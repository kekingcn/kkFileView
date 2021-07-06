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
import unohelper
import traceback

from .LetterWizardDialogImpl import LetterWizardDialogImpl, Desktop

from com.sun.star.lang import XServiceInfo
from com.sun.star.task import XJobExecutor

# pythonloader looks for a static g_ImplementationHelper variable
g_ImplementationHelper = unohelper.ImplementationHelper()
g_implName = "com.sun.star.wizards.letter.CallWizard"

# implement a UNO component by deriving from the standard unohelper.Base class
# and from the interface(s) you want to implement.
class CallWizard(unohelper.Base, XJobExecutor, XServiceInfo):
    def __init__(self, ctx):
        # store the component context for later use
        self.ctx = ctx

    def trigger(self, args):
        try:
            lw = LetterWizardDialogImpl(self.ctx.ServiceManager)
            lw.startWizard(self.ctx.ServiceManager)
        except Exception as e:
            print ("Wizard failure exception " + str(type(e)) +
                   " message " + str(e) + " args " + str(e.args) +
                   traceback.format_exc())

    @classmethod
    def callRemote(self):
        #Call the wizard remotely(see README)
        try:
            ConnectStr = \
                "uno:socket,host=localhost,port=2002;urp;StarOffice.ComponentContext"
            xLocMSF = Desktop.connect(ConnectStr)
            lw = LetterWizardDialogImpl(xLocMSF)
            lw.startWizard(xLocMSF)
        except Exception as e:
            print ("Wizard failure exception " + str(type(e)) +
                   " message " + str(e) + " args " + str(e.args) +
                   traceback.format_exc())

    def getImplementationName(self):
        return g_implName

    def supportsService(self, ServiceName):
        return g_ImplementationHelper.supportsService(g_implName, ServiceName)

    def getSupportedServiceNames(self):
        return g_ImplementationHelper.getSupportedServiceNames(g_implName)

g_ImplementationHelper.addImplementation( \
    CallWizard,                               # UNO object class
    g_implName,                               # implementation name
    ("com.sun.star.task.Job",),)              # list of implemented services
                                              # (the only service)

# vim:set shiftwidth=4 softtabstop=4 expandtab:
