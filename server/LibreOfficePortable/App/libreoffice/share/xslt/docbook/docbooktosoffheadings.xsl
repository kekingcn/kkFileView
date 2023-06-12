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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:office="http://openoffice.org/2000/office" xmlns:style="http://openoffice.org/2000/style" xmlns:text="http://openoffice.org/2000/text" xmlns:table="http://openoffice.org/2000/table" xmlns:draw="http://openoffice.org/2000/drawing" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="http://openoffice.org/2000/meta" xmlns:number="http://openoffice.org/2000/datastyle" xmlns:svg="http://www.w3.org/2000/svg" xmlns:chart="http://openoffice.org/2000/chart" xmlns:dr3d="http://openoffice.org/2000/dr3d" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="http://openoffice.org/2000/form" xmlns:script="http://openoffice.org/2000/script" xmlns:config="http://openoffice.org/2001/config" office:class="text" office:version="1.0">
    <xsl:decimal-format name="staff" digit="D"/>
    <xsl:template match="/">
        <xsl:element name="office:document">
            <office:meta>
                <dc:title>
                    <xsl:value-of select="/article/articleinfo/title"/>
                </dc:title>
                <dc:description></dc:description>
                <dc:subject></dc:subject>
                <dc:date>
                    <xsl:value-of select="article/articleinfo/pubdate"/>
                </dc:date>
                <dc:language>
                    <xsl:value-of select="article/@lang"/>
                </dc:language>
                <meta:user-defined meta:name="Info 1"/>
                <meta:user-defined meta:name="Info 2"/>
                <meta:user-defined meta:name="Info 3"/>
                <meta:user-defined meta:name="Info 4"/>
            </office:meta>
            <office:font-decls>
                <style:font-decl style:name="Tahoma1" fo:font-family="Tahoma"/>
                <style:font-decl style:name="Thorndale" fo:font-family="Thorndale" style:font-family-generic="roman" style:font-pitch="variable"/>
                <style:font-decl style:name="Albany" fo:font-family="Albany" style:font-family-generic="swiss" style:font-pitch="variable"/>
                <style:font-decl style:name="Andale Sans UI" fo:font-family="'Andale Sans UI'" style:font-family-generic="system" style:font-pitch="variable"/>
                <style:font-decl style:name="MS Mincho" fo:font-family="'MS Mincho'" style:font-family-generic="system" style:font-pitch="variable"/>
                <style:font-decl style:name="Tahoma" fo:font-family="Tahoma" style:font-family-generic="system" style:font-pitch="variable"/>
            </office:font-decls>
            <office:styles>
                <style:default-style style:family="graphics">
                    <style:properties draw:shadow-offset-x="0.3cm" draw:shadow-offset-y="0.3cm" draw:start-line-spacing-horizontal="0.283cm" draw:start-line-spacing-vertical="0.283cm" draw:end-line-spacing-horizontal="0.283cm" draw:end-line-spacing-vertical="0.283cm" style:text-autospace="ideograph-alpha" style:line-break="strict" style:writing-mode="lr-tb" style:font-independent-line-spacing="false" style:use-window-font-color="true" fo:font-size="12pt" fo:language="en" fo:country="US" style:font-size-asian="12pt" style:language-asian="zxx" style:country-asian="none" style:font-size-complex="12pt" style:language-complex="zxx" style:country-complex="none">
                        <style:tab-stops/>
                    </style:properties>
                </style:default-style>
                <style:default-style style:family="paragraph">
                    <style:properties fo:hyphenation-ladder-count="no-limit" style:text-autospace="ideograph-alpha" style:punctuation-wrap="hanging" style:line-break="strict" style:tab-stop-distance="2.205cm" style:writing-mode="page" style:use-window-font-color="true" style:font-name="Thorndale" fo:font-size="12pt" fo:language="en" fo:country="US" style:font-name-asian="Andale Sans UI" style:font-size-asian="12pt" style:language-asian="zxx" style:country-asian="none" style:font-name-complex="Tahoma" style:font-size-complex="12pt" style:language-complex="zxx" style:country-complex="none" fo:hyphenate="false" fo:hyphenation-remain-char-count="2" fo:hyphenation-push-char-count="2"/>
                </style:default-style>
                <style:default-style style:family="table">
                    <style:properties table:border-model="separating"/>
                </style:default-style>
                <style:default-style style:family="table-row">
                    <style:properties fo:keep-together="always"/>
                </style:default-style>
                <style:style style:name="Standard" style:family="paragraph" style:class="text"/>
                <style:style style:name="Text body" style:family="paragraph" style:parent-style-name="Standard" style:class="text">
                    <style:properties fo:margin-top="0cm" fo:margin-bottom="0.212cm"/>
                </style:style>
                <style:style style:name="Heading" style:family="paragraph" style:parent-style-name="Standard" style:next-style-name="Text body" style:class="text">
                    <style:properties fo:margin-top="0.423cm" fo:margin-bottom="0.212cm" fo:keep-with-next="true" style:font-name="Albany" fo:font-size="14pt" style:font-name-asian="MS Mincho" style:font-size-asian="14pt" style:font-name-complex="Tahoma" style:font-size-complex="14pt"/>
                </style:style>
                <style:style style:name="Heading 1" style:family="paragraph" style:parent-style-name="Heading" style:next-style-name="Text body" style:class="text">
                    <style:properties fo:font-size="115%" fo:font-weight="bold" style:font-size-asian="115%" style:font-weight-asian="bold" style:font-size-complex="115%" style:font-weight-complex="bold"/>
                </style:style>
                <style:style style:name="Heading 2" style:family="paragraph" style:parent-style-name="Heading" style:next-style-name="Text body" style:class="text">
                    <style:properties fo:font-size="14pt" fo:font-style="italic" fo:font-weight="bold" style:font-size-asian="14pt" style:font-style-asian="italic" style:font-weight-asian="bold" style:font-size-complex="14pt" style:font-style-complex="italic" style:font-weight-complex="bold"/>
                </style:style>
                <style:style style:name="Heading 3" style:family="paragraph" style:parent-style-name="Heading" style:next-style-name="Text body" style:class="text">
                    <style:properties fo:font-size="14pt" fo:font-weight="bold" style:font-size-asian="14pt" style:font-weight-asian="bold" style:font-size-complex="14pt" style:font-weight-complex="bold"/>
                </style:style>
                <style:style style:name="Heading 4" style:family="paragraph" style:parent-style-name="Heading" style:next-style-name="Text body" style:class="text">
                    <style:properties fo:font-size="85%" fo:font-style="italic" fo:font-weight="bold" style:font-size-asian="85%" style:font-style-asian="italic" style:font-weight-asian="bold" style:font-size-complex="85%" style:font-style-complex="italic" style:font-weight-complex="bold"/>
                </style:style>
                <style:style style:name="List" style:family="paragraph" style:parent-style-name="Text body" style:class="list">
                    <style:properties style:font-name-complex="Tahoma1"/>
                </style:style>
                <style:style style:name="Table Contents" style:family="paragraph" style:parent-style-name="Text body" style:class="extra">
                    <style:properties text:number-lines="false" text:line-number="0"/>
                </style:style>
                <style:style style:name="Table Heading" style:family="paragraph" style:parent-style-name="Table Contents" style:class="extra">
                    <style:properties fo:text-align="center" style:justify-single-word="false" text:number-lines="false" text:line-number="0" fo:font-style="italic" fo:font-weight="bold" style:font-style-asian="italic" style:font-weight-asian="bold" style:font-style-complex="italic" style:font-weight-complex="bold"/>
                </style:style>
                <style:style style:name="Caption" style:family="paragraph" style:parent-style-name="Standard" style:class="extra">
                    <style:properties fo:margin-top="0.212cm" fo:margin-bottom="0.212cm" text:number-lines="false" text:line-number="0" fo:font-size="10pt" fo:font-style="italic" style:font-size-asian="10pt" style:font-style-asian="italic" style:font-size-complex="10pt" style:font-style-complex="italic"/>
                </style:style>
                <style:style style:name="Table" style:family="paragraph" style:parent-style-name="Caption" style:class="extra"/>
                <style:style style:name="Frame contents" style:family="paragraph" style:parent-style-name="Text body" style:class="extra"/>
                <style:style style:name="Footnote" style:family="paragraph" style:parent-style-name="Standard" style:class="extra">
                    <style:properties fo:margin-left="0.499cm" fo:margin-right="0cm" fo:text-indent="-0.499cm" style:auto-text-indent="false" text:number-lines="false" text:line-number="0" fo:font-size="10pt" style:font-size-asian="10pt" style:font-size-complex="10pt"/>
                </style:style>
                <style:style style:name="Index" style:family="paragraph" style:parent-style-name="Standard" style:class="index">
                    <style:properties text:number-lines="false" text:line-number="0" style:font-name-complex="Tahoma1"/>
                </style:style>
                <style:style style:name="Subtitle" style:family="paragraph" style:parent-style-name="Heading" style:next-style-name="Text body" style:class="chapter">
                    <style:properties fo:text-align="center" style:justify-single-word="false" fo:font-size="14pt" fo:font-style="italic" style:font-size-asian="14pt" style:font-style-asian="italic" style:font-size-complex="14pt" style:font-style-complex="italic"/>
                </style:style>
                <style:style style:name="Mediaobject" style:family="paragraph" style:class="text"/>
                <style:style style:name="Object" style:family="paragraph" style:parent-style-name="Caption" style:class="extra"/>
                <style:style style:name="Section Title" style:family="paragraph" style:next-style-name="Text body" style:master-page-name="">
                    <style:properties fo:line-height="200%" fo:text-transform="capitalize" fo:font-size="14pt"/>
                </style:style>
                <style:style style:name="Appendix Title" style:family="paragraph" style:next-style-name="Text body" style:master-page-name="">
                    <style:properties fo:line-height="200%" fo:text-transform="capitalize" fo:font-size="14pt"/>
                </style:style>
                <style:style style:name="Section1 Title" style:family="paragraph" style:next-style-name="Text body" style:master-page-name="">
                    <style:properties fo:line-height="200%" fo:text-transform="capitalize" fo:font-size="14pt"/>
                </style:style>
                <style:style style:name="Section2 Title" style:family="paragraph" style:next-style-name="Text body" style:master-page-name="">
                    <style:properties fo:line-height="200%" fo:text-transform="capitalize" fo:font-size="13pt"/>
                </style:style>
                <style:style style:name="Section3 Title" style:family="paragraph" style:next-style-name="Text body" style:master-page-name="">
                    <style:properties fo:line-height="200%" fo:text-transform="capitalize" fo:font-size="12pt"/>
                </style:style>
                <style:style style:name="Section4 Title" style:family="paragraph" style:next-style-name="Text body" style:master-page-name="">
                    <style:properties fo:line-height="200%" fo:text-transform="capitalize" fo:font-size="12pt"/>
                </style:style>
                <style:style style:name="Section5 Title" style:family="paragraph" style:next-style-name="Text body" style:master-page-name="">
                    <style:properties fo:line-height="200%" fo:text-transform="capitalize" fo:font-size="12pt"/>
                </style:style>
                <style:style style:name="Document Title" style:family="paragraph" style:parent-style-name="Standard" style:next-style-name="Document SubTitle">
                    <style:properties fo:text-align="center" style:justify-single-word="false" fo:font-size="20pt"/>
                </style:style>
                <style:style style:name="Document SubTitle" style:family="paragraph" style:parent-style-name="Document Title" style:next-style-name="Text body">
                    <style:properties fo:font-size="14pt"/>
                </style:style>
                <style:style style:name="Section SubTitle" style:family="paragraph" style:parent-style-name="Section Title"/>
                <style:style style:name="CopyRight" style:family="paragraph" style:parent-style-name="Text body"/>
                <style:style style:name="VarList Item" style:family="paragraph" style:parent-style-name="Text body" style:list-style-name="Var List" style:class="text">
                    <style:properties fo:margin-left="3cm" fo:margin-right="0cm" fo:text-indent="0cm" style:auto-text-indent="false">
                        <style:tab-stops>
                            <style:tab-stop style:position="0cm"/>
                        </style:tab-stops>
                    </style:properties>
                </style:style>
                <style:style style:name="VarList Term" style:family="paragraph" style:parent-style-name="Text body" style:list-style-name="Var List" style:class="text">
                    <style:properties fo:margin-left="1cm" fo:margin-right="0cm" fo:text-indent="-4.5cm" style:auto-text-indent="false">
                        <style:tab-stops>
                            <style:tab-stop style:position="0cm"/>
                        </style:tab-stops>
                    </style:properties>
                </style:style>
                <style:style style:name="Footnote Symbol" style:family="text"/>
                <style:style style:name="Numbering Symbols" style:family="text"/>
                <style:style style:name="Bullet Symbols" style:family="text">
                    <style:properties fo:font-size="9pt" style:font-size-asian="9pt" style:font-size-complex="9pt"/>
                </style:style>
                <style:style style:name="Internet link" style:family="text">
                    <style:properties fo:color="#000080" style:text-underline-color="font-color" style:text-underline="single"/>
                </style:style>
                <style:style style:name="Endnote Symbol" style:family="text"/>
                <style:style style:name="Emphasis" style:family="text">
                    <style:properties fo:font-style="italic" style:font-style-asian="italic" style:font-style-complex="italic"/>
                </style:style>
                <style:style style:name="Source Text" style:family="text"/>
                <style:style style:name="Highlight" style:family="text">
                    <style:properties style:text-background-color="#fff000"/>
                </style:style>
                <style:style style:name="KeyCap" style:family="text">
                    <style:properties fo:font-weight="bold"/>
                </style:style>
                <style:style style:name="Command" style:family="text">
                    <style:properties fo:font-weight="bold"/>
                </style:style>
                <style:style style:name="Application" style:family="text">
                    <style:properties fo:font-weight="bold"/>
                </style:style>
                <style:style style:name="FileName" style:family="text">
                    <style:properties fo:font-weight="bold"/>
                </style:style>
                <style:style style:name="SuperScript" style:family="text">
                    <style:properties style:text-position="super 58%"/>
                </style:style>
                <style:style style:name="SubScript" style:family="text">
                    <style:properties style:text-position="sub 58%"/>
                </style:style>
                <style:style style:name="SystemItem" style:family="text">
                    <style:properties fo:font-weight="bold"/>
                </style:style>
                <style:style style:name="ComputerOutput" style:family="text">
                    <style:properties fo:font-weight="bold"/>
                </style:style>
                <style:style style:name="KeyCombo" style:family="text">
                    <style:properties fo:font-weight="bold"/>
                </style:style>
                <style:style style:name="KeySym" style:family="text">
                    <style:properties fo:font-weight="bold"/>
                </style:style>
                <style:style style:name="GuiMenu" style:family="text">
                    <style:properties fo:color="#000fff" fo:font-style="italic"/>
                </style:style>
                <style:style style:name="GuiSubMenu" style:family="text">
                    <style:properties fo:color="#ff9966" fo:font-style="italic"/>
                </style:style>
                <style:style style:name="GuiButton" style:family="text">
                    <style:properties fo:color="#00f0ff" fo:font-style="italic"/>
                </style:style>
                <style:style style:name="GuiMenuItem" style:family="text">
                    <style:properties fo:color="#00ffff" fo:font-style="italic"/>
                </style:style>
                <style:style style:name="GuiLabel" style:family="text">
                    <style:properties fo:color="#00777f" fo:font-style="italic"/>
                </style:style>
                <style:style style:name="Frame" style:family="graphics">
                    <style:properties text:anchor-type="paragraph" svg:x="0cm" svg:y="0cm" fo:margin-left="0.201cm" fo:margin-right="0.201cm" fo:margin-top="0.201cm" fo:margin-bottom="0.201cm" style:wrap="parallel" style:number-wrapped-paragraphs="no-limit" style:wrap-contour="false" style:vertical-pos="top" style:vertical-rel="paragraph-content" style:horizontal-pos="center" style:horizontal-rel="paragraph-content" fo:padding="0.15cm" fo:border="0.002cm solid #000000"/>
                </style:style>
                <text:outline-style>
                    <text:outline-level-style text:level="1" style:num-format=""/>
                    <text:outline-level-style text:level="2" style:num-format=""/>
                    <text:outline-level-style text:level="3" style:num-format=""/>
                    <text:outline-level-style text:level="4" style:num-format=""/>
                    <text:outline-level-style text:level="5" style:num-format=""/>
                    <text:outline-level-style text:level="6" style:num-format=""/>
                    <text:outline-level-style text:level="7" style:num-format=""/>
                    <text:outline-level-style text:level="8" style:num-format=""/>
                    <text:outline-level-style text:level="9" style:num-format=""/>
                    <text:outline-level-style text:level="10" style:num-format=""/>
                </text:outline-style>
                <text:list-style style:name="Ordered List">
                    <text:list-level-style-number text:level="1" text:style-name="Numbering Symbols" style:num-suffix="." style:num-format="1">
                        <style:properties text:min-label-width="0.499cm"/>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="2" style:num-suffix="." style:num-format="1">
                        <style:properties text:space-before="0.501cm" text:min-label-width="0.499cm"/>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="3" style:num-suffix="." style:num-format="1">
                        <style:properties text:space-before="1cm" text:min-label-width="0.499cm"/>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="4" style:num-suffix="." style:num-format="1">
                        <style:properties text:space-before="1.501cm" text:min-label-width="0.499cm"/>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="5" style:num-suffix="." style:num-format="1">
                        <style:properties text:space-before="2cm" text:min-label-width="0.499cm"/>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="6" style:num-suffix="." style:num-format="1">
                        <style:properties text:space-before="2.501cm" text:min-label-width="0.499cm"/>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="7" style:num-suffix="." style:num-format="1">
                        <style:properties text:space-before="3.001cm" text:min-label-width="0.499cm"/>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="8" style:num-suffix="." style:num-format="1">
                        <style:properties text:space-before="3.502cm" text:min-label-width="0.499cm"/>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="9" style:num-suffix="." style:num-format="1">
                        <style:properties text:space-before="4.001cm" text:min-label-width="0.499cm"/>
                    </text:list-level-style-number>
                    <text:list-level-style-number text:level="10" style:num-suffix="." style:num-format="1">
                        <style:properties text:space-before="4.502cm" text:min-label-width="0.499cm"/>
                    </text:list-level-style-number>
                </text:list-style>
                <text:list-style style:name="UnOrdered List">
                    <text:list-level-style-bullet text:level="1" text:style-name="Bullet Symbols" text:bullet-char="•">
                        <style:properties text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="2" text:style-name="Bullet Symbols" text:bullet-char="•">
                        <style:properties text:space-before="0.501cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="3" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="1cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="4" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="1.501cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="5" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="2cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="6" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="2.501cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="7" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="3.001cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="8" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="3.502cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="9" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="4.001cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="10" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="4.502cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                </text:list-style>
                <text:list-style style:name="Var List">
                    <text:list-level-style-bullet text:level="1" text:style-name="Bullet Symbols" text:bullet-char="•">
                        <style:properties text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="2" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="0.501cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="3" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="1cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="4" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="1.501cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="5" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="2cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="6" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="2.501cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="7" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="3.001cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="8" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="3.502cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="9" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="4.001cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                    <text:list-level-style-bullet text:level="10" text:style-name="Bullet Symbols" style:num-suffix="." text:bullet-char="•">
                        <style:properties text:space-before="4.502cm" text:min-label-width="0.499cm" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
                    </text:list-level-style-bullet>
                </text:list-style>
                <text:footnotes-configuration text:citation-style-name="Footnote Symbol" style:num-format="1" text:start-value="0" text:footnotes-position="page" text:start-numbering-at="page"/>
                <text:endnotes-configuration text:citation-style-name="Endnote Symbol" text:master-page-name="Endnote" style:num-format="1" text:start-value="0"/>
                <text:linenumbering-configuration text:number-lines="false" text:offset="0.499cm" style:num-format="1" text:number-position="left" text:increment="5"/>
            </office:styles>
            <office:automatic-styles>
                <style:page-master style:name="pm1">
                    <style:properties fo:page-width="20.999cm" fo:page-height="29.699cm" style:num-format="1" style:print-orientation="portrait" fo:margin-top="2.54cm" fo:margin-bottom="2.54cm" fo:margin-left="3.175cm" fo:margin-right="3.175cm" style:writing-mode="lr-tb" style:footnote-max-height="0cm">
                        <style:footnote-sep style:width="0.018cm" style:distance-before-sep="0.101cm" style:distance-after-sep="0.101cm" style:adjustment="left" style:rel-width="25%" style:color="#000000"/>
                    </style:properties>
                    <style:header-style/>
                    <style:footer-style/>
                </style:page-master>
                <style:page-master style:name="pm2">
                    <style:properties fo:page-width="20.999cm" fo:page-height="29.699cm" style:num-format="1" style:print-orientation="portrait" fo:margin-top="2cm" fo:margin-bottom="2cm" fo:margin-left="2cm" fo:margin-right="2cm" style:writing-mode="lr-tb" style:footnote-max-height="0cm">
                        <style:footnote-sep style:adjustment="left" style:rel-width="25%" style:color="#000000"/>
                    </style:properties>
                    <style:header-style/>
                    <style:footer-style/>
                </style:page-master>
            </office:automatic-styles>
            <office:master-styles>
                <style:master-page style:name="Standard" style:page-master-name="pm1"/>
                <style:master-page style:name="Endnote" style:page-master-name="pm2"/>
            </office:master-styles>
            <office:body>
                <xsl:apply-templates/>
            </office:body>
        </xsl:element>
    </xsl:template>

    <xsl:template match="subtitle">
        <xsl:choose>
            <xsl:when test="parent::table">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="parent::informaltable">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="text:p">
                    <xsl:attribute name="text:style-name">Section SubTitle</xsl:attribute>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>




    <xsl:template match="title">
        <xsl:choose>
            <xsl:when test="parent::figure"></xsl:when>
            <xsl:when test="parent::table"></xsl:when>
            <xsl:when test="parent::sect1"></xsl:when>
            <xsl:when test="parent::sect2"></xsl:when>
            <xsl:when test="parent::sect3"></xsl:when>
            <xsl:when test="parent::sect4"></xsl:when>
            <xsl:when test="parent::sect5"></xsl:when>
            <xsl:when test="parent::informaltable">
                <xsl:apply-templates/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:element name="text:p">
                    <xsl:choose>

                        <xsl:when test="parent::appendix">
                            <xsl:attribute name="text:style-name">Appendix Title</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="articleinfo">
        <xsl:element name="text:section">
            <xsl:attribute name="text:style-name">ArticleInfo</xsl:attribute>
            <xsl:attribute name="text:name">ArticleInfo</xsl:attribute>
            <xsl:if test="/article/articleinfo/title !=''">
                <xsl:element name="text:p">
                    <xsl:attribute name="text:style-name">Document Title</xsl:attribute>
                    <xsl:value-of select="/article/articleinfo/title"/>
                </xsl:element>
                <xsl:if test="/article/articleinfo/subtitle !=''">
                    <xsl:element name="text:p">
                        <xsl:attribute name="text:style-name">Document SubTitle</xsl:attribute>
                        <xsl:value-of select="/article/articleinfo/subtitle"/>
                    </xsl:element>
                </xsl:if>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>

    </xsl:template>

    <xsl:template match="appendix">
        <xsl:element name="text:section">
            <xsl:attribute name="text:style-name">Appendix</xsl:attribute>
            <xsl:attribute name="text:name">Appendix</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>

    </xsl:template>

<!--
<xsl:template match="author">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="firstname">
     <xsl:element name="text:variable-set">
         <xsl:attribute name="text:name">
            <xsl:if test="ancestor::articleinfo/author">
                <xsl:text disable-output-escaping="yes">articleinfo.author</xsl:text><xsl:value-of select="count(parent::author[preceding-sibling::author])"/><xsl:text disable-output-escaping="yes">.firstname</xsl:text><xsl:value-of select="count(preceding-sibling::firstname)"/>
            </xsl:if>
        </xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>

</xsl:template>-->

    <xsl:template match="articleinfo/title">
    <!-- <xsl:element name="text:variable-decls">
                <xsl:element name="text:variable-decl">
                    <xsl:attribute name="text:value-type">
                        <xsl:text>string</xsl:text>
                     </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:text disable-output-escaping="yes">articleinfo.title</xsl:text>
                    </xsl:attribute>
                 </xsl:element>

        </xsl:element>
        <xsl:element name="text:p">
     <xsl:element name="text:variable-set">
        <xsl:attribute name="text:value-type">
                        <xsl:text>string</xsl:text>
                     </xsl:attribute>
         <xsl:attribute name="text:name">
            <xsl:text disable-output-escaping="yes">articleinfo.title</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
    </xsl:element>--></xsl:template>

    <xsl:template match="articleinfo/subtitle">
        <xsl:element name="text:variable-decls">
            <xsl:element name="text:variable-decl">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:text disable-output-escaping="yes">articleinfo.subtitle</xsl:text>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
        <xsl:element name="text:p">
            <xsl:element name="text:variable-set">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:text disable-output-escaping="yes">articleinfo.subtitle</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="articleinfo/edition">
        <xsl:element name="text:variable-decls">
            <xsl:element name="text:variable-decl">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:text disable-output-escaping="yes">articleinfo.edition</xsl:text>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
        <xsl:element name="text:p">
            <xsl:element name="text:variable-set">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:text disable-output-escaping="yes">articleinfo.edition</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="articleinfo/releaseinfo">
        <xsl:element name="text:variable-decls">
            <xsl:element name="text:variable-decl">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:text disable-output-escaping="yes">articleinfo.releaseinfo_</xsl:text>
                    <xsl:value-of select="count(preceding-sibling::releaseinfo)"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
        <xsl:element name="text:p">
            <xsl:element name="text:variable-set">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:text disable-output-escaping="yes">articleinfo.releaseinfo_</xsl:text>
                    <xsl:value-of select="count(preceding-sibling::releaseinfo)"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>


    <xsl:template match="author/firstname">
        <xsl:element name="text:variable-decls">
            <xsl:element name="text:variable-decl">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>

                <xsl:attribute name="text:name">
                    <xsl:if test="ancestor::articleinfo">
                        <xsl:text disable-output-escaping="yes">articleinfo.author_</xsl:text>
                        <xsl:value-of select="count(parent::author[preceding-sibling::author])"/>
                        <xsl:text disable-output-escaping="yes">.firstname_</xsl:text>
                        <xsl:value-of select="count(preceding-sibling::firstname)"/>
                    </xsl:if>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
        <xsl:element name="text:p">
            <xsl:element name="text:variable-set">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:if test="ancestor::articleinfo">
                        <xsl:text disable-output-escaping="yes">articleinfo.author_</xsl:text>
                        <xsl:value-of select="count(parent::author[preceding-sibling::author])"/>
                        <xsl:text disable-output-escaping="yes">.firstname_</xsl:text>
                        <xsl:value-of select="count(preceding-sibling::firstname)"/>
                    </xsl:if>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>



    <xsl:template match="articleinfo/copyright/year">
        <xsl:element name="text:variable-decls">
            <xsl:element name="text:variable-decl">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>

                <xsl:attribute name="text:name">
                    <xsl:if test="ancestor::articleinfo/copyright">
                        <xsl:text disable-output-escaping="yes">articleinfo.copyright_</xsl:text>
                        <xsl:value-of select="count(parent::copyright[preceding-sibling::copyright])"/>
                        <xsl:text disable-output-escaping="yes">.year_</xsl:text>
                        <xsl:value-of select="count(preceding-sibling::year)"/>
                    </xsl:if>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
        <xsl:element name="text:p">
            <xsl:element name="text:variable-set">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:if test="ancestor::articleinfo/copyright">
                        <xsl:text disable-output-escaping="yes">articleinfo.copyright_</xsl:text>
                        <xsl:value-of select="count(parent::copyright[preceding-sibling::copyright])"/>
                        <xsl:text disable-output-escaping="yes">.year_</xsl:text>
                        <xsl:value-of select="count(preceding-sibling::year)"/>
                    </xsl:if>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="authorgroup">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="articleinfo/copyright/holder">
        <xsl:element name="text:variable-decls">
            <xsl:element name="text:variable-decl">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>

                <xsl:attribute name="text:name">
                    <xsl:if test="ancestor::articleinfo/copyright">
                        <xsl:text disable-output-escaping="yes">articleinfo.copyright_</xsl:text>
                        <xsl:value-of select="count(parent::copyright[preceding-sibling::copyright])"/>
                        <xsl:text disable-output-escaping="yes">.holder_</xsl:text>
                        <xsl:value-of select="count(preceding-sibling::holder)"/>
                    </xsl:if>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
        <xsl:element name="text:p">
            <xsl:element name="text:variable-set">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:if test="ancestor::articleinfo/copyright">
                        <xsl:text disable-output-escaping="yes">articleinfo.copyright_</xsl:text>
                        <xsl:value-of select="count(parent::copyright[preceding-sibling::copyright])"/>
                        <xsl:text disable-output-escaping="yes">.holder_</xsl:text>
                        <xsl:value-of select="count(preceding-sibling::holder)"/>
                    </xsl:if>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>




    <xsl:template name="affiliation">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="author/affiliation/address">
        <xsl:element name="text:variable-decls">
            <xsl:element name="text:variable-decl">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:text disable-output-escaping="yes">articleinfo.author_</xsl:text>
                    <xsl:value-of select="count(ancestor::author[preceding-sibling::author])"/>
                    <xsl:text disable-output-escaping="yes">.affiliation_</xsl:text>
                    <xsl:value-of select="count(parent::affiliation[preceding-sibling::affiliation])"/>
                    <xsl:text disable-output-escaping="yes">.address_</xsl:text>
                    <xsl:value-of select="count(preceding-sibling::address)"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
        <xsl:element name="text:p">
            <xsl:element name="text:variable-set">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:text disable-output-escaping="yes">articleinfo.author_</xsl:text>
                    <xsl:value-of select="count(ancestor::author[preceding-sibling::author])"/>
                    <xsl:text disable-output-escaping="yes">.affiliation_</xsl:text>
                    <xsl:value-of select="count(parent::affiliation[preceding-sibling::affiliation])"/>
                    <xsl:text disable-output-escaping="yes">.address_</xsl:text>
                    <xsl:value-of select="count(preceding-sibling::address)"/>

                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="author/affiliation/orgname">
        <xsl:element name="text:variable-decls">
            <xsl:element name="text:variable-decl">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:if test="ancestor::articleinfo">
                    <xsl:attribute name="text:name">
                        <xsl:text disable-output-escaping="yes">articleinfo.author_</xsl:text>
                        <xsl:value-of select="count(ancestor::author[preceding-sibling::author])"/>
                        <xsl:text disable-output-escaping="yes">.affiliation_</xsl:text>
                        <xsl:value-of select="count(parent::affiliation[preceding-sibling::affiliation])"/>
                        <xsl:text disable-output-escaping="yes">.orgname_</xsl:text>
                        <xsl:value-of select="count(preceding-sibling::orgname)"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:element>
        <xsl:element name="text:p">
            <xsl:element name="text:variable-set">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:if test="ancestor::articleinfo">
                    <xsl:attribute name="text:name">
                        <xsl:text disable-output-escaping="yes">articleinfo.author_</xsl:text>
                        <xsl:value-of select="count(ancestor::author[preceding-sibling::author])"/>
                        <xsl:text disable-output-escaping="yes">.affiliation_</xsl:text>
                        <xsl:value-of select="count(parent::affiliation[preceding-sibling::affiliation])"/>
                        <xsl:text disable-output-escaping="yes">.orgname_</xsl:text>
                        <xsl:value-of select="count(preceding-sibling::orgname)"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>



    <xsl:template match="author/surname">
        <xsl:element name="text:variable-decls">
            <xsl:element name="text:variable-decl">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>

                <xsl:attribute name="text:name">
                    <xsl:text disable-output-escaping="yes">articleinfo.author_</xsl:text>
                    <xsl:value-of select="count(parent::author[preceding-sibling::author])"/>
                    <xsl:text disable-output-escaping="yes">.surname_</xsl:text>
                    <xsl:value-of select="count(preceding-sibling::surname)"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
        <xsl:element name="text:p">
            <xsl:element name="text:variable-set">
                <xsl:attribute name="text:value-type">
                    <xsl:text>string</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="text:name">
                    <xsl:text disable-output-escaping="yes">articleinfo.author_</xsl:text>
                    <xsl:value-of select="count(parent::author[preceding-sibling::author])"/>
                    <xsl:text disable-output-escaping="yes">.surname_</xsl:text>
                    <xsl:value-of select="count(preceding-sibling::surname)"/>


                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>





    <xsl:template match="para">

        <xsl:element name="text:p">

            <xsl:choose>
                <xsl:when test="ancestor-or-self::footnote">
                    <xsl:attribute name="text:style-name">Footnote</xsl:attribute>
                </xsl:when>
                <xsl:when test="ancestor-or-self::listitem">
                    <xsl:attribute name="text:style-name">VarList Item</xsl:attribute>
                </xsl:when>
                <xsl:when test="ancestor-or-self::informaltable">
                    <xsl:if test="ancestor-or-self::informaltable">
                        <xsl:attribute name="text:style-name">Table Contents</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::thead">
                        <xsl:attribute name="text:style-name">Table Heading</xsl:attribute>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="ancestor-or-self::table">
                    <xsl:if test="ancestor-or-self::table">
                        <xsl:attribute name="text:style-name">Table Contents</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::thead">
                        <xsl:attribute name="text:style-name">Table Heading</xsl:attribute>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="text:style-name">Text body</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates/>
        </xsl:element>

    </xsl:template>

    <xsl:template match="section">
        <xsl:element name="text:h">
            <xsl:attribute name="text:level">
                <xsl:value-of select="count(ancestor-or-self::section)"/>
            </xsl:attribute>
            <xsl:value-of select="child::title"/>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="abstract">
        <xsl:element name="text:h">
            <xsl:attribute name="text:level">1</xsl:attribute>
            <xsl:text>abstract</xsl:text>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="appendix">
        <xsl:element name="text:h">
            <xsl:attribute name="text:level">1</xsl:attribute>
            <xsl:text>appendix</xsl:text>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="sect1">
        <xsl:element name="text:h">
            <xsl:attribute name="text:level">1</xsl:attribute>
            <xsl:attribute name="text:style-name">Heading 1</xsl:attribute>
            <xsl:value-of select="child::title"/>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="sect2">
        <xsl:element name="text:h">
            <xsl:attribute name="text:level">2</xsl:attribute>
            <xsl:attribute name="text:style-name">Heading 2</xsl:attribute>
            <xsl:value-of select="child::title"/>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="sect3">
        <xsl:element name="text:h">
            <xsl:attribute name="text:level">3</xsl:attribute>
            <xsl:attribute name="text:style-name">Heading 3</xsl:attribute>
            <xsl:value-of select="child::title"/>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="sect4">
        <xsl:element name="text:h">
            <xsl:attribute name="text:level">4</xsl:attribute>
            <xsl:attribute name="text:style-name">Heading 4</xsl:attribute>
            <xsl:value-of select="child::title"/>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="sect5">
        <xsl:element name="text:h">
            <xsl:attribute name="text:level">5</xsl:attribute>
            <xsl:value-of select="child::title"/>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>

<!--<xsl:template match="sect5">
    <xsl:element name="text:section">
        <xsl:attribute name="text:style-name">Sect1</xsl:attribute>
        <xsl:attribute name="text:name"><xsl:value-of select="@id"/></xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>-->


    <xsl:template match="informaltable">
        <xsl:element name="table:table">
            <xsl:attribute name="table:name"></xsl:attribute>
            <xsl:attribute name="table:style-name">Table1</xsl:attribute>
            <xsl:attribute name="table:name">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="table">
        <xsl:variable name="tabletitle">
            <xsl:value-of select="title"/>
        </xsl:variable>
        <xsl:element name="table:table">
            <xsl:attribute name="table:name"></xsl:attribute>
            <xsl:attribute name="table:style-name">Table1</xsl:attribute>
            <xsl:attribute name="table:name">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
        <xsl:if test="not($tabletitle='')">
            <xsl:element name="text:p">
                <xsl:attribute name="text:style-name">Table</xsl:attribute>
                <xsl:value-of select="$tabletitle"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tgroup">
        <xsl:element name="table:table-column">
            <xsl:attribute name="table:style-name">Table1.A</xsl:attribute>
            <xsl:choose>
                <xsl:when test="@cols >0">
                    <xsl:attribute name="table:number-columns-repeated">
                        <xsl:value-of select="@cols"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="table:number-columns-repeated">
                        <xsl:value-of select="count(child::tbody/row/entry) div count(child::tbody/row)"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="indexterm"></xsl:template>

    <xsl:template match="thead">
        <xsl:element name="table:table-header-rows">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tbody">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="row">
        <xsl:element name="table:table-row">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="entry">
        <xsl:element name="table:table-cell">
            <xsl:if test="ancestor-or-self::thead">
                <xsl:attribute name="table:style-name">Table1.A1</xsl:attribute>
            </xsl:if>
            <xsl:if test="not(ancestor-or-self::thead)">
                <xsl:attribute name="table:style-name">Table1.A2</xsl:attribute>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="@spanname">
        <!--<xsl:if test="@spanname">-->
                    <xsl:variable name="sname">
                        <xsl:value-of select="@spanname"/>
                    </xsl:variable>
                    <xsl:attribute name="table:number-columns-spanned">
                        <xsl:variable name="colnamestart">
                            <xsl:value-of select="ancestor::tgroup/spanspec[@spanname=$sname]/@namest"/>
                        </xsl:variable>
                        <xsl:variable name="colnameend">
                            <xsl:value-of select="ancestor::tgroup/spanspec[@spanname=$sname]/@nameend"/>
                        </xsl:variable>
                        <xsl:variable name="colnumstart">
                            <xsl:value-of select="ancestor::tgroup/colspec[@colname=$colnamestart]/@colnum"/>
                        </xsl:variable>
                        <xsl:variable name="colnumend">
                            <xsl:value-of select="ancestor::tgroup/colspec[@colname=$colnameend]/@colnum"/>
                        </xsl:variable>
                        <xsl:value-of select="$colnumend - $colnumstart + 1"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@namest and @nameend">
        <!--<xsl:if test="@namest and @nameend">-->
                    <xsl:variable name="colnamestart">
                        <xsl:value-of select="@namest"/>
                    </xsl:variable>
                    <xsl:variable name="colnameend">
                        <xsl:value-of select="@nameend"/>
                    </xsl:variable>

                    <xsl:attribute name="table:number-columns-spanned">
                        <xsl:variable name="colnumstart">
                            <xsl:value-of select="ancestor::tgroup/colspec[@colname=$colnamestart]/@colnum"/>
                        </xsl:variable>
                        <xsl:variable name="colnumend">
                            <xsl:value-of select="ancestor::tgroup/colspec[@colname=$colnameend]/@colnum"/>
                        </xsl:variable>
                        <xsl:value-of select="$colnumend - $colnumstart + 1"/>

                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
        <!--
        <xsl:if test="not(@namest = '' ) ">
             <xsl:attribute name="table:number-columns-spanned">
                 <xsl:value-of select="(substring-after(@nameend,'c')-substring-after(@namest,'c'))+1"/>

             </xsl:attribute>
        </xsl:if>
        -->
            <xsl:choose>
                <xsl:when test="not(child::para)">
                    <xsl:element name="text:p">
                        <xsl:if test="ancestor-or-self::thead">
                            <xsl:attribute name="text:style-name">Table Heading</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="ancestor-or-self::tbody">
                            <xsl:attribute name="text:style-name">Table Contents</xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>






    <xsl:template match="figure">
        <xsl:apply-templates/>
    </xsl:template>

<!--  lists Section -->

    <xsl:template match="itemizedlist">
        <xsl:element name="text:unordered-list">
            <xsl:if test="not(ancestor::itemizedlist)">
                <xsl:attribute name="text:style-name">L1</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="variablelist">
        <xsl:element name="text:unordered-list">
            <xsl:attribute name="text:style-name">Var List</xsl:attribute>
            <xsl:attribute name="text:continue-numbering">false</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="orderedlist">
        <xsl:element name="text:ordered-list">
            <xsl:attribute name="text:style-name">Ordered List</xsl:attribute>
            <xsl:attribute name="text:continue-numbering">false</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="term">
        <xsl:if test="parent::varlistentry">
            <text:list-item>
                <xsl:element name="text:p">
                    <xsl:attribute name="text:style-name">VarList Term</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </text:list-item>
        </xsl:if>
    </xsl:template>

    <xsl:template match="listitem">
        <text:list-item>
            <xsl:apply-templates/>
        </text:list-item>
    </xsl:template>

<!--  end of lists-->

    <xsl:template match="menuchoice">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="guimenuitem">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">GuiMenuItem</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="guibutton">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">GuiButton</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="guisubmenu">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">GuiSubMenu</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="emphasis">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">Emphasis</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="guimenu">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">GuiMenu</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="guisubmenu">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">GuiSubMenu</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="guilabel">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">GuiLabel</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="guibutton">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">GuiButton</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="keycap">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">KeyCap</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="keysym">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">KeySym</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="keycombo">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">KeyCombo</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="command">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">Command</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="application">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">Application</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="filename">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">FileName</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="systemitem">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">SystemItem</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="computeroutput">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">ComputerOutput</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="inlinegraphic">
        <xsl:element name="draw:image">
            <xsl:attribute name="draw:style-name">fr1</xsl:attribute>
            <xsl:attribute name="draw:name"></xsl:attribute>
            <xsl:attribute name="text:anchor-type"></xsl:attribute>
            <xsl:attribute name="draw:z-index"></xsl:attribute>
            <xsl:attribute name="xlink:href">
                <xsl:value-of select="@fileref"/>
            </xsl:attribute>
            <xsl:attribute name="xlink:type"></xsl:attribute>
            <xsl:attribute name="svg:width">
            <!--<xsl:value-of select="@width"/>-->
                <xsl:text>1cm</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="svg:height">
                <xsl:text>1cm</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xlink:show">
                <xsl:text>embed</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xlink:actuate">
                <xsl:text>onLoad</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="draw:filter-name">
                <xsl:text disable-output-escaping="yes">&lt;All formats&gt;</xsl:text>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>


    <xsl:template match="footnote">
        <xsl:element name="text:footnote">
        <!--<xsl:element name="text:footnote-citation">Aidan</xsl:element>-->
            <xsl:element name="text:footnote-body">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="highlight">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">Highlight</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="ulink">
        <xsl:element name="text:a">
            <xsl:attribute name="xlink:type">
                <xsl:text>simple</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xlink:href">
                <xsl:value-of select="@url"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>

    </xsl:template>

    <xsl:template match="link">
        <xsl:element name="text:a">
            <xsl:attribute name="xlink:type">
                <xsl:text>simple</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xlink:href">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="@linkend"/>
                <xsl:text>%7Cregion</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>

    </xsl:template>

    <xsl:template match="olink">
        <xsl:element name="text:a">
            <xsl:attribute name="xlink:type">
                <xsl:text>simple</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xlink:href">
                <xsl:value-of select="@targetdocent"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="note">
        <office:annotation>
            <text:p>
                <xsl:apply-templates/>
            </text:p>
        </office:annotation>
    </xsl:template>

    <xsl:template match="imageobject">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="textobject"></xsl:template>

    <xsl:template match="caption">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="imagedata">
        <xsl:element name="draw:image">
            <xsl:attribute name="draw:style-name">fr1</xsl:attribute>
            <xsl:attribute name="draw:name"></xsl:attribute>
            <xsl:attribute name="text:anchor-type"></xsl:attribute>
            <xsl:attribute name="draw:z-index"></xsl:attribute>
            <xsl:attribute name="xlink:href">
                <xsl:value-of select="@fileref"/>
            </xsl:attribute>
            <xsl:attribute name="xlink:type"></xsl:attribute>
            <xsl:attribute name="svg:width">
            <!--<xsl:value-of select="@width"/>-->
                <xsl:text>1cm</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="svg:height">
                <xsl:text>1cm</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xlink:show">
                <xsl:text>embed</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xlink:actuate">
                <xsl:text>onLoad</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="draw:filter-name">
                <xsl:text disable-output-escaping="yes">&lt;All formats&gt;</xsl:text>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template match="audioobject">
        <xsl:element name="draw:plugin">
            <xsl:attribute name="draw:style-name">fr1</xsl:attribute>
            <xsl:attribute name="draw:name"></xsl:attribute>
            <xsl:attribute name="text:anchor-type"></xsl:attribute>
            <xsl:attribute name="draw:z-index"></xsl:attribute>
            <xsl:attribute name="xlink:href">
                <xsl:value-of select="@fileref"/>
            </xsl:attribute>
            <xsl:attribute name="xlink:type"></xsl:attribute>
            <xsl:attribute name="svg:width">
            <!--<xsl:value-of select="@width"/>-->
                <xsl:text>1cm</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="svg:height">
                <xsl:text>1cm</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xlink:show">
                <xsl:text>embed</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xlink:actuate">
                <xsl:text>onLoad</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="draw:filter-name">
                <xsl:text disable-output-escaping="yes">&lt;All formats&gt;</xsl:text>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template match="remark">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="mediaobject">
        <xsl:element name="text:p">
            <xsl:attribute name="text:style-name">Mediaobject</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="superscript">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">SuperScript</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="subscript">
        <xsl:element name="text:span">
            <xsl:attribute name="text:style-name">SubScript</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="anchor">
        <xsl:element name="text:bookmark">
            <xsl:attribute name="text:name"><xsl:value-of select="@id"/></xsl:attribute>
        </xsl:element>
    </xsl:template>

<!-- Change Made By Kevin Fowlks (fowlks@msu.edu) July 2nd, 2003 -->
    <xsl:template match="example">
        <xsl:element name="text:p">
            <xsl:attribute name="text:style-name">Example</xsl:attribute>
            <xsl:value-of select="programlisting"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>