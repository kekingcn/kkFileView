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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xt="http://www.jclark.com/xt" xmlns:common="http://exslt.org/common" xmlns:xalan="http://xml.apache.org/xalan" xmlns:loext="urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0" exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xforms xlink xsd xsi xt common xalan" xmlns="http://www.w3.org/1999/xhtml">


    <!--+++++ INCLUDED XSL MODULES +++++-->

    <!-- helper collection, to convert measures (e.g. inch to pixel using DPI (dots per inch) parameter)-->
    <xsl:import href="../../common/measure_conversion.xsl"/>

    <!-- common office body element handling -->
    <xsl:import href="../common/body.xsl"/>

    <!-- common table handling -->
    <xsl:import href="../common/table/table.xsl"/>

    <!-- xhtml table handling -->
    <xsl:include href="table.xsl"/>

    <!-- Useful in case of 'style:map', conditional formatting, where a style references to another -->
    <xsl:key name="styles" match="/*/office:styles/style:style | /*/office:automatic-styles/style:style" use="@style:name"/>


    <!-- ************ -->
    <!-- *** body *** -->
    <!-- ************ -->

    <xsl:key match="style:style/@style:master-page-name" name="masterPage" use="'count'"/>
    <xsl:key match="style:master-page" name="masterPageElements" use="@style:name"/>
    <xsl:key match="style:page-layout" name="pageLayoutElements" use="@style:name"/>
    <xsl:key name="writingModeStyles" match="/*/office:styles/style:style/style:paragraph-properties/@style:writing-mode | /*/office:automatic-styles/style:style/style:paragraph-properties/@style:writing-mode" use="'test'"/>
    <xsl:template name="create-body">
        <xsl:param name="globalData"/>
        <xsl:call-template name="create-body.collect-page-properties">
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="create-body.collect-page-properties">
        <xsl:param name="globalData"/>

        <!-- approximation to find the correct master page style (with page dimensions) -->
        <xsl:variable name="masterPageNames">
            <!-- Loop over every style:style containing a @style:master-page-name attribute -->
            <xsl:for-each select="key('masterPage','count')">
                <!-- Check if this style is being used in the body -->
                <xsl:if test="key('elementUsingStyle', ../@style:name)">
                    <!-- Check every master-page-name if it is not empty and return as ';' separated list  -->
                    <xsl:if test="string-length(../@style:master-page-name) &gt; 0">
                        <xsl:value-of select="../@style:master-page-name"/>;
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <!-- Take the first of the masterpage list and get the according style:master-page element and find the @style:page-layout-name  -->
        <xsl:variable name="pageLayoutName" select="key('masterPageElements', substring-before($masterPageNames,';'))/@style:page-layout-name"/>
        <xsl:variable name="pagePropertiesRTF">
            <xsl:choose>
                <xsl:when test="not($pageLayoutName) or $pageLayoutName = ''">
                    <xsl:copy-of select="$globalData/styles-file/*/office:automatic-styles/style:page-layout[1]/style:page-layout-properties"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Find the according style:page-layout and store the properties in a variable  -->
                    <xsl:copy-of select="key('pageLayoutElements', $pageLayoutName)/style:page-layout-properties"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="function-available('common:node-set')">
                <xsl:call-template name="create-body.create">
                    <xsl:with-param name="globalData" select="common:node-set($globalData)"/>
                    <xsl:with-param name="pageProperties" select="common:node-set($pagePropertiesRTF)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xalan:nodeset')">
                <xsl:call-template name="create-body.create">
                    <xsl:with-param name="globalData" select="xalan:nodeset($globalData)"/>
                    <xsl:with-param name="pageProperties" select="xalan:nodeset($pagePropertiesRTF)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xt:node-set')">
                <xsl:call-template name="create-body.create">
                    <xsl:with-param name="globalData" select="xt:node-set($globalData)"/>
                    <xsl:with-param name="pageProperties" select="xt:node-set($pagePropertiesRTF)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">The required node-set function was not found!</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="create-body.create">
        <xsl:param name="globalData"/>
        <xsl:param name="pageProperties"/>

        <xsl:element name="body">
            <!-- direction of text flow -->
            <xsl:variable name="writingMode" select="$pageProperties/style:page-layout-properties/@style:writing-mode"/>
            <xsl:choose>
                <xsl:when test="$writingMode">
                    <xsl:choose>
                        <xsl:when test="contains($writingMode, 'lr')">
                            <xsl:attribute name="dir">ltr</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains($writingMode, 'rl')">
                            <xsl:attribute name="dir">rtl</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <!-- As CSS writing-mode is not implemented by all browsers, a heuristic is done -->
                    <xsl:variable name="writingModeTest" select="key('writingModeStyles', 'test')"/>
                    <xsl:if test="contains($writingModeTest, 'rl')">
                        <xsl:attribute name="dir">rtl</xsl:attribute>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <!-- adapt page size -->
            <xsl:variable name="pageWidth" select="$pageProperties/style:page-layout-properties/@fo:page-width"/>

            <!-- multiple backgroundimages for different page styles (never used in html) -->
            <xsl:variable name="backgroundImage" select="$pageProperties/style:page-layout-properties/style:background-image"/>
            <!-- page margins & background image  -->
            <xsl:if test="$pageWidth or $pageProperties/style:page-layout-properties/@fo:* or $backgroundImage/@xlink:href">
                <xsl:attribute name="style">
                    <xsl:if test="$pageWidth">
                        <xsl:text>max-width:</xsl:text>
                        <xsl:value-of select="$pageWidth"/>
                        <xsl:text>;</xsl:text>
                    </xsl:if>
                    <xsl:if test="$pageProperties/style:page-layout-properties/@fo:* or $backgroundImage/@xlink:href">
                        <xsl:apply-templates select="$pageProperties/style:page-layout-properties/@fo:*"/>
                        <xsl:if test="$backgroundImage/@xlink:href">
                            <xsl:text>background-image:url(</xsl:text>
                            <xsl:call-template name="create-href">
                                <xsl:with-param name="href" select="$backgroundImage/@xlink:href"/>
                            </xsl:call-template>
                            <xsl:text>);</xsl:text>

                            <xsl:if test="$backgroundImage/@style:repeat">
                                <xsl:choose>
                                    <xsl:when test="$backgroundImage/@style:repeat = 'no-repeat'">
                                        <xsl:text>background-repeat:no-repeat;</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>background-repeat:repeat;</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="$backgroundImage/@style:position">
                                <xsl:text>background-position:</xsl:text>
                                <xsl:value-of select="$backgroundImage/@style:position"/>
                                <xsl:text>;</xsl:text>
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:attribute>
            </xsl:if>
            <!-- processing the content of the OpenDocument content file -->
            <xsl:apply-templates select="/*/office:body/*">
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:apply-templates>

        </xsl:element>
    </xsl:template>

    <!-- processing the content of the OpenDocument content file -->
    <xsl:template match="office:body/*">
        <xsl:param name="globalData"/>

        <!-- not using of 'apply-styles-and-content' as the content table information might have been added to 'globalData' variable -->
        <xsl:apply-templates select="@text:style-name | @draw:style-name | @draw:text-style-name | @table:style-name"><!-- | @presentation:style-name -->
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:apply-templates>

        <xsl:apply-templates>
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:apply-templates>

        <!-- writing the footer- and endnotes beyond the body -->
        <xsl:call-template name="write-text-nodes">
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:call-template>
    </xsl:template>

    <!-- ******************************* -->
    <!-- *** User Field Declarations *** -->
    <!-- ******************************* -->

    <xsl:template match="text:user-field-get | text:user-field-input">
        <xsl:param name="globalData"/>

        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="text:conditional-text">
        <xsl:param name="globalData"/>

        <xsl:value-of select="."/>
    </xsl:template>

    <!-- ODF text fields -->
    <xsl:template match="text:author-initials | text:author-name | text:chapter | text:character-count | text:creation-date | text:creation-time | text:creator | text:date | text:description | text:editing-cycles | text:editing-duration | text:file-name | text:image-count | text:initial-creator | text:keywords | text:modification-date | text:modification-time | text:object-count | text:page-continuation | text:page-count | text:page-number | text:paragraph-count | text:print-date | text:print-time | text:printed-by | text:sender-city | text:sender-company | text:sender-country | text:sender-email | text:sender-fax | text:sender-firstname | text:sender-initials | text:sender-lastname | text:sender-phone-private | text:sender-phone-work | text:sender-position | text:sender-postal-code | text:sender-state-or-province | text:sender-street | text:sender-title | text:sheet-name | text:subject | text:table-count | text:time | text:title | text:user-defined | text:word-count">
        <xsl:param name="globalData"/>

        <xsl:element name="span">
            <xsl:attribute name="title">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:apply-templates>
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>



    <!-- *************** -->
    <!-- *** Textbox *** -->
    <!-- *************** -->

    <xsl:template match="draw:text-box">
        <xsl:param name="globalData"/>

        <xsl:comment>Next 'div' was a 'draw:text-box'.</xsl:comment>
        <xsl:element name="div">
            <xsl:variable name="dimension">
                <xsl:apply-templates select="@fo:min-width"/>
                <xsl:apply-templates select="@fo:max-width"/>
                <xsl:apply-templates select="@fo:min-height"/>
                <xsl:apply-templates select="@fo:max-height"/>
            </xsl:variable>
            <xsl:if test="$dimension">
                <xsl:attribute name="style">
                    <xsl:value-of select="$dimension"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@draw:name">
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:apply-templates>

            <xsl:apply-templates select="node()">
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@fo:min-width">
        <xsl:text>min-width:</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    <xsl:template match="@fo:max-width">
        <xsl:text>max-width:</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    <xsl:template match="@fo:min-height">
        <xsl:text>min-height:</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>
    <xsl:template match="@fo:max-height">
        <xsl:text>max-height:</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>;</xsl:text>
    </xsl:template>


    <!-- inline style helper for the 'div' boxes -->
    <xsl:template name="svg:height">
        <xsl:text>height:</xsl:text>
        <xsl:choose>
            <!-- changing the distance measure: inch to in -->
            <xsl:when test="contains(@svg:height, 'inch')">
                <xsl:value-of select="substring-before(@svg:height, 'ch')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@svg:height"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>;</xsl:text>
    </xsl:template>

    <!-- inline style helper for the 'div' boxes -->
    <xsl:template name="svg:width">
        <xsl:text>width:</xsl:text>
        <xsl:choose>
            <!-- changing the distance measure: inch to in -->
            <xsl:when test="contains(@svg:width, 'inch')">
                <xsl:value-of select="substring-before(@svg:width, 'ch')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@svg:width"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>;</xsl:text>
    </xsl:template>



    <!-- ****************** -->
    <!-- *** Paragraphs *** -->
    <!-- ****************** -->

    <xsl:template match="text:p | draw:page">
        <xsl:param name="globalData"/>
        <!-- The footnote symbol is the prefix for a footnote in the footer -->
        <xsl:param name="footnotePrefix"/>
        <!-- 1) In ODF sometimes the following children are nested
                <text:p>
                    <draw:frame>
                        <draw:text-box>
                            <text:p>
                Which results in a paragraphs (the last text:p) having a paragraph as its ancestor.
                In HTML a 'p' can only have inline documents (no other 'p' as children'),
                a 'div' will be given for the ancestors instead.
             2) ODF images are embedded in a paragraph, but CSS is not able to express a horizontal alignment for an HTML image (text:align is only valid for block elements).
                A surrounding 'div' element taking over the image style solves that problem, but the div is invalid as child of a paragraph
                Therefore the paragraph has to be exchanged with a HTML div element
        -->
        <!-- 2DO page alignment fix - PART1 -->
        <xsl:variable name="childText"><xsl:apply-templates mode="getAllTextChildren"/></xsl:variable>
        <xsl:choose>
            <xsl:when test="name() = 'text:p' and not(*) and (normalize-space($childText) = '')">
                <!-- WorkAround: Test if the empty paragraph was added after an image, which OOO often does -->
                <xsl:variable name="isFollowingImage">
                    <xsl:call-template name="follows-empty-paragraphs-and-image">
                        <xsl:with-param name="precedingElement" select="preceding-sibling::node()[1]"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$isFollowingImage = 'no'">
                    <xsl:call-template name="create-paragraph">
                        <xsl:with-param name="globalData" select="$globalData" />
                        <xsl:with-param name="footnotePrefix" select="$footnotePrefix" />
                    </xsl:call-template>
                </xsl:if>

            </xsl:when>
            <xsl:when test="draw:frame and ((normalize-space($childText) != '')  or (((count(*) - count(text:soft-page-break)) &gt; 1)))">
                <!-- If there is a 'draw:frame' child with text (not being whitespace alone) and more than the draw:frame alone and
                    not the draw:frame and a soft-page-break alone (which is quite often) -->

                <!-- If there is a frame within the text:p or draw:page, its siblings are surrounded as well by a div and are floating (CSS float) -->
                <!-- But it makes no sense to create floating if the frame is alone or only together with a soft-page-break not usable for HTML -->
                <!-- The paragraph is written as DIV as there might be nested paragraphs (see above choose block) -->
                <xsl:choose>
                    <xsl:when test="name() = 'text:p'">
                        <xsl:comment>Next 'div' was a 'text:p'.</xsl:comment>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:comment>Next 'div' was a 'draw:page'.</xsl:comment>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:element name="div">
                    <xsl:apply-templates select="@*">
                        <xsl:with-param name="globalData" select="$globalData"/>
                    </xsl:apply-templates>
                    <!-- the footnote symbol is the prefix for a footnote in the footer -->
                    <xsl:copy-of select="$footnotePrefix"/>
                    <!-- start floating of frame (and siblings) -->
                    <xsl:apply-templates select="node()[1]" mode="frameFloating">
                        <xsl:with-param name="globalData" select="$globalData" />
                        <xsl:with-param name="previousFrameWidths" select="0"/>
                        <xsl:with-param name="previousFrameHeights" select="0"/>
                        <!-- 2DO for me (Svante) - Not used, uncertain 4now...
                        <xsl:with-param name="pageMarginLeft">
                            <xsl:call-template name="getPageMarginLeft"/>
                         </xsl:with-param>-->
                    </xsl:apply-templates>
                </xsl:element>
                <!-- after the last draw:frame sibling the CSS float is disabled
                    &#160; is an unbreakable whitespace to give content to the element and force a browser not to ignore the element -->
                <div style="clear:both; line-height:0; width:0; height:0; margin:0; padding:0;">&#160;</div>
            </xsl:when>
            <xsl:when test="text:tab and not(ancestor::text:index-body)">
                <!-- If there is a tabulator (ie. text:tab) within a paragraph, a heuristic for ODF tabulators creates a
                    span for every text:tab embracing the following text nodes aligning them according to the tabulator.
                    A line break or another text:tab starts a new text:span, line break even the tab counter for the line.
                -->
                <xsl:element name="p">
                    <xsl:apply-templates select="@*">
                        <xsl:with-param name="globalData" select="$globalData" />
                    </xsl:apply-templates>
                    <!-- start with first child of the paragraph -->
                    <xsl:variable name="firstChildNode" select="node()[1]" />
                    <xsl:apply-templates select="$firstChildNode" mode="tabHandling">
                        <xsl:with-param name="globalData" select="$globalData" />
                        <xsl:with-param name="tabStops" select="$globalData/all-doc-styles/style[@style:name = current()/@text:style-name]/*/style:tab-stops"/>
                        <xsl:with-param name="parentMarginLeft">
                            <!-- Styles of first paragraph in list item, including ancestor styles (inheritance) -->
                            <xsl:variable name="paragraphName" select="@text:style-name" />
                            <xsl:variable name="imageParagraphStyle" select="$globalData/all-styles/style[@style:name = $paragraphName]/final-properties"/>
                            <!-- Only the left margin of the first paragraph of a list item will be added to the margin of the complete list (all levels)-->
<!-- 2DO: left-margin in order with bidirectional -->
                            <xsl:choose>
                                <xsl:when test="contains($imageParagraphStyle, 'margin-left:')">
                                    <xsl:call-template name="convert2cm">
                                        <xsl:with-param name="value" select="normalize-space(substring-before(substring-after($imageParagraphStyle, 'margin-left:'), ';'))"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="pageMarginLeft">
                            <xsl:call-template name="getPageMarginLeft"/>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:when>
            <xsl:when test="text:tab and text:a and ancestor::text:index-body">
                <xsl:element name="p">
                    <xsl:apply-templates select="attribute::* | child::text:a">
                        <xsl:with-param name="globalData" select="$globalData" />
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <!-- !!Check if paragraph is empty!!
                        OOo writes out empty paragraphs layouted behind an image (= draw:image within draw:frame)
                        those have to be neglected in HTML -->
                    <xsl:when test="name() = 'text:p' and not($childText) and not(*)">
                        <xsl:variable name="isFollowingImage">
                            <xsl:call-template name="follows-empty-paragraphs-and-image">
                                <xsl:with-param name="precedingElement" select="preceding-sibling::node()[1]"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:if test="$isFollowingImage = 'no'">
                            <xsl:call-template name="create-paragraph">
                                <xsl:with-param name="globalData" select="$globalData" />
                                <xsl:with-param name="footnotePrefix" select="$footnotePrefix" />
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="create-paragraph">
                            <xsl:with-param name="globalData" select="$globalData" />
                            <xsl:with-param name="footnotePrefix" select="$footnotePrefix" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Return the text  -->
    <xsl:template match="text()" mode="getAllTextChildren">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- A span will be created for every text:tab embracing the following text nodes.
        A line break or another text:tab starts a new text:span -->
    <xsl:template match="* | text()" mode="tabHandling">
        <xsl:param name="globalData"/>
        <xsl:param name="tabStops"/>
        <!-- there can be multiple tabs in one line, tabNo guesses the one to apply. By default the first i.e. "1" -->
        <xsl:param name="tabCount" select="0"/>
        <xsl:param name="parentMarginLeft" />
        <xsl:param name="pageMarginLeft" />

<!-- 2DO: EXCHANGE FOLLOWING SIBLING BY VARIABLE -->
        <xsl:variable name="followingSiblingNode" select="following-sibling::node()[1]"/>


        <!--
            Every tabulator indents its following content, encapuslated in a span
            element.

            This template have two modes:

            1) Before the first tabulator it will match as usually paragraph content
            to HTML.
            2) After the first paragraph it will always triggers two recursions.
            One embraces the following content of a paragraph element into a span.
            (tabContentHandling)
            The other calls this template and will now ignore anything else than
            TAB and LINE-BREAK.


            The tabulators and linebreaks are being iterated, one by one to keep track of the tab number
        -->


        <xsl:choose>
            <xsl:when test="name() = 'text:tab'">
                <!-- every frame sibling have to be incapuslated within a div with left indent  -->
                <xsl:element name="span">
                    <xsl:choose>
                        <xsl:when test="count($tabStops/style:tab-stop) &gt; 0 and count($tabStops/style:tab-stop) &lt; 3">
                            <!-- only allow the heuristic when the style has less than 3 TABS -->
                            <!-- ignore heuristics if no TABS are defined -->
                            <xsl:attribute name="style">
                                <xsl:call-template name="createTabIndent">
                                    <xsl:with-param name="globalData" select="$globalData"/>
                                    <xsl:with-param name="tabStops" select="$tabStops"/>
                                    <xsl:with-param name="tabCount" select="$tabCount + 1"/>
                                    <xsl:with-param name="parentMarginLeft" select="$parentMarginLeft"/>
                                    <xsl:with-param name="pageMarginLeft" select="$pageMarginLeft"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- if there are more than 3 TABS in the style, create a none-breakable-space as whitespace -->
                            <xsl:text>&#160;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates select="following-sibling::node()[1]" mode="tabContentHandling">
                        <xsl:with-param name="globalData" select="$globalData"/>
                    </xsl:apply-templates>
                </xsl:element>
                <xsl:apply-templates select="following-sibling::node()[1]" mode="tabHandling">
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="tabStops" select="$tabStops"/>
                    <xsl:with-param name="tabCount" select="$tabCount + 1"/>
                    <xsl:with-param name="parentMarginLeft" select="$parentMarginLeft"/>
                    <xsl:with-param name="pageMarginLeft" select="$pageMarginLeft"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="name() = 'text:line-break'">
                <!-- A line-break resets the tabCount to '0' -->
                <br/>
                <xsl:apply-templates select="following-sibling::node()[1]" mode="tabHandling">
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="tabStops" select="$tabStops"/>
                    <xsl:with-param name="tabCount" select="0"/>
                    <xsl:with-param name="parentMarginLeft" select="$parentMarginLeft"/>
                    <xsl:with-param name="pageMarginLeft" select="$pageMarginLeft"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <!-- only before the first tab all content is written out -->
                <xsl:if test="$tabCount = 0">
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="globalData" select="$globalData"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:apply-templates select="following-sibling::node()[1]" mode="tabHandling">
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="tabStops" select="$tabStops"/>
                    <xsl:with-param name="tabCount" select="$tabCount"/>
                    <xsl:with-param name="parentMarginLeft" select="$parentMarginLeft"/>
                    <xsl:with-param name="pageMarginLeft" select="$pageMarginLeft"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        This recursion creates the content of a tab (i.e. following siblings
        till next TAB or LINE BREAK) and ends with the next
        TAB, LINE-BREAK or with the end of the paragraph.
     -->
    <xsl:template match="* | text()" mode="tabContentHandling">
        <xsl:param name="globalData"/>

        <xsl:if test="(name() != 'text:tab') and (name() != 'text:line-break')">
            <!-- Write out content -->
            <xsl:apply-templates select=".">
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:apply-templates>
            <!-- Apply for the next node -->
            <xsl:apply-templates select="following-sibling::node()[1]" mode="tabContentHandling">
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <xsl:template name="createTabIndent">
        <xsl:param name="globalData"/>
        <xsl:param name="tabStops"/>
        <xsl:param name="tabCount"/>
        <xsl:param name="parentMarginLeft" />
        <xsl:param name="pageMarginLeft" />

        <xsl:text>position:absolute;left:</xsl:text>
        <xsl:variable name="tabPosition">
            <xsl:call-template name="convert2cm">
                <xsl:with-param name="value" select="$tabStops/style:tab-stop[$tabCount]/@style:position"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="tabIndent">
            <xsl:choose>
                <xsl:when test="$tabStops/style:tab-stop[$tabCount]/@style:type = 'center'">
                    <!-- in case of style:type 'center' the text is even before the tab stop,
                      centered around the beginning. As I see currently no way in mapping this,
                      therefore I do some HEURISTIC (minus -2.5cm) -->
                    <xsl:value-of select="$tabPosition + $parentMarginLeft + $pageMarginLeft - 2.5"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$tabPosition + $parentMarginLeft + $pageMarginLeft"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--<xsl:message>TAB: tabCount=
            <xsl:value-of select="$tabCount"/>, tabPosition=
            <xsl:value-of select="$tabPosition"/>, tabIndent=
            <xsl:value-of select="$tabIndent"/>
        </xsl:message>-->
        <xsl:choose>
            <xsl:when test="$tabIndent='NaN'">
                <xsl:variable name="tabPositionTmp">
                    <xsl:call-template name="convert2cm">
                        <xsl:with-param name="value" select="$tabStops/style:tab-stop[last()]/@style:position"/>
                    </xsl:call-template>
                </xsl:variable>
                    <!-- Heuristic: for every tab that is more than specified give a further 1 cm -->
                <xsl:value-of select="$parentMarginLeft + $tabPositionTmp + count($tabStops/style:tab-stop) - $tabCount"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$tabIndent"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>cm;</xsl:text>
        <xsl:apply-templates select="$tabStops/style:tab-stop[$tabCount]/@style:type"/>
    </xsl:template>

    <!-- OOo writes out empty paragraphs layouted behind an image,
        those have to be neglected in HTML
    This method checks if an empty paragraph is of that kind! -->
    <xsl:template name="follows-empty-paragraphs-and-image">
        <xsl:param name="precedingElement" />
        <xsl:param name="elementToCheck" select="1"/>
        <xsl:choose>
            <!-- OOo writes out empty paragraphs layouted behind the image,
                those have to be neglected in HTML
            <xsl:when test="name() = 'text:p' and (normalize-space($childText) = '')"> -->
                <!-- WorkAround: Test if the empty paragraph was added after an image, which OOO often does -->
            <xsl:when test="(name($precedingElement) = 'text:p' and not($precedingElement/text()) and not($precedingElement/*))">
                <xsl:call-template name="follows-empty-paragraphs-and-image">
                    <xsl:with-param name="precedingElement" select="preceding-sibling::*[$elementToCheck]"/>
                    <xsl:with-param name="elementToCheck" select="$elementToCheck +1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$precedingElement/draw:frame">yes</xsl:when>
            <xsl:otherwise>no</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="create-paragraph">
        <xsl:param name="globalData"/>
        <!-- the footnote symbol is the prefix for a footnote in the footer -->
        <xsl:param name="footnotePrefix"/>

        <!-- xhtml:p may only contain inline elements.
             If there is one frame beyond, div must be used! -->
        <xsl:variable name="elementName">
            <xsl:choose>
                <xsl:when test="descendant::draw:frame[1] or descendant::text:p[1]">div</xsl:when>
                <xsl:otherwise>p</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="{$elementName}">
            <xsl:choose>
                <!-- in ODF borders of paragraphs will be merged by default. Merging means the adjacent paragraphs are building a unit,
                    where only the first and the last will have a border to the surrounding (top / bottom border)
                                                <xsl:variable name="precedingParagraphStyle" select="preceding-sibling::*[1][name() = 'text:p']/@text:style-name"/>
                    <xsl:variable name="followingParagraphStyle" select="following-sibling::*[1][name() = 'text:p']/@text:style-name"/>
                    -->
                <xsl:when test="$globalData/all-styles/style[@style:name = current()/@text:style-name]/@mergedBorders">
                    <xsl:variable name="precedingParagraphStyle" select="preceding-sibling::*[1][name() = 'text:p']/@text:style-name"/>
                    <xsl:variable name="followingParagraphStyle" select="following-sibling::*[1][name() = 'text:p']/@text:style-name"/>
                    <xsl:choose>
                        <xsl:when test="$precedingParagraphStyle or $followingParagraphStyle">
                            <xsl:variable name="isPrecedingBorderParagraph" select="$globalData/all-styles/style[@style:name = $precedingParagraphStyle]/@mergedBorders"/>
                            <xsl:variable name="isFollowingBorderParagraph" select="$globalData/all-styles/style[@style:name = $followingParagraphStyle]/@mergedBorders"/>
                            <xsl:choose>
                                <xsl:when test="not($isPrecedingBorderParagraph) and $isFollowingBorderParagraph">
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="concat(translate(@text:style-name, '.,;: %()[]/\+', '_____________'), '_borderStart')"/>
                                    </xsl:attribute>
                                    <xsl:apply-templates>
                                        <xsl:with-param name="globalData" select="$globalData"/>
                                    </xsl:apply-templates>
                                </xsl:when>
                                <xsl:when test="$isPrecedingBorderParagraph and not($isFollowingBorderParagraph)">
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="concat(translate(@text:style-name, '.,;: %()[]/\+', '_____________'), '_borderEnd')"/>
                                    </xsl:attribute>
                                    <xsl:apply-templates>
                                        <xsl:with-param name="globalData" select="$globalData"/>
                                    </xsl:apply-templates>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="translate(@text:style-name, '.,;: %()[]/\+', '_____________')"/>
                                    </xsl:attribute>
                                    <xsl:apply-templates>
                                        <xsl:with-param name="globalData" select="$globalData"/>
                                    </xsl:apply-templates>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="write-paragraph">
                                <xsl:with-param name="globalData" select="$globalData"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="write-paragraph">
                        <xsl:with-param name="globalData" select="$globalData" />
                        <xsl:with-param name="footnotePrefix" select="$footnotePrefix" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template name="write-paragraph">
        <xsl:param name="globalData"/>
        <!-- the footnote symbol is the prefix for a footnote in the footer -->
        <xsl:param name="footnotePrefix" />

            <!-- empty paragraph tags does not provoke a carriage return,
                therefore a non breakable space (&nbsp) have been inserted.-->
        <xsl:choose>
            <xsl:when test="node()">
                <xsl:call-template name="apply-styles-and-content">
                    <xsl:with-param name="globalData" select="$globalData" />
                    <xsl:with-param name="footnotePrefix" select="$footnotePrefix" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="apply-styles-and-content">
                    <xsl:with-param name="globalData" select="$globalData" />
                    <xsl:with-param name="footnotePrefix" select="$footnotePrefix" />
                </xsl:call-template>
                <xsl:text>&#160;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="style:tab-stop/@style:type">
        <xsl:text>text-align:</xsl:text>
        <xsl:choose>
            <xsl:when test=". = 'left'">left</xsl:when>
            <xsl:when test=". = 'right'">right</xsl:when>
            <xsl:when test=". = 'center'">center</xsl:when>
            <xsl:otherwise>justify</xsl:otherwise>
        </xsl:choose>
        <xsl:text>;</xsl:text>
    </xsl:template>

    <!-- As soon a frame is within a paragraph (text:p) or page:frame, every child element is  floating (CSS) and worked out in sequence.
    Accumulating prior frame width and adding parent's left margin -->
    <!-- Matching all elements and text beyond a paragraph/text:page which are sibling of a draw:frame -->
    <xsl:template match="* | text()" mode="frameFloating">
        <xsl:param name="globalData"/>
        <xsl:param name="previousFrameWidths" select="0"/>
        <xsl:param name="previousFrameHeights" select="0" />
        <!-- it becomes true for siblings after a draw:frame  -->
        <xsl:param name="createDiv" select="false()"/>
        <xsl:param name="noDivBefore" select="true()"/>
        <xsl:param name="leftPosition" />
        <xsl:param name="parentMarginLeft" />
        <xsl:param name="frameAlignedToParagraphWithSvgY" />

        <xsl:choose>
            <xsl:when test="name() = 'draw:frame'">
                <xsl:copy-of select="$frameAlignedToParagraphWithSvgY"/>

                <!-- if the first node is a draw:frame create a div -->
                <xsl:call-template name="createDrawFrame">
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="previousFrameWidths" select="$previousFrameWidths"/>
                    <xsl:with-param name="previousFrameHeights" select="$previousFrameHeights"/>
                    <xsl:with-param name="parentMarginLeft" select="$parentMarginLeft"/>
                </xsl:call-template>
                <!-- next elements will be called after the creation with the new indent (plus width of frame) -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="nextSiblingIsFrame" select="name(following-sibling::node()[1]) = 'draw:frame'"/>
                <xsl:choose>
                    <xsl:when test="$createDiv and normalize-space(.) != ''">
                        <!-- every following frame sibling till the next draw:frame
                            have to be incapuslated within a div with left indent.
                            To be moved altogether according the indent (usually right) -->
                        <xsl:comment>Next 'div' added for floating.</xsl:comment>
                        <xsl:element name="div">
                            <xsl:attribute name="style">
                                <xsl:text>position:relative; left:</xsl:text>
                                <xsl:value-of select="$leftPosition"/>
                                <xsl:text>cm;</xsl:text>
                            </xsl:attribute>
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="globalData" select="$globalData"/>
                            </xsl:apply-templates>
                            <!-- if it is a frame sibling it will be NOT incapuslated within the div (as already within one) -->
                            <xsl:if test="not($nextSiblingIsFrame)">
                                <xsl:apply-templates select="following-sibling::node()[1]" mode="frameFloating">
                                    <xsl:with-param name="globalData" select="$globalData"/>
                                    <xsl:with-param name="previousFrameWidths" select="$previousFrameWidths"/>
                                    <xsl:with-param name="previousFrameHeights" select="$previousFrameHeights"/>
                                    <xsl:with-param name="parentMarginLeft" select="$parentMarginLeft"/>
                                    <xsl:with-param name="leftPosition" select="$leftPosition"/>
                                    <xsl:with-param name="createDiv" select="false()"/>
                                    <xsl:with-param name="noDivBefore" select="$noDivBefore"/>
                                    <xsl:with-param name="frameAlignedToParagraphWithSvgY" select="$frameAlignedToParagraphWithSvgY"/>
                                </xsl:apply-templates>
                            </xsl:if>
                        </xsl:element>
                        <xsl:copy-of select="$frameAlignedToParagraphWithSvgY"/>

                        <!-- Other draw:frame will be created outside of the div element  -->
                        <xsl:apply-templates select="following-sibling::draw:frame[1]" mode="frameFloating">
                            <xsl:with-param name="globalData" select="$globalData"/>
                            <xsl:with-param name="previousFrameWidths" select="$previousFrameWidths"/>
                            <xsl:with-param name="previousFrameHeights" select="$previousFrameHeights"/>
                            <xsl:with-param name="parentMarginLeft" select="$parentMarginLeft"/>
                            <xsl:with-param name="leftPosition" select="$leftPosition"/>
                            <xsl:with-param name="frameAlignedToParagraphWithSvgY" select="$frameAlignedToParagraphWithSvgY"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="not($createDiv)">
                        <xsl:apply-templates select=".">
                            <xsl:with-param name="globalData" select="$globalData"/>
                            <xsl:with-param name="frameAlignedToParagraphWithSvgY" select="$frameAlignedToParagraphWithSvgY"/>
                        </xsl:apply-templates>
                        <xsl:if test="not($nextSiblingIsFrame) or $noDivBefore">
                            <xsl:apply-templates select="following-sibling::node()[1]" mode="frameFloating">
                                <xsl:with-param name="globalData" select="$globalData"/>
                                <xsl:with-param name="previousFrameWidths" select="$previousFrameWidths"/>
                                <xsl:with-param name="previousFrameHeights" select="$previousFrameHeights"/>
                                <xsl:with-param name="parentMarginLeft" select="$parentMarginLeft"/>
                                <xsl:with-param name="leftPosition" select="$leftPosition"/>
                                <xsl:with-param name="createDiv" select="false()"/>
                                <xsl:with-param name="noDivBefore" select="$noDivBefore"/>
                                <xsl:with-param name="frameAlignedToParagraphWithSvgY" select="$frameAlignedToParagraphWithSvgY"/>
                            </xsl:apply-templates>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- A XML node other than text or element (e.g. comment) should not stop the recursion  -->
    <xsl:template match="comment()" mode="frameFloating">
        <xsl:param name="globalData"/>
        <xsl:param name="previousFrameWidths" select="0"/>
        <xsl:param name="previousFrameHeights" select="0" />
        <!-- it becomes true for siblings after a draw:frame  -->
        <xsl:param name="createDiv" select="false()"/>
        <xsl:param name="noDivBefore" select="true()"/>
        <xsl:param name="leftPosition" />
        <xsl:param name="parentMarginLeft" />
        <xsl:param name="frameAlignedToParagraphWithSvgY" />

        <xsl:apply-templates select="following-sibling::node()[1]" mode="frameFloating">
            <xsl:with-param name="globalData" select="$globalData"/>
            <xsl:with-param name="previousFrameWidths" select="$previousFrameWidths"/>
            <xsl:with-param name="parentMarginLeft" select="$parentMarginLeft"/>
            <xsl:with-param name="leftPosition" select="$leftPosition"/>
            <xsl:with-param name="createDiv" select="$createDiv"/>
            <xsl:with-param name="noDivBefore" select="$noDivBefore"/>
        </xsl:apply-templates>
    </xsl:template>



    <!-- As draw:frame may occur within more elements than in text:p and draw:page -->
    <xsl:template match="draw:frame">
        <xsl:param name="globalData"/>
        <xsl:param name="previousFrameWidths" select="0"/>
        <xsl:param name="previousFrameHeights" select="0" />

        <xsl:call-template name="createDrawFrame">
            <xsl:with-param name="globalData" select="$globalData" />
            <xsl:with-param name="previousFrameWidths" select="$previousFrameWidths"/>
            <xsl:with-param name="previousFrameHeights" select="$previousFrameHeights"/>
        </xsl:call-template>
        <!-- after the last draw:frame sibling the CSS float is disabled -->
        <xsl:if test="@text:anchor-type!='as-char'">
            <div style="clear:both; line-height:0; width:0; height:0; margin:0; padding:0;">&#160;</div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="getPageMarginLeft">
        <!-- approximation to find the correct master page style (with page dimensions) -->
        <xsl:variable name="masterPageNames">
            <!-- Loop over every style:style containing a @style:master-page-name attribute -->
            <xsl:for-each select="key('masterPage','count')">
                    <!-- Check if this style is being used in the body -->
                <xsl:if test="key('elementUsingStyle', ../@style:name)">
                        <!-- Check every master-page-name if it is not empty and return as ';' separated list  -->
                    <xsl:if test="string-length(../@style:master-page-name) &gt; 0">
                        <xsl:value-of select="../@style:master-page-name"/>;
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <!-- Take the first of the masterpage list and get the according style:master-page element and find the @style:page-layout-name  -->
        <xsl:variable name="pageLayoutName" select="key('masterPageElements', substring-before($masterPageNames,';'))/@style:page-layout-name"/>
         <!-- Find the according style:page-layout and store the properties in a variable  -->
        <xsl:variable name="pageMarginLeftAttr" select="key('pageLayoutElements', $pageLayoutName)/style:page-layout-properties/@fo:margin-left"/>
        <xsl:choose>
            <xsl:when test="$pageMarginLeftAttr">
                <xsl:call-template name="convert2cm">
                    <xsl:with-param name="value" select="$pageMarginLeftAttr"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Elements and text aside of a draw:frame are floating, here a div is being created.
        Either for a draw:frame or for text and other elements floating aside -->
    <xsl:template name="createDrawFrame">
        <xsl:param name="globalData"/>
        <xsl:param name="previousFrameWidths" select="0"/>
        <xsl:param name="previousFrameHeights" select="0" />
        <xsl:param name="parentMarginLeft"/>

        <xsl:variable name="parentMarginLeftNew">
            <xsl:choose>
                <xsl:when test="string-length(normalize-space($parentMarginLeft)) &lt; 1">
                    <!-- Styles of first paragraph in list item, including ancestor styles (inheritance) -->
                    <xsl:variable name="paragraphName" select="parent::*/@text:style-name" />
                    <xsl:variable name="imageParagraphStyle" select="$globalData/all-styles/style[@style:name = $paragraphName]/final-properties"/>
                    <!-- Only the left margin of the first paragraph of a list item will be added to the margin of the complete list (all levels)-->
                    <xsl:choose>
                        <xsl:when test="contains($imageParagraphStyle, 'margin-left:')">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="normalize-space(substring-before(substring-after($imageParagraphStyle, 'margin-left:'), ';'))"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$parentMarginLeft"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="svgWidth">
            <xsl:choose>
                <xsl:when test="@svg:width">
                    <xsl:call-template name="convert2cm">
                        <xsl:with-param name="value" select="@svg:width"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="svgX">
            <xsl:choose>
                <xsl:when test="@svg:x">
                    <xsl:call-template name="convert2cm">
                        <xsl:with-param name="value" select="@svg:x"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="leftPosition" select="$svgX - $parentMarginLeftNew - $previousFrameWidths"/>
        <xsl:variable name="svgY">
            <xsl:choose>
                <xsl:when test="@svg:y">
                    <xsl:call-template name="convert2cm">
                        <xsl:with-param name="value" select="@svg:y"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- if the frame is anchored on a paragraph -->
        <xsl:if test="@text:anchor-type='paragraph'">
            <xsl:comment>Next 'div' is emulating the top height of a draw:frame.</xsl:comment>
            <!-- When the svg:y is set relative to the paragraph content, the best way to emulate a positive height,
             is to add an invisible division inbetween with a height.
             Often text will flow into this 'gap', which is handled separately!
             -->
            <xsl:if test="$svgY &gt; 0">
                <xsl:element name="div">
                    <xsl:attribute name="style">
                        <xsl:text>height:</xsl:text>
                        <xsl:value-of select="$svgY"/>
                        <xsl:text>cm;</xsl:text>
                    </xsl:attribute>
                    <xsl:text>&#160;</xsl:text>
                </xsl:element>
            </xsl:if>
        </xsl:if>


      <!--
        <xsl:variable name="followingSibling" select="following-sibling::node()[1]"/>
        <xsl:choose>
           HEURISTIC: if the frame is anchored on a paragraph and the above gab is big enough to hold a text line,
                move it behind the text
            <xsl:when test="@text:anchor-type='paragraph' and
                (
                    ($svgY &gt; 0.5) or
                    ($svgX &gt; 4)
                ) and normalize-space($followingSibling) != ''">
                <xsl:apply-templates select="$followingSibling" mode="frameFloating">
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="previousFrameWidths" select="$previousFrameWidths + $svgWidth"/>
                    <xsl:with-param name="parentMarginLeft" select="$parentMarginLeftNew"/>
                    <xsl:with-param name="leftPosition" select="$leftPosition"/>
                    <xsl:with-param name="createDiv" select="true()"/>
                    <xsl:with-param name="noDivBefore" select="false()"/>
                    <xsl:with-param name="frameAlignedToParagraphWithSvgY">
                        <xsl:call-template name="createDrawFrame2">
                            <xsl:with-param name="globalData" select="$globalData"/>
                            <xsl:with-param name="previousFrameWidths" select="$previousFrameWidths + $svgWidth"/>
                            <xsl:with-param name="parentMarginLeftNew" select="$parentMarginLeftNew"/>
                            <xsl:with-param name="leftPosition" select="$leftPosition"/>
                            <xsl:with-param name="svgY" select="$svgY"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>-->
        <xsl:call-template name="createDrawFrame2">
            <xsl:with-param name="globalData" select="$globalData"/>
            <xsl:with-param name="previousFrameWidths" select="$previousFrameWidths + $svgWidth"/>
            <xsl:with-param name="parentMarginLeftNew" select="$parentMarginLeftNew"/>
            <xsl:with-param name="leftPosition" select="$leftPosition"/>
            <xsl:with-param name="svgY" select="$svgY"/>
        </xsl:call-template>
        <xsl:apply-templates select="following-sibling::node()[1]" mode="frameFloating">
            <xsl:with-param name="globalData" select="$globalData"/>
            <xsl:with-param name="previousFrameWidths" select="$previousFrameWidths + $svgWidth"/>
            <xsl:with-param name="parentMarginLeft" select="$parentMarginLeftNew"/>
            <xsl:with-param name="leftPosition" select="$leftPosition"/>
            <xsl:with-param name="createDiv" select="true()"/>
            <xsl:with-param name="noDivBefore" select="false()"/>
        </xsl:apply-templates>
                <!--

            </xsl:otherwise>
        </xsl:choose> -->
    </xsl:template>

    <xsl:template name="createDrawFrame2">
        <xsl:param name="globalData"/>
        <xsl:param name="previousFrameWidths" />
        <xsl:param name="parentMarginLeftNew"/>
        <xsl:param name="leftPosition" />
        <xsl:param name="svgY" />

        <xsl:variable name="elem-name">
            <xsl:choose>
                <xsl:when test="@text:anchor-type='as-char'">span</xsl:when>
                <xsl:otherwise>div</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:comment>Next '
            <xsl:value-of select="$elem-name"/>' is a draw:frame.
        </xsl:comment>
        <xsl:element name="{$elem-name}">
            <xsl:choose>
                <xsl:when test="draw:object/math:math">
                    <!-- draw:frame elements contain many data that are not
                    relevant for mathematical formulas and that may
                    cause incorrect rendering. Let's ignore the
                    replacement image and keep only the id attribute.
                    See fdo#66645 -->
                    <xsl:apply-templates select="@draw:name"/>
                        <xsl:text> </xsl:text>
                    <xsl:apply-templates select="draw:object[1]"/>
                    <!-- TODO: do not always add a space after the formula,
                    for example when it is followed by a comma, period,
                    dash etc This will probably require using regexp
                    features like xsl:analyze-string -->
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="style">
                    <xsl:call-template name="widthAndHeight"/>
                    <xsl:text> padding:0; </xsl:text>
                    <xsl:if test="@text:anchor-type!='as-char'">
                        <!-- all images float (CSS float relative) with a left position calculated by svg:x - parentMarginLeft - previousFrameWidths -->
                        <xsl:text> float:left; position:relative; left:</xsl:text>
                        <xsl:value-of select="$leftPosition"/>
                        <xsl:text>cm; </xsl:text>
                        <!-- if the frame is anchored on a char -->
                        <xsl:if test="@text:anchor-type='char'">
                            <xsl:text>top:</xsl:text>
                            <xsl:value-of select="$svgY"/>
                            <xsl:text>cm; </xsl:text>
                        </xsl:if>
                    </xsl:if>
                </xsl:attribute>
                <xsl:apply-templates select="@*">
                    <xsl:with-param name="globalData" select="$globalData"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="node()">
                    <xsl:with-param name="globalData" select="$globalData"/>
                </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="svg:desc"/>

    <xsl:template name="widthAndHeight">
        <xsl:if test="@svg:height | @svg:width">
            <xsl:choose>
                <xsl:when test="not(@svg:width)">
                    <xsl:call-template name="svg:height"/>
                </xsl:when>
                <xsl:when test="not(@svg:height)">
                    <xsl:call-template name="svg:width"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="svg:height"/>
                    <xsl:call-template name="svg:width"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- ***************** -->
    <!-- *** Text Span *** -->
    <!-- ***************** -->

    <xsl:template match="text:span">
        <xsl:param name="globalData"/>

        <xsl:choose>
            <xsl:when test="draw:frame">
                <!-- sometimes an ODF image is anchored as character and the
                    image frame appears within a span (which is not valid for HTML)
                    Heuristic: Neglecting the span assuming no text content aside
                    of frame within span -->
                <xsl:apply-templates>
                    <xsl:with-param name="globalData" select="$globalData"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="span">
                    <xsl:call-template name="apply-styles-and-content">
                        <xsl:with-param name="globalData" select="$globalData"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!-- **************** -->
    <!-- *** Headings *** -->
    <!-- **************** -->

    <xsl:template match="text:h">
        <xsl:param name="globalData"/>

        <!-- no creation of empty headings (without text content)   -->
        <xsl:if test="text() or descendant::text()">
            <!-- The URL linking of a table-of-content is due to a bug (cp. bug id# 102311) not mapped as URL in the XML.
                 Linking of the table-of-content can therefore only be achieved by a work-around in HTML -->
            <xsl:call-template name="create-heading">
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- default matching for header elements -->
    <xsl:template name="create-heading">
        <xsl:param name="globalData"/>

        <xsl:variable name="headingLevel">
            <xsl:choose>
                <xsl:when test="@text:outline-level &lt; 6">
                    <xsl:value-of select="@text:outline-level"/>
                </xsl:when>
                <xsl:otherwise>6</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="headertyp" select="concat('h', $headingLevel)"/>
        <xsl:element name="{$headertyp}">
            <!-- outline style 'text:min-label-width' is interpreted as a CSS 'margin-right' attribute
            NOTE: Should be handled as CSS style in style header -->
            <xsl:variable name="min-label" select="$globalData/office:styles/text:outline-style/text:outline-level-style[@text:level = current()/@text:outline-level]/*/@text:min-label-width"/>
            <xsl:attribute name="class">
                <xsl:value-of select="translate(@text:style-name, '.,;: %()[]/\+', '_____________')"/>
            </xsl:attribute>

            <xsl:call-template name="create-heading-anchor">
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:call-template>

            <xsl:apply-templates>
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:apply-templates>
        </xsl:element>

    </xsl:template>

    <xsl:template name="create-heading-anchor">
        <xsl:param name="globalData"/>

        <!-- writing out a heading number if desired.-->
        <!-- if a corresponding 'text:outline-style' exist or is not empty -->
        <xsl:choose>
            <xsl:when test="$globalData/office:styles/text:outline-style/text:outline-level-style[@text:level = current()/@text:outline-level]/@style:num-format != '' and not(@text:is-list-header='true')">

                <!-- Every heading element will get a unique anchor for its file, from its hierarchy level and name:
                     For example:  The heading title 'My favorite heading' might get <a name="1_2_2_My_favorite_heading" /> -->
                <!-- creating an anchor for referencing the heading (e.g. from content table) -->
                <xsl:variable name="headingNumber">
                    <xsl:call-template name="get-heading-number">
                        <xsl:with-param name="globalData" select="$globalData"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="create-heading-anchor2">
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="headingNumber" select="$headingNumber"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="create-heading-anchor2">
                    <xsl:with-param name="globalData" select="$globalData"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="get-heading-number">
        <xsl:param name="globalData"/>

        <!-- write number prefix -->
        <xsl:value-of select="$globalData/office:styles/text:outline-style/text:outline-level-style[@text:level = current()/@text:outline-level]/@style:num-prefix"/>
        <xsl:call-template name="write-heading-number">
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:call-template>
        <!-- write number suffix -->
        <xsl:value-of select="$globalData/office:styles/text:outline-style/text:outline-level-style[@text:level = current()/@text:outline-level]/@style:num-suffix"/>
    </xsl:template>

    <!-- creating an anchor for referencing the heading -->
    <xsl:template name="create-heading-anchor2">
        <xsl:param name="globalData"/>
        <xsl:param name="headingNumber" />

        <xsl:variable name="title">
            <xsl:apply-templates mode="concatenate"/>
        </xsl:variable>
        <!-- REFERENCE HANDLING - ANCHOR -->
        <xsl:element namespace="{$namespace}" name="a">
            <xsl:attribute name="id">
                <xsl:value-of select="translate(concat('a_',normalize-space($headingNumber), '_', normalize-space($title)), '&#xA;&amp;&lt;&gt;–.,;: %()[]/\+', '____________________________')" disable-output-escaping="yes"/>
            </xsl:attribute>

            <xsl:element name="span">
                <!-- Convert the "label-followed-by" to margins. According to ODF, possible values are: 'listtab', 'space', and 'nothing'.
                'space' seems not to be written out by LO, and for 'nothing' we obviously need do nothing.
                NOTE: Should be handled as CSS style in style header -->
                <xsl:variable name="currentOutlineLevel" select="@text:outline-level"/>
                <xsl:variable name="labelFollowedBy" select="$globalData//office:document/office:styles/text:outline-style/text:outline-level-style[@text:level = $currentOutlineLevel]/style:list-level-properties[@text:list-level-position-and-space-mode='label-alignment']/style:list-level-label-alignment/@text:label-followed-by"/>

                <!-- Add some margin, but only if there is a number preceding the heading. -->
                <xsl:if test="$labelFollowedBy='listtab' and $headingNumber != ''">
                    <xsl:attribute name="class">
                        <xsl:text>heading_numbering</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="$headingNumber"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="write-heading-number">
        <xsl:param name="globalData"/>

        <!-- By default heading start with '1', the parameter 'textStartValue' will only be set, if the attribute @text:start-value exist -->
        <xsl:choose>
            <xsl:when test="$globalData/office:styles/text:outline-style/text:outline-level-style[@text:level = current()/@text:outline-level]/@text:start-value">
                <xsl:call-template name="calc-heading-number">
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="outlineLevel" select="@text:outline-level"/>
                    <xsl:with-param name="textStartValue" select="$globalData/office:styles/text:outline-style/text:outline-level-style[@text:level = current()/@text:outline-level]/@text:start-value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="calc-heading-number">
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="outlineLevel" select="@text:outline-level"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    Find the correct heading no., which is the sum of 'text:start-value'
    and preceding siblings of 'text:h' with the same 'text:outline-level' (until a text:outline-level with lower value is found).
    If the 'text:start-value is not set the default value of '1' has to be taken.
    If a heading number is found (e.g. text:outline-level='3') all heading numbers
    for the higher levels have to be written out -->
    <xsl:template name="calc-heading-number">
        <xsl:param name="globalData"/>
        <xsl:param name="outlineLevel"/><!-- text level of the heading -->
        <xsl:param name="iOutlineLevel" select="1"/><!-- iterator, counts from 1 to the text level of the heading -->
        <xsl:param name="textStartValue" select="1"/><!-- text level to start with, default is '1' -->

        <xsl:choose>
            <!-- iText levels counts up from '1' to outlineLevel
                Which means writing a heading number from left to right -->
            <xsl:when test="$iOutlineLevel &lt; $outlineLevel">

            <!-- Write preceding heading numbers -->
                <xsl:if test="$globalData/office:styles/text:outline-style/text:outline-level-style[@text:level = ($iOutlineLevel)]/@style:num-format != ''">
                    <xsl:call-template name="writeNumber">
                        <xsl:with-param name="numberDigit">
                            <xsl:call-template name="calc-heading-digit">
                                <xsl:with-param name="value" select="0"/>
                                <xsl:with-param name="currentoutlineLevel" select="$iOutlineLevel"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="numberFormat" select="$globalData/office:styles/text:outline-style/text:outline-level-style[@text:level = ($iOutlineLevel)]/@style:num-format"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$globalData/office:styles/text:outline-style/text:outline-level-style[@text:level = ($iOutlineLevel + 1)]/@text:start-value">
                        <xsl:call-template name="calc-heading-number">
                            <xsl:with-param name="globalData" select="$globalData"/>
                            <xsl:with-param name="outlineLevel" select="$outlineLevel"/>
                            <xsl:with-param name="iOutlineLevel" select="$iOutlineLevel + 1"/>
                            <xsl:with-param name="textStartValue" select="$globalData/office:styles/text:outline-style/text:outline-level-style[@text:level = ($iOutlineLevel + 1)]/@text:start-value"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="calc-heading-number">
                            <xsl:with-param name="globalData" select="$globalData"/>
                            <xsl:with-param name="outlineLevel" select="$outlineLevel"/>
                            <xsl:with-param name="iOutlineLevel" select="$iOutlineLevel + 1"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- Write preceding heading numbers -->
                <xsl:call-template name="writeNumber">
                    <xsl:with-param name="numberDigit">
                        <xsl:call-template name="calc-heading-digit">
                            <xsl:with-param name="value" select="$textStartValue"/>
                            <xsl:with-param name="currentoutlineLevel" select="$iOutlineLevel"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="numberFormat" select="$globalData/office:styles/text:outline-style/text:outline-level-style[@text:level = $iOutlineLevel]/@style:num-format"/>
                    <xsl:with-param name="last" select="true()"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="writeNumber">
        <xsl:param name="numberDigit"/>
        <xsl:param name="numberFormat"/>
        <xsl:param name="last"/>

        <xsl:choose>
            <xsl:when test="not($numberFormat)">
                <xsl:number value="$numberDigit" format="1."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$last">
                        <xsl:number value="$numberDigit" format="{$numberFormat}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:number value="$numberDigit" format="{$numberFormat}."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="calc-heading-digit">
        <xsl:param name="value"/>
        <xsl:param name="currentoutlineLevel"/>
        <xsl:param name="i" select="1"/>

        <xsl:variable name="precedingHeading" select="preceding-sibling::text:h[@text:outline-level &lt;= $currentoutlineLevel][$i]"/>
        <xsl:variable name="precedingoutlineLevel" select="$precedingHeading/@text:outline-level"/>
        <!-- tdf#107696: if text:h has attribute "is-list-header" with "true" value, it mustn't be counted for numbering -->
        <xsl:variable name="precedingoutlineLevel-is-list-header" select="$precedingHeading[@text:is-list-header='true']/@text:outline-level"/>
        <xsl:choose>
            <xsl:when test="($currentoutlineLevel = $precedingoutlineLevel) and (not($precedingoutlineLevel-is-list-header)) ">
                <xsl:call-template name="calc-heading-digit">
                    <xsl:with-param name="value" select="$value + 1"/>
                    <xsl:with-param name="currentoutlineLevel" select="$currentoutlineLevel"/>
                    <xsl:with-param name="i" select="$i + 1"/>
                </xsl:call-template>
            </xsl:when>
            <!-- tdf#107696: case text:h has attribute "is-list-header" with "true" value, we don't increment value -->
            <xsl:when test="($currentoutlineLevel = $precedingoutlineLevel) and ($precedingoutlineLevel-is-list-header) ">
                <xsl:call-template name="calc-heading-digit">
                    <xsl:with-param name="value" select="$value"/>
                    <xsl:with-param name="currentoutlineLevel" select="$currentoutlineLevel"/>
                    <xsl:with-param name="i" select="$i + 1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$currentoutlineLevel &lt; $precedingoutlineLevel">
                <xsl:message terminate="yes">this should not happen</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Neglect Annotations -->
    <xsl:template match="office:annotation" mode="concatenate"/>

    <!-- Match text:placeholder child nodes (e.g. text) -->
    <xsl:template match="text:placeholder">
        <xsl:param name="globalData"/>

        <xsl:call-template name="apply-styles-and-content">
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:call-template>
    </xsl:template>

    <!-- ************* -->
    <!-- *** Link  *** -->
    <!-- ************* -->

    <xsl:template match="text:a | draw:a">
        <xsl:param name="globalData"/>

        <xsl:call-template name="create-common-anchor-link">
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="create-common-anchor-link">
        <xsl:param name="globalData"/>

        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:call-template name="create-href">
                    <xsl:with-param name="href" select="@xlink:href"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:call-template name="apply-styles-and-content">
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>



    <!-- ******************* -->
    <!-- *** Image Link  *** -->
    <!-- ******************* -->

    <!-- currently suggesting that all draw:object-ole elements are images -->
    <xsl:template match="draw:image | draw:object-ole">
        <xsl:param name="globalData"/>

        <!-- If there is a replacement graphic, we take it (only exception is if the main image is svg).
             The replacement graphic is a png which browsers are more likely able to render than the
             original graphic which might have arbitrary formats. -->
        <xsl:if test="(@loext:mime-type = 'image/svg+xml') or
                      (@draw:mime-type = 'image/svg+xml') or
                            (not(following-sibling::draw:image) and
                             not((preceding-sibling::draw:image[1]/@loext:mime-type = 'image/svg+xml')
                                 or
                                 (preceding-sibling::draw:image[1]/@draw:mime-type = 'image/svg+xml')))">
            <xsl:choose>
                <xsl:when test="ancestor::text:p or parent::text:span or parent::text:h or parent::draw:a or parent::text:a or text:ruby-base">
                    <!-- XHTML does not allow the mapped elements to contain paragraphs -->
                    <xsl:call-template name="create-image-element">
                        <xsl:with-param name="globalData" select="$globalData"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <!-- images are embedded in a paragraph, but are in CSS not able to express a horizontal alignment for themself.
                        A 'div' element taking over the image style would solve that problem, but is invalid as child of a paragraph -->
                    <xsl:element name="p">
                        <xsl:apply-templates select="@draw:style-name">
                            <xsl:with-param name="globalData" select="$globalData"/>
                        </xsl:apply-templates>

                        <xsl:call-template name="create-image-element">
                            <xsl:with-param name="globalData" select="$globalData"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="create-image-element">
        <xsl:param name="globalData"/>

        <xsl:element name="img">
            <xsl:if test="../@svg:width or ../@svg:height">
                <xsl:attribute name="style">
                    <xsl:if test="../@svg:height">
                        <xsl:text>height:</xsl:text>
                        <xsl:call-template name="convert2cm">
                            <xsl:with-param name="value" select="../@svg:height"/>
                        </xsl:call-template>
                        <xsl:text>cm;</xsl:text>
                    </xsl:if>
                    <xsl:if test="../@svg:width">
                        <xsl:text>width:</xsl:text>
                        <xsl:call-template name="convert2cm">
                            <xsl:with-param name="value" select="../@svg:width"/>
                        </xsl:call-template>
                        <xsl:text>cm;</xsl:text>
                    </xsl:if>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="alt">
                <xsl:choose>
                    <xsl:when test="../svg:title">
                        <xsl:value-of select="../svg:title"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
    Accessibility Warning:
         No alternate text ('svg:title' element) set for
         image '
                            <xsl:value-of select="@xlink:href"/>'!
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <xsl:attribute name="src">
                <xsl:call-template name="create-href">
                    <xsl:with-param name="href" select="@xlink:href"/>
                    <xsl:with-param name="mimetype">
                        <xsl:choose>
                            <xsl:when test="@draw:mime-type">
                                <xsl:value-of select="@draw:mime-type"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@loext:mime-type"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:attribute>

            <!-- style interpretation only, as no subelements are allowed for img in XHTML -->
            <xsl:apply-templates select="@draw:style-name">
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <!-- ************ -->
    <!-- *** list *** -->
    <!-- ************ -->
    <!--
        Due to the requirements below the ODF list functionality is not handled by CSS, but the list labels calculated and written by XSLT.

        REQUIREMENTS:
        =============

        A)
        One significant difference between XHTML and Office List elements is that a list without text nodes but only further list children
        would not show a list symbol in the Office, but in the browser from XHTML.

        B)
        Since OASIS Open Document XML (implemented in OOo2.0) only one parent type exists for list items
        the 'text:list' element. The XHTML element 'ol', 'ul' will be chosen upon the list style type.

        C)
        An Office list may be spread over the whole document. Linked by their style and text:continue-numbering='true'.

        D)
        An Office list can use characters or images as list label.

        E)
        An Office list can have a prefix and suffix around the list label.

        F)
        An Office list style may have the attribute consecutive numbering, which resolves in a list counting for all levels

        G)
        An Office list may (re)start on any arbitrary value by using @text:start-value on the text:list-item

        INDENTATION:
        ============

        The indent of a list label is not only calculated by using the text:space-before of the list level (listLevelStyle), but
        as well taking the left margin of the first paragraph (or heading) of the list into account as loy match="" name="" use=""/>ng it is not negative.

        |           MARGIN LEFT                 |        LABEL           |

        |   text:space-before (listlevelstyle)  | text:min-label-width   |
        | + fo:left-margin (firstParagraph)     |                        |

        Further details beyond text:list-list...
    -->
    <xsl:key name="listStyles" match=" /*/office:styles/text:list-style | /*/office:automatic-styles/text:list-style | /*/office:styles/style:graphic-properties/text:list-style | /*/office:automatic-styles/style:graphic-properties/text:list-style | /*/office:styles/text:list-style | /*/office:automatic-styles/text:list-style | /*/office:styles/style:graphic-properties/text:list-style | /*/office:automatic-styles/style:graphic-properties/text:list-style" use="@style:name"/>

    <!--
        A text list may only have text:list-item and text:list-header as children.
    -->
    <xsl:template match="text:list">
        <xsl:param name="globalData"/>
        <xsl:param name="isListNumberingReset"/>
        <xsl:param name="isNextLevelNumberingReset"/>
        <xsl:param name="listLevel" select="1"/>
        <xsl:param name="listRestart" select="false()"/>
        <xsl:param name="itemLabel" select="''"/>
        <xsl:param name="listStyle"/>
        <xsl:param name="listStyleName" select="@text:style-name"/>

        <!-- To choose list type - get the list style, with the same 'text:style-name' and same 'text:level' >-->
        <xsl:variable name="listStyleRTF">
            <xsl:variable name="listStyleInContentFile" select="key('listStyles', $listStyleName)"/>
            <xsl:choose>
                <xsl:when test="$listStyleInContentFile">
                    <xsl:copy-of select="$listStyleInContentFile"/>
                </xsl:when>
                <xsl:when test="$globalData/office:styles/text:list-style[@style:name = $listStyleName]">
                    <xsl:copy-of select="$globalData/office:styles/text:list-style[@style:name = $listStyleName]"/>
                </xsl:when>
                <xsl:when test="$globalData/office:styles/style:graphic-properties/text:list-style[@style:name = $listStyleName]">
                    <xsl:copy-of select="$globalData/office:styles/style:graphic-properties/text:list-style[@style:name = $listStyleName]"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="function-available('common:node-set')">
                <xsl:call-template name="create-list-type">
                    <xsl:with-param name="listStyle" select="common:node-set($listStyleRTF)" />
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="isListNumberingReset" select="$isListNumberingReset"/>
                    <xsl:with-param name="isNextLevelNumberingReset" select="$isNextLevelNumberingReset"/>
                    <xsl:with-param name="listLevel" select="$listLevel"/>
                    <xsl:with-param name="listRestart" select="$listRestart"/>
                    <xsl:with-param name="itemLabel" select="$itemLabel"/>
                    <xsl:with-param name="listStyleName" select="$listStyleName" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xalan:nodeset')">
                <xsl:call-template name="create-list-type">
                    <xsl:with-param name="listStyle" select="xalan:nodeset($listStyleRTF)" />
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="isListNumberingReset" select="$isListNumberingReset"/>
                    <xsl:with-param name="isNextLevelNumberingReset" select="$isNextLevelNumberingReset"/>
                    <xsl:with-param name="listLevel" select="$listLevel"/>
                    <xsl:with-param name="listRestart" select="$listRestart"/>
                    <xsl:with-param name="itemLabel" select="$itemLabel"/>
                    <xsl:with-param name="listStyleName" select="$listStyleName" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xt:node-set')">
                <xsl:call-template name="create-list-type">
                    <xsl:with-param name="listStyle" select="xt:node-set($listStyleRTF)" />
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="isListNumberingReset" select="$isListNumberingReset"/>
                    <xsl:with-param name="isNextLevelNumberingReset" select="$isNextLevelNumberingReset"/>
                    <xsl:with-param name="listLevel" select="$listLevel"/>
                    <xsl:with-param name="listRestart" select="$listRestart"/>
                    <xsl:with-param name="itemLabel" select="$itemLabel"/>
                    <xsl:with-param name="listStyleName" select="$listStyleName" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">The required node-set function was not found!</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="create-list-type">
        <xsl:param name="globalData"/>
        <xsl:param name="isListNumberingReset"/>
        <xsl:param name="isNextLevelNumberingReset"/>
        <xsl:param name="listLevel" />
        <xsl:param name="listRestart" />
        <xsl:param name="itemLabel"/>
        <xsl:param name="listStyle"/>
        <xsl:param name="listStyleName" />

        <!-- $globalData/styles-file/*/office:styles/ -->
        <xsl:variable name="listLevelStyle" select="$listStyle/*/*[@text:level = number($listLevel)]"/>
        <xsl:variable name="listIndent">
            <xsl:call-template name="getListIndent">
                <xsl:with-param name="globalData" select="$globalData"/>
                <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                <xsl:with-param name="firstPara" select="*[1]/*[name() = 'text:p' or name() = 'text:h'][1]"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="isEmptyList" select="not(*[1]/*[name() = 'text:h' or name() = 'text:p' or name() = 'text:name'])"/>
        <xsl:variable name="listType">
            <xsl:choose>
                <!-- ordered list -->
                <xsl:when test="name($listLevelStyle) = 'text:list-level-style-number'">
                    <xsl:text>ol</xsl:text>
                </xsl:when>
                <!-- unordered list (bullet or image) -->
                <xsl:otherwise>
                    <xsl:text>ul</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="{$listType}">
            <xsl:apply-templates select="*[1]" mode="listItemSibling">
                <xsl:with-param name="globalData" select="$globalData"/>
                <xsl:with-param name="isEmptyList" select="$isEmptyList"/>
                <xsl:with-param name="isListNumberingReset" select="$isNextLevelNumberingReset"/>
                <xsl:with-param name="isNextLevelNumberingReset">
                    <xsl:choose>
                        <xsl:when test="$isListNumberingReset">
                            <xsl:value-of select="true()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- A list is empty if a text:list does not have a text:list-header or text:list-item (wildcard as only those can exist beyond a text:list), which contains a text:h or text:p -->
                            <xsl:value-of select="not($isEmptyList)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="itemLabel" select="$itemLabel"/>
                <xsl:with-param name="listIndent" select="$listIndent"/>
                <xsl:with-param name="listLevel" select="$listLevel"/>
                <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                <xsl:with-param name="listRestart">
                    <xsl:choose>
                        <xsl:when test="$listRestart">
                            <xsl:value-of select="$listRestart"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- descendants restart their list numbering, when an ancestor is not empty -->
                            <xsl:value-of select="not($isEmptyList)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="listStyle" select="$listStyle"/>
                <xsl:with-param name="listStyleName" select="$listStyleName"/>
                <xsl:with-param name="minLabelDist">
                    <xsl:choose>
                        <xsl:when test="$listLevelStyle/*/@text:min-label-distance">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="$listLevelStyle/*/@text:min-label-distance"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="minLabelWidth">
                    <xsl:choose>
                        <xsl:when test="$listLevelStyle/*/@text:min-label-width">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="$listLevelStyle/*/@text:min-label-width"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <!-- See comment before text:list template -->
    <xsl:template name="getListIndent">
        <xsl:param name="globalData"/>
        <xsl:param name="listLevelStyle"/>
        <!-- The first paragraph of the list item (heading is special paragraph in ODF) -->
        <xsl:param name="firstPara" />

        <!-- Styles of first paragraph in list item, including ancestor styles (inheritance) -->
        <xsl:variable name="firstParaStyles" select="$globalData/all-styles/style[@style:name = $firstPara/@text:style-name]/final-properties"/>

        <!-- Only the left margin of the first paragraph of a list item will be added to the margin of the complete list (all levels)-->
        <xsl:variable name="firstParaLeftMargin">
            <xsl:choose>
                <xsl:when test="contains($firstParaStyles, 'margin-left:')">
                    <xsl:call-template name="convert2cm">
                        <xsl:with-param name="value" select="normalize-space(substring-before(substring-after($firstParaStyles, 'margin-left:'), ';'))"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="spaceBefore">
            <xsl:choose>
                <xsl:when test="$listLevelStyle/*/@text:space-before">
                    <xsl:call-template name="convert2cm">
                        <xsl:with-param name="value" select="$listLevelStyle/*/@text:space-before"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Only if the left-margin of the first paragraph is positive the sum
        text:space-before and fo:left-margin is taken as list indent -->
        <xsl:choose>
            <xsl:when test="$firstParaLeftMargin &gt; 0">
                <xsl:value-of select="$firstParaLeftMargin + $spaceBefore"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$spaceBefore"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ****************** -->
    <!-- *** list item  *** -->
    <!-- ****************** -->
<!--
    Left margin of the complete list:
    The space between left page and the list symbol (left-margin) is in the Office implemented by
    the sum of three values:
        1) 'text:space-before', which is part of the 'text:list-style' element.
        2) 'margin:left' from the style of the first child (e.g. paragraph).
        3) 'fo:text-indent' the indent of the first line of some child (e.g. paragraph) (applied by CSS class style)

    Possible list children:
    <!ELEMENT text:list-item (text:p|text:h|text:list)+>

    In the Office the list label before the text depends on two attributes:
        - 'text:min-label-width': the distance between list label and all text of the list item.
        - 'text:min-label-distance': the distance between list label and text of the first line,
            only used, when text does not fit in text:min-label-width (ignored)

-->
    <xsl:template match="text:list-item | text:list-header" mode="listItemSibling">
        <xsl:param name="globalData"/>
        <xsl:param name="firstitemLabelWidth"/>
        <xsl:param name="isEmptyList" select="not(*[name() = 'text:h' or name() = 'text:p' or name() = 'text:name'])"/>
        <xsl:param name="isListNumberingReset"/>
        <xsl:param name="isNextLevelNumberingReset"/>
        <xsl:param name="itemNumber"/>
        <xsl:param name="itemLabel"/>
        <xsl:param name="listLevel"/>
        <xsl:param name="listLevelStyle"/>
        <xsl:param name="listRestart"/>
        <xsl:param name="listStyle"/>
        <xsl:param name="listStyleName"/>
        <xsl:param name="minLabelDist"/>
        <xsl:param name="minLabelWidth"/>
        <xsl:param name="listIndent" />

        <!-- The text:list-header shall not be labeled. According to ODF specification (sect. 4.3.2):
        "The <text:list-header> element represents a list header and is a special kind of list item. It
        contains one or more paragraphs that are displayed before a list. The paragraphs are formatted
        like list items but they do not have a preceding number or bullet." -->
        <xsl:variable name="isListHeader" select="boolean(self::text:list-header)"/>

        <xsl:variable name="listIndentNew">
            <xsl:choose>
                <xsl:when test="$listIndent">
                    <xsl:value-of select="$listIndent"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="getListIndent">
                        <xsl:with-param name="globalData" select="$globalData"/>
                        <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                        <xsl:with-param name="firstPara" select="*[name() = 'text:p' or name() = 'text:h'][1]" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="itemNumberNew">
            <xsl:if test="$listStyle/text:list-style/text:list-level-style-number">
                <xsl:choose>
                    <xsl:when test="$isListHeader">0</xsl:when>
                    <xsl:when test="$isEmptyList">
                        <!--  An empty list item (no text:h/text:p as child), will not count as item and does not increment the count.  -->
                        <xsl:variable name="tempItemNumber">
                            <xsl:choose>
                                <!-- siblings will be incremented by one -->
                                <xsl:when test="$itemNumber">
                                    <xsl:if test="not($isListHeader)">
                                        <xsl:value-of select="$itemNumber + 1"/>
                                    </xsl:if>
                                </xsl:when>
                                <!-- if a higher list level had content the numbering starts with 1 -->
                                <xsl:when test="$isListNumberingReset and $listLevel &gt; 1">
                                    <xsl:value-of select="1"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="getItemNumber">
                                        <xsl:with-param name="listStyleName" select="$listStyleName"/>
                                        <xsl:with-param name="listLevel" select="$listLevel"/>
                                        <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                                        <xsl:with-param name="listStyle" select="$listStyle"/>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:choose>
                            <!-- in case the empty list-item is the first list-item in document -->
                            <xsl:when test="$tempItemNumber = 1">
                                <xsl:value-of select="1"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$tempItemNumber - 1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="@text:start-value">
                                <xsl:value-of select="@text:start-value"/>
                            </xsl:when>
                            <!-- text:start-value from list level style will only be taken on the first list-item of a list -->
                            <xsl:when test="$listLevelStyle/@text:start-value and count(preceding-sibling::text:list-item) = 0">
                                <xsl:value-of select="$listLevelStyle/@text:start-value"/>
                            </xsl:when>
                            <!-- siblings will be incremented by one -->
                            <xsl:when test="$itemNumber">
                                <xsl:value-of select="$itemNumber + 1"/>
                            </xsl:when>
                            <!-- if a higher list level had content the numbering starts with 1 -->
                            <xsl:when test="$isListNumberingReset and $listLevel &gt; 1">
                                <xsl:value-of select="1"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="getItemNumber">
                                    <xsl:with-param name="listStyleName" select="$listStyleName"/>
                                    <xsl:with-param name="listLevel" select="$listLevel"/>
                                    <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                                    <xsl:with-param name="listStyle" select="$listStyle"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="itemLabelNew">
            <xsl:if test="$listStyle/text:list-style/text:list-level-style-number">
                <!--
                    A numbered label (e.g. 2.C.III) is created for every text:list-item/header.
                    Above list levels are listed in the label, if the list-style requires this. Levels are separated by a '.'
                    Formatation is dependent for every list level depth.
                    The label is passed from ancestor text:list-item/header and if required truncated.
                    The prefix/suffix (as well list level dependent) comes before and after the complete label (after truncation)
                -->
                <!-- Numbered label will be generated  -->
                <xsl:call-template name="createItemLabel">
                    <xsl:with-param name="itemNumber" select="$itemNumberNew"/>
                    <xsl:with-param name="itemLabel" select="$itemLabel"/>
                    <xsl:with-param name="listLevelsToDisplay">
                        <xsl:variable name="display" select="$listLevelStyle/@text:display-levels"/>
                        <xsl:choose>
                            <xsl:when test="$display">
                                <xsl:value-of select="$display"/>
                            </xsl:when>
                            <xsl:when test="$isListHeader">0</xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="listLevel" select="$listLevel"/>
                    <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:element name="li">
            <xsl:choose>
                <xsl:when test="$isEmptyList or $isListHeader">
                    <xsl:apply-templates>
                        <xsl:with-param name="globalData" select="$globalData"/>
                        <xsl:with-param name="itemLabel" select="$itemLabelNew"/>
                        <xsl:with-param name="listLevel" select="$listLevel + 1"/>
                        <xsl:with-param name="listStyleName" select="$listStyleName"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Possible following children are text:h, text:p, list:text, text:soft-page-break -->
                    <xsl:apply-templates mode="list-item-children" select="*[1]">
                        <xsl:with-param name="globalData" select="$globalData"/>
                        <xsl:with-param name="isEmptyList" select="$isEmptyList"/>
                        <xsl:with-param name="isNextLevelNumberingReset" select="$isListHeader or $isNextLevelNumberingReset"/>
                        <!-- The new created label is given to the children -->
                        <xsl:with-param name="itemLabel" select="$itemLabelNew"/>
                        <xsl:with-param name="listLabelElement">
                            <xsl:choose>
                                <xsl:when test="name() = 'text:list-header'"/>
                                <xsl:otherwise>
                                    <xsl:variable name="listLabelWidth">
                                        <xsl:choose>
                                            <xsl:when test="$minLabelWidth &gt; $minLabelDist">
                                                <xsl:value-of select="$minLabelWidth"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:choose>
                                                    <xsl:when test="$minLabelDist &gt; 0">
                                                <xsl:value-of select="$minLabelDist"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:variable name="listLevelLabelAlignment" select="$listLevelStyle/style:list-level-properties/style:list-level-label-alignment"/>
                                                        <xsl:variable name="listLevelTextIndent">
                                                            <xsl:call-template name="convert2cm">
                                                                <xsl:with-param name="value" select="string($listLevelLabelAlignment/@fo:text-indent)"/>
                                                            </xsl:call-template>
                                                        </xsl:variable>
                                                        <xsl:value-of select="-$listLevelTextIndent"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <!-- Numbering is being done by this transformation creating a HTML span representing the number label
                                         The html:span represents the list item/header label (e.g. 1.A.III)
                                         As the html:span is usually an inline element is formatted by CSS as block element to use width upon it,
                                         to disable the carriage return float:left is used and later neglected -->
                                    <xsl:element name="span">
                                        <xsl:if test="$listLevelStyle/@text:style-name">
                                            <xsl:attribute name="class">
                                                <xsl:value-of select="$listLevelStyle/@text:style-name"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:attribute name="style">
                                            <xsl:text>display:block;float:</xsl:text>
                                            <!-- 2DO: Svante - copy this functionality for other used margin:left (in western country 'left') -->
                                            <xsl:call-template name="getOppositeWritingDirection">
                                                <xsl:with-param name="globalData" select="$globalData"/>
                                                <xsl:with-param name="paraStyleName" select="descendant-or-self::*/@text:style-name"/>
                                            </xsl:call-template>
                                            <xsl:text>;min-width:</xsl:text>
                                            <xsl:value-of select="$listLabelWidth"/>
                                            <xsl:text>cm;</xsl:text>
                                        </xsl:attribute>
                                        <xsl:variable name="labelContent">
                                            <xsl:choose>
                                                <xsl:when test="text:number">
                                                    <xsl:apply-templates select="text:number" mode="listnumber"/>
                                                </xsl:when>
                                                <xsl:when test="name($listLevelStyle) = 'text:list-level-style-bullet'">
                                                    <xsl:value-of select="$listLevelStyle/@style:num-prefix"/>
                                                    <xsl:value-of select="$listLevelStyle/@text:bullet-char"/>
                                                    <xsl:value-of select="$listLevelStyle/@style:num-suffix"/>
                                                </xsl:when>
                                                <xsl:when test="name($listLevelStyle) = 'text:list-level-style-number'">
                                                    <xsl:value-of select="$listLevelStyle/@style:num-prefix"/>
                                                    <xsl:value-of select="$itemLabelNew"/>
                                                    <xsl:value-of select="$listLevelStyle/@style:num-suffix"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                <!-- Listing with image as bullets, taken from the list style's href -->
                                                    <xsl:value-of select="$listLevelStyle/@xlink:href"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <!-- Some browsers have problem with stand-alone elements (e.g. <span/>)
                                            Therefore a comment is being inserted into an empty label -->
                                        <xsl:choose>
                                            <xsl:when test="$labelContent != ''">
                                                <xsl:value-of select="$labelContent"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:comment>&#160;</xsl:comment>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="listLabelEmptyElement">
                            <xsl:variable name="listLabelWidth">
                                <xsl:choose>
                                    <xsl:when test="$minLabelWidth &gt; $minLabelDist">
                                        <xsl:value-of select="$minLabelWidth"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$minLabelDist"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:element name="span">
                                <xsl:if test="$listLevelStyle/@text:style-name">
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="$listLevelStyle/@text:style-name"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:attribute name="style">
                                    <xsl:text>display:block;float:</xsl:text>
                                    <xsl:call-template name="getOppositeWritingDirection">
                                        <xsl:with-param name="globalData" select="$globalData"/>
                                        <xsl:with-param name="paraStyleName" select="descendant-or-self::*/@text:style-name"/>
                                    </xsl:call-template>
                                    <xsl:text>;min-width:</xsl:text>
                                    <xsl:value-of select="$listLabelWidth"/>
                                    <xsl:text>cm</xsl:text>
                                </xsl:attribute>
                                <xsl:comment>&#160;</xsl:comment>
                            </xsl:element>
                        </xsl:with-param>
                        <xsl:with-param name="listLevel" select="$listLevel + 1"/>
                        <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                        <xsl:with-param name="listRestart" select="$listRestart"/>
                        <xsl:with-param name="listStyle" select="$listStyle"/>
                        <xsl:with-param name="listStyleName" select="$listStyleName"/>
                        <xsl:with-param name="listIndent" select="$listIndentNew"/>
                        <xsl:with-param name="minLabelWidth" select="$minLabelWidth"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:apply-templates select="following-sibling::*[1]" mode="listItemSibling">
            <xsl:with-param name="globalData" select="$globalData"/>
            <xsl:with-param name="isListNumberingReset" select="$isListNumberingReset"/>
            <xsl:with-param name="isNextLevelNumberingReset" select="$isNextLevelNumberingReset"/>
            <xsl:with-param name="itemNumber" select="$itemNumberNew"/>
            <xsl:with-param name="listIndent">
                <xsl:choose>
                    <xsl:when test="not($isEmptyList)">
                        <xsl:value-of select="$listIndentNew"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:with-param>
            <!-- Receives the same parent label -->
            <xsl:with-param name="itemLabel" select="$itemLabel"/>
            <xsl:with-param name="listLevel" select="$listLevel"/>
            <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
            <xsl:with-param name="listStyle" select="$listStyle"/>
            <xsl:with-param name="listStyleName" select="$listStyleName"/>
            <xsl:with-param name="minLabelDist" select="$minLabelDist"/>
            <xsl:with-param name="minLabelWidth" select="$minLabelWidth"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template name="getOppositeWritingDirection">
        <xsl:param name="globalData"/>
        <xsl:param name="paraStyleName"/>

        <xsl:variable name="imageParagraphStyle" select="$globalData/all-styles/style[@style:name = $paraStyleName]/final-properties"/>

        <xsl:choose>
            <xsl:when test="contains($imageParagraphStyle, 'writing-mode:')">
                <xsl:choose>
                    <xsl:when test="contains(substring-before(substring-after($imageParagraphStyle, 'writing-mode:'), ';'), 'rl')">right</xsl:when>
                    <xsl:otherwise>left</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>left</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text:number" mode="listnumber">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text:number" mode="list-item-children">
        <xsl:param name="globalData"/>
        <xsl:param name="listLabelElement"/>
        <xsl:param name="listLabelEmptyElement"/>
        <xsl:param name="isEmptyList"/>
        <xsl:param name="isListNumberingReset"/>
        <xsl:param name="isNextLevelNumberingReset"/>
        <xsl:param name="itemLabel"/>
        <xsl:param name="itemNumber"/>
        <xsl:param name="listIndent"/>
        <xsl:param name="listLevel"/>
        <xsl:param name="listLevelStyle" />
        <xsl:param name="listRestart"/>
        <xsl:param name="listStyle"/>
        <xsl:param name="listStyleName"/>
        <xsl:param name="minLabelWidth"/>

        <xsl:apply-templates mode="list-item-children" select="following-sibling::*[1]">
            <xsl:with-param name="globalData" select="$globalData"/>
            <xsl:with-param name="isEmptyList" select="$isEmptyList"/>
            <xsl:with-param name="isNextLevelNumberingReset" select="$isNextLevelNumberingReset"/>
            <xsl:with-param name="itemLabel" select="$itemLabel"/>
            <xsl:with-param name="listLabelElement" select="$listLabelElement"/>
            <xsl:with-param name="listLabelEmptyElement" select="$listLabelEmptyElement"/>
            <xsl:with-param name="listLevel" select="$listLevel"/>
            <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
            <xsl:with-param name="listRestart" select="$listRestart"/>
            <xsl:with-param name="listStyle" select="$listStyle"/>
            <xsl:with-param name="listStyleName" select="$listStyleName"/>
            <xsl:with-param name="listIndent" select="$listIndent"/>
            <xsl:with-param name="minLabelWidth" select="$minLabelWidth"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- Each key element holds the set of all text:list-item/text:list-header of a certain level and a certain style -->
    <xsl:key name="getListItemsByLevelAndStyle" use="concat(count(ancestor::text:list), ancestor::text:list/@text:style-name)" match="text:list-item | text:list-header"/>
    <!-- Each key element holds the set of all text:list-item/text:list-header of a certain style -->
    <xsl:key name="getListItemsByStyle" use="ancestor::text:list/@text:style-name" match="text:list-item | text:list-header"/>


    <!-- The Numbering start value (or offset from regular counteing) is used at the first item of offset,
    but have to be reused on following items with no text:start-value -->
    <xsl:template name="getItemNumber">
        <xsl:param name="listLevel"/>
        <xsl:param name="listLevelStyle"/>
        <xsl:param name="listStyleName"/>
        <xsl:param name="listStyle"/>

        <xsl:call-template name="countListItemTillStartValue">
            <xsl:with-param name="listLevel" select="$listLevel"/>
            <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
            <xsl:with-param name="listStyleName" select="$listStyleName"/>
            <xsl:with-param name="listStyle" select="$listStyle"/>
            <xsl:with-param name="precedingListItemsOfSameLevelAndStyle" select="preceding::text:list-item[generate-id(key('getListItemsByLevelAndStyle', concat($listLevel, $listStyleName))) = generate-id(key('getListItemsByLevelAndStyle', concat(count(ancestor::text:list), ancestor::text:list/@text:style-name)))]"/>

            <xsl:with-param name="precedingListItemsOfSameStyle" select="preceding::text:list-item[generate-id(key('getListItemsByStyle', $listStyleName)) = generate-id(key('getListItemsByStyle', ancestor::text:list/@text:style-name))]"/>
        </xsl:call-template>
    </xsl:template>

    <!-- When there is a text:start-value the last have to be found and added to the number -->
    <xsl:template name="countListItemTillStartValue">
        <xsl:param name="IteratorSameLevelAndStyle" select="1"/>
        <xsl:param name="IteratorSameStyle" select="1"/>
        <xsl:param name="itemNumber" select="1"/>
        <xsl:param name="listLevel"/>
        <xsl:param name="listLevelStyle"/>
        <xsl:param name="listStyle"/>
        <xsl:param name="listStyleName"/>
        <xsl:param name="precedingListItemsOfSameLevelAndStyle" />
        <xsl:param name="precedingListItemsOfSameLevelAndStyleCount" select="count($precedingListItemsOfSameLevelAndStyle)"/>
        <xsl:param name="precedingListItemsOfSameStyle" />
        <xsl:param name="precedingListItemsOfSameStyleCount" select="count($precedingListItemsOfSameStyle)"/>
        <!-- E.g.: If a list level 2 number is searched, a level 3 with content found with only a level 1 parent with content,
            the level 3 gets a 'pseudoLevel' -->
        <xsl:param name="pseudoLevel" select="0" />

        <xsl:variable name="isListHeader" select="boolean(self::text:list-header)"/>
        <xsl:variable name="isEmptyList" select="not(*[name() = 'text:h' or name() = 'text:p'])"/>

        <!-- set the next of preceding list items. Starting from the current to the next previous text:list-item -->
        <xsl:variable name="precedingListItemOfSameLevelAndStyle" select="$precedingListItemsOfSameLevelAndStyle[$precedingListItemsOfSameLevelAndStyleCount - $IteratorSameLevelAndStyle + 1]"/>
        <xsl:variable name="precedingListItemOfSameStyle" select="$precedingListItemsOfSameStyle[$precedingListItemsOfSameStyleCount - $IteratorSameStyle + 1]"/>
        <xsl:choose>
            <xsl:when test="($precedingListItemOfSameStyle and $precedingListItemOfSameLevelAndStyle) or ($precedingListItemOfSameStyle and $listStyle/text:list-style/@text:consecutive-numbering)">
                <xsl:for-each select="$precedingListItemOfSameStyle">
                    <xsl:choose>
                        <!-- if it is a higher list level element  -->
                        <xsl:when test="$listStyle/text:list-style/@text:consecutive-numbering">

                            <xsl:call-template name="countListItem">
                                <xsl:with-param name="IteratorSameLevelAndStyle" select="$IteratorSameLevelAndStyle" />
                                <xsl:with-param name="IteratorSameStyle" select="$IteratorSameStyle"/>
                                <xsl:with-param name="itemNumber" select="$itemNumber"/>
                                <xsl:with-param name="listLevel" select="$listLevel"/>
                                <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                                <xsl:with-param name="listStyle" select="$listStyle"/>
                                <xsl:with-param name="precedingListItemsOfSameLevelAndStyle" select="$precedingListItemsOfSameLevelAndStyle"/>
                                <xsl:with-param name="precedingListItemsOfSameLevelAndStyleCount" select="$precedingListItemsOfSameLevelAndStyleCount"/>
                                <xsl:with-param name="precedingListItemsOfSameStyle" select="$precedingListItemsOfSameStyle"/>
                                <xsl:with-param name="precedingListItemsOfSameStyleCount" select="$precedingListItemsOfSameStyleCount"/>
                                <xsl:with-param name="pseudoLevel" select="$pseudoLevel" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- NOT CONSECUTIVE NUMBERING -->
                            <xsl:variable name="currentListLevel" select="count(ancestor::text:list)"/>
                            <xsl:choose>
                                <!-- IF IT IS A HIGHER LIST LEVEL ELEMENT -->
                                <xsl:when test="$currentListLevel &lt; $listLevel">
                                    <xsl:choose>
                                        <!-- if it has content the counting is ended -->
                                        <xsl:when test="*[name() = 'text:h' or name() = 'text:p'] or $isListHeader">
                                            <!-- 2DO: Perhaps the children still have to be processed -->
                                            <xsl:value-of select="$itemNumber + $pseudoLevel"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                        <!-- if it is empty the counting continues -->
                                            <xsl:call-template name="countListItemTillStartValue">
                                                <xsl:with-param name="IteratorSameLevelAndStyle" select="$IteratorSameLevelAndStyle" />
                                                <xsl:with-param name="IteratorSameStyle" select="$IteratorSameStyle + 1"/>
                                                <xsl:with-param name="itemNumber" select="$itemNumber"/>
                                                <xsl:with-param name="listLevel" select="$listLevel"/>
                                                <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                                                <xsl:with-param name="listStyle" select="$listStyle"/>
                                                <xsl:with-param name="precedingListItemsOfSameLevelAndStyle" select="$precedingListItemsOfSameLevelAndStyle"/>
                                                <xsl:with-param name="precedingListItemsOfSameLevelAndStyleCount" select="$precedingListItemsOfSameLevelAndStyleCount"/>
                                                <xsl:with-param name="precedingListItemsOfSameStyle" select="$precedingListItemsOfSameStyle"/>
                                                <xsl:with-param name="precedingListItemsOfSameStyleCount" select="$precedingListItemsOfSameStyleCount"/>
                                                <xsl:with-param name="pseudoLevel" select="$pseudoLevel" />
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <!-- IF IT IS A LIST LEVEL ELEMENT OF THE COUNTING LEVEL -->
                                <xsl:when test="$currentListLevel = $listLevel">
                                    <xsl:call-template name="countListItem">
                                        <xsl:with-param name="IteratorSameLevelAndStyle" select="$IteratorSameLevelAndStyle" />
                                        <xsl:with-param name="IteratorSameStyle" select="$IteratorSameStyle"/>
                                        <xsl:with-param name="itemNumber" select="$itemNumber"/>
                                        <xsl:with-param name="listLevel" select="$listLevel"/>
                                        <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                                        <xsl:with-param name="listStyle" select="$listStyle"/>
                                        <xsl:with-param name="precedingListItemsOfSameLevelAndStyle" select="$precedingListItemsOfSameLevelAndStyle"/>
                                        <xsl:with-param name="precedingListItemsOfSameLevelAndStyleCount" select="$precedingListItemsOfSameLevelAndStyleCount"/>
                                        <xsl:with-param name="precedingListItemsOfSameStyle" select="$precedingListItemsOfSameStyle"/>
                                        <xsl:with-param name="precedingListItemsOfSameStyleCount" select="$precedingListItemsOfSameStyleCount"/>
                                        <xsl:with-param name="pseudoLevel" select="$pseudoLevel" />
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- list item below the current level does not count -->
                                    <xsl:call-template name="countListItemTillStartValue">
                                        <xsl:with-param name="IteratorSameLevelAndStyle" select="$IteratorSameLevelAndStyle" />
                                        <xsl:with-param name="IteratorSameStyle" select="$IteratorSameStyle + 1"/>
                                        <xsl:with-param name="itemNumber" select="$itemNumber"/>
                                        <xsl:with-param name="listLevel" select="$listLevel"/>
                                        <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                                        <xsl:with-param name="listStyle" select="$listStyle"/>
                                        <xsl:with-param name="listStyleName" select="$listStyleName"/>
                                        <xsl:with-param name="precedingListItemsOfSameLevelAndStyle" select="$precedingListItemsOfSameLevelAndStyle"/>
                                        <xsl:with-param name="precedingListItemsOfSameLevelAndStyleCount" select="$precedingListItemsOfSameLevelAndStyleCount"/>
                                        <xsl:with-param name="precedingListItemsOfSameStyle" select="$precedingListItemsOfSameStyle"/>
                                        <xsl:with-param name="precedingListItemsOfSameStyleCount" select="$precedingListItemsOfSameStyleCount"/>
                                        <xsl:with-param name="pseudoLevel">
                                            <xsl:choose>
                                                <!-- empty list item does not count -->
                                                <xsl:when test="not(*[name() = 'text:h' or name() = 'text:p']) or $isListHeader">
                                                    <xsl:value-of select="$pseudoLevel"/>
                                                </xsl:when>
                                                <xsl:otherwise>1</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$itemNumber"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="countListItem">
        <xsl:param name="IteratorSameLevelAndStyle"/>
        <xsl:param name="IteratorSameStyle"/>
        <xsl:param name="itemNumber"/>
        <xsl:param name="listLevel"/>
        <xsl:param name="listLevelStyle"/>
        <xsl:param name="listStyle"/>
        <xsl:param name="listStyleName"/>
        <xsl:param name="precedingListItemsOfSameLevelAndStyle"/>
        <xsl:param name="precedingListItemsOfSameLevelAndStyleCount"/>
        <xsl:param name="precedingListItemsOfSameStyle"/>
        <xsl:param name="precedingListItemsOfSameStyleCount"/>
        <xsl:param name="pseudoLevel" />

        <xsl:variable name="isListHeader" select="boolean(self::text:list-header)"/>
        <xsl:variable name="isEmptyList" select="not(*[name() = 'text:h' or name() = 'text:p'])"/>

        <xsl:choose>
            <xsl:when test="@text:start-value">
                <xsl:choose>
                    <xsl:when test="$isEmptyList or $isListHeader">
                        <!-- empty list item does not count. neither does list header -->
                        <xsl:call-template name="countListItemTillStartValue">
                            <xsl:with-param name="IteratorSameLevelAndStyle" select="$IteratorSameLevelAndStyle + 1" />
                            <xsl:with-param name="IteratorSameStyle" select="$IteratorSameStyle + 1"/>
                            <xsl:with-param name="itemNumber" select="$itemNumber"/>
                            <xsl:with-param name="listLevel" select="$listLevel"/>
                            <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                            <xsl:with-param name="listStyle" select="$listStyle"/>
                            <xsl:with-param name="precedingListItemsOfSameLevelAndStyle" select="$precedingListItemsOfSameLevelAndStyle"/>
                            <xsl:with-param name="precedingListItemsOfSameLevelAndStyleCount" select="$precedingListItemsOfSameLevelAndStyleCount"/>
                            <xsl:with-param name="precedingListItemsOfSameStyle" select="$precedingListItemsOfSameStyle"/>
                            <xsl:with-param name="precedingListItemsOfSameStyleCount" select="$precedingListItemsOfSameStyleCount"/>
                            <xsl:with-param name="pseudoLevel" select="$pseudoLevel" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$itemNumber + @text:start-value"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$listLevelStyle/@text:start-value">
                <xsl:choose>
                    <xsl:when test="$isEmptyList or $isListHeader">
                        <!-- empty list item does not count. neither does list header -->
                        <xsl:call-template name="countListItemTillStartValue">
                            <xsl:with-param name="IteratorSameLevelAndStyle" select="$IteratorSameLevelAndStyle + 1" />
                            <xsl:with-param name="IteratorSameStyle" select="$IteratorSameStyle + 1"/>
                            <xsl:with-param name="itemNumber" select="$itemNumber"/>
                            <xsl:with-param name="listLevel" select="$listLevel"/>
                            <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                            <xsl:with-param name="listStyle" select="$listStyle"/>
                            <xsl:with-param name="precedingListItemsOfSameLevelAndStyle" select="$precedingListItemsOfSameLevelAndStyle"/>
                            <xsl:with-param name="precedingListItemsOfSameLevelAndStyleCount" select="$precedingListItemsOfSameLevelAndStyleCount"/>
                            <xsl:with-param name="precedingListItemsOfSameStyle" select="$precedingListItemsOfSameStyle"/>
                            <xsl:with-param name="precedingListItemsOfSameStyleCount" select="$precedingListItemsOfSameStyleCount"/>
                            <xsl:with-param name="pseudoLevel" select="$pseudoLevel" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$itemNumber + $listLevelStyle/@text:start-value"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$isEmptyList or $isListHeader">
                        <!-- empty list item does not count. neither does list header -->
                        <xsl:call-template name="countListItemTillStartValue">
                            <xsl:with-param name="IteratorSameLevelAndStyle" select="$IteratorSameLevelAndStyle + 1" />
                            <xsl:with-param name="IteratorSameStyle" select="$IteratorSameStyle + 1"/>
                            <xsl:with-param name="itemNumber" select="$itemNumber"/>
                            <xsl:with-param name="listLevel" select="$listLevel"/>
                            <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                            <xsl:with-param name="listStyle" select="$listStyle"/>
                            <xsl:with-param name="precedingListItemsOfSameLevelAndStyle" select="$precedingListItemsOfSameLevelAndStyle"/>
                            <xsl:with-param name="precedingListItemsOfSameLevelAndStyleCount" select="$precedingListItemsOfSameLevelAndStyleCount"/>
                            <xsl:with-param name="precedingListItemsOfSameStyle" select="$precedingListItemsOfSameStyle"/>
                            <xsl:with-param name="precedingListItemsOfSameStyleCount" select="$precedingListItemsOfSameStyleCount"/>
                            <xsl:with-param name="pseudoLevel" select="$pseudoLevel" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- count on till you find a start-value or the end is reached -->
                        <xsl:call-template name="countListItemTillStartValue">
                            <xsl:with-param name="IteratorSameLevelAndStyle" select="$IteratorSameLevelAndStyle + 1" />
                            <xsl:with-param name="IteratorSameStyle" select="$IteratorSameStyle + 1"/>
                            <xsl:with-param name="itemNumber" select="$itemNumber + 1"/>
                            <xsl:with-param name="listLevel" select="$listLevel"/>
                            <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
                            <xsl:with-param name="listStyle" select="$listStyle"/>
                            <xsl:with-param name="precedingListItemsOfSameLevelAndStyle" select="$precedingListItemsOfSameLevelAndStyle"/>
                            <xsl:with-param name="precedingListItemsOfSameLevelAndStyleCount" select="$precedingListItemsOfSameLevelAndStyleCount"/>
                            <xsl:with-param name="precedingListItemsOfSameStyle" select="$precedingListItemsOfSameStyle"/>
                            <xsl:with-param name="precedingListItemsOfSameStyleCount" select="$precedingListItemsOfSameStyleCount"/>
                            <xsl:with-param name="pseudoLevel" select="0" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Creates the list label containing the number, which is separated by '.' between the levels.
        Depending on the levels to display (listLevelsToDisplay) -->
    <xsl:template name="createItemLabel">
        <xsl:param name="itemLabel" select="''"/>
        <xsl:param name="itemNumber" />
        <xsl:param name="listLevel" />
        <xsl:param name="listLevelStyle" />
        <xsl:param name="listLevelsToDisplay" />

        <xsl:choose>
            <xsl:when test="$listLevelsToDisplay &lt; $listLevel">
                <xsl:call-template name="truncLabel">
                    <xsl:with-param name="itemLabel" select="$itemLabel"/>
                    <xsl:with-param name="itemNumber" select="$itemNumber" />
                    <xsl:with-param name="listLevel" select="$listLevel"/>
                    <xsl:with-param name="listLevelStyle" select="$listLevelStyle" />
                    <xsl:with-param name="listLevelsToDisplay" select="$listLevelsToDisplay"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="numberedSymbol">
                    <xsl:comment>&#160;</xsl:comment>
                    <!-- only give out a number when number format is not empty -->
                    <xsl:if test="$listLevelStyle/@style:num-format != ''">
                        <xsl:number value="$itemNumber" format="{$listLevelStyle/@style:num-format}"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$listLevelsToDisplay != 1">
                        <xsl:value-of select="concat($itemLabel, '.' , $numberedSymbol)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$numberedSymbol"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="truncLabel">
        <xsl:param name="itemLabel" />
        <xsl:param name="itemNumber" />
        <xsl:param name="listLevel" />
        <xsl:param name="listLevelStyle" />
        <xsl:param name="listLevelsToDisplay" />
        <xsl:param name="listStyle" />
        <xsl:param name="listStyleName" />

        <xsl:call-template name="createItemLabel">
            <xsl:with-param name="itemLabel">
                <xsl:if test="contains($itemLabel, '.')">
                    <xsl:value-of select="substring-after($itemLabel, '.')"/>
                </xsl:if>
            </xsl:with-param>
            <xsl:with-param name="itemNumber" select="$itemNumber"/>
            <xsl:with-param name="listLevel" select="$listLevel - 1"/>
            <xsl:with-param name="listLevelStyle" select="$listLevelStyle"/>
            <xsl:with-param name="listLevelsToDisplay" select="$listLevelsToDisplay"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="text:p" mode="list-item-children">
        <xsl:param name="globalData"/>
        <xsl:param name="listLabelElement"/>
        <xsl:param name="listLabelEmptyElement"/>
        <xsl:param name="isEmptyList"/>
        <xsl:param name="isListNumberingReset"/>
        <xsl:param name="isNextLevelNumberingReset"/>
        <xsl:param name="itemLabel"/>
        <xsl:param name="itemNumber"/>
        <xsl:param name="listIndent"/>
        <xsl:param name="listLevel"/>
        <xsl:param name="listRestart"/>
        <xsl:param name="listStyle"/>
        <xsl:param name="listStyleName"/>
        <xsl:param name="minLabelWidth"/>

        <!-- 2DO page alignment fix - PART1 -->

        <!-- xhtml:p may only contain inline elements.
             If there is one frame beyond, div must be used! -->
        <xsl:variable name="elementName">
            <xsl:choose>
                <xsl:when test="descendant::draw:frame[1] or descendant::text:p[1]">div</xsl:when>
                <xsl:otherwise>p</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$elementName}">
            <xsl:call-template name="create-list-style">
                <xsl:with-param name="globalData" select="$globalData"/>
                <xsl:with-param name="listIndent" select="$listIndent"/>
                <xsl:with-param name="styleName" select="@text:style-name"/>
            </xsl:call-template>
            <xsl:choose>
                <xsl:when test="$listLabelElement">
                    <xsl:copy-of select="$listLabelElement"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$listLabelEmptyElement"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates>
                <xsl:with-param name="globalData" select="$globalData"/>
                <xsl:with-param name="listIndent" select="$minLabelWidth"/>
            </xsl:apply-templates>
            <!-- this span disables the float necessary to bring two block elements on one line. It contains a space as IE6 bug workaround -->
            <span class="odfLiEnd"></span>
            <xsl:text>&#160;</xsl:text>
        </xsl:element>

        <xsl:apply-templates mode="list-item-children" select="following-sibling::*[1]">
            <xsl:with-param name="globalData" select="$globalData"/>
            <xsl:with-param name="isEmptyList" select="$isEmptyList"/>
            <xsl:with-param name="isListNumberingReset" select="$isListNumberingReset"/>
            <xsl:with-param name="isNextLevelNumberingReset" select="$isNextLevelNumberingReset"/>
            <xsl:with-param name="itemLabel" select="$itemLabel"/>
            <xsl:with-param name="itemNumber" select="$itemNumber"/>
            <xsl:with-param name="listLabelEmptyElement" select="$listLabelEmptyElement"/>
            <xsl:with-param name="listLevel" select="$listLevel"/>
            <xsl:with-param name="listRestart" select="$listRestart"/>
            <xsl:with-param name="listStyle" select="$listStyle"/>
            <xsl:with-param name="listStyleName" select="$listStyleName"/>
            <xsl:with-param name="listIndent" select="$listIndent"/>
            <xsl:with-param name="minLabelWidth" select="$minLabelWidth"/>
        </xsl:apply-templates>
    </xsl:template>


    <!-- Neglecting the left margin behavior for headings for now -->
    <xsl:template match="text:h" mode="list-item-children">
        <xsl:param name="globalData"/>
        <xsl:param name="listLabelElement"/>
        <xsl:param name="listLabelEmptyElement"/>
        <xsl:param name="isEmptyList"/>
        <xsl:param name="isListNumberingReset"/>
        <xsl:param name="isNextLevelNumberingReset"/>
        <xsl:param name="itemLabel"/>
        <xsl:param name="itemNumber"/>
        <xsl:param name="listIndent"/>
        <xsl:param name="listLevel"/>
        <xsl:param name="listRestart"/>
        <xsl:param name="listStyle"/>
        <xsl:param name="listStyleName"/>
        <xsl:param name="minLabelWidth"/>

        <xsl:element name="h">
            <xsl:call-template name="create-list-style">
                <xsl:with-param name="globalData" select="$globalData"/>
                <xsl:with-param name="listIndent" select="$listIndent"/>
                <xsl:with-param name="styleName" select="@text:style-name"/>
            </xsl:call-template>
            <xsl:variable name="title">
                <xsl:apply-templates mode="concatenate"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$listLabelElement">
                    <xsl:copy-of select="$listLabelElement"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$listLabelEmptyElement"/>
                </xsl:otherwise>
            </xsl:choose>

            <!-- REFERENCE HANDLING - ANCHOR -->
            <xsl:element namespace="{$namespace}" name="a">
                <xsl:attribute name="id">
                    <xsl:value-of select="translate(concat('a_',$listLabelElement, '_', normalize-space($title)), '&#xA;&amp;&lt;&gt;.,;: %()[]/\+', '___________________________')"/>
                </xsl:attribute>
                <xsl:apply-templates>
                    <xsl:with-param name="globalData" select="$globalData"/>
                    <xsl:with-param name="listIndent" select="$minLabelWidth"/>
                </xsl:apply-templates>
            </xsl:element>

            <!-- this span disables the float necessary to bring two block elements on one line. It contains a space as IE6 bug workaround -->
            <span class="odfLiEnd"></span>
            <xsl:text>&#160;</xsl:text>
        </xsl:element>

        <xsl:apply-templates mode="list-item-children" select="following-sibling::*[1]">
            <xsl:with-param name="globalData" select="$globalData"/>
            <xsl:with-param name="isEmptyList" select="$isEmptyList"/>
            <xsl:with-param name="isListNumberingReset" select="$isListNumberingReset"/>
            <xsl:with-param name="isNextLevelNumberingReset" select="$isNextLevelNumberingReset"/>
            <xsl:with-param name="itemLabel" select="$itemLabel"/>
            <xsl:with-param name="itemNumber" select="$itemNumber"/>
            <xsl:with-param name="listLabelEmptyElement" select="$listLabelEmptyElement"/>
            <xsl:with-param name="listLevel" select="$listLevel"/>
            <xsl:with-param name="listRestart" select="$listRestart"/>
            <xsl:with-param name="listStyle" select="$listStyle"/>
            <xsl:with-param name="listStyleName" select="$listStyleName"/>
            <xsl:with-param name="listIndent" select="$listIndent"/>
            <xsl:with-param name="minLabelWidth" select="$minLabelWidth"/>
        </xsl:apply-templates>
    </xsl:template>


    <xsl:template match="*" mode="list-item-children">
        <xsl:param name="globalData"/>
        <xsl:param name="isEmptyList"/>
        <xsl:param name="listLabelEmptyElement"/>
        <xsl:param name="isListNumberingReset"/>
        <xsl:param name="isNextLevelNumberingReset"/>
        <xsl:param name="itemLabel"/>
        <xsl:param name="itemNumber"/>
        <xsl:param name="listIndent"/>
        <xsl:param name="listLevel"/>
        <xsl:param name="listRestart"/>
        <xsl:param name="listStyle"/>
        <xsl:param name="listStyleName"/>
        <xsl:param name="minLabelWidth"/>

        <xsl:apply-templates select="self::*">
            <xsl:with-param name="globalData" select="$globalData"/>
            <xsl:with-param name="isEmptyList" select="$isEmptyList"/>
            <xsl:with-param name="isListNumberingReset" select="$isListNumberingReset"/>
            <xsl:with-param name="isNextLevelNumberingReset" select="$isNextLevelNumberingReset"/>
            <xsl:with-param name="listLabelEmptyElement" select="$listLabelEmptyElement"/>
            <xsl:with-param name="itemLabel" select="$itemLabel"/>
            <xsl:with-param name="itemNumber" select="$itemNumber"/>
            <xsl:with-param name="listIndent" select="$listIndent"/>
            <xsl:with-param name="listLevel" select="$listLevel"/>
            <xsl:with-param name="listRestart" select="$listRestart"/>
            <xsl:with-param name="listStyle" select="$listStyle"/>
            <xsl:with-param name="listStyleName" select="$listStyleName"/>
        </xsl:apply-templates>

        <xsl:apply-templates mode="list-item-children" select="following-sibling::*[1]">
            <xsl:with-param name="globalData" select="$globalData"/>
            <xsl:with-param name="isEmptyList" select="$isEmptyList"/>
            <xsl:with-param name="isListNumberingReset" select="$isListNumberingReset"/>
            <xsl:with-param name="isNextLevelNumberingReset" select="$isNextLevelNumberingReset"/>
            <xsl:with-param name="itemLabel" select="$itemLabel"/>
            <xsl:with-param name="itemNumber" select="$itemNumber"/>
            <xsl:with-param name="listLabelEmptyElement" select="$listLabelEmptyElement"/>
            <xsl:with-param name="listLevel" select="$listLevel"/>
            <xsl:with-param name="listRestart" select="$listRestart"/>
            <xsl:with-param name="listStyle" select="$listStyle"/>
            <xsl:with-param name="listStyleName" select="$listStyleName"/>
            <xsl:with-param name="listIndent" select="$listIndent"/>
            <xsl:with-param name="minLabelWidth" select="$minLabelWidth"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*" mode="listItemSibling">
        <xsl:param name="globalData"/>
        <xsl:param name="isEmptyList"/>
        <xsl:param name="isListNumberingReset"/>
        <xsl:param name="isNextLevelNumberingReset"/>
        <xsl:param name="itemLabel"/>
        <xsl:param name="itemNumber"/>
        <xsl:param name="listIndent"/>
        <xsl:param name="listLevel"/>
        <xsl:param name="listRestart"/>
        <xsl:param name="listStyle"/>
        <xsl:param name="listStyleName"/>

        <xsl:apply-templates select="self::*">
            <xsl:with-param name="globalData" select="$globalData"/>
            <xsl:with-param name="isEmptyList" select="$isEmptyList"/>
            <xsl:with-param name="isListNumberingReset" select="$isListNumberingReset"/>
            <xsl:with-param name="isNextLevelNumberingReset" select="$isNextLevelNumberingReset"/>
            <xsl:with-param name="itemNumber" select="$itemNumber"/>
            <xsl:with-param name="listIndent" select="$listIndent"/>
            <!-- receives the same parent label, only with a different itemNumber -->
            <xsl:with-param name="itemLabel" select="$itemLabel"/>
            <xsl:with-param name="listLevel" select="$listLevel"/>
            <xsl:with-param name="listStyle" select="$listStyle"/>
            <xsl:with-param name="listStyleName" select="$listStyleName"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="following-sibling::*[1]" mode="listItemSibling">
            <xsl:with-param name="globalData" select="$globalData"/>
            <xsl:with-param name="isEmptyList" select="$isEmptyList"/>
            <xsl:with-param name="isListNumberingReset" select="$isListNumberingReset"/>
            <xsl:with-param name="isNextLevelNumberingReset" select="$isNextLevelNumberingReset"/>
            <xsl:with-param name="itemNumber" select="$itemNumber"/>
            <xsl:with-param name="listIndent" select="$listIndent"/>
            <!-- receives the same parent label, only with a different itemNumber -->
            <xsl:with-param name="itemLabel" select="$itemLabel"/>
            <xsl:with-param name="listLevel" select="$listLevel"/>
            <xsl:with-param name="listStyle" select="$listStyle"/>
            <xsl:with-param name="listStyleName" select="$listStyleName"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="text()" mode="list-item-children">
        <xsl:value-of select="."/>
    </xsl:template>


    <xsl:template name="create-list-style">
        <xsl:param name="globalData"/>
        <xsl:param name="listIndent" select="0"/>
        <xsl:param name="styleName"/>

        <xsl:if test="$styleName">
            <xsl:attribute name="class">
                <xsl:value-of select="translate($styleName, '.,;: %()[]/\+', '_____________')"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="style">
            <xsl:text>margin-</xsl:text>
            <xsl:call-template name="getOppositeWritingDirection">
                <xsl:with-param name="globalData" select="$globalData"/>
                <xsl:with-param name="paraStyleName" select="descendant-or-self::*/@text:style-name"/>
            </xsl:call-template>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="$listIndent"/>
            <xsl:text>cm;</xsl:text>
        </xsl:attribute>
    </xsl:template>


    <!-- ********************************************** -->
    <!-- *** Text Section (contains: draw:text-box) *** -->
    <!-- ********************************************** -->

    <xsl:template match="text:section">
        <xsl:param name="globalData"/>

        <xsl:if test="not(contains(@text:display, 'none'))">
            <xsl:comment>Next 'div' was a 'text:section'.</xsl:comment>
            <xsl:element name="div">
                <xsl:call-template name="apply-styles-and-content">
                    <xsl:with-param name="globalData" select="$globalData"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:if>
    </xsl:template>


    <!-- Hidden text dependent on Office variables:
         The text is not shown, if condition is 'true'.
         Implemented solely for conditions as '<VARIABLE>==0' or '<VARIABLE>==1'
    -->
    <xsl:key match="text:variable-set" name="varSet" use="@text:name"/>
    <xsl:template match="text:hidden-text">
        <xsl:param name="globalData"/>

        <xsl:variable name="varName" select="substring-before(@text:condition, '==')"/>
        <xsl:variable name="varValue" select="substring-after(@text:condition, '==')"/>
        <xsl:choose>
            <xsl:when test="key('varSet', $varName)/@text:value != $varValue">
                <xsl:value-of select="@text:string-value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>
                    <xsl:value-of select="$varName"/>
                    <xsl:value-of select="@text:string-value"/>
                    <xsl:value-of select="$varName"/>
                </xsl:comment>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@text:style-name | @draw:style-name | @draw:text-style-name | @table:style-name"><!-- | @presentation:style-name-->
        <xsl:param name="globalData"/>

        <xsl:attribute name="class">
            <xsl:value-of select="translate(., '.,;: %()[]/\+', '_____________')"/>
        </xsl:attribute>
    </xsl:template>


    <!-- ***************** -->
    <!-- *** Footnotes *** -->
    <!-- ***************** -->

    <xsl:template match="text:note">
        <xsl:param name="globalData"/>

        <!-- get style configuration -->
        <xsl:variable name="footnoteConfig" select="$globalData/office:styles/text:notes-configuration[@text:note-class=current()/@text:note-class]" />

        <xsl:variable name="titlePrefix">
            <xsl:choose>
                <xsl:when test="@text:note-class = 'footnote'">
                    <xsl:text>Footnote: </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Endnote: </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- write anchor -->
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="$footnoteConfig/@text:citation-body-style-name"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="$titlePrefix"/>
                <xsl:apply-templates mode="textOnly" select="text:note-body"/>
            </xsl:attribute>
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('#', @text:id)"/>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="concat('body_', @text:id)"/>
                </xsl:attribute>
                <xsl:apply-templates mode="textOnly" select="text:note-citation"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*" mode="textOnly">
        <xsl:apply-templates select="* | text()" mode="textOnly" />
    </xsl:template>

    <xsl:template match="text()" mode="textOnly">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- Useful in case of 'style:map', conditional formatting, where a style references to another -->
    <xsl:key name="textNotes" match="text:note" use="@text:note-class"/>

    <!-- writing the footer- and endnotes beyond the body -->
    <xsl:template name="write-text-nodes">
        <xsl:param name="globalData"/>

        <!-- write footnote body -->
        <xsl:for-each select="key('textNotes', 'footnote')">
            <xsl:call-template name="write-text-node">
                <xsl:with-param name="globalData" select="$globalData"/>
                <xsl:with-param name="footnoteConfig" select="$globalData/office:styles/text:notes-configuration[@text:note-class=current()/@text:note-class]" />
            </xsl:call-template>
        </xsl:for-each>

        <!-- write endnote body -->
        <xsl:for-each select="key('textNotes', 'endnote')">
            <xsl:call-template name="write-text-node">

                <xsl:with-param name="globalData" select="$globalData"/>
                <xsl:with-param name="footnoteConfig" select="$globalData/office:styles/text:notes-configuration[@text:note-class=current()/@text:note-class]" />
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="write-text-node">
        <xsl:param name="globalData"/>
        <xsl:param name="footnoteConfig"/>

        <xsl:apply-templates select="text:note-body/*[1]">
            <xsl:with-param name="globalData" select="$globalData" />
            <xsl:with-param name="footnotePrefix">
                <xsl:element name="span">
                    <xsl:attribute name="class">footnodeNumber</xsl:attribute>
                    <xsl:element name="a">
                        <xsl:attribute name="class">
                            <xsl:value-of select="$footnoteConfig/@text:citation-style-name"/>
                        </xsl:attribute>
                        <xsl:attribute name="id">
                            <xsl:value-of select="@text:id"/>
                        </xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat('#body_', @text:id)"/>
                        </xsl:attribute>
                        <xsl:apply-templates mode="textOnly" select="text:note-citation"/>
                    </xsl:element>
                </xsl:element>
            </xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="text:note-body/*[position()&gt;1]">
            <xsl:with-param name="globalData" select="$globalData" />
        </xsl:apply-templates>
    </xsl:template>

    <!-- ***************** -->
    <!-- *** Bookmarks *** -->
    <!-- ***************** -->

    <xsl:template match="text:bookmark|text:bookmark-start">
        <xsl:element name="a">
            <xsl:attribute name="id">
                <xsl:value-of select="@text:name"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text:bookmark-end"/>

    <!-- DISABLING this tab handling as the tab width is only relative
    <xsl:template match="text:tab">
        <xsl:param name="globalData"/>

        <xsl:variable name="tabNo">
            <xsl:choose>
                <xsl:when test="preceding-sibling::text:line-break">
                    <xsl:call-template name="countTextTab"/>
                </xsl:when>
                <xsl:when test="preceding-sibling::text:tab">
                    <xsl:value-of select="count(preceding-sibling::text:tab)"/>
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="span">
             <xsl:attribute name="style">margin-left:<xsl:value-of select="$globalData/all-doc-styles/style[@style:name = current()/parent::*/@text:style-name]/*/style:tab-stops/style:tab-stop[$tabNo]/@style:position"/>;</xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template name="countTextTab">
        <xsl:param name="tabCount" select="1"/>
        <xsl:param name="context" select="."/>

        <xsl:choose>
            <xsl:when test="preceding-sibling::*[1]">
                <xsl:for-each select="preceding-sibling::*[1]">
                    <xsl:call-template name="countTextTab">
                        <xsl:with-param name="tabCout">
                            <xsl:choose>
                                <xsl:when test="name(.) = 'text:tab'">
                                    <xsl:value-of select="$tabCount + 1"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$tabCount"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="context" select="preceding-sibling::*[1]" />
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$tabCount"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
-->
    <!-- MathML -->
    <xsl:template match="draw:object[math:math]">
        <xsl:apply-templates select="math:math" mode="math"/>
    </xsl:template>

    <xsl:template match="*" mode="math">
        <xsl:element name="{local-name()}" namespace="http://www.w3.org/1998/Math/MathML">
            <xsl:apply-templates select="@*|node()" mode="math"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*" mode="math">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <!-- Ignore semantic annotations -->
    <xsl:template match="math:semantics" mode="math">
        <xsl:apply-templates select="*[1]" mode="math"/>
    </xsl:template>

</xsl:stylesheet>
