#!/usr/bin/env perl
#
# This file is part of the LibreOffice project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This file incorporates work covered by the following license notice:
#
#   Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements. See the NOTICE file distributed
#   with this work for additional information regarding copyright
#   ownership. The ASF licenses this file to you under the Apache
#   License, Version 2.0 (the "License"); you may not use this file
#   except in compliance with the License. You may obtain a copy of
#   the License at http://www.apache.org/licenses/LICENSE-2.0 .
#

require "common.pl";

%aRequestMap = common::HTTP_getRequest();

# get new picture
$sCurrPic = $aRequestMap{ "CurrPic" };

@aPictureArray = common::File_read( "picture.txt" );
$nPictureArrayLen = @aPictureArray;

# check if + or - was pressed
if( $aRequestMap{ "Auswahl" } eq "+" )
{
    $sCurrPic = abs( $sCurrPic ) + 1;
}

if( $aRequestMap{ "Auswahl" } eq "-" )
{
    $sCurrPic = abs( $sCurrPic ) - 1;
}

# save picture name
if( (abs( $sCurrPic ) > 0) && ( abs( $sCurrPic ) < ( $nPictureArrayLen ) ) )
{
    open( F_CURRPIC, ">currpic.txt");
    print F_CURRPIC abs( $sCurrPic );
    close( F_CURRPIC );
}

# return to edit page
print "Content-type: text/html\n\n";
print "<HTML>\n<HEAD>\n";
print "<META http-equiv=\"refresh\" CONTENT=\"0 ;URL=editpic.pl\">";
print "<title>savepic.pl</title>";
print "</HEAD>\n";
print "<BODY>\n";
print "</BODY>\n";
print "</HTML>\n";
%>
