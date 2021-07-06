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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" exclude-result-prefixes="w wx aml o dt fo v">
    <xsl:template match="o:DocumentProperties">
        <office:meta>
            <meta:generator>Microsoft Word 2003</meta:generator>
            <dc:title>
                <xsl:value-of select="o:Title"/>
            </dc:title>
            <dc:description>
                <xsl:value-of select="o:Description"/>
            </dc:description>
            <dc:subject>
                <xsl:value-of select="o:Subject"/>
            </dc:subject>
            <meta:initial-creator>
                <xsl:value-of select="o:Author"/>
            </meta:initial-creator>
            <meta:creation-date>
                <xsl:value-of select="substring-before( o:Created, 'Z')"/>
            </meta:creation-date>
            <dc:creator>
                <xsl:value-of select="o:LastAuthor"/>
            </dc:creator>
            <xsl:if test="string-length(substring-before( o:LastSaved, 'Z')) &gt; 0">
                <dc:date>
                    <xsl:value-of select="substring-before( o:LastSaved, 'Z')"/>
                </dc:date>
            </xsl:if>
            <!-- comment out the below line now because Oasis format doesn't allow the meta:print-by to be empty element -->
            <!--meta:printed-by /-->
            <xsl:if test="string-length(substring-before( o:LastPrinted, 'Z')) &gt; 0">
                <!--
            <meta:print-date>
                <xsl:value-of select="substring-before( o:LastPrinted, 'Z')"/>
            </meta:print-date>
            -->
            </xsl:if>
            <meta:keyword>
                <xsl:value-of select="o:Keywords"/>
            </meta:keyword>
            <meta:editing-cycles>
                <xsl:value-of select="o:Revision"/>
            </meta:editing-cycles>
            <meta:editing-duration>
                <xsl:if test="o:TotalTime">
                    <xsl:value-of select="concat('PT', floor(o:TotalTime div 60), 'H', o:TotalTime mod 60, 'M0S')"/>
                </xsl:if>
            </meta:editing-duration>
            <meta:user-defined meta:name="Category" meta:value-type="string">
                <xsl:value-of select="o:Category"/>
            </meta:user-defined>
            <meta:user-defined meta:name="Manager" meta:value-type="string">
                <xsl:value-of select="o:Manager"/>
            </meta:user-defined>
            <meta:user-defined meta:name="Company" meta:value-type="string">
                <xsl:value-of select="o:Company"/>
            </meta:user-defined>
            <meta:user-defined meta:name="Version" meta:value-type="string">
                <xsl:value-of select="o:Version"/>
            </meta:user-defined>
            <meta:user-defined meta:name="HyperlinkBase" meta:value-type="string">
                <xsl:value-of select="o:HyperlinkBase"/>
            </meta:user-defined>
            <xsl:apply-templates select="../o:CustomDocumentProperties"/>
            <meta:document-statistic meta:page-count="{o:Pages}" meta:paragraph-count="{o:Paragraphs}" meta:word-count="{o:Words}" meta:character-count="{o:Characters}"/>
        </office:meta>
    </xsl:template>
    <xsl:template match="o:CustomDocumentProperties">
        <xsl:for-each select="node()[@dt:dt]">
            <meta:user-defined meta:name="{local-name()}" meta:value-type="{@dt:dt}">
                <xsl:value-of select="."/>
            </meta:user-defined>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
