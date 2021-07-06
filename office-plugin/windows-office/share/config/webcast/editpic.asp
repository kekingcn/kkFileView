<%
    Option Explicit
    Response.Expires = 0
    Response.Buffer = True
%>
<!--
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
-->

<!-- #include file = "common.inc" -->


<%
    Dim aPictureArray, nPic, nUpper

    aPictureArray = File_getDataVirtual( csFilePicture, ".", ";" )
    nPic = File_readVirtual( "currpic.txt", "." )
	nUpper = CInt( (UBound(aPictureArray) - 1 ) / 2)
%>

<HTML>
<HEAD>
</HEAD>
<BODY>
    <FORM action="savepic.asp" method=get>
        <%
			if isNumeric(nPic) then
				if  (CInt( nPic ) >= CInt( (UBound(aPictureArray ) - 1 ) / 2 )) then
					nPic = nUpper
				end if
			else
				nPic = nUpper
			end if


            if CInt( nPic ) > 1 then
            %>
                <INPUT type=submit name="Auswahl" value="-"></INPUT>
            <%
            else
            %>
                <INPUT type=button value=" "></INPUT>
            <%
            end if
            %>
            <INPUT type=text name="CurrPic" value="<% = nPic %>" SIZE=3></INPUT>
            <%
            if CInt( nPic ) < CInt( nUpper ) then
            %>
                <INPUT type=submit name="Auswahl" value="+"></INPUT>
            <%
            else
            %>
                <INPUT type=button value=" "></INPUT>
            <%
            end if
        %>
        <INPUT type=submit name="Auswahl" value="$$2"></INPUT>
    </FORM>
</BODY>
</HTML>
