# -*- tab-width: 4; indent-tabs-mode: nil; py-indent-offset: 4 -*-
#
# This file is part of the LibreOffice project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This file incorporates work covered by the following license notice:
#
#   Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements. See the NOTICE file distributed
#   with this work for additional information regarding copyright
#   ownership. The ASF licenses this file to you under the Apache
#   License, Version 2.0 (the "License"); you may not use this file
#   except in compliance with the License. You may obtain a copy of
#   the License at http://www.apache.org/licenses/LICENSE-2.0 .
#
import pyuno
import sys
import traceback
import warnings

# since on Windows sal3.dll no longer calls WSAStartup
import socket

# All functions and variables starting with a underscore (_) must be
# considered private and can be changed at any time. Don't use them.
_component_context = pyuno.getComponentContext()


def getComponentContext():
    """Returns the UNO component context used to initialize the Python runtime."""

    return _component_context


def getCurrentContext():
    """Returns the current context.

    See http://udk.openoffice.org/common/man/concept/uno_contexts.html#current_context
    for an explanation on the current context concept.
    """

    return pyuno.getCurrentContext()


def setCurrentContext(newContext):
    """Sets newContext as new UNO context.

    The newContext must implement the XCurrentContext interface. The
    implementation should handle the desired properties and delegate
    unknown properties to the old context. Ensure that the old one
    is reset when you leave your stack, see
    http://udk.openoffice.org/common/man/concept/uno_contexts.html#current_context
    """

    return pyuno.setCurrentContext(newContext)


def getConstantByName(constant):
    """Looks up the value of an IDL constant by giving its explicit name."""

    return pyuno.getConstantByName(constant)


def getTypeByName(typeName):
    """Returns a `uno.Type` instance of the type given by typeName.

    If the type does not exist, a `com.sun.star.uno.RuntimeException` is raised.
    """

    return pyuno.getTypeByName(typeName)


def createUnoStruct(typeName, *args, **kwargs):
    """Creates a UNO struct or exception given by typeName.

    Can be called with:

    1) No additional argument.
       In this case, you get a default constructed UNO structure.
       (e.g. `createUnoStruct("com.sun.star.uno.Exception")`)
    2) Exactly one additional argument that is an instance of typeName.
       In this case, a copy constructed instance of typeName is returned
       (e.g. `createUnoStruct("com.sun.star.uno.Exception" , e)`)
    3) As many additional arguments as the number of elements within typeName
       (e.g. `createUnoStruct("com.sun.star.uno.Exception", "foo error" , self)`).
    4) Keyword arguments to give values for each element of the struct by name.
    5) A mix of 3) and 4), such that each struct element is given a value exactly once,
       either by a positional argument or by a keyword argument.

    The additional and/or keyword arguments must match the type of each struct element,
    otherwise an exception is thrown.
    """

    return getClass(typeName)(*args, **kwargs)


def getClass(typeName):
    """Returns the class of a concrete UNO exception, struct, or interface."""

    return pyuno.getClass(typeName)


def isInterface(obj):
    """Returns True, when obj is a class of a UNO interface."""

    return pyuno.isInterface(obj)


def generateUuid():
    """Returns a 16 byte sequence containing a newly generated uuid or guid.

    For more information, see rtl/uuid.h.
    """

    return pyuno.generateUuid()


def systemPathToFileUrl(systemPath):
    """Returns a file URL for the given system path."""

    return pyuno.systemPathToFileUrl(systemPath)


def fileUrlToSystemPath(url):
    """Returns a system path.

    This path is determined by the system that the Python interpreter is running on.
    """

    return pyuno.fileUrlToSystemPath(url)


def absolutize(path, relativeUrl):
    """Returns an absolute file url from the given urls."""

    return pyuno.absolutize(path, relativeUrl)


class Enum:
    """Represents a UNO enum.

    Use an instance of this class to explicitly pass an enum to UNO.

    :param typeName: The name of the enum as a string.
    :param value: The actual value of this enum as a string.
    """

    def __init__(self, typeName, value):
        self.typeName = typeName
        self.value = value
        pyuno.checkEnum(self)

    def __repr__(self):
        return "<Enum instance %s (%r)>" % (self.typeName, self.value)

    def __eq__(self, that):
        if not isinstance(that, Enum):
            return False

        return (self.typeName == that.typeName) and (self.value == that.value)

    def __ne__(self,other):
        return not self.__eq__(other)


class Type:
    """Represents a UNO type.

    Use an instance of this class to explicitly pass a type to UNO.

    :param typeName: Name of the UNO type
    :param typeClass: Python Enum of TypeClass, see com/sun/star/uno/TypeClass.idl
    """

    def __init__(self, typeName, typeClass):
        self.typeName = typeName
        self.typeClass = typeClass
        pyuno.checkType(self)

    def __repr__(self):
        return "<Type instance %s (%r)>" % (self.typeName, self.typeClass)

    def __eq__(self, that):
        if not isinstance(that, Type):
            return False

        return self.typeClass == that.typeClass and self.typeName == that.typeName

    def __ne__(self,other):
        return not self.__eq__(other)

    def __hash__(self):
        return self.typeName.__hash__()


class Bool(object):
    """Represents a UNO boolean.

    Use an instance of this class to explicitly pass a boolean to UNO.

    Note: This class is deprecated. Use Python's True and False directly instead.
    """

    def __new__(cls, value):
        message = "The Bool class is deprecated. Use Python's True and False directly instead."
        warnings.warn(message, DeprecationWarning)

        if isinstance(value, str) and value == "true":
            return True

        if isinstance(value, str) and value == "false":
            return False

        if value:
            return True

        return False


class Char:
    """Represents a UNO char.

    Use an instance of this class to explicitly pass a char to UNO.

    For Python 2, this class only works with unicode objects. Creating
    a Char instance with a normal str object or comparing a Char instance
    to a normal str object will raise an AssertionError.

    :param value: A Unicode string with length 1
    """

    def __init__(self, value):
        assert isinstance(value, str), "Expected str object, got %s instead." % type(value)

        assert len(value) == 1, "Char value must have length of 1."

        self.value = value

    def __repr__(self):
        return "<Char instance %s>" % (self.value,)

    def __eq__(self, that):
        if isinstance(that, str):
            if len(that) > 1:
                return False

            return self.value == that[0]

        if isinstance(that, Char):
            return self.value == that.value

        return False

    def __ne__(self,other):
        return not self.__eq__(other)


class ByteSequence:
    """Represents a UNO ByteSequence value.

    Use an instance of this class to explicitly pass a byte sequence to UNO.

    :param value: A string or bytesequence
    """

    def __init__(self, value):
        if isinstance(value, bytes):
            self.value = value

        elif isinstance(value, ByteSequence):
            self.value = value.value

        else:
            raise TypeError("Expected bytes object or ByteSequence, got %s instead." % type(value))

    def __repr__(self):
        return "<ByteSequence instance '%s'>" % (self.value,)

    def __eq__(self, that):
        if isinstance(that, bytes):
            return self.value == that

        if isinstance(that, ByteSequence):
            return self.value == that.value

        return False

    def __len__(self):
        return len(self.value)

    def __getitem__(self, index):
        return self.value[index]

    def __iter__(self):
        return self.value.__iter__()

    def __add__(self, b):
        if isinstance(b, bytes):
            return ByteSequence(self.value + b)

        elif isinstance(b, ByteSequence):
            return ByteSequence(self.value + b.value)

        else:
            raise TypeError("Can't add ByteString and %s." % type(b))

    def __hash__(self):
        return self.value.hash()


class Any:
    """Represents a UNO Any value.

    Use only in connection with uno.invoke() to pass an explicit typed Any.
    """

    def __init__(self, type, value):
        if isinstance(type, Type):
            self.type = type
        else:
            self.type = getTypeByName(type)

        self.value = value


def invoke(object, methodname, argTuple):
    """Use this function to pass exactly typed Anys to the callee (using uno.Any)."""

    return pyuno.invoke(object, methodname, argTuple)


# -----------------------------------------------------------------------------
# Don't use any functions beyond this point; private section, likely to change.
# -----------------------------------------------------------------------------
_builtin_import = __import__


def _uno_import(name, *optargs, **kwargs):
    """Overrides built-in import to allow directly importing LibreOffice classes."""

    try:
        return _builtin_import(name, *optargs, **kwargs)
    except ImportError as e:
        # process optargs
        globals, locals, fromlist = list(optargs)[:3] + [kwargs.get('globals', {}), kwargs.get('locals', {}),
                                                         kwargs.get('fromlist', [])][len(optargs):]

        # from import form only, but skip if a uno lookup has already failed
        if not fromlist or hasattr(e, '_uno_import_failed'):
            raise

        # hang onto exception for possible use on subsequent uno lookup failure
        py_import_exc = e

    mod = None
    d = sys.modules

    for module in name.split("."):
        if module in d:
            mod = d[module]
        else:
            # How to create a module ??
            mod = pyuno.__class__(module)

        d = mod.__dict__

    RuntimeException = pyuno.getClass("com.sun.star.uno.RuntimeException")

    for class_name in fromlist:
        if class_name not in d:
            failed = False

            try:
                # check for structs, exceptions or interfaces
                d[class_name] = pyuno.getClass(name + "." + class_name)
            except RuntimeException:
                # check for enums
                try:
                    d[class_name] = Enum(name, class_name)
                except RuntimeException:
                    # check for constants
                    try:
                        d[class_name] = getConstantByName(name + "." + class_name)
                    except RuntimeException:
                        # check for constant group
                        try:
                            d[class_name] = _impl_getConstantGroupByName(name, class_name)
                        except ValueError:
                            failed = True

            if failed:
                # We have an import failure, but cannot distinguish between
                # uno and non-uno errors as uno lookups are attempted for all
                # "from xxx import yyy" imports following a python failure.
                #
                # In Python 3, the original python exception traceback is reused
                # to help pinpoint the actual failing location.  Its original
                # message, unlike Python 2, is unlikely to be helpful for uno
                # failures, as it most commonly is just a top level module like
                # 'com'.  So our exception appends the uno lookup failure.
                # This is more ambiguous, but it plus the traceback should be
                # sufficient to identify a root cause for python or uno issues.
                #
                # Our exception is raised outside of the nested exception
                # handlers above, to avoid Python 3 nested exception
                # information for the RuntimeExceptions during lookups.
                #
                # Finally, a private attribute is used to prevent further
                # processing if this failure was in a nested import.  That
                # keeps the exception relevant to the primary failure point,
                # preventing us from re-processing our own import errors.

                uno_import_exc = ImportError("%s (or '%s.%s' is unknown)" %
                                             (py_import_exc, name, class_name))

                uno_import_exc = uno_import_exc.with_traceback(py_import_exc.__traceback__)

                uno_import_exc._uno_import_failed = True
                raise uno_import_exc

    return mod


try:
    import __builtin__
except ImportError:
    import builtins as __builtin__

# hook into the __import__ chain
__builtin__.__dict__['__import__'] = _uno_import


class _ConstantGroup(object):
    """Represents a group of UNOIDL constants."""

    __slots__ = ['_constants']

    def __init__(self, constants):
        self._constants = constants

    def __dir__(self):
        return self._constants.keys()

    def __getattr__(self, name):
        if name in self._constants:
            return self._constants[name]

        raise AttributeError("The constant '%s' could not be found." % name)


def _impl_getConstantGroupByName(module, group):
    """Gets UNOIDL constant group by name."""

    constants = Enum('com.sun.star.uno.TypeClass', 'CONSTANTS')
    one = Enum('com.sun.star.reflection.TypeDescriptionSearchDepth', 'ONE')
    type_desc_mgr = _component_context.getValueByName('/singletons/com.sun.star.reflection.theTypeDescriptionManager')
    type_descs = type_desc_mgr.createTypeDescriptionEnumeration(module, (constants,), one)
    qualified_name = module + '.' + group

    for type_desc in type_descs:
        if type_desc.Name == qualified_name:
            return _ConstantGroup(dict(
                (c.Name.split('.')[-1], c.ConstantValue)
                for c in type_desc.Constants))

    raise ValueError("The constant group '%s' could not be found." % qualified_name)


def _uno_struct__init__(self, *args, **kwargs):
    """Initializes a UNO struct.

    Referenced from the pyuno shared library.

    This function can be called with either an already constructed UNO struct, which it
    will then just reference without copying, or with arguments to create a new UNO struct.
    """

    # Check to see if this function was passed an existing UNO struct
    if len(kwargs) == 0 and len(args) == 1 and getattr(args[0], "__class__", None) == self.__class__:
        self.__dict__['value'] = args[0]
    else:
        struct, used = pyuno._createUnoStructHelper(self.__class__.__pyunostruct__, args, **kwargs)

        for kwarg in kwargs.keys():
            if not used.get(kwarg):
                RuntimeException = pyuno.getClass("com.sun.star.uno.RuntimeException")
                raise RuntimeException("_uno_struct__init__: unused keyword argument '%s'." % kwarg, None)

        self.__dict__["value"] = struct


def _uno_struct__getattr__(self, name):
    """Gets attribute from UNO struct.

    Referenced from the pyuno shared library.
    """

    return getattr(self.__dict__["value"], name)


def _uno_struct__setattr__(self, name, value):
    """Sets attribute on UNO struct.

    Referenced from the pyuno shared library.
    """

    return setattr(self.__dict__["value"], name, value)


def _uno_struct__repr__(self):
    """Converts a UNO struct to a printable string.

    Referenced from the pyuno shared library.
    """

    return repr(self.__dict__["value"])


def _uno_struct__str__(self):
    """Converts a UNO struct to a string."""

    return str(self.__dict__["value"])

def _uno_struct__ne__(self, other):
    return not self.__eq__(other)

def _uno_struct__eq__(self, that):
    """Compares two UNO structs.

    Referenced from the pyuno shared library.
    """

    if hasattr(that, "value"):
        return self.__dict__["value"] == that.__dict__["value"]

    return False


def _uno_extract_printable_stacktrace(trace):
    """Extracts a printable stacktrace.

    Referenced from pyuno shared lib and pythonscript.py.
    """

    return ''.join(traceback.format_tb(trace))

# vim: set shiftwidth=4 softtabstop=4 expandtab:
