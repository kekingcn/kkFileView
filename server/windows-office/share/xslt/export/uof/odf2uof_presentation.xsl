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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0" xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0" xmlns:uof="http://schemas.uof.org/cn/2003/uof" xmlns:表="http://schemas.uof.org/cn/2003/uof-spreadsheet" xmlns:演="http://schemas.uof.org/cn/2003/uof-slideshow" xmlns:字="http://schemas.uof.org/cn/2003/uof-wordproc" xmlns:数="http://www.w3.org/1998/Math/MathML" xmlns:图="http://schemas.uof.org/cn/2003/graph" exclude-result-prefixes="office style text table draw fo xlink dc meta number presentation svg chart dr3d math form script config ooo ooow oooc dom xforms smil anim">
    <xsl:output method="xml" indent="no" encoding="UTF-8" version="1.0" standalone="no" omit-xml-declaration="no"/>
    <xsl:variable name="impresswithUnit">
        <xsl:value-of select="/office:document/office:styles/style:style[@style:family='graphic']/style:graphic-properties/@svg:stroke-width"/>
    </xsl:variable>
    <xsl:variable name="uofUnit">
        <xsl:choose>
            <xsl:when test="contains($impresswithUnit,'inch')">inch</xsl:when>
            <xsl:when test="contains($impresswithUnit,'cm')">cm</xsl:when>
            <xsl:when test="contains($impresswithUnit,'mm')">mm</xsl:when>
            <xsl:when test="contains($impresswithUnit,'pt')">pt</xsl:when>
            <xsl:otherwise>cm</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="cm-to-other">
        <xsl:choose>
            <xsl:when test="$uofUnit='cm'">1</xsl:when>
            <xsl:when test="$uofUnit='inch'">0.394</xsl:when>
            <xsl:when test="$uofUnit='pt'">28.346</xsl:when>
            <xsl:when test="$uofUnit='mm'">10</xsl:when>
            <xsl:when test="$uofUnit='pica'">2.364</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:key match="/office:document/office:automatic-styles/style:style | /office:document/office:styles/style:style" name="graphicset" use="@style:name"/>
    <xsl:template match="/">
        <xsl:apply-templates select="office:document"/>
    </xsl:template>
    <xsl:template match="office:document">
        <uof:UOF xmlns:uof="http://schemas.uof.org/cn/2003/uof" xmlns:图="http://schemas.uof.org/cn/2003/graph" xmlns:数="http://www.w3.org/1998/Math/MathML" xmlns:字="http://schemas.uof.org/cn/2003/uof-wordproc" xmlns:演="http://schemas.uof.org/cn/2003/uof-slideshow" xmlns:表="http://schemas.uof.org/cn/2003/uof-spreadsheet" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" uof:language="cn" uof:version="1.0" uof:locID="u0000" uof:mimetype="vnd.uof.presentation">
            <xsl:apply-templates select="office:meta"/>
            <xsl:if test="//text:bookmark|//text:bookmark-start">
            <uof:书签集 uof:locID="u0027">
                <xsl:for-each select="//text:bookmark|//text:bookmark-start">
                    <uof:书签 uof:名称="{@text:name}" uof:locID="u0028" uof:attrList="名称">
                        <uof:文本位置 uof:区域引用="{generate-id(.)}" uof:locID="u0029" uof:attrList="区域引用"/>
                    </uof:书签>
                </xsl:for-each>
            </uof:书签集>
        </xsl:if>
            <xsl:if test="/office:document/office:body/text:p/text:a | /office:document/office:body/text:p/draw:a">
                <uof:链接集 uof:locID="u0031">
                    <xsl:for-each select="/office:document/office:body/text:p/text:a | /office:document/office:body/text:p/draw:a">
                        <xsl:variable name="hyperStr" select="@xlink:href"/>
                        <uof:超级链接 uof:locID="u0032" uof:attrList="标识符 目标 书签 式样引用 已访问式样引用 提示 链源">
                            <xsl:if test="contains($hyperStr,'#')">
                                <xsl:attribute name="uof:书签"><xsl:value-of select="substring-after($hyperStr,'#')"/></xsl:attribute>
                                <xsl:attribute name="uof:提示"><xsl:value-of select="."/></xsl:attribute>
                            </xsl:if>
                            <xsl:variable name="num">
                                <xsl:number from="/office:document/office:body" level="any" count="text:p[text:a]"/>
                            </xsl:variable>
                            <xsl:attribute name="uof:链源"><xsl:value-of select="concat('hlnk',$num)"/></xsl:attribute>
                            <xsl:attribute name="uof:标识符"><xsl:value-of select="concat('hyk_','hlnk',$num)"/></xsl:attribute>
                            <xsl:if test="not(contains($hyperStr,'#'))">
                                <xsl:attribute name="uof:目标"><xsl:value-of select="$hyperStr"/></xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="contains($hyperStr,'@')">
                                        <xsl:attribute name="uof:提示">链接到邮件地址</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="uof:提示">链接文件</xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="@text:style-name">
                                <xsl:attribute name="uof:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@text:visited-style-name">
                                <xsl:attribute name="uof:已访问式样引用"><xsl:value-of select="@text:visited-style-name"/></xsl:attribute>
                            </xsl:if>
                        </uof:超级链接>
                    </xsl:for-each>
                </uof:链接集>
            </xsl:if>
            <uof:对象集 uof:locID="u0033">
                <xsl:apply-templates select="office:master-styles/style:handout-master" mode="styles"/>
                <xsl:apply-templates select="office:master-styles/style:master-page" mode="styles"/>
                <xsl:apply-templates select="office:body/office:presentation/draw:page" mode="styles"/>
                <xsl:apply-templates select="office:styles/style:presentation-page-layout/presentation:placeholder" mode="graphic"/>
                <xsl:apply-templates select="office:body/office:presentation/draw:page/presentation:notes" mode="styles"/>
                <xsl:for-each select="(/office:document/office:styles/draw:fill-image) | (/office:document/office:automatic-styles/draw:fill-image)">
                    <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                        <xsl:attribute name="uof:标识符"><xsl:value-of select="@draw:name"/></xsl:attribute>
                        <xsl:attribute name="uof:公共类型">jpg</xsl:attribute>
                        <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                        <uof:数据 uof:locID="u0037">
                            <xsl:value-of select="office:binary-data"/>
                        </uof:数据>
                    </uof:其他对象>
                </xsl:for-each>
                <xsl:for-each select="(/office:document/office:styles/style:style/style:graphic-properties/text:list-style/text:list-level-style-image) | (/office:document/office:automatic-styles/style:style/style:graphic-properties/text:list-style/text:list-level-style-image)">
                    <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                        <xsl:attribute name="uof:标识符"><xsl:value-of select="concat('image_numbering_',count(preceding::text:list-level-style-image))"/></xsl:attribute>
                        <xsl:attribute name="uof:公共类型">jpg</xsl:attribute>
                        <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                        <uof:数据 uof:locID="u0037">
                            <xsl:value-of select="office:binary-data"/>
                        </uof:数据>
                    </uof:其他对象>
                </xsl:for-each>
            </uof:对象集>
            <uof:式样集 uof:locID="u0039">
                <xsl:apply-templates select="office:font-face-decls"/>
                <xsl:element name="uof:自动编号集">
                    <xsl:attribute name="uof:locID">u0042</xsl:attribute>
                    <xsl:for-each select="/office:document//text:list-style">
                        <xsl:element name="字:自动编号">
                            <xsl:attribute name="uof:locID">t0169</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符 名称 父编号引用 多级编号</xsl:attribute>
                            <xsl:attribute name="字:标识符">
                                <xsl:variable name="count1" select="count(preceding::text:list-style)"/>
                            <xsl:choose><xsl:when test="@style:name"><xsl:value-of select="concat(@style:name,$count1)"/></xsl:when><xsl:otherwise><xsl:value-of select="concat(../../@style:name,$count1)"/></xsl:otherwise></xsl:choose></xsl:attribute>
                            <xsl:attribute name="字:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                            <xsl:attribute name="字:多级编号">true</xsl:attribute>
                            <xsl:for-each select="./* ">
                            <xsl:if test="number(@text:level) &lt; 10">
                                <xsl:element name="字:级别">
                                    <xsl:attribute name="uof:locID">t0159</xsl:attribute>
                                    <xsl:attribute name="uof:attrList">级别值 编号对齐方式 尾随字符</xsl:attribute>
                                    <xsl:attribute name="字:级别值"><xsl:value-of select="number(@text:level)"/></xsl:attribute>
                                    <xsl:if test="style:list-level-properties/@fo:text-align">
                                    <xsl:attribute name="字:编号对齐方式"><xsl:value-of select="style:list-level-properties/@fo:text-align"/></xsl:attribute>
                                    </xsl:if>
                                    <xsl:variable name="level">
                                        <xsl:value-of select="@text:level"/>
                                    </xsl:variable>
                                    <xsl:if test="office:binary-data">
                                        <xsl:element name="字:图片符号引用" uof:locID="t0164" uof:attrList="宽度 高度">
                                            <xsl:attribute name="字:宽度"><xsl:value-of select="substring-before(style:list-level-properties/@fo:width,$uofUnit)"/></xsl:attribute>
                                            <xsl:attribute name="字:高度"><xsl:value-of select="substring-before(style:list-level-properties/@fo:height,$uofUnit)"/></xsl:attribute>
                                            <xsl:value-of select="concat('image_numbering_',count(preceding::text:list-level-style-image))"/>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="@text:bullet-char">
                                        <xsl:element name="字:项目符号">
                                            <xsl:attribute name="uof:locID">t0171</xsl:attribute>
                                            <xsl:value-of select="@text:bullet-char"/>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="字:符号字体">
                                        <xsl:attribute name="uof:locID">t0160</xsl:attribute>
                                        <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                                        <xsl:call-template name="字:句属性"/>
                                    </xsl:element>
                                    <xsl:if test="@style:num-format">
                                        <xsl:choose>
                                            <xsl:when test="string(@style:num-format)='a'">
                                                <xsl:element name="字:编号格式" uof:locID="t0162">lower-letter</xsl:element>
                                            </xsl:when>
                                            <xsl:when test="string(@style:num-format)='A'">
                                                <xsl:element name="字:编号格式" uof:locID="t0162">upper-letter</xsl:element>
                                            </xsl:when>
                                            <xsl:when test="string(@style:num-format)='i'">
                                                <xsl:element name="字:编号格式" uof:locID="t0162">lower-roman</xsl:element>
                                            </xsl:when>
                                            <xsl:when test="string(@style:num-format)='I'">
                                                <xsl:element name="字:编号格式" uof:locID="t0162">upper-roman</xsl:element>
                                            </xsl:when>
                                            <xsl:when test="string(@style:num-format)='①, ②, ③, ...'">
                                                <xsl:element name="字:编号格式" uof:locID="t0162">decimal-enclosed-circle</xsl:element>
                                            </xsl:when>
                                            <xsl:when test="string(@style:num-format)='甲, 乙, 丙, ...'">
                                                <xsl:element name="字:编号格式" uof:locID="t0162">ideograph-traditional</xsl:element>
                                            </xsl:when>
                                            <xsl:when test="string(@style:num-format)='子, 丑, 寅, ...'">
                                                <xsl:element name="字:编号格式" uof:locID="t0162">ideograph-zodiac</xsl:element>
                                            </xsl:when>
                                            <xsl:when test="string(@style:num-format)='一, 二, 三, ...'">
                                                <xsl:element name="字:编号格式" uof:locID="t0162">chinese-counting</xsl:element>
                                            </xsl:when>
                                            <xsl:when test="string(@style:num-format)='壹, 贰, 叁, ...'">
                                                <xsl:element name="字:编号格式" uof:locID="t0162">chinese-legal-simplified</xsl:element>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:element name="字:编号格式" uof:locID="t0162">decimal</xsl:element>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:variable name="jibie">
                                        <xsl:value-of select="position()"/>
                                    </xsl:variable>
                                    <xsl:variable name="xianshijibie">
                                        <xsl:choose>
                                            <xsl:when test="@text:display-levels">
                                                <xsl:value-of select="@text:display-levels"/>
                                            </xsl:when>
                                            <xsl:otherwise>1</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <字:编号格式表示 uof:locID="t0163">
                                        <xsl:call-template name="字:编号格式表示">
                                            <xsl:with-param name="bubianjibie" select="$jibie"/>
                                            <xsl:with-param name="jibie" select="$jibie"/>
                                            <xsl:with-param name="xianshijibie" select="$xianshijibie"/>
                                            <xsl:with-param name="biaoshi" select="concat(string(@style:num-prefix),'%',$jibie,string(@style:num-suffix))"/>
                                        </xsl:call-template>
                                    </字:编号格式表示>
                                    <xsl:element name="字:缩进">
                                        <xsl:attribute name="uof:locID">t0165</xsl:attribute>
                                        <xsl:call-template name="字:缩进类型"/>
                                    </xsl:element>
                                    <xsl:element name="字:制表符位置">
                                    <xsl:attribute name="uof:locID">t0166</xsl:attribute>
                                        <xsl:value-of select="substring-before(style:list-level-properties/@text:min-label-width,$uofUnit)"/>
                                    </xsl:element>
                                    <xsl:if test="@text:start-value">
                                        <xsl:element name="字:起始编号">
                                            <xsl:value-of select="@text:start-value"/>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="@text:num-regular-exp">
                                        <xsl:element name="字:正规格式" uof:locID="t0168" uof:attrList="值">
                                            <xsl:attribute name="值"><xsl:value-of select="@text:num-regular-exp"/></xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
                <xsl:for-each select="/office:document//text:list-style/*">
                    <xsl:if test="style:text-properties/@fo:font-family">
                        <xsl:element name="uof:句式样">
                            <xsl:attribute name="uof:locID">u0043</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符 名称 类型 别名 基式样引用</xsl:attribute>
                            <xsl:variable name="count"><xsl:value-of select="count(preceding::node())"/></xsl:variable>
                            <xsl:attribute name="字:标识符"><xsl:value-of select="concat('ID',$count)"/></xsl:attribute>
                            <xsl:attribute name="字:名称"><xsl:value-of select="concat(ancestor::style:style/@style:name,@text:level)"/></xsl:attribute>
                            <xsl:attribute name="字:类型">auto</xsl:attribute>
                            <xsl:if test="ancestor::style:style/@style:parent-style-name">
                                <xsl:attribute name="字:基式样引用"><xsl:value-of select="ancestor::style:style/@style:parent-style-name"/></xsl:attribute>
                            </xsl:if>
                            <xsl:call-template name="字:句属性"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
                <xsl:apply-templates select="office:styles | office:automatic-styles" mode="style"/>
                <xsl:for-each select="/office:document/office:master-styles/style:master-page">
                    <xsl:for-each select="child::draw:frame">
                        <xsl:variable name="stylename" select="@presentation:style-name"/>
                        <xsl:variable name="parent" select="/office:document/office:automatic-styles/style:style[@style:name=$stylename]/@style:parent-style-name"/>
                        <xsl:for-each select="/office:document/*/style:style[@style:name=$parent]">
                            <xsl:if test="not(contains(@style:name,'outline'))">
                                <xsl:call-template name="段落式样"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="/office:document/office:styles/style:style[contains(@style:name,'outline')]">
                    <xsl:call-template name="段落式样"/>
                </xsl:for-each>
            </uof:式样集>
            <uof:演示文稿 uof:locID="u0048">
                <演:公用处理规则 uof:locID="p0000">
                    <xsl:element name="演:度量单位">
                        <xsl:attribute name="uof:locID">p0055</xsl:attribute>
                        <xsl:value-of select="$uofUnit"/>
                    </xsl:element>
                    <演:页面设置集 uof:locID="p0001">
                        <xsl:apply-templates select="office:automatic-styles/style:page-layout"/>
                    </演:页面设置集>
                    <演:配色方案集 uof:locID="p0007">
                            <xsl:for-each select="/office:document/office:master-styles/*[@draw:style-name]">
                               <xsl:call-template name="配色方案"/>
                            </xsl:for-each>
                        <xsl:for-each select="/office:document/office:body/office:presentation/draw:page">
                          <xsl:call-template name="配色方案"/>
                        </xsl:for-each>
                    </演:配色方案集>
                    <演:页面版式集 uof:locID="p0017">
                        <xsl:apply-templates select="office:styles/style:presentation-page-layout" mode="pagestyle"/>
                    </演:页面版式集>
                    <xsl:if test="office:styles/style:style='标准-title' or office:styles/style:style='标准-outline'" >
                    <演:文本式样集 uof:locID="p0131">
                        <xsl:for-each select="office:styles/style:style">
                        <xsl:variable name="name"><xsl:value-of select="@style:name"/></xsl:variable>
                        <xsl:if test="$name='标准-title' or contains($name,'标准-outline')">
                        <演:文本式样 uof:locID="p0132" uof:attrList="标识符 名称">
                           <xsl:attribute name="演:标识符">text-style</xsl:attribute>
                            <xsl:attribute name="演:名称">文本式样</xsl:attribute>
                            <xsl:element name="演:段落式样">
                               <xsl:attribute name="字:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
                               <xsl:attribute name="字:类型">auto</xsl:attribute>
                              <xsl:if test="@style:parent-style-name">
                               <xsl:attribute name="字:基式样引用"><xsl:value-of select="@style:parent-style-name"/></xsl:attribute>
                              </xsl:if>
                              <xsl:attribute name="字:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                              <xsl:attribute name="字:别名"><xsl:value-of select="@style:class"/></xsl:attribute>
                        <xsl:call-template name="ParaAttribute">
                          <xsl:with-param name="text-style-name" select="@text:style-name"/>
                        </xsl:call-template>
                        <xsl:call-template name="字:句属性"/>
                    </xsl:element>
                        </演:文本式样>
                        </xsl:if>
                    </xsl:for-each>
                    </演:文本式样集>
                    </xsl:if>
                    <演:显示比例 uof:locID="p0020">
                        <xsl:variable name="VisibleAreaWidth">
                            <xsl:value-of select="/office:document/office:settings/config:config-item-set/config:config-item-map-indexed/config:config-item-map-entry/config:config-item[@config:name='VisibleAreaWidth']"/>
                        </xsl:variable>
                        <xsl:value-of select="substring-before((13997 div $VisibleAreaWidth)*100,'.')"/>
                    </演:显示比例>
                    <演:放映设置 uof:locID="p0021">
                        <演:幻灯片序列 uof:locID="p0022" uof:attrList="标识符 名称 自定义">
                            <xsl:attribute name="演:标识符">customList</xsl:attribute>
                            <xsl:attribute name="演:名称">幻灯片序列</xsl:attribute>
                            <xsl:attribute name="演:自定义">true</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="office:body/office:presentation/presentation:settings/@presentation:start-page">
                                    <xsl:variable name="start-page">
                                        <xsl:value-of select="office:body/office:presentation/presentation:settings/@presentation:start-page"/>
                                    </xsl:variable>
                                    <xsl:variable name="before-slides">
                                        <xsl:call-template name="幻灯片序列">
                                            <xsl:with-param name="start-node" select="office:body/office:presentation/draw:page[@draw:name=$start-page]"/>
                                            <xsl:with-param name="end-node" select="office:body/office:presentation/draw:page[last()]"/>
                                            <xsl:with-param name="value"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="after-slides">
                                        <xsl:for-each select="office:body/office:presentation/draw:page[@draw:name=$start-page]">
                                            <xsl:call-template name="幻灯片序列">
                                                <xsl:with-param name="start-node" select="/office:document/office:body/office:presentation/draw:page[1]"/>
                                                <xsl:with-param name="end-node" select="preceding-sibling::node()[1]"/>
                                                <xsl:with-param name="value"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </xsl:variable>
                                    <xsl:value-of select="concat($before-slides,' ',$after-slides)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="幻灯片序列">
                                        <xsl:with-param name="start-node" select="office:body/office:presentation/draw:page[1]"/>
                                        <xsl:with-param name="end-node" select="office:body/office:presentation/draw:page[last()]"/>
                                        <xsl:with-param name="value"/>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </演:幻灯片序列>
                        <演:放映顺序 uof:locID="p0023" uof:attrList="名称 序列引用">
                            <xsl:attribute name="演:名称">放映顺序</xsl:attribute>
                            <xsl:attribute name="演:序列引用">customList</xsl:attribute>
                        </演:放映顺序>
                        <演:全屏放映 uof:locID="p0024">
                            <xsl:choose>
                                <xsl:when test="office:body/office:presentation/presentation:settings/@presentation:full-screen='false'">false</xsl:when>
                                <xsl:otherwise>true</xsl:otherwise>
                            </xsl:choose>
                        </演:全屏放映>
                        <演:循环放映 uof:locID="p0025">
                            <xsl:choose>
                                <xsl:when test="office:body/office:presentation/presentation:settings/@presentation:endless='true'">true</xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </演:循环放映>
                        <xsl:if test="office:body/office:presentation/presentation:settings/@presentation:pause">
                            <演:放映间隔 uof:locID="p0026">
                                <xsl:variable name="hms">
                                    <xsl:value-of select="substring-after(office:body/office:presentation/presentation:settings/@presentation:pause,'PT')"/>
                                </xsl:variable>
                                <xsl:value-of select="concat('P0Y0M0DT',$hms)"/>
                            </演:放映间隔>
                        </xsl:if>
                        <演:手动方式 uof:locID="p0027">
                            <xsl:choose>
                                <xsl:when test="office:body/office:presentation/presentation:settings/@presentation:force-manual='true'">true</xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </演:手动方式>
                        <演:导航帮助 uof:locID="p0029">
                            <xsl:choose>
                                <xsl:when test="office:body/office:presentation/presentation:settings/@presentation:start-with-navigator='true'">true</xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </演:导航帮助>
                        <演:放映动画 uof:locID="p0030">
                            <xsl:choose>
                                <xsl:when test="office:body/office:presentation/presentation:settings/@presentation:animations='disabled'">false</xsl:when>
                                <xsl:otherwise>true</xsl:otherwise>
                            </xsl:choose>
                        </演:放映动画>
                        <演:前端显示 uof:locID="p0031">
                            <xsl:choose>
                                <xsl:when test="office:body/office:presentation/presentation:settings/@presentation:stay-on-top='true'">true</xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </演:前端显示>
                    </演:放映设置>
                </演:公用处理规则>
                <演:主体 uof:locID="p0034">
                    <演:母版集 uof:locID="p0035">
                        <xsl:apply-templates select="office:master-styles"/>
                    </演:母版集>
                    <演:幻灯片集 uof:locID="p0039">
                        <xsl:apply-templates select="office:body/office:presentation/draw:page"/>
                    </演:幻灯片集>
                </演:主体>
            </uof:演示文稿>
        </uof:UOF>
    </xsl:template>
<xsl:template name="配色方案">
   <xsl:variable name="page-name"><xsl:value-of select="@draw:style-name"/></xsl:variable>
                            <演:配色方案 uof:locID="p0008" uof:attrList="标识符 名称 类型">
                                <xsl:attribute name="演:标识符">
                                   <xsl:choose>
                                                <xsl:when test="@draw:name"><xsl:value-of select="@draw:name"/></xsl:when>
                                                <xsl:otherwise><xsl:value-of select="@draw:style-name"/></xsl:otherwise>
                                            </xsl:choose>

                                </xsl:attribute>
                                <xsl:for-each select="/office:document/office:automatic-styles/style:style[@style:name = $page-name]">
                                <xsl:attribute name="演:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                                <xsl:attribute name="演:类型"><xsl:choose><xsl:when test="not(contains(@style:name,'color'))">custom</xsl:when><xsl:otherwise>standard</xsl:otherwise></xsl:choose></xsl:attribute>
                                <xsl:if test="style:drawing-page-properties/@draw:fill-color">
                                    <演:背景色 uof:locID="p0009">
                                        <xsl:value-of select="style:drawing-page-properties/@draw:fill-color"/>
                                    </演:背景色>
                                </xsl:if>
                                <xsl:if test="style:drawing-page-properties/@svg:stroke-color">
                                    <演:文本和线条 uof:locID="p0010">
                                        <xsl:value-of select="style:drawing-page-properties/@svg:stroke-color"/>
                                    </演:文本和线条>
                                </xsl:if>
                                <xsl:if test="style:drawing-page-properties/@draw:shadow-color">
                                    <演:阴影 uof:locID="p0011">
                                        <xsl:value-of select="style:drawing-page-properties/@draw:shadow-color"/>
                                    </演:阴影>
                                </xsl:if>
                                <xsl:if test="style:drawing-page-properties/@svg:stroke-color">
                                <演:标题文本 uof:locID="p0012">
                                    <xsl:value-of select="style:drawing-page-properties/@svg:stroke-color"/>
                                </演:标题文本>
                                </xsl:if>
                                <xsl:if test="style:drawing-page-properties/@draw:fill-color">
                                    <演:填充 uof:locID="p0013">
                                        <xsl:value-of select="style:drawing-page-properties/@draw:fill-color"/>
                                    </演:填充>
                                </xsl:if>
                                <演:强调 uof:locID="p0014">#FFFFFF</演:强调>
                                <演:强调和超级链接 uof:locID="p0015">#FF0000</演:强调和超级链接>
                                <演:强调和尾随超级链接 uof:locID="p0016">#FF00FF</演:强调和尾随超级链接>
                                </xsl:for-each>
                            </演:配色方案>
</xsl:template>
    <xsl:template name="幻灯片序列">
        <xsl:param name="start-node"/>
        <xsl:param name="end-node"/>
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="not($start-node/@draw:name = $end-node/@draw:name)">
                <xsl:for-each select="$start-node">
                    <xsl:variable name="value1">
                        <xsl:value-of select="concat($value,@draw:name,'_',@draw:style-name,' ')"/>
                    </xsl:variable>
                    <xsl:call-template name="幻灯片序列">
                        <xsl:with-param name="start-node" select="following-sibling::node()[1]"/>
                        <xsl:with-param name="end-node" select="$end-node"/>
                        <xsl:with-param name="value" select="$value1"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($value,$start-node/@draw:name)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="字:编号格式表示">
        <xsl:param name="bubianjibie"/>
        <xsl:param name="jibie"/>
        <xsl:param name="xianshijibie"/>
        <xsl:param name="biaoshi"/>
        <xsl:choose>
            <xsl:when test="number($xianshijibie)= 1">
                <xsl:value-of select="$biaoshi"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="num-prefix">
                    <xsl:value-of select="preceding-sibling::*[number($bubianjibie -$jibie +1)]/@style:num-prefix"/>
                </xsl:variable>
                <xsl:variable name="num-suffix">
                    <xsl:value-of select="preceding-sibling::*[number($bubianjibie -$jibie +1)]/@style:num-suffix"/>
                </xsl:variable>
                <xsl:call-template name="字:编号格式表示">
                    <xsl:with-param name="bubianjibie" select="$bubianjibie"/>
                    <xsl:with-param name="jibie" select="$jibie -1"/>
                    <xsl:with-param name="xianshijibie" select="$xianshijibie -1"/>
                    <xsl:with-param name="biaoshi" select="concat($num-prefix,'%',number($jibie -1),$num-suffix,'.',$biaoshi)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="字:句属性">
        <xsl:element name="字:字体">
            <xsl:attribute name="uof:locID">t0088</xsl:attribute>
            <xsl:attribute name="uof:attrList">西文字体引用 中文字体引用 特殊字体引用 西文绘制 字号 相对字号 颜色</xsl:attribute>
            <xsl:if test=".//@fo:font-size or .//@style:font-size-asian or  .//@style:font-size-complex">
                <xsl:choose>
                    <xsl:when test="contains(.//@fo:font-size,'%') or contains(.//@style:font-size-asian,'%')">
                        <xsl:attribute name="字:相对字号"><xsl:choose><xsl:when test=".//@fo:font-size"><xsl:value-of select="substring-before(.//@fo:font-size,'%')"/></xsl:when><xsl:when test=".//@style:font-size-asian"><xsl:value-of select="substring-before(.//@style:font-size-asian,'%')"/></xsl:when></xsl:choose></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="字:字号"><xsl:choose><xsl:when test=".//@fo:font-size"><xsl:value-of select="substring-before(.//@fo:font-size,'pt')"/></xsl:when><xsl:when test=".//@style:font-size-asian"><xsl:value-of select="substring-before(.//@style:font-size-asian,'pt')"/></xsl:when><xsl:when test=".//@style:font-size-complex"><xsl:value-of select="substring-before(.//@style:font-size-complex,'pt')"/></xsl:when></xsl:choose></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test=".//@style:font-name">
                <xsl:attribute name="字:西文字体引用"><xsl:value-of select=".//@style:font-name"/></xsl:attribute>
            </xsl:if>
            <xsl:if test=".//@style:font-name-asian">
                <xsl:attribute name="字:中文字体引用"><xsl:value-of select=".//@style:font-name-asian"/></xsl:attribute>
            </xsl:if>
            <xsl:if test=".//@fo:color">
                <xsl:attribute name="字:颜色"><xsl:value-of select=".//@fo:color"/></xsl:attribute>
            </xsl:if>
        </xsl:element>
        <xsl:if test=".//@style:text-background-color and not(.//@style:text-background-color='transparent')">
            <xsl:element name="字:填充">
                <xsl:element name="图:图案">
                    <xsl:attribute name="uof:locID">g0036</xsl:attribute>
                    <xsl:attribute name="uof:attrList">类型 图形引用 前景色 背景色</xsl:attribute>
                    <xsl:if test=".//@style:text-background-color">
                        <xsl:attribute name="图:前景色"><xsl:value-of select=".//@style:text-background-color"/></xsl:attribute>
                    </xsl:if>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:font-weight or .//@style:font-weight-asian">
            <xsl:element name="字:粗体">
                <xsl:attribute name="uof:locID">t0089</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test=".//@style:font-weight-asian='bold' or .//@fo:font-weight='bold'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:font-style or .//@style:font-style-asian">
            <xsl:element name="字:斜体">
                <xsl:attribute name="uof:locID">t0090</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test=".//@fo:font-style='italic' or .//@style:font-style-asian='italic'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@style:text-crossing-out">
            <xsl:element name="字:删除线">
                <xsl:attribute name="uof:locID">t0094</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                <xsl:attribute name="字:类型"><xsl:call-template name="uof:线型类型"><xsl:with-param name="lineType" select=".//@style:text-crossing-out"/></xsl:call-template></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@style:text-underline">
            <xsl:element name="字:下划线">
                <xsl:attribute name="字:类型"><xsl:call-template name="uof:线型类型"><xsl:with-param name="lineType" select=".//@style:text-underline"/></xsl:call-template></xsl:attribute>
                <xsl:attribute name="uof:locID">t0095</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                <xsl:if test=".//@style:text-underline-color">
                    <xsl:attribute name="字:颜色"><xsl:value-of select=".//@style:text-underline-color"/></xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:text-shadow and not(.//@fo:text-shadow='none')">
            <xsl:element name="字:阴影">
                <xsl:attribute name="uof:locID">t0100</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test=".//@fo:text-shadow='none'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@style:text-emphasize">
            <xsl:element name="字:着重号">
                <xsl:attribute name="uof:locID">t0096</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型 颜色 字着重号</xsl:attribute>
                <xsl:choose>
                    <xsl:when test=".//@style:text-emphasize='none'">
                        <xsl:attribute name="字:字着重号">false</xsl:attribute>
                        <xsl:attribute name="字:类型">none</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="字:字着重号">true</xsl:attribute>
                        <xsl:attribute name="字:类型">dot</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test=".//@fo:color">
                    <xsl:attribute name="字:颜色"><xsl:value-of select=".//@fo:color"/></xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@text:display and not(.//@text:display='none')">
            <xsl:element name="字:隐藏文字">
                <xsl:attribute name="uof:locID">t0097</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值">true</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@style:text-outline and not(.//@style:text-outline='none')">
            <xsl:element name="字:空心">
                <xsl:attribute name="uof:locID">t0098</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:value-of select=".//@style:text-outline"/></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@style:font-relief and not(.//@style:font-relief='none')">
            <xsl:element name="字:浮雕">
                <xsl:attribute name="uof:locID">t0099</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                <xsl:attribute name="字:类型"><xsl:choose><xsl:when test=".//@style:font-relief='embossed'">emboss</xsl:when><xsl:when test=".//@style:font-relief='engraved'">engrave</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:text-transform or .//@fo:font-variant">
            <xsl:element name="字:醒目字体">
                <xsl:attribute name="uof:locID">t0101</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                <xsl:attribute name="字:类型"><xsl:choose><xsl:when test=".//@fo:text-transform='uppercase'">uppercase</xsl:when><xsl:when test=".//@fo:text-transform='lowercase'">lowercase</xsl:when><xsl:when test=".//@fo:text-transform='capitalize'">capital</xsl:when><xsl:when test=".//@fo:font-variant='small-caps'">small-caps</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@style:text-position">
            <xsl:element name="字:位置">
                <xsl:attribute name="uof:locID">t0102</xsl:attribute>
                <xsl:value-of select=".//@style:text-position"/>
            </xsl:element>
            <字:上下标 uof:locID="t0205" uof:attrList="值">
                <xsl:attribute name="字:值">none</xsl:attribute>
            </字:上下标>
        </xsl:if>
        <xsl:if test=".//@style:text-scale">
            <xsl:element name="字:缩放">
                <xsl:attribute name="uof:locID">t0103</xsl:attribute>
                <xsl:value-of select=".//@style:text-scale"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:letter-spacing">
            <xsl:element name="字:字符间距">
                <xsl:attribute name="uof:locID">t0104</xsl:attribute>
                <xsl:value-of select=".//@fo:letter-spacing"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@style:letter-kerning">
            <xsl:element name="字:调整字间距">
                <xsl:attribute name="uof:locID">t015</xsl:attribute>
                <xsl:value-of select=".//@style:letter-kerning"/>
            </xsl:element>
        </xsl:if>
        <xsl:element name="字:字符对齐网格">
            <xsl:attribute name="字:值">false</xsl:attribute>
            <xsl:attribute name="uof:locID">t0106</xsl:attribute>
            <xsl:attribute name="uof:attrList">值</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="style:presentation-page-layout" mode="pagestyle">
        <演:页面版式 uof:locID="p0018" uof:attrList="标识符 名称">
            <xsl:attribute name="演:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
            <xsl:attribute name="演:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
            <演:布局 uof:locID="p0129" uof:attrList="类型">
                <xsl:attribute name="演:类型">
                <xsl:variable name="layout" select="substring-after(@style:name,'T')"/>
                <xsl:choose>
                <xsl:when test="$layout='0'">title-subtitle</xsl:when><xsl:when test="$layout='1'">title-body</xsl:when><xsl:when test="$layout='19'">title-only</xsl:when><xsl:when test="$layout='12'">column-2-rows</xsl:when><xsl:when test="$layout='15'">2-rows-column</xsl:when><xsl:when test="$layout='16'">2-columns-row</xsl:when><xsl:when test="$layout='17'">2-rows</xsl:when><xsl:when test="$layout='18'">4-objects</xsl:when><xsl:when test="$layout='27'">v-2-rows</xsl:when><xsl:when test="$layout='28'">v-title-body</xsl:when><xsl:when test="$layout='29'">big-object</xsl:when><xsl:when test="$layout='30'">2-columns</xsl:when>
                    <xsl:otherwise>title-only</xsl:otherwise>
                </xsl:choose></xsl:attribute>
            </演:布局>
            <xsl:apply-templates select="presentation:placeholder" mode="anchor"/>
        </演:页面版式>
    </xsl:template>
    <xsl:template match="presentation:placeholder" mode="anchor">
        <演:占位符 uof:locID="p0130" uof:attrList="类型">
            <xsl:attribute name="演:类型"><xsl:choose><xsl:when test="@presentation:object = 'vertical_outline'">vertical_text</xsl:when><xsl:when test="@presentation:object = 'date-time'">date</xsl:when><xsl:when test="@presentation:object = 'page_number'">number</xsl:when><xsl:otherwise><xsl:value-of select="@presentation:object"/></xsl:otherwise></xsl:choose></xsl:attribute>
            <uof:锚点 uof:locID="u0064" uof:attrList="x坐标 y坐标 宽度 高度 图形引用 随动方式 缩略图 占位符">
                <xsl:attribute name="uof:x坐标"><xsl:value-of select="substring-before(@svg:x,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="uof:y坐标"><xsl:value-of select="substring-before(@svg:y,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(@svg:width,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="uof:高度"><xsl:value-of select="substring-before(@svg:height,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="uof:图形引用"><xsl:variable name="number"><xsl:value-of select="concat('_',count(preceding-sibling::presentation:placeholder))"/></xsl:variable><xsl:value-of select="concat(parent::style:presentation-page-layout/@style:name,$number)"/></xsl:attribute>
            </uof:锚点>
        </演:占位符>
    </xsl:template>
    <xsl:template match="presentation:placeholder" mode="graphic">
        <图:图形 uof:locID="g0000" uof:attrList="层次 标识符 组合列表 其他对象" 图:层次="3">
            <xsl:attribute name="图:标识符"><xsl:variable name="number"><xsl:value-of select="concat('_',count(preceding-sibling::presentation:placeholder))"/></xsl:variable><xsl:value-of select="concat(parent::style:presentation-page-layout/@style:name,$number)"/></xsl:attribute>
        </图:图形>
    </xsl:template>
    <xsl:template match="office:master-styles">
        <xsl:apply-templates select="style:handout-master"/>
        <xsl:apply-templates select="style:master-page"/>
        <xsl:if test="style:master-page/presentation:notes">
            <xsl:apply-templates select="style:master-page/presentation:notes"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="style:handout-master">
        <演:母版 uof:locID="p0036" uof:attrList="标识符 名称 类型 页面设置引用 配色方案引用 页面版式引用 文本式样引用" 演:名称="handout母版" 演:类型="handout">
            <xsl:attribute name="演:页面设置引用"><xsl:value-of select="@style:page-layout-name"/></xsl:attribute>
            <xsl:if test="@draw:style-name">
                <xsl:attribute name="演:配色方案引用"><xsl:value-of select="@draw:style-name"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@presentation:presentation-page-layout-name">
                <xsl:attribute name="演:页面版式引用"><xsl:value-of select="@presentation:presentation-page-layout-name"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="产生锚点"/>
        </演:母版>
    </xsl:template>
    <xsl:template match="style:master-page">
        <演:母版 uof:locID="p0036" uof:attrList="标识符 名称 类型 页面设置引用 配色方案引用 页面版式引用 文本式样引用" 演:名称="slide母版" 演:类型="slide">
            <xsl:attribute name="演:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
            <xsl:attribute name="演:页面设置引用"><xsl:value-of select="@style:page-layout-name"/></xsl:attribute>
            <xsl:if test="@draw:style-name">
                <xsl:attribute name="演:配色方案引用"><xsl:value-of select="@draw:style-name"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@presentation:presentation-page-layout-name">
                <xsl:attribute name="演:页面版式引用"><xsl:value-of select="@presentation:presentation-page-layout-name"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="产生锚点"/>
            <xsl:variable name="stylename">
                <xsl:value-of select="@draw:style-name"/>
            </xsl:variable>
            <xsl:variable name="name">
                <xsl:value-of select="name(.)"/>
            </xsl:variable>
            <xsl:for-each select="/office:document/*/style:style[@style:name=$stylename]/style:drawing-page-properties">
                <xsl:if test="@draw:fill and not(@draw:fill='none')">
                    <演:背景 uof:locID="p0057">
                        <xsl:call-template name="填充">
                            <xsl:with-param name="picname" select="$stylename"/>
                            <xsl:with-param name="nodename" select="$name"/>
                        </xsl:call-template>
                    </演:背景>
                </xsl:if>
            </xsl:for-each>
        </演:母版>
    </xsl:template>
    <xsl:template match="presentation:notes">
        <演:母版 uof:locID="p0036" uof:attrList="标识符 名称 类型 页面设置引用 配色方案引用 页面版式引用 文本式样引用" 演:名称="notes母版" 演:类型="notes">
            <xsl:attribute name="演:标识符"><xsl:value-of select="concat('note-',parent::style:master-page/@style:name)"/></xsl:attribute>
            <xsl:attribute name="演:页面设置引用"><xsl:value-of select="@style:page-layout-name"/></xsl:attribute>
            <xsl:if test="@draw:style-name">
                <xsl:attribute name="演:配色方案引用"><xsl:value-of select="@draw:style-name"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@presentation:presentation-page-layout-name">
                <xsl:attribute name="演:页面版式引用"><xsl:value-of select="@presentation:presentation-page-layout-name"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="产生锚点"/>
        </演:母版>
    </xsl:template>
    <xsl:template match="draw:page">
        <演:幻灯片 uof:locID="p0040" uof:attrList="名称 标识符 母版引用 配色方案引用 页面版式引用 显示 显示背景 显示背景对象">
            <xsl:attribute name="演:标识符"><xsl:value-of select="concat(@draw:name,'_',@draw:style-name)"/></xsl:attribute>
            <xsl:attribute name="演:名称"><xsl:value-of select="@draw:name"/></xsl:attribute>
            <xsl:attribute name="演:母版引用"><xsl:value-of select="@draw:master-page-name"/></xsl:attribute>
            <xsl:if test="@presentation:presentation-page-layout-name">
                <xsl:attribute name="演:页面版式引用"><xsl:value-of select="@presentation:presentation-page-layout-name"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="产生锚点"/>
            <xsl:apply-templates select="presentation:notes" mode="page"/>
            <xsl:variable name="stylename">
                <xsl:value-of select="@draw:style-name"/>
            </xsl:variable>
            <xsl:variable name="name">
                <xsl:value-of select="name(.)"/>
            </xsl:variable>
            <xsl:for-each select="/office:document/*/style:style[@style:name=$stylename]/style:drawing-page-properties">
                <xsl:if test="@draw:fill and not(@draw:fill='none')">
                    <演:背景 uof:locID="p0057">
                        <xsl:call-template name="填充">
                            <xsl:with-param name="picname" select="$stylename"/>
                            <xsl:with-param name="nodename" select="$name"/>
                        </xsl:call-template>
                    </演:背景>
                </xsl:if>
            </xsl:for-each>
            <演:切换 uof:locID="p0058" uof:attrList="效果 速度">
                <xsl:for-each select="key('graphicset',$stylename)/style:drawing-page-properties">
                    <xsl:attribute name="演:速度"><xsl:choose><xsl:when test="@presentation:transition-speed='slow'">slow</xsl:when><xsl:otherwise>fast</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="演:效果"><xsl:variable name="type"><xsl:value-of select="@smil:type"/></xsl:variable><xsl:variable name="subtype"><xsl:value-of select="@smil:subtype"/></xsl:variable><xsl:choose><xsl:when test="$type='irisWipe' and $subtype='rectangle' and @smil:direction='reverse'">box in</xsl:when><xsl:when test="$type='irisWipe' and $subtype='rectangle'">box out</xsl:when><xsl:when test="$type='checkerBoardWipe' and $subtype='across'">checkerboard across</xsl:when><xsl:when test="$type='checkerBoardWipe' and $subtype='down'">checkerboard down</xsl:when><xsl:when test="$type='pushWipe' and $subtype='combHorizontal'">comb horizontal</xsl:when><xsl:when test="$type='pushWipe' and $subtype='combVertical'">comb vertical</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromTop' and @smil:direction='reverse'">uncover down</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromRight' and @smil:direction='reverse'">uncover left</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromLeft' and @smil:direction='reverse'">uncover right</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromBottom' and @smil:direction='reverse'">uncover up</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromTopRight' and @smil:direction='reverse'">uncover left-down</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromBottomRight' and @smil:direction='reverse'">uncover left-up</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromTopLeft' and @smil:direction='reverse'">uncover right-down</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromBottomLeft' and @smil:direction='reverse'">uncover right-up</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromTop'">cover down</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromRight'">cover left</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromLeft'">cover right</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromBottom'">cover up</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromTopRight'">cover left-down</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromBottomRight'">cover left-up</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromTopLeft'">cover right-down</xsl:when><xsl:when test="$type='slideWipe' and $subtype='fromBottomLeft'">cover right-up</xsl:when><xsl:when test="$type='fade' and $subtype='fadeOverColor'">fade through black</xsl:when><xsl:when test="$type='pushWipe' and $subtype='fromTop'">push down</xsl:when><xsl:when test="$type='pushWipe' and $subtype='fromRight'">push left</xsl:when><xsl:when test="$type='pushWipe' and $subtype='fromLeft'">push right</xsl:when><xsl:when test="$type='pushWipe' and $subtype='fromBottom'">push up</xsl:when><xsl:when test="$type='randomBarWipe' and $subtype='horizontal'">random bars horizontal</xsl:when><xsl:when test="$type='randomBarWipe' and $subtype='vertical'">random bars vertical</xsl:when><xsl:when test="$type='ellipseWipe' and $subtype='circle'">shape circle</xsl:when><xsl:when test="$type='irisWipe' and $subtype='diamond'">shape diamond</xsl:when><xsl:when test="$type='fourBoxWipe' and $subtype='cornersOut'">shape plus</xsl:when><xsl:when test="$type='barnDoorWipe' and $subtype='horizontal' and @smil:direction='reverse'">split horizontal in</xsl:when><xsl:when test="$type='barnDoorWipe' and $subtype='horizontal'">split horizontal out</xsl:when><xsl:when test="$type='barnDoorWipe' and $subtype='vertical' and @smil:direction='reverse'">split vertical in</xsl:when><xsl:when test="$type='barnDoorWipe' and $subtype='vertical'">split vertical out</xsl:when><xsl:when test="$type='fanWipe' and $subtype='centerTop'">wedge</xsl:when><xsl:when test="$type='pinWheelWipe' and $subtype='oneBlade'">wheel clockwise – 1 spoke</xsl:when><xsl:when test="$type='pinWheelWipe' and $subtype='twoBladeVertical'">wheel clockwise – 2 spoke</xsl:when><xsl:when test="$type='pinWheelWipe' and $subtype='threeBlade'">wheel clockwise – 3 spoke</xsl:when><xsl:when test="$type='pinWheelWipe' and $subtype='fourBlade'">wheel clockwise – 4 spoke</xsl:when><xsl:when test="$type='pinWheelWipe' and $subtype='eightBlade'">wheel clockwise – 8 spoke</xsl:when><xsl:when test="$type='barWipe' and $subtype='leftToRight' and @smil:direction='reverse'">wipe left</xsl:when><xsl:when test="$type='barWipe' and $subtype='leftToRight'">wipe right</xsl:when><xsl:when test="$type='barWipe' and $subtype='topToBottom' and @smil:direction='reverse'">wipe up</xsl:when><xsl:when test="$type='barWipe' and $subtype='topToBottom'">wipe down</xsl:when><xsl:when test="$type='blindsWipe' and $subtype='vertical'">blinds vertical</xsl:when><xsl:when test="$type='blindsWipe' and $subtype='horizontal'">blinds horizontal</xsl:when><xsl:when test="$type='dissolve'">dissolve</xsl:when><xsl:when test="$type='random'">random transition</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    <演:声音 uof:locID="p0061" uof:attrList="预定义声音 自定义声音">
                        <xsl:choose>
                            <xsl:when test="not(presentation:sound)">
                                <xsl:attribute name="演:预定义声音">none</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="lujing">
                                    <xsl:value-of select="substring-after(presentation:sound/@xlink:href,'share/gallery/sounds/')"/>
                                </xsl:variable>
                                <xsl:variable name="ming">
                                    <xsl:value-of select="substring-before($lujing,'.wav')"/>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="$ming='applause'">
                                        <xsl:attribute name="演:预定义声音">applause</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="$ming='explos'">
                                        <xsl:attribute name="演:预定义声音">explosion</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="$ming='laser'">
                                        <xsl:attribute name="演:预定义声音">laser</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="演:自定义声音"><xsl:value-of select="presentation:sound/@xlink:href"/></xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </演:声音>
                    <演:方式 uof:locID="p0062">
                        <演:单击鼠标 uof:locID="p0065">
                            <xsl:choose>
                                <xsl:when test="@presentation:transition-type='automatic'">false</xsl:when>
                                <xsl:otherwise>true</xsl:otherwise>
                            </xsl:choose>
                        </演:单击鼠标>
                        <xsl:if test="@presentation:duration">
                            <演:时间间隔 uof:locID="p0066">
                                <xsl:variable name="hms">
                                    <xsl:value-of select="substring-after(@presentation:duration,'PT')"/>
                                </xsl:variable>
                                <xsl:variable name="h">
                                    <xsl:value-of select="number(substring-before($hms,'H'))"/>
                                </xsl:variable>
                                <xsl:variable name="ms">
                                    <xsl:value-of select="substring-after($hms,'H')"/>
                                </xsl:variable>
                                <xsl:variable name="m">
                                    <xsl:value-of select="number(substring-before($ms,'M'))"/>
                                </xsl:variable>
                                <xsl:variable name="s">
                                    <xsl:value-of select="number(substring-before(substring-after($ms,'M'),'S'))"/>
                                </xsl:variable>
                                <xsl:value-of select="$h *3600 + $m * 60 + $s"/>
                            </演:时间间隔>
                        </xsl:if>
                    </演:方式>
                </xsl:for-each>
            </演:切换>
        </演:幻灯片>
    </xsl:template>
    <xsl:template match="presentation:notes" mode="page">
        <演:幻灯片备注 uof:locID="p0054" uof:attrList="备注母版引用">
            <xsl:attribute name="演:备注母版引用"><xsl:variable name="cute"><xsl:value-of select="parent::node()/@draw:master-page-name"/></xsl:variable><xsl:value-of select="concat('note-',$cute)"/></xsl:attribute>
            <xsl:call-template name="产生锚点"/>
            <演:背景 uof:locID="p0057">
               <图:颜色 uof:locID="g0034">#ffffff</图:颜色>
            </演:背景>
        </演:幻灯片备注>
    </xsl:template>
    <xsl:template name="产生锚点">
        <xsl:for-each select="child::node( )">
            <xsl:choose>
                <xsl:when test="substring-before(name(),':')='draw'">
                    <uof:锚点 uof:locID="u0064" uof:attrList="x坐标 y坐标 宽度 高度 图形引用 随动方式 缩略图 占位符">
                        <xsl:variable name="nodename">
                            <xsl:value-of select="name(.)"/>
                        </xsl:variable>
                        <xsl:variable name="refpicname">
                            <xsl:choose>
                                <xsl:when test="@draw:style-name">
                                    <xsl:value-of select="@draw:style-name"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@presentation:style-name"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="picnumber">
                            <xsl:choose>
                                <xsl:when test="@draw:style-name">
                                    <xsl:value-of select="count(preceding::*[@draw:style-name=$refpicname])"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="count(preceding::*[@presentation:style-name=$refpicname])"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:attribute name="uof:x坐标"><xsl:choose><xsl:when test="name(.)='draw:g'"><xsl:call-template name="groupminx"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:x][1]/@svg:x,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="@svg:x"><xsl:value-of select="substring-before(@svg:x,$uofUnit)"/></xsl:when><xsl:when test="@svg:x1"><xsl:value-of select="substring-before(@svg:x1,$uofUnit)"/></xsl:when></xsl:choose></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:y坐标"><xsl:choose><xsl:when test="name(.)='draw:g'"><xsl:call-template name="groupminx"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:y][1]/@svg:y,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="@svg:y"><xsl:value-of select="substring-before(@svg:y,$uofUnit)"/></xsl:when><xsl:when test="@svg:y1"><xsl:value-of select="substring-before(@svg:y1,$uofUnit)"/></xsl:when></xsl:choose></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:宽度"><xsl:choose><xsl:when test="@svg:width"><xsl:value-of select="substring-before(@svg:width,$uofUnit)"/></xsl:when><xsl:when test="@svg:x1"><xsl:value-of select="substring-before(@svg:x2,$uofUnit) - substring-before(@svg:x1,$uofUnit)"/></xsl:when><xsl:when test="name(.)='draw:g'"><xsl:variable name="minx"><xsl:call-template name="groupminx"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:x][1]/@svg:x,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable><xsl:variable name="svgx"><xsl:value-of select="number(substring-before(descendant::node()[@svg:x][1]/@svg:x,$uofUnit))"/></xsl:variable><xsl:variable name="width"><xsl:value-of select="number(substring-before(descendant::node()[@svg:x][1]/@svg:width,$uofUnit))"/></xsl:variable><xsl:variable name="maxx"><xsl:call-template name="groupmaxx"><xsl:with-param name="value" select="$svgx + $width"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable><xsl:value-of select="$maxx - $minx"/></xsl:when></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:高度"><xsl:choose><xsl:when test="@svg:height"><xsl:value-of select="substring-before(@svg:height,$uofUnit)"/></xsl:when><xsl:when test="@svg:x1"><xsl:value-of select="substring-before(@svg:y2,$uofUnit) - substring-before(@svg:y1,$uofUnit)"/></xsl:when><xsl:when test="name(.)='draw:g'"><xsl:variable name="miny"><xsl:call-template name="groupminy"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:y][1]/@svg:y,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable><xsl:variable name="svgy"><xsl:value-of select="number(substring-before(descendant::node()[@svg:y][1]/@svg:y,$uofUnit))"/></xsl:variable><xsl:variable name="height"><xsl:value-of select="number(substring-before(descendant::node()[@svg:y][1]/@svg:height,$uofUnit))"/></xsl:variable><xsl:variable name="maxy"><xsl:call-template name="groupmaxy"><xsl:with-param name="value" select="$svgy + $height"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable><xsl:value-of select="$maxy - $miny"/></xsl:when></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:图形引用"><xsl:choose><xsl:when test="@draw:id"><xsl:value-of select="@draw:id"/></xsl:when><xsl:when test="not(@draw:style-name) and name()='draw:g'"><xsl:value-of select="concat(child::node()[1]/@draw:style-name,'_',$picnumber)"/></xsl:when><xsl:otherwise><xsl:value-of select="concat($refpicname,'_',$picnumber)"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:随动方式"><xsl:choose><xsl:when test="key('graphicset',$refpicname)/node()/@style:protect"><xsl:for-each select="key('graphicset',$refpicname)/node()"><xsl:choose><xsl:when test="@style:protect='size'">move</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:for-each></xsl:when><xsl:otherwise>movesize</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:if test="name(.)='draw:page-thumbnail'">
                            <xsl:attribute name="uof:缩略图">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="not(name(parent::node())='style:handout-master')">
                        <xsl:attribute name="uof:占位符"><xsl:choose><xsl:when test="@presentation:object"><xsl:value-of select="@presentation:object"/></xsl:when><xsl:when test=".//draw:image">graphic</xsl:when></xsl:choose></xsl:attribute>
                        <xsl:if test="@presentation:class">
                            <xsl:attribute name="uof:占位符"><xsl:value-of select="@presentation:class"/></xsl:attribute>
                        </xsl:if>
                        </xsl:if>
                    </uof:锚点>
                </xsl:when>
                <xsl:when test="name()= 'anim:par'">
                    <演:动画 uof:locID="p0042">
                        <xsl:apply-templates select="anim:seq"/>
                    </演:动画>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="anim:seq">
        <xsl:apply-templates select="anim:par/anim:par/anim:par"/>
        <xsl:apply-templates select="anim:par/anim:par/anim:iterate"/>
    </xsl:template>
    <xsl:template match="anim:par | anim:iterate">
        <演:序列 uof:locID="p0043" uof:attrList="段落引用 动画对象">
            <xsl:attribute name="演:动画对象"><xsl:choose>
            <xsl:when test=".//@smil:targetElement"><xsl:value-of select=".//@smil:targetElement"/></xsl:when><xsl:when test="@anim:id"><xsl:value-of select="@anim:id"/></xsl:when><xsl:otherwise><xsl:value-of select="../@smil:targetElement"/></xsl:otherwise></xsl:choose></xsl:attribute>

            <演:定时 uof:locID="p0067" uof:attrList="事件 延时 速度 重复 回卷">
                <xsl:attribute name="演:事件">
                <xsl:choose>
                    <xsl:when test="@presentation:node-type='on-click'">on click</xsl:when>
                    <xsl:when test="@presentation:node-type='with-previous'">with previous</xsl:when>
                    <xsl:otherwise><xsl:value-of select="@presentation:node-type"/></xsl:otherwise>
                </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="演:延时"><xsl:value-of select="substring-before(@smil:begin,'s')"/></xsl:attribute>
                <xsl:attribute name="演:速度"><xsl:choose><xsl:when test="anim:animate/@smil:dur='0.5s'">very fast</xsl:when><xsl:when test="anim:animate/@smil:dur='1s'">fast</xsl:when><xsl:when test="anim:animate/@smil:dur='2s'">medium</xsl:when><xsl:when test="anim:animate/@smil:dur='3s'">slow</xsl:when><xsl:when test="anim:animate/@smil:dur='5s'">very slow</xsl:when><xsl:otherwise>medium</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="演:重复"><xsl:choose><xsl:when test="@smil:repeatCount = 'indefinite' "><xsl:choose><xsl:when test="@smil:end='next'">until next click</xsl:when><xsl:otherwise>until next slide</xsl:otherwise></xsl:choose></xsl:when><xsl:when test="@smil:repeatCount ='2' or @smil:repeatCount ='3' or @smil:repeatCount ='4' or @smil:repeatCount ='5' or @smil:repeatCount ='10' "><xsl:value-of select="@smil:repeatCount"/></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="演:回卷"><xsl:choose><xsl:when test="@smil:fill='remove'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </演:定时>
            <演:增强 uof:locID="p0068">
                <演:动画播放后 uof:locID="p0070" uof:attrList="颜色 变暗 播放后隐藏 单击后隐藏">
                    <xsl:if test="../anim:animateColor">
                        <xsl:attribute name="演:颜色"><xsl:value-of select="../anim:animateColor/@smil:to"/></xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="../anim:animateColor">
                            <xsl:attribute name="演:变暗">true</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="演:变暗">false</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="@presentation:preset-property='Direction;Accelerate;Decelerate' ">
                            <xsl:attribute name="演:播放后隐藏">true</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="演:播放后隐藏">false</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="../anim:set/@smil:to">
                            <xsl:attribute name="演:单击后隐藏">true</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="演:单击后隐藏">false</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </演:动画播放后>
                    <演:动画文本 uof:locID="p0071" uof:attrList="发送 间隔 动画形状 相反顺序">
                        <xsl:attribute name="演:发送"><xsl:choose><xsl:when test="@anim:iterate-type = 'by-word' ">by word</xsl:when><xsl:when test="@anim:iterate-type = 'by-letter' ">by letter</xsl:when><xsl:otherwise>all at once</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="演:间隔"><xsl:choose><xsl:when test="@anim:iterate-interval"><xsl:value-of select="substring-before(@anim:iterate-interval,'s')"/>
</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="演:动画形状">false</xsl:attribute>
                        <xsl:attribute name="演:相反顺序">false</xsl:attribute>
                    </演:动画文本>
                <xsl:if test="anim:audio">
                    <演:声音 uof:locID="p0061" uof:attrList="预定义声音 自定义声音">
                        <xsl:variable name="audioname">
                            <xsl:value-of select="substring-after(anim:audio/@xlink:href,'gallery/sounds/')"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="not($audioname='')">
                                <xsl:attribute name="演:预定义声音"><xsl:choose><xsl:when test="anim:audio/@xlink:href"><xsl:value-of select="anim:audio/@xlink:href"/></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="演:自定义声音"><xsl:value-of select="anim:audio/@xlink:href"/></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </演:声音>
                </xsl:if>
            </演:增强>
            <演:效果 uof:locID="p0069">
                <xsl:choose>
                    <xsl:when test="./@presentation:preset-class = 'entrance'">
                        <演:进入 uof:locID="p0073">
                            <xsl:apply-templates select="@presentation:preset-id"/>
                        </演:进入>
                    </xsl:when>
                    <xsl:when test="./@presentation:preset-class = 'exit'">
                        <演:退出 uof:locID="p0074">
                            <xsl:apply-templates select="@presentation:preset-id"/>
                        </演:退出>
                    </xsl:when>
                    <xsl:when test="./@presentation:preset-class = 'emphasis' ">
                        <演:强调 uof:locID="p0075">
                            <xsl:apply-templates select="@presentation:preset-id"/>
                        </演:强调>
                    </xsl:when>
                    <xsl:otherwise>
                        <演:动作路径 uof:locID="p0133" uof:attrList="路径">
                            <xsl:attribute name="演:路径">
                                <xsl:value-of select="anim:animateMotion/@svg:path"/>
                            </xsl:attribute>
                        </演:动作路径>
                    </xsl:otherwise>
                </xsl:choose>
            </演:效果>
        </演:序列>
    </xsl:template>
    <xsl:template name="anim_speed">
        <xsl:param name="speed"/>
        <xsl:choose>
            <xsl:when test="$speed='0.5s' or $speed='0.25s'">very fast</xsl:when>
            <xsl:when test="$speed='1s'">fast</xsl:when>
            <xsl:when test="$speed='2s'">medium</xsl:when>
            <xsl:when test="$speed='3s'">slow</xsl:when>
            <xsl:when test="$speed='5s'">very slow</xsl:when>
            <xsl:otherwise>medium</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-venetian-blinds']">
        <演:百叶窗 uof:locID="p0080" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:百叶窗>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-appear']">
        <演:出现 uof:locID="p0081">
    </演:出现>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-box']">
        <演:盒状 uof:locID="p0082" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:盒状>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-diagonal-squares']">
        <演:阶梯状 uof:locID="p0083" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:choose><xsl:when test="../@presentation:preset-sub-type = 'left-to-bottom' ">left down</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'left-to-top' ">left up</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'right-to-bottom' ">right down</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'right-to-top' ">right up</xsl:when></xsl:choose></xsl:attribute>
        </演:阶梯状>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-wheel']">
        <演:轮子 uof:locID="p0084" uof:attrList="速度 辐射状">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:辐射状"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:轮子>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-checkerboard']">
        <演:棋盘 uof:locID="p0085" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:subtype"/></xsl:attribute>
        </演:棋盘>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-flash-once']">
        <演:闪烁一次 uof:locID="p0086" uof:attrList="速度">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:set/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
        </演:闪烁一次>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-plus']">
        <演:十字形扩展 uof:locID="p0087" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:十字形扩展>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-random']">
        <演:随机效果 uof:locID="p0088">
        </演:随机效果>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-circle']">
        <演:圆形扩展 uof:locID="p0089" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:圆形扩展>
    </xsl:template>
        <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-wipe']">
        <演:擦除 uof:locID="p0090" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:choose><xsl:when test="../@presentation:preset-sub-type = 'from-right'">from right</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-left'">from left</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-top'">from top</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-bottom'">from bottom</xsl:when></xsl:choose></xsl:attribute>
        </演:擦除>
    </xsl:template>
        <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-fly-in']">
        <演:飞入 uof:locID="p0091" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:animate/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:choose><xsl:when test="../@presentation:preset-sub-type = 'from-bottom'">from bottom</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-top-right'">from top-right</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-top-left'">from top-left</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-bottom-left'">from bottom-left</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-bottom-right'">from bottom-right</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-right'">from right</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-left'">from left</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-top'">from top</xsl:when></xsl:choose></xsl:attribute>
        </演:飞入>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-fly-in-slow']">
        <演:缓慢飞入 uof:locID="p0092" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:animate/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:choose><xsl:when test="../@presentation:preset-sub-type = 'from-right'">from right</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-left'">from left</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-top'">from top</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-bottom'">from bottom</xsl:when></xsl:choose></xsl:attribute>
        </演:缓慢飞入>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-diamond']">
        <演:菱形 uof:locID="p0093" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:菱形>
    </xsl:template>
        <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-split']">
        <演:劈裂 uof:locID="p0094" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:choose><xsl:when test="../@presentation:preset-sub-type = 'horizontal-out'">horizontal out</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'horizontal-in'">horizontal in</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'vertical-in'">vertical in</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'vertical-out'">vertical out</xsl:when></xsl:choose></xsl:attribute>
        </演:劈裂>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-peek-in']">
        <演:切入 uof:locID="p0095" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:choose><xsl:when test="../@presentation:preset-sub-type = 'from-right'">from right</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-left'">from left</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-top'">from top</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-bottom'">from bottom</xsl:when></xsl:choose></xsl:attribute>
        </演:切入>
    </xsl:template>
        <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-wedge']">
        <演:扇形展开 uof:locID="p0096" uof:attrList="速度">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
        </演:扇形展开>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-random-bars']">
        <演:随机线条 uof:locID="p0097" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:随机线条>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-dissolve-in']">
        <演:向内溶解 uof:locID="p0098" uof:attrList="速度">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
        </演:向内溶解>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-boomerang']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-bounce']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-curve-up']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-falling-in']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-flip']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-float']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-fold']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-glide']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-magnify']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-movie-credits']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-pinwheel']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-breaks']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-sling']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-spiral-in']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-swivel']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-thread']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-whip']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'oooo-entrance-ascend']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-center-revolve']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-colored-lettering']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-compress']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-descend']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-ease-in']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-rise-up']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-spin-in']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-stretchy']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-turn-and-grow']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-unfold']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-colored-lettering']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-expand']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-fade-in']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-fade-in-and-swivel']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-entrance-fade-in-and-zoom']">
        <演:其他 uof:locID="p0099">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-fill-color']">
        <演:更改填充颜色 uof:locID="p0124" uof:attrList="速度 颜色">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="../anim:animateColor/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:颜色"><xsl:value-of select="../anim:animateColor/@smil:to"/></xsl:attribute>
        </演:更改填充颜色>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-font-color']">
        <演:更改字体颜色 uof:locID="p0126" uof:attrList="速度 颜色">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="../anim:animateColor/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:颜色"><xsl:value-of select="../anim:animateColor/@smil:to"/></xsl:attribute>
        </演:更改字体颜色>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-grow-and-shrink']">
        <演:缩放 uof:locID="p0120" uof:attrList="速度 方向 预定义尺寸 自定义尺寸">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="../anim:animateTransform/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向">horizontal</xsl:attribute>
            <xsl:choose>
                <xsl:when test="../anim:animateTransform/@smil:to='0.25,1' ">
                    <xsl:attribute name="演:预定义尺寸">tiny</xsl:attribute>
                </xsl:when>
                <xsl:when test="../anim:animateTransform/@smil:to='0.5,1' ">
                    <xsl:attribute name="演:预定义尺寸">smaller</xsl:attribute>
                </xsl:when>
                <xsl:when test="../anim:animateTransform/@smil:to='1.5,1' ">
                    <xsl:attribute name="演:预定义尺寸">larger</xsl:attribute>
                </xsl:when>
                <xsl:when test="../anim:animateTransform/@smil:to='4,1' ">
                    <xsl:attribute name="演:预定义尺寸">huge</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="演:自定义尺寸"><xsl:choose><xsl:when test="../anim:animateTransform/@smil:to"><xsl:value-of select="../anim:animateTransform/@smil:to"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </演:缩放>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-font-size']">
        <演:更改字号 uof:locID="p0125" uof:attrList="速度 预定义尺寸 自定义尺寸">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="../anim:animate/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:choose>
                <xsl:when test="parent::anim:par/anim:animate/@smil:to='0.25,1' ">
                    <xsl:attribute name="演:预定义尺寸">tiny</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::anim:par/anim:animate/@smil:to='0.5,1' ">
                    <xsl:attribute name="演:预定义尺寸">smaller</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::anim:par/anim:animate/@smil:to='1.5,1' ">
                    <xsl:attribute name="演:预定义尺寸">larger</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::anim:par/anim:animate/@smil:to='4,1' ">
                    <xsl:attribute name="演:预定义尺寸">huge</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="演:自定义尺寸"><xsl:choose><xsl:when test="parent::anim:par/anim:animate/@smil:to"><xsl:value-of select="parent::anim:par/anim:animate/@smil:to"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </演:更改字号>
    </xsl:template>
    <xsl:template name="getfontstyle_emphasis">
        <xsl:value-of select="concat(@smil:to,' ')"/>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-font-style']">
        <演:更改字形 uof:locID="p0122" uof:attrList="字形 期间">
            <xsl:attribute name="演:字形"><xsl:variable name="fontstyle"><xsl:for-each select="../anim:set"><xsl:call-template name="getfontstyle_emphasis"/></xsl:for-each></xsl:variable><xsl:value-of select="$fontstyle"/></xsl:attribute>
            <xsl:attribute name="演:期间"><xsl:choose><xsl:when test="../@smil:repeatCount = 'indefinite' "><xsl:choose><xsl:when test="../@smil:end='next'">until next click</xsl:when><xsl:otherwise>until next slide</xsl:otherwise></xsl:choose></xsl:when><xsl:when test="../@smil:repeatCount ='2' or ../@smil:repeatCount ='3' or ../@smil:repeatCount ='4' or ../@smil:repeatCount ='5' or ../@smil:repeatCount ='10'"><xsl:value-of select="../@smil:repeatCount"/></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
        </演:更改字形>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-line-color']">
        <演:更改线条颜色 uof:locID="p0121" uof:attrList="速度 颜色">
            <xsl:attribute name="演:速度">medium</xsl:attribute>
            <xsl:attribute name="演:颜色"><xsl:value-of select="../anim:animateColor/@smil:to"/></xsl:attribute>
        </演:更改线条颜色>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-spin']">
        <演:陀螺旋 uof:locID="p0123" uof:attrList="速度 顺时针方向 预定义角度 自定义角度">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:animateTransform/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:顺时针方向">true</xsl:attribute>
            <xsl:choose>
                <xsl:when test="parent::anim:par/anim:animateTransform/@smil:by='90'">
                    <xsl:attribute name="演:预定义角度">quarter spin</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::anim:par/anim:animateTransform/@smil:by='180'">
                    <xsl:attribute name="演:预定义角度">half spin</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::anim:par/anim:animateTransform/@smil:by='360'">
                    <xsl:attribute name="演:预定义角度">full spin</xsl:attribute>
                </xsl:when>
                <xsl:when test="parent::anim:par/anim:animateTransform/@smil:by='720'">
                    <xsl:attribute name="演:预定义角度">two spins</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="演:自定义角度"><xsl:value-of select="parent::anim:par/anim:animateTransform/@smil:by"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </演:陀螺旋>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-transparency']">
        <演:透明 uof:locID="p0127" uof:attrList="预定义透明度 自定义透明度 期间">
            <xsl:choose>
                <xsl:when test="../anim:set/@smil:to='0.25' ">
                    <xsl:attribute name="演:预定义透明度">25</xsl:attribute>
                </xsl:when>
                <xsl:when test="../anim:set/@smil:to='0.5' ">
                    <xsl:attribute name="演:预定义透明度">50</xsl:attribute>
                </xsl:when>
                <xsl:when test="../anim:set/@smil:to='0.75' ">
                    <xsl:attribute name="演:预定义透明度">75</xsl:attribute>
                </xsl:when>
                <xsl:when test="../anim:set/@smil:to='1' ">
                    <xsl:attribute name="演:预定义透明度">100</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="演:自定义透明度"><xsl:value-of select="../anim:set/@smil:to"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="演:期间"><xsl:choose><xsl:when test="../@smil:repeatCount = 'indefinite' "><xsl:choose><xsl:when test="../@smil:end='next'">until next click</xsl:when><xsl:otherwise>until next slide</xsl:otherwise></xsl:choose></xsl:when><xsl:when test="../@smil:repeatCount ='2' or ../@smil:repeatCount ='3' or ../@smil:repeatCount ='4' or ../@smil:repeatCount ='5' or ../@smil:repeatCount ='10'"><xsl:value-of select="../@smil:repeatCount"/></xsl:when><xsl:otherwise>until next click</xsl:otherwise></xsl:choose></xsl:attribute>
        </演:透明>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-font']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-blast']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-blink']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-bold-reveal']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-style-emphasis']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-wave']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-flicker']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-grow-with-color']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-shimmer']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-teeter']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-bold-flash']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-color-blend']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-color-over-by-letter']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-color-over-by-word']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-complementary-color']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-complementary-color-2']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-contrasting-color']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-darken']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-desaturate']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-flash-bulb']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-lighten']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-emphasis-reveal-underline']">
        <演:其他 uof:locID="p0128">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-box']">
        <演:盒状 uof:locID="p0111" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:盒状>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-checkerboard']">
        <演:棋盘 uof:locID="p0114" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:subtype"/></xsl:attribute>
        </演:棋盘>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-circle']">
        <演:圆形扩展 uof:locID="p0109" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:圆形扩展>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-crawl-out']">
        <演:缓慢移出 uof:locID="p0102" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="../anim:animate/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:choose><xsl:when test="../@presentation:preset-sub-type = 'from-right'">to right</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-left'">to left</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-top'">to top</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-bottom'">to bottom</xsl:when></xsl:choose></xsl:attribute>
        </演:缓慢移出>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-diagonal-squares']">
        <演:阶梯状 uof:locID="p0112" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:choose><xsl:when test="../@presentation:preset-sub-type = 'left-to-bottom' ">left down</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'left-to-top' ">left up</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'right-to-bottom' ">right down</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'right-to-top' ">right up</xsl:when></xsl:choose></xsl:attribute>
        </演:阶梯状>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-diamond']">
        <演:菱形 uof:locID="p0103" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:菱形>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-disappear']">
        <演:消失 uof:locID="p0118">
         </演:消失>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-dissolve']">
        <演:向外溶解 uof:locID="p0108" uof:attrList="速度">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
        </演:向外溶解>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-flash-once']">
        <演:闪烁一次 uof:locID="p0115" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="../anim:animate/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
        </演:闪烁一次>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-fly-out']">
        <演:飞出 uof:locID="p0101" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="../anim:animate/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:choose><xsl:when test="../@presentation:preset-sub-type = 'from-bottom'">to bottom</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-top-right'">to top-right</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-top-left'">to top-left</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-bottom-left'">to bottom-left</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-bottom-right'">to bottom-right</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-right'">to right</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-left'">to left</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-top'">to top</xsl:when></xsl:choose></xsl:attribute>
        </演:飞出>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-peek-out']">
        <演:切出 uof:locID="p0105" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:choose><xsl:when test="../@presentation:preset-sub-type = 'from-right'">to right</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-left'">to left</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-top'">to top</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-bottom'">to bottom</xsl:when></xsl:choose></xsl:attribute>
        </演:切出>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-plus']">
        <演:十字形扩展 uof:locID="p0116" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:十字形扩展>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-random-bars']">
        <演:随机线条 uof:locID="p0107" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:随机线条>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-random']">
        <演:随机效果 uof:locID="p0117">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:choose><xsl:when test="parent::anim:par/anim:transitionFilter/@smil:dur"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:when><xsl:otherwise><xsl:value-of select="../anim:animate/@smil:dur"/></xsl:otherwise></xsl:choose></xsl:with-param></xsl:call-template></xsl:attribute>
        </演:随机效果>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-split']">
        <演:劈裂 uof:locID="p0104" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:choose><xsl:when test="../@presentation:preset-sub-type = 'horizontal-out'">horizontal out</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'horizontal-in'">horizontal in</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'vertical-in'">vertical in</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'vertical-out'">vertical out</xsl:when></xsl:choose></xsl:attribute>
        </演:劈裂>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-venetian-blinds']">
        <演:百叶窗 uof:locID="p0100" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:百叶窗>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-wedge']">
        <演:扇形展开 uof:locID="p0106" uof:attrList="速度">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
        </演:扇形展开>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-wheel']">
        <演:轮子 uof:locID="p0113" uof:attrList="速度 轮辐">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:轮辐"><xsl:value-of select="../@presentation:preset-sub-type"/></xsl:attribute>
        </演:轮子>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-wipe']">
        <演:擦除 uof:locID="p0110" uof:attrList="速度 方向">
            <xsl:attribute name="演:速度"><xsl:call-template name="anim_speed"><xsl:with-param name="speed"><xsl:value-of select="parent::anim:par/anim:transitionFilter/@smil:dur"/></xsl:with-param></xsl:call-template></xsl:attribute>
            <xsl:attribute name="演:方向"><xsl:choose><xsl:when test="../@presentation:preset-sub-type = 'from-right'">from right</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-left'">from left</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-top'">from top</xsl:when><xsl:when test="../@presentation:preset-sub-type = 'from-bottom'">from bottom</xsl:when></xsl:choose></xsl:attribute>
        </演:擦除>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-boomerang']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-bounce']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-curve-down']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-flip']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-float']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-fold']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-glide']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-magnify']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-movie-credits']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-pinwheel']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-breaks']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-sling']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-swish']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-swivel']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-thread']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-whip']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-ascend']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-center-revolve']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-collapse']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-colored-lettering']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-descend']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-ease-out']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-sink-down']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-spin-out']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-stretchy']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-turn-and-grow ']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-unfold']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-zoom']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-contract']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-fade-out']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-fade-out-and-swivel']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="@presentation:preset-id[. = 'ooo-exit-fade-out-and-zoom']">
        <演:其他 uof:locID="p0119">
            <xsl:copy-of select="parent::node()"/>
        </演:其他>
    </xsl:template>
    <xsl:template match="draw:page" mode="styles">
        <xsl:call-template name="creategraphicstyles"/>
    </xsl:template>
    <xsl:template match="style:handout-master" mode="styles">
        <xsl:call-template name="creategraphicstyles"/>
    </xsl:template>
    <xsl:template match="style:master-page" mode="styles">
        <xsl:apply-templates select="presentation:notes" mode="styles"/>
        <xsl:call-template name="creategraphicstyles"/>
    </xsl:template>
    <xsl:template match="presentation:notes" mode="styles">
        <xsl:call-template name="creategraphicstyles"/>
    </xsl:template>
    <xsl:template name="creategraphicstyles">
        <xsl:for-each select="node()">
            <xsl:variable name="nodename1">
                <xsl:value-of select="name()"/>
            </xsl:variable>
            <xsl:if test="(substring-before($nodename1,':') = 'draw')">
                <xsl:call-template name="draw">
                    <xsl:with-param name="nodename1" select="$nodename1"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="draw">
        <xsl:param name="nodename1"/>
        <xsl:choose>
            <xsl:when test="substring-after($nodename1,':') = 'a'">
                <xsl:for-each select="child::*">
                    <xsl:call-template name="draw">
                        <xsl:with-param name="nodename">
                            <xsl:value-of select="name()"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="substring-after($nodename1,':') = 'g'">
                <xsl:call-template name="draw:g"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="creategraphic"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="draw:g">
        <xsl:for-each select="child::*">
            <xsl:choose>
                <xsl:when test="name()='draw:g'">
                    <xsl:call-template name="draw:g"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="creategraphic"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:call-template name="creategraphic"/>
    </xsl:template>
    <xsl:template name="zuheliebiao">
        <xsl:param name="allnode"/>
        <xsl:param name="pos"/>
        <xsl:choose>
            <xsl:when test="../child::*[$pos]">
                <xsl:for-each select="../child::*[$pos]">
                    <xsl:variable name="nodepos">
                        <xsl:value-of select="@draw:style-name"/>
                    </xsl:variable>
                    <xsl:variable name="picnumber1">
                        <xsl:value-of select="count(preceding::*[@draw:style-name=$nodepos])"/>
                    </xsl:variable>
                    <xsl:variable name="pic-name1">
                        <xsl:value-of select="concat($nodepos,'_',$picnumber1)"/>
                    </xsl:variable>
                    <xsl:variable name="allnode1">
                        <xsl:value-of select="concat($allnode,',',$pic-name1)"/>
                    </xsl:variable>
                    <xsl:call-template name="zuheliebiao">
                        <xsl:with-param name="allnode" select="$allnode1"/>
                        <xsl:with-param name="pos" select="$pos+1"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$allnode"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="creategraphic">
        <xsl:variable name="nodename">
            <xsl:value-of select="name()"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@draw:style-name or name()='draw:g'">
                <xsl:variable name="pic-name">
                    <xsl:value-of select="@draw:style-name"/>
                </xsl:variable>
                <xsl:variable name="pic-num">
                    <xsl:value-of select="count(/descendant::*[@draw:style-name=$pic-name])"/>
                </xsl:variable>
                <xsl:variable name="picnumber">
                    <xsl:value-of select="count(preceding::*[@draw:style-name=$pic-name])"/>
                </xsl:variable>
                <xsl:call-template name="pic-process">
                    <xsl:with-param name="pic-name" select="$pic-name"/>
                    <xsl:with-param name="nodename" select="$nodename"/>
                    <xsl:with-param name="picnumber" select="$picnumber"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@presentation:style-name">
                <xsl:variable name="pic-name">
                    <xsl:value-of select="@presentation:style-name"/>
                </xsl:variable>
                <xsl:variable name="pic-num">
                    <xsl:value-of select="count(/descendant::*[@presentation:style-name=$pic-name])"/>
                </xsl:variable>
                <xsl:variable name="picnumber">
                    <xsl:value-of select="count(preceding::*[@presentation:style-name=$pic-name])"/>
                </xsl:variable>
                <xsl:call-template name="pic-process">
                    <xsl:with-param name="pic-name" select="$pic-name"/>
                    <xsl:with-param name="picnumber" select="$picnumber"/>
                    <xsl:with-param name="nodename" select="$nodename"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="pic-process">
        <xsl:param name="pic-name"/>
        <xsl:param name="nodename"/>
        <xsl:param name="picnumber"/>
        <图:图形 uof:locID="g0000" uof:attrList="层次 标识符 组合列表 其他对象">
            <xsl:attribute name="图:标识符"><xsl:choose><xsl:when test="@draw:id"><xsl:value-of select="@draw:id"/></xsl:when><xsl:when test="not(@draw:style-name) and name()='draw:g'"><xsl:value-of select="concat(child::node()[1]/@draw:style-name,'-',$picnumber)"/></xsl:when><xsl:otherwise><xsl:value-of select="concat($pic-name,'_',$picnumber)"/></xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="图:层次"><xsl:choose><xsl:when test="name(parent::node())='draw:g'"><xsl:value-of select="position()"/></xsl:when><xsl:when test="@draw:z-index"><xsl:value-of select="@draw:z-index"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise>
            </xsl:choose></xsl:attribute>
            <xsl:if test="$nodename='draw:g'">
                <xsl:attribute name="图:组合列表"><xsl:for-each select="child::*[1]"><xsl:variable name="node1"><xsl:value-of select="@draw:style-name"/></xsl:variable><xsl:variable name="picnumber2"><xsl:value-of select="count(preceding::*[@draw:style-name=$node1])"/></xsl:variable><xsl:call-template name="zuheliebiao"><xsl:with-param name="allnode"><xsl:value-of select="concat($node1,'_',$picnumber2)"/></xsl:with-param><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:for-each></xsl:attribute>
            </xsl:if>
            <xsl:if test=".//office:binary-data">
                <xsl:attribute name="图:其他对象"><xsl:choose><xsl:when test="@draw:name"><xsl:value-of select="@draw:name"/></xsl:when><xsl:otherwise><xsl:value-of select="concat($pic-name,'_b1')"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:if>
            <xsl:variable name="arrow-sign">
                <xsl:choose>
                    <xsl:when test="key('graphicset',$pic-name)/style:graphic-properties/@draw:marker-start or key('graphicset',$pic-name)/style:graphic-properties/@draw:marker-end">
                        <xsl:value-of select="'1'"/>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$nodename='draw:line' or $nodename='draw:rect' or $nodename='draw:circle' or $nodename='draw:polygon' or $nodename='draw:polyline' or $nodename='draw:ellipse' or $nodename='draw:page-thumbnail' or $nodename='draw:frame' or $nodename='draw:path'or $nodename='draw:g'">
                    <图:预定义图形 uof:locID="g0005">
                        <图:类别 uof:locID="g0006">
                            <xsl:choose>
                                <xsl:when test="$nodename='draw:rect'">11</xsl:when>
                                <xsl:when test="$nodename='draw:line'">61</xsl:when>
                                <xsl:when test="$nodename='draw:circle'">19</xsl:when>
                                <xsl:when test="$nodename='draw:polygon'">65</xsl:when>
                                <xsl:when test="$nodename='draw:polyline'">66</xsl:when>
                                <xsl:when test="$nodename='draw:ellipse'">19</xsl:when>
                                <xsl:when test="$nodename='draw:page-thumbnail'">67</xsl:when>
                                <xsl:when test="$nodename='draw:frame'">3</xsl:when>
                                <xsl:when test="$nodename='draw:path'">64</xsl:when>
                                <xsl:when test="$nodename='draw:g'">4</xsl:when>
                            </xsl:choose>
                        </图:类别>
                        <图:名称 uof:locID="g0007">
                            <xsl:choose>
                                <xsl:when test="$nodename='draw:rect'">Rectangle</xsl:when>
                                <xsl:when test="$nodename='draw:line'">Line</xsl:when>
                                <xsl:when test="$nodename='draw:circle'">Oval</xsl:when>
                                <xsl:when test="$nodename='draw:polygon'">Freeform</xsl:when>
                                <xsl:when test="$nodename='draw:polyline'">Scribble</xsl:when>
                                <xsl:when test="$nodename='draw:ellipse'">Oval</xsl:when>
                                <xsl:when test="$nodename='draw:page-thumbnail'">缩略图</xsl:when>
                                <xsl:when test="$nodename='draw:frame'">文本框</xsl:when>
                                <xsl:when test="$nodename='draw:path'">Curve</xsl:when>
                                <xsl:when test="$nodename='draw:g'">group</xsl:when>
                            </xsl:choose>
                        </图:名称>
                        <图:生成软件 uof:locID="g0008">PNG</图:生成软件>
                        <xsl:if test="./@draw:points or ./@svg:d">
                            <图:关键点坐标 uof:locID="g0009" uofattrList="路径">
                                <xsl:attribute name="图:路径"><xsl:choose><xsl:when test="@svg:d"><xsl:value-of select="@svg:d"/></xsl:when><xsl:when test="@draw:points"><xsl:call-template name="draw:points"><xsl:with-param name="point" select="@draw:points"/><xsl:with-param name="lujing"/></xsl:call-template></xsl:when></xsl:choose></xsl:attribute>
                            </图:关键点坐标>
                        </xsl:if>
                        <图:属性 uof:locID="g0011">
                            <xsl:for-each select="(/office:document/office:styles/descendant::*[@style:name=$pic-name]) | (/office:document/*/style:style[@style:name=$pic-name]) ">
                                <xsl:for-each select="style:graphic-properties">
                                    <xsl:if test="not(@draw:fill='none')">
                                        <图:填充 uof:locID="g0012">
                                            <xsl:call-template name="填充">
                                                <xsl:with-param name="nodename" select="$nodename"/>
                                                <xsl:with-param name="picname" select="$pic-name"/>
                                            </xsl:call-template>
                                        </图:填充>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if test="style:graphic-properties/@svg:stroke-color">
                                    <图:线颜色 uof:locID="g0013">
                                        <xsl:value-of select="style:graphic-properties/@svg:stroke-color"/>
                                    </图:线颜色>
                                </xsl:if>
                                <图:线型 uof:locID="g0014">
                                    <xsl:variable name="linetype" select="style:graphic-properties/@draw:stroke-dash"/>
                                    <xsl:choose>
                                        <xsl:when test="not(style:graphic-properties/@draw:stroke)">
                                            <xsl:choose>
                                                <xsl:when test="not(style:graphic-properties/@svg:stroke-width)">single</xsl:when>
                                                <xsl:otherwise>thick</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="style:graphic-properties/@draw:stroke = 'none'">none</xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:choose>
                                                        <xsl:when test="$linetype='Fine_20_Dashed' and style:graphic-properties/@svg:stroke-width">dash-long-heavy</xsl:when>
                                                        <xsl:when test="$linetype='Fine_20_Dashed'">dash-long</xsl:when>
                                                        <xsl:when test="$linetype='_32__20_Dots_20_1_20_Dash' and style:graphic-properties/@svg:stroke-width">dash-dot-dot-heavy</xsl:when>
                                                        <xsl:when test="$linetype='_32__20_Dots_20_1_20_Dash'">dot-dot-dash</xsl:when>
                                                        <xsl:when test="$linetype='Ultrafine_20_Dashed' and style:graphic-properties/@svg:stroke-width">dashed-heavy</xsl:when>
                                                        <xsl:when test="$linetype='Ultrafine_20_Dotted_20__28_var_29_'and style:graphic-properties/@svg:stroke-width">dotted-heavy</xsl:when>
                                                        <xsl:when test="$linetype='Ultrafine_20_Dotted_20__28_var_29_'">dotted</xsl:when>
                                                        <xsl:when test="$linetype='Line_20_with_20_Fine_20_Dots'">double</xsl:when>
                                                        <xsl:when test="$linetype='_33__20_Dashes_20_3_20_Dots_20__28_var_29_' and style:graphic-properties/@svg:stroke-width">dash-dot-heavy</xsl:when>
                                                        <xsl:when test="$linetype='_33__20_Dashes_20_3_20_Dots_20__28_var_29_'">dot-dash</xsl:when>
                                                        <xsl:when test="$linetype='Ultrafine_20_2_20_Dots_20_3_20_Dashes'and style:graphic-properties/@svg:stroke-width">wavy-heavy</xsl:when>
                                                        <xsl:when test="$linetype='Ultrafine_20_2_20_Dots_20_3_20_Dashes'">wave</xsl:when>
                                                        <xsl:when test="$linetype='Fine_20_Dashed_20__28_var_29_'">wavy-double</xsl:when>
                                                        <xsl:otherwise>dash</xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </图:线型>
                                <xsl:if test="style:graphic-properties/@svg:stroke-width">
                                    <图:线粗细 uof:locID="g0016">
                                        <xsl:value-of select="substring-before(style:graphic-properties/@svg:stroke-width,$uofUnit)"/>
                                    </图:线粗细>
                                </xsl:if>
                                <xsl:if test="style:graphic-properties/@draw:marker-start and string-length(style:graphic-properties/@draw:marker-start)&gt;0">
                                    <图:前端箭头 uof:locID="g0017">
                                        <图:式样 uof:locID="g0018">
                                            <xsl:choose>
                                                <xsl:when test="style:graphic-properties/@draw:marker-start='Arrow'">normal</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-start='Line_20_Arrow'">open</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-start='Arrow_20_concave'">stealth</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-start='Circle'">oval</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-start='Square_20_45'">diamond</xsl:when>
                                                <xsl:otherwise>normal</xsl:otherwise>
                                            </xsl:choose>
                                        </图:式样>
                                        <xsl:if test="style:graphic-properties/@draw:marker-start-width">
                                            <图:大小 uof:locID="g0019">
                                                <xsl:variable name="width">
                                                    <xsl:value-of select="substring-before(style:graphic-properties/@draw:marker-start-width,$uofUnit)"/>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="($width&lt;0.05 and 0&lt;$width) or $width=0.05">1</xsl:when>
                                                    <xsl:when test="($width&lt;0.10 and 0.05&lt;$width) or $width=0.10">2</xsl:when>
                                                    <xsl:when test="($width&lt;0.15 and 0.10&lt;$width) or $width=0.15">3</xsl:when>
                                                    <xsl:when test="($width&lt;0.20 and 0.15&lt;$width) or $width=0.20">4</xsl:when>
                                                    <xsl:when test="($width&lt;0.25 and 0.20&lt;$width) or $width=0.25">5</xsl:when>
                                                    <xsl:when test="($width&lt;0.30 and 0.25&lt;$width) or $width=0.30">6</xsl:when>
                                                    <xsl:when test="($width&lt;0.35 and 0.30&lt;$width) or $width=0.35">7</xsl:when>
                                                    <xsl:when test="($width&lt;0.40 and 0.35&lt;$width) or $width=0.40">8</xsl:when>
                                                    <xsl:otherwise>9</xsl:otherwise>
                                                </xsl:choose>
                                            </图:大小>
                                        </xsl:if>
                                    </图:前端箭头>
                                </xsl:if>
                                <xsl:if test="style:graphic-properties/@draw:marker-end">
                                    <图:后端箭头 uof:locID="g0020">
                                        <图:式样 uof:locID="g0021">
                                            <xsl:choose>
                                                <xsl:when test="style:graphic-properties/@draw:marker-end='Arrow'">normal</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-end='Line_20_Arrow'">open</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-end='Arrow_20_concave'">stealth</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-end='Circle'">oval</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-end='Square_20_45'">diamond</xsl:when>
                                                <xsl:otherwise>normal</xsl:otherwise>
                                            </xsl:choose>
                                        </图:式样>
                                        <xsl:if test="style:graphic-properties/@draw:marker-end-width">
                                            <图:大小 uof:locID="g0022">
                                                <xsl:variable name="width">
                                                    <xsl:value-of select="number(substring-before(style:graphic-properties/@draw:marker-end-width,$uofUnit))"/>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="($width&lt;0.05 and 0&lt;$width) or $width=0.05">1</xsl:when>
                                                    <xsl:when test="($width&lt;0.10 and 0.05&lt;$width) or $width=0.10">2</xsl:when>
                                                    <xsl:when test="($width&lt;0.15 and 0.10&lt;$width) or $width=0.15">3</xsl:when>
                                                    <xsl:when test="($width&lt;0.20 and 0.15&lt;$width) or $width=0.20">4</xsl:when>
                                                    <xsl:when test="($width&lt;0.25 and 0.20&lt;$width) or $width=0.25">5</xsl:when>
                                                    <xsl:when test="($width&lt;0.30 and 0.25&lt;$width) or $width=0.30">6</xsl:when>
                                                    <xsl:when test="($width&lt;0.35 and 0.30&lt;$width) or $width=0.35">7</xsl:when>
                                                    <xsl:when test="($width&lt;0.40 and 0.35&lt;$width) or $width=0.40">8</xsl:when>
                                                    <xsl:otherwise>9</xsl:otherwise>
                                                </xsl:choose>
                                            </图:大小>
                                        </xsl:if>
                                    </图:后端箭头>
                                </xsl:if>
                                <xsl:if test="style:graphic-properties/@draw:opacity or style:graphic-properties/@svg:stroke-opacity or style:graphic-properties/@svg:stroke-opacity">
                                    <图:透明度 uof:locID="g0038">
                                    <xsl:choose>
                                        <xsl:when test="style:graphic-properties/@draw:opacity">
                                        <xsl:variable name="transparency">
                                            <xsl:value-of select="substring-before(style:graphic-properties/@draw:opacity,'%')"/>
                                        </xsl:variable>
                                        <xsl:value-of select="(100 - $transparency) div 100"/>
                                        </xsl:when>
                                        <xsl:when test="style:graphic-properties/@svg:stroke-opacity">
                                        <xsl:variable name="transparency">
                                            <xsl:value-of select="substring-before(style:graphic-properties/@svg:stroke-opacity,'%')"/>
                                        </xsl:variable>
                                        <xsl:value-of select="(100 - $transparency) div 100"/>
                                        </xsl:when>
                                        <xsl:when test="style:properties/@svg:stroke-opacity">
                                            <xsl:value-of select="substring-before(style:properties/@svg:stroke-opacity,'%')"/>
                                        </xsl:when>
                                    </xsl:choose>
                                    </图:透明度>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:choose>
                                <xsl:when test="@svg:x1">
                                    <图:宽度 uof:locID="g0023">
                                        <xsl:value-of select="substring-before(@svg:x2,$uofUnit) - substring-before(@svg:x1,$uofUnit)"/>
                                    </图:宽度>
                                    <图:高度 uof:locID="g0024">
                                        <xsl:value-of select="substring-before(@svg:y2,$uofUnit) - substring-before(@svg:y1,$uofUnit)"/>
                                    </图:高度>
                                </xsl:when>
                                <xsl:when test="@svg:x">
                                    <图:宽度 uof:locID="g0023">
                                        <xsl:value-of select="substring-before(@svg:width,$uofUnit)"/>
                                    </图:宽度>
                                    <图:高度 uof:locID="g0024">
                                        <xsl:value-of select="substring-before(@svg:height,$uofUnit)"/>
                                    </图:高度>
                                </xsl:when>
                                <xsl:when test="@svg:width">
                                    <图:宽度 uof:locID="g0023">
                                        <xsl:value-of select="substring-before(@svg:width,$uofUnit)"/>
                                    </图:宽度>
                                    <图:高度 uof:locID="g0024">
                                        <xsl:value-of select="substring-before(@svg:height,$uofUnit)"/>
                                    </图:高度>
                                </xsl:when>
                            </xsl:choose>
                            <图:旋转角度 uof:locID="g0025">
                                <xsl:choose>
                                    <xsl:when test="@draw:transform">
                                        <xsl:variable name="rotate-angle">
                                            <xsl:value-of select="@draw:transform"/>
                                        </xsl:variable>
                                        <xsl:variable name="rotate-temp">
                                            <xsl:value-of select="substring-before(substring-after($rotate-angle,'rotate ('),')')"/>
                                        </xsl:variable>
                                        <xsl:value-of select="($rotate-temp * 360) div (2 * 3.14159265)"/>
                                    </xsl:when>
                                    <xsl:otherwise>0.0</xsl:otherwise>
                                </xsl:choose>
                            </图:旋转角度>
                            <图:X-缩放比例 uof:locID="g0026">1</图:X-缩放比例>
                            <图:Y-缩放比例 uof:locID="g0027">1</图:Y-缩放比例>
                            <图:锁定纵横比 uof:locID="g0028">0</图:锁定纵横比>
                            <图:相对原始比例 uof:locID="g0029">1</图:相对原始比例>
                            <图:打印对象 uof:locID="g0032">true</图:打印对象>
                            <图:Web文字 uof:locID="g0033"/>
                        </图:属性>
                    </图:预定义图形>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="./text:p or ./draw:text-box">
                <图:文本内容 uof:locID="g0002" uof:attrList="文本框 左边距 右边距 上边距 下边距 水平对齐 垂直对齐 文字排列方向 自动换行 大小适应文字 前一链接 后一链接">
                    <xsl:if test="$nodename='draw:text-box'">
                        <xsl:attribute name="图:文本框">true</xsl:attribute>
                        <xsl:if test="./@draw:name = /office:document/office:body
//draw:text-box/@draw:chain-next-name">
                            <xsl:attribute name="图:前一链接"><xsl:variable name="drawname"><xsl:value-of select="./@draw:name"/></xsl:variable><xsl:variable name="befor-link-name"><xsl:value-of select="/office:document/office:body
//draw:text-box[@draw:name=$drawname]/@draw:style-name"/></xsl:variable><xsl:value-of select="concat($befor-link-name,'_',$picnumber)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="./@draw:chain-next-name">
                            <xsl:attribute name="图:后一链接"><xsl:variable name="next-link"><xsl:value-of select="./@draw:chain-next-name"/></xsl:variable><xsl:variable name="link-name"><xsl:value-of select="/office:document/office:body
//draw:text-box[@draw:name=$next-link]/@draw:style-name"/></xsl:variable><xsl:value-of select="concat($link-name,'_',$picnumber)"/></xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <xsl:for-each select="(/office:document/office:styles/descendant::*[@style:name=$pic-name]) | (/office:document/office:automatic-styles/descendant::*[@style:name=$pic-name]) ">
                        <xsl:if test="style:graphic-properties/@fo:padding-left">
                            <xsl:attribute name="图:左边距"><xsl:value-of select="substring-before(style:graphic-properties/@fo:padding-left,$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="图:右边距"><xsl:value-of select="substring-before(style:graphic-properties/@fo:padding-right,$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="图:上边距"><xsl:value-of select="substring-before(style:graphic-properties/@fo:padding-top,$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="图:下边距"><xsl:value-of select="substring-before(style:graphic-properties/@fo:padding-bottom,$uofUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="图:文字排列方向">
                            <xsl:choose>
                                <xsl:when test="style:paragraph-properties/@style:writing-mode">
                                    <xsl:choose>
                                        <xsl:when test="style:paragraph-properties/@style:writing-mode='tb-rl' and style:graphic-properties/@draw:textarea-vertical-align='bottom'">vert-l2r</xsl:when>
                                        <xsl:when test="style:paragraph-properties/@style:writing-mode='tb-rl'">vert-r2l</xsl:when>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="style:graphic-properties/@draw:textarea-horizontal-align='right'">hori-r2l</xsl:when>
                                <xsl:otherwise>hori-l2r</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:if test="style:graphic-properties/@fo:wrap-option">
                            <xsl:attribute name="图:自动换行">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="style:graphic-properties/@draw:auto-grow-width='true'">
                            <xsl:attribute name="图:大小适应文字">true</xsl:attribute>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="./draw:text-box">
                        <xsl:for-each select="draw:text-box/node( )">
                            <xsl:choose>
                                <xsl:when test="name()='text:list'">
                                    <xsl:call-template name="unordered-ordered-list">
                                        <xsl:with-param name="currlistlvl" select="number('1')"/>
                                        <xsl:with-param name="liststylename" select="@text:style-name"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="name()='text:p'or name()='text:h'">
                                    <xsl:call-template name="execParagraph">
                                        <xsl:with-param name="currlistlvl" select="number('0')"/>
                                        <xsl:with-param name="liststylename" select="string('00000')"/>
                                    </xsl:call-template>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="./text:p">
                        <xsl:call-template name="execParagraph">
                            <xsl:with-param name="currlistlvl" select="number('0')"/>
                            <xsl:with-param name="liststylename" select="string('00000')"/>
                        </xsl:call-template>
                    </xsl:if>
                </图:文本内容>
            </xsl:if>
            <图:控制点 uof:locID="g0003" uof:attrList="x坐标 y坐标">
                <xsl:attribute name="图:x坐标"><xsl:value-of select="substring-before(@svg:x,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="图:y坐标"><xsl:value-of select="substring-before(@svg:y,$uofUnit)"/></xsl:attribute>
            </图:控制点>
               <图:翻转 uof:locID="g0040" uof:attrList="方向" 图:方向="x"/>
        </图:图形>
        <xsl:if test="name(..)='draw:g'">
            <图:组合位置 uof:locID="g0041" uof:attrList="x坐标 y坐标">
                <xsl:attribute name="图:x坐标"><xsl:variable name="minx"><xsl:for-each select="parent::node()"><xsl:call-template name="groupminx"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:x][1]/@svg:x,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:for-each></xsl:variable><xsl:choose><xsl:when test="name(.)='draw:g'"><xsl:variable name="current-minx"><xsl:call-template name="groupminx"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:x][1]/@svg:x,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable><xsl:value-of select="$current-minx - $minx"/></xsl:when><xsl:otherwise><xsl:variable name="current-x" select="number(substring-before(@svg:x,$uofUnit))"/><xsl:value-of select="$current-x - $minx"/></xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="图:y坐标"><xsl:variable name="miny"><xsl:for-each select="parent::node()"><xsl:call-template name="groupminy"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:y][1]/@svg:y,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:for-each></xsl:variable><xsl:choose><xsl:when test="name(.)='draw:g'"><xsl:variable name="current-miny"><xsl:call-template name="groupminy"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:y][1]/@svg:y,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable><xsl:value-of select="$current-miny - $miny"/></xsl:when><xsl:otherwise><xsl:variable name="current-y" select="number(substring-before(@svg:y,$uofUnit))"/><xsl:value-of select="$current-y - $miny"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </图:组合位置>
        </xsl:if>
        <xsl:if test="name()='draw:frame' and ./draw:image">
            <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                <xsl:attribute name="uof:标识符"><xsl:choose><xsl:when test="@draw:id"><xsl:value-of select="@draw:id"/></xsl:when><xsl:otherwise><xsl:value-of select="concat($pic-name,'_',$picnumber)"/></xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                <xsl:attribute name="uof:公共类型">jpg</xsl:attribute>
                <xsl:if test="./draw:image/office:binary-data">
                    <uof:数据 uof:locID="u0037">
                        <xsl:value-of select="./draw:image/office:binary-data"/>
                    </uof:数据>
                </xsl:if>
                <xsl:if test="./draw:image/@xlink:href">
                    <uof:路径 uof:locID="u0038">
                        <xsl:value-of select="./draw:image/@xlink:href"/>
                    </uof:路径>
                </xsl:if>
            </uof:其他对象>
        </xsl:if>
        <xsl:for-each select="(/office:document/office:styles/descendant::*[@style:name=$pic-name]) | (/office:document/office:automatic-styles/descendant::*[@style:name=$pic-name]) ">
            <xsl:if test="style:graphic-properties/@draw:fill-image-name and @draw:fill='bitmap'">
                <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                    <xsl:attribute name="uof:标识符"><xsl:choose><xsl:when test="@draw:id"><xsl:value-of select="@draw:id"/></xsl:when><xsl:otherwise><xsl:value-of select="concat($pic-name,'_',$picnumber)"/></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="uof:公共类型">jpg</xsl:attribute>
                    <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                    <xsl:variable name="fill-name">
                        <xsl:value-of select="style:graphic-properties/@draw:fill-image-name"/>
                    </xsl:variable>
                    <uof:数据 uof:locID="u0037">
                        <xsl:for-each select="/office:document/office:styles/draw:fill-image[@draw:name=$fill-name]">
                            <xsl:value-of select="office:binary-data"/>
                        </xsl:for-each>
                    </uof:数据>
                    <uof:路径 uof:locID="u0038">
                        <xsl:value-of select="@xlink:href"/>
                    </uof:路径>
                </uof:其他对象>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="unordered-ordered-list">
        <xsl:param name="currlistlvl"/>
        <xsl:param name="liststylename"/>
        <xsl:for-each select="text:list-item">
            <xsl:if test="text:p">
                <xsl:for-each select="text:p">
                    <xsl:call-template name="execParagraph">
                        <xsl:with-param name="currlistlvl" select="$currlistlvl"/>
                        <xsl:with-param name="liststylename" select="$liststylename"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="node( )">
                <xsl:if test="name()='text:list'">
                    <xsl:call-template name="unordered-ordered-list">
                        <xsl:with-param name="currlistlvl" select="$currlistlvl +1"/>
                        <xsl:with-param name="liststylename" select="$liststylename"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="groupminx">
        <xsl:param name="value"/>
        <xsl:param name="pos"/>
        <xsl:choose>
            <xsl:when test="descendant::node()[@svg:x][position()=$pos]">
                <xsl:variable name="othervalue" select="number(substring-before(descendant::node()[@svg:x][position()=$pos]/@svg:x,$uofUnit))"/>
                <xsl:call-template name="groupminx">
                    <xsl:with-param name="value">
                        <xsl:choose>
                            <xsl:when test="$value&gt;$othervalue">
                                <xsl:value-of select="$othervalue"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="pos" select="$pos+1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="groupminy">
        <xsl:param name="value"/>
        <xsl:param name="pos"/>
        <xsl:choose>
            <xsl:when test="descendant::node()[@svg:y][position()=$pos]">
                <xsl:variable name="othervalue" select="number(substring-before(descendant::node()[@svg:y][position()=$pos]/@svg:y,$uofUnit))"/>
                <xsl:call-template name="groupminy">
                    <xsl:with-param name="value">
                        <xsl:choose>
                            <xsl:when test="$value&gt;$othervalue">
                                <xsl:value-of select="$othervalue"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="pos" select="$pos+1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="groupmaxx">
        <xsl:param name="value"/>
        <xsl:param name="pos"/>
        <xsl:choose>
            <xsl:when test="descendant::node()[@svg:x][position()=$pos]">
                <xsl:variable name="svgx">
                    <xsl:value-of select="number(substring-before(descendant::node()[@svg:x][position()=$pos]/@svg:x,$uofUnit))"/>
                </xsl:variable>
                <xsl:variable name="width">
                    <xsl:value-of select="number(substring-before(descendant::node()[@svg:x][position()=$pos]/@svg:width,$uofUnit))"/>
                </xsl:variable>
                <xsl:variable name="othervalue" select="$svgx + $width"/>
                <xsl:call-template name="groupminx">
                    <xsl:with-param name="value">
                        <xsl:choose>
                            <xsl:when test="$value&gt;$othervalue">
                                <xsl:value-of select="$value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$othervalue"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="pos" select="$pos+1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="groupmaxy">
        <xsl:param name="value"/>
        <xsl:param name="pos"/>
        <xsl:choose>
            <xsl:when test="descendant::node()[@svg:y][position()=$pos]">
                <xsl:variable name="svgy">
                    <xsl:value-of select="number(substring-before(descendant::node()[@svg:y][position()=$pos]/@svg:y,$uofUnit))"/>
                </xsl:variable>
                <xsl:variable name="height">
                    <xsl:value-of select="number(substring-before(descendant::node()[@svg:y][position()=$pos]/@svg:height,$uofUnit))"/>
                </xsl:variable>
                <xsl:variable name="othervalue" select="$svgy + $height"/>
                <xsl:call-template name="groupminy">
                    <xsl:with-param name="value">
                        <xsl:choose>
                            <xsl:when test="$value&gt;$othervalue">
                                <xsl:value-of select="$value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$othervalue"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="pos" select="$pos+1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="draw:points">
        <xsl:param name="point"/>
        <xsl:param name="lujing"/>
        <xsl:choose>
            <xsl:when test="contains($point,' ' )">
                <xsl:variable name="first-point" select="substring-before($point,' ')"/>
                <xsl:variable name="other-point" select="substring-after($point,' ')"/>
                <xsl:variable name="xzuobiao">
                    <xsl:value-of select="substring-before($first-point,',') div 1000"/>
                </xsl:variable>
                <xsl:variable name="yzuobiao">
                    <xsl:value-of select="substring-after($first-point,',') div 1000"/>
                </xsl:variable>
                <xsl:call-template name="draw:points">
                    <xsl:with-param name="point" select="$other-point"/>
                    <xsl:with-param name="lujing" select="concat($lujing,$xzuobiao,' ',$yzuobiao,'lineto')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="xzuobiao">
                    <xsl:value-of select="substring-before($point,',') div 1000"/>
                </xsl:variable>
                <xsl:variable name="yzuobiao">
                    <xsl:value-of select="substring-after($point,',') div 1000"/>
                </xsl:variable>
                <xsl:value-of select="concat($lujing,$xzuobiao,' ',$yzuobiao)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="execParagraph">
        <xsl:param name="currlistlvl"/>
        <xsl:param name="liststylename"/>
        <字:段落 uof:locID="t0051" uof:attrList="标识符">
        <xsl:if test="@text:id">
                <xsl:attribute name="字:动画标识"><xsl:value-of select="@text:id"/></xsl:attribute>
            </xsl:if>
            <xsl:element name="字:段落属性">
                <xsl:attribute name="uof:locID">t0052</xsl:attribute>
                <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                <xsl:attribute name="字:式样引用"><xsl:choose><xsl:when test="@text:id"><xsl:value-of select="@text:id"/></xsl:when><xsl:otherwise><xsl:value-of select="@text:style-name"/></xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:if test="not(number($currlistlvl) =number('0'))">
                    <xsl:variable name="parent-position">
                        <xsl:number from="/office:document/office:body/text:ordered-list" level="any" count="text:list-item/text:p" format="1"/>
                    </xsl:variable>
                    <xsl:element name="字:自动编号信息">
                        <xsl:attribute name="uof:locID">t0059</xsl:attribute>
                        <xsl:attribute name="uof:attrList">编号引用 编号级别 重新编号 起始编号</xsl:attribute>
                        <xsl:attribute name="字:编号引用"><xsl:value-of select="$liststylename"/></xsl:attribute>
                        <xsl:attribute name="字:编号级别"><xsl:value-of select="$currlistlvl"/></xsl:attribute>
                        <xsl:attribute name="字:重新编号"><xsl:choose><xsl:when test="number($parent-position)=number('1')">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="字:起始编号"><xsl:for-each select="//text:list-style[$liststylename=@style:name]/*[number($currlistlvl)=number(@text:level)]"><xsl:choose><xsl:when test="@text:start-value"><xsl:value-of select="@text:start-value"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:for-each></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:variable name="stylename">
                    <xsl:value-of select="@text:style-name"/>
                </xsl:variable>
                <xsl:for-each select="(//style:style[@style:name=$stylename])">
                    <xsl:call-template name="ParaAttribute">
                        <xsl:with-param name="text-style-name" select="@text:style-name"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:element>
            <xsl:for-each select="node( )">
                <xsl:choose>
                    <xsl:when test="self::node( )[name(.)='text:span']">
                        <xsl:call-template name="textspan"/>
                    </xsl:when>
                    <xsl:when test="self::node()[name(.)='text:time']">
                        <xsl:apply-templates select="."/>
                    </xsl:when>
                    <xsl:when test="self::node()[name(.)='text:s']">
                        <xsl:apply-templates select="."/>
                    </xsl:when>
                    <xsl:when test="substring-before(name(.),':')='draw' and not(name(.)='draw:a')">
                    </xsl:when>
                    <xsl:when test="name(.)='text:a'">
                        <字:句 uof:locID="t0085">
                            <xsl:element name="字:句属性">
                                <xsl:attribute name="uof:locID">t0086</xsl:attribute>
                                <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                                <字:字体 uof:locID="t0088" uof:attrList="西文字体引用 中文字体引用 字号 颜色" 字:颜色="#0000ff"/>
                                <字:下划线 uof:locID="t0095" 字:类型="single" 字:颜色="#0000ff" uof:attrList="类型 颜色 字下划线"/>
                            </xsl:element>
                            <xsl:element name="字:区域开始">
                                <xsl:attribute name="字:标识符">hlnk<xsl:number from="/office:document/office:body" level="any" count="text:p[text:a]"/></xsl:attribute>
                                <xsl:attribute name="字:名称">Hyperlink</xsl:attribute>
                                <xsl:attribute name="字:类型">hyperlink</xsl:attribute>
                                <xsl:attribute name="uof:locID">t0121</xsl:attribute>
                                <xsl:attribute name="uof:attrList">标识符 名称 类型</xsl:attribute>
                            </xsl:element>
                            <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                                <xsl:value-of select="."/>
                            </字:文本串>
                            <xsl:element name="字:区域结束">
                                <xsl:attribute name="字:标识符引用">hlnk<xsl:number from="/office:document/office:body" level="any" count="text:p[text:a]"/></xsl:attribute>
                                <xsl:attribute name="uof:locID">t0122</xsl:attribute>
                                <xsl:attribute name="uof:attrList">标识符引用</xsl:attribute>
                            </xsl:element>
                        </字:句>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="字:句"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </字:段落>
    </xsl:template>
    <xsl:template name="字:句">
        <xsl:if test="not(name(.)='text:bookmark-start' or name(.)='text:bookmark-end' or  name(.)='draw:image' or name(.)='office:binary-data')">
            <字:句 uof:locID="t0085">
                <字:句属性 uof:locID="t0086" uof:attrList="式样引用">
                    <xsl:choose>
                        <xsl:when test="@text:style-name">
                            <xsl:attribute name="字:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="字:式样引用"><xsl:value-of select="parent::node( )/@text:style-name"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </字:句属性>
                <xsl:choose>
                    <xsl:when test="(preceding-sibling::text:bookmark-start) and (following-sibling::text:bookmark-end)">
                        <字:区域开始 uof:locID="t0121" uof:attrList="标识符 名称 类型">
                            <xsl:attribute name="字:标识符"><xsl:value-of select="preceding-sibling::text:bookmark-start/@text:name"/></xsl:attribute>
                            <xsl:attribute name="字:名称">Bookmark</xsl:attribute>
                            <xsl:attribute name="字:类型">bookmark</xsl:attribute>
                        </字:区域开始>
                        <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                            <xsl:value-of select="string(.)"/>
                        </字:文本串>
                        <字:区域结束 uof:locID="t0122" uof:attrList="标识符引用">
                            <xsl:attribute name="字:标识符引用"><xsl:value-of select="following-sibling::text:bookmark-end/@text:name"/></xsl:attribute>
                        </字:区域结束>
                    </xsl:when>
                    <xsl:when test="preceding-sibling::text:bookmark">
                        <字:区域开始 uof:locID="t0121" uof:attrList="标识符 名称 类型">
                            <xsl:attribute name="字:标识符"><xsl:value-of select="preceding-sibling::text:bookmark/@text:name"/></xsl:attribute>
                            <xsl:attribute name="字:名称">Bookmark</xsl:attribute>
                            <xsl:attribute name="字:类型">bookmark</xsl:attribute>
                        </字:区域开始>
                        <字:区域结束 uof:locID="t0122" uof:attrList="标识符引用">
                            <xsl:attribute name="字:标识符引用"><xsl:value-of select="preceding-sibling::text:bookmark/@text:name"/></xsl:attribute>
                        </字:区域结束>
                        <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                            <xsl:value-of select="string(.)"/>
                        </字:文本串>
                    </xsl:when>
                    <xsl:when test="name(.)='draw:a'">
                        <xsl:variable name="link-name">
                            <xsl:value-of select="substring-after(@xlink:href,'#')"/>
                        </xsl:variable>
                        <字:区域开始 uof:locID="t0121" uof:attrList="标识符 名称 类型">
                            <xsl:attribute name="字:标识符"><xsl:value-of select="$link-name"/></xsl:attribute>
                            <xsl:attribute name="字:名称">Bookmark</xsl:attribute>
                            <xsl:attribute name="字:类型">bookmark</xsl:attribute>
                        </字:区域开始>
                        <字:区域结束 uof:locID="t0122" uof:attrList="标识符引用">
                            <xsl:attribute name="字:标识符引用"><xsl:value-of select="$link-name"/></xsl:attribute>
                        </字:区域结束>
                    </xsl:when>
                    <xsl:when test="self::node( )[name(.)='text:tab-stop']">
                        <xsl:element name="字:制表符">
                            <xsl:attribute name="uof:locID">t0123</xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="name(.)='text:bookmark-start' or name(.)='text:bookmark-end' or  name(.)='draw:image' or name(.)='office:binary-data'">
                        </xsl:when>
                    <xsl:otherwise>
                        <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                            <xsl:value-of select="string(.)"/>
                        </字:文本串>
                    </xsl:otherwise>
                </xsl:choose>
            </字:句>
        </xsl:if>
    </xsl:template>
    <xsl:template name="jiaozhu">
        <字:脚注 uof:locID="t0107" uof:attrList="引文体">
            <xsl:call-template name="execParagraph">
                <xsl:with-param name="currlistlvl" select="number('0')"/>
                <xsl:with-param name="liststylename" select="string('00000')"/>
            </xsl:call-template>
        </字:脚注>
    </xsl:template>
    <xsl:template match="text:s">
        <xsl:param name="bText"/>
        <xsl:choose>
            <xsl:when test="$bText='0'">
                <xsl:variable name="count">
                    <xsl:choose>
                        <xsl:when test="not(@text:c)">1</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@text:c+1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <字:句 uof:locID="t0085">
                    <字:空格符 uof:locID="t0126" uof:attrList="个数" 字:个数="{$count}"/>
                </字:句>
            </xsl:when>
            <xsl:otherwise>
                <字:空格符 uof:locID="t0126" uof:attrList="个数" 字:个数="{@text:c}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="weizhu">
        <字:尾注 uof:locID="t0108" uof:attrList="引文体">
            <xsl:call-template name="execParagraph">
                <xsl:with-param name="currlistlvl" select="number('0')"/>
                <xsl:with-param name="liststylename" select="string('00000')"/>
            </xsl:call-template>
        </字:尾注>
    </xsl:template>
    <xsl:template match="text:time">
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'TIME'"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="text:fixed='1'">
                    <xsl:attribute name="字:锁定">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:锁定">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="uof:locID">t0079</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
        </xsl:element>
        <xsl:element name="字:域代码">
            <字:段落 uof:locID="t0051">
                <字:句 uof:locID="t0085">
                    <字:句属性 uof:locID="t0086" uof:attrList="式样引用"/>
                    <xsl:variable name="timefmt">
                        <xsl:variable name="aa" select="@style:data-style-name"/>
                        <xsl:for-each select="key('geshi',$aa)/number:hours | key('geshi',$aa)/number:minutes | key('geshi',$aa)/number:am-pm | key('geshi',$aa)/number:seconds | key('geshi',$aa)/number:text">
                            <xsl:choose>
                                <xsl:when test="@number:style='long' ">
                                    <xsl:if test="self::node( )[name(.)='number:hours']">HH</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:minutes']">MM</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:seconds']">SS</xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="self::node( )[name(.)='number:text']">
                                        <xsl:value-of select="."/>
                                    </xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:hours']">H</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:minutes']">M</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:seconds']">S</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:am-pm']">AMPM</xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="quote">"</xsl:variable>
                    <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                        <xsl:value-of select="concat('TIME \@ ',$quote,$timefmt,$quote,' \* MERGEFORMAT ')"/>
                    </字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                <xsl:value-of select="."/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template name="ParaAttribute">
        <xsl:param name="text-style-name"/>
        <xsl:for-each select="/office:document/office:styles/style:style">
            <xsl:if test="@style:name=$text-style-name and not($text-style-name='Standard')">
                <xsl:element name="字:格式修订">
                    <xsl:attribute name="uof:locID">t0053</xsl:attribute>
                    <xsl:attribute name="uof:attrList">修订信息引用</xsl:attribute>
                    <xsl:attribute name="字:修订信息引用"><xsl:value-of select="@style:name"/></xsl:attribute>
                    <xsl:element name="字:段落属性">
                        <xsl:attribute name="uof:locID">t0052</xsl:attribute>
                        <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                        <xsl:attribute name="字:式样引用"><xsl:value-of select="@style:name"/></xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="@style:name='Heading'">
            <xsl:element name="字:大纲级别">
                <xsl:attribute name="uof:locID">t0054</xsl:attribute>
                <xsl:value-of select="substring-after(@style:name,'Heading')"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:text-align or .//@style:vertical-align">
            <xsl:element name="字:对齐">
                <xsl:attribute name="uof:locID">t0055</xsl:attribute>
                <xsl:attribute name="uof:attrList">水平对齐 文字对齐</xsl:attribute>
                <xsl:attribute name="字:水平对齐"><xsl:choose><xsl:when test=".//@fo:text-align='end'">right</xsl:when><xsl:when test=".//@fo:text-align='center'">center</xsl:when><xsl:when test=".//@fo:text-align='justify' and not(.//@fo:text-align-last='justify')">justified</xsl:when><xsl:when test=".//@fo:text-align='justify' and .//@fo:text-align-last='justify'">distributed</xsl:when><xsl:otherwise>left</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="字:文字对齐"><xsl:choose><xsl:when test=".//@style:vertical-align='baseline'">base</xsl:when><xsl:when test=".//@style:vertical-align='top'">top</xsl:when><xsl:when test=".//@style:vertical-align='middle'">center</xsl:when><xsl:when test=".//@style:vertical-align='bottom'">bottom</xsl:when><xsl:otherwise>auto</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:margin-left or .//@fo:margin-right or .//@fo:text-indent">
            <xsl:element name="字:缩进">
                <xsl:attribute name="uof:locID">t0056</xsl:attribute>
                <xsl:call-template name="字:缩进类型"/>
            </xsl:element>
        </xsl:if>
        <xsl:element name="字:行距">
            <xsl:attribute name="uof:locID">t0057</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 值</xsl:attribute>
            <xsl:choose>
                <xsl:when test="contains(.//@fo:line-height,$uofUnit)">
                    <xsl:attribute name="字:类型">fixed</xsl:attribute>
                    <xsl:attribute name="字:值"><xsl:value-of select="substring-before(.//@fo:line-height,$uofUnit)"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="contains(.//@fo:line-height,'%')">
                    <xsl:attribute name="字:类型">multi-lines</xsl:attribute>
                    <xsl:attribute name="字:值"><xsl:value-of select="substring-before(.//@fo:line-height,'%') div 100"/></xsl:attribute>
                </xsl:when>
                <xsl:when test=".//@style:line-height-at-least">
                    <xsl:attribute name="字:类型">at-least</xsl:attribute>
                    <xsl:attribute name="字:值"><xsl:value-of select="substring-before(.//@style:line-height-at-least,$uofUnit)"/></xsl:attribute>
                </xsl:when>
                <xsl:when test=".//@style:line-spacing">
                    <xsl:attribute name="字:类型">line-space</xsl:attribute>
                    <xsl:attribute name="字:值"><xsl:value-of select="substring-before(.//@style:line-spacing,$uofUnit)"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:类型">multi-lines</xsl:attribute>
                    <xsl:attribute name="字:值">1.0</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:if test=".//@fo:orphans">
            <xsl:element name="字:孤行控制">
                <xsl:attribute name="uof:locID">t0060</xsl:attribute>
                <xsl:value-of select=".//@fo:orphans"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:widows">
            <xsl:element name="字:寡行控制">
                <xsl:attribute name="uof:locID">t0061</xsl:attribute>
                <xsl:value-of select=".//@fo:widows"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@style:break-inside">
            <xsl:element name="字:段中不分页">
                <xsl:attribute name="uof:locID">t0062</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值">true</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:keep-with-next">
            <xsl:element name="字:与下段同页">
                <xsl:attribute name="uof:locID">t0063</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值">true</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:break-before">
            <xsl:element name="字:段前分页">
                <xsl:attribute name="uof:locID">t0064</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值">true</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@style:snap-to-layout-grid">
            <xsl:element name="字:对齐网格">
                <xsl:attribute name="uof:locID">t0069</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test=".//@style:snap-to-layout-grid='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//style:drop-cap">
            <xsl:element name="字:首字下沉">
                <xsl:attribute name="uof:locID">t0070</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型 字体引用 字符数 行数 间距</xsl:attribute>
                <xsl:attribute name="字:类型">dropped</xsl:attribute>
                <xsl:if test=".//style:drop-cap/@style:style-name">
                    <xsl:attribute name="字:字体引用"><xsl:value-of select=".//style:drop-cap/@style:style-name"/></xsl:attribute>
                </xsl:if>
                <xsl:if test=".//style:drop-cap/@style:distance">
                    <xsl:attribute name="字:间距"><xsl:value-of select="substring-before(.//style:drop-cap/@style:distance,$uofUnit)"/></xsl:attribute>
                </xsl:if>
                <xsl:if test=".//style:drop-cap/@style:length">
                    <xsl:attribute name="字:字符数"><xsl:value-of select=".//style:drop-cap/@style:length"/></xsl:attribute>
                </xsl:if>
                <xsl:if test=".//style:drop-cap/@style:lines">
                    <xsl:attribute name="字:行数"><xsl:value-of select=".//style:drop-cap/@style:lines"/></xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:hyphenate">
            <xsl:element name="字:取消断字">
                <xsl:attribute name="uof:locID">t0071</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:value-of select=".//@fo:hyphenate"/></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@text:number-lines">
            <xsl:element name="字:取消行号">
                <xsl:attribute name="字:值"><xsl:value-of select=".//@text:number-lines"/></xsl:attribute>
                <xsl:attribute name="uof:locID">t0072</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:element name="字:允许单词断字">
            <xsl:attribute name="字:值">true</xsl:attribute>
            <xsl:attribute name="uof:locID">t0073</xsl:attribute>
            <xsl:attribute name="uof:attrList">值</xsl:attribute>
        </xsl:element>
        <xsl:if test=".//@style:punctuation-wrap">
            <xsl:element name="字:行首尾标点控制">
                <xsl:attribute name="uof:locID">t0074</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test=".//@style:punctuation-wrap='hanging'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:element name="字:是否行首标点压缩">
            <xsl:attribute name="uof:locID">t0075</xsl:attribute>
            <xsl:attribute name="uof:attrList">值</xsl:attribute>
            <xsl:attribute name="字:值">false</xsl:attribute>
        </xsl:element>
        <xsl:if test=".//@style:line-break  ">
            <xsl:element name="字:中文习惯首尾字符">
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test=".//@style:line-break='strict'">true</xsl:when><xsl:when test=".//@style:line-break='normal'">false</xsl:when></xsl:choose></xsl:attribute>
                <xsl:attribute name="uof:locID">t0076</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@style:text-autospace">
            <xsl:element name="字:自动调整中英文字符间距">
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test=".//@style:text-autospace='ideograph-alpha'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="uof:locID">t0077</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@style:text-autospace">
            <xsl:element name="字:自动调整中文与数字间距">
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test=".//@style:text-autospace='ideograph-alpha'">true  </xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="uof:locID">t0078</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:element name="字:有网格自动调整右缩进">
            <xsl:attribute name="字:值">false</xsl:attribute>
            <xsl:attribute name="uof:locID">t0195</xsl:attribute>
            <xsl:attribute name="uof:attrList">值</xsl:attribute>
        </xsl:element>
        <xsl:if test=".//@fo:border or .//@fo:border-top or .//@fo:border-bottom or .//@fo:border-left or .//@fo:border-right or .//@style:shadow[.!='none']">
            <xsl:element name="字:边框">
                <xsl:attribute name="uof:locID">t0065</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:background-color">
            <xsl:element name="字:填充">
                <xsl:attribute name="uof:locID">t0066</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test=".//@fo:margin-top or .//@fo:margin-bottom">
            <字:段间距 uof:locID="t0058">
                <xsl:if test=".//@fo:margin-top">
                    <字:段前距 uof:locID="t0196">
                        <字:绝对值 uof:locID="t0199" uof:attrList="值">
                            <xsl:attribute name="字:值"><xsl:value-of select="substring-before(.//@fo:margin-top,$uofUnit)"/></xsl:attribute>
                        </字:绝对值>
                    </字:段前距>
                </xsl:if>
                <xsl:if test=".//@fo:margin-bottom">
                    <字:段后距 uof:locID="t0196">
                        <字:绝对值 uof:locID="t0202" uof:attrList="值">
                            <xsl:attribute name="字:值"><xsl:value-of select="substring-before(.//@fo:margin-bottom,$uofUnit)"/></xsl:attribute>
                        </字:绝对值>
                    </字:段后距>
                </xsl:if>
            </字:段间距>
        </xsl:if>
        <xsl:if test=".//style:tab-stops">
            <xsl:element name="字:制表位设置">
                <xsl:attribute name="uof:locID">t0067</xsl:attribute>
                <xsl:for-each select=".//style:tab-stops/style:tab-stop">
                    <xsl:element name="字:制表位">
                        <xsl:attribute name="uof:locID">t0068</xsl:attribute>
                        <xsl:attribute name="uof:attrList">位置 类型 前导符</xsl:attribute>
                        <xsl:attribute name="字:位置"><xsl:value-of select="@style:position"/></xsl:attribute>
                        <xsl:variable name="aa">
                            <xsl:value-of select="@style:type"/>
                        </xsl:variable>
                        <xsl:variable name="zbflx">
                            <xsl:choose>
                                <xsl:when test="$aa='right'">right</xsl:when>
                                <xsl:when test="$aa='center'">center</xsl:when>
                                <xsl:when test="$aa='char'and @style:char!=''">decimal</xsl:when>
                                <xsl:otherwise>left</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:attribute name="字:类型"><xsl:value-of select="$zbflx"/></xsl:attribute>
                        <xsl:if test="$zbflx='decimal'">
                            <xsl:attribute name="字:制表位字符"><xsl:value-of select="@style:char"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@style:leader-char">
                            <xsl:attribute name="字:前导符"><xsl:value-of select="@style:leader-char"/></xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="textspan">
        <字:句 uof:locID="t0085">
            <xsl:choose>
                <xsl:when test="./text:footnote">
                    <xsl:call-template name="jiaozhu"/>
                </xsl:when>
                <xsl:when test="./text:endnote">
                    <xsl:call-template name="weizhu"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="字:句属性">
                        <xsl:attribute name="uof:locID">t0086</xsl:attribute>
                        <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                        <xsl:variable name="textstyle">
                            <xsl:value-of select="@text:style-name"/>
                        </xsl:variable>
                        <xsl:attribute name="字:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                        <xsl:for-each select="/office:document/office:automatic-styles//style:style[@style:family='text']">
                            <xsl:if test="@style:name=$textstyle and not(@style:parent-style-name='Standard')">
                                <xsl:if test="@style:parent-style-name=/office:document/office:styles/style:style/@style:name">
                                    <xsl:call-template name="SentenceXD">
                                        <xsl:with-param name="Sentencestyle" select="@style:parent-style-name"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="/office:document/office:styles//style:style[@style:family='text']">
                            <xsl:if test="@style:name=$textstyle">
                                <xsl:call-template name="SentenceXD">
                                    <xsl:with-param name="Sentencestyle" select="@style:name"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element>
                    <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                        <xsl:value-of select="string(.)"/>
                    </字:文本串>
                </xsl:otherwise>
            </xsl:choose>
        </字:句>
    </xsl:template>
    <xsl:template name="SentenceXD">
        <xsl:param name="Sentencestyle"/>
        <xsl:element name="字:格式修订">
            <xsl:attribute name="uof:locID">t0087</xsl:attribute>
            <xsl:attribute name="uof:attrList">修订信息引用</xsl:attribute>
            <xsl:attribute name="字:修订信息引用"><xsl:value-of select="$Sentencestyle"/></xsl:attribute>
            <xsl:element name="字:句属性">
                <xsl:attribute name="uof:locID">t0086</xsl:attribute>
                <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                <xsl:attribute name="字:式样引用"><xsl:value-of select="$Sentencestyle"/></xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="add-space">
        <xsl:param name="number"/>
        <xsl:if test="$number &gt; 1">
            <xsl:call-template name="add-space">
                <xsl:with-param name="number" select="$number - 1"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="office:styles | office:automatic-styles" mode="style">
        <xsl:for-each select="style:style[@style:family= 'paragraph' or @style:family= 'text']">
            <xsl:choose>
            <xsl:when test="@style:family = 'text'">
                    <xsl:call-template name="句式样"/>
                </xsl:when>
                <xsl:when test="@style:family = 'paragraph'">
                    <xsl:call-template name="段落式样"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="段落式样">
        <xsl:element name="uof:段落式样">
            <xsl:attribute name="uof:locID">u0044</xsl:attribute>
            <xsl:attribute name="uof:attrList">标识符 名称 类型 别名 基式样引用</xsl:attribute>
            <xsl:variable name="count"><xsl:value-of select="count(preceding::style:style)"/></xsl:variable>
            <xsl:attribute name="字:标识符"><xsl:value-of select="concat(@style:name,$count)"/></xsl:attribute>
            <xsl:attribute name="字:类型">default</xsl:attribute>
            <xsl:attribute name="字:基式样引用"><xsl:variable name="stylename" select="@style:name"/><xsl:variable name="frame-parent"><xsl:choose><xsl:when test="/office:document/office:master-styles/style:master-page/draw:frame[draw:text-box//text:p/@text:style-name = $stylename]"><xsl:for-each select="/office:document/office:master-styles/style:master-page/draw:frame[draw:text-box//text:p/@text:style-name = $stylename][1]"><xsl:variable name="frame-style" select="@presentation:style-name"/><xsl:value-of select="/office:document/*/style:style[@style:name=$frame-style]/@style:parent-style-name"/></xsl:for-each></xsl:when><xsl:otherwise>not-master</xsl:otherwise></xsl:choose></xsl:variable><xsl:choose><xsl:when test="@style:parent-style-name"><xsl:value-of select="@style:parent-style-name"/></xsl:when><xsl:when test="not($frame-parent='not-master')"><xsl:value-of select="$frame-parent"/></xsl:when></xsl:choose></xsl:attribute>
            <xsl:attribute name="字:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
            <xsl:apply-templates select="style:paragraph-properties"/>
            <xsl:for-each select="style:text-properties">
            <xsl:element name="字:句属性">
                                <xsl:attribute name="uof:locID">t0086</xsl:attribute>
                                <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                <xsl:call-template name="字:句属性"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match="style:paragraph-properties">
        <xsl:element name="字:缩进">
            <xsl:attribute name="uof:locID">t0056</xsl:attribute>
            <xsl:call-template name="字:缩进类型"/>
            </xsl:element>
        <xsl:if test="@fo:text-align | @fotext-align-last">
            <xsl:element name="字:对齐">
                <xsl:attribute name="uof:locID">t0055</xsl:attribute>
                <xsl:if test="@fo:text-align">
                <xsl:attribute name="字:水平对齐"><xsl:choose><xsl:when test=".//@fo:text-align='end'">right</xsl:when><xsl:when test=".//@fo:text-align='center'">center</xsl:when><xsl:when test=".//@fo:text-align='justify' and not(.//@fo:text-align-last='justify')">justified</xsl:when><xsl:when test=".//@fo:text-align='justify' and .//@fo:text-align-last='justify'">distributed</xsl:when><xsl:otherwise>left</xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
                <xsl:if test="@style:vertical-align">
                <xsl:attribute name="字:文字对齐"><xsl:choose><xsl:when test=".//@style:vertical-align='baseline'">base</xsl:when><xsl:when test=".//@style:vertical-align='top'">top</xsl:when><xsl:when test=".//@style:vertical-align='middle'">center</xsl:when><xsl:when test=".//@style:vertical-align='bottom'">bottom</xsl:when><xsl:otherwise>auto</xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
                <xsl:attribute name="uof:attrList">水平对齐 文字对齐</xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="句式样">
        <xsl:element name="uof:句式样">
            <xsl:attribute name="uof:locID">u0043</xsl:attribute>
            <xsl:attribute name="uof:attrList">标识符 名称 类型 别名 基式样引用</xsl:attribute>
            <xsl:attribute name="字:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
            <xsl:attribute name="字:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
            <xsl:attribute name="字:类型">auto</xsl:attribute>
            <xsl:call-template name="字:句属性"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="style:text-properties">
        <xsl:element name="字:字体">
            <xsl:attribute name="uof:locID">t0088</xsl:attribute>
            <xsl:attribute name="uof:attrList">西文字体引用 中文字体引用 特殊字体引用 西文绘制 字号 相对字号 颜色</xsl:attribute>
            <xsl:if test=".//@fo:font-size or .//@style:font-size-asian or  .//@style:font-size-complex">
                <xsl:choose>
                    <xsl:when test="contains(.//@fo:font-size,'%') or contains(.//@style:font-size-asian,'%')">
                        <xsl:attribute name="字:相对字号"><xsl:choose><xsl:when test=".//@fo:font-size"><xsl:value-of select="substring-before(.//@fo:font-size,'%')"/></xsl:when><xsl:when test=".//@style:font-size-asian"><xsl:value-of select="substring-before(.//@style:font-size-asian,'%')"/></xsl:when></xsl:choose></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="字:字号"><xsl:choose><xsl:when test=".//@fo:font-size"><xsl:value-of select="substring-before(.//@fo:font-size,'pt')"/></xsl:when><xsl:when test=".//@style:font-size-asian"><xsl:value-of select="substring-before(.//@style:font-size-asian,'pt')"/></xsl:when><xsl:when test=".//@style:font-size-complex"><xsl:value-of select="substring-before(.//@style:font-size-complex,'pt')"/></xsl:when></xsl:choose></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test=".//@style:font-name">
                <xsl:attribute name="字:西文字体引用"><xsl:value-of select=".//@style:font-name"/></xsl:attribute>
            </xsl:if>
            <xsl:if test=".//@style:font-name-asian">
                <xsl:attribute name="字:中文字体引用"><xsl:value-of select=".//@style:font-name-asian"/></xsl:attribute>
            </xsl:if>
            <xsl:if test=".//@fo:color">
                <xsl:attribute name="字:颜色"><xsl:value-of select=".//@fo:color"/></xsl:attribute>
            </xsl:if>
        </xsl:element>
        <xsl:if test="(@fo:font-weight='bold') or (@fo:font-weight-asian='bold') or (@style:font-weight-asian='bold') or (@style:font-weight-complex='bold')">
            <xsl:element name="字:粗体">
                <xsl:attribute name="字:值">1</xsl:attribute>
                <xsl:attribute name="uof:locID">t0089</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="(@style:font-style-asian='italic') or (@style:font-style-complex='italic') or (@fo:font-style-asian='italic') or (@fo:font-style='italic')">
            <xsl:element name="字:斜体">
                <xsl:attribute name="字:值">1</xsl:attribute>
                <xsl:attribute name="uof:locID">t0090</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="style:page-layout">
        <xsl:element name="演:页面设置">
            <xsl:attribute name="uof:locID">p0002</xsl:attribute>
            <xsl:attribute name="uof:attrList">标识符 名称</xsl:attribute>
            <xsl:attribute name="演:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
            <xsl:attribute name="演:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
            <xsl:attribute name="演:名称">页面设置</xsl:attribute>
            <xsl:element name="演:纸张">
                <xsl:attribute name="uof:locID">p0003</xsl:attribute>
                <xsl:attribute name="uof:attrList">宽度 高度 纸型</xsl:attribute>
                <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(style:page-layout-properties/@fo:page-width,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="uof:高度"><xsl:value-of select="substring-before(style:page-layout-properties/@fo:page-height,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="uof:纸型"><xsl:variable name="height"><xsl:value-of select="style:page-layout-properties/@fo:page-height"/></xsl:variable><xsl:variable name="width"><xsl:value-of select="style:page-layout-properties/@fo:page-width"/></xsl:variable><xsl:choose><xsl:when test="$height='29.7cm' and $width='42cm'">A3</xsl:when><xsl:when test="$height='21cm' and $width='29.7cm'">A4</xsl:when><xsl:when test="$height='14.8cm' and $width='21cm'">A5</xsl:when><xsl:when test="$height='25cm' and $width='35.3cm'">B4</xsl:when><xsl:when test="$height='17.6cm' and $width='25cm'">B5</xsl:when><xsl:when test="$height='12.5cm' and $width='17.6cm'">B6</xsl:when><xsl:otherwise>使用者</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
            <xsl:element name="演:页边距">
                <xsl:attribute name="uof:locID">p0004</xsl:attribute>
                <xsl:attribute name="uof:attrList">左 上 右 下</xsl:attribute>
                <xsl:attribute name="uof:左"><xsl:value-of select="substring-before(style:page-layout-properties/@fo:margin-left,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="uof:上"><xsl:value-of select="substring-before(style:page-layout-properties/@fo:margin-top,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="uof:右"><xsl:value-of select="substring-before(style:page-layout-properties/@fo:margin-right,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="uof:下"><xsl:value-of select="substring-before(style:page-layout-properties/@fo:margin-bottom,$uofUnit)"/></xsl:attribute>
            </xsl:element>
            <xsl:variable name="PageNumberFormat">
                <xsl:value-of select="/office:document/office:settings/config:config-item-set/config:config-item[@config:name='PageNumberFormat']"/>
            </xsl:variable>
            <xsl:if test="not($PageNumberFormat='5')">
                <xsl:element name="演:页码格式">
                    <xsl:attribute name="uof:locID">p0005</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$PageNumberFormat='0'">upper-letter</xsl:when>
                        <xsl:when test="$PageNumberFormat='1'">lower-letter</xsl:when>
                        <xsl:when test="$PageNumberFormat='2'">upper-roman</xsl:when>
                        <xsl:when test="$PageNumberFormat='3'">lower-letter</xsl:when>
                        <xsl:when test="$PageNumberFormat='4'">decimal</xsl:when>
                    </xsl:choose>
                </xsl:element>
            </xsl:if>
            <xsl:element name="演:纸张方向">
                <xsl:attribute name="uof:locID">p0006</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="style:page-layout-properties/@style:print-orientation">
                        <xsl:value-of select="style:page-layout-properties/@style:print-orientation"/>
                    </xsl:when>
                    <xsl:otherwise>portrait</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="obtain_anim_type">
        <xsl:param name="flytype"/>
        <xsl:variable name="flytypestr" select="substring-after($flytype,'from-')"/>
        <xsl:choose>
            <xsl:when test="contains($flytypestr,'-')">
                <xsl:value-of select="concat(substring-before($flytypestr,'-'),substring-after($flytypestr,'-'))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$flytypestr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="cm2pt">
        <xsl:param name="cmval"/>
        <xsl:value-of select="substring-before($cmval,$uofUnit)* $cm-to-other "/>
    </xsl:template>
    <xsl:template match="office:font-face-decls">
        <uof:字体集 uof:locID="u0040">
            <uof:默认字体 uof:ascii="Times New Roman" uof:fareast="宋体" uof:h-ansi="宋体" uof:cs="宋体"/>
            <xsl:for-each select="style:font-face">
                <xsl:element name="uof:字体声明">
                    <xsl:attribute name="uof:attrList">标识符 名称 字体族</xsl:attribute>
                    <xsl:attribute name="uof:locID">u0041</xsl:attribute>
                    <xsl:attribute name="uof:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                    <xsl:attribute name="uof:字体族"><xsl:value-of select="@svg:font-family"/></xsl:attribute>
                    <xsl:if test="@style:font-charset= '02'">
                        <xsl:attribute name="uof:字符集">x-symbol</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@style:font-family-generic">
                        <xsl:choose>
                            <xsl:when test="@style:font-family-generic = 'swiss'">
                                <xsl:attribute name="uof:字体族">Swiss</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@style:font-family-generic ='modern'">
                                <xsl:attribute name="uof:字符集">Modern</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@style:font-family-generic='roman'">
                                <xsl:attribute name="uof:字符集">Roman</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@style:font-family-generic ='script'">
                                <xsl:attribute name="uof:字符集">Script</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@style:font-family-generic ='decorative'">
                                <xsl:attribute name="uof:字符集">Decorative</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@style:font-family-generic ='system'">
                                <xsl:attribute name="uof:字符集">System</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="uof:字符集">System</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:element>
            </xsl:for-each>
            <xsl:apply-templates select="style:font-decl"/>
        </uof:字体集>
    </xsl:template>
    <xsl:template match="office:meta">
        <uof:元数据 uof:locID="u0001">
            <uof:标题 uof:locID="u0002">
                <xsl:value-of select="dc:title"/>
            </uof:标题>
            <uof:创建应用程序 uof:locID="u0011">
                <xsl:value-of select="meta:generator"/>
            </uof:创建应用程序>
            <uof:摘要 uof:locID="u0007">
                <xsl:value-of select="dc:description"/>
            </uof:摘要>
            <uof:主题 uof:locID="u0003">
                <xsl:value-of select="dc:subject"/>
            </uof:主题>
            <uof:创建者 uof:locID="u0004"/>
            <uof:作者 uof:locID="u0005">
                <xsl:value-of select="meta:initial-creator"/>
            </uof:作者>
            <uof:创建日期 uof:locID="u0008">
                <xsl:value-of select="meta:creation-date"/>
            </uof:创建日期>
            <uof:最后作者 uof:locID="u0006">
                <xsl:value-of select="dc:creator"/>
            </uof:最后作者>
            <uof:关键字集 uof:locID="u0014">
                <xsl:for-each select=".">
                    <uof:关键字 uof:locID="u0015">
                        <xsl:value-of select="meta:keywords/@meta:keyword"/>
                    </uof:关键字>
                </xsl:for-each>
            </uof:关键字集>
            <uof:编辑次数 uof:locID="u0009">
                <xsl:value-of select="meta:editing-cycles"/>
            </uof:编辑次数>
            <xsl:if test="meta:editing-duration">
                <uof:编辑时间 uof:locID="u0010">
                    <xsl:value-of select="meta:editing-duration"/>
                </uof:编辑时间>
            </xsl:if>
            <xsl:if test="meta:template/@xlink:href">
                <uof:文档模板 uof:locID="u0013">
                    <xsl:value-of select="meta:template/@xlink:href"/>
                </uof:文档模板>
            </xsl:if>
            <xsl:if test="meta:user-defined/@meta:name">
                <uof:用户自定义元数据集 uof:locID="u0016">
                    <xsl:for-each select="meta:user-defined">
                        <uof:用户自定义元数据 uof:locID="u0017" uof:attrList="名称 类型">
                            <xsl:attribute name="uof:名称"><xsl:value-of select="@meta:name"/></xsl:attribute>
                            <xsl:attribute name="uof:类型"><xsl:value-of select="'string'"/></xsl:attribute>
                        </uof:用户自定义元数据>
                    </xsl:for-each>
                </uof:用户自定义元数据集>
            </xsl:if>
            <xsl:if test="meta:document-statistic/@meta:page-count">
            <uof:页数 uof:locID="u0020">
                <xsl:value-of select="meta:document-statistic/@meta:page-count"/>
            </uof:页数>
            </xsl:if>
            <xsl:if test="meta:document-statistic/@meta:paragraph-count">
            <uof:段落数 uof:locID="u0025">
                <xsl:value-of select="meta:document-statistic/@meta:paragraph-count"/>
            </uof:段落数>
            </xsl:if>
            <xsl:if test="meta:document-statistic/@meta:object-count">
            <uof:对象数 uof:locID="u0026">
                <xsl:value-of select="meta:document-statistic/@meta:object-count"/>
            </uof:对象数>
            </xsl:if>
            <xsl:if test="meta:document-statistic/@meta:character-count">
            <uof:字数 uof:locID="u0021">
                <xsl:value-of select="meta:document-statistic/@meta:character-count"/>
            </uof:字数>
            </xsl:if>
            <xsl:if test="meta:document-statistic/@meta:word-count">
            <uof:中文字符数 uof:locID="u0023">
                <xsl:value-of select="meta:document-statistic/@meta:word-count"/>
            </uof:中文字符数>
            </xsl:if>
                    </uof:元数据>
    </xsl:template>
    <xsl:template name="填充">
        <xsl:param name="picname"/>
        <xsl:param name="nodename"/>
        <xsl:choose>
            <xsl:when test="@draw:fill='gradient'">
                <xsl:variable name="gradient-name">
                    <xsl:value-of select="@draw:fill-gradient-name"/>
                </xsl:variable>
                <xsl:for-each select="/descendant::draw:gradient[@draw:name=$gradient-name]">
                    <图:渐变 uof:locID="g0037" uof:attrList="起始色 终止色 种子类型 起始浓度 终止浓度 渐变方向 边界 种子X位置 种子Y位置 类型">
                        <xsl:attribute name="图:起始色"><xsl:value-of select="@draw:start-color"/></xsl:attribute>
                        <xsl:attribute name="图:终止色"><xsl:value-of select="@draw:end-color"/></xsl:attribute>
                        <xsl:attribute name="图:种子类型"><xsl:choose><xsl:when test="@draw:style='linear' or @draw:style='axial'">linear</xsl:when><xsl:when test="@draw:style='radial'">radar</xsl:when><xsl:when test="@draw:style='ellipsoid'">oval</xsl:when><xsl:when test="@draw:style='square'">square</xsl:when><xsl:when test="@draw:style='rectangular'">rectangle</xsl:when></xsl:choose></xsl:attribute>
                        <xsl:attribute name="图:起始浓度"><xsl:value-of select="substring-before(@draw:start-intensity,'%')"/></xsl:attribute>
                        <xsl:attribute name="图:终止浓度"><xsl:value-of select="substring-before(@draw:end-intensity,'%')"/></xsl:attribute>
                        <xsl:variable name="angle">
                            <xsl:value-of select="@draw:angle div 10"/>
                        </xsl:variable>
                        <xsl:attribute name="图:渐变方向"><xsl:choose><xsl:when test="0&lt;$angle and $angle&lt;25">0</xsl:when><xsl:when test="25&lt;$angle and $angle&lt;70">45</xsl:when><xsl:when test="70&lt;$angle and $angle&lt;115">90</xsl:when><xsl:when test="115&lt;$angle and $angle&lt;160">135</xsl:when><xsl:when test="160&lt;$angle and $angle&lt;205">180</xsl:when><xsl:when test="205&lt;$angle and $angle&lt;250">225</xsl:when><xsl:when test="250&lt;$angle and $angle&lt;295">270</xsl:when><xsl:when test="295&lt;$angle and $angle&lt;340">315</xsl:when><xsl:when test="340&lt;$angle and $angle&lt;360">360</xsl:when></xsl:choose></xsl:attribute>
                        <xsl:attribute name="图:边界"><xsl:value-of select="substring-before(@draw:border,'%')"/></xsl:attribute>
                        <xsl:if test="@draw:cx">
                            <xsl:attribute name="图:种子X位置"><xsl:value-of select="substring-before(@draw:cx,'%')"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@draw:cy">
                            <xsl:attribute name="图:种子Y位置"><xsl:value-of select="substring-before(@draw:cy,'%')"/></xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="图:类型">-2</xsl:attribute>
                    </图:渐变>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="@draw:fill='bitmap'">
                <图:图片 uof:locID="g0035" uof:attrList="位置 图形引用 类型 名称">
                    <xsl:attribute name="图:位置"><xsl:choose><xsl:when test="not(@style:repeat)">title</xsl:when><xsl:otherwise><xsl:choose><xsl:when test="@style:repeat = 'stretch'">stretch</xsl:when><xsl:when test="@style:repeat = 'repeat'">title</xsl:when><xsl:when test="@style:repeat = 'no-repeat'">center</xsl:when></xsl:choose></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="图:图形引用"><xsl:value-of select="@draw:fill-image-name"/></xsl:attribute>
                    <xsl:attribute name="图:类型">png</xsl:attribute>
                    <xsl:attribute name="图:名称"><xsl:value-of select="concat($picname,'_b1')"/></xsl:attribute>
                </图:图片>
            </xsl:when>
            <xsl:when test="@draw:fill='hatch'">
                <图:图案 uof:locID="g0036" uof:attrList="类型 图形引用 前景色 背景色">
                    <xsl:attribute name="图:类型"><xsl:value-of select="/office:document/office:styles/draw:hatch/@draw:name"/></xsl:attribute>
                    <xsl:attribute name="图:图形引用"/>
                    <xsl:attribute name="图:前景色"><xsl:value-of select="/office:document/office:styles/draw:hatch/@draw:color"/></xsl:attribute>
                    <xsl:attribute name="图:背景色"><xsl:choose><xsl:when test="@draw:fill-color"><xsl:value-of select="@draw:fill-color"/></xsl:when><xsl:otherwise>#ffffff</xsl:otherwise></xsl:choose></xsl:attribute>
                </图:图案>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$nodename='draw:frame'">
                        <xsl:if test="@draw:fill='solid'">
                            <图:颜色 uof:locID="g0034">
                                <xsl:value-of select="@draw:fill-color"/>
                            </图:颜色>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <图:颜色 uof:locID="g0034">
                            <xsl:choose>
                                <xsl:when test="@draw:fill-color">
                                    <xsl:value-of select="@draw:fill-color"/>
                                </xsl:when>
                                <xsl:otherwise>#99ccff</xsl:otherwise>
                            </xsl:choose>
                        </图:颜色>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="字:缩进类型">
        <xsl:if test="style:list-level-properties/@text:space-before">
            <字:左 uof:locID="t0182">
                <字:绝对  uof:locID="t0185" uof:attrList="值">
                    <xsl:attribute name="字:值"><xsl:value-of select="substring-before(style:list-level-properties/@text:space-before,$uofUnit)"/></xsl:attribute>
                </字:绝对>
            </字:左>
        </xsl:if>
        <xsl:if test="style:list-level-properties/@text:min-label-width">
            <字:右 uof:locID="t0183">
                <字:绝对 uof:locID="t0187" uof:attrList="值">
                    <xsl:attribute name="字:值"><xsl:value-of select="substring-before(style:list-level-properties/@text:min-label-width,$uofUnit)"/></xsl:attribute>
         </字:绝对>
                </字:右>
        </xsl:if>
        <xsl:if test="style:list-level-properties/@text:min-label-distance">
            <字:首行 uof:locID="t0184">
                <字:绝对 uof:locID="t0189" uof:attrList="值">
                    <xsl:attribute name="字:值"><xsl:value-of select="substring-before(style:list-level-properties/@text:min-label-distance,$uofUnit)"/></xsl:attribute>
        </字:绝对>
                </字:首行>
        </xsl:if>
    </xsl:template>
    <xsl:template name="uof:线型类型">
        <xsl:param name="lineType"/>
        <xsl:choose>
            <xsl:when test="$lineType='single-line'">single</xsl:when>
            <xsl:when test="$lineType='double-line'">double</xsl:when>
            <xsl:when test="$lineType='single'">single</xsl:when>
            <xsl:when test="$lineType='double'">double</xsl:when>
            <xsl:when test="$lineType='dash'">dash</xsl:when>
            <xsl:when test="$lineType='long-dash'">dash-long</xsl:when>
            <xsl:when test="$lineType='dot-dash'">dot-dash</xsl:when>
            <xsl:when test="$lineType='dot-dot-dash'">dot-dot-dash</xsl:when>
            <xsl:when test="$lineType='wave'">wave</xsl:when>
            <xsl:when test="$lineType='bold-dotted'">dotted-heavy</xsl:when>
            <xsl:when test="$lineType='bold-dash'">dashed-heavy</xsl:when>
            <xsl:when test="$lineType='bold-long-dash'">dash-long-heavy</xsl:when>
            <xsl:when test="$lineType='bold-dot-dash'">dash-dot-heavy</xsl:when>
            <xsl:when test="$lineType='bold-dot-dot-dash'">dash-dot-dot-heavy</xsl:when>
            <xsl:when test="$lineType='bold-wave'">wavy-heavy</xsl:when>
            <xsl:when test="$lineType='double-wave'">wavy-double</xsl:when>
            <xsl:when test="$lineType='bold'">bold</xsl:when>
            <xsl:when test="$lineType='small-wave'">wave</xsl:when>
            <xsl:when test="$lineType='dotted'">dotted</xsl:when>
            <xsl:when test="$lineType='none'">none</xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
