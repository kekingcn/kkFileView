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
    ' get new picture
    Dim sCurrPic,aPictureArray, nUpper, nCurrPic

    aPictureArray = File_getDataVirtual( csFilePicture, ".", ";" )
    nUpper = CInt( (UBound(aPictureArray) - 1 ) / 2)

    sCurrPic = Request( "CurrPic" )

    ' check if + or - was pressed
    select case Request( "Auswahl" )
        case "+"
            if isNumeric( sCurrPic ) then
                sCurrPic = CStr( CLng( sCurrPic ) + 1 )
            end if
        case "-"
            if isNumeric( sCurrPic ) then
                sCurrPic = CStr( CLng( sCurrPic ) - 1 )
            end if
    end select

    ' save picture name
	if isNumeric( sCurrPic ) then
		if (CInt( sCurrPic ) > 0) and ( CInt( sCurrPic ) <= nUpper ) then
			call File_writeVirtual( "currpic.txt", ".", sCurrPic )
		end if
	end if

    ' return to edit page
    Response.Redirect( "./editpic.asp" )
%>
