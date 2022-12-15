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
class NoValidPathException(Exception):

    def __init__(self, xMSF, _sText):
        super(NoValidPathException,self).__init__(_sText)
        # TODO: NEVER open a dialog in an exception
        from .SystemDialog import SystemDialog
        if xMSF:
            import sys, os

            # imp is deprecated since Python v.3.4
            if sys.version_info >= (3,3):
                from importlib.machinery import SourceFileLoader
                SourceFileLoader('strings', os.path.join(os.path.dirname(__file__), '../common/strings.hrc')).load_module()
            else:
                import imp
                imp.load_source('strings', os.path.join(os.path.dirname(__file__), '../common/strings.hrc'))

            import strings
            SystemDialog.showErrorBox(xMSF, strings.RID_COMMON_START_21) #OfficePathnotavailable

