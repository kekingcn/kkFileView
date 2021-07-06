/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * This file incorporates work covered by the following license notice:
 *
 *   Licensed to the Apache Software Foundation (ASF) under one or more
 *   contributor license agreements. See the NOTICE file distributed
 *   with this work for additional information regarding copyright
 *   ownership. The ASF licenses this file to you under the Apache
 *   License, Version 2.0 (the "License"); you may not use this file
 *   except in compliance with the License. You may obtain a copy of
 *   the License at http://www.apache.org/licenses/LICENSE-2.0 .
 */

package org.libreoffice.example.java_scripts;

import java.util.Random;
import java.util.Date;
import com.sun.star.uno.UnoRuntime;
import com.sun.star.uno.AnyConverter;
import com.sun.star.uno.Type;
import com.sun.star.uno.XInterface;
import com.sun.star.lang.XComponent;
import com.sun.star.lang.XMultiServiceFactory;
import com.sun.star.frame.XComponentLoader;
import com.sun.star.document.XEmbeddedObjectSupplier;
import com.sun.star.awt.Rectangle;
import com.sun.star.beans.XPropertySet;
import com.sun.star.beans.PropertyValue;

import com.sun.star.container.*;
import com.sun.star.chart.*;
import com.sun.star.table.*;
import com.sun.star.sheet.*;

import com.sun.star.script.provider.XScriptContext;

public class MemoryUsage {
    public void updateMemoryUsage(XScriptContext ctxt)
    throws Exception {
        XSpreadsheet sheet = createSpreadsheet(ctxt);

        Runtime runtime = Runtime.getRuntime();
        Random generator = new Random();
        Date date = new Date();

        // allocate a random amount of memory
        int len = (int)(generator.nextFloat() * runtime.freeMemory() / 5);
        byte[] bytes = new byte[len];

        addData(sheet, date.toString(),
                runtime.totalMemory(), runtime.freeMemory());

        addChart(sheet);
    }

    private XSpreadsheet createSpreadsheet(XScriptContext ctxt)
    throws Exception {
        XComponentLoader loader = (XComponentLoader)
                                  UnoRuntime.queryInterface(
                                      XComponentLoader.class, ctxt.getDesktop());

        XComponent comp = loader.loadComponentFromURL(
                              "private:factory/scalc", "_blank", 4, new PropertyValue[0]);

        XSpreadsheetDocument doc = (XSpreadsheetDocument)
                                   UnoRuntime.queryInterface(XSpreadsheetDocument.class, comp);

        XIndexAccess index = (XIndexAccess)
                             UnoRuntime.queryInterface(XIndexAccess.class, doc.getSheets());

        XSpreadsheet sheet = (XSpreadsheet) AnyConverter.toObject(
                                 new Type(com.sun.star.sheet.XSpreadsheet.class), index.getByIndex(0));

        return sheet;
    }

    private void addData(
        XSpreadsheet sheet, String date, long total, long free)
    throws Exception {
        sheet.getCellByPosition(0, 0).setFormula("Used");
        sheet.getCellByPosition(0, 1).setFormula("Free");
        sheet.getCellByPosition(0, 2).setFormula("Total");

        sheet.getCellByPosition(1, 0).setValue(total - free);
        sheet.getCellByPosition(1, 1).setValue(free);
        sheet.getCellByPosition(1, 2).setValue(total);
    }

    private void addChart(XSpreadsheet sheet)
    throws Exception {
        Rectangle rect = new Rectangle();
        rect.X = 500;
        rect.Y = 3000;
        rect.Width = 10000;
        rect.Height = 8000;

        XCellRange range = (XCellRange)
                           UnoRuntime.queryInterface(XCellRange.class, sheet);

        XCellRange myRange =
            range.getCellRangeByName("A1:B2");

        XCellRangeAddressable rangeAddr = (XCellRangeAddressable)
                                          UnoRuntime.queryInterface(XCellRangeAddressable.class, myRange);

        CellRangeAddress myAddr = rangeAddr.getRangeAddress();

        CellRangeAddress[] addr = new CellRangeAddress[1];
        addr[0] = myAddr;

        XTableChartsSupplier supp = (XTableChartsSupplier)
                                    UnoRuntime.queryInterface(XTableChartsSupplier.class, sheet);

        XTableCharts charts = supp.getCharts();
        charts.addNewByName("Example", rect, addr, false, true);

        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) { }

        // get the diagram and Change some of the properties
        XNameAccess chartsAccess = (XNameAccess)
                                   UnoRuntime.queryInterface(XNameAccess.class, charts);

        XTableChart tchart = (XTableChart)
                             UnoRuntime.queryInterface(
                                 XTableChart.class, chartsAccess.getByName("Example"));

        XEmbeddedObjectSupplier eos = (XEmbeddedObjectSupplier)
                                      UnoRuntime.queryInterface(XEmbeddedObjectSupplier.class, tchart);

        XInterface xifc = eos.getEmbeddedObject();

        XChartDocument xChart = (XChartDocument)
                                UnoRuntime.queryInterface(XChartDocument.class, xifc);

        XMultiServiceFactory xDocMSF = (XMultiServiceFactory)
                                       UnoRuntime.queryInterface(XMultiServiceFactory.class, xChart);

        Object diagObject =
            xDocMSF.createInstance("com.sun.star.chart.PieDiagram");

        XDiagram xDiagram = (XDiagram)
                            UnoRuntime.queryInterface(XDiagram.class, diagObject);

        xChart.setDiagram(xDiagram);

        XPropertySet propset = (XPropertySet)
                               UnoRuntime.queryInterface(XPropertySet.class, xChart.getTitle());
        propset.setPropertyValue("String", "JVM Memory Usage");
    }
}
