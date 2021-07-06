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


    <!--+++++ INCLUDED XSL MODULES +++++-->

    <!-- inheritance of office style properties is resolved into absolute styles. Office properties gathered as elements -->
    <xsl:include href="../common/styles/style_collector.xsl" />

    <!-- mapping rules of office style properties to CSS/HTML properties -->
    <xsl:include href="../common/styles/style_mapping_css.xsl" />

    <!-- office header element handling especially for XHTML -->
    <xsl:include href="header.xsl" />

    <!-- office body element handling especially for XHTML -->
    <xsl:include href="body.xsl" />


    <xsl:output method               = "xml"
                encoding             = "UTF-8"
                media-type           = "application/xhtml+xml"
                indent               = "no"
                omit-xml-declaration = "no"
                doctype-public       = "-//W3C//DTD XHTML 1.1 plus MathML 2.0//EN"
                doctype-system       = "http://www.w3.org/Math/DTD/mathml2/xhtml-math11-f.dtd" />



    <xsl:variable name="namespace" select="'http://www.w3.org/1999/xhtml'" />

    <!--+++++ PARAMETER SECTION +++++-->

    <!-- OPTIONAL: if the document content is provided in a directory structure. Opposite to a single flat XML stream -->
    <xsl:param name="isPackageFormat" />

    <!-- OPTIONAL: (MANDATORY: for all input document with relative external links): parameter is an absolute file URL to the target directory.
         Relative links from the office document (e.g. to external graphics) will get this parameter as a prefix -->
    <xsl:param name="targetBaseURL" select="'./'" />

    <!-- OPTIONAL: (MANDATORY: for all input document with content table) : parameter is an absolute file URL to the target document.
         Relative links to this office document (e.g. to internal anchor) will get this parameter as a prefix -->
    <xsl:param name="targetURL" select="'./'" />

    <!-- OPTIONAL: (MANDATORY: for input document with relative internal links)
         To access contents of an office file (content like the meta.xml, styles.xml file or  graphics) a URL could be chosen.
     This could be even a JAR URL. The sourceBase of the content URL "jar:file:/C:/temp/Test.sxw!/content.xml" would be
     "jar:file:/C:/temp/Test.sxw!/" for example.
         When working with OpenOffice API a Package-URL encoded over HTTP can be used to access the jared contents of the jared document. -->
    <xsl:param name="sourceBaseURL" select="'./'" />

    <!-- OPTIONAL: (MANDATORY: for session management by URL rewriting)
         Useful for WebApplications: if a HTTP session is not cookie based, URL rewriting is being used (the session is appended to the URL).
         This URL session is used for example when links to graphics are created by XSLT. Otherwise the user have to log again in for every graphic he likes to see. -->
    <xsl:param name="optionalURLSuffix" />

    <!-- OPTIONAL: URL to office meta file (flat xml use the URL to the input file) -->
    <xsl:param name="metaFileURL" />

    <!-- OPTIONAL: URL to office meta file (flat xml use the URL to the input file) -->
    <xsl:param name="stylesFileURL" />

    <!-- OPTIONAL: DPI (dots per inch) the standard resolution of given pictures (necessary for the conversion of 'cm' into 'pixel')-->
    <!-- Although many pictures have a 96 dpi resolution, a higher resolution give better results for common browsers -->
    <!-- Cp. measure_conversion.xsl:
         <xsl:param name="dpi" select="111" /> -->


    <!-- OPTIONAL: in case of using a different processor than a JAVA XSLT, you can unable the Java functionality
         (e.g. encoding chapter names for the content-table as href and anchors ) -->
    <xsl:param name="java"        select="true()" />
    <xsl:param name="javaEnabled" select="boolean($java)" />

    <!-- OPTIONAL: for activating the debug mode set the variable here to 'true()' or give any value from outside -->
    <xsl:param name="debug"                    select="false()" />
    <xsl:param name="debugEnabled"             select="boolean($debug)" />
    <xsl:param name="onlyStyleOutput"          select="false()" />
    <xsl:param name="onlyStyleOutputEnabled"   select="boolean($onlyStyleOutput)" />

    <!-- *************************************** -->
    <!-- *** build the appropriate HTML file *** -->
    <!-- *************************************** -->
    <xsl:template match="/">
        <!-- debug output of parameter value set -->
        <xsl:if test="$debugEnabled">
            <xsl:call-template name="debug-check-parameter" />
        </xsl:if>
        <!-- gathers style properties and
            returns them as globalData parameter to the 'start-main' template            -->
        <xsl:call-template name="collect-global-odf-properties" />
    </xsl:template>


    <!-- *************************** -->
    <!-- *** Built up XHTML file *** -->
    <!-- *************************** -->
    <xsl:template name="start-main">
        <xsl:param name="globalData" />

        <xsl:element name="html">
            <xsl:comment>This file was converted to xhtml by LibreOffice - see https://cgit.freedesktop.org/libreoffice/core/tree/filter/source/xslt for the code.</xsl:comment>
            <xsl:call-template name='create-header'>
                <xsl:with-param name="globalData" select="$globalData" />
            </xsl:call-template>

            <xsl:call-template name='create-body'>
                <xsl:with-param name="globalData" select="$globalData" />
            </xsl:call-template>
        </xsl:element>
    </xsl:template>


    <!-- debug purpose only:
         verbose checking of the parameters of this template-->
    <xsl:template name="debug-check-parameter">
        <xsl:message>Parameter dpi: <xsl:value-of select="$dpi" /></xsl:message>
        <xsl:message>Parameter metaFileURL: <xsl:value-of select="$metaFileURL" /></xsl:message>
        <xsl:message>Parameter stylesFileURL: <xsl:value-of select="$stylesFileURL" /></xsl:message>
        <xsl:message>Parameter sourceBaseURL: <xsl:value-of select="$sourceBaseURL" /></xsl:message>
        <xsl:message>Parameter targetBaseURL: <xsl:value-of select="$targetBaseURL" /></xsl:message>
        <xsl:message>Parameter onlyStyleOutputEnabled: <xsl:value-of select="$onlyStyleOutputEnabled" /></xsl:message>
        <xsl:message>Parameter debugEnabled: <xsl:value-of select="$debugEnabled" /></xsl:message>
        <xsl:message>Parameter java: <xsl:value-of select="$java" /></xsl:message>
        <xsl:message>Parameter javaEnabled: <xsl:value-of select="$javaEnabled" /></xsl:message>
    </xsl:template>

</xsl:stylesheet>
