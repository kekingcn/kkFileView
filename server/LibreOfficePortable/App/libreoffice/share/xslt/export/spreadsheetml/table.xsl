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
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xt="http://www.jclark.com/xt"
    xmlns:common="http://exslt.org/common"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:c="urn:schemas-microsoft-com:office:component:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x2="http://schemas.microsoft.com/office/excel/2003/xml" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xlink xt common xalan">


    <!-- ************** -->
    <!-- *** Table  *** -->
    <!-- ************** -->

    <!-- check existence of default cell style -->
    <xsl:variable name="firstDefaultCellStyle" select="descendant::table:table-column/@table:default-cell-style-name" />


    <xsl:template match="table:table" name="table:table">
        <xsl:element name="Table">
            <xsl:apply-templates select="@table:style-name" />

            <!-- find all columns in the table -->
            <xsl:variable name="columnNodes" select="descendant::table:table-column" />
            <!-- calculate the overall column amount -->
            <xsl:variable name="maxColumnNo">
                <xsl:choose>
                    <xsl:when test="$columnNodes/@table:number-columns-repeated">
                        <xsl:value-of select="count($columnNodes)
                                            + number(sum($columnNodes/@table:number-columns-repeated))
                                            - count($columnNodes/@table:number-columns-repeated)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="count($columnNodes)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- create columns -->
            <xsl:apply-templates select="$columnNodes[1]">
                <xsl:with-param name="columnNodes"  select="$columnNodes" />
                <xsl:with-param name="maxColumnNo"  select="$maxColumnNo" />
            </xsl:apply-templates>

            <!-- create rows -->
            <xsl:choose>
                <xsl:when test="not($columnNodes/@table:number-columns-repeated)">
                    <xsl:call-template name="optimized-row-handling">
                        <xsl:with-param name="rowNodes"         select="descendant::table:table-row" />
                        <xsl:with-param name="columnNodes"      select="$columnNodes" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <!-- To be able to match from a cell to the corresponding column to match @table:default-cell-style-name,
                        the repeated columns are being resolved by copying them in a helper variable -->
                    <xsl:variable name="columnNodes-RTF">
                        <xsl:for-each select="$columnNodes">
                            <xsl:call-template name="adding-column-styles-entries" />
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="function-available('xalan:nodeset')">
                            <xsl:call-template name="optimized-row-handling">
                                <xsl:with-param name="rowNodes"         select="descendant::table:table-row" />
                                <xsl:with-param name="columnNodes"      select="xalan:nodeset($columnNodes-RTF)" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="function-available('common:node-set')">
                            <xsl:call-template name="optimized-row-handling">
                                <xsl:with-param name="rowNodes"         select="descendant::table:table-row" />
                                <xsl:with-param name="columnNodes"      select="common:node-set($columnNodes-RTF)" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="function-available('xt:node-set')">
                            <xsl:call-template name="optimized-row-handling">
                                <xsl:with-param name="rowNodes"         select="descendant::table:table-row" />
                                <xsl:with-param name="columnNodes"      select="xt:node-set($columnNodes-RTF)" />
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>


    <!-- **************** -->
    <!-- *** Columns  *** -->
    <!-- **************** -->

    <xsl:template match="table:table-column">
        <xsl:param name="columnNodes"  />
        <xsl:param name="currentColumnNumber" select="1" />
        <xsl:param name="setIndex" select="false()" />
        <xsl:param name="maxColumnNo" />

        <xsl:element name="Column">
            <xsl:if test="@table:visibility = 'collapse' or @table:visibility = 'filter'">
                <xsl:attribute name="ss:Hidden">1</xsl:attribute>
            </xsl:if>

            <xsl:if test="@table:number-columns-repeated">
                <xsl:attribute name="ss:Span">
                    <xsl:value-of select="@table:number-columns-repeated - 1" />
                </xsl:attribute>
            </xsl:if>

           <xsl:if test="$setIndex">
                <xsl:attribute name="ss:Index">
                    <xsl:value-of select="$currentColumnNumber" />
                </xsl:attribute>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="@style:use-optimal-column-width = 'true'">
                    <xsl:attribute name="ss:AutoFitWidth">1</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="width" select="key('styles', @table:style-name)/style:table-column-properties/@style:column-width" />
                    <xsl:if test="$width">
                        <xsl:attribute name="ss:Width">
                            <!-- using the absolute width in point -->
                            <xsl:call-template name="convert2pt">
                                <xsl:with-param name="value" select="$width" />
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="@table:number-columns-repeated">
                <xsl:attribute name="ss:Span">
                    <xsl:value-of select="@table:number-columns-repeated - 1" />
                </xsl:attribute>
            </xsl:if>
        </xsl:element>

        <xsl:variable name="columnNumber">
            <xsl:choose>
                <xsl:when test="@table:number-columns-repeated">
                    <xsl:value-of select="$currentColumnNumber + @table:number-columns-repeated"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$currentColumnNumber"/>
               </xsl:otherwise>
           </xsl:choose>
       </xsl:variable>
        <xsl:if test="$columnNumber &lt; $maxColumnNo">
            <xsl:variable name="nextColumnNodes" select="$columnNodes[position() != 1]" />
            <xsl:choose>
                <xsl:when test="@table:number-columns-repeated">
                    <xsl:apply-templates select="$nextColumnNodes[1]">
                        <xsl:with-param name="columnNodes"          select="$nextColumnNodes" />
                        <xsl:with-param name="currentColumnNumber"  select="$columnNumber" />
                        <xsl:with-param name="maxColumnNo"          select="$maxColumnNo" />
                        <xsl:with-param name="setIndex"             select="true()" />
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$nextColumnNodes[1]">
                        <xsl:with-param name="columnNodes"          select="$nextColumnNodes" />
                        <xsl:with-param name="currentColumnNumber"  select="$columnNumber + 1" />
                        <xsl:with-param name="maxColumnNo"          select="$maxColumnNo" />
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- current node is a table:table-column -->
    <xsl:template name="adding-column-styles-entries">
        <xsl:choose>
            <xsl:when test="not(@table:number-columns-repeated and @table:number-columns-repeated > 1)">
                <!-- writes an entry of a column in the columns-variable -->
                <xsl:copy-of select="." />
            </xsl:when>
            <xsl:otherwise>
                <!-- repeated columns will be written explicit several times in the variable-->
                <xsl:call-template name="repeat-adding-table-column">
                    <xsl:with-param name="numberColumnsRepeated"  select="@table:number-columns-repeated" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>


    <!-- current node is a table:table-column -->
    <!-- duplicates column elements in case of column-repeated attribute  -->
    <xsl:template name="repeat-adding-table-column">
        <xsl:param name="table:table-column" />
        <xsl:param name="numberColumnsRepeated" />

        <xsl:choose>
            <xsl:when test="$numberColumnsRepeated > 1">
                <!-- writes an entry of a column in the columns-variable -->
                <xsl:copy-of select="." />
                <!-- repeat calling this method until all elements written out -->
                <xsl:call-template name="repeat-adding-table-column">
                    <xsl:with-param name="numberColumnsRepeated"    select="$numberColumnsRepeated - 1" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- writes an entry of a column in the columns-variable -->
                <xsl:copy-of select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- ************* -->
    <!-- *** Rows  *** -->
    <!-- ************* -->


    <!-- Recursions are much faster when the stack size is small    -->
    <xsl:template name="optimized-row-handling">
        <xsl:param name="rowNodes" />
        <xsl:param name="columnNodes"  />
        <xsl:param name="offset" select="0"/>
        <xsl:param name="threshold" select="10"/>

        <xsl:variable name="rowCount" select="count($rowNodes)"/>
        <xsl:choose>
            <xsl:when test="$rowCount &lt;= $threshold">
                <xsl:apply-templates select="$rowNodes[1]">
                    <xsl:with-param name="rowNodes" select="$rowNodes" />
                    <xsl:with-param name="offset" select="$offset" />
                    <xsl:with-param name="columnNodes" select="$columnNodes" />
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="rowCountHalf" select="floor($rowCount div 2)"/>
                <xsl:variable name="rowNodesSetA" select="$rowNodes[position() &lt;= $rowCountHalf]"/>
                <xsl:variable name="rowNodesSetB" select="$rowNodes[position() &gt; $rowCountHalf]"/>
                <!-- to keep track of the rownumber, the repeated rows have to kept into accounts -->
                <xsl:variable name="rowsCreatedByRepetition">
                <xsl:choose>
                    <xsl:when test="$rowNodesSetA/@table:number-rows-repeated">
                        <xsl:value-of select="number(sum($rowNodesSetA/@table:number-rows-repeated))
                                            - count($rowNodesSetA/@table:number-rows-repeated)" />
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$rowCountHalf &gt; $threshold">
                        <xsl:call-template name="optimized-row-handling">
                            <xsl:with-param name="rowNodes" select="$rowNodesSetA"/>
                            <xsl:with-param name="offset" select="$offset" />
                            <xsl:with-param name="columnNodes" select="$columnNodes" />
                        </xsl:call-template>
                        <xsl:call-template name="optimized-row-handling">
                            <xsl:with-param name="rowNodes" select="$rowNodesSetB"/>
                            <xsl:with-param name="offset" select="$offset + $rowCountHalf + $rowsCreatedByRepetition" />
                            <xsl:with-param name="columnNodes" select="$columnNodes" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$rowNodesSetA[1]">
                            <xsl:with-param name="rowNodes" select="$rowNodesSetA"/>
                            <xsl:with-param name="offset" select="$offset" />
                            <xsl:with-param name="columnNodes" select="$columnNodes" />
                        </xsl:apply-templates>
                        <xsl:apply-templates select="$rowNodesSetB[1]">
                            <xsl:with-param name="rowNodes" select="$rowNodesSetB" />
                            <xsl:with-param name="offset" select="$offset + $rowCountHalf + $rowsCreatedByRepetition" />
                            <xsl:with-param name="columnNodes" select="$columnNodes" />
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        Rows as "table:table-row" might be grouped in
        "table:table-header-rows" or "table:table-row-group"
        This row-tree will be traversed providing each Row with its
        calculatedRowPosition and earlierRowNumber.
        By this repeated empty rows might be neglected in the spreadsheetml output,
        as the following row will notice the 'gap' and provide @ss:Index,
        which results in filling up the gap by a row without style and content.

        In Excel created rows by ss:Index are 'default' rows.
    -->
    <xsl:template match="table:table-row">
        <xsl:param name="earlierRowNumber" select="0" />
        <xsl:param name="offset" />
        <xsl:param name="calculatedRowPosition" select="$offset + 1" />
        <xsl:param name="rowNodes" />
        <xsl:param name="columnNodes"  />

        <xsl:choose>
            <xsl:when test="@table:number-rows-repeated &gt; 1">
                <xsl:call-template name="write-table-row">
                    <xsl:with-param name="earlierRowNumber"  select="$earlierRowNumber" />
                    <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition" />
                    <xsl:with-param name="columnNodes" select="$columnNodes" />
                </xsl:call-template>
                <xsl:if test="@table:number-rows-repeated &gt; 2 and (table:table-cell/@office:value-type or $firstDefaultCellStyle != '')">
                    <!-- In case a cell is being repeated, the cell will be created
                    in a variable, which is as many times given out, as being repeated -->
                    <xsl:variable name="tableRow">
                        <xsl:call-template name="write-table-row">
                            <xsl:with-param name="columnNodes" select="$columnNodes" />
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:call-template name="optimized-row-repeating">
                        <xsl:with-param name="tableRow"     select="$tableRow" />
                        <xsl:with-param name="repetition"   select="@table:number-rows-repeated - 1" />
                        <xsl:with-param name="columnNodes" select="$columnNodes" />
                   </xsl:call-template>
               </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="write-table-row">
                    <xsl:with-param name="earlierRowNumber"  select="$earlierRowNumber" />
                    <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition" />
                    <xsl:with-param name="columnNodes" select="$columnNodes" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:variable name="nextRowNodes" select="$rowNodes[position()!=1]" />
        <xsl:choose>
            <xsl:when test="@table:number-rows-repeated &gt; 1">
                <xsl:apply-templates select="$nextRowNodes[1]">
                    <xsl:with-param name="earlierRowNumber"  select="$calculatedRowPosition" />
                    <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition + @table:number-rows-repeated" />
                    <xsl:with-param name="rowNodes" select="$nextRowNodes" />
                    <xsl:with-param name="columnNodes" select="$columnNodes" />
               </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$nextRowNodes[1]">
                    <xsl:with-param name="earlierRowNumber"  select="$calculatedRowPosition" />
                    <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition + 1" />
                    <xsl:with-param name="rowNodes" select="$nextRowNodes" />
                    <xsl:with-param name="columnNodes" select="$columnNodes" />
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="write-table-row">
        <xsl:param name="earlierRowNumber" select="0" />
        <xsl:param name="calculatedRowPosition" select="1" />
        <xsl:param name="columnNodes"  />

        <xsl:element name="Row">
            <xsl:if test="@table:visibility = 'collapse' or @table:visibility = 'filter'">
                <xsl:attribute name="ss:Hidden">1</xsl:attribute>
            </xsl:if>
            <xsl:if test="not($earlierRowNumber + 1 = $calculatedRowPosition)">
                <xsl:attribute name="ss:Index"><xsl:value-of select="$calculatedRowPosition" /></xsl:attribute>
            </xsl:if>

            <!-- writing the style of the row -->
            <xsl:apply-templates select="@table:style-name" mode="table-row" />

            <xsl:variable name="rowProperties" select="key('styles', @table:style-name)/*" />
            <xsl:if test="$rowProperties/@style:use-optimal-row-height = 'false'">
                <!-- default is '1', therefore write only '0' -->
                <xsl:attribute name="ss:AutoFitHeight">0</xsl:attribute>
            </xsl:if>

            <xsl:variable name="height" select="$rowProperties/@style:row-height" />
            <xsl:if test="$height">
                <xsl:attribute name="ss:Height">
                    <!-- using the absolute height in point -->
                    <xsl:call-template name="convert2pt">
                        <xsl:with-param name="value" select="$height" />
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="table:table-cell[1]">
                <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition" />
                <xsl:with-param name="cellNodes"  select="table:table-cell" />
                <xsl:with-param name="columnNodes" select="$columnNodes" />
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>


    <!-- Recursions are much faster when the stack size is small    -->
    <xsl:template name="optimized-row-repeating">
        <xsl:param name="tableRow" />
        <xsl:param name="repetition" />
        <!-- resource optimization: instead of '1' it will be '1000' and the column is not full -->
        <xsl:param name="thresholdmax" select="512"/>
        <xsl:param name="thresholdmin" select="256"/>

        <xsl:choose>
            <xsl:when test="$repetition &lt;= $thresholdmax">
                <xsl:copy-of select="$tableRow" />
                <xsl:if test="$repetition &gt;= $thresholdmin">
                    <xsl:call-template name="optimized-row-repeating">
                        <xsl:with-param name="repetition" select="$repetition - 1"/>
                        <xsl:with-param name="tableRow" select="$tableRow" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$repetition mod 2 = 1">
                    <xsl:copy-of select="$tableRow" />
                </xsl:if>
                <xsl:variable name="repetitionHalf" select="floor($repetition div 2)"/>
                <xsl:call-template name="optimized-row-repeating">
                    <xsl:with-param name="repetition" select="$repetitionHalf"/>
                    <xsl:with-param name="tableRow" select="$tableRow" />
                </xsl:call-template>
                <xsl:call-template name="optimized-row-repeating">
                    <xsl:with-param name="repetition" select="$repetitionHalf"/>
                    <xsl:with-param name="tableRow" select="$tableRow" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!-- ************** -->
    <!-- *** Cells  *** -->
    <!-- ************** -->

    <!-- Table cells are able to be repeated by attribute in StarOffice,
         but not in Excel. If more cells are repeated -->
    <xsl:template name="table:table-cell" match="table:table-cell">
        <xsl:param name="calculatedCellPosition" select="1" /><!-- the later table position of the current cell  -->
        <xsl:param name="calculatedRowPosition" /><!-- the later table position of the current row  -->
        <xsl:param name="setIndex" select="false()" /> <!-- if not '0' @ss:Index used for neglecting repeated empty cells -->
        <xsl:param name="repetition" select="@table:number-columns-repeated" /> <!-- used for explicit written out cells -->
        <xsl:param name="repetitionCellPosition" select="$calculatedCellPosition" /><!-- during repetition formula needs exact cell positioning -->
        <xsl:param name="nextMatchedCellPosition"><!-- the later table position of the next cell  -->
        <xsl:choose>
            <xsl:when test="not(@table:number-columns-repeated) and not(@table:number-columns-spanned)">
                <xsl:value-of select="$calculatedCellPosition + 1" />
            </xsl:when>
            <xsl:when test="not(@table:number-columns-spanned)">
                <xsl:value-of select="$calculatedCellPosition + @table:number-columns-repeated" />
            </xsl:when>
            <xsl:when test="not(@table:number-columns-repeated)">
                <xsl:value-of select="$calculatedCellPosition + @table:number-columns-spanned" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$calculatedCellPosition + @table:number-columns-spanned * @table:number-columns-repeated" />
            </xsl:otherwise>
        </xsl:choose>
        </xsl:param>
        <xsl:param name="cellNodes" /><!-- cells to be handled  -->
        <xsl:param name="columnNodes" />

        <xsl:choose>
            <!-- in case a repetition took place -->
            <xsl:when test="$repetition &gt; 0">
                <xsl:choose>
                    <!-- In case of no cell content (text, subelements, attribute, except repeated style) the ss:Index could be used -->
                    <xsl:when test="not(text()) and not(*) and not(@*[name() != 'table:number-columns-repeated'])">
                        <xsl:choose>
                            <xsl:when test="count($cellNodes) = 1">
                                <xsl:call-template name="create-table-cell">
                                    <xsl:with-param name="setIndex" select="true()" />
                                    <xsl:with-param name="calculatedCellPosition" select="$nextMatchedCellPosition - 1" />
                                    <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition" />
                                    <xsl:with-param name="columnNodes"            select="$columnNodes" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="$cellNodes[2]">
                                    <xsl:with-param name="calculatedCellPosition" select="$nextMatchedCellPosition" />
                                    <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition" />
                                    <xsl:with-param name="setIndex" select="true()" />
                                    <xsl:with-param name="cellNodes" select="$cellNodes[position() != 1]" />
                                    <xsl:with-param name="columnNodes"            select="$columnNodes" />
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- Fastest cell repetition by creating cell once and copying, works not for
                            a) cells with formula (need of actual cell position)
                            b) cells, which start with ss:Index (as ss:Index is not allowed to be repeated) -->
                    <xsl:when test="not(@table:formula) and not($setIndex)">
                        <!-- In case a non-empty cell is being repeated, the cell will be created
                            in a variable, which is as many times given out, as being repeated -->
                        <xsl:variable name="tableCell">
                            <xsl:call-template name="create-table-cell">
                                <xsl:with-param name="setIndex" select="false()" /><!-- copied cells may not have indices -->
                                <xsl:with-param name="columnNodes" select="$columnNodes" />
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:call-template name="repeat-copy-table-cell">
                            <xsl:with-param name="tableCell"   select="$tableCell" />
                            <xsl:with-param name="repetition"  select="$repetition" />
                            <xsl:with-param name="columnNodes" select="$columnNodes" />
                       </xsl:call-template>
                        <xsl:apply-templates select="$cellNodes[2]">
                            <xsl:with-param name="calculatedCellPosition" select="$nextMatchedCellPosition" />
                            <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition" />
                            <xsl:with-param name="cellNodes" select="$cellNodes[position() != 1]" />
                            <xsl:with-param name="columnNodes" select="$columnNodes" />
                        </xsl:apply-templates>
                    </xsl:when>
                    <!-- explicit writing (instead of copying) of cell for the cases mentioned above -->
                    <xsl:otherwise>
                        <xsl:call-template name="create-table-cell">
                            <xsl:with-param name="setIndex" select="$setIndex" /><!-- a possible Index will be created -->
                            <xsl:with-param name="calculatedCellPosition" select="$repetitionCellPosition" />
                            <xsl:with-param name="calculatedRowPosition" select="$calculatedRowPosition" />
                            <xsl:with-param name="columnNodes" select="$columnNodes" />
                        </xsl:call-template>
                        <xsl:choose>
                            <!-- as long there is a repetition (higher '1') stay on the same cell node  -->
                            <xsl:when test="$repetition &gt; 1">
                                <xsl:call-template name="table:table-cell">
                                    <xsl:with-param name="calculatedCellPosition" select="$nextMatchedCellPosition" />
                                    <xsl:with-param name="calculatedRowPosition" select="$calculatedRowPosition" />
                                    <xsl:with-param name="repetitionCellPosition">
                                        <xsl:choose>
                                            <xsl:when test="@table:number-columns-spanned">
                                                <xsl:value-of select="$repetitionCellPosition + @table:number-columns-spanned" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$repetitionCellPosition + 1"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                    <xsl:with-param name="nextMatchedCellPosition" select="$nextMatchedCellPosition" />
                                    <xsl:with-param name="repetition" select="$repetition - 1" />
                                    <xsl:with-param name="cellNodes" select="$cellNodes" />
                                    <xsl:with-param name="columnNodes" select="$columnNodes" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="$cellNodes[2]">
                                    <xsl:with-param name="calculatedCellPosition" select="$nextMatchedCellPosition" />
                                    <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition" />
                                    <xsl:with-param name="cellNodes" select="$cellNodes[position() != 1]" />
                                    <xsl:with-param name="columnNodes" select="$columnNodes" />
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- in case no repetition took place -->
                <xsl:choose>
                    <!-- neglect an empty cell by using ss:Index Attribute  -->
                    <xsl:when test="not(text()) and not(*) and not(@*)">
                        <xsl:choose>
                            <!-- if it is the last cell, write this cell -->
                            <xsl:when test="count($cellNodes) = 1">
                                <xsl:call-template name="create-table-cell">
                                    <xsl:with-param name="setIndex" select="true()" />
                                    <xsl:with-param name="calculatedCellPosition" select="$nextMatchedCellPosition - 1" />
                                    <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition" />
                                    <xsl:with-param name="columnNodes" select="$columnNodes" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="$cellNodes[2]">
                                    <xsl:with-param name="setIndex" select="true()" />
                                    <xsl:with-param name="calculatedCellPosition" select="$nextMatchedCellPosition" />
                                    <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition" />
                                    <xsl:with-param name="cellNodes" select="$cellNodes[position() != 1]" />
                                    <xsl:with-param name="columnNodes" select="$columnNodes" />
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- create cell and use/unset the ss:Index -->
                        <xsl:call-template name="create-table-cell">
                            <xsl:with-param name="setIndex" select="$setIndex" />
                            <xsl:with-param name="calculatedCellPosition" select="$calculatedCellPosition" />
                            <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition" />
                            <xsl:with-param name="columnNodes" select="$columnNodes" />
                        </xsl:call-template>
                        <xsl:apply-templates select="$cellNodes[2]">
                            <xsl:with-param name="calculatedCellPosition" select="$nextMatchedCellPosition" />
                            <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition" />
                            <xsl:with-param name="cellNodes" select="$cellNodes[position() != 1]" />
                            <xsl:with-param name="columnNodes" select="$columnNodes" />
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Copies the variable 'tableCell' to the output as often as 'repetition' -->
    <xsl:template name="repeat-copy-table-cell">
        <xsl:param name="tableCell" />
        <xsl:param name="repetition" />

        <xsl:if test="$repetition &gt; 0">
            <xsl:copy-of select="$tableCell"/>
            <xsl:call-template name="repeat-copy-table-cell">
                <xsl:with-param name="tableCell"   select="$tableCell" />
                <xsl:with-param name="repetition"  select="$repetition - 1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="create-table-cell">
        <xsl:param name="setIndex" select="false()" />
        <xsl:param name="calculatedCellPosition" />
        <xsl:param name="calculatedRowPosition" />
        <xsl:param name="columnNodes"  />

        <xsl:element name="Cell" namespace="urn:schemas-microsoft-com:office:spreadsheet">
            <xsl:if test="$setIndex">
                <xsl:attribute name="ss:Index">
                    <xsl:value-of select="$calculatedCellPosition"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@table:number-columns-spanned &gt; 1">
                <xsl:attribute name="ss:MergeAcross">
                    <xsl:value-of select="@table:number-columns-spanned - 1" />
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@table:number-rows-spanned &gt; 1">
                <xsl:attribute name="ss:MergeDown">
                    <xsl:value-of select="@table:number-rows-spanned - 1" />
                </xsl:attribute>
            </xsl:if>
            <xsl:variable name="link" select="descendant::text:a/@xlink:href" />
            <xsl:if test="$link">
                <xsl:attribute name="ss:HRef">
                    <xsl:value-of select="$link" />
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@table:style-name">
                    <xsl:apply-templates select="@table:style-name" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$firstDefaultCellStyle != ''">
                        <xsl:variable name="defaultCellStyle" select="$columnNodes/table:table-column[position() = $calculatedCellPosition]/@table:default-cell-style-name" />
                        <xsl:if test="$defaultCellStyle">
                            <xsl:if test="not($defaultCellStyle = 'Default')">
                                    <xsl:attribute name="ss:StyleID"><xsl:value-of select="$defaultCellStyle"/></xsl:attribute>
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="@table:formula">
                <xsl:with-param name="calculatedCellPosition" select="$calculatedCellPosition" />
                <xsl:with-param name="calculatedRowPosition"  select="$calculatedRowPosition" />
            </xsl:apply-templates>
            <xsl:choose>
                <xsl:when test="*">
                <!-- in case it is not an empty cell

                  As the sequence of comment and data is opposite in Excel and Calc no match work here, in both comments exist only once
                  Possible Table Content of interest: text:h|text:p|text:list  -->
                    <xsl:if test="text:h | text:p | text:list">
                        <xsl:variable name="valueType">
                            <xsl:choose>
                                <xsl:when test="@office:value-type">
                                    <xsl:value-of select="@office:value-type" />
                                </xsl:when>
                                <xsl:otherwise>string</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:call-template name="ss:Data">
                            <xsl:with-param name="valueType" select="$valueType" />
                            <xsl:with-param name="cellStyleName" select="@table:style-name" />
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="office:annotation">
                        <xsl:element name="Comment">
                            <xsl:if test="office:annotation/@office:author">
                                <xsl:attribute name="ss:Author"><xsl:value-of select="office:annotation/@office:author" /></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="office:annotation/@office:display = 'true'">
                                <xsl:attribute name="ss:ShowAlways">1</xsl:attribute>
                            </xsl:if>
                            <!-- ss:Data is obligatory, but not the same as the ss:Cell ss:Data child, as it has no attributes  -->
                            <ss:Data xmlns="http://www.w3.org/TR/REC-html40">
                                <xsl:for-each select="office:annotation/text:p">
                                    <xsl:choose>
                                        <xsl:when test="*">
                                            <!-- paragraph style have to be neglected due to Excel error,
                                                which does not allow shadowing their HTML attributes -->
                                            <xsl:for-each select="*">
                                                <xsl:call-template name="style-and-contents" />
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:when test="@text:style-name">
                                            <xsl:call-template name="style-and-contents" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- if no style is set, BOLD is set as default -->
                                            <B>
                                                <xsl:call-template name="style-and-contents" />
                                            </B>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </ss:Data>
                        </xsl:element>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <!-- comments are handled separately in the cell -->
    <xsl:template match="office:annotation" />
    <xsl:template match="dc:date" />

    <xsl:template name="ss:Data">
        <!-- the default value is 'String' in the office -->
        <xsl:param name="valueType" select="'string'" />
        <xsl:param name="cellStyleName" />

        <xsl:choose>
            <xsl:when test="descendant::*/@text:style-name">
                <xsl:choose>
                    <xsl:when test="$valueType = 'string'">
                        <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40">
                            <xsl:apply-templates>
                                <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                            </xsl:apply-templates>
                        </ss:Data>
                    </xsl:when>
                    <xsl:when test="$valueType = 'boolean'">
                        <ss:Data ss:Type="Boolean" xmlns="http://www.w3.org/TR/REC-html40">
                            <xsl:apply-templates>
                                <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                            </xsl:apply-templates>
                        </ss:Data>
                    </xsl:when>
                    <xsl:when test="$valueType = 'date'">
                        <ss:Data ss:Type="DateTime" xmlns="http://www.w3.org/TR/REC-html40">
                            <xsl:apply-templates>
                                <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                            </xsl:apply-templates>
                        </ss:Data>
                    </xsl:when>
                    <!-- float, time, percentage, currency (no 'Error' setting) -->
                    <xsl:otherwise>
                        <ss:Data ss:Type="Number" xmlns="http://www.w3.org/TR/REC-html40">
                            <xsl:apply-templates>
                                <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                            </xsl:apply-templates>
                        </ss:Data>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="Data">
                    <xsl:call-template name="ss:Type">
                        <xsl:with-param name="valueType" select="$valueType" />
                    </xsl:call-template>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="ss:Type">
        <xsl:param name="valueType" select="'string'" />

        <xsl:choose>
            <xsl:when test="$valueType = 'string'">
                <xsl:attribute name="ss:Type">String</xsl:attribute>
                <xsl:apply-templates select="*"/>
            </xsl:when>
            <xsl:when test="$valueType = 'boolean'">
                <xsl:attribute name="ss:Type">Boolean</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="@office:boolean-value = 'true'">1</xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$valueType = 'date' or $valueType = 'time'">
                <!-- issue in Excel: can not have an empty 'DateTime' cell -->
                <xsl:attribute name="ss:Type">DateTime</xsl:attribute>
                <!-- Gathering information of two StarOffice date/time attributes
                Excel always needs both pieces of information in one attribute -->
                <xsl:choose>
                    <xsl:when test="@office:date-value">
                    <!-- office:date-value may contain time (after 'T')-->
                        <xsl:choose>
                            <xsl:when test="contains(@office:date-value, 'T')">
                                <!-- in case time is also part of the date -->
                                <xsl:value-of select="substring-before(@office:date-value, 'T')" />
                                <xsl:text>T</xsl:text>
                                <xsl:value-of select="substring-after(@office:date-value,'T')" />
                               <xsl:if test="not(contains(@office:date-value,'.'))">
                                    <xsl:text>.</xsl:text>
                                </xsl:if>
                                <xsl:text>000</xsl:text>
                            </xsl:when>
                            <xsl:when test="@office:time-value">
                            <!-- contains date and time (time will be evaluated later -->
                                <xsl:value-of select="@office:date-value" />
                                <xsl:text>T</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="@table:formula or contains(@office:time-value,',')">
                                        <!-- customized number types not implemented yet -->
                                        <xsl:text>00:00:00.000</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="translate(substring-after(@office:time-value,'PT'),'HMS','::.')" />
                                        <xsl:if test="not(contains(@office:time-value,'S'))">
                                            <xsl:text>.</xsl:text>
                                        </xsl:if>
                                        <xsl:text>000</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@office:date-value" />
                                <xsl:text>T00:00:00.000</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="@office:time-value">
                            <xsl:text>1899-12-31T</xsl:text>
                            <xsl:choose>
                                <xsl:when test="@table:formula or contains(@office:time-value,',')">
                                    <!-- customized number types not implemented yet -->
                                    <xsl:text>00:00:00.000</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="translate(substring-after(@office:time-value,'PT'),'HMS','::.')" />
                                   <xsl:if test="not(contains(@office:time-value,'S'))">
                                        <xsl:text>.</xsl:text>
                                    </xsl:if>
                                    <xsl:text>000</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- float, percentage, currency (no 'Error' setting) -->
            <xsl:otherwise>
                <xsl:attribute name="ss:Type">Number</xsl:attribute>
                <xsl:value-of select="@office:value" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- ******************** -->
    <!-- *** Common Rules *** -->
    <!-- ******************** -->

    <xsl:template match="*">
        <xsl:param name="cellStyleName" />

<!--    LineBreak in Cell -->
        <xsl:if test="preceding-sibling::text:p[1]"><xsl:text>&#10;</xsl:text></xsl:if>
        <xsl:call-template name="style-and-contents">
            <xsl:with-param name="cellStyleName" select="$cellStyleName" />
        </xsl:call-template>
    </xsl:template>

    <!-- disabling draw:frames -->
    <xsl:template match="draw:frame" />

    <xsl:template match="text:s">
        <xsl:call-template name="write-breakable-whitespace">
            <xsl:with-param name="whitespaces" select="@text:c" />
        </xsl:call-template>
    </xsl:template>

    <!--write the number of 'whitespaces' -->
    <xsl:template name="write-breakable-whitespace">
        <xsl:param name="whitespaces" />

        <xsl:text> </xsl:text>
        <xsl:if test="$whitespaces >= 1">
            <xsl:call-template name="write-breakable-whitespace">
                <xsl:with-param name="whitespaces" select="$whitespaces - 1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- allowing all matched text nodes -->
    <xsl:template match="text()"><xsl:value-of select="." /></xsl:template>

</xsl:stylesheet>

