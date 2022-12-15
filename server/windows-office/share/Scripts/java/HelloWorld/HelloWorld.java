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

import com.sun.star.script.provider.XScriptContext;
import com.sun.star.uno.UnoRuntime;
import com.sun.star.text.XTextDocument;
import com.sun.star.text.XTextRange;
import com.sun.star.text.XText;
/**
 *  HelloWorld class
 *
 */
public class HelloWorld {
    public static void printHW(XScriptContext xSc) {

        // getting the text document object
        XTextDocument xtextdocument = (XTextDocument) UnoRuntime.queryInterface(
                                          XTextDocument.class, xSc.getDocument());
        XText xText = xtextdocument.getText();
        XTextRange xTextRange = xText.getEnd();
        xTextRange.setString("Hello World (in Java)");

    }// printHW

}
