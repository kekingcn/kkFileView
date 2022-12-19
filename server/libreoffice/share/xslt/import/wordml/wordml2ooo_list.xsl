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
    <xsl:template match="w:listPr" mode="style">
        <xsl:variable name="currlistid" select="w:ilfo/@w:val"/>
        <xsl:variable name="currlist" select="."/>
        <xsl:variable name="rootlistid" select="/w:wordDocument/w:lists/w:list[@w:ilfo=$currlistid]/w:ilst/@w:val"/>
        <xsl:variable name="rootlist" select="/w:wordDocument/w:lists/w:listDef[@w:listDefId =$rootlistid ]"/>
        <xsl:if test="not(ancestor::w:p/preceding-sibling::w:p/w:pPr/w:listPr[1]/w:ilfo/@w:val= $currlistid) and $rootlist/w:lvl ">
            <xsl:element name="text:list-style">
                <xsl:attribute name="style:name">List<xsl:value-of select="count(preceding::w:listPr)"/>
                </xsl:attribute>
                <xsl:apply-templates select="$rootlist/w:lvl"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="w:lvl">
        <xsl:variable name="listtype">
            <xsl:choose>
                <xsl:when test="w:nfc/@w:val">
                    <xsl:value-of select="w:nfc/@w:val"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$listtype =23 and w:lvlPicBulletId">
                <!-- image characters. wym -->
                <xsl:element name="text:list-level-style-image">
                    <xsl:call-template name="list-styles-image"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$listtype =23">
                <!-- nfcBullet: Bullet character. glu -->
                <xsl:element name="text:list-level-style-bullet">
                    <xsl:call-template name="list-styles-common">
                        <xsl:with-param name="listtype" select="$listtype"/>
                        <xsl:with-param name="currlevel" select="number(@w:ilvl)+1"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- all kinds of numbering characters. glu :( -->
                <xsl:element name="text:list-level-style-number">
                    <xsl:call-template name="list-styles-common">
                        <xsl:with-param name="listtype" select="$listtype"/>
                        <xsl:with-param name="currlevel" select="number(@w:ilvl)+1"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="list-styles-common">
        <xsl:param name="listtype"/>
        <xsl:param name="currlevel"/>
        <xsl:variable name="startval" select="w:start/@w:val"/>
        <xsl:attribute name="text:level">
            <xsl:value-of select="$currlevel"/>
        </xsl:attribute>
        <xsl:choose>
            <xsl:when test="$listtype = 23">
                <!-- bullet character. glu -->
                <xsl:attribute name="text:style-name">Bullet_20_Symbols</xsl:attribute>
                <xsl:if test="not (contains(w:lvlText/@w:val,'%'))">
                    <xsl:attribute name="text:bullet-char">
                        <xsl:value-of select="w:lvlText/@w:val"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="contains(w:lvlText/@w:val,'%')">
                    <xsl:attribute name="text:bullet-char">
                        <xsl:value-of select=" '·' "/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:when>
            <xsl:when test="($listtype &gt;= 0) and ($listtype &lt; 60)">
                <xsl:attribute name="text:style-name">Numbering_20_Symbols</xsl:attribute>
                <xsl:if test="$startval">
                    <xsl:choose>
                        <xsl:when test="$startval &gt; 0">
                            <xsl:attribute name="text:start-value">
                                <xsl:value-of select="$startval"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="text:start-value">
                                <xsl:value-of select=" '1' "/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--xsl:attribute name="text:start-value"><xsl:value-of select="$startval"/></xsl:attribute -->
                </xsl:if>
                <xsl:attribute name="text:display-levels">
                    <xsl:value-of select="string-length(w:lvlText/@w:val) - string-length(translate(w:lvlText/@w:val,'%','') ) + 1"/>
                </xsl:attribute>
                <xsl:call-template name="nfc2numformat">
                    <xsl:with-param name="nfcvalue" select="$listtype"/>
                    <xsl:with-param name="prefix" select="substring-before(w:lvlText/@w:val, '%')"/>
                    <xsl:with-param name="suffix" select="substring-after(w:lvlText/@w:val, concat('%', $currlevel) )"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="text:style-name">Numbering_20_Symbols</xsl:attribute>
                <xsl:if test="$startval">
                    <xsl:choose>
                        <xsl:when test="$startval &gt; 0">
                            <xsl:attribute name="text:start-value">
                                <xsl:value-of select="$startval"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="text:start-value">
                                <xsl:value-of select=" '1' "/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- xsl:attribute name="text:start-value"><xsl:value-of select="$startval"/></xsl:attribute -->
                </xsl:if>
                <xsl:attribute name="text:display-levels">
                    <xsl:value-of select="string-length(w:lvlText/@w:val) - string-length(translate(w:lvlText/@w:val,'%','') ) + 1"/>
                </xsl:attribute>
                <!-- 'none' in Word 2003. wym -->
                <xsl:attribute name="style:num-format"/>
                <xsl:attribute name="style:num-prefix">
                    <xsl:value-of select="substring-before(w:lvlText/@w:val, '%')"/>
                </xsl:attribute>
                <xsl:attribute name="style:num-suffix">
                    <xsl:value-of select="substring-after(w:lvlText/@w:val, concat('%', $currlevel + 1) )"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:element name="style:list-level-properties">
            <xsl:choose>
                <xsl:when test="w:lvlJc/@w:val='right'">
                    <xsl:attribute name="fo:text-align">end</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:lvlJc/@w:val='center'">
                    <xsl:attribute name="fo:text-align">center</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="fo:text-align">start</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name="labelwidth">
                <xsl:choose>
                    <xsl:when test="w:pPr/w:ind/@w:hanging">
                        <xsl:call-template name="ConvertMeasure">
                            <xsl:with-param name="value" select="concat(w:pPr/w:ind/@w:hanging,'twip')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="w:pPr/w:ind/@w:first-line">
                        <xsl:call-template name="ConvertMeasure">
                            <xsl:with-param name="value" select="concat('-',w:pPr/w:ind/@w:first-line,'twip')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="leftwidth">
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="value" select="concat(w:pPr/w:ind/@w:left,'twip')"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:if test="w:pPr/w:ind/@w:left">
                <xsl:attribute name="text:space-before">
                    <xsl:choose>
                        <xsl:when test=" ( number($leftwidth)-number($labelwidth) ) &gt; 0">
                            <xsl:value-of select="concat(number($leftwidth)-number($labelwidth),'cm')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select=" '0cm' "/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="text:min-label-width">
                <xsl:choose>
                    <xsl:when test="$labelwidth &gt; 0">
                        <xsl:value-of select="concat($labelwidth,'cm')"/>
                    </xsl:when>
                    <xsl:otherwise>0cm</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <!-- In binary word translation, text:min-label-distance do not generate. So, the width of number-symbol will not effect the start position of text. But first line always start same position of second line, no indent. If text:min-label-distance generate, the look of list will change because of uncountable number-symbol's width, now use 0.25cm as default width-->
            <xsl:choose>
                <xsl:when test="w:suff/@w:val='Space'">
                    <xsl:attribute name="text:min-label-distance">0.20cm</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:pPr/w:tabs/w:tab/@w:pos">
                    <xsl:variable name="tabpos">
                        <xsl:call-template name="ConvertMeasure">
                            <xsl:with-param name="value" select="concat(w:pPr/w:tabs/w:tab/@w:pos,'twip')"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:if test="number($tabpos) &gt; (number($leftwidth)-number($labelwidth))">
                        <xsl:variable name="min-label-distance">
                            <xsl:choose>
                                <xsl:when test="number($tabpos)+number($labelwidth)-number($leftwidth)-0.25 &lt; 0">0</xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="number($tabpos)+number($labelwidth)-number($leftwidth)-0.25"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:attribute name="text:min-label-distance">
                            <xsl:value-of select="concat($min-label-distance,'cm')"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
            <!-- Find the node that corresponds to the level being processed. We can use this to determine the indentation to be used
            <xsl:variable name="currNode" select="/w:wordDocument/w:body//w:listPr[w:ilvl/@w:val = $currlevel][w:ilfo/@w:val = $currlist/w:ilfo/@w:val]"/>
            <xsl:choose>
                <xsl:when test="($currNode/wx:t/@wx:wTabBefore ) and ($currNode/wx:t/@wx:wTabAfter ) and (not($currNode/following-sibling::w:jc) or $currNode/following-sibling::w:jc/@w:val = 'left')">
                    <xsl:attribute name="text:space-before"><xsl:value-of select="(number($currNode/wx:t/@wx:wTabBefore)div 1440) * 2.54"/>cm</xsl:attribute>
                    <xsl:attribute name="text:min-label-distance"><xsl:value-of select="(number($currNode/wx:t/@wx:wTabAfter)div 1440) * 2.54"/>cm</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="text:space-before"><xsl:value-of select="((number(w:pPr/w:ind/@w:left)  div 1440) * 2.54) "/>cm</xsl:attribute>
                    <xsl:attribute name="text:min-label-distance"><xsl:value-of select="(number($currlist/wx:t/@wx:wTabAfter) div 1440) * 2.54"/>cm</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>-->
            <xsl:if test="w:rPr/w:rFonts">
                <xsl:if test="w:rPr/w:rFonts/@w:ascii">
                    <xsl:attribute name="style:font-name">
                        <xsl:value-of select="w:rPr/w:rFonts/@w:ascii"/>
                    </xsl:attribute>
                </xsl:if>
                <!-- in Oasis format the style:font-name-asian is not allowed to appear here -->
                <!--xsl:if test="w:rPr/w:rFonts/@w:fareast">
                    <xsl:attribute name="style:font-name-asian"><xsl:value-of select="w:rPr/w:rFonts/@w:fareast"/></xsl:attribute>
                </xsl:if -->
                <!--
                <xsl:if test="w:rPr/w:rFonts/@w:cs">
                    <xsl:attribute name="style:font-name-complex"><xsl:value-of select="w:rPr/w:rFonts/@w:cs"/></xsl:attribute>
                </xsl:if>
                -->
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="list-styles-image">
        <xsl:variable name="currlevel" select="number(@w:ilvl)"/>
        <xsl:attribute name="text:level">
            <xsl:value-of select="$currlevel+1"/>
        </xsl:attribute>
        <xsl:variable name="picid" select="w:lvlPicBulletId/@w:val"/>
        <office:binary-data>
            <xsl:value-of select="/descendant::w:lists/w:listPicBullet[@w:listPicBulletId=$picid]/w:pict/w:binData"/>
        </office:binary-data>
        <xsl:element name="style:list-level-properties">
            <xsl:attribute name="style:vertical-pos">middle</xsl:attribute>
            <xsl:attribute name="style:vertical-rel">line</xsl:attribute>
            <xsl:variable name="picsize" select="/descendant::w:lists/w:listPicBullet[@w:listPicBulletId=$picid]/w:pict/v:shape/@style"/>
            <xsl:attribute name="fo:text-align">left</xsl:attribute>
            <xsl:attribute name="fo:width">
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="value" select="substring-before(substring-after($picsize,'width:'), ';')"/>
                </xsl:call-template>
                <xsl:text>cm</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="fo:height">
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="value" select="substring-after($picsize,'height:')"/>
                </xsl:call-template>
                <xsl:text>cm</xsl:text>
            </xsl:attribute>
            <xsl:variable name="labelwidth">
                <xsl:choose>
                    <xsl:when test="w:pPr/w:ind/@w:hanging">
                        <xsl:call-template name="ConvertMeasure">
                            <xsl:with-param name="value" select="concat(w:pPr/w:ind/@w:hanging,'twip')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="w:pPr/w:ind/@w:first-line">
                        <xsl:call-template name="ConvertMeasure">
                            <xsl:with-param name="value" select="concat('-',w:pPr/w:ind/@w:first-line,'twip')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="leftwidth">
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="value" select="concat(w:pPr/w:ind/@w:left,'twip')"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="text:space-before">
                <xsl:choose>
                    <xsl:when test="(number($leftwidth)-number($labelwidth)) &gt; 0 ">
                        <xsl:value-of select="concat(number($leftwidth)-number($labelwidth),'cm')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select=" '0cm' "/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="text:min-label-width">
                <xsl:choose>
                    <xsl:when test="$labelwidth &gt; 0">
                        <xsl:value-of select="concat($labelwidth,'cm')"/>
                    </xsl:when>
                    <xsl:otherwise>0cm</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="w:suff/@w:val='Space'">
                    <xsl:attribute name="text:min-label-distance">0.20cm</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:pPr/w:tabs/w:tab/@w:pos">
                    <xsl:variable name="tabpos">
                        <xsl:call-template name="ConvertMeasure">
                            <xsl:with-param name="value" select="concat(w:pPr/w:tabs/w:tab/@w:pos,'twip')"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:if test="number($tabpos) &gt; (number($leftwidth)-number($labelwidth))">
                        <xsl:attribute name="text:min-label-distance">
                            <xsl:value-of select="concat(number($tabpos)+number($labelwidth)-number($leftwidth),'cm')"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!-- avoid listPr in textbox. :( glu -->
    <xsl:template match="w:p[w:pPr/w:listPr[w:ilvl and w:ilfo]]">
        <xsl:call-template name="genlist"/>
    </xsl:template>
    <xsl:template name="genlist">
        <xsl:variable name="currlistid" select="w:pPr/w:listPr/w:ilfo/@w:val"/>
        <xsl:variable name="currlistlvl" select="w:pPr/w:listPr/w:ilvl/@w:val"/>
        <xsl:variable name="firstoccur" select="/descendant::w:pPr[w:listPr/w:ilfo/@w:val = $currlistid][1]"/>
        <xsl:variable name="rootlistid" select="/w:wordDocument/w:lists/w:list[@w:ilfo=$currlistid]/w:ilst/@w:val"/>
        <xsl:variable name="rootlistname" select="/w:wordDocument/w:lists/w:listDef[@w:listDefId =$rootlistid ]/w:listStyleLink/@w:val"/>
        <xsl:element name="text:list">
            <xsl:attribute name="text:style-name">
                <xsl:choose>
                    <xsl:when test="string-length($rootlistname) &gt; 0">
                        <xsl:value-of select="translate($rootlistname,' ~`!@#$%^*(&#x26;)+/,;?&lt;&gt;{}[]:','_')"/>
                    </xsl:when>
                    <xsl:otherwise>List<xsl:value-of select="count($firstoccur/preceding::w:listPr)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="preceding::w:pPr/w:listPr/w:ilfo/@w:val = w:pPr/w:listPr/w:ilfo/@w:val">
                    <xsl:attribute name="text:continue-numbering">true</xsl:attribute>
                    <xsl:element name="text:list-item">
                        <xsl:call-template name="levels">
                            <xsl:with-param name="level" select="$currlistlvl"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="text:list-item">
                        <xsl:call-template name="levels">
                            <xsl:with-param name="level" select="$currlistlvl"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template name="levels">
        <xsl:param name="level"/>
        <xsl:choose>
            <xsl:when test="$level = '0'">
                <xsl:call-template name="process-common-paragraph"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="text:list">
                    <xsl:element name="text:list-item">
                        <xsl:call-template name="levels">
                            <xsl:with-param name="level" select="$level -1"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="w:style" mode="list">
        <xsl:variable name="listname" select="@w:styleId"/>
        <xsl:if test="/w:wordDocument/w:lists/w:listDef[w:styleLink/@w:val=$listname]">
            <text:list-style style:name="{$listname}">
                <xsl:apply-templates select="/w:wordDocument/w:lists/w:listDef[w:styleLink/@w:val=$listname]/w:lvl"/>
            </text:list-style>
        </xsl:if>
    </xsl:template>
    <!-- for create outline style in office:styles -->
    <xsl:template name="create-outline-style">
        <xsl:element name="text:outline-style">
            <xsl:call-template name="outline-level-style">
                <xsl:with-param name="level" select="1"/>
            </xsl:call-template>
            <xsl:call-template name="outline-level-style">
                <xsl:with-param name="level" select="2"/>
            </xsl:call-template>
            <xsl:call-template name="outline-level-style">
                <xsl:with-param name="level" select="3"/>
            </xsl:call-template>
            <xsl:call-template name="outline-level-style">
                <xsl:with-param name="level" select="4"/>
            </xsl:call-template>
            <xsl:call-template name="outline-level-style">
                <xsl:with-param name="level" select="5"/>
            </xsl:call-template>
            <xsl:call-template name="outline-level-style">
                <xsl:with-param name="level" select="6"/>
            </xsl:call-template>
            <xsl:call-template name="outline-level-style">
                <xsl:with-param name="level" select="7"/>
            </xsl:call-template>
            <xsl:call-template name="outline-level-style">
                <xsl:with-param name="level" select="8"/>
            </xsl:call-template>
            <xsl:call-template name="outline-level-style">
                <xsl:with-param name="level" select="9"/>
            </xsl:call-template>
            <xsl:call-template name="outline-level-style">
                <xsl:with-param name="level" select="10"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template name="outline-level-style">
        <xsl:param name="level"/>
        <xsl:element name="text:outline-level-style">
            <xsl:choose>
                <xsl:when test="(w:style[@w:type = 'paragraph' and w:pPr/w:outlineLvl/@w:val = $level -1 and w:pPr/w:listPr ]/w:pPr/w:listPr)[position()=1]">
                    <xsl:apply-templates select="(w:style[@w:type = 'paragraph' and w:pPr/w:outlineLvl/@w:val = $level -1 and w:pPr/w:listPr ]/w:pPr/w:listPr)[position()=1]" mode="outline">
                        <xsl:with-param name="outlinelevel" select="$level"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="text:level">
                        <xsl:value-of select="$level"/>
                    </xsl:attribute>
                    <xsl:attribute name="style:num-format"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="w:listPr" mode="outline">
        <xsl:param name="outlinelevel"/>
        <xsl:variable name="currlistid" select="w:ilfo/@w:val"/>
        <xsl:variable name="currlistlevel">
            <xsl:choose>
                <xsl:when test="w:ilvl">
                    <xsl:value-of select="w:ilvl/@w:val"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="rootlistid" select="/w:wordDocument/w:lists/w:list[@w:ilfo=$currlistid]/w:ilst/@w:val"/>
        <xsl:variable name="rootlist" select="/w:wordDocument/w:lists/w:listDef[@w:listDefId =$rootlistid ]"/>
        <xsl:if test="$rootlist/w:lvl[@w:ilvl=$currlistlevel]">
            <xsl:for-each select="$rootlist/w:lvl[@w:ilvl=$currlistlevel]">
                <xsl:call-template name="list-styles-common">
                    <xsl:with-param name="listtype">
                        <xsl:choose>
                            <xsl:when test="w:nfc/@w:val">
                                <xsl:value-of select="w:nfc/@w:val"/>
                            </xsl:when>
                            <xsl:otherwise>0</xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="currlevel" select="$outlinelevel"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="not($rootlist/w:lvl[@w:ilvl=$currlistlevel])">
            <xsl:attribute name="text:level">
                <xsl:value-of select="'1'"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template name="nfc2numformat">
        <xsl:param name="nfcvalue"/>
        <xsl:param name="prefix"/>
        <xsl:param name="suffix"/>
        <xsl:choose>
            <xsl:when test="$nfcvalue=0">
                <xsl:attribute name="style:num-format">1</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=1">
                <xsl:attribute name="style:num-format">I</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=2">
                <xsl:attribute name="style:num-format">i</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=3">
                <xsl:attribute name="style:num-format">A</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=4">
                <xsl:attribute name="style:num-format">a</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="style:num-format">1</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$nfcvalue=26">
                <xsl:attribute name="style:num-prefix">
                    <xsl:value-of select="$prefix"/>
                </xsl:attribute>
                <xsl:attribute name="style:num-suffix">
                    <xsl:value-of select="concat( '.' , $suffix )"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=27 or $nfcvalue=29">
                <xsl:attribute name="style:num-prefix">
                    <xsl:value-of select="concat( $prefix, '(' )"/>
                </xsl:attribute>
                <xsl:attribute name="style:num-suffix">
                    <xsl:value-of select="concat( ')' , $suffix )"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=57">
                <xsl:attribute name="style:num-prefix">
                    <xsl:value-of select="concat( $prefix, '- ' )"/>
                </xsl:attribute>
                <xsl:attribute name="style:num-suffix">
                    <xsl:value-of select="concat( ' -' , $suffix )"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="style:num-prefix">
                    <xsl:value-of select="$prefix"/>
                </xsl:attribute>
                <xsl:attribute name="style:num-suffix">
                    <xsl:value-of select="$suffix"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- xsl:template name="nfc2numformat">
        <xsl:param name="nfcvalue"/>
        <xsl:param name="prefix"/>
        <xsl:param name="suffix"/>
        <xsl:choose>
            <xsl:when test="$nfcvalue=0">
                <xsl:attribute name="style:num-format">1</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=1">
                <xsl:attribute name="style:num-format">I</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=2">
                <xsl:attribute name="style:num-format">i</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=3">
                <xsl:attribute name="style:num-format">A</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=4">
                <xsl:attribute name="style:num-format">a</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=10 or $nfcvalue=11 or $nfcvalue=17 or $nfcvalue=29 or $nfcvalue=33 or $nfcvalue=35 or $nfcvalue=36 or $nfcvalue=37 or $nfcvalue=39 or $nfcvalue=44">
                <xsl:attribute name="style:num-format">一, 二, 三, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=12">
                <xsl:attribute name="style:num-format">ア, イ, ウ, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=13">
                <xsl:attribute name="style:num-format">イ, ロ, ハ, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=14 or $nfcvalue=19">
                <xsl:attribute name="style:num-format">１, ２, ３, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=16">
                <xsl:attribute name="style:num-format">壱, 弐, 参, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=18 or $nfcvalue=28">
                <xsl:attribute name="style:num-format">①, ②, ③, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=20">
                <xsl:attribute name="style:num-format">ｱ, ｲ, ｳ, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=21">
                <xsl:attribute name="style:num-format">ｲ, ﾛ, ﾊ, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=24">
                <xsl:attribute name="style:num-format">가, 나, 다, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=25">
                <xsl:attribute name="style:num-format">ㄱ, ㄴ, ㄷ, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=30">
                <xsl:attribute name="style:num-format">甲, 乙, 丙, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=31">
                <xsl:attribute name="style:num-format">子, 丑, 寅, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=34">
                <xsl:attribute name="style:num-format">壹, 貳, 參, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=38">
                <xsl:attribute name="style:num-format">壹, 贰, 叁, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=41 or $nfcvalue=42 or $nfcvalue=43">
                <xsl:attribute name="style:num-format">일, 이, 삼, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=45 or $nfcvalue=47">
                <xsl:attribute name="style:num-format">א, ב, ג, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=46 or $nfcvalue=48">
                <xsl:attribute name="style:num-format">أ, ب, ت, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=53">
                <xsl:attribute name="style:num-format">ก, ข, ฃ, ...</xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue!=57 and $nfcvalue &gt; 48 and $nfcvalue &lt; 60">
                <xsl:attribute name="style:num-format">Native Numbering</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="style:num-format">1</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$nfcvalue=26">
                <xsl:attribute name="style:num-prefix"><xsl:value-of select="$prefix"/></xsl:attribute>
                <xsl:attribute name="style:num-suffix"><xsl:value-of select="concat( '.' , $suffix )"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=27 or $nfcvalue=29">
                <xsl:attribute name="style:num-prefix"><xsl:value-of select="concat( $prefix, '(' )"/></xsl:attribute>
                <xsl:attribute name="style:num-suffix"><xsl:value-of select="concat( ')' , $suffix )"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="$nfcvalue=57">
                <xsl:attribute name="style:num-prefix"><xsl:value-of select="concat( $prefix, '- ' )"/></xsl:attribute>
                <xsl:attribute name="style:num-suffix"><xsl:value-of select="concat( ' -' , $suffix )"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="style:num-prefix"><xsl:value-of select="$prefix"/></xsl:attribute>
                <xsl:attribute name="style:num-suffix"><xsl:value-of select="$suffix"/></xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template -->
</xsl:stylesheet>
