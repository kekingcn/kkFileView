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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:ole="http://libreoffice.org/2011/xslt/ole" exclude-result-prefixes="w wx aml o dt v">
    <xsl:include href="wordml2ooo_custom_draw.xsl"/>
    <xsl:include href="wordml2ooo_path.xsl"/>

    <xsl:key name="imagedata" match="w:binData" use="@w:name"/>
    <xsl:key name="shapetype" match="v:shapetype" use="concat('#', @id)"/>
    <xsl:template match="v:fill" mode="get-xsl-number">
        <xsl:number from="/w:wordDocument/w:body" level="any" count="v:fill" format="1"/>
    </xsl:template>
    <xsl:template match="v:textpath" mode="get-xsl-number">
        <xsl:number from="/w:wordDocument/w:body" level="any" count="v:textpath" format="1"/>
    </xsl:template>
    <xsl:template match="v:fill" mode="office-style">
        <xsl:choose>
            <xsl:when test="@type='pattern' or @type='tile' or @type='frame'">
                <xsl:variable name="fill-src" select="key('imagedata',@src)"/>
                <xsl:if test="$fill-src">
                    <draw:fill-image>
                        <xsl:if test="string-length(@o:title) &gt; 0">
                            <xsl:attribute name="draw:name">
                                <xsl:value-of select="@o:title"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="draw:name">
                            <xsl:value-of select="translate(@src,'&#9;&#10;&#13;&#32;:/.','' ) "/>
                        </xsl:attribute>
                        <xsl:element name="office:binary-data">
                            <xsl:value-of select="translate($fill-src/text(),'&#9;&#10;&#13;&#32;','' ) "/>
                        </xsl:element>
                    </draw:fill-image>
                </xsl:if>
            </xsl:when>
            <xsl:when test="contains(@type,'gradient')">
                <draw:gradient>
                    <xsl:attribute name="draw:name">
                        <xsl:value-of select=" 'gradient' "/>
                        <xsl:number from="/w:wordDocument/w:body" level="any" count="v:fill" format="1"/>
                    </xsl:attribute>
                    <xsl:attribute name="draw:style">linear</xsl:attribute>
                    <xsl:if test="string-length(parent::v:*/@fillcolor) &gt; 0">
                        <xsl:attribute name="draw:start-color">
                            <xsl:call-template name="MapConstColor">
                                <xsl:with-param name="color" select="parent::v:*/@fillcolor"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="string-length(@color2) &gt; 0">
                        <xsl:attribute name="draw:end-color">
                            <xsl:call-template name="MapConstColor">
                                <xsl:with-param name="color" select="@color2"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                </draw:gradient>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="w:pict" mode="style4dash_mark">
        <xsl:if test="descendant::v:line or descendant::v:rect or descendant::v:oval or descendant::v:arc or descendant::v:shape">
            <!--Changed-->
            <xsl:variable name="vchild" select="./v:*"/>
            <xsl:variable name="def" select="$vchild/v:stroke"/>
            <xsl:if test="$def">
                <!--<draw:marker draw:name="Stupid33" svg:viewBox="0 0 20 30" svg:d="m10 0-10 30h20z"/> -->
                <xsl:variable name="wdashstyle" select="$vchild/v:stroke/@dashstyle"/>
                <xsl:variable name="stroke-num">
                    <xsl:number from="/w:wordDocument/w:body" level="any" count="v:stroke" format="1"/>
                </xsl:variable>
                <xsl:variable name="ptweight">
                    <xsl:choose>
                        <xsl:when test="$vchild/@strokeweight">
                            <xsl:call-template name="ConvertMeasure">
                                <xsl:with-param name="TargetMeasure" select="'pt'"/>
                                <xsl:with-param name="value" select="$vchild/@strokeweight"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="ConvertMeasure">
                                <xsl:with-param name="TargetMeasure" select="'pt'"/>
                                <xsl:with-param name="value" select="'1pt'"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="$wdashstyle and not ($wdashstyle = 'solid')">
                    <xsl:variable name="strdashdot">
                        <xsl:call-template name="getstrdashdot">
                            <xsl:with-param name="dashstyle" select="$wdashstyle"/>
                            <!--<xsl:with-param name="weight" select="$vchild/@strokeweight"/>-->
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="draw-style">
                        <xsl:variable name="end-cap" select="$vchild/v:stroke/@endcap"/>
                        <xsl:choose>
                            <xsl:when test="$end-cap = 'round'">round</xsl:when>
                            <xsl:otherwise>rect</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="dot1-length">
                        <xsl:call-template name="get-middle-substring">
                            <xsl:with-param name="string" select="$strdashdot"/>
                            <xsl:with-param name="prefix" select="'dol:'"/>
                            <xsl:with-param name="suffix" select="';don'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="dot1n">
                        <xsl:call-template name="get-middle-substring">
                            <xsl:with-param name="string" select="$strdashdot"/>
                            <xsl:with-param name="prefix" select="'don:'"/>
                            <xsl:with-param name="suffix" select="';dist'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="dist-length">
                        <xsl:call-template name="get-middle-substring">
                            <xsl:with-param name="string" select="$strdashdot"/>
                            <xsl:with-param name="prefix" select="'dist:'"/>
                            <xsl:with-param name="suffix" select="';dtl'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="dot2-length">
                        <xsl:call-template name="get-middle-substring">
                            <xsl:with-param name="string" select="$strdashdot"/>
                            <xsl:with-param name="prefix" select="'dtl:'"/>
                            <xsl:with-param name="suffix" select="';dtn'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="dot2n">
                        <xsl:call-template name="get-middle-substring">
                            <xsl:with-param name="string" select="$strdashdot"/>
                            <xsl:with-param name="prefix" select="'dtn:'"/>
                            <xsl:with-param name="suffix" select="';eddtn'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:element name="draw:stroke-dash">
                        <!--dol:8;don:1;dist:2;dtl:1;dtn:2;eddtn" />-->
                        <xsl:attribute name="draw:name">
                            <xsl:value-of select="concat('Tdash',$stroke-num)"/>
                        </xsl:attribute>
                        <xsl:attribute name="draw:style">
                            <xsl:value-of select="$draw-style"/>
                        </xsl:attribute>
                        <xsl:if test="(string-length($dot1n) &gt; 0 ) and not ($dot1n ='-1')">
                            <xsl:attribute name="draw:dots1">
                                <xsl:value-of select="$dot1n"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="(string-length($dot2n) &gt; 0 ) and not ($dot2n ='-1')">
                            <xsl:attribute name="draw:dots2">
                                <xsl:value-of select="$dot2n"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="(string-length($dot1-length) &gt; 0 ) and not ($dot1-length ='-1')">
                            <xsl:attribute name="draw:dots1-length">
                                <xsl:call-template name="ConvertMeasure">
                                    <xsl:with-param name="TargetMeasure" select="'in'"/>
                                    <xsl:with-param name="value" select="concat($dot1-length,'pt')"/>
                                </xsl:call-template>in</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="(string-length($dot2-length) &gt; 0 ) and not ($dot2-length ='-1')">
                            <xsl:attribute name="draw:dots2-length">
                                <xsl:call-template name="ConvertMeasure">
                                    <xsl:with-param name="TargetMeasure" select="'in'"/>
                                    <xsl:with-param name="value" select="concat($dot2-length,'pt')"/>
                                </xsl:call-template>in</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="(string-length($dist-length) &gt; 0 ) and not ($dist-length ='-1')">
                            <xsl:variable name="valdistance-length">
                                <xsl:call-template name="ConvertMeasure">
                                    <xsl:with-param name="TargetMeasure" select="'in'"/>
                                    <xsl:with-param name="value" select="concat($dist-length,'pt')"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:attribute name="draw:distance">
                                <xsl:value-of select="$valdistance-length*$ptweight"/>in</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$vchild/v:stroke/@startarrow">
                    <xsl:call-template name="CreateArrowStyle">
                        <xsl:with-param name="arrow-name" select="$vchild/v:stroke/@startarrow"/>
                        <xsl:with-param name="namenumber" select="concat('markerstart',$stroke-num)"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="$vchild/v:stroke/@endarrow">
                    <xsl:call-template name="CreateArrowStyle">
                        <xsl:with-param name="arrow-name" select="$vchild/v:stroke/@endarrow"/>
                        <xsl:with-param name="namenumber" select="concat('markerend',$stroke-num)"/>
                    </xsl:call-template>
                </xsl:if>
                <!--<v:stroke dashstyle="1 1" startarrow="diamond" startarrowwidth="wide" startarrowlength="long" endarrow="block"
                                    endarrowwidth="wide" endarrowlength="long" endcap="round"/>
                    <draw:stroke-dash draw:name="2 2dots 1 dash" draw:style="rect" draw:dots1="2" draw:dots2="1" draw:dots2-length="0.0795in"
                                                    draw:distance="0.102in"/>
                    Hehe, it needs to be revised-->
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template name="CreateArrowStyle">
        <!--<draw:marker draw:name="Stupid33" svg:viewBox="0 0 20 30" svg:d="m10 0-10 30h20z"/> -->
        <xsl:param name="arrow-name"/>
        <xsl:param name="namenumber"/>
        <xsl:param name="arrow-weight"/>
        <xsl:variable name="svg-box">
            <xsl:choose>
                <xsl:when test="$arrow-name = 'block' ">0 0 1131 902</xsl:when>
                <xsl:when test="$arrow-name = 'diamond' ">0 0 10 10</xsl:when>
                <xsl:when test="$arrow-name = 'open' ">0 0 1122 2243</xsl:when>
                <xsl:when test="$arrow-name = 'oval' ">0 0 1131 1131</xsl:when>
                <xsl:when test="$arrow-name = 'diamond' ">0 0 1131 1131</xsl:when>
                <xsl:when test="$arrow-name = 'classic' ">0 0 1131 1580</xsl:when>
                <xsl:otherwise>0 0 1122 2243</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="svg-d">
            <xsl:choose>
                <xsl:when test="$arrow-name = 'block' ">m564 0-564 902h1131z</xsl:when>
                <!--Symmetric Arrow-->
                <xsl:when test="$arrow-name = 'diamond' ">m0 0h10v10h-10z</xsl:when>
                <xsl:when test="$arrow-name = 'open' ">m0 2108v17 17l12 42 30 34 38 21 43 4 29-8 30-21 25-26 13-34 343-1532 339 1520 13 42 29 34 39 21 42 4 42-12 34-30 21-42v-39-12l-4 4-440-1998-9-42-25-39-38-25-43-8-42 8-38 25-26 39-8 42z</xsl:when>
                <xsl:when test="$arrow-name = 'oval' ">m462 1118-102-29-102-51-93-72-72-93-51-102-29-102-13-105 13-102 29-106 51-102 72-89 93-72 102-50 102-34 106-9 101 9 106 34 98 50 93 72 72 89 51 102 29 106 13 102-13 105-29 102-51 102-72 93-93 72-98 51-106 29-101 13z</xsl:when>
                <xsl:when test="$arrow-name = 'diamond' ">m0 564 564 567 567-567-567-564z</xsl:when>
                <xsl:when test="$arrow-name = 'classic' ">m1013 1491 118 89-567-1580-564 1580 114-85 136-68 148-46 161-17 161 13 153 46z</xsl:when>
                <xsl:otherwise>m0 2108v17 17l12 42 30 34 38 21 43 4 29-8 30-21 25-26 13-34 343-1532 339 1520 13 42 29 34 39 21 42 4 42-12 34-30 21-42v-39-12l-4 4-440-1998-9-42-25-39-38-25-43-8-42 8-38 25-26 39-8 42z</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="draw:marker">
            <xsl:attribute name="draw:name">
                <xsl:value-of select="$namenumber"/>
            </xsl:attribute>
            <xsl:attribute name="draw:display-name">
                <xsl:value-of select="$namenumber"/>
            </xsl:attribute>
            <xsl:attribute name="svg:viewBox">
                <xsl:value-of select="$svg-box"/>
            </xsl:attribute>
            <xsl:attribute name="svg:d">
                <xsl:value-of select="$svg-d"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <!-- The template MapDashConst Map the const dashstyle to a number manner
          It calls the template kickblanks to delete the extra blanks in the dash style here is the map
•    Solid (default)  •    ShortDash "2 2"
•    ShortDot "0 2" •    ShortDashDot "2 2 0 2"
•    ShortDashDotDot "2 2 0 2 0 2" •    Dot "1 2"
•    Dash "4 2" •    LongDash "8 2"
•    DashDot "4 2 1 2"•    LongDashDot "8 2 1 2"
•    LongDashDotDot "8 2 1 2 1 2"
-->
    <xsl:template name="MapDashConst">
        <xsl:param name="dashstyle"/>
        <xsl:choose>
            <xsl:when test="$dashstyle='shortDash'"> 2 2 </xsl:when>
            <xsl:when test="$dashstyle='shortDot'"> 0 2 </xsl:when>
            <xsl:when test="$dashstyle='shortDashDot'"> 2 2 0 2 </xsl:when>
            <xsl:when test="$dashstyle='shortDashDotDot'"> 2 2 0 2 0 2 </xsl:when>
            <xsl:when test="$dashstyle='dot'"> 1 2 </xsl:when>
            <xsl:when test="$dashstyle='dash'"> 4 2 </xsl:when>
            <xsl:when test="$dashstyle='longDash'"> 8 2 </xsl:when>
            <xsl:when test="$dashstyle='dashDot'"> 4 2 1 2 </xsl:when>
            <xsl:when test="$dashstyle='longDashDot'"> 8 2 1 2 </xsl:when>
            <xsl:when test="$dashstyle='longDashDotDot'"> 8 2 1 2 1 2 </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="str-style" select="concat(' ',$dashstyle ,' ')"/>
                <xsl:variable name="cleanstyle">
                    <xsl:call-template name="kickblanks">
                        <xsl:with-param name="str" select="translate($str-style,' ','-')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="translate($cleanstyle,'-',' ')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--The template is used to delete the extra blanks from a string.-->
    <xsl:template name="kickblanks">
        <xsl:param name="str"/>
        <xsl:variable name="tmpstr">
            <xsl:choose>
                <xsl:when test="contains($str,'--')">
                    <xsl:variable name="str-before">
                        <xsl:value-of select="substring-before($str,'--')"/>
                    </xsl:variable>
                    <xsl:variable name="str-after">
                        <xsl:value-of select="substring-after($str,'--')"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($str-before,'-',$str-after)"/>
                </xsl:when>
                <xsl:when test="contains($str,'  ')">
                    <xsl:variable name="str-before">
                        <xsl:value-of select="substring-before($str,'  ')"/>
                    </xsl:variable>
                    <xsl:variable name="str-after">
                        <xsl:value-of select="substring-after($str,'  ')"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($str-before,' ',$str-after)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$str"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not ( string-length($str) = string-length($tmpstr) )">
                <xsl:variable name="restr">
                    <xsl:call-template name="kickblanks">
                        <xsl:with-param name="str" select="$tmpstr"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$restr"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$str"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="substrcount">
        <xsl:param name="str"/>
        <xsl:param name="substr"/>
        <xsl:choose>
            <xsl:when test="$substr and string-length($str) and contains($str,$substr) and string-length(substring-before($str,$substr)) = 0">
                <xsl:variable name="restr" select="substring-after($str,$substr)"/>
                <xsl:variable name="num">
                    <xsl:call-template name="substrcount">
                        <xsl:with-param name="str" select="$restr"/>
                        <xsl:with-param name="substr" select="$substr"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$num+1"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="latest-substr-after">
        <xsl:param name="str"/>
        <xsl:param name="substr"/>
        <xsl:choose>
            <xsl:when test="contains($str,$substr) and string-length(substring-before($str,$substr)) = 0">
                <xsl:variable name="restr" select="substring-after($str,$substr)"/>
                <xsl:call-template name="latest-substr-after">
                    <xsl:with-param name="str" select="$restr"/>
                    <xsl:with-param name="substr" select="$substr"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$str"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--Template get_revised_adj is used to get real adj when adj show two time in the file. -->
    <xsl:template name="get_remained_adj">
        <xsl:param name="adj_typeid"/>
        <xsl:param name="num"/>
        <xsl:param name="mark"/>
        <xsl:choose>
            <xsl:when test="$num &gt; 0 ">
                <xsl:variable name="new_remained_adj">
                    <xsl:choose>
                        <xsl:when test="string-length($adj_typeid) &gt; 0">
                            <xsl:call-template name="get_remained_adj">
                                <xsl:with-param name="adj_typeid" select="substring-after($adj_typeid,$mark)"/>
                                <xsl:with-param name="num" select="$num -1"/>
                                <xsl:with-param name="mark" select="$mark"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="$new_remained_adj"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$adj_typeid"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--Template get_non_omit_adj is used to get the non-omit adj.(e.g. Adj="10,,11" means modifiers="10 0 11").-->
    <xsl:template name="get_non_omit_adj">
        <xsl:param name="adj_typeid"/>
        <xsl:param name="num"/>
        <xsl:param name="mark"/>
        <xsl:choose>
            <xsl:when test="$num &gt; 0 ">
                <xsl:variable name="before" select="substring-before($adj_typeid,',')"/>
                <xsl:variable name="after" select="substring-after($adj_typeid,',')"/>
                <xsl:variable name="zero_or_itself">
                    <xsl:choose>
                        <xsl:when test="string-length(translate($before, ' ','' ) ) &gt; 0">
                            <xsl:value-of select="$before"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'0'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="new_non_omit_adj">
                    <xsl:call-template name="get_non_omit_adj">
                        <xsl:with-param name="adj_typeid" select="$after"/>
                        <xsl:with-param name="num" select="$num -1"/>
                        <xsl:with-param name="mark" select="$mark"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($zero_or_itself, ' ',$new_non_omit_adj)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="zero_or_itself">
                    <xsl:choose>
                        <xsl:when test="string-length(translate($adj_typeid, ' ','' ) ) &gt; 0">
                            <xsl:value-of select="$adj_typeid"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'0'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="$zero_or_itself"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="getstrdashdot">
        <!--Remember the robust!if dashstyle is '2'?What  to do!-->
        <xsl:param name="dashstyle"/>
        <xsl:variable name="dstyle">
            <xsl:variable name="tmpstyle">
                <xsl:call-template name="MapDashConst">
                    <xsl:with-param name="dashstyle" select="$dashstyle"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="substring-after($tmpstyle,' ')"/>
        </xsl:variable>
        <xsl:variable name="dot1" select="substring-before($dstyle,' ')"/>
        <xsl:variable name="dot1after" select="substring-after($dstyle,' ')"/>
        <xsl:variable name="dot1distance" select="substring-before($dot1after,' ')"/>
        <xsl:variable name="modesubstr1" select="concat($dot1,' ',$dot1distance,' ')"/>
        <xsl:variable name="dot1n">
            <xsl:call-template name="substrcount">
                <xsl:with-param name="str" select="$dstyle"/>
                <xsl:with-param name="substr" select="$modesubstr1"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dot2substr">
            <xsl:call-template name="latest-substr-after">
                <xsl:with-param name="str" select="$dstyle"/>
                <xsl:with-param name="substr" select="$modesubstr1"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dot2">
            <xsl:choose>
                <xsl:when test="string-length($dot2substr) &gt; 3">
                    <xsl:value-of select="substring-before($dot2substr,' ')"/>
                </xsl:when>
                <xsl:otherwise>-1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dot2distance">
            <xsl:choose>
                <xsl:when test="string-length($dot2substr) &gt; 3">
                    <xsl:variable name="tmpstr" select="substring-after($dot2substr,' ')"/>
                    <xsl:value-of select="substring-before($tmpstr,' ')"/>
                </xsl:when>
                <xsl:otherwise>-1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="modesubstr2" select="concat($dot2,' ',$dot2distance,' ') "/>
        <xsl:variable name="dot2n">
            <xsl:choose>
                <xsl:when test="string-length($dot2substr) &gt; 3">
                    <xsl:call-template name="substrcount">
                        <xsl:with-param name="str" select="$dot2substr"/>
                        <xsl:with-param name="substr" select="$modesubstr2"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>-1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="valDistance">
            <!--Over all distance is the larger one!-->
            <xsl:choose>
                <xsl:when test="$dot2distance &gt;  $dot1distance">
                    <xsl:value-of select="$dot2distance"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$dot1distance"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat('dol:',$dot1,';don:',$dot1n,';dist:',$valDistance,';dtl:',$dot2,';dtn:',$dot2n,';eddtn')"/>
        <!--<xsl:choose>
            <xsl:when test="$dashstyle='1 1' or $dashstyle='Dots'">
                <xsl:variable name="do"><xsl:value-of select="'1'"/></xsl:variable>
                <xsl:variable name="dol"><xsl:value-of select="$do * $cmweight"/></xsl:variable>
                <xsl:variable name="ds"><xsl:value-of select="'1'"/></xsl:variable>
                <xsl:variable name="dsl"><xsl:value-of select="$ds * $cmweight"/></xsl:variable>
                <xsl:variable name="dt"><xsl:value-of select="'-1'"/></xsl:variable>
                <xsl:variable name="dtl"><xsl:value-of select="'-1'"/></xsl:variable>
                <xsl:value-of select="concat('dsl:',$dsl,'edsl','do:',$do, 'edo;','do')"/>
            </xsl:when>
        </xsl:choose>-->
    </xsl:template>
    <xsl:template match="w:pict" mode="style">
        <xsl:apply-templates mode="style" select="v:*"/>
    </xsl:template>
    <xsl:template match="v:*" mode="style">
        <xsl:variable name="vchild" select="."/>
        <xsl:variable name="style" select="concat($vchild/@style, ';')"/>
        <xsl:variable name="z-index" select="substring-before(substring-after($style,'z-index:'),';')"/>
        <xsl:variable name="right-name" select="not(name($vchild) = 'v:formulas') and not(name($vchild) = 'v:f') and not(name($vchild) = 'v:shapetype')"/>
        <xsl:variable name="def" select="string-length($style) &gt; 0 or $vchild/@stroke or $vchild/@stroked or $vchild/@strokecolor or $vchild/v:stroke or $vchild/@strokeweight or $vchild/@wrapcoords or $vchild/@fillcolor"/>
        <xsl:choose>
            <xsl:when test="$right-name and ($def or (number($z-index) &lt; 0))">
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name">Tgr<xsl:number from="/w:wordDocument/w:body" level="any" count="v:*" format="1"/>
                    </xsl:attribute>
                    <xsl:attribute name="style:family">graphic</xsl:attribute>
                    <xsl:variable name="stroke-num">
                        <xsl:if test="$vchild/v:stroke">
                            <xsl:number from="/w:wordDocument/w:body" level="any" count="v:stroke" format="1"/>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="draw-stroke">
                        <xsl:variable name="dashstyle" select="$vchild/v:stroke/@dashstyle"/>
                        <xsl:choose>
                            <xsl:when test="$vchild/@stroked and $vchild/@stroked='f'">none</xsl:when>
                            <xsl:when test="$dashstyle and not ($dashstyle = 'solid')">
                                <xsl:value-of select="concat('Tdash',$stroke-num)"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:element name="style:graphic-properties">
                        <xsl:variable name="style-str" select="concat(@style,';')"/>
                        <xsl:choose>
                            <xsl:when test="number($z-index) &lt; 0 or (name($vchild) = 'v:group' and $vchild/@editas ='canvas' )">
                                <xsl:attribute name="style:wrap">run-through</xsl:attribute>
                                <xsl:attribute name="style:run-through">background</xsl:attribute>
                                <xsl:attribute name="style:flow-with-text">false</xsl:attribute>
                                <xsl:attribute name="fo:border">none</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:wrap">run-through</xsl:attribute>
                                <xsl:attribute name="style:run-through">foreground</xsl:attribute>
                                <xsl:attribute name="style:flow-with-text">false</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="contains($style-str,'mso-position-horizontal:')">
                                <xsl:attribute name="style:horizontal-pos">
                                    <xsl:value-of select="substring-before( substring-after( $style-str ,  'mso-position-horizontal:') , ';')"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="v:imagedata or v:textbox">
                                <xsl:attribute name="style:horizontal-pos">from-left</xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:if test="parent::w:pict/o:OLEObject">
                            <xsl:variable name="width" select="substring-before( substring-after($style,'width:') ,';')"/>
                            <xsl:variable name="height" select="substring-before(substring-after($style,'height:'),';')"/>
                            <xsl:attribute name="draw:visible-area-left">0cm</xsl:attribute>
                            <xsl:attribute name="draw:visible-area-top">0cm</xsl:attribute>
                            <xsl:attribute name="draw:visible-area-width">
                                <xsl:call-template name="convert-with-scale-and-measure">
                                    <xsl:with-param name="value" select="$width"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:attribute name="draw:visible-area-height">
                                <xsl:call-template name="convert-with-scale-and-measure">
                                    <xsl:with-param name="value" select="$height"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:attribute name="draw:ole-draw-aspect">
                                <!--   DVASPECT_CONTENT    = 1,
                                        DVASPECT_THUMBNAIL  = 2,
                                        DVASPECT_ICON       = 4,
                                        DVASPECT_DOCPRINT   = 8 -->
                                <xsl:variable name="ms-aspect" select="parent::w:pict/o:OLEObject/@DrawAspect"/>
                                <xsl:choose>
                                    <xsl:when test="$ms-aspect = 'Content'">1</xsl:when>
                                    <xsl:when test="$ms-aspect = 'Thumbnail'">2</xsl:when>
                                    <xsl:when test="$ms-aspect = 'Icon'">4</xsl:when>
                                    <xsl:when test="$ms-aspect = 'Docprint'">8</xsl:when>
                                    <xsl:otherwise>1</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="parent::w:pict/o:OLEObject">
                                <xsl:attribute name="style:vertical-pos">middle</xsl:attribute>
                                <xsl:attribute name="style:vertical-rel">baseline</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="contains($style-str,'mso-position-vertical:')">
                                <xsl:attribute name="style:vertical-pos">
                                    <xsl:value-of select="substring-before( substring-after( $style-str ,  'mso-position-vertical:') , ';')"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="v:imagedata or v:textbox">
                                <xsl:attribute name="style:vertical-pos">from-top</xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:if test="string-length($draw-stroke) &gt; 0">
                            <!--draw:stroke="dash" draw:stroke-dash="Ohon!Ultrafine dashed" -->
                            <xsl:choose>
                                <xsl:when test="not ($draw-stroke = 'none')">
                                    <xsl:attribute name="draw:stroke">
                                        <xsl:value-of select="'dash'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="draw:stroke-dash">
                                        <xsl:value-of select="$draw-stroke"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="draw:stroke">
                                        <xsl:value-of select="'none'"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="$vchild/v:stroke/@startarrow">
                            <!--<v:stroke startarrow="block" startarrowwidth="wide" startarrowlength="long"/-->
                            <xsl:attribute name="draw:marker-start">
                                <xsl:value-of select="concat('markerstart',$stroke-num)"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$vchild/v:stroke/@endarrow">
                            <!--<v:stroke startarrow="block" startarrowwidth="wide" startarrowlength="long"/-->
                            <xsl:attribute name="draw:marker-end">
                                <xsl:value-of select="concat('markerend',$stroke-num)"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$vchild/@strokeweight">
                            <xsl:attribute name="svg:stroke-width">
                                <xsl:call-template name="convert-with-scale-and-measure">
                                    <xsl:with-param name="value" select="$vchild/@strokeweight"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$vchild/@strokecolor">
                            <xsl:attribute name="svg:stroke-color">
                                <xsl:call-template name="MapConstColor">
                                    <xsl:with-param name="color" select="$vchild/@strokecolor"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$vchild/@fillcolor">
                            <xsl:attribute name="draw:fill-color">
                                <xsl:call-template name="MapConstColor">
                                    <xsl:with-param name="color" select="$vchild/@fillcolor"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="not($vchild/@fillcolor)">
                            <xsl:choose>
                                <xsl:when test="ancestor::v:group | v:shadow">
                                    <xsl:attribute name="draw:fill-color">#ffffff</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="not($vchild/v:fill) and not(v:shadow)">
                                    <xsl:attribute name="draw:fill">none</xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="$vchild/v:fill/@opacity">
                            <xsl:attribute name="draw:opacity">
                                <xsl:call-template name="convert2percent">
                                    <xsl:with-param name="value" select="$vchild/v:fill/@opacity"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$vchild/v:fill/@type = 'pattern' or $vchild/v:fill/@type = 'tile' or $vchild/v:fill/@type = 'frame'">
                            <xsl:attribute name="draw:fill">bitmap</xsl:attribute>
                            <xsl:attribute name="draw:fill-image-name">
                                <xsl:value-of select="translate($vchild/v:fill/@src,'&#9;&#10;&#13;&#32;:/.','' ) "/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$vchild/v:fill/@type = 'gradient'">
                            <xsl:attribute name="draw:fill">gradient</xsl:attribute>
                            <xsl:attribute name="draw:fill-gradient-name">
                                <xsl:value-of select=" 'gradient' "/>
                                <xsl:apply-templates mode="get-xsl-number" select="$vchild/v:fill"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates mode="style" select="v:shadow"/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!--Default style which will surely be removed during imported from a .flat file to SO-->
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name">Tgr<xsl:number from="/w:wordDocument/w:body" level="any" count="v:*" format="1"/>
                    </xsl:attribute>
                    <xsl:attribute name="style:family">graphic</xsl:attribute>
                    <style:graphic-properties draw:textarea-horizontal-align="center" draw:textarea-vertical-align="middle" style:wrap="none" draw:fill="none"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="name() = 'v:group'">
            <xsl:apply-templates mode="style" select="v:*"/>
        </xsl:if>
        <xsl:apply-templates mode="style" select="v:textpath"/>
    </xsl:template>
    <xsl:template match="v:shadow" mode="style">
        <!-- v:shadow on="t" color="aqua" opacity=".5" offset="13pt,11pt" offset2="14pt,10pt" -->
        <xsl:attribute name="draw:shadow">
            <xsl:choose>
                <xsl:when test="contains(@on,'f')">hidden</xsl:when>
                <xsl:otherwise>visible</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="draw:shadow-color">
            <xsl:call-template name="MapConstColor">
                <xsl:with-param name="color" select="@color"/>
            </xsl:call-template>
        </xsl:attribute>
        <xsl:if test="string-length(@opacity) &gt;0">
            <xsl:attribute name="draw:shadow-opacity">
                <xsl:call-template name="convert2percent">
                    <xsl:with-param name="value" select="@opacity"/>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="contains(@offset,',')">
                <xsl:attribute name="draw:shadow-offset-x">
                    <xsl:call-template name="ConvertMeasure">
                        <xsl:with-param name="value" select="substring-before(@offset,',')"/>
                        <xsl:with-param name="TargetMeasure" select=" 'cm' "/>
                    </xsl:call-template>
                    <xsl:value-of select="'cm'"/>
                </xsl:attribute>
                <xsl:attribute name="draw:shadow-offset-y">
                    <xsl:call-template name="ConvertMeasure">
                        <xsl:with-param name="value" select="substring-after(@offset,',')"/>
                        <xsl:with-param name="TargetMeasure" select=" 'cm' "/>
                    </xsl:call-template>
                    <xsl:value-of select="'cm'"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="draw:shadow-offset-x">
                    <xsl:call-template name="ConvertMeasure">
                        <xsl:with-param name="value" select="@offset"/>
                        <xsl:with-param name="TargetMeasure" select=" 'cm' "/>
                    </xsl:call-template>
                    <xsl:value-of select="'cm'"/>
                </xsl:attribute>
                <xsl:attribute name="draw:shadow-offset-y">0.062cm</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@type='perspective' and @offset='0,0'">
            <xsl:message>This kind of shadow does not support yet.</xsl:message>
        </xsl:if>
    </xsl:template>
    <xsl:template name="convert2percent">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value,'%')">
                <xsl:value-of select="$value"/>
            </xsl:when>
            <xsl:when test="contains($value,'f')">
                <xsl:variable name="num-value" select="round(substring-before($value,'f') div 6.5536) div 100"/>
                <xsl:value-of select="concat(100 - $num-value ,'%')"/>
            </xsl:when>
            <xsl:when test="string-length($value) = 0">
                <xsl:value-of select="'1%'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($value * 100 ,'%')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="w:pict">
        <xsl:param name="x-scale" select="1"/>
        <xsl:param name="y-scale" select="1"/>
        <xsl:param name="group-left" select="0"/>
        <xsl:param name="group-top" select="0"/>
        <xsl:param name="coord-left" select="0"/>
        <xsl:param name="coord-top" select="0"/>
        <xsl:param name="MeasureMark"/>
        <xsl:apply-templates>
            <xsl:with-param name="x-scale" select="$x-scale"/>
            <xsl:with-param name="y-scale" select="$x-scale"/>
            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
            <xsl:with-param name="group-left" select="$group-left"/>
            <xsl:with-param name="group-top" select="$group-top"/>
            <xsl:with-param name="coord-left" select="$coord-left"/>
            <xsl:with-param name="coord-top" select="$coord-top"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template name="get-middle-substring">
        <xsl:param name="string"/>
        <xsl:param name="prefix"/>
        <xsl:param name="suffix"/>
        <xsl:if test="contains($string, $prefix)">
            <xsl:choose>
                <xsl:when test="contains(substring-after( $string, $prefix), $suffix)">
                    <xsl:value-of select="substring-before(substring-after( $string, $prefix), $suffix)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after( $string, $prefix)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="w:binData">
    </xsl:template>
    <xsl:template match="v:group">
        <xsl:param name="x-scale" select="1"/>
        <xsl:param name="y-scale" select="1"/>
        <xsl:param name="MeasureMark"/>
        <xsl:param name="group-left" select="0"/>
        <xsl:param name="group-top" select="0"/>
        <xsl:param name="coord-left" select="0"/>
        <xsl:param name="coord-top" select="0"/>
        <xsl:variable name="style" select="concat(@style, ';')"/>
        <xsl:variable name="left">
            <xsl:variable name="direct-left" select="substring-before(substring-after($style,';left:'),';')"/>
            <xsl:variable name="margin-left" select="substring-before( substring-after($style,'margin-left:')  ,';')"/>
            <xsl:call-template name="Add-with-Measure">
                <xsl:with-param name="value1" select="$margin-left"/>
                <xsl:with-param name="value2" select="$direct-left"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="top">
            <xsl:variable name="direct-top" select="substring-before(substring-after($style,';top:'),';')"/>
            <xsl:variable name="margin-top" select="substring-before( substring-after($style,'margin-top:')  ,';')"/>
            <xsl:call-template name="Add-with-Measure">
                <xsl:with-param name="value1" select="$margin-top"/>
                <xsl:with-param name="value2" select="$direct-top"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="width" select="substring-before( substring-after($style,'width:') ,';')"/>
        <xsl:variable name="height" select="substring-before(substring-after($style,'height:'),';')"/>
        <xsl:variable name="Current-coord-left">
            <xsl:call-template name="get-number">
                <xsl:with-param name="value" select="substring-before(@coordorigin, ',' )"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="Current-coord-top">
            <xsl:call-template name="get-number">
                <xsl:with-param name="value" select="substring-after(@coordorigin, ',' )"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="Current-coord-width">
            <xsl:call-template name="get-number">
                <xsl:with-param name="value" select="substring-before(@coordsize, ',' )"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="Current-coord-height">
            <xsl:call-template name="get-number">
                <xsl:with-param name="value" select="substring-after(@coordsize, ',' )"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="Current-MeasureMark">
            <xsl:choose>
                <xsl:when test="string-length($MeasureMark) &gt; 0">
                    <xsl:value-of select="$MeasureMark"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select=" 'cm' "/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="left-value">
            <xsl:variable name="adjusted-left">
                <xsl:call-template name="convert-with-scale-and-measure">
                    <xsl:with-param name="value" select="$left"/>
                    <xsl:with-param name="scale" select="$x-scale"/>
                    <xsl:with-param name="MeasureMark" select="$Current-MeasureMark"/>
                    <xsl:with-param name="Target-Measure" select="$Current-MeasureMark"/>
                    <xsl:with-param name="group-value" select="$group-left"/>
                    <xsl:with-param name="coord-value" select="$coord-left"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:call-template name="get-number">
                <xsl:with-param name="value" select="$adjusted-left"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="top-value">
            <xsl:variable name="adjusted-top">
                <xsl:call-template name="convert-with-scale-and-measure">
                    <xsl:with-param name="value" select="$top"/>
                    <xsl:with-param name="scale" select="$x-scale"/>
                    <xsl:with-param name="MeasureMark" select="$Current-MeasureMark"/>
                    <xsl:with-param name="Target-Measure" select="$Current-MeasureMark"/>
                    <xsl:with-param name="group-value" select="$group-left"/>
                    <xsl:with-param name="coord-value" select="$coord-left"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:call-template name="get-number">
                <xsl:with-param name="value" select="$adjusted-top"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="width-value">
            <xsl:variable name="adjusted-width">
                <xsl:call-template name="convert-with-scale-and-measure">
                    <xsl:with-param name="value" select="$width"/>
                    <xsl:with-param name="scale" select="$x-scale"/>
                    <xsl:with-param name="MeasureMark" select="$Current-MeasureMark"/>
                    <xsl:with-param name="Target-Measure" select="$Current-MeasureMark"/>
                    <xsl:with-param name="group-value" select="$group-left"/>
                    <xsl:with-param name="coord-value" select="$coord-left"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:call-template name="get-number">
                <xsl:with-param name="value" select="$adjusted-width"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="height-value">
            <xsl:variable name="adjusted-height">
                <xsl:call-template name="convert-with-scale-and-measure">
                    <xsl:with-param name="value" select="$height"/>
                    <xsl:with-param name="scale" select="$y-scale"/>
                    <xsl:with-param name="MeasureMark" select="$Current-MeasureMark"/>
                    <xsl:with-param name="Target-Measure" select="$Current-MeasureMark"/>
                    <xsl:with-param name="group-value" select="$group-left"/>
                    <xsl:with-param name="coord-value" select="$coord-left"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:call-template name="get-number">
                <xsl:with-param name="value" select="$adjusted-height"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="Current-x-scale" select="( $Current-coord-width div $width-value ) * $x-scale"/>
        <xsl:variable name="Current-y-scale" select="( $Current-coord-height div $height-value ) * $y-scale"/>
        <xsl:choose>
            <xsl:when test="@editas='canvas' ">
                <!-- frame -->
                <xsl:variable name="style-name">Tgr<xsl:number from="/w:wordDocument/w:body" level="any" count="v:*" format="1"/>
                </xsl:variable>
                <xsl:variable name="frame-name">frame<xsl:number from="/w:wordDocument/w:body" level="any" count="v:group" format="1"/>
                </xsl:variable>
                <draw:frame draw:style-name="{$style-name}" draw:name="{$frame-name}" text:anchor-type="as-char" svg:x="{$left-value}{$Current-MeasureMark}" svg:y="{$top-value}{$Current-MeasureMark}" svg:width="{$width-value}{$Current-MeasureMark}" svg:height="{$height-value}{$Current-MeasureMark}" draw:z-index="0">
                    <draw:text-box>
                        <text:p text:style-name="Drawing">
                            <xsl:apply-templates select="w:r/w:pict | v:*">
                                <xsl:with-param name="x-scale" select="$Current-x-scale"/>
                                <xsl:with-param name="y-scale" select="$Current-y-scale"/>
                                <xsl:with-param name="MeasureMark" select="$Current-MeasureMark"/>
                                <xsl:with-param name="group-left" select="$left-value"/>
                                <xsl:with-param name="group-top" select="$top-value"/>
                                <xsl:with-param name="coord-left" select="$Current-coord-left"/>
                                <xsl:with-param name="coord-top" select="$Current-coord-top"/>
                            </xsl:apply-templates>
                        </text:p>
                    </draw:text-box>
                </draw:frame>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="draw:g">
                    <xsl:apply-templates select="w:r/w:pict | v:*">
                        <xsl:with-param name="x-scale" select="$Current-x-scale"/>
                        <xsl:with-param name="y-scale" select="$Current-y-scale"/>
                        <xsl:with-param name="MeasureMark" select="$Current-MeasureMark"/>
                        <xsl:with-param name="group-left" select="$left-value"/>
                        <xsl:with-param name="group-top" select="$top-value"/>
                        <xsl:with-param name="coord-left" select="$Current-coord-left"/>
                        <xsl:with-param name="coord-top" select="$Current-coord-top"/>
                    </xsl:apply-templates>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="v:*">
        <xsl:param name="x-scale" select="1"/>
        <xsl:param name="y-scale" select="1"/>
        <xsl:param name="MeasureMark"/>
        <xsl:param name="group-left" select="0"/>
        <xsl:param name="group-top" select="0"/>
        <xsl:param name="coord-left" select="0"/>
        <xsl:param name="coord-top" select="0"/>
        <xsl:if test="not (name() = 'v:shapetype' )">
            <xsl:call-template name="DrawElements">
                <xsl:with-param name="x-scale" select="$x-scale"/>
                <xsl:with-param name="y-scale" select="$y-scale"/>
                <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                <xsl:with-param name="group-left" select="$group-left"/>
                <xsl:with-param name="group-top" select="$group-top"/>
                <xsl:with-param name="coord-left" select="$coord-left"/>
                <xsl:with-param name="coord-top" select="$coord-top"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="DrawElements">
        <xsl:param name="x-scale" select="1"/>
        <xsl:param name="y-scale" select="1"/>
        <xsl:param name="MeasureMark"/>
        <xsl:param name="group-left" select="0"/>
        <xsl:param name="group-top" select="0"/>
        <xsl:param name="coord-left" select="0"/>
        <xsl:param name="coord-top" select="0"/>
        <xsl:param name="force-draw" select="'false'"/>
        <xsl:param name="shape-type"/>
        <xsl:variable name="wordshapename" select="substring-after(name(),':')"/>
        <xsl:variable name="custom_shapename">
            <xsl:if test="$wordshapename='roundrect' ">round-rectangle</xsl:if>
            <xsl:if test="$wordshapename='shape' and not (v:imagedata) and not (v:textbox) and @type">
                <xsl:call-template name="ms_word_draw_map2ooo_custom_draw">
                    <xsl:with-param name="ms_word_draw_type" select="@type"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="is-image" select="$wordshapename='shape' and v:imagedata"/>
        <xsl:variable name="element-name">
            <xsl:choose>
                <xsl:when test="$wordshapename='line'">draw:line</xsl:when>
                <xsl:when test="$wordshapename='rect'">draw:rect</xsl:when>
                <xsl:when test="$wordshapename='oval'">draw:ellipse</xsl:when>
                <xsl:when test="$wordshapename='arc'">draw:ellipse</xsl:when>
                <xsl:when test="$wordshapename='polyline'">draw:polyline</xsl:when>
                <xsl:when test="$wordshapename='roundrect' ">draw:custom-shape</xsl:when>
                <xsl:when test="$wordshapename='shape' and v:imagedata">draw:frame</xsl:when>
                <xsl:when test="$wordshapename='shape' and not (v:imagedata) and @type">
                    <xsl:choose>
                        <xsl:when test="string-length($custom_shapename) &gt; 0">draw:custom-shape</xsl:when>
                        <xsl:when test=" string-length(@type) &gt; 0 and key('shapetype',@type)">draw:custom-shape</xsl:when>
                        <xsl:otherwise>draw:rect</xsl:otherwise>
                        <!--if nothing match it, we prefer rect-->
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$wordshapename='shape' and v:textbox">draw:frame</xsl:when>
                <!--changed here!-->
                <xsl:otherwise>draw:path</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="wfill" select="@fill"/>
        <xsl:variable name="draw-kind">
            <xsl:if test="$wordshapename='arc' and string-length($wfill) &gt; 0">arc</xsl:if>
            <!--Means this is a Segment of Circle-->
        </xsl:variable>
        <!--Get the position,left,top,width,height,z-index,flip from Style-->
        <xsl:variable name="style" select="concat(@style, ';')"/>
        <xsl:variable name="position" select="substring-before(substring-after($style,'position:'),';')"/>
        <xsl:variable name="direct-left" select="substring-before(substring-after($style,';left:'),';')"/>
        <xsl:variable name="left">
            <xsl:variable name="margin-left" select="substring-before( substring-after($style,'margin-left:')  ,';')"/>
            <xsl:call-template name="Add-with-Measure">
                <xsl:with-param name="value1" select="$margin-left"/>
                <xsl:with-param name="value2" select="$direct-left"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="direct-top" select="substring-before(substring-after($style,';top:'),';')"/>
        <xsl:variable name="top">
            <xsl:variable name="margin-top" select="substring-before( substring-after($style,'margin-top:')  ,';')"/>
            <xsl:call-template name="Add-with-Measure">
                <xsl:with-param name="value1" select="$margin-top"/>
                <xsl:with-param name="value2" select="$direct-top"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="width" select="substring-before( substring-after($style,'width:') ,';')"/>
        <xsl:variable name="height" select="substring-before(substring-after($style,'height:'),';')"/>
        <xsl:variable name="flip" select="substring-before(substring-after($style,'flip:'),';')"/>
        <xsl:variable name="z-index" select="substring-before(substring-after($style,'z-index:'),';')"/>
        <!--these are used for wrap margins get from style-->
        <xsl:variable name="mso-wrap-distance-lefttmp" select="substring-after($style,'mso-wrap-distance-left:')"/>
        <xsl:variable name="mso-wrap-distance-left" select="substring-before($mso-wrap-distance-lefttmp,';')"/>
        <xsl:variable name="mso-wrap-distance-toptmp" select="substring-after($style,'mso-wrap-distance-top:')"/>
        <xsl:variable name="mso-wrap-distance-top" select="substring-before($mso-wrap-distance-toptmp,';')"/>
        <xsl:variable name="mso-wrap-distance-righttmp" select="substring-after($style,'mso-wrap-distance-right:')"/>
        <xsl:variable name="mso-wrap-distance-right" select="substring-before($mso-wrap-distance-righttmp,';')"/>
        <xsl:variable name="mso-wrap-distance-bottomtmp" select="substring-after($style,'mso-wrap-distance-bottom:')"/>
        <xsl:variable name="mso-wrap-distance-bottom" select="substring-before($mso-wrap-distance-bottomtmp,';')"/>
        <xsl:variable name="mso-position-horizontal-relativetmp" select="substring-after($style,'mso-position-horizontal-relative:')"/>
        <xsl:variable name="mso-position-horizontal-relative" select="substring-before($mso-position-horizontal-relativetmp,';')"/>
        <xsl:variable name="mso-position-vertical-relativetmp" select="substring-after($style,'mso-position-vertical-relative:')"/>
        <xsl:variable name="mso-position-vertical-relative" select="substring-before($mso-position-vertical-relativetmp,';')"/>
        <xsl:variable name="anchor-type">
            <xsl:choose>
                <xsl:when test="$mso-position-vertical-relative='page' or $mso-position-horizontal-relative = 'page'">page</xsl:when>
                <xsl:when test="$position='absolute'">paragraph</xsl:when>
                <xsl:otherwise>as-char</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="text-style-name">
            <xsl:choose>
                <xsl:when test="descendant::v:textbox">P1</xsl:when>
                <xsl:when test="v:textpath">textpath<xsl:apply-templates mode="get-xsl-number" select="v:textpath"/>
                </xsl:when>
                <!--Should get the real style late-->
                <xsl:otherwise>P1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$element-name}">
            <xsl:if test="$element-name = 'draw:frame'">
                <xsl:attribute name="draw:name">
                    <xsl:value-of select="'frame'"/>
                    <xsl:number from="/w:wordDocument/w:body" level="any" count="v:*" format="1"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$element-name ='draw:path'">
                <xsl:choose>
                    <xsl:when test="string-length(@path) = 0">
                        <xsl:attribute name="svg:d">M 0,0 L 0,0</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="svg:d">
                            <xsl:call-template name="vmlpath2svgpath">
                                <xsl:with-param name="vml-path" select="@path"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="$element-name ='draw:path' or $wordshapename='polyline'">
                <xsl:attribute name="svg:viewBox">
                    <xsl:value-of select="'0 0'"/>
                    <xsl:value-of select="' '"/>
                    <xsl:if test="string-length(@coordsize) = 0">
                        <xsl:value-of select="'1000 1000'"/>
                    </xsl:if>
                    <xsl:if test="not(string-length(@coordsize) = 0)">
                        <xsl:value-of select="translate(@coordsize,',',' ')"/>
                    </xsl:if>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="contains($style,'rotation:')">
                <xsl:attribute name="draw:transform">
                    <xsl:variable name="rotate">
                        <xsl:call-template name="convert2redian">
                            <xsl:with-param name="x" select="substring-before(substring-after($style,'rotation:') , ';')"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="concat( 'rotate(' , $rotate * -1 ,  ')' )"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="text:anchor-type">
                <xsl:value-of select="$anchor-type"/>
                <!--This need to be checkout and built!-->
            </xsl:attribute>
            <xsl:if test="string-length($z-index) &gt; 0">
                <xsl:if test="number($z-index) &lt; 0">
                    <xsl:attribute name="draw:z-index">
                        <xsl:value-of select="'0'"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="not(number($z-index) &lt; 0)">
                    <xsl:attribute name="draw:z-index">
                        <xsl:value-of select="$z-index"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:attribute name="draw:style-name">Tgr<xsl:number from="/w:wordDocument/w:body" level="any" count="v:*" format="1"/>
            </xsl:attribute>
            <xsl:attribute name="draw:text-style-name">
                <xsl:value-of select="$text-style-name"/>
                <!--This is difficult!!-->
            </xsl:attribute>
            <xsl:if test="$wordshapename='line'">
                <xsl:variable name="fromx" select="substring-before(@from,',')"/>
                <xsl:variable name="fromy" select="substring-after(@from,',')"/>
                <xsl:variable name="tox" select="substring-before(@to,',')"/>
                <xsl:variable name="toy" select="substring-after(@to,',')"/>
                <xsl:variable name="valfromx"> </xsl:variable>
                <xsl:if test="$anchor-type='as-char'">
                    <xsl:attribute name="svg:x1">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$fromx"/>
                            <xsl:with-param name="scale" select="$x-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                            <xsl:with-param name="group-value" select="$group-left"/>
                            <xsl:with-param name="coord-value" select="$coord-left"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="svg:y1">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$fromy"/>
                            <xsl:with-param name="scale" select="$y-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                            <xsl:with-param name="group-value" select="$group-top"/>
                            <xsl:with-param name="coord-value" select="$coord-top"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="svg:x2">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$tox"/>
                            <xsl:with-param name="scale" select="$x-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                            <xsl:with-param name="group-value" select="$group-left"/>
                            <xsl:with-param name="coord-value" select="$coord-left"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="svg:y2">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$toy"/>
                            <xsl:with-param name="scale" select="$y-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                            <xsl:with-param name="group-value" select="$group-top"/>
                            <xsl:with-param name="coord-value" select="$coord-top"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="not ($anchor-type='as-char')">
                    <xsl:attribute name="svg:x1">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$fromx"/>
                            <xsl:with-param name="scale" select="$x-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                            <xsl:with-param name="group-value" select="$group-left"/>
                            <xsl:with-param name="coord-value" select="$coord-left"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="svg:y1">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$toy"/>
                            <xsl:with-param name="scale" select="$y-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                            <xsl:with-param name="group-value" select="$group-top"/>
                            <xsl:with-param name="coord-value" select="$coord-top"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="svg:x2">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$tox"/>
                            <xsl:with-param name="scale" select="$x-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                            <xsl:with-param name="group-value" select="$group-left"/>
                            <xsl:with-param name="coord-value" select="$coord-left"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="svg:y2">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$fromy"/>
                            <xsl:with-param name="scale" select="$y-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                            <xsl:with-param name="group-value" select="$group-top"/>
                            <xsl:with-param name="coord-value" select="$coord-top"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$wordshapename='rect' or $wordshapename='oval'  or $wordshapename='arc' or $wordshapename='shape' or $wordshapename='polyline' or ($wordshapename='shape' and v:textbox) or ($wordshapename='roundrect' and v:textbox) ">
                <xsl:if test="$anchor-type='as-char'">
                    <xsl:attribute name="svg:width">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$width"/>
                            <xsl:with-param name="scale" select="$x-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="svg:height">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$height"/>
                            <xsl:with-param name="scale" select="$y-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="svg:x">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$left"/>
                            <xsl:with-param name="scale" select="$x-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                            <xsl:with-param name="group-value" select="$group-left"/>
                            <xsl:with-param name="coord-value" select="$coord-left"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="svg:y">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$top"/>
                            <xsl:with-param name="scale" select="$y-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                            <xsl:with-param name="group-value" select="$group-top"/>
                            <xsl:with-param name="coord-value" select="$coord-top"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="not ($anchor-type='as-char')">
                    <!--Something has to be down because We have Margin-top options-->
                    <xsl:attribute name="svg:width">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$width"/>
                            <xsl:with-param name="scale" select="$x-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="svg:height">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$height"/>
                            <xsl:with-param name="scale" select="$y-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="svg:x">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$left"/>
                            <xsl:with-param name="scale" select="$x-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                            <xsl:with-param name="group-value" select="$group-left"/>
                            <xsl:with-param name="coord-value" select="$coord-left"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="svg:y">
                        <xsl:call-template name="convert-with-scale-and-measure">
                            <xsl:with-param name="value" select="$top"/>
                            <xsl:with-param name="scale" select="$y-scale"/>
                            <xsl:with-param name="MeasureMark" select="$MeasureMark"/>
                            <xsl:with-param name="group-value" select="$group-top"/>
                            <xsl:with-param name="coord-value" select="$coord-top"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$element-name='draw:ellipse' and string-length($draw-kind) &gt; 0">
                <xsl:attribute name="draw:kind">
                    <xsl:value-of select="$draw-kind"/>
                </xsl:attribute>
            </xsl:if>
            <!--<draw:area-polygon …    svg:x="0" svg:y="0" svg:width="2.0cm" svg:height="2.0cm"   svg:viewBox="0 0 2000 2000"   svg:points="400,1500 1600,1500 1000,400"/>
                    The element shown in the following example defines a triangle that is located in the middle of a 2cm by 2cm image. The bounding box covers an area of 2cm by 1.5cm. One view box unit corresponds to 0.01mm.-->
            <xsl:if test="$wordshapename='polyline'">
                <xsl:variable name="MeasureMark_Here" select="'cm'"/>
                <!--MeasureMarkHere is cm because One view box unit corresponds to 0.01mm-->
                <xsl:variable name="width_cm">
                    <xsl:call-template name="convert-with-scale-and-measure">
                        <xsl:with-param name="value" select="$width"/>
                        <xsl:with-param name="scale" select="$x-scale"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="height_cm">
                    <xsl:call-template name="convert-with-scale-and-measure">
                        <xsl:with-param name="value" select="$height"/>
                        <xsl:with-param name="scale" select="$x-scale"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="widthval">
                    <xsl:if test="contains($width_cm,'cm')">
                        <xsl:value-of select="round(substring-before($width_cm,'cm')*1000)"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="heightval">
                    <xsl:if test="contains($height_cm,'cm')">
                        <xsl:value-of select="round(substring-before($height_cm,'cm')*1000)"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="viewBoxstr" select="concat('0 0 ',$widthval,' ',$heightval)"/>
                <xsl:attribute name="svg:viewBox">
                    <xsl:value-of select="$viewBoxstr"/>
                </xsl:attribute>
                <xsl:variable name="inputx_cm">
                    <xsl:call-template name="convert-with-scale-and-measure">
                        <xsl:with-param name="value" select="$left"/>
                        <xsl:with-param name="scale" select="$x-scale"/>
                        <xsl:with-param name="group-value" select="$group-left"/>
                        <xsl:with-param name="coord-value" select="$coord-left"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="inputy_cm">
                    <xsl:call-template name="convert-with-scale-and-measure">
                        <xsl:with-param name="value" select="$top"/>
                        <xsl:with-param name="scale" select="$y-scale"/>
                        <xsl:with-param name="group-value" select="$group-top"/>
                        <xsl:with-param name="coord-value" select="$coord-top"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="inputx_val">
                    <xsl:choose>
                        <xsl:when test="contains($inputx_cm,'cm')">
                            <xsl:value-of select="substring-before($inputx_cm,'cm')"/>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="inputy_val">
                    <xsl:choose>
                        <xsl:when test="contains($inputy_cm,'cm')">
                            <xsl:value-of select="substring-before($inputy_cm,'cm')"/>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="inputboxwidth" select="$widthval"/>
                <xsl:variable name="oopoints">
                    <xsl:call-template name="wordpoints2oopoints">
                        <xsl:with-param name="input_x" select="$inputx_val"/>
                        <xsl:with-param name="input_y" select="$inputy_val"/>
                        <xsl:with-param name="input_width" select="$width"/>
                        <xsl:with-param name="input_height" select="$height"/>
                        <xsl:with-param name="input_boxwidth" select="$widthval"/>
                        <xsl:with-param name="input_boxheight" select="$heightval"/>
                        <xsl:with-param name="input_points" select="concat(@points,',')"/>
                        <!-- add a space to the end of input_points -->
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="string-length($oopoints) &gt; 0">
                    <xsl:attribute name="draw:points">
                        <xsl:value-of select="$oopoints"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$is-image">
                <xsl:variable name="the-image" select="key('imagedata',v:imagedata/@src)"/>
                <xsl:choose>
                    <xsl:when test="string-length(v:imagedata/@o:title) &gt; 0">
                        <xsl:attribute name="draw:name">
                            <xsl:value-of select="v:imagedata/@o:title"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="string-length(parent::w:pict/o:OLEObject/@ObjectID) &gt; 0">
                        <xsl:attribute name="draw:name">
                            <xsl:value-of select="parent::w:pict/o:OLEObject/@ObjectID"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <xsl:apply-templates select="parent::w:pict/o:OLEObject" mode="output"/>
                <draw:image>
                    <xsl:element name="office:binary-data">
                        <xsl:value-of select="translate($the-image/text(),'&#9;&#10;&#13;&#32;','' ) "/>
                    </xsl:element>
                </draw:image>
            </xsl:if>
            <xsl:if test="$element-name = 'draw:custom-shape'">
                <xsl:apply-templates select="v:textpath" mode="text-p">
                    <xsl:with-param name="type-textpath" select="key('shapetype',@type)/v:textpath[1]"/>
                </xsl:apply-templates>
                <xsl:element name="draw:enhanced-geometry">
                    <xsl:variable name="enhanced_path">
                        <!--enhanced_path call a template to get the enhanced-path-->
                        <xsl:choose>
                            <xsl:when test="string-length($custom_shapename) = 0">
                                <xsl:call-template name="vmlpath2enhancedpath">
                                    <xsl:with-param name="vml-path" select="@path"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:variable>
                    <!--####notice that:there is some drawing elements that don't have the shapetype so that can not have a viewbox
                        It is a ****problem**** now-so be sure to check it out.-->
                    <xsl:if test="$wordshapename='roundrect' ">
                        <xsl:variable name="tmp_MeasueMark">
                            <xsl:value-of select="'cm'"/>
                        </xsl:variable>
                        <xsl:variable name="svg_viewwidth">
                            <xsl:if test="$anchor-type='as-char'">
                                <xsl:call-template name="convert-with-scale-and-measure">
                                    <xsl:with-param name="value" select="$width"/>
                                    <xsl:with-param name="scale" select="$x-scale"/>
                                    <xsl:with-param name="MeasureMark" select="$tmp_MeasueMark"/>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="not ($anchor-type='as-char')">
                                <!--Something has to be down because We have Margin-top options-->
                                <xsl:call-template name="convert-with-scale-and-measure">
                                    <xsl:with-param name="value" select="$width"/>
                                    <xsl:with-param name="scale" select="$x-scale"/>
                                    <xsl:with-param name="MeasureMark" select="$tmp_MeasueMark"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:variable name="svg_viewheight">
                            <xsl:if test="$anchor-type='as-char'">
                                <xsl:call-template name="convert-with-scale-and-measure">
                                    <xsl:with-param name="value" select="$height"/>
                                    <xsl:with-param name="scale" select="$y-scale"/>
                                    <xsl:with-param name="MeasureMark" select="$tmp_MeasueMark"/>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="not ($anchor-type='as-char')">
                                <!--Something has to be down because We have Margin-top options-->
                                <xsl:call-template name="convert-with-scale-and-measure">
                                    <xsl:with-param name="value" select="$height"/>
                                    <xsl:with-param name="scale" select="$y-scale"/>
                                    <xsl:with-param name="MeasureMark" select="$tmp_MeasueMark"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:variable name="svg_viewBox">
                            <xsl:value-of select="concat( '0 0 ',substring-before($svg_viewwidth,$tmp_MeasueMark)*10000,' ',substring-before($svg_viewheight,$tmp_MeasueMark)*10000)"/>
                        </xsl:variable>
                        <xsl:attribute name="svg:viewBox">
                            <xsl:value-of select="$svg_viewBox"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="string-length($custom_shapename) &gt; 0">
                        <xsl:attribute name="draw:type">
                            <xsl:value-of select="$custom_shapename"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="string-length($enhanced_path) &gt; 0">
                        <xsl:attribute name="draw:enhanced-path">
                            <xsl:value-of select="$enhanced_path"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:variable name="typeid_adj">
                        <!--for fix the bug of version 1.63: the following description: adj="-11796480,,5400" in OOo should be: modifier =" -11796480 0 5400"-->
                        <xsl:variable name="tmp_adj">
                            <xsl:value-of select="key('shapetype',@type)/@adj"/>
                        </xsl:variable>
                        <xsl:if test="contains($tmp_adj, ',') ">
                            <xsl:variable name="number">
                                <xsl:value-of select="string-length(translate($tmp_adj,'+-0123456789 ','' ) )"/>
                            </xsl:variable>
                            <xsl:call-template name="get_non_omit_adj">
                                <xsl:with-param name="adj_typeid" select="$tmp_adj"/>
                                <xsl:with-param name="num" select="$number"/>
                                <xsl:with-param name="mark" select="',' "/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="not (contains($tmp_adj, ',') )">
                            <xsl:value-of select="$tmp_adj"/>
                        </xsl:if>
                    </xsl:variable>
                    <!--the following choose statement code will process the revised modifier
                        It happens that if a drawing elements has more than 2 modifier, the modifier (or say adj
                        in wordml) can be adjusted and only the modified adj is recorded.
                        what makes it more complicated is that adj support both comma and blanks.
                        so you have to use kickblanks template to kick the blanks and change it to comma version.
                        <key('shapetype',@type)/v:textpath[1]-->
                    <xsl:choose>
                        <xsl:when test="string-length($typeid_adj) = 0">
                            <xsl:if test="contains(@adj,',')">
                                <!--Please Note that the modifier can be more than 2 , so use a translate can be more efficient.
                                -####Note that comma can't be recognized by OOo's modifiers
                                <xsl:variable name="adjust-x" select="substring-before(@adj,',')"/>
                                <xsl:variable name="adjust-y" select="substring-after(@adj,',')"/>
                                <xsl:variable name="adjuststr">
                                    <xsl:if test="$adjust-x and $adjust-y">
                                        -####Note that comma can't be recognized by OOo's modifiers->
                                        <xsl:value-of select="concat( $adjust-x , '  ' ,$adjust-y )"/>
                                    </xsl:if>
                                </xsl:variable>-->
                                <xsl:attribute name="draw:modifiers">
                                    <xsl:value-of select="translate(@adj ,',' ,'  ')"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@adj and not(contains(@adj,','))">
                                <!--####Note that comma can't be recognized by OOo's modifiers.-->
                                <xsl:attribute name="draw:modifiers">
                                    <xsl:value-of select="@adj"/>
                                </xsl:attribute>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <!--Means that you have to care about 2 adj parameters which is different-->
                            <xsl:variable name="mark_used_by_typeid">
                                <xsl:if test="contains($typeid_adj, ',' )">
                                    <xsl:value-of select="',' "/>
                                </xsl:if>
                                <xsl:if test="not (contains( $typeid_adj, ',' ) ) ">
                                    <xsl:value-of select="' ' "/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="@adj">
                                    <xsl:variable name="remained_adj">
                                        <xsl:if test="contains(@adj,',' ) ">
                                            <xsl:variable name="number">
                                                <xsl:value-of select="string-length(translate(@adj,'+-0123456789 ','' ) )"/>
                                            </xsl:variable>
                                            <xsl:call-template name="get_remained_adj">
                                                <xsl:with-param name="adj_typeid" select="$typeid_adj"/>
                                                <xsl:with-param name="num" select="$number+1"/>
                                                <xsl:with-param name="mark" select="$mark_used_by_typeid"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:if test="not (contains(@adj,',' ) ) ">
                                            <xsl:variable name="tmp_str_adj">
                                                <xsl:call-template name="kickblanks">
                                                    <xsl:with-param name="str" select="concat(' ' ,@adj,' ')"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:variable name="number">
                                                <xsl:value-of select="string-length(translate($tmp_str_adj,'+-0123456789','' ) )"/>
                                            </xsl:variable>
                                            <xsl:call-template name="get_remained_adj">
                                                <xsl:with-param name="adj_typeid" select="$typeid_adj"/>
                                                <xsl:with-param name="num" select="$number - 1"/>
                                                <xsl:with-param name="mark" select="$mark_used_by_typeid "/>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </xsl:variable>
                                    <xsl:attribute name="draw:modifiers">
                                        <xsl:value-of select="translate(concat(@adj ,',' ,$remained_adj), ',' ,' ' )"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="contains($typeid_adj,',')">
                                        <xsl:attribute name="draw:modifiers">
                                            <xsl:value-of select="translate($typeid_adj ,',' ,'  ')"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="not(contains($typeid_adj,','))">
                                        <xsl:attribute name="draw:modifiers">
                                            <xsl:value-of select="$typeid_adj"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="@type">
                        <xsl:apply-templates select="v:textpath" mode="output">
                            <xsl:with-param name="type-textpath" select="key('shapetype',@type)/v:textpath[1]"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="key('shapetype',@type)" mode="output">
                            <xsl:with-param name="instance" select="."/>
                        </xsl:apply-templates>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$wordshapename='shape' and v:textbox and $element-name='draw:frame' ">
                    <xsl:element name="draw:text-box">
                        <xsl:apply-templates select="v:textbox/w:txbxContent/w:p"/>
                    </xsl:element>
                </xsl:when>
                <!--It is a case statement for all shapes,so we add v:roundrect here.-->
                <xsl:when test="$wordshapename='roundrect' and v:textbox and $element-name='draw:frame' ">
                    <xsl:element name="draw:text-box">
                        <xsl:apply-templates select="v:textbox/w:txbxContent/w:p"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="v:textbox">
                    <xsl:apply-templates select="v:textbox/w:txbxContent/w:p"/>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="w:docOleData" mode="init">
        <xsl:apply-templates select="w:binData[@w:name='oledata.mso']" mode="oledata.mso"/>
    </xsl:template>
    <xsl:template match="w:binData" mode="oledata.mso">
           <xsl:variable name="tmp" select="ole:insertByName('oledata.mso', translate(text(),'&#10;&#13;&#32;','' )  )"/>
    </xsl:template>
    <xsl:template match="o:OLEObject " mode="output">
        <!-- depends on i43230,we can uncomment this code or find another way after i43230 got fixed -->
        <draw:object-ole>
            <xsl:element name="office:binary-data">
                <xsl:value-of select="translate(ole:getByName(@ObjectID),'&#13;','')"/>
            </xsl:element>
        </draw:object-ole>
    </xsl:template>
    <xsl:template name="get-vml-value">
        <xsl:param name="node1" select="''"/>
        <xsl:param name="property-name"/>
        <xsl:variable name="pn" select="concat(';',$property-name, ':')"/>
        <xsl:choose>
            <xsl:when test="string-length(@*[name() = $property-name]) &gt; 0">
                <xsl:value-of select="@*[name() = $property-name]"/>
            </xsl:when>
            <xsl:when test="string-length(@style) &gt; 0 and  contains(concat(';',translate(@style,' ','')),$pn)">
                <xsl:value-of select=" substring-before( concat(substring-after(concat(';',translate($node1/@style,' ','')) , $pn),';') , ';')  "/>
            </xsl:when>
            <xsl:when test="$node1 and string-length($node1/@*[name() = $property-name]) &gt; 0">
                <xsl:value-of select="$node1/@*[name() = $property-name]"/>
            </xsl:when>
            <xsl:when test="$node1 and string-length($node1/@style) &gt; 0 and  contains(concat(';',translate($node1/@style,' ','')),$pn)">
                <xsl:value-of select=" substring-before( concat(substring-after(concat(';',translate($node1/@style,' ','')) , $pn),';') , ';')  "/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="v:textpath" mode="text-p">
        <xsl:param name="type-textpath" select="''"/>
        <xsl:variable name="the-string">
            <xsl:call-template name="get-vml-value">
                <xsl:with-param name="node1" select="$type-textpath"/>
                <xsl:with-param name="property-name" select="'string'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="style-name">
            <xsl:value-of select="'textpath'"/>
            <xsl:number from="/w:wordDocument/w:body" level="any" count="v:textpath" format="1"/>
        </xsl:variable>
        <text:p text:style-name="{$style-name}">
            <xsl:value-of select="$the-string"/>
        </text:p>
    </xsl:template>
    <xsl:template match="v:textpath" mode="style">
        <xsl:if test="contains(@style,'font-family:')">
            <xsl:variable name="style-name">
                <xsl:value-of select="'textpath'"/>
                <xsl:number from="/w:wordDocument/w:body" level="any" count="v:textpath" format="1"/>
            </xsl:variable>
            <xsl:variable name="font-family">
                <!--  we need remove the additional  &quot; from font-family -->
                <xsl:value-of select="translate(substring-before(substring-after(@style,'font-family:'),';'), '&quot;' ,'')"/>
            </xsl:variable>
            <xsl:variable name="font-size">
                <xsl:choose>
                    <xsl:when test="contains(@style,'font-size:')">
                        <xsl:value-of select="substring-before(substring-after(@style,'font-size:'),';')"/>
                    </xsl:when>
                    <xsl:otherwise>36pt</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <style:style style:name="{$style-name}" style:family="paragraph">
                <style:paragraph-properties text:enable-numbering="false" style:writing-mode="lr-tb"/>
                <style:text-properties fo:font-family="{$font-family}" fo:font-size="{$font-size}" style:font-family-generic="roman" style:text-scale="80%"/>
            </style:style>
        </xsl:if>
    </xsl:template>
    <xsl:template match="v:textpath" mode="output">
        <xsl:param name="type-textpath" select="''"/>
        <xsl:variable name="on">
            <xsl:call-template name="get-vml-value">
                <xsl:with-param name="node1" select="$type-textpath"/>
                <xsl:with-param name="property-name" select="'on'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="starts-with($on,'t')">
            <xsl:attribute name="draw:text-path">true</xsl:attribute>
        </xsl:if>
        <xsl:variable name="fitshape">
            <xsl:call-template name="get-vml-value">
                <xsl:with-param name="node1" select="$type-textpath"/>
                <xsl:with-param name="property-name" select="'fitshape'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="fitpath">
            <xsl:call-template name="get-vml-value">
                <xsl:with-param name="node1" select="$type-textpath"/>
                <xsl:with-param name="property-name" select="'fitpath'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:attribute name="draw:type">fontwork-plain-text</xsl:attribute>
        <xsl:attribute name="draw:text-path-mode">
            <xsl:choose>
                <xsl:when test="starts-with($fitpath,'t') ">path</xsl:when>
                <xsl:when test="starts-with($fitshape,'t') ">shape</xsl:when>
                <xsl:otherwise>normal</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="draw:text-path-scale">path</xsl:attribute>
        <!-- xsl:attribute name="draw:text-path-same-letter-heights">false</xsl:attribute -->
        <!-- xsl:attribute name="draw:text-path-scale-x">false</xsl:attribute -->
    </xsl:template>
    <xsl:template match="v:shapetype" mode="output">
        <xsl:param name="instance" select="''"/>
        <!--#Dummy after version 1.63 The following test is for the adj attribute of the file. It is Dummy now.
        <xsl:if test="not($instance/@adj)">
            <xsl:if test="contains(@adj,',')">-->
        <!--Please Note that the modifier can be more than 2 , so use a translate can be more efficient.
                        -####Note that comma can't be recognized by OOo's modifiers
                <xsl:variable name="adjust-x" select="substring-before(@adj,',')"/>
                <xsl:variable name="adjust-y" select="substring-after(@adj,',')"/>
                <xsl:variable name="adjuststr">
                    <xsl:if test="$adjust-x and $adjust-y">
                        < -####Note that comma can't be recognized by OOo's modifiers.->
                        <xsl:value-of select="concat( $adjust-x , '  ' ,$adjust-y )"/>
                    </xsl:if>
                </xsl:variable>-->
        <!--Dummy after version 1.63    <xsl:attribute name="draw:modifiers">
                    <xsl:value-of select="translate(@adj, ',' , '  ' )"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@adj and not(contains(@adj,','))">-->
        <!--####Note that comma can't be recognized by OOo's modifiers.-->
        <!--Dummy after version 1.63    <xsl:attribute name="draw:modifiers">
                    <xsl:value-of select="@adj"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>-->
        <xsl:variable name="viewbox">
            <xsl:value-of select="'0 0'"/>
            <xsl:value-of select="' '"/>
            <xsl:if test="string-length(@coordsize) = 0">
                <xsl:value-of select="'1000 1000'"/>
            </xsl:if>
            <xsl:if test="not(string-length(@coordsize) = 0)">
                <xsl:value-of select="translate(@coordsize,',',' ')"/>
            </xsl:if>
        </xsl:variable>
        <xsl:attribute name="svg:viewBox">
            <xsl:value-of select="$viewbox"/>
        </xsl:attribute>
        <xsl:attribute name="draw:text-areas">
            <xsl:value-of select="$viewbox"/>
        </xsl:attribute>
        <!-- This path need be output is instance does not have a path-->
        <xsl:if test="not($instance/@path)  and string-length(@path) &gt;0">
            <xsl:attribute name="draw:enhanced-path">
                <!--<xsl:call-template name="vmlpath2svgpath">rrrrrrevised-->
                <xsl:call-template name="vmlpath2enhancedpath">
                    <xsl:with-param name="vml-path" select="@path"/>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="v:formulas | v:handles" mode="output"/>
    </xsl:template>
    <xsl:template match="v:formulas" mode="output">
        <xsl:apply-templates select="v:f" mode="output"/>
    </xsl:template>
    <xsl:template match="v:f" mode="output">
        <xsl:element name="draw:equation">
            <xsl:attribute name="draw:formula">
                <xsl:call-template name="v-formula2o-formula">
                    <xsl:with-param name="v-formula" select="@eqn"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="draw:name">
                <xsl:value-of select="'f'"/>
                <xsl:variable name="the-number">
                    <xsl:number format="1" level="single"/>
                </xsl:variable>
                <xsl:value-of select="$the-number - 1"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template name="v-formula2o-formula">
        <xsl:param name="v-formula"/>
        <xsl:variable name="command" select="substring-before(normalize-space($v-formula), ' ')"/>
        <xsl:variable name="tmp" select="normalize-space(substring-after($v-formula, $command ))"/>
        <xsl:variable name="step1">
            <xsl:choose>
                <xsl:when test="$command ='val'">
                    <xsl:value-of select="$tmp"/>
                </xsl:when>
                <!-- (sum a b c) = (a + b - c)-->
                <xsl:when test="$command = 'sum' ">
                    <xsl:call-template name="replace-space">
                        <xsl:with-param name="value" select="$tmp"/>
                        <xsl:with-param name="replace1" select="'+'"/>
                        <xsl:with-param name="replace2" select="'-'"/>
                    </xsl:call-template>
                </xsl:when>
                <!-- (prod a b c) = (a * b / c)-->
                <xsl:when test="$command = 'prod'">
                    <xsl:call-template name="replace-space">
                        <xsl:with-param name="value" select="$tmp"/>
                        <xsl:with-param name="replace1" select="'*'"/>
                        <xsl:with-param name="replace2" select="'/'"/>
                    </xsl:call-template>
                </xsl:when>
                <!-- (mid a b) = ((a + b)  / 2)-->
                <xsl:when test="$command = 'mid'">
                    <xsl:value-of select="concat('(' , translate($tmp,' ', '+') , ') / 2' )"/>
                </xsl:when>
                <!-- (if a b c) = (a>0?  b : c) Conditional testing.  -->
                <xsl:when test="$command = 'if' ">
                    <xsl:value-of select="concat('if(' , translate($tmp,' ', ',') , ')' )"/>
                </xsl:when>
                <!-- (min a b) = (min (a , b) )-->
                <!-- (max a b) = (max (a , b) )-->
                <xsl:when test="$command = 'min' or $command = 'max'">
                    <xsl:value-of select="concat($command, '(' , translate($tmp,' ', ',') , ')' )"/>
                </xsl:when>
                <xsl:when test="$command = 'abs' or $command = 'sqrt'">
                    <xsl:value-of select="concat($command, '(' , $tmp , ')' )"/>
                </xsl:when>
                <!--  sin(a,b) = a*sin(b) -->
                <xsl:when test="$command = 'sin' or $command = 'cos' or $command = 'tan' ">
                    <!-- atan is not this kind 2 $command = 'atan2' "-->
                    <xsl:variable name="value1" select="substring-before($tmp,' ')"/>
                    <xsl:variable name="value2" select="substring-after($tmp,' ')"/>
                    <xsl:value-of select="concat( $value1 , ' * ' ,  $command, '(' , $value2 , ')' )"/>
                </xsl:when>
                <!-- -->
                <xsl:when test="$command = 'atan2' ">
                    <xsl:variable name="value1" select="substring-before($tmp,' ')"/>
                    <xsl:variable name="value2" select="substring-after($tmp,' ')"/>
                    <xsl:value-of select="concat(  $command , '( ' ,  $value2, ',' , $value1 , ')' )"/>
                </xsl:when>
                <!-- -->
                <!--><xsl:when test="$command = 'atan2' ">
                    <xsl:variable name="value1" select="substring-before($tmp,' ')"/>
                    <xsl:variable name="value2" select="substring-after($tmp,' ')"/>
                    <xsl:value-of select="concat(  'atan' , '( ' ,  $value2, '/' , $value1 , ')' )"/>
                </xsl:when><- -->
                <!-- ellipse and sumangle are always used by arc command like this
                        eqn="ellipse @24 @4 height" ; and eqn="sumangle @2 360 0"
                    mod is always used too.-->
                <!--mod  =sqrt( v*v + P1×P1 + P2×P2). ( 3 parameters )-->
                <xsl:when test="$command='mod' ">
                    <xsl:variable name="value1" select="substring-before($tmp,' ')"/>
                    <xsl:variable name="value2" select="substring-before(substring-after($tmp,' '), ' ')"/>
                    <xsl:variable name="value3" select="substring-after(substring-after($tmp,' '), ' ')"/>
                    <xsl:value-of select="concat( 'sqrt( ' , $value3, ' * ',$value3,    ' + '   ,$value2, ' * ' ,$value2,   ' + '   ,$value1, ' * ', $value1, ' )'  )"/>
                </xsl:when>
                <!--ellipse= P2* sqrt(1 - v*v /P1*P1) ( 3 parameters )-->
                <xsl:when test="$command='ellipse' ">
                    <xsl:variable name="value1" select="substring-before($tmp,' ')"/>
                    <xsl:variable name="value2" select="substring-before(substring-after($tmp,' '), ' ')"/>
                    <xsl:variable name="value3" select="substring-after(substring-after($tmp,' '), ' ')"/>
                    <xsl:value-of select="concat( $value3 , ' * sqrt( ' , $value2 , ' * ' ,  $value2, ' - ',$value1 , ' * ',  $value1, ' )' ,'/',$value2 )"/>
                </xsl:when>
                <!--sumangle  =v + P1×2^16 - P2×2^16. ( 3 parameters )-->
                <!--<xsl:when test="$command='sumangle' ">
                    <xsl:variable name="value1" select="substring-before($tmp,' ')"/>
                    <xsl:variable name="value2" select="substring-before(substring-after($tmp,' '), ' ')"/>
                    <xsl:variable name="value3" select="substring-after(substring-after($tmp,' '), ' ')"/>
                    <xsl:value-of select="concat( $value1 , '+' , $value2 , ' * ' ,  '65535',' + ', $value2,' - ' ,$value3 , ' * ',  '65535', ' - ', $value3)"/>
                </xsl:when>-->
                <!--sumangle  =v + P1×2^16 - P2×2^16. ( 3 parameters )-->
                <xsl:when test="$command='sumangle' ">
                    <xsl:variable name="value1" select="substring-before($tmp,' ')"/>
                    <xsl:variable name="value2" select="substring-before(substring-after($tmp,' '), ' ')"/>
                    <xsl:variable name="value3" select="substring-after(substring-after($tmp,' '), ' ')"/>
                    <xsl:value-of select="concat( $value1 , '+' , $value2 , '*pi/180',' - ' ,$value3 , '*pi/180' )"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>Find an unsupported formula:<xsl:value-of select="$v-formula"/>
                    </xsl:message>
                    <!--<xsl:value-of select="'0'"/><-for release use-->
                    <xsl:value-of select="concat('not found this:', $v-formula)"/>
                    <!--for Debug use-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="step2">
            <xsl:value-of select="translate($step1,'#','$')"/>
        </xsl:variable>
        <xsl:call-template name="replace-at">
            <xsl:with-param name="value" select="$step2"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="replace-space">
        <xsl:param name="value"/>
        <xsl:param name="replace1"/>
        <xsl:param name="replace2"/>
        <xsl:value-of select=" concat( substring-before($value,' ') ,  $replace1, translate(substring-after($value,' '), ' ', $replace2 ) ) "/>
    </xsl:template>
    <xsl:template name="replace-at">
        <xsl:param name="value"/>
        <xsl:param name="position" select="1"/>
        <xsl:choose>
            <xsl:when test="string-length($value) &lt; $position">
                <xsl:value-of select="$value"/>
            </xsl:when>
            <xsl:when test="substring($value,$position,1) = '@'">
                <xsl:call-template name="replace-at">
                    <xsl:with-param name="value" select="concat(substring($value,1,$position -1) , '?f' , substring($value,$position+1)) "/>
                    <xsl:with-param name="position" select="$position + 2"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="replace-at">
                    <xsl:with-param name="value" select="$value"/>
                    <xsl:with-param name="position" select="$position + 1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test=" substring($value,$position,1) = '@'">
            </xsl:if>
    </xsl:template>
    <xsl:template match="v:handles" mode="output">
        <xsl:apply-templates select="v:h" mode="output"/>
    </xsl:template>
    <xsl:template match="v:h" mode="output">
        <xsl:element name="draw:handle">
            <xsl:if test="@position">
                <xsl:attribute name="draw:handle-position">
                    <xsl:value-of select="translate(@position,'#,' , '$ ')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@switch">
                <xsl:attribute name="draw:handle-switched">
                    <xsl:value-of select="@switch"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@xrange">
                <xsl:attribute name="draw:handle-range-x-maximum">
                    <xsl:value-of select="substring-after(@xrange,',')"/>
                </xsl:attribute>
                <xsl:attribute name="draw:handle-range-x-minimum">
                    <xsl:value-of select="substring-before(@xrange,',')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@yrange">
                <xsl:attribute name="draw:handle-range-y-maximum">
                    <xsl:value-of select="substring-after(@yrange,',')"/>
                </xsl:attribute>
                <xsl:attribute name="draw:handle-range-y-minimum">
                    <xsl:value-of select="substring-before(@yrange,',')"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <!--this template map word's points to svg:viewbox's point they are quite different because word's use pt but svg's use 0.001cm as a unit-->
    <xsl:template name="wordpoints2oopoints">
        <xsl:param name="input_points"/>
        <xsl:param name="input_x"/>
        <xsl:param name="input_y"/>
        <xsl:param name="input_width"/>
        <xsl:param name="input_height"/>
        <xsl:param name="input_boxwidth"/>
        <xsl:param name="input_boxheight"/>
        <xsl:variable name="ptx" select="substring-before($input_points,',')"/>
        <xsl:variable name="tempstr" select="substring-after($input_points,',')"/>
        <xsl:variable name="pty" select="substring-before($tempstr,',')"/>
        <xsl:variable name="nextinput" select="substring-after ($tempstr,',')"/>
        <xsl:if test="$ptx and $pty">
            <xsl:variable name="val_ptx">
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="value" select="$ptx"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="val_pty">
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="value" select="$pty"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="round( $input_boxwidth  -  ( $val_ptx - $input_x ) * 1000 )"/>
            <xsl:value-of select="','"/>
            <xsl:value-of select="round( ( $val_pty  -  $input_y ) * 1000 )"/>
        </xsl:if>
        <xsl:if test="contains($nextinput,',')">
            <xsl:value-of select="' '"/>
            <!--Leave a blank first as mark of points group-->
            <xsl:call-template name="wordpoints2oopoints">
                <xsl:with-param name="input_points" select="$nextinput"/>
                <xsl:with-param name="input_x" select="$input_x"/>
                <xsl:with-param name="input_y" select="$input_y"/>
                <xsl:with-param name="input_width" select="$input_width"/>
                <xsl:with-param name="input_height" select="$input_height"/>
                <xsl:with-param name="input_boxwidth" select="$input_boxwidth"/>
                <xsl:with-param name="input_boxheight" select="$input_boxheight"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!--template MapConstColor:input is a color in form of const e.g 'red' or number e.g '#ff0010' output is a number color-->
    <xsl:template name="MapConstColor">
        <xsl:param name="color"/>
        <xsl:choose>
            <xsl:when test="$color='black'">#000000</xsl:when>
            <xsl:when test="$color='olive'">#808000</xsl:when>
            <xsl:when test="$color='red'">#ff0000</xsl:when>
            <xsl:when test="$color='teal'">#008080</xsl:when>
            <xsl:when test="$color='green'">#00ff00</xsl:when>
            <xsl:when test="$color='gray'">#808080</xsl:when>
            <xsl:when test="$color='blue'">#0000ff</xsl:when>
            <xsl:when test="$color='navy'">#000080</xsl:when>
            <xsl:when test="$color='white'">#ffffff</xsl:when>
            <xsl:when test="$color='lime'">#00ff00</xsl:when>
            <xsl:when test="$color='yellow'">#ffff00</xsl:when>
            <xsl:when test="$color='fuchsia'">#ff00ff</xsl:when>
            <xsl:when test="$color='purple'">#800080</xsl:when>
            <xsl:when test="$color='aqua'">#00ffff</xsl:when>
            <xsl:when test="$color='maroon'">#800000</xsl:when>
            <xsl:when test="$color='silver'">#c0c0c0</xsl:when>
            <xsl:when test="$color='window'">#ffffff</xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="string-length($color) =7">
                        <xsl:value-of select="$color"/>
                    </xsl:when>
                    <xsl:when test="string-length($color) =4">
                        <!--short form representation of color-->
                        <xsl:variable name="valr">
                            <xsl:value-of select="concat(substring($color,2,1),substring($color,2,1))"/>
                            <!--<xsl:call-template name="shortcolorconv"><xsl:with-param name="value" select="substring($color,2,1)"/></xsl:call-template>-->
                        </xsl:variable>
                        <xsl:variable name="valg" select="concat(substring($color,3,1),substring($color,3,1))"/>
                        <xsl:variable name="valb" select="concat(substring($color,4,1),substring($color,4,1))"/>
                        <xsl:value-of select="concat('#',$valr,$valg,$valb)"/>
                    </xsl:when>
                    <xsl:otherwise>#000000</xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="shortcolorconv">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="$value='1'">11</xsl:when>
            <xsl:when test="$value='2'">22</xsl:when>
            <xsl:when test="$value='3'">33</xsl:when>
            <xsl:when test="$value='4'">44</xsl:when>
            <xsl:when test="$value='5'">55</xsl:when>
            <xsl:when test="$value='6'">66</xsl:when>
            <xsl:when test="$value='7'">77</xsl:when>
            <xsl:when test="$value='8'">88</xsl:when>
            <xsl:when test="$value='9'">99</xsl:when>
            <xsl:when test="$value='a'">aa</xsl:when>
            <xsl:when test="$value='b'">bb</xsl:when>
            <xsl:when test="$value='c'">cc</xsl:when>
            <xsl:when test="$value='d'">dd</xsl:when>
            <xsl:when test="$value='e'">ee</xsl:when>
            <xsl:when test="$value='f'">ff</xsl:when>
            <!--I just guess it, maybe it is not right-->
        </xsl:choose>
    </xsl:template>
    <xsl:template name="MapArrowStyle">
        <!--What is a block?normal arrow?-->
        <xsl:param name="arrow-name"/>
        <xsl:choose>
            <xsl:when test="$arrow-name = 'Block' ">Arrow</xsl:when>
            <xsl:when test="$arrow-name = 'Diamond' ">Square</xsl:when>
            <xsl:when test="$arrow-name = 'Open' ">Line Arrow</xsl:when>
            <xsl:when test="$arrow-name = 'Oval' ">Circle</xsl:when>
            <xsl:when test="$arrow-name = 'Diamond' ">Square 45</xsl:when>
            <xsl:when test="$arrow-name = 'Classic' ">Arrow concave</xsl:when>
            <xsl:otherwise>Arrow</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Add-with-Measure">
        <xsl:param name="value1"/>
        <xsl:param name="value2"/>
        <xsl:variable name="Current-MeasureMark">
            <xsl:choose>
                <xsl:when test="string-length(translate($value1 ,'-.0123456789 ','' )) &gt; 0">
                    <xsl:value-of select="translate($value1 ,'-.0123456789 ','' )"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate($value2 ,'-.0123456789 ','' )"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="number-value1">
            <xsl:call-template name="get-number">
                <xsl:with-param name="value" select="$value1"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="number-value2">
            <xsl:call-template name="get-number">
                <xsl:with-param name="value" select="$value2"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat( $number-value1 + $number-value2 , $Current-MeasureMark)"/>
    </xsl:template>
    <xsl:template name="convert-with-scale-and-measure">
        <xsl:param name="value"/>
        <xsl:param name="group-value" select="0"/>
        <xsl:param name="coord-value" select="0"/>
        <xsl:param name="scale" select="1"/>
        <xsl:param name="MeasureMark" select="''"/>
        <xsl:param name="Target-Measure" select="''"/>
        <xsl:variable name="Current-MeasureMark">
            <xsl:choose>
                <xsl:when test="not (translate($value ,'-. 0123456789 ','' ) = '') ">
                    <xsl:value-of select="translate($value ,'-. 0123456789 ','' )  "/>
                </xsl:when>
                <xsl:when test="string-length($MeasureMark) &gt; 0">
                    <xsl:value-of select="$MeasureMark"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate($value ,'-. 0123456789 ','' )  "/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="number-value">
            <xsl:call-template name="get-number">
                <xsl:with-param name="value" select="$value"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="value-string" select="( $number-value - $coord-value)  div $scale + $group-value"/>
        <xsl:choose>
            <xsl:when test="$value-string = 0">0cm</xsl:when>
            <xsl:when test="$Target-Measure = $Current-MeasureMark">
                <xsl:value-of select="concat($value-string , $Current-MeasureMark)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ConvertMeasure">
                    <xsl:with-param name="value" select="concat($value-string , $Current-MeasureMark)"/>
                </xsl:call-template>
                <xsl:value-of select=" 'cm' "/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-number">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="translate($value,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ','') = '' ">0</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(translate($value,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',''))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
