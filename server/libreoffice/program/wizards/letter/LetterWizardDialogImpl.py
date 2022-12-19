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
import os.path
from .LetterWizardDialog import LetterWizardDialog, uno, HelpIds, HID
from .LetterDocument import LetterDocument, BusinessPaperObject
from .CGLetterWizard import CGLetterWizard
from ..common.FileAccess import FileAccess
from ..common.Configuration import Configuration
from ..common.SystemDialog import SystemDialog
from ..common.Desktop import Desktop
from ..ui.PathSelection import PathSelection
from ..ui.event.UnoDataAware import UnoDataAware
from ..ui.event.RadioDataAware import RadioDataAware
from ..ui.event.CommonListener import TerminateListenerProcAdapter
from ..text.TextElement import TextElement
from ..text.TextFieldHandler import TextFieldHandler
from ..document.OfficeDocument import OfficeDocument

from com.sun.star.awt.VclWindowPeerAttribute import YES_NO, DEF_NO
from com.sun.star.util import CloseVetoException
from com.sun.star.view.DocumentZoomType import OPTIMAL
from com.sun.star.document.UpdateDocMode import FULL_UPDATE
from com.sun.star.document.MacroExecMode import ALWAYS_EXECUTE


class LetterWizardDialogImpl(LetterWizardDialog):

    RM_TYPESTYLE = 1
    RM_BUSINESSPAPER = 2
    RM_SENDERRECEIVER = 4
    RM_FOOTER = 5

    def enterStep(self, OldStep, NewStep):
        pass

    def leaveStep(self, OldStep, NewStep):
        pass

    def __init__(self, xmsf):
        super(LetterWizardDialogImpl, self).__init__(xmsf)
        self.lstBusinessStylePos = None
        self.lstPrivateStylePos = None
        self.lstPrivOfficialStylePos = None
        self.xmsf = xmsf
        self.bSaveSuccess = False
        self.filenameChanged = False
        self.BusCompanyLogo = None
        self.BusCompanyAddress = None
        self.BusCompanyAddressReceiver = None
        self.BusFooter = None

    def startWizard(self, xMSF):
        self.running = True
        try:
            #Number of steps on WizardDialog
            self.nMaxStep = 6

            #instantiate The Document Frame for the Preview
            self.terminateListener = TerminateListenerProcAdapter(self.queryTermination)
            self.myLetterDoc = LetterDocument(xMSF, self.terminateListener)

            #create the dialog
            self.drawNaviBar()
            self.buildStep1()
            self.buildStep2()
            self.buildStep3()
            self.buildStep4()
            self.buildStep5()
            self.buildStep6()

            self.initializePaths()
            self.initializeSalutation()
            self.initializeGreeting()

            #special Control fFrameor setting the save Path:
            self.insertPathSelectionControl()

            self.myConfig = CGLetterWizard()

            self.initializeTemplates(xMSF)

            #load the last used settings
            #from the registry and apply listeners to the controls:
            self.initConfiguration()

            if self.myConfig.cp_BusinessLetter.cp_Greeting :
                self.myConfig.cp_BusinessLetter.cp_Greeting = \
                    self.resources.GreetingLabels[0]

            if self.myConfig.cp_BusinessLetter.cp_Salutation:
                self.myConfig.cp_BusinessLetter.cp_Salutation = \
                    self.resources.SalutationLabels[0]

            if self.myConfig.cp_PrivateOfficialLetter.cp_Greeting:
                self.myConfig.cp_PrivateOfficialLetter.cp_Greeting = \
                    self.resources.GreetingLabels[1]

            if self.myConfig.cp_PrivateOfficialLetter.cp_Salutation:
                self.myConfig.cp_PrivateOfficialLetter.cp_Salutation = \
                    self.resources.SalutationLabels[1]

            if self.myConfig.cp_PrivateLetter.cp_Greeting:
                self.myConfig.cp_PrivateLetter.cp_Greeting = \
                    self.resources.GreetingLabels[2]

            if self.myConfig.cp_PrivateLetter.cp_Salutation:
                self.myConfig.cp_PrivateLetter.cp_Salutation = \
                    self.resources.SalutationLabels[2]

            if self.myPathSelection.xSaveTextBox.Text.lower() == "":
                self.myPathSelection.initializePath()

            xContainerWindow = self.myLetterDoc.xFrame.ContainerWindow
            self.createWindowPeer(xContainerWindow)
            self.insertRoadmap()
            self.setConfiguration()
            self.setDefaultForGreetingAndSalutation()
            self.initializeElements()
            self.myLetterDoc.xFrame.ComponentWindow.Enable = False
            self.executeDialogFromComponent(self.myLetterDoc.xFrame)
            self.removeTerminateListener()
            self.closeDocument()
            self.running = False
        except Exception:
            self.removeTerminateListener()
            traceback.print_exc()
            self.running = False
            return

    def cancelWizard(self):
        self.xUnoDialog.endExecute()
        self.running = False

    def finishWizard(self):
        self.switchToStep(self.getCurrentStep(), self.nMaxStep)
        endWizard = True
        try:
            self.sPath = self.myPathSelection.getSelectedPath()
            if not self.sPath or not os.path.exists(self.sPath):
                self.myPathSelection.triggerPathPicker()
                self.sPath = self.myPathSelection.getSelectedPath()

            if not self.filenameChanged:
                    answer = SystemDialog.showMessageBox(
                        self.xMSF, "MessBox", YES_NO + DEF_NO,
                        self.resources.resOverwriteWarning,
                        self.xUnoDialog.Peer)
                    if answer == 3:
                        # user said: no, do not overwrite...
                        endWizard = False
                        return False

            self.myLetterDoc.setWizardTemplateDocInfo(
                self.resources.resLetterWizardDialog_title,
                self.resources.resTemplateDescription)
            self.myLetterDoc.killEmptyUserFields()
            self.myLetterDoc.keepLogoFrame = self.chkUseLogo.State != 0
            if self.chkBusinessPaper.State != 0 \
                    and self.chkPaperCompanyLogo.State != 0:
                self.myLetterDoc.keepLogoFrame = False

            self.myLetterDoc.keepBendMarksFrame = \
                self.chkUseBendMarks.State != 0
            self.myLetterDoc.keepLetterSignsFrame = \
                self.chkUseSigns.State != 0
            self.myLetterDoc.keepSenderAddressRepeatedFrame = \
                self.chkUseAddressReceiver.State != 0
            if self.optBusinessLetter.State:
                if self.chkBusinessPaper.State != 0 \
                        and self.chkCompanyReceiver.State != 0:
                    self.myLetterDoc.keepSenderAddressRepeatedFrame = False

                if self.chkBusinessPaper.State != 0 \
                        and self.chkPaperCompanyAddress.State != 0:
                    self.myLetterDoc.keepAddressFrame = False

            self.myLetterDoc.killEmptyFrames()
            self.bSaveSuccess = \
                OfficeDocument.store(
                    self.xMSF, self.myLetterDoc.xTextDocument,
                    self.sPath, "writer8_template")
            if self.bSaveSuccess:
                self.saveConfiguration()
                xIH = self.xMSF.createInstance(
                    "com.sun.star.comp.uui.UUIInteractionHandler")
                loadValues = list(range(4))
                loadValues[0] = uno.createUnoStruct( \
                    'com.sun.star.beans.PropertyValue')
                loadValues[0].Name = "AsTemplate"
                loadValues[1] = uno.createUnoStruct( \
                    'com.sun.star.beans.PropertyValue')
                loadValues[1].Name = "MacroExecutionMode"
                loadValues[1].Value = ALWAYS_EXECUTE
                loadValues[2] = uno.createUnoStruct( \
                    'com.sun.star.beans.PropertyValue')
                loadValues[2].Name = "UpdateDocMode"
                loadValues[2].Value = FULL_UPDATE
                loadValues[3] = uno.createUnoStruct( \
                    'com.sun.star.beans.PropertyValue')
                loadValues[3].Name = "InteractionHandler"
                loadValues[3].Value = xIH
                if self.bEditTemplate:
                    loadValues[0].Value = False
                else:
                    loadValues[0].Value = True

                oDoc = OfficeDocument.load(
                    Desktop.getDesktop(self.xMSF),
                    self.sPath, "_default", loadValues)
                oDoc.CurrentController.ViewSettings.ZoomType = OPTIMAL
            else:
                pass

        except Exception:
            traceback.print_exc()
        finally:
            if endWizard:
                self.xUnoDialog.endExecute()
                self.running = False

        return True;

    def closeDocument(self):
        try:
            xCloseable = self.myLetterDoc.xFrame
            xCloseable.close(False)
        except CloseVetoException:
            traceback.print_exc()

    def optBusinessLetterItemChanged(self):
        self.lstPrivateStylePos = None
        self.lstPrivOfficialStylePos = None
        self.xDialogModel.lblBusinessStyle.Enabled = True
        self.xDialogModel.lstBusinessStyle.Enabled = True
        self.xDialogModel.chkBusinessPaper.Enabled = True
        self.xDialogModel.lblPrivOfficialStyle.Enabled = False
        self.xDialogModel.lstPrivOfficialStyle.Enabled = False
        self.xDialogModel.lblPrivateStyle.Enabled = False
        self.xDialogModel.lstPrivateStyle.Enabled = False
        self.lstBusinessStyleItemChanged()
        self.enableSenderReceiver()
        self.setPossibleFooter(True)
        if self.myPathSelection.xSaveTextBox.Text.lower() == "":
            self.myPathSelection.initializePath()

    def optPrivOfficialLetterItemChanged(self):
        self.lstBusinessStylePos = None
        self.lstPrivateStylePos = None
        self.xDialogModel.lblBusinessStyle.Enabled = False
        self.xDialogModel.lstBusinessStyle.Enabled = False
        self.xDialogModel.chkBusinessPaper.Enabled = False
        self.xDialogModel.lblPrivOfficialStyle.Enabled = True
        self.xDialogModel.lstPrivOfficialStyle.Enabled = True
        self.xDialogModel.lblPrivateStyle.Enabled = False
        self.xDialogModel.lstPrivateStyle.Enabled = False
        self.lstPrivOfficialStyleItemChanged()
        self.disableBusinessPaper()
        self.disableSenderReceiver()
        self.setPossibleFooter(True)
        if self.myPathSelection.xSaveTextBox.Text.lower() == "":
            self.myPathSelection.initializePath()
        self.myLetterDoc.fillSenderWithUserData()

    def optPrivateLetterItemChanged(self):
        self.lstBusinessStylePos = None
        self.lstPrivOfficialStylePos = None
        self.xDialogModel.lblBusinessStyle.Enabled = False
        self.xDialogModel.lstBusinessStyle.Enabled = False
        self.xDialogModel.chkBusinessPaper.Enabled = False
        self.xDialogModel.lblPrivOfficialStyle.Enabled = False
        self.xDialogModel.lstPrivOfficialStyle.Enabled = False
        self.xDialogModel.lblPrivateStyle.Enabled = True
        self.xDialogModel.lstPrivateStyle.Enabled = True
        self.lstPrivateStyleItemChanged()
        self.disableBusinessPaper()
        self.disableSenderReceiver()
        self.setPossibleFooter(False)
        if self.myPathSelection.xSaveTextBox.Text.lower() == "":
            self.myPathSelection.initializePath()

    def optSenderPlaceholderItemChanged(self):
        self.xDialogModel.lblSenderName.Enabled = False
        self.xDialogModel.lblSenderStreet.Enabled = False
        self.xDialogModel.lblPostCodeCity.Enabled = False
        self.xDialogModel.txtSenderName.Enabled = False
        self.xDialogModel.txtSenderStreet.Enabled = False
        self.xDialogModel.txtSenderPostCode.Enabled = False
        self.xDialogModel.txtSenderState.Enabled = False
        self.xDialogModel.txtSenderCity.Enabled = False
        self.myLetterDoc.fillSenderWithUserData()

    def optSenderDefineItemChanged(self):
        self.xDialogModel.lblSenderName.Enabled = True
        self.xDialogModel.lblSenderStreet.Enabled = True
        self.xDialogModel.lblPostCodeCity.Enabled = True
        self.xDialogModel.txtSenderName.Enabled = True
        self.xDialogModel.txtSenderStreet.Enabled = True
        self.xDialogModel.txtSenderPostCode.Enabled = True
        self.xDialogModel.txtSenderState.Enabled = True
        self.xDialogModel.txtSenderCity.Enabled = True
        self.txtSenderNameTextChanged()
        self.txtSenderStreetTextChanged()
        self.txtSenderPostCodeTextChanged()
        self.txtSenderStateTextChanged()
        self.txtSenderCityTextChanged()

    def lstBusinessStyleItemChanged(self):
        selectedItemPos = self.lstBusinessStyle.SelectedItemPos
        if self.lstBusinessStylePos != selectedItemPos:
            self.lstBusinessStylePos = selectedItemPos
            self.myLetterDoc.loadAsPreview(
                self.BusinessFiles[1][selectedItemPos], False)
            self.initializeElements()
            self.chkBusinessPaperItemChanged()
            self.setElements(False)
            self.drawConstants()

    def lstPrivOfficialStyleItemChanged(self):
        selectedItemPos = self.lstPrivOfficialStyle.SelectedItemPos
        if self.lstPrivOfficialStylePos != selectedItemPos:
            self.lstPrivOfficialStylePos = selectedItemPos
            self.myLetterDoc.loadAsPreview(
                self.OfficialFiles[1][selectedItemPos], False)
            self.initializeElements()
            self.setPossibleSenderData(True)
            self.setElements(False)
            self.drawConstants()

    def lstPrivateStyleItemChanged(self):
        selectedItemPos = self.lstPrivateStyle.SelectedItemPos
        if self.lstPrivateStylePos != selectedItemPos:
            self.lstPrivateStylePos = selectedItemPos
            self.myLetterDoc.xTextDocument = \
            self.myLetterDoc.loadAsPreview(
                self.PrivateFiles[1][selectedItemPos], False)
            self.initializeElements()
            self.setElements(True)

    def numLogoHeightTextChanged(self):
        self.BusCompanyLogo.iHeight = int(self.numLogoHeight.Value * 1000)
        self.BusCompanyLogo.setFramePosition()

    def numLogoWidthTextChanged(self):
        self.BusCompanyLogo.iWidth = int(self.numLogoWidth.Value * 1000)
        self.BusCompanyLogo.setFramePosition()

    def numLogoXTextChanged(self):
        self.BusCompanyLogo.iXPos = int(self.numLogoX.Value * 1000)
        self.BusCompanyLogo.setFramePosition()

    def numLogoYTextChanged(self):
        self.BusCompanyLogo.iYPos = int(self.numLogoY.Value * 1000)
        self.BusCompanyLogo.setFramePosition()

    def numAddressWidthTextChanged(self):
        self.BusCompanyAddress.iWidth = int(self.numAddressWidth.Value * 1000)
        self.BusCompanyAddress.setFramePosition()

    def numAddressXTextChanged(self):
        self.BusCompanyAddress.iXPos = int(self.numAddressX.Value * 1000)
        self.BusCompanyAddress.setFramePosition()

    def numAddressYTextChanged(self):
        self.BusCompanyAddress.iYPos = int(self.numAddressY.Value * 1000)
        self.BusCompanyAddress.setFramePosition()

    def numAddressHeightTextChanged(self):
        self.BusCompanyAddress.iHeight = int(self.numAddressHeight.Value * 1000)
        self.BusCompanyAddress.setFramePosition()

    def numFooterHeightTextChanged(self):
        self.BusFooter.iHeight = int(self.numFooterHeight.Value * 1000)
        self.BusFooter.iYPos = \
            self.myLetterDoc.DocSize.Height - self.BusFooter.iHeight
        self.BusFooter.setFramePosition()

    def chkPaperCompanyLogoItemChanged(self):
        if self.chkPaperCompanyLogo.State != 0:
            if self.numLogoWidth.Value == 0:
                self.numLogoWidth.Value = 0.1

            if self.numLogoHeight.Value == 0:
                self.numLogoHeight.Value = 0.1
            self.BusCompanyLogo = BusinessPaperObject(
                self.myLetterDoc.xTextDocument, "Company Logo",
                int(self.numLogoWidth.Value * 1000),
                int(self.numLogoHeight.Value * 1000),
                int(self.numLogoX.Value * 1000),
                self.numLogoY.Value * 1000)
            self.xDialogModel.numLogoHeight.Enabled = True
            self.xDialogModel.numLogoWidth.Enabled = True
            self.xDialogModel.numLogoX.Enabled = True
            self.xDialogModel.numLogoY.Enabled = True
            self.setPossibleLogo(False)
        else:
            if self.BusCompanyLogo is not None:
                self.BusCompanyLogo.removeFrame()

            self.xDialogModel.numLogoHeight.Enabled = False
            self.xDialogModel.numLogoWidth.Enabled = False
            self.xDialogModel.numLogoX.Enabled = False
            self.xDialogModel.numLogoY.Enabled = False
            self.setPossibleLogo(True)

    def chkPaperCompanyAddressItemChanged(self):
        if self.chkPaperCompanyAddress.State != 0:
            if self.numAddressWidth.Value == 0:
                self.numAddressWidth.Value = 0.1

            if self.numAddressHeight.Value == 0:
                self.numAddressHeight.Value = 0.1

            self.BusCompanyAddress = BusinessPaperObject(
                self.myLetterDoc.xTextDocument, "Company Address",
                int(self.numAddressWidth.Value * 1000),
                int(self.numAddressHeight.Value * 1000),
                int(self.numAddressX.Value * 1000),
                int(self.numAddressY.Value * 1000))
            self.xDialogModel.numAddressHeight.Enabled = True
            self.xDialogModel.numAddressWidth.Enabled = True
            self.xDialogModel.numAddressX.Enabled = True
            self.xDialogModel.numAddressY.Enabled = True
            if self.myLetterDoc.hasElement("Sender Address"):
                self.myLetterDoc.switchElement(
                "Sender Address", False)

            if self.chkCompanyReceiver.State != 0:
                self.setPossibleSenderData(False)

        else:
            if self.BusCompanyAddress is not None:
                self.BusCompanyAddress.removeFrame()
            self.xDialogModel.numAddressHeight.Enabled = False
            self.xDialogModel.numAddressWidth.Enabled = False
            self.xDialogModel.numAddressX.Enabled = False
            self.xDialogModel.numAddressY.Enabled = False
            if self.myLetterDoc.hasElement("Sender Address"):
                self.myLetterDoc.switchElement("Sender Address", True)

            self.setPossibleSenderData(True)
            if self.optSenderDefine.State:
                self.optSenderDefineItemChanged()

            if self.optSenderPlaceholder.State:
                self.optSenderPlaceholderItemChanged()

    def chkCompanyReceiverItemChanged(self):
        xReceiverFrame = None
        if self.chkCompanyReceiver.State != 0:
            try:
                xReceiverFrame = self.myLetterDoc.getFrameByName(
                    "Receiver Address", self.myLetterDoc.xTextDocument)
                iFrameWidth = int(xReceiverFrame.Width)
                iFrameX = int(xReceiverFrame.HoriOrientPosition)
                iFrameY = int(xReceiverFrame.VertOrientPosition)
                iReceiverHeight = int(0.5 * 1000)
                self.BusCompanyAddressReceiver = BusinessPaperObject(
                    self.myLetterDoc.xTextDocument, " ", iFrameWidth, iReceiverHeight,
                    iFrameX, iFrameY - iReceiverHeight)
                self.setPossibleAddressReceiver(False)
            except Exception:
                traceback.print_exc()

            if self.chkPaperCompanyAddress.State != 0:
                self.setPossibleSenderData(False)

        else:
            if self.BusCompanyAddressReceiver is not None:
                self.BusCompanyAddressReceiver.removeFrame()

            self.setPossibleAddressReceiver(True)
            self.setPossibleSenderData(True)
            if self.optSenderDefine.State:
                self.optSenderDefineItemChanged()

            if self.optSenderPlaceholder.State:
                self.optSenderPlaceholderItemChanged()

    def chkPaperFooterItemChanged(self):
        if self.chkPaperFooter.State != 0:
            if self.numFooterHeight.Value == 0:
                self.numFooterHeight.Value = 0.1

            self.BusFooter = BusinessPaperObject(
                self.myLetterDoc.xTextDocument, "Footer",
                self.myLetterDoc.DocSize.Width,
                int(self.numFooterHeight.Value * 1000), 0,
                int(self.myLetterDoc.DocSize.Height - \
                    (self.numFooterHeight.Value * 1000)))
            self.xDialogModel.numFooterHeight.Enabled = True
            self.xDialogModel.lblFooterHeight.Enabled = True
            self.setPossibleFooter(False)
        else:
            if self.BusFooter is not None:
                self.BusFooter.removeFrame()

            self.xDialogModel.numFooterHeight.Enabled = False
            self.xDialogModel.lblFooterHeight.Enabled = False
            self.setPossibleFooter(True)

    def chkUseLogoItemChanged(self):
        try:
            if self.myLetterDoc.hasElement("Company Logo"):
                logostatus = \
                    bool(self.xDialogModel.chkUseLogo.Enabled) \
                    and (self.chkUseLogo.State != 0)
                self.myLetterDoc.switchElement(
                "Company Logo", logostatus)
        except Exception:
            traceback.print_exc()

    def chkUseAddressReceiverItemChanged(self):
        try:
            if self.myLetterDoc.hasElement("Sender Address Repeated"):
                rstatus = \
                    bool(self.xDialogModel.chkUseAddressReceiver.Enabled) \
                    and (self.chkUseAddressReceiver.State != 0)
                self.myLetterDoc.switchElement(
                    "Sender Address Repeated", rstatus)

        except Exception:
            traceback.print_exc()

    def chkUseSignsItemChanged(self):
        if self.myLetterDoc.hasElement("Letter Signs"):
            self.myLetterDoc.switchElement(
                "Letter Signs", self.chkUseSigns.State != 0)

    def chkUseSubjectItemChanged(self):
        if self.myLetterDoc.hasElement("Subject Line"):
            self.myLetterDoc.switchElement(
                "Subject Line", self.chkUseSubject.State != 0)

    def chkUseBendMarksItemChanged(self):
        if self.myLetterDoc.hasElement("Bend Marks"):
            self.myLetterDoc.switchElement(
                "Bend Marks", self.chkUseBendMarks.State != 0)

    def chkUseFooterItemChanged(self):
        try:
            bFooterPossible = (self.chkUseFooter.State != 0) \
                and bool(self.xDialogModel.chkUseFooter.Enabled)
            if self.chkFooterNextPages.State != 0:
                self.myLetterDoc.switchFooter(
                    "First Page", False, self.chkFooterPageNumbers.State != 0,
                    self.txtFooter.Text)
                self.myLetterDoc.switchFooter("Standard", bFooterPossible,
                    self.chkFooterPageNumbers.State != 0, self.txtFooter.Text)
            else:
                self.myLetterDoc.switchFooter(
                    "First Page", bFooterPossible,
                    self.chkFooterPageNumbers.State != 0, self.txtFooter.Text)
                self.myLetterDoc.switchFooter(
                    "Standard", bFooterPossible,
                    self.chkFooterPageNumbers.State != 0, self.txtFooter.Text)

            BPaperItem = \
                self.getRoadmapItemByID(LetterWizardDialogImpl.RM_FOOTER)
            BPaperItem.Enabled = bFooterPossible
        except Exception:
            traceback.print_exc()

    def chkFooterNextPagesItemChanged(self):
        self.chkUseFooterItemChanged()

    def chkFooterPageNumbersItemChanged(self):
        self.chkUseFooterItemChanged()

    def setPossibleFooter(self, bState):
        self.xDialogModel.chkUseFooter.Enabled = bState
        self.chkUseFooterItemChanged()

    def setPossibleAddressReceiver(self, bState):
        if self.myLetterDoc.hasElement("Sender Address Repeated"):
            self.xDialogModel.chkUseAddressReceiver.Enabled = bState
            self.chkUseAddressReceiverItemChanged()

    def setPossibleLogo(self, bState):
        if self.myLetterDoc.hasElement("Company Logo"):
            self.xDialogModel.chkUseLogo.Enabled = bState
            self.chkUseLogoItemChanged()

    def txtFooterTextChanged(self):
        self.chkUseFooterItemChanged()

    def txtSenderNameTextChanged(self):
        myFieldHandler = TextFieldHandler(
            self.myLetterDoc.xMSF, self.myLetterDoc.xTextDocument)
        myFieldHandler.changeUserFieldContent(
            "Company", self.txtSenderName.Text)

    def txtSenderStreetTextChanged(self):
        myFieldHandler = TextFieldHandler(
            self.myLetterDoc.xMSF, self.myLetterDoc.xTextDocument)
        myFieldHandler.changeUserFieldContent(
            "Street", self.txtSenderStreet.Text)

    def txtSenderCityTextChanged(self):
        myFieldHandler = TextFieldHandler(
            self.myLetterDoc.xMSF, self.myLetterDoc.xTextDocument)
        myFieldHandler.changeUserFieldContent(
            "City", self.txtSenderCity.Text)

    def txtSenderPostCodeTextChanged(self):
        myFieldHandler = TextFieldHandler(
            self.myLetterDoc.xMSF, self.myLetterDoc.xTextDocument)
        myFieldHandler.changeUserFieldContent(
            "PostCode", self.txtSenderPostCode.Text)

    def txtSenderStateTextChanged(self):
        myFieldHandler = TextFieldHandler(
            self.myLetterDoc.xMSF, self.myLetterDoc.xTextDocument)
        myFieldHandler.changeUserFieldContent(
            "State", self.txtSenderState.Text)

    def txtTemplateNameTextChanged(self):
        xDocProps = self.myLetterDoc.xTextDocument.DocumentProperties
        TitleName = self.txtTemplateName.Text
        xDocProps.Title = TitleName

    def chkUseSalutationItemChanged(self):
        self.myLetterDoc.switchUserField(
            "Salutation", self.lstSalutation.Text,
            self.chkUseSalutation.State != 0)
        self.xDialogModel.lstSalutation.Enabled = \
            self.chkUseSalutation.State != 0

    def lstSalutationItemChanged(self):
        self.myLetterDoc.switchUserField(
            "Salutation", self.lstSalutation.Text,
            self.chkUseSalutation.State != 0)

    def chkUseGreetingItemChanged(self):
        self.myLetterDoc.switchUserField(
            "Greeting", self.lstGreeting.Text, self.chkUseGreeting.State != 0)
        self.xDialogModel.lstGreeting.Enabled = \
            self.chkUseGreeting.State != 0

    def setDefaultForGreetingAndSalutation(self):
        if self.lstSalutation.Text:
            self.lstSalutation.Text = self.resources.SalutationLabels[0]

        if self.lstGreeting.Text:
            self.lstGreeting.Text = self.resources.GreetingLabels[0]

    def lstGreetingItemChanged(self):
        self.myLetterDoc.switchUserField(
            "Greeting", self.lstGreeting.Text, self.chkUseGreeting.State != 0)

    def chkBusinessPaperItemChanged(self):
        if self.chkBusinessPaper.State != 0:
            self.enableBusinessPaper()
        else:
            self.disableBusinessPaper()
            self.setPossibleSenderData(True)

    def setPossibleSenderData(self, bState):
        self.xDialogModel.optSenderDefine.Enabled = bState
        self.xDialogModel.optSenderPlaceholder.Enabled = bState
        self.xDialogModel.lblSenderAddress.Enabled = bState
        if not bState:
            self.xDialogModel.txtSenderCity.Enabled = bState
            self.xDialogModel.txtSenderName.Enabled = bState
            self.xDialogModel.txtSenderPostCode.Enabled = bState
            self.xDialogModel.txtSenderStreet.Enabled = bState
            self.xDialogModel.txtSenderCity.Enabled = bState
            self.xDialogModel.txtSenderState.Enabled = bState
            self.xDialogModel.lblSenderName.Enabled = bState
            self.xDialogModel.lblSenderStreet.Enabled = bState
            self.xDialogModel.lblPostCodeCity.Enabled = bState

    def enableSenderReceiver(self):
        BPaperItem = self.getRoadmapItemByID(
            LetterWizardDialogImpl.RM_SENDERRECEIVER)
        BPaperItem.Enabled = True

    def disableSenderReceiver(self):
        BPaperItem = self.getRoadmapItemByID(
            LetterWizardDialogImpl.RM_SENDERRECEIVER)
        BPaperItem.Enabled = False

    def enableBusinessPaper(self):
        try:
            BPaperItem = self.getRoadmapItemByID(
                LetterWizardDialogImpl.RM_BUSINESSPAPER)
            BPaperItem.Enabled = True
            self.chkPaperCompanyLogoItemChanged()
            self.chkPaperCompanyAddressItemChanged()
            self.chkPaperFooterItemChanged()
            self.chkCompanyReceiverItemChanged()
        except Exception:
            traceback.print_exc()

    def disableBusinessPaper(self):
        try:
            BPaperItem = self.getRoadmapItemByID(
                LetterWizardDialogImpl.RM_BUSINESSPAPER)
            BPaperItem.Enabled = False
            if self.BusCompanyLogo is not None:
                self.BusCompanyLogo.removeFrame()

            if self.BusCompanyAddress is not None:
                self.BusCompanyAddress.removeFrame()

            if self.BusFooter is not None:
                self.BusFooter.removeFrame()

            if self.BusCompanyAddressReceiver is not None:
                self.BusCompanyAddressReceiver.removeFrame()

            self.setPossibleAddressReceiver(True)
            self.setPossibleFooter(True)
            self.setPossibleLogo(True)
            if self.myLetterDoc.hasElement("Sender Address"):
                self.myLetterDoc.switchElement(
                "Sender Address", True)
        except Exception:
            traceback.print_exc()

    def initializeSalutation(self):
        self.xDialogModel.lstSalutation.StringItemList = \
            tuple(self.resources.SalutationLabels)

    def initializeGreeting(self):
        self.xDialogModel.lstGreeting.StringItemList = \
            tuple(self.resources.GreetingLabels)

    def initializeTemplates(self, xMSF):
        sLetterPath = self.sTemplatePath + "/wizard/letter"
        self.BusinessFiles = \
            FileAccess.getFolderTitles(
                xMSF, "bus", sLetterPath, self.resources.dictBusinessTemplate)
        self.OfficialFiles = \
            FileAccess.getFolderTitles(
                xMSF, "off", sLetterPath, self.resources.dictOfficialTemplate)
        self.PrivateFiles = \
            FileAccess.getFolderTitles(
                xMSF, "pri", sLetterPath, self.resources.dictPrivateTemplate)
        self.xDialogModel.lstBusinessStyle.StringItemList = \
            tuple(self.BusinessFiles[0])
        self.xDialogModel.lstPrivOfficialStyle.StringItemList = \
            tuple(self.OfficialFiles[0])
        self.xDialogModel.lstPrivateStyle.StringItemList = \
            tuple(self.PrivateFiles[0])
        self.xDialogModel.lstBusinessStyle.SelectedItems = (0,)
        self.xDialogModel.lstPrivOfficialStyle.SelectedItems = (0,)
        self.xDialogModel.lstPrivateStyle.SelectedItems = (0,)
        return True

    def initializeElements(self):
        self.xDialogModel.chkUseLogo.Enabled = \
            self.myLetterDoc.hasElement("Company Logo")
        self.xDialogModel.chkUseBendMarks.Enabled = \
            self.myLetterDoc.hasElement("Bend Marks")
        self.xDialogModel.chkUseAddressReceiver.Enabled = \
            self.myLetterDoc.hasElement("Sender Address Repeated")
        self.xDialogModel.chkUseSubject.Enabled = \
            self.myLetterDoc.hasElement("Subject Line")
        self.xDialogModel.chkUseSigns.Enabled = \
            self.myLetterDoc.hasElement("Letter Signs")
        self.myLetterDoc.updateDateFields()

    def setConfiguration(self):
        if self.optBusinessLetter.State:
            self.optBusinessLetterItemChanged()

        elif self.optPrivOfficialLetter.State:
            self.optPrivOfficialLetterItemChanged()

        elif self.optPrivateLetter.State:
            self.optPrivateLetterItemChanged()

    def optReceiverPlaceholderItemChanged(self):
        OfficeDocument.attachEventCall(
            self.myLetterDoc.xTextDocument, "OnNew", "StarBasic",
            "macro:///Template.Correspondence.Placeholder()")

    def optReceiverDatabaseItemChanged(self):
        OfficeDocument.attachEventCall(
            self.myLetterDoc.xTextDocument, "OnNew", "StarBasic",
            "macro:///Template.Correspondence.Database()")

    def setElements(self, privLetter):
        if self.optSenderDefine.State:
            self.optSenderDefineItemChanged()

        if self.optSenderPlaceholder.State:
            self.optSenderPlaceholderItemChanged()

        self.chkUseSignsItemChanged()
        self.chkUseSubjectItemChanged()
        self.chkUseSalutationItemChanged()
        self.chkUseGreetingItemChanged()
        self.chkUseBendMarksItemChanged()
        self.chkUseAddressReceiverItemChanged()
        self.txtTemplateNameTextChanged()
        if self.optReceiverDatabase.State and not privLetter:
            self.optReceiverDatabaseItemChanged()

        if self.optReceiverPlaceholder.State and not privLetter:
            self.optReceiverPlaceholderItemChanged()

        if self.optCreateLetter.State:
            self.optCreateFromTemplateItemChanged()

        if self.optMakeChanges.State:
            self.optMakeChangesItemChanged()

    def drawConstants(self):
        '''Localise the template'''
        constRangeList = self.myLetterDoc.searchFillInItems(1)

        for i in constRangeList:
            text = i.String.lower()
            aux = TextElement(i, self.resources.dictConstants[text])
            aux.write()

    def insertRoadmap(self):
        self.addRoadmap()
        self.insertRoadMapItems(
                self.resources.RoadmapLabels,
                [True, False, True, True, False, True])
        self.setRoadmapInteractive(True)
        self.setRoadmapComplete(True)
        self.setCurrentRoadmapItemID(1)

    def insertPathSelectionControl(self):
        self.myPathSelection = \
            PathSelection(self.xMSF, self, PathSelection.TransferMode.SAVE,
                PathSelection.DialogTypes.FILE)
        self.myPathSelection.insert(
            6, 97, 70, 205, 45, self.resources.reslblTemplatePath_value,
            True, HelpIds.getHelpIdString(HID + 47),
            HelpIds.getHelpIdString(HID + 48))
        self.myPathSelection.sDefaultDirectory = self.sUserTemplatePath
        self.myPathSelection.sDefaultName = "myLetterTemplate.ott"
        self.myPathSelection.sDefaultFilter = "writer8_template"
        self.myPathSelection.addSelectionListener(self)

    def initConfiguration(self):
        try:
            root = Configuration.getConfigurationRoot(
                self.xMSF, "/org.openoffice.Office.Writer/Wizards/Letter",
                False)
            self.myConfig.readConfiguration(root, "cp_")
            RadioDataAware.attachRadioButtons(self.myConfig, "cp_LetterType",
                (self.optBusinessLetter, self.optPrivOfficialLetter,
                    self.optPrivateLetter), True).updateUI()
            UnoDataAware.attachListBox(
                self.myConfig.cp_BusinessLetter, "cp_Style",
                self.lstBusinessStyle, True).updateUI()
            UnoDataAware.attachListBox(
                self.myConfig.cp_PrivateOfficialLetter, "cp_Style",
                self.lstPrivOfficialStyle, True).updateUI()
            UnoDataAware.attachListBox(
                self.myConfig.cp_PrivateLetter, "cp_Style",
                self.lstPrivateStyle, True).updateUI()
            UnoDataAware.attachCheckBox(
                self.myConfig.cp_BusinessLetter, "cp_BusinessPaper",
                self.chkBusinessPaper, True).updateUI()
            cgl = self.myConfig.cp_BusinessLetter
            cgpl = self.myConfig.cp_BusinessLetter.cp_CompanyLogo
            cgpa = self.myConfig.cp_BusinessLetter.cp_CompanyAddress
            UnoDataAware.attachCheckBox(
                cgpl, "cp_Display", self.chkPaperCompanyLogo, True).updateUI()
            UnoDataAware.attachNumericControl(
                cgpl, "cp_Width", self.numLogoWidth, True).updateUI()
            UnoDataAware.attachNumericControl(
                cgpl, "cp_Height", self.numLogoHeight, True).updateUI()
            UnoDataAware.attachNumericControl(
                cgpl, "cp_X", self.numLogoX, True).updateUI()
            UnoDataAware.attachNumericControl(
                cgpl, "cp_Y", self.numLogoY, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgpa, "cp_Display", self.chkPaperCompanyAddress, True).updateUI()
            UnoDataAware.attachNumericControl(
                cgpa, "cp_Width", self.numAddressWidth, True).updateUI()
            UnoDataAware.attachNumericControl(
                cgpa, "cp_Height", self.numAddressHeight, True).updateUI()
            UnoDataAware.attachNumericControl(
                cgpa, "cp_X", self.numAddressX, True).updateUI()
            UnoDataAware.attachNumericControl(
                cgpa, "cp_Y", self.numAddressY, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgl, "cp_PaperCompanyAddressReceiverField",
                self.chkCompanyReceiver, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgl, "cp_PaperFooter", self.chkPaperFooter, True).updateUI()
            UnoDataAware.attachNumericControl(
                cgl, "cp_PaperFooterHeight", self.numFooterHeight, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgl, "cp_PrintCompanyLogo", self.chkUseLogo, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgl, "cp_PrintCompanyAddressReceiverField",
                self.chkUseAddressReceiver, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgl, "cp_PrintLetterSigns", self.chkUseSigns, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgl, "cp_PrintSubjectLine", self.chkUseSubject, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgl, "cp_PrintSalutation", self.chkUseSalutation, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgl, "cp_PrintBendMarks", self.chkUseBendMarks, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgl, "cp_PrintGreeting", self.chkUseGreeting, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgl, "cp_PrintFooter", self.chkUseFooter, True).updateUI()
            UnoDataAware.attachEditControl(
                cgl, "cp_Salutation", self.lstSalutation, True).updateUI()
            UnoDataAware.attachEditControl(
                cgl, "cp_Greeting", self.lstGreeting, True).updateUI()
            RadioDataAware.attachRadioButtons(
                cgl, "cp_SenderAddressType",
                (self.optSenderDefine, self.optSenderPlaceholder), True).updateUI()
            UnoDataAware.attachEditControl(
                cgl, "cp_SenderCompanyName", self.txtSenderName, True).updateUI()
            UnoDataAware.attachEditControl(
                cgl, "cp_SenderStreet", self.txtSenderStreet, True).updateUI()
            UnoDataAware.attachEditControl(
                cgl, "cp_SenderPostCode", self.txtSenderPostCode, True).updateUI()
            UnoDataAware.attachEditControl(
                cgl, "cp_SenderState", self.txtSenderState, True).updateUI()
            UnoDataAware.attachEditControl(
                cgl, "cp_SenderCity", self.txtSenderCity, True).updateUI()
            RadioDataAware.attachRadioButtons(
                cgl, "cp_ReceiverAddressType",
                (self.optReceiverDatabase, self.optReceiverPlaceholder),
                True).updateUI()
            UnoDataAware.attachEditControl(
                cgl, "cp_Footer", self.txtFooter, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgl, "cp_FooterOnlySecondPage",
                self.chkFooterNextPages, True).updateUI()
            UnoDataAware.attachCheckBox(
                cgl, "cp_FooterPageNumbers",
                self.chkFooterPageNumbers, True).updateUI()
            RadioDataAware.attachRadioButtons(
                cgl, "cp_CreationType",
                (self.optCreateLetter, self.optMakeChanges), True).updateUI()
            UnoDataAware.attachEditControl(
                cgl, "cp_TemplateName", self.txtTemplateName, True).updateUI()
            UnoDataAware.attachEditControl(
                cgl, "cp_TemplatePath", self.myPathSelection.xSaveTextBox,
                True).updateUI()
        except Exception:
            traceback.print_exc()

    def saveConfiguration(self):
        try:
            root = Configuration.getConfigurationRoot(self.xMSF,
                "/org.openoffice.Office.Writer/Wizards/Letter", True)
            self.myConfig.writeConfiguration(root, "cp_")
            root.commitChanges()
        except Exception:
            traceback.print_exc()

    def validatePath(self):
        if self.myPathSelection.usedPathPicker:
                self.filenameChanged = True
        self.myPathSelection.usedPathPicker = False
