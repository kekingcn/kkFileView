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


    <!-- table row handling -->
    <xsl:include href="table_rows.xsl" />
    <!-- table column handling -->
    <xsl:include href="table_columns.xsl" />
    <!-- table cell handling -->
    <xsl:include href="table_cells.xsl" />

    <xsl:param name="tableElement" select="'table'" />

    <!-- ******************* -->
    <!-- *** main table  *** -->
    <!-- ******************* -->


    <xsl:template match="table:table" name="table:table">
        <xsl:param name="globalData" />

        <!-- The table will only be created if the table:scenario is active -->
        <xsl:if test="not(table:scenario) or table:scenario/@table:is-active">
            <xsl:call-template name="create-table">
                <xsl:with-param name="globalData" select="$globalData" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>



    <xsl:template name="create-table">
        <xsl:param name="globalData" />

        <!-- by default '1', for each new sub/inner/nested table the number counts one up -->
        <xsl:variable name="tableLevel" select="count(ancestor-or-self::table:table)" />
        <!-- collecting all visible "table:table-row" elements of the table -->
        <xsl:variable name="allVisibleTableRows" select="table:table-row[not(@table:visibility = 'collapse' or @table:visibility = 'filter')][count(ancestor-or-self::table:table) = $tableLevel] |
                                                         table:table-header-rows/descendant::table:table-row[not(@table:visibility = 'collapse' or @table:visibility = 'filter')][count(ancestor-or-self::table:table) = $tableLevel] |
                                                         table:table-row-group/descendant::table:table-row[not(@table:visibility = 'collapse' or @table:visibility = 'filter')][count(ancestor-or-self::table:table) = $tableLevel]" />
        <!-- As the alignment of a table is by 'align' attribute is deprecated and as the CSS 'float' attribute not well displayed,
             we do a trick by encapsulating the table with an aligned 'div' element-->
        <xsl:variable name="table-alignment" select="key('styles', @style:name = current()/@table:style-name)/*/@table:align" />
        <xsl:choose>
            <xsl:when test="string-length($table-alignment) != 0">
                <xsl:element namespace="{$namespace}" name="div">
                    <xsl:attribute name="style">
                        <xsl:choose>
                            <xsl:when test='$table-alignment="left" or $table-alignment="margins"'>
                                <xsl:text>text-align:left</xsl:text>
                            </xsl:when>
                            <xsl:when test='$table-alignment="right"'>
                                <xsl:text>text-align:right</xsl:text>
                            </xsl:when>
                            <xsl:when test='$table-alignment="center"'>
                                <xsl:text>text-align:center</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:call-template name="create-table-element">
                        <xsl:with-param name="globalData" select="$globalData" />
                        <xsl:with-param name="allVisibleTableRows" select="$allVisibleTableRows" />
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="create-table-element">
                    <xsl:with-param name="globalData" select="$globalData" />
                    <xsl:with-param name="allVisibleTableRows" select="$allVisibleTableRows" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="create-table-element">
        <xsl:param name="globalData" />
        <xsl:param name="allVisibleTableRows" />

        <xsl:element namespace="{$namespace}" name="{$tableElement}">
            <xsl:attribute name="border">0</xsl:attribute>
            <xsl:attribute name="cellspacing">0</xsl:attribute>
            <xsl:attribute name="cellpadding">0</xsl:attribute>
            <xsl:choose>
                <xsl:when test='name()="table:table"'>
                    <xsl:variable name="value" select="$globalData/all-doc-styles/style[@style:name = current()/@table:style-name]/*/@style:rel-width" />
                    <xsl:if test="$value">
                        <xsl:attribute name="width">
                            <xsl:value-of select="$value" />
                        </xsl:attribute>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="width">100%</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates select="@table:style-name">
                <xsl:with-param name="globalData" select="$globalData" />
            </xsl:apply-templates>

            <xsl:call-template name="create-column-style-variable">
                <xsl:with-param name="globalData" select="$globalData" />
                <xsl:with-param name="allVisibleTableRows" select="$allVisibleTableRows" />
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
