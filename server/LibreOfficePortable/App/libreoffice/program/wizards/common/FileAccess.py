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
import traceback

from os import sep as FileSeparator

'''
This class delivers static convenience methods
to use with ucb SimpleFileAccess service.
You can also instantiate the class, to encapsulate
some functionality of SimpleFileAccess. The instance
keeps a reference to an XSimpleFileAccess and an
XFileIdentifierConverter, saves the permanent
overhead of querying for those interfaces, and delivers
convenience methods for using them.
These Convenience methods include mainly Exception-handling.
'''

class FileAccess(object):

    def __init__(self, xmsf):
        #get the file identifier converter
        self.filenameConverter = xmsf.createInstance(
            "com.sun.star.ucb.FileContentProvider")
        self.xInterface = xmsf.createInstance(
                "com.sun.star.ucb.SimpleFileAccess")

    @classmethod
    def deleteLastSlashfromUrl(self, _sPath):
        if _sPath.endswith("/"):
            return _sPath[:-1]
        else:
            return _sPath

    '''
    Further information on arguments value see in OO Developer Guide,
    chapter 6.2.7
    @param xMSF
    @param sPath
    @param xSimpleFileAccess
    @return the respective path of the office application.
    A probable following "/" at the end is trimmed.
    '''

    @classmethod
    def getOfficePath(self, xMSF, sPath, xSimpleFileAccess):
        try:
            ResultPath = ""
            xInterface = xMSF.createInstance("com.sun.star.util.PathSettings")
            ResultPath = str(getattr(xInterface, sPath))
            ResultPath = self.deleteLastSlashfromUrl(ResultPath)
            return ResultPath
        except Exception:
            traceback.print_exc()
            return ""

    @classmethod
    def getFolderTitles(self, xMSF, FilterName, FolderName, resDict=None):
        #Returns and ordered dict containing the template's name and path

        locLayoutFiles = []
        try:
            xDocInterface = xMSF.createInstance(
                "com.sun.star.document.DocumentProperties")
            xInterface = xMSF.createInstance(
                "com.sun.star.ucb.SimpleFileAccess")
            nameList = xInterface.getFolderContents(FolderName, False)
            if FilterName is None or FilterName == "":
                FilterName = None
            else:
                FilterName += "-"

            locLayoutDict = {}
            for i in nameList:
                fileName = self.getFilename(i)
                if FilterName is None or fileName.startswith(FilterName):
                    xDocInterface.loadFromMedium(i, tuple())
                    if resDict is None:
                        title = xDocInterface.Title
                    else:
                        if xDocInterface.Title in resDict:
                            # localise string at runtime
                            title = resDict[xDocInterface.Title]
                        else:
                            title = xDocInterface.Title
                    locLayoutDict[title] = i

            #sort the dictionary and create a list containing the
            #keys list and the values list
            keysList = sorted(locLayoutDict.keys())
            valuesList= []
            for i in keysList:
                valuesList.append(locLayoutDict[i])
            locLayoutFiles.append(keysList)
            locLayoutFiles.append(valuesList)
        except Exception:
            traceback.print_exc()

        return locLayoutFiles

    @classmethod
    def getTitle(self, xMSF, _sFile):
        sTitle = ""
        try:
            xDocInterface = xMSF.createInstance(
                "com.sun.star.document.DocumentProperties")
            noArgs = []
            xDocInterface.loadFromMedium(_sFile, noArgs)
            sTitle = xDocInterface.getTitle()
        except Exception:
            traceback.print_exc()

        return sTitle

    def getPath(self, parentURL, childURL):
        string = ""
        if childURL is not None and childURL != "":
            string = "/" + childURL
        return self.filenameConverter.getSystemPathFromFileURL(
            parentURL + string)

    def copy(self, source, target):
        try:
            self.xInterface.copy(source, target)
            return True
        except Exception:
            traceback.print_exc()
        return False

    def exists(self, filename, default):
        try:
            return self.xInterface.exists(filename)
        except Exception:
            traceback.print_exc()
        return default

    def delete(self, filename):
        try:
            self.xInterface.kill(filename)
            return True
        except Exception:
            traceback.print_exc()
        return False

    # lists the files in a given directory
    # @param dir
    # @param includeFolders
    # @return
    def listFiles(self, folder, includeFolders):
        try:
            return self.xInterface.getFolderContents(folder, includeFolders)
        except Exception:
            traceback.print_exc()
        return [""]

    def getSize(self, url):
        try:
            return self.xInterface.getSize(url)
        except Exception:
            traceback.print_exc()
            return -1

    def getURL(self, parentURL, childPath):
        if len(childPath) > 0 and childPath[0] == "/":
            path = parentURL + childPath
        else:
            path = parentURL + "/" + childPath
        return path

    @classmethod
    def getFilename(self, path, pathSeparator = "/"):
        return path.split(pathSeparator)[-1]

    '''
    if the path points to file, gives the directory in which the file is.
    '''

    @classmethod
    def getParentDir(self, url):
        while url[-1] == "/":
            url = url[:-1]
        return url[:url.rfind("/")]

    @classmethod
    def connectURLs(self, urlFolder, urlFilename):
        stringFolder = ""
        stringFileName = urlFilename
        if not urlFolder.endswith("/"):
            stringFolder = "/"
        if urlFilename.startswith("/"):
            stringFileName = urlFilename[1:]
        return urlFolder + stringFolder + stringFileName

    # @param filename
    # @return the extension of the given filename.
    @classmethod
    def getExtension(self, filename):
        p = filename.find(".")
        if (p == -1):
            return ""
        else:
            while (True):
                filename = filename[(p+1):]
                p = filename.find(".")
                if (p == -1):
                    break
        return filename

    @classmethod
    def filename(self, name, ext, i):
        return name + ("" if (i == 0) else str(i)) + ("" if (ext == "") else ("." + ext))
