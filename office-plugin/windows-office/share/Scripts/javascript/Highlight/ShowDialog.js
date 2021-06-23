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
importClass(Packages.com.sun.star.uno.UnoRuntime);
importClass(Packages.com.sun.star.lang.XMultiComponentFactory);
importClass(Packages.com.sun.star.awt.XDialogProvider);
importClass(Packages.com.sun.star.awt.XDialog);
importClass(Packages.com.sun.star.uno.Exception);
importClass(Packages.com.sun.star.script.provider.XScriptContext);

importClass(java.lang.Thread);
importClass(java.lang.System);

function tryLoadingLibrary( xmcf, context, name )
{
    try
    {
        obj = xmcf.createInstanceWithContext(
               "com.sun.star.script.Application" + name + "LibraryContainer",
               context.getComponentContext());

        xLibraryContainer = UnoRuntime.queryInterface(XLibraryContainer, obj);

        System.err.println("Got XLibraryContainer");

        serviceObj = context.getComponentContext().getValueByName(
                    "/singletons/com.sun.star.util.theMacroExpander");

        xme = AnyConverter.toObject(new Type(XMacroExpander), serviceObj);

        bootstrapName = "bootstraprc";
        if (System.getProperty("os.name").startsWith("Windows"))
        {
            bootstrapName = "bootstrap.ini";
        }

        libURL = xme.expandMacros(
                "$BRAND_BASE_DIR/$BRAND_SHARE_SUBDIR/basic/ScriptBindingLibrary/" +
                    name.toLowerCase() + ".xlb/");

        System.err.println("libURL is: " + libURL);

        xLibraryContainer.createLibraryLink(
            "ScriptBindingLibrary", libURL, false);

        System.err.println("liblink created");

    }
    catch (e)
    {
        System.err.println("Got an exception loading lib: " + e.getMessage());
        return false;
    }
    return true;
}

function getDialogProvider()
{
    // UNO awt components of the Highlight dialog
    //get the XMultiServiceFactory
    xmcf = XSCRIPTCONTEXT.getComponentContext().getServiceManager();

    args = new Array;
    //get the XDocument from the context
    args[0] = XSCRIPTCONTEXT.getDocument();

    //try to create the DialogProvider
    try {
        obj = xmcf.createInstanceWithArgumentsAndContext(
            "com.sun.star.awt.DialogProvider", args,
            XSCRIPTCONTEXT.getComponentContext());
    }
    catch (e) {
        System.err.println("Error getting DialogProvider object");
        return null;
    }

    return UnoRuntime.queryInterface(XDialogProvider, obj);
}

//get the DialogProvider
xDialogProvider = getDialogProvider();

if (xDialogProvider != null)
{
    //try to create the Highlight dialog (found in the ScriptBinding library)
    try
    {
        findDialog = xDialogProvider.createDialog("vnd.sun.star.script:" +
            "ScriptBindingLibrary.Highlight?location=application");
        if( findDialog == null )
        {
            if (tryLoadingLibrary(xmcf, XSCRIPTCONTEXT, "Dialog") == false ||
                tryLoadingLibrary(xmcf, XSCRIPTCONTEXT, "Script") == false)
            {
                System.err.println("Error loading ScriptBindingLibrary");
            }
            else
            {
                // try to create the Highlight dialog (found in the
                // ScriptBindingLibrary)
                findDialog = xDialogProvider.createDialog("vnd.sun.star.script:" +
                    "ScriptBindingLibrary.Highlight?location=application");
            }
        }

        //launch the dialog
        if ( findDialog != null )
        {
            findDialog.execute();
        }
    }
    catch (e) {
        System.err.println("Got exception on first creating dialog: " +
            e.getMessage());
    }
}
