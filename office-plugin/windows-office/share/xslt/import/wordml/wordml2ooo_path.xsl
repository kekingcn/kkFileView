<?xml version="1.0" encoding="UTF-8"?>
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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" exclude-result-prefixes="w wx aml o dt  v">
    <xsl:include href="../../common/math.xsl"/>
    <xsl:template name="dummy">
        <xsl:call-template name="test"/>
    </xsl:template>
    <xsl:template name="test-arc">
        <xsl:call-template name="svg-arc2vml-arc">
            <!--  M 125,75 a100,50 0 ?,? 100,50 -->
            <xsl:with-param name="x0" select="125"/>
            <xsl:with-param name="y0" select="75"/>
            <xsl:with-param name="rx" select="100"/>
            <xsl:with-param name="ry" select="50"/>
            <xsl:with-param name="x-axis-rotation" select="0"/>
            <xsl:with-param name="large-arc-flag" select="0"/>
            <xsl:with-param name="sweep-flag" select="0"/>
            <xsl:with-param name="x" select="225"/>
            <xsl:with-param name="y" select="125"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="test">
        <xsl:call-template name="vmlpath2svgpath">
            <xsl:with-param name="vml-path" select="'m,l,4500,3420,2520,6120,4500r2160,l6660,3240,8460,2520,8460,,3960,540r360,720l2700,1260,3240,540,,xe'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="vmlpath2svgpath">
        <xsl:param name="vml-path"/>
        <xsl:param name="svg-path" select="''"/>
        <xsl:param name="position" select="1"/>
        <xsl:param name="last-command" select="'m'"/>
        <xsl:param name="current-x" select="'0'"/>
        <xsl:param name="current-y" select="'0'"/>
        <xsl:variable name="command-and-newpos">
            <xsl:call-template name="get-path-command">
                <xsl:with-param name="vml-path" select="$vml-path"/>
                <xsl:with-param name="position" select="$position"/>
                <xsl:with-param name="last-command" select="$last-command"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="command" select="substring-before($command-and-newpos , ':')"/>
        <xsl:variable name="newpos" select="substring-after($command-and-newpos , ':')"/>
        <xsl:choose>
            <xsl:when test="$command = 'm' ">
                <!-- absolute moveto -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' M ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 't' ">
                <!-- relative moveto -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' m ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')    , ' ')  + $current-x"/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')    , ' ') + $current-y "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'l' ">
                <!-- absolute lineto -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' L ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'r' ">
                <!-- relative lineto -->
                <!-- 'l' command is not supported currently, so we use 'L' -->
                <xsl:message>'l' command is not supported currently, so we use 'L'. This may case problem.</xsl:message>
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' L ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="new-x" select=" substring-before( substring-before( $num-and-pos , ':')  , ' ')  + $current-x  "/>
                <xsl:variable name="new-y" select=" substring-after( substring-before( $num-and-pos , ':')    , ' ')  + $current-y "/>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <!-- 'l' command is not supported currently-->
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , $new-x ,' ' , $new-y  , ' ') "/>
                    <!-- xsl:with-param name="svg-path" select=" concat($new-svg-path , substring-before( $num-and-pos , ':')  , ' ') "/ -->
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')  , ' ')  + $current-x  "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')    , ' ')  + $current-y "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'dummyH' ">
                <!-- absolute horizontal  lineto -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' l ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , substring-before( $num-and-pos , ':')  , ' ' , $current-y , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( $num-and-pos , ':')  "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'dummyh' ">
                <!-- relative horizontal  lineto -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' l ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , substring-before( $num-and-pos , ':') + $current-x  , ' ' , $current-y , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( $num-and-pos , ':')  + $current-x"/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'dummyV' ">
                <!-- absolute vertical  lineto -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' l ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , $current-x , ' ' , substring-before( $num-and-pos , ':')  , ' ' ) "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x"/>
                    <xsl:with-param name="current-y" select=" substring-before( $num-and-pos , ':')  "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'dummyv' ">
                <!-- relative horizontal  lineto -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' l ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , $current-x , ' ' , substring-before( $num-and-pos , ':')  + $current-y , ' ' ) "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x"/>
                    <xsl:with-param name="current-y" select=" substring-before( $num-and-pos , ':')  "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'c' ">
                <!-- absolute curveto -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' C ' ) "/>
                <xsl:variable name="control-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="4"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $control-and-pos , ':') "/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , substring-before( $control-and-pos , ':')  , ' ' ,  substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'v' ">
                <!-- relative curveto -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' c ' ) "/>
                <xsl:variable name="control-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="4"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $control-and-pos , ':') "/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , substring-before( $control-and-pos , ':')  , ' ' ,  substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')  , ' ')  + $current-x  "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')    , ' ')  + $current-y "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'dummyS' ">
                <!-- absolute shorthand/smooth curveto -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' c ' ) "/>
                <xsl:variable name="control-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $control-and-pos , ':') "/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="control-1">
                    <xsl:choose>
                        <xsl:when test="string-length(translate($last-command, 'CcSs','')  )= 0 ">
                            <xsl:variable name="previous-control-2">
                                <xsl:call-template name="get-number-before">
                                    <xsl:with-param name="vml-path" select="$vml-path"/>
                                    <xsl:with-param name="position" select="$position"/>
                                    <xsl:with-param name="count" select="2"/>
                                    <xsl:with-param name="skipcount" select="2"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:value-of select="substring-before($previous-control-2 , ':') "/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring-before($control-and-pos, ':') "/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path ,  $control-1 , ' ' ,  substring-before( $control-and-pos , ':')  , ' ' ,  substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'dummys' ">
                <!-- absolute shorthand/smooth curveto -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' v ' ) "/>
                <xsl:variable name="control-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $control-and-pos , ':') "/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="control-1">
                    <xsl:choose>
                        <xsl:when test="string-length(translate($last-command, 'CcSs' , '')) = 0 ">
                            <xsl:variable name="previous-control-2">
                                <xsl:call-template name="get-number-before">
                                    <xsl:with-param name="vml-path" select="$vml-path"/>
                                    <xsl:with-param name="position" select="$position"/>
                                    <xsl:with-param name="count" select="2"/>
                                    <xsl:with-param name="skipcount" select="2"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:value-of select="substring-before($previous-control-2 , ':') "/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring-before($control-and-pos, ':') "/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path ,  $control-1 , ' ' ,  substring-before( $control-and-pos , ':')  , ' ' ,  substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')  , ' ')  + $current-x  "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')    , ' ')  + $current-y "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'dummyQ' ">
                <!-- absolute quadratic  bézier curves  -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' qb ' ) "/>
                <xsl:variable name="control-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $control-and-pos , ':') "/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , substring-before( $control-and-pos , ':')  , ' ' ,  substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'dummyq' ">
                <!-- relative  quadratic  bézier curves -->
                <xsl:variable name="control-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="control" select="substring-before( $control-and-pos , ':') "/>
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' qb ' ,  substring-before($control,' ') + $current-x , ' '  , substring-after($control , ' ') + $current-y ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $control-and-pos , ':') "/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="number" select="substring-before($num-and-pos, ':')"/>
                <xsl:variable name="absolute-number" select="concat(substring-before($number, ' ') + $current-x  , ' ' , substring-after($number, ' ') + $current-y)"/>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path   , ' ' ,  $absolute-number  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( $absolute-number  , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( $absolute-number   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'x' ">
                <!--dummy or $command = 'z' "-->
                <!-- closepath -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' Z ' ) "/>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'e' ">
                <!-- end path -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' N ' )"/>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <!--Code below is for the support of h-command like ha,hb...hi, maybe still need to revise-->
            <xsl:when test="$command = 'ha' ">
                <xsl:variable name="new-svg-path" select="$svg-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hb' ">
                <xsl:variable name="new-svg-path" select="$svg-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hc' ">
                <xsl:variable name="new-svg-path" select="$svg-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hd' ">
                <xsl:variable name="new-svg-path" select="$svg-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'he' ">
                <xsl:variable name="new-svg-path" select="$svg-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hf' ">
                <xsl:variable name="new-svg-path" select="$svg-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hg' ">
                <xsl:variable name="new-svg-path" select="$svg-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hh' ">
                <xsl:variable name="new-svg-path" select="$svg-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hi' ">
                <xsl:variable name="new-svg-path" select="$svg-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'nf' or $command = 'ns' ">
                <xsl:variable name="new-svg-path" select="$svg-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'al' ">
                <!-- absolute moveto -->
                <xsl:variable name="new-svg-path" select="concat($svg-path ,' W ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="6"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2svgpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="svg-path" select=" concat($new-svg-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$svg-path"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--
    **Template vmlpath2enhancedpath**
    The template is responsible for converting the vml-path to enhanced-path, because the svg:path
    can't support command a now.(But heard that will be supported in OOo3.0)
    And  the 2nd reason of using an enhanced-path is that enhanced-path have a perfect mapping to
    vmlpath.(You will find out that often, we even don't need to change the parameters).
    -->
    <xsl:template name="vmlpath2enhancedpath">
        <xsl:param name="vml-path"/>
        <xsl:param name="enhanced-path" select="''"/>
        <xsl:param name="position" select="1"/>
        <xsl:param name="last-command" select="'m'"/>
        <xsl:param name="current-x" select="'0'"/>
        <xsl:param name="current-y" select="'0'"/>
        <xsl:variable name="command-and-newpos">
            <xsl:call-template name="get-path-command">
                <xsl:with-param name="vml-path" select="$vml-path"/>
                <xsl:with-param name="position" select="$position"/>
                <xsl:with-param name="last-command" select="$last-command"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="command" select="substring-before($command-and-newpos , ':')"/>
        <xsl:variable name="newpos" select="substring-after($command-and-newpos , ':')"/>
        <xsl:choose>
            <xsl:when test="$command = 'm' ">
                <!--####Notice that the "m 0,0,1,1,1,1" means two lines-->
                <!-- absolute moveto -->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' M ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'l' ">
                <!-- absolute lineto -->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' L ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'x' ">
                <!--dummy or $command = 'z' "-->
                <!-- closepath -->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' Z ' ) "/>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'e' ">
                <!-- end path -->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' N ' )"/>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'c' ">
                <!-- absolute curveto -->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' C ' ) "/>
                <xsl:variable name="control-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="4"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $control-and-pos , ':') "/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $control-and-pos , ':')  , ' ' ,  substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 't' ">
                <!-- relative moveto -->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' M ' ) "/>
                <!--####maybe this is not created because t r and v haven't direct image in enhanced-path-->
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')    , ' ')  + $current-x"/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')    , ' ') + $current-y "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'r' ">
                <!-- relative lineto -->
                <!--####maybe this is not created because 't' 'r' and 'v' haven't direct image in enhanced-path-->
                <!-- 'l' command is not supported currently, so we use 'L' -->
                <xsl:message>'l' command is not supported currently, so we use 'L'. This may case problem.</xsl:message>
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' L ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="new-x" select=" substring-before( substring-before( $num-and-pos , ':')  , ' ')  + $current-x  "/>
                <xsl:variable name="new-y" select=" substring-after( substring-before( $num-and-pos , ':')    , ' ')  + $current-y "/>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <!-- 'l' command is not supported currently-->
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , $new-x ,' ' , $new-y  , ' ') "/>
                    <!-- xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/ -->
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')  , ' ')  + $current-x  "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')    , ' ')  + $current-y "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'v' ">
                <!-- relative curveto -->
                <!--####maybe this is not created because 't' 'r' and 'v' haven't direct image in enhanced-path-->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' C ' ) "/>
                <!--<xsl:variable name="control-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="4"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $control-and-pos , ':') "/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $control-and-pos , ':')  , ' ' ,  substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')  , ' ')  + $current-x  "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')    , ' ')  + $current-y "/>
                </xsl:call-template>-
                -->
                <xsl:variable name="x1">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="y1">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $x1 , ':')"/>
                        <xsl:with-param name="count" select="1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="x2">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $y1 , ':')"/>
                        <xsl:with-param name="count" select="1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="y2">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $x2 , ':')"/>
                        <xsl:with-param name="count" select="1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="x">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $y2 , ':')"/>
                        <xsl:with-param name="count" select="1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="y">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after( $x , ':')"/>
                        <xsl:with-param name="count" select="1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="val_x1">
                    <xsl:value-of select="substring-before( $x1 , ':')+$current-x"/>
                </xsl:variable>
                <xsl:variable name="val_y1">
                    <xsl:value-of select="substring-before( $y1 , ':')+$current-y"/>
                </xsl:variable>
                <xsl:variable name="val_x2">
                    <xsl:value-of select="substring-before( $x2 , ':')+$current-x"/>
                </xsl:variable>
                <xsl:variable name="val_y2">
                    <xsl:value-of select="substring-before( $y2 , ':')+$current-y"/>
                </xsl:variable>
                <xsl:variable name="val_x">
                    <xsl:value-of select="substring-before( $x , ':')+$current-x"/>
                </xsl:variable>
                <xsl:variable name="val_y">
                    <xsl:value-of select="substring-before( $y , ':')+$current-y"/>
                </xsl:variable>
                <xsl:variable name="control-and-pos">
                    <xsl:value-of select="concat($val_x1, ' ',$val_y1, ' ',$val_x2, ' ',$val_y2, ' ' )"/>
                </xsl:variable>
                <xsl:variable name="num-and-pos">
                    <xsl:value-of select="concat($val_x, ' ',$val_y, ' ' )"/>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ',$control-and-pos , ' ' , $num-and-pos , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $y , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $val_x  "/>
                    <xsl:with-param name="current-y" select=" $val_y "/>
                </xsl:call-template>
            </xsl:when>
            <!--Code below is for the support of h-command like ha,hb...hi, maybe still need to revise-->
            <xsl:when test="$command = 'ha' ">
                <xsl:variable name="new-enhanced-path" select="$enhanced-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hb' ">
                <xsl:variable name="new-enhanced-path" select="$enhanced-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hc' ">
                <xsl:variable name="new-enhanced-path" select="$enhanced-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hd' ">
                <xsl:variable name="new-enhanced-path" select="$enhanced-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'he' ">
                <xsl:variable name="new-enhanced-path" select="$enhanced-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hf' ">
                <xsl:variable name="new-enhanced-path" select="$enhanced-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hg' ">
                <xsl:variable name="new-enhanced-path" select="$enhanced-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hh' ">
                <xsl:variable name="new-enhanced-path" select="$enhanced-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'hi' ">
                <xsl:variable name="new-enhanced-path" select="$enhanced-path"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'nf' ">
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' F ' )"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'ns' ">
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' S ' )"/>
                <!--simply did nothing which might be wrong-->
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , ' ') "/>
                    <xsl:with-param name="position" select=" $newpos  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" $current-x "/>
                    <xsl:with-param name="current-y" select=" $current-y"/>
                </xsl:call-template>
            </xsl:when>
            <!--The following is 6 command which deal with arcs:
                ae   -> T       al -> U
                at   -> A       ar -> B
                wa   -> W       wr -> V
              These pairs of commands have shown the perfect mapping from vml-path to enhanced-path-->
            <xsl:when test="$command = 'ae' ">
                <!-- arc on the screen with the start and end angles -->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' T ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="6"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'al' ">
                <!-- ae command plus an implicitly moveto startpoint-->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' U ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="6"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'at' ">
                <!-- arc on the screen with the edge box ,start points and end points(Notice it's counter-clockwise)-->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' A ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="8"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'ar' ">
                <!-- at command plus an implicitly moveto startpoint-->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' B ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="8"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'wa' ">
                <!-- arc on the screen with the edge box ,start points and end points(Notice it's clockwise)-->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' W ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="8"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'wr' ">
                <!-- wa command plus an implicitly moveto startpoint-->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' V ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="8"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'qx' ">
                <!-- Draw a quarter ellipse retated to the x-axis-->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' X ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'qy' ">
                <!-- Draw a quarter ellipse retated to the y-axis-->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' Y ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$command = 'qb' ">
                <!-- quadratic Bezier-->
                <xsl:variable name="new-enhanced-path" select="concat($enhanced-path ,' Q ' ) "/>
                <xsl:variable name="num-and-pos">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$newpos"/>
                        <xsl:with-param name="count" select="4"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="enhanced-path" select=" concat($new-enhanced-path , substring-before( $num-and-pos , ':')  , ' ') "/>
                    <xsl:with-param name="position" select=" substring-after( $num-and-pos , ':')  "/>
                    <xsl:with-param name="last-command" select="$command"/>
                    <xsl:with-param name="current-x" select=" substring-before( substring-before( $num-and-pos , ':')   , ' ') "/>
                    <xsl:with-param name="current-y" select=" substring-after( substring-before( $num-and-pos , ':')   , ' ') "/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$enhanced-path"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-number-before">
        <!--  get $count number of number before current position , output format:number1 number2 ... numberN:newposition
            skip $skipcount of numbers
        -->
        <xsl:param name="vml-path"/>
        <xsl:param name="position" select="1"/>
        <xsl:param name="count" select="1"/>
        <xsl:param name="skipcount" select="0"/>
        <xsl:param name="number" select="''"/>
        <xsl:choose>
            <xsl:when test="$count = 0">
                <xsl:value-of select=" concat($number ,   ':' , $position) "/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="num-pos">
                    <xsl:call-template name="get-number-position">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$position"/>
                        <xsl:with-param name="direction" select="-1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="previous-num-and-pos">
                    <xsl:call-template name="get-previous-number">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$num-pos"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$skipcount &gt; 0">
                    <xsl:call-template name="get-number-before">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after($previous-num-and-pos , ':')"/>
                        <xsl:with-param name="count" select="$count"/>
                        <xsl:with-param name="skipcount" select="$skipcount - 1"/>
                        <xsl:with-param name="number" select="$number"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="$skipcount = 0">
                    <xsl:variable name="new-number">
                        <xsl:if test="not($count  = 1)">
                            <xsl:value-of select="' '"/>
                        </xsl:if>
                        <xsl:value-of select=" concat( substring-before($previous-num-and-pos , ':')  , $number ) "/>
                    </xsl:variable>
                    <xsl:call-template name="get-number-before">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after($previous-num-and-pos , ':')"/>
                        <xsl:with-param name="count" select="$count - 1"/>
                        <xsl:with-param name="skipcount" select="0"/>
                        <xsl:with-param name="number" select="$new-number"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-number-after">
        <!--  get $count number of number after current position, output format:number1 number2 ... numberN:newposition
            skip $skipcount of numbers
        -->
        <xsl:param name="vml-path"/>
        <xsl:param name="position" select="1"/>
        <xsl:param name="count" select="1"/>
        <xsl:param name="skipcount" select="0"/>
        <xsl:param name="number" select="''"/>
        <xsl:choose>
            <xsl:when test="$count = 0">
                <xsl:value-of select=" concat($number ,   ':' , $position) "/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="num-pos">
                    <xsl:call-template name="get-number-position">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$position"/>
                        <xsl:with-param name="direction" select="1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="next-num-and-pos">
                    <xsl:call-template name="get-next-number">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="$num-pos"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$skipcount &gt; 0">
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after($next-num-and-pos , ':')"/>
                        <xsl:with-param name="count" select="$count"/>
                        <xsl:with-param name="skipcount" select="$skipcount - 1"/>
                        <xsl:with-param name="number" select="$number"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="$skipcount = 0">
                    <xsl:variable name="new-number">
                        <xsl:value-of select=" concat( $number , substring-before($next-num-and-pos , ':') ) "/>
                        <xsl:if test="not($count  = 1)">
                            <xsl:value-of select="' '"/>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:call-template name="get-number-after">
                        <xsl:with-param name="vml-path" select="$vml-path"/>
                        <xsl:with-param name="position" select="substring-after($next-num-and-pos , ':')"/>
                        <xsl:with-param name="count" select="$count - 1"/>
                        <xsl:with-param name="skipcount" select="0"/>
                        <xsl:with-param name="number" select="$new-number"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-number-position">
        <!-- get the next number start position, direction should be 1  or -1-->
        <xsl:param name="vml-path"/>
        <xsl:param name="position"/>
        <xsl:param name="direction" select="1"/>
        <xsl:choose>
            <xsl:when test="$direction  = 1 and $position &gt; string-length($vml-path) ">0</xsl:when>
            <xsl:when test="$direction  = -1 and not($position &gt; 0)">0</xsl:when>
            <xsl:otherwise>
                <xsl:variable name="curr-char">
                    <xsl:if test="$direction = 1">
                        <xsl:value-of select="substring($vml-path, $position , 1)"/>
                    </xsl:if>
                    <xsl:if test="$direction = -1">
                        <xsl:value-of select="substring($vml-path, $position -1 , 1)"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="string-length(translate($curr-char ,  '+-.0123456789@' ,'')) = 0 ">
                        <!-- number start-->
                        <xsl:value-of select="$position"/>
                    </xsl:when>
                    <xsl:when test="not($curr-char = ' ')">
                        <xsl:value-of select="$position"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="get-number-position">
                            <xsl:with-param name="vml-path" select="$vml-path"/>
                            <xsl:with-param name="position" select="$position + $direction"/>
                            <xsl:with-param name="direction" select="$direction"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="skip-space">
        <xsl:param name="vml-path"/>
        <xsl:param name="position"/>
        <xsl:param name="skip-comma" select="'yes'"/>
        <xsl:variable name="curr-char" select="substring($vml-path, $position , 1)"/>
        <xsl:choose>
            <xsl:when test="$curr-char = ',' and $skip-comma = 'yes'">
                <xsl:call-template name="skip-space">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="position" select="$position+1"/>
                    <xsl:with-param name="skip-comma" select="'no'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$curr-char = ' '">
                <xsl:call-template name="skip-space">
                    <xsl:with-param name="vml-path" select="$vml-path"/>
                    <xsl:with-param name="position" select="$position+1"/>
                    <xsl:with-param name="skip-comma" select="$skip-comma"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$position"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="format-number-pos">
        <xsl:param name="number"/>
        <xsl:param name="position"/>
        <xsl:choose>
            <xsl:when test="contains($number,'@')">
                <xsl:value-of select="concat('?f',translate($number,'@',''),':' , $position ) "/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select=" concat(round($number) ,  ':' , $position) "/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-next-number">
        <!-- get the next number from current position-->
        <xsl:param name="vml-path"/>
        <xsl:param name="position"/>
        <xsl:param name="number" select=" '' "/>
        <xsl:choose>
            <xsl:when test="$position &gt; string-length($vml-path) ">
                <xsl:call-template name="format-number-pos">
                    <xsl:with-param name="number" select="$number"/>
                    <xsl:with-param name="position" select="$position"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="curr-char" select="substring($vml-path, $position , 1)"/>
                <xsl:choose>
                    <xsl:when test="string-length(translate($curr-char ,  '.0123456789' ,'')) = 0 ">
                        <!-- is number -->
                        <xsl:call-template name="get-next-number">
                            <xsl:with-param name="vml-path" select="$vml-path"/>
                            <xsl:with-param name="position" select="$position +1"/>
                            <xsl:with-param name="number" select="concat( $number, $curr-char) "/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="string-length(translate($curr-char ,  '@+-' ,'') ) = 0  and string-length($number) = 0">
                        <!-- is number -->
                        <xsl:call-template name="get-next-number">
                            <xsl:with-param name="vml-path" select="$vml-path"/>
                            <xsl:with-param name="position" select="$position +1"/>
                            <xsl:with-param name="number" select="concat( $number, $curr-char) "/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test=" $number = '' and $curr-char = ',' ">
                        <xsl:variable name="new-pos">
                            <xsl:call-template name="skip-space">
                                <xsl:with-param name="vml-path" select="$vml-path"/>
                                <xsl:with-param name="position" select="$position"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat( '0:' , $new-pos )"/>
                    </xsl:when>
                    <xsl:when test=" $number = '' and not($curr-char = ',') ">
                        <xsl:variable name="new-pos">
                            <xsl:call-template name="skip-space">
                                <xsl:with-param name="vml-path" select="$vml-path"/>
                                <xsl:with-param name="position" select="$position"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat( '0:' , $new-pos)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="new-pos">
                            <xsl:call-template name="skip-space">
                                <xsl:with-param name="vml-path" select="$vml-path"/>
                                <xsl:with-param name="position" select="$position"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:call-template name="format-number-pos">
                            <xsl:with-param name="number" select="$number"/>
                            <xsl:with-param name="position" select="$new-pos"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-previous-number">
        <!-- get the previous number from current position-->
        <xsl:param name="vml-path"/>
        <xsl:param name="position"/>
        <xsl:param name="number" select="''"/>
        <xsl:choose>
            <xsl:when test="not($position &gt; 0)">
                <xsl:call-template name="format-number-pos">
                    <xsl:with-param name="number" select="$number"/>
                    <xsl:with-param name="position" select="'0'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="curr-char" select="substring($vml-path, $position -1 , 1)"/>
                <xsl:choose>
                    <xsl:when test="string-length(translate($curr-char ,  '.0123456789' ,'')) = 0 ">
                        <!-- is number -->
                        <xsl:call-template name="get-previous-number">
                            <xsl:with-param name="vml-path" select="$vml-path"/>
                            <xsl:with-param name="position" select="$position -1"/>
                            <xsl:with-param name="number" select="concat($curr-char ,  $number) "/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="string-length(translate($curr-char ,  '@+-' ,'') ) = 0  and string-length($number) = 0">
                        <!-- skip it -->
                        <xsl:call-template name="get-previous-number">
                            <xsl:with-param name="vml-path" select="$vml-path"/>
                            <xsl:with-param name="position" select="$position -1"/>
                            <xsl:with-param name="number" select="$number "/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="string-length(translate($curr-char ,  '+-' ,'') ) = 0  and string-length($number) &gt; 0">
                        <!-- finish it with +/- -->
                        <xsl:call-template name="format-number-pos">
                            <xsl:with-param name="number" select="$number"/>
                            <xsl:with-param name="position" select="$position"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="format-number-pos">
                            <xsl:with-param name="number" select="$number"/>
                            <xsl:with-param name="position" select="$position"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-path-command_dummy">
        <xsl:param name="vml-path"/>
        <xsl:param name="position" select="1"/>
        <xsl:param name="last-command"/>
        <xsl:choose>
            <xsl:when test="$position &gt; string-length($vml-path) "/>
            <xsl:otherwise>
                <xsl:variable name="curr-char" select="substring($vml-path, $position , 1)"/>
                <xsl:choose>
                    <xsl:when test="string-length(translate($curr-char ,  'mlcxetrvnfsawqyb' ,'')) = 0 ">
                        <!-- "MmZzLlHhVvCcSsQqTtAa" are all possible  command chars -->
                        <xsl:value-of select="concat( $curr-char , ':'  , $position +1)"/>
                    </xsl:when>
                    <xsl:when test="string-length(translate($curr-char ,  '+-.0123456789@' ,'')) = 0 ">
                        <!-- number start, use last command -->
                        <xsl:if test="string-length($last-command) = 0">
                            <xsl:message>ooo2wordml_path.xsl: Find undefined command</xsl:message>
                        </xsl:if>
                        <xsl:value-of select="concat( $last-command  , ':'  , $position )"/>
                    </xsl:when>
                    <xsl:when test="string-length(translate($curr-char ,  ',&#9;&#10;&#13;&#32;' ,'')) = 0 ">
                        <!-- space or ',' should be skip -->
                        <xsl:call-template name="get-path-command">
                            <xsl:with-param name="vml-path" select="$vml-path"/>
                            <xsl:with-param name="position" select="$position +1"/>
                            <xsl:with-param name="last-command" select="$last-command"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>ooo2wordml_path.xsl: Find undefined command:<xsl:value-of select="$curr-char"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--
        **get-path- command**
        This function will collect the next command from a string. If the input string should has a start of number character,
        we here implicitly think the command is the last-command
        All of the command of vml is listed as following:
        __Basic commands:__
        m       l       c       x       e       t       r       v       nf      ns      ae      al      at      ar      wa      wr      qx      qy      qb
        __Edit behavior extensions commands__
        ha  hb  hc  hd  he  hf  hg  hh  hi

        So we know the longest command should be four character.The function is implemented on this basis:
     -->
    <xsl:template name="get-path-command">
        <xsl:param name="vml-path"/>
        <xsl:param name="position" select="1"/>
        <xsl:param name="last-command"/>
        <xsl:choose>
            <xsl:when test="$position &gt; string-length($vml-path) "/>
            <xsl:otherwise>
                <xsl:variable name="curr-char" select="substring($vml-path, $position , 1)"/>
                <xsl:variable name="curr-2char" select="substring($vml-path, $position - 1 , 2)"/>
                <xsl:choose>
                    <xsl:when test="$curr-char = 'a' ">
                        <!--process the commands ae al at ar-->
                        <xsl:variable name="second-char" select="substring($vml-path, $position+1 , 1)"/>
                        <xsl:variable name="isvalid">
                            <xsl:choose>
                                <xsl:when test="$second-char='e' ">1</xsl:when>
                                <xsl:when test="$second-char='l' ">1</xsl:when>
                                <xsl:when test="$second-char='t' ">1</xsl:when>
                                <xsl:when test="$second-char='r' ">1</xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:if test="$isvalid = '1' ">
                            <xsl:value-of select="concat( $curr-char,$second-char , ':'  , $position +2)"/>
                        </xsl:if>
                        <xsl:if test="$isvalid = '0' ">
                            <xsl:message>ooo2wordml_path.xsl: Error command occurred </xsl:message>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$curr-char = 'n' ">
                        <!--process the commands nf ns -->
                        <xsl:variable name="second-char" select="substring($vml-path, $position+1 , 1)"/>
                        <xsl:variable name="isvalid">
                            <xsl:choose>
                                <xsl:when test="$second-char='f' ">1</xsl:when>
                                <xsl:when test="$second-char='s' ">1</xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:if test="$isvalid = '1' ">
                            <xsl:value-of select="concat( $curr-char,$second-char , ':'  , $position +2)"/>
                        </xsl:if>
                        <xsl:if test="$isvalid = '0' ">
                            <xsl:message>ooo2wordml_path.xsl: Error command occurred </xsl:message>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$curr-char = 'w' ">
                        <!--process the commands wa wr-->
                        <xsl:variable name="second-char" select="substring($vml-path, $position+1 , 1)"/>
                        <xsl:variable name="isvalid">
                            <xsl:choose>
                                <xsl:when test="$second-char='a' ">1</xsl:when>
                                <xsl:when test="$second-char='r' ">1</xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:if test="$isvalid = '1' ">
                            <xsl:value-of select="concat( $curr-char,$second-char , ':'  , $position +2)"/>
                        </xsl:if>
                        <xsl:if test="$isvalid = '0' ">
                            <xsl:message>ooo2wordml_path.xsl: Error command occurred </xsl:message>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$curr-char = 'q' ">
                        <!--process the commands qx qy qb-->
                        <xsl:variable name="second-char" select="substring($vml-path, $position+1 , 1)"/>
                        <xsl:variable name="isvalid">
                            <xsl:choose>
                                <xsl:when test="$second-char='x' ">1</xsl:when>
                                <xsl:when test="$second-char='y' ">1</xsl:when>
                                <xsl:when test="$second-char='b' ">1</xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:if test="$isvalid = '1' ">
                            <xsl:value-of select="concat( $curr-char,$second-char , ':'  , $position +2)"/>
                        </xsl:if>
                        <xsl:if test="$isvalid = '0' ">
                            <xsl:message>ooo2wordml_path.xsl: Error command occurred </xsl:message>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$curr-char = 'h' ">
                        <!--process the edit behavior extensions commands-->
                        <xsl:variable name="second-char" select="substring($vml-path, $position+1 , 1)"/>
                        <xsl:variable name="isvalid">
                            <xsl:choose>
                                <xsl:when test="string-length(translate($second-char ,  'abcdefghi' ,'')) = 0">1</xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:if test="$isvalid = '1' ">
                            <xsl:value-of select="concat( $curr-char,$second-char , ':'  , $position +2)"/>
                        </xsl:if>
                        <xsl:if test="$isvalid = '0' ">
                            <xsl:message>ooo2wordml_path.xsl: Error command occurred </xsl:message>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="string-length(translate($curr-char ,  'mlcxetrv' ,'')) = 0 ">
                        <!--process the single character commands m l c x e t r v -->
                        <xsl:value-of select="concat( $curr-char , ':'  , $position +1)"/>
                    </xsl:when>
                    <xsl:when test="string-length(translate($curr-char ,  '+-.0123456789@' ,'')) = 0 ">
                        <!-- number start, use last command -->
                        <xsl:if test="string-length($last-command) = 0">
                            <xsl:message>ooo2wordml_path.xsl: Find undefined command</xsl:message>
                        </xsl:if>
                        <xsl:value-of select="concat( $last-command  , ':'  , $position )"/>
                    </xsl:when>
                    <xsl:when test="$curr-2char=',,' ">
                        <!-- here are two ',' -->
                        <xsl:if test="string-length($last-command) = 0">
                            <xsl:message>ooo2wordml_path.xsl: Find undefined command</xsl:message>
                        </xsl:if>
                        <xsl:value-of select="concat( $last-command  , ':'  , $position  )"/>
                    </xsl:when>
                    <xsl:when test="string-length(translate($curr-char ,  ',&#9;&#10;&#13;&#32;' ,'')) = 0 ">
                        <!-- space or ',' should be skip -->
                        <xsl:call-template name="get-path-command">
                            <xsl:with-param name="vml-path" select="$vml-path"/>
                            <xsl:with-param name="position" select="$position +1"/>
                            <xsl:with-param name="last-command" select="$last-command"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>ooo2wordml_path.xsl: Find undefined command:<xsl:value-of select="$curr-char"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="svg-arc2vml-arc">
        <xsl:param name="x0"/>
        <xsl:param name="y0"/>
        <xsl:param name="rx"/>
        <xsl:param name="ry"/>
        <xsl:param name="x-axis-rotation" select="0"/>
        <xsl:param name="large-arc-flag" select="0"/>
        <xsl:param name="sweep-flag" select="0"/>
        <xsl:param name="x"/>
        <xsl:param name="y"/>
        <!-- Compute 1/2 distance between current and final point -->
        <xsl:variable name="dx2" select="($x0 - $x) div 2"/>
        <xsl:variable name="dy2" select="($y0 - $y) div 2"/>
        <!--    Convert from degrees to radians -->
        <xsl:variable name="rotation-radian" select="$x-axis-rotation * $pi div 180"/>
        <!-- Compute (x1, y1). What are x1,y1?-->
        <xsl:variable name="cos-rotation">
            <xsl:call-template name="cos">
                <xsl:with-param name="x" select="$rotation-radian"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="sin-rotation">
            <xsl:call-template name="sin">
                <xsl:with-param name="x" select="$rotation-radian"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="x1" select="$cos-rotation * $dx2 + $sin-rotation * $dy2"/>
        <xsl:variable name="y1" select="-1 * $sin-rotation  * $dx2 + $cos-rotation * $dy2"/>
        <!-- Make sure radii are large enough -->
        <xsl:variable name="rx-abs">
            <xsl:call-template name="abs">
                <xsl:with-param name="x" select="$rx"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ry-abs">
            <xsl:call-template name="abs">
                <xsl:with-param name="x" select="$ry"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="rx-sq" select="$rx-abs * $rx-abs"/>
        <xsl:variable name="ry-sq" select="$ry-abs * $ry-abs"/>
        <xsl:variable name="x1-sq" select="$x1 * $x1"/>
        <xsl:variable name="y1-sq" select="$y1 * $y1"/>
        <xsl:variable name="radius-check" select=" $x1-sq div $rx-sq + $y1-sq div $ry-sq "/>
        <xsl:variable name="radius-check-sqrt">
            <xsl:call-template name="sqrt">
                <xsl:with-param name="x" select="$radius-check"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="new-rx">
            <xsl:choose>
                <xsl:when test="$radius-check &gt; 1">
                    <xsl:value-of select="$rx-abs * $radius-check-sqrt"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$rx-abs"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="new-ry">
            <xsl:choose>
                <xsl:when test="$radius-check &gt; 1">
                    <xsl:value-of select="$ry-abs * $radius-check-sqrt"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$ry-abs"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="new-ry-sq">
            <xsl:choose>
                <xsl:when test="$radius-check &gt; 1">
                    <xsl:value-of select="$new-ry * $new-ry"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$ry-sq"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="new-rx-sq">
            <xsl:choose>
                <xsl:when test="$radius-check &gt; 1">
                    <xsl:value-of select="$new-rx * $new-rx"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$rx-sq"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Step 2: Compute (cx1, cy1) -->
        <xsl:variable name="sign">
            <xsl:choose>
                <xsl:when test="$large-arc-flag = $sweep-flag">-1</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="unchecked-sq" select=" (($new-rx-sq * $new-ry-sq) - ($new-rx-sq * $y1-sq) - ($new-ry-sq * $x1-sq)) div   (($new-rx-sq * $y1-sq) + ($new-ry-sq * $x1-sq)) "/>
        <xsl:variable name="sq">
            <xsl:choose>
                <xsl:when test=" $unchecked-sq &lt; 0">0</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$unchecked-sq"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sq-sqrt">
            <xsl:call-template name="sqrt">
                <xsl:with-param name="x" select="$sq"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="coef" select="$sign * $sq-sqrt "/>
        <xsl:variable name="cx1" select="$coef * $new-rx * $y1 div $new-ry"/>
        <xsl:variable name="cy1" select=" -1 * $coef * $new-ry * $x1 div $new-rx"/>
        <!--  Step 3: Compute (cx, cy) from (cx1, cy1) -->
        <xsl:variable name="sx2" select="($x0 +$x) div 2 "/>
        <xsl:variable name="sy2" select="($y0 +$y) div 2 "/>
        <xsl:variable name="tmp1" select="$cos-rotation * $cx1 "/>
        <xsl:variable name="tmp2" select="$cos-rotation * $cx1 "/>
        <xsl:variable name="cx" select=" $sx2 + ( $cos-rotation * $cx1 - $sin-rotation * $cy1 ) "/>
        <xsl:variable name="cy" select=" $sy2 + ( $sin-rotation * $cx1 + $cos-rotation * $cy1 ) "/>
        <!-- Step 4: Compute angle start and angle extent -->
        <xsl:variable name="ux" select="( $x1 - $cx1)  div $new-rx"/>
        <xsl:variable name="uy" select="( $y1 - $cy1)  div $new-ry"/>
        <xsl:variable name="vx" select="( - 1 *  $x1 - $cx1)  div $new-rx"/>
        <xsl:variable name="vy" select="(- 1 *  $y1 - $cy1)  div $new-ry"/>
        <xsl:variable name="n">
            <xsl:call-template name="sqrt">
                <xsl:with-param name="x" select="  ($ux * $ux) + ($uy * $uy)  "/>
            </xsl:call-template>
        </xsl:variable>
        <!--  1 * ux + 0 * uy -->
        <xsl:variable name="p" select="$ux"/>
        <xsl:variable name="uy-sign">
            <xsl:choose>
                <xsl:when test=" $uy &lt; 0 ">-1</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="acos-pn">
            <xsl:call-template name="acos">
                <xsl:with-param name="x" select="$p div $n"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="theta" select="( $uy-sign * $acos-pn * 180 div $pi ) mod 360 "/>
        <xsl:variable name="n-delta">
            <xsl:call-template name="sqrt">
                <xsl:with-param name="x" select="($ux * $ux + $uy * $uy) * ($vx * $vx + $vy * $vy)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="p-delta" select="$ux * $vx + $uy * $vy"/>
        <xsl:variable name="vy-sign">
            <xsl:choose>
                <xsl:when test="($ux * $vy - $uy * $vx)   &lt; 0 ">-1</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="acos-pn-delta">
            <xsl:call-template name="acos">
                <xsl:with-param name="x" select="$p-delta div $n-delta"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="unchecked-delta" select="$vy-sign * $acos-pn-delta * 180 div $pi "/>
        <xsl:variable name="delta">
            <xsl:choose>
                <xsl:when test=" $sweep-flag = 0 and $unchecked-delta &gt; 0 ">
                    <xsl:value-of select=" ($unchecked-delta - 360) mod 360 "/>
                </xsl:when>
                <xsl:when test=" $sweep-flag = 1 and $unchecked-delta &lt; 0 ">
                    <xsl:value-of select=" ($unchecked-delta + 360) mod 360 "/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select=" $unchecked-delta  mod 360 "/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat ($cx,  ' ' , $cy, ' ' ,  $rx, ' ' ,  $ry, ' ' ,  $theta, ' ' , $delta,  ' ' , $x-axis-rotation) "/>
    </xsl:template>
</xsl:stylesheet>
