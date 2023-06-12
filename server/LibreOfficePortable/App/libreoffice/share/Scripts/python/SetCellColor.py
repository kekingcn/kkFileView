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

def _SetCellColor(sheet, cellRange, color):
    """Sets the background of 'cellRange' in 'sheet', to 'color'."""
    # https://api.libreoffice.org/docs/idl/ref/interfacecom_1_1sun_1_1star_1_1table_1_1XCellRange.html#a92c77dc3025ac50d55bf31bc80ab118f
    cells = sheet.getCellRangeByName(cellRange)

    # https://api.libreoffice.org/docs/idl/ref/servicecom_1_1sun_1_1star_1_1table_1_1CellProperties.html
    cells.CellBackColor = color

def SetCellColor():
    ctx = uno.getComponentContext()
    smgr = ctx.ServiceManager
    desktop = smgr.createInstanceWithContext("com.sun.star.frame.Desktop", ctx)

    # Create a blank spreadsheet document, instead of operating on the existing one
    doc = desktop.loadComponentFromURL("private:factory/scalc", "_blank", 0, ())

    # Select the first sheet in the spreadsheet (0-index based).
    sheet = doc.Sheets[0]

    # Call the above helper function to set color (in hex number).
    # To get the hex number:
    #    1. go to Calc, click toolbar dropdown "Background Color" > Custom Color;
    #    2. Pick a color, copy the hex number and prefix it with "0x".
    _SetCellColor(sheet, "C3:C21",    0x4021c9)
    _SetCellColor(sheet, "D18:E21",   0x4021c9)
    _SetCellColor(sheet, "G3:G21",    0x4021c9)
    _SetCellColor(sheet, "H3:I5",     0x4021c9)
    _SetCellColor(sheet, "I6:I21",    0x4021c9)
    _SetCellColor(sheet, "H19:H21",   0x4021c9)

    # You should get a nice "LO" in the spreadsheet!

# Only the specified function will show in the Tools > Macro > Organize Macro dialog:
g_exportedScripts = (SetCellColor,)
