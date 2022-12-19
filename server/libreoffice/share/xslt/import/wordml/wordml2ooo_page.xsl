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
    <xsl:template match="w:footnotePr" mode="config">
        <text:notes-configuration text:note-class="footnote" text:citation-style-name="Footnote_20_Symbol">
            <xsl:if test="w:pos">
                <xsl:choose>
                    <xsl:when test="w:pos/@w:val = 'beneath-text'">
                        <xsl:attribute name="text:footnotes-position">document</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="text:footnotes-position">page</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="w:numStart">
                <xsl:choose>
                    <xsl:when test="w:numStart/@w:val - 1 &gt; 0">
                        <xsl:attribute name="text:start-value">
                            <xsl:value-of select="w:numStart/@w:val - 1"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="text:start-value">
                            <xsl:value-of select=" '1' "/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <!--xsl:attribute name="text:start-value"><xsl:value-of select="w:numStart/@w:val - 1"/></xsl:attribute-->
            </xsl:if>
            <xsl:if test="w:numFmt">
                <xsl:call-template name="convert-number-format">
                    <xsl:with-param name="number-format" select="w:numFmt/@w:val"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="w:numRestart">
                <xsl:choose>
                    <xsl:when test="w:numRestart/@w:val = 'continuous'">
                        <xsl:attribute name="text:start-numbering-at">document</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="w:numRestart/@w:val = 'each-sect'">
                        <xsl:attribute name="text:start-numbering-at">chapter</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="text:start-numbering-at">page</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <!--
            <xsl:if test="w:footnote[@w:type = 'continuation-separator']">
                <text:footnote-continuation-notice-backward>
                    <xsl:value-of select="normalize-space(w:footnote[@w:type = 'continuation-separator'])"/>
                </text:footnote-continuation-notice-backward>
            </xsl:if>
            <xsl:if test="w:footnote[@w:type = 'continuation-notice']">
                <text:footnote-continuation-notice-forward>
                    <xsl:value-of select="normalize-space(w:footnote[@w:type = 'continuation-notice'])"/>
                </text:footnote-continuation-notice-forward>
            </xsl:if>
            -->
        </text:notes-configuration>
    </xsl:template>
    <xsl:template match="w:endnotePr" mode="config">
        <text:notes-configuration text:note-class="endnote" text:citation-style-name="Endnote_20_Symbol">
            <xsl:if test="w:numStart">
                <xsl:choose>
                    <xsl:when test="(w:numStart/@w:val - 1) &gt; 0">
                        <xsl:attribute name="text:start-value">
                            <xsl:value-of select="w:numStart/@w:val - 1"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="text:start-value">
                            <xsl:value-of select=" '1' "/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <!--xsl:attribute name="text:start-value"><xsl:value-of select="w:numStart/@w:val - 1"/></xsl:attribute -->
            </xsl:if>
            <xsl:if test="w:numFmt">
                <xsl:call-template name="convert-number-format">
                    <xsl:with-param name="number-format" select="w:numFmt/@w:val"/>
                </xsl:call-template>
            </xsl:if>
        </text:notes-configuration>
    </xsl:template>
    <xsl:template name="convert-number-format">
        <xsl:param name="number-format"/>
        <xsl:choose>
            <xsl:when test="$number-format = 'decimal' or $number-format = 'decimal-half-width'">
                <xsl:attribute name="style:num-format">1</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'decimal-zero'">
                <xsl:attribute name="style:num-format">1</xsl:attribute>
                <xsl:attribute name="style:num-prefix">0</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'decimal-enclosed-fullstop'">
                <xsl:attribute name="style:num-format">1</xsl:attribute>
                <xsl:attribute name="style:num-prefix">.</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'decimal-enclosed-paren'">
                <xsl:attribute name="style:num-format">1</xsl:attribute>
                <xsl:attribute name="style:num-prefix">(</xsl:attribute>
                <xsl:attribute name="style:num-suffix">)</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'number-in-dash'">
                <xsl:attribute name="style:num-format">1</xsl:attribute>
                <xsl:attribute name="style:num-prefix">-</xsl:attribute>
                <xsl:attribute name="style:num-suffix">-</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'upper-letter'">
                <xsl:attribute name="style:num-format">A</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'lower-letter'">
                <xsl:attribute name="style:num-format">a</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'upper-roman'">
                <xsl:attribute name="style:num-format">I</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'lower-roman'">
                <xsl:attribute name="style:num-format">i</xsl:attribute>
            </xsl:when>
            <!-- ordinal, cardinal-text, ordinal-text, hex, chicago, bullet, ideograph-zodiac-traditional,
            vietnamese-counting, russian-lower, russian-upper, hindi-vowels, hindi-consonants, hindi-numbers, hindi-counting -->
            <xsl:otherwise>
                <xsl:attribute name="style:num-format">1</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="w:bgPict">
        <xsl:if test="w:background/@w:bgcolor">
            <xsl:attribute name="fo:background-color">
                <xsl:call-template name="MapConstColor">
                    <xsl:with-param name="color" select="w:background/@w:bgcolor"/>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="w:background/@w:background">
            <style:background-image>
                <office:binary-data>
                    <xsl:variable name="the-image" select="key('imagedata',w:background/@w:background)"/>
                    <xsl:value-of select="translate($the-image/text(),'&#9;&#10;&#13;&#32;','' ) "/>
                </office:binary-data>
            </style:background-image>
        </xsl:if>
    </xsl:template>
    <xsl:template match="w:sectPr" mode="page-layout">
        <style:page-layout>
            <xsl:attribute name="style:name">pm<xsl:number from="/w:wordDocument/w:body" level="any" count="w:sectPr" format="1"/>
            </xsl:attribute>
            <style:page-layout-properties>
            <xsl:call-template name="page-layout-properties"/>
                <xsl:apply-templates select="/w:wordDocument/w:bgPict"/>
            </style:page-layout-properties>
        <style:header-style>
        <style:header-footer-properties style:dynamic-spacing="true" fo:margin-bottom="0">
           <xsl:variable name="header-margin">
               <xsl:choose>
                   <xsl:when test="w:pgMar/@w:header">
                       <xsl:value-of select="w:pgMar/@w:header"/>
                   </xsl:when>
                   <xsl:otherwise>720</xsl:otherwise>
               </xsl:choose>
           </xsl:variable>
           <xsl:variable name="header-margin-diff">
               <xsl:value-of select="w:pgMar/@w:top - $header-margin"/>
           </xsl:variable>
           <xsl:variable name="min-height">
               <xsl:choose>
                   <xsl:when test="$header-margin-diff &gt; 0">
                       <xsl:value-of select="$header-margin-diff div 567.0"/>
                   </xsl:when>
                   <xsl:otherwise>0</xsl:otherwise>
               </xsl:choose>
           </xsl:variable>
           <xsl:attribute name="fo:min-height">
               <xsl:value-of select="concat($min-height, 'cm')"/>
           </xsl:attribute>
        </style:header-footer-properties>
        </style:header-style>
        </style:page-layout>
    </xsl:template>
    <xsl:template match="w:sectPr" mode="master-page">
        <!-- style:page-layout style:style-->

        <xsl:variable name="master-page-number">
            <xsl:number count="w:sectPr" from="/w:wordDocument/w:body" level="any" format="1"/>
        </xsl:variable>
        <xsl:if test="$master-page-number = '1'">
            <style:master-page style:next-style-name="Standard-1" style:page-layout-name="pm1" style:display-name="First Page" style:name="First_20_Page">
                <style:header>
                    <xsl:apply-templates select="w:hdr[@w:type='first']/child::*" mode="dispatch"/>
                </style:header>
                <style:footer>
                    <xsl:apply-templates select="w:ftr[@w:type='first']/child::*" mode="dispatch"/>
                </style:footer>
            </style:master-page>
        </xsl:if>
        <xsl:element name="style:master-page">
            <xsl:attribute name="style:name">Standard-<xsl:value-of select="$master-page-number"/>
            </xsl:attribute>
            <xsl:attribute name="style:page-layout-name">
                <xsl:value-of select="concat('pm', $master-page-number)"/>
            </xsl:attribute>

            <style:header>
                <xsl:apply-templates select="w:hdr[@w:type='odd']/child::*" mode="dispatch"/>
            </style:header>
            <style:header-left>
                <xsl:apply-templates select="w:hdr[@w:type='even']/child::*" mode="dispatch"/>
            </style:header-left>
            <style:footer>
                <xsl:apply-templates select="w:ftr[@w:type='odd']/child::*" mode="dispatch"/>
            </style:footer>
            <style:footer-left>
                <xsl:apply-templates select="w:ftr[@w:type='even']/child::*" mode="dispatch"/>
            </style:footer-left>

            <!-- Headers and footers-->
            <!--
            <style:header-style>
                <style:header-footer-properties>
                    <xsl:attribute name="fo:min-height"><xsl:call-template name="ConvertMeasure"><xsl:with-param name="value" select="concat(w:pgMar/@w:header,'twip')"/></xsl:call-template>cm</xsl:attribute>
                    <xsl:attribute name="fo:margin-bottom">0.792cm</xsl:attribute>
                    <xsl:attribute name="style:dynamic-spacing">true</xsl:attribute>
                </style:header-footer-properties>
            </style:header-style>
            <style:footer-style>
                <style:header-footer-properties>
                    <xsl:attribute name="fo:min-height"><xsl:call-template name="ConvertMeasure"><xsl:with-param name="value" select="concat(w:pgMar/@w:footer,'twip')"/></xsl:call-template>cm</xsl:attribute>
                    <xsl:attribute name="fo:margin-top">0.792cm</xsl:attribute>
                    <xsl:attribute name="style:dynamic-spacing">true</xsl:attribute>
                </style:header-footer-properties>
            </style:footer-style>
            -->

            <!-- any examples for w:titlePg usage? -->
            <xsl:if test="not(w:titlePg)">
                <xsl:apply-templates select="w:hdr[@w:type='odd']"/>
                <xsl:apply-templates select="w:hdr[@w:type='even']"/>
                <xsl:apply-templates select="w:ftr[@w:type='odd']"/>
                <xsl:apply-templates select="w:ftr[@w:type='even']"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template match="w:hdr">
        <!--
        <xsl:choose>
            <xsl:when test="@w:type = 'odd'">
                <style:header>
                    <xsl:apply-templates select="wx:pBdrGroup | w:p | w:tbl"/>
                </style:header>
            </xsl:when>
            <xsl:when test="@w:type = 'even'">
                <style:header>
                    <xsl:apply-templates select="wx:pBdrGroup | w:p | w:tbl"/>
                </style:header>
            </xsl:when>
        </xsl:choose>
        -->
    </xsl:template>
    <xsl:template match="w:ftr">
        <!--
        <xsl:choose>
            <xsl:when test="@w:type = 'odd'">
                <style:footer>
                    <xsl:apply-templates select="wx:pBdrGroup | w:p | w:tbl"/>
                </style:footer>
            </xsl:when>
            <xsl:when test="@w:type = 'even'">
                <style:footer-left>
                    <xsl:apply-templates select="wx:pBdrGroup | w:p | w:tbl"/>
                </style:footer-left>
            </xsl:when>
        </xsl:choose>
        -->
    </xsl:template>
    <xsl:template match="wx:pBdrGroup">
        <xsl:apply-templates mode="dispatch"/>
    </xsl:template>
    <!-- xsl:template name="convert-number-format">
        <xsl:param name="number-format"/>
        <xsl:choose>
            <xsl:when test="$number-format = 'decimal' or $number-format = 'decimal-half-width'">
                <xsl:attribute name="style:num-format">1</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'decimal-zero'">
                <xsl:attribute name="style:num-format">1</xsl:attribute>
                <xsl:attribute name="style:num-prefix">0</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'decimal-enclosed-fullstop'">
                <xsl:attribute name="style:num-format">1</xsl:attribute>
                <xsl:attribute name="style:num-prefix">.</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'decimal-enclosed-paren'">
                <xsl:attribute name="style:num-format">1</xsl:attribute>
                <xsl:attribute name="style:num-prefix">(</xsl:attribute>
                <xsl:attribute name="style:num-suffix">)</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'number-in-dash'">
                <xsl:attribute name="style:num-format">1</xsl:attribute>
                <xsl:attribute name="style:num-prefix">-</xsl:attribute>
                <xsl:attribute name="style:num-suffix">-</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'upper-letter'">
                <xsl:attribute name="style:num-format">A</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'lower-letter'">
                <xsl:attribute name="style:num-format">a</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'upper-roman'">
                <xsl:attribute name="style:num-format">I</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'lower-roman'">
                <xsl:attribute name="style:num-format">i</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'decimal-full-width' or $number-format = 'decimal-full-width2'">
                <xsl:attribute name="style:num-format">１, ２, ３, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'decimal-enclosed-circle-chinese' or $number-format = 'decimal-enclosed-circle'">
                <xsl:attribute name="style:num-format">①, ②, ③, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'ideograph-enclosed-circle'">
                <xsl:attribute name="style:num-format">一, 二, 三, ...</xsl:attribute>
                <xsl:attribute name="style:num-prefix">(</xsl:attribute>
                <xsl:attribute name="style:num-suffix">)</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'chinese-counting-thousand' or $number-format = 'ideograph-digital' or $number-format = 'japanese-counting' or $number-format = 'japanese-digital-ten-thousand' or $number-format = 'taiwanese-counting-thousand' or $number-format = 'taiwanese-counting' or $number-format = 'taiwanese-digital' or $number-format = 'chinese-counting' or $number-format = 'korean-digital2' or $number-format = 'chinese-not-impl'">
                <xsl:attribute name="style:num-format">一, 二, 三, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'chinese-legal-simplified'">
                <xsl:attribute name="style:num-format">壹, 贰, 叁, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'ideograph-legal-traditional'">
                <xsl:attribute name="style:num-format">壹, 貳, 參, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'ideograph-traditional'">
                <xsl:attribute name="style:num-format">甲, 乙, 丙, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'ideograph-zodiac'">
                <xsl:attribute name="style:num-format">子, 丑, 寅, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'japanese-legal'">
                <xsl:attribute name="style:num-format">壱, 弐, 参, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'aiueo-full-width'">
                <xsl:attribute name="style:num-format">ア, イ, ウ, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'aiueo'">
                <xsl:attribute name="style:num-format">ｱ, ｲ, ｳ, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'iroha-full-width'">
                <xsl:attribute name="style:num-format">イ, ロ, ハ, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'iroha'">
                <xsl:attribute name="style:num-format">ｲ, ﾛ, ﾊ, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'korean-digital' or $number-format = 'korean-counting' or $number-format = 'korean-legal'">
                <xsl:attribute name="style:num-format">일, 이, 삼, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'chosung'">
                <xsl:attribute name="style:num-format">ㄱ, ㄴ, ㄷ, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'ganada'">
                <xsl:attribute name="style:num-format">가, 나, 다, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'arabic-alpha' or $number-format = 'arabic-abjad'">
                <xsl:attribute name="style:num-format">أ, ب, ت, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'thai-letters' or $number-format = 'thai-numbers' or $number-format = 'thai-counting'">
                <xsl:attribute name="style:num-format">ก, ข, ฃ, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'hebrew-1'">
                <xsl:attribute name="style:num-format">א, י, ק, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$number-format = 'hebrew-2'">
                <xsl:attribute name="style:num-format">א, ב, ג, ...</xsl:attribute>
            </xsl:when>
            < ordinal, cardinal-text, ordinal-text, hex, chicago, bullet, ideograph-zodiac-traditional,
            vietnamese-counting, russian-lower, russian-upper, hindi-vowels, hindi-consonants, hindi-numbers, hindi-counting >
            <xsl:otherwise>
                <xsl:attribute name="style:num-format">Native Numbering</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template -->
</xsl:stylesheet>
