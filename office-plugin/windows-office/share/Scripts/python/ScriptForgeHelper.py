# -*- coding: utf-8 -*-

# Copyright 2019-2020 Jean-Pierre LEDURE, Jean-François NIFENECKER, Alain ROMEDENNE

# ======================================================================================================================
# ===           The ScriptForge library and its associated libraries are part of the LibreOffice project.            ===
# ===                   Full documentation is available on https://help.libreoffice.org/                             ===
# ======================================================================================================================

#    ScriptForge is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

#    ScriptForge is free software; you can redistribute it and/or modify it under the terms of either (at your option):

#    1) The Mozilla Public License, v. 2.0. If a copy of the MPL was not
#    distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0/ .

#    2) The GNU Lesser General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version. If a copy of the LGPL was not
#    distributed with this file, see http://www.gnu.org/licenses/ .

"""
Collection of Python helper functions called from the ScriptForge Basic libraries
to execute specific services that are not or not easily available from Basic directly.
"""

import getpass
import os
import platform
import hashlib
import filecmp
import webbrowser
import json


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


# #################################################################
# Dictionary service
# #################################################################

def _SF_Dictionary__ConvertToJson(propval, indent = None) -> str:
    # used by Dictionary.ConvertToJson() Basic method
    """
    Given an array of PropertyValues as argument, convert it to a JSON string
    """
    #   Array of property values => Dict(ionary) => JSON
    pvDict = {}
    for pv in propval:
        pvDict[pv.Name] = pv.Value
    return json.dumps(pvDict, indent=indent, skipkeys=True)


def _SF_Dictionary__ImportFromJson(jsonstr: str):  # used by Dictionary.ImportFromJson() Basic method
    """
    Given a JSON string as argument, convert it to a list of tuples (name, value)
    The value must not be a (sub)dict. This doesn't pass the python-basic bridge.
    """
    #   JSON => Dictionary => Array of tuples/lists
    dico = json.loads(jsonstr)
    result = []
    for key in iter(dico):
        value = dico[key]
        item = value
        if isinstance(value, dict):  # check that first level is not itself a (sub)dict
            item = None
        elif isinstance(value, list):  # check every member of the list is not a (sub)dict
            for i in range(len(value)):
                if isinstance(value[i], dict): value[i] = None
        result.append((key, item))
    return result


# #################################################################
# FileSystem service
# #################################################################

def _SF_FileSystem__CompareFiles(filename1: str, filename2: str, comparecontents=True) -> bool:
    # used by SF_FileSystem.CompareFiles() Basic method
    """
    Compare the 2 files, returning True if they seem equal, False otherwise.
    By default, only their signatures (modification time, ...) are compared.
    When comparecontents == True, their contents are compared.
    """
    try:
        return filecmp.cmp(filename1, filename2, not comparecontents)
    except Exception:
        return False


def _SF_FileSystem__GetFilelen(systemfilepath: str) -> str:  # used by SF_FileSystem.GetFilelen() Basic method
    return str(os.path.getsize(systemfilepath))


def _SF_FileSystem__HashFile(filename: str, algorithm: str) -> str:  # used by SF_FileSystem.HashFile() Basic method
    """
    Hash a given file with the given hashing algorithm
    cfr. https://www.pythoncentral.io/hashing-files-with-python/
    Example
        hash = _SF_FileSystem__HashFile('myfile.txt','MD5')
    """
    algo = algorithm.lower()
    try:
        if algo in hashlib.algorithms_guaranteed:
            BLOCKSIZE = 65535    # Provision for large size files
            if algo == 'md5':
                hasher = hashlib.md5()
            elif algo == 'sha1':
                hasher = hashlib.sha1()
            elif algo == 'sha224':
                hasher = hashlib.sha224()
            elif algo == 'sha256':
                hasher = hashlib.sha256()
            elif algo == 'sha384':
                hasher = hashlib.sha384()
            elif algo == 'sha512':
                hasher = hashlib.sha512()
            else:
                return ''
            with open(filename, 'rb') as file:   # open in binary mode
                buffer = file.read(BLOCKSIZE)
                while len(buffer) > 0:
                    hasher.update(buffer)
                    buffer = file.read(BLOCKSIZE)
            return hasher.hexdigest()
        else:
            return ''
    except Exception:
        return ''


# #################################################################
# Platform service
# #################################################################

def _SF_Platform(propertyname: str):       # used by SF_Platform Basic module
    """
    Switch between SF_Platform properties (read the documentation about the ScriptForge.Platform service)
    """
    pf = Platform()
    if propertyname == 'Architecture':
        return pf.Architecture
    elif propertyname == 'ComputerName':
        return pf.ComputerName
    elif propertyname == 'CPUCount':
        return pf.CPUCount
    elif propertyname == 'CurrentUser':
        return pf.CurrentUser
    elif propertyname == 'Machine':
        return pf.Machine
    elif propertyname == 'OSName':
        return pf.OSName
    elif propertyname == 'OSPlatform':
        return pf.OSPlatform
    elif propertyname == 'OSRelease':
        return pf.OSRelease
    elif propertyname == 'OSVersion':
        return pf.OSVersion
    elif propertyname == 'Processor':
        return pf.Processor
    else:
        return None


class Platform(object, metaclass = _Singleton):
    @property
    def Architecture(self): return platform.architecture()[0]

    @property  # computer's network name
    def ComputerName(self): return platform.node()

    @property  # number of CPU's
    def CPUCount(self): return os.cpu_count()

    @property
    def CurrentUser(self):
        try:
            return getpass.getuser()
        except Exception:
            return ''

    @property  # machine type e.g. 'i386'
    def Machine(self): return platform.machine()

    @property  # system/OS name e.g. 'Darwin', 'Java', 'Linux', ...
    def OSName(self): return platform.system().replace('Darwin', 'macOS')

    @property  # underlying platform e.g. 'Windows-10-...'
    def OSPlatform(self): return platform.platform(aliased = True)

    @property  # system's release e.g. '2.2.0'
    def OSRelease(self): return platform.release()

    @property  # system's version
    def OSVersion(self): return platform.version()

    @property  # real processor name e.g. 'amdk'
    def Processor(self): return platform.processor()


# #################################################################
# Session service
# #################################################################

def _SF_Session__OpenURLInBrowser(url: str):    # Used by SF_Session.OpenURLInBrowser() Basic method
    """
    Display url using the default browser
    """
    try:
        webbrowser.open(url, new = 2)
    finally:
        return None


# #################################################################
# String service
# #################################################################

def _SF_String__HashStr(string: str, algorithm: str) -> str:  # used by SF_String.HashStr() Basic method
    """
    Hash a given UTF-8 string with the given hashing algorithm
    Example
        hash = _SF_String__HashStr('This is a UTF-8 encoded string.','MD5')
    """
    algo = algorithm.lower()
    try:
        if algo in hashlib.algorithms_guaranteed:
            ENCODING = 'utf-8'
            bytestring = string.encode(ENCODING)    # Hashing functions expect bytes, not strings
            if algo == 'md5':
                hasher = hashlib.md5(bytestring)
            elif algo == 'sha1':
                hasher = hashlib.sha1(bytestring)
            elif algo == 'sha224':
                hasher = hashlib.sha224(bytestring)
            elif algo == 'sha256':
                hasher = hashlib.sha256(bytestring)
            elif algo == 'sha384':
                hasher = hashlib.sha384(bytestring)
            elif algo == 'sha512':
                hasher = hashlib.sha512(bytestring)
            else:
                return ''
            return hasher.hexdigest()
        else:
            return ''
    except Exception:
        return ''


if __name__ == "__main__":
    print(_SF_Platform('Architecture'))
    print(_SF_Platform('ComputerName'))
    print(_SF_Platform('CPUCount'))
    print(_SF_Platform('CurrentUser'))
    print(_SF_Platform('Machine'))
    print(_SF_Platform('OSName'))
    print(_SF_Platform('OSPlatform'))
    print(_SF_Platform('OSRelease'))
    print(_SF_Platform('OSVersion'))
    print(_SF_Platform('Processor'))
    #
    print(hashlib.algorithms_guaranteed)
    print(_SF_FileSystem__HashFile('/opt/libreoffice6.4/program/libbootstraplo.so', 'md5'))
    print(_SF_FileSystem__HashFile('/opt/libreoffice6.4/share/Scripts/python/Capitalise.py', 'sha512'))
    #
    print(_SF_String__HashStr('œ∑¡™£¢∞§¶•ªº–≠œ∑´®†¥¨ˆøπ“‘åß∂ƒ©˙∆˚¬', 'MD5'))    # 616eb9c513ad07cd02924b4d285b9987
    #
    # _SF_Session__OpenURLInBrowser('https://docs.python.org/3/library/webbrowser.html')
    #
    js = """
    {"firstName": "John","lastName": "Smith","isAlive": true,"age": 27,
    "address": {"streetAddress": "21 2nd Street","city": "New York","state": "NY","postalCode": "10021-3100"},
    "phoneNumbers": [{"type": "home","number": "212 555-1234"},{"type": "office","number": "646 555-4567"}],
    "children": ["Q", "M", "G", "T"],"spouse": null}
    """
    arr = _SF_Dictionary__ImportFromJson(js)
    print(arr)
