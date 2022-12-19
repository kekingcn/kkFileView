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
from .Desktop import Desktop

from com.sun.star.ui.dialogs.TemplateDescription import \
    FILESAVE_AUTOEXTENSION, FILEOPEN_SIMPLE
from com.sun.star.ui.dialogs.ExtendedFilePickerElementIds import \
    CHECKBOX_AUTOEXTENSION
from com.sun.star.awt import WindowDescriptor
from com.sun.star.awt.WindowClass import MODALTOP
from com.sun.star.lang import IllegalArgumentException
from com.sun.star.awt.VclWindowPeerAttribute import OK

class SystemDialog(object):

    def __init__(self, xMSF, ServiceName, Type):
        try:
            self.xMSF = xMSF
            self.systemDialog = xMSF.createInstance(ServiceName)
            self.xStringSubstitution = self.createStringSubstitution(xMSF)

            # Add a name textbox to the filepicker
            if self.systemDialog is not None:
                if (hasattr(self.systemDialog, "initialize")):
                    self.systemDialog.initialize((Type,))

        except Exception:
            traceback.print_exc()

    @classmethod
    def createStoreDialog(self, xmsf):
        return SystemDialog(
            xmsf, "com.sun.star.ui.dialogs.FilePicker",
                FILESAVE_AUTOEXTENSION)

    def subst(self, path):
        try:
            s = self.xStringSubstitution.substituteVariables(path, False)
            return s
        except Exception:
            traceback.print_exc()
            return path

    def callStoreDialog(self, displayDir, defaultName, sDocuType=None):
        if sDocuType is not None:
            self.addFilterToDialog(defaultName[-3:], sDocuType, True)

        self.sStorePath = None
        try:
            self.systemDialog.setValue(CHECKBOX_AUTOEXTENSION, 0, True)
            self.systemDialog.setDefaultName(defaultName)
            self.systemDialog.setDisplayDirectory(self.subst(displayDir))
            if self.execute(self.systemDialog):
                sPathList = self.systemDialog.getFiles()
                self.sStorePath = sPathList[0]

        except Exception:
            traceback.print_exc()

        return self.sStorePath

    def execute(self, execDialog):
        return execDialog.execute() == 1

    def addFilterToDialog(self, sExtension, filterName, setToDefault):
        try:
            #get the localized filtername
            uiName = self.getFilterUIName(filterName)
            pattern = "*." + sExtension
            #add the filter
            self.addFilter(uiName, pattern, setToDefault)
        except Exception:
            traceback.print_exc()

    def addFilter(self, uiName, pattern, setToDefault):
        try:
            self.systemDialog.appendFilter(uiName, pattern)
            if setToDefault:
                self.systemDialog.setCurrentFilter(uiName)

        except Exception:
            traceback.print_exc()

    '''
    note the result should go through conversion of the product name.
    @param filterName
    @return the UI localized name of the given filter name.
    '''

    def getFilterUIName(self, filterName):
        try:
            oFactory = self.xMSF.createInstance(
                "com.sun.star.document.FilterFactory")
            oObject = oFactory.getByName(filterName)
            xPropertyValue = list(oObject)
            for i in xPropertyValue:
                if i is not None and i.Name == "UIName":
                    return str(i.Value).replace("%productname%", "LibreOffice")

            raise Exception(
                "UIName property not found for Filter " + filterName);
        except Exception:
            traceback.print_exc()
            return None

    @classmethod
    def showErrorBox(self, xMSF, sErrorMessage, AddTag=None, AddString=None):
        sErrorMessage = sErrorMessage.replace("%PRODUCTNAME", "LibreOffice" )
        sErrorMessage = sErrorMessage.replace(str(13), "<BR>")
        if AddTag and AddString:
            sErrorMessage = sErrorMessage.replace( AddString, AddTag)
        return self.showMessageBox(xMSF, "ErrorBox", OK, sErrorMessage)

    '''
    example:
    (xMSF, "ErrorBox", com.sun.star.awt.VclWindowPeerAttribute.OK, "message")

    @param windowServiceName one of the following strings:
    "ErrorBox", "WarningBox", "MessBox", "InfoBox", "QueryBox".
    There are other values possible, look
    under src/toolkit/source/awt/vcltoolkit.cxx
    @param windowAttribute see com.sun.star.awt.VclWindowPeerAttribute
    @return 0 = cancel, 1 = ok, 2 = yes,  3 = no(I'm not sure here)
    other values check for yourself ;-)
    '''
    @classmethod
    def showMessageBox(self, xMSF, windowServiceName, windowAttribute,
            MessageText, peer=None):

        if MessageText is None:
            return 0

        iMessage = 0
        try:
            # If the peer is null we try to get one from the desktop...
            if peer is None:
                xFrame = Desktop.getActiveFrame(xMSF)
                peer = xFrame.getComponentWindow()

            xToolkit = xMSF.createInstance("com.sun.star.awt.Toolkit")
            oDescriptor = WindowDescriptor()
            oDescriptor.WindowServiceName = windowServiceName
            oDescriptor.Parent = peer
            oDescriptor.Type = MODALTOP
            oDescriptor.WindowAttributes = windowAttribute
            xMsgPeer = xToolkit.createWindow(oDescriptor)
            xMsgPeer.MessageText = MessageText
            iMessage = xMsgPeer.execute()
            xMsgPeer.dispose()
        except Exception:
            traceback.print_exc()

        return iMessage

    @classmethod
    def createStringSubstitution(self, xMSF):
        xPathSubst = None
        try:
            xPathSubst = xMSF.createInstance(
                "com.sun.star.util.PathSubstitution")
            return xPathSubst
        except Exception:
            traceback.print_exc()
            return None
