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
//this script acts as a handler for the buttons in the Highlight dialog
importClass(Packages.com.sun.star.uno.UnoRuntime);
importClass(Packages.com.sun.star.uno.Type);
importClass(Packages.com.sun.star.uno.AnyConverter);

importClass(Packages.com.sun.star.awt.XButton);
importClass(Packages.com.sun.star.awt.XControl);
importClass(Packages.com.sun.star.awt.ActionEvent);
importClass(Packages.com.sun.star.awt.XControlModel);
importClass(Packages.com.sun.star.awt.XControlContainer);
importClass(Packages.com.sun.star.awt.XDialog);
importClass(Packages.com.sun.star.awt.XTextComponent);

importClass(Packages.com.sun.star.util.XReplaceable);
importClass(Packages.com.sun.star.util.XReplaceDescriptor);
importClass(Packages.com.sun.star.util.XPropertyReplace);

importClass(Packages.com.sun.star.beans.XPropertySet);
importClass(Packages.com.sun.star.beans.PropertyValue);

// Scripting Framework DialogFactory class
importClass(Packages.com.sun.star.script.framework.browse.DialogFactory);

// Get the ActionEvent object from the ARGUMENTS list
event = ARGUMENTS[0];

// Each argument is of type Any so we must use the AnyConverter class to
// convert it into the interface or primitive type we expect
button = AnyConverter.toObject(new Type(XButton), event.Source);

// We can now query for the model of the button and get its properties
control = UnoRuntime.queryInterface(XControl, button);
cmodel = control.getModel();
pset = UnoRuntime.queryInterface(XPropertySet, cmodel);

if (pset.getPropertyValue("Label").equals("Exit"))
{
    // We can get the XDialog in which this control appears by calling
    // getContext() on the XControl interface
    xDialog = UnoRuntime.queryInterface(
        XDialog, control.getContext());

    // Close the dialog
    xDialog.endExecute();
}
else
{
    // We can get the list of controls for this dialog by calling
    // getContext() on the XControl interface of the button
    controls = UnoRuntime.queryInterface(
        XControlContainer, control.getContext());

    // Now get the text field control from the list
    textField =
        UnoRuntime.queryInterface(
            XTextComponent, controls.getControl("HighlightTextField"));

    searchKey = textField.getText();

    // highlight the text in red
    red = java.awt.Color.red.getRGB();

    replaceable =
        UnoRuntime.queryInterface(XReplaceable, XSCRIPTCONTEXT.getDocument());

    descriptor = replaceable.createReplaceDescriptor();

    // Gets a XPropertyReplace object for altering the properties
    // of the replaced text
    xPropertyReplace = UnoRuntime.queryInterface(XPropertyReplace, descriptor);

    // Sets the replaced text property fontweight value to Bold
    wv = new PropertyValue("CharWeight", -1,
        new java.lang.Float(Packages.com.sun.star.awt.FontWeight.BOLD),
            Packages.com.sun.star.beans.PropertyState.DIRECT_VALUE);

    // Sets the replaced text property color value to RGB parameter
    cv = new PropertyValue("CharColor", -1,
        new java.lang.Integer(red),
            Packages.com.sun.star.beans.PropertyState.DIRECT_VALUE);

    // Apply the properties
    props = new Array;
    props[0] = cv;
    props[1] = wv;

    try {
        xPropertyReplace.setReplaceAttributes(props);

        // Only matches whole words and case sensitive
        descriptor.setPropertyValue(
            "SearchCaseSensitive", new java.lang.Boolean(true));
        descriptor.setPropertyValue("SearchWords", new java.lang.Boolean(true));

        // Replaces all instances of searchKey with new Text properties
        // and gets the number of instances of the searchKey
        descriptor.setSearchString(searchKey);
        descriptor.setReplaceString(searchKey);
        replaceable.replaceAll(descriptor);
    }
    catch (e) {
        java.lang.System.err.println("Error setting up search properties"
            + e.getMessage());
    }
}
