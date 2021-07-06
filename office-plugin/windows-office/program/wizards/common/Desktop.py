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

from com.sun.star.frame.FrameSearchFlag import ALL
from com.sun.star.util import URL
from com.sun.star.i18n.KParseTokens import ANY_LETTER_OR_NUMBER, ASC_UNDERSCORE

class Desktop(object):

    @classmethod
    def getDesktop(self, xMSF):
        xDesktop = None
        if xMSF is not None:
            try:
                xDesktop = xMSF.createInstance( "com.sun.star.frame.Desktop")
            except Exception:
                traceback.print_exc()
        else:
            print ("Can't create a desktop. null pointer !")
        return xDesktop

    @classmethod
    def getActiveFrame(self, xMSF):
        xDesktop = self.getDesktop(xMSF)
        return xDesktop.getActiveFrame()

    @classmethod
    def getDispatcher(self, xMSF, xFrame, _stargetframe, oURL):
        try:
            xDispatch = xFrame.queryDispatch(oURL, _stargetframe, ALL)
            return xDispatch
        except Exception:
            traceback.print_exc()

        return None

    @classmethod
    def connect(self, connectStr):
        localContext = uno.getComponentContext()
        resolver = localContext.ServiceManager.createInstanceWithContext(
                        "com.sun.star.bridge.UnoUrlResolver", localContext)
        ctx = resolver.resolve( connectStr )
        orb = ctx.ServiceManager
        return orb

    @classmethod
    def getIncrementSuffix(self, xElementContainer, sElementName):
        bElementexists = True
        i = 1
        sIncSuffix = ""
        BaseName = sElementName
        while bElementexists:
            try:
                bElementexists = xElementContainer.hasByName(sElementName)
            except:
                bElementexists = xElementContainer.hasByHierarchicalName(
                    sElementName)
            if bElementexists:
                i += 1
                sElementName = BaseName + str(i)

        if i > 1:
            sIncSuffix = str(i)

        return sIncSuffix

    '''
    Checks if the passed Element Name already exists in the  ElementContainer.
    If yes it appends a suffix to make it unique
    @param xElementContainer
    @param sElementName
    @return a unique Name ready to be added to the container.
    '''

    @classmethod
    def getUniqueName(self, xElementContainer, sElementName):
        sIncSuffix = self.getIncrementSuffix(xElementContainer, sElementName)
        return sElementName + sIncSuffix

