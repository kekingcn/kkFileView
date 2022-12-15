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
from ..common.PropertyNames import PropertyNames
from ..common.FileAccess import FileAccess
from ..common.SystemDialog import SystemDialog

class PathSelection(object):

    class DialogTypes(object):
        FOLDER = 0
        FILE = 1

    class TransferMode(object):
        SAVE = 0
        LOAD = 1

    def __init__(self, xMSF, CurUnoDialog, TransferMode, DialogType):
        self.CurUnoDialog = CurUnoDialog
        self.xMSF = xMSF
        self.iDialogType = DialogType
        self.iTransferMode = TransferMode
        self.sDefaultDirectory = ""
        self.sDefaultName = ""
        self.sDefaultFilter = ""
        self.usedPathPicker = False
        self.CMDSELECTPATH = 1
        self.TXTSAVEPATH = 1

    def insert(
        self, DialogStep, XPos, YPos, Width,
        CurTabIndex, LabelText, Enabled, TxtHelpURL, BtnHelpURL):

        self.CurUnoDialog.insertControlModel(
            "com.sun.star.awt.UnoControlFixedTextModel", "lblSaveAs",
            (PropertyNames.PROPERTY_ENABLED,
                PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_LABEL,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH),
            (Enabled, 8, LabelText, XPos, YPos, DialogStep,
                CurTabIndex, Width))
        self.xSaveTextBox = self.CurUnoDialog.insertTextField(
            "txtSavePath", "callXPathSelectionListener",
            (PropertyNames.PROPERTY_ENABLED,
                PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_HELPURL,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH),
            (Enabled, 12, TxtHelpURL, XPos, YPos + 10, DialogStep,
                (CurTabIndex + 1), Width - 26), self)

        self.CurUnoDialog.xDialogModel.txtSavePath.Enabled = False
        self.CurUnoDialog.insertButton("cmdSelectPath", "triggerPathPicker",
            (PropertyNames.PROPERTY_ENABLED,
                PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_HELPURL,
                PropertyNames.PROPERTY_LABEL,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH),
            (Enabled, 14, BtnHelpURL, "...",XPos + Width - 16, YPos + 9,
                DialogStep, (CurTabIndex + 2), 16), self)

    def addSelectionListener(self, xAction):
        self.xAction = xAction

    def getSelectedPath(self):
        return self.xSaveTextBox.Text

    def initializePath(self):
        try:
            myFA = FileAccess(self.xMSF)
            self.xSaveTextBox.setText(
                myFA.getPath(self.sDefaultDirectory + \
                    "/" + \
                    self.sDefaultName, None))
        except Exception:
            traceback.print_exc()

    def triggerPathPicker(self):
        try:
            if self.iTransferMode == self.TransferMode.SAVE:
                if self.iDialogType == self.DialogTypes.FOLDER:
                    #TODO: write code for picking a folder for saving
                    return
                elif self.iDialogType == self.DialogTypes.FILE:
                    self.usedPathPicker = True
                    myFilePickerDialog = \
                        SystemDialog.createStoreDialog(self.xMSF)
                    myFilePickerDialog.callStoreDialog(
                        self.sDefaultDirectory,
                        self.sDefaultName, self.sDefaultFilter)
                    sStorePath = myFilePickerDialog.sStorePath
                    if sStorePath is not None:
                        myFA = FileAccess(self.xMSF)
                        self.xSaveTextBox.Text = myFA.getPath(sStorePath, None)
                        self.sDefaultDirectory = \
                            FileAccess.getParentDir(sStorePath)
                        self.sDefaultName = myFA.getFilename(sStorePath)
                    return
            elif self.iTransferMode == self.TransferMode.LOAD:
                if self.iDialogType == self.DialogTypes.FOLDER:
                    #TODO: write code for picking a folder for loading
                    return
                elif self.iDialogType == self.DialogTypes.FILE:
                    #TODO: write code for picking a file for loading
                    return
        except Exception:
            traceback.print_exc()

    def callXPathSelectionListener(self):
            if self.xAction is not None:
                self.xAction.validatePath()      
