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
    <!--xsl:key name="colWidth" match="/office:automatic/style:style/" use="@style:column-width"/-->
    <xsl:variable name="swValueWithUnit">
        <xsl:value-of select="/office:document/office:automatic-styles/style:page-layout/style:page-layout-properties/@fo:page-width"/>
    </xsl:variable>
    <xsl:variable name="uofUnit">
        <xsl:choose>
            <xsl:when test="contains($swValueWithUnit,'in')">inch</xsl:when>
            <xsl:when test="contains($swValueWithUnit,'cm')">cm</xsl:when>
            <xsl:when test="contains($swValueWithUnit,'mm')">mm</xsl:when>
            <xsl:when test="contains($swValueWithUnit,'pt')">pt</xsl:when>
            <xsl:otherwise>inch</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="ooUnit">
        <xsl:choose>
            <xsl:when test="contains($swValueWithUnit,'in')">inch</xsl:when>
            <xsl:when test="contains($swValueWithUnit,'cm')">cm</xsl:when>
            <xsl:when test="contains($swValueWithUnit,'mm')">mm</xsl:when>
            <xsl:when test="contains($swValueWithUnit,'pt')">pt</xsl:when>
            <xsl:otherwise>inch</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:apply-templates select="office:document"/>
    </xsl:template>
    <xsl:template match="office:document">
        <uof:UOF xmlns:uof="http://schemas.uof.org/cn/2003/uof" xmlns:表="http://schemas.uof.org/cn/2003/uof-spreadsheet" xmlns:演="http://schemas.uof.org/cn/2003/uof-slideshow" xmlns:字="http://schemas.uof.org/cn/2003/uof-wordproc" xmlns:图="http://schemas.uof.org/cn/2003/graph" uof:language="cn" uof:locID="u0000" uof:version="1.0" uof:mimetype="vnd.uof.text">
            <xsl:apply-templates select="office:meta"/>
            <xsl:if test="/office:document/office:body/office:text/text:p/text:bookmark-start|/office:document/office:body/office:text/text:p/text:bookmark">
                <uof:书签集 uof:locID="u0027">
                    <xsl:for-each select="/office:document/office:body/office:text/text:p/text:bookmark-start|/office:document/office:body/office:text/text:p/text:bookmark">
                        <uof:书签 uof:locID="u0028" uof:attrList="名称">
                            <xsl:attribute name="uof:名称"><xsl:value-of select="@text:name"/></xsl:attribute>
                            <uof:文本位置 uof:locID="u0029" uof:attrList="区域引用">
                                <xsl:attribute name="字:区域引用"><xsl:value-of select="generate-id()"/></xsl:attribute>
                            </uof:文本位置>
                        </uof:书签>
                    </xsl:for-each>
                </uof:书签集>
            </xsl:if>
            <xsl:if test="/office:document/office:body/office:text/text:p/text:a | /office:document/office:body/office:text/text:p/draw:a | /office:document/office:body/office:text/table:table/table:table-row/table:table-cell/text:p/text:a | /office:document/office:body/office:text/text:table-of-content/text:index-body/text:p/text:a">
                <uof:链接集 uof:locID="u0031">
                    <xsl:for-each select="/office:document/office:body/office:text/text:p/text:a | /office:document/office:body/office:text/text:p/draw:a | /office:document/office:body/office:text/table:table/table:table-row/table:table-cell/text:p/text:a | /office:document/office:body/office:text/text:table-of-content/text:index-body/text:p/text:a">
                        <xsl:variable name="hyperStr" select="@xlink:href"/>
                        <uof:超级链接 uof:locID="u0032" uof:attrList="标识符 目标 书签 式样引用 已访问式样引用 提示 链源">
                            <xsl:if test="contains($hyperStr,'#')">
                                <xsl:attribute name="uof:书签"><xsl:value-of select="substring-after($hyperStr,'#')"/></xsl:attribute>
                            </xsl:if>
                            <xsl:variable name="num">
                                <xsl:number from="/office:document/office:body/office:text" level="any" count="text:a | table:table/table:table-row/table:table-cell/text:a"/>
                            </xsl:variable>
                            <xsl:attribute name="uof:链源"><xsl:value-of select="concat('hlnk',$num)"/></xsl:attribute>
                            <xsl:attribute name="uof:标识符"><xsl:value-of select="concat('hyk_','hlnk',$num)"/></xsl:attribute>
                            <xsl:if test="not(contains($hyperStr,'#'))">
                                <xsl:attribute name="uof:目标"><xsl:value-of select="$hyperStr"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@office:name">
                                <xsl:attribute name="uof:提示"><xsl:value-of select="@office:name"/></xsl:attribute>
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
            <uof:式样集 uof:locID="u0039">
                <xsl:apply-templates select="office:font-face-decls"/>
                <xsl:call-template name="自动编号集"/>
                <xsl:call-template name="shiyang"/>
                <xsl:apply-templates select="office:automatic-styles/style:style" mode="style"/>
            </uof:式样集>
            <uof:对象集 uof:locID="u0033">
                <xsl:for-each select="/office:document/office:body/office:text/draw:*">
                    <xsl:variable name="nodename1">
                        <xsl:value-of select="name()"/>
                    </xsl:variable>
                    <xsl:call-template name="draw">
                        <xsl:with-param name="nodename1" select="$nodename1"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:apply-templates select="/office:document/office:body/office:text//text:p" mode="styles"/>
                <xsl:apply-templates select="/office:document/office:master-styles/style:master-page/style:header/text:p" mode="styles"/>
                <xsl:apply-templates select="/office:document/office:master-styles/style:master-page/style:footer/text:p" mode="styles"/>
                <xsl:for-each select="(/office:document/office:styles/style:style/style:paragraph-properties/style:background-image) | (/office:document/office:automatic-styles/style:style/style:paragraph-properties/style:background-image) | (/office:document/office:automatic-styles/style:page-layout/style:page-layout-properties/style:background-image) | /office:document/office:automatic-styles/style:style/style:table-cell-properties/style:background-image | /office:document/office:automatic-styles/style:style/style:table-properties/style:background-image | /office:document/office:automatic-styles/style:style/style:graphic-properties/style:background-image">
                    <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                        <xsl:attribute name="uof:标识符"><xsl:value-of select="concat('background-image_',count(preceding::style:background-image))"/></xsl:attribute>
                        <xsl:attribute name="uof:公共类型">png</xsl:attribute>
                        <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                        <uof:数据 uof:locID="u0037">
                            <xsl:value-of select="office:binary-data"/>
                        </uof:数据>
                    </uof:其他对象>
                </xsl:for-each>
                <xsl:for-each select="(/office:document/office:styles/text:list-style/text:list-level-style-image) | (/office:document/office:automatic-styles/text:list-style/text:list-level-style-image)">
                    <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                        <xsl:attribute name="uof:标识符"><xsl:value-of select="concat('image_numbering_',count(preceding::text:list-level-style-image))"/></xsl:attribute>
                        <xsl:attribute name="uof:公共类型">png</xsl:attribute>
                        <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                        <uof:数据 uof:locID="u0037">
                            <xsl:value-of select="office:binary-data"/>
                        </uof:数据>
                    </uof:其他对象>
                </xsl:for-each>
                <xsl:for-each select="/office:document/office:styles/draw:fill-image">
                    <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                        <xsl:attribute name="uof:标识符"><xsl:value-of select="@draw:name"/></xsl:attribute>
                        <xsl:attribute name="uof:公共类型">png</xsl:attribute>
                        <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                        <uof:数据 uof:locID="u0037">
                            <xsl:value-of select="office:binary-data"/>
                        </uof:数据>
                    </uof:其他对象>
                </xsl:for-each>
                <!--xsl:apply-templates select="/office:document/office:automatic-styles/style:style[@style:family = 'graphics']"/>
                <xsl:apply-templates select="office:styles/style:style[@style:family = 'graphics']"/>
                <xsl:apply-templates select="office:styles/style:default-style [@style:family = 'graphics']"/-->
            </uof:对象集>
            <uof:文字处理 uof:locID="u0047">
                <字:公用处理规则 uof:locID="t0000">
                    <xsl:apply-templates select="office:settings"/>
                    <xsl:call-template name="GetUsers"/>
                    <xsl:call-template name="GetTrackChanges"/>
                    <xsl:call-template name="GetAnnotations"/>
                </字:公用处理规则>
                <字:主体 uof:locID="t0016">
                    <xsl:for-each select="office:automatic-styles/style:page-layout[@style:name='pm1']">
                        <xsl:call-template name="style:page-layout"/>
                    </xsl:for-each>
                    <!--xsl:call-template name="office:automatic-styles/style:page-layout[@style:name='pm1']"/-->
                    <!--xsl:apply-templates select="office:automatic-styles/style:page-layout[@style:name='pm1']"/-->
                    <xsl:apply-templates select="office:body/office:text"/>
                    <xsl:call-template name="logic-chapter"/>
                </字:主体>
            </uof:文字处理>
        </uof:UOF>
    </xsl:template>
    <xsl:template name="logic-chapter">
        <xsl:element name="字:逻辑章节">
            <xsl:attribute name="uof:locID">t0050</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template name="GetAnnotations">
        <xsl:if test="/*/office:body/office:text//office:annotation ">
            <字:批注集 uof:locID="t0014">
                <xsl:for-each select="/*/office:body/office:text//office:annotation">
                    <字:批注 uof:locID="t0015" uof:attrList="区域引用 作者 日期 作者缩写">
                        <xsl:attribute name="字:作者"><xsl:value-of select="generate-id()"/></xsl:attribute>
                        <xsl:attribute name="字:日期"><xsl:value-of select="dc:date"/></xsl:attribute>
                        <xsl:attribute name="字:区域引用">cmt<xsl:number from="/office:document/office:body/office:text" level="any" count="office:annotation"/></xsl:attribute>
                        <xsl:for-each select="./node()">
                            <xsl:choose>
                                <xsl:when test="name()='text:p'">
                                    <xsl:call-template name="execParagraph">
                                        <xsl:with-param name="currlistlvl" select="number('0')"/>
                                        <xsl:with-param name="liststylename" select="string('00000')"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="name()='table:table'">
                                    <xsl:call-template name="exec_table"/>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </xsl:for-each>
                    </字:批注>
                </xsl:for-each>
            </字:批注集>
        </xsl:if>
    </xsl:template>
    <xsl:template name="GetTrackChanges">
        <xsl:if test="/*/office:body/office:text/text:tracked-changes">
            <字:修订信息集 uof:locID="t0012">
                <xsl:for-each select="/*/office:body/office:text/text:tracked-changes/text:changed-region">
                    <字:修订信息 字:标识符="{@text:id}" 字:作者="{generate-id()}" 字:日期="{node()//office:change-info/dc:date}" uof:locID="t0013" uof:attrList="标识符 作者 日期"/>
                </xsl:for-each>
            </字:修订信息集>
        </xsl:if>
    </xsl:template>
    <xsl:template name="GetUsers">
        <xsl:if test="/*/office:body/office:text/text:tracked-changes//office:change-info/dc:creator or //office:annotation/@office:author or //office:annotation/dc:creator">
            <字:用户集 uof:locID="t0010">
                <xsl:for-each select="/*/office:body/office:text/text:tracked-changes/text:changed-region">
                    <字:用户 字:标识符="{generate-id()}" 字:姓名="{node()//office:change-info/dc:creator}" uof:locID="t0011" uof:attrList="标识符 姓名"/>
                </xsl:for-each>
                <xsl:for-each select="//office:annotation">
                    <字:用户 字:标识符="{generate-id()}" 字:姓名="{dc:creator}" uof:locID="t0011" uof:attrList="标识符 姓名"/>
                </xsl:for-each>
            </字:用户集>
        </xsl:if>
    </xsl:template>
    <xsl:key match="/office:document/office:automatic-styles/style:style | /office:document/office:styles/style:style" name="graphicset" use="@style:name"/>
    <xsl:template match="text:p" mode="styles">
        <xsl:for-each select="child::*">
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
                <xsl:call-template name="creategraphicstyles"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="draw:g">
        <xsl:variable name="picnumber1">
            <xsl:value-of select="count(preceding::draw:g)"/>
        </xsl:variable>
        <图:图形 uof:locID="g0000" uof:attrList="层次 标识符 组合列表 其他对象">
            <xsl:attribute name="图:标识符"><xsl:value-of select="concat(@draw:style-name,'_',$picnumber1)"/></xsl:attribute>
            <xsl:attribute name="图:层次"><xsl:choose><xsl:when test="name(parent::node())='draw:g'"><xsl:value-of select="position()"/></xsl:when><xsl:when test="@draw:z-index"><xsl:value-of select="@draw:z-index"/></xsl:when><xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise></xsl:choose></xsl:attribute>
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
        </xsl:for-each>
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
    <xsl:template name="creategraphicstyles">
        <xsl:variable name="nodename">
            <xsl:value-of select="name()"/>
        </xsl:variable>
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
    </xsl:template>
    <!--xsl:key match="/office:document/office:automatic-styles/style:style" name="graphicset" use="@style:name"/>

    <xsl:template match="style:style[@style:family = 'graphics']">
        <xsl:variable name="pic-name">
            <xsl:value-of select="@style:name"/>
        </xsl:variable>
        <xsl:variable name="pic-num">
            <xsl:value-of select="count(/descendant::*[@draw:style-name=$pic-name])"/>
        </xsl:variable>
        <xsl:call-template name="pic-process">
            <xsl:with-param name="pic-name" select="$pic-name"/>
            <xsl:with-param name="pic-num" select="$pic-num"/>
            <xsl:with-param name="current-num" select="1"/>
        </xsl:call-template>
    </xsl:template-->
    <xsl:template name="pic-process">
        <xsl:param name="pic-name"/>
        <xsl:param name="nodename"/>
        <xsl:param name="picnumber"/>
        <图:图形 uof:locID="g0000" uof:attrList="层次 标识符 组合列表 其他对象">
            <xsl:attribute name="图:标识符"><xsl:value-of select="concat($pic-name,'_',$picnumber)"/></xsl:attribute>
            <xsl:attribute name="图:层次"><xsl:value-of select="@draw:z-index"/></xsl:attribute>
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
                <xsl:when test="$nodename='draw:line' or $nodename='draw:rect' or $nodename='draw:circle' or $nodename='draw:polygon' or $nodename='draw:polyline' or $nodename='draw:ellipse' or $nodename='draw:path'or $nodename='draw:g' or $nodename='draw:text-box' or child::draw:text-box">
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
                                <xsl:when test="child::draw:text-box[@fo:min-height]">22</xsl:when>
                                <xsl:when test="child::draw:text-box">23</xsl:when>
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
                                <xsl:when test="$nodename='draw:frame' and  child::draw:text-box[@fo:min-height]">排版框</xsl:when>
                                <xsl:when test="$nodename='draw:frame' and child::draw:text-box">排版框</xsl:when>
                            </xsl:choose>
                        </图:名称>
                        <图:生成软件 uof:locID="g0008">PNG</图:生成软件>
                        <xsl:if test="./@draw:points or ./@svg:d">
                            <图:关键点坐标 uof:locID="g0009" uof:attrList="路径">
                                <xsl:attribute name="图:路径"><xsl:choose><xsl:when test="@svg:d"><xsl:value-of select="@svg:d"/></xsl:when><xsl:when test="@draw:points"><xsl:call-template name="draw:points"><xsl:with-param name="point" select="@draw:points"/><xsl:with-param name="lujing"/></xsl:call-template></xsl:when></xsl:choose></xsl:attribute>
                            </图:关键点坐标>
                        </xsl:if>
                        <图:属性 uof:locID="g0011">
                            <xsl:for-each select="(/office:document/office:styles/descendant::*[@style:name=$pic-name]) | (/office:document/office:automatic-styles/descendant::*[@style:name=$pic-name]) ">
                                <xsl:if test="style:graphic-properties/@draw:fill-color  or  style:graphic-properties/@fo:background-color or style:graphic-properties/@draw:fill-image-name or style:graphic-properties/@draw:fill-gradient-name">
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
                                            <xsl:when test="style:graphic-properties/@draw:fill-image-name or style:graphic-properties/style:background-image/office:binary-data">
                                                <xsl:choose>
                                                    <xsl:when test="style:graphic-properties/@draw:fill-image-name">
                                                        <图:图片 uof:locID="g0035" uof:attrList="位置 图形引用 类型 名称">
                                                            <xsl:attribute name="图:位置"><xsl:choose><xsl:when test="not(style:graphic-properties/@style:repeat)">tile</xsl:when><xsl:otherwise><xsl:choose><xsl:when test="style:graphic-properties/@style:repeat  = 'stretch'">stretch</xsl:when><xsl:when test="style:graphic-properties/@style:repeat = 'repeat'">tile</xsl:when><xsl:when test="style:graphic-properties/@style:repeat = 'no-repeat'">center</xsl:when></xsl:choose></xsl:otherwise></xsl:choose></xsl:attribute>
                                                            <xsl:attribute name="图:图形引用"><xsl:value-of select="concat($pic-name,'_b1')"/></xsl:attribute>
                                                            <xsl:attribute name="图:类型">png</xsl:attribute>
                                                            <xsl:attribute name="图:名称"><xsl:value-of select="style:graphic-properties/@draw:fill-image-name"/></xsl:attribute>
                                                        </图:图片>
                                                    </xsl:when>
                                                    <xsl:when test="style:graphic-properties/style:background-image/office:binary-data">
                                                        <xsl:for-each select="style:graphic-properties">
                                                            <xsl:call-template name="图:填充"/>
                                                        </xsl:for-each>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:when test="style:graphic-properties/@draw:fill='hatch'">
                                                <图:图案 uof:locID="g0036" uof:attrList="类型 图形引用 前景色 背景色">
                                                    <xsl:attribute name="图:类型"><xsl:value-of select="/office:document/office:styles/draw:hatch/@draw:name"/></xsl:attribute>
                                                    <xsl:attribute name="图:图形引用"/>
                                                    <xsl:attribute name="图:前景色"><xsl:value-of select="/office:document/office:styles/draw:hatch/@draw:color"/></xsl:attribute>
                                                    <xsl:attribute name="图:背景色"><xsl:choose><xsl:when test="style:graphic-properties/@draw:fill-color"><xsl:value-of select="style:graphic-properties/@draw:fill-color"/></xsl:when><xsl:otherwise>#ffffff</xsl:otherwise></xsl:choose></xsl:attribute>
                                                </图:图案>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <图:颜色 uof:locID="g0034">
                                                    <xsl:choose>
                                                        <xsl:when test="style:graphic-properties/@draw:fill-color">
                                                            <xsl:value-of select="style:graphic-properties/@draw:fill-color"/>
                                                        </xsl:when>
                                                        <xsl:when test="style:graphic-properties/@fo:background-color">
                                                            <xsl:value-of select="style:graphic-properties/@fo:background-color"/>
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
                                    <xsl:variable name="linetype" select="style:graphic-properties/@draw:stroke-dash"/>
                                    <xsl:choose>
                                        <xsl:when test="style:graphic-properties/@fo:border='none'">none</xsl:when>
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
                                                        <xsl:when test="$linetype='2 Dots 1 Dash' and style:graphic-properties/@svg:stroke-width">dash-dot-dot-heavy</xsl:when>
                                                        <xsl:when test="$linetype='2 Dots 1 Dash'">dot-dot-dash</xsl:when>
                                                        <xsl:when test="$linetype='Ultrafine Dashed' and style:graphic-properties/@svg:stroke-width">dashed-heavy</xsl:when>
                                                        <xsl:when test="$linetype='Ultrafine Dotted (var)'and style:graphic-properties/@svg:stroke-width">dotted-heavy</xsl:when>
                                                        <xsl:when test="$linetype='Ultrafine Dotted (var)'">dotted</xsl:when>
                                                        <xsl:when test="$linetype='Line with Fine Dots'">double</xsl:when>
                                                        <xsl:when test="$linetype='3 Dashes 3 Dots (var)' and style:graphic-properties/@svg:stroke-width">dash-dot-heavy</xsl:when>
                                                        <xsl:when test="$linetype='3 Dashes 3 Dots (var)'">dot-dash</xsl:when>
                                                        <xsl:when test="$linetype='Ultrafine 2 Dots 3 Dashes'and style:graphic-properties/@svg:stroke-width">wavy-heavy</xsl:when>
                                                        <xsl:when test="$linetype='Ultrafine 2 Dots 3 Dashes'">wave</xsl:when>
                                                        <xsl:when test="$linetype='Fine Dashed (var)'">wavy-double</xsl:when>
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
                                                <xsl:when test="style:graphic-properties/@draw:marker-start='Line Arrow'">open</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-start='Arrow concave'">stealth</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-start='Circle'">oval</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-start='Square 45'">diamond</xsl:when>
                                                <xsl:otherwise>normal</xsl:otherwise>
                                            </xsl:choose>
                                        </图:式样>
                                        <图:大小 uof:locID="g0019">
                                            <xsl:choose>
                                                <xsl:when test="not(style:graphic-properties/@draw:marker-start-width)">4</xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:call-template name="graphsize">
                                                        <xsl:with-param name="width" select="substring-before(style:graphic-properties/@draw:marker-start-width,$uofUnit)"/>
                                                        <xsl:with-param name="Unitofsize" select="$uofUnit"/>
                                                    </xsl:call-template>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </图:大小>
                                    </图:前端箭头>
                                </xsl:if>
                                <xsl:if test="style:graphic-properties/@draw:marker-end">
                                    <图:后端箭头 uof:locID="g0017">
                                        <图:式样 uof:locID="g0018">
                                            <xsl:choose>
                                                <xsl:when test="style:graphic-properties/@draw:marker-end='Arrow'">normal</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-end='Line Arrow'">open</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-end='Arrow concave'">stealth</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-end='Circle'">oval</xsl:when>
                                                <xsl:when test="style:graphic-properties/@draw:marker-end='Square 45'">diamond</xsl:when>
                                                <xsl:otherwise>normal</xsl:otherwise>
                                            </xsl:choose>
                                        </图:式样>
                                        <图:大小 uof:locID="g0022">
                                            <xsl:choose>
                                                <xsl:when test="not(style:properties/@draw:marker-start-width)">4</xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:variable name="width">
                                                        <xsl:value-of select="substring-before(style:graphic-properties/@draw:marker-end-width,$uofUnit)"/>
                                                    </xsl:variable>
                                                    <xsl:choose>
                                                        <xsl:when test="(not($width&gt;0.05) and 0&lt;$width) or $width=0.05">1</xsl:when>
                                                        <xsl:when test="(not($width&gt;0.10) and 0.05&lt;$width) or $width=0.10">2</xsl:when>
                                                        <xsl:when test="(not($width&gt;0.15) and 0.10&lt;$width) or $width=0.15">3</xsl:when>
                                                        <xsl:when test="(not($width&gt;0.20) and 0.15&lt;$width) or $width=0.20">4</xsl:when>
                                                        <xsl:when test="(not($width&gt;0.25) and 0.20&lt;$width) or $width=0.25">5</xsl:when>
                                                        <xsl:when test="(not($width&gt;0.30) and 0.25&lt;$width) or $width=0.30">6</xsl:when>
                                                        <xsl:when test="(not($width&gt;0.35) and 0.30&lt;$width) or $width=0.35">7</xsl:when>
                                                        <xsl:when test="(not($width&gt;0.40) and 0.35&lt;$width) or $width=0.40">8</xsl:when>
                                                        <xsl:otherwise>9</xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </图:大小>
                                    </图:后端箭头>
                                </xsl:if>
                                <xsl:if test="style:graphic-properties/@draw:opacity or style:graphic-properties/@draw:transparency">
                                    <图:透明度 uof:locID="g0038">
                                        <xsl:choose>
                                            <xsl:when test="style:graphic-properties/@draw:transparency">
                                                <xsl:value-of select="substring-before(style:graphic-properties/@draw:transparency,'%')"/>
                                            </xsl:when>
                                            <xsl:when test="style:graphic-properties/@draw:opacity">
                                                <xsl:value-of select="100 - substring-before(style:graphic-properties/@draw:opacity,'%')"/>
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
                                <xsl:when test="child::draw:text-box/@fo:min-height">
                                    <图:宽度 uof:locID="g0023">
                                        <xsl:value-of select="substring-before(@svg:width,$uofUnit)"/>
                                    </图:宽度>
                                    <图:高度 uof:locID="g0024">
                                        <xsl:value-of select="substring-before(child::draw:text-box/@fo:min-height,$uofUnit)"/>
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
                <xsl:when test="name()='draw:path'">
                    <图:svg图形对象 图:version="1.1" 图:xmlns_xlink="http://www.w3.org/1999/xlink">
                        <xsl:attribute name="图:x"><xsl:value-of select="@svg:x"/></xsl:attribute>
                        <xsl:attribute name="图:y"><xsl:value-of select="@svg:y"/></xsl:attribute>
                        <xsl:attribute name="图:width"><xsl:value-of select="@svg:width"/></xsl:attribute>
                        <xsl:attribute name="图:height"><xsl:value-of select="@svg:height"/></xsl:attribute>
                        <xsl:attribute name="图:viewBox"><xsl:value-of select="@svg:viewBox"/></xsl:attribute>
                        <图:path>
                            <xsl:attribute name="图:d"><xsl:value-of select="@svg:d"/></xsl:attribute>
                        </图:path>
                    </图:svg图形对象>
                </xsl:when>
            </xsl:choose>
            <图:文本内容 uof:locID="g0002" uof:attrList="文本框 左边距 右边距 上边距 下边距 水平对齐 垂直对齐 文字排列方向 自动换行 大小适应文字 前一链接 后一链接">
                <xsl:if test="./draw:text-box">
                    <xsl:attribute name="图:文本框">true</xsl:attribute>
                    <xsl:if test="./@draw:name = /office:document/office:body/office:text//draw:text-box/@draw:chain-next-name">
                        <xsl:attribute name="图:前一链接"><xsl:variable name="drawname"><xsl:value-of select="./@draw:name"/></xsl:variable><xsl:variable name="befor-link-name"><xsl:value-of select="/office:document/office:body/office:text//draw:text-box[@draw:name=$drawname]/@draw:style-name"/></xsl:variable><xsl:value-of select="concat($befor-link-name,'_',$picnumber)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="./@draw:chain-next-name">
                        <xsl:attribute name="图:后一链接"><xsl:variable name="next-link"><xsl:value-of select="./@draw:chain-next-name"/></xsl:variable><xsl:variable name="link-name"><xsl:value-of select="/office:document/office:body/office:text//draw:text-box[@draw:name=$next-link]/@draw:style-name"/></xsl:variable><xsl:value-of select="concat($link-name,'_',$picnumber)"/></xsl:attribute>
                    </xsl:if>
                </xsl:if>
                <xsl:for-each select="(/office:document/office:styles/descendant::*[@style:name=$pic-name]) | (/office:document/office:automatic-styles/descendant::*[@style:name=$pic-name]) ">
                    <xsl:if test="style:text-properties/@fo:padding-left">
                        <xsl:attribute name="图:左边距"><xsl:value-of select="style:text-properties/@fo:padding-left"/></xsl:attribute>
                        <xsl:attribute name="图:右边距"><xsl:value-of select="style:text-properties/@fo:padding-right"/></xsl:attribute>
                        <xsl:attribute name="图:上边距"><xsl:value-of select="style:text-properties/@fo:padding-top"/></xsl:attribute>
                        <xsl:attribute name="图:下边距"><xsl:value-of select="style:text-properties/@fo:padding-bottom"/></xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="图:文字排列方向"><xsl:choose><xsl:when test="style:paragraph-properties/@style:writing-mode"><xsl:choose><xsl:when test="style:paragraph-properties/@style:writing-mode='tb-lr'">vert-l2r</xsl:when><xsl:when test="style:paragraph-properties/@style:writing-mode='tb-rl'">vert-r2l</xsl:when></xsl:choose></xsl:when><xsl:when test="style:graphic-properties/@style:writing-mode='tb-lr'">vert-l2r</xsl:when><xsl:when test="style:graphic-properties/@style:writing-mode='tb-rl'">vert-r2l</xsl:when><xsl:when test="style:paragraph-properties/@draw:textarea-horizontal-align='right'">hori-r2l</xsl:when><xsl:otherwise>hori-l2r</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:if test="style:text-properties/@fo:wrap-option">
                        <xsl:attribute name="图:自动换行">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="style:graphic-properties/@draw:textarea-horizontal-align">
                        <xsl:attribute name="图:水平对齐"><xsl:value-of select="style:graphic-properties/@draw:textarea-horizontal-align"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="style:graphic-properties/@draw:textarea-vertical-align">
                        <xsl:attribute name="图:垂直对齐"><xsl:value-of select="style:graphic-properties/@draw:textarea-vertical-align"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="style:graphic-properties/@draw:auto-grow-width='true' and style:graphic-properties/@draw:auto-grow-height='true'">
                        <xsl:attribute name="图:大小适应文字"><xsl:choose><xsl:when test="style:graphic-properties/@draw:auto-grow-width='true' and style:graphic-properties/@draw:auto-grow-height='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="text:p">
                    <字:段落 uof:locID="t0051" uof:attrList="标识符">
                        <xsl:if test="style:paragraph-properties">
                            <字:段落属性 uof:locID="t0052" uof:attrList="式样引用">
                                <xsl:apply-templates select="style:paragraph-properties"/>
                            </字:段落属性>
                        </xsl:if>
                        <xsl:call-template name="textp"/>
                    </字:段落>
                </xsl:for-each>
                <xsl:for-each select="draw:text-box/text:p">
                    <字:段落 uof:locID="t0051" uof:attrList="标识符">
                        <xsl:if test="style:paragraph-properties">
                            <字:段落属性 uof:locID="t0052" uof:attrList="式样引用">
                                <xsl:apply-templates select="style:paragraph-properties"/>
                            </字:段落属性>
                        </xsl:if>
                        <xsl:call-template name="textp"/>
                    </字:段落>
                </xsl:for-each>
            </图:文本内容>
            <xsl:if test="@svg:x and @svg:y">
                <图:控制点 uof:locID="g0003" uof:attrList="x坐标 y坐标">
                    <xsl:attribute name="图:x坐标"><xsl:value-of select="substring-before(@svg:x,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="图:y坐标"><xsl:value-of select="substring-before(@svg:y,$uofUnit)"/></xsl:attribute>
                </图:控制点>
            </xsl:if>
        </图:图形>
        <xsl:if test="name()='draw:frame' and ./draw:image">
            <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                <xsl:attribute name="uof:标识符"><xsl:value-of select="concat($pic-name,'_',$picnumber)"/></xsl:attribute>
                <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                <xsl:variable name="pic">
                    <xsl:choose>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.png')">png</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.jpg')">jpg</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.gif')">gif</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.bmp')">bmp</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.pbm')">pbm</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.ras')">ras</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.txt')">text</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.xml')">xml</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.htm')">html</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.html')">html</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.wav')">wav</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.mid')">midi</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.ra')">ra</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.au')">au</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.mp3')">mp3</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.snd')">snd</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.svg')">svg</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.avi')">avi</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.mpeg')">mpeg4</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.qt')">qt</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.rm')">rm</xsl:when>
                        <xsl:when test="contains(./draw:image/@xlink:href,'.asf')">asf</xsl:when>
                        <xsl:otherwise>图片</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$pic!='图片'">
                        <xsl:attribute name="uof:公共类型"><xsl:value-of select="$pic"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="uof:私有类型">图片</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
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
            <xsl:if test="style:text-properties/@draw:fill-image-name">
                <uof:其他对象 uof:locID="u0036" uof:attrList="标识符 内嵌 公共类型 私有类型">
                    <xsl:attribute name="uof:标识符"><xsl:value-of select="concat($pic-name,'-b1')"/></xsl:attribute>
                    <xsl:attribute name="uof:公共类型">png</xsl:attribute>
                    <xsl:attribute name="uof:内嵌">true</xsl:attribute>
                    <xsl:variable name="fill-name">
                        <xsl:value-of select="style:text-properties/@draw:fill-image-name"/>
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
            <uof:创建者 uof:locID="u0004">
                <xsl:value-of select="meta:initial-creator"/>
            </uof:创建者>
            <!--uof:作者 uof:locID="u0005">
                <xsl:value-of select="meta:initial-creator"/>
            </uof:作者-->
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
            <!--xsl:if test="meta:document-statistic/@meta:page-count"-->
            <uof:页数 uof:locID="u0020">
                <xsl:value-of select="meta:document-statistic/@meta:page-count"/>
            </uof:页数>
            <!--/xsl:if-->
            <!--xsl:if test="meta:document-statistic/@meta:paragraph-count"-->
            <uof:段落数 uof:locID="u0025">
                <xsl:value-of select="meta:document-statistic/@meta:paragraph-count"/>
            </uof:段落数>
            <!--/xsl:if-->
            <!--xsl:if test="meta:document-statistic/@meta:object-count"-->
            <uof:对象数 uof:locID="u0026">
                <xsl:value-of select="meta:document-statistic/@meta:object-count"/>
            </uof:对象数>
            <!--/xsl:if-->
            <!--xsl:if test="meta:document-statistic/@meta:character-count"-->
            <uof:字数 uof:locID="u0021">
                <xsl:value-of select="meta:document-statistic/@meta:character-count"/>
            </uof:字数>
            <!--/xsl:if-->
            <!--xsl:if test="meta:document-statistic/@meta:word-count"-->
            <uof:中文字符数 uof:locID="u0023">
                <xsl:value-of select="meta:document-statistic/@meta:word-count"/>
            </uof:中文字符数>
            <!--/xsl:if-->
            <uof:英文字符数 uof:locID="u0022">
                <xsl:value-of select="meta:document-statistic/@meta:character-count - meta:document-statistic/@meta:word-count"/>
            </uof:英文字符数>
            <uof:行数 uof:locID="u0024">
                <xsl:variable name="quzhi">
                    <xsl:value-of select="(meta:document-statistic/@meta:character-count div 39) + 0.9"/>
                </xsl:variable>
                <xsl:value-of select="substring-before($quzhi,'.')"/>
            </uof:行数>
            <uof:分类 uof:locID="u0012">
                <xsl:value-of select="meta:user-defined[@meta:name='Category']"/>
            </uof:分类>
            <uof:经理名称 uof:locID="u0019">
                <xsl:value-of select="meta:user-defined[meta:name='Manager']"/>
            </uof:经理名称>
            <uof:公司名称 uof:locID="u0018">
                <xsl:value-of select="meta:user-defined[meta:name='Company']"/>
            </uof:公司名称>
        </uof:元数据>
    </xsl:template>
    <xsl:template match="office:font-face-decls">
        <uof:字体集 uof:locID="u0040">
            <xsl:for-each select="style:font-face">
                <xsl:element name="uof:字体声明">
                    <xsl:attribute name="uof:attrList">标识符 名称 字体族</xsl:attribute>
                    <xsl:attribute name="uof:locID">u0041</xsl:attribute>
                    <xsl:attribute name="uof:名称"><xsl:value-of select="@svg:font-family"/></xsl:attribute>
                    <xsl:attribute name="uof:标识符"><xsl:value-of select="translate(@style:name,' ','_')"/></xsl:attribute>
                    <xsl:if test="@style:font-charset= '02'">
                        <xsl:attribute name="uof:字符集">x-symbol</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@style:font-family-generic">
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
                    </xsl:if>
                </xsl:element>
            </xsl:for-each>
            <xsl:apply-templates select="style:font-decl"/>
        </uof:字体集>
    </xsl:template>
    <xsl:template name="自动编号集">
        <xsl:element name="uof:自动编号集">
            <xsl:attribute name="uof:locID">u0042</xsl:attribute>
            <xsl:for-each select="/office:document//text:list-style">
                <xsl:element name="字:自动编号">
                    <xsl:attribute name="uof:locID">t0169</xsl:attribute>
                    <xsl:attribute name="uof:attrList">标识符 名称 父编号引用 多级编号</xsl:attribute>
                    <xsl:attribute name="字:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
                    <xsl:if test=".//@text:style-name">
                        <xsl:attribute name="字:名称"><xsl:value-of select=".//@text:style-name"/></xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="字:多级编号">true</xsl:attribute>
                    <xsl:for-each select="./* ">
                        <xsl:if test="not(number(@text:level)=10)">
                            <xsl:element name="字:级别">
                                <xsl:attribute name="uof:locID">t0159</xsl:attribute>
                                <xsl:attribute name="uof:attrList">级别值 编号对齐方式 尾随字符</xsl:attribute>
                                <xsl:attribute name="字:级别值"><xsl:value-of select="number(@text:level) - 1"/></xsl:attribute>
                                <xsl:if test="@style:num-suffix">
                                    <xsl:attribute name="字:尾随字符"><xsl:choose><xsl:when test="@style:num-suffix=' '">space</xsl:when><xsl:when test="@style:num-suffix='   '">tab</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                                </xsl:if>
                                <xsl:if test="style:list-level-properties/@fo:text-align">
                                    <xsl:attribute name="字:编号对齐方式"><xsl:variable name="vv"><xsl:value-of select="style:list-level-properties/@fo:text-align"/></xsl:variable><xsl:choose><xsl:when test="$vv='center' ">center</xsl:when><xsl:when test="$vv='end' ">right</xsl:when><xsl:otherwise>left</xsl:otherwise></xsl:choose></xsl:attribute>
                                </xsl:if>
                                <xsl:if test="@text:bullet-char">
                                    <xsl:element name="字:项目符号">
                                        <xsl:attribute name="uof:locID">t0171</xsl:attribute>
                                        <xsl:value-of select="@text:bullet-char"/>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="@text:style-name">
                                    <xsl:element name="字:符号字体">
                                        <xsl:attribute name="uof:locID">t0160</xsl:attribute>
                                        <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                                        <xsl:attribute name="字:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="@style:num-format">
                                    <xsl:choose>
                                        <xsl:when test="string(@style:num-format)='a'">
                                            <xsl:element name="字:编号格式">
                                                <xsl:attribute name="uof:locID">t0162</xsl:attribute>lower-letter</xsl:element>
                                        </xsl:when>
                                        <xsl:when test="string(@style:num-format)='A'">
                                            <xsl:element name="字:编号格式">
                                                <xsl:attribute name="uof:locID">t0162</xsl:attribute>upper-letter</xsl:element>
                                        </xsl:when>
                                        <xsl:when test="string(@style:num-format)='i'">
                                            <xsl:element name="字:编号格式">
                                                <xsl:attribute name="uof:locID">t0162</xsl:attribute>lower-roman</xsl:element>
                                        </xsl:when>
                                        <xsl:when test="string(@style:num-format)='I'">
                                            <xsl:element name="字:编号格式">
                                                <xsl:attribute name="uof:locID">t0162</xsl:attribute>upper-roman</xsl:element>
                                        </xsl:when>
                                        <xsl:when test="string(@style:num-format)='①, ②, ③, ...'">
                                            <xsl:element name="字:编号格式">
                                                <xsl:attribute name="uof:locID">t0162</xsl:attribute>decimal-enclosed-circle</xsl:element>
                                        </xsl:when>
                                        <xsl:when test="string(@style:num-format)='甲, 乙, 丙, ...'">
                                            <xsl:element name="字:编号格式">
                                                <xsl:attribute name="uof:locID">t0162</xsl:attribute>ideograph-traditional</xsl:element>
                                        </xsl:when>
                                        <xsl:when test="string(@style:num-format)='子, 丑, 寅, ...'">
                                            <xsl:element name="字:编号格式">
                                                <xsl:attribute name="uof:locID">t0162</xsl:attribute>ideograph-zodiac</xsl:element>
                                        </xsl:when>
                                        <xsl:when test="string(@style:num-format)='一, 二, 三, ...'">
                                            <xsl:element name="字:编号格式">
                                                <xsl:attribute name="uof:locID">t0162</xsl:attribute>chinese-counting</xsl:element>
                                        </xsl:when>
                                        <xsl:when test="string(@style:num-format)='壹, 贰, 叁, ...'">
                                            <xsl:element name="字:编号格式">
                                                <xsl:attribute name="uof:locID">t0162</xsl:attribute>chinese-legal-simplified</xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:element name="字:编号格式">
                                                <xsl:attribute name="uof:locID">t0162</xsl:attribute>decimal</xsl:element>
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
                                <xsl:element name="字:编号格式表示">
                                    <xsl:attribute name="uof:locID">t0163</xsl:attribute>
                                    <xsl:call-template name="字:编号格式表示">
                                        <xsl:with-param name="bubianjibie" select="$jibie"/>
                                        <xsl:with-param name="jibie" select="$jibie"/>
                                        <xsl:with-param name="xianshijibie" select="$xianshijibie"/>
                                        <xsl:with-param name="biaoshi" select="concat(string(@style:num-prefix),'%',$jibie,string(@style:num-suffix))"/>
                                    </xsl:call-template>
                                </xsl:element>
                                <xsl:if test="office:binary-data">
                                    <xsl:element name="字:图片符号引用">
                                        <xsl:attribute name="uof:locID">t0164</xsl:attribute>
                                        <xsl:attribute name="uof:attrList">宽度 高度</xsl:attribute>
                                        <xsl:if test="style:list-level-properties/@fo:width">
                                            <xsl:attribute name="字:宽度"><xsl:value-of select="substring-before(style:list-level-properties/@fo:width,$uofUnit)"/></xsl:attribute>
                                        </xsl:if>
                                        <xsl:if test="style:list-level-properties/@fo:height">
                                            <xsl:attribute name="字:高度"><xsl:value-of select="substring-before(style:list-level-properties/@fo:height,$uofUnit)"/></xsl:attribute>
                                        </xsl:if>
                                        <xsl:value-of select="concat('image_numbering_',count(preceding::text:list-level-style-image))"/>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="style:paragraph-properties/@fo:margin-left or style:paragraph-properties/@fo:margin-right or style:paragraph-properties/@fo:text-indent">
                                    <xsl:element name="字:缩进">
                                        <xsl:attribute name="uof:locID">t0165</xsl:attribute>
                                        <xsl:for-each select="style:paragraph-properties">
                                            <xsl:call-template name="字:缩进类型"/>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="style:list-level-properties/@text:min-label-width">
                                    <xsl:element name="字:制表符位置">
                                        <xsl:attribute name="uof:locID">t0166</xsl:attribute>
                                        <xsl:value-of select="substring-before(style:list-level-properties/@text:min-label-width,$uofUnit)"/>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="@text:start-value">
                                    <xsl:element name="字:起始编号">
                                        <xsl:attribute name="uof:locID">t0167</xsl:attribute>
                                        <xsl:value-of select="@text:start-value"/>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="@text:num-regular-exp">
                                    <xsl:element name="字:正规格式">
                                        <xsl:attribute name="uof:locID">t0168</xsl:attribute>
                                        <xsl:attribute name="uof:attrList">值</xsl:attribute>
                                        <xsl:attribute name="字:值"><xsl:value-of select="@text:num-regular-exp"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template name="shiyang">
        <xsl:for-each select="office:styles/style:style">
            <xsl:choose>
                <xsl:when test="@style:family='text'">
                    <xsl:element name="uof:句式样">
                        <xsl:attribute name="uof:locID">u0043</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符 名称 类型 别名 基式样引用 后继式样引用</xsl:attribute>
                        <xsl:attribute name="字:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:attribute name="字:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:attribute name="字:类型">auto</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="@style:parent-style-name">
                                <xsl:attribute name="字:基式样引用"><xsl:value-of select="@style:parent-style-name"/></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="字:基式样引用"><xsl:value-of select="@style:name"/></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:call-template name="字:句属性"/>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="office:automatic-styles/style:style">
            <xsl:choose>
                <xsl:when test="@style:family='text'">
                    <xsl:element name="uof:句式样">
                        <xsl:attribute name="uof:locID">u0043</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符 名称 类型 别名 基式样引用 后继式样引用</xsl:attribute>
                        <xsl:attribute name="字:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:attribute name="字:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:attribute name="字:类型">custom</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="@style:parent-style-name">
                                <xsl:attribute name="字:基式样引用"><xsl:value-of select="@style:parent-style-name"/></xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="@style:parent-style-name and not(@style:parent-style-name='Standard')">
                                <xsl:variable name="stylename" select="@style:parent-style-name"/>
                                <xsl:for-each select="/office:document/office:styles/style:style[@style:name=$stylename]">
                                    <xsl:call-template name="字:句属性"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="字:句属性"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="office:styles/style:style">
            <xsl:choose>
                <xsl:when test="@style:family='paragraph'">
                    <xsl:element name="uof:段落式样">
                        <xsl:attribute name="uof:locID">u0044</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符 名称 类型 别名 基式样引用 后继式样引用</xsl:attribute>
                        <xsl:attribute name="字:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:attribute name="字:类型">auto</xsl:attribute>
                        <xsl:if test="@style:parent-style-name">
                            <xsl:attribute name="字:基式样引用"><xsl:value-of select="@style:parent-style-name"/></xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="字:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:if test="@style:display-name">
                            <xsl:attribute name="字:别名"><xsl:value-of select="@style:display-name"/></xsl:attribute>
                        </xsl:if>
                        <xsl:element name="字:句属性">
                            <xsl:attribute name="uof:locID">t0086</xsl:attribute>
                            <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                            <xsl:call-template name="字:句属性"/>
                        </xsl:element>
                        <xsl:call-template name="ParaAttribute"/>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="office:automatic-styles/style:style">
            <xsl:choose>
                <xsl:when test="@style:family='paragraph'">
                    <xsl:element name="uof:段落式样">
                        <xsl:attribute name="uof:locID">u0044</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符 名称 类型 别名 基式样引用 后继式样引用</xsl:attribute>
                        <xsl:attribute name="字:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:attribute name="字:类型">custom</xsl:attribute>
                        <xsl:if test="@style:parent-style-name">
                            <xsl:attribute name="字:基式样引用"><xsl:value-of select="@style:parent-style-name"/></xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="字:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:element name="字:句属性">
                            <xsl:attribute name="uof:locID">t0086</xsl:attribute>
                            <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                            <xsl:call-template name="字:句属性"/>
                        </xsl:element>
                        <xsl:call-template name="ParaAttribute"/>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
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
    <xsl:template match="style:style[ancestor::office:automatic-styles]" mode="style">
        <xsl:for-each select=".">
            <xsl:choose>
                <xsl:when test="@style:family='table' ">
                    <xsl:element name="uof:文字表式样">
                        <xsl:attribute name="uof:locID">u0045</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符 名称 类型 别名 基式样引用 后继式样引用</xsl:attribute>
                        <xsl:attribute name="字:标识符"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:attribute name="字:名称"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:attribute name="字:别名"><xsl:value-of select="@style:name"/></xsl:attribute>
                        <xsl:attribute name="字:类型">auto</xsl:attribute>
                        <xsl:if test="style:table-properties">
                            <xsl:element name="字:宽度">
                                <xsl:attribute name="字:绝对宽度"><xsl:value-of select="substring-before(style:table-properties/@style:width,$ooUnit)"/></xsl:attribute>
                                <xsl:attribute name="uof:locID">t0130</xsl:attribute>
                                <xsl:attribute name="uof:attrList">绝对宽度 相对宽度</xsl:attribute>
                            </xsl:element>
                            <字:对齐 uof:locID="t0133">
                                <xsl:choose>
                                    <xsl:when test="style:table-properties/@table:align='right'">right</xsl:when>
                                    <xsl:when test="style:table-properties/@table:align='center'">center</xsl:when>
                                    <xsl:otherwise>left</xsl:otherwise>
                                </xsl:choose>
                            </字:对齐>
                        </xsl:if>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="office:settings">
        <字:文档设置 uof:locID="t0001">
            <字:度量单位 uof:locID="t0006">
                <xsl:value-of select="$ooUnit"/>
            </字:度量单位>
            <字:默认制表位位置 uof:locID="t0004">
                <xsl:variable name="aa" select="substring-before(/office:document/office:styles/style:default-style[@style:family='paragraph']/style:paragraph-properties/@style:tab-stop-distance,$ooUnit)"/>
                <xsl:variable name="bb" select="$aa - 0.74"/>
                <xsl:value-of select="substring($bb,1,4)"/>
            </字:默认制表位位置>
            <字:当前视图 uof:locID="t0002">
                <xsl:choose>
                    <xsl:when test="config:config-item-set[@config:name='ooo:view-settings']/config:config-item[@config:name='InBrowseMode']='false'">page</xsl:when>
                    <xsl:when test="config:config-item-set[@config:name='ooo:view-settings']/config:config-item[@config:name='InBrowseMode']='true'">web</xsl:when>
                    <xsl:otherwise>page</xsl:otherwise>
                </xsl:choose>
            </字:当前视图>
            <xsl:if test="config:config-item-set[@config:name='ooo:view-settings']/config:config-item-map-indexed[@config:name='Views']/config:config-item-map-entry/config:config-item[@config:name='ZoomFactor']">
                <字:缩放 uof:locID="t0003">
                    <xsl:value-of select="config:config-item-set[@config:name='ooo:view-settings']/config:config-item-map-indexed[@config:name='Views']/config:config-item-map-entry/config:config-item[@config:name='ZoomFactor']"/>
                </字:缩放>
            </xsl:if>
            <字:修订 uof:locID="t0005">
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test="/office:document/office:body/office:text/text:tracked-changes">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </字:修订>
            <xsl:if test="config:config-item-set[@config:name='configuration-settings']/config:config-item-map-indexed[@config:name='ForbiddenCharacters']/config:config-item-map-entry[config:config-item='CN']">
                <字:标点禁则 uof:locID="t0007">
                    <字:行首字符 uof:locID="t0008">
                        <xsl:value-of select="config:config-item-set[@config:name='configuration-settings']/config:config-item-map-indexed[@config:name='ForbiddenCharacters']/config:config-item-map-entry[config:config-item='CN']/config:config-item[@config:name='BeginLine']"/>
                    </字:行首字符>
                    <字:行尾字符 uof:locID="t0009">
                        <xsl:value-of select="config:config-item-set[@config:name='configuration-settings']/config:config-item-map-indexed[@config:name='ForbiddenCharacters']/config:config-item-map-entry[config:config-item='CN']/config:config-item[@config:name='EndLine']"/>
                    </字:行尾字符>
                </字:标点禁则>
                <xsl:if test="/office:document/office:styles/text:notes-configuration[@text:note-class='endnote']">
                    <字:尾注位置 uof:locID="t0210" uof:attrList="位置">
                        <xsl:attribute name="字:位置">doc-end</xsl:attribute>
                    </字:尾注位置>
                </xsl:if>
            </xsl:if>
        </字:文档设置>
    </xsl:template>
    <xsl:template name="style:page-layout">
        <字:分节 uof:locID="t0017" uof:attrList="名称">
            <xsl:attribute name="字:名称"><xsl:variable name="stylename"><xsl:value-of select="@style:name"/></xsl:variable><xsl:value-of select="/office:document/office:master-styles/style:master-page[@style:page-layout-name=$stylename]/@style:name"/></xsl:attribute>
            <字:节属性 uof:locID="t0018">
                <字:节类型 uof:locID="t0020">new-page</字:节类型>
                <xsl:element name="字:页边距">
                    <xsl:attribute name="uof:locID">t0021</xsl:attribute>
                    <xsl:attribute name="uof:attrList">左 上 右 下</xsl:attribute>
                    <xsl:attribute name="uof:上"><xsl:value-of select="substring-before(style:page-layout-properties/@fo:margin-top,$ooUnit)"/></xsl:attribute>
                    <xsl:attribute name="uof:左"><xsl:value-of select="substring-before(style:page-layout-properties/@fo:margin-left,$ooUnit)"/></xsl:attribute>
                    <xsl:attribute name="uof:下"><xsl:value-of select="substring-before(style:page-layout-properties/@fo:margin-bottom,$ooUnit)"/></xsl:attribute>
                    <xsl:attribute name="uof:右"><xsl:value-of select="substring-before(style:page-layout-properties/@fo:margin-right,$ooUnit)"/></xsl:attribute>
                </xsl:element>
                <xsl:element name="字:纸张">
                    <xsl:attribute name="uof:locID">t0022</xsl:attribute>
                    <xsl:attribute name="uof:attrList">纸型 宽度 高度</xsl:attribute>
                    <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(style:page-layout-properties/@fo:page-width,$ooUnit)"/></xsl:attribute>
                    <xsl:attribute name="uof:高度"><xsl:value-of select="substring-before(style:page-layout-properties/@fo:page-height,$ooUnit)"/></xsl:attribute>
                    <xsl:attribute name="uof:纸型"><xsl:variable name="height"><xsl:value-of select="style:page-layout-properties/@fo:page-height"/></xsl:variable><xsl:variable name="width"><xsl:value-of select="style:page-layout-properties/@fo:page-width"/></xsl:variable><xsl:choose><xsl:when test="$width='29.702cm' and $height='42cm'">A3</xsl:when><xsl:when test="$width='21.001cm' and $height='29.7cm'">A4</xsl:when><xsl:when test="$width='14.799cm' and $height='20.999cm'">A5</xsl:when><xsl:when test="$width='25cm' and $height='35.3cm'">B4</xsl:when><xsl:when test="$width='17.598cm' and $height='25cm'">B5</xsl:when><xsl:when test="$width='12.5cm' and $height='17.6cm'">B6</xsl:when><xsl:otherwise>使用者</xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:element>
                <xsl:if test="/office:document/office:master-styles/style:master-page/style:header-left">
                    <xsl:element name="字:奇偶页页眉页脚不同">
                        <xsl:attribute name="uof:locID">t0023</xsl:attribute>
                        <xsl:attribute name="uof:attrList">值</xsl:attribute>
                        <xsl:attribute name="字:值">true</xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="字:首页页眉页脚不同">
                    <xsl:attribute name="uof:locID">t0024</xsl:attribute>
                    <xsl:attribute name="uof:attrList">值</xsl:attribute>
                    <xsl:attribute name="字:值">false</xsl:attribute>
                </xsl:element>
                <xsl:if test="style:header-style/style:header-footer-properties">
                    <xsl:element name="字:页眉位置">
                        <xsl:attribute name="uof:locID">t0025</xsl:attribute>
                        <xsl:attribute name="uof:attrList">距边界 距版芯</xsl:attribute>
                        <xsl:attribute name="字:距边界"><xsl:value-of select="substring-before(style:header-style/style:header-footer-properties/@fo:margin-bottom,$ooUnit)"/></xsl:attribute>
                        <xsl:variable name="long1" select="substring-before(style:header-style/style:header-footer-properties/@fo:margin-bottom,$ooUnit)"/>
                        <xsl:variable name="long2" select="substring-before(style:header-style/style:header-footer-properties/@svg:height,$ooUnit)"/>
                        <xsl:attribute name="字:距版芯"><xsl:value-of select="$long2 - $long1"/></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="style:footer-style/style:header-footer-properties">
                    <xsl:element name="字:页脚位置">
                        <xsl:attribute name="uof:locID">t0026</xsl:attribute>
                        <xsl:attribute name="uof:attrList">距边界 距版芯</xsl:attribute>
                        <xsl:attribute name="字:距边界"><xsl:value-of select="substring-before(style:footer-style/style:header-footer-properties/@fo:margin-top,$ooUnit)"/></xsl:attribute>
                        <xsl:variable name="long1" select="substring-before(style:footer-style/style:header-footer-properties/@fo:margin-top,$ooUnit)"/>
                        <xsl:variable name="long2" select="substring-before(style:footer-style/style:header-footer-properties/@svg:height,$ooUnit)"/>
                        <xsl:attribute name="字:距版芯"><xsl:value-of select="$long2 - $long1"/></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:variable name="masterPages" select="'Standard'"/>
                <xsl:variable name="mp">
                    <xsl:value-of select="@style:name"/>
                </xsl:variable>
                <xsl:for-each select="/office:document/office:master-styles/style:master-page[@style:page-layout-name=$mp and @style:name=$masterPages]">
                    <xsl:if test="style:header-left or style:header">
                        <字:页眉 uof:locID="t0027">
                            <xsl:choose>
                                <xsl:when test="style:header-left">
                                    <xsl:for-each select="style:header">
                                        <字:首页页眉 uof:locID="t0030">
                                            <xsl:if test="text:p">
                                                <xsl:for-each select="text:p">
                                                    <xsl:call-template name="execParagraph">
                                                        <xsl:with-param name="currlistlvl" select="number('0')"/>
                                                        <xsl:with-param name="liststylename" select="string('00000')"/>
                                                    </xsl:call-template>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="table:table">
                                                <xsl:for-each select="table:table">
                                                    <xsl:call-template name="exec_table"/>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </字:首页页眉>
                                    </xsl:for-each>
                                    <xsl:for-each select="style:header-left">
                                        <字:偶数页页眉 uof:locID="t0029">
                                            <xsl:if test="text:p">
                                                <xsl:for-each select="text:p">
                                                    <xsl:call-template name="execParagraph">
                                                        <xsl:with-param name="currlistlvl" select="number('0')"/>
                                                        <xsl:with-param name="liststylename" select="string('00000')"/>
                                                    </xsl:call-template>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="table:table">
                                                <xsl:for-each select="table:table">
                                                    <xsl:call-template name="exec_table"/>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </字:偶数页页眉>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="style:header">
                                        <字:奇数页页眉 uof:locID="t0028">
                                            <xsl:if test="text:p">
                                                <xsl:for-each select="text:p">
                                                    <xsl:call-template name="execParagraph">
                                                        <xsl:with-param name="currlistlvl" select="number('0')"/>
                                                        <xsl:with-param name="liststylename" select="string('00000')"/>
                                                    </xsl:call-template>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="table:table">
                                                <xsl:for-each select="table:table">
                                                    <xsl:call-template name="exec_table"/>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </字:奇数页页眉>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </字:页眉>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="/office:document/office:master-styles/style:master-page[@style:page-layout-name=$mp and @style:name=$masterPages]">
                    <xsl:if test="style:footer-left or style:footer">
                        <字:页脚 uof:locID="t0031">
                            <xsl:choose>
                                <xsl:when test="style:footer-left">
                                    <xsl:for-each select="style:footer">
                                        <字:首页页脚 uof:locID="t0034">
                                            <xsl:if test="text:p">
                                                <xsl:for-each select="text:p">
                                                    <xsl:call-template name="execParagraph">
                                                        <xsl:with-param name="currlistlvl" select="number('0')"/>
                                                        <xsl:with-param name="liststylename" select="string('00000')"/>
                                                    </xsl:call-template>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="table:table">
                                                <xsl:for-each select="table:table">
                                                    <xsl:call-template name="exec_table"/>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </字:首页页脚>
                                    </xsl:for-each>
                                    <xsl:for-each select="style:footer-left">
                                        <字:偶数页页脚 uof:locID="t0033">
                                            <xsl:if test="text:p">
                                                <xsl:for-each select="text:p">
                                                    <xsl:call-template name="execParagraph">
                                                        <xsl:with-param name="currlistlvl" select="number('0')"/>
                                                        <xsl:with-param name="liststylename" select="string('00000')"/>
                                                    </xsl:call-template>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="table:table">
                                                <xsl:for-each select="table:table">
                                                    <xsl:call-template name="exec_table"/>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </字:偶数页页脚>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="style:footer">
                                        <字:奇数页页脚 uof:locID="t0032">
                                            <xsl:if test="text:p">
                                                <xsl:for-each select="text:p">
                                                    <xsl:call-template name="execParagraph">
                                                        <xsl:with-param name="currlistlvl" select="number('0')"/>
                                                        <xsl:with-param name="liststylename" select="string('00000')"/>
                                                    </xsl:call-template>
                                                </xsl:for-each>
                                            </xsl:if>
                                            <xsl:if test="table:table">
                                                <xsl:for-each select="table:table">
                                                    <xsl:call-template name="exec_table"/>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </字:奇数页页脚>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </字:页脚>
                    </xsl:if>
                </xsl:for-each>
                <xsl:if test="@style:page-usage">
                    <字:对称页边距 uof:locID="t0036" uof:attrList="值">
                        <xsl:attribute name="字:值"><xsl:choose><xsl:when test="@style:page-usage='mirrored'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                    </字:对称页边距>
                </xsl:if>
                <xsl:if test="@style:page-usage='mirrored'">
                    <xsl:element name="字:拼页">
                        <xsl:attribute name="uof:locID">t0037</xsl:attribute>
                        <xsl:attribute name="uof:attrList">值</xsl:attribute>
                        <xsl:attribute name="字:值">1</xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="字:纸张方向">
                    <xsl:attribute name="uof:locID">t0038</xsl:attribute>
                    <xsl:value-of select="style:page-layout-properties/@style:print-orientation"/>
                </xsl:element>
                <xsl:if test="style:page-layout-properties/@style:paper-tray-name">
                    <字:纸张来源 uof:locID="t0039" uof:attrList="首页 其他页" 字:首页="false" 字:其他页="style:page-layout-properties/@style:paper-tray-name"/>
                </xsl:if>
                <xsl:if test="style:page-layout-properties/@style:num-format">
                    <xsl:element name="字:页码设置">
                        <xsl:attribute name="uof:locID">t0042</xsl:attribute>
                        <xsl:attribute name="uof:attrList">首页显示 格式 包含章节号 章节起始样式引用 分隔符 起始编号</xsl:attribute>
                        <xsl:attribute name="字:首页显示">1</xsl:attribute>
                        <xsl:attribute name="字:格式"><xsl:variable name="format"><xsl:value-of select="style:page-layout-properties/@style:num-format"/></xsl:variable><xsl:call-template name="oo数字格式"><xsl:with-param name="oo_format" select="$format"/></xsl:call-template></xsl:attribute>
                        <xsl:if test="style:text-properties/@style:first-page-number">
                            <xsl:attribute name="字:起始编号"><xsl:value-of select="style:text-properties/@style:first-page-number"/></xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="字:包含章节号">false</xsl:attribute>
                        <!--xsl:attribute name="字:章节起始样式引用">false</xsl:attribute-->
                        <xsl:attribute name="字:分隔符">hyphen</xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="/office:document/office:styles/text:notes-configuration[@text:note-class='footnote']">
                    <xsl:element name="字:脚注设置">
                        <xsl:attribute name="uof:locID">t0040</xsl:attribute>
                        <xsl:attribute name="uof:attrList">位置 格式 起始编号 编号方式</xsl:attribute>
                        <xsl:for-each select="/office:document/office:styles/text:notes-configuration[@text:note-class='footnote']">
                            <xsl:attribute name="字:位置"><xsl:choose><xsl:when test="@text:footnotes-position='page'">page-bottom</xsl:when><xsl:when test="@text:footnotes-position='document'">below-text</xsl:when></xsl:choose></xsl:attribute>
                            <xsl:attribute name="字:编号方式"><xsl:choose><xsl:when test="@text:start-numbering-at='document'">continuous</xsl:when><xsl:when test="@text:start-numbering-at='chapter'">section</xsl:when><xsl:when test="@text:start-numbering-at='page'">page</xsl:when></xsl:choose></xsl:attribute>
                            <xsl:attribute name="字:起始编号"><xsl:value-of select="@text:start-value + 1"/></xsl:attribute>
                            <xsl:attribute name="字:格式"><xsl:variable name="format"><xsl:value-of select="@style:num-format"/></xsl:variable><xsl:call-template name="oo数字格式"><xsl:with-param name="oo_format" select="$format"/></xsl:call-template></xsl:attribute>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="/office:document/office:styles/text:notes-configuration[@text:note-class='endnote']">
                    <字:尾注设置 uof:locID="t0041" uof:attrList="格式 起始编号 编号方式">
                        <xsl:for-each select="/office:document/office:styles/text:notes-configuration[@text:note-class='endnote']">
                            <xsl:attribute name="字:格式"><xsl:variable name="format"><xsl:value-of select="@style:num-format"/></xsl:variable><xsl:call-template name="oo数字格式"><xsl:with-param name="oo_format" select="$format"/></xsl:call-template></xsl:attribute>
                            <xsl:attribute name="字:起始编号"><xsl:value-of select="@text:start-value + 1"/></xsl:attribute>
                        </xsl:for-each>
                    </字:尾注设置>
                </xsl:if>
                <xsl:if test="/office:document/office:styles/text:linenumbering-configuration">
                    <字:行号设置 uof:locID="t0043" uof:attrList="使用行号 编号方式 起始编号 距边界 行号间隔">
                        <xsl:for-each select="/office:document/office:styles/text:linenumbering-configuration">
                            <xsl:choose>
                                <xsl:when test="@text:number-lines='false'">
                                    <xsl:attribute name="字:使用行号">false</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="字:使用行号">true</xsl:attribute>
                                    <xsl:attribute name="字:编号方式"><xsl:choose><xsl:when test="@text:count-in-floating-frames='true'">section</xsl:when><xsl:when test="@text:restart-on-page='true'">page</xsl:when><xsl:when test="@text:count-empty-lines='false'"/><xsl:otherwise>continuous</xsl:otherwise></xsl:choose></xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="@style:num-format">
                                <xsl:attribute name="字:起始编号"><xsl:value-of select="@style:num-format"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@text:offset">
                                <xsl:attribute name="字:距边界"><xsl:value-of select="substring-before(@text:offset,$uofUnit)"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@text:increment">
                                <xsl:attribute name="字:行号间隔"><xsl:value-of select="@text:increment"/></xsl:attribute>
                            </xsl:if>
                        </xsl:for-each>
                    </字:行号设置>
                </xsl:if>
                <xsl:variable name="aa">
                    <xsl:value-of select="substring-before(style:page-layout-properties/@style:layout-grid-ruby-height,$ooUnit)"/>
                </xsl:variable>
                <xsl:if test="style:page-layout-properties/@style:layout-grid-display and $aa='0' ">
                    <字:网格设置 uof:locID="t0044" uof:attrList="网格类型 宽度 高度 显示网格 打印网格">
                        <xsl:if test="style:page-layout-properties/@style:layout-grid-mode">
                            <xsl:attribute name="字:网格类型"><xsl:choose><xsl:when test="style:page-layout-properties/@style:layout-grid-mode='both-nosnap'">line-char</xsl:when><xsl:when test="style:page-layout-properties/@style:layout-grid-mode='both'">char</xsl:when><xsl:when test="style:page-layout-properties/@style:layout-grid-mode='line'">line</xsl:when><xsl:when test="style:page-layout-properties/@style:layout-grid-mode='none'">none</xsl:when></xsl:choose></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="style:page-layout-properties/@style:layout-grid-base-width">
                            <xsl:attribute name="字:宽度"><xsl:value-of select="substring-before(style:page-layout-properties/@style:layout-grid-base-width,$ooUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="style:page-layout-properties/@style:layout-grid-base-height">
                            <xsl:attribute name="字:高度"><xsl:value-of select="substring-before(style:page-layout-properties/@style:layout-grid-base-height,$ooUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="style:page-layout-properties/@style:layout-grid-display">
                            <xsl:attribute name="字:显示网格"><xsl:choose><xsl:when test="style:page-layout-properties/@style:layout-grid-display='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="style:page-layout-properties/@style:layout-grid-print">
                            <xsl:attribute name="字:打印网格"><xsl:choose><xsl:when test="style:page-layout-properties/@style:layout-grid-print='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                        </xsl:if>
                    </字:网格设置>
                </xsl:if>
                <xsl:if test="style:page-layout-properties/@style:layout-grid-display and not($aa = '0')">
                    <字:稿纸设置 uof:locID="t0211" uof:attrList="类型 格式 线型 颜色 方向">
                        <xsl:variable name="mode">
                            <xsl:value-of select="style:page-layout-properties/@style:layout-grid-mode"/>
                        </xsl:variable>
                        <xsl:variable name="ruby">
                            <xsl:value-of select="substring-before(style:page-layout-properties/@style:layout-grid-ruby-height,$ooUnit)"/>
                        </xsl:variable>
                        <xsl:variable name="width">
                            <xsl:value-of select="substring-before(style:page-layout-properties/@style:layout-grid-base-width,$ooUnit)"/>
                        </xsl:variable>
                        <xsl:variable name="height">
                            <xsl:value-of select="substring-before(style:page-layout-properties/@style:layout-grid-base-height,$ooUnit)"/>
                        </xsl:variable>
                        <xsl:attribute name="字:类型"><xsl:choose><xsl:when test="style:page-layout-properties/@style:layout-grid-mode='line'">letter-paper</xsl:when><xsl:when test="style:page-layout-properties/@style:layout-grid-mode='both'">draft-paper</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:if test="style:page-layout-properties/@style:layout-grid-mode">
                            <xsl:attribute name="字:格式"><xsl:choose><xsl:when test="$mode='both' and $width='0.728' and $height='0.728' and $ruby='0.496' ">fourth-gear</xsl:when><xsl:when test="$mode='both' and $width='0.584' and $height='0.584' and $ruby='0.64' ">third-gear</xsl:when><xsl:when test="$mode='both' and $width='0.728' and $height='0.728' and $ruby='0.905' ">second-gear</xsl:when><xsl:when test="$mode='both' and $width='0.728' and $height='0.728' and $ruby='1.633' ">first-gear</xsl:when></xsl:choose></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="style:page-layout-properties/@style:layout-grid-color">
                            <xsl:attribute name="字:颜色"><xsl:value-of select="style:page-layout-properties/@style:layout-grid-color"/></xsl:attribute>
                        </xsl:if>
                    </字:稿纸设置>
                </xsl:if>
                <xsl:if test="/office:document/office:automatic-styles/style:page-layout/style:page-layout-properties/@style:writing-mode='lr-tb' or style:text-properties/@style:writing-mode='rl-tb'">
                    <字:垂直对齐方式 uof:locID="t0045">
                        <xsl:variable name="path" select="/office:document/office:automatic-styles/style:style/style:paragraph-properties"/>
                        <xsl:choose>
                            <xsl:when test="$path/@fo:text-align='start'">top</xsl:when>
                            <xsl:when test="$path/@fo:text-align='end'">bottom</xsl:when>
                            <xsl:when test="$path/@fo:text-align='center'">center</xsl:when>
                            <xsl:otherwise>justified</xsl:otherwise>
                        </xsl:choose>
                    </字:垂直对齐方式>
                </xsl:if>
                <字:文字排列方向 uof:locID="t0046">
                    <xsl:variable name="writing_mode">
                        <xsl:value-of select="style:page-layout-properties/@style:writing-mode"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$writing_mode='lr-tb' or $writing_mode='lr'">hori-l2r</xsl:when>
                        <xsl:when test="$writing_mode='rl-tb' or $writing_mode='rl'">hori-r2l</xsl:when>
                        <xsl:when test="$writing_mode='tb-rl'">vert-r2l</xsl:when>
                        <xsl:when test="$writing_mode='tb-lr'">vert-l2r</xsl:when>
                        <xsl:otherwise>hori-l2r</xsl:otherwise>
                    </xsl:choose>
                </字:文字排列方向>
                <xsl:if test="style:page-layout-properties/@fo:border or style:page-layout-properties/@fo:border-top or style:page-layout-properties/@fo:border-bottom or style:page-layout-properties/@fo:border-left or style:page-layout-properties/@fo:border-right or style:page-layout-properties/@style:shadow[.!='none']">
                    <xsl:element name="字:边框">
                        <xsl:attribute name="uof:locID">t0047</xsl:attribute>
                        <xsl:for-each select="style:page-layout-properties">
                            <xsl:call-template name="uof:边框"/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="style:page-layout-properties/@fo:background-color">
                    <xsl:element name="字:填充">
                        <xsl:attribute name="uof:locID">t0048</xsl:attribute>
                        <xsl:for-each select="style:page-layout-properties">
                            <xsl:call-template name="图:填充"/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="style:page-layout-properties/style:columns">
                    <xsl:element name="字:分栏">
                        <xsl:attribute name="uof:locID">t0049</xsl:attribute>
                        <xsl:attribute name="uof:attrList">栏数 等宽 分隔线 分隔线宽度 分隔线颜色</xsl:attribute>
                        <xsl:if test="//@fo:column-count">
                            <xsl:attribute name="字:栏数"><xsl:choose><xsl:when test="//@fo:column-count='0'">1</xsl:when><xsl:otherwise><xsl:value-of select="//@fo:column-count"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        </xsl:if>
                        <xsl:variable name="第一宽度">
                            <xsl:value-of select="style:page-layout-properties/style:columns/style:column/@style:rel-width"/>
                        </xsl:variable>
                        <xsl:variable name="dkm">
                            <xsl:for-each select="style:page-layout-properties/style:columns/style:column">
                                <xsl:if test="$第一宽度 != @style:rel-width">
                                    <xsl:value-of select="boolean($第一宽度 = @style:rel-width)"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="style:page-layout-properties/style:columns/@fo:column-gap">
                                <xsl:attribute name="字:等宽">true</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="字:等宽">false</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="style:page-layout-properties/style:columns/style:column-sep">
                            <xsl:attribute name="字:分隔线宽度"><xsl:value-of select="substring-before(style:page-layout-properties/style:columns/style:column-sep/@style:width,$ooUnit)"/></xsl:attribute>
                            <xsl:attribute name="字:分隔线颜色"><xsl:value-of select="style:page-layout-properties/style:columns/style:column-sep/@style:color"/></xsl:attribute>
                            <xsl:attribute name="字:分隔线">single</xsl:attribute>
                        </xsl:if>
                        <xsl:for-each select="style:page-layout-properties/style:columns/style:column">
                            <xsl:element name="字:栏">
                                <xsl:variable name="left">
                                    <xsl:value-of select="substring-before(@fo:start-indent,$uofUnit)"/>
                                </xsl:variable>
                                <xsl:variable name="right">
                                    <xsl:value-of select="substring-before(@fo:end-indent,$uofUnit)"/>
                                </xsl:variable>
                                <xsl:if test="@style:rel-width">
                                    <xsl:attribute name="字:宽度"><xsl:value-of select="substring-before(@style:rel-width,'*')"/></xsl:attribute>
                                </xsl:if>
                                <xsl:if test="@fo:start-indent or @fo:end-indent">
                                    <xsl:choose>
                                        <xsl:when test="parent::style:columns/@fo:column-gap">
                                            <xsl:attribute name="字:间距"><xsl:choose><xsl:when test="$left - $right &gt;0 "><xsl:value-of select="$left - $right"/></xsl:when><xsl:when test="$right - $left &gt; 0 "><xsl:value-of select="$right - $left"/></xsl:when><xsl:otherwise><xsl:value-of select="$right"/></xsl:otherwise></xsl:choose></xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="字:间距"><xsl:value-of select="$right"/></xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                                <xsl:attribute name="uof:locID">t0050</xsl:attribute>
                                <xsl:attribute name="uof:attrList">宽度 间距</xsl:attribute>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
            </字:节属性>
        </字:分节>
    </xsl:template>
    <xsl:template match="office:text">
        <xsl:for-each select="node( )">
            <xsl:choose>
                <xsl:when test="name()='text:list'or name()='text:ordered-list'">
                    <xsl:call-template name="unordered-ordered-list">
                        <xsl:with-param name="currlistlvl" select="number('1')"/>
                        <xsl:with-param name="liststylename" select="@text:style-name"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="name()='text:p'or name()='text:h'">
                    <xsl:variable name="bs" select="./@text:style-name"/>
                    <xsl:if test="/office:document/office:automatic-styles/style:style[@style:name=$bs]/@style:master-page-name">
                        <xsl:variable name="bs1" select="/office:document/office:automatic-styles/style:style[@style:name=$bs]/@style:master-page-name"/>
                        <xsl:if test="/office:document/office:master-styles/style:master-page[@style:name=$bs1]/@style:page-layout-name">
                            <xsl:variable name="bs2" select="/office:document/office:master-styles/style:master-page[@style:name=$bs1]/@style:page-layout-name"/>
                            <xsl:for-each select="/office:document/office:automatic-styles/style:page-layout[@style:name=$bs2]">
                                <xsl:call-template name="style:page-layout"/>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:if>
                    <xsl:call-template name="execParagraph">
                        <xsl:with-param name="currlistlvl" select="number('0')"/>
                        <xsl:with-param name="liststylename" select="string('00000')"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="name()='table:table'">
                    <xsl:variable name="tbs" select="./@table:style-name"/>
                    <xsl:if test="/office:document/office:automatic-styles/style:style[@style:name=$tbs]/@style:master-page-name">
                        <xsl:variable name="tbs1" select="/office:document/office:automatic-styles/style:style[@style:name=$tbs]/@style:master-page-name"/>
                        <xsl:if test="/office:document/office:master-styles/style:master-page[@style:name=$tbs1]/@style:page-layout-name">
                            <xsl:variable name="tbs2" select="/office:document/office:master-styles/style:master-page[@style:name=$tbs1]/@style:page-layout-name"/>
                            <xsl:for-each select="/office:document/office:automatic-styles/style:page-layout[@style:name=$tbs2]">
                                <xsl:call-template name="style:page-layout"/>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:if>
                    <xsl:call-template name="exec_table"/>
                </xsl:when>
                <xsl:when test="name()='text:table-of-content'">
                    <xsl:call-template name="text:table-of-content"/>
                </xsl:when>
                <xsl:when test="name()='text:alphabetical-index'">
                    <xsl:call-template name="text:alphabetical-index"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="jiaozhu">
        <字:脚注 uof:locID="t0107" uof:attrList="引文体">
            <xsl:for-each select="text:note-citation">
                <xsl:attribute name="字:引文体"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:for-each select="text:note-body/text:p">
                <xsl:call-template name="execParagraph">
                    <xsl:with-param name="currlistlvl" select="number('0')"/>
                    <xsl:with-param name="liststylename" select="string('00000')"/>
                </xsl:call-template>
            </xsl:for-each>
        </字:脚注>
    </xsl:template>
    <xsl:template name="weizhu">
        <字:尾注 uof:locID="t0108" uof:attrList="引文体">
            <xsl:for-each select="text:note-citation">
                <xsl:attribute name="字:引文体"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:for-each select="text:note-body/text:p">
                <xsl:call-template name="execParagraph">
                    <xsl:with-param name="currlistlvl" select="number('0')"/>
                    <xsl:with-param name="liststylename" select="string('00000')"/>
                </xsl:call-template>
            </xsl:for-each>
        </字:尾注>
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
    <xsl:template name="execParagraph">
        <xsl:param name="currlistlvl"/>
        <xsl:param name="liststylename"/>
        <字:段落 uof:locID="t0051" uof:attrList="标识符">
            <xsl:element name="字:段落属性">
                <xsl:attribute name="uof:locID">t0052</xsl:attribute>
                <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                <xsl:if test="@text:style-name">
                    <xsl:attribute name="字:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="not(number($currlistlvl) =number('0'))">
                    <xsl:variable name="parent-position">
                        <xsl:number from="/office:document/office:body/office:text/text:list" level="any" count="text:list-item/text:p" format="1"/>
                    </xsl:variable>
                    <xsl:element name="字:自动编号信息">
                        <xsl:attribute name="uof:locID">t0059</xsl:attribute>
                        <xsl:attribute name="uof:attrList">编号引用 编号级别 重新编号 起始编号</xsl:attribute>
                        <xsl:attribute name="字:编号引用"><xsl:value-of select="$liststylename"/></xsl:attribute>
                        <xsl:attribute name="字:编号级别"><xsl:value-of select="$currlistlvl - 1"/></xsl:attribute>
                        <xsl:attribute name="字:重新编号"><xsl:choose><xsl:when test="number($parent-position)=number('1')">1</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="字:起始编号"><xsl:for-each select="/office:document//text:list-style[$liststylename=@style:name]/*[number($currlistlvl)=number(@text:level)]"><xsl:choose><xsl:when test="@text:start-value"><xsl:value-of select="@text:start-value"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:for-each></xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:variable name="stylename">
                    <xsl:value-of select="@text:style-name"/>
                </xsl:variable>
                <xsl:for-each select="/office:document//style:style">
                    <xsl:if test="@style:name=$stylename">
                        <xsl:element name="字:句属性">
                            <xsl:attribute name="uof:locID">t0086</xsl:attribute>
                            <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                            <xsl:attribute name="字:式样引用"><xsl:value-of select="$stylename"/></xsl:attribute>
                            <xsl:call-template name="字:句属性"/>
                        </xsl:element>
                        <xsl:call-template name="ParaAttribute">
                            <xsl:with-param name="text-style-name" select="@style:name"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </xsl:element>
            <xsl:call-template name="textp"/>
            <xsl:if test="parent::office:text and not(preceding-sibling::text:p) and preceding-sibling::*[substring-before(name(),':')='draw']">
                <xsl:for-each select="preceding-sibling::*[substring-before(name(),':')='draw']">
                    <字:句 uof:locID="t0085">
                        <xsl:call-template name="字:锚点"/>
                    </字:句>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="draw:frame/draw:text-box/text:p">
                <xsl:for-each select="draw:frame/draw:text-box/text:p">
                    <xsl:for-each select="child::*[substring-before(name(),':')='draw']">
                        <字:句 uof:locID="t0085">
                            <xsl:call-template name="字:锚点"/>
                        </字:句>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:if>
            <xsl:variable name="aa">
                <xsl:value-of select="@text:style-name"/>
            </xsl:variable>
            <xsl:if test="//office:document/office:automatic-styles/style:style[@style:name=$aa]/style:paragraph-properties/@fo:break-before='column'">
                <字:句 uof:locID="t0085">
                    <xsl:element name="字:分栏符">
                        <xsl:attribute name="uof:locID">t0125</xsl:attribute>
                    </xsl:element>
                </字:句>
            </xsl:if>
            <xsl:if test="//office:document/office:automatic-styles/style:style[@style:name=$aa]/style:paragraph-properties/@fo:break-before='page'">
                <字:句 uof:locID="t0085">
                    <xsl:element name="字:分页符">
                        <xsl:attribute name="uof:locID">t0127</xsl:attribute>
                    </xsl:element>
                </字:句>
            </xsl:if>
            <xsl:if test="/office:document/office:body/office:text/text:p/text:initial-creator">
                <xsl:apply-templates select="text:initial-creator"/>
            </xsl:if>
            <xsl:if test="/office:document/office:body/office:text/text:p/text:title">
                <xsl:apply-templates select="text:title"/>
            </xsl:if>
            <xsl:if test="/office:document/office:body/office:text/text:p/text:subject">
                <xsl:apply-templates select="text:subject"/>
            </xsl:if>
            <xsl:if test="/office:document/office:body/office:text/text:p/text:file-name">
                <xsl:apply-templates select="text:file-name"/>
            </xsl:if>
            <xsl:if test="/office:document/office:body/office:text/text:p/text:author-name">
                <xsl:apply-templates select="text:author-name"/>
            </xsl:if>
            <xsl:if test="/office:document/office:body/office:text/text:p/text:author-initials">
                <xsl:apply-templates select="text:author-initials"/>
            </xsl:if>
            <xsl:if test="/office:document/office:body/office:text/text:p/text:span/text:date">
                <xsl:apply-templates select="text:date"/>
            </xsl:if>
        </字:段落>
    </xsl:template>
    <xsl:template name="ParaAttribute">
        <xsl:param name="text-style-name"/>
        <xsl:if test="substring-after(@style:display-name,'Heading')">
            <xsl:element name="字:大纲级别">
                <xsl:attribute name="uof:locID">t0054</xsl:attribute>
                <xsl:value-of select="substring-after(@style:display-name,'Heading ')"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:paragraph-properties/@fo:text-align or style:paragraph-properties/@style:vertical-align">
            <xsl:element name="字:对齐">
                <xsl:attribute name="uof:locID">t0055</xsl:attribute>
                <xsl:attribute name="uof:attrList">水平对齐 文字对齐</xsl:attribute>
                <xsl:attribute name="字:水平对齐"><xsl:choose><xsl:when test="style:paragraph-properties/@fo:text-align='end'">right</xsl:when><xsl:when test="style:paragraph-properties/@fo:text-align='center'">center</xsl:when><xsl:when test="style:paragraph-properties/@fo:text-align='justify' and not(style:paragraph-properties/@fo:text-align-last='justify')">justified</xsl:when><xsl:when test="style:paragraph-properties/@fo:text-align='justify' and style:paragraph-properties/@fo:text-align-last='justify'">distributed</xsl:when><xsl:otherwise>left</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="字:文字对齐"><xsl:choose><xsl:when test="style:paragraph-properties/@style:vertical-align='baseline'">base</xsl:when><xsl:when test="style:paragraph-properties/@style:vertical-align='top'">top</xsl:when><xsl:when test="style:paragraph-properties/@style:vertical-align='middle'">center</xsl:when><xsl:when test="style:paragraph-properties/@style:vertical-align='bottom'">bottom</xsl:when><xsl:otherwise>auto</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:paragraph-properties/@fo:margin-left or style:paragraph-properties/@fo:margin-right or style:paragraph-properties/@fo:text-indent">
            <xsl:element name="字:缩进">
                <xsl:attribute name="uof:locID">t0056</xsl:attribute>
                <xsl:for-each select="style:paragraph-properties">
                    <xsl:call-template name="字:缩进类型"/>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
        <xsl:element name="字:行距">
            <xsl:attribute name="uof:locID">t0057</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 值</xsl:attribute>
            <xsl:choose>
                <xsl:when test="contains(style:paragraph-properties/@fo:line-height,$ooUnit)">
                    <xsl:attribute name="字:类型">fixed</xsl:attribute>
                    <xsl:attribute name="字:值"><xsl:value-of select="substring-before(style:paragraph-properties/@fo:line-height,$ooUnit)"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="contains(style:paragraph-properties/@fo:line-height,'%')">
                    <xsl:attribute name="字:类型">multi-lines</xsl:attribute>
                    <xsl:attribute name="字:值"><xsl:value-of select="substring-before(style:paragraph-properties/@fo:line-height,'%') div 100"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="style:paragraph-properties/@style:line-height-at-least">
                    <xsl:attribute name="字:类型">at-least</xsl:attribute>
                    <xsl:attribute name="字:值"><xsl:value-of select="substring-before(style:paragraph-properties/@style:line-height-at-least,$ooUnit)"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="style:paragraph-properties/@style:line-spacing">
                    <xsl:attribute name="字:类型">line-space</xsl:attribute>
                    <xsl:attribute name="字:值"><xsl:value-of select="substring-before(style:paragraph-properties/@style:line-spacing,$ooUnit)"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:类型">multi-lines</xsl:attribute>
                    <xsl:attribute name="字:值">1.0</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:if test="style:paragraph-properties/@fo:widows">
            <xsl:element name="字:孤行控制">
                <xsl:attribute name="uof:locID">t0060</xsl:attribute>
                <xsl:value-of select="style:paragraph-properties/@fo:widows"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:paragraph-properties/@fo:orphans">
            <xsl:element name="字:寡行控制">
                <xsl:attribute name="uof:locID">t0061</xsl:attribute>
                <xsl:value-of select="style:paragraph-properties/@fo:orphans"/>
            </xsl:element>
        </xsl:if>
        <xsl:element name="字:段中不分页">
            <xsl:attribute name="uof:locID">t0062</xsl:attribute>
            <xsl:attribute name="uof:attrList">值</xsl:attribute>
            <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:paragraph-properties/@fo:keep-together='always'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:element>
        <xsl:if test="style:paragraph-properties/@fo:keep-with-next">
            <xsl:element name="字:与下段同页">
                <xsl:attribute name="uof:locID">t0063</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值">true</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:paragraph-properties/@fo:break-before">
            <xsl:element name="字:段前分页">
                <xsl:attribute name="uof:locID">t0064</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值">true</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:paragraph-properties/@style:snap-to-layout-grid">
            <xsl:element name="字:对齐网格">
                <xsl:attribute name="uof:locID">t0069</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:paragraph-properties/@style:snap-to-layout-grid='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:paragraph-properties/style:drop-cap/@style:lines">
            <xsl:element name="字:首字下沉">
                <xsl:attribute name="uof:locID">t0070</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型 字体引用 字符数 行数 间距</xsl:attribute>
                <xsl:attribute name="字:类型">dropped</xsl:attribute>
                <xsl:if test="style:paragraph-properties/style:drop-cap/@style:style-name">
                    <xsl:attribute name="字:字体引用"><xsl:value-of select="translate(style:paragraph-properties/style:drop-cap/@style:style-name,' ','_')"/></xsl:attribute>
                </xsl:if>
                <xsl:attribute name="字:间距"><xsl:choose><xsl:when test="style:paragraph-properties/style:drop-cap/@style:distance"><xsl:value-of select="substring-before(style:paragraph-properties/style:drop-cap/@style:distance,$ooUnit)"/></xsl:when><xsl:otherwise>0.00</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:if test="style:paragraph-properties/style:drop-cap/@style:length">
                    <xsl:attribute name="字:字符数"><xsl:value-of select="style:paragraph-properties/style:drop-cap/@style:length"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="style:paragraph-properties/style:drop-cap/@style:lines">
                    <xsl:attribute name="字:行数"><xsl:value-of select="style:paragraph-properties/style:drop-cap/@style:lines"/></xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
        <xsl:element name="字:取消断字">
            <xsl:attribute name="uof:locID">t0071</xsl:attribute>
            <xsl:attribute name="uof:attrList">值</xsl:attribute>
            <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:paragraph-properties/@fo:hyphenate"><xsl:value-of select="style:paragraph-properties/@fo:hyphenate"/></xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:element>
        <xsl:element name="字:取消行号">
            <xsl:attribute name="uof:locID">t0072</xsl:attribute>
            <xsl:attribute name="uof:attrList">值</xsl:attribute>
            <xsl:variable name="aa">
                <xsl:value-of select="style:paragraph-properties/@text:number-lines"/>
            </xsl:variable>
            <xsl:attribute name="字:值"><xsl:choose><xsl:when test="$aa='false'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:element>
        <xsl:element name="字:允许单词断字">
            <xsl:attribute name="字:值">true</xsl:attribute>
            <xsl:attribute name="uof:locID">t0073</xsl:attribute>
            <xsl:attribute name="uof:attrList">值</xsl:attribute>
        </xsl:element>
        <xsl:if test="style:paragraph-properties/@style:punctuation-wrap">
            <xsl:element name="字:行首尾标点控制">
                <xsl:attribute name="uof:locID">t0074</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:paragraph-properties/@style:punctuation-wrap='hanging'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:element name="字:是否行首标点压缩">
            <xsl:attribute name="uof:locID">t0075</xsl:attribute>
            <xsl:attribute name="uof:attrList">值</xsl:attribute>
            <xsl:attribute name="字:值">false</xsl:attribute>
        </xsl:element>
        <xsl:if test="style:paragraph-properties/@style:line-break ">
            <xsl:element name="字:中文习惯首尾字符">
                <xsl:attribute name="uof:locID">t0076</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:paragraph-properties/@style:line-break='strict'">true</xsl:when><xsl:when test="style:paragraph-properties/@style:line-break='normal'">false</xsl:when></xsl:choose></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:paragraph-properties/@style:text-autospace">
            <xsl:element name="字:自动调整中英文字符间距">
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:paragraph-properties/@style:text-autospace='ideograph-alpha'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="uof:locID">t0077</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:paragraph-properties/@style:text-autospace">
            <xsl:element name="字:自动调整中文与数字间距">
                <xsl:attribute name="字:值"><xsl:choose><xsl:when test="style:paragraph-properties/@style:text-autospace='ideograph-alpha'">true  </xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="uof:locID">t0078</xsl:attribute>
                <xsl:attribute name="uof:attrList">值</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:element name="字:有网格自动调整右缩进">
            <xsl:attribute name="字:值">false</xsl:attribute>
            <xsl:attribute name="uof:locID">t0195</xsl:attribute>
            <xsl:attribute name="uof:attrList">值</xsl:attribute>
        </xsl:element>
        <xsl:if test="style:paragraph-properties/@fo:border or style:paragraph-properties/@fo:border-top or style:paragraph-properties/@fo:border-bottom or style:paragraph-properties/@fo:border-left or style:paragraph-properties/@fo:border-right or style:paragraph-properties/@style:shadow[.!='none']">
            <xsl:element name="字:边框">
                <xsl:attribute name="uof:locID">t0065</xsl:attribute>
                <xsl:for-each select="style:paragraph-properties">
                    <xsl:call-template name="uof:边框"/>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:paragraph-properties/@fo:background-color">
            <xsl:element name="字:填充">
                <xsl:attribute name="uof:locID">t0066</xsl:attribute>
                <xsl:for-each select="style:paragraph-properties">
                    <xsl:call-template name="图:填充"/>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:paragraph-properties/@fo:margin-top or style:paragraph-properties/@fo:margin-bottom">
            <字:段间距 uof:locID="t0058">
                <xsl:if test="style:paragraph-properties/@fo:margin-top">
                    <字:段前距 uof:locID="t0196">
                        <字:绝对值 uof:locID="t0199" uof:attrList="值">
                            <xsl:attribute name="字:值"><xsl:value-of select="substring-before(style:paragraph-properties/@fo:margin-top,$ooUnit)"/></xsl:attribute>
                        </字:绝对值>
                    </字:段前距>
                </xsl:if>
                <xsl:if test="style:paragraph-properties/@fo:margin-bottom">
                    <字:段后距 uof:locID="t0197">
                        <字:绝对值 uof:locID="t0202" uof:attrList="值">
                            <xsl:attribute name="字:值"><xsl:value-of select="substring-before(style:paragraph-properties/@fo:margin-bottom,$ooUnit)"/></xsl:attribute>
                        </字:绝对值>
                    </字:段后距>
                </xsl:if>
            </字:段间距>
        </xsl:if>
        <xsl:if test="style:paragraph-properties/style:tab-stops">
            <xsl:element name="字:制表位设置">
                <xsl:attribute name="uof:locID">t0067</xsl:attribute>
                <xsl:for-each select="style:paragraph-properties/style:tab-stops/style:tab-stop">
                    <xsl:element name="字:制表位">
                        <xsl:attribute name="uof:locID">t0068</xsl:attribute>
                        <xsl:attribute name="uof:attrList">位置 类型 前导符 制表位字符</xsl:attribute>
                        <xsl:attribute name="字:位置"><xsl:value-of select="substring-before(@style:position,$ooUnit)"/></xsl:attribute>
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
                        <xsl:attribute name="字:制表位字符"><xsl:value-of select="@style:leader-text"/></xsl:attribute>
                        <xsl:if test="@style:leader-style">
                            <xsl:attribute name="字:前导符"><xsl:value-of select="@style:leader-style"/></xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
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
    <xsl:template name="textp" match="text:p">
        <xsl:variable name="parentstyle">
            <xsl:value-of select="@text:style-name"/>
        </xsl:variable>
        <xsl:for-each select="node( )">
            <xsl:choose>
                <xsl:when test="self::node()[name(.)='text:span']">
                    <xsl:call-template name="textspan"/>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:sequence']">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::node()/draw:text-box/text:p/text:sequence">
                    <xsl:for-each select="draw:text-box/text:p/node()">
                        <xsl:choose>
                            <xsl:when test="self::node()[name(.)='text:sequence']">
                                <xsl:apply-templates select="."/>
                            </xsl:when>
                            <xsl:when test="not(self::node()[substring-before(name(.),':')='draw'])">
                                <xsl:call-template name="字:句">
                                    <xsl:with-param name="parentstyle" select="$parentstyle"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:date']">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:time']">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:s']">
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="bText" select="0"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:file-name']">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:chapter']">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:editing-duration']">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:creation-time']">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:creation-date']">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:character-count']">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:page-count']">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:page-number']">
                    <xsl:apply-templates select="."/>
                </xsl:when>
                <xsl:when test="substring-before(name(.),':')='draw' and not(name(.)='draw:a')">
                    <字:句 uof:locID="t0085">
                        <xsl:call-template name="字:锚点"/>
                    </字:句>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:note']/@text:note-class='footnote'">
                    <字:句 uof:locID="t0085">
                        <xsl:call-template name="jiaozhu"/>
                    </字:句>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:note']/@text:note-class='endnote'">
                    <字:句 uof:locID="t0085">
                        <xsl:call-template name="weizhu"/>
                    </字:句>
                </xsl:when>
                <xsl:when test="name(.)='text:alphabetical-index-mark-start'">
                    <xsl:element name="字:句">
                        <xsl:element name="字:区域开始">
                            <xsl:attribute name="uof:locId">t0121</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符 名称 类型</xsl:attribute>
                            <xsl:attribute name="字:类型">user-data</xsl:attribute>
                            <xsl:attribute name="字:名称"><xsl:value-of select="@text:string-value-phonetic"/></xsl:attribute>
                            <xsl:attribute name="字:标识符"><xsl:value-of select="@text:id"/></xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="name(.)='text:alphabetical-index-mark-end'">
                    <xsl:element name="字:句">
                        <xsl:element name="字:区域结束" uof:locID="t0122" uof:attrList="标识符引用">
                            <xsl:attribute name="字:标识符引用"><xsl:value-of select="@text:id"/></xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="name(.)='text:bookmark' ">
                    <字:句 uof:locID="t0085">
                        <xsl:element name="字:句属性">
                            <xsl:attribute name="uof:locID">t0086</xsl:attribute>
                            <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                        </xsl:element>
                        <字:区域开始 uof:locID="t0121" uof:attrList="标识符 名称 类型" 字:名称="{@text:name}" 字:类型="bookmark" 字:标识符="{generate-id()}"/>
                        <字:区域结束 uof:locID="t0122" uof:attrList="标识符引用" 字:标识符引用="{generate-id()}"/>
                    </字:句>
                </xsl:when>
                <xsl:when test="name(.)='text:a'">
                    <字:句 uof:locID="t0085">
                        <xsl:element name="字:句属性">
                            <xsl:attribute name="uof:locID">t0086</xsl:attribute>
                            <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="字:区域开始">
                            <xsl:attribute name="字:标识符">hlnk<xsl:number from="/office:document/office:body/office:text" level="any" count="text:a"/></xsl:attribute>
                            <xsl:attribute name="字:名称">Hyperlink</xsl:attribute>
                            <xsl:attribute name="字:类型">hyperlink</xsl:attribute>
                            <xsl:attribute name="uof:locID">t0121</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符 名称 类型</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="字:文本串">
                            <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                            <xsl:value-of select="."/>
                        </xsl:element>
                        <xsl:element name="字:区域结束">
                            <xsl:attribute name="字:标识符引用">hlnk<xsl:number from="/office:document/office:body/office:text" level="any" count="text:a"/></xsl:attribute>
                            <xsl:attribute name="uof:locID">t0122</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符引用</xsl:attribute>
                        </xsl:element>
                    </字:句>
                </xsl:when>
                <xsl:when test="name(.)='office:annotation'">
                    <字:句 uof:locID="t0085">
                        <xsl:element name="字:句属性">
                            <xsl:attribute name="uof:locID">t0086</xsl:attribute>
                            <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="字:区域开始">
                            <xsl:attribute name="字:标识符">cmt<xsl:number from="/office:document/office:body/office:text" level="any" count="office:annotation"/></xsl:attribute>
                            <xsl:attribute name="字:名称">Comment</xsl:attribute>
                            <xsl:attribute name="字:类型">annotation</xsl:attribute>
                            <xsl:attribute name="uof:locID">t0121</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符 名称 类型</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="字:区域结束">
                            <xsl:attribute name="字:标识符引用">cmt<xsl:number from="/office:document/office:body/office:text" level="any" count="office:annotation"/></xsl:attribute>
                            <xsl:attribute name="uof:locID">t0122</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符引用</xsl:attribute>
                        </xsl:element>
                    </字:句>
                </xsl:when>
                <xsl:when test="self::node()[name(.)='text:change-start'] or self::node()[name(.)='text:change'] or self::node()[name(.)='text:change-end']">
                    <xsl:call-template name="xiuding"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="字:句">
                        <xsl:with-param name="parentstyle" select="$parentstyle"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="xiuding">
        <xsl:choose>
            <xsl:when test="self::node()[name(.)='text:change-start']or self::node()[name(.)='text:change']">
                <xsl:variable name="changeID">
                    <xsl:value-of select="@text:change-id"/>
                </xsl:variable>
                <xsl:for-each select="/office:document/office:body/office:text/text:tracked-changes/text:changed-region">
                    <xsl:if test="$changeID=@text:id">
                        <xsl:choose>
                            <xsl:when test="text:insertion">
                                <xsl:element name="字:修订开始">
                                    <xsl:attribute name="uof:locID">t0206</xsl:attribute>
                                    <xsl:attribute name="uof:attrList">标识符 类型 修订信息引用</xsl:attribute>
                                    <xsl:attribute name="字:标识符"><xsl:value-of select="@text:id"/></xsl:attribute>
                                    <xsl:attribute name="字:类型">insert</xsl:attribute>
                                    <xsl:attribute name="字:修订信息引用"><xsl:value-of select="@text:id"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="text:format-change">
                                <xsl:element name="字:修订开始">
                                    <xsl:attribute name="uof:locID">t0206</xsl:attribute>
                                    <xsl:attribute name="uof:attrList">标识符 类型 修订信息引用</xsl:attribute>
                                    <xsl:attribute name="字:标识符"><xsl:value-of select="@text:id"/></xsl:attribute>
                                    <xsl:attribute name="字:类型">format</xsl:attribute>
                                    <xsl:attribute name="字:修订信息引用"><xsl:value-of select="@text:id"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="text:deletion">
                                <xsl:element name="字:修订开始">
                                    <xsl:attribute name="uof:locID">t0206</xsl:attribute>
                                    <xsl:attribute name="uof:attrList">标识符 类型 修订信息引用</xsl:attribute>
                                    <xsl:attribute name="字:标识符"><xsl:value-of select="@text:id"/></xsl:attribute>
                                    <xsl:attribute name="字:类型">delete</xsl:attribute>
                                    <xsl:attribute name="字:修订信息引用"><xsl:value-of select="@text:id"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="self::node()[name(.)='text:change-end']">
                <xsl:variable name="changeendID">
                    <xsl:value-of select="@text:change-id"/>
                </xsl:variable>
                <xsl:for-each select="/office:document/office:body/office:text/text:tracked-changes/text:changed-region">
                    <xsl:if test="$changeendID=@text:id">
                        <xsl:choose>
                            <xsl:when test="text:insertion">
                                <xsl:element name="字:修订结束">
                                    <xsl:attribute name="uof:locID">t0207</xsl:attribute>
                                    <xsl:attribute name="uof:attrList">开始标识引用</xsl:attribute>
                                    <xsl:attribute name="字:开始标识引用"><xsl:value-of select="@text:id"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="text:deletion">
                                <xsl:element name="字:修订结束">
                                    <xsl:attribute name="uof:locID">t0207</xsl:attribute>
                                    <xsl:attribute name="uof:attrList">开始标识引用</xsl:attribute>
                                    <xsl:attribute name="字:开始标识引用"><xsl:value-of select="@text:id"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="text:format-change">
                                <xsl:element name="字:修订结束">
                                    <xsl:attribute name="uof:locID">t0207</xsl:attribute>
                                    <xsl:attribute name="uof:attrList">开始标识引用</xsl:attribute>
                                    <xsl:attribute name="字:开始标识引用"><xsl:value-of select="@text:id"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="字:句">
        <xsl:param name="parentstyle"/>
        <xsl:if test="not(name(.)='text:bookmark-start' or name(.)='text:bookmark-end' or  name(.)='draw:image' or name(.)='office:binary-data' or name(.)='text:page-number' or name(.)='text:page-count' or name(.)='text:initial-creator' or name(.)='text:author-name' or name(.)='text:author-initials' or name(.)='text:creation-time' or name(.)='text:creation-date' or name(.)='text:title' or name(.)='text:subject' or  name(.)='text:file-name' or name(.)='text:editing-duration'  or name(.)='text:character-count' or name(.)='text:chapter')">
            <字:句 uof:locID="t0085">
                <字:句属性 uof:locID="t0086" uof:attrList="式样引用">
                    <xsl:choose>
                        <xsl:when test="@text:style-name">
                            <xsl:attribute name="字:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                        </xsl:when>
                        <xsl:when test="parent::text:h/@text:outline-level">
                            <xsl:attribute name="字:式样引用"><xsl:value-of select="concat('Heading_20_',parent::text:h/@text:outline-level)"/></xsl:attribute>
                        </xsl:when>
                        <xsl:when test="parent::node()/@text:style-name">
                            <xsl:attribute name="字:式样引用"><xsl:value-of select="parent::node( )/@text:style-name"/></xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </字:句属性>
                <xsl:if test="ancestor::text:note-body">
                    <字:引文符号>
                        <xsl:value-of select="ancestor::text:note/text:note-citation"/>
                    </字:引文符号>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="(preceding-sibling::text:bookmark-start) and (following-sibling::text:bookmark-end)">
                        <字:区域开始 uof:locID="t0121" uof:attrList="标识符 名称 类型">
                            <xsl:attribute name="字:标识符"><xsl:value-of select="preceding-sibling::text:bookmark-start/@text:name"/></xsl:attribute>
                            <xsl:attribute name="字:名称">Bookmark</xsl:attribute>
                            <xsl:attribute name="字:类型">bookmark</xsl:attribute>
                        </字:区域开始>
                        <xsl:element name="字:文本串">
                            <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                            <xsl:value-of select="string(.)"/>
                        </xsl:element>
                        <字:区域结束 uof:locID="t0122" uof:attrList="标识符引用">
                            <xsl:attribute name="字:标识符引用"><xsl:value-of select="following-sibling::text:bookmark-end/@text:name"/></xsl:attribute>
                        </字:区域结束>
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
                        <xsl:call-template name="字:锚点"/>
                        <字:区域结束 uof:locID="t0122" uof:attrList="标识符引用">
                            <xsl:attribute name="字:标识符引用"><xsl:value-of select="$link-name"/></xsl:attribute>
                        </字:区域结束>
                    </xsl:when>
                    <xsl:when test="self::node( )[name(.)='text:tab']">
                        <xsl:element name="字:制表符">
                            <xsl:attribute name="uof:locID">t0123</xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="self::node( )[name(.)='text:line-break']">
                        <xsl:element name="字:换行符">
                            <xsl:attribute name="uof:locID">t0124</xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="name(.)='text:bookmark-start' or name(.)='text:bookmark-end' or  name(.)='draw:image' or name(.)='office:binary-data'">
                        </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="字:文本串">
                            <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                            <xsl:value-of select="string(.)"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </字:句>
        </xsl:if>
    </xsl:template>
    <xsl:template match="draw:text-box">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template name="text">
        <xsl:element name="字:句属性">
            <xsl:attribute name="uof:locID">t0086</xsl:attribute>
            <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
            <xsl:attribute name="字:式样引用"><xsl:value-of select="parent::node( )/@text:style-name"/></xsl:attribute>
        </xsl:element>
        <xsl:element name="字:文本串">
            <xsl:attribute name="uof:locID">t0109</xsl:attribute>
            <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
            <xsl:value-of select="string(.)"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="textspan">
        <字:句 uof:locID="t0085">
            <xsl:choose>
                <xsl:when test="./text:note/@text:note-class='footnote'">
                    <xsl:for-each select="text:note">
                        <xsl:call-template name="jiaozhu"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="./text:note/@text:note-class='endnote'">
                    <xsl:for-each select="text:note">
                        <xsl:call-template name="weizhu"/>
                    </xsl:for-each>
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
                        <xsl:for-each select="/office:document/office:automatic-styles//style:style[@style:family='text']">
                            <xsl:if test="@style:name=$textstyle">
                                <xsl:call-template name="SentenceXD">
                                    <xsl:with-param name="Sentencestyle" select="@style:name"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element>
                    <xsl:element name="字:文本串">
                        <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                        <xsl:value-of select="string(.)"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </字:句>
    </xsl:template>
    <xsl:template name="SentenceXD">
        <xsl:param name="Sentencestyle"/>
    </xsl:template>
    <xsl:template name="字:锚点">
        <xsl:if test="not(name(.)='draw:glue-point')">
            <xsl:variable name="name">
                <xsl:value-of select="name(.)"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="name='draw:a'">
                    <xsl:for-each select="child::node( )">
                        <xsl:call-template name="字:锚点"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$name = 'draw:g'">
                        <xsl:for-each select="child::*">
                            <xsl:call-template name="字:锚点"/>
                        </xsl:for-each>
                    </xsl:if>
                    <字:锚点 uof:locID="t0110" uof:attrList="标识符 类型">
                        <xsl:choose>
                            <xsl:when test="@text:anchor-type='as-char'">
                                <xsl:attribute name="字:类型">inline</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="字:类型">normal</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <字:锚点属性 uof:locID="t0111">
                            <字:宽度 uof:locID="t0112">
                                <xsl:choose>
                                    <xsl:when test="@svg:width">
                                        <xsl:value-of select="substring-before(@svg:width,$uofUnit)"/>
                                    </xsl:when>
                                    <xsl:when test="@svg:x1">
                                        <xsl:value-of select="substring-before(@svg:x2,$uofUnit) - substring-before(@svg:x1,$uofUnit)"/>
                                    </xsl:when>
                                </xsl:choose>
                            </字:宽度>
                            <字:高度 uof:locID="t0113">
                                <xsl:choose>
                                    <xsl:when test="@svg:height">
                                        <xsl:value-of select="substring-before(@svg:height,$uofUnit)"/>
                                    </xsl:when>
                                    <xsl:when test="@svg:x1">
                                        <xsl:value-of select="substring-before(@svg:y2,$uofUnit) - substring-before(@svg:y1,$uofUnit)"/>
                                    </xsl:when>
                                    <xsl:when test="child::draw:text-box/@fo:min-height">
                                        <xsl:value-of select="substring-before(child::draw:text-box/@fo:min-height,$uofUnit)"/>
                                    </xsl:when>
                                </xsl:choose>
                            </字:高度>
                            <xsl:if test="not(@text:anchor-type='as-char')">
                                <字:位置 uof:locID="t0114">
                                    <字:水平 uof:locID="t0176" uof:attrList="相对于">
                                        <xsl:for-each select="key('graphicset',@draw:style-name)/style:graphic-properties">
                                            <xsl:attribute name="字:相对于"><xsl:choose><xsl:when test="@style:horizontal-rel='page'">page</xsl:when><xsl:when test="@style:horizontal-rel='paragraph'">margin</xsl:when><xsl:when test="@style:horizontal-rel='page-content'">margin</xsl:when><xsl:when test="@style:horizontal-rel='paragraph-content'">margin</xsl:when><xsl:when test="@style:horizontal-rel='char'">char</xsl:when><xsl:otherwise>paragraph</xsl:otherwise></xsl:choose></xsl:attribute>
                                        </xsl:for-each>
                                        <xsl:choose>
                                            <xsl:when test="@svg:x or @svg:x1">
                                                <字:绝对 uof:locID="t0177" uof:attrList="值">
                                                    <xsl:attribute name="字:值"><xsl:choose><xsl:when test="@svg:x"><xsl:value-of select="substring-before(@svg:x,$uofUnit)"/></xsl:when><xsl:when test="@svg:x1"><xsl:value-of select="substring-before(@svg:x1,$uofUnit)"/></xsl:when></xsl:choose></xsl:attribute>
                                                </字:绝对>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <字:相对 uof:locID="t0178" uof:attrList="参考点 值">
                                                    <xsl:for-each select="key('graphicset',@draw:style-name)/style:graphic-properties">
                                                        <xsl:attribute name="字:值"><xsl:choose><xsl:when test="@style:horizontal-pos='left'">left</xsl:when><xsl:when test="@style:horizontal-pos='right'">right</xsl:when><xsl:when test="@style:horizontal-pos='center'">center</xsl:when></xsl:choose></xsl:attribute>
                                                    </xsl:for-each>
                                                </字:相对>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </字:水平>
                                    <字:垂直 uof:locID="t0179" uof:attrList="相对于">
                                        <xsl:for-each select="key('graphicset',@draw:style-name)/style:graphic-properties">
                                            <xsl:attribute name="字:相对于"><xsl:choose><xsl:when test="@style:vertical-rel='page'">page</xsl:when><xsl:when test="@style:vertical-rel='paragraph'">paragraph</xsl:when><xsl:when test="@style:vertical-rel='page-content'">margin</xsl:when><xsl:when test="@style:vertical-rel='paragraph-content'">margin</xsl:when><xsl:when test="@style:vertical-rel='line'">line</xsl:when><xsl:otherwise>paragraph</xsl:otherwise></xsl:choose></xsl:attribute>
                                        </xsl:for-each>
                                        <xsl:choose>
                                            <xsl:when test="@svg:y or @svg:y1">
                                                <字:绝对 uof:locID="t0180" uof:attrList="值">
                                                    <xsl:attribute name="字:值"><xsl:choose><xsl:when test="@svg:y"><xsl:value-of select="substring-before(@svg:y,$uofUnit)"/></xsl:when><xsl:when test="@svg:y1"><xsl:value-of select="substring-before(@svg:y1,$uofUnit)"/></xsl:when></xsl:choose></xsl:attribute>
                                                </字:绝对>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <字:相对 uof:locID="t0181" uof:attrList="参考点 值">
                                                    <xsl:for-each select="key('graphicset',@draw:style-name)/style:graphic-properties">
                                                        <xsl:attribute name="字:值"><xsl:choose><xsl:when test="@style:vertical-pos='bottom'">bottom</xsl:when><xsl:when test="@style:vertical-pos='top'">top</xsl:when><xsl:when test="@style:vertical-pos='middle'">center</xsl:when><xsl:when test="@style:vertical-pos='below'">inside</xsl:when></xsl:choose></xsl:attribute>
                                                    </xsl:for-each>
                                                </字:相对>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </字:垂直>
                                </字:位置>
                            </xsl:if>
                            <xsl:for-each select="key('graphicset',@draw:style-name)/style:graphic-properties">
                                <字:绕排 uof:locID="t0115" uof:attrList="绕排方式 环绕文字 绕排顶点">
                                    <xsl:variable name="wrap_type1">
                                        <xsl:value-of select="@style:wrap"/>
                                    </xsl:variable>
                                    <xsl:variable name="wrap_type2">
                                        <xsl:value-of select="@style:run-through"/>
                                    </xsl:variable>
                                    <xsl:variable name="a">
                                        <xsl:value-of select="@style:number-wrapped-paragraphs"/>
                                    </xsl:variable>
                                    <xsl:if test="$wrap_type1">
                                        <xsl:attribute name="字:绕排方式"><xsl:choose><xsl:when test="$wrap_type1='run-through' and $wrap_type2='background' ">behindtext</xsl:when><xsl:when test="$wrap_type1='run-through' and $a='1'">infrontoftext</xsl:when><xsl:when test="$wrap_type1='run-through'">through</xsl:when><xsl:when test="$wrap_type1='dynamic' ">top-bottom</xsl:when><xsl:when test="$wrap_type1='parallel' ">square</xsl:when><xsl:when test="$wrap_type1='left' or $wrap_type1='right'">tight</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="$wrap_type1='left' or $wrap_type1='right'">
                                        <xsl:attribute name="字:环绕文字"><xsl:choose><xsl:when test="$wrap_type1='left'">left</xsl:when><xsl:when test="$wrap_type1='right'">right</xsl:when></xsl:choose></xsl:attribute>
                                    </xsl:if>
                                </字:绕排>
                                <字:边距 uof:locID="t0116" uof:attrList="上 左 右 下">
                                    <xsl:choose>
                                        <xsl:when test="@fo:margin-top">
                                            <xsl:attribute name="字:上"><xsl:value-of select="substring-before(@fo:margin-top,$uofUnit)"/></xsl:attribute>
                                            <xsl:attribute name="字:下"><xsl:value-of select="substring-before(@fo:margin-bottom,$uofUnit)"/></xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="字:上">0.0</xsl:attribute>
                                            <xsl:attribute name="字:下">0.0</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="@fo:margin-right">
                                            <xsl:attribute name="字:右"><xsl:value-of select="substring-before(@fo:margin-right,$uofUnit)"/></xsl:attribute>
                                            <xsl:attribute name="字:左"><xsl:value-of select="substring-before(@fo:margin-left,$uofUnit)"/></xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="字:右">0.0</xsl:attribute>
                                            <xsl:attribute name="字:左">0.0</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </字:边距>
                                <字:锁定 uof:attrList="值" uof:locID="t0117">
                                    <xsl:attribute name="字:值"><xsl:choose><xsl:when test="@draw:move-protect='false'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
                                </字:锁定>
                                <字:保护 uof:locID="t0118" uof:attrList="值">
                                    <xsl:choose>
                                        <xsl:when test="$name='draw:image' or $name='draw:text-box'">
                                            <xsl:attribute name="字:值"><xsl:choose><xsl:when test="@style:protect = 'content size position' or @style:protect = 'content' or @style:protect = 'content size'  or @style:protect = 'size position' or @style:protect = 'size' or @style:protect = 'position' or @style:protect = 'content position' and @draw:size-protect= 'true'and @draw:move-protect= 'true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="字:值"><xsl:choose><xsl:when test="@style:protect = 'position size'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </字:保护>
                            </xsl:for-each>
                            <字:允许重叠 uof:locID="t0119" uof:attrList="值" 字:值="true"/>
                        </字:锚点属性>
                        <字:图形 uof:locID="t0120" uof:attrList="图形引用">
                            <xsl:variable name="refpicname">
                                <xsl:if test="@draw:style-name">
                                    <xsl:value-of select="@draw:style-name"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="picnumber">
                                <xsl:if test="@draw:style-name">
                                    <xsl:value-of select="count(preceding::*[@draw:style-name=$refpicname])"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:attribute name="字:图形引用"><xsl:value-of select="concat($refpicname,'_',$picnumber)"/></xsl:attribute>
                        </字:图形>
                    </字:锚点>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="liekuan">
        <xsl:param name="count"/>
        <xsl:param name="width"/>
        <xsl:if test="$count &gt; 0">
            <字:列宽 uof:locID="t0132">
                <xsl:value-of select="$width"/>
            </字:列宽>
            <xsl:call-template name="liekuan">
                <xsl:with-param name="count" select="$count -1"/>
                <xsl:with-param name="width" select="$width"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="exec_table" match="table:table">
        <xsl:param name="tabletype"/>
        <字:文字表 uof:locID="t0128" uof:attrList="类型">
            <xsl:choose>
                <xsl:when test="@table:is-sub-table='true'">
                    <xsl:attribute name="字:类型">sub-table</xsl:attribute>
                    <xsl:element name="字:文字表属性">
                        <xsl:attribute name="uof:locID">t0129</xsl:attribute>
                        <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                        <xsl:element name="字:列宽集">
                            <xsl:attribute name="uof:locID">t0131</xsl:attribute>
                            <xsl:for-each select="table:table-column">
                                <xsl:variable name="tableColName" select="@table:style-name"/>
                                <xsl:variable name="colWidth" select="substring-before(//style:style[@style:name=$tableColName and @style:family='table-column']/style:table-column-properties/@style:column-width,$ooUnit)"/>
                                <xsl:choose>
                                    <xsl:when test="@table:number-columns-repeated">
                                        <xsl:call-template name="liekuan">
                                            <xsl:with-param name="count" select="@table:number-columns-repeated"/>
                                            <xsl:with-param name="width" select="$colWidth"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <字:列宽 uof:locID="t0132">
                                            <xsl:value-of select="$colWidth"/>
                                        </字:列宽>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:类型">table</xsl:attribute>
                    <xsl:element name="字:文字表属性">
                        <xsl:attribute name="uof:locID">t0129</xsl:attribute>
                        <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                        <xsl:attribute name="字:式样引用"><xsl:value-of select="@table:style-name"/></xsl:attribute>
                        <xsl:variable name="tableName" select="@table:style-name"/>
                        <xsl:element name="字:列宽集">
                            <xsl:attribute name="uof:locID">t0131</xsl:attribute>
                            <xsl:for-each select="table:table-column">
                                <xsl:variable name="tableColName" select="@table:style-name"/>
                                <xsl:variable name="colWidth" select="substring-before(//style:style[@style:name=$tableColName and @style:family='table-column']/style:table-column-properties/@style:column-width,$ooUnit)"/>
                                <xsl:choose>
                                    <xsl:when test="@table:number-columns-repeated">
                                        <xsl:call-template name="liekuan">
                                            <xsl:with-param name="count" select="@table:number-columns-repeated"/>
                                            <xsl:with-param name="width" select="$colWidth"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <字:列宽 uof:locID="t0132">
                                            <xsl:value-of select="$colWidth"/>
                                        </字:列宽>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:element>
                        <xsl:for-each select="key('set_styleStyle',$tableName)">
                            <xsl:element name="字:宽度">
                                <xsl:attribute name="uof:locID">t0130</xsl:attribute>
                                <xsl:attribute name="uof:attrList">绝对宽度 相对宽度</xsl:attribute>
                                <xsl:attribute name="字:绝对宽度"><xsl:value-of select="substring-before(style:table-properties/@style:width,$ooUnit)"/></xsl:attribute>
                                <xsl:if test="style:table-properties/@style:rel-width">
                                    <xsl:attribute name="字:相对宽度"><xsl:value-of select="substring-before(style:table-properties/@style:rel-width,'%') div 100"/></xsl:attribute>
                                </xsl:if>
                            </xsl:element>
                            <xsl:element name="字:对齐">
                                <xsl:attribute name="uof:locID">t0133</xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="style:table-properties/@table:align='right'">right</xsl:when>
                                    <xsl:when test="style:table-properties/@table:align='center'">center</xsl:when>
                                    <xsl:otherwise>left</xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                            <xsl:if test="style:table-properties/@fo:margin-left">
                                <xsl:element name="字:左缩进">
                                    <xsl:attribute name="uof:locID">t0134</xsl:attribute>
                                    <xsl:value-of select="substring-before(style:table-properties/@fo:margin-left,$ooUnit)"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:element name="字:绕排">
                                <xsl:attribute name="uof:locID">t0135</xsl:attribute>
                                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                                <xsl:attribute name="字:值">around</xsl:attribute>
                            </xsl:element>
                            <xsl:element name="字:边框">
                                <xsl:attribute name="uof:locID">t0137</xsl:attribute>
                                <xsl:for-each select="style:table-properties">
                                    <xsl:call-template name="uof:边框"/>
                                </xsl:for-each>
                            </xsl:element>
                            <xsl:if test="style:table-properties/style:background-image/office:binary-data or style:table-properties/@fo:background-color  or style:page-layout-properties/@fo:background-color">
                                <字:填充 uof:locID="t0138">
                                    <xsl:for-each select="style:table-properties">
                                        <xsl:call-template name="图:填充">
                                            <xsl:with-param name="style-name" select="$tableName"/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </字:填充>
                            </xsl:if>
                            <xsl:element name="字:绕排边距">
                                <xsl:attribute name="uof:locID">t0139</xsl:attribute>
                                <xsl:attribute name="uof:attrList">上 左 右 下</xsl:attribute>
                                <xsl:if test="style:table-properties/@fo:margin-top">
                                    <xsl:attribute name="字:上"><xsl:value-of select="substring-before(style:table-properties/@fo:margin-top,$ooUnit)"/></xsl:attribute>
                                </xsl:if>
                                <xsl:if test="style:table-properties/@fo:margin-left">
                                    <xsl:attribute name="字:左"><xsl:value-of select="substring-before(style:table-properties/@fo:margin-left,$ooUnit)"/></xsl:attribute>
                                </xsl:if>
                                <xsl:if test="style:table-properties/@fo:margin-right">
                                    <xsl:attribute name="字:右"><xsl:value-of select="substring-before(style:table-properties/@fo:margin-right,$ooUnit)"/></xsl:attribute>
                                </xsl:if>
                                <xsl:if test="style:table-properties/@fo:margin-bottom">
                                    <xsl:attribute name="字:下"><xsl:value-of select="substring-before(style:table-properties/@fo:margin-bottom,$ooUnit)"/></xsl:attribute>
                                </xsl:if>
                            </xsl:element>
                            <xsl:element name="字:自动调整大小">
                                <xsl:attribute name="字:值">true</xsl:attribute>
                                <xsl:attribute name="uof:locID">t0140</xsl:attribute>
                                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                            </xsl:element>
                            <xsl:element name="字:默认单元格边距">
                                <xsl:attribute name="uof:locID">t0141</xsl:attribute>
                                <xsl:attribute name="uof:attrList">上 左 右 下</xsl:attribute>
                                <xsl:attribute name="字:上">0.10</xsl:attribute>
                                <xsl:attribute name="字:左">0.10</xsl:attribute>
                                <xsl:attribute name="字:右">0.10</xsl:attribute>
                                <xsl:attribute name="字:下">0.10</xsl:attribute>
                            </xsl:element>
                            <xsl:element name="字:默认单元格间距">
                                <xsl:attribute name="uof:locID">t0142</xsl:attribute>
                                <xsl:value-of select="'0.00'"/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="table:table-header-rows/table:table-row"/>
            <xsl:apply-templates select="table:table-row"/>
        </字:文字表>
    </xsl:template>
    <xsl:key name="set_colWidth" match="//office:automatic-styles/style:style[@style:family='table-column']" use="@style:name"/>
    <xsl:key name="set_styleStyle" match="//office:automatic-styles/style:style" use="@style:name"/>
    <xsl:template match="table:table-row">
        <xsl:element name="字:行">
            <xsl:attribute name="uof:locID">t0143</xsl:attribute>
            <xsl:variable name="rowStyleName" select="@table:style-name|table:table-row/@table:style-name"/>
            <xsl:element name="字:表行属性">
                <xsl:attribute name="uof:locID">t0144</xsl:attribute>
                <xsl:for-each select="key('set_styleStyle',$rowStyleName)/style:table-row-properties[@style:row-height or @style:min-row-height]">
                    <xsl:element name="字:高度">
                        <xsl:if test="@style:row-height">
                            <xsl:attribute name="字:固定值"><xsl:value-of select="substring-before(@style:row-height,$ooUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@style:min-row-height">
                            <xsl:attribute name="字:最小值"><xsl:value-of select="substring-before(@style:min-row-height,$ooUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="uof:locID">t0145</xsl:attribute>
                        <xsl:attribute name="uof:attrList">固定值 最小值</xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
                <xsl:if test="key('set_styleStyle',$rowStyleName)/style:table-row-properties[@style:keep-together]">
                    <xsl:element name="字:跨页">
                        <xsl:attribute name="uof:locID">t0146</xsl:attribute>
                        <xsl:attribute name="uof:attrList">值</xsl:attribute>
                        <xsl:for-each select="key('set_styleStyle',$rowStyleName)/style:table-row-properties[@style:keep-together]">
                            <xsl:attribute name="字:值"><xsl:choose><xsl:when test="@style:keep-together='false'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="name(..)='table:table-header-rows'">
                    <xsl:element name="字:表头行">
                        <xsl:attribute name="uof:locID">t0147</xsl:attribute>
                        <xsl:attribute name="uof:attrList">值</xsl:attribute>
                        <xsl:attribute name="字:值">true</xsl:attribute>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="name()='table:table-cell'">
                        <xsl:element name="字:单元格">
                            <xsl:attribute name="uof:locID">t0148</xsl:attribute>
                            <xsl:call-template name="execTableCellAttribute"/>
                            <xsl:for-each select="node( )">
                                <xsl:choose>
                                    <xsl:when test="name()='text:p'">
                                        <xsl:call-template name="execParagraph">
                                            <xsl:with-param name="currlistlvl" select="number('0')"/>
                                            <xsl:with-param name="liststylename" select="string('00000')"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:when test="name()='table:table' or name()='table:sub-table' or self::node()/@table:is-sub-table='true'">
                                        <xsl:call-template name="exec_table">
                                            <xsl:with-param name="tabletype" select="name()"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template name="execTableCellAttribute">
        <xsl:element name="字:单元格属性">
            <xsl:attribute name="uof:locID">t0149</xsl:attribute>
            <xsl:variable name="StyleName" select="@table:style-name"/>
            <xsl:element name="字:宽度">
                <xsl:attribute name="uof:locID">t0150</xsl:attribute>
                <xsl:attribute name="uof:attrList">绝对值 相对值</xsl:attribute>
                <xsl:variable name="sn">
                    <xsl:number from="/office:document/office:body/office:text" level="single" count="table:table-cell" format="1"/>
                </xsl:variable>
                <xsl:variable name="sn1">
                    <xsl:choose>
                        <xsl:when test="../../table:table-column[number($sn)]/@table:style-name">
                            <xsl:value-of select="$sn"/>
                        </xsl:when>
                        <xsl:when test=" name(../..)='table:table-header-rows' and ../../../table:table-column[number($sn)]/@table:style-name">
                            <xsl:value-of select="$sn"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'1'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="KuanDu">
                    <xsl:choose>
                        <xsl:when test=" name(../..)='table:table-header-rows' and ../../../table:table-column[number($sn)]/@table:style-name">
                            <xsl:value-of select="../../../table:table-column[number($sn1)]/@table:style-name"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="../../table:table-column[number($sn1)]/@table:style-name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="字:绝对值"><xsl:value-of select="substring-before(key('set_colWidth',$KuanDu)/style:table-column-properties/@style:column-width,$ooUnit)"/></xsl:attribute>
                <xsl:if test="key('set_colWidth',$KuanDu)/style:table-column-properties/@style:rel-column-width">
                    <xsl:attribute name="字:相对值"><xsl:value-of select="substring-before(key('set_colWidth',$KuanDu)/style:table-column-properties/@style:rel-column-width,'*')"/></xsl:attribute>
                </xsl:if>
            </xsl:element>
            <xsl:if test="@table:number-columns-spanned">
                <xsl:element name="字:跨列">
                    <xsl:attribute name="uof:locID">t0156</xsl:attribute>
                    <xsl:attribute name="uof:attrList">值</xsl:attribute>
                    <xsl:attribute name="字:值"><xsl:value-of select="@table:number-columns-spanned"/></xsl:attribute>
                </xsl:element>
            </xsl:if>
            <xsl:for-each select="key('set_styleStyle',$StyleName)">
                <xsl:element name="字:单元格边距">
                    <xsl:attribute name="uof:locID">t0151</xsl:attribute>
                    <xsl:attribute name="uof:attrList">上 左 右 下</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="style:table-cell-properties/@fo:padding">
                            <xsl:attribute name="字:上"><xsl:value-of select="substring-before(style:table-cell-properties/@fo:padding,$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="字:左"><xsl:value-of select="substring-before(style:table-cell-properties/@fo:padding,$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="字:右"><xsl:value-of select="substring-before(style:table-cell-properties/@fo:padding,$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="字:下"><xsl:value-of select="substring-before(style:table-cell-properties/@fo:padding,$uofUnit)"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="字:上"><xsl:value-of select="substring-before(style:table-cell-properties/@fo:padding-top,$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="字:左"><xsl:value-of select="substring-before(style:table-cell-properties/@fo:padding-left,$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="字:右"><xsl:value-of select="substring-before(style:table-cell-properties/@fo:padding-right,$uofUnit)"/></xsl:attribute>
                            <xsl:attribute name="字:下"><xsl:value-of select="substring-before(style:table-cell-properties/@fo:padding-bottom,$uofUnit)"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:if test="style:table-cell-properties/@fo:border or style:table-cell-properties/@fo:border-top or style:table-cell-properties/@fo:border-bottom or style:table-cell-properties/@fo:border-left or style:table-cell-properties/@fo:border-right or style:table-cell-properties/@style:shadow">
                    <xsl:element name="字:边框">
                        <xsl:attribute name="uof:locID">t0152</xsl:attribute>
                        <xsl:for-each select="style:table-cell-properties">
                            <xsl:call-template name="uof:边框"/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="style:table-cell-properties/style:background-image/office:binary-data or style:table-cell-properties/@fo:background-color">
                    <字:填充 uof:locID="t0153">
                        <xsl:for-each select="style:table-cell-properties">
                            <xsl:call-template name="图:填充"/>
                        </xsl:for-each>
                    </字:填充>
                </xsl:if>
                <字:垂直对齐方式 uof:locID="t0154">
                    <xsl:choose>
                        <xsl:when test="style:table-cell-properties/@style:vertical-align='middle'">center</xsl:when>
                        <xsl:when test="style:table-cell-properties/@style:vertical-align='bottom'">bottom</xsl:when>
                        <xsl:otherwise>top</xsl:otherwise>
                    </xsl:choose>
                </字:垂直对齐方式>
                <xsl:element name="字:自动换行">
                    <xsl:attribute name="字:值">true</xsl:attribute>
                    <xsl:attribute name="uof:locID">t0157</xsl:attribute>
                    <xsl:attribute name="uof:attrList">值</xsl:attribute>
                </xsl:element>
                <xsl:element name="字:适应文字">
                    <xsl:attribute name="字:值">true</xsl:attribute>
                    <xsl:attribute name="uof:locID">t0158</xsl:attribute>
                    <xsl:attribute name="uof:attrList">值</xsl:attribute>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:key name="bpath" match="//office:document/office:body/office:text/text:p/text:span" use="@text:style-name"/>
    <xsl:template name="字:句属性">
        <xsl:element name="字:字体">
            <xsl:attribute name="uof:locID">t0088</xsl:attribute>
            <xsl:attribute name="uof:attrList">西文字体引用 中文字体引用 特殊字体引用 西文绘制 字号 相对字号 颜色</xsl:attribute>
            <xsl:if test="contains(@style:parent-style-name,'Header') or contains(@style:parent-style-name,'Foot') or contains(@style:parent-style-name,'Endnote')">
                <xsl:attribute name="字:字号">9</xsl:attribute>
            </xsl:if>
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
            <xsl:if test="style:text-properties/@style:font-name">
                <xsl:variable name="xiwen" select="style:text-properties/@style:font-name"/>
                <xsl:attribute name="字:西文字体引用"><xsl:value-of select="translate($xiwen,' ','_')"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="style:text-properties/@style:font-name-asian">
                <xsl:attribute name="字:中文字体引用"><xsl:value-of select="style:text-properties/@style:font-name-asian"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="style:text-properties/@fo:color">
                <xsl:attribute name="字:颜色"><xsl:value-of select="style:text-properties/@fo:color"/></xsl:attribute>
            </xsl:if>
        </xsl:element>
        <xsl:if test="style:text-properties/@fo:background-color and not(style:text-properties/@style:text-background-color='transparent')">
            <xsl:element name="字:填充">
                <xsl:attribute name="uof:locID">t0093</xsl:attribute>
                <xsl:element name="图:图案">
                    <xsl:attribute name="uof:locID">g0036</xsl:attribute>
                    <xsl:attribute name="uof:attrList">类型 图形引用 前景色 背景色</xsl:attribute>
                    <xsl:if test="style:text-properties/@fo:background-color">
                        <xsl:attribute name="图:前景色"><xsl:choose><xsl:when test="style:text-properties/@fo:background-color='transparent'">auto</xsl:when><xsl:otherwise><xsl:value-of select="style:text-properties/@fo:background-color"/></xsl:otherwise></xsl:choose></xsl:attribute>
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
        <xsl:if test="style:text-properties/@fo:background-color|style:text-properties/@style:text-background-color">
            <xsl:element name="字:突出显示">
                <xsl:attribute name="字:颜色"><xsl:choose><xsl:when test="style:text-properties/@fo:background-color='transparent' or style:text-properties/@style:text-background-color='transparent'">auto</xsl:when><xsl:otherwise><xsl:value-of select="style:text-properties/@fo:background-color|style:text-properties/@style:text-background-color"/></xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="uof:locID">t0091</xsl:attribute>
                <xsl:attribute name="uof:attrList">颜色</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:text-line-through-style">
            <xsl:element name="字:删除线">
                <xsl:attribute name="uof:locID">t0094</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型</xsl:attribute>
                <xsl:attribute name="字:类型"><xsl:call-template name="uof:删除线类型"><xsl:with-param name="lineType" select="style:text-properties/@style:text-line-through-style"/></xsl:call-template></xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:text-underline-style">
            <xsl:element name="字:下划线">
                <xsl:attribute name="uof:locID">t0095</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型 颜色 字下划线</xsl:attribute>
                <xsl:attribute name="字:类型"><xsl:call-template name="uof:线型类型"/></xsl:attribute>
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
                <xsl:attribute name="字:类型"><xsl:call-template name="uof:着重号类型"><xsl:with-param name="te" select="style:text-properties/@style:text-emphasize"/></xsl:call-template></xsl:attribute>
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
                <xsl:variable name="aa">
                    <xsl:value-of select="style:text-properties/@style:text-position"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains($aa,'sub')">
                        <xsl:value-of select="substring-before($aa,' ')"/>
                    </xsl:when>
                    <xsl:when test="contains($aa,'super')">
                        <xsl:value-of select="substring-before($aa,' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="translate($aa,'%','')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:text-scale">
            <xsl:element name="字:缩放">
                <xsl:attribute name="uof:locID">t0103</xsl:attribute>
                <xsl:variable name="scale" select="style:text-properties/@style:text-scale"/>
                <xsl:choose>
                    <xsl:when test="contains($scale,'%')">
                        <xsl:value-of select="substring-before($scale,'%')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="style:text-properties/@style:text-scale"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@fo:letter-spacing">
            <xsl:element name="字:字符间距">
                <xsl:attribute name="uof:locID">t0104</xsl:attribute>
                <xsl:value-of select="substring-before(style:text-properties/@fo:letter-spacing,$uofUnit)"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="style:text-properties/@style:letter-kerning">
            <xsl:element name="字:调整字间距">
                <xsl:variable name="tt" select="style:text-properties/@style:letter-kerning"/>
                <xsl:attribute name="uof:locID">t0105</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$tt='true'">1</xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
        <xsl:element name="字:字符对齐网格">
            <xsl:attribute name="字:值">false</xsl:attribute>
            <xsl:attribute name="uof:locID">t0106</xsl:attribute>
            <xsl:attribute name="uof:attrList">值</xsl:attribute>
        </xsl:element>
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
            <xsl:otherwise>none</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="uof:删除线类型">
        <xsl:param name="lineType"/>
        <xsl:variable name="tw" select="style:text-properties/@style:text-line-through-width"/>
        <xsl:variable name="tt" select="style:text-properties/@style:text-line-through-text"/>
        <xsl:variable name="ttp" select="style:text-properties/@style:text-line-through-type"/>
        <xsl:choose>
            <xsl:when test="$lineType='solid'and $ttp='double'">double</xsl:when>
            <xsl:when test="$lineType='solid'and $tw='bold'">bold</xsl:when>
            <xsl:when test="$lineType='solid'and $tt='X'">xl</xsl:when>
            <xsl:when test="$lineType='solid'and $tt='/'">/l</xsl:when>
            <xsl:otherwise>
                <xsl:if test="not($lineType='none') ">single</xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="uof:着重号类型">
        <xsl:param name="te"/>
        <xsl:choose>
            <xsl:when test="$te='disc above' ">disc above</xsl:when>
            <xsl:when test="$te='circle above' ">circle above</xsl:when>
            <xsl:when test="$te='dot above' ">dot above</xsl:when>
            <xsl:when test="$te='accent above' ">accent above</xsl:when>
            <xsl:when test="$te='dot below' ">dot</xsl:when>
            <xsl:when test="$te='circle below' ">circle below</xsl:when>
            <xsl:when test="$te='disc below' ">disc below</xsl:when>
            <xsl:when test="$te='accent below' ">accent below</xsl:when>
            <xsl:otherwise>none</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="uof:边框">
        <xsl:choose>
            <xsl:when test="@fo:border">
                <xsl:call-template name="uof:左边框">
                    <xsl:with-param name="border" select="@fo:border"/>
                </xsl:call-template>
                <xsl:call-template name="uof:上边框">
                    <xsl:with-param name="border" select="@fo:border"/>
                </xsl:call-template>
                <xsl:call-template name="uof:右边框">
                    <xsl:with-param name="border" select="@fo:border"/>
                </xsl:call-template>
                <xsl:call-template name="uof:下边框">
                    <xsl:with-param name="border" select="@fo:border"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="@fo:border-left or contains(substring-before(substring-after(@style:shadow,' '),' '),'-')">
                    <xsl:call-template name="uof:左边框">
                        <xsl:with-param name="border" select="@fo:border-left"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="@fo:border-top or contains(substring-after(substring-after(@style:shadow,' '),' '),'-')">
                    <xsl:call-template name="uof:上边框">
                        <xsl:with-param name="border" select="@fo:border-top"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="@fo:border-right or substring-before(substring-before(substring-after(@style:shadow,' '),' '),$ooUnit) &gt;0 or contains(substring-before(substring-after(@style:shadow,' '),' '),'+')">
                    <xsl:call-template name="uof:右边框">
                        <xsl:with-param name="border" select="@fo:border-right"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="@fo:border-bottom or substring-before(substring-after(substring-after(@style:shadow,' '),' '),$ooUnit) &gt;0 or contains(substring-after(substring-after(@style:shadow,' '),' '),'+')">
                    <xsl:call-template name="uof:下边框">
                        <xsl:with-param name="border" select="@fo:border-bottom"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="uof:左边框">
        <xsl:param name="border"/>
        <xsl:element name="uof:左">
            <xsl:attribute name="uof:locID">u0057</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
            <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border!='none'"><xsl:choose><xsl:when test="substring-before(substring-after($border,' '),' ')='solid'">single</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='double'">double</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dashed'">dash</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dotted'">dotted</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:if test="$border!='none'">
                <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(substring-before($border,' '),substring($ooUnit,1,2))"/></xsl:attribute>
                <xsl:attribute name="uof:颜色"><xsl:value-of select="substring-after(substring-after($border,' '),' ')"/></xsl:attribute>
                <xsl:if test="@fo:padding or @fo:padding-left">
                    <xsl:attribute name="uof:边距"><xsl:choose><xsl:when test="@fo:padding-left"><xsl:value-of select="substring-before(@fo:padding-left,$ooUnit)"/></xsl:when><xsl:otherwise><xsl:value-of select="substring-before(@fo:padding,$ooUnit)"/></xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:if test="contains(substring-before(substring-after(@style:shadow,' '),' '),'-')">
                <xsl:attribute name="uof:阴影">true</xsl:attribute>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="uof:上边框">
        <xsl:param name="border"/>
        <xsl:element name="uof:上">
            <xsl:attribute name="uof:locID">u0058</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
            <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border!='none'"><xsl:choose><xsl:when test="substring-before(substring-after($border,' '),' ')='solid'">single</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='double'">double</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dashed'">dash</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dotted'">dotted</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:if test="$border!='none'">
                <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(substring-before($border,' '),substring($ooUnit,1,2))"/></xsl:attribute>
                <xsl:attribute name="uof:颜色"><xsl:value-of select="substring-after(substring-after($border,' '),' ')"/></xsl:attribute>
                <xsl:if test="@fo:padding or @fo:padding-top">
                    <xsl:attribute name="uof:边距"><xsl:choose><xsl:when test="@fo:padding-top"><xsl:value-of select="substring-before(@fo:padding-top,$ooUnit)"/></xsl:when><xsl:otherwise><xsl:value-of select="substring-before(@fo:padding,$ooUnit)"/></xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:if test="contains(substring-after(substring-after(@style:shadow,' '),' '),'-')">
                <xsl:attribute name="uof:阴影">true</xsl:attribute>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="uof:右边框">
        <xsl:param name="border"/>
        <xsl:element name="uof:右">
            <xsl:attribute name="uof:locID">u0059</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
            <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border!='none'"><xsl:choose><xsl:when test="substring-before(substring-after($border,' '),' ')='solid'">single</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='double'">double</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dashed'">dash</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dotted'">dotted</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:if test="$border!='none'">
                <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(substring-before($border,' '),substring($ooUnit,1,2))"/></xsl:attribute>
                <xsl:attribute name="uof:颜色"><xsl:value-of select="substring-after(substring-after($border,' '),' ')"/></xsl:attribute>
                <xsl:if test="@fo:padding or @fo:padding-right">
                    <xsl:attribute name="uof:边距"><xsl:choose><xsl:when test="@fo:padding-right"><xsl:value-of select="substring-before(@fo:padding-right,$ooUnit)"/></xsl:when><xsl:otherwise><xsl:value-of select="substring-before(@fo:padding,$ooUnit)"/></xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:if test="substring-before(substring-before(substring-after(@style:shadow,' '),' '),$ooUnit) &gt;0 or contains(substring-before(substring-after(@style:shadow,' '),' '),'+')">
                <xsl:attribute name="uof:阴影">true</xsl:attribute>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="uof:下边框">
        <xsl:param name="border"/>
        <xsl:element name="uof:下">
            <xsl:attribute name="uof:locID">u0060</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 宽度 边距 颜色 阴影</xsl:attribute>
            <xsl:attribute name="uof:类型"><xsl:choose><xsl:when test="$border!='none'"><xsl:choose><xsl:when test="substring-before(substring-after($border,' '),' ')='solid'">single</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='double'">double</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dashed'">dash</xsl:when><xsl:when test="substring-before(substring-after($border,' '),' ')='dotted'">dotted</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:if test="$border!='none'">
                <xsl:attribute name="uof:宽度"><xsl:value-of select="substring-before(substring-before($border,' '),substring($ooUnit,1,2))"/></xsl:attribute>
                <xsl:attribute name="uof:颜色"><xsl:value-of select="substring-after(substring-after($border,' '),' ')"/></xsl:attribute>
                <xsl:if test="@fo:padding or @fo:padding-bottom">
                    <xsl:attribute name="uof:边距"><xsl:choose><xsl:when test="@fo:padding-bottom"><xsl:value-of select="substring-before(@fo:padding-bottom,$ooUnit)"/></xsl:when><xsl:otherwise><xsl:value-of select="substring-before(@fo:padding,$ooUnit)"/></xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:if test="substring-before(substring-after(substring-after(@style:shadow,' '),' '),$ooUnit) &gt;0 or contains(substring-after(substring-after(@style:shadow,' '),' '),'+')">
                <xsl:attribute name="uof:阴影">true</xsl:attribute>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:key name="geshi" match="//office:document/office:automatic-styles/number:date-style | //office:document/office:automatic-styles/number:time-style" use="@style:name"/>
    <xsl:template name="inline-text">
        <xsl:param name="pStyleName"/>
        <xsl:param name="bText"/>
        <xsl:apply-templates select="text()|textspan|jiaozhu|weizhu|office:annotation|text:sequence|text:date|text:time|text:page-number|text:page-count|text:subject|text:title|text:initial-creator|text:author-name|text:author-initials|text:file-name|text:change-start|text:change-end|text:change">
            <xsl:with-param name="pStyleName" select="$pStyleName"/>
            <xsl:with-param name="bText" select="$bText"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="text:sequence">
        <xsl:param name="tStyle"/>
        <xsl:if test="@text:name='Illustration'  or @text:name='Text'  or @text:name='Drawing'  or @text:name='Table'">
            <xsl:element name="字:域开始">
                <xsl:attribute name="字:类型"><xsl:value-of select="'seq'"/></xsl:attribute>
                <xsl:attribute name="uof:locID">t0079</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            </xsl:element>
            <xsl:element name="字:域代码">
                <xsl:attribute name="uof:locID">t0080</xsl:attribute>
                <字:段落 uof:locID="t0051" uof:attrList="标识符">
                    <字:句 uof:locID="t0085">
                        <xsl:if test="$tStyle!=''">
                            <字:句属性 字:式样引用="{$tStyle}" uof:locID="t0086" uof:attrList="式样引用"/>
                        </xsl:if>
                        <xsl:variable name="fmt">
                            <xsl:call-template name="oo数字格式域开关">
                                <xsl:with-param name="oo_format" select="@style:num-format"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <字:文本串>
                            <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                            <xsl:value-of select="concat('SEQ ',@text:name,' \* ',$fmt,' \f ',@text:formula)"/>
                        </字:文本串>
                    </字:句>
                </字:段落>
            </xsl:element>
            <字:句 uof:locID="t0085">
                <字:文本串>
                    <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                    <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                    <xsl:value-of select="string(.)"/>
                </字:文本串>
            </字:句>
            <xsl:element name="字:域结束">
                <xsl:attribute name="uof:locID">t0081</xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="text:time">
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'time'"/></xsl:attribute>
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
            <xsl:attribute name="uof:locID">t0080</xsl:attribute>
            <字:段落 uof:locID="t0051" uof:attrList="标识符">
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
                                    <xsl:if test="self::node( )[name(.)='number:am-pm']">am/pm</xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="quote">"</xsl:variable>
                    <字:文本串>
                        <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                        <xsl:value-of select="concat('TIME \@ ',$quote,$timefmt,$quote)"/>
                    </字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串>
                <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                <xsl:value-of select="string(.)"/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text:date">
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'date'"/></xsl:attribute>
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
            <xsl:attribute name="uof:locID">t0080</xsl:attribute>
            <字:段落 uof:locID="t0051" uof:attrList="标识符">
                <字:句 uof:locID="t0085">
                    <字:句属性 uof:locID="t0086" uof:attrList="式样引用"/>
                    <xsl:variable name="datefmt">
                        <xsl:variable name="bb" select="@style:data-style-name"/>
                        <xsl:for-each select="key('geshi',$bb)/number:year | key('geshi',$bb)/number:month | key('geshi',$bb)/number:day |  key('geshi',$bb)/number:hours |  key('geshi',$bb)/number:minutes | key('geshi',$bb)/number:seconds | key('geshi',$bb)/number:quarter | key('geshi',$bb)/number:day-of-week | key('geshi',$bb)/number:week-of-year |  key('geshi',$bb)/number:text | key('geshi',$bb)/number:am-pm">
                            <xsl:choose>
                                <xsl:when test="@number:style='long' ">
                                    <xsl:if test="self::node( )[name(.)='number:year']">yyyy</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:month']">MM</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:day']">dd</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:hours']">hh</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:minutes']">mm</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:seconds']">ss</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:quarter']">第QQ季度</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:day-of-week']">星期N</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:week-of-year']">WW</xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="self::node( )[name(.)='number:text']">
                                        <xsl:value-of select="."/>
                                    </xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:year']">yy</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:month']">M</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:day']">d</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:hours']">h</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:minutes']">m</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:seconds']">s</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:quarter']">Q季</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:day-of-week']">星期N</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:week-of-year']">WW</xsl:if>
                                    <xsl:if test="self::node( )[name(.)='number:am-pm']">am/pm</xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="quote">"</xsl:variable>
                    <字:文本串>
                        <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                        <xsl:value-of select="concat('CREATEDATE \@ ',$quote,$datefmt,$quote)"/>
                    </字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串>
                <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                <xsl:value-of select="string(.)"/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template name="oo数字格式域开关">
        <xsl:param name="oo_format"/>
        <xsl:choose>
            <xsl:when test="$oo_format='1'">Arabic</xsl:when>
            <xsl:when test="$oo_format='I'">ROMAN</xsl:when>
            <xsl:when test="$oo_format='i'">roman</xsl:when>
            <xsl:when test="$oo_format='A'">ALPHABETIC</xsl:when>
            <xsl:when test="$oo_format='a'">alphabetic</xsl:when>
            <xsl:when test="$oo_format='１, ２, ３, ...'">GB1</xsl:when>
            <xsl:when test="$oo_format='①, ②, ③, ...'">GB3</xsl:when>
            <xsl:when test="$oo_format='一, 二, 三, ...'">CHINESENUM3</xsl:when>
            <xsl:when test="$oo_format='壹, 贰, 叁, ...'">CHINESENUM2</xsl:when>
            <xsl:when test="$oo_format='甲, 乙, 丙, ...'">ZODIAC1</xsl:when>
            <xsl:when test="$oo_format='子, 丑, 寅, ...'">ZODIAC2</xsl:when>
            <xsl:otherwise>Arabic</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text:page-number">
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'page'"/></xsl:attribute>
            <xsl:attribute name="uof:locID">t0079</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            <xsl:choose>
                <xsl:when test="text:fixed='1'">
                    <xsl:attribute name="字:锁定">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:锁定">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="字:域代码">
            <xsl:attribute name="uof:locID">t0080</xsl:attribute>
            <字:段落 uof:locID="t0051" uof:attrList="标识符">
                <字:句 uof:locID="t0085">
                    <字:句属性 uof:locID="t0086" uof:attrList="式样引用"/>
                    <xsl:variable name="fmt">
                        <xsl:call-template name="oo数字格式域开关">
                            <xsl:with-param name="oo_format" select="@style:num-format"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <字:文本串>
                        <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="@style:num-format">
                                <xsl:value-of select="concat('PAGE \* ',$fmt)"/>
                            </xsl:when>
                            <xsl:otherwise>PAGE</xsl:otherwise>
                        </xsl:choose>
                    </字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串>
                <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                <xsl:value-of select="string(.)"/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text:page-count">
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'numpages'"/></xsl:attribute>
            <xsl:attribute name="uof:locID">t0079</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            <xsl:choose>
                <xsl:when test="text:fixed='1'or text:fixed='true'">
                    <xsl:attribute name="字:锁定">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:锁定">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="字:域代码">
            <xsl:attribute name="uof:locID">t0080</xsl:attribute>
            <字:段落 uof:locID="t0051" uof:attrList="标识符">
                <字:句 uof:locID="t0085">
                    <字:句属性 uof:locID="t0086" uof:attrList="式样引用"/>
                    <xsl:variable name="fmt">
                        <xsl:call-template name="oo数字格式域开关">
                            <xsl:with-param name="oo_format" select="@style:num-format"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <字:文本串>
                        <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="@style:num-format">
                                <xsl:value-of select="concat('NumPages \* ',$fmt,' \* Upper')"/>
                            </xsl:when>
                            <xsl:otherwise>NumPages</xsl:otherwise>
                        </xsl:choose>
                    </字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串>
                <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                <xsl:value-of select="string(.)"/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text:initial-creator">
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'author'"/></xsl:attribute>
            <xsl:attribute name="uof:locID">t0079</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            <xsl:choose>
                <xsl:when test="text:fixed='1'or text:fixed='true'">
                    <xsl:attribute name="字:锁定">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:锁定">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="字:域代码">
            <xsl:attribute name="uof:locID">t0080</xsl:attribute>
            <字:段落 uof:locID="t0051" uof:attrList="标识符">
                <字:句 uof:locID="t0085">
                    <字:句属性 uof:locID="t0086" uof:attrList="式样引用"/>
                    <字:文本串>
                        <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                        <!--xsl:value-of select="concat('AUTHOR \* ','Caps',' \* MERGEFORMAT')"/-->
                        <xsl:value-of select="'AUTHOR'"/>
                    </字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串>
                <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                <xsl:value-of select="string(.)"/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text:author-name">
        <xsl:param name="tStyle"/>
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'username'"/></xsl:attribute>
            <xsl:attribute name="uof:locID">t0079</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            <xsl:choose>
                <xsl:when test="text:fixed='1'or text:fixed='true'">
                    <xsl:attribute name="字:锁定">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:锁定">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="字:域代码">
            <xsl:attribute name="uof:locID">t0080</xsl:attribute>
            <字:段落 uof:locID="t0051" uof:attrList="标识符">
                <字:句 uof:locID="t0085">
                    <xsl:if test="$tStyle!=''">
                        <字:句属性 字:式样引用="{$tStyle}" uof:locID="t0086" uof:attrList="式样引用"/>
                    </xsl:if>
                    <字:文本串 uof:locID="t0109" uof:attrList="标识符">AUTHOR</字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串 uof:locID="t0109" uof:attrList="标识符">
                <xsl:value-of select="."/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text:author-initials">
        <xsl:param name="tStyle"/>
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'userinitials'"/></xsl:attribute>
            <xsl:attribute name="uof:locID">t0079</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            <xsl:choose>
                <xsl:when test="text:fixed='1'or text:fixed='true'">
                    <xsl:attribute name="字:锁定">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:锁定">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="字:域代码">
            <xsl:attribute name="uof:locID">t0080</xsl:attribute>
            <字:段落 uof:locID="t0051" uof:attrList="标识符">
                <字:句 uof:locID="t0085">
                    <xsl:if test="$tStyle!=''">
                        <字:句属性 字:式样引用="{$tStyle}" uof:locID="t0086" uof:attrList="式样引用"/>
                    </xsl:if>
                    <字:文本串 uof:locID="t0109" uof:attrList="标识符">AUTHOR</字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串 uof:locID="t0109" uof:attrList="标识符">
                <xsl:value-of select="."/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text:title">
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'title'"/></xsl:attribute>
            <xsl:attribute name="uof:locID">t0079</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            <xsl:choose>
                <xsl:when test="text:fixed='1'or text:fixed='true'">
                    <xsl:attribute name="字:锁定">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:锁定">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="字:域代码">
            <xsl:attribute name="uof:locID">t0080</xsl:attribute>
            <字:段落 uof:locID="t0051" uof:attrList="标识符">
                <字:句 uof:locID="t0085">
                    <字:句属性 uof:locID="t0086" uof:attrList="式样引用"/>
                    <xsl:variable name="titlename" select="/office:document/office:meta/dc:title"/>
                    <字:文本串 uof:locID="t0109" uof:attrList="标识符">
                        <xsl:value-of select="concat('TITLE',' \* Upper')"/>
                    </字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串 uof:locID="t0109" uof:attrList="标识符">
                <xsl:value-of select="."/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text:subject">
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'subject'"/></xsl:attribute>
            <xsl:attribute name="uof:locID">t0079</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            <xsl:choose>
                <xsl:when test="text:fixed='1'or text:fixed='true'">
                    <xsl:attribute name="字:锁定">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:锁定">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="字:域代码">
            <xsl:attribute name="uof:locID">t0080</xsl:attribute>
            <字:段落 uof:locID="t0051" uof:attrList="标识符">
                <字:句 uof:locID="t0085">
                    <字:句属性 uof:locID="t0086" uof:attrList="式样引用"/>
                    <字:文本串 uof:locID="t0109" uof:attrList="标识符">
                        <xsl:value-of select="concat('SUBJECT \* ','Caps',' \* MERGEFORMAT')"/>
                    </字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串 uof:locID="t0109" uof:attrList="标识符">
                <xsl:value-of select="."/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text:file-name">
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'filename'"/></xsl:attribute>
            <xsl:attribute name="uof:locID">t0079</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            <xsl:choose>
                <xsl:when test="text:fixed='1'or text:fixed='true'">
                    <xsl:attribute name="字:锁定">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:锁定">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="字:域代码">
            <xsl:attribute name="uof:locID">t0080</xsl:attribute>
            <字:段落 uof:locID="t0051" uof:attrList="标识符">
                <字:句 uof:locID="t0085">
                    <字:句属性 uof:locID="t0086" uof:attrList="式样引用"/>
                    <字:文本串 uof:locID="t0109" uof:attrList="标识符">
                        <!--xsl:value-of select="concat('FILENAME \* ','Caps',' \* MERGEFORMAT')"/-->
                        <xsl:value-of select="concat('FILENAME',' \p')"/>
                    </字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串 uof:locID="t0109" uof:attrList="标识符">
                <xsl:value-of select="."/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text:editing-duration">
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'edittime'"/></xsl:attribute>
            <xsl:attribute name="uof:locID">t0079</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            <xsl:choose>
                <xsl:when test="text:fixed='1'or text:fixed='true'">
                    <xsl:attribute name="字:锁定">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:锁定">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="字:域代码">
            <xsl:attribute name="uof:locID">t0080</xsl:attribute>
            <字:段落 uof:locID="t0051" uof:attrList="标识符">
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
                                    <xsl:if test="self::node( )[name(.)='number:am-pm']">am/pm</xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="quote">"</xsl:variable>
                    <字:文本串>
                        <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                        <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                        <xsl:value-of select="concat('EDITTIME \@ ',$quote,$timefmt,$quote,' \* MERGEFORMAT ')"/>
                    </字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串>
                <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                <xsl:value-of select="."/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:key name="path" match="//office:document/office:automatic-styles/style:style" use="@style:name"/>
    <xsl:template name="text:table-of-content">
        <xsl:element name="字:段落">
            <xsl:attribute name="uof:locID">t0051</xsl:attribute>
            <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
            <xsl:element name="字:段落属性">
                <xsl:attribute name="uof:locID">t0052</xsl:attribute>
                <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                <xsl:attribute name="字:式样引用"><xsl:value-of select="text:index-body/text:p/@text:style-name"/></xsl:attribute>
                <xsl:element name="字:制表位设置">
                    <xsl:attribute name="uof:locID">t0067</xsl:attribute>
                    <xsl:element name="字:制表位">
                        <xsl:attribute name="uof:locID">t0068</xsl:attribute>
                        <xsl:attribute name="uof:attrList">位置 类型 前导符 制表位字符</xsl:attribute>
                        <xsl:variable name="aa" select="text:index-body/text:p/@text:style-name"/>
                        <xsl:attribute name="字:位置"><xsl:value-of select="substring-before(key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:position,$ooUnit)"/></xsl:attribute>
                        <xsl:attribute name="字:类型"><xsl:value-of select="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:type"/></xsl:attribute>
                        <xsl:attribute name="字:制表位字符"><xsl:value-of select="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:leader-text"/></xsl:attribute>
                        <xsl:if test="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:leader-style">
                            <xsl:attribute name="字:前导符"><xsl:value-of select="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:leader-style"/></xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="字:是否行首标点压缩">
                    <xsl:attribute name="uof:locID">t0075</xsl:attribute>
                    <xsl:attribute name="uof:attrList">值</xsl:attribute>
                    <xsl:attribute name="字:值">true</xsl:attribute>
                </xsl:element>
                <xsl:element name="字:中文习惯首尾字符">
                    <xsl:attribute name="字:值">true</xsl:attribute>
                    <xsl:attribute name="uof:locID">t0076</xsl:attribute>
                    <xsl:attribute name="uof:attrList">值</xsl:attribute>
                </xsl:element>
            </xsl:element>
            <xsl:element name="字:域开始">
                <xsl:attribute name="字:类型"><xsl:value-of select="'REF'"/></xsl:attribute>
                <xsl:if test="@text:protected">
                    <xsl:attribute name="字:锁定"><xsl:value-of select="@text:protected"/></xsl:attribute>
                </xsl:if>
                <xsl:attribute name="uof:locID">t0079</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            </xsl:element>
            <xsl:element name="字:域代码">
                <xsl:attribute name="uof:locID">t0080</xsl:attribute>
                <字:段落 uof:locID="t0051" uof:attrList="标识符">
                    <字:句 uof:locID="t0085">
                        <字:文本串>
                            <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                            <xsl:value-of select="'TOC \o 1-10 \h \z'"/>
                        </字:文本串>
                    </字:句>
                </字:段落>
                <xsl:for-each select="text:index-body/text:index-title/text:p">
                    <xsl:element name="字:段落" uof:locID="t0051" uof:attrList="标识符">
                        <xsl:element name="字:段落属性">
                            <xsl:attribute name="uof:locID">t0052</xsl:attribute>
                            <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                            <xsl:attribute name="字:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="字:句">
                            <字:句属性 uof:locID="t0086" uof:attrList="式样引用">
                                <xsl:attribute name="字:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                            </字:句属性>
                            <xsl:element name="字:文本串">
                                <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                                <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                                <xsl:value-of select="self::node()"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
                <xsl:for-each select="text:index-body/text:p">
                    <xsl:element name="字:段落" uof:locID="t0051" uof:attrList="标识符">
                        <xsl:element name="字:段落属性">
                            <xsl:attribute name="uof:locID">t0052</xsl:attribute>
                            <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                            <xsl:attribute name="字:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                            <xsl:element name="字:制表位设置">
                                <xsl:attribute name="uof:locID">t0067</xsl:attribute>
                                <xsl:element name="字:制表位">
                                    <xsl:attribute name="uof:locID">t0068</xsl:attribute>
                                    <xsl:attribute name="uof:attrList">位置 类型 前导符</xsl:attribute>
                                    <xsl:variable name="aa" select="@text:style-name"/>
                                    <xsl:attribute name="字:位置"><xsl:value-of select="substring-before(key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:position,$ooUnit)"/></xsl:attribute>
                                    <xsl:attribute name="字:类型"><xsl:value-of select="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:type"/></xsl:attribute>
                                    <xsl:attribute name="字:制表位字符"><xsl:value-of select="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:leader-text"/></xsl:attribute>
                                    <xsl:if test="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:leader-style">
                                        <xsl:attribute name="字:前导符"><xsl:value-of select="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:leader-style"/></xsl:attribute>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="字:是否行首标点压缩">
                                <xsl:attribute name="uof:locID">t0075</xsl:attribute>
                                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                                <xsl:attribute name="字:值">true</xsl:attribute>
                            </xsl:element>
                            <xsl:element name="字:中文习惯首尾字符">
                                <xsl:attribute name="字:值">true</xsl:attribute>
                                <xsl:attribute name="uof:locID">t0076</xsl:attribute>
                                <xsl:attribute name="uof:attrList">值</xsl:attribute>
                            </xsl:element>
                        </xsl:element>
                        <xsl:if test="self::node()/text:a">
                            <字:句 uof:locID="t0085">
                                <xsl:variable name="num">
                                    <xsl:number from="/office:document/office:body/office:text" level="any" count="text:a"/>
                                </xsl:variable>
                                <xsl:element name="字:区域开始">
                                    <xsl:attribute name="字:标识符"><xsl:value-of select="concat('hlnk',$num + 1)"/></xsl:attribute>
                                    <xsl:attribute name="字:名称">Hyperlink</xsl:attribute>
                                    <xsl:attribute name="字:类型">hyperlink</xsl:attribute>
                                    <xsl:attribute name="uof:locID">t0121</xsl:attribute>
                                    <xsl:attribute name="uof:attrList">标识符 名称 类型</xsl:attribute>
                                </xsl:element>
                                <xsl:for-each select="text:a/node()">
                                    <xsl:choose>
                                        <xsl:when test="name(.)='text:tab-stop' or name(.)='text:tab'">
                                            <xsl:element name="字:制表符" uof:locID="t0123"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:element name="字:文本串">
                                                <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                                                <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                                                <xsl:value-of select="."/>
                                            </xsl:element>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <xsl:element name="字:区域结束">
                                    <xsl:attribute name="字:标识符引用"><xsl:value-of select="concat('hlnk',$num + 1)"/></xsl:attribute>
                                    <xsl:attribute name="uof:locID">t0122</xsl:attribute>
                                    <xsl:attribute name="uof:attrList">标识符引用</xsl:attribute>
                                </xsl:element>
                                <xsl:variable name="stt">
                                    <xsl:value-of select="./text:a"/>
                                </xsl:variable>
                                <xsl:variable name="end">
                                    <xsl:value-of select="."/>
                                </xsl:variable>
                                <xsl:variable name="bijiao">
                                    <xsl:value-of select="substring-after($end,$stt)"/>
                                </xsl:variable>
                                <xsl:if test="not($bijiao='')">
                                    <xsl:element name="字:文本串">
                                        <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                                        <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                                        <xsl:value-of select="$bijiao"/>
                                    </xsl:element>
                                </xsl:if>
                            </字:句>
                        </xsl:if>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="字:域结束">
                <xsl:attribute name="uof:locID">t0081</xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="text:alphabetical-index">
        <xsl:element name="字:段落">
            <xsl:attribute name="uof:locID">t0051</xsl:attribute>
            <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
            <xsl:element name="字:段落属性">
                <xsl:attribute name="uof:locID">t0052</xsl:attribute>
                <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                <xsl:attribute name="字:式样引用"><xsl:value-of select="text:index-body/text:p/@text:style-name"/></xsl:attribute>
                <xsl:element name="字:制表位设置">
                    <xsl:attribute name="uof:locID">t0067</xsl:attribute>
                    <xsl:element name="字:制表位">
                        <xsl:attribute name="uof:locID">t0068</xsl:attribute>
                        <xsl:attribute name="uof:attrList">位置 类型 前导符 制表位字符</xsl:attribute>
                        <xsl:variable name="aa" select="text:index-body/text:p/@text:style-name"/>
                        <xsl:attribute name="字:位置"><xsl:value-of select="substring-before(key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:position,$ooUnit)"/></xsl:attribute>
                        <xsl:attribute name="字:类型"><xsl:value-of select="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:type"/></xsl:attribute>
                        <xsl:attribute name="字:制表位字符"><xsl:value-of select="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:leader-text"/></xsl:attribute>
                        <xsl:if test="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:leader-style">
                            <xsl:attribute name="字:前导符"><xsl:value-of select="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:leader-style"/></xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="字:域开始">
                <xsl:attribute name="字:类型"><xsl:value-of select="'INDEX'"/></xsl:attribute>
                <xsl:if test="@text:protected">
                    <xsl:attribute name="字:锁定"><xsl:value-of select="@text:protected"/></xsl:attribute>
                </xsl:if>
                <xsl:attribute name="uof:locID">t0079</xsl:attribute>
                <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            </xsl:element>
            <xsl:element name="字:域代码">
                <xsl:attribute name="uof:locID">t0080</xsl:attribute>
                <字:段落 uof:locID="t0051" uof:attrList="标识符">
                    <字:句 uof:locID="t0085">
                        <字:文本串>
                            <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                            <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                            <xsl:value-of select="'TOC \o 1-10 \h \z'"/>
                        </字:文本串>
                    </字:句>
                </字:段落>
                <xsl:for-each select="text:index-body/text:index-title/text:p">
                    <xsl:element name="字:段落" uof:locID="t0051" uof:attrList="标识符">
                        <xsl:element name="字:段落属性">
                            <xsl:attribute name="uof:locID">t0052</xsl:attribute>
                            <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                            <xsl:attribute name="字:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="字:句">
                            <字:句属性 uof:locID="t0086" uof:attrList="式样引用">
                                <xsl:attribute name="字:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                            </字:句属性>
                            <xsl:element name="字:文本串">
                                <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                                <xsl:value-of select="self::node()"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
                <xsl:for-each select="text:index-body/text:p">
                    <xsl:element name="字:段落" uof:locID="t0051" uof:attrList="标识符">
                        <xsl:element name="字:段落属性">
                            <xsl:attribute name="uof:locID">t0052</xsl:attribute>
                            <xsl:attribute name="uof:attrList">式样引用</xsl:attribute>
                            <xsl:attribute name="字:式样引用"><xsl:value-of select="@text:style-name"/></xsl:attribute>
                            <xsl:element name="字:制表位设置">
                                <xsl:attribute name="uof:locID">t0067</xsl:attribute>
                                <xsl:element name="字:制表位">
                                    <xsl:attribute name="uof:locID">t0068</xsl:attribute>
                                    <xsl:attribute name="uof:attrList">位置 类型 前导符 制表位字符</xsl:attribute>
                                    <xsl:variable name="aa" select="@text:style-name"/>
                                    <xsl:attribute name="字:位置"><xsl:value-of select="substring-before(key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:position,$ooUnit)"/></xsl:attribute>
                                    <xsl:attribute name="字:类型"><xsl:value-of select="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:type"/></xsl:attribute>
                                    <xsl:attribute name="字:制表位字符"><xsl:value-of select="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:leader-text"/></xsl:attribute>
                                    <xsl:if test="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:leader-style">
                                        <xsl:attribute name="字:前导符"><xsl:value-of select="key('path',$aa)/style:paragraph-properties/style:tab-stops/style:tab-stop/@style:leader-style"/></xsl:attribute>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                        <xsl:for-each select="node()">
                            <字:句 uof:locID="t0085">
                                <xsl:choose>
                                    <xsl:when test="name(.)='text:tab-stop' or name(.)='text:tab'">
                                        <xsl:element name="字:制表符" uof:locID="t0123"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="字:文本串">
                                            <xsl:attribute name="uof:locID">t0109</xsl:attribute>
                                            <xsl:attribute name="uof:attrList">标识符</xsl:attribute>
                                            <xsl:value-of select="."/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </字:句>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="字:域结束">
                <xsl:attribute name="uof:locID">t0081</xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="oo数字格式">
        <xsl:param name="oo_format"/>
        <xsl:choose>
            <xsl:when test="$oo_format='1'">decimal</xsl:when>
            <xsl:when test="$oo_format='I'">upper-roman</xsl:when>
            <xsl:when test="$oo_format='i'">lower-roman</xsl:when>
            <xsl:when test="$oo_format='A'">upper-letter</xsl:when>
            <xsl:when test="$oo_format='a'">lower-letter</xsl:when>
            <xsl:when test="$oo_format='１, ２, ３, ...'">decimal-full-width</xsl:when>
            <xsl:when test="$oo_format='①, ②, ③, ...'">decimal-enclosed-circle</xsl:when>
            <xsl:when test="$oo_format='一, 二, 三, ...'">chinese-counting</xsl:when>
            <xsl:when test="$oo_format='壹, 贰, 叁, ...'">chinese-legal-simplified</xsl:when>
            <xsl:when test="$oo_format='甲, 乙, 丙, ...'">ideograph-traditional</xsl:when>
            <xsl:when test="$oo_format='子, 丑, 寅, ...'">ideograph-zodiac</xsl:when>
            <xsl:otherwise>decimal</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="图:填充">
        <xsl:param name="style-name"/>
        <xsl:choose>
            <xsl:when test="style:background-image/office:binary-data">
                <图:图片 uof:locID="g0035" uof:attrList="位置 图形引用 类型 名称">
                    <xsl:attribute name="图:位置"><xsl:choose><xsl:when test="not(style:background-image/@style:repeat)">tile</xsl:when><xsl:otherwise><xsl:choose><xsl:when test="style:background-image/@style:repeat = 'stretch'">stretch</xsl:when><xsl:when test="style:background-image/@style:repeat = 'repeat'">tile</xsl:when><xsl:when test="style:background-image/@style:repeat = 'no-repeat'">center</xsl:when></xsl:choose></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="图:图形引用"><xsl:value-of select="concat('background-image_',count(preceding::style:background-image))"/></xsl:attribute>
                    <xsl:attribute name="图:类型">png</xsl:attribute>
                    <xsl:attribute name="图:名称">background-image</xsl:attribute>
                </图:图片>
            </xsl:when>
            <xsl:when test="@fo:background-color">
                <图:颜色 uof:locID="g0034">
                    <xsl:choose>
                        <xsl:when test="@fo:background-color='transparent' ">auto</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@fo:background-color"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </图:颜色>
            </xsl:when>
            <xsl:when test="@draw:fill='gradient'">
            </xsl:when>
            <xsl:when test="@draw:fill='hatch'">
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="字:缩进类型">
        <xsl:if test="@text:space-before or @fo:margin-left">
            <字:左 uof:locID="t0182">
                <字:绝对 uof:locID="t0185" uof:attrList="值">
                    <xsl:if test="@text:space-before">
                        <xsl:attribute name="字:值"><xsl:value-of select="substring-before(@text:space-before,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@fo:margin-left">
                        <xsl:attribute name="字:值"><xsl:value-of select="substring-before(@fo:margin-left,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                </字:绝对>
            </字:左>
        </xsl:if>
        <xsl:if test="@text:min-label-width or @fo:margin-right">
            <字:右 uof:locID="t0183">
                <字:绝对 uof:locID="t0187" uof:attrList="值">
                    <xsl:if test="@text:min-label-width">
                        <xsl:attribute name="字:值"><xsl:value-of select="substring-before(@text:min-label-width,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@fo:margin-right">
                        <xsl:attribute name="字:值"><xsl:value-of select="substring-before(@fo:margin-right,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                </字:绝对>
            </字:右>
        </xsl:if>
        <xsl:if test="@text:min-label-distance or @fo:text-indent">
            <字:首行 uof:locID="t0184">
                <字:绝对 uof:locID="t0189" uof:attrList="值">
                    <xsl:if test="@text:min-label-distance">
                        <xsl:attribute name="字:值"><xsl:value-of select="substring-before(@text:min-label-distance,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@fo:text-indent">
                        <xsl:attribute name="字:值"><xsl:value-of select="substring-before(@fo:text-indent,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                </字:绝对>
            </字:首行>
        </xsl:if>
    </xsl:template>
    <xsl:template name="graphsize">
        <xsl:param name="width"/>
        <xsl:param name="Unitofsize"/>
        <xsl:if test="$Unitofsize='pt'">
            <xsl:choose>
                <xsl:when test="(not($width&gt;1.42) and 0&lt;$width)">1</xsl:when>
                <xsl:when test="(not($width&gt;2.84) and 1.42&lt;$width)">2</xsl:when>
                <xsl:when test="(not($width&gt;4.26) and 2.84&lt;$width)">3</xsl:when>
                <xsl:when test="(not($width&gt;5.68) and 4.26&lt;$width)">4</xsl:when>
                <xsl:when test="(not($width&gt;7.10) and 5.68&lt;$width)">5</xsl:when>
                <xsl:when test="(not($width&gt;8.52) and 7.10&lt;$width)">6</xsl:when>
                <xsl:when test="(not($width&gt;9.94) and 8.52&lt;$width)">7</xsl:when>
                <xsl:when test="(not($width&gt;11.36) and 9.94&lt;$width)">8</xsl:when>
                <xsl:otherwise>9</xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$uofUnit='in'">
            <xsl:choose>
                <xsl:when test="(not($width&gt;0.02) and 0&lt;$width)">1</xsl:when>
                <xsl:when test="(not($width&gt;0.04) and 0.02&lt;$width)">2</xsl:when>
                <xsl:when test="(not($width&gt;0.06) and 0.04&lt;$width)">3</xsl:when>
                <xsl:when test="(not($width&gt;0.08) and 0.06&lt;$width)">4</xsl:when>
                <xsl:when test="(not($width&gt;0.10) and 0.08&lt;$width)">5</xsl:when>
                <xsl:when test="(not($width&gt;0.12) and 0.10&lt;$width)">6</xsl:when>
                <xsl:when test="(not($width&gt;0.14) and 0.12&lt;$width)">7</xsl:when>
                <xsl:when test="(not($width&gt;0.16) and 0.14&lt;$width)">8</xsl:when>
                <xsl:otherwise>9</xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$uofUnit='mm'">
            <xsl:choose>
                <xsl:when test="(not($width&gt;0.5) and 0&lt;$width) or $width=0.5">1</xsl:when>
                <xsl:when test="(not($width&gt;1.0) and 0.5&lt;$width) or $width=1.0">2</xsl:when>
                <xsl:when test="(not($width&gt;1.5) and 0.10&lt;$width) or $width=1.5">3</xsl:when>
                <xsl:when test="(not($width&gt;2.0) and 1.5&lt;$width) or $width=2.0">4</xsl:when>
                <xsl:when test="(not($width&gt;2.5) and 2.0&lt;$width) or $width=2.5">5</xsl:when>
                <xsl:when test="(not($width&gt;3.0) and 2.5&lt;$width) or $width=3.0">6</xsl:when>
                <xsl:when test="(not($width&gt;3.5) and 3.0&lt;$width) or $width=3.5">7</xsl:when>
                <xsl:when test="(not($width&gt;4.0) and 3.5&lt;$width) or $width=4.0">8</xsl:when>
                <xsl:otherwise>9</xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$uofUnit='cm'">
            <xsl:choose>
                <xsl:when test="(not($width&gt;0.05) and 0&lt;$width) or $width=0.05">1</xsl:when>
                <xsl:when test="(not($width&gt;0.10) and 0.05&lt;$width) or $width=0.10">2</xsl:when>
                <xsl:when test="(not($width&gt;0.15) and 0.10&lt;$width) or $width=0.15">3</xsl:when>
                <xsl:when test="(not($width&gt;0.20) and 0.15&lt;$width) or $width=0.20">4</xsl:when>
                <xsl:when test="(not($width&gt;0.25) and 0.20&lt;$width) or $width=0.25">5</xsl:when>
                <xsl:when test="(not($width&gt;0.30) and 0.25&lt;$width) or $width=0.30">6</xsl:when>
                <xsl:when test="(not($width&gt;0.35) and 0.30&lt;$width) or $width=0.35">7</xsl:when>
                <xsl:when test="(not($width&gt;0.40) and 0.35&lt;$width) or $width=0.40">8</xsl:when>
                <xsl:otherwise>9</xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="text:character-count">
        <xsl:element name="字:域开始">
            <xsl:attribute name="字:类型"><xsl:value-of select="'numchars'"/></xsl:attribute>
            <xsl:attribute name="uof:locID">t0079</xsl:attribute>
            <xsl:attribute name="uof:attrList">类型 锁定</xsl:attribute>
            <xsl:choose>
                <xsl:when test="text:fixed='1'or text:fixed='true'">
                    <xsl:attribute name="字:锁定">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="字:锁定">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="字:域代码">
            <xsl:attribute name="uof:locID">t0080</xsl:attribute>
            <字:段落 uof:locID="t0051" uof:attrList="标识符">
                <字:句 uof:locID="t0085">
                    <字:句属性 uof:locID="t0086" uof:attrList="式样引用"/>
                    <xsl:variable name="quote" select="'&quot;'"/>
                    <xsl:variable name="fmt">
                        <xsl:call-template name="oo数字格式域开关">
                            <xsl:with-param name="oo_format" select="@style:num-format"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <字:文本串 uof:locID="t0109" uof:attrList="标识符">
                        <xsl:value-of select="concat('NUMCHARS \* ',$fmt,' \# ',$quote,0,$quote)"/>
                    </字:文本串>
                </字:句>
            </字:段落>
        </xsl:element>
        <字:句 uof:locID="t0085">
            <字:文本串 uof:locID="t0109" uof:attrList="标识符">
                <xsl:value-of select="."/>
            </字:文本串>
        </字:句>
        <xsl:element name="字:域结束">
            <xsl:attribute name="uof:locID">t0081</xsl:attribute>
        </xsl:element>
    </xsl:template>
    <!-- measure_conversion.xsl Begin-->
    <!--xsl:param name="dpi" select="111"/>
    <xsl:param name="centimeter-in-mm" select="10"/>
    <xsl:param name="inch-in-mm" select="25.4"/>
    <xsl:param name="didot-point-in-mm" select="0.376065"/>
    <xsl:param name="pica-in-mm" select="4.2333333"/>
    <xsl:param name="point-in-mm" select="0.3527778"/>
    <xsl:param name="twip-in-mm" select="0.017636684"/>
    <xsl:param name="pixel-in-mm" select="$inch-in-mm div $dpi"/-->
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
    <!--xsl:template name="convert2cm">
        <xsl:param name="value"/>
        <xsl:param name="rounding-factor" select="10000"/>
        <xsl:choose>
            <xsl:when test="contains($value, 'mm')">
                <xsl:value-of select="round($rounding-factor * number(substring-before($value, 'mm') div $centimeter-in-mm)) div $rounding-factor"/>
            </xsl:when>
            <xsl:when test="contains($value, $uofUnit)">
                <xsl:value-of select="substring-before($value, $uofUnit)"/>
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
    </xsl:template-->
</xsl:stylesheet>
