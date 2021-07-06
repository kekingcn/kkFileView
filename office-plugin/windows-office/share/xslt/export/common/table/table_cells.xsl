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
<!--
    For further documentation and updates visit http://xml.openoffice.org/odf2xhtml
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
    xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dom="http://www.w3.org/2001/xml-events"
    xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
    xmlns:math="http://www.w3.org/1998/Math/MathML"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:ooo="http://openoffice.org/2004/office"
    xmlns:oooc="http://openoffice.org/2004/calc"
    xmlns:ooow="http://openoffice.org/2004/writer"
    xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:xforms="http://www.w3.org/2002/xforms"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xt="http://www.jclark.com/xt"
    xmlns:common="http://exslt.org/common"
    xmlns:xalan="http://xml.apache.org/xalan"
    exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xforms xlink xsd xsi xt common xalan">


    <!-- *********************************** -->
    <!-- *** write repeating table cells *** -->
    <!-- *********************************** -->


    <!-- matching cells to give out -> covered table cells are not written out -->
    <xsl:template match="table:table-cell">
        <xsl:param name="globalData" />
        <!-- position of the current input cell to get the correct column style (hidden are also counted)-->
        <xsl:param name="allTableColumns" />
        <xsl:param name="maxRowLength" />
        <xsl:param name="tableDataType" />


        <!-- The column position of the current cell has to be determined
        to get the adequate column styles during later cell creation,
        or hiding the cell when @table:visibility is not set to 'visible'.

        The position is archived by adding up all table:number-columns-repeated of the preceding cells.
            Step1: creating '$precedingCells/quantity/@table:number-columns-repeated').
            Step2: sum(xxx:nodeset($precedingCells)/quantity) + 1        -->
        <xsl:variable name="precedingCells">
            <xsl:for-each select="preceding-sibling::*">
                <xsl:choose>
                    <!-- maybe a parser is used, which reads the DTD files (e.g. Xerces),
                        then '1' is the default for 'table:number-columns-repeated' -->
                    <xsl:when test="not(@table:number-columns-repeated and @table:number-columns-repeated > 1)">
                        <xsl:element name="quantity" namespace="">
                            <xsl:text>1</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="quantity" namespace="">
                            <xsl:value-of select="@table:number-columns-repeated" />
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>



        <xsl:choose>
            <xsl:when test="function-available('common:node-set')">
                <xsl:call-template name="create-table-cell">
                    <!-- position of the current input cell to get the correct column style (hidden are also counted)-->
                    <xsl:with-param name="allTableColumns"  select="$allTableColumns" />
                    <xsl:with-param name="maxRowLength"     select="$maxRowLength" />
                    <xsl:with-param name="precedingColumns"   select="sum(common:node-set($precedingCells)/*)" />
                    <xsl:with-param name="globalData"       select="$globalData" />
                    <xsl:with-param name="tableDataType"    select="$tableDataType" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xalan:nodeset')">
                <xsl:call-template name="create-table-cell">
                    <!-- position of the current input cell to get the correct column style (hidden are also counted)-->
                    <xsl:with-param name="allTableColumns"  select="$allTableColumns" />
                    <xsl:with-param name="maxRowLength"     select="$maxRowLength" />
                    <xsl:with-param name="precedingColumns"   select="sum(xalan:nodeset($precedingCells)/*)" />
                    <xsl:with-param name="globalData"       select="$globalData" />
                    <xsl:with-param name="tableDataType"    select="$tableDataType" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xt:node-set')">
                <xsl:call-template name="create-table-cell">
                    <!-- position of the current input cell to get the correct column style (hidden are also counted)-->
                    <xsl:with-param name="allTableColumns"  select="$allTableColumns" />
                    <xsl:with-param name="maxRowLength"     select="$maxRowLength" />
                    <xsl:with-param name="precedingColumns"   select="sum(xt:node-set($precedingCells)/*)" />
                    <xsl:with-param name="globalData"       select="$globalData" />
                    <xsl:with-param name="tableDataType"    select="$tableDataType" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">ERROR: Function not found: nodeset</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- current node is a table:table-cell -->
    <xsl:template name="create-table-cell">
        <!-- position of the current input cell to get the correct column style (hidden are also counted)-->
        <xsl:param name="allTableColumns" />
        <xsl:param name="globalData" />
        <xsl:param name="maxRowLength" />
        <xsl:param name="precedingColumns" select="0" />
        <xsl:param name="tableDataType" />

        <xsl:variable name="columnPosition" select="$precedingColumns + 1" />

        <xsl:if test="$debugEnabled">
            <xsl:message>
                <xsl:text>
                    table:table-cell #</xsl:text>
                <xsl:value-of select="$columnPosition" />
                <xsl:text> has been entered with node value: </xsl:text>
                <xsl:value-of select="." />
                <xsl:text>
                    table:number-columns-repeated: </xsl:text>
                <xsl:value-of select="@table:number-columns-repeated" />
                <xsl:text>
                    maxRowLength: </xsl:text>
                <xsl:value-of select="$maxRowLength" />
            </xsl:message>
        </xsl:if>

        <!-- only non hidden column will be given out -->
        <xsl:variable name="currentTableColumn" select="$allTableColumns/table:table-column[position() = $columnPosition]" />
        <xsl:if test="$currentTableColumn[not(@table:visibility = 'collapse' or @table:visibility = 'filter')]">
            <xsl:choose>
                <!-- if parser reads DTD the default is set to '1' -->
                <xsl:when test="@table:number-columns-repeated > 1">
                    <!-- writes multiple entries of a cell -->
                    <xsl:call-template name="repeat-write-cell">
                        <xsl:with-param name="globalData"               select="$globalData" />
                        <xsl:with-param name="allTableColumns"          select="$allTableColumns" />
                        <xsl:with-param name="columnPosition"           select="$columnPosition" />
                        <xsl:with-param name="currentTableColumn"       select="$currentTableColumn" />
                        <xsl:with-param name="maxRowLength"             select="$maxRowLength" />
                        <xsl:with-param name="numberColumnsRepeated"    select="@table:number-columns-repeated" />
                        <xsl:with-param name="tableDataType"            select="$tableDataType" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <!-- writes an entry of a cell -->
                    <xsl:call-template name="write-cell">
                        <xsl:with-param name="globalData"           select="$globalData" />
                        <xsl:with-param name="allTableColumns"      select="$allTableColumns" />
                        <xsl:with-param name="columnPosition"       select="$columnPosition" />
                        <xsl:with-param name="currentTableColumn"   select="$currentTableColumn" />
                        <xsl:with-param name="maxRowLength"         select="$maxRowLength" />
                        <xsl:with-param name="tableDataType"        select="$tableDataType" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>


    <xsl:template name="repeat-write-cell">
        <xsl:param name="globalData" />
        <xsl:param name="allTableColumns" />
        <xsl:param name="columnPosition" />
        <xsl:param name="currentTableColumn" />
        <xsl:param name="maxRowLength" />
        <xsl:param name="numberColumnsRepeated" />
        <xsl:param name="tableDataType" />

        <xsl:choose>
            <!-- This is the current workaround for the flood of cells, simulation background by repeating cell -->
            <xsl:when test="$numberColumnsRepeated > 1 and $maxRowLength > $columnPosition">

                <!-- writes an entry of a cell -->
                <xsl:call-template name="write-cell">
                    <xsl:with-param name="globalData"           select="$globalData" />
                    <xsl:with-param name="allTableColumns"      select="$allTableColumns" />
                    <xsl:with-param name="columnPosition"       select="$columnPosition" />
                    <xsl:with-param name="currentTableColumn"   select="$currentTableColumn" />
                    <xsl:with-param name="tableDataType"        select="$tableDataType" />
                </xsl:call-template>
                <!-- repeat calling this method until all elements written out -->
                <xsl:if test="$debugEnabled">
                    <xsl:message>+++++++++ cell repetition +++++++++</xsl:message>
                </xsl:if>
                <xsl:call-template name="repeat-write-cell">
                    <xsl:with-param name="globalData"               select="$globalData" />
                    <xsl:with-param name="allTableColumns"          select="$allTableColumns" />
                    <xsl:with-param name="columnPosition"           select="$columnPosition + 1" />
                    <xsl:with-param name="currentTableColumn"       select="$allTableColumns/table:table-column[position() = ($columnPosition + 1)]" />
                    <xsl:with-param name="maxRowLength"             select="$maxRowLength" />
                    <xsl:with-param name="numberColumnsRepeated"    select="$numberColumnsRepeated - 1" />
                    <xsl:with-param name="tableDataType"            select="$tableDataType" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- This is the current workaround for the flood of cells, simulation background by repeating cell -->
                <!--      When the maxRowLength is reached a last entry of a cell is written -->
                <xsl:call-template name="write-cell">
                    <xsl:with-param name="globalData"           select="$globalData" />
                    <xsl:with-param name="allTableColumns"      select="$allTableColumns" />
                    <xsl:with-param name="columnPosition"       select="$columnPosition" />
                    <xsl:with-param name="currentTableColumn"   select="$currentTableColumn" />
                    <xsl:with-param name="tableDataType"        select="$tableDataType" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="write-cell">
        <xsl:param name="globalData" />
        <xsl:param name="allTableColumns" />
        <xsl:param name="columnPosition" />
        <xsl:param name="currentTableColumn" />
        <xsl:param name="tableDataType" />

        <!-- a non hidden column will be give out -->
        <xsl:choose>
            <xsl:when test="$currentTableColumn[not(@table:visibility = 'collapse' or @table:visibility = 'filter')]">
                <xsl:call-template name="create-table-cell-content">
                    <xsl:with-param name="globalData"           select="$globalData" />
                    <xsl:with-param name="allTableColumns"      select="$allTableColumns" />
                    <xsl:with-param name="columnPosition"       select="$columnPosition" />
                    <xsl:with-param name="currentTableColumn"   select="$currentTableColumn" />
                    <xsl:with-param name="tableDataType"        select="$tableDataType" />
                </xsl:call-template>
            </xsl:when>
            <!-- a hidden column -->
            <xsl:otherwise>
                <xsl:if test="$debugEnabled">
                    <xsl:message>table column is hidden!</xsl:message>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
