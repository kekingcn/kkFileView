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
    xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:c="urn:schemas-microsoft-com:office:component:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x2="http://schemas.microsoft.com/office/excel/2003/xml" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xlink">


    <!--+++++ INCLUDED XSL MODULES +++++-->

    <!-- helper collection, to convert measures (e.g. inch to pixel using DPI (dots per inch) parameter)-->
    <xsl:import  href="../../common/measure_conversion.xsl" />

    <!-- excel table handling -->
    <xsl:include  href="table.xsl" />

    <!-- mapping rules of office style properties to Excel style properties -->
    <xsl:include href="style_mapping.xsl" />

    <!-- creating the Excel styles element  -->
    <xsl:include href="styles.xsl" />

    <!-- mapping formular Expressions  -->
    <xsl:include href="formular.xsl" />

    <xsl:output method               = "xml"
                indent               = "no"
                encoding             = "UTF-8"
                omit-xml-declaration = "no" />

    <xsl:strip-space elements="ss:Data html:Data" />


    <!-- common table handling -->
    <xsl:variable name="namespace" select="'urn:schemas-microsoft-com:office:spreadsheet'" />

    <!--+++++ PARAMETER SECTION +++++-->

    <!-- OPTIONAL: (MANDATORY: for all input document with relative external links): parameter is a (relative) URL to the target directory.
         Relative links from the office document (e.g. to external graphics) will get this parameter as a prefix -->
    <xsl:param name="targetBaseURL" select="'./'" />

    <!-- OPTIONAL: (MANDATORY: for input document with relative internal links)
         To access contents of an office file (content like the meta.xml, styles.xml file or  graphics) a URL could be chosen.
     This could be even a JAR URL. The sourceBase of the content URL "jar:file:/C:/temp/Test.sxw!/content.xml" would be
     "jar:file:/C:/temp/Test.sxw!/" for example.
         When working with OpenOffice API a Package-URL encoded over HTTP can be used to access the jared contents of the jared document. -->
    <xsl:param name="sourceBaseURL" select="'./'" />

    <!-- OPTIONAL: (MANDATORY: for session management by URL rewriting)
         Useful for WebApplications: if a HTTP session is not cookie based, URL rewriting is being used (the session is appended to the URL).
         This URL session is used for example when links to graphics are created by XSLT. Otherwise the user has to log again in for every graphic he likes to see. -->
    <xsl:param name="optionalURLSuffix" />

    <!-- OPTIONAL: URL to office meta file (flat xml use the URL to the input file) -->
    <xsl:param name="metaFileURL" />

    <!-- OPTIONAL: URL to office meta file (flat xml use the URL to the input file) -->
    <xsl:param name="stylesFileURL" />

    <!-- OPTIONAL: in case of using a different processor than a JAVA XSLT, you can unable the Java functionality
         (e.g. encoding chapter names for the content-table as href and anchors ) -->
    <xsl:param name="java"        select="true()" />
    <xsl:param name="javaEnabled" select="boolean($java)" />

    <!-- OPTIONAL: for activating the debug mode set the variable here to 'true()' or give any value from outside -->
    <xsl:param name="debug"                    select="false()" />
    <xsl:param name="debugEnabled"             select="boolean($debug)" />

    <!-- matching configuration entries -->
    <xsl:key name="config" use="@config:name"
             match="/*/office:settings/config:config-item-set/config:config-item-map-indexed/config:config-item-map-entry/config:config-item |
                    /*/office:settings/config:config-item-set/config:config-item-map-indexed/config:config-item-map-entry/config:config-item-map-named/config:config-item-map-entry/config:config-item" />

    <xsl:key name="colors" match="/*/office:styles//@*[name() = 'fo:background-color' or name() = 'fo:color'] |
                                  /*/office:automatic-styles//@*[name() = 'fo:background-color' or name() = 'fo:color']" use="/" />
    <xsl:key name="colorRGB" match="@fo:background-color | @fo:color" use="." />
    <!-- *************************** -->
    <!-- *** Built up Excel file *** -->
    <!-- *************************** -->
    <xsl:template match="/">
        <xsl:processing-instruction  name="mso-application">progid="Excel.Sheet"</xsl:processing-instruction>
        <!-- Note: for debugging purpose include schema location
        <Workbook xsi:schemaLocation="urn:schemas-microsoft-com:office:spreadsheet <YOUR_SCHEMA_URL>/excelss.xsd"> -->
        <Workbook>
            <!-- adding some default settings -->
            <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
                <Colors>
                    <xsl:for-each select="key('colors', /)
                        [generate-id(.) =
                         generate-id(key('colorRGB', .)[1]) and starts-with(., '#')] ">
                    <xsl:sort select="." />
                    <Color>
                        <Index><xsl:value-of select="position() + 2" /></Index>
                        <RGB><xsl:value-of select="." /></RGB>
                    </Color>
                    </xsl:for-each>
                    <xsl:for-each select="key('config', 'TabColor')[not(.=preceding::config:config-item)]">
                    <xsl:sort select="." />
                    <Color>
                        <Index><xsl:value-of select="56 - position()" /></Index>
                        <RGB>
                            <xsl:call-template name="colordecimal2rgb">
                                <xsl:with-param name="colordecimal" select="."/>
                            </xsl:call-template>
                        </RGB>
                    </Color>
                    </xsl:for-each>
                </Colors>
            </OfficeDocumentSettings>
            <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
                <xsl:if test="key('config', 'HasSheetTabs') = 'false'">
                        <xsl:element name="HideWorkbookTabs" />
                </xsl:if>
                <WindowHeight>9000</WindowHeight>
                <WindowWidth>13860</WindowWidth>
                <WindowTopX>240</WindowTopX>
                <WindowTopY>75</WindowTopY>
                <ProtectStructure>False</ProtectStructure>
                <ProtectWindows>False</ProtectWindows>
            </ExcelWorkbook>
            <!-- Note: the following handling will exchange the default, later
                <x:ExcelWorkbook>
                    <xsl:apply-templates select="table:calculation-settings" />
                </x:ExcelWorkbook>
            -->
            <xsl:element name="Styles">
                <!-- our application default will not be used for export to Excel
                <xsl:apply-templates select="/*/office:styles/style:default-style" mode="styles" />-->
                <xsl:apply-templates select="/*/office:styles/style:style" mode="styles" />
                <xsl:apply-templates select="/*/office:automatic-styles/style:style" mode="styles" >
                    <xsl:with-param name="isAutomatic" select="true()" />
                </xsl:apply-templates>
            </xsl:element>
            <xsl:apply-templates select="/*/office:body" />
        </Workbook>
    </xsl:template>

    <xsl:template name="colordecimal2rgb">
        <xsl:param name="colordecimal"/>
        <xsl:choose>
            <xsl:when test="$colordecimal &lt;= 16777215 and $colordecimal &gt;= 65536">
                <xsl:variable name="redValue" select="floor(($colordecimal) div 65536)"/>
                <xsl:variable name="greenValue" select="floor(($colordecimal - ($redValue*65536)) div 256)"/>
                <xsl:variable name="blueValue" select="$colordecimal - ($redValue*65536) - ($greenValue*256)"/>
                <xsl:call-template name="dec_rgb2Hex">
                    <xsl:with-param name="decRedValue" select="$redValue"/>
                    <xsl:with-param name="decGreenValue" select="$greenValue"/>
                    <xsl:with-param name="decBlueValue" select="$blueValue"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$colordecimal &lt;= 65535 and $colordecimal &gt;= 256">
                <xsl:variable name="redValue" select="0"/>
                <xsl:variable name="greenValue" select="$colordecimal div 256"/>
                <xsl:variable name="blueValue" select="$colordecimal - ($greenValue*256)"/>
                <xsl:call-template name="dec_rgb2Hex">
                    <xsl:with-param name="decRedValue" select="$redValue"/>
                    <xsl:with-param name="decGreenValue" select="$greenValue"/>
                    <xsl:with-param name="decBlueValue" select="$blueValue"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$colordecimal &lt;= 255 and $colordecimal &gt;= 0">
                <xsl:variable name="redValue" select="0"/>
                <xsl:variable name="greenValue" select="0"/>
                <xsl:variable name="blueValue" select="$colordecimal"/>
                <xsl:call-template name="dec_rgb2Hex">
                    <xsl:with-param name="decRedValue" select="$redValue"/>
                    <xsl:with-param name="decGreenValue" select="$greenValue"/>
                    <xsl:with-param name="decBlueValue" select="$blueValue"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="dec_rgb2Hex">
        <xsl:param name="decRedValue"/>
        <xsl:param name="decGreenValue"/>
        <xsl:param name="decBlueValue"/>
        <xsl:variable name="hexRedValue">
            <xsl:variable name="tmpHexRedValue">
                <xsl:call-template name="decimal2hex">
                    <xsl:with-param name="dec-number" select="$decRedValue"/>
                    <xsl:with-param name="last-value" select="'H'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($tmpHexRedValue) = 1">
                    <xsl:value-of select="concat('0',$tmpHexRedValue)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$tmpHexRedValue"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="hexGreenValue">
            <xsl:variable name="tmpHexGreenValue">
                <xsl:call-template name="decimal2hex">
                    <xsl:with-param name="dec-number" select="$decGreenValue"/>
                    <xsl:with-param name="last-value" select="'H'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($tmpHexGreenValue) = 1">
                    <xsl:value-of select="concat('0',$tmpHexGreenValue)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$tmpHexGreenValue"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="hexBlueValue">
            <xsl:variable name="tmpHexBlueValue">
                <xsl:call-template name="decimal2hex">
                    <xsl:with-param name="dec-number" select="$decBlueValue"/>
                    <xsl:with-param name="last-value" select="'H'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($tmpHexBlueValue) = 1">
                    <xsl:value-of select="concat('0',$tmpHexBlueValue)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$tmpHexBlueValue"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat('#',$hexRedValue,$hexGreenValue,$hexBlueValue)"/>
    </xsl:template>
    <xsl:template name="decimal2hex">
        <!-- transforms a decimal number to a hex number,only for two-bit hex(less than 256 in decimal) currently -->
        <xsl:param name="dec-number"/>
        <xsl:param name="last-value"/>
        <xsl:variable name="current-value">
            <xsl:call-template name="decNumber2hex">
                <xsl:with-param name="dec-value">
                    <xsl:if test="$dec-number &gt; 15">
                        <xsl:value-of select="floor($dec-number div 16)"/>
                    </xsl:if>
                    <xsl:if test="$dec-number &lt; 16">
                        <xsl:value-of select="$dec-number"/>
                    </xsl:if>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$dec-number &gt; 15">
            <xsl:call-template name="decimal2hex">
                <xsl:with-param name="dec-number" select="$dec-number mod 16"/>
                <xsl:with-param name="last-value" select="concat($last-value,$current-value)"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$dec-number &lt; 16">
            <xsl:value-of select="substring-after(concat($last-value,$current-value),'H')"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="decNumber2hex">
        <!-- return a hex number for a decimal character -->
        <xsl:param name="dec-value"/>
        <xsl:choose>
            <xsl:when test="$dec-value = 10">
                <xsl:value-of select="'A'"/>
            </xsl:when>
            <xsl:when test="$dec-value = 11">
                <xsl:value-of select="'B'"/>
            </xsl:when>
            <xsl:when test="$dec-value = 12">
                <xsl:value-of select="'C'"/>
            </xsl:when>
            <xsl:when test="$dec-value = 13">
                <xsl:value-of select="'D'"/>
            </xsl:when>
            <xsl:when test="$dec-value = 14">
                <xsl:value-of select="'E'"/>
            </xsl:when>
            <xsl:when test="$dec-value = 15">
                <xsl:value-of select="'F'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$dec-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="GetTabColorIndex">
        <xsl:param name="SheetColor"/>
        <xsl:for-each select="key('config', 'TabColor')[not(.=preceding::config:config-item)]">
        <xsl:sort select="." />
            <xsl:variable name="tmpColor" select="."/>
            <xsl:if test=". = $SheetColor" >
                <xsl:value-of select="56 - position()"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="office:body">
        <!-- office:body table:table children are spreadsheets -->
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="office:spreadsheet">
        <xsl:apply-templates />
    </xsl:template>

    <!-- office:body table:table children are spreadsheets -->
    <xsl:template match="office:spreadsheet/table:table">
        <xsl:element name="ss:Worksheet">
            <xsl:variable name="TableName">
                <xsl:value-of select="@table:name" />
            </xsl:variable>
            <xsl:attribute name="ss:Name">
                <xsl:value-of select="$TableName" />
            </xsl:attribute>
            <xsl:call-template name="table:table" />
            <xsl:element name="x:WorksheetOptions">
                <xsl:if test="key('config', 'ShowGrid') = 'false'">
                        <xsl:element name="x:DoNotDisplayGridlines" />
                </xsl:if>
                <xsl:if test="key('config', 'HasColumnRowHeaders') = 'false'">
                        <xsl:element name="x:DoNotDisplayHeadings" />
                </xsl:if>
                <xsl:if test="key('config', 'IsOutlineSymbolsSet') = 'false'">
                        <xsl:element name="x:DoNotDisplayOutline" />
                </xsl:if>
                <xsl:if test="key('config', 'ShowZeroValues') = 'false'">
                        <xsl:element name="x:DoNotDisplayZeros" />
                </xsl:if>
                <xsl:if test="/*/office:settings/config:config-item-set/config:config-item-map-indexed/config:config-item-map-entry/config:config-item-map-named/config:config-item-map-entry[@config:name=$TableName]/config:config-item[@config:name='TabColor']">
                    <xsl:element name="x:TabColorIndex">
                        <xsl:variable name="TabColorIndex">
                            <xsl:call-template name="GetTabColorIndex">
                                <xsl:with-param name="SheetColor" select="/*/office:settings/config:config-item-set/config:config-item-map-indexed/config:config-item-map-entry/config:config-item-map-named/config:config-item-map-entry[@config:name=$TableName]/config:config-item[@config:name='TabColor']"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$TabColorIndex"/>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="table:decls" mode="ExcelWorkbook">
        <xsl:apply-templates mode="ExcelWorkbook" />
    </xsl:template>

    <xsl:template match="table:calculation-settings"  mode="ExcelWorkbook">
        <xsl:if test="table:precision-as-shown">
            <x:PrecisionAsDisplayed/>
        </xsl:if>
        <xsl:if test="table:null-date/@office:date-value='1904-01-01'">
            <x:Date1904/>
        </xsl:if>
        <xsl:apply-templates select="table:iteration" />
    </xsl:template>

    <xsl:template match="table:iteration" mode="ExcelWorkbook">
        <xsl:element name="x:ExcelWorkbook">
            <xsl:if test="@table:status = 'enable'">
                <x:Iteration/>
            </xsl:if>
            <xsl:if test="@table:steps">
                <xsl:element name="x:MaxIterations">
                    <xsl:value-of select="@table:steps" />
                </xsl:element>
            </xsl:if>
            <xsl:if test="@table:maximum-difference">
                <xsl:element name="x:MaxChange">
                    <xsl:value-of select="@table:maximum-difference" />
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
