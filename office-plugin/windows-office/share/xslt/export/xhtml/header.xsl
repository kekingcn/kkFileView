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
    exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xforms xlink xsd xsi xforms xsd xsi"
    xmlns="http://www.w3.org/1999/xhtml">

    <!-- ************** -->
    <!-- *** header *** -->
    <!-- ************** -->

    <xsl:template name="create-header">
        <xsl:param name="globalData" />

        <xsl:element name="head">
        <xsl:attribute name="profile">http://dublincore.org/documents/dcmi-terms/</xsl:attribute>
            <xsl:if test="$debugEnabled"><xsl:message>CSS helper variable will be created...</xsl:message></xsl:if>
            <xsl:call-template name='xhtml-header-properties'>
                <xsl:with-param name="globalData" select="$globalData" />
            </xsl:call-template>

            <xsl:if test="$debugEnabled"><xsl:message>CSS variable ready, header will be created...</xsl:message></xsl:if>
            <!-- constructing the css header simulating inheritance of style-families by style order -->
            <xsl:call-template name='create-css-styleheader'>
                <xsl:with-param name="globalData" select="$globalData" />
            </xsl:call-template>
            <xsl:if test="$debugEnabled"><xsl:message>CSS header creation finished!</xsl:message></xsl:if>
        </xsl:element>

    </xsl:template>

    <!-- Creating a CSS style header from the collected styles of the 'globalData' parameter -->
    <xsl:template name='create-css-styleheader'>
        <xsl:param name="globalData" />

        <xsl:element name="style">
            <xsl:attribute name="type">text/css</xsl:attribute>
<xsl:text>
    </xsl:text>
    <xsl:call-template name='create-page-layout'>
        <xsl:with-param name="globalData" select="$globalData" />
    </xsl:call-template>
<xsl:text>table { border-collapse:collapse; border-spacing:0; empty-cells:show }
    </xsl:text>
    <xsl:choose>
        <xsl:when test="/*/office:body/office:spreadsheet"><xsl:text>td, th { vertical-align:top; font-size:10pt;}
    </xsl:text></xsl:when>
        <xsl:otherwise><xsl:text>td, th { vertical-align:top; font-size:12pt;}
    </xsl:text></xsl:otherwise>
    </xsl:choose>
<xsl:text>h1, h2, h3, h4, h5, h6 { clear:both;}
    </xsl:text>
<xsl:choose>
    <xsl:when test="/*/office:body/office:spreadsheet">
        <xsl:text>p { white-space: nowrap; }
    </xsl:text>
    </xsl:when>
</xsl:choose>
<xsl:text>ol, ul { margin:0; padding:0;}
    </xsl:text>
<xsl:text>li { list-style: none; margin:0; padding:0;}
    </xsl:text>
<xsl:text>/* "li span.odfLiEnd" - IE 7 issue*/</xsl:text>
<xsl:text>
    </xsl:text>
<xsl:text>li span. { clear: both; line-height:0; width:0; height:0; margin:0; padding:0; }
    </xsl:text>
<xsl:text>span.footnodeNumber { padding-right:1em; }
    </xsl:text>
<xsl:text>span.annotation_style_by_filter { font-size:95%; font-family:Arial; background-color:#fff000;  margin:0; border:0; padding:0;  }
    </xsl:text>
<!-- Simulate tabs. They are around 0.64cm in LO, we convert that to 0.8rem. -->
<xsl:text>span.heading_numbering { margin-right: 0.8rem; }</xsl:text>
<xsl:text>* { margin:0;}
    </xsl:text>
            <xsl:call-template name="write-mapped-CSS-styles">
                <xsl:with-param name="globalData" select="$globalData" />
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <xsl:template name="write-mapped-CSS-styles">
        <xsl:param name="globalData" />
        <xsl:param name="emptyStyles"/>

            <xsl:for-each select="$globalData/all-styles/style">
                    <xsl:if test="final-properties != ''">
                        <!-- NOTE: easy process, as only the style family in conjunction with the style name, makes the style unambiguous -->
                        <xsl:text>.</xsl:text><!--<xsl:value-of select="@style:family" /><xsl:text>:</xsl:text>--><xsl:value-of select="translate(@style:name, '.,;: %()[]/\+', '_____________')"/><xsl:text> { </xsl:text> <xsl:value-of select="final-properties" /><xsl:text>}
    </xsl:text>
                    </xsl:if>

            </xsl:for-each>
            <!-- Otherwise all styles have been processed and the empty styles have to be given out -->
                <xsl:text>/* ODF styles with no properties representable as CSS */</xsl:text><xsl:text>
    </xsl:text><xsl:for-each select="$globalData/all-styles/style[final-properties = '']"><xsl:value-of select="concat('.', @style:name, ' ')"/></xsl:for-each> { }
    </xsl:template>

    <!-- Creating CSS page layout based on first office master style -->
    <xsl:template name='create-page-layout'>
        <xsl:param name="globalData" />

        <!-- approximation to find the correct master page style (with page dimensions) -->
        <xsl:variable name="masterPageNames">
            <!-- set context to styles.xml -->
            <xsl:for-each select="$globalData/all-doc-styles/style">
                <!-- Loop over every style:style containing a @style:master-page-name attribute -->
                <xsl:for-each select="key('masterPage','count')">
                        <!-- set context to styles.xml -->
                        <xsl:for-each select="/*/office:body">
                            <!-- Check if this style is being used in the body -->
                            <xsl:if test="key('elementUsingStyle', ../@style:name)">
                                <!-- Check every master-page-name if it is not empty and return as ';' separated list  -->
                                <xsl:if test="string-length(../@style:master-page-name) &gt; 0"><xsl:value-of select="../@style:master-page-name"/>;</xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <!-- Take the first of the masterpage list and get the according style:master-page element and find the @style:page-layout-name  -->
        <xsl:variable name="pageLayoutName" select="key('masterPageElements', substring-before($masterPageNames,';'))/@style:page-layout-name"/>
         <!-- Find the according style:page-layout and store the properties in a variable  -->
        <xsl:variable name="pageProperties" select="key('pageLayoutElements', $pageLayoutName)/style:page-layout-properties"/>

<xsl:text>@page { </xsl:text>

        <xsl:call-template name="page-size">
            <xsl:with-param name="globalData"       select="$globalData" />
            <xsl:with-param name="pageProperties"   select="$pageProperties" />
        </xsl:call-template>
        <xsl:call-template name="page-margin">
            <xsl:with-param name="globalData"       select="$globalData" />
            <xsl:with-param name="pageProperties"   select="$pageProperties" />
        </xsl:call-template>

<xsl:text> }
    </xsl:text>

    </xsl:template>


    <xsl:template name="page-size">
        <xsl:param name="globalData" />
        <xsl:param name="pageProperties" />

        <xsl:variable name="printOrientation"  select="$pageProperties/@style:print-orientation" />
        <xsl:variable name="pageWidth"         select="$pageProperties/@fo:page-width" />
        <xsl:variable name="pageHeight"        select="$pageProperties/@fo:page-height" />
        <xsl:choose>
            <xsl:when test="$pageWidth and $pageHeight">
                <xsl:text>size: </xsl:text>
                <xsl:value-of select="$pageWidth" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$pageHeight" />
                <xsl:text>; </xsl:text>
            </xsl:when>
            <xsl:when test="$printOrientation">
                <xsl:text>size: </xsl:text>
                <xsl:value-of select="$printOrientation" />
                <xsl:text>; </xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="page-margin">
        <xsl:param name="globalData" />
        <xsl:param name="pageProperties" />

        <xsl:variable name="marginTop"  select="$pageProperties/@fo:margin-top" />
        <xsl:if test="$marginTop">
            <xsl:text>margin-top: </xsl:text>
            <xsl:value-of select="$marginTop" />
            <xsl:text>; </xsl:text>
        </xsl:if>
        <xsl:variable name="marginBottom"  select="$pageProperties/@fo:margin-bottom" />
        <xsl:if test="$marginBottom">
            <xsl:text>margin-bottom: </xsl:text>
            <xsl:value-of select="$marginBottom" />
            <xsl:text>; </xsl:text>
        </xsl:if>
        <xsl:variable name="marginLeft"  select="$pageProperties/@fo:margin-left" />
        <xsl:if test="$marginLeft">
            <xsl:text>margin-left: </xsl:text>
            <xsl:value-of select="$marginLeft" />
            <xsl:text>; </xsl:text>
        </xsl:if>
        <xsl:variable name="marginRight"  select="$pageProperties/@fo:margin-right" />
        <xsl:if test="$marginRight">
            <xsl:text>margin-right: </xsl:text>
            <xsl:value-of select="$marginRight" />
        </xsl:if>
    </xsl:template>

    <!-- *************************** -->
    <!-- *** Common XHTML header *** -->
    <!-- *************************** -->

    <xsl:template name='xhtml-header-properties'>
        <xsl:param name="globalData" />

        <xsl:variable name="netloc">
        <xsl:for-each select="$globalData/meta-file/*/office:meta/meta:user-defined">
        <xsl:if test="./@meta:name='ODF.base'">
        <xsl:value-of select="." />
        </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$globalData/meta-file/*/office:meta/meta:user-defined">
        <xsl:if test="./@meta:name='ODF.filename'">
        <xsl:value-of select="." />
        </xsl:if>
        </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="lang">
             <xsl:choose>
                 <xsl:when test="$globalData/meta-file/*/office:meta/dc:language">
                     <xsl:value-of select="$globalData/meta-file/*/office:meta/dc:language" />
                 </xsl:when>
                 <xsl:otherwise>en-US</xsl:otherwise>
             </xsl:choose>
        </xsl:variable>

        <xsl:variable name="prov">
             <xsl:choose>
                 <xsl:when test="$globalData/meta-file/*/office:meta/meta:printed-by">
                     <xsl:value-of select="concat('Printed by &quot;',$globalData/meta-file/*/office:meta/meta:printed-by,'&quot;[dc:publisher] on &quot;',$globalData/meta-file/*/office:meta/meta:print-date,'&quot;[dc:date] in &quot;',$lang,'&quot;[dc:language]')" />
                 </xsl:when>
                 <xsl:otherwise />
             </xsl:choose>
        </xsl:variable>

        <xsl:variable name="keywords">
            <xsl:for-each select="$globalData/meta-file/*/office:meta/meta:keyword">
                <xsl:value-of select="." />
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <!-- explicit output content-type for low-tech browser (e.g. IE6) -->
        <xsl:element name="meta">
            <xsl:attribute name="http-equiv">Content-Type</xsl:attribute>
            <xsl:attribute name="content">application/xhtml+xml; charset=utf-8</xsl:attribute>
        </xsl:element>

        <!-- title of document for browser frame title -->
        <xsl:element name="title">
        <xsl:attribute name="xml:lang">
            <xsl:value-of select="$lang" />
        </xsl:attribute>

            <xsl:choose>
                <xsl:when test="$globalData/meta-file/*/office:meta/dc:title">
                    <xsl:value-of select="$globalData/meta-file/*/office:meta/dc:title" />
                </xsl:when>
                <!-- providing the mandatory title is a workaround for an IE bug-->
                <xsl:otherwise>
                    <xsl:text>- no title specified</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>

        <!-- title, in DC syntax -->
        <xsl:element name="meta">
            <xsl:attribute name="name">DCTERMS.title</xsl:attribute>
            <xsl:attribute name="content">
               <xsl:value-of select="$globalData/meta-file/*/office:meta/dc:title" />
            </xsl:attribute>
            <xsl:attribute name="xml:lang">
               <xsl:value-of select="$lang" />
            </xsl:attribute>
        </xsl:element>

        <!-- the identifier for source  (identifier) -->
        <xsl:call-template name="add-meta-tag">
            <xsl:with-param name="meta-name" select="'DCTERMS.identifier'" />
            <xsl:with-param name="meta-data" select="translate($netloc, ' ','')" />
            <xsl:with-param name="meta-enc" select="'DCTERMS.URI'" />
        </xsl:call-template>

        <!-- the language for source  (language) -->
        <xsl:call-template name="add-meta-tag">
            <xsl:with-param name="meta-name" select="'DCTERMS.language'" />
            <xsl:with-param name="meta-data" select="$lang" />
            <xsl:with-param name="meta-enc" select="'DCTERMS.RFC4646'" />
        </xsl:call-template>

        <!-- a bit commercial (generator) -->
        <xsl:element name="meta">
            <xsl:attribute name="name">DCTERMS.source</xsl:attribute>
            <xsl:attribute name="content">http://xml.openoffice.org/odf2xhtml</xsl:attribute>
        </xsl:element>

        <!-- the author of the input source (author) -->
        <xsl:call-template name="add-meta-tag">
            <xsl:with-param name="meta-name" select="'DCTERMS.creator'" />
            <xsl:with-param name="meta-data" select="$globalData/meta-file/*/office:meta/meta:initial-creator" />
        </xsl:call-template>

        <!-- creation-date of the input source (issued) -->
        <xsl:call-template name="add-meta-tag">
            <xsl:with-param name="meta-name" select="'DCTERMS.issued'" />
            <xsl:with-param name="meta-data" select="$globalData/meta-file/*/office:meta/meta:creation-date" />
            <xsl:with-param name="meta-enc" select="'DCTERMS.W3CDTF'" />
        </xsl:call-template>

        <!-- name of last changing person of the input source (changedby) -->
        <xsl:call-template name="add-meta-tag">
            <xsl:with-param name="meta-name" select="'DCTERMS.contributor'" />
            <xsl:with-param name="meta-data" select="$globalData/meta-file/*/office:meta/dc:creator" />
        </xsl:call-template>

        <!-- last changing date of the input source (changed) -->
        <xsl:call-template name="add-meta-tag">
            <xsl:with-param name="meta-name" select="'DCTERMS.modified'" />
            <xsl:with-param name="meta-data" select="$globalData/meta-file/*/office:meta/dc:date" />
            <xsl:with-param name="meta-enc" select="'DCTERMS.W3CDTF'" />
        </xsl:call-template>

        <!-- Last print, as provenance -->
        <xsl:if test="$prov">
        <xsl:call-template name="add-meta-tag">
            <xsl:with-param name="meta-name" select="'DCTERMS.provenance'" />
            <xsl:with-param name="meta-data" select="$prov" />
            <xsl:with-param name="meta-lang" select="$lang" />
        </xsl:call-template>
        </xsl:if>

        <!-- keywords about the input source (keywords) -->
        <xsl:call-template name="add-meta-tag">
            <xsl:with-param name="meta-name" select="'DCTERMS.subject'" />
            <xsl:with-param name="meta-data" select="normalize-space(concat($globalData/meta-file/*/office:meta/dc:subject,',   ',$keywords))" />
            <xsl:with-param name="meta-lang" select="$lang" />
        </xsl:call-template>

        <!-- detailed description about the input source (description) -->
        <xsl:call-template name="add-meta-tag">
            <xsl:with-param name="meta-name" select="'DCTERMS.description'" />
            <xsl:with-param name="meta-data" select="$globalData/meta-file/*/office:meta/dc:description" />
            <xsl:with-param name="meta-lang" select="$lang" />
        </xsl:call-template>


        <!-- user defined use of DCTERM tags -->
        <xsl:for-each select="$globalData/meta-file/*/office:meta/meta:user-defined[starts-with(@meta:name,'DCTERMS.')][not(.='')]">
        <xsl:call-template name="add-meta-tag">
            <xsl:with-param name="meta-name" select="@meta:name" />
            <xsl:with-param name="meta-data" select="." />
            <!-- <xsl:with-param name="meta-lang" select="$lang" /> -->
        </xsl:call-template>
        </xsl:for-each>
        <!-- user defined use of DC tags (legacy) -->
        <xsl:for-each select="$globalData/meta-file/*/office:meta/meta:user-defined[starts-with(@meta:name,'DC.')][not(.='')]">
        <xsl:call-template name="add-meta-tag">
            <xsl:with-param name="meta-name" select="@meta:name" />
            <xsl:with-param name="meta-data" select="." />
            <!-- <xsl:with-param name="meta-lang" select="$lang" /> -->
        </xsl:call-template>
        </xsl:for-each>

        <link rel="schema.DC" href="http://purl.org/dc/elements/1.1/" hreflang="en" />
        <link rel="schema.DCTERMS" href="http://purl.org/dc/terms/" hreflang="en" />
        <link rel="schema.DCTYPE" href="http://purl.org/dc/dcmitype/" hreflang="en" />
        <link rel="schema.DCAM" href="http://purl.org/dc/dcam/" hreflang="en" />
        <!-- W3C GRDDL Profile -->
        <!--
        <link rel="transformation" href="http://xml.openoffice.org/odf2xhtml/rdf-extract.xsl" />
        -->

        <!-- base URL of document for resolving relative links
        NOTE: CHROME has a problem, with relative references as from content table, referencing to root directory instead of document
        <xsl:element name="base">
            <xsl:attribute name="href">-->
                <!-- earlier 'targetURL' was used for an absolute reference of base provided by the Office (file URL)
                    <xsl:value-of select="$targetURL" />
                    now '.' let relative links work, even if document has been moved -->
                <!--<xsl:text>.</xsl:text>
            </xsl:attribute>
        </xsl:element>-->
    </xsl:template>

    <!-- generic template for adding common meta tags -->
    <xsl:template name="add-meta-tag">
        <xsl:param name="meta-name" />
        <xsl:param name="meta-data" />
        <xsl:param name="meta-enc" />
        <xsl:param name="meta-lang" />

        <xsl:if test="$meta-data">
            <xsl:element name="meta">
                <xsl:attribute name="name">
                    <xsl:value-of select="$meta-name" />
                </xsl:attribute>
                <xsl:attribute name="content">
                    <xsl:value-of select="$meta-data" />
                </xsl:attribute>
                <xsl:if test="$meta-enc">
                <xsl:attribute name="scheme">
                    <xsl:value-of select="$meta-enc" />
                </xsl:attribute>
                </xsl:if>
                <xsl:if test="$meta-lang">
                <xsl:attribute name="xml:lang">
                    <xsl:value-of select="$meta-lang" />
                </xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
