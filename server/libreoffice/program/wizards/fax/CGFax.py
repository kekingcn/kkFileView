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
from ..common.ConfigGroup import ConfigGroup

class CGFax(ConfigGroup):

    def __init__(self):

        self.cp_Style = int()
        self.cp_PrintCompanyLogo = bool()
        self.cp_PrintDate = bool()
        self.cp_PrintSubjectLine = bool()
        self.cp_PrintSalutation = bool()
        self.cp_PrintCommunicationType = bool()
        self.cp_PrintGreeting = bool()
        self.cp_PrintFooter = bool()
        self.cp_CommunicationType = str()
        self.cp_Salutation = str()
        self.cp_Greeting = str()
        self.cp_SenderAddressType = int()
        self.cp_SenderCompanyName = str()
        self.cp_SenderStreet = str()
        self.cp_SenderPostCode = str()
        self.cp_SenderState = str()
        self.cp_SenderCity = str()
        self.cp_SenderFax = str()
        self.cp_ReceiverAddressType = int()
        self.cp_Footer = str()
        self.cp_FooterOnlySecondPage = bool()
        self.cp_FooterPageNumbers = bool()
        self.cp_CreationType = int()
        self.cp_TemplateName = str()
        self.cp_TemplatePath = str()
