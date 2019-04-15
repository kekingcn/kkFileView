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
    Session( "GIFID" ) = File_getDataVirtual( csFileCurrent, ".", ";" )( 0 )
%>

<HTML>

<HEAD>
</HEAD>

<FRAMESET ROWS="*,2" BORDER=0 FRAMEBORDER=0 FRAMESPACING=0>
	<FRAME SRC="./show.asp" NAME="frame1" SCROLLING=yes  RESIZE MARGINWIDTH=0 MARGINHEIGHT=0 FRAMEBORDER=0>
	<FRAME SRC="./poll.asp" NAME="frame2" SCROLLING=no NORESIZE MARGINWIDTH=0 MARGINHEIGHT=0 FRAMEBORDER=0>
</FRAMESET>

<NOFRAMES>

<BODY BGCOLOR="white">
    <META HTTP-EQUIV="-REFRESH" CONTENT="1;URL=./show.asp">
</BODY>

</HTML>
