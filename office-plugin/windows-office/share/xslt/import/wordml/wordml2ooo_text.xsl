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
    <xsl:template name="create-default-paragraph-styles">
        <xsl:variable name="default-paragraph-style" select="w:style[@w:default = 'on' and @w:type = 'paragraph']"/>
        <xsl:if test="$default-paragraph-style">
            <style:default-style style:family="paragraph">
                <style:paragraph-properties>
                    <xsl:attribute name="style:tab-stop-distance">
                        <xsl:call-template name="ConvertMeasure">
                            <xsl:with-param name="value" select="concat(/w:wordDocument/w:docPr/w:defaultTabStop/@w:val,'twip')"/>
                        </xsl:call-template>cm</xsl:attribute>
                </style:paragraph-properties>
                <style:text-properties style:use-window-font-color="true">
                    <xsl:choose>
                        <xsl:when test="/w:wordDocument/w:fonts/w:defaultFonts">
                            <xsl:attribute name="style:font-name">
                                <xsl:value-of select="/w:wordDocument/w:fonts/w:defaultFonts/@w:ascii"/>
                            </xsl:attribute>
                            <xsl:attribute name="style:font-name-asian">
                                <xsl:value-of select="/w:wordDocument/w:fonts/w:defaultFonts/@w:fareast"/>
                            </xsl:attribute>
                            <xsl:attribute name="style:font-name-complex">
                                <xsl:value-of select="/w:wordDocument/w:fonts/w:defaultFonts/@w:cs"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:font-name">Times New Roman</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$default-paragraph-style/w:rPr/w:sz">
                        <xsl:attribute name="fo:font-size">
                            <xsl:value-of select="translate($default-paragraph-style/w:rPr/w:sz/@w:val,'Na','0') div 2"/>pt</xsl:attribute>
                        <xsl:attribute name="style:font-size-asian">
                            <xsl:value-of select="translate($default-paragraph-style/w:rPr/w:sz/@w:val,'Na','0') div 2"/>pt</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$default-paragraph-style/w:rPr/w:sz-cs">
                        <xsl:attribute name="style:font-size-complex">
                            <xsl:value-of select="$default-paragraph-style/w:rPr/w:sz-cs/@w:val div 2"/>pt</xsl:attribute>
                    </xsl:if>
                    <!-- if not defined default font size in Word, make it out as 10pt. glu -->
                    <xsl:if test="not($default-paragraph-style/w:rPr/w:sz or w:rPr/w:sz-cs)">
                        <xsl:attribute name="fo:font-size">10pt</xsl:attribute>
                        <xsl:attribute name="style:font-size-asian">10pt</xsl:attribute>
                        <xsl:attribute name="style:font-size-complex">10pt</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$default-paragraph-style/w:rPr/w:lang">
                        <xsl:if test="$default-paragraph-style/w:rPr/w:lang/@w:val">
                            <xsl:attribute name="fo:language">
                                <xsl:choose>
                                    <xsl:when test="contains($default-paragraph-style/w:rPr/w:lang/@w:val, '-')">
                                        <xsl:value-of select="substring-before( $default-paragraph-style/w:rPr/w:lang/@w:val, '-')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$default-paragraph-style/w:rPr/w:lang/@w:val"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <!--xsl:value-of select="substring-before( $default-paragraph-style/w:rPr/w:lang/@w:val, '-')"/ -->
                            </xsl:attribute>
                            <xsl:attribute name="fo:country">
                                <xsl:choose>
                                    <xsl:when test="contains($default-paragraph-style/w:rPr/w:lang/@w:val, '-')">
                                        <xsl:value-of select="substring-before( $default-paragraph-style/w:rPr/w:lang/@w:val, '-')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$default-paragraph-style/w:rPr/w:lang/@w:val"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <!--xsl:value-of select="substring-after( $default-paragraph-style/w:rPr/w:lang/@w:val, '-')"/-->
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$default-paragraph-style/w:rPr/w:lang/@w:fareast">
                            <xsl:attribute name="style:language-asian">
                                <xsl:choose>
                                    <xsl:when test="contains($default-paragraph-style/w:rPr/w:lang/@w:fareast, '-')">
                                        <xsl:value-of select="substring-before( $default-paragraph-style/w:rPr/w:lang/@w:fareast, '-')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$default-paragraph-style/w:rPr/w:lang/@w:fareast"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <!--xsl:value-of select="substring-before( $default-paragraph-style/w:rPr/w:lang/@w:fareast, '-')"/-->
                            </xsl:attribute>
                            <xsl:attribute name="style:country-asian">
                                <xsl:choose>
                                    <xsl:when test="contains($default-paragraph-style/w:rPr/w:lang/@w:fareast, '-')">
                                        <xsl:value-of select="substring-before( $default-paragraph-style/w:rPr/w:lang/@w:fareast, '-')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$default-paragraph-style/w:rPr/w:lang/@w:fareast"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <!--xsl:value-of select="substring-after( $default-paragraph-style/w:rPr/w:lang/@w:fareast, '-')"/ -->
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$default-paragraph-style/w:rPr/w:lang/@w:bidi">
                            <xsl:attribute name="style:language-complex">
                                <xsl:choose>
                                    <xsl:when test="contains( $default-paragraph-style/w:rPr/w:lang/@w:bidi, '-') ">
                                        <xsl:value-of select="substring-after( $default-paragraph-style/w:rPr/w:lang/@w:bidi, '-')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$default-paragraph-style/w:rPr/w:lang/@w:bidi "/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <!--xsl:value-of select="substring-before( $default-paragraph-style/w:rPr/w:lang/@w:bidi, '-')"/-->
                            </xsl:attribute>
                            <xsl:attribute name="style:country-complex">
                                <xsl:choose>
                                    <xsl:when test="contains($default-paragraph-style/w:rPr/w:lang/@w:bidi, '-')">
                                        <xsl:value-of select="substring-after( $default-paragraph-style/w:rPr/w:lang/@w:bidi, '-')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$default-paragraph-style/w:rPr/w:lang/@w:bidi"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <!-- xsl:value-of select="substring-after( $default-paragraph-style/w:rPr/w:lang/@w:bidi, '-')"/ -->
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                </style:text-properties>
            </style:default-style>
        </xsl:if>
    </xsl:template>
    <xsl:template name="create-default-text-styles">
        <style:style style:name="Footnote_20_Symbol" style:display-name="Footnote Symbol" style:family="text"/>
        <style:style style:name="Numbering_20_Symbols" style:display-name="Numbering Symbols" style:family="text"/>
        <style:style style:name="Bullet_20_Symbols" style:display-name="Bullet Symbols" style:family="text">
            <style:text-properties style:font-name="StarSymbol" fo:font-size="9pt" style:font-name-asian="StarSymbol" style:font-size-asian="9pt" style:font-name-complex="StarSymbol" style:font-size-complex="9pt"/>
        </style:style>
        <style:style style:name="Endnote_20_Symbol" style:display-name="Endnote Symbol" style:family="text"/>
        <style:style style:name="Footnote_20_anchor" style:display-name="Footnote anchor" style:family="text">
            <style:text-properties style:text-position="super 58%"/>
        </style:style>
    </xsl:template>
    <xsl:template match="w:p" mode="style">
        <xsl:variable name="paragraph-number">
            <xsl:number from="/w:wordDocument/w:body" level="any" count="w:p" format="1"/>
        </xsl:variable>
        <xsl:variable name="section-property-number" select="count(preceding::w:sectPr)"/>
        <xsl:variable name="last-section-property" select="preceding::w:pPr/w:sectPr[1]"/>
        <xsl:variable name="next-section-property" select="following::w:sectPr[1]"/>
        <style:style style:family="paragraph" style:name="P{$paragraph-number}">
            <xsl:choose>
              <xsl:when test="w:pPr/w:pStyle">
                <xsl:attribute name="style:parent-style-name">
                  <xsl:value-of select="concat('w',translate(w:pPr/w:pStyle/@w:val,' ~`!@#$%^*(&#x26;)+/,;?&lt;&gt;{}[]:','_'))" />
                </xsl:attribute>
              </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style:parent-style-name">wNormal</xsl:attribute>
            </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="not($next-section-property/w:type/@w:val = 'continuous') and  generate-id($last-section-property[last()]/following::w:p[1]) = generate-id(.) and not(ancestor::w:sectPr or ancestor::w:tbl)">
                    <xsl:attribute name="style:master-page-name">Standard-1<xsl:value-of select="$section-property-number + 1"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="$paragraph-number = 1">
                    <xsl:attribute name="style:master-page-name">First_20_Page</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <style:paragraph-properties>
                <xsl:apply-templates select="w:pPr"/>
            </style:paragraph-properties>
            <style:text-properties>
                <xsl:apply-templates select="w:pPr/w:rPr"/>
                <xsl:apply-templates select="w:rPr"/>
            </style:text-properties>
        </style:style>
        <xsl:if test="w:r/w:br/@w:type='page'">
            <style:style style:family="paragraph" style:name="P{$paragraph-number}page-break">
                <xsl:if test="w:pPr/w:pStyle">
                    <xsl:attribute name="style:parent-style-name">
                        <xsl:value-of select="concat('w',translate(w:pPr/w:pStyle/@w:val,' ~`!@#$%^*(&#x26;)+/,;?&lt;&gt;{}[]:','_'))"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="generate-id($last-section-property[last()]/following::w:p[1]) = generate-id(.) and not(ancestor::w:sectPr or ancestor::w:tbl)">
                        <xsl:attribute name="style:master-page-name">Standard-1<xsl:value-of select="$section-property-number + 1"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$paragraph-number = 1">
                        <xsl:attribute name="style:master-page-name">First_20_Page</xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <style:paragraph-properties fo:break-before="page">
                    <xsl:apply-templates select="w:pPr"/>
                </style:paragraph-properties>
            </style:style>
        </xsl:if>
        <xsl:if test="w:r/w:br/@w:type='column'">
            <style:style style:family="paragraph" style:name="P{$paragraph-number}column-break">
                <xsl:if test="w:pPr/w:pStyle">
                    <xsl:attribute name="style:parent-style-name">
                        <xsl:value-of select="concat('w',translate(w:pPr/w:pStyle/@w:val,' ~`!@#$%^*(&#x26;)+/,;?&lt;&gt;{}[]:','_'))"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="generate-id($last-section-property[last()]/following::w:p[1]) = generate-id(.) and not(ancestor::w:sectPr or ancestor::w:tbl)">
                        <xsl:attribute name="style:master-page-name">Standard-1<xsl:value-of select="$section-property-number + 1"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$paragraph-number = 1">
                        <xsl:attribute name="style:master-page-name">First_20_Page</xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <style:paragraph-properties fo:break-before="column">
                    <xsl:apply-templates select="w:pPr"/>
                </style:paragraph-properties>
            </style:style>
        </xsl:if>
    </xsl:template>
    <xsl:template match="w:pPr">
        <xsl:if test="w:ind/@w:left">
            <xsl:attribute name="fo:margin-left">
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="value" select="concat(w:ind/@w:left, 'twip')"/>
                </xsl:call-template>cm</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:ind/@w:right">
            <xsl:attribute name="fo:margin-right">
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="value" select="concat(w:ind/@w:right, 'twip')"/>
                </xsl:call-template>cm</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:ind/@w:first-line">
            <xsl:attribute name="fo:text-indent">
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="value" select="concat(w:ind/@w:first-line, 'twip')"/>
                </xsl:call-template>cm</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:ind/@w:hanging">
            <xsl:attribute name="fo:text-indent">
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="value" select="concat('-',w:ind/@w:hanging, 'twip')"/>
                </xsl:call-template>cm</xsl:attribute>
        </xsl:if>
        <!-- bi-directional support-->
        <xsl:if test="w:bidi">
            <xsl:choose>
                <xsl:when test="w:bidi/@w:val = 'off'">
                    <xsl:attribute name="fo:text-align">start</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="style:writing-mode">rl-tb</xsl:attribute>
                    <xsl:attribute name="fo:text-align">end</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="w:jc">
            <xsl:choose>
                <xsl:when test="w:jc/@w:val = 'center'">
                    <xsl:attribute name="fo:text-align">center</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:jc/@w:val = 'left'">
                    <xsl:choose>
                        <xsl:when test="w:bidi and not(w:bidi/@w:val = 'off')">
                            <xsl:attribute name="fo:text-align">end</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="fo:text-align">start</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="w:jc/@w:val = 'right'">
                    <xsl:choose>
                        <xsl:when test="w:bidi and not(w:bidi/@w:val = 'off')">
                            <xsl:attribute name="fo:text-align">start</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="fo:text-align">end</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="fo:text-align">justify</xsl:attribute>
                    <xsl:attribute name="style:justify-single-word">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="w:spacing">
            <xsl:choose>
                <xsl:when test="w:spacing/@w:line-rule = 'at-least'">
                    <xsl:attribute name="style:line-height-at-least">
                        <xsl:call-template name="ConvertMeasure">
                            <xsl:with-param name="value" select="concat(w:spacing/@w:line, 'twip')"/>
                        </xsl:call-template>cm</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:spacing/@w:line-rule = 'auto'">
                    <xsl:attribute name="fo:line-height">
                        <xsl:value-of select="round(w:spacing/@w:line div 240 * 100)"/>%</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:spacing/@w:line-rule = 'exact'">
                    <xsl:attribute name="fo:line-height">
                        <xsl:call-template name="ConvertMeasure">
                            <xsl:with-param name="value" select="concat(w:spacing/@w:line, 'twip')"/>
                        </xsl:call-template>cm</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="w:spacing/@w:before">
                <xsl:attribute name="fo:margin-top">
                    <xsl:call-template name="ConvertMeasure">
                        <xsl:with-param name="value" select="concat(w:spacing/@w:before, 'twip')"/>
                    </xsl:call-template>cm</xsl:attribute>
            </xsl:if>
            <xsl:if test="w:spacing/@w:after">
                <xsl:attribute name="fo:margin-bottom">
                    <xsl:call-template name="ConvertMeasure">
                        <xsl:with-param name="value" select="concat(w:spacing/@w:after, 'twip')"/>
                    </xsl:call-template>cm</xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="w:shd">
            <xsl:variable name="background-color">
                <xsl:choose>
                    <xsl:when test="string-length(w:shd/@w:fill) = 6">
                        <xsl:value-of select="concat('#', w:shd/@w:fill)"/>
                    </xsl:when>
                    <xsl:otherwise>#000000</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="w:shd/@w:val = 'solid'">
                    <xsl:attribute name="fo:background-color">
                        <xsl:value-of select="$background-color"/>
                    </xsl:attribute>
                </xsl:when>
                <!-- patterns are necessary in the future. glu -->
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="w:pageBreakBefore and not(w:pageBreakBefore/@w:val = 'off')">
            <xsl:attribute name="fo:break-before">page</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:pageBreakBefore and w:pageBreakBefore/@w:val = 'off'">
            <xsl:attribute name="fo:break-before">auto</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:keepNext">
            <xsl:attribute name="fo:keep-with-next">always</xsl:attribute>
        </xsl:if>
        <!--
        <xsl:if test="w:keepLines">
            <xsl:attribute name="style:break-inside">avoid</xsl:attribute>
        </xsl:if>
        -->
        <xsl:if test="w:widowControl='on'">
            <xsl:attribute name="fo:widows">2</xsl:attribute>
            <xsl:attribute name="fo:orphans">2</xsl:attribute>
        </xsl:if>
        <!--
        <xsl:if test="w:suppressAutoHyphens">
            <xsl:attribute name="fo:hyphenate">false</xsl:attribute>
        </xsl:if>
        -->
        <xsl:if test="w:kinsoku/@w:val='off'">
            <xsl:attribute name="style:line-break">normal</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:overflowPunct/@w:val='off'">
            <xsl:attribute name="style:punctuation-wrap">simple</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:autoSpaceDE/@w:val='off' or w:autoSpaceDN/@w:val='off'">
            <xsl:attribute name="style:text-autospace">none</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:textAlignment">
            <xsl:choose>
                <xsl:when test="w:textAlignment/@w:val='center'">
                    <xsl:attribute name="style:vertical-align">middle</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:textAlignment/@w:val='baseline'">
                    <xsl:attribute name="style:vertical-align">bottom</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="style:vertical-align">
                        <xsl:value-of select="w:textAlignment/@w:val"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="w:pBdr">
            <xsl:if test="w:pBdr/w:top">
                <xsl:call-template name="get-table-border">
                    <xsl:with-param name="style-pos" select="'top'"/>
                    <xsl:with-param name="style-position-0" select="w:pBdr/w:top"/>
                </xsl:call-template>
                <xsl:attribute name="fo:padding-top">
                    <xsl:call-template name="ConvertMeasure">
                        <xsl:with-param name="value" select="concat(w:pBdr/w:top/@w:space,'pt')"/>
                    </xsl:call-template>cm</xsl:attribute>
            </xsl:if>
            <xsl:if test="w:pBdr/w:left">
                <xsl:call-template name="get-table-border">
                    <xsl:with-param name="style-pos" select="'left'"/>
                    <xsl:with-param name="style-position-0" select="w:pBdr/w:left"/>
                </xsl:call-template>
                <xsl:attribute name="fo:padding-left">
                    <xsl:call-template name="ConvertMeasure">
                        <xsl:with-param name="value" select="concat(w:pBdr/w:left/@w:space,'pt')"/>
                    </xsl:call-template>cm</xsl:attribute>
            </xsl:if>
            <xsl:if test="w:pBdr/w:right">
                <xsl:call-template name="get-table-border">
                    <xsl:with-param name="style-pos" select="'right'"/>
                    <xsl:with-param name="style-position-0" select="w:pBdr/w:right"/>
                </xsl:call-template>
                <xsl:attribute name="fo:padding-right">
                    <xsl:call-template name="ConvertMeasure">
                        <xsl:with-param name="value" select="concat(w:pBdr/w:right/@w:space,'pt')"/>
                    </xsl:call-template>cm</xsl:attribute>
            </xsl:if>
            <xsl:if test="w:pBdr/w:bottom">
                <xsl:call-template name="get-table-border">
                    <xsl:with-param name="style-pos" select="'bottom'"/>
                    <xsl:with-param name="style-position-0" select="w:pBdr/w:bottom"/>
                </xsl:call-template>
                <xsl:attribute name="fo:padding-bottom">
                    <xsl:call-template name="ConvertMeasure">
                        <xsl:with-param name="value" select="concat(w:pBdr/w:bottom/@w:space,'pt')"/>
                    </xsl:call-template>cm</xsl:attribute>
            </xsl:if>
            <xsl:if test="w:pBdr/*/@w:shadow='on'">
                <xsl:attribute name="style:shadow">#000000 0.15cm 0.15cm</xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="w:snapToGrid/@w:val='off'">
            <xsl:attribute name="style:snap-to-layout-grid">false</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:tabs">
            <xsl:element name="style:tab-stops">
                <xsl:for-each select="w:tabs/w:tab">
                    <xsl:element name="style:tab-stop">
                        <xsl:attribute name="style:position">
                            <xsl:if test="@w:pos &lt; 0">
                                <xsl:message>
                                    We meet a negative w:pos:<xsl:value-of select="@w:pos"/>.
                                </xsl:message>
                                <xsl:value-of select="'0cm'"/>
                            </xsl:if>
                            <xsl:if test="not(@w:pos &lt; 0)">
                                <xsl:call-template name="ConvertMeasure">
                                    <xsl:with-param name="value" select="concat(@w:pos, 'twip')"/>
                                </xsl:call-template>cm</xsl:if>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="@w:val = 'decimal'">
                                <xsl:attribute name="style:type">char</xsl:attribute>
                                <xsl:attribute name="style:char">
                                    <xsl:value-of select="' '"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@w:val = 'left' or @w:val = 'right' or @w:val = 'center' ">
                                <xsl:attribute name="style:type">
                                    <xsl:value-of select="@w:val"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:type">char</xsl:attribute>
                                <xsl:attribute name="style:char">
                                    <xsl:value-of select="' '"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- Detect leader chars in tabs (rp) -->
                        <xsl:choose>
                            <xsl:when test="@w:leader = 'hyphen'">
                                <xsl:attribute name="style:leader-style">solid</xsl:attribute>
                                <xsl:attribute name="style:leader-text">-</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@w:leader = 'underscore'">
                                <xsl:attribute name="style:leader-style">solid</xsl:attribute>
                                <xsl:attribute name="style:leader-text">_</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@w:leader = 'dot'">
                                <xsl:attribute name="style:leader-style">dotted</xsl:attribute>
                                <xsl:attribute name="style:leader-text">.</xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <!-- end leader chars (rp) -->
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
        <xsl:apply-templates select="w:rPr" mode="paragraph-properties"/>
    </xsl:template>
    <xsl:template match="w:rPr" mode="style">
        <xsl:element name="style:style">
            <xsl:attribute name="style:name">T<xsl:number from="/w:wordDocument/w:body" level="any" count="w:rPr" format="1"/>
            </xsl:attribute>
            <xsl:attribute name="style:family">text</xsl:attribute>
            <xsl:if test="w:rStyle">
                <xsl:attribute name="style:parent-style-name">
                    <xsl:value-of select="concat('w',translate(w:rStyle/@w:val,' ~`!@#$%^*(&#x26;)+/,;?&lt;&gt;{}[]:','_'))"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:element name="style:text-properties">

                <xsl:apply-templates select="current()"/>
                <!-- <xsl:call-template name="text-properties"/> -->
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="w:rPr">
        <xsl:if test="w:rFonts">
            <xsl:if test="w:rFonts/@w:ascii">
                <xsl:attribute name="style:font-name">
                    <xsl:value-of select="w:rFonts/@w:ascii"/>
                </xsl:attribute>
                <xsl:if test="ancestor::w:body">
                    <xsl:attribute name="style:font-name-asian">
                        <xsl:value-of select="w:rFonts/@w:ascii"/>
                    </xsl:attribute>
                    <xsl:attribute name="style:font-name-complex">
                        <xsl:value-of select="w:rFonts/@w:ascii"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:if test="ancestor::w:styles">
                <xsl:if test="w:rFonts/@w:fareast">
                    <xsl:attribute name="style:font-name-asian">
                        <xsl:value-of select="w:rFonts/@w:fareast"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="w:rFonts/@w:cs">
                    <xsl:attribute name="style:font-name-complex">
                        <xsl:value-of select="w:rFonts/@w:cs"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:if test="parent::w:r">
            <xsl:if test="w:b">
                <xsl:attribute name="fo:font-weight">bold</xsl:attribute>
                <xsl:attribute name="style:font-weight-asian">bold</xsl:attribute>
            </xsl:if>
            <xsl:if test="w:b-cs">
                <xsl:attribute name="style:font-weight-complex">bold</xsl:attribute>
            </xsl:if>
            <xsl:if test="w:i">
                <xsl:attribute name="fo:font-style">italic</xsl:attribute>
                <xsl:attribute name="style:font-style-asian">italic</xsl:attribute>
            </xsl:if>
            <xsl:if test="w:i-cs">
                <xsl:attribute name="style:font-style-complex">italic</xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="w:caps">
            <xsl:attribute name="fo:text-transform">uppercase</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:smallCaps">
            <xsl:attribute name="fo:font-variant">small-caps</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:strike">
            <xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:dstrike">
            <xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
            <xsl:attribute name="style:text-line-through-type">double</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:outline">
            <xsl:attribute name="style:text-outline">true</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:shadow">
            <xsl:attribute name="fo:text-shadow">1pt 1pt</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:imprint">
            <xsl:attribute name="style:font-relief">engraved</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:emboss">
            <xsl:attribute name="style:font-relief">embossed</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:vanish">
            <xsl:attribute name="text:display">true</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:color[not(@w:val = 'auto')]">
            <xsl:attribute name="fo:color">#<xsl:value-of select="w:color/@w:val"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="w:spacing">
            <xsl:attribute name="fo:letter-spacing">
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="value" select="concat(w:spacing/@w:val,'twip')"/>
                </xsl:call-template>cm</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:w/@w:val">
            <xsl:attribute name="style:text-scale">
                <xsl:value-of select="concat(w:w/@w:val, '%')"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="w:vertAlign or w:position">
            <xsl:variable name="height">
                <xsl:choose>
                    <xsl:when test="w:vertAlign[@w:val = 'superscript' or @w:val = 'subscript']">58%</xsl:when>
                    <xsl:otherwise>100%</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="position">
                <xsl:choose>
                    <xsl:when test="w:position">
                        <!-- con't get font height easily, so just set w:val as percentage. glu -->
                        <xsl:value-of select="concat( w:position/@w:val, '%')"/>
                    </xsl:when>
                    <xsl:when test="w:vertAlign[@w:val = 'superscript']">super</xsl:when>
                    <xsl:when test="w:vertAlign[@w:val = 'subscript']">sub</xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="style:text-position">
                <xsl:value-of select="concat($position, ' ', $height)"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="w:sz">
            <xsl:attribute name="fo:font-size">
                <xsl:value-of select="translate(w:sz/@w:val,'Na','0') div 2"/>pt</xsl:attribute>
            <xsl:attribute name="style:font-size-asian">
                <xsl:value-of select="translate(w:sz/@w:val,'Na','0') div 2"/>pt</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:sz-cs">
            <xsl:attribute name="style:font-size-complex">
                <xsl:value-of select="w:sz-cs/@w:val div 2"/>pt</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:highlight">
            <xsl:choose>
                <xsl:when test="w:highlight/@w:val='black'">
                    <xsl:attribute name="fo:background-color">#000000</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='yellow'">
                    <xsl:attribute name="fo:background-color">#ffff00</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='green'">
                    <xsl:attribute name="fo:background-color">#00ff00</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='cyan'">
                    <xsl:attribute name="fo:background-color">#00ffff</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='magenta'">
                    <xsl:attribute name="fo:background-color">#ff00ff</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='blue'">
                    <xsl:attribute name="fo:background-color">#0000ff</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='red'">
                    <xsl:attribute name="fo:background-color">#ff0000</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='dark-blue'">
                    <xsl:attribute name="fo:background-color">#000080</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='dark-cyan'">
                    <xsl:attribute name="fo:background-color">#008080</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='dark-green'">
                    <xsl:attribute name="fo:background-color">#008000</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='dark-magenta'">
                    <xsl:attribute name="fo:background-color">#800080</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='dark-red'">
                    <xsl:attribute name="fo:background-color">#800000</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='dark-yellow'">
                    <xsl:attribute name="fo:background-color">#808000</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='dark-gray'">
                    <xsl:attribute name="fo:background-color">#808080</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:highlight/@w:val='light-gray'">
                    <xsl:attribute name="fo:background-color">#c0c0c0</xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="w:u">
            <xsl:if test="w:u/@w:val = 'thick' or contains(w:u/@w:val,'-heavy')">
                <xsl:attribute name="style:text-underline-width">bold</xsl:attribute>
            </xsl:if>
            <xsl:if test="w:u/@w:val = 'double' or contains(w:u/@w:val,'-double')">
                <xsl:attribute name="style:text-underline-type">double</xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="w:u/@w:val = 'words' or w:u/@w:val = 'single' or w:u/@w:val = 'thick' or w:u/@w:val = 'double'">
                    <xsl:attribute name="style:text-underline-style">solid</xsl:attribute>
                </xsl:when>
                <xsl:when test="contains(w:u/@w:val , 'dotted')">
                    <xsl:attribute name="style:text-underline-style">dotted</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:u/@w:val = 'dashed-heavy' or w:u/@w:val = 'dash'">
                    <xsl:attribute name="style:text-underline-style">dash</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:u/@w:val = 'dash-long' or w:u/@w:val = 'dash-long-heavy'">
                    <xsl:attribute name="style:text-underline-style">long-dash</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:u/@w:val = 'dash-dot-heavy' or w:u/@w:val = 'dot-dash'">
                    <xsl:attribute name="style:text-underline-style">dot-dash</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:u/@w:val = 'dash-dot-dot-heavy' or w:u/@w:val = 'dot-dot-dash'">
                    <xsl:attribute name="style:text-underline-style">dot-dot-dash</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:u/@w:val = 'wavy-heavy' or w:u/@w:val = 'wavy-double' or w:u/@w:val = 'wavy'">
                    <xsl:attribute name="style:text-underline-style">wave</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="string-length(style:text-underline-style) &gt; 0">
                        <xsl:attribute name="style:text-underline-style">
                            <xsl:value-of select="w:u/@w:val"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="w:u/@w:color and not(w:u/@w:color = 'auto')">
                <xsl:attribute name="style:text-underline-color">#<xsl:value-of select="w:u/@w:color"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="w:effect[@w:val = 'blink-background']">
            <xsl:attribute name="style:text-blinking">true</xsl:attribute>
        </xsl:if>
        <xsl:if test="w:shd and not(w:highlight)">
            <xsl:if test="string-length(w:shd/@w:fill) = 6">
                <xsl:attribute name="fo:background-color">#<xsl:value-of select="w:shd/@w:fill"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="w:em">
            <xsl:choose>
                <xsl:when test="w:em/@w:val = 'comma'">
                    <xsl:attribute name="style:text-emphasize">accent below</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:em/@w:val = 'under-dot'">
                    <xsl:attribute name="style:text-emphasize">disc below</xsl:attribute>
                </xsl:when>
                <xsl:when test="w:em/@w:val = 'dot' or w:em/@w:val = 'circle' ">
                    <xsl:attribute name="style:text-emphasize">
                        <xsl:value-of select=" concat(w:em/@w:val,' below') "/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="style:text-emphasize">none</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="w:lang">
            <xsl:if test="w:lang/@w:val">
                <xsl:attribute name="fo:language">
                    <xsl:choose>
                        <xsl:when test="contains(w:lang/@w:val, '-')">
                            <xsl:value-of select="substring-before( w:lang/@w:val, '-')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="w:lang/@w:val"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--xsl:value-of select="substring-before( w:lang/@w:val, '-')"/-->
                </xsl:attribute>
                <xsl:attribute name="fo:country">
                    <xsl:choose>
                        <xsl:when test="contains(w:lang/@w:val, '-')">
                            <xsl:value-of select="substring-before( w:lang/@w:val, '-')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="w:lang/@w:val"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--xsl:value-of select="substring-after( w:lang/@w:val, '-')"/-->
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="w:rPr" mode="paragraph-properties">
        <!--  right-to-left support-->
        <xsl:if test="w:rtl and not(w:rtl/@w:val = 'off')">
            <xsl:attribute name="style:writing-mode">rl-tb</xsl:attribute>
            <xsl:attribute name="fo:text-align">end</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="w:p">
        <xsl:choose>
            <!-- because word treats page breaks as separate tags, we must split some paragraphs up so that we can
            give the sub para a fo:break-before ="page" or column attribute. -->
            <xsl:when test="w:r[w:br/@w:type='page' or w:br/@w:type='column']">
                <xsl:call-template name="process-breaks-in-paragraph"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="process-common-paragraph"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="process-breaks-in-paragraph">
        <xsl:variable name="textruns-with-break" select="w:r[w:br/@w:type='page' or w:br/@w:type='column']"/>
        <xsl:call-template name="create-sub-paragraph">
            <xsl:with-param name="textruns" select="$textruns-with-break[1]/preceding-sibling::w:r"/>
        </xsl:call-template>
        <xsl:for-each select="$textruns-with-break">
            <xsl:variable name="break-position" select="position()"/>
            <xsl:call-template name="create-sub-paragraph">
                <!-- added following-sibling::w:fldSimple | following-sibling::w:hlink | following-sibling::aml:annotation to enable these elements to be processed when there are breaks happen  G.Yang -->
                <xsl:with-param name="textruns" select="following-sibling::w:r[not(w:br/@w:type='page' or w:br/@w:type='column') and (count(preceding::w:r[w:br/@w:type='page' or w:br/@w:type='column']) = $break-position)] | following-sibling::w:fldSimple[count(preceding::w:r[w:br/@w:type='page' or w:br/@w:type='column']) = $break-position] | following-sibling::w:hlink[count(preceding::w:r[w:br/@w:type='page' or w:br/@w:type='column']) = $break-position] | following-sibling::aml:annotation[count(preceding::w:r[w:br/@w:type='page' or w:br/@w:type='column']) = $break-position] "/>
                <xsl:with-param name="textruns-with-break" select="current()"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="create-sub-paragraph">
        <xsl:param name="textruns"/>
        <xsl:param name="textruns-with-break"/>
        <xsl:if test="$textruns or $textruns-with-break">
            <xsl:variable name="curr-num">
                <xsl:number from="/w:wordDocument/w:body" level="any" count="w:p" format="1"/>
            </xsl:variable>
            <text:p>
                <xsl:choose>
                    <xsl:when test="$textruns-with-break">
                        <xsl:attribute name="text:style-name">
                            <xsl:value-of select="concat('P',$curr-num,w:br/@w:type, '-break')"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="$textruns-with-break"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="text:style-name">
                            <xsl:value-of select="concat( 'P', $curr-num)"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="$textruns">
                    <xsl:apply-templates select="$textruns"/>
                </xsl:if>
            </text:p>
        </xsl:if>
    </xsl:template>
    <xsl:template name="process-common-paragraph">
        <xsl:variable name="heading-or-paragraph">
            <xsl:choose>
                <xsl:when test="key('heading-style', w:pPr/w:pStyle/@w:val)">text:h</xsl:when>
                <xsl:otherwise>text:p</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$heading-or-paragraph}">
            <xsl:if test="$heading-or-paragraph = 'text:h'">
                <xsl:attribute name="text:outline-level">
                    <xsl:value-of select="key('heading-style',w:pPr/w:pStyle/@w:val)/w:pPr/w:outlineLvl/@w:val + 1"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:variable name="curr-num">
                <xsl:number from="/w:wordDocument/w:body" level="any" count="w:p" format="1"/>
            </xsl:variable>
            <xsl:attribute name="text:style-name">
                <xsl:value-of select="concat( 'P', $curr-num)"/>
            </xsl:attribute>
            <xsl:variable name="bookmark-and-paragraph" select="preceding::aml:annotation[(@w:type = 'Word.Bookmark.Start' or @w:type = 'Word.Bookmark.End') and not(ancestor::w:p)] | preceding::w:p"/>
            <xsl:if test="count($bookmark-and-paragraph) &gt; 0 and name($bookmark-and-paragraph[last()]) = 'aml:annotation'">
                <xsl:call-template name="create-bookmark">
                    <xsl:with-param name="bookmark-and-paragraph" select="$bookmark-and-paragraph"/>
                    <xsl:with-param name="position" select="count($bookmark-and-paragraph)"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:apply-templates mode="dispatch"/>
            <xsl:if test="not(following::w:p)">
                <xsl:apply-templates select="following::aml:annotation[(@w:type = 'Word.Bookmark.Start' or @w:type = 'Word.Bookmark.End') and not(ancestor::w:p)]"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="create-bookmark">
        <xsl:param name="bookmark-and-paragraph"/>
        <xsl:param name="position"/>
        <xsl:choose>
            <xsl:when test="name($bookmark-and-paragraph[$position]) = 'aml:annotation'">
                <xsl:if test="$position &gt; 0">
                    <xsl:call-template name="create-bookmark">
                        <xsl:with-param name="bookmark-and-paragraph" select="$bookmark-and-paragraph"/>
                        <xsl:with-param name="position" select="$position - 1"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="output-bookmark">
                    <xsl:with-param name="bookmark-and-paragraph" select="$bookmark-and-paragraph"/>
                    <xsl:with-param name="position" select="$position + 1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="output-bookmark">
        <xsl:param name="bookmark-and-paragraph"/>
        <xsl:param name="position"/>
        <xsl:apply-templates select="$bookmark-and-paragraph[$position]"/>
        <xsl:if test="$position &lt; count($bookmark-and-paragraph)">
            <xsl:call-template name="output-bookmark">
                <xsl:with-param name="bookmark-and-paragraph" select="$bookmark-and-paragraph"/>
                <xsl:with-param name="position" select="$position + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- WordML contains multiple w:t within one w:r, so in Star Writer text:span should correspond to w:t glu -->
    <xsl:template match="w:r">
        <xsl:choose>
            <xsl:when test="(preceding-sibling::w:r) or (w:rPr)">
                <!-- add this condition to prevent from  printing the value of DATE, TIME, PRINTDATE, CREATEDATE, SAVEDATE, PAGE, NUMPAGES etc. fields  in-between w:fldchar begin and w:fldchar end   G.Yang.-->
                <xsl:if test="not (preceding-sibling::w:r/w:instrText[substring(normalize-space(.),1,4) = 'DATE'  or substring(normalize-space(.),1,4) = 'TIME'  or  substring(normalize-space(.),1,9) = 'PRINTDATE'  or substring(normalize-space(.),1,10) = 'CREATEDATE'  or substring(normalize-space(.),1,8) = 'SAVEDATE' or substring(normalize-space(.),1,4) = 'PAGE' or substring(normalize-space(.),1,8) = 'NUMPAGES'  or substring(normalize-space(.),1,8) = 'NUMWORDS' or substring(normalize-space(.),1,8) = 'NUMCHARS' or substring(normalize-space(.),1,6) = 'REVNUM' or substring(normalize-space(.),1,7) = 'AUTONUM'  or  substring(normalize-space(.),1,10) = 'AUTONUMLGL' or substring(normalize-space(.),1,10) = 'AUTONUMOUT' or substring(normalize-space(.),1,3) = 'SEQ' or substring(normalize-space(.),1,6) = 'AUTHOR' or substring(normalize-space(.),1,5) = 'TITLE'  or substring(normalize-space(.),1,7) = 'SUBJECT'  or substring(normalize-space(.),1,8) = 'KEYWORDS' or substring(normalize-space(.),1,6) = 'FILLIN'  or substring(normalize-space(.),1,11) = 'DOCPROPERTY' or substring(normalize-space(.),1,10) = 'MERGEFIELD' or substring(normalize-space(.),1,8) = 'MERGEREC' or substring(normalize-space(.),1,4) = 'NEXT' or substring( normalize-space(.),1,9) = 'HYPERLINK' or substring( normalize-space(.),1,3) = 'REF' ][1]  and (following-sibling::w:r/w:fldChar[@w:fldCharType='end'] or (  not(preceding-sibling::w:r/w:fldChar[@w:fldCharType='end'] ) and parent::w:p/following-sibling::w:p/w:r/w:fldChar[@w:fldCharType='end'])) )">
                    <text:span>
                        <xsl:choose>
                            <xsl:when test="w:rPr/w:rStyle">
                                <xsl:attribute name="text:style-name">
                                    <xsl:value-of select="concat('w', translate(w:rPr/w:rStyle/@w:val,' ~`!@#$%^*(&#x26;)+/,;?&lt;&gt;{}[]:','_'))"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="w:rPr">
                                <xsl:variable name="position">
                                    <xsl:number from="/w:wordDocument/w:body" level="any" count="w:rPr" format="1"/>
                                </xsl:variable>
                                <xsl:attribute name="text:style-name">T<xsl:value-of select="$position + 1"/>
                                </xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:apply-templates mode="dispatch"/>
                    </text:span>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <!-- add this condition to prevent from printing the value of DATE, TIME, PRINTDATE, CREATEDATE, SAVEDATE, PAGE, NUMPAGES, etc. fields in-between w:fldchar begin and w:fldchar end  G.Yang.-->
                <xsl:if test="not( preceding-sibling::w:r/w:instrText[substring(normalize-space(.),1,4) = 'DATE'  or substring(normalize-space(.),1,4) = 'TIME'  or  substring(normalize-space(.),1,9) = 'PRINTDATE'  or substring(normalize-space(.),1,10) = 'CREATEDATE'  or substring(normalize-space(.),1,8) = 'SAVEDATE' or substring(normalize-space(.),1,4) = 'PAGE' or substring(normalize-space(.),1,8) = 'NUMPAGES'  or substring(normalize-space(.),1,8) = 'NUMWORDS' or substring(normalize-space(.),1,8) = 'NUMCHARS' or substring(normalize-space(.),1,6) = 'REVNUM' or substring(normalize-space(.),1,7) = 'AUTONUM'  or  substring(normalize-space(.),1,10) = 'AUTONUMLGL' or substring(normalize-space(.),1,10) = 'AUTONUMOUT' or substring(normalize-space(.),1,3) = 'SEQ' or substring(normalize-space(.),1,6) = 'AUTHOR' or substring(normalize-space(.),1,5) = 'TITLE'  or substring(normalize-space(.),1,7) = 'SUBJECT'  or substring(normalize-space(.),1,8) = 'KEYWORDS' or substring(normalize-space(.),1,6) = 'FILLIN' or substring(normalize-space(.),1,11) = 'DOCPROPERTY' or substring(normalize-space(.),1,10) = 'MERGEFIELD' or substring(normalize-space(.),1,8) = 'MERGEREC' or substring(normalize-space(.),1,4) = 'NEXT' or substring( normalize-space(.),1,9) = 'HYPERLINK' or substring( normalize-space(.),1,3) = 'REF' ][1]  and (following-sibling::w:r/w:fldChar[@w:fldCharType='end'] or (  not(preceding-sibling::w:r/w:fldChar[@w:fldCharType='end'] ) and parent::w:p/following-sibling::w:p/w:r/w:fldChar[@w:fldCharType='end'])) )">
                    <xsl:apply-templates mode="dispatch"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="aml:annotation">
        <xsl:choose>
            <xsl:when test="@w:type = 'Word.Bookmark.Start'">
                <text:bookmark-start text:name="{@w:name}"/>
            </xsl:when>
            <xsl:when test="@w:type = 'Word.Bookmark.End'">
                <xsl:variable name="id" select="@aml:id"/>
                <text:bookmark-end text:name="{preceding::aml:annotation[@aml:id = $id]/@w:name}"/>
            </xsl:when>
            <xsl:when test="@w:type = 'Word.Comment'">
                <office:annotation office:display="true">
                    <dc:creator>
                        <xsl:value-of select="@aml:author"/>
                    </dc:creator>
                    <dc:date>
                        <xsl:value-of select="substring(@aml:createdate,1,10)"/>
                    </dc:date>
                    <xsl:apply-templates select="aml:content/w:p"/>
                </office:annotation>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="w:hlink">
        <xsl:element name="text:a">
            <xsl:attribute name="xlink:type">simple</xsl:attribute>
            <xsl:choose>
                <xsl:when test="@w:dest and @w:bookmark">
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="concat( @w:dest, concat('#', @w:bookmark) )"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@w:dest">
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="@w:dest"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@w:bookmark">
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="concat('#', @w:bookmark)"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="@w:target">
                <xsl:attribute name="office:target-frame-name">
                    <xsl:value-of select="@w:target"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="dispatch"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="w:t">
        <xsl:choose>
            <xsl:when test="string(.) = ' ' ">
                <xsl:element name="text:s"/>
            </xsl:when>
            <xsl:when test="contains(.,'  ')">
                <xsl:call-template name="replace-spaces">
                    <xsl:with-param name="curr-string" select="."/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="replace-spaces">
        <xsl:param name="curr-string"/>
        <xsl:if test="contains($curr-string,'  ')">
            <xsl:value-of select="substring-before($curr-string,'  ')"/>
            <text:s text:c="2"/>
            <xsl:variable name="next-string" select="substring-after($curr-string,'  ')"/>
            <xsl:choose>
                <xsl:when test="contains($next-string, '  ')">
                    <xsl:call-template name="replace-spaces">
                        <xsl:with-param name="curr-string" select="$next-string"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$next-string"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="w:tab">
        <xsl:element name="text:tab"/>
    </xsl:template>
    <xsl:template match="w:br">
        <xsl:if test="@w:type='text-wrapping' or not(@w:type)">
            <text:line-break/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="w:footnote">
        <xsl:variable name="footnote-position">
            <xsl:number from="/w:wordDocument/w:body" count="w:footnote" level="any"/>
        </xsl:variable>
        <text:note text:note-class="footnote" text:id="ftn{$footnote-position}">
            <text:note-citation/>
            <text:note-body>
                <xsl:apply-templates mode="dispatch"/>
            </text:note-body>
        </text:note>
    </xsl:template>
    <xsl:template match="w:endnote">
        <xsl:variable name="endnote-position">
            <xsl:number from="/w:wordDocument/w:body" count="w:endnote" level="any" format="1"/>
        </xsl:variable>
        <text:endnote text:id="edn{$endnote-position}">
            <text:endnote-body>
                <xsl:apply-templates mode="dispatch"/>
            </text:endnote-body>
        </text:endnote>
    </xsl:template>
</xsl:stylesheet>
