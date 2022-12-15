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

class AgendaWizardDialogResources(object):

    SECTION_ITEMS = "AGENDA_ITEMS"
    SECTION_TOPICS = "AGENDA_TOPICS"
    SECTION_MINUTES_ALL = "MINUTES_ALL"
    SECTION_MINUTES = "MINUTES"

    def __init__(self):
        import sys, os

        # imp is deprecated since Python v.3.4
        if sys.version_info >= (3,3):
            from importlib.machinery import SourceFileLoader
            SourceFileLoader('strings', os.path.join(os.path.dirname(__file__), '../common/strings.hrc')).load_module()
        else:
            import imp
            imp.load_source('strings', os.path.join(os.path.dirname(__file__), '../common/strings.hrc'))

        import strings

        self.resAgendaWizardDialog_title = strings.RID_AGENDAWIZARDDIALOG_START_1
        self.resoptMakeChanges_value = strings.RID_AGENDAWIZARDDIALOG_START_2
        self.reslblTemplateName_value = strings.RID_AGENDAWIZARDDIALOG_START_3
        self.reslblTemplatePath_value = strings.RID_AGENDAWIZARDDIALOG_START_4
        self.reslblProceed_value = strings.RID_AGENDAWIZARDDIALOG_START_5
        self.reslblTitle1_value = strings.RID_AGENDAWIZARDDIALOG_START_6
        self.reslblTitle3_value = strings.RID_AGENDAWIZARDDIALOG_START_7
        self.reslblTitle2_value = strings.RID_AGENDAWIZARDDIALOG_START_8
        self.reslblTitle4_value = strings.RID_AGENDAWIZARDDIALOG_START_9
        self.reslblTitle5_value = strings.RID_AGENDAWIZARDDIALOG_START_10
        self.reslblTitle6_value = strings.RID_AGENDAWIZARDDIALOG_START_11
        self.reschkMinutes_value = strings.RID_AGENDAWIZARDDIALOG_START_12
        self.reslblHelp1_value = strings.RID_AGENDAWIZARDDIALOG_START_13
        self.reslblTime_value = strings.RID_AGENDAWIZARDDIALOG_START_14
        self.reslblTitle_value = strings.RID_AGENDAWIZARDDIALOG_START_15
        self.reslblLocation_value = strings.RID_AGENDAWIZARDDIALOG_START_16
        self.reslblHelp2_value = strings.RID_AGENDAWIZARDDIALOG_START_17
        self.resbtnTemplatePath_value = strings.RID_AGENDAWIZARDDIALOG_START_18
        self.resoptCreateAgenda_value = strings.RID_AGENDAWIZARDDIALOG_START_19
        self.reslblHelp6_value = strings.RID_AGENDAWIZARDDIALOG_START_20
        self.reslblTopic_value = strings.RID_AGENDAWIZARDDIALOG_START_21
        self.reslblResponsible_value = strings.RID_AGENDAWIZARDDIALOG_START_22
        self.reslblDuration_value = strings.RID_AGENDAWIZARDDIALOG_START_23
        self.reschkConvenedBy_value = strings.RID_AGENDAWIZARDDIALOG_START_24
        self.reschkPresiding_value = strings.RID_AGENDAWIZARDDIALOG_START_25
        self.reschkNoteTaker_value = strings.RID_AGENDAWIZARDDIALOG_START_26
        self.reschkTimekeeper_value = strings.RID_AGENDAWIZARDDIALOG_START_27
        self.reschkAttendees_value = strings.RID_AGENDAWIZARDDIALOG_START_28
        self.reschkObservers_value = strings.RID_AGENDAWIZARDDIALOG_START_29
        self.reschkResourcePersons_value = strings.RID_AGENDAWIZARDDIALOG_START_30
        self.reslblHelp4_value = strings.RID_AGENDAWIZARDDIALOG_START_31
        self.reschkMeetingTitle_value = strings.RID_AGENDAWIZARDDIALOG_START_32
        self.reschkRead_value = strings.RID_AGENDAWIZARDDIALOG_START_33
        self.reschkBring_value = strings.RID_AGENDAWIZARDDIALOG_START_34
        self.reschkNotes_value = strings.RID_AGENDAWIZARDDIALOG_START_35
        self.reslblHelp3_value = strings.RID_AGENDAWIZARDDIALOG_START_36
        self.reslblDate_value = strings.RID_AGENDAWIZARDDIALOG_START_38
        self.reslblHelpPg6_value = strings.RID_AGENDAWIZARDDIALOG_START_39
        self.reslblPageDesign_value = strings.RID_AGENDAWIZARDDIALOG_START_40
        self.resDefaultFilename = strings.RID_AGENDAWIZARDDIALOG_START_41
        self.resDefaultFilename = self.resDefaultFilename[:-4] + ".ott"
        self.resDefaultTitle = strings.RID_AGENDAWIZARDDIALOG_START_42
        self.resErrSaveTemplate = strings.RID_AGENDAWIZARDDIALOG_START_43
        self.resPlaceHolderTitle = strings.RID_AGENDAWIZARDDIALOG_START_44
        self.resPlaceHolderDate = strings.RID_AGENDAWIZARDDIALOG_START_45
        self.resPlaceHolderTime = strings.RID_AGENDAWIZARDDIALOG_START_46
        self.resPlaceHolderLocation = strings.RID_AGENDAWIZARDDIALOG_START_47
        self.resPlaceHolderHint = strings.RID_AGENDAWIZARDDIALOG_START_48
        self.resErrOpenTemplate = strings.RID_AGENDAWIZARDDIALOG_START_56
        self.itemMeetingType = strings.RID_AGENDAWIZARDDIALOG_START_57
        self.itemBring = strings.RID_AGENDAWIZARDDIALOG_START_58
        self.itemRead = strings.RID_AGENDAWIZARDDIALOG_START_59
        self.itemNote = strings.RID_AGENDAWIZARDDIALOG_START_60
        self.itemCalledBy = strings.RID_AGENDAWIZARDDIALOG_START_61
        self.itemFacilitator = strings.RID_AGENDAWIZARDDIALOG_START_62
        self.itemAttendees = strings.RID_AGENDAWIZARDDIALOG_START_63
        self.itemNotetaker = strings.RID_AGENDAWIZARDDIALOG_START_64
        self.itemTimekeeper = strings.RID_AGENDAWIZARDDIALOG_START_65
        self.itemObservers = strings.RID_AGENDAWIZARDDIALOG_START_66
        self.itemResource = strings.RID_AGENDAWIZARDDIALOG_START_67
        self.resButtonInsert = strings.RID_AGENDAWIZARDDIALOG_START_68
        self.resButtonRemove = strings.RID_AGENDAWIZARDDIALOG_START_69
        self.resButtonUp = strings.RID_AGENDAWIZARDDIALOG_START_70
        self.resButtonDown = strings.RID_AGENDAWIZARDDIALOG_START_71

        #Create a dictionary for localised string in the template
        self.dictConstants = {
        "#datetitle#" : strings.RID_AGENDAWIZARDDIALOG_START_72,
        "#timetitle#" : strings.RID_AGENDAWIZARDDIALOG_START_73,
        "#locationtitle#" : strings.RID_AGENDAWIZARDDIALOG_START_74,
        "#topics#" : strings.RID_AGENDAWIZARDDIALOG_START_75,
        "#num.#" : strings.RID_AGENDAWIZARDDIALOG_START_76,
        "#topicheader#" : strings.RID_AGENDAWIZARDDIALOG_START_77,
        "#responsibleheader#" : strings.RID_AGENDAWIZARDDIALOG_START_78,
        "#timeheader#" : strings.RID_AGENDAWIZARDDIALOG_START_79,
        "#additional-information#" : strings.RID_AGENDAWIZARDDIALOG_START_80,
        "#minutes-for#" : strings.RID_AGENDAWIZARDDIALOG_START_81,
        "#discussion#" : strings.RID_AGENDAWIZARDDIALOG_START_82,
        "#conclusion#" : strings.RID_AGENDAWIZARDDIALOG_START_83,
        "#to-do#" : strings.RID_AGENDAWIZARDDIALOG_START_84,
        "#responsible-party#" : strings.RID_AGENDAWIZARDDIALOG_START_85,
        "#deadline#" : strings.RID_AGENDAWIZARDDIALOG_START_86}

        #Create a dictionary for localising the page design
        self.dictPageDesign = {
        "Blue" : strings.RID_AGENDAWIZARDDIALOG_START_87,
        "Classic" : strings.RID_AGENDAWIZARDDIALOG_START_88,
        "Colorful" : strings.RID_AGENDAWIZARDDIALOG_START_89,
        "Elegant" : strings.RID_AGENDAWIZARDDIALOG_START_90,
        "Green" : strings.RID_AGENDAWIZARDDIALOG_START_91,
        "Grey" : strings.RID_AGENDAWIZARDDIALOG_START_92,
        "Modern" : strings.RID_AGENDAWIZARDDIALOG_START_93,
        "Orange" : strings.RID_AGENDAWIZARDDIALOG_START_94,
        "Red" : strings.RID_AGENDAWIZARDDIALOG_START_95,
        "Simple" : strings.RID_AGENDAWIZARDDIALOG_START_96}

        #Common Resources
        self.resOverwriteWarning = strings.RID_COMMON_START_19
        self.resTemplateDescription = strings.RID_COMMON_START_20

        self.RoadmapLabels = []
        self.RoadmapLabels.append(strings.RID_AGENDAWIZARDDIALOG_START_50)
        self.RoadmapLabels.append(strings.RID_AGENDAWIZARDDIALOG_START_51)
        self.RoadmapLabels.append(strings.RID_AGENDAWIZARDDIALOG_START_52)
        self.RoadmapLabels.append(strings.RID_AGENDAWIZARDDIALOG_START_53)
        self.RoadmapLabels.append(strings.RID_AGENDAWIZARDDIALOG_START_54)
        self.RoadmapLabels.append(strings.RID_AGENDAWIZARDDIALOG_START_55)
