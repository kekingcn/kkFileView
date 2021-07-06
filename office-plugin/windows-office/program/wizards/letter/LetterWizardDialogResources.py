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

class LetterWizardDialogResources(object):

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

        self.resLetterWizardDialog_title = strings.RID_LETTERWIZARDDIALOG_START_1
        self.resLabel9_value = strings.RID_LETTERWIZARDDIALOG_START_2
        self.resoptBusinessLetter_value = strings.RID_LETTERWIZARDDIALOG_START_3
        self.resoptPrivOfficialLetter_value = strings.RID_LETTERWIZARDDIALOG_START_4
        self.resoptPrivateLetter_value = strings.RID_LETTERWIZARDDIALOG_START_5
        self.reschkBusinessPaper_value = strings.RID_LETTERWIZARDDIALOG_START_6
        self.reschkPaperCompanyLogo_value = strings.RID_LETTERWIZARDDIALOG_START_7
        self.reschkPaperCompanyAddress_value = strings.RID_LETTERWIZARDDIALOG_START_8
        self.reschkPaperFooter_value = strings.RID_LETTERWIZARDDIALOG_START_9
        self.reschkCompanyReceiver_value = strings.RID_LETTERWIZARDDIALOG_START_10
        self.reschkUseLogo_value = strings.RID_LETTERWIZARDDIALOG_START_11
        self.reschkUseAddressReceiver_value = strings.RID_LETTERWIZARDDIALOG_START_12
        self.reschkUseSigns_value = strings.RID_LETTERWIZARDDIALOG_START_13
        self.reschkUseSubject_value = strings.RID_LETTERWIZARDDIALOG_START_14
        self.reschkUseSalutation_value = strings.RID_LETTERWIZARDDIALOG_START_15
        self.reschkUseBendMarks_value = strings.RID_LETTERWIZARDDIALOG_START_16
        self.reschkUseGreeting_value = strings.RID_LETTERWIZARDDIALOG_START_17
        self.reschkUseFooter_value = strings.RID_LETTERWIZARDDIALOG_START_18
        self.resoptSenderPlaceholder_value = strings.RID_LETTERWIZARDDIALOG_START_19
        self.resoptSenderDefine_value = strings.RID_LETTERWIZARDDIALOG_START_20
        self.resoptReceiverPlaceholder_value = strings.RID_LETTERWIZARDDIALOG_START_21
        self.resoptReceiverDatabase_value = strings.RID_LETTERWIZARDDIALOG_START_22
        self.reschkFooterNextPages_value = strings.RID_LETTERWIZARDDIALOG_START_23
        self.reschkFooterPageNumbers_value = strings.RID_LETTERWIZARDDIALOG_START_24
        self.restxtTemplateName_value = strings.RID_LETTERWIZARDDIALOG_START_25
        self.resoptCreateLetter_value = strings.RID_LETTERWIZARDDIALOG_START_26
        self.resoptMakeChanges_value = strings.RID_LETTERWIZARDDIALOG_START_27
        self.reslblBusinessStyle_value = strings.RID_LETTERWIZARDDIALOG_START_28
        self.reslblPrivOfficialStyle_value = strings.RID_LETTERWIZARDDIALOG_START_29
        self.reslblPrivateStyle_value = strings.RID_LETTERWIZARDDIALOG_START_30
        self.reslblIntroduction_value = strings.RID_LETTERWIZARDDIALOG_START_31
        self.reslblLogoHeight_value = strings.RID_LETTERWIZARDDIALOG_START_32
        self.reslblLogoWidth_value = strings.RID_LETTERWIZARDDIALOG_START_33
        self.reslblLogoX_value = strings.RID_LETTERWIZARDDIALOG_START_34
        self.reslblLogoY_value = strings.RID_LETTERWIZARDDIALOG_START_35
        self.reslblAddressHeight_value = strings.RID_LETTERWIZARDDIALOG_START_36
        self.reslblAddressWidth_value = strings.RID_LETTERWIZARDDIALOG_START_37
        self.reslblAddressX_value = strings.RID_LETTERWIZARDDIALOG_START_38
        self.reslblAddressY_value = strings.RID_LETTERWIZARDDIALOG_START_39
        self.reslblFooterHeight_value = strings.RID_LETTERWIZARDDIALOG_START_40
        self.reslblSenderAddress_value = strings.RID_LETTERWIZARDDIALOG_START_42
        self.reslblSenderName_value = strings.RID_LETTERWIZARDDIALOG_START_43
        self.reslblSenderStreet_value = strings.RID_LETTERWIZARDDIALOG_START_44
        self.reslblPostCodeCity_value = strings.RID_LETTERWIZARDDIALOG_START_45
        self.reslblReceiverAddress_value = strings.RID_LETTERWIZARDDIALOG_START_46
        self.reslblFooter_value = strings.RID_LETTERWIZARDDIALOG_START_47
        self.reslblFinalExplanation1_value = strings.RID_LETTERWIZARDDIALOG_START_48
        self.reslblFinalExplanation2_value = strings.RID_LETTERWIZARDDIALOG_START_49
        self.reslblTemplateName_value = strings.RID_LETTERWIZARDDIALOG_START_50
        self.reslblTemplatePath_value = strings.RID_LETTERWIZARDDIALOG_START_51
        self.reslblProceed_value = strings.RID_LETTERWIZARDDIALOG_START_52
        self.reslblTitle1_value = strings.RID_LETTERWIZARDDIALOG_START_53
        self.reslblTitle3_value = strings.RID_LETTERWIZARDDIALOG_START_54
        self.reslblTitle2_value = strings.RID_LETTERWIZARDDIALOG_START_55
        self.reslblTitle4_value = strings.RID_LETTERWIZARDDIALOG_START_56
        self.reslblTitle5_value = strings.RID_LETTERWIZARDDIALOG_START_57
        self.reslblTitle6_value = strings.RID_LETTERWIZARDDIALOG_START_58

        #Create a Dictionary for the constants values.
        self.dictConstants = {
        "#subjectconst#" : strings.RID_LETTERWIZARDDIALOG_START_59}

        #Create a dictionary for localising the business templates
        self.dictBusinessTemplate = {
        "Elegant" : strings.RID_LETTERWIZARDDIALOG_START_60,
        "Modern" : strings.RID_LETTERWIZARDDIALOG_START_61,
        "Office" : strings.RID_LETTERWIZARDDIALOG_START_62}

        #Create a dictionary for localising the official templates
        self.dictOfficialTemplate = {
        "Elegant" : strings.RID_LETTERWIZARDDIALOG_START_60,
        "Modern" : strings.RID_LETTERWIZARDDIALOG_START_61,
        "Office" : strings.RID_LETTERWIZARDDIALOG_START_62}

        #Create a dictionary for localising the private templates
        self.dictPrivateTemplate = {
        "Bottle" : strings.RID_LETTERWIZARDDIALOG_START_63,
        "Mail" : strings.RID_LETTERWIZARDDIALOG_START_64,
        "Marine" : strings.RID_LETTERWIZARDDIALOG_START_65,
        "Red Line" : strings.RID_LETTERWIZARDDIALOG_START_66}

        #Common Resources
        self.resOverwriteWarning = strings.RID_COMMON_START_19
        self.resTemplateDescription = strings.RID_COMMON_START_20

        self.RoadmapLabels = []
        self.RoadmapLabels.append(strings.RID_LETTERWIZARDROADMAP_START_1)
        self.RoadmapLabels.append(strings.RID_LETTERWIZARDROADMAP_START_2)
        self.RoadmapLabels.append(strings.RID_LETTERWIZARDROADMAP_START_3)
        self.RoadmapLabels.append(strings.RID_LETTERWIZARDROADMAP_START_4)
        self.RoadmapLabels.append(strings.RID_LETTERWIZARDROADMAP_START_5)
        self.RoadmapLabels.append(strings.RID_LETTERWIZARDROADMAP_START_6)
        self.SalutationLabels = []
        self.SalutationLabels.append(strings.RID_LETTERWIZARDSALUTATION_START_1)
        self.SalutationLabels.append(strings.RID_LETTERWIZARDSALUTATION_START_2)
        self.SalutationLabels.append(strings.RID_LETTERWIZARDSALUTATION_START_3)
        self.GreetingLabels = []
        self.GreetingLabels.append(strings.RID_LETTERWIZARDGREETING_START_1)
        self.GreetingLabels.append(strings.RID_LETTERWIZARDGREETING_START_2)
        self.GreetingLabels.append(strings.RID_LETTERWIZARDGREETING_START_3)
