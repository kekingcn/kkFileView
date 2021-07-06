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
    <xsl:template name="page-background">
        <xsl:choose>
            <xsl:when test="/office:document/office:automatic-styles/style:page-layout/style:page-layout-properties/style:background-image[string-length(office:binary-data/text()) &gt; 0]">
                <w:bgPict>
                    <xsl:apply-templates select="/office:document/office:automatic-styles/style:page-layout/style:page-layout-properties/style:background-image[string-length(office:binary-data/text()) &gt; 0]" mode="bgPict"/>
                </w:bgPict>
            </xsl:when>
            <xsl:when test="/office:document/office:automatic-styles/style:page-layout/style:page-layout-properties[string-length(@fo:background-color) &gt; 0]">
                <w:bgPict>
                    <xsl:apply-templates select="/office:document/office:automatic-styles/style:page-layout/style:page-layout-properties[string-length(@fo:background-color) &gt; 0]" mode="bgPict"/>
                </w:bgPict>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="style:background-image" mode="bgPict">
        <xsl:variable name="binName" select="concat('wordml://',generate-id(.))"/>
        <w:binData w:name="{$binName}">
            <xsl:value-of select="translate(office:binary-data/text(),'&#9;&#10;&#13;&#32;','' ) "/>
        </w:binData>
        <w:background w:bgcolor="{parent::style:page-layout-properties/@fo:background-color}" w:background="{$binName}"/>
    </xsl:template>
    <xsl:template match="style:page-layout-properties" mode="bgPict">
        <w:background w:bgcolor="{@fo:background-color}"/>
    </xsl:template>
    <xsl:template match="style:master-page">
        <xsl:apply-templates select="key( 'page-layout', @style:page-layout-name)"/>
        <xsl:if test="style:header">
            <w:hdr w:type="odd">
                <xsl:apply-templates select="style:header/text:p | style:header/table:table"/>
                <!-- change style:header//text:p to style:header/text:p and  add table:table here, fix for  Issue 32035 -->
            </w:hdr>
        </xsl:if>
        <xsl:if test="style:header-left">
            <w:hdr w:type="even">
                <xsl:apply-templates select="style:header-left/text:p | style:header-left/table:table"/>
                <!-- change style:header//text:p to style:header/text:p and  add table:table here, fix for  Issue 32035 -->
            </w:hdr>
        </xsl:if>
        <xsl:if test="style:footer">
            <w:ftr w:type="odd">
                <xsl:apply-templates select="style:footer/text:p | style:footer/table:table"/>
                <!-- change style:header//text:p to style:header/text:p and  add table:table here, fix for  Issue 32035 -->
            </w:ftr>
        </xsl:if>
        <xsl:if test="style:footer-left">
            <w:ftr w:type="even">
                <xsl:apply-templates select="style:footer-left/text:p | style:footer-left/table:table"/>
                <!-- change style:header//text:p to style:header/text:p and  add table:table here, fix for  Issue 32035 -->
            </w:ftr>
        </xsl:if>
    </xsl:template>
    <xsl:template match="style:page-layout">
        <xsl:choose>
            <xsl:when test="@style:page-usage = 'left'">
                <w:type w:val="even-page"/>
            </xsl:when>
            <xsl:when test="@style:page-usage = 'right'">
                <w:type w:val="odd-page"/>
            </xsl:when>
            <xsl:when test="@style:page-usage = 'all'">
                <w:type w:val="next-page"/>
            </xsl:when>
            <!-- for mirrored, and default -->
            <xsl:otherwise>
                <w:type w:val="next-page"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="page-width">
            <xsl:if test="style:page-layout-properties/@fo:page-width">
                <xsl:call-template name="convert2twip">
                    <xsl:with-param name="value" select="style:page-layout-properties/@fo:page-width"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="margin-left">
            <xsl:if test="style:page-layout-properties/@fo:margin-left">
                <xsl:call-template name="convert2twip">
                    <xsl:with-param name="value" select="style:page-layout-properties/@fo:margin-left"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="margin-right">
            <xsl:if test="style:page-layout-properties/@fo:margin-right">
                <xsl:call-template name="convert2twip">
                    <xsl:with-param name="value" select="style:page-layout-properties/@fo:margin-right"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <w:pgSz>
            <xsl:if test="style:page-layout-properties/@fo:page-width">
                <xsl:attribute name="w:w">
                    <xsl:value-of select="$page-width"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="style:page-layout-properties/@fo:page-height">
                <xsl:attribute name="w:h">
                    <xsl:call-template name="convert2twip">
                        <xsl:with-param name="value" select="style:page-layout-properties/@fo:page-height"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="style:page-layout-properties/@style:print-orientation">
                <xsl:attribute name="w:orient">
                    <xsl:value-of select="style:page-layout-properties/@style:print-orientation"/>
                </xsl:attribute>
            </xsl:if>
        </w:pgSz>
        <w:pgMar>
            <xsl:if test="style:page-layout-properties/@fo:margin-top">
                <xsl:variable name="top-margin">
                    <xsl:call-template name="convert2twip">
                        <xsl:with-param name="value" select="style:page-layout-properties/@fo:margin-top"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:attribute name="w:top">
                    <xsl:value-of select="$top-margin"/>
                </xsl:attribute>
                <xsl:if test="style:header-style/style:page-layout-properties/@fo:min-height">
                    <xsl:variable name="header-height">
                        <xsl:call-template name="convert2twip">
                            <xsl:with-param name="value" select="style:header-style/style:page-layout-properties/@fo:min-height"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="w:header">
                        <xsl:value-of select="$top-margin - $header-height"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:if test="style:page-layout-properties/@fo:margin-bottom">
                <xsl:variable name="bottom-margin">
                    <xsl:call-template name="convert2twip">
                        <xsl:with-param name="value" select="style:page-layout-properties/@fo:margin-bottom"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:attribute name="w:bottom">
                    <xsl:value-of select="$bottom-margin"/>
                </xsl:attribute>
                <xsl:if test="style:footer-style/style:page-layout-properties/@fo:min-height">
                    <xsl:variable name="footer-height">
                        <xsl:call-template name="convert2twip">
                            <xsl:with-param name="value" select="style:footer-style/style:page-layout-properties/@fo:min-height"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="w:footer">
                        <xsl:value-of select="$bottom-margin - $footer-height"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:if test="style:page-layout-properties/@fo:margin-left">
                <xsl:attribute name="w:left">
                    <xsl:value-of select="$margin-left"/>
                </xsl:attribute>
                <xsl:attribute name="w:gutter">
                    <xsl:value-of select="'0'"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="style:page-layout-properties/@fo:margin-right">
                <xsl:attribute name="w:right">
                    <xsl:value-of select="$margin-right"/>
                </xsl:attribute>
            </xsl:if>
        </w:pgMar>
        <xsl:variable name="border-top" select="style:page-layout-properties/@fo:border-top | style:page-layout-properties/@fo:border"/>
        <xsl:variable name="border-bottom" select="style:page-layout-properties/@fo:border-bottom | style:page-layout-properties/@fo:border"/>
        <xsl:variable name="border-left" select="style:page-layout-properties/@fo:border-left | style:page-layout-properties/@fo:border"/>
        <xsl:variable name="border-right" select="style:page-layout-properties/@fo:border-right | style:page-layout-properties/@fo:border"/>
        <xsl:variable name="border-line-width-top" select="style:page-layout-properties/@style:border-line-width-top | style:page-layout-properties/@style:border-line-width "/>
        <xsl:variable name="border-line-width-bottom" select="style:page-layout-properties/@style:border-line-width-bottom | style:page-layout-properties/@style:border-line-width"/>
        <xsl:variable name="border-line-width-left" select="style:page-layout-properties/@style:border-line-width-left | style:page-layout-properties/@style:border-line-width"/>
        <xsl:variable name="border-line-width-right" select="style:page-layout-properties/@style:border-line-width-right | style:page-layout-properties/@style:border-line-width"/>
        <xsl:variable name="padding-top" select="style:page-layout-properties/@fo:padding-top | style:page-layout-properties/@fo:padding"/>
        <xsl:variable name="padding-bottom" select="style:page-layout-properties/@fo:padding-bottom | style:page-layout-properties/@fo:padding"/>
        <xsl:variable name="padding-left" select="style:page-layout-properties/@fo:padding-left | style:page-layout-properties/@fo:padding"/>
        <xsl:variable name="padding-right" select="style:page-layout-properties/@fo:padding-right | style:page-layout-properties/@fo:padding"/>
        <w:pgBorders w:offset-from="text">
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
                    <xsl:if test="style:page-layout-properties/@style:shadow!='none'">
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
                    <xsl:if test="style:page-layout-properties/@style:shadow!='none'">
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
                    <xsl:if test="style:page-layout-properties/@style:shadow!='none'">
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
                    <xsl:if test="style:page-layout-properties/@style:shadow!='none'">
                        <xsl:attribute name="w:shadow">on</xsl:attribute>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
        </w:pgBorders>
        <xsl:variable name="valid-width">
            <xsl:value-of select="$page-width - $margin-left - $margin-right"/>
        </xsl:variable>
        <xsl:apply-templates select="style:page-layout-properties/style:columns">
            <xsl:with-param name="page-width" select="$valid-width"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="/office:document/office:styles/text:linenumbering-configuration"/>
    </xsl:template>
    <xsl:template match="text:linenumbering-configuration">
        <xsl:if test="not(@text:number-lines = 'false')">
            <xsl:element name="w:lnNumType">
                <xsl:if test="@text:increment">
                    <xsl:attribute name="w:count-by">
                        <xsl:value-of select="@text:increment"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="@text:offset">
                    <xsl:attribute name="w:distance">
                        <xsl:call-template name="convert2twip">
                            <xsl:with-param name="value" select="@text:offset"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="w:restart">continuous</xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="style:style" mode="section">
        <xsl:param name="master-page"/>
        <xsl:variable name="page-width">
            <xsl:call-template name="convert2twip">
                <xsl:with-param name="value" select="$master-page/style:page-layout-properties/@fo:page-width"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="margin-left">
            <xsl:call-template name="convert2twip">
                <xsl:with-param name="value" select="$master-page/style:page-layout-properties/@fo:margin-left"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="margin-right">
            <xsl:call-template name="convert2twip">
                <xsl:with-param name="value" select="$master-page/style:page-layout-properties/@fo:margin-right"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="valid-width">
            <xsl:value-of select="$page-width - $margin-left - $margin-right"/>
        </xsl:variable>
        <w:type w:val="continuous"/>
        <xsl:apply-templates select="style:section-properties/style:columns">
            <xsl:with-param name="page-width" select="$valid-width"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="style:columns">
        <xsl:param name="page-width"/>
        <w:cols w:num="{@fo:column-count}">
            <xsl:if test="@fo:column-gap">
                <xsl:attribute name="w:space">
                    <xsl:call-template name="convert2twip">
                        <xsl:with-param name="value" select="@fo:column-gap"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="style:column-sep">
                <xsl:attribute name="w:sep">on</xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="not(style:column)">
                    <xsl:attribute name="w:equalWidth">on</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="w:equalWidth">off</xsl:attribute>
                    <xsl:variable name="column-relative-width">
                        <xsl:call-template name="get-sum-column-width">
                            <xsl:with-param name="current-column" select="style:column[1]"/>
                            <xsl:with-param name="current-width" select="'0'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:for-each select="style:column">
                        <xsl:element name="w:col">
                            <xsl:attribute name="w:w">
                                <xsl:value-of select="floor(substring-before(@style:rel-width,'*') * $page-width div $column-relative-width)"/>
                            </xsl:attribute>
                            <xsl:if test="@fo:margin-right">
                                <xsl:variable name="margin-right">
                                    <xsl:call-template name="convert2twip">
                                        <xsl:with-param name="value" select="@fo:margin-right"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="following-sibling::style:column">
                                        <xsl:variable name="margin-left">
                                            <xsl:call-template name="convert2twip">
                                                <xsl:with-param name="value" select="@fo:margin-left"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:attribute name="w:space">
                                            <xsl:value-of select="$margin-right + $margin-left"/>
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="w:space">
                                            <xsl:value-of select="$margin-right"/>
                                        </xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </w:cols>
    </xsl:template>
    <xsl:template name="get-sum-column-width">
        <xsl:param name="current-column"/>
        <xsl:param name="current-width"/>
        <xsl:variable name="new-width" select="$current-width + substring-before($current-column/@style:rel-width,'*')"/>
        <xsl:choose>
            <xsl:when test="$current-column/following-sibling::style:column">
                <xsl:call-template name="get-sum-column-width">
                    <xsl:with-param name="current-column" select="$current-column/following-sibling::style:column[1]"/>
                    <xsl:with-param name="current-width" select="$new-width"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$new-width"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
