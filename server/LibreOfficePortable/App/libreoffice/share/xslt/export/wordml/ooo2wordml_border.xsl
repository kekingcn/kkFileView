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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" exclude-result-prefixes="office table style text draw svg   dc config xlink meta oooc dom ooo chart math dr3d form script ooow draw">
    <!-- multiple usage: get size, type, color of table-cell, paragraph, and page borders. -->
    <xsl:template name="get-border-size">
        <xsl:param name="border"/>
        <xsl:param name="border-line-width"/>
        <xsl:choose>
            <xsl:when test="$border = 'none' or $border = 'hidden'">
                <xsl:text>none;0</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="border-value">
                    <xsl:call-template name="convert2cm">
                        <xsl:with-param name="value" select="$border"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="border-style">
                    <xsl:choose>
                        <xsl:when test="contains($border,'solid')">solid</xsl:when>
                        <xsl:when test="contains($border,'double')">double</xsl:when>
                        <xsl:otherwise>none</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- MS word and SO writer borders Mapping
                MS word Borders                         SO borders
                w:val="single" w:sz="0"                         0.05pt(0.002cm);solid
                w:val="single" w:sz="12"                        1.00pt(0.035cm);solid
                w:val="single" w:sz="18"                        2.50pt(0.088cm);solid
                w:val="single" w:sz="36"                        4.00pt(0.141cm);solid
                w:val="single" w:sz="48"                        5.00pt(0.176cm);solid
                w:val="double" w:sz="2"                         1.10pt(0.039cm);double
                w:val="double" w:sz="6"                         2.60pt(0.092cm);double
                w:val="thin-thick-small-gap" w:sz="12"          3.00pt(0.105cm);double
                w:val="thin-thick-large-gap" w:sz="18"          3.55pt(0.125cm);double
                w:val="thick-thin-medium-gap" w:sz="24"         4.50pt(0.158cm);double
                w:val="thin-thick-medium-gap" w:sz="24"         5.05pt(0.178cm);double
                w:val="thin-thick-small-gap" w:sz="24"          6.00pt(0.211cm);double
                w:val="thin-thick-medium-gap" w:sz="36"         6.55pt(0.231cm);double
                w:val="double" w:sz="18"                        7.50pt(0.264cm);double
                w:val="thin-thick-medium-gap" w:sz="48"         9.00pt(0.317cm);double;style:border-line-width="0.088cm 0.088cm 0.141cm"
                w:val="double" w:sz="24"                        9.00pt(0.317cm);double;style:border-line-width="0.141cm 0.088cm 0.088cm"
                we adjust the criteria by adding about 1/2 range of this current criteria and next criteria.  Gary. Yang -->
                <xsl:variable name="microsoft-border-style-size">
                    <xsl:choose>
                        <xsl:when test=" $border-style = 'solid'">
                            <xsl:choose>
                                <xsl:when test="$border-value &lt;= 0.018">single;0</xsl:when>
                                <xsl:when test="$border-value &lt;= 0.055">single;12</xsl:when>
                                <xsl:when test="$border-value &lt;= 0.110">single;18</xsl:when>
                                <xsl:when test="$border-value &lt;= 0.155">single;36</xsl:when>
                                <xsl:when test="$border-value &lt;= 0.198">single;48</xsl:when>
                                <xsl:otherwise>single;48</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="$border-style = 'double'">
                            <xsl:choose>
                                <xsl:when test="$border-value &lt; 0.064">double;2</xsl:when>
                                <xsl:when test="$border-value &lt; 0.098">double;6</xsl:when>
                                <xsl:when test="$border-value &lt; 0.115">thin-thick-small-gap;12</xsl:when>
                                <xsl:when test="$border-value &lt; 0.135">thin-thick-large-gap;18</xsl:when>
                                <xsl:when test="$border-value &lt; 0.168">thick-thin-medium-gap;24</xsl:when>
                                <xsl:when test="$border-value &lt; 0.190">thin-thick-medium-gap;24</xsl:when>
                                <xsl:when test="$border-value &lt; 0.221">thin-thick-small-gap;24</xsl:when>
                                <xsl:when test="$border-value &lt; 0.241">thin-thick-medium-gap;36</xsl:when>
                                <xsl:when test="$border-value &lt; 0.300">double;18</xsl:when>
                                <xsl:when test="$border-value &lt; 0.430">
                                    <xsl:variable name="border-inner-line-value">
                                        <xsl:call-template name="convert2cm">
                                            <xsl:with-param name="value" select="$border-line-width"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:if test="$border-inner-line-value &lt; 0.10">thin-thick-medium-gap;48</xsl:if>
                                    <xsl:if test="$border-inner-line-value &gt; 0.10">double;24</xsl:if>
                                </xsl:when>
                                <xsl:otherwise>double;24</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>none;0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="$microsoft-border-style-size"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- get bottom and right border style, size, color  -->
    <xsl:template name="get-border">
        <xsl:param name="so-border"/>
        <xsl:param name="so-border-line-width"/>
        <xsl:param name="so-border-position"/>
        <xsl:variable name="ms-style-width">
            <xsl:call-template name="get-border-size">
                <xsl:with-param name="border" select="$so-border"/>
                <xsl:with-param name="border-line-width" select="$so-border-line-width"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$so-border-position = 'bottom' or $so-border-position = 'right'">
                <!-- if border style is bottom or right border we need to change the thin-thick to thick-thin; Vice Versa -->
                <xsl:choose>
                    <xsl:when test="substring-before($ms-style-width, '-')='thin'">
                        <xsl:attribute name="w:val"><xsl:value-of select="concat( 'thick-thin', substring-after(substring-before($ms-style-width, ';'), 'k' ))"/></xsl:attribute>
                    </xsl:when>
                    <xsl:when test="substring-before($ms-style-width, '-')='thick'">
                        <xsl:attribute name="w:val"><xsl:value-of select="concat( 'thin-thick', substring-after(substring-before($ms-style-width, ';'), 'n' ))"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="w:val"><xsl:value-of select="substring-before($ms-style-width, ';')"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:attribute name="w:sz"><xsl:value-of select="substring-after($ms-style-width,';')"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="$so-border-position = 'top' or $so-border-position = 'left'">
                <xsl:attribute name="w:val"><xsl:value-of select="substring-before($ms-style-width,';')"/></xsl:attribute>
                <xsl:attribute name="w:sz"><xsl:value-of select="substring-after($ms-style-width,';')"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <!--get border color -->
        <xsl:choose>
            <xsl:when test="contains($so-border,'#')">
                <xsl:attribute name="w:color"><xsl:value-of select="substring-after($so-border, '#')"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="w:color">auto</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
