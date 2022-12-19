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
    <xsl:key name="table-style" match="style:style[@style:family='table']" use="@style:name"/>
    <xsl:key name="table-column-style" match="style:style[@style:family='table-column']" use="@style:name"/>
    <xsl:key name="table-row-style" match="style:style[@style:family='table-row']" use="@style:name"/>
    <xsl:key name="table-cell-style" match="style:style[@style:family='table-cell']" use="@style:name"/>
    <xsl:template match="style:table-properties" mode="table">
        <xsl:param name="within-body"/>
        <xsl:if test="$within-body = 'yes'">
            <w:tblW>
                <xsl:choose>
                    <xsl:when test="@style:rel-width">
                        <xsl:attribute name="w:w"><xsl:value-of select="substring-before(@style:rel-width, '%') * 50"/></xsl:attribute>
                        <xsl:attribute name="w:type">pct</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="@style:width">
                        <xsl:attribute name="w:w"><xsl:call-template name="convert2twip"><xsl:with-param name="value" select="@style:width"/></xsl:call-template></xsl:attribute>
                        <xsl:attribute name="w:type">dxa</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="w:w">0</xsl:attribute>
                        <xsl:attribute name="w:type">auto</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </w:tblW>
        </xsl:if>
        <w:tblInd>
            <xsl:choose>
                <xsl:when test="@fo:margin-left">
                    <xsl:attribute name="w:w"><xsl:call-template name="convert2twip"><xsl:with-param name="value" select="@fo:margin-left"/></xsl:call-template></xsl:attribute>
                    <xsl:attribute name="w:type">dxa</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="w:w">0</xsl:attribute>
                    <xsl:attribute name="w:type">auto</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </w:tblInd>
        <xsl:if test="@table:align">
            <w:jc>
                <xsl:choose>
                    <xsl:when test="@table:align = 'left' or @table:align= 'center' or @table:align = 'right'">
                        <xsl:attribute name="w:val"><xsl:value-of select="@table:align"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="w:val">left</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </w:jc>
        </xsl:if>
    </xsl:template>
    <xsl:template match="table:table">
        <!--fix for issue i32030 pagebreak before-->
        <xsl:if test="key('table-style', @table:style-name)/style:table-properties/@fo:break-before">
            <xsl:variable name="table-break-before" select="key('table-style', @table:style-name)/style:table-properties/@fo:break-before"/>
            <xsl:choose>
                <xsl:when test="$table-break-before = 'page' ">
                    <w:p>
                        <w:r>
                            <w:br w:type="page"/>
                        </w:r>
                    </w:p>
                </xsl:when>
                <xsl:when test="$table-break-before = 'column' ">
                    <w:p>
                        <w:r>
                            <w:br w:type="column"/>
                        </w:r>
                    </w:p>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <w:tbl>
            <w:tblPr>
                <xsl:if test="not (@table:is-sub-table) or (@table:is-sub-table = 'false' )">
                    <w:tblStyle w:val="{@table:style-name}"/>
                    <xsl:apply-templates select="key('table-style', @table:style-name)/style:table-properties" mode="table">
                        <xsl:with-param name="within-body" select="'yes'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="@table:is-sub-table ='true' ">
                    <w:tblW w:type="dxa">
                        <xsl:variable name="sub-table-width">
                            <xsl:call-template name="calculate-sub-table-width">
                                <xsl:with-param name="sub-table-column-node" select="table:table-column[1]"/>
                                <xsl:with-param name="total-sub-table-width" select="0"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="w:w"><xsl:value-of select="$sub-table-width"/></xsl:attribute>
                    </w:tblW>
                    <!--w:tblLayout w:type="Fixed"/-->
                </xsl:if>
            </w:tblPr>
            <w:tblGrid>
                <xsl:apply-templates select="table:table-column"/>
            </w:tblGrid>
            <xsl:apply-templates select="table:table-header-rows/table:table-row | table:table-row"/>
        </w:tbl>
        <!--fix for issue i32030 pagebreak after-->
        <xsl:if test="key('table-style', @table:style-name)/style:table-properties/@fo:break-after">
            <xsl:variable name="table-break-after" select="   key('table-style', @table:style-name)/style:table-properties/@fo:break-after"/>
            <xsl:choose>
                <xsl:when test="$table-break-after = 'page' ">
                    <w:p>
                        <w:r>
                            <w:br w:type="page"/>
                        </w:r>
                    </w:p>
                </xsl:when>
                <xsl:when test="$table-break-after = 'column' ">
                    <w:p>
                        <w:r>
                            <w:br w:type="column"/>
                        </w:r>
                    </w:p>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="name(..)= 'table:table-cell' ">
            <w:p/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="calculate-sub-table-width">
        <xsl:param name="sub-table-column-node"/>
        <xsl:param name="total-sub-table-width"/>
        <xsl:variable name="column-width" select="key('table-column-style', $sub-table-column-node/@table:style-name)/style:table-column-properties/@style:column-width"/>
        <xsl:variable name="column-width-in-twip">
            <xsl:call-template name="convert2twip">
                <xsl:with-param name="value" select="$column-width"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$sub-table-column-node/following-sibling::table:table-column">
                <xsl:choose>
                    <xsl:when test="$sub-table-column-node/@table:number-columns-repeated">
                        <xsl:call-template name="calculate-sub-table-width">
                            <xsl:with-param name="sub-table-column-node" select="$sub-table-column-node/following-sibling::table:table-column[ 1]"/>
                            <xsl:with-param name="total-sub-table-width" select="$total-sub-table-width + $column-width-in-twip *  $sub-table-column-node/@table:number-columns-repeated"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="calculate-sub-table-width">
                            <xsl:with-param name="sub-table-column-node" select="$sub-table-column-node/following-sibling::table:table-column[1]"/>
                            <xsl:with-param name="total-sub-table-width" select="$total-sub-table-width + $column-width-in-twip "/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$sub-table-column-node/@table:number-columns-repeated">
                        <xsl:value-of select="$total-sub-table-width + $column-width-in-twip *  $sub-table-column-node/@table:number-columns-repeated"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$total-sub-table-width + $column-width-in-twip "/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="table:table-column">
        <xsl:variable name="column-width" select="key('table-column-style', @table:style-name)/style:table-column-properties/@style:column-width"/>
        <xsl:variable name="column-width-in-twip">
            <xsl:call-template name="convert2twip">
                <xsl:with-param name="value" select="$column-width"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <!-- if table:table-column has attribute table:number-columns-repeated, then call the recursion
            temple repeat-gridcol to produce multiple w:gridCol in MS word. Gary.Yang   -->
            <xsl:when test="@table:number-columns-repeated">
                <xsl:call-template name="repeat-gridcol">
                    <xsl:with-param name="grid-repeat-count" select="@table:number-columns-repeated"/>
                    <xsl:with-param name="column-width" select="$column-width-in-twip"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <w:gridCol w:w="{$column-width-in-twip}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--recursion template for produce multiple w:gridCol  Gary.Yang-->
    <xsl:template name="repeat-gridcol">
        <xsl:param name="grid-repeat-count"/>
        <xsl:param name="column-width"/>
        <xsl:if test="$grid-repeat-count &gt; 0">
            <w:gridCol w:w="{$column-width}"/>
            <xsl:call-template name="repeat-gridcol">
                <xsl:with-param name="grid-repeat-count" select="$grid-repeat-count - 1"/>
                <xsl:with-param name="column-width" select="$column-width"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template match="table:table-row">
        <xsl:element name="w:tr">
            <xsl:element name="w:trPr">
                <xsl:if test="parent::table:table-header-rows">
                    <!-- fix for  Issue 32034-->
                    <w:tblHeader>on</w:tblHeader>
                </xsl:if>
                <xsl:variable name="row-height" select="key('table-row-style', @table:style-name)/style:table-row-properties/@style:row-height"/>
                <xsl:if test="$row-height">
                    <w:trHeight>
                        <xsl:attribute name="w:val"><xsl:call-template name="convert2twip"><xsl:with-param name="value" select="$row-height"/></xsl:call-template></xsl:attribute>
                    </w:trHeight>
                </xsl:if>
            </xsl:element>
            <!--end of w:trPr-->
            <xsl:apply-templates select="table:table-cell "/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="table:table-cell ">
        <xsl:element name="w:tc">
            <xsl:element name="w:tcPr">
                <!-- to calculate the table-cell width Gary.Yang -->
                <xsl:choose>
                    <!--when the table-cell contains the sub-table -->
                    <xsl:when test="table:table/@table:is-sub-table= 'true' ">
                        <xsl:variable name="table-cell-width">
                            <xsl:call-template name="calculate-sub-table-width">
                                <xsl:with-param name="sub-table-column-node" select="table:table/table:table-column[1]"/>
                                <xsl:with-param name="total-sub-table-width" select="0"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <w:tcW w:type="dxa">
                            <xsl:attribute name="w:w"><xsl:value-of select="$table-cell-width"/></xsl:attribute>
                        </w:tcW>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- when the table-cell doesn't contain the sub-table -->
                        <xsl:variable name="table-cell-width">
                            <xsl:call-template name="calculate-table-cell-width">
                                <xsl:with-param name="table-cell-position" select="position()"/>
                                <xsl:with-param name="table-column" select="ancestor::table:table[1]/table:table-column[1]"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <w:tcW w:type="dxa">
                            <xsl:attribute name="w:w"><xsl:value-of select="$table-cell-width"/></xsl:attribute>
                        </w:tcW>
                        <!-- for performance issue, we can set w:type to auto that makes the cell width auto fit the content. -->
                        <!--w:tcW w:w="0" w:type="auto"/-->
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="@table:number-columns-spanned">
                    <w:gridSpan w:val="{@table:number-columns-spanned}"/>
                </xsl:if>
                <xsl:variable name="cell-style-properties" select="key('table-cell-style', @table:style-name)/style:table-cell-properties"/>
                <xsl:if test="$cell-style-properties/@fo:background-color">
                    <w:shd w:val="solid" w:color="{substring-after($cell-style-properties/@fo:background-color,'#')}"/>
                </xsl:if>
                <xsl:if test="$cell-style-properties/@fo:vertical-align">
                    <xsl:choose>
                        <xsl:when test="$cell-style-properties/@fo:vertical-align = 'middle'">
                            <w:vAlign w:val="center"/>
                        </xsl:when>
                        <xsl:when test="$cell-style-properties/@fo:vertical-align = 'Automatic'">
                            <w:vAlign w:val="both"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:vAlign w:val="{$cell-style-properties/@fo:vertical-align}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <w:tcMar>
                    <xsl:if test="$cell-style-properties/@fo:padding-top">
                        <w:top w:type="dxa">
                            <xsl:attribute name="w:w"><xsl:call-template name="convert2twip"><xsl:with-param name="value" select="$cell-style-properties/@fo:padding-top"/></xsl:call-template></xsl:attribute>
                        </w:top>
                    </xsl:if>
                    <xsl:if test="$cell-style-properties/@fo:padding-bottom">
                        <w:bottom w:type="dxa">
                            <xsl:attribute name="w:w"><xsl:call-template name="convert2twip"><xsl:with-param name="value" select="$cell-style-properties/@fo:padding-bottom"/></xsl:call-template></xsl:attribute>
                        </w:bottom>
                    </xsl:if>
                    <xsl:if test="$cell-style-properties/@fo:padding-left">
                        <w:left w:type="dxa">
                            <xsl:attribute name="w:w"><xsl:call-template name="convert2twip"><xsl:with-param name="value" select="$cell-style-properties/@fo:padding-left"/></xsl:call-template></xsl:attribute>
                        </w:left>
                    </xsl:if>
                    <xsl:if test="$cell-style-properties/@fo:padding-right">
                        <w:right w:type="dxa">
                            <xsl:attribute name="w:w"><xsl:call-template name="convert2twip"><xsl:with-param name="value" select="$cell-style-properties/@fo:padding-right"/></xsl:call-template></xsl:attribute>
                        </w:right>
                    </xsl:if>
                </w:tcMar>
                <!-- the following code is to get the cell borders if they exist -->
                <xsl:variable name="border-top" select="$cell-style-properties/@fo:border-top | $cell-style-properties/@fo:border"/>
                <xsl:variable name="border-bottom" select="$cell-style-properties/@fo:border-bottom | $cell-style-properties/@fo:border"/>
                <xsl:variable name="border-left" select="$cell-style-properties/@fo:border-left | $cell-style-properties/@fo:border"/>
                <xsl:variable name="border-right" select="$cell-style-properties/@fo:border-right | $cell-style-properties/@fo:border"/>
                <xsl:variable name="border-line-width-top" select="$cell-style-properties/@style:border-line-width-top | $cell-style-properties/@style:border-line-width "/>
                <xsl:variable name="border-line-width-bottom" select="$cell-style-properties/@style:border-line-width-bottom | $cell-style-properties/@style:border-line-width"/>
                <xsl:variable name="border-line-width-left" select="$cell-style-properties/@style:border-line-width-left | $cell-style-properties/@style:border-line-width"/>
                <xsl:variable name="border-line-width-right" select="$cell-style-properties/@style:border-line-width-right | $cell-style-properties/@style:border-line-width"/>
                <xsl:element name="w:tcBorders">
                    <xsl:if test="$border-top">
                        <xsl:element name="w:top">
                            <xsl:call-template name="get-border">
                                <xsl:with-param name="so-border" select="$border-top"/>
                                <xsl:with-param name="so-border-line-width" select="$border-line-width-top"/>
                                <xsl:with-param name="so-border-position" select=" 'top' "/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$border-bottom">
                        <xsl:element name="w:bottom">
                            <xsl:call-template name="get-border">
                                <xsl:with-param name="so-border" select="$border-bottom"/>
                                <xsl:with-param name="so-border-line-width" select="$border-line-width-bottom"/>
                                <xsl:with-param name="so-border-position" select=" 'bottom' "/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$border-left">
                        <xsl:element name="w:left">
                            <xsl:call-template name="get-border">
                                <xsl:with-param name="so-border" select="$border-left"/>
                                <xsl:with-param name="so-border-line-width" select="$border-line-width-left"/>
                                <xsl:with-param name="so-border-position" select=" 'left' "/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$border-right">
                        <xsl:element name="w:right">
                            <xsl:call-template name="get-border">
                                <xsl:with-param name="so-border" select="$border-right"/>
                                <xsl:with-param name="so-border-line-width" select="$border-line-width-right"/>
                                <xsl:with-param name="so-border-position" select=" 'right' "/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:element>
            <xsl:if test="not (*) ">
                <w:p/>
            </xsl:if>
            <xsl:apply-templates select=" text:p | table:table | text:h | office:annotation"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="calculate-table-cell-width">
        <xsl:param name="table-cell-position"/>
        <xsl:param name="table-column"/>
        <xsl:choose>
            <xsl:when test="$table-column/@table:number-columns-repeated">
                <xsl:choose>
                    <xsl:when test="($table-cell-position - $table-column/@table:number-columns-repeated) &lt;= 0">
                        <xsl:variable name="table-cell-width" select="key('table-column-style', $table-column/@table:style-name)/style:table-column-properties/@style:column-width"/>
                        <xsl:variable name="table-cell-width-in-twip">
                            <xsl:call-template name="convert2twip">
                                <xsl:with-param name="value" select="$table-cell-width"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$table-cell-width-in-twip"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="calculate-table-cell-width">
                            <xsl:with-param name="table-cell-position" select="$table-cell-position - $table-column/@table:number-columns-repeated"/>
                            <xsl:with-param name="table-column" select="$table-column/following-sibling::table:table-column[1]"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- if the $table-column doesn't contain the table:number-columns-repeated attribute -->
                <xsl:choose>
                    <xsl:when test="($table-cell-position - 1) = 0">
                        <xsl:variable name="table-cell-width" select="key('table-column-style', $table-column/@table:style-name)/style:table-column-properties/@style:column-width"/>
                        <xsl:variable name="table-cell-width-in-twip">
                            <xsl:call-template name="convert2twip">
                                <xsl:with-param name="value" select="$table-cell-width"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$table-cell-width-in-twip"/>
                    </xsl:when>
                    <xsl:when test="($table-cell-position - 1) &gt; 0">
                        <xsl:call-template name="calculate-table-cell-width">
                            <xsl:with-param name="table-cell-position" select=" $table-cell-position - 1 "/>
                            <xsl:with-param name="table-column" select="$table-column/following-sibling::table:table-column[1]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:value-of select=" 'calculate table cell width wrong ' "/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
