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
        xmlns:xt="http://www.jclark.com/xt"
        xmlns:common="http://exslt.org/common"
        xmlns:xalan="http://xml.apache.org/xalan"
        exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xforms xlink xsd xsi xt common xalan">



    <!-- ***************************************** -->
    <!-- *** Gathering office style properties *** -->
    <!-- ***************************************** -->

    <!-- REASON FOR STYLESHEET:
            In the OpenOffice documents styles are represented by a hierarchy.
            (e.g. most styles are inherited from a default style).
            Many other languages (as XHTML/CSS) do not support inherited styles.
            The style inheritance have to be made flat/absolute for each style.

            A further reason was, that the earlier style collection mechanism
            had problems with CSS inline, which do not inherit from XML office defaults
            nor font:family defaults as the style header does
            (cp. stylesheet 'style_collector.xsl' and the 'write-default-styles' template)

         RESULT OF STYLESHEET:
            All styles will be returned in a variable containing styles with their inherited *:

                <all-styles>
                    <style style:family="foo" style:name="x1">
                        <* fo:padding-left="0cm" fo:margin-right="0cm" />
                    </style>
                    <style style:family="muh" style:name="x2" >
                        <* fo:padding-left="3cm" ...                  />
                    </style>
                    ...

                </all-styles>
    -->


    <xsl:template name="collect-global-odf-properties">
        <!-- to access the variable as a node-set by XPATH expressions, it is necessary to convert it
             from a result-tree-fragment (RTF) to a node set by a in a XSLT 1.0 non standardized function -->
        <xsl:variable name="globalDataRTF">
            <xsl:call-template name="collect-document-links-RTF" />
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="function-available('common:node-set')">
                <xsl:call-template name="collect-style-properties">
                    <xsl:with-param name="globalData" select="common:node-set($globalDataRTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xalan:nodeset')">
                <xsl:call-template name="collect-style-properties">
                    <xsl:with-param name="globalData" select="xalan:nodeset($globalDataRTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xt:node-set')">
                <xsl:call-template name="collect-style-properties">
                    <xsl:with-param name="globalData" select="xt:node-set($globalDataRTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">The required node-set function was not found!</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template name="collect-style-properties">
        <xsl:param name="globalData" />

        <!-- Add the input file references to the new collected style properties -->
        <xsl:variable name="globalDataRTF">
            <xsl:copy-of select="$globalData" />
            <xsl:call-template name="collect-style-properties-RTF">
                <xsl:with-param name="globalData" select="$globalData" />
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="function-available('common:node-set')">
                <xsl:call-template name="map-odf-style-properties">
                    <xsl:with-param name="globalData" select="common:node-set($globalDataRTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xalan:nodeset')">
                <xsl:call-template name="map-odf-style-properties">
                    <xsl:with-param name="globalData" select="xalan:nodeset($globalDataRTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xt:node-set')">
                <xsl:call-template name="map-odf-style-properties">
                    <xsl:with-param name="globalData" select="xt:node-set($globalDataRTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">The required node-set function was not found!</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="collect-document-links-RTF">
        <!-- works for zipped office files, unzipped office files as for flat filter single office file format as well -->
        <xsl:variable name="documentLinksRTF">
            <xsl:choose>
                <xsl:when test="office:document-content">
                    <xsl:element name="styles-file" namespace="">
                        <xsl:copy-of select="document(concat($sourceBaseURL, 'styles.xml'), .)" />
                    </xsl:element>
                    <xsl:element name="meta-file" namespace="">
                        <xsl:copy-of select="document(concat($sourceBaseURL, 'meta.xml'), .)" />
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="styles-file" namespace="">
                        <xsl:copy-of select="/" />
                    </xsl:element>
                    <xsl:element name="meta-file" namespace="">
                        <xsl:copy-of select="/" />
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="function-available('common:node-set')">
                <xsl:call-template name="collect-document-links">
                    <xsl:with-param name="documentLinks" select="common:node-set($documentLinksRTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xalan:nodeset')">
                <xsl:call-template name="collect-document-links">
                    <xsl:with-param name="documentLinks" select="xalan:nodeset($documentLinksRTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xt:node-set')">
                <xsl:call-template name="collect-document-links">
                    <xsl:with-param name="documentLinks" select="xt:node-set($documentLinksRTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">The required node-set function was not found!</xsl:message>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <xsl:template name="collect-document-links">
        <xsl:param name="documentLinks" />

        <xsl:element name="styles-file" namespace="">
            <xsl:copy-of select="$documentLinks/styles-file/*" />
        </xsl:element>

        <xsl:element name="meta-file" namespace="">
            <xsl:copy-of select="$documentLinks/meta-file/*" />
        </xsl:element>

        <xsl:copy-of select="$documentLinks/styles-file/*/office:styles" />
        <xsl:copy-of select="$documentLinks/styles-file/*/office:font-face-decls" />

        <!-- office:automatic-styles may be contained in two files (i.e. content.xml and styles.xml).
             Wild card necessary as top level element differs from flat office files ("SampleName.fsxw") -->
        <xsl:copy-of select="/*/office:automatic-styles" />

    </xsl:template>


    <xsl:template name="collect-style-properties-RTF">
        <xsl:param name="globalData" />

       <!--** DEFAULT STYLES: First adding some office defaults unwritten in XML -->
        <xsl:variable name="defaultOfficeStyle-RTF">
            <xsl:element name="style" namespace="">
                <xsl:element name="style:properties" />
            </xsl:element>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="function-available('common:node-set')">
                <xsl:call-template name="collect-properties-defaults">
                    <xsl:with-param name="globalData" select="$globalData" />
                    <xsl:with-param name="defaultOfficeStyle" select="common:node-set($defaultOfficeStyle-RTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xalan:nodeset')">
                <xsl:call-template name="collect-properties-defaults">
                    <xsl:with-param name="globalData" select="$globalData" />
                    <xsl:with-param name="defaultOfficeStyle" select="xalan:nodeset($defaultOfficeStyle-RTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xt:node-set')">
                <xsl:call-template name="collect-properties-defaults">
                    <xsl:with-param name="globalData" select="$globalData" />
                    <xsl:with-param name="defaultOfficeStyle" select="xt:node-set($defaultOfficeStyle-RTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">ERROR: Function not found: 'Nodeset'</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="collect-properties-defaults">
        <xsl:param name="globalData" />
        <xsl:param name="defaultOfficeStyle" />

        <!--** DEFAULT STYLES: Adding the default styles of a style:family, by adding each office:styles/style:default-style element **-->
        <xsl:variable name="defaultFamilyStyles-RTF">
            <xsl:for-each select="$globalData/office:styles/style:default-style">
                <xsl:element name="style" namespace="">
                    <xsl:copy-of select="@style:family" />
                    <xsl:call-template name="create-inherited-style-properties">
                        <xsl:with-param name="inheritedStyleProperties" select="$defaultOfficeStyle/style/*" />
                    </xsl:call-template>
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="function-available('common:node-set')">
                <xsl:call-template name="collect-properties">
                    <xsl:with-param name="globalData" select="$globalData" />
                    <xsl:with-param name="defaultOfficeStyle" select="$defaultOfficeStyle" />
                    <xsl:with-param name="defaultFamilyStyles" select="common:node-set($defaultFamilyStyles-RTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xalan:nodeset')">
                <xsl:call-template name="collect-properties">
                    <xsl:with-param name="globalData" select="$globalData" />
                    <xsl:with-param name="defaultOfficeStyle" select="$defaultOfficeStyle" />
                    <xsl:with-param name="defaultFamilyStyles" select="xalan:nodeset($defaultFamilyStyles-RTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="function-available('xt:node-set')">
                <xsl:call-template name="collect-properties">
                    <xsl:with-param name="globalData" select="$globalData" />
                    <xsl:with-param name="defaultOfficeStyle" select="$defaultOfficeStyle" />
                    <xsl:with-param name="defaultFamilyStyles" select="xt:node-set($defaultFamilyStyles-RTF)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">ERROR: Function not found: nodeset</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="collect-properties">
        <xsl:param name="globalData" />
        <xsl:param name="defaultOfficeStyle" />
        <xsl:param name="defaultFamilyStyles" />

       <!--** traversee all style trees - branch after branch - collecting style properties **-->
        <xsl:element name="all-doc-styles" namespace="">

       <!-- Background Information:

           There are two different types of styles in the Office:
               1) The office:styles from the user pre-defined style templates
               2) The automatic:styles, which are created whenever a user uses explicit style formatting.

           The office:styles only have parent styles in the office:styles,
           but automatic:styles may inherit from both office:styles and themself.
        -->

           <!--** traversee all office:styles trees beginning with the top-level styles **-->
            <xsl:for-each select="$globalData/office:styles/style:style[not(@style:parent-style-name)]">
               <!-- Looking for parents from style:family
               <xsl:for-each select="$globalData/office:styles/style:style[@style:family=current()/@style:family][not(@style:parent-style-name)]"> -->
                <xsl:choose>
                    <xsl:when test="$defaultFamilyStyles/style[@style:family=current()/@style:family]">
                        <xsl:call-template name="inherit-style-for-self-and-children">
                            <xsl:with-param name="globalData" select="$globalData" />
                            <xsl:with-param name="inheritedStyleProperties" select="$defaultFamilyStyles/style[@style:family=current()/@style:family]/*" />
                            <xsl:with-param name="searchOnlyInAutomaticStyles" select="false()" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="inherit-style-for-self-and-children">
                            <xsl:with-param name="globalData" select="$globalData" />
                            <xsl:with-param name="inheritedStyleProperties" select="$defaultOfficeStyle/style/*" />
                            <xsl:with-param name="searchOnlyInAutomaticStyles" select="false()" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
               <!--** creates a style element with style:name and style:family attribute and
                       an element representing the absolute style properties style:property  ** -->
            </xsl:for-each>

       <!--** traversee all office:automatic-styles trees beginning with the top-level styles **-->
            <xsl:for-each select="$globalData/office:automatic-styles/style:style[not(@style:parent-style-name)]">
               <!--** creates a style element with style:name and style:family attribute and
                       an element representing the absolute style properties style:property  ** -->
                <xsl:choose>
                    <xsl:when test="$defaultFamilyStyles/style[@style:family=current()/@style:family]">
                        <xsl:call-template name="inherit-style-for-self-and-children">
                            <xsl:with-param name="globalData" select="$globalData" />
                            <xsl:with-param name="inheritedStyleProperties" select="$defaultFamilyStyles/style[@style:family=current()/@style:family]/*" />
                            <xsl:with-param name="searchOnlyInAutomaticStyles" select="true()" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="inherit-style-for-self-and-children">
                            <xsl:with-param name="globalData" select="$globalData" />
                            <xsl:with-param name="inheritedStyleProperties" select="$defaultOfficeStyle/style/*" />
                            <xsl:with-param name="searchOnlyInAutomaticStyles" select="true()" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:for-each>

        </xsl:element>
       <!-- debug output in case only styles should be given out (regression test)  -->
        <xsl:if test="$onlyStyleOutputEnabled">
            <xsl:element name="defaultOfficeStyle" namespace="">
                <xsl:copy-of select="$defaultOfficeStyle" />
            </xsl:element>
            <xsl:element name="defaultFamilyStyles" namespace="">
                <xsl:copy-of select="$defaultFamilyStyles" />
            </xsl:element>
        </xsl:if>

    </xsl:template>


    <xsl:template name="inherit-style-for-self-and-children">
        <xsl:param name="globalData" />
        <xsl:param name="inheritedStyleProperties" />
        <xsl:param name="searchOnlyInAutomaticStyles" />

           <!--** create an absolute style by inheriting properties from the given parent properties **-->
        <xsl:variable name="newStyleProperties-RTF">
            <xsl:call-template name="create-inherited-style-properties">
                <xsl:with-param name="inheritedStyleProperties" select="$inheritedStyleProperties" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="function-available('common:node-set')">
                <xsl:variable name="newStyleProperties" select="common:node-set($newStyleProperties-RTF)" />

                <xsl:element name="style" namespace="">
                    <xsl:copy-of select="@style:family" />
                    <xsl:copy-of select="@style:name" />
                    <xsl:copy-of select="$newStyleProperties" />
                </xsl:element>

                <xsl:choose>
                    <xsl:when test="$searchOnlyInAutomaticStyles">
                        <xsl:call-template name="get-children">
                            <xsl:with-param name="globalData" select="$globalData" />
                            <xsl:with-param name="searchOnlyInAutomaticStyles" select="true()" />
                            <xsl:with-param name="inheritedStyleProperties" select="$newStyleProperties/*" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                           <!--** for all automatic-children of the current office:styles  **-->
                        <xsl:call-template name="get-children">
                            <xsl:with-param name="globalData" select="$globalData" />
                            <xsl:with-param name="searchOnlyInAutomaticStyles" select="false()" />
                            <xsl:with-param name="inheritedStyleProperties" select="$newStyleProperties/*" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="function-available('xalan:nodeset')">
                <xsl:variable name="newStyleProperties" select="xalan:nodeset($newStyleProperties-RTF)" />

                <xsl:element name="style" namespace="">
                    <xsl:copy-of select="@style:family" />
                    <xsl:copy-of select="@style:name" />
                    <xsl:copy-of select="$newStyleProperties" />
                </xsl:element>

                <xsl:choose>
                    <xsl:when test="$searchOnlyInAutomaticStyles">
                        <xsl:call-template name="get-children">
                            <xsl:with-param name="globalData" select="$globalData" />
                            <xsl:with-param name="searchOnlyInAutomaticStyles" select="true()" />
                            <xsl:with-param name="inheritedStyleProperties" select="$newStyleProperties/*" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                           <!--** for all automatic-children of the current office:styles  **-->
                        <xsl:call-template name="get-children">
                            <xsl:with-param name="globalData" select="$globalData" />
                            <xsl:with-param name="searchOnlyInAutomaticStyles" select="false()" />
                            <xsl:with-param name="inheritedStyleProperties" select="$newStyleProperties/*" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="function-available('xt:node-set')">
                <xsl:variable name="newStyleProperties" select="xt:node-set($newStyleProperties-RTF)" />

                <xsl:element name="style" namespace="">
                    <xsl:copy-of select="@style:family" />
                    <xsl:copy-of select="@style:name" />
                    <xsl:copy-of select="$newStyleProperties" />
                </xsl:element>

                <xsl:choose>
                    <xsl:when test="$searchOnlyInAutomaticStyles">
                        <xsl:call-template name="get-children">
                            <xsl:with-param name="globalData" select="$globalData" />
                            <xsl:with-param name="searchOnlyInAutomaticStyles" select="true()" />
                            <xsl:with-param name="inheritedStyleProperties" select="$newStyleProperties/*" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                           <!--** for all automatic-children of the current office:styles  **-->
                        <xsl:call-template name="get-children">
                            <xsl:with-param name="globalData" select="$globalData" />
                            <xsl:with-param name="searchOnlyInAutomaticStyles" select="false()" />
                            <xsl:with-param name="inheritedStyleProperties" select="$newStyleProperties/*" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">ERROR: Function not found: nodeset</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="get-children">
        <xsl:param name="globalData" />
        <xsl:param name="searchOnlyInAutomaticStyles" />
        <xsl:param name="inheritedStyleProperties" select="*" />

<!-- QUESTION: Parent style is only unique by name and family, but what about cross family inheritance? -->
       <!-- For each child style (that is every style which has the given parentStyleName as style:parent-style-name and the same style:family -->
        <xsl:variable name="parentStyleFamily" select="@style:family" />
        <xsl:variable name="parentStyleName" select="@style:name" />
        <xsl:if test="not($searchOnlyInAutomaticStyles)">
            <xsl:for-each select="$globalData/office:styles/style:style[@style:family=$parentStyleFamily and @style:parent-style-name=$parentStyleName]">
                <xsl:call-template name="inherit-style-for-self-and-children">
                    <xsl:with-param name="globalData" select="$globalData" />
                    <xsl:with-param name="inheritedStyleProperties" select="$inheritedStyleProperties" />
                    <xsl:with-param name="searchOnlyInAutomaticStyles" select="$searchOnlyInAutomaticStyles" />
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
        <xsl:for-each select="$globalData/office:automatic-styles/style:style[@style:family=$parentStyleFamily and @style:parent-style-name=$parentStyleName]">
            <xsl:call-template name="inherit-style-for-self-and-children">
                <xsl:with-param name="globalData" select="$globalData" />
                <xsl:with-param name="inheritedStyleProperties" select="$inheritedStyleProperties" />
                <xsl:with-param name="searchOnlyInAutomaticStyles" select="$searchOnlyInAutomaticStyles" />
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="create-inherited-style-properties">
        <xsl:param name="inheritedStyleProperties" />

        <xsl:element name="style:properties">
           <!-- Writing all inherited style properties -->
            <xsl:for-each select="$inheritedStyleProperties/@*">
                <xsl:sort select="name()" />
                <xsl:copy-of select="." />
            </xsl:for-each>

           <!--All current attributes will override already inserted attributes of the same name
               XSLT Spec: "Adding an attribute to an element replaces any existing attribute of that element with the same expanded-name." -->
            <xsl:for-each select="*/@*[name() != 'style:font-size-rel']">
                <xsl:copy-of select="." />
            </xsl:for-each>

            <xsl:if test="*/@style:font-size-rel">
<!--
    The intheritedStyleProperties should include an absolute Font Size, but
    <style:properties
        xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
        xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
        style:font-name="Courier New"
        fo:language="en"
        fo:country="US"
        style:font-name-asian=Courier New"
        style:font-name-complex="Courier New"/>
-->
                <xsl:variable name="fontSizeAbsolute">
                    <xsl:call-template name="convert2pt">
                        <xsl:with-param name="value" select="$inheritedStyleProperties/@fo:font-size" />
                    </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="fontSizeRelative">
                    <xsl:call-template name="convert2pt">
                        <xsl:with-param name="value" select="*/@style:font-size-rel" />
                    </xsl:call-template>
                </xsl:variable>

                <xsl:attribute name="fo:font-size">
                    <xsl:value-of select="$fontSizeAbsolute + $fontSizeRelative"/>
                    <xsl:text>pt</xsl:text>
                </xsl:attribute>
            </xsl:if>

            <!-- providing tabulator indentation -->
            <xsl:copy-of select="$inheritedStyleProperties/style:tab-stops"/>
            <xsl:copy-of select="*/style:tab-stops"/>
        </xsl:element>
    </xsl:template>

   <!-- debugging & testing purpose -->
    <xsl:template name="write-collected-styles">
        <xsl:param name="globalData" />

        <xsl:message>&lt;all-doc-styles&gt;</xsl:message>
        <xsl:for-each select="$globalData/all-doc-styles/style">
            <xsl:message>&lt;style</xsl:message>
            <xsl:message>style:family="<xsl:value-of select="current()/@style:family" />"&gt;</xsl:message>
            <xsl:message>style:name="<xsl:value-of select="current()/@style:name" />" </xsl:message>
            <xsl:message>   &lt;*</xsl:message>
            <xsl:for-each select="*/@*">
                <xsl:message>
                    <xsl:text></xsl:text>
                    <xsl:value-of select="name()" />="<xsl:value-of select="." />"</xsl:message>
            </xsl:for-each>
            <xsl:message>/&gt;</xsl:message>
            <xsl:message>&lt;/style&gt;</xsl:message>
        </xsl:for-each>
        <xsl:message>&lt;/all-doc-styles&gt;</xsl:message>
    </xsl:template>

    <xsl:template name="map-odf-style-properties">
        <xsl:param name="globalData" />

        <xsl:choose>
           <!--+++++ DEBUG STYLE OUTPUT FOR REGRESSION TEST +++++-->
           <!-- create styles file from the style variable (testing switch) -->
            <xsl:when test="$onlyStyleOutputEnabled">

                <xsl:element name="debug-output" namespace="">
                    <xsl:copy-of select="$globalData" />
                    <xsl:call-template name="map-odf-properties">
                        <xsl:with-param name="globalData" select="$globalData" />
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>

           <!-- create XHTML file -->
            <xsl:otherwise>
               <!-- to access the variable like a node-set it is necessary to convert it
                    from a result-tree-fragment (RTF) to a node set using the James Clark extension -->
                <xsl:variable name="globalDataRTF">
                   <!-- raw properties still needed for table width attribute creation -->
                    <xsl:copy-of select="$globalData" />
                    <xsl:call-template name="map-odf-properties">
                        <xsl:with-param name="globalData" select="$globalData" />
                    </xsl:call-template>
                </xsl:variable>

                <xsl:choose>
                    <xsl:when test="function-available('common:node-set')">
                        <xsl:call-template name="start-main">
                            <xsl:with-param name="globalData" select="common:node-set($globalDataRTF)" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="function-available('xalan:nodeset')">
                        <xsl:call-template name="start-main">
                            <xsl:with-param name="globalData" select="xalan:nodeset($globalDataRTF)" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="function-available('xt:node-set')">
                        <xsl:call-template name="start-main">
                            <xsl:with-param name="globalData" select="xt:node-set($globalDataRTF)" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="yes">ERROR: Function not found: nodeset</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- REASON FOR TEMPLATE:
       The OpenOffice style properties gathered in the variable 'globalData' have to be mapped to the CSS style format
    -->
    <xsl:template name="map-odf-properties">
        <xsl:param name="globalData" />
        <xsl:element name="all-styles" namespace="">
            <xsl:for-each select="$globalData/all-doc-styles/style">
                <xsl:sort select="@style:family" />
                <xsl:sort select="@style:name" />

                <xsl:call-template name="writeUsedStyles">
                    <xsl:with-param name="globalData" select="$globalData" />
                    <xsl:with-param name="style" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:key name="elementUsingStyle" match="*" use="@text:style-name | @draw:style-name | @draw:text-style-name | @table:style-name | @table:default-cell-style-name"/>
    <xsl:key name="listLabelStyleInStyles" match="/*/office:styles/text:list-style/*  |
                                      /*/office:styles/style:graphic-properties/text:list-style/*" use="@text:style-name"/>

    <xsl:key name="listLabelStyleInContent" match="/*/office:automatic-styles/text:list-style/* | /*/office:automatic-styles/style:graphic-properties/text:list-style/*" use="@text:style-name"/>


    <xsl:variable name="documentRoot" select="/" />
    <xsl:template name="writeUsedStyles">
        <xsl:param name="globalData" />
        <xsl:param name="style"/>

        <!-- for-each changes the key environment from the previously globalData back to the document root  -->
        <xsl:for-each select="$documentRoot">
                <!-- only styles, which are used in the content are written as CSS styles -->
            <xsl:choose>
                <xsl:when test="key('elementUsingStyle', $style/@style:name)/@* or key('listLabelStyleInContent', $style/@style:name)/@*">
                    <xsl:call-template name="writeUsedStyles2">
                        <xsl:with-param name="globalData" select="$globalData" />
                        <xsl:with-param name="style" select="$style" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="not(office:document-content)">
                            <xsl:if test="key('listLabelStyleInStyles', $style/@style:name)/@* or /*/office:styles/text:notes-configuration[@text:citation-style-name = $style/@style:name or /*/office:styles/@text:citation-body-style-name=$style/@style:name]">
                                <!-- if there are consecutive paragraphs with borders (OR background AND margin ), only the first and the last have the top/bottom border
                                unless style:join-border="false" -->
                                <xsl:call-template name="writeUsedStyles2">
                                    <xsl:with-param name="globalData" select="$globalData" />
                                    <xsl:with-param name="style" select="$style" />
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="document($stylesFileURL)">
                                <xsl:if test="key('listLabelStyleInStyles', $style/@style:name)/@* or /*/office:styles/text:notes-configuration[@text:citation-style-name = $style/@style:name or /*/office:styles/@text:citation-body-style-name=$style/@style:name]">
                                    <!-- if there are consecutive paragraphs with borders (OR background AND margin ), only the first and the last have the top/bottom border
                                    unless style:join-border="false" -->
                                    <xsl:call-template name="writeUsedStyles2">
                                        <xsl:with-param name="globalData" select="$globalData" />
                                        <xsl:with-param name="style" select="$style" />
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="writeUsedStyles2">
        <xsl:param name="globalData" />
        <xsl:param name="style"/>
        <xsl:choose>
            <xsl:when test="
                $style/@style:family='paragraph'
                and
            (
                (
                    (
                        $style/*/@fo:border-top
                        or $style/*/@fo:border-bottom
                        or ($style/*/@fo:border
                        and
                        not($style/*/@fo:border='none')
                        )
                    )
                    and
                    (
                        not($style/*/@style:join-border)
                        or  $style/*/@style:join-border = 'true'
                    )
                )
                or
                (
                    (
                        $style/*/@fo:margin-top
                        or $style/*/@fo:margin-bottom
                        or $style/*/@fo:margin
                    )
                    and
                    (     $style/*/@fo:background-color
                    and
                        not($style/*/@fo:background-color='transparent')
                    )
                )
            )">
                <xsl:element name="style" namespace="">
                    <xsl:copy-of select="$style/@style:family" />
                    <xsl:attribute name="style:name"><xsl:value-of select="concat($style/@style:name, '_borderStart')" /></xsl:attribute>
                    <xsl:element name="final-properties" namespace="">
                        <xsl:apply-templates select="$style/*/@*[not(name() = 'fo:border-bottom')][not(name() = 'fo:padding-bottom')][not(name() = 'fo:margin-bottom')][not(name() = 'fo:margin')]">
                            <xsl:with-param name="globalData" select="$globalData" />
                        </xsl:apply-templates>
                        <xsl:apply-templates mode="paragraphMerge" select="$style/*/@*[name() = 'fo:margin-bottom' or name() = 'fo:margin']">
                            <xsl:with-param name="globalData" select="$globalData" />
                        </xsl:apply-templates>
                        <xsl:text> border-bottom-style:none; </xsl:text>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="style" namespace="">
                    <xsl:copy-of select="$style/@style:family" />
                    <xsl:copy-of select="$style/@style:name" />
                    <xsl:attribute name="mergedBorders"><xsl:value-of select="true()" /></xsl:attribute>
                    <xsl:element name="final-properties" namespace="">
                        <xsl:apply-templates select="$style/*/@*[not(name() = 'fo:border-top') and not(name() = 'fo:border-bottom')][not(name() = 'fo:padding-top') and not(name() = 'fo:padding-bottom')][not(name() = 'fo:margin-top') and not(name() = 'fo:margin-bottom')][not(name() = 'fo:margin')]">
                            <xsl:with-param name="globalData" select="$globalData" />
                        </xsl:apply-templates>
                        <xsl:apply-templates mode="paragraphMerge" select="$style/*/@*[name() = 'fo:margin-top' or name() = 'fo:margin-bottom' or name() = 'fo:margin']">
                            <xsl:with-param name="globalData" select="$globalData" />
                        </xsl:apply-templates>
                        <xsl:text> border-top-style:none; border-bottom-style:none; </xsl:text>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="style" namespace="">
                    <xsl:copy-of select="$style/@style:family" />
                    <xsl:attribute name="style:name"><xsl:value-of select="concat($style/@style:name, '_borderEnd')" /></xsl:attribute>
                    <xsl:element name="final-properties" namespace="">
                        <xsl:apply-templates select="$style/*/@*[not(name() = 'fo:border-top')][not(name() = 'fo:padding-top')][not(name() = 'fo:margin-top')][not(name() = 'fo:margin')]">
                            <xsl:with-param name="globalData" select="$globalData" />
                        </xsl:apply-templates>
                        <xsl:apply-templates mode="paragraphMerge" select="$style/*/@*[name() = 'fo:margin-top' or name() = 'fo:margin']">
                            <xsl:with-param name="globalData" select="$globalData" />
                        </xsl:apply-templates>
                        <xsl:text> border-top-style:none;</xsl:text>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="not(key('listLabelStyleInStyles', $style/@style:name)/@*)">
                        <xsl:element name="style" namespace="">
                            <xsl:copy-of select="$style/@style:family" />
                            <xsl:copy-of select="$style/@style:name" />
                            <xsl:element name="final-properties" namespace="">
                                <xsl:apply-templates select="$style/*/@*">
                                    <xsl:with-param name="globalData" select="$globalData" />
                                </xsl:apply-templates>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="style" namespace="">
                            <xsl:attribute name="style:family">none</xsl:attribute>
                            <xsl:attribute name="style:name"><xsl:value-of select="$style/@style:name"/></xsl:attribute>
                            <xsl:element name="final-properties" namespace="">
                                <xsl:apply-templates select="$style/*/@*">
                                    <xsl:with-param name="globalData" select="$globalData" />
                                </xsl:apply-templates>
                            </xsl:element>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- workaround AOOO#119401 suspicious property fo:margin="100%" in paragraph style -->
    <xsl:template match="@fo:margin[string(.) = '100%']" mode="paragraphMerge"/>

    <xsl:template mode="paragraphMerge" match="@fo:margin | @fo:margin-top | @fo:margin-bottom | @fo:margin-left | @fo:margin-right">
        <xsl:text>padding</xsl:text>
        <xsl:value-of select="substring-after(name(), 'fo:margin')"/>
        <xsl:text>:</xsl:text>
        <!-- Map once erroneously used inch shortage 'inch' to CSS shortage 'in' -->
        <xsl:choose>
            <xsl:when test="contains(., 'inch')">
                <xsl:value-of select="substring-before(.,'ch')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>; </xsl:text>
    </xsl:template>
</xsl:stylesheet>
