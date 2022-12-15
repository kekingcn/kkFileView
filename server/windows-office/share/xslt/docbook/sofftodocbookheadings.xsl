<?xml version='1.0' encoding="UTF-8"?>
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
<xsl:stylesheet version="1.0" xmlns:style="http://openoffice.org/2000/style" xmlns:text="http://openoffice.org/2000/text" xmlns:office="http://openoffice.org/2000/office" xmlns:table="http://openoffice.org/2000/table" xmlns:draw="http://openoffice.org/2000/drawing" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="http://openoffice.org/2000/meta" xmlns:number="http://openoffice.org/2000/datastyle" xmlns:svg="http://www.w3.org/2000/svg" xmlns:chart="http://openoffice.org/2000/chart" xmlns:dr3d="http://openoffice.org/2000/dr3d" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="http://openoffice.org/2000/form" xmlns:script="http://openoffice.org/2000/script" xmlns:config="http://openoffice.org/2001/config" office:class="text" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="office meta table number dc fo xlink chart math script xsl draw svg dr3d form config text style">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="no" version="1.0" encoding="UTF-8" doctype-public="-//OASIS//DTD DocBook XML V4.1.2//EN" doctype-system="http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd"/>


    <!-- Heading will be mapped to sections.
         In OpenDocument headings are not nested, they do not embrace their related content, the XML hierarchy has to be restructured.

        Example of OpenDocument content:

        <office:body>
            <text:h text:style-name="Heading 1" text:level="1">Heading 1</text:h>
            <text:p text:style-name="Text body">Heading 1 Content</text:p>
            <text:h text:style-name="Heading 2" text:level="2">Heading 2</text:h>
            <text:p text:style-name="Text body">Heading 2 Content</text:p>
        <office:body>

        Example of DocBook content:

        <article lang="en-US">
            <sect1>
                <title>Heading 1</title>
                <para>Heading 1 Content</para>
                <sect2>
                    <title>Heading 2</title>
                    <para>Heading 2 Content</para>
                </sect2>
            </sect1>
        </article>
    -->

    <!-- The key function "nestedContent" returns all ODF elements that are children of the current heading (i.e. text:h) or their parent office:body in case there is no text:h.
        It works by matching all ODF elements, that text:h refer to (it's sibling or office:body childring)
        Various keyed element sets of these matched elements are being generated. A set is identified by having the same last (closest) preceding text:h or if none existent the parent document.
        All those elements, that have the current heading as last preceding heading (text:h) are returned as a nodeset.
    -->
    <xsl:key name="nestedContent"
             match="text:p | table:table | text:span | text:ordered-list | office:annotation | text:unordered-list | text:footnote | text:a | text:list-item | draw:plugin | draw:text-box | text:footnote-body | text:section"
             use="generate-id((.. | preceding::text:h)[last()])"/>

    <!-- The key function "nestedHeadings" returns a nodeset of all heading (text:h) elements, which belong to this heading (follow and have a higher outline number than the current text:h, which ID is given to the function) -->
    <xsl:key name="nestedHeadings"
             match="text:h"
             use="generate-id(preceding::text:h[@text:level &lt; current()/@text:level][1])"/>

    <!-- The key function "getHeadingsByOutline" returns all headings of a certain outline level -->
    <xsl:key name="getHeadingsByOutline"
             match="text:h"
             use="@text:level"/>

    <!-- A further problem during mapping of Heading to sections is the quantity of levels. In OpenDocument there can exist more than 4 hierarchies (outline levels).
    Furthermore an OpenDocument have not to start with heading outline level 1 nor does an outline level 2 have to follow.
    Therefore all possible existing heading outline levels from 1 to 10 have to be mapped to the section1 to section4 in DocBook.
    The lowest outline number is mapped section1, second is section2... until fourth and higher are all mapped to section4 -->

    <!-- Each global variable hold the outline level which has been mapped to one of the four sections in DocBook   -->
    <xsl:variable name="section1_OutlineLevel">
        <xsl:call-template name="findOutlineLevel">
            <xsl:with-param name="candidateOutlineLevel" select="1"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="section2_OutlineLevel">
        <xsl:call-template name="findOutlineLevel">
            <xsl:with-param name="candidateOutlineLevel" select="$section1_OutlineLevel + 1"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="section3_OutlineLevel">
        <xsl:call-template name="findOutlineLevel">
            <xsl:with-param name="candidateOutlineLevel" select="$section2_OutlineLevel + 1"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="section4_OutlineLevel">
        <xsl:call-template name="findOutlineLevel">
            <xsl:with-param name="candidateOutlineLevel" select="$section3_OutlineLevel + 1"/>
        </xsl:call-template>
    </xsl:variable>

    <!-- get the minimum available heading outline level (usually '1') -->
    <xsl:template name="findOutlineLevel">
        <xsl:param name="candidateOutlineLevel"/>
        <xsl:choose>
            <xsl:when test="key('getHeadingsByOutline', $candidateOutlineLevel)[1]/@text:level != ''">
                <xsl:value-of select="$candidateOutlineLevel"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$candidateOutlineLevel &lt; 11">
                    <xsl:call-template name="findOutlineLevel">
                        <xsl:with-param name="candidateOutlineLevel" select="$candidateOutlineLevel + 1"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- START -->
    <xsl:template match="/*">
        <xsl:element name="article">
            <xsl:attribute name="lang">
                <xsl:value-of select="/*/office:meta/dc:language"/>
            </xsl:attribute>
            <!-- page style header -->
            <xsl:call-template name="page-style">
                <xsl:with-param name="area" select="'header'"/>
            </xsl:call-template>
            <xsl:apply-templates select="office:body"/>
            <!-- page style footer -->
            <xsl:call-template name="page-style"/>
        </xsl:element>
    </xsl:template>


    <xsl:key match="style:master-page" name="styleMasterPage" use="@style:name" />
    <!-- using a simple heuristic for "standard" page-style heading/footer from page styles -->
    <xsl:template name="page-style">
        <xsl:param name="area"/>

        <xsl:variable name="defaultPageStyle" select="key('styleMasterPage', 'Standard')"/>
        <xsl:choose>
            <xsl:when test="$area = 'header'">
                <xsl:apply-templates select="$defaultPageStyle/style:header/*"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$defaultPageStyle/style:footer/*"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="office:body">
        <!-- here all children of office:body before the first heading are matched -->
        <xsl:apply-templates select="key('nestedContent', generate-id())"/>
        <!-- have to be descendant as text:h can be in a list:item in some list -->
        <xsl:variable name="firstHeading" select="descendant::text:h[1]"/>
        <!-- changing the context node from office:body to text:h as required for used key functions -->
        <xsl:for-each select="descendant::text:h[@text:level=$section1_OutlineLevel][1]">
            <!-- if the first heading is not of the section1 level -->
            <xsl:if test="generate-id(.) != generate-id($firstHeading)">
                <!-- create an anonymous section1 and embrace all headings preceding the first real existent section1 -->
                <xsl:element name="sect1">
                    <title></title>
                    <!-- create sections for all the first section1 preluding headings -->
                    <xsl:for-each select="key('getHeadingsByOutline', $section1_OutlineLevel)[1]/preceding::text:h">
                        <xsl:call-template name="make-section">
                            <xsl:with-param name="previousSectionLevel" select="$section1_OutlineLevel"/>
                            <xsl:with-param name="currentSectionLevel">
                                <xsl:call-template name="getSectionLevel">
                                    <xsl:with-param name="outlineLevel" select="@text:level"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
        <!-- match all headings, which are mapped to section1 to create a nested section structure used in docbook (see first comment after copyright) -->
        <xsl:apply-templates mode="recreateStructure" select="descendant::text:h[@text:level = $section1_OutlineLevel]"/>
    </xsl:template>

    <xsl:template match="text:h" mode="recreateStructure">
        <!-- relate the current ODF outline level of the heading to one of the four docbook section levels-->
        <xsl:variable name="currentSectionLevel">
            <xsl:call-template name="getSectionLevel">
                <xsl:with-param name="outlineLevel" select="@text:level"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <!-- heading with outline level 1 might be an Abstract  -->
            <xsl:when test="$currentSectionLevel = 1">
                <xsl:choose>
                    <!-- when the content of a level 1 heading is 'Abstract' the <abstract> docbook element is used instead of <section1>  -->
                    <xsl:when test=".='Abstract'">
                        <abstract>
                            <xsl:apply-templates select="key('nestedContent', generate-id())"/>
                            <xsl:apply-templates select="key('nestedHeadings', generate-id())" mode="recreateStructure"/>
                        </abstract>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="make-section">
                            <xsl:with-param name="currentSectionLevel" select="$currentSectionLevel"/>
                            <xsl:with-param name="previousSectionLevel" select="$currentSectionLevel"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="previousHeading" select="preceding::text:h[@text:level &lt; current()/@text:level][1]"/>
                <xsl:choose>
                    <xsl:when test="$previousHeading/@text:level != ''">
                        <xsl:call-template name="make-section">
                            <xsl:with-param name="currentSectionLevel" select="$currentSectionLevel"/>
                            <xsl:with-param name="previousSectionLevel">
                                <xsl:call-template name="getSectionLevel">
                                    <xsl:with-param name="outlineLevel" select="$previousHeading/@text:level"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="make-section">
                            <xsl:with-param name="currentSectionLevel" select="$currentSectionLevel"/>
                            <xsl:with-param name="previousSectionLevel" select="$currentSectionLevel"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text:bookmark | text:bookmark-start">
        <xsl:element name="anchor">
            <xsl:attribute name="id">
                <!-- ID have to be an NCName which have to start with a letter or '_'
                    in case of the frequent starting number a '_' will be added as prefix -->
                <xsl:choose>
                    <xsl:when test="(starts-with(@text:name, '0') or
                                     starts-with(@text:name, '1') or
                                     starts-with(@text:name, '2') or
                                     starts-with(@text:name, '3') or
                                     starts-with(@text:name, '4') or
                                     starts-with(@text:name, '5') or
                                     starts-with(@text:name, '6') or
                                     starts-with(@text:name, '7') or
                                     starts-with(@text:name, '8') or
                                     starts-with(@text:name, '9'))">
                        <xsl:value-of select="concat('_', @text:name)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@text:name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template name="getSectionLevel">
        <xsl:param name="outlineLevel"/>
        <xsl:choose>
            <xsl:when test="$outlineLevel = $section1_OutlineLevel">1</xsl:when>
            <xsl:when test="$outlineLevel = $section2_OutlineLevel">2</xsl:when>
            <xsl:when test="$outlineLevel = $section3_OutlineLevel">3</xsl:when>
            <xsl:otherwise>4</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- make-section creates the nested section hierarchy and
         in case the difference between the parent section and the new section is higher than one
         a section is inserted to keep the output format valid  -->
    <xsl:template name="make-section">
        <xsl:param name="currentSectionLevel"/>
        <xsl:param name="previousSectionLevel"/>
        <xsl:choose>
            <!-- empty title as it is an empty section between two headings with an outline level difference higher than 1 -->
            <xsl:when test="$currentSectionLevel &gt; $previousSectionLevel+1">
                <xsl:element name="{concat('sect', $previousSectionLevel + 1)}">
                    <title></title>
                    <xsl:call-template name="make-section">
                        <xsl:with-param name="currentSectionLevel" select="$currentSectionLevel"/>
                        <xsl:with-param name="previousSectionLevel" select="$previousSectionLevel +1"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{concat('sect', $currentSectionLevel)}">
                    <title>
                        <xsl:apply-templates/>
                    </title>
                    <xsl:apply-templates select="key('nestedContent', generate-id())"/>
                    <xsl:apply-templates select="key('nestedHeadings', generate-id())" mode="recreateStructure"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="office:meta">
    <!--<xsl:apply-templates/>--></xsl:template>

    <xsl:template match="meta:editing-cycles"></xsl:template>

    <xsl:template match="meta:user-defined"></xsl:template>

    <xsl:template match="meta:editing-duration"></xsl:template>

    <xsl:template match="dc:language"></xsl:template>

    <xsl:template match="dc:date">
    <!--<pubdate>
        <xsl:value-of select="substring-before(.,'T')"/>
    </pubdate>--></xsl:template>

    <xsl:template match="meta:creation-date"></xsl:template>

    <xsl:template match="office:styles">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="office:script"></xsl:template>


    <xsl:template match="office:settings"></xsl:template>

    <xsl:template match="office:font-decls"></xsl:template>

    <xsl:template match="text:section">
        <xsl:choose>
            <xsl:when test="@text:name='ArticleInfo'">
                <articleinfo>
                    <title>
                        <xsl:value-of select="text:p[@text:style-name='Document Title']"/>
                    </title>
                    <subtitle>
                        <xsl:value-of select="text:p[@text:style-name='Document SubTitle']"/>
                    </subtitle>
                    <edition>
                        <xsl:value-of select="text:p/text:variable-set[@text:name='articleinfo.edition']"/>
                    </edition>
                    <xsl:for-each select="text:p/text:variable-set[substring-after(@text:name,'articleinfo.releaseinfo')]">
                        <releaseinfo>
                            <xsl:value-of select="."/>
                        </releaseinfo>
                    </xsl:for-each>
                    <xsl:call-template name="ArticleInfo">
                        <xsl:with-param name="level" select="0"/>
                    </xsl:call-template>
                </articleinfo>
            </xsl:when>
            <xsl:when test="@text:name='Abstract'">
                <abstract>
                    <xsl:apply-templates/>
                </abstract>
            </xsl:when>
            <xsl:when test="@text:name='Appendix'">
                <appendix>
                    <xsl:apply-templates/>
                </appendix>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{concat('sect', count(ancestor::text:section) + 1)}">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@text:name"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="ArticleInfo">
        <xsl:param name="level"/>
        <xsl:variable name="author">
            <xsl:value-of select="concat('articleinfo.author_','', $level)"/>
        </xsl:variable>
        <xsl:if test="text:p/text:variable-set[contains(@text:name, $author )]">
            <xsl:call-template name="Author">
                <xsl:with-param name="AuthorLevel" select="0"/>
            </xsl:call-template>
            <xsl:call-template name="Copyright">
                <xsl:with-param name="CopyrightLevel" select="0"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Copyright">
        <xsl:param name="CopyrightLevel"/>

        <xsl:variable name="Copyright">
            <xsl:value-of select="concat('articleinfo.copyright_','', $CopyrightLevel)"/>
        </xsl:variable>

        <xsl:if test="text:p/text:variable-set[contains(@text:name,$Copyright)]">
            <copyright>
                <xsl:call-template name="Year">
                    <xsl:with-param name="CopyrightLevel" select="$CopyrightLevel"/>
                    <xsl:with-param name="YearlLevel" select="0"/>
                </xsl:call-template>
                <xsl:call-template name="Holder">
                    <xsl:with-param name="CopyrightLevel" select="$CopyrightLevel"/>
                    <xsl:with-param name="HolderlLevel" select="0"/>

                </xsl:call-template>
            </copyright>
        </xsl:if>
    </xsl:template>


    <xsl:template name="Year">
        <xsl:param name="CopyrightLevel"/>
        <xsl:param name="YearLevel"/>
        <xsl:variable name="Copyright">
            <xsl:value-of select="concat('articleinfo.copyright_','', $CopyrightLevel)"/>
        </xsl:variable>
        <xsl:variable name="Year">
            <xsl:value-of select="concat($Copyright,'',concat('.year_','',$YearLevel))"/>
        </xsl:variable>

        <xsl:if test="text:p/text:variable-set[@text:name=$Year]">
            <orgname>
                <xsl:value-of select="text:p/text:variable-set[@text:name=$Year]"/>
            </orgname>
        </xsl:if>
    </xsl:template>


    <xsl:template name="Holder">
        <xsl:param name="CopyrightLevel"/>
        <xsl:param name="HolderLevel"/>
        <xsl:variable name="Copyright">
            <xsl:value-of select="concat('articleinfo.copyright_','', $CopyrightLevel)"/>
        </xsl:variable>
        <xsl:variable name="Holder">
            <xsl:value-of select="concat($Copyright,'',concat('.holder_','',$HolderLevel))"/>
        </xsl:variable>

        <xsl:if test="text:p/text:variable-set[@text:name=$Holder]">
            <orgname>
                <xsl:value-of select="text:p/text:variable-set[@text:name=$Holder]"/>
            </orgname>
        </xsl:if>
    </xsl:template>



    <xsl:template name="Author">
        <xsl:param name="AuthorLevel"/>
        <xsl:variable name="Author">
            <xsl:value-of select="concat('articleinfo.author_','', $AuthorLevel)"/>
        </xsl:variable>
        <xsl:if test="text:p/text:variable-set[contains(@text:name, $Author )]">
            <author>
                <xsl:call-template name="Surname">
                    <xsl:with-param name="AuthorLevel" select="$AuthorLevel"/>
                    <xsl:with-param name="SurnameLevel" select="0"/>
                </xsl:call-template>
                <xsl:call-template name="Firstname">
                    <xsl:with-param name="AuthorLevel" select="$AuthorLevel"/>
                    <xsl:with-param name="FirstnameLevel" select="0"/>
                </xsl:call-template>
                <xsl:call-template name="Affiliation">
                    <xsl:with-param name="AuthorLevel" select="$AuthorLevel"/>
                    <xsl:with-param name="AffilLevel" select="0"/>
                </xsl:call-template>
            </author>
            <xsl:call-template name="Author">
                <xsl:with-param name="AuthorLevel" select="$AuthorLevel+1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    <xsl:template name="Surname">
        <xsl:param name="AuthorLevel"/>
        <xsl:param name="SurnameLevel"/>
        <xsl:variable name="Author">
            <xsl:value-of select="concat('articleinfo.author_','', $AuthorLevel)"/>
        </xsl:variable>
        <xsl:variable name="Surname">
            <xsl:value-of select="concat($Author,'',concat('.surname_','',$SurnameLevel))"/>
        </xsl:variable>
        <xsl:if test="text:p/text:variable-set[@text:name=$Surname]">
            <surname>
                <xsl:value-of select="text:p/text:variable-set[@text:name=$Surname]"/>
            </surname>
            <xsl:call-template name="Surname">
                <xsl:with-param name="AuthorLevel" select="$AuthorLevel"/>
                <xsl:with-param name="SurnameLevel" select="SurnameLevel+1"/>
            </xsl:call-template>

        </xsl:if>
    </xsl:template>




    <xsl:template name="Firstname">
        <xsl:param name="AuthorLevel"/>
        <xsl:param name="FirstnameLevel"/>
        <xsl:variable name="Author">
            <xsl:value-of select="concat('articleinfo.author_','', $AuthorLevel)"/>
        </xsl:variable>
        <xsl:variable name="Firstname">
            <xsl:value-of select="concat($Author,'',concat('.firstname_','',$FirstnameLevel))"/>
        </xsl:variable>
        <xsl:if test="text:p/text:variable-set[@text:name=$Firstname]">
            <firstname>
                <xsl:value-of select="text:p/text:variable-set[@text:name=$Firstname]"/>
            </firstname>
            <xsl:call-template name="Surname">
                <xsl:with-param name="AuthorLevel" select="$AuthorLevel"/>
                <xsl:with-param name="FirstnameLevel" select="FirstnameLevel+1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>



    <xsl:template name="Affiliation">
        <xsl:param name="AuthorLevel"/>
        <xsl:param name="AffilLevel"/>
        <xsl:variable name="Author">
            <xsl:value-of select="concat('articleinfo.author_','', $AuthorLevel)"/>
        </xsl:variable>
        <xsl:variable name="Affil">
            <xsl:value-of select="concat($Author,'',concat('.affiliation_','',$AffilLevel))"/>
        </xsl:variable>
        <xsl:if test="text:p/text:variable-set[contains(@text:name,$Affil)]">
            <affiliation>
                <xsl:call-template name="Orgname">
                    <xsl:with-param name="AuthorLevel" select="$AuthorLevel"/>
                    <xsl:with-param name="AffilLevel" select="$AffilLevel"/>
                    <xsl:with-param name="OrgLevel" select="0"/>
                </xsl:call-template>
                <xsl:call-template name="Address">
                    <xsl:with-param name="AuthorLevel" select="$AuthorLevel"/>
                    <xsl:with-param name="AffilLevel" select="$AffilLevel"/>
                    <xsl:with-param name="AddressLevel" select="0"/>

                </xsl:call-template>
            </affiliation>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Orgname">
        <xsl:param name="AuthorLevel"/>
        <xsl:param name="AffilLevel"/>
        <xsl:param name="OrgLevel"/>

        <xsl:variable name="Author">
            <xsl:value-of select="concat('articleinfo.author_','', $AuthorLevel)"/>
        </xsl:variable>
        <xsl:variable name="Affil">
            <xsl:value-of select="concat($Author,'',concat('.affiliation_','',$AffilLevel))"/>
        </xsl:variable>
        <xsl:variable name="Org">
            <xsl:value-of select="concat($Affil,'',concat('.orgname_','',$OrgLevel))"/>
        </xsl:variable>

        <xsl:if test="text:p/text:variable-set[@text:name=$Org]">
            <orgname>
                <xsl:value-of select="text:p/text:variable-set[@text:name=$Org]"/>
            </orgname>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Address">
        <xsl:param name="AuthorLevel"/>
        <xsl:param name="AffilLevel"/>
        <xsl:param name="AddressLevel"/>

        <xsl:variable name="Author">
            <xsl:value-of select="concat('articleinfo.author_','', $AuthorLevel)"/>
        </xsl:variable>
        <xsl:variable name="Affil">
            <xsl:value-of select="concat($Author,'',concat('.affiliation_','',$AffilLevel))"/>
        </xsl:variable>
        <xsl:variable name="Address">
            <xsl:value-of select="concat($Affil,'',concat('.address_','',$AddressLevel))"/>
        </xsl:variable>

        <xsl:if test="text:p/text:variable-set[@text:name=$Address]">
            <address>
                <xsl:value-of select="text:p/text:variable-set[@text:name=$Address]"/>
            </address>
        </xsl:if>
    </xsl:template>




    <xsl:template match="text:p[@text:style-name='Document Title']"></xsl:template>

    <xsl:template match="text:p[@text:style-name='Document SubTitle']"></xsl:template>


    <xsl:template match="text:p[@text:style-name='Section Title']">
        <xsl:element name="title">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text:p[@text:style-name='Appendix Title']">
        <xsl:element name="title">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


<!--<xsl:template match="text:p[@text:style-name='VarList Item']">
    <xsl:if test="not(preceding-sibling::text:p[@text:style-name='VarList Item'])">
        <xsl:text disable-output-escaping="yes">&lt;listitem&gt;</xsl:text>
    </xsl:if>
        <para>
            <xsl:apply-templates/>
        </para>
    <xsl:if test="not(following-sibling::text:p[@text:style-name='VarList Item'])">
        <xsl:text disable-output-escaping="yes">&lt;/listitem&gt;</xsl:text>
    </xsl:if>
</xsl:template>-->


    <xsl:template match="text:p[@text:style-name='Section1 Title']">
        <xsl:element name="title">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="text:p[@text:style-name='Section2 Title']">
        <xsl:element name="title">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="text:p[@text:style-name='Section3 Title']">
        <xsl:element name="title">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text:footnote-citation"></xsl:template>

    <xsl:template match="text:p[@text:style-name='Mediaobject']">
        <mediaobject>
            <xsl:apply-templates/>
        </mediaobject>
    </xsl:template>

    <xsl:template match="office:annotation/text:p">
        <note>
            <remark>
                <xsl:apply-templates/>
            </remark>
        </note>
    </xsl:template>

<!--<xsl:template match="meta:initial-creator">
    <author>
    <xsl:apply-templates />
        </author>
</xsl:template>-->

    <xsl:template match="table:table">
        <xsl:choose>
            <xsl:when test="following-sibling::text:p[@text:style-name='Table']">
                <table frame="all">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@table:name"/>
                    </xsl:attribute>
                    <title>
                        <xsl:value-of select="following-sibling::text:p[@text:style-name='Table']"/>
                    </title>
                    <xsl:call-template name="generictable"/>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <informaltable frame="all">
                    <xsl:call-template name="generictable"/>
                </informaltable>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="generictable">
        <xsl:variable name="cells" select="count(descendant::table:table-cell)"></xsl:variable>
        <xsl:variable name="rows">
            <xsl:value-of select="count(descendant::table:table-row)"/>
        </xsl:variable>
        <xsl:variable name="cols">
            <xsl:value-of select="$cells div $rows"/>
        </xsl:variable>
        <xsl:variable name="numcols">
            <xsl:choose>
                <xsl:when test="child::table:table-column/@table:number-columns-repeated">
                    <xsl:value-of select="number(table:table-column/@table:number-columns-repeated+1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$cols"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="tgroup">
            <xsl:attribute name="cols">
                <xsl:value-of select="$numcols"/>
            </xsl:attribute>
            <xsl:call-template name="colspec">
                <xsl:with-param name="left" select="1"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="colspec">
        <xsl:param name="left"/>
        <xsl:if test="number($left &lt; ( table:table-column/@table:number-columns-repeated +2) )">
            <xsl:element name="colspec">
                <xsl:attribute name="colnum">
                    <xsl:value-of select="$left"/>
                </xsl:attribute>
                <xsl:attribute name="colname">c<xsl:value-of select="$left"/>
                </xsl:attribute>
            </xsl:element>
            <xsl:call-template name="colspec">
                <xsl:with-param name="left" select="$left+1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="table:table-column">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="table:table-header-rows">
        <thead>
            <xsl:apply-templates/>
        </thead>
    </xsl:template>

    <xsl:template match="table:table-header-rows/table:table-row">
        <row>
            <xsl:apply-templates/>
        </row>
    </xsl:template>

    <xsl:template match="table:table/table:table-row">
        <xsl:if test="not(preceding-sibling::table:table-row)">
            <xsl:text disable-output-escaping="yes">&lt;tbody&gt;</xsl:text>
        </xsl:if>
        <row>
            <xsl:apply-templates/>
        </row>
        <xsl:if test="not(following-sibling::table:table-row)">
            <xsl:text disable-output-escaping="yes">&lt;/tbody&gt;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="table:table-cell">
        <xsl:element name="entry">
            <xsl:if test="@table:number-columns-spanned >'1'">
                <xsl:attribute name="namest">
                    <xsl:value-of select="concat('c',count(preceding-sibling::table:table-cell[not(@table:number-columns-spanned)]) +sum(preceding-sibling::table:table-cell/@table:number-columns-spanned)+1)"/>
                </xsl:attribute>
                <xsl:attribute name="nameend">
                    <xsl:value-of select="concat('c',count(preceding-sibling::table:table-cell[not(@table:number-columns-spanned)]) +sum(preceding-sibling::table:table-cell/@table:number-columns-spanned)+ @table:number-columns-spanned)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text:p">
        <xsl:choose>
            <xsl:when test="@text:style-name='Table'"></xsl:when>
            <xsl:otherwise>
                <para>
                    <xsl:apply-templates/>
                </para>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:key match="text:list-style" name="getListStyle" use="@style:name"/>

    <xsl:template match="text:ordered-list">
        <xsl:param name="outlineLevel" select="1"/>

        <xsl:variable name="listStyle" select="key('getListStyle', @text:style-name)/*[@text:level = $outlineLevel]"/>

        <!-- if the list is not recognizable as a list (e.g. no indent, number/bullet, etc.) the list will be ignored -->
        <xsl:if test="$listStyle/style:properties/@*">
            <orderedlist>
                <xsl:apply-templates>
                    <xsl:with-param name="itemType" select="'listitem'"/>
                    <xsl:with-param name="outlineLevel" select="$outlineLevel + 1"/>
                </xsl:apply-templates>
            </orderedlist>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text:unordered-list">
        <xsl:param name="outlineLevel" select="1"/>

        <xsl:variable name="listStyle" select="key('getListStyle', @text:style-name)/*[@text:level = $outlineLevel]"/>
        <!-- if the list is not recognizable as a list (e.g. no indent, number/bullet, etc.) the list will be ignored -->
        <xsl:if test="$listStyle/style:properties/@*">
            <xsl:choose>
                <xsl:when test="@text:style-name='Var List'">
                    <variablelist>
                        <xsl:apply-templates>
                            <xsl:with-param name="itemType" select="'varlist'"/>
                            <xsl:with-param name="outlineLevel" select="$outlineLevel + 1"/>
                        </xsl:apply-templates>
                    </variablelist>
                </xsl:when>
                <xsl:otherwise>
                    <itemizedlist>
                        <xsl:apply-templates>
                            <xsl:with-param name="itemType" select="'listitem'"/>
                            <xsl:with-param name="outlineLevel" select="$outlineLevel + 1"/>
                        </xsl:apply-templates>
                    </itemizedlist>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text:list-item | text:list-header">
        <xsl:param name="listType"/>
        <xsl:param name="outlineLevel"/>

        <xsl:choose>
            <xsl:when test="$listType='Var List'">
                <xsl:element name="varlistentry">
                    <xsl:apply-templates>
                        <xsl:with-param name="outlineLevel" select="$outlineLevel"/>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="listitem">
                    <xsl:apply-templates>
                        <xsl:with-param name="outlineLevel" select="$outlineLevel"/>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text:p[@text:style-name='VarList Term']">
        <xsl:element name="term">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text:p[@text:style-name='VarList Item']">
        <xsl:element name="para">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- text headings should only be matched once, when creating a nested docbook section structure, but might be as well become as part of a list a title -->
    <xsl:template match="text:h">
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>

    <xsl:template match="dc:title"></xsl:template>

    <xsl:template match="dc:description">
        <abstract>
            <para>
                <xsl:apply-templates/>
            </para>
        </abstract>
    </xsl:template>

    <xsl:template match="dc:subject"></xsl:template>


    <xsl:template match="meta:generator"></xsl:template>

    <xsl:template match="draw:plugin">
        <xsl:element name="audioobject">
            <xsl:attribute name="fileref">
                <xsl:value-of select="@xlink:href"/>
            </xsl:attribute>
            <xsl:attribute name="width"></xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text:footnote">
        <footnote>
            <xsl:apply-templates/>
        </footnote>
    </xsl:template>

    <xsl:template match="text:footnote-body">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="draw:text-box"></xsl:template>



    <xsl:template match="draw:image">
        <xsl:choose>
            <xsl:when test="parent::text:p[@text:style-name='Mediaobject']">
                <xsl:element name="imageobject">
                    <xsl:element name="imagedata">
                        <xsl:attribute name="fileref">
                            <xsl:value-of select="@xlink:href"/>
                        </xsl:attribute>
                    </xsl:element>
                    <xsl:element name="caption">
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="inlinegraphic">
                    <xsl:attribute name="fileref">
                        <xsl:choose>
                            <xsl:when test="@xlink:href != ''">
                                <xsl:value-of select="@xlink:href"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>embedded:</xsl:text>
                                <xsl:value-of select="@draw:name"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="width">
                        <xsl:value-of select="@svg:width"/>
                    </xsl:attribute>
                    <xsl:attribute name="depth">
                        <xsl:value-of select="@svg:height"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="text:span">
        <xsl:choose>
            <xsl:when test="./@text:style-name='GuiMenu'">
                <xsl:element name="guimenu">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="./@text:style-name='GuiSubMenu'">
                <xsl:element name="guisubmenu">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@text:style-name='GuiMenuItem'">
                <xsl:element name="guimenuitem">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@text:style-name='GuiButton'">
                <xsl:element name="guibutton">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@text:style-name='GuiButton'">
                <xsl:element name="guibutton">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@text:style-name='GuiLabel'">
                <xsl:element name="guilabel">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@text:style-name='Emphasis'">
                <xsl:element name="emphasis">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@text:style-name='FileName'">
                <xsl:element name="filename">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@text:style-name='Application'">
                <xsl:element name="application">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@text:style-name='Command'">
                <command>
                    <xsl:apply-templates/>
                </command>
            </xsl:when>
            <xsl:when test="@text:style-name='SubScript'">
                <subscript>
                    <xsl:apply-templates/>
                </subscript>
            </xsl:when>
            <xsl:when test="@text:style-name='SuperScript'">
                <superscript>
                    <xsl:apply-templates/>
                </superscript>
            </xsl:when>
            <xsl:when test="@text:style-name='SystemItem'">
                <systemitem>
                    <xsl:apply-templates/>
                </systemitem>
            </xsl:when>
            <xsl:when test="@text:style-name='ComputerOutput'">
                <computeroutput>
                    <xsl:apply-templates/>
                </computeroutput>
            </xsl:when>
            <xsl:when test="@text:style-name='Highlight'">
                <highlight>
                    <xsl:apply-templates/>
                </highlight>
            </xsl:when>
            <xsl:when test="@text:style-name='KeyCap'">
                <keycap>
                    <xsl:apply-templates/>
                </keycap>
            </xsl:when>
            <xsl:when test="@text:style-name='KeySym'">
                <xsl:element name="keysym">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@text:style-name='KeyCombo'">
                <keycombo>
                    <xsl:apply-templates/>
                </keycombo>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <xsl:template match="text:a">
        <xsl:choose>
            <xsl:when test="contains(@xlink:href,'://')">
                <xsl:element name="ulink">
                    <xsl:attribute name="url">
                        <xsl:value-of select="@xlink:href"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="contains(@xlink:href,'mailto:')">
                <xsl:element name="ulink">
                    <xsl:attribute name="url">
                        <xsl:value-of select="@xlink:href"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="not(contains(@xlink:href,'#'))">
                <xsl:element name="olink">
                    <xsl:attribute name="targetdocent">
                        <xsl:value-of select="@xlink:href"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="linkvar" select="substring-after(@xlink:href,'#')"/>
                <xsl:element name="link">
                    <xsl:attribute name="linkend">
                        <xsl:value-of select="substring-before($linkvar,'%')"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!--
    Change Made By Kevin Fowlks (fowlks@msu.edu) July 2nd, 2003
    This allows users to create example code in DocBook.

    Note: This type of grouping could also be implemented for
    <notes>,<literallayout>, <blockquote> or any other tag that requires text to be treated as blocked.
-->
    <xsl:template match="text:p[@text:style-name='Example']">
        <xsl:if test="not(preceding-sibling::*[1][self::text:p[@text:style-name='Example']])">
            <xsl:element name="example">
                <xsl:element name="title"></xsl:element>
                <xsl:element name="programlisting">
                    <xsl:value-of select="."/>
                    <xsl:text disable-output-escaping="no">&#xD;</xsl:text>
                    <xsl:apply-templates mode="in-list" select="following-sibling::*[1][self::text:p[@text:style-name='Example']]"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text:p[@text:style-name='Example']" mode="in-list">
        <xsl:value-of select="."/>
        <xsl:text disable-output-escaping="no">&#xD;</xsl:text>
        <xsl:apply-templates mode="in-list" select="following-sibling::*[1][self::text:p[@text:style-name='Example']]"/>
    </xsl:template>

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

    <xsl:template match="text:tab-stop">
        <xsl:call-template name="write-breakable-whitespace">
            <xsl:with-param name="whitespaces" select="8"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
