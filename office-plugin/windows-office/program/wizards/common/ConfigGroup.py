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
import inspect

class ConfigGroup(object):

    root = None

    def __init__(self):
        self.root = None

    def writeConfiguration(self, configurationView, param):
        for name,data in inspect.getmembers(self):
            if name.startswith(param):
                self.writeField( name, configurationView, param)

    def writeField(self, field, configView, prefix):
        propertyName = field[len(prefix):]
        child = getattr(self, field)
        if isinstance(child, ConfigGroup):
            child.writeConfiguration(configView.getByName(propertyName),
                prefix)
        else:
            setattr(configView,propertyName,getattr(self,field))

    def readConfiguration(self, configurationView, param):
        for name,data in inspect.getmembers(self):
            if name.startswith(param):
                self.readField( name, configurationView, param)

    def readField(self, field, configView, prefix):
        propertyName = field[len(prefix):]
        child = getattr(self, field)
        if isinstance(child, ConfigGroup):
            child.setRoot(self.root);
            child.readConfiguration(configView.getByName(propertyName),
                prefix)
        else:
            value = configView.getByName(propertyName)
            if value is not None:
                setattr(self,field, value)

    def setRoot(self, newRoot):
        self.root = newRoot
