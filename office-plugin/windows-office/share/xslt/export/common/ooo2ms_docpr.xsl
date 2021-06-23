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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" exclude-result-prefixes="office table style text draw svg   dc config xlink meta oooc dom ooo chart math dr3d form script ooow draw">
    <xsl:template match="office:meta">
        <o:DocumentProperties>
            <o:Title>
                <xsl:value-of select="dc:title"/>
            </o:Title>
            <o:Subject>
                <xsl:value-of select="dc:subject"/>
            </o:Subject>
            <o:Keywords>
                <xsl:for-each select="meta:keywords/meta:keyword">
                    <xsl:value-of select="."/>
                    <xsl:if test="position()!=last()">, </xsl:if>
                </xsl:for-each>
            </o:Keywords>
            <o:Description>
                <xsl:value-of select="dc:description"/>
            </o:Description>
            <o:Category>
                <xsl:value-of select="meta:user-defined[@meta:name = 'Category']"/>
            </o:Category>
            <o:Author>
                <xsl:value-of select="meta:initial-creator"/>
            </o:Author>
            <o:LastAuthor>
                <xsl:value-of select="dc:creator"/>
            </o:LastAuthor>
            <o:Manager>
                <xsl:value-of select="meta:user-defined[@meta:name = 'Manager']"/>
            </o:Manager>
            <o:Company>
                <xsl:value-of select="meta:user-defined[@meta:name = 'Company']"/>
            </o:Company>
            <o:HyperlinkBase>
                <xsl:value-of select="meta:user-defined[@meta:name = 'HyperlinkBase']"/>
            </o:HyperlinkBase>
            <o:Revision>
                <xsl:value-of select="meta:editing-cycles"/>
            </o:Revision>
            <!-- PresentationFormat, Guid, AppName, Version -->
            <o:TotalTime>
                <xsl:if test="meta:editing-duration">
                    <xsl:variable name="hours">
                        <xsl:choose>
                            <xsl:when test="contains(meta:editing-duration, 'H')">
                                <xsl:value-of select="substring-before( substring-after( meta:editing-duration, 'PT'), 'H')"/>
                            </xsl:when>
                            <xsl:otherwise>0</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="minutes">
                        <xsl:choose>
                            <xsl:when test="contains(meta:editing-duration, 'M') and contains(meta:editing-duration, 'H')">
                                <xsl:value-of select="substring-before( substring-after( meta:editing-duration, 'H'), 'M')"/>
                            </xsl:when>
                            <xsl:when test="contains(meta:editing-duration, 'M')">
                                <xsl:value-of select="substring-before( substring-after( meta:editing-duration, 'PT'), 'M')"/>
                            </xsl:when>
                            <xsl:otherwise>0</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:value-of select="$hours * 60 + $minutes"/>
                </xsl:if>
            </o:TotalTime>
            <o:LastPrinted>
                <xsl:if test="meta:print-date">
                    <xsl:value-of select="concat( meta:print-date, 'Z')"/>
                </xsl:if>
            </o:LastPrinted>
            <o:Created>
                <xsl:if test="meta:creation-date">
                    <xsl:value-of select="concat( meta:creation-date, 'Z')"/>
                </xsl:if>
            </o:Created>
            <o:LastSaved>
                <xsl:if test="dc:date">
                    <xsl:value-of select="concat( dc:date, 'Z')"/>
                </xsl:if>
            </o:LastSaved>
            <o:Pages>
                <xsl:value-of select="meta:document-statistic/@meta:page-count"/>
            </o:Pages>
            <o:Words>
                <xsl:value-of select="meta:document-statistic/@meta:word-count"/>
            </o:Words>
            <o:Characters>
                <xsl:value-of select="meta:document-statistic/@meta:character-count"/>
            </o:Characters>
            <!-- CharactersWithSpaces, Bytes, Lines -->
            <o:Paragraphs>
                <xsl:value-of select="meta:document-statistic/@meta:paragraph-count"/>
            </o:Paragraphs>
        </o:DocumentProperties>
        <o:CustomDocumentProperties>
            <o:Editor dt:dt="string">
                <xsl:value-of select="meta:generator"/>
            </o:Editor>
            <o:Language dt:dt="string">
                <xsl:value-of select="dc:language"/>
            </o:Language>
            <xsl:for-each select="meta:user-defined">
                <!-- transfer strings to XML QName, necessary to convert several characters -->
                <!-- &#x7b;&#x7d; -->
                <xsl:variable name="foo">.,| ~`!@#$%^*()&amp;&lt;&gt;+=[];:&quot;/\?{}'</xsl:variable>
                <xsl:element name="{concat( 'o:', translate(@meta:name,string($foo),'_'))}">
                    <xsl:attribute name="dt:dt">string</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>
        </o:CustomDocumentProperties>
    </xsl:template>
</xsl:stylesheet>
