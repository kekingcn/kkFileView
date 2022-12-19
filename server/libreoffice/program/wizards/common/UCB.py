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

import uno
import traceback

from abc import abstractmethod

from ..common.FileAccess import FileAccess

from com.sun.star.beans import Property

from com.sun.star.ucb import Command
from com.sun.star.ucb import GlobalTransferCommandArgument
from com.sun.star.ucb.NameClash import OVERWRITE
from com.sun.star.ucb import OpenCommandArgument2
from com.sun.star.ucb.OpenMode import ALL
from com.sun.star.ucb.TransferCommandOperation import COPY


# This class is used to copy the content of a folder to
# another folder.
# There is an inconsistency with argument order.
# It should be always: dir,filename.
class UCB(object):

    ucb = None
    fa = None
    xmsf = None

    def __init__(self, xmsf):
        self.ucb = xmsf.createInstanceWithArguments("com.sun.star.ucb.UniversalContentBroker", ())
        self.fa = FileAccess(xmsf)
        self.xmsf = xmsf

    def delete(self, filename):
        # System.out.println("UCB.delete(" + filename)
        self.executeCommand(self.getContent(filename),"delete", True)

    def copy(self, sourceDir, targetDir):
        self.copy1(sourceDir,targetDir, None)

    def copy1(self, sourceDir, targetDir, verifier):
        files = self.listFiles(sourceDir, verifier)
        for i in range(len(files)):
          self.copy2(sourceDir, files[i], targetDir, "")

    def copy2(self, sourceDir, filename, targetDir, targetName):
        if (not self.fa.exists(targetDir, True)):
          self.fa.xInterface.createFolder(targetDir)
        self.executeCommand(self.ucb, "globalTransfer", self.copyArg(sourceDir, filename, targetDir, targetName))

    # target name can be PropertyNames.EMPTY_STRING, in which case the name stays lige the source name
    # @param sourceDir
    # @param sourceFilename
    # @param targetDir
    # @param targetFilename
    # @return
    def copyArg(self, sourceDir, sourceFilename, targetDir, targetFilename):
        aArg = GlobalTransferCommandArgument()
        aArg.Operation = COPY
        aArg.SourceURL = self.fa.getURL(sourceDir, sourceFilename)
        aArg.TargetURL = targetDir
        aArg.NewTitle = targetFilename
        # fail, if object with same name exists in target folder
        aArg.NameClash = OVERWRITE
        return aArg

    def executeCommand(self, xContent, aCommandName, aArgument):
        aCommand  = Command()
        aCommand.Name     = aCommandName
        aCommand.Handle   = -1 # not available
        aCommand.Argument = aArgument
        return xContent.execute(aCommand, 0, None)

    def listFiles(self, path, verifier):
        xContent = self.getContent(path)

        aArg = OpenCommandArgument2()
        aArg.Mode = ALL
        aArg.Priority = 32768

        # Fill info for the properties wanted.
        aArg.Properties = (Property(),)

        aArg.Properties[0].Name = "Title"
        aArg.Properties[0].Handle = -1

        xSet = self.executeCommand(xContent, "open", aArg)

        xResultSet = xSet.getStaticResultSet()

        files = []

        if (xResultSet.first()):
            # obtain XContentAccess interface for child content access and XRow for properties
            while (True):
                # Obtain URL of child.
                if (hasattr(xResultSet, "queryContentIdentifierString")):
                    aId = xResultSet.queryContentIdentifierString()
                    aTitle = FileAccess.getFilename(aId)
                elif (hasattr(xResultSet, "getString")):
                    # First column: Title (column numbers are 1-based!)
                    aTitle = xResultSet.getString(1)
                else:
                    aTitle = ""
                #if (len(aTitle) == 0 and xResultSet.wasNull()):
                if (len(aTitle) == 0):
                    # ignore
                    pass
                else:
                    files.append(aTitle)
                if (not xResultSet.next()):
                    break
                # next child
        if (verifier is not None):
            for i in range(len(files)):
                if (not verifier.verify(files[i])):
                    files.pop(i) # FIXME !!! dangerous
        return files

    def getContent(self, path):
        try:
            ident = self.ucb.createContentIdentifier(path)
            return self.ucb.queryContent(ident)
        except Exception:
            traceback.print_exc()
            return None

    class Verifier:
        @abstractmethod
        def verify(object):
            pass

