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
    exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xforms xlink xsd xsi">


    <xsl:param name="rowElement" select="'tr'" />

    <!-- ********************************** -->
    <!-- *** write repeating table rows *** -->
    <!-- ********************************** -->

    <!-- current node is a table:table -->
    <xsl:template name="create-table-rows">
        <xsl:param name="globalData" />
        <xsl:param name="allVisibleTableRows" />
        <xsl:param name="allTableColumns" />

        <!-- Some Office Calc documents simulate a background by repeating one of the later cells until end of used space
             (The value of "table:number-columns-repeated" is enormous). Writing out all these cells would be fatal in time
             and output size. Therefore, this global variable shows us the longest row with content. -->
        <xsl:variable name="maxRowLength" select="count($allTableColumns/table:table-column)" />
        <xsl:if test="$debugEnabled">
            <xsl:message>maxRowLength: <xsl:value-of select="$maxRowLength" /></xsl:message>
            <xsl:call-template name="table-debug-allTableColumns">
                <xsl:with-param name="allTableColumns" select="$allTableColumns" />
            </xsl:call-template>
        </xsl:if>

        <!-- a table is a table header, when it has a "table:table-header-rows" ancestor -->
        <xsl:variable name="tableDataType">
            <xsl:choose>
                <xsl:when test="ancestor::table:table-header-rows">
                    <xsl:text>th</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>td</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- removes repetition of rows, most probably done for background emulating -->
        <xsl:for-each select="$allVisibleTableRows">
            <xsl:choose>
                <xsl:when test="(last() or (last() - 1)) and @table:number-rows-repeated &gt; 99">
                    <xsl:call-template name="repeat-write-row">
                        <xsl:with-param name="globalData"           select="$globalData" />
                        <xsl:with-param name="allTableColumns"      select="$allTableColumns" />
                        <xsl:with-param name="numberRowsRepeated"   select="1" />
                        <xsl:with-param name="maxRowLength"         select="$maxRowLength" />
                        <xsl:with-param name="tableDataType"        select="$tableDataType" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="repeat-write-row">
                        <xsl:with-param name="globalData"           select="$globalData" />
                        <xsl:with-param name="allTableColumns"      select="$allTableColumns" />
                        <xsl:with-param name="numberRowsRepeated"   select="@table:number-rows-repeated" />
                        <xsl:with-param name="maxRowLength"         select="$maxRowLength" />
                        <xsl:with-param name="tableDataType"        select="$tableDataType" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="repeat-write-row">
        <xsl:param name="globalData" />
        <xsl:param name="allTableColumns" />
        <xsl:param name="numberRowsRepeated" select="1" />
        <xsl:param name="maxRowLength" />
        <xsl:param name="tableDataType" />

        <xsl:choose>
            <!-- write an entry of a row and repeat calling this method until all elements are written out -->
            <xsl:when test="$numberRowsRepeated > 1 and table:table-cell">
                <xsl:call-template name="write-row">
                    <xsl:with-param name="globalData"       select="$globalData" />
                    <xsl:with-param name="allTableColumns"  select="$allTableColumns" />
                    <xsl:with-param name="maxRowLength"     select="$maxRowLength" />
                    <xsl:with-param name="tableDataType"    select="$tableDataType" />
                </xsl:call-template>

                <!-- NOTE: take variable from the output of repeated write-row and iterate giving out the variable -->
                <xsl:call-template name="repeat-write-row">
                    <xsl:with-param name="globalData"           select="$globalData" />
                    <xsl:with-param name="allTableColumns"      select="$allTableColumns" />
                    <xsl:with-param name="maxRowLength"         select="$maxRowLength" />
                    <xsl:with-param name="numberRowsRepeated"   select="$numberRowsRepeated - 1" />
                    <xsl:with-param name="tableDataType"        select="$tableDataType" />
                </xsl:call-template>
            </xsl:when>
            <!-- write a single entry of a row -->
            <xsl:otherwise>
                <xsl:call-template name="write-row">
                    <xsl:with-param name="globalData"           select="$globalData" />
                    <xsl:with-param name="allTableColumns"      select="$allTableColumns" />
                    <xsl:with-param name="maxRowLength"         select="$maxRowLength" />
                    <xsl:with-param name="tableDataType"        select="$tableDataType" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="add-table-row-attributes">
        <xsl:param name="globalData" />

        <!-- writing the style of the row -->
        <xsl:if test="@table:style-name">
            <xsl:call-template name='add-style-properties'>
                <xsl:with-param name="globalData" select="$globalData" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="write-row">
        <xsl:param name="globalData" />
        <xsl:param name="allTableColumns" />
        <xsl:param name="maxRowLength" />
        <xsl:param name="tableDataType" />


        <xsl:element namespace="{$namespace}" name="{$rowElement}">
            <xsl:call-template name='add-table-row-attributes'>
                <xsl:with-param name="globalData" select="$globalData" />
            </xsl:call-template>

            <xsl:if test="$debugEnabled">
                <xsl:message>'tr' element has been added!</xsl:message>
            </xsl:if>

            <xsl:apply-templates select="table:table-cell">
                <xsl:with-param name="globalData"       select="$globalData" />
                <xsl:with-param name="allTableColumns"  select="$allTableColumns" />
                <xsl:with-param name="maxRowLength"     select="$maxRowLength" />
                <xsl:with-param name="tableDataType"    select="$tableDataType" />
            </xsl:apply-templates>

        </xsl:element>
    </xsl:template>


    <!-- **************************** -->
    <!-- *** HELPER: table styles *** -->
    <!-- **************************** -->

    <xsl:template name="add-style-properties">
        <xsl:param name="globalData" />
        <xsl:param name="allTableColumns" />
        <xsl:param name="node-position" />

        <xsl:attribute name="class">
            <xsl:value-of select="translate(@table:style-name, '. %()/\+', '')" />
        </xsl:attribute>
    </xsl:template>

</xsl:stylesheet>
