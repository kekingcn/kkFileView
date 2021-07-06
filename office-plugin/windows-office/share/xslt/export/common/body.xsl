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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:java="http://xml.apache.org/xslt/java" xmlns:urlencoder="http://www.jclark.com/xt/java/java.net.URLEncoder" exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xforms xlink xsd xsi java urlencoder">


    <xsl:include href="table_of_content.xsl"/>


    <!-- ****************** -->
    <!-- *** Whitespace *** -->
    <!-- ****************** -->

    <xsl:template match="text:s">
        <xsl:call-template name="write-breakable-whitespace">
            <xsl:with-param name="whitespaces" select="@text:c"/>
        </xsl:call-template>
    </xsl:template>


    <!--write the number of 'whitespaces' -->
    <xsl:template name="write-breakable-whitespace">
        <xsl:param name="whitespaces"/>

        <!--write two space chars as the normal white space character will be stripped
            and the other is able to break -->
        <xsl:text>&#160;</xsl:text>
        <xsl:if test="$whitespaces >= 2">
            <xsl:call-template name="write-breakable-whitespace-2">
                <xsl:with-param name="whitespaces" select="$whitespaces - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    <!--write the number of 'whitespaces' -->
    <xsl:template name="write-breakable-whitespace-2">
        <xsl:param name="whitespaces"/>
        <!--write two space chars as the normal white space character will be stripped
            and the other is able to break -->
        <xsl:text> </xsl:text>
        <xsl:if test="$whitespaces >= 2">
            <xsl:call-template name="write-breakable-whitespace">
                <xsl:with-param name="whitespaces" select="$whitespaces - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- currentSolution: 8 non-breakable-spaces instead of a TAB is an approximation.
         Sometimes less spaces than 8 might be needed and the output might be more difficult to read-->
    <xsl:template match="text:tab">
        <xsl:param name="globalData"/>

        <xsl:call-template name="write-breakable-whitespace">
            <xsl:with-param name="whitespaces" select="8"/>
        </xsl:call-template>
    </xsl:template>



    <!-- *************** -->
    <!-- *** Textbox *** -->
    <!-- *************** -->

    <!-- ID / NAME of text-box -->
    <xsl:template match="@draw:name">
        <xsl:attribute name="id">
            <xsl:choose>
                <xsl:when test="number(substring(.,1,1))">
                <!-- Heuristic: If the first character is a number a 'a_' will be set
                    as prefix, as id have to be of type NMTOKEN -->
                    <xsl:value-of select="concat('a_',translate(., '&#xA;&amp;&lt;&gt;.,;: %()[]/\+', '___________________________'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(., '&#xA;&amp;&lt;&gt;.,;: %()[]/\+', '___________________________')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>


    <xsl:template match="text:line-break">
        <xsl:param name="listIndent"/>

        <xsl:element namespace="{$namespace}" name="br"/>

        <!-- line breaks in lists need an indent similar to the list label -->
        <xsl:if test="$listIndent">
            <xsl:element namespace="{$namespace}" name="span">
                <xsl:attribute name="style">margin-left:<xsl:value-of select="$listIndent"/>cm</xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>


    <!-- currently there have to be an explicit call of the style attribute nodes, maybe the attributes nodes have no priority only order relevant-->
    <xsl:template name="apply-styles-and-content">
        <xsl:param name="globalData"/>
        <xsl:param name="footnotePrefix" />
        <xsl:apply-templates select="@*">
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:apply-templates>
        <!-- the footnote symbol is the prefix for a footnote in the footer -->
        <xsl:copy-of select="$footnotePrefix"/>
        <xsl:apply-templates select="node()">
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:apply-templates>
    </xsl:template>


    <!-- ******************* -->
    <!-- *** References  *** -->
    <!-- ******************* -->

    <xsl:template match="text:reference-ref | text:sequence-ref | text:bookmark-ref">
        <xsl:param name="globalData"/>
        <xsl:if test="*|text()">
        <xsl:element namespace="{$namespace}" name="a">
            <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
                <xsl:choose>
                    <xsl:when test="number(substring(@text:ref-name,1,1))">
                    <!-- Heuristic: If the first character is a number a 'a_' will be set
                        as prefix, as id have to be of type NMTOKEN -->
                        <xsl:value-of select="concat('a_',translate(@text:ref-name, '&#xA;&amp;&lt;&gt;.,;: %()[]/\+', '___________________________'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="translate(@text:ref-name, '&#xA;&amp;&lt;&gt;.,;: %()[]/\+', '___________________________')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <xsl:apply-templates select="@* | node()">
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:apply-templates>

        </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@text:name">
        <xsl:attribute name="id">
            <xsl:choose>
                <xsl:when test="number(substring(.,1,1))">
                <!-- Heuristic: If the first character is a number a 'a_' will be set
                    as prefix, as id have to be of type NMTOKEN -->
                    <xsl:value-of select="concat('a_',translate(., '&#xA;&amp;&lt;&gt;.,;: %()[]/\+', '___________________________'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(., '&#xA;&amp;&lt;&gt;.,;: %()[]/\+', '___________________________')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="text:sequence">
        <xsl:param name="globalData"/>

        <xsl:element namespace="{$namespace}" name="a">
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="number(substring(@text:ref-name,1,1))">
                    <!-- Heuristic: If the first character is a number a 'a_' will be set
                        as prefix, as id have to be of type NMTOKEN -->
                        <xsl:value-of select="concat('a_',translate(@text:ref-name, '&#xA;&amp;&lt;&gt;.,;: %()[]/\+', '___________________________'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="translate(@text:ref-name, '&#xA;&amp;&lt;&gt;.,;: %()[]/\+', '___________________________')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:element>

        <xsl:apply-templates>
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="text:reference-mark">
        <xsl:param name="globalData"/>

        <xsl:element namespace="{$namespace}" name="a">
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="number(substring(@text:name,1,1))">
                    <!-- Heuristic: If the first character is a number a 'a_' will be set
                        as prefix, as id have to be of type NMTOKEN -->
                        <xsl:value-of select="concat('a_',translate(@text:name, '&#xA;&amp;&lt;&gt;.,;: %()[]/\+', '___________________________'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="translate(@text:name, '&#xA;&amp;&lt;&gt;.,;: %()[]/\+', '___________________________')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:element>

        <xsl:apply-templates>
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:apply-templates>
    </xsl:template>


    <xsl:template match="text:reference-mark-start">
        <xsl:param name="globalData"/>

        <xsl:element namespace="{$namespace}" name="a">
            <xsl:apply-templates select="@*" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="text:bibliography-mark">
        <xsl:param name="globalData"/>

        <xsl:element namespace="{$namespace}" name="a">
            <xsl:apply-templates select="@* | node()">
                <xsl:with-param name="globalData" select="$globalData"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <!-- @text:title exist only in text:bibliography-mark -->
    <xsl:template match="@text:title">
        <xsl:attribute name="title">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <!-- @text:url exist only in text:bibliography-mark -->
    <xsl:template match="@text:url">
        <xsl:attribute name="href">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="text:user-defined">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="office:annotation">
        <xsl:element name="span">
            <xsl:attribute name="title">annotation</xsl:attribute>
            <xsl:attribute name="class">annotation_style_by_filter</xsl:attribute>
            <xsl:apply-templates select="@*" />
            <br/>
            <xsl:text>[ANNOTATION:</xsl:text>
            <br/>
            <xsl:apply-templates select="*" mode="annotation"/>
            <xsl:text>]</xsl:text>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text:p" mode="annotation">
        <br/>
        <xsl:element name="span">
            <xsl:text>NOTE: '</xsl:text>
            <xsl:apply-templates />
            <xsl:text>'</xsl:text>
        </xsl:element>
    </xsl:template>

    <xsl:template match="dc:creator" mode="annotation">
        <br/>
        <xsl:element name="span">
            <xsl:attribute name="title">dc:creator</xsl:attribute>
            <xsl:text>BY '</xsl:text>
            <xsl:apply-templates />
            <xsl:text>'</xsl:text>
        </xsl:element>
    </xsl:template>

    <xsl:template match="dc:date" mode="annotation">
        <br/>
        <xsl:element name="span">
            <xsl:attribute name="title">dc:date</xsl:attribute>
            <xsl:text>ON '</xsl:text>
            <xsl:apply-templates />
            <xsl:text>'</xsl:text>
        </xsl:element>
    </xsl:template>

    <xsl:template match="meta:date-string" mode="annotation">
        <br/>
        <xsl:element name="span">
            <xsl:attribute name="title">meta-date-string</xsl:attribute>
            <xsl:text>META DATE '</xsl:text>
            <xsl:apply-templates />
            <xsl:text>'</xsl:text>
        </xsl:element>
    </xsl:template>


    <!-- *************** -->
    <!-- *** HELPER  *** -->
    <!-- *************** -->


    <xsl:template name="create-href">
        <xsl:param name="href"/>
        <xsl:param name="mimetype"/>

        <xsl:choose>
            <!-- internal OOo URL used in content tables -->
            <xsl:when test="contains($href, '%7Coutline') or contains($href, '|outline')">
                <!-- the simplest workaround for content tables in a single document is to create an anchor from every heading element.
                     Downside: multiple identical headings won't refer always to the first.
                -->
                <xsl:text>#</xsl:text>
                <xsl:variable name="title">
                    <xsl:apply-templates mode="concatenate"/>
                </xsl:variable>

                <xsl:value-of select="concat('a_', translate(normalize-space($title), '.,;: %()[]/\+', '_____________'))"/>
            </xsl:when>
            <xsl:when test="self::draw:image[office:binary-data]">
                <xsl:choose>
                    <xsl:when test="$mimetype">
                        <xsl:text>data:</xsl:text><xsl:value-of select="$mimetype"/><xsl:text>;base64,</xsl:text><xsl:value-of select="office:binary-data"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>data:image/*;base64,</xsl:text><xsl:value-of select="office:binary-data"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                     <!-- in case of packed open office document -->
                    <xsl:when test="starts-with($sourceBaseURL, 'jar:') or $isPackageFormat">
                        <xsl:choose>
                             <!-- for images relative to open office document -->
                            <xsl:when test="starts-with($href, '../')">
                                <!-- creating an absolute http URL to the packed image file (removing the '.')-->
                                <xsl:value-of select="concat(substring-after(substring-before($sourceBaseURL, '!'), 'jar:'), '/', $href, $optionalURLSuffix)"/>
                            </xsl:when>
                             <!-- for absolute URLs & absolute paths -->
                            <xsl:when test="contains($href, ':') or starts-with($href, '/')">
                                <xsl:value-of select="concat($href, $optionalURLSuffix)"/>
                            </xsl:when>
                            <!-- for images jared in open office document -->
                            <xsl:otherwise>
                                <xsl:value-of select="concat($sourceBaseURL, $href, $optionalURLSuffix)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                             <!-- for absolute URLs & Paths -->
                            <xsl:when test="contains($href, ':') or starts-with($href, '/')">
                                <xsl:value-of select="concat($href, $optionalURLSuffix)"/>
                            </xsl:when>
                             <!-- for relative URLs -->
                             <xsl:when test="starts-with($href, '#')">
                               <!-- intra document ref -->
                               <xsl:value-of select="$href"/>
                             </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($sourceBaseURL, $href, $optionalURLSuffix)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="text()" mode="concatenate">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="*" mode="concatenate">
        <xsl:apply-templates mode="concatenate"/>
    </xsl:template>


    <!-- ******************** -->
    <!-- *** Common Rules *** -->
    <!-- ******************** -->

    <!-- ignore / neglect the following elements -->
    <xsl:template match="draw:custom-shape | draw:g | office:forms | text:alphabetical-index-mark | text:alphabetical-index-mark-end | text:alphabetical-index-mark-start | text:bibliography-source | text:number | text:reference-mark-end | text:sequence-decls | text:soft-page-break | text:table-of-content-source | text:tracked-changes | text:user-field-decls"/>

    <!-- default template used by purpose-->
    <xsl:template match="text:bibliography | text:change-end | text:change-start">
        <xsl:param name="globalData"/>

        <xsl:apply-templates>
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- default template for not recognized elements -->
    <xsl:template match="*">
        <xsl:param name="globalData"/>
        <xsl:message>Using default element rule for ODF element '<xsl:value-of select="name()"/>'.</xsl:message>

        <xsl:apply-templates>
            <xsl:with-param name="globalData" select="$globalData"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="@*"/>

    <!-- allowing all matched text nodes -->
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>

</xsl:stylesheet>
