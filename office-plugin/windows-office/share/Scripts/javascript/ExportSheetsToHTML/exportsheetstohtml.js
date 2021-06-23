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
// When this script is run on an existing, saved, spreadsheet,
// eg. /home/testuser/myspreadsheet.sxc, the script will export
// each sheet to a separate html file,
// eg. /home/testuser/myspreadsheet_sheet1.html,
// /home/testuser/myspreadsheet_sheet2.html etc
importClass(Packages.com.sun.star.uno.UnoRuntime);
importClass(Packages.com.sun.star.sheet.XSpreadsheetDocument);
importClass(Packages.com.sun.star.container.XIndexAccess);
importClass(Packages.com.sun.star.beans.XPropertySet);
importClass(Packages.com.sun.star.beans.PropertyValue);
importClass(Packages.com.sun.star.util.XModifiable);
importClass(Packages.com.sun.star.frame.XStorable);
importClass(Packages.com.sun.star.frame.XModel);
importClass(Packages.com.sun.star.uno.AnyConverter);
importClass(Packages.com.sun.star.uno.Type);

importClass(java.lang.System);

//get the document object from the scripting context
oDoc = XSCRIPTCONTEXT.getDocument();
//get the XSpreadsheetDocument interface from the document
xSDoc = UnoRuntime.queryInterface(XSpreadsheetDocument, oDoc);
//get the XModel interface from the document
xModel = UnoRuntime.queryInterface(XModel,oDoc);
//get the XIndexAccess interface used to access each sheet
xSheetsIndexAccess = UnoRuntime.queryInterface(XIndexAccess, xSDoc.getSheets());
//get the XStorable interface used to save the document
xStorable = UnoRuntime.queryInterface(XStorable,xSDoc);
//get the XModifiable interface used to indicate if the document has been
//changed
xModifiable = UnoRuntime.queryInterface(XModifiable,xSDoc);

//set up an array of PropertyValue objects used to save each sheet in the
//document
storeProps = new Array;//PropertyValue[1];
storeProps[0] = new PropertyValue();
storeProps[0].Name = "FilterName";
storeProps[0].Value = "HTML (StarCalc)";
storeUrl = xModel.getURL();
storeUrl = storeUrl.substring(0,storeUrl.lastIndexOf('.'));

//set only one sheet visible, and store to HTML doc
for(var i=0;i<xSheetsIndexAccess.getCount();i++)
{
	setAllButOneHidden(xSheetsIndexAccess,i);
	xModifiable.setModified(false);
	xStorable.storeToURL(storeUrl+"_sheet"+(i+1)+".html", storeProps);
}

// now set all visible again
for(var i=0;i<xSheetsIndexAccess.getCount();i++)
{
	xPropSet = AnyConverter.toObject( new Type(XPropertySet), xSheetsIndexAccess.getByIndex(i));
	xPropSet.setPropertyValue("IsVisible", true);
}

function setAllButOneHidden(xSheetsIndexAccess,vis) {
	//System.err.println("count="+xSheetsIndexAccess.getCount());
    //get an XPropertySet interface for the vis-th sheet
	xPropSet = AnyConverter.toObject( new Type(XPropertySet), xSheetsIndexAccess.getByIndex(vis));
    //set the vis-th sheet to be visible
	xPropSet.setPropertyValue("IsVisible", true);
    // set all other sheets to be invisible
	for(var i=0;i<xSheetsIndexAccess.getCount();i++)
	{
		xPropSet = AnyConverter.toObject( new Type(XPropertySet), xSheetsIndexAccess.getByIndex(i));
		if(i!=vis) {
			xPropSet.setPropertyValue("IsVisible", false);
		}
	}
}
