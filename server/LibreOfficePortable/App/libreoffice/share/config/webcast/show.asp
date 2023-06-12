<%
    Option Explicit
    Response.Expires = 0
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
    Dim sGifName1, sGifName2, nGifID, aPictureArray

    nGifID      = Session( "GIFID" )

    ' get current and next picture
    aPictureArray = File_getDataVirtual( csFilePicture, ".", ";" )

    ' not last picture or wrong input ?
    If CInt( nGifID ) < UBound( aPictureArray ) / 2 Then
        sGifName1 = aPictureArray( ( nGifID - 1 ) * 2 + 1 )
        sGifName2 = aPictureArray( ( nGifID ) * 2 + 1 )
    Else
        nGifID = CInt( UBound( aPictureArray ) / 2 )
        sGifName1 = aPictureArray( ( nGifID - 1 ) * 2 + 1 )
        sGifName2 = sGifName1
    End If
%>

<HTML>

<HEAD>
    <TITLE>$$1</TITLE>
</HEAD>

<BODY bgcolor="white">
	<table width=100% height=99%>
	<tr valign=center><td align=center>
		<IMG src="<% = sGifName1 %>" width=$$4 height=$$5 border=0>
		<br><IMG src="<% = sGifName2 %>" width=1 height=1 border=0>
	</td></tr>
	</table>
</BODY>

</HTML>