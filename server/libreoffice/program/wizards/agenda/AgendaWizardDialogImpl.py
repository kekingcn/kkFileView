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
from .AgendaWizardDialog import AgendaWizardDialog, uno
from .AgendaWizardDialogConst import HID
from .AgendaDocument import AgendaDocument, TextElement
from .TemplateConsts import TemplateConsts
from .TopicsControl import TopicsControl
from .CGAgenda import CGAgenda
from ..ui.PathSelection import PathSelection
from ..ui.event.UnoDataAware import UnoDataAware
from ..ui.event.RadioDataAware import RadioDataAware
from ..ui.event.CommonListener import TerminateListenerProcAdapter
from ..common.NoValidPathException import NoValidPathException
from ..common.SystemDialog import SystemDialog
from ..common.Desktop import Desktop
from ..common.HelpIds import HelpIds
from ..common.Configuration import Configuration
from ..common.FileAccess import FileAccess
from ..document.OfficeDocument import OfficeDocument

from com.sun.star.util import CloseVetoException
from com.sun.star.view.DocumentZoomType import OPTIMAL
from com.sun.star.awt.VclWindowPeerAttribute import YES_NO, DEF_NO

class AgendaWizardDialogImpl(AgendaWizardDialog):

    def __init__(self, xmsf):
        super(AgendaWizardDialogImpl, self).__init__(xmsf)
        self.filenameChanged = False
        self.pageDesign = -1

    def enterStep(self, OldStep, NewStep):
        pass

    def leaveStep(self, OldStep, NewStep):
        pass

    def startWizard(self, xMSF):
        self.running = True
        try:
            #Number of steps on WizardDialog
            self.nMaxStep = 6

            self.agenda = CGAgenda()

            # read configuration data before we initialize the topics
            root = Configuration.getConfigurationRoot(
                self.xMSF, "/org.openoffice.Office.Writer/Wizards/Agenda",
                False)
            self.agenda.readConfiguration(root, "cp_")

            self.templateConsts = TemplateConsts

            self.initializePaths()
            # initialize the agenda template
            self.terminateListener = TerminateListenerProcAdapter(self.queryTermination)
            self.myAgendaDoc = AgendaDocument(
                self.xMSF, self.agenda, self.resources,
                self.templateConsts, self.terminateListener)
            self.initializeTemplates()

            self.myAgendaDoc.load(
                self.agendaTemplates[1][self.agenda.cp_AgendaType])
            self.drawConstants()

            # build the dialog.
            self.drawNaviBar()

            self.buildStep1()
            self.buildStep2()
            self.buildStep3()
            self.buildStep4()
            self.buildStep5()
            self.buildStep6()

            self.topicsControl = TopicsControl(self, self.xMSF, self.agenda)

            #special Control for setting the save Path:
            self.insertPathSelectionControl()

            # synchronize GUI and CGAgenda object.
            self.initConfiguration()

            if self.myPathSelection.xSaveTextBox.Text.lower() == "":
                self.myPathSelection.initializePath()

            # create the peer
            xContainerWindow = self.myAgendaDoc.xFrame.ContainerWindow
            self.createWindowPeer(xContainerWindow)

            # initialize roadmap
            self.insertRoadmap()

            self.executeDialogFromComponent(self.myAgendaDoc.xFrame)
            self.removeTerminateListener()
            self.closeDocument()
            self.running = False
        except Exception:
            self.removeTerminateListener()
            traceback.print_exc()
            self.running = False
            return

    def insertPathSelectionControl(self):
        self.myPathSelection = PathSelection(
            self.xMSF, self, PathSelection.TransferMode.SAVE,
            PathSelection.DialogTypes.FILE)
        self.myPathSelection.insert(6, 97, 70, 205, 45,
            self.resources.reslblTemplatePath_value, True,
            HelpIds.getHelpIdString(HID + 24),
            HelpIds.getHelpIdString(HID + 25))
        self.myPathSelection.sDefaultDirectory = self.sUserTemplatePath
        self.myPathSelection.sDefaultName = "myAgendaTemplate.ott"
        self.myPathSelection.sDefaultFilter = "writer8_template"
        self.myPathSelection.addSelectionListener(self)

    '''
    bind controls to the agenda member (DataAware model)
    '''

    def initConfiguration(self):
        self.xDialogModel.listPageDesign.StringItemList = \
            tuple(self.agendaTemplates[0])
        UnoDataAware.attachListBox(
            self.agenda, "cp_AgendaType", self.listPageDesign, True).updateUI()
        self.pageDesign = self.agenda.cp_AgendaType
        UnoDataAware.attachCheckBox(
            self.agenda, "cp_IncludeMinutes", self.chkMinutes, True).updateUI()
        UnoDataAware.attachEditControl(
            self.agenda, "cp_Title", self.txtTitle, True).updateUI()
        UnoDataAware.attachDateControl(
            self.agenda, "cp_Date", self.txtDate, True).updateUI()
        UnoDataAware.attachTimeControl(
            self.agenda, "cp_Time", self.txtTime, True).updateUI()
        UnoDataAware.attachEditControl(
            self.agenda, "cp_Location", self.cbLocation, True).updateUI()
        UnoDataAware.attachCheckBox(
            self.agenda, "cp_ShowMeetingType", self.chkMeetingTitle,
            True).updateUI()
        UnoDataAware.attachCheckBox(
            self.agenda, "cp_ShowRead", self.chkRead, True).updateUI()
        UnoDataAware.attachCheckBox(
            self.agenda, "cp_ShowBring", self.chkBring, True).updateUI()
        UnoDataAware.attachCheckBox(
            self.agenda, "cp_ShowNotes", self.chkNotes, True).updateUI()
        UnoDataAware.attachCheckBox(
            self.agenda, "cp_ShowCalledBy", self.chkConvenedBy,
            True).updateUI()
        UnoDataAware.attachCheckBox(
            self.agenda, "cp_ShowFacilitator", self.chkPresiding,
            True).updateUI()
        UnoDataAware.attachCheckBox(
            self.agenda, "cp_ShowNotetaker", self.chkNoteTaker,
            True).updateUI()
        UnoDataAware.attachCheckBox(
            self.agenda, "cp_ShowTimekeeper", self.chkTimekeeper,
            True).updateUI()
        UnoDataAware.attachCheckBox(
            self.agenda, "cp_ShowAttendees", self.chkAttendees,
            True).updateUI()
        UnoDataAware.attachCheckBox(
            self.agenda, "cp_ShowObservers", self.chkObservers,
            True).updateUI()
        UnoDataAware.attachCheckBox(
            self.agenda, "cp_ShowResourcePersons",self.chkResourcePersons,
            True).updateUI()
        UnoDataAware.attachEditControl(
            self.agenda, "cp_TemplateName", self.txtTemplateName,
            True).updateUI()
        RadioDataAware.attachRadioButtons(
            self.agenda, "cp_ProceedMethod",
                (self.optCreateAgenda, self.optMakeChanges), True).updateUI()

    def insertRoadmap(self):
        self.addRoadmap()
        self.insertRoadMapItems(
            self.resources.RoadmapLabels, [True, True, True, True, True, True])
        self.setRoadmapInteractive(True)
        self.setRoadmapComplete(True)
        self.setCurrentRoadmapItemID(1)

    '''
    read the available agenda wizard templates.
    '''

    def initializeTemplates(self):
        try:
            sAgendaPath = self.sTemplatePath + "/wizard/agenda"
            self.agendaTemplates = FileAccess.getFolderTitles(
                self.xMSF, "aw", sAgendaPath, self.resources.dictPageDesign)
            return True
        except NoValidPathException:
            traceback.print_exc()
            return False

    '''
    first page, page design listbox changed.
    '''

    def pageDesignChanged(self):
        try:
            SelectedItemPos = self.listPageDesign.SelectedItemPos
            #avoid to load the same item again
            if self.pageDesign is not SelectedItemPos:
                self.pageDesign = SelectedItemPos
                self.myAgendaDoc.load(
                    self.agendaTemplates[1][SelectedItemPos])
                self.drawConstants()
        except Exception:
            traceback.print_exc()

    #textFields listeners
    def txtTitleTextChanged(self):
        self.myAgendaDoc.redrawTitle("txtTitle")

    def txtDateTextChanged(self):
        self.myAgendaDoc.redrawTitle("txtDate")

    def txtTimeTextChanged(self):
        self.myAgendaDoc.redrawTitle("txtTime")

    def txtLocationTextChanged(self):
        self.myAgendaDoc.redrawTitle("cbLocation")

    #checkbox listeners
    def chkUseMeetingTypeItemChanged(self):
        self.myAgendaDoc.redraw(self.templateConsts.FILLIN_MEETING_TYPE)

    def chkUseReadItemChanged(self):
        self.myAgendaDoc.redraw(self.templateConsts.FILLIN_READ)

    def chkUseBringItemChanged(self):
        self.myAgendaDoc.redraw(self.templateConsts.FILLIN_BRING)

    def chkUseNotesItemChanged(self):
        self.myAgendaDoc.redraw(self.templateConsts.FILLIN_NOTES)

    def chkUseCalledByItemChanged(self):
        self.myAgendaDoc.redraw(self.templateConsts.FILLIN_CALLED_BY)

    def chkUseFacilitatorItemChanged(self):
        self.myAgendaDoc.redraw(self.templateConsts.FILLIN_FACILITATOR)

    def chkUseNoteTakerItemChanged(self):
        self.myAgendaDoc.redraw(self.templateConsts.FILLIN_NOTETAKER)

    def chkUseTimeKeeperItemChanged(self):
        self.myAgendaDoc.redraw(self.templateConsts.FILLIN_TIMEKEEPER)

    def chkUseAttendeesItemChanged(self):
        self.myAgendaDoc.redraw(self.templateConsts.FILLIN_PARTICIPANTS)

    def chkUseObserversItemChanged(self):
        self.myAgendaDoc.redraw(self.templateConsts.FILLIN_OBSERVERS)

    def chkUseResourcePersonsItemChanged(self):
        self.myAgendaDoc.redraw(self.templateConsts.FILLIN_RESOURCE_PERSONS)

    def insertRow(self):
        self.topicsControl.insertRow()

    def removeRow(self):
        self.topicsControl.removeRow()

    def rowUp(self):
        self.topicsControl.rowUp()

    def rowDown(self):
        self.topicsControl.rowDown()

    def cancelWizard(self):
        self.xUnoDialog.endExecute()
        self.running = False

    def finishWizard(self):
        self.switchToStep(self.getCurrentStep(), self.nMaxStep)
        bSaveSuccess = False
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
                    # user said: no, do not overwrite
                    endWizard = False
                    return False

            xDocProps = self.myAgendaDoc.xTextDocument.DocumentProperties
            xDocProps.Title = self.txtTemplateName.Text
            self.myAgendaDoc.setWizardTemplateDocInfo( \
                self.resources.resAgendaWizardDialog_title,
                self.resources.resTemplateDescription)
            bSaveSuccess = OfficeDocument.store(
                self.xMSF, self.myAgendaDoc.xTextDocument, self.sPath,
                "writer8_template")

            if bSaveSuccess:
                self.topicsControl.saveTopics(self.agenda)
                root = Configuration.getConfigurationRoot(
                    self.xMSF, "/org.openoffice.Office.Writer/Wizards/Agenda",
                    True)
                self.agenda.writeConfiguration(root, "cp_")
                root.commitChanges()

                self.myAgendaDoc.finish(self.topicsControl.scrollfields)

                loadValues = list(range(2))
                loadValues[0] = uno.createUnoStruct( \
                    'com.sun.star.beans.PropertyValue')
                loadValues[0].Name = "AsTemplate"
                if self.agenda.cp_ProceedMethod == 1:
                    loadValues[0].Value = True
                else:
                    loadValues[0].Value = False

                loadValues[1] = uno.createUnoStruct( \
                    'com.sun.star.beans.PropertyValue')
                loadValues[1].Name = "InteractionHandler"

                xIH = self.xMSF.createInstance(
                    "com.sun.star.comp.uui.UUIInteractionHandler")
                loadValues[1].Value = xIH

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
        return True

    def closeDocument(self):
        try:
            self.myAgendaDoc.xFrame.close(False)
        except CloseVetoException:
            traceback.print_exc()

    def drawConstants(self):
        '''Localise the template'''
        constRangeList = self.myAgendaDoc.searchFillInItems(1)

        for i in constRangeList:
            text = i.String.lower()
            aux = TextElement(i, self.resources.dictConstants[text])
            aux.write()

    def validatePath(self):
        if self.myPathSelection.usedPathPicker:
                self.filenameChanged = True
        self.myPathSelection.usedPathPicker = False
