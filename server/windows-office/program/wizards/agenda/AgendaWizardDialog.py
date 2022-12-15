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
from ..ui.WizardDialog import WizardDialog, uno, UIConsts, PropertyNames
from .AgendaWizardDialogConst import AgendaWizardDialogConst, HID
from .AgendaWizardDialogResources import AgendaWizardDialogResources

from com.sun.star.awt.FontUnderline import SINGLE

class AgendaWizardDialog(WizardDialog):

    def __init__(self, xmsf):
        super(AgendaWizardDialog,self).__init__(xmsf, HID )

        #Load Resources
        self.resources = AgendaWizardDialogResources()

        #set dialog properties...
        self.setDialogProperties(True, 210, True, 200, 52, 1, 1,
            self.resources.resAgendaWizardDialog_title, 310)

        self.PROPS_LIST = ("Dropdown",
                PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_HELPURL,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH)
        self.PROPS_LABEL_B = ("FontDescriptor",
                PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_LABEL,
                PropertyNames.PROPERTY_MULTILINE,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH)
        self.PROPS_CHECK = (PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_HELPURL,
                PropertyNames.PROPERTY_LABEL,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STATE,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH)
        self.PROPS_BUTTON = (PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_HELPURL,
                PropertyNames.PROPERTY_LABEL,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH)
        self.PROPS_X = (PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_HELPURL,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH)
        self.PROPS_TEXTAREA = (PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_LABEL,
                PropertyNames.PROPERTY_MULTILINE,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH)
        self.PROPS_TEXT = (PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_LABEL,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH)
        self.PROPS_IMAGE = ("Border",
                PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_HELPURL,
                PropertyNames.PROPERTY_IMAGEURL,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                "ScaleImage", PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH)

        self.fontDescriptor4 = \
            uno.createUnoStruct('com.sun.star.awt.FontDescriptor')
        self.fontDescriptor4.Weight = 150

    def buildStep1(self):
        self.insertLabel("lblTitle1", self.PROPS_LABEL_B,
            (self.fontDescriptor4, 16, self.resources.reslblTitle1_value,
                True, 91, 8, 1, 100,212))
        self.insertLabel("lblPageDesign", self.PROPS_TEXT,
            (8, self.resources.reslblPageDesign_value, 97, 32, 1, 101, 66))
        self.listPageDesign = self.insertListBox("listPageDesign",
            None, AgendaWizardDialogConst.LISTPAGEDESIGN_ACTION_PERFORMED,
            self.PROPS_LIST,
            (True, 12, AgendaWizardDialogConst.LISTPAGEDESIGN_HID,
                166, 30, 1, 102, 70), self)
        self.chkMinutes = self.insertCheckBox("chkMinutes", None,
            self.PROPS_CHECK, (9, AgendaWizardDialogConst.CHKMINUTES_HID,
            self.resources.reschkMinutes_value, 97, 50, 0, 1, 103, 203), self)
        self.insertImage("imgHelp1", self.PROPS_IMAGE,
            (0, 10, "", UIConsts.INFOIMAGEURL, 92, 145, False, 1, 104, 10))
        self.insertLabel("lblHelp1", self.PROPS_TEXTAREA,
            (39, self.resources.reslblHelp1_value,
                True, 104, 145, 1, 105, 199))

    def buildStep2(self):
        self.insertLabel("lblTitle2", self.PROPS_LABEL_B,
            (self.fontDescriptor4, 16, self.resources.reslblTitle2_value,
                True, 91, 8, 2, 200, 212))
        self.insertLabel("lblDate", self.PROPS_TEXT,
            (8, self.resources.reslblDate_value, 97, 32, 2, 201,66))
        self.txtDate = self.insertDateField(
            "txtDate", AgendaWizardDialogConst.TXTDATE_TEXT_CHANGED,
            self.PROPS_LIST,
            (True, 12, AgendaWizardDialogConst.TXTDATE_HID,
                166,30, 2, 202, 70), self)
        self.insertLabel("lblTime", self.PROPS_TEXT,
            (8, self.resources.reslblTime_value, 97, 50, 2, 203, 66))
        self.txtTime = self.insertTimeField("txtTime",
            AgendaWizardDialogConst.TXTTIME_TEXT_CHANGED,
            (PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_HELPURL,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                "StrictFormat",
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH),
            (12, AgendaWizardDialogConst.TXTTIME_HID,
                166, 48, 2, True, 204, 70), self)
        self.insertLabel("lblTitle", self.PROPS_TEXT,
            (8, self.resources.reslblTitle_value, 97, 68, 2, 205, 66))
        self.txtTitle = self.insertTextField(
            "txtTitle", AgendaWizardDialogConst.TXTTITLE_TEXT_CHANGED,
            (PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_HELPURL,
                PropertyNames.PROPERTY_MULTILINE,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH),
            (26, AgendaWizardDialogConst.TXTTITLE_HID,
                True, 166, 66, 2, 206, 138), self)
        self.insertLabel("lblLocation", self.PROPS_TEXT,
            (8, self.resources.reslblLocation_value, 97, 100, 2, 207, 66))
        self.cbLocation = self.insertTextField(
            "cbLocation", AgendaWizardDialogConst.TXTLOCATION_TEXT_CHANGED,
            (PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_HELPURL,
                PropertyNames.PROPERTY_MULTILINE,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_TABINDEX,
                PropertyNames.PROPERTY_WIDTH),
            (34, AgendaWizardDialogConst.CBLOCATION_HID,
                True, 166,98, 2, 208, 138), self)
        self.insertImage("imgHelp2", self.PROPS_IMAGE,
            (0, 10, "", UIConsts.INFOIMAGEURL, 92, 145, False, 2, 209, 10))
        self.insertLabel("lblHelp2", self.PROPS_TEXTAREA,
            (39, self.resources.reslblHelp2_value,
                True, 104, 145, 2, 210, 199))

    def buildStep3(self):
        self.insertLabel("lblTitle3", self.PROPS_LABEL_B,
            (self.fontDescriptor4, 16, self.resources.reslblTitle3_value,
                True, 91, 8, 3, 300,212))
        self.chkMeetingTitle = self.insertCheckBox("chkMeetingTitle",
            AgendaWizardDialogConst.CHKUSEMEETINGTYPE_ITEM_CHANGED,
            self.PROPS_CHECK,
            (8, AgendaWizardDialogConst.CHKMEETINGTITLE_HID,
                self.resources.reschkMeetingTitle_value,
                97, 32, 1, 3, 301, 69), self)
        self.chkRead = self.insertCheckBox("chkRead",
            AgendaWizardDialogConst.CHKUSEREAD_ITEM_CHANGED, self.PROPS_CHECK,
            (8, AgendaWizardDialogConst.CHKREAD_HID,
                self.resources.reschkRead_value, 97, 46, 0, 3, 302, 162), self)
        self.chkBring = self.insertCheckBox("chkBring",
            AgendaWizardDialogConst.CHKUSEBRING_ITEM_CHANGED, self.PROPS_CHECK,
            (8, AgendaWizardDialogConst.CHKBRING_HID,
                self.resources.reschkBring_value,
                97, 60, 0, 3, 303, 162), self)
        self.chkNotes = self.insertCheckBox("chkNotes",
            AgendaWizardDialogConst.CHKUSENOTES_ITEM_CHANGED, self.PROPS_CHECK,
            (8, AgendaWizardDialogConst.CHKNOTES_HID,
                self.resources.reschkNotes_value,
                97, 74, 1, 3, 304, 160), self)
        self.insertImage("imgHelp3", self.PROPS_IMAGE, (0, 10,
            "", UIConsts.INFOIMAGEURL, 92, 145, False, 3, 305, 10))
        self.insertLabel("lblHelp3", self.PROPS_TEXTAREA,
            (39, self.resources.reslblHelp3_value, True,104, 145, 3, 306, 199))

    def buildStep4(self):
        self.insertLabel("lblTitle5", self.PROPS_LABEL_B,
            (self.fontDescriptor4, 16, self.resources.reslblTitle5_value,
                True, 91, 8, 4, 400, 212))
        self.chkConvenedBy = self.insertCheckBox("chkConvenedBy",
            AgendaWizardDialogConst.CHKUSECALLEDBYNAME_ITEM_CHANGED,
            self.PROPS_CHECK,
            (8, AgendaWizardDialogConst.CHKCONVENEDBY_HID,
                self.resources.reschkConvenedBy_value,
                97, 32, 1, 4, 401, 150), self)
        self.chkPresiding = self.insertCheckBox("chkPresiding",
            AgendaWizardDialogConst.CHKUSEFACILITATOR_ITEM_CHANGED,
            self.PROPS_CHECK,
            (8, AgendaWizardDialogConst.CHKPRESIDING_HID,
                self.resources.reschkPresiding_value,
                97, 46, 0, 4, 402, 150), self)
        self.chkNoteTaker = self.insertCheckBox("chkNoteTaker",
            AgendaWizardDialogConst.CHKUSENOTETAKER_ITEM_CHANGED,
            self.PROPS_CHECK,
            (8, AgendaWizardDialogConst.CHKNOTETAKER_HID,
                self.resources.reschkNoteTaker_value,
                97, 60, 0, 4, 403, 150), self)
        self.chkTimekeeper = self.insertCheckBox("chkTimekeeper",
            AgendaWizardDialogConst.CHKUSETIMEKEEPER_ITEM_CHANGED,
            self.PROPS_CHECK,
            (8, AgendaWizardDialogConst.CHKTIMEKEEPER_HID,
                self.resources.reschkTimekeeper_value,
                97, 74, 0, 4, 404, 150), self)
        self.chkAttendees = self.insertCheckBox("chkAttendees",
            AgendaWizardDialogConst.CHKUSEATTENDEES_ITEM_CHANGED,
            self.PROPS_CHECK,
            (8, AgendaWizardDialogConst.CHKATTENDEES_HID,
                self.resources.reschkAttendees_value,
                97, 88, 1, 4, 405, 150), self)
        self.chkObservers = self.insertCheckBox("chkObservers",
            AgendaWizardDialogConst.CHKUSEOBSERVERS_ITEM_CHANGED,
            self.PROPS_CHECK,
            (8, AgendaWizardDialogConst.CHKOBSERVERS_HID,
                self.resources.reschkObservers_value,
                97, 102, 0, 4, 406, 150), self)
        self.chkResourcePersons = self.insertCheckBox("chkResourcePersons",
            AgendaWizardDialogConst.CHKUSERESOURCEPERSONS_ITEM_CHANGED,
            self.PROPS_CHECK,
            (8, AgendaWizardDialogConst.CHKRESOURCEPERSONS_HID,
                self.resources.reschkResourcePersons_value,
                97, 116, 0, 4, 407, 150), self)
        self.insertImage("imgHelp4", self.PROPS_IMAGE,
            (0, 10, "", UIConsts.INFOIMAGEURL,
                92, 145, False, 4, 408, 10))
        self.insertLabel("lblHelp4", self.PROPS_TEXTAREA,
            (39, self.resources.reslblHelp4_value, True, 104, 145, 4, 409, 199))

    def buildStep5(self):
        self.insertLabel("lblTitle4", self.PROPS_LABEL_B,
            (self.fontDescriptor4, 16, self.resources.reslblTitle4_value,
                True, 91, 8, 5, 500, 212))
        self.insertLabel("lblTopic", self.PROPS_TEXT,
            (8, self.resources.reslblTopic_value, 107, 28, 5, 71, 501))
        self.insertLabel("lblResponsible", self.PROPS_TEXT,
            (8, self.resources.reslblResponsible_value, 195, 28, 5, 72, 502))
        self.insertLabel("lblDuration", self.PROPS_TEXT,
            (8, self.resources.reslblDuration_value, 267, 28, 5, 73, 503))
        self.btnInsert = self.insertButton("btnInsert",
            AgendaWizardDialogConst.BTNINSERT_ACTION_PERFORMED,
            self.PROPS_BUTTON, (14, AgendaWizardDialogConst.BTNINSERT_HID,
                self.resources.resButtonInsert, 92, 136, 5, 580, 40), self)
        self.btnRemove = self.insertButton("btnRemove",
            AgendaWizardDialogConst.BTNREMOVE_ACTION_PERFORMED,
            self.PROPS_BUTTON, (14, AgendaWizardDialogConst.BTNREMOVE_HID,
                self.resources.resButtonRemove, 134, 136, 5, 581, 40), self)
        self.btnUp = self.insertButton("btnUp",
            AgendaWizardDialogConst.BTNUP_ACTION_PERFORMED,
            self.PROPS_BUTTON, (14, AgendaWizardDialogConst.BTNUP_HID,
                self.resources.resButtonUp, 180, 136, 5, 582, 60), self)
        self.btnDown = self.insertButton("btnDown",
            AgendaWizardDialogConst.BTNDOWN_ACTION_PERFORMED,
            self.PROPS_BUTTON, (14, AgendaWizardDialogConst.BTNDOWN_HID,
                self.resources.resButtonDown, 244, 136, 5, 583, 60), self)

    def buildStep6(self):
        self.insertLabel("lblTitle6", self.PROPS_LABEL_B,
            (self.fontDescriptor4, 16, self.resources.reslblTitle6_value,
                True, 91, 8, 6, 600, 212))
        self.insertLabel("lblHelpPg6", self.PROPS_TEXTAREA,
            (24, self.resources.reslblHelpPg6_value, True,
                97, 32, 6, 601,204))
        self.insertLabel("lblTemplateName", self.PROPS_TEXT,
            (8, self.resources.reslblTemplateName_value,
                97, 62, 6, 602, 101))
        self.txtTemplateName = self.insertTextField("txtTemplateName",
            None, self.PROPS_X,
            (12, AgendaWizardDialogConst.TXTTEMPLATENAME_HID,
                202, 60, 6, 603, 100), self)
        self.insertLabel("lblProceed", self.PROPS_TEXT,
            (8, self.resources.reslblProceed_value, 97, 101, 6, 607,204))
        self.optCreateAgenda = self.insertRadioButton("optCreateAgenda", None,
            self.PROPS_CHECK, (8, AgendaWizardDialogConst.OPTCREATEAGENDA_HID,
                self.resources.resoptCreateAgenda_value,
                103, 113, 1, 6, 608, 198), self)
        self.optMakeChanges = self.insertRadioButton("optMakeChanges", None,
            self.PROPS_BUTTON, (8, AgendaWizardDialogConst.OPTMAKECHANGES_HID,
                self.resources.resoptMakeChanges_value,
                103, 125, 6, 609, 198), self)
        self.insertImage("imgHelp6", self.PROPS_IMAGE, (0, 10, "",
            UIConsts.INFOIMAGEURL, 92, 145, False, 6, 610, 10))
        self.insertLabel("lblHelp6", self.PROPS_TEXTAREA,
            (39, self.resources.reslblHelp6_value, True, 104, 145, 6, 611, 199))
