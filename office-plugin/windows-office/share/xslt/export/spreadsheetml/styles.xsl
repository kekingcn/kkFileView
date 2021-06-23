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

    <!-- Used in case of 'style:map', conditional formatting, where a style references to another -->
    <xsl:key name="styles" match="/*/office:styles/style:style | /*/office:automatic-styles/style:style" use="@style:name" />
    <!--
        Mapping of OOo style:name and style:family to excel ss:ID
        Styles form style:style map from style:name to ss:Name
        style:parent-style map to ss:Parent
    -->
    <!--   default styles of the application
    <xsl:template match="style:default-style" mode="styles" >
        <xsl:call-template name="style:style">
            <xsl:with-param name="styleName" select="'Default'" />
        </xsl:call-template>
    </xsl:template>
     -->

    <xsl:template match="style:style" mode="styles">
        <xsl:param name="isAutomatic" />
        <xsl:param name="styleName" select="@style:name" />
        <xsl:param name="styleParentName" select="@style:parent-style-name" />

        <!-- only row styles used by cells are exported,
            as usual row style properties are already exported as row attributes -->
        <xsl:if test="not(@style:family='table-row') or @style:family='table-row' and key('getCellByStyle', '.')">
            <xsl:element name="Style">
                <xsl:attribute name="ss:ID">
                    <!-- neglecting that a style is only unique in conjunction with its family name -->
                    <xsl:value-of select="@style:name" />
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="not($isAutomatic)">
                        <xsl:choose>
                            <xsl:when test="@style:display-name">
                                <xsl:attribute name="ss:Name"><xsl:value-of select="@style:display-name"/></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="ss:Name"><xsl:value-of select="@style:name" /></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <!-- when a non-allowed parent style is found
                                (in spreadsheetml no style with ss:Name is able to have a ss:Parent)  -->
                            <xsl:when test="@style:parent-style-name">
                                <!-- styles have to be merged (flatting heritance tree) -->
                                <xsl:variable name="stylePropertiesContainer">
                                    <xsl:call-template name="merge-all-parent-styles">
                                        <xsl:with-param name="currentStyle" select="." />
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="function-available('xalan:nodeset')">
                                        <xsl:call-template name="write-style-properties">
                                            <xsl:with-param name="styleProperties" select="xalan:nodeset($stylePropertiesContainer)/*" />
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:when test="function-available('common:node-set')">
                                        <xsl:call-template name="write-style-properties">
                                            <xsl:with-param name="styleProperties" select="common:node-set($stylePropertiesContainer)/*" />
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:when test="function-available('xt:node-set')">
                                        <xsl:call-template name="write-style-properties">
                                            <xsl:with-param name="styleProperties" select="xt:node-set($stylePropertiesContainer)/*" />
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:message terminate="yes">WARNING: The required node set function was not found!</xsl:message>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="write-style-properties" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- automatic styles are implicit inheriting from a style called 'Default',
                        furthermore nor in spreadsheetml nor in OpenDocument automatic styles are able to inherit from each other -->
                        <xsl:choose>
                            <xsl:when test="@style:parent-style-name and not(@style:parent-style-name = 'Default')">
                                <xsl:attribute name="ss:Parent"><xsl:value-of select="@style:parent-style-name" /></xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:call-template name="write-style-properties" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!-- resolving the style inheritance by starting from uppermost parent and
         overriding existing style properties by new found child properties -->
    <xsl:template name="merge-all-parent-styles">
        <xsl:param name="currentStyle" />

        <xsl:choose>
            <!-- in case of a parent, styles have to be merged (flatting heritance tree) -->
            <xsl:when test="$currentStyle/@style:parent-style-name">
                <!-- collect parent style properties -->
                <xsl:variable name="parentStyleContainer">
                    <!-- take a look if the parent style has a parent himself -->
                    <xsl:call-template name="merge-all-parent-styles" >
                        <xsl:with-param name="currentStyle" select="key('styles', $currentStyle/@style:parent-style-name)" />
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="function-available('xalan:nodeset')">
                        <xsl:call-template name="merge-style-properties">
                            <xsl:with-param name="childStyleContainer"  select="$currentStyle" />
                            <xsl:with-param name="parentStyleContainer" select="xalan:nodeset($parentStyleContainer)" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="function-available('common:node-set')">
                        <xsl:call-template name="merge-style-properties">
                            <xsl:with-param name="childStyleContainer"  select="$currentStyle" />
                            <xsl:with-param name="parentStyleContainer" select="common:node-set($parentStyleContainer)" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="function-available('xt:node-set')">
                        <xsl:call-template name="merge-style-properties">
                            <xsl:with-param name="childStyleContainer"  select="$currentStyle" />
                            <xsl:with-param name="parentStyleContainer" select="xt:node-set($parentStyleContainer)" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="yes">WARNING: The required node-set function was not found!</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- called for top parents (or styles without parents) -->
            <xsl:otherwise>
                <xsl:copy-of select="$currentStyle/*"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="merge-style-properties">
        <xsl:param name="childStyleContainer" />
        <xsl:param name="parentStyleContainer" />

        <xsl:choose>
            <xsl:when test="$parentStyleContainer/*">
                <xsl:apply-templates select="$parentStyleContainer/*" mode="inheritance">
                    <xsl:with-param name="childStyleContainer" select="$childStyleContainer" />
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$childStyleContainer/*"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="inheritance">
        <xsl:param name="childStyleContainer" />

        <!-- create an element named equal to the current properties parent element (e.g. style:table-cell-properties) -->
        <xsl:element name="{name()}" namespace="urn:oasis:names:tc:opendocument:xmlns:style:1.0">
            <!-- attributes will be automatically replaced  -->
            <xsl:copy-of select="@*" />
            <xsl:copy-of select="$childStyleContainer/*[name() = name(current() )]/@*"/>

            <!-- elements are not needed yet, will be neglected for simplicity reasons -->
        </xsl:element>
    </xsl:template>

    <xsl:key match="/*/office:styles/number:date-style |
                    /*/office:styles/number:time-style |
                    /*/office:styles/number:number-style |
                    /*/office:styles/number:percentage-style |
                    /*/office:styles/number:currency-style |
                    /*/office:automatic-styles/number:date-style |
                    /*/office:automatic-styles/number:time-style |
                    /*/office:automatic-styles/number:number-style  |
                    /*/office:automatic-styles/number:percentage-style |
                    /*/office:automatic-styles/number:currency-style" name="number-style" use="@style:name" />


    <xsl:template name="write-style-properties">
        <xsl:param name="styleProperties" select="key('styles', @style:name)/*" />

        <xsl:call-template name="Alignment">
            <xsl:with-param name="styleProperties" select="$styleProperties" />
        </xsl:call-template>
        <xsl:call-template name="Border">
            <xsl:with-param name="styleProperties" select="$styleProperties" />
        </xsl:call-template>
        <xsl:call-template name="Font">
            <xsl:with-param name="styleProperties" select="$styleProperties" />
            <xsl:with-param name="styleParentName" select="@style:parent-style-name" />
        </xsl:call-template>
        <xsl:call-template name="Interior">
            <xsl:with-param name="styleProperties" select="$styleProperties" />
        </xsl:call-template>
        <xsl:call-template name="NumberFormat">
            <xsl:with-param name="styleProperties" select="$styleProperties" />
        </xsl:call-template>
    </xsl:template>

    <!-- context is element 'style:style' -->
    <xsl:template name="NumberFormat">
        <xsl:if test="@style:data-style-name">
            <xsl:variable name="numberStyleName" select="@style:data-style-name" />
            <xsl:variable name="numberStyle" select="key('number-style', $numberStyleName)" />

            <xsl:element name="NumberFormat">
                <xsl:attribute name="ss:Format">
                <xsl:choose>
                    <xsl:when test="not($numberStyle/node())">
                        <!-- Excel2003sp1 issue: 'General' and 'General Number' is not supported -->
                         <xsl:text>General</xsl:text>
                    </xsl:when>
                    <xsl:when test="name($numberStyle) = 'number:number-style'">
                        <xsl:choose>
                            <xsl:when test="$numberStyle/number:scientific-number">
                                <xsl:text>Scientific</xsl:text>
                            </xsl:when>
                            <!-- Excel2003sp1 issue: 'General Number' not supported -->
                            <xsl:when test="$numberStyle/number:number/@number:decimal-places and
                                            $numberStyle/number:number/@number:decimal-places='0'">
                                <xsl:text>General</xsl:text>
                            </xsl:when>
                            <xsl:when test="$numberStyle/number:text">
                                <xsl:choose>
                                    <xsl:when test="$numberStyle/number:text = 'No' or $numberStyle/number:text = 'Nein'">
                                        <xsl:text>Yes/No</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$numberStyle/number:text = 'False' or $numberStyle/number:text = 'Falsch'">
                                        <xsl:text>True/False</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$numberStyle/number:text = 'Off' or $numberStyle/number:text = 'Aus'">
                                        <xsl:text>On/Off</xsl:text>
                                    </xsl:when>
                                    <!-- Excel2003sp1 issue: currency is saved as 'float' -->
                                    <xsl:when test="$numberStyle/number:currency-symbol">
                                        <xsl:choose>
                                            <xsl:when test="contains($numberStyle/number:currency-symbol, '€')">
                                                <xsl:text>Euro Currency</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>Currency</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <!-- Excel2003sp1 issue: 'Currency' is saved as 'float' -->
                                    <xsl:when test="contains($numberStyle/number:text, '$')">
                                        <xsl:text>Currency</xsl:text>
                                    </xsl:when>
                                    <!-- OASIS XML adaptation -->
                                    <xsl:otherwise>
                                        <xsl:text>General</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="$numberStyle/number:grouping">
                                <xsl:text>Standard</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Fixed</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="name($numberStyle) = 'number:time-style'">
                        <xsl:choose>
                            <xsl:when test="$numberStyle/number:am-pm">
                                <xsl:choose>
                                    <xsl:when test="$numberStyle/number:seconds">
                                        <xsl:text>Long Time</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>Medium Time</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Short Time</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="name($numberStyle) = 'number:percentage-style'">
                        <xsl:text>Percent</xsl:text>
                    </xsl:when>
                    <xsl:when test="name($numberStyle) = 'number:currency-style'">
                        <xsl:choose>
                            <xsl:when test="contains($numberStyle/number:currency-symbol, '€')">
                                <xsl:text>Euro Currency</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Currency</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$numberStyle/number:month">
                                <xsl:choose>
                                    <xsl:when test="$numberStyle/number:month/@number:textual and
                                                    $numberStyle/number:month/@number:textual=true()">
                                        <xsl:text>Medium Date</xsl:text>
                                        <!--  Excel2003 sp1 issue: No difference between 'Long Date' and 'Medium Date' -->
                                    </xsl:when>
                                    <xsl:when test="$numberStyle/number:hours">
                                        <xsl:text>General Date</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$numberStyle/number:year/@number:style and
                                                    $numberStyle/number:year/@number:style='long'">
                                        <xsl:text>Short Date</xsl:text>
                                    </xsl:when>
                                    <!-- OASIS XML adaptation -->
                                    <xsl:otherwise>
                                        <xsl:text>Short Date</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <!-- OASIS XML adaptation -->
                            <xsl:otherwise>
                                <xsl:text>General</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Alignment">
        <xsl:param name="styleProperties" />

        <!-- An empty Alignment element, might overwrite parents setting by
             the default attributes -->
        <xsl:if test="$styleProperties/@fo:text-align or
                      $styleProperties/@style:vertical-align or
                      $styleProperties/@fo:wrap-option or
                      $styleProperties/@fo:margin-left or
                      $styleProperties/@style:rotation-angle or
                      $styleProperties/@style:direction">
            <xsl:element name="Alignment">
                <xsl:if test="$styleProperties/@fo:text-align">
                    <xsl:attribute name="ss:Horizontal">
                        <xsl:choose>
                            <xsl:when test="$styleProperties/@fo:text-align = 'center'">Center</xsl:when>
                            <xsl:when test="$styleProperties/@fo:text-align = 'end'">Right</xsl:when>
                            <xsl:when test="$styleProperties/@fo:text-align = 'justify'">Justify</xsl:when>
                            <xsl:otherwise>Left</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:vertical-align">
                    <xsl:attribute name="ss:Vertical">
                        <xsl:choose>
                            <xsl:when test="$styleProperties/@style:vertical-align = 'top'">Top</xsl:when>
                            <xsl:when test="$styleProperties/@style:vertical-align = 'bottom'">Bottom</xsl:when>
                            <xsl:when test="$styleProperties/@style:vertical-align = 'middle'">Center</xsl:when>
                            <xsl:otherwise>Automatic</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="$styleProperties/@fo:wrap-option = 'wrap'">
                    <xsl:attribute name="ss:WrapText">1</xsl:attribute>
                </xsl:if>
                <xsl:if test="$styleProperties/@fo:margin-left">
                    <xsl:attribute name="ss:Indent">
                        <xsl:variable name="margin">
                            <xsl:call-template name="convert2pt">
                                <xsl:with-param name="value" select="$styleProperties/@fo:margin-left" />
                                <xsl:with-param name="rounding-factor" select="1" />
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- one ss:Indent is equal to 10 points -->
                        <xsl:value-of select="number($margin) div 10"/>
                    </xsl:attribute>
                </xsl:if>
                <!-- Excel is only able to rotate between 90 and -90 degree (inclusive).
                     Other degrees will be mapped by 180 degrees -->
                <xsl:if test="$styleProperties/@style:rotation-angle">
                    <xsl:attribute name="ss:Rotate">
                        <xsl:choose>
                            <xsl:when test="$styleProperties/@style:rotation-angle &gt; 90">
                                <xsl:choose>
                                    <xsl:when test="$styleProperties/@style:rotation-angle &gt;= 270">
                                        <xsl:value-of select="$styleProperties/@style:rotation-angle - 360" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$styleProperties/@style:rotation-angle - 180" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="$styleProperties/@style:rotation-angle &lt; -90">
                                <xsl:choose>
                                    <xsl:when test="$styleProperties/@style:rotation-angle &lt;= -270">
                                        <xsl:value-of select="$styleProperties/@style:rotation-angle + 360" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$styleProperties/@style:rotation-angle + 180" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$styleProperties/@style:rotation-angle" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:direction = 'ttb'">
                    <xsl:attribute name="ss:VerticalText">1</xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
    </xsl:template>


    <xsl:template name="Border">
        <xsl:param name="styleProperties" />

        <!-- An empty border element, might overwrite parents setting by
             the default attributes -->
        <xsl:if test="$styleProperties/@fo:border or
                      $styleProperties/@fo:border-bottom or
                      $styleProperties/@fo:border-left or
                      $styleProperties/@fo:border-right or
                      $styleProperties/@fo:border-top">
            <xsl:element name="Borders">
                <xsl:if test="$styleProperties/@fo:border-bottom and not($styleProperties/@fo:border-bottom = 'none')">
                    <xsl:element name="Border">
                        <xsl:attribute name="ss:Position">Bottom</xsl:attribute>
                        <xsl:call-template name="border-attributes">
                            <xsl:with-param name="border_properties" select="$styleProperties/@fo:border-bottom" />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$styleProperties/@fo:border-left and not($styleProperties/@fo:border-left = 'none')">
                    <xsl:element name="Border">
                        <xsl:attribute name="ss:Position">Left</xsl:attribute>
                        <xsl:call-template name="border-attributes">
                            <xsl:with-param name="border_properties" select="$styleProperties/@fo:border-left" />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$styleProperties/@fo:border-right and not($styleProperties/@fo:border-right = 'none')">
                    <xsl:element name="Border">
                        <xsl:attribute name="ss:Position">Right</xsl:attribute>
                        <xsl:call-template name="border-attributes">
                            <xsl:with-param name="border_properties" select="$styleProperties/@fo:border-right" />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$styleProperties/@fo:border-top  and not($styleProperties/@fo:border-top = 'none')">
                    <xsl:element name="Border">
                        <xsl:attribute name="ss:Position">Top</xsl:attribute>
                        <xsl:call-template name="border-attributes">
                            <xsl:with-param name="border_properties" select="$styleProperties/@fo:border-top" />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
                <!-- write out all table border  -->
                <xsl:if test="$styleProperties/@fo:border and not($styleProperties/@fo:border = 'none')">
                    <xsl:element name="Border">
                        <xsl:attribute name="ss:Position">Bottom</xsl:attribute>
                        <xsl:call-template name="border-attributes">
                            <xsl:with-param name="border_properties" select="$styleProperties/@fo:border" />
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="Border">
                        <xsl:attribute name="ss:Position">Left</xsl:attribute>
                        <xsl:call-template name="border-attributes">
                            <xsl:with-param name="border_properties" select="$styleProperties/@fo:border" />
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="Border">
                        <xsl:attribute name="ss:Position">Right</xsl:attribute>
                        <xsl:call-template name="border-attributes">
                            <xsl:with-param name="border_properties" select="$styleProperties/@fo:border" />
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="Border">
                        <xsl:attribute name="ss:Position">Top</xsl:attribute>
                        <xsl:call-template name="border-attributes">
                            <xsl:with-param name="border_properties" select="$styleProperties/@fo:border" />
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:if>
    </xsl:template>


    <xsl:template name="border-attributes">
        <xsl:param name="border_properties" />

        <xsl:variable name="border-width">
            <xsl:call-template name="convert2cm">
                <xsl:with-param name="value" select="substring-before($border_properties, ' ')" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="border-style" select="substring-before(substring-after($border_properties, ' '), ' ')" />
        <xsl:variable name="border-color" select="substring-after(substring-after($border_properties, ' '), ' ')" />
<!--
        <xsl:message>border-width:<xsl:value-of select="$border-width" /></xsl:message>
        <xsl:message>border-style:<xsl:value-of select="$border-style" /></xsl:message>
        <xsl:message>border-color:<xsl:value-of select="$border-color" /></xsl:message>
 -->

        <!-- Dash, Dot, DashDot, DashDotDot, SlantDashDot are not supported yet -->
        <xsl:attribute name="ss:LineStyle">
            <xsl:choose>
                <xsl:when test="$border-style = 'none'">None</xsl:when>
                <xsl:when test="$border-style = 'double'">Double</xsl:when>
                <xsl:otherwise>Continuous</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="ss:Weight">
            <xsl:choose>
                <!-- 0: Hairline -->
                <xsl:when test="$border-width &lt;= 0.002">0</xsl:when>
                <!-- 1: Thin -->
                <xsl:when test="$border-width &lt;= 0.035">1</xsl:when>
                <!-- 2: Medium -->
                <xsl:when test="$border-width &lt;= 0.088">2</xsl:when>
                <!-- 3: Thick -->
                <xsl:otherwise>3</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:attribute name="ss:Color">
            <xsl:choose>
                <xsl:when test="$border-color"><xsl:value-of select="$border-color" /></xsl:when>
                <xsl:otherwise>Automatic</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>


    <xsl:template name="Font">
        <xsl:param name="styleProperties" />
        <xsl:param name="styleParentName" />

        <!-- An empty font element, might overwrite parents setting by
             the default attributes -->
        <xsl:if test="$styleProperties/@style:font-weight or
                      $styleProperties/@fo:color or
                      $styleProperties/@style:font-name or
                      $styleProperties/@fo:font-style or
                      $styleProperties/@style:text-outline or
                      $styleProperties/@style:text-shadow or
                      $styleProperties/@style:font-size or
                      $styleProperties/@style:text-line-through-style or
                      $styleProperties/@style:text-underline-type or
                      $styleProperties/@style:text-underline-style or
                      $styleProperties/@style:text-position">


            <xsl:element name="Font">
                <xsl:call-template name="getParentBold">
                    <xsl:with-param name="styleProperties" select="$styleProperties" />
                    <xsl:with-param name="styleParentName" select="$styleParentName" />
                </xsl:call-template>
                <xsl:if test="$styleProperties/@fo:color">
                    <xsl:attribute name="ss:Color"><xsl:value-of select="$styleProperties/@fo:color" /></xsl:attribute>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:font-name">
                    <xsl:attribute name="ss:FontName"><xsl:value-of select="$styleProperties/@style:font-name" /></xsl:attribute>
                </xsl:if>
                <xsl:if test="$styleProperties/@fo:font-style = 'italic'">
                    <xsl:attribute name="ss:Italic">1</xsl:attribute>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:text-outline = 'true'">
                    <xsl:attribute name="ss:Outline">1</xsl:attribute>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:text-shadow = 'shadow'">
                    <xsl:attribute name="ss:Shadow">1</xsl:attribute>
                </xsl:if>
                <xsl:if test="$styleProperties/@fo:font-size">
                    <xsl:attribute name="ss:Size">
                        <xsl:call-template name="convert2pt">
                            <xsl:with-param name="value" select="$styleProperties/@fo:font-size" />
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:text-line-through-style and $styleProperties/@style:text-line-through-style != 'none'">
                    <xsl:attribute name="ss:StrikeThrough">1</xsl:attribute>
                </xsl:if>
                <xsl:if test="($styleProperties/@style:text-underline-type and $styleProperties/@style:text-underline-type != 'none') or
                              ($styleProperties/@style:text-underline-style and $styleProperties/@style:text-underline-style != 'none')">
                    <xsl:attribute name="ss:Underline">
                        <xsl:choose>
                            <xsl:when test="$styleProperties/@style:text-underline-type = 'double'">Double</xsl:when>
                            <xsl:otherwise>Single</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:text-position">
                    <xsl:attribute name="ss:VerticalAlign">
                        <xsl:choose>
                            <xsl:when test="substring-before($styleProperties/@style:text-position, '% ') &gt; 0">Superscript</xsl:when>
                            <xsl:otherwise>Subscript</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Interior">
        <xsl:param name="styleProperties" />
        <xsl:if test="$styleProperties/@fo:background-color and not($styleProperties/@fo:background-color = 'transparent')">
            <xsl:element name="Interior">
                <xsl:attribute name="ss:Color">
                    <xsl:value-of select="$styleProperties/@fo:background-color" />
                </xsl:attribute>
                <!-- Background color (i.e. Interior/ss:Color) not shown without ss:Pattern (or with 'none')
                Therefore a default is set -->
                <xsl:attribute name="ss:Pattern">Solid</xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!-- Excel issue workaround: <Font ss:Bold="1"> is not inherited -->
    <xsl:template name="getParentBold">
        <xsl:param name="styleProperties" />
        <xsl:param name="styleParentName" />
        <xsl:param name="styleName" />

        <xsl:if test="$styleParentName and $styleParentName != $styleName">
            <xsl:choose>
                <xsl:when test="$styleProperties/@fo:font-weight = 'bold'">
                    <xsl:attribute name="ss:Bold">1</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="getParentBold">
                        <xsl:with-param name="styleProperties" select="key('styles', $styleParentName)/*" />
                        <xsl:with-param name="styleParentName" select="key('styles', $styleParentName)/@style:parent-style-name" />
                        <xsl:with-param name="styleName" select="$styleParentName" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
