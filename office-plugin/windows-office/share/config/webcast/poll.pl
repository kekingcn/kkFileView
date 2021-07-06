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
print "<HTML>";

# get current and last shown picture id
$sCurrPic = join( "", common::File_read( "currpic.txt" ) );

%aRequestMap = common::HTTP_getRequest();
$sLastPic = $aRequestMap{ "LastPic" };

print "<HEAD>";
    print "<META http-equiv=\"refresh\" CONTENT=\"" . $common::REFRESH_TIME . "; URL=poll.pl?LastPic=" . $sCurrPic . "\">";
print "</HEAD>";

#' a new picture was chosen ?
if( $sLastPic ne $sCurrPic )
{
    # then show the new picture
    print "<BODY bgcolor=\"red\" onLoad=\"parent.frame1.location.href='./show.pl?" . $sCurrPic . "'\">";
}
else
{
    # otherwise do nothing
    print "<BODY bgcolor=\"green\">";
}

print "</BODY>";

print "</HTML>";
