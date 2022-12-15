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

import com.sun.star.uno.UnoRuntime;
import com.sun.star.script.provider.XScriptContext;
import com.sun.star.lang.XMultiComponentFactory;
import com.sun.star.lang.EventObject;
import com.sun.star.uno.Type;
import com.sun.star.uno.AnyConverter;
import com.sun.star.text.XTextDocument;
import com.sun.star.beans.PropertyValue;
import com.sun.star.script.XLibraryContainer;
import com.sun.star.awt.*;
import com.sun.star.util.*;

import java.awt.Color;

public class HighlightText implements com.sun.star.awt.XActionListener {

    // UNO awt components of the Highlight dialog
    XDialog findDialog = null;
    XTextComponent findTextBox;

    // The document being searched
    XTextDocument theDocument;

    // The text to be searched for
    private String searchKey = "";

    public void showForm(XScriptContext context) {
        System.err.println("Starting showForm");

        XMultiComponentFactory xmcf =
            context.getComponentContext().getServiceManager();

        Object[] args = new Object[1];
        args[0] = context.getDocument();

        Object obj;

        try {
            obj = xmcf.createInstanceWithArgumentsAndContext(
                      "com.sun.star.awt.DialogProvider", args,
                      context.getComponentContext());
        } catch (com.sun.star.uno.Exception e) {
            System.err.println("Error getting DialogProvider object");
            return;
        }

        XDialogProvider xDialogProvider = (XDialogProvider)
                                          UnoRuntime.queryInterface(XDialogProvider.class, obj);

        System.err.println("Got DialogProvider, now get dialog");

        try {
            findDialog = xDialogProvider.createDialog(
                             "vnd.sun.star.script:" +
                             "ScriptBindingLibrary.Highlight?location=application");
        } catch (java.lang.Exception e) {
            System.err.println("Got exception on first creating dialog: " +
                               e.getMessage());
        }

        if (findDialog == null) {
            if (!tryLoadingLibrary(xmcf, context, "Dialog") ||
                !tryLoadingLibrary(xmcf, context, "Script")) {
                System.err.println("Error loading ScriptBindingLibrary");
                return;
            }

            try {
                findDialog = xDialogProvider.createDialog(
                                 "vnd.sun.star.script://" +
                                 "ScriptBindingLibrary.Highlight?location=application");
            } catch (com.sun.star.lang.IllegalArgumentException iae) {
                System.err.println("Error loading ScriptBindingLibrary");
                return;
            }
        }

        XControlContainer controls = (XControlContainer)
                                     UnoRuntime.queryInterface(XControlContainer.class, findDialog);

        XButton highlightButton = (XButton) UnoRuntime.queryInterface(
                                      XButton.class, controls.getControl("HighlightButton"));
        highlightButton.setActionCommand("Highlight");

        findTextBox = (XTextComponent) UnoRuntime.queryInterface(
                          XTextComponent.class, controls.getControl("HighlightTextField"));

        XButton exitButton = (XButton) UnoRuntime.queryInterface(
                                 XButton.class, controls.getControl("ExitButton"));
        exitButton.setActionCommand("Exit");

        theDocument = (XTextDocument) UnoRuntime.queryInterface(
                          XTextDocument.class, context.getDocument());

        highlightButton.addActionListener(this);
        exitButton.addActionListener(this);

        findDialog.execute();
    }

    public void actionPerformed(ActionEvent e) {
        if (e.ActionCommand.equals("Exit")) {
            findDialog.endExecute();
            return;
        } else if (e.ActionCommand.equals("Highlight")) {
            searchKey = findTextBox.getText();

            // highlight the text in red
            Color cRed = new Color(255, 0, 0);
            int red = cRed.getRGB();

            XReplaceable replaceable = (XReplaceable)
                                       UnoRuntime.queryInterface(XReplaceable.class, theDocument);

            XReplaceDescriptor descriptor =
                (XReplaceDescriptor) replaceable.createReplaceDescriptor();

            // Gets a XPropertyReplace object for altering the properties
            // of the replaced text
            XPropertyReplace xPropertyReplace = (XPropertyReplace)
                                                UnoRuntime.queryInterface(XPropertyReplace.class, descriptor);

            // Sets the replaced text property fontweight value to Bold
            PropertyValue wv = new PropertyValue("CharWeight", -1,
                                                 new Float(com.sun.star.awt.FontWeight.BOLD),
                                                 com.sun.star.beans.PropertyState.DIRECT_VALUE);

            // Sets the replaced text property color value to RGB parameter
            PropertyValue cv = new PropertyValue("CharColor", -1,
                                                 Integer.valueOf(red),
                                                 com.sun.star.beans.PropertyState.DIRECT_VALUE);

            // Apply the properties
            PropertyValue[] props = new PropertyValue[] { cv, wv };

            try {
                xPropertyReplace.setReplaceAttributes(props);

                // Only matches whole words and case sensitive
                descriptor.setPropertyValue(
                    "SearchCaseSensitive", Boolean.TRUE);
                descriptor.setPropertyValue("SearchWords", Boolean.TRUE);
            } catch (com.sun.star.beans.UnknownPropertyException upe) {
                System.err.println("Error setting up search properties");
                return;
            } catch (com.sun.star.beans.PropertyVetoException pve) {
                System.err.println("Error setting up search properties");
                return;
            } catch (com.sun.star.lang.WrappedTargetException wte) {
                System.err.println("Error setting up search properties");
                return;
            } catch (com.sun.star.lang.IllegalArgumentException iae) {
                System.err.println("Error setting up search properties");
                return;
            }

            // Replaces all instances of searchKey with new Text properties
            // and gets the number of instances of the searchKey
            descriptor.setSearchString(searchKey);
            descriptor.setReplaceString(searchKey);
            replaceable.replaceAll(descriptor);
        }
    }

    public void disposing(EventObject o) {
        // do nothing
    }

    private boolean tryLoadingLibrary(
        XMultiComponentFactory xmcf, XScriptContext context, String name) {
        System.err.println("Try to load ScriptBindingLibrary");

        try {
            Object obj = xmcf.createInstanceWithContext(
                             "com.sun.star.script.Application" + name + "LibraryContainer",
                             context.getComponentContext());

            XLibraryContainer xLibraryContainer = (XLibraryContainer)
                                                  UnoRuntime.queryInterface(XLibraryContainer.class, obj);

            System.err.println("Got XLibraryContainer");

            Object serviceObj = context.getComponentContext().getValueByName(
                                    "/singletons/com.sun.star.util.theMacroExpander");

            XMacroExpander xme = (XMacroExpander) AnyConverter.toObject(
                                     new Type(XMacroExpander.class), serviceObj);

            String bootstrapName = "bootstraprc";

            if (System.getProperty("os.name").startsWith("Windows")) {
                bootstrapName = "bootstrap.ini";
            }

            String libURL = xme.expandMacros(
                                "$BRAND_BASE_DIR/$BRAND_SHARE_SUBDIR/basic/ScriptBindingLibrary/" +
                                name.toLowerCase() + ".xlb/");

            System.err.println("libURL is: " + libURL);

            xLibraryContainer.createLibraryLink(
                "ScriptBindingLibrary", libURL, false);

            System.err.println("liblink created");

        } catch (com.sun.star.uno.Exception e) {
            System.err.println("Got an exception loading lib: " + e.getMessage());
            return false;
        }

        return true;
    }
}
