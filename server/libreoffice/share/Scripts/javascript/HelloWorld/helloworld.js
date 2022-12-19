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
// Hello World in JavaScript
importClass(Packages.com.sun.star.uno.UnoRuntime);
importClass(Packages.com.sun.star.text.XTextDocument);
importClass(Packages.com.sun.star.text.XText);
importClass(Packages.com.sun.star.text.XTextRange);

//get the document from the scripting context
oDoc = XSCRIPTCONTEXT.getDocument();
//get the XTextDocument interface
xTextDoc = UnoRuntime.queryInterface(XTextDocument,oDoc);
//get the XText interface
xText = xTextDoc.getText();
//get an (empty) XTextRange interface at the end of the text
xTextRange = xText.getEnd();
//set the text in the XTextRange
xTextRange.setString( "Hello World (in JavaScript)" );
