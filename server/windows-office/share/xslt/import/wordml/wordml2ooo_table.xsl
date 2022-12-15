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
    <xsl:template match="w:style[@w:type='table']" mode="table">
        <style:style style:family="table">
            <xsl:attribute name="style:name">
                <xsl:value-of select="concat('w',translate(@w:styleId,' ~`!@#$%^*(&#x26;)+/,;?&lt;&gt;{}[]:','_'))"/>
            </xsl:attribute>
            <xsl:if test="w:basedOn">
                <xsl:attribute name="style:parent-style-name">
                    <xsl:value-of select="concat('w',translate(w:basedOn/@w:val,' ~`!@#$%^*(&#x26;)+/,;?&lt;&gt;{}[]:','_'))"/>
                </xsl:attribute>
            </xsl:if>
            <style:table-properties table:align="margins"/>
        </style:style>
    </xsl:template>
    <xsl:template match="w:tblPr" mode="style">
    <xsl:variable name="table-number">
       <xsl:number count="w:tbl" from="/w:wordDocument/w:body" level="any" format="1" />
    </xsl:variable>
        <xsl:element name="style:style">
      <xsl:attribute name="style:name">
        <xsl:text>Table</xsl:text>
        <xsl:value-of select="$table-number"/>
            </xsl:attribute>
            <xsl:attribute name="style:family">table</xsl:attribute>
            <xsl:if test="w:tblStyle">
                <xsl:attribute name="style:parent-style-name">
                    <xsl:value-of select="concat('w',translate(w:tblStyle/@w:val,' ~`!@#$%^*(&#x26;)+/,;?&lt;&gt;{}[]:','_'))"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:variable name="section-property-number" select="count(preceding::w:sectPr)"/>
            <xsl:variable name="last-section-property" select="preceding::w:pPr/w:sectPr[1]"/>
            <xsl:variable name="next-section-property" select="following::w:sectPr[1]"/>
            <xsl:variable name="last-next-p-tbl" select="$last-section-property[last()]/following::*[name()='w:p' or name()='w:tbl']"/>
            <xsl:choose>
              <xsl:when test="not($next-section-property/w:type/@w:val = 'continuous') and generate-id($last-next-p-tbl[1]) = generate-id(..) and not(ancestor::w:sectPr or ancestor::w:styles)">
                <xsl:attribute name="style:master-page-name">
                  <xsl:text>Standard</xsl:text>
                  <xsl:value-of select="$section-property-number + 1" />
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="$table-number = 1 and not(preceding::w:p[ancestor::w:body])">
                <xsl:attribute name="style:master-page-name">First_20_Page</xsl:attribute>
              </xsl:when>
            </xsl:choose>
            <xsl:element name="style:table-properties">
                <xsl:choose>
                    <xsl:when test="w:jc/@w:val = 'left' or w:jc/@w:val = 'center' or w:jc/@w:val = 'right'">
                        <xsl:attribute name="table:align">
                            <xsl:value-of select="w:jc/@w:val"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="table:align">margins</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- adopt the width of table and column corresponding the width of page and margins. . -->
                <xsl:variable name="sectPr" select="following::w:sectPr[1]"/>
                <xsl:variable name="total-page-size" select="$sectPr/w:pgSz/@w:w"/>
                <xsl:variable name="page-left-mar" select="$sectPr/w:pgMar/@w:left"/>
                <xsl:variable name="page-right-mar" select="$sectPr/w:pgMar/@w:right"/>
                <xsl:variable name="page-size-value" select="$total-page-size - $page-left-mar - $page-right-mar"/>
                <xsl:variable name="page-size-inch">
                    <xsl:call-template name="ConvertMeasure">
                        <xsl:with-param name="TargetMeasure" select="'in'"/>
                        <xsl:with-param name="value" select="concat($page-size-value, 'twip') "/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="gridcols" select="../w:tblGrid/w:gridCol"/>
                <xsl:variable name="tblsize" select="sum($gridcols/@w:w)"/>
                <xsl:variable name="table_indent">
                    <xsl:choose>
                        <xsl:when test="w:tblInd and  w:tblInd/@w:w &gt; 0 ">
                            <xsl:call-template name="ConvertMeasure">
                                <xsl:with-param name="TargetMeasure" select="'in'"/>
                                <xsl:with-param name="value" select="concat(w:tblInd/@w:w, 'twip') "/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="number( '0') "/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rel-tblsize">
                    <xsl:choose>
                        <xsl:when test="w:tblW/@w:type = 'pct'">
                            <xsl:value-of select="(number(w:tblW/@w:w  ) div 5000) * $page-size-inch"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="ConvertMeasure">
                                <xsl:with-param name="TargetMeasure" select="'in'"/>
                                <xsl:with-param name="value" select="concat($tblsize, 'twip')"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="style:width">
                    <xsl:value-of select="concat($rel-tblsize, 'in' )"/>
                </xsl:attribute>
                <xsl:variable name="tbl_margin_left">
                    <xsl:choose>
                        <xsl:when test="not(w:tblpPr ) ">
                            <xsl:choose>
                                <xsl:when test="w:bidiVisual">
                                    <xsl:choose>
                                        <xsl:when test=" number($page-size-inch - $table_indent - $rel-tblsize) &gt; 0">
                                            <xsl:value-of select="$page-size-inch - $table_indent - $rel-tblsize"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>0</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$table_indent"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="w:tblpPr">
                            <!-- if the table is  put into a draw:text-box,  fo:margin-left and fo:margin-right should be 0 -->
                            <xsl:text>0</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="tbl_margin_right">
                    <xsl:choose>
                        <xsl:when test="not(w:tblpPr ) ">
                            <xsl:choose>
                                <xsl:when test="w:bidiVisual">
                                    <xsl:value-of select="$table_indent"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test=" number($page-size-inch - $table_indent - $rel-tblsize) &gt; 0">
                                            <xsl:value-of select="$page-size-inch - $table_indent - $rel-tblsize"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>0</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="w:tblpPr">
                            <!-- if the table is  put into a draw:text-box,  fo:margin-left and fo:margin-right should be 0 -->
                            <xsl:text>0</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="fo:margin-left">
                    <xsl:value-of select="concat( $tbl_margin_left, 'in')"/>
                </xsl:attribute>
                <xsl:attribute name="fo:margin-right">
                    <xsl:value-of select="concat($tbl_margin_right, 'in')"/>
                </xsl:attribute>
                <!-- If previous w:p has a page break, the table must have the page break attribute applied to it    May need this for tables starting on new pages -->
                <!--    <xsl:if test="parent::w:tbl/preceding-sibling::w:p[1][descendant::w:br/@w:type='page']">
                            <xsl:attribute name="fo:break-before">page</xsl:attribute></xsl:if> -->
                <!-- initial values for tables-->
            </xsl:element>
        </xsl:element>
        <!-- the following style is for converting Word table text wrapping to SO Writer. Since SO Writer has no table text wrapping feature, so we use the draw:text-box as a container and put the table in draw:text-box -->
        <xsl:if test="w:tblpPr">
            <xsl:element name="style:style">
                <xsl:attribute name="style:name">TableFrame<xsl:number count="w:tblpPr" from="/w:wordDocument/w:body" level="any" format="1"/>
                </xsl:attribute>
                <xsl:attribute name="style:family">graphic</xsl:attribute>
                <xsl:attribute name="style:parent-style-name">
                    <xsl:value-of select=" 'Frame' "/>
                </xsl:attribute>
                <xsl:element name="style:graphic-properties">
                    <xsl:if test="w:tblpPr/@w:leftFromText">
                        <xsl:variable name="left_margin_from_text">
                            <xsl:call-template name="ConvertMeasure">
                                <xsl:with-param name="TargetMeasure" select="'in'"/>
                                <xsl:with-param name="value" select="concat (w:tblpPr/@w:leftFromText, 'twip') "/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="fo:margin-left">
                            <xsl:value-of select="concat( $left_margin_from_text, 'in') "/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="w:tblpPr/@w:rightFromText">
                        <xsl:variable name="right_margin_from_text">
                            <xsl:call-template name="ConvertMeasure">
                                <xsl:with-param name="TargetMeasure" select="'in'"/>
                                <xsl:with-param name="value" select="concat (w:tblpPr/@w:rightFromText, 'twip') "/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="fo:margin-right">
                            <xsl:value-of select="concat( $right_margin_from_text, 'in') "/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="w:tblpPr/@w:topFromText">
                        <xsl:variable name="top_margin_from_text">
                            <xsl:call-template name="ConvertMeasure">
                                <xsl:with-param name="TargetMeasure" select="'in'"/>
                                <xsl:with-param name="value" select="concat (w:tblpPr/@w:topFromText, 'twip') "/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="fo:margin-top">
                            <xsl:value-of select="concat( $top_margin_from_text, 'in') "/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="w:tblpPr/@w:bottomFromText">
                        <xsl:variable name="bottom_margin_from_text">
                            <xsl:call-template name="ConvertMeasure">
                                <xsl:with-param name="TargetMeasure" select="'in'"/>
                                <xsl:with-param name="value" select="concat (w:tblpPr/@w:bottomFromText, 'twip') "/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="fo:margin-bottom">
                            <xsl:value-of select="concat( $bottom_margin_from_text, 'in') "/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="style:number-wrapped-paragraphs">
                        <xsl:text>no-limit</xsl:text>
                    </xsl:attribute>
                    <!--xsl:if test="w:tblpPr/@w:tblpYSpec" to get the vertical alignment-->
                    <xsl:variable name="vertical_alignment">
                        <xsl:choose>
                            <xsl:when test="w:tblpPr/@w:tblpYSpec = 'top' ">
                                <xsl:text>top</xsl:text>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:tblpYSpec = 'center' ">
                                <xsl:text>middle</xsl:text>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:tblpYSpec= 'bottom' ">
                                <xsl:text>bottom</xsl:text>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:tblpYSpec = 'inside' ">
                                <xsl:text>from-top</xsl:text>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:tblpYSpec= 'outside' ">
                                <xsl:text>top</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>from-top</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="style:vertical-pos">
                        <xsl:value-of select="$vertical_alignment"/>
                    </xsl:attribute>
                    <!--/xsl:if-->
                    <!--xsl:if test="w:tblpPr/@w:vertAnchor" to get the vertical anchor related area type -->
                    <xsl:variable name="frame_v_anchor">
                        <xsl:choose>
                            <xsl:when test="w:tblpPr/@w:vertAnchor = 'text' ">
                                <xsl:value-of select=" 'paragraph' "/>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:vertAnchor = 'margin' ">
                                <xsl:value-of select=" 'paragraph-content' "/>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:vertAnchor = 'page' ">
                                <xsl:value-of select="w:tblpPr/@w:vertAnchor"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select=" 'page-content' "/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="style:vertical-rel">
                        <xsl:value-of select="$frame_v_anchor"/>
                    </xsl:attribute>
                    <!--/xsl:if-->
                    <!--xsl:if test="w:tblpPr/@w:tblpXSpec" to get the horizontal alignment-->
                    <xsl:variable name="horizental_alignment">
                        <xsl:choose>
                            <xsl:when test="w:tblpPr/@w:tblpXSpec = 'left' ">
                                <xsl:text>left</xsl:text>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:tblpXSpec = 'center' ">
                                <xsl:text>center</xsl:text>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:tblpXSpec = 'right' ">
                                <xsl:text>right</xsl:text>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:tblpXSpec = 'inside' ">
                                <xsl:text>from-left</xsl:text>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:tblpXSpec = 'outside' ">
                                <xsl:text>outside</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>left</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="style:horizontal-pos">
                        <xsl:value-of select="$horizental_alignment"/>
                    </xsl:attribute>
                    <!--/xsl:if-->
                    <!--xsl:if test="w:tblpPr/@w:horzAnchor" to get the horizental anchor related area type-->
                    <xsl:variable name="frame_h_anchor">
                        <xsl:choose>
                            <xsl:when test="w:tblpPr/@w:horzAnchor = 'text' ">
                                <xsl:value-of select=" 'paragraph' "/>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:horzAnchor = 'margin' ">
                                <xsl:value-of select=" 'page-content' "/>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:horzAnchor = 'page' ">
                                <xsl:value-of select="w:tblpPr/@w:horzAnchor"/>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:horzAnchor= 'inside' ">
                                <xsl:value-of select=" 'paragraph-start-margin' "/>
                            </xsl:when>
                            <xsl:when test="w:tblpPr/@w:horzAnchor= 'outside' ">
                                <xsl:value-of select=" 'paragraph-end-margin' "/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select=" 'paragraph-content' "/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="style:horizontal-rel">
                        <xsl:value-of select="$frame_h_anchor"/>
                    </xsl:attribute>
                    <!--/xsl:if-->
                    <xsl:attribute name="fo:background-color">
                        <xsl:text>#ffffff</xsl:text>
                    </xsl:attribute>
                    <!-- xsl:attribute name="style:background-transparency"><xsl:text>100%</xsl:text></xsl:attribute -->
                    <xsl:attribute name="style:wrap">
                        <xsl:text>parallel</xsl:text>
                    </xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="w:gridCol" mode="style">
        <xsl:element name="style:style">
            <xsl:attribute name="style:family">table-column</xsl:attribute>
            <xsl:attribute name="style:name">Table<xsl:number count="w:tbl" from="/w:wordDocument/w:body" level="any" format="1"/>.C<xsl:number count="w:gridCol" from="/w:wordDocument/w:body" level="single" format="1"/>
            </xsl:attribute>
            <xsl:element name="style:table-column-properties">
                <xsl:variable name="column_width">
                    <xsl:call-template name="ConvertMeasure">
                        <xsl:with-param name="TargetMeasure" select="'in'"/>
                        <xsl:with-param name="value" select="concat(@w:w, 'twip') "/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:attribute name="style:column-width">
                    <xsl:value-of select="concat($column_width,'in') "/>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="w:trPr" mode="style">
        <!-- to generate style:style of table-row height.  -->
        <xsl:element name="style:style">
            <xsl:attribute name="style:family">table-row</xsl:attribute>
            <xsl:attribute name="style:name">Table<xsl:number count="w:tbl" from="/w:wordDocument/w:body" level="any" format="1"/>.R<xsl:number count="w:tr" from="/w:wordDocument/w:body" level="single" format="1"/>
            </xsl:attribute>
            <xsl:element name="style:table-row-properties">
                <xsl:choose>
                    <xsl:when test="w:trHeight/@w:val">
                        <xsl:variable name="tbl_row_height">
                            <xsl:call-template name="ConvertMeasure">
                                <xsl:with-param name="TargetMeasure" select="'in'"/>
                                <xsl:with-param name="value" select="concat(w:trHeight/@w:val, 'twip') "/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="style:min-row-height">
                            <xsl:value-of select="concat($tbl_row_height, 'in' )"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="w:tcPr" mode="style">
        <style:style>
            <xsl:attribute name="style:name">Table<xsl:number count="w:tbl" from="/w:wordDocument/w:body" level="any" format="1"/>.R<xsl:number count="w:tr" from="/w:wordDocument/w:body" level="single" format="1"/>C<xsl:number count="w:tc" from="/w:wordDocument/w:body" level="single" format="1"/>
            </xsl:attribute>
            <xsl:attribute name="style:family">table-cell</xsl:attribute>
            <xsl:variable name="rootStyle" select="ancestor::w:tbl/w:tblPr/w:tblStyle/@w:val"/>
            <xsl:variable name="rootStyleNode" select="/w:wordDocument/w:styles/w:style[@w:styleId = $rootStyle]"/>
            <xsl:element name="style:table-cell-properties">
                <!-- cell background color start -->
                <xsl:variable name="tbl_cell_background_color">
                    <xsl:choose>
                        <xsl:when test="w:shd/@w:fill">
                            <xsl:value-of select="w:shd/@w:fill"/>
                        </xsl:when>
                        <xsl:when test="$rootStyleNode/w:tblpr/w:shd/@w:fill">
                            <xsl:value-of select="$rootStyleNode/w:tblpr/w:shd/@w:fill"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test=" string-length($tbl_cell_background_color) &gt; 0 and not( $tbl_cell_background_color ='auto' )">
                        <xsl:attribute name="fo:background-color">
                            <xsl:value-of select="concat('#',$tbl_cell_background_color)"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <!--cell background color end -->
                <!-- table cell vertical alignment start -->
                <xsl:if test="w:vAlign">
                    <xsl:variable name="tbl_cell_alignment">
                        <xsl:choose>
                            <xsl:when test="w:vAlign/@w:val = 'top' ">
                                <xsl:text>top</xsl:text>
                            </xsl:when>
                            <xsl:when test="w:vAlign/@w:val = 'center' ">
                                <xsl:text>middle</xsl:text>
                            </xsl:when>
                            <xsl:when test="w:vAlign/@w:val = 'bottom' ">
                                <xsl:text>bottom</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>automatic</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="style:vertical-align">
                        <xsl:value-of select="$tbl_cell_alignment"/>
                    </xsl:attribute>
                </xsl:if>
                <!--table cell alignment end -->
                <!-- cell margin start -->
                <xsl:variable name="tblcell_leftmargin">
                    <xsl:choose>
                        <xsl:when test="w:tcMar/w:left">
                            <xsl:call-template name="convert2in_special">
                                <xsl:with-param name="original_value" select="concat(w:tcMar/w:left/@w:w , w:tcMar/w:left/@w:type) "/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$rootStyleNode/w:tblPr/w:tblCellMar/w:left">
                            <xsl:call-template name="convert2in_special">
                                <xsl:with-param name="original_value" select="concat($rootStyleNode/w:tblPr/w:tblCellMar/w:left/@w:w , $rootStyleNode/w:tblPr/w:tblCellMar/w:left/@w:type)"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>0</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="tblcell_rightmargin">
                    <xsl:choose>
                        <xsl:when test="w:tcMar/w:right">
                            <xsl:call-template name="convert2in_special">
                                <xsl:with-param name="original_value" select="concat(w:tcMar/w:right/@w:w , w:tcMar/w:right/@w:type) "/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$rootStyleNode/w:tblPr/w:tblCellMar/w:right">
                            <xsl:call-template name="convert2in_special">
                                <xsl:with-param name="original_value" select="concat($rootStyleNode/w:tblPr/w:tblCellMar/w:right/@w:w , $rootStyleNode/w:tblPr/w:tblCellMar/w:right/@w:type)"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>0</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="tblcell_topmargin">
                    <xsl:choose>
                        <xsl:when test="w:tcMar/w:top">
                            <xsl:call-template name="convert2in_special">
                                <xsl:with-param name="original_value" select="concat(w:tcMar/w:top/@w:w , w:tcMar/w:top/@w:type) "/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$rootStyleNode/w:tblPr/w:tblCellMar/w:top">
                            <xsl:call-template name="convert2in_special">
                                <xsl:with-param name="original_value" select="concat($rootStyleNode/w:tblPr/w:tblCellMar/w:top/@w:w , $rootStyleNode/w:tblPr/w:tblCellMar/w:top/@w:type)"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>0</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="tblcell_bottommargin">
                    <xsl:choose>
                        <xsl:when test="w:tcMar/w:bottom">
                            <xsl:call-template name="convert2in_special">
                                <xsl:with-param name="original_value" select="concat(w:tcMar/w:bottom/@w:w , w:tcMar/w:bottom/@w:type) "/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$rootStyleNode/w:tblPr/w:tblCellMar/w:bottom">
                            <xsl:call-template name="convert2in_special">
                                <xsl:with-param name="original_value" select="concat($rootStyleNode/w:tblPr/w:tblCellMar/w:bottom/@w:w , $rootStyleNode/w:tblPr/w:tblCellMar/w:bottom/@w:type)"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>0</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="string-length($tblcell_leftmargin) &gt; 0 ">
                    <xsl:attribute name="fo:padding-left">
                        <xsl:value-of select="concat($tblcell_leftmargin, 'in' )"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="string-length($tblcell_rightmargin) &gt; 0">
                    <xsl:attribute name="fo:padding-right">
                        <xsl:value-of select="concat($tblcell_rightmargin, 'in' )"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="string-length($tblcell_topmargin) &gt; 0 ">
                    <xsl:attribute name="fo:padding-top">
                        <xsl:value-of select="concat($tblcell_topmargin, 'in' )"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="string-length($tblcell_bottommargin) &gt;  0">
                    <xsl:attribute name="fo:padding-bottom">
                        <xsl:value-of select="concat($tblcell_bottommargin, 'in' )"/>
                    </xsl:attribute>
                </xsl:if>
                <!-- cell margin end -->
                <xsl:variable name="row-position">
                    <xsl:number count="w:tr" from="/w:wordDocument/w:body" level="single" format="1"/>
                </xsl:variable>
                <!-- cell borders should be carefully converted. a little complex. glu :( -->
                <xsl:variable name="Borders" select="ancestor::w:tbl/w:tblPr/w:tblBorders"/>
                <xsl:choose>
                    <xsl:when test="$row-position &gt; 1">
                        <xsl:call-template name="get-table-border">
                            <xsl:with-param name="style-pos" select="'top'"/>
                            <xsl:with-param name="style-position-0" select="w:tcBorders/w:top"/>
                            <xsl:with-param name="style-position-1" select="$Borders/w:insideH"/>
                            <xsl:with-param name="style-position-2" select="$rootStyleNode/w:tblPr/w:tblBorders/w:insideH"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="get-table-border">
                            <xsl:with-param name="style-pos" select="'top'"/>
                            <xsl:with-param name="style-position-0" select="w:tcBorders/w:top"/>
                            <xsl:with-param name="style-position-1" select="$Borders/w:top"/>
                            <xsl:with-param name="style-position-2" select="$rootStyleNode/w:tblPr/w:tblBorders/w:top"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="count(ancestor::w:tr/following-sibling::w:tr) &gt; 0">
                        <xsl:call-template name="get-table-border">
                            <xsl:with-param name="style-pos" select="'bottom'"/>
                            <xsl:with-param name="style-position-0" select="w:tcBorders/w:bottom"/>
                            <xsl:with-param name="style-position-1" select="$Borders/w:insideH"/>
                            <xsl:with-param name="style-position-2" select="$rootStyleNode/w:tblPr/w:tblBorders/w:insideH"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="get-table-border">
                            <xsl:with-param name="style-pos" select="'bottom'"/>
                            <xsl:with-param name="style-position-0" select="w:tcBorders/w:bottom"/>
                            <xsl:with-param name="style-position-1" select="$Borders/w:bottom"/>
                            <xsl:with-param name="style-position-2" select="$rootStyleNode/w:tblPr/w:tblBorders/w:bottom"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="count(ancestor::w:tc/preceding-sibling::w:tc) &gt; 0">
                        <xsl:call-template name="get-table-border">
                            <xsl:with-param name="style-pos" select="'left'"/>
                            <xsl:with-param name="style-position-0" select="w:tcBorders/w:left"/>
                            <xsl:with-param name="style-position-1" select="$Borders/w:insideV"/>
                            <xsl:with-param name="style-position-2" select="$rootStyleNode/w:tblPr/w:tblBorders/w:insideV"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="get-table-border">
                            <xsl:with-param name="style-pos" select="'left'"/>
                            <xsl:with-param name="style-position-0" select="w:tcBorders/w:left"/>
                            <xsl:with-param name="style-position-1" select="$Borders/w:left"/>
                            <xsl:with-param name="style-position-2" select="$rootStyleNode/w:tblPr/w:tblBorders/w:left"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="count(ancestor::w:tc/following-sibling::w:tc) &gt; 0">
                        <xsl:call-template name="get-table-border">
                            <xsl:with-param name="style-pos" select="'right'"/>
                            <xsl:with-param name="style-position-0" select="w:tcBorders/w:right"/>
                            <xsl:with-param name="style-position-1" select="$Borders/w:insideV"/>
                            <xsl:with-param name="style-position-2" select="$rootStyleNode/w:tblPr/w:tblBorders/w:insideV"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="get-table-border">
                            <xsl:with-param name="style-pos" select="'right'"/>
                            <xsl:with-param name="style-position-0" select="w:tcBorders/w:right"/>
                            <xsl:with-param name="style-position-1" select="$Borders/w:right"/>
                            <xsl:with-param name="style-position-2" select="$rootStyleNode/w:tblPr/w:tblBorders/w:right"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </style:style>
    </xsl:template>
    <xsl:template name="get-table-border">
        <xsl:param name="style-pos"/>
        <xsl:param name="style-position-0"/>
        <xsl:param name="style-position-1"/>
        <xsl:param name="style-position-2"/>
        <xsl:variable name="size-style">
            <xsl:choose>
                <xsl:when test="$style-position-0">
                    <xsl:value-of select="$style-position-0/@w:sz"/>
                </xsl:when>
                <xsl:when test="$style-position-1">
                    <xsl:value-of select="$style-position-1/@w:sz"/>
                </xsl:when>
                <xsl:when test="$style-position-2">
                    <xsl:value-of select="$style-position-2/@w:sz"/>
                </xsl:when>
                <xsl:otherwise>2</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="border-style">
            <xsl:choose>
                <xsl:when test="$style-position-0">
                    <xsl:value-of select="$style-position-0/@w:val"/>
                </xsl:when>
                <xsl:when test="$style-position-1">
                    <xsl:value-of select="$style-position-1/@w:val"/>
                </xsl:when>
                <xsl:when test="$style-position-2">
                    <xsl:value-of select="$style-position-2/@w:val"/>
                </xsl:when>
                <xsl:otherwise>single</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="color-border">
            <xsl:choose>
                <xsl:when test="$style-position-0 and string-length($style-position-0/@w:color) = 6">
                    <xsl:value-of select="$style-position-0/@w:color"/>
                </xsl:when>
                <xsl:when test="$style-position-0 and $style-position-0/@w:color = 'auto' and contains($border-style, 'set')">
                    <xsl:text>c0c0c0</xsl:text>
                </xsl:when>
                <xsl:when test="$style-position-1 and string-length($style-position-1/@w:color) = 6">
                    <xsl:value-of select="$style-position-1/@w:color"/>
                </xsl:when>
                <xsl:when test="$style-position-1 and $style-position-1/@w:color = 'auto' and contains($border-style, 'set')">
                    <xsl:text>c0c0c0</xsl:text>
                </xsl:when>
                <xsl:when test="$style-position-2 and string-length($style-position-2/@w:color) = 6">
                    <xsl:value-of select="$style-position-2/@w:color"/>
                </xsl:when>
                <xsl:when test="$style-position-2 and $style-position-2/@w:color = 'auto' and contains($border-style, 'set')">
                    <xsl:text>c0c0c0</xsl:text>
                </xsl:when>
                <xsl:otherwise>000000</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- mapping border line widths. glu -->
        <xsl:choose>
      <xsl:when test="$border-style = 'nil' or $border-style = 'none'">
         <xsl:attribute name="{concat('fo:border-', $style-pos)}">hidden</xsl:attribute>
      </xsl:when>
            <xsl:when test="$border-style = 'single'">
                <xsl:choose>
                    <xsl:when test="$size-style &lt; 7">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.002cm solid #', $color-border)"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 20">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.035cm solid #', $color-border)"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 30">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.088cm solid #', $color-border)"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 40">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.141cm solid #', $color-border)"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.176cm solid #', $color-border)"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$border-style = 'double'">
                <xsl:choose>
                    <xsl:when test="$size-style &lt; 10">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.039cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.035cm 0.002cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 15">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.092cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.002cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 20">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.106cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.035cm 0.035cm 0.035cm</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.265cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.088cm 0.088cm</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$border-style = 'triple'">
                <xsl:choose>
                    <xsl:when test="$size-style &lt; 5">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.039cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.035cm 0.002cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 10">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.092cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">.002cm 0.088cm 0.002cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 15">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.106cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.035cm 0.035cm 0.035cm</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.265cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.088cm 0.088cm</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$border-style = 'thin-thick-small-gap' or $border-style = 'thick-thin-small-gap'">
                <xsl:choose>
                    <xsl:when test="($border-style = 'thin-thick-small-gap' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'thick-thin-small-gap' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                        <xsl:choose>
                            <xsl:when test="$size-style &lt; 20">
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.125cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.035cm</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$size-style &lt; 30">
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.178cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.088cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.231cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.141cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.159cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.035cm 0.035cm</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$border-style = 'thin-thick-thin-small-gap'">
                <xsl:choose>
                    <xsl:when test="$size-style &lt; 20">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.178cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.088cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 40">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.231cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.141cm</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.318cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.088cm 0.141cm</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$border-style = 'thin-thick-medium-gap' or $border-style = 'thick-thin-medium-gap'">
                <xsl:choose>
                    <xsl:when test="$size-style &lt; 10">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.039cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.035cm 0.002cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 15">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.106cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.035cm 0.035cm 0.035cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 30">
                        <xsl:choose>
                            <xsl:when test="($border-style = 'thin-thick-medium-gap' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'thick-thin-medium-gap' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.212cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.035cm 0.088cm 0.088cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.159cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.035cm 0.035cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.318cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="($border-style = 'thin-thick-medium-gap' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'thick-thin-medium-gap' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.088cm 0.141cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.141cm 0.088cm 0.088cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$border-style = 'thin-thick-thin-medium-gap'">
                <xsl:choose>
                    <xsl:when test="$size-style &lt; 10">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.039cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.035cm 0.002cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 15">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.106cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.035cm 0.035cm 0.035cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 30">
                        <xsl:choose>
                            <xsl:when test="$style-pos = 'left' or $style-pos = 'top'">
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.159cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.035cm 0.035cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.212cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.035cm 0.088cm 0.088cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.318cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$style-pos = 'left' or $style-pos = 'top'">
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.141cm 0.088cm 0.088cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.088cm 0.141cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$border-style = 'thin-thick-large-gap' or $border-style = 'thick-thin-large-gap'">
                <xsl:choose>
                    <xsl:when test="$size-style &lt; 7">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.092cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.002cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 10">
                        <xsl:choose>
                            <xsl:when test="($border-style = 'thin-thick-large-gap' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'thick-thin-large-gap' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.125cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.035cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.092cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.002cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 15">
                        <xsl:choose>
                            <xsl:when test="($border-style = 'thin-thick-large-gap' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'thick-thin-large-gap' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.125cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.035cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.159cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.035cm 0.035cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 30">
                        <xsl:choose>
                            <xsl:when test="($border-style = 'thin-thick-large-gap' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'thick-thin-large-gap' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.178cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.088cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.159cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.035cm 0.035cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 40">
                        <xsl:choose>
                            <xsl:when test="($border-style = 'thin-thick-large-gap' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'thick-thin-large-gap' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.231cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.141cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.159cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.035cm 0.035cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.318cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="($border-style = 'thin-thick-large-gap' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'thick-thin-large-gap' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.088cm 0.141cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.141cm 0.088cm 0.088cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$border-style = 'thin-thick-thin-large-gap'">
                <xsl:choose>
                    <xsl:when test="$size-style &lt; 5">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.125cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.035cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 10">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.178cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.088cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 20">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.231cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.141cm</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.318cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.088cm 0.141cm</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains( $border-style, 'wave') or $border-style = 'dash-dot-stroked'">
                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                    <xsl:value-of select="concat('0.106cm double #', $color-border)"/>
                </xsl:attribute>
                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.035cm 0.035cm 0.035cm</xsl:attribute>
            </xsl:when>
            <xsl:when test="contains( $border-style, 'three-d')">
                <xsl:choose>
                    <xsl:when test="$size-style &lt; 10">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.035cm solid #', $color-border)"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 20">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.088cm solid #', $color-border)"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 30">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.176cm solid #', $color-border)"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 40">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.265cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.088cm 0.088cm</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.318cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.088cm 0.141cm</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains( $border-style, 'set')">
                <xsl:choose>
                    <xsl:when test="$size-style &lt; 7">
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.092cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.002cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 10">
                        <xsl:choose>
                            <xsl:when test="($border-style = 'outset' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'inset' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.092cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.002cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.125cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.035cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 15">
                        <xsl:choose>
                            <xsl:when test="($border-style = 'outset' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'inset' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.159cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.035cm 0.035cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.125cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.035cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 30">
                        <xsl:choose>
                            <xsl:when test="($border-style = 'outset' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'inset' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.159cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.035cm 0.035cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.178cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.088cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$size-style &lt; 40">
                        <xsl:choose>
                            <xsl:when test="($border-style = 'outset' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'inset' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.159cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.035cm 0.035cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.231cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.002cm 0.088cm 0.141cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                            <xsl:value-of select="concat('0.318cm double #', $color-border)"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="($border-style = 'outset' and ($style-pos = 'left' or $style-pos = 'top')) or ($border-style = 'inset' and ($style-pos = 'right' or $style-pos = 'bottom'))">
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.141cm 0.088cm 0.088cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{concat('fo:border-', $style-pos)}">
                                    <xsl:value-of select="concat('0.231cm double #', $color-border)"/>
                                </xsl:attribute>
                                <xsl:attribute name="{concat('style:border-line-width-',$style-pos)}">0.088cm 0.088cm 0.141cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="{concat('fo:border-', $style-pos)}">0.002cm solid #000000</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="w:tbl">
        <xsl:choose>
            <xsl:when test="w:tblPr/w:tblpPr">
                <!-- if the table is surrounded by text then put the table into a draw:text-box -->
                <xsl:element name="text:p">
                    <xsl:element name="draw:frame">
                        <xsl:attribute name="draw:style-name">
                            <xsl:text>TableFrame</xsl:text>
                            <xsl:number count="w:tblpPr" from="/w:wordDocument/w:body" level="any" format="1"/>
                        </xsl:attribute>
                        <xsl:attribute name="draw:name">TableFr<xsl:number count="w:tblpPr" from="/w:wordDocument/w:body" level="any" format="1"/>
                        </xsl:attribute>
                        <xsl:variable name="tbl_anchor_type">
                            <xsl:choose>
                                <xsl:when test="name(..) = 'w:tc' ">
                                    <xsl:text>as-char</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>paragraph</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:attribute name="text:anchor-type">
                            <xsl:value-of select="$tbl_anchor_type"/>
                        </xsl:attribute>
                        <xsl:variable name="tbl_draw_textbox_width">
                            <xsl:call-template name="ConvertMeasure">
                                <xsl:with-param name="TargetMeasure" select="'in'"/>
                                <!--  adjust the width of draw:text-box containing a table with 20dxa + table-width -->
                                <xsl:with-param name="value" select="concat(string(number(sum(w:tblGrid/w:gridCol/@w:w) +20)), 'twip' )"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="svg:width">
                            <xsl:value-of select="concat ($tbl_draw_textbox_width, 'in') "/>
                        </xsl:attribute>
                        <xsl:if test="w:tblPr/w:tblpPr/@w:tblpX">
                            <xsl:variable name="x_distance_from_anchor">
                                <xsl:call-template name="ConvertMeasure">
                                    <xsl:with-param name="TargetMeasure" select="'in'"/>
                                    <xsl:with-param name="value" select="concat(w:tblPr/w:tblpPr/@w:tblpX, 'twip' ) "/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:attribute name="svg:x">
                                <xsl:value-of select="concat ($x_distance_from_anchor, 'in' )"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="w:tblPr/w:tblpPr/@w:tblpY">
                            <xsl:variable name="y_distance_from_anchor">
                                <xsl:call-template name="ConvertMeasure">
                                    <xsl:with-param name="TargetMeasure" select="'in'"/>
                                    <xsl:with-param name="value" select="concat(w:tblPr/w:tblpPr/@w:tblpY, 'twip' ) "/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:attribute name="svg:y">
                                <xsl:value-of select="concat ($y_distance_from_anchor, 'in' )"/>
                            </xsl:attribute>
                        </xsl:if>
                        <!--create table in draw:text-box to produce table wrapping text effect-->
                        <xsl:element name="draw:text-box">
                            <xsl:element name="table:table">
                                <xsl:if test="w:tblPr">
                                    <xsl:attribute name="table:style-name">Table<xsl:number count="w:tbl" from="/w:wordDocument/w:body" level="any" format="1"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:apply-templates mode="dispatch"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <!--draw:text-box end  -->
                </xsl:element>
                <!-- text:p end -->
            </xsl:when>
            <xsl:otherwise>
                <!-- if the table is not surrounded by text then put the table into a draw:text-box -->
                <xsl:element name="table:table">
                    <xsl:if test="w:tblPr">
                        <xsl:attribute name="table:style-name">Table<xsl:number count="w:tbl" from="/w:wordDocument/w:body" level="any" format="1"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates mode="dispatch"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="w:tblGrid">
        <xsl:apply-templates select="w:gridCol"/>
    </xsl:template>
    <xsl:template match="w:gridCol">
        <xsl:element name="table:table-column">
            <xsl:attribute name="table:style-name">Table<xsl:number count="w:tbl" from="/w:wordDocument/w:body" level="any" format="1"/>.C<xsl:number count="w:gridCol" from="/w:wordDocument/w:body" level="single" format="1"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="w:tr">
        <xsl:element name="table:table-row">
            <!-- generate row in table and add attribute of table:style-name if the style:style exists. cp tom chen. -->
            <xsl:if test="w:trPr/w:trHeight">
                <xsl:attribute name="table:style-name">Table<xsl:number count="w:tbl" from="/w:wordDocument/w:body" level="any" format="1"/>.R<xsl:number count="w:tr" from="/w:wordDocument/w:body" level="single" format="1"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="dispatch"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="w:tc">
        <xsl:element name="table:table-cell">
            <xsl:attribute name="table:style-name">Table<xsl:number count="w:tbl" from="/w:wordDocument/w:body" level="any" format="1"/>.R<xsl:number count="w:tr" from="/w:wordDocument/w:body" level="single" format="1"/>C<xsl:number count="w:tc" from="/w:wordDocument/w:body" level="single" format="1"/>
            </xsl:attribute>
            <xsl:if test="w:tcPr/w:gridSpan and w:tcPr/w:gridSpan/@w:val &gt; 0">
                <xsl:attribute name="table:number-columns-spanned">
                    <xsl:value-of select="w:tcPr/w:gridSpan/@w:val"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="dispatch"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="convert2in_special">
        <!-- this template is specially to  deal with w:type ='dxa' situation -->
        <xsl:param name="original_value"/>
        <xsl:choose>
            <xsl:when test="contains($original_value, 'dxa') ">
                <xsl:variable name="table_measurement_new_value">
                    <xsl:value-of select="concat( substring-before($original_value,'dxa'), 'twip')"/>
                </xsl:variable>
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="TargetMeasure" select="'in'"/>
                    <xsl:with-param name="value" select="$table_measurement_new_value"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
