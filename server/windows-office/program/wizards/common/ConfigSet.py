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
from .ConfigGroup import ConfigGroup

class ConfigSet(ConfigGroup):
    '''
    After reading the configuration set items,
    the ConfigSet checks this field.
    If it is true, it will remove any nulls from
    the vector.
    subclasses can change this field in the constructor
    to avoid this "deletion" of nulls.
    '''

    def __init__(self, childType):
        self.childType = childType
        self.childrenList = []
        self.childrenListLen = 0

    def writeConfiguration(self, configurationView, param):
        for i in range(self.childrenListLen):
            #remove previous configuration
            configurationView.removeByName(i)
        for index,item in enumerate(self.childrenList):
            try:
                childView = configurationView.createInstance()
                configurationView.insertByName(index, childView)
                if callable( self.childType ):
                    topic = self.childType()
                    topic.cp_Index = item[0].Value
                    topic.cp_Topic = item[1].Value
                    topic.cp_Responsible = item[2].Value
                    topic.cp_Time = item[3].Value
                    topic.writeConfiguration(childView, param)
            except Exception:
                traceback.print_exc()

    def readConfiguration(self, configurationView, param):
        #each iteration represents a Topic row
        names = configurationView.ElementNames
        if names:
            for i in names:
                try:
                    if callable( self.childType ):
                        topic = self.childType()
                        topic.readConfiguration(
                            configurationView.getByName(i), param)
                        self.childrenList.append(topic)
                except Exception:
                    traceback.print_exc()
        self.childrenListLen = len(self.childrenList)
