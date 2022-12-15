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
    <xsl:template name="ListStyles">
        <w:lists>
            <xsl:if test="descendant::text:list-level-style-image">
                <xsl:call-template name="PicLists"/>
            </xsl:if>
            <xsl:apply-templates select="office:styles/text:outline-style | office:styles/text:list-style | office:automatic-styles/text:list-style" mode="style"/>
            <xsl:for-each select="office:styles/text:outline-style | office:styles/text:list-style | office:automatic-styles/text:list-style">
                <w:list w:ilfo="{position()}">
                    <w:ilst w:val="{position()-1}"/>
                </w:list>
            </xsl:for-each>
        </w:lists>
    </xsl:template>
    <xsl:template match="text:list-style | text:outline-style" mode="style">
        <w:listDef w:listDefId="{position()-1}">
            <xsl:if test="name(..)='office:styles' and name()!='text:outline-style'">
                <w:styleLink w:val="{@style:name}"/>
            </xsl:if>
            <xsl:for-each select="text:list-level-style-number | text:list-level-style-bullet | text:list-level-style-image | text:outline-level-style">
                <xsl:if test="@text:level &lt; 10">
                    <w:lvl w:ilvl="{ @text:level - 1 }">
                        <xsl:if test="name()='text:outline-level-style'">
                            <xsl:variable name="headinglevel">
                                <xsl:value-of select="@text:level"/>
                            </xsl:variable>
                            <xsl:if test="/office:document/office:body//text:h[@text:level=$headinglevel and @text:style-name]">
                                <xsl:element name="w:pStyle">
                                    <xsl:attribute name="w:val"><xsl:value-of select="/office:document/office:body//text:h[@text:level=$headinglevel]/@text:style-name"/></xsl:attribute>
                                </xsl:element>
                            </xsl:if>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="@text:start-value">
                                <w:start w:val="{@text:start-value}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <w:start w:val="1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="@text:bullet-char">
                                <w:nfc w:val="23"/>
                            </xsl:when>
                            <xsl:when test="@style:num-format">
                                <xsl:call-template name="convert_list_number">
                                    <xsl:with-param name="number-format" select="@style:num-format"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="name()='text:list-level-style-image'">
                                <w:lvlText w:val="."/>
                                <w:lvlPicBulletId>
                                    <xsl:attribute name="w:val"><xsl:value-of select="count(preceding::text:list-level-style-image)"/></xsl:attribute>
                                </w:lvlPicBulletId>
                            </xsl:when>
                            <xsl:when test="@text:bullet-char">
                                <w:lvlText w:val="{@text:bullet-char}"/>
                            </xsl:when>
                            <xsl:when test="@text:display-levels and not(../@text:consecutive-numbering='true')">
                                <xsl:variable name="levelText">
                                    <xsl:call-template name="displaylevel">
                                        <xsl:with-param name="number" select="@text:display-levels"/>
                                        <xsl:with-param name="textlevel" select="@text:level"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <w:lvlText w:val="{concat(@style:num-prefix, substring-after($levelText, '.'), @style:num-suffix)}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <w:lvlText w:val="{concat(@style:num-prefix, '%', @text:level, @style:num-suffix)}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="style:list-level-properties/@fo:text-align = 'end'">
                                <w:lvlJc w:val="right"/>
                            </xsl:when>
                            <xsl:when test="style:list-level-properties/@fo:text-align = 'center'">
                                <w:lvlJc w:val="center"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <w:lvlJc w:val="left"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="style:list-level-properties/@text:space-before | style:list-level-properties/@text:min-label-width | style:list-level-properties/@text:min-label-distance">
                                <xsl:call-template name="list_position"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <w:suff w:val="Nothing"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates select="key('text-style',@text:style-name)/style:text-properties" mode="character"/>
                        <xsl:apply-templates select="style:text-properties" mode="character"/>
                    </w:lvl>
                </xsl:if>
            </xsl:for-each>
        </w:listDef>
    </xsl:template>
    <xsl:template match="text:list-style" mode="count">
        <xsl:value-of select="count(preceding::text:list-style | preceding::text:outline-style)+1"/>
    </xsl:template>
    <xsl:template match="text:unordered-list | text:ordered-list | text:list">
        <xsl:apply-templates select="text:unordered-list | text:ordered-list | text:list-item | text:list-header | text:list"/>
    </xsl:template>
    <xsl:template match="text:list-item | text:list-header">
        <xsl:apply-templates select="text:unordered-list | text:ordered-list | text:list |  text:p |  text:h"/>
    </xsl:template>
    <xsl:template name="displaylevel">
        <xsl:param name="number"/>
        <xsl:param name="textlevel"/>
        <xsl:if test="$number &gt; 1">
            <xsl:call-template name="displaylevel">
                <xsl:with-param name="number" select="$number -1"/>
                <xsl:with-param name="textlevel" select="number($textlevel)-1"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:value-of select="concat('.','%',$textlevel)"/>
    </xsl:template>
    <xsl:template name="list_position">
        <xsl:variable name="spacebefore">
            <xsl:choose>
                <xsl:when test="style:list-level-properties/@text:space-before">
                    <xsl:call-template name="convert2twip">
                        <xsl:with-param name="value" select="style:list-level-properties/@text:space-before"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="space2text">
            <xsl:choose>
                <xsl:when test="style:list-level-properties/@text:min-label-width">
                    <xsl:call-template name="convert2twip">
                        <xsl:with-param name="value" select="style:list-level-properties/@text:min-label-width"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="spacedistance">
            <xsl:choose>
                <xsl:when test="style:list-level-properties/@text:min-label-distance">
                    <xsl:call-template name="convert2twip">
                        <xsl:with-param name="value" select="style:list-level-properties/@text:min-label-distance"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$spacedistance='0' and $space2text='0'">
            <w:suff w:val="Nothing"/>
        </xsl:if>
        <w:pPr>
            <xsl:if test="$spacedistance!='0' or $space2text!='0'">
                <w:tabs>
                    <w:tab>
                        <xsl:attribute name="w:val">list</xsl:attribute>
                        <xsl:attribute name="w:pos"><xsl:choose><xsl:when test="number($spacedistance) &gt; number($space2text)"><xsl:value-of select="number($spacebefore)+number($spacedistance)+150"/></xsl:when><xsl:otherwise><xsl:value-of select="number($spacebefore)+number($space2text)+150"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <!-- Since SO MinSpaceDistance is width after number or bullet, MS TabSpaceAfter include the number or bullet width. So +150 -->
                    </w:tab>
                </w:tabs>
            </xsl:if>
            <w:ind w:left="{number($space2text)+number($spacebefore)}" w:hanging="{$space2text}"/>
            <!-- w:pos(MS TabSpaceAfter) = text:space-before + MAX(text:min-label-distance,text:min-label-width) + ( Symbol width ); w:left(MS IndentAt)= text:space-before + text:min-label-width; w:hanging(MS IndentAt - MS AlignedAt)=text:min-label-width -->
        </w:pPr>
    </xsl:template>
    <xsl:template name="PicLists">
        <xsl:for-each select="descendant::text:list-level-style-image">
            <w:listPicBullet w:listPicBulletId="{position()-1}">
                <w:pict>
                    <v:shape>
                        <xsl:variable name="Picwidth">
                            <xsl:call-template name="convert2pt">
                                <xsl:with-param name="value" select="style:list-level-properties/@fo:width"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="Picheight">
                            <xsl:call-template name="convert2pt">
                                <xsl:with-param name="value" select="style:list-level-properties/@fo:height"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="style"><xsl:value-of select="concat('width:', number($Picwidth*1), 'pt;height:', number($Picheight*1), 'pt')"/></xsl:attribute>
                        <xsl:attribute name="o:bullet">t</xsl:attribute>
                        <v:stroke joinstyle="miter"/>
                        <w:binData w:name="{concat('wordml://SOpicbullet', position(), '.gif')}">
                            <xsl:value-of select="office:binary-data"/>
                        </w:binData>
                        <v:imagedata src="{concat('wordml://SOpicbullet', position(), '.gif')}" o:title="{concat('SOpicbullet', position())}"/>
                    </v:shape>
                </w:pict>
            </w:listPicBullet>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="convert_list_number">
        <xsl:param name="number-format"/>
        <xsl:choose>
            <xsl:when test="$number-format = 'a'">
                <!-- nfcLCLetter: Lowercase alpha -->
                <w:nfc w:val="4"/>
            </xsl:when>
            <xsl:when test="$number-format = 'A'">
                <!-- nfcUCLetter: Uppercase alpha -->
                <w:nfc w:val="3"/>
            </xsl:when>
            <xsl:when test="$number-format = 'i'">
                <!-- nfcLCRoman: Lowercase roman -->
                <w:nfc w:val="2"/>
            </xsl:when>
            <xsl:when test="$number-format = 'I'">
                <!-- nfcUCRoman: Uppercase roman -->
                <w:nfc w:val="1"/>
            </xsl:when>
            <xsl:when test="$number-format = '1st'">
                <!-- nfcUCOrdinal: Ordinal indicator -->
                <w:nfc w:val="5"/>
            </xsl:when>
            <xsl:when test="$number-format = 'One'">
                <!-- nfcCardText: Cardinal -->
                <w:nfc w:val="6"/>
            </xsl:when>
            <xsl:when test="$number-format = 'First'">
                <!-- nfcOrdText: Ordinal -->
                <w:nfc w:val="7"/>
            </xsl:when>
            <xsl:when test="$number-format = '１, ２, ３, ...'">
                <!-- '１, ２, ３, ...' also seems: decimal-full-width2 -->
                <w:nfc w:val="14"/>
            </xsl:when>
            <xsl:when test="$number-format = '①, ②, ③, ...'">
                <w:nfc w:val="18"/>
            </xsl:when>
            <xsl:when test="$number-format = '一, 二, 三, ...'">
                <!-- '一, 二, 三, ...' also seems: ideograph-digital, japanese-counting, japanese-digital-ten-thousand,
                taiwanese-counting, taiwanese-counting-thousand, taiwanese-digital, chinese-counting, korean-digital2 -->
                <w:nfc w:val="10"/>
            </xsl:when>
            <xsl:when test="$number-format = '壹, 贰, 叁, ...'">
                <w:nfc w:val="38"/>
            </xsl:when>
            <xsl:when test="$number-format = '壹, 貳, 參, ...'">
                <w:nfc w:val="34"/>
            </xsl:when>
            <xsl:when test="$number-format = '甲, 乙, 丙, ...'">
                <w:nfc w:val="30"/>
            </xsl:when>
            <xsl:when test="$number-format = '子, 丑, 寅, ...'">
                <w:nfc w:val="31"/>
            </xsl:when>
            <xsl:when test="$number-format = '壱, 弐, 参, ...'">
                <w:nfc w:val="16"/>
            </xsl:when>
            <xsl:when test="$number-format = 'ア, イ, ウ, ...'">
                <w:nfc w:val="12"/>
            </xsl:when>
            <xsl:when test="$number-format = 'ｱ, ｲ, ｳ, ...'">
                <w:nfc w:val="20"/>
            </xsl:when>
            <xsl:when test="$number-format = 'イ, ロ, ハ, ...'">
                <w:nfc w:val="13"/>
            </xsl:when>
            <xsl:when test="$number-format = 'ｲ, ﾛ, ﾊ, ...'">
                <w:nfc w:val="21"/>
            </xsl:when>
            <xsl:when test="$number-format = '일, 이, 삼, ...'">
                <!-- '일, 이, 삼, ...' also seems: korean-counting -->
                <w:nfc w:val="41"/>
            </xsl:when>
            <xsl:when test="$number-format = 'ㄱ, ㄴ, ㄷ, ...' or $number-format = '㉠, ㉡, ㉢, ...'">
                <!-- mapping circled to uncircled -->
                <w:nfc w:val="25"/>
            </xsl:when>
            <xsl:when test='$number-format = "가, 나, 다, ..." or $number-format = "㉮, ㉯, ㉰, ..."'>
                <!-- mapping circled to uncircled -->
                <w:nfc w:val="24"/>
            </xsl:when>
            <xsl:when test="$number-format ='أ, ب, ت, ...'">
                <!-- 46.    arabic-alpha-->
                <w:nfc w:val="46"/>
            </xsl:when>
            <xsl:when test="$number-format = 'ก, ข, ฃ, ...'">
                <!--53. thai-letters not match well !-->
                <w:nfc w:val="53"/>
            </xsl:when>
            <xsl:when test="$number-format='א, י, ק, ...'">
                <!--45. hebrew-1-->
                <w:nfc w:val="45"/>
            </xsl:when>
            <xsl:when test="$number-format='א, ב, ג, ...'">
                <!--47. hebrew-2-->
                <w:nfc w:val="47"/>
            </xsl:when>
            <xsl:when test="string-length($number-format)=0">
                <w:nfc w:val="255"/>
            </xsl:when>
            <xsl:when test="$number-format = 'Native Numbering'">
                <xsl:variable name="locale" select="/office:document/office:meta/dc:language"/>
                <xsl:choose>
                    <xsl:when test="starts-with($locale, 'th-')">
                        <!-- for Thai, mapping thai-numbers, thai-counting to thai-numbers -->
                        <w:nfc w:val="54"/>
                    </xsl:when>
                    <xsl:when test="starts-with($locale, 'hi-')">
                        <!-- for Hindi, mapping hindi-vowels, hindi-consonants, hindi-counting to hindi-numbers -->
                        <w:nfc w:val="51"/>
                    </xsl:when>
                    <xsl:when test="starts-with($locale, 'ar-')">
                        <!-- for Arabic, mapping  arabic-abjad to arabic-alpha -->
                        <w:nfc w:val="45"/>
                    </xsl:when>
                    <xsl:when test="starts-with($locale, 'he-')">
                        <!-- for Hebrew, mapping hebrew-2 to  -->
                        <w:nfc w:val="46"/>
                    </xsl:when>
                    <xsl:when test="starts-with($locale, 'ru-')">
                        <!-- for Russian, mapping russian-upper to russian-lower -->
                        <w:nfc w:val="58"/>
                    </xsl:when>
                    <xsl:when test="starts-with($locale, 'vi-')">
                        <!-- for Vietnamese -->
                        <w:nfc w:val="56"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <!-- unsupported: hex, chicago, bullet, ideograph-zodiac-traditional,
            chinese-not-impl, korean-legal, none  -->
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
