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
import uno
from .CommonListener import ItemListenerProcAdapter, TextListenerProcAdapter
from .DataAware import DataAware, datetime, Date, Time
from ...common.PropertyNames import PropertyNames

'''
This class supports simple cases where a UI control can
be directly synchronized with a data property.
Such controls are: the different text controls
(synchronizing the "Text" , "Value", "Date", "Time" property),
Checkbox controls, Dropdown listbox controls (synchronizing the
SelectedItems[] property.
For those controls, static convenience methods are offered, to simplify use.
'''

class UnoDataAware(DataAware):

    def __init__(self, dataObject, field, unoObject_, unoPropName_, isShort=False):
        super(UnoDataAware,self).__init__(dataObject, field)
        self.unoControl = unoObject_
        self.unoModel = self.unoControl.Model
        self.unoPropName = unoPropName_
        self.isShort = isShort

    def setToUI(self, value):
        if (isinstance(value, list)):
            value = tuple(value)
        elif self.isShort:
            value = uno.Any("[]short", (value,))
        if value:
            if(hasattr(self.unoModel, self.unoPropName)):
                if self.unoPropName == "Date":
                    d = datetime.strptime(value, '%d/%m/%y')
                    value = Date(d.day, d.month, d.year)
                elif self.unoPropName == "Time":
                    t = datetime.strptime(value, '%H:%M')
                    value = Time(0, 0, t.minute, t.hour, False)

                setattr(self.unoModel, self.unoPropName, value)
            else:
                uno.invoke(self.unoModel, "set" + self.unoPropName, (value,))

    def getFromUI(self):
        return getattr(self.unoModel, self.unoPropName)

    @classmethod
    def __attachTextControl(
        self, data, prop, unoText, unoProperty, field, value):
        uda = UnoDataAware(data, prop, unoText, unoProperty)
        method = getattr(uda,"updateData")
        unoText.addTextListener(TextListenerProcAdapter(method))
        return uda

    @classmethod
    def attachEditControl(self, data, prop, unoControl, field):
        return self.__attachTextControl(
            data, prop, unoControl, "Text", field, "")

    @classmethod
    def attachDateControl(self, data, prop, unoControl, field):
        return self.__attachTextControl(
            data, prop, unoControl, "Date", field, 0)

    @classmethod
    def attachTimeControl(self, data, prop, unoControl, field):
        return self.__attachTextControl(
            data, prop, unoControl, "Time", field, 0)

    @classmethod
    def attachNumericControl(self, data, prop, unoControl, field):
        return self.__attachTextControl(
            data, prop, unoControl, "Value", field, float(0))

    @classmethod
    def attachCheckBox(
            self, data, prop, checkBox, field):
        uda = UnoDataAware(data, prop, checkBox, PropertyNames.PROPERTY_STATE)
        method = getattr(uda,"updateData")
        checkBox.addItemListener(ItemListenerProcAdapter(method))
        return uda

    @classmethod
    def attachListBox(self, data, prop, listBox, field):
        uda = UnoDataAware(data, prop, listBox, "SelectedItems", True)
        method = getattr(uda,"updateData")
        listBox.addItemListener(ItemListenerProcAdapter(method))
        return uda
