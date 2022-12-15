# Example python script for the scripting framework

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

def InsertText(text):
    """Inserts the argument string into the current document.
    If there is a selection, the selection is replaced by it.
    """

    # Get the doc from the scripting context which is made available to
    # all scripts.
    desktop = XSCRIPTCONTEXT.getDesktop()
    model = desktop.getCurrentComponent()

    # Check whether there's already an opened document.
    if not hasattr(model, "Text"):
        return

    # The context variable is of type XScriptContext and is available to
    # all BeanShell scripts executed by the Script Framework
    xModel = XSCRIPTCONTEXT.getDocument()

    # The writer controller impl supports the css.view.XSelectionSupplier
    # interface.
    xSelectionSupplier = xModel.getCurrentController()

    # See section 7.5.1 of developers' guide
    xIndexAccess = xSelectionSupplier.getSelection()
    count = xIndexAccess.getCount()

    if count >= 1:  # ie we have a selection
        i = 0

    while i < count:
        xTextRange = xIndexAccess.getByIndex(i)
        theString = xTextRange.getString()

        if not len(theString):
            # Nothing really selected, just insert.
            xText = xTextRange.getText()
            xWordCursor = xText.createTextCursorByRange(xTextRange)
            xWordCursor.setString(text)
            xSelectionSupplier.select(xWordCursor)
        else:
            # Replace the selection.
            xTextRange.setString(text)
            xSelectionSupplier.select(xTextRange)

        i += 1
