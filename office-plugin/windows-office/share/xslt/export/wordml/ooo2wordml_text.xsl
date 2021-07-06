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
    <xsl:template match="style:paragraph-properties" mode="paragraph">
        <w:pPr>
            <w:adjustRightInd w:val="off"/>
            <xsl:if test="@fo:break-before = 'page'">
                <w:pageBreakBefore w:val="on"/>
            </xsl:if>
            <xsl:if test="contains(@style:writing-mode, 'rl')">
                <w:bidi/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@fo:text-align-last = 'start'">
                    <xsl:choose>
                        <xsl:when test="contains(@style:writing-mode, 'rl')">
                            <w:jc w:val="right"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:jc w:val="left"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@fo:text-align-last = 'justify'">
                    <w:jc w:val="distribute"/>
                </xsl:when>
                <xsl:when test="@fo:text-align-last = 'center'">
                    <w:jc w:val="center"/>
                </xsl:when>
                <xsl:when test="@fo:text-align = 'start'">
                    <xsl:choose>
                        <xsl:when test="contains(@style:writing-mode, 'rl')">
                            <w:jc w:val="right"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:jc w:val="left"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@fo:text-align = 'end'">
                    <xsl:choose>
                        <xsl:when test="contains(@style:writing-mode, 'rl')">
                            <w:jc w:val="left"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:jc w:val="right"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@fo:text-align = 'justify'">
                    <w:jc w:val="distribute"/>
                </xsl:when>
                <xsl:when test="@fo:text-align = 'center'">
                    <w:jc w:val="center"/>
                </xsl:when>
            </xsl:choose>
            <w:spacing>
                <xsl:choose>
                    <xsl:when test="@fo:line-height">
                        <xsl:choose>
                            <xsl:when test="contains(@fo:line-height, '%')">
                                <xsl:attribute name="w:line-rule">auto</xsl:attribute>
                                <xsl:attribute name="w:line">
                                    <xsl:value-of select="round(substring-before(@fo:line-height, '%') div 100 * 240)"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="w:line-rule">exact</xsl:attribute>
                                <xsl:attribute name="w:line">
                                    <xsl:call-template name="convert2twip">
                                        <xsl:with-param name="value" select="@fo:line-height"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="@style:line-height-at-least">
                        <xsl:attribute name="w:line-rule">at-least</xsl:attribute>
                        <xsl:attribute name="w:line">
                            <xsl:call-template name="convert2twip">
                                <xsl:with-param name="value" select="@style:line-height-at-least"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="@style:line-spacing">
                        <xsl:attribute name="w:line-rule">auto</xsl:attribute>
                        <xsl:variable name="spacing">
                            <xsl:call-template name="convert2twip">
                                <xsl:with-param name="value" select="@style:line-spacing"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="w:line">
                            <xsl:value-of select="round($spacing div 0.567)"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="@fo:margin-top">
                    <xsl:choose>
                        <xsl:when test="contains(@fo:margin-top, '%')">
                            <xsl:if test="../@style:parent-style-name">
                                <xsl:variable name="parent-size">
                                    <xsl:value-of select="key('paragraph-style', ../@style:parent-style-name)/style:paragraph-properties/@fo:margin-top"/>
                                </xsl:variable>
                                <xsl:variable name="w-number">
                                    <xsl:call-template name="convert2twip">
                                        <xsl:with-param name="value" select="$parent-size"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:attribute name="w:before">
                                    <xsl:value-of select="round($w-number div 100 * substring-before(@fo:margin-top, '%'))"/>
                                </xsl:attribute>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="w:before">
                                <xsl:call-template name="convert2twip">
                                    <xsl:with-param name="value" select="@fo:margin-top"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@fo:margin-bottom">
                    <xsl:choose>
                        <xsl:when test="contains(@fo:margin-bottom, '%')">
                            <xsl:if test="../@style:parent-style-name">
                                <xsl:variable name="parent-size">
                                    <xsl:value-of select="key('paragraph-style', ../@style:parent-style-name)/style:paragraph-properties/@fo:margin-bottom"/>
                                </xsl:variable>
                                <xsl:variable name="w-number">
                                    <xsl:call-template name="convert2twip">
                                        <xsl:with-param name="value" select="$parent-size"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:attribute name="w:after">
                                    <xsl:value-of select="round($w-number div 100 * substring-before(@fo:margin-bottom, '%'))"/>
                                </xsl:attribute>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="w:after">
                                <xsl:call-template name="convert2twip">
                                    <xsl:with-param name="value" select="@fo:margin-bottom"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </w:spacing>
            <w:ind>
                <xsl:if test="@fo:margin-left">
                    <xsl:choose>
                        <xsl:when test="contains(@fo:margin-left, '%')">
                            <xsl:if test="../@style:parent-style-name">
                                <xsl:variable name="parent-size">
                                    <xsl:value-of select="key('paragraph-style', ../@style:parent-style-name)/style:paragraph-properties/@fo:margin-left"/>
                                </xsl:variable>
                                <xsl:variable name="w-number">
                                    <xsl:call-template name="convert2twip">
                                        <xsl:with-param name="value" select="$parent-size"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:attribute name="w:left">
                                    <xsl:value-of select="round($w-number div 100 * substring-before(@fo:margin-left, '%'))"/>
                                </xsl:attribute>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="w:left">
                                <xsl:call-template name="convert2twip">
                                    <xsl:with-param name="value" select="@fo:margin-left"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@fo:margin-right">
                    <xsl:choose>
                        <xsl:when test="contains(@fo:margin-right, '%')">
                            <xsl:if test="../@style:parent-style-name">
                                <xsl:variable name="parent-size">
                                    <xsl:value-of select="key('paragraph-style', ../@style:parent-style-name)/style:paragraph-properties/@fo:margin-right"/>
                                </xsl:variable>
                                <xsl:variable name="w-number">
                                    <xsl:call-template name="convert2twip">
                                        <xsl:with-param name="value" select="$parent-size"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:attribute name="w:right">
                                    <xsl:value-of select="round($w-number div 100 * substring-before(@fo:margin-right, '%'))"/>
                                </xsl:attribute>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="w:right">
                                <xsl:call-template name="convert2twip">
                                    <xsl:with-param name="value" select="@fo:margin-right"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@fo:text-indent">
                    <xsl:choose>
                        <!-- When @style:auto-text-indent='true' @fo:text-indent ignored, use 283 for all font size -->
                        <xsl:when test="@style:auto-text-indent='true'">
                            <xsl:attribute name="w:first-line">283</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains(@fo:text-indent, '%')">
                            <xsl:if test="../@style:parent-style-name">
                                <xsl:variable name="parent-size">
                                    <xsl:value-of select="key('paragraph-style', ../@style:parent-style-name)/style:paragraph-properties/@fo:text-indent"/>
                                </xsl:variable>
                                <xsl:variable name="w-number">
                                    <xsl:call-template name="convert2twip">
                                        <xsl:with-param name="value" select="$parent-size"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="$w-number &lt; 0">
                                        <xsl:attribute name="w:hanging">
                                            <xsl:value-of select="round($w-number div -100 * substring-before(@fo:text-indent, '%'))"/>
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="w:first-line">
                                            <xsl:value-of select="round($w-number div 100 * substring-before(@fo:text-indent, '%'))"/>
                                        </xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="starts-with(@fo:text-indent,'-')">
                            <xsl:attribute name="w:hanging">
                                <xsl:call-template name="convert2twip">
                                    <xsl:with-param name="value" select="substring-after(@fo:text-indent,'-')"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="w:first-line">
                                <xsl:call-template name="convert2twip">
                                    <xsl:with-param name="value" select="@fo:text-indent"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </w:ind>
            <xsl:if test="contains(@fo:background-color, '#')">
                <w:shd w:val="clear" w:color="auto" w:fill="{substring-after(@fo:background-color, '#')}"/>
            </xsl:if>
            <xsl:if test="@fo:keep-with-next='true'">
                <w:keepNext/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@fo:widows | @fo:orphans">
                    <w:widowControl w:val="on"/>
                </xsl:when>
                <xsl:otherwise>
                    <w:widowControl w:val="off"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@style:break-inside = 'avoid'">
                <w:keepLines/>
            </xsl:if>
            <xsl:if test="@fo:hyphenate = 'false'">
                <w:suppressAutoHyphens/>
            </xsl:if>
            <xsl:if test="@style:snap-to-layout-grid='false'">
                <w:snapToGrid w:val="off"/>
            </xsl:if>
            <xsl:if test="style:tab-stops">
                <w:tabs>
                    <xsl:for-each select="style:tab-stops/style:tab-stop">
                        <w:tab>
                            <xsl:choose>
                                <xsl:when test="@style:type='char'">
                                    <xsl:attribute name="w:val">decimal</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="@style:type">
                                    <xsl:attribute name="w:val">
                                        <xsl:value-of select="@style:type"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="w:val">left</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="@style:leader-char">
                                <xsl:choose>
                                    <xsl:when test="@style:leader-char='-'">
                                        <xsl:attribute name="w:leader">hyphen</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="@style:leader-char='_'">
                                        <xsl:attribute name="w:leader">underscore</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="@style:leader-char='.'">
                                        <xsl:attribute name="w:leader">dot</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="w:leader">dot</xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="@style:position">
                                <xsl:attribute name="w:pos">
                                    <xsl:call-template name="convert2twip">
                                        <xsl:with-param name="value" select="@style:position"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:if>
                        </w:tab>
                    </xsl:for-each>
                </w:tabs>
            </xsl:if>
            <xsl:if test="@style:line-break='normal'">
                <w:kinsoku w:val="off"/>
            </xsl:if>
            <xsl:if test="@style:punctuation-wrap='simple'">
                <w:overflowPunct w:val="off"/>
            </xsl:if>
            <xsl:if test="@style:text-autospace='none'">
                <w:autoSpaceDE w:val="off"/>
                <w:autoSpaceDN w:val="off"/>
            </xsl:if>
            <xsl:if test="@style:vertical-align">
                <xsl:element name="w:textAlignment">
                    <xsl:choose>
                        <xsl:when test="@style:vertical-align='middle'">
                            <xsl:attribute name="w:val">center</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="w:val">
                                <xsl:value-of select="@style:vertical-align"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:if>
            <xsl:if test="@text:number-lines='false'">
                <w:suppressLineNumbers/>
            </xsl:if>
            <xsl:variable name="border-top" select="@fo:border-top | @fo:border"/>
            <xsl:variable name="border-bottom" select="@fo:border-bottom | @fo:border"/>
            <xsl:variable name="border-left" select="@fo:border-left | @fo:border"/>
            <xsl:variable name="border-right" select="@fo:border-right | @fo:border"/>
            <xsl:variable name="border-line-width-top" select="@style:border-line-width-top | @style:border-line-width "/>
            <xsl:variable name="border-line-width-bottom" select="@style:border-line-width-bottom | @style:border-line-width"/>
            <xsl:variable name="border-line-width-left" select="@style:border-line-width-left | @style:border-line-width"/>
            <xsl:variable name="border-line-width-right" select="@style:border-line-width-right | @style:border-line-width"/>
            <xsl:variable name="padding-top" select="@fo:padding-top | @fo:padding"/>
            <xsl:variable name="padding-bottom" select="@fo:padding-bottom | @fo:padding"/>
            <xsl:variable name="padding-left" select="@fo:padding-left | @fo:padding"/>
            <xsl:variable name="padding-right" select="@fo:padding-right | @fo:padding"/>
            <w:pBdr>
                <xsl:if test="$border-top">
                    <xsl:element name="w:top">
                        <xsl:call-template name="get-border">
                            <xsl:with-param name="so-border" select="$border-top"/>
                            <xsl:with-param name="so-border-line-width" select="$border-line-width-top"/>
                            <xsl:with-param name="so-border-position" select=" 'top' "/>
                        </xsl:call-template>
                        <xsl:attribute name="w:space">
                            <xsl:call-template name="convert2pt">
                                <xsl:with-param name="value" select="$padding-top"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="@style:shadow!='none'">
                            <xsl:attribute name="w:shadow">on</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$border-bottom">
                    <xsl:element name="w:bottom">
                        <xsl:call-template name="get-border">
                            <xsl:with-param name="so-border" select="$border-bottom"/>
                            <xsl:with-param name="so-border-line-width" select="$border-line-width-bottom"/>
                            <xsl:with-param name="so-border-position" select=" 'bottom' "/>
                        </xsl:call-template>
                        <xsl:attribute name="w:space">
                            <xsl:call-template name="convert2pt">
                                <xsl:with-param name="value" select="$padding-bottom"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="@style:shadow!='none'">
                            <xsl:attribute name="w:shadow">on</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$border-left">
                    <xsl:element name="w:left">
                        <xsl:call-template name="get-border">
                            <xsl:with-param name="so-border" select="$border-left"/>
                            <xsl:with-param name="so-border-line-width" select="$border-line-width-left"/>
                            <xsl:with-param name="so-border-position" select=" 'left' "/>
                        </xsl:call-template>
                        <xsl:attribute name="w:space">
                            <xsl:call-template name="convert2pt">
                                <xsl:with-param name="value" select="$padding-left"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="@style:shadow!='none'">
                            <xsl:attribute name="w:shadow">on</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$border-right">
                    <xsl:element name="w:right">
                        <xsl:call-template name="get-border">
                            <xsl:with-param name="so-border" select="$border-right"/>
                            <xsl:with-param name="so-border-line-width" select="$border-line-width-right"/>
                            <xsl:with-param name="so-border-position" select=" 'right' "/>
                        </xsl:call-template>
                        <xsl:attribute name="w:space">
                            <xsl:call-template name="convert2pt">
                                <xsl:with-param name="value" select="$padding-right"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="@style:shadow!='none'">
                            <xsl:attribute name="w:shadow">on</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="@style:shadow!='none' and not(@fo:border-top | @fo:border-bottom | @fo:border-left | @fo:border-right | @fo:border)">
                    <xsl:element name="w:right">
                        <xsl:attribute name="w:shadow">on</xsl:attribute>
                        <xsl:attribute name="w:val">single</xsl:attribute>
                        <xsl:variable name="shadow-size">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="substring-after(substring-after(@style:shadow, ' '), ' ')"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="w:sz">
                            <xsl:choose>
                                <xsl:when test="$shadow-size &lt;= 0.08">12</xsl:when>
                                <xsl:when test="$shadow-size &lt;= 0.14">18</xsl:when>
                                <xsl:when test="$shadow-size &lt;= 0.20">24</xsl:when>
                                <xsl:when test="$shadow-size &lt;= 0.25">36</xsl:when>
                                <xsl:otherwise>48</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:element>
                    <xsl:element name="w:bottom">
                        <xsl:attribute name="w:shadow">on</xsl:attribute>
                        <xsl:attribute name="w:val">single</xsl:attribute>
                        <xsl:variable name="shadow-size">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="substring-after(substring-after(@style:shadow, ' '), ' ')"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="w:sz">
                            <xsl:choose>
                                <xsl:when test="$shadow-size &lt;= 0.08">12</xsl:when>
                                <xsl:when test="$shadow-size &lt;= 0.14">18</xsl:when>
                                <xsl:when test="$shadow-size &lt;= 0.20">24</xsl:when>
                                <xsl:when test="$shadow-size &lt;= 0.25">36</xsl:when>
                                <xsl:otherwise>48</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:if>
            </w:pBdr>
            <w:ind>
                <xsl:if test="$padding-left!=''">
                    <xsl:attribute name="w:left">
                        <xsl:call-template name="convert2twip">
                            <xsl:with-param name="value" select="$padding-left"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="$padding-right!='' ">
                    <xsl:attribute name="w:right">
                        <xsl:call-template name="convert2twip">
                            <xsl:with-param name="value" select="$padding-right"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
            </w:ind>
            <xsl:variable name="stylename">
                <xsl:value-of select="../@style:name"/>
            </xsl:variable>
            <xsl:if test="/office:document/office:body//text:h[@text:style-name = $stylename]">
                <xsl:variable name="headinglevel">
                    <xsl:value-of select="/office:document/office:body//text:h[@text:style-name = $stylename]/@text:level"/>
                </xsl:variable>
                <xsl:if test="/office:document/office:styles/text:outline-style/text:outline-level-style[@text:level = $headinglevel]">
                    <w:listPr>
                        <w:ilvl w:val="{$headinglevel -1}"/>
                        <w:ilfo w:val="1"/>
                    </w:listPr>
                </xsl:if>
            </xsl:if>
        </w:pPr>
    </xsl:template>
    <xsl:template match="style:text-properties" mode="character">
        <w:rPr>
            <xsl:if test="@svg:font-family | @style:font-name | @style:font-name-asian | @style:font-name-complex">
                <w:rFonts>
                    <xsl:variable name="fontname">
                        <xsl:choose>
                            <xsl:when test='starts-with(@svg:font-family,"&apos;")'>
                                <xsl:value-of select='substring-before(substring-after(@svg:font-family,"&apos;"),"&apos;")'/>
                            </xsl:when>
                            <xsl:when test="@svg:font-family">
                                <xsl:value-of select="@svg:font-family"/>
                            </xsl:when>
                            <xsl:when test="@style:font-name">
                                <xsl:value-of select="@style:font-name"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="string-length($fontname)!=0">
                        <xsl:attribute name="w:ascii">
                            <xsl:value-of select="$fontname"/>
                        </xsl:attribute>
                        <xsl:attribute name="w:h-ansi">
                            <xsl:value-of select="$fontname"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@style:font-name-asian">
                        <xsl:attribute name="w:fareast">
                            <xsl:value-of select="@style:font-name-asian"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@style:font-name-complex">
                        <xsl:attribute name="w:cs">
                            <xsl:value-of select="@style:font-name-complex"/>
                        </xsl:attribute>
                    </xsl:if>
                </w:rFonts>
            </xsl:if>
            <!-- relative font sizes not supported yet. -->
            <xsl:if test="contains(@fo:font-size, 'pt')">
                <w:sz w:val="{substring-before(@fo:font-size,'pt') * 2}"/>
            </xsl:if>
            <xsl:if test="contains(@fo:font-size-complex, 'pt')">
                <w:sz-cs w:val="{substring-before(@fo:font-size-complex, 'pt') * 2}"/>
            </xsl:if>
            <xsl:if test="@fo:font-style = 'italic' or @fo:font-style-asian = 'italic'">
                <w:i/>
            </xsl:if>
            <xsl:if test="@fo:font-style-complex = 'italic'">
                <w:i-cs/>
            </xsl:if>
            <xsl:if test="@fo:font-weight = 'bold' or @fo:font-weight-asian = 'bold'">
                <w:b/>
            </xsl:if>
            <xsl:if test="@fo:font-weight-complex = 'bold'">
                <w:b-cs/>
            </xsl:if>
            <xsl:if test="@style:text-underline-style">
                <w:u>
                    <xsl:variable name="w-u">
                        <xsl:choose>
                            <xsl:when test="@style:text-underline-style = 'solid'">
                                <xsl:choose>
                                    <xsl:when test="@style:text-underline-type = 'double'">double</xsl:when>
                                    <xsl:when test="@style:text-underline-width = 'bold'">thick</xsl:when>
                                    <xsl:otherwise>single</xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="@style:text-underline-style = 'dotted'">
                                <xsl:choose>
                                    <xsl:when test="@style:text-underline-type = 'double'">dotted-double</xsl:when>
                                    <xsl:when test="@style:text-underline-width = 'bold'">dotted-heavy</xsl:when>
                                    <xsl:otherwise>dotted</xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="@style:text-underline-style = 'dash'">
                                <xsl:choose>
                                    <xsl:when test="@style:text-underline-type = 'double'">dashed-double</xsl:when>
                                    <xsl:when test="@style:text-underline-width = 'bold'">dashed-heavy</xsl:when>
                                    <xsl:otherwise>dash</xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="@style:text-underline-style = 'long-dash'">
                                <xsl:choose>
                                    <xsl:when test="@style:text-underline-type = 'double'">dash-long-double</xsl:when>
                                    <xsl:when test="@style:text-underline-width = 'bold'">dash-long-heavy</xsl:when>
                                    <xsl:otherwise>dash-long</xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="@style:text-underline-style = 'dot-dash'">
                                <xsl:choose>
                                    <xsl:when test="@style:text-underline-type = 'double'">dot-dash-double</xsl:when>
                                    <xsl:when test="@style:text-underline-width = 'bold'">dash-dot-heavy</xsl:when>
                                    <xsl:otherwise>dot-dash</xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="@style:text-underline-style = 'dot-dot-dash'">
                                <xsl:choose>
                                    <xsl:when test="@style:text-underline-type = 'double'">dot-dot-dash-double</xsl:when>
                                    <xsl:when test="@style:text-underline-width = 'bold'">dash-dot-dot-heavy</xsl:when>
                                    <xsl:otherwise>dot-dot-dash</xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="@style:text-underline-style = 'wave'">
                                <xsl:choose>
                                    <xsl:when test="@style:text-underline-type = 'double'">wavy-double</xsl:when>
                                    <xsl:when test="@style:text-underline-width = 'bold'">wavy-heavy</xsl:when>
                                    <xsl:otherwise>wave</xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@style:text-underline-style"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="w:val">
                        <xsl:value-of select="$w-u"/>
                    </xsl:attribute>
                    <xsl:if test="contains(@style:text-underline-color,'#')">
                        <xsl:attribute name="w:color">
                            <xsl:value-of select="substring-after(@style:text-underline-color,'#')"/>
                        </xsl:attribute>
                    </xsl:if>
                </w:u>
            </xsl:if>
            <xsl:if test="@style:text-shadow | @fo:text-shadow">
                <w:shadow/>
            </xsl:if>
            <xsl:if test="string-length(@style:text-line-through-style) &gt; 0">
                <xsl:choose>
                    <xsl:when test="@style:text-line-through-type = 'double'">
                        <w:dstrike/>
                    </xsl:when>
                    <xsl:when test="@style:text-line-through-style = 'solid'">
                        <w:strike/>
                    </xsl:when>
                    <xsl:otherwise>
                        <w:strike/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="@fo:color">
                <w:color>
                    <xsl:choose>
                        <xsl:when test="@fo:color != '#000000'">
                            <xsl:attribute name="w:val">
                                <xsl:value-of select="substring-after(@fo:color,'#')"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="w:val">auto</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </w:color>
            </xsl:if>
            <xsl:if test="@fo:font-variant = 'small-caps'">
                <w:smallCaps/>
            </xsl:if>
            <xsl:if test="@fo:text-transform = 'uppercase'">
                <w:caps/>
            </xsl:if>
            <xsl:if test="@style:font-relief = 'engraved'">
                <w:imprint/>
            </xsl:if>
            <xsl:if test="@style:font-relief = 'embossed'">
                <w:emboss/>
            </xsl:if>
            <xsl:if test="@style:text-outline = 'true'">
                <w:outline/>
            </xsl:if>
            <xsl:if test="contains(@style:text-scale,'%')">
                <w:w w:val="{substring-before(@style:text-scale,'%')}"/>
            </xsl:if>
            <xsl:if test="@style:text-emphasize">
                <w:em>
                    <xsl:choose>
                        <xsl:when test="contains(@style:text-emphasize, 'accent')">
                            <xsl:attribute name="w:val">comma</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains(@style:text-emphasize, 'disc')">
                            <xsl:attribute name="w:val">under-dot</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains(@style:text-emphasize, 'none')">
                            <xsl:attribute name="w:val">none</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains(@style:text-emphasize, 'dot below')">
                            <xsl:attribute name="w:val">under-dot</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains(@style:text-emphasize, 'dot above')">
                            <xsl:attribute name="w:val">dot</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains(@style:text-emphasize, 'circle')">
                            <xsl:attribute name="w:val">dot</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </w:em>
            </xsl:if>
            <xsl:if test="@fo:letter-spacing != 'normal'">
                <w:spacing>
                    <xsl:attribute name="w:val">
                        <xsl:call-template name="convert2twip">
                            <xsl:with-param name="value" select="@fo:letter-spacing"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </w:spacing>
            </xsl:if>
            <xsl:if test="@style:text-blinking = 'true'">
                <w:effect w:val="blink-background"/>
            </xsl:if>
            <xsl:if test="@fo:language | @fo:language-asian | @fo:language-complex">
                <w:lang>
                    <xsl:if test="@fo:language and @fo:country">
                        <xsl:attribute name="w:val">
                            <xsl:value-of select="concat(@fo:language, '-', @fo:country)"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@fo:language-asian and @fo:country-asian">
                        <xsl:attribute name="w:fareast">
                            <xsl:value-of select="concat(@fo:language-asian, '-', @fo:country-asian)"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@fo:language-complex and @fo:language-complex">
                        <xsl:attribute name="w:bidi">
                            <xsl:value-of select="concat(@fo:language-complex, '-', @fo:language-complex)"/>
                        </xsl:attribute>
                    </xsl:if>
                </w:lang>
            </xsl:if>
            <xsl:if test="@style:text-position">
                <xsl:variable name="position">
                    <xsl:choose>
                        <xsl:when test="starts-with(@style:text-position, 'super')">superscript_0</xsl:when>
                        <xsl:when test="starts-with(@style:text-position, 'sub')">subscript_0</xsl:when>
                        <xsl:when test="starts-with(@style:text-position, '-')">
                            <xsl:value-of select="concat('subscript_', substring-before(@style:text-position,'%'))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('superscript_', substring-before(@style:text-position,'%'))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <w:vertAlign>
                    <xsl:attribute name="w:val">
                        <xsl:value-of select="substring-before($position,'_')"/>
                    </xsl:attribute>
                </w:vertAlign>
                <!-- Raised/Lowed position is difficult to map to MSWord w:position, Writer use %, but Word use half-point(not relative position). Since it's difficult to get font-size, use 12pt as default font-size -->
                <w:position>
                    <xsl:attribute name="w:val">
                        <xsl:choose>
                            <xsl:when test="substring-after($position, '_') = 0">0</xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="round(substring-after($position, '_') div 6)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </w:position>
            </xsl:if>
            <xsl:if test="@text:display = 'true'">
                <w:vanish/>
            </xsl:if>
            <xsl:if test="contains(@fo:background-color, '#')">
                <w:shd w:val="clear" w:color="auto" w:fill="{substring-after(@fo:background-color, '#')}"/>
            </xsl:if>
        </w:rPr>
    </xsl:template>
    <xsl:template match="text:p | text:h">
        <w:p>
            <w:pPr>
                <xsl:if test="@text:style-name">
                    <w:pStyle w:val="{@text:style-name}"/>
                </xsl:if>
                <xsl:if test="@text:level">
                    <w:outlineLvl w:val="{@text:level - 1}"/>
                </xsl:if>
                <xsl:variable name="following-paragraph-heading-table" select="following::*[(name()= 'text:p' or name()= 'text:h' or name()= 'table:table')]"/>
                <xsl:variable name="following-section" select="following::text:section[1]"/>
                <xsl:variable name="ancestor-section" select="ancestor::text:section"/>
                <!-- if the following neighbour paragraph/heading are slave of one master style, or new section starts,
                 then a new page will start -->
                <xsl:variable name="next-is-new-page" select="boolean(key( 'slave-style', $following-paragraph-heading-table[1]/@*[name()='text:style-name' or name()='table:style-name']))"/>
                <xsl:variable name="next-is-new-section">
                    <xsl:if test="$following-section and generate-id($following-section/descendant::*[(name()= 'text:p' or name()= 'text:h' or name()= 'table:table') and position() =1]) = generate-id($following-paragraph-heading-table[1])">
                        <xsl:value-of select="'yes'"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="next-is-section-end">
                    <xsl:if test="$ancestor-section and generate-id($ancestor-section[1]/following::*[(name()= 'text:p' or name()= 'text:h' or name()= 'table:table') and position() =1]) = generate-id($following-paragraph-heading-table[1])">
                        <xsl:value-of select="'yes'"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:if test="ancestor::office:body and not(ancestor::text:footnote or ancestor::text:endnote) and ($next-is-new-page or $next-is-new-section = 'yes' or $next-is-section-end = 'yes')">
                    <w:sectPr>
                        <xsl:apply-templates select="/office:document/office:styles/text:footnotes-configuration">
                            <xsl:with-param name="within-section" select="'yes'"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="/office:document/office:styles/text:endnotes-configuration">
                            <xsl:with-param name="within-section" select="'yes'"/>
                        </xsl:apply-templates>
                        <xsl:choose>
                            <xsl:when test="key( 'slave-style', @*[name()='text:style-name' or name()='table:style-name'])">
                                <xsl:apply-templates select="key('master-page', key( 'slave-style', @*[name()='text:style-name' or name()='table:style-name'])[1]/@style:master-page-name)"/>
                                <xsl:if test="$ancestor-section">
                                    <xsl:apply-templates select="key('section-style',$ancestor-section[1]/@text:style-name)" mode="section">
                                        <xsl:with-param name="master-page" select="key( 'page-layout', key('master-page', key( 'slave-style', @*[name()='text:style-name' or name()='table:style-name'])[1]/@style:master-page-name)/@style:page-layout-name)"/>
                                    </xsl:apply-templates>
                                </xsl:if>
                                <xsl:if test="key( 'slave-style', @*[name()='text:style-name' or name()='table:style-name'])/style:paragraph-properties/@style:page-number">
                                    <!-- in M$ word the header and footer associate with the w:sectPr, but in StarOffice writer the header and footer associate with the style:master-page -->
                                    <xsl:variable name="pagenumber_start">
                                        <xsl:value-of select=" key( 'slave-style', @*[name()='text:style-name' or name()='table:style-name'])/style:paragraph-properties/@style:page-number"/>
                                    </xsl:variable>
                                    <xsl:if test=" number($pagenumber_start)  &gt; 0 ">
                                        <w:pgNumType w:start="{$pagenumber_start}"/>
                                    </xsl:if>
                                    <!-- comment out the below line to enable the header and footer display normally when style:page-number =0  -->
                                    <!--w:pgNumType w:start="{key( 'slave-style', @*[name()='text:style-name' or name()='table:style-name'])/style:paragraph-properties/@style:page-number}"/ -->
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="preceding-style" select="preceding::*[(name()= 'text:p' or name()= 'text:h' or name()= 'table:table') and key( 'slave-style', @*[name()='text:style-name' or name()='table:style-name'])]"/>
                                <xsl:choose>
                                    <xsl:when test="$preceding-style">
                                        <xsl:apply-templates select="key('master-page', key( 'slave-style', $preceding-style[1]/@*[name()='text:style-name' or name()='table:style-name'])[1]/@style:master-page-name)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="/office:document/office:master-styles/style:master-page[1]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:if test="$ancestor-section">
                                    <xsl:choose>
                                        <xsl:when test="$preceding-style">
                                            <xsl:apply-templates select="key('section-style',$ancestor-section[1]/@text:style-name)" mode="section">
                                                <xsl:with-param name="master-page" select="key( 'page-layout', key('master-page', key( 'slave-style', $preceding-style[1]/@*[name()='text:style-name' or name()='table:style-name'])[1]/@style:master-page-name)/@style:page-layout-name)"/>
                                            </xsl:apply-templates>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="key('section-style',$ancestor-section[1]/@text:style-name)" mode="section">
                                                <xsl:with-param name="master-page" select="/office:document/office:automatic-styles/style:page-layout[1]"/>
                                            </xsl:apply-templates>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </w:sectPr>
                </xsl:if>
                <!-- add for office:annotation style G.Y. -->
                <xsl:if test="name(..)= 'office:annotation' ">
                    <w:pStyle w:val="CommentText"/>
                </xsl:if>
                <!-- add by wym for listPr -->
                <xsl:if test="ancestor::text:ordered-list | ancestor::text:unordered-list | ancestor::text:list">
                    <xsl:variable name="listname">
                        <xsl:value-of select="ancestor::text:ordered-list/@text:style-name | ancestor::text:unordered-list/@text:style-name  | ancestor::text:list/@text:style-name"/>
                    </xsl:variable>
                    <xsl:variable name="currlevel">
                        <xsl:value-of select="count(ancestor::text:list-item|ancestor::text:list-header)"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="string-length($listname)!=0 and $currlevel &lt; 10">
                            <xsl:variable name="currlist">
                                <xsl:apply-templates select="key('list-style', $listname)" mode="count"/>
                            </xsl:variable>
                            <w:listPr>
                                <w:ilvl w:val="{number($currlevel)-1}"/>
                                <w:ilfo w:val="{$currlist}"/>
                            </w:listPr>
                        </xsl:when>
                        <xsl:when test="string-length($listname)!=0">
                            <xsl:for-each select="key('list-style', $listname)">
                                <xsl:variable name="spacebefore">
                                    <xsl:choose>
                                        <xsl:when test="*[@text:level=$currlevel]/style:list-level-properties/@text:space-before">
                                            <xsl:call-template name="convert2twip">
                                                <xsl:with-param name="value" select="*[@text:level=$currlevel]/style:list-level-properties/@text:space-before"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="space2text">
                                    <xsl:choose>
                                        <xsl:when test="*[@text:level=$currlevel]/style:list-level-properties/@text:min-label-width">
                                            <xsl:call-template name="convert2twip">
                                                <xsl:with-param name="value" select="*[@text:level=$currlevel]/style:list-level-properties/@text:min-label-width"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <w:ind w:left="{number($space2text)+number($spacebefore)}" w:hanging="{$space2text}"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:listPr>
                                <w:ilvl w:val="{number($currlevel)-1}"/>
                                <w:ilfo w:val="1"/>
                            </w:listPr>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <!-- end of listPr -->
            </w:pPr>
            <!-- get break column from style -->
            <xsl:variable name="style" select="key('paragraph-style', @text:style-name)/style:paragraph-properties"/>
            <xsl:if test="$style/@fo:break-before = 'column'">
                <w:r>
                    <w:br w:type="column"/>
                </w:r>
            </xsl:if>
            <xsl:if test="parent::office:text and not(preceding-sibling::text:p)">
                <xsl:call-template name="PageLevelGraphic"/>
            </xsl:if>
            <xsl:if test="parent::text:footnote-body and not(preceding-sibling::*)">
                <w:r>
                    <w:rPr>
                        <w:rStyle w:val="{/office:document/office:styles/text:footnotes-configuration/@text:citation-style-name}"/>
                    </w:rPr>
                    <xsl:choose>
                        <xsl:when test="../../text:footnote-citation/@text:label">
                            <w:t>
                                <xsl:value-of select="../../text:footnote-citation/@text:label"/>
                            </w:t>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:footnoteRef/>
                        </xsl:otherwise>
                    </xsl:choose>
                </w:r>
                <w:r>
                    <w:tab/>
                </w:r>
            </xsl:if>
            <xsl:if test="parent::text:endnote-body and not(preceding-sibling::*)">
                <w:r>
                    <w:rPr>
                        <w:rStyle w:val="{/office:document/office:styles/text:endnotes-configuration/@text:citation-style-name}"/>
                    </w:rPr>
                    <xsl:choose>
                        <xsl:when test="../../text:endnote-citation/@text:label">
                            <w:t>
                                <xsl:value-of select="../../text:endnote-citation/@text:label"/>
                            </w:t>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:endnoteRef/>
                        </xsl:otherwise>
                    </xsl:choose>
                </w:r>
                <w:r>
                    <w:tab/>
                </w:r>
            </xsl:if>
            <!-- newly added the endnote , footnote templates -->
            <xsl:if test="../../@text:note-class='endnote'  and not(preceding-sibling::*)">
                <xsl:message>
                    <xsl:value-of select=" 'enter into ext:note-class= endnote' "/>
                </xsl:message>
                <w:r>
                    <w:rPr>
                        <w:rStyle w:val="Endnote_20_Symbol"/>
                    </w:rPr>
                    <xsl:choose>
                        <xsl:when test="../../text:note-citation/@text:label">
                            <w:t>
                                <xsl:value-of select="../../text:note-citation/@text:label"/>
                            </w:t>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:footnoteRef/>
                        </xsl:otherwise>
                    </xsl:choose>
                </w:r>
                <w:r>
                    <w:tab/>
                </w:r>
            </xsl:if>
            <xsl:if test="../../@text:note-class='footnote'  and not(preceding-sibling::*)">
                <xsl:message>
                    <xsl:value-of select=" 'enter into ext:note-class= footnote' "/>
                </xsl:message>
                <w:r>
                    <w:rPr>
                        <w:rStyle w:val="Footnote_20_Symbol"/>
                    </w:rPr>
                    <xsl:choose>
                        <xsl:when test="../../text:note-citation/@text:label">
                            <w:t>
                                <xsl:value-of select="../../text:note-citation/@text:label"/>
                            </w:t>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:footnoteRef/>
                        </xsl:otherwise>
                    </xsl:choose>
                </w:r>
                <w:r>
                    <w:tab/>
                </w:r>
            </xsl:if>
            <!-- apply inline-text-elements, many many many ... :( glu -->
            <xsl:apply-templates select="text:a | text:span | text() | text:hidden-text | text:line-break | text:tab-stop
             | text:s | text:note  | draw:*
             | text:page-number | text:page-count | text:subject | text:initial-creator | text:title | text:date | text:time
             | text:author-name | text:author-initials | text:chapter | text:file-name | text:sender-company
             | text:sender-firstname | text:sender-lastname | text:sender-initials | text:sender-street
             | text:sender-country | text:sender-postal-code | text:sender-city | text:sender-title | text:sender-position
             | text:sender-phone-private | text:sender-phone-work | text:sender-email | text:sender-fax
             | text:sender-state-or-province | text:word-count | text:paragraph-count | text:character-count
             | text:table-count | text:image-count | text:object-count | text:template-name | text:description
             | text:creation-time | text:creation-date | text:editing-cycles | text:editing-duration | text:keywords
             | text:print-time | text:print-date | text:creator | text:modification-time | text:modification-date
             | text:user-defined | text:printed-by | text:hidden-paragraph  | text:placeholder | text:drop-down
             | text:conditional-text  | text:text-input | text:execute-macro | text:variable-set | text:variable-input
             | text:user-field-input | text:variable-get | text:user-field-get | text:sequence | text:page-variable-set
             | text:page-variable-get | text:table-formula | text:database-display | text:database-next
             | text:database-select | text:database-row-number | text:database-name | text:reference-ref
             | text:bookmark-ref | text:footnote-ref  | text:endnote-ref | text:sequence-ref | text:expression
             | text:measure | text:dde-connection | text:sheet-name | text:bibliography-mark | text:script
             | text:page-continuation | office:annotation | text:bookmark-start | text:bookmark-end | text:bookmark
 "/>
            <!-- comment out the following line to replace the text:footnote , text:endnote with text:note in OASIS format -->
            <!--xsl:apply-templates select="text:a | text:span | text() | text:hidden-text | text:line-break | text:tab-stop
             | text:s | text:footnote | text:endnote | draw:*
             | text:page-number | text:page-count | text:subject | text:initial-creator | text:title | text:date | text:time
             | text:author-name | text:author-initials | text:chapter | text:file-name | text:sender-company
             | text:sender-firstname | text:sender-lastname | text:sender-initials | text:sender-street
             | text:sender-country | text:sender-postal-code | text:sender-city | text:sender-title | text:sender-position
             | text:sender-phone-private | text:sender-phone-work | text:sender-email | text:sender-fax
             | text:sender-state-or-province | text:word-count | text:paragraph-count | text:character-count
             | text:table-count | text:image-count | text:object-count | text:template-name | text:description
             | text:creation-time | text:creation-date | text:editing-cycles | text:editing-duration | text:keywords
             | text:print-time | text:print-date | text:creator | text:modification-time | text:modification-date
             | text:user-defined | text:printed-by | text:hidden-paragraph  | text:placeholder | text:drop-down
             | text:conditional-text  | text:text-input | text:execute-macro | text:variable-set | text:variable-input
             | text:user-field-input | text:variable-get | text:user-field-get | text:sequence | text:page-variable-set
             | text:page-variable-get | text:table-formula | text:database-display | text:database-next
             | text:database-select | text:database-row-number | text:database-name | text:reference-ref
             | text:bookmark-ref | text:footnote-ref  | text:endnote-ref | text:sequence-ref | text:expression
             | text:measure | text:dde-connection | text:sheet-name | text:bibliography-mark | text:script
             | text:page-continuation | office:annotation | text:bookmark-start | text:bookmark-end | text:bookmark
 "/-->
            <xsl:if test="$style/@fo:break-after">
                <w:r>
                    <w:br w:type="{$style/@fo:break-after}"/>
                </w:r>
            </xsl:if>
        </w:p>
    </xsl:template>
    <xsl:template match="text:span">
        <!-- apply inline-text-elements, many many many ... :( glu -->
        <xsl:apply-templates select="text:a | text() | text:hidden-text | text:line-break | text:tab-stop | text:s
             | text:note
             | text:page-number | text:page-count | text:subject | text:initial-creator | text:title | text:date | text:time
             | text:author-name | text:author-initials | text:chapter | text:file-name | text:sender-company
             | text:sender-firstname | text:sender-lastname | text:sender-initials | text:sender-street
             | text:sender-country | text:sender-postal-code | text:sender-city | text:sender-title | text:sender-position
             | text:sender-phone-private | text:sender-phone-work | text:sender-email | text:sender-fax
             | text:sender-state-or-province | text:word-count | text:paragraph-count | text:character-count
             | text:table-count | text:image-count | text:object-count | text:template-name | text:description
             | text:creation-time | text:creation-date | text:editing-cycles | text:editing-duration | text:keywords
             | text:print-time | text:print-date | text:creator | text:modification-time | text:modification-date
             | text:user-defined | text:printed-by | text:hidden-paragraph  | text:placeholder | text:drop-down
             | text:conditional-text  | text:text-input | text:execute-macro | text:variable-set | text:variable-input
             | text:user-field-input | text:variable-get | text:user-field-get | text:sequence | text:page-variable-set
             | text:page-variable-get | text:table-formula | text:database-display | text:database-next
             | text:database-select | text:database-row-number | text:database-name | text:reference-ref
             | text:bookmark-ref | text:footnote-ref  | text:endnote-ref | text:sequence-ref | text:expression
             | text:measure | text:dde-connection | text:sheet-name | text:bibliography-mark | text:script
             | text:page-continuation | office:annotation | text:bookmark-start | text:bookmark-end | text:bookmark
"/>
        <!-- comment out the following line to replace the text:footnote , text:endnote with text:note in OASIS format -->
        <!-- xsl:apply-templates select="text:a | text() | text:hidden-text | text:line-break | text:tab-stop | text:s
             | text:footnote | text:endnote
             | text:page-number | text:page-count | text:subject | text:initial-creator | text:title | text:date | text:time
             | text:author-name | text:author-initials | text:chapter | text:file-name | text:sender-company
             | text:sender-firstname | text:sender-lastname | text:sender-initials | text:sender-street
             | text:sender-country | text:sender-postal-code | text:sender-city | text:sender-title | text:sender-position
             | text:sender-phone-private | text:sender-phone-work | text:sender-email | text:sender-fax
             | text:sender-state-or-province | text:word-count | text:paragraph-count | text:character-count
             | text:table-count | text:image-count | text:object-count | text:template-name | text:description
             | text:creation-time | text:creation-date | text:editing-cycles | text:editing-duration | text:keywords
             | text:print-time | text:print-date | text:creator | text:modification-time | text:modification-date
             | text:user-defined | text:printed-by | text:hidden-paragraph  | text:placeholder | text:drop-down
             | text:conditional-text  | text:text-input | text:execute-macro | text:variable-set | text:variable-input
             | text:user-field-input | text:variable-get | text:user-field-get | text:sequence | text:page-variable-set
             | text:page-variable-get | text:table-formula | text:database-display | text:database-next
             | text:database-select | text:database-row-number | text:database-name | text:reference-ref
             | text:bookmark-ref | text:footnote-ref  | text:endnote-ref | text:sequence-ref | text:expression
             | text:measure | text:dde-connection | text:sheet-name | text:bibliography-mark | text:script
             | text:page-continuation | office:annotation | text:bookmark-start | text:bookmark-end | text:bookmark
"/-->
    </xsl:template>
    <xsl:template match="text()">
        <xsl:if test="string-length(normalize-space(.)) &gt; 0">
            <w:r>
                <xsl:if test="parent::text:span">
                    <w:rPr>
                        <w:rStyle w:val="{parent::text:span/@text:style-name}"/>
                    </w:rPr>
                </xsl:if>
                <w:t>
                    <xsl:value-of select="."/>
                </w:t>
            </w:r>
        </xsl:if>
    </xsl:template>
    <xsl:template match="text:hidden-text">
        <w:r>
            <w:rPr>
                <xsl:if test="parent::text:span">
                    <w:rStyle w:val="{parent::text:span/@text:style-name}"/>
                </xsl:if>
                <w:vanish/>
            </w:rPr>
            <w:t>
                <xsl:value-of select="@text:string-value"/>
            </w:t>
        </w:r>
    </xsl:template>
    <xsl:template match="text:line-break">
        <w:r>
            <xsl:if test="parent::text:span">
                <w:rPr>
                    <w:rStyle w:val="{parent::text:span/@text:style-name}"/>
                </w:rPr>
            </xsl:if>
            <w:br w:type="text-wrapping" w:clear="all"/>
        </w:r>
    </xsl:template>
    <xsl:template match="text:tab-stop">
        <w:r>
            <xsl:if test="parent::text:span">
                <w:rPr>
                    <w:rStyle w:val="{parent::text:span/@text:style-name}"/>
                </w:rPr>
            </xsl:if>
            <w:tab/>
        </w:r>
    </xsl:template>
    <xsl:template match="text:s">
        <w:r>
            <xsl:if test="parent::text:span">
                <w:rPr>
                    <w:rStyle w:val="{parent::text:span/@text:style-name}"/>
                </w:rPr>
            </xsl:if>
            <w:t>
                <xsl:if test="@text:c">
                    <xsl:call-template name="add-space">
                        <xsl:with-param name="number" select="@text:c"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:text> </xsl:text>
            </w:t>
        </w:r>
    </xsl:template>
    <xsl:template name="add-space">
        <xsl:param name="number"/>
        <xsl:if test="$number &gt; 1">
            <xsl:call-template name="add-space">
                <xsl:with-param name="number" select="$number - 1"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="text:footnote">
        <w:r>
            <w:rPr>
                <w:rStyle w:val="{/office:document/office:styles/text:footnotes-configuration/@text:citation-body-style-name}"/>
            </w:rPr>
            <xsl:apply-templates select="text:footnote-body"/>
        </w:r>
    </xsl:template>
    <xsl:template match="text:footnote-body">
        <w:footnote>
            <xsl:if test="../text:footnote-citation/@text:label">
                <xsl:attribute name="w:suppressRef">on</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="text:h | text:p | text:ordered-list | text:unordered-list | text:list"/>
        </w:footnote>
    </xsl:template>
    <xsl:template match="text:endnote">
        <w:r>
            <w:rPr>
                <w:rStyle w:val="{/office:document/office:styles/text:endnotes-configuration/@text:citation-body-style-name}"/>
            </w:rPr>
            <xsl:apply-templates select="text:endnote-body"/>
        </w:r>
    </xsl:template>
    <xsl:template match="text:endnote-body">
        <w:endnote>
            <xsl:if test="../text:endnote-citation/@text:label">
                <xsl:attribute name="w:suppressRef">on</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="text:h | text:p | text:ordered-list | text:unordered-list | text:list"/>
        </w:endnote>
    </xsl:template>
    <xsl:template match="text:bookmark-start">
        <xsl:variable name="bookmark-id">
            <xsl:number from="/office:document/office:body" count="text:bookmark | text:bookmark-start" level="any" format="1"/>
        </xsl:variable>
        <aml:annotation aml:id="{$bookmark-id}" w:type="Word.Bookmark.Start" w:name="{@text:name}"/>
    </xsl:template>
    <xsl:template match="text:bookmark-end">
        <xsl:variable name="bookmark-id">
            <xsl:number from="/office:document/office:body" count="text:bookmark | text:bookmark-start" level="any" format="1"/>
        </xsl:variable>
        <aml:annotation aml:id="{$bookmark-id}" w:type="Word.Bookmark.End"/>
    </xsl:template>
    <xsl:template match="text:bookmark">
        <xsl:variable name="bookmark-id">
            <xsl:number from="/office:document/office:body" count="text:bookmark | text:bookmark-start" level="any" format="1"/>
        </xsl:variable>
        <aml:annotation aml:id="{$bookmark-id}" w:type="Word.Bookmark.Start" w:name="{@text:name}"/>
        <aml:annotation aml:id="{$bookmark-id}" w:type="Word.Bookmark.End"/>
    </xsl:template>
    <!-- newly added the endnote , footnote templates -->
    <xsl:template match="text:note">
        <xsl:choose>
            <xsl:when test="@text:note-class = 'endnote' ">
                <w:r>
                    <w:rPr>
                        <w:rStyle w:val="Endnote"/>
                    </w:rPr>
                    <xsl:apply-templates select="text:note-body"/>
                </w:r>
            </xsl:when>
            <xsl:when test="@text:note-class = 'footnote' ">
                <w:r>
                    <w:rPr>
                        <w:rStyle w:val="Footnote"/>
                    </w:rPr>
                    <xsl:apply-templates select="text:note-body"/>
                </w:r>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text:note-body">
        <xsl:choose>
            <xsl:when test="../@text:note-class='endnote' ">
                <w:endnote>
                    <xsl:if test="../text:note-citation/@text:label">
                        <xsl:attribute name="w:suppressRef">on</xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates select="text:h | text:p | text:ordered-list | text:unordered-list | text:list"/>
                </w:endnote>
            </xsl:when>
            <xsl:when test="../@text:note-class='footnote' ">
                <w:footnote>
                    <xsl:if test="../text:note-citation/@text:label">
                        <xsl:attribute name="w:suppressRef">on</xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates select="text:h | text:p | text:ordered-list | text:unordered-list | text:list"/>
                </w:footnote>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
