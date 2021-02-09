<%
    Option Explicit
    Response.Expires = 0
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
