# HelloWorld python script for the scripting framework

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

def HelloWorldPython():
    """Prints the string 'Hello World (in Python)' into the current document.
    """

    # Get the doc from the scripting context which is made available to all
    # scripts.
    desktop = XSCRIPTCONTEXT.getDesktop()
    model = desktop.getCurrentComponent()

    # Check whether there's already an opened document.
    # Otherwise, create a new one
    if not hasattr(model, "Text"):
        model = desktop.loadComponentFromURL(
            "private:factory/swriter", "_blank", 0, ())

    # get the XText interface
    text = model.Text

    # create an XTextRange at the end of the document
    tRange = text.End

    # and set the string
    tRange.String = "Hello World (in Python)"

    return None

# vim: set shiftwidth=4 softtabstop=4 expandtab:
