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
package common;

$REFRESH_TIME = 5;

sub File_read
{
    $sFilename = @_[ 0 ];

    @aFileContentList = "";
    open( F_CURRPIC, "<" . $sFilename ) || "Could not open file " . $sFilename . " !<BR>\n";
    while( <F_CURRPIC> )
    {
        push( @aFileContentList, $_ );
    }
    close( F_CURRPIC );

    return @aFileContentList;
}   ##File_read


sub HTTP_getRequest
{
    # post- or get- method ?
    if( $ENV{ 'REQUEST_METHOD' } eq 'GET' )
    {
        # get parameters from querystring (get)
        $sRequest = $ENV{ 'QUERY_STRING' }
    }
    else
    {
        # get parameters from stdin (post)
        read( STDIN, $sRequest, $ENV{ 'CONTENT_LENGTH' } );
    }
    # process parameters
    @aRequestList = split( /&/, $sRequest );
    foreach $Feld ( @aRequestList )
    {
        ( $name, $sValue ) = split( /=/, $Feld );
        $sValue =~ tr/+/ /;
        $sValue =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
        $sValue =~ s/<!--(.|\n)*-->//g;
        $aRequestMap{ $name } = $sValue;
    }

    return %aRequestMap;
}   ##HTTP_getRequest

1;
