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
    <xsl:template match="office:settings">
        <w:docPr>
            <w:displayBackgroundShape/>
            <xsl:variable name="view-settings" select="config:config-item-set[@config:name = 'view-settings']"/>
            <xsl:choose>
                <xsl:when test="$view-settings/config:config-item[@config:name = 'InBrowseMode'] = 'true'">
                    <w:view w:val="outline"/>
                </xsl:when>
                <xsl:otherwise>
                    <w:view w:val="print"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name="views" select="$view-settings/config:config-item-map-indexed[@config:name = 'Views']"/>
            <w:zoom w:percent="{$views/config:config-item-map-entry/config:config-item[@config:name = 'ZoomFactor']}">
                <xsl:variable name="zoom-type" select="$views/config:config-item-map-entry/config:config-item[@config:name = 'ZoomType']"/>
                <xsl:choose>
                    <xsl:when test="$zoom-type = '3'">
                        <xsl:attribute name="w:val">best-fit</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$zoom-type = '2'">
                        <xsl:attribute name="w:val">full-page</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$zoom-type = '1'">
                        <xsl:attribute name="w:val">text-fit</xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </w:zoom>
            <w:defaultTabStop>
                <xsl:attribute name="w:val"><xsl:call-template name="convert2twip"><xsl:with-param name="value" select="/office:document/office:styles/style:default-style[@style:family='paragraph']/style:paragraph-properties/@style:tab-stop-distance"/></xsl:call-template></xsl:attribute>
            </w:defaultTabStop>
            <xsl:if test="../office:master-styles/style:master-page/style:header-left">
                <w:evenAndOddHeaders/>
            </xsl:if>
            <xsl:apply-templates select="/office:document/office:styles/text:footnotes-configuration"/>
            <xsl:apply-templates select="/office:document/office:styles/text:endnotes-configuration"/>
            <!-- add the variables declaration in w:docpr G.Y.  Begin-->
            <xsl:if test="/office:document/office:body/office:text/text:variable-decls | /office:document/office:body/office:text/text:user-field-decls |/office:document/office:body/office:text/text:sequence-decls ">
                <xsl:call-template name="field_declare">
                    <xsl:with-param name="simple_field_variable_declares" select="/office:document/office:body/office:text/text:variable-decls"/>
                    <xsl:with-param name="user_field_variable_declares" select=" /office:document/office:body/office:text/text:user-field-decls"/>
                    <xsl:with-param name="field_sequence_declares" select="/office:document/office:body/office:text/text:sequence-decls"/>
                </xsl:call-template>
            </xsl:if>
            <!--add the variables declaration in w:docpr  G.Y. End-->
        </w:docPr>
    </xsl:template>
    <xsl:template match="text:footnotes-configuration">
        <xsl:param name="within-section"/>
        <w:footnotePr>
            <xsl:choose>
                <xsl:when test="@text:footnotes-position = 'document'">
                    <w:pos w:val="beneath-text"/>
                </xsl:when>
                <xsl:otherwise>
                    <w:pos w:val="page-bottom"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@text:start-value">
                <w:numStart w:val="{@text:start-value + 1}"/>
            </xsl:if>
            <xsl:if test="@style:num-format">
                <xsl:call-template name="convert-number-format">
                    <xsl:with-param name="number-format" select="@style:num-format"/>
                    <xsl:with-param name="number-prefix" select="@style:num-prefix"/>
                    <xsl:with-param name="number-suffix" select="@style:num-suffix"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="@text:start-numbering-at">
                <xsl:choose>
                    <xsl:when test="@text:start-numbering-at = 'document'">
                        <w:numRestart w:val="continuous"/>
                    </xsl:when>
                    <xsl:when test="@text:start-numbering-at = 'page'">
                        <w:numRestart w:val="each-page"/>
                    </xsl:when>
                    <!-- convert "chapter" to "section" -->
                    <xsl:otherwise>
                        <w:numRestart w:val="each-sect"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="$within-section != 'yes'">
                <!-- because in SO/OOo footnote-sep is defined within every page-layout, but in Word XML footnote separator
                is defined solely in docPr, so not trouble to find the proper footnote-sep definition. -->
                <w:footnote w:type="separator">
                    <w:p>
                        <w:r>
                            <w:separator/>
                        </w:r>
                    </w:p>
                </w:footnote>
                <w:footnote w:type="continuation-separator">
                    <w:p>
                        <w:r>
                            <w:continuationSeparator/>
                            <xsl:if test="text:footnote-continuation-notice-backward">
                                <w:t>
                                    <xsl:value-of select="text:footnote-continuation-notice-backward"/>
                                </w:t>
                            </xsl:if>
                        </w:r>
                    </w:p>
                </w:footnote>
                <xsl:if test="text:footnote-continuation-notice-forward">
                    <w:footnote w:type="continuation-notice">
                        <w:p>
                            <w:r>
                                <w:t>
                                    <xsl:value-of select="text:footnote-continuation-notice-forward"/>
                                </w:t>
                            </w:r>
                        </w:p>
                    </w:footnote>
                </xsl:if>
            </xsl:if>
        </w:footnotePr>
    </xsl:template>
    <xsl:template match="text:endnotes-configuration">
        <xsl:param name="within-section"/>
        <w:endnotePr>
            <w:pos w:val="sect-end"/>
            <xsl:if test="@text:start-value">
                <w:numStart w:val="{@text:start-value + 1}"/>
            </xsl:if>
            <xsl:if test="@style:num-format">
                <xsl:call-template name="convert-number-format">
                    <xsl:with-param name="number-format" select="@style:num-format"/>
                    <xsl:with-param name="number-prefix" select="@style:num-prefix"/>
                    <xsl:with-param name="number-suffix" select="@style:num-suffix"/>
                </xsl:call-template>
            </xsl:if>
            <w:numRestart w:val="each-sect"/>
            <xsl:if test="$within-section != 'yes'">
                <w:endnote w:type="separator">
                    <w:p>
                        <w:r>
                            <w:separator/>
                        </w:r>
                    </w:p>
                </w:endnote>
                <w:endnote w:type="continuation-separator">
                    <w:p>
                        <w:r>
                            <w:continuationSeparator/>
                        </w:r>
                    </w:p>
                </w:endnote>
            </xsl:if>
        </w:endnotePr>
    </xsl:template>
    <xsl:template name="convert-number-format">
        <xsl:param name="number-format"/>
        <xsl:param name="number-prefix"/>
        <xsl:param name="number-suffix"/>
        <xsl:choose>
            <xsl:when test="$number-format = '1' and normalize-space($number-prefix) = '0'">
                <w:numFmt w:val="decimal-zero"/>
            </xsl:when>
            <xsl:when test="$number-format = '1' and normalize-space($number-suffix) = '.'">
                <w:numFmt w:val="decimal-enclosed-fullstop"/>
            </xsl:when>
            <xsl:when test="$number-format = '1' and normalize-space($number-prefix) = '(' and normalize-space($number-prefix) = ')'">
                <w:numFmt w:val="decimal-enclosed-paren"/>
            </xsl:when>
            <xsl:when test="$number-format = '1' and normalize-space($number-prefix) = '-' and normalize-space($number-prefix) = '-'">
                <w:numFmt w:val="number-in-dash"/>
            </xsl:when>
            <xsl:when test="$number-format = '1'">
                <!-- '1' also seems: decimal-half-width -->
                <w:numFmt w:val="decimal"/>
            </xsl:when>
            <xsl:when test="$number-format = 'a'">
                <w:numFmt w:val="lower-letter"/>
            </xsl:when>
            <xsl:when test="$number-format = 'A'">
                <w:numFmt w:val="upper-letter"/>
            </xsl:when>
            <xsl:when test="$number-format = 'i'">
                <w:numFmt w:val="lower-roman"/>
            </xsl:when>
            <xsl:when test="$number-format = 'I'">
                <w:numFmt w:val="upper-roman"/>
            </xsl:when>
            <xsl:when test="$number-format = '１, ２, ３, ...'">
                <!-- '１, ２, ３, ...' also seems: decimal-full-width2 -->
                <w:numFmt w:val="decimal-full-width"/>
            </xsl:when>
            <xsl:when test="$number-format = '①, ②, ③, ...'">
                <!-- decimal-enclosed-circle seems same -->
                <w:numFmt w:val="decimal-enclosed-circle-chinese"/>
            </xsl:when>
            <xsl:when test="$number-format = '一, 二, 三, ...' and normalize-space($number-prefix) = '(' and normalize-space($number-suffix) = ')'">
                <w:numFmt w:val="ideograph-enclosed-circle"/>
            </xsl:when>
            <xsl:when test="$number-format = '一, 二, 三, ...'">
                <!-- '一, 二, 三, ...' also seems: ideograph-digital, japanese-counting, japanese-digital-ten-thousand,
                taiwanese-counting, taiwanese-counting-thousand, taiwanese-digital, chinese-counting, korean-digital2 -->
                <w:numFmt w:val="chinese-counting-thousand"/>
            </xsl:when>
            <xsl:when test="$number-format = '壹, 贰, 叁, ...'">
                <w:numFmt w:val="chinese-legal-simplified"/>
            </xsl:when>
            <xsl:when test="$number-format = '壹, 貳, 參, ...'">
                <w:numFmt w:val="ideograph-legal-traditional"/>
            </xsl:when>
            <xsl:when test="$number-format = '甲, 乙, 丙, ...'">
                <w:numFmt w:val="ideograph-traditional"/>
            </xsl:when>
            <xsl:when test="$number-format = '子, 丑, 寅, ...'">
                <w:numFmt w:val="ideograph-zodiac"/>
            </xsl:when>
            <xsl:when test="$number-format = '壱, 弐, 参, ...'">
                <w:numFmt w:val="japanese-legal"/>
            </xsl:when>
            <xsl:when test="$number-format = 'ア, イ, ウ, ...'">
                <w:numFmt w:val="aiueo-full-width"/>
            </xsl:when>
            <xsl:when test="$number-format = 'ｱ, ｲ, ｳ, ...'">
                <w:numFmt w:val="aiueo"/>
            </xsl:when>
            <xsl:when test="$number-format = 'イ, ロ, ハ, ...'">
                <w:numFmt w:val="iroha-full-width"/>
            </xsl:when>
            <xsl:when test="$number-format = 'ｲ, ﾛ, ﾊ, ...'">
                <w:numFmt w:val="iroha"/>
            </xsl:when>
            <xsl:when test="$number-format = '일, 이, 삼, ...'">
                <!-- '일, 이, 삼, ...' also seems: korean-counting -->
                <w:numFmt w:val="korean-digital"/>
            </xsl:when>
            <xsl:when test="$number-format = 'ㄱ, ㄴ, ㄷ, ...' or $number-format = '㉠, ㉡, ㉢, ...'">
                <!-- mapping circled to uncircled -->
                <w:numFmt w:val="chosung"/>
            </xsl:when>
            <xsl:when test="$number-format = '가, 나, 다, ...' or $number-format = '㉮, ㉯, ㉰, ...'">
                <!-- mapping circled to uncircled -->
                <w:numFmt w:val="ganada"/>
            </xsl:when>
            <xsl:when test="$number-format = 'أ, ب, ت, ...'">
                <w:numFmt w:val="arabic-alpha"/>
            </xsl:when>
            <xsl:when test="$number-format = 'ก, ข, ฃ, ...'">
                <w:numFmt w:val="thai-letters"/>
            </xsl:when>
            <xsl:when test="$number-format = 'א, י, ק, ...'">
                <w:numFmt w:val="hebrew-1"/>
            </xsl:when>
            <xsl:when test="$number-format = 'א, ב, ג, ...'">
                <w:numFmt w:val="hebrew-2"/>
            </xsl:when>
            <xsl:when test="$number-format = 'Native Numbering'">
                <xsl:variable name="locale" select="/office:document/office:meta/dc:language"/>
                <xsl:choose>
                    <xsl:when test="starts-with($locale, 'th-')">
                        <!-- for Thai, mapping thai-numbers, thai-counting to thai-letters -->
                        <w:numFmt w:val="thai-letters"/>
                    </xsl:when>
                    <xsl:when test="starts-with($locale, 'hi-')">
                        <!-- for Hindi, mapping hindi-vowels, hindi-consonants, hindi-counting to hindi-numbers -->
                        <w:numFmt w:val="hindi-numbers"/>
                    </xsl:when>
                    <xsl:when test="starts-with($locale, 'ar-')">
                        <!-- for Arabic, mapping  arabic-abjad to arabic-alpha -->
                        <w:numFmt w:val="arabic-alpha"/>
                    </xsl:when>
                    <xsl:when test="starts-with($locale, 'he-')">
                        <!-- for Hebrew, mapping hebrew-2 to  -->
                        <w:numFmt w:val="hebrew-1"/>
                    </xsl:when>
                    <xsl:when test="starts-with($locale, 'ru-')">
                        <!-- for Russian, mapping russian-upper to russian-lower -->
                        <w:numFmt w:val="russian-lower"/>
                    </xsl:when>
                    <xsl:when test="starts-with($locale, 'vi-')">
                        <!-- for Vietnamese -->
                        <w:numFmt w:val="vietnamese-counting"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <!-- unsupported: ordinal, cardinal-text, ordinal-text, hex, chicago, bullet, ideograph-zodiac-traditional,
            chinese-not-impl, korean-legal -->
            <xsl:otherwise>
                <w:numFmt w:val="decimal"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
