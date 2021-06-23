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

def getNewString(theString):
    """helper function
    """
    if (not theString):
        return ""

    # should we tokenize on "."?
    if len(theString) >= 2 and theString[:2].isupper():
        # first two chars are UC => first UC, rest LC
        newString = theString[0].upper() + theString[1:].lower()

    elif theString[0].isupper():
        # first char UC => all to LC
        newString = theString.lower()

    else:
        # all to UC.
        newString = theString.upper()

    return newString


def capitalisePython():
    """Change the case of the selected or current word(s).
    If at least the first two characters are "UPpercase, then it is changed
    to first char "Uppercase".
    If the first character is "Uppercase", then it is changed to
    all "lowercase".
    Otherwise, all are changed to "UPPERCASE".
    """
    # The context variable is of type XScriptContext and is available to
    # all BeanShell scripts executed by the Script Framework
    xModel = XSCRIPTCONTEXT.getDocument()

    # the writer controller impl supports the css.view.XSelectionSupplier
    # interface
    xSelectionSupplier = xModel.getCurrentController()

    # see section 7.5.1 of developers' guide
    xIndexAccess = xSelectionSupplier.getSelection()
    count = xIndexAccess.getCount()

    if(count >= 1):  # ie we have a selection
        i = 0

    while i < count:
        xTextRange = xIndexAccess.getByIndex(i)
        theString = xTextRange.getString()
        # print("theString")
        if len(theString) == 0:
            # sadly we can have a selection where nothing is selected
            # in this case we get the XWordCursor and make a selection!
            xText = xTextRange.getText()
            xWordCursor = xText.createTextCursorByRange(xTextRange)

            if not xWordCursor.isStartOfWord():
                xWordCursor.gotoStartOfWord(False)

            xWordCursor.gotoNextWord(True)
            theString = xWordCursor.getString()
            newString = getNewString(theString)

            if newString:
                xWordCursor.setString(newString)
                xSelectionSupplier.select(xWordCursor)
        else:
            newString = getNewString(theString)
            if newString:
                xTextRange.setString(newString)
                xSelectionSupplier.select(xTextRange)
        i += 1


# lists the scripts, that shall be visible inside OOo. Can be omitted, if
# all functions shall be visible, however here getNewString shall be suppressed
g_exportedScripts = capitalisePython,

# vim: set shiftwidth=4 softtabstop=4 expandtab:
