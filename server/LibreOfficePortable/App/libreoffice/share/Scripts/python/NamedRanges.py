#
# This file is part of the LibreOffice project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
import uno
from com.sun.star.container import NoSuchElementException

def DefineNamedRange(doc, SheetName, rangeName, rangeReference):
    """Defines a new named range. If the named range exists in the document, then
    update the rangeReference.

    Example: DefineNamedRange(doc, "Sheet1", "test_range", '$A$1:$F$14').

    API Reference:
    https://api.libreoffice.org/docs/idl/ref/interfacecom_1_1sun_1_1star_1_1sheet_1_1XNamedRanges.html
    """
    aName = rangeName
    # make sure the sheet name starts with "$"
    sheetName = "$" + SheetName.replace("$", "")
    aContent = sheetName + "." + rangeReference

    try:
        # If the named range exists, then update it
        doc.NamedRanges.getByName(rangeName)
        update = True
    except NoSuchElementException:
        update = False

    if update:
        doc.NamedRanges.getByName(rangeName).setContent(aContent)
    else:
        aPosition = uno.createUnoStruct('com.sun.star.table.CellAddress')
        sheet = doc.Sheets.getByName(SheetName)
        # the index of the sheet in the doc, 0-based
        aPosition.Sheet = sheet.getRangeAddress().Sheet

        addressObj = sheet.getCellRangeByName(rangeReference)
        # (com.sun.star.table.CellRangeAddress){ Sheet = (short)0x0, StartColumn = (long)0x0, StartRow = (long)0x0, EndColumn = (long)0x5, EndRow = (long)0xd }
        address = addressObj.getRangeAddress()

        aPosition.Column = address.StartColumn
        aPosition.Row = address.StartRow

        doc.NamedRanges.addNewByName(aName, aContent, aPosition, 0)

    return None

def NamedRanges():
    """The main function to be shown on the user interface."""
    ctx = uno.getComponentContext()
    smgr = ctx.ServiceManager
    desktop = smgr.createInstanceWithContext("com.sun.star.frame.Desktop", ctx)

    # Create a blank spreadsheet document, instead of damaging the existing document.
    doc = desktop.loadComponentFromURL("private:factory/scalc", "_blank", 0, ())

    # Create a new sheet to store our output information
    doc.Sheets.insertNewByName("Information", 1)
    infoSheet = doc.Sheets.getByName("Information")

    # Set text in the information sheet
    infoSheet.getCellRangeByName("A1").String = "Operation"
    infoSheet.getCellRangeByName("B1").String = "Name of Cell Range"
    infoSheet.getCellRangeByName("C1").String = "Content of Named Cell Range"

    # Format the information header row
    infoHeaderRange = infoSheet.getCellRangeByName("A1:C1")
    # 2 = CENTER, see enum CellHoriJustify in https://api.libreoffice.org/docs/idl/ref/namespacecom_1_1sun_1_1star_1_1table.html
    infoHeaderRange.HoriJustify = 2
    infoHeaderRange.CellBackColor = 0xdee6ef

    # Defines the named range test_range1
    dataSheetName = "data"
    doc.Sheets[0].Name = dataSheetName
    DefineNamedRange(doc, dataSheetName, "test_range1", "$A$1:$F$14")

    # Displays the named range information
    test_range1 = doc.NamedRanges.getByName("test_range1")
    infoSheet.getCellRangeByName("A2").String = "Defined test_range1"
    infoSheet.getCellRangeByName("B2").String = test_range1.Name
    infoSheet.getCellRangeByName("C2").String = test_range1.Content

    # Revise the named ranges.
    DefineNamedRange(doc, dataSheetName, "test_range1", "$A$1:$A$10")
    infoSheet.getCellRangeByName("A3").String = "Revised test_range1"
    infoSheet.getCellRangeByName("B3").String = test_range1.Name
    infoSheet.getCellRangeByName("C3").String = test_range1.Content

    # Defines the named range test_range2
    DefineNamedRange(doc, dataSheetName, "test_range2", "$B$1:$B$10")
    test_range2 = doc.NamedRanges.getByName("test_range2")
    infoSheet.getCellRangeByName("A4").String = "Defined test_range2"
    infoSheet.getCellRangeByName("B4").String = test_range2.Name
    infoSheet.getCellRangeByName("C4").String = test_range2.Content

    # Set data to test_range1 and test_range2

    dataSheet = doc.Sheets.getByName(dataSheetName)
    # You should use a tuple for setDataArray. For range e.g. A1:E1 it should
    # be in the form tuple((1,2,3,4,5)), and for range e.g. A1:A5 it should be
    # in the form tuple((1,), (2,), (3,), (4,), (5,)).
    data1 = tuple(((1,),(2,),(3,),(4,),(5,),(6,),(7,),(8,),(9,),(10,)))
    dataSheet.getCellRangeByName(test_range1.Content).setDataArray(data1)
    infoSheet.getCellRangeByName("A5").String = "Set value to test_range1"

    data2 = tuple(((2,),(4,),(6,),(8,),(10,),(12,),(14,),(16,),(18,),(20,)))
    dataSheet.getCellRangeByName(test_range2.Content).setDataArray(data2)
    infoSheet.getCellRangeByName("A6").String = "Set value to test_range2"

    # Calculate sum of test_range1
    infoSheet.getCellRangeByName("A8").String = "Sum of test_range1:"
    infoSheet.getCellRangeByName("B8").Formula = "=SUM(test_range1)"

    # Calculate sum of test_range2
    infoSheet.getCellRangeByName("A9").String = "Sum of test_range2:"
    infoSheet.getCellRangeByName("B9").Formula = "=SUM(test_range2)"

    # Calculate the difference between the two ranges
    infoSheet.getCellRangeByName("A10").String = "sum(test_range2) - sum(test_range1):"
    infoSheet.getCellRangeByName("B10").Formula = "=B9-B8"

    # Format the sum header columns
    infoSheet.getCellRangeByName("A8:A10").CellBackColor = 0xdee6ef

    # Set column width
    infoSheet.Columns.getByName("A").Width = 5590
    infoSheet.Columns.getByName("B").Width = 4610
    infoSheet.Columns.getByName("C").Width = 4610

g_exportedScripts = (NamedRanges,)
# vim: set shiftwidth=4 softtabstop=4 expandtab:
