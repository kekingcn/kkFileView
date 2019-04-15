<%
    Option Explicit
    Response.Expires = 0
    Response.Buffer = True
%>
<!--***********************************************************
 * 
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 * 
 ***********************************************************-->

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
