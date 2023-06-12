# -*- coding: utf-8 -*-

#     Copyright 2020-2022 Jean-Pierre LEDURE, Rafael LIMA, Alain ROMEDENNE

# =====================================================================================================================
# ===           The ScriptForge library and its associated libraries are part of the LibreOffice project.           ===
# ===                   Full documentation is available on https://help.libreoffice.org/                            ===
# =====================================================================================================================

# ScriptForge is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# ScriptForge is free software; you can redistribute it and/or modify it under the terms of either (at your option):

# 1) The Mozilla Public License, v. 2.0. If a copy of the MPL was not
# distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0/ .

# 2) The GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version. If a copy of the LGPL was not
# distributed with this file, see http://www.gnu.org/licenses/ .

"""
    ScriptForge libraries are an extensible and robust collection of macro scripting resources for LibreOffice
    to be invoked from user Basic or Python macros. Users familiar with other BASIC macro variants often face hard
    times to dig into the extensive LibreOffice Application Programming Interface even for the simplest operations.
    By collecting most-demanded document operations in a set of easy to use, easy to read routines, users can now
    program document macros with much less hassle and get quicker results.

    ScriptForge abundant methods are organized in reusable modules that cleanly isolate Basic/Python programming
    language constructs from ODF document content accesses and user interface(UI) features.

    The scriptforge.py module
        - implements a protocol between Python (user) scripts and the ScriptForge Basic library
        - contains the interfaces (classes and attributes) to be used in Python user scripts
          to run the services implemented in the standard libraries shipped with LibreOffice

    Usage:

        When Python and LibreOffice run in the same process (usual case): either
            from scriptforge import *   # or, better ...
            from scriptforge import CreateScriptService

        When Python and LibreOffice are started in separate processes,
        LibreOffice being started from console ... (example for Linux with port = 2021)
            ./soffice --accept='socket,host=localhost,port=2021;urp;'
        then use next statement:
            from scriptforge import *   # or, better ...
            from scriptforge import CreateScriptService, ScriptForge
            ScriptForge(hostname = 'localhost', port = 2021)

    Specific documentation about the use of ScriptForge from Python scripts:
        https://help.libreoffice.org/latest/en-US/text/sbasic/shared/03/sf_intro.html?DbPAR=BASIC
    """

import uno

import datetime
import time
import os


class _Singleton(type):
    """
        A Singleton metaclass design pattern
        Credits: « Python in a Nutshell » by Alex Martelli, O'Reilly
        """
    instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls.instances:
            cls.instances[cls] = super(_Singleton, cls).__call__(*args, **kwargs)
        return cls.instances[cls]


# #####################################################################################################################
#                           ScriptForge CLASS                                                                       ###
# #####################################################################################################################

class ScriptForge(object, metaclass = _Singleton):
    """
        The ScriptForge (singleton) class encapsulates the core of the ScriptForge run-time
            - Bridge with the LibreOffice process
            - Implementation of the inter-language protocol with the Basic libraries
            - Identification of the available services interfaces
            - Dispatching of services
            - Coexistence with UNO

        It embeds the Service class that manages the protocol with Basic
        """

    # #########################################################################
    # Class attributes
    # #########################################################################
    hostname = ''
    port = 0
    componentcontext = None
    scriptprovider = None
    SCRIPTFORGEINITDONE = False

    # #########################################################################
    # Class constants
    # #########################################################################
    library = 'ScriptForge'
    Version = '7.4'  # Actual version number
    #
    # Basic dispatcher for Python scripts
    basicdispatcher = '@application#ScriptForge.SF_PythonHelper._PythonDispatcher'
    # Python helper functions module
    pythonhelpermodule = 'ScriptForgeHelper.py'
    #
    # VarType() constants
    V_EMPTY, V_NULL, V_INTEGER, V_LONG, V_SINGLE, V_DOUBLE = 0, 1, 2, 3, 4, 5
    V_CURRENCY, V_DATE, V_STRING, V_OBJECT, V_BOOLEAN = 6, 7, 8, 9, 11
    V_VARIANT, V_ARRAY, V_ERROR, V_UNO = 12, 8192, -1, 16
    # Object types
    objMODULE, objCLASS, objUNO = 1, 2, 3
    # Special argument symbols
    cstSymEmpty, cstSymNull, cstSymMissing = '+++EMPTY+++', '+++NULL+++', '+++MISSING+++'
    # Predefined references for services implemented as standard Basic modules
    servicesmodules = dict([('ScriptForge.Array', 0),
                            ('ScriptForge.Exception', 1),
                            ('ScriptForge.FileSystem', 2),
                            ('ScriptForge.Platform', 3),
                            ('ScriptForge.Region', 4),
                            ('ScriptForge.Services', 5),
                            ('ScriptForge.Session', 6),
                            ('ScriptForge.String', 7),
                            ('ScriptForge.UI', 8)])

    def __init__(self, hostname = '', port = 0):
        """
            Because singleton, constructor is executed only once while Python active
            Arguments are mandatory when Python and LibreOffice run in separate processes
            :param hostname: probably 'localhost'
            :param port: port number
            """
        ScriptForge.hostname = hostname
        ScriptForge.port = port
        # Determine main pyuno entry points
        ScriptForge.componentcontext = self.ConnectToLOProcess(hostname, port)  # com.sun.star.uno.XComponentContext
        ScriptForge.scriptprovider = self.ScriptProvider(self.componentcontext)  # ...script.provider.XScriptProvider
        #
        # Establish a list of the available services as a dictionary (servicename, serviceclass)
        ScriptForge.serviceslist = dict((cls.servicename, cls) for cls in SFServices.__subclasses__())
        ScriptForge.servicesdispatcher = None
        #
        # All properties and methods of the ScriptForge API are ProperCased
        # Compute their synonyms as lowercased and camelCased names
        ScriptForge.SetAttributeSynonyms()
        #
        ScriptForge.SCRIPTFORGEINITDONE = True

    @classmethod
    def ConnectToLOProcess(cls, hostname = '', port = 0):
        """
            Called by the ScriptForge class constructor to establish the connection with
            the requested LibreOffice instance
            The default arguments are for the usual interactive mode

            :param hostname: probably 'localhost' or ''
            :param port: port number or 0
            :return: the derived component context
            """
        if len(hostname) > 0 and port > 0:  # Explicit connection request via socket
            ctx = uno.getComponentContext()  # com.sun.star.uno.XComponentContext
            resolver = ctx.ServiceManager.createInstanceWithContext(
                'com.sun.star.bridge.UnoUrlResolver', ctx)  # com.sun.star.comp.bridge.UnoUrlResolver
            try:
                conn = 'socket,host=%s,port=%d' % (hostname, port)
                url = 'uno:%s;urp;StarOffice.ComponentContext' % conn
                ctx = resolver.resolve(url)
            except Exception:  # thrown when LibreOffice specified instance isn't started
                raise SystemExit(
                    'Connection to LibreOffice failed (host = ' + hostname + ', port = ' + str(port) + ')')
            return ctx
        elif len(hostname) == 0 and port == 0:  # Usual interactive mode
            return uno.getComponentContext()
        else:
            raise SystemExit('The creation of the ScriptForge() instance got invalid arguments: '
                             + '(host = ' + hostname + ', port = ' + str(port) + ')')

    @classmethod
    def ScriptProvider(cls, context = None):
        """
            Returns the general script provider
            """
        servicemanager = context.ServiceManager  # com.sun.star.lang.XMultiComponentFactory
        masterscript = servicemanager.createInstanceWithContext(
            'com.sun.star.script.provider.MasterScriptProviderFactory', context)
        return masterscript.createScriptProvider("")

    @classmethod
    def InvokeSimpleScript(cls, script, *args):
        """
            Create a UNO object corresponding with the given Python or Basic script
            The execution is done with the invoke() method applied on the created object
            Implicit scope: Either
                "application"            a shared library                               (BASIC)
                "share"                  a library of LibreOffice Macros                (PYTHON)
            :param script: Either
                    [@][scope#][library.]module.method - Must not be a class module or method
                        [@] means that the targeted method accepts ParamArray arguments (Basic only)
                    [scope#][directory/]module.py$method - Must be a method defined at module level
            :return: the value returned by the invoked script, or an error if the script was not found
            """

        # The frequently called PythonDispatcher in the ScriptForge Basic library is cached to privilege performance
        if cls.servicesdispatcher is not None and script == ScriptForge.basicdispatcher:
            xscript = cls.servicesdispatcher
            fullscript = script
            paramarray = True
        #    Build the URI specification described in
        #    https://wiki.documentfoundation.org/Documentation/DevGuide/Scripting_Framework#Scripting_Framework_URI_Specification
        elif len(script) > 0:
            # Check ParamArray arguments
            paramarray = False
            if script[0] == '@':
                script = script[1:]
                paramarray = True
            scope = ''
            if '#' in script:
                scope, script = script.split('#')
            if '.py$' in script.lower():  # Python
                if len(scope) == 0:
                    scope = 'share'  # Default for Python
                # Provide an alternate helper script depending on test context
                if script.startswith(cls.pythonhelpermodule) and hasattr(cls, 'pythonhelpermodule2'):
                    script = cls.pythonhelpermodule2 + script[len(cls.pythonhelpermodule):]
                    if '#' in script:
                        scope, script = script.split('#')
                uri = 'vnd.sun.star.script:{0}?language=Python&location={1}'.format(script, scope)
            else:  # Basic
                if len(scope) == 0:
                    scope = 'application'  # Default for Basic
                lib = ''
                if len(script.split('.')) < 3:
                    lib = cls.library + '.'  # Default library = ScriptForge
                uri = 'vnd.sun.star.script:{0}{1}?language=Basic&location={2}'.format(lib, script, scope)
            # Get the script object
            fullscript = ('@' if paramarray else '') + scope + ':' + script
            try:
                xscript = cls.scriptprovider.getScript(uri)
            except Exception:
                raise RuntimeError(
                    'The script \'{0}\' could not be located in your LibreOffice installation'.format(script))
        else:  # Should not happen
            return None

        # At 1st execution of the common Basic dispatcher, buffer xscript
        if fullscript == ScriptForge.basicdispatcher and cls.servicesdispatcher is None:
            cls.servicesdispatcher = xscript

        # Execute the script with the given arguments
        # Packaging for script provider depends on presence of ParamArray arguments in the called Basic script
        if paramarray:
            scriptreturn = xscript.invoke(args[0], (), ())
        else:
            scriptreturn = xscript.invoke(args, (), ())

        #
        return scriptreturn[0]  # Updatable arguments passed by reference are ignored

    @classmethod
    def InvokeBasicService(cls, basicobject, flags, method, *args):
        """
            Execute a given Basic script and interpret its result
            This method has as counterpart the ScriptForge.SF_PythonHelper._PythonDispatcher() Basic method
            :param basicobject: a Service subclass
            :param flags: see the vb* and flg* constants in the SFServices class
            :param method: the name of the method or property to invoke, as a string
            :param args: the arguments of the method. Symbolic cst* constants may be necessary
            :return: The invoked Basic counterpart script (with InvokeSimpleScript()) will return a tuple
                [0]     The returned value - scalar, object reference or a tuple
                [1]     The Basic VarType() of the returned value
                        Null, Empty and Nothing have different vartypes but return all None to Python
                Additionally, when [0] is a tuple:
                [2]     Number of dimensions in Basic
                Additionally, when [0] is a UNO or Basic object:
                [2]     Module (1), Class instance (2) or UNO (3)
                [3]     The object's ObjectType
                [4]     The object's ServiceName
                [5]     The object's name
                When an error occurs Python receives None as a scalar. This determines the occurrence of a failure
                The method returns either
                    - the 0th element of the tuple when scalar, tuple or UNO object
                    - a new Service() object or one of its subclasses otherwise
            """
        # Constants
        script = ScriptForge.basicdispatcher
        cstNoArgs = '+++NOARGS+++'
        cstValue, cstVarType, cstDims, cstClass, cstType, cstService, cstName = 0, 1, 2, 2, 3, 4, 5

        #
        # Run the basic script
        # The targeted script has a ParamArray argument. Do not change next 4 lines except if you know what you do !
        if len(args) == 0:
            args = (basicobject,) + (flags,) + (method,) + (cstNoArgs,)
        else:
            args = (basicobject,) + (flags,) + (method,) + args
        returntuple = cls.InvokeSimpleScript(script, args)
        #
        # Interpret the result
        # Did an error occur in the Basic world ?
        if not isinstance(returntuple, (tuple, list)):
            raise RuntimeError("The execution of the method '" + method + "' failed. Execution stops.")
        #
        # Analyze the returned tuple
        if returntuple[cstVarType] == ScriptForge.V_OBJECT and len(returntuple) > cstClass:  # Avoid Nothing
            if returntuple[cstClass] == ScriptForge.objUNO:
                pass
            else:
                # Create the new class instance of the right subclass of SFServices()
                servname = returntuple[cstService]
                if servname not in cls.serviceslist:
                    # When service not found
                    raise RuntimeError("The service '" + servname + "' is not available in Python. Execution stops.")
                subcls = cls.serviceslist[servname]
                if subcls is not None:
                    return subcls(returntuple[cstValue], returntuple[cstType], returntuple[cstClass],
                                  returntuple[cstName])
        elif returntuple[cstVarType] >= ScriptForge.V_ARRAY:
            # Intercept empty array
            if isinstance(returntuple[cstValue], uno.ByteSequence):
                return ()
        elif returntuple[cstVarType] == ScriptForge.V_DATE:
            dat = SFScriptForge.SF_Basic.CDateFromUnoDateTime(returntuple[cstValue])
            return dat
        else:  # All other scalar values
            pass
        return returntuple[cstValue]

    @staticmethod
    def SetAttributeSynonyms():
        """
            A synonym of an attribute is either the lowercase or the camelCase form of its original ProperCase name.
            In every subclass of SFServices:
            1) Fill the propertysynonyms dictionary with the synonyms of the properties listed in serviceproperties
                Example:
                     serviceproperties = dict(ConfigFolder = False, InstallFolder = False)
                     propertysynonyms = dict(configfolder = 'ConfigFolder', installfolder = 'InstallFolder',
                                             configFolder = 'ConfigFolder', installFolder = 'InstallFolder')
            2) Define new method attributes synonyms of the original methods
                Example:
                    def CopyFile(...):
                        # etc ...
                    copyFile, copyfile = CopyFile, CopyFile
            """

        def camelCase(key):
            return key[0].lower() + key[1:]

        for cls in SFServices.__subclasses__():
            # Synonyms of properties
            if hasattr(cls, 'serviceproperties'):
                dico = cls.serviceproperties
                dicosyn = dict(zip(map(str.lower, dico.keys()), dico.keys()))  # lower case
                cc = dict(zip(map(camelCase, dico.keys()), dico.keys()))  # camel Case
                dicosyn.update(cc)
                setattr(cls, 'propertysynonyms', dicosyn)
            # Synonyms of methods. A method is a public callable attribute
            methods = [method for method in dir(cls) if not method.startswith('_')]
            for method in methods:
                func = getattr(cls, method)
                if callable(func):
                    # Assign to each synonym a reference to the original method
                    lc = method.lower()
                    setattr(cls, lc, func)
                    cc = camelCase(method)
                    if cc != lc:
                        setattr(cls, cc, func)
        return

    @staticmethod
    def unpack_args(kwargs):
        """
            Convert a dictionary passed as argument to a list alternating keys and values
            Example:
                dict(A = 'a', B = 2) => 'A', 'a', 'B', 2
            """
        return [v for p in zip(list(kwargs.keys()), list(kwargs.values())) for v in p]


# #####################################################################################################################
#                           SFServices CLASS    (ScriptForge services superclass)                                   ###
# #####################################################################################################################

class SFServices(object):
    """
        Generic implementation of a parent Service class
        Every service must subclass this class to be recognized as a valid service
        A service instance is created by the CreateScriptService method
        It can have a mirror in the Basic world or be totally defined in Python

        Every subclass must initialize 3 class properties:
            servicename (e.g. 'ScriptForge.FileSystem', 'ScriptForge.Basic')
            servicesynonyms (e.g. 'FileSystem', 'Basic')
            serviceimplementation: either 'python' or 'basic'
        This is sufficient to register the service in the Python world

        The communication with Basic is managed by 2 ScriptForge() methods:
            InvokeSimpleScript(): low level invocation of a Basic script. This script must be located
                in a usual Basic module. The result is passed as-is
            InvokeBasicService(): the result comes back encapsulated with additional info
                The result is interpreted in the method
                The invoked script can be a property or a method of a Basic class or usual module
        It is up to every service method to determine which method to use

        For Basic services only:
            Each instance is identified by its
                - object reference: the real Basic object embedded as a UNO wrapper object
                - object type ('SF_String', 'DICTIONARY', ...)
                - class module: 1 for usual modules, 2 for class modules
                - name (form, control, ... name) - may be blank

            The role of the SFServices() superclass is mainly to propose a generic properties management
            Properties are got and set following next strategy:
                1. Property names are controlled strictly ('Value' or 'value', not 'VALUE')
                2. Getting a property value for the first time is always done via a Basic call
                3. Next occurrences are fetched from the Python dictionary of the instance if the property
                   is read-only, otherwise via a Basic call
                4. Read-only properties may be modified or deleted exceptionally by the class
                   when self.internal == True. The latter must immediately be reset after use

            Each subclass must define its interface with the user scripts:
            1.  The properties
                Property names are proper-cased
                Conventionally, camel-cased and lower-cased synonyms are supported where relevant
                    a dictionary named 'serviceproperties' with keys = (proper-cased) property names and value = boolean
                        True = editable, False = read-only
                    a list named 'localProperties' reserved to properties for internal use
                        e.g. oDlg.Controls() is a method that uses '_Controls' to hold the list of available controls
                When
                    forceGetProperty = False    # Standard behaviour
                read-only serviceproperties are buffered in Python after their 1st get request to Basic
                Otherwise set it to True to force a recomputation at each property getter invocation
                If there is a need to handle a specific property in a specific manner:
                    @property
                    def myProperty(self):
                        return self.GetProperty('myProperty')
            2   The methods
                a usual def: statement
                    def myMethod(self, arg1, arg2 = ''):
                        return self.Execute(self.vbMethod, 'myMethod', arg1, arg2)
                Method names are proper-cased, arguments are lower-cased
                Conventionally, camel-cased and lower-cased homonyms are supported where relevant
                All arguments must be present and initialized before the call to Basic, if any
        """
    # Python-Basic protocol constants and flags
    vbGet, vbLet, vbMethod, vbSet = 2, 4, 1, 8  # CallByName constants
    flgPost = 32  # The method or the property implies a hardcoded post-processing
    flgDateArg = 64  # Invoked service method may contain a date argument
    flgDateRet = 128  # Invoked service method can return a date
    flgArrayArg = 512  # 1st argument can be a 2D array
    flgArrayRet = 1024  # Invoked service method can return a 2D array (standard modules) or any array (class modules)
    flgUno = 256  # Invoked service method/property can return a UNO object
    flgObject = 2048  # 1st argument may be a Basic object
    flgHardCode = 4096  # Force hardcoded call to method, avoid CallByName()
    # Basic class type
    moduleClass, moduleStandard = 2, 1
    #
    # Define the default behaviour for read-only properties: buffer their values in Python
    forceGetProperty = False
    # Empty dictionary for lower/camelcased homonyms or properties
    propertysynonyms = {}
    # To operate dynamic property getting/setting it is necessary to
    # enumerate all types of properties and adapt __getattr__() and __setattr__() according to their type
    internal_attributes = ('objectreference', 'objecttype', 'name', 'internal', 'servicename',
                           'serviceimplementation', 'classmodule', 'EXEC', 'SIMPLEEXEC')
    # Shortcuts to script provider interfaces
    SIMPLEEXEC = ScriptForge.InvokeSimpleScript
    EXEC = ScriptForge.InvokeBasicService

    def __init__(self, reference = -1, objtype = None, classmodule = 0, name = ''):
        """
            Trivial initialization of internal properties
            If the subclass has its own __init()__ method, a call to this one should be its first statement.
            Afterwards localProperties should be filled with the list of its own properties
            """
        self.objectreference = reference  # the index in the Python storage where the Basic object is stored
        self.objecttype = objtype  # ('SF_String', 'DICTIONARY', ...)
        self.classmodule = classmodule  # Module (1), Class instance (2)
        self.name = name  # '' when no name
        self.internal = False  # True to exceptionally allow assigning a new value to a read-only property
        self.localProperties = []  # the properties reserved for internal use (often empty)

    def __getattr__(self, name):
        """
            Executed for EVERY property reference if name not yet in the instance dict
            At the 1st get, the property value is always got from Basic
            Due to the use of lower/camelcase synonyms, it is called for each variant of the same property
            The method manages itself the buffering in __dict__ based on the official ProperCase property name
            """
        if name in self.propertysynonyms:  # Reset real name if argument provided in lower or camel case
            name = self.propertysynonyms[name]
        if self.serviceimplementation == 'basic':
            if name in ('serviceproperties', 'localProperties', 'internal_attributes', 'propertysynonyms',
                        'forceGetProperty'):
                pass
            elif name in self.serviceproperties:
                if self.forceGetProperty is False and self.serviceproperties[name] is False:  # False = read-only
                    if name in self.__dict__:
                        return self.__dict__[name]
                    else:
                        # Get Property from Basic and store it
                        prop = self.GetProperty(name)
                        self.__dict__[name] = prop
                        return prop
                else:  # Get Property from Basic and do not store it
                    return self.GetProperty(name)
        # Execute the usual attributes getter
        return super(SFServices, self).__getattribute__(name)

    def __setattr__(self, name, value):
        """
            Executed for EVERY property assignment, including in __init__() !!
            Setting a property requires for serviceproperties() to be executed in Basic
            Management of __dict__ is automatically done in the final usual object.__setattr__ method
            """
        if self.serviceimplementation == 'basic':
            if name in ('serviceproperties', 'localProperties', 'internal_attributes', 'propertysynonyms',
                        'forceGetProperty'):
                pass
            elif name[0:2] == '__' or name in self.internal_attributes or name in self.localProperties:
                pass
            elif name in self.serviceproperties or name in self.propertysynonyms:
                if name in self.propertysynonyms:  # Reset real name if argument provided in lower or camel case
                    name = self.propertysynonyms[name]
                if self.internal:  # internal = True forces property local setting even if property is read-only
                    pass
                elif self.serviceproperties[name] is True:  # True == Editable
                    self.SetProperty(name, value)
                    return
                else:
                    raise AttributeError(
                        "type object '" + self.objecttype + "' has no editable property '" + name + "'")
            else:
                raise AttributeError("type object '" + self.objecttype + "' has no property '" + name + "'")
        object.__setattr__(self, name, value)
        return

    def __repr__(self):
        return self.serviceimplementation + '/' + self.servicename + '/' + str(self.objectreference) + '/' + \
               super(SFServices, self).__repr__()

    def Dispose(self):
        if self.serviceimplementation == 'basic':
            if self.objectreference >= len(ScriptForge.servicesmodules):  # Do not dispose predefined module objects
                self.ExecMethod(self.vbMethod, 'Dispose')
                self.objectreference = -1

    def ExecMethod(self, flags = 0, methodname = '', *args):
        if flags == 0:
            flags = self.vbMethod
        if len(methodname) > 0:
            return self.EXEC(self.objectreference, flags, methodname, *args)

    def GetProperty(self, propertyname, arg = None):
        """
            Get the given property from the Basic world
            """
        if self.serviceimplementation == 'basic':
            # Conventionally properties starting with X (and only them) may return a UNO object
            calltype = self.vbGet + (self.flgUno if propertyname[0] == 'X' else 0)
            if arg is None:
                return self.EXEC(self.objectreference, calltype, propertyname)
            else:  # There are a few cases (Calc ...) where GetProperty accepts an argument
                return self.EXEC(self.objectreference, calltype, propertyname, arg)
        return None

    def Properties(self):
        return list(self.serviceproperties)

    def basicmethods(self):
        if self.serviceimplementation == 'basic':
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'Methods')
        else:
            return []

    def basicproperties(self):
        if self.serviceimplementation == 'basic':
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'Properties')
        else:
            return []

    def SetProperty(self, propertyname, value):
        """
            Set the given property to a new value in the Basic world
            """
        if self.serviceimplementation == 'basic':
            flag = self.vbLet
            if isinstance(value, datetime.datetime):
                value = SFScriptForge.SF_Basic.CDateToUnoDateTime(value)
                flag += self.flgDateArg
            if repr(type(value)) == "<class 'pyuno'>":
                flag += self.flgUno
            return self.EXEC(self.objectreference, flag, propertyname, value)


# #####################################################################################################################
#                       SFScriptForge CLASS    (alias of ScriptForge Basic library)                                 ###
# #####################################################################################################################
class SFScriptForge:
    pass

    # #########################################################################
    # SF_Array CLASS
    # #########################################################################
    class SF_Array(SFServices, metaclass = _Singleton):
        """
            Provides a collection of methods for manipulating and transforming arrays of one dimension (vectors)
            and arrays of two dimensions (matrices). This includes set operations, sorting,
            importing to and exporting from text files.
            The Python version of the service provides a single method: ImportFromCSVFile
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'ScriptForge.Array'
        servicesynonyms = ('array', 'scriptforge.array')
        serviceproperties = dict()

        def ImportFromCSVFile(self, filename, delimiter = ',', dateformat = ''):
            """
                Difference with the Basic version: dates are returned in their iso format,
                not as any of the datetime objects.
                """
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'ImportFromCSVFile',
                                   filename, delimiter, dateformat)

    # #########################################################################
    # SF_Basic CLASS
    # #########################################################################
    class SF_Basic(SFServices, metaclass = _Singleton):
        """
            This service proposes a collection of Basic methods to be executed in a Python context
            simulating the exact syntax and behaviour of the identical Basic builtin method.
            Typical example:
                SF_Basic.MsgBox('This has to be displayed in a message box')

            The signatures of Basic builtin functions are derived from
                core/basic/source/runtime/stdobj.cxx

            Detailed user documentation:
                https://help.libreoffice.org/latest/en-US/text/sbasic/shared/03/sf_basic.html?DbPAR=BASIC
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'python'
        servicename = 'ScriptForge.Basic'
        servicesynonyms = ('basic', 'scriptforge.basic')
        # Basic helper functions invocation
        module = 'SF_PythonHelper'
        # Message box constants
        MB_ABORTRETRYIGNORE, MB_DEFBUTTON1, MB_DEFBUTTON2, MB_DEFBUTTON3 = 2, 128, 256, 512
        MB_ICONEXCLAMATION, MB_ICONINFORMATION, MB_ICONQUESTION, MB_ICONSTOP = 48, 64, 32, 16
        MB_OK, MB_OKCANCEL, MB_RETRYCANCEL, MB_YESNO, MB_YESNOCANCEL = 0, 1, 5, 4, 3
        IDABORT, IDCANCEL, IDIGNORE, IDNO, IDOK, IDRETRY, IDYES = 3, 2, 5, 7, 1, 4, 6

        @classmethod
        def CDate(cls, datevalue):
            cdate = cls.SIMPLEEXEC(cls.module + '.PyCDate', datevalue)
            return cls.CDateFromUnoDateTime(cdate)

        @staticmethod
        def CDateFromUnoDateTime(unodate):
            """
                Converts a UNO date/time representation to a datetime.datetime Python native object
                :param unodate: com.sun.star.util.DateTime, com.sun.star.util.Date or com.sun.star.util.Time
                :return: the equivalent datetime.datetime
                """
            date = datetime.datetime(1899, 12, 30, 0, 0, 0, 0)  # Idem as Basic builtin TimeSeria() function
            datetype = repr(type(unodate))
            if 'com.sun.star.util.DateTime' in datetype:
                if 1900 <= unodate.Year <= datetime.MAXYEAR:
                    date = datetime.datetime(unodate.Year, unodate.Month, unodate.Day, unodate.Hours,
                                             unodate.Minutes, unodate.Seconds, int(unodate.NanoSeconds / 1000))
            elif 'com.sun.star.util.Date' in datetype:
                if 1900 <= unodate.Year <= datetime.MAXYEAR:
                    date = datetime.datetime(unodate.Year, unodate.Month, unodate.Day)
            elif 'com.sun.star.util.Time' in datetype:
                date = datetime.datetime(unodate.Hours, unodate.Minutes, unodate.Seconds,
                                         int(unodate.NanoSeconds / 1000))
            else:
                return unodate  # Not recognized as a UNO date structure
            return date

        @staticmethod
        def CDateToUnoDateTime(date):
            """
                Converts a date representation into the ccom.sun.star.util.DateTime date format
                Acceptable boundaries: year >= 1900 and <= 32767
                :param date: datetime.datetime, datetime.date, datetime.time, float (time.time) or time.struct_time
                :return: a com.sun.star.util.DateTime
                """
            unodate = uno.createUnoStruct('com.sun.star.util.DateTime')
            unodate.Year, unodate.Month, unodate.Day, unodate.Hours, unodate.Minutes, unodate.Seconds, \
            unodate.NanoSeconds, unodate.IsUTC = \
                1899, 12, 30, 0, 0, 0, 0, False  # Identical to Basic TimeSerial() function

            if isinstance(date, float):
                date = time.localtime(date)
            if isinstance(date, time.struct_time):
                if 1900 <= date[0] <= 32767:
                    unodate.Year, unodate.Month, unodate.Day, unodate.Hours, unodate.Minutes, unodate.Seconds = \
                        date[0:6]
                else:  # Copy only the time related part
                    unodate.Hours, unodate.Minutes, unodate.Seconds = date[3:3]
            elif isinstance(date, (datetime.datetime, datetime.date, datetime.time)):
                if isinstance(date, (datetime.datetime, datetime.date)):
                    if 1900 <= date.year <= 32767:
                        unodate.Year, unodate.Month, unodate.Day = date.year, date.month, date.day
                if isinstance(date, (datetime.datetime, datetime.time)):
                    unodate.Hours, unodate.Minutes, unodate.Seconds, unodate.NanoSeconds = \
                        date.hour, date.minute, date.second, date.microsecond * 1000
            else:
                return date  # Not recognized as a date
            return unodate

        @classmethod
        def ConvertFromUrl(cls, url):
            return cls.SIMPLEEXEC(cls.module + '.PyConvertFromUrl', url)

        @classmethod
        def ConvertToUrl(cls, systempath):
            return cls.SIMPLEEXEC(cls.module + '.PyConvertToUrl', systempath)

        @classmethod
        def CreateUnoService(cls, servicename):
            return cls.SIMPLEEXEC(cls.module + '.PyCreateUnoService', servicename)

        @classmethod
        def CreateUnoStruct(cls, unostructure):
            return uno.createUnoStruct(unostructure)

        @classmethod
        def DateAdd(cls, interval, number, date):
            if isinstance(date, datetime.datetime):
                date = cls.CDateToUnoDateTime(date)
            dateadd = cls.SIMPLEEXEC(cls.module + '.PyDateAdd', interval, number, date)
            return cls.CDateFromUnoDateTime(dateadd)

        @classmethod
        def DateDiff(cls, interval, date1, date2, firstdayofweek = 1, firstweekofyear = 1):
            if isinstance(date1, datetime.datetime):
                date1 = cls.CDateToUnoDateTime(date1)
            if isinstance(date2, datetime.datetime):
                date2 = cls.CDateToUnoDateTime(date2)
            return cls.SIMPLEEXEC(cls.module + '.PyDateDiff', interval, date1, date2, firstdayofweek, firstweekofyear)

        @classmethod
        def DatePart(cls, interval, date, firstdayofweek = 1, firstweekofyear = 1):
            if isinstance(date, datetime.datetime):
                date = cls.CDateToUnoDateTime(date)
            return cls.SIMPLEEXEC(cls.module + '.PyDatePart', interval, date, firstdayofweek, firstweekofyear)

        @classmethod
        def DateValue(cls, string):
            if isinstance(string, datetime.datetime):
                string = string.isoformat()
            datevalue = cls.SIMPLEEXEC(cls.module + '.PyDateValue', string)
            return cls.CDateFromUnoDateTime(datevalue)

        @classmethod
        def Format(cls, expression, format = ''):
            if isinstance(expression, datetime.datetime):
                expression = cls.CDateToUnoDateTime(expression)
            return cls.SIMPLEEXEC(cls.module + '.PyFormat', expression, format)

        @classmethod
        def GetDefaultContext(cls):
            return ScriptForge.componentcontext

        @classmethod
        def GetGuiType(cls):
            return cls.SIMPLEEXEC(cls.module + '.PyGetGuiType')

        @classmethod
        def GetPathSeparator(cls):
            return os.sep

        @classmethod
        def GetSystemTicks(cls):
            return cls.SIMPLEEXEC(cls.module + '.PyGetSystemTicks')

        class GlobalScope(object, metaclass = _Singleton):
            @classmethod  # Mandatory because the GlobalScope class is normally not instantiated
            def BasicLibraries(cls):
                return ScriptForge.InvokeSimpleScript(SFScriptForge.SF_Basic.module + '.PyGlobalScope', 'Basic')

            @classmethod
            def DialogLibraries(cls):
                return ScriptForge.InvokeSimpleScript(SFScriptForge.SF_Basic.module + '.PyGlobalScope', 'Dialog')

        @classmethod
        def InputBox(cls, prompt, title = '', default = '', xpostwips = -1, ypostwips = -1):
            if xpostwips < 0 or ypostwips < 0:
                return cls.SIMPLEEXEC(cls.module + '.PyInputBox', prompt, title, default)
            return cls.SIMPLEEXEC(cls.module + '.PyInputBox', prompt, title, default, xpostwips, ypostwips)

        @classmethod
        def MsgBox(cls, prompt, buttons = 0, title = ''):
            return cls.SIMPLEEXEC(cls.module + '.PyMsgBox', prompt, buttons, title)

        @classmethod
        def Now(cls):
            return datetime.datetime.now()

        @classmethod
        def RGB(cls, red, green, blue):
            return int('%02x%02x%02x' % (red, green, blue), 16)

        @property
        def StarDesktop(self):
            ctx = ScriptForge.componentcontext
            if ctx is None:
                return None
            smgr = ctx.getServiceManager()  # com.sun.star.lang.XMultiComponentFactory
            DESK = 'com.sun.star.frame.Desktop'
            desktop = smgr.createInstanceWithContext(DESK, ctx)
            return desktop

        starDesktop, stardesktop = StarDesktop, StarDesktop

        @property
        def ThisComponent(self):
            """
                When the current component is the Basic IDE, the ThisComponent object returns
                in Basic the component owning the currently run user script.
                Above behaviour cannot be reproduced in Python.
                :return: the current component or None when not a document
                """
            comp = self.StarDesktop.getCurrentComponent()
            if comp is None:
                return None
            impl = comp.ImplementationName
            if impl in ('com.sun.star.comp.basic.BasicIDE', 'com.sun.star.comp.sfx2.BackingComp'):
                return None  # None when Basic IDE or welcome screen
            return comp

        thisComponent, thiscomponent = ThisComponent, ThisComponent

        @property
        def ThisDatabaseDocument(self):
            """
                When the current component is the Basic IDE, the ThisDatabaseDocument object returns
                in Basic the database owning the currently run user script.
                Above behaviour cannot be reproduced in Python.
                :return: the current Base (main) component or None when not a Base document or one of its subcomponents
            """
            comp = self.ThisComponent  # Get the current component
            if comp is None:
                return None
            #
            sess = CreateScriptService('Session')
            impl, ident = '', ''
            if sess.HasUnoProperty(comp, 'ImplementationName'):
                impl = comp.ImplementationName
            if sess.HasUnoProperty(comp, 'Identifier'):
                ident = comp.Identifier
            #
            targetimpl = 'com.sun.star.comp.dba.ODatabaseDocument'
            if impl == targetimpl:  # The current component is the main Base window
                return comp
            # Identify resp. form, table/query, table/query in edit mode, report, relations diagram
            if impl == 'SwXTextDocument' and ident == 'com.sun.star.sdb.FormDesign' \
                    or impl == 'org.openoffice.comp.dbu.ODatasourceBrowser' \
                    or impl in ('org.openoffice.comp.dbu.OTableDesign', 'org.openoffice.comp.dbu.OQuertDesign') \
                    or impl == 'SwXTextDocument' and ident == 'com.sun.star.sdb.TextReportDesign' \
                    or impl == 'org.openoffice.comp.dbu.ORelationDesign':
                db = comp.ScriptContainer
                if sess.HasUnoProperty(db, 'ImplementationName'):
                    if db.ImplementationName == targetimpl:
                        return db
            return None

        thisDatabaseDocument, thisdatabasedocument = ThisDatabaseDocument, ThisDatabaseDocument

        @classmethod
        def Xray(cls, unoobject = None):
            return cls.SIMPLEEXEC('XrayTool._main.xray', unoobject)

    # #########################################################################
    # SF_Dictionary CLASS
    # #########################################################################
    class SF_Dictionary(SFServices, dict):
        """
            The service adds to a Python dict instance the interfaces for conversion to and from
            a list of UNO PropertyValues

            Usage:
                dico = dict(A = 1, B = 2, C = 3)
                myDict = CreateScriptService('Dictionary', dico)    # Initialize myDict with the content of dico
                myDict['D'] = 4
                print(myDict)   # {'A': 1, 'B': 2, 'C': 3, 'D': 4}
                propval = myDict.ConvertToPropertyValues()
            or
                dico = dict(A = 1, B = 2, C = 3)
                myDict = CreateScriptService('Dictionary')          # Initialize myDict as an empty dict object
                myDict.update(dico) # Load the values of dico into myDict
                myDict['D'] = 4
                print(myDict)   # {'A': 1, 'B': 2, 'C': 3, 'D': 4}
                propval = myDict.ConvertToPropertyValues()
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'python'
        servicename = 'ScriptForge.Dictionary'
        servicesynonyms = ('dictionary', 'scriptforge.dictionary')

        def __init__(self, dic = None):
            SFServices.__init__(self)
            dict.__init__(self)
            if dic is not None:
                self.update(dic)

        def ConvertToPropertyValues(self):
            """
                Store the content of the dictionary in an array of PropertyValues.
                Each entry in the array is a com.sun.star.beans.PropertyValue.
                he key is stored in Name, the value is stored in Value.

                If one of the items has a type datetime, it is converted to a com.sun.star.util.DateTime structure.
                If one of the items is an empty list, it is converted to None.

                The resulting array is empty when the dictionary is empty.
                """
            result = []
            for key in iter(self):
                value = self[key]
                item = value
                if isinstance(value, dict):  # check that first level is not itself a (sub)dict
                    item = None
                elif isinstance(value, (tuple, list)):  # check every member of the list is not a (sub)dict
                    if len(value) == 0:  # Property values do not like empty lists
                        value = None
                    else:
                        for i in range(len(value)):
                            if isinstance(value[i], dict):
                                value[i] = None
                    item = value
                elif isinstance(value, (datetime.datetime, datetime.date, datetime.time)):
                    item = SFScriptForge.SF_Basic.CDateToUnoDateTime(value)
                pv = uno.createUnoStruct('com.sun.star.beans.PropertyValue')
                pv.Name = key
                pv.Value = item
                result.append(pv)
            return result

        def ImportFromPropertyValues(self, propertyvalues, overwrite = False):
            """
                Inserts the contents of an array of PropertyValue objects into the current dictionary.
                PropertyValue Names are used as keys in the dictionary, whereas Values contain the corresponding values.
                Date-type values are converted to datetime.datetime instances.
                :param propertyvalues: a list.tuple containing com.sun.star.beans.PropertyValue objects
                :param overwrite: When True, entries with same name may exist in the dictionary and their values
                    are overwritten. When False (default), repeated keys are not overwritten.
                :return: True when successful
                """
            result = []
            for pv in iter(propertyvalues):
                key = pv.Name
                if overwrite is True or key not in self:
                    item = pv.Value
                    if 'com.sun.star.util.DateTime' in repr(type(item)):
                        item = datetime.datetime(item.Year, item.Month, item.Day,
                                                 item.Hours, item.Minutes, item.Seconds, int(item.NanoSeconds / 1000))
                    elif 'com.sun.star.util.Date' in repr(type(item)):
                        item = datetime.datetime(item.Year, item.Month, item.Day)
                    elif 'com.sun.star.util.Time' in repr(type(item)):
                        item = datetime.datetime(item.Hours, item.Minutes, item.Seconds, int(item.NanoSeconds / 1000))
                    result.append((key, item))
            self.update(result)
            return True

    # #########################################################################
    # SF_Exception CLASS
    # #########################################################################
    class SF_Exception(SFServices, metaclass = _Singleton):
        """
            The Exception service is a collection of methods for code debugging and error handling.

            The Exception service console stores events, variable values and information about errors.
            Use the console when the Python shell is not available, for example in Calc user defined functions (UDF)
            or during events processing.
            Use DebugPrint() method to aggregate additional user data of any type.

            Console entries can be dumped to a text file or visualized in a dialogue.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'ScriptForge.Exception'
        servicesynonyms = ('exception', 'scriptforge.exception')
        serviceproperties = dict()

        def Console(self, modal = True):
            # From Python, the current XComponentContext must be added as last argument
            return self.ExecMethod(self.vbMethod, 'Console', modal, ScriptForge.componentcontext)

        def ConsoleClear(self, keep = 0):
            return self.ExecMethod(self.vbMethod, 'ConsoleClear', keep)

        def ConsoleToFile(self, filename):
            return self.ExecMethod(self.vbMethod, 'ConsoleToFile', filename)

        def DebugDisplay(self, *args):
            # Arguments are concatenated in a single string similar to what the Python print() function would produce
            self.DebugPrint(*args)
            param = '\n'.join(list(map(lambda a: a.strip("'") if isinstance(a, str) else repr(a), args)))
            bas = CreateScriptService('ScriptForge.Basic')
            return bas.MsgBox(param, bas.MB_OK + bas.MB_ICONINFORMATION, 'DebugDisplay')

        def DebugPrint(self, *args):
            # Arguments are concatenated in a single string similar to what the Python print() function would produce
            # Avoid using repr() on strings to not have backslashes * 4
            param = '\t'.join(list(map(lambda a: a.strip("'") if isinstance(a, str) else repr(a),
                                       args))).expandtabs(tabsize = 4)
            return self.ExecMethod(self.vbMethod, 'DebugPrint', param)

        @classmethod
        def PythonShell(cls, variables = None):
            """
                Open an APSO python shell window - Thanks to its authors Hanya/Tsutomu Uchino/Hubert Lambert
                :param variables: Typical use
                                        PythonShell.({**globals(), **locals()})
                                  to push the global and local dictionaries to the shell window
                """
            if variables is None:
                variables = locals()
            # Is APSO installed ?
            ctx = ScriptForge.componentcontext
            ext = ctx.getByName('/singletons/com.sun.star.deployment.PackageInformationProvider')
            apso = 'apso.python.script.organizer'
            if len(ext.getPackageLocation(apso)) > 0:
                # APSO is available. However, PythonShell() is ignored in bridge mode
                # because APSO library not in pythonpath
                if ScriptForge.port > 0:
                    return None
                # Directly derived from apso.oxt|python|scripts|tools.py$console
                # we need to load apso before import statement
                ctx.ServiceManager.createInstance('apso.python.script.organizer.impl')
                # now we can use apso_utils library
                from apso_utils import console
                kwargs = {'loc': variables}
                kwargs['loc'].setdefault('XSCRIPTCONTEXT', uno)
                console(**kwargs)
                # An interprocess call is necessary to allow a redirection of STDOUT and STDERR by APSO
                #   Choice is a minimalist call to a Basic routine: no arguments, a few lines of code
                SFScriptForge.SF_Basic.GetGuiType()
            else:
                # The APSO extension could not be located in your LibreOffice installation
                cls._RaiseFatal('SF_Exception.PythonShell', 'variables=None', 'PYTHONSHELLERROR')

        @classmethod
        def RaiseFatal(cls, errorcode, *args):
            """
                Generate a run-time error caused by an anomaly in a user script detected by ScriptForge
                The message is logged in the console. The execution is STOPPED
                For INTERNAL USE only
                """
            # Direct call because RaiseFatal forces an execution stop in Basic
            if len(args) == 0:
                args = (None,)
            return cls.SIMPLEEXEC('@SF_Exception.RaiseFatal', (errorcode, *args))  # With ParamArray

        @classmethod
        def _RaiseFatal(cls, sub, subargs, errorcode, *args):
            """
                Wrapper of RaiseFatal(). Includes method and syntax of the failed Python routine
                to simulate the exact behaviour of the Basic RaiseFatal() method
                For INTERNAL USE only
                """
            ScriptForge.InvokeSimpleScript('ScriptForge.SF_Utils._EnterFunction', sub, subargs)
            cls.RaiseFatal(errorcode, *args)
            raise RuntimeError("The execution of the method '" + sub.split('.')[-1] + "' failed. Execution stops.")

    # #########################################################################
    # SF_FileSystem CLASS
    # #########################################################################
    class SF_FileSystem(SFServices, metaclass = _Singleton):
        """
            The "FileSystem" service includes common file and folder handling routines.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'ScriptForge.FileSystem'
        servicesynonyms = ('filesystem', 'scriptforge.filesystem')
        serviceproperties = dict(FileNaming = True, ConfigFolder = False, ExtensionsFolder = False, HomeFolder = False,
                                 InstallFolder = False, TemplatesFolder = False, TemporaryFolder = False,
                                 UserTemplatesFolder = False)
        # Force for each property to get its value from Basic - due to FileNaming updatability
        forceGetProperty = True
        # Open TextStream constants
        ForReading, ForWriting, ForAppending = 1, 2, 8

        def BuildPath(self, foldername, name):
            return self.ExecMethod(self.vbMethod, 'BuildPath', foldername, name)

        def CompareFiles(self, filename1, filename2, comparecontents = False):
            py = ScriptForge.pythonhelpermodule + '$' + '_SF_FileSystem__CompareFiles'
            if self.FileExists(filename1) and self.FileExists(filename2):
                file1 = self._ConvertFromUrl(filename1)
                file2 = self._ConvertFromUrl(filename2)
                return self.SIMPLEEXEC(py, file1, file2, comparecontents)
            else:
                return False

        def CopyFile(self, source, destination, overwrite = True):
            return self.ExecMethod(self.vbMethod, 'CopyFile', source, destination, overwrite)

        def CopyFolder(self, source, destination, overwrite = True):
            return self.ExecMethod(self.vbMethod, 'CopyFolder', source, destination, overwrite)

        def CreateFolder(self, foldername):
            return self.ExecMethod(self.vbMethod, 'CreateFolder', foldername)

        def CreateTextFile(self, filename, overwrite = True, encoding = 'UTF-8'):
            return self.ExecMethod(self.vbMethod, 'CreateTextFile', filename, overwrite, encoding)

        def DeleteFile(self, filename):
            return self.ExecMethod(self.vbMethod, 'DeleteFile', filename)

        def DeleteFolder(self, foldername):
            return self.ExecMethod(self.vbMethod, 'DeleteFolder', foldername)

        def ExtensionFolder(self, extension):
            return self.ExecMethod(self.vbMethod, 'ExtensionFolder', extension)

        def FileExists(self, filename):
            return self.ExecMethod(self.vbMethod, 'FileExists', filename)

        def Files(self, foldername, filter = ''):
            return self.ExecMethod(self.vbMethod, 'Files', foldername, filter)

        def FolderExists(self, foldername):
            return self.ExecMethod(self.vbMethod, 'FolderExists', foldername)

        def GetBaseName(self, filename):
            return self.ExecMethod(self.vbMethod, 'GetBaseName', filename)

        def GetExtension(self, filename):
            return self.ExecMethod(self.vbMethod, 'GetExtension', filename)

        def GetFileLen(self, filename):
            py = ScriptForge.pythonhelpermodule + '$' + '_SF_FileSystem__GetFilelen'
            if self.FileExists(filename):
                file = self._ConvertFromUrl(filename)
                return int(self.SIMPLEEXEC(py, file))
            else:
                return 0

        def GetFileModified(self, filename):
            return self.ExecMethod(self.vbMethod + self.flgDateRet, 'GetFileModified', filename)

        def GetName(self, filename):
            return self.ExecMethod(self.vbMethod, 'GetName', filename)

        def GetParentFolderName(self, filename):
            return self.ExecMethod(self.vbMethod, 'GetParentFolderName', filename)

        def GetTempName(self):
            return self.ExecMethod(self.vbMethod, 'GetTempName')

        def HashFile(self, filename, algorithm):
            py = ScriptForge.pythonhelpermodule + '$' + '_SF_FileSystem__HashFile'
            if self.FileExists(filename):
                file = self._ConvertFromUrl(filename)
                return self.SIMPLEEXEC(py, file, algorithm.lower())
            else:
                return ''

        def MoveFile(self, source, destination):
            return self.ExecMethod(self.vbMethod, 'MoveFile', source, destination)

        def Normalize(self, filename):
            return self.ExecMethod(self.vbMethod, 'Normalize', filename)

        def MoveFolder(self, source, destination):
            return self.ExecMethod(self.vbMethod, 'MoveFolder', source, destination)

        def OpenTextFile(self, filename, iomode = 1, create = False, encoding = 'UTF-8'):
            return self.ExecMethod(self.vbMethod, 'OpenTextFile', filename, iomode, create, encoding)

        def PickFile(self, defaultfile = ScriptForge.cstSymEmpty, mode = 'OPEN', filter = ''):
            return self.ExecMethod(self.vbMethod, 'PickFile', defaultfile, mode, filter)

        def PickFolder(self, defaultfolder = ScriptForge.cstSymEmpty, freetext = ''):
            return self.ExecMethod(self.vbMethod, 'PickFolder', defaultfolder, freetext)

        def SubFolders(self, foldername, filter = ''):
            return self.ExecMethod(self.vbMethod, 'SubFolders', foldername, filter)

        @classmethod
        def _ConvertFromUrl(cls, filename):
            # Alias for same function in FileSystem Basic module
            return cls.SIMPLEEXEC('ScriptForge.SF_FileSystem._ConvertFromUrl', filename)

    # #########################################################################
    # SF_L10N CLASS
    # #########################################################################
    class SF_L10N(SFServices):
        """
            This service provides a number of methods related to the translation of strings
            with minimal impact on the program's source code.
            The methods provided by the L10N service can be used mainly to:
                Create POT files that can be used as templates for translation of all strings in the program.
                Get translated strings at runtime for the language defined in the Locale property.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'ScriptForge.L10N'
        servicesynonyms = ('l10n', 'scriptforge.l10n')
        serviceproperties = dict(Folder = False, Languages = False, Locale = False)

        @classmethod
        def ReviewServiceArgs(cls, foldername = '', locale = '', encoding = 'UTF-8',
                              locale2 = '', encoding2 = 'UTF-8'):
            """
                Transform positional and keyword arguments into positional only
                """
            return foldername, locale, encoding, locale2, encoding2

        def AddText(self, context = '', msgid = '', comment = ''):
            return self.ExecMethod(self.vbMethod, 'AddText', context, msgid, comment)

        def AddTextsFromDialog(self, dialog):
            dialogobj = dialog.objectreference if isinstance(dialog, SFDialogs.SF_Dialog) else dialog
            return self.ExecMethod(self.vbMethod + self.flgObject, 'AddTextsFromDialog', dialogobj)

        def ExportToPOTFile(self, filename, header = '', encoding = 'UTF-8'):
            return self.ExecMethod(self.vbMethod, 'ExportToPOTFile', filename, header, encoding)

        def GetText(self, msgid, *args):
            return self.ExecMethod(self.vbMethod, 'GetText', msgid, *args)

        _ = GetText

    # #########################################################################
    # SF_Platform CLASS
    # #########################################################################
    class SF_Platform(SFServices, metaclass = _Singleton):
        """
            The 'Platform' service implements a collection of properties about the actual execution environment
            and context :
                the hardware platform
                the operating system
                the LibreOffice version
                the current user
            All those properties are read-only.
            The implementation is mainly based on the 'platform' module of the Python standard library
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'ScriptForge.Platform'
        servicesynonyms = ('platform', 'scriptforge.platform')
        serviceproperties = dict(Architecture = False, ComputerName = False, CPUCount = False, CurrentUser = False,
                                 Extensions = False, FilterNames = False, Fonts = False, FormatLocale = False,
                                 Locale = False, Machine = False, OfficeLocale = False, OfficeVersion = False,
                                 OSName = False, OSPlatform = False, OSRelease = False, OSVersion = False,
                                 Printers = False, Processor = False, PythonVersion = False, SystemLocale = False)
        # Python helper functions
        py = ScriptForge.pythonhelpermodule + '$' + '_SF_Platform'

        @property
        def Architecture(self):
            return self.SIMPLEEXEC(self.py, 'Architecture')

        @property
        def ComputerName(self):
            return self.SIMPLEEXEC(self.py, 'ComputerName')

        @property
        def CPUCount(self):
            return self.SIMPLEEXEC(self.py, 'CPUCount')

        @property
        def CurrentUser(self):
            return self.SIMPLEEXEC(self.py, 'CurrentUser')

        @property
        def Machine(self):
            return self.SIMPLEEXEC(self.py, 'Machine')

        @property
        def OSName(self):
            return self.SIMPLEEXEC(self.py, 'OSName')

        @property
        def OSPlatform(self):
            return self.SIMPLEEXEC(self.py, 'OSPlatform')

        @property
        def OSRelease(self):
            return self.SIMPLEEXEC(self.py, 'OSRelease')

        @property
        def OSVersion(self):
            return self.SIMPLEEXEC(self.py, 'OSVersion')

        @property
        def Processor(self):
            return self.SIMPLEEXEC(self.py, 'Processor')

        @property
        def PythonVersion(self):
            return self.SIMPLEEXEC(self.py, 'PythonVersion')

    # #########################################################################
    # SF_Region CLASS
    # #########################################################################
    class SF_Region(SFServices, metaclass = _Singleton):
        """
            The "Region" service gathers a collection of functions about languages, countries and timezones
                - Locales
                - Currencies
                - Numbers and dates formatting
                - Calendars
                - Timezones conversions
                - Numbers transformed to text
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'ScriptForge.Region'
        servicesynonyms = ('region', 'scriptforge.region')
        serviceproperties = dict()

        # Next functions are implemented in Basic as read-only properties with 1 argument
        def Country(self, region = ''):
            return self.GetProperty('Country', region)

        def Currency(self, region = ''):
            return self.GetProperty('Currency', region)

        def DatePatterns(self, region = ''):
            return self.GetProperty('DatePatterns', region)

        def DateSeparator(self, region = ''):
            return self.GetProperty('DateSeparator', region)

        def DayAbbrevNames(self, region = ''):
            return self.GetProperty('DayAbbrevNames', region)

        def DayNames(self, region = ''):
            return self.GetProperty('DayNames', region)

        def DayNarrowNames(self, region = ''):
            return self.GetProperty('DayNarrowNames', region)

        def DecimalPoint(self, region = ''):
            return self.GetProperty('DecimalPoint', region)

        def Language(self, region = ''):
            return self.GetProperty('Language', region)

        def ListSeparator(self, region = ''):
            return self.GetProperty('ListSeparator', region)

        def MonthAbbrevNames(self, region = ''):
            return self.GetProperty('MonthAbbrevNames', region)

        def MonthNames(self, region = ''):
            return self.GetProperty('MonthNames', region)

        def MonthNarrowNames(self, region = ''):
            return self.GetProperty('MonthNarrowNames', region)

        def ThousandSeparator(self, region = ''):
            return self.GetProperty('ThousandSeparator', region)

        def TimeSeparator(self, region = ''):
            return self.GetProperty('TimeSeparator', region)

        # Usual methods
        def DSTOffset(self, localdatetime, timezone, locale = ''):
            if isinstance(localdatetime, datetime.datetime):
                localdatetime = SFScriptForge.SF_Basic.CDateToUnoDateTime(localdatetime)
            return self.ExecMethod(self.vbMethod + self.flgDateArg, 'DSTOffset', localdatetime, timezone, locale)

        def LocalDateTime(self, utcdatetime, timezone, locale = ''):
            if isinstance(utcdatetime, datetime.datetime):
                utcdatetime = SFScriptForge.SF_Basic.CDateToUnoDateTime(utcdatetime)
            localdate = self.ExecMethod(self.vbMethod + self.flgDateArg + self.flgDateRet, 'LocalDateTime',
                                        utcdatetime, timezone, locale)
            return SFScriptForge.SF_Basic.CDateFromUnoDateTime(localdate)

        def Number2Text(self, number, locale = ''):
            return self.ExecMethod(self.vbMethod, 'Number2Text', number, locale)

        def TimeZoneOffset(self, timezone, locale = ''):
            return self.ExecMethod(self.vbMethod, 'TimeZoneOffset', timezone, locale)

        def UTCDateTime(self, localdatetime, timezone, locale = ''):
            if isinstance(localdatetime, datetime.datetime):
                localdatetime = SFScriptForge.SF_Basic.CDateToUnoDateTime(localdatetime)
            utcdate = self.ExecMethod(self.vbMethod + self.flgDateArg + self.flgDateRet, 'UTCDateTime', localdatetime,
                                      timezone, locale)
            return SFScriptForge.SF_Basic.CDateFromUnoDateTime(utcdate)

        def UTCNow(self, timezone, locale = ''):
            now = self.ExecMethod(self.vbMethod + self.flgDateRet, 'UTCNow', timezone, locale)
            return SFScriptForge.SF_Basic.CDateFromUnoDateTime(now)

    # #########################################################################
    # SF_Session CLASS
    # #########################################################################
    class SF_Session(SFServices, metaclass = _Singleton):
        """
            The Session service gathers various general-purpose methods about:
            - UNO introspection
            - the invocation of external scripts or programs
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'ScriptForge.Session'
        servicesynonyms = ('session', 'scriptforge.session')
        serviceproperties = dict()

        # Class constants                       Where to find an invoked library ?
        SCRIPTISEMBEDDED = 'document'  # in the document
        SCRIPTISAPPLICATION = 'application'  # in any shared library (Basic)
        SCRIPTISPERSONAL = 'user'  # in My Macros (Python)
        SCRIPTISPERSOXT = 'user:uno_packages'  # in an extension installed for the current user (Python)
        SCRIPTISSHARED = 'share'  # in LibreOffice macros (Python)
        SCRIPTISSHAROXT = 'share:uno_packages'  # in an extension installed for all users (Python)
        SCRIPTISOXT = 'uno_packages'  # in an extension but the installation parameters are unknown (Python)

        @classmethod
        def ExecuteBasicScript(cls, scope = '', script = '', *args):
            if scope is None or scope == '':
                scope = cls.SCRIPTISAPPLICATION
            if len(args) == 0:
                args = (scope,) + (script,) + (None,)
            else:
                args = (scope,) + (script,) + args
            # ExecuteBasicScript method has a ParamArray parameter in Basic
            return cls.SIMPLEEXEC('@SF_Session.ExecuteBasicScript', args)

        @classmethod
        def ExecuteCalcFunction(cls, calcfunction, *args):
            if len(args) == 0:
                # Arguments of Calc functions are strings or numbers. None == Empty is a good alias for no argument
                args = (calcfunction,) + (None,)
            else:
                args = (calcfunction,) + args
            # ExecuteCalcFunction method has a ParamArray parameter in Basic
            return cls.SIMPLEEXEC('@SF_Session.ExecuteCalcFunction', args)

        @classmethod
        def ExecutePythonScript(cls, scope = '', script = '', *args):
            return cls.SIMPLEEXEC(scope + '#' + script, *args)

        def HasUnoMethod(self, unoobject, methodname):
            return self.ExecMethod(self.vbMethod, 'HasUnoMethod', unoobject, methodname)

        def HasUnoProperty(self, unoobject, propertyname):
            return self.ExecMethod(self.vbMethod, 'HasUnoProperty', unoobject, propertyname)

        @classmethod
        def OpenURLInBrowser(cls, url):
            py = ScriptForge.pythonhelpermodule + '$' + '_SF_Session__OpenURLInBrowser'
            return cls.SIMPLEEXEC(py, url)

        def RunApplication(self, command, parameters):
            return self.ExecMethod(self.vbMethod, 'RunApplication', command, parameters)

        def SendMail(self, recipient, cc = '', bcc = '', subject = '', body = '', filenames = '', editmessage = True):
            return self.ExecMethod(self.vbMethod, 'SendMail', recipient, cc, bcc, subject, body, filenames, editmessage)

        def UnoObjectType(self, unoobject):
            return self.ExecMethod(self.vbMethod, 'UnoObjectType', unoobject)

        def UnoMethods(self, unoobject):
            return self.ExecMethod(self.vbMethod, 'UnoMethods', unoobject)

        def UnoProperties(self, unoobject):
            return self.ExecMethod(self.vbMethod, 'UnoProperties', unoobject)

        def WebService(self, uri):
            return self.ExecMethod(self.vbMethod, 'WebService', uri)

    # #########################################################################
    # SF_String CLASS
    # #########################################################################
    class SF_String(SFServices, metaclass = _Singleton):
        """
            Focus on string manipulation, regular expressions, encodings and hashing algorithms.
            The methods implemented in Basic that are redundant with Python builtin functions
            are not duplicated
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'ScriptForge.String'
        servicesynonyms = ('string', 'scriptforge.string')
        serviceproperties = dict()

        @classmethod
        def HashStr(cls, inputstr, algorithm):
            py = ScriptForge.pythonhelpermodule + '$' + '_SF_String__HashStr'
            return cls.SIMPLEEXEC(py, inputstr, algorithm.lower())

        def IsADate(self, inputstr, dateformat = 'YYYY-MM-DD'):
            return self.ExecMethod(self.vbMethod, 'IsADate', inputstr, dateformat)

        def IsEmail(self, inputstr):
            return self.ExecMethod(self.vbMethod, 'IsEmail', inputstr)

        def IsFileName(self, inputstr, osname = ScriptForge.cstSymEmpty):
            return self.ExecMethod(self.vbMethod, 'IsFileName', inputstr, osname)

        def IsIBAN(self, inputstr):
            return self.ExecMethod(self.vbMethod, 'IsIBAN', inputstr)

        def IsIPv4(self, inputstr):
            return self.ExecMethod(self.vbMethod, 'IsIPv4', inputstr)

        def IsLike(self, inputstr, pattern, casesensitive = False):
            return self.ExecMethod(self.vbMethod, 'IsLike', inputstr, pattern, casesensitive)

        def IsSheetName(self, inputstr):
            return self.ExecMethod(self.vbMethod, 'IsSheetName', inputstr)

        def IsUrl(self, inputstr):
            return self.ExecMethod(self.vbMethod, 'IsUrl', inputstr)

        def SplitNotQuoted(self, inputstr, delimiter = ' ', occurrences = 0, quotechar = '"'):
            return self.ExecMethod(self.vbMethod, 'SplitNotQuoted', inputstr, delimiter, occurrences, quotechar)

        def Wrap(self, inputstr, width = 70, tabsize = 8):
            return self.ExecMethod(self.vbMethod, 'Wrap', inputstr, width, tabsize)

    # #########################################################################
    # SF_TextStream CLASS
    # #########################################################################
    class SF_TextStream(SFServices):
        """
            The TextStream service is used to sequentially read from and write to files opened or created
            using the ScriptForge.FileSystem service..
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'ScriptForge.TextStream'
        servicesynonyms = ()
        serviceproperties = dict(AtEndOfStream = False, Encoding = False, FileName = False, IOMode = False,
                                 Line = False, NewLine = True)

        @property
        def AtEndOfStream(self):
            return self.GetProperty('AtEndOfStream')

        atEndOfStream, atendofstream = AtEndOfStream, AtEndOfStream

        @property
        def Line(self):
            return self.GetProperty('Line')

        line = Line

        def CloseFile(self):
            return self.ExecMethod(self.vbMethod, 'CloseFile')

        def ReadAll(self):
            return self.ExecMethod(self.vbMethod, 'ReadAll')

        def ReadLine(self):
            return self.ExecMethod(self.vbMethod, 'ReadLine')

        def SkipLine(self):
            return self.ExecMethod(self.vbMethod, 'SkipLine')

        def WriteBlankLines(self, lines):
            return self.ExecMethod(self.vbMethod, 'WriteBlankLines', lines)

        def WriteLine(self, line):
            return self.ExecMethod(self.vbMethod, 'WriteLine', line)

    # #########################################################################
    # SF_Timer CLASS
    # #########################################################################
    class SF_Timer(SFServices):
        """
            The "Timer" service measures the amount of time it takes to run user scripts.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'ScriptForge.Timer'
        servicesynonyms = ('timer', 'scriptforge.timer')
        serviceproperties = dict(Duration = False, IsStarted = False, IsSuspended = False,
                                 SuspendDuration = False, TotalDuration = False)
        # Force for each property to get its value from Basic
        forceGetProperty = True

        @classmethod
        def ReviewServiceArgs(cls, start = False):
            """
                Transform positional and keyword arguments into positional only
                """
            return (start,)

        def Continue(self):
            return self.ExecMethod(self.vbMethod, 'Continue')

        def Restart(self):
            return self.ExecMethod(self.vbMethod, 'Restart')

        def Start(self):
            return self.ExecMethod(self.vbMethod, 'Start')

        def Suspend(self):
            return self.ExecMethod(self.vbMethod, 'Suspend')

        def Terminate(self):
            return self.ExecMethod(self.vbMethod, 'Terminate')

    # #########################################################################
    # SF_UI CLASS
    # #########################################################################
    class SF_UI(SFServices, metaclass = _Singleton):
        """
            Singleton class for the identification and the manipulation of the
            different windows composing the whole LibreOffice application:
                - Windows selection
                - Windows moving and resizing
                - Statusbar settings
                - Creation of new windows
                - Access to the underlying "documents"
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'ScriptForge.UI'
        servicesynonyms = ('ui', 'scriptforge.ui')
        serviceproperties = dict(ActiveWindow = False, Height = False, Width = False, X = False, Y = False)

        # Class constants
        MACROEXECALWAYS, MACROEXECNEVER, MACROEXECNORMAL = 2, 1, 0
        BASEDOCUMENT, CALCDOCUMENT, DRAWDOCUMENT, IMPRESSDOCUMENT, MATHDOCUMENT, WRITERDOCUMENT = \
            'Base', 'Calc', 'Draw', 'Impress', 'Math', 'Writer'

        @property
        def ActiveWindow(self):
            return self.ExecMethod(self.vbMethod, 'ActiveWindow')

        activeWindow, activewindow = ActiveWindow, ActiveWindow

        def Activate(self, windowname = ''):
            return self.ExecMethod(self.vbMethod, 'Activate', windowname)

        def CreateBaseDocument(self, filename, embeddeddatabase = 'HSQLDB', registrationname = '', calcfilename = ''):
            return self.ExecMethod(self.vbMethod, 'CreateBaseDocument', filename, embeddeddatabase, registrationname,
                                   calcfilename)

        def CreateDocument(self, documenttype = '', templatefile = '', hidden = False):
            return self.ExecMethod(self.vbMethod, 'CreateDocument', documenttype, templatefile, hidden)

        def Documents(self):
            return self.ExecMethod(self.vbMethod, 'Documents')

        def GetDocument(self, windowname = ''):
            return self.ExecMethod(self.vbMethod, 'GetDocument', windowname)

        def Maximize(self, windowname = ''):
            return self.ExecMethod(self.vbMethod, 'Maximize', windowname)

        def Minimize(self, windowname = ''):
            return self.ExecMethod(self.vbMethod, 'Minimize', windowname)

        def OpenBaseDocument(self, filename = '', registrationname = '', macroexecution = MACROEXECNORMAL):
            return self.ExecMethod(self.vbMethod, 'OpenBaseDocument', filename, registrationname, macroexecution)

        def OpenDocument(self, filename, password = '', readonly = False, hidden = False,
                         macroexecution = MACROEXECNORMAL, filtername = '', filteroptions = ''):
            return self.ExecMethod(self.vbMethod, 'OpenDocument', filename, password, readonly, hidden,
                                   macroexecution, filtername, filteroptions)

        def Resize(self, left = -1, top = -1, width = -1, height = -1):
            return self.ExecMethod(self.vbMethod, 'Resize', left, top, width, height)

        def RunCommand(self, command, *args, **kwargs):
            params = tuple(list(args) + ScriptForge.unpack_args(kwargs))
            if len(params) == 0:
                params = (command,) + (None,)
            else:
                params = (command,) + params
            return self.SIMPLEEXEC('@SF_UI.RunCommand', params)

        def SetStatusbar(self, text = '', percentage = -1):
            return self.ExecMethod(self.vbMethod, 'SetStatusbar', text, percentage)

        def ShowProgressBar(self, title = '', text = '', percentage = -1):
            # From Python, the current XComponentContext must be added as last argument
            return self.ExecMethod(self.vbMethod, 'ShowProgressBar', title, text, percentage,
                                   ScriptForge.componentcontext)

        def WindowExists(self, windowname):
            return self.ExecMethod(self.vbMethod, 'WindowExists', windowname)


# #####################################################################################################################
#                       SFDatabases CLASS    (alias of SFDatabases Basic library)                                   ###
# #####################################################################################################################
class SFDatabases:
    """
        The SFDatabases class manages databases embedded in or connected to Base documents
        """
    pass

    # #########################################################################
    # SF_Database CLASS
    # #########################################################################
    class SF_Database(SFServices):
        """
            Each instance of the current class represents a single database, with essentially its tables, queries
            and data
            The exchanges with the database are done in SQL only.
            To make them more readable, use optionally square brackets to surround table/query/field names
            instead of the (RDBMS-dependent) normal surrounding character.
            SQL statements may be run in direct or indirect mode. In direct mode the statement is transferred literally
            without syntax checking nor review to the database engine.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFDatabases.Database'
        servicesynonyms = ('database', 'sfdatabases.database')
        serviceproperties = dict(Queries = False, Tables = False, XConnection = False, XMetaData = False)

        @classmethod
        def ReviewServiceArgs(cls, filename = '', registrationname = '', readonly = True, user = '', password = ''):
            """
                Transform positional and keyword arguments into positional only
                """
            return filename, registrationname, readonly, user, password

        def CloseDatabase(self):
            return self.ExecMethod(self.vbMethod, 'CloseDatabase')

        def DAvg(self, expression, tablename, criteria = ''):
            return self.ExecMethod(self.vbMethod, 'DAvg', expression, tablename, criteria)

        def DCount(self, expression, tablename, criteria = ''):
            return self.ExecMethod(self.vbMethod, 'DCount', expression, tablename, criteria)

        def DLookup(self, expression, tablename, criteria = '', orderclause = ''):
            return self.ExecMethod(self.vbMethod, 'DLookup', expression, tablename, criteria, orderclause)

        def DMax(self, expression, tablename, criteria = ''):
            return self.ExecMethod(self.vbMethod, 'DMax', expression, tablename, criteria)

        def DMin(self, expression, tablename, criteria = ''):
            return self.ExecMethod(self.vbMethod, 'DMin', expression, tablename, criteria)

        def DSum(self, expression, tablename, criteria = ''):
            return self.ExecMethod(self.vbMethod, 'DSum', expression, tablename, criteria)

        def GetRows(self, sqlcommand, directsql = False, header = False, maxrows = 0):
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'GetRows', sqlcommand, directsql, header, maxrows)

        def OpenQuery(self, queryname):
            return self.ExecMethod(self.vbMethod, 'OpenQuery', queryname)

        def OpenSql(self, sql, directsql = False):
            return self.ExecMethod(self.vbMethod, 'OpenSql', sql, directsql)

        def OpenTable(self, tablename):
            return self.ExecMethod(self.vbMethod, 'OpenTable', tablename)

        def RunSql(self, sqlcommand, directsql = False):
            return self.ExecMethod(self.vbMethod, 'RunSql', sqlcommand, directsql)

    # #########################################################################
    # SF_Datasheet CLASS
    # #########################################################################
    class SF_Datasheet(SFServices):
        """
            A datasheet is the visual representation of tabular data produced by a database.
            A datasheet may be opened automatically by script code at any moment.
            The Base document owning the data may or may not be opened.
            Any SELECT SQL statement may trigger the datasheet display.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFDatabases.Datasheet'
        servicesynonyms = ('datasheet', 'sfdatabases.datasheet')
        serviceproperties = dict(ColumnHeaders = False, CurrentColumn = False, CurrentRow = False,
                                 DatabaseFileName = False, Filter = True, LastRow = False, OrderBy = True,
                                 ParentDatabase = False, Source = False, SourceType = False, XComponent = False,
                                 XControlModel = False, XTabControllerModel = False)

        def Activate(self):
            return self.ExecMethod(self.vbMethod, 'Activate')

        def CloseDatasheet(self):
            return self.ExecMethod(self.vbMethod, 'CloseDatasheet')

        def CreateMenu(self, menuheader, before = '', submenuchar = '>'):
            return self.ExecMethod(self.vbMethod, 'CreateMenu', menuheader, before, submenuchar)

        def GetText(self, column = 0):
            return self.ExecMethod(self.vbMethod, 'GetText', column)

        def GetValue(self, column = 0):
            return self.ExecMethod(self.vbMethod, 'GetValue', column)

        def GoToCell(self, row = 0, column = 0):
            return self.ExecMethod(self.vbMethod, 'GoToCell', row, column)

        def RemoveMenu(self, menuheader):
            return self.ExecMethod(self.vbMethod, 'RemoveMenu', menuheader)


# #####################################################################################################################
#                       SFDialogs CLASS    (alias of SFDialogs Basic library)                                       ###
# #####################################################################################################################
class SFDialogs:
    """
        The SFDialogs class manages dialogs defined with the Basic IDE
        """
    pass

    # #########################################################################
    # SF_Dialog CLASS
    # #########################################################################
    class SF_Dialog(SFServices):
        """
            Each instance of the current class represents a single dialog box displayed to the user.
            The dialog box must have been designed and defined with the Basic IDE previously.
            From a Python script, a dialog box can be displayed in modal or in non-modal modes.

            In modal mode, the box is displayed and the execution of the macro process is suspended
            until one of the OK or Cancel buttons is pressed. In the meantime, other user actions
            executed on the box can trigger specific actions.

            In non-modal mode, the floating dialog remains displayed until the dialog is terminated
            by code (Terminate()) or until the LibreOffice application stops.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFDialogs.Dialog'
        servicesynonyms = ('dialog', 'sfdialogs.dialog')
        serviceproperties = dict(Caption = True, Height = True, Modal = False, Name = False,
                                 OnFocusGained = False, OnFocusLost = False, OnKeyPressed = False,
                                 OnKeyReleased = False, OnMouseDragged = False, OnMouseEntered = False,
                                 OnMouseExited = False, OnMouseMoved = False, OnMousePressed = False,
                                 OnMouseReleased = False,
                                 Page = True, Visible = True, Width = True, XDialogModel = False, XDialogView = False)
        # Class constants used together with the Execute() method
        OKBUTTON, CANCELBUTTON = 1, 0

        @classmethod
        def ReviewServiceArgs(cls, container = '', library = 'Standard', dialogname = ''):
            """
                Transform positional and keyword arguments into positional only
                Add the XComponentContext as last argument
                """
            return container, library, dialogname, ScriptForge.componentcontext

        # Methods potentially executed while the dialog is in execution require the flgHardCode flag
        def Activate(self):
            return self.ExecMethod(self.vbMethod + self.flgHardCode, 'Activate')

        def Center(self, parent = ScriptForge.cstSymMissing):
            parentclasses = (SFDocuments.SF_Document, SFDocuments.SF_Base, SFDocuments.SF_Calc, SFDocuments.SF_Writer,
                             SFDialogs.SF_Dialog)
            parentobj = parent.objectreference if isinstance(parent, parentclasses) else parent
            return self.ExecMethod(self.vbMethod + self.flgObject + self.flgHardCode, 'Center', parentobj)

        def Controls(self, controlname = ''):
            return self.ExecMethod(self.vbMethod + self.flgArrayRet + self.flgHardCode, 'Controls', controlname)

        def EndExecute(self, returnvalue):
            return self.ExecMethod(self.vbMethod + self.flgHardCode, 'EndExecute', returnvalue)

        def Execute(self, modal = True):
            return self.ExecMethod(self.vbMethod + self.flgHardCode, 'Execute', modal)

        def GetTextsFromL10N(self, l10n):
            l10nobj = l10n.objectreference if isinstance(l10n, SFScriptForge.SF_L10N) else l10n
            return self.ExecMethod(self.vbMethod + self.flgObject, 'GetTextsFromL10N', l10nobj)

        def Resize(self, left = -1, top = -1, width = -1, height = -1):
            return self.ExecMethod(self.vbMethod + self.flgHardCode, 'Resize', left, top, width, height)

        def SetPageManager(self, pilotcontrols = '', tabcontrols = '', wizardcontrols = '', lastpage = 0):
            return self.ExecMethod(self.vbMethod, 'SetPageManager', pilotcontrols, tabcontrols, wizardcontrols,
                                   lastpage)

        def Terminate(self):
            return self.ExecMethod(self.vbMethod, 'Terminate')

    # #########################################################################
    # SF_DialogControl CLASS
    # #########################################################################
    class SF_DialogControl(SFServices):
        """
            Each instance of the current class represents a single control within a dialog box.
            The focus is clearly set on getting and setting the values displayed by the controls of the dialog box,
            not on their formatting.
            A special attention is given to controls with type TreeControl.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFDialogs.DialogControl'
        servicesynonyms = ()
        serviceproperties = dict(Cancel = True, Caption = True, ControlType = False, CurrentNode = True,
                                 Default = True, Enabled = True, Format = True, ListCount = False,
                                 ListIndex = True, Locked = True, MultiSelect = True, Name = False,
                                 OnActionPerformed = False, OnAdjustmentValueChanged = False, OnFocusGained = False,
                                 OnFocusLost = False, OnItemStateChanged = False, OnKeyPressed = False,
                                 OnKeyReleased = False, OnMouseDragged = False, OnMouseEntered = False,
                                 OnMouseExited = False, OnMouseMoved = False, OnMousePressed = False,
                                 OnMouseReleased = False, OnNodeExpanded = True, OnNodeSelected = True,
                                 OnTextChanged = False, Page = True, Parent = False, Picture = True,
                                 RootNode = False, RowSource = True, Text = False, TipText = True,
                                 TripleState = True, Value = True, Visible = True,
                                 XControlModel = False, XControlView = False, XGridColumnModel = False,
                                 XGridDataModel = False, XTreeDataModel = False)

        # Root related properties do not start with X and, nevertheless, return a UNO object
        @property
        def CurrentNode(self):
            return self.EXEC(self.objectreference, self.vbGet + self.flgUno, 'CurrentNode')

        @property
        def RootNode(self):
            return self.EXEC(self.objectreference, self.vbGet + self.flgUno, 'RootNode')

        def AddSubNode(self, parentnode, displayvalue, datavalue = ScriptForge.cstSymEmpty):
            return self.ExecMethod(self.vbMethod + self.flgUno, 'AddSubNode', parentnode, displayvalue, datavalue)

        def AddSubTree(self, parentnode, flattree, withdatavalue = False):
            return self.ExecMethod(self.vbMethod, 'AddSubTree', parentnode, flattree, withdatavalue)

        def CreateRoot(self, displayvalue, datavalue = ScriptForge.cstSymEmpty):
            return self.ExecMethod(self.vbMethod + self.flgUno, 'CreateRoot', displayvalue, datavalue)

        def FindNode(self, displayvalue, datavalue = ScriptForge.cstSymEmpty, casesensitive = False):
            return self.ExecMethod(self.vbMethod + self.flgUno, 'FindNode', displayvalue, datavalue, casesensitive)

        def SetFocus(self):
            return self.ExecMethod(self.vbMethod, 'SetFocus')

        def SetTableData(self, dataarray, widths = (1,), alignments = ''):
            return self.ExecMethod(self.vbMethod + self.flgArrayArg, 'SetTableData', dataarray, widths, alignments)

        def WriteLine(self, line = ''):
            return self.ExecMethod(self.vbMethod, 'WriteLine', line)


# #####################################################################################################################
#                       SFDocuments CLASS    (alias of SFDocuments Basic library)                                   ###
# #####################################################################################################################
class SFDocuments:
    """
        The SFDocuments class gathers a number of classes, methods and properties making easy
        managing and manipulating LibreOffice documents
        """
    pass

    # #########################################################################
    # SF_Document CLASS
    # #########################################################################
    class SF_Document(SFServices):
        """
            The methods and properties are generic for all types of documents: they are combined in the
            current SF_Document class
                - saving, closing documents
                - accessing their standard or custom properties
            Specific properties and methods are implemented in the concerned subclass(es) SF_Calc, SF_Base, ...
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFDocuments.Document'
        servicesynonyms = ('document', 'sfdocuments.document')
        serviceproperties = dict(Description = True, DocumentType = False, ExportFilters = False, ImportFilters = False,
                                 IsBase = False, IsCalc = False, IsDraw = False, IsImpress = False, IsMath = False,
                                 IsWriter = False, Keywords = True, Readonly = False, Subject = True, Title = True,
                                 XComponent = False)
        # Force for each property to get its value from Basic - due to intense interactivity with user
        forceGetProperty = True

        @classmethod
        def ReviewServiceArgs(cls, windowname = ''):
            """
                Transform positional and keyword arguments into positional only
                """
            return windowname,

        def Activate(self):
            return self.ExecMethod(self.vbMethod, 'Activate')

        def CloseDocument(self, saveask = True):
            return self.ExecMethod(self.vbMethod, 'CloseDocument', saveask)

        def CreateMenu(self, menuheader, before = '', submenuchar = '>'):
            return self.ExecMethod(self.vbMethod, 'CreateMenu', menuheader, before, submenuchar)

        def ExportAsPDF(self, filename, overwrite = False, pages = '', password = '', watermark = ''):
            return self.ExecMethod(self.vbMethod, 'ExportAsPDF', filename, overwrite, pages, password, watermark)

        def PrintOut(self, pages = '', copies = 1):
            return self.ExecMethod(self.vbMethod, 'PrintOut', pages, copies)

        def RemoveMenu(self, menuheader):
            return self.ExecMethod(self.vbMethod, 'RemoveMenu', menuheader)

        def RunCommand(self, command, *args, **kwargs):
            params = tuple([command] + list(args) + ScriptForge.unpack_args(kwargs))
            return self.ExecMethod(self.vbMethod, 'RunCommand', *params)

        def Save(self):
            return self.ExecMethod(self.vbMethod, 'Save')

        def SaveAs(self, filename, overwrite = False, password = '', filtername = '', filteroptions = ''):
            return self.ExecMethod(self.vbMethod, 'SaveAs', filename, overwrite, password, filtername, filteroptions)

        def SaveCopyAs(self, filename, overwrite = False, password = '', filtername = '', filteroptions = ''):
            return self.ExecMethod(self.vbMethod, 'SaveCopyAs', filename, overwrite,
                                   password, filtername, filteroptions)

        def SetPrinter(self, printer = '', orientation = '', paperformat = ''):
            return self.ExecMethod(self.vbMethod, 'SetPrinter', printer, orientation, paperformat)

    # #########################################################################
    # SF_Base CLASS
    # #########################################################################
    class SF_Base(SF_Document, SFServices):
        """
            The SF_Base module is provided mainly to block parent properties that are NOT applicable to Base documents
            In addition, it provides methods to identify form documents and access their internal forms
            (read more elsewhere (the "SFDocuments.Form" service) about this subject)
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFDocuments.Base'
        servicesynonyms = ('base', 'scriptforge.base')
        serviceproperties = dict(DocumentType = False, IsBase = False, IsCalc = False,
                                 IsDraw = False, IsImpress = False, IsMath = False, IsWriter = False,
                                 XComponent = False)

        @classmethod
        def ReviewServiceArgs(cls, windowname = ''):
            """
                Transform positional and keyword arguments into positional only
                """
            return windowname,

        def CloseDocument(self, saveask = True):
            return self.ExecMethod(self.vbMethod, 'CloseDocument', saveask)

        def CloseFormDocument(self, formdocument):
            return self.ExecMethod(self.vbMethod, 'CloseFormDocument', formdocument)

        def FormDocuments(self):
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'FormDocuments')

        def Forms(self, formdocument, form = ''):
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'Forms', formdocument, form)

        def GetDatabase(self, user = '', password = ''):
            return self.ExecMethod(self.vbMethod, 'GetDatabase', user, password)

        def IsLoaded(self, formdocument):
            return self.ExecMethod(self.vbMethod, 'IsLoaded', formdocument)

        def OpenFormDocument(self, formdocument, designmode = False):
            return self.ExecMethod(self.vbMethod, 'OpenFormDocument', formdocument, designmode)

        def OpenQuery(self, queryname):
            return self.ExecMethod(self.vbMethod, 'OpenQuery', queryname)

        def OpenTable(self, tablename):
            return self.ExecMethod(self.vbMethod, 'OpenTable', tablename)

        def PrintOut(self, formdocument, pages = '', copies = 1):
            return self.ExecMethod(self.vbMethod, 'PrintOut', formdocument, pages, copies)

        def SetPrinter(self, formdocument = '', printer = '', orientation = '', paperformat = ''):
            return self.ExecMethod(self.vbMethod, 'SetPrinter', formdocument, printer, orientation, paperformat)

    # #########################################################################
    # SF_Calc CLASS
    # #########################################################################
    class SF_Calc(SF_Document, SFServices):
        """
            The SF_Calc module is focused on :
                - management (copy, insert, move, ...) of sheets within a Calc document
                - exchange of data between Basic data structures and Calc ranges of values
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFDocuments.Calc'
        servicesynonyms = ('calc', 'sfdocuments.calc')
        serviceproperties = dict(CurrentSelection = True, Sheets = False,
                                 Description = True, DocumentType = False, ExportFilters = False, ImportFilters = False,
                                 IsBase = False, IsCalc = False, IsDraw = False, IsImpress = False, IsMath = False,
                                 IsWriter = False, Keywords = True, Readonly = False, Subject = True, Title = True,
                                 XComponent = False)
        # Force for each property to get its value from Basic - due to intense interactivity with user
        forceGetProperty = True

        @classmethod
        def ReviewServiceArgs(cls, windowname = ''):
            """
                Transform positional and keyword arguments into positional only
                """
            return windowname,

        # Next functions are implemented in Basic as read-only properties with 1 argument
        def FirstCell(self, rangename):
            return self.GetProperty('FirstCell', rangename)

        def FirstColumn(self, rangename):
            return self.GetProperty('FirstColumn', rangename)

        def FirstRow(self, rangename):
            return self.GetProperty('FirstRow', rangename)

        def Height(self, rangename):
            return self.GetProperty('Height', rangename)

        def LastCell(self, rangename):
            return self.GetProperty('LastCell', rangename)

        def LastColumn(self, rangename):
            return self.GetProperty('LastColumn', rangename)

        def LastRow(self, rangename):
            return self.GetProperty('LastRow', rangename)

        def Range(self, rangename):
            return self.GetProperty('Range', rangename)

        def Region(self, rangename):
            return self.GetProperty('Region', rangename)

        def Sheet(self, sheetname):
            return self.GetProperty('Sheet', sheetname)

        def SheetName(self, rangename):
            return self.GetProperty('SheetName', rangename)

        def Width(self, rangename):
            return self.GetProperty('Width', rangename)

        def XCellRange(self, rangename):
            return self.ExecMethod(self.vbGet + self.flgUno, 'XCellRange', rangename)

        def XSheetCellCursor(self, rangename):
            return self.ExecMethod(self.vbGet + self.flgUno, 'XSheetCellCursor', rangename)

        def XSpreadsheet(self, sheetname):
            return self.ExecMethod(self.vbGet + self.flgUno, 'XSpreadsheet', sheetname)

        # Usual methods
        def A1Style(self, row1, column1, row2 = 0, column2 = 0, sheetname = '~'):
            return self.ExecMethod(self.vbMethod, 'A1Style', row1, column1, row2, column2, sheetname)

        def Activate(self, sheetname = ''):
            return self.ExecMethod(self.vbMethod, 'Activate', sheetname)

        def Charts(self, sheetname, chartname = ''):
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'Charts', sheetname, chartname)

        def ClearAll(self, range, filterformula = '', filterscope = ''):
            return self.ExecMethod(self.vbMethod, 'ClearAll', range, filterformula, filterscope)

        def ClearFormats(self, range, filterformula = '', filterscope = ''):
            return self.ExecMethod(self.vbMethod, 'ClearFormats', range, filterformula, filterscope)

        def ClearValues(self, range, filterformula = '', filterscope = ''):
            return self.ExecMethod(self.vbMethod, 'ClearValues', range, filterformula, filterscope)

        def CompactLeft(self, range, wholecolumn = False, filterformula = ''):
            return self.ExecMethod(self.vbMethod, 'CompactLeft', range, wholecolumn, filterformula)

        def CompactUp(self, range, wholerow = False, filterformula = ''):
            return self.ExecMethod(self.vbMethod, 'CompactUp', range, wholerow, filterformula)

        def CopySheet(self, sheetname, newname, beforesheet = 32768):
            sheet = (sheetname.objectreference if isinstance(sheetname, SFDocuments.SF_CalcReference) else sheetname)
            return self.ExecMethod(self.vbMethod + self.flgObject, 'CopySheet', sheet, newname, beforesheet)

        def CopySheetFromFile(self, filename, sheetname, newname, beforesheet = 32768):
            sheet = (sheetname.objectreference if isinstance(sheetname, SFDocuments.SF_CalcReference) else sheetname)
            return self.ExecMethod(self.vbMethod + self.flgObject, 'CopySheetFromFile',
                                   filename, sheet, newname, beforesheet)

        def CopyToCell(self, sourcerange, destinationcell):
            range = (sourcerange.objectreference if isinstance(sourcerange, SFDocuments.SF_CalcReference)
                     else sourcerange)
            return self.ExecMethod(self.vbMethod + self.flgObject, 'CopyToCell', range, destinationcell)

        def CopyToRange(self, sourcerange, destinationrange):
            range = (sourcerange.objectreference if isinstance(sourcerange, SFDocuments.SF_CalcReference)
                     else sourcerange)
            return self.ExecMethod(self.vbMethod + self.flgObject, 'CopyToRange', range, destinationrange)

        def CreateChart(self, chartname, sheetname, range, columnheader = False, rowheader = False):
            return self.ExecMethod(self.vbMethod, 'CreateChart', chartname, sheetname, range, columnheader, rowheader)

        def CreatePivotTable(self, pivottablename, sourcerange, targetcell, datafields = ScriptForge.cstSymEmpty,
                             rowfields = ScriptForge.cstSymEmpty, columnfields = ScriptForge.cstSymEmpty,
                             filterbutton = True, rowtotals = True, columntotals = True):
            return self.ExecMethod(self.vbMethod, 'CreatePivotTable', pivottablename, sourcerange, targetcell,
                                   datafields, rowfields, columnfields, filterbutton, rowtotals, columntotals)

        def DAvg(self, range):
            return self.ExecMethod(self.vbMethod, 'DAvg', range)

        def DCount(self, range):
            return self.ExecMethod(self.vbMethod, 'DCount', range)

        def DMax(self, range):
            return self.ExecMethod(self.vbMethod, 'DMax', range)

        def DMin(self, range):
            return self.ExecMethod(self.vbMethod, 'DMin', range)

        def DSum(self, range):
            return self.ExecMethod(self.vbMethod, 'DSum', range)

        def ExportRangeToFile(self, range, filename, imagetype = 'pdf', overwrite = False):
            return self.ExecMethod(self.vbMethod, 'ExportRangeToFile', range, filename, imagetype, overwrite)

        def Forms(self, sheetname, form = ''):
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'Forms', sheetname, form)

        def GetColumnName(self, columnnumber):
            return self.ExecMethod(self.vbMethod, 'GetColumnName', columnnumber)

        def GetFormula(self, range):
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'GetFormula', range)

        def GetValue(self, range):
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'GetValue', range)

        def ImportFromCSVFile(self, filename, destinationcell, filteroptions = ScriptForge.cstSymEmpty):
            return self.ExecMethod(self.vbMethod, 'ImportFromCSVFile', filename, destinationcell, filteroptions)

        def ImportFromDatabase(self, filename = '', registrationname = '', destinationcell = '', sqlcommand = '',
                               directsql = False):
            return self.ExecMethod(self.vbMethod, 'ImportFromDatabase', filename, registrationname,
                                   destinationcell, sqlcommand, directsql)

        def InsertSheet(self, sheetname, beforesheet = 32768):
            return self.ExecMethod(self.vbMethod, 'InsertSheet', sheetname, beforesheet)

        def MoveRange(self, source, destination):
            return self.ExecMethod(self.vbMethod, 'MoveRange', source, destination)

        def MoveSheet(self, sheetname, beforesheet = 32768):
            return self.ExecMethod(self.vbMethod, 'MoveSheet', sheetname, beforesheet)

        def Offset(self, range, rows = 0, columns = 0, height = ScriptForge.cstSymEmpty,
                   width = ScriptForge.cstSymEmpty):
            return self.ExecMethod(self.vbMethod, 'Offset', range, rows, columns, height, width)

        def OpenRangeSelector(self, title = '', selection = '~', singlecell = False, closeafterselect = True):
            return self.ExecMethod(self.vbMethod, 'OpenRangeSelector', title, selection, singlecell, closeafterselect)

        def Printf(self, inputstr, range, tokencharacter = '%'):
            return self.ExecMethod(self.vbMethod, 'Printf', inputstr, range, tokencharacter)

        def PrintOut(self, sheetname = '~', pages = '', copies = 1):
            return self.ExecMethod(self.vbMethod, 'PrintOut', sheetname, pages, copies)

        def RemoveSheet(self, sheetname):
            return self.ExecMethod(self.vbMethod, 'RemoveSheet', sheetname)

        def RenameSheet(self, sheetname, newname):
            return self.ExecMethod(self.vbMethod, 'RenameSheet', sheetname, newname)

        def SetArray(self, targetcell, value):
            return self.ExecMethod(self.vbMethod + self.flgArrayArg, 'SetArray', targetcell, value)

        def SetCellStyle(self, targetrange, style, filterformula = '', filterscope = ''):
            return self.ExecMethod(self.vbMethod, 'SetCellStyle', targetrange, style, filterformula, filterscope)

        def SetFormula(self, targetrange, formula):
            return self.ExecMethod(self.vbMethod + self.flgArrayArg, 'SetFormula', targetrange, formula)

        def SetValue(self, targetrange, value):
            return self.ExecMethod(self.vbMethod + self.flgArrayArg, 'SetValue', targetrange, value)

        def ShiftDown(self, range, wholerow = False, rows = 0):
            return self.ExecMethod(self.vbMethod, 'ShiftDown', range, wholerow, rows)

        def ShiftLeft(self, range, wholecolumn = False, columns = 0):
            return self.ExecMethod(self.vbMethod, 'ShiftLeft', range, wholecolumn, columns)

        def ShiftRight(self, range, wholecolumn = False, columns = 0):
            return self.ExecMethod(self.vbMethod, 'ShiftRight', range, wholecolumn, columns)

        def ShiftUp(self, range, wholerow = False, rows = 0):
            return self.ExecMethod(self.vbMethod, 'ShiftUp', range, wholerow, rows)

        def SortRange(self, range, sortkeys, sortorder = 'ASC', destinationcell = ScriptForge.cstSymEmpty,
                      containsheader = False, casesensitive = False, sortcolumns = False):
            return self.ExecMethod(self.vbMethod, 'SortRange', range, sortkeys, sortorder, destinationcell,
                                   containsheader, casesensitive, sortcolumns)

    # #########################################################################
    # SF_CalcReference CLASS
    # #########################################################################
    class SF_CalcReference(SFServices):
        """
            The SF_CalcReference class has as unique role to hold sheet and range references.
            They are implemented in Basic as Type ... End Type data structures
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFDocuments.CalcReference'
        servicesynonyms = ()
        serviceproperties = dict()

    # #########################################################################
    # SF_Chart CLASS
    # #########################################################################
    class SF_Chart(SFServices):
        """
            The SF_Chart module is focused on the description of chart documents
            stored in Calc sheets.
            With this service, many chart types and chart characteristics available
            in the user interface can be read or modified.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFDocuments.Chart'
        servicesynonyms = ()
        serviceproperties = dict(ChartType = True, Deep = True, Dim3D = True, Exploded = True, Filled = True,
                                 Legend = True, Percent = True, Stacked = True, Title = True,
                                 XChartObj = False, XDiagram = False, XShape = False, XTableChart = False,
                                 XTitle = True, YTitle = True)

        def Resize(self, xpos = -1, ypos = -1, width = -1, height = -1):
            return self.ExecMethod(self.vbMethod, 'Resize', xpos, ypos, width, height)

        def ExportToFile(self, filename, imagetype = 'png', overwrite = False):
            return self.ExecMethod(self.vbMethod, 'ExportToFile', filename, imagetype, overwrite)

    # #########################################################################
    # SF_Form CLASS
    # #########################################################################
    class SF_Form(SFServices):
        """
            Management of forms defined in LibreOffice documents. Supported types are Base, Calc and Writer documents.
            It includes the management of subforms
            Each instance of the current class represents a single form or a single subform
            A form may optionally be (understand "is often") linked to a data source manageable with
            the SFDatabases.Database service. The current service offers a rapid access to that service.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFDocuments.Form'
        servicesynonyms = ()
        serviceproperties = dict(AllowDeletes = True, AllowInserts = True, AllowUpdates = True, BaseForm = False,
                                 Bookmark = True, CurrentRecord = True, Filter = True, LinkChildFields = False,
                                 LinkParentFields = False, Name = False,
                                 OnApproveCursorMove = True, OnApproveParameter = True, OnApproveReset = True,
                                 OnApproveRowChange = True, OnApproveSubmit = True, OnConfirmDelete = True,
                                 OnCursorMoved = True, OnErrorOccurred = True, OnLoaded = True, OnReloaded = True,
                                 OnReloading = True, OnResetted = True, OnRowChanged = True, OnUnloaded = True,
                                 OnUnloading = True,
                                 OrderBy = True, Parent = False, RecordSource = True, XForm = False)

        def Activate(self):
            return self.ExecMethod(self.vbMethod, 'Activate')

        def CloseFormDocument(self):
            return self.ExecMethod(self.vbMethod, 'CloseFormDocument')

        def Controls(self, controlname = ''):
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'Controls', controlname)

        def GetDatabase(self, user = '', password = ''):
            return self.ExecMethod(self.vbMethod, 'GetDatabase', user, password)

        def MoveFirst(self):
            return self.ExecMethod(self.vbMethod, 'MoveFirst')

        def MoveLast(self):
            return self.ExecMethod(self.vbMethod, 'MoveLast')

        def MoveNew(self):
            return self.ExecMethod(self.vbMethod, 'MoveNew')

        def MoveNext(self, offset = 1):
            return self.ExecMethod(self.vbMethod, 'MoveNext', offset)

        def MovePrevious(self, offset = 1):
            return self.ExecMethod(self.vbMethod, 'MovePrevious', offset)

        def Requery(self):
            return self.ExecMethod(self.vbMethod, 'Requery')

        def Subforms(self, subform = ''):
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'Subforms', subform)

    # #########################################################################
    # SF_FormControl CLASS
    # #########################################################################
    class SF_FormControl(SFServices):
        """
            Manage the controls belonging to a form or subform stored in a document.
            Each instance of the current class represents a single control within a form, a subform or a tablecontrol.
            A prerequisite is that all controls within the same form, subform or tablecontrol must have
            a unique name.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFDocuments.FormControl'
        servicesynonyms = ()
        serviceproperties = dict(Action = True, Caption = True, ControlSource = False, ControlType = False,
                                 Default = True, DefaultValue = True, Enabled = True, Format = True,
                                 ListCount = False, ListIndex = True, ListSource = True, ListSourceType = True,
                                 Locked = True, MultiSelect = True, Name = False,
                                 OnActionPerformed = True, OnAdjustmentValueChanged = True,
                                 OnApproveAction = True, OnApproveReset = True, OnApproveUpdate = True,
                                 OnChanged = True, OnErrorOccurred = True, OnFocusGained = True, OnFocusLost = True,
                                 OnItemStateChanged = True, OnKeyPressed = True, OnKeyReleased = True,
                                 OnMouseDragged = True, OnMouseEntered = True, OnMouseExited = True,
                                 OnMouseMoved = True, OnMousePressed = True, OnMouseReleased = True, OnResetted = True,
                                 OnTextChanged = True, OnUpdated = True, Parent = False, Picture = True,
                                 Required = True, Text = False, TipText = True, TripleState = True, Value = True,
                                 Visible = True, XControlModel = False, XControlView = False)

        def Controls(self, controlname = ''):
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'Controls', controlname)

        def SetFocus(self):
            return self.ExecMethod(self.vbMethod, 'SetFocus')

    # #########################################################################
    # SF_Writer CLASS
    # #########################################################################
    class SF_Writer(SF_Document, SFServices):
        """
            The SF_Writer module is focused on :
                - TBD
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFDocuments.Writer'
        servicesynonyms = ('writer', 'sfdocuments.writer')
        serviceproperties = dict(Description = True, DocumentType = False, ExportFilters = False, ImportFilters = False,
                                 IsBase = False, IsCalc = False, IsDraw = False, IsImpress = False, IsMath = False,
                                 IsWriter = False, Keywords = True, Readonly = False, Subject = True, Title = True,
                                 XComponent = False)
        # Force for each property to get its value from Basic - due to intense interactivity with user
        forceGetProperty = True

        @classmethod
        def ReviewServiceArgs(cls, windowname = ''):
            """
                Transform positional and keyword arguments into positional only
                """
            return windowname,

        def Forms(self, form = ''):
            return self.ExecMethod(self.vbMethod + self.flgArrayRet, 'Forms', form)

        def PrintOut(self, pages = '', copies = 1, printbackground = True, printblankpages = False,
                     printevenpages = True, printoddpages = True, printimages = True):
            return self.ExecMethod(self.vbMethod, 'PrintOut', pages, copies, printbackground, printblankpages,
                                   printevenpages, printoddpages, printimages)


# #####################################################################################################################
#                       SFWidgets CLASS    (alias of SFWidgets Basic library)                                       ###
# #####################################################################################################################
class SFWidgets:
    """
        The SFWidgets class manages toolbars and popup menus
        """
    pass

    # #########################################################################
    # SF_Menu CLASS
    # #########################################################################
    class SF_Menu(SFServices):
        """
            Display a menu in the menubar of a document or a form document.
            After use, the menu will not be saved neither in the application settings, nor in the document.
            The menu will be displayed, as usual, when its header in the menubar is clicked.
            When one of its items is selected, there are 3 alternative options:
            - a UNO command (like ".uno:About") is triggered
            - a user script is run receiving a standard argument defined in this service
            - one of above combined with a toggle of the status of the item
            The menu is described from top to bottom. Each menu item receives a numeric and a string identifier.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFWidgets.Menu'
        servicesynonyms = ('menu', 'sfwidgets.menu')
        serviceproperties = dict(ShortcutCharacter = False, SubmenuCharacter = False)

        def AddCheckBox(self, menuitem, name = '', status = False, icon = '', tooltip = '',
                        command = '', script = ''):
            return self.ExecMethod(self.vbMethod, 'AddCheckBox', menuitem, name, status, icon, tooltip,
                                   command, script)

        def AddItem(self, menuitem, name = '', icon = '', tooltip = '', command = '', script = ''):
            return self.ExecMethod(self.vbMethod, 'AddItem', menuitem, name, icon, tooltip, command, script)

        def AddRadioButton(self, menuitem, name = '', status = False, icon = '', tooltip = '',
                           command = '', script = ''):
            return self.ExecMethod(self.vbMethod, 'AddRadioButton', menuitem, name, status, icon, tooltip,
                                   command, script)

    # #########################################################################
    # SF_PopupMenu CLASS
    # #########################################################################
    class SF_PopupMenu(SFServices):
        """
            Display a popup menu anywhere and any time.
            A popup menu is usually triggered by a mouse action (typically a right-click) on a dialog, a form
            or one of their controls. In this case the menu will be displayed below the clicked area.
            When triggered by other events, including in the normal flow of a user script, the script should
            provide the coordinates of the topleft edge of the menu versus the actual component.
            The menu is described from top to bottom. Each menu item receives a numeric and a string identifier.
            The execute() method returns the item selected by the user.
            """
        # Mandatory class properties for service registration
        serviceimplementation = 'basic'
        servicename = 'SFWidgets.PopupMenu'
        servicesynonyms = ('popupmenu', 'sfwidgets.popupmenu')
        serviceproperties = dict(ShortcutCharacter = False, SubmenuCharacter = False)

        @classmethod
        def ReviewServiceArgs(cls, event = None, x = 0, y = 0, submenuchar = ''):
            """
                Transform positional and keyword arguments into positional only
                """
            return event, x, y, submenuchar

        def AddCheckBox(self, menuitem, name = '', status = False, icon = '', tooltip = ''):
            return self.ExecMethod(self.vbMethod, 'AddCheckBox', menuitem, name, status, icon, tooltip)

        def AddItem(self, menuitem, name = '', icon = '', tooltip = ''):
            return self.ExecMethod(self.vbMethod, 'AddItem', menuitem, name, icon, tooltip)

        def AddRadioButton(self, menuitem, name = '', status = False, icon = '', tooltip = ''):
            return self.ExecMethod(self.vbMethod, 'AddRadioButton', menuitem, name, status, icon, tooltip)

        def Execute(self, returnid = True):
            return self.ExecMethod(self.vbMethod, 'Execute', returnid)


# ##############################################False##################################################################
#                           CreateScriptService()                                                                   ###
# #####################################################################################################################
def CreateScriptService(service, *args, **kwargs):
    """
        A service being the name of a collection of properties and methods,
        this method returns either
            - the Python object mirror of the Basic object implementing the requested service
            - the Python object implementing the service itself

        A service may be designated by its official name, stored in its class.servicename
        or by one of its synonyms stored in its class.servicesynonyms list
        If the service is not identified, the service creation is delegated to Basic, that might raise an error
        if still not identified there

        :param service: the name of the service as a string 'library.service' - cased exactly
                or one of its synonyms
        :param args: the arguments to pass to the service constructor
        :return: the service as a Python object
        """
    # Init at each CreateScriptService() invocation
    #       CreateScriptService is usually the first statement in user scripts requesting ScriptForge services
    #       ScriptForge() is optional in user scripts when Python process inside LibreOffice process
    if ScriptForge.SCRIPTFORGEINITDONE is False:
        ScriptForge()

    def ResolveSynonyms(servicename):
        """
            Synonyms within service names implemented in Python or predefined are resolved here
            :param servicename: The short name of the service
            :return: The official service name if found, the argument otherwise
            """
        for cls in SFServices.__subclasses__():
            if servicename.lower() in cls.servicesynonyms:
                return cls.servicename
        return servicename

    #
    # Check the list of available services
    scriptservice = ResolveSynonyms(service)
    if scriptservice in ScriptForge.serviceslist:
        serv = ScriptForge.serviceslist[scriptservice]
        # Check if the requested service is within the Python world
        if serv.serviceimplementation == 'python':
            return serv(*args)
        # Check if the service is a predefined standard Basic service
        elif scriptservice in ScriptForge.servicesmodules:
            return serv(ScriptForge.servicesmodules[scriptservice], classmodule = SFServices.moduleStandard)
    else:
        serv = None
    # The requested service is to be found in the Basic world
    # Check if the service must review the arguments
    if serv is not None:
        if hasattr(serv, 'ReviewServiceArgs'):
            # ReviewServiceArgs() must be a class method
            args = serv.ReviewServiceArgs(*args, **kwargs)
    # Get the service object back from Basic
    if len(args) == 0:
        serv = ScriptForge.InvokeBasicService('SF_Services', SFServices.vbMethod, 'CreateScriptService', service)
    else:
        serv = ScriptForge.InvokeBasicService('SF_Services', SFServices.vbMethod, 'CreateScriptService',
                                              service, *args)
    return serv


createScriptService, createscriptservice = CreateScriptService, CreateScriptService

# ######################################################################
# Lists the scripts, that shall be visible inside the Basic/Python IDE
# ######################################################################

g_exportedScripts = ()
