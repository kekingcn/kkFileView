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
from ..common.ConfigSet import ConfigSet
from .CGTopic import CGTopic

class CGAgenda(ConfigGroup):

    def __init__(self):
        self.cp_AgendaType = int()
        self.cp_IncludeMinutes = bool()
        self.cp_Title = ""
        self.cp_Date = str()
        self.cp_Time = str()
        self.cp_Location = ""
        self.cp_ShowMeetingType = bool()
        self.cp_ShowRead = bool()
        self.cp_ShowBring = bool()
        self.cp_ShowNotes = bool()
        self.cp_ShowCalledBy = bool()
        self.cp_ShowFacilitator = bool()
        self.cp_ShowNotetaker = bool()
        self.cp_ShowTimekeeper = bool()
        self.cp_ShowAttendees = bool()
        self.cp_ShowObservers = bool()
        self.cp_ShowResourcePersons = bool()
        self.cp_TemplateName = str()
        self.cp_TemplatePath = str()
        self.cp_ProceedMethod = int()

        self.cp_Topics = ConfigSet(CGTopic)
