# -*- coding: utf-8 -*-

#     Copyright 2012-2020 Jean-Pierre LEDURE

# =====================================================================================================================
# ===                   The Access2Base library is a part of the LibreOffice project.                               ===
# ===                   Full documentation is available on http://www.access2base.com                               ===
# =====================================================================================================================

# Access2Base is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# Access2Base is free software; you can redistribute it and/or modify it under the terms of either (at your option):

# 1) The Mozilla Public License, v. 2.0. If a copy of the MPL was not
# distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0/ .

# 2) The GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version. If a copy of the LGPL was not
# distributed with this file, see http://www.gnu.org/licenses/ .

"""
The access2base.py module implements an interface between Python (user) scripts and the Access2Base Basic library.

Usage:
    from access2base import *
Additionally, if Python and LibreOffice are started in separate processes:
    If LibreOffice started from console ... (example for Linux)
        ./soffice --accept='socket,host=localhost,port=2019;urp;'
    then insert next statement
        A2BConnect(hostname = 'localhost', port = 2019)

Specific documentation about Access2Base and Python:
    http://www.access2base.com/access2base.html#%5B%5BAccess2Base%20and%20Python%5D%5D
"""

import uno
XSCRIPTCONTEXT = uno

from platform import system as _opsys
import datetime, os, sys, traceback

_LIBRARY = ''               # Should be 'Access2Base' or 'Access2BaseDev'
_VERSION = '7.1'            # Actual version number
_WRAPPERMODULE = 'Python'   # Module name in the Access2Base library containing Python interfaces

# CallByName types
_vbGet, _vbLet, _vbMethod, _vbSet, _vbUNO = 2, 4, 1, 8, 16


class _Singleton(type):
    """
    A Singleton design pattern
    Credits: « Python in a Nutshell » by Alex Martelli, O'Reilly
    """
    instances = {}
    def __call__(cls, *args, **kwargs):
        if cls not in cls.instances:
            cls.instances[cls] = super(_Singleton, cls).__call__(*args, **kwargs)
        return cls.instances[cls]


class acConstants(object, metaclass = _Singleton):
    """
    VBA constants used in the Access2Base API.
    Values derived from MSAccess, except when conflicts
    """
    # Python special constants (used in the protocol between Python and Basic)
    # -----------------------------------------------------------------
    Empty = '+++EMPTY+++'
    Null = '+++NULL+++'
    Missing = '+++MISSING+++'
    FromIsoFormat = '%Y-%m-%d %H:%M:%S' # To be used with datetime.datetime.strptime()

    # AcCloseSave
    # -----------------------------------------------------------------
    acSaveNo = 2
    acSavePrompt = 0
    acSaveYes = 1

    # AcFormView
    # -----------------------------------------------------------------
    acDesign = 1
    acNormal = 0
    acPreview = 2

    # AcFormOpenDataMode
    # -----------------------------------------------------------------
    acFormAdd = 0
    acFormEdit = 1
    acFormPropertySettings = -1
    acFormReadOnly = 2

    # acView
    # -----------------------------------------------------------------
    acViewDesign = 1
    acViewNormal = 0
    acViewPreview = 2

    # acOpenDataMode
    # -----------------------------------------------------------------
    acAdd = 0
    acEdit = 1
    acReadOnly = 2

    # AcObjectType
    # -----------------------------------------------------------------
    acDefault = -1
    acDiagram = 8
    acForm = 2
    acQuery = 1
    acReport = 3
    acTable = 0
    #   Unexisting in MS/Access
    acBasicIDE = 101
    acDatabaseWindow = 102
    acDocument = 111
    acWelcome = 112
    #   Subtype if acDocument
    docWriter = "Writer"
    docCalc = "Calc"
    docImpress = "Impress"
    docDraw = "Draw"
    docMath = "Math"

    # AcWindowMode
    # -----------------------------------------------------------------
    acDialog = 3
    acHidden = 1
    acIcon = 2
    acWindowNormal = 0

    # VarType constants
    # -----------------------------------------------------------------
    vbEmpty = 0
    vbNull = 1
    vbInteger = 2
    vbLong = 3
    vbSingle = 4
    vbDouble = 5
    vbCurrency = 6
    vbDate = 7
    vbString = 8
    vbObject = 9
    vbBoolean = 11
    vbVariant = 12
    vbByte = 17
    vbUShort = 18
    vbULong = 19
    vbBigint = 35
    vbDecimal = 37
    vbArray = 8192

    # MsgBox constants
    # -----------------------------------------------------------------
    vbOKOnly = 0  # OK button only (default)
    vbOKCancel = 1  # OK and Cancel buttons
    vbAbortRetryIgnore = 2  # Abort, Retry, and Ignore buttons
    vbYesNoCancel = 3  # Yes, No, and Cancel buttons
    vbYesNo = 4  # Yes and No buttons
    vbRetryCancel = 5  # Retry and Cancel buttons
    vbCritical = 16  # Critical message
    vbQuestion = 32  # Warning query
    vbExclamation = 48  # Warning message
    vbInformation = 64  # Information message
    vbDefaultButton1 = 128  # First button is default (default) (VBA: 0)
    vbDefaultButton2 = 256  # Second button is default
    vbDefaultButton3 = 512  # Third button is default
    vbApplicationModal = 0  # Application modal message box (default)
    # MsgBox Return Values
    # -----------------------------------------------------------------
    vbOK = 1  # OK button pressed
    vbCancel = 2  # Cancel button pressed
    vbAbort = 3  # Abort button pressed
    vbRetry = 4  # Retry button pressed
    vbIgnore = 5  # Ignore button pressed
    vbYes = 6  # Yes button pressed
    vbNo = 7  # No button pressed

    # Dialogs Return Values
    # ------------------------------------------------------------------
    dlgOK = 1  # OK button pressed
    dlgCancel = 0  # Cancel button pressed

    # Control Types
    # -----------------------------------------------------------------
    acCheckBox = 5
    acComboBox = 7
    acCommandButton = 2
    acToggleButton = 122
    acCurrencyField = 18
    acDateField = 15
    acFileControl = 12
    acFixedLine = 24  # FREE ENTRY (USEFUL IN DIALOGS)
    acFixedText = 10
    acLabel = 10
    acFormattedField = 1  # FREE ENTRY TAKEN TO NOT CONFUSE WITH acTextField
    acGridControl = 11
    acGroupBox = 8
    acOptionGroup = 8
    acHiddenControl = 13
    acImageButton = 4
    acImageControl = 14
    acImage = 14
    acListBox = 6
    acNavigationBar = 22
    acNumericField = 17
    acPatternField = 19
    acProgressBar = 23  # FREE ENTRY (USEFUL IN DIALOGS)
    acRadioButton = 3
    acOptionButton = 3
    acScrollBar = 20
    acSpinButton = 21
    acSubform = 112
    acTextField = 9
    acTextBox = 9
    acTimeField = 16

    # AcRecord
    # -----------------------------------------------------------------
    acFirst = 2
    acGoTo = 4
    acLast = 3
    acNewRec = 5
    acNext = 1
    acPrevious = 0

    # FindRecord
    # -----------------------------------------------------------------
    acAnywhere = 0
    acEntire = 1
    acStart = 2
    acDown = 1
    acSearchAll = 2
    acUp = 0
    acAll = 0
    acCurrent = -1

    # AcDataObjectType
    # -----------------------------------------------------------------
    acActiveDataObject = -1
    acDataForm = 2
    acDataQuery = 1
    acDataServerView = 7
    acDataStoredProcedure = 9
    acDataTable = 0

    # AcQuitOption
    # -----------------------------------------------------------------
    acQuitPrompt = 0
    acQuitSaveAll = 1
    acQuitSaveNone = 2

    # AcCommand
    # -----------------------------------------------------------------
    acCmdAboutMicrosoftAccess = 35
    acCmdAboutOpenOffice = 35
    acCmdAboutLibreOffice = 35
    acCmdVisualBasicEditor = 525
    acCmdBringToFront = 52
    acCmdClose = 58
    acCmdToolbarsCustomize = 165
    acCmdChangeToCommandButton = 501
    acCmdChangeToCheckBox = 231
    acCmdChangeToComboBox = 230
    acCmdChangeToTextBox = 227
    acCmdChangeToLabel = 228
    acCmdChangeToImage = 234
    acCmdChangeToListBox = 229
    acCmdChangeToOptionButton = 233
    acCmdCopy = 190
    acCmdCut = 189
    acCmdCreateRelationship = 150
    acCmdDelete = 337
    acCmdDatabaseProperties = 256
    acCmdSQLView = 184
    acCmdRemove = 366
    acCmdDesignView = 183
    acCmdFormView = 281
    acCmdNewObjectForm = 136
    acCmdNewObjectTable = 134
    acCmdNewObjectView = 350
    acCmdOpenDatabase = 25
    acCmdNewObjectQuery = 135
    acCmdShowAllRelationships = 149
    acCmdNewObjectReport = 137
    acCmdSelectAll = 333
    acCmdRemoveTable = 84
    acCmdOpenTable = 221
    acCmdRename = 143
    acCmdDeleteRecord = 223
    acCmdApplyFilterSort = 93
    acCmdSnapToGrid = 62
    acCmdViewGrid = 63
    acCmdInsertHyperlink = 259
    acCmdMaximumRecords = 508
    acCmdObjectBrowser = 200
    acCmdPaste = 191
    acCmdPasteSpecial = 64
    acCmdPrint = 340
    acCmdPrintPreview = 54
    acCmdSaveRecord = 97
    acCmdFind = 30
    acCmdUndo = 292
    acCmdRefresh = 18
    acCmdRemoveFilterSort = 144
    acCmdRunMacro = 31
    acCmdSave = 20
    acCmdSaveAs = 21
    acCmdSelectAllRecords = 109
    acCmdSendToBack = 53
    acCmdSortDescending = 164
    acCmdSortAscending = 163
    acCmdTabOrder = 41
    acCmdDatasheetView = 282
    acCmdZoomSelection = 371

    # AcSendObjectType
    # -----------------------------------------------------------------
    acSendForm = 2
    acSendNoObject = -1
    acSendQuery = 1
    acSendReport = 3
    acSendTable = 0

    # AcOutputObjectType
    # -----------------------------------------------------------------
    acOutputTable = 0
    acOutputQuery = 1
    acOutputForm = 2
    acOutputArray = -1

    # AcEncoding
    # -----------------------------------------------------------------
    acUTF8Encoding = 76

    # AcFormat
    # -----------------------------------------------------------------
    acFormatPDF = "writer_pdf_Export"
    acFormatODT = "writer8"
    acFormatDOC = "MS Word 97"
    acFormatHTML = "HTML"
    acFormatODS = "calc8"
    acFormatXLS = "MS Excel 97"
    acFormatXLSX = "Calc MS Excel 2007 XML"
    acFormatTXT = "Text - txt - csv (StarCalc)"

    # AcExportQuality
    # -----------------------------------------------------------------
    acExportQualityPrint = 0
    acExportQualityScreen = 1

    # AcSysCmdAction
    # -----------------------------------------------------------------
    acSysCmdAccessDir = 9
    acSysCmdAccessVer = 7
    acSysCmdClearHelpTopic = 11
    acSysCmdClearStatus = 5
    acSysCmdGetObjectState = 10
    acSysCmdGetWorkgroupFile = 13
    acSysCmdIniFile = 8
    acSysCmdInitMeter = 1
    acSysCmdProfile = 12
    acSysCmdRemoveMeter = 3
    acSysCmdRuntime = 6
    acSysCmdSetStatus = 4
    acSysCmdUpdateMeter = 2

    # Type property
    # -----------------------------------------------------------------
    dbBigInt = 16
    dbBinary = 9
    dbBoolean = 1
    dbByte = 2
    dbChar = 18
    dbCurrency = 5
    dbDate = 8
    dbDecimal = 20
    dbDouble = 7
    dbFloat = 21
    dbGUID = 15
    dbInteger = 3
    dbLong = 4
    dbLongBinary = 11  # (OLE Object)
    dbMemo = 12
    dbNumeric = 19
    dbSingle = 6
    dbText = 10
    dbTime = 22
    dbTimeStamp = 23
    dbVarBinary = 17
    dbUndefined = -1

    # Attributes property
    # -----------------------------------------------------------------
    dbAutoIncrField = 16
    dbDescending = 1
    dbFixedField = 1
    dbHyperlinkField = 32768
    dbSystemField = 8192
    dbUpdatableField = 32
    dbVariableField = 2

    # OpenRecordset
    # -----------------------------------------------------------------
    dbOpenForwardOnly = 8
    dbSQLPassThrough = 64
    dbReadOnly = 4

    # Query types
    # -----------------------------------------------------------------
    dbQAction = 240
    dbQAppend = 64
    dbQDDL = 4  # 96
    dbQDelete = 32
    dbQMakeTable = 128  # 80
    dbQSelect = 0
    dbQSetOperation = 8  # 128
    dbQSQLPassThrough = 1  # 112
    dbQUpdate = 16  # 48

    # Edit mode
    # -----------------------------------------------------------------
    dbEditNone = 0
    dbEditInProgress = 1
    dbEditAdd = 2

    # Toolbars
    # -----------------------------------------------------------------
    msoBarTypeNormal = 0  # Usual toolbar
    msoBarTypeMenuBar = 1  # Menu bar
    msoBarTypePopup = 2  # Shortcut menu
    msoBarTypeStatusBar = 11  # Status bar
    msoBarTypeFloater = 12  # Floating window

    msoControlButton = 1  # Command button
    msoControlPopup = 10  # Popup, submenu

    # New Lines
    # -----------------------------------------------------------------
    vbCr = chr(13)
    vbLf = chr(10)

    def _NewLine():
        if _opsys == 'Windows': return chr(13) + chr(10)
        return chr(10)

    vbNewLine = _NewLine()
    vbTab = chr(9)

    # Module types
    # -----------------------------------------------------------------
    acClassModule = 1
    acStandardModule = 0

    # (Module) procedure types
    # -----------------------------------------------------------------
    vbext_pk_Get = 1  # A Property Get procedure
    vbext_pk_Let = 2  # A Property Let procedure
    vbext_pk_Proc = 0  # A Sub or Function procedure
    vbext_pk_Set = 3  # A Property Set procedure


COMPONENTCONTEXT, DESKTOP, SCRIPTPROVIDER, THISDATABASEDOCUMENT = None, None, None, None

def _ErrorHandler(type, value, tb):
    '''
    Is the function to be set as new sys.excepthook to bypass the standard error handler
        Derived from https://stackoverflow.com/questions/31949760/how-to-limit-python-traceback-to-specific-files
    Handler removes traces pointing to methods located in access2base.py when error is due to a user programming error
        sys.excepthook = _ErrorHandler
    NOT APPLIED YET
    '''

    def check_file(name):
        return 'access2base.py' not in name

    show = (fs for fs in traceback.extract_tb(tb) if check_file(fs.filename))
    fmt = traceback.format_list(show) + traceback.format_exception_only(type, value)
    print(''.join(fmt), end = '', file = sys.stderr)
    # Reset to standard handler
    sys.excepthook = sys.__excepthook__


def A2BConnect(hostname = '', port = 0):
    """
    To be called explicitly by user scripts when Python process runs outside the LibreOffice process.
        LibreOffice started as (Linux):
            ./soffice --accept='socket,host=localhost,port=xxxx;urp;'
    Otherwise called implicitly by the current module without arguments
    Initializes COMPONENTCONTEXT, SCRIPTPROVIDER and DESKTOP
    :param hostname: probably 'localhost' or ''
    :param port: port number or 0
    :return: None
    """
    global XSCRIPTCONTEXT, COMPONENTCONTEXT, DESKTOP, SCRIPTPROVIDER
    # Determine COMPONENTCONTEXT, via socket or inside LibreOffice
    if len(hostname) > 0 and port > 0:      # Explicit connection request via socket
        # Code derived from Bridge.py by Alain H. Romedenne
        local_context = XSCRIPTCONTEXT.getComponentContext()
        resolver = local_context.ServiceManager.createInstanceWithContext(
            'com.sun.star.bridge.UnoUrlResolver', local_context)
        try:
            conn = 'socket,host=%s,port=%d' % (hostname, port)
            connection_url = 'uno:%s;urp;StarOffice.ComponentContext' % conn
            established_context = resolver.resolve(connection_url)
        except Exception:  # thrown when LibreOffice specified instance isn't started
            raise ConnectionError('Connection to LibreOffice failed (host = ' + hostname + ', port = ' + str(port) + ')')
        COMPONENTCONTEXT = established_context
        DESKTOP = None
    elif len(hostname) == 0 and port == 0:       # Usual interactive mode
        COMPONENTCONTEXT = XSCRIPTCONTEXT.getComponentContext()
        DESKTOP = COMPONENTCONTEXT.ServiceManager.createInstanceWithContext( 'com.sun.star.frame.Desktop', COMPONENTCONTEXT)
    else:
        raise SystemExit('The invocation of A2BConnect() has invalid arguments')
    # Determine SCRIPTPROVIDER
    servicemanager = COMPONENTCONTEXT.ServiceManager
    masterscript = servicemanager.createInstanceWithContext("com.sun.star.script.provider.MasterScriptProviderFactory", COMPONENTCONTEXT)
    SCRIPTPROVIDER = masterscript.createScriptProvider("")
    Script = _A2B.xScript('TraceLog', 'Trace')  # Don't use invokeMethod() to force reset of error stack
    Script.invoke(('===>', 'Python wrapper loaded V.' + _VERSION, False), (), ())
    return None


class _A2B(object, metaclass = _Singleton):
    """
    Collection of helper functions implementing the protocol between Python and Basic
        Read comments in PythonWrapper Basic function
    """

    @classmethod
    def BasicObject(cls, objectname):
        objs = {'COLLECTION': _Collection
            , 'COMMANDBAR': _CommandBar
            , 'COMMANDBARCONTROL': _CommandBarControl
            , 'CONTROL': _Control
            , 'DATABASE': _Database
            , 'DIALOG': _Dialog
            , 'EVENT': _Event
            , 'FIELD': _Field
            , 'FORM': _Form
            , 'MODULE': _Module
            , 'OPTIONGROUP': _OptionGroup
            , 'PROPERTY': _Property
            , 'QUERYDEF': _QueryDef
            , 'RECORDSET': _Recordset
            , 'SUBFORM': _SubForm
            , 'TABLEDEF': _TableDef
            , 'TEMPVAR': _TempVar
                }
        return objs[objectname]

    @classmethod
    def xScript(cls, script, module):
        """
        At first call checks the existence of the Access2Base library
        Initializes _LIBRARY with the found library name
        First and next calls execute the given script in the given module of the _LIBRARY library
        The script and module are presumed to exist
        :param script: name of script
        :param module: name of module
        :return: the script object. NB: the execution is done with the invoke() method applied on the returned object
        """
        global _LIBRARY
        Script = None
        def sScript(lib):
            return 'vnd.sun.star.script:' + lib + '.' + module + '.' + script + '?language=Basic&location=application'
        if _LIBRARY == '':
            # Check the availability of the Access2Base library
            for lib in ('Access2BaseDev', 'Access2Base'):
                try:
                    if Script == None:
                        Script = SCRIPTPROVIDER.getScript(sScript(lib))
                        _LIBRARY = lib
                except Exception:
                    pass
            if Script == None:
                raise SystemExit('Access2Base basic library not found')
        else:
            Script = SCRIPTPROVIDER.getScript(sScript(_LIBRARY))
        return Script

    @classmethod
    def A2BErrorCode(cls):
        """
        Return the Access2Base error stack as a tuple
            0 => error code
            1 => severity level
            2 => short error message
            3 => long error message
        """
        Script = cls.xScript('TraceErrorCode', 'Trace')
        return Script.invoke((), (), ())[0]

    @classmethod
    def invokeMethod(cls, script, module, *args):
        """
        Direct call to a named script/module pair with their arguments
        If the arguments do not match their definition at the Basic side, a TypeError is raised
        :param script: name of script
        :param module: name of module
        :param args: list of arguments to be passed to the script
        :return: the value returned by the script execution
        """
        if COMPONENTCONTEXT == None: A2BConnect()     #   Connection from inside LibreOffice is done at first API invocation
        Script = cls.xScript(script, module)
        try:
            Returned = Script.invoke((args), (), ())[0]
        except:
            raise TypeError("Access2Base error: method '" + script + "' in Basic module '" + module + "' call error. Check its arguments.")
        else:
            if Returned == None:
                if cls.VerifyNoError(): return None
            return Returned

    @classmethod
    def invokeWrapper(cls, action, basic, script, *args):
        """
        Call the Basic wrapper to invite it to execute the proposed action on a Basic object
        If the arguments do not match their definition at the Basic side, a TypeError is raised
        After execution, a check is done if the execution has raised an error within Basic
            If yes, a TypeError is raised
        :param action: Property Get, Property Let, Property Set, invoke Method or return UNO object
        :param basic: the reference of the Basic object, i.e. the index in the array caching the addresses of the objects
                        conventionally Application = -1 and DoCmd = -2
        :param script: the property or method name
        :param args: the arguments of the method, if any
        :return: the value returned by the execution of the Basic routine
        """
        if COMPONENTCONTEXT == None: A2BConnect()     #   Connection from inside LibreOffice is done at first API invocation
        # Intercept special call to Application.Events()
        if basic == Application.basicmodule and script == 'Events':
            Script = cls.xScript('PythonEventsWrapper', _WRAPPERMODULE)
            Returned = Script.invoke((args[0],), (), ())
        else:
            Script = cls.xScript('PythonWrapper', _WRAPPERMODULE)
            NoArgs = '+++NOARGS+++'     # Conventional notation for properties/methods without arguments
            if len(args) == 0:
                args = (action,) + (basic,) + (script,) + (NoArgs,)
            else:
                args = (action,) + (basic,) + (script,) + args
            try:
                Returned = Script.invoke((args), (), ())
            except:
                raise TypeError("Access2Base error: method '" + script + "' call error. Check its arguments.")

        if isinstance(Returned[0], tuple):
            # Is returned value a reference to a basic object, a scalar or a UNO object ?
            if len(Returned[0]) in (3, 4):
                if Returned[0][0] == 0:         # scalar
                    return Returned[0][1]
                elif Returned[0][0] == 1:       # reference to objects cache
                    basicobject = cls.BasicObject(Returned[0][2])
                    if len(Returned[0]) == 3:
                        return basicobject(Returned[0][1], Returned[0][2])
                    else:
                        return basicobject(Returned[0][1], Returned[0][2], Returned[0][3])
                elif Returned[0][0] == 2:       # Null value
                    return None
                else:       # Should not happen
                    return None
            else:                               # UNO object
                return Returned[0]
        elif Returned[0] == None:
            if cls.VerifyNoError(): return None
        else: # Should not happen
            return Returned[0]

    @classmethod
    def VerifyNoError(cls):
        # has Access2Base generated an error ?
        errorstack = cls.A2BErrorCode()  # 0 = code, 1 = severity, 2 = short text, 3 = long text
        if errorstack[1] in ('ERROR', 'FATAL', 'ABORT'):
            raise TypeError('Access2Base error: ' + errorstack[3])
        return True


class Application(object, metaclass = _Singleton):
    """ Collection of methods located in the Application (Basic) module """
    W = _A2B.invokeWrapper
    basicmodule = -1

    @classmethod
    def AllDialogs(cls, dialog = acConstants.Missing):
        return cls.W(_vbMethod, cls.basicmodule, 'AllDialogs', dialog)
    @classmethod
    def AllForms(cls, form = acConstants.Missing):
        return cls.W(_vbMethod, cls.basicmodule, 'AllForms', form)
    @classmethod
    def AllModules(cls, module = acConstants.Missing):
        return cls.W(_vbMethod, cls.basicmodule, 'AllModules', module)
    @classmethod
    def CloseConnection(cls):
        return cls.W(_vbMethod, cls.basicmodule, 'CloseConnection')
    @classmethod
    def CommandBars(cls, bar = acConstants.Missing):
        return cls.W(_vbMethod, cls.basicmodule, 'CommandBars', bar)
    @classmethod
    def CurrentDb(cls):
        return cls.W(_vbMethod, cls.basicmodule, 'CurrentDb')
    @classmethod
    def CurrentUser(cls):
        return cls.W(_vbMethod, cls.basicmodule, 'CurrentUser')
    @classmethod
    def DAvg(cls, expression, domain, criteria = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'DAvg', expression, domain, criteria)
    @classmethod
    def DCount(cls, expression, domain, criteria = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'DCount', expression, domain, criteria)
    @classmethod
    def DLookup(cls, expression, domain, criteria = '', orderclause = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'DLookup', expression, domain, criteria, orderclause)
    @classmethod
    def DMax(cls, expression, domain, criteria = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'DMax', expression, domain, criteria)
    @classmethod
    def DMin(cls, expression, domain, criteria = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'DMin', expression, domain, criteria)
    @classmethod
    def DStDev(cls, expression, domain, criteria = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'DStDev', expression, domain, criteria)
    @classmethod
    def DStDevP(cls, expression, domain, criteria = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'DStDevP', expression, domain, criteria)
    @classmethod
    def DSum(cls, expression, domain, criteria = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'DSum', expression, domain, criteria)
    @classmethod
    def DVar(cls, expression, domain, criteria = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'DVar', expression, domain, criteria)
    @classmethod
    def DVarP(cls, expression, domain, criteria = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'DVarP', expression, domain, criteria)
    @classmethod
    def Events(cls, event):
        return cls.W(_vbMethod, cls.basicmodule, 'Events', event)
    @classmethod
    def Forms(cls, form = acConstants.Missing):
        return cls.W(_vbMethod, cls.basicmodule, 'Forms', form)
    @classmethod
    def getObject(cls, shortcut):
        return cls.W(_vbMethod, cls.basicmodule, 'getObject', shortcut)
    GetObject = getObject
    @classmethod
    def getValue(cls, shortcut):
        return cls.W(_vbMethod, cls.basicmodule, 'getValue', shortcut)
    GetValue = getValue
    @classmethod
    def HtmlEncode(cls, string, length = 0):
        return cls.W(_vbMethod, cls.basicmodule, 'HtmlEncode', string, length)
    @classmethod
    def OpenConnection(cls, thisdatabasedocument = acConstants.Missing):
        global THISDATABASEDOCUMENT
        if COMPONENTCONTEXT == None: A2BConnect()     #   Connection from inside LibreOffice is done at first API invocation
        if DESKTOP != None:
            THISDATABASEDOCUMENT = DESKTOP.getCurrentComponent()
            return _A2B.invokeMethod('OpenConnection', 'Application', THISDATABASEDOCUMENT)
    @classmethod
    def OpenDatabase(cls, connectionstring, username = '', password = '', readonly = False):
        return cls.W(_vbMethod, cls.basicmodule, 'OpenDatabase', connectionstring, username
                           , password, readonly)
    @classmethod
    def ProductCode(cls):
        return cls.W(_vbMethod, cls.basicmodule, 'ProductCode')
    @classmethod
    def setValue(cls, shortcut, value):
        return cls.W(_vbMethod, cls.basicmodule, 'setValue', shortcut, value)
    SetValue = setValue
    @classmethod
    def SysCmd(cls, action, text = '', value = -1):
        return cls.W(_vbMethod, cls.basicmodule, 'SysCmd', action, text, value)
    @classmethod
    def TempVars(cls, var = acConstants.Missing):
        return cls.W(_vbMethod, cls.basicmodule, 'TempVars', var)
    @classmethod
    def Version(cls):
        return cls.W(_vbMethod, cls.basicmodule, 'Version')


class DoCmd(object, metaclass = _Singleton):
    """ Collection of methods located in the DoCmd (Basic) module """
    W = _A2B.invokeWrapper
    basicmodule = -2

    @classmethod
    def ApplyFilter(cls, filter = '', sqlwhere = '', controlname = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'ApplyFilter', filter, sqlwhere, controlname)
    @classmethod
    def Close(cls, objecttype, objectname, save = acConstants.acSavePrompt):
        return cls.W(_vbMethod, cls.basicmodule, 'Close', objecttype, objectname, save)
    @classmethod
    def CopyObject(cls, sourcedatabase, newname, sourceobjecttype, sourceobjectname):    # 1st argument must be set
        return cls.W(_vbMethod, cls.basicmodule, 'CopyObject', sourcedatabase, newname, sourceobjecttype
                           , sourceobjectname)
    @classmethod
    def FindNext(cls):
        return cls.W(_vbMethod, cls.basicmodule, 'FindNext')
    @classmethod
    def FindRecord(cls, findwhat, match = acConstants.acEntire, matchcase = False, search = acConstants.acSearchAll
        , searchasformatted = False, onlycurrentfield = acConstants.acCurrent, findfirst = True):
        return cls.W(_vbMethod, cls.basicmodule, 'FindRecord', findwhat, match, matchcase, search
        , searchasformatted, onlycurrentfield, findfirst)
    @classmethod
    def GetHiddenAttribute(cls, objecttype, objectname = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'GetHiddenAttribute', objecttype, objectname)
    @classmethod
    def GoToControl(cls, controlname):
        return cls.W(_vbMethod, cls.basicmodule, 'GoToControl', controlname)
    @classmethod
    def GoToRecord(cls, objecttype = acConstants.acActiveDataObject, objectname = '', record = acConstants.acNext
                   , offset = 1):
        return cls.W(_vbMethod, cls.basicmodule, 'GoToRecord', objecttype, objectname, record, offset)
    @classmethod
    def Maximize(cls):
        return cls.W(_vbMethod, cls.basicmodule, 'Maximize')
    @classmethod
    def Minimize(cls):
        return cls.W(_vbMethod, cls.basicmodule, 'Minimize')
    @classmethod
    def MoveSize(cls, left = -1, top = -1, width = -1, height = -1):
        return cls.W(_vbMethod, cls.basicmodule, 'MoveSize', left, top, width, height)
    @classmethod
    def OpenForm(cls, formname, view = acConstants.acNormal, filter = '', wherecondition = ''
        , datamode = acConstants.acFormEdit, windowmode = acConstants.acWindowNormal, openargs = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'OpenForm', formname, view, filter, wherecondition
        , datamode, windowmode, openargs)
    @classmethod
    def OpenQuery(cls, queryname, view = acConstants.acNormal, datamode = acConstants.acEdit):
        return cls.W(_vbMethod, cls.basicmodule, 'OpenQuery', queryname, view, datamode)
    @classmethod
    def OpenReport(cls, queryname, view = acConstants.acNormal):
        return cls.W(_vbMethod, cls.basicmodule, 'OpenReport', queryname, view)
    @classmethod
    def OpenSQL(cls, sql, option = -1):
        return cls.W(_vbMethod, cls.basicmodule, 'OpenSQL', sql, option)
    @classmethod
    def OpenTable(cls, tablename, view = acConstants.acNormal, datamode = acConstants.acEdit):
        return cls.W(_vbMethod, cls.basicmodule, 'OpenTable', tablename, view, datamode)
    @classmethod
    def OutputTo(cls, objecttype, objectname = '', outputformat = '', outputfile = '', autostart = False, templatefile = ''
        , encoding = acConstants.acUTF8Encoding, quality = acConstants.acExportQualityPrint):
        if objecttype == acConstants.acOutputForm: encoding = 0
        return cls.W(_vbMethod, cls.basicmodule, 'OutputTo', objecttype, objectname, outputformat
                           , outputfile, autostart, templatefile, encoding, quality)
    @classmethod
    def Quit(cls):
        return cls.W(_vbMethod, cls.basicmodule, 'Quit')
    @classmethod
    def RunApp(cls, commandline):
        return cls.W(_vbMethod, cls.basicmodule, 'RunApp', commandline)
    @classmethod
    def RunCommand(cls, command):
        return cls.W(_vbMethod, cls.basicmodule, 'RunCommand', command)
    @classmethod
    def RunSQL(cls, SQL, option = -1):
        return cls.W(_vbMethod, cls.basicmodule, 'RunSQL', SQL, option)
    @classmethod
    def SelectObject(cls, objecttype, objectname = '', indatabasewindow = False):
        return cls.W(_vbMethod, cls.basicmodule, 'SelectObject', objecttype, objectname, indatabasewindow)
    @classmethod
    def SendObject(cls, objecttype = acConstants.acSendNoObject, objectname = '', outputformat = '', to = '', cc = ''
        , bcc = '', subject = '', messagetext = '', editmessage = True, templatefile = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'SendObject', objecttype, objectname, outputformat, to, cc
        , bcc, subject, messagetext, editmessage, templatefile)
    @classmethod
    def SetHiddenAttribute(cls, objecttype, objectname = '', hidden = True):
        return cls.W(_vbMethod, cls.basicmodule, 'SetHiddenAttribute', objecttype, objectname, hidden)
    @classmethod
    def SetOrderBy(cls, orderby = '', controlname = ''):
        return cls.W(_vbMethod, cls.basicmodule, 'SetOrderBy', orderby, controlname)
    @classmethod
    def ShowAllRecords(cls):
        return cls.W(_vbMethod, cls.basicmodule, 'ShowAllRecords')


class Basic(object, metaclass = _Singleton):
    """ Collection of helper functions having the same behaviour as their Basic counterparts """
    M = _A2B.invokeMethod

    @classmethod
    def ConvertFromUrl(cls, url):
        return cls.M('PyConvertFromUrl', _WRAPPERMODULE, url)

    @classmethod
    def ConvertToUrl(cls, file):
        return cls.M('PyConvertToUrl', _WRAPPERMODULE, file)

    @classmethod
    def CreateUnoService(cls, servicename):
        return cls.M('PyCreateUnoService', _WRAPPERMODULE, servicename)

    @classmethod
    def DateAdd(cls, add, count, datearg):
        if isinstance(datearg, datetime.datetime): datearg = datearg.isoformat()
        dateadd = cls.M('PyDateAdd', _WRAPPERMODULE, add, count, datearg)
        return datetime.datetime.strptime(dateadd, acConstants.FromIsoFormat)

    @classmethod
    def DateDiff(cls, add, date1, date2, weekstart = 1, yearstart = 1):
        if isinstance(date1, datetime.datetime): date1 = date1.isoformat()
        if isinstance(date2, datetime.datetime): date2 = date2.isoformat()
        return cls.M('PyDateDiff', _WRAPPERMODULE, add, date1, date2, weekstart, yearstart)

    @classmethod
    def DatePart(cls, add, datearg, weekstart = 1, yearstart = 1):
        if isinstance(datearg, datetime.datetime): datearg = datearg.isoformat()
        return cls.M('PyDatePart', _WRAPPERMODULE, add, datearg, weekstart, yearstart)

    @classmethod
    def DateValue(cls, datestring):
        datevalue = cls.M('PyDateValue', _WRAPPERMODULE, datestring)
        return datetime.datetime.strptime(datevalue, acConstants.FromIsoFormat)

    @classmethod
    def Format(cls, value, format = None):
        if isinstance(value, (datetime.datetime, datetime.date, datetime.time, )):
            value = value.isoformat()
        return cls.M('PyFormat', _WRAPPERMODULE, value, format)

    @classmethod
    def GetGUIType(cls):
        return cls.M('PyGetGUIType', _WRAPPERMODULE)

    @staticmethod
    def GetPathSeparator():
        return os.sep

    @classmethod
    def GetSystemTicks(cls):
        return cls.M('PyGetSystemTicks', _WRAPPERMODULE)

    @classmethod
    def MsgBox(cls, text, type = None, dialogtitle = None):
        return cls.M('PyMsgBox', _WRAPPERMODULE, text, type, dialogtitle)

    class GlobalScope(object, metaclass = _Singleton):
        @classmethod
        def BasicLibraries(cls):
            return Basic.M('PyGlobalScope', _WRAPPERMODULE, 'Basic')
        @classmethod
        def DialogLibraries(self):
            return Basic.M('PyGlobalScope', _WRAPPERMODULE, 'Dialog')

    @classmethod
    def InputBox(cls, text, title = None, default = None, xpos = None, ypos = None):
        return cls.M('PyInputBox', _WRAPPERMODULE, text, title, default, xpos, ypos)

    @staticmethod
    def Now():
        return datetime.datetime.now()

    @staticmethod
    def RGB(red, green, blue):
        return int('%02x%02x%02x' % (red, green, blue), 16)

    @classmethod
    def Timer(cls):
        return cls.M('PyTimer', _WRAPPERMODULE)

    @staticmethod
    def Xray(myObject):
        xrayscript = 'vnd.sun.star.script:XrayTool._Main.Xray?language=Basic&location=application'
        xScript = SCRIPTPROVIDER.getScript(xrayscript)
        xScript.invoke((myObject,), (), ())
        return


class _BasicObject(object):
    """
    Parent class of Basic objects
    Each subclass is identified by its classProperties:
         dictionary with keys = allowed properties, value = True if editable or False
    Each instance is identified by its
        - reference in the cache managed by Basic
        - type ('DATABASE', 'COLLECTION', ...)
        - name (form, control, ... name) - may be blank
    Properties are got and set following next strategy:
        1. Property names are controlled strictly ('Value' and not 'value')
        2. Getting a property value for the first time is always done via a Basic call
        3. Next occurrences are fetched from the Python dictionary of the instance if the property is read-only, otherwise via a Basic call
        4. Methods output might force the deletion of a property from the dictionary ('MoveNext' changes 'BOF' and 'EOF' properties)
        5. Setting a property value is done via a Basic call, except if self.internal == True
    """
    W = _A2B.invokeWrapper
    internal_attributes = ('objectreference', 'objecttype', 'name', 'internal')

    def __init__(self, reference = -1, objtype = None, name = ''):
        self.objectreference = reference    # reference in the cache managed by Basic
        self.objecttype = objtype           # ('DATABASE', 'COLLECTION', ...)
        self.name = name                    # '' when no name
        self.internal = False               # True to exceptionally allow assigning a new value to a read-only property
        self.localProperties = ()

    def __getattr__(self, name):
        if name in ('classProperties', 'localProperties'):
            pass
        elif name in self.classProperties:
            # Get Property from Basic
            return self.W(_vbGet, self.objectreference, name)
        # Usual attributes getter
        return super(_BasicObject, self).__getattribute__(name)

    def __setattr__(self, name, value):
        if name in ('classProperties', 'localProperties'):
            pass
        elif name in self.classProperties:
            if self.internal:       # internal = True forces property setting even if property is read-only
                pass
            elif self.classProperties[name] == True: # True == Editable
                self.W(_vbLet, self.objectreference, name, value)
            else:
                raise AttributeError("type object '" + self.objecttype + "' has no editable attribute '" + name + "'")
        elif name[0:2] == '__' or name in self.internal_attributes or name in self.localProperties:
            pass
        else:
            raise AttributeError("type object '" + self.objecttype + "' has no attribute '" + name + "'")
        object.__setattr__(self, name, value)
        return

    def __repr__(self):
        repr = "Basic object (type='" + self.objecttype + "', index=" + str(self.objectreference)
        if len(self.name) > 0: repr += ", name='" + self.name + "'"
        return repr + ")"

    def _Reset(self, propertyname, basicreturn = None):
        """ force new value or erase properties from dictionary (done to optimize calls to Basic scripts) """
        if propertyname in ('BOF', 'EOF'):
            # After a Move method invocation on a Recordset object, BOF or EOF likely to be got soon
            if isinstance(basicreturn, int):
                self.internal = True
                # f.i. basicreturn = 0b10 means: BOF = True, EOF = False
                self.BOF = basicreturn in (2, 3, -2, -3)
                self.EOF = basicreturn in (1, 3, -1, -3)
                self.internal = False
                return ( basicreturn >= 0 )
        else:
            # Suppress possibly invalid property values: e.g. RecordCount after Delete applied on Recordset object
            if property in self.__dict__:
                del(self.propertyname)
        return basicreturn

    @property
    def Name(self): return self.name
    @property
    def ObjectType(self): return self.objecttype

    def Dispose(self):
        return self.W(_vbMethod, self.objectreference, 'Dispose')
    def getProperty(self, propertyname, index = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'getProperty', propertyname, index)
    GetProperty = getProperty
    def hasProperty(self, propertyname):
        return propertyname in tuple(self.classProperties.keys())
    HasProperty = hasProperty
    def Properties(self, index = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'Properties', index)
    def setProperty(self, propertyname, value, index = acConstants.Missing):
        if self.hasProperty(propertyname):
            if self.W(_vbMethod, self.objectreference, 'setProperty', propertyname, value, index):
                return self.__setattr__(propertyname, value)
        raise AttributeError("type object '" + self.objecttype + "' has no editable attribute '" + propertyname + "'")
    SetProperty = setProperty


class _Collection(_BasicObject):
    """ Collection object built as a Python iterator """
    classProperties = dict(Count = False)
    def __init__(self, reference = -1, objtype = None):
        super().__init__(reference, objtype)
        self.localProperties = ('count', 'index')
        self.count = self.Count
        self.index = 0
    def __iter__(self):
        self.index = 0
        return self
    def __next__(self):
        if self.index >= self.count:
            raise StopIteration
        next = self.Item(self.index)
        self.index = self.index + 1
        return next
    def __len__(self):
        return self.count

    def Add(self, table, value = acConstants.Missing):
        if isinstance(table, _BasicObject):     # Add method applied to a TABLEDEFS collection
            return self.W(_vbMethod, self.objectreference, 'Add', table.objectreference)
        else:                                   # Add method applied to a TEMPVARS collection
            add = self.W(_vbMethod, self.objectreference, 'Add', table, value)
            self.count = self.Count
            return add
    def Delete(self, name):
        return self.W(_vbMethod, self.objectreference, 'Delete', name)
    def Item(self, index):
        return self.W(_vbMethod, self.objectreference, 'Item', index)
    def Remove(self, tempvarname):
        remove = self.W(_vbMethod, self.objectreference, 'Remove', tempvarname)
        self.count = self.Count
        return remove
    def RemoveAll(self):
        remove = self.W(_vbMethod, self.objectreference, 'RemoveAll')
        self.count = self.Count
        return remove


class _CommandBar(_BasicObject):
    classProperties = dict(BuiltIn = False, Parent = False, Visible = True)

    def CommandBarControls(self, index = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'CommandBarControls', index)
    def Reset(self):
        return self.W(_vbMethod, self.objectreference, 'Reset')


class _CommandBarControl(_BasicObject):
    classProperties = dict(BeginGroup = False, BuiltIn = False, Caption = True, Index = False, OnAction = True
                        , Parent = False, TooltipText = True, Type = False, Visible = True)

    def Execute(self):
        return self.W(_vbMethod, self.objectreference, 'Execute')


class _Control(_BasicObject):
    classProperties = dict(BackColor = True, BorderColor = True, BorderStyle = True, Cancel = True, Caption = True
                        , ControlSource = False, ControlTipText = True, ControlType = False, Default = True
                        , DefaultValue = True, Enabled = True, FontBold = True, FontItalic = True, FontName = True
                        , FontSize = True, FontUnderline = True, FontWeight = True, ForeColor = True, Form = False
                        , Format = True, ItemData = False, ListCount = False, ListIndex = True, Locked = True, MultiSelect = True
                        , OnActionPerformed = True, OnAdjustmentValueChanged = True, OnApproveAction = True
                        , OnApproveReset = True, OnApproveUpdate = True, OnChanged = True, OnErrorOccurred = True
                        , OnFocusGained = True, OnFocusLost = True, OnItemStateChanged = True, OnKeyPressed = True
                        , OnKeyReleased = True, OnMouseDragged = True, OnMouseEntered = True, OnMouseExited = True
                        , OnMouseMoved = True, OnMousePressed = True, OnMouseReleased = True, OnResetted = True, OnTextChanged = True
                        , OnUpdated = True, OptionValue = False, Page = False, Parent = False, Picture = True, Required = True
                        , RowSource = True, RowSourceType = True, Selected = True, SelLength = True, SelStart = True, SelText = True
                        , SubType = False, TabIndex = True, TabStop = True, Tag = True, Text = False, TextAlign = True
                        , TripleState = True, Value = True, Visible = True
                        )

    @property
    def BoundField(self): return self.W(_vbUNO, self.objectreference, 'BoundField')
    @property
    def ControlModel(self): return self.W(_vbUNO, self.objectreference, 'ControlModel')
    @property
    def ControlView(self): return self.W(_vbUNO, self.objectreference, 'ControlView')
    @property
    def LabelControl(self): return self.W(_vbUNO, self.objectreference, 'LabelControl')

    def AddItem(self, value, index = -1):
        basicreturn = self.W(_vbMethod, self.objectreference, 'AddItem', value, index)
        self._Reset('ItemData')
        self._Reset('ListCount')
        return basicreturn
    def Controls(self, index = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'Controls', index)
    # Overrides method in parent class: list of properties is strongly control type dependent
    def hasProperty(self, propertyname):
        return self.W(_vbMethod, self.objectreference, 'hasProperty', propertyname)
    HasProperty = hasProperty
    def RemoveItem(self, index):
        basicreturn = self.W(_vbMethod, self.objectreference, 'RemoveItem', index)
        self._Reset('ItemData')
        self._Reset('ListCount')
        return basicreturn
    def Requery(self):
        return self.W(_vbMethod, self.objectreference, 'Requery')
    def SetSelected(self, value, index):
        return self.W(_vbMethod, self.objectreference, 'SetSelected', value, index)
    def SetFocus(self):
        return self.W(_vbMethod, self.objectreference, 'SetFocus')


class _Database(_BasicObject):
    classProperties = dict(Connect = False, OnCreate = True
                        , OnFocus = True, OnLoad = True, OnLoadFinished = True, OnModifyChanged = True, OnNew = True
                        , OnPrepareUnload = True, OnPrepareViewClosing = True, OnSave = True, OnSaveAs = True
                        , OnSaveAsDone = True, OnSaveAsFailed = True, OnSaveDone = True, OnSaveFailed = True
                        , OnSubComponentClosed = True, OnSubComponentOpened = True, OnTitleChanged = True, OnUnfocus = True
                        , OnUnload = True, OnViewClosed = True, OnViewCreated = True, Version = False
                        )

    @property
    def Connection(self): return self.W(_vbUNO, self.objectreference, 'Connection')
    @property
    def Document(self): return self.W(_vbUNO, self.objectreference, 'Document')
    @property
    def MetaData(self): return self.W(_vbUNO, self.objectreference, 'MetaData')

    def Close(self):
        return self.W(_vbMethod, self.objectreference, 'Close')
    def CloseAllRecordsets(self):
        return self.W(_vbMethod, self.objectreference, 'CloseAllRecordsets')
    def CreateQueryDef(self, name, sqltext, option = -1):
        return self.W(_vbMethod, self.objectreference, 'CreateQueryDef', name, sqltext, option)
    def CreateTableDef(self, name):
        return self.W(_vbMethod, self.objectreference, 'CreateTableDef', name)
    def DAvg(self, expression, domain, criteria = ''):
        return self.W(_vbMethod, self.objectreference, 'DAvg', expression, domain, criteria)
    def DCount(self, expression, domain, criteria = ''):
        return self.W(_vbMethod, self.objectreference, 'DCount', expression, domain, criteria)
    def DLookup(self, expression, domain, criteria = '', orderclause = ''):
        return self.W(_vbMethod, self.objectreference, 'DLookup', expression, domain, criteria, orderclause)
    def DMax(self, expression, domain, criteria = ''):
        return self.W(_vbMethod, self.objectreference, 'DMax', expression, domain, criteria)
    def DMin(self, expression, domain, criteria = ''):
        return self.W(_vbMethod, self.objectreference, 'DMin', expression, domain, criteria)
    def DStDev(self, expression, domain, criteria = ''):
        return self.W(_vbMethod, self.objectreference, 'DStDev', expression, domain, criteria)
    def DStDevP(self, expression, domain, criteria = ''):
        return self.W(_vbMethod, self.objectreference, 'DStDevP', expression, domain, criteria)
    def DVar(self, expression, domain, criteria = ''):
        return self.W(_vbMethod, self.objectreference, 'DVar', expression, domain, criteria)
    def DVarP(self, expression, domain, criteria = ''):
        return self.W(_vbMethod, self.objectreference, 'DVarP', expression, domain, criteria)
    def OpenRecordset(self, source, type = -1, option = -1, lockedit = -1):
        return self.W(_vbMethod, self.objectreference, 'OpenRecordset', source, type, option, lockedit)
    def OpenSQL(self, SQL, option = -1):
        return self.W(_vbMethod, self.objectreference, 'OpenSQL', SQL, option)
    def OutputTo(self, objecttype, objectname = '', outputformat = '', outputfile = '', autostart = False, templatefile = ''
        , encoding = acConstants.acUTF8Encoding, quality = acConstants.acExportQualityPrint):
        if objecttype == acConstants.acOutputForm: encoding = 0
        return self.W(_vbMethod, self.objectreference, 'OutputTo', objecttype, objectname, outputformat, outputfile
                      , autostart, templatefile, encoding, quality)
    def QueryDefs(self, index = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'QueryDefs', index)
    def Recordsets(self, index = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'Recordsets', index)
    def RunSQL(self, SQL, option = -1):
        return self.W(_vbMethod, self.objectreference, 'RunSQL', SQL, option)
    def TableDefs(self, index = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'TableDefs', index)


class _Dialog(_BasicObject):
    classProperties = dict(Caption = True, Height = True, IsLoaded = False, OnFocusGained = True
                        , OnFocusLost = True, OnKeyPressed = True, OnKeyReleased = True, OnMouseDragged = True
                        , OnMouseEntered = True, OnMouseExited = True, OnMouseMoved = True, OnMousePressed = True
                        , OnMouseReleased = True, Page = True, Parent = False, Visible = True, Width = True
                        )

    @property
    def UnoDialog(self): return self.W(_vbUNO, self.objectreference, 'UnoDialog')

    def EndExecute(self, returnvalue):
        return self.W(_vbMethod, self.objectreference, 'EndExecute', returnvalue)
    def Execute(self):
        return self.W(_vbMethod, self.objectreference, 'Execute')
    def Move(self, left = -1, top = -1, width = -1, height = -1):
        return self.W(_vbMethod, self.objectreference, 'Move', left, top, width, height)
    def OptionGroup(self, groupname):
        return self.W(_vbMethod, self.objectreference, 'OptionGroup', groupname)
    def Start(self):
        return self.W(_vbMethod, self.objectreference, 'Start')
    def Terminate(self):
        return self.W(_vbMethod, self.objectreference, 'Terminate')

class _Event(_BasicObject):
    classProperties = dict(ButtonLeft = False, ButtonMiddle = False, ButtonRight = False, ClickCount = False
                    , ContextShortcut = False, EventName = False, EventType = False, FocusChangeTemporary = False
                    , KeyAlt = False, KeyChar = False, KeyCode = False, KeyCtrl = False, KeyFunction = False, KeyShift = False
                    , Recommendation = False, RowChangeAction = False, Source = False, SubComponentName = False
                    , SubComponentType = False, XPos = False, YPos = False
                    )


class _Field(_BasicObject):
    classProperties = dict(DataType = False, DataUpdatable = False, DbType = False, DefaultValue = True
                        , Description = True, FieldSize = False, Size = False, Source = False
                        , SourceField = False, SourceTable = False, TypeName = False, Value = True
                        )

    @property
    def Column(self): return self.W(_vbUNO, self.objectreference, 'Column')

    def AppendChunk(self, value):
        return self.W(_vbMethod, self.objectreference, 'AppendChunk', value)
    def GetChunk(self, offset, numbytes):
        return self.W(_vbMethod, self.objectreference, 'GetChunk', offset, numbytes)
    def ReadAllBytes(self, file):
        return self.W(_vbMethod, self.objectreference, 'ReadAllBytes', file)
    def ReadAllText(self, file):
        return self.W(_vbMethod, self.objectreference, 'ReadAllText', file)
    def WriteAllBytes(self, file):
        return self.W(_vbMethod, self.objectreference, 'WriteAllBytes', file)
    def WriteAllText(self, file):
        return self.W(_vbMethod, self.objectreference, 'WriteAllText', file)


class _Form(_BasicObject):
    classProperties = dict(AllowAdditions = True, AllowDeletions = True, AllowEdits = True, Bookmark = True
                        , Caption = True, CurrentRecord = True, Filter = True, FilterOn = True, Height = True
                        , IsLoaded = False, OnApproveCursorMove = True, OnApproveParameter = True, OnApproveReset = True
                        , OnApproveRowChange = True, OnApproveSubmit = True, OnConfirmDelete = True, OnCursorMoved = True
                        , OnErrorOccurred = True, OnLoaded = True, OnReloaded = True, OnReloading = True, OnResetted = True
                        , OnRowChanged = True, OnUnloaded = True, OnUnloading = True, OpenArgs = False, OrderBy = True
                        , OrderByOn = True, Parent = False, Recordset = False, RecordSource = True, Visible = True
                        , Width = True
                        )

    @property
    def Component(self): return self.W(_vbUNO, self.objectreference, 'Component')
    @property
    def ContainerWindow(self): return self.W(_vbUNO, self.objectreference, 'ContainerWindow')
    @property
    def DatabaseForm(self): return self.W(_vbUNO, self.objectreference, 'DatabaseForm')

    def Close(self):
        return self.W(_vbMethod, self.objectreference, 'Close')
    def Controls(self, index = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'Controls', index)
    def Move(self, left = -1, top = -1, width = -1, height = -1):
        return self.W(_vbMethod, self.objectreference, 'Move', left, top, width, height)
    def OptionGroup(self, groupname):
        return self.W(_vbMethod, self.objectreference, 'OptionGroup', groupname)
    def Refresh(self):
        return self.W(_vbMethod, self.objectreference, 'Refresh')
    def Requery(self):
        return self.W(_vbMethod, self.objectreference, 'Requery')
    def SetFocus(self):
        return self.W(_vbMethod, self.objectreference, 'SetFocus')


class _Module(_BasicObject):
    classProperties = dict(CountOfDeclarationLines = False, CountOfLines = False
                        , ProcStartLine = False, Type = False
                        )
    def __init__(self, reference = -1, objtype = None, name = ''):
        super().__init__(reference, objtype, name)
        self.localProperties = ('startline', 'startcolumn', 'endline', 'endcolumn', 'prockind')

    def Find(self, target, startline, startcolumn, endline, endcolumn, wholeword = False
        , matchcase = False, patternsearch = False):
        Returned = self.W(_vbMethod, self.objectreference, 'Find', target, startline, startcolumn, endline
                      , endcolumn, wholeword, matchcase, patternsearch)
        if isinstance(Returned, tuple):
            if Returned[0] == True and len(Returned) == 5:
                self.startline = Returned[1]
                self.startcolumn = Returned[2]
                self.endline = Returned[3]
                self.endcolumn = Returned[4]
            return Returned[0]
        return Returned
    def Lines(self, line, numlines):
        return self.W(_vbMethod, self.objectreference, 'Lines', line, numlines)
    def ProcBodyLine(self, procname, prockind):
        return self.W(_vbMethod, self.objectreference, 'ProcBodyLine', procname, prockind)
    def ProcCountLines(self, procname, prockind):
        return self.W(_vbMethod, self.objectreference, 'ProcCountLines', procname, prockind)
    def ProcOfLine(self, line, prockind):
        Returned = self.W(_vbMethod, self.objectreference, 'ProcOfLine', line, prockind)
        if isinstance(Returned, tuple):
            if len(Returned) == 2:
                self.prockind = Returned[1]
                return Returned[0]
        return Returned
    def ProcStartLine(self, procname, prockind):
        return self.W(_vbMethod, self.objectreference, 'ProcStartLine', procname, prockind)


class _OptionGroup(_BasicObject):
    classProperties = dict(Count = False, Value = True)

    def Controls(self, index = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'Controls', index)


class _Property(_BasicObject):
    classProperties = dict(Value = True)


class _QueryDef(_BasicObject):
    classProperties = dict(SQL = True, Type = False)

    @property
    def Query(self): return self.W(_vbUNO, self.objectreference, 'Query')

    def Execute(self, options = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'Execute', options)
    def Fields(self, index = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'Fields', index)
    def OpenRecordset(self, type = -1, option = -1, lockedit = -1):
        return self.W(_vbMethod, self.objectreference, 'OpenRecordset', type, option, lockedit)


class _Recordset(_BasicObject):
    classProperties = dict(AbsolutePosition = True, BOF = False, Bookmark = True, Bookmarkable = False
                        , EditMode = False, EOF = False, Filter = True, RecordCount = False
                        )

    @property
    def RowSet(self): return self.W(_vbUNO, self.objectreference, 'RowSet')

    def AddNew(self):
        return self.W(_vbMethod, self.objectreference, 'AddNew')
    def CancelUpdate(self):
        return self.W(_vbMethod, self.objectreference, 'CancelUpdate')
    def Clone(self):
        return self.W(_vbMethod, self.objectreference, 'Clone')
    def Close(self):
        return self.W(_vbMethod, self.objectreference, 'Close')
    def Delete(self):
        return self._Reset('RecordCount',self.W(_vbMethod, self.objectreference, 'Delete'))
    def Edit(self):
        return self.W(_vbMethod, self.objectreference, 'Edit')
    def Fields(self, index = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'Fields', index)
    def GetRows(self, numrows):
        return self.W(_vbMethod, self.objectreference, 'GetRows', numrows)
    def Move(self, rows, startbookmark = acConstants.Missing):
        return self._Reset('BOF', self.W(_vbMethod, self.objectreference, 'Move', rows, startbookmark))
    def MoveFirst(self):
        return self._Reset('BOF', self.W(_vbMethod, self.objectreference, 'MoveFirst'))
    def MoveLast(self):
        return self._Reset('BOF', self.W(_vbMethod, self.objectreference, 'MoveLast'))
    def MoveNext(self):
        return self._Reset('BOF', self.W(_vbMethod, self.objectreference, 'MoveNext'))
    def MovePrevious(self):
        return self._Reset('BOF', self.W(_vbMethod, self.objectreference, 'MovePrevious'))
    def OpenRecordset(self, type = -1, option = -1, lockedit = -1):
        return self.W(_vbMethod, self.objectreference, 'OpenRecordset', type, option, lockedit)
    def Update(self):
        return self._Reset('RecordCount',self.W(_vbMethod, self.objectreference, 'Update'))


class _SubForm(_Form):
    classProperties = dict(AllowAdditions = True, AllowDeletions = True, AllowEdits = True, CurrentRecord = True
                        , Filter = True, FilterOn = True, LinkChildFields = False, LinkMasterFields = False
                        , OnApproveCursorMove = True, OnApproveParameter = True, OnApproveReset = True
                        , OnApproveRowChange = True, OnApproveSubmit = True, OnConfirmDelete = True, OnCursorMoved = True
                        , OnErrorOccurred = True, OnLoaded = True, OnReloaded = True, OnReloading = True, OnResetted = True
                        , OnRowChanged = True, OnUnloaded = True, OnUnloading = True, OrderBy = True
                        , OrderByOn = True, Parent = False, Recordset = False, RecordSource = True, Visible = True
                        )

    def SetFocus(self):
        raise AttributeError("type object 'SubForm' has no method 'SetFocus'")


class _TableDef(_BasicObject):
    classProperties = dict()

    @property
    def Table(self): return self.W(_vbUNO, self.objectreference, 'Table')

    def CreateField(self, name, type, size = 0, attributes = 0):
        return self.W(_vbMethod, self.objectreference, 'CreateField', name, type, size, attributes)
    def Fields(self, index = acConstants.Missing):
        return self.W(_vbMethod, self.objectreference, 'Fields', index)
    def OpenRecordset(self, type = -1, option = -1, lockedit = -1):
        return self.W(_vbMethod, self.objectreference, 'OpenRecordset', type, option, lockedit)


class _TempVar(_BasicObject):
    classProperties = dict(Value = True)

"""
Set of directly callable error handling methods
"""
def DebugPrint(*args):
    dargs = ()
    for arg in args:
        if isinstance(arg, _BasicObject):
            arg = ('[' + arg.objecttype + '] ' + arg.name).rstrip()
        dargs = dargs + (arg,)
    return _A2B.invokeMethod('DebugPrint', _WRAPPERMODULE, *dargs)
def TraceConsole(): return _A2B.invokeMethod('TraceConsole', 'Trace')
def TraceError(tracelevel, errorcode, errorprocedure, errorline):
    return _A2B.invokeMethod('TraceError', 'Trace', tracelevel, errorcode, errorprocedure, errorline)
def TraceLevel(newtracelevel = 'ERROR'): return _A2B.invokeMethod('TraceLevel', 'Trace', newtracelevel)
def TraceLog(tracelevel, text, messagebox = True):
    return _A2B.invokeMethod('TraceLog', 'Trace', tracelevel, text, messagebox)

