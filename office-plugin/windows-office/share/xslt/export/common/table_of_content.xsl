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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:java="http://xml.apache.org/xslt/java" xmlns:sxg="http://www.jclark.com/xt/java/org.openoffice.xslt.OOoMasterDocument" xmlns:common="http://exslt.org/common" xmlns:xt="http://www.jclark.com/xt" xmlns:xalan="http://xml.apache.org/xalan" exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xforms xlink xsd xsi java sxg xt common xalan">

    <!-- ****************************** -->
    <!-- ***    Table of Content    *** -->
    <!-- ****************************** -->

    <xsl:param name="currentChildContentRef" />
    <xsl:param name="contentTableHeadings" />
    <xsl:param name="contentTableURL" />
    <xsl:template match="text:table-of-content">
        <xsl:param name="globalData"/>

        <xsl:apply-templates>
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:apply-templates>
    </xsl:template>


    <xsl:template match="text:index-body">
        <xsl:param name="globalData"/>

        <xsl:choose>
            <xsl:when test="parent::table-of-content and */text:tab[1] or */*/text:tab[1]">
                <xsl:call-template name="createIndexBodyTable">
                    <xsl:with-param name="globalData" select="$globalData"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="globalData" select="$globalData"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text:index-title" mode="content-table">
        <xsl:param name="globalData"/>

        <xsl:apply-templates>
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template name="createIndexBodyTable">
        <xsl:param name="globalData"/>
        <xsl:variable name="allStyleTabStops-RTF">
            <xsl:element name="style:tab-stops">
                <xsl:call-template name="get-tab-stops">
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="styleName" select="current()/@text:style-name"/>

                    <!--
                    Currently only the style of text:index-body is recognized, but not of a paragraph child containing the text:tab element!
                    <xsl:with-param name="styleName" select="descendant-or-self::*/@text:style-name"/>

                    The column width needs to be tabstop plus fo:margin-left paragraph-properties
                     -->
                </xsl:call-template>
            </xsl:element>
        </xsl:variable>
        <xsl:element namespace="{$namespace}" name="table">

            <xsl:attribute name="border">0</xsl:attribute>
            <xsl:attribute name="cellspacing">0</xsl:attribute>
            <xsl:attribute name="cellpadding">0</xsl:attribute>
            <xsl:if test="parent::*/@text:style-name">
                <!-- parent as index:body has no style -->
                <xsl:variable name="value" select="$globalData/all-doc-styles/style[@style:name = current()/parent::*/@text:style-name]/*/@style:rel-width"/>
                <xsl:if test="$value">
                    <xsl:attribute name="width">
                        <xsl:value-of select="$value"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="class">
                    <xsl:value-of select="translate(parent::*/@text:style-name, '.,;: %()[]/\+', '_____________')"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:element namespace="{$namespace}" name="colgroup">
                <xsl:choose>
                    <xsl:when test="function-available('common:node-set')">
                        <xsl:call-template name="create-col-element">
                            <xsl:with-param name="lastNodePosition" select="count(common:node-set($allStyleTabStops-RTF)/style:tab-stops/style:tab-stop)"/>
                            <xsl:with-param name="allStyleTabStops" select="common:node-set($allStyleTabStops-RTF)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="function-available('xalan:nodeset')">
                        <xsl:call-template name="create-col-element">
                            <xsl:with-param name="lastNodePosition" select="count(xalan:nodeset($allStyleTabStops-RTF)/style:tab-stops/style:tab-stop)"/>
                            <xsl:with-param name="allStyleTabStops" select="xalan:nodeset($allStyleTabStops-RTF)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="function-available('xt:node-set')">
                        <xsl:call-template name="create-col-element">
                            <xsl:with-param name="lastNodePosition" select="count(xt:node-set($allStyleTabStops-RTF)/style:tab-stops/style:tab-stop)"/>
                            <xsl:with-param name="allStyleTabStops" select="xt:node-set($allStyleTabStops-RTF)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="yes">ERROR: Function not found: nodeset</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>

            <!-- add table data -->
            <xsl:choose>
                <xsl:when test="function-available('common:node-set')">
                    <xsl:apply-templates mode="content-table">
                        <xsl:with-param name="globalData" select="$globalData"/>
                        <xsl:with-param name="allStyleTabStops" select="common:node-set($allStyleTabStops-RTF)"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="function-available('xalan:nodeset')">
                    <xsl:apply-templates mode="content-table">
                        <xsl:with-param name="globalData" select="$globalData"/>
                        <xsl:with-param name="allStyleTabStops" select="xalan:nodeset($allStyleTabStops-RTF)"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="function-available('xt:node-set')">
                    <xsl:apply-templates mode="content-table">
                        <xsl:with-param name="globalData" select="$globalData"/>
                        <xsl:with-param name="allStyleTabStops" select="xt:node-set($allStyleTabStops-RTF)"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">ERROR: Function not found: nodeset</xsl:message>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:element>
    </xsl:template>


    <!-- ************************************************ -->
    <!-- *** Create Table for Content Table Paragraph *** -->
    <!-- ************************************************ -->

    <!-- Usually the paragraphs in a content-table are ordered by tab-stops, which can not be displayed correctly by XHTML/CSS
     Therefore they will be simulated by a table -->
    <xsl:template match="text:p" mode="content-table">
        <xsl:param name="globalData"/>
        <xsl:param name="allStyleTabStops"/>

            <!-- all elements before the first tabStop -->
        <xsl:variable name="testNo-RTF">
            <xsl:apply-templates select="node()" mode="cell-content"/>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="function-available('common:node-set')">
                <xsl:variable name="tabNodePositions" select="common:node-set($testNo-RTF)"/>
                <xsl:element namespace="{$namespace}" name="tr">
                    <xsl:call-template name="create-td-elements">
                        <xsl:with-param name="lastNodePosition" select="count($allStyleTabStops/style:tab-stops/style:tab-stop)"/>
                        <xsl:with-param name="position" select="1"/>
                        <xsl:with-param name="allStyleTabStops" select="$allStyleTabStops"/>
                        <xsl:with-param name="tabNodePositions" select="$tabNodePositions"/>
                        <xsl:with-param name="globalData" select="$globalData"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:when test="function-available('xalan:nodeset')">
                <xsl:variable name="tabNodePositions" select="xalan:nodeset($testNo-RTF)"/>
                <xsl:element namespace="{$namespace}" name="tr">
                    <xsl:call-template name="create-td-elements">
                        <xsl:with-param name="lastNodePosition" select="count($allStyleTabStops/style:tab-stops/style:tab-stop)"/>
                        <xsl:with-param name="position" select="1"/>
                        <xsl:with-param name="allStyleTabStops" select="$allStyleTabStops"/>
                        <xsl:with-param name="tabNodePositions" select="$tabNodePositions"/>
                        <xsl:with-param name="globalData" select="$globalData"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:when test="function-available('xt:node-set')">
                <xsl:variable name="tabNodePositions" select="xt:node-set($testNo-RTF)"/>
                <xsl:element namespace="{$namespace}" name="tr">
                    <xsl:call-template name="create-td-elements">
                        <xsl:with-param name="lastNodePosition" select="count($allStyleTabStops/style:tab-stops/style:tab-stop)"/>
                        <xsl:with-param name="position" select="1"/>
                        <xsl:with-param name="allStyleTabStops" select="$allStyleTabStops"/>
                        <xsl:with-param name="tabNodePositions" select="$tabNodePositions"/>
                        <xsl:with-param name="globalData" select="$globalData"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">ERROR: Function not found: nodeset</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Gathering all style:tab-stops from a style-hierarchy as siblings -->
    <xsl:template name="get-tab-stops">
        <xsl:param name="globalData"/>
        <xsl:param name="styleName"/>
        <xsl:variable name="tabStyle" select="key('styles', $styleName)"/>

        <xsl:if test="$tabStyle/*/style:tab-stops/style:tab-stop/@style:position">
            <xsl:for-each select="$tabStyle/*/style:tab-stops/style:tab-stop">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="$tabStyle/@style:parent-style-name">
            <xsl:call-template name="get-tab-stops">
                <xsl:with-param name="globalData" select="$globalData"/>
                <xsl:with-param name="styleName" select="$tabStyle/@style:parent-style-name"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="create-col-element">
        <xsl:param name="lastNodePosition"/>
        <xsl:param name="allStyleTabStops"/>

        <xsl:for-each select="$allStyleTabStops/style:tab-stops/style:tab-stop">
            <xsl:element namespace="{$namespace}" name="col">
                <xsl:attribute name="style">
                    <xsl:text>width: </xsl:text>
                    <xsl:choose>
                        <xsl:when test="contains(@style:position, 'cm')">
                            <xsl:call-template name="create-cell-width">
                                <xsl:with-param name="width" select="number(substring-before(@style:position,'cm'))"/>
                                <xsl:with-param name="unit" select="'cm'"/>
                                <xsl:with-param name="position" select="position() - 1"/>
                                <xsl:with-param name="allStyleTabStops" select="$allStyleTabStops"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="contains(@style:position, 'in')">
                            <xsl:call-template name="create-cell-width">
                                <xsl:with-param name="width" select="number(substring-before(@style:position,'in'))"/>
                                <xsl:with-param name="unit" select="'in'"/>
                                <xsl:with-param name="position" select="position() - 1"/>
                                <xsl:with-param name="allStyleTabStops" select="$allStyleTabStops"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="contains(@style:position, 'ch')">
                            <xsl:call-template name="create-cell-width">
                                <xsl:with-param name="width" select="number(substring-before(@style:position,'ch'))"/>
                                <xsl:with-param name="unit" select="'ch'"/>
                                <xsl:with-param name="position" select="position() - 1"/>
                                <xsl:with-param name="allStyleTabStops" select="$allStyleTabStops"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="contains(@style:position, 'pt')">
                            <xsl:call-template name="create-cell-width">
                                <xsl:with-param name="width" select="number(substring-before(@style:position,'pt'))"/>
                                <xsl:with-param name="unit" select="'pt'"/>
                                <xsl:with-param name="position" select="position() - 1"/>
                                <xsl:with-param name="allStyleTabStops" select="$allStyleTabStops"/>
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>

                </xsl:attribute>
            </xsl:element>
        </xsl:for-each>

    </xsl:template>
<!--
Scenarios tabstops

1) style:type of style:tab-stop is 'right' and earlier tabStop is not right
 -> Earlier text-nodes and following text-nodes, will be put into an inner table, with two TD first aligned left, with preceding textnodes, the latter aligned right.

2) style:type is 'right' and earlier tabStop is right
 -> following text-nodes, will be put into a right aligned TD

3) style:type is 'non-right' and earlier tabStop 'non-right' as well
 -> put the preceding tab stops into a TD (left aligned is default)

4) first style:type would have no right preceding tabStop
 -> works well with first sceanrios 1 and 3

5) last style:type would be a special case, if it would be left aligned, but this won't happen in our case... :D

Scenarios unmatched:
- text:styleposition 'center' will not be matched in our case (effort for nothing), there will be only 'right' and not 'right'
- If the last tabStop is not from text:styleposition 'right', the length of the last cell is undefined and a document length must be found.
  Not happens in our master document case. Also the algorithm below would have to be expanded (cp. scenario 5).

-->
    <xsl:template name="create-td-elements">
        <xsl:param name="globalData"/>
        <xsl:param name="lastNodePosition"/>
        <xsl:param name="position"/>
        <xsl:param name="allStyleTabStops"/>
        <xsl:param name="tabNodePositions"/>

        <xsl:variable name="currentTabStop" select="$allStyleTabStops/style:tab-stops/style:tab-stop[$position]"/>
        <xsl:variable name="earlierTabStop" select="$allStyleTabStops/style:tab-stops/style:tab-stop[$position - 1]"/>
        <xsl:choose>
            <xsl:when test="not($currentTabStop/@style:position) and not($earlierTabStop/@style:position)">
                <!-- in case no TAB STOP is being set -->
                <xsl:element namespace="{$namespace}" name="td">
                    <xsl:element namespace="{$namespace}" name="p">
                        <xsl:if test="$position = 1">
                            <xsl:attribute name="class">
                                <xsl:value-of select="translate(@text:style-name, '.,;: %()[]/\+', '_____________')"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates mode="content-table">
                            <xsl:with-param name="globalData" select="$globalData"/>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$currentTabStop/@style:type = 'right'">
                        <xsl:choose>
                            <xsl:when test="$earlierTabStop/@style:type = 'right'">
                                <!--
                                2) style:type is 'right' and earlier tabStop is right
                                    -> following text-nodes, will be put into a right aligned TD -->
                                <xsl:element namespace="{$namespace}" name="td">
                                    <xsl:attribute name="style">
                                        <xsl:text>align: right</xsl:text>
                                    </xsl:attribute>
                                    <xsl:element namespace="{$namespace}" name="p">
                                        <xsl:if test="$position = 1">
                                            <xsl:attribute name="class">
                                                <xsl:value-of select="translate(@text:style-name, '.,;: %()[]/\+', '_____________')"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:call-template name="grab-cell-content-before-tab-stop">
                                            <xsl:with-param name="globalData" select="$globalData"/>
                                            <xsl:with-param name="endingTabStopPosition" select="$position + 1"/>
                                            <xsl:with-param name="lastNodePosition" select="$lastNodePosition"/>
                                            <xsl:with-param name="tabNodePositions" select="$tabNodePositions"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element namespace="{$namespace}" name="td">
                                    <xsl:element namespace="{$namespace}" name="p">
                                        <xsl:if test="$position = 1">
                                            <xsl:attribute name="class">
                                                <xsl:value-of select="translate(@text:style-name, '.,;: %()[]/\+', '_____________')"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:call-template name="grab-cell-content-before-tab-stop">
                                            <xsl:with-param name="globalData" select="$globalData"/>
                                            <xsl:with-param name="endingTabStopPosition" select="$position"/>
                                            <xsl:with-param name="lastNodePosition" select="$lastNodePosition"/>
                                            <xsl:with-param name="tabNodePositions" select="$tabNodePositions"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$earlierTabStop/@style:type = 'right'"></xsl:when>
                            <xsl:otherwise>
                            <!--
                               3) style:type is 'non-right' and earlier tabStop 'non-right' as well
                                    -> put the preceding tab stops into a TD (left aligned is default) -->
                                <xsl:element namespace="{$namespace}" name="p">
                                    <xsl:if test="$position = 1">
                                        <xsl:attribute name="class">
                                            <xsl:value-of select="translate(@text:style-name, '.,;: %()[]/\+', '_____________')"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:element namespace="{$namespace}" name="td">
                                        <xsl:call-template name="grab-cell-content-before-tab-stop">
                                            <xsl:with-param name="globalData" select="$globalData"/>
                                            <xsl:with-param name="endingTabStopPosition" select="$position"/>
                                            <xsl:with-param name="lastNodePosition" select="$lastNodePosition"/>
                                            <xsl:with-param name="tabNodePositions" select="$tabNodePositions"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:if test="$position != $lastNodePosition">
                    <xsl:call-template name="create-td-elements">
                        <xsl:with-param name="globalData" select="$globalData"/>
                        <xsl:with-param name="lastNodePosition" select="$lastNodePosition"/>
                        <xsl:with-param name="position" select="$position + 1"/>
                        <xsl:with-param name="allStyleTabStops" select="$allStyleTabStops"/>
                        <xsl:with-param name="tabNodePositions" select="$tabNodePositions"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="grab-cell-content-before-tab-stop">
        <xsl:param name="globalData"/>
        <xsl:param name="endingTabStopPosition"/>
        <xsl:param name="tabNodePositions"/>
        <xsl:param name="lastNodePosition"/>

        <xsl:choose>
            <xsl:when test="$endingTabStopPosition = 1">
                <xsl:apply-templates mode="content-table" select="node()[position() &lt; $tabNodePositions/tab-stop-node-position[$endingTabStopPosition]]">
                    <xsl:with-param name="globalData" select="$globalData"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$endingTabStopPosition > $lastNodePosition">
                <xsl:apply-templates mode="content-table" select="node()[position() > $tabNodePositions/tab-stop-node-position[$endingTabStopPosition - 1]]">
                    <xsl:with-param name="globalData" select="$globalData"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="nodesOfNextColumn" select="node()[position() &lt; $tabNodePositions/tab-stop-node-position[$endingTabStopPosition]][position() &gt; $tabNodePositions/tab-stop-node-position[$endingTabStopPosition - 1]]"/>
                <xsl:choose>
                    <xsl:when test="$nodesOfNextColumn != ''">
                        <xsl:apply-templates mode="content-table" select="$nodesOfNextColumn">
                            <xsl:with-param name="globalData" select="$globalData"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="content-table">
                            <xsl:with-param name="globalData" select="$globalData"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- As the span width will be mapped to column width, the preceding span widths have to be subtracted -->
    <xsl:template name="create-cell-width">
        <xsl:param name="width"/>
        <xsl:param name="unit"/>
        <xsl:param name="position"/>
        <xsl:param name="allStyleTabStops"/>

        <xsl:choose>
            <!-- beyond second width -->
            <xsl:when test="$position > 1">
                <xsl:call-template name="create-cell-width">
                    <xsl:with-param name="width" select="$width - number(substring-before($allStyleTabStops/style:tab-stops/style:tab-stop[$position]/@style:position,$unit))"/>
                    <xsl:with-param name="unit" select="$unit"/>
                    <xsl:with-param name="position" select="$position - 1"/>
                    <xsl:with-param name="allStyleTabStops" select="$allStyleTabStops"/>
                </xsl:call-template>
            </xsl:when>
            <!-- second width -->
            <xsl:when test="$position = 1">
                <xsl:value-of select="concat($width - number(substring-before($allStyleTabStops/style:tab-stops/style:tab-stop[$position]/@style:position,$unit)), $unit)"/>
            </xsl:when>
            <!-- first width -->
            <xsl:otherwise>
                <xsl:value-of select="concat($width, $unit)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- ************************************** -->
    <!--    CREATION OF A CONTENT TABLE LINK    -->
    <!-- ************************************** -->

    <xsl:key name="bookmark" match="text:bookmark | text:bookmark-start" use="@text:name"/>

     <!-- content table link  -->
    <xsl:template match="text:a" mode="content-table">
        <xsl:param name="globalData"/>

        <xsl:variable name="name" select="substring(@xlink:href,2)"/>

        <xsl:variable name="text">
            <xsl:choose>
            <!-- heuristic assumption that first in a content table row, there is numbering (if at all) and then the text,
            furthermore that a tab will separate the to be neglected page number -->
                <xsl:when test="text:tab">
                    <xsl:call-template name="write-text-without-line-numbers">
                        <xsl:with-param name="textCount" select="count(text())"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="text()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- REFERENCE HANDLING - HREF -->
        <xsl:element namespace="{$namespace}" name="a">
            <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
                <xsl:choose>
                    <xsl:when test="key('bookmark',$name)">
                        <xsl:value-of select="$name"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select='concat("a_",  translate(normalize-space($text), "&#xA;&amp;&lt;&gt;.,;: %()[]/\+", "_______________________________"))'/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="$text"/>
        </xsl:element>
    </xsl:template>

    <!-- Heuristic: write out text separated by elements, leaving the last number out (mostly text number) -->
    <xsl:template name="write-text-without-line-numbers">
        <xsl:param name="textCount"/>
        <xsl:param name="textNodeNumber" select="1"/>

        <xsl:choose>
            <xsl:when test="$textCount &gt; $textNodeNumber">
                <xsl:value-of select="text()[$textNodeNumber]"/>
                <xsl:call-template name="write-text-without-line-numbers">
                    <xsl:with-param name="textCount" select="$textCount"/>
                    <xsl:with-param name="textNodeNumber" select="$textNodeNumber + 1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(number(text()[$textNodeNumber]) &gt; -1)">
                    <xsl:value-of select="text()[$textNodeNumber]"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="text:s" mode="content-table">
        <xsl:call-template name="write-breakable-whitespace">
            <xsl:with-param name="whitespaces" select="@text:c"/>
        </xsl:call-template>
    </xsl:template>

    <!-- ******************** -->
    <!-- *** Common Rules *** -->
    <!-- ******************** -->

    <xsl:template match="*" mode="content-table">
        <xsl:param name="globalData"/>

        <xsl:apply-templates select=".">
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*" mode="cell-content">
        <xsl:if test="name() = 'text:tab' or *[name() = 'text:tab']">
            <xsl:element name="tab-stop-node-position" namespace="">
                <xsl:value-of select="position()"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text()" mode="content-table">
        <!-- Heuristic to remove page numbers (useless in HTML) in the content table
            usually after a tab  -->
        <xsl:if test="name(preceding-sibling::*[1]) != 'text:tab' and not(number() &gt; -1)">
            <xsl:value-of select="."/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
