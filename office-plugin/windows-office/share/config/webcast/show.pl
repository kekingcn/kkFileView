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

print "Content-type: text/html\n\n";

# get current and next picture
$sCurrPic = join( "", common::File_read( "currpic.txt" ) );
@aPictureArray = common::File_read( "picture.txt" );

# not last picture or wrong input ?
if( abs( $sCurrPic ) > 0 )
{
    $nCurrPic = abs( $sCurrPic );
    $nPictureArrayLen = @aPictureArray;
    if( $nCurrPic < $nPictureArrayLen )
    {
        $sPictureName1 = ( split( ";", @aPictureArray[ $nCurrPic ] ) )[ 1 ];
        $sPictureName2 = ( split( ";", @aPictureArray[ $nCurrPic + 1 ] ) )[ 1 ];
    }
    else
    {
        $sPictureName1 = ( split( ";", @aPictureArray[ $nCurrPic ] ) )[ 1 ];
        $sPictureName2 = $sPictureName1;
    }
}

print "<HTML>";

print "<HEAD>";
    print "<TITLE>$$1</TITLE>";
print "</HEAD>";

print "<BODY bgcolor=\"white\">";
    print "<P ALIGN=CENTER><IMG src=\"" . $sPictureName1 . "\" width=$$4 height=$$5 border=0>";
    print "<P><IMG src=\"" . $sPictureName2 . "\" width=1 height=1 border=0>";
print "</BODY>";

print "</HTML>";
