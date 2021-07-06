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
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:SL="http://schemas.microsoft.com/schemaLibrary/2003/core" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" extension-element-prefixes="set exsl" exclude-result-prefixes="aml dt html o ss SL v w10 w wx x set exsl">
    <!--+++++ INCLUDED XSL MODULES +++++-->
    <!-- helper collection, to convert measures (e.g. inch to pixel using DPI (dots per inch) parameter)-->
    <xsl:import href="../../common/measure_conversion.xsl"/>
    <xsl:output indent="no" version="1.0" encoding="UTF-8" method="xml"/>
    <xsl:template match="/">
        <office:document office:mimetype="application/vnd.oasis.opendocument.spreadsheet" office:version="1.0">
            <xsl:apply-templates select="ss:Workbook/o:DocumentProperties"/>
            <xsl:apply-templates select="ss:Workbook/x:ExcelWorkbook"/>
            <xsl:call-template name="font-declaration"/>
            <xsl:apply-templates select="ss:Workbook/ss:Worksheet[1]" mode="styles"/>
            <xsl:element name="office:body">
                <xsl:element name="office:spreadsheet">
                    <xsl:call-template name="set-calculation"/>
                    <!-- for DataValidation -->
                    <xsl:if test="ss:Workbook/ss:Worksheet/x:DataValidation">
                        <xsl:element name="table:content-validations">
                            <xsl:apply-templates select="ss:Workbook/ss:Worksheet/x:DataValidation"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:apply-templates select="ss:Workbook/ss:Worksheet"/>
                    <xsl:call-template name="Names"/>
                    <xsl:element name="table:database-ranges">
                        <!-- these descriptions located in every Worksheet in Excel, but at the same path in Calc -->
                        <xsl:for-each select="ss:Workbook/ss:Worksheet">
                            <xsl:apply-templates select="./x:Sorting"/>
                            <xsl:apply-templates select="./x:AutoFilter"/>
                            <!-- for Advanced Filter.the position is same as AutoFilter -->
                            <xsl:if test="./ss:Names/ss:NamedRange and ./ss:Names/ss:NamedRange/@ss:Name='_FilterDatabase'">
                                <xsl:call-template name="transform-advanced-filter">
                                    <xsl:with-param name="target-value" select="substring-after(./ss:Names/ss:NamedRange[@ss:Name='_FilterDatabase']/@ss:RefersTo, '=')"/>
                                    <xsl:with-param name="condition-pos" select="substring-after(./ss:Names/ss:NamedRange[@ss:Name='Criteria']/@ss:RefersTo, '=')"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </office:document>
    </xsl:template>
    <xsl:template match="o:DocumentProperties">
        <office:meta>
            <meta:generator>Microsoft Excel 2003</meta:generator>
            <xsl:if test="o:Title">
                <dc:title>
                    <xsl:value-of select="o:Title"/>
                </dc:title>
            </xsl:if>
            <xsl:if test="o:Description">
                <dc:description>
                    <xsl:value-of select="o:Description"/>
                </dc:description>
            </xsl:if>
            <xsl:if test="o:Subject">
                <dc:subject>
                    <xsl:value-of select="o:Subject"/>
                </dc:subject>
            </xsl:if>
            <xsl:if test="o:Author">
                <meta:initial-creator>
                    <xsl:value-of select="o:Author"/>
                </meta:initial-creator>
            </xsl:if>
            <xsl:if test="o:Created">
                <meta:creation-date>
                    <xsl:value-of select="substring-before( o:Created, 'Z')"/>
                </meta:creation-date>
            </xsl:if>
            <xsl:if test="o:LastAuthor">
                <dc:creator>
                    <xsl:value-of select="o:LastAuthor"/>
                </dc:creator>
            </xsl:if>
            <xsl:if test="o:LastSaved">
                <dc:date>
                    <xsl:value-of select="substring-before( o:LastSaved, 'Z')"/>
                </dc:date>
            </xsl:if>
            <!--
            <meta:printed-by/>
            <meta:print-date/>
                <!~~ removed in OASIS Open Office XML
                <meta:keywords>
                    <meta:keyword>
                        <xsl:value-of select="o:Keywords" />
                    </meta:keyword>
                </meta:keywords>
                ~~>
            <dc:language/>
            -->
            <xsl:if test="o:Revision">
                <meta:editing-cycles>
                    <xsl:value-of select="o:Revision"/>
                </meta:editing-cycles>
            </xsl:if>
            <xsl:if test="o:TotalTime">
                <meta:editing-duration>
                    <xsl:value-of select="concat('PT', floor(o:TotalTime div 60), 'H', o:TotalTime mod 60, 'M0S')"/>
                </meta:editing-duration>
            </xsl:if>
            <xsl:if test="o:Category">
                <meta:user-defined meta:name="Category">
                    <xsl:value-of select="o:Category"/>
                </meta:user-defined>
            </xsl:if>
            <xsl:if test="o:Manager">
                <meta:user-defined meta:name="Manager">
                    <xsl:value-of select="o:Manager"/>
                </meta:user-defined>
            </xsl:if>
            <xsl:if test="o:Company">
                <meta:user-defined meta:name="Company">
                    <xsl:value-of select="o:Company"/>
                </meta:user-defined>
            </xsl:if>
            <xsl:if test="o:Version">
                <meta:user-defined meta:name="Version">
                    <xsl:value-of select="o:Version"/>
                </meta:user-defined>
            </xsl:if>
            <xsl:if test="o:HyperlinkBase">
                <meta:user-defined meta:name="HyperlinkBase">
                    <xsl:value-of select="o:HyperlinkBase"/>
                </meta:user-defined>
            </xsl:if>
            <xsl:apply-templates select="../o:CustomDocumentProperties"/>
            <!--Note:  <meta:document-statistic/>-->
        </office:meta>
    </xsl:template>
    <xsl:template match="o:CustomDocumentProperties">
        <xsl:for-each select="node()[@dt:dt]">
            <meta:user-defined meta:name="{name()}">
                <xsl:value-of select="."/>
            </meta:user-defined>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="x:ExcelWorkbook">
        <!-- Configuration in 'ooo:view-settings' and 'ooo:configuration-settings'
        "GridColor"
        "HasColumnRowHeaders"
        "HasSheetTabs"
        "IsOutlineSymbolsSet"
        "IsRasterAxisSynchronized"
        "IsSnapToRaster"
        "RasterIsVisible"
        "RasterResolutionX"
        "RasterResolutionY"
        "RasterSubdivisionX"
        "RasterSubdivisionY"
        "ShowGrid"
        "ShowNotes"
        "ShowPageBreaks"
        "ShowZeroValues"
        -->
        <xsl:variable name="sharedConfiguration">
            <xsl:if test="../ss:Worksheet/x:WorksheetOptions/x:GridlineColor">
                <config:config-item config:name="GridColor" config:type="long">
                    <xsl:variable name="temp-code" select="substring-after(normalize-space(../ss:Worksheet/x:WorksheetOptions/x:GridlineColor), '#')"/>
                    <xsl:variable name="temp-value">
                        <xsl:call-template name="hex2decimal">
                            <xsl:with-param name="hex-number" select="$temp-code"/>
                            <xsl:with-param name="index" select="1"/>
                            <xsl:with-param name="str-length" select="string-length($temp-code)"/>
                            <xsl:with-param name="last-value" select="0"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$temp-value"/>
                </config:config-item>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="../ss:Worksheet/x:WorksheetOptions/x:DoNotDisplayHeadings">
                    <config:config-item config:name="HasColumnRowHeaders" config:type="boolean">false</config:config-item>
                </xsl:when>
                <xsl:otherwise>
                    <config:config-item config:name="HasColumnRowHeaders" config:type="boolean">true</config:config-item>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="x:HideWorkbookTabs">
                    <config:config-item config:name="HasSheetTabs" config:type="boolean">false</config:config-item>
                </xsl:when>
                <xsl:otherwise>
                    <config:config-item config:name="HasSheetTabs" config:type="boolean">true</config:config-item>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
            <xsl:when test="../ss:Worksheet/x:WorksheetOptions/x:DoNotDisplayOutline">
                <config:config-item config:name="IsOutlineSymbolsSet" config:type="boolean">false</config:config-item>
            </xsl:when>
                <xsl:otherwise>
                <config:config-item config:name="IsOutlineSymbolsSet" config:type="boolean">true</config:config-item>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="../ss:Worksheet/x:WorksheetOptions/x:DoNotDisplayGridlines">
                    <config:config-item config:name="ShowGrid" config:type="boolean">false</config:config-item>
                </xsl:when>
                <xsl:otherwise>
                    <config:config-item config:name="ShowGrid" config:type="boolean">true</config:config-item>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="../ss:Worksheet/x:WorksheetOptions/x:DoNotDisplayZeros">
                    <config:config-item config:name="ShowZeroValues" config:type="boolean">false</config:config-item>
                </xsl:when>
                <xsl:otherwise>
                    <config:config-item config:name="ShowZeroValues" config:type="boolean">true</config:config-item>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <office:settings>
            <config:config-item-set config:name="ooo:view-settings">
                <config:config-item config:type="int" config:name="VisibleAreaTop">
                    <xsl:value-of select="x:WindowTopY"/>
                </config:config-item>
                <config:config-item config:name="VisibleAreaLeft" config:type="int">
                    <xsl:value-of select="x:WindowTopX"/>
                </config:config-item>
                <config:config-item config:name="VisibleAreaWidth" config:type="int">
                    <xsl:value-of select="x:WindowWidth"/>
                </config:config-item>
                <config:config-item config:name="VisibleAreaHeight" config:type="int">
                    <xsl:value-of select="x:WindowHeight"/>
                </config:config-item>
                <xsl:variable name="ratio" select="15"/>
                <config:config-item-map-indexed config:name="Views">
                    <config:config-item-map-entry>
                        <config:config-item config:name="ViewId" config:type="string">View1</config:config-item>
                        <config:config-item-map-named config:name="Tables">
                            <!--  The panes of a table is like 3   |   1   or  3 |  1, or   3 , while 3 is the default one. glu
                                                     - - - -        - - -
                                                    2  |  0         2    -->
                            <xsl:for-each select="../ss:Worksheet">
                                <config:config-item-map-entry config:name="{@ss:Name}">
                                    <xsl:variable name="active-pane">
                                        <xsl:choose>
                                            <xsl:when test="x:WorksheetOptions/x:ActivePane">
                                                <xsl:value-of select="x:WorksheetOptions/x:ActivePane"/>
                                            </xsl:when>
                                            <xsl:otherwise/>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:if test="not( $active-pane = '' ) and ( x:WorksheetOptions/x:SplitVertical or x:WorksheetOptions/x:SplitHorizontal )">
                                        <config:config-item config:name="ActiveSplitRange" config:type="short">
                                            <xsl:choose>
                                                <xsl:when test="x:WorksheetOptions/x:SplitVertical and not(x:WorksheetOptions/x:SplitHorizontal)">
                                                    <xsl:value-of select="'3'"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$active-pane"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </config:config-item>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when test="not( $active-pane = '')">
                                            <config:config-item config:name="CursorPositionX" config:type="int">
                                                <xsl:value-of select="x:WorksheetOptions/x:Panes/x:Pane[x:Number = $active-pane ]/x:ActiveCol"/>
                                            </config:config-item>
                                            <config:config-item config:name="CursorPositionY" config:type="int">
                                                <xsl:value-of select="x:WorksheetOptions/x:Panes/x:Pane[x:Number = $active-pane ]/x:ActiveRow"/>
                                            </config:config-item>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <config:config-item config:name="CursorPositionX" config:type="int">
                                                <xsl:value-of select="x:WorksheetOptions/x:Panes/x:Pane/x:ActiveCol"/>
                                            </config:config-item>
                                            <config:config-item config:name="CursorPositionY" config:type="int">
                                                <xsl:value-of select="x:WorksheetOptions/x:Panes/x:Pane/x:ActiveRow"/>
                                            </config:config-item>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:variable name="position-left">
                                        <xsl:choose>
                                            <xsl:when test="x:WorksheetOptions/x:LeftColumnVisible">
                                                <xsl:value-of select="x:WorksheetOptions/x:LeftColumnVisible"/>
                                            </xsl:when>
                                            <xsl:otherwise>0</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <config:config-item config:name="PositionLeft" config:type="int">
                                        <xsl:value-of select="$position-left"/>
                                    </config:config-item>
                                    <xsl:variable name="position-top">
                                        <xsl:choose>
                                            <xsl:when test="x:WorksheetOptions/x:TopRowVisible">
                                                <xsl:value-of select="x:WorksheetOptions/x:TopRowVisible"/>
                                            </xsl:when>
                                            <xsl:otherwise>0</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when test="x:WorksheetOptions/x:SplitVertical and not(x:WorksheetOptions/x:SplitHorizontal)">
                                            <config:config-item config:name="PositionBottom" config:type="int">
                                                <xsl:value-of select="$position-top"/>
                                            </config:config-item>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <config:config-item config:name="PositionTop" config:type="int">
                                                <xsl:value-of select="$position-top"/>
                                            </config:config-item>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="x:WorksheetOptions/x:SplitVertical">
                                            <config:config-item config:name="HorizontalSplitMode" config:type="short">
                                                <xsl:choose>
                                                    <xsl:when test="x:WorksheetOptions/x:FreezePanes">2</xsl:when>
                                                    <xsl:otherwise>1</xsl:otherwise>
                                                </xsl:choose>
                                            </config:config-item>
                                            <config:config-item config:name="HorizontalSplitPosition" config:type="int">
                                                <xsl:choose>
                                                    <xsl:when test="x:WorksheetOptions/x:FreezePanes">
                                                        <xsl:value-of select="x:WorksheetOptions/x:SplitVertical + $position-left"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="floor( x:WorksheetOptions/x:SplitVertical div $ratio )"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </config:config-item>
                                            <config:config-item config:name="PositionRight" config:type="int">
                                                <xsl:value-of select="x:WorksheetOptions/x:LeftColumnRightPane"/>
                                            </config:config-item>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <config:config-item config:name="HorizontalSplitMode" config:type="short">0</config:config-item>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="x:WorksheetOptions/x:SplitHorizontal">
                                            <config:config-item config:name="VerticalSplitMode" config:type="short">
                                                <xsl:choose>
                                                    <xsl:when test="x:WorksheetOptions/x:FreezePanes">2</xsl:when>
                                                    <xsl:otherwise>1</xsl:otherwise>
                                                </xsl:choose>
                                            </config:config-item>
                                            <config:config-item config:name="VerticalSplitPosition" config:type="int">
                                                <xsl:choose>
                                                    <xsl:when test="x:WorksheetOptions/x:FreezePanes">
                                                        <xsl:value-of select="x:WorksheetOptions/x:SplitHorizontal + $position-top"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="floor( x:WorksheetOptions/x:SplitHorizontal div $ratio )"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </config:config-item>
                                            <config:config-item config:name="PositionBottom" config:type="int">
                                                <xsl:value-of select="x:WorksheetOptions/x:TopRowBottomPane"/>
                                            </config:config-item>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <config:config-item config:name="VerticalSplitMode" config:type="short">0</config:config-item>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:copy-of select="$sharedConfiguration"/>
                                    <xsl:if test="x:WorksheetOptions/x:TabColorIndex">
                                        <config:config-item config:name="TabColor" config:type="int">
                                            <xsl:variable name="temp-value">
                                                <xsl:call-template name="colorindex2decimal">
                                                    <xsl:with-param name="colorindex" select="x:WorksheetOptions/x:TabColorIndex"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:value-of select="$temp-value"/>
                                        </config:config-item>
                                    </xsl:if>
                                </config:config-item-map-entry>
                            </xsl:for-each>
                        </config:config-item-map-named>
                        <xsl:if test="x:ActiveSheet">
                            <config:config-item config:name="ActiveTable" config:type="string">
                                <xsl:value-of select="../ss:Worksheet[/ss:Workbook/x:ExcelWorkbook/x:ActiveSheet+1]/@ss:Name"/>
                            </config:config-item>
                        </xsl:if>
                        <config:config-item config:name="HorizontalScrollbarWidth" config:type="int">555</config:config-item>
                        <!-- following are some table setting from Excel, but transformed to global setting, due to limit of Calc -->
                        <xsl:if test="../ss:Worksheet/x:WorksheetOptions/x:ShowPageBreakZoom">
                            <config:config-item config:name="ShowPageBreakPreview" config:type="boolean">true</config:config-item>
                        </xsl:if>
                        <xsl:if test="../ss:Worksheet/x:WorksheetOptions/x:PageBreakZoom">
                            <config:config-item config:name="PageViewZoomValue" config:type="int">
                                <xsl:value-of select="../ss:Worksheet/x:WorksheetOptions/x:PageBreakZoom"/>
                            </config:config-item>
                        </xsl:if>
                        <xsl:if test="../ss:Worksheet/x:WorksheetOptions/x:Zoom">
                            <config:config-item config:name="ZoomValue" config:type="int">
                                <xsl:value-of select="../ss:Worksheet/x:WorksheetOptions/x:Zoom"/>
                            </config:config-item>
                        </xsl:if>
                        <!-- several properties are not saved in Calc XML but setting, whereas vice versa. :( So just to be expanded, glu -->
                    </config:config-item-map-entry>
                </config:config-item-map-indexed>
            </config:config-item-set>
            <config:config-item-set config:name="ooo:configuration-settings">
                <xsl:copy-of select="$sharedConfiguration"/>
            </config:config-item-set>
            <!-- printer setting, not finished yet. glu
            <config:config-item-set config:name="configuration-settings" />
            -->
        </office:settings>
    </xsl:template>

    <xsl:variable name="allFontDefs"><xsl:for-each select="/ss:Workbook/ss:Styles/ss:Style/ss:Font[@ss:FontName or @x:Family]|/ss:Workbook/ss:Worksheet/ss:Table/ss:Row/ss:Cell/descendant::html:Font[@html:Face or @x:Family]"><f><xsl:copy-of select="@ss:FontName |@html:Face | @x:Family"/><xsl:value-of select="concat(@ss:FontName, @html:Face, '&#9;', @x:Family)"/></f></xsl:for-each></xsl:variable>

    <xsl:template name="font-declaration">
        <xsl:variable name="distinctFontDefs">
            <xsl:choose>
                <!-- saxon dropped support for exslt:sets#distinct() in version 8.2, but is capable of executing XPath 2.0 functions -->
                <xsl:when test="function-available('set:distinct')"><xsl:copy-of select="set:distinct(exsl:node-set($allFontDefs)/*)"/></xsl:when>
                <xsl:otherwise><xsl:call-template name="set:distinct"><xsl:with-param name="nodes" select="$allFontDefs"></xsl:with-param></xsl:call-template></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <office:font-face-decls>
            <xsl:if test="count(exsl:node-set($distinctFontDefs))">
                <xsl:for-each select="exsl:node-set($distinctFontDefs)/*">
                    <style:font-face>
                        <xsl:if test="@ss:FontName or @html:Face">
                            <xsl:attribute name="style:name">
                                <xsl:value-of select="@ss:FontName | @html:Face"/>
                            </xsl:attribute>
                            <xsl:attribute name="svg:font-family">
                                <xsl:value-of select="@ss:FontName | @html:Face "/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@x:Family">
                            <xsl:attribute name="style:font-family-generic">
                                <xsl:call-template name="translate-font-family-generic">
                                    <xsl:with-param name="family" select="@x:Family"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                    </style:font-face>
                </xsl:for-each>
            </xsl:if>
        </office:font-face-decls>
    </xsl:template>
    <xsl:template name="translate-font-family-generic">
        <xsl:param name="family"/>
        <xsl:choose>
            <xsl:when test="$family='Swiss'">swiss</xsl:when>
            <xsl:when test="$family='Modern'">modern</xsl:when>
            <xsl:when test="$family='Roman'">roman</xsl:when>
            <xsl:when test="$family='Script'">script</xsl:when>
            <xsl:when test="$family='Decorative'">decorative</xsl:when>
            <!-- change 'System' to 'Automatic' for Excel -->
            <xsl:when test="$family='Automatic'">system</xsl:when>
            <xsl:otherwise>system</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ss:Workbook/ss:Worksheet" mode="styles">
        <office:styles>
            <xsl:apply-templates select="/ss:Workbook/ss:Styles/ss:Style[@ss:Name]"/>
            <xsl:apply-templates select="/ss:Workbook/ss:Styles/ss:Style/ss:NumberFormat[@ss:Format]"/>
            <!-- if ConditionalFormatting exists,it should generate some styles for style:style -->
            <xsl:if test="/ss:Workbook/ss:Worksheet/x:ConditionalFormatting">
                <xsl:call-template name="CondFormat_office_style"/>
            </xsl:if>
        </office:styles>
        <office:automatic-styles>
            <xsl:apply-templates select="/ss:Workbook/ss:Worksheet/ss:Table"/>
            <xsl:apply-templates select="/ss:Workbook/ss:Styles/ss:Style[not(@ss:Name)]"/>
            <xsl:apply-templates select="/ss:Workbook/ss:Styles/ss:Style/ss:Font[@ss:VerticalAlign]"/>
            <!-- applying to ss:Data (but *, as also ss:Data nested in ss:Comments -->
            <xsl:apply-templates select="/ss:Workbook/ss:Worksheet/ss:Table/ss:Row/ss:Cell/*[descendant-or-self::*]"/>
            <xsl:apply-templates select="/ss:Workbook/ss:Worksheet/x:WorksheetOptions/x:PageSetup//@x:Data"/>
            <!-- if ConditionalFormatting exists,transforing the styles -->
            <xsl:if test="/ss:Workbook/ss:Worksheet/x:ConditionalFormatting">
                <xsl:call-template name="CondFormat_automatic_style"/>
            </xsl:if>
            <xsl:call-template name="create-page-master">
                <xsl:with-param name="worksheetoptions" select="/ss:Workbook/ss:Worksheet/x:WorksheetOptions"/>
            </xsl:call-template>
        </office:automatic-styles>
        <office:master-styles>
            <xsl:call-template name="create-master-styles">
                <xsl:with-param name="worksheetoptions" select="/ss:Workbook/ss:Worksheet/x:WorksheetOptions"/>
            </xsl:call-template>
        </office:master-styles>
    </xsl:template>
    <xsl:template name="CondFormat_office_style">
        <!-- translate the ConditionalFormatting style,including font,size,color,etc -->
        <xsl:for-each select="/ss:Workbook/ss:Worksheet/x:ConditionalFormatting">
            <xsl:variable name="table-pos" select="count(../preceding-sibling::ss:Worksheet)+1"/>
            <xsl:variable name="conditions" select="count(preceding-sibling::x:ConditionalFormatting)+1"/>
            <!-- Matching multiple styles, but automatic styles are not allowed to inherit from another automatic style
            <xsl:for-each select="key('tableStyleIDs', key('tableWithConditional', .))
                [generate-id(.) =
                 generate-id(key('styleId', .)[1])] ">
                 <xsl:sort select="." />

                 <xsl:apply-templates select="/ss:Workbook/ss:Styles/ss:Style[@ss:ID = current()/.]"/>
            </xsl:for-each>
            -->
            <xsl:for-each select="x:Condition">
                <xsl:variable name="condition-number" select="count(preceding-sibling::x:Condition)+1"/>
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name">
                        <xsl:call-template name="encode-as-nc-name">
                            <xsl:with-param name="string" select="concat('Excel_CondFormat_',$table-pos,'_',$conditions,'_',$condition-number)"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="style:family">table-cell</xsl:attribute>
                    <xsl:apply-templates select="@ss:Name" />
                    <xsl:element name="style:table-cell-properties">
                        <xsl:choose>
                            <xsl:when test="x:Format/@Style">
                                <xsl:variable name="stylevalue" select="./x:Format/@Style"/>
                                <xsl:call-template name="recursion-condformat-style-table-cell">
                                    <xsl:with-param name="style-value-t">
                                        <xsl:choose>
                                            <xsl:when test="substring($stylevalue,string-length($stylevalue),1) != ';'">
                                                <xsl:value-of select="concat($stylevalue,';')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$stylevalue"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:element name="style:text-properties">
                        <xsl:choose>
                            <xsl:when test="x:Format/@Style">
                                <xsl:variable name="stylevalue" select="./x:Format/@Style"/>
                                <xsl:call-template name="recursion-condformat-style-text">
                                    <xsl:with-param name="style-value-t">
                                        <xsl:choose>
                                            <xsl:when test="substring($stylevalue,string-length($stylevalue),1) != ';'">
                                                <xsl:value-of select="concat($stylevalue,';')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$stylevalue"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="fo:font-style">
                                    <xsl:value-of select="'italic'"/>
                                </xsl:attribute>
                                <xsl:attribute name="style:text-underline-type">
                                    <xsl:value-of select="'single'"/>
                                </xsl:attribute>
                                <xsl:attribute name="style:text-underline-color">
                                    <xsl:value-of select="'font-color'"/>
                                </xsl:attribute>
                                <xsl:attribute name="fo:font-weight">
                                    <xsl:value-of select="'bold'"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@ss:Name">
        <xsl:attribute name="style:display-name">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="recursion-condformat-style-table-cell">
        <!-- generates style:style for ConditionalFormatting -->
        <xsl:param name="style-value-t"/>
        <xsl:variable name="style-value" select="normalize-space($style-value-t)"/>
        <xsl:choose>
            <xsl:when test="starts-with($style-value,'background')">
                <xsl:choose>
                    <xsl:when test="contains($style-value,'mso-pattern')">
                        <xsl:variable name="color-value">
                            <xsl:call-template name="translate-color-style">
                                <xsl:with-param name="source-str" select="normalize-space(substring-before(substring-after($style-value,':'),';'))"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="mso-value">
                            <xsl:call-template name="translate-color-style">
                                <xsl:with-param name="source-str" select="normalize-space(substring-after($style-value,'mso-pattern'))"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="mso-color" select="substring-after($mso-value,'#')"/>
                        <xsl:variable name="pattern-color-value" select="substring($mso-color,1,6)"/>
                        <xsl:variable name="pattern" select="concat('0.',normalize-space(substring-before(substring-after($mso-color,'gray-'),';')))"/>
                        <xsl:variable name="pattern-color">
                            <xsl:call-template name="cell-pattern-color">
                                <xsl:with-param name="pattern" select="$pattern"/>
                                <xsl:with-param name="color-value" select="$color-value"/>
                                <xsl:with-param name="pattern-color-value" select="concat('#',$pattern-color-value)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="fo:background-color">
                            <xsl:value-of select="normalize-space($pattern-color)"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="fo:background-color">
                            <xsl:call-template name="translate-color-style">
                                <xsl:with-param name="source-str" select="normalize-space(substring-before(substring-after($style-value,':'),';'))"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with($style-value,'border')">
                <xsl:attribute name="fo:border">
                    <xsl:value-of select="'0.002cm solid #000000'"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="contains($style-value,':')">
            <xsl:call-template name="recursion-condformat-style-table-cell">
                <xsl:with-param name="style-value-t" select="substring-after($style-value,';')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="recursion-condformat-style-text">
        <!-- generates style:style for ConditionalFormatting -->
        <xsl:param name="style-value-t"/>
        <xsl:variable name="style-value" select="normalize-space($style-value-t)"/>
        <xsl:choose>
            <xsl:when test="starts-with($style-value,'color')">
                <xsl:attribute name="fo:color">
                    <xsl:call-template name="translate-color-style">
                        <xsl:with-param name="source-str" select="normalize-space(substring-before(substring-after($style-value,':'),';'))"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="starts-with($style-value,'font-style')">
                <xsl:attribute name="fo:font-style">
                    <xsl:value-of select="normalize-space(substring-before(substring-after($style-value,':'),';'))"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="starts-with($style-value,'font-weight')">
                <xsl:variable name="font-weight" select="normalize-space(substring-before(substring-after($style-value,':'),';'))"/>
                <xsl:attribute name="fo:font-weight">
                    <xsl:choose>
                        <xsl:when test="($font-weight &gt; 300) and ($font-weight &lt; 500)">
                            <xsl:value-of select="'normal'"/>
                        </xsl:when>
                        <xsl:when test="($font-weight &gt; 500) or ($font-weight = 500)">
                            <xsl:value-of select="'bold'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'0'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="starts-with($style-value,'text-underline-style')">
                <xsl:attribute name="style:text-underline-type">
                    <xsl:value-of select="normalize-space(substring-before(substring-after($style-value,':'),';'))"/>
                </xsl:attribute>
                <xsl:attribute name="style:text-underline-color">
                    <xsl:value-of select="'#000000'"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="contains($style-value,':')">
            <xsl:call-template name="recursion-condformat-style-text">
                <xsl:with-param name="style-value-t" select="substring-after($style-value,';')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="translate-color-style">
        <!-- translate the word of color to hex code of color -->
        <xsl:param name="source-str"/>
        <xsl:choose>
            <xsl:when test="starts-with($source-str,'#')">
                <xsl:value-of select="$source-str"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with($source-str,'black')">
                        <xsl:value-of select="'#000000'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'maroon')">
                        <xsl:value-of select="'#800000'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'red')">
                        <xsl:value-of select="'#FF0000'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'fuchsia')">
                        <xsl:value-of select="'#FF00FF'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'olive')">
                        <xsl:value-of select="'#808000'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'yellow')">
                        <xsl:value-of select="'#FFFF00'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'green')">
                        <xsl:value-of select="'#008000'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'lime')">
                        <xsl:value-of select="'#00FF00'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'teal')">
                        <xsl:value-of select="'#008080'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'aqua')">
                        <xsl:value-of select="'#00FFFF'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'navy')">
                        <xsl:value-of select="'#000080'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'blue')">
                        <xsl:value-of select="'#0000FF'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'purple')">
                        <xsl:value-of select="'#800080'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'gray')">
                        <xsl:value-of select="'#808080'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'silver')">
                        <xsl:value-of select="'#C0C0C0'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'white')">
                        <xsl:value-of select="'#FFFFFF'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'#FFFFFF'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:key name="definedStyleIds" match="/ss:Workbook/ss:Styles/ss:Style/@ss:ID" use="string(.)"/>
    <xsl:variable name="defaultStyle" select="/ss:Workbook/ss:Styles/ss:Style[@ss:ID='Default']/@ss:ID"></xsl:variable>
    <xsl:key name="styleId" match="@ss:StyleID" use="."/>
    <xsl:template name="CondFormat_automatic_style">
        <!-- For each conditionalFormatting We inject a new style, which is a child of the current found style -->
        <xsl:for-each select="/ss:Workbook/ss:Worksheet[x:ConditionalFormatting]">
            <xsl:variable name="table-pos" select="count(preceding-sibling::ss:Worksheet)+1"/>
            <xsl:variable name="styleIdsUsedByTable" select="$defaultStyle | key('definedStyleIds', ss:Table/ss:Row/ss:Cell/@ss:StyleID)"/>
            <xsl:for-each select="x:ConditionalFormatting">
                <xsl:variable name="conditions" select="position()"/>
                <xsl:variable name="conditionalFormatting" select="."/>
                <!-- we want to loop over the distinct styleId attribute values of all cells within the table related to the current conditional formatting. -->
                <!-- We'd need to add the anonymous style id "Default" to the mix. -->
                <!-- for all 'ssStyle/@ss:ID's, which are in tables connected within this conditional formatting  -->
                <!-- <xsl:for-each select="key('tableStyleIDs', generate-id(preceding-sibling::ss:Table)) [generate-id(.) = generate-id(key('styleId', .)[1])] "> -->
                <xsl:for-each select="$styleIdsUsedByTable">
                    <xsl:element name="style:style">
                        <xsl:attribute name="style:name">
                            <xsl:call-template name="encode-as-nc-name">
                                <xsl:with-param name="string" select="concat(.,'-ce',$table-pos,'-',$conditions)"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:attribute name="style:family">table-cell</xsl:attribute>
                        <xsl:variable name="style" select="key('Style', .)" />
                        <xsl:choose>
                            <xsl:when test="$style/@ss:Name">
                                <xsl:attribute name="style:parent-style-name">
                                    <xsl:call-template name="encode-as-nc-name">
                                        <xsl:with-param name="string" select="."/>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:when>
                            <!-- as we create an automatic style, the parent is not allowed to be an automatic style as well
                                if the parent would be an automatic (unnamed) style, the style information have to be embedded to this style -->
                            <xsl:otherwise>
                                <xsl:attribute name="style:parent-style-name">
                                    <xsl:call-template name="encode-as-nc-name">
                                        <xsl:with-param name="string" select="$style/@ss:Parent"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:if test="$style/ss:NumberFormat/@ss:Format">
                                    <xsl:attribute name="style:data-style-name">
                                        <xsl:value-of select="concat($style/@ss:ID, 'F')"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:apply-templates select="$style" mode="style-style-content"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:for-each select="$conditionalFormatting/x:Condition">
                            <xsl:variable name="condition-number" select="count(preceding-sibling::x:Condition)+1"/>
                            <xsl:variable name="base-address">
                                <xsl:choose>
                                    <xsl:when test="contains(../x:Range,',')">
                                        <xsl:choose>
                                            <xsl:when test="contains(substring-before(../x:Range,','),':')">
                                                <xsl:value-of select="substring-before(substring-after(../x:Range,':'),',')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="substring-before(../x:Range,',')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="../x:Range"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="columnNumber">
                                <xsl:choose>
                                    <xsl:when test="contains($base-address, ':')">
                                        <xsl:value-of select="substring-after(substring-after($base-address, ':'),'C')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-after($base-address,'C')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="rowNumber">
                                <xsl:choose>
                                    <xsl:when test="contains($base-address, ':')">
                                        <xsl:value-of select="substring-before(substring-after(substring-after($base-address, ':'),'R'),'C')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-before(substring-after($base-address,'R'),'C')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="base-cell-address">
                                <xsl:call-template name="translate-unit">
                                    <xsl:with-param name="column-number" select="$columnNumber"/>
                                    <xsl:with-param name="row-number" select="$rowNumber"/>
                                    <xsl:with-param name="column-pos-style" select="'relative'"/>
                                    <xsl:with-param name="row-pos-style" select="'relative'"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="condition-value">
                                <xsl:call-template name="translate-condition">
                                    <xsl:with-param name="cell-column-pos" select="$columnNumber"/>
                                    <xsl:with-param name="cell-row-pos" select="$rowNumber"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:element name="style:map">
                                <xsl:attribute name="style:condition">
                                    <xsl:value-of select="$condition-value"/>
                                </xsl:attribute>
                                <xsl:attribute name="style:apply-style-name">
                                    <xsl:value-of select="concat('Excel_CondFormat_',$table-pos,'_',$conditions,'_',$condition-number)"/>
                                </xsl:attribute>
                                <xsl:attribute name="style:base-cell-address">
                                    <xsl:value-of select="concat(../../@ss:Name,'.',$base-cell-address)"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="translate-condition">
        <xsl:param name="cell-row-pos"/>
        <xsl:param name="cell-column-pos"/>
        <!-- translates the condition to generate formula -->
        <xsl:variable name="address-value">
            <xsl:call-template name="translate-expression">
                <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                <xsl:with-param name="expression" select="x:Value1"/>
                <xsl:with-param name="return-value" select="''"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="x:Qualifier">
                <xsl:variable name="qualifier" select="x:Qualifier"/>
                <xsl:variable name="first-value" select="x:Value1"/>
                <xsl:choose>
                    <xsl:when test="$qualifier = 'Between'">
                        <xsl:variable name="second-value">
                            <xsl:call-template name="translate-expression">
                                <xsl:with-param name="cell-row-pos" select="0"/>
                                <xsl:with-param name="cell-column-pos" select="0"/>
                                <xsl:with-param name="expression" select="x:Value2"/>
                                <xsl:with-param name="return-value" select="''"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat('cell-content-is-between(',$address-value,',',$second-value,')')"/>
                    </xsl:when>
                    <xsl:when test="$qualifier = 'NotBetween'">
                        <xsl:variable name="second-value">
                            <xsl:call-template name="translate-expression">
                                <xsl:with-param name="cell-row-pos" select="0"/>
                                <xsl:with-param name="cell-column-pos" select="0"/>
                                <xsl:with-param name="expression" select="x:Value2"/>
                                <xsl:with-param name="return-value" select="''"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat('cell-content-is-not-between(',$address-value,',',$second-value,')')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="translatedQualifier">
                            <xsl:choose>
                                <xsl:when test="$qualifier = 'Equal'">=</xsl:when>
                                <xsl:when test="$qualifier = 'Less'">&lt;</xsl:when>
                                <xsl:when test="$qualifier = 'Greater'">&gt;</xsl:when>
                                <xsl:when test="$qualifier = 'LessOrEqual'">&lt;=</xsl:when>
                                <xsl:when test="$qualifier = 'GreaterOrEqual'">&gt;=</xsl:when>
                                <xsl:when test="$qualifier = 'NotEqual'">!=</xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="concat('cell-content()', $translatedQualifier, $address-value)"/>
                    </xsl:otherwise>

                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('is-true-formula(',$address-value,')')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Used in case of 'style:map', conditional formatting, where a style references to another -->
    <xsl:key match="/ss:Workbook/ss:Worksheet/ss:Table/ss:Row/ss:Cell" name="cells" use="@ss:StyleID"/>
    <xsl:template match="ss:NumberFormat">
        <xsl:variable name="unit-count" select="string-length(@ss:Format) - string-length(translate(@ss:Format,';','')) + 1"/>
        <xsl:variable name="proto-style-id" select="../@ss:ID"/>
        <xsl:call-template name="process-number-format-unit">
            <xsl:with-param name="number-format-unit" select="@ss:Format"/>
            <xsl:with-param name="style-id" select="concat($proto-style-id,'F')"/>
            <xsl:with-param name="format-type" select="key('cells', $proto-style-id)/ss:Data/@ss:Type"/>
            <xsl:with-param name="total-unit" select="$unit-count"/>
            <xsl:with-param name="current-unit" select="0"/>
        </xsl:call-template>
    </xsl:template>
    <!-- Note: conditions appearing only once at the beginning are mixed with others -->
    <xsl:template name="process-number-format-unit">
        <xsl:param name="number-format-unit"/>
        <xsl:param name="style-id"/>
        <xsl:param name="format-type"/>
        <xsl:param name="total-unit"/>
        <xsl:param name="current-unit"/>
        <xsl:choose>
            <!-- if total-unit > 1 and the last unit is just @, delete it -->
            <xsl:when test="$current-unit = 0 and $total-unit &gt; 1 and substring( $number-format-unit, string-length($number-format-unit) - 1) = ';@'">
                <xsl:call-template name="process-number-format-unit">
                    <xsl:with-param name="number-format-unit" select="substring( $number-format-unit, 1, string-length($number-format-unit) - 2)"/>
                    <xsl:with-param name="style-id" select="$style-id"/>
                    <xsl:with-param name="format-type" select="$format-type"/>
                    <xsl:with-param name="total-unit" select="$total-unit - 1"/>
                    <xsl:with-param name="current-unit" select="0"/>
                </xsl:call-template>
            </xsl:when>
            <!-- $number-format-unit enum values: General, General Number, General Date, Long Date, Medium Date, Short Date, Long Time,
             Medium Time, Short Time, Currency, Euro Currency, Fixed, Standard, Percent, Scientific, Yes/No, True/False, On/Off -->
            <xsl:when test="$number-format-unit = 'Currency'">
                <number:currency-style style:name="{concat( $style-id, 'P1')}" style:volatile="true">
                    <number:text>$</number:text>
                    <number:number number:decimal-places="2" number:min-integer-digits="1" number:grouping="true"/>
                </number:currency-style>
                <number:currency-style style:name="{$style-id}">
                    <style:text-properties fo:color="#ff0000"/>
                    <number:text>$-</number:text>
                    <number:number number:decimal-places="2" number:min-integer-digits="1" number:grouping="true"/>
                    <style:map style:condition="value()&gt;=0" style:apply-style-name="{concat( $style-id, 'P1')}"/>
                </number:currency-style>
            </xsl:when>
            <xsl:when test="$number-format-unit = 'Euro Currency'">
                <number:currency-style style:name="{concat( $style-id, 'P1')}" style:volatile="true">
                    <number:text>€ </number:text>
                    <number:number number:decimal-places="2" number:min-integer-digits="1" number:grouping="true"/>
                </number:currency-style>
                <number:currency-style style:name="{$style-id}">
                    <style:text-properties fo:color="#ff0000"/>
                    <number:text>(€ </number:text>
                    <number:number number:decimal-places="2" number:min-integer-digits="1" number:grouping="true"/>
                    <number:text>)</number:text>
                    <style:map style:condition="value()&gt;=0" style:apply-style-name="{concat( $style-id, 'P1')}"/>
                </number:currency-style>
            </xsl:when>
            <xsl:when test="$number-format-unit = 'Yes/No' or $number-format-unit = 'True/False' or $number-format-unit = 'On/Off'">
                <xsl:variable name="left-code" select="substring-before( $number-format-unit, '/')"/>
                <xsl:variable name="right-code" select="substring-after( $number-format-unit, '/')"/>
                <number:number-style style:name="{concat( $style-id, 'P1')}" style:volatile="true">
                    <number:text>
                        <xsl:value-of select="$left-code"/>
                    </number:text>
                </number:number-style>
                <number:number-style style:name="{concat( $style-id, 'P2')}" style:volatile="true">
                    <number:text>
                        <xsl:value-of select="$left-code"/>
                    </number:text>
                </number:number-style>
                <number:number-style style:name="{$style-id}">
                    <number:text>
                        <xsl:value-of select="$right-code"/>
                    </number:text>
                    <style:map style:condition="value()&gt;0" style:apply-style-name="{concat( $style-id, 'P1')}"/>
                    <style:map style:condition="value()&lt;0" style:apply-style-name="{concat( $style-id, 'P2')}"/>
                </number:number-style>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$total-unit &gt; 1 and $current-unit = 0">
                    <!-- still complete number format string of multiple sub-formats, split them out -->
                    <xsl:call-template name="process-number-format-unit">
                        <xsl:with-param name="number-format-unit" select="substring-before($number-format-unit,';')"/>
                        <xsl:with-param name="style-id" select="concat($style-id,'P1')"/>
                        <xsl:with-param name="format-type" select="$format-type"/>
                        <xsl:with-param name="total-unit" select="$total-unit"/>
                        <xsl:with-param name="current-unit" select="1"/>
                    </xsl:call-template>
                    <xsl:if test="$total-unit &gt; 2">
                        <xsl:call-template name="process-number-format-unit">
                            <xsl:with-param name="number-format-unit" select="substring-before(substring-after($number-format-unit,';'),';')"/>
                            <xsl:with-param name="style-id" select="concat($style-id,'P2')"/>
                            <xsl:with-param name="format-type" select="$format-type"/>
                            <xsl:with-param name="total-unit" select="$total-unit"/>
                            <xsl:with-param name="current-unit" select="2"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$total-unit &gt; 3">
                        <!-- four sub number format -->
                        <xsl:call-template name="process-number-format-unit">
                            <xsl:with-param name="number-format-unit" select="substring-before(substring-after(substring-after($number-format-unit,';'),';'),';')"/>
                            <xsl:with-param name="style-id" select="concat($style-id,'P3')"/>
                            <xsl:with-param name="format-type" select="$format-type"/>
                            <xsl:with-param name="total-unit" select="$total-unit"/>
                            <xsl:with-param name="current-unit" select="3"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:if>
                <!-- symbol number format converted, below deal with ordinary number formatting -->
                <xsl:variable name="current-number-format-unit">
                    <xsl:choose>
                        <xsl:when test="$total-unit = 1 and $current-unit = 0">
                            <xsl:value-of select="$number-format-unit"/>
                        </xsl:when>
                        <xsl:when test="$total-unit = 2 and $current-unit = 0">
                            <xsl:value-of select="substring-after($number-format-unit,';')"/>
                        </xsl:when>
                        <xsl:when test="$total-unit = 3 and $current-unit = 0">
                            <xsl:value-of select="substring-after(substring-after($number-format-unit,';'),';')"/>
                        </xsl:when>
                        <xsl:when test="$current-unit = 0">
                            <!-- the forth sub number format -->
                            <xsl:value-of select="substring-after(substring-after(substring-after($number-format-unit,';'),';'),';')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- not the default sub number format, glu -->
                            <xsl:value-of select="$number-format-unit"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="style-type-name">
                    <xsl:choose>
                        <xsl:when test="($format-type = 'Number' and contains($current-number-format-unit,'[$') and not(contains($current-number-format-unit,'[$-') ) ) or contains($current-number-format-unit,'Currency') ">number:currency-style</xsl:when>
                        <xsl:when test="($format-type = 'Number' and (contains($current-number-format-unit,'%') or contains($current-number-format-unit, 'Percent') ) ) or contains($current-number-format-unit,'Percent') ">number:percentage-style</xsl:when>
                        <xsl:when test="($format-type = 'DateTime' or $format-type = 'String') and (contains($current-number-format-unit,'y') or contains($current-number-format-unit,'g') or contains($current-number-format-unit,'d') or contains($current-number-format-unit, 'Date') )">number:date-style</xsl:when>
                        <xsl:when test="($format-type = 'DateTime' or $format-type = 'String') and ( contains($current-number-format-unit,'h') or contains($current-number-format-unit,'m') or contains($current-number-format-unit,'s') or contains($current-number-format-unit, 'Time') )">number:time-style</xsl:when>
                        <xsl:when test="contains($current-number-format-unit, 'Number') or contains($current-number-format-unit, 'General') or contains($current-number-format-unit, 'Fixed') or contains($current-number-format-unit, 'Standard') or contains($current-number-format-unit, 'Scientific') or ( contains($current-number-format-unit,'#') or contains($current-number-format-unit,'0') or contains($current-number-format-unit,'?') )">number:number-style</xsl:when>
                        <xsl:when test="$format-type = 'Boolean'">number:boolean-style</xsl:when>
                        <xsl:otherwise>number:text-style</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="{$style-type-name}">
                    <xsl:attribute name="style:name">
                        <xsl:value-of select="$style-id"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@ss:Name" />
                    <!-- removed in OASIS XML
                    <xsl:attribute name="style:family">data-style</xsl:attribute>-->
                    <xsl:if test="$current-unit &gt; 0">
                        <xsl:attribute name="style:volatile">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="contains ( $current-number-format-unit, '[h]') or contains ( $current-number-format-unit, '[m]') or contains ( $current-number-format-unit, '[s]')">
                        <xsl:attribute name="number:truncate-on-overflow">false</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="contains($current-number-format-unit,'[$') or contains($current-number-format-unit, '[DBNum')">
                        <xsl:call-template name="create-language-country-attribute">
                            <xsl:with-param name="attribute-code" select="substring-before(substring-after(substring-after($current-number-format-unit,'[$'),'-'),']')"/>
                            <xsl:with-param name="number-code-style" select="substring-before( substring-after($current-number-format-unit,'[DBNum'),']')"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="contains( $current-number-format-unit, '[')">
                        <xsl:element name="style:text-properties">
                            <xsl:choose>
                                <xsl:when test="contains( $current-number-format-unit, '[Red')">
                                    <xsl:attribute name="fo:color">#ff0000</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="contains( $current-number-format-unit, '[Black')">
                                    <xsl:attribute name="fo:color">#000000</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="contains( $current-number-format-unit, '[Blue')">
                                    <xsl:attribute name="fo:color">#0000ff</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="contains( $current-number-format-unit, '[Cyan')">
                                    <xsl:attribute name="fo:color">#00ffff</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="contains( $current-number-format-unit, '[Green')">
                                    <xsl:attribute name="fo:color">#00ff00</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="contains( $current-number-format-unit, '[Magenta')">
                                    <xsl:attribute name="fo:color">#ff00ff</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="contains( $current-number-format-unit, '[White')">
                                    <xsl:attribute name="fo:color">#ffffff</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="contains( $current-number-format-unit, '[Yellow')">
                                    <xsl:attribute name="fo:color">#ffff00</xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:if>
                    <!-- the type of condition-pos:1,the former third part of General; 2, the last General. the methods handling different -->
                    <xsl:call-template name="create-number-format-content">
                        <xsl:with-param name="style-type-name" select="$style-type-name"/>
                        <xsl:with-param name="number-format-unit" select="$current-number-format-unit"/>
                        <xsl:with-param name="unit-pos" select="1"/>
                        <xsl:with-param name="condition-pos">
                            <xsl:choose>
                                <xsl:when test="$current-unit = 1 or $current-unit = 2 or $current-unit = 3">
                                    <xsl:value-of select="1"/>
                                </xsl:when>
                                <xsl:when test="$current-unit = 0 and not(contains($number-format-unit, ';'))">
                                    <xsl:value-of select="1"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="2"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                    <!-- create style:map for other sub number formats -->
                    <xsl:if test="$current-unit = 0 and $total-unit &gt; 1">
                        <xsl:variable name="style-condition1">
                            <xsl:call-template name="get-number-format-condition">
                                <xsl:with-param name="number-format-unit" select="substring-before($number-format-unit,';')"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="string-length($style-condition1) &gt; 0">
                                <style:map style:condition="{concat('value()',$style-condition1)}" style:apply-style-name="{concat($style-id,'P1')}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$total-unit = 2">
                                        <style:map style:condition="value()&gt;=0" style:apply-style-name="{concat($style-id,'P1')}"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <style:map style:condition="value()&gt;0" style:apply-style-name="{concat($style-id,'P1')}"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="$total-unit &gt; 2">
                            <xsl:variable name="style-condition2">
                                <xsl:call-template name="get-number-format-condition">
                                    <xsl:with-param name="number-format-unit" select="substring-before(substring-after($number-format-unit,';'),';')"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="string-length($style-condition2) &gt; 0">
                                    <style:map style:condition="{concat('value()',$style-condition2)}" style:apply-style-name="{concat($style-id,'P2')}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <style:map style:condition="value()&lt;0" style:apply-style-name="{concat($style-id,'P2')}"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="$total-unit &gt; 3">
                            <!-- four sub number formats, glu -->
                            <xsl:variable name="style-condition3">
                                <xsl:call-template name="get-number-format-condition">
                                    <xsl:with-param name="number-format-unit" select="substring-before(substring-after(substring-after($number-format-unit,';'),';'),';')"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="string-length($style-condition3) &gt; 0">
                                    <style:map style:condition="{concat('value()',$style-condition3)}" style:apply-style-name="{concat($style-id,'P3')}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <style:map style:condition="value()=0" style:apply-style-name="{concat($style-id,'P3')}"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:if>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="create-language-country-attribute">
        <xsl:param name="attribute-code"/>
        <xsl:param name="number-code-style"/>
        <!-- convert Microsoft List of Locale ID (LCID) to language and country codes according to ISO-639 and ISO-3166.
            Reference:
            http://www.loc.gov/standards/iso639-2/langcodes.html
            http://etext.lib.virginia.edu/tei/iso639.html
            http://nl.ijs.si/gnusl/cee/std/ISO_3166.html
            http://xml.coverpages.org/ripe3166.txt
            http://www.worldlanguage.com/
            http://www.ethnologue.com/
        glu -->
        <!-- the variables of language-country-code and number-shape-code transformed to decimal format -->
        <xsl:variable name="language-country-code">
            <xsl:variable name="temp-code">
                <xsl:choose>
                    <xsl:when test="string-length($attribute-code) &lt;= 4">
                        <xsl:value-of select="$attribute-code"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring($attribute-code,string-length($attribute-code) - 3)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="$temp-code"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="string-length($temp-code)"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($attribute-code) &gt; 4 or string-length($number-code-style) &gt; 0">
            <xsl:variable name="number-shape-code">
                <xsl:variable name="temp-code">
                    <xsl:choose>
                        <xsl:when test="string-length($attribute-code) &gt; 4">
                            <xsl:value-of select="substring($attribute-code, 1, string-length($attribute-code) - 6)"/>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="hex2decimal">
                    <xsl:with-param name="hex-number" select="$temp-code"/>
                    <xsl:with-param name="index" select="1"/>
                    <xsl:with-param name="str-length" select="string-length($temp-code)"/>
                    <xsl:with-param name="last-value" select="0"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="number:transliteration-style">long</xsl:attribute>
            <xsl:choose>
                <!-- Western, #01 -->
                <xsl:when test="$number-shape-code = 1"/>
                <!-- Arabic Indic, #02 -->
                <xsl:when test="$number-shape-code = 2"/>
                <!-- Extended Arabic Indic, #03 -->
                <xsl:when test="$number-shape-code = 3"/>
                <!-- Devanagari (Sanskrit - India), #04-->
                <xsl:when test="$number-shape-code = 4">
                    <xsl:attribute name="number:transliteration-language">sa</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">IN</xsl:attribute>
                </xsl:when>
                <!-- Bengali (India), #05 -->
                <xsl:when test="$number-shape-code = 5">
                    <xsl:attribute name="number:transliteration-language">bn</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">IN</xsl:attribute>
                </xsl:when>
                <!-- Gurmukhi (Punjabi - India), #06 -->
                <xsl:when test="$number-shape-code = 6">
                    <xsl:attribute name="number:transliteration-language">pa</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">IN</xsl:attribute>
                </xsl:when>
                <!-- Gujarati (India), #07 -->
                <xsl:when test="$number-shape-code = 7">
                    <xsl:attribute name="number:transliteration-language">gu</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">IN</xsl:attribute>
                </xsl:when>
                <!-- Odia (India), #08 -->
                <xsl:when test="$number-shape-code = 8">
                    <xsl:attribute name="number:transliteration-language">or</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">IN</xsl:attribute>
                </xsl:when>
                <!-- Tamil (India), #09 -->
                <xsl:when test="$number-shape-code = 9">
                    <xsl:attribute name="number:transliteration-language">ta</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">IN</xsl:attribute>
                </xsl:when>
                <!-- Telugu (India), #0a -->
                <xsl:when test="$number-shape-code = 10">
                    <xsl:attribute name="number:transliteration-language">te</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">IN</xsl:attribute>
                </xsl:when>
                <!-- Kannada (India), #0b -->
                <xsl:when test="$number-shape-code = 11">
                    <xsl:attribute name="number:transliteration-language">kn</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">IN</xsl:attribute>
                </xsl:when>
                <!-- Malayalam (India), #0c -->
                <xsl:when test="$number-shape-code = 12">
                    <xsl:attribute name="number:transliteration-language">ml</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">IN</xsl:attribute>
                </xsl:when>
                <!-- Thai, #0d -->
                <xsl:when test="$number-shape-code = 13">
                    <xsl:attribute name="number:transliteration-language">th</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">TH</xsl:attribute>
                </xsl:when>
                <!-- Lao, #0e -->
                <xsl:when test="$number-shape-code = 14">
                    <xsl:attribute name="number:transliteration-language">lo</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">LA</xsl:attribute>
                </xsl:when>
                <!-- Tibetan (China), #0f -->
                <xsl:when test="$number-shape-code = 15">
                    <xsl:attribute name="number:transliteration-language">bo</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">CN</xsl:attribute>
                </xsl:when>
                <!-- Myanmar (Burma), #10 -->
                <xsl:when test="$number-shape-code = 16">
                    <xsl:attribute name="number:transliteration-language">my</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">MM</xsl:attribute>
                </xsl:when>
                <!-- Ethiopic (Geez), #11 -->
                <xsl:when test="$number-shape-code = 17">
                    <xsl:attribute name="number:transliteration-language">gez</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">ET</xsl:attribute>
                </xsl:when>
                <!-- Khmer (Cambodian), #12-->
                <xsl:when test="$number-shape-code = 18">
                    <xsl:attribute name="number:transliteration-language">km</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">KH</xsl:attribute>
                </xsl:when>
                <!-- Mongolian, #13 -->
                <xsl:when test="$number-shape-code = 19">
                    <xsl:attribute name="number:transliteration-language">mn</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">CN</xsl:attribute>
                </xsl:when>
                <!-- Japanese 1 ([DBNum1]) , #1b, #0411 -->
                <xsl:when test="$number-shape-code = 27 or ($number-code-style = '1' and $language-country-code = 1041)">
                    <xsl:attribute name="number:transliteration-format">一</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">ja</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">JP</xsl:attribute>
                </xsl:when>
                <!-- Japanese 2 ([DBNum2]) ,#1c, #0411 -->
                <xsl:when test="$number-shape-code = 28 or ($number-code-style = '2' and $language-country-code = 1041 )">
                    <xsl:attribute name="number:transliteration-format">壹</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">ja</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">JP</xsl:attribute>
                </xsl:when>
                <!-- Japanese 3 ([DBNum3]), #1d, #0411 -->
                <xsl:when test="$number-shape-code = 29 or ($number-code-style = '3' and $language-country-code = 1041 )">
                    <xsl:attribute name="number:transliteration-format">１</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">ja</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">JP</xsl:attribute>
                </xsl:when>
                <!-- Simplified Chinese 1 ([DBNum1]), #1e, #0804 -->
                <xsl:when test="$number-shape-code = 30 or ($number-code-style = '1' and $language-country-code = 2052 )">
                    <xsl:attribute name="number:transliteration-format">一</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">zh</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">CN</xsl:attribute>
                </xsl:when>
                <!-- Simplified Chinese 2 ([DBNum2]),#1f,#0804 -->
                <xsl:when test="$number-shape-code = 31 or ($number-code-style = '2' and $language-country-code = 2052 )">
                    <xsl:attribute name="number:transliteration-format">壹</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">zh</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">CN</xsl:attribute>
                </xsl:when>
                <!-- Simplified Chinese 3 ([DBNum3]), #20,#0804 -->
                <xsl:when test="$number-shape-code = 32 or ($number-code-style = '3' and $language-country-code = 2052 )">
                    <xsl:attribute name="number:transliteration-format">１</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">zh</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">CN</xsl:attribute>
                </xsl:when>
                <!-- Traditional Chinese 1 ([DBNum1]), #21, #0404 -->
                <xsl:when test="$number-shape-code = 33 or ($number-code-style = '1' and $language-country-code = 1028 )">
                    <xsl:attribute name="number:transliteration-format">一</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">zh</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">TW</xsl:attribute>
                </xsl:when>
                <!-- Traditional Chinese 2 ([DBNum2]), #22, #0404 -->
                <xsl:when test="$number-shape-code = 34 or ($number-code-style = '2' and $language-country-code = 1028 )">
                    <xsl:attribute name="number:transliteration-format">壹</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">zh</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">TW</xsl:attribute>
                </xsl:when>
                <!-- Traditional Chinese 3 ([DBNum3]),#23, #0404  -->
                <xsl:when test="$number-shape-code = 35 or ($number-code-style = '3' and $language-country-code = 1028 )">
                    <xsl:attribute name="number:transliteration-format">１</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">zh</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">TW</xsl:attribute>
                </xsl:when>
                <!-- Korean 1 ([DBNum1]), #24, #0412 -->
                <xsl:when test="$number-shape-code = 36 or ($number-code-style = '1' and $language-country-code = 1042 )">
                    <xsl:attribute name="number:transliteration-format">一</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">ko</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">KR</xsl:attribute>
                </xsl:when>
                <!-- Korean 2 ([DBNum2]), #25, #0412 -->
                <xsl:when test="$number-shape-code = 37 or ($number-code-style = '2' and $language-country-code = 1042 )">
                    <xsl:attribute name="number:transliteration-format">壹</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">ko</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">KR</xsl:attribute>
                </xsl:when>
                <!-- Korean 3 ([DBNum3]), #26, #0412 -->
                <xsl:when test="$number-shape-code = 38 or ($number-code-style = '3' and $language-country-code = 1042 )">
                    <xsl:attribute name="number:transliteration-format">１</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">ko</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">KR</xsl:attribute>
                </xsl:when>
                <!-- Korean 4 ([DBNum4]), #27, #0412 -->
                <xsl:when test="$number-shape-code = 39 or ($number-code-style = '4' and $language-country-code = 1042 )">
                    <xsl:attribute name="number:transliteration-format">1</xsl:attribute>
                    <xsl:attribute name="number:transliteration-language">ko</xsl:attribute>
                    <xsl:attribute name="number:transliteration-country">KR</xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <!-- components of a format code: two digits  for number shape codes, two for calendar types, four for LCID -->
        <xsl:choose>
            <!-- totally 223 language-country LCID codes, manually created, among which MS Office 2003 supports 134, OOo supports 91 -->
            <xsl:when test="$language-country-code = 1078">
                <!-- Afrikaans - South Africa, #0436 -->
                <xsl:attribute name="number:language">af</xsl:attribute>
                <xsl:attribute name="number:country">ZA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1052">
                <!-- Albanian - Albania, #041c -->
                <xsl:attribute name="number:language">sq</xsl:attribute>
                <xsl:attribute name="number:country">AL</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1118">
                <!-- Amharic - Ethiopia, #045e -->
                <xsl:attribute name="number:language">am</xsl:attribute>
                <xsl:attribute name="number:country">ET</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1025">
                <!-- Arabic - Saudi Arabia, #0401 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">SA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 5121">
                <!-- Arabic - Algeria, #1401 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">DZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 15361">
                <!-- Arabic - Bahrain, #3c01 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">BH</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 3073">
                <!-- Arabic - Egypt, #0c01 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">EG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2049">
                <!-- Arabic - Iraq, #0801 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">IQ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 11265">
                <!-- Arabic - Jordan, #2c01 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">JO</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 13313">
                <!-- Arabic - Kuwait, #3401 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">KW</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 12289">
                <!-- Arabic - Lebanon, #3001 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">LB</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 4097">
                <!-- Arabic - Libya, #1001 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">LY</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 6145">
                <!-- Arabic - Morocco, #1801 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">MA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 8193">
                <!-- Arabic - Oman, #2001 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">OM</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 16385">
                <!-- Arabic - Qatar, #4001 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">QA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 10241">
                <!-- Arabic - Syria, #2801 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">SY</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 7169">
                <!-- Arabic - Tunisia, #1c01 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">TN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 14337">
                <!-- Arabic - U.A.E., #3801 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">AE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 9217">
                <!-- Arabic - Yemen, #2401 -->
                <xsl:attribute name="number:language">ar</xsl:attribute>
                <xsl:attribute name="number:country">YE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1067">
                <!-- Armenian - Armenia, #042b -->
                <xsl:attribute name="number:language">hy</xsl:attribute>
                <xsl:attribute name="number:country">AM</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1101">
                <!-- Assamese, #044d -->
                <xsl:attribute name="number:language">as</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2092">
                <!-- Azeri - Cyrillic, #082c -->
                <xsl:attribute name="number:language">az</xsl:attribute>
                <xsl:attribute name="number:country">AZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1068">
                <!-- Azeri - Latin, #042c -->
                <xsl:attribute name="number:language">az</xsl:attribute>
                <xsl:attribute name="number:country">AZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1069">
                <!-- Basque - France/Spain, #042d -->
                <xsl:attribute name="number:language">eu</xsl:attribute>
                <xsl:attribute name="number:country">ES</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1059">
                <!-- Belarusian - Belarus, #0423 -->
                <xsl:attribute name="number:language">be</xsl:attribute>
                <xsl:attribute name="number:country">BY</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1093">
                <!-- Bengali (India), #0445 -->
                <xsl:attribute name="number:language">bn</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2117">
                <!-- Bengali (Bangladesh), #0845 -->
                <xsl:attribute name="number:language">bn</xsl:attribute>
                <xsl:attribute name="number:country">BD</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 5146">
                <!-- Bosnian (Bosnia/Herzegovina), #141a -->
                <xsl:attribute name="number:language">bs</xsl:attribute>
                <xsl:attribute name="number:country">BA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1026">
                <!-- Bulgarian, #0402 -->
                <xsl:attribute name="number:language">bg</xsl:attribute>
                <xsl:attribute name="number:country">BG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1109">
                <!-- Burmese (Burma/Myanmar), #0455 -->
                <xsl:attribute name="number:language">my</xsl:attribute>
                <xsl:attribute name="number:country">MM</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1027">
                <!-- Catalan - Spain, #0403 -->
                <xsl:attribute name="number:language">ca</xsl:attribute>
                <xsl:attribute name="number:country">ES</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1116">
                <!-- Cherokee - United States, #045c -->
                <xsl:attribute name="number:language">chr</xsl:attribute>
                <xsl:attribute name="number:country">US</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2052">
                <!-- Chinese - People's Republic of China, #0804 -->
                <xsl:attribute name="number:language">zh</xsl:attribute>
                <xsl:attribute name="number:country">CN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 4100">
                <!-- Chinese - Singapore, #1004 -->
                <xsl:attribute name="number:language">zh</xsl:attribute>
                <xsl:attribute name="number:country">SG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1028">
                <!-- Chinese - Taiwan, #0404 -->
                <xsl:attribute name="number:language">zh</xsl:attribute>
                <xsl:attribute name="number:country">TW</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 3076">
                <!-- Chinese - Hong Kong SAR, #0c04 -->
                <xsl:attribute name="number:language">zh</xsl:attribute>
                <xsl:attribute name="number:country">HK</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 5124">
                <!-- Chinese - Macao SAR, #1404 -->
                <xsl:attribute name="number:language">zh</xsl:attribute>
                <xsl:attribute name="number:country">MO</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1050">
                <!-- Croatian (Croatia), #041a -->
                <xsl:attribute name="number:language">hr</xsl:attribute>
                <xsl:attribute name="number:country">HR</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 4122">
                <!-- Croatian (Bosnia/Herzegovina), #101a -->
                <xsl:attribute name="number:language">hr</xsl:attribute>
                <xsl:attribute name="number:country">BA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1029">
                <!-- Czech, #0405 -->
                <xsl:attribute name="number:language">cs</xsl:attribute>
                <xsl:attribute name="number:country">CZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1030">
                <!-- Danish, #0406 -->
                <xsl:attribute name="number:language">da</xsl:attribute>
                <xsl:attribute name="number:country">DK</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1125">
                <!-- Divehi, #0465 -->
                <xsl:attribute name="number:language">dv</xsl:attribute>
                <xsl:attribute name="number:country">MV</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1043">
                <!-- Dutch - Netherlands, #0413 -->
                <xsl:attribute name="number:language">nl</xsl:attribute>
                <xsl:attribute name="number:country">NL</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2067">
                <!-- Dutch - Belgium, #0813 -->
                <xsl:attribute name="number:language">nl</xsl:attribute>
                <xsl:attribute name="number:country">BE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1126">
                <!-- Edo (Bini - Nigeria), #0466 -->
                <xsl:attribute name="number:language">bin</xsl:attribute>
                <xsl:attribute name="number:country">NG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1033">
                <!-- English - United States, #0409 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">US</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2057">
                <!-- English - United Kingdom, #0809 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">GB</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 3081">
                <!-- English - Australia, #0c09 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">AU</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 10249">
                <!-- English - Belize, #2809 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">BZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 4105">
                <!-- English - Canada, #1009 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">CA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 9225">
                <!-- English - Caribbean (Cuba), #2409 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">CU</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 15369">
                <!-- English - Hong Kong SAR, #3c09 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">HK</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 16393">
                <!-- English - India, #4009 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 14345">
                <!-- English - Indonesia, #3809 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">ID</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 6153">
                <!-- English - Ireland, #1809 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">IE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 8201">
                <!-- English - Jamaica, #2009 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">JM</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 17417">
                <!-- English - Malaysia, #4409 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">MY</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 5129">
                <!-- English - New Zealand, #1409 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">NZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 13321">
                <!-- English - Philippines, #3409 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">PH</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 18441">
                <!-- English - Singapore, #4809 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">SG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 7177">
                <!-- English - South Africa, #1c09 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">ZA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 11273">
                <!-- English - Trinidad, #2c09 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">TT</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 12297">
                <!-- English - Zimbabwe, #3009 -->
                <xsl:attribute name="number:language">en</xsl:attribute>
                <xsl:attribute name="number:country">ZW</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1061">
                <!-- Estonian (Estonia), #0425 -->
                <xsl:attribute name="number:language">et</xsl:attribute>
                <xsl:attribute name="number:country">EE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1080">
                <!-- Faroese (Faroe Islands), #0438 -->
                <xsl:attribute name="number:language">fo</xsl:attribute>
                <xsl:attribute name="number:country">FO</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1065">
                <!-- Farsi (Persian/Iran), #0429 -->
                <xsl:attribute name="number:language">fa</xsl:attribute>
                <xsl:attribute name="number:country">IR</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1124">
                <!-- Filipino (Philippine), #0464 -->
                <xsl:attribute name="number:language">phi</xsl:attribute>
                <xsl:attribute name="number:country">PH</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1035">
                <!-- Finnish, #040b -->
                <xsl:attribute name="number:language">fi</xsl:attribute>
                <xsl:attribute name="number:country">FI</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1036">
                <!-- French - France, #040c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">FR</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2060">
                <!-- French - Belgium, #080c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">BE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 11276">
                <!-- French - Cameroon, #2c0c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">CM</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 3084">
                <!-- French - Canada, #0c0c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">CA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 9228">
                <!-- French - Congo, #240c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">CG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 12300">
                <!-- French - Cote d'Ivoire, #300c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">CI</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 15372">
                <!-- French - Haiti, #3c0c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">HT</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 5132">
                <!-- French - Luxembourg, #140c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">LU</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 13324">
                <!-- French - Mali, #340c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">ML</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 6156">
                <!-- French - Monaco, #180c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">MC</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 14348">
                <!-- French - Morocco, #380c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">MA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 58380">
                <!-- French - North Africa (Algeria), #e40c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">DZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 8204">
                <!-- French - Reunion, #200c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">RE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 10252">
                <!-- French - Senegal, #280c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">SN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 4108">
                <!-- French - Switzerland, #100c -->
                <xsl:attribute name="number:language">fr</xsl:attribute>
                <xsl:attribute name="number:country">CH</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1122">
                <!-- Frisian - Netherlands, #0462 -->
                <xsl:attribute name="number:language">fy</xsl:attribute>
                <xsl:attribute name="number:country">NL</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1127">
                <!-- Fulfude (Fulah) - Nigeria, #0467 -->
                <xsl:attribute name="number:language">ff</xsl:attribute>
                <xsl:attribute name="number:country">NG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1071">
                <!-- FYRO Macedonian, #042f -->
                <xsl:attribute name="number:language">mk</xsl:attribute>
                <xsl:attribute name="number:country">MK</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2108">
                <!-- Gaelic (Ireland), #083c -->
                <xsl:attribute name="number:language">gd</xsl:attribute>
                <xsl:attribute name="number:country">IE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1084">
                <!-- Gaelic (Scotland), #043c -->
                <xsl:attribute name="number:language">gd</xsl:attribute>
                <xsl:attribute name="number:country">GB</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1110">
                <!-- Galician (Gallegan) - Spain, #0456 -->
                <xsl:attribute name="number:language">gl</xsl:attribute>
                <xsl:attribute name="number:country">ES</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1079">
                <!-- Georgian - Georgia, #0437 -->
                <xsl:attribute name="number:language">ka</xsl:attribute>
                <xsl:attribute name="number:country">GE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1031">
                <!-- German - Germany, #0407 -->
                <xsl:attribute name="number:language">de</xsl:attribute>
                <xsl:attribute name="number:country">DE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 3079">
                <!-- German - Austria, #0c07 -->
                <xsl:attribute name="number:language">de</xsl:attribute>
                <xsl:attribute name="number:country">AT</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 5127">
                <!-- German - Liechtenstein, #1407 -->
                <xsl:attribute name="number:language">de</xsl:attribute>
                <xsl:attribute name="number:country">LI</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 4103">
                <!-- German - Luxembourg, #1007 -->
                <xsl:attribute name="number:language">de</xsl:attribute>
                <xsl:attribute name="number:country">LU</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2055">
                <!-- German - Switzerland, #0807 -->
                <xsl:attribute name="number:language">de</xsl:attribute>
                <xsl:attribute name="number:country">CH</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1032">
                <!-- Greek, #0408 -->
                <xsl:attribute name="number:language">el</xsl:attribute>
                <xsl:attribute name="number:country">GR</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1140">
                <!-- Guarani - Paraguay, #0474 -->
                <xsl:attribute name="number:language">gn</xsl:attribute>
                <xsl:attribute name="number:country">PY</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1095">
                <!-- Gujarati - India, #0447 -->
                <xsl:attribute name="number:language">gu</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1128">
                <!-- Hausa - Nigeria, #0468 -->
                <xsl:attribute name="number:language">ha</xsl:attribute>
                <xsl:attribute name="number:country">NG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1141">
                <!-- Hawaiian - US, #0475 -->
                <xsl:attribute name="number:language">haw</xsl:attribute>
                <xsl:attribute name="number:country">US</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1037">
                <!-- Hebrew, #040d -->
                <xsl:attribute name="number:language">he</xsl:attribute>
                <xsl:attribute name="number:country">IL</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1081">
                <!-- Hindi (India), #0439 -->
                <xsl:attribute name="number:language">hi</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1038">
                <!-- Hungarian - Hungary, #040e -->
                <xsl:attribute name="number:language">hu</xsl:attribute>
                <xsl:attribute name="number:country">HU</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1129">
                <!-- Ibibio (Niger-Kordofanian) - Nigeria, #0469 -->
                <xsl:attribute name="number:language">nic</xsl:attribute>
                <xsl:attribute name="number:country">NG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1039">
                <!-- Icelandic, #040f -->
                <xsl:attribute name="number:language">is</xsl:attribute>
                <xsl:attribute name="number:country">IS</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1136">
                <!-- Igbo - Nigeria, #0470 -->
                <xsl:attribute name="number:language">ig</xsl:attribute>
                <xsl:attribute name="number:country">NG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1057">
                <!-- Indonesian, #0421 -->
                <xsl:attribute name="number:language">id</xsl:attribute>
                <xsl:attribute name="number:country">ID</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1117">
                <!-- Inuktitut - US, #045d -->
                <xsl:attribute name="number:language">iu</xsl:attribute>
                <xsl:attribute name="number:country">US</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1040">
                <!-- Italian - Italy, #0410 -->
                <xsl:attribute name="number:language">it</xsl:attribute>
                <xsl:attribute name="number:country">IT</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2064">
                <!-- Italian - Switzerland, #0810 -->
                <xsl:attribute name="number:language">it</xsl:attribute>
                <xsl:attribute name="number:country">CH</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1041">
                <!-- Japanese, #0411 -->
                <xsl:attribute name="number:language">ja</xsl:attribute>
                <xsl:attribute name="number:country">JP</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1099">
                <!-- Kannada (India), #044b -->
                <xsl:attribute name="number:language">kn</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1137">
                <!-- Kanuri - Nigeria, #0471 -->
                <xsl:attribute name="number:language">kr</xsl:attribute>
                <xsl:attribute name="number:country">NG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2144">
                <!-- Kashmiri (India), #0860 -->
                <xsl:attribute name="number:language">ks</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1120">
                <!-- Kashmiri (Arabic), #0460 -->
                <xsl:attribute name="number:language">ks</xsl:attribute>
                <xsl:attribute name="number:country">PK</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1087">
                <!-- Kazakh, #043f -->
                <xsl:attribute name="number:language">kk</xsl:attribute>
                <xsl:attribute name="number:country">KZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1107">
                <!-- Khmer (Cambodian), #0453 -->
                <xsl:attribute name="number:language">km</xsl:attribute>
                <xsl:attribute name="number:country">KH</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1111">
                <!-- Konkani (India), #0457 -->
                <xsl:attribute name="number:language">kok</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1042">
                <!-- Korean, #0412 -->
                <xsl:attribute name="number:language">ko</xsl:attribute>
                <xsl:attribute name="number:country">KR</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1088">
                <!-- Kyrgyz ( Kirgiz / Cyrillic), #0440 -->
                <xsl:attribute name="number:language">ky</xsl:attribute>
                <xsl:attribute name="number:country">KG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1108">
                <!-- Lao, #0454 -->
                <xsl:attribute name="number:language">lo</xsl:attribute>
                <xsl:attribute name="number:country">LA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1142">
                <!-- Latin, #0476 -->
                <xsl:attribute name="number:language">la</xsl:attribute>
                <xsl:attribute name="number:country">IT</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1062">
                <!-- Latvian, #0426 -->
                <xsl:attribute name="number:language">lv</xsl:attribute>
                <xsl:attribute name="number:country">LV</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1063">
                <!-- Lithuanian, #0427 -->
                <xsl:attribute name="number:language">lt</xsl:attribute>
                <xsl:attribute name="number:country">LT</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1086">
                <!-- Malay - Malaysia, #043e -->
                <xsl:attribute name="number:language">ms</xsl:attribute>
                <xsl:attribute name="number:country">MY</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2110">
                <!-- Malay - Brunei Darussalam, #083e -->
                <xsl:attribute name="number:language">ms</xsl:attribute>
                <xsl:attribute name="number:country">BN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1071">
                <!-- Macedonian (FYROM), #042f -->
                <xsl:attribute name="number:language">mk</xsl:attribute>
                <xsl:attribute name="number:country">MK</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1100">
                <!-- Malayalam (India), #044c -->
                <xsl:attribute name="number:language">ml</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1082">
                <!-- Maltese, #043a -->
                <xsl:attribute name="number:language">mt</xsl:attribute>
                <xsl:attribute name="number:country">MT</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1112">
                <!-- Manipuri (India), #0458 -->
                <xsl:attribute name="number:language">mni</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1153">
                <!-- Maori - New Zealand, #0481 -->
                <xsl:attribute name="number:language">mi</xsl:attribute>
                <xsl:attribute name="number:country">NZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1102">
                <!-- Marathi (India), #044e -->
                <xsl:attribute name="number:language">mr</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1104">
                <!-- Mongolian (Cyrillic), #0450 -->
                <xsl:attribute name="number:language">mn</xsl:attribute>
                <xsl:attribute name="number:country">MN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2128">
                <!-- Mongolian (Mongolian), #0850 -->
                <xsl:attribute name="number:language">mn</xsl:attribute>
                <xsl:attribute name="number:country">CN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1121">
                <!-- Nepali, #0461 -->
                <xsl:attribute name="number:language">ne</xsl:attribute>
                <xsl:attribute name="number:country">NP</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2145">
                <!-- Nepali (India), #0861 -->
                <xsl:attribute name="number:language">ne</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1044">
                <!-- Norwegian (Bokmal), #0414 -->
                <xsl:attribute name="number:language">nb</xsl:attribute>
                <xsl:attribute name="number:country">NO</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2068">
                <!-- Norwegian (Nynorsk), #0814 -->
                <xsl:attribute name="number:language">nn</xsl:attribute>
                <xsl:attribute name="number:country">NO</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1096">
                <!-- Odia (India), #0448 -->
                <xsl:attribute name="number:language">or</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1138">
                <!-- Oromo (Ethiopia), #0472 -->
                <xsl:attribute name="number:language">om</xsl:attribute>
                <xsl:attribute name="number:country">ET</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1145">
                <!-- Papiamentu (Netherlands Antilles), #0479 -->
                <xsl:attribute name="number:language">pap</xsl:attribute>
                <xsl:attribute name="number:country">AN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1123">
                <!-- Pashto (Afghanistan), #0463 -->
                <xsl:attribute name="number:language">ps</xsl:attribute>
                <xsl:attribute name="number:country">AF</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1045">
                <!-- Polish, #0415 -->
                <xsl:attribute name="number:language">pl</xsl:attribute>
                <xsl:attribute name="number:country">PL</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1046">
                <!-- Portuguese - Brazil, #0416 -->
                <xsl:attribute name="number:language">pt</xsl:attribute>
                <xsl:attribute name="number:country">BR</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2070">
                <!-- Portuguese - Portugal, #0816 -->
                <xsl:attribute name="number:language">pt</xsl:attribute>
                <xsl:attribute name="number:country">PT</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1094">
                <!-- Punjabi, #0446 -->
                <xsl:attribute name="number:language">pa</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2118">
                <!-- Punjabi (Pakistan), #0846 -->
                <xsl:attribute name="number:language">pa</xsl:attribute>
                <xsl:attribute name="number:country">PK</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1131">
                <!-- Quecha - Blivia, #046b -->
                <xsl:attribute name="number:language">qu</xsl:attribute>
                <xsl:attribute name="number:country">BO</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2155">
                <!-- Quecha - Ecuador, #086b -->
                <xsl:attribute name="number:language">qu</xsl:attribute>
                <xsl:attribute name="number:country">EC</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 3179">
                <!-- Quecha - peru, #0c6b -->
                <xsl:attribute name="number:language">qu</xsl:attribute>
                <xsl:attribute name="number:country">PE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1047">
                <!-- Rhaeto-Romanic (Italy), #0417 -->
                <xsl:attribute name="number:language">rm</xsl:attribute>
                <xsl:attribute name="number:country">IT</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1048">
                <!-- Romanian, #0418 -->
                <xsl:attribute name="number:language">ro</xsl:attribute>
                <xsl:attribute name="number:country">RO</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2072">
                <!-- Romanian - Moldova, #0818 -->
                <xsl:attribute name="number:language">ro</xsl:attribute>
                <xsl:attribute name="number:country">MD</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1049">
                <!-- Russian, #0419 -->
                <xsl:attribute name="number:language">ru</xsl:attribute>
                <xsl:attribute name="number:country">RU</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2073">
                <!-- Russian - Moldova, #0819 -->
                <xsl:attribute name="number:language">ru</xsl:attribute>
                <xsl:attribute name="number:country">MD</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1083">
                <!-- Sami (Lappish), # (Northern Sami - Sweden), #043b -->
                <xsl:attribute name="number:language">se</xsl:attribute>
                <xsl:attribute name="number:country">SE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1103">
                <!-- Sanskrit (India), #044f -->
                <xsl:attribute name="number:language">sa</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1132">
                <!-- Sepedi (Northern Sotho - South Africa), #046c -->
                <xsl:attribute name="number:language">nso</xsl:attribute>
                <xsl:attribute name="number:country">ZA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 3098">
                <!-- Serbian (Cyrillic - Serbia Yugoslavia), #0c1a -->
                <xsl:attribute name="number:language">sr</xsl:attribute>
                <xsl:attribute name="number:country">YU</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2074">
                <!-- Serbian (Latin - Croatia), #081a -->
                <xsl:attribute name="number:language">sr</xsl:attribute>
                <xsl:attribute name="number:country">HR</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1113">
                <!-- Sindhi - India,#0459 -->
                <xsl:attribute name="number:language">sd</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2137">
                <!-- Sindhi - Pakistan, #0859 -->
                <xsl:attribute name="number:language">sd</xsl:attribute>
                <xsl:attribute name="number:country">PK</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1115">
                <!-- Sinhalese - Sri Lanka, #045b -->
                <xsl:attribute name="number:language">si</xsl:attribute>
                <xsl:attribute name="number:country">LK</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1051">
                <!-- Slovak, #041b -->
                <xsl:attribute name="number:language">sk</xsl:attribute>
                <xsl:attribute name="number:country">SK</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1060">
                <!-- Slovenian, #0424 -->
                <xsl:attribute name="number:language">sl</xsl:attribute>
                <xsl:attribute name="number:country">SI</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1143">
                <!-- Somali, #0477 -->
                <xsl:attribute name="number:language">so</xsl:attribute>
                <xsl:attribute name="number:country">SO</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1070">
                <!-- Sorbian, #042e -->
                <xsl:attribute name="number:language">wen</xsl:attribute>
                <xsl:attribute name="number:country">DE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 3082">
                <!-- Spanish - Spain (Modern/International Sort), #0c0a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">ES</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1034">
                <!-- Spanish - Spain (Traditional Sort), #040a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">ES</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 11274">
                <!-- Spanish - Argentina, #2c0a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">AR</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 16394">
                <!-- Spanish - Bolivia, #400a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">BO</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 13322">
                <!-- Spanish - Chile, #340a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">CL</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 9226">
                <!-- Spanish - Colombia, #240a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">CO</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 5130">
                <!-- Spanish - Costa Rica, #140a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">CR</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 7178">
                <!-- Spanish - Dominican Republic, #1c0a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">DO</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 12298">
                <!-- Spanish - Ecuador, #300a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">EC</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 17418">
                <!-- Spanish - EL Salvador, #440a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">SV</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 4106">
                <!-- Spanish - Guatemala, #100a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">GT</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 18442">
                <!-- Spanish - Honduras, #480a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">HN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 58378">
                <!-- Spanish - Latin America (Argentina), #e40a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">AR</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2058">
                <!-- Spanish - Mexico, #080a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">MX</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 19466">
                <!-- Spanish - Nicaragua, #4c0a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">NI</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 6154">
                <!-- Spanish - Panama, #180a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">PA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 15370">
                <!-- Spanish - Paraguay, #3c0a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">PY</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 10250">
                <!-- Spanish - Peru, #280a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">PE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 20490">
                <!-- Spanish - Puerto Rico, #500a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">PR</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 21514">
                <!-- Spanish - US, #540a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">US</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 14346">
                <!-- Spanish - Uruguay, #380a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">UY</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 8202">
                <!-- Spanish - Venezuela, #200a -->
                <xsl:attribute name="number:language">es</xsl:attribute>
                <xsl:attribute name="number:country">VE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1072">
                <!-- Sutu (Ngoni - Tanzania), #0430 -->
                <xsl:attribute name="number:language">bnt</xsl:attribute>
                <xsl:attribute name="number:country">TZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1089">
                <!-- Swahili (Tanzania), #0441 -->
                <xsl:attribute name="number:language">sw</xsl:attribute>
                <xsl:attribute name="number:country">TZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1053">
                <!-- Swedish (Sweden), #041d -->
                <xsl:attribute name="number:language">sv</xsl:attribute>
                <xsl:attribute name="number:country">SE</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2077">
                <!-- Swedish - Finland, #081d -->
                <xsl:attribute name="number:language">sv</xsl:attribute>
                <xsl:attribute name="number:country">FI</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1114">
                <!-- Syriac (Syria), #045a -->
                <xsl:attribute name="number:language">syr</xsl:attribute>
                <xsl:attribute name="number:country">SY</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1064">
                <!-- Tajik, #0428 -->
                <xsl:attribute name="number:language">tg</xsl:attribute>
                <xsl:attribute name="number:country">TJ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1119">
                <!-- Tamazight (Arabic), #045f -->
                <xsl:attribute name="number:language">ber</xsl:attribute>
                <xsl:attribute name="number:country">ML</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2143">
                <!-- Tamazight (Latin), #085f -->
                <xsl:attribute name="number:language">ber</xsl:attribute>
                <xsl:attribute name="number:country">MA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1097">
                <!-- Tamil (India), #0449 -->
                <xsl:attribute name="number:language">ta</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1092">
                <!-- Tatar (Russia), #0444 -->
                <xsl:attribute name="number:language">tt</xsl:attribute>
                <xsl:attribute name="number:country">RU</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1098">
                <!-- Telugu (India), #044a -->
                <xsl:attribute name="number:language">te</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1054">
                <!-- Thai, #041e -->
                <xsl:attribute name="number:language">th</xsl:attribute>
                <xsl:attribute name="number:country">TH</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2129">
                <!-- Tibetan - Bhutan, #0851 -->
                <xsl:attribute name="number:language">bo</xsl:attribute>
                <xsl:attribute name="number:country">BT</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1105">
                <!-- Tibetan - People's Republic of China, #0451 -->
                <xsl:attribute name="number:language">bo</xsl:attribute>
                <xsl:attribute name="number:country">CN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2163">
                <!-- Tigrigna (Tigrinya) - Eritrea, #0873 -->
                <xsl:attribute name="number:language">ti</xsl:attribute>
                <xsl:attribute name="number:country">ER</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1139">
                <!-- Tigrigna (Tigrinya) - Ethiopia, #0473 -->
                <xsl:attribute name="number:language">ti</xsl:attribute>
                <xsl:attribute name="number:country">ET</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1073">
                <!-- Tsonga (South Africa), #0431 -->
                <xsl:attribute name="number:language">ts</xsl:attribute>
                <xsl:attribute name="number:country">ZA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1074">
                <!-- Tswana (South Africa), #0432 -->
                <xsl:attribute name="number:language">tn</xsl:attribute>
                <xsl:attribute name="number:country">ZA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1055">
                <!-- Turkish, #041f -->
                <xsl:attribute name="number:language">tr</xsl:attribute>
                <xsl:attribute name="number:country">TR</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1090">
                <!-- Turkmen, #0442 -->
                <xsl:attribute name="number:language">tk</xsl:attribute>
                <xsl:attribute name="number:country">TM</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1152">
                <!-- Uighur - China, #0480 -->
                <xsl:attribute name="number:language">ug</xsl:attribute>
                <xsl:attribute name="number:country">CN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1058">
                <!-- Ukrainian, #0422 -->
                <xsl:attribute name="number:language">uk</xsl:attribute>
                <xsl:attribute name="number:country">UA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1056">
                <!-- Urdu (Pakistan), #0420 -->
                <xsl:attribute name="number:language">ur</xsl:attribute>
                <xsl:attribute name="number:country">PK</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2080">
                <!-- Urdu - India, #0820 -->
                <xsl:attribute name="number:language">ur</xsl:attribute>
                <xsl:attribute name="number:country">IN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 2115">
                <!-- Uzbek (Cyrillic), #0843 -->
                <xsl:attribute name="number:language">uz</xsl:attribute>
                <xsl:attribute name="number:country">UZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1091">
                <!-- Uzbek (Latin), #0443 -->
                <xsl:attribute name="number:language">uz</xsl:attribute>
                <xsl:attribute name="number:country">UZ</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1075">
                <!-- Venda (South Africa), #0433 -->
                <xsl:attribute name="number:language">ve</xsl:attribute>
                <xsl:attribute name="number:country">ZA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1066">
                <!-- Vietnamese, #042a -->
                <xsl:attribute name="number:language">vi</xsl:attribute>
                <xsl:attribute name="number:country">VN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1106">
                <!-- Welsh (UK), #0452 -->
                <xsl:attribute name="number:language">cy</xsl:attribute>
                <xsl:attribute name="number:country">UK</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1076">
                <!-- Xhosa (South Africa), #0434 -->
                <xsl:attribute name="number:language">xh</xsl:attribute>
                <xsl:attribute name="number:country">ZA</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1144">
                <!-- Yi (Sino-Tibetan - China), #0478 -->
                <xsl:attribute name="number:language">sit</xsl:attribute>
                <xsl:attribute name="number:country">CN</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1085">
                <!-- Yiddish (Jews - Israel), #043d -->
                <xsl:attribute name="number:language">yi</xsl:attribute>
                <xsl:attribute name="number:country">IL</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1130">
                <!-- Yoruba (Nigeria), #046a -->
                <xsl:attribute name="number:language">yo</xsl:attribute>
                <xsl:attribute name="number:country">NG</xsl:attribute>
            </xsl:when>
            <xsl:when test="$language-country-code = 1077">
                <!-- Zulu (South Africa), #0435 -->
                <xsl:attribute name="number:language">zu</xsl:attribute>
                <xsl:attribute name="number:country">ZA</xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-number-format-condition">
        <xsl:param name="number-format-unit"/>
        <xsl:choose>
            <xsl:when test="contains($number-format-unit, '[&gt;')">
                <xsl:value-of select="concat('&gt;', substring-before( substring-after($number-format-unit,'[&gt;'), ']'))"/>
            </xsl:when>
            <xsl:when test="contains($number-format-unit, '[&lt;')">
                <xsl:value-of select="concat('&lt;', substring-before( substring-after($number-format-unit,'[&lt;'), ']'))"/>
            </xsl:when>
            <xsl:when test="contains($number-format-unit, '[=')">
                <xsl:value-of select="concat('=', substring-before( substring-after($number-format-unit,'[='), ']'))"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="add-number-text-value">
        <xsl:param name="style-type-name"/>
        <xsl:param name="number-format-unit"/>
        <xsl:param name="unit-pos"/>
        <xsl:param name="condition-pos"/>
        <xsl:param name="isNumberTextElementOpened" select="false()"/>
        <xsl:param name="numberTextValue"/>
        <xsl:param name="posed-number-format-unit"/>
        <xsl:param name="finished" select="false()"/>
        <xsl:choose>
            <xsl:when test="not($finished)">
                <xsl:choose>
<!-- <xsl:when test="$style-type-name='number:text-style' or $style-type-name='number:date-style'"> -->
                    <xsl:when test="$style-type-name='number:text-style'">
                        <xsl:choose>
                            <xsl:when test="$isNumberTextElementOpened">
                                <number:text-content/>
                                <number:text>
                                    <xsl:copy-of select="$numberTextValue"/>
                                </number:text>
                                <xsl:call-template name="get-number-text-content">
                                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                                    <xsl:with-param name="unit-pos" select="$unit-pos"/>
                                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                                    <xsl:with-param name="isNumberTextElementOpened" select="true()"/>
                                    <xsl:with-param name="posed-number-format-unit" select="$posed-number-format-unit"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <number:text>
                                    <xsl:copy-of select="$numberTextValue"/>
                                </number:text>
                                <xsl:call-template name="get-number-text-content">
                                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                                    <xsl:with-param name="unit-pos" select="$unit-pos"/>
                                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                                    <xsl:with-param name="isNumberTextElementOpened" select="true()"/>
                                    <xsl:with-param name="posed-number-format-unit" select="$posed-number-format-unit"/>
                                </xsl:call-template>
                                <xsl:call-template name="get-number-text-content">
                                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                                    <xsl:with-param name="unit-pos" select="$unit-pos"/>
                                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                                    <xsl:with-param name="posed-number-format-unit" select="$posed-number-format-unit"/>
                                    <xsl:with-param name="finished" select="true()"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$style-type-name='number:number-style'">
                        <xsl:choose>
                            <xsl:when test="$isNumberTextElementOpened">
                                <xsl:copy-of select="$numberTextValue"/>
                                <xsl:call-template name="get-number-text-content">
                                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                                    <xsl:with-param name="unit-pos" select="$unit-pos"/>
                                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                                    <xsl:with-param name="isNumberTextElementOpened" select="true()"/>
                                    <xsl:with-param name="posed-number-format-unit" select="$posed-number-format-unit"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <number:text>
                                    <xsl:copy-of select="$numberTextValue"/>
                                    <xsl:call-template name="get-number-text-content">
                                        <xsl:with-param name="style-type-name" select="$style-type-name"/>
                                        <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                                        <xsl:with-param name="unit-pos" select="$unit-pos"/>
                                        <xsl:with-param name="condition-pos" select="$condition-pos"/>
                                        <xsl:with-param name="isNumberTextElementOpened" select="true()"/>
                                        <xsl:with-param name="posed-number-format-unit" select="$posed-number-format-unit"/>
                                    </xsl:call-template>
                                </number:text>
                                <xsl:call-template name="get-number-text-content">
                                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                                    <xsl:with-param name="unit-pos" select="$unit-pos"/>
                                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                                    <xsl:with-param name="posed-number-format-unit" select="$posed-number-format-unit"/>
                                    <xsl:with-param name="finished" select="true()"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <number:text>
                            <xsl:copy-of select="$numberTextValue"/>
                        </number:text>
                        <xsl:choose>
                            <xsl:when test="starts-with($posed-number-format-unit, '\')">
                                <xsl:call-template name="get-number-text-content">
                                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                                    <xsl:with-param name="unit-pos" select="$unit-pos"/>
                                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                                    <xsl:with-param name="posed-number-format-unit" select="$posed-number-format-unit"/>
                                    <xsl:with-param name="finished" select="false()" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="get-number-text-content">
                                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                                    <xsl:with-param name="unit-pos" select="$unit-pos"/>
                                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                                    <xsl:with-param name="posed-number-format-unit" select="$posed-number-format-unit"/>
                                    <xsl:with-param name="finished" select="true()" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="get-number-text-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                    <xsl:with-param name="posed-number-format-unit" select="$posed-number-format-unit"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-number-text-content">
        <xsl:param name="style-type-name"/>
        <xsl:param name="number-format-unit"/>
        <xsl:param name="unit-pos"/>
        <xsl:param name="condition-pos"/>
        <xsl:param name="isNumberTextElementOpened" select="false()"/>
        <xsl:param name="finished" select="false()"/>
        <xsl:param name="posed-number-format-unit"/>
        <!-- process number-format-unit by character string parser -->
        <xsl:choose>
            <xsl:when test="starts-with( $posed-number-format-unit, '\') or starts-with( $posed-number-format-unit, '*')">
                <xsl:choose>
                    <xsl:when test="not($finished)">
                        <xsl:call-template name="add-number-text-value">
                            <xsl:with-param name="style-type-name" select="$style-type-name"/>
                            <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                            <xsl:with-param name="unit-pos" select="$unit-pos + 2"/>
                            <xsl:with-param name="condition-pos" select="$condition-pos"/>
                            <xsl:with-param name="isNumberTextElementOpened" select="$isNumberTextElementOpened"/>
                            <xsl:with-param name="posed-number-format-unit" select="substring($number-format-unit,$unit-pos + 2)"/>
                            <!-- place '*' temporarily here, because now StarCalc doesn't support variable filling character definition -->
                            <xsl:with-param name="numberTextValue" select="substring($posed-number-format-unit,2,1)"/>
                            <xsl:with-param name="finished" select="$finished"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="get-number-text-content">
                            <xsl:with-param name="style-type-name" select="$style-type-name"/>
                            <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                            <xsl:with-param name="unit-pos" select="$unit-pos + 2"/>
                            <xsl:with-param name="condition-pos" select="$condition-pos"/>
                            <xsl:with-param name="posed-number-format-unit" select="substring($number-format-unit,$unit-pos +2)"/>
                            <xsl:with-param name="finished" select="true()"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, '_')">
                <xsl:choose>
                    <xsl:when test="not($finished)">
                        <xsl:call-template name="add-number-text-value">
                            <xsl:with-param name="style-type-name" select="$style-type-name"/>
                            <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                            <xsl:with-param name="unit-pos" select="$unit-pos + 2"/>
                            <xsl:with-param name="condition-pos" select="$condition-pos"/>
                            <xsl:with-param name="isNumberTextElementOpened" select="$isNumberTextElementOpened"/>
                            <xsl:with-param name="posed-number-format-unit" select="substring($number-format-unit,$unit-pos + 2)"/>
                            <!-- adding an empty string -->
                            <xsl:with-param name="numberTextValue" select="' '"/>
                            <xsl:with-param name="finished" select="$finished"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="get-number-text-content">
                            <xsl:with-param name="style-type-name" select="$style-type-name"/>
                            <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                            <xsl:with-param name="unit-pos" select="$unit-pos + 2"/>
                            <xsl:with-param name="condition-pos" select="$condition-pos"/>
                            <xsl:with-param name="posed-number-format-unit" select="substring($number-format-unit,$unit-pos + 2)"/>
                            <xsl:with-param name="finished" select="true()"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, '&quot;')">
                <xsl:choose>
                    <xsl:when test="not($finished)">
                        <!-- creating a pre-character string  -->
                        <xsl:variable name="pre-character-string" select="substring-before(substring($posed-number-format-unit,2), '&quot;')"/>
                        <xsl:call-template name="add-number-text-value">
                            <xsl:with-param name="style-type-name" select="$style-type-name"/>
                            <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                            <xsl:with-param name="unit-pos" select="$unit-pos + string-length($pre-character-string) + 2"/>
                            <xsl:with-param name="condition-pos" select="$condition-pos"/>
                            <xsl:with-param name="posed-number-format-unit" select="substring($number-format-unit,$unit-pos + string-length($pre-character-string) + 2)"/>
                            <xsl:with-param name="isNumberTextElementOpened" select="$isNumberTextElementOpened"/>
                            <xsl:with-param name="numberTextValue" select="$pre-character-string"/>
                            <xsl:with-param name="finished" select="$finished"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- creating a pre-character string  -->
                        <xsl:variable name="pre-character-string" select="substring-before(substring($posed-number-format-unit,2), '&quot;')"/>
                        <xsl:call-template name="get-number-text-content">
                            <xsl:with-param name="style-type-name" select="$style-type-name"/>
                            <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                            <xsl:with-param name="unit-pos" select="$unit-pos + string-length($pre-character-string) + 2"/>
                            <xsl:with-param name="condition-pos" select="$condition-pos"/>
                            <xsl:with-param name="posed-number-format-unit" select="substring($number-format-unit,$unit-pos + string-length($pre-character-string) + 2)"/>
                            <xsl:with-param name="finished" select="true()"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$finished">
                    <xsl:call-template name="create-number-format-content">
                        <xsl:with-param name="style-type-name" select="$style-type-name"/>
                        <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                        <xsl:with-param name="unit-pos" select="$unit-pos"/>
                        <xsl:with-param name="condition-pos" select="$condition-pos"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="create-number-format-content">
        <xsl:param name="style-type-name"/>
        <xsl:param name="number-format-unit"/>
        <xsl:param name="unit-pos"/>
        <xsl:param name="condition-pos"/>
        <xsl:param name="isNumberTextElementOpened" select="false()"/>
        <xsl:variable name="posed-number-format-unit" select="substring($number-format-unit,$unit-pos)"/>
        <xsl:variable name="calendar-type-name">
            <xsl:if test="contains( $number-format-unit, '[$')">
                <xsl:variable name="format-code" select="substring-before( substring-after( substring-after( $number-format-unit, '[$'), '-'), ']')"/>
                <xsl:if test="string-length( $format-code) &gt; 4">
                    <xsl:call-template name="get-calendar-type-name">
                        <xsl:with-param name="calendar-type" select="substring( $format-code, string-length($format-code) -5, 2)"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:if>
        </xsl:variable>
        <!-- process number-format-unit by character string parser -->
        <xsl:choose>
            <xsl:when test="starts-with( $posed-number-format-unit, '[$') and (not(starts-with($posed-number-format-unit, '[$-') ) )">
                <xsl:element name="number:currency-symbol">
                    <xsl:call-template name="create-language-country-attribute">
                        <xsl:with-param name="attribute-code" select="substring-before(substring-after(substring-after($posed-number-format-unit,'[$'),'-'),']')"/>
                    </xsl:call-template>
                    <xsl:value-of select="substring-before( substring-after( $posed-number-format-unit, '[$'), '-')"/>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + string-length( substring-before( $posed-number-format-unit, ']') ) + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, '\') or starts-with( $posed-number-format-unit, '*') or starts-with( $posed-number-format-unit, '_') or starts-with( $posed-number-format-unit, '&quot;')">
                <xsl:call-template name="get-number-text-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                    <xsl:with-param name="posed-number-format-unit" select="$posed-number-format-unit"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="(starts-with( $posed-number-format-unit, '0') or starts-with( $posed-number-format-unit, '#') or starts-with( $posed-number-format-unit, '?') ) and (not ( contains( $posed-number-format-unit, 's.00') ) )">
                <xsl:variable name="valid-number-format-string">
                    <xsl:call-template name="get-valid-number-format-string">
                        <xsl:with-param name="number-format-unit" select="$posed-number-format-unit"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains( $valid-number-format-string, '/')">
                        <xsl:element name="number:fraction">
                            <xsl:attribute name="number:min-integer-digits">
                                <xsl:value-of select="string-length( substring-before($valid-number-format-string, '/') ) - string-length(translate( substring-before($valid-number-format-string, '/'), '0', '') )"/>
                            </xsl:attribute>
                            <xsl:if test="contains( $valid-number-format-string, ',')">
                                <xsl:attribute name="number:grouping">true</xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="number:min-numerator-digits">
                                <xsl:value-of select="string-length( substring-before($valid-number-format-string, '/') ) - string-length(translate( substring-before($valid-number-format-string,'/'), '?', '') )"/>
                            </xsl:attribute>
                            <xsl:attribute name="number:min-denominator-digits">
                                <xsl:value-of select="string-length(substring-after($valid-number-format-string, '/') )"/>
                            </xsl:attribute>
                            <!-- deal with number:embedded-text (removed, as SCHEMA demands element to be empty)
                            <xsl:call-template name="create-number-format-embedded-text">
                                <xsl:with-param name="adapted-number-format-unit" select="$posed-number-format-unit"/>
                                <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                            </xsl:call-template>
                             -->
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains( $valid-number-format-string, '%')">
                        <xsl:element name="number:number">
                            <xsl:choose>
                                <xsl:when test="contains( $valid-number-format-string, '.')">
                                    <xsl:attribute name="number:decimal-places">
                                        <xsl:value-of select="string-length( substring-before( substring-after( $valid-number-format-string, '.'), '%') ) - string-length( translate( substring-before( substring-after( $valid-number-format-string, '.'), '%'), '0', '') )"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="number:min-integer-digits">
                                        <xsl:value-of select="string-length( substring-before($valid-number-format-string, '.') ) - string-length(translate( substring-before($valid-number-format-string, '.'), '0', '') )"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="number:decimal-places">0</xsl:attribute>
                                    <xsl:attribute name="number:min-integer-digits">
                                        <xsl:value-of select="string-length( substring-before($valid-number-format-string, '%') ) - string-length(translate( substring-before($valid-number-format-string, '%'), '0', '') )"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="contains( $valid-number-format-string, ',') and (substring( $valid-number-format-string,string-length($valid-number-format-string)) = ',')">
                                    <xsl:variable name="display-factor">
                                        <xsl:call-template name="get-display-factor">
                                            <xsl:with-param name="start-number" select="1"/>
                                            <xsl:with-param name="thousand-count" select="string-length($valid-number-format-string) - string-length( translate($valid-number-format-string, ',', '') )"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:attribute name="number:display-factor">
                                        <xsl:value-of select="$display-factor"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="number:grouping">true</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="contains( $valid-number-format-string, ',')">
                                    <xsl:attribute name="number:grouping">true</xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                            <!-- deal with number:embedded-text -->
                            <xsl:call-template name="create-number-format-embedded-text">
                                <xsl:with-param name="adapted-number-format-unit" select="$posed-number-format-unit"/>
                                <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                            </xsl:call-template>
                        </xsl:element>
                        <number:text>%</number:text>
                    </xsl:when>
                    <xsl:when test="contains( $valid-number-format-string, 'E') or contains ($valid-number-format-string, 'e')">
                        <xsl:element name="number:scientific-number">
                            <xsl:choose>
                                <xsl:when test="contains( $valid-number-format-string, '.')">
                                    <xsl:attribute name="number:decimal-places">
                                        <xsl:value-of select="string-length( substring-before( substring-after( $valid-number-format-string, '.'), 'E') ) - string-length( translate( substring-before( substring-after( $valid-number-format-string, '.'), 'E'), '0', '') )"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="number:min-integer-digits">
                                        <xsl:value-of select="string-length( substring-before($valid-number-format-string, '.') ) - string-length(translate( substring-before($valid-number-format-string, '.'), '0', '') )"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="number:decimal-places">0</xsl:attribute>
                                    <xsl:attribute name="number:min-integer-digits">
                                        <xsl:value-of select="string-length( substring-before($valid-number-format-string, 'E') ) - string-length(translate( substring-before($valid-number-format-string, 'E'), '0', '') )"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:attribute name="number:min-exponent-digits">
                                <xsl:value-of select="string-length( substring-after( $valid-number-format-string, 'E') ) - string-length( translate( substring-after( $valid-number-format-string, 'E'), '0', '') )"/>
                            </xsl:attribute>
                            <!-- deal with number:embedded-text -->
                            <xsl:call-template name="create-number-format-embedded-text">
                                <xsl:with-param name="adapted-number-format-unit" select="$posed-number-format-unit"/>
                                <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- -normal number format, currency, and accounting, e.g -->
                        <xsl:element name="number:number">
                            <xsl:choose>
                                <xsl:when test="contains( $valid-number-format-string, '.')">
                                    <xsl:attribute name="number:decimal-places">
                                        <xsl:value-of select="string-length( substring-after( $valid-number-format-string, '.') ) - string-length( translate( substring-after( $valid-number-format-string, '.'), '0', '') )"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="number:min-integer-digits">
                                        <xsl:value-of select="string-length( substring-before($valid-number-format-string, '.') ) - string-length(translate( substring-before($valid-number-format-string, '.'), '0', '') )"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="number:decimal-places">0</xsl:attribute>
                                    <xsl:attribute name="number:min-integer-digits">
                                        <xsl:value-of select="string-length( $valid-number-format-string ) - string-length(translate( $valid-number-format-string, '0', '') )"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="contains( $valid-number-format-string, ',') and (substring( $valid-number-format-string,string-length($valid-number-format-string)) = ',')">
                                    <xsl:variable name="display-factor">
                                        <xsl:call-template name="get-display-factor">
                                            <xsl:with-param name="start-number" select="1"/>
                                            <xsl:with-param name="thousand-count">
                                                <xsl:call-template name="thousand-count-temp">
                                                    <xsl:with-param name="format-unit" select="$valid-number-format-string"/>
                                                </xsl:call-template>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:attribute name="number:display-factor">
                                        <xsl:value-of select="$display-factor"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="number:grouping">true</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="contains( $valid-number-format-string, ',')">
                                    <xsl:attribute name="number:grouping">true</xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                            <!-- deal with number:embedded-text -->
                            <xsl:call-template name="create-number-format-embedded-text">
                                <xsl:with-param name="adapted-number-format-unit" select="$posed-number-format-unit"/>
                                <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- deal with post number:text -->
                <xsl:variable name="post-number-format-text">
                    <xsl:call-template name="get-post-number-format-text">
                        <xsl:with-param name="adapted-number-format-unit" select="$posed-number-format-unit"/>
                        <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$post-number-format-text"/>
                    <xsl:with-param name="unit-pos" select="1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'ggg')">
                <xsl:element name="number:era">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 3"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'gg')">
                <xsl:element name="number:era">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 2"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'g')">
                <xsl:element name="number:era">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'ee')">
                <xsl:element name="number:year">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 2"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'r')">
                <xsl:element name="number:year">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'yyyy')">
                <xsl:element name="number:year">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 4"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'yy')">
                <xsl:element name="number:year">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 2"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'e') or starts-with( $posed-number-format-unit, 'y')">
                <xsl:element name="number:year">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'mmmmm')">
                <xsl:element name="number:month">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                    <xsl:attribute name="number:textual">true</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 5"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'mmmm')">
                <xsl:element name="number:month">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                    <xsl:attribute name="number:textual">true</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 4"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'mmm')">
                <xsl:element name="number:month">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                    <xsl:attribute name="number:textual">true</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 3"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, '[mm]')">
                <xsl:element name="number:minutes">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 4"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, '[m]')">
                <xsl:element name="number:minutes">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 3"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'mm') and ( contains( $number-format-unit, 'h') or contains( $posed-number-format-unit, 's') )">
                <xsl:element name="number:minutes">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 2"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'mm')">
                <xsl:element name="number:month">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 2"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'm') and ( contains( $number-format-unit, 'h') or contains( $posed-number-format-unit, 's') )">
                <xsl:element name="number:minutes">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'm')">
                <xsl:element name="number:month">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'dddd') or starts-with( $posed-number-format-unit, 'aaaa')">
                <xsl:element name="number:day-of-week">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 4"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'ddd') or starts-with( $posed-number-format-unit, 'aaa')">
                <xsl:element name="number:day-of-week">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 3"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'dd')">
                <xsl:element name="number:day">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 2"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'd')">
                <xsl:element name="number:day">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                    <xsl:if test="string-length($calendar-type-name) &gt; 0">
                        <xsl:attribute name="number:calendar">
                            <xsl:value-of select="$calendar-type-name"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'hh')">
                <xsl:element name="number:hours">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 2"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, '[hh]')">
                <xsl:element name="number:hours">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 4"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'h')">
                <xsl:element name="number:hours">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, '[h]')">
                <xsl:element name="number:hours">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 3"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'AM/PM') or starts-with( $posed-number-format-unit, 'am/pm')">
                <number:am-pm/>
                <!-- long: am-pm doesn't support long style yet -->
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 5"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'a/p'or starts-with( $posed-number-format-unit, 'A/P'))">
                <number:am-pm/>
                <!-- short: am-pm doesn't support short style yet -->
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 3"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 'ss')">
                <xsl:variable name="decimal-places">
                    <xsl:choose>
                        <xsl:when test="starts-with( $posed-number-format-unit, 'ss.0')">
                            <xsl:value-of select="string-length( $posed-number-format-unit) - string-length( translate( $posed-number-format-unit, '0', '') )"/>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="number:seconds">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                    <xsl:if test="$decimal-places &gt; 0">
                        <xsl:attribute name="number:decimal-places">
                            <xsl:value-of select="$decimal-places"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:variable name="second-length">
                    <xsl:choose>
                        <xsl:when test="$decimal-places &gt; 0">
                            <xsl:value-of select="$decimal-places + 3"/>
                        </xsl:when>
                        <xsl:otherwise>2</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + $second-length"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, '[ss]')">
                <xsl:element name="number:seconds">
                    <xsl:attribute name="number:style">long</xsl:attribute>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 4"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, 's')">
                <xsl:variable name="decimal-places">
                    <xsl:choose>
                        <xsl:when test="starts-with( $posed-number-format-unit, 's.0')">
                            <xsl:value-of select="string-length( $posed-number-format-unit) - string-length( translate( $posed-number-format-unit, '0', '') )"/>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="number:seconds">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                    <xsl:if test="$decimal-places &gt; 0">
                        <xsl:attribute name="number:decimal-places">
                            <xsl:value-of select="$decimal-places"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:variable name="second-length">
                    <xsl:choose>
                        <xsl:when test="$decimal-places &gt; 0">
                            <xsl:value-of select="$decimal-places + 2"/>
                        </xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + $second-length"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, '[s]')">
                <xsl:element name="number:seconds">
                    <xsl:attribute name="number:style">short</xsl:attribute>
                </xsl:element>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 3"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, '@')">
                <number:text-content/>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$posed-number-format-unit = 'General Number'">
                <number:number number:decimal-places="0" number:min-integer-digits="1"/>
            </xsl:when>
            <xsl:when test="$posed-number-format-unit = 'General Date'">
                <number:year number:style="long"/>
                <number:text>-</number:text>
                <number:month number:style="short"/>
                <number:text>-</number:text>
                <number:day number:style="short"/>
                <number:text>
                    <xsl:text> </xsl:text>
                </number:text>
                <number:hours number:style="short"/>
                <number:text>:</number:text>
                <number:minutes number:style="long"/>
            </xsl:when>
            <!-- special for General number:text-content output -->
            <xsl:when test="starts-with($posed-number-format-unit , 'General')">
                <xsl:choose>
                    <xsl:when test="$posed-number-format-unit = 'General' and $condition-pos = 1">
                        <number:number number:decimal-places="0" number:min-integer-digits="1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="create-number-format-content">
                            <xsl:with-param name="style-type-name" select="$style-type-name"/>
                            <xsl:with-param name="number-format-unit" select="$posed-number-format-unit"/>
                            <xsl:with-param name="unit-pos" select="8"/>
                            <xsl:with-param name="condition-pos" select="$condition-pos"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$posed-number-format-unit = 'Fixed'">
                <number:number number:decimal-places="2" number:min-integer-digits="1"/>
                <number:text/>
            </xsl:when>
            <xsl:when test="$posed-number-format-unit = 'Standard'">
                <number:number number:decimal-places="2" number:min-integer-digits="1" number:grouping="true"/>
            </xsl:when>
            <xsl:when test="$posed-number-format-unit = 'Long Date'">
                <number:year number:style="long"/>
                <number:text>-</number:text>
                <number:month number:style="long"/>
                <number:text>-</number:text>
                <number:day number:style="long"/>
            </xsl:when>
            <xsl:when test="$posed-number-format-unit = 'Medium Date'">
                <number:day number:style="short"/>
                <number:text>-</number:text>
                <number:month number:textual="true"/>
                <number:text>-</number:text>
                <number:year number:style="short"/>
            </xsl:when>
            <xsl:when test="$posed-number-format-unit = 'Short Date'">
                <number:day number:style="short"/>
                <number:text>-</number:text>
                <number:month number:style="short"/>
                <number:text>-</number:text>
                <number:year number:style="short"/>
            </xsl:when>
            <xsl:when test="$posed-number-format-unit = 'Long Time'">
                <number:hours number:style="long"/>
                <number:text>:</number:text>
                <number:minutes number:style="long"/>
                <number:text>:</number:text>
                <number:seconds number:style="long"/>
                <number:text>
                    <xsl:text> </xsl:text>
                </number:text>
                <number:am-pm/>
            </xsl:when>
            <xsl:when test="$posed-number-format-unit = 'Medium Time'">
                <number:hours number:style="short"/>
                <number:text>:</number:text>
                <number:minutes number:style="long"/>
                <number:text>
                    <xsl:text> </xsl:text>
                </number:text>
                <number:am-pm/>
            </xsl:when>
            <xsl:when test="$posed-number-format-unit = 'Short Time'">
                <number:hours number:style="short"/>
                <number:text>:</number:text>
                <number:minutes number:style="long"/>
                <number:text>
                    <xsl:text> </xsl:text>
                </number:text>
            </xsl:when>
            <xsl:when test="$posed-number-format-unit = 'Percent'">
                <number:number number:decimal-places="2" number:min-integer-digits="1"/>
                <number:text>%</number:text>
            </xsl:when>
            <xsl:when test="$posed-number-format-unit = 'Scientific'">
                <number:scientific-number number:decimal-places="2" number:min-integer-digits="1" number:min-exponent-digits="2"/>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, '[')">
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + string-length( substring-before( $posed-number-format-unit, ']') ) + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                    <xsl:with-param name="isNumberTextElementOpened" select="$isNumberTextElementOpened"/>
                    <xsl:with-param name="posed-number-format-unit" select="$posed-number-format-unit"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, '/')">
                <number:text>/</number:text>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with( $posed-number-format-unit, ':')">
                <number:text>:</number:text>
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="string-length( $posed-number-format-unit ) &gt; 0">
                <xsl:call-template name="create-number-format-content">
                    <xsl:with-param name="style-type-name" select="$style-type-name"/>
                    <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
                    <xsl:with-param name="unit-pos" select="$unit-pos + 1"/>
                    <xsl:with-param name="condition-pos" select="$condition-pos"/>
                    <xsl:with-param name="isNumberTextElementOpened" select="$isNumberTextElementOpened"/>
                    <xsl:with-param name="posed-number-format-unit" select="$posed-number-format-unit"/>
                    <xsl:with-param name="numberTextValue" select="substring( $posed-number-format-unit, 1, 1)"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="thousand-count-temp">
        <!-- thousand count for char ',' at the latter of format-unit by recursion -->
        <xsl:param name="format-unit"/>
        <xsl:choose>
            <xsl:when test="contains($format-unit, ',#')">
                <xsl:call-template name="thousand-count-temp">
                    <xsl:with-param name="format-unit" select="substring-after($format-unit, ',#')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($format-unit, ',0')">
                <xsl:call-template name="thousand-count-temp">
                    <xsl:with-param name="format-unit" select="substring-after($format-unit, ',0')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="string-length($format-unit) - string-length( translate($format-unit, ',', ''))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-calendar-type-name">
        <xsl:param name="calendar-type"/>
        <xsl:variable name="temp-type">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="$calendar-type"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="string-length($calendar-type)"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <!-- Japanese (Emperor era), #03 -->
            <xsl:when test="$temp-type = 3">gengou</xsl:when>
            <!-- Taiwanese, #04 -->
            <xsl:when test="$temp-type = 4">ROC</xsl:when>
            <!-- Korean (Tangun era) hanja_yoil is ok too. #05 -->
            <xsl:when test="$temp-type = 5">hanja</xsl:when>
            <!-- Hijri (Arabic lunar), #06 -->
            <xsl:when test="$temp-type = 6">hijri</xsl:when>
            <!-- Thai, #07 -->
            <xsl:when test="$temp-type = 7">buddhist</xsl:when>
            <!-- 01: Gregorian (Localized), 02: Gregorian (United States), 09: Gregorian (Middle East French), 0A: Gregorian (Arabic), 0B: Gregorian (Transliterated English) -->
            <xsl:otherwise>gregorian</xsl:otherwise>
            <!-- not found jewish yet -->
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-valid-number-format-string">
        <xsl:param name="number-format-unit"/>
        <xsl:choose>
            <xsl:when test="contains( $number-format-unit, '\')">
                <xsl:call-template name="get-valid-number-format-string">
                    <xsl:with-param name="number-format-unit" select="concat( substring-before( $number-format-unit, '\'), substring( substring-after( $number-format-unit, '\'), 2) )"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains( $number-format-unit, '*')">
                <xsl:call-template name="get-valid-number-format-string">
                    <xsl:with-param name="number-format-unit" select="concat( substring-before( $number-format-unit, '*'), substring( substring-after( $number-format-unit, '*'), 2) )"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains( $number-format-unit, '_')">
                <xsl:call-template name="get-valid-number-format-string">
                    <xsl:with-param name="number-format-unit" select="concat( substring-before( $number-format-unit, '_'), substring( substring-after( $number-format-unit, '_'), 2) )"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains( $number-format-unit, '&quot;')">
                <xsl:call-template name="get-valid-number-format-string">
                    <xsl:with-param name="number-format-unit" select="concat( substring-before( $number-format-unit, '&quot;'), substring-after( substring-after( $number-format-unit, '&quot;'), '&quot;') )"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$number-format-unit"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-display-factor">
        <xsl:param name="start-number"/>
        <xsl:param name="thousand-count"/>
        <xsl:choose>
            <xsl:when test="$thousand-count = 0">
                <xsl:value-of select="$start-number"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="get-display-factor">
                    <xsl:with-param name="start-number" select="$start-number * 1000"/>
                    <xsl:with-param name="thousand-count" select="$thousand-count -1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-post-number-format-text">
        <xsl:param name="adapted-number-format-unit"/>
        <xsl:param name="valid-number-format-string"/>
        <xsl:variable name="first-embedded-character-pos">
            <xsl:choose>
                <xsl:when test="contains( $adapted-number-format-unit, '\')">
                    <xsl:value-of select="string-length( substring-before($adapted-number-format-unit, '\') ) + 1"/>
                </xsl:when>
                <xsl:when test="contains( $adapted-number-format-unit, '_')">
                    <xsl:value-of select="string-length( substring-before($adapted-number-format-unit, '_') ) + 1"/>
                </xsl:when>
                <xsl:when test="contains( $adapted-number-format-unit, '*')">
                    <xsl:value-of select="string-length( substring-before($adapted-number-format-unit, '*') ) + 1"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="first-embedded-string-pos">
            <xsl:choose>
                <xsl:when test="contains( $adapted-number-format-unit, '&quot;')">
                    <xsl:value-of select="string-length( substring-before($adapted-number-format-unit, '&quot;') ) + 1"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="first-embedded-text-pos">
            <xsl:choose>
                <xsl:when test="$first-embedded-character-pos &lt; $first-embedded-string-pos and $first-embedded-character-pos &gt; 0">
                    <xsl:value-of select="$first-embedded-character-pos"/>
                </xsl:when>
                <xsl:when test="$first-embedded-character-pos &lt; $first-embedded-string-pos and $first-embedded-character-pos = 0">
                    <xsl:value-of select="$first-embedded-string-pos"/>
                </xsl:when>
                <xsl:when test="$first-embedded-character-pos &gt; $first-embedded-string-pos and $first-embedded-string-pos &gt; 0">
                    <xsl:value-of select="$first-embedded-string-pos"/>
                </xsl:when>
                <xsl:when test="$first-embedded-character-pos &gt; $first-embedded-string-pos and $first-embedded-string-pos = 0">
                    <xsl:value-of select="$first-embedded-character-pos"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$first-embedded-text-pos &gt; string-length( $valid-number-format-string )">
                <xsl:value-of select="substring( $adapted-number-format-unit, $first-embedded-text-pos)"/>
            </xsl:when>
            <xsl:when test="$first-embedded-text-pos &gt; 0 and $first-embedded-text-pos &lt; string-length( $valid-number-format-string )">
                <xsl:choose>
                    <xsl:when test="starts-with( substring( $adapted-number-format-unit, $first-embedded-text-pos, 1), '\')">
                        <xsl:call-template name="get-post-number-format-text">
                            <xsl:with-param name="adapted-number-format-unit" select="concat( substring-before( $adapted-number-format-unit, '\'), substring( $adapted-number-format-unit, $first-embedded-text-pos + 2) )"/>
                            <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="starts-with( substring( $adapted-number-format-unit, $first-embedded-text-pos, 1), '_')">
                        <xsl:call-template name="get-post-number-format-text">
                            <xsl:with-param name="adapted-number-format-unit" select="concat( substring-before( $adapted-number-format-unit, '_'), substring( $adapted-number-format-unit, $first-embedded-text-pos + 2) )"/>
                            <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="starts-with( substring( $adapted-number-format-unit, $first-embedded-text-pos, 1), '*')">
                        <xsl:call-template name="get-post-number-format-text">
                            <xsl:with-param name="adapted-number-format-unit" select="concat( substring-before( $adapted-number-format-unit, '*'), substring( $adapted-number-format-unit, $first-embedded-text-pos + 2) )"/>
                            <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="starts-with( substring( $adapted-number-format-unit, $first-embedded-text-pos, 1), '&quot;')">
                        <xsl:call-template name="get-post-number-format-text">
                            <xsl:with-param name="adapted-number-format-unit" select="concat( substring-before( $adapted-number-format-unit, '&quot;'), substring-after( substring-after( $adapted-number-format-unit, '&quot;'), '&quot;') )"/>
                            <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="create-number-format-embedded-text">
        <xsl:param name="adapted-number-format-unit"/>
        <xsl:param name="valid-number-format-string"/>
        <xsl:variable name="first-embedded-character-pos">
            <xsl:choose>
                <xsl:when test="contains( $adapted-number-format-unit, '\')">
                    <xsl:value-of select="string-length( substring-before($adapted-number-format-unit, '\') ) + 1"/>
                </xsl:when>
                <xsl:when test="contains( $adapted-number-format-unit, '_')">
                    <xsl:value-of select="string-length( substring-before($adapted-number-format-unit, '_') ) + 1"/>
                </xsl:when>
                <xsl:when test="contains( $adapted-number-format-unit, '*')">
                    <xsl:value-of select="string-length( substring-before($adapted-number-format-unit, '*') ) + 1"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="first-embedded-string-pos">
            <xsl:choose>
                <xsl:when test="contains( $adapted-number-format-unit, '&quot;')">
                    <xsl:value-of select="string-length( substring-before($adapted-number-format-unit, '&quot;') ) + 1"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="first-embedded-text-pos">
            <xsl:choose>
                <xsl:when test="$first-embedded-character-pos &lt; $first-embedded-string-pos and $first-embedded-character-pos &gt; 0">
                    <xsl:value-of select="$first-embedded-character-pos"/>
                </xsl:when>
                <xsl:when test="$first-embedded-character-pos &lt; $first-embedded-string-pos and $first-embedded-character-pos = 0">
                    <xsl:value-of select="$first-embedded-string-pos"/>
                </xsl:when>
                <xsl:when test="$first-embedded-character-pos &gt; $first-embedded-string-pos and $first-embedded-string-pos &gt; 0">
                    <xsl:value-of select="$first-embedded-string-pos"/>
                </xsl:when>
                <xsl:when test="$first-embedded-character-pos &gt; $first-embedded-string-pos and $first-embedded-string-pos = 0">
                    <xsl:value-of select="$first-embedded-character-pos"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$first-embedded-text-pos &gt; 0 and $first-embedded-text-pos &lt; string-length( $valid-number-format-string )">
            <xsl:variable name="text-pos">
                <xsl:choose>
                    <xsl:when test="contains( $valid-number-format-string, '.')">
                        <xsl:variable name="right-text-pos" select="substring( substring-before( $valid-number-format-string, '.'), $first-embedded-text-pos)"/>
                        <xsl:value-of select="string-length($right-text-pos) - string-length( translate( $right-text-pos, '0#?', '') )"/>
                    </xsl:when>
                    <xsl:when test="contains( $valid-number-format-string, '/')">
                        <xsl:variable name="right-text-pos" select="substring( substring-before( $valid-number-format-string, '/'), $first-embedded-text-pos)"/>
                        <xsl:value-of select="string-length($right-text-pos) - string-length( translate( $right-text-pos, '0#?', '') )"/>
                    </xsl:when>
                    <xsl:when test="contains( $valid-number-format-string, '%')">
                        <xsl:variable name="right-text-pos" select="substring( substring-before( $valid-number-format-string, '%'), $first-embedded-text-pos)"/>
                        <xsl:value-of select="string-length($right-text-pos) - string-length( translate( $right-text-pos, '0#?', '') )"/>
                    </xsl:when>
                    <xsl:when test="contains( $valid-number-format-string, 'E')">
                        <xsl:variable name="right-text-pos" select="substring( substring-before( $valid-number-format-string, 'E'), $first-embedded-text-pos)"/>
                        <xsl:value-of select="string-length($right-text-pos) - string-length( translate( $right-text-pos, '0#?', '') )"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="right-text-pos" select="substring( $valid-number-format-string, $first-embedded-text-pos)"/>
                        <xsl:value-of select="string-length($right-text-pos) - string-length( translate( $right-text-pos, '0#?', '') )"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="starts-with( substring( $adapted-number-format-unit, $first-embedded-text-pos, 1), '\')">
                    <number:embedded-text number:position="{$text-pos}">
                        <xsl:value-of select="substring( $adapted-number-format-unit, $first-embedded-text-pos + 1, 1)"/>
                    </number:embedded-text>
                    <xsl:call-template name="create-number-format-embedded-text">
                        <xsl:with-param name="adapted-number-format-unit" select="concat( substring-before( $adapted-number-format-unit, '\'), substring( $adapted-number-format-unit, $first-embedded-text-pos + 2) )"/>
                        <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="starts-with( substring( $adapted-number-format-unit, $first-embedded-text-pos, 1), '_')">
                    <number:embedded-text number:position="{$text-pos}">
                        <xsl:value-of select="substring( $adapted-number-format-unit, $first-embedded-text-pos + 1, 1)"/>
                    </number:embedded-text>
                    <xsl:call-template name="create-number-format-embedded-text">
                        <xsl:with-param name="adapted-number-format-unit" select="concat( substring-before( $adapted-number-format-unit, '_'), substring( $adapted-number-format-unit, $first-embedded-text-pos + 2) )"/>
                        <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="starts-with( substring( $adapted-number-format-unit, $first-embedded-text-pos, 1), '*')">
                    <number:embedded-text number:position="{$text-pos}">
                        <xsl:value-of select="substring( $adapted-number-format-unit, $first-embedded-text-pos + 1, 1)"/>
                    </number:embedded-text>
                    <xsl:call-template name="create-number-format-embedded-text">
                        <xsl:with-param name="adapted-number-format-unit" select="concat( substring-before( $adapted-number-format-unit, '*'), substring( $adapted-number-format-unit, $first-embedded-text-pos + 2) )"/>
                        <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="starts-with( substring( $adapted-number-format-unit, $first-embedded-text-pos, 1), '&quot;')">
                    <number:embedded-text number:position="{$text-pos}">
                        <xsl:value-of select="substring-before( substring( $adapted-number-format-unit, $first-embedded-text-pos + 1), '&quot;')"/>
                    </number:embedded-text>
                    <xsl:call-template name="create-number-format-embedded-text">
                        <xsl:with-param name="adapted-number-format-unit" select="concat( substring-before( $adapted-number-format-unit, '&quot;'), substring-after( substring-after( $adapted-number-format-unit, '&quot;'), '&quot;') )"/>
                        <xsl:with-param name="valid-number-format-string" select="$valid-number-format-string"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="create-master-styles">
        <xsl:param name="worksheetoptions"/>
        <xsl:for-each select="$worksheetoptions">
            <xsl:element name="style:master-page">
                <xsl:attribute name="style:name">
                    <xsl:call-template name="encode-as-nc-name">
                        <xsl:with-param name="string" select="concat( 'TAB_', ../@ss:Name)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="style:display-name">
                    <xsl:value-of select="concat( 'PageStyle_', ../@ss:Name)"/>
                </xsl:attribute>
                <xsl:attribute name="style:page-layout-name">
                    <xsl:call-template name="encode-as-nc-name">
                        <xsl:with-param name="string" select="concat( 'pm_', ../@ss:Name)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="x:PageSetup/x:Header/@x:Data">
                        <style:header>
                            <xsl:call-template name="translate-header-footer">
                                <xsl:with-param name="content" select="x:PageSetup/x:Header/@x:Data"/>
                                <xsl:with-param name="style-name-header" select="concat(../@ss:Name, substring(name(x:PageSetup/x:Header),1,1))"/>
                            </xsl:call-template>
                        </style:header>
                    </xsl:when>
                    <xsl:otherwise>
                        <style:header style:display="false"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="x:PageSetup/x:Footer/@x:Data">
                        <style:footer>
                            <xsl:call-template name="translate-header-footer">
                                <xsl:with-param name="content" select="x:PageSetup/x:Footer/@x:Data"/>
                                <xsl:with-param name="style-name-header" select="concat(../@ss:Name, substring(name(x:PageSetup/x:Footer),1,1))"/>
                            </xsl:call-template>
                        </style:footer>
                    </xsl:when>
                    <xsl:otherwise>
                        <style:footer style:display="false"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="translate-header-footer">
        <xsl:param name="content"/>
        <xsl:param name="style-name-header"/>
        <style:region-left>
            <text:p>
                <xsl:variable name="left-content">
                    <xsl:call-template name="get-pos-content">
                        <xsl:with-param name="content" select="$content"/>
                        <xsl:with-param name="pos" select="'left'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="locate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="$left-content"/>
                    <xsl:with-param name="style-name-header" select="concat($style-name-header,'L')"/>
                    <xsl:with-param name="index" select="0"/>
                    <xsl:with-param name="current-pos" select="1"/>
                </xsl:call-template>
            </text:p>
        </style:region-left>
        <style:region-center>
            <text:p>
                <xsl:variable name="center-content">
                    <xsl:call-template name="get-pos-content">
                        <xsl:with-param name="content" select="$content"/>
                        <xsl:with-param name="pos" select="'center'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="locate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="$center-content"/>
                    <xsl:with-param name="style-name-header" select="concat($style-name-header,'C')"/>
                    <xsl:with-param name="index" select="0"/>
                    <xsl:with-param name="current-pos" select="1"/>
                </xsl:call-template>
            </text:p>
        </style:region-center>
        <style:region-right>
            <text:p>
                <xsl:variable name="right-content">
                    <xsl:call-template name="get-pos-content">
                        <xsl:with-param name="content" select="$content"/>
                        <xsl:with-param name="pos" select="'right'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="locate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="$right-content"/>
                    <xsl:with-param name="style-name-header" select="concat($style-name-header,'R')"/>
                    <xsl:with-param name="index" select="0"/>
                    <xsl:with-param name="current-pos" select="1"/>
                </xsl:call-template>
            </text:p>
        </style:region-right>
    </xsl:template>
    <xsl:template name="locate-header-footer-data">
        <xsl:param name="header-footer-data"/>
        <xsl:param name="style-name-header"/>
        <xsl:param name="index"/>
        <xsl:param name="current-pos"/>
        <xsl:variable name="current-style-data">
            <xsl:value-of select="substring($header-footer-data,$current-pos)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="starts-with($current-style-data,'&amp;X') or starts-with($current-style-data,'&amp;Y') or starts-with($current-style-data,'&amp;S') or starts-with($current-style-data,'&amp;U') or starts-with($current-style-data,'&amp;E') or starts-with($current-style-data,'&amp;B')">
                <xsl:call-template name="locate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="$header-footer-data"/>
                    <xsl:with-param name="style-name-header" select="$style-name-header"/>
                    <xsl:with-param name="index" select="$index"/>
                    <xsl:with-param name="current-pos" select="$current-pos+2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($current-style-data,'&amp;0') or starts-with($current-style-data,'&amp;1') or starts-with($current-style-data,'&amp;2') or starts-with($current-style-data,'&amp;3') or starts-with($current-style-data,'&amp;4') or starts-with($current-style-data,'&amp;5') or starts-with($current-style-data,'&amp;6') or starts-with($current-style-data,'&amp;7') or starts-with($current-style-data,'&amp;8') or starts-with($current-style-data,'&amp;9')">
                <xsl:variable name="font-size-length">
                    <xsl:call-template name="get-digit-length">
                        <xsl:with-param name="complexive-string" select="substring-after($current-style-data,'&amp;')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="locate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="$header-footer-data"/>
                    <xsl:with-param name="style-name-header" select="$style-name-header"/>
                    <xsl:with-param name="index" select="$index"/>
                    <xsl:with-param name="current-pos" select="$current-pos+1+$font-size-length"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($current-style-data,'&amp;&quot;')">
                <xsl:call-template name="locate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="$header-footer-data"/>
                    <xsl:with-param name="style-name-header" select="$style-name-header"/>
                    <xsl:with-param name="index" select="$index"/>
                    <xsl:with-param name="current-pos" select="string-length(substring-before(substring($header-footer-data,$current-pos+2),'&quot;'))+$current-pos+3"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="current-content-last-pos">
                    <xsl:call-template name="get-current-content-last-pos">
                        <xsl:with-param name="style-data" select="$header-footer-data"/>
                        <xsl:with-param name="current-pos" select="$current-pos"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$current-pos &gt; 1">
                        <text:span text:style-name="{concat($style-name-header,$index)}">
                            <xsl:call-template name="translate-header-footer-data">
                                <xsl:with-param name="header-footer-data" select="substring($header-footer-data,$current-pos,$current-content-last-pos+1-$current-pos)"/>
                            </xsl:call-template>
                        </text:span>
                        <xsl:if test="$current-content-last-pos &lt; string-length($header-footer-data)">
                            <xsl:call-template name="locate-header-footer-data">
                                <xsl:with-param name="header-footer-data" select="$header-footer-data"/>
                                <xsl:with-param name="style-name-header" select="$style-name-header"/>
                                <xsl:with-param name="index" select="$index+1"/>
                                <xsl:with-param name="current-pos" select="$current-content-last-pos+1"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="translate-header-footer-data">
                            <xsl:with-param name="header-footer-data" select="substring($header-footer-data,$current-pos,$current-content-last-pos+1-$current-pos)"/>
                        </xsl:call-template>
                        <xsl:if test="$current-content-last-pos &lt; string-length($header-footer-data)">
                            <xsl:call-template name="locate-header-footer-data">
                                <xsl:with-param name="header-footer-data" select="$header-footer-data"/>
                                <xsl:with-param name="style-name-header" select="$style-name-header"/>
                                <xsl:with-param name="index" select="$index"/>
                                <xsl:with-param name="current-pos" select="$current-content-last-pos+1"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-current-content-last-pos">
        <xsl:param name="style-data"/>
        <xsl:param name="current-pos"/>
        <xsl:variable name="current-style-data">
            <xsl:value-of select="substring($style-data,$current-pos)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="starts-with($current-style-data,'&amp;&quot;') or starts-with($current-style-data,'&amp;X') or starts-with($current-style-data,'&amp;Y') or starts-with($current-style-data,'&amp;S') or starts-with($current-style-data,'&amp;U') or starts-with($current-style-data,'&amp;E') or starts-with($current-style-data,'&amp;B')or starts-with($current-style-data,'&amp;0') or starts-with($current-style-data,'&amp;1') or starts-with($current-style-data,'&amp;2') or starts-with($current-style-data,'&amp;3') or starts-with($current-style-data,'&amp;4') or starts-with($current-style-data,'&amp;5') or starts-with($current-style-data,'&amp;6') or starts-with($current-style-data,'&amp;7') or starts-with($current-style-data,'&amp;8') or starts-with($current-style-data,'&amp;9')">
                <xsl:value-of select="$current-pos - 1"/>
            </xsl:when>
            <xsl:when test="contains($current-style-data,'&amp;&quot;') or contains($current-style-data,'&amp;X') or contains($current-style-data,'&amp;Y') or contains($current-style-data,'&amp;S') or contains($current-style-data,'&amp;U') or contains($current-style-data,'&amp;E') or contains($current-style-data,'&amp;B')or contains($current-style-data,'&amp;0') or contains($current-style-data,'&amp;1') or contains($current-style-data,'&amp;2') or contains($current-style-data,'&amp;3') or contains($current-style-data,'&amp;4') or contains($current-style-data,'&amp;5') or contains($current-style-data,'&amp;6') or contains($current-style-data,'&amp;7') or contains($current-style-data,'&amp;8') or contains($current-style-data,'&amp;9')">
                <xsl:variable name="temp" select="substring-before(substring($current-style-data,2),'&amp;')"/>
                <xsl:variable name="next-amp-pos">
                    <xsl:value-of select="$current-pos+string-length($temp)+1"/>
                </xsl:variable>
                <xsl:call-template name="get-current-content-last-pos">
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="current-pos" select="$next-amp-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="string-length($style-data)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="translate-header-footer-data">
        <xsl:param name="header-footer-data"/>
        <xsl:choose>
            <xsl:when test="contains( $header-footer-data, '&amp;D')">
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-before( $header-footer-data, '&amp;D')"/>
                </xsl:call-template>
                <text:date/>
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-after( $header-footer-data, '&amp;D')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains( $header-footer-data, '&amp;T')">
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-before( $header-footer-data, '&amp;T')"/>
                </xsl:call-template>
                <text:time/>
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-after( $header-footer-data, '&amp;T')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains( $header-footer-data, '&amp;P')">
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-before( $header-footer-data, '&amp;P')"/>
                </xsl:call-template>
                <text:page-number/>
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-after( $header-footer-data, '&amp;P')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains( $header-footer-data, '&amp;N')">
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-before( $header-footer-data, '&amp;N')"/>
                </xsl:call-template>
                <text:page-count/>
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-after( $header-footer-data, '&amp;N')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains( $header-footer-data, '&amp;A')">
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-before( $header-footer-data, '&amp;A')"/>
                </xsl:call-template>
                <text:sheet-name/>
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-after( $header-footer-data, '&amp;A')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains( $header-footer-data, '&amp;Z&amp;F')">
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-before( $header-footer-data, '&amp;Z&amp;F')"/>
                </xsl:call-template>
                <text:file-name text:display="full"/>
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-after( $header-footer-data, '&amp;Z&amp;F')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains( $header-footer-data, '&amp;Z')">
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-before( $header-footer-data, '&amp;Z')"/>
                </xsl:call-template>
                <text:file-name text:display="path"/>
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-after( $header-footer-data, '&amp;Z')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains( $header-footer-data, '&amp;F')">
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-before( $header-footer-data, '&amp;F')"/>
                </xsl:call-template>
                <text:file-name text:display="name"/>
                <xsl:call-template name="translate-header-footer-data">
                    <xsl:with-param name="header-footer-data" select="substring-after( $header-footer-data, '&amp;F')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$header-footer-data"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="create-page-master">
        <xsl:param name="worksheetoptions"/>
        <xsl:for-each select="$worksheetoptions">
            <xsl:element name="style:page-layout">
                <xsl:attribute name="style:name">
                    <xsl:call-template name="encode-as-nc-name">
                        <xsl:with-param name="string" select="concat( 'pm_', ../@ss:Name)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:element name="style:page-layout-properties">
                    <xsl:choose>
                        <xsl:when test="x:PageSetup/x:Layout/@x:Orientation = 'Landscape'">
                            <xsl:attribute name="style:print-orientation">landscape</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:print-orientation">portrait</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="x:PageSetup/x:Layout/@x:StartPageNumber">
                            <xsl:attribute name="style:first-page-number">
                                <xsl:value-of select="x:PageSetup/x:Layout/@x:StartPageNumber"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:first-page-number">continue</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="x:PageSetup/x:PageMargins">
                        <xsl:attribute name="fo:margin-top">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="concat(x:PageSetup/x:PageMargins/@x:Top,'pt')"/>
                            </xsl:call-template>
                            <xsl:text>cm</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="fo:margin-bottom">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="concat(x:PageSetup/x:PageMargins/@x:Bottom,'pt')"/>
                            </xsl:call-template>
                            <xsl:text>cm</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="fo:margin-left">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="concat(x:PageSetup/x:PageMargins/@x:Left,'pt')"/>
                            </xsl:call-template>
                            <xsl:text>cm</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="fo:margin-right">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="concat(x:PageSetup/x:PageMargins/@x:Right,'pt')"/>
                            </xsl:call-template>
                            <xsl:text>cm</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:if test="x:PageSetup/x:Header">
                    <style:header-style>
                        <xsl:element name="style:header-footer-properties">
                            <xsl:attribute name="fo:min-height">0.75cm</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="x:PageSetup/x:Header/@x:Margin">
                                    <xsl:attribute name="fo:margin-bottom">
                                        <xsl:call-template name="convert2cm">
                                            <xsl:with-param name="value" select="concat(x:PageSetup/x:Header/@x:Margin,'pt')"/>
                                        </xsl:call-template>
                                        <xsl:text>cm</xsl:text>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="fo:margin-bottom">0.25cm</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </style:header-style>
                </xsl:if>
                <xsl:if test="x:PageSetup/x:Footer">
                    <style:footer-style>
                        <xsl:element name="style:header-footer-properties">
                            <xsl:attribute name="fo:min-height">0.75cm</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="x:PageSetup/x:Footer/@x:Margin">
                                    <xsl:attribute name="fo:margin-top">
                                        <xsl:call-template name="convert2cm">
                                            <xsl:with-param name="value" select="concat(x:PageSetup/x:Footer/@x:Margin,'pt')"/>
                                        </xsl:call-template>
                                        <xsl:text>cm</xsl:text>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="fo:margin-top">0.25cm</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </style:footer-style>
                </xsl:if>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="ss:Style" name="style-style-content" mode="style-style-content">
        <xsl:element name="style:table-cell-properties">
            <xsl:if test="ss:Alignment">
                <xsl:if test="ss:Alignment/@ss:Vertical">
                    <xsl:variable name="vertical-align">
                        <xsl:choose>
                            <xsl:when test="ss:Alignment/@ss:Vertical = 'Top'">top</xsl:when>
                            <xsl:when test="ss:Alignment/@ss:Vertical = 'Center'">middle</xsl:when>
                            <xsl:when test="ss:Alignment/@ss:Vertical = 'Bottom'">bottom</xsl:when>
                            <xsl:when test="ss:Alignment/@ss:Vertical = 'Automatic'">middle</xsl:when>
                            <!-- actually for vertical written characters, not supported by StarOffice/OpenOffice now yet -->
                            <xsl:otherwise>middle</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="style:vertical-align">
                        <xsl:value-of select="$vertical-align"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="ss:Alignment/@ss:WrapText = '1'">
                    <xsl:attribute name="fo:wrap-option">wrap</xsl:attribute>
                </xsl:if>
                <xsl:if test="ss:Alignment/@ss:Indent">
                    <xsl:attribute name="fo:padding-left"><!-- Indent is ten times of a point -->
                        <xsl:variable name="indent" select="ss:Alignment/@ss:Indent * 10"/>
                        <xsl:call-template name="convert2cm">
                            <xsl:with-param name="value" select="concat($indent,'pt')"/>
                        </xsl:call-template>
                        <xsl:text>cm</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="ss:Alignment/@ss:Rotate">
                    <xsl:attribute name="style:rotation-angle">
                        <xsl:choose>
                            <xsl:when test="ss:Alignment/@ss:Rotate &lt; 0">
                                <xsl:value-of select="360 + ss:Alignment/@ss:Rotate"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="ss:Alignment/@ss:Rotate"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="style:rotation-align">none</xsl:attribute>
                </xsl:if>
                <xsl:if test="ss:Alignment/@ss:VerticalText = '1'">
                    <xsl:attribute name="style:direction">ttb</xsl:attribute>
                    <!-- The horizontal align default for vertical text in Excel is 'center' -->
                    <xsl:if test="not(ss:Alignment/@ss:Horizontal)">
                        <!-- OASIS XML removal
                        <xsl:attribute name="fo:text-align">center</xsl:attribute>-->
                        <xsl:attribute name="style:text-align-source">fix</xsl:attribute>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
            <xsl:if test="ss:Borders">
                <xsl:if test="ss:Borders/ss:Border">
                    <xsl:apply-templates select="ss:Borders/ss:Border"/>
                </xsl:if>
            </xsl:if>
            <xsl:apply-templates select="ss:Interior" mode="style-style-content"/>
            <xsl:if test="ss:Protection">
                <xsl:choose>
                    <xsl:when test="ss:Protection/@ss:Protected = '0'">
                        <xsl:choose>
                            <xsl:when test="ss:Protection/@ss:HideFormula = '1'">
                                <xsl:attribute name="style:cell-protect">hidden-and-protected</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:cell-protect">none</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="ss:Protection/@x:HideFormula = '1'">
                                <xsl:attribute name="style:cell-protect">protected formula-hidden</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:cell-protect">none</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <!-- fix means the horizontal alignment is dependent on ss:Horizontal,
                 but set on paragraph properties not cell paragraphs -->
            <xsl:if test="ss:Alignment/@ss:Horizontal">
                <xsl:attribute name="style:text-align-source">fix</xsl:attribute>
            </xsl:if>
        </xsl:element>
        <xsl:choose>
            <xsl:when test="ss:Alignment/@ss:Horizontal">
                <xsl:element name="style:paragraph-properties">
                    <xsl:variable name="text-align">
                        <xsl:choose>
                            <xsl:when test="ss:Alignment/@ss:Horizontal = 'Left'">start</xsl:when>
                            <xsl:when test="ss:Alignment/@ss:Horizontal = 'Center'">center</xsl:when>
                            <xsl:when test="ss:Alignment/@ss:Horizontal = 'Right'">end</xsl:when>
                            <xsl:when test="ss:Alignment/@ss:Horizontal = 'Justify'">justify</xsl:when>
                            <!-- many other text-align not supported yet -->
                            <xsl:otherwise>start</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="fo:text-align">
                        <xsl:value-of select="$text-align"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- The horizontal align default for vertical text in Excel is 'center' -->
                <xsl:element name="style:paragraph-properties">
                    <xsl:if test="ss:Alignment/@ss:VerticalText = '1'">
                        <xsl:attribute name="fo:text-align">center</xsl:attribute>
                    </xsl:if>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="ss:Font">
            <xsl:element name="style:text-properties">
                <xsl:choose>
                    <xsl:when test="ss:Font/@ss:FontName">
                        <xsl:attribute name="style:font-name">
                            <xsl:value-of select="ss:Font/@ss:FontName"/>
                        </xsl:attribute>
                        <xsl:attribute name="style:font-name-asian">
                            <xsl:value-of select="ss:Font/@ss:FontName"/>
                        </xsl:attribute>
                        <xsl:attribute name="style:font-name-complex">
                            <xsl:value-of select="ss:Font/@ss:FontName"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style:font-name">Arial</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- "ss:Font/@x:Family" is useless here, so can't map to "svg:font-family" attribute -->
                <xsl:if test="ss:Font/@ss:Bold = '1'">
                    <xsl:attribute name="fo:font-weight">bold</xsl:attribute>
                    <xsl:attribute name="style:font-weight-asian">bold</xsl:attribute>
                    <xsl:attribute name="style:font-weight-complex">bold</xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="ss:Font/@ss:Color">
                        <xsl:attribute name="fo:color">
                            <xsl:value-of select="ss:Font/@ss:Color"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style:use-window-font-color">true</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="ss:Font/@ss:Italic = '1'">
                    <!-- omit font-style oblique -->
                    <xsl:attribute name="fo:font-style">italic</xsl:attribute>
                    <xsl:attribute name="style:font-style-asian">italic</xsl:attribute>
                    <xsl:attribute name="style:font-style-complex">italic</xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="ss:Font/@ss:Size">
                        <xsl:attribute name="fo:font-size">
                            <xsl:value-of select="concat( ss:Font/@ss:Size, 'pt')"/>
                        </xsl:attribute>
                        <xsl:attribute name="style:font-size-asian">
                            <xsl:value-of select="concat( ss:Font/@ss:Size, 'pt')"/>
                        </xsl:attribute>
                        <xsl:attribute name="style:font-size-complex">
                            <xsl:value-of select="concat( ss:Font/@ss:Size, 'pt')"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="fo:font-size">10pt</xsl:attribute>
                        <xsl:attribute name="style:font-size-asian">10pt</xsl:attribute>
                        <xsl:attribute name="style:font-size-complex">10pt</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="ss:Font/@ss:Outline = '1'">
                    <xsl:attribute name="style:text-outline">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="ss:Font/@ss:Shadow = '1'">
                    <!-- Not in DTD nor in docu <xsl:attribute name="style:text-shadow">shadow</xsl:attribute> -->
                    <xsl:attribute name="fo:text-shadow">1pt 1pt</xsl:attribute>
                </xsl:if>
                <xsl:if test="ss:Font/@ss:StrikeThrough = '1'">
                    <xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
                </xsl:if>
                <xsl:if test="ss:Font/@ss:Underline">
                    <xsl:choose>
                        <xsl:when test="ss:Font/@ss:Underline = 'None'">
                            <xsl:attribute name="style:text-underline-type">none</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="ss:Font/@ss:Underline = 'Single'">
                            <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="ss:Font/@ss:Underline = 'Double'">
                            <xsl:attribute name="style:text-underline-type">double</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="ss:Font/@ss:Underline = 'SingleAccounting'">
                            <xsl:attribute name="style:text-underline-type">single</xsl:attribute>"</xsl:when>
                        <xsl:when test="ss:Font/@ss:Underline = 'DoubleAccounting'">
                            <xsl:attribute name="style:text-underline-type">double</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:text-underline-type">none</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="ss:Font/@x:Charset">
                    <!-- quite unclear till now, -->
                    <xsl:attribute name="style:font-charset">x-symbol</xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ss:Interior" mode="style-style-content">
        <xsl:choose>
            <xsl:when test="@ss:Pattern = 'Solid'">
                <xsl:if test="@ss:Color">
                    <xsl:attribute name="fo:background-color">
                        <xsl:value-of select="@ss:Color"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="@ss:PatternColor">
                    <xsl:variable name="pattern-value">
                        <xsl:call-template name="cell-pattern-color">
                            <xsl:with-param name="pattern" select="concat('0.',substring-after(@ss:Pattern,'y'))"/>
                            <xsl:with-param name="color-value" select="@ss:Color"/>
                            <xsl:with-param name="pattern-color-value" select="@ss:PatternColor"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="fo:background-color">
                        <xsl:value-of select="$pattern-value"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="ss:Style">
        <!-- style:default-style is meant for application defaults
        <xsl:when test="@ss:ID = 'Default'">
            <xsl:element name="style:default-style">
                <xsl:call-template name="style-style-content" />
            </xsl:element>
        </xsl:when> -->
        <xsl:element name="style:style">
            <xsl:attribute name="style:name">
                <xsl:value-of select="@ss:ID"/>
            </xsl:attribute>
            <xsl:apply-templates select="@ss:Name" />
            <xsl:choose>
                <xsl:when test="@ss:Parent">
                    <xsl:attribute name="style:parent-style-name">
                        <xsl:value-of select="@ss:Parent"/>
                    </xsl:attribute>
                </xsl:when>
                <!-- no parent, but automatic style are automatically inheriting from a style called 'Default'
                    not necessary named style -->
                <xsl:when test="not(key('Style', @ss:ID)/@ss:Name)">
                    <xsl:attribute name="style:parent-style-name">
                        <xsl:text>Default</xsl:text>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="ss:NumberFormat/@ss:Format">
                <xsl:attribute name="style:data-style-name">
                    <xsl:value-of select="concat( @ss:ID, 'F')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="style:family">table-cell</xsl:attribute>
            <xsl:call-template name="style-style-content"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="cell-pattern-color">
        <!-- generates a new color from cell-pattern-color -->
        <xsl:param name="pattern"/>
        <xsl:param name="color-value"/>
        <xsl:param name="pattern-color-value"/>
        <xsl:variable name="rev-pattern" select="1 - $pattern"/>
        <xsl:variable name="color-R-value">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="substring($color-value,2,2)"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="2"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="color-G-value">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="substring($color-value,4,2)"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="2"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="color-B-value">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="substring($color-value,6,2)"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="2"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="pattern-R-value">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="substring($pattern-color-value,2,2)"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="2"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="pattern-G-value">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="substring($pattern-color-value,4,2)"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="2"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="pattern-B-value">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="substring($pattern-color-value,6,2)"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="2"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="R-value">
            <xsl:variable name="combined-R-value">
                <xsl:call-template name="decimal2hex">
                    <xsl:with-param name="dec-number" select="floor($color-R-value * $rev-pattern + $pattern-R-value * $pattern)"/>
                    <xsl:with-param name="last-value" select="'H'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($combined-R-value) = 1">
                    <xsl:value-of select="concat('0',$combined-R-value)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$combined-R-value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="G-value">
            <xsl:variable name="combined-G-value">
                <xsl:call-template name="decimal2hex">
                    <xsl:with-param name="dec-number" select="floor($color-G-value * $rev-pattern + $pattern-G-value * $pattern)"/>
                    <xsl:with-param name="last-value" select="'H'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($combined-G-value) = 1">
                    <xsl:value-of select="concat('0',$combined-G-value)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$combined-G-value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="B-value">
            <xsl:variable name="combined-B-value">
                <xsl:call-template name="decimal2hex">
                    <xsl:with-param name="dec-number" select="floor($color-B-value * $rev-pattern + $pattern-B-value * $pattern)"/>
                    <xsl:with-param name="last-value" select="'H'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($combined-B-value) = 1">
                    <xsl:value-of select="concat('0',$combined-B-value)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$combined-B-value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat('#',$R-value,$G-value,$B-value)"/>
    </xsl:template>
    <xsl:template name="colorindex2decimal">
        <xsl:param name="colorindex"/>
        <xsl:variable name="colorIndexLookup">
            <xsl:value-of select="$colorindex - 8"/>
        </xsl:variable>
        <xsl:variable name="tempColorValue">
            <xsl:choose>
                <!-- Grab the color from the custom color index if it exists... -->
                <xsl:when test="/ss:Workbook/o:OfficeDocumentSettings/o:Colors/o:Color/o:Index=$colorIndexLookup">
                    <xsl:value-of select="substring-after(normalize-space(/ss:Workbook/o:OfficeDocumentSettings/o:Colors/o:Color/o:RGB[/ss:Workbook/o:OfficeDocumentSettings/o:Colors/o:Color/o:Index=$colorIndexLookup]), '#')"/>
                </xsl:when >
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$colorindex=8">
                            <xsl:value-of select="'000000'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=9">
                            <xsl:value-of select="'FFFFFF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=10">
                            <xsl:value-of select="'FF0000'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=11">
                            <xsl:value-of select="'00FF00'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=12">
                            <xsl:value-of select="'0000FF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=13">
                            <xsl:value-of select="'FFFF00'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=14">
                            <xsl:value-of select="'FF00FF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=15">
                            <xsl:value-of select="'00FFFF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=16">
                            <xsl:value-of select="'800000'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=17">
                            <xsl:value-of select="'008000'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=18">
                            <xsl:value-of select="'000080'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=19">
                            <xsl:value-of select="'808000'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=20">
                            <xsl:value-of select="'800080'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=21">
                            <xsl:value-of select="'008080'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=22">
                            <xsl:value-of select="'C0C0C0'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=23">
                            <xsl:value-of select="'808080'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=24">
                            <xsl:value-of select="'9999FF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=25">
                            <xsl:value-of select="'993366'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=26">
                            <xsl:value-of select="'FFFFCC'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=27">
                            <xsl:value-of select="'CCFFFF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=28">
                            <xsl:value-of select="'660066'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=29">
                            <xsl:value-of select="'FF8080'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=30">
                            <xsl:value-of select="'0066CC'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=31">
                            <xsl:value-of select="'CCCCFF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=32">
                            <xsl:value-of select="'000080'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=33">
                            <xsl:value-of select="'FF00FF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=34">
                            <xsl:value-of select="'FFFF00'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=35">
                            <xsl:value-of select="'00FFFF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=36">
                            <xsl:value-of select="'800080'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=37">
                            <xsl:value-of select="'800000'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=38">
                            <xsl:value-of select="'008080'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=39">
                            <xsl:value-of select="'0000FF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=40">
                            <xsl:value-of select="'00CCFF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=41">
                            <xsl:value-of select="'CCFFFF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=42">
                            <xsl:value-of select="'CCFFCC'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=43">
                            <xsl:value-of select="'FFFF99'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=44">
                            <xsl:value-of select="'99CCFF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=45">
                            <xsl:value-of select="'FF99CC'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=46">
                            <xsl:value-of select="'CC99FF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=47">
                            <xsl:value-of select="'FFCC99'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=48">
                            <xsl:value-of select="'3366FF'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=49">
                            <xsl:value-of select="'33CCCC'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=50">
                            <xsl:value-of select="'99CC00'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=51">
                            <xsl:value-of select="'FFCC00'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=52">
                            <xsl:value-of select="'FF9900'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=53">
                            <xsl:value-of select="'FF6600'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=54">
                            <xsl:value-of select="'666699'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=55">
                            <xsl:value-of select="'969696'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=56">
                            <xsl:value-of select="'003366'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=57">
                            <xsl:value-of select="'339966'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=58">
                            <xsl:value-of select="'003300'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=59">
                            <xsl:value-of select="'333300'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=60">
                            <xsl:value-of select="'993300'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=61">
                            <xsl:value-of select="'993366'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=62">
                            <xsl:value-of select="'333399'"/>
                        </xsl:when>
                        <xsl:when test="$colorindex=63">
                            <xsl:value-of select="'333333'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'NOTFOUND'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="tempColorDecimal">
            <xsl:choose>
                    <xsl:when test="not($tempColorValue = 'NOTFOUND')">
                        <xsl:call-template name="hex2decimal">
                            <xsl:with-param name="hex-number" select="$tempColorValue"/>
                            <xsl:with-param name="index" select="1"/>
                            <xsl:with-param name="str-length" select="6"/>
                            <xsl:with-param name="last-value" select="0"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="4294967295"/>
                    </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$tempColorDecimal"/>
    </xsl:template>
    <xsl:template name="hex2decimal">
        <!-- transforms a hex number to a decimal number.parses the string from left to right -->
        <xsl:param name="hex-number"/>
        <xsl:param name="index"/>
        <xsl:param name="str-length"/>
        <xsl:param name="last-value"/>
        <xsl:variable name="dec-char">
            <xsl:call-template name="hexNumber2dec">
                <xsl:with-param name="hex-value" select="substring($hex-number, $index ,1)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="current-value" select="$last-value * 16 + $dec-char"/>
        <xsl:if test="$index &lt; $str-length">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="$hex-number"/>
                <xsl:with-param name="index" select="$index + 1"/>
                <xsl:with-param name="str-length" select="$str-length"/>
                <xsl:with-param name="last-value" select="$current-value"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$index = $str-length">
            <xsl:value-of select="$current-value"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="hexNumber2dec">
        <!-- return a decimal number for a hex character -->
        <xsl:param name="hex-value"/>
        <xsl:choose>
            <xsl:when test="$hex-value = 'A' or ($hex-value = 'a')">
                <xsl:value-of select="10"/>
            </xsl:when>
            <xsl:when test="$hex-value = 'B' or ($hex-value = 'b')">
                <xsl:value-of select="11"/>
            </xsl:when>
            <xsl:when test="$hex-value = 'C' or ($hex-value = 'c')">
                <xsl:value-of select="12"/>
            </xsl:when>
            <xsl:when test="$hex-value = 'D' or ($hex-value = 'd')">
                <xsl:value-of select="13"/>
            </xsl:when>
            <xsl:when test="$hex-value = 'E' or ($hex-value = 'e')">
                <xsl:value-of select="14"/>
            </xsl:when>
            <xsl:when test="$hex-value = 'F' or ($hex-value = 'f')">
                <xsl:value-of select="15"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$hex-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decimal2hex">
        <!-- transforms a decimal number to a hex number,only for two-bit hex(less than 256 in decimal) currently -->
        <xsl:param name="dec-number"/>
        <xsl:param name="last-value"/>
        <xsl:variable name="current-value">
            <xsl:call-template name="decNumber2hex">
                <xsl:with-param name="dec-value">
                    <xsl:if test="$dec-number &gt; 15">
                        <xsl:value-of select="floor($dec-number div 16)"/>
                    </xsl:if>
                    <xsl:if test="$dec-number &lt; 16">
                        <xsl:value-of select="$dec-number"/>
                    </xsl:if>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$dec-number &gt; 15">
            <xsl:call-template name="decimal2hex">
                <xsl:with-param name="dec-number" select="$dec-number mod 16"/>
                <xsl:with-param name="last-value" select="concat($last-value,$current-value)"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$dec-number &lt; 16">
            <xsl:value-of select="substring-after(concat($last-value,$current-value),'H')"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="decNumber2hex">
        <!-- return a hex number for a decimal character -->
        <xsl:param name="dec-value"/>
        <xsl:choose>
            <xsl:when test="$dec-value = 10">
                <xsl:value-of select="'A'"/>
            </xsl:when>
            <xsl:when test="$dec-value = 11">
                <xsl:value-of select="'B'"/>
            </xsl:when>
            <xsl:when test="$dec-value = 12">
                <xsl:value-of select="'C'"/>
            </xsl:when>
            <xsl:when test="$dec-value = 13">
                <xsl:value-of select="'D'"/>
            </xsl:when>
            <xsl:when test="$dec-value = 14">
                <xsl:value-of select="'E'"/>
            </xsl:when>
            <xsl:when test="$dec-value = 15">
                <xsl:value-of select="'F'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$dec-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ss:Border">
        <xsl:variable name="position">
            <xsl:choose>
                <xsl:when test="@ss:Position = 'Top'">fo:border-top</xsl:when>
                <xsl:when test="@ss:Position = 'Bottom'">fo:border-bottom</xsl:when>
                <xsl:when test="@ss:Position = 'Left'">fo:border-left</xsl:when>
                <xsl:when test="@ss:Position = 'Right'">fo:border-right</xsl:when>
                <!-- DiagonalLeft & DiagonalRight are not supported yet, -->
                <xsl:otherwise>fo:border-left</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="width">
            <xsl:choose>
                <!-- 0: Hairline -->
                <xsl:when test="@ss:Weight = '0'">0.002cm</xsl:when>
                <!-- 1: Thin -->
                <xsl:when test="@ss:Weight = '1'">0.035cm</xsl:when>
                <!-- 2: Medium -->
                <xsl:when test="@ss:Weight = '2'">0.088cm</xsl:when>
                <!-- 3: Thick -->
                <xsl:when test="@ss:Weight = '3'">
                    <xsl:choose>
                        <xsl:when test="@ss:LineStyle = 'Double'">0.105cm</xsl:when>
                        <xsl:otherwise>0.141cm</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- invalid value, or parameter not exist at all -->
                <xsl:otherwise>0.002cm</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="linestyle">
            <xsl:choose>
                <xsl:when test="@ss:LineStyle = 'None'">none</xsl:when>
                <xsl:when test="@ss:LineStyle = 'Continuous'">solid</xsl:when>
                <xsl:when test="@ss:LineStyle = 'Double'">double</xsl:when>
                <!-- Dash, Dot, DashDot, DashDotDot, SlantDashDot are not supported yet -->
                <xsl:otherwise>solid</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="color">
            <xsl:choose>
                <xsl:when test="@ss:Color">
                    <xsl:value-of select="@ss:Color"/>
                </xsl:when>
                <!-- default border color is black -->
                <xsl:otherwise>#000000</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="{$position}">
            <xsl:value-of select="concat( $width, ' ', $linestyle, ' ', $color)"/>
        </xsl:attribute>
        <xsl:if test="@ss:LineStyle = 'Double'">
            <xsl:variable name="widthposition">
                <xsl:choose>
                    <xsl:when test="@ss:Position = 'Top'">style:border-line-width-top</xsl:when>
                    <xsl:when test="@ss:Position = 'Bottom'">style:border-line-width-bottom</xsl:when>
                    <xsl:when test="@ss:Position = 'Left'">style:border-line-width-left</xsl:when>
                    <xsl:when test="@ss:Position = 'Right'">style:border-line-width-right</xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="{$widthposition}">0.035cm 0.035cm 0.035cm</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="ss:Font">
        <xsl:choose>
            <xsl:when test="@ss:VerticalAlign = 'Superscript'">
                <style:style style:name="{concat(../@ss:ID,'T0')}" style:family="text">
                    <style:text-properties style:text-position="33% 58%"/>
                </style:style>
            </xsl:when>
            <xsl:when test="@ss:VerticalAlign = 'Subscript'">
                <style:style style:name="{concat(../@ss:ID,'T0')}" style:family="text">
                    <style:text-properties style:text-position="-33% 58%"/>
                </style:style>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ss:Table">
        <xsl:variable name="default-column-width">
            <xsl:choose>
                <xsl:when test="@ss:DefaultColumnWidth">
                    <xsl:call-template name="convert2cm">
                        <xsl:with-param name="value" select="concat(@ss:DefaultColumnWidth,'pt')"/>
                    </xsl:call-template>
                    <xsl:text>cm</xsl:text>
                </xsl:when>
                <!-- Note: Specify where this value come from... -->
                <xsl:otherwise>2.096cm</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="table-pos">
            <xsl:value-of select="count(../preceding-sibling::ss:Worksheet)+1"/>
        </xsl:variable>
        <!-- naming convention the default column style is name co<NumberOfSheet> e.g. co1 for the first sheet -->
        <style:style style:family="table-column" style:name="{concat('co', $table-pos)}">
            <style:table-column-properties fo:break-before="auto" style:column-width="{$default-column-width}"/>
        </style:style>
        <xsl:variable name="columnCount" select="count(ss:Column)"/>
        <xsl:for-each select="ss:Column">
            <xsl:apply-templates select="." mode="create-column-style">
                <xsl:with-param name="columnCount" select="$columnCount"/>
                <xsl:with-param name="currentCount" select="position()"/>
                <xsl:with-param name="table-pos" select="$table-pos"/>
                <xsl:with-param name="default-column-width" select="$default-column-width"/>
            </xsl:apply-templates>
        </xsl:for-each>
        <xsl:if test="../x:PageBreaks/x:ColBreaks">
            <style:style style:name="{concat('cob',$table-pos)}" style:family="table-column">
                <xsl:element name="style:table-column-properties">
                    <xsl:attribute name="style:column-width">
                        <xsl:value-of select="$default-column-width"/>
                    </xsl:attribute>
                    <xsl:attribute name="fo:break-before">page</xsl:attribute>
                </xsl:element>
            </style:style>
        </xsl:if>
        <xsl:variable name="default-row-height">
            <xsl:choose>
                <xsl:when test="@ss:DefaultRowHeight">
                    <xsl:call-template name="convert2cm">
                        <xsl:with-param name="value" select="concat(@ss:DefaultRowHeight,'pt')"/>
                    </xsl:call-template>
                    <xsl:text>cm</xsl:text>
                </xsl:when>
                <!-- Note: This is the default row height value in spec it is written 255 point, this seems wrong -->
                <!-- <xsl:otherwise>0.503cm</xsl:otherwise> -->
                <xsl:otherwise>0.45cm</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <style:style style:family="table-row" style:name="{concat('ro', $table-pos)}">
            <style:table-row-properties style:row-height="{$default-row-height}" style:use-optimal-row-height="false"/>
        </style:style>
        <xsl:variable name="rowCount" select="count(ss:Row)"/>
        <xsl:for-each select="ss:Row">
            <xsl:apply-templates select="." mode="create-row-style">
                <xsl:with-param name="rowNodeCount" select="$rowCount"/>
                <xsl:with-param name="rowNodeIndex" select="position()"/>
                <xsl:with-param name="table-pos" select="$table-pos"/>
                <xsl:with-param name="default-row-height" select="$default-row-height"/>
            </xsl:apply-templates>
        </xsl:for-each>
        <xsl:if test="../x:PageBreaks/x:RowBreaks">
            <style:style style:name="{concat('rob',$table-pos)}" style:family="table-row">
                <xsl:element name="style:table-row-properties">
                    <xsl:attribute name="style:row-height">
                        <xsl:value-of select="$default-row-height"/>
                    </xsl:attribute>
                    <xsl:attribute name="style:use-optimal-row-height">false</xsl:attribute>
                    <xsl:attribute name="fo:break-before">page</xsl:attribute>
                </xsl:element>
            </style:style>
        </xsl:if>
        <!-- create table-style -->
        <xsl:element name="style:style">
            <xsl:attribute name="style:name">
                <xsl:value-of select="concat( 'ta', $table-pos)"/>
            </xsl:attribute>
            <xsl:attribute name="style:family">table</xsl:attribute>
            <!-- ss:Name have to be from type 'NCNameChar'      ::=     Letter | Digit | '.' | '-' | '_' | CombiningChar | Extender -->
            <xsl:attribute name="style:master-page-name">
                <xsl:call-template name="encode-as-nc-name">
                    <xsl:with-param name="string" select="../@ss:Name"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:element name="style:table-properties">
                <xsl:choose>
                    <xsl:when test="../x:WorksheetOptions/x:Visible = 'SheetHidden'">
                        <xsl:attribute name="table:display">false</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="table:display">true</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="ss:Column" mode="create-column-style">
        <!-- generate stylename of colbreak after matching the column number and the colbreak number -->
        <xsl:param name="columnCount"/>
        <xsl:param name="currentCount"/>
        <xsl:param name="table-pos"/>
        <xsl:param name="default-column-width"/>
        <xsl:variable name="span-value" select="@ss:Span + count(@ss:Span)"/>
        <xsl:variable name="finishedColumns">
            <xsl:choose>
                <xsl:when test="@ss:Index">
                    <xsl:value-of select="@ss:Index -1 + $span-value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="recent-index"
                        select="preceding-sibling::ss:Column[@ss:Index][last()]"/>
                    <xsl:choose>
                        <xsl:when test="$recent-index">
                            <xsl:variable name="nodes-up-to-current"
                                select="set:intersection(preceding-sibling::ss:Column, $recent-index/following-sibling::ss:Column)"/>
                            <xsl:variable name="allSpans" select="$nodes-up-to-current/@ss:Span"/>
                            <xsl:value-of
                                select="$recent-index/@ss:Index + count($nodes-up-to-current) + sum($allSpans) + count($allSpans)"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="allSpans" select="preceding-sibling::ss:Column/@ss:Span"/>

                            <xsl:value-of select="$currentCount + sum($allSpans) + count($allSpans)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="current-index">
            <xsl:choose>
                <xsl:when test="@ss:Index">
                    <xsl:value-of select="@ss:Index - 1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$finishedColumns"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="column-break">
            <xsl:choose>
                <xsl:when test="$span-value = 0">
                    <xsl:if test="../x:PageBreaks/x:ColBreaks/x:ColBreak/x:Column = $current-index">
                        <xsl:value-of select="1"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if
                        test="../x:PageBreaks/x:ColBreaks[(x:ColBreak/x:Column &gt; $finishedColumns) and (x:ColBreak/x:Column &lt; ($finishedColumns + $span-value))]">
                        <xsl:value-of select="1"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$column-break = 1">
            <xsl:element name="style:style">
                <xsl:attribute name="style:name">
                    <xsl:call-template name="encode-as-nc-name">
                        <xsl:with-param name="string"
                            select="concat('cob', $table-pos, '-',$currentCount)"/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="style:family">table-column</xsl:attribute>
                <xsl:element name="style:table-column-properties">
                    <xsl:choose>
                        <xsl:when test="@ss:Width">
                            <xsl:attribute name="style:column-width">
                                <xsl:call-template name="convert2cm">
                                    <xsl:with-param name="value"
                                        select="concat(@ss:Width,'pt')"
                                    />
                                </xsl:call-template>
                                <xsl:text>cm</xsl:text>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:column-width">
                                <xsl:value-of select="$default-column-width"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="@ss:AutoFitWidth = '0'">
                            <xsl:attribute name="style:use-optimal-column-width"
                                >false</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when
                                    test="@ss:Width &gt; 0">
                                    <xsl:attribute name="style:use-optimal-column-width"
                                        >false</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="style:use-optimal-column-width"
                                        >true</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="fo:break-before">page</xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <style:style style:name="{concat('co', $table-pos, '-',$currentCount)}"
            style:family="table-column">
            <xsl:element name="style:table-column-properties">
                <xsl:choose>
                    <xsl:when test="@ss:Width">
                        <xsl:attribute name="style:column-width">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value"
                                    select="concat(@ss:Width,'pt')"
                                />
                            </xsl:call-template>
                            <xsl:text>cm</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style:column-width">
                            <xsl:value-of select="$default-column-width"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:attribute name="fo:break-before">auto</xsl:attribute>
            </xsl:element>
        </style:style>
    </xsl:template>

    <xsl:template match="ss:Row" mode="create-row-style">
        <!-- generate stylename of rowbreak after matching the row number and the rowbreak number -->
        <xsl:param name="rowNodeCount"/>
        <xsl:param name="rowNodeIndex" select="position()"/>
        <xsl:param name="table-pos"/>
        <xsl:param name="default-row-height"/>
        <xsl:variable name="simple-span-value" select="@ss:Span + count(@ss:Span)"/>

        <xsl:variable name="earlierRowNo">
            <xsl:choose>
                <xsl:when test="@ss:Index"><xsl:value-of select="@ss:Index -1 + $simple-span-value"/></xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="recent-index" select="preceding-sibling::ss:Row[@ss:Index][last()]"></xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$recent-index">
                            <xsl:variable name="nodes-up-to-current" select="set:intersection(preceding-sibling::ss:Row, $recent-index/following-sibling::ss:Row)"></xsl:variable>
                            <xsl:variable name="allSpans" select="$nodes-up-to-current/@ss:Span"/>
                            <xsl:value-of select="$recent-index/@ss:Index + count($nodes-up-to-current) + sum($allSpans) + count($allSpans)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="allSpans" select="preceding-sibling::ss:Row/@ss:Span"/>
                            <xsl:value-of select="position() + sum($allSpans) + count($allSpans)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="span-value">
            <xsl:choose>
                <xsl:when test="@ss:Index">
                    <xsl:choose>
                        <xsl:when test="@ss:Span">
                            <xsl:value-of select="@ss:Index - $earlierRowNo + @ss:Span"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="@ss:Span">
                            <xsl:value-of select="@ss:Span + 1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="current-index">
            <xsl:choose>
                <xsl:when test="@ss:Index">
                    <xsl:value-of select="@ss:Index - 1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$earlierRowNo"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="row-break">
            <xsl:choose>
                <xsl:when test="$span-value = 0">
                    <xsl:if test="../x:PageBreaks/x:RowBreaks/x:RowBreak/x:Row = $current-index">
                        <xsl:value-of select="1"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="../x:PageBreaks/x:RowBreaks[(x:RowBreak/x:Row &gt; $earlierRowNo) and (x:RowBreak/x:Row &lt; ($earlierRowNo + $span-value))]">
                        <xsl:value-of select="1"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$row-break = 1">
            <xsl:element name="style:style">
                <xsl:choose>
                    <xsl:when test="@ss:StyleID">
                        <xsl:attribute name="style:name"><xsl:value-of select="concat('ro', $table-pos, '-',$rowNodeIndex,'-',@ss:StyleID)"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style:name"><xsl:value-of select="concat('ro', $table-pos, '-',$rowNodeIndex)"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:attribute name="style:family">table-row</xsl:attribute>


                <xsl:element name="style:table-row-properties">
                    <xsl:choose>
                        <xsl:when test="@ss:Height">
                            <xsl:attribute name="style:row-height">
                                <xsl:call-template name="convert2cm">
                                    <xsl:with-param name="value" select="concat(@ss:Height,'pt')"/>
                                </xsl:call-template>
                                <xsl:text>cm</xsl:text>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:row-height">
                                <xsl:value-of select="$default-row-height"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="@ss:AutoFitHeight = '0'">
                            <xsl:attribute name="style:use-optimal-row-height">false</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="@ss:Height &gt; 0">
                                    <xsl:attribute name="style:use-optimal-row-height">false</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="style:use-optimal-row-height">true</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="fo:break-before">page</xsl:attribute>
                    <xsl:apply-templates select="key('Style', @ss:StyleID)/ss:Interior" mode="style-style-content"/>
                </xsl:element>
                <!--
                    <xsl:apply-templates select="key('Style', @ss:StyleID)" mode="style-style-content" />
                -->
            </xsl:element>
        </xsl:if>
        <!--
            <style:style style:name="{concat('ro', $table-pos, '-',$rowNodeIndex)}" style:family="table-row">
        -->
        <xsl:element name="style:style">
            <xsl:choose>
                <xsl:when test="@ss:StyleID">
                    <xsl:attribute name="style:name"><xsl:value-of select="concat('ro', $table-pos, '-',$rowNodeIndex,'-',@ss:StyleID)"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="style:name"><xsl:value-of select="concat('ro', $table-pos, '-',$rowNodeIndex)"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="style:family">table-row</xsl:attribute>


            <xsl:element name="style:table-row-properties">
                <xsl:choose>
                    <xsl:when test="@ss:Height">
                        <xsl:attribute name="style:row-height">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="concat(@ss:Height,'pt')"/>
                            </xsl:call-template>
                            <xsl:text>cm</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style:row-height">
                            <xsl:value-of select="$default-row-height"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="@ss:AutoFitHeight">
                        <xsl:choose>
                            <xsl:when test="@ss:AutoFitHeight = '0'">
                                <xsl:attribute name="style:use-optimal-row-height">false</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:use-optimal-row-height">true</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="@ss:Height &gt; 0">
                                <xsl:attribute name="style:use-optimal-row-height">false</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:use-optimal-row-height">true</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:attribute name="fo:break-before">auto</xsl:attribute>
                <!-- apply to background  -->
                <xsl:apply-templates select="key('Style', @ss:StyleID)/ss:Interior" mode="style-style-content"/>
            </xsl:element>
            <!--
                <xsl:apply-templates select="key('Style', ss:Row[position() = $rowNodeIndex]/@ss:StyleID)" mode="style-style-content" />
            -->
        </xsl:element>


    </xsl:template>

    <xsl:template name="count-spanned-columns">
        <xsl:param name="expandedColumnCount" select="0"/>
        <xsl:param name="columns"/>
        <xsl:param name="columnsCount" select="count($columns)"/>
        <xsl:param name="columnIndex" select="1"/>
        <xsl:choose>
            <xsl:when test="$columnIndex &lt;= $columnsCount">
                <xsl:call-template name="count-spanned-columns">
                    <xsl:with-param name="columns" select="$columns"/>
                    <xsl:with-param name="columnsCount" select="$columnsCount"/>
                    <xsl:with-param name="columnIndex" select="$columnIndex + 1"/>
                    <xsl:with-param name="expandedColumnCount" select="$expandedColumnCount + $columns[$columnIndex]/@ss:Span"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$expandedColumnCount"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ss:Worksheet">
        <xsl:element name="table:table">
            <xsl:attribute name="table:name">
                <xsl:value-of select="@ss:Name"/>
            </xsl:attribute>
            <!-- other attributes aren't suitable to apply yet -->
            <xsl:if test="ss:Table">
                <xsl:attribute name="table:style-name">
                    <xsl:value-of select="concat( 'ta', count(preceding-sibling::ss:Worksheet)+1)"/>
                </xsl:attribute>
                <xsl:if test="@ss:Protected = '1'">
                    <xsl:attribute name="table:protected">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="descendant::ss:NamedRange[@ss:Name = 'Print_Area' and contains( @ss:RefersTo, '!R')]">
                    <xsl:variable name="referto">
                        <xsl:call-template name="translate-expression">
                            <xsl:with-param name="cell-row-pos" select="0"/>
                            <xsl:with-param name="cell-column-pos" select="0"/>
                            <xsl:with-param name="expression" select="descendant::ss:NamedRange/@ss:RefersTo"/>
                            <xsl:with-param name="return-value" select="''"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="table:print-ranges">
                        <xsl:value-of select="translate( $referto, '=', '$')"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:variable name="table-pos">
                    <xsl:value-of select="count(../preceding-sibling::ss:Worksheet)+1"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="ss:Table/@ss:ExpandedColumnCount">
                        <xsl:choose>
                            <xsl:when test="not(ss:Table/ss:Column)">
                                <!-- no columns exist -->
                                <xsl:call-template name="create-columns-without-input">
                                    <xsl:with-param name="table-pos" select="$table-pos"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="create-columns">
                                    <xsl:with-param name="columnCount" select="ss:Table/@ss:ExpandedColumnCount"/>
                                    <xsl:with-param name="currentColumnNode" select="ss:Table/ss:Column[1]"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="ss:Table/ss:Column/@ss:Span">
                                <!-- No absolute column number (ss:ExpandedColumnCount) is add the nodes and spanned columns -->
                                <xsl:variable name="spannedColumns">
                                    <xsl:call-template name="count-spanned-columns">
                                        <xsl:with-param name="columns" select="ss:Table/ss:Column[@ss:Span]"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:call-template name="create-columns">
                                    <xsl:with-param name="columnCount" select="count(ss:Table/ss:Column) + number($spannedColumns)"/>
                                    <xsl:with-param name="currentColumnNode" select="ss:Table/ss:Column[1]"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- No absolute column number (ss:ExpandedColumnCount) is add the nodes -->
                                <xsl:call-template name="create-columns">
                                    <xsl:with-param name="columnCount" select="count(ss:Table/ss:Column)"/>
                                    <xsl:with-param name="currentColumnNode" select="ss:Table/ss:Column[1]"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- generates the string of row\column position if ConditionalFormatting exists -->
                <xsl:variable name="condition-pos-str1">
                    <xsl:if test="./x:ConditionalFormatting">
                        <xsl:call-template name="condition-row-column-string">
                            <xsl:with-param name="last" select="''"/>
                            <xsl:with-param name="total" select="count(./x:ConditionalFormatting)"/>
                            <xsl:with-param name="index" select="1"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="condition-pos-str2">
                    <xsl:if test="./x:DataValidation">
                        <xsl:call-template name="validation-row-column-string">
                            <xsl:with-param name="last" select="''"/>
                            <xsl:with-param name="total" select="count(./x:DataValidation)"/>
                            <xsl:with-param name="index" select="1"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="condition-pos-str" select="concat($condition-pos-str1, $condition-pos-str2)"/>
                <xsl:choose>
                    <xsl:when test="./ss:Table/ss:Row">
                        <xsl:variable name="worksheetNo" select="count(preceding-sibling::ss:Worksheet)+1"/>
                        <xsl:variable name="rowNodeCount" select="count(ss:Table/ss:Row)"/>
                        <xsl:variable name="expandedRowCount">
                            <xsl:call-template name="get-expanded-row-count"/>
                        </xsl:variable>
                        <xsl:variable name="expandedColumnCount">
                            <xsl:call-template name="get-expanded-column-count"/>
                        </xsl:variable>
                        <xsl:for-each select="ss:Table/ss:Row">
                            <xsl:apply-templates select="." mode="create-rows">
                                <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                                <xsl:with-param name="rowNodeCount" select="$rowNodeCount"/>
                                <xsl:with-param name="rowNodeIndex" select="position()"/>
                                <xsl:with-param name="expandedRowCount" select="$expandedRowCount"/>
                                <xsl:with-param name="expandedRowCountIndex" select="1"/>
                                <xsl:with-param name="expandedColumnCount" select="$expandedColumnCount"/>
                            </xsl:apply-templates>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="./x:PageBreaks/x:RowBreaks">
                                <xsl:for-each select="./x:PageBreaks/x:RowBreaks/x:RowBreak">
                                    <xsl:variable name="number-repeated">
                                        <xsl:choose>
                                            <xsl:when test="position() = 1">
                                                <xsl:value-of select="./x:Row"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select=". - preceding::x:RowBreak[position()=count(.)]/x:Row - 1"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:if test="$number-repeated &gt; 0">
                                        <xsl:element name="table:table-row">
                                            <xsl:if test="@ss:Hidden = '1'">
                                                <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                                            </xsl:if>
                                            <xsl:attribute name="table:style-name">
                                                <xsl:value-of select="concat('ro',$table-pos)"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="table:number-rows-repeated">
                                                <xsl:value-of select="$number-repeated"/>
                                            </xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="ss:Table/@ss:ExpandedColumnCount">
                                                    <table:table-cell table:number-columns-repeated="{ss:Table/@ss:ExpandedColumnCount}"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <!-- OASIS XML row can not be empty -->
                                                    <table:table-cell table:number-columns-repeated="256"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="table:table-row">
                                        <xsl:if test="@ss:Hidden = '1'">
                                            <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                                        </xsl:if>
                                        <xsl:attribute name="table:style-name">
                                            <xsl:value-of select="concat('rob',$table-pos)"/>
                                        </xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="ss:Table/@ss:ExpandedColumnCount">
                                                <table:table-cell table:number-columns-repeated="{ss:Table/@ss:ExpandedColumnCount}"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <!-- OASIS XML row can not be empty -->
                                                <table:table-cell table:number-columns-repeated="256"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- in case no table row exists (empty spreadsheet) -->
                                <xsl:element name="table:table-row">
                                    <xsl:choose>
                                        <xsl:when test="ss:Table/@ss:StyleID">
                                            <xsl:attribute name="table:style-name">
                                                <xsl:value-of select="ss:Table/@ss:StyleID"/>
                                            </xsl:attribute>
                                            <xsl:element name="table:table-cell">
                                                <xsl:attribute name="table:style-name">
                                                    <xsl:value-of select="ss:Table/@ss:StyleID"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="table:style-name">
                                                <xsl:value-of select="concat('ro',$table-pos)"/>
                                            </xsl:attribute>
                                            <xsl:element name="table:table-cell"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="./x:ConditionalFormatting">
                            <xsl:variable name="condition-row-max">
                                <xsl:call-template name="condition-row-col-pos-max">
                                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                    <xsl:with-param name="last-value" select="0"/>
                                    <xsl:with-param name="div-value" select="'R'"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="condition-col-max">
                                <xsl:call-template name="condition-row-col-pos-max">
                                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                    <xsl:with-param name="last-value" select="0"/>
                                    <xsl:with-param name="div-value" select="'C'"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="break-row-max">
                                <xsl:call-template name="break-row-beyond-max">
                                    <xsl:with-param name="pos" select="1"/>
                                    <xsl:with-param name="last-value" select="0"/>
                                    <xsl:with-param name="count-value" select="count(./x:PageBreaks/x:RowBreaks/x:RowBreak)"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="end-value">
                                <xsl:choose>
                                    <xsl:when test="$condition-row-max &lt; $break-row-max">
                                        <xsl:value-of select="$break-row-max"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$condition-row-max"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:call-template name="get-row-beyond-last">
                                <xsl:with-param name="index-value" select="1"/>
                                <xsl:with-param name="worksheetNo" select="count(preceding-sibling::ss:Worksheet)+1"/>
                                <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                <xsl:with-param name="end-pos" select="$end-value"/>
                                <xsl:with-param name="total-col" select="$condition-col-max"/>
                            </xsl:call-template>
                        </xsl:if>
                        <!-- if exists attribute of StyleID in tag of ss:Table but no Row/Column -->
                        <xsl:if test="./ss:Table/@ss:StyleID">
                            <table:table-row table:style-name="{concat('ro',$table-pos)}" table:number-rows-repeated="65564">
                                <table:table-cell table:number-columns-repeated="256"/>
                            </table:table-row>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <!-- Note: Need to be refactored -->
    <xsl:template name="create-columns-without-input">
        <xsl:param name="table-pos"/>
        <xsl:choose>
            <xsl:when test="./x:PageBreaks/x:ColBreaks">
                <xsl:for-each select="./x:PageBreaks/x:ColBreaks/x:ColBreak">
                    <xsl:variable name="number-repeated">
                        <xsl:choose>
                            <xsl:when test="position() = 1">
                                <xsl:value-of select="./x:Column"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select=". - preceding::x:ColBreak[position()=count(.)]/x:Column - 1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$number-repeated &gt; 0">
                        <xsl:element name="table:table-column">
                            <xsl:if test="ancestor::ss:Worksheet/ss:Table/@ss:StyleID">
                                <xsl:attribute name="table:default-cell-style-name">
                                    <xsl:value-of select="ancestor::ss:Worksheet/ss:Table/@ss:StyleID"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@ss:Hidden = '1'">
                                <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="table:style-name">
                                <xsl:value-of select="concat('co',$table-pos)"/>
                            </xsl:attribute>
                            <xsl:attribute name="table:number-columns-repeated">
                                <xsl:value-of select="$number-repeated"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="table:table-column">
                        <!-- column style be made out beforehead -->
                        <xsl:if test="ancestor::ss:Worksheet/ss:Table/@ss:StyleID">
                            <xsl:attribute name="table:default-cell-style-name">
                                <xsl:value-of select="ancestor::ss:Worksheet/ss:Table/@ss:StyleID"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@ss:Hidden = '1'">
                            <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="table:style-name">
                            <xsl:value-of select="concat('cob',$table-pos)"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="table:table-column">
                    <xsl:choose>
                        <xsl:when test="ss:Table/@ss:StyleID">
                            <xsl:attribute name="table:style-name">
                                <xsl:value-of select="ss:Table/@ss:StyleID"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="table:style-name">
                                <xsl:text>co1</xsl:text>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="ss:Table/@ss:ExpandedColumnCount and ss:Table/@ss:ExpandedColumnCount > 0">
                        <xsl:attribute name="table:number-columns-repeated">
                            <xsl:value-of select="ss:Table/@ss:ExpandedColumnCount"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="table:default-cell-style-name">
                        <xsl:text>Default</xsl:text>
                    </xsl:attribute>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--
     Example:
        <ss:Table>
            <ss:Column ss:Index="4" ss:Width="500" ss:Span="3" />
            <ss:Column ss:Width="200" />
        </ss:Table>

    Prior column (ss:Index - 1) is written
    The given fourth cell (ss:Index="4") is handled as repeated three times (ss:Span="3").
    The eight column got a width of "200"

    ContextNode: ss:Worksheet
    -->
    <xsl:key match="/ss:Workbook/ss:Worksheet/x:PageBreaks/x:ColBreaks/x:ColBreak" name="ColBreak" use="Column"/>
    <xsl:template name="create-columns">
        <xsl:param name="columnCount"/>
        <xsl:param name="currentColumn" select="1"/>
        <xsl:param name="finishedColumns" select="0"/>
        <xsl:param name="worksheetNo" select="count(preceding-sibling::ss:Worksheet)+1"/>
        <xsl:param name="currentColumnNode"/>
        <xsl:choose>
            <xsl:when test="$finishedColumns &lt; $columnCount">
                <xsl:choose>
                    <xsl:when test="$currentColumnNode">
                        <xsl:choose>
                            <xsl:when test="$currentColumnNode/@ss:Index - $finishedColumns &gt; 1">
                                <!-- found column with index.
                                 filling up table with empty columns until Index is reached -->
                                <xsl:call-template name="create-default-column">
                                    <xsl:with-param name="currentColumn" select="$currentColumn"/>
                                    <xsl:with-param name="currentColumnNode" select="$currentColumnNode"/>
                                    <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                                </xsl:call-template>
                                <xsl:call-template name="create-columns">
                                    <xsl:with-param name="columnCount" select="$columnCount"/>
                                    <xsl:with-param name="currentColumn" select="$currentColumn"/>
                                    <xsl:with-param name="currentColumnNode" select="$currentColumnNode"/>
                                    <xsl:with-param name="finishedColumns" select="$finishedColumns + 1"/>
                                    <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="table:table-column">
                                    <xsl:if test="$currentColumnNode/@ss:Hidden = '1'">
                                        <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="$currentColumnNode/@ss:Span">
                                        <xsl:attribute name="table:number-columns-repeated">
                                            <xsl:value-of select="$currentColumnNode/@ss:Span + 1"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when test="key('ColBreak', $currentColumn)">
                                            <xsl:attribute name="table:style-name">
                                                <xsl:value-of select="concat('cob', $worksheetNo, '-', $currentColumn)"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="table:style-name">
                                                <xsl:value-of select="concat('co', $worksheetNo, '-', $currentColumn)"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="$currentColumnNode/@ss:StyleID">
                                            <xsl:attribute name="table:default-cell-style-name">
                                                <xsl:value-of select="$currentColumnNode/@ss:StyleID"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="table:default-cell-style-name">
                                                <xsl:text>Default</xsl:text>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:call-template name="create-columns">
                                    <xsl:with-param name="columnCount" select="$columnCount"/>
                                    <xsl:with-param name="currentColumn" select="$currentColumn + 1"/>
                                    <xsl:with-param name="finishedColumns">
                                        <xsl:choose>
                                            <xsl:when test="$currentColumnNode/@ss:Span">
                                                <xsl:value-of select="$finishedColumns + $currentColumnNode/@ss:Span + 1"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$finishedColumns + 1"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                    <xsl:with-param name="currentColumnNode" select="ss:Table/ss:Column[$currentColumn + 1]"/>
                                    <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                    <!--                                 <xsl:if test="not($finishedColumns + 1 = $columnCount)"> -->
                        <xsl:call-template name="create-default-column">
                            <xsl:with-param name="currentColumn" select="$currentColumn"/>
                            <xsl:with-param name="currentColumnNode" select="$currentColumnNode"/>
                            <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                        </xsl:call-template>
                        <xsl:call-template name="create-columns">
                            <xsl:with-param name="columnCount" select="$columnCount"/>
                            <xsl:with-param name="currentColumn" select="$currentColumn"/>
                            <xsl:with-param name="finishedColumns" select="$finishedColumns + 1"/>
                            <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$currentColumn = $columnCount">
                    <!-- Note: name test document for this case and refactor the template -->
                    <xsl:if test="x:PageBreaks/x:ColBreaks/x:ColBreak/x:Column &gt; $finishedColumns">
                        <xsl:call-template name="get-column-beyond-last">
                            <xsl:with-param name="index-value" select="$finishedColumns"/>
                            <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                        </xsl:call-template>
                    </xsl:if>
                    <!--Note: Test Scenario for this case: generates some special tags for whole row style
                <xsl:if test="(./ss:Table[@ss:StyleID] or ./ss:Table/ss:Row[@ss:StyleID]) and (256 - $finishedColumns &gt; 0)">
                    <xsl:element name="table:table-column">
                        <xsl:attribute name="table:default-cell-style-name"><xsl:choose><xsl:when test="./ss:Table[@ss:StyleID]"><xsl:value-of select="./ss:Table/@ss:StyleID" /></xsl:when><xsl:otherwise><xsl:value-of select="'Default'" /></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="table:style-name"><xsl:value-of select="'co1'" /></xsl:attribute>
                        <xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="256 - $finishedColumns" /></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                -->
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="create-default-column">
        <xsl:param name="currentColumn"/>
        <xsl:param name="currentColumnNode"/>
        <xsl:param name="worksheetNo"/>
        <xsl:param name="nextColumnNo"/>
        <xsl:element name="table:table-column">
            <xsl:attribute name="table:default-cell-style-name">
                <xsl:call-template name="get-default-cell-style">
                    <xsl:with-param name="currentColumnNode" select="$currentColumnNode"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-- <xsl:attribute name="table:default-cell-style-name"><xsl:value-of select="$nextColumnNo - $currentColumn"/></xsl:attribute>  -->
            <xsl:choose>
                <xsl:when test="key('ColBreak', $currentColumn)">
                    <xsl:attribute name="table:style-name">
                        <xsl:value-of select="concat('cob',$worksheetNo)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="table:style-name">
                        <xsl:value-of select="concat('co',$worksheetNo)"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template name="create-rows">
        <xsl:param name="condition-pos-str"/>
        <xsl:apply-templates select="ss:Table/ss:Row[1]" mode="create-rows">
            <xsl:with-param name="worksheetNo" select="count(preceding-sibling::ss:Worksheet)+1"/>
            <xsl:with-param name="rowNodeCount" select="count(ss:Table/ss:Row)"/>
            <xsl:with-param name="rowNodeIndex" select="1"/>
            <xsl:with-param name="expandedRowCount">
                <xsl:call-template name="get-expanded-row-count"/>
            </xsl:with-param>
            <xsl:with-param name="expandedRowCountIndex" select="1"/>
            <xsl:with-param name="expandedColumnCount">
                <xsl:call-template name="get-expanded-column-count"/>
            </xsl:with-param>
            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="ss:Row" mode="create-rows">
        <xsl:param name="worksheetNo"/>
        <xsl:param name="rowNodeCount"/>
        <xsl:param name="rowNodeIndex"/>
        <xsl:param name="expandedRowCount"/>
        <xsl:param name="expandedColumnCount"/>
        <xsl:param name="condition-pos-str"/>
        <xsl:variable name="simple-span-value" select="@ss:Span + count(@ss:Span)"/>
        <xsl:variable name="expandedRowCountIndex">
                <xsl:choose>
                    <xsl:when test="@ss:Index"><xsl:value-of select="@ss:Index -1 + $simple-span-value"/></xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="recent-index" select="preceding-sibling::ss:Row[@ss:Index][last()]"></xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$recent-index">
                                <xsl:variable name="nodes-up-to-current" select="set:intersection(preceding-sibling::ss:Row, $recent-index/following-sibling::ss:Row)"></xsl:variable>
                                <xsl:variable name="allSpans" select="$nodes-up-to-current/@ss:Span"/>
                                <xsl:value-of select="$recent-index/@ss:Index + count($nodes-up-to-current) + sum($allSpans) + count($allSpans)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="allSpans" select="preceding-sibling::ss:Row/@ss:Span"/>
                                <xsl:value-of select="$rowNodeIndex + sum($allSpans) + count($allSpans)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
        </xsl:variable>
        <xsl:variable name="currentRowNo">
            <xsl:choose>
                <xsl:when test="@ss:Index">
                    <xsl:value-of select="@ss:Index"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$expandedRowCountIndex"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="@ss:Index - $expandedRowCountIndex &gt; 0">
            <!-- create the preceding missing rows -->
            <xsl:element name="table:table-row">
                <!-- fill the preceding gap with rows without a cell -->
                <xsl:attribute name="table:number-rows-repeated">
                    <xsl:value-of select="@ss:Index - $expandedRowCountIndex"/>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$expandedColumnCount != 0">
                        <table:table-cell table:number-columns-repeated="{$expandedColumnCount}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- OASIS XML row can not be empty -->
                        <table:table-cell table:number-columns-repeated="256"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
        <xsl:element name="table:table-row">
            <xsl:attribute name="table:style-name">
                <xsl:choose>
                    <xsl:when test="@ss:StyleID">
                        <xsl:value-of select="concat('ro',$worksheetNo, '-',$rowNodeIndex,'-', @ss:StyleID)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('ro',$worksheetNo,'-',$rowNodeIndex)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="@ss:Hidden = '1'">
                <xsl:attribute name="table:visibility">collapse</xsl:attribute>
            </xsl:if>
            <xsl:if test="@ss:Span">
                <xsl:attribute name="table:number-rows-repeated">
                    <xsl:value-of select="@ss:Span + 1"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <!-- Excel row without content -->
                <xsl:when test="not(*)">
                    <!-- OASIS OpenDocument Format does not allow rows without a cell -->
                    <xsl:choose>
                        <xsl:when test="$expandedColumnCount != 0">
                            <table:table-cell table:number-columns-repeated="{$expandedColumnCount}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- OASIS XML row can not be empty -->
                            <table:table-cell table:number-columns-repeated="256"/>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="create-cells">
                        <xsl:with-param name="row-pos" select="$currentRowNo"/>
                        <xsl:with-param name="expandedColumnCount" select="$expandedColumnCount"/>
                        <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>

    </xsl:template>

    <xsl:template name="get-expanded-column-count">
        <xsl:choose>
            <xsl:when test="ss:Table/@ss:ExpandedColumnCount">
                <xsl:value-of select="ss:Table/@ss:ExpandedColumnCount"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="ss:Table/ss:Column/@ss:Span">
                        <!-- No absolute column number (ss:ExpandedColumnCount) is add the nodes and spanned columns -->
                        <xsl:variable name="spannedColumns">
                            <xsl:call-template name="count-spanned-columns">
                                <xsl:with-param name="columns" select="ss:Table/ss:Column[@ss:Span]"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="count(ss:Table/ss:Column) + number($spannedColumns)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- No absolute column number (ss:ExpandedColumnCount) is add the nodes -->
                        <xsl:value-of select="count(ss:Table/ss:Column)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-expanded-row-count">
        <xsl:choose>
            <xsl:when test="ss:Table/@ss:ExpandedRowCount">
                <xsl:value-of select="ss:Table/@ss:ExpandedRowCount"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="ss:Table/ss:Row/@ss:Index and not(ss:Table/ss:Row/@ss:Span)">
                        <xsl:variable name="lastIndexedRow" select="ss:Table/ss:Row[@ss:Index][last()]"/>
                        <xsl:value-of select="number($lastIndexedRow/@ss:Index) + count($lastIndexedRow/following-sibling::ss:Row)"/>
                    </xsl:when>
                    <xsl:when test="ss:Table/ss:Row/@ss:Index and ss:Table/ss:Row/@ss:Span">
                        <xsl:variable name="lastIndexedRow" select="ss:Table/ss:Row[@ss:Index][last()]"/>
                        <xsl:variable name="spannedRows">
                            <xsl:call-template name="count-spanned-rows">
                                <xsl:with-param name="rows" select="$lastIndexedRow/following-sibling::ss:Row[@ss:Span]"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="number($lastIndexedRow/@ss:Index) + count($lastIndexedRow/following-sibling::ss:Row) + number($spannedRows)"/>
                    </xsl:when>
                    <xsl:when test="not(ss:Table/ss:Row/@ss:Index) and ss:Table/ss:Row/@ss:Span">
                        <xsl:variable name="spannedRows">
                            <xsl:call-template name="count-spanned-rows">
                                <xsl:with-param name="rows" select="ss:Table/ss:Rows[@ss:Span]"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="count(ss:Table/ss:Row + number($spannedRows))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="count(ss:Table/ss:Row)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="count-spanned-rows">
        <xsl:param name="expandedRowCount" select="0"/>
        <xsl:param name="rows"/>
        <xsl:param name="rowsCount" select="count($rows)"/>
        <xsl:param name="rowIndex" select="1"/>
        <xsl:choose>
            <xsl:when test="$rowIndex &lt;= $rowsCount">
                <xsl:call-template name="count-spanned-rows">
                    <xsl:with-param name="rows" select="$rows"/>
                    <xsl:with-param name="rowsCount" select="$rowsCount"/>
                    <xsl:with-param name="rowIndex" select="$rowIndex + 1"/>
                    <xsl:with-param name="expandedRowCount" select="$expandedRowCount + $rows[$rowIndex]/@ss:Span"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$expandedRowCount"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-default-cell-style">
        <xsl:param name="currentColumnNode"/>
        <xsl:choose>
            <xsl:when test="$currentColumnNode">
                <xsl:choose>
                    <xsl:when test="$currentColumnNode/@ss:StyleID">
                        <xsl:value-of select="$currentColumnNode/@ss:StyleID"/>
                    </xsl:when>
                    <xsl:otherwise>Default</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="./ss:Table[@ss:StyleID]">
                        <xsl:value-of select="./ss:Table/@ss:StyleID"/>
                    </xsl:when>
                    <xsl:otherwise>Default</xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-row-beyond-last">
        <!-- dealing the RowBreak after last row by recursion -->
        <xsl:param name="index-value"/>
        <xsl:param name="worksheetNo"/>
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="end-pos"/>
        <xsl:param name="total-col"/>
        <xsl:variable name="current" select="concat('R',$index-value)"/>
        <xsl:element name="table:table-row">
            <xsl:choose>
                <xsl:when test="./x:PageBreaks/x:RowBreaks/x:RowBreak/x:Row = ($index-value - 1)">
                    <xsl:attribute name="table:style-name">
                        <xsl:value-of select="concat('rob',$worksheetNo)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="table:style-name">
                        <xsl:value-of select="concat('ro',$worksheetNo)"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <!-- Note: 2 be refactored
                <xsl:when test="./ss:Table/ss:Column[@ss:StyleID] or ./ss:Table[@ss:StyleID]">
                    <xsl:if test="256 - count(ss:Table/ss:Column) &gt; 0">
                        <table:table-cell table:number-columns-repeated="{256 - count(ss:Table/ss:Column)}" />
                    </xsl:if>
                </xsl:when>-->
                <xsl:when test="contains($condition-pos-str,$current)">
                    <xsl:call-template name="create-spanning-cells">
                        <xsl:with-param name="row-pos" select="$index-value"/>
                        <xsl:with-param name="c-start" select="1"/>
                        <xsl:with-param name="c-end" select="$total-col"/>
                        <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <!-- OASIS XML does not allow rows without a cell -->
                    <table:table-cell/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:if test="$index-value &lt; ($end-pos + 1)">
            <xsl:call-template name="get-row-beyond-last">
                <xsl:with-param name="index-value" select="$index-value + 1"/>
                <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                <xsl:with-param name="end-pos" select="$end-pos"/>
                <xsl:with-param name="total-col" select="$total-col"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="break-row-beyond-max">
        <!-- returns the max position of the row from condition-pos-str -->
        <xsl:param name="pos"/>
        <xsl:param name="last-value"/>
        <xsl:param name="count-value"/>
        <xsl:variable name="pre-value" select="./x:PageBreaks/x:RowBreaks/x:RowBreak[position() = $pos]/x:Row"/>
        <xsl:variable name="end-value">
            <xsl:choose>
                <xsl:when test="$last-value &lt; $pre-value">
                    <xsl:value-of select="$pre-value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$last-value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$pos &lt; $count-value">
                <xsl:call-template name="break-row-beyond-max">
                    <xsl:with-param name="pos" select="$pos + 1"/>
                    <xsl:with-param name="last-value" select="$end-value"/>
                    <xsl:with-param name="count-value" select="$count-value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$end-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-column-beyond-last">
        <!-- dealing the ColBreak after last column by recursion -->
        <xsl:param name="index-value"/>
        <xsl:param name="worksheetNo"/>
        <xsl:for-each select="./x:PageBreaks/x:ColBreaks/x:ColBreak">
            <xsl:variable name="each-column-value" select="./x:Column"/>
            <xsl:choose>
                <xsl:when test="$each-column-value + 1 &gt; $index-value">
                    <xsl:variable name="number-repeated">
                        <xsl:choose>
                            <xsl:when test="preceding-sibling::x:ColBreak[position()=count(.)]/x:Column + 1 = $index-value">
                                <xsl:value-of select="$each-column-value - preceding-sibling::x:ColBreak[position()=count(.)]/x:Column - 1"/>
                            </xsl:when>
                            <xsl:when test="preceding-sibling::x:ColBreak[position()=count(.)]/x:Column + 1 &gt; $index-value">
                                <xsl:value-of select="$each-column-value - preceding-sibling::x:ColBreak[position()=count(.)]/x:Column - 1"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$each-column-value - $index-value + 1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$number-repeated &gt; 0">
                        <xsl:element name="table:table-column">
                            <xsl:attribute name="table:style-name">
                                <xsl:value-of select="'co1'"/>
                            </xsl:attribute>
                            <xsl:attribute name="table:number-columns-repeated">
                                <xsl:value-of select="$number-repeated"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="table:table-column">
                        <xsl:if test="./../../../ss:Table[@ss:StyleID]">
                            <xsl:attribute name="table:default-cell-style-name">
                                <xsl:value-of select="./ss:Table/@ss:StyleID"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="table:style-name">
                            <xsl:value-of select="concat('cob',$worksheetNo)"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="$each-column-value + 1 = $index-value">
                    <xsl:element name="table:table-column">
                        <xsl:if test="./../../../ss:Table[@ss:StyleID]">
                            <xsl:attribute name="table:default-cell-style-name">
                                <xsl:value-of select="./../../../ss:Table/@ss:StyleID"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="table:style-name">
                            <xsl:value-of select="concat('cob',$worksheetNo)"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="create-spanning-cells">
        <!-- judge the position of the Cell in the condition-pos-str -->
        <xsl:param name="row-pos"/>
        <xsl:param name="c-start"/>
        <xsl:param name="c-end"/>
        <xsl:param name="condition-pos-str"/>

        <xsl:variable name="current" select="concat('R',$row-pos,'C',$c-start,',')"/>
        <xsl:variable name="style-name">
            <xsl:choose>
                <xsl:when test="contains($condition-pos-str,$current)">
                    <xsl:variable name="temp-str">
                        <xsl:call-template name="condition-str">
                            <xsl:with-param name="param-str" select="substring-before($condition-pos-str,$current)"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="starts-with($temp-str, 'c')">
                            <xsl:value-of select="concat('ce', substring-after($temp-str, 'c'))"/>
                        </xsl:when>
                        <xsl:when test="starts-with($temp-str, 'v')">
                            <xsl:value-of select="concat('val', substring-after($temp-str, 'v'))"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <!-- as for the spanned cells no style is taken... -->
                    <xsl:choose>
                        <!-- inherit style from parent row style-->
                        <xsl:when test="../@ss:StyleID">
                            <xsl:value-of select="../@ss:StyleID"/>
                        </xsl:when>
                        <!-- if no correspondent column style exists... -->
                        <!-- inherit style from parent table style -->
                        <xsl:when test="../../@ss:StyleID">
                            <!-- function to give in col-pos and get back column style  -->
                            <xsl:variable name="relatedColumnStyle">
                                <xsl:call-template name="get-related-column-style">
                                    <!-- the given position of the cell in the table, a column style is searched -->
                                    <xsl:with-param name="calculatedCellPosition" select="$c-start" />
                                    <!-- all columns in XML -->
                                    <xsl:with-param name="columnXMLNodes" select="../../ss:Column"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:if test="$relatedColumnStyle = ''">
                                <xsl:value-of select="../../@ss:StyleID"/>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="table:table-cell">
            <xsl:if test="not($style-name = '')">
                <xsl:choose>
                    <xsl:when test="starts-with($style-name, 'val')">
                        <xsl:attribute name="table:content-validation-name">
                            <xsl:value-of select="$style-name"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="starts-with($style-name, 'ce')">
                        <xsl:attribute name="table:style-name">
                            <xsl:value-of select="$style-name"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="table:style-name">
                            <xsl:value-of select="$style-name"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="$c-start &lt; $c-end">
                <xsl:attribute name="table:number-columns-repeated">
                    <xsl:value-of select="$c-end - $c-start + 1"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="condition-row-col-pos-max">
        <!-- returns the max position of the column or row from condition-pos-str -->
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="last-value"/>
        <xsl:param name="div-value"/>
        <xsl:variable name="pre-value">
            <xsl:choose>
                <xsl:when test="$div-value = 'R'">
                    <xsl:value-of select="substring-before(substring-after($condition-pos-str,$div-value),'C')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(substring-after($condition-pos-str,$div-value),',')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="end-value">
            <xsl:choose>
                <xsl:when test="$last-value &lt; $pre-value">
                    <xsl:value-of select="$pre-value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$last-value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($condition-pos-str,$div-value)">
                <xsl:call-template name="condition-row-col-pos-max">
                    <xsl:with-param name="condition-pos-str" select="substring-after($condition-pos-str,$div-value)"/>
                    <xsl:with-param name="last-value" select="$end-value"/>
                    <xsl:with-param name="div-value" select="$div-value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$end-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="condition-str">
        <!-- returns the string of style name of condition-pos-str -->
        <xsl:param name="param-str"/>
        <xsl:choose>
            <xsl:when test="contains($param-str,'(')">
                <xsl:call-template name="condition-str">
                    <xsl:with-param name="param-str" select="substring-after($param-str,'(')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring-before($param-str,':')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:key name="Style" match="/ss:Workbook/ss:Styles/ss:Style" use="@ss:ID"/>
    <xsl:template name="create-cells">
        <xsl:param name="row-pos"/>
        <xsl:param name="expandedColumnCount"/>
        <xsl:param name="condition-pos-str"/>
        <xsl:choose>
            <xsl:when test="ss:Cell">
                <xsl:apply-templates select="ss:Cell[1]" mode="selected">
                    <xsl:with-param name="row-pos" select="$row-pos"/>
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    <xsl:with-param name="col-pos-max" select="$expandedColumnCount"/>
                    <!--
                        <xsl:call-template name="condition-row-col-pos-max">
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str" />
                            <xsl:with-param name="last-value" select="0" />
                            <xsl:with-param name="div-value" select="'C'" />
                        </xsl:call-template>
                    </xsl:with-param> -->
                    <xsl:with-param name="col-pos-written" select="0"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="current" select="concat('R',$row-pos,'C')"/>
                <xsl:choose>
                    <xsl:when test="contains($condition-pos-str,$current)">
                        <xsl:call-template name="create-spanning-cells">
                            <xsl:with-param name="row-pos" select="$row-pos"/>
                            <xsl:with-param name="c-start" select="1"/>
                            <xsl:with-param name="c-end">
                                <xsl:call-template name="condition-row-col-pos-max">
                                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                    <xsl:with-param name="last-value" select="0"/>
                                    <xsl:with-param name="div-value" select="'C'"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            <xsl:with-param name="col-pos" select="1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- OASIS XML does not allow an empty row -->
                        <xsl:choose>
                            <xsl:when test="$expandedColumnCount != 0">
                                <table:table-cell table:number-columns-repeated="{$expandedColumnCount}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- OASIS XML row can not be empty -->
                                <table:table-cell table:number-columns-repeated="256"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ss:Cell" name="ss:Cell" mode="selected">
        <!-- Contains the max position of the column or row from the concatenation from
            x:ConditionalFormatting
                and
            x:DataValidation -->
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="col-pos-max"/>
        <xsl:param name="col-pos-written" select="0"/>
        <xsl:param name="col-pos-current" select="0"/>
        <xsl:param name="row-pos"/>
        <xsl:param name="col-repeated" select="1"/>

        <!-- The column position of the cell (might jumped by ss:Index) -->
        <xsl:variable name="col-pos">
            <xsl:choose>
                <xsl:when test="@ss:Index">
                    <xsl:choose>
                        <xsl:when test="@ss:MergeAcross">
                            <xsl:value-of select="@ss:MergeAcross + @ss:Index"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@ss:Index"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="@ss:MergeAcross">
                            <xsl:value-of select="1 + @ss:MergeAcross + $col-pos-current"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="1 + $col-pos-current"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="nextCell" select="following-sibling::ss:Cell[1]"/>
        <!-- Multiple empty cells with the same or no style will be moved to one cell with a 'table:number-columns-repeated' attribute -->
        <xsl:variable name="cell-is-repeatable" select="
                                                        not(current()/*)
                                                    and
                                                        not(current()/text())
                                                    and
                                                        (
                                                            not($nextCell)
                                                            and $col-pos &gt; $col-pos-written + 1
                                                        or
                                                            (
                                                                $nextCell
                                                                and
                                                                not($nextCell/*)
                                                                and
                                                                not($nextCell/text())
                                                                and
                                                                (
                                                                    (current()/@ss:StyleID = $nextCell/@ss:StyleID)
                                                                    or
                                                                    (not(current()/@ss:StyleID) and not($nextCell/@ss:StyleID))
                                                                )
                                                                and
                                                                (
                                                                    not($nextCell/@ss:Index)
                                                                    or
                                                                       ($nextCell/@ss:Index = $col-pos + 1)
                                                                 )
                                                             )
                                                         ) "/>
        <xsl:choose>
            <!-- Scenario: The missing cells skipped by using the ss:Index attribute will be added -->
            <xsl:when test="@ss:Index and @ss:Index &gt; $col-pos-written + 1">
                <!-- In Open Document nothing comparable to Index exists,
                    the missing cells might have to be created, if they had content as only style will be repeated-->
                <xsl:call-template name="create-spanning-cells">
                    <xsl:with-param name="row-pos" select="$row-pos"/>
                    <xsl:with-param name="c-start" select="$col-pos-current + 1"/>
                    <xsl:with-param name="c-end" select="@ss:Index - 1"/>
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                </xsl:call-template>
                <xsl:call-template name="ss:Cell">
                    <xsl:with-param name="row-pos" select="$row-pos"/>
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                    <xsl:with-param name="col-pos-written" select="@ss:Index - 1"/>
                    <xsl:with-param name="col-pos-current" select="$col-pos"/>
                    <xsl:with-param name="col-repeated" select="$col-repeated"/>
                </xsl:call-template>
            </xsl:when>
            <!-- Scenario: A sequence of cells can be put together as one cell -->
            <xsl:when test="$cell-is-repeatable">
                <xsl:apply-templates select="$nextCell" mode="selected">
                    <xsl:with-param name="row-pos" select="$row-pos"/>
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                    <xsl:with-param name="col-pos-written" select="$col-pos-written"/>
                    <xsl:with-param name="col-pos-current" select="$col-pos"/>
                    <xsl:with-param name="col-repeated" select="$col-repeated"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <!-- if the cell wasn't repeated yet, created first -->
                <xsl:if test="$col-repeated = 1">
                    <xsl:element name="table:table-cell">
                        <!-- in case the cell has an Index and is repeatable (s.above) and therefore has not been repeated earlier  -->
                        <xsl:choose>
                            <xsl:when test="@ss:MergeAcross">
                                <xsl:if test="$col-pos - @ss:MergeAcross &gt; $col-pos-written + 1">
                                    <xsl:attribute name="table:number-columns-repeated">
                                        <xsl:value-of select="$col-pos - $col-pos-written"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$col-pos &gt; $col-pos-written + 1">
                                    <xsl:attribute name="table:number-columns-repeated">
                                        <xsl:value-of select="$col-pos - $col-pos-written"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:call-template name="create-table-cell-attributes">
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                            <xsl:with-param name="col-pos" select="$col-pos"/>
                            <xsl:with-param name="row-pos" select="$row-pos"/>
                        </xsl:call-template>
                        <xsl:call-template name="create-table-cell-content">
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                            <xsl:with-param name="col-pos" select="$col-pos"/>
                            <xsl:with-param name="row-pos" select="$row-pos"/>
                        </xsl:call-template>
                    </xsl:element>
                    <!-- ss:MergeAcross (column spanned) indicates a covered table-cell in Open Document XML-->
                    <xsl:if test="@ss:MergeAcross">
                        <xsl:element name="table:covered-table-cell">
                            <xsl:if test="@ss:MergeAcross &gt; 1">
                                <xsl:attribute name="table:number-columns-repeated">
                                    <xsl:value-of select="@ss:MergeAcross"/>
                                </xsl:attribute>
                            </xsl:if>
                        </xsl:element>
                    </xsl:if>
                </xsl:if>
                <xsl:choose>
                    <!-- the following block is not used, if the cell had been repeated earlier -->
                    <xsl:when test="$nextCell and not($cell-is-repeatable and $col-repeated = 1)">
                        <xsl:choose>
                            <!-- After cells can no longer be repeated write out the attribute -->
                            <xsl:when test="not($cell-is-repeatable) and $col-repeated > 1">
                                <xsl:attribute name="table:number-columns-repeated">
                                    <xsl:value-of select="$col-repeated"/>
                                </xsl:attribute>
                            </xsl:when>
                            <!-- At the end of the row -->
                            <xsl:when test="not($nextCell)">
                                <xsl:if test="../../../x:ConditionalFormatting">
                                    <!-- at the last position of the Cell tag,inspecting the following cell before condition-row-col-pos-max -->
                                    <xsl:call-template name="create-spanning-cells">
                                        <xsl:with-param name="row-pos" select="$row-pos"/>
                                        <xsl:with-param name="c-start" select="$col-pos"/>
                                        <xsl:with-param name="c-end" select="$col-pos-max"/>
                                        <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:when>
                            <!-- If the cells can not be repeated (default) -->
                            <xsl:when test="not($cell-is-repeatable)">
                                <!-- Traverse the following Cell -->
                                <xsl:apply-templates select="$nextCell" mode="selected">
                                    <xsl:with-param name="row-pos" select="$row-pos"/>
                                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                    <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                                    <xsl:with-param name="col-pos-written" select="$col-pos"/>
                                    <xsl:with-param name="col-pos-current" select="$col-pos"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <!-- Go on with started repetition -->
                            <xsl:otherwise>
                                <xsl:apply-templates select="$nextCell" mode="selected">
                                    <xsl:with-param name="row-pos" select="$row-pos"/>
                                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                    <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                                    <xsl:with-param name="col-pos-written" select="$col-pos"/>
                                    <xsl:with-param name="col-pos-current" select="$col-pos"/>
                                    <xsl:with-param name="col-repeated" select="$col-repeated + 1"/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="not($nextCell)">
                        <xsl:choose>
                            <xsl:when test="$col-repeated = 1 and ($col-pos &lt; $col-pos-max)">
                                <table:table-cell table:number-columns-repeated="{$col-pos-max - $col-pos}"/>
                            </xsl:when>
                            <xsl:when test="$col-repeated &gt; 1">
                                <xsl:attribute name="table:number-columns-repeated">
                                    <xsl:value-of select="$col-repeated"/>
                                </xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$nextCell" mode="skip">
                            <xsl:with-param name="row-pos" select="$row-pos"/>
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                            <xsl:with-param name="col-pos-written" select="$col-pos"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ss:Cell" mode="skip">
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="col-pos-max"/>
        <xsl:param name="col-pos-written"/>
        <xsl:param name="row-pos"/>

        <xsl:variable name="nextCell" select="following-sibling::ss:Cell[1]"/>
        <!-- Multiple empty cells with the same style will be moved to one cell with a 'table:number-columns-repeated' attribute -->
        <xsl:variable name="cell-is-repeatable" select="not($nextCell/*) and not($nextCell/text()) and ((current()/@ss:StyleID = $nextCell/@ss:StyleID) or (not(current()/@ss:StyleID) and not($nextCell/@ss:StyleID))) and not($nextCell/@ss:Index)"/>
        <xsl:choose>
            <xsl:when test="$cell-is-repeatable">
                <xsl:apply-templates select="$nextCell" mode="skip">
                    <xsl:with-param name="row-pos" select="$row-pos"/>
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                    <xsl:with-param name="col-pos-written" select="$col-pos-written + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$nextCell" mode="selected">
                    <xsl:with-param name="row-pos" select="$row-pos"/>
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                    <xsl:with-param name="col-pos-written" select="$col-pos-written + 1"/>
                    <xsl:with-param name="col-pos-current" select="$col-pos-written + 1"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="create-table-cell-attributes">
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="col-pos-max"/>
        <xsl:param name="col-pos"/>
        <xsl:param name="row-pos"/>

        <xsl:choose>
            <xsl:when test="$condition-pos-str">
                <xsl:call-template name="get-condition-dependent-cell-attributes">
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    <xsl:with-param name="current-pos-str" select="concat('R',$row-pos,'C',$col-pos,',')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@ss:StyleID">
                        <xsl:attribute name="table:style-name">
                            <xsl:value-of select="@ss:StyleID"/>
                        </xsl:attribute>
                    </xsl:when>
                    <!-- inherit style from parent row style-->
                    <xsl:when test="../@ss:StyleID">
                        <xsl:attribute name="table:style-name">
                            <xsl:value-of select="../@ss:StyleID"/>
                        </xsl:attribute>
                    </xsl:when>
                    <!-- if no correspondent column style exists... -->
                    <!-- inherit style from parent table style -->
                    <xsl:when test="../../@ss:StyleID">
                        <!-- function to give in col-pos and get back column style  -->
                        <xsl:variable name="relatedColumnStyle">
                            <xsl:call-template name="get-related-column-style">
                                <!-- the given position of the cell in the table, a column style is searched -->
                                <xsl:with-param name="calculatedCellPosition" select="$col-pos" />
                                <!-- all columns in XML -->
                                <xsl:with-param name="columnXMLNodes" select="../../ss:Column"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:if test="$relatedColumnStyle = ''">
                            <xsl:attribute name="table:style-name">
                                <xsl:value-of select="../../@ss:StyleID"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@ss:MergeAcross or @ss:MergeDown">
            <xsl:choose>
                <xsl:when test="@ss:MergeAcross">
                    <xsl:attribute name="table:number-columns-spanned">
                        <xsl:value-of select="@ss:MergeAcross + 1"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="table:number-columns-spanned">1</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="@ss:MergeDown">
                    <xsl:attribute name="table:number-rows-spanned">
                        <xsl:value-of select="@ss:MergeDown+1"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="table:number-rows-spanned">1</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="@ss:Formula">
            <!-- formula translation from Excel to Calc -->
            <xsl:variable name="calc-formula">
                <xsl:call-template name="translate-expression">
                    <xsl:with-param name="cell-row-pos" select="$row-pos"/>
                    <xsl:with-param name="cell-column-pos" select="$col-pos"/>
                    <xsl:with-param name="expression" select="@ss:Formula"/>
                    <xsl:with-param name="return-value" select="''"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="table:formula">
                <xsl:value-of select="$calc-formula"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="ss:Data">
            <xsl:variable name="data-format">
                <xsl:value-of select="key('Style', @ss:StyleID)/ss:NumberFormat/@ss:Format"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="ss:Data/@ss:Type = 'Number'">
                    <xsl:choose>
                        <xsl:when test="$data-format = 'Percent' or contains( $data-format, '%')">
                            <xsl:attribute name="office:value-type">percentage</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains(key('Style', @ss:StyleID)/ss:NumberFormat/@ss:Format, 'Currency')">
                            <xsl:attribute name="office:value-type">currency</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="office:value-type">float</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="office:value">
                        <xsl:value-of select="ss:Data"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="ss:Data/@ss:Type = 'DateTime'">
                    <xsl:choose>
                        <xsl:when test="(contains( $data-format, 'Date') or contains($data-format,'y') or contains($data-format,'g') or contains($data-format,'d') or contains($data-format,'e') or starts-with( substring( ss:Data, 11), 'T00:00:00.000' ) ) and (not (contains( $data-format, 'Time') ) )">
                            <xsl:attribute name="office:value-type">date</xsl:attribute>
                            <xsl:attribute name="office:date-value">
                                <xsl:value-of select="substring-before(ss:Data, 'T')"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="office:value-type">time</xsl:attribute>
                            <xsl:attribute name="office:time-value">
                                <xsl:value-of select="concat('P',substring(ss:Data, 11, 3), 'H', substring(ss:Data, 15, 2), 'M', substring(ss:Data, 18,2), 'S')"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="ss:Data/@ss:Type = 'Boolean'">
                    <xsl:attribute name="office:value-type">boolean</xsl:attribute>
                    <xsl:attribute name="office:boolean-value">
                        <xsl:choose>
                            <xsl:when test="ss:Data = '1'">true</xsl:when>
                            <xsl:otherwise>false</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="ss:Data/@ss:Type = 'String'">
                    <xsl:attribute name="office:value-type">string</xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="get-related-column-style">
        <!-- the given position of the cell in the table, a column style is searched -->
        <xsl:param name="calculatedCellPosition" />
        <!-- the current position of the column as XML node -->
        <xsl:param name="columnXMLPosition" select="1" />
        <!-- all columns in XML -->
        <xsl:param name="columnXMLNodes" />
        <!-- the ending column position of the earlier column style in the table -->
        <xsl:param name="earlierCalculatedColumnEnd" select="0" />

        <!-- the current column as XML node -->
        <xsl:variable name="columnXMLNode" select="$columnXMLNodes[1]" />
        <xsl:if test="$columnXMLNodes and count($columnXMLNodes) > 0">
            <!-- the starting column position of the style in the table -->
            <xsl:variable name="calculatedColumnStart">
                <!-- if ss:Index exists, this is the start of the column -->
                <xsl:choose>
                    <xsl:when test="$columnXMLNode/@ss:Index">
                        <xsl:value-of select="$columnXMLNode/@ss:Index" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$earlierCalculatedColumnEnd + 1" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- the ending column position of the style in the table -->
            <xsl:variable name="calculatedColumnEnd">
                <xsl:choose>
                    <xsl:when test="$columnXMLNode/@ss:Span">
                        <xsl:value-of select="$calculatedColumnStart + $columnXMLNode/@ss:Span" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$calculatedColumnStart" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$calculatedColumnStart &gt;= $calculatedCellPosition and $calculatedCellPosition &lt;= $calculatedColumnEnd">
                    <xsl:value-of select="$columnXMLNode/@ss:StyleID"/>
                </xsl:when>
                <xsl:when test="$calculatedColumnEnd &lt;= $calculatedCellPosition">
                    <xsl:call-template name="get-related-column-style">
                        <!-- the given position of the cell in the table, a column style is searched -->
                        <xsl:with-param name="calculatedCellPosition" select="$calculatedCellPosition" />
                        <!-- all columns in XML -->
                        <xsl:with-param name="columnXMLNodes" select="$columnXMLNodes[position() != 1]"/>
                        <!-- the ending column position of the style in the table -->
                        <xsl:with-param name="earlierCalculatedColumnEnd" select="$calculatedColumnEnd" />
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="create-table-cell-content">
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="col-pos-max"/>
        <xsl:param name="col-pos"/>
        <xsl:param name="row-pos"/>
        <xsl:apply-templates select="ss:Comment" mode="body"/>
        <xsl:if test="ss:Data">
            <text:p>
                <xsl:call-template name="create-data-content">
                    <xsl:with-param name="style-id" select="@ss:StyleID"/>
                </xsl:call-template>
            </text:p>
        </xsl:if>
    </xsl:template>
    <xsl:template name="create-data-content">
        <xsl:param name="style-id" select="@ss:StyleID"/>
        <xsl:choose>
            <xsl:when test="ss:Data//text()[string-length(.) != 0] and ss:Data[count(*)>0]">
                <xsl:for-each select="ss:Data//text()[string-length(.) != 0]">
                    <xsl:sort select="position(  )" order="ascending" data-type="number"/>
                    <text:span text:style-name="{concat($style-id, 'T', count(preceding::ss:Data[child::html:*]), '_', position())}">
                        <xsl:value-of select="."/>
                    </text:span>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains(key('Style', $style-id)/ss:Font/@ss:VerticalAlign, 'script')">
                <text:span text:style-name="{concat($style-id, 'T0')}">
                    <xsl:choose>
                        <xsl:when test="@ss:HRef">
                            <text:a xlink:href="{@ss:HRef}">
                                <xsl:value-of select="ss:Data"/>
                            </text:a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="ss:Data"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </text:span>
            </xsl:when>
            <xsl:when test="@ss:HRef">
                <text:a xlink:href="{@ss:HRef}">
                    <xsl:value-of select="ss:Data"/>
                </text:a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ss:Data"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-condition-dependent-cell-attributes">
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="current-pos-str"/>
        <xsl:variable name="temp-str">
            <xsl:call-template name="condition-str">
                <xsl:with-param name="param-str" select="substring-before($condition-pos-str,$current-pos-str)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="base-style-name">
            <xsl:choose>
                <xsl:when test="@ss:StyleID">
                    <xsl:value-of select="@ss:StyleID"/>
                </xsl:when>
                <xsl:when test="../@ss:StyleID">
                    <xsl:value-of select="../@ss:StyleID"/>
                </xsl:when>
                <xsl:when test="../../@ss:StyleID">
                    <xsl:value-of select="../../@ss:StyleID"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="style-name">
            <xsl:choose>
                <xsl:when test="contains($condition-pos-str, $current-pos-str) and starts-with($temp-str, 'c')">
                    <xsl:choose>
                        <xsl:when test="string-length($base-style-name) &gt; 0"><xsl:value-of select="concat($base-style-name, '-ce', substring-after($temp-str, 'c'))"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="concat('Default-ce', substring-after($temp-str, 'c'))"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$base-style-name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="starts-with($style-name, 'val')">
                <xsl:attribute name="table:content-validation-name">
                    <xsl:value-of select="$style-name"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="not($style-name = '')">
                <xsl:attribute name="table:style-name">
                    <xsl:value-of select="$style-name"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <!-- maybe multi functions occur at the same time in the same Cell, such as ConditionalFormatting and DataValidation -->
        <xsl:if test="contains($condition-pos-str, $current-pos-str)">
            <xsl:choose>
                <xsl:when test="starts-with($temp-str, 'v')">
                    <xsl:attribute name="table:content-validation-name">
                        <xsl:value-of select="concat('val', substring-after($temp-str, 'v'))"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="after-str" select="substring-after($condition-pos-str, $current-pos-str)"/>
                    <xsl:if test="contains( $after-str, $current-pos-str)">
                        <xsl:variable name="temp-str-2">
                            <xsl:call-template name="condition-str">
                                <xsl:with-param name="param-str" select="substring-before( $after-str,$current-pos-str)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:if test="starts-with( $temp-str-2, 'v')">
                            <xsl:attribute name="table:content-validation-name">
                                <xsl:value-of select="concat('val', substring-after($temp-str-2, 'v'))"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="validation-row-column-string">
        <!-- returns a string with structure, including row/column position by extraction from x:DataValidation -->
        <xsl:param name="last"/>
        <xsl:param name="total"/>
        <xsl:param name="index"/>
        <xsl:variable name="table-pos" select="count(preceding-sibling::ss:Worksheet)+1"/>
        <xsl:variable name="current">
            <xsl:call-template name="parse-range">
                <xsl:with-param name="range-value" select="./x:DataValidation[position() = $index]/x:Range"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="current-value" select="concat('(v',$index,':', $current,');')"/>
        <xsl:if test="$index &lt; $total">
            <xsl:call-template name="validation-row-column-string">
                <xsl:with-param name="last" select="concat($last, $current-value)"/>
                <xsl:with-param name="total" select="$total"/>
                <xsl:with-param name="index" select="$index + 1"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$index = $total">
            <xsl:value-of select="concat($last, $current-value)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="condition-row-column-string">
        <!-- returns a string with structure, including row/column position by extraction from x:ConditionalFormatting -->
        <xsl:param name="last"/>
        <xsl:param name="total"/>
        <xsl:param name="index"/>
        <xsl:variable name="table-pos" select="count(preceding-sibling::ss:Worksheet)+1"/>
        <xsl:variable name="current">
            <xsl:call-template name="parse-range">
                <xsl:with-param name="range-value" select="./x:ConditionalFormatting[position() = $index]/x:Range"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="current-value" select="concat('(c',$table-pos,'-',$index,':', $current,');')"/>
        <xsl:if test="$index &lt; $total">
            <xsl:call-template name="condition-row-column-string">
                <xsl:with-param name="last" select="concat($last, $current-value)"/>
                <xsl:with-param name="total" select="$total"/>
                <xsl:with-param name="index" select="$index + 1"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$index = $total">
            <xsl:value-of select="concat($last, $current-value)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="parse-range">
        <!-- returns a string,input param:the value of x:Range -->
        <xsl:param name="range-value"/>
        <xsl:param name="last"/>
        <xsl:variable name="first-pit">
            <xsl:choose>
                <xsl:when test="contains($range-value,',')">
                    <xsl:value-of select="substring-before($range-value,',')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$range-value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="current">
            <xsl:choose>
                <xsl:when test="contains($first-pit,':')">
                    <xsl:variable name="R-start" select="substring-before(substring-after($first-pit,'R'),'C')"/>
                    <xsl:variable name="C-start" select="substring-before(substring-after($first-pit,'C'),':')"/>
                    <xsl:variable name="second-pit" select="substring-after($first-pit,':')"/>
                    <xsl:variable name="R-end" select="substring-before(substring-after($second-pit,'R'),'C')"/>
                    <xsl:variable name="C-end" select="substring-after($second-pit,'C')"/>
                    <xsl:variable name="the-str">
                        <xsl:call-template name="condition-rc-str">
                            <xsl:with-param name="r-start" select="$R-start"/>
                            <xsl:with-param name="r-end" select="$R-end"/>
                            <xsl:with-param name="c-start" select="$C-start"/>
                            <xsl:with-param name="c-end" select="$C-end"/>
                            <xsl:with-param name="last" select="''"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$the-str"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($first-pit,',')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($range-value,',')">
                <xsl:call-template name="parse-range">
                    <xsl:with-param name="range-value" select="substring-after($range-value,',')"/>
                    <xsl:with-param name="last" select="concat($last,$current)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($last,$current)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="condition-rc-str">
        <!-- dealing the range of row\column -->
        <xsl:param name="r-start"/>
        <xsl:param name="r-end"/>
        <xsl:param name="c-start"/>
        <xsl:param name="c-end"/>
        <xsl:param name="last"/>
        <xsl:variable name="current">
            <xsl:call-template name="condition-c-str">
                <xsl:with-param name="rc-str" select="concat('R',$r-start)"/>
                <xsl:with-param name="start" select="$c-start"/>
                <xsl:with-param name="end" select="$c-end"/>
                <xsl:with-param name="last" select="''"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$r-start &lt; $r-end">
            <xsl:call-template name="condition-rc-str">
                <xsl:with-param name="r-start" select="$r-start + 1"/>
                <xsl:with-param name="r-end" select="$r-end"/>
                <xsl:with-param name="c-start" select="$c-start"/>
                <xsl:with-param name="c-end" select="$c-end"/>
                <xsl:with-param name="last" select="concat($last,$current)"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$r-start = $r-end">
            <xsl:value-of select="concat($last,$current)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="condition-c-str">
        <!-- return value for the template condition-rc-str -->
        <xsl:param name="rc-str"/>
        <xsl:param name="start"/>
        <xsl:param name="end"/>
        <xsl:param name="last"/>
        <xsl:variable name="current" select="concat($rc-str,'C',$start,',')"/>
        <xsl:if test="$start &lt; $end">
            <xsl:call-template name="condition-c-str">
                <xsl:with-param name="rc-str" select="$rc-str"/>
                <xsl:with-param name="start" select="$start + 1"/>
                <xsl:with-param name="end" select="$end"/>
                <xsl:with-param name="last" select="concat($last,$current)"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$start = $end">
            <xsl:value-of select="concat($last,$current)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="ss:Data[count(*)>0]">
        <xsl:for-each select=".//text()[string-length(.) != 0]">
            <style:style style:name="{concat(ancestor::ss:Cell/@ss:StyleID,'T',count(preceding::ss:Data[child::html:*]), '_', position())}" style:family="text">
                <xsl:element name="style:text-properties">
                    <xsl:if test="ancestor-or-self::html:Font/@html:Face">
                        <xsl:attribute name="style:font-name">
                            <xsl:value-of select="ancestor-or-self::html:Font/@html:Face"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::html:Font/@html:Size">
                        <xsl:attribute name="fo:font-size">
                            <xsl:value-of select="concat(ancestor-or-self::html:Font/@html:Size,'pt')"/>
                        </xsl:attribute>
                        <xsl:attribute name="style:font-size-asian">
                            <xsl:value-of select="concat(ancestor-or-self::html:Font/@html:Size,'pt')"/>
                        </xsl:attribute>
                        <xsl:attribute name="style:font-size-complex">
                            <xsl:value-of select="concat(ancestor-or-self::html:Font/@html:Size,'pt')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::html:Font/@html:Color">
                        <xsl:attribute name="fo:color">
                            <xsl:value-of select="ancestor-or-self::html:Font/@html:Color"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::html:B">
                        <xsl:attribute name="fo:font-weight">bold</xsl:attribute>
                        <xsl:attribute name="style:font-weight-asian">bold</xsl:attribute>
                        <xsl:attribute name="style:font-weight-complex">bold</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::html:I">
                        <xsl:attribute name="fo:font-style">italic</xsl:attribute>
                        <xsl:attribute name="style:font-style-asian">italic</xsl:attribute>
                        <xsl:attribute name="style:font-style-complex">italic</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::html:U">
                        <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::html:S">
                        <xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::html:Sup">
                        <xsl:attribute name="style:text-position">33% 58%</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::html:Sub">
                        <xsl:attribute name="style:text-position">-33% 58%</xsl:attribute>
                    </xsl:if>
                </xsl:element>
            </style:style>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="get-pos-content">
        <xsl:param name="content"/>
        <xsl:param name="pos"/>
        <xsl:choose>
            <xsl:when test="$pos = 'left'">
                <xsl:choose>
                    <xsl:when test="contains($content,'&amp;C')">
                        <xsl:value-of select="substring-before( substring-after( $content, '&amp;L'), '&amp;C')"/>
                    </xsl:when>
                    <xsl:when test="contains($content,'&amp;R')">
                        <xsl:value-of select="substring-before( substring-after( $content, '&amp;L'), '&amp;R')"/>
                    </xsl:when>
                    <xsl:when test="contains($content,'&amp;L')">
                        <xsl:value-of select="substring-after( $content, '&amp;L')"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$pos = 'center'">
                <xsl:choose>
                    <xsl:when test="contains($content,'&amp;R')">
                        <xsl:value-of select="substring-before( substring-after( $content, '&amp;C'), '&amp;R')"/>
                    </xsl:when>
                    <xsl:when test="contains($content,'&amp;C')">
                        <xsl:value-of select="substring-after( $content, '&amp;C')"/>
                    </xsl:when>
                    <xsl:when test="contains($content,'&amp;L')"/>
                    <xsl:otherwise>
                        <xsl:value-of select="$content"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$pos = 'right'">
                <xsl:value-of select="substring-after( $content, '&amp;R')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@x:Data">
        <xsl:variable name="style-name-header">
            <xsl:value-of select="concat(ancestor::ss:Worksheet/@ss:Name, substring(name(..),1,1))"/>
        </xsl:variable>
        <xsl:variable name="left-style-data">
            <xsl:call-template name="get-pos-content">
                <xsl:with-param name="content" select="."/>
                <xsl:with-param name="pos" select="'left'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($left-style-data)&gt;0 and contains($left-style-data,'&amp;')">
            <xsl:call-template name="create-header-footer-style">
                <xsl:with-param name="style-name-header" select="concat($style-name-header,'L')"/>
                <xsl:with-param name="style-data" select="$left-style-data"/>
                <xsl:with-param name="index" select="0"/>
                <xsl:with-param name="current-pos" select="1"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:variable name="center-style-data">
            <xsl:call-template name="get-pos-content">
                <xsl:with-param name="content" select="."/>
                <xsl:with-param name="pos" select="'center'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($center-style-data)&gt;0 and contains($center-style-data,'&amp;')">
            <xsl:call-template name="create-header-footer-style">
                <xsl:with-param name="style-name-header" select="concat($style-name-header,'C')"/>
                <xsl:with-param name="style-data" select="$center-style-data"/>
                <xsl:with-param name="index" select="0"/>
                <xsl:with-param name="current-pos" select="1"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:variable name="right-style-data">
            <xsl:call-template name="get-pos-content">
                <xsl:with-param name="content" select="."/>
                <xsl:with-param name="pos" select="'right'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($right-style-data)&gt;0 and contains($right-style-data,'&amp;')">
            <xsl:call-template name="create-header-footer-style">
                <xsl:with-param name="style-name-header" select="concat($style-name-header,'R')"/>
                <xsl:with-param name="style-data" select="$right-style-data"/>
                <xsl:with-param name="index" select="0"/>
                <xsl:with-param name="current-pos" select="1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="create-header-footer-style">
        <xsl:param name="style-name-header"/>
        <xsl:param name="style-data"/>
        <xsl:param name="index"/>
        <xsl:param name="current-pos"/>
        <xsl:variable name="current-style-data">
            <xsl:value-of select="substring($style-data,$current-pos)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="starts-with($current-style-data,'&amp;D') or starts-with($current-style-data,'&amp;T') or starts-with($current-style-data,'&amp;P') or starts-with($current-style-data,'&amp;N') or starts-with($current-style-data,'&amp;A') or starts-with($current-style-data,'&amp;F') or starts-with($current-style-data,'&amp;Z')">
                <xsl:call-template name="create-header-footer-style">
                    <xsl:with-param name="style-name-header" select="$style-name-header"/>
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="index" select="$index"/>
                    <xsl:with-param name="current-pos" select="$current-pos +2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($current-style-data,'&amp;')">
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name">
                        <xsl:value-of select="concat($style-name-header,$index)"/>
                    </xsl:attribute>
                    <xsl:attribute name="style:family">text</xsl:attribute>
                    <xsl:element name="style:text-properties">
                        <xsl:call-template name="process-header-footer-style-properties">
                            <xsl:with-param name="style-data" select="$style-data"/>
                            <xsl:with-param name="current-pos" select="$current-pos"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
                <xsl:variable name="next-style-header-pos">
                    <xsl:call-template name="get-current-content-pos">
                        <xsl:with-param name="style-data" select="$style-data"/>
                        <xsl:with-param name="current-pos" select="$current-pos"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="create-header-footer-style">
                    <xsl:with-param name="style-name-header" select="$style-name-header"/>
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="index" select="$index+1"/>
                    <xsl:with-param name="current-pos" select="$next-style-header-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($current-style-data,'&amp;')">
                <xsl:variable name="temp" select="substring-before($current-style-data,'&amp;')"/>
                <xsl:call-template name="create-header-footer-style">
                    <xsl:with-param name="style-name-header" select="$style-name-header"/>
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="index" select="$index"/>
                    <xsl:with-param name="current-pos" select="string-length($temp)+$current-pos"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="process-header-footer-style-properties">
        <xsl:param name="style-data"/>
        <xsl:param name="current-pos"/>
        <xsl:variable name="current-style-data">
            <xsl:value-of select="substring($style-data,$current-pos)"/>
        </xsl:variable>
        <xsl:choose>
            <!-- stack operations necessary -->
            <xsl:when test="starts-with($current-style-data,'&amp;&quot;')">
                <xsl:attribute name="style:font-name">
                    <xsl:value-of select="substring-before(substring-after($current-style-data,'&amp;&quot;'),',')"/>
                </xsl:attribute>
                <xsl:if test="contains(substring-before(substring-after($current-style-data,','),'&quot;'),'Bold')">
                    <xsl:attribute name="fo:font-weight">bold</xsl:attribute>
                    <xsl:attribute name="style:font-weight-asian">bold</xsl:attribute>
                    <xsl:attribute name="style:font-weight-complex">bold</xsl:attribute>
                </xsl:if>
                <xsl:if test="contains(substring-before(substring-after($current-style-data,','),'&quot;'),'Italic')">
                    <xsl:attribute name="fo:font-style">italic</xsl:attribute>
                    <xsl:attribute name="style:font-style-asian">italic</xsl:attribute>
                    <xsl:attribute name="style:font-style-complex">italic</xsl:attribute>
                </xsl:if>
                <xsl:variable name="temp" select="substring-before(substring($style-data,$current-pos+2),'&quot;')"/>
                <xsl:call-template name="process-header-footer-style-properties">
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="current-pos" select="string-length($temp)+$current-pos+3"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($current-style-data,'&amp;0') or starts-with($current-style-data,'&amp;1') or starts-with($current-style-data,'&amp;2') or starts-with($current-style-data,'&amp;3') or starts-with($current-style-data,'&amp;4') or starts-with($current-style-data,'&amp;5') or starts-with($current-style-data,'&amp;6') or starts-with($current-style-data,'&amp;7') or starts-with($current-style-data,'&amp;8') or starts-with($current-style-data,'&amp;9')">
                <xsl:variable name="font-size-length">
                    <xsl:call-template name="get-digit-length">
                        <xsl:with-param name="complexive-string" select="substring-after($current-style-data,'&amp;')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:attribute name="fo:font-size">
                    <xsl:value-of select="concat(substring($current-style-data,2,$font-size-length),'pt')"/>
                </xsl:attribute>
                <xsl:call-template name="process-header-footer-style-properties">
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="current-pos" select="$current-pos + 1 + $font-size-length"/>
                </xsl:call-template>
            </xsl:when>
            <!-- don't consider tangled or adjoined '&X' and '&Y', '&U' & '&E', processing-check is necessary, too complex. :( -->
            <xsl:when test="starts-with($current-style-data,'&amp;X')">
                <xsl:variable name="superscript-count-before">
                    <xsl:call-template name="get-substyle-count-in-data">
                        <xsl:with-param name="style-data" select="substring($style-data,1,$current-pos)"/>
                        <xsl:with-param name="substyle" select="'&amp;X'"/>
                        <xsl:with-param name="count" select="0"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$superscript-count-before mod 2 = 0">
                    <xsl:attribute name="style:text-position">33% 58%</xsl:attribute>
                </xsl:if>
                <xsl:call-template name="process-header-footer-style-properties">
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="current-pos" select="$current-pos + 2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($current-style-data,'&amp;B')">
                <xsl:variable name="subscript-count-before">
                    <xsl:call-template name="get-substyle-count-in-data">
                        <xsl:with-param name="style-data" select="substring($style-data,1,$current-pos)"/>
                        <xsl:with-param name="substyle" select="'&amp;B'"/>
                        <xsl:with-param name="count" select="0"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$subscript-count-before mod 2 = 0">
                    <xsl:attribute name="fo:font-weight">bold</xsl:attribute>
                    <xsl:attribute name="style:font-weight-asian">bold</xsl:attribute>
                    <xsl:attribute name="style:font-weight-complex">bold</xsl:attribute>
                </xsl:if>
                <xsl:call-template name="process-header-footer-style-properties">
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="current-pos" select="$current-pos + 2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($current-style-data,'&amp;Y')">
                <xsl:variable name="subscript-count-before">
                    <xsl:call-template name="get-substyle-count-in-data">
                        <xsl:with-param name="style-data" select="substring($style-data,1,$current-pos)"/>
                        <xsl:with-param name="substyle" select="'&amp;Y'"/>
                        <xsl:with-param name="count" select="0"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$subscript-count-before mod 2 = 0">
                    <xsl:attribute name="style:text-position">-33% 58%</xsl:attribute>
                </xsl:if>
                <xsl:call-template name="process-header-footer-style-properties">
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="current-pos" select="$current-pos + 2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($current-style-data,'&amp;S')">
                <xsl:variable name="strikethrough-count-before">
                    <xsl:call-template name="get-substyle-count-in-data">
                        <xsl:with-param name="style-data" select="substring($style-data,1,$current-pos)"/>
                        <xsl:with-param name="substyle" select="'&amp;S'"/>
                        <xsl:with-param name="count" select="0"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$strikethrough-count-before mod 2 = 0">
                    <xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
                </xsl:if>
                <xsl:call-template name="process-header-footer-style-properties">
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="current-pos" select="$current-pos + 2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($current-style-data,'&amp;U')">
                <xsl:variable name="single-underline-count-before">
                    <xsl:call-template name="get-substyle-count-in-data">
                        <xsl:with-param name="style-data" select="substring($style-data,1,$current-pos)"/>
                        <xsl:with-param name="substyle" select="'&amp;U'"/>
                        <xsl:with-param name="count" select="0"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$single-underline-count-before mod 2 = 0">
                    <xsl:attribute name="style:text-underline-type">single</xsl:attribute>
                </xsl:if>
                <xsl:call-template name="process-header-footer-style-properties">
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="current-pos" select="$current-pos + 2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($current-style-data,'&amp;E')">
                <xsl:variable name="double-underline-count-before">
                    <xsl:call-template name="get-substyle-count-in-data">
                        <xsl:with-param name="style-data" select="substring($style-data,1,$current-pos)"/>
                        <xsl:with-param name="substyle" select="'&amp;E'"/>
                        <xsl:with-param name="count" select="0"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$double-underline-count-before mod 2 = 0">
                    <xsl:attribute name="style:text-underline-type">double</xsl:attribute>
                </xsl:if>
                <xsl:call-template name="process-header-footer-style-properties">
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="current-pos" select="$current-pos + 2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-substyle-count-in-data">
        <xsl:param name="style-data"/>
        <xsl:param name="substyle"/>
        <xsl:param name="count"/>
        <xsl:choose>
            <xsl:when test="contains($style-data,$substyle)">
                <xsl:call-template name="get-substyle-count-in-data">
                    <xsl:with-param name="style-data" select="substring-after($style-data,$substyle)"/>
                    <xsl:with-param name="substyle" select="$substyle"/>
                    <xsl:with-param name="count" select="$count+1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$count"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-current-content-pos">
        <xsl:param name="style-data"/>
        <xsl:param name="current-pos"/>
        <xsl:variable name="current-style-data">
            <xsl:value-of select="substring($style-data,$current-pos)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="starts-with($current-style-data,'&amp;X') or starts-with($current-style-data,'&amp;Y') or starts-with($current-style-data,'&amp;S') or starts-with($current-style-data,'&amp;U') or starts-with($current-style-data,'&amp;E') or starts-with($current-style-data,'&amp;B')">
                <xsl:call-template name="get-current-content-pos">
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="current-pos" select="$current-pos+2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($current-style-data,'&amp;0') or starts-with($current-style-data,'&amp;1') or starts-with($current-style-data,'&amp;2') or starts-with($current-style-data,'&amp;3') or starts-with($current-style-data,'&amp;4') or starts-with($current-style-data,'&amp;5') or starts-with($current-style-data,'&amp;6') or starts-with($current-style-data,'&amp;7') or starts-with($current-style-data,'&amp;8') or starts-with($current-style-data,'&amp;9')">
                <xsl:variable name="font-size-length">
                    <xsl:call-template name="get-digit-length">
                        <xsl:with-param name="complexive-string" select="substring-after($current-style-data,'&amp;')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="get-current-content-pos">
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="current-pos" select="$current-pos+1+$font-size-length"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($current-style-data,'&amp;&quot;')">
                <xsl:variable name="temp" select="substring-before(substring($style-data,$current-pos+2),'&quot;')"/>
                <xsl:call-template name="get-current-content-pos">
                    <xsl:with-param name="style-data" select="$style-data"/>
                    <xsl:with-param name="current-pos" select="string-length($temp)+$current-pos+3"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($current-style-data, '&amp;')">
                <xsl:value-of select="$current-pos + 1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$current-pos"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- OASIS OpenDocument Format change:
        Excel   "=RC4*6"
        OOoXML "=$D22*6"
     OASIS XML "oooc:=[.$D22]*6" -->
    <xsl:template name="translate-expression">
        <!--  return position or range for formula or other -->
        <xsl:param name="cell-row-pos"/>
        <!-- the position in row (vertical) of cell -->
        <xsl:param name="cell-column-pos"/>
        <!-- the position in column (horizontal of cell -->
        <xsl:param name="expression"/>
        <!-- recomposed expression containing cell positions after every conversion -->
        <xsl:param name="is-range-mode" select="false()"/>
        <!-- as mode changes a '[.' resp. ']' is written out  -->
        <xsl:param name="return-value"/>
        <!-- expression of table:cell-range-address is different than formula (e.g. no prefix)  -->
        <xsl:param name="isRangeAddress"/>
        <!-- determines if the currently processed expression is relative -->
        <xsl:param name="isRelative" select="false()" />

        <!-- value to be given out later -->
        <!-- to judge whether this input expression contains any cell position to convert -->
        <xsl:variable name="temp-range">
            <xsl:choose>
                <xsl:when test="$expression != ''">
                    <xsl:call-template name="parse-range-name">
                        <xsl:with-param name="expression" select="$expression"/>
                        <xsl:with-param name="return-value" select="''"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- if $range-type = 1, then range is representing a sheet, function's name or separated symbol, but not cell position,
             or if $range-type = 2, range should be handled because it contains certain cell position.
             The first character marks the type of that expression. -->
        <xsl:variable name="range-type">
            <xsl:choose>
                <xsl:when test="substring($temp-range, 1, 1) = '1'">
                    <xsl:value-of select="1"/>
                </xsl:when>
                <xsl:when test="substring($temp-range, 1, 1) = '2'">
                    <xsl:value-of select="2"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="2"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- remove that added range type token -->
        <xsl:variable name="current-range">
            <xsl:value-of select="substring($temp-range, 2)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$range-type = 1">
                <!-- Nothing to convert, so just join the front and behind strings. -->
                <xsl:call-template name="translate-expression">
                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                    <xsl:with-param name="expression">
                        <!-- get current converting position from $temp-token or $current-range, then join the expression. -->
                        <xsl:choose>
                            <xsl:when test="contains($current-range, '#$')">
                                <!-- because of recomposing of string, the $current-range may not be the pit
                            of $expression, so the char #$ should not be used for nominal -->
                                <xsl:variable name="temp-token">
                                    <xsl:choose>
                                        <xsl:when test="contains($current-range, '\')">
                                            <xsl:value-of select="concat(']', substring-after($current-range, '#$'), &quot;&apos;&quot;)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-after($current-range, '#$')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:value-of select="substring-after($expression, $temp-token)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after($expression, $current-range)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="return-value">
                        <!-- react on range mode change (when to insert closing ']' or in case of '!' change the mode to RANGE and create open '[' -->
                        <xsl:choose>
                            <xsl:when test="$current-range = '=' and $return-value = '' and not($isRangeAddress)">
                                <xsl:text>oooc:=</xsl:text>
                            </xsl:when>
                            <xsl:when test="contains($current-range, '!') and not($isRangeAddress)">
                                <xsl:value-of select="concat($return-value, '[', $current-range)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$is-range-mode = 'true' and $current-range != ':' and not($isRangeAddress)">
                                        <xsl:value-of select="concat($return-value, ']', substring-before($expression, $current-range), $current-range)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat($return-value, substring-before($expression, $current-range), $current-range)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="is-range-mode">
                        <xsl:choose>
                            <!-- ! is the separator of worksheet and range
                                 : is the separator for a cell range -->
                            <xsl:when test="contains($current-range, '!') or $current-range = ':'">
                                <xsl:value-of select="true()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="false()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- types of range to handle in $current-range, i.e. the cell position expression to convert
                    1: special cell including row and column; e.g. R4C5
                    2: whole row; e.g. R3
                    3: whole column; e.g. C5
                    4: other name not for cell or row/column; e.g. RANDOM() or something unknown
                -->
                <xsl:variable name="handle-type">
                    <xsl:choose>
                        <xsl:when test="starts-with($current-range, 'R')">
                            <!-- It's type 1 or type 2 or 4/unknown cell position. -->
                            <xsl:choose>
                                <xsl:when test="contains($current-range, 'C')">
                                    <!-- It's type 1, specifying the cell position or 4/unknown -->
                                    <xsl:variable name="part-type-r">
                                        <xsl:call-template name="handle-type-number">
                                            <xsl:with-param name="t-part" select="substring-before( substring-after($current-range, 'R'), 'C')"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="part-type-c">
                                        <xsl:call-template name="handle-type-number">
                                            <xsl:with-param name="t-part" select="substring-after($current-range, 'C')"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when test="($part-type-r = 1) and ($part-type-c = 1)">
                                            <xsl:value-of select="1"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="4"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- It's type 2 specifying the cell position, or 4/unknown. -->
                                    <xsl:variable name="part-type">
                                        <xsl:call-template name="handle-type-number">
                                            <xsl:with-param name="t-part" select="substring-after($current-range, 'R')"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when test="$part-type = 1">
                                            <xsl:value-of select="2"/>
                                        </xsl:when>
                                        <xsl:when test="$part-type = 2">
                                            <xsl:value-of select="4"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="4"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="starts-with($current-range, 'C')">
                            <!-- It's type 3 of cell position, or 4/unknown -->
                            <xsl:variable name="part-type">
                                <xsl:call-template name="handle-type-number">
                                    <xsl:with-param name="t-part" select="substring-after($current-range, 'C')"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$part-type = 1">
                                    <xsl:value-of select="3"/>
                                </xsl:when>
                                <xsl:when test="$part-type = 2">
                                    <xsl:value-of select="4"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="4"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- It's type 4, not cell position -->
                            <xsl:value-of select="4"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- Start to convert that cell position expression, that cell position unit -->
                <xsl:choose>
                    <xsl:when test="$handle-type = 1">
                        <!-- It's type 1, e.g. R1C2 -->
                        <!-- process the row part -->
                        <xsl:variable name="after-R">
                            <xsl:value-of select="substring(substring-after($current-range,'R'),1,1)"/>
                        </xsl:variable>
                        <xsl:choose>
                            <!-- found one cell unit -->
                            <xsl:when test="$after-R='C' or $after-R='[' or $after-R='0' or $after-R='1' or $after-R='2' or $after-R='3' or $after-R='4' or $after-R='5' or $after-R='6' or $after-R='7' or $after-R='8' or $after-R='9'">
                                <xsl:variable name="row-pos">
                                    <xsl:choose>
                                        <xsl:when test="$after-R='['">
                                            <xsl:value-of select="$cell-row-pos+substring-before( substring-after($current-range,'R['),']')"/>
                                        </xsl:when>
                                        <xsl:when test="$after-R='C'">
                                            <xsl:value-of select="$cell-row-pos"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-before(substring-after($current-range,'R'),'C')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="row-pos-style">
                                    <xsl:choose>
                                        <xsl:when test="$after-R='[' or $after-R='C'">relative</xsl:when>
                                        <xsl:otherwise>absolute</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- process the column part -->
                                <xsl:variable name="after-C">
                                    <xsl:value-of select="substring(substring-after(substring-after($current-range,'R'),'C'),1,1)"/>
                                </xsl:variable>
                                <xsl:variable name="column-digit-length">
                                    <xsl:choose>
                                        <xsl:when test="$after-C='0' or $after-C='1' or $after-C='2' or $after-C='3' or $after-C='4' or $after-C='5' or $after-C='6' or $after-C='7' or $after-C='8' or $after-C='9'">
                                            <xsl:call-template name="get-digit-length">
                                                <xsl:with-param name="complexive-string" select="substring-after(substring-after($current-range,'R'),'C')"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="column-pos">
                                    <xsl:choose>
                                        <xsl:when test="$after-C='['">
                                            <xsl:value-of select="$cell-column-pos + substring-before(substring-after(substring-after($current-range,'R'),'C['),']')"/>
                                        </xsl:when>
                                        <xsl:when test="$after-C='0' or $after-C='1' or $after-C='2' or $after-C='3' or $after-C='4' or $after-C='5' or $after-C='6' or $after-C='7' or $after-C='8' or $after-C='9'">
                                            <xsl:value-of select="substring(substring-after(substring-after($current-range,'R'),'C'),1,$column-digit-length)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$cell-column-pos"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="column-pos-style">
                                    <xsl:choose>
                                        <xsl:when test="$after-C='0' or $after-C='1' or $after-C='2' or $after-C='3' or $after-C='4' or $after-C='5' or $after-C='6' or $after-C='7' or $after-C='8' or $after-C='9'">absolute</xsl:when>
                                        <xsl:otherwise>relative</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="trans-unit">
                                    <xsl:call-template name="translate-unit">
                                        <xsl:with-param name="column-number" select="$column-pos"/>
                                        <xsl:with-param name="row-number" select="$row-pos"/>
                                        <xsl:with-param name="column-pos-style" select="$column-pos-style"/>
                                        <xsl:with-param name="row-pos-style" select="$row-pos-style"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), $trans-unit)"/>
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($expression, $current-range)"/>
                                    <xsl:with-param name="return-value">
                                        <xsl:choose>
                                            <xsl:when test="$is-range-mode = 'true'">
                                                <xsl:value-of select="concat($return-value, $name-unit)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($return-value, '[.', $name-unit)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                    <xsl:with-param name="is-range-mode" select="true()"/>
                                    <xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), translate( substring-before(substring-after($expression, '('),'R'),',!', ';.'))"/>
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($current-range,'R')"/>
                                    <xsl:with-param name="return-value">
                                        <xsl:choose>
                                            <xsl:when test="$is-range-mode = 'true'">
                                                <xsl:value-of select="concat($return-value, $name-unit)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($return-value, '[.', $name-unit)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                    <xsl:with-param name="is-range-mode" select="true()"/>
                                    <xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$handle-type = 2">
                        <!-- It's type 2, e.g. R3 -->
                        <!-- process the range only including a whole row -->
                        <xsl:variable name="after-R">
                            <xsl:value-of select="substring(substring-after($current-range,'R'),1,1)"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$after-R='[' or $after-R='0' or $after-R='1' or $after-R='2' or $after-R='3' or $after-R='4' or $after-R='5' or $after-R='6' or $after-R='7' or $after-R='8' or $after-R='9'">
                                <xsl:variable name="row-number">
                                    <xsl:choose>
                                        <xsl:when test="$after-R = '['">
                                            <xsl:value-of select="substring-before(substring-after($current-range, 'R['), ']')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-after($current-range, 'R')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="row-pos">
                                    <xsl:choose>
                                        <xsl:when test="$after-R='['">
                                            <xsl:value-of select="$cell-row-pos + $row-number"/>
                                        </xsl:when>
                                        <xsl:when test="$after-R='0' or $after-R='1' or $after-R='2' or $after-R='3' or $after-R='4' or $after-R='5' or $after-R='6' or $after-R='7' or $after-R='8' or $after-R='9'">
                                            <xsl:value-of select="$row-number"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$cell-row-pos"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="trans-unit1">
                                    <xsl:call-template name="translate-unit">
                                        <xsl:with-param name="column-number" select="1"/>
                                        <xsl:with-param name="row-number" select="$row-pos"/>
                                        <xsl:with-param name="column-pos-style" select="'relative'"/>
                                        <xsl:with-param name="row-pos-style" select="'relative'"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="trans-unit2">
                                    <xsl:call-template name="translate-unit">
                                        <xsl:with-param name="column-number" select="256"/>
                                        <xsl:with-param name="row-number" select="$row-pos"/>
                                        <xsl:with-param name="column-pos-style" select="'relative'"/>
                                        <xsl:with-param name="row-pos-style" select="'relative'"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), $trans-unit1, ':', $trans-unit2)"/>
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($expression, $current-range)"/>
                                    <xsl:with-param name="return-value">
                                        <xsl:choose>
                                            <xsl:when test="$is-range-mode = 'true'">
                                                <xsl:value-of select="concat($return-value, $name-unit)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($return-value, '[.', $name-unit)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                    <xsl:with-param name="is-range-mode" select="true()"/>
                                    <xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), translate( substring-before($current-range,'R'),',!', ';.'),'R')"/>
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($current-range,'R')"/>
                                    <xsl:with-param name="return-value">
                                        <xsl:choose>
                                            <xsl:when test="$is-range-mode = 'true'">
                                                <xsl:value-of select="concat($return-value, $name-unit)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($return-value, '[.', $name-unit)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                    <xsl:with-param name="is-range-mode" select="true()"/>
                                    <xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$handle-type = 3">
                        <!-- It's type 3, e.g. C4 -->
                        <!-- process the range only including a whole column -->
                        <xsl:variable name="after-C">
                            <xsl:value-of select="substring(substring-after($current-range,'C'),1,1)"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$after-C='[' or $after-C='0' or $after-C='1' or $after-C='2' or $after-C='3' or $after-C='4' or $after-C='5' or $after-C='6' or $after-C='7' or $after-C='8' or $after-C='9'">
                                <xsl:variable name="column-number">
                                    <xsl:choose>
                                        <xsl:when test="$after-C = '['">
                                            <xsl:value-of select="substring-before(substring-after($current-range, 'C['), ']')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-after($current-range, 'C')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="column-pos">
                                    <xsl:choose>
                                        <xsl:when test="$after-C='['">
                                            <xsl:value-of select="$cell-column-pos + $column-number"/>
                                        </xsl:when>
                                        <xsl:when test="$after-C='0' or $after-C='1' or $after-C='2' or $after-C='3' or $after-C='4' or $after-C='5' or $after-C='6' or $after-C='7' or $after-C='8' or $after-C='9'">
                                            <xsl:value-of select="$column-number"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$cell-column-pos"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="trans-unit1">
                                    <xsl:call-template name="translate-unit">
                                        <xsl:with-param name="column-number" select="$column-pos"/>
                                        <xsl:with-param name="row-number" select="1"/>
                                        <xsl:with-param name="column-pos-style" select="'relative'"/>
                                        <xsl:with-param name="row-pos-style" select="'relative'"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="trans-unit2">
                                    <xsl:call-template name="translate-unit">
                                        <xsl:with-param name="column-number" select="$column-pos"/>
                                        <xsl:with-param name="row-number" select="65565"/>
                                        <xsl:with-param name="column-pos-style" select="'relative'"/>
                                        <xsl:with-param name="row-pos-style" select="'relative'"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), $trans-unit1, ':', $trans-unit2)"/>
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($expression, $current-range)"/>
                                    <xsl:with-param name="return-value">
                                        <xsl:choose>
                                            <xsl:when test="$is-range-mode = 'true'">
                                                <xsl:value-of select="concat($return-value, $name-unit)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($return-value, '[.', $name-unit)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                    <xsl:with-param name="is-range-mode" select="true()"/>
                                    <xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), translate( substring-before($current-range,'C'),',!', ';.'),'C')"/>
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($current-range,'C')"/>
                                    <xsl:with-param name="return-value">
                                        <xsl:choose>
                                            <xsl:when test="$is-range-mode = 'true'">
                                                <xsl:value-of select="concat($return-value, $name-unit)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($return-value, '[.', $name-unit)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                    <xsl:with-param name="is-range-mode" select="true()"/>
                                    <xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- It's unknown, so just jump over it -->
                        <xsl:variable name="next-pit" select="substring-after($expression, $current-range)"/>
                        <xsl:choose>
                            <xsl:when test="contains($next-pit, '+') or contains($next-pit, '-') or contains($next-pit, '*') or contains($next-pit, '/') or contains($next-pit, ')') or contains($next-pit, '^') or contains($next-pit, ':') or contains($next-pit, '&quot;') or contains($next-pit, ';') or contains($next-pit, ',') or contains($next-pit, '[')">
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($expression, $current-range)"/>
                                    <xsl:with-param name="return-value" select="concat($return-value, substring-before($expression, $current-range), $current-range)"/>
                                    <xsl:with-param name="is-range-mode" select="false()"/>
                                    <xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- return the final range or formula -->
                                <xsl:choose>
                                    <!-- in case the closing bracket of the range wasn't set, do it now  -->
                                    <xsl:when test="$is-range-mode = 'true' and $current-range = ''">
                                        <xsl:value-of select="translate( concat($return-value, ']'),',!', ';.')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="translate( concat($return-value, substring-before($expression, $current-range), $current-range),',!', ';.')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="parse-range-name">
        <!-- return the string or name for next handle. the type 1 is names of function, sheet, special separated symbol, not to parse as range; type 2 is the range including R/C to be parsed -->
        <xsl:param name="expression"/>
        <xsl:param name="return-value"/>
        <xsl:variable name="first-one" select="substring($expression,1,1)"/>
        <xsl:choose>
            <xsl:when test="$first-one = '='">
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space($return-value)) &gt; 0">
                        <xsl:value-of select="concat('2', $return-value)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>1=</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$first-one='(' or $first-one='!' or $first-one='&amp;'">
                <xsl:value-of select="concat('1', $return-value, $first-one)"/>
            </xsl:when>
            <xsl:when test="$first-one='['">
                <xsl:choose>
                    <xsl:when test="starts-with(substring-after($expression, ']'), 'C')">
                        <xsl:call-template name="parse-range-name">
                            <xsl:with-param name="expression" select="substring-after($expression, ']')"/>
                            <xsl:with-param name="return-value" select="concat($return-value, substring-before($expression, ']'), ']')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains(substring-before($expression, ']'), '.') and contains(substring-after($expression, ']'), '!')">
                        <xsl:value-of select="concat('1', &quot;&apos;&quot;, substring-before(substring-after($expression, '['), ']'), &quot;&apos;&quot;, '#$', substring-before(substring-after($expression, ']'), '!'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('2', $return-value, substring-before($expression, ']'), ']')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$first-one='&quot;'">
                <xsl:value-of select="concat('1', $first-one, substring-before(substring-after($expression, '&quot;'), '&quot;'), '&quot;')"/>
            </xsl:when>
            <xsl:when test="$first-one=&quot;&apos;&quot;">
                <!-- here the string &quot;&apos;&quot; represents a char &apos;  -->
                <xsl:variable name="str-in" select="substring-before(substring-after($expression, &quot;&apos;&quot;), &quot;&apos;&quot;)"/>
                <xsl:choose>
                    <!-- for file path transformation -->
                    <xsl:when test="contains($str-in, '\') and contains($str-in, '[') and contains($str-in, ']')">
                        <xsl:variable name="first-pos" select="substring-before($str-in, '[')"/>
                        <xsl:variable name="second-pos" select="substring-before(substring-after($str-in, '['), ']')"/>
                        <xsl:variable name="third-pos" select="substring-after($str-in, ']')"/>
                        <xsl:value-of select="concat('1', &quot;&apos;&quot;, $first-pos, $second-pos, &quot;&apos;&quot;, '#$', $third-pos)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('1', &quot;&apos;&quot;, $str-in, &quot;&apos;&quot;)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$first-one='+' or $first-one='-' or $first-one='*' or $first-one='/' or $first-one=')' or $first-one='^' or $first-one=':' or $first-one='&quot;' or $first-one=';' or $first-one=',' or $first-one='&gt;' or $first-one='&lt;'">
                <xsl:choose>
                    <xsl:when test="$return-value = ''">
                        <xsl:value-of select="concat('1', $first-one)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('2', $return-value)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$expression = ''">
                        <xsl:value-of select="concat('2', $return-value)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="parse-range-name">
                            <xsl:with-param name="expression" select="substring($expression, 2, string-length($expression)-1)"/>
                            <xsl:with-param name="return-value" select="concat($return-value, substring($expression, 1, 1))"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="handle-type-number">
        <!-- to handle the part between R and C, or after C in range string in translate-expression. return type: 1: number or cell range; 2: other, not for next step -->
        <xsl:param name="t-part"/>
        <xsl:choose>
            <xsl:when test="starts-with($t-part, '[')">
                <xsl:variable name="tt-str" select="substring-before( substring-after( $t-part, '['), ']')"/>
                <xsl:choose>
                    <xsl:when test="($tt-str &lt; 0) or ($tt-str &gt; 0) or ($tt-str = 0)">
                        <xsl:value-of select="1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="2"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="($t-part &lt; 0) or ($t-part &gt; 0) or ($t-part = 0)">
                <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:when test="$t-part = ''">
                <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="translate-unit">
        <!-- convert cell position expression unit, R1C1, R3, C4 -->
        <xsl:param name="column-number"/>
        <xsl:param name="row-number"/>
        <xsl:param name="column-pos-style"/>
        <xsl:param name="row-pos-style"/>
        <xsl:variable name="column-number1">
            <xsl:value-of select="floor( $column-number div 26 )"/>
        </xsl:variable>
        <xsl:variable name="column-number2">
            <xsl:value-of select="$column-number mod 26"/>
        </xsl:variable>
        <xsl:variable name="column-character1">
            <xsl:call-template name="number-to-character">
                <xsl:with-param name="number" select="$column-number1"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="column-character2">
            <xsl:call-template name="number-to-character">
                <xsl:with-param name="number" select="$column-number2"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- position styles are 'absolute' or 'relative', -->
        <xsl:choose>
            <xsl:when test="$column-pos-style = 'absolute'">
                <xsl:value-of select="concat( '$', $column-character1, $column-character2)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat( $column-character1, $column-character2)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$row-pos-style ='absolute'">
                <xsl:value-of select="concat( '$', $row-number)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$row-number"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="number-to-character">
        <xsl:param name="number"/>
        <xsl:choose>
            <xsl:when test="$number = 0"/>
            <xsl:when test="$number = 1">A</xsl:when>
            <xsl:when test="$number = 2">B</xsl:when>
            <xsl:when test="$number = 3">C</xsl:when>
            <xsl:when test="$number = 4">D</xsl:when>
            <xsl:when test="$number = 5">E</xsl:when>
            <xsl:when test="$number = 6">F</xsl:when>
            <xsl:when test="$number = 7">G</xsl:when>
            <xsl:when test="$number = 8">H</xsl:when>
            <xsl:when test="$number = 9">I</xsl:when>
            <xsl:when test="$number = 10">J</xsl:when>
            <xsl:when test="$number = 11">K</xsl:when>
            <xsl:when test="$number = 12">L</xsl:when>
            <xsl:when test="$number = 13">M</xsl:when>
            <xsl:when test="$number = 14">N</xsl:when>
            <xsl:when test="$number = 15">O</xsl:when>
            <xsl:when test="$number = 16">P</xsl:when>
            <xsl:when test="$number = 17">Q</xsl:when>
            <xsl:when test="$number = 18">R</xsl:when>
            <xsl:when test="$number = 19">S</xsl:when>
            <xsl:when test="$number = 20">T</xsl:when>
            <xsl:when test="$number = 21">U</xsl:when>
            <xsl:when test="$number = 22">V</xsl:when>
            <xsl:when test="$number = 23">W</xsl:when>
            <xsl:when test="$number = 24">X</xsl:when>
            <xsl:when test="$number = 25">Y</xsl:when>
            <xsl:when test="$number = 26">Z</xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-digit-length">
        <xsl:param name="complexive-string"/>
        <xsl:variable name="first-char">
            <xsl:value-of select="substring( $complexive-string, 1, 1)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$first-char = '1' or $first-char = '2' or $first-char = '3' or $first-char = '4' or $first-char = '5' or $first-char = '6' or $first-char = '7' or $first-char = '8' or $first-char = '9' or $first-char = '0' ">
                <xsl:variable name="temp">
                    <xsl:call-template name="get-digit-length">
                        <xsl:with-param name="complexive-string" select="substring( $complexive-string, 2)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$temp+1"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ss:Comment" mode="body">
        <xsl:element name="office:annotation">
            <xsl:if test="@ss:ShowAlways = '1'">
                <xsl:attribute name="office:display">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="@ss:Author">
                <xsl:element name="dc:creator">
                    <xsl:value-of select="@ss:Author"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="ss:Data">
                <text:p>
                    <xsl:call-template name="create-data-content">
                        <xsl:with-param name="style-id" select="@ss:StyleID"/>
                    </xsl:call-template>
                </text:p>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="Names">
        <xsl:variable name="namedRanges" select="/ss:Workbook/ss:Worksheet/ss:Names/ss:NamedRange |
                                                 /ss:Workbook/ss:Names/ss:NamedRange" />
        <xsl:if test="$namedRanges">
            <table:named-expressions>
                <xsl:for-each select="$namedRanges">
                    <xsl:choose>
                        <xsl:when test="contains( @ss:RefersTo, '!R')">
                            <xsl:variable name="referto">
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="isRangeAddress" select="true()"/>
                                    <xsl:with-param name="cell-row-pos" select="0"/>
                                    <xsl:with-param name="cell-column-pos" select="0"/>
                                    <xsl:with-param name="expression" select="@ss:RefersTo"/>
                                    <xsl:with-param name="return-value" select="''"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:element name="table:named-range">
                                <xsl:attribute name="table:name">
                                    <xsl:value-of select="@ss:Name"/>
                                </xsl:attribute>
                                <xsl:attribute name="table:base-cell-address">
                                    <xsl:variable name="worksheetName" select="translate(substring-before(@ss:RefersTo, '!'), '=', '$')" />
                                    <xsl:call-template name="encode-as-cell-address">
                                        <xsl:with-param name="string" select="concat($worksheetName,'.$A$1')"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="table:cell-range-address">
                                    <xsl:call-template name="encode-as-cell-range-address">
                                        <xsl:with-param name="string" select="translate( $referto, '=', '$')"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:if test="@ss:Name = 'Print_Area'">
                                    <xsl:attribute name="table:range-usable-as">print-range</xsl:attribute>
                                </xsl:if>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="expression-name">
                                <xsl:value-of select="@ss:Name"/>
                            </xsl:variable>
                            <xsl:element name="table:named-expression">
                                <xsl:attribute name="table:name">
                                    <xsl:value-of select="@ss:Name"/>
                                </xsl:attribute>
                                <!-- just set '$Sheet1.$A$1' as named-expressions virtual base-cell-address -->
                                <xsl:attribute name="table:base-cell-address">
                                    <xsl:variable name="worksheetName" select="following-sibling::ss:Worksheet/@ss:Name" />
                                    <xsl:call-template name="encode-as-cell-address">
                                        <xsl:with-param name="string" select="concat('$', $worksheetName,'.$A$1')"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="table:expression">
                                    <xsl:value-of select="substring( @ss:RefersTo, 2)"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </table:named-expressions>
        </xsl:if>
    </xsl:template>
    <xsl:template name="transform-advanced-filter">
        <!-- transform the params of Advanced Filter.it's different from AutoFilter -->
        <xsl:param name="target-value"/>
        <xsl:param name="condition-pos"/>
        <xsl:element name="table:database-range">
            <xsl:variable name="target-range">
                <xsl:call-template name="translate-expression">
                    <xsl:with-param name="cell-row-pos" select="0"/>
                    <xsl:with-param name="cell-column-pos" select="0"/>
                    <xsl:with-param name="expression" select="$target-value"/>
                    <xsl:with-param name="return-value" select="''"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="condition-range">
                <xsl:call-template name="translate-expression">
                    <xsl:with-param name="cell-row-pos" select="0"/>
                    <xsl:with-param name="cell-column-pos" select="0"/>
                    <xsl:with-param name="expression" select="$condition-pos"/>
                    <xsl:with-param name="return-value" select="''"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="table:target-range-address">
                <xsl:value-of select="$target-range"/>
            </xsl:attribute>
            <xsl:attribute name="table:name">
                <xsl:value-of select="concat($target-range, '.filter')"/>
            </xsl:attribute>
            <xsl:element name="table:filter">
                <xsl:attribute name="table:condition-source-range-address">
                    <xsl:value-of select="$condition-range"/>
                </xsl:attribute>
                <xsl:element name="table:filter-condition">
                    <xsl:attribute name="table:field-number">0</xsl:attribute>
                    <!-- The two attributes are recommended by OASIS -->
                    <xsl:attribute name="table:value"/>
                    <xsl:attribute name="table:operator"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="x:AutoFilter">
        <!-- for AutoFilter -->
        <xsl:element name="table:database-range">
            <xsl:attribute name="table:name">
                <xsl:value-of select="concat(../@ss:Name,'_',@x:Range)"/>
            </xsl:attribute>
            <xsl:variable name="range">
                <xsl:call-template name="translate-expression">
                    <xsl:with-param name="cell-row-pos" select="0"/>
                    <xsl:with-param name="cell-column-pos" select="0"/>
                    <xsl:with-param name="expression" select="@x:Range"/>
                    <xsl:with-param name="return-value" select="''"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="table:target-range-address">
                <xsl:value-of select="concat('$',../@ss:Name,'.',$range)"/>
            </xsl:attribute>
            <xsl:attribute name="table:display-filter-buttons">true</xsl:attribute>
            <xsl:element name="table:filter">
                <xsl:call-template name="auto-filter-condition">
                    <xsl:with-param name="item-pos" select="1"/>
                    <xsl:with-param name="index" select="1"/>
                    <xsl:with-param name="total" select="count(./x:AutoFilterColumn)"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="auto-filter-condition">
        <!--?? generate element of filter-condition for AutoCondition to get position of index -->
        <xsl:param name="item-pos"/>
        <xsl:param name="index"/>
        <xsl:param name="total"/>
        <xsl:if test="($index - 1 &lt; $total) or ($index - 1 = $total)">
            <xsl:element name="table:filter-condition">
                <xsl:attribute name="table:data-type">number</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]/@x:Type = 'TopPercent'">
                        <xsl:attribute name="table:operator">
                            <xsl:value-of select="'top value'"/>
                        </xsl:attribute>
                        <xsl:attribute name="table:value">
                            <xsl:value-of select="./x:AutoFilterColumn[position() = $item-pos]/@x:Value"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]/@x:Type = 'Top'">
                        <xsl:attribute name="table:operator">
                            <xsl:value-of select="'top values'"/>
                        </xsl:attribute>
                        <xsl:attribute name="table:value">
                            <xsl:value-of select="./x:AutoFilterColumn[position() = $item-pos]/@x:Value"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]/@x:Type = 'TopPercent'">
                        <xsl:attribute name="table:operator">
                            <xsl:value-of select="'top percent'"/>
                        </xsl:attribute>
                        <xsl:attribute name="table:value">
                            <xsl:value-of select="./x:AutoFilterColumn[position() = $item-pos]/@x:Value"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]/@x:Type = 'Bottom'">
                        <xsl:attribute name="table:operator">
                            <xsl:value-of select="'bottom values'"/>
                        </xsl:attribute>
                        <xsl:attribute name="table:value">
                            <xsl:value-of select="./x:AutoFilterColumn[position() = $item-pos]/@x:Value"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]/@x:Type = 'BottomPercent'">
                        <xsl:attribute name="table:operator">
                            <xsl:value-of select="'bottom percent'"/>
                        </xsl:attribute>
                        <xsl:attribute name="table:value">
                            <xsl:value-of select="./x:AutoFilterColumn[position() = $item-pos]/@x:Value"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]/@x:Type = 'Custom'">
                        <xsl:choose>
                            <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]/x:AutoFilterOr or ./x:AutoFilterColumn[position() = $item-pos]/x:AutoFilterAnd">
                                <xsl:attribute name="table:operator">
                                    <xsl:choose>
                                        <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]//@x:Operator = 'Equals'">
                                            <xsl:value-of select="'='"/>
                                        </xsl:when>
                                        <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]//@x:Operator = 'DoesNotEquals'">
                                            <xsl:value-of select="'!='"/>
                                        </xsl:when>
                                        <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]//@x:Operator = 'GreaterThan'">
                                            <xsl:value-of select="'&gt;'"/>
                                        </xsl:when>
                                        <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]//@x:Operator = 'GreaterThanOrEqual'">
                                            <xsl:value-of select="'&gt;='"/>
                                        </xsl:when>
                                        <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]//@x:Operator = 'LessThan'">
                                            <xsl:value-of select="'&lt;'"/>
                                        </xsl:when>
                                        <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]//@x:Operator = 'LessThanOrEqual'">
                                            <xsl:value-of select="'&lt;='"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'='"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:attribute name="table:value">
                                    <xsl:value-of select="./x:AutoFilterColumn[position() = $item-pos]//@x:Value"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="table:operator">
                                    <xsl:value-of select="'bottom percent'"/>
                                </xsl:attribute>
                                <xsl:attribute name="table:value">
                                    <xsl:value-of select="./x:AutoFilterColumn[position() = $item-pos]//@x:Value"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
                <xsl:attribute name="table:field-number">
                    <xsl:choose>
                        <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]/@x:Index">
                            <xsl:value-of select="./x:AutoFilterColumn[position() = $item-pos]/@x:Index - 1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$index - 1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:element>
            <xsl:call-template name="auto-filter-condition">
                <xsl:with-param name="item-pos" select="$item-pos + 1"/>
                <xsl:with-param name="index">
                    <xsl:choose>
                        <xsl:when test="./x:AutoFilterColumn[position() = $item-pos]/@x:Index">
                            <xsl:value-of select="./x:AutoFilterColumn[position() = $item-pos]/@x:Index + 1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$index + 1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="total" select="count(./x:AutoFilterColumn)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template match="x:Sorting">
        <!-- for Sorting don't contains header row -->
        <xsl:if test="contains(./x:Sort, 'Column')">
            <xsl:element name="table:database-range">
                <xsl:variable name="first-sort-letter" select="normalize-space(substring-after(./x:Sort[position() = 1], 'Column'))"/>
                <xsl:variable name="second-sort-letter" select="normalize-space(substring-after(./x:Sort[position() = 2], 'Column'))"/>
                <xsl:variable name="third-sort-letter" select="normalize-space(substring-after(./x:Sort[position() = 3], 'Column'))"/>
                <xsl:variable name="first-sort-num">
                    <xsl:call-template name="letter-to-number">
                        <xsl:with-param name="source-letter" select="$first-sort-letter"/>
                        <xsl:with-param name="return-value" select="0"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="second-sort-num">
                    <xsl:call-template name="letter-to-number">
                        <xsl:with-param name="source-letter" select="$second-sort-letter"/>
                        <xsl:with-param name="return-value" select="0"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="third-sort-num">
                    <xsl:call-template name="letter-to-number">
                        <xsl:with-param name="source-letter" select="$third-sort-letter"/>
                        <xsl:with-param name="return-value" select="0"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="min-left-num">
                    <xsl:call-template name="min-of-three">
                        <xsl:with-param name="first-num" select="$first-sort-num"/>
                        <xsl:with-param name="second-num" select="$second-sort-num"/>
                        <xsl:with-param name="third-num" select="$third-sort-num"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="max-right-num">
                    <xsl:call-template name="max-of-three">
                        <xsl:with-param name="first-num" select="$first-sort-num"/>
                        <xsl:with-param name="second-num" select="$second-sort-num"/>
                        <xsl:with-param name="third-num" select="$third-sort-num"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="left-column">
                    <xsl:call-template name="number-to-letter">
                        <xsl:with-param name="source-number" select="$min-left-num"/>
                        <xsl:with-param name="return-value" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="right-column">
                    <xsl:call-template name="number-to-letter">
                        <xsl:with-param name="source-number" select="$max-right-num"/>
                        <xsl:with-param name="return-value" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:attribute name="table:target-range-address">
                    <xsl:value-of select="concat(../@ss:Name, '.', $left-column, '1:', ../@ss:Name, '.', $right-column, '32000')"/>
                </xsl:attribute>
                <xsl:attribute name="table:name">
                    <xsl:value-of select="concat(../@ss:Name, '.sort')"/>
                </xsl:attribute>
                <xsl:attribute name="table:contains-header">
                    <xsl:value-of select="'false'"/>
                </xsl:attribute>
                <xsl:element name="table:sort">
                    <xsl:for-each select="./x:Sort">
                        <xsl:element name="table:sort-by">
                            <xsl:attribute name="table:field-number">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                            <xsl:attribute name="table:data-type">
                                <xsl:value-of select="'automatic'"/>
                            </xsl:attribute>
                            <xsl:variable name="after-sort" select="following-sibling::*"/>
                            <xsl:if test="name($after-sort[position() = 1]) = 'Descending'">
                                <xsl:attribute name="table:order">
                                    <xsl:value-of select="'descending'"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="position() = 1">
                                    <xsl:attribute name="table:field-number">
                                        <xsl:value-of select="$first-sort-num - $min-left-num"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:when test="position() = 2">
                                    <xsl:attribute name="table:field-number">
                                        <xsl:value-of select="$second-sort-num - $min-left-num"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:when test="position() = 3">
                                    <xsl:attribute name="table:field-number">
                                        <xsl:value-of select="$third-sort-num - $min-left-num"/>
                                    </xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="letter-to-number">
        <!-- convert letter to number for sorting. the string source-letter should be normalize-space and the first return-value should be zero -->
        <xsl:param name="source-letter"/>
        <xsl:param name="return-value"/>
        <xsl:choose>
            <xsl:when test="string-length($source-letter) &gt; 0">
                <xsl:variable name="first-pit" select="substring($source-letter, 1, 1)"/>
                <xsl:variable name="pit-number">
                    <xsl:choose>
                        <xsl:when test="($first-pit = 'A') or ($first-pit = 'a')">
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'B') or ($first-pit = 'b')">
                            <xsl:value-of select="2"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'C') or ($first-pit = 'c')">
                            <xsl:value-of select="3"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'D') or ($first-pit = 'd')">
                            <xsl:value-of select="4"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'E') or ($first-pit = 'e')">
                            <xsl:value-of select="5"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'F') or ($first-pit = 'f')">
                            <xsl:value-of select="6"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'G') or ($first-pit = 'g')">
                            <xsl:value-of select="7"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'H') or ($first-pit = 'h')">
                            <xsl:value-of select="8"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'I') or ($first-pit = 'i')">
                            <xsl:value-of select="9"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'J') or ($first-pit = 'j')">
                            <xsl:value-of select="10"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'K') or ($first-pit = 'k')">
                            <xsl:value-of select="11"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'L') or ($first-pit = 'l')">
                            <xsl:value-of select="12"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'M') or ($first-pit = 'm')">
                            <xsl:value-of select="13"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'N') or ($first-pit = 'n')">
                            <xsl:value-of select="14"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'O') or ($first-pit = 'o')">
                            <xsl:value-of select="15"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'P') or ($first-pit = 'p')">
                            <xsl:value-of select="16"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'Q') or ($first-pit = 'q')">
                            <xsl:value-of select="17"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'R') or ($first-pit = 'r')">
                            <xsl:value-of select="18"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'S') or ($first-pit = 's')">
                            <xsl:value-of select="19"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'T') or ($first-pit = 't')">
                            <xsl:value-of select="20"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'U') or ($first-pit = 'u')">
                            <xsl:value-of select="21"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'V') or ($first-pit = 'v')">
                            <xsl:value-of select="22"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'W') or ($first-pit = 'w')">
                            <xsl:value-of select="23"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'X') or ($first-pit = 'x')">
                            <xsl:value-of select="24"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'Y') or ($first-pit = 'y')">
                            <xsl:value-of select="25"/>
                        </xsl:when>
                        <xsl:when test="($first-pit = 'Z') or ($first-pit = 'z')">
                            <xsl:value-of select="26"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="letter-to-number">
                    <xsl:with-param name="source-letter" select="substring($source-letter, 2)"/>
                    <xsl:with-param name="return-value">
                        <xsl:choose>
                            <xsl:when test="string-length($source-letter) &gt;= 2">
                                <xsl:value-of select="$pit-number * 26 + $return-value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$pit-number + $return-value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$return-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="number-to-letter">
        <!--?? convert number to letter for sorting -->
        <xsl:param name="source-number"/>
        <xsl:param name="return-value"/>
        <xsl:variable name="current-value">
            <xsl:call-template name="num-conv-letter">
                <xsl:with-param name="first-pit">
                    <xsl:choose>
                        <xsl:when test="$source-number &gt; 26">
                            <xsl:value-of select="floor($source-number div 26)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$source-number"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$source-number &gt; 26">
            <xsl:call-template name="number-to-letter">
                <xsl:with-param name="source-number" select="$source-number mod 26"/>
                <xsl:with-param name="return-value" select="concat($return-value,$current-value)"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$source-number &lt; 27">
            <xsl:value-of select="concat($return-value,$current-value)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="num-conv-letter">
        <!-- convert number to number by pit of 26 -->
        <xsl:param name="first-pit"/>
        <xsl:choose>
            <xsl:when test="$first-pit = 1">
                <xsl:value-of select="'A'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 2">
                <xsl:value-of select="'B'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 3">
                <xsl:value-of select="'C'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 4">
                <xsl:value-of select="'D'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 5">
                <xsl:value-of select="'E'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 6">
                <xsl:value-of select="'F'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 7">
                <xsl:value-of select="'G'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 8">
                <xsl:value-of select="'H'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 9">
                <xsl:value-of select="'I'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 10">
                <xsl:value-of select="'J'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 11">
                <xsl:value-of select="'K'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 12">
                <xsl:value-of select="'L'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 13">
                <xsl:value-of select="'M'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 14">
                <xsl:value-of select="'N'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 15">
                <xsl:value-of select="'O'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 16">
                <xsl:value-of select="'P'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 17">
                <xsl:value-of select="'Q'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 18">
                <xsl:value-of select="'R'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 19">
                <xsl:value-of select="'S'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 20">
                <xsl:value-of select="'T'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 21">
                <xsl:value-of select="'U'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 22">
                <xsl:value-of select="'V'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 23">
                <xsl:value-of select="'W'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 24">
                <xsl:value-of select="'X'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 25">
                <xsl:value-of select="'Y'"/>
            </xsl:when>
            <xsl:when test="$first-pit = 26">
                <xsl:value-of select="'Z'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'A'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="min-of-three">
        <!-- return lowest of three for sorting -->
        <xsl:param name="first-num"/>
        <xsl:param name="second-num"/>
        <xsl:param name="third-num"/>
        <xsl:variable name="first-comp">
            <xsl:choose>
                <xsl:when test="$first-num = 0">
                    <xsl:value-of select="$second-num"/>
                </xsl:when>
                <xsl:when test="($first-num &lt; $second-num) or ($second-num = 0)">
                    <xsl:value-of select="$first-num"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$second-num"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="second-comp">
            <xsl:choose>
                <xsl:when test="($first-comp &lt; $third-num) or ($third-num = 0)">
                    <xsl:value-of select="$first-comp"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$third-num"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$second-comp"/>
    </xsl:template>
    <xsl:template name="max-of-three">
        <!-- return greatest of three for sorting -->
        <xsl:param name="first-num"/>
        <xsl:param name="second-num"/>
        <xsl:param name="third-num"/>
        <xsl:variable name="first-comp">
            <xsl:choose>
                <xsl:when test="$first-num &gt; $second-num">
                    <xsl:value-of select="$first-num"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$second-num"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="second-comp">
            <xsl:choose>
                <xsl:when test="$first-comp &gt; $third-num">
                    <xsl:value-of select="$first-comp"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$third-num"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$second-comp"/>
    </xsl:template>
    <xsl:template name="set-calculation">
        <xsl:element name="table:calculation-settings">
            <xsl:if test="/ss:Workbook/x:ExcelWorkbook/x:PrecisionAsDisplayed">
                <xsl:attribute name="table:precision-as-shown">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="/ss:Workbook/x:ExcelWorkbook/x:Date1904">
                <table:null-date office:date-value="1904-01-01"/>
            </xsl:if>
            <xsl:element name="table:iteration">
                <xsl:if test="/ss:Workbook/x:ExcelWorkbook/x:Iteration">
                    <xsl:attribute name="table:status">enable</xsl:attribute>
                </xsl:if>
                <xsl:if test="/ss:Workbook/x:ExcelWorkbook/x:MaxIterations">
                    <xsl:attribute name="table:steps">
                        <xsl:value-of select="/ss:Workbook/x:ExcelWorkbook/x:MaxIterations"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="/ss:Workbook/x:ExcelWorkbook/x:MaxChange">
                    <xsl:attribute name="table:maximum-difference">
                        <xsl:value-of select="/ss:Workbook/x:ExcelWorkbook/x:MaxChange"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="x:DataValidation">
        <!-- for DataValidation. don't support the attribute IMEMode currently.  -->
        <xsl:element name="table:content-validation">
            <xsl:attribute name="table:name">
                <xsl:value-of select="concat('val', position())"/>
            </xsl:attribute>
            <xsl:attribute name="table:condition"><!-- don't support two type of qualifier: List, Custom -->
                <xsl:variable name="qualifier-content">
                    <xsl:choose>
                        <xsl:when test="./x:Qualifier = 'NotBetween'">
                            <xsl:value-of select="concat('cell-content-is-not-between(', ./x:Min, ',', ./x:Max, ')')"/>
                        </xsl:when>
                        <xsl:when test="./x:Qualifier = 'NotEqual'">
                            <xsl:value-of select="concat('!=', ./x:Value)"/>
                        </xsl:when>
                        <xsl:when test="./x:Qualifier = 'Equal'">
                            <xsl:value-of select="concat('=', ./x:Value)"/>
                        </xsl:when>
                        <xsl:when test="./x:Qualifier = 'Less'">
                            <xsl:value-of select="concat('&lt;', ./x:Value)"/>
                        </xsl:when>
                        <xsl:when test="./x:Qualifier = 'Greater'">
                            <xsl:value-of select="concat('&gt;', ./x:Value)"/>
                        </xsl:when>
                        <xsl:when test="./x:Qualifier = 'GreaterOrEqual'">
                            <xsl:value-of select="concat('&gt;=', ./x:Value)"/>
                        </xsl:when>
                        <xsl:when test="./x:Qualifier = 'LessOrEqual'">
                            <xsl:value-of select="concat('&lt;=', ./x:Value)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('cell-content-is-between(', ./x:Min, ',', ./x:Max)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="qualifier-value">
                    <xsl:choose>
                        <xsl:when test="./x:Type = 'Whole'">
                            <xsl:choose>
                                <xsl:when test="(./x:Qualifier = 'NotBetween') or ./x:Max">
                                    <xsl:value-of select="concat('cell-content-is-whole-number() and ', $qualifier-content, ')')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('cell-content-is-whole-number() and ', 'cell-content()', $qualifier-content)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="./x:Type = 'Decimal'">
                            <xsl:choose>
                                <xsl:when test="(./x:Qualifier = 'NotBetween') or ./x:Max">
                                    <xsl:value-of select="concat('cell-content-is-decimal-number() and ', $qualifier-content, ')')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('cell-content-is-decimal-number() and ', 'cell-content()', $qualifier-content)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="./x:Type = 'Date'">
                            <xsl:choose>
                                <xsl:when test="(./x:Qualifier = 'NotBetween') or ./x:Max">
                                    <xsl:value-of select="concat('cell-content-is-date() and ', $qualifier-content, ')')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('cell-content-is-date() and ', 'cell-content()', $qualifier-content)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="./x:Type = 'Time'">
                            <xsl:choose>
                                <xsl:when test="(./x:Qualifier = 'NotBetween') or ./x:Max">
                                    <xsl:value-of select="concat('cell-content-is-time() and ', $qualifier-content, ')')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('cell-content-is-time() and ', 'cell-content()', $qualifier-content)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="./x:Type = 'TextLength'">
                            <xsl:choose>
                                <xsl:when test="./x:Qualifier = 'NotBetween'">
                                    <xsl:value-of select="concat('cell-content-text-length-is-not-between(', ./x:Min, ',', ./x:Max, ')')"/>
                                </xsl:when>
                                <xsl:when test="./x:Max and ./x:Min">
                                    <xsl:value-of select="concat('cell-content-text-length-is-between(', ./x:Min, ',', ./x:Max, ')')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('cell-content-text-length()', $qualifier-content)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./x:Type"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="$qualifier-value"/>
            </xsl:attribute>
            <xsl:attribute name="table:base-cell-address">
                <xsl:variable name="first-range">
                    <xsl:choose>
                        <xsl:when test="contains(./x:Range, ',')">
                            <xsl:value-of select="substring-before(./x:Range, ',')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./x:Range"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="range">
                    <xsl:call-template name="translate-expression">
                        <xsl:with-param name="cell-row-pos" select="0"/>
                        <xsl:with-param name="cell-column-pos" select="0"/>
                        <xsl:with-param name="expression" select="$first-range"/>
                        <xsl:with-param name="return-value" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="encode-as-cell-address">
                    <xsl:with-param name="string" select="concat(../../ss:Worksheet/@ss:Name, '.', $range)"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:element name="table:help-message">
                <xsl:attribute name="table:title">
                    <xsl:value-of select="./x:InputTitle"/>
                </xsl:attribute>
                <xsl:attribute name="table:display">
                    <xsl:choose>
                        <xsl:when test="./x:InputHide">
                            <xsl:value-of select="'false'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'true'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:element name="text:p">
                    <xsl:value-of select="./x:InputMessage"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="table:error-message">
                <xsl:attribute name="table:message-type">
                    <xsl:choose>
                        <xsl:when test="./x:ErrorStyle= 'Info'">
                            <xsl:value-of select="'information'"/>
                        </xsl:when>
                        <xsl:when test="./x:ErrorStyle= 'Warn'">
                            <xsl:value-of select="'warning'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'stop'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="table:title">
                    <xsl:value-of select="./x:ErrorTitle"/>
                </xsl:attribute>
                <xsl:attribute name="table:display">
                    <xsl:choose>
                        <xsl:when test="./x:ErrorHide">
                            <xsl:value-of select="'false'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'true'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:element name="text:p">
                    <xsl:value-of select="./x:ErrorMessage"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- Note: Move template to common section -->
    <xsl:template name="encode-as-cell-range-address">
        <xsl:param name="string"/>
        <xsl:value-of select="$string"/>
    </xsl:template>
    <xsl:template name="encode-as-cell-address">
        <xsl:param name="string"/>
        <xsl:value-of select="$string"/>
    </xsl:template>
    <xsl:template name="encode-as-nc-name">
        <xsl:param name="string"/>
        <xsl:value-of select="translate($string, '.%()/\+[]', '')"/>
    </xsl:template>

    <xsl:template name="set:distinct">
        <xsl:param name="nodes" select="/.."/>
        <xsl:param name="distinct" select="/.."/>
        <xsl:choose>
            <xsl:when test="$nodes">
                <xsl:call-template name="set:distinct">
                    <xsl:with-param name="distinct" select="$distinct | $nodes[1][not(. = $distinct)]"/>
                    <xsl:with-param name="nodes" select="$nodes[position() > 1]"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$distinct" mode="set:distinct"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="node()|@*" mode="set:distinct">
        <xsl:copy-of select="." />
    </xsl:template>

</xsl:stylesheet>
