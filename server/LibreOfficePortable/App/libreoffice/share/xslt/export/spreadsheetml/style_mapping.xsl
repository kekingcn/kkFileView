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

    <xsl:variable name="namespace-html" select="'http://www.w3.org/TR/REC-html40'" />

    <xsl:template match="@table:style-name | @table:default-cell-style-name">
        <xsl:if test="not(name() = 'Default')">
            <xsl:attribute name="ss:StyleID">
                <xsl:value-of  select="." />
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:key match="table:table-cell" name="getCellByStyle" use="@table:style-name"/>
    <xsl:template match="@table:style-name" mode="table-row">
        <!-- only row styles used by cells are exported,
            as usual row style properties are already written as row attributes -->
        <xsl:if test="key('getCellByStyle', '.')">
            <xsl:attribute name="ss:StyleID">
                <xsl:value-of  select="." />
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="style-and-contents">
        <xsl:param name="cellStyleName" />

        <!-- WorkAround of Excel2003 issue:
            Styles from the CellStyle will not be inherited to HTML content (e.g. Colour style).
        -->
        <xsl:choose>
            <xsl:when test="@text:style-name">
                <xsl:variable name="styles">
                    <xsl:copy-of select="key('styles', @text:style-name)/*" />
                    <xsl:copy-of select="key('styles', $cellStyleName)/*" />
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="function-available('xalan:nodeset')">
                        <xsl:call-template name="create-nested-format-tags">
                            <xsl:with-param name="styles" select="xalan:nodeset($styles)" />
                            <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="function-available('xt:node-set')">
                        <xsl:call-template name="create-nested-format-tags">
                            <xsl:with-param name="styles" select="xt:node-set($styles)" />
                            <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="function-available('common:node-set')">
                        <xsl:call-template name="create-nested-format-tags">
                            <xsl:with-param name="styles" select="common:node-set($styles)" />
                            <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="yes">The required node-set function was not found!</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@table:style-name">
                <xsl:variable name="styles">
                    <xsl:copy-of select="key('styles', @text:style-name)/*" />
                    <xsl:copy-of select="key('styles', $cellStyleName)/*" />
                </xsl:variable>

                <xsl:choose>
                    <xsl:when test="function-available('xalan:nodeset')">
                        <xsl:call-template name="create-nested-format-tags">
                            <xsl:with-param name="styles" select="xalan:nodeset($styles)" />
                            <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="function-available('xt:node-set')">
                        <xsl:call-template name="create-nested-format-tags">
                            <xsl:with-param name="styles" select="xt:node-set($styles)" />
                            <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="function-available('common:node-set')">
                        <xsl:call-template name="create-nested-format-tags">
                            <xsl:with-param name="styles" select="common:node-set($styles)" />
                            <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="yes">The required node-set function was not found!</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- *********************************** -->
    <!-- *** creating nested format tags *** -->
    <!-- *********************************** -->

    <!-- Bold -->
    <xsl:template name="create-nested-format-tags">
        <xsl:param name="styles" />
        <xsl:param name="cellStyleName" />

        <xsl:choose>
            <xsl:when test="$styles/*/@fo:font-weight = 'bold' or $styles/*/@fo:font-weight = 'bolder'">
                <xsl:element namespace="{$namespace-html}" name="B">
                    <xsl:call-template name="italic">
                        <xsl:with-param name="styles" select="$styles" />
                        <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="italic">
                    <xsl:with-param name="styles" select="$styles" />
                    <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Italic -->
    <xsl:template name="italic">
        <xsl:param name="styles" />
        <xsl:param name="cellStyleName" />

        <xsl:choose>
            <xsl:when test="$styles/*/@fo:font-style = 'italic' or $styles/*/@fo:font-style = 'oblique'">
                <xsl:element namespace="{$namespace-html}" name="I">
                    <xsl:call-template name="underline">
                        <xsl:with-param name="styles" select="$styles" />
                        <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="underline">
                    <xsl:with-param name="styles" select="$styles" />
                    <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Underline -->
    <xsl:template name="underline">
        <xsl:param name="styles" />
        <xsl:param name="cellStyleName" />

        <xsl:choose>
            <xsl:when test="$styles/*/@style:text-underline-type and not($styles/*/@style:text-underline-type = 'none')">
                <xsl:element namespace="{$namespace-html}" name="U">
                    <xsl:call-template name="strikethrough">
                        <xsl:with-param name="styles" select="$styles" />
                        <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="strikethrough">
                    <xsl:with-param name="styles" select="$styles" />
                    <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <!-- strikethrough -->
    <xsl:template name="strikethrough">
        <xsl:param name="styles" />
        <xsl:param name="cellStyleName" />

        <xsl:choose>
            <xsl:when test="$styles/*/@style:text-line-through-style and not($styles/*/@style:text-line-through-style = 'none')">
                <xsl:element namespace="{$namespace-html}" name="S">
                    <xsl:call-template name="super-subscript">
                        <xsl:with-param name="styles" select="$styles" />
                        <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="super-subscript">
                    <xsl:with-param name="styles" select="$styles" />
                    <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!-- superscript & subscript -->
    <xsl:template name="super-subscript">
        <xsl:param name="styles" />
        <xsl:param name="cellStyleName" />

        <xsl:choose>
            <xsl:when test="$styles/*/@style:text-position">
                <xsl:variable name="textPosition" select="number(substring-before($styles/*/@style:text-position, '% '))" />
                <xsl:choose>
                    <xsl:when test="$textPosition &gt; 0">
                        <xsl:element namespace="{$namespace-html}" name="Sup">
                            <xsl:call-template name="align">
                                <xsl:with-param name="styles" select="$styles" />
                                <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$textPosition &lt; 0">
                        <xsl:element namespace="{$namespace-html}" name="Sub">
                            <xsl:call-template name="align">
                                <xsl:with-param name="styles" select="$styles" />
                                <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="align">
                            <xsl:with-param name="styles" select="$styles" />
                            <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="align">
                    <xsl:with-param name="styles" select="$styles" />
                    <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Alignment - normally called by strikethrough, but no DIV elements in HTML -->
    <xsl:template name="align">
        <xsl:param name="styles" />
        <xsl:param name="cellStyleName" />

        <xsl:choose>
            <xsl:when test="$styles/*/@fo:font-align">
                <xsl:element namespace="{$namespace-html}" name="DIV">
                    <xsl:attribute name="html:style">
                         <xsl:choose>
                            <xsl:when test="$styles/*/@fo:font-align = 'start'">
                                <xsl:text>text-align:left;</xsl:text>
                            </xsl:when>
                            <xsl:when test="$styles/*/@fo:font-align = 'end'">
                                <xsl:text>text-align:right;</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>text-align:center;</xsl:text>
                            </xsl:otherwise>
                         </xsl:choose>
                    </xsl:attribute>
                    <xsl:call-template name="font">
                        <xsl:with-param name="styles" select="$styles" />
                        <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="font">
                    <xsl:with-param name="styles" select="$styles" />
                    <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Font (size and color)  -->
    <xsl:template name="font">
        <xsl:param name="styles" />
        <xsl:param name="cellStyleName" />

        <xsl:choose>
            <xsl:when test="$styles/*/@style:font-name or
                            $styles/*/@fo:font-size or
                            $styles/*/@fo:color">
                <xsl:element namespace="{$namespace-html}" name="Font">
                    <xsl:if test="$styles/*/@style:font-name">
                        <xsl:attribute name="html:Face">
                             <xsl:value-of select="$styles/*/@style:font-name" />
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$styles/*/@fo:color">
                        <xsl:attribute name="html:Color">
                             <xsl:value-of select="$styles/*/@fo:color" />
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$styles/*/@fo:font-size">
                        <!-- WORKAROUND TO EXCEL2003 issue where nested FONT elements with size attributes result in unloadable documents -->
                        <!-- Only create size attribute if parent do not have already one -->

                        <!--<xsl:choose>
                            <xsl:when test="not(key('styles', parent::*/@text:style-name)/*/@fo:font-size)"> -->
                        <xsl:if test="not(key('styles', parent::*/@text:style-name)/*/@fo:font-size)">
                            <xsl:attribute name="html:Size">
                                <xsl:call-template name="convert2pt">
                                    <xsl:with-param name="value" select="$styles/*/@fo:font-size" />
                                    <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <!--</xsl:when>
                            <xsl:otherwise>
                                <xsl:message>Due Excel issue we have to neglect size from @text:style-name '<xsl:value-of select="@text:style-name"/>'!</xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>-->
                    </xsl:if>
                    <!-- get the embedded content -->
                    <xsl:apply-templates>
                        <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- get the embedded content -->
                <xsl:apply-templates>
                    <xsl:with-param name="cellStyleName" select="$cellStyleName" />
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
