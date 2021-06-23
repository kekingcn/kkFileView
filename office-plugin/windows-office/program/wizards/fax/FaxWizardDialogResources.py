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

class FaxWizardDialogResources(object):

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

        self.resFaxWizardDialog_title = strings.RID_FAXWIZARDDIALOG_START_1
        self.resoptBusinessFax_value = strings.RID_FAXWIZARDDIALOG_START_3
        self.resoptPrivateFax_value = strings.RID_FAXWIZARDDIALOG_START_4
        self.reschkUseLogo_value = strings.RID_FAXWIZARDDIALOG_START_5
        self.reschkUseSubject_value = strings.RID_FAXWIZARDDIALOG_START_6
        self.reschkUseSalutation_value = strings.RID_FAXWIZARDDIALOG_START_7
        self.reschkUseGreeting_value = strings.RID_FAXWIZARDDIALOG_START_8
        self.reschkUseFooter_value = strings.RID_FAXWIZARDDIALOG_START_9
        self.resoptSenderPlaceholder_value = strings.RID_FAXWIZARDDIALOG_START_10
        self.resoptSenderDefine_value = strings.RID_FAXWIZARDDIALOG_START_11
        self.restxtTemplateName_value = strings.RID_FAXWIZARDDIALOG_START_12
        self.resoptCreateFax_value = strings.RID_FAXWIZARDDIALOG_START_13
        self.resoptMakeChanges_value = strings.RID_FAXWIZARDDIALOG_START_14
        self.reslblBusinessStyle_value = strings.RID_FAXWIZARDDIALOG_START_15
        self.reslblPrivateStyle_value = strings.RID_FAXWIZARDDIALOG_START_16
        self.reslblIntroduction_value = strings.RID_FAXWIZARDDIALOG_START_17
        self.reslblSenderAddress_value = strings.RID_FAXWIZARDDIALOG_START_18
        self.reslblSenderName_value = strings.RID_FAXWIZARDDIALOG_START_19
        self.reslblSenderStreet_value = strings.RID_FAXWIZARDDIALOG_START_20
        self.reslblPostCodeCity_value = strings.RID_FAXWIZARDDIALOG_START_21
        self.reslblFooter_value = strings.RID_FAXWIZARDDIALOG_START_22
        self.reslblFinalExplanation1_value = strings.RID_FAXWIZARDDIALOG_START_23
        self.reslblFinalExplanation2_value = strings.RID_FAXWIZARDDIALOG_START_24
        self.reslblTemplateName_value = strings.RID_FAXWIZARDDIALOG_START_25
        self.reslblTemplatePath_value = strings.RID_FAXWIZARDDIALOG_START_26
        self.reslblProceed_value = strings.RID_FAXWIZARDDIALOG_START_27
        self.reslblTitle1_value = strings.RID_FAXWIZARDDIALOG_START_28
        self.reslblTitle3_value = strings.RID_FAXWIZARDDIALOG_START_29
        self.reslblTitle4_value = strings.RID_FAXWIZARDDIALOG_START_30
        self.reslblTitle5_value = strings.RID_FAXWIZARDDIALOG_START_31
        self.reslblTitle6_value = strings.RID_FAXWIZARDDIALOG_START_32
        self.reschkFooterNextPages_value = strings.RID_FAXWIZARDDIALOG_START_33
        self.reschkFooterPageNumbers_value = strings.RID_FAXWIZARDDIALOG_START_34
        self.reschkUseDate_value = strings.RID_FAXWIZARDDIALOG_START_35
        self.reschkUseCommunicationType_value = strings.RID_FAXWIZARDDIALOG_START_36
        self.resLabel1_value = strings.RID_FAXWIZARDDIALOG_START_37
        self.resoptReceiverPlaceholder_value = strings.RID_FAXWIZARDDIALOG_START_38
        self.resoptReceiverDatabase_value = strings.RID_FAXWIZARDDIALOG_START_39
        self.resLabel2_value = strings.RID_FAXWIZARDDIALOG_START_40

        #Create a Dictionary for the constants values.
        self.dictConstants = {
        "#to#" : strings.RID_FAXWIZARDDIALOG_START_41,
        "#from#" : strings.RID_FAXWIZARDDIALOG_START_42,
        "#faxconst#" : strings.RID_FAXWIZARDDIALOG_START_43,
        "#telconst#" : strings.RID_FAXWIZARDDIALOG_START_44,
        "#emailconst#" : strings.RID_FAXWIZARDDIALOG_START_45,
        "#consist1#" : strings.RID_FAXWIZARDDIALOG_START_46,
        "#consist2#" : strings.RID_FAXWIZARDDIALOG_START_47,
        "#consist3#" : strings.RID_FAXWIZARDDIALOG_START_48}

        #Create a dictionary for localising the private template
        self.dictPrivateTemplate = {
        "Bottle" : strings.RID_FAXWIZARDDIALOG_START_49,
        "Fax" : strings.RID_FAXWIZARDDIALOG_START_56,
        "Lines" : strings.RID_FAXWIZARDDIALOG_START_50,
        "Marine" : strings.RID_FAXWIZARDDIALOG_START_51}

        #Create a dictionary for localising the business template
        self.dictBusinessTemplate = {
        "Classic Fax" : strings.RID_FAXWIZARDDIALOG_START_52,
        "Classic Fax from Private" : strings.RID_FAXWIZARDDIALOG_START_53,
        "Modern Fax" : strings.RID_FAXWIZARDDIALOG_START_54,
        "Modern Fax from Private" : strings.RID_FAXWIZARDDIALOG_START_55}

        #Common Resources
        self.resOverwriteWarning = strings.RID_COMMON_START_19
        self.resTemplateDescription = strings.RID_COMMON_START_20

        self.RoadmapLabels = []
        self.RoadmapLabels.append(strings.RID_FAXWIZARDROADMAP_START_1)
        self.RoadmapLabels.append(strings.RID_FAXWIZARDROADMAP_START_2)
        self.RoadmapLabels.append(strings.RID_FAXWIZARDROADMAP_START_3)
        self.RoadmapLabels.append(strings.RID_FAXWIZARDROADMAP_START_4)
        self.RoadmapLabels.append(strings.RID_FAXWIZARDROADMAP_START_5)
        self.SalutationLabels = []
        self.SalutationLabels.append(strings.RID_FAXWIZARDSALUTATION_START_1)
        self.SalutationLabels.append(strings.RID_FAXWIZARDSALUTATION_START_2)
        self.SalutationLabels.append(strings.RID_FAXWIZARDSALUTATION_START_3)
        self.SalutationLabels.append(strings.RID_FAXWIZARDSALUTATION_START_4)
        self.GreetingLabels = []
        self.GreetingLabels.append(strings.RID_FAXWIZARDGREETING_START_1)
        self.GreetingLabels.append(strings.RID_FAXWIZARDGREETING_START_2)
        self.GreetingLabels.append(strings.RID_FAXWIZARDGREETING_START_3)
        self.GreetingLabels.append(strings.RID_FAXWIZARDGREETING_START_4)
        self.CommunicationLabels = []
        self.CommunicationLabels.append(strings.RID_FAXWIZARDCOMMUNICATION_START_1)
        self.CommunicationLabels.append(strings.RID_FAXWIZARDCOMMUNICATION_START_2)
        self.CommunicationLabels.append(strings.RID_FAXWIZARDCOMMUNICATION_START_3)
