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
from .FaxWizardDialog import FaxWizardDialog, uno, HID
from .CGFaxWizard import CGFaxWizard
from .FaxDocument import FaxDocument
from ..ui.PathSelection import PathSelection
from ..ui.event.UnoDataAware import UnoDataAware
from ..ui.event.RadioDataAware import RadioDataAware
from ..ui.event.CommonListener import TerminateListenerProcAdapter
from ..text.TextFieldHandler import TextFieldHandler
from ..text.TextElement import TextElement
from ..common.Configuration import Configuration
from ..common.SystemDialog import SystemDialog
from ..common.NoValidPathException import NoValidPathException
from ..common.HelpIds import HelpIds
from ..common.FileAccess import FileAccess
from ..common.Desktop import Desktop
from ..document.OfficeDocument import OfficeDocument

from com.sun.star.awt.VclWindowPeerAttribute import YES_NO, DEF_NO
from com.sun.star.util import CloseVetoException
from com.sun.star.view.DocumentZoomType import OPTIMAL
from com.sun.star.document.UpdateDocMode import FULL_UPDATE
from com.sun.star.document.MacroExecMode import ALWAYS_EXECUTE

class FaxWizardDialogImpl(FaxWizardDialog):

    def leaveStep(self, nOldStep, nNewStep):
        pass

    def enterStep(self, nOldStep, nNewStep):
        pass

    RM_SENDERRECEIVER = 3
    RM_FOOTER = 4

    def __init__(self, xmsf):
        super(FaxWizardDialogImpl, self).__init__(xmsf)
        self.lstBusinessStylePos = None
        self.lstPrivateStylePos = None
        self.bSaveSuccess = False
        self.filenameChanged = False

    def startWizard(self, xMSF):
        self.running = True
        try:
            #Number of steps on WizardDialog
            self.nMaxStep = 5

            #instantiate The Document Frame for the Preview
            self.terminateListener = TerminateListenerProcAdapter(self.queryTermination)
            self.myFaxDoc = FaxDocument(xMSF, self.terminateListener)

            #create the dialog:
            self.drawNaviBar()

            self.buildStep1()
            self.buildStep2()
            self.buildStep3()
            self.buildStep4()
            self.buildStep5()

            self.initializeSalutation()
            self.initializeGreeting()
            self.initializeCommunication()
            self.initializePaths()

            #special Control for setting the save Path:
            self.insertPathSelectionControl()

            self.initializeTemplates(xMSF)

            #load the last used settings
            #from the registry and apply listeners to the controls:
            self.initConfiguration()

            if self.myPathSelection.xSaveTextBox.Text.lower() == "":
                self.myPathSelection.initializePath()

            xContainerWindow = self.myFaxDoc.xFrame.ContainerWindow
            self.createWindowPeer(xContainerWindow)

            #add the Roadmap to the dialog:
            self.insertRoadmap()

            #load the last used document and apply last used settings:
            #TODO:
            self.setConfiguration()

            #If the configuration does not define
            #Greeting/Salutation/CommunicationType yet choose a default
            self.__setDefaultForGreetingAndSalutationAndCommunication()

            #disable functionality that is not supported by the template:
            self.initializeElements()

            #disable the document, so that the user cannot change anything:
            self.myFaxDoc.xFrame.ComponentWindow.Enable = False
            self.executeDialogFromComponent(self.myFaxDoc.xFrame)
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

            #first, if the filename was not changed, thus
            #it is coming from a saved session, check if the
            # file exists and warn the user.
            if not self.filenameChanged:
                answer = SystemDialog.showMessageBox(
                    self.xMSF, "MessBox", YES_NO + DEF_NO,
                    self.resources.resOverwriteWarning,
                    self.xUnoDialog.Peer)
                if answer == 3:
                    # user said: no, do not overwrite...
                    endWizard = False
                    return False

            self.myFaxDoc.setWizardTemplateDocInfo( \
                self.resources.resFaxWizardDialog_title,
                self.resources.resTemplateDescription)
            self.myFaxDoc.killEmptyUserFields()
            self.myFaxDoc.keepLogoFrame = bool(self.chkUseLogo.State)
            self.myFaxDoc.keepTypeFrame = \
                bool(self.chkUseCommunicationType.State)
            self.myFaxDoc.killEmptyFrames()
            self.bSaveSuccess = OfficeDocument.store(self.xMSF,
                self.myFaxDoc.xTextDocument, self.sPath, "writer8_template")
            if self.bSaveSuccess:
                self.saveConfiguration()
                xIH = self.xMSF.createInstance( \
                    "com.sun.star.comp.uui.UUIInteractionHandler")
                loadValues = list(range(4))
                loadValues[0] = uno.createUnoStruct( \
                    'com.sun.star.beans.PropertyValue')
                loadValues[0].Name = "AsTemplate"
                loadValues[0].Value = True
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

                oDoc = OfficeDocument.load(Desktop.getDesktop(self.xMSF),
                    self.sPath, "_default", loadValues)
                oDoc.CurrentController.ViewSettings.ZoomType = OPTIMAL
            else:
                pass
                #TODO: Error Handling

        except Exception:
            traceback.print_exc()
        finally:
            if endWizard:
                self.xUnoDialog.endExecute()
                self.running = False

        return True

    def closeDocument(self):
        try:
            self.myFaxDoc.xFrame.close(False)
        except CloseVetoException:
            traceback.print_exc()

    def drawConstants(self):
        '''Localise the template'''
        constRangeList = self.myFaxDoc.searchFillInItems(1)
        
        for i in constRangeList:
            text = i.String.lower()
            aux = TextElement(i, self.resources.dictConstants[text])
            aux.write()
            
    def insertRoadmap(self):
        self.addRoadmap()
        self.insertRoadMapItems(
                self.resources.RoadmapLabels, [True, True, True, False, True])

        self.setRoadmapInteractive(True)
        self.setRoadmapComplete(True)
        self.setCurrentRoadmapItemID(1)

    def insertPathSelectionControl(self):
        self.myPathSelection = PathSelection(self.xMSF,
            self, PathSelection.TransferMode.SAVE,
            PathSelection.DialogTypes.FILE)
        self.myPathSelection.insert(
            5, 97, 70, 205, 45, self.resources.reslblTemplatePath_value,
            True, HelpIds.getHelpIdString(HID + 34),
            HelpIds.getHelpIdString(HID + 35))
        self.myPathSelection.sDefaultDirectory = self.sUserTemplatePath
        self.myPathSelection.sDefaultName = "myFaxTemplate.ott"
        self.myPathSelection.sDefaultFilter = "writer8_template"
        self.myPathSelection.addSelectionListener(self)

    def initializeTemplates(self, xMSF):
        try:
            self.sFaxPath = self.sTemplatePath + "/wizard/fax"
            self.BusinessFiles = FileAccess.getFolderTitles(xMSF, "bus",
                self.sFaxPath, self.resources.dictBusinessTemplate)
            self.PrivateFiles = FileAccess.getFolderTitles(xMSF, "pri",
                self.sFaxPath, self.resources.dictPrivateTemplate)
                
            self.xDialogModel.lstBusinessStyle.StringItemList = \
                tuple(self.BusinessFiles[0])
            self.xDialogModel.lstPrivateStyle.StringItemList = \
                tuple(self.PrivateFiles[0])
            self.xDialogModel.lstBusinessStyle.SelectedItems = (0,)
            self.xDialogModel.lstPrivateStyle.SelectedItems = (0,)
            return True
        except NoValidPathException:
            traceback.print_exc()
            return False

    def initializeElements(self):
        self.xDialogModel.chkUseLogo.Enabled = \
            self.myFaxDoc.hasElement("Company Logo")
        self.xDialogModel.chkUseSubject.Enabled = \
            self.myFaxDoc.hasElement("Subject Line")
        self.xDialogModel.chkUseDate.Enabled = \
            self.myFaxDoc.hasElement("Date")
        self.myFaxDoc.updateDateFields()

    def initializeSalutation(self):
        #'Salutation' listbox
        self.xDialogModel.lstSalutation.StringItemList = \
            tuple(self.resources.SalutationLabels)

    def initializeGreeting(self):
        #'Complimentary Close' listbox
        self.xDialogModel.lstGreeting.StringItemList = \
            tuple(self.resources.GreetingLabels)

    def initializeCommunication(self):
        #'Type of message' listbox
        self.xDialogModel.lstCommunicationType.StringItemList = \
            tuple(self.resources.CommunicationLabels)

    def __setDefaultForGreetingAndSalutationAndCommunication(self):
        if not self.lstSalutation.Text:
            self.lstSalutation.setText(self.resources.SalutationLabels[0])

        if not self.lstGreeting.Text:
            self.lstGreeting.setText(self.resources.GreetingLabels[0])

        if not self.lstCommunicationType.Text:
            self.lstCommunicationType.setText( \
                self.resources.CommunicationLabels[0])

    def initConfiguration(self):
        try:
            self.myConfig = CGFaxWizard()
            root = Configuration.getConfigurationRoot(self.xMSF,
                "/org.openoffice.Office.Writer/Wizards/Fax", False)
            self.myConfig.readConfiguration(root, "cp_")
            RadioDataAware.attachRadioButtons(
                self.myConfig, "cp_FaxType",
                (self.optBusinessFax, self.optPrivateFax), True).updateUI()
            UnoDataAware.attachListBox(
                self.myConfig.cp_BusinessFax, "cp_Style",
                self.lstBusinessStyle, True).updateUI()
            UnoDataAware.attachListBox(
                self.myConfig.cp_PrivateFax, "cp_Style", self.lstPrivateStyle,
                True).updateUI()
            cgl = self.myConfig.cp_BusinessFax
            UnoDataAware.attachCheckBox(cgl,
                "cp_PrintCompanyLogo", self.chkUseLogo, True).updateUI()
            UnoDataAware.attachCheckBox(cgl,
                "cp_PrintSubjectLine", self.chkUseSubject, True).updateUI()
            UnoDataAware.attachCheckBox(cgl,
                "cp_PrintSalutation", self.chkUseSalutation, True).updateUI()
            UnoDataAware.attachCheckBox(cgl,
                "cp_PrintDate", self.chkUseDate, True).updateUI()
            UnoDataAware.attachCheckBox(cgl, "cp_PrintCommunicationType",
                self.chkUseCommunicationType, True).updateUI()
            UnoDataAware.attachCheckBox(cgl,
                "cp_PrintGreeting", self.chkUseGreeting, True).updateUI()
            UnoDataAware.attachCheckBox(cgl,
                "cp_PrintFooter", self.chkUseFooter, True).updateUI()
            UnoDataAware.attachEditControl(cgl,
                "cp_Salutation", self.lstSalutation, True).updateUI()
            UnoDataAware.attachEditControl(cgl,
                "cp_Greeting", self.lstGreeting, True).updateUI()
            UnoDataAware.attachEditControl(cgl, "cp_CommunicationType",
                self.lstCommunicationType, True).updateUI()
            RadioDataAware.attachRadioButtons(cgl, "cp_SenderAddressType",
                (self.optSenderDefine, self.optSenderPlaceholder),
                True).updateUI()
            UnoDataAware.attachEditControl(cgl, "cp_SenderCompanyName",
                self.txtSenderName, True).updateUI()
            UnoDataAware.attachEditControl(cgl, "cp_SenderStreet",
                self.txtSenderStreet, True).updateUI()
            UnoDataAware.attachEditControl(cgl, "cp_SenderPostCode",
                self.txtSenderPostCode, True).updateUI()
            UnoDataAware.attachEditControl(cgl, "cp_SenderState",
                self.txtSenderState, True).updateUI()
            UnoDataAware.attachEditControl(cgl, "cp_SenderCity",
                self.txtSenderCity, True).updateUI()
            UnoDataAware.attachEditControl(cgl, "cp_SenderFax",
                self.txtSenderFax, True).updateUI()
            RadioDataAware.attachRadioButtons(cgl, "cp_ReceiverAddressType",
                (self.optReceiverDatabase, self.optReceiverPlaceholder),
                True).updateUI()
            UnoDataAware.attachEditControl(cgl, "cp_Footer",
                self.txtFooter, True).updateUI()
            UnoDataAware.attachCheckBox(cgl, "cp_FooterOnlySecondPage",
                self.chkFooterNextPages, True).updateUI()
            UnoDataAware.attachCheckBox(cgl, "cp_FooterPageNumbers",
                self.chkFooterPageNumbers, True).updateUI()
            RadioDataAware.attachRadioButtons(cgl, "cp_CreationType",
                (self.optCreateFax, self.optMakeChanges), True).updateUI()
            UnoDataAware.attachEditControl(cgl,
                "cp_TemplateName", self.txtTemplateName, True).updateUI()
            UnoDataAware.attachEditControl(cgl, "cp_TemplatePath",
                self.myPathSelection.xSaveTextBox, True).updateUI()
        except Exception:
            traceback.print_exc()

    def saveConfiguration(self):
        try:
            root = Configuration.getConfigurationRoot(self.xMSF,
                "/org.openoffice.Office.Writer/Wizards/Fax", True)
            self.myConfig.writeConfiguration(root, "cp_")
            root.commitChanges()
        except Exception:
            traceback.print_exc()

    def setConfiguration(self):
        #set correct Configuration tree:
        if self.optBusinessFax.State:
            self.optBusinessFaxItemChanged()
        elif self.optPrivateFax.State:
            self.optPrivateFaxItemChanged()

    def optBusinessFaxItemChanged(self):
        self.lstPrivateStylePos = None
        self.xDialogModel.lblBusinessStyle.Enabled = True
        self.xDialogModel.lstBusinessStyle.Enabled = True
        self.xDialogModel.lblPrivateStyle.Enabled = False
        self.xDialogModel.lstPrivateStyle.Enabled = False

        self.lstBusinessStyleItemChanged()
        self.__enableSenderReceiver()
        self.__setPossibleFooter(True)

    def lstBusinessStyleItemChanged(self):
        selectedItemPos = self.lstBusinessStyle.SelectedItemPos
        #avoid to load the same item again
        if self.lstBusinessStylePos != selectedItemPos:
            self.lstBusinessStylePos = selectedItemPos
            self.myFaxDoc.loadAsPreview(
                self.BusinessFiles[1][selectedItemPos], False)
            self.initializeElements()
            self.setElements()
            self.drawConstants()

    def optPrivateFaxItemChanged(self):
        self.lstBusinessStylePos = None
        self.xDialogModel.lblBusinessStyle.Enabled = False
        self.xDialogModel.lstBusinessStyle.Enabled = False
        self.xDialogModel.lblPrivateStyle.Enabled = True
        self.xDialogModel.lstPrivateStyle.Enabled = True

        self.lstPrivateStyleItemChanged()
        self.__disableSenderReceiver()
        self.__setPossibleFooter(False)

    def lstPrivateStyleItemChanged(self):
        selectedItemPos = self.lstPrivateStyle.SelectedItemPos
        #avoid to load the same item again
        if self.lstPrivateStylePos != selectedItemPos:
            self.lstPrivateStylePos = selectedItemPos
            self.myFaxDoc.loadAsPreview(
                self.PrivateFiles[1][selectedItemPos], False)
            self.initializeElements()
            self.setElements()

    def txtTemplateNameTextChanged(self):
        # Change Template Title in Properties
        xDocProps = self.myFaxDoc.xTextDocument.DocumentProperties
        xDocProps.Title = self.txtTemplateName.Text

    def optSenderPlaceholderItemChanged(self):
        self.xDialogModel.lblSenderName.Enabled = False
        self.xDialogModel.lblSenderStreet.Enabled = False
        self.xDialogModel.lblPostCodeCity.Enabled = False
        self.xDialogModel.lblSenderFax.Enabled = False
        self.xDialogModel.txtSenderName.Enabled = False
        self.xDialogModel.txtSenderStreet.Enabled = False
        self.xDialogModel.txtSenderPostCode.Enabled = False
        self.xDialogModel.txtSenderState.Enabled = False
        self.xDialogModel.txtSenderCity.Enabled = False
        self.xDialogModel.txtSenderFax.Enabled = False
        self.myFaxDoc.fillSenderWithUserData()

    def optSenderDefineItemChanged(self):
        self.xDialogModel.lblSenderName.Enabled = True
        self.xDialogModel.lblSenderStreet.Enabled = True
        self.xDialogModel.lblPostCodeCity.Enabled = True
        self.xDialogModel.lblSenderFax.Enabled = True
        self.xDialogModel.txtSenderName.Enabled = True
        self.xDialogModel.txtSenderStreet.Enabled = True
        self.xDialogModel.txtSenderPostCode.Enabled = True
        self.xDialogModel.txtSenderState.Enabled = True
        self.xDialogModel.txtSenderCity.Enabled = True
        self.xDialogModel.txtSenderFax.Enabled = True

        self.myFieldHandler = TextFieldHandler(self.myFaxDoc.xMSF,
            self.myFaxDoc.xTextDocument)
        self.txtSenderNameTextChanged()
        self.txtSenderStreetTextChanged()
        self.txtSenderPostCodeTextChanged()
        self.txtSenderStateTextChanged()
        self.txtSenderCityTextChanged()
        self.txtSenderFaxTextChanged()

    def txtSenderNameTextChanged(self):
        self.myFieldHandler.changeUserFieldContent(
            "Company", self.txtSenderName.Text)

    def txtSenderStreetTextChanged(self):
        self.myFieldHandler.changeUserFieldContent(
            "Street", self.txtSenderStreet.Text)

    def txtSenderCityTextChanged(self):
        self.myFieldHandler.changeUserFieldContent(
            "City", self.txtSenderCity.Text)

    def txtSenderPostCodeTextChanged(self):
        self.myFieldHandler.changeUserFieldContent(
            "PostCode", self.txtSenderPostCode.Text)

    def txtSenderStateTextChanged(self):
        self.myFieldHandler.changeUserFieldContent(
            "State", self.txtSenderState.Text)

    def txtSenderFaxTextChanged(self):
        self.myFieldHandler.changeUserFieldContent(
            "Fax", self.txtSenderFax.Text)

    #switch Elements on/off --------------------------------------------------

    def setElements(self):
        #UI relevant:
        if self.optSenderDefine.State:
            self.optSenderDefineItemChanged()

        if self.optSenderPlaceholder.State:
            self.optSenderPlaceholderItemChanged()

        self.chkUseLogoItemChanged()
        self.chkUseSubjectItemChanged()
        self.chkUseSalutationItemChanged()
        self.chkUseGreetingItemChanged()
        self.chkUseCommunicationItemChanged()
        self.chkUseDateItemChanged()
        self.chkUseFooterItemChanged()
        self.txtTemplateNameTextChanged()
        #not UI relevant:
        if self.optReceiverDatabase.State:
            self.optReceiverDatabaseItemChanged()

        elif self.optReceiverPlaceholder.State:
            self.optReceiverPlaceholderItemChanged()

        if self.optCreateFax.State:
            self.optCreateFromTemplateItemChanged()

        elif self.optMakeChanges.State:
            self.optMakeChangesItemChanged()

    def chkUseLogoItemChanged(self):
        if self.myFaxDoc.hasElement("Company Logo"):
            self.myFaxDoc.switchElement("Company Logo",
                bool(self.chkUseLogo.State))

    def chkUseSubjectItemChanged(self):
        if self.myFaxDoc.hasElement("Subject Line"):
            self.myFaxDoc.switchElement("Subject Line",
                bool(self.chkUseSubject.State))

    def chkUseDateItemChanged(self):
        if self.myFaxDoc.hasElement("Date"):
            self.myFaxDoc.switchElement("Date",
                bool(self.chkUseDate.State))

    def chkUseFooterItemChanged(self):
        try:
            bFooterPossible = bool(self.chkUseFooter.State) \
                and bool(self.xDialogModel.chkUseFooter.Enabled)
            if bool(self.chkFooterNextPages.State):
                self.myFaxDoc.switchFooter("First Page", False,
                    bool(self.chkFooterPageNumbers.State),
                        self.txtFooter.Text)
                self.myFaxDoc.switchFooter("Standard", bFooterPossible,
                    bool(self.chkFooterPageNumbers.State),
                    self.txtFooter.Text)
            else:
                self.myFaxDoc.switchFooter("First Page", bFooterPossible,
                    bool(self.chkFooterPageNumbers.State),
                    self.txtFooter.Text)
                self.myFaxDoc.switchFooter("Standard", bFooterPossible,
                    bool(self.chkFooterPageNumbers.State),
                    self.txtFooter.Text)

            #enable/disable roadmap item for footer page
            BPaperItem = self.getRoadmapItemByID( \
                FaxWizardDialogImpl.RM_FOOTER)
            BPaperItem.Enabled = bFooterPossible
        except Exception:
            traceback.print_exc()

    def chkFooterNextPagesItemChanged(self):
        self.chkUseFooterItemChanged()

    def chkFooterPageNumbersItemChanged(self):
        self.chkUseFooterItemChanged()

    def txtFooterTextChanged(self):
        self.myFaxDoc.switchFooter("First Page", True,
                    bool(self.chkFooterPageNumbers.State),
                    self.txtFooter.Text)

    def chkUseSalutationItemChanged(self):
        self.myFaxDoc.switchUserField("Salutation",
            self.lstSalutation.Text, bool(self.chkUseSalutation.State))
        self.xDialogModel.lstSalutation.Enabled = \
            bool(self.chkUseSalutation.State)

    def lstSalutationItemChanged(self):
        self.myFaxDoc.switchUserField("Salutation",
            self.lstSalutation.Text, bool(self.chkUseSalutation.State))

    def chkUseCommunicationItemChanged(self):
        self.myFaxDoc.switchUserField("CommunicationType",
            self.lstCommunicationType.Text,
            bool(self.chkUseCommunicationType.State))
        self.xDialogModel.lstCommunicationType.Enabled = \
            bool(self.chkUseCommunicationType.State)

    def lstCommunicationItemChanged(self):
        self.myFaxDoc.switchUserField("CommunicationType",
            self.lstCommunicationType.Text,
            bool(self.chkUseCommunicationType.State))

    def chkUseGreetingItemChanged(self):
        self.myFaxDoc.switchUserField("Greeting",
            self.lstGreeting.Text, bool(self.chkUseGreeting.State))
        self.xDialogModel.lstGreeting.Enabled = \
            bool(self.chkUseGreeting.State)

    def lstGreetingItemChanged(self):
        self.myFaxDoc.switchUserField("Greeting", self.lstGreeting.Text,
            bool(self.chkUseGreeting.State))

    def __setPossibleFooter(self, bState):
        self.xDialogModel.chkUseFooter.Enabled = bState
        if not bState:
            self.chkUseFooter.State = 0

        self.chkUseFooterItemChanged()
        
    def optReceiverPlaceholderItemChanged(self):
        OfficeDocument.attachEventCall(
            self.myFaxDoc.xTextDocument, "OnNew", "StarBasic",
            "macro:///Template.Correspondence.Placeholder()")

    def optReceiverDatabaseItemChanged(self):
        OfficeDocument.attachEventCall(
            self.myFaxDoc.xTextDocument, "OnNew", "StarBasic",
            "macro:///Template.Correspondence.Database()")

    def __enableSenderReceiver(self):
        BPaperItem = self.getRoadmapItemByID( \
            FaxWizardDialogImpl.RM_SENDERRECEIVER)
        BPaperItem.Enabled = True

    def __disableSenderReceiver(self):
        BPaperItem = self.getRoadmapItemByID( \
            FaxWizardDialogImpl.RM_SENDERRECEIVER)
        BPaperItem.Enabled = False

    def validatePath(self):
        if self.myPathSelection.usedPathPicker:
                self.filenameChanged = True
        self.myPathSelection.usedPathPicker = False
