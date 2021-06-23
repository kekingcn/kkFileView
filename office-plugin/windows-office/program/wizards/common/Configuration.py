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
import traceback

class Configuration(object):
    '''This class gives access to the OO configuration api.'''

    @classmethod
    def getConfigurationRoot(self, xmsf, sPath, updateable):
        oConfigProvider = xmsf.createInstance(
            "com.sun.star.configuration.ConfigurationProvider")
        args = []

        aPathArgument = uno.createUnoStruct(
            'com.sun.star.beans.PropertyValue')
        aPathArgument.Name = "nodepath"
        aPathArgument.Value = sPath

        args.append(aPathArgument)

        if updateable:
            sView = "com.sun.star.configuration.ConfigurationUpdateAccess"
        else:
            sView = "com.sun.star.configuration.ConfigurationAccess"

        return oConfigProvider.createInstanceWithArguments(sView, tuple(args))

    @classmethod
    def getProductName(self, xMSF):
        try:
            oProdNameAccess = self.getConfigurationRoot(xMSF, "org.openoffice.Setup/Product", False);
            return oProdNameAccess.getByName("ooName")
        except Exception:
            traceback.print_exc()
            return "Unknown"

    @classmethod
    def getNode(self, name, parent):
        return parent.getByName(name)

    @classmethod
    def commit(self, configView):
        configView.commitChanges()

    @classmethod
    def getInt(self, name, parent):
        o = getNode(name, parent)
        if (com.sun.star.uno.AnyConverter.isVoid(o)):
            return 0
        return com.sun.star.uno.AnyConverter.toInt(o)

    @classmethod
    def set(self, value, name, parent):
        parent.setHierarchicalPropertyValue(name, value)
