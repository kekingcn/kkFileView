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
    For further documentation and updates visit http://xml.openoffice.org/odf2xhtml
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xforms xlink xsd xsi">


    <!-- *** Properties with a 'fo:' prefix *** -->
    <xsl:template match="@fo:background-color">
        <xsl:text>background-color:</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>; </xsl:text>
    </xsl:template>

    <xsl:template match="@fo:border | @fo:border-top | @fo:border-bottom | @fo:border-left | @fo:border-right">
        <xsl:variable name="borderType" select="substring-after(name(), ':')"/>
        <xsl:choose>
            <xsl:when test=". = 'none'">
                <xsl:value-of select="$borderType"/>
                <xsl:text>-style:none; </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="borderWidth" select="substring-before(., ' ')"/>
                <xsl:variable name="borderStyle" select="substring-before(substring-after(., ' '), ' ')"/>
                <xsl:variable name="borderColor" select="substring-after(substring-after(., ' '), ' ')"/>

               <!-- More information at template 'round-up-border-width' -->
                <xsl:variable name="borderWidthFixed">
                    <xsl:call-template name="round-up-border-width">
                        <xsl:with-param name="borderWidth" select="$borderWidth"/>
                        <xsl:with-param name="multiplier">
                            <xsl:choose>
                                <xsl:when test="$borderStyle = 'double'">3</xsl:when>
                                <xsl:otherwise>1</xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$borderType"/>
                <xsl:text>-width:</xsl:text>
                <xsl:choose>
                    <xsl:when test="$borderWidth = '0.05pt'">thin</xsl:when>
                    <xsl:otherwise><xsl:value-of select="$borderWidthFixed"/></xsl:otherwise>
                </xsl:choose>
                <xsl:text>; </xsl:text>
                <xsl:value-of select="$borderType"/>
                <xsl:text>-style:</xsl:text>
                <xsl:value-of select="$borderStyle"/>
                <xsl:text>; </xsl:text>
                <xsl:value-of select="$borderType"/>
                <xsl:text>-color:</xsl:text>
                <xsl:value-of select="$borderColor"/>
                <xsl:text>; </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- NOTE: Still there have to be placed a <br clear='all' /> to disable the flow!!!!-->
    <xsl:template match="@fo:clear">
        <xsl:text>clear:both; </xsl:text>
    </xsl:template>

    <!-- text-shadow is a CSS2 feature and yet not common used in user-agents -->
    <xsl:template match="@fo:color |@svg:font-family |@fo:font-size |@fo:font-style |@fo:font-weight |@fo:text-indent |@fo:text-shadow |@text:display">
        <xsl:value-of select="substring-after(name(), ':')"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>; </xsl:text>
    </xsl:template>

    <!-- workaround AOOO#119401 suspicious property fo:margin="100%" in paragraph style -->
    <xsl:template match="@fo:margin[string(.) = '100%']"/>

    <!-- Maps fo:margin as well fo:margin-top, fo:margin-bottom, fo:padding-left, fo:margin-right -->
    <!-- Maps fo:padding as well fo:padding-top, fo:padding-bottom, fo:padding-left, fo:padding-right -->
    <xsl:template match="@fo:letter-spacing | @fo:line-height | @fo:width |@fo:margin | @fo:margin-top | @fo:margin-bottom | @fo:margin-left | @fo:margin-right | @fo:padding | @fo:padding-top | @fo:padding-bottom | @fo:padding-left | @fo:padding-right">
        <xsl:value-of select="local-name(.)"/>
        <xsl:text>:</xsl:text>
        <!-- Map once erroneously used inch shortage 'inch' to CSS shortage 'in' -->
        <xsl:choose>
            <xsl:when test="contains(., 'inch')">
                <xsl:value-of select="substring-before(.,'ch')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>; </xsl:text>
    </xsl:template>

    <xsl:template match="@fo:text-align">
        <!-- 'important' is necessary as table cell value alignment is decided by runtime over the valuetype
            Otherwise a table cell style-class would always be outnumbered by the run-time alignment value -->
        <xsl:choose>
            <xsl:when test="contains(., 'start')">
                <xsl:choose>
                    <xsl:when test="parent::*/@style:writing-mode and contains(parent::*/@style:writing-mode, 'rl')">
                        <xsl:text>text-align:right ! important; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>text-align:left ! important; </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains(., 'end')">
                <xsl:choose>
                    <xsl:when test="parent::*/@style:writing-mode and contains(parent::*/@style:writing-mode, 'rl')">
                        <xsl:text>text-align:right ! important;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>text-align:left ! important; </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>text-align:</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text> ! important; </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@style:vertical-align">
        <xsl:choose>
            <xsl:when test="contains(., 'bottom')">
                <xsl:text>vertical-align:bottom; </xsl:text>
            </xsl:when>
            <xsl:when test="contains(., 'middle')">
                <xsl:text>vertical-align:middle; </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>vertical-align:top; </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!-- *** Properties with a 'style:' prefix *** -->
    <!-- NOTE: Can 'inside' | 'from-inside' better be handled:
    <!ATTLIST * style:horizontal-pos (from-left|left|center|right|from-inside|inside|outside)#IMPLIED>-->
    <xsl:template match="@style:horizontal-pos">
        <xsl:choose>
            <xsl:when test=".='left'">
                <xsl:text>text-align:left; </xsl:text>
            </xsl:when>
            <xsl:when test=". = 'right'">
                <xsl:text>text-align:right; </xsl:text>
            </xsl:when>
            <xsl:when test=".='center'">
                <xsl:text>text-align:center; </xsl:text>
            </xsl:when>
            <!-- NOTE: currently other values are not used.
                If the property value is from-left or from-inside,
                the svg:x attribute associated with the frame element specifies
                the horizontal position of the frame.
                Otherwise the svg:x attribute is ignored for text documents.
            -->
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@style:column-width">
        <xsl:text>width:</xsl:text>
        <xsl:choose>
            <!-- changing the distance measure: inch to in -->
            <xsl:when test="contains(., 'inch')">
                <xsl:value-of select="substring-before(.,'ch')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>; </xsl:text>
    </xsl:template>

    <xsl:template match="@style:text-underline-style">
        <xsl:text>text-decoration:</xsl:text>
        <xsl:choose>
            <!-- changing the distance measure: inch to in -->
            <xsl:when test=".='none'">
                <xsl:text>none ! important</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>underline</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>; </xsl:text>
    </xsl:template>

    <xsl:template match="@style:font-name">
        <xsl:param name="globalData" />

        <xsl:text>font-family:</xsl:text>
        <xsl:variable name="content" select="."/>
        <xsl:variable name="quote">'</xsl:variable>
        <xsl:variable name="fontName" select="$globalData/office:font-face-decls/style:font-face[@style:name=$content]/@svg:font-family" />
        <xsl:value-of select="translate($fontName, $quote, '')"/>
        <xsl:text>; </xsl:text>
    </xsl:template>

    <xsl:template match="@style:row-height">
        <xsl:text>height:</xsl:text>
        <xsl:choose>
            <!-- changing the distance measure: inch to in -->
            <xsl:when test="contains(., 'inch')">
                <xsl:value-of select="substring-before(.,'ch')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>; </xsl:text>
    </xsl:template>

    <xsl:template match="@svg:strikethrough-position">
        <xsl:if test="not(.='none')">
            <xsl:text>text-decoration:line-through; </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@style:text-position">
        <xsl:if test="contains(., 'sub')">
            <xsl:text>vertical-align:sub; </xsl:text>
            <xsl:if test="contains(., '%')">
                <xsl:text>font-size:</xsl:text>
                <xsl:value-of select="substring-after(., 'sub ')"/>
                <xsl:text>;</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:if test="contains(., 'super')">
            <xsl:text>vertical-align:super; </xsl:text>
            <xsl:if test="contains(., '%')">
                <xsl:text>font-size:</xsl:text>
                <xsl:value-of select="substring-after(., 'super ')"/>
                <xsl:text>;</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@style:vertical-pos">
        <xsl:choose>
            <xsl:when test=".='from-top'">
                <xsl:text>vertical-align:top; </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>vertical-align:</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>; </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@style:width">
        <xsl:text>width:</xsl:text>
        <xsl:choose>
            <!-- changing the distance measure: inch to in -->
            <xsl:when test="contains(., 'inch')">
                <xsl:value-of select="substring-before(.,'ch')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>; </xsl:text>
    </xsl:template>
    <xsl:template match="@style:wrap">
        <xsl:choose>
            <xsl:when test=".='left'">
                <xsl:text>float:right; </xsl:text>
            </xsl:when>
            <xsl:when test=".='right'">
                <xsl:text>float:left; </xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@style:writing-mode">
        <xsl:text>writing-mode:</xsl:text>
        <xsl:choose>
            <xsl:when test=".='rl-tb'">
                <xsl:text>horizontal-tb; direction:rtl; </xsl:text>
            </xsl:when>
            <xsl:when test=".='lr-tb'">
                <xsl:text>horizontal-tb; direction:ltr; </xsl:text>
            </xsl:when>
            <xsl:when test=".='tb-rl'">
                <xsl:text>vertical-rl; </xsl:text>
            </xsl:when>
            <xsl:when test=".='tb-lr'">
                <xsl:text>vertical-lr; </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>horizontal-tb; direction:ltr;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- *** Properties with a no 'fo:' or 'style:' prefix *** -->
    <xsl:template match="@table:align">
        <xsl:choose>
            <xsl:when test=".='left'">
                <xsl:if test="not(../@fo:margin-left)">margin-left:0px; </xsl:if>
                <xsl:text>margin-right:auto;</xsl:text></xsl:when>
            <xsl:when test=".='right'">
                <xsl:text>margin-left:auto</xsl:text>
                <xsl:if test="not(../@fo:margin-right)">
                    ; margin-right: 0px;
                </xsl:if>
            </xsl:when>
            <xsl:when test=".='center'">
                margin-left:auto;margin-right:auto;
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>float:none; </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="style:background-image">
        <xsl:text>background-image:url(</xsl:text>
        <xsl:value-of select="@xlink:href"/>
        <xsl:text>); </xsl:text>
        <xsl:choose>
            <xsl:when test="@style:repeat = 'repeat'">
                <xsl:text>background-repeat:repeat; </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>background-repeat:no-repeat; </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Changing border width measure to cm and enlarging border-width to the Mozilla browser(1.7)
         visible minimum width
            - 0.0133cm for solid style
            - 0.0399cm for double style
         as there are three border lines painted -->
    <xsl:decimal-format name = "unifiedFormat" decimal-separator = "." />
    <xsl:template name="round-up-border-width">
        <xsl:param name="borderWidth"/>
        <xsl:param name="multiplier"/>

        <xsl:variable name="borderWidthByCentimeter">
            <xsl:call-template name="convert2cm">
                <xsl:with-param name="value" select="$borderWidth"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="minimalBorderWidth" select="0.0133 * $multiplier"/>
        <xsl:choose>
            <xsl:when test="number($borderWidthByCentimeter) &lt; $minimalBorderWidth">
                <xsl:value-of select="format-number($minimalBorderWidth,'0.######','unifiedFormat')"/>
                <xsl:text>cm</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="format-number($borderWidthByCentimeter,'0.######','unifiedFormat')"/>
                <xsl:text>cm</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
