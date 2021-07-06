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

print "Content-type: text/html\n\n";

print "<HTML>";

print "<HEAD>";
print "</HEAD>";

print "<FRAMESET ROWS=\"*,2\" BORDER=0 FRAMEBORDER=0 FRAMESPACING=0>";
    print "<FRAME SRC=\"./show.pl\" NAME=\"frame1\" SCROLLING=yes  RESIZE MARGINWIDTH=0 MARGINHEIGHT=0 FRAMEBORDER=0>";
    print "<FRAME SRC=\"./poll.pl\" NAME=\"frame2\" SCROLLING=no NORESIZE MARGINWIDTH=0 MARGINHEIGHT=0 FRAMEBORDER=0>";
print "</FRAMESET>";

print "<NOFRAMES>";

print "<BODY BGCOLOR=\"white\">";
    print "<META HTTP-EQUIV=\"-REFRESH\" CONTENT=\"1;URL=./show.pl\">";
print "</BODY>";

print "</HTML>";
