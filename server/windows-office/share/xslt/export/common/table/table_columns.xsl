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

    <xsl:param name="tableColumnElement"            select="'col'" />

    <!-- ******************************************** -->
    <!-- *** Create table columns style variable  *** -->
    <!-- ******************************************** -->

    <!-- current node is a table:table -->
    <xsl:template name="create-column-style-variable">
        <xsl:param name="globalData" />
        <xsl:param name="allVisibleTableRows" />

        <!-- all columns of the table -->
        <xsl:variable name="allTableColumns" select="table:table-column |
                                                     table:table-column-group/descendant::table:table-column |
                                                     table:table-header-columns/descendant::table:table-column" />
        <!-- allTableColumns: Containing all columns of the table, hidden and viewed.
            - if a column is hidden, if table:visibility has the value 'collapse' or 'filter', otherwise the value is 'visible'
            - if a column is being repeated, each repeated column is explicitly written as entry in this variable.
              Later (during template "write-cell") the style of the column will be mixed with the cell-style by using
              the position() of the column entry and comparing it with the iterating cell number. -->
        <xsl:variable name="allTableColumns-RTF">
            <xsl:for-each select="$allTableColumns">
                <xsl:call-template name="adding-column-styles-entries">
                    <xsl:with-param name="globalData"       select="$globalData" />
                    <xsl:with-param name="allTableColumns"  select="$allTableColumns" />
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="function-available('common:node-set')">
                <xsl:call-template name="create-table-children">
                    <xsl:with-param name="globalData"           select="$globalData" />
                    <xsl:with-param name="allVisibleTableRows"  select="$allVisibleTableRows" />
                    <xsl:with-param name="allTableColumns"      select="common:node-set($allTableColumns-RTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xalan:nodeset')">
                <xsl:call-template name="create-table-children">
                    <xsl:with-param name="globalData"           select="$globalData" />
                    <xsl:with-param name="allVisibleTableRows"  select="$allVisibleTableRows" />
                    <xsl:with-param name="allTableColumns"      select="xalan:nodeset($allTableColumns-RTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xt:node-set')">
                <xsl:call-template name="create-table-children">
                    <xsl:with-param name="globalData"           select="$globalData" />
                    <xsl:with-param name="allVisibleTableRows"  select="$allVisibleTableRows" />
                    <xsl:with-param name="allTableColumns"      select="xt:node-set($allTableColumns-RTF)" />
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- current node is a table:table -->
    <xsl:template name="create-table-children">
        <xsl:param name="globalData" />
        <xsl:param name="allVisibleTableRows" />
        <xsl:param name="allTableColumns" />


        <xsl:for-each select="$allTableColumns/table:table-column">
            <xsl:if test="not(@table:visibility = 'collapse' or @table:visibility = 'filter')">

                <xsl:call-template name="create-column-element">
                    <xsl:with-param name="globalData"           select="$globalData" />
                    <xsl:with-param name="allVisibleTableRows"  select="$allVisibleTableRows" />
                    <xsl:with-param name="allTableColumns"      select="$allTableColumns" />
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>

        <xsl:call-template name="create-table-rows">
            <xsl:with-param name="globalData"           select="$globalData" />
            <xsl:with-param name="allVisibleTableRows"  select="$allVisibleTableRows" />
            <xsl:with-param name="allTableColumns"      select="$allTableColumns" />
        </xsl:call-template>
    </xsl:template>

    <!-- To be OVERWRITTEN -->
    <xsl:template name="create-column-element" />

    <!-- current node is a table:table-column -->
    <xsl:template name="adding-column-styles-entries">
        <xsl:param name="globalData" />
        <xsl:param name="allTableColumns" />

        <xsl:choose>
            <!-- if parser reads DTD the default is set to '1' -->
            <xsl:when test="not(@table:number-columns-repeated and @table:number-columns-repeated > 1)">
                <!-- writes an entry of a column in the columns-variable -->
                <xsl:copy-of select="." />
            </xsl:when>
            <!-- No higher repetition of cells greater than 99 for the last and second last column.
                 This is a workaround for some sample document (Waehrungsumrechner.sxc),
                 having 230 repeated columns in the second last column to emulate background -->
            <!-- NOTE: Testcase with a table containing table:table-column-group and/or table:table-header-columns -->
            <xsl:when test="(last() or (last() - 1)) and @table:number-columns-repeated &gt; 99">
                <!-- writes an entry of a column in the columns-variable -->
                <xsl:call-template name="repeat-adding-table-column">
                    <xsl:with-param name="numberColumnsRepeated"    select="1" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- repeated columns will be written explicit several times in the variable-->
                <xsl:call-template name="repeat-adding-table-column">
                    <xsl:with-param name="numberColumnsRepeated"    select="@table:number-columns-repeated" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>


    <!-- WRITES THE REPEATED COLUMN STYLE EXPLICIT AS AN ELEMENT IN THE COLUMNS-VARIABLE -->
    <!-- current node is a table:table-column -->
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


    <!--debugEnabled-START-->
    <!-- giving out the 'allColumnStyle' variable:
        For each 'table:table-column' of the 'allTableColumns' variable the style-name is given out.
        In case of 'column-hidden-flag' attribute the text 'Column is hidden is given out.-->
    <!-- current node is a table:table -->
    <xsl:template name="table-debug-allTableColumns">
        <xsl:param name="allTableColumns" />

        <!-- debug output as table summary attribute in html -->
        <xsl:attribute name="summary">
            <xsl:call-template name="table-debug-column-out">
                <xsl:with-param name="allTableColumns" select="$allTableColumns" />
            </xsl:call-template>
        </xsl:attribute>
        <!-- debug output to console -->
        <xsl:message>
            <xsl:call-template name="table-debug-column-out">
                <xsl:with-param name="allTableColumns" select="$allTableColumns" />
            </xsl:call-template>
        </xsl:message>
    </xsl:template>

    <!-- current node is a table:table -->
    <xsl:template name="table-debug-column-out">
        <xsl:param name="allTableColumns" />
            <xsl:text>
            DebugInformation: For each 'table:table-column' of the 'allTableColumns' variable the style-name is given out.
                              In case of table:visibility attribute unequal 'visible' the 'column is hidden' no text is given out.
            </xsl:text>
            <xsl:for-each select="$allTableColumns/table:table-column">
                <xsl:choose>
                    <xsl:when test="@table:visibility = 'collapse' or @table:visibility = 'filter' ">
                        <xsl:text>  </xsl:text><xsl:value-of select="@table:style-name" /><xsl:text>column is hidden</xsl:text><xsl:text></xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>  </xsl:text><xsl:value-of select="@table:style-name" /><xsl:text> </xsl:text><xsl:value-of select="@table:default-cell-style-name" /><xsl:text></xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
    </xsl:template>
    <!--debugEnabled-END-->

</xsl:stylesheet>
