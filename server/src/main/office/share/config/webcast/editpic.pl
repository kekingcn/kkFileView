#!/usr/bin/perl
# *************************************************************
#  
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#  
#    http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing,
#  software distributed under the License is distributed on an
#  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#  KIND, either express or implied.  See the License for the
#  specific language governing permissions and limitations
#  under the License.
#  
# *************************************************************

require "common.pl";

print "Content-type: text/html\n\n";
print "<HTML>\n";

print "<HEAD>\n";
print "<title>editpic.pl</title>";
print "</HEAD>\n";

print "<BODY>\n";
    $sCurrPic = join( "", common::File_read( "currpic.txt" ) );
    @aPictureArray = common::File_read( "picture.txt" );
    $nPictureArrayLen = @aPictureArray;
    print "<FORM action=\"savepic.pl\" method=get>\n";
        if( abs( $sCurrPic ) > 1 )
        {
            print "<INPUT type=submit name=\"Auswahl\" value=\"-\"></INPUT>\n";
        }
        else
        {
            print "<INPUT type=button value=\" \"></INPUT>\n";
        }
        print "<INPUT type=text name=\"CurrPic\" value=\"";
        print $sCurrPic;
        print "\" SIZE=3></INPUT>\n";
        if( abs( $sCurrPic ) < ( $nPictureArrayLen - 1 ) )
        {
            print "<INPUT type=submit name=\"Auswahl\" value=\"+\"></INPUT>\n";
        }
        else
        {
            print "<INPUT type=button value=\" \"></INPUT>\n";
        }
        print "<INPUT type=submit name=\"Auswahl\" value=\"$$2\"></INPUT>\n";
    print "</FORM>\n";
print "</BODY>\n";

print "</HTML>\n";
