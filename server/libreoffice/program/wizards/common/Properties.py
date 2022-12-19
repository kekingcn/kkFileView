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
from com.sun.star.beans import PropertyValue

'''
Simplifies handling Arrays of PropertyValue.
To make a use of this class, instantiate it, and call
the put(propName,propValue) method.
caution: propName should always be a String.
When finished, call the getProperties() method to get an array of the set properties.
'''

class Properties(dict):

    @classmethod
    def getPropertyValue(self, props, propName):
        for i in props:
            if propName == i.Name:
                return i.Value

        raise AttributeError ("Property '" + propName + "' not found.")

    @classmethod
    def hasPropertyValue(self, props, propName):
        for i in props:
            if propName == i.Name:
                return True
        return False

    @classmethod
    def getProperties(self, _map):
        pv = []
        for k,v in _map.items():
            pv.append(self.createProperty(k, v))
        return pv

    @classmethod
    def createProperty(self, name, value, handle=None):
        pv = PropertyValue()
        pv.Name = name
        pv.Value = value
        if handle is not None:
            pv.Handle = handle
        return pv

    def getProperties1(self):
        return self.getProperties(self)
