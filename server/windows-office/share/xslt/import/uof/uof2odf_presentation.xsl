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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:uof="http://schemas.uof.org/cn/2003/uof" xmlns:表="http://schemas.uof.org/cn/2003/uof-spreadsheet" xmlns:演="http://schemas.uof.org/cn/2003/uof-slideshow" xmlns:字="http://schemas.uof.org/cn/2003/uof-wordproc" xmlns:图="http://schemas.uof.org/cn/2003/graph" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0" xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0" office:version="1.0">
    <xsl:output method="xml" indent="no" encoding="UTF-8" version="1.0"/>
    <xsl:template match="uof:UOF">
        <office:document xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0" xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0" office:version="1.0">
            <xsl:apply-templates select="uof:元数据"/>
            <office:settings>
                <xsl:variable name="PageNumberFormat" select="/uof:UOF/uof:演示文稿/演:公用处理规则/演:页面设置集/演:页面设置/演:页码格式[1]"/>
                <xsl:variable name="proportion">
                    <xsl:value-of select="substring-before(/uof:UOF/uof:演示文稿/演:公用处理规则/演:显示比例,'%')"/>
                </xsl:variable>
                <config:config-item-set config:name="ooo:view-settings">
                    <config:config-item config:name="VisibleAreaTop" config:type="int">0</config:config-item>
                    <config:config-item config:name="VisibleAreaLeft" config:type="int">0</config:config-item>
                    <config:config-item config:name="VisibleAreaWidth" config:type="int">14098</config:config-item>
                    <config:config-item config:name="VisibleAreaHeight" config:type="int">9998</config:config-item>
                    <config:config-item-map-indexed config:name="Views">
                        <config:config-item-map-entry>
                            <config:config-item config:name="ViewId" config:type="string">view1</config:config-item>
                            <config:config-item config:name="GridIsVisible" config:type="boolean">false</config:config-item>
                            <config:config-item config:name="GridIsFront" config:type="boolean">false</config:config-item>
                            <config:config-item config:name="IsSnapToGrid" config:type="boolean">true</config:config-item>
                            <config:config-item config:name="IsSnapToPageMargins" config:type="boolean">true</config:config-item>
                            <config:config-item config:name="IsSnapToSnapLines" config:type="boolean">false</config:config-item>
                            <config:config-item config:name="IsSnapToObjectFrame" config:type="boolean">false</config:config-item>
                            <config:config-item config:name="IsSnapToObjectPoints" config:type="boolean">false</config:config-item>
                            <config:config-item config:name="IsPlusHandlesAlwaysVisible" config:type="boolean">false</config:config-item>
                            <config:config-item config:name="IsFrameDragSingles" config:type="boolean">true</config:config-item>
                            <config:config-item config:name="EliminatePolyPointLimitAngle" config:type="int">1500</config:config-item>
                            <config:config-item config:name="IsEliminatePolyPoints" config:type="boolean">false</config:config-item>
                            <config:config-item config:name="VisibleLayers" config:type="base64Binary">//////////////////////////////////////////8=</config:config-item>
                            <config:config-item config:name="PrintableLayers" config:type="base64Binary">//////////////////////////////////////////8=</config:config-item>
                            <config:config-item config:name="LockedLayers" config:type="base64Binary"/>
                            <config:config-item config:name="NoAttribs" config:type="boolean">false</config:config-item>
                            <config:config-item config:name="NoColors" config:type="boolean">true</config:config-item>
                            <config:config-item config:name="RulerIsVisible" config:type="boolean">false</config:config-item>
                            <config:config-item config:name="PageKind" config:type="short">0</config:config-item>
                            <config:config-item config:name="SelectedPage" config:type="short">0</config:config-item>
                            <config:config-item config:name="IsLayerMode" config:type="boolean">false</config:config-item>
                            <config:config-item config:name="IsDoubleClickTextEdit" config:type="boolean">true</config:config-item>
                            <config:config-item config:name="IsClickChangeRotation" config:type="boolean">false</config:config-item>
                            <config:config-item config:name="SlidesPerRow" config:type="short">4</config:config-item>
                            <config:config-item config:name="EditModeStandard" config:type="int">0</config:config-item>
                            <config:config-item config:name="EditModeNotes" config:type="int">0</config:config-item>
                            <config:config-item config:name="EditModeHandout" config:type="int">1</config:config-item>
                            <config:config-item config:name="VisibleAreaTop" config:type="int">-5402</config:config-item>
                            <config:config-item config:name="VisibleAreaLeft" config:type="int">-441</config:config-item>
                            <config:config-item config:name="VisibleAreaWidth" config:type="int">
                                <xsl:value-of select="(100*13997) div $proportion"/>
                            </config:config-item>
                            <config:config-item config:name="VisibleAreaHeight" config:type="int">
                                <xsl:value-of select="(100*15426) div $proportion"/>
                            </config:config-item>
                            <config:config-item config:name="GridCoarseWidth" config:type="int">1000</config:config-item>
                            <config:config-item config:name="GridCoarseHeight" config:type="int">1000</config:config-item>
                            <config:config-item config:name="GridFineWidth" config:type="int">500</config:config-item>
                            <config:config-item config:name="GridFineHeight" config:type="int">500</config:config-item>
                            <config:config-item config:name="GridSnapWidth" config:type="int">1000</config:config-item>
                            <config:config-item config:name="GridSnapHeight" config:type="int">1000</config:config-item>
                            <config:config-item config:name="GridSnapWidthXNumerator" config:type="int">500</config:config-item>
                            <config:config-item config:name="GridSnapWidthXDenominator" config:type="int">1</config:config-item>
                            <config:config-item config:name="GridSnapWidthYNumerator" config:type="int">500</config:config-item>
                            <config:config-item config:name="GridSnapWidthYDenominator" config:type="int">1</config:config-item>
                            <config:config-item config:name="IsAngleSnapEnabled" config:type="boolean">false</config:config-item>
                            <config:config-item config:name="SnapAngle" config:type="int">1500</config:config-item>
                            <config:config-item config:name="ZoomOnPage" config:type="boolean">true</config:config-item>
                        </config:config-item-map-entry>
                    </config:config-item-map-indexed>
                </config:config-item-set>
                <config:config-item-set config:name="ooo:configuration-settings">
                    <config:config-item config:name="PageNumberFormat" config:type="int">
                        <xsl:choose>
                            <xsl:when test="/uof:UOF/uof:演示文稿/演:公用处理规则/演:页面设置集/演:页面设置/演:页码格式">
                                <xsl:choose>
                                    <xsl:when test="$PageNumberFormat='upper-letter'">0</xsl:when>
                                    <xsl:when test="$PageNumberFormat='lower-letter'">1</xsl:when>
                                    <xsl:when test="$PageNumberFormat='upper-roman'">2</xsl:when>
                                    <xsl:when test="$PageNumberFormat='lower-letter'">3</xsl:when>
                                    <xsl:when test="$PageNumberFormat='decimal'">4</xsl:when>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>5</xsl:otherwise>
                        </xsl:choose>
                    </config:config-item>
                </config:config-item-set>
            </office:settings>
            <office:scripts/>
            <xsl:element name="office:font-face-decls">
                <style:font-face style:name="宋体" svg:font-family="宋体" style:font-family-generic="swiss" style:font-pitch="variable"/>
                <xsl:apply-templates select="uof:式样集/uof:字体集"/>
            </xsl:element>
            <office:styles>
                <xsl:apply-templates select="uof:演示文稿/演:公用处理规则/演:页面版式集/演:页面版式"/>
                <xsl:call-template name="编号字体"/>
                <xsl:for-each select="uof:式样集/uof:段落式样">
                    <xsl:variable name="outline" select="@字:标识符"/>
                    <xsl:choose>
                        <xsl:when test="/uof:UOF/uof:式样集/uof:自动编号集/字:自动编号[@字:标识符=$outline]">
                            <xsl:call-template name="段落式样"/>
                        </xsl:when>
                        <xsl:when test="contains($outline,'outline')">
                            <xsl:call-template name="段落式样"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </office:styles>
            <office:automatic-styles>
                <xsl:apply-templates select="uof:演示文稿/演:公用处理规则/演:配色方案集/演:配色方案"/>
                <xsl:apply-templates select="uof:式样集/uof:句式样"/>
                <xsl:for-each select="uof:式样集/uof:段落式样">
                    <xsl:variable name="outline" select="@字:标识符"/>
                    <xsl:if test="not(/uof:UOF/uof:式样集/uof:自动编号集/字:自动编号[@字:标识符=$outline]) and not(contains($outline,'outline'))">
                        <xsl:call-template name="段落式样"/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:apply-templates select="uof:对象集"/>
                <xsl:call-template name="create-page-master">
                    <xsl:with-param name="impressoptions" select="uof:演示文稿/演:公用处理规则/演:页面设置集/演:页面设置"/>
                </xsl:call-template>
                <xsl:for-each select="/uof:UOF/uof:对象集/图:图形/图:文本内容/字:段落/字:段落属性/字:自动编号信息">
                    <xsl:variable name="currlistid" select="@字:编号引用"/>
                    <xsl:variable name="currlist" select="."/>
                    <xsl:variable name="rootlist" select="/uof:UOF/uof:式样集/uof:自动编号集/字:自动编号[@字:标识符 =$currlistid]"/>
                    <xsl:if test="not(ancestor::字:段落/preceding-sibling::字:段落[1]/字:段落属性/字:自动编号信息/@字:编号引用= $currlistid)">
                        <xsl:element name="text:list-style">
                            <xsl:attribute name="style:name">List<xsl:value-of select="count(preceding::字:自动编号信息)"/></xsl:attribute>
                            <xsl:for-each select="$rootlist">
                                <xsl:call-template name="自动编号"/>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
            </office:automatic-styles>
            <office:master-styles>
                <xsl:apply-templates select="uof:演示文稿/演:主体/演:母版集"/>
            </office:master-styles>
            <office:body>
                <office:presentation>
                    <xsl:apply-templates select="uof:演示文稿/演:主体/演:幻灯片集"/>
                    <xsl:apply-templates select="uof:演示文稿/演:公用处理规则/演:放映设置"/>
                </office:presentation>
            </office:body>
        </office:document>
    </xsl:template>
    <xsl:template match="演:放映设置">
        <presentation:settings>
            <xsl:variable name="start-page">
                <xsl:choose>
                    <xsl:when test="contains(演:幻灯片序列,' ')">
                        <xsl:value-of select="substring-before(演:幻灯片序列,' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="演:幻灯片序列"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="first-page">
                <xsl:value-of select="/uof:UOF/uof:演示文稿/演:主体/演:幻灯片集/演:幻灯片[1]/@演:名称"/>
            </xsl:variable>
            <xsl:if test="not($start-page = $first-page)">
                <xsl:attribute name="presentation:start-page"><xsl:value-of select="$start-page"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="演:全屏放映='false'">
                <xsl:attribute name="presentation:full-screen">false</xsl:attribute>
            </xsl:if>
            <xsl:if test="演:循环放映='true'">
                <xsl:attribute name="presentation:endless">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="演:放映间隔">
                <xsl:attribute name="presentation:pause"><xsl:variable name="OOtime"><xsl:value-of select="substring-after(演:放映间隔,'P0Y0M0DT')"/></xsl:variable><xsl:value-of select="concat('PT',$OOtime)"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="演:手动方式='true'">
                <xsl:attribute name="presentation:force-manual">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="演:导航帮助='true'">
                <xsl:attribute name="presentation:start-with-navigator">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="演:放映动画='false'">
                <xsl:attribute name="presentation:animations">disabled</xsl:attribute>
            </xsl:if>
            <xsl:if test="演:前端显示='true'">
                <xsl:attribute name="presentation:stay-on-top">true</xsl:attribute>
            </xsl:if>
        </presentation:settings>
    </xsl:template>
    <xsl:template name="自动编号">
        <xsl:for-each select="字:级别">
            <xsl:choose>
                <xsl:when test="字:项目符号">
                    <xsl:call-template name="xiangmufuhao">
                        <xsl:with-param name="biaoshifu" select="../@字:标识符"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="字:图片符号引用">
                    <xsl:call-template name="imagefuhao">
                        <xsl:with-param name="biaoshifu" select="../@字:标识符"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="jibianhao">
                        <xsl:with-param name="biaoshifu" select="../@字:标识符"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="编号字体">
        <xsl:for-each select="/uof:UOF/uof:式样集/uof:自动编号集/字:自动编号">
            <xsl:if test="字:级别/字:符号字体">
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name"><xsl:value-of select="concat( @字:标识符,字:级别/@字:级别值)"/></xsl:attribute>
                    <xsl:attribute name="style:family">text</xsl:attribute>
                    <xsl:element name="style:text-properties">
                        <xsl:attribute name="fo:color"><xsl:value-of select="字:级别/字:符号字体/字:字体/@字:颜色"/></xsl:attribute>
                        <xsl:if test="字:级别/字:符号字体/字:粗体 and 字:级别/字:符号字体/字:粗体/@字:值='true'">
                            <xsl:attribute name="fo:font-weight">bold</xsl:attribute>
                            <xsl:attribute name="style:font-style-asian">bold</xsl:attribute>
                        </xsl:if>
                        <xsl:variable name="ziti">
                            <xsl:value-of select="字:级别/字:符号字体/字:字体/@字:中文字体引用"/>
                        </xsl:variable>
                        <xsl:for-each select="/uof:UOF/uof:式样集/uof:字体集/uof:字体声明">
                            <xsl:if test="@uof:标识符=$ziti">
                                <xsl:attribute name="style:font-name"><xsl:value-of select="@uof:名称"/></xsl:attribute>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:attribute name="fo:font-style">normal</xsl:attribute>
                        <xsl:attribute name="style:font-weight-asian">normal</xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="uof:对象集">
        <xsl:apply-templates select="图:图形"/>
        <xsl:apply-templates select="图:图形/图:文本内容/字:段落/字:句/字:句属性" mode="style"/>
    </xsl:template>
    <xsl:variable name="uofUnit">
        <xsl:variable name="uu">
            <xsl:value-of select="/uof:UOF/uof:演示文稿/演:公用处理规则/演:度量单位"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$uu='cm'">cm</xsl:when>
            <xsl:when test="$uu='mm'">mm</xsl:when>
            <xsl:when test="$uu='pt'">pt</xsl:when>
            <xsl:when test="$uu='inch'">inch</xsl:when>
            <xsl:otherwise>pt</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="other-to-cm-conversion-factor">
        <xsl:choose>
            <xsl:when test="$uofUnit='cm'">1</xsl:when>
            <xsl:when test="$uofUnit='mm'">0.1</xsl:when>
            <xsl:when test="$uofUnit='pt'">0.03527</xsl:when>
            <xsl:when test="$uofUnit='inch'">2.54</xsl:when>
            <xsl:when test="$uofUnit='pica'">0.4233</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:key match="/uof:UOF/uof:演示文稿/演:主体/演:母版集/演:母版/uof:锚点 | /uof:UOF/uof:演示文稿/演:主体/演:幻灯片集/演:幻灯片/uof:锚点 | /uof:UOF/uof:演示文稿/演:主体/演:幻灯片集/演:幻灯片/演:幻灯片备注/uof:锚点" name="rel_graphic_name" use="@uof:图形引用"/>
    <xsl:template match="图:图形">
        <xsl:variable name="random-name">
            <xsl:value-of select="generate-id()"/>
        </xsl:variable>
        <xsl:variable name="draw-name">
            <xsl:value-of select="substring($random-name,string-length($random-name)-1)"/>
        </xsl:variable>
        <xsl:call-template name="graphic-fill">
            <xsl:with-param name="draw-name" select="$draw-name"/>
            <xsl:with-param name="gradient-name" select="图:预定义图形/图:属性/图:填充/图:渐变"/>
        </xsl:call-template>
        <xsl:variable name="biaozhifu" select="@图:标识符"/>
        <xsl:choose>
            <xsl:when test="图:预定义图形/图:属性/图:填充/图:渐变">
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
                    <xsl:attribute name="style:family"><xsl:choose><xsl:when test="图:预定义图形/图:类别='3' or 图:预定义图形/图:类别='67'">presentation</xsl:when><xsl:otherwise>graphic</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:if test="/uof:UOF/uof:演示文稿/演:主体/演:母版集/演:母版/uof:锚点[@uof:图形引用=$biaozhifu]">
                        <xsl:variable name="duan" select="图:文本内容/字:段落/字:段落属性/@字:式样引用"/>
                        <xsl:attribute name="style:parent-style-name"><xsl:value-of select="/uof:UOF/uof:式样集/uof:段落式样[@字:标识符=$duan]/@字:基式样引用"/></xsl:attribute>
                    </xsl:if>
                    <xsl:element name="style:graphic-properties">
                        <xsl:call-template name="process-graphics">
                            <xsl:with-param name="draw-name" select="$draw-name"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
                    <xsl:attribute name="style:family"><xsl:choose><xsl:when test="图:预定义图形/图:类别='3' or 图:预定义图形/图:类别='67'">presentation</xsl:when><xsl:otherwise>graphic</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:if test="/uof:UOF/uof:演示文稿/演:主体/演:母版集/演:母版/uof:锚点[@uof:图形引用=$biaozhifu]">
                        <xsl:variable name="duan" select="图:文本内容/字:段落/字:段落属性/@字:式样引用"/>
                        <xsl:attribute name="style:parent-style-name"><xsl:value-of select="/uof:UOF/uof:式样集/uof:段落式样[@字:标识符=$duan]/@字:基式样引用"/></xsl:attribute>
                    </xsl:if>
                    <xsl:element name="style:graphic-properties">
                        <xsl:if test="@图:其他对象">
                            <xsl:attribute name="fo:clip">rect(0cm 0cm 0cm 0cm)</xsl:attribute>
                            <xsl:attribute name="draw:color-mode">standard</xsl:attribute>
                            <xsl:attribute name="draw:luminance">0%</xsl:attribute>
                            <xsl:attribute name="draw:contrast">0%</xsl:attribute>
                            <xsl:attribute name="draw:gamma">100%</xsl:attribute>
                            <xsl:attribute name="draw:red">0%</xsl:attribute>
                            <xsl:attribute name="draw:green">0%</xsl:attribute>
                            <xsl:attribute name="draw:blue">0%</xsl:attribute>
                            <xsl:attribute name="draw:image-opacity">100%</xsl:attribute>
                            <xsl:attribute name="style:mirror">none</xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="process-graphics"/>
                    </xsl:element>
                    <xsl:if test="图:文本内容/@图:文字排列方向='vert-r2l' or 图:文本内容/@图:文字排列方向='vert-l2r'">
                        <xsl:element name="style:paragraph-properties">
                            <xsl:attribute name="style:writing-mode">tb-rl</xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="process-graphics">
        <xsl:param name="draw-name"/>
        <xsl:if test="not(key('rel_graphic_name',@图:标识符)/@uof:随动方式='movesize')">
            <xsl:attribute name="style:protect"><xsl:choose><xsl:when test="key('rel_graphic_name',@图:标识符)/@uof:随动方式='move'">size</xsl:when><xsl:otherwise>position size</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="not(图:预定义图形/图:属性/图:填充)">
                <xsl:attribute name="draw:fill">none</xsl:attribute>
            </xsl:when>
            <xsl:when test="图:预定义图形/图:属性/图:填充/图:图片">
                <xsl:attribute name="draw:fill">bitmap</xsl:attribute>
                <xsl:attribute name="draw:fill-image-name"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图片/@图:名称"/></xsl:attribute>
                <xsl:if test="not(图:预定义图形/图:属性/图:填充/图:图片/@图:位置='title')">
                    <xsl:attribute name="style:repeat"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:位置='center'">no-repeat</xsl:when><xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:位置='stretch'">stretch</xsl:when></xsl:choose></xsl:attribute>
                </xsl:if>
            </xsl:when>
            <xsl:when test="图:预定义图形/图:属性/图:填充/图:图案">
                <xsl:attribute name="draw:fill">bitmap</xsl:attribute>
                <xsl:attribute name="draw:fill-color"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图案/@图:前景色"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="图:预定义图形/图:属性/图:填充/图:颜色">
                <xsl:attribute name="draw:fill">solid</xsl:attribute>
                <xsl:attribute name="draw:fill-color"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:颜色"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="图:预定义图形/图:属性/图:填充/图:渐变">
                <xsl:attribute name="draw:fill">gradient</xsl:attribute>
                <xsl:attribute name="draw:fill-color"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:渐变/@图:起始色"/></xsl:attribute>
                <xsl:attribute name="draw:fill-gradient-name"><xsl:value-of select="concat('Gradient ',$draw-name)"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="图:预定义图形/图:属性/图:线颜色">
            <xsl:attribute name="svg:stroke-color"><xsl:value-of select="图:预定义图形/图:属性/图:线颜色"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:线型 and not(图:预定义图形/图:属性/图:线型 = 'single') and not(图:预定义图形/图:属性/图:线型 = 'thick')">
            <xsl:variable name="linetype" select="图:预定义图形/图:属性/图:线型"/>
            <xsl:attribute name="draw:stroke"><xsl:choose><xsl:when test="$linetype='none'">none</xsl:when><xsl:otherwise>dash</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="draw:stroke-dash"><xsl:choose><xsl:when test="$linetype='dot-dot-dash' or $linetype='dash-dot-dot-heavy'">_32__20_Dots_20_1_20_Dash</xsl:when><xsl:when test="$linetype='dash' or $linetype='dashed-heavy'">Ultrafine_20_Dashed</xsl:when><xsl:when test="$linetype='dotted' or $linetype='dotted-heavy'">Ultrafine_20_Dotted_20__28_var_29_</xsl:when><xsl:when test="$linetype='double'">Line_20_with_20_Fine_20_Dots</xsl:when><xsl:when test="$linetype='dot-dash' or $linetype='dash-dot-heavy'">_33__20_Dashes_20_3_20_Dots_20__28_var_29_</xsl:when><xsl:when test="$linetype='wave' or $linetype='wavy-heavy'">Ultrafine_20_2_20_Dots_20_3_20_Dashes</xsl:when><xsl:when test="$linetype='wavy-double'">Fine_20_Dashed_20__28_var_29_</xsl:when><xsl:otherwise>Fine Dashed</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:线粗细">
            <xsl:attribute name="svg:stroke-width"><xsl:value-of select="concat(图:预定义图形/图:属性/图:线粗细,$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:前端箭头">
            <xsl:attribute name="draw:marker-start"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='normal'">Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='open'">Line_20_Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='stealth'">Arrow_20_concave</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='oval'">Circle</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='diamond'">Square_20_45</xsl:when></xsl:choose></xsl:attribute>
            <xsl:if test="图:预定义图形/图:属性/图:前端箭头/图:大小">
                <xsl:attribute name="draw:marker-start-width"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '1'"><xsl:value-of select="concat('0.05',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '2'"><xsl:value-of select="concat('0.10',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '3'"><xsl:value-of select="concat('0.15',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '4'"><xsl:value-of select="concat('0.20',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '5'"><xsl:value-of select="concat('0.25',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '6'"><xsl:value-of select="concat('0.30',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '7'"><xsl:value-of select="concat('0.35',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '8'"><xsl:value-of select="concat('0.40',$uofUnit)"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('0.45',$uofUnit)"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:后端箭头">
            <xsl:attribute name="draw:marker-end"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='normal'">Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='open'">Line_20_Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='stealth'">Arrow_20_concave</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='oval'">Circle</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='diamond'">Square_20_45</xsl:when></xsl:choose></xsl:attribute>
            <xsl:if test="图:预定义图形/图:属性/图:后端箭头/图:大小">
                <xsl:attribute name="draw:marker-end-width"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '1'"><xsl:value-of select="concat('0.05',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '2'"><xsl:value-of select="concat('0.10',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '3'"><xsl:value-of select="concat('0.15',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '4'"><xsl:value-of select="concat('0.20',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '5'"><xsl:value-of select="concat('0.25',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '6'"><xsl:value-of select="concat('0.30',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '7'"><xsl:value-of select="concat('0.35',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '8'"><xsl:value-of select="concat('0.40',$uofUnit)"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('0.45',$uofUnit)"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:透明度">
            <xsl:attribute name="draw:opacity"><xsl:variable name="opacity"><xsl:value-of select="./图:预定义图形/图:属性/图:透明度"/></xsl:variable><xsl:value-of select="concat((1 - $opacity)*100,'%')"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="图:文本内容">
            <xsl:for-each select="图:文本内容">
                <xsl:if test="@图:上边距">
                    <xsl:attribute name="fo:padding-top"><xsl:value-of select="concat(@图:上边距,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="fo:padding-bottom"><xsl:value-of select="concat(@图:下边距,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="fo:padding-left"><xsl:value-of select="concat(@图:左边距,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="fo:padding-right"><xsl:value-of select="concat(@图:右边距,$uofUnit)"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="not(@图:文字排列方向='middle')">
                    <xsl:variable name="hori-or-vert" select="@图:文字排列方向"/>
                    <xsl:choose>
                        <xsl:when test="$hori-or-vert='vert-l2r'">
                            <xsl:attribute name="draw:textarea-vertical-align">bottom</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="$hori-or-vert='hori-l2r'">
                            <xsl:attribute name="draw:textarea-horizontal-align">left</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="$hori-or-vert='hori-r2l'">
                            <xsl:attribute name="draw:textarea-horizontal-align">right</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$hori-or-vert"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@图:自动换行">
                    <xsl:attribute name="fo:wrap-option">no-wrap</xsl:attribute>
                </xsl:if>
                <xsl:attribute name="draw:auto-grow-width"><xsl:choose><xsl:when test="@图:大小适应文字">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="bina_graphic">
        <xsl:param name="refGraphic"/>
        <xsl:element name="office:binary-data">
            <xsl:for-each select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符 = $refGraphic]">
                <xsl:value-of select="uof:数据"/>
            </xsl:for-each>
        </xsl:element>
        <text:p/>
    </xsl:template>
    <xsl:template name="graphic-fill">
        <xsl:param name="draw-name"/>
        <xsl:param name="gradient-name"/>
        <xsl:if test="图:预定义图形/图:属性/图:填充/图:渐变">
            <xsl:element name="draw:gradient">
                <xsl:attribute name="draw:name"><xsl:value-of select="concat('Gradient ',$draw-name)"/></xsl:attribute>
                <xsl:attribute name="draw:style"><xsl:choose><xsl:when test="$gradient-name/@图:种子类型='linear'"><xsl:value-of select="'linear'"/></xsl:when><xsl:when test="$gradient-name/@图:种子类型='radar'"><xsl:value-of select="'radial'"/></xsl:when><xsl:when test="$gradient-name/@图:种子类型='oval'"><xsl:value-of select="'ellipsoid'"/></xsl:when><xsl:when test="$gradient-name/@图:种子类型='square'"><xsl:value-of select="'square'"/></xsl:when><xsl:when test="$gradient-name/@图:种子类型='rectangle'"><xsl:value-of select="'rectangular'"/></xsl:when></xsl:choose></xsl:attribute>
                <xsl:attribute name="draw:start-color"><xsl:value-of select="$gradient-name/@图:起始色"/></xsl:attribute>
                <xsl:attribute name="draw:end-color"><xsl:value-of select="$gradient-name/@图:终止色"/></xsl:attribute>
                <xsl:attribute name="draw:start-intensity"><xsl:value-of select="concat($gradient-name/@图:起始浓度,'%')"/></xsl:attribute>
                <xsl:attribute name="draw:end-intensity"><xsl:value-of select="concat($gradient-name/@图:终止浓度,'%')"/></xsl:attribute>
                <xsl:attribute name="draw:angle"><xsl:value-of select="$gradient-name/@图:渐变方向 * 10"/></xsl:attribute>
                <xsl:attribute name="draw:border"><xsl:value-of select="concat($gradient-name/@图:边界,'%')"/></xsl:attribute>
                <xsl:if test="$gradient-name/@图:种子X位置">
                    <xsl:attribute name="draw:cx"><xsl:value-of select="concat($gradient-name/@图:种子X位置,'%')"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="$gradient-name/@图:种子Y位置">
                    <xsl:attribute name="draw:cy"><xsl:value-of select="concat($gradient-name/@图:种子Y位置,'%')"/></xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:前端箭头">
            <xsl:element name="draw:marker">
                <xsl:attribute name="draw:name"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='normal'">Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='open'">Line_20_Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='stealth'">Arrow_20_concave</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='oval'">Circle</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='diamond'">Square_20_45</xsl:when></xsl:choose></xsl:attribute>
                <xsl:choose>
                    <xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='normal'">
                        <xsl:attribute name="svg:viewBox">0 0 20 30</xsl:attribute>
                        <xsl:attribute name="svg:d">m10 0-10 30h20z</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='open'">
                        <xsl:attribute name="svg:viewBox">0 0 1122 2243</xsl:attribute>
                        <xsl:attribute name="svg:d">m0 2108v17 17l12 42 30 34 38 21 43 4 29-8 30-21 25-26 13-34 343-1532 339 1520 13 42 29 34 39 21 42 4 42-12 34-30 21-42v-39-12l-4 4-440-1998-9-42-25-39-38-25-43-8-42 8-38 25-26 39-8 42z</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='stealth'">
                        <xsl:attribute name="svg:viewBox">0 0 1131 1580</xsl:attribute>
                        <xsl:attribute name="svg:d">m1013 1491 118 89-567-1580-564 1580 114-85 136-68 148-46 161-17 161 13 153 46z</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='oval'">
                        <xsl:attribute name="svg:viewBox">0 0 1131 1131</xsl:attribute>
                        <xsl:attribute name="svg:d">m462 1118-102-29-102-51-93-72-72-93-51-102-29-102-13-105 13-102 29-106 51-102 72-89 93-72 102-50 102-34 106-9 101 9 106 34 98 50 93 72 72 89 51 102 29 106 13 102-13 105-29 102-51 102-72 93-93 72-98 51-106 29-101 13z</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='diamond'">
                        <xsl:attribute name="svg:viewBox">0 0 1131 1131</xsl:attribute>
                        <xsl:attribute name="svg:d">m0 564 564 567 567-567-567-564z</xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:后端箭头">
            <xsl:element name="draw:marker">
                <xsl:attribute name="draw:name"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='normal'">Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='open'">Line_20_Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='stealth'">Arrow_20_concave</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='oval'">Circle</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='diamond'">Square_20_45</xsl:when></xsl:choose></xsl:attribute>
                <xsl:choose>
                    <xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='normal'">
                        <xsl:attribute name="svg:viewBox">0 0 20 30</xsl:attribute>
                        <xsl:attribute name="svg:d">m10 0-10 30h20z</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='open'">
                        <xsl:attribute name="svg:viewBox">0 0 1122 2243</xsl:attribute>
                        <xsl:attribute name="svg:d">m0 2108v17 17l12 42 30 34 38 21 43 4 29-8 30-21 25-26 13-34 343-1532 339 1520 13 42 29 34 39 21 42 4 42-12 34-30 21-42v-39-12l-4 4-440-1998-9-42-25-39-38-25-43-8-42 8-38 25-26 39-8 42z</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='stealth'">
                        <xsl:attribute name="svg:viewBox">0 0 1131 1580</xsl:attribute>
                        <xsl:attribute name="svg:d">m1013 1491 118 89-567-1580-564 1580 114-85 136-68 148-46 161-17 161 13 153 46z</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='oval'">
                        <xsl:attribute name="svg:viewBox">0 0 1131 1131</xsl:attribute>
                        <xsl:attribute name="svg:d">m462 1118-102-29-102-51-93-72-72-93-51-102-29-102-13-105 13-102 29-106 51-102 72-89 93-72 102-50 102-34 106-9 101 9 106 34 98 50 93 72 72 89 51 102 29 106 13 102-13 105-29 102-51 102-72 93-93 72-98 51-106 29-101 13z</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='diamond'">
                        <xsl:attribute name="svg:viewBox">0 0 1131 1131</xsl:attribute>
                        <xsl:attribute name="svg:d">m0 564 564 567 567-567-567-564z</xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:填充/图:图片/@图:图形引用 or 图:预定义图形/图:属性/图:填充/图:图案/@图:图形引用">
            <xsl:element name="draw:fill-image">
                <xsl:attribute name="draw:name"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:填充/图:图案/@图:图形引用"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图案/@图:类型"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:图形引用"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图片/@图:名称"/></xsl:when></xsl:choose></xsl:attribute>
                <xsl:call-template name="bina_graphic">
                    <xsl:with-param name="refGraphic">
                        <xsl:choose>
                            <xsl:when test="图:预定义图形/图:属性/图:填充/图:图案/@图:图形引用">
                                <xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图案/@图:图形引用"/>
                            </xsl:when>
                            <xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:图形引用">
                                <xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图片/@图:图形引用"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:element>
        </xsl:if>
        <xsl:if test="not(图:预定义图形/图:属性/图:线型='single') and not(图:预定义图形/图:属性/图:线型='thick') and 图:预定义图形/图:属性/图:线型">
            <xsl:variable name="line" select="图:预定义图形/图:属性/图:线型"/>
            <xsl:element name="draw:stroke-dash">
                <xsl:choose>
                    <xsl:when test="$line='dash-long' or $line='dash-long-heavy'">
                        <xsl:attribute name="draw:name">Fine_20_Dashed</xsl:attribute>
                        <xsl:attribute name="draw:display-name">Fine dashed</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">1</xsl:attribute>
                        <xsl:attribute name="draw:dots1-length">0.508cm</xsl:attribute>
                        <xsl:attribute name="draw:dots2">1</xsl:attribute>
                        <xsl:attribute name="draw:dots2-length">0.508cm</xsl:attribute>
                        <xsl:attribute name="draw:distance">0.508cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='dot-dot-dash' or $line='dash-dot-dot-heavy'">
                        <xsl:attribute name="draw:name">_32__20_Dots_20_1_20_Dash</xsl:attribute>
                        <xsl:attribute name="draw:display-name">2 Dots 1 Dash</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">2</xsl:attribute>
                        <xsl:attribute name="draw:dots2">1</xsl:attribute>
                        <xsl:attribute name="draw:dots2-length">0.203cm</xsl:attribute>
                        <xsl:attribute name="draw:distance">0.203cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='dash' or $line='dashed-heavy'">
                        <xsl:attribute name="draw:name">Ultrafine_20_Dashed</xsl:attribute>
                        <xsl:attribute name="draw:display-name">Ultrafine Dashed</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">1</xsl:attribute>
                        <xsl:attribute name="draw:dots1-length">0.051cm</xsl:attribute>
                        <xsl:attribute name="draw:dots2">1</xsl:attribute>
                        <xsl:attribute name="draw:dots2-length">0.051cm</xsl:attribute>
                        <xsl:attribute name="draw:distance">0.051cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='dotted' or $line='dotted-heavy'">
                        <xsl:attribute name="draw:name">Ultrafine_20_Dotted_20__28_var_29_</xsl:attribute>
                        <xsl:attribute name="draw:display-name">Ultrafine Dotted (var)</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">1</xsl:attribute>
                        <xsl:attribute name="draw:distance">50%</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='wave' or $line='wavy-heavy'">
                        <xsl:attribute name="draw:name">Ultrafine_20_2_20_Dots_20_3_20_Dashes</xsl:attribute>
                        <xsl:attribute name="draw:display-name">Ultrafine 2 Dots 3 Dashes</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">2</xsl:attribute>
                        <xsl:attribute name="draw:dots1-length">0.051cm</xsl:attribute>
                        <xsl:attribute name="draw:dots2">3</xsl:attribute>
                        <xsl:attribute name="draw:dots2-length">0.254cm</xsl:attribute>
                        <xsl:attribute name="draw:distance">0.127cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='dot-dash' or $line='dash-dot-heavy'">
                        <xsl:attribute name="draw:name">_33__20_Dashes_20_3_20_Dots_20__28_var_29_</xsl:attribute>
                        <xsl:attribute name="draw:display-name">3 Dashes 3 Dots (var)</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">3</xsl:attribute>
                        <xsl:attribute name="draw:dots1-length">197%</xsl:attribute>
                        <xsl:attribute name="draw:dots2">3</xsl:attribute>
                        <xsl:attribute name="draw:distance">100%</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='double'">
                        <xsl:attribute name="draw:name">Line_20_with_20_Fine_20_Dots</xsl:attribute>
                        <xsl:attribute name="draw:display-name">Line with Fine Dots</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">1</xsl:attribute>
                        <xsl:attribute name="draw:dots1-length">2.007cm</xsl:attribute>
                        <xsl:attribute name="draw:dots2">10</xsl:attribute>
                        <xsl:attribute name="draw:distance">0.152cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='wavy-double'">
                        <xsl:attribute name="draw:name">Fine_20_Dashed_20__28_var_29_</xsl:attribute>
                        <xsl:attribute name="draw:display-name">Fine Dashed (var)</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">1</xsl:attribute>
                        <xsl:attribute name="draw:dots1-length">197%</xsl:attribute>
                        <xsl:attribute name="draw:distance">197%</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="draw:name">Fine Dashed</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">1</xsl:attribute>
                        <xsl:attribute name="draw:dots1-length">0.508cm</xsl:attribute>
                        <xsl:attribute name="draw:dots2">1</xsl:attribute>
                        <xsl:attribute name="draw:dots2-length">0.508cm</xsl:attribute>
                        <xsl:attribute name="draw:distance">0.508cm</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="create-page-master">
        <xsl:param name="impressoptions"/>
        <xsl:for-each select="$impressoptions">
            <xsl:element name="style:page-layout">
                <xsl:attribute name="style:name"><xsl:call-template name="encode-as-nc-name"><xsl:with-param name="string" select="@演:标识符"/></xsl:call-template></xsl:attribute>
                <xsl:element name="style:page-layout-properties">
                    <xsl:if test="演:纸张/@uof:宽度">
                        <xsl:attribute name="fo:page-width"><xsl:value-of select="concat(演:纸张/@uof:宽度,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="演:纸张/@uof:高度">
                        <xsl:attribute name="fo:page-height"><xsl:value-of select="concat((演:纸张/@uof:高度),$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="演:页边距">
                        <xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(演:页边距/@uof:上,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(演:页边距/@uof:下,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(演:页边距/@uof:左,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(演:页边距/@uof:右,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="演:纸张方向 = 'landscape'">
                            <xsl:attribute name="style:print-orientation">landscape</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:print-orientation">portrait</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="encode-as-nc-name">
        <xsl:param name="string"/>
        <xsl:value-of select="translate($string, '. %()/\+', '')"/>
    </xsl:template>
    <xsl:key name="tianchongmu" match="/uof:UOF/uof:演示文稿/演:主体/演:母版集/演:母版" use="@演:配色方案引用"/>
    <xsl:key name="tianchonghuan" match="/uof:UOF/uof:演示文稿/演:主体/演:幻灯片集/演:幻灯片" use="@演:标识符"/>
    <xsl:template match="演:配色方案">
        <xsl:if test="key('tianchongmu',@演:标识符)/演:背景">
            <xsl:for-each select="key('tianchongmu',@演:标识符)/演:背景">
                <xsl:call-template name="officestyle"/>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="key('tianchonghuan',@演:标识符)/演:背景">
            <xsl:for-each select="key('tianchonghuan',@演:标识符)/演:背景">
                <xsl:call-template name="officestyle"/>
            </xsl:for-each>
        </xsl:if>
        <xsl:element name="style:style">
            <xsl:attribute name="style:family">drawing-page</xsl:attribute>
            <xsl:attribute name="style:name"><xsl:value-of select="@演:标识符"/></xsl:attribute>
            <xsl:element name="style:drawing-page-properties">
                <xsl:if test="演:填充">
                    <xsl:attribute name="draw:fill">solid</xsl:attribute>
                    <xsl:attribute name="draw:fill-color"><xsl:value-of select="演:背景色"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="演:背景色">
                    <xsl:attribute name="draw:background-size">border</xsl:attribute>
                </xsl:if>
                <xsl:if test="演:阴影">
                    <xsl:attribute name="draw:shadow">visible</xsl:attribute>
                    <xsl:attribute name="draw:shadow-color"><xsl:value-of select="演:阴影"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="演:文本和线条">
                    <xsl:attribute name="svg:stroke-color"><xsl:value-of select="演:文本和线条"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="key('tianchongmu',@演:标识符)/演:背景">
                    <xsl:for-each select="key('tianchongmu',@演:标识符)/演:背景">
                        <xsl:call-template name="background"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="key('tianchonghuan',@演:标识符)/演:背景">
                    <xsl:for-each select="key('tianchonghuan',@演:标识符)/演:背景">
                        <xsl:call-template name="background"/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:element>
            <xsl:variable name="style-name">
                <xsl:value-of select="@演:标识符"/>
            </xsl:variable>
            <xsl:for-each select="/uof:UOF/uof:演示文稿/演:主体/演:幻灯片集/演:幻灯片[@演:标识符=$style-name]/演:切换">
                <style:drawing-page-properties>
                    <xsl:if test="@演:速度='slow'">
                        <xsl:attribute name="presentation:transition-speed">slow</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="not(@演:效果 = 'none')">
                        <xsl:variable name="effect">
                            <xsl:value-of select="@演:效果"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$effect='box in'">
                                <xsl:attribute name="smil:type">irisWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">rectangle</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='box out'">
                                <xsl:attribute name="smil:type">irisWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">rectangle</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='checkerboard across'">
                                <xsl:attribute name="smil:type">checkerBoardWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">across</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='checkerboard down'">
                                <xsl:attribute name="smil:type">checkerBoardWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">down</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='comb horizontal'">
                                <xsl:attribute name="smil:type">pushWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">combHorizontal</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='comb vertical'">
                                <xsl:attribute name="smil:type">pushWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">combVertical</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='uncover down'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromTop</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='uncover left'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromRight</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='uncover right'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromLeft</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='uncover up'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromBottom</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='uncover left-down'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromTopRight</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='uncover left-up'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromBottomRight</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='uncover right-down'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromTopLeft</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='uncover right-up'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromBottomLeft</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='cover down'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromTop</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='cover left'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromRight</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='cover right'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromLeft</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='cover up'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromBottom</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='cover left-down'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromTopRight</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='cover left-up'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromBottomRight</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='cover right-down'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromTopLeft</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='cover right-up'">
                                <xsl:attribute name="smil:type">slideWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromBottomLeft</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='fade through black'">
                                <xsl:attribute name="smil:type">fade</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fadeOverColor</xsl:attribute>
                                <xsl:attribute name="smil:fadeColor">#000000</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='push down'">
                                <xsl:attribute name="smil:type">pushWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromTop</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='push left'">
                                <xsl:attribute name="smil:type">pushWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromRight</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='push right'">
                                <xsl:attribute name="smil:type">pushWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromLeft</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='push up'">
                                <xsl:attribute name="smil:type">pushWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fromBottom</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='random bars horizontal'">
                                <xsl:attribute name="smil:type">randomBarWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">horizontal</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='random bars vertical'">
                                <xsl:attribute name="smil:type">randomBarWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">vertical</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='shape circle'">
                                <xsl:attribute name="smil:type">ellipseWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">circle</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='shape diamond'">
                                <xsl:attribute name="smil:type">irisWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">diamond</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='shape plus'">
                                <xsl:attribute name="smil:type">fourBoxWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">cornersOut</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='split horizontal in'">
                                <xsl:attribute name="smil:type">barnDoorWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">horizontal</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='split horizontal out'">
                                <xsl:attribute name="smil:type">barnDoorWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">horizontal</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='split vertical in'">
                                <xsl:attribute name="smil:type">barnDoorWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">vertical</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='split vertical out'">
                                <xsl:attribute name="smil:type">barnDoorWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">vertical</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='wedge'">
                                <xsl:attribute name="smil:type">fanWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">centerTop</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='wheel clockwise – 1 spoke'">
                                <xsl:attribute name="smil:type">pinWheelWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">oneBlade</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='wheel clockwise – 2 spoke'">
                                <xsl:attribute name="smil:type">pinWheelWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">twoBladeVertical</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='wheel clockwise – 3 spoke'">
                                <xsl:attribute name="smil:type">pinWheelWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">threeBlade</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='wheel clockwise – 4 spoke'">
                                <xsl:attribute name="smil:type">pinWheelWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">fourBlade</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='wheel clockwise – 8 spoke'">
                                <xsl:attribute name="smil:type">pinWheelWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">eightBlade</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='wipe left'">
                                <xsl:attribute name="smil:type">barWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">leftToRight</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='wipe right'">
                                <xsl:attribute name="smil:type">barWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">leftToRight</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='wipe up'">
                                <xsl:attribute name="smil:type">barWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">topToBottom</xsl:attribute>
                                <xsl:attribute name="smil:direction">reverse</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='wipe down'">
                                <xsl:attribute name="smil:type">barWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">topToBottom</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='blinds vertical'">
                                <xsl:attribute name="smil:type">blindsWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">vertical</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='blinds horizontal'">
                                <xsl:attribute name="smil:type">blindsWipe</xsl:attribute>
                                <xsl:attribute name="smil:subtype">horizontal</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='dissolve'">
                                <xsl:attribute name="smil:type">dissolve</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effect='random transition'">
                                <xsl:attribute name="smil:type">random</xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="演:方式/演:单击鼠标='false'">
                        <xsl:attribute name="presentation:transition-type">automatic</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="演:方式/演:时间间隔">
                        <xsl:attribute name="presentation:duration"><xsl:value-of select="concat('PT00H00M',演:方式/演:时间间隔,'S')"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="(演:声音/@演:预定义声音 and not(演:声音/@演:预定义声音='none')) or 演:声音/@演:自定义声音">
                        <xsl:choose>
                            <xsl:when test="演:声音/@演:预定义声音">
                                <xsl:variable name="voice">
                                    <xsl:value-of select="演:声音/@演:预定义声音"/>
                                </xsl:variable>
                                <presentation:sound xlink:type="simple" xlink:show="new" xlink:actuate="onRequest">
                                    <xsl:attribute name="xlink:href"><xsl:choose><xsl:when test="$voice='applause'">../../../../../../../softwware/Redoffcie%203.0/share/gallery/sounds/applause.wav</xsl:when><xsl:when test="$voice='explosion'">../../../../../../../softwware/Redoffcie%203.0/share/gallery/sounds/explos.wav</xsl:when><xsl:when test="$voice='laser'">../../../../../../../softwware/Redoffcie%203.0/share/gallery/sounds/laser.wav</xsl:when><xsl:otherwise><xsl:value-of select="演:声音/@演:预定义声音"/></xsl:otherwise></xsl:choose></xsl:attribute>
                                </presentation:sound>
                            </xsl:when>
                            <xsl:otherwise>
                                <presentation:sound xlink:type="simple" xlink:show="new" xlink:actuate="onRequest">
                                    <xsl:attribute name="xlink:href"><xsl:value-of select="演:声音/@演:自定义声音"/></xsl:attribute>
                                </presentation:sound>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </style:drawing-page-properties>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template name="officestyle">
        <xsl:variable name="random-name">
            <xsl:value-of select="generate-id()"/>
        </xsl:variable>
        <xsl:variable name="draw-name">
            <xsl:value-of select="substring($random-name,string-length($random-name)-1)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="图:渐变">
                <xsl:element name="draw:gradient">
                    <xsl:attribute name="draw:name"><xsl:value-of select="concat('Gradient ',$draw-name)"/></xsl:attribute>
                    <xsl:attribute name="draw:style"><xsl:choose><xsl:when test="图:渐变/@图:种子类型='linear'"><xsl:value-of select="'linear'"/></xsl:when><xsl:when test="图:渐变/@图:种子类型='radar'"><xsl:value-of select="'radial'"/></xsl:when><xsl:when test="图:渐变/@图:种子类型='oval'"><xsl:value-of select="'ellipsoid'"/></xsl:when><xsl:when test="图:渐变/@图:种子类型='square'"><xsl:value-of select="'square'"/></xsl:when><xsl:when test="图:渐变/@图:种子类型='rectangle'"><xsl:value-of select="'rectangular'"/></xsl:when></xsl:choose></xsl:attribute>
                    <xsl:attribute name="draw:start-color"><xsl:value-of select="图:渐变/@图:起始色"/></xsl:attribute>
                    <xsl:attribute name="draw:end-color"><xsl:value-of select="图:渐变/@图:终止色"/></xsl:attribute>
                    <xsl:attribute name="draw:start-intensity"><xsl:value-of select="concat(图:渐变/@图:起始浓度,'%')"/></xsl:attribute>
                    <xsl:attribute name="draw:end-intensity"><xsl:value-of select="concat(图:渐变/@图:终止浓度,'%')"/></xsl:attribute>
                    <xsl:attribute name="draw:angle"><xsl:value-of select="图:渐变/@图:渐变方向 * 10"/></xsl:attribute>
                    <xsl:attribute name="draw:border"><xsl:value-of select="concat(图:渐变/@图:边界,'%')"/></xsl:attribute>
                    <xsl:if test="图:渐变/@图:种子X位置">
                        <xsl:attribute name="draw:cx"><xsl:value-of select="concat(图:渐变/@图:种子X位置,'%')"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="图:渐变/@图:种子Y位置">
                        <xsl:attribute name="draw:cy"><xsl:value-of select="concat(图:渐变/@图:种子Y位置,'%')"/></xsl:attribute>
                    </xsl:if>
                </xsl:element>
            </xsl:when>
            <xsl:when test="图:图片/@图:图形引用 or 图:图案/@图:图形引用">
                <xsl:element name="draw:fill-image">
                    <xsl:attribute name="draw:name"><xsl:choose><xsl:when test="图:图案/@图:图形引用"><xsl:value-of select="图:图案/@图:类型"/></xsl:when><xsl:when test="图:图片/@图:图形引用"><xsl:value-of select="图:图片/@图:名称"/></xsl:when></xsl:choose></xsl:attribute>
                    <xsl:call-template name="bina_graphic">
                        <xsl:with-param name="refGraphic">
                            <xsl:choose>
                                <xsl:when test="图:图案/@图:图形引用">
                                    <xsl:value-of select="图:图案/@图:图形引用"/>
                                </xsl:when>
                                <xsl:when test="图:图片/@图:图形引用">
                                    <xsl:value-of select="图:图片/@图:图形引用"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="background">
        <xsl:variable name="random-name">
            <xsl:value-of select="generate-id()"/>
        </xsl:variable>
        <xsl:variable name="draw-name">
            <xsl:value-of select="substring($random-name,string-length($random-name)-1)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="图:图片">
                <xsl:attribute name="draw:fill">bitmap</xsl:attribute>
                <xsl:attribute name="draw:fill-image-name"><xsl:value-of select="图:图片/@图:名称"/></xsl:attribute>
                <xsl:if test="not(图:图片/@图:位置='title')">
                    <xsl:attribute name="style:repeat"><xsl:choose><xsl:when test="图:图片/@图:位置='center'">no-repeat</xsl:when><xsl:when test="图:图片/@图:位置='stretch'">stretch</xsl:when></xsl:choose></xsl:attribute>
                </xsl:if>
            </xsl:when>
            <xsl:when test="图:图案">
                <xsl:attribute name="draw:fill">bitmap</xsl:attribute>
                <xsl:attribute name="draw:fill-color"><xsl:value-of select="图:图案/@图:前景色"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="图:颜色">
                <xsl:attribute name="draw:fill-color"><xsl:value-of select="图:颜色"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="图:渐变">
                <xsl:attribute name="draw:fill">gradient</xsl:attribute>
                <xsl:attribute name="draw:fill-color"><xsl:value-of select="图:渐变/@图:起始色"/></xsl:attribute>
                <xsl:attribute name="draw:fill-gradient-name"><xsl:value-of select="concat('Gradient ',$draw-name)"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="演:母版集">
        <draw:layer-set>
            <draw:layer draw:name="layout"/>
            <draw:layer draw:name="background"/>
            <draw:layer draw:name="backgroundobjects"/>
            <draw:layer draw:name="controls"/>
            <draw:layer draw:name="measurelines"/>
        </draw:layer-set>
        <xsl:apply-templates select="演:母版"/>
    </xsl:template>
    <xsl:template match="演:母版">
        <xsl:choose>
            <xsl:when test="@演:类型 = 'handout' ">
                <xsl:element name="style:handout-master">
                    <xsl:attribute name="style:name"><xsl:value-of select="@演:标识符"/></xsl:attribute>
                    <xsl:attribute name="style:page-layout-name"><xsl:value-of select="@演:页面设置引用"/></xsl:attribute>
                    <xsl:attribute name="draw:style-name"><xsl:value-of select="@演:配色方案引用"/></xsl:attribute>
                    <xsl:for-each select="uof:锚点[@uof:缩略图='true']">
                        <draw:page-thumbnail draw:layer="backgroundobjects">
                            <xsl:attribute name="svg:width"><xsl:value-of select="concat(@uof:宽度,$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="svg:height"><xsl:value-of select="concat(@uof:高度,$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="svg:x"><xsl:value-of select="concat(@uof:x坐标,$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="svg:y"><xsl:value-of select="concat(@uof:y坐标,$uofUnit)"/></xsl:attribute>
                        </draw:page-thumbnail>
                    </xsl:for-each>
                    <xsl:apply-templates select="uof:锚点[not(@uof:缩略图='true')]"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@演:类型 = 'slide'">
                <xsl:element name="style:master-page">
                    <xsl:attribute name="style:name"><xsl:value-of select="@演:标识符"/></xsl:attribute>
                    <xsl:attribute name="style:page-layout-name"><xsl:value-of select="@演:页面设置引用"/></xsl:attribute>
                    <xsl:attribute name="draw:style-name"><xsl:value-of select="@演:配色方案引用"/></xsl:attribute>
                    <xsl:apply-templates select="uof:锚点 "/>
                    <xsl:for-each select="/uof:UOF/uof:演示文稿/演:主体/演:母版集/演:母版">
                        <xsl:if test="@演:类型 = 'notes'">
                            <xsl:element name="presentation:notes">
                                <xsl:attribute name="style:page-layout-name"><xsl:value-of select="@演:页面设置引用"/></xsl:attribute>
                                <xsl:attribute name="draw:style-name"><xsl:value-of select="@演:配色方案引用"/></xsl:attribute>
                                <xsl:apply-templates select="uof:锚点 "/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="uof:句式样">
        <xsl:element name="style:style">
            <xsl:attribute name="style:name"><xsl:value-of select="@字:标识符"/></xsl:attribute>
            <xsl:if test="@字:基式样引用">
                <xsl:attribute name="style:parent-style-name"><xsl:value-of select="@字:基式样引用"/></xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="ancestor::字:段落式样">
                    <xsl:attribute name="style:family">paragraph</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="style:family">text</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:element name="style:text-properties">
                <xsl:apply-templates select="*"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="段落式样">
        <xsl:element name="style:style">
            <xsl:variable name="outline" select="@字:标识符"/>
            <xsl:attribute name="style:family"><xsl:choose><xsl:when test="/uof:UOF/uof:式样集/uof:自动编号集/字:自动编号[@字:标识符=$outline]">presentation</xsl:when><xsl:otherwise>paragraph</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="style:name"><xsl:value-of select="@字:标识符"/></xsl:attribute>
            <xsl:if test="@字:基式样引用">
                <xsl:attribute name="style:parent-style-name"><xsl:value-of select="@字:基式样引用"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="/uof:UOF/uof:式样集/uof:自动编号集/字:自动编号[@字:标识符=$outline]">
                <xsl:for-each select="/uof:UOF/uof:式样集/uof:自动编号集/字:自动编号[@字:标识符=$outline]">
                    <style:graphic-properties draw:stroke="none" draw:fill="none">
                        <xsl:element name="text:list-style">
                            <xsl:call-template name="自动编号"/>
                        </xsl:element>
                    </style:graphic-properties>
                </xsl:for-each>
            </xsl:if>
            <xsl:element name="style:paragraph-properties">
                <xsl:if test="字:自动编号信息">
                    <xsl:attribute name="text:enable-numbering">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="contains($outline,'title')">
                    <xsl:attribute name="fo:text-align">center</xsl:attribute>
                </xsl:if>
                <xsl:call-template name="paragraph-properties"/>
            </xsl:element>
            <xsl:element name="style:text-properties">
                <xsl:apply-templates select="*"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="paragraph-properties">
        <xsl:choose>
            <xsl:when test="descendant::字:页边距[@uof:左]">
                <xsl:attribute name="fo:margin-left"><xsl:value-of select="number(((descendant::字:页边距/@uof:左)div 10) *1)"/>cm</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="fo:margin-left">0cm</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="descendant::字:页边距[@uof:右]">
                <xsl:attribute name="fo:margin-right"><xsl:value-of select="number(((descendant::字:页边距/@uof:右)div 10) *1)"/>cm</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="fo:margin-right">0cm</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:attribute name="fo:text-indent">0cm</xsl:attribute>
        <xsl:call-template name="bidi"/>
    </xsl:template>
    <xsl:template name="bidi">
    </xsl:template>
    <xsl:template name="jibianhao">
        <xsl:param name="biaoshifu"/>
        <xsl:element name="text:list-level-style-number">
            <xsl:variable name="currlevel" select="number(@字:级别值)"/>
            <xsl:attribute name="text:level"><xsl:value-of select="$currlevel"/></xsl:attribute>
            <xsl:attribute name="text:style-name">Numbering Symbols</xsl:attribute>
            <xsl:if test="字:起始编号">
                <xsl:attribute name="text:start-value"><xsl:value-of select="字:起始编号"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="字:正规格式">
                <xsl:attribute name="text:num-regular-exp"><xsl:value-of select="字:正规格式/@值"/></xsl:attribute>
            </xsl:if>
            <xsl:attribute name="text:display-levels"><xsl:value-of select="string-length(字:编号格式表示) - string-length(translate(字:编号格式表示,'%','') )"/></xsl:attribute>
            <xsl:if test="字:编号格式">
                <xsl:call-template name="编号格式"/>
            </xsl:if>
            <xsl:if test="字:编号格式表示">
                <xsl:attribute name="style:num-prefix"><xsl:choose><xsl:when test="number($currlevel) =1"><xsl:value-of select="substring-before(字:编号格式表示,concat('%',$currlevel))"/></xsl:when><xsl:otherwise><xsl:value-of select="substring-after(substring-after( substring-before(字:编号格式表示,concat('%',$currlevel)),concat('%',string(number($currlevel) -1))),'.')"/></xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="style:num-suffix"><xsl:value-of select="substring-after(字:编号格式表示,concat('%',$currlevel))"/></xsl:attribute>
            </xsl:if>
            <xsl:element name="style:list-level-properties">
                <xsl:if test="@字:编号对齐方式">
                    <xsl:attribute name="fo:text-align"><xsl:value-of select="@字:编号对齐方式"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="suojinleixing"/>
            </xsl:element>
            <xsl:element name="style:text-properties">
                <xsl:if test="字:符号字体">
                    <xsl:variable name="Font-ID">
                        <xsl:value-of select="字:符号字体/@字:式样引用"/>
                    </xsl:variable>
                    <xsl:for-each select="/uof:UOF/uof:式样集/uof:句式样">
                        <xsl:if test="@字:标识符=$Font-ID">
                            <xsl:if test="字:字体/@字:中文字体引用">
                                <xsl:attribute name="fo:font-family"><xsl:value-of select="字:字体/@字:中文字体引用"/></xsl:attribute>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="字:符号字体">
                        <xsl:apply-templates select="*"/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="xiangmufuhao">
        <xsl:param name="biaoshifu"/>
        <xsl:variable name="currlevel" select="number(@字:级别值)"/>
        <xsl:element name="text:list-level-style-bullet">
            <xsl:attribute name="text:level"><xsl:value-of select="$currlevel"/></xsl:attribute>
            <xsl:attribute name="text:style-name"><xsl:value-of select="concat( $biaoshifu,$currlevel)"/></xsl:attribute>
            <xsl:attribute name="style:num-suffix"><xsl:value-of select="substring-after(字:编号格式表示,'%1')"/></xsl:attribute>
            <xsl:attribute name="text:bullet-char"><xsl:value-of select="字:项目符号"/></xsl:attribute>
            <xsl:element name="style:list-level-properties">
                <xsl:if test="@字:编号对齐方式">
                    <xsl:attribute name="fo:text-align"><xsl:value-of select="@字:编号对齐方式"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="suojinleixing"/>
            </xsl:element>
            <xsl:element name="style:text-properties">
                <xsl:if test="字:符号字体">
                    <xsl:variable name="Font-ID">
                        <xsl:value-of select="字:符号字体/@字:式样引用"/>
                    </xsl:variable>
                    <xsl:for-each select="/uof:UOF/uof:式样集/uof:句式样[@字:标识符=$Font-ID]">
                        <xsl:if test="字:字体/@字:中文字体引用">
                            <xsl:attribute name="fo:font-family"><xsl:value-of select="字:字体/@字:中文字体引用"/></xsl:attribute>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="字:符号字体">
                        <xsl:apply-templates select="*"/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="suojinleixing">
        <xsl:if test="字:缩进/字:左/字:绝对/@字:值">
            <xsl:attribute name="text:space-before"><xsl:value-of select="concat(number(字:缩进/字:左/字:绝对/@字:值),$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:缩进/字:右/字:绝对/@字:值">
            <xsl:attribute name="text:min-label-width"><xsl:value-of select="concat(number(字:缩进/字:右/字:绝对/@字:值),$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:缩进/字:首行/字:绝对/@字:值">
            <xsl:attribute name="text:min-label-distance"><xsl:value-of select="concat(number(字:缩进/字:首行/字:绝对/@字:值),$uofUnit)"/></xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template name="imagefuhao">
        <xsl:param name="biaoshifu"/>
        <xsl:variable name="currlevel" select="number(@字:级别值)"/>
        <xsl:element name="text:list-level-style-image" style:vertical-pos="middle" style:vertical-rel="line" fo:width="0.265cm" fo:height="0.265cm">
            <xsl:attribute name="text:level"><xsl:value-of select="$currlevel"/></xsl:attribute>
            <xsl:attribute name="text:style-name"><xsl:value-of select="concat( $biaoshifu,$currlevel)"/></xsl:attribute>
            <xsl:attribute name="style:num-suffix"><xsl:value-of select="substring-after(字:编号格式表示,'%1')"/></xsl:attribute>
            <xsl:if test="字:图片符号引用">
                <xsl:variable name="gid">
                    <xsl:value-of select="字:图片符号引用"/>
                </xsl:variable>
                <xsl:element name="office:binary-data">
                    <xsl:value-of select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$gid]/uof:数据"/>
                </xsl:element>
            </xsl:if>
            <xsl:element name="style:list-level-properties">
                <xsl:attribute name="style:vertical-pos">middle</xsl:attribute>
                <xsl:attribute name="style:vertical-rel">line</xsl:attribute>
                <xsl:attribute name="fo:width"><xsl:value-of select="concat(字:图片符号引用/@字:宽度,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="fo:height"><xsl:value-of select="concat(字:图片符号引用/@字:高度,$uofUnit)"/></xsl:attribute>
                <xsl:if test="字:符号字体">
                    <xsl:variable name="Font-ID">
                        <xsl:value-of select="字:符号字体/@字:式样引用"/>
                    </xsl:variable>
                    <xsl:for-each select="/uof:UOF/uof:式样集/uof:句式样">
                        <xsl:if test="@字:标识符=$Font-ID">
                            <xsl:if test="字:字体/@字:中文字体引用">
                                <xsl:attribute name="fo:font-family"><xsl:value-of select="字:字体/@字:中文字体引用"/></xsl:attribute>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                <xsl:call-template name="suojinleixing"/>
                <xsl:if test="@字:编号对齐方式">
                    <xsl:attribute name="fo:text-align"><xsl:value-of select="@字:编号对齐方式"/></xsl:attribute>
                </xsl:if>
            </xsl:element>
            <xsl:element name="style:text-properties">
                <xsl:for-each select="字:符号字体">
                    <xsl:apply-templates select="*"/>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="编号格式">
        <xsl:attribute name="style:num-format"><xsl:choose><xsl:when test="string(字:编号格式)='lower-letter'">a</xsl:when><xsl:when test="string(字:编号格式)='upper-letter'">A</xsl:when><xsl:when test="string(字:编号格式)='lower-roman'">i</xsl:when><xsl:when test="string(字:编号格式)='upper-roman'">I</xsl:when><xsl:when test="string(字:编号格式)='decimal-enclosed-circle'">①, ②, ③, ...</xsl:when><xsl:when test="string(字:编号格式)='ideograph-traditional'">甲, 乙, 丙, ...</xsl:when><xsl:when test="string(字:编号格式)='ideograph-zodiac'">子, 丑, 寅, ...</xsl:when><xsl:when test="string(字:编号格式)='chinese-counting'">一, 二, 三, ...</xsl:when><xsl:when test="string(字:编号格式)='chinese-legal-simplified'">壹, 贰, 叁, ...</xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute>
    </xsl:template>
    <xsl:template match="演:幻灯片集">
        <xsl:for-each select="演:幻灯片">
            <xsl:element name="draw:page">
                <xsl:attribute name="draw:name"><xsl:value-of select="@演:名称"/></xsl:attribute>
                <xsl:attribute name="draw:style-name"><xsl:value-of select="@演:标识符"/></xsl:attribute>
                <xsl:attribute name="draw:master-page-name"><xsl:value-of select="@演:母版引用"/></xsl:attribute>
                <xsl:if test="@演:页面版式引用">
                    <xsl:attribute name="presentation:presentation-page-layout-name"><xsl:value-of select="@演:页面版式引用"/></xsl:attribute>
                </xsl:if>
                <office:forms form:automatic-focus="false" form:apply-design-mode="false"/>
                <xsl:apply-templates select="uof:锚点"/>
                <xsl:apply-templates select="演:动画"/>
                <xsl:element name="presentation:notes">
                    <xsl:attribute name="draw:style-name">dp2</xsl:attribute>
                    <xsl:apply-templates select="./演:幻灯片备注/uof:锚点"/>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="演:动画">
        <xsl:element name="anim:par">
            <xsl:attribute name="presentation:node-type">timing-root</xsl:attribute>
            <anim:seq presentation:node-type="main-sequence">
                <xsl:for-each select="演:序列">
                    <anim:par begin="next">
                        <anim:par smil:begin="0s">
                            <xsl:variable name="animnodename">anim:par</xsl:variable>
                            <xsl:choose>
                                <xsl:when test="演:效果//演:其他">
                                    <xsl:copy-of select="演:效果//演:其他/*"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="{$animnodename}">
                                        <xsl:attribute name="smil:fill"><xsl:choose><xsl:when test="演:定时/@演:回卷='true'">remove</xsl:when><xsl:otherwise>hold</xsl:otherwise></xsl:choose></xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="演:增强/演:动画播放后/@演:播放后隐藏='true'">
                                                <xsl:attribute name="presentation:preset-property">Direction;Accelerate;Decelerate</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test=".//演:轮子">
                                                <xsl:attribute name="presentation:preset-property">Spokes</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="演:效果/演:强调/演:更改填充颜色">
                                                <xsl:attribute name="presentation:preset-property">FillColor;ColorStyle;Accelerate;Decelerate;AutoReverse</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="演:效果/演:强调/演:更改字体颜色">
                                                <xsl:attribute name="presentation:preset-property">CharColor;ColorStyle;Accelerate;Decelerate;AutoReverse</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="演:效果/演:强调/演:更改字号">
                                                <xsl:attribute name="presentation:preset-property">CharHeight</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="演:效果/演:强调/演:更改字形">
                                                <xsl:attribute name="presentation:preset-property">CharDecoration</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="演:效果/演:强调/演:陀螺旋">
                                                <xsl:attribute name="presentation:preset-property">Rotate;Accelerate;Decelerate;AutoReverse</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="演:效果/演:强调/演:透明">
                                                <xsl:attribute name="presentation:preset-property">Transparency</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="演:效果/演:强调/演:更改线条颜色">
                                                <xsl:attribute name="presentation:preset-property">LineColor;ColorStyle;Accelerate;Decelerate;AutoReverse</xsl:attribute>
                                            </xsl:when>
                                        </xsl:choose>
                                        <xsl:attribute name="presentation:node-type"><xsl:choose><xsl:when test="演:定时/@演:事件='on click'">on-click</xsl:when><xsl:otherwise><xsl:value-of select="演:定时/@演:事件"/></xsl:otherwise></xsl:choose></xsl:attribute>
                                        <xsl:attribute name="smil:begin"><xsl:value-of select="演:定时/@演:延时"/></xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="演:定时/@演:重复='until next click' ">
                                                <xsl:attribute name="smil:repeatCount">indefinite</xsl:attribute>
                                                <xsl:attribute name="smil:end">next</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="演:定时/@演:重复='until next slide' ">
                                                <xsl:attribute name="smil:repeatCount">indefinite</xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="演:定时/@演:重复 !='none'">
                                                <xsl:attribute name="smil:repeatCount"><xsl:value-of select="演:定时/@演:重复"/></xsl:attribute>
                                            </xsl:when>
                                        </xsl:choose>
                                        <xsl:if test="演:增强/演:动画文本/@演:发送">
                                            <xsl:attribute name="anim:iterate-type"><xsl:choose><xsl:when test="演:增强/演:动画文本/@演:发送='by word'">by-word</xsl:when><xsl:when test="演:增强/演:动画文本/@演:发送='by letter'">by-letter</xsl:when><xsl:otherwise>all at once</xsl:otherwise></xsl:choose></xsl:attribute>
                                        </xsl:if>
                                        <xsl:if test="演:增强/演:动画文本/@演:间隔">
                                            <xsl:attribute name="anim:iterate-interval"><xsl:value-of select="演:增强/演:动画文本/@演:间隔"/></xsl:attribute>
                                        </xsl:if>
                                        <xsl:if test="$animnodename='anim:iterate' ">
                                            <xsl:attribute name="anim:id"><xsl:value-of select="@演:动画对象"/></xsl:attribute>
                                        </xsl:if>
                                        <xsl:apply-templates select="演:效果"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </anim:par>
                    </anim:par>
                </xsl:for-each>
            </anim:seq>
        </xsl:element>
    </xsl:template>
    <xsl:template match="演:效果">
        <xsl:apply-templates select="演:进入 "/>
        <xsl:apply-templates select="演:强调"/>
        <xsl:apply-templates select="演:退出"/>
    </xsl:template>
    <xsl:template match="演:进入">
        <xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
        <xsl:apply-templates select="." mode="entrance"/>
    </xsl:template>
    <xsl:template match="演:强调">
        <xsl:attribute name="presentation:preset-class">emphasis</xsl:attribute>
        <xsl:apply-templates select="." mode="emphasis"/>
    </xsl:template>
    <xsl:template match="演:退出">
        <xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
        <xsl:apply-templates select="." mode="exit"/>
    </xsl:template>
    <xsl:template name="演速度">
        <xsl:choose>
            <xsl:when test="./@演:速度='very fast' ">0.5s</xsl:when>
            <xsl:when test="./@演:速度='fast'">1s</xsl:when>
            <xsl:when test="./@演:速度='medium'">2s</xsl:when>
            <xsl:when test="./@演:速度='slow'">3s</xsl:when>
            <xsl:when test="./@演:速度='very slow'">5s</xsl:when>
            <xsl:otherwise>1s</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="演:出现" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-appear</xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" anim:sub-item="text" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:盒状" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-box</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:方向"/></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.004s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:type="irisWipe" smil:subtype="rectangle" smil:direction="reverse">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:棋盘" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-checkerboard</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:方向='down'">downward</xsl:when><xsl:when test="@演:方向='across'">across</xsl:when></xsl:choose></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.004s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:dur="2s" anim:sub-item="text" smil:type="checkerBoardWipe" smil:subtype="down">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:圆形扩展" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-circle</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:方向"/></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:type="ellipseWipe" smil:subtype="horizontal" smil:direction="reverse">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:阶梯状" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-diagonal-squares</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:方向='left down'">left-to-bottom</xsl:when><xsl:when test="@演:方向='left up'">left-to-top</xsl:when><xsl:when test="@演:方向='right down'">right-to-bottom</xsl:when><xsl:when test="@演:方向='right up'">right-to-top</xsl:when></xsl:choose></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:type="waterfallWipe" smil:direction="reverse">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:方向='left down'">horizontalLeft</xsl:when><xsl:when test="@演:方向='left up'">horizontalLeft</xsl:when><xsl:when test="@演:方向='right down'">horizontalRight</xsl:when><xsl:when test="@演:方向='right up'">horizontalRight</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:菱形" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-diamond</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:方向"/></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:type="irisWipe" smil:subtype="diamond" smil:direction="reverse">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:内向溶解" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-dissolve-in</xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:type="dissolve" smil:direction="reverse">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:闪烁一次" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-flash-once</xsl:attribute>
        <anim:set smil:begin="0s" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:飞入" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-fly-in</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:方向= 'from bottom'">from-bottom</xsl:when><xsl:when test="@演:方向 = 'from top-right'">from-top-right</xsl:when><xsl:when test="@演:方向 = 'from top-left'">from-top-left</xsl:when><xsl:when test="@演:方向 = 'from bottom-left'">from-bottom-left</xsl:when><xsl:when test="@演:方向 = 'from bottom-right'">from-bottom-right</xsl:when><xsl:when test="@演:方向 = 'from right'">from-right</xsl:when><xsl:when test="@演:方向 = 'from left'">from-left</xsl:when><xsl:when test="@演:方向 = 'from top'">from-top</xsl:when></xsl:choose></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <xsl:variable name="smilvalueX">
            <xsl:choose>
                <xsl:when test="contains(@演:方向,'right')">1+width/2;x</xsl:when>
                <xsl:when test="contains(@演:方向,'left')">0-width/2;x</xsl:when>
                <xsl:otherwise>x;x</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="smilvalueY">
            <xsl:choose>
                <xsl:when test="contains(@演:方向,'bottom')">1+height/2;y</xsl:when>
                <xsl:when test="contains(@演:方向,'top')">0-height/2;y</xsl:when>
                <xsl:otherwise>y;y</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <anim:animate smil:fill="hold" smil:attributeName="x" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueX"/></xsl:attribute>
        </anim:animate>
        <anim:animate smil:fill="hold" smil:attributeName="y" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueY"/></xsl:attribute>
        </anim:animate>
    </xsl:template>
    <xsl:template match="演:缓慢飞入" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-fly-in-slow</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:方向= 'from bottom'">from-bottom</xsl:when><xsl:when test="@演:方向 = 'from right'">from-right</xsl:when><xsl:when test="@演:方向 = 'from left'">from-left</xsl:when><xsl:when test="@演:方向 = 'from top'">from-top</xsl:when></xsl:choose></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <xsl:variable name="smilvalueX">
            <xsl:choose>
                <xsl:when test="contains(@演:方向,'right')">1+width/2;x</xsl:when>
                <xsl:when test="contains(@演:方向,'left')">0-width/2;x</xsl:when>
                <xsl:otherwise>x;x</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="smilvalueY">
            <xsl:choose>
                <xsl:when test="contains(@演:方向,'bottom')">1+height/2;y</xsl:when>
                <xsl:when test="contains(@演:方向,'top')">0-height/2;y</xsl:when>
                <xsl:otherwise>y;y</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <anim:animate smil:fill="hold" smil:attributeName="x" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueX"/></xsl:attribute>
        </anim:animate>
        <anim:animate smil:fill="hold" smil:attributeName="y" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueY"/></xsl:attribute>
        </anim:animate>
    </xsl:template>
    <xsl:template match="演:切入" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-peek-in</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:方向= 'from bottom'">from-bottom</xsl:when><xsl:when test="@演:方向 = 'from right'">from-right</xsl:when><xsl:when test="@演:方向 = 'from left'">from-left</xsl:when><xsl:when test="@演:方向 = 'from top'">from-top</xsl:when></xsl:choose></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:type="slideWipe" smil:direction="reverse">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:方向= 'from bottom'">fromBottom</xsl:when><xsl:when test="@演:方向 = 'from right'">fromRight</xsl:when><xsl:when test="@演:方向 = 'from left'">fromLeft</xsl:when><xsl:when test="@演:方向 = 'from top'">fromTop</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:十字形扩展" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-plus</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:方向"/></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.00025s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:type="fourBoxWipe" smil:direction="reverse">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:方向= 'in'">cornersIn</xsl:when><xsl:when test="@演:方向 = 'out'">cornersOut</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:随机线条" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-bars</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:方向"/></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:type="randomBarWipe" smil:direction="reverse">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:方向= 'horizontal'">vertical</xsl:when><xsl:when test="@演:方向 = 'vertical'">horizontal</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:劈裂" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-split</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:方向 = 'horizontal out'">horizontal-out</xsl:when><xsl:when test="@演:方向= 'horizontal in'">horizontal-in</xsl:when><xsl:when test="@演:方向= 'vertical in'">vertical-in</xsl:when><xsl:when test="@演:方向= 'vertical out'">vertical-out</xsl:when></xsl:choose></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:dur="0.5s" smil:type="barnDoorWipe">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:方向 = 'horizontal out'">horizontal</xsl:when><xsl:when test="@演:方向= 'horizontal in'">horizontal</xsl:when><xsl:when test="@演:方向= 'vertical in'">vertical</xsl:when><xsl:when test="@演:方向= 'vertical out'">vertical</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:百叶窗" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-venetian-blinds</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:方向"/></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:type="blindsWipe" smil:direction="reverse">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:方向= 'horizontal'">vertical</xsl:when><xsl:when test="@演:方向 = 'vertical'">horizontal</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:扇形展开" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-wedge</xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.0015s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:type="fanWipe" smil:subtype="centerTop">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:轮子" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-wheel</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:辐射状"/></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.00025s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:dur="0.5s" smil:type="pinWheelWipe">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:辐射状='1'">oneBlade</xsl:when><xsl:when test="@演:辐射状='2'">twoBlade</xsl:when><xsl:when test="@演:辐射状='3'">threeBlade</xsl:when><xsl:when test="@演:辐射状='4'">fourBlade</xsl:when><xsl:when test="@演:辐射状='8'">eightBlade</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:擦除" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-wipe</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:速度 = 'from right'">from-right</xsl:when><xsl:when test="@演:速度 = 'from left'">from-left</xsl:when><xsl:when test="@演:速度 = 'from top'">from-top</xsl:when><xsl:when test="@演:速度 = 'from bottom'">from-bottom</xsl:when><xsl:otherwise>from-left</xsl:otherwise></xsl:choose></xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.006s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:transitionFilter smil:type="barWipe" smil:subtype="leftToRight" smil:direction="reverse">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="(@演:速度 = 'from right') or (@演:速度 = 'from left')">leftToRight</xsl:when><xsl:when test="(@演:速度 = 'from top') or (@演:速度 = 'from bottom')">topToBottom</xsl:when><xsl:otherwise>leftToRight</xsl:otherwise></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="演:随机效果" mode="entrance">
        <xsl:attribute name="presentation:preset-id">ooo-entrance-random</xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
        <anim:animate smil:dur="1s" smil:fill="hold" smil:attributeName="width" smil:values="0;width" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
        </anim:animate>
        <anim:animate smil:fill="hold" smil:attributeName="height" smil:values="0;height" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
        </anim:animate>
        <anim:animate smil:fill="hold" smil:attributeName="rotate" smil:values="90;0" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
        </anim:animate>
        <anim:transitionFilter smil:type="fade" smil:subtype="crossfade">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
        </anim:transitionFilter>
    </xsl:template>
    <xsl:template match="更改填充颜色" mode="emphasis">
        <xsl:attribute name="presentation:preset-id">ooo-emphasis-fill-color</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type">2</xsl:attribute>
        <anim:animateColor smil:fill="hold" smil:attributeName="fill-color" presentation:additive="base" anim:color-interpolation="rgb" anim:color-interpolation-direction="clockwise">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:to"><xsl:value-of select="@演:颜色"/></xsl:attribute>
        </anim:animateColor>
        <anim:set smil:dur="0.5s" smil:fill="hold" smil:attributeName="fill" smil:to="solid">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="更改字体颜色" mode="emphasis">
        <xsl:attribute name="presentation:preset-id">ooo-emphasis-font-color</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type">2</xsl:attribute>
        <anim:animateColor smil:fill="hold" smil:attributeName="fill-color" presentation:additive="base" anim:color-interpolation="rgb" anim:color-interpolation-direction="clockwise">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:to"><xsl:value-of select="@演:颜色"/></xsl:attribute>
        </anim:animateColor>
    </xsl:template>
    <xsl:template match="演:更改字号" mode="emphasis">
        <xsl:attribute name="presentation:preset-id">ooo-emphasis-font-size</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type">2</xsl:attribute>
        <anim:animate smil:fill="hold" smil:attributeName="font-size" presentation:additive="base">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:to"><xsl:choose><xsl:when test="@演:预定义尺寸='tiny' ">0.25,1</xsl:when><xsl:when test="@演:预定义尺寸='smaller' ">0.5,1</xsl:when><xsl:when test="@演:预定义尺寸='larger' ">1.5,1</xsl:when><xsl:when test="@演:预定义尺寸='huge' ">4,1</xsl:when><xsl:when test="@演:自定义尺寸"><xsl:value-of select="@演:自定义尺寸"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute>
        </anim:animate>
    </xsl:template>
    <xsl:template name="emp_font_style">
        <xsl:param name="fontstyle"/>
        <xsl:choose>
            <xsl:when test="contains($fontstyle,' ')">
                <anim:set smil:dur="indefinite" smil:attributeName="font-style">
                    <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
                    <xsl:attribute name="smil:to"><xsl:value-of select="substring-before($fontstyle,' ')"/></xsl:attribute>
                </anim:set>
                <xsl:variable name="fontstyle1">
                    <xsl:choose>
                        <xsl:when test="contains($fontstyle,' ')">
                            <xsl:value-of select="substring-after($fontstyle,' ')"/>
                        </xsl:when>
                        <xsl:when test="not($fontstyle=' ')">
                            <xsl:value-of select="$fontstyle"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="emp_font_style">
                    <xsl:with-param name="fontstyle">
                        <xsl:value-of select="$fontstyle1"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="演:更改字形" mode="emphasis">
        <xsl:attribute name="presentation:preset-id">ooo-emphasis-font-style</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type">1</xsl:attribute>
        <xsl:call-template name="emp_font_style">
            <xsl:with-param name="fontstyle">
                <xsl:value-of select="@演:字形"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="演:更改线条颜色" mode="emphasis">
        <xsl:attribute name="presentation:preset-id">ooo-emphasis-line-color</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type">2</xsl:attribute>
        <anim:animateColor smil:dur="0s" smil:fill="hold" smil:attributeName="stroke-color" presentation:additive="base" anim:color-interpolation="rgb" anim:color-interpolation-direction="clockwise">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:to"><xsl:value-of select="@演:颜色"/></xsl:attribute>
        </anim:animateColor>
        <anim:set smil:dur="0s" smil:fill="hold" anim:sub-item="text" smil:attributeName="stroke" smil:to="solid">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:陀螺旋" mode="emphasis">
        <xsl:attribute name="presentation:preset-id">ooo-emphasis-spin</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type">2</xsl:attribute>
        <anim:animateTransform smil:fill="hold" smil:by="180" presentation:additive="base" svg:type="rotate">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:by"><xsl:choose><xsl:when test="@演:预定义角度='quarter spin'">90</xsl:when><xsl:when test="@演:预定义角度='half spin'">180</xsl:when><xsl:when test="@演:预定义角度='full spin'">360</xsl:when><xsl:when test="@演:预定义角度='two spins'">720   </xsl:when><xsl:when test="@演:自定义角度"><xsl:value-of select="@演:自定义角度"/></xsl:when></xsl:choose></xsl:attribute>
        </anim:animateTransform>
    </xsl:template>
    <xsl:template match="演:透明" mode="emphasis">
        <xsl:attribute name="presentation:preset-id">ooo-emphasis-transparency</xsl:attribute>
        <xsl:attribute name="smil:repeatCount"><xsl:choose><xsl:when test="(@演:期间 = 'until next click') or (@演:期间 ='until next slide') ">indefinite</xsl:when><xsl:when test="@演:期间='2' or @演:期间 ='3' or @演:期间 ='4' or @演:期间 ='5' or @演:期间 ='10'"><xsl:value-of select="@演:期间"/></xsl:when><xsl:otherwise>2</xsl:otherwise></xsl:choose></xsl:attribute>
        <anim:set smil:dur="indefinite" anim:sub-item="text" smil:attributeName="opacity">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:to"><xsl:choose><xsl:when test="@演:预定义透明度='25' ">0.25</xsl:when><xsl:when test="@演:预定义透明度='50' ">0.5</xsl:when><xsl:when test="@演:预定义透明度='75' ">0.75</xsl:when><xsl:when test="@演:预定义透明度='100' ">1</xsl:when><xsl:when test="@演:自定义透明度"><xsl:value-of select="@演:自定义透明度"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:缩放" mode="emphasis">
        <xsl:attribute name="presentation:preset-id">ooo-emphasis-grow-and-shrink</xsl:attribute>
        <anim:animateTransform smil:fill="hold" anim:sub-item="text" presentation:additive="base" svg:type="scale">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:to"><xsl:choose><xsl:when test="@演:预定义尺寸='tiny' ">0.25,1</xsl:when><xsl:when test="@演:预定义尺寸='smaller' ">0.5,1</xsl:when><xsl:when test="@演:预定义尺寸='larger' ">1.5,1</xsl:when><xsl:when test="@演:预定义尺寸='huge' ">4,1</xsl:when><xsl:when test="@演:自定义尺寸"><xsl:value-of select="@演:自定义尺寸"/></xsl:when><xsl:otherwise>0.5,1</xsl:otherwise></xsl:choose></xsl:attribute>
        </anim:animateTransform>
    </xsl:template>
    <xsl:template match="演:盒状" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-box</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:方向"/></xsl:attribute>
        <anim:transitionFilter smil:type="irisWipe" smil:subtype="rectangle" smil:direction="reverse" smil:mode="out">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.004s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:棋盘" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-checkerboard</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:方向='down'">downward</xsl:when><xsl:when test="@演:方向='across'">across</xsl:when></xsl:choose></xsl:attribute>
        <anim:transitionFilter smil:dur="2s" anim:sub-item="text" smil:type="checkerBoardWipe" smil:subtype="down" smil:mode="out">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.004s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:圆形扩展" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-circle</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:方向"/></xsl:attribute>
        <anim:transitionFilter smil:type="ellipseWipe" smil:subtype="horizontal" smil:direction="reverse" smil:mode="out">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:阶梯状" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-diagonal-squares</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:方向='left down'">left-to-bottom</xsl:when><xsl:when test="@演:方向='left up'">left-to-top</xsl:when><xsl:when test="@演:方向='right down'">right-to-bottom</xsl:when><xsl:when test="@演:方向='right up'">right-to-top</xsl:when></xsl:choose></xsl:attribute>
        <anim:transitionFilter smil:type="waterfallWipe" smil:direction="reverse" smil:mode="out">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:方向='left down'">horizontalLeft</xsl:when><xsl:when test="@演:方向='left up'">horizontalLeft</xsl:when><xsl:when test="@演:方向='right down'">horizontalRight</xsl:when><xsl:when test="@演:方向='right up'">horizontalRight</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:菱形" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-diamond</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:方向"/></xsl:attribute>
        <anim:transitionFilter smil:type="irisWipe" smil:subtype="diamond" smil:direction="reverse" smil:mode="out">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:消失" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-disappear</xsl:attribute>
        <anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" anim:sub-item="text" smil:attributeName="visibility" smil:to="visible">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:向外溶解" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-dissolve</xsl:attribute>
        <anim:transitionFilter smil:type="dissolve" smil:direction="reverse" smil:mode="out">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:闪烁一次" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-flash-once</xsl:attribute>
        <anim:animate smil:attributeName="visibility" smil:values="hidden;visible" smil:keyTimes="0;0.5" smil:calcMode="discrete" presentation:additive="base">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:animate>
        <anim:set smil:dur="0s" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:飞出" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-fly-out</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:方向= 'to bottom'">from-bottom</xsl:when><xsl:when test="@演:方向 = 'to top-right'">from-top-right</xsl:when><xsl:when test="@演:方向 = 'to top-left'">from-top-left</xsl:when><xsl:when test="@演:方向 = 'to bottom-left'">from-bottom-left</xsl:when><xsl:when test="@演:方向 = 'to bottom-right'">from-bottom-right</xsl:when><xsl:when test="@演:方向 = 'to right'">from-right</xsl:when><xsl:when test="@演:方向 = 'to left'">from-left</xsl:when><xsl:when test="@演:方向 = 'to top'">from-top</xsl:when></xsl:choose></xsl:attribute>
        <xsl:variable name="smilvalueX">
            <xsl:choose>
                <xsl:when test="contains(@演:方向,'right')">x;1+width/2</xsl:when>
                <xsl:when test="contains(@演:方向,'left')">x;0-width/2</xsl:when>
                <xsl:otherwise>x;x</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="smilvalueY">
            <xsl:choose>
                <xsl:when test="contains(@演:方向,'bottom')">y;1+height/2</xsl:when>
                <xsl:when test="contains(@演:方向,'top')">y;0-height/2</xsl:when>
                <xsl:otherwise>y;y</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <anim:animate smil:fill="hold" smil:attributeName="x" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueX"/></xsl:attribute>
        </anim:animate>
        <anim:animate smil:fill="hold" smil:attributeName="y" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueY"/></xsl:attribute>
        </anim:animate>
        <anim:set smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:缓慢移出" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-crawl-out</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:方向= 'to bottom'">from-bottom</xsl:when><xsl:when test="@演:方向 = 'to right'">from-right</xsl:when><xsl:when test="@演:方向 = 'to left'">from-left</xsl:when><xsl:when test="@演:方向 = 'to top'">from-top</xsl:when></xsl:choose></xsl:attribute>
        <xsl:variable name="smilvalueX">
            <xsl:choose>
                <xsl:when test="contains(@演:方向,'right')">x;1+width/2</xsl:when>
                <xsl:when test="contains(@演:方向,'left')">x;0-width/2</xsl:when>
                <xsl:otherwise>x;x</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="smilvalueY">
            <xsl:choose>
                <xsl:when test="contains(@演:方向,'bottom')">y;1+height/2</xsl:when>
                <xsl:when test="contains(@演:方向,'top')">y;0-height/2</xsl:when>
                <xsl:otherwise>y;y</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <anim:animate smil:fill="hold" smil:attributeName="x" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueX"/></xsl:attribute>
        </anim:animate>
        <anim:animate smil:fill="hold" smil:attributeName="y" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueY"/></xsl:attribute>
        </anim:animate>
        <anim:set smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:切出" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-peek-out</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:方向= 'from bottom'">from-bottom</xsl:when><xsl:when test="@演:方向 = 'from right'">from-right</xsl:when><xsl:when test="@演:方向 = 'from left'">from-left</xsl:when><xsl:when test="@演:方向 = 'from top'">from-top</xsl:when></xsl:choose></xsl:attribute>
        <anim:transitionFilter smil:type="slideWipe" smil:direction="reverse" smil:mode="out">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:方向= 'from bottom'">fromBottom</xsl:when><xsl:when test="@演:方向 = 'from right'">fromRight</xsl:when><xsl:when test="@演:方向 = 'from left'">fromLeft</xsl:when><xsl:when test="@演:方向 = 'from top'">fromTop</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:十字形扩展" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-plus</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:方向"/></xsl:attribute>
        <anim:transitionFilter smil:type="fourBoxWipe" smil:direction="reverse" smil:mode="out">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:方向= 'in'">cornersIn</xsl:when><xsl:when test="@演:方向 = 'out'">cornersOut</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.00025s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:随机线条" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-random-bars</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:方向"/></xsl:attribute>
        <anim:transitionFilter smil:type="randomBarWipe" smil:direction="reverse" smil:mode="out">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:方向= 'horizontal'">vertical</xsl:when><xsl:when test="@演:方向 = 'vertical'">horizontal</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:劈裂" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-split</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:方向 = 'horizontal out'">horizontal-out</xsl:when><xsl:when test="@演:方向= 'horizontal in'">horizontal-in</xsl:when><xsl:when test="@演:方向= 'vertical in'">vertical-in</xsl:when><xsl:when test="@演:方向= 'vertical out'">vertical-out</xsl:when></xsl:choose></xsl:attribute>
        <anim:transitionFilter smil:dur="0.5s" smil:type="barnDoorWipe" smil:mode="out">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:方向 = 'horizontal out'">horizontal</xsl:when><xsl:when test="@演:方向= 'horizontal in'">horizontal</xsl:when><xsl:when test="@演:方向= 'vertical in'">vertical</xsl:when><xsl:when test="@演:方向= 'vertical out'">vertical</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:百叶窗" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-venetian-blinds</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:方向"/></xsl:attribute>
        <anim:transitionFilter smil:type="blindsWipe" smil:direction="reverse" smil:mode="out">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:方向= 'horizontal'">vertical</xsl:when><xsl:when test="@演:方向 = 'vertical'">horizontal</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:扇形展开" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-wedge</xsl:attribute>
        <anim:transitionFilter smil:type="fanWipe" smil:subtype="centerTop" smil:mode="out">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.0015s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:轮子" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-wheel</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:value-of select="@演:辐射状"/></xsl:attribute>
        <anim:transitionFilter smil:dur="0.5s" smil:type="pinWheelWipe" smil:mode="out">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@演:辐射状='1'">oneBlade</xsl:when><xsl:when test="@演:辐射状='2'">twoBlade</xsl:when><xsl:when test="@演:辐射状='3'">threeBlade</xsl:when><xsl:when test="@演:辐射状='4'">fourBlade</xsl:when><xsl:when test="@演:辐射状='8'">eightBlade</xsl:when></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.00025s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:擦除" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-wipe</xsl:attribute>
        <xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@演:速度 = 'from right'">from-right</xsl:when><xsl:when test="@演:速度 = 'from left'">from-left</xsl:when><xsl:when test="@演:速度 = 'from top'">from-top</xsl:when><xsl:when test="@演:速度 = 'from bottom'">from-bottom</xsl:when><xsl:otherwise>from-left</xsl:otherwise></xsl:choose></xsl:attribute>
        <anim:transitionFilter smil:type="barWipe" smil:subtype="leftToRight" smil:direction="reverse" smil:mode="out">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="(@演:速度 = 'from right') or (@演:速度 = 'from left')">leftToRight</xsl:when><xsl:when test="(@演:速度 = 'from top') or (@演:速度 = 'from bottom')">topToBottom</xsl:when><xsl:otherwise>leftToRight</xsl:otherwise></xsl:choose></xsl:attribute>
        </anim:transitionFilter>
        <anim:set smil:dur="0.006s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="演:随机效果" mode="exit">
        <xsl:attribute name="presentation:preset-id">ooo-exit-random</xsl:attribute>
        <anim:transitionFilter smil:type="fade" smil:subtype="crossfade" smil:mode="out">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:transitionFilter>
        <anim:animate smil:attributeName="x" smil:values="x;x" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:animate>
        <anim:animate smil:dur="0.1s" smil:decelerate="1" smil:attributeName="y" smil:values="y;y-.03" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:animate>
        <anim:animate smil:begin="0.1s" smil:dur="0.9s" smil:accelerate="1" smil:attributeName="y" smil:values="y;y+1" smil:keyTimes="0;1" presentation:additive="base">
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:animate>
        <anim:set smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
            <xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
            <xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列/@演:动画对象"/></xsl:attribute>
        </anim:set>
    </xsl:template>
    <xsl:template match="uof:锚点" name="图形解析">
        <xsl:variable name="tuxing1" select="@uof:图形引用"/>
        <xsl:choose>
            <xsl:when test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]">
                <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:公共类型='png' or /uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:公共类型='jpg' or /uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:公共类型='bmp' or /uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:公共类型='gif'">
                    <xsl:element name="draw:frame">
                        <xsl:attribute name="draw:name"><xsl:variable name="pos"><xsl:value-of select="count(preceding::uof:锚点)"/></xsl:variable><xsl:value-of select="concat('图形',$pos)"/></xsl:attribute>
                        <xsl:attribute name="presentation:class">graphic</xsl:attribute>
                        <xsl:attribute name="presentation:user-transformed">true</xsl:attribute>
                        <xsl:attribute name="svg:x"><xsl:value-of select="concat(@uof:x坐标,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="svg:y"><xsl:value-of select="concat(@uof:y坐标,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="svg:width"><xsl:value-of select="concat(@uof:宽度,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="svg:height"><xsl:value-of select="concat(@uof:高度,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="draw:layer">layout</xsl:attribute>
                        <xsl:if test="../演:动画/演:序列/@演:动画对象=$tuxing1">
                            <xsl:attribute name="draw:id"><xsl:value-of select="$tuxing1"/></xsl:attribute>
                        </xsl:if>
                        <draw:image>
                            <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:路径">
                                <xsl:attribute name="xlink:href"><xsl:value-of select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:路径"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:路径">
                                <xsl:attribute name="xlink:href"><xsl:value-of select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:路径"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:数据">
                                <office:binary-data>
                                    <xsl:value-of select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:数据"/>
                                </office:binary-data>
                            </xsl:if>
                        </draw:image>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="graph">
                    <xsl:with-param name="id" select="/uof:UOF/uof:对象集/图:图形[@图:标识符=$tuxing1]"/>
                    <xsl:with-param name="groupx" select="0"/>
                    <xsl:with-param name="groupy" select="0"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="graph">
        <xsl:param name="id"/>
        <xsl:param name="groupx"/>
        <xsl:param name="groupy"/>
        <xsl:for-each select="$id">
            <xsl:variable name="tuxing1">
                <xsl:value-of select="图:预定义图形/图:类别"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$tuxing1='11'">
                    <xsl:call-template name="Rectangle">
                        <xsl:with-param name="groupx1" select="$groupx"/>
                        <xsl:with-param name="groupy1" select="$groupy"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$tuxing1='19'">
                    <xsl:call-template name="Oval">
                        <xsl:with-param name="groupx1" select="$groupx"/>
                        <xsl:with-param name="groupy1" select="$groupy"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$tuxing1='61'">
                    <xsl:call-template name="Line">
                        <xsl:with-param name="groupx1" select="$groupx"/>
                        <xsl:with-param name="groupy1" select="$groupy"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$tuxing1='64'">
                    <xsl:call-template name="Curve">
                        <xsl:with-param name="groupx1" select="$groupx"/>
                        <xsl:with-param name="groupy1" select="$groupy"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$tuxing1='65'">
                    <xsl:call-template name="Freeform">
                        <xsl:with-param name="groupx1" select="$groupx"/>
                        <xsl:with-param name="groupy1" select="$groupy"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$tuxing1='66'">
                    <xsl:call-template name="Scribble">
                        <xsl:with-param name="groupx1" select="$groupx"/>
                        <xsl:with-param name="groupy1" select="$groupy"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$tuxing1='3'">
                    <xsl:call-template name="演文本框"/>
                </xsl:when>
                <xsl:when test="$tuxing1='67'">
                    <xsl:call-template name="演缩略图"/>
                </xsl:when>
                <xsl:when test="$tuxing1='4'">
                    <xsl:element name="draw:g">
                        <xsl:variable name="tu">
                            <xsl:value-of select="@图:标识符"/>
                        </xsl:variable>
                        <xsl:attribute name="draw:style-name"><xsl:value-of select="$tu"/></xsl:attribute>
                        <xsl:attribute name="draw:z-index"><xsl:value-of select="@图:层次"/></xsl:attribute>
                        <xsl:variable name="this-group-x">
                            <xsl:value-of select="key('rel_graphic_name',@图:标识符)/@uof:x坐标"/>
                        </xsl:variable>
                        <xsl:variable name="this-group-y">
                            <xsl:value-of select="key('rel_graphic_name',@图:标识符)/uof:y坐标"/>
                        </xsl:variable>
                        <xsl:variable name="group-x">
                            <xsl:value-of select="number($groupx + $this-group-x)"/>
                        </xsl:variable>
                        <xsl:variable name="group-y">
                            <xsl:value-of select="number($groupy + $this-group-y)"/>
                        </xsl:variable>
                        <xsl:call-template name="组合图形">
                            <xsl:with-param name="zuheliebiao" select="@图:组合列表"/>
                            <xsl:with-param name="groupx1" select="$group-x"/>
                            <xsl:with-param name="groupy1" select="$group-y"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="common">
        <xsl:param name="groupx"/>
        <xsl:param name="groupy"/>
        <xsl:variable name="tuxing">
            <xsl:value-of select="@图:标识符"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="key('rel_graphic_name',@图:标识符)">
                <xsl:for-each select="key('rel_graphic_name',@图:标识符)">
                    <xsl:attribute name="svg:x"><xsl:value-of select="concat(@uof:x坐标,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="svg:y"><xsl:value-of select="concat(@uof:y坐标,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="svg:width"><xsl:value-of select="concat(@uof:宽度,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="svg:height"><xsl:value-of select="concat(@uof:高度,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="draw:layer"><xsl:choose><xsl:when test="parent::演:母版">backgroundobjects</xsl:when><xsl:otherwise>layout</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:if test="../演:动画/演:序列/@演:动画对象=$tuxing">
                        <xsl:attribute name="draw:id"><xsl:value-of select="$tuxing"/></xsl:attribute>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="zuheweizhi-x">
                    <xsl:value-of select="图:组合位置/@图:x坐标"/>
                </xsl:variable>
                <xsl:variable name="zuheweizhi-y">
                    <xsl:value-of select="图:组合位置/@图:y坐标"/>
                </xsl:variable>
                <xsl:attribute name="text:anchor-type">paragraph</xsl:attribute>
                <xsl:attribute name="svg:x"><xsl:value-of select="concat(($groupx + $zuheweizhi-x),$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="svg:y"><xsl:value-of select="concat(($groupy + $zuheweizhi-y),$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="svg:width"><xsl:value-of select="concat(图:预定义图形 /图:属性/图:宽度,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="svg:height"><xsl:value-of select="concat(图:预定义图形/图:属性 /图:高度,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="draw:layer">layout</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:attribute name="draw:style-name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
        <xsl:attribute name="draw:z-index"><xsl:value-of select="@图:层次"/></xsl:attribute>
        <xsl:if test="图:预定义图形/图:属性/图:旋转角度 and not(图:预定义图形/图:属性/图:旋转角度='0.0')">
            <xsl:variable name="rotate-angle">
                <xsl:value-of select="(图:预定义图形/图:属性/图:旋转角度 * 2 * 3.14159265 ) div 360"/>
            </xsl:variable>
            <xsl:attribute name="draw:transform"><xsl:value-of select="concat('rotate (',$rotate-angle,') translate (-0.0194027777777778cm 3.317875cm)')"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="图:文本内容">
            <xsl:apply-templates select="图:文本内容/字:段落"/>
            <xsl:apply-templates select="图:文本内容/字:文字表"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="组合图形">
        <xsl:param name="zuheliebiao"/>
        <xsl:param name="groupx1"/>
        <xsl:param name="groupy1"/>
        <xsl:variable name="x">
            <xsl:value-of select="$groupx1"/>
        </xsl:variable>
        <xsl:variable name="y">
            <xsl:value-of select="$groupy1"/>
        </xsl:variable>
        <xsl:variable name="first-pictures">
            <xsl:value-of select="substring-before($zuheliebiao,',')"/>
        </xsl:variable>
        <xsl:variable name="other-pictures">
            <xsl:value-of select="substring-after($zuheliebiao,',')"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($other-pictures,',')">
                <xsl:call-template name="graph">
                    <xsl:with-param name="id" select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $first-pictures]"/>
                    <xsl:with-param name="groupx" select="$groupx1"/>
                    <xsl:with-param name="groupy" select="$groupy1"/>
                </xsl:call-template>
                <xsl:call-template name="组合图形">
                    <xsl:with-param name="zuheliebiao" select="$other-pictures"/>
                    <xsl:with-param name="groupx1" select="$x"/>
                    <xsl:with-param name="groupy1" select="$y"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="graph">
                    <xsl:with-param name="id" select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $first-pictures]"/>
                    <xsl:with-param name="groupx" select="$groupx1"/>
                    <xsl:with-param name="groupy" select="$groupy1"/>
                </xsl:call-template>
                <xsl:call-template name="graph">
                    <xsl:with-param name="id" select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $other-pictures]"/>
                    <xsl:with-param name="groupx" select="$groupx1"/>
                    <xsl:with-param name="groupy" select="$groupy1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Curve">
        <xsl:param name="groupx1"/>
        <xsl:param name="groupy1"/>
        <xsl:element name="draw:path">
            <xsl:variable name="width" select="number(图:预定义图形/图:属性/图:宽度)*1000"/>
            <xsl:variable name="height" select="number(图:预定义图形/图:属性/图:高度)*1000"/>
            <xsl:attribute name="svg:viewBox"><xsl:value-of select="concat('0 0 ',$width, ' ',$height)"/></xsl:attribute>
            <xsl:attribute name="svg:d"><xsl:value-of select="图:预定义图形/图:关键点坐标/@图:路径"/></xsl:attribute>
            <xsl:call-template name="common">
                <xsl:with-param name="groupx" select="$groupx1"/>
                <xsl:with-param name="groupy" select="$groupy1"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template name="Freeform">
        <xsl:param name="groupx1"/>
        <xsl:param name="groupy1"/>
        <xsl:element name="draw:polygon">
            <xsl:variable name="width" select="number(图:预定义图形/图:属性/图:宽度)*1000"/>
            <xsl:variable name="height" select="number(图:预定义图形/图:属性/图:高度)*1000"/>
            <xsl:attribute name="svg:viewBox"><xsl:value-of select="concat('0 0 ',$width, ' ',$height)"/></xsl:attribute>
            <xsl:attribute name="draw:points"><xsl:call-template name="drawpoints"><xsl:with-param name="points" select="图:预定义图形/图:关键点坐标/@图:路径"/><xsl:with-param name="value"/></xsl:call-template></xsl:attribute>
            <xsl:call-template name="common">
                <xsl:with-param name="groupx" select="$groupx1"/>
                <xsl:with-param name="groupy" select="$groupy1"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template name="Scribble">
        <xsl:param name="groupx1"/>
        <xsl:param name="groupy1"/>
        <xsl:element name="draw:polyline">
            <xsl:variable name="width" select="number(图:预定义图形/图:属性/图:宽度)*1000"/>
            <xsl:variable name="height" select="number(图:预定义图形/图:属性/图:高度)*1000"/>
            <xsl:attribute name="svg:viewBox"><xsl:value-of select="concat('0 0 ',$width, ' ',$height)"/></xsl:attribute>
            <xsl:attribute name="draw:points"><xsl:call-template name="drawpoints"><xsl:with-param name="points" select="图:预定义图形/图:关键点坐标/@图:路径"/><xsl:with-param name="value"/></xsl:call-template></xsl:attribute>
            <xsl:call-template name="common">
                <xsl:with-param name="groupx" select="$groupx1"/>
                <xsl:with-param name="groupy" select="$groupy1"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template name="drawpoints">
        <xsl:param name="points"/>
        <xsl:param name="value"/>
        <xsl:variable name="frist-piont">
            <xsl:value-of select="substring-before($points,'lineto')"/>
        </xsl:variable>
        <xsl:variable name="other-points">
            <xsl:value-of select="substring-after($points,'lineto')"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($other-points,'lineto')">
                <xsl:variable name="x-coor">
                    <xsl:value-of select="substring-before($frist-piont,' ') * 1000"/>
                </xsl:variable>
                <xsl:variable name="y-coor">
                    <xsl:value-of select="substring-after($frist-piont,' ') * 1000"/>
                </xsl:variable>
                <xsl:variable name="all-points">
                    <xsl:value-of select="concat($value,$x-coor,',',$y-coor,' ')"/>
                </xsl:variable>
                <xsl:call-template name="drawpoints">
                    <xsl:with-param name="points" select="$other-points"/>
                    <xsl:with-param name="value" select="$all-points"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="q-x-coor">
                    <xsl:value-of select="substring-before($frist-piont,' ') * 1000"/>
                </xsl:variable>
                <xsl:variable name="q-y-coor">
                    <xsl:value-of select="substring-after($frist-piont,' ') * 1000"/>
                </xsl:variable>
                <xsl:variable name="e-x-coor">
                    <xsl:value-of select="substring-before($other-points,' ') * 1000"/>
                </xsl:variable>
                <xsl:variable name="e-y-coor">
                    <xsl:value-of select="substring-after($other-points,' ') * 1000"/>
                </xsl:variable>
                <xsl:value-of select="concat($value,$q-x-coor,',',$q-y-coor,' ',$e-x-coor,',',$e-y-coor)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Oval">
        <xsl:param name="groupx1"/>
        <xsl:param name="groupy1"/>
        <xsl:element name="draw:ellipse">
            <xsl:call-template name="common">
                <xsl:with-param name="groupx" select="$groupx1"/>
                <xsl:with-param name="groupy" select="$groupy1"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template name="Rectangle">
        <xsl:param name="groupx1"/>
        <xsl:param name="groupy1"/>
        <xsl:element name="draw:rect">
            <xsl:call-template name="common">
                <xsl:with-param name="groupx" select="$groupx1"/>
                <xsl:with-param name="groupy" select="$groupy1"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template name="Line">
        <xsl:param name="groupx1"/>
        <xsl:param name="groupy1"/>
        <xsl:element name="draw:line">
            <xsl:variable name="tuxing1" select="@图:标识符"/>
            <xsl:choose>
                <xsl:when test="key('rel_graphic_name',@图:标识符)">
                    <xsl:for-each select="key('rel_graphic_name',@图:标识符)">
                        <xsl:attribute name="svg:x1"><xsl:value-of select="concat(@uof:x坐标,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="svg:y1"><xsl:value-of select="concat(@uof:y坐标,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="svg:x2"><xsl:value-of select="concat((@uof:x坐标 + @uof:宽度),$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="svg:y2"><xsl:value-of select="concat((@uof:y坐标 + @uof:高度),$uofUnit)"/></xsl:attribute>
                        <xsl:if test="../演:动画/演:序列/@演:动画对象=$tuxing1">
                            <xsl:attribute name="draw:id"><xsl:value-of select="$tuxing1"/></xsl:attribute>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="zuheweizhi-x">
                        <xsl:value-of select="图:组合位置/@图:x坐标"/>
                    </xsl:variable>
                    <xsl:variable name="zuheweizhi-y">
                        <xsl:value-of select="图:组合位置/@图:y坐标"/>
                    </xsl:variable>
                    <xsl:variable name="hex">
                        <xsl:value-of select="concat(number($groupx1 + $zuheweizhi-x),$uofUnit)"/>
                    </xsl:variable>
                    <xsl:variable name="hey">
                        <xsl:value-of select="concat(number($groupy1 + $zuheweizhi-y),$uofUnit)"/>
                    </xsl:variable>
                    <xsl:attribute name="svg:x1"><xsl:value-of select="$hex"/></xsl:attribute>
                    <xsl:attribute name="svg:y1"><xsl:value-of select="$hey"/></xsl:attribute>
                    <xsl:attribute name="svg:x2"><xsl:value-of select="concat(($hex + 图:预定义图形/图:属性/图:宽度),$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="svg:y2"><xsl:value-of select="concat(($hey + 图:预定义图形/图:属性/图:高度),$uofUnit)"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="text:anchor-type">paragraph</xsl:attribute>
            <xsl:attribute name="draw:style-name"><xsl:value-of select="$tuxing1"/></xsl:attribute>
            <xsl:attribute name="draw:z-index"><xsl:value-of select="@图:层次"/></xsl:attribute>
            <xsl:if test="图:预定义图形/图:属性/图:旋转角度 and not(图:预定义图形/图:属性/图:旋转角度='0.0')">
                <xsl:variable name="rotate-angle">
                    <xsl:value-of select="(图:预定义图形/图:属性/图:旋转角度 *  2 * 3.14159265 ) div 360"/>
                </xsl:variable>
                <xsl:attribute name="draw:transform"><xsl:value-of select="concat('rotate (',$rotate-angle,') translate (-0.0194027777777778cm 3.317875cm)')"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="图:文本内容">
                <xsl:apply-templates select="图:文本内容/字:段落"/>
                <xsl:apply-templates select="图:文本内容/字:文字表"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="演文本框">
        <xsl:for-each select="key('rel_graphic_name',@图:标识符)">
            <xsl:variable name="tuxing1" select="@uof:图形引用"/>
            <xsl:element name="draw:frame">
                <xsl:attribute name="svg:x"><xsl:value-of select="concat(@uof:x坐标,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="svg:y"><xsl:value-of select="concat(@uof:y坐标,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="svg:width"><xsl:value-of select="concat(@uof:宽度,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="svg:height"><xsl:value-of select="concat(@uof:高度,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="draw:layer"><xsl:choose><xsl:when test="parent::演:母版">backgroundobjects</xsl:when><xsl:otherwise>layout</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:if test="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]/图:预定义图形/图:类别 = '3' and (parent::演:幻灯片/@演:配色方案引用) and not(@uof:占位符 = 'graphic')">
                    <xsl:attribute name="presentation:style-name"><xsl:value-of select="parent::演:幻灯片/@演:配色方案引用"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="../演:动画/演:序列/@演:动画对象=$tuxing1">
                    <xsl:attribute name="draw:id"><xsl:value-of select="$tuxing1"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="not(@uof:占位符 = 'graphic')">
                    <xsl:attribute name="presentation:style-name"><xsl:value-of select="@uof:图形引用"/></xsl:attribute>
                </xsl:if>
                <xsl:variable name="placeholdType">
                    <xsl:value-of select="@uof:占位符"/>
                </xsl:variable>
                <xsl:if test="@uof:占位符">
                    <xsl:attribute name="presentation:class"><xsl:choose><xsl:when test="@uof:占位符 = 'clipart'">graphic</xsl:when><xsl:when test="@uof:占位符 = 'media_clip'">graphic</xsl:when><xsl:when test="@uof:占位符 = 'graphics'">graphic</xsl:when><xsl:when test="@uof:占位符 = 'number'">page_number</xsl:when><xsl:when test="@uof:占位符 = 'centertitle'">title</xsl:when><xsl:when test="@uof:占位符 = 'date'">date-time</xsl:when><xsl:when test="@uof:占位符 = 'vertical_text'">vertical_outline</xsl:when><xsl:when test="@uof:占位符 = 'vertical_subtitle'">vertical_outline</xsl:when><xsl:otherwise><xsl:value-of select="@uof:占位符"/></xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
                <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]">
                    <xsl:variable name="leibie">
                        <xsl:value-of select="图:预定义图形/图:类别"/>
                    </xsl:variable>
                    <xsl:if test="图:预定义图形/图:属性/图:旋转角度 and not(图:预定义图形/图:属性/图:旋转角度='0.0')">
                        <xsl:variable name="rotate-angle">
                            <xsl:value-of select="(图:预定义图形/图:属性/图:旋转角度 *  2 * 3.14159265 ) div 360"/>
                        </xsl:variable>
                        <xsl:attribute name="draw:transform"><xsl:value-of select="concat('rotate (',$rotate-angle,') translate (-0.0194027777777778cm 3.317875cm)')"/></xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="图:文本内容 or @图:其他对象">
                            <xsl:attribute name="presentation:user-transformed">true</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="presentation:placeholder">true</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="$placeholdType = 'graphic' or  $placeholdType = 'clipart' or $placeholdType ='media_clip'">
                            <draw:image/>
                        </xsl:when>
                        <xsl:when test="$placeholdType = 'table' or $placeholdType = 'chart' or $placeholdType ='object'">
                            <draw:object/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="draw:text-box">
                                <xsl:apply-templates select="图:文本内容/字:段落"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="演缩略图">
        <draw:page-thumbnail>
            <xsl:call-template name="common"/>
            <xsl:attribute name="draw:layer">layout</xsl:attribute>
            <xsl:attribute name="draw:page-number"><xsl:for-each select="../.."><xsl:value-of select="count(preceding-sibling::演:幻灯片) + 1"/></xsl:for-each></xsl:attribute>
            <xsl:attribute name="presentation:class">page</xsl:attribute>
        </draw:page-thumbnail>
    </xsl:template>
    <xsl:template match="演:页面版式">
        <xsl:element name="style:presentation-page-layout">
            <xsl:attribute name="style:name"><xsl:value-of select="@演:标识符"/></xsl:attribute>
            <xsl:apply-templates select="演:占位符" mode="layout"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="演:占位符" mode="layout">
        <presentation:placeholder>
            <xsl:attribute name="presentation:object"><xsl:choose><xsl:when test="@演:类型='vertical_text'">vertical_outline</xsl:when><xsl:when test="@演:类型='date'">date-time</xsl:when><xsl:when test="@演:类型='number'">page_number</xsl:when><xsl:otherwise><xsl:value-of select="@演:类型"/></xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="svg:x"><xsl:value-of select="concat(uof:锚点/@uof:x坐标,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:y"><xsl:value-of select="concat(uof:锚点/@uof:y坐标,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:width"><xsl:value-of select="concat(uof:锚点/@uof:宽度,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:height"><xsl:value-of select="concat(uof:锚点/@uof:高度,$uofUnit)"/></xsl:attribute>
        </presentation:placeholder>
    </xsl:template>
    <xsl:template match="字:段落">
        <xsl:choose>
            <xsl:when test="字:段落属性/字:自动编号信息">
                <xsl:call-template name="编号解析"/>
            </xsl:when>
            <xsl:when test="字:句/字:分页符">
                <xsl:call-template name="processPageBreaks"/>
            </xsl:when>
            <xsl:when test="string(parent::node()/@uof:locID)='t0107'">
                <xsl:call-template name="jiaozhu"/>
            </xsl:when>
            <xsl:when test="string(parent::node()/@uof:locID)='t0108'">
                <xsl:call-template name="weizhu"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="commonParagraph"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="jiaozhu">
        <xsl:element name="text:footnote">
            <xsl:element name="text:footnote-body">
                <xsl:call-template name="commonParagraph"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="weizhu">
        <xsl:element name="text:endnote">
            <xsl:element name="text:endnote-body">
                <xsl:call-template name="commonParagraph"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="processPageBreaks">
        <xsl:variable name="pageBreak" select="字:句/字:分页符"/>
        <xsl:call-template name="createSubParagraph">
            <xsl:with-param name="list" select="$pageBreak[1]/preceding-sibling::字:句"/>
            <xsl:with-param name="pageBreak"/>
            <xsl:with-param name="needsPageBreak">false</xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="$pageBreak">
            <xsl:call-template name="createSubParagraph">
                <xsl:with-param name="list" select="./following-sibling::字:句[preceding::字:句/字:分页符 = '.']"/>
                <xsl:with-param name="pageBreak" select="."/>
                <xsl:with-param name="needsPageBreak">true</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="createSubParagraph">
        <xsl:param name="list"/>
        <xsl:param name="pageBreak"/>
        <xsl:param name="needsPageBreak"/>
        <xsl:if test="(count($list) &gt; 0) or ($needsPageBreak ='true') ">
            <xsl:element name="text:p">
                <xsl:choose>
                    <xsl:when test="$needsPageBreak = 'true'">
                        <xsl:choose>
                            <xsl:when test="ancestor::字:段落/字:段落属性">
                                <xsl:attribute name="text:style-name">P<xsl:number from="/uof:UOF/uof:演示文稿/演:主体" level="any" count="字:段落属性"/></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="text:style-name">PageBreak</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="$pageBreak">
                    <xsl:apply-templates select="$pageBreak"/>
                </xsl:if>
                <xsl:apply-templates select="$list"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="字:区域开始[@字:类型='bookmark']">
        <text:bookmark-start text:name="{@字:标识符}"/>
    </xsl:template>
    <xsl:template match="字:区域结束[preceding::字:区域开始[1]/@字:类型='bookmark']">
        <text:bookmark-end text:name="{@字:标识符引用}"/>
    </xsl:template>
    <xsl:template match="字:段落/字:域开始">
        <xsl:choose>
            <xsl:when test="@字:类型='CREATEDATE'">
                <xsl:variable name="datestr" select="../字:句/字:文本串"/>
                <xsl:element name="text:date">
                    <xsl:attribute name="style:data-style-name">Time<xsl:number from="/uof:UOF/uof:演示文稿/演:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'CREATEDATE']"/></xsl:attribute>
                    <xsl:attribute name="text:date-value"><xsl:value-of select="concat(substring-before($datestr,' '),'T',substring-after($datestr,' '))"/></xsl:attribute>
                    <xsl:value-of select="$datestr"/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="commonParagraph">
        <xsl:element name="text:p">
            <xsl:if test="@字:动画标识">
                <xsl:attribute name="text:id"><xsl:value-of select="@字:动画标识"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="commonParagraphAttributes"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="commonParagraphAttributes">
        <xsl:choose>
            <xsl:when test="字:段落属性">
                <xsl:attribute name="text:style-name"><xsl:value-of select="字:段落属性/@字:式样引用"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="generate-id(ancestor::字:主体/descendant::字:段落[1]) = generate-id(.)">
                <xsl:variable name="paragraph-number">
                    <xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落[字:段落属性]"/>
                </xsl:variable>
                <xsl:attribute name="text:style-name">P<xsl:value-of select="number($paragraph-number)"/>_1</xsl:attribute>
            </xsl:when>
            <xsl:when test="not(字:段落属性) and (descendant::字:分栏符 or ancestor::字:分节/descendant::字:节属性[字:分栏/@字:栏数 &gt; 1])">
                <xsl:attribute name="text:style-name">ColumnBreakPara</xsl:attribute>
            </xsl:when>
            <xsl:when test="字:句">
                <xsl:apply-templates select="字:文本串"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:段落属性"/>
    <xsl:template match="字:句/字:句属性"/>
    <xsl:template match="字:句属性" mode="style">
        <xsl:element name="style:style">
            <xsl:attribute name="style:name">T<xsl:number from="/uof:UOF/uof:对象集" level="any" count="字:句属性" format="1"/></xsl:attribute>
            <xsl:attribute name="style:family">text</xsl:attribute>
            <xsl:if test="@字:式样引用">
                <xsl:attribute name="style:parent-style-name"><xsl:value-of select="@字:式样引用"/></xsl:attribute>
            </xsl:if>
            <xsl:element name="style:text-properties">
                <xsl:apply-templates select="./*"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="字:句/字:文本串">
        <xsl:choose>
            <xsl:when test="string(.) = ' ' ">
                <xsl:element name="text:s"/>
            </xsl:when>
            <xsl:when test="contains(.,'  ')">
                <xsl:call-template name="replace-spaces">
                    <xsl:with-param name="curr-string" select="."/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="replace-spaces">
        <xsl:param name="curr-string"/>
        <xsl:if test="contains($curr-string,'  ')">
            <xsl:value-of select="substring-before($curr-string,'  ')"/>
            <text:s text:c="2"/>
            <xsl:variable name="next-string" select="substring-after($curr-string,'  ')"/>
            <xsl:choose>
                <xsl:when test="contains($next-string, '  ')">
                    <xsl:call-template name="replace-spaces">
                        <xsl:with-param name="curr-string" select="$next-string"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$next-string"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="字:句">
        <xsl:if test="name(following-sibling::*[1])!='字:域结束'">
            <xsl:if test="字:换行符">
                <xsl:element name="text:line-break"/>
            </xsl:if>
            <xsl:variable name="currently-node" select="./字:锚点"/>
            <xsl:choose>
                <xsl:when test="字:句属性//字:隐藏文字/@字:值='true'">
                    <text:hidden-text text:is-hidden="true" text:string-value="{.}"/>
                </xsl:when>
                <xsl:when test="字:区域开始[@字:类型='hyperlink']">
                    <xsl:element name="text:a">
                        <xsl:attribute name="xlink:type">simple</xsl:attribute>
                        <xsl:variable name="hyperDest" select="字:区域开始/@字:标识符"/>
                        <xsl:attribute name="xlink:href"><xsl:for-each select="/uof:UOF/uof:链接集/uof:超级链接"><xsl:if test="@uof:链源=$hyperDest"><xsl:if test="@uof:目标"><xsl:value-of select="@uof:目标"/></xsl:if><xsl:if test="@uof:书签"><xsl:variable name="bookmarkDest" select="@uof:书签"/><xsl:for-each select="/uof:UOF/uof:书签集/uof:书签"><xsl:if test="@uof:名称=$bookmarkDest"><xsl:value-of select="concat('#',uof:文本位置/@字:区域引用)"/></xsl:if></xsl:for-each></xsl:if></xsl:if></xsl:for-each></xsl:attribute>
                        <xsl:apply-templates select="字:文本串"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="(preceding-sibling::字:句) or (字:句属性)or(字:区域开始)">
                    <xsl:element name="text:span">
                        <xsl:choose>
                            <xsl:when test="字:区域开始[@字:类型='annotation']">
                                <xsl:variable name="ref_comment">
                                    <xsl:value-of select="字:区域开始/@字:标识符"/>
                                </xsl:variable>
                                <xsl:apply-templates/>
                                <xsl:apply-templates select="/uof:UOF/uof:文字处理/字:公用处理规则/字:批注集/字:批注[@字:区域引用 = $ref_comment]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="stylenum">
                                    <xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:句" format="1"/>
                                </xsl:variable>
                                <xsl:attribute name="text:style-name"><xsl:value-of select="字:句属性/@字:式样引用"/></xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="node()[name() =  '字:位置']">
        <xsl:variable name="height">100%    </xsl:variable>
        <xsl:variable name="position">
            <xsl:choose>
                <xsl:when test="parent::字:句属性//字:位置">
                    <xsl:value-of select="concat( parent::字:句属性//字:位置, '%')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="style:text-position"><xsl:value-of select="concat(concat( $position, ' '), $height)"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:字体">
        <xsl:if test="@字:字号">
            <xsl:attribute name="fo:font-size"><xsl:value-of select="@字:字号"/>pt</xsl:attribute>
            <xsl:attribute name="style:font-size-asian"><xsl:value-of select="@字:字号"/>pt</xsl:attribute>
            <xsl:attribute name="style:font-size-complex"><xsl:value-of select="@字:字号"/>pt</xsl:attribute>
        </xsl:if>
        <xsl:if test="@字:相对字号 and self::node( )[not(parent::字:句属性)]">
            <xsl:variable name="stylename" select="parent::node()/@字:基式样引用"/>
            <xsl:variable name="zihao">
                <xsl:for-each select="/uof:UOF/uof:式样集//uof:段落式样[@字:标识符=$stylename]">
                    <xsl:value-of select="字:字体/@字:字号"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="font-size" select="@字:相对字号"/>
            <xsl:attribute name="fo:font-size"><xsl:value-of select="($zihao * $font-size div 100)"/>pt</xsl:attribute>
            <xsl:attribute name="style:font-size-asian"><xsl:value-of select="($zihao * $font-size div 100)"/>pt</xsl:attribute>
            <xsl:attribute name="style:font-size-complex"><xsl:value-of select="($zihao * $font-size div 100)"/>pt</xsl:attribute>
        </xsl:if>
        <xsl:if test="@字:颜色">
            <xsl:attribute name="fo:color"><xsl:value-of select="string(@字:颜色)"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@字:中文字体引用">
            <xsl:attribute name="style:font-name-asian"><xsl:value-of select="@字:中文字体引用"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@字:西文字体引用">
            <xsl:attribute name="style:font-name"><xsl:value-of select="@字:西文字体引用"/></xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="字:斜体">
        <xsl:if test="@字:值='true'">
            <xsl:attribute name="fo:font-style">italic</xsl:attribute>
            <xsl:attribute name="fo:font-style-asian">italic</xsl:attribute>
            <xsl:attribute name="style:font-style-asian">italic</xsl:attribute>
            <xsl:attribute name="style:font-style-complex">italic</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="字:粗体">
        <xsl:if test="@字:值='true'">
            <xsl:attribute name="fo:font-weight">bold</xsl:attribute>
            <xsl:attribute name="fo:font-weight-asian">bold</xsl:attribute>
            <xsl:attribute name="style:font-weight-asian">bold</xsl:attribute>
            <xsl:attribute name="style:font-weight-complex">bold</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="字:下划线">
        <xsl:choose>
            <xsl:when test="@字:字下划线 = 'true'">
                <xsl:attribute name="style:text-underline">single</xsl:attribute>
                <xsl:attribute name="style:text-underline-color">font-color</xsl:attribute>
                <xsl:attribute name="fo:score-spaces">false</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'thick'">
                <xsl:attribute name="style:text-underline">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dotted-heavy'">
                <xsl:attribute name="style:text-underline">bold-dotted</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dashed-heavy'">
                <xsl:attribute name="style:text-underline">bold-dash</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dash-long'">
                <xsl:attribute name="style:text-underline">long-dash</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dash-long-heavy'">
                <xsl:attribute name="style:text-underline">bold-long-dash</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dash-dot-heavy'">
                <xsl:attribute name="style:text-underline">bold-dot-dash</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dash-dot-dot-heavy'">
                <xsl:attribute name="style:text-underline">bold-dot-dot-dash</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'wavy-heavy'">
                <xsl:attribute name="style:text-underline">bold-wave</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'wavy-double'">
                <xsl:attribute name="style:text-underline">double-wave</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="style:text-underline"><xsl:value-of select="@字:类型"/></xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@字:颜色 and not(@字:颜色 = 'auto')">
            <xsl:attribute name="style:text-underline-color"><xsl:value-of select="concat( '#', @字:颜色)"/></xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="字:阴影">
        <xsl:attribute name="style:text-shadow">1pt 1pt</xsl:attribute>
        <xsl:attribute name="fo:text-shadow">1pt 1pt</xsl:attribute>
    </xsl:template>
    <xsl:template match="字:删除线">
        <xsl:choose>
            <xsl:when test="@字:类型 = 'single' ">
                <xsl:attribute name="style:text-crossing-out">single-line</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字类型 = 'double'">
                <xsl:attribute name="style:text-crossing-out">double-line</xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:突出显示">
        <xsl:attribute name="fo:text-transform">uppercase</xsl:attribute>
        <xsl:attribute name="fo:text-background-color"><xsl:value-of select="string(@字:颜色)"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="@字:颜色[not(.='auto')]">
        <xsl:attribute name="fo:color">#<xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:浮雕">
        <xsl:attribute name="style:font-relief">embossed</xsl:attribute>
    </xsl:template>
    <xsl:template match="字:外框">
        <xsl:attribute name="style:text-outline">true</xsl:attribute>
    </xsl:template>
    <xsl:template match="字:缩放">
        <xsl:attribute name="style:text-scale"><xsl:value-of select="@字:字号"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:字符间距[parent::字:句属性]">
        <xsl:attribute name="fo:letter-spacing"><xsl:value-of select="concat( floor(number(字:字符间距 div 1440) * 2540) div 1000, 'cm')"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="uof:字体集">
        <xsl:if test="not(uof:字体声明[@uof:名称='StarSymbol'])">
            <style:font-face style:name="StarSymbol" svg:font-family="StarSymbol" style:font-charset="x-symbol"/>
        </xsl:if>
        <xsl:for-each select="uof:字体声明">
            <xsl:element name="style:font-face">
                <xsl:attribute name="style:name"><xsl:value-of select="@uof:名称"/></xsl:attribute>
                <xsl:attribute name="svg:font-family"><xsl:value-of select="@uof:字体族"/></xsl:attribute>
                <xsl:if test="@uof:字符集 = '02'">
                    <xsl:attribute name="style:font-charset">x-symbol</xsl:attribute>
                </xsl:if>
                <xsl:if test="@uof:字体族">
                    <xsl:choose>
                        <xsl:when test="@uof:字体族 = 'Swiss'">
                            <xsl:attribute name="style:font-family-generic">swiss</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@uof:字体族 ='Modern'">
                            <xsl:attribute name="style:font-family-generic">modern</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@uof:字体族='Roman'">
                            <xsl:attribute name="style:font-family-generic">roman</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@uof:字体族 ='Script'">
                            <xsl:attribute name="style:font-family-generic">script</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@uof:字体族 ='Decorative'">
                            <xsl:attribute name="style:font-family-generic">decorative</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@uof:字体族 ='System'">
                            <xsl:attribute name="style:font-family-generic">system</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:font-family-generic">system</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:attribute name="style:font-pitch">12</xsl:attribute>
            </xsl:element>
        </xsl:for-each>
        <xsl:apply-templates select="uof:字体声明"/>
    </xsl:template>
    <xsl:template match="uof:元数据">
        <office:meta>
            <meta:generator>UOFText 2004</meta:generator>
            <dc:title>
                <xsl:value-of select="uof:标题"/>
            </dc:title>
            <dc:description>
                <xsl:value-of select="uof:摘要"/>
            </dc:description>
            <dc:subject>
                <xsl:value-of select="uof:主题"/>
            </dc:subject>
            <meta:initial-creator>
                <xsl:value-of select="uof:作者"/>
            </meta:initial-creator>
            <meta:creation-date>
                <xsl:value-of select="substring-before( uof:创建日期, 'Z')"/>
            </meta:creation-date>
            <dc:creator>
                <xsl:value-of select="uof:最后作者"/>
            </dc:creator>
            <dc:date>
                <xsl:value-of select="substring-before( uof:编辑时间, 'Z')"/>
            </dc:date>
            <meta:printed-by/>
            <meta:print-date/>
            <meta:keywords>
                <meta:keyword>
                    <xsl:value-of select="uof:关键字集/uof:关键字"/>
                </meta:keyword>
            </meta:keywords>
            <dc:language/>
            <meta:editing-cycles>
                <xsl:value-of select="uof:编辑次数"/>
            </meta:editing-cycles>
            <meta:editing-duration>
                <xsl:if test="uof:编辑时间">
                    <xsl:value-of select="concat('PT', floor(uof:编辑时间 div 60), 'H', uof:编辑时间 mod 60, 'M0S')"/>
                </xsl:if>
            </meta:editing-duration>
            <meta:user-defined meta:name="Category">
                <xsl:value-of select="uof:分类"/>
            </meta:user-defined>
            <meta:user-defined meta:name="Manager">
                <xsl:value-of select="uof:经理名称"/>
            </meta:user-defined>
            <meta:user-defined meta:name="Company">
                <xsl:value-of select="uof:公司名称"/>
            </meta:user-defined>
            <meta:user-defined meta:name="Version">
                <xsl:value-of select="uof:创建应用程序"/>
            </meta:user-defined>
            <xsl:if test="uof:文档模板|child::*[@uof:locID='u0013']">
                <meta:template xlink:type="simple" xlink:actuate="onRequest" xlink:href="{child::*[@uof:locID='u0013']}"/>
            </xsl:if>
            <xsl:if test="uof:用户自定义元数据集/uof:用户自定义元数据|child::*[@uof:locID='u0016']/*[@uof:locID='u0017']">
                <xsl:for-each select="uof:用户自定义元数据集/uof:用户自定义元数据|child::*[@uof:locID='u0016']/*[@uof:locID='u0017']">
                    <xsl:element name="meta:user-defined">
                        <xsl:attribute name="meta:name"><xsl:value-of select="@uof:名称"/></xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
            <meta:document-statistic meta:page-count="{child::*[@uof:locID='u0020']}" meta:paragraph-count="{child::*[@uof:locID='u0025']}" meta:word-count="{child::*[@uof:locID='u0023']}" meta:object-count="{child::*[@uof:locID='u0026']}" meta:character-count="{child::*[@uof:locID='u0021']}"/>
            <meta:document-statistic/>
        </office:meta>
    </xsl:template>
    <xsl:template match="uof:用户自定义元数据集">
        <xsl:for-each select="node()[@名称]">
            <meta:user-defined meta:name="{name()}">
                <xsl:value-of select="."/>
            </meta:user-defined>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="parse-range">
        <xsl:param name="range-value"/>
        <xsl:param name="last"/>
        <xsl:variable name="first-pit">
            <xsl:choose>
                <xsl:when test="contains($range-value,',')">
                    <xsl:value-of select="substring-before($range-value,',')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$range-value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="current">
            <xsl:choose>
                <xsl:when test="contains($first-pit,':')">
                    <xsl:variable name="R-start" select="substring-before(substring-after($first-pit,'R'),'C')"/>
                    <xsl:variable name="C-start" select="substring-before(substring-after($first-pit,'C'),':')"/>
                    <xsl:variable name="second-pit" select="substring-after($first-pit,':')"/>
                    <xsl:variable name="R-end" select="substring-before(substring-after($second-pit,'R'),'C')"/>
                    <xsl:variable name="C-end" select="substring-after($second-pit,'C')"/>
                    <xsl:variable name="the-str">
                        <xsl:call-template name="condition-rc-str">
                            <xsl:with-param name="r-start" select="$R-start"/>
                            <xsl:with-param name="r-end" select="$R-end"/>
                            <xsl:with-param name="c-start" select="$C-start"/>
                            <xsl:with-param name="c-end" select="$C-end"/>
                            <xsl:with-param name="last" select="''"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$the-str"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($first-pit,',')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($range-value,',')">
                <xsl:call-template name="parse-range">
                    <xsl:with-param name="range-value" select="substring-after($range-value,',')"/>
                    <xsl:with-param name="last" select="concat($last,$current)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($last,$current)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="condition-rc-str">
        <xsl:param name="r-start"/>
        <xsl:param name="r-end"/>
        <xsl:param name="c-start"/>
        <xsl:param name="c-end"/>
        <xsl:param name="last"/>
        <xsl:variable name="current">
            <xsl:call-template name="condition-c-str">
                <xsl:with-param name="rc-str" select="concat('R',$r-start)"/>
                <xsl:with-param name="start" select="$c-start"/>
                <xsl:with-param name="end" select="$c-end"/>
                <xsl:with-param name="last" select="''"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$r-start &lt; $r-end">
            <xsl:call-template name="condition-rc-str">
                <xsl:with-param name="r-start" select="$r-start + 1"/>
                <xsl:with-param name="r-end" select="$r-end"/>
                <xsl:with-param name="c-start" select="$c-start"/>
                <xsl:with-param name="c-end" select="$c-end"/>
                <xsl:with-param name="last" select="concat($last,$current)"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$r-start = $r-end">
            <xsl:value-of select="concat($last,$current)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="condition-c-str">
        <xsl:param name="rc-str"/>
        <xsl:param name="start"/>
        <xsl:param name="end"/>
        <xsl:param name="last"/>
        <xsl:variable name="current" select="concat($rc-str,'C',$start,',')"/>
        <xsl:if test="$start &lt; $end">
            <xsl:call-template name="condition-c-str">
                <xsl:with-param name="rc-str" select="$rc-str"/>
                <xsl:with-param name="start" select="$start + 1"/>
                <xsl:with-param name="end" select="$end"/>
                <xsl:with-param name="last" select="concat($last,$current)"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$start = $end">
            <xsl:value-of select="concat($last,$current)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="condition-str">
        <xsl:param name="param-str"/>
        <xsl:choose>
            <xsl:when test="contains($param-str,'(')">
                <xsl:call-template name="condition-str">
                    <xsl:with-param name="param-str" select="substring-after($param-str,'(')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring-before($param-str,':')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="encode-as-cell-range-address">
        <xsl:param name="string"/>
        <xsl:value-of select="$string"/>
    </xsl:template>
    <xsl:template name="encode-as-cell-address">
        <xsl:param name="string"/>
        <xsl:value-of select="$string"/>
    </xsl:template>
    <xsl:param name="dpi" select="111"/>
    <xsl:param name="centimeter-in-mm" select="10"/>
    <xsl:param name="inch-in-mm" select="25.4"/>
    <xsl:param name="didot-point-in-mm" select="0.376065"/>
    <xsl:param name="pica-in-mm" select="4.2333333"/>
    <xsl:param name="point-in-mm" select="0.3527778"/>
    <xsl:param name="twip-in-mm" select="0.017636684"/>
    <xsl:param name="pixel-in-mm" select="$inch-in-mm div $dpi"/>
    <!-- ***** MEASUREMENT CONVERSIONS *****
      PARAM 'value'
        The measure to be converted.
        The current measure is judged by a substring (e.g. 'mm', 'cm', 'in', 'pica'...)
        directly added to the number.

      PARAM 'rounding-factor'
        Is used for the rounding of decimal places.
        The parameter number is the product of 1 and some '10', where
        every zero represents a decimal place.

        For example, providing as parameter:
            <xsl:param name="rounding-factor" select="10000" />
        Gives by default four decimal places.

        To round two decimal places, basically the following is done:
            <xsl:value-of select="round(100 * value) div 100"/>

      RETURN    The converted number, by default rounded to four decimal places.
                In case the input measure could not be matched the same value is
                returned and a warning message is written out.



     MEASURE LIST:
     * 1 millimeter (mm), the basic measure

     * 1 centimeter (cm) = 10 mm

     * 1 inch (in) = 25.4 mm
        While the English have already seen the light (read: the metric system), the US
        remains loyal to this medieval system.

     * 1 point (pt) = 0.35277777.. mm
        Sometimes called PostScript point (ppt), as when Adobe created PostScript, they added their own system of points.
        There are exactly 72 PostScript points in 1 inch.

     * 1 twip = twentieth of a (PostScript) point
        A twip (twentieth of a point) is a 1/20th of a PostScript point, a traditional measure in printing.

     * 1 didot point (dpt) = 0.376065 mm
        Didot point after the French typographer Firmin Didot (1764-1836).

        More details under
        http://www.unc.edu/~rowlett/units/dictP.html:
        "A unit of length used by typographers and printers. When printing was done
        from hand-set metal type, one point represented the smallest element of type
        that could be handled, roughly 1/64 inch. Eventually, the point was standardized
        in Britain and America as exactly 1/72.27 = 0.013 837 inch, which is
        about 0.35 mm (351.46 micrometers). In continental Europe, typographers
        traditionally used a slightly larger point of 0.014 83 inch (about
        1/72 pouce, 0.377 mm, or roughly 1/67 English inch), called a Didot point
        after the French typographer Firmin Didot (1764-1836). In the U.S.,
        Adobe software defines the point to be exactly 1/72 inch (0.013 888 9 inch
        or 0.352 777 8 millimeters) and TeX software uses a slightly smaller point
        of 0.351 459 8035 mm. The German standards agency DIN has proposed that
        all these units be replaced by multiples of 0.25 millimeters (1/101.6 inch).

     * 1 pica = 4.233333 mm
        1/6 inch or 12 points

     * 1 pixel (px) = 0.26458333.. mm   (relative to 'DPI', here: 96 dpi)
        Most pictures have the 96 dpi resolution, but the dpi variable may vary by stylesheet parameter


    -->
    <!-- changing measure to mm -->
    <xsl:template name="convert2mm">
        <xsl:param name="value"/>
        <xsl:param name="rounding-factor" select="10000"/>
        <xsl:choose>
            <xsl:when test="contains($value, 'mm')">
                <xsl:value-of select="substring-before($value, 'mm')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'cm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'cm' ) * $centimeter-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'in')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'in' ) * $inch-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pt')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'pt') * $point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'twip')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'twip') * $twip-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'dpt')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'dpt') * $didot-point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pica')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'pica') * $pica-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'px')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'px') * $pixel-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>measure_conversion.xsl: Find no conversion for <xsl:value-of select="$value"/> to 'mm'!</xsl:message>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- changing measure to cm -->
    <xsl:template name="convert2cm">
        <xsl:param name="value"/>
        <xsl:param name="rounding-factor" select="10000"/>
        <xsl:choose>
            <xsl:when test="contains($value, 'mm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'mm') div $centimeter-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'cm')">
                <xsl:value-of select="substring-before($value, 'cm')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'in')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'in') div $centimeter-in-mm * $inch-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pt')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'pt') div $centimeter-in-mm * $point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'dpt')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'dpt') div $centimeter-in-mm * $didot-point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pica')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'pica') div $centimeter-in-mm * $pica-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'twip')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'twip') div $centimeter-in-mm * $twip-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'px')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'px') div $centimeter-in-mm * $pixel-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>measure_conversion.xsl: Find no conversion for <xsl:value-of select="$value"/> to 'cm'!</xsl:message>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- changing measure to inch (cp. section comment) -->
    <xsl:template name="convert2in">
        <xsl:param name="value"/>
        <xsl:param name="rounding-factor" select="10000"/>
        <xsl:choose>
            <xsl:when test="contains($value, 'mm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'mm') div $inch-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'cm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'cm') div $inch-in-mm * $centimeter-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'in')">
                <xsl:value-of select="substring-before($value, 'in')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pt')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'pt') div $inch-in-mm * $point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'dpt')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'dpt') div $inch-in-mm * $didot-point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pica')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'pica') div $inch-in-mm * $pica-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'twip')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'twip') div $inch-in-mm * $twip-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'px')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'px') div $inch-in-mm * $pixel-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>measure_conversion.xsl: Find no conversion for <xsl:value-of select="$value"/> to 'in'!</xsl:message>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- changing measure to dpt (cp. section comment) -->
    <xsl:template name="convert2dpt">
        <xsl:param name="value"/>
        <xsl:param name="rounding-factor" select="10000"/>
        <xsl:choose>
            <xsl:when test="contains($value, 'mm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'mm') div $didot-point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'cm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'cm') div $didot-point-in-mm * $centimeter-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'in')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'in') div $didot-point-in-mm * $inch-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pt')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'pt') div $didot-point-in-mm * $point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'dpt')">
                <xsl:value-of select="substring-before($value, 'dpt')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pica')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'pica') div $didot-point-in-mm * $pica-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'twip')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'twip') div $didot-point-in-mm * $twip-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'px')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'px') div $didot-point-in-mm * $pixel-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>measure_conversion.xsl: Find no conversion for <xsl:value-of select="$value"/> to 'dpt'!</xsl:message>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- changing measure to pica (cp. section comment) -->
    <xsl:template name="convert2pica">
        <xsl:param name="value"/>
        <xsl:param name="rounding-factor" select="10000"/>
        <xsl:choose>
            <xsl:when test="contains($value, 'mm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'mm') div $pica-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'cm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'cm') div $pica-in-mm * $centimeter-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'in')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'in') div $pica-in-mm * $inch-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pt')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'pt') div $pica-in-mm * $point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'dpt')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'dpt') div $pica-in-mm * $didot-point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pica')">
                <xsl:value-of select="substring-before($value, 'pica')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'twip')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'twip') div $pica-in-mm * $twip-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'px')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'px') div $pica-in-mm * $pixel-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>measure_conversion.xsl: Find no conversion for <xsl:value-of select="$value"/> to 'pica'!</xsl:message>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- changing measure to pt (cp. section comment) -->
    <xsl:template name="convert2pt">
        <xsl:param name="value"/>
        <xsl:param name="rounding-factor" select="10000"/>
        <xsl:choose>
            <xsl:when test="contains($value, 'mm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'mm') div $point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'cm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'cm') div $point-in-mm * $centimeter-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'in')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'in') div $point-in-mm * $inch-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pt')">
                <xsl:value-of select="substring-before($value, 'pt')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'dpt')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'dpt') div $point-in-mm * $didot-point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pica')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'pica') div $point-in-mm * $pica-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'twip')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'twip') div $point-in-mm * $twip-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'px')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'px') div $point-in-mm * $pixel-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>measure_conversion.xsl: Find no conversion for <xsl:value-of select="$value"/> to 'pt'!</xsl:message>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="编号解析">
        <xsl:variable name="bianhao">
            <xsl:value-of select="字:段落属性/字:自动编号信息/@字:编号引用"/>
        </xsl:variable>
        <xsl:variable name="bianhaojibie">
            <xsl:value-of select="字:段落属性/字:自动编号信息/@字:编号级别"/>
        </xsl:variable>
        <xsl:variable name="isxiangmuorisimage">
            <xsl:for-each select="/uof:UOF/uof:式样集/uof:自动编号集/字:自动编号">
                <xsl:choose>
                    <xsl:when test="$bianhao=@字:标识符">
                        <xsl:choose>
                            <xsl:when test="字:级别[@字:级别值= (number($bianhaojibie))]/字:项目符号">true</xsl:when>
                            <xsl:when test="字:级别[@字:级别值= (number($bianhaojibie))]/字:图片符号引用">true</xsl:when>
                            <xsl:otherwise>false</xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>false</xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$isxiangmuorisimage='true'">
                <xsl:call-template name="无序"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="有序"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="有序">
        <xsl:variable name="currlistid" select="字:段落属性/字:自动编号信息/@字:编号引用"/>
        <xsl:variable name="currlistlvl" select="字:段落属性/字:自动编号信息/@字:编号级别"/>
        <xsl:variable name="firstoccur" select="/descendant::字:段落属性[字:自动编号信息/@字:编号引用 = $currlistid][1]"/>
        <xsl:element name="text:list">
            <xsl:attribute name="text:style-name">List<xsl:value-of select="count($firstoccur/preceding::字:自动编号信息)"/></xsl:attribute>
            <xsl:if test="字:段落属性/字:自动编号信息/@字:重新编号">
                <xsl:attribute name="text:continue-numbering"><xsl:choose><xsl:when test="字:段落属性/字:自动编号信息/@字:重新编号='true'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:if>
            <xsl:element name="text:list-item">
                <xsl:call-template name="ordered-levels">
                    <xsl:with-param name="level" select="$currlistlvl -1"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="ordered-levels">
        <xsl:param name="level"/>
        <xsl:choose>
            <xsl:when test="$level = '0'">
                <xsl:call-template name="commonParagraph"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="text:list">
                    <xsl:element name="text:list-item">
                        <xsl:call-template name="ordered-levels">
                            <xsl:with-param name="level" select="$level -1"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="无序">
        <xsl:variable name="currlistid" select="字:段落属性/字:自动编号信息/@字:编号引用"/>
        <xsl:variable name="currlistlvl" select="字:段落属性/字:自动编号信息/@字:编号级别"/>
        <xsl:variable name="firstoccur" select="/descendant::字:段落属性[字:自动编号信息/@字:编号引用 = $currlistid][1]"/>
        <xsl:element name="text:list">
            <xsl:attribute name="text:style-name">List<xsl:value-of select="count($firstoccur/preceding::字:自动编号信息)"/></xsl:attribute>
            <xsl:element name="text:list-item">
                <xsl:call-template name="unordered-levels">
                    <xsl:with-param name="level" select="$currlistlvl -1"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="unordered-levels">
        <xsl:param name="level"/>
        <xsl:choose>
            <xsl:when test="$level = '0'">
                <xsl:call-template name="commonParagraph"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="text:list">
                    <xsl:element name="text:list-item">
                        <xsl:call-template name="unordered-levels">
                            <xsl:with-param name="level" select="$level -1"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- changing measure to pt (cp. section comment) -->
    <xsl:template name="convert2twip">
        <xsl:param name="value"/>
        <xsl:param name="rounding-factor" select="10000"/>
        <xsl:choose>
            <xsl:when test="contains($value, 'mm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'mm') div $twip-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'cm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'cm') div $twip-in-mm * $centimeter-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'in')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'in') div $twip-in-mm * $inch-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pt')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'pt') div $twip-in-mm * $point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'dpt')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'dpt') div $twip-in-mm * $didot-point-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pica')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'pica') div $twip-in-mm * $pica-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, 'twip')">
                <xsl:value-of select="substring-before($value, 'twip')"/>
            </xsl:when>
            <xsl:when test="contains($value, 'px')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'px') div $twip-in-mm * $pixel-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>measure_conversion.xsl: Find no conversion for <xsl:value-of select="$value"/> to 'twip'!</xsl:message>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- changing measure to pixel by via parameter provided dpi (dots per inch) standard factor (cp. section comment) -->
    <xsl:template name="convert2px">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, 'mm')">
                <xsl:value-of select="round(number(substring-before($value, 'mm')) div $pixel-in-mm)"/>
            </xsl:when>
            <xsl:when test="contains($value, 'cm')">
                <xsl:value-of select="round(number(substring-before($value, 'cm')) div $pixel-in-mm * $centimeter-in-mm)"/>
            </xsl:when>
            <xsl:when test="contains($value, 'in')">
                <xsl:value-of select="round(number(substring-before($value, 'in')) div $pixel-in-mm * $inch-in-mm)"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pt')">
                <xsl:value-of select="round(number(substring-before($value, 'pt')) div $pixel-in-mm * $point-in-mm)"/>
            </xsl:when>
            <xsl:when test="contains($value, 'dpt')">
                <xsl:value-of select="round(number(substring-before($value, 'dpt')) div $pixel-in-mm * $didot-point-in-mm)"/>
            </xsl:when>
            <xsl:when test="contains($value, 'pica')">
                <xsl:value-of select="round(number(substring-before($value, 'pica')) div $pixel-in-mm * $pica-in-mm)"/>
            </xsl:when>
            <xsl:when test="contains($value, 'twip')">
                <xsl:value-of select="round(number(substring-before($value, 'twip')) div $pixel-in-mm * $twip-in-mm)"/>
            </xsl:when>
            <xsl:when test="contains($value, 'px')">
                <xsl:value-of select="$value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>measure_conversion.xsl: Find no conversion for <xsl:value-of select="$value"/> to 'px'!</xsl:message>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
