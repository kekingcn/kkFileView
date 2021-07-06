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
import time

from com.sun.star.util import DateTime
from com.sun.star.uno import RuntimeException
from com.sun.star.beans import UnknownPropertyException

class TextFieldHandler(object):

    xTextFieldsSupplierAux = None
    arrayTextFields = []
    dictTextFields = {}

    def __init__(self, xMSF, xTextDocument):
        self.xMSFDoc = xMSF
        self.xTextFieldsSupplier = xTextDocument
        if TextFieldHandler.xTextFieldsSupplierAux is not \
                self.xTextFieldsSupplier:
            self.__getTextFields()
            TextFieldHandler.xTextFieldsSupplierAux = self.xTextFieldsSupplier

    def refreshTextFields(self):
        xUp = self.xTextFieldsSupplier.TextFields
        xUp.refresh()

    def __getTextFields(self):
        try:
            if self.xTextFieldsSupplier.TextFields.hasElements():
                xEnum = \
                    self.xTextFieldsSupplier.TextFields.createEnumeration()
                while xEnum.hasMoreElements():
                    oTextField = xEnum.nextElement()
                    TextFieldHandler.arrayTextFields.append(oTextField)
                    xPropertySet = oTextField.TextFieldMaster
                    if xPropertySet.Name:
                        TextFieldHandler.dictTextFields[xPropertySet.Name] = \
                            oTextField
        except Exception:
            traceback.print_exc()

    def changeUserFieldContent(self, _FieldName, _FieldContent):
        try:
            DependentTextFields = \
                TextFieldHandler.dictTextFields[_FieldName]
        except KeyError:
            return None
        try:
            if hasattr(DependentTextFields, "TextFieldMaster"):
                DependentTextFields.TextFieldMaster.Content = _FieldContent
                self.refreshTextFields()
        except UnknownPropertyException:
            pass

    def updateDocInfoFields(self):
        try:
            for i in TextFieldHandler.arrayTextFields:
                if i.supportsService(
                    "com.sun.star.text.TextField.ExtendedUser"):
                    i.update()

                if i.supportsService(
                    "com.sun.star.text.TextField.User"):
                    i.update()

        except Exception:
            traceback.print_exc()

    def updateDateFields(self):
        try:
            now = time.localtime(time.time())
            dt = DateTime()
            dt.Day = time.strftime("%d", now)
            dt.Year = time.strftime("%Y", now)
            dt.Month = time.strftime("%m", now)
            dt.Month += 1
            for i in TextFieldHandler.arrayTextFields:
                if i.supportsService(
                    "com.sun.star.text.TextField.DateTime"):
                    try:
                        i.IsFixed = False
                        i.DateTimeValue = dt
                    except RuntimeException:
                        pass

        except Exception:
            traceback.print_exc()

    def removeUserFieldByContent(self):
        #Remove userfield when its text is empty
        xDependentTextFields = TextFieldHandler.arrayTextFields
        for i in xDependentTextFields:
            try:
                if not i.TextFieldMaster.Content:
                    i.dispose()
            except Exception:
                #TextField doesn't even have the attribute Content,
                #so it's empty
                i.dispose()
