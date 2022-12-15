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

from .event.CommonListener import WindowListenerProcAdapter

'''
To change the template for this generated type comment go to
Window>Preferences>Java>Code Generation>Code and Comments
'''

class PeerConfig(object):

    def __init__(self, _oUnoDialog):
        self.oUnoDialog = _oUnoDialog
        self.oUnoDialog.xUnoDialog.addWindowListener(
            WindowListenerProcAdapter(self.windowShown))
        self.m_aPeerTasks = []
        self.aImageUrlTasks = []

    class PeerTask(object):

        def __init__(self, _xControl, _propNames, _propValues):
            self.propnames = _propNames
            self.propvalues = _propValues
            self.xControl = _xControl

    class ImageUrlTask(object):

        def __init__(self, _oModel, _oResource):
            self.oModel = _oModel
            self.oResource = _oResource

    def windowShown(self):
        try:
            for i in self.m_aPeerTasks:
                xVclWindowPeer = i.xControl.Peer
                xVclWindowPeer.setProperty(i.propnames, i.propvalues)

            for aImageUrlTask in self.aImageUrlTasks:
                sImageUrl = aImageUrlTask.oResource
                if sImageUrl != "":
                    aImageUrlTask.oModel.ImageURL = sImageUrl

        except Exception:
            traceback.print_exc()
