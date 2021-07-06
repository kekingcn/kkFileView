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
<!--
     xslt math lib by Wind Li
Public Functions
    sin(x,rounding-factor=100)
    cos(x,rounding-factor=100)
    tan(x,rounding-factor=100)
    ctan(x,rounding-factor=100)
    atan2(x, y ,rounding-factor=100)
    atan(x,rounding-factor=100)
    acos(x,rounding-factor=100)
    asin(x,rounding-factor=100)
    abs(x)
    max(x1,x2)
    min(x1,x2)
    power(x,power(integer only), rounding-factor=100)
    sqrt(x, rounding-factor=100)
    convert2radian(x,rounding-factor=100)
    convert2degree(x,rounding-factor=100)
    convert2fd(x,rounding-factor=100)
 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:draw="http://openoffice.org/2000/drawing" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:text="http://openoffice.org/2000/text" xmlns:style="http://openoffice.org/2000/style" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:office="http://openoffice.org/2000/office" exclude-result-prefixes="draw svg style office fo text">
    <xsl:variable name="pi" select="3.1416"/>
    <xsl:template name="math-test">
        sin(34.8)
        <xsl:call-template name="sin">
            <xsl:with-param name="x" select="34.8"/>
            <xsl:with-param name="rounding-factor" select="100000"/>
        </xsl:call-template>
        cos(34.8)
        <xsl:call-template name="cos">
            <xsl:with-param name="x" select="34.8"/>
            <xsl:with-param name="rounding-factor" select="100000"/>
        </xsl:call-template>
        atan(2.74)
        <xsl:call-template name="atan">
            <xsl:with-param name="x" select="2.74"/>
            <xsl:with-param name="rounding-factor" select="100000"/>
        </xsl:call-template>
        acos(0.5)
        <xsl:call-template name="acos">
            <xsl:with-param name="x" select="0.5"/>
            <xsl:with-param name="rounding-factor" select="100000"/>
        </xsl:call-template>
        asin(0.5)
        <xsl:call-template name="asin">
            <xsl:with-param name="x" select="0.5"/>
            <xsl:with-param name="rounding-factor" select="100000"/>
        </xsl:call-template>
        sqrt(1328.3414)
        <xsl:call-template name="sqrt">
            <xsl:with-param name="x" select="1328.3414"/>
            <xsl:with-param name="rounding-factor" select="100000"/>
        </xsl:call-template>
    </xsl:template>
    <!-- public functions start -->
    <xsl:template name="sin">
        <xsl:param name="x" select="0"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:variable name="angle" select="$x * 180 div $pi "/>
        <xsl:variable name="mod-angle" select="$angle mod 360"/>
        <xsl:variable name="sinx">
            <xsl:call-template name="sin-private">
                <xsl:with-param name="x" select="  ( $angle mod 360 )  * $pi div 180 "/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select=" round ( number($sinx) * $rounding-factor ) div $rounding-factor"/>
    </xsl:template>
    <xsl:template name="cos">
        <xsl:param name="x" select="0"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:variable name="angle" select="$x * 180 div $pi "/>
        <xsl:variable name="mod-angle" select="$angle mod 360"/>
        <xsl:variable name="cosx">
            <xsl:call-template name="cos-private">
                <xsl:with-param name="x" select="  ( $angle mod 360 )  * $pi div 180 "/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select=" round ( number($cosx) * $rounding-factor ) div $rounding-factor"/>
    </xsl:template>
    <xsl:template name="tan">
        <xsl:param name="x" select="0"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:variable name="sinx">
            <xsl:call-template name="sin">
                <xsl:with-param name="x" select="$x"/>
                <xsl:with-param name="rounding-factor" select="$rounding-factor * 10"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="cosx">
            <xsl:call-template name="cos">
                <xsl:with-param name="x" select="$x"/>
                <xsl:with-param name="rounding-factor" select="$rounding-factor * 10"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test=" $cosx = 0 ">
                <xsl:message>tan error : tan(<xsl:value-of select="$x"/>) is infinite!</xsl:message>
                <xsl:value-of select="63535"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select=" round( $sinx div $cosx * $rounding-factor) div $rounding-factor"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="ctan">
        <xsl:param name="x" select="0"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:variable name="sinx">
            <xsl:call-template name="sin">
                <xsl:with-param name="x" select="$x"/>
                <xsl:with-param name="rounding-factor" select="$rounding-factor * 10"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="cosx">
            <xsl:call-template name="cos">
                <xsl:with-param name="x" select="$x"/>
                <xsl:with-param name="rounding-factor" select="$rounding-factor * 10"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test=" $sinx = 0 ">
                <xsl:message>tan error : tan(<xsl:value-of select="$x"/>) is infinite!</xsl:message>
                <xsl:value-of select="63535"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select=" round( $cosx div $sinx * $rounding-factor) div $rounding-factor"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="atan">
        <xsl:param name="x" select="0"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:choose>
            <xsl:when test="$x = 0">
                <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:when test="$x &lt; 0">
                <xsl:variable name="atan-x">
                    <xsl:call-template name="atan">
                        <xsl:with-param name="x" select=" -1 * $x"/>
                        <xsl:with-param name="rounding-factor" select="$rounding-factor"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="-1 * $atan-x"/>
            </xsl:when>
            <xsl:when test="$x &gt; 1">
                <xsl:variable name="atan-div-x">
                    <xsl:call-template name="atan">
                        <xsl:with-param name="x" select="1 div $x "/>
                        <xsl:with-param name="rounding-factor" select="$rounding-factor"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select=" $pi div 2 - $atan-div-x"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="arctanx">
                    <xsl:call-template name="atan-private">
                        <xsl:with-param name="x" select="  $x "/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select=" round ( number($arctanx) * $rounding-factor ) div $rounding-factor"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="atan2">
        <xsl:param name="x"/>
        <xsl:param name="y"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:choose>
            <xsl:when test="$x = 0">
                <xsl:value-of select=" $pi div 2"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="atan">
                    <xsl:with-param name="x" select="$y div $x"/>
                    <xsl:with-param name="rounding-factor" select="$rounding-factor"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="acos">
        <xsl:param name="x"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:variable name="abs-x">
            <xsl:call-template name="abs">
                <xsl:with-param name="x" select="$x"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$abs-x  &gt;  1">
                <xsl:message>acos error : abs(<xsl:value-of select="$x"/>) greater than 1 !</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="atan2">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="y">
                        <xsl:call-template name="sqrt">
                            <xsl:with-param name="x" select="1 - $x * $x"/>
                            <xsl:with-param name="rounding-factor" select=" concat($rounding-factor,'0') "/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="asin">
        <xsl:param name="x"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:variable name="abs-x">
            <xsl:call-template name="abs">
                <xsl:with-param name="x" select="$x"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$abs-x  &gt;  1">
                <xsl:message>asin error : abs(<xsl:value-of select="$x"/>) greater than 1 !</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="atan2">
                    <xsl:with-param name="y" select="$x"/>
                    <xsl:with-param name="x">
                        <xsl:call-template name="sqrt">
                            <xsl:with-param name="x" select="1 - $x * $x"/>
                            <xsl:with-param name="rounding-factor" select=" concat($rounding-factor,'0') "/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="abs">
        <xsl:param name="x"/>
        <xsl:choose>
            <xsl:when test="$x &gt; 0">
                <xsl:value-of select="$x"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$x * -1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="max">
        <xsl:param name="x1"/>
        <xsl:param name="x2"/>
        <xsl:choose>
            <xsl:when test="$x1 &gt;  $x2">
                <xsl:value-of select="$x1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$x2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="min">
        <xsl:param name="x1"/>
        <xsl:param name="x2"/>
        <xsl:choose>
            <xsl:when test="$x1 &lt;  $x2">
                <xsl:value-of select="$x1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$x2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="power">
        <xsl:param name="x"/>
        <xsl:param name="y" select="1"/>
        <xsl:param name="rounding-factor" select="100"/>
        <!--  z is a private param -->
        <xsl:param name="z" select="1"/>
        <xsl:choose>
            <xsl:when test="$y &gt; 0">
                <xsl:call-template name="power">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="y" select="$y - 1"/>
                    <xsl:with-param name="z" select="$z * $x"/>
                    <xsl:with-param name="rounding-factor" select="$rounding-factor"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select=" round( $z * $rounding-factor) div $rounding-factor"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="sqrt">
        <xsl:param name="x"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:choose>
            <xsl:when test="$x = 0">0</xsl:when>
            <xsl:when test="$x &lt; 0">
                <xsl:message>sqrt error : <xsl:value-of select="$x"/>  less than 0!</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="sqrt-private">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="rounding-factor" select="$rounding-factor"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- public functions end -->
    <!--
Private functions:
sin-private
cos-private
atan-private
sqrt-private
integer-sqrt
Sqrt-GetOneDigit
-->
    <xsl:template name="sin-private">
        <xsl:param name="x" select="0"/>
        <xsl:param name="n" select="0"/>
        <xsl:param name="nx" select="1"/>
        <xsl:param name="sign" select="1"/>
        <xsl:param name="max-n" select="20"/>
        <xsl:param name="sinx" select="0"/>
        <xsl:choose>
            <xsl:when test="not ($max-n &gt;  $n) or $nx = 0 ">
                <xsl:value-of select="$sinx"/>
            </xsl:when>
            <xsl:when test="$n = 0">
                <xsl:call-template name="sin-private">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="n" select="$n + 1"/>
                    <xsl:with-param name="sign" select="$sign *  -1"/>
                    <xsl:with-param name="max-n" select="$max-n"/>
                    <xsl:with-param name="nx" select="$x "/>
                    <xsl:with-param name="sinx" select="$sinx + $x"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="new-nx" select="($nx * $x * $x)  div ( 2  *  $n )  div ( 2  *  $n  + 1)  "/>
                <xsl:call-template name="sin-private">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="n" select="$n + 1"/>
                    <xsl:with-param name="sign" select="$sign *  -1"/>
                    <xsl:with-param name="max-n" select="$max-n"/>
                    <xsl:with-param name="nx" select=" $new-nx "/>
                    <xsl:with-param name="sinx" select="$sinx + $new-nx  * $sign"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="cos-private">
        <xsl:param name="x" select="0"/>
        <xsl:param name="n" select="0"/>
        <xsl:param name="nx" select="1"/>
        <xsl:param name="sign" select="1"/>
        <xsl:param name="max-n" select="20"/>
        <xsl:param name="cosx" select="0"/>
        <xsl:choose>
            <xsl:when test="not ($max-n &gt;  $n)  or $nx = 0  ">
                <xsl:value-of select="$cosx"/>
            </xsl:when>
            <xsl:when test="$n = 0">
                <xsl:call-template name="cos-private">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="n" select="$n + 1"/>
                    <xsl:with-param name="sign" select="$sign *  -1"/>
                    <xsl:with-param name="max-n" select="$max-n"/>
                    <xsl:with-param name="nx" select=" 1 "/>
                    <xsl:with-param name="cosx" select="1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="new-nx" select="($nx * $x * $x)  div ( 2  *  $n  -1 )  div ( 2  *  $n )  "/>
                <xsl:call-template name="cos-private">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="n" select="$n + 1"/>
                    <xsl:with-param name="sign" select="$sign *  -1"/>
                    <xsl:with-param name="max-n" select="$max-n"/>
                    <xsl:with-param name="nx" select=" $new-nx "/>
                    <xsl:with-param name="cosx" select="$cosx + $new-nx  * $sign"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="atan-private">
        <xsl:param name="x" select="0"/>
        <xsl:param name="n" select="0"/>
        <xsl:param name="nx" select="1"/>
        <xsl:param name="sign" select="1"/>
        <xsl:param name="max-n" select="40"/>
        <xsl:param name="arctanx" select="0"/>
        <xsl:choose>
            <xsl:when test="not ($max-n &gt;  $n) or $nx = 0 ">
                <xsl:value-of select="$arctanx"/>
            </xsl:when>
            <xsl:when test="$n = 0">
                <xsl:call-template name="atan-private">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="n" select="$n + 1"/>
                    <xsl:with-param name="sign" select="$sign *  -1"/>
                    <xsl:with-param name="max-n" select="$max-n"/>
                    <xsl:with-param name="nx" select="$x "/>
                    <xsl:with-param name="arctanx" select="$arctanx + $x"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="new-nx" select=" $nx * $x * $x "/>
                <xsl:call-template name="atan-private">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="n" select="$n + 1"/>
                    <xsl:with-param name="sign" select="$sign *  -1"/>
                    <xsl:with-param name="max-n" select="$max-n"/>
                    <xsl:with-param name="nx" select=" $new-nx "/>
                    <xsl:with-param name="arctanx" select="$arctanx + $new-nx div (2 * $n +1)  * $sign"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="sqrt-private">
        <xsl:param name="x"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:variable name="shift" select="string-length( $rounding-factor)"/>
        <xsl:variable name="power">
            <xsl:call-template name="power">
                <xsl:with-param name="x" select="100"/>
                <xsl:with-param name="y" select="$shift"/>
                <xsl:with-param name="rounding-factor" select="1"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="integer-x" select=" round( $power * $x )"/>
        <xsl:variable name="integer-quotient">
            <xsl:call-template name="integer-sqrt">
                <xsl:with-param name="x" select="$integer-x"/>
                <xsl:with-param name="length" select=" string-length( $integer-x ) "/>
                <xsl:with-param name="curr-pos" select=" 2 -  (round (string-length( $integer-x ) div 2 )  * 2 - string-length( $integer-x ) ) "/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="power-10">
            <xsl:call-template name="power">
                <xsl:with-param name="x" select="10"/>
                <xsl:with-param name="y" select="$shift - 1"/>
                <xsl:with-param name="rounding-factor" select="1"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="  round( $integer-quotient div 10) div $power-10 "/>
    </xsl:template>
    <xsl:template name="integer-sqrt">
        <xsl:param name="x"/>
        <xsl:param name="length"/>
        <xsl:param name="curr-pos"/>
        <xsl:param name="last-quotient" select="0"/>
        <xsl:choose>
            <xsl:when test="$curr-pos &gt; $length">
                <xsl:value-of select="$last-quotient"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="curr-x" select="substring( $x, 1,  $curr-pos )"/>
                <xsl:variable name="new-quotient">
                    <xsl:call-template name="get-one-sqrt-digit">
                        <xsl:with-param name="x" select="$curr-x"/>
                        <xsl:with-param name="last-quotient" select="$last-quotient"/>
                        <xsl:with-param name="n" select="5"/>
                        <xsl:with-param name="direct" select="0"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="integer-sqrt">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="length" select="$length"/>
                    <xsl:with-param name="curr-pos" select="$curr-pos + 2"/>
                    <xsl:with-param name="last-quotient" select="number($new-quotient)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-one-sqrt-digit">
        <xsl:param name="x"/>
        <xsl:param name="last-quotient"/>
        <xsl:param name="n"/>
        <xsl:param name="direct" select="1"/>
        <xsl:variable name="quotient" select=" concat( $last-quotient, $n) "/>
        <xsl:variable name="accumulate" select="$quotient * $quotient "/>
        <xsl:choose>
            <xsl:when test="$accumulate  =  $x">
                <xsl:value-of select="concat($last-quotient , $n  )"/>
            </xsl:when>
            <xsl:when test="$direct = 0 and $accumulate  &lt;  $x">
                <xsl:call-template name="get-one-sqrt-digit">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="last-quotient" select="$last-quotient"/>
                    <xsl:with-param name="n" select="$n + 1"/>
                    <xsl:with-param name="direct" select="1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$direct = 0 and $accumulate  &gt;  $x">
                <xsl:call-template name="get-one-sqrt-digit">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="last-quotient" select="$last-quotient"/>
                    <xsl:with-param name="n" select="$n - 1"/>
                    <xsl:with-param name="direct" select="-1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test=" $accumulate * $direct  &lt;  $x * $direct  ">
                <xsl:call-template name="get-one-sqrt-digit">
                    <xsl:with-param name="x" select="$x"/>
                    <xsl:with-param name="last-quotient" select="$last-quotient"/>
                    <xsl:with-param name="n" select="$n+ $direct"/>
                    <xsl:with-param name="direct" select="$direct"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="not($n &lt; 9)  or $n = -1">
                <xsl:value-of select="concat($last-quotient , $n - $direct) "/>
            </xsl:when>
            <xsl:when test="$direct = 1">
                <xsl:value-of select="concat($last-quotient , $n - 1) "/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($last-quotient , $n) "/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="convert2redian">
        <xsl:param name="x" select="'0'"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:choose>
            <xsl:when test="contains($x,'deg')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($x, 'deg') div 180 * $pi)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($x,'fd')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($x, 'fd') div 180 div 65536 * $pi)) div $rounding-factor"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="round($rounding-factor * number($x) div 180 * $pi) div $rounding-factor"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="convert2degree">
        <xsl:param name="x" select="'0'"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:choose>
            <xsl:when test="contains($x,'deg')">
                <xsl:value-of select="round($rounding-factor * substring-before($x,'deg')) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($x,'fd')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($x, 'fd')) div 65536 ) div $rounding-factor"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="round($rounding-factor * number($x) * 180 div $pi) div $rounding-factor"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="convert2fd">
        <xsl:param name="x" select="'0'"/>
        <xsl:param name="rounding-factor" select="100"/>
        <xsl:choose>
            <xsl:when test="contains($x,'deg')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($x, 'deg') * 65535)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($x,'fd')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($x, 'fd'))) div $rounding-factor"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="round($rounding-factor * number($x) * 180 div $pi * 65535) div $rounding-factor"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
