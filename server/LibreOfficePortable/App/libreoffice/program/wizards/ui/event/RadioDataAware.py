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
from .CommonListener import ItemListenerProcAdapter
from .DataAware import DataAware

class RadioDataAware(DataAware):

    def __init__(self, data, value, radioButtons):
        super(RadioDataAware,self).__init__(data, value)
        self.radioButtons = radioButtons

    def setToUI(self, value):
        selected = int(value)
        if selected == -1:
            for i in self.radioButtons:
                i.State = False
        else:
            self.radioButtons[selected].State = True

    def getFromUI(self):
        for index, workwith in enumerate(self.radioButtons):
            if workwith.State:
                return index

        return -1

    @classmethod
    def attachRadioButtons(self, data, prop, buttons, field):
        da = RadioDataAware(data, prop, buttons)
        method = getattr(da,"updateData")
        for i in da.radioButtons:
            i.addItemListener(ItemListenerProcAdapter(method))
        return da
