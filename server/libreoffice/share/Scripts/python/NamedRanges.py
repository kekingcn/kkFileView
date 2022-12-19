# -*- tab-width: 4; indent-tabs-mode: nil; py-indent-offset: 4 -*-
#
# This file is part of the LibreOffice project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

import traceback
import uno


def GetNamedRanges():
    """Returns a list of the named ranges in the document.
    """
    try:
        desktop = XSCRIPTCONTEXT.getDesktop()
        model = desktop.getCurrentComponent()
        rangeNames = model.NamedRanges.ElementNames
        result = []
        for i in rangeNames:
            range = model.NamedRanges.getByName(i).Content
            result.append((i, range))
        return result
    except Exception as e:
        print("Caught Exception: " + str(e))
        tb = e.__traceback__
        traceback.print_tb(tb)
        return None


def DefineNamedRange(sheet, x0, y0, width, height, name):
    """Defines a new (or replaces an existing) named range on a sheet,
    using zero-based absolute coordinates
    """
    desktop = XSCRIPTCONTEXT.getDesktop()
    model = desktop.getCurrentComponent()
    # FIXME: Is there some Python-callable API to turn a row and column into an A1 string?
    # This obviously works only for the first 26 columns.
    abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    content = "$" + sheet + "." + "$" + \
        abc[x0: x0+1] + "$" + str(y0+1) + ":" + "$" + abc[x0+width -
                                                          1: x0+width] + "$" + str(y0+height)
    position = uno.createUnoStruct('com.sun.star.table.CellAddress')
    position.Sheet = 0
    position.Column = 0
    position.Row = 0
    model.NamedRanges.addNewByName(name, content, position, 0)
    return None


def DeleteNamedRange(name):
    try:
        desktop = XSCRIPTCONTEXT.getDesktop()
        model = desktop.getCurrentComponent()
        model.NamedRanges.removeByName(name)
    except Exception as e:
        print("Caught Exception: " + str(e))
        tb = e.__traceback__
        traceback.print_tb(tb)
    return None

# vim: set shiftwidth=4 softtabstop=4 expandtab:
