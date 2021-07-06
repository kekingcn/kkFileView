<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:uof="http://schemas.uof.org/cn/2003/uof" xmlns:表="http://schemas.uof.org/cn/2003/uof-spreadsheet" xmlns:演="http://schemas.uof.org/cn/2003/uof-slideshow" xmlns:字="http://schemas.uof.org/cn/2003/uof-wordproc" xmlns:图="http://schemas.uof.org/cn/2003/graph" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0" xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0" office:version="1.0" exclude-result-prefixes="office style text table draw fo xlink dc meta number presentation svg chart dr3d math form script config ooo ooow oooc dom xforms smil anim">
    <xsl:output method="xml" indent="no" encoding="UTF-8" version="1.0"/>
    <xsl:variable name="scValueWithUnit">
        <xsl:value-of select="/office:document/office:automatic-styles/style:style[@style:name='co1']/style:table-column-properties/@style:column-width"/>
    </xsl:variable>
    <xsl:variable name="uofUnit">
        <xsl:choose>
            <xsl:when test="contains($scValueWithUnit,'in')">inch</xsl:when>
            <xsl:when test="contains($scValueWithUnit,'cm')">cm</xsl:when>
            <xsl:when test="contains($scValueWithUnit,'mm')">mm</xsl:when>
            <xsl:when test="contains($scValueWithUnit,'pt')">pt</xsl:when>
            <xsl:otherwise>inch</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="ooUnit">
        <xsl:choose>
            <xsl:when test="contains($scValueWithUnit,'inch')">inch</xsl:when>
            <xsl:when test="contains($scValueWithUnit,'cm')">cm</xsl:when>
            <xsl:when test="contains($scValueWithUnit,'mm')">mm</xsl:when>
            <xsl:when test="contains($scValueWithUnit,'pt')">pt</xsl:when>
            <xsl:otherwise>inch</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="office:document">
        <uof:UOF xmlns:uof="http://schemas.uof.org/cn/2003/uof" xmlns:表="http://schemas.uof.org/cn/2003/uof-spreadsheet" xmlns:演="http://schemas.uof.org/cn/2003/uof-slideshow" xmlns:字="http://schemas.uof.org/cn/2003/uof-wordproc" xmlns:图="http://schemas.uof.org/cn/2003/graph" uof:language="cn" uof:locID="u0000" uof:version="1.0" uof:mimetype="vnd.uof.spreadsheet">
            <xsl:apply-templates select="/office:document/office:meta"/>
            <uof:对象集 uof:locID="u0033">
                <xsl:if test="/office:document/office:body/office:spreadsheet/table:table//table:table-cell/office:annotation">
                    <xsl:for-each select="/office:document/office:body/office:spreadsheet/table:table//table:table-cell/office:annotation">
                        <xsl:variable name="num">
                            <xsl:value-of select="substring-after(@draw:style-name,'gr')"/>
                        </xsl:variable>
                        <图:图形 uof:locID="g0000" uof:attrList="层次 标识符 组合列表 其他对象">
                            <xsl:attribute name="图:标识符"><xsl:value-of select="concat('pz',$num)"/></xsl:attribute>
                            <xsl:variable name="name" select="@draw:style-name"/>
                            <图:预定义图形 uof:locID="g0005">
                                <图:属性 uof:locID="g0011">
                                    <xsl:for-each select="/office:document/office:automatic-styles/style:style[@style:name=$name]">
                                        <xsl:call-template name="graphicattr"/>
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
                            <图:文本内容 uof:locID="g0002" uof:attrList="文本框 左边距 右边距 上边距 下边距 水平对齐 垂直对齐 文字排列方向 自动换行 大小适应文字 前一链接 后一链接">
                                <xsl:for-each select="/office:document/office:automatic-styles/style:style[@style:name=$name]">
                                    <xsl:attribute name="图:文字排列方向"><xsl:choose><xsl:when test="style:paragraph-properties/@style:writing-mode"><xsl:choose><xsl:when test="style:paragraph-properties/@style:writing-mode='tb-rl'">vert-r2l</xsl:when><xsl:when test="style:paragraph-properties/@style:writing-mode='tb-lr'">vert-l2r</xsl:when></xsl:choose></xsl:when><xsl:when test="style:graphic-properties/@draw:textarea-horizontal-align='right'">hori-r2l</xsl:when><xsl:otherwise>hori-l2r</xsl:otherwise></xsl:choose></xsl:attribute>
                                    <xsl:if test="style:graphic-properties/@draw:textarea-horizontal-align">
                                        <xsl:attribute name="图:水平对齐"><xsl:value-of select="style:graphic-properties/@draw:textarea-horizontal-align"/></xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="style:graphic-properties/@draw:textarea-vertical-align">
                                        <xsl:attribute name="图:垂直对齐"><xsl:value-of select="style:graphic-properties/@draw:textarea-vertical-align"/></xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="style:graphic-properties/@fo:wrap-option">
                                        <xsl:attribute name="图:自动换行">true</xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="style:graphic-properties/@draw:auto-grow-width='true' and style:graphic-properties/@draw:auto-grow-height='true'">
                                        <xsl:attribute name="图:大小适应文字">true</xsl:attribute>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="./text:p">
                                    <xsl:call-template name="textp"/>
                                </xsl:for-each>
                            </图:文本内容>
                        </图:图形>
                    </xsl:for-each>
                </xsl:if>
                <xsl:for-each select="/office:document/office:body/office:spreadsheet/table:table//table:table-cell/office:annotation">
                    <xsl:variable name="name1" select="@draw:style-name"/>
                    <xsl:for-each select="/office:document/office:automatic-styles/style:style[@style:name=$name1]">
                        <xsl:if test="style:graphic-properties/@draw:fill-image-name">
                            <xsl:variable name="bsh">
                                <xsl:value-of select="style:graphic-properties/@draw:fill-image-name"/>
                            </xsl:variable>
                            <xsl:for-each select="/office:document/office:styles/draw:fill-image">
                                <xsl:if test="@draw:name=$bsh">
                                    <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                                        <xsl:attribute name="uof:标识符"><xsl:value-of select="concat($name1,'_b1')"/></xsl:attribute>
                                        <xsl:attribute name="uof:公共类型">png</xsl:attribute>
                                        <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                                        <uof:数据 uof:locID="u0037">
                                            <xsl:value-of select="office:binary-data"/>
                                        </uof:数据>
                                    </uof:其他对象>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="/office:document/office:body/office:spreadsheet/table:table/table:shapes/child::* | /office:document/office:body/office:spreadsheet/table:table/table:table-row/table:table-cell/child::*">
                    <xsl:if test="starts-with(name(.),'draw:')">
                        <xsl:choose>
                            <xsl:when test="name(.)='draw:frame' and self::node()/draw:object">
                                <xsl:for-each select="draw:image">
                                    <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                                        <xsl:attribute name="uof:标识符"><xsl:value-of select="concat('chart_image_',count(preceding::draw:fill-image))"/></xsl:attribute>
                                        <xsl:attribute name="uof:公共类型">png</xsl:attribute>
                                        <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                                        <uof:数据 uof:locID="u0037">
                                            <xsl:value-of select="office:binary-data"/>
                                        </uof:数据>
                                    </uof:其他对象>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="draw">
                                    <xsl:with-param name="nodename1" select="name(.)"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </uof:对象集>
            <xsl:if test="/office:document/office:body//text:bookmark-start">
                <uof:书签集 uof:locID="u0027">
                    <xsl:for-each select="/office:document/office:body//text:bookmark-start">
                        <xsl:element name="uof:书签">
                            <xsl:attribute name="uof:名称"><xsl:value-of select="@text:name"/></xsl:attribute>
                            <xsl:attribute name="uof:locID">u0028</xsl:attribute>
                            <xsl:attribute name="uof:attrList">名称</xsl:attribute>
                            <xsl:element name="uof:文本位置">
                                <xsl:attribute name="字:区域引用"><xsl:value-of select="concat('bk_',@text:name)"/></xsl:attribute>
                                <xsl:attribute name="uof:locID">u0029</xsl:attribute>
                                <xsl:attribute name="uof:attrList">区域引用</xsl:attribute>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </uof:书签集>
            </xsl:if>
            <xsl:if test="/office:document/office:body/text:p/text:a">
                <uof:链接集 uof:locID="u0031">
                    <xsl:for-each select="/office:document/office:body/text:p/text:a">
                        <!--chengxz 要改-->
                        <xsl:variable name="hyperStr" select="@xlink:href"/>
                        <xsl:element name="uof:超级链接">
                            <xsl:if test="contains($hyperStr,'#')">
                                <xsl:attribute name="uof:书签"><xsl:value-of select="substring-after($hyperStr,'#')"/></xsl:attribute>
                            </xsl:if>
                            <!--暂时不写uof:提示-->
                            <xsl:attribute name="uof:链源">hlnk<xsl:number from="/office:document/office:body" level="any" count="text:p[text:a]"/></xsl:attribute>
                            <xsl:if test="contains($hyperStr,'http://') or contains($hyperStr,'mailto')">
                                <xsl:attribute name="uof:目标"><xsl:value-of select="$hyperStr"/></xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="uof:locID">u0032</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符 目标 书签 式样引用 已访问式样引用 提示 链源</xsl:attribute>
                        </xsl:element>
                    </xsl:for-each>
                </uof:链接集>
            </xsl:if>
            <uof:式样集 uof:locID="u0039">
                <xsl:apply-templates select="/office:document/office:font-face-decls"/>
                <xsl:apply-templates select="/office:document/office:styles/style:style" mode="styles"/>
                <xsl:apply-templates select="/office:document/office:automatic-styles/style:style" mode="styles">
                    <xsl:with-param name="isAutomatic" select="true()"/>
                </xsl:apply-templates>
            </uof:式样集>
            <uof:电子表格 uof:locID="u0049">
                <表:公用处理规则 uof:locID="s0000">
                    <表:度量单位 uof:locID="s0001">
                        <xsl:value-of select="$uofUnit"/>
                    </表:度量单位>
                    <xsl:apply-templates select="/office:document/office:body/office:spreadsheet/table:calculation-settings" mode="common"/>
                    <xsl:apply-templates select="/office:document/office:body/office:spreadsheet/table:content-validations" mode="common"/>
                    <xsl:if test="/office:document/office:automatic-styles/style:style[@style:family='table-cell' and style:map]">
                        <xsl:element name="表:条件格式化集">
                            <xsl:attribute name="uof:locID">s0016</xsl:attribute>
                            <xsl:call-template name="create-condition-format"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="/office:document/office:body/office:spreadsheet/table:database-ranges/table:database-range">
                        <表:区域公式集 uof:locID="s0122">
                            <表:区域公式 uof:locID="s0123" uof:attrList="类型">
                                <xsl:attribute name="表:类型">table</xsl:attribute>
                                <xsl:for-each select="/office:document/office:body/office:spreadsheet/table:database-ranges/table:database-range">
                                    <表:区域 uof:locID="s0007">
                                        <xsl:value-of select="@table:target-range-address"/>
                                    </表:区域>
                                    <表:公式 uof:locID="s0125"/>
                                </xsl:for-each>
                            </表:区域公式>
                        </表:区域公式集>
                    </xsl:if>
                    <表:是否RC引用 uof:locID="s0124" uof:attrList="值" 表:值="false"/>
                </表:公用处理规则>
                <表:主体 uof:locID="s0024">
                    <xsl:apply-templates select="office:body"/>
                </表:主体>
            </uof:电子表格>
        </uof:UOF>
    </xsl:template>
    <xsl:template match="office:body">
        <xsl:apply-templates select="office:spreadsheet"/>
    </xsl:template>
    <xsl:template match="office:spreadsheet">
        <xsl:apply-templates select="./*"/>
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
            <xsl:if test="dc:creator">
                <uof:最后作者 uof:locID="u0006">
                    <xsl:value-of select="dc:creator"/>
                </uof:最后作者>
            </xsl:if>
            <uof:关键字集 uof:locID="u0014">
                <uof:关键字 uof:locID="u0015">
                    <xsl:value-of select="meta:keyword"/>
                </uof:关键字>
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
                            <xsl:value-of select="."/>
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
            <xsl:if test="meta:document-statistic/@meta:character-count - meta:document-statistic/@meta:word-count">
                <uof:英文字符数 uof:locID="u0022">
                    <xsl:value-of select="meta:document-statistic/@meta:character-count - meta:document-statistic/@meta:word-count"/>
                </uof:英文字符数>
            </xsl:if>
            <xsl:if test="meta:document-statistic/@meta:character-count">
                <uof:行数 uof:locID="u0024">
                    <xsl:variable name="quzhi">
                        <xsl:value-of select="(meta:document-statistic/@meta:character-count div 39) + 0.9"/>
                    </xsl:variable>
                    <xsl:value-of select="substring-before($quzhi,'.')"/>
                </uof:行数>
            </xsl:if>
            <xsl:if test="meta:user-defined[@meta:name='Category']">
                <uof:分类 uof:locID="u0012">
                    <xsl:value-of select="meta:user-defined[@meta:name='Category']"/>
                </uof:分类>
            </xsl:if>
            <xsl:if test="meta:user-defined[@meta:name='Manager']">
                <uof:经理名称 uof:locID="u0019">
                    <xsl:value-of select="meta:user-defined[meta:name='Manager']"/>
                </uof:经理名称>
            </xsl:if>
            <xsl:if test="meta:user-defined[@meta:name='Company']">
                <uof:公司名称 uof:locID="u0018">
                    <xsl:value-of select="meta:user-defined[meta:name='Company']"/>
                </uof:公司名称>
            </xsl:if>
        </uof:元数据>
    </xsl:template>
    <xsl:template match="table:table">
        <xsl:element name="表:工作表">
            <xsl:attribute name="uof:locID">s0025</xsl:attribute>
            <xsl:attribute name="uof:attrList">标识符 名称 隐藏 背景 式样引用</xsl:attribute>
            <xsl:attribute name="表:标识符"><xsl:value-of select="@table:name"/></xsl:attribute>
            <xsl:attribute name="表:名称"><xsl:value-of select="@table:name"/></xsl:attribute>
            <xsl:attribute name="表:隐藏"><xsl:choose><xsl:when test="@table:style-name='ta1'"><xsl:value-of select="'false'"/></xsl:when><xsl:otherwise><xsl:value-of select="'true'"/></xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="表:背景"><xsl:choose><xsl:when test="/office:document/office:automatic-styles/style:page-master/style:table-properties/@fo:background-color"><xsl:value-of select="/office:document/office:automatic-styles/style:page-master/style:table-properties/@fo:background-color"/></xsl:when><xsl:otherwise>#ffffff</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="表:式样引用"><xsl:value-of select="@table:style-name"/></xsl:attribute>
            <xsl:element name="表:工作表属性">
                <xsl:attribute name="uof:locID">s0026</xsl:attribute>
                <表:标签前景色 uof:locID="s0027">#000000</表:标签前景色>
                <表:标签背景色 uof:locID="s0028">#ffffff</表:标签背景色>
                <xsl:call-template name="create-page-setting">
                    <xsl:with-param name="master-page" select="/*/office:master-styles/style:master-page"/>
                    <xsl:with-param name="page-master-style" select="/*/office:automatic-styles/style:page-layout/style:page-layout-properties"/>
                </xsl:call-template>
                <xsl:call-template name="create-view">
                    <xsl:with-param name="table-name" select="/*/office:body/office:spreadsheet/table:table/@table:name"/>
                    <xsl:with-param name="view-id" select="count(preceding-sibling::table:table) + 1"/>
                    <xsl:with-param name="aaa" select="/*/office:settings/config:config-item-set/config:config-item-map-indexed/config:config-item-map-entry"/>
                </xsl:call-template>
            </xsl:element>
            <xsl:call-template name="table"/>
            <xsl:variable name="filter" select="/*/office:body/office:spreadsheet/table:database-ranges/table:database-range"/>
            <xsl:if test="$filter">
                <xsl:variable name="target-range-address" select="//table:database-range[table:filter]/@table:target-range-address"/>
                <xsl:element name="表:筛选">
                    <xsl:attribute name="uof:locID">s0101</xsl:attribute>
                    <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                    <xsl:attribute name="表:类型"><xsl:choose><xsl:when test="$filter/@table:display-filter-buttons">auto</xsl:when><xsl:otherwise>advance</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:element name="表:范围">
                        <xsl:attribute name="uof:locID">s0102</xsl:attribute>
                        <xsl:value-of select="$filter/@table:target-range-address"/>
                    </xsl:element>
                    <xsl:variable name="column-and-row" select="substring-before(substring-after($target-range-address,'.'),':')"/>
                    <xsl:variable name="dd" select="number(substring($column-and-row,2,1))"/>
                    <xsl:variable name="zone-left-column-string">
                        <xsl:choose>
                            <xsl:when test="contains($dd,'NaN') ">
                                <xsl:value-of select="substring($column-and-row,1,2)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring($column-and-row,1,1)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="zone-left-column-num">
                        <xsl:call-template name="translate-column-char-to-number">
                            <xsl:with-param name="string" select="$zone-left-column-string"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:call-template name="create-filter-conditions">
                        <xsl:with-param name="filter-condition-set" select="$filter//table:filter-condition"/>
                        <xsl:with-param name="zone-left-column-num" select="$zone-left-column-num"/>
                    </xsl:call-template>
                    <xsl:if test="$filter/@table:condition-source-range-address">
                        <xsl:element name="表:条件区域">
                            <xsl:attribute name="uof:locID">s0108</xsl:attribute>
                            <xsl:value-of select="$filter/@table:condition-source-range-address"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$filter/@table:display-duplicates">
                        <xsl:element name="表:结果区域">
                            <xsl:attribute name="uof:locID">s0109</xsl:attribute>
                            <xsl:value-of select="$filter/@table:display-duplicates"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
            <xsl:if test="key('styles', .//@table:style-name)/style:table-row-properties/@fo:break-before = 'page' or key('styles',.//@table:style-name)/style:table-column-properties/@fo:break-before='page'">
                <xsl:element name="表:分页符集">
                    <xsl:attribute name="uof:locID">s0111</xsl:attribute>
                    <xsl:call-template name="分页符集"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:param name="tableElement" select="'表:工作表内容'"/>
    <xsl:param name="rowElement" select="'表:行'"/>
    <!--xsl:param name="cellElement" select="'表:单元格'" /-->
    <!-- ************** -->
    <!-- *** Table  *** -->
    <!-- ************** -->
    <xsl:template name="table">
        <!-- The table will only be created if the table:scenario is active -->
        <xsl:if test="not(table:scenario) or table:scenario/@table:is-active">
            <xsl:call-template name="create-table"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="create-table">
        <!-- collecting all visible "table:table-row" elements of the table -->
        <xsl:variable name="allVisibleTableRows" select="table:table-row[not(@table:visibility = 'collapse' or @table:visibility = 'filter')] | table:table-header-rows/descendant::table:table-row[not(@table:visibility = 'collapse' or @table:visibility = 'filter')] | table:table-row-group/descendant::table:table-row[not(@table:visibility = 'collapse' or @table:visibility = 'filter')]"/>
        <xsl:call-template name="create-table-element">
            <xsl:with-param name="allVisibleTableRows" select="$allVisibleTableRows"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="create-table-element">
        <xsl:param name="allVisibleTableRows"/>
        <xsl:element name="表:工作表内容">
            <xsl:attribute name="uof:locID">s0018</xsl:attribute>
            <xsl:attribute name="uof:attrList">最大行 最大列 缺省行高 缺省列宽</xsl:attribute>
            <xsl:variable name="group-column" select="./table:table-column-group"/>
            <xsl:variable name="group-row" select="./table:table-row-group"/>
            <xsl:apply-templates select="@table:style-name"/>
            <xsl:for-each select="table:table-column">
                <表:列 uof:locID="s0048" uof:attrList="列号 隐藏 列宽 式样引用 跨度">
                    <xsl:attribute name="表:列号"><xsl:value-of select="position()"/></xsl:attribute>
                    <xsl:if test="@table:visibility">
                        <xsl:attribute name="表:隐藏"><xsl:choose><xsl:when test="@table:visibility='collapse'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="表:列宽"><xsl:value-of select="substring-before(key('styles',@table:style-name)/style:table-column-properties/@style:column-width,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="表:式样引用"><xsl:value-of select="@table:style-name"/></xsl:attribute>
                    <xsl:attribute name="表:跨度"><xsl:choose><xsl:when test="@table:number-columns-repeated"><xsl:value-of select="@table:number-columns-repeated"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute>
                </表:列>
            </xsl:for-each>
            <xsl:variable name="columnNodes" select="table:table-column"/>
            <xsl:variable name="columnsRepeated" select="table:table-column/@table:number-columns-repeated"/>
            <xsl:variable name="columnCount">
                <xsl:choose>
                    <xsl:when test="$columnNodes[last()]/@table:number-columns-repeated &gt; 99">
                        <xsl:value-of select="count($columnNodes)+ number(sum($columnsRepeated))- count($columnsRepeated)- $columnNodes[last()]/@table:number-columns-repeated+ 1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="count($columnNodes)+ number(sum($columnsRepeated))- count($columnsRepeated)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="table-name" select="@table:name"/>
            <xsl:apply-templates select="table:table-row">
                <xsl:with-param name="table-name" select="$table-name"/>
                <xsl:with-param name="columnCount" select="$columnCount"/>
            </xsl:apply-templates>
            <xsl:if test="table:table-row-group//table:table-row">
                <xsl:apply-templates select="table:table-row-group//table:table-row">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="columnCount" select="$columnCount"/>
                </xsl:apply-templates>
            </xsl:if>
            <xsl:for-each select="table:shapes/child::*">
                <xsl:if test="starts-with(name(.),'draw:')">
                    <xsl:choose>
                        <xsl:when test="name(.)='draw:frame' and self::node()/draw:object">
                            <xsl:call-template name="draw:chart-frame">
                                <xsl:with-param name="table-name" select="$table-name"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="uof锚点"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="table:table-row-group or table:table-column-group">
                <xsl:element name="表:分组集">
                    <xsl:attribute name="uof:locID">s0098</xsl:attribute>
                    <xsl:for-each select="table:table-column-group">
                        <xsl:variable name="numcolumnrep" select="count(descendant::table:table-column[@table:number-columns-repeated])"/>
                        <xsl:variable name="numrep" select="sum(descendant::table:table-column/@table:number-columns-repeated)"/>
                        <xsl:variable name="numcolumn" select="count(descendant::table:table-column)"/>
                        <xsl:call-template name="table:table-column-group">
                            <xsl:with-param name="start" select="count(preceding::table:table-column)"/>
                            <xsl:with-param name="end" select="count(preceding::table:table-column) + $numrep + $numcolumn - $numcolumnrep"/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:for-each select="table:table-row-group">
                        <xsl:variable name="numrowrep" select="count(descendant::table:table-row[@table:number-rows-repeated])"/>
                        <xsl:variable name="numrep" select="sum(descendant::table:table-row/@table:number-rows-repeated)"/>
                        <xsl:variable name="numrow" select="count(descendant::table:table-row)"/>
                        <xsl:call-template name="table:table-row-group">
                            <xsl:with-param name="start" select="count(preceding::table:table-row)"/>
                            <xsl:with-param name="end" select="count(preceding::table:table-row) + $numrep + $numrow - $numrowrep"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="table:table-row-group">
        <xsl:param name="start"/>
        <xsl:param name="end"/>
        <xsl:element name="表:行">
            <xsl:attribute name="uof:locID">s0100</xsl:attribute>
            <xsl:attribute name="uof:attrList">起始 终止 隐藏</xsl:attribute>
            <xsl:attribute name="表:起始"><xsl:value-of select="$start + 1"/></xsl:attribute>
            <xsl:attribute name="表:终止"><xsl:value-of select="$end"/></xsl:attribute>
            <xsl:attribute name="表:隐藏"><xsl:choose><xsl:when test="@table:display"><xsl:value-of select="'true'"/></xsl:when><xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:element>
        <xsl:for-each select="table:table-row-group">
            <xsl:call-template name="table:table-row-group">
                <xsl:with-param name="start" select="count(preceding::table:table-row) + number(sum(preceding::table:table-row/@table:number-rows-repeated)) - count(preceding::table:table-row[@table:number-rows-repeated])"/>
                <xsl:with-param name="end" select="count(preceding::table:table-row) + number(sum(preceding::table:table-row/@table:number-rows-repeated)) - count(preceding::table:table-row[@table:number-rows-repeated]) + number(sum(descendant::table:table-row/@table:number-rows-repeated)) + count(descendant::table:table-row) - count(descendant::table:table-row[@table:number-rows-repeated])"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="table:table-column-group">
        <xsl:param name="start"/>
        <xsl:param name="end"/>
        <xsl:element name="表:列">
            <xsl:attribute name="uof:locID">s0099</xsl:attribute>
            <xsl:attribute name="uof:attrList">起始 终止 隐藏</xsl:attribute>
            <xsl:attribute name="表:起始"><xsl:value-of select="$start + 1"/></xsl:attribute>
            <xsl:attribute name="表:终止"><xsl:value-of select="$end"/></xsl:attribute>
            <xsl:attribute name="表:隐藏"><xsl:choose><xsl:when test="@table:display"><xsl:value-of select="'true'"/></xsl:when><xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:element>
        <xsl:for-each select="table:table-column-group">
            <xsl:call-template name="table:table-column-group">
                <xsl:with-param name="start" select="count(preceding::table:table-column) + number(sum(preceding::table:table-column/@table:number-columns-repeated)) - count(preceding::table:table-column[@table:number-columns-repeated])"/>
                <xsl:with-param name="end" select="count(preceding::table:table-column) + number(sum(preceding::table:table-column/@table:number-columns-repeated)) - count(preceding::table:table-column[@table:number-columns-repeated]) + number(sum(descendant::table:table-column/@table:number-columns-repeated)) + count(descendant::table:table-column) - count(descendant::table:table-column[@table:number-columns-repeated])"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="uof锚点">
        <xsl:if test="not(name(.)='draw:glue-point')">
            <xsl:variable name="name">
                <xsl:value-of select="name(.)"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="name='draw:a'">
                    <xsl:for-each select="child::node( )">
                        <xsl:call-template name="uof锚点"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <uof:锚点 uof:locID="u0064" uof:attrList="x坐标 y坐标 宽度 高度 图形引用 随动方式 缩略图 占位符">
                        <xsl:attribute name="uof:x坐标"><xsl:choose><xsl:when test="name(.)='draw:g'"><xsl:call-template name="groupminx"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:x][1]/@svg:x,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="@svg:x"><xsl:value-of select="substring-before(@svg:x,$uofUnit)"/></xsl:when><xsl:when test="@svg:x1"><xsl:value-of select="substring-before(@svg:x1,$uofUnit)"/></xsl:when></xsl:choose></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:y坐标"><xsl:choose><xsl:when test="name(.)='draw:g'"><xsl:call-template name="groupminx"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:y][1]/@svg:y,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="@svg:y"><xsl:value-of select="substring-before(@svg:y,$uofUnit)"/></xsl:when><xsl:when test="@svg:y1"><xsl:value-of select="substring-before(@svg:y1,$uofUnit)"/></xsl:when></xsl:choose></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:宽度"><xsl:choose><xsl:when test="@svg:width"><xsl:value-of select="substring-before(@svg:width,$uofUnit)"/></xsl:when><xsl:when test="@svg:x1"><xsl:value-of select="substring-before(@svg:x2,$uofUnit) - substring-before(@svg:x1,$uofUnit)"/></xsl:when><xsl:when test="name(.)='draw:g'"><xsl:variable name="minx"><xsl:call-template name="groupminx"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:x][1]/@svg:x,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable><xsl:variable name="svgx"><xsl:value-of select="number(substring-before(descendant::node()[@svg:x][1]/@svg:x,$uofUnit))"/></xsl:variable><xsl:variable name="width"><xsl:value-of select="number(substring-before(descendant::node()[@svg:x][1]/@svg:width,$uofUnit))"/></xsl:variable><xsl:variable name="maxx"><xsl:call-template name="groupmaxx"><xsl:with-param name="value" select="$svgx + $width"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable><xsl:value-of select="$maxx - $minx"/></xsl:when></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:高度"><xsl:choose><xsl:when test="@svg:height"><xsl:value-of select="substring-before(@svg:height,$uofUnit)"/></xsl:when><xsl:when test="@svg:x1"><xsl:value-of select="substring-before(@svg:y2,$uofUnit) - substring-before(@svg:y1,$uofUnit)"/></xsl:when><xsl:when test="name(.)='draw:g'"><xsl:variable name="miny"><xsl:call-template name="groupminy"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:y][1]/@svg:y,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable><xsl:variable name="svgy"><xsl:value-of select="number(substring-before(descendant::node()[@svg:y][1]/@svg:y,$uofUnit))"/></xsl:variable><xsl:variable name="height"><xsl:value-of select="number(substring-before(descendant::node()[@svg:y][1]/@svg:height,$uofUnit))"/></xsl:variable><xsl:variable name="maxy"><xsl:call-template name="groupmaxy"><xsl:with-param name="value" select="$svgy + $height"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable><xsl:value-of select="$maxy - $miny"/></xsl:when></xsl:choose></xsl:attribute>
                        <xsl:variable name="refpicname">
                            <xsl:choose>
                                <xsl:when test="./@draw:style-name">
                                    <xsl:value-of select="@draw:style-name"/>
                                </xsl:when>
                                <xsl:when test="./@table:end-cell-address">
                                    <xsl:value-of select="@table:end-cell-address"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="./@draw:id"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:attribute name="uof:图形引用"><xsl:variable name="picnumber"><xsl:value-of select="count(preceding::*[@draw:style-name=$refpicname])"/></xsl:variable><xsl:value-of select="concat($refpicname,'_',$picnumber)"/></xsl:attribute>
                        <xsl:attribute name="uof:随动方式"><xsl:choose><xsl:when test="key('graphicset',$refpicname)/style:graphic-properties/@style:protect"><xsl:for-each select="key('graphicset',$refpicname)/style:graphic-properties"><xsl:choose><xsl:when test="@style:protect='size'">move</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:for-each></xsl:when><xsl:otherwise>movesize</xsl:otherwise></xsl:choose></xsl:attribute>
                    </uof:锚点>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!--end 06.02.14 -->
    <!-- **************** -->
    <!-- *** Columns  *** -->
    <!-- **************** -->
    <!--Redoffice comment liliang 06.05.23-->
    <!--xsl:template name="create-table-column">
        <xsl:param name="columnNodes"/>
        <xsl:param name="currentColumn"/>
        <xsl:param name="columnCount"/>
        <xsl:param name="columnNo"/>
        <xsl:param name="columnNodeNo"/>
        <xsl:param name="index"/>
        <xsl:element name="表:列">
            <xsl:attribute name="locID">s0048</xsl:attribute>
            <xsl:attribute name="attrList">列号 隐藏 列宽 式样引用 跨度</xsl:attribute>
            <xsl:if test="$currentColumn/@table:visibility = 'collapse' or $currentColumn/@table:visibility = 'filter'">
                <xsl:attribute name="表:隐藏">true</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="表:跨度"><xsl:choose><xsl:when test="$currentColumn/@table:number-columns-repeated"><xsl:value-of select="$currentColumn/@table:number-columns-repeated - 1"/></xsl:when><xsl:otherwise><xsl:value-of select="'0'"/></xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:if test="$index">
                <xsl:attribute name="表:列号"><xsl:value-of select="$columnNo"/></xsl:attribute>
            </xsl:if-->
    <!--自动列宽没有,暂略 autofitwidth-->
    <!--Redoffice comment liliang 06.05.22-->
    <!--xsl:variable name="width">
                <xsl:value-of select="key('styles', $currentColumn/@table:style-name)/style:properties/@style:column-width"/>
            </xsl:variable-->
    <!--end-->
    <!--xsl:if test="$width">
                <xsl:attribute name="表:宽度"><xsl:call-template name="convert2pt"><xsl:with-param name="value" select="$width"/></xsl:call-template></xsl:attribute>
            </xsl:if>
            <xsl:attribute name="表:跨度"><xsl:choose><xsl:when test="$currentColumn/@table:number-columns-repeated"><xsl:value-of select="$currentColumn/@table:number-columns-repeated - 1"/></xsl:when><xsl:otherwise><xsl:value-of select="'0'"/></xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:element>
        <xsl:if test="$columnNo &lt; $columnCount">
            <xsl:choose>
                <xsl:when test="@table:number-columns-repeated">
                    <xsl:call-template name="create-table-column">
                        <xsl:with-param name="columnNodes" select="$columnNodes"/>
                        <xsl:with-param name="columnCount" select="$columnCount"/>
                        <xsl:with-param name="columnNo" select="$columnNo + $currentColumn/@table:number-columns-repeated"/>
                        <xsl:with-param name="columnNodeNo" select="$columnNodeNo + 1"/>
                        <xsl:with-param name="currentColumn" select="$columnNodes[$columnNodeNo + 1]"/>
                        <xsl:with-param name="index" select="true()"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="create-table-column">
                        <xsl:with-param name="columnNodes" select="$columnNodes"/>
                        <xsl:with-param name="columnCount" select="$columnCount"/>
                        <xsl:with-param name="columnNo" select="$columnNo + 1"/>
                        <xsl:with-param name="columnNodeNo" select="$columnNodeNo + 1"/>
                        <xsl:with-param name="currentColumn" select="$columnNodes[$columnNodeNo + 1]"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template-->
    <!-- ************* -->
    <!-- *** Rows  *** -->
    <!-- ************* -->
    <xsl:template match="table:table-row">
        <xsl:param name="table-name"/>
        <xsl:param name="columnCount"/>
        <xsl:choose>
            <xsl:when test="@table:number-rows-repeated &gt; 1">
                <xsl:choose>
                    <xsl:when test="(last() or (last() - 1)) and @table:number-rows-repeated &gt; 99">
                        <xsl:call-template name="write-table-row">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="columnCount" select="$columnCount"/>
                            <xsl:with-param name="lastRow" select="true()"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- In case a cell is being repeated, the cell will be created
                        in a variable, which is as many times given out, as being repeated -->
                        <xsl:variable name="tableRow">
                            <xsl:call-template name="write-table-row">
                                <xsl:with-param name="table-name" select="$table-name"/>
                                <xsl:with-param name="columnCount" select="$columnCount"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:call-template name="repeat-write-table-row">
                            <xsl:with-param name="tableRow" select="$tableRow"/>
                            <xsl:with-param name="repetition" select="@table:number-rows-repeated"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="write-table-row">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="columnCount" select="$columnCount"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="write-table-row">
        <xsl:param name="table-name"/>
        <xsl:param name="columnCount"/>
        <xsl:param name="lastRow"/>
        <xsl:element name="表:行">
            <xsl:attribute name="uof:locID">s0049</xsl:attribute>
            <xsl:attribute name="uof:attrList">行号 隐藏 行高 式样引用 跨度</xsl:attribute>
            <xsl:if test="./table:table-cell/@office:value-type">
                <xsl:attribute name="表:行号"><xsl:value-of select="count(preceding::table:table-row[not(@table:number-rows-repeated)])+1+number(sum(preceding::table:table-row[@table:number-rows-repeated]/@table:number-rows-repeated))"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@table:visibility = 'collapse' or @table:visibility = 'filter'">
                <xsl:attribute name="表:隐藏">true</xsl:attribute>
            </xsl:if>
            <!-- although valid, can not be opened with Excel - issue i31949)
            <xsl:if test="$lastRow">
                <xsl:attribute name="ss:Span"><xsl:value-of select="@table:number-rows-repeated - 1" /></xsl:attribute>
            </xsl:if>-->
            <!-- writing the style of the row -->
            <xsl:apply-templates select="@table:style-name"/>
            <xsl:variable name="rowProperties" select="key('styles', @table:style-name)/*"/>
            <!--xsl:if test="$rowProperties/@style:use-optimal-row-height = 'false'">
                <! - - default is '1', therefore write only '0' - ->
                <xsl:attribute name="ss:AutoFitHeight">0</xsl:attribute>
            </xsl:if-->
            <xsl:variable name="height" select="$rowProperties/@style:row-height"/>
            <xsl:if test="$height">
                <xsl:attribute name="表:行高"><!-- using the absolute height in point --><xsl:call-template name="convert2pt"><xsl:with-param name="value" select="$height"/></xsl:call-template></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="table:table-cell">
                <xsl:with-param name="table-name" select="$table-name"/>
                <xsl:with-param name="columnCount" select="$columnCount"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    <xsl:template name="repeat-write-table-row">
        <xsl:param name="tableRow"/>
        <xsl:param name="repetition"/>
        <xsl:copy-of select="$tableRow"/>
        <xsl:if test="$repetition &gt; 1">
            <xsl:call-template name="repeat-write-table-row">
                <xsl:with-param name="tableRow" select="$tableRow"/>
                <xsl:with-param name="repetition" select="$repetition - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- ************** -->
    <!-- *** Cells  *** -->
    <!-- ************** -->
    <!-- Table cells are able to be repeated by attribute in StarOffice,
        but not in Excel. If more cells are repeated
        (e.g. for emulating background) only as many cells as columns are
        allowed to be written out. -->
    <xsl:template match="table:table-cell">
        <xsl:param name="table-name"/>
        <xsl:param name="columnCount"/>
        <!--xsl:choose>
            <xsl:when test="@table:number-columns-repeated &gt; 1">
                <xsl:variable name="tableCell">
                    <xsl:call-template name="write-table-cell"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="not(following-sibling::table:table-cell)">
                        <xsl:call-template name="repeat-write-table-cell">
                            <xsl:with-param name="tableCell" select="$tableCell"/>
                            <xsl:with-param name="repetition" select="@table:number-columns-repeated"/>
                            <xsl:with-param name="columnCount" select="$columnCount"/>
                            <xsl:with-param name="cellNo" select="position()+ sum(preceding-sibling::table:table-cell/@table:number-columns-repeated)- count(preceding-sibling::table:table-cell/@table:number-columns-repeated)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="repeat-write-table-cell">
                            <xsl:with-param name="tableCell" select="$tableCell"/>
                            <xsl:with-param name="repetition" select="@table:number-columns-repeated"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="write-table-cell"/>
            </xsl:otherwise>
        </xsl:choose-->
        <xsl:choose>
            <xsl:when test="@table:number-columns-repeated">
                <xsl:call-template name="write-table-cell">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="repeat-table-cell-no" select="@table:number-columns-repeated"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="write-table-cell">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="repeat-table-cell-no" select="number(1)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--xsl:template name="repeat-write-table-cell">
        <xsl:param name="tableCell"/>
        <xsl:param name="repetition"/>
        <xsl:param name="columnCount"/>
        <xsl:param name="cellNo"/>
        <xsl:copy-of select="$tableCell"/>
        <xsl:if test="$repetition &gt; 1">
            <xsl:choose>
                <xsl:when test="$cellNo">
                    <xsl:if test="$cellNo  &lt; $columnCount">
                        <xsl:call-template name="repeat-write-table-cell">
                            <xsl:with-param name="tableCell" select="$tableCell"/>
                            <xsl:with-param name="repetition" select="$repetition - 1"/>
                            <xsl:with-param name="columnCount" select="$columnCount"/>
                            <xsl:with-param name="cellNo" select="$cellNo + 1"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="repeat-write-table-cell">
                        <xsl:with-param name="tableCell" select="$tableCell"/>
                        <xsl:with-param name="repetition" select="$repetition - 1"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template-->
    <xsl:template name="write-table-cell">
        <xsl:param name="table-name"/>
        <xsl:param name="repeat-table-cell-no"/>
        <xsl:if test="$repeat-table-cell-no &gt; 0">
            <表:单元格 uof:locID="s0050" uof:attrList="列号 式样引用 超链接引用 合并列数 合并行数">
                <xsl:if test="@table:number-columns-spanned &gt; 1">
                    <xsl:attribute name="表:合并列数"><xsl:value-of select="@table:number-columns-spanned - 1"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="@table:number-rows-spanned &gt; 1">
                    <xsl:attribute name="表:合并行数"><xsl:value-of select="@table:number-rows-spanned - 1"/></xsl:attribute>
                </xsl:if>
                <xsl:variable name="link" select="descendant::text:a/@xlink:href"/>
                <xsl:if test="$link">
                    <xsl:attribute name="表:超链接引用"><xsl:value-of select="$link"/></xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="@table:style-name">
                        <xsl:apply-templates select="@table:style-name"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="ancestor::table:table/table:table-column/@table:default-cell-style-name"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="*">
                        <xsl:if test="text:p">
                            <xsl:variable name="valueType">
                                <xsl:choose>
                                    <xsl:when test="@office:value-type">
                                        <xsl:value-of select="@office:value-type"/>
                                    </xsl:when>
                                    <xsl:otherwise>string</xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:call-template name="表的数据">
                                <xsl:with-param name="valueType" select="$valueType"/>
                                <xsl:with-param name="cellStyleName" select="@table:style-name"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="office:annotation">
                            <xsl:element name="表:批注">
                                <xsl:attribute name="uof:locID">s0053</xsl:attribute>
                                <xsl:attribute name="uof:attrList">是否显示</xsl:attribute>
                                <xsl:attribute name="表:是否显示"><xsl:choose><xsl:when test="office:annotation/@office:display = 'true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                                <uof:锚点 uof:locID="u0064" uof:attrList="x坐标 y坐标 宽度 高度 图形引用 随动方式 缩略图 占位符">
                                    <xsl:variable name="num">
                                        <xsl:value-of select="substring-after(office:annotation/@draw:style-name,'gr')"/>
                                    </xsl:variable>
                                    <xsl:attribute name="uof:图形引用"><xsl:value-of select="concat('pz',$num)"/></xsl:attribute>
                                    <xsl:attribute name="uof:x坐标"><xsl:value-of select="substring-before(office:annotation/@svg:x,$uofUnit)"/></xsl:attribute>
                                    <xsl:attribute name="uof:y坐标"><xsl:value-of select="substring-before(office:annotation/@svg:y,$uofUnit)"/></xsl:attribute>
                                    <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(office:annotation/@svg:width,$uofUnit)"/></xsl:attribute>
                                    <xsl:attribute name="uof:高度"><xsl:value-of select="substring-before(office:annotation/@svg:height,$uofUnit)"/></xsl:attribute>
                                </uof:锚点>
                            </xsl:element>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
                <xsl:for-each select="child::*">
                    <xsl:if test="starts-with(name(.),'draw:')">
                        <xsl:choose>
                            <xsl:when test="name(.)='draw:frame' and self::node()/draw:object">
                                <xsl:call-template name="draw:chart-frame">
                                    <xsl:with-param name="table-name" select="$table-name"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="uof锚点"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
                <xsl:if test="/office:document/office:body/office:spreadsheet/table:tracked-changes and not(self::node()/@table:style-name) and self::node()/text:p">
                    <xsl:element name="表:数据">
                        <xsl:attribute name="uof:locID">s0051</xsl:attribute>
                        <xsl:attribute name="uof:attrList">数据类型</xsl:attribute>
                        <xsl:element name="字:句">
                            <xsl:attribute name="uof:locID">t0085</xsl:attribute>
                            <xsl:call-template name="table:tracked-changes"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
            </表:单元格>
            <xsl:variable name="repeat-table-cell-no1">
                <xsl:value-of select="$repeat-table-cell-no - 1"/>
            </xsl:variable>
            <xsl:call-template name="write-table-cell">
                <xsl:with-param name="table-name" select="$table-name"/>
                <xsl:with-param name="repeat-table-cell-no" select="$repeat-table-cell-no1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template match="office:annotation"/>
    <xsl:template match="dc:date"/>
    <xsl:template name="表的数据">
        <xsl:param name="valueType"/>
        <xsl:param name="cellStyleName"/>
        <xsl:choose>
            <xsl:when test="descendant::*/@text:style-name">
                <xsl:choose>
                    <xsl:when test="$valueType = 'string'">
                        <表:数据 表:数据类型="string" uof:locID="s0051" uof:attrList="数据类型">
                            <xsl:apply-templates>
                                <xsl:with-param name="cellStyleName" select="$cellStyleName"/>
                            </xsl:apply-templates>
                        </表:数据>
                    </xsl:when>
                    <xsl:when test="$valueType = 'boolean'">
                        <表:数据 表:数据类型="boolean" uof:locID="s0051" uof:attrList="数据类型">
                            <xsl:apply-templates>
                                <xsl:with-param name="cellStyleName" select="$cellStyleName"/>
                            </xsl:apply-templates>
                        </表:数据>
                    </xsl:when>
                    <xsl:when test="$valueType = 'date'">
                        <表:数据 表:数据类型="date" uof:locID="s0051" uof:attrList="数据类型">
                            <xsl:apply-templates>
                                <xsl:with-param name="cellStyleName" select="$cellStyleName"/>
                            </xsl:apply-templates>
                        </表:数据>
                    </xsl:when>
                    <xsl:otherwise>
                        <表:数据 表:数据类型="number" uof:locID="s0051" uof:attrList="数据类型">
                            <xsl:apply-templates>
                                <xsl:with-param name="cellStyleName" select="$cellStyleName"/>
                            </xsl:apply-templates>
                        </表:数据>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <表:数据 uof:locID="s0051" uof:attrList="数据类型">
                    <xsl:choose>
                        <xsl:when test="$valueType = 'string'">
                            <xsl:attribute name="表:数据类型">text</xsl:attribute>
                            <!--xsl:attribute name="表:数据数值"><xsl:value-of select="@office:string-value"/></xsl:attribute-->
                            <!--chengxz schema no this attr-->
                            <字:句 uof:locID="t0085">
                                <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                                    <xsl:value-of select="text:p"/>
                                </字:文本串>
                            </字:句>
                        </xsl:when>
                        <xsl:when test="$valueType = 'boolean'">
                            <xsl:attribute name="表:数据类型">boolean</xsl:attribute>
                            <字:句 uof:locID="t0085">
                                <xsl:choose>
                                    <xsl:when test="@table:boolean-value = 'true'">
                                        <字:文本串 uof:locID="t0109" uof:attrList="udsPath">true</字:文本串>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <字:文本串 uof:locID="t0109" uof:attrList="udsPath">false</字:文本串>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </字:句>
                        </xsl:when>
                        <xsl:when test="$valueType = 'date'">
                            <xsl:attribute name="表:数据类型">date</xsl:attribute>
                            <xsl:attribute name="表:数据数值"><xsl:value-of select="@office:date-value"/></xsl:attribute>
                            <字:句 uof:locID="t0085">
                                <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                                    <xsl:value-of select="text:p"/>
                                </字:文本串>
                            </字:句>
                        </xsl:when>
                        <xsl:when test="$valueType = 'time'">
                            <xsl:attribute name="表:数据类型">time</xsl:attribute>
                            <xsl:attribute name="表:数据数值"><xsl:value-of select="@office:time-value"/></xsl:attribute>
                            <字:句 uof:locID="t0085">
                                <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                                    <xsl:value-of select="text:p"/>
                                </字:文本串>
                            </字:句>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="表:数据类型">number</xsl:attribute>
                            <xsl:attribute name="表:数据数值"><xsl:value-of select="@office:value"/></xsl:attribute>
                            <字:句 uof:locID="t0085">
                                <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                                    <xsl:value-of select="text:p"/>
                                </字:文本串>
                            </字:句>
                        </xsl:otherwise>
                    </xsl:choose>
                </表:数据>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="分页符集">
        <xsl:for-each select="table:table-row">
            <xsl:if test="key('styles', @table:style-name)/style:table-row-properties/@fo:break-before">
                <xsl:variable name="table-break-before">
                    <xsl:value-of select="key('styles', @table:style-name)/style:table-row-properties/@fo:break-before"/>
                </xsl:variable>
                <xsl:if test="$table-break-before = 'page'">
                    <xsl:element name="表:分页符">
                        <xsl:attribute name="uof:locID">s0112</xsl:attribute>
                        <xsl:attribute name="uof:attrList">行号 列号</xsl:attribute>
                        <xsl:if test="preceding-sibling::table:table-row/@table:number-rows-repeated">
                            <xsl:attribute name="表:行号"><xsl:value-of select="sum(preceding-sibling::table:table-row/@table:number-rows-repeated)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="not(preceding-sibling::table:table-row/@table:number-rows-repeated)">
                            <xsl:attribute name="表:行号">1</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
            </xsl:if>
            <xsl:if test="key('styles', @table:style-name)/style:table-row-properties/@fo:break-after">
                <xsl:variable name="table-break-after" select="key('styles', @table:style-name)/style:table-row-properties/@fo:break-after"/>
                <xsl:if test="$table-break-after = 'page'">
                    <xsl:element name="表:分页符">
                        <xsl:attribute name="uof:locID">s0112</xsl:attribute>
                        <xsl:attribute name="uof:attrList">行号 列号</xsl:attribute>
                        <xsl:if test="preceding-sibling::table:table-row/@table:number-rows-repeated">
                            <xsl:attribute name="表:行号"><xsl:value-of select="sum(preceding-sibling::table:table-row/@table:number-rows-repeated)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="not(preceding-sibling::table:table-row/@table:number-rows-repeated)">
                            <xsl:attribute name="表:行号">1</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="table:table-column">
            <xsl:if test="key('styles', @table:style-name)/style:table-column-properties/@fo:break-before">
                <xsl:variable name="table-break-before" select="key('styles', @table:style-name)/style:table-column-properties/@fo:break-before"/>
                <xsl:if test="$table-break-before = 'page'">
                    <xsl:element name="表:分页符">
                        <xsl:attribute name="uof:locID">s0112</xsl:attribute>
                        <xsl:attribute name="uof:attrList">行号 列号</xsl:attribute>
                        <xsl:if test="preceding-sibling::table:table-column/@table:number-columns-repeated">
                            <xsl:attribute name="表:列号"><xsl:value-of select="sum(preceding-sibling::table:table-column/@table:number-columns-repeated)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="not(preceding-sibling::table:table-column/@table:number-columns-repeated)">
                            <xsl:attribute name="表:列号">1</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
            </xsl:if>
            <xsl:if test="key('styles', @table:style-name)/style:table-column-properties/@fo:break-after">
                <xsl:variable name="table-break-after" select="key('styles', @table:style-name)/style:table-column-properties/@fo:break-after"/>
                <xsl:if test="$table-break-after = 'page'">
                    <xsl:element name="表:分页符">
                        <xsl:attribute name="uof:locID">s0112</xsl:attribute>
                        <xsl:attribute name="uof:attrList">行号 列号</xsl:attribute>
                        <xsl:if test="preceding-sibling::table:table-column/@table:number-columns-repeated">
                            <xsl:attribute name="表:列号"><xsl:value-of select="sum(preceding-sibling::table:table-column/@table:number-columns-repeated)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="not(preceding-sibling::table:table-column/@table:number-columns-repeated)">
                            <xsl:attribute name="表:列号">1</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="text:s">
        <xsl:call-template name="write-breakable-whitespace">
            <xsl:with-param name="whitespaces" select="@text:c"/>
        </xsl:call-template>
    </xsl:template>
    <!--write the number of 'whitespaces' -->
    <xsl:template name="write-breakable-whitespace">
        <xsl:param name="whitespaces"/>
        <xsl:text> </xsl:text>
        <xsl:if test="$whitespaces >= 1">
            <xsl:call-template name="write-breakable-whitespace">
                <xsl:with-param name="whitespaces" select="$whitespaces - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- allowing all matched text nodes -->
    <!--chengxz0630-->
    <!--xsl:template match="text()">
        <字:句 uof:locID="t0085">
            <xsl:element name="字:文本串">
                <xsl:attribute name="locID">t0109</xsl:attribute>

                <xsl:value-of select="." />
            </xsl:element>
        </字:句>
    </xsl:template-->
    <xsl:variable name="namespace-html" select="'http://www.w3.org/TR/REC-html40'"/>
    <xsl:template match="@table:style-name | @table:default-cell-style-name">
        <xsl:attribute name="表:式样引用"><!--ss:styleID--><xsl:value-of select="."/><!--chengxz 060114--></xsl:attribute>
    </xsl:template>
    <xsl:template name="style-and-contents">
        <xsl:param name="cellStyleName"/>
        <字:句 uof:locID="t0085">
            <xsl:element name="字:文本串">
                <!--chengxz0630-->
            </xsl:element>
        </字:句>
    </xsl:template>
    <!-- *************88-->
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
    <xsl:key match="draw:object/office:document/office:automatic-styles/style:style" name="chart-style-name" use="@style:name"/>
    <xsl:template name="draw:chart-frame">
        <xsl:param name="table-name"/>
        <表:图表 uof:locID="s0055" uof:attrList="类型 子类型 宽度 高度 x坐标 y坐标 随动方式">
            <xsl:variable name="plot-area">
                <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/@chart:style-name"/>
            </xsl:variable>
            <xsl:variable name="data-area">
                <xsl:value-of select="draw:object/@draw:notify-on-update-of-ranges"/>
            </xsl:variable>
            <xsl:variable name="series-generate">
                <xsl:for-each select="key('chart-style-name',$plot-area)">
                    <xsl:choose>
                        <xsl:when test="style:chart-properties/@chart:series-source='columns'">col</xsl:when>
                        <xsl:otherwise>row</xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>
            <xsl:call-template name="表:图表">
                <xsl:with-param name="table-name" select="$table-name"/>
                <xsl:with-param name="data-area" select="$data-area"/>
                <xsl:with-param name="series-generate" select="$series-generate"/>
            </xsl:call-template>
            <表:图表区 uof:locID="s0056">
                <xsl:call-template name="表:图表区">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="data-area" select="$data-area"/>
                    <xsl:with-param name="series-generate" select="$series-generate"/>
                </xsl:call-template>
            </表:图表区>
            <表:绘图区 uof:locID="s0060">
                <xsl:attribute name="表:宽度"><xsl:value-of select="substring-before(draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/@svg:width,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="表:高度"><xsl:value-of select="substring-before(draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/@svg:height,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="表:x坐标"><xsl:value-of select="substring-before(draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/@svg:x,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="表:y坐标"><xsl:value-of select="substring-before(draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/@svg:y,$uofUnit)"/></xsl:attribute>
                <xsl:call-template name="表:绘图区">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="data-area" select="$data-area"/>
                    <xsl:with-param name="series-generate" select="$series-generate"/>
                </xsl:call-template>
            </表:绘图区>
            <表:分类轴 uof:locID="s0061" uof:attrList="主刻度类型 次刻度类型 刻度线标志">
                <xsl:variable name="axis-style-name">
                    <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:axis[child::chart:categories]/@chart:style-name"/>
                </xsl:variable>
                <xsl:for-each select="draw:object/office:document/office:automatic-styles/style:style[@style:name=$axis-style-name]">
                    <xsl:attribute name="表:主刻度类型"><xsl:choose><xsl:when test="style:chart-properties/@chart:tick-marks-major-inner='true' and style:chart-properties/@chart:tick-marks-major-outer='true'">cross</xsl:when><xsl:when test="style:chart-properties/@chart:tick-marks-major-inner='false'">inside</xsl:when><xsl:when test="style:chart-properties/@chart:tick-marks-major-inner='true'">outside</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="表:次刻度类型"><xsl:choose><xsl:when test="style:chart-properties/@chart:tick-marks-minor-inner='true' and style:chart-properties/@chart:tick-marks-minor-outer='true'">cross</xsl:when><xsl:when test="style:chart-properties/@chart:tick-marks-minor-inner='true'">inside</xsl:when><xsl:when test="style:chart-properties/@chart:tick-marks-minor-inner='true'">outside</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="表:刻度线标志"><xsl:choose><xsl:when test="style:chart-properties/@chart:display-label='true'">next to axis</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:call-template name="表:坐标轴类型">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="data-area" select="$data-area"/>
                        <xsl:with-param name="series-generate" select="$series-generate"/>
                        <xsl:with-param name="axis-type" select="category-axis"/>
                    </xsl:call-template>
                </xsl:for-each>
            </表:分类轴>
            <表:数值轴 uof:locID="s0082" uof:attrList="主刻度类型 次刻度类型 刻度线标志">
                <xsl:variable name="axis-style-name">
                    <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:axis[child::chart:grid]/@chart:style-name"/>
                </xsl:variable>
                <xsl:for-each select="draw:object/office:document/office:automatic-styles/style:style[@style:name=$axis-style-name]">
                    <xsl:attribute name="表:主刻度类型"><xsl:choose><xsl:when test="style:chart-properties/@chart:tick-marks-major-inner='true' and style:chart-properties/@chart:tick-marks-major-outer='true'">cross</xsl:when><xsl:when test="style:chart-properties/@chart:tick-marks-major-inner='true'">inside</xsl:when><xsl:when test="style:chart-properties/@chart:tick-marks-major-inner='true'">outside</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="表:次刻度类型"><xsl:choose><xsl:when test="style:chart-properties/@chart:tick-marks-minor-inner='true' and style:chart-properties/@chart:tick-marks-minor-outer='true'">cross</xsl:when><xsl:when test="style:chart-properties/@chart:tick-marks-minor-inner='true'">inside</xsl:when><xsl:when test="style:chart-properties/@chart:tick-marks-minor-inner='true'">outside</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="表:刻度线标志"><xsl:choose><xsl:when test="style:chart-properties/@chart:display-label='true'">next to axis</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:call-template name="表:坐标轴类型">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="data-area" select="$data-area"/>
                        <xsl:with-param name="series-generate" select="$series-generate"/>
                        <xsl:with-param name="axis-type" select="category-axis"/>
                    </xsl:call-template>
                </xsl:for-each>
            </表:数值轴>
            <表:图例 uof:locID="s0083" uof:attrList="位置">
                <xsl:attribute name="表:位置"><xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:legend/@chart:legend-position"/></xsl:attribute>
                <xsl:attribute name="表:x坐标"><xsl:value-of select="substring-before(draw:object/office:document/office:body/office:chart/chart:chart/chart:legend/@svg:x,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="表:y坐标"><xsl:value-of select="substring-before(draw:object/office:document/office:body/office:chart/chart:chart/chart:legend/@svg:y,$uofUnit)"/></xsl:attribute>
                <xsl:call-template name="表:图例">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="data-area" select="$data-area"/>
                    <xsl:with-param name="series-generate" select="$series-generate"/>
                </xsl:call-template>
            </表:图例>
            <!--表:数据表 uof:locID="s0085">
                <xsl:call-template name="表:数据表">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="data-area" select="$data-area"/>
                    <xsl:with-param name="series-generate" select="$series-generate"/>
                </xsl:call-template>
            </表:数据表-->
            <表:数据系列集 uof:locID="s0086">
                <xsl:variable name="data-series-path" select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:series"/>
                <xsl:call-template name="表:数据系列">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="data-area" select="$data-area"/>
                    <xsl:with-param name="series-generate" select="$series-generate"/>
                    <xsl:with-param name="data-series-path" select="$data-series-path"/>
                </xsl:call-template>
            </表:数据系列集>
            <!--0825 by lil -->
            <xsl:if test="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:series">
                <表:数据点集 uof:locID="s0090">
                    <xsl:variable name="data-series-path" select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:series"/>
                    <xsl:call-template name="表:数据点">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="data-area" select="$data-area"/>
                        <xsl:with-param name="series-generate" select="$series-generate"/>
                        <xsl:with-param name="data-series-path" select="$data-series-path"/>
                    </xsl:call-template>
                </表:数据点集>
            </xsl:if>
            <!--end-->
            <表:网格线集 uof:locID="s0092">
                <xsl:if test="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:axis[@chart:dimension='x' and @chart:style-name]/chart:grid">
                    <xsl:call-template name="表:网格线">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="data-area" select="$data-area"/>
                        <xsl:with-param name="series-generate" select="$series-generate"/>
                        <xsl:with-param name="grid-type" select="'category axis'"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:axis[@chart:dimension='y']/@chart:style-name">
                    <xsl:call-template name="表:网格线">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="data-area" select="$data-area"/>
                        <xsl:with-param name="series-generate" select="$series-generate"/>
                        <xsl:with-param name="grid-type" select="'value axis'"/>
                    </xsl:call-template>
                </xsl:if>
            </表:网格线集>
            <表:数据源 uof:locID="s0094" uof:attrList="数据区域 系列产生">
                <xsl:variable name="series-row-start">
                    <xsl:call-template name="General-Char-Transition">
                        <xsl:with-param name="input-char" select="substring-before(substring(substring-after($data-area,'.'),2),':')"/>
                        <xsl:with-param name="output-type" select="'ARABIC'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="series-row-end">
                    <xsl:call-template name="General-Char-Transition">
                        <xsl:with-param name="input-char" select="substring(substring-after(substring-after($data-area,'.'),'.'),2)"/>
                        <xsl:with-param name="output-type" select="'ARABIC'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="series-col-start">
                    <xsl:call-template name="General-Char-Transition">
                        <xsl:with-param name="input-char" select="substring(substring-after($data-area,'.'),1,1)"/>
                        <xsl:with-param name="output-type" select="'ARABIC'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="series-col-end">
                    <xsl:call-template name="General-Char-Transition">
                        <xsl:with-param name="input-char" select="substring(substring-after(substring-after($data-area,'.'),'.'),1,1)"/>
                        <xsl:with-param name="output-type" select="'ARABIC'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="series-value-count">
                    <xsl:choose>
                        <xsl:when test="$series-generate='col'">
                            <xsl:value-of select="$series-col-end -$series-col-start +1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$series-row-end -$series-row-start +1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="表:数据区域"><xsl:value-of select="draw:object/@draw:notify-on-update-of-ranges"/></xsl:attribute>
                <xsl:attribute name="表:系列产生"><xsl:choose><xsl:when test="contains($series-generate,'col')">col</xsl:when><xsl:when test="contains($series-generate,'row')">row</xsl:when></xsl:choose></xsl:attribute>
                <xsl:call-template name="表:系列">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="data-area" select="$data-area"/>
                    <xsl:with-param name="series-generate" select="$series-generate"/>
                    <xsl:with-param name="series-row-start" select="$series-row-start"/>
                    <xsl:with-param name="series-row-end" select="$series-row-end"/>
                    <xsl:with-param name="series-col-start" select="$series-col-start"/>
                    <xsl:with-param name="series-col-end" select="$series-col-end"/>
                    <xsl:with-param name="series-value-current" select="'1'"/>
                    <xsl:with-param name="series-value-count" select="$series-value-count"/>
                </xsl:call-template>
            </表:数据源>
            <表:标题集 uof:locID="s0096">
                <xsl:if test="draw:object/office:document/office:body/office:chart/chart:chart/chart:title">
                    <xsl:call-template name="表:标题">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="data-area" select="$data-area"/>
                        <xsl:with-param name="series-generate" select="$series-generate"/>
                        <xsl:with-param name="caption-type" select="'chart'"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:axis[@chart:dimension='x']">
                    <xsl:call-template name="表:标题">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="data-area" select="$data-area"/>
                        <xsl:with-param name="series-generate" select="$series-generate"/>
                        <xsl:with-param name="caption-type" select="'category axis'"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:axis[@chart:dimension='y']">
                    <xsl:call-template name="表:标题">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="data-area" select="$data-area"/>
                        <xsl:with-param name="series-generate" select="$series-generate"/>
                        <xsl:with-param name="caption-type" select="'value axis'"/>
                    </xsl:call-template>
                </xsl:if>
            </表:标题集>
        </表:图表>
    </xsl:template>
    <xsl:template name="表:图表">
        <xsl:param name="table-name"/>
        <xsl:param name="data-area"/>
        <xsl:param name="series-generate"/>
        <xsl:variable name="chart-class">
            <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/@chart:class"/>
        </xsl:variable>
        <xsl:variable name="chart-area">
            <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/@chart:style-name"/>
        </xsl:variable>
        <xsl:variable name="plot-area">
            <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/@chart:style-name"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$chart-class='chart:bar'">
                <xsl:variable name="chart-sub-class">
                    <xsl:value-of select="key('chart-style-name',$plot-area)/style:chart-properties/@chart:vertical"/>
                </xsl:variable>
                <xsl:attribute name="表:类型"><xsl:choose><xsl:when test="$chart-sub-class='true'">bar</xsl:when><xsl:when test="$chart-sub-class='false'">column</xsl:when><xsl:otherwise/></xsl:choose></xsl:attribute>
                <xsl:attribute name="表:子类型"><xsl:choose><xsl:when test="$chart-sub-class='true'"><xsl:choose><xsl:when test="key('chart-style-name',$plot-area)/style:chart-properties/@chart:percentage">bar_percent</xsl:when><xsl:when test="key('chart-style-name',$plot-area)/style:chart-properties/@chart:stacked">bar_stacked</xsl:when><xsl:otherwise>bar_standard</xsl:otherwise></xsl:choose></xsl:when><xsl:when test="$chart-sub-class='false'"><xsl:choose><xsl:when test="key('chart-style-name',$plot-area)/style:chart-properties/@chart:percentage">column_percent</xsl:when><xsl:when test="key('chart-style-name',$plot-area)/style:chart-properties/@chart:stacked">column_stacked</xsl:when><xsl:otherwise>column_standard</xsl:otherwise></xsl:choose></xsl:when></xsl:choose></xsl:attribute>
            </xsl:when>
            <xsl:when test="$chart-class='chart:line'">
                <xsl:attribute name="表:类型">line</xsl:attribute>
                <xsl:attribute name="表:子类型"><xsl:choose><xsl:when test="key('chart-style-name',$plot-area)/style:chart-properties/@chart:percentage">line_percent</xsl:when><xsl:when test="key('chart-style-name',$plot-area)/style:chart-properties/@chart:stacked">line_stacked</xsl:when><xsl:otherwise>line_standard</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:when>
            <xsl:when test="$chart-class='chart:circle'">
                <xsl:attribute name="表:类型">pie</xsl:attribute>
                <xsl:variable name="data-point-end" select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:series[1]/chart:data-point"/>
                <xsl:choose>
                    <xsl:when test="count($data-point-end) &lt;=1">
                        <xsl:attribute name="表:子类型">pie_standard</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="data-point-position-1">
                            <xsl:for-each select="$data-point-end[position()=1]">
                                <xsl:choose>
                                    <xsl:when test="@chart:style-name">
                                        <xsl:for-each select="key('chart-style-name',@chart:style-name)">
                                            <xsl:choose>
                                                <xsl:when test="style:chart-properties/@chart:pie-offset">1</xsl:when>
                                                <xsl:otherwise>0</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>0</xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$data-point-position-1='0'">
                                <xsl:attribute name="表:子类型">pie_standard</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="$data-point-end[position()=2]">
                                    <xsl:choose>
                                        <xsl:when test="@chart:style-name">
                                            <xsl:for-each select="key('chart-style-name',@chart:style-name)">
                                                <xsl:choose>
                                                    <xsl:when test="style:chart-properties/@chart:pie-offset">
                                                        <xsl:attribute name="表:子类型">pie_offset2</xsl:attribute>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:attribute name="表:子类型">pie_offset1</xsl:attribute>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="表:子类型">pie_offset1</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$chart-class='chart:ring'">
                <xsl:attribute name="表:类型">pie</xsl:attribute>
                <xsl:attribute name="表:子类型">pie_ring</xsl:attribute>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <xsl:attribute name="表:宽度"><xsl:value-of select="substring-before(@svg:width,$uofUnit)"/></xsl:attribute>
        <xsl:attribute name="表:高度"><xsl:value-of select="substring-before(@svg:height,$uofUnit)"/></xsl:attribute>
        <xsl:attribute name="表:x坐标"><xsl:value-of select="substring-before(@svg:x,$uofUnit)"/></xsl:attribute>
        <xsl:attribute name="表:y坐标"><xsl:value-of select="substring-before(@svg:y,$uofUnit)"/></xsl:attribute>
        <xsl:choose>
            <xsl:when test="@draw:style-name">
                <xsl:variable name="draw-style-name" select="@draw:style-name"/>
                <xsl:for-each select="draw:object//office:document/office:automatic-styles/style:style[@style:name=$draw-style-name]">
                    <xsl:choose>
                        <xsl:when test="style:graphic-properties/@draw:move-protect='true' and style:graphic-properties/@draw:size-protect='true'">
                            <xsl:attribute name="表:随动方式">none</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="style:graphic-properties/@draw:size-protect='true'">
                            <xsl:attribute name="表:随动方式">move</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="表:随动方式">move and re-size</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="表:随动方式">move and re-size</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="表:图表区">
        <xsl:param name="table-name"/>
        <xsl:param name="data-area"/>
        <xsl:param name="series-generate"/>
        <xsl:variable name="chart-style-name" select="draw:object/office:document/office:body/office:chart/chart:chart/@chart:style-name"/>
        <xsl:for-each select="draw:object/office:document/office:automatic-styles/style:style[@style:name=$chart-style-name]">
            <表:边框 uof:locID="s0057" uof:attrList="类型 宽度 边距 颜色 阴影">
                <xsl:call-template name="表:边框"/>
            </表:边框>
            <xsl:if test="style:graphic-properties/@draw:fill-color or (style:graphic-properties/@draw:fill and not(style:graphic-properties/@draw:fill='none'))">
                <表:填充 uof:locID="s0058">
                    <xsl:call-template name="图:填充类型"/>
                </表:填充>
            </xsl:if>
            <表:字体 uof:locID="s0059" uof:attrList="式样引用">
                <xsl:call-template name="字:句属性类型">
                </xsl:call-template>
            </表:字体>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:绘图区">
        <xsl:param name="table-name"/>
        <xsl:param name="data-area"/>
        <xsl:param name="series-generate"/>
        <xsl:variable name="plot-style-name" select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:wall/@chart:style-name"/>
        <xsl:for-each select="draw:object/office:document/office:automatic-styles/style:style[@style:name=$plot-style-name]">
            <表:边框 uof:locID="s0057" uof:attrList="类型 宽度 边距 颜色 阴影">
                <xsl:call-template name="表:边框"/>
            </表:边框>
            <xsl:if test="style:graphic-properties/@draw:fill-color or (style:graphic-properties/@draw:fill and not(style:graphic-properties/@draw:fill='none'))">
                <表:填充 uof:locID="s0058">
                    <xsl:call-template name="图:填充类型2"/>
                </表:填充>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:图例">
        <xsl:param name="table-name"/>
        <xsl:param name="data-area"/>
        <xsl:param name="series-generate"/>
        <xsl:variable name="legend">
            <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:legend/@chart:style-name"/>
        </xsl:variable>
        <xsl:for-each select="draw:object/office:document/office:automatic-styles/style:style[@style:name=$legend]">
            <表:边框 uof:locID="s0057" uof:attrList="类型 宽度 边距 颜色 阴影">
                <xsl:call-template name="表:边框"/>
            </表:边框>
            <xsl:if test="style:graphic-properties/@draw:fill-color or (style:graphic-properties/@draw:fill and not(style:graphic-properties/@draw:fill='none'))">
                <表:填充 uof:locID="s0058">
                    <xsl:call-template name="图:填充类型"/>
                </表:填充>
            </xsl:if>
            <表:字体 uof:locID="s0059" uof:attrList="式样引用">
                <xsl:call-template name="字:句属性类型"/>
            </表:字体>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:图例项">
        <xsl:param name="table-name"/>
        <xsl:param name="data-area"/>
        <xsl:param name="series-generate"/>
        <表:图例项 uof:locID="s0084" uof:attrList="系列">
            <表:字体 uof:locID="s0059" uof:attrList="式样引用">
                <xsl:call-template name="字:句属性类型"/>
            </表:字体>
        </表:图例项>
    </xsl:template>
    <xsl:template name="表:数据表">
        <xsl:param name="table-name"/>
        <xsl:param name="data-area"/>
        <xsl:param name="series-generate"/>
        <xsl:if test="style:graphic-properties/@draw:fill-color or (style:graphic-properties/@draw:fill and not(style:graphic-properties/@draw:fill='none'))">
            <表:填充 uof:locID="s0058">
                <xsl:call-template name="图:填充类型"/>
            </表:填充>
        </xsl:if>
        <表:字体 uof:locID="s0059" uof:attrList="式样引用">
            <xsl:call-template name="字:句属性类型"/>
        </表:字体>
    </xsl:template>
    <xsl:template name="表:数据系列">
        <xsl:param name="table-name"/>
        <xsl:param name="data-area"/>
        <xsl:param name="series-generate"/>
        <xsl:param name="data-series-path"/>
        <xsl:for-each select="$data-series-path">
            <表:数据系列 uof:locID="s0087" uof:attrList="系列">
                <xsl:variable name="data-series-position">
                    <xsl:value-of select="position()"/>
                </xsl:variable>
                <xsl:attribute name="表:系列"><xsl:value-of select="$data-series-position"/></xsl:attribute>
                <xsl:variable name="data-series-point" select="@chart:style-name"/>
                <xsl:call-template name="表:数据点类型">
                    <xsl:with-param name="data-series-point" select="$data-series-point"/>
                    <xsl:with-param name="data-series-position" select="$data-series-position"/>
                </xsl:call-template>
            </表:数据系列>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:数据点">
        <xsl:param name="table-name"/>
        <xsl:param name="data-area"/>
        <xsl:param name="series-generate"/>
        <xsl:param name="data-series-path"/>
        <xsl:for-each select="$data-series-path">
            <xsl:variable name="data-series-position" select="position()"/>
            <xsl:for-each select="chart:data-point">
                <!--xsl:if test="@chart:style-name"-->
                <xsl:variable name="data-point-position">
                    <xsl:call-template name="count-chart-data-point">
                        <xsl:with-param name="data-point-count" select="'1'"/>
                        <xsl:with-param name="data-point-position-temp" select="position() -1"/>
                    </xsl:call-template>
                </xsl:variable>
                <表:数据点 uof:locID="s0091" uof:attrList="系列 点">
                    <xsl:attribute name="表:系列"><xsl:value-of select="$data-series-position"/></xsl:attribute>
                    <xsl:attribute name="表:点"><xsl:value-of select="$data-point-position"/></xsl:attribute>
                    <xsl:variable name="data-series-point" select="@chart:style-name"/>
                    <xsl:for-each select="../../../../../office:automatic-styles/style:style[@style:name=$data-series-point]">
                        <表:边框 uof:locID="s0057" uof:attrList="类型 宽度 边距 颜色 阴影">
                            <xsl:call-template name="表:边框"/>
                        </表:边框>
                        <xsl:if test="style:graphic-properties/@draw:fill-color or (style:graphic-properties/@draw:fill and not(style:graphic-properties/@draw:fill='none'))">
                            <表:填充 uof:locID="s0058">
                                <xsl:call-template name="图:填充类型"/>
                            </表:填充>
                        </xsl:if>
                        <表:字体 uof:locID="s0059" uof:attrList="式样引用">
                            <xsl:call-template name="字:句属性类型"/>
                        </表:字体>
                        <表:显示标志 uof:locID="s0088" uof:attrList="系列名 类别名 数值 百分数 分隔符 图例标志">
                            <xsl:attribute name="表:系列名"/>
                            <xsl:attribute name="表:分隔符"/>
                            <xsl:if test="style:chart-properties/@chart:data-label-text">
                                <xsl:attribute name="表:类别名"><xsl:value-of select="style:chart-properties/@chart:data-label-text"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="style:chart-properties/@chart:data-label-number">
                                <xsl:choose>
                                    <xsl:when test="style:chart-properties/@chart:data-label-number='value'">
                                        <xsl:attribute name="表:数值">true</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="style:chart-properties/@chart:data-label-number='percentage'">
                                        <xsl:attribute name="表:百分数">true</xsl:attribute>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="style:chart-properties/@chart:data-label-symbol">
                                <xsl:attribute name="表:图例标志"><xsl:value-of select="style:chart-properties/@chart:data-label-symbol"/></xsl:attribute>
                            </xsl:if>
                        </表:显示标志>
                        <表:系列名 uof:locID="s0089">
                            <xsl:value-of select="concat('系列',$data-series-position)"/>
                        </表:系列名>
                    </xsl:for-each>
                </表:数据点>
                <!--/xsl:if-->
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:网格线">
        <xsl:param name="table-name"/>
        <xsl:param name="data-area"/>
        <xsl:param name="series-generate"/>
        <xsl:param name="grid-type"/>
        <xsl:if test="$grid-type='category axis'">
            <xsl:variable name="category-axis-grid">
                <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:axis[@chart:dimension='x']/@chart:style-name"/>
            </xsl:variable>
            <xsl:for-each select="key('chart-style-name',$category-axis-grid)">
                <表:网格线 uof:locID="s0093" uof:attrList="类型 宽度 边距 颜色 阴影 位置">
                    <xsl:call-template name="表:边框"/>
                    <xsl:attribute name="表:位置"><xsl:value-of select="$grid-type"/></xsl:attribute>
                </表:网格线>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$grid-type='value axis'">
            <xsl:variable name="value-axis-grid">
                <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:axis[@chart:dimension='y']/@chart:style-name"/>
            </xsl:variable>
            <xsl:for-each select="key('chart-style-name',$value-axis-grid)">
                <表:网格线 uof:locID="s0093" uof:attrList="类型 宽度 边距 颜色 阴影 位置">
                    <xsl:call-template name="表:边框"/>
                    <xsl:attribute name="表:位置"><xsl:value-of select="$grid-type"/></xsl:attribute>
                </表:网格线>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="表:系列">
        <xsl:param name="table-name"/>
        <xsl:param name="data-area"/>
        <xsl:param name="series-generate"/>
        <xsl:param name="series-row-start"/>
        <xsl:param name="series-row-end"/>
        <xsl:param name="series-col-start"/>
        <xsl:param name="series-col-end"/>
        <xsl:param name="series-value-current"/>
        <xsl:param name="series-value-count"/>
        <xsl:choose>
            <xsl:when test="$series-value-current>$series-value-count"/>
            <xsl:otherwise>
                <表:系列 uof:locID="s0095" uof:attrList="系列名 系列值 分类名">
                    <xsl:attribute name="表:系列名"><xsl:value-of select="concat('系列',$series-value-current)"/></xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$series-generate='col'">
                            <xsl:variable name="series-col-letter-start">
                                <xsl:call-template name="General-Char-Transition">
                                    <xsl:with-param name="input-char" select="$series-col-start +$series-value-current -1"/>
                                    <xsl:with-param name="output-type" select="'CHARS_UPPER_LETTER'"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:attribute name="表:系列值"><xsl:value-of select="concat($table-name,'!',$series-col-letter-start,$series-row-start,':',$series-col-letter-start,$series-row-end)"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="series-col-letter-start">
                                <xsl:value-of select="substring(substring-after($data-area,'.'),1,1)"/>
                            </xsl:variable>
                            <xsl:variable name="series-col-letter-end">
                                <xsl:value-of select="substring(substring-after(substring-after($data-area,'.'),'.'),1,1)"/>
                            </xsl:variable>
                            <xsl:attribute name="表:系列值"><xsl:value-of select="concat($table-name,'!',$series-col-letter-start,$series-row-start +$series-value-current -1,':',$series-col-letter-end,$series-row-start +$series-value-current -1)"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </表:系列>
                <xsl:call-template name="表:系列">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="data-area" select="$data-area"/>
                    <xsl:with-param name="series-generate" select="$series-generate"/>
                    <xsl:with-param name="series-row-start" select="$series-row-start"/>
                    <xsl:with-param name="series-row-end" select="$series-row-end"/>
                    <xsl:with-param name="series-col-start" select="$series-col-start"/>
                    <xsl:with-param name="series-col-end" select="$series-col-end"/>
                    <xsl:with-param name="series-value-current" select="$series-value-current +1"/>
                    <xsl:with-param name="series-value-count" select="$series-value-count"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="表:标题">
        <xsl:param name="table-name"/>
        <xsl:param name="data-area"/>
        <xsl:param name="series-generate"/>
        <xsl:param name="caption-type"/>
        <xsl:if test="$caption-type='chart'">
            <xsl:variable name="chart-title">
                <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:title/@chart:style-name"/>
            </xsl:variable>
            <xsl:variable name="chart-title-name">
                <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:title/text:p"/>
            </xsl:variable>
            <xsl:for-each select="key('chart-style-name',$chart-title)">
                <表:标题 uof:locID="s0097" uof:attrList="名称 位置">
                    <xsl:attribute name="表:名称"><xsl:value-of select="$chart-title-name"/></xsl:attribute>
                    <xsl:attribute name="表:位置"><xsl:value-of select="$caption-type"/></xsl:attribute>
                    <xsl:call-template name="表:标题类型"/>
                </表:标题>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$caption-type='category axis'">
            <xsl:variable name="category-axis-title">
                <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:axis[@chart:dimension='x']/chart:title/@chart:style-name"/>
            </xsl:variable>
            <xsl:variable name="category-axis-title-name">
                <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:axis[@chart:dimension='x']/chart:title/text:p"/>
            </xsl:variable>
            <xsl:for-each select="key('chart-style-name',$category-axis-title)">
                <表:标题 uof:locID="s0097" uof:attrList="名称 位置">
                    <xsl:attribute name="表:名称"><xsl:value-of select="$category-axis-title-name"/></xsl:attribute>
                    <xsl:attribute name="表:位置"><xsl:value-of select="$caption-type"/></xsl:attribute>
                    <xsl:call-template name="表:标题类型"/>
                </表:标题>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$caption-type='value axis'">
            <xsl:variable name="value-axis-title">
                <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:axis[@chart:dimension='y']/chart:title/@chart:style-name"/>
            </xsl:variable>
            <xsl:variable name="value-axis-title-name">
                <xsl:value-of select="draw:object/office:document/office:body/office:chart/chart:chart/chart:plot-area/chart:axis[@chart:dimension='y']/chart:title/text:p"/>
            </xsl:variable>
            <xsl:for-each select="key('chart-style-name',$value-axis-title)">
                <表:标题 uof:locID="s0097" uof:attrList="名称 位置">
                    <xsl:attribute name="表:名称"><xsl:value-of select="$value-axis-title-name"/></xsl:attribute>
                    <xsl:attribute name="表:位置"><xsl:value-of select="$caption-type"/></xsl:attribute>
                    <xsl:call-template name="表:标题类型"/>
                </表:标题>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="表:坐标轴类型">
        <xsl:param name="table-name"/>
        <xsl:param name="data-area"/>
        <xsl:param name="series-generate"/>
        <xsl:param name="axis-type"/>
        <表:线型 uof:locID="s0062" uof:attrList="类型 宽度 边距 颜色 阴影">
            <xsl:attribute name="uof:类型"><xsl:call-template name="表:线型"/></xsl:attribute>
        </表:线型>
        <表:数值 uof:locID="s0063" uof:attrList="链接到源 分类名称 格式码">
            <xsl:attribute name="表:链接到源"><xsl:choose><xsl:when test="style:chart-properties/@chart:link-data-style-to-source"><xsl:value-of select="style:chart-properties/@chart:link-data-style-to-source"/></xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:if test="@style:data-style-name">
                <xsl:call-template name="Chart-NumberFormat">
                    <xsl:with-param name="temp-style" select="@style:data-style-name"/>
                </xsl:call-template>
            </xsl:if>
        </表:数值>
        <表:字体 uof:locID="s0059" uof:attrList="式样引用">
            <xsl:call-template name="字:句属性类型"/>
        </表:字体>
        <表:刻度 uof:locID="s0064">
            <xsl:call-template name="表:刻度类型"/>
        </表:刻度>
        <表:对齐 uof:locID="s0078">
            <xsl:if test="style:chart-properties/@style:direction">
                <xsl:element name="表:文字方向">
                    <xsl:attribute name="uof:locID">s0079</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="style:chart-properties/@style:direction = 'ttb'">vertical</xsl:when>
                        <xsl:otherwise>horizontal</xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:if>
            <xsl:if test="style:chart-properties/@text:rotation-angle">
                <表:旋转角度 uof:locID="s0080">
                    <xsl:value-of select="style:chart-properties/@text:rotation-angle"/>
                </表:旋转角度>
            </xsl:if>
            <表:偏移量 uof:locID="s0081"/>
        </表:对齐>
    </xsl:template>
    <xsl:template name="Chart-NumberFormat">
        <xsl:param name="temp-style"/>
        <xsl:for-each select="(preceding-sibling::*[@style:name=$temp-style]) | (following-sibling::*[@style:name=$temp-style])">
            <xsl:attribute name="表:分类名称"><xsl:choose><xsl:when test="name(.)='number:currency-style'">currency</xsl:when><xsl:when test="name(.)='number:percentage-style'">percentage</xsl:when><xsl:when test="name(.)='number:date-style'">date</xsl:when><xsl:when test="name(.)='number:time-style'">time</xsl:when><xsl:when test="name(.)='number:boolean-style'">custom</xsl:when><xsl:when test="name(.)='number:text-style'">text</xsl:when><xsl:when test="name(.)='number:number-style'"><xsl:choose><xsl:when test="number:fraction">fraction</xsl:when><xsl:when test="number:scientific-number">scientific</xsl:when><xsl:otherwise>number</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>general</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="表:格式码"><xsl:call-template name="element-attribute"/><xsl:for-each select="style:map"><xsl:text>[</xsl:text><xsl:value-of select="@style:condition"/><xsl:text>]</xsl:text><xsl:variable name="apply-style" select="@style:apply-style-name"/><xsl:for-each select="../../child::*[@style:name=$apply-style]/*"><xsl:call-template name="general-number-format"/></xsl:for-each><xsl:text>;</xsl:text></xsl:for-each><xsl:for-each select="*[not(name(.)='style:map')]"><xsl:call-template name="general-number-format"/></xsl:for-each></xsl:attribute>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:数据点类型">
        <xsl:param name="data-series-point"/>
        <xsl:param name="data-series-position"/>
        <xsl:for-each select="ancestor::draw:object/office:document/office:automatic-styles/style:style[@style:name=$data-series-point]">
            <表:边框 uof:locID="s0057" uof:attrList="类型 宽度 边距 颜色 阴影">
                <xsl:call-template name="表:边框"/>
            </表:边框>
            <xsl:if test="style:graphic-properties/@draw:fill-color or (style:graphic-properties/@draw:fill and not(style:graphic-properties/@draw:fill='none'))">
                <表:填充 uof:locID="s0058">
                    <xsl:call-template name="图:填充类型"/>
                </表:填充>
            </xsl:if>
            <表:字体 uof:locID="s0059" uof:attrList="式样引用">
                <xsl:call-template name="字:句属性类型"/>
            </表:字体>
            <表:显示标志 uof:locID="s0088" uof:attrList="系列名 类别名 数值 百分数 分隔符 图例标志">
                <xsl:attribute name="表:系列名">true</xsl:attribute>
                <xsl:if test="style:chart-properties/@chart:data-label-text">
                    <xsl:attribute name="表:类别名"><xsl:value-of select="style:chart-properties/@chart:data-label-text"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="style:chart-properties/@chart:data-label-number">
                    <xsl:choose>
                        <xsl:when test="style:chart-properties/@chart:data-label-number='value'">
                            <xsl:attribute name="表:数值">true</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="style:chart-properties/@chart:data-label-number='percentage'">
                            <xsl:attribute name="表:百分数">true</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="style:chart-properties/@chart:data-label-symbol">
                    <xsl:attribute name="表:图例标志"><xsl:value-of select="style:chart-properties/@chart:data-label-symbol"/></xsl:attribute>
                </xsl:if>
            </表:显示标志>
            <表:系列名 uof:locID="s0089">
                <xsl:value-of select="concat('系列',$data-series-position)"/>
            </表:系列名>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:标题类型">
        <表:边框 uof:locID="s0057" uof:attrList="类型 宽度 边距 颜色 阴影">
            <xsl:call-template name="表:边框"/>
        </表:边框>
        <xsl:if test="style:graphic-properties/@draw:fill-color or (style:graphic-properties/@draw:fill and not(style:graphic-properties/@draw:fill='none'))">
            <表:填充 uof:locID="s0058">
                <xsl:call-template name="图:填充类型"/>
            </表:填充>
        </xsl:if>
        <表:字体 uof:locID="s0059" uof:attrList="式样引用">
            <xsl:call-template name="字:句属性类型"/>
        </表:字体>
        <表:对齐 uof:locID="s0020">
            <xsl:call-template name="表:对齐格式类型"/>
        </表:对齐>
    </xsl:template>
    <xsl:template name="count-chart-data-point">
        <xsl:param name="data-point-count"/>
        <xsl:param name="data-point-position-temp"/>
        <xsl:choose>
            <xsl:when test="$data-point-position-temp=0">
                <xsl:value-of select="$data-point-count"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="temp">
                    <xsl:for-each select="../chart:data-point[position()=$data-point-position-temp]">
                        <xsl:choose>
                            <xsl:when test="@chart:repeated">
                                <xsl:value-of select="@chart:repeated"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:call-template name="count-chart-data-point">
                    <xsl:with-param name="data-point-count" select="$data-point-count +$temp"/>
                    <xsl:with-param name="data-point-position-temp" select="$data-point-position-temp -1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="表:边框">
        <xsl:attribute name="uof:类型"><xsl:call-template name="表:线型"/></xsl:attribute>
        <xsl:if test="style:graphic-properties/@svg:stroke-width">
            <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(style:graphic-properties/@svg:stroke-width,$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="style:graphic-properties/@svg:stroke-color">
            <xsl:attribute name="uof:颜色"><xsl:value-of select="style:graphic-properties/@svg:stroke-color"/></xsl:attribute>
        </xsl:if>
        <xsl:attribute name="uof:阴影">false</xsl:attribute>
    </xsl:template>
    <xsl:template name="图:填充类型">
        <xsl:choose>
            <xsl:when test="style:graphic-properties/@draw:fill='gradient'">
                <xsl:variable name="gradient-name">
                    <xsl:value-of select="style:graphic-properties/@draw:fill-gradient-name"/>
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
            <xsl:when test="style:graphic-properties/@draw:fill-image-name">
                <图:图片 uof:locID="g0035" uof:attrList="位置 图形引用 类型 名称">
                    <xsl:attribute name="图:位置"><xsl:choose><xsl:when test="not(style:graphic-properties/@style:repeat)">tile</xsl:when><xsl:otherwise><xsl:choose><xsl:when test="style:graphic-properties/@style:repeat = 'stretch'">stretch</xsl:when><xsl:when test="style:graphic-properties/@style:repeat = 'repeat'">tile</xsl:when><xsl:when test="style:graphic-properties/@style:repeat = 'no-repeat'">center</xsl:when></xsl:choose></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="图:图形引用"><xsl:value-of select="concat('chart_image_',count(preceding::draw:fill-image))"/></xsl:attribute>
                    <xsl:attribute name="图:类型">png</xsl:attribute>
                    <xsl:attribute name="图:名称"><xsl:value-of select="style:graphic-properties/@draw:fill-image-name"/></xsl:attribute>
                </图:图片>
            </xsl:when>
            <xsl:when test="style:graphic-properties/@draw:fill='hatch'">
                <图:图案 uof:locID="g0036" uof:attrList="类型 图形引用 前景色 背景色">
                    <xsl:attribute name="图:类型"><xsl:value-of select="../../office:styles/draw:hatch/@draw:name"/></xsl:attribute>
                    <xsl:attribute name="图:图形引用">gr1</xsl:attribute>
                    <xsl:attribute name="图:前景色"><xsl:value-of select="../../office:styles/draw:hatch/@draw:color"/></xsl:attribute>
                    <xsl:attribute name="图:背景色"><xsl:choose><xsl:when test="style:graphic-properties/@draw:fill-color"><xsl:value-of select="style:graphic-properties/@draw:fill-color"/></xsl:when><xsl:otherwise>#ffffff</xsl:otherwise></xsl:choose></xsl:attribute>
                </图:图案>
            </xsl:when>
            <xsl:otherwise>
                <图:颜色 uof:locID="g0034">
                    <xsl:choose>
                        <xsl:when test="style:graphic-properties/@draw:fill-color">
                            <xsl:value-of select="style:graphic-properties/@draw:fill-color"/>
                        </xsl:when>
                        <xsl:otherwise>#99ccff</xsl:otherwise>
                    </xsl:choose>
                </图:颜色>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="图:填充类型2">
        <xsl:if test="style:graphic-properties/@draw:fill-color">
            <图:颜色 uof:locID="g0034">
                <xsl:value-of select="style:graphic-properties/@draw:fill-color"/>
            </图:颜色>
        </xsl:if>
        <xsl:if test="style:graphic-properties/@draw:fill-image-name">
            <xsl:variable name="chart-image-name" select="style:graphic-properties/@draw:fill-image-name"/>
            <图:图片 uof:locID="g0035" uof:attrList="位置 图形引用 类型 名称">
                <xsl:attribute name="图:位置"><xsl:choose><xsl:when test="not(style:graphic-properties/@style:repeat)">tile</xsl:when><xsl:otherwise><xsl:choose><xsl:when test="style:graphic-properties/@style:repeat = 'stretch'">stretch</xsl:when><xsl:when test="style:graphic-properties/@style:repeat = 'repeat'">tile</xsl:when><xsl:when test="style:graphic-properties/@style:repeat = 'no-repeat'">center</xsl:when></xsl:choose></xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:for-each select="../../office:styles/draw:fill-image[@draw:name=$chart-image-name]">
                    <xsl:attribute name="图:图形引用"><xsl:value-of select="concat('chart_image_',count(preceding::draw:fill-image))"/></xsl:attribute>
                </xsl:for-each>
                <xsl:attribute name="图:类型">png</xsl:attribute>
                <xsl:attribute name="图:名称"><xsl:value-of select="$chart-image-name"/></xsl:attribute>
            </图:图片>
        </xsl:if>
        <xsl:if test="style:graphic-properties/@draw:fill-hatch-name">
            <xsl:variable name="chart-hatch-name" select="style:graphic-properties/@draw:fill-hatch-name"/>
            <图:图案 uof:locID="g0036" uof:attrList="类型 图形引用 前景色 背景色">
                <xsl:for-each select="../../office:styles/draw:hatch[@draw:name=$chart-hatch-name]">
                    <xsl:attribute name="图:类型"><xsl:value-of select="@draw:style"/></xsl:attribute>
                    <xsl:attribute name="图:前景色"><xsl:value-of select="@draw:color"/></xsl:attribute>
                    <xsl:attribute name="图:背景色"/>
                    <xsl:attribute name="图:距离"><xsl:value-of select="@draw:distance"/></xsl:attribute>
                    <xsl:attribute name="图:旋转度"><xsl:value-of select="@draw:rotation"/></xsl:attribute>
                </xsl:for-each>
                <xsl:attribute name="图:图形引用"><xsl:value-of select="$chart-hatch-name"/></xsl:attribute>
            </图:图案>
        </xsl:if>
        <xsl:if test="style:graphic-properties/@draw:fill-gradient-name">
            <xsl:variable name="chart-gradient-name" select="style:graphic-properties/@draw:fill-gradient-name"/>
            <图:渐变 uof:locID="g0037" uof:attrList="起始色 终止色 种子类型 起始浓度 终止浓度 渐变方向 边界 种子X位置 种子Y位置 类型">
                <xsl:for-each select="../../office:styles/draw:gradient[@draw:name=$chart-gradient-name]">
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
                </xsl:for-each>
                <xsl:attribute name="图:图形引用"><xsl:value-of select="$chart-gradient-name"/></xsl:attribute>
            </图:渐变>
        </xsl:if>
    </xsl:template>
    <xsl:template name="表:对齐格式类型">
        <xsl:if test="style:chart-properties/@style:rotation-angle">
            <表:文字旋转角度 uof:locID="s0080">
                <xsl:value-of select="style:chart-properties/@style:rotation-angle"/>
            </表:文字旋转角度>
        </xsl:if>
        <xsl:if test="style:chart-properties/@fo:text-align">
            <xsl:element name="表:水平对齐方式">
                <xsl:attribute name="uof:locID">s0115</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="style:chart-properties/@fo:text-align = 'center'">center</xsl:when>
                    <xsl:when test="style:chart-properties/@fo:text-align = 'end'">right</xsl:when>
                    <xsl:when test="style:chart-properties/@fo:text-align = 'justify'">justify</xsl:when>
                    <xsl:when test="style:chart-properties/@fo:text-align = 'start'">left</xsl:when>
                    <xsl:otherwise>fill</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
        <xsl:if test="(style:chart-properties/@style:vertical-align) or (style:chart-properties/@fo:vertical-align)">
            <xsl:element name="表:垂直对齐方式">
                <xsl:attribute name="uof:locID">s0116</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="style:chart-properties/@fo:vertical-align = 'top'">top</xsl:when>
                    <xsl:when test="style:chart-properties/@fo:vertical-align = 'middle'">center</xsl:when>
                    <xsl:when test="style:chart-properties/@fo:vertical-align = 'bottom'">bottom</xsl:when>
                    <xsl:when test="style:chart-properties/@fo:vertical-align = 'justify'">justify</xsl:when>
                    <xsl:otherwise>distributed</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:paragraph-properties/@fo:margin-left">
            <表:缩进 uof:locID="s0117">
                <xsl:value-of select="substring-before(style:paragraph-properties/@fo:margin-left,$uofUnit)"/>
            </表:缩进>
        </xsl:if>
        <xsl:element name="表:文字方向">
            <xsl:attribute name="uof:locID">s0118</xsl:attribute>
            <xsl:choose>
                <xsl:when test="style:chart-properties/@style:direction = 'ttb'">vertical</xsl:when>
                <xsl:otherwise>horizontal</xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <表:自动换行 uof:locID="s0120" uof:attrList="值">
            <xsl:attribute name="表:值">true</xsl:attribute>
        </表:自动换行>
        <表:缩小字体填充 uof:locID="s0121" uof:attrList="值">
            <xsl:attribute name="表:值">true</xsl:attribute>
        </表:缩小字体填充>
    </xsl:template>
    <xsl:template name="表:线型">
        <xsl:variable name="linetype" select="style:graphic-properties/@draw:stroke-dash"/>
        <xsl:variable name="stroke" select="style:graphic-properties/@draw:stroke"/>
        <xsl:choose>
            <xsl:when test="$stroke='solid'">single</xsl:when>
            <xsl:when test="$stroke='none'">none</xsl:when>
            <xsl:when test="$stroke='dash'">
                <xsl:choose>
                    <xsl:when test="$linetype='Ultrafine_20_Dashed'">dash</xsl:when>
                    <xsl:when test="$linetype='Fine_20_Dashed'">dashed-heavy</xsl:when>
                    <xsl:when test="$linetype='Ultrafine_20_2_20_Dots_20_3_20_Dashes'">dot-dash</xsl:when>
                    <xsl:when test="$linetype='Fine_20_Dotted'">dotted</xsl:when>
                    <xsl:when test="$linetype='Line_20_with_20_Fine_20_Dots'">dash-long-heavy</xsl:when>
                    <xsl:when test="$linetype='Fine_20_Dashed_20__28_var_29_'">dash-long</xsl:when>
                    <xsl:when test="$linetype='_33__20_Dashes_20_3_20_Dots_20__28_var_29_'">dash-dot-dot</xsl:when>
                    <xsl:when test="$linetype='Ultrafine_20_Dotted_20__28_var_29_'">dotted-heavy</xsl:when>
                    <xsl:when test="$linetype='Line_20_Style_20_9'">thick</xsl:when>
                    <xsl:when test="$linetype='_32__20_Dots_20_1_20_Dash'">dot-dot-dash</xsl:when>
                    <xsl:when test="$linetype='Dashed_20__28_var_29_'">dash-dot-dot-heavy</xsl:when>
                    <xsl:when test="$linetype='Dash_20_10'">dash-dot-heavy</xsl:when>
                    <xsl:otherwise>single</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>single</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="表:刻度类型">
        <xsl:if test="style:chart-properties/@chart:minimum">
            <表:最小值 uof:locID="s0065">
                <xsl:value-of select="style:chart-properties/@chart:minimum"/>
            </表:最小值>
        </xsl:if>
        <xsl:if test="style:chart-properties/@chart:maximum">
            <表:最大值 uof:locID="s0066">
                <xsl:value-of select="style:chart-properties/@chart:maximum"/>
            </表:最大值>
        </xsl:if>
        <xsl:if test="style:chart-properties/@chart:interval-major">
            <表:主单位 uof:locID="s0067">
                <xsl:value-of select="style:chart-properties/@chart:interval-major"/>
            </表:主单位>
        </xsl:if>
        <xsl:if test="style:chart-properties/@chart:interval-minor">
            <表:次单位 uof:locID="s0068">
                <xsl:value-of select="style:chart-properties/@chart:interval-minor"/>
            </表:次单位>
        </xsl:if>
        <xsl:if test="style:chart-properties/@chart:origin">
            <表:分类交叉点 uof:locID="s0069">
                <xsl:value-of select="style:chart-properties/@chart:origin"/>
            </表:分类交叉点>
        </xsl:if>
        <表:单位 uof:locID="s0070">none</表:单位>
        <表:显示单位 uof:locID="s0071" uof:attrList="值" 表:值="false"/>
        <表:对数 uof:locID="s0072" uof:attrList="值" 表:值="false"/>
    </xsl:template>
    <xsl:template name="字:句属性类型">
        <xsl:element name="字:字体">
            <xsl:attribute name="uof:locID">t0088</xsl:attribute>
            <xsl:attribute name="uof:attrList">西文字体引用 中文字体引用 特殊字体引用 西文绘制 字号 相对字号 颜色</xsl:attribute>
            <xsl:if test="style:text-properties/@fo:font-size or style:text-properties/@style:font-size-asian or  style:text-properties/@style:font-size-complex">
                <xsl:choose>
                    <xsl:when test="contains(style:text-properties/@fo:font-size,'%') or contains(style:text-properties/@style:font-size-asian,'%')">
                        <xsl:attribute name="字:相对字号"><xsl:choose><xsl:when test="style:text-properties/@fo:font-size"><xsl:value-of select="substring-before(style:text-properties/@fo:font-size,'%')"/></xsl:when><xsl:when test="style:text-properties/@style:font-size-asian"><xsl:value-of select="substring-before(style:text-properties/@style:font-size-asian,'%')"/></xsl:when></xsl:choose></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="字:字号"><xsl:choose><xsl:when test="style:text-properties/@fo:font-size"><xsl:value-of select="substring-before(style:text-properties/@fo:font-size,'pt')"/></xsl:when><xsl:when test="style:text-properties/@style:font-size-asian"><xsl:value-of select="substring-before(style:text-properties/@style:font-size-asian,'pt')"/></xsl:when><xsl:when test="style:text-properties/@style:font-size-complex"><xsl:value-of select="substring-before(style:text-properties/@style:font-size-complex,'pt')"/></xsl:when></xsl:choose></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="style:text-properties/@fo:font-family">
                <xsl:attribute name="字:西文字体引用"><xsl:value-of select="style:text-properties/@fo:font-family"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="style:text-properties/@style:font-family-asian">
                <xsl:attribute name="字:中文字体引用"><xsl:value-of select="style:text-properties/@style:font-family-asian"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="style:text-properties/@fo:color">
                <xsl:attribute name="字:颜色"><xsl:value-of select="style:text-properties/@fo:color"/></xsl:attribute>
            </xsl:if>
        </xsl:element>
        <xsl:if test="style:text-properties/@style:text-background-color and not(style:text-properties/@style:text-background-color='transparent')">
            <xsl:element name="字:填充">
                <xsl:element name="图:图案">
                    <xsl:attribute name="uof:locID">g0036</xsl:attribute>
                    <xsl:attribute name="uof:attrList">类型 图形引用 前景色 背景色</xsl:attribute>
                    <xsl:if test="style:text-properties/@style:text-background-color">
                        <xsl:attribute name="图:前景色"><xsl:value-of select="style:text-properties/@style:text-background-color"/></xsl:attribute>
                    </xsl:if>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@fo:font-weight or style:text-properties/@style:font-weight-asian">
            <xsl:element name="字:粗体">
                <xsl:attribute name="uof:locID">t0089</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:text-properties/@style:font-weight-asian='bold' or style:text-properties/@fo:font-weight='bold'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@fo:font-style or style:text-properties/@style:font-style-asian">
            <xsl:element name="字:斜体">
                <xsl:attribute name="uof:locID">t0090</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:text-properties/@fo:font-style='italic' or style:text-properties/@style:font-style-asian='italic'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:text-line-through-style  and not(style:text-properties/@style:text-line-through-style='none')">
            <xsl:element name="字:删除线">
                <xsl:attribute name="uof:locID">t0094</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                <xsl:attribute name="字:类型"><xsl:call-template name="uof:delete线型类型"/></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:text-underline">
            <xsl:element name="字:下划线">
                <xsl:attribute name="字:类型"><xsl:call-template name="uof:线型类型"/></xsl:attribute>
                <xsl:attribute name="uof:locID">t0095</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                <xsl:if test="style:text-properties/@style:text-underline-color">
                    <xsl:attribute name="字:颜色"><xsl:choose><xsl:when test="style:text-properties/@style:text-underline-color='font-color'">auto</xsl:when><xsl:otherwise><xsl:value-of select="style:text-properties/@style:text-underline-color"/></xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@fo:text-shadow">
            <xsl:element name="字:阴影">
                <xsl:attribute name="uof:locID">t0100</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:text-properties/@fo:text-shadow='none'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:text-emphasize">
            <xsl:element name="字:着重号">
                <xsl:attribute name="uof:locID">t0096</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型 颜色 字着重号</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="style:text-properties/@style:text-emphasize='none'">
                        <xsl:attribute name="字:字着重号">false</xsl:attribute>
                        <xsl:attribute name="字:类型">none</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="字:字着重号">true</xsl:attribute>
                        <xsl:attribute name="字:类型"><xsl:call-template name="uof:着重号类型"><xsl:with-param name="te" select="style:text-properties/@style:text-emphasize"/></xsl:call-template></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="style:text-properties/@fo:color">
                    <xsl:attribute name="字:颜色"><xsl:value-of select="style:text-properties/@fo:color"/></xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@text:display">
            <xsl:element name="字:隐藏文字">
                <xsl:attribute name="uof:locID">t0097</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值">true</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:text-outline">
            <xsl:element name="字:空心">
                <xsl:attribute name="uof:locID">t0098</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:value-of select="style:text-properties/@style:text-outline"/></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:font-relief">
            <xsl:element name="字:浮雕">
                <xsl:attribute name="uof:locID">t0099</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                <xsl:attribute name="字:类型"><xsl:choose><xsl:when test="style:text-properties/@style:font-relief='embossed'">emboss</xsl:when><xsl:when test="style:text-properties/@style:font-relief='engraved'">engrave</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@fo:text-transform or style:text-properties/@fo:font-variant">
            <xsl:element name="字:醒目字体">
                <xsl:attribute name="uof:locID">t0101</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                <xsl:attribute name="字:类型"><xsl:choose><xsl:when test="style:text-properties/@fo:text-transform='uppercase'">uppercase</xsl:when><xsl:when test="style:text-properties/@fo:text-transform='lowercase'">lowercase</xsl:when><xsl:when test="style:text-properties/@fo:text-transform='capitalize'">capital</xsl:when><xsl:when test="style:text-properties/@fo:font-variant='small-caps'">small-caps</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:text-position">
            <xsl:element name="字:位置">
                <xsl:attribute name="uof:locID">t0102</xsl:attribute>
                <xsl:value-of select="style:text-properties/@style:text-position"/>
            </xsl:element>
            <字:上下标 uof:locID="t0205" uof:attrList="值">
                <xsl:attribute name="字:值">none</xsl:attribute>
            </字:上下标>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:text-scale">
            <xsl:element name="字:缩放">
                <xsl:attribute name="uof:locID">t0103</xsl:attribute>
                <xsl:value-of select="style:text-properties/@style:text-scale"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@fo:letter-spacing">
            <xsl:element name="字:字符间距">
                <xsl:attribute name="uof:locID">t0104</xsl:attribute>
                <xsl:value-of select="style:text-properties/@fo:letter-spacing"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:letter-kerning">
            <xsl:element name="字:调整字间距">
                <xsl:attribute name="uof:locID">t015</xsl:attribute>
                <xsl:value-of select="style:text-properties/@style:letter-kerning"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="uof:着重号类型">
        <xsl:param name="te"/>
        <xsl:choose>
            <xsl:when test="$te='disc above' ">disc above</xsl:when>
            <xsl:when test="$te='circle above' ">circle above</xsl:when>
            <xsl:when test="$te='dot above' ">dot above</xsl:when>
            <xsl:when test="$te='accent above' ">accent above</xsl:when>
            <xsl:when test="$te='dot below' ">dot below</xsl:when>
            <xsl:when test="$te='circle below' ">circle below</xsl:when>
            <xsl:when test="$te='disc below' ">disc below</xsl:when>
            <xsl:when test="$te='accent below' ">accent below</xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="uof:线型类型">
        <xsl:variable name="spath" select="style:text-properties/@style:text-underline-style"/>
        <xsl:variable name="wpath" select="style:text-properties/@style:text-underline-width"/>
        <xsl:variable name="tpath" select="style:text-properties/@style:text-underline-type"/>
        <xsl:choose>
            <xsl:when test="$spath='solid' and not($tpath='double' ) and $wpath='auto' ">single</xsl:when>
            <xsl:when test="$spath='solid' and $tpath='double' and $wpath='auto' ">double</xsl:when>
            <xsl:when test="$spath='solid' and not($tpath='double' )and $wpath='bold' ">thick</xsl:when>
            <xsl:when test="$spath='dotted' and not($tpath='double' )and $wpath='auto' ">dotted</xsl:when>
            <xsl:when test="$spath='dotted' and not($tpath='double' )and $wpath='bold' ">dotted-heavy</xsl:when>
            <xsl:when test="$spath='dash' and not($tpath='double' )and $wpath='auto' ">dash</xsl:when>
            <xsl:when test="$spath='dash' and not($tpath='double' )and $wpath='bold' ">dashed-heavy</xsl:when>
            <xsl:when test="$spath='long-dash' and not($tpath='double' )and $wpath='auto' ">dash-long</xsl:when>
            <xsl:when test="$spath='long-dash' and not($tpath='double' )and $wpath='bold' ">dash-long-heavy</xsl:when>
            <xsl:when test="$spath='dot-dash' and not($tpath='double' )and $wpath='auto' ">dot-dash</xsl:when>
            <xsl:when test="$spath='dot-dash' and not($tpath='double' )and $wpath='bold' ">dash-dot-heavy</xsl:when>
            <xsl:when test="$spath='dot-dot-dash' and not($tpath='double' )and $wpath='auto' ">dot-dot-dash</xsl:when>
            <xsl:when test="$spath='dot-dot-dash' and not($tpath='double' )and $wpath='bold' ">dash-dot-dot-heavy</xsl:when>
            <xsl:when test="$spath='wave' and not($tpath='double' )and $wpath='auto' ">wave</xsl:when>
            <xsl:when test="$spath='wave' and not($tpath='double' )and $wpath='bold' ">wavy-heavy</xsl:when>
            <xsl:when test="$spath='wave' and $tpath='double' and $wpath='auto' ">wavy-double</xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="uof:delete线型类型">
        <xsl:variable name="wpath" select="style:text-properties/@style:text-line-through-width"/>
        <xsl:variable name="textpath" select="style:text-properties/@style:text-line-through-text"/>
        <xsl:variable name="umpath" select="style:text-properties/@style:text-underline-mode"/>
        <xsl:variable name="tmpath" select="style:text-properties/@style:text-line-through-mode"/>
        <xsl:variable name="tpath" select="style:text-properties/@style:text-line-through-type"/>
        <xsl:choose>
            <xsl:when test="$umpath='continuous' and $tmpath='continuous'">single</xsl:when>
            <xsl:when test="$tpath='double'">double</xsl:when>
            <xsl:when test="$wpath='bold'">bold</xsl:when>
            <xsl:when test="$textpath='/'">带/</xsl:when>
            <xsl:when test="$textpath='X'">带X</xsl:when>
            <xsl:otherwise>none</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--comment: if input char is Roman,please add a prefix 'Roman_'-->
    <xsl:template name="General-Char-Transition">
        <xsl:param name="input-char"/>
        <xsl:param name="output-type"/>
        <xsl:choose>
            <xsl:when test="$input-char='A' or $input-char='a' or $input-char='1' or $input-char='Roman_I' or $input-char='Roman_i' or $input-char='一' or $input-char='壹' or $input-char='甲' or $input-char='子'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">1</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">a</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">A</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">I</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">i</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">1</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">一</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">1</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">壹</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">1</xsl:when>
                    <xsl:when test="$output-type='TIAN_GAN_ZH'">甲</xsl:when>
                    <xsl:when test="$output-type='DI_ZI_ZH'">子</xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='B' or $input-char='b' or $input-char='2' or $input-char='Roman_II' or $input-char='Roman_ii' or $input-char='二' or $input-char='贰' or $input-char='乙' or $input-char='丑'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">2</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">b</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">B</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">II</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">ii</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">２</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">二</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">2</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">贰</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">2</xsl:when>
                    <xsl:when test="$output-type='TIAN_GAN_ZH'">乙</xsl:when>
                    <xsl:when test="$output-type='DI_ZI_ZH'">丑</xsl:when>
                    <xsl:otherwise>2</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='C' or $input-char='c' or $input-char='3' or $input-char='Roman_III' or $input-char='Roman_iii' or $input-char='三' or $input-char='叁' or $input-char='丙' or $input-char='寅'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">3</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">c</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">C</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">III</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">iii</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">３</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">三</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">３</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">叁</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">３</xsl:when>
                    <xsl:when test="$output-type='TIAN_GAN_ZH'">丙</xsl:when>
                    <xsl:when test="$output-type='DI_ZI_ZH'">寅</xsl:when>
                    <xsl:otherwise>3</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='D' or $input-char='d' or $input-char='4' or $input-char='Roman_IV' or $input-char='Roman_iv' or $input-char='四' or $input-char='肆' or $input-char='丁' or $input-char='卯'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">4</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">d</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">D</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">IV</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">iv</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">４</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">四</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">4</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">肆</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">4</xsl:when>
                    <xsl:when test="$output-type='TIAN_GAN_ZH'">丁</xsl:when>
                    <xsl:when test="$output-type='DI_ZI_ZH'">卯</xsl:when>
                    <xsl:otherwise>4</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='E' or $input-char='e' or $input-char='5' or $input-char='Roman_V' or $input-char='Roman_v' or $input-char='五' or $input-char='伍' or $input-char='戊' or $input-char='辰'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">5</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">e</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">E</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">V</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">v</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">5</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">五</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">5</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">伍</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">5</xsl:when>
                    <xsl:when test="$output-type='TIAN_GAN_ZH'">戊</xsl:when>
                    <xsl:when test="$output-type='DI_ZI_ZH'">辰</xsl:when>
                    <xsl:otherwise>5</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='F' or $input-char='f' or $input-char='6' or $input-char='Roman_VI' or $input-char='Roman_vi' or $input-char='六' or $input-char='陆' or $input-char='己' or $input-char='巳'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">6</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">f</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">F</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">VI</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">vi</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">６</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">六</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">６</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">陆</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">６</xsl:when>
                    <xsl:when test="$output-type='TIAN_GAN_ZH'">己</xsl:when>
                    <xsl:when test="$output-type='DI_ZI_ZH'">巳</xsl:when>
                    <xsl:otherwise>6</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='G' or $input-char='g' or $input-char='7' or $input-char='Roman_VII' or $input-char='Roman_vii' or $input-char='七' or $input-char='柒' or $input-char='庚' or $input-char='午'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">7</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">g</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">G</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">VII</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">vii</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">７</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">七</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">7</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">柒</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">7</xsl:when>
                    <xsl:when test="$output-type='TIAN_GAN_ZH'">庚</xsl:when>
                    <xsl:when test="$output-type='DI_ZI_ZH'">午</xsl:when>
                    <xsl:otherwise>7</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='H' or $input-char='h' or $input-char='8' or $input-char='Roman_VIII' or $input-char='Roman_viii' or $input-char='八' or $input-char='捌' or $input-char='辛' or $input-char='未'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">8</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">h</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">H</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">VIII</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">viii</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">８</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">八</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">8</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">捌</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">8</xsl:when>
                    <xsl:when test="$output-type='TIAN_GAN_ZH'">辛</xsl:when>
                    <xsl:when test="$output-type='DI_ZI_ZH'">未</xsl:when>
                    <xsl:otherwise>8</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='I' or $input-char='i' or $input-char='9' or $input-char='Roman_IX' or $input-char='Roman_ix' or $input-char='九' or $input-char='玖' or $input-char='壬' or $input-char='申'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">9</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">i</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">I</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">IX</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">ix</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">９</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">九</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">９</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">玖</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">９</xsl:when>
                    <xsl:when test="$output-type='TIAN_GAN_ZH'">壬</xsl:when>
                    <xsl:when test="$output-type='DI_ZI_ZH'">申</xsl:when>
                    <xsl:otherwise>9</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='J' or $input-char='j' or $input-char='10' or $input-char='Roman_X' or $input-char='Roman_x' or $input-char='十' or $input-char='拾' or $input-char='癸' or $input-char='酉'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">10</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">j</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">J</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">X</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">x</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">10</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">十</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">10</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">拾</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">10</xsl:when>
                    <xsl:when test="$output-type='TIAN_GAN_ZH'">癸</xsl:when>
                    <xsl:when test="$output-type='DI_ZI_ZH'">酉</xsl:when>
                    <xsl:otherwise>10</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='K' or $input-char='k' or $input-char='11' or $input-char='Roman_XI' or $input-char='Roman_xi' or $input-char='十一' or $input-char='拾壹' or $input-char='戌'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">11</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">k</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">K</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XI</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xi</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">１１</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">十一</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">11</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">拾壹</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">11</xsl:when>
                    <xsl:when test="$output-type='DI_ZI_ZH'">戌</xsl:when>
                    <xsl:otherwise>11</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='L' or $input-char='l' or $input-char='12' or $input-char='Roman_XII' or $input-char='Roman_xii' or $input-char='十二' or $input-char='拾贰' or $input-char='亥'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">12</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">l</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">L</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XII</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xii</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">12</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">十二</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">12</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">拾贰</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">12</xsl:when>
                    <xsl:when test="$output-type='DI_ZI_ZH'">亥</xsl:when>
                    <xsl:otherwise>12</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='M' or $input-char='m' or $input-char='13' or $input-char='Roman_XIII' or $input-char='Roman_xiii' or $input-char='十三' or $input-char='拾叁'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">13</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">m</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">M</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XIII</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xiii</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">13</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">十三</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">13</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">拾叁</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">13</xsl:when>
                    <xsl:otherwise>13</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='N' or $input-char='n' or $input-char='14' or $input-char='Roman_XIV' or $input-char='Roman_xiv' or $input-char='十四' or $input-char='拾肆'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">14</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">n</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">N</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XIV</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xiv</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">14</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">十四</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">14</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">拾肆</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">14</xsl:when>
                    <xsl:otherwise>14</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='O' or $input-char='o' or $input-char='15' or $input-char='Roman_XV' or $input-char='Roman_xv' or $input-char='十五' or $input-char='拾伍'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">15</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">o</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">O</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XV</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xv</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">15</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">十五</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">15</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">拾伍</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">15</xsl:when>
                    <xsl:otherwise>15</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='P' or $input-char='p' or $input-char='16' or $input-char='Roman_XVI' or $input-char='Roman_xvi' or $input-char='十六' or $input-char='拾陆'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">16</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">p</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">P</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XVI</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xvi</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">16</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">十六</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">16</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">拾陆</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">16</xsl:when>
                    <xsl:otherwise>16</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='Q' or $input-char='q' or $input-char='17' or $input-char='Roman_XVII' or $input-char='Roman_xvii' or $input-char='十七' or $input-char='拾柒'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">17</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">q</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">Q</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XVII</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xvii</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">17</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">十七</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">17</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">拾柒</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">17</xsl:when>
                    <xsl:otherwise>17</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='R' or $input-char='r' or $input-char='18' or $input-char='Roman_XVIII' or $input-char='Roman_xviii' or $input-char='十八' or $input-char='拾捌'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">18</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">r</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">R</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XVIII</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xviii</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">18</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">十八</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">18</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">拾捌</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">18</xsl:when>
                    <xsl:otherwise>18</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='S' or $input-char='s' or $input-char='19' or $input-char='Roman_XIX' or $input-char='Roman_xix' or $input-char='十九' or $input-char='拾玖'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">19</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">s</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">S</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XIX</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xix</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">19</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">十九</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">19</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">拾玖</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">19</xsl:when>
                    <xsl:otherwise>19</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='T' or $input-char='t' or $input-char='20' or $input-char='Roman_XX' or $input-char='Roman_xx' or $input-char='二十' or $input-char='贰拾'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">20</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">t</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">T</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XX</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xx</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">20</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">二十</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">20</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">贰拾</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">20</xsl:when>
                    <xsl:otherwise>20</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='U' or $input-char='u' or $input-char='21' or $input-char='Roman_XXI' or $input-char='Roman_xxi' or $input-char='二十一' or $input-char='贰拾壹'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">21</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">u</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">U</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XXI</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xxi</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">21</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">二十一</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">21</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">贰拾壹</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">21</xsl:when>
                    <xsl:otherwise>21</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='V' or $input-char='v' or $input-char='22' or $input-char='Roman_XXII' or $input-char='Roman_xxii' or $input-char='二十二' or $input-char='贰拾贰'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">22</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">v</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">V</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XXII</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xxii</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">22</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">二十二</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">22</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">贰拾贰</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">22</xsl:when>
                    <xsl:otherwise>22</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='W' or $input-char='w' or $input-char='23' or $input-char='Roman_XXIII' or $input-char='Roman_xxiii' or $input-char='二十三' or $input-char='贰拾叁'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">23</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">w</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">W</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XXIII</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xxiii</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">23</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">二十三</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">23</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">贰拾叁</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">23</xsl:when>
                    <xsl:otherwise>23</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='X' or $input-char='x' or $input-char='24' or $input-char='Roman_XXIV' or $input-char='Roman_xxiv' or $input-char='二十四' or $input-char='贰拾肆'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">24</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">x</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">X</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XXIV</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xxiv</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">24</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">二十四</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">24</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">贰拾肆</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">24</xsl:when>
                    <xsl:otherwise>24</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='Y' or $input-char='y' or $input-char='25' or $input-char='Roman_XXV' or $input-char='Roman_xxv' or $input-char='二十五' or $input-char='贰拾伍'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">25</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">y</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">Y</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XXV</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xxv</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">25</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">二十五</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">25</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">贰拾伍</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">25</xsl:when>
                    <xsl:otherwise>25</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$input-char='Z' or $input-char='z' or $input-char='26' or $input-char='Roman_XXVI' or $input-char='Roman_xxvi' or $input-char='二十六' or $input-char='贰拾陆'">
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">26</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">z</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">Z</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">XXVI</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">xxvi</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">26</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">二十六</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">26</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">贰拾陆</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">26</xsl:when>
                    <xsl:otherwise>26</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$output-type='ARABIC'">1</xsl:when>
                    <xsl:when test="$output-type='CHARS_LOWER_LETTER'">a</xsl:when>
                    <xsl:when test="$output-type='CHARS_UPPER_LETTER'">A</xsl:when>
                    <xsl:when test="$output-type='ROMAN_UPPER'">I</xsl:when>
                    <xsl:when test="$output-type='ROMAN_LOWER'">i</xsl:when>
                    <xsl:when test="$output-type='FULLWIDTH_ARABIC'">1</xsl:when>
                    <xsl:when test="$output-type='NUMBER_LOWER_ZH'">一</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH_TW'">1</xsl:when>
                    <xsl:when test="$output-type='NUMBER_UPPER_ZH'">壹</xsl:when>
                    <xsl:when test="$output-type='CIRCLE_NUMBER'">1</xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--RedOffice comment (Zengjh) end charts-->
    <!-- 以下模板的作用是将网格线的R或者G或者B颜色从十进制转换为16进制-->
    <xsl:template name="transform-decimal-to-hexadecimal">
        <xsl:param name="color-decimal"/>
        <xsl:variable name="first-number" select="floor($color-decimal div 16)"/>
        <xsl:variable name="first-char">
            <xsl:call-template name="decimal-to-hex">
                <xsl:with-param name="number" select="$first-number"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="second-number" select="$color-decimal - ($first-number * 16)"/>
        <xsl:variable name="second-char">
            <xsl:call-template name="decimal-to-hex">
                <xsl:with-param name="number" select="$second-number"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat($first-char,$second-char)"/>
    </xsl:template>
    <!-- 以下模板的作用为将0到15的整数转换为16进制数-->
    <xsl:template name="decimal-to-hex">
        <xsl:param name="number"/>
        <xsl:choose>
            <xsl:when test="$number=0">0</xsl:when>
            <xsl:when test="$number=1">1</xsl:when>
            <xsl:when test="$number=2">2</xsl:when>
            <xsl:when test="$number=3">3</xsl:when>
            <xsl:when test="$number=4">4</xsl:when>
            <xsl:when test="$number=5">5</xsl:when>
            <xsl:when test="$number=6">6</xsl:when>
            <xsl:when test="$number=7">7</xsl:when>
            <xsl:when test="$number=8">8</xsl:when>
            <xsl:when test="$number=9">9</xsl:when>
            <xsl:when test="$number=10">a</xsl:when>
            <xsl:when test="$number=11">b</xsl:when>
            <xsl:when test="$number=12">c</xsl:when>
            <xsl:when test="$number=13">d</xsl:when>
            <xsl:when test="$number=14">e</xsl:when>
            <xsl:when test="$number='15'">f</xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="setDefaultPageWidth">
        <xsl:choose>
            <xsl:when test="$uofUnit='inch'">
                <xsl:value-of select="'7.9'"/>
            </xsl:when>
            <xsl:when test="$uofUnit='cm'">
                <xsl:value-of select="'20.999'"/>
            </xsl:when>
            <xsl:when test="$uofUnit='mm'">
                <xsl:value-of select="'200.99'"/>
            </xsl:when>
            <xsl:when test="$uofUnit='pt'">
                <xsl:value-of select="'7870'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'20.990'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="setDefaultPageHeight">
        <xsl:choose>
            <xsl:when test="$uofUnit='inch'">
                <xsl:value-of select="'10.14'"/>
            </xsl:when>
            <xsl:when test="$uofUnit='cm'">
                <xsl:value-of select="'26.999'"/>
            </xsl:when>
            <xsl:when test="$uofUnit='mm'">
                <xsl:value-of select="'269.99'"/>
            </xsl:when>
            <xsl:when test="$uofUnit='pt'">
                <xsl:value-of select="'1023'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'26.990'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--ro000179 chenjh-->
    <xsl:template name="create-condition-format">
        <xsl:variable name="unique-map-cellstyle" select="/office:document/office:automatic-styles/style:style[style:map and not(style:map/@style:condition=preceding-sibling::style:style/style:map/@style:condition and style:map/@style:apply-style-name=preceding-sibling::style:style/style:map/@style:apply-style-name and style:map/@style:base-cell-address=preceding-sibling::style:style/style:map/@style:base-cell-address)]"/>
        <xsl:for-each select="$unique-map-cellstyle">
            <xsl:call-template name="create-cell-condition-format"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="create-cell-condition-format">
        <xsl:element name="表:条件格式化">
            <xsl:attribute name="uof:locID">s0017</xsl:attribute>
            <xsl:element name="表:区域">
                <xsl:attribute name="uof:locID">s0007</xsl:attribute>
                <xsl:variable name="cellstylenamelist">
                    <xsl:call-template name="createcellnamelist">
                        <xsl:with-param name="list">
                            <xsl:value-of select="/office:document/office:automatic-styles/style:style[style:map and (style:map/@style:condition=current()/style:map/@style:condition and style:map/@style:apply-style-name=current()/style:map/@style:apply-style-name and style:map/@style:base-cell-address=current()/style:map/@style:base-cell-address)]"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <!-- <xsl:value-of select="concat($cellstylenamelist,'end')"/>-->
                <xsl:variable name="left-top">
                    <xsl:call-template name="search-left-top">
                        <xsl:with-param name="cellstylenamelist" select="$cellstylenamelist"/>
                    </xsl:call-template>
                </xsl:variable>
                <!-- <xsl:value-of select="concat('qqqqqqqq  ',$left-top)"/> -->
                <xsl:variable name="after-translated-left-top">
                    <xsl:call-template name="translate-left-top-condition">
                        <xsl:with-param name="left-top" select="$left-top"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($after-translated-left-top,':',style:map/@style:base-cell-address)"/>
            </xsl:element>
            <xsl:for-each select="style:map">
                <xsl:element name="表:条件">
                    <xsl:attribute name="uof:locID">s0019</xsl:attribute>
                    <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                    <xsl:variable name="conditiontext" select="@style:condition"/>
                    <xsl:attribute name="表:类型"><xsl:choose><xsl:when test="contains($conditiontext,'cell-content')">cell value</xsl:when><xsl:when test="contains($conditiontext,'is-true-formula')">formula</xsl:when><xsl:otherwise>条件字符串错误!</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:element name="表:操作码">
                        <xsl:attribute name="uof:locID">s0009</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="starts-with($conditiontext,'is-true-formula')">equal to</xsl:when>
                            <xsl:when test="starts-with($conditiontext,'cell-content()')">
                                <xsl:variable name="operatortext" select="substring-after($conditiontext,'cell-content()')"/>
                                <xsl:choose>
                                    <xsl:when test="starts-with($operatortext,'&lt;=')">less than or equal to</xsl:when>
                                    <xsl:when test="starts-with($operatortext,'&gt;=')">greater than or equal to</xsl:when>
                                    <xsl:when test="starts-with($operatortext,'&lt;')">less than</xsl:when>
                                    <xsl:when test="starts-with($operatortext,'&gt;')">greater than</xsl:when>
                                    <xsl:when test="starts-with($operatortext,'!=')">not equal to</xsl:when>
                                    <xsl:when test="starts-with($operatortext,'=')">equal to</xsl:when>
                                    <!-- 注意：uof有的另几种操作码在oo中没有，他们是contain,not contain,start with,not start with, end with,not end with-->
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="starts-with($conditiontext,'cell-content-is-between')">between</xsl:when>
                            <xsl:when test="starts-with($conditiontext,'cell-content-is-not-between')">not between</xsl:when>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:element name="表:第一操作数">
                        <xsl:attribute name="uof:locID">s0010</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="starts-with($conditiontext,'is-true-formula')">
                                <xsl:value-of select="substring(substring-after($conditiontext,'is-true-formula('),1,string-length($conditiontext)-1-string-length('is-true-formula('))"/>
                            </xsl:when>
                            <xsl:when test="starts-with($conditiontext,'cell-content-is-between')">
                                <xsl:value-of select="substring-before(substring-after($conditiontext,'cell-content-is-between('),',')"/>
                            </xsl:when>
                            <xsl:when test="starts-with($conditiontext,'cell-content-is-not-between')">
                                <xsl:value-of select="substring-before(substring-after($conditiontext,'cell-content-is-not-between('),',')"/>
                            </xsl:when>
                            <xsl:when test="starts-with($conditiontext,'cell-content()')">
                                <xsl:variable name="operatortext" select="substring-after($conditiontext,'cell-content()')"/>
                                <xsl:choose>
                                    <xsl:when test="starts-with($operatortext,'&lt;=')">
                                        <xsl:value-of select="substring-after($conditiontext,'&lt;=')"/>
                                    </xsl:when>
                                    <xsl:when test="starts-with($operatortext,'&gt;=')">
                                        <xsl:value-of select="substring-after($conditiontext,'&gt;=')"/>
                                    </xsl:when>
                                    <xsl:when test="starts-with($operatortext,'&lt;')">
                                        <xsl:value-of select="substring-after($conditiontext,'&lt;')"/>
                                    </xsl:when>
                                    <xsl:when test="starts-with($operatortext,'&gt;')">
                                        <xsl:value-of select="substring-after($conditiontext,'&gt;')"/>
                                    </xsl:when>
                                    <xsl:when test="starts-with($operatortext,'!=')">
                                        <xsl:value-of select="substring-after($conditiontext,'!=')"/>
                                    </xsl:when>
                                    <xsl:when test="starts-with($operatortext,'=')">
                                        <xsl:value-of select="substring-after($conditiontext,'=')"/>
                                    </xsl:when>
                                    <!-- 注意：uof有的另几种操作码在oo中没有，他们是contain,not contain,start with,not start with, end with,not end with-->
                                </xsl:choose>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:if test="starts-with($conditiontext,'cell-content-is-between') or starts-with($conditiontext,'cell-content-is-not-between')">
                        <xsl:element name="表:第二操作数">
                            <xsl:attribute name="uof:locID">s0011</xsl:attribute>
                            <xsl:value-of select="substring(substring-after($conditiontext,','),1,string-length(substring-after($conditiontext,','))-1)"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="表:格式">
                        <xsl:variable name="apply-style-name" select="@style:apply-style-name"/>
                        <xsl:attribute name="uof:locID">s0023</xsl:attribute>
                        <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                        <xsl:attribute name="表:式样引用"><xsl:value-of select="$apply-style-name"/></xsl:attribute>
                        <!--xsl:attribute name="表:式样引用"><xsl:value-of select="generate-id(//style:style[@style:name=$apply-style-name])"/></xsl:attribute-->
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template name="createcellnamelist">
        <xsl:param name="list"/>
        <xsl:choose>
            <xsl:when test="$list">
                <xsl:variable name="first" select="$list[1]"/>
                <xsl:variable name="stringlist-of-rest">
                    <xsl:call-template name="createcellnamelist">
                        <xsl:with-param name="list" select="$list[position()!=1]"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($first/@style:name,' ',$stringlist-of-rest)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="search-left-top">
        <xsl:param name="cellstylenamelist"/>
        <xsl:choose>
            <xsl:when test="$cellstylenamelist!=''">
                <xsl:variable name="first-cellstylename" select="substring-before($cellstylenamelist, ' ')"/>
                <xsl:variable name="tableslist" select="/office:document/office:body/office:spreadsheet/table:table"/>
                <xsl:variable name="first-left-top">
                    <xsl:call-template name="search-left-top-with-one-cellstyle">
                        <xsl:with-param name="cellstylename" select="$first-cellstylename"/>
                        <xsl:with-param name="tableslist" select="$tableslist"/>
                        <xsl:with-param name="return" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="rest-left-top">
                    <xsl:call-template name="search-left-top">
                        <xsl:with-param name="cellstylenamelist" select="substring-after($cellstylenamelist,' ')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="final-left-top">
                    <xsl:choose>
                        <xsl:when test="$rest-left-top =''">
                            <xsl:value-of select="$first-left-top"/>
                        </xsl:when>
                        <xsl:when test="$first-left-top =''">
                            <xsl:value-of select="$rest-left-top"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="after-compared-left-top">
                                <xsl:call-template name="compare-two-left-top">
                                    <xsl:with-param name="first" select="$first-left-top"/>
                                    <xsl:with-param name="second" select="$rest-left-top"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:value-of select="$after-compared-left-top"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="$final-left-top"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="translate-left-top-condition">
        <xsl:param name="left-top"/>
        <xsl:variable name="column-number" select="substring-before(substring-after($left-top,'.'),' ')"/>
        <xsl:variable name="column-number1">
            <xsl:value-of select="floor( $column-number div 26 )"/>
        </xsl:variable>
        <xsl:variable name="column-number2">
            <xsl:value-of select="$column-number mod 26"/>
        </xsl:variable>
        <xsl:variable name="column-character1">
            <xsl:call-template name="number-to-character">
                <xsl:with-param name="number" select="$column-number1"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="column-character2">
            <xsl:call-template name="number-to-character">
                <xsl:with-param name="number" select="$column-number2"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat(substring-before($left-top,'.'),'.',$column-character1,$column-character2,substring-after($left-top,' '))"/>
    </xsl:template>
    <xsl:template name="search-left-top-with-one-cellstyle">
        <xsl:param name="cellstylename"/>
        <xsl:param name="tableslist"/>
        <xsl:param name="return"/>
        <xsl:choose>
            <xsl:when test="$tableslist and $return=''">
                <xsl:variable name="firsttablerows" select="$tableslist[1]//table:table-row"/>
                <xsl:variable name="first-left-top">
                    <xsl:call-template name="search-left-top-with-one-cellstyle-inatable">
                        <xsl:with-param name="row-num" select="'1'"/>
                        <xsl:with-param name="firsttablerows" select="$firsttablerows"/>
                        <xsl:with-param name="cellstylename" select="$cellstylename"/>
                        <xsl:with-param name="return" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="rest-left-top">
                    <xsl:call-template name="search-left-top-with-one-cellstyle">
                        <xsl:with-param name="cellstylename" select="$cellstylename"/>
                        <xsl:with-param name="tableslist" select="$tableslist[position()!=1]"/>
                        <xsl:with-param name="return" select="$first-left-top"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$first-left-top!=''">
                        <xsl:value-of select="$first-left-top"/>
                    </xsl:when>
                    <xsl:when test="$rest-left-top!=''">
                        <xsl:value-of select="$rest-left-top"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$return"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="compare-two-left-top">
        <xsl:param name="first"/>
        <xsl:param name="second"/>
        <xsl:variable name="first-column" select="substring-before(substring-after($first,'.'),' ')"/>
        <xsl:variable name="first-row" select="substring-after($first,' ')"/>
        <xsl:variable name="second-column" select="substring-before(substring-after($second,'.'),' ')"/>
        <xsl:variable name="second-row" select="substring-after($second,' ')"/>
        <xsl:choose>
            <xsl:when test="$first-row&lt;$second-row">
                <xsl:value-of select="$first"/>
            </xsl:when>
            <xsl:when test="$first-row=$second-row">
                <xsl:choose>
                    <xsl:when test="$first-column&lt;=$second-column">
                        <xsl:value-of select="$first"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$second"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$second"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="search-left-top-with-one-cellstyle-inatable">
        <xsl:param name="row-num"/>
        <xsl:param name="firsttablerows"/>
        <xsl:param name="cellstylename"/>
        <xsl:param name="return"/>
        <xsl:choose>
            <xsl:when test="$firsttablerows and $return=''">
                <xsl:variable name="firstcells" select="$firsttablerows[1]/table:table-cell"/>
                <xsl:variable name="first-left-top">
                    <xsl:call-template name="search-left-top-with-one-cellstyle-inarow">
                        <xsl:with-param name="row-num" select="$row-num"/>
                        <xsl:with-param name="column-num" select="'1'"/>
                        <xsl:with-param name="firstcells" select="$firstcells"/>
                        <xsl:with-param name="cellstylename" select="$cellstylename"/>
                        <xsl:with-param name="return" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="row-num-p">
                    <xsl:choose>
                        <xsl:when test="$firsttablerows[1]/@table:number-rows-repeated">
                            <xsl:value-of select="$row-num+ $firsttablerows[1]/@table:number-rows-repeated"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$row-num+1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rest-left-top">
                    <xsl:call-template name="search-left-top-with-one-cellstyle-inatable">
                        <xsl:with-param name="row-num" select="$row-num-p"/>
                        <xsl:with-param name="firsttablerows" select="$firsttablerows[position()!=1]"/>
                        <xsl:with-param name="cellstylename" select="$cellstylename"/>
                        <xsl:with-param name="return" select="$first-left-top"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$first-left-top!=''">
                        <xsl:value-of select="$first-left-top"/>
                    </xsl:when>
                    <xsl:when test="$rest-left-top !=''">
                        <xsl:value-of select="$rest-left-top "/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$return"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="search-left-top-with-one-cellstyle-inarow">
        <xsl:param name="row-num"/>
        <xsl:param name="column-num"/>
        <xsl:param name="firstcells"/>
        <xsl:param name="cellstylename"/>
        <xsl:param name="return"/>
        <xsl:choose>
            <xsl:when test="$firstcells and $return=''">
                <xsl:variable name="firstcell" select="$firstcells[1]"/>
                <xsl:variable name="first-left-top">
                    <xsl:call-template name="search-left-top-with-one-cellstyle-inacell">
                        <xsl:with-param name="row-num" select="$row-num"/>
                        <xsl:with-param name="column-num" select="$column-num"/>
                        <xsl:with-param name="cell" select="$firstcell"/>
                        <xsl:with-param name="cellstylename" select="$cellstylename"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="column-num-p">
                    <xsl:choose>
                        <xsl:when test="$firstcell/@table:number-columns-repeated">
                            <xsl:value-of select="$column-num+ $firstcell/@table:number-columns-repeated"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$column-num+ 1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rest-left-top">
                    <xsl:call-template name="search-left-top-with-one-cellstyle-inarow">
                        <xsl:with-param name="row-num" select="$row-num"/>
                        <xsl:with-param name="column-num" select="$column-num-p"/>
                        <xsl:with-param name="firstcells" select="$firstcells[position()!=1]"/>
                        <xsl:with-param name="cellstylename" select="$cellstylename"/>
                        <xsl:with-param name="return" select="$first-left-top"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$first-left-top!=''">
                        <xsl:value-of select="$first-left-top"/>
                    </xsl:when>
                    <xsl:when test="$rest-left-top !=''">
                        <xsl:value-of select="$rest-left-top "/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$return"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="search-left-top-with-one-cellstyle-inacell">
        <xsl:param name="row-num"/>
        <xsl:param name="column-num"/>
        <xsl:param name="cell"/>
        <xsl:param name="cellstylename"/>
        <xsl:choose>
            <xsl:when test="$cell/@table:style-name">
                <xsl:if test="$cell/@table:style-name=$cellstylename">
                    <xsl:value-of select="concat($cell/ancestor::table:table/@table:name,'.',$column-num,' ',$row-num)"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="style-is-default">
                    <xsl:call-template name="is-default-or-not">
                        <xsl:with-param name="column-num" select="$column-num"/>
                        <xsl:with-param name="cell" select="$cell"/>
                        <xsl:with-param name="preceding-cellstylename" select="''"/>
                        <xsl:with-param name="temp-num" select="'0'"/>
                        <xsl:with-param name="cellstylename" select="$cellstylename"/>
                        <xsl:with-param name="table-columns" select="$cell/ancestor::table:table//table:table-column "/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$style-is-default='yes' ">
                        <xsl:value-of select="concat($cell/ancestor::table:table/@table:name,'.',$column-num,' ',$row-num)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="is-default-or-not">
        <xsl:param name="column-num"/>
        <xsl:param name="cell"/>
        <xsl:param name="preceding-cellstylename"/>
        <xsl:param name="temp-num"/>
        <xsl:param name="cellstylename"/>
        <xsl:param name="table-columns"/>
        <xsl:choose>
            <xsl:when test="$temp-num&lt;$column-num">
                <xsl:variable name="firstcolumn">
                    <xsl:choose>
                        <xsl:when test="$table-columns[1]/@table:number-columns-repeated">
                            <xsl:value-of select="$table-columns[1]/@table:number-columns-repeated"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'1'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="preceding-cellstylename-to-param">
                    <xsl:choose>
                        <xsl:when test="$table-columns[1]/@table:default-cell-style-name">
                            <xsl:value-of select="$table-columns[1]/@table:default-cell-style-name"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="''"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="is-default-or-not">
                    <xsl:with-param name="column-num" select="$column-num"/>
                    <xsl:with-param name="temp-num" select="$temp-num + $firstcolumn"/>
                    <xsl:with-param name="preceding-cellstylename" select="$preceding-cellstylename-to-param"/>
                    <xsl:with-param name="cellstylename" select="$cellstylename"/>
                    <xsl:with-param name="table-columns" select="$table-columns[position()!=1]"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$cellstylename=$preceding-cellstylename">
                        <xsl:value-of select="'yes'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'no'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="table:tracked-changes">
        <xsl:for-each select="/office:document/office:body/office:spreadsheet/table:tracked-changes">
            <xsl:if test="table:cell-content-change/table:cell-address">
                <xsl:variable name="row" select="table:cell-content-change/table:cell-address/@table:row"/>
                <xsl:variable name="column" select="table:cell-content-change/table:cell-address/@table:column"/>
                <xsl:element name="字:修订开始">
                    <xsl:attribute name="uof:locID">t0206</xsl:attribute>
                    <xsl:attribute name="uof:attrList">标识符 类型 修订信息引用</xsl:attribute>
                    <xsl:attribute name="字:标识符"><xsl:value-of select="concat($row,'-',$column)"/></xsl:attribute>
                    <xsl:attribute name="字:类型">format</xsl:attribute>
                    <xsl:if test="table:cell-content-change/office:change-info and table:cell-content-change/table:previous">
                        <xsl:variable name="creator" select="table:cell-content-change/office:change-info/dc:creator"/>
                        <xsl:variable name="date" select="table:cell-content-change/office:change-info/dc:date"/>
                        <xsl:variable name="text" select="table:cell-content-change/table:previous/table:change-track-table-cell/text:p"/>
                        <xsl:attribute name="字:修订信息引用"><xsl:value-of select="concat($creator,'+',$date,'%',$text)"/></xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="字:修订结束">
                    <xsl:attribute name="uof:locID">t0207</xsl:attribute>
                    <xsl:attribute name="uof:attrList">开始标识引用</xsl:attribute>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="office:font-face-decls">
        <uof:字体集 uof:locID="u0040">
            <xsl:for-each select="style:font-face">
                <xsl:element name="uof:字体声明">
                    <xsl:attribute name="uof:attrList">标识符 名称 字体族</xsl:attribute>
                    <xsl:attribute name="uof:locID">u0041</xsl:attribute>
                    <xsl:attribute name="uof:标识符"><xsl:value-of select="translate(@style:name,' ','_')"/></xsl:attribute>
                    <xsl:attribute name="uof:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                    <xsl:attribute name="uof:字体族"><xsl:value-of select="@svg:font-family"/></xsl:attribute>
                    <!-- added by glu, for process special fonts e.g. Marlett, -->
                    <!--chengxz 060821 delete uof:字符集,because there is no this attr-->
                    <!--xsl:if test="@style:font-charset= '02'">
                        <xsl:attribute name="uof:字符集">x-symbol</xsl:attribute>
                    </xsl:if-->
                    <!--xsl:if test="@style:font-family-generic">
                        <xsl:choose>
                            <xsl:when test="@style:font-family-generic = 'swiss'">
                                <xsl:attribute name="uof:字体族">Swiss</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@style:font-family-generic ='modern'">
                                <xsl:attribute name="uof:字体族">Modern</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@style:font-family-generic='roman'">
                                <xsl:attribute name="uof:字体族">Roman</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@style:font-family-generic ='script'">
                                <xsl:attribute name="uof:字体族">Script</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@style:font-family-generic ='decorative'">
                                <xsl:attribute name="uof:字体族">Decorative</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@style:font-family-generic ='system'">
                                <xsl:attribute name="uof:字体族">System</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="uof:字体族">System</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if-->
                    <!--xsl:if test="@style:font-pitch">
                        <xsl:attribute name="uof:字号">12</xsl:attribute>
                    </xsl:if-->
                </xsl:element>
            </xsl:for-each>
            <xsl:apply-templates select="style:font-face"/>
        </uof:字体集>
    </xsl:template>
    <xsl:key name="styles" match="/*/office:styles/style:style | /*/office:automatic-styles/style:style" use="@style:name"/>
    <xsl:template match="style:style" mode="styles">
        <xsl:param name="isAutomatic"/>
        <xsl:param name="styleName" select="@style:name"/>
        <xsl:choose>
            <xsl:when test="@style:family='text'">
                <xsl:element name="uof:句式样">
                    <xsl:attribute name="uof:locID">u0043</xsl:attribute>
                    <xsl:attribute name="uof:attrList">标识符 名称 类型 别名 基式样引用</xsl:attribute>
                    <xsl:attribute name="字:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
                    <xsl:attribute name="字:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                    <xsl:attribute name="字:类型">auto</xsl:attribute>
                    <xsl:call-template name="字:字体"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@style:family='paragraph'">
                <xsl:element name="uof:段落式样">
                    <xsl:attribute name="uof:locID">u0044</xsl:attribute>
                    <xsl:attribute name="uof:attrList">标识符 名称 类型 别名 基式样引用 后继式样引用</xsl:attribute>
                    <xsl:attribute name="字:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
                    <xsl:attribute name="字:类型">auto</xsl:attribute>
                    <xsl:attribute name="字:基式样引用"><xsl:value-of select="@style:parent-style-name"/></xsl:attribute>
                    <xsl:attribute name="字:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                </xsl:element>
                <xsl:if test="style:text-properties">
                    <xsl:element name="uof:句式样">
                        <xsl:attribute name="uof:locID">u0043</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符 名称 类型 别名 基式样引用</xsl:attribute>
                        <xsl:attribute name="字:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:attribute name="字:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:attribute name="字:类型">custum</xsl:attribute>
                        <xsl:attribute name="字:基式样引用"><xsl:value-of select="@style:parent-style-name"/></xsl:attribute>
                        <xsl:call-template name="字:字体"/>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="uof:单元格式样">
                    <xsl:attribute name="uof:locID">u0046</xsl:attribute>
                    <xsl:attribute name="uof:attrList">标识符 名称 类型</xsl:attribute>
                    <xsl:attribute name="表:标识符"><xsl:value-of select="$styleName"/></xsl:attribute>
                    <xsl:attribute name="表:类型"><xsl:choose><xsl:when test="ancestor::office:automatic-styles">auto</xsl:when><xsl:when test="ancestor::office:styles">custom</xsl:when><xsl:otherwise>default</xsl:otherwise></xsl:choose></xsl:attribute>
                    <!--xsl:attribute name="表:基式样引用"><xsl:value-of select="@style:parent-style-name"/></xsl:attribute-->
                    <xsl:choose>
                        <xsl:when test="style:map">
                            <xsl:attribute name="表:名称"><xsl:value-of select="style:map/@style:apply-style-name"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="表:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="not($isAutomatic)">
                        <xsl:choose>
                            <xsl:when test="$styleName='Default'">
                                <xsl:attribute name="表:名称"><xsl:value-of select="'Normal'"/></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="表:名称"><xsl:value-of select="$styleName"/></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <!--xsl:if test="@style:parent-style-name">
                        <xsl:attribute name="表:基式样引用"><xsl:value-of select="@style:parent-style-name"/></xsl:attribute>
                    </xsl:if-->
                    <!--chengxz change the order-->
                    <xsl:variable name="styleProperties" select="key('styles', $styleName)/*"/>
                    <xsl:call-template name="Font">
                        <xsl:with-param name="styleProperties" select="$styleProperties"/>
                    </xsl:call-template>
                    <xsl:call-template name="Alignment">
                        <xsl:with-param name="styleProperties" select="$styleProperties"/>
                    </xsl:call-template>
                    <!--chenjh changed 1103-->
                    <!--xsl:if test="/*/office:automatic-styles/style:style[@style:name=/*/office:body/table:table/table:table-row/table:table-cell/@table:style-name]/style:properties/@fo:border"-->
                    <xsl:if test="@style:data-style-name">
                        <!--RedOffice Comment from Zengjh:UOF0020 2006-04-26-->
                        <xsl:call-template name="NumberFormat">
                            <xsl:with-param name="temp-style" select="@style:data-style-name"/>
                        </xsl:call-template>
                        <!--RedOffice comment (Zengjh) end-->
                    </xsl:if>
                    <xsl:call-template name="Border">
                        <xsl:with-param name="styleProperties" select="$styleProperties"/>
                        <!--xsl:with-param name="styleProperties" select="/*/office:automatic-styles/style:style"/-->
                    </xsl:call-template>
                    <!--/xsl:if-->
                    <!--chenjh end 1103-->
                    <xsl:call-template name="Interior">
                        <xsl:with-param name="styleProperties" select="$styleProperties"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="字:字体">
        <xsl:element name="字:字体">
            <xsl:attribute name="uof:locID">t0088</xsl:attribute>
            <xsl:attribute name="uof:attrList">西文字体引用 中文字体引用 特殊字体引用 西文绘制 字号 相对字号 颜色</xsl:attribute>
            <xsl:if test="style:text-properties/@fo:font-size or style:text-properties/@fo:font-size-asian or style:text-properties/@style:font-size-asian or style:text-properties/@style:font-size">
                <xsl:attribute name="字:字号"><xsl:choose><xsl:when test="style:text-properties/@fo:font-size"><xsl:value-of select="substring-before(style:text-properties/@fo:font-size,'pt')"/></xsl:when><xsl:when test="style:text-properties/@fo:font-size-asian"><xsl:value-of select="substring-before(style:text-properties/@fo:font-size-asian,'pt')"/></xsl:when><xsl:when test="style:text-properties/@style:font-size-asian"><xsl:value-of select="substring-before(style:text-properties/@style:font-size-asian,'pt')"/></xsl:when><xsl:when test="style:text-properties/@style:font-size"><xsl:value-of select="substring-before(style:text-properties/@style:font-size,'pt')"/></xsl:when></xsl:choose></xsl:attribute>
            </xsl:if>
            <xsl:if test="style:text-properties/@style:font-name">
                <xsl:attribute name="字:西文字体引用"><xsl:value-of select="style:text-properties/@style:font-name"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="style:text-properties/@style:font-name-complex">
                <xsl:attribute name="字:中文字体引用"><xsl:value-of select="style:text-properties/@style:font-name-complex"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="style:text-properties/@fo:color">
                <xsl:attribute name="字:颜色"><xsl:value-of select="style:text-properties/@fo:color"/></xsl:attribute>
            </xsl:if>
        </xsl:element>
        <xsl:if test="style:text-properties/@fo:font-weight or style:text-properties/@style:font-weight-asian">
            <xsl:element name="字:粗体">
                <xsl:attribute name="uof:locID">t0089</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:text-properties/@style:font-weight-asian='bold' or style:text-properties/@fo:font-weight='bold'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@fo:font-style or style:text-properties/@style:font-style-asian">
            <xsl:element name="字:斜体">
                <xsl:attribute name="uof:locID">t0090</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:text-properties/@fo:font-style='italic' or style:text-properties/@style:font-style-asian='italic'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:text-line-through-style and not(style:text-properties/@style:text-line-through-style='none')">
            <xsl:element name="字:删除线">
                <xsl:attribute name="uof:locID">t0094</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                <xsl:attribute name="字:类型"><xsl:call-template name="uof:delete线型类型"/></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:text-underline-style">
            <xsl:element name="字:下划线">
                <xsl:attribute name="字:类型"><xsl:call-template name="uof:线型类型"/></xsl:attribute>
                <xsl:attribute name="uof:locID">t0095</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                <xsl:if test="style:text-properties/@style:text-underline-color">
                    <xsl:attribute name="字:颜色"><xsl:choose><xsl:when test="style:text-properties/@style:text-underline-color='font-color'">auto</xsl:when><xsl:otherwise><xsl:value-of select="style:text-properties/@style:text-underline-color"/></xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@fo:text-shadow">
            <xsl:element name="字:阴影">
                <xsl:attribute name="uof:locID">t0100</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:text-properties/@fo:text-shadow='none'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:text-position">
            <xsl:element name="字:位置">
                <xsl:attribute name="uof:locID">t0102</xsl:attribute>
                <xsl:value-of select="style:text-properties/@style:text-position"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <!--RedOffice Comment from Zengjh:UOF0020 2006-04-01 Based on Original-->
    <xsl:template name="NumberFormat">
        <xsl:param name="temp-style"/>
        <xsl:for-each select="(/*/office:styles/child::*[@style:name=$temp-style]) | (/*/office:automatic-styles/child::*[@style:name=$temp-style])">
            <表:数字格式 uof:locID="s0021" uof:attrList="分类名称 格式码">
                <xsl:attribute name="表:分类名称"><xsl:choose><xsl:when test="name(.)='number:currency-style'">currency</xsl:when><xsl:when test="name(.)='number:percentage-style'">percentage</xsl:when><xsl:when test="name(.)='number:date-style'">date</xsl:when><xsl:when test="name(.)='number:time-style'">time</xsl:when><xsl:when test="name(.)='number:boolean-style'">custom</xsl:when><xsl:when test="name(.)='number:text-style'">text</xsl:when><xsl:when test="name(.)='number:number-style'"><xsl:choose><xsl:when test="number:fraction">fraction</xsl:when><xsl:when test="number:scientific-number">scientific</xsl:when><xsl:otherwise>number</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>general</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="表:格式码"><xsl:call-template name="element-attribute"/><xsl:for-each select="style:map"><xsl:text>[</xsl:text><xsl:value-of select="@style:condition"/><xsl:text>]</xsl:text><xsl:variable name="apply-style" select="@style:apply-style-name"/><xsl:for-each select="../../child::*[@style:name=$apply-style]/*"><xsl:call-template name="general-number-format"/></xsl:for-each><xsl:text>;</xsl:text></xsl:for-each><xsl:for-each select="*[not(name(.)='style:map')]"><xsl:call-template name="general-number-format"/></xsl:for-each></xsl:attribute>
            </表:数字格式>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="general-number-format">
        <xsl:choose>
            <xsl:when test="name(.)='style:text-properties'">
                <xsl:call-template name="general-color-format"/>
            </xsl:when>
            <xsl:when test="name(.)='number:text'">&quot;<xsl:value-of select="text()"/>&quot;</xsl:when>
            <xsl:when test="name(.)='number:text-content' ">@</xsl:when>
            <xsl:when test="name(.)='number:boolean'">boolean</xsl:when>
            <xsl:when test="name(.)='number:currency-symbol'">
                <xsl:call-template name="general-currency-format"/>
            </xsl:when>
            <xsl:when test="name(.)='number:fraction' or name(.)='number:number' or name(.)='number:scientific-number'">
                <xsl:if test="@number:min-integer-digits and not(@number:grouping)">
                    <xsl:choose>
                        <xsl:when test="@number:min-integer-digits='0'">#</xsl:when>
                        <xsl:when test="@number:min-integer-digits='1'">0</xsl:when>
                        <xsl:when test="@number:min-integer-digits='2'">00</xsl:when>
                        <xsl:when test="@number:min-integer-digits='3'">000</xsl:when>
                        <xsl:when test="@number:min-integer-digits='4'">0000</xsl:when>
                        <xsl:when test="@number:min-integer-digits='5'">00000</xsl:when>
                        <xsl:when test="@number:min-integer-digits='6'">000000</xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@number:min-integer-digits and @number:grouping">
                    <xsl:choose>
                        <xsl:when test="@number:min-integer-digits='0'">#,###</xsl:when>
                        <xsl:when test="@number:min-integer-digits='1'">#,##0</xsl:when>
                        <xsl:when test="@number:min-integer-digits='2'">#,#00</xsl:when>
                        <xsl:when test="@number:min-integer-digits='3'">#,000</xsl:when>
                        <xsl:when test="@number:min-integer-digits='4'">##0,000</xsl:when>
                        <xsl:when test="@number:min-integer-digits='5'">#00,000</xsl:when>
                        <xsl:when test="@number:min-integer-digits='6'">#,000,000</xsl:when>
                        <xsl:when test="@number:min-integer-digits='7'">##0,000,000</xsl:when>
                        <xsl:when test="@number:min-integer-digits='8'">#,#00,000,000</xsl:when>
                        <xsl:otherwise>#,##0</xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@number:decimal-places and not(@number:decimal-replacement)">
                    <xsl:choose>
                        <xsl:when test="@number:decimal-places='0'"/>
                        <xsl:when test="@number:decimal-places='1'">.0</xsl:when>
                        <xsl:when test="@number:decimal-places='2'">.00</xsl:when>
                        <xsl:when test="@number:decimal-places='3'">.000</xsl:when>
                        <xsl:when test="@number:decimal-places='4'">.0000</xsl:when>
                        <xsl:when test="@number:decimal-places='5'">.00000</xsl:when>
                        <xsl:when test="@number:decimal-places='6'">.000000</xsl:when>
                        <xsl:otherwise>.00</xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@number:decimal-places and @number:decimal-replacement">
                    <xsl:choose>
                        <xsl:when test="@number:decimal-places='0'"/>
                        <xsl:when test="@number:decimal-places='1'">.#</xsl:when>
                        <xsl:when test="@number:decimal-places='2'">.##</xsl:when>
                        <xsl:when test="@number:decimal-places='3'">.###</xsl:when>
                        <xsl:when test="@number:decimal-places='4'">.####</xsl:when>
                        <xsl:when test="@number:decimal-places='5'">.#####</xsl:when>
                        <xsl:when test="@number:decimal-places='6'">.######</xsl:when>
                        <xsl:otherwise>.##</xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@number:display-factor">
                    <xsl:choose>
                        <xsl:when test="@number:display-factor='1000'">,</xsl:when>
                        <xsl:when test="@number:display-factor='1000000'">,,</xsl:when>
                        <xsl:when test="@number:display-factor='1000000000'">,,,</xsl:when>
                        <xsl:when test="@number:display-factor='1000000000000000'">,,,,</xsl:when>
                        <xsl:when test="@number:display-factor='1000000000000000000'">,,,,,</xsl:when>
                        <xsl:when test="@number:display-factor='1000000000000000000000'">,,,,,</xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@number:min-exponent-digits">
                    <xsl:choose>
                        <xsl:when test="@number:min-exponent-digits='1'">E+0</xsl:when>
                        <xsl:when test="@number:min-exponent-digits='2'">E+00</xsl:when>
                        <xsl:when test="@number:min-exponent-digits='3'">E+000</xsl:when>
                        <xsl:when test="@number:min-exponent-digits='4'">E+0000</xsl:when>
                        <xsl:when test="@number:min-exponent-digits='5'">E+00000</xsl:when>
                        <xsl:when test="@number:min-exponent-digits='6'">E+000000</xsl:when>
                        <xsl:otherwise>E+00</xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@number:min-numerator-digits">
                    <xsl:choose>
                        <xsl:when test="@number:min-numerator-digits='1' "> ?</xsl:when>
                        <xsl:when test="@number:min-numerator-digits='2' "> ??</xsl:when>
                        <xsl:when test="@number:min-numerator-digits='3' "> ???</xsl:when>
                        <xsl:when test="@number:min-numerator-digits='4' "> ????</xsl:when>
                        <xsl:when test="@number:min-numerator-digits='5' "> ?????</xsl:when>
                        <xsl:when test="@number:min-numerator-digits='6' "> ??????</xsl:when>
                        <xsl:otherwise> ???</xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@number:min-denominator-digits">
                    <xsl:choose>
                        <xsl:when test="@number:min-denominator-digits='1' ">/?</xsl:when>
                        <xsl:when test="@number:min-denominator-digits='2' ">/??</xsl:when>
                        <xsl:when test="@number:min-denominator-digits='3' ">/???</xsl:when>
                        <xsl:when test="@number:min-denominator-digits='4' ">/????</xsl:when>
                        <xsl:when test="@number:min-denominator-digits='5' ">/?????</xsl:when>
                        <xsl:when test="@number:min-denominator-digits='6' ">/??????</xsl:when>
                        <xsl:otherwise>/???</xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:when test="name(.)='number:year'">
                <xsl:choose>
                    <xsl:when test="@number:style='long'">YYYY</xsl:when>
                    <xsl:otherwise>YY</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="name(.)='number:month'">
                <xsl:choose>
                    <xsl:when test="@number:style='long' and @number:textual='true'">MMMM</xsl:when>
                    <xsl:when test="not(@number:style='long') and @number:textual='true'">MMM</xsl:when>
                    <xsl:when test="@number:style='long' and not(@number:textual)">MM</xsl:when>
                    <xsl:when test="not(@number:style='long') and not(@number:textual)">M</xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="name(.)='number:day'">
                <xsl:choose>
                    <xsl:when test="@number:style='long'">DD</xsl:when>
                    <xsl:otherwise>D</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="name(.)='number:day-of-week'">
                <xsl:choose>
                    <xsl:when test="@number:style='long'">NNNN</xsl:when>
                    <xsl:otherwise>NNN</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="name(.)='number:quarter'">
                <xsl:choose>
                    <xsl:when test="@number:style='long'">QQ</xsl:when>
                    <xsl:otherwise>Q</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="name(.)='number:hours'">
                <xsl:choose>
                    <xsl:when test="@number:style='long' and ../@number:truncate-on-overflow='false'">[HH]</xsl:when>
                    <xsl:when test="@number:style='long'">HH</xsl:when>
                    <xsl:otherwise>H</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="name(.)='number:minutes'">
                <xsl:choose>
                    <xsl:when test="@number:style='long'">MM</xsl:when>
                    <xsl:otherwise>M</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="name(.)='number:seconds'">
                <xsl:choose>
                    <xsl:when test="@number:style='long' and @number:decimal-places='2'">SS.00</xsl:when>
                    <xsl:when test="@number:style='long'">SS</xsl:when>
                    <xsl:otherwise>S</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="name(.)='number:am-pm'">AM/PM</xsl:when>
            <xsl:when test="name(.)='number:week-of-year'">
                <xsl:choose>
                    <xsl:when test="@number:style='long'">WW</xsl:when>
                    <xsl:otherwise>WW</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="general-color-format">
        <xsl:choose>
            <xsl:when test="@fo:color='#000000'">[Black]</xsl:when>
            <xsl:when test="@fo:color='#0000ff'">[Blue]</xsl:when>
            <xsl:when test="@fo:color='#00ffff'">[Cyan]</xsl:when>
            <xsl:when test="@fo:color='#00ff00'">[Green]</xsl:when>
            <xsl:when test="@fo:color='#ff00ff'">[Magenta]</xsl:when>
            <xsl:when test="@fo:color='#ff0000'">[Red]</xsl:when>
            <xsl:when test="@fo:color='#ffffff'">[White]</xsl:when>
            <xsl:when test="@fo:color='#ffff00'">[Yellow]</xsl:when>
            <xsl:otherwise>[Black]</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="general-currency-format">
        <xsl:choose>
            <xsl:when test="text()='￥' and @number:language='zh' and @number:country='CN'">[$￥-804]</xsl:when>
            <xsl:when test="text()='$' and @number:language='en' and @number:country='US'">[$$-409]</xsl:when>
            <xsl:when test="text()='$' and @number:language='es' and @number:country='AR'">[$$-2C0A]</xsl:when>
            <xsl:when test="text()='$' and @number:language='fr' and @number:country='CA'">[$$-C0C]</xsl:when>
            <xsl:when test="text()='CNY'">[$CNY]</xsl:when>
            <xsl:when test="text()='AFA'">[$AFA]</xsl:when>
            <xsl:when test="text()='CCC'">CCC</xsl:when>
            <xsl:otherwise>￥</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="element-attribute">
        <xsl:if test="@number:transliteration-format='一' and @number:transliteration-style='short'">[NatNum1]</xsl:if>
        <xsl:if test="@number:transliteration-format='一' and @number:transliteration-style='medium'">[NatNum7]</xsl:if>
        <xsl:if test="@number:transliteration-format='一' and @number:transliteration-style='long'">[NatNum4]</xsl:if>
        <xsl:if test="@number:transliteration-format='壹' and @number:transliteration-style='short'">[NatNum2]</xsl:if>
        <xsl:if test="@number:transliteration-format='壹' and @number:transliteration-style='medium'">[NatNum8]</xsl:if>
        <xsl:if test="@number:transliteration-format='壹' and @number:transliteration-style='long'">[NatNum5]</xsl:if>
        <xsl:if test="@number:transliteration-format='１' and @number:transliteration-style='short'">[NatNum3]</xsl:if>
        <xsl:if test="@number:transliteration-format='１' and @number:transliteration-style='medium'">[NatNum0]</xsl:if>
        <xsl:if test="@number:transliteration-format='１' and @number:transliteration-style='long'">[NatNum6]</xsl:if>
        <xsl:if test="@number:transliteration-format='1' and @number:transliteration-style='short'">[NatNum0]</xsl:if>
        <xsl:if test="@number:transliteration-format='1' and @number:transliteration-style='medium'">[NatNum0]</xsl:if>
        <xsl:if test="@number:transliteration-format='1' and @number:transliteration-style='long'">[NatNum0]</xsl:if>
        <xsl:if test="@number:transliteration-language='zh' and @number:transliteration-country='CN'">[$-804]</xsl:if>
    </xsl:template>
    <!--RedOffice comment (Zengjh) end-->
    <!--huangzf0715-->
    <xsl:template name="Alignment">
        <xsl:param name="styleProperties"/>
        <xsl:if test="($styleProperties/@fo:text-align) or ($styleProperties/@style:vertical-align) or ($styleProperties/@fo:wrap-option) or($styleProperties/@fo:margin-left) or ($styleProperties/@style:rotation-angle) or ($styleProperties/@style:direction)">
            <xsl:element name="表:对齐格式">
                <xsl:attribute name="uof:locID">s0114</xsl:attribute>
                <xsl:if test="$styleProperties/@fo:margin-left">
                    <xsl:attribute name="表:缩进"><xsl:variable name="margin"><xsl:call-template name="convert2pt"><xsl:with-param name="value" select="$styleProperties/@fo:margin-left"/><xsl:with-param name="rounding-factor" select="1"/></xsl:call-template></xsl:variable><xsl:value-of select="number($margin) div 10"/></xsl:attribute>
                </xsl:if>
                <xsl:element name="表:水平对齐方式">
                    <xsl:attribute name="uof:locID">s0115</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$styleProperties/@fo:text-align">
                            <xsl:choose>
                                <xsl:when test="$styleProperties/@fo:text-align = 'center'">center</xsl:when>
                                <xsl:when test="$styleProperties/@fo:text-align = 'end'">right</xsl:when>
                                <xsl:when test="$styleProperties/@fo:text-align = 'justify'">justify</xsl:when>
                                <xsl:when test="$styleProperties/@fo:text-align = 'start'">left</xsl:when>
                                <xsl:otherwise>fill</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>general</xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:if test="($styleProperties/@style:vertical-align) or ($styleProperties/@fo:vertical-align)">
                    <xsl:element name="表:垂直对齐方式">
                        <xsl:attribute name="uof:locID">s0116</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$styleProperties/@fo:vertical-align = 'top'">top</xsl:when>
                            <xsl:when test="$styleProperties/@fo:vertical-align = 'bottom'">bottom</xsl:when>
                            <xsl:when test="$styleProperties/@fo:vertical-align = 'middle'">center</xsl:when>
                            <xsl:when test="$styleProperties/@fo:vertical-align = 'justify'">justify</xsl:when>
                            <xsl:when test="$styleProperties/@fo:vertical-align = 'top'">top</xsl:when>
                            <xsl:otherwise>distributed</xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="表:文字方向">
                    <xsl:attribute name="uof:locID">s0118</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$styleProperties/@style:direction = 'ttb'">vertical</xsl:when>
                        <xsl:otherwise>horizontal</xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:if test="$styleProperties/@style:rotation-angle">
                    <xsl:element name="表:文字旋转角度">
                        <xsl:attribute name="uof:locID">s0119</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$styleProperties/@style:rotation-angle &gt; 90">
                                <xsl:choose>
                                    <xsl:when test="$styleProperties/@style:rotation-angle &gt;= 270">
                                        <xsl:value-of select="$styleProperties/@style:rotation-angle - 360"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$styleProperties/@style:rotation-angle - 180"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="$styleProperties/@style:rotation-angle &lt; -90">
                                <xsl:choose>
                                    <xsl:when test="$styleProperties/@style:rotation-angle &lt;= -270">
                                        <xsl:value-of select="$styleProperties/@style:rotation-angle + 360"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$styleProperties/@style:rotation-angle + 180"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$styleProperties/@style:rotation-angle"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$styleProperties/@fo:wrap-option = 'wrap'">
                    <xsl:element name="表:自动换行">
                        <xsl:attribute name="uof:locID">s0120</xsl:attribute>
                        <xsl:attribute name="uof:attrList">值</xsl:attribute>
                        <xsl:attribute name="表:值">true</xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:shrink-to-fit">
                    <xsl:element name="表:缩小字体填充">
                        <xsl:attribute name="uof:locID">s0121</xsl:attribute>
                        <xsl:attribute name="uof:attrList">值</xsl:attribute>
                        <xsl:attribute name="表:值"><xsl:value-of select="$styleProperties/@style:shrink-to-fit"/></xsl:attribute>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="Font">
        <xsl:param name="styleProperties"/>
        <!--xsl:if test="(style:text-properties/@fo:font-weight) or (style:text-properties/@fo:color) or ($styleProperties/@style:font-name) or ($styleProperties/@fo:font-style) or ($styleProperties/@style:text-outline) or ($styleProperties/@style:text-shadow) or ($styleProperties/@style:font-size) or ($styleProperties/@style:text-crossing-out) or ($styleProperties/@style:text-underline) or ($styleProperties/@style:text-underline-style) or ($styleProperties/@style:text-position)"-->
        <xsl:if test="not(@style:name='Default')">
            <xsl:element name="表:字体格式">
                <xsl:attribute name="uof:locID">s0113</xsl:attribute>
                <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                <xsl:if test="$styleProperties/@fo:font-weight or $styleProperties/@style:font-weight-asian">
                    <xsl:element name="字:粗体">
                        <xsl:attribute name="字:值"><xsl:choose><xsl:when test="$styleProperties/@style:font-weight-asian='bold' or $styleProperties/@fo:font-weight='bold'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:locID">t0089</xsl:attribute>
                        <xsl:attribute name="uof:attrList">值</xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$styleProperties/@fo:font-style or $styleProperties/@style:font-style-asian">
                    <xsl:element name="字:斜体">
                        <xsl:attribute name="字:值"><xsl:choose><xsl:when test="$styleProperties/@fo:font-style='italic' or $styleProperties/@style:font-style-asian='italic'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:locID">t0090</xsl:attribute>
                        <xsl:attribute name="uof:attrList">值</xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:text-outline = 'true'">
                    <字:空心 uof:locID="t0098" uof:attrList="值" 字:值="true"/>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:text-shadow = 'shadow'">
                    <字:阴影 uof:locID="t0100" uof:attrList="值" 字:值="true"/>
                </xsl:if>
                <xsl:if test="(style:text-properties/@style:text-underline-style) and ($styleProperties/@style:text-underline-style != 'none')">
                    <xsl:element name="字:下划线">
                        <xsl:attribute name="uof:locID">t0095</xsl:attribute>
                        <xsl:attribute name="uof:attrList">类型 颜色 字下划线</xsl:attribute>
                        <xsl:attribute name="字:类型"><xsl:call-template name="uof:线型类型"/></xsl:attribute>
                        <xsl:attribute name="字:字下划线">true</xsl:attribute>
                        <xsl:if test="$styleProperties/@style:text-underline-color">
                            <xsl:attribute name="字:颜色"><xsl:choose><xsl:when test="$styleProperties/@style:text-underline-color='font-color'">auto</xsl:when><xsl:otherwise><xsl:value-of select="$styleProperties/@style:text-underline-color"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:text-line-through-style and not($styleProperties/@style:text-line-through-style='none')">
                    <xsl:element name="字:删除线">
                        <xsl:attribute name="uof:locID">t0094</xsl:attribute>
                        <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                        <xsl:attribute name="字:类型"><xsl:call-template name="uof:delete线型类型"/></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:text-emphasize">
                    <xsl:element name="字:着重号">
                        <xsl:attribute name="uof:locID">t0096</xsl:attribute>
                        <xsl:attribute name="uof:attrList">类型 颜色 字着重号</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$styleProperties/@style:text-emphasize='none'">
                                <xsl:attribute name="字:字着重号">false</xsl:attribute>
                                <xsl:attribute name="字:类型">none</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="字:字着重号">true</xsl:attribute>
                                <xsl:attribute name="字:类型"><xsl:call-template name="uof:着重号类型"><xsl:with-param name="te" select="$styleProperties/@style:text-emphasize"/></xsl:call-template></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="$styleProperties/@fo:color">
                            <xsl:attribute name="字:颜色"><xsl:value-of select="$styleProperties/@fo:color"/></xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$styleProperties/@style:text-position">
                    <xsl:element name="字:上下标">
                        <xsl:choose>
                            <xsl:when test="substring-before($styleProperties/@style:text-position, '% ') &gt; 0">
                                <xsl:attribute name="字:上下标">sup</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="字:上下标">sub</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="字:字体">
                    <xsl:attribute name="uof:locID">t0088</xsl:attribute>
                    <xsl:attribute name="uof:attrList">西文字体引用 中文字体引用 特殊字体引用 西文绘制 字号 相对字号 颜色</xsl:attribute>
                    <xsl:if test="$styleProperties/@style:font-name-asian">
                        <xsl:attribute name="字:中文字体引用"><xsl:value-of select="translate($styleProperties/@style:font-name-asian,' ','_')"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$styleProperties/@style:font-name or $styleProperties/@fo:font-family">
                        <xsl:choose>
                            <xsl:when test="$styleProperties/@style:font-name">
                                <xsl:attribute name="字:西文字体引用"><xsl:value-of select="translate($styleProperties/@style:font-name,' ','_')"/></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="字:西文字体引用"><xsl:value-of select="translate($styleProperties/@fo:font-family,' ','_')"/></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="$styleProperties/@fo:color">
                        <xsl:attribute name="字:颜色"><xsl:value-of select="$styleProperties/@fo:color"/></xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="$styleProperties/@fo:font-size">
                            <xsl:attribute name="字:字号"><xsl:call-template name="convert2pt"><xsl:with-param name="value" select="$styleProperties/@fo:font-size"/></xsl:call-template></xsl:attribute>
                        </xsl:when>
                        <xsl:when test="$styleProperties/@style:font-size-asian">
                            <xsl:attribute name="字:字号"><xsl:call-template name="convert2pt"><xsl:with-param name="value" select="$styleProperties/@style:font-size-asian"/></xsl:call-template></xsl:attribute>
                        </xsl:when>
                        <xsl:when test="$styleProperties/@style:font-size-complex">
                            <xsl:attribute name="字:字号"><xsl:call-template name="convert2pt"><xsl:with-param name="value" select="$styleProperties/@style:font-size-complex"/></xsl:call-template></xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </xsl:element>
                <xsl:if test="style:text-properties/@style:font-relief">
                    <xsl:element name="字:浮雕">
                        <xsl:attribute name="uof:locID">t0099</xsl:attribute>
                        <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                        <xsl:attribute name="字:类型"><xsl:choose><xsl:when test="style:text-properties/@style:font-relief='embossed'">emboss</xsl:when><xsl:when test="style:text-properties/@style:font-relief='engraved'">engrave</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="style:text-properties/@fo:text-transform or style:text-properties/@fo:font-variant">
                    <xsl:element name="字:醒目字体">
                        <xsl:attribute name="uof:locID">t0101</xsl:attribute>
                        <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                        <xsl:attribute name="字:类型"><xsl:choose><xsl:when test="style:text-properties/@fo:text-transform='uppercase'">uppercase</xsl:when><xsl:when test="style:text-properties/@fo:text-transform='lowercase'">lowercase</xsl:when><xsl:when test="style:text-properties/@fo:text-transform='capitalize'">capital</xsl:when><xsl:when test="style:text-properties/@fo:font-variant='small-caps'">small-caps</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="style:text-properties/@fo:text-shadow">
                    <xsl:element name="字:阴影">
                        <xsl:attribute name="uof:locID">t0100</xsl:attribute>
                        <xsl:attribute name="uof:attrList">值</xsl:attribute>
                        <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:text-properties/@fo:text-shadow='none'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="Border">
        <xsl:param name="styleProperties"/>
        <xsl:if test="style:table-cell-properties/@fo:border and not($styleProperties/@fo:border-top or $styleProperties/@fo:border-left or $styleProperties/@fo:border-bottom or $styleProperties/@fo:border-right)">
            <xsl:element name="表:边框">
                <xsl:attribute name="uof:locID">s0022</xsl:attribute>
                <xsl:variable name="border">
                    <xsl:value-of select="$styleProperties/@fo:border"/>
                </xsl:variable>
                <xsl:element name="uof:左">
                    <xsl:attribute name="uof:locID">u0057</xsl:attribute>
                    <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
                    <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border!='none'"><xsl:choose><xsl:when test="substring-before(substring-after($border,' '),' ')='solid'">single</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='double'">double</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dotted'">dotted</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dashed'">dash</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:if test="$border!='none'">
                        <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(substring-before($border,' '),$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="uof:颜色"><xsl:value-of select="substring-after(substring-after($border,' '),' ')"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="contains(substring-before(substring-after($styleProperties/@style:shadow,' '),' '),'-')">
                        <xsl:attribute name="uof:阴影">true</xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="uof:上">
                    <xsl:attribute name="uof:locID">u0058</xsl:attribute>
                    <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
                    <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border!='none'"><xsl:choose><xsl:when test="substring-before(substring-after($border,' '),' ')='solid'">single</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='double'">double</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dotted'">dotted</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dashed'">dash</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:if test="$border!='none'">
                        <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(substring-before($border,' '),$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="uof:颜色"><xsl:value-of select="substring-after(substring-after($border,' '),' ')"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="contains(substring-after(substring-after($styleProperties/@style:shadow,' '),' '),'-')">
                        <xsl:attribute name="uof:阴影">true</xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="uof:右">
                    <xsl:attribute name="uof:locID">u0059</xsl:attribute>
                    <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
                    <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border!='none'"><xsl:choose><xsl:when test="substring-before(substring-after($border,' '),' ')='solid'">single</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='double'">double</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dotted'">dotted</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dashed'">dash</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:if test="$border!='none'">
                        <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(substring-before($border,' '),$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="uof:颜色"><xsl:value-of select="substring-after(substring-after($border,' '),' ')"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="substring-before(substring-before(substring-after($styleProperties/@style:shadow,' '),' '),$uofUnit) &gt;0 or contains(substring-before(substring-after($styleProperties/@style:shadow,' '),' '),'+')">
                        <xsl:attribute name="uof:阴影">true</xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="uof:下">
                    <xsl:attribute name="uof:locID">u0060</xsl:attribute>
                    <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
                    <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border!='none'"><xsl:choose><xsl:when test="substring-before(substring-after($border,' '),' ')='solid'">single</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='double'">double</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dotted'">dotted</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dashed'">dash</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:if test="$border!='none'">
                        <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(substring-before($border,' '),$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="uof:颜色"><xsl:value-of select="substring-after(substring-after($border,' '),' ')"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="substring-before(substring-after(substring-after($styleProperties/@style:shadow,' '),' '),$uofUnit) &gt;0 or contains(substring-after(substring-after($styleProperties/@style:shadow,' '),' '),'+')">
                        <xsl:attribute name="uof:阴影">true</xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:if test="$styleProperties/@style:diagonal-bl-tr">
                    <xsl:element name="uof:对角线1">
                        <xsl:attribute name="uof:locID">u0061</xsl:attribute>
                        <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
                        <xsl:variable name="border-width">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="substring-before($styleProperties/@style:diagonal-bl-tr, ' ')"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="border-style" select="substring-before(substring-after($styleProperties/@style:diagonal-bl-tr, ' '), ' ')"/>
                        <xsl:variable name="border-color" select="substring-after(substring-after($styleProperties/@style:diagonal-bl-tr, ' '), ' ')"/>
                        <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border-style = 'none'">none</xsl:when><xsl:when test="$border-style = 'none'">none</xsl:when><xsl:when test="$border-style='solid'">single</xsl:when><xsl:when test="$border-style='double'">double</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:宽度"><xsl:value-of select="$border-width"/></xsl:attribute>
                        <xsl:attribute name="uof:颜色"><xsl:choose><xsl:when test="$border-color"><xsl:value-of select="$border-color"/></xsl:when><xsl:otherwise>Automatic</xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <!--end of uo:对角线1-->
                <!--xsl:if test="$styleProperties/@fo:border and $styleProperties/@style:diagonal-tl-br"-->
                <xsl:if test="$styleProperties/@style:diagonal-tl-br">
                    <xsl:element name="uof:对角线2">
                        <xsl:attribute name="uof:locID">u0062</xsl:attribute>
                        <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
                        <xsl:variable name="border-width">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="substring-before($styleProperties/@style:diagonal-tl-br, ' ')"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="border-style" select="substring-before(substring-after($styleProperties/@style:diagonal-tl-br, ' '), ' ')"/>
                        <xsl:variable name="border-color" select="substring-after(substring-after($styleProperties/@style:diagonal-tl-br, ' '), ' ')"/>
                        <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border-style = 'none'">none</xsl:when><xsl:when test="$border-style = 'none'">none</xsl:when><xsl:when test="$border-style='solid'">single</xsl:when><xsl:when test="$border-style='double'">double</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:宽度"><xsl:value-of select="$border-width"/></xsl:attribute>
                        <xsl:attribute name="uof:颜色"><xsl:choose><xsl:when test="$border-color"><xsl:value-of select="$border-color"/></xsl:when><xsl:otherwise>Automatic</xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <!--end of uo:对角线2-->
            </xsl:element>
        </xsl:if>
        <!--end of fo:border-->
        <xsl:if test="$styleProperties/@fo:border-top or $styleProperties/@fo:border-left or $styleProperties/@fo:border-bottom or $styleProperties/@fo:border-right or $styleProperties/@style:diagonal-tl-br or $styleProperties/@style:diagonal-bl-tr">
            <xsl:element name="表:边框">
                <xsl:attribute name="uof:locID">s0022</xsl:attribute>
                <xsl:if test="$styleProperties/@fo:border-left or $styleProperties/@style:shadow">
                    <xsl:element name="uof:左">
                        <xsl:attribute name="uof:locID">u0057</xsl:attribute>
                        <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
                        <xsl:variable name="borderleft">
                            <xsl:value-of select="$styleProperties/@fo:border-left"/>
                        </xsl:variable>
                        <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$borderleft!='none'"><xsl:choose><xsl:when test="substring-before(substring-after($borderleft,' '),' ')='solid'">single</xsl:when><xsl:when test="substring-before(substring-after($borderleft,' '),' ')='double'">double</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:if test="$borderleft!='none'">
                            <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(substring-before($borderleft,' '),$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="uof:颜色"><xsl:value-of select="substring-after(substring-after($borderleft,' '),' ')"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="contains(substring-before(substring-after($styleProperties/@style:shadow,' '),' '),'-')">
                            <xsl:attribute name="uof:阴影">true</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <!--end of uof:左-->
                <xsl:if test="$styleProperties/@fo:border-top or $styleProperties/@style:shadow">
                    <xsl:element name="uof:上">
                        <xsl:attribute name="uof:locID">u0058</xsl:attribute>
                        <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
                        <xsl:variable name="bordertop">
                            <xsl:value-of select="$styleProperties/@fo:border-top"/>
                        </xsl:variable>
                        <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$bordertop!='none'"><xsl:choose><xsl:when test="substring-before(substring-after($bordertop,' '),' ')='solid'">single</xsl:when><xsl:when test="substring-before(substring-after($bordertop,' '),' ')='double'">double</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:if test="$bordertop!='none'">
                            <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(substring-before($bordertop,' '),$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="uof:颜色"><xsl:value-of select="substring-after(substring-after($bordertop,' '),' ')"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="contains(substring-after(substring-after($styleProperties/@style:shadow,' '),' '),'-')">
                            <xsl:attribute name="uof:阴影">true</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <!--end of uof:上-->
                <xsl:if test="$styleProperties/@fo:border-right or $styleProperties/@style:shadow">
                    <xsl:element name="uof:右">
                        <xsl:attribute name="uof:locID">u0059</xsl:attribute>
                        <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
                        <xsl:variable name="borderright">
                            <xsl:value-of select="$styleProperties/@fo:border-right"/>
                        </xsl:variable>
                        <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$borderright!='none'"><xsl:choose><xsl:when test="substring-before(substring-after($borderright,' '),' ')='solid'">single</xsl:when><xsl:when test="substring-before(substring-after($borderright,' '),' ')='double'">double</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:if test="$borderright!='none'">
                            <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(substring-before($borderright,' '),$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="uof:颜色"><xsl:value-of select="substring-after(substring-after($borderright,' '),' ')"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="substring-before(substring-before(substring-after($styleProperties/@style:shadow,' '),' '),$uofUnit)&gt;0 or contains(substring-before(substring-after($styleProperties/@style:shadow,' '),' '),'+')">
                            <xsl:attribute name="uof:阴影">true</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <!--end of uof:右-->
                <xsl:if test="$styleProperties/@fo:border-bottom or $styleProperties/@style:shadow">
                    <xsl:element name="uof:下">
                        <xsl:attribute name="uof:locID">u0060</xsl:attribute>
                        <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
                        <xsl:variable name="borderbottom">
                            <xsl:value-of select="$styleProperties/@fo:border-bottom"/>
                        </xsl:variable>
                        <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$borderbottom!='none'"><xsl:choose><xsl:when test="substring-before(substring-after($borderbottom,' '),' ')='solid'">single</xsl:when><xsl:when test="substring-before(substring-after($borderbottom,' '),' ')='double'">double</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:if test="$borderbottom!='none'">
                            <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(substring-before($borderbottom,' '),$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="uof:颜色"><xsl:value-of select="substring-after(substring-after($borderbottom,' '),' ')"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="substring-before(substring-after(substring-after($styleProperties/@style:shadow,' '),' '),$uofUnit) &gt;0 or contains(substring-after(substring-after($styleProperties/@style:shadow,' '),' '),'+')">
                            <xsl:attribute name="uof:阴影">true</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <!--end of uof:下-->
                <xsl:if test="$styleProperties/@style:diagonal-bl-tr">
                    <xsl:element name="uof:对角线1">
                        <xsl:attribute name="uof:locID">u0061</xsl:attribute>
                        <xsl:attribute name="attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
                        <xsl:variable name="border-width">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="substring-before($styleProperties/@style:diagonal-bl-tr, ' ')"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="border-style" select="substring-before(substring-after($styleProperties/@style:diagonal-bl-tr, ' '), ' ')"/>
                        <xsl:variable name="border-color" select="substring-after(substring-after($styleProperties/@style:diagonal-bl-tr, ' '), ' ')"/>
                        <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border-style = 'none'">none</xsl:when><xsl:when test="$border-style='solid'">single</xsl:when><xsl:when test="$border-style='double'">double</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:宽度"><xsl:value-of select="$border-width"/></xsl:attribute>
                        <xsl:attribute name="uof:颜色"><xsl:choose><xsl:when test="$border-color"><xsl:value-of select="$border-color"/></xsl:when><xsl:otherwise>Automatic</xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <!--end of uo:对角线1-->
                <xsl:if test="$styleProperties/@style:diagonal-tl-br">
                    <xsl:element name="uof:对角线2">
                        <xsl:attribute name="uof:locID">u0062</xsl:attribute>
                        <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
                        <xsl:variable name="border-width">
                            <xsl:call-template name="convert2cm">
                                <xsl:with-param name="value" select="substring-before($styleProperties/@style:diagonal-tl-br, ' ')"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="border-style" select="substring-before(substring-after($styleProperties/@style:diagonal-tl-br, ' '), ' ')"/>
                        <xsl:variable name="border-color" select="substring-after(substring-after($styleProperties/@style:diagonal-tl-br, ' '), ' ')"/>
                        <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border-style = 'none'">none</xsl:when><xsl:when test="$border-style='solid'">single</xsl:when><xsl:when test="$border-style='double'">double</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="uof:宽度"><xsl:value-of select="$border-width"/></xsl:attribute>
                        <xsl:attribute name="uof:颜色"><xsl:choose><xsl:when test="$border-color"><xsl:value-of select="$border-color"/></xsl:when><xsl:otherwise>Automatic</xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <!--end of uo:对角线2-->
            </xsl:element>
            <!--end of 表:边框-->
        </xsl:if>
        <!--chenjh 边框   E -->
    </xsl:template>
    <xsl:template name="border-attributes">
        <xsl:param name="border_properties"/>
        <xsl:attribute name="attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
        <xsl:variable name="border-width">
            <xsl:call-template name="convert2cm">
                <xsl:with-param name="value" select="substring-before($border_properties, ' ')"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="border-style" select="substring-before(substring-after($border_properties, ' '), ' ')"/>
        <xsl:variable name="border-color" select="substring-after(substring-after($border_properties, ' '), ' ')"/>
        <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border-style = 'none'">none</xsl:when><xsl:otherwise><xsl:value-of select="$border-style"/></xsl:otherwise></xsl:choose></xsl:attribute>
        <xsl:attribute name="uof:宽度"><xsl:value-of select="$border-width"/></xsl:attribute>
        <xsl:attribute name="uof:颜色"><xsl:choose><xsl:when test="$border-color"><xsl:value-of select="$border-color"/></xsl:when><xsl:otherwise>Automatic</xsl:otherwise></xsl:choose></xsl:attribute>
    </xsl:template>
    <xsl:template name="Interior">
        <xsl:param name="styleProperties"/>
        <xsl:if test="style:table-cell-properties/@fo:background-color and not($styleProperties/@fo:background-color = 'transparent')">
            <xsl:element name="表:填充">
                <!--chenp modify redo0000047-->
                <xsl:attribute name="uof:locID">s0058</xsl:attribute>
                <!--0821 by lil -->
                <xsl:choose>
                    <xsl:when test="$styleProperties/@fo:background-color">
                        <xsl:element name="图:颜色">
                            <xsl:attribute name="uof:locID">g0034</xsl:attribute>
                            <xsl:value-of select="$styleProperties/@fo:background-color"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="表:图案">
                            <xsl:value-of select="' Solid'"/>
                            <xsl:attribute name="xsl:lodID">g0036</xsl:attribute>
                            <xsl:attribute name="attrList">类型 图形引用 前景色 背景色</xsl:attribute>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
                <!--end-->
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <!--chengxz 0621 E-->
    <!--xsl:template name="image">

            <xsl:element name="图:图形">
                <xsl:attribute name="图:标识符"><xsl:value-of select="@draw:name"/></xsl:attribute>
                <xsl:attribute name="uof:locID">g0000</xsl:attribute>
                <xsl:attribute name="uof:attrList">层次 标识符 组合列表 其他对象</xsl:attribute>
                <xsl:element name="图:预定义图形">
                    <xsl:attribute name="uof:locID">g0005</xsl:attribute>
                    <xsl:element name="图:类别">图片</xsl:element>
                    <xsl:element name="图:生成软件"><xsl:value-of select="office:binary-data" ></xsl:value-of></xsl:element>
                    <xsl:element name="图:属性">
                        <xsl:element name="图:宽度"><xsl:value-of select="substring-before(@svg:width,'cm')"/></xsl:element>
                        <xsl:element name="图:高度"><xsl:value-of select="substring-before(@svg:height,'cm')"/></xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:template-->
    <!--1新增内容-->
    <xsl:key match="/office:document/office:automatic-styles/style:style | /office:document/office:styles/style:style" name="graphicset" use="@style:name"/>
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
                <xsl:call-template name="creategraphicstyles"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="draw:g">
        <!--xsl:variable name="picnumber1">
            <xsl:value-of select="count(preceding::draw:g)"/>
        </xsl:variable>
        <图:图形 uof:locID="g0000" uof:attrList="层次 标识符 组合列表 其他对象">
            <xsl:attribute name="图:标识符"><xsl:value-of select="concat(@draw:style-name,'_',$picnumber1)"/></xsl:attribute>
            <xsl:attribute name="图:层次"><xsl:value-of select="@draw:z-index"/></xsl:attribute>
            <xsl:attribute name="图:组合列表"><xsl:for-each select="child::*[1]"><xsl:variable name="node1"><xsl:value-of select="@draw:style-name"/></xsl:variable><xsl:variable name="picnumber2"><xsl:value-of select="count(preceding::*[@draw:style-name=$node1])"/></xsl:variable><xsl:call-template name="zuheliebiao"><xsl:with-param name="allnode"><xsl:value-of select="concat($node1,'_',$picnumber2)"/></xsl:with-param><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:for-each></xsl:attribute>
        </图:图形>
        <xsl:for-each select="child::*">
            <xsl:choose>
                <xsl:when test="name()='draw:g'">
                    <xsl:call-template name="draw:g"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="creategraphicstyles"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-->
        <!--根据新修改的Schema做的修改-->
        <xsl:for-each select="child::*">
            <xsl:choose>
                <xsl:when test="name()='draw:g'">
                    <xsl:call-template name="draw:g"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="creategraphicstyles"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:call-template name="creategraphicstyles"/>
    </xsl:template>
    <xsl:template name="zuheliebiao">
        <xsl:param name="allnode"/>
        <xsl:param name="pos"/>
        <xsl:choose>
            <xsl:when test="../child::*[$pos]">
                <xsl:for-each select="../child::*[$pos]">
                    <xsl:variable name="nodepos">
                        <!--add by lvxg  -->
                        <xsl:choose>
                            <xsl:when test="./@draw:style-name">
                                <xsl:value-of select="@draw:style-name"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@draw:id"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--end-->
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
    <xsl:template name="creategraphicstyles">
        <xsl:variable name="nodename">
            <xsl:value-of select="name()"/>
        </xsl:variable>
        <xsl:variable name="pic-name">
            <xsl:choose>
                <xsl:when test="./@draw:style-name">
                    <xsl:value-of select="@draw:style-name"/>
                </xsl:when>
                <xsl:when test="./@table:end-cell-address">
                    <xsl:value-of select="@table:end-cell-address"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="./@draw:id"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--end -->
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
    </xsl:template>
    <xsl:template name="pic-process">
        <xsl:param name="pic-name"/>
        <xsl:param name="nodename"/>
        <xsl:param name="picnumber"/>
        <xsl:variable name="aa">
            <xsl:choose>
                <xsl:when test="./@draw:style-name">
                    <xsl:value-of select="@draw:style-name"/>
                </xsl:when>
                <xsl:when test="./@table:end-cell-address">
                    <xsl:value-of select="@table:end-cell-address"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="./@draw:id"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <图:图形 uof:locID="g0000" uof:attrList="层次 标识符 组合列表 其他对象">
            <xsl:attribute name="图:标识符"><xsl:value-of select="concat($pic-name,'_',$picnumber)"/></xsl:attribute>
            <xsl:attribute name="图:层次"><xsl:choose><xsl:when test="name(parent::node())='draw:g'"><xsl:value-of select="position()"/></xsl:when><xsl:when test="@draw:z-index"><xsl:value-of select="@draw:z-index"/></xsl:when></xsl:choose></xsl:attribute>
            <xsl:if test="$nodename='draw:g'">
                <xsl:attribute name="图:组合列表"><xsl:for-each select="child::*[1]"><xsl:variable name="node1"><xsl:value-of select="@draw:style-name | @draw:id"/></xsl:variable><xsl:variable name="picnumber2"><xsl:value-of select="count(preceding::*[@draw:style-name=$node1 or @draw:id=$node1])"/></xsl:variable><xsl:call-template name="zuheliebiao"><xsl:with-param name="allnode"><xsl:value-of select="concat($node1,'_',$picnumber2)"/></xsl:with-param><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:for-each></xsl:attribute>
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
                <xsl:when test="$nodename='draw:line' or $nodename='draw:rect' or $nodename='draw:circle' or $nodename='draw:polygon' or $nodename='draw:polyline' or $nodename='draw:ellipse' or $nodename='draw:path'or $nodename='draw:g'">
                    <图:预定义图形 uof:locID="g0005">
                        <图:类别 uof:locID="g0006">
                            <xsl:choose>
                                <xsl:when test="$nodename='draw:line' and $arrow-sign='1'">62</xsl:when>
                                <xsl:when test="$nodename='draw:rect'">11</xsl:when>
                                <xsl:when test="$nodename='draw:line'">61</xsl:when>
                                <xsl:when test="$nodename='draw:circle'">19</xsl:when>
                                <xsl:when test="$nodename='draw:polygon'">65</xsl:when>
                                <xsl:when test="$nodename='draw:polyline'">66</xsl:when>
                                <xsl:when test="$nodename='draw:ellipse'">19</xsl:when>
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
                                <xsl:when test="$nodename='draw:path'">Curve</xsl:when>
                                <xsl:when test="$nodename='draw:g'">group</xsl:when>
                            </xsl:choose>
                        </图:名称>
                        <图:生成软件 uof:locID="g0008">PNG</图:生成软件>
                        <xsl:if test="./@draw:points or ./@svg:d">
                            <图:关键点坐标 uof:locID="g0009" uofattrList="路径">
                                <!--xsl:call-template name="draw:points">
                        <xsl:with-param name="point" select="./@draw:points"/>
                        </xsl:call-template-->
                                <xsl:attribute name="图:路径"><xsl:choose><xsl:when test="@svg:d"><xsl:value-of select="@svg:d"/></xsl:when><xsl:when test="@draw:points"><xsl:call-template name="draw:points"><xsl:with-param name="point" select="@draw:points"/><xsl:with-param name="lujing"/></xsl:call-template></xsl:when></xsl:choose></xsl:attribute>
                            </图:关键点坐标>
                        </xsl:if>
                        <图:属性 uof:locID="g0011">
                            <xsl:for-each select="(/office:document/office:styles/descendant::*[@style:name=$aa]) | (/office:document/office:automatic-styles/descendant::*[@style:name=$aa]) ">
                                <xsl:call-template name="graphicattr"/>
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
                            <!--0820 by lil -->
                        </图:属性>
                    </图:预定义图形>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="string(.//text:p)">
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
                        <xsl:attribute name="图:文字排列方向"><xsl:choose><xsl:when test="style:paragraph-properties/@style:writing-mode"><xsl:choose><xsl:when test="style:paragraph-properties/@style:writing-mode='tb-lr'">vert-l2r</xsl:when><xsl:when test="style:paragraph-properties/@style:writing-mode='tb-rl'">vert-r2l</xsl:when></xsl:choose></xsl:when><xsl:when test="style:graphic-properties/@draw:textarea-horizontal-align='right'">hori-r2l</xsl:when><xsl:otherwise>hori-l2r</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:if test="style:graphic-properties/@fo:wrap-option">
                            <xsl:attribute name="图:自动换行">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="style:graphic-properties/@draw:auto-grow-width='true' or style:graphic-properties/@draw:auto-grow-height='true'">
                            <xsl:attribute name="图:大小适应文字">true</xsl:attribute>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="text:p">
                        <xsl:attribute name="字:标识符"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                        <xsl:if test="style:paragraph-properties">
                            <xsl:apply-templates select="style:paragraph-properties"/>
                        </xsl:if>
                        <xsl:call-template name="textp"/>
                    </xsl:for-each>
                </图:文本内容>
            </xsl:if>
            <图:控制点 uof:locID="g0003" uof:attrList="x坐标 y坐标">
                <xsl:attribute name="图:x坐标"><xsl:value-of select="substring-before(@svg:x,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="图:y坐标"><xsl:value-of select="substring-before(@svg:y,$uofUnit)"/></xsl:attribute>
            </图:控制点>
            <!--新增内容-->
            <xsl:if test="name(..)='draw:g'">
                <图:组合位置 uof:locID="g0041" uof:attrList="x坐标 y坐标">
                    <xsl:attribute name="图:x坐标"><xsl:variable name="minx"><xsl:for-each select="parent::node()"><xsl:call-template name="groupminx"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:x][1]/@svg:x,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:for-each></xsl:variable><xsl:choose><xsl:when test="name(.)='draw:g'"><xsl:variable name="current-minx"><xsl:call-template name="groupminx"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:x][1]/@svg:x,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable><xsl:value-of select="$current-minx - $minx"/></xsl:when><xsl:otherwise><xsl:variable name="current-x" select="number(substring-before(@svg:x,$uofUnit))"/><xsl:value-of select="$current-x - $minx"/></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="图:y坐标"><xsl:variable name="miny"><xsl:for-each select="parent::node()"><xsl:call-template name="groupminy"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:y][1]/@svg:y,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:for-each></xsl:variable><xsl:choose><xsl:when test="name(.)='draw:g'"><xsl:variable name="current-miny"><xsl:call-template name="groupminy"><xsl:with-param name="value" select="number(substring-before(descendant::node()[@svg:y][1]/@svg:y,$uofUnit))"/><xsl:with-param name="pos" select="2"/></xsl:call-template></xsl:variable><xsl:value-of select="$current-miny - $miny"/></xsl:when><xsl:otherwise><xsl:variable name="current-y" select="number(substring-before(@svg:y,$uofUnit))"/><xsl:value-of select="$current-y - $miny"/></xsl:otherwise></xsl:choose></xsl:attribute>
                </图:组合位置>
            </xsl:if>
            <!--Redoffice comment liliang 06.03.28 end-->
        </图:图形>
        <xsl:if test="name()='draw:image'">
            <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                <xsl:attribute name="uof:标识符"><xsl:value-of select="concat($pic-name,'_',$picnumber)"/></xsl:attribute>
                <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                <xsl:attribute name="uof:公共类型">png</xsl:attribute>
                <xsl:if test="./office:binary-data">
                    <uof:数据 uof:locID="u0037">
                        <xsl:value-of select="./office:binary-data"/>
                    </uof:数据>
                </xsl:if>
                <xsl:if test="@xlink:href">
                    <uof:路径 uof:locID="u0038">
                        <xsl:value-of select="@xlink:href"/>
                    </uof:路径>
                </xsl:if>
            </uof:其他对象>
        </xsl:if>
        <xsl:if test="name()='draw:frame'">
            <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                <xsl:attribute name="uof:标识符"><xsl:value-of select="concat($pic-name,'_',$picnumber)"/></xsl:attribute>
                <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                <xsl:attribute name="uof:公共类型">png</xsl:attribute>
                <xsl:if test="draw:image/office:binary-data">
                    <uof:数据 uof:locID="u0037">
                        <xsl:value-of select="draw:image/office:binary-data"/>
                    </uof:数据>
                </xsl:if>
                <xsl:if test="@xlink:href">
                    <uof:路径 uof:locID="u0038">
                        <xsl:value-of select="@xlink:href"/>
                    </uof:路径>
                </xsl:if>
            </uof:其他对象>
        </xsl:if>
        <xsl:for-each select="(/office:document/office:styles/descendant::*[@style:name=$pic-name]) | (/office:document/office:automatic-styles/descendant::*[@style:name=$pic-name]) ">
            <xsl:if test="style:graphic-properties/@draw:fill-image-name">
                <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                    <xsl:attribute name="uof:标识符"><xsl:value-of select="concat($pic-name,'_b1')"/></xsl:attribute>
                    <xsl:attribute name="uof:公共类型">png</xsl:attribute>
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
    <!--Redoffice comment liliang 06.03.29-->
    <!--新增内容-->
    <xsl:template name="graphicattr">
        <xsl:variable name="aa" select="@style:name"/>
        <xsl:if test="not(style:graphic-properties/@draw:fill='none')">
            <图:填充 uof:locID="g0012">
                <xsl:choose>
                    <xsl:when test="style:graphic-properties/@draw:fill='gradient'">
                        <xsl:variable name="gradient-name">
                            <xsl:value-of select="style:graphic-properties/@draw:fill-gradient-name"/>
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
                    <xsl:when test="style:graphic-properties/@draw:fill-image-name">
                        <图:图片 uof:locID="g0035" uof:attrList="位置 图形引用 类型 名称">
                            <xsl:attribute name="图:位置"><xsl:choose><xsl:when test="not(style:graphic-properties/@style:repeat)">tile</xsl:when><xsl:otherwise><xsl:choose><xsl:when test="style:graphic-properties/@style:repeat = 'stretch'">stretch</xsl:when><xsl:when test="style:graphic-properties/@style:repeat = 'repeat'">tile</xsl:when><xsl:when test="style:graphic-properties/@style:repeat = 'no-repeat'">center</xsl:when></xsl:choose></xsl:otherwise></xsl:choose></xsl:attribute>
                            <xsl:attribute name="图:图形引用"><xsl:value-of select="concat($aa,'_b1')"/></xsl:attribute>
                            <xsl:attribute name="图:类型">png</xsl:attribute>
                            <xsl:attribute name="图:名称"><xsl:value-of select="style:graphic-properties/@draw:fill-image-name"/></xsl:attribute>
                        </图:图片>
                    </xsl:when>
                    <xsl:when test="style:graphic-properties/@draw:fill='hatch'">
                        <图:图案 uof:locID="g0036" uof:attrList="类型 图形引用 前景色 背景色">
                            <xsl:if test="/office:document/office:styles/draw:hatch/@draw:name">
                                <xsl:attribute name="图:类型"><xsl:value-of select="/office:document/office:styles/draw:hatch/@draw:name"/></xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="图:图形引用">rogr1</xsl:attribute>
                            <xsl:if test="/office:document/office:styles/draw:hatch/@draw:color">
                                <xsl:attribute name="图:前景色"><xsl:value-of select="/office:document/office:styles/draw:hatch/@draw:color"/></xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="图:背景色"><xsl:choose><xsl:when test="style:graphic-properties/@draw:fill-color"><xsl:value-of select="style:graphic-properties/@draw:fill-color"/></xsl:when><xsl:otherwise>#ffffff</xsl:otherwise></xsl:choose></xsl:attribute>
                        </图:图案>
                    </xsl:when>
                    <xsl:otherwise>
                        <图:颜色 uof:locID="g0034">
                            <xsl:choose>
                                <xsl:when test="style:graphic-properties/@draw:fill-color">
                                    <xsl:value-of select="style:graphic-properties/@draw:fill-color"/>
                                </xsl:when>
                                <xsl:otherwise>#99ccff</xsl:otherwise>
                            </xsl:choose>
                        </图:颜色>
                    </xsl:otherwise>
                </xsl:choose>
            </图:填充>
        </xsl:if>
        <xsl:if test="style:graphic-properties/@svg:stroke-color">
            <图:线颜色 uof:locID="g0013">
                <xsl:value-of select="style:graphic-properties/@svg:stroke-color"/>
            </图:线颜色>
        </xsl:if>
        <图:线型 uof:locID="g0014">
            <xsl:call-template name="表:线型"/>
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
                        <xsl:when test="style:graphic-properties/@draw:marker-start='Line Arrow'">open</xsl:when>
                        <xsl:when test="style:graphic-properties/@draw:marker-start='Arrow concave'">stealth</xsl:when>
                        <xsl:when test="style:graphic-properties/@draw:marker-start='Circle'">oval</xsl:when>
                        <xsl:when test="style:graphic-properties/@draw:marker-start='Square 45'">diamond</xsl:when>
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
            <!--0820 by lil -->
            <图:后端箭头 uof:locID="g0020">
                <图:式样 uof:locID="g0021">
                    <xsl:choose>
                        <xsl:when test="style:graphic-properties/@draw:marker-end='Arrow'">normal</xsl:when>
                        <xsl:when test="style:graphic-properties/@draw:marker-end='Line Arrow'">open</xsl:when>
                        <xsl:when test="style:graphic-properties/@draw:marker-end='Arrow concave'">stealth</xsl:when>
                        <xsl:when test="style:graphic-properties/@draw:marker-end='Circle'">oval</xsl:when>
                        <xsl:when test="style:graphic-properties/@draw:marker-end='Square 45'">diamond</xsl:when>
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
        <xsl:if test="style:graphic-properties/@draw:opacity">
            <xsl:variable name="trans" select="style:graphic-properties/@draw:opacity"/>
            <图:透明度 uof:locID="g0038">
                <xsl:value-of select="substring($trans,1,2)"/>
            </图:透明度>
        </xsl:if>
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
    <!--Redoffice comment liliang end 06.03.29-->
    <!--Redoffice comment liliang 06.03.29-->
    <!--新增内容-->
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
    <!--Redoffice comment liliang end 06.03.29-->
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
    <!--Redoffice comment end liliang-->
    <!--chenjh add 20050624-->
    <xsl:template name="create-page-setting">
        <xsl:param name="master-page"/>
        <xsl:param name="page-master-style"/>
        <xsl:element name="表:页面设置">
            <xsl:attribute name="uof:locID">s0029</xsl:attribute>
            <xsl:attribute name="uof:attrList">名称</xsl:attribute>
            <xsl:attribute name="表:名称"><xsl:value-of select="$master-page/@style:name"/></xsl:attribute>
            <xsl:element name="表:纸张">
                <xsl:attribute name="uof:locID">s0030</xsl:attribute>
                <xsl:attribute name="uof:attrList">纸型 宽度 高度</xsl:attribute>
                <xsl:attribute name="uof:纸型"><xsl:variable name="height"><xsl:value-of select="$page-master-style/@fo:page-height"/></xsl:variable><xsl:variable name="width"><xsl:value-of select="$page-master-style/@fo:page-width"/></xsl:variable><xsl:choose><xsl:when test="$width='29.699cm' and $height='42cm'">A3</xsl:when><xsl:when test="not($page-master-style/@fo:page-height) and not($page-master-style/@fo:page-width)">A4</xsl:when><xsl:when test="$width='14.799cm' and $height='20.999cm'">A5</xsl:when><xsl:when test="$width='25cm' and $height='35.299cm'">B4</xsl:when><xsl:when test="$width='17.598cm' and $height='25cm'">B5</xsl:when><xsl:when test="$width='12.499cm' and $height='17.598cm'">B6</xsl:when><xsl:otherwise>使用者</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="uof:宽度"><xsl:choose><xsl:when test="$page-master-style/@fo:page-width"><xsl:value-of select="substring-before($page-master-style/@fo:page-width,$uofUnit)"/></xsl:when><xsl:otherwise><xsl:call-template name="setDefaultPageWidth"/></xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="uof:高度"><xsl:choose><xsl:when test="$page-master-style/@fo:page-height"><xsl:value-of select="substring-before($page-master-style/@fo:page-height,$uofUnit)"/></xsl:when><xsl:otherwise><xsl:call-template name="setDefaultPageHeight"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
            <xsl:element name="表:纸张方向">
                <xsl:attribute name="uof:locID">s0031</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$page-master-style/@style:print-orientation">
                        <xsl:value-of select="$page-master-style/@style:print-orientation"/>
                    </xsl:when>
                    <xsl:otherwise>portrait</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:element name="表:缩放">
                <xsl:attribute name="uof:locID">s0032</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$page-master-style/@style:scale-to">
                        <xsl:value-of select="$page-master-style/@style:scale-to"/>
                    </xsl:when>
                    <xsl:otherwise>100</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:if test="$page-master-style/@fo:margin-left or $page-master-style/@fo:margin-top or $page-master-style/@fo:margin-right or $page-master-style/@fo:margin-bottom">
                <xsl:element name="表:页边距">
                    <xsl:attribute name="uof:locID">s0033</xsl:attribute>
                    <xsl:attribute name="uof:attrList">左 上 右 下</xsl:attribute>
                    <xsl:attribute name="uof:左"><xsl:value-of select="substring-before($page-master-style/@fo:margin-left,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="uof:上"><xsl:value-of select="substring-before($page-master-style/@fo:margin-top,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="uof:右"><xsl:value-of select="substring-before($page-master-style/@fo:margin-right,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="uof:下"><xsl:value-of select="substring-before($page-master-style/@fo:margin-bottom,$uofUnit)"/></xsl:attribute>
                </xsl:element>
            </xsl:if>
            <xsl:for-each select="$master-page[@style:page-layout-name='pm1']/style:header/child::*">
                <表:页眉页脚 uof:locID="s0034" uof:attrList="位置">
                    <xsl:attribute name="表:位置"><xsl:choose><xsl:when test="name()='style:region-left'">headerleft</xsl:when><xsl:when test="name()='style:region-right'">headerright</xsl:when><xsl:otherwise>headercenter</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:call-template name="create-page-header-footer-paragraph">
                        <xsl:with-param name="paragraph-set" select="text:p"/>
                    </xsl:call-template>
                </表:页眉页脚>
            </xsl:for-each>
            <xsl:for-each select="$master-page[@style:page-layout-name='pm1']/style:footer/child::*">
                <表:页眉页脚 uof:locID="s0034" uof:attrList="位置">
                    <xsl:attribute name="表:位置"><xsl:choose><xsl:when test="name()='style:region-left'">footerleft</xsl:when><xsl:when test="name()='style:region-right'">footerright</xsl:when><xsl:otherwise>footercenter</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:call-template name="create-page-header-footer-paragraph">
                        <xsl:with-param name="paragraph-set" select="text:p"/>
                    </xsl:call-template>
                </表:页眉页脚>
            </xsl:for-each>
            <xsl:if test="$page-master-style/@style:print-page-order or $page-master-style/@style:print">
                <表:打印 uof:locID="s126" uof:attrList="网格线 行号列标 按草稿方式 先列后行">
                    <xsl:if test="$page-master-style/@style:print-page-order='ltr'">
                        <xsl:attribute name="表:先列后行">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="contains($page-master-style/@style:print,'grid')">
                        <xsl:attribute name="表:网格线">true</xsl:attribute>
                    </xsl:if>
                </表:打印>
            </xsl:if>
            <xsl:if test="$page-master-style/@style:table-centering='vertical' or $page-master-style/@style:table-centering='both'">
                <表:垂直对齐 uof:locID="s0128" uof:attrList="对齐方式">
                    <xsl:attribute name="表:对齐方式">center</xsl:attribute>
                </表:垂直对齐>
            </xsl:if>
            <xsl:if test="$page-master-style/@style:table-centering='horizontal' or $page-master-style/@style:table-centering='both'">
                <表:水平对齐 uof:locID="s0129" uof:attrList="对齐方式">
                    <xsl:attribute name="表:对齐方式">center</xsl:attribute>
                </表:水平对齐>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="create-page-header-footer-paragraph">
        <xsl:param name="paragraph-set"/>
        <xsl:choose>
            <xsl:when test="$paragraph-set">
                <xsl:element name="字:段落">
                    <xsl:attribute name="uof:locID">t0051</xsl:attribute>
                    <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                    <xsl:element name="字:句">
                        <xsl:attribute name="uof:locID">t0085</xsl:attribute>
                        <xsl:apply-templates select="$paragraph-set//text()">
                            <xsl:with-param name="bText" select="'0'"/>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:element>
                <xsl:call-template name="create-page-header-footer-paragraph">
                    <xsl:with-param name="paragraph-set" select="$paragraph-set[position()!=1]"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text:p" name="textp">
        <xsl:apply-templates select="text()|text:span|text:tab-stop|text:line-break|text:s|text:ruby|text:bookmark|text:bookmark-start|text:bookmark-end|text:a|text:footnote|text:endnote">
            <xsl:with-param name="bText" select="'1'"/>
            <xsl:with-param name="sText" select="'1'"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="text:a">
        <xsl:param name="bText"/>
        <xsl:choose>
            <xsl:when test="$bText='0'">
                <xsl:element name="字:句">
                    <xsl:attribute name="uof:locID">t0085</xsl:attribute>
                    <xsl:element name="字:区域开始">
                        <xsl:attribute name="字:标识符"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
                        <xsl:attribute name="字:类型">hyperlink</xsl:attribute>
                        <xsl:attribute name="uof:locID">t0121</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符 名称 类型</xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="字:区域开始">
                    <xsl:attribute name="字:标识符"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
                    <xsl:attribute name="字:类型">hyperlink</xsl:attribute>
                    <xsl:attribute name="uof:locID">t0121</xsl:attribute>
                    <xsl:attribute name="uof:attrList">标识符 名称 类型</xsl:attribute>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:param name="bText"/>
        <xsl:param name="sText"/>
        <xsl:if test="normalize-space(.)!=''">
            <xsl:choose>
                <xsl:when test="$bText='1' and $sText='1'">
                    <字:句 uof:locID="t0085">
                        <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                            <xsl:value-of select="."/>
                        </字:文本串>
                    </字:句>
                </xsl:when>
                <xsl:otherwise>
                    <字:文本串 uof:locID="t0109" uof:attrList="udsPath">
                        <xsl:value-of select="."/>
                    </字:文本串>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="text:span">
        <xsl:param name="bText"/>
        <xsl:choose>
            <xsl:when test="$bText='0'">
                <字:句属性 uof:locID="t0086" uof:attrList="式样引用">
                    <xsl:attribute name="字:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                </字:句属性>
                <xsl:apply-templates select="text:s|text()|text:line-break|text:tab-stop| text:a | text:footnote|text:endnote|draw:image|office:annotation|draw:frame">
                    <xsl:with-param name="bText" select="1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <字:句 uof:locID="t0085">
                    <字:句属性 uof:locID="t0086" uof:attrList="式样引用" 字:式样引用="{@text:style-name}"/>
                    <xsl:apply-templates select="text:s|text()|text:line-break|text:tab-stop| text:a |text:footnote|text:endnote|draw:image|office:annotation|draw:frame">
                        <xsl:with-param name="bText" select="1"/>
                    </xsl:apply-templates>
                </字:句>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text:s">
        <xsl:param name="bText"/>
        <xsl:choose>
            <xsl:when test="$bText='0'">
                <xsl:variable name="count">
                    <xsl:choose>
                        <xsl:when test="not(@text:c)">1</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@text:c"/>
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
    <xsl:template match="text:line-break">
        <xsl:param name="bText"/>
        <xsl:choose>
            <xsl:when test="$bText='0'">
                <字:句 uof:locID="t0085">
                    <字:换行符 uof:locID="t0124"/>
                </字:句>
            </xsl:when>
            <xsl:otherwise>
                <字:换行符 uof:locID="t0124"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text:tab-stop">
        <xsl:param name="bText"/>
        <xsl:choose>
            <xsl:when test="$bText='0'">
                <字:句 uof:locID="t0085">
                    <字:制表符 uof:locID="t0123"/>
                </字:句>
            </xsl:when>
            <xsl:otherwise>
                <字:制表符 uof:locID="t0123"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--chenjh0713-->
    <!--chenjh0629E-->
    <!--chenjh add 20050629 -->
    <!--字符串转换为数字-->
    <xsl:template name="translate-column-char-to-number">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="string-length($string)=1">
                <xsl:call-template name="char-to-number">
                    <xsl:with-param name="char" select="$string"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="tens-place">
                    <xsl:call-template name="char-to-number">
                        <xsl:with-param name="char" select="substring($string,1,1)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="units-place">
                    <xsl:call-template name="char-to-number">
                        <xsl:with-param name="char" select="substring($string,2,1)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$tens-place * 26 + $units-place"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="char-to-number">
        <xsl:param name="char"/>
        <xsl:choose>
            <xsl:when test="$char='A'">1</xsl:when>
            <xsl:when test="$char='B'">2</xsl:when>
            <xsl:when test="$char='C'">3</xsl:when>
            <xsl:when test="$char='D'">4</xsl:when>
            <xsl:when test="$char='E'">5</xsl:when>
            <xsl:when test="$char='F'">6</xsl:when>
            <xsl:when test="$char='G'">7</xsl:when>
            <xsl:when test="$char='H'">8</xsl:when>
            <xsl:when test="$char='I'">9</xsl:when>
            <xsl:when test="$char='J'">10</xsl:when>
            <xsl:when test="$char='K'">11</xsl:when>
            <xsl:when test="$char='L'">12</xsl:when>
            <xsl:when test="$char='M'">13</xsl:when>
            <xsl:when test="$char='N'">14</xsl:when>
            <xsl:when test="$char='O'">15</xsl:when>
            <xsl:when test="$char='P'">16</xsl:when>
            <xsl:when test="$char='Q'">17</xsl:when>
            <xsl:when test="$char='R'">18</xsl:when>
            <xsl:when test="$char='S'">19</xsl:when>
            <xsl:when test="$char='T'">20</xsl:when>
            <xsl:when test="$char='U'">21</xsl:when>
            <xsl:when test="$char='V'">22</xsl:when>
            <xsl:when test="$char='W'">23</xsl:when>
            <xsl:when test="$char='X'">24</xsl:when>
            <xsl:when test="$char='Y'">25</xsl:when>
            <xsl:when test="$char='Z'">26</xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="create-filter-conditions">
        <xsl:param name="filter-condition-set"/>
        <xsl:param name="zone-left-column-num"/>
        <xsl:if test="$filter-condition-set">
            <xsl:variable name="first-condition" select="$filter-condition-set"/>
            <xsl:element name="表:条件">
                <xsl:attribute name="uof:locID">s0103</xsl:attribute>
                <xsl:attribute name="uof:attrList">列号</xsl:attribute>
                <xsl:attribute name="表:列号"><xsl:value-of select="$zone-left-column-num + $first-condition/@table:field-number"/></xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$first-condition/@table:operator ='top values'">
                        <xsl:element name="表:普通">
                            <xsl:attribute name="uof:locID">s0104</xsl:attribute>
                            <xsl:attribute name="uof:attrList">类型 值</xsl:attribute>
                            <xsl:attribute name="表:类型">topitem</xsl:attribute>
                            <xsl:attribute name="表:值"><xsl:value-of select="$first-condition/@table:value"/></xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="表:自定义">
                            <xsl:attribute name="uof:locID">s0105</xsl:attribute>
                            <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                            <xsl:element name="表:操作条件">
                                <xsl:attribute name="uof:locID">s0106</xsl:attribute>
                                <!--redoffice comment  from  lvxg  8.27-->
                                <xsl:if test="$first-condition/@table:operator">
                                    <xsl:element name="表:操作码">
                                        <xsl:attribute name="uof:locID">s0009</xsl:attribute>
                                        <xsl:variable name="operator-text" select="$first-condition/@table:operator"/>
                                        <xsl:choose>
                                            <xsl:when test="$operator-text ='&lt;' ">less than</xsl:when>
                                            <xsl:when test="$operator-text ='&gt;' ">greater than</xsl:when>
                                            <xsl:when test="$operator-text ='=' ">equal to</xsl:when>
                                            <xsl:when test="$operator-text ='&gt;=' ">greater than or equal to</xsl:when>
                                            <xsl:when test="$operator-text ='&lt;=' ">less than or equal to</xsl:when>
                                            <xsl:when test="$operator-text ='!=' ">not equal to</xsl:when>
                                        </xsl:choose>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:element name="表:值">
                                    <xsl:attribute name="uof:locID">s0107</xsl:attribute>
                                    <xsl:value-of select="$first-condition/@table:value"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:call-template name="create-filter-conditions">
                <xsl:with-param name="filter-condition-set" select="$filter-condition-set[position()!=1]"/>
                <xsl:with-param name="zone-left-column-num" select="$zone-left-column-num"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="create-view">
        <xsl:param name="table-name"/>
        <xsl:param name="view-id"/>
        <!--xsl:param name="ActiveTable"/-->
        <xsl:param name="aaa"/>
        <!--xsl:variable name="aaa" select="/*/office:settings/config:config-item-set/config:config-item-map-indexed"-->
        <xsl:element name="表:视图">
            <xsl:attribute name="uof:locID">s0035</xsl:attribute>
            <xsl:attribute name="uof:attrList">窗口标识符</xsl:attribute>
            <xsl:attribute name="表:窗口标识符"><xsl:value-of select="$view-id"/></xsl:attribute>
            <xsl:if test="$table-name='ActiveTable'">
                <xsl:element name="表:选中">
                    <xsl:attribute name="uof:locID">s0036</xsl:attribute>
                    <xsl:attribute name="uof:attrList">值</xsl:attribute>
                    <xsl:attribute name="表:值">1</xsl:attribute>
                </xsl:element>
            </xsl:if>
            <xsl:variable name="name" select="./@table:name"/>
            <xsl:choose>
                <xsl:when test="$aaa/config:config-item-map-named/config:config-item-map-entry[@config:name=$name]/config:config-item[@config:name='HorizontalSplitMode']/text()='2'  or $aaa/config:config-item-map-named/config:config-item-map-entry[@config:name=name]/config:config-item[@config:name='VerticalSplitMode']/text()='2' ">
                    <xsl:element name="表:冻结">
                        <xsl:attribute name="uof:locID">s0038</xsl:attribute>
                        <xsl:attribute name="uof:attrList">行号 列号</xsl:attribute>
                        <xsl:attribute name="表:行号"><xsl:value-of select="$aaa/config:config-item-map-named/config:config-item-map-entry[@config:name=$name]/config:config-item[@config:name='VerticalSplitPosition']/text()"/></xsl:attribute>
                        <xsl:attribute name="表:列号"><xsl:value-of select="$aaa/config:config-item-map-named/config:config-item-map-entry[@config:name=$name]/config:config-item[@config:name='HorizontalSplitPosition']/text()"/></xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="表:拆分">
                        <xsl:attribute name="uof:locID">s0037</xsl:attribute>
                        <xsl:attribute name="uof:attrList">宽度 高度</xsl:attribute>
                        <xsl:attribute name="表:宽度"><xsl:choose><xsl:when test="$aaa/config:config-item-map-named/config:config-item-map-entry[@config:name=$name]/config:config-item[@config:name='HorizontalSplitMode']/text()='1'"><xsl:value-of select="$aaa/config:config-item-map-named/config:config-item-map-entry[@config:name=$name]/config:config-item[@config:name='HorizontalSplitPosition']/text()"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="表:高度"><xsl:choose><xsl:when test="$aaa/config:config-item-map-named/config:config-item-map-entry[@config:name=$name]/config:config-item[@config:name='VerticalSplitMode']/text()='1'"><xsl:value-of select="$aaa/config:config-item-map-named/config:config-item-map-entry[@config:name=$name]/config:config-item[@config:name='VerticalSplitPosition']/text()"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:element name="表:最上行">
                <xsl:attribute name="uof:locID">s0039</xsl:attribute>
                <!--xsl:value-of select="$aaa/config:config-item-map-named/config:config-item-map-entry[@config:name=$table-name]/config:config-item[@config:name='PositionBottom']/text()+1"/-->
                <xsl:choose>
                    <xsl:when test="$aaa/config:config-item-map-named/config:config-item-map-entry/config:config-item[@config:name='PositionBottom']/text()">
                        <xsl:value-of select="$aaa/config:config-item-map-named/config:config-item-map-entry/config:config-item[@config:name='PositionBottom']/text()"/>
                    </xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:element name="表:最左列">
                <xsl:attribute name="uof:locID">s0040</xsl:attribute>
                <!--xsl:value-of select="$aaa/config:config-item-map-named/config:config-item-map-entry[@config:name=$table-name]/config:config-item[@config:name='PositionLeft']/text() + 1"/-->
                <xsl:choose>
                    <xsl:when test="$aaa/config:config-item-map-named/config:config-item-map-entry/config:config-item[@config:name='PositionRight']/text()">
                        <xsl:value-of select="$aaa/config:config-item-map-named/config:config-item-map-entry/config:config-item[@config:name='PositionRight']/text()"/>
                    </xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:element name="表:当前视图">
                <xsl:attribute name="uof:locID">s0041</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                <xsl:attribute name="表:类型"><xsl:choose><xsl:when test="$aaa/config:config-item[@config:name='ShowPageBreakPreview']/text()='true'">page</xsl:when><xsl:otherwise>normal</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
            <xsl:element name="表:网格">
                <xsl:attribute name="uof:locID">s0043</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="表:值"><xsl:choose><xsl:when test="/*/office:settings/config:config-item-set[@config:name='ooo:view-settings']//config:config-item[@config:name='ShowGrid']/text()='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
            <xsl:element name="表:网格颜色">
                <xsl:attribute name="uof:locID">s0044</xsl:attribute>
                <xsl:variable name="GridColor-text">
                    <xsl:value-of select="//config:config-item-set[@config:name='ooo:view-settings']//config:config-item[@config:name='GridColor']/text()"/>
                </xsl:variable>
                <xsl:variable name="R-color" select="floor($GridColor-text div 65536)"/>
                <xsl:variable name="G-color" select="floor(($GridColor-text - ($R-color * 65536)) div 256)"/>
                <xsl:variable name="B-color" select="$GridColor-text - ($R-color * 65536)- ($G-color * 256)"/>
                <xsl:variable name="R-color-in-16">
                    <xsl:call-template name="transform-decimal-to-hexadecimal">
                        <xsl:with-param name="color-decimal" select="$R-color"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="G-color-in-16">
                    <xsl:call-template name="transform-decimal-to-hexadecimal">
                        <xsl:with-param name="color-decimal" select="$G-color"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="B-color-in-16">
                    <xsl:call-template name="transform-decimal-to-hexadecimal">
                        <xsl:with-param name="color-decimal" select="$B-color"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('#',$R-color-in-16,$G-color-in-16,$B-color-in-16)"/>
            </xsl:element>
            <xsl:if test="/*/office:settings/config:config-item-set[@config:name='ooo:view-settings']//config:config-item[@config:name='ZoomType']/text()=0">
                <xsl:element name="表:缩放">
                    <xsl:attribute name="uof:locID">s0045</xsl:attribute>
                    <xsl:value-of select="/*/office:settings/config:config-item-set[@config:name='ooo:view-settings']//config:config-item[@config:name='ZoomValue']/text()"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="/*/office:settings/config:config-item-set[@config:name='ooo:view-settings']//config:config-item[@config:name='ZoomType']/text()=1">
                <xsl:element name="表:分页缩放">
                    <xsl:attribute name="uof:locID">s0046</xsl:attribute>
                    <xsl:value-of select="/*/office:settings/config:config-item-set[@config:name='ooo:view-settings']//config:config-item[@config:name='ZoomValue']/text()"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="hexNumber2dec">
        <xsl:param name="hex-value"/>
        <xsl:choose>
            <xsl:when test="$hex-value = 'A' or ($hex-value = 'a')">
                <xsl:value-of select="10"/>
            </xsl:when>
            <xsl:when test="$hex-value = 'B' or ($hex-value = 'b')">
                <xsl:value-of select="11"/>
            </xsl:when>
            <xsl:when test="$hex-value = 'C' or ($hex-value = 'c')">
                <xsl:value-of select="12"/>
            </xsl:when>
            <xsl:when test="$hex-value = 'D' or ($hex-value = 'd')">
                <xsl:value-of select="13"/>
            </xsl:when>
            <xsl:when test="$hex-value = 'E' or ($hex-value = 'e')">
                <xsl:value-of select="14"/>
            </xsl:when>
            <xsl:when test="$hex-value = 'F' or ($hex-value = 'f')">
                <xsl:value-of select="15"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$hex-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="hex2decimal">
        <xsl:param name="hex-number"/>
        <xsl:param name="index"/>
        <xsl:param name="str-length"/>
        <xsl:param name="last-value"/>
        <xsl:variable name="dec-char">
            <xsl:call-template name="hexNumber2dec">
                <xsl:with-param name="hex-value" select="substring($hex-number, $index ,1)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="current-value" select="$last-value * 16 + $dec-char"/>
        <xsl:if test="$index &lt; $str-length">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="$hex-number"/>
                <xsl:with-param name="index" select="$index + 1"/>
                <xsl:with-param name="str-length" select="$str-length"/>
                <xsl:with-param name="last-value" select="$current-value"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$index = $str-length">
            <xsl:value-of select="$current-value"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="table:calculation-settings" mode="common">
        <xsl:if test="@table:precision-as-shown">
            <xsl:element name="表:精确度以显示值为准">
                <xsl:attribute name="uof:locID">s0002</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="表:值"><xsl:value-of select="@table:precision-as-shown"/></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:element name="表:日期系统-1904">
            <xsl:attribute name="uof:locID">s0003</xsl:attribute>
            <xsl:attribute name="uof:attrList">值</xsl:attribute>
            <xsl:attribute name="表:值"><xsl:choose><xsl:when test="table:null-date/@table:date-value='1904-01-01'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:element>
        <xsl:if test="table:iteration/@table:status='enable'">
            <表:计算设置 uof:locID="s0004" uof:attrList="迭代次数 偏差值">
                <xsl:attribute name="表:迭代次数"><xsl:value-of select="table:iteration/@table:steps"/></xsl:attribute>
                <xsl:attribute name="表:偏差值"><xsl:choose><xsl:when test="table:iteration/@table:maximum-difference"><xsl:value-of select="table:iteration/@table:maximum-difference"/></xsl:when><xsl:otherwise>0.001</xsl:otherwise></xsl:choose><!--xsl:value-of select="table:iteration/@table:maximum-difference"/--></xsl:attribute>
            </表:计算设置>
        </xsl:if>
    </xsl:template>
    <xsl:template match="office:automatic-styles" mode="common">
        <xsl:element name="表:条件格式化集">
            <xsl:attribute name="uof:locID">s0016</xsl:attribute>
            <xsl:variable name="temp-path" select="../office:automatic-styles/style:style"/>
            <xsl:for-each select="$temp-path/style:map">
                <xsl:element name="表:条件格式化">
                    <xsl:attribute name="uof:locID">s0017</xsl:attribute>
                    <xsl:element name="表:区域">
                        <xsl:attribute name="uof:locID">s0007</xsl:attribute>
                        <xsl:variable name="range-name">
                            <xsl:value-of select="substring-before(@style:base-cell-address,'.')"/>
                        </xsl:variable>
                        <xsl:variable name="range-value">
                            <xsl:value-of select="substring-after(@style:base-cell-address,'.')"/>
                        </xsl:variable>
                        <xsl:value-of select="concat(&quot;&apos;&quot;,$range-name,&quot;&apos;&quot;,'!$',substring($range-value,1,1),'$',substring($range-value,2))"/>
                    </xsl:element>
                    <xsl:element name="表:条件">
                        <xsl:attribute name="uof:locID">s0019</xsl:attribute>
                        <xsl:attribute name="表:类型"><xsl:choose><xsl:when test="contains(@style:condition,'formula')"><xsl:value-of select="'formula'"/></xsl:when><xsl:otherwise><xsl:value-of select="'cell value'"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:element name="表:操作码">
                            <xsl:attribute name="uof:locID">s0009</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="contains(@style:condition,'!=')">
                                    <xsl:value-of select="'not equal to'"/>
                                </xsl:when>
                                <xsl:when test="contains(@style:condition,'&lt;=')">
                                    <xsl:value-of select="'less than or equal to'"/>
                                </xsl:when>
                                <xsl:when test="contains(@style:condition,'&gt;=')">
                                    <xsl:value-of select="'greater than or equal to'"/>
                                </xsl:when>
                                <xsl:when test="contains(@style:condition,'&lt;')">
                                    <xsl:value-of select="'less than'"/>
                                </xsl:when>
                                <xsl:when test="contains(@style:condition,'&gt;')">
                                    <xsl:value-of select="'greater than'"/>
                                </xsl:when>
                                <xsl:when test="contains(@style:condition,'=')">
                                    <xsl:value-of select="'equal to'"/>
                                </xsl:when>
                                <xsl:when test="contains(@style:condition,'not-between')">
                                    <xsl:value-of select="'not-between'"/>
                                </xsl:when>
                                <xsl:when test="contains(@style:condition,'between')">
                                    <xsl:value-of select="'between'"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:element>
                        <xsl:element name="表:第一操作数">
                            <xsl:attribute name="uof:locID">s0010</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="contains(@style:condition,'formula')">
                                    <xsl:value-of select="substring-after(substring-before(@style:condition,')'),'(')"/>
                                </xsl:when>
                                <xsl:when test="contains(@style:condition,'=')">
                                    <xsl:value-of select="substring-after(@style:condition,'=')"/>
                                </xsl:when>
                                <xsl:when test="contains(@style:condition,'&lt;') and not(contains(@style:condition,'&lt;='))">
                                    <xsl:value-of select="substring-after(@style:condition,'&lt;')"/>
                                </xsl:when>
                                <xsl:when test="contains(@style:condition,'&gt;') and not(contains(@style:condition,'&gt;='))">
                                    <xsl:value-of select="substring-after(@style:condition,'&gt;')"/>
                                </xsl:when>
                                <xsl:when test="contains(@style:condition,'between')">
                                    <xsl:value-of select="substring-before(substring-after(@style:condition,'('),',')"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:element>
                        <xsl:if test="contains(@style:condition,',')">
                            <xsl:element name="表:第二操作数">
                                <xsl:attribute name="uof:locID">s0011</xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="contains(@style:condition,'between')">
                                        <xsl:value-of select="substring-before(substring-after(@style:condition,','),')')"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:if>
                        <xsl:element name="表:格式">
                            <xsl:attribute name="uof:locID">s0023</xsl:attribute>
                            <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                            <xsl:attribute name="表:式样引用"><xsl:value-of select="@style:apply-style-name"/></xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match="table:content-validations" mode="common">
        <xsl:element name="表:数据有效性集">
            <xsl:attribute name="uof:locID">s0005</xsl:attribute>
            <xsl:call-template name="create-validation-set">
                </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template name="create-validation-set">
        <xsl:for-each select="//table:content-validation">
            <xsl:element name="表:数据有效性">
                <xsl:attribute name="uof:locID">s0006</xsl:attribute>
                <xsl:variable name="conditiontext" select="@table:condition"/>
                <xsl:variable name="operatortext" select="substring-after($conditiontext,'and ')"/>
                <xsl:element name="表:区域">
                    <xsl:attribute name="uof:locID">s0007</xsl:attribute>
                    <xsl:variable name="left-top">
                        <xsl:call-template name="search-left-top-validation">
                            <xsl:with-param name="validation-name" select="@table:name"/>
                            <xsl:with-param name="tableslist" select="/*/office:body/office:spreadsheet/table:table"/>
                            <xsl:with-param name="return" select="''"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="after-translated-left-top">
                        <xsl:call-template name="translate-left-top">
                            <xsl:with-param name="left-top" select="$left-top"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="base" select="@table:base-cell-address"/>
                    <xsl:variable name="base-column-and-row" select="substring-after($base,'.')"/>
                    <xsl:variable name="dd" select="number(substring($base-column-and-row,2,1))"/>
                    <xsl:variable name="base-column">
                        <xsl:choose>
                            <xsl:when test="contains($dd,'NaN') ">
                                <xsl:value-of select="substring($base-column-and-row,1,2)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring($base-column-and-row,1,1)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="base-row" select="substring-after($base,$base-column)"/>
                    <xsl:variable name="after-translated-base-left-top">
                        <xsl:value-of select="concat('$',substring-before($base,'.'),'.$',$base-column,'$',$base-row)"/>
                    </xsl:variable>
                    <xsl:value-of select="concat('$',$after-translated-left-top,':',$after-translated-base-left-top)"/>
                </xsl:element>
                <xsl:element name="表:校验类型">
                    <xsl:attribute name="uof:locID">s0008</xsl:attribute>
                    <xsl:variable name="listtest">cell-content-is-in-list("</xsl:variable>
                    <xsl:choose>
                        <xsl:when test="contains($conditiontext,'cell-content-is-whole-number()')">whole number</xsl:when>
                        <xsl:when test="contains($conditiontext,'cell-content-is-decimal-number()')">decimal</xsl:when>
                        <xsl:when test="contains($conditiontext,'cell-content-is-date()')">date</xsl:when>
                        <xsl:when test="contains($conditiontext,'cell-content-is-time()')">time</xsl:when>
                        <xsl:when test="contains($conditiontext,'cell-content-is-in-list') and not(contains($conditiontext,$listtest))">cell range</xsl:when>
                        <xsl:when test="contains($conditiontext,'cell-content-is-in-list') and contains($conditiontext,$listtest)">list</xsl:when>
                        <xsl:when test="contains($conditiontext,'cell-content-text-length')">text length</xsl:when>
                        <xsl:otherwise>any value</xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:element name="表:操作码">
                    <xsl:attribute name="uof:locID">s0009</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="starts-with($operatortext,'cell-content()&lt;=')">less than or equal to</xsl:when>
                        <xsl:when test="starts-with($operatortext,'cell-content()&gt;=')">greater than or equal to</xsl:when>
                        <xsl:when test="starts-with($operatortext,'cell-content()&lt;')">less than</xsl:when>
                        <xsl:when test="starts-with($operatortext,'cell-content()&gt;')">greater than</xsl:when>
                        <xsl:when test="starts-with($operatortext,'cell-content()!=')">not equal to</xsl:when>
                        <xsl:when test="starts-with($operatortext,'cell-content()=')">equal to</xsl:when>
                        <xsl:when test="starts-with($conditiontext,'oooc:cell-content-text-length()')">
                            <xsl:variable name="operator" select="substring-after($conditiontext,'oooc:cell-content-text-length()')"/>
                            <xsl:choose>
                                <xsl:when test="starts-with($operator,'&lt;=')">less than or equal to</xsl:when>
                                <xsl:when test="starts-with($operator,'&gt;=')">greater than or equal to</xsl:when>
                                <xsl:when test="starts-with($operator,'&lt;')">less than</xsl:when>
                                <xsl:when test="starts-with($operator,'&gt;')">greater than</xsl:when>
                                <xsl:when test="starts-with($operator,'!=')">not equal to</xsl:when>
                                <xsl:when test="starts-with($operator,'=')">equal to</xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="contains($conditiontext,'is-between')">between</xsl:when>
                        <xsl:when test="contains($conditiontext,'is-not-between')">not between</xsl:when>
                        <!-- 注意：uof有的另几种操作码在oo中没有，他们是contain,not contain,start with,not start with, end with,not end with-->
                    </xsl:choose>
                </xsl:element>
                <xsl:element name="表:第一操作数">
                    <xsl:attribute name="uof:locID">s0010</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="starts-with($operatortext,'cell-content-is-between')">
                            <xsl:value-of select="substring-before(substring-after($operatortext,'cell-content-is-between('),',')"/>
                        </xsl:when>
                        <xsl:when test="starts-with($operatortext,'cell-content-is-not-between')">
                            <xsl:value-of select="substring-before(substring-after($operatortext,'cell-content-is-not-between('),',')"/>
                        </xsl:when>
                        <xsl:when test="starts-with($conditiontext,'oooc:cell-content-text-length()')">
                            <xsl:variable name="operator" select="substring-after($conditiontext,'cell-content-text-length()')"/>
                            <xsl:choose>
                                <xsl:when test="starts-with($operator,'&lt;=')">
                                    <xsl:value-of select="substring-after($operator,'&lt;=')"/>
                                </xsl:when>
                                <xsl:when test="starts-with($operator,'&gt;=')">
                                    <xsl:value-of select="substring-after($operator,'&gt;=')"/>
                                </xsl:when>
                                <xsl:when test="starts-with($operator,'&lt;')">
                                    <xsl:value-of select="substring-after($operator,'&lt;')"/>
                                </xsl:when>
                                <xsl:when test="starts-with($operator,'&gt;')">
                                    <xsl:value-of select="substring-after($operator,'&gt;')"/>
                                </xsl:when>
                                <xsl:when test="starts-with($operator,'!=')">
                                    <xsl:value-of select="substring-after($operator,'!=')"/>
                                </xsl:when>
                                <xsl:when test="starts-with($operator,'=')">
                                    <xsl:value-of select="substring-after($operator,'=')"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="starts-with($conditiontext,'oooc:cell-content-is-in-list')">
                            <xsl:value-of select="substring-after($conditiontext,'oooc:cell-content-is-in-list')"/>
                        </xsl:when>
                        <xsl:when test="starts-with($conditiontext,'oooc:cell-content-text-length-is-not-between')">
                            <xsl:value-of select="substring-before(substring-after($conditiontext,'oooc:cell-content-text-length-is-not-between('),',')"/>
                        </xsl:when>
                        <xsl:when test="starts-with($conditiontext,'oooc:cell-content-text-length-is-between')">
                            <xsl:value-of select="substring-before(substring-after($conditiontext,'oooc:cell-content-text-length-is-between('),',')"/>
                        </xsl:when>
                        <xsl:when test="starts-with($operatortext,'cell-content()')">
                            <xsl:variable name="operator" select="substring-after($conditiontext,'oooc:cell-content()')"/>
                            <xsl:choose>
                                <xsl:when test="starts-with($operator,'&lt;=')">
                                    <xsl:value-of select="substring-after($operator,'&lt;=')"/>
                                </xsl:when>
                                <xsl:when test="starts-with($operator,'&gt;=')">
                                    <xsl:value-of select="substring-after($operator,'&gt;=')"/>
                                </xsl:when>
                                <xsl:when test="starts-with($operator,'&lt;')">
                                    <xsl:value-of select="substring-after($operator,'&lt;')"/>
                                </xsl:when>
                                <xsl:when test="starts-with($operator,'&gt;')">
                                    <xsl:value-of select="substring-after($operator,'&gt;')"/>
                                </xsl:when>
                                <xsl:when test="starts-with($operator,'!=')">
                                    <xsl:value-of select="substring-after($operator,'!=')"/>
                                </xsl:when>
                                <xsl:when test="starts-with($operator,'=')">
                                    <xsl:value-of select="substring-after($operator,'=')"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:element>
                <xsl:if test="starts-with($operatortext,'cell-content-is-between') or starts-with($operatortext,'cell-content-is-not-between')">
                    <xsl:element name="表:第二操作数">
                        <xsl:attribute name="uof:locID">s0011</xsl:attribute>
                        <xsl:value-of select="substring-before(substring-after($operatortext,','),')')"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="starts-with($conditiontext,'oooc:cell-content-text-length-is-not-between') or starts-with($conditiontext,'oooc:cell-content-text-length-is-between')">
                    <xsl:element name="表:第二操作数">
                        <xsl:attribute name="uof:locID">s0011</xsl:attribute>
                        <xsl:value-of select="substring-before(substring-after($conditiontext,','),')')"/>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="表:忽略空格">
                    <xsl:attribute name="uof:locID">s0012</xsl:attribute>
                    <xsl:attribute name="uof:attrList">值</xsl:attribute>
                    <xsl:attribute name="表:值"><xsl:value-of select="@table:allow-empty-cell"/></xsl:attribute>
                </xsl:element>
                <xsl:if test="contains($conditiontext,'cell-content-is-in-list') ">
                    <xsl:element name="表:下拉箭头">
                        <xsl:attribute name="uof:locID">s0013</xsl:attribute>
                        <xsl:attribute name="uof:attrList">值</xsl:attribute>
                        <xsl:attribute name="表:值">false</xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="table:help-message">
                    <xsl:element name="表:输入提示">
                        <xsl:attribute name="uof:locID">s0014</xsl:attribute>
                        <xsl:attribute name="uof:attrList">显示 标题 内容</xsl:attribute>
                        <xsl:attribute name="表:显示"><xsl:value-of select="table:help-message/@table:display"/></xsl:attribute>
                        <xsl:attribute name="表:标题"><xsl:choose><xsl:when test="table:help-message/@table:title"><xsl:value-of select="table:help-message/@table:title"/></xsl:when><xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:variable name="content">
                            <xsl:call-template name="create-help-error-message-content">
                                <xsl:with-param name="text-p-set" select="table:help-message/text:p"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="表:内容"><xsl:value-of select="$content"/></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="table:error-message">
                    <xsl:element name="表:错误提示">
                        <xsl:attribute name="uof:locID">s0015</xsl:attribute>
                        <xsl:attribute name="uof:attrList">显示 类型 标题 内容</xsl:attribute>
                        <xsl:attribute name="表:显示"><xsl:value-of select="table:error-message/@table:display"/></xsl:attribute>
                        <xsl:attribute name="表:类型"><xsl:value-of select="table:error-message/@table:message-type"/></xsl:attribute>
                        <xsl:attribute name="表:标题"><xsl:choose><xsl:when test="table:error-message/@table:title"><xsl:value-of select="table:error-message/@table:title"/></xsl:when><xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:variable name="content">
                            <xsl:call-template name="create-help-error-message-content">
                                <xsl:with-param name="text-p-set" select="table:error-message/text:p"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="表:内容"><xsl:value-of select="$content"/></xsl:attribute>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="search-left-top-validation">
        <xsl:param name="validation-name"/>
        <xsl:param name="tableslist"/>
        <xsl:param name="return"/>
        <xsl:choose>
            <xsl:when test="$tableslist and $return=''">
                <xsl:variable name="firsttablerows" select="$tableslist[1]//table:table-row"/>
                <xsl:variable name="first-left-top">
                    <xsl:call-template name="search-left-top-validation-inatable">
                        <xsl:with-param name="row-num" select="'1'"/>
                        <xsl:with-param name="firsttablerows" select="$firsttablerows"/>
                        <xsl:with-param name="validation-name" select="$validation-name"/>
                        <xsl:with-param name="return" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="rest-left-top">
                    <xsl:call-template name="search-left-top-validation">
                        <xsl:with-param name="validation-name" select="$validation-name"/>
                        <xsl:with-param name="tableslist" select="$tableslist[position()!=1]"/>
                        <xsl:with-param name="return" select="$first-left-top"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$first-left-top!=''">
                        <xsl:value-of select="$first-left-top"/>
                    </xsl:when>
                    <xsl:when test="$rest-left-top!=''">
                        <xsl:value-of select="$rest-left-top"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$return"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="translate-left-top">
        <xsl:param name="left-top"/>
        <xsl:variable name="column-number" select="substring-before(substring-after($left-top,'.'),' ')"/>
        <xsl:variable name="column-number1">
            <xsl:value-of select="floor( $column-number div 26 )"/>
        </xsl:variable>
        <xsl:variable name="column-number2">
            <xsl:value-of select="$column-number mod 26"/>
        </xsl:variable>
        <xsl:variable name="column-character1">
            <xsl:call-template name="number-to-character">
                <xsl:with-param name="number" select="$column-number1"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="column-character2">
            <xsl:call-template name="number-to-character">
                <xsl:with-param name="number" select="$column-number2"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat(substring-before($left-top,'.'),'.','$',$column-character1,$column-character2,'$',substring-after($left-top,' '))"/>
    </xsl:template>
    <xsl:template name="create-help-error-message-content">
        <xsl:param name="text-p-set"/>
        <xsl:if test="$text-p-set">
            <!--此处有问题！！！！应该是有一个模块调用等-->
            <!--xsl:value-of select="'&#10;'"/-->
            <xsl:value-of select="$text-p-set"/>
            <xsl:call-template name="create-help-error-message-content">
                <xsl:with-param name="text-p-set" select="$text-p-set[position()!=1]"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="search-left-top-validation-inatable">
        <xsl:param name="row-num"/>
        <xsl:param name="firsttablerows"/>
        <xsl:param name="validation-name"/>
        <xsl:param name="return"/>
        <xsl:choose>
            <xsl:when test="$firsttablerows and $return=''">
                <xsl:variable name="firstcells" select="$firsttablerows[1]/table:table-cell"/>
                <xsl:variable name="first-left-top">
                    <xsl:call-template name="search-left-top-validation-inarow">
                        <xsl:with-param name="row-num" select="$row-num"/>
                        <xsl:with-param name="column-num" select="'1'"/>
                        <xsl:with-param name="firstcells" select="$firstcells"/>
                        <xsl:with-param name="validation-name" select="$validation-name"/>
                        <xsl:with-param name="return" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="row-num-p">
                    <xsl:choose>
                        <xsl:when test="$firsttablerows[1]/@table:number-rows-repeated">
                            <xsl:value-of select="$row-num+ $firsttablerows[1]/@table:number-rows-repeated"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$row-num+1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rest-left-top">
                    <xsl:call-template name="search-left-top-validation-inatable">
                        <xsl:with-param name="row-num" select="$row-num-p"/>
                        <xsl:with-param name="firsttablerows" select="$firsttablerows[position()!=1]"/>
                        <xsl:with-param name="validation-name" select="$validation-name"/>
                        <xsl:with-param name="return" select="$first-left-top"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$first-left-top!=''">
                        <xsl:value-of select="$first-left-top"/>
                    </xsl:when>
                    <xsl:when test="$rest-left-top !=''">
                        <xsl:value-of select="$rest-left-top "/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$return"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="number-to-character">
        <xsl:param name="number"/>
        <xsl:choose>
            <xsl:when test="$number =  0"/>
            <xsl:when test="$number =  1">A</xsl:when>
            <xsl:when test="$number =  2">B</xsl:when>
            <xsl:when test="$number =  3">C</xsl:when>
            <xsl:when test="$number =  4">D</xsl:when>
            <xsl:when test="$number =  5">E</xsl:when>
            <xsl:when test="$number =  6">F</xsl:when>
            <xsl:when test="$number =  7">G</xsl:when>
            <xsl:when test="$number =  8">H</xsl:when>
            <xsl:when test="$number =  9">I</xsl:when>
            <xsl:when test="$number = 10">J</xsl:when>
            <xsl:when test="$number = 11">K</xsl:when>
            <xsl:when test="$number = 12">L</xsl:when>
            <xsl:when test="$number = 13">M</xsl:when>
            <xsl:when test="$number = 14">N</xsl:when>
            <xsl:when test="$number = 15">O</xsl:when>
            <xsl:when test="$number = 16">P</xsl:when>
            <xsl:when test="$number = 17">Q</xsl:when>
            <xsl:when test="$number = 18">R</xsl:when>
            <xsl:when test="$number = 19">S</xsl:when>
            <xsl:when test="$number = 20">T</xsl:when>
            <xsl:when test="$number = 21">U</xsl:when>
            <xsl:when test="$number = 22">V</xsl:when>
            <xsl:when test="$number = 23">W</xsl:when>
            <xsl:when test="$number = 24">X</xsl:when>
            <xsl:when test="$number = 25">Y</xsl:when>
            <xsl:when test="$number = 26">Z</xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="search-left-top-validation-inacell">
        <xsl:param name="row-num"/>
        <xsl:param name="column-num"/>
        <xsl:param name="cell"/>
        <xsl:param name="validation-name"/>
        <xsl:choose>
            <xsl:when test="$cell/@table:content-validation-name=$validation-name">
                <xsl:value-of select="concat($cell/ancestor::table:table/@table:name,'.',$column-num,' ',$row-num)"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="search-left-top-validation-inarow">
        <xsl:param name="row-num"/>
        <xsl:param name="column-num"/>
        <xsl:param name="firstcells"/>
        <xsl:param name="validation-name"/>
        <xsl:param name="return"/>
        <xsl:choose>
            <xsl:when test="$firstcells and $return=''">
                <xsl:variable name="firstcell" select="$firstcells[1]"/>
                <xsl:variable name="first-left-top">
                    <xsl:call-template name="search-left-top-validation-inacell">
                        <xsl:with-param name="row-num" select="$row-num"/>
                        <xsl:with-param name="column-num" select="$column-num"/>
                        <xsl:with-param name="cell" select="$firstcell"/>
                        <xsl:with-param name="validation-name" select="$validation-name"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="column-num-p">
                    <xsl:choose>
                        <xsl:when test="$firstcell/@table:number-columns-repeated">
                            <xsl:value-of select="$column-num+ $firstcell/@table:number-columns-repeated"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$column-num+ 1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rest-left-top">
                    <xsl:call-template name="search-left-top-validation-inarow">
                        <xsl:with-param name="row-num" select="$row-num"/>
                        <xsl:with-param name="column-num" select="$column-num-p"/>
                        <xsl:with-param name="firstcells" select="$firstcells[position()!=1]"/>
                        <xsl:with-param name="validation-name" select="$validation-name"/>
                        <xsl:with-param name="return" select="$first-left-top"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$first-left-top!=''">
                        <xsl:value-of select="$first-left-top"/>
                    </xsl:when>
                    <xsl:when test="$rest-left-top !=''">
                        <xsl:value-of select="$rest-left-top "/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$return"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
