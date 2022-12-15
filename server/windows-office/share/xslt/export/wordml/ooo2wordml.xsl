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
    <xsl:output method="xml" indent="no" encoding="UTF-8" version="1.0" standalone="yes"/>
    <xsl:include href="../../common/measure_conversion.xsl"/>
    <xsl:include href="../common/ooo2ms_docpr.xsl"/>
    <xsl:include href="ooo2wordml_settings.xsl"/>
    <xsl:include href="ooo2wordml_border.xsl"/>
    <xsl:include href="ooo2wordml_page.xsl"/>
    <xsl:include href="ooo2wordml_text.xsl"/>
    <xsl:include href="ooo2wordml_list.xsl"/>
    <xsl:include href="ooo2wordml_field.xsl"/>
    <xsl:include href="ooo2wordml_table.xsl"/>
    <xsl:include href="ooo2wordml_draw.xsl"/>
    <xsl:include href="ooo2wordml_path.xsl"/>
    <xsl:key name="paragraph-style" match="style:style[@style:family='paragraph']" use="@style:name"/>
    <xsl:key name="text-style" match="style:style[@style:family='text']" use="@style:name"/>
    <xsl:key name="section-style" match="style:style[@style:family='section']" use="@style:name"/>
    <xsl:key name="master-page" match="style:master-page" use="@style:name"/>
    <xsl:key name="page-layout" match="style:page-layout" use="@style:name"/>
    <xsl:key name="slave-style" match="style:style[string-length(normalize-space(@style:master-page-name)) &gt; 0]" use="@style:name"/>
    <xsl:key name="list-style" match="office:styles/text:list-style | office:automatic-styles/text:list-style" use="@style:name"/>
    <xsl:key name="graphics-style" match="style:style[@style:family='graphic']" use="@style:name"/>
    <xsl:template match="/">
        <xsl:apply-templates select="office:document"/>
    </xsl:template>
    <xsl:template match="office:document">
        <xsl:processing-instruction name="mso-application">progid="Word.Document"</xsl:processing-instruction>
        <xsl:variable name="embeddedObjPresent">
            <xsl:choose>
                <xsl:when test="//draw:object-ole[1]">yes</xsl:when>
                <xsl:otherwise>no</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <w:wordDocument xml:space="preserve" w:embeddedObjPresent="{$embeddedObjPresent}">
            <xsl:apply-templates select="office:meta"/>
            <xsl:apply-templates select="office:font-face-decls"/>
            <xsl:if test="office:styles/text:outline-style | office:styles/text:list-style | office:automatic-styles/text:list-style">
                <xsl:call-template name="ListStyles"/>
            </xsl:if>
            <w:styles>
                <xsl:apply-templates select="office:styles"/>
                <xsl:apply-templates select="office:automatic-styles"/>
                <xsl:call-template name="add_hyperlink_style"/>
                <!--add for hyperlink character style G.Y.-->
                <xsl:call-template name="add_comments_style"/>
                <!--add for comments style G.Y.-->
            </w:styles>
            <xsl:call-template name="export-oledata"/>
            <xsl:apply-templates select="office:settings"/>
            <xsl:apply-templates select="office:body"/>
        </w:wordDocument>
    </xsl:template>
    <xsl:template match="office:body">
        <xsl:call-template name="page-background"/>
        <xsl:apply-templates select="office:text"/>
    </xsl:template>
    <xsl:template match="office:font-face-decls">
        <!-- get default font from default paragraph properties -->
        <w:fonts>
            <xsl:variable name="default-paragraph-properties" select="/office:document/office:styles/style:default-style[@style:family = 'paragraph']/style:paragraph-properties"/>
            <w:defaultFonts w:ascii="{$default-paragraph-properties/@style:font-name}" w:h-ansi="{$default-paragraph-properties/@style:font-name}" w:fareast="{$default-paragraph-properties/@style:font-name-asian}" w:cs="{$default-paragraph-properties/@style:font-name-complex}"/>
            <xsl:for-each select="style:font-face">
                <w:font w:name="{@style:name}">
                    <xsl:if test="@style:font-charset = 'x-symbol'">
                        <w:charset w:val="02"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="@style:font-family-generic = 'swiss'">
                            <w:family w:val="Swiss"/>
                        </xsl:when>
                        <xsl:when test="@style:font-family-generic = 'modern'">
                            <w:family w:val="Modern"/>
                        </xsl:when>
                        <xsl:when test="@style:font-family-generic = 'roman'">
                            <w:family w:val="Roman"/>
                        </xsl:when>
                        <xsl:when test="@style:font-family-generic = 'script'">
                            <w:family w:val="Script"/>
                        </xsl:when>
                        <xsl:when test="@style:font-family-generic = 'decorative'">
                            <w:family w:val="Decorative"/>
                        </xsl:when>
                        <xsl:when test="@style:font-family-generic = 'system'">
                            <w:family w:val="System"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:family w:val="System"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <w:pitch w:val="{@style:font-pitch}"/>
                </w:font>
            </xsl:for-each>
        </w:fonts>
    </xsl:template>
    <xsl:template match="office:styles | office:automatic-styles">
        <xsl:for-each select="*[(name()='style:style' or name()='style:default-style') and (@style:family= 'paragraph' or @style:family= 'text' or @style:family='table')]">
            <xsl:variable name="style-name">
                <xsl:choose>
                    <xsl:when test="name() = 'style:default-style'">
                        <xsl:value-of select="concat('default-', @style:family, '-style')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@style:name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <w:style w:styleId="{$style-name}">
                <xsl:choose>
                    <xsl:when test="@style:family = 'paragraph'">
                        <xsl:attribute name="w:type">paragraph</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="@style:family = 'text'">
                        <xsl:attribute name="w:type">character</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="@style:family = 'table'">
                        <xsl:attribute name="w:type">table</xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="name() = 'style:default-style'">
                    <xsl:attribute name="w:default">on</xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="@style:parent-style-name">
                        <w:basedOn w:val="{@style:parent-style-name}"/>
                    </xsl:when>
                    <xsl:when test="name() = 'style:style' and @style:family= 'paragraph'">
                        <w:basedOn w:val="{concat('default-', @style:family, '-style')}"/>
                    </xsl:when>
                </xsl:choose>
                <w:name w:val="{$style-name}"/>
                <xsl:if test="parent::office:automatic-styles">
                    <w:hidden w:val="on"/>
                </xsl:if>
                <xsl:if test="@style:next-style-name">
                    <w:next w:val="{@style:next-style-name}"/>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="@style:family = 'paragraph'">
                        <xsl:apply-templates select="style:paragraph-properties" mode="paragraph"/>
                    </xsl:when>
                    <xsl:when test="@style:family = 'table'">
                        <w:tblPr>
                            <xsl:apply-templates select="style:table-properties" mode="table"/>
                        </w:tblPr>
                    </xsl:when>
                </xsl:choose>
                <xsl:apply-templates select="style:text-properties" mode="character"/>
            </w:style>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="office:text">
        <w:body>
            <xsl:apply-templates select="text:p | text:h | text:section | text:unordered-list | text:ordered-list | text:list |table:table"/>
            <xsl:variable name="paragraph-heading-table" select=".//*[name() = 'text:p' or name() = 'text:h' or name() = 'table:table']"/>
            <xsl:variable name="page" select="$paragraph-heading-table[key( 'slave-style', @*[name()='text:style-name' or name()='table:style-name'])]"/>
            <w:sectPr>
                <!--w:type w:val="continuous"/ -->
                <xsl:apply-templates select="/office:document/office:styles/text:footnotes-configuration">
                    <xsl:with-param name="within-section" select="'yes'"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="/office:document/office:styles/text:endnotes-configuration">
                    <xsl:with-param name="within-section" select="'yes'"/>
                </xsl:apply-templates>
                <xsl:choose>
                    <xsl:when test="count($page) &gt; 0">
                        <xsl:apply-templates select="key('master-page', key( 'slave-style', $page[last()]/@*[name()='text:style-name' or name()='table:style-name'])/@style:master-page-name)"/>
                        <xsl:if test="key( 'slave-style', $page[last()]/@*[name()='text:style-name' or name()='table:style-name'])/style:paragraph-properties/@style:page-number">
                            <!-- in M$ word the header and footer associate with the w:sectPr, but in StarOffice writer the header and footer associate with the style:master-page -->
                            <xsl:variable name="pagenumber_start">
                                <xsl:value-of select=" key( 'slave-style', $page[last()]/@*[name()='text:style-name' or name()='table:style-name'])/style:paragraph-properties/@style:page-number"/>
                            </xsl:variable>
                            <xsl:if test=" number($pagenumber_start)  &gt; 0 ">
                                <w:pgNumType w:start="{$pagenumber_start}"/>
                            </xsl:if>
                            <!-- comment out the below line to enable the header and footer display normally when style:page-number =0  -->
                            <!-- w:pgNumType w:start="{key( 'slave-style', $page[last()]/@*[name()='text:style-name' or name()='table:style-name'])/style:paragraph-properties/@style:page-number}"/-->
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="/office:document/office:master-styles/style:master-page[1]"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="$paragraph-heading-table[last()]/ancestor::text:section">
                    <xsl:apply-templates select="key('section-style',$paragraph-heading-table[last()]/ancestor::text:section[1]/@text:style-name)" mode="section"/>
                </xsl:if>
            </w:sectPr>
        </w:body>
    </xsl:template>
    <xsl:template match="text:section">
        <xsl:apply-templates select="text:p | text:h | text:section | text:unordered-list | text:ordered-list | text:list | table:table"/>
    </xsl:template>
</xsl:stylesheet>
