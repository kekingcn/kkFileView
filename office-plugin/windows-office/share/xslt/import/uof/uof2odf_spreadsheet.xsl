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
        <!--chengxz0804 OK-->
        <!--office:document xmlns:office="http://openoffice.org/2000/office" xmlns:style="http://openoffice.org/2000/style" xmlns:text="http://openoffice.org/2000/text" xmlns:table="http://openoffice.org/2000/table" xmlns:draw="http://openoffice.org/2000/drawing" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="http://openoffice.org/2000/meta" xmlns:number="http://openoffice.org/2000/datastyle" xmlns:svg="http://www.w3.org/2000/svg" xmlns:chart="http://openoffice.org/2000/chart" xmlns:dr3d="http://openoffice.org/2000/dr3d" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="http://openoffice.org/2000/form" xmlns:script="http://openoffice.org/2000/script" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" office:version="1.0" office:class="spreadsheet"-->
        <office:document xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0" xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0" office:version="1.0">
            <xsl:apply-templates select="uof:元数据"/>
            <office:settings>
                <xsl:call-template name="工作表属性"/>
            </office:settings>
            <xsl:apply-templates select="uof:式样集"/>
            <!--xsl:apply-templates select="表:公用处理规则"/-->
            <xsl:apply-templates select="uof:电子表格"/>
        </office:document>
    </xsl:template>
    <!--Redoffice comment lil from chenjh SC0013 06.02.15-->
    <!--增加内容-->
    <xsl:variable name="uofUnit">
        <xsl:variable name="uu">
            <xsl:value-of select="/uof:UOF/uof:电子表格/表:公用处理规则/表:度量单位"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$uu='cm'">cm</xsl:when>
            <xsl:when test="$uu='mm'">mm</xsl:when>
            <xsl:when test="$uu='pt'">pt</xsl:when>
            <xsl:when test="$uu='inch'">inch</xsl:when>
            <xsl:otherwise>cm</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="other-to-cm-conversion-factor">
        <xsl:choose>
            <xsl:when test="$uofUnit='cm'">1</xsl:when>
            <xsl:when test="$uofUnit='mm'">0.1</xsl:when>
            <xsl:when test="$uofUnit='pt'">0.03527</xsl:when>
            <xsl:when test="$uofUnit='inch'">2.54</xsl:when>
            <xsl:when test="$uofUnit='pica'">0.4233</xsl:when>
            <xsl:otherwise>0.03527</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!--Redoffice comment liliang end 06.02.15-->
    <xsl:template name="set-calculation">
        <xsl:element name="table:calculation-settings">
            <xsl:if test="表:公用处理规则/表:度量单位">
                <xsl:variable name="uofUnit">
                    <xsl:variable name="uu">
                        <xsl:value-of select="表:公用处理规则/表:度量单位"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$uu='cm'">cm</xsl:when>
                        <xsl:when test="$uu='mm'">mm</xsl:when>
                        <xsl:when test="$uu='pt'">pt</xsl:when>
                        <xsl:when test="$uu='inch'">inch</xsl:when>
                        <xsl:otherwise>cm</xsl:otherwise>
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
            </xsl:if>
            <xsl:if test="表:公用处理规则/表:精确度以显示值为准">
                <xsl:attribute name="table:precision-as-shown">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="表:公用处理规则/表:日期系统-1904/@表:值='true'">
                <table:null-date table:date-value="1904-01-01"/>
            </xsl:if>
            <xsl:if test="表:公用处理规则/表:计算设置">
                <xsl:element name="table:iteration">
                    <xsl:attribute name="table:status">enable</xsl:attribute>
                    <xsl:attribute name="table:steps"><xsl:value-of select="表:公用处理规则/表:计算设置/@表:迭代次数"/></xsl:attribute>
                    <xsl:attribute name="table:maximum-difference"><xsl:value-of select="表:公用处理规则/表:计算设置/@表:偏差值"/></xsl:attribute>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template match="uof:字体集">
        <xsl:if test="not(uof:字体声明[@uof:名称='StarSymbol'])">
            <style:font-face style:name="StarSymbol" fo:font-family="StarSymbol" style:font-charset="x-symbol"/>
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
    <xsl:template match="uof:电子表格">
        <office:body>
            <office:spreadsheet>
                <xsl:call-template name="trackchange"/>
                <xsl:call-template name="set-calculation"/>
                <xsl:if test="表:公用处理规则/表:数据有效性集">
                    <xsl:element name="table:content-validations">
                        <xsl:call-template name="create-content-validations">
                            <xsl:with-param name="validation-set" select="表:公用处理规则/表:数据有效性集/表:数据有效性"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
                <xsl:apply-templates select="表:主体/表:工作表"/>
                <!--MSexcel 中的names暂时没有对应的-->
                <xsl:element name="table:database-ranges">
                    <xsl:for-each select="表:主体/表:工作表">
                        <xsl:if test="./表:筛选">
                            <xsl:variable name="filter" select="./表:筛选"/>
                            <xsl:variable name="column-and-row" select="substring-before(substring-after($filter/表:范围/text(),'.'),':')"/>
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
                            <xsl:element name="table:database-range">
                                <xsl:attribute name="table:name"><xsl:value-of select="uof:电子表格/表:主体/表:工作表/@表:名称"/></xsl:attribute>
                                <xsl:attribute name="table:target-range-address"><xsl:call-template name="translate-expression2"><xsl:with-param name="expression2" select="translate($filter/表:范围/text(),'$','')"/></xsl:call-template></xsl:attribute>
                                <xsl:if test="$filter/@表:类型='auto'">
                                    <xsl:attribute name="table:display-filter-buttons">true</xsl:attribute>
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="$filter/表:条件区域">
                                        <xsl:element name="table:filter">
                                            <xsl:attribute name="table:condition-source-range-address"><xsl:call-template name="translate-expression2"><xsl:with-param name="expression2" select="translate($filter/表:条件区域/text(),'$','')"/></xsl:call-template></xsl:attribute>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="table:filter">
                                            <xsl:element name="table:filter-and">
                                                <xsl:call-template name="auto-filter-condition">
                                                    <xsl:with-param name="condition-set" select="$filter/表:条件"/>
                                                    <xsl:with-param name="zone-left-column-num" select="$zone-left-column-num"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </office:spreadsheet>
        </office:body>
    </xsl:template>
    <xsl:template name="trackchange">
        <xsl:for-each select="表:主体/表:工作表/表:工作表内容//字:修订开始">
            <xsl:variable name="num">
                <xsl:number level="any" from="表:主体/表:工作表/表:工作表内容//*" count="字:修订开始"/>
            </xsl:variable>
            <table:tracked-changes>
                <table:cell-content-change>
                    <xsl:attribute name="table:id"><xsl:value-of select="concat('ct',$num)"/></xsl:attribute>
                    <table:cell-address>
                        <xsl:attribute name="table:column"><xsl:value-of select="substring-after(@字:标识符,'-')"/></xsl:attribute>
                        <xsl:attribute name="table:row"><xsl:value-of select="substring-before(@字:标识符,'-')"/></xsl:attribute>
                        <xsl:attribute name="table:table">0</xsl:attribute>
                    </table:cell-address>
                    <office:change-info>
                        <dc:creator>
                            <xsl:choose>
                                <xsl:when test="starts-with(@字:修订信息引用,'+')"/>
                                <xsl:otherwise>
                                    <xsl:value-of select="substring-before(@字:修订信息引用,'+')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </dc:creator>
                        <!--xsl:value-of select="/uof:UOF/uof:元数据/uof:作者"/-->
                        <!--xsl:value-of select="/uof:UOF/uof:元数据/uof:创建日期"/-->
                        <dc:date>
                            <xsl:value-of select="substring-before(substring-after(@字:修订信息引用,'+'),'%')"/>
                        </dc:date>
                    </office:change-info>
                    <table:previous>
                        <table:change-track-table-cell>
                            <text:p>
                                <xsl:value-of select="substring-after(@字:修订信息引用,'%')"/>
                            </text:p>
                        </table:change-track-table-cell>
                    </table:previous>
                </table:cell-content-change>
            </table:tracked-changes>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="uof:式样集">
        <xsl:element name="office:font-face-decls">
            <style:font-face style:name="宋体" svg:font-family="宋体" style:font-family-generic="swiss"/>
            <xsl:apply-templates select="uof:字体集"/>
        </xsl:element>
        <xsl:call-template name="单元格式样"/>
    </xsl:template>
    <xsl:key match="/uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/uof:锚点 | /uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/表:行/表:单元格/uof:锚点" name="rel_graphic_name" use="@uof:图形引用"/>
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
        <xsl:choose>
            <xsl:when test="图:预定义图形/图:属性/图:填充/图:渐变">
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
                    <xsl:attribute name="style:family">graphic</xsl:attribute>
                    <xsl:element name="style:graphic-properties">
                        <xsl:call-template name="process-graphics">
                            <xsl:with-param name="draw-name" select="$draw-name"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="style:paragraph-properties">
                        <xsl:if test="图:文本内容/@图:文字排列方向">
                            <xsl:choose>
                                <xsl:when test="图:文本内容/@图:文字排列方向='vert-l2r'">
                                    <xsl:attribute name="style:writing-mode">tb-lr</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="图:文本内容/@图:文字排列方向='vert-r2l'">
                                    <xsl:attribute name="style:writing-mode">tb-rl</xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
                    <xsl:attribute name="style:family">graphic</xsl:attribute>
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
                    <xsl:element name="style:paragraph-properties">
                        <xsl:if test="图:文本内容/@图:文字排列方向">
                            <xsl:choose>
                                <xsl:when test="图:文本内容/@图:文字排列方向='vert-l2r'">
                                    <xsl:attribute name="style:writing-mode">tb-lr</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="图:文本内容/@图:文字排列方向='vert-r2l'">
                                    <xsl:attribute name="style:writing-mode">tb-rl</xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:element>
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
                <xsl:if test="not(图:预定义图形/图:属性/图:填充/图:图片/@图:位置='tile')">
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
            <xsl:variable name="type" select="图:预定义图形/图:属性/图:线型"/>
            <xsl:attribute name="draw:stroke"><xsl:choose><xsl:when test="$type='none'">none</xsl:when><xsl:when test="$type='single'">solid</xsl:when><xsl:otherwise>dash</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="draw:stroke-dash"><xsl:choose><xsl:when test="$type='dash'">Ultrafine_20_Dashed</xsl:when><xsl:when test="$type='dot-dash'">Ultrafine_20_2_20_Dots_20_3_20_Dashes</xsl:when><xsl:when test="$type='dashed-heavy'">Fine_20_Dashed</xsl:when><xsl:when test="$type='dotted' ">Fine_20_Dotted</xsl:when><xsl:when test="$type='dash-long-heavy'">Line_20_with_20_Fine_20_Dots</xsl:when><xsl:when test="$type='dash-long'">Fine_20_Dashed_20__28_var_29_</xsl:when><xsl:when test="$type='dash-dot-dot'">_33__20_Dashes_20_3_20_Dots_20__28_var_29_</xsl:when><xsl:when test="$type='dotted-heavy'">Ultrafine_20_Dotted_20__28_var_29_</xsl:when><xsl:when test="$type='thick'">Line_20_Style_20_9</xsl:when><xsl:when test="$type='dot-dot-dash'">_32__20_Dots_20_1_20_Dash</xsl:when><xsl:when test="$type='dash-dot-dot-heavy'">Dashed_20__28_var_29_</xsl:when><xsl:when test="$type='dash-dot-heavy'">Dash_20_10</xsl:when></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:线粗细">
            <xsl:attribute name="svg:stroke-width"><xsl:value-of select="concat(图:预定义图形/图:属性/图:线粗细,$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:前端箭头">
            <xsl:attribute name="draw:marker-start"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='normal'">Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='open'">Line Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='stealth'">Arrow concave</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='oval'">Circle</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='diamond'">Square 45</xsl:when></xsl:choose></xsl:attribute>
            <xsl:if test="图:预定义图形/图:属性/图:前端箭头/图:大小">
                <xsl:attribute name="draw:marker-start-width"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '1'"><xsl:value-of select="concat('0.05',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '2'"><xsl:value-of select="concat('0.10',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '3'"><xsl:value-of select="concat('0.15',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '4'"><xsl:value-of select="concat('0.20',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '5'"><xsl:value-of select="concat('0.25',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '6'"><xsl:value-of select="concat('0.30',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '7'"><xsl:value-of select="concat('0.35',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:大小 = '8'"><xsl:value-of select="concat('0.40',$uofUnit)"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('0.45',$uofUnit)"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:后端箭头">
            <xsl:attribute name="draw:marker-end"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='normal'">Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='open'">Line Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='stealth'">Arrow concave</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='oval'">Circle</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='diamond'">Square 45</xsl:when></xsl:choose></xsl:attribute>
            <xsl:if test="图:预定义图形/图:属性/图:后端箭头/图:大小">
                <xsl:attribute name="draw:marker-end-width"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '1'"><xsl:value-of select="concat('0.05',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '2'"><xsl:value-of select="concat('0.10',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '3'"><xsl:value-of select="concat('0.15',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '4'"><xsl:value-of select="concat('0.20',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '5'"><xsl:value-of select="concat('0.25',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '6'"><xsl:value-of select="concat('0.30',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '7'"><xsl:value-of select="concat('0.35',$uofUnit)"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:大小 = '8'"><xsl:value-of select="concat('0.40',$uofUnit)"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('0.45',$uofUnit)"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:透明度">
            <xsl:attribute name="draw:opacity"><xsl:value-of select="concat(图:预定义图形/图:属性/图:透明度,'%')"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="图:文本内容">
            <xsl:if test="图:文本内容/@图:上边距">
                <xsl:attribute name="fo:padding-top"><xsl:value-of select="concat(图:文本内容/@图:上边距,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="fo:padding-bottom"><xsl:value-of select="concat(图:文本内容/@图:下边距,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="fo:padding-left"><xsl:value-of select="concat(图:文本内容/@图:左边距,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="fo:padding-right"><xsl:value-of select="concat(图:文本内容/@图:右边距,$uofUnit)"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="图:文本内容/@图:文字排列方向">
                <xsl:choose>
                    <xsl:when test="图:文本内容/@图:文字排列方向='vert-l2r'">
                        <xsl:attribute name="style:writing-mode">tb-lr</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="图:文本内容/@图:文字排列方向='vert-r2l'">
                        <xsl:attribute name="style:writing-mode">tb-rl</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="图:文本内容/@图:文字排列方向='hori-r2l'">
                        <xsl:attribute name="draw:textarea-horizontal-align">right</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="图:文本内容/@图:文字排列方向='hori-12r'">
                        <xsl:attribute name="draw:textarea-horizontal-align">left</xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="图:文本内容/@图:水平对齐">
                <xsl:attribute name="draw:textarea-horizontal-align"><xsl:value-of select="图:文本内容/@图:水平对齐"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="图:文本内容/@图:垂直对齐">
                <xsl:attribute name="draw:textarea-vertical-align"><xsl:value-of select="图:文本内容/@图:垂直对齐"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="图:文本内容/@图:自动换行">
                <xsl:attribute name="fo:wrap-option">no-wrap</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="draw:auto-grow-width"><xsl:choose><xsl:when test="图:文本内容/@图:大小适应文字">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="draw:auto-grow-height"><xsl:choose><xsl:when test="图:文本内容/@图:大小适应文字">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
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
                <xsl:attribute name="draw:name"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='normal'">Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='open'">Line Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='stealth'">Arrow concave</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='oval'">Circle</xsl:when><xsl:when test="图:预定义图形/图:属性/图:前端箭头/图:式样='diamond'">Square 45</xsl:when></xsl:choose></xsl:attribute>
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
                <xsl:attribute name="draw:name"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='normal'">Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='open'">Line Arrow</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='stealth'">Arrow concave</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='oval'">Circle</xsl:when><xsl:when test="图:预定义图形/图:属性/图:后端箭头/图:式样='diamond'">Square 45</xsl:when></xsl:choose></xsl:attribute>
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
            <draw:stroke-dash draw:name="Ultrafine_20_Dashed" draw:display-name="Ultrafine Dashed" draw:style="rect" draw:dots1="1" draw:dots1-length="0.051cm" draw:dots2="1" draw:dots2-length="0.051cm" draw:distance="0.051cm"/>
            <draw:stroke-dash draw:name="Fine_20_Dashed" draw:display-name="Fine Dashed" draw:style="rect" draw:dots1="1" draw:dots1-length="0.508cm" draw:dots2="1" draw:dots2-length="0.508cm" draw:distance="0.508cm"/>
            <draw:stroke-dash draw:name="Ultrafine_20_2_20_Dots_20_3_20_Dashes" draw:display-name="Ultrafine 2 Dots 3 Dashes" draw:style="rect" draw:dots1="2" draw:dots1-length="0.051cm" draw:dots2="3" draw:dots2-length="0.254cm" draw:distance="0.127cm"/>
            <draw:stroke-dash draw:name="Fine_20_Dashed_20__28_var_29_" draw:display-name="Fine Dashed (var)" draw:style="rect" draw:dots1="1" draw:dots1-length="197%" draw:distance="197%"/>
            <draw:stroke-dash draw:name="Fine_20_Dotted" draw:display-name="Fine Dotted" draw:style="rect" draw:dots1="1" draw:distance="0.457cm"/>
            <draw:stroke-dash draw:name="Fine_20_Dashed_20__28_var_29_" draw:display-name="Fine Dashed (var)" draw:style="rect" draw:dots1="1" draw:dots1-length="197%" draw:distance="197%"/>
            <draw:stroke-dash draw:name="Fine_20_Dotted" draw:display-name="Fine Dotted" draw:style="rect" draw:dots1="1" draw:distance="0.457cm"/>
            <draw:stroke-dash draw:name="Line_20_with_20_Fine_20_Dots" draw:display-name="Line with Fine Dots" draw:style="rect" draw:dots1="1" draw:dots1-length="2.007cm" draw:dots2="10" draw:distance="0.152cm"/>
            <draw:stroke-dash draw:name="Line_20_Style_20_9" draw:display-name="Line Style 9" draw:style="rect" draw:dots1="1" draw:dots1-length="197%" draw:distance="120%"/>
            <draw:stroke-dash draw:name="_33__20_Dashes_20_3_20_Dots_20__28_var_29_" draw:display-name="3 Dashes 3 Dots (var)" draw:style="rect" draw:dots1="3" draw:dots1-length="197%" draw:dots2="3" draw:distance="100%"/>
            <draw:stroke-dash draw:name="_32__20_Dots_20_1_20_Dash" draw:display-name="2 Dots 1 Dash" draw:style="rect" draw:dots1="2" draw:dots2="1" draw:dots2-length="0.203cm" draw:distance="0.203cm"/>
            <draw:stroke-dash draw:name="Ultrafine_20_Dotted_20__28_var_29_" draw:display-name="Ultrafine Dotted (var)" draw:style="rect" draw:dots1="1" draw:distance="50%"/>
            <draw:stroke-dash draw:name="Dash_20_10" draw:display-name="Dash 10" draw:style="rect" draw:dots1="1" draw:dots1-length="0.02cm" draw:dots2="1" draw:dots2-length="0.02cm" draw:distance="0.02cm"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="单元格式样">
        <xsl:variable name="uofSheet" select="/uof:UOF/uof:电子表格"/>
        <xsl:variable name="uofSheet1" select="/uof:UOF/uof:电子表格/表:主体/表:工作表"/>
        <xsl:variable name="uofSheetCom" select="$uofSheet/表:公用处理规则"/>
        <xsl:variable name="first-style" select="/uof:UOF/uof:式样集/uof:单元格式样"/>
        <xsl:variable name="quyu" select="/uof:UOF/uof:电子表格/表:公用处理规则/表:条件格式化集/表:条件格式化/表:区域"/>
        <xsl:variable name="condition-format-set" select="/uof:UOF/uof:电子表格/表:公用处理规则/表:条件格式化集/表:条件格式化"/>
        <xsl:variable name="aa">
            <xsl:for-each select="$first-style">
                <xsl:if test="@表:标识符!=@表:名称 and @表:名称!='Normal'">
                    <xsl:value-of select="@表:名称"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="bb">
            <xsl:for-each select="$first-style">
                <xsl:if test="@表:标识符!=@表:名称 and @表:名称!='Normal'">
                    <xsl:value-of select="@表:标识符"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <office:styles>
            <!-- if ConditionalFormatting exists,it should generate some styles for style:style -->
            <!--xsl:if test="$uofSheetCom/表:条件格式化集">
                <xsl:call-template name="CondFormat_office_style"/>
            </xsl:if-->
            <!--ro000179 chenjh-->
            <xsl:for-each select="$first-style[@表:类型='custom' or @表:类型='default']">
                <xsl:call-template name="单元格具体式样"/>
                <xsl:apply-templates select="表:数字格式[@表:格式码]"/>
                <xsl:apply-templates select="表:字体格式[字:上下标]"/>
            </xsl:for-each>
        </office:styles>
        <office:automatic-styles>
            <xsl:for-each select="$first-style[@表:类型='auto']">
                <xsl:variable name="apply-style-name" select="@表:名称"/>
                <xsl:variable name="style-name" select="@表:标识符"/>
                <xsl:choose>
                    <xsl:when test="$style-name!=$apply-style-name and $apply-style-name!='Normal'">
                        <xsl:for-each select="$condition-format-set/表:条件">
                            <style:style>
                                <xsl:attribute name="style:name"><xsl:value-of select="//uof:单元格式样[@表:名称=current()/表:格式/@表:式样引用 and @表:类型='auto']/@表:标识符"/></xsl:attribute>
                                <xsl:attribute name="style:family">table-cell</xsl:attribute>
                                <xsl:attribute name="style:parent-style-name">Default</xsl:attribute>
                                <xsl:for-each select="parent::表:条件格式化/表:条件">
                                    <xsl:variable name="condition-text">
                                        <xsl:choose>
                                            <xsl:when test="@表:类型='cell value'">
                                                <xsl:choose>
                                                    <xsl:when test="表:操作码/text()='between' ">
                                                        <xsl:value-of select="concat('cell-content-is-between','(',表:第一操作数/text(),',',表:第二操作数/text(),')')"/>
                                                    </xsl:when>
                                                    <xsl:when test=" 表:操作码/text()='not between'">
                                                        <xsl:value-of select="concat('cell-content-is-not-between','(',表:第一操作数/text(),',',表:第二操作数/text(),')')"/>
                                                    </xsl:when>
                                                    <xsl:when test="表:操作码/text()='equal to'">
                                                        <xsl:value-of select="concat('cell-content()=',表:第一操作数/text())"/>
                                                    </xsl:when>
                                                    <xsl:when test="表:操作码/text()='not equal to'">
                                                        <xsl:value-of select="concat('cell-content()!=',表:第一操作数/text())"/>
                                                    </xsl:when>
                                                    <xsl:when test="表:操作码/text()='greater than'">
                                                        <xsl:value-of select="concat('cell-content()&gt;',表:第一操作数/text())"/>
                                                    </xsl:when>
                                                    <xsl:when test="表:操作码/text()='less than'">
                                                        <xsl:value-of select="concat('cell-content()&lt;',表:第一操作数/text())"/>
                                                    </xsl:when>
                                                    <xsl:when test="表:操作码/text()='greater than or equal to'">
                                                        <xsl:value-of select="concat('cell-content()&gt;=',表:第一操作数/text())"/>
                                                    </xsl:when>
                                                    <xsl:when test="表:操作码/text()='less than or equal to'">
                                                        <xsl:value-of select="concat('cell-content()&lt;=',表:第一操作数/text())"/>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:when test="@表:类型='formula'">
                                                <xsl:value-of select="concat('is-true-formula','(',表:第一操作数/text(),')')"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:element name="style:map">
                                        <xsl:variable name="address">
                                            <xsl:value-of select="preceding-sibling::表:区域"/>
                                        </xsl:variable>
                                        <xsl:attribute name="style:condition"><xsl:value-of select="$condition-text"/></xsl:attribute>
                                        <xsl:attribute name="style:apply-style-name"><xsl:value-of select="表:格式/@表:式样引用"/></xsl:attribute>
                                        <xsl:attribute name="style:base-cell-address"><xsl:value-of select="substring-after($address,':')"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:for-each>
                            </style:style>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="uof:单元格式样 ">
                            <xsl:if test="@表:类型='auto' and (@表:标识符=@表:名称 or @表:名称='Normal')">
                                <xsl:call-template name="单元格具体式样"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <!--Redoffie comment liliang SC0008 06.02.14-->
            <!--1新增内容-->
            <xsl:if test="uof:单元格式样">
                <xsl:for-each select="uof:单元格式样">
                    <xsl:if test="@表:类型='auto' and (@表:标识符=@表:名称 or @表:名称='Normal')">
                        <xsl:call-template name="单元格具体式样"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象/@uof:公有类型='png' or /uof:UOF/uof:对象集/uof:其他对象/@uof:公有类型='ipg' or /uof:UOF/uof:对象集/uof:其他对象/@uof:公有类型='bmp' or /uof:UOF/uof:对象集/uof:其他对象/@uof:公有类型='gif'">
                <style:style style:name="Graphics" style:family="graphics">
                    <style:properties text:anchor-type="paragraph" svg:x="0cm" svg:y="0cm" style:wrap="none" style:vertical-pos="top" style:vertical-rel="paragraph" style:horizontal-pos="center" style:horizontal-rel="paragraph"/>
                </style:style>
            </xsl:if>
            <xsl:apply-templates select="/uof:UOF/uof:对象集/图:图形"/>
            <xsl:apply-templates select="/uof:UOF/uof:对象集/图:图形/图:文本内容/字:段落/字:句/字:句属性" mode="style"/>
            <!--Redoffice comment end 06.02.14-->
            <xsl:apply-templates select="$uofSheet1/表:工作表内容"/>
            <xsl:if test="uof:单元格式样">
                <xsl:for-each select="uof:单元格式样[@表:类型='auto' and (@表:标识符=@表:名称 or @表:名称='Normal')]">
                    <xsl:call-template name="单元格具体式样"/>
                    <xsl:apply-templates select="表:数字格式[@表:格式码]"/>
                    <xsl:apply-templates select="表:字体格式[字:上下标]"/>
                </xsl:for-each>
            </xsl:if>
            <!-- if ConditionalFormatting exists,transforing the styles -->
            <!--xsl:if test="$uofSheetCom/表:条件格式化集">
                <xsl:call-template name="CondFormat_automatic_style"/>
            </xsl:if-->
            <xsl:if test="$uofSheetCom/表:条件格式化集/表:条件格式化">
                <xsl:variable name="style-name" select="$first-style/@表:标识符"/>
                <xsl:variable name="left-top">
                    <xsl:call-template name="search-left-top-in-tables">
                        <xsl:with-param name="cellstylename" select="$style-name"/>
                        <xsl:with-param name="tableslist" select="$uofSheet1/表:工作表内容"/>
                        <xsl:with-param name="return" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="after-translated-left-top">
                    <xsl:call-template name="translate-left-top">
                        <xsl:with-param name="left-top" select="$left-top"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$after-translated-left-top!=''">
                    <xsl:call-template name="create-the-condition-format-map">
                        <xsl:with-param name="condition-format-set" select="$uofSheetCom/表:条件格式化集//表:条件格式化"/>
                        <xsl:with-param name="current-left-top" select="$after-translated-left-top"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:if>
            <xsl:apply-templates select="/uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/表:列/表:单元格/*[descendant-or-self::*[namespace-uri()='http://www.w3.org/TR/REC-html40']]"/>
            <!--xsl:apply-templates select="$uofSheet1/表:工作表属性/表:页面设置/表:页眉页脚/字:段落" /-->
            <xsl:call-template name="create-page-master">
                <xsl:with-param name="worksheetoptions" select="$uofSheet1/表:工作表属性"/>
            </xsl:call-template>
            <xsl:for-each select="uof:句式样">
                <style:style>
                    <xsl:attribute name="style:name"><xsl:value-of select="@字:标识符"/></xsl:attribute>
                    <xsl:attribute name="style:family">text</xsl:attribute>
                    <style:text-properties>
                        <xsl:apply-templates select="./*"/>
                    </style:text-properties>
                </style:style>
            </xsl:for-each>
        </office:automatic-styles>
        <office:master-styles>
            <xsl:call-template name="create-master-styles">
                <xsl:with-param name="worksheetoptions" select="$uofSheet1/表:工作表属性"/>
            </xsl:call-template>
        </office:master-styles>
    </xsl:template>
    <xsl:template match="表:数据有效性">
        <xsl:variable name="range-name-temp">
            <xsl:value-of select="substring-before(表:区域,'!')"/>
        </xsl:variable>
        <xsl:variable name="range-name">
            <xsl:value-of select="substring($range-name-temp,2,string-length($range-name-temp)-2)"/>
        </xsl:variable>
        <xsl:variable name="first-range">
            <xsl:choose>
                <xsl:when test="contains(表:区域, ',')">
                    <xsl:value-of select="translate(substring-after(substring-before(表:区域, ','),'!'),'$','')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(substring-after(表:区域,'!'),'$','')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="value-first">
            <xsl:value-of select="translate(表:第一操作数,'=','')"/>
        </xsl:variable>
        <xsl:variable name="value-second">
            <xsl:value-of select="translate(表:第二操作数,'=','')"/>
        </xsl:variable>
        <xsl:element name="table:content-validation">
            <xsl:attribute name="table:name"><xsl:value-of select="concat('val', position())"/></xsl:attribute>
            <!--数据有效性:第一操作数、第二操作数-->
            <!-- don't support two type of qualifier: List, Custom -->
            <xsl:attribute name="table:condition"><xsl:variable name="qualifier-content"><xsl:choose><xsl:when test="表:操作码 = 'between'"><xsl:choose><xsl:when test="(number($value-second))"><xsl:value-of select="concat('cell-content-is-between([',$range-name,'.',$value-first,'],',$value-second)"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('cell-content-is-between([',$range-name,'.',$value-first,'],[',$range-name,'.',$value-second,']')"/></xsl:otherwise></xsl:choose></xsl:when><xsl:when test="表:操作码 = 'not between'"><xsl:choose><xsl:when test="number($value-second)"><xsl:value-of select="concat('cell-content-is-not-between([',$range-name,'.',$value-first,'],',$value-second)"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('cell-content-is-not-between([',$range-name,'.',$value-first,'],[',$range-name,'.',$value-second,']')"/></xsl:otherwise></xsl:choose></xsl:when><xsl:when test="表:操作码 = 'not equal to'"><xsl:value-of select="concat('!=', $value-first)"/></xsl:when><xsl:when test="表:操作码 = 'equal to'"><xsl:variable name="range1"><xsl:value-of select="substring-after(substring-before($value-first,':'),'(')"/></xsl:variable><xsl:variable name="range2"><xsl:value-of select="substring-before(substring-after($value-first,':'),')')"/></xsl:variable><xsl:value-of select="concat('=SUM([',$range-name,'.',$range1,':',$range-name,'.',$range2,']')"/></xsl:when><xsl:when test="表:操作码 = 'less than'"><xsl:value-of select="concat('&lt;', $value-first)"/></xsl:when><xsl:when test="表:操作码 = 'greater than'"><xsl:value-of select="concat('&gt;', $value-first)"/></xsl:when><xsl:when test="表:操作码 = 'greater than or equal to'"><xsl:value-of select="concat('&gt;=[',$range-name, '.',$value-first,']')"/></xsl:when><xsl:when test="表:操作码 = 'less than or equal to'"><xsl:value-of select="concat('&lt;=[',$range-name,'.', $value-first,']')"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('([',$range-name,'.',substring-before($value-first,':'),':',$range-name,'.',substring-after($value-first,':'),'])')"/></xsl:otherwise></xsl:choose></xsl:variable><!--操作码、校验类型--><xsl:variable name="qualifier-value"><xsl:choose><xsl:when test="表:校验类型 = 'whole number'"><xsl:choose><xsl:when test="(表:操作码 = 'not between') or (表:操作码 = 'between')"><xsl:value-of select="concat('oooc:cell-content-is-whole-number() and ', $qualifier-content, ')')"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('oooc:cell-content-is-whole-number() and ', 'cell-content()', $qualifier-content)"/></xsl:otherwise></xsl:choose></xsl:when><xsl:when test="表:校验类型 = 'decimal'"><xsl:choose><xsl:when test="(表:操作码 = 'not between') or (表:操作码 = 'between')"><xsl:value-of select="concat('oooc:cell-content-is-decimal-number() and ', $qualifier-content, ')')"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('oooc:cell-content-is-decimal-number() and ', 'cell-content()', $qualifier-content)"/></xsl:otherwise></xsl:choose></xsl:when><xsl:when test="表:校验类型 = 'list'"><xsl:choose><xsl:when test="(表:操作码 = 'not between') or (表:操作码 = 'between')"><xsl:value-of select="concat('oooc:cell-content-is-in-list() and ', $qualifier-content, ')')"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('oooc:cell-content-is-in-list',$qualifier-content)"/></xsl:otherwise></xsl:choose></xsl:when><xsl:when test="表:校验类型 = 'date'"><xsl:choose><xsl:when test="(表:操作码 = 'not between') or (表:操作码 = 'between')"><xsl:value-of select="concat('oooc:cell-content-is-date() and ', $qualifier-content, ')')"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('oooc:cell-content-is-date() and ', 'cell-content()', $qualifier-content)"/></xsl:otherwise></xsl:choose></xsl:when><xsl:when test="表:校验类型 = 'time'"><xsl:choose><xsl:when test="(表:操作码 = 'not between') or (表:操作码 = 'between')"><xsl:value-of select="concat('oooc:cell-content-is-time() and ', $qualifier-content, ')')"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('oooc:cell-content-is-time() and ', 'cell-content()', $qualifier-content)"/></xsl:otherwise></xsl:choose></xsl:when><xsl:when test="表:校验类型 = 'text length'"><xsl:choose><xsl:when test="表:操作码 = 'not between'"><xsl:choose><xsl:when test="number($value-second)"><xsl:value-of select="concat('oooc:cell-content-text-length-is-not-between([', $range-name,'.',$value-first, '],', $value-second, ')')"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('oooc:cell-content-text-length-is-not-between([',$range-name,'.', $value-first, '],[',$range-name,'.', $value-second, '])')"/></xsl:otherwise></xsl:choose></xsl:when><xsl:when test="$value-second and $value-first"><xsl:choose><xsl:when test="number($value-second)"><xsl:value-of select="concat('oooc:cell-content-text-length-is-between([',$range-name,'.',$value-first,'],',$value-second,')')"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('oooc:cell-content-text-length-is-between([',$range-name,'.',$value-first,'],[',$range-name,'.',$value-second,'])')"/></xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise><xsl:value-of select="concat('oooc:cell-content-text-length()', $qualifier-content)"/></xsl:otherwise></xsl:choose></xsl:when><xsl:when test="表:校验类型 = 'custom'"><xsl:choose><xsl:when test="表:操作码 = 'between'"><xsl:value-of select="concat('and cell-content-is-between(',substring-before($value-first,'('),'([',$range-name,'.',substring-after(substring-before($value-first,':'),'('),':',$range-name,'.',substring-before(substring-after($value-first,':'),')'),']),0')"/></xsl:when><xsl:when test="表:操作码 = 'not between'"><xsl:value-of select="concat('oooc:and cell-content-is-not-between(',substring-before($value-first,'('),'([',$range-name,'.',substring-after(substring-before($value-first,':'),'('),':',$range-name,'.',substring-before(substring-after($value-first,':'),')'),']),0')"/></xsl:when><xsl:otherwise><xsl:value-of select="concat('oooc:cell-content-is-custom() and ', 'cell-content()', $qualifier-content)"/></xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise><xsl:value-of select="表:校验类型"/></xsl:otherwise></xsl:choose></xsl:variable><xsl:value-of select="$qualifier-value"/></xsl:attribute>
            <!--忽略空格-->
            <xsl:attribute name="table:allow-empty-cell"><xsl:choose><xsl:when test="表:忽略空格"><xsl:value-of select="'false'"/></xsl:when><xsl:otherwise><xsl:value-of select="'true'"/></xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="table:base-cell-address"><xsl:variable name="range"><xsl:value-of select="$first-range"/><!--xsl:call-template name="translate-expression">
                        <xsl:with-param name="cell-row-pos" select="0" />
                        <xsl:with-param name="cell-column-pos" select="0" />
                        <xsl:with-param name="expression" select="$first-range" />
                        <xsl:with-param name="return-value" select="''" />
                    </xsl:call-template--></xsl:variable><xsl:call-template name="encode-as-cell-address"><xsl:with-param name="string" select="concat($range-name, '.', $range)"/></xsl:call-template></xsl:attribute>
            <!--输入提示-->
            <xsl:element name="table:help-message">
                <xsl:attribute name="table:title"><xsl:value-of select="表:输入提示/@表:标题"/></xsl:attribute>
                <xsl:attribute name="table:display"><xsl:choose><xsl:when test="表:输入提示/@表:显示"><xsl:value-of select="表:输入提示/@表:显示"/></xsl:when><xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:element name="text:p">
                    <xsl:value-of select="表:输入提示/@表:内容"/>
                </xsl:element>
            </xsl:element>
            <!--错误提示-->
            <xsl:element name="table:error-message">
                <xsl:attribute name="table:message-type"><xsl:choose><xsl:when test="表:错误提示/@表:类型= 'information'"><xsl:value-of select="'information'"/></xsl:when><xsl:when test="表:错误提示/@表:类型= 'warning'"><xsl:value-of select="'warning'"/></xsl:when><xsl:otherwise><xsl:value-of select="'stop'"/></xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="table:title"><xsl:value-of select="表:错误提示/@表:标题"/></xsl:attribute>
                <xsl:attribute name="table:display"><xsl:choose><xsl:when test="表:错误提示/@表:显示"><xsl:value-of select="表:错误提示/@表:显示"/></xsl:when><xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:element name="text:p">
                    <xsl:value-of select="表:错误提示/@表:内容"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="CondFormat_office_style">
        <xsl:for-each select="../../uof:电子表格/表:公用处理规则/表:条件格式化集/表:条件格式化">
            <xsl:variable name="table-pos" select="count(../../../preceding-sibling::表:公用处理规则)+1"/>
            <xsl:variable name="conditions" select="count(../preceding-sibling::表:条件格式化集)+1"/>
            <xsl:for-each select="表:条件">
                <xsl:variable name="condition-number" select="count(preceding-sibling::表:条件)+1"/>
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name"><xsl:call-template name="encode-as-nc-name"><xsl:with-param name="string" select="concat('Excel_CondFormat_',$table-pos,'_',$conditions,'_',$condition-number)"/></xsl:call-template></xsl:attribute>
                    <xsl:attribute name="style:family">table-cell</xsl:attribute>
                    <xsl:element name="style:properties">
                        <xsl:choose>
                            <xsl:when test="表:格式/@表:式样引用">
                                <xsl:variable name="stylevalue" select="表:格式/@表:式样引用"/>
                                <xsl:call-template name="recursion-condformat-style-table-cell">
                                    <xsl:with-param name="style-value-t">
                                        <xsl:choose>
                                            <xsl:when test="substring($stylevalue,string-length($stylevalue),1) != ';'">
                                                <xsl:value-of select="concat($stylevalue,';')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$stylevalue"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:element>
                    <!--xsl:element name="style:text-properties"-->
                    <!--chengxz0618-->
                    <xsl:element name="style:properties">
                        <xsl:choose>
                            <xsl:when test="表:格式/@表:式样引用">
                                <xsl:variable name="stylevalue" select="表:格式/@表:式样引用"/>
                                <xsl:call-template name="recursion-condformat-style-text">
                                    <xsl:with-param name="style-value-t">
                                        <xsl:choose>
                                            <xsl:when test="substring($stylevalue,string-length($stylevalue),1) != ';'">
                                                <xsl:value-of select="concat($stylevalue,';')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$stylevalue"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="fo:font-style"><xsl:value-of select="'italic'"/></xsl:attribute>
                                <xsl:attribute name="style:text-underline-type"><xsl:value-of select="'single'"/></xsl:attribute>
                                <xsl:attribute name="style:text-underline-color"><xsl:value-of select="'font-color'"/></xsl:attribute>
                                <xsl:attribute name="fo:font-weight"><xsl:value-of select="'bold'"/></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="cell-pattern-color">
        <xsl:param name="pattern"/>
        <xsl:param name="color-value"/>
        <xsl:param name="pattern-color-value"/>
        <xsl:variable name="rev-pattern" select="1 - $pattern"/>
        <xsl:variable name="color-R-value">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="substring($color-value,2,2)"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="2"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="color-G-value">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="substring($color-value,4,2)"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="2"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="color-B-value">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="substring($color-value,6,2)"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="2"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="pattern-R-value">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="substring($pattern-color-value,2,2)"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="2"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="pattern-G-value">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="substring($pattern-color-value,4,2)"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="2"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="pattern-B-value">
            <xsl:call-template name="hex2decimal">
                <xsl:with-param name="hex-number" select="substring($pattern-color-value,6,2)"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="str-length" select="2"/>
                <xsl:with-param name="last-value" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="R-value">
            <xsl:variable name="combined-R-value">
                <xsl:call-template name="decimal2hex">
                    <xsl:with-param name="dec-number" select="floor($color-R-value * $rev-pattern + $pattern-R-value * $pattern)"/>
                    <xsl:with-param name="last-value" select="'H'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($combined-R-value) = 1">
                    <xsl:value-of select="concat('0',$combined-R-value)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$combined-R-value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="G-value">
            <xsl:variable name="combined-G-value">
                <xsl:call-template name="decimal2hex">
                    <xsl:with-param name="dec-number" select="floor($color-G-value * $rev-pattern + $pattern-G-value * $pattern)"/>
                    <xsl:with-param name="last-value" select="'H'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($combined-G-value) = 1">
                    <xsl:value-of select="concat('0',$combined-G-value)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$combined-G-value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="B-value">
            <xsl:variable name="combined-B-value">
                <xsl:call-template name="decimal2hex">
                    <xsl:with-param name="dec-number" select="floor($color-B-value * $rev-pattern + $pattern-B-value * $pattern)"/>
                    <xsl:with-param name="last-value" select="'H'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($combined-B-value) = 1">
                    <xsl:value-of select="concat('0',$combined-B-value)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$combined-B-value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat('#',$R-value,$G-value,$B-value)"/>
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
    <xsl:template name="decimal2hex">
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
    <xsl:template name="recursion-condformat-style-table-cell">
        <xsl:param name="style-value-t"/>
        <xsl:variable name="style-value" select="$style-value-t"/>
        <xsl:choose>
            <xsl:when test="starts-with($style-value,'background')">
                <xsl:choose>
                    <xsl:when test="contains($style-value,'mso-pattern')">
                        <xsl:variable name="color-value">
                            <xsl:call-template name="translate-color-style">
                                <xsl:with-param name="source-str" select="normalize-space(substring-before(substring-after($style-value,':'),';'))"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="mso-value">
                            <xsl:call-template name="translate-color-style">
                                <xsl:with-param name="source-str" select="normalize-space(substring-after($style-value,'mso-pattern'))"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="mso-color" select="substring-after($mso-value,'#')"/>
                        <xsl:variable name="pattern-color-value" select="substring($mso-color,1,6)"/>
                        <xsl:variable name="pattern" select="concat('0.',normalize-space(substring-before(substring-after($mso-color,'gray-'),';')))"/>
                        <xsl:variable name="pattern-color">
                            <xsl:call-template name="cell-pattern-color">
                                <xsl:with-param name="pattern" select="$pattern"/>
                                <xsl:with-param name="color-value" select="$color-value"/>
                                <xsl:with-param name="pattern-color-value" select="concat('#',$pattern-color-value)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:attribute name="fo:background-color"><xsl:value-of select="normalize-space($pattern-color)"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="fo:background-color"><xsl:call-template name="translate-color-style"><xsl:with-param name="source-str" select="normalize-space(substring-before(substring-after($style-value,':'),';'))"/></xsl:call-template></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with($style-value,'border')">
                <xsl:attribute name="fo:border"><xsl:value-of select="'0.002cm solid #000000'"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="contains($style-value,':')">
            <xsl:call-template name="recursion-condformat-style-table-cell">
                <xsl:with-param name="style-value-t" select="substring-after($style-value,';')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="recursion-condformat-style-text">
        <xsl:param name="style-value-t"/>
        <xsl:variable name="style-value" select="normalize-space($style-value-t)"/>
        <xsl:choose>
            <xsl:when test="starts-with($style-value,'color')">
                <xsl:attribute name="fo:color"><xsl:call-template name="translate-color-style"><xsl:with-param name="source-str" select="normalize-space(substring-before(substring-after($style-value,':'),';'))"/></xsl:call-template></xsl:attribute>
            </xsl:when>
            <xsl:when test="starts-with($style-value,'font-style')">
                <xsl:attribute name="fo:font-style"><xsl:value-of select="normalize-space(substring-before(substring-after($style-value,':'),';'))"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="starts-with($style-value,'font-weight')">
                <xsl:variable name="font-weight" select="normalize-space(substring-before(substring-after($style-value,':'),';'))"/>
                <xsl:attribute name="fo:font-weight"><xsl:choose><xsl:when test="($font-weight &gt; 300) and ($font-weight &lt; 500)"><xsl:value-of select="'normal'"/></xsl:when><xsl:when test="($font-weight &gt; 500) or ($font-weight = 500)"><xsl:value-of select="'bold'"/></xsl:when><xsl:otherwise><xsl:value-of select="'0'"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:when>
            <xsl:when test="starts-with($style-value,'text-underline-style')">
                <xsl:attribute name="style:text-underline-type"><xsl:value-of select="normalize-space(substring-before(substring-after($style-value,':'),';'))"/></xsl:attribute>
                <xsl:attribute name="style:text-underline-color"><xsl:value-of select="'#000000'"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="contains($style-value,':')">
            <xsl:call-template name="recursion-condformat-style-text">
                <xsl:with-param name="style-value-t" select="substring-after($style-value,';')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="translate-color-style">
        <xsl:param name="source-str"/>
        <xsl:choose>
            <xsl:when test="starts-with($source-str,'#')">
                <xsl:value-of select="$source-str"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with($source-str,'black')">
                        <xsl:value-of select="'#000000'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'maroon')">
                        <xsl:value-of select="'#800000'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'red')">
                        <xsl:value-of select="'#FF0000'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'fuchsia')">
                        <xsl:value-of select="'#FF00FF'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'olive')">
                        <xsl:value-of select="'#808000'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'yellow')">
                        <xsl:value-of select="'#FFFF00'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'green')">
                        <xsl:value-of select="'#008000'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'lime')">
                        <xsl:value-of select="'#00FF00'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'teal')">
                        <xsl:value-of select="'#008080'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'aqua')">
                        <xsl:value-of select="'#00FFFF'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'navy')">
                        <xsl:value-of select="'#000080'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'blue')">
                        <xsl:value-of select="'#0000FF'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'purple')">
                        <xsl:value-of select="'#800080'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'gray')">
                        <xsl:value-of select="'#808080'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'silver')">
                        <xsl:value-of select="'#C0C0C0'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($source-str,'white')">
                        <xsl:value-of select="'#FFFFFF'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'#FFFFFF'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="CondFormat_automatic_style">
        <xsl:for-each select="../uof:电子表格/表:公用处理规则/表:条件格式化集/表:条件格式化">
            <xsl:variable name="table-pos" select="count(../../../preceding-sibling::表:公用处理规则)+1"/>
            <xsl:variable name="conditions" select="count(../preceding-sibling::表:条件格式化集)+1"/>
            <xsl:element name="style:style">
                <xsl:attribute name="style:name"><xsl:call-template name="encode-as-nc-name"><xsl:with-param name="string" select="concat('ce',$table-pos,'-',$conditions)"/></xsl:call-template></xsl:attribute>
                <xsl:attribute name="style:family">table-cell</xsl:attribute>
                <xsl:for-each select="uof:单元格式样/表:条件">
                    <xsl:variable name="condition-number" select="count(preceding-sibling::表:条件)+1"/>
                    <xsl:variable name="base-address">
                        <xsl:choose>
                            <xsl:when test="contains(../表:区域,',')">
                                <xsl:choose>
                                    <xsl:when test="contains(substring-before(../表:区域,','),':')">
                                        <xsl:value-of select="substring-before(substring-after(../表:区域,':'),',')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-before(../表:区域,',')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="../表:区域"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="base-cell-address">
                        <xsl:call-template name="translate-unit">
                            <xsl:with-param name="column-number" select="substring-before(substring-after($base-address,'R'),'C')"/>
                            <xsl:with-param name="row-number" select="substring-after($base-address,'C')"/>
                            <xsl:with-param name="column-pos-style" select="absolute"/>
                            <xsl:with-param name="row-pos-style" select="absolute"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="condition-value">
                        <xsl:call-template name="translate-condition">
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:element name="style:map">
                        <xsl:attribute name="style:condition"><xsl:value-of select="$condition-value"/></xsl:attribute>
                        <xsl:attribute name="style:apply-style-name"><xsl:value-of select="concat('Excel_CondFormat_',$table-pos,'_',$conditions,'_',$condition-number)"/></xsl:attribute>
                        <xsl:attribute name="style:base-cell-address"><xsl:value-of select="concat(../../@Name,'.',$base-cell-address)"/></xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="translate-condition">
        <xsl:variable name="address-value">
            <xsl:call-template name="translate-expression">
                <xsl:with-param name="cell-row-pos" select="0"/>
                <xsl:with-param name="cell-column-pos" select="0"/>
                <xsl:with-param name="expression" select="表:第一操作数"/>
                <xsl:with-param name="return-value" select="''"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="表:操作码">
                <xsl:variable name="qualifier" select="表:操作码"/>
                <xsl:variable name="first-value" select="表:第一操作数"/>
                <xsl:choose>
                    <xsl:when test="$qualifier = 'Equal'">
                        <xsl:choose>
                            <xsl:when test="starts-with($first-value,'&quot;')">
                                <xsl:value-of select="concat('cell-content()=',$address-value)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('cell-content()=[',$address-value,']')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$qualifier = 'Less'">
                        <xsl:value-of select="concat('cell-content()&lt;[',$address-value,']')"/>
                    </xsl:when>
                    <xsl:when test="$qualifier = 'Greater'">
                        <xsl:value-of select="concat('cell-content()&gt;[',$address-value,']')"/>
                    </xsl:when>
                    <xsl:when test="$qualifier = 'LessOrEqual'">
                        <xsl:value-of select="concat('cell-content()&lt;=[',$address-value,']')"/>
                    </xsl:when>
                    <xsl:when test="$qualifier = 'GreaterOrEqual'">
                        <xsl:value-of select="concat('cell-content()&gt;=[',$address-value,']')"/>
                    </xsl:when>
                    <xsl:when test="$qualifier = 'NotEqual'">
                        <xsl:value-of select="concat('cell-content()!=[',$address-value,']')"/>
                    </xsl:when>
                    <xsl:when test="$qualifier = 'Between'">
                        <xsl:variable name="second-value">
                            <xsl:call-template name="translate-expression">
                                <xsl:with-param name="cell-row-pos" select="0"/>
                                <xsl:with-param name="cell-column-pos" select="0"/>
                                <xsl:with-param name="expression" select="表:第二操作数"/>
                                <xsl:with-param name="return-value" select="''"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat('cell-content-is-between([',$address-value,'],[',$second-value,'])')"/>
                    </xsl:when>
                    <xsl:when test="$qualifier = 'NotBetween'">
                        <xsl:variable name="second-value">
                            <xsl:call-template name="translate-expression">
                                <xsl:with-param name="cell-row-pos" select="0"/>
                                <xsl:with-param name="cell-column-pos" select="0"/>
                                <xsl:with-param name="expression" select="表:第二操作数"/>
                                <xsl:with-param name="return-value" select="''"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat('cell-content-is-not-between([',$address-value,'],[',$second-value,'])')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('is-true-formula(',$address-value,')')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="translate-expression">
        <xsl:param name="cell-row-pos"/>
        <xsl:param name="cell-column-pos"/>
        <xsl:param name="expression"/>
        <xsl:param name="return-value"/>
        <xsl:variable name="temp-range">
            <xsl:choose>
                <xsl:when test="$expression != ''">
                    <xsl:call-template name="parse-range-name">
                        <xsl:with-param name="expression" select="$expression"/>
                        <xsl:with-param name="return-value" select="''"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="range-type">
            <xsl:choose>
                <xsl:when test="substring($temp-range, 1, 1) = '1'">
                    <xsl:value-of select="1"/>
                </xsl:when>
                <xsl:when test="substring($temp-range, 1, 1) = '2'">
                    <xsl:value-of select="2"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="2"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="current-range">
            <xsl:value-of select="substring($temp-range, 2)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$range-type = 1">
                <xsl:call-template name="translate-expression">
                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                    <xsl:with-param name="expression">
                        <xsl:choose>
                            <xsl:when test="contains($current-range, '#$')">
                                <xsl:variable name="temp-token">
                                    <xsl:choose>
                                        <xsl:when test="contains($current-range, '\')">
                                            <xsl:value-of select="concat(']', substring-after($current-range, '#$'), &quot;&apos;&quot;)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-after($current-range, '#$')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:value-of select="substring-after($expression, $temp-token)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after($expression, $current-range)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="return-value">
                        <xsl:choose>
                            <xsl:when test="$current-range = '='">
                                <xsl:text>oooc:=</xsl:text>
                            </xsl:when>
                            <xsl:when test="substring($current-range, string-length($current-range)) = '('">
                                <xsl:value-of select="concat($return-value, substring-before($expression, $current-range), $current-range, '[.')"/>
                            </xsl:when>
                            <xsl:when test="$current-range = ','">
                                <xsl:value-of select="concat($return-value, substring-before($expression, $current-range), '];[.')"/>
                            </xsl:when>
                            <xsl:when test="$current-range = ')'">
                                <xsl:value-of select="concat($return-value, substring-before($expression, $current-range), '])')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($return-value, substring-before($expression, $current-range), $current-range)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="handle-type">
                    <xsl:choose>
                        <xsl:when test="starts-with($current-range, 'R')">
                            <xsl:choose>
                                <xsl:when test="contains($current-range, 'C')">
                                    <xsl:variable name="part-type-r">
                                        <xsl:call-template name="handle-type-number">
                                            <xsl:with-param name="t-part" select="substring-before( substring-after($current-range, 'R'), 'C')"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="part-type-c">
                                        <xsl:call-template name="handle-type-number">
                                            <xsl:with-param name="t-part" select="substring-after($current-range, 'C')"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when test="($part-type-r = 1) and ($part-type-c = 1)">
                                            <xsl:value-of select="1"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="4"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="part-type">
                                        <xsl:call-template name="handle-type-number">
                                            <xsl:with-param name="t-part" select="substring-after($current-range, 'R')"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when test="$part-type = 1">
                                            <xsl:value-of select="2"/>
                                        </xsl:when>
                                        <xsl:when test="$part-type = 2">
                                            <xsl:value-of select="4"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="4"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="starts-with($current-range, 'C')">
                            <xsl:variable name="part-type">
                                <xsl:call-template name="handle-type-number">
                                    <xsl:with-param name="t-part" select="substring-after($current-range, 'C')"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$part-type = 1">
                                    <xsl:value-of select="3"/>
                                </xsl:when>
                                <xsl:when test="$part-type = 2">
                                    <xsl:value-of select="4"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="4"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="4"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$handle-type = 1">
                        <xsl:variable name="after-R">
                            <xsl:value-of select="substring(substring-after($current-range,'R'),1,1)"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$after-R='C' or $after-R='[' or $after-R='0' or $after-R='1' or $after-R='2' or $after-R='3' or $after-R='4' or $after-R='5' or $after-R='6' or $after-R='7' or $after-R='8' or $after-R='9'">
                                <xsl:variable name="row-pos">
                                    <xsl:choose>
                                        <xsl:when test="$after-R='['">
                                            <xsl:value-of select="$cell-row-pos+substring-before( substring-after($current-range,'R['),']')"/>
                                        </xsl:when>
                                        <xsl:when test="$after-R='C'">
                                            <xsl:value-of select="$cell-row-pos"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-before(substring-after($current-range,'R'),'C')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="row-pos-style">
                                    <xsl:choose>
                                        <xsl:when test="$after-R='[' or $after-R='C'">relative</xsl:when>
                                        <xsl:otherwise>absolute</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="after-C">
                                    <xsl:value-of select="substring(substring-after(substring-after($current-range,'R'),'C'),1,1)"/>
                                </xsl:variable>
                                <xsl:variable name="column-digit-length">
                                    <xsl:choose>
                                        <xsl:when test="$after-C='0' or $after-C='1' or $after-C='2' or $after-C='3' or $after-C='4' or $after-C='5' or $after-C='6' or $after-C='7' or $after-C='8' or $after-C='9'">
                                            <xsl:call-template name="get-digit-length">
                                                <xsl:with-param name="complexive-string" select="substring-after(substring-after($current-range,'R'),'C')"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="column-pos">
                                    <xsl:choose>
                                        <xsl:when test="$after-C='['">
                                            <xsl:value-of select="$cell-column-pos + substring-before(substring-after(substring-after($current-range,'R'),'C['),']')"/>
                                        </xsl:when>
                                        <xsl:when test="$after-C='0' or $after-C='1' or $after-C='2' or $after-C='3' or $after-C='4' or $after-C='5' or $after-C='6' or $after-C='7' or $after-C='8' or $after-C='9'">
                                            <xsl:value-of select="substring(substring-after(substring-after($current-range,'R'),'C'),1,$column-digit-length)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$cell-column-pos"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="column-pos-style">
                                    <xsl:choose>
                                        <xsl:when test="$after-C='0' or $after-C='1' or $after-C='2' or $after-C='3' or $after-C='4' or $after-C='5' or $after-C='6' or $after-C='7' or $after-C='8' or $after-C='9'">absolute</xsl:when>
                                        <xsl:otherwise>relative</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="trans-unit">
                                    <xsl:call-template name="translate-unit">
                                        <xsl:with-param name="column-number" select="$column-pos"/>
                                        <xsl:with-param name="row-number" select="$row-pos"/>
                                        <xsl:with-param name="column-pos-style" select="$column-pos-style"/>
                                        <xsl:with-param name="row-pos-style" select="$row-pos-style"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), $trans-unit)"/>
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($expression, $current-range)"/>
                                    <xsl:with-param name="return-value" select="concat($return-value, $name-unit)"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), translate( substring-before(substring-after($expression, '('),'R'),',!', ';.'))"/>
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($current-range,'R')"/>
                                    <xsl:with-param name="return-value" select="concat($return-value, $name-unit)"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$handle-type = 2">
                        <xsl:variable name="after-R">
                            <xsl:value-of select="substring(substring-after($current-range,'R'),1,1)"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$after-R='[' or $after-R='0' or $after-R='1' or $after-R='2' or $after-R='3' or $after-R='4' or $after-R='5' or $after-R='6' or $after-R='7' or $after-R='8' or $after-R='9'">
                                <xsl:variable name="row-number">
                                    <xsl:choose>
                                        <xsl:when test="$after-R = '['">
                                            <xsl:value-of select="substring-before(substring-after($current-range, 'R['), ']')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-after($current-range, 'R')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="row-pos">
                                    <xsl:choose>
                                        <xsl:when test="$after-R='['">
                                            <xsl:value-of select="$cell-row-pos + $row-number"/>
                                        </xsl:when>
                                        <xsl:when test="$after-R='0' or $after-R='1' or $after-R='2' or $after-R='3' or $after-R='4' or $after-R='5' or $after-R='6' or $after-R='7' or $after-R='8' or $after-R='9'">
                                            <xsl:value-of select="$row-number"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$cell-row-pos"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="trans-unit1">
                                    <xsl:call-template name="translate-unit">
                                        <xsl:with-param name="column-number" select="1"/>
                                        <xsl:with-param name="row-number" select="$row-pos"/>
                                        <xsl:with-param name="column-pos-style" select="'relative'"/>
                                        <xsl:with-param name="row-pos-style" select="'relative'"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="trans-unit2">
                                    <xsl:call-template name="translate-unit">
                                        <xsl:with-param name="column-number" select="256"/>
                                        <xsl:with-param name="row-number" select="$row-pos"/>
                                        <xsl:with-param name="column-pos-style" select="'relative'"/>
                                        <xsl:with-param name="row-pos-style" select="'relative'"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), $trans-unit1, ':', $trans-unit2)"/>
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($expression, $current-range)"/>
                                    <xsl:with-param name="return-value" select="concat($return-value, $name-unit)"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), translate( substring-before($current-range,'R'),',!', ';.'),'R')"/>
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($current-range,'R')"/>
                                    <xsl:with-param name="return-value" select="concat($return-value, $name-unit)"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$handle-type = 3">
                        <xsl:variable name="after-C">
                            <xsl:value-of select="substring(substring-after($current-range,'C'),1,1)"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$after-C='[' or $after-C='0' or $after-C='1' or $after-C='2' or $after-C='3' or $after-C='4' or $after-C='5' or $after-C='6' or $after-C='7' or $after-C='8' or $after-C='9'">
                                <xsl:variable name="column-number">
                                    <xsl:choose>
                                        <xsl:when test="$after-C = '['">
                                            <xsl:value-of select="substring-before(substring-after($current-range, 'C['), ']')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-after($current-range, 'C')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="column-pos">
                                    <xsl:choose>
                                        <xsl:when test="$after-C='['">
                                            <xsl:value-of select="$cell-column-pos + $column-number"/>
                                        </xsl:when>
                                        <xsl:when test="$after-C='0' or $after-C='1' or $after-C='2' or $after-C='3' or $after-C='4' or $after-C='5' or $after-C='6' or $after-C='7' or $after-C='8' or $after-C='9'">
                                            <xsl:value-of select="$column-number"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$cell-column-pos"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="trans-unit1">
                                    <xsl:call-template name="translate-unit">
                                        <xsl:with-param name="column-number" select="$column-pos"/>
                                        <xsl:with-param name="row-number" select="1"/>
                                        <xsl:with-param name="column-pos-style" select="'relative'"/>
                                        <xsl:with-param name="row-pos-style" select="'relative'"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="trans-unit2">
                                    <xsl:call-template name="translate-unit">
                                        <xsl:with-param name="column-number" select="$column-pos"/>
                                        <xsl:with-param name="row-number" select="32000"/>
                                        <xsl:with-param name="column-pos-style" select="'relative'"/>
                                        <xsl:with-param name="row-pos-style" select="'relative'"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), $trans-unit1, ':', $trans-unit2)"/>
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($expression, $current-range)"/>
                                    <xsl:with-param name="return-value" select="concat($return-value, $name-unit)"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), translate( substring-before($current-range,'C'),',!', ';.'),'C')"/>
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($current-range,'C')"/>
                                    <xsl:with-param name="return-value" select="concat($return-value, $name-unit)"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="next-pit" select="substring-after($expression, $current-range)"/>
                        <xsl:choose>
                            <xsl:when test="contains($next-pit, '+') or contains($next-pit, '-') or contains($next-pit, '*') or contains($next-pit, '/') or contains($next-pit, ')') or contains($next-pit, '^') or contains($next-pit, ':') or contains($next-pit, '&quot;') or contains($next-pit, ';') or contains($next-pit, ',') or contains($next-pit, '[')">
                                <xsl:call-template name="translate-expression">
                                    <xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
                                    <xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
                                    <xsl:with-param name="expression" select="substring-after($expression, $current-range)"/>
                                    <xsl:with-param name="return-value" select="concat($return-value, substring-before($expression, $current-range), $current-range)"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="translate( concat($return-value, substring-before($expression, $current-range), $current-range),',!', ';.')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="parse-range-name">
        <xsl:param name="expression"/>
        <xsl:param name="return-value"/>
        <xsl:variable name="first-one" select="substring($expression,1,1)"/>
        <xsl:choose>
            <xsl:when test="$first-one = '='">
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space($return-value)) &gt; 0">
                        <xsl:value-of select="concat('2', $return-value)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>1=</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$first-one='(' or $first-one='!' or $first-one='&amp;'">
                <xsl:value-of select="concat('1', $return-value, $first-one)"/>
            </xsl:when>
            <xsl:when test="$first-one='['">
                <xsl:choose>
                    <xsl:when test="starts-with(substring-after($expression, ']'), 'C')">
                        <xsl:call-template name="parse-range-name">
                            <xsl:with-param name="expression" select="substring-after($expression, ']')"/>
                            <xsl:with-param name="return-value" select="concat($return-value, substring-before($expression, ']'), ']')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains(substring-before($expression, ']'), '.') and contains(substring-after($expression, ']'), '!')">
                        <xsl:value-of select="concat('1', &quot;&apos;&quot;, substring-before(substring-after($expression, '['), ']'), &quot;&apos;&quot;, '#$', substring-before(substring-after($expression, ']'), '!'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('2', $return-value, substring-before($expression, ']'), ']')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$first-one='&quot;'">
                <xsl:value-of select="concat('1', $first-one, substring-before(substring-after($expression, '&quot;'), '&quot;'), '&quot;')"/>
            </xsl:when>
            <xsl:when test="$first-one=&quot;&apos;&quot;">
                <xsl:variable name="str-in" select="substring-before(substring-after($expression, &quot;&apos;&quot;), &quot;&apos;&quot;)"/>
                <xsl:choose>
                    <xsl:when test="contains($str-in, '\') and contains($str-in, '[') and contains($str-in, ']')">
                        <xsl:variable name="first-pos" select="substring-before($str-in, '[')"/>
                        <xsl:variable name="second-pos" select="substring-before(substring-after($str-in, '['), ']')"/>
                        <xsl:variable name="third-pos" select="substring-after($str-in, ']')"/>
                        <xsl:value-of select="concat('1', &quot;&apos;&quot;, $first-pos, $second-pos, &quot;&apos;&quot;, '#$', $third-pos)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('1', &quot;&apos;&quot;, $str-in, &quot;&apos;&quot;)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$first-one='+' or $first-one='-' or $first-one='*' or $first-one='/' or $first-one=')' or $first-one='^' or $first-one=':' or $first-one='&quot;' or $first-one=';' or $first-one=',' or $first-one='&gt;' or $first-one='&lt;'">
                <xsl:choose>
                    <xsl:when test="$return-value = ''">
                        <xsl:value-of select="concat('1', $first-one)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('2', $return-value)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$expression = ''">
                        <xsl:value-of select="concat('2', $return-value)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="parse-range-name">
                            <xsl:with-param name="expression" select="substring($expression, 2, string-length($expression)-1)"/>
                            <xsl:with-param name="return-value" select="concat($return-value, substring($expression, 1, 1))"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="handle-type-number">
        <xsl:param name="t-part"/>
        <xsl:choose>
            <xsl:when test="starts-with($t-part, '[')">
                <xsl:variable name="tt-str" select="substring-before( substring-after( $t-part, '['), ']')"/>
                <xsl:choose>
                    <xsl:when test="($tt-str &lt; 0) or ($tt-str &gt; 0) or ($tt-str = 0)">
                        <xsl:value-of select="1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="2"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="($t-part &lt; 0) or ($t-part &gt; 0) or ($t-part = 0)">
                <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:when test="$t-part = ''">
                <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="translate-unit">
        <xsl:param name="column-number"/>
        <xsl:param name="row-number"/>
        <xsl:param name="column-pos-style"/>
        <xsl:param name="row-pos-style"/>
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
        <xsl:choose>
            <xsl:when test="$column-pos-style = 'absolute'">
                <xsl:value-of select="concat( '$', $column-character1, $column-character2)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat( $column-character1, $column-character2)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="$row-pos-style ='absolute'">
                <xsl:value-of select="concat( '$', $row-number)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$row-number"/>
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
    <xsl:template name="get-digit-length">
        <xsl:param name="complexive-string"/>
        <xsl:variable name="first-char">
            <xsl:value-of select="substring( $complexive-string, 1, 1)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$first-char = '1' or $first-char =  '2' or $first-char =  '3' or $first-char =  '4' or $first-char =  '5' or $first-char =  '6' or $first-char = '7' or $first-char =  '8' or $first-char =  '9' or $first-char = '0' ">
                <xsl:variable name="temp">
                    <xsl:call-template name="get-digit-length">
                        <xsl:with-param name="complexive-string" select="substring( $complexive-string, 2)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$temp+1"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:句属性" mode="style">
        <!--chengxz 0725-->
        <xsl:if test="not(@字:式样引用)">
            <xsl:element name="style:style">
                <xsl:attribute name="style:name">T<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:句属性" format="1"/></xsl:attribute>
                <xsl:attribute name="style:family">text</xsl:attribute>
                <xsl:if test="@字:式样引用">
                    <xsl:attribute name="style:parent-style-name"><xsl:value-of select="@字:式样引用"/></xsl:attribute>
                </xsl:if>
                <xsl:element name="style:text-properties">
                    <xsl:apply-templates select="./*"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="style-style-content">
        <xsl:variable name="style-name" select="@表:标识符"/>
        <xsl:variable name="apply-style-name" select="@表:名称"/>
        <xsl:attribute name="style:family"><xsl:choose><xsl:when test="/uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/表:列[@表:式样引用=$style-name]">table-column</xsl:when><xsl:otherwise>table-cell</xsl:otherwise></xsl:choose></xsl:attribute>
        <xsl:if test="/uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/表:列[@表:式样引用=$style-name]/@表:列宽">
            <xsl:element name="style:table-column-properties">
                <xsl:attribute name="style:column-width"><xsl:value-of select="concat(/uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/表:列[@表:式样引用=$style-name]/@表:列宽,$uofUnit)"/></xsl:attribute>
                <xsl:if test="/uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/表:列[@表:式样引用=$style-name]/@表:跨度">
                    <xsl:attribute name="fo:break-before">auto</xsl:attribute>
                </xsl:if>
                <xsl:for-each select="/uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/表:列[@表:式样引用=$style-name]">
                    <xsl:if test="preceding-sibling::表:列[1]/@表:跨度 and ancestor::表:工作表/表:分页符集/表:分页符/@表:列号">
                        <xsl:variable name="kuadu">
                            <xsl:value-of select="preceding-sibling::表:列[1]/@表:跨度"/>
                        </xsl:variable>
                        <xsl:if test="not($kuadu='1')">
                            <xsl:attribute name="fo:break-before">page</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$kuadu='1' and not(preceding::表:列[2])">
                            <xsl:attribute name="fo:break-before">page</xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
        <xsl:element name="style:table-cell-properties">
            <xsl:if test="表:对齐格式">
                <xsl:if test="表:对齐格式/表:垂直对齐方式">
                    <xsl:variable name="vertical-align">
                        <xsl:choose>
                            <xsl:when test="表:对齐格式/表:垂直对齐方式 = 'top'">top</xsl:when>
                            <xsl:when test="表:对齐格式/表:垂直对齐方式 = 'center'">center</xsl:when>
                            <xsl:when test="表:对齐格式/表:垂直对齐方式 = 'bottom'">bottom</xsl:when>
                            <xsl:otherwise>middle</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="style:vertical-align"><xsl:value-of select="$vertical-align"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="表:对齐格式/表:自动换行/@表:值 = 'true'">
                    <xsl:attribute name="fo:wrap-option">wrap</xsl:attribute>
                </xsl:if>
                <xsl:if test="表:对齐格式/表:缩进">
                    <xsl:attribute name="fo:padding-left"><xsl:variable name="indent" select="表:对齐格式/表:缩进 * 10"/><xsl:call-template name="convert2cm"><xsl:with-param name="value" select="concat($indent,'pt')"/></xsl:call-template><xsl:text>cm</xsl:text></xsl:attribute>
                </xsl:if>
                <xsl:if test="表:对齐格式/表:文字旋转角度">
                    <xsl:attribute name="style:rotation-angle"><xsl:choose><xsl:when test="表:对齐格式/表:文字旋转角度 &lt; 0"><xsl:value-of select="360 - 表:对齐格式/表:文字旋转角度"/></xsl:when><xsl:otherwise><xsl:value-of select="表:对齐格式/表:文字旋转角度"/></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="style:rotation-align">none</xsl:attribute>
                </xsl:if>
                <xsl:if test="表:对齐格式/表:文字方向 = 'vertical'">
                    <xsl:attribute name="style:direction">ttb</xsl:attribute>
                    <xsl:if test="not(表:对齐格式/字:水平对齐方式)">
                        <xsl:attribute name="style:text-align-source">fix</xsl:attribute>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
            <!--xsl:if test="表:边框">
                <xsl:apply-templates select="表:边框" />
            </xsl:if-->
            <!--chenjh add 边框 again-->
            <xsl:if test="表:边框/uof:上/@uof:宽度 !=''">
                <xsl:variable name="top-line-width" select="concat(表:边框/uof:上/@uof:宽度,$uofUnit)"/>
                <xsl:variable name="top-line-tyle">
                    <xsl:choose>
                        <xsl:when test="表:边框/uof:上/@uof:类型='single'">solid</xsl:when>
                        <xsl:when test="表:边框/uof:上/@uof:类型='double'">double</xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="top-line-color" select="表:边框/uof:上/@uof:颜色"/>
                <xsl:variable name="border-top" select="concat($top-line-width,' ',$top-line-tyle,' ',$top-line-color)"/>
                <xsl:attribute name="fo:border-top"><xsl:value-of select="$border-top"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="表:边框/uof:下/@uof:宽度 !=''">
                <xsl:variable name="bottom-line-width" select="concat(表:边框/uof:下/@uof:宽度,$uofUnit)"/>
                <xsl:variable name="bottom-line-tyle">
                    <xsl:choose>
                        <xsl:when test="表:边框/uof:下/@uof:类型='single'">solid</xsl:when>
                        <xsl:when test="表:边框/uof:下/@uof:类型='double'">double</xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="bottom-line-color" select="表:边框/uof:下/@uof:颜色"/>
                <xsl:variable name="border-bottom" select="concat($bottom-line-width,' ',$bottom-line-tyle,' ',$bottom-line-color)"/>
                <xsl:attribute name="fo:border-bottom"><xsl:value-of select="$border-bottom"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="表:边框/uof:左/@uof:宽度 !=''">
                <xsl:variable name="left-line-width" select="concat(表:边框/uof:左/@uof:宽度,$uofUnit)"/>
                <xsl:variable name="left-line-tyle">
                    <xsl:choose>
                        <xsl:when test="表:边框/uof:左/@uof:类型='single'">solid</xsl:when>
                        <xsl:when test="表:边框/uof:左/@uof:类型='double'">double</xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="left-line-color" select="表:边框/uof:左/@uof:颜色"/>
                <xsl:variable name="border-left" select="concat($left-line-width,' ',$left-line-tyle,' ',$left-line-color)"/>
                <xsl:attribute name="fo:border-left"><xsl:value-of select="$border-left"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="表:边框/uof:右/@uof:宽度 !=''">
                <xsl:variable name="right-line-width" select="concat(表:边框/uof:右/@uof:宽度,$uofUnit)"/>
                <xsl:variable name="right-line-tyle">
                    <xsl:choose>
                        <xsl:when test="@uof:类型 = 'none'">none</xsl:when>
                        <xsl:when test="@uof:类型 = 'continuous'">solid</xsl:when>
                        <xsl:when test="@uof:类型 = 'double'">double</xsl:when>
                        <xsl:otherwise>solid</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="right-line-color" select="表:边框/uof:右/@uof:颜色"/>
                <xsl:variable name="border-right" select="concat($right-line-width,' ',$right-line-tyle,' ',$right-line-color)"/>
                <xsl:attribute name="fo:border-right"><xsl:value-of select="$border-right"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="表:边框/uof:对角线1/@uof:宽度 !=''">
                <xsl:variable name="diagonal-lr-width" select="concat(表:边框/uof:对角线1/@uof:宽度,$uofUnit)"/>
                <xsl:variable name="diagonal-lr-tyle">
                    <xsl:choose>
                        <xsl:when test="表:边框/uof:对角线1/@uof:类型 = 'none'">none</xsl:when>
                        <xsl:when test="表:边框/uof:对角线1/@uof:类型 = 'continuous'">solid</xsl:when>
                        <xsl:when test="表:边框/uof:对角线1/@uof:类型 = 'double'">double</xsl:when>
                        <xsl:otherwise>solid</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="diagonal-lr-color" select="表:边框/uof:对角线1/@uof:颜色"/>
                <xsl:variable name="border-diagonal" select="concat($diagonal-lr-width,' ',$diagonal-lr-tyle,' ',$diagonal-lr-color)"/>
                <xsl:attribute name="style:diagonal-bl-tr"><xsl:value-of select="$border-diagonal"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="表:边框/uof:对角线2/@uof:宽度 !=''">
                <xsl:variable name="diagonal-rl-width" select="concat(表:边框/uof:对角线2/@uof:宽度,$uofUnit)"/>
                <xsl:variable name="diagonal-rl-tyle">
                    <xsl:choose>
                        <xsl:when test="表:边框/uof:对角线1/@uof:类型 = 'none'">none</xsl:when>
                        <xsl:when test="表:边框/uof:对角线1/@uof:类型 = 'continuous'">solid</xsl:when>
                        <xsl:when test="表:边框/uof:对角线1/@uof:类型 = 'double'">double</xsl:when>
                        <xsl:otherwise>solid</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="diagonal-rl-color" select="表:边框/uof:对角线2/@uof:颜色"/>
                <xsl:variable name="border-diagonal" select="concat($diagonal-rl-width,' ',$diagonal-rl-tyle,' ',$diagonal-rl-color)"/>
                <xsl:attribute name="style:diagonal-tl-br"><xsl:value-of select="$border-diagonal"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="表:边框/*/@uof:阴影">
                <xsl:choose>
                    <xsl:when test="表:边框/uof:下/@uof:阴影 and 表:边框/uof:右/@uof:阴影">
                        <xsl:attribute name="style:shadow">#808080 0.18cm 0.18cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="表:边框/uof:下/@uof:阴影 and 表:边框/uof:左/@uof:阴影">
                        <xsl:attribute name="style:shadow">#808080 -0.18cm 0.18cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="表:边框/uof:上/@uof:阴影 and 表:边框/uof:右/@uof:阴影">
                        <xsl:attribute name="style:shadow">#808080 0.18cm -0.18cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="表:边框/uof:上/@uof:阴影 and 表:边框/uof:左/@uof:阴影">
                        <xsl:attribute name="style:shadow">#808080 -0.18cm -0.18cm</xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <!--边框 end -->
            <xsl:if test="表:填充">
                <xsl:choose>
                    <xsl:when test="表:填充/图:颜色">
                        <xsl:attribute name="fo:background-color"><xsl:value-of select="表:填充/图:颜色"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="表:填充/图:图案/@图:前景色">
                            <xsl:variable name="pattern-value">
                                <xsl:call-template name="cell-pattern-color">
                                    <xsl:with-param name="pattern" select="concat('0.',substring-after(表:填充/图:图案/图:背景色,'y'))"/>
                                    <xsl:with-param name="color-value" select="表:填充/图:颜色"/>
                                    <xsl:with-param name="pattern-color-value" select="表:填充/图:图案/图:背景色"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:attribute name="fo:background-color"><xsl:value-of select="$pattern-value"/></xsl:attribute>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="表:字体格式/字:隐藏文字">
                <xsl:choose>
                    <xsl:when test="表:字体格式/字:隐藏文字 = 'true'">
                        <xsl:attribute name="style:cell-protect">protected formula-hidden</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style:cell-protect">none</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:attribute name="style:cell-protect">none</xsl:attribute>
            <xsl:attribute name="style:text-align-source">fix</xsl:attribute>
        </xsl:element>
        <xsl:element name="style:paragraph-properties">
            <xsl:if test="表:对齐格式/表:水平对齐方式">
                <xsl:variable name="text-align">
                    <xsl:choose>
                        <xsl:when test="表:对齐格式/表:水平对齐方式 = 'left'">start</xsl:when>
                        <xsl:when test="表:对齐格式/表:水平对齐方式 = 'center'">center</xsl:when>
                        <xsl:when test="表:对齐格式/表:水平对齐方式 = 'right'">end</xsl:when>
                        <xsl:when test="表:对齐格式/表:水平对齐方式 = 'justify'">justify</xsl:when>
                        <xsl:otherwise>start</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="fo:text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
            </xsl:if>
        </xsl:element>
        <xsl:element name="style:text-properties">
            <xsl:if test="表:字体格式/字:字体">
                <xsl:choose>
                    <xsl:when test="(表:字体格式/字:字体/@字:中文字体引用)or (表:字体格式/字:字体/@字:西文字体引用)">
                        <xsl:variable name="fontnameZ" select="表:字体格式/字:字体/@字:中文字体引用"/>
                        <xsl:variable name="fontnameX" select="表:字体格式/字:字体/@字:西文字体引用"/>
                        <xsl:for-each select="/uof:UOF/uof:式样集/uof:字体集/uof:字体声明">
                            <xsl:if test="(./@uof:标识符 = $fontnameZ)or(./@uof:标识符 = $fontnameX)">
                                <xsl:attribute name="style:font-name"><xsl:value-of select="./@uof:名称"/></xsl:attribute>
                                <xsl:attribute name="style:font-name-asian"><xsl:value-of select="./@uof:名称"/></xsl:attribute>
                                <xsl:attribute name="style:font-name-complex"><xsl:value-of select="./@uof:名称"/></xsl:attribute>
                                <xsl:attribute name="style:font-charset"><xsl:value-of select="./@uof:字体族"/></xsl:attribute>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style:font-name">Arial</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="表:字体格式/字:粗体/@字:值">
                    <xsl:attribute name="fo:font-weight"><xsl:choose><xsl:when test="表:字体格式/字:粗体/@字:值=1 or 表:字体格式/字:粗体/@字:值='true'">bold</xsl:when><xsl:when test="表:字体格式/字:粗体/@字:值=0 or 表:字体格式/字:粗体/@字:值='false'">normal</xsl:when></xsl:choose></xsl:attribute>
                    <xsl:attribute name="style:font-weight-asian"><xsl:choose><xsl:when test="表:字体格式/字:粗体/@字:值=1 or 表:字体格式/字:粗体/@字:值='true'">bold</xsl:when><xsl:when test="表:字体格式/字:粗体/@字:值=0 or 表:字体格式/字:粗体/@字:值='false'">normal</xsl:when></xsl:choose></xsl:attribute>
                    <xsl:attribute name="style:font-weight-complex"><xsl:choose><xsl:when test="表:字体格式/字:粗体/@字:值=1 or 表:字体格式/字:粗体/@字:值='true'">bold</xsl:when><xsl:when test="表:字体格式/字:粗体/@字:值=0 or 表:字体格式/字:粗体/@字:值='false'">normal</xsl:when></xsl:choose></xsl:attribute>
                </xsl:if>
                <xsl:if test="表:字体格式/字:斜体/@字:值">
                    <xsl:attribute name="fo:font-style"><xsl:choose><xsl:when test="表:字体格式/字:斜体/@字:值=1 or 表:字体格式/字:斜体/@字:值='true'">italic</xsl:when><xsl:when test="表:字体格式/字:斜体/@字:值=0 or 表:字体格式/字:斜体/@字:值='false'">normal</xsl:when></xsl:choose></xsl:attribute>
                    <xsl:attribute name="style:font-style-asian"><xsl:choose><xsl:when test="表:字体格式/字:斜体/@字:值=1 or 表:字体格式/字:斜体/@字:值='true'">italic</xsl:when><xsl:when test="表:字体格式/字:斜体/@字:值=0 or 表:字体格式/字:斜体/@字:值='false'">normal</xsl:when></xsl:choose></xsl:attribute>
                    <xsl:attribute name="style:font-style-complex"><xsl:choose><xsl:when test="表:字体格式/字:斜体/@字:值=1 or 表:字体格式/字:斜体/@字:值='true'">italic</xsl:when><xsl:when test="表:字体格式/字:斜体/@字:值=0 or 表:字体格式/字:斜体/@字:值='false'">normal</xsl:when></xsl:choose></xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="表:字体格式/字:字体/@字:颜色">
                        <xsl:attribute name="fo:color"><xsl:value-of select="表:字体格式/字:字体/@字:颜色"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style:use-window-font-color">true</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="表:字体格式/字:字体/@字:字号">
                        <xsl:attribute name="fo:font-size"><xsl:value-of select="concat( 表:字体格式/字:字体/@字:字号, 'pt')"/></xsl:attribute>
                        <xsl:attribute name="style:font-size-asian"><xsl:value-of select="concat( 表:字体格式/字:字体/@字:字号, 'pt')"/></xsl:attribute>
                        <xsl:attribute name="style:font-size-complex"><xsl:value-of select="concat( 表:字体格式/字:字体/@字:字号, 'pt')"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="fo:font-size">12pt</xsl:attribute>
                        <xsl:attribute name="style:font-size-asian">12pt</xsl:attribute>
                        <xsl:attribute name="style:font-size-complex">12pt</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="表:字体格式/字:浮雕">
                    <xsl:variable name="aa">
                        <xsl:value-of select="表:字体格式/字:浮雕/@字:类型"/>
                    </xsl:variable>
                    <xsl:attribute name="style:font-relief"><xsl:choose><xsl:when test="$aa='emboss'">embossed</xsl:when><xsl:when test="$aa='engrave'">engraved</xsl:when></xsl:choose></xsl:attribute>
                </xsl:if>
                <xsl:if test="表:字体格式/字:阴影/@字:值 = '1' or 表:字体格式/字:阴影/@字:值 = 'true'">
                    <xsl:attribute name="fo:text-shadow">1pt 1pt</xsl:attribute>
                </xsl:if>
                <xsl:if test="表:字体格式/字:删除线">
                    <xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="表:字体格式/字:删除线/@字:类型='double'">
                            <xsl:attribute name="style:text-line-through-type">double</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="表:字体格式/字:删除线/@字:类型='single'">
                            <xsl:attribute name="style:text-underline-mode">continuous</xsl:attribute>
                            <xsl:attribute name="style:text-line-through-mode">continuous</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="表:字体格式/字:删除线/@字:类型='bold'">
                            <xsl:attribute name="style:text-line-through-width">bold</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="表:字体格式/字:删除线/@字:类型='带/'">
                            <xsl:attribute name="style:text-line-through-text">/</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="表:字体格式/字:删除线/@字:类型='带X'">
                            <xsl:attribute name="style:text-line-through-text">X</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="表:字体格式/字:下划线">
                    <xsl:apply-templates select="表:字体格式/字:下划线"/>
                </xsl:if>
            </xsl:if>
            <xsl:if test="表:字体格式/字:着重号">
                <xsl:apply-templates select="表:字体格式/字:着重号"/>
            </xsl:if>
            <xsl:if test="表:字体格式/字:空心/@字:值='true'">
                <xsl:attribute name="style:text-outline">true</xsl:attribute>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="单元格具体式样">
        <xsl:choose>
            <xsl:when test="@表:类型 = 'Default'">
                <xsl:element name="style:default-style">
                    <xsl:call-template name="style-style-content"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name"><xsl:value-of select="@表:标识符"/></xsl:attribute>
                    <xsl:if test="表:数字格式/@表:格式码 = 'general'">
                        <xsl:attribute name="style:parent-style-name">Default</xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="style:parent-style-name">Default</xsl:attribute>
                    <xsl:attribute name="style:data-style-name"><xsl:value-of select="concat( @表:标识符, 'F')"/></xsl:attribute>
                    <!--chengxz这里要改 -->
                    <!--xsl:attribute name="style:data-style-name"><xsl:value-of select="'N2'"/></xsl:attribute-->
                    <xsl:call-template name="style-style-content"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="表:边框">
        <!--chengxz 0622-->
        <xsl:if test="not(uof:下)">
            <xsl:attribute name="fo:border-bottom">none</xsl:attribute>
        </xsl:if>
        <xsl:if test="not(uof:上)">
            <xsl:attribute name="fo:border-top">none</xsl:attribute>
        </xsl:if>
        <xsl:if test="not(uof:左)">
            <xsl:attribute name="fo:border-left">none</xsl:attribute>
        </xsl:if>
        <xsl:if test="not(uof:右)">
            <xsl:attribute name="fo:border-right">none</xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="uof:对角线1"/>
        <xsl:apply-templates select="uof:对角线2"/>
        <xsl:apply-templates select="uof:上"/>
        <xsl:apply-templates select="uof:下"/>
        <xsl:apply-templates select="uof:左"/>
        <xsl:apply-templates select="uof:右"/>
    </xsl:template>
    <xsl:template match="uof:上">
        <xsl:variable name="bordtype">
            <xsl:choose>
                <xsl:when test="@uof:类型 = 'none'">none</xsl:when>
                <xsl:when test="@uof:类型 = 'continuous'">solid</xsl:when>
                <xsl:when test="@uof:类型 = 'double'">double</xsl:when>
                <!-- Dash, Dot, DashDot, DashDotDot, SlantDashDot are not supported yet -->
                <xsl:otherwise>solid</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="fo:border-top"><xsl:value-of select="concat(@uof:宽度 div 30,$uofUnit, ' ',$bordtype, ' ', @uof:颜色)"/></xsl:attribute>
        <xsl:if test="@uof:类型 = 'double'">
            <xsl:attribute name="style:border-line-width-top">0.035cm 0.035cm 0.035cm</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="uof:下">
        <xsl:variable name="bordtype">
            <xsl:choose>
                <xsl:when test="@uof:类型 = 'none'">none</xsl:when>
                <xsl:when test="@uof:类型 = 'continuous'">solid</xsl:when>
                <xsl:when test="@uof:类型 = 'double'">double</xsl:when>
                <!-- Dash, Dot, DashDot, DashDotDot, SlantDashDot are not supported yet -->
                <xsl:otherwise>solid</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="fo:border-bottom"><xsl:value-of select="concat(@uof:宽度 div 30, $uofUnit,' ',$bordtype, ' ',@uof:颜色)"/></xsl:attribute>
        <xsl:if test="@uof:类型 = 'double'">
            <xsl:attribute name="style:border-line-width-bottom">0.035cm 0.035cm 0.035cm</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="uof:左">
        <xsl:variable name="bordtype">
            <xsl:choose>
                <xsl:when test="@uof:类型 = 'none'">none</xsl:when>
                <xsl:when test="@uof:类型 = 'continuous'">solid</xsl:when>
                <xsl:when test="@uof:类型 = 'double'">double</xsl:when>
                <!-- Dash, Dot, DashDot, DashDotDot, SlantDashDot are not supported yet -->
                <xsl:otherwise>solid</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="fo:border-left"><xsl:value-of select="concat(@uof:宽度 div 30,$uofUnit, ' ',$bordtype, ' ', @uof:颜色)"/></xsl:attribute>
        <xsl:if test="@uof:类型 = 'double'">
            <xsl:attribute name="style:border-line-width-left">0.035cm 0.035cm 0.035cm</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="uof:右">
        <xsl:variable name="bordtype">
            <xsl:choose>
                <xsl:when test="@uof:类型 = 'none'">none</xsl:when>
                <xsl:when test="@uof:类型 = 'continuous'">solid</xsl:when>
                <xsl:when test="@uof:类型 = 'double'">double</xsl:when>
                <!-- Dash, Dot, DashDot, DashDotDot, SlantDashDot are not supported yet -->
                <xsl:otherwise>solid</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="fo:border-right"><xsl:value-of select="concat( @uof:宽度 div 30, $uofUnit,' ',$bordtype, ' ', @uof:颜色)"/></xsl:attribute>
        <xsl:if test="@uof:类型 = 'double'">
            <xsl:attribute name="style:border-line-width-right">0.035cm 0.035cm 0.035cm</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="uof:对角线1">
        <xsl:variable name="bordtype">
            <xsl:choose>
                <xsl:when test="@uof:类型 = 'none'">none</xsl:when>
                <xsl:when test="@uof:类型 = 'continuous'">solid</xsl:when>
                <xsl:when test="@uof:类型 = 'double'">double</xsl:when>
                <!-- Dash, Dot, DashDot, DashDotDot, SlantDashDot are not supported yet -->
                <xsl:otherwise>solid</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="style:diagonal-bl-tr"><xsl:value-of select="concat( @uof:宽度 div 30, $uofUnit,' ',$bordtype, ' ', @uof:颜色)"/></xsl:attribute>
        <xsl:if test="@uof:类型 = 'double'">
            <xsl:attribute name="style:diagonal-bl-tr-width">0.035cm 0.035cm 0.035cm</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="uof:对角线2">
        <xsl:variable name="bordtype">
            <xsl:choose>
                <xsl:when test="@uof:类型 = 'none'">none</xsl:when>
                <xsl:when test="@uof:类型 = 'continuous'">solid</xsl:when>
                <xsl:when test="@uof:类型 = 'double'">double</xsl:when>
                <!-- Dash, Dot, DashDot, DashDotDot, SlantDashDot are not supported yet -->
                <xsl:otherwise>solid</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="style:diagonal-tl-br"><xsl:value-of select="concat( @uof:宽度 div 30, $uofUnit,' ',$bordtype, ' ', @uof:颜色)"/></xsl:attribute>
        <xsl:if test="@uof:类型 = 'double'">
            <xsl:attribute name="style:diagonal-tl-br-width">0.035cm 0.035cm 0.035cm</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="表:字体格式">
        <xsl:choose>
            <xsl:when test="字:上下标/@字:上下标 = 'sup'">
                <style:style style:name="{concat(../@表:标识符,'T0')}" style:family="text">
                    <style:text-properties style:text-position="33% 58%"/>
                </style:style>
            </xsl:when>
            <xsl:when test="字:上下标/@字:上下标 = 'sub'">
                <style:style style:name="{concat(../@表:标识符,'T0')}" style:family="text">
                    <style:text-properties style:text-position="-33% 58%"/>
                </style:style>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="tablecolumngroup">
        <xsl:param name="start"/>
        <xsl:param name="end"/>
        <xsl:param name="prestart"/>
        <xsl:param name="preend"/>
        <xsl:param name="nextstart"/>
        <xsl:param name="nextend"/>
        <table:table-column-group>
            <table:table-column>
                <xsl:attribute name="table:style-name">co1</xsl:attribute>
                <xsl:attribute name="table:table-column-repeated"><xsl:value-of select="@表:终止 - @表:起始 + 1"/></xsl:attribute>
            </table:table-column>
            <xsl:if test="$nextstart &gt;= $start and $nextend &lt;= $end">
                <xsl:for-each select="following-sibling::表:列[1]">
                    <xsl:call-template name="tablecolumngroup"/>
                </xsl:for-each>
            </xsl:if>
        </table:table-column-group>
    </xsl:template>
    <xsl:template match="表:工作表">
        <xsl:variable name="rowpath" select="表:工作表内容/表:行"/>
        <xsl:variable name="colpath" select="表:工作表内容/表:列"/>
        <xsl:element name="table:table">
            <xsl:attribute name="table:name"><xsl:value-of select="@表:名称"/></xsl:attribute>
            <xsl:if test="表:工作表内容">
                <xsl:attribute name="table:style-name"><xsl:value-of select="concat( 'ta', count(preceding-sibling::表:工作表)+1)"/></xsl:attribute>
                <xsl:if test="(@表:隐藏 = '1')or(@表:隐藏 = 'true')">
                    <xsl:attribute name="table:protected">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="表:工作表内容/uof:锚点 or 表:工作表内容/表:图表">
                    <table:shapes>
                        <xsl:apply-templates select="表:工作表内容/uof:锚点"/>
                        <xsl:apply-templates select="表:工作表内容/表:图表">
                            <xsl:with-param name="table-name" select="@表:名称"/>
                        </xsl:apply-templates>
                    </table:shapes>
                </xsl:if>
                <xsl:variable name="table-pos">
                    <xsl:value-of select="count(../preceding-sibling::表:工作表)+1"/>
                </xsl:variable>
                <xsl:if test="表:工作表内容/表:分组集/表:列">
                    <xsl:for-each select="表:工作表内容/表:分组集/表:列">
                        <xsl:variable name="start" select="@表:起始"/>
                        <xsl:variable name="end" select="@表:终止"/>
                        <xsl:variable name="prestart" select="preceding-sibling::表:列/@表:起始"/>
                        <xsl:variable name="preend" select="preceding-sibling::表:列/@表:终止"/>
                        <xsl:variable name="nextstart" select="following-sibling::表:列/@表:起始"/>
                        <xsl:variable name="nextend" select="following-sibling::表:列/@表:终止"/>
                            <xsl:call-template name="tablecolumngroup">
                                <xsl:with-param name="start" select="$start"/>
                                <xsl:with-param name="end" select="$end"/>
                                <xsl:with-param name="prestart" select="$prestart"/>
                                <xsl:with-param name="preend" select="$preend"/>
                                <xsl:with-param name="nextstart" select="$nextstart"/>
                                <xsl:with-param name="nextend" select="$nextend"/>
                            </xsl:call-template>
                    </xsl:for-each>
                </xsl:if>
                <xsl:for-each select="表:工作表内容/表:列">
                    <table:table-column>
                        <xsl:attribute name="table:style-name"><xsl:value-of select="@表:式样引用"/></xsl:attribute>
                        <xsl:if test="@表:跨度 and not(@表:跨度='1')">
                            <xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="@表:跨度"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@表:隐藏">
                            <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                        </xsl:if>
                    </table:table-column>
                </xsl:for-each>
                <xsl:variable name="condition-pos-str1">
                    <xsl:if test="../../表:公用处理规则/表:条件格式化集/表:条件格式化">
                        <xsl:call-template name="condition-row-column-string">
                            <xsl:with-param name="last" select="''"/>
                            <xsl:with-param name="total" select="count(../../表:公用处理规则/表:条件格式化集/表:条件格式化)"/>
                            <xsl:with-param name="index" select="1"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="condition-pos-str2">
                    <xsl:if test="../../表:公用处理规则/表:数据有效性集/表:数据有效性">
                        <xsl:call-template name="validation-row-column-string">
                            <xsl:with-param name="last" select="''"/>
                            <xsl:with-param name="total" select="count(../../表:公用处理规则/表:数据有效性集/表:数据有效性)"/>
                            <xsl:with-param name="index" select="1"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="condition-pos-str" select="concat($condition-pos-str1, $condition-pos-str2)"/>
                <xsl:choose>
                    <xsl:when test="./表:工作表内容/表:行">
                        <xsl:call-template name="create-rows">
                            <xsl:with-param name="lastrowpos" select="0"/>
                            <xsl:with-param name="row-count" select="count(表:工作表内容/表:行)"/>
                            <xsl:with-param name="currentRow" select="1"/>
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="tableHasStyle">
                            <xsl:choose>
                                <xsl:when test="./表:工作表内容[@表:式样引用]">
                                    <xsl:value-of select="1"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="0"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="./表:分页符集/表:分页符[@表:行号]">
                                <xsl:for-each select="./表:分页符集/表:分页符[@表:行号]">
                                    <xsl:variable name="number-repeated">
                                        <xsl:choose>
                                            <xsl:when test="position() = 1">
                                                <xsl:value-of select="./@表:行号"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="./@表:行号 - preceding::表:分页符[@表:行号 and (position()=count(.))]/@表:行号 - 1"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:if test="$number-repeated &gt; 0">
                                        <xsl:element name="table:table-row">
                                            <xsl:if test="($rowpath/@表:隐藏 = '1') or  ($rowpath/@表:隐藏 = 'true')">
                                                <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                                            </xsl:if>
                                            <xsl:attribute name="table:style-name"><xsl:value-of select="concat('ro',$table-pos)"/></xsl:attribute>
                                            <xsl:attribute name="table:number-rows-repeated"><xsl:value-of select="$number-repeated"/></xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="$tableHasStyle = 1">
                                                    <table:table-cell table:number-columns-repeated="256"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <table:table-cell/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="table:table-row">
                                        <xsl:if test="($colpath/@表:隐藏 = '1') or  ($colpath/@表:隐藏 = 'true')">
                                            <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                                        </xsl:if>
                                        <xsl:attribute name="table:style-name"><xsl:value-of select="concat('rob',$table-pos)"/></xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="$tableHasStyle = 1">
                                                <table:table-cell table:number-columns-repeated="256"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <table:table-cell/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="table:table-row">
                                    <xsl:choose>
                                        <xsl:when test="表:工作表内容/@表:式样引用">
                                            <xsl:attribute name="table:style-name"><xsl:value-of select="表:工作表内容/@表:式样引用"/></xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="table:style-name"><xsl:text>ro1</xsl:text></xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:element name="table:table-cell"/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="../../表:公用处理规则/表:条件格式化集/表:条件格式化">
                            <xsl:variable name="condition-row-max">
                                <xsl:call-template name="condition-row-col-pos-max">
                                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                    <xsl:with-param name="last-value" select="0"/>
                                    <xsl:with-param name="div-value" select="'R'"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="condition-col-max">
                                <xsl:call-template name="condition-row-col-pos-max">
                                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                    <xsl:with-param name="last-value" select="0"/>
                                    <xsl:with-param name="div-value" select="'C'"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="break-row-max">
                                <xsl:call-template name="break-row-beyond-max">
                                    <xsl:with-param name="pos" select="1"/>
                                    <xsl:with-param name="last-value" select="0"/>
                                    <xsl:with-param name="count-value" select="count(./表:分页符集/表:分页符[@表:行号])"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="end-value">
                                <xsl:choose>
                                    <xsl:when test="$condition-row-max &lt; $break-row-max">
                                        <xsl:value-of select="$break-row-max"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$condition-row-max"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:call-template name="get-row-beyond-last">
                                <xsl:with-param name="index-value" select="1"/>
                                <xsl:with-param name="worksheetNo" select="count(preceding-sibling::表:工作表)+1"/>
                                <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                <xsl:with-param name="end-pos" select="$end-value"/>
                                <xsl:with-param name="total-col" select="$condition-col-max"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="./表:工作表内容/@表:式样引用">
                            <table:table-row table:style-name="ro1" table:number-rows-repeated="32000">
                                <table:table-cell table:number-columns-repeated="256"/>
                            </table:table-row>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:element>
        <xsl:if test="表:图表">
            <table:shapes>
                <xsl:apply-templates select="表:图表">
                    <xsl:with-param name="table-name" select="@表:名称"/>
                </xsl:apply-templates>
            </table:shapes>
        </xsl:if>
    </xsl:template>
    <!--xsl:template name="create-columns-without-input"></xsl:template>
    <xsl:template name="create-columns"></xsl:template>
    <xsl:template name="condition-row-column-string"></xsl:template>
<xsl:template name="validation-row-column-string"></xsl:template>
<xsl:template name="create-rows"></xsl:template>
<xsl:template name="condition-row-col-pos-max"></xsl:template>
<xsl:template name="get-row-beyond-last"></xsl:template-->
    <!--xsl:template name="break-row-beyond-max"></xsl:template-->
    <!-- chengxz有问题-->
    <xsl:template name="create-columns-without-input">
        <xsl:param name="table-pos"/>
        <xsl:variable name="rowpath" select="表:工作表内容/表:行"/>
        <xsl:variable name="colpath" select="表:工作表内容/表:列"/>
        <xsl:choose>
            <xsl:when test="./表:分页符集/表:分页符[@表:列号]">
                <xsl:for-each select="./表:分页符集/表:分页符[@表:列号]">
                    <xsl:variable name="number-repeated">
                        <xsl:choose>
                            <xsl:when test="position() = 1">
                                <xsl:value-of select="./@表:列号"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="./@表:列号 - preceding::表:分页符[@表:列号 and (position()=count(.))]/@表:列号 - 1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$number-repeated &gt; 0">
                        <xsl:element name="table:table-column">
                            <xsl:if test="ancestor::表:工作表/表:工作表内容/@表:式样引用">
                                <xsl:attribute name="table:default-cell-style-name"><xsl:value-of select="ancestor::表:工作表/表:工作表内容/@表:式样引用"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="($colpath/@表:隐藏 = '1') or  ($colpath/@表:隐藏 = 'true')">
                                <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                            </xsl:if>
                            <xsl:attribute name="table:style-name"><xsl:value-of select="concat('co',$table-pos)"/></xsl:attribute>
                            <xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="$number-repeated"/></xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="table:table-column">
                        <xsl:if test="ancestor::表:工作表/表:工作表内容/@表:式样引用">
                            <xsl:attribute name="table:default-cell-style-name"><xsl:value-of select="ancestor::表:工作表/表:工作表内容/@表:式样引用"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="($colpath/@表:隐藏 = '1') or  ($colpath/@表:隐藏 = 'true')">
                            <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="table:style-name"><xsl:value-of select="concat('cob',$table-pos)"/></xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="table:table-column">
                    <xsl:choose>
                        <xsl:when test="表:工作表内容/@表:式样引用">
                            <xsl:attribute name="table:style-name"><xsl:value-of select="表:工作表内容/@表:式样引用"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="table:style-name"><xsl:text>co1</xsl:text></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="表:工作表内容/@表:最大列 and 表:工作表内容/@表:最大列 > 0">
                        <xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="表:工作表内容/@表:最大列"/></xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="table:default-cell-style-name"><xsl:text>Default</xsl:text></xsl:attribute>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="create-columns">
        <xsl:param name="columnCount"/>
        <xsl:param name="currentColumn" select="1"/>
        <xsl:param name="finishedColumns" select="0"/>
        <xsl:param name="worksheetNo" select="count(preceding-sibling::表:工作表)+1"/>
        <xsl:param name="currentColumnNode"/>
        <xsl:choose>
            <xsl:when test="$finishedColumns &lt; $columnCount">
                <xsl:choose>
                    <xsl:when test="$currentColumnNode">
                        <xsl:choose>
                            <xsl:when test="$currentColumnNode/@表:列号 - $finishedColumns  &gt; 1">
                                <xsl:call-template name="create-default-column">
                                    <xsl:with-param name="currentColumn" select="$currentColumn"/>
                                    <xsl:with-param name="currentColumnNode" select="$currentColumnNode"/>
                                    <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                                </xsl:call-template>
                                <xsl:call-template name="create-columns">
                                    <xsl:with-param name="columnCount" select="$columnCount"/>
                                    <xsl:with-param name="currentColumn" select="$currentColumn"/>
                                    <xsl:with-param name="currentColumnNode" select="$currentColumnNode"/>
                                    <xsl:with-param name="finishedColumns" select="$finishedColumns + 1"/>
                                    <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="table:table-column">
                                    <xsl:if test="($currentColumnNode/@表:隐藏 = '1') or  ($currentColumnNode/@表:隐藏 = 'true')">
                                        <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="$currentColumnNode/@表:跨度">
                                        <xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="$currentColumnNode/@表:跨度 + 1"/></xsl:attribute>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when test="key('ColBreak', $currentColumn)">
                                            <xsl:attribute name="table:style-name"><xsl:value-of select="concat('cob', $worksheetNo, '-', $currentColumn)"/></xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="table:style-name"><xsl:value-of select="concat('co', $worksheetNo, '-', $currentColumn)"/></xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:call-template name="create-columns">
                                    <xsl:with-param name="columnCount" select="$columnCount"/>
                                    <xsl:with-param name="currentColumn" select="$currentColumn + 1"/>
                                    <xsl:with-param name="finishedColumns" select="$finishedColumns + 1"/>
                                    <xsl:with-param name="currentColumnNode" select="表:工作表属性/表:列[$currentColumn + 1]"/>
                                    <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="create-default-column">
                            <xsl:with-param name="currentColumn" select="$currentColumn"/>
                            <xsl:with-param name="currentColumnNode" select="$currentColumnNode"/>
                            <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                        </xsl:call-template>
                        <xsl:call-template name="create-columns">
                            <xsl:with-param name="columnCount" select="$columnCount"/>
                            <xsl:with-param name="currentColumn" select="$currentColumn"/>
                            <xsl:with-param name="finishedColumns" select="$finishedColumns + 1"/>
                            <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$currentColumn = $columnCount">
                    <xsl:if test="表:分页符集/表:分页符/@表:列号 &gt; $finishedColumns">
                        <xsl:call-template name="get-column-beyond-last">
                            <xsl:with-param name="index-value" select="$finishedColumns"/>
                            <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-column-beyond-last">
        <xsl:param name="index-value"/>
        <xsl:param name="worksheetNo"/>
        <xsl:for-each select="表:分页符集/表:分页符[@表:列号]">
            <xsl:variable name="each-column-value" select="@表:列号"/>
            <xsl:choose>
                <xsl:when test="$each-column-value + 1 &gt; $index-value">
                    <xsl:variable name="number-repeated">
                        <xsl:choose>
                            <xsl:when test="preceding-sibling::表:分页符[@表:列号][position()=count(.)]/@表:列号 + 1 = $index-value">
                                <xsl:value-of select="$each-column-value - preceding-sibling::表:分页符[@表:列号  and (position()=count(.))]/@表:列号 - 1"/>
                            </xsl:when>
                            <xsl:when test="preceding-sibling::表:分页符[@表:列号 and (position()=count(.))]/@表:列号 + 1 &gt; $index-value">
                                <xsl:value-of select="$each-column-value - preceding-sibling::表:分页符[@表:列号][position()=count(.)]/@表:列号 - 1"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$each-column-value - $index-value + 1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$number-repeated &gt; 0">
                        <xsl:element name="table:table-column">
                            <xsl:attribute name="table:style-name"><xsl:value-of select="'co1'"/></xsl:attribute>
                            <xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="$number-repeated"/></xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="table:table-column">
                        <xsl:if test="../../表:工作表内容[@表:式样引用]">
                            <xsl:attribute name="table:default-cell-style-name"><xsl:value-of select="./表:工作表内容/@表:式样引用"/></xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="table:style-name"><xsl:value-of select="concat('cob',$worksheetNo)"/></xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="$each-column-value + 1 = $index-value">
                    <xsl:element name="table:table-column">
                        <xsl:if test="/../../表:工作表内容[@表:式样引用]">
                            <xsl:attribute name="table:default-cell-style-name"><xsl:value-of select="./../../表:工作表内容/@表:式样引用"/></xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="table:style-name"><xsl:value-of select="concat('cob',$worksheetNo)"/></xsl:attribute>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="condition-row-column-string">
        <xsl:param name="last"/>
        <xsl:param name="total"/>
        <xsl:param name="index"/>
        <xsl:variable name="table-pos" select="count(preceding-sibling::表:工作表)+1"/>
        <xsl:variable name="current">
            <xsl:call-template name="parse-range">
                <xsl:with-param name="range-value" select="../../表:公用处理规则/表:条件格式化集/表:条件格式化[position() = $index]/表:范围"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="current-value" select="concat('(c',$table-pos,'-',$index,':', $current,');')"/>
        <xsl:if test="$index &lt; $total">
            <xsl:call-template name="condition-row-column-string">
                <xsl:with-param name="last" select="concat($last, $current-value)"/>
                <xsl:with-param name="total" select="$total"/>
                <xsl:with-param name="index" select="$index + 1"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$index = $total">
            <xsl:value-of select="concat($last, $current-value)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="validation-row-column-string">
        <xsl:param name="last"/>
        <xsl:param name="total"/>
        <xsl:param name="index"/>
        <xsl:variable name="table-pos" select="count(preceding-sibling::表:工作表)+1"/>
        <xsl:variable name="current">
            <xsl:call-template name="parse-range">
                <xsl:with-param name="range-value" select="../../表:公用处理规则/表:数据有效性集/表:数据有效性[position() = $index]/表:范围"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="current-value" select="concat('(v',$index,':', $current,');')"/>
        <xsl:if test="$index &lt; $total">
            <xsl:call-template name="validation-row-column-string">
                <xsl:with-param name="last" select="concat($last, $current-value)"/>
                <xsl:with-param name="total" select="$total"/>
                <xsl:with-param name="index" select="$index + 1"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$index = $total">
            <xsl:value-of select="concat($last, $current-value)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="create-rows">
        <xsl:param name="lastrowpos"/>
        <xsl:param name="row-count"/>
        <xsl:param name="currentRow"/>
        <xsl:param name="condition-pos-str"/>
        <xsl:choose>
            <xsl:when test="$currentRow &lt; ($row-count + 1)">
                <xsl:variable name="span-value">
                    <xsl:choose>
                        <xsl:when test="./表:工作表内容/表:行[position() = $currentRow]/@表:行号">
                            <xsl:choose>
                                <xsl:when test="./表:工作表内容/表:行[position() = $currentRow]/@表:跨度">
                                    <xsl:value-of select="./表:工作表内容/表:行[position() = $currentRow]/@表:行号 - $lastrowpos + ./表:工作表内容/表:行[position() = $currentRow]/@表:跨度"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="./表:工作表内容/表:行[position() = $currentRow]/@表:行号 - $lastrowpos"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="./表:工作表内容/表:行[position() = $currentRow]/@表:跨度">
                                    <xsl:value-of select="./表:工作表内容/表:行[position() = $currentRow]/@表:跨度 + 1"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="1"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="current-index">
                    <xsl:choose>
                        <xsl:when test="./表:工作表内容/表:行[position() = $currentRow]/@表:行号">
                            <xsl:value-of select="./表:工作表内容/表:行[position() = $currentRow]/@表:行号"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$lastrowpos + 1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="./表:工作表内容/表:分组集/表:行">
                        <xsl:for-each select="./表:工作表内容/表:分组集/表:行[1]">
                            <xsl:call-template name="table:table-row-group"/>
                        </xsl:for-each>
                        <xsl:for-each select="./表:工作表内容/表:行[not(@表:行号)]">
                            <xsl:call-template name="create-row">
                                <xsl:with-param name="index-value" select="$lastrowpos"/>
                                <xsl:with-param name="span-value" select="$span-value"/>
                                <xsl:with-param name="worksheetNo" select="count(preceding-sibling::表:工作表)+1"/>
                                <xsl:with-param name="row-value" select="$currentRow"/>
                                <xsl:with-param name="times" select="1"/>
                                <xsl:with-param name="current-index" select="$current-index"/>
                                <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="./表:工作表内容/表:分组集 and ( ./表:工作表内容/表:分组集/表:行/@表:起始 &gt;= ($currentRow - 1) and ($currentRow - 1) &lt;= ./表:工作表内容/表:分组集/表:行/@表:终止 )">
                        <xsl:element name="table:table-row-group">
                            <xsl:variable name="TempStart">
                                <xsl:value-of select="./表:工作表内容/表:分组集/表:行/@表:起始"/>
                            </xsl:variable>
                            <xsl:variable name="TempEnd">
                                <xsl:value-of select="./表:工作表内容/表:分组集/表:行/@表:终止"/>
                            </xsl:variable>
                            <xsl:for-each select="./表:工作表内容/表:行">
                                <xsl:if test="$TempStart &gt;= ($currentRow - 1) and ($currentRow - 1) &lt;= $TempEnd">
                                    <xsl:call-template name="create-row">
                                        <xsl:with-param name="index-value" select="$lastrowpos"/>
                                        <xsl:with-param name="span-value" select="$span-value"/>
                                        <xsl:with-param name="worksheetNo" select="count(preceding-sibling::表:工作表)+1"/>
                                        <xsl:with-param name="row-value" select="$currentRow"/>
                                        <xsl:with-param name="times" select="1"/>
                                        <xsl:with-param name="current-index" select="$current-index"/>
                                        <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="create-row">
                            <xsl:with-param name="index-value" select="$lastrowpos"/>
                            <xsl:with-param name="span-value" select="$span-value"/>
                            <xsl:with-param name="worksheetNo" select="count(preceding-sibling::表:工作表)+1"/>
                            <xsl:with-param name="row-value" select="$currentRow"/>
                            <xsl:with-param name="times" select="1"/>
                            <xsl:with-param name="current-index" select="$current-index"/>
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                        </xsl:call-template>
                        <xsl:if test="$currentRow &lt; $row-count">
                            <xsl:call-template name="create-rows">
                                <xsl:with-param name="lastrowpos">
                                    <xsl:choose>
                                        <xsl:when test="./表:工作表内容/表:行[position() = $currentRow]/@表:行号">
                                            <xsl:choose>
                                                <xsl:when test="./表:工作表内容/表:行[position() = $currentRow]/@表:跨度">
                                                    <xsl:value-of select="./表:工作表内容/表:行[position() = $currentRow]/@表:行号 + ./表:工作表内容/表:行[position() = $currentRow]/@表:跨度"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="./表:工作表内容/表:行[position() = $currentRow]/@表:行号"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="./表:工作表内容/表:行[position() = $currentRow]/@表:跨度">
                                                    <xsl:value-of select="$lastrowpos + ./表:工作表内容/表:行[position() = $currentRow]/@表:跨度 + 1"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$lastrowpos + 1"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:with-param>
                                <xsl:with-param name="row-count" select="$row-count"/>
                                <xsl:with-param name="currentRow" select="$currentRow + 1"/>
                                <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$currentRow = $row-count">
                <xsl:variable name="last-pos">
                    <xsl:choose>
                        <xsl:when test="./表:工作表内容/表:行[position() = $currentRow]/@表:行号">
                            <xsl:choose>
                                <xsl:when test="./表:工作表内容/表:行[position() = $currentRow]/@表:跨度">
                                    <xsl:value-of select="./表:工作表内容/表:行[position() = $currentRow]/@表:行号 + ./表:工作表内容/表:行[position() = $currentRow]/@表:跨度"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="./表:工作表内容/表:行[position() = $currentRow]/@表:行号"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="./表:工作表内容/表:行[position() = $currentRow]/@表:跨度">
                                    <xsl:value-of select="$lastrowpos + ./表:工作表内容/表:行[position() = $currentRow]/@表:跨度 + 1"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$lastrowpos + 1"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="./表:分页符集/表:分页符/@表:行号 &gt; ($last-pos - 1) or ../../表:公用处理规则/表:条件格式化集/表:条件格式化">
                    <xsl:variable name="condition-row-max">
                        <xsl:call-template name="condition-row-col-pos-max">
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            <xsl:with-param name="last-value" select="0"/>
                            <xsl:with-param name="div-value" select="'R'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="condition-col-max">
                        <xsl:call-template name="condition-row-col-pos-max">
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            <xsl:with-param name="last-value" select="0"/>
                            <xsl:with-param name="div-value" select="'C'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="break-row-max">
                        <xsl:call-template name="break-row-beyond-max">
                            <xsl:with-param name="pos" select="1"/>
                            <xsl:with-param name="last-value" select="0"/>
                            <xsl:with-param name="count-value" select="count(./表:分页符集/表:分页符[@表:行号])"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="end-value">
                        <xsl:choose>
                            <xsl:when test="$condition-row-max &lt; $break-row-max">
                                <xsl:value-of select="$break-row-max"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$condition-row-max"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:call-template name="get-row-beyond-last">
                        <xsl:with-param name="index-value" select="$last-pos + 1"/>
                        <xsl:with-param name="worksheetNo" select="count(preceding-sibling::表:工作表)+1"/>
                        <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                        <xsl:with-param name="end-pos" select="$end-value"/>
                        <xsl:with-param name="total-col" select="$condition-col-max"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="./表:工作表内容/表:列[@表:式样引用] or ./表:工作表内容[@表:式样引用]">
                    <table:table-row table:style-name="ro1" table:number-rows-repeated="31990">
                        <table:table-cell table:number-columns-repeated="256"/>
                    </table:table-row>
                    <table:table-row table:style-name="ro1">
                        <table:table-cell table:number-columns-repeated="256"/>
                    </table:table-row>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!--    add row-group       2.6-->
    <xsl:template name="table:table-row-group">
        <xsl:param name="start"/>
        <xsl:param name="end"/>
        <xsl:variable name="start1" select="@表:起始"/>
        <xsl:variable name="end1" select="@表:终止"/>
        <xsl:variable name="nextstart" select="following-sibling::表:行/@表:起始"/>
        <xsl:variable name="nextend" select="following-sibling::表:行/@表:终止"/>
        <xsl:variable name="prestart" select="preceding-sibling::表:行/@表:起始"/>
        <xsl:variable name="preend" select="preceding-sibling::表:行/@表:终止"/>
        <xsl:variable name="numrow" select="$end1 - $start1"/>
        <xsl:variable name="position" select="position()"/>
        <xsl:choose>
            <xsl:when test="$nextstart &gt;= $start1 and $nextend &lt;= $end1">
                <table:table-row-group>
                    <xsl:call-template name="creategroup"/>
                </table:table-row-group>
            </xsl:when>
            <xsl:when test="$nextstart &gt;= $end1">
                <xsl:choose>
                    <xsl:when test="$nextend &lt;=$preend">
                        <xsl:call-template name="row">
                            <xsl:with-param name="start1" select="$start1"/>
                            <xsl:with-param name="end1" select="$end1"/>
                            <xsl:with-param name="nextstart" select="$nextstart"/>
                            <xsl:with-param name="nextend" select="$nextend"/>
                            <xsl:with-param name="prestart" select="$prestart"/>
                            <xsl:with-param name="preend" select="$preend"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="levelgroup"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="row">
                    <xsl:with-param name="start1" select="$start1"/>
                    <xsl:with-param name="end1" select="$end1"/>
                    <xsl:with-param name="nextstart" select="$nextstart"/>
                    <xsl:with-param name="nextend" select="$nextend"/>
                    <xsl:with-param name="prestart" select="$prestart"/>
                    <xsl:with-param name="preend" select="$preend"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="levelrowgroup">
        <xsl:param name="start"/>
        <xsl:param name="end"/>
        <xsl:variable name="start1" select="@表:起始"/>
        <xsl:variable name="end1" select="@表:终止"/>
        <xsl:variable name="nextstart" select="following-sibling::表:行/@表:起始"/>
        <xsl:variable name="nextend" select="following-sibling::表:行/@表:终止"/>
        <xsl:variable name="prestart" select="preceding-sibling::表:行/@表:起始"/>
        <xsl:variable name="preend" select="preceding-sibling::表:行/@表:终止"/>
        <xsl:variable name="numrow" select="$end1 - $start1"/>
        <xsl:variable name="position" select="position()"/>
        <xsl:call-template name="row">
            <xsl:with-param name="start1" select="$start1"/>
            <xsl:with-param name="end1" select="$end1"/>
            <xsl:with-param name="nextstart" select="$nextstart"/>
            <xsl:with-param name="nextend" select="$nextend"/>
            <xsl:with-param name="prestart" select="$prestart"/>
            <xsl:with-param name="preend" select="$preend"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="creategroup">
        <xsl:for-each select="following-sibling::表:行">
            <xsl:variable name="start1" select="@表:起始"/>
            <xsl:variable name="end1" select="@表:终止"/>
            <xsl:variable name="nextstart" select="following-sibling::表:行/@表:起始"/>
            <xsl:variable name="nextend" select="following-sibling::表:行/@表:终止"/>
            <xsl:variable name="prestart" select="preceding-sibling::表:行/@表:起始"/>
            <xsl:variable name="preend" select="preceding-sibling::表:行/@表:终止"/>
            <xsl:if test="$start1 &gt;= $prestart and $end1 &lt;= $preend">
                <xsl:call-template name="table:table-row-group"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="levelgroup">
        <xsl:for-each select="parent::表:分组集/表:行">
            <xsl:call-template name="levelrowgroup"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="row">
        <xsl:param name="start1"/>
        <xsl:param name="end1"/>
        <xsl:param name="nextstart"/>
        <xsl:param name="nextend"/>
        <xsl:param name="prestart"/>
        <xsl:param name="preend"/>
        <xsl:for-each select="ancestor::表:工作表内容/表:行[@表:行号]">
            <xsl:variable name="rownum" select="@表:行号"/>
            <xsl:variable name="aa" select="$start1 - $prestart"/>
            <xsl:if test="$rownum &gt;= $prestart and $rownum &lt;= ($prestart + $aa - 1) and $start1 &lt;= $preend">
                <table:table-row>
                    <xsl:attribute name="table:style-name"><xsl:value-of select="@表:式样引用"/></xsl:attribute>
                    <xsl:call-template name="celldata"/>
                </table:table-row>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="ancestor::表:工作表内容/表:行[@表:行号]">
            <xsl:variable name="rownum" select="@表:行号"/>
            <xsl:variable name="ss" select="$start1 - $preend"/>
            <xsl:if test="$rownum &gt;= ($preend +1) and $rownum &lt;= ($preend + $ss - 1) and $start1 &gt;= $preend">
                <table:table-row>
                    <xsl:attribute name="table:style-name"><xsl:value-of select="@表:式样引用"/></xsl:attribute>
                    <xsl:call-template name="celldata"/>
                </table:table-row>
            </xsl:if>
        </xsl:for-each>
        <table:table-row-group>
            <xsl:for-each select="ancestor::表:工作表内容/表:行[@表:行号]">
                <xsl:variable name="rownum" select="@表:行号"/>
                <xsl:if test="$rownum &lt;= $end1">
                    <xsl:if test="$rownum &gt;= $start1">
                        <table:table-row>
                            <xsl:attribute name="table:style-name"><xsl:value-of select="@表:式样引用"/></xsl:attribute>
                            <xsl:call-template name="celldata"/>
                        </table:table-row>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </table:table-row-group>
        <xsl:for-each select="ancestor::表:工作表内容/表:行[@表:行号]">
            <xsl:variable name="rownum" select="@表:行号"/>
            <xsl:variable name="bb" select="$preend - $end1"/>
            <xsl:if test="$rownum &gt;= ($end1 + 1) and $rownum &lt;= ($end1 + $bb) and $start1 &lt; $preend">
                <table:table-row>
                    <xsl:attribute name="table:style-name"><xsl:value-of select="@表:式样引用"/></xsl:attribute>
                    <xsl:call-template name="celldata"/>
                </table:table-row>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="celldata">
            <xsl:for-each select="./表:单元格">
            <table:table-cell>
                <xsl:choose>
                    <xsl:when test="表:数据/@表:数据类型 = 'number'">
                        <xsl:attribute name="office:value-type">float</xsl:attribute>
                        <xsl:attribute name="office:value"><xsl:choose><xsl:when test="表:数据/@表:数据数值"><xsl:value-of select="表:数据/@表:数据数值"/></xsl:when><xsl:otherwise><xsl:value-of select="表:数据/字:句/字:文本串"/></xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:when>
                    <xsl:when test="表:数据/@表:数据类型 = 'date'">
                        <xsl:attribute name="office:value-type">date</xsl:attribute>
                        <xsl:attribute name="table:date-value"><xsl:value-of select="表:数据/@表:数据数值"/></xsl:attribute>
                    </xsl:when>
                    <xsl:when test="表:数据/@表:数据类型 = 'time'">
                        <xsl:attribute name="office:value-type">time</xsl:attribute>
                        <xsl:attribute name="table:time-value"><xsl:value-of select="表:数据/@表:数据数值"/></xsl:attribute>
                    </xsl:when>
                    <xsl:when test="表:数据/@表:数据类型 = 'boolean'">
                        <xsl:attribute name="office:value-type">boolean</xsl:attribute>
                        <xsl:attribute name="table:boolean-value"><xsl:choose><xsl:when test="表:数据/字:句/字:文本串 = '1'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:when>
                    <xsl:when test="表:数据/@表:数据类型 = 'text'">
                        <xsl:attribute name="office:value-type">string</xsl:attribute>
                        <xsl:attribute name="table:string-value"><xsl:value-of select="表:数据/@表:数据数值"/></xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="表:数据/字:句/字:文本串">
                    <text:p>
                        <xsl:value-of select="表:数据/字:句/字:文本串"/>
                    </text:p>
                </xsl:if>
            </table:table-cell>
        </xsl:for-each>
    </xsl:template>
    <!-- add row-group 2.8 -->
    <xsl:template name="create-row">
        <xsl:param name="index-value"/>
        <xsl:param name="span-value"/>
        <xsl:param name="worksheetNo"/>
        <xsl:param name="row-value"/>
        <xsl:param name="times"/>
        <xsl:param name="current-index"/>
        <xsl:param name="condition-pos-str"/>
        <xsl:element name="table:table-row">
            <xsl:choose>
                <xsl:when test="./表:分页符集/表:分页符/@表:行号 = ($index-value + $times - 1)">
                    <xsl:choose>
                        <xsl:when test="($index-value + $times &lt; $current-index) and ($current-index != 0)">
                            <xsl:attribute name="table:style-name"><xsl:value-of select="concat('rob',$worksheetNo)"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="table:style-name"><xsl:value-of select="concat('rob', $worksheetNo, '-', $row-value)"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="($index-value + $times &lt; $current-index) and ($current-index != 0)">
                            <xsl:attribute name="table:style-name"><xsl:value-of select="concat('ro',$worksheetNo)"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="table:style-name"><xsl:value-of select="concat('ro', $worksheetNo, '-', $row-value)"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <!--chengxiuzhi0617-->
            <xsl:if test="./表:工作表内容/表:行[position() = $row-value]/@表:隐藏 = 'true'">
                <xsl:choose>
                    <xsl:when test="./表:工作表内容/表:行[position() = $row-value]/@表:跨度">
                        <xsl:if test="$index-value + $times &gt; ($current-index - 1)">
                            <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="$index-value + $times = $current-index">
                            <xsl:attribute name="table:visibility">collapse</xsl:attribute>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="not(./表:工作表内容/表:行[position() = $row-value]/*)">
                    <table:table-cell>
                        <xsl:for-each select="./表:单元格/表:数据">
                            <xsl:choose>
                                <xsl:when test="@表:数据类型 = 'number'">
                                    <xsl:attribute name="office:value-type">float</xsl:attribute>
                                    <xsl:attribute name="office:value"><xsl:choose><xsl:when test="@表:数据数值"><xsl:value-of select="@表:数据数值"/></xsl:when><xsl:otherwise><xsl:value-of select="字:句/字:文本串"/></xsl:otherwise></xsl:choose></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="@表:数据类型 = 'date'">
                                    <xsl:attribute name="office:value-type">date</xsl:attribute>
                                    <xsl:attribute name="table:date-value"><xsl:value-of select="@表:数据数值"/></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="@表:数据类型 = 'time'">
                                    <xsl:attribute name="office:value-type">time</xsl:attribute>
                                    <xsl:attribute name="table:time-value"><xsl:value-of select="@表:数据数值"/></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="@表:数据类型 = 'boolean'">
                                    <xsl:attribute name="office:value-type">boolean</xsl:attribute>
                                    <xsl:attribute name="table:boolean-value"><xsl:choose><xsl:when test="字:句/字:文本串 = '1'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="@表:数据类型 = 'text'">
                                    <xsl:attribute name="office:value-type">string</xsl:attribute>
                                    <xsl:attribute name="table:string-value"><xsl:value-of select="@表:数据数值"/></xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:if test="字:句/字:文本串">
                                <text:p>
                                    <xsl:value-of select="字:句/字:文本串"/>
                                </text:p>
                            </xsl:if>
                        </xsl:for-each>
                    </table:table-cell>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$index-value + $times &lt; $current-index">
                            <xsl:variable name="current" select="concat('R',($index-value + $times),'C')"/>
                            <xsl:variable name="col-pos-max">
                                <xsl:call-template name="condition-row-col-pos-max">
                                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                    <xsl:with-param name="last-value" select="0"/>
                                    <xsl:with-param name="div-value" select="'C'"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="contains($condition-pos-str,$current)">
                                    <xsl:call-template name="get-cell-span-in">
                                        <xsl:with-param name="row-pos" select="$index-value + $times"/>
                                        <xsl:with-param name="c-start" select="1"/>
                                        <xsl:with-param name="c-end" select="$col-pos-max"/>
                                        <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <table:table-cell/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="$index-value + $times = $current-index">
                            <xsl:apply-templates select="表:工作表内容/表:行[position() = $row-value]" mode="selected">
                                <xsl:with-param name="row-pos" select="$index-value + $times"/>
                                <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <table:table-cell/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:if test="$times &lt; $span-value">
            <xsl:call-template name="create-row">
                <xsl:with-param name="index-value" select="$index-value"/>
                <xsl:with-param name="span-value" select="$span-value"/>
                <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                <xsl:with-param name="row-value" select="$row-value"/>
                <xsl:with-param name="times" select="$times + 1"/>
                <xsl:with-param name="current-index" select="$current-index"/>
                <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="condition-row-col-pos-max">
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="last-value"/>
        <xsl:param name="div-value"/>
        <xsl:variable name="pre-value">
            <xsl:choose>
                <xsl:when test="$div-value = 'R'">
                    <xsl:value-of select="substring-before(substring-after($condition-pos-str,$div-value),'C')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(substring-after($condition-pos-str,$div-value),',')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="end-value">
            <xsl:choose>
                <xsl:when test="$last-value &lt; $pre-value">
                    <xsl:value-of select="$pre-value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$last-value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($condition-pos-str,$div-value)">
                <xsl:call-template name="condition-row-col-pos-max">
                    <xsl:with-param name="condition-pos-str" select="substring-after($condition-pos-str,$div-value)"/>
                    <xsl:with-param name="last-value" select="$end-value"/>
                    <xsl:with-param name="div-value" select="$div-value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$end-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="break-row-beyond-max">
        <xsl:param name="pos"/>
        <xsl:param name="last-value"/>
        <xsl:param name="count-value"/>
        <xsl:variable name="pre-value" select="./表:分页符集/表:分页符[@表:列号 and (position() = $pos)]/@表:列号"/>
        <xsl:variable name="end-value">
            <xsl:choose>
                <xsl:when test="$last-value &lt; $pre-value">
                    <xsl:value-of select="$pre-value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$last-value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$pos &lt; $count-value">
                <xsl:call-template name="break-row-beyond-max">
                    <xsl:with-param name="pos" select="$pos + 1"/>
                    <xsl:with-param name="last-value" select="$end-value"/>
                    <xsl:with-param name="count-value" select="$count-value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$end-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-row-beyond-last">
        <xsl:param name="index-value"/>
        <xsl:param name="worksheetNo"/>
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="end-pos"/>
        <xsl:param name="total-col"/>
        <xsl:variable name="current" select="concat('R',$index-value)"/>
        <xsl:element name="table:table-row">
            <xsl:choose>
                <xsl:when test="./表:分页符集/表:分页符/@行号 = ($index-value - 1)">
                    <xsl:attribute name="table:style-name"><xsl:value-of select="concat('rob',$worksheetNo)"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="table:style-name"><xsl:value-of select="concat('ro',$worksheetNo)"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="contains($condition-pos-str,$current)">
                    <xsl:call-template name="get-cell-span-in">
                        <xsl:with-param name="row-pos" select="$index-value"/>
                        <xsl:with-param name="c-start" select="1"/>
                        <xsl:with-param name="c-end" select="$total-col"/>
                        <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <table:table-cell/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:if test="$index-value &lt; ($end-pos + 1)">
            <xsl:call-template name="get-row-beyond-last">
                <xsl:with-param name="index-value" select="$index-value + 1"/>
                <xsl:with-param name="worksheetNo" select="$worksheetNo"/>
                <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                <xsl:with-param name="end-pos" select="$end-pos"/>
                <xsl:with-param name="total-col" select="$total-col"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="get-cell-span-in">
        <xsl:param name="row-pos"/>
        <xsl:param name="c-start"/>
        <xsl:param name="c-end"/>
        <xsl:param name="condition-pos-str"/>
        <xsl:variable name="current" select="concat('R',$row-pos,'C',$c-start,',')"/>
        <xsl:variable name="style-name">
            <xsl:choose>
                <xsl:when test="contains($condition-pos-str,$current)">
                    <xsl:variable name="temp-str">
                        <xsl:call-template name="condition-str">
                            <xsl:with-param name="param-str" select="substring-before($condition-pos-str,$current)"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="starts-with($temp-str, 'c')">
                            <xsl:value-of select="concat('ce', substring-after($temp-str, 'c'))"/>
                        </xsl:when>
                        <xsl:when test="starts-with($temp-str, 'v')">
                            <xsl:value-of select="concat('val', substring-after($temp-str, 'v'))"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="../表:单元格[position() = position() - 1]/@表:式样引用">
                            <xsl:value-of select="../表:单元格[position() = position() - 1]/@表:式样引用 "/>
                        </xsl:when>
                        <xsl:when test="../@表:式样引用">
                            <xsl:value-of select="../@表:式样引用"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'Default'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$c-start &lt; $c-end">
                <xsl:call-template name="get-cell-condition-in">
                    <xsl:with-param name="style-name" select="$style-name"/>
                </xsl:call-template>
                <xsl:call-template name="get-cell-span-in">
                    <xsl:with-param name="row-pos" select="$row-pos"/>
                    <xsl:with-param name="c-start" select="$c-start + 1"/>
                    <xsl:with-param name="c-end" select="$c-end"/>
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$c-start = $c-end">
                <xsl:call-template name="get-cell-condition-in">
                    <xsl:with-param name="style-name" select="$style-name"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <table:table-cell/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-cell-condition-in">
        <xsl:param name="style-name"/>
        <xsl:element name="table:table-cell">
            <xsl:if test="not( contains($style-name, 'Default'))">
                <xsl:choose>
                    <xsl:when test="starts-with($style-name, 'val')">
                        <xsl:attribute name="table:content-validation-name"><xsl:value-of select="$style-name"/></xsl:attribute>
                    </xsl:when>
                    <xsl:when test="starts-with($style-name, 'ce')">
                        <xsl:attribute name="table:style-name"><xsl:value-of select="$style-name"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="table:style-name"><xsl:value-of select="$style-name"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <!--chengxiuzhi0617 单元格-->
        </xsl:element>
    </xsl:template>
    <xsl:key match="/uof:UOF/uof:电子表格/表:主体/表:工作表/表:分页符集/表:分页符[@表:列号]" name="ColBreak" use="Column"/>
    <xsl:template name="create-default-column">
        <xsl:param name="currentColumn"/>
        <xsl:param name="currentColumnNode"/>
        <xsl:param name="worksheetNo"/>
        <xsl:element name="table:table-column">
            <xsl:attribute name="table:default-cell-style-name"><xsl:call-template name="get-default-cell-style"><xsl:with-param name="currentColumnNode" select="$currentColumnNode"/></xsl:call-template></xsl:attribute>
            <xsl:choose>
                <xsl:when test="key('ColBreak', $currentColumn)">
                    <xsl:attribute name="table:style-name"><xsl:value-of select="concat('cob',$worksheetNo)"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="table:style-name"><xsl:value-of select="concat('co',$worksheetNo)"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <!--chengxiuzhi0617用key就错-->
        </xsl:element>
    </xsl:template>
    <xsl:template name="get-default-cell-style">
        <xsl:param name="currentColumnNode"/>
        <xsl:choose>
            <xsl:when test="$currentColumnNode">
                <xsl:choose>
                    <xsl:when test="$currentColumnNode/@表:式样引用">
                        <xsl:value-of select="$currentColumnNode/@表:式样引用"/>
                    </xsl:when>
                    <xsl:otherwise>Default</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="./表:工作表内容[@表:式样引用]">
                        <xsl:value-of select="./表:工作表内容/@表:式样引用"/>
                    </xsl:when>
                    <xsl:otherwise>Default</xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="表:行" mode="selected">
        <xsl:param name="row-pos"/>
        <xsl:param name="condition-pos-str"/>
        <xsl:choose>
            <xsl:when test="表:单元格">
                <xsl:apply-templates select="表:单元格[1]" mode="selected">
                    <xsl:with-param name="row-pos" select="$row-pos"/>
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    <xsl:with-param name="col-pos-max">
                        <xsl:call-template name="condition-row-col-pos-max">
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            <xsl:with-param name="last-value" select="0"/>
                            <xsl:with-param name="div-value" select="'C'"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="col-pos-before" select="0"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="current" select="concat('R',$row-pos,'C')"/>
                <xsl:choose>
                    <xsl:when test="contains($condition-pos-str,$current)">
                        <xsl:call-template name="get-cell-span-in">
                            <xsl:with-param name="row-pos" select="$row-pos"/>
                            <xsl:with-param name="c-start" select="1"/>
                            <xsl:with-param name="c-end">
                                <xsl:call-template name="condition-row-col-pos-max">
                                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                                    <xsl:with-param name="last-value" select="0"/>
                                    <xsl:with-param name="div-value" select="'C'"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            <xsl:with-param name="col-pos" select="1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <table:table-cell/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="表:单元格" mode="selected">
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="col-pos-max"/>
        <xsl:param name="col-pos-before"/>
        <xsl:param name="row-pos"/>
        <xsl:param name="col-repeated" select="1"/>
        <xsl:variable name="col-pos">
            <xsl:choose>
                <xsl:when test="@表:列号">
                    <xsl:choose>
                        <xsl:when test="@表:合并列数">
                            <xsl:value-of select="@表:合并列数 + @表:列号"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@表:列号"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="@表:合并列数">
                            <xsl:value-of select="1 + @表:合并列数 + $col-pos-before"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="1 + $col-pos-before"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="next-cell" select="following-sibling::表:单元格[1]"/>
        <xsl:variable name="maodian" select="boolean($next-cell/uof:锚点)"/>
        <xsl:variable name="cell-is-repeatable" select="not(current()/*) and not($next-cell/*) and not($next-cell/text()) and (@表:式样引用 = $next-cell/@表:式样引用) and not($next-cell/@表:列号)"/>
        <xsl:if test="$col-repeated = 1">
            <xsl:if test="@表:列号  != ($col-pos-before + 1)">
                <xsl:call-template name="get-cell-span-in">
                    <xsl:with-param name="row-pos" select="$row-pos"/>
                    <xsl:with-param name="c-start" select="$col-pos-before + 1"/>
                    <xsl:with-param name="c-end" select="@表:列号 - 1"/>
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:element name="table:table-cell">
                <xsl:call-template name="create-table-cell-attributes">
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                    <xsl:with-param name="col-pos" select="$col-pos"/>
                    <xsl:with-param name="row-pos" select="$row-pos"/>
                </xsl:call-template>
                <xsl:if test="$cell-is-repeatable">
                    <xsl:apply-templates select="$next-cell" mode="selected">
                        <xsl:with-param name="row-pos" select="$row-pos"/>
                        <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                        <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                        <xsl:with-param name="col-pos-before" select="$col-pos + 1"/>
                        <xsl:with-param name="col-repeated" select="$col-repeated + 1"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:call-template name="create-table-cell-content">
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                    <xsl:with-param name="col-pos" select="$col-pos"/>
                    <xsl:with-param name="row-pos" select="$row-pos"/>
                </xsl:call-template>
            </xsl:element>
            <xsl:if test="@表:合并列数">
                <xsl:element name="table:covered-table-cell">
                    <xsl:if test="@表:合并列数 &gt; 1">
                        <xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="@表:合并列数"/></xsl:attribute>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="not($cell-is-repeatable and $col-repeated = 1)">
                <xsl:choose>
                    <xsl:when test="not($cell-is-repeatable) and $col-repeated &gt; 1">
                        <xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="$col-repeated"/></xsl:attribute>
                    </xsl:when>
                    <xsl:when test="not($next-cell)">
                        <xsl:if test="../../../../../表:公用处理规则/表:条件格式化集/表:条件格式化">
                            <xsl:call-template name="get-cell-span-in">
                                <xsl:with-param name="row-pos" select="$row-pos"/>
                                <xsl:with-param name="c-start" select="$col-pos"/>
                                <xsl:with-param name="c-end" select="$col-pos-max"/>
                                <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="not($cell-is-repeatable)">
                        <xsl:apply-templates select="$next-cell" mode="selected">
                            <xsl:with-param name="row-pos" select="$row-pos"/>
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                            <xsl:with-param name="col-pos-before" select="$col-pos"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$next-cell" mode="selected">
                            <xsl:with-param name="row-pos" select="$row-pos"/>
                            <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                            <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                            <xsl:with-param name="col-pos-before" select="$col-pos"/>
                            <xsl:with-param name="col-repeated" select="$col-repeated + 1"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$next-cell">
                    <xsl:apply-templates select="$next-cell" mode="skip">
                        <xsl:with-param name="row-pos" select="$row-pos"/>
                        <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                        <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                        <xsl:with-param name="col-pos-before" select="$col-pos"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--Redoffice comment liliang sc0012 06.02.15-->
    <!--新增内容-->
    <xsl:template match="uof:锚点">
        <xsl:variable name="tuxing1" select="@uof:图形引用"/>
        <xsl:choose>
            <xsl:when test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]">
                <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:公共类型='png' or /uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:公共类型='ipg' or /uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:公共类型='bmp' or /uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:公共类型='gif'">
                    <xsl:element name="draw:frame">
                        <xsl:attribute name="draw:name"><xsl:variable name="pos"><xsl:value-of select="count(preceding::uof:锚点)"/></xsl:variable><xsl:value-of select="concat('图形',$pos)"/></xsl:attribute>
                        <xsl:attribute name="svg:x"><xsl:value-of select="concat(@uof:x坐标,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="svg:y"><xsl:value-of select="concat(@uof:y坐标,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="svg:width"><xsl:value-of select="concat(@uof:宽度,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="svg:height"><xsl:value-of select="concat(@uof:高度,$uofUnit)"/></xsl:attribute>
                        <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]">
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
                        </xsl:for-each>
                        <xsl:element name="draw:image">
                            <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:路径">
                                <xsl:attribute name="xlink:href"><xsl:value-of select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=  $tuxing1]/uof:路径"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:数据">
                                <office:binary-data>
                                    <xsl:value-of select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:数据"/>
                                </office:binary-data>
                            </xsl:if>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:when test="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]/图:文本内容[@图:文本框='true']">
                <draw:text-box text:anchor-type="paragraph">
                    <xsl:attribute name="draw:style-name"><xsl:value-of select="$tuxing1"/></xsl:attribute>
                    <xsl:attribute name="svg:width"><xsl:value-of select="concat(@uof:宽度,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="svg:height"><xsl:value-of select="concat(@uof:高度,$uofUnit)"/></xsl:attribute>
                    <xsl:if test="@uof:x坐标">
                        <xsl:attribute name="svg:x"><xsl:value-of select="concat(@uof:x坐标,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@uof:y坐标">
                        <xsl:attribute name="svg:y"><xsl:value-of select="concat(@uof:y坐标,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="draw:z-index"><xsl:value-of select="/uof:UOF/uof:对象集/图:图形/@图:层次"/></xsl:attribute>
                    <xsl:apply-templates select="/uof:UOF/uof:对象集/图:图形[@图:标识符=$tuxing1]/图:文本内容/字:段落"/>
                    <xsl:apply-templates select="/uof:UOF/uof:对象集/图:图形[@图:标识符=$tuxing1]/图:文本内容/字:文字表"/>
                </draw:text-box>
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
                <xsl:when test="$tuxing1='4'">
                    <xsl:element name="draw:g">
                        <xsl:variable name="tu">
                            <xsl:value-of select="@图:标识符"/>
                        </xsl:variable>
                        <xsl:attribute name="draw:style-name"><xsl:value-of select="$tu"/></xsl:attribute>
                        <xsl:attribute name="draw:z-index"><xsl:value-of select="@图:层次"/></xsl:attribute>
                        <xsl:variable name="this-group-x">
                            <xsl:choose>
                                <xsl:when test="key('rel_graphic_name',@图:标识符)/@uof:x坐标">
                                    <xsl:value-of select="key('rel_graphic_name',@图:标识符)/@uof:x坐标"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="number(0)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="this-group-y">
                            <xsl:choose>
                                <xsl:when test="key('rel_graphic_name',@图:标识符)/@uof:y坐标">
                                    <xsl:value-of select="key('rel_graphic_name',@图:标识符)/@uof:y坐标"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="number(0)"/>
                                </xsl:otherwise>
                            </xsl:choose>
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
            <xsl:when test="key('rel_graphic_name',@图:标识符)/@uof:x坐标">
                <xsl:for-each select="key('rel_graphic_name',@图:标识符)">
                    <xsl:if test="@uof:x坐标">
                        <xsl:attribute name="svg:x"><xsl:value-of select="concat(@uof:x坐标,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@uof:y坐标">
                        <xsl:attribute name="svg:y"><xsl:value-of select="concat(@uof:y坐标,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:variable name="tuxing1" select="@uof:图形引用"/>
                    <xsl:attribute name="svg:width"><xsl:value-of select="concat(@uof:宽度,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="svg:height"><xsl:value-of select="concat(@uof:高度,$uofUnit)"/></xsl:attribute>
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
                <xsl:attribute name="svg:width"><xsl:value-of select="concat(图:预定义图形/图:属性/图:宽度,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="svg:height"><xsl:value-of select="concat(图:预定义图形/图:属性 /图:高度,$uofUnit)"/></xsl:attribute>
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
                        <xsl:attribute name="svg:x2"><xsl:value-of select="concat((number(@uof:x坐标) + number(@uof:宽度)),$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="svg:y2"><xsl:value-of select="concat((number(@uof:y坐标) + number(@uof:高度)),$uofUnit)"/></xsl:attribute>
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
    <!--Redoffice comment liliang end 06.02.15-->
    <xsl:template match="表:单元格" mode="skip">
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="col-pos-max"/>
        <xsl:param name="col-pos-before"/>
        <xsl:param name="row-pos"/>
        <xsl:variable name="next-cell" select="following-sibling::表:单元格[1]"/>
        <xsl:variable name="cell-is-repeatable" select="not($next-cell/*) and not($next-cell/text()) and (@表:式样引用 = $next-cell/@表:式样引用) and not($next-cell/@表:列号)"/>
        <xsl:choose>
            <xsl:when test="$cell-is-repeatable">
                <xsl:apply-templates select="$next-cell" mode="skip">
                    <xsl:with-param name="row-pos" select="$row-pos"/>
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                    <xsl:with-param name="col-pos-before" select="$col-pos-before + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$next-cell">
                    <xsl:apply-templates select="$next-cell" mode="selected">
                        <xsl:with-param name="row-pos" select="$row-pos"/>
                        <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                        <xsl:with-param name="col-pos-max" select="$col-pos-max"/>
                        <xsl:with-param name="col-pos-before" select="$col-pos-before +1"/>
                    </xsl:apply-templates>
                    <!--chengxz0925 no otherwise ,some content cells missed -->
                </xsl:if>
                <!--chengxz 060418 add if sentence-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--xsl:template name="create-table-cell-attributes"></xsl:template>
<xsl:template name="create-table-cell-content"></xsl:template>
<xsl:template name="create-data-content"></xsl:template>
<xsl:template name="get-condition-dependent-cell-attributes"></xsl:template-->
    <xsl:template name="create-table-cell-attributes">
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="col-pos-max"/>
        <xsl:param name="col-pos"/>
        <xsl:param name="row-pos"/>
        <xsl:choose>
            <xsl:when test="$condition-pos-str">
                <xsl:call-template name="get-condition-dependent-cell-attributes">
                    <xsl:with-param name="condition-pos-str" select="$condition-pos-str"/>
                    <xsl:with-param name="current-pos-str" select="concat('R',$row-pos,'C',$col-pos,',')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="table:style-name"><xsl:choose><xsl:when test="@表:式样引用"><xsl:value-of select="@表:式样引用"/></xsl:when><xsl:when test="../@表:式样引用 and ../@表:式样引用 != ''"><xsl:value-of select="../@表:式样引用"/></xsl:when><xsl:otherwise><xsl:value-of select="'Default'"/></xsl:otherwise></xsl:choose></xsl:attribute>
                <!--chengxiuzhi-->
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@表:合并列数 or @表:合并行数">
            <xsl:choose>
                <xsl:when test="@表:合并列数">
                    <xsl:attribute name="table:number-columns-spanned"><xsl:value-of select="@表:合并列数 + 1"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="table:number-columns-spanned">1</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="@表:合并行数">
                    <xsl:attribute name="table:number-rows-spanned"><xsl:value-of select="@表:合并行数+1"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="table:number-rows-spanned">1</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="表:数据">
            <xsl:if test="表:数据/表:公式">
                <xsl:variable name="calc-formula">
                    <xsl:call-template name="translate-expression">
                        <xsl:with-param name="cell-row-pos" select="$row-pos"/>
                        <xsl:with-param name="cell-column-pos" select="$col-pos"/>
                        <xsl:with-param name="expression" select="表:数据/表:公式"/>
                        <xsl:with-param name="return-value" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:attribute name="table:formula"><xsl:value-of select="$calc-formula"/></xsl:attribute>
            </xsl:if>
            <!--RedOffice Comment from Zengjh:UOF0020 2006-04-17 Based on Original-->
            <xsl:variable name="table-stylename" select="@表:式样引用"/>
            <xsl:variable name="data-format">
                <xsl:for-each select="/uof:UOF/uof:式样集/uof:单元格式样">
                    <xsl:if test="$table-stylename = ./@ 表:标识符">
                        <xsl:value-of select="表:数字格式/@表:分类名称"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="data-formatcode">
                <xsl:for-each select="/uof:UOF/uof:式样集/uof:单元格式样">
                    <xsl:if test="$table-stylename= ./@表:标识符">
                        <xsl:value-of select="表:数字格式/@表:格式码"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="表:数据/@表:数据类型 = 'number'">
                    <xsl:choose>
                        <xsl:when test="$data-format = 'percentage' or contains( $data-formatcode, '%')">
                            <xsl:attribute name="office:value-type">percentage</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="contains($data-format, 'currency')">
                            <xsl:attribute name="office:value-type">currency</xsl:attribute>
                            <xsl:attribute name="office:currency">CNY</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="office:value-type">float</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="office:value"><xsl:choose><xsl:when test="表:数据/@表:数据数值"><xsl:value-of select="表:数据/@表:数据数值"/></xsl:when><xsl:otherwise><xsl:value-of select="表:数据/字:句/字:文本串"/></xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:when>
                <xsl:when test="表:数据/@表:数据类型 = 'date'">
                    <xsl:attribute name="office:value-type">date</xsl:attribute>
                    <xsl:attribute name="office:date-value"><xsl:value-of select="表:数据/@表:数据数值"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="表:数据/@表:数据类型 = 'time'">
                    <xsl:attribute name="office:value-type">time</xsl:attribute>
                    <xsl:attribute name="office:time-value"><xsl:value-of select="表:数据/@表:数据数值"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="表:数据/@表:数据类型 = 'boolean'">
                    <xsl:attribute name="office:value-type">boolean</xsl:attribute>
                    <xsl:attribute name="office:boolean-value"><xsl:choose><xsl:when test="表:数据/字:句/字:文本串 = '1'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:when>
                <xsl:when test="表:数据/@表:数据类型 = 'text'">
                    <xsl:attribute name="office:value-type">string</xsl:attribute>
                    <xsl:attribute name="office:string-value"><xsl:value-of select="表:数据/@表:数据数值"/></xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <!-- zhangying ok and /uof:UOF/uof:电子表格/表:公共处理规则/表:数据有效性集-->
        <xsl:if test="表:数据">
            <xsl:variable name="validation-name">
                <xsl:call-template name="zyvalidationtest">
                    <xsl:with-param name="column-num" select="$col-pos"/>
                    <xsl:with-param name="row-num" select="$row-pos"/>
                    <xsl:with-param name="table-name" select="ancestor::表:工作表/@表:名称"/>
                    <xsl:with-param name="validation-set" select="/uof:UOF/uof:电子表格/表:公用处理规则/表:数据有效性集/表:数据有效性"/>
                    <xsl:with-param name="validation-num" select="'1'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:if test="$validation-name!=''">
                <xsl:attribute name="table:content-validation-name"><xsl:value-of select="$validation-name"/></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <!-- zhangying mod end -->
    </xsl:template>
    <!-- zhangying o -->
    <xsl:template name="zyvalidationtest">
        <xsl:param name="row-num"/>
        <xsl:param name="column-num"/>
        <xsl:param name="table-name"/>
        <xsl:param name="validation-set"/>
        <xsl:param name="validation-num"/>
        <xsl:if test="$validation-set">
            <xsl:variable name="zone" select="$validation-set/表:区域/text()"/>
            <xsl:variable name="success">
                <xsl:choose>
                    <xsl:when test="$table-name=substring-after(substring-before($zone,'.'),'$')">
                        <xsl:variable name="validation-row-left-top" select="substring-before(substring-after(substring-after(substring-after($zone,'$'),'$'),'$'),':')"/>
                        <xsl:variable name="validation-row-right-bottom" select="substring-after(substring-after(substring-after($zone,':$'),'$'),'$')"/>
                        <xsl:choose>
                            <xsl:when test="($row-num &gt;= $validation-row-left-top and $row-num &lt;= $validation-row-right-bottom) or $validation-row-left-top=$validation-row-right-bottom">
                                <xsl:variable name="validation-column-left-top">
                                    <xsl:call-template name="translate-column-char-to-number">
                                        <xsl:with-param name="string" select="substring-before(substring-after(substring-after($zone,'$'),'$'),'$')"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="validation-column-right-bottom">
                                    <xsl:call-template name="translate-column-char-to-number">
                                        <xsl:with-param name="string" select="substring-before(substring-after(substring-after($zone,':$'),'$'),'$')"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="($column-num &gt;= $validation-column-left-top) and ($column-num &lt;= $validation-column-right-bottom)">yes</xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$success='yes'">
                    <xsl:value-of select="concat('val',$validation-num)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="zyvalidationtest">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="row-num" select="$row-num"/>
                        <xsl:with-param name="column-num" select="$column-num"/>
                        <xsl:with-param name="validation-set" select="$validation-set[position()!=1]"/>
                        <xsl:with-param name="validation-num" select="$validation-num + 1"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!--zhangying mod end -->
    <xsl:template name="create-table-cell-content">
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="col-pos-max"/>
        <xsl:param name="col-pos"/>
        <xsl:param name="row-pos"/>
        <!--Redoffice comment liliang SC0011 06.02.15 -->
        <!--新增内容-->
        <xsl:apply-templates select="uof:锚点"/>
        <!--Redoffice comment liliang end 06.02.15 -->
        <xsl:apply-templates select="表:批注" mode="body"/>
        <!--RedOffice Comment from Zengjh:UOF0020 2006-04-26 charts-->
        <xsl:apply-templates select="表:图表"/>
        <xsl:if test="表:数据/字:句">
            <text:p>
                <xsl:call-template name="create-data-content">
                    <xsl:with-param name="style-id" select="../../@表:式样引用"/>
                </xsl:call-template>
            </text:p>
        </xsl:if>
        <!--chengxz0701多个句不能读入-->
    </xsl:template>
    <xsl:template name="create-data-content">
        <xsl:param name="style-id" select="@表:式样引用"/>
        <xsl:variable name="html-children" select="表:式样引用/descendant-or-self::*[namespace-uri()='http://www.w3.org/TR/REC-html40'][string-length(text()) != 0]"/>
        <xsl:choose>
            <xsl:when test="$html-children and $html-children != ''">
                <xsl:for-each select="$html-children">
                    <text:span text:style-name="{concat($style-id, 'T', count(preceding::表:数据/字:句/字:文本串[child::html:*]), '_', position())}">
                        <xsl:copy-of select="text()"/>
                    </text:span>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="@表:超链接引用">
                <text:a xlink:href="{@表:超链接引用}">
                    <xsl:value-of select="表:数据/字:句/字:文本串"/>
                </text:a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="表:数据/字:句">
                    <xsl:choose>
                        <xsl:when test="name(descendant::*[1])='字:句属性'">
                            <text:span>
                                <xsl:attribute name="text:style-name"><xsl:value-of select="descendant::*[1]/@字:式样引用"/></xsl:attribute>
                                <xsl:value-of select="./字:文本串"/>
                            </text:span>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./字:文本串"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="create-comment-data-content">
        <xsl:param name="style-id" select="@表:式样引用"/>
        <xsl:variable name="html-children" select="表:式样引用/descendant-or-self::*[namespace-uri()='http://www.w3.org/TR/REC-html40'][string-length(text()) != 0]"/>
        <xsl:choose>
            <xsl:when test="$html-children and $html-children != ''">
                <xsl:for-each select="$html-children">
                    <text:span text:style-name="{concat($style-id, 'T', count(preceding::图:文本内容/字:段落/字:句/字:文本串[child::html:*]), '_', position())}">
                        <xsl:copy-of select="text()"/>
                    </text:span>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="@表:超链接引用">
                <text:a xlink:href="{@表:超链接引用}">
                    <xsl:value-of select="图:文本内容/字:段落/字:句/字:文本串"/>
                </text:a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="图:文本内容/字:段落/字:句/字:文本串"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get-condition-dependent-cell-attributes">
        <xsl:param name="condition-pos-str"/>
        <xsl:param name="current-pos-str"/>
        <xsl:variable name="temp-str">
            <xsl:call-template name="condition-str">
                <xsl:with-param name="param-str" select="substring-before($condition-pos-str,$current-pos-str)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="style-name">
            <xsl:choose>
                <xsl:when test="contains($condition-pos-str, $current-pos-str) and starts-with($temp-str, 'c')">
                    <xsl:value-of select="concat('ce', substring-after($temp-str, 'c'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="@表:式样引用">
                            <xsl:value-of select="@表:式样引用"/>
                        </xsl:when>
                        <xsl:when test="../@表:式样引用">
                            <xsl:value-of select="../@表:式样引用"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'Default'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="not( contains($style-name, 'Default'))">
            <xsl:choose>
                <xsl:when test="starts-with($style-name, 'val')">
                    <xsl:attribute name="table:content-validation-name"><xsl:value-of select="$style-name"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="table:style-name"><xsl:value-of select="$style-name"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="contains($style-name, 'Default')">
            <xsl:variable name="style-nametemp">
                <xsl:choose>
                    <xsl:when test="@表:式样引用">
                        <xsl:value-of select="@表:式样引用"/>
                    </xsl:when>
                    <xsl:when test="../@表:式样引用">
                        <xsl:value-of select="../@表:式样引用"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'Default'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="table:style-name"><xsl:value-of select="$style-nametemp"/></xsl:attribute>
            <!--xsl:attribute name="style:data-style-name"><xsl:value-of select="N104" /></xsl:attribute-->
        </xsl:if>
        <!--chengxz-->
        <xsl:if test="contains($condition-pos-str, $current-pos-str)">
            <xsl:choose>
                <xsl:when test="starts-with($temp-str, 'v')">
                    <xsl:attribute name="table:content-validation-name"><xsl:value-of select="concat('val', substring-after($temp-str, 'v'))"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="after-str" select="substring-after($condition-pos-str, $current-pos-str)"/>
                    <xsl:if test="contains( $after-str, $current-pos-str)">
                        <xsl:variable name="temp-str-2">
                            <xsl:call-template name="condition-str">
                                <xsl:with-param name="param-str" select="substring-before( $after-str,$current-pos-str)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:if test="starts-with( $temp-str-2, 'v')">
                            <xsl:attribute name="table:content-validation-name"><xsl:value-of select="concat('val', substring-after($temp-str-2, 'v'))"/></xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="表:工作表内容">
        <xsl:variable name="default-column-width">
            <xsl:choose>
                <xsl:when test="@表:缺省列宽">
                    <xsl:call-template name="convert2cm">
                        <xsl:with-param name="value" select="concat(@表:缺省列宽,'pt')"/>
                    </xsl:call-template>
                    <xsl:text>cm</xsl:text>
                </xsl:when>
                <xsl:otherwise>2.096cm</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="table-pos">
            <xsl:value-of select="count(../preceding-sibling::表:工作表)+1"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="表:列">
                <xsl:call-template name="get-column-style-name">
                    <xsl:with-param name="finishedColumns" select="0"/>
                    <xsl:with-param name="columnCount" select="count(./表:列)"/>
                    <xsl:with-param name="currentCount" select="1"/>
                    <xsl:with-param name="table-pos" select="$table-pos"/>
                    <xsl:with-param name="default-column-width" select="$default-column-width"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="../表:分页符集/表:分页符[@表:列号]">
            <style:style style:name="{concat('cob',$table-pos)}" style:family="table-column">
                <xsl:element name="style:table-column-properties">
                    <xsl:attribute name="style:column-width"><xsl:value-of select="$default-column-width"/></xsl:attribute>
                    <xsl:attribute name="fo:break-before">page</xsl:attribute>
                </xsl:element>
            </style:style>
        </xsl:if>
        <xsl:variable name="default-row-height">
            <xsl:choose>
                <xsl:when test="@表:缺省行高">
                    <xsl:call-template name="convert2cm">
                        <xsl:with-param name="value" select="concat(@表:缺省行高,'pt')"/>
                    </xsl:call-template>
                    <xsl:text>cm</xsl:text>
                </xsl:when>
                <xsl:otherwise>0.503cm</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <style:style style:family="table-row" style:name="{concat('ro', $table-pos)}">
            <style:table-row-properties style:row-height="{$default-row-height}" style:use-optimal-row-height="false"/>
        </style:style>
        <xsl:if test="表:行">
            <xsl:call-template name="get-row-style-name">
                <xsl:with-param name="lastrowpos" select="0"/>
                <xsl:with-param name="row-count" select="count(./表:行)"/>
                <xsl:with-param name="currentRow" select="1"/>
                <xsl:with-param name="table-pos" select="$table-pos"/>
                <xsl:with-param name="default-row-height" select="$default-row-height"/>
            </xsl:call-template>
        </xsl:if>
        <!--RedOffice Comment from Zengjh:UOF0020 2006-06-11 charts-->
        <xsl:for-each select="//表:图表">
            <xsl:variable name="chart-current">
                <xsl:number level="any" count="表:图表" format="1"/>
            </xsl:variable>
            <style:style style:family="graphics" style:name="{concat('chart', $chart-current)}">
                <style:graphic-properties>
                    <xsl:choose>
                        <xsl:when test="@表:随动方式='none'">
                            <xsl:attribute name="draw:move-protect">true</xsl:attribute>
                            <xsl:attribute name="draw:size-protect">true</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@表:随动方式='move'">
                            <xsl:attribute name="draw:size-protect">true</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </style:graphic-properties>
            </style:style>
        </xsl:for-each>
        <!--RedOffice comment (Zengjh) end charts-->
        <xsl:if test="../表:分页符集/表:分页符[@行号]">
            <style:style style:name="{concat('rob',$table-pos)}" style:family="table-row">
                <xsl:element name="style:table-row-properties">
                    <xsl:attribute name="style:row-height"><xsl:value-of select="$default-row-height"/></xsl:attribute>
                    <xsl:attribute name="style:use-optimal-row-height">false</xsl:attribute>
                    <xsl:attribute name="fo:break-before">page</xsl:attribute>
                </xsl:element>
            </style:style>
        </xsl:if>
        <xsl:element name="style:style">
            <xsl:attribute name="style:name"><xsl:value-of select="concat( 'ta', $table-pos)"/></xsl:attribute>
            <xsl:attribute name="style:family">table</xsl:attribute>
            <xsl:attribute name="style:master-page-name"><xsl:call-template name="encode-as-nc-name"><xsl:with-param name="string" select="concat( 'TAB_',../@表:名称)"/></xsl:call-template></xsl:attribute>
            <xsl:element name="style:properties">
                <xsl:choose>
                    <xsl:when test="../@表:隐藏 = 'true'">
                        <xsl:attribute name="table:display">false</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="table:display">true</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="get-column-style-name">
        <xsl:param name="finishedColumns"/>
        <xsl:param name="columnCount"/>
        <xsl:param name="currentCount"/>
        <xsl:param name="table-pos"/>
        <xsl:param name="default-column-width"/>
        <xsl:if test="$currentCount &lt; ($columnCount + 1)">
            <xsl:variable name="span-value">
                <xsl:choose>
                    <xsl:when test="./表:列[position() = $currentCount]/@表:跨度">
                        <xsl:value-of select="./表:跨度[position() = $currentCount]/@表:跨度 + 1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="0"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="current-index">
                <xsl:choose>
                    <xsl:when test="./表:列[position() = $currentCount]/@表:列号">
                        <xsl:value-of select="./表:列[position() = $currentCount]/@表:列号 - 1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$finishedColumns"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="column-break">
                <xsl:choose>
                    <xsl:when test="$span-value = 0">
                        <xsl:if test="../表:分页符集/表:分页符/表:列 = $current-index">
                            <xsl:value-of select="1"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="../表:分页符集/表:分页符[(@表:列号 &gt; $finishedColumns) and (@表:列号 &lt; ($finishedColumns + $span-value))]">
                            <xsl:value-of select="1"/>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="$column-break = 1">
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name"><xsl:call-template name="encode-as-nc-name"><xsl:with-param name="string" select="concat('cob', $table-pos, '-',$currentCount)"/></xsl:call-template></xsl:attribute>
                    <xsl:attribute name="style:family">table-column</xsl:attribute>
                    <xsl:element name="style:table-column-properties">
                        <xsl:choose>
                            <xsl:when test="./表:列[position() = $currentCount]/@表:列宽">
                                <xsl:attribute name="style:column-width"><xsl:call-template name="convert2cm"><xsl:with-param name="value" select="concat(./表:列[position() = $currentCount]/@表:列宽,'pt')"/></xsl:call-template><xsl:text>cm</xsl:text></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:column-width"><xsl:value-of select="$default-column-width"/></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="./表:列[position() = $currentCount]/@表:列宽 &gt; 0">
                                <xsl:attribute name="style:use-optimal-column-width">false</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:use-optimal-column-width">true</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:attribute name="fo:break-before">page</xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <style:style style:name="{concat('co', $table-pos, '-',$currentCount)}" style:family="table-column">
                <xsl:element name="style:table-column-properties">
                    <xsl:choose>
                        <xsl:when test="./表:列[position() = $currentCount]/@表:列宽">
                            <xsl:attribute name="style:column-width"><xsl:call-template name="convert2cm"><xsl:with-param name="value" select="concat(./表:列[position() = $currentCount]/@表:列宽,'pt')"/></xsl:call-template><xsl:text>cm</xsl:text></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:column-width"><xsl:value-of select="$default-column-width"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="fo:break-before">auto</xsl:attribute>
                </xsl:element>
            </style:style>
            <xsl:if test="$currentCount &lt; $columnCount">
                <xsl:call-template name="get-column-style-name">
                    <xsl:with-param name="finishedColumns">
                        <xsl:choose>
                            <xsl:when test="./表:列[position() = $currentCount]/@表:列号">
                                <xsl:choose>
                                    <xsl:when test="./表:列[position() = $currentCount]/@表:跨度">
                                        <xsl:value-of select="./表:列[position() = $currentCount]/@表:列宽 + ./表:列[position() = $currentCount]/@表:跨度"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="./表:列[position() = $currentCount]/@表:列号"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="./表:列[position() = $currentCount]/@表:跨度">
                                        <xsl:value-of select="$finishedColumns + ./表:列[position() = $currentCount]/@表:跨度 + 1"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$finishedColumns + 1"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="columnCount" select="$columnCount"/>
                    <xsl:with-param name="currentCount" select="$currentCount + 1"/>
                    <xsl:with-param name="table-pos" select="$table-pos"/>
                    <xsl:with-param name="default-column-width" select="$default-column-width"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template name="get-row-style-name">
        <xsl:param name="lastrowpos"/>
        <xsl:param name="row-count"/>
        <xsl:param name="currentRow"/>
        <xsl:param name="table-pos"/>
        <xsl:param name="default-row-height"/>
        <xsl:if test="$currentRow &lt; ($row-count + 1)">
            <xsl:variable name="span-value">
                <xsl:choose>
                    <xsl:when test="./表:行[position() = $currentRow]/@表:行号">
                        <xsl:choose>
                            <xsl:when test="./表:行[position() = $currentRow]/@表:跨度">
                                <xsl:value-of select="./表:行[position() = $currentRow]/@表:行号 - $lastrowpos+ ./表:行[position() = $currentRow]/@表:跨度"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="0"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="./表:行[position() = $currentRow]/@表:跨度">
                                <xsl:value-of select="./表:行[position() = $currentRow]/@表:跨度 + 1"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="0"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="current-index">
                <xsl:choose>
                    <xsl:when test="./表:行[position() = $currentRow]/@表:行号">
                        <xsl:value-of select="./表:行[position() = $currentRow]/@表:行号 - 1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$lastrowpos"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="row-break">
                <xsl:choose>
                    <xsl:when test="$span-value = 0">
                        <xsl:if test="../表:分页符集/表:分页符/@表:行号 = $current-index">
                            <xsl:value-of select="1"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="../表:分页符集/表:分页符[(@表:行号 &gt; $lastrowpos) and (@表:行号 &lt; ($lastrowpos + $span-value))]">
                            <xsl:value-of select="1"/>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="$row-break = 1">
                <style:style style:name="{concat('rob', $table-pos, '-',$currentRow)}" style:family="table-row">
                    <xsl:element name="style:table-row-properties">
                        <xsl:choose>
                            <xsl:when test="./表:行[position() = $currentRow]/@表:行高">
                                <xsl:attribute name="style:row-height"><xsl:call-template name="convert2cm"><xsl:with-param name="value" select="concat(./表:行[position() = $currentRow]/@表:行高,'pt')"/></xsl:call-template><xsl:text>cm</xsl:text></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:row-height"><xsl:value-of select="$default-row-height"/></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="./表:行[position() = $currentRow]/@表:行高 &gt; 0">
                                <xsl:attribute name="style:use-optimal-row-height">false</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:use-optimal-row-height">true</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:attribute name="fo:break-before">page</xsl:attribute>
                    </xsl:element>
                </style:style>
            </xsl:if>
            <style:style style:name="{concat('ro', $table-pos, '-',$currentRow)}" style:family="table-row">
                <xsl:element name="style:table-row-properties">
                    <xsl:choose>
                        <xsl:when test="./表:行[position() = $currentRow]/@表:行高">
                            <xsl:attribute name="style:row-height"><xsl:call-template name="convert2cm"><xsl:with-param name="value" select="concat(./表:行[position() = $currentRow]/@表:行高,'pt')"/></xsl:call-template><xsl:text>cm</xsl:text></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:row-height"><xsl:value-of select="$default-row-height"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="style:use-optimal-row-height">true</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="./表:行[position() = $currentRow]/@表:行高 &gt; 0">
                            <xsl:attribute name="style:use-optimal-row-height">false</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:use-optimal-row-height">true</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="fo:break-before">auto</xsl:attribute>
                </xsl:element>
            </style:style>
            <xsl:if test="$currentRow &lt; $row-count">
                <xsl:call-template name="get-row-style-name">
                    <xsl:with-param name="lastrowpos">
                        <xsl:choose>
                            <xsl:when test="./表:行[position() = $currentRow]/@表:行号">
                                <xsl:choose>
                                    <xsl:when test="./表:行[position() = $currentRow]/@表:跨度">
                                        <xsl:value-of select="./表:行[position() = $currentRow]/@表:行号 + ./表:行[position() = $currentRow]/@表:跨度"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="./表:行[position() = $currentRow]/@表:行号"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="./表:行[position() = $currentRow]/@表:跨度">
                                        <xsl:value-of select="$lastrowpos + ./表:行[position() = $currentRow]/@表:跨度 + 1"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$lastrowpos + 1"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="row-count" select="$row-count"/>
                    <xsl:with-param name="currentRow" select="$currentRow + 1"/>
                    <xsl:with-param name="table-pos" select="$table-pos"/>
                    <xsl:with-param name="default-row-height" select="$default-row-height"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template name="encode-as-nc-name">
        <xsl:param name="string"/>
        <xsl:value-of select="translate($string, '. %()/\+', '')"/>
    </xsl:template>
    <xsl:key match="/uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/表:行/表:单元格" name="cells" use="@表:式样引用"/>
    <xsl:template match="表:数字格式">
        <xsl:variable name="unit-count" select="string-length(@表:格式码) - string-length(translate(@表:格式码,';','')) + 1"/>
        <xsl:variable name="style-id" select="../@表:标识符"/>
        <xsl:variable name="number-format-name">
            <xsl:choose>
                <xsl:when test="@表:分类名称='fraction' or @表:分类名称='scientific'">number</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@表:分类名称"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="process-number-format">
            <xsl:with-param name="number-format-name" select="$number-format-name"/>
            <xsl:with-param name="number-format-unit" select="@表:格式码"/>
            <xsl:with-param name="style-id" select="concat($style-id,'F')"/>
            <xsl:with-param name="format-type" select="key('cells', $style-id)/表:数据/@表:数据类型"/>
            <xsl:with-param name="total-unit" select="$unit-count"/>
            <xsl:with-param name="current-unit" select="0"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="process-number-format">
        <xsl:param name="number-format-name"/>
        <xsl:param name="number-format-unit"/>
        <xsl:param name="style-id"/>
        <xsl:param name="format-type"/>
        <xsl:param name="total-unit"/>
        <xsl:param name="current-unit"/>
        <xsl:choose>
            <xsl:when test="$current-unit &lt; ($total-unit -1)">
                <xsl:variable name="style-name">
                    <xsl:choose>
                        <xsl:when test="contains(substring-before($number-format-unit,';'),'[$')">currency</xsl:when>
                        <xsl:when test="contains(substring-before($number-format-unit,';'),'%')">percentage</xsl:when>
                        <xsl:otherwise>number</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="{concat('number:',$style-name,'-style')}">
                    <xsl:attribute name="style:name"><xsl:value-of select="concat( $style-id, 'P',$current-unit)"/></xsl:attribute>
                    <xsl:attribute name="style:volatile">true</xsl:attribute>
                    <xsl:call-template name="general-number">
                        <xsl:with-param name="number-format-unit" select="substring-before($number-format-unit,';')"/>
                    </xsl:call-template>
                </xsl:element>
                <xsl:call-template name="process-number-format">
                    <xsl:with-param name="number-format-name" select="$number-format-name"/>
                    <xsl:with-param name="number-format-unit" select="substring-after($number-format-unit,';')"/>
                    <xsl:with-param name="style-id" select="$style-id"/>
                    <xsl:with-param name="format-type" select="$format-type"/>
                    <xsl:with-param name="total-unit" select="$total-unit"/>
                    <xsl:with-param name="current-unit" select="$current-unit +1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{concat('number:',$number-format-name,'-style')}">
                    <xsl:attribute name="style:name"><xsl:value-of select="$style-id"/></xsl:attribute>
                    <xsl:call-template name="element-attribute">
                        <xsl:with-param name="number-format-unit" select="string($number-format-unit)"/>
                    </xsl:call-template>
                    <xsl:call-template name="general-number">
                        <xsl:with-param name="number-format-unit" select="string($number-format-unit)"/>
                    </xsl:call-template>
                    <xsl:call-template name="style-map">
                        <xsl:with-param name="number-format-name" select="@表:分类名称"/>
                        <xsl:with-param name="number-format-unit" select="@表:格式码"/>
                        <xsl:with-param name="style-id" select="$style-id"/>
                        <xsl:with-param name="format-type" select="$format-type"/>
                        <xsl:with-param name="total-unit" select="$total-unit"/>
                        <xsl:with-param name="current-unit" select="0"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="style-map">
        <xsl:param name="number-format-name"/>
        <xsl:param name="number-format-unit"/>
        <xsl:param name="style-id"/>
        <xsl:param name="format-type"/>
        <xsl:param name="total-unit"/>
        <xsl:param name="current-unit"/>
        <xsl:if test="$current-unit &lt; ($total-unit -1)">
            <xsl:variable name="stylecondition" select="substring-after(substring-before($number-format-unit,']'),'[')"/>
            <style:map style:condition="{$stylecondition}" style:apply-style-name="{concat( $style-id, 'P',$current-unit)}"/>
            <xsl:call-template name="style-map">
                <xsl:with-param name="number-format-name" select="$number-format-name"/>
                <xsl:with-param name="number-format-unit" select="substring-after($number-format-unit,';')"/>
                <xsl:with-param name="style-id" select="$style-id"/>
                <xsl:with-param name="format-type" select="$format-type"/>
                <xsl:with-param name="total-unit" select="$total-unit"/>
                <xsl:with-param name="current-unit" select="$current-unit +1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="general-number">
        <xsl:param name="number-format-unit"/>
        <xsl:call-template name="number-format-color">
            <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
        </xsl:call-template>
        <xsl:call-template name="number-format-currency">
            <xsl:with-param name="number-format-unit" select="$number-format-unit"/>
        </xsl:call-template>
        <xsl:choose>
            <xsl:when test="starts-with($number-format-unit,'&quot;')">
                <number:text>
                    <xsl:value-of select="substring-before(substring-after($number-format-unit,'&quot;'),'&quot;')"/>
                </number:text>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'@')">
                <number:text-content/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'-') or starts-with($number-format-unit,'$') or starts-with($number-format-unit,'￥')">
                <number:text>
                    <xsl:value-of select="substring($number-format-unit,1,1)"/>
                </number:text>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'YYYY')">
                <number:year number:style="long"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'YY')">
                <number:year number:style="rolong"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'MMMM')">
                <number:month number:style="long" number:textual="true"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'MMM')">
                <number:month number:style="rolong" number:textual="true"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'DD')">
                <number:day number:style="long"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'D')">
                <number:day number:style="rolong"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[HH]')">
                <number:hours number:style="long"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'HH')">
                <number:hours number:style="long"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'H')">
                <number:hours/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'SS.00')">
                <number:seconds number:style="long" number:decimal-places="2"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'SS')">
                <number:seconds number:style="long"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'S')">
                <number:seconds/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'AM/PM')">
                <number:am-pm/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'NNNN')">
                <number:day-of-week number:style="long"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'NNN')">
                <number:day-of-week/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'QQ')">
                <number:quarter number:style="long"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'Q')">
                <number:quarter/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'WW')">
                <number:week-of-year/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'MM')">
                <xsl:choose>
                    <xsl:when test="starts-with(substring($number-format-unit,3),'S') or (starts-with(substring($number-format-unit,3),'&quot;')  and starts-with(substring-after(substring-after($number-format-unit,'&quot;'),'&quot;'),'S'))">
                        <number:minutes number:style="long"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <number:month number:style="long"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'M')">
                <xsl:choose>
                    <xsl:when test="starts-with(substring($number-format-unit,2),'S') or (starts-with(substring($number-format-unit,2),'&quot;') and starts-with(substring-after(substring-after($number-format-unit,'&quot;'),'&quot;'),'S'))">
                        <number:minutes/>
                    </xsl:when>
                    <xsl:otherwise>
                        <number:month/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'#') or starts-with($number-format-unit,'0')">
                <xsl:variable name="digits-part">
                    <xsl:choose>
                        <xsl:when test="contains($number-format-unit,'&quot;')">
                            <xsl:value-of select="substring-before($number-format-unit,'&quot;')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$number-format-unit"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="decimal-integer-exponent-fraction">
                    <xsl:with-param name="digits-part" select="$digits-part"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
        <xsl:variable name="unit-length">
            <xsl:choose>
                <xsl:when test="starts-with($number-format-unit,'[value()')">
                    <xsl:value-of select="string-length(substring-before($number-format-unit,']')) +2"/>
                </xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[NatNum')">
                    <xsl:value-of select="string-length(substring-before($number-format-unit,']')) +2"/>
                </xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[$-804]')">8</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'&quot;')">
                    <xsl:value-of select="string-length(substring-before(substring-after($number-format-unit,'&quot;'),'&quot;')) +3"/>
                </xsl:when>
                <xsl:when test="starts-with($number-format-unit,'@')">2</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'-') or starts-with($number-format-unit,'$') or starts-with($number-format-unit,'￥')">2</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'YYYY')">5</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'YY')">3</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'MMMM')">5</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'MMM')">4</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'MM')">3</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'M')">2</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'DD')">3</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'D')">2</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[HH]')">5</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'HH')">3</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'H')">2</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'SS.00')">6</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'SS')">3</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'S')">2</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'AM/PM')">6</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'NNNN')">5</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'NNN')">4</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'QQ')">3</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'Q')">2</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'WW')">3</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'#') or starts-with($number-format-unit,'0')">
                    <xsl:choose>
                        <xsl:when test="contains($number-format-unit,'&quot;')">
                            <xsl:value-of select="string-length(substring-before($number-format-unit,'&quot;')) +1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="string-length($number-format-unit) +1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$unit-length &gt;1 and $unit-length &lt;=string-length($number-format-unit)">
            <xsl:call-template name="general-number">
                <xsl:with-param name="number-format-unit" select="substring($number-format-unit,$unit-length)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="decimal-integer-exponent-fraction">
        <xsl:param name="digits-part"/>
        <xsl:variable name="decimal-digits">
            <xsl:choose>
                <xsl:when test="contains($digits-part,'.')">
                    <xsl:choose>
                        <xsl:when test="contains($digits-part,' ')">
                            <xsl:value-of select="string-length(substring-before(substring-after($digits-part,'.'),' '))"/>
                        </xsl:when>
                        <xsl:when test="contains(substring-after($digits-part,'.'),',')">
                            <xsl:value-of select="string-length(substring-before(substring-after($digits-part,'.'),','))"/>
                        </xsl:when>
                        <xsl:when test="contains($digits-part,'E')">
                            <xsl:value-of select="string-length(substring-before(substring-after($digits-part,'.'),'E'))"/>
                        </xsl:when>
                        <xsl:when test="contains($digits-part,'e')">
                            <xsl:value-of select="string-length(substring-before(substring-after($digits-part,'.'),'e'))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="string-length(substring-after($digits-part,'.'))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="decimal-replacement">
            <xsl:choose>
                <xsl:when test="contains($digits-part,'.')">
                    <xsl:choose>
                        <xsl:when test="contains($digits-part,' ') and contains(substring-before(substring-after($digits-part,'.'),' '),'#')">true</xsl:when>
                        <xsl:when test="contains($digits-part,'E') and contains(substring-before(substring-after($digits-part,'.'),'E'),'#')">true</xsl:when>
                        <xsl:when test="contains($digits-part,'e') and contains(substring-before(substring-after($digits-part,'.'),'e'),'#')">true</xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="contains(substring-after($digits-part,'.'),'#')">true</xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="integer-digits">
            <xsl:choose>
                <xsl:when test="contains($digits-part,'.')">
                    <xsl:value-of select="string-length(substring-before($digits-part,'.')) - string-length(translate(substring-before($digits-part,'.'),'0',''))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="string-length($digits-part) - string-length(translate($digits-part,'0',''))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="factor-digits">
            <xsl:call-template name="display-factor-digits">
                <xsl:with-param name="digits-part" select="$digits-part"/>
                <xsl:with-param name="count" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="grouping">
            <xsl:choose>
                <xsl:when test="(string-length($digits-part) - string-length(translate($digits-part,',',''))) &gt;$factor-digits">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="exponent-digits">
            <xsl:choose>
                <xsl:when test="contains($digits-part,'E')">
                    <xsl:value-of select="string-length(substring-after($digits-part,'E')) -1"/>
                </xsl:when>
                <xsl:when test="contains($digits-part,'e')">
                    <xsl:value-of select="string-length(substring-after($digits-part,'e')) -1"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="numerator-digits">
            <xsl:choose>
                <xsl:when test="contains($digits-part,' ')">
                    <xsl:value-of select="string-length(substring-before(substring-after($digits-part,' '),'/'))"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="denominator-digits">
            <xsl:choose>
                <xsl:when test="contains($digits-part,' ')">
                    <xsl:value-of select="string-length(substring-after(substring-after($digits-part,' '),'/'))"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="number-type">
            <xsl:choose>
                <xsl:when test="$exponent-digits &gt;0">number:scientific-number</xsl:when>
                <xsl:when test="($numerator-digits &gt;0) or ($denominator-digits &gt;0)">number:fraction</xsl:when>
                <xsl:otherwise>number:number</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$number-type}">
            <xsl:if test="$decimal-digits &gt;=0">
                <xsl:attribute name="number:decimal-places"><xsl:value-of select="$decimal-digits"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$decimal-replacement='true'">
                <xsl:attribute name="number:decimal-replacement"/>
            </xsl:if>
            <xsl:if test="$integer-digits &gt;=0">
                <xsl:attribute name="number:min-integer-digits"><xsl:value-of select="$integer-digits"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$grouping='true'">
                <xsl:attribute name="number:grouping"><xsl:value-of select="$grouping"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$factor-digits &gt;0">
                <xsl:attribute name="number:display-factor"><xsl:choose><xsl:when test="$factor-digits=1">1000</xsl:when><xsl:when test="$factor-digits=2">1000000</xsl:when><xsl:when test="$factor-digits=3">1000000000</xsl:when><xsl:when test="$factor-digits=4">1000000000000</xsl:when><xsl:when test="$factor-digits=5">1000000000000000</xsl:when><xsl:when test="$factor-digits=6">1000000000000000000</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:if>
            <xsl:if test="$exponent-digits &gt;0">
                <xsl:attribute name="number:min-exponent-digits"><xsl:value-of select="$exponent-digits"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$numerator-digits &gt;0">
                <xsl:attribute name="number:min-numerator-digits"><xsl:value-of select="$numerator-digits"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$denominator-digits &gt;0">
                <xsl:attribute name="number:min-denominator-digits"><xsl:value-of select="$denominator-digits"/></xsl:attribute>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="number-format-color">
        <xsl:param name="number-format-unit"/>
        <xsl:choose>
            <xsl:when test="starts-with($number-format-unit,'[Black]')">
                <style:text-properties fo:color="#000000"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[Blue]')">
                <style:text-properties fo:color="#0000ff"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[Cyan]')">
                <style:text-properties fo:color="#00ffff"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[Green]')">
                <style:text-properties fo:color="#00ff00"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[Magenta]')">
                <style:text-properties fo:color="#ff00ff"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[Red]')">
                <style:text-properties fo:color="#ff0000"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[White]')">
                <style:text-properties fo:color="#ffffff"/>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[Yellow]')">
                <style:text-properties fo:color="#ffff00"/>
            </xsl:when>
        </xsl:choose>
        <xsl:variable name="unit-length">
            <xsl:choose>
                <xsl:when test="starts-with($number-format-unit,'[Black]')">8</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[Blue]')">7</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[Cyan]')">7</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[Green]')">8</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[Magenta]')">10</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[Red]')">6</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[White]')">8</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[Yellow]')">9</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$unit-length &gt;1 and $unit-length &lt;=string-length($number-format-unit)">
            <xsl:call-template name="general-number">
                <xsl:with-param name="number-format-unit" select="substring($number-format-unit,$unit-length)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="number-format-currency">
        <xsl:param name="number-format-unit"/>
        <xsl:choose>
            <xsl:when test="starts-with($number-format-unit,'[$￥-804]')">
                <number:currency-symbol number:language="zh" number:country="CN">￥</number:currency-symbol>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[$$-409]')">
                <number:currency-symbol number:language="en" number:country="US">$</number:currency-symbol>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[$$-2C0A]')">
                <number:currency-symbol number:language="es" number:country="AR">$</number:currency-symbol>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[$$-C0C]')">
                <number:currency-symbol number:language="fr" number:country="CA">$</number:currency-symbol>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[$CNY]')">
                <number:currency-symbol>CNY</number:currency-symbol>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'[$AFA]')">
                <number:currency-symbol>AFA</number:currency-symbol>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'CNY')">
                <number:currency-symbol>CNY</number:currency-symbol>
            </xsl:when>
            <xsl:when test="starts-with($number-format-unit,'CCC')">
                <number:currency-symbol>CCC</number:currency-symbol>
            </xsl:when>
        </xsl:choose>
        <xsl:variable name="unit-length">
            <xsl:choose>
                <xsl:when test="starts-with($number-format-unit,'[$￥-804]')">9</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[$$-409]')">9</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[$$-2C0A]')">10</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[$$-C0C]')">9</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[$CNY]')">7</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'[$AFA]')">7</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'CNY')">4</xsl:when>
                <xsl:when test="starts-with($number-format-unit,'CCC')">4</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$unit-length &gt;1 and $unit-length &lt;=string-length($number-format-unit)">
            <xsl:call-template name="general-number">
                <xsl:with-param name="number-format-unit" select="substring($number-format-unit,$unit-length)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="display-factor-digits">
        <xsl:param name="digits-part"/>
        <xsl:param name="count"/>
        <xsl:choose>
            <xsl:when test="not(substring($digits-part,string-length($digits-part),1) =',')">
                <xsl:value-of select="$count"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="display-factor-digits">
                    <xsl:with-param name="digits-part" select="substring($digits-part,1,string-length($digits-part) -1)"/>
                    <xsl:with-param name="count" select="$count +1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="element-attribute">
        <xsl:param name="number-format-unit"/>
        <xsl:if test="contains($number-format-unit,'[HH]')">
            <xsl:attribute name="number:truncate-on-overflow">false</xsl:attribute>
        </xsl:if>
        <xsl:if test="starts-with($number-format-unit,'[NatNum1]')">
            <xsl:attribute name="number:transliteration-format">一</xsl:attribute>
            <xsl:attribute name="number:transliteration-style">short</xsl:attribute>
        </xsl:if>
        <xsl:if test="starts-with($number-format-unit,'[NatNum2]')">
            <xsl:attribute name="number:transliteration-format">壹</xsl:attribute>
            <xsl:attribute name="number:transliteration-style">short</xsl:attribute>
        </xsl:if>
        <xsl:if test="starts-with($number-format-unit,'[NatNum3]')">
            <xsl:attribute name="number:transliteration-format">１</xsl:attribute>
            <xsl:attribute name="number:transliteration-style">short</xsl:attribute>
        </xsl:if>
        <xsl:if test="starts-with($number-format-unit,'[NatNum4]')">
            <xsl:attribute name="number:transliteration-format">一</xsl:attribute>
            <xsl:attribute name="number:transliteration-style">long</xsl:attribute>
        </xsl:if>
        <xsl:if test="starts-with($number-format-unit,'[NatNum5]')">
            <xsl:attribute name="number:transliteration-format">壹</xsl:attribute>
            <xsl:attribute name="number:transliteration-style">long</xsl:attribute>
        </xsl:if>
        <xsl:if test="starts-with($number-format-unit,'[NatNum6]')">
            <xsl:attribute name="number:transliteration-format">１</xsl:attribute>
            <xsl:attribute name="number:transliteration-style">long</xsl:attribute>
        </xsl:if>
        <xsl:if test="starts-with($number-format-unit,'[NatNum7]')">
            <xsl:attribute name="number:transliteration-format">一</xsl:attribute>
            <xsl:attribute name="number:transliteration-style">medium</xsl:attribute>
        </xsl:if>
        <xsl:if test="starts-with($number-format-unit,'[NatNum8]')">
            <xsl:attribute name="number:transliteration-format">壹</xsl:attribute>
            <xsl:attribute name="number:transliteration-style">medium</xsl:attribute>
        </xsl:if>
        <xsl:if test="starts-with($number-format-unit,'[NatNum0]')">
            <xsl:attribute name="number:transliteration-format">1</xsl:attribute>
            <xsl:attribute name="number:transliteration-style">short</xsl:attribute>
        </xsl:if>
        <xsl:if test="contains($number-format-unit,'[$-804]')">
            <xsl:attribute name="number:transliteration-language">zh</xsl:attribute>
            <xsl:attribute name="number:transliteration-country">CN</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:key name="pz" match="/uof:UOF/uof:对象集/图:图形" use="@图:标识符"/>
    <xsl:template match="表:批注" mode="body">
        <xsl:element name="office:annotation">
            <xsl:if test="@表:是否显示 = 'true'">
                <xsl:attribute name="office:display">true</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="draw:style-name"><xsl:value-of select="uof:锚点/@uof:图形引用"/></xsl:attribute>
            <xsl:attribute name="svg:height"><xsl:value-of select="concat(uof:锚点/@uof:高度,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:x"><xsl:value-of select="concat(uof:锚点/@uof:x坐标,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:y"><xsl:value-of select="concat(uof:锚点/@uof:y坐标,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:width"><xsl:value-of select="concat(uof:锚点/@uof:宽度,$uofUnit)"/></xsl:attribute>
            <xsl:variable name="w">
                <xsl:value-of select="./uof:锚点/@uof:图形引用"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="key('pz',$w)/图:文本内容/字:句/字:文本串">
                    <text:p>
                        <xsl:for-each select="key('pz',$w)/图:文本内容/字:句">
                            <text:span>
                                <xsl:if test="字:句属性/@字:式样引用">
                                    <xsl:attribute name="text:style-name"><xsl:value-of select="字:句属性/@字:式样引用"/></xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="字:文本串"/>
                            </text:span>
                        </xsl:for-each>
                    </text:p>
                </xsl:when>
            </xsl:choose>
            <!--xsl:if test="图:文本内容/字:段落/字:句/字:文本串">
                <text:p>
                    <xsl:call-template name="create-comment-data-content">
                        <xsl:with-param name="style-id" select="../@表:式样引用"/>
                    </xsl:call-template>
                </text:p>
            </xsl:if-->
        </xsl:element>
    </xsl:template>
    <xsl:template name="auto-filter-condition">
        <xsl:param name="condition-set"/>
        <xsl:param name="zone-left-column-num"/>
        <xsl:if test="$condition-set">
            <xsl:variable name="first-condition" select="$condition-set[1]"/>
            <xsl:element name="table:filter-condition">
                <xsl:attribute name="table:field-number"><xsl:value-of select="$first-condition/@表:列号 - $zone-left-column-num"/></xsl:attribute>
                <xsl:attribute name="office:value"><xsl:choose><xsl:when test="$first-condition/表:普通"><xsl:value-of select="$first-condition/表:普通/@表:值"/></xsl:when><xsl:when test="$first-condition/表:自定义"><xsl:value-of select="$first-condition/表:自定义/表:操作条件/表:值"/></xsl:when></xsl:choose></xsl:attribute>
                <xsl:variable name="operator">
                    <xsl:choose>
                        <xsl:when test="$first-condition/表:普通">
                            <xsl:variable name="general" select="$first-condition/表:普通/@表:类型"/>
                            <xsl:choose>
                                <xsl:when test="$general ='topitem'">top values</xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="$first-condition/表:自定义">
                            <xsl:variable name="operator-text" select="$first-condition/表:自定义/表:操作条件/表:操作码/text()"/>
                            <xsl:choose>
                                <xsl:when test="$operator-text ='less than'">&lt;</xsl:when>
                                <xsl:when test="$operator-text ='greater than'">&gt;</xsl:when>
                                <xsl:when test="$operator-text ='equal to'">
                                    <xsl:value-of select="'='"/>
                                </xsl:when>
                                <xsl:when test="$operator-text ='greater than or equal to'">
                                    <xsl:value-of select="'&gt;='"/>
                                </xsl:when>
                                <xsl:when test="$operator-text ='less than or equal to'">
                                    <xsl:value-of select="'&lt;='"/>
                                </xsl:when>
                                <xsl:when test="$operator-text ='not equal to'">
                                    <xsl:value-of select="'!='"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="table:operator"><xsl:value-of select="$operator"/></xsl:attribute>
            </xsl:element>
            <xsl:call-template name="auto-filter-condition">
                <xsl:with-param name="condition-set" select="$condition-set[position()!=1]"/>
                <xsl:with-param name="zone-left-column-num" select="$zone-left-column-num"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
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
    <xsl:template name="translate-expression2">
        <xsl:param name="expression2"/>
        <xsl:choose>
            <xsl:when test="contains($expression2,':')">
                <xsl:variable name="column-one">
                    <xsl:value-of select="substring(substring-before($expression2,':'),1,1)"/>
                </xsl:variable>
                <xsl:variable name="row-one">
                    <xsl:value-of select="substring(substring-before($expression2,':'),2)"/>
                </xsl:variable>
                <xsl:variable name="column-two">
                    <xsl:value-of select="substring(substring-after($expression2,':'),1,1)"/>
                </xsl:variable>
                <xsl:variable name="row-two">
                    <xsl:value-of select="substring(substring-after($expression2,':'),2)"/>
                </xsl:variable>
                <xsl:variable name="column-value1">
                    <xsl:call-template name="character-to-column">
                        <xsl:with-param name="column-value" select="$column-one"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="column-value2">
                    <xsl:call-template name="character-to-column">
                        <xsl:with-param name="column-value" select="$column-two"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('R',$row-one,'C',$column-value1,':','R',$row-two,'C',$column-value2)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="column-one">
                    <xsl:value-of select="substring($expression2,1,1)"/>
                </xsl:variable>
                <xsl:variable name="row-one">
                    <xsl:value-of select="substring($expression2,2)"/>
                </xsl:variable>
                <xsl:variable name="column-value1">
                    <xsl:call-template name="character-to-column">
                        <xsl:with-param name="column-value" select="$column-one"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('R',$row-one,'C',$column-value1)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="character-to-column">
        <xsl:param name="column-value"/>
        <xsl:choose>
            <xsl:when test="$column-value= 'A'">1</xsl:when>
            <xsl:when test="$column-value= 'B'">2</xsl:when>
            <xsl:when test="$column-value= 'C'">3</xsl:when>
            <xsl:when test="$column-value= 'D'">4</xsl:when>
            <xsl:when test="$column-value= 'E'">5</xsl:when>
            <xsl:when test="$column-value= 'F'">6</xsl:when>
            <xsl:when test="$column-value= 'G'">7</xsl:when>
            <xsl:when test="$column-value= 'H'">8</xsl:when>
            <xsl:when test="$column-value= 'I'">9</xsl:when>
            <xsl:when test="$column-value= 'J'">10</xsl:when>
            <xsl:when test="$column-value= 'K'">11</xsl:when>
            <xsl:when test="$column-value= 'L'">12</xsl:when>
            <xsl:when test="$column-value= 'M'">13</xsl:when>
            <xsl:when test="$column-value= 'N'">14</xsl:when>
            <xsl:when test="$column-value= 'O'">15</xsl:when>
            <xsl:when test="$column-value= 'P'">16</xsl:when>
            <xsl:when test="$column-value= 'Q'">17</xsl:when>
            <xsl:when test="$column-value= 'R'">18</xsl:when>
            <xsl:when test="$column-value= 'S'">19</xsl:when>
            <xsl:when test="$column-value= 'T'">20</xsl:when>
            <xsl:when test="$column-value= 'U'">21</xsl:when>
            <xsl:when test="$column-value= 'V'">22</xsl:when>
            <xsl:when test="$column-value= 'W'">23</xsl:when>
            <xsl:when test="$column-value= 'X'">24</xsl:when>
            <xsl:when test="$column-value= 'Y'">25</xsl:when>
            <xsl:when test="$column-value= 'Z'">26</xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <!--chenjh end 20050611-->
    <xsl:template name="工作表属性">
        <!--office:settings-->
        <xsl:variable name="sheetprop" select="/uof:UOF/uof:电子表格/表:主体/表:工作表"/>
        <config:config-item-set config:name="ooo:view-settings">
            <xsl:variable name="ratio" select="15"/>
            <xsl:if test="/uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/表:行/表:单元格/表:数据/字:句/字:修订开始">
                <config:config-item-set config:name="TrackedChangesViewSettings">
                    <config:config-item config:name="ShowChanges" config:type="boolean">true</config:config-item>
                    <config:config-item config:name="ShowAcceptedChanges" config:type="boolean">false</config:config-item>
                    <config:config-item config:name="ShowRejectedChanges" config:type="boolean">false</config:config-item>
                    <config:config-item config:name="ShowChangesByDatetime" config:type="boolean">false</config:config-item>
                    <config:config-item config:name="ShowChangesByDatetimeMode" config:type="short">0</config:config-item>
                    <config:config-item config:name="ShowChangesByDatetimeFirstDatetime" config:type="datetime">2007-01-17T10:56:46.21</config:config-item>
                    <config:config-item config:name="ShowChangesByDatetimeSecondDatetime" config:type="datetime">2007-01-17T10:56:46.21</config:config-item>
                    <config:config-item config:name="ShowChangesByAuthor" config:type="boolean">false</config:config-item>
                    <config:config-item config:name="ShowChangesByAuthorName" config:type="string"/>
                    <config:config-item config:name="ShowChangesByComment" config:type="boolean">false</config:config-item>
                    <config:config-item config:name="ShowChangesByCommentText" config:type="string"/>
                    <config:config-item config:name="ShowChangesByRanges" config:type="boolean">false</config:config-item>
                    <config:config-item config:name="ShowChangesByRangesList" config:type="string"/>
                </config:config-item-set>
            </xsl:if>
            <config:config-item-map-indexed config:name="Views">
                <config:config-item-map-entry>
                    <config:config-item config:name="ViewId" config:type="string">View1</config:config-item>
                    <config:config-item-map-named config:name="Tables">
                        <xsl:for-each select="$sheetprop/表:工作表属性/表:视图">
                            <xsl:element name="config:config-item-map-entry">
                                <xsl:attribute name="config:name"><xsl:value-of select="ancestor::表:工作表/@表:名称"/></xsl:attribute>
                                <xsl:element name="config:config-item">
                                    <xsl:attribute name="config:name">HorizontalSplitMode</xsl:attribute>
                                    <xsl:attribute name="config:type">short</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="表:冻结 and 表:冻结/@表:列号!=0">2</xsl:when>
                                        <xsl:when test="表:冻结 and 表:冻结/@表:列号=0">0</xsl:when>
                                        <xsl:when test="表:拆分 and 表:拆分/@表:宽度!=0">1</xsl:when>
                                        <xsl:when test="表:拆分 and 表:拆分/@表:宽度=0">0</xsl:when>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:element name="config:config-item">
                                    <xsl:attribute name="config:name">VerticalSplitMode</xsl:attribute>
                                    <xsl:attribute name="config:type">short</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="表:冻结 and 表:冻结/@表:行号!=0">2</xsl:when>
                                        <xsl:when test="表:冻结 and 表:冻结/@表:行号=0">0</xsl:when>
                                        <xsl:when test="表:拆分 and 表:拆分/@表:高度!=0">1</xsl:when>
                                        <xsl:when test="表:拆分 and 表:拆分/@表:高度=0">0</xsl:when>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:element name="config:config-item">
                                    <xsl:attribute name="config:name">HorizontalSplitPosition</xsl:attribute>
                                    <xsl:attribute name="config:type">int</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="表:冻结 and 表:冻结/@表:列号=0">0</xsl:when>
                                        <xsl:when test="表:冻结 and 表:冻结/@表:列号!=0">
                                            <xsl:value-of select="表:冻结/@表:列号"/>
                                        </xsl:when>
                                        <xsl:when test="表:拆分 and 表:拆分/@表:宽度=0">0</xsl:when>
                                        <xsl:when test="表:拆分 and 表:拆分/@表:宽度!=0">
                                            <xsl:value-of select="表:拆分/@表:宽度"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:element name="config:config-item">
                                    <xsl:attribute name="config:name">VerticalSplitPosition</xsl:attribute>
                                    <xsl:attribute name="config:type">int</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="表:冻结 and 表:冻结/@表:行号=0">0</xsl:when>
                                        <xsl:when test="表:冻结 and 表:冻结/@表:行号!=0">
                                            <xsl:value-of select="表:冻结/@表:行号"/>
                                        </xsl:when>
                                        <xsl:when test="表:拆分 and 表:拆分/@表:高度=0">0</xsl:when>
                                        <xsl:when test="表:拆分 and 表:拆分/@表:高度!=0">
                                            <xsl:value-of select="表:拆分/@表:高度"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:variable name="position-top">
                                    <xsl:choose>
                                        <xsl:when test="$sheetprop/表:工作表属性/表:视图/表:最上行">
                                            <xsl:value-of select="//表:工作表属性/表:视图/表:最上行"/>
                                        </xsl:when>
                                        <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="position-left">
                                    <xsl:choose>
                                        <xsl:when test="$sheetprop/表:工作表属性/表:视图/表:最左列">
                                            <xsl:value-of select="$sheetprop/表:工作表属性/表:视图/表:最左列"/>
                                        </xsl:when>
                                        <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <config:config-item config:name="PositionRight" config:type="int">
                                    <xsl:value-of select="$position-left"/>
                                </config:config-item>
                                <config:config-item config:name="PositionBottom" config:type="int">
                                    <xsl:value-of select="$position-top"/>
                                </config:config-item>
                            </xsl:element>
                        </xsl:for-each>
                    </config:config-item-map-named>
                    <xsl:if test="$sheetprop/表:工作表属性/表:视图/表:当前视图">
                        <xsl:element name="config:config-item">
                            <xsl:attribute name="config:name">ShowPageBreakPreview</xsl:attribute>
                            <xsl:attribute name="config:type">boolean</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="$sheetprop/表:工作表属性/表:视图/表:当前视图/@表:类型='normal'">false</xsl:when>
                                <xsl:otherwise>true</xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$sheetprop/表:工作表属性/表:视图/表:网格">
                        <xsl:element name="config:config-item">
                            <xsl:attribute name="config:name">ShowGrid</xsl:attribute>
                            <xsl:attribute name="config:type">boolean</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="$sheetprop/表:工作表属性/表:视图/表:网格/@表:值=1 or $sheetprop/表:工作表属性/表:视图/表:网格/@表:值='true'">true</xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$sheetprop/表:工作表属性/表:视图/表:网格颜色">
                        <xsl:element name="config:config-item">
                            <xsl:attribute name="config:name">GridColor</xsl:attribute>
                            <xsl:attribute name="config:type">long</xsl:attribute>
                            <xsl:call-template name="transform-hex-to-decimal">
                                <xsl:with-param name="number" select="//表:视图/表:网格颜色/text()"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$sheetprop/表:工作表属性/表:视图/表:选中">
                        <xsl:element name="config:config-item">
                            <xsl:attribute name="config:name">ActiveTable</xsl:attribute>
                            <xsl:attribute name="config:type">string</xsl:attribute>
                            <xsl:value-of select="$sheetprop/表:工作表属性/表:视图[表:选中]/ancestor::表:工作表/@表:名称"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$sheetprop/表:工作表属性/表:视图/表:缩放">
                        <config:config-item config:name="ZoomValue" config:type="int">
                            <xsl:value-of select="$sheetprop/表:工作表属性/表:视图/表:缩放/text()"/>
                        </config:config-item>
                    </xsl:if>
                    <xsl:if test="$sheetprop/表:工作表属性/表:视图/表:分页缩放">
                        <config:config-item config:name="PageViewZoomValue" config:type="int">
                            <xsl:value-of select="$sheetprop/表:工作表属性/表:视图/表:分页缩放/text()"/>
                        </config:config-item>
                    </xsl:if>
                </config:config-item-map-entry>
            </config:config-item-map-indexed>
        </config:config-item-set>
    </xsl:template>
    <xsl:template name="create-page-master">
        <xsl:param name="worksheetoptions"/>
        <xsl:for-each select="$worksheetoptions">
            <xsl:element name="style:page-layout">
                <xsl:attribute name="style:name"><xsl:call-template name="encode-as-nc-name"><xsl:with-param name="string" select="concat( 'pm_', ../@表:名称)"/></xsl:call-template></xsl:attribute>
                <xsl:element name="style:page-layout-properties">
                    <xsl:if test="表:页面设置/表:纸张/@uof:宽度">
                        <xsl:attribute name="fo:page-width"><xsl:value-of select="concat(表:页面设置/表:纸张/@uof:宽度,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="表:页面设置/表:纸张/@uof:高度">
                        <xsl:attribute name="fo:page-height"><xsl:value-of select="concat(表:页面设置/表:纸张/@uof:高度,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="表:页面设置/表:纸张方向">
                        <xsl:attribute name="style:print-orientation"><xsl:value-of select="表:页面设置/表:纸张方向"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="表:页面设置/表:缩放">
                        <xsl:attribute name="style:scale-to"><xsl:value-of select="concat(表:页面设置/表:缩放,'%')"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="/uof:UOF/uof:电子表格/表:主体/表:工作表/@表:背景">
                        <xsl:attribute name="fo:background-color"><xsl:value-of select="/uof:UOF/uof:电子表格/表:主体/表:工作表/@表:背景"/></xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="style:first-page-number">continue</xsl:attribute>
                    <xsl:if test="表:页面设置/表:页边距">
                        <xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(表:页面设置/表:页边距/@uof:上,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(表:页面设置/表:页边距/@uof:下,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(表:页面设置/表:页边距/@uof:左,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(表:页面设置/表:页边距/@uof:右,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="表:页面设置/表:打印/@表:先列后行='true'">
                        <xsl:attribute name="style:print-page-order">ltr</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="表:页面设置/表:垂直对齐/@表:对齐方式">
                        <xsl:attribute name="style:table-centering">vertical</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="表:页面设置/表:水平对齐/@表:对齐方式">
                        <xsl:attribute name="style:table-centering">horizontal</xsl:attribute>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="style:header-style">
                    <xsl:element name="style:header-footer-properties">
                        <xsl:attribute name="fo:min-height">0.75cm</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="表:页面设置/表:页眉页脚/@uof:边距">
                                <xsl:attribute name="fo:margin-bottom"><xsl:call-template name="convert2cm"><xsl:with-param name="value" select="concat(表:页面设置/表:页眉页脚/@uof:边距,'pt')"/></xsl:call-template><xsl:text>cm</xsl:text></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="fo:margin-bottom">0.25cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="style:footer-style">
                    <xsl:element name="style:header-footer-properties">
                        <xsl:attribute name="fo:min-height">0.75cm</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="表:页面设置/表:页眉页脚/@uof:边距">
                                <xsl:attribute name="fo:margin-top"><xsl:call-template name="convert2cm"><xsl:with-param name="value" select="concat(表:页面设置/表:页眉页脚/@uof:边距,'pt')"/></xsl:call-template><xsl:text>cm</xsl:text></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="fo:margin-top">0.25cm</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="字:文本串">
        <xsl:value-of select="text()"/>
    </xsl:template>
    <xsl:template match="字:换行符">
        <xsl:element name="text:line-break"/>
    </xsl:template>
    <xsl:template match="字:制表符">
        <xsl:element name="text:tab-stop"/>
    </xsl:template>
    <xsl:template match="字:区域开始">
        <xsl:if test="@字:类型='hyperlink'">
            <xsl:variable name="superlink" select="//uof:超级链接[@uof:标识符=current()/@字:标识符]"/>
            <xsl:element name="text:a">
                <xsl:attribute name="xlink:href"><xsl:value-of select="$superlink/@uof:目标"/></xsl:attribute>
                <xsl:value-of select="$superlink/@uof:提示"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="字:空格符">
        <xsl:element name="text:s">
            <xsl:if test="@字:个数">
                <xsl:attribute name="text:c"><xsl:value-of select="@字:个数"/></xsl:attribute>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="create-page-header-footer-text-p">
        <xsl:param name="paragragh-set"/>
        <xsl:choose>
            <xsl:when test="$paragragh-set">
                <xsl:element name="text:p">
                    <xsl:for-each select="$paragragh-set[1]/字:句">
                        <xsl:choose>
                            <xsl:when test="not(字:句属性)">
                                <xsl:apply-templates select="字:文本串 | 字:空格符 | 字:换行符"/>
                            </xsl:when>
                            <xsl:when test="字:句属性">
                                <xsl:element name="text:span">
                                    <xsl:attribute name="text:style-name"><xsl:value-of select="//uof:句式样[@字:标识符=current()/字:句属性/@字:式样引用]/@字:名称"/></xsl:attribute>
                                    <xsl:apply-templates select="字:空格符 | 字:文本串 | 字:换行符 | 字:制表符"/>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:element>
                <xsl:call-template name="create-page-header-footer-text-p">
                    <xsl:with-param name="paragragh-set" select="$paragragh-set[position()!=1]"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <!--Redoffice comment lilliang SC0016 06.02.16 -->
    <!--新增内容-->
    <xsl:template match="字:段落">
        <xsl:element name="text:p">
            <xsl:choose>
                <xsl:when test="字:段落属性">
                    <xsl:attribute name="text:style-name">P<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落[字:段落属性]"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="generate-id(ancestor::字:主体/descendant::字:段落[1]) = generate-id(.)">
                    <!-- create the leading paragraph style name in one section for master page style application, glu -->
                    <xsl:variable name="paragraph-number">
                        <xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落[字:段落属性]"/>
                    </xsl:variable>
                    <xsl:attribute name="text:style-name">P<xsl:value-of select="number($paragraph-number)"/>_1</xsl:attribute>
                </xsl:when>
                <xsl:when test="not(字:段落属性) and (descendant::字:分栏符 or ancestor::字:分节/descendant::字:节属性[字:分栏/@字:栏数 &gt; 1])">
                    <xsl:attribute name="text:style-name">ColumnBreakPara</xsl:attribute>
                </xsl:when>
                <xsl:when test="字:句">
                    <xsl:apply-templates select="字:句/字:文本串"/>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!--Redoffice comment liliang end 06.02.16-->
    <xsl:template name="create-master-styles">
        <xsl:param name="worksheetoptions"/>
        <xsl:for-each select="$worksheetoptions">
            <xsl:element name="style:master-page">
                <xsl:attribute name="style:name"><xsl:call-template name="encode-as-nc-name"><xsl:with-param name="string" select="concat( 'TAB_', ../@表:名称)"/></xsl:call-template></xsl:attribute>
                <!--xsl:attribute name="style:page-layout-name"-->
                <xsl:attribute name="style:page-layout-name"><xsl:call-template name="encode-as-nc-name"><xsl:with-param name="string" select="concat( 'pm_', ../@表:名称)"/></xsl:call-template></xsl:attribute>
                <xsl:attribute name="style:display-name"><xsl:value-of select="concat( 'PageStyle_', ../@表:名称)"/></xsl:attribute>
                <style:header>
                    <xsl:for-each select="表:页面设置/表:页眉页脚">
                        <xsl:variable name="temp" select="@表:位置"/>
                        <xsl:choose>
                            <xsl:when test="contains($temp,'header')">
                                <xsl:if test="字:段落">
                                    <xsl:choose>
                                        <xsl:when test="@表:位置='headerleft'">
                                            <xsl:element name="style:region-left">
                                                <xsl:call-template name="create-page-header-footer-text-p">
                                                    <xsl:with-param name="paragragh-set" select="字:段落"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when test="@表:位置='headercenter'">
                                            <xsl:element name="style:region-center">
                                                <xsl:call-template name="create-page-header-footer-text-p">
                                                    <xsl:with-param name="paragragh-set" select="字:段落"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when test="@表:位置='headerright'">
                                            <xsl:element name="style:region-right">
                                                <xsl:call-template name="create-page-header-footer-text-p">
                                                    <xsl:with-param name="paragragh-set" select="字:段落"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise/>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:for-each>
                </style:header>
                <style:footer>
                    <xsl:for-each select="表:页面设置/表:页眉页脚">
                        <xsl:variable name="temp" select="@表:位置"/>
                        <xsl:choose>
                            <xsl:when test="contains($temp,'footer')">
                                <xsl:if test="字:段落">
                                    <xsl:choose>
                                        <xsl:when test="@表:位置='footerleft'">
                                            <xsl:element name="style:region-left">
                                                <xsl:call-template name="create-page-header-footer-text-p">
                                                    <xsl:with-param name="paragragh-set" select="字:段落"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when test="@表:位置='footercenter'">
                                            <xsl:element name="style:region-center">
                                                <xsl:call-template name="create-page-header-footer-text-p">
                                                    <xsl:with-param name="paragragh-set" select="字:段落"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when test="@表:位置='footerright'">
                                            <xsl:element name="style:region-right">
                                                <xsl:call-template name="create-page-header-footer-text-p">
                                                    <xsl:with-param name="paragragh-set" select="字:段落"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise/>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:for-each>
                </style:footer>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <!--xsl:template name="create-page-master">
    </xsl:template>
    <xsl:template match="表:页面设置">
    </xsl:template>

    <xsl:template name="create-master-styles">
    </xsl:template>
    <xsl:template  name="表:工作表属性">
    </xsl:template-->
    <!--00000000000-->
    <xsl:template match="uof:元数据">
        <office:meta>
            <xsl:if test="uof:创建应用程序">
                <meta:generator>
                    <xsl:value-of select="uof:创建应用程序"/>
                </meta:generator>
            </xsl:if>
            <xsl:if test="uof:标题">
                <dc:title>
                    <xsl:value-of select="uof:标题"/>
                </dc:title>
            </xsl:if>
            <xsl:if test="uof:摘要">
                <dc:description>
                    <xsl:value-of select="uof:摘要"/>
                </dc:description>
            </xsl:if>
            <xsl:if test="uof:主题">
                <dc:subject>
                    <xsl:value-of select="uof:主题"/>
                </dc:subject>
            </xsl:if>
            <xsl:if test="uof:作者">
                <meta:initial-creator>
                    <xsl:value-of select="uof:作者"/>
                </meta:initial-creator>
            </xsl:if>
            <xsl:if test="uof:创建日期">
                <meta:creation-date>
                    <xsl:value-of select="uof:创建日期"/>
                </meta:creation-date>
            </xsl:if>
            <xsl:if test="uof:最后作者">
                <dc:creator>
                    <xsl:value-of select="uof:最后作者"/>
                </dc:creator>
            </xsl:if>
            <xsl:if test="uof:编辑时间">
                <meta:editing-duration>
                    <xsl:value-of select="uof:编辑时间"/>
                </meta:editing-duration>
            </xsl:if>
            <dc:language/>
            <meta:keyword>
                <xsl:value-of select="uof:关键字集/uof:关键字"/>
            </meta:keyword>
            <xsl:if test="uof:编辑次数">
                <meta:editing-cycles>
                    <xsl:value-of select="uof:编辑次数"/>
                </meta:editing-cycles>
            </xsl:if>
            <xsl:if test="uof:分类">
                <meta:user-defined meta:name="Category">
                    <xsl:value-of select="uof:分类"/>
                </meta:user-defined>
            </xsl:if>
            <xsl:if test="uof:经理名称">
                <meta:user-defined meta:name="Manager">
                    <xsl:value-of select="uof:经理名称"/>
                </meta:user-defined>
            </xsl:if>
            <xsl:if test="uof:公司名称">
                <meta:user-defined meta:name="Company">
                    <xsl:value-of select="uof:公司名称"/>
                </meta:user-defined>
            </xsl:if>
            <xsl:apply-templates select="uof:用户自定义元数据集"/>
        </office:meta>
    </xsl:template>
    <xsl:template match="uof:用户自定义元数据集">
        <xsl:for-each select="uof:用户自定义元数据">
            <meta:user-defined meta:name="{@uof:名称}">
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
        <!-- dealing the range of row\column -->
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
        <!-- return value for the template condition-rc-str -->
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
    <!--chengxiuzhi 111111111111111111111111111111111111111111111111111111111111111-->
    <!-- measure_conversion.xsl Begin-->
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
    <!-- chenjh zhangying-->
    <xsl:template name="create-content-validations">
        <xsl:param name="validation-set"/>
        <xsl:if test="$validation-set">
            <xsl:variable name="first-validation" select="$validation-set[1]"/>
            <xsl:variable name="condition-text">
                <xsl:choose>
                    <xsl:when test="$first-validation/表:校验类型/text()='whole number'">
                        <xsl:choose>
                            <xsl:when test="$first-validation/表:操作码/text()='between' ">
                                <xsl:value-of select="concat('oooc:cell-content-is-whole-number() and cell-content-is-between','(',$first-validation/表:第一操作数/text(),',',$first-validation/表:第二操作数/text(),')')"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='not between'">
                                <xsl:value-of select="concat('oooc:cell-content-is-whole-number() and cell-content-is-not-between','(',$first-validation/表:第一操作数/text(),',',$first-validation/表:第二操作数/text(),')')"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-whole-number() and cell-content()=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='not equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-whole-number() and cell-content()!=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='greater than'">
                                <xsl:value-of select="concat('oooc:cell-content-is-whole-number() and cell-content()&gt;',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='less than'">
                                <xsl:value-of select="concat('oooc:cell-content-is-whole-number() and cell-content()&lt;',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='greater than or equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-whole-number() and cell-content()&gt;=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='less than or equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-whole-number() and cell-content()&lt;=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$first-validation/表:校验类型/text()='decimal'">
                        <xsl:choose>
                            <xsl:when test="$first-validation/表:操作码/text()='between' ">
                                <xsl:value-of select="concat('oooc:cell-content-is-decimal-number() and cell-content-is-between','(',$first-validation/表:第一操作数/text(),',',$first-validation/表:第二操作数/text(),')')"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='not between'">
                                <xsl:value-of select="concat('oooc:cell-content-is-decimal-number() and cell-content-is-not-between','(',$first-validation/表:第一操作数/text(),',',$first-validation/表:第二操作数/text(),')')"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-decimal-number() and cell-content()=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='not equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-decimal-number() and cell-content()!=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='greater than'">
                                <xsl:value-of select="concat('oooc:cell-content-is-decimal-number() and cell-content()&gt;',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='less than'">
                                <xsl:value-of select="concat('oooc:cell-content-is-decimal-number() and cell-content()&lt;',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='greater than or equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-decimal-number() and cell-content()&gt;=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='less than or equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-decimal-number() and cell-content()&lt;=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$first-validation/表:校验类型/text()='date'">
                        <xsl:choose>
                            <xsl:when test="$first-validation/表:操作码/text()='between' ">
                                <xsl:value-of select="concat('oooc:cell-content-is-date() and cell-content-is-between','(',$first-validation/表:第一操作数/text(),',',$first-validation/表:第二操作数/text(),')')"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='not between'">
                                <xsl:value-of select="concat('oooc:cell-content-is-date() and cell-content-is-not-between','(',$first-validation/表:第一操作数/text(),',',$first-validation/表:第二操作数/text(),')')"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-date() and cell-content()=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='not equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-date() and cell-content()!=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='greater than'">
                                <xsl:value-of select="concat('oooc:cell-content-is-date() and cell-content()&gt;',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='less than'">
                                <xsl:value-of select="concat('oooc:cell-content-is-date() and cell-content()&lt;',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='greater than or equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-date() and cell-content()&gt;=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='less than or equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-date() and cell-content()&lt;=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$first-validation/表:校验类型/text()='time'">
                        <xsl:choose>
                            <xsl:when test="$first-validation/表:操作码/text()='between' ">
                                <xsl:value-of select="concat('oooc:cell-content-is-time() and cell-content-is-between','(',$first-validation/表:第一操作数/text(),',',$first-validation/表:第二操作数/text(),')')"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='not between'">
                                <xsl:value-of select="concat('oooc:cell-content-is-time() and cell-content-is-not-between','(',$first-validation/表:第一操作数/text(),',',$first-validation/表:第二操作数/text(),')')"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-time() and cell-content()=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='not equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-time() and cell-content()!=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='greater than'">
                                <xsl:value-of select="concat('oooc:cell-content-is-time() and cell-content()&gt;',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='less than'">
                                <xsl:value-of select="concat('oooc:cell-content-is-time() and cell-content()&lt;',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='greater than or equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-time() and cell-content()&gt;=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='less than or equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-is-time() and cell-content()&lt;=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <!-- add 20060317 -->
                    <xsl:when test="$first-validation/表:校验类型/text()='cell range'">
                        <xsl:value-of select="concat('oooc:cell-content-is-in-list',$first-validation/表:第一操作数/text())"/>
                    </xsl:when>
                    <xsl:when test="$first-validation/表:校验类型/text()='list'">
                        <xsl:value-of select="concat('oooc:cell-content-is-in-list',$first-validation/表:第一操作数/text())"/>
                    </xsl:when>
                    <!-- add 20060317 end -->
                    <xsl:when test="$first-validation/表:校验类型/text()='text length'">
                        <xsl:choose>
                            <xsl:when test="$first-validation/表:操作码/text()='between' ">
                                <xsl:value-of select="concat('oooc:cell-content-text-length-is-between','(',$first-validation/表:第一操作数/text(),',',$first-validation/表:第二操作数/text(),')')"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='not between'">
                                <xsl:value-of select="concat('oooc:cell-content-text-length-is-not-between','(',$first-validation/表:第一操作数/text(),',',$first-validation/表:第二操作数/text(),')')"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-text-length()=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='not equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-text-length()!=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='greater than'">
                                <xsl:value-of select="concat('oooc:cell-content-text-length()&gt;',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='less than'">
                                <xsl:value-of select="concat('oooc:cell-content-text-length()&lt;',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='greater than or equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-text-length()&gt;=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                            <xsl:when test="$first-validation/表:操作码/text()='less than or equal to'">
                                <xsl:value-of select="concat('oooc:cell-content-text-length()&lt;=',$first-validation/表:第一操作数/text())"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:element name="table:content-validation">
                <xsl:attribute name="table:name"><xsl:value-of select="concat('val',count($first-validation/preceding-sibling::表:数据有效性)+1)"/></xsl:attribute>
                <xsl:attribute name="table:condition"><xsl:value-of select="$condition-text"/></xsl:attribute>
                <xsl:attribute name="table:allow-empty-cell"><xsl:value-of select="$first-validation/表:忽略空格/@表:值"/></xsl:attribute>
                <xsl:attribute name="table:base-cell-address"><xsl:value-of select="translate(substring-after($first-validation/表:区域/text(),':'),'$','')"/></xsl:attribute>
                <xsl:if test="$first-validation/表:输入提示">
                    <xsl:element name="table:help-message">
                        <xsl:attribute name="table:title"><xsl:value-of select="$first-validation/表:输入提示/@表:标题"/></xsl:attribute>
                        <xsl:attribute name="table:display"><xsl:value-of select="$first-validation/表:输入提示/@表:显示"/></xsl:attribute>
                        <xsl:element name="text:p">
                            <xsl:value-of select="$first-validation/表:输入提示/@表:内容"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$first-validation/表:错误提示">
                    <xsl:element name="table:error-message">
                        <xsl:attribute name="table:title"><xsl:value-of select="$first-validation/表:错误提示/@表:标题"/></xsl:attribute>
                        <xsl:attribute name="table:display"><xsl:value-of select="$first-validation/表:错误提示/@表:显示"/></xsl:attribute>
                        <xsl:attribute name="table:message-type"><xsl:value-of select="$first-validation/表:错误提示/@表:类型"/></xsl:attribute>
                        <xsl:element name="text:p">
                            <xsl:value-of select="$first-validation/表:错误提示/@表:内容"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
            <xsl:call-template name="create-content-validations">
                <xsl:with-param name="validation-set" select="$validation-set[position()!=1]"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!--RedOffice Comment from Zengjh:UOF0020 2006-04-26 charts-->
    <xsl:template match="表:图表">
        <xsl:param name="table-name"/>
        <xsl:element name="draw:frame">
            <xsl:attribute name="draw:z-index"><xsl:value-of select="'0'"/></xsl:attribute>
            <xsl:attribute name="svg:width"><xsl:value-of select="concat(@表:宽度,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:height"><xsl:value-of select="concat(@表:高度,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:x"><xsl:value-of select="concat(@表:x坐标,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:y"><xsl:value-of select="concat(@表:y坐标,$uofUnit)"/></xsl:attribute>
            <xsl:variable name="chart-current">
                <xsl:number level="any" count="表:图表" format="1"/>
            </xsl:variable>
            <xsl:attribute name="draw:style-name"><xsl:value-of select="concat('chart', $chart-current)"/></xsl:attribute>
            <xsl:variable name="series-value-start">
                <xsl:for-each select="表:数据源/表:系列[position()='1']">
                    <xsl:value-of select="@表:系列值"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="series-value-end">
                <xsl:for-each select="表:数据源/表:系列[position()=last()]">
                    <xsl:value-of select="@表:系列值"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="series-generate-type">
                <xsl:choose>
                    <xsl:when test="表:数据源/@表序号产生">
                        <xsl:value-of select="表:数据源/@表序号产生"/>
                    </xsl:when>
                    <xsl:when test="substring(substring-after($series-value-start,'!'),2,1)=substring(substring-after($series-value-start,':'),2,1)">row</xsl:when>
                    <xsl:otherwise>col</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:element name="draw:object">
                <xsl:attribute name="draw:notify-on-update-of-ranges"><xsl:value-of select="表:数据源/@表:数据区域"/></xsl:attribute>
                <office:document xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" office:version="1.0" office:mimetype="application/vnd.oasis.opendocument.chart">
                    <xsl:call-template name="表:元数据">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="table-type" select="@表:类型"/>
                        <xsl:with-param name="table-subtype" select="@表:子类型"/>
                        <xsl:with-param name="series-value-start" select="$series-value-start"/>
                        <xsl:with-param name="series-value-end" select="$series-value-end"/>
                        <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    </xsl:call-template>
                    <xsl:call-template name="表:式样集">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="table-type" select="@表:类型"/>
                        <xsl:with-param name="table-subtype" select="@表:子类型"/>
                        <xsl:with-param name="series-value-start" select="$series-value-start"/>
                        <xsl:with-param name="series-value-end" select="$series-value-end"/>
                        <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    </xsl:call-template>
                    <xsl:call-template name="表:主体">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="table-type" select="@表:类型"/>
                        <xsl:with-param name="table-subtype" select="@表:子类型"/>
                        <xsl:with-param name="series-value-start" select="$series-value-start"/>
                        <xsl:with-param name="series-value-end" select="$series-value-end"/>
                        <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    </xsl:call-template>
                </office:document>
            </xsl:element>
            <xsl:element name="draw:image">
                <office:binary-data>
                    <xsl:value-of select="/uof:UOF/uof:对象集/uof:其他对象/uof:数据"/>
                </office:binary-data>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="表:元数据">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:for-each select="/uof:UOF/uof:元数据">
            <office:meta>
                <meta:generator>OpenOffice.org 1.1.3 (Win32)</meta:generator>
                <xsl:if test="uof:标题">
                    <dc:title>
                        <xsl:value-of select="uof:标题"/>
                    </dc:title>
                </xsl:if>
                <xsl:if test="uof:摘要">
                    <dc:description>
                        <xsl:value-of select="uof:摘要"/>
                    </dc:description>
                </xsl:if>
                <xsl:if test="uof:主题">
                    <dc:subject>
                        <xsl:value-of select="uof:主题"/>
                    </dc:subject>
                </xsl:if>
                <xsl:if test="uof:作者">
                    <meta:initial-creator>
                        <xsl:value-of select="uof:作者"/>
                    </meta:initial-creator>
                </xsl:if>
                <xsl:if test="uof:创建日期">
                    <meta:creation-date>
                        <xsl:value-of select="uof:创建日期"/>
                    </meta:creation-date>
                </xsl:if>
                <xsl:if test="uof:最后作者">
                    <dc:creator>
                        <xsl:value-of select="uof:最后作者"/>
                    </dc:creator>
                </xsl:if>
                <xsl:if test="uof:编辑时间">
                    <meta:editing-duration>
                        <xsl:value-of select="uof:编辑时间"/>
                    </meta:editing-duration>
                </xsl:if>
                <dc:language/>
                <meta:keywords>
                    <meta:keyword>
                        <xsl:value-of select="uof:关键字集/uof:关键字"/>
                    </meta:keyword>
                </meta:keywords>
                <xsl:if test="uof:编辑次数">
                    <meta:editing-cycles>
                        <xsl:value-of select="uof:编辑次数"/>
                    </meta:editing-cycles>
                </xsl:if>
                <xsl:if test="uof:分类">
                    <meta:user-defined meta:name="Category">
                        <xsl:value-of select="uof:分类"/>
                    </meta:user-defined>
                </xsl:if>
                <xsl:if test="uof:经理名称">
                    <meta:user-defined meta:name="Manager">
                        <xsl:value-of select="uof:经理名称"/>
                    </meta:user-defined>
                </xsl:if>
                <xsl:if test="uof:公司名称">
                    <meta:user-defined meta:name="Company">
                        <xsl:value-of select="uof:公司名称"/>
                    </meta:user-defined>
                </xsl:if>
                <xsl:if test="uof:创建应用程序">
                    <meta:user-defined meta:name="Version">
                        <xsl:value-of select="uof:创建应用程序"/>
                    </meta:user-defined>
                </xsl:if>
            </office:meta>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:式样集">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <office:styles>
            <draw:stroke-dash draw:name="Ultrafine_20_Dashed" draw:display-name="Ultrafine Dashed" draw:style="rect" draw:dots1="1" draw:dots1-length="0.051cm" draw:dots2="1" draw:dots2-length="0.051cm" draw:distance="0.051cm"/>
            <draw:stroke-dash draw:name="Fine_20_Dashed" draw:display-name="Fine Dashed" draw:style="rect" draw:dots1="1" draw:dots1-length="0.508cm" draw:dots2="1" draw:dots2-length="0.508cm" draw:distance="0.508cm"/>
            <draw:stroke-dash draw:name="Ultrafine_20_2_20_Dots_20_3_20_Dashes" draw:display-name="Ultrafine 2 Dots 3 Dashes" draw:style="rect" draw:dots1="2" draw:dots1-length="0.051cm" draw:dots2="3" draw:dots2-length="0.254cm" draw:distance="0.127cm"/>
            <draw:stroke-dash draw:name="Fine_20_Dashed_20__28_var_29_" draw:display-name="Fine Dashed (var)" draw:style="rect" draw:dots1="1" draw:dots1-length="197%" draw:distance="197%"/>
            <draw:stroke-dash draw:name="Fine_20_Dotted" draw:display-name="Fine Dotted" draw:style="rect" draw:dots1="1" draw:distance="0.457cm"/>
            <draw:stroke-dash draw:name="Fine_20_Dashed_20__28_var_29_" draw:display-name="Fine Dashed (var)" draw:style="rect" draw:dots1="1" draw:dots1-length="197%" draw:distance="197%"/>
            <draw:stroke-dash draw:name="Fine_20_Dotted" draw:display-name="Fine Dotted" draw:style="rect" draw:dots1="1" draw:distance="0.457cm"/>
            <draw:stroke-dash draw:name="Line_20_with_20_Fine_20_Dots" draw:display-name="Line with Fine Dots" draw:style="rect" draw:dots1="1" draw:dots1-length="2.007cm" draw:dots2="10" draw:distance="0.152cm"/>
            <draw:stroke-dash draw:name="Line_20_Style_20_9" draw:display-name="Line Style 9" draw:style="rect" draw:dots1="1" draw:dots1-length="197%" draw:distance="120%"/>
            <draw:stroke-dash draw:name="_33__20_Dashes_20_3_20_Dots_20__28_var_29_" draw:display-name="3 Dashes 3 Dots (var)" draw:style="rect" draw:dots1="3" draw:dots1-length="197%" draw:dots2="3" draw:distance="100%"/>
            <draw:stroke-dash draw:name="_32__20_Dots_20_1_20_Dash" draw:display-name="2 Dots 1 Dash" draw:style="rect" draw:dots1="2" draw:dots2="1" draw:dots2-length="0.203cm" draw:distance="0.203cm"/>
            <draw:stroke-dash draw:name="Ultrafine_20_Dotted_20__28_var_29_" draw:display-name="Ultrafine Dotted (var)" draw:style="rect" draw:dots1="1" draw:distance="50%"/>
            <draw:stroke-dash draw:name="Dash_20_10" draw:display-name="Dash 10" draw:style="rect" draw:dots1="1" draw:dots1-length="0.02cm" draw:dots2="1" draw:dots2-length="0.02cm" draw:distance="0.02cm"/>
            <xsl:for-each select="//图:图片">
                <xsl:variable name="chart-image-name" select="@图:名称"/>
                <draw:fill-image>
                    <xsl:attribute name="draw:name"><xsl:value-of select="@图:名称"/></xsl:attribute>
                    <office:binary-data>
                        <xsl:for-each select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$chart-image-name]">
                            <xsl:value-of select="uof:数据"/>
                        </xsl:for-each>
                    </office:binary-data>
                </draw:fill-image>
            </xsl:for-each>
            <xsl:for-each select="//图:图案">
                <xsl:variable name="chart-hatch-name" select="@图:图形引用"/>
                <draw:hatch>
                    <xsl:if test="@图:图形引用">
                        <xsl:attribute name="draw:name"><xsl:value-of select="$chart-hatch-name"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:类型">
                        <xsl:attribute name="draw:style"><xsl:value-of select="@图:类型"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:前景色">
                        <xsl:attribute name="draw:color"><xsl:value-of select="@图:前景色"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:距离">
                        <xsl:attribute name="draw:distance"><xsl:value-of select="@图:距离"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:旋转度">
                        <xsl:attribute name="draw:rotation"><xsl:value-of select="@图:旋转度"/></xsl:attribute>
                    </xsl:if>
                </draw:hatch>
            </xsl:for-each>
            <xsl:for-each select="//图:渐变">
                <draw:gradient>
                    <xsl:if test="@图:图形引用">
                        <xsl:attribute name="draw:name"><xsl:value-of select="@图:图形引用"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:起始色">
                        <xsl:attribute name="draw:start-color"><xsl:value-of select="@图:起始色"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:终止色">
                        <xsl:attribute name="draw:end-color"><xsl:value-of select="@图:终止色"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:种子类型">
                        <xsl:attribute name="draw:style"><xsl:value-of select="@图:种子类型"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:起始浓度">
                        <xsl:attribute name="draw:start-intensity"><xsl:value-of select="@图:起始浓度"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:终止浓度">
                        <xsl:attribute name="draw:end-intensity"><xsl:value-of select="@图:终止浓度"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:渐变方向">
                        <xsl:attribute name="draw:angle"><xsl:value-of select="@图:渐变方向"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:边界">
                        <xsl:attribute name="draw:border"><xsl:value-of select="@图:边界"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:种子X位置">
                        <xsl:attribute name="draw:cx"><xsl:value-of select="@图:种子X位置"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@图:种子Y位置">
                        <xsl:attribute name="draw:cy"><xsl:value-of select="@图:种子Y位置"/></xsl:attribute>
                    </xsl:if>
                </draw:gradient>
            </xsl:for-each>
        </office:styles>
        <office:automatic-styles>
            <xsl:for-each select="node( )">
                <xsl:choose>
                    <xsl:when test="name(.)='表:图表区'">
                        <xsl:call-template name="表:图表区式样">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name(.)='表:绘图区'">
                        <xsl:call-template name="表:绘图区式样">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                        <xsl:call-template name="表:图表背景墙式样">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name(.)='表:分类轴'">
                        <xsl:call-template name="表:分类轴式样">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name(.)='表:数值轴'">
                        <xsl:call-template name="表:数值轴式样">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name(.)='表:图例'">
                        <xsl:call-template name="表:图例式样">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name(.)='表:数据表'">
                        <xsl:call-template name="表:数据表式样">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name(.)='表:数据系列集'">
                        <xsl:call-template name="表:数据系列集式样">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name(.)='表:数据点集'">
                        <xsl:call-template name="表:数据点集式样">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name(.)='表:网格线集'">
                        <xsl:call-template name="表:网格线集式样">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name(.)='表:数据源'">
                        <xsl:call-template name="表:数据源式样">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name(.)='表:标题集'">
                        <xsl:call-template name="表:标题集式样">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>
        </office:automatic-styles>
    </xsl:template>
    <xsl:template name="表:主体">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <office:body>
            <office:chart>
                <chart:chart>
                    <xsl:attribute name="svg:width"><xsl:value-of select="concat(@表:宽度,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="svg:height"><xsl:value-of select="concat(@表:高度,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="chart:class"><xsl:choose><xsl:when test="$table-type='column'">chart:bar</xsl:when><xsl:when test="$table-type='line'">chart:line</xsl:when><xsl:when test="$table-type='pie'"><xsl:choose><xsl:when test="$table-subtype='pie_ring'">chart:ring</xsl:when><xsl:otherwise>chart:circle</xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise><xsl:value-of select="$table-type"/></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="chart:style-name">chart-area</xsl:attribute>
                    <xsl:for-each select="表:标题集/表:标题[@表:位置='chart']">
                        <chart:title chart:style-name="chart-title">
                            <text:p>
                                <xsl:value-of select="@表:名称"/>
                            </text:p>
                        </chart:title>
                    </xsl:for-each>
                    <xsl:call-template name="表:图例区域">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="table-type" select="$table-type"/>
                        <xsl:with-param name="table-subtype" select="$table-subtype"/>
                        <xsl:with-param name="series-value-start" select="$series-value-start"/>
                        <xsl:with-param name="series-value-end" select="$series-value-end"/>
                        <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    </xsl:call-template>
                    <xsl:call-template name="表:绘图区域">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="table-type" select="$table-type"/>
                        <xsl:with-param name="table-subtype" select="$table-subtype"/>
                        <xsl:with-param name="series-value-start" select="$series-value-start"/>
                        <xsl:with-param name="series-value-end" select="$series-value-end"/>
                        <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    </xsl:call-template>
                    <xsl:call-template name="表:本地表">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="table-type" select="$table-type"/>
                        <xsl:with-param name="table-subtype" select="$table-subtype"/>
                        <xsl:with-param name="series-value-start" select="$series-value-start"/>
                        <xsl:with-param name="series-value-end" select="$series-value-end"/>
                        <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    </xsl:call-template>
                </chart:chart>
            </office:chart>
        </office:body>
    </xsl:template>
    <xsl:template name="表:图例区域">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <chart:legend>
            <xsl:attribute name="chart:legend-position"><xsl:choose><xsl:when test="表:图例/@表:位置"><xsl:value-of select="表:图例/@表:位置"/></xsl:when><xsl:otherwise>right</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="svg:x"><xsl:value-of select="concat(表:图例/@表:x坐标,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:y"><xsl:value-of select="concat(表:图例/@表:y坐标,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="chart:style-name">legend</xsl:attribute>
        </chart:legend>
    </xsl:template>
    <xsl:template name="表:绘图区域">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <chart:plot-area>
            <xsl:variable name="start-range">
                <xsl:value-of select="concat('.$',substring(substring-after($series-value-start,'!'),1,1),'$',substring-before(substring(substring-after($series-value-start,'!'),2),':'))"/>
            </xsl:variable>
            <xsl:variable name="end-range">
                <xsl:value-of select="concat(':.$',substring(substring-after($series-value-end,':'),1,1),'$',substring(substring-after($series-value-end,':'),2))"/>
            </xsl:variable>
            <xsl:attribute name="chart:style-name">plot-area</xsl:attribute>
            <xsl:attribute name="table:cell-range-address"><xsl:value-of select="concat($table-name,$start-range,$end-range)"/></xsl:attribute>
            <!--xsl:value-of select="表:数据源/@表:数据区域"/-->
            <xsl:attribute name="chart:table-number-list">0</xsl:attribute>
            <xsl:attribute name="svg:width"><xsl:value-of select="concat(表:绘图区/@表:宽度,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:height"><xsl:value-of select="concat(表:绘图区/@表:高度,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:x"><xsl:value-of select="concat(表:绘图区/@表:x坐标,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:y"><xsl:value-of select="concat(表:绘图区/@表:y坐标,$uofUnit)"/></xsl:attribute>
            <xsl:if test="表:分类轴">
                <chart:axis chart:dimension="x" chart:name="primary-x" chart:style-name="category-axis">
                    <xsl:for-each select="表:标题集/表:标题[@表:位置='category axis']">
                        <chart:title chart:style-name="category-axis-title">
                            <text:p>
                                <xsl:value-of select="@表:名称"/>
                            </text:p>
                        </chart:title>
                    </xsl:for-each>
                    <chart:categories/>
                    <xsl:if test="表:网格线集/表:网格线[@表:位置='category axis']">
                        <chart:grid chart:style-name="category-axis-grid" chart:class="major"/>
                    </xsl:if>
                </chart:axis>
            </xsl:if>
            <xsl:if test="表:数值轴">
                <chart:axis chart:dimension="y" chart:name="primary-y" chart:style-name="value-axis">
                    <xsl:for-each select="表:标题集/表:标题[@表:位置='value axis']">
                        <chart:title chart:style-name="value-axis-title">
                            <text:p>
                                <xsl:value-of select="@表:名称"/>
                            </text:p>
                        </chart:title>
                    </xsl:for-each>
                    <chart:grid chart:style-name="value-axis-grid" chart:class="major"/>
                </chart:axis>
            </xsl:if>
            <xsl:call-template name="表:数据组">
                <xsl:with-param name="table-name" select="$table-name"/>
                <xsl:with-param name="table-type" select="$table-type"/>
                <xsl:with-param name="table-subtype" select="$table-subtype"/>
                <xsl:with-param name="series-value-start" select="$series-value-start"/>
                <xsl:with-param name="series-value-end" select="$series-value-end"/>
                <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
            </xsl:call-template>
            <chart:wall>
                <xsl:attribute name="chart:style-name">chart-wall</xsl:attribute>
            </chart:wall>
            <chart:floor>
                <xsl:attribute name="chart:style-name">chart-floor</xsl:attribute>
            </chart:floor>
        </chart:plot-area>
    </xsl:template>
    <xsl:template name="表:本地表">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <table:table table:name="local-table">
            <table:table-header-columns>
                <xsl:call-template name="表:本地表_表头列">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="table-type" select="$table-type"/>
                    <xsl:with-param name="table-subtype" select="$table-subtype"/>
                    <xsl:with-param name="series-value-start" select="$series-value-start"/>
                    <xsl:with-param name="series-value-end" select="$series-value-end"/>
                    <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    <xsl:with-param name="sum" select="1"/>
                </xsl:call-template>
            </table:table-header-columns>
            <table:table-columns>
                <xsl:variable name="column-sum">
                    <xsl:value-of select="count(表:数据源/表:系列)"/>
                </xsl:variable>
                <xsl:call-template name="表:本地表_列">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="table-type" select="$table-type"/>
                    <xsl:with-param name="table-subtype" select="$table-subtype"/>
                    <xsl:with-param name="series-value-start" select="$series-value-start"/>
                    <xsl:with-param name="series-value-end" select="$series-value-end"/>
                    <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    <xsl:with-param name="column-sum" select="$column-sum"/>
                </xsl:call-template>
            </table:table-columns>
            <table:table-header-rows>
                <xsl:call-template name="表:本地表_表头行">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="table-type" select="$table-type"/>
                    <xsl:with-param name="table-subtype" select="$table-subtype"/>
                    <xsl:with-param name="series-value-start" select="$series-value-start"/>
                    <xsl:with-param name="series-value-end" select="$series-value-end"/>
                    <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    <xsl:with-param name="row-current" select="1"/>
                    <xsl:with-param name="fixed-row-sum" select="'1'"/>
                </xsl:call-template>
            </table:table-header-rows>
            <table:table-rows>
                <xsl:variable name="row-start">
                    <xsl:value-of select="substring-before(substring(substring-after($series-value-start,'!'),2),':')"/>
                </xsl:variable>
                <xsl:variable name="row-end">
                    <xsl:value-of select="substring(substring-after($series-value-end,':'),2)"/>
                </xsl:variable>
                <xsl:variable name="fixed-row-sum">
                    <xsl:value-of select="$row-end -$row-start +1"/>
                </xsl:variable>
                <xsl:call-template name="表:本地表_行">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="table-type" select="$table-type"/>
                    <xsl:with-param name="table-subtype" select="$table-subtype"/>
                    <xsl:with-param name="series-value-start" select="$series-value-start"/>
                    <xsl:with-param name="series-value-end" select="$series-value-end"/>
                    <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    <xsl:with-param name="row-current" select="'1'"/>
                    <xsl:with-param name="fixed-row-sum" select="$fixed-row-sum"/>
                </xsl:call-template>
            </table:table-rows>
        </table:table>
    </xsl:template>
    <xsl:template name="表:本地表_表头列">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:param name="sum"/>
        <xsl:choose>
            <xsl:when test="$sum=0"/>
            <xsl:otherwise>
                <table:table-column/>
                <xsl:call-template name="表:本地表_表头列">
                    <xsl:with-param name="sum" select="$sum -1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="表:本地表_列">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:param name="column-sum"/>
        <xsl:choose>
            <xsl:when test="$column-sum=0"/>
            <xsl:otherwise>
                <table:table-column/>
                <xsl:call-template name="表:本地表_列">
                    <xsl:with-param name="column-sum" select="$column-sum -1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="表:本地表_表头行">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:param name="row-current"/>
        <xsl:param name="fixed-row-sum"/>
        <xsl:choose>
            <xsl:when test="$row-current >$fixed-row-sum"/>
            <xsl:otherwise>
                <table:table-row>
                    <xsl:variable name="series-value-current">
                        <xsl:for-each select="表:数据源/表:系列[position()=$row-current]">
                            <xsl:value-of select="@表:系列值"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="cell-start">
                        <xsl:call-template name="General-Char-Transition">
                            <xsl:with-param name="input-char" select="substring(substring-after($series-value-start,'!'),1,1)"/>
                            <xsl:with-param name="output-type" select="'ARABIC'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="cell-end">
                        <xsl:choose>
                            <xsl:when test="$series-generate-type='row'">
                                <xsl:call-template name="General-Char-Transition">
                                    <xsl:with-param name="input-char" select="substring(substring-after($series-value-start,':'),1,1)"/>
                                    <xsl:with-param name="output-type" select="'ARABIC'"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="General-Char-Transition">
                                    <xsl:with-param name="input-char" select="substring(substring-after($series-value-end,'!'),1,1)"/>
                                    <xsl:with-param name="output-type" select="'ARABIC'"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="cell-sum">
                        <xsl:value-of select="$cell-end -$cell-start +2"/>
                    </xsl:variable>
                    <xsl:variable name="fixed-cell-sum" select="$cell-sum"/>
                    <xsl:call-template name="表:本地表_表头行_单元格">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="table-type" select="$table-type"/>
                        <xsl:with-param name="table-subtype" select="$table-subtype"/>
                        <xsl:with-param name="series-value-start" select="$series-value-start"/>
                        <xsl:with-param name="series-value-end" select="$series-value-end"/>
                        <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        <xsl:with-param name="series-value-current" select="$series-value-current"/>
                        <xsl:with-param name="row-current" select="$row-current"/>
                        <xsl:with-param name="cell-sum" select="$cell-sum"/>
                        <xsl:with-param name="fixed-cell-sum" select="$fixed-cell-sum"/>
                    </xsl:call-template>
                </table:table-row>
                <xsl:call-template name="表:本地表_表头行">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="table-type" select="$table-type"/>
                    <xsl:with-param name="table-subtype" select="$table-subtype"/>
                    <xsl:with-param name="series-value-start" select="$series-value-start"/>
                    <xsl:with-param name="series-value-end" select="$series-value-end"/>
                    <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    <xsl:with-param name="row-current" select="$row-current +1"/>
                    <xsl:with-param name="fixed-row-sum" select="$fixed-row-sum"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="表:本地表_表头行_单元格">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:param name="series-value-current"/>
        <xsl:param name="row-current"/>
        <xsl:param name="cell-sum"/>
        <xsl:param name="fixed-cell-sum"/>
        <xsl:choose>
            <xsl:when test="$cell-sum=0"/>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$fixed-cell-sum=$cell-sum">
                        <table:table-cell>
                            <text:p/>
                        </table:table-cell>
                    </xsl:when>
                    <xsl:otherwise>
                        <table:table-cell office:value-type="string">
                            <xsl:variable name="cell-no">
                                <xsl:value-of select="$fixed-cell-sum -$cell-sum +1"/>
                            </xsl:variable>
                            <xsl:variable name="cell-start">
                                <xsl:call-template name="General-Char-Transition">
                                    <xsl:with-param name="input-char" select="substring(substring-after($series-value-start,'!'),1,1)"/>
                                    <xsl:with-param name="output-type" select="'ARABIC'"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="char">
                                <xsl:call-template name="General-Char-Transition">
                                    <xsl:with-param name="input-char" select="$cell-start +$cell-no -2"/>
                                    <xsl:with-param name="output-type" select="'CHARS_UPPER_LETTER'"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <text:p>
                                <xsl:value-of select="concat('列 ',$char)"/>
                            </text:p>
                        </table:table-cell>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="表:本地表_表头行_单元格">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="table-type" select="$table-type"/>
                    <xsl:with-param name="table-subtype" select="$table-subtype"/>
                    <xsl:with-param name="series-value-start" select="$series-value-start"/>
                    <xsl:with-param name="series-value-end" select="$series-value-end"/>
                    <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    <xsl:with-param name="series-value-current" select="$series-value-current"/>
                    <xsl:with-param name="row-current" select="$row-current"/>
                    <xsl:with-param name="cell-sum" select="$cell-sum -1"/>
                    <xsl:with-param name="fixed-cell-sum" select="$fixed-cell-sum"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="表:本地表_行">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:param name="row-current"/>
        <xsl:param name="fixed-row-sum"/>
        <xsl:choose>
            <xsl:when test="$row-current >$fixed-row-sum"/>
            <xsl:otherwise>
                <xsl:variable name="series-value-current">
                    <xsl:for-each select="表:数据源/表:系列[position()=$row-current]">
                        <xsl:value-of select="@表:系列值"/>
                    </xsl:for-each>
                </xsl:variable>
                <table:table-row>
                    <xsl:variable name="cell-start">
                        <xsl:call-template name="General-Char-Transition">
                            <xsl:with-param name="input-char" select="substring(substring-after($series-value-start,'!'),1,1)"/>
                            <xsl:with-param name="output-type" select="'ARABIC'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="cell-end">
                        <xsl:choose>
                            <xsl:when test="$series-generate-type='row'">
                                <xsl:call-template name="General-Char-Transition">
                                    <xsl:with-param name="input-char" select="substring(substring-after($series-value-start,':'),1,1)"/>
                                    <xsl:with-param name="output-type" select="'ARABIC'"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="General-Char-Transition">
                                    <xsl:with-param name="input-char" select="substring(substring-after($series-value-end,'!'),1,1)"/>
                                    <xsl:with-param name="output-type" select="'ARABIC'"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="cell-sum">
                        <xsl:value-of select="$cell-end -$cell-start +2"/>
                    </xsl:variable>
                    <xsl:variable name="fixed-cell-sum" select="$cell-sum"/>
                    <xsl:call-template name="表:本地表_行_单元格">
                        <xsl:with-param name="table-name" select="$table-name"/>
                        <xsl:with-param name="table-type" select="$table-type"/>
                        <xsl:with-param name="table-subtype" select="$table-subtype"/>
                        <xsl:with-param name="series-value-start" select="$series-value-start"/>
                        <xsl:with-param name="series-value-end" select="$series-value-end"/>
                        <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        <xsl:with-param name="series-value-current" select="$series-value-current"/>
                        <xsl:with-param name="row-current" select="$row-current"/>
                        <xsl:with-param name="cell-sum" select="$cell-sum"/>
                        <xsl:with-param name="fixed-cell-sum" select="$fixed-cell-sum"/>
                    </xsl:call-template>
                </table:table-row>
                <xsl:call-template name="表:本地表_行">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="table-type" select="$table-type"/>
                    <xsl:with-param name="table-subtype" select="$table-subtype"/>
                    <xsl:with-param name="series-value-start" select="$series-value-start"/>
                    <xsl:with-param name="series-value-end" select="$series-value-end"/>
                    <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    <xsl:with-param name="row-current" select="$row-current +1"/>
                    <xsl:with-param name="fixed-row-sum" select="$fixed-row-sum"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="表:本地表_行_单元格">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:param name="series-value-current"/>
        <xsl:param name="row-current"/>
        <xsl:param name="cell-sum"/>
        <xsl:param name="fixed-cell-sum"/>
        <xsl:choose>
            <xsl:when test="$cell-sum=0"/>
            <xsl:otherwise>
                <xsl:variable name="cell-start">
                    <xsl:call-template name="General-Char-Transition">
                        <xsl:with-param name="input-char" select="substring(substring-after($series-value-start,'!'),1,1)"/>
                        <xsl:with-param name="output-type" select="'ARABIC'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="cell-no">
                    <xsl:value-of select="$cell-start +$fixed-cell-sum -$cell-sum -1"/>
                </xsl:variable>
                <xsl:variable name="row-start">
                    <xsl:value-of select="substring(substring-after($series-value-start,'!'),2,1)"/>
                </xsl:variable>
                <xsl:variable name="row-no">
                    <xsl:value-of select="$row-start +$row-current -1"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$fixed-cell-sum=$cell-sum">
                        <table:table-cell office:value-type="string">
                            <text:p>
                                <xsl:value-of select="concat('行 ',$row-no)"/>
                            </text:p>
                        </table:table-cell>
                    </xsl:when>
                    <xsl:otherwise>
                        <table:table-cell office:value-type="float">
                            <xsl:variable name="cell-content">
                                <xsl:choose>
                                    <xsl:when test="/uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/表:行/@表:行号">
                                        <xsl:for-each select="/uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/表:行[@表:行号=$row-no]">
                                            <xsl:for-each select="表:单元格[@表:列号=$cell-no]">
                                                <xsl:value-of select="表:数据/字:句/字:文本串"/>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="/uof:UOF/uof:电子表格/表:主体/表:工作表/表:工作表内容/表:行[position()=$row-no]">
                                            <xsl:for-each select="表:单元格[position()=$cell-no]">
                                                <xsl:value-of select="表:数据/字:句/字:文本串"/>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:attribute name="office:value"><xsl:value-of select="$cell-content"/></xsl:attribute>
                            <text:p>
                                <xsl:value-of select="$cell-content"/>
                            </text:p>
                        </table:table-cell>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="表:本地表_行_单元格">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="table-type" select="$table-type"/>
                    <xsl:with-param name="table-subtype" select="$table-subtype"/>
                    <xsl:with-param name="series-value-start" select="$series-value-start"/>
                    <xsl:with-param name="series-value-end" select="$series-value-end"/>
                    <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    <xsl:with-param name="series-value-current" select="$series-value-current"/>
                    <xsl:with-param name="row-current" select="$row-current"/>
                    <xsl:with-param name="cell-sum" select="$cell-sum -1"/>
                    <xsl:with-param name="fixed-cell-sum" select="$fixed-cell-sum"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="表:数据组">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:variable name="input-char-start">
            <xsl:choose>
                <xsl:when test="$series-generate-type='row'">
                    <xsl:value-of select="substring(substring-after($series-value-start,'!'),1,1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(substring(substring-after($series-value-start,'!'),2),':')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="input-char-end">
            <xsl:choose>
                <xsl:when test="$series-generate-type='row'">
                    <xsl:value-of select="substring(substring-after($series-value-start,':'),1,1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring(substring-after($series-value-start,':'),2)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="cell-start">
            <xsl:call-template name="General-Char-Transition">
                <xsl:with-param name="input-char" select="$input-char-start"/>
                <xsl:with-param name="output-type" select="'ARABIC'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="cell-end">
            <xsl:call-template name="General-Char-Transition">
                <xsl:with-param name="input-char" select="$input-char-end"/>
                <xsl:with-param name="output-type" select="'ARABIC'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="fixed-cell-sum">
            <xsl:value-of select="$cell-end -$cell-start +1"/>
        </xsl:variable>
        <xsl:for-each select="表:数据系列集/表:数据系列">
            <chart:series>
                <xsl:attribute name="chart:style-name"><xsl:value-of select="concat('data-series',position())"/></xsl:attribute>
                <xsl:call-template name="表:数据点">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="table-type" select="$table-type"/>
                    <xsl:with-param name="table-subtype" select="$table-subtype"/>
                    <xsl:with-param name="series-value-start" select="$series-value-start"/>
                    <xsl:with-param name="series-value-end" select="$series-value-end"/>
                    <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    <xsl:with-param name="data-series-current" select="position()"/>
                    <xsl:with-param name="cell-current" select="'1'"/>
                    <xsl:with-param name="fixed-cell-sum" select="$fixed-cell-sum"/>
                </xsl:call-template>
            </chart:series>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:数据点">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:param name="data-series-current"/>
        <xsl:param name="cell-current"/>
        <xsl:param name="fixed-cell-sum"/>
        <xsl:choose>
            <xsl:when test="$cell-current>$fixed-cell-sum"/>
            <xsl:otherwise>
                <chart:data-point>
                    <xsl:attribute name="chart:style-name"><xsl:value-of select="concat('data-point',$data-series-current,$cell-current)"/></xsl:attribute>
                </chart:data-point>
                <xsl:call-template name="表:数据点">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="table-type" select="$table-type"/>
                    <xsl:with-param name="table-subtype" select="$table-subtype"/>
                    <xsl:with-param name="series-value-start" select="$series-value-start"/>
                    <xsl:with-param name="series-value-end" select="$series-value-end"/>
                    <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    <xsl:with-param name="data-series-current" select="$data-series-current"/>
                    <xsl:with-param name="cell-current" select="$cell-current +1"/>
                    <xsl:with-param name="fixed-cell-sum" select="$fixed-cell-sum"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="表:图表区式样">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <style:style style:name="chart-area" style:family="chart">
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="name(.)='表:边框'">
                        <style:graphic-properties>
                            <xsl:call-template name="uof:边框"/>
                        </style:graphic-properties>
                    </xsl:when>
                    <xsl:when test="name(.)='表:填充'">
                        <style:graphic-properties>
                            <xsl:call-template name="图:填充类型"/>
                        </style:graphic-properties>
                    </xsl:when>
                    <xsl:when test="name(.)='表:字体'">
                        <style:text-properties>
                            <xsl:call-template name="字:句属性类型"/>
                        </style:text-properties>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </style:style>
    </xsl:template>
    <xsl:template name="表:绘图区式样">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <style:style style:name="plot-area" style:family="chart">
            <style:chart-properties>
                <xsl:choose>
                    <xsl:when test="$table-subtype='bar_stacked' or $table-subtype='column_stacked' or $table-subtype='line_stacked'">
                        <xsl:attribute name="chart:stacked">true</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$table-subtype='bar_percent' or $table-subtype='column_percent' or $table-subtype='line_percent'">
                        <xsl:attribute name="chart:percentage">true</xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <xsl:attribute name="chart:vertical"><xsl:choose><xsl:when test="$table-type='bar'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="chart:series-source"><xsl:choose><xsl:when test="$series-generate-type='row'">rows</xsl:when><xsl:otherwise>columns</xsl:otherwise></xsl:choose></xsl:attribute>
            </style:chart-properties>
        </style:style>
    </xsl:template>
    <xsl:template name="表:图表背景墙式样">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <style:style style:name="chart-wall" style:family="chart">
            <style:graphic-properties>
                <xsl:for-each select="node()">
                    <xsl:choose>
                        <xsl:when test="name(.)='表:边框'">
                            <xsl:call-template name="uof:边框"/>
                        </xsl:when>
                        <xsl:when test="name(.)='表:填充'">
                            <xsl:call-template name="图:填充类型"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </style:graphic-properties>
        </style:style>
    </xsl:template>
    <xsl:template name="表:分类轴式样">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <style:style style:name="category-axis" style:family="chart">
            <xsl:call-template name="表:坐标轴类型">
                <xsl:with-param name="table-name" select="$table-name"/>
                <xsl:with-param name="table-type" select="$table-type"/>
                <xsl:with-param name="table-subtype" select="$table-subtype"/>
                <xsl:with-param name="series-value-start" select="$series-value-start"/>
                <xsl:with-param name="series-value-end" select="$series-value-end"/>
                <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                <xsl:with-param name="axis-type" select="'category axis'"/>
            </xsl:call-template>
        </style:style>
    </xsl:template>
    <xsl:template name="表:数值轴式样">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <style:style style:name="value-axis" style:family="chart">
            <xsl:call-template name="表:坐标轴类型">
                <xsl:with-param name="table-name" select="$table-name"/>
                <xsl:with-param name="table-type" select="$table-type"/>
                <xsl:with-param name="table-subtype" select="$table-subtype"/>
                <xsl:with-param name="series-value-start" select="$series-value-start"/>
                <xsl:with-param name="series-value-end" select="$series-value-end"/>
                <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                <xsl:with-param name="axis-type" select="'value axis'"/>
            </xsl:call-template>
        </style:style>
    </xsl:template>
    <xsl:template name="表:图例式样">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <style:style style:name="legend" style:family="chart">
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="name(.)='表:边框'">
                        <style:graphic-properties>
                            <xsl:call-template name="uof:边框"/>
                        </style:graphic-properties>
                    </xsl:when>
                    <xsl:when test="name(.)='表:填充'">
                        <style:graphic-properties>
                            <xsl:call-template name="图:填充类型"/>
                        </style:graphic-properties>
                    </xsl:when>
                    <xsl:when test="name(.)='表:字体'">
                        <style:text-properties>
                            <xsl:call-template name="字:句属性类型"/>
                        </style:text-properties>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </style:style>
    </xsl:template>
    <xsl:template name="表:数据表式样">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <style:style style:name="data-table" style:family="chart">
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="name(.)='表:边框'">
                        <style:graphic-properties>
                            <xsl:call-template name="uof:边框"/>
                        </style:graphic-properties>
                    </xsl:when>
                    <xsl:when test="name(.)='表:填充'">
                        <style:graphic-properties>
                            <xsl:call-template name="图:填充类型"/>
                        </style:graphic-properties>
                    </xsl:when>
                    <xsl:when test="name(.)='表:字体'">
                        <style:text-properties>
                            <xsl:call-template name="字:句属性类型"/>
                        </style:text-properties>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </style:style>
    </xsl:template>
    <xsl:template name="表:数据系列集式样">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:for-each select="表:数据系列">
            <style:style style:family="chart">
                <xsl:variable name="current-position" select="position()"/>
                <xsl:attribute name="style:name"><xsl:value-of select="concat('data-series',$current-position)"/></xsl:attribute>
                <xsl:call-template name="表:数据点类型">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="table-type" select="$table-type"/>
                    <xsl:with-param name="table-subtype" select="$table-subtype"/>
                    <xsl:with-param name="series-value-start" select="$series-value-start"/>
                    <xsl:with-param name="series-value-end" select="$series-value-end"/>
                    <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    <xsl:with-param name="recall-type" select="'data-series'"/>
                </xsl:call-template>
            </style:style>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:数据点集式样">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:for-each select="表:数据点">
            <style:style style:family="chart">
                <xsl:attribute name="style:name"><xsl:value-of select="concat('data-point',@表:系列,@表:点)"/></xsl:attribute>
                <xsl:call-template name="表:数据点类型">
                    <xsl:with-param name="table-name" select="$table-name"/>
                    <xsl:with-param name="table-type" select="$table-type"/>
                    <xsl:with-param name="table-subtype" select="$table-subtype"/>
                    <xsl:with-param name="series-value-start" select="$series-value-start"/>
                    <xsl:with-param name="series-value-end" select="$series-value-end"/>
                    <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                    <xsl:with-param name="recall-type" select="'data-point'"/>
                </xsl:call-template>
            </style:style>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:网格线集式样">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:for-each select="表:网格线">
            <xsl:choose>
                <xsl:when test="@表:位置='category axis'">
                    <style:style style:name="category-axis-grid" style:family="chart">
                        <style:graphic-properties>
                            <xsl:call-template name="uof:边框"/>
                        </style:graphic-properties>
                    </style:style>
                </xsl:when>
                <xsl:when test="@表:位置='value axis'">
                    <style:style style:name="value-axis-grid" style:family="chart">
                        <style:graphic-properties>
                            <xsl:call-template name="uof:边框"/>
                        </style:graphic-properties>
                    </style:style>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:数据源式样">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:for-each select="表:系列">
            <style:style style:family="chart">
                <xsl:variable name="current-position" select="position()"/>
                <xsl:attribute name="style:name"><xsl:value-of select="concat('data-source',$current-position)"/></xsl:attribute>
            </style:style>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:标题集式样">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:for-each select="表:标题">
            <xsl:choose>
                <xsl:when test="@表:位置='chart'">
                    <style:style style:name="chart-title" style:family="chart">
                        <xsl:call-template name="表:标题类型">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </style:style>
                </xsl:when>
                <xsl:when test="@表:位置='category axis'">
                    <style:style style:name="category-axis-title" style:family="chart">
                        <xsl:call-template name="表:标题类型">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </style:style>
                </xsl:when>
                <xsl:when test="@表:位置='value axis'">
                    <style:style style:name="value-axis-title" style:family="chart">
                        <xsl:call-template name="表:标题类型">
                            <xsl:with-param name="table-name" select="$table-name"/>
                            <xsl:with-param name="table-type" select="$table-type"/>
                            <xsl:with-param name="table-subtype" select="$table-subtype"/>
                            <xsl:with-param name="series-value-start" select="$series-value-start"/>
                            <xsl:with-param name="series-value-end" select="$series-value-end"/>
                            <xsl:with-param name="series-generate-type" select="$series-generate-type"/>
                        </xsl:call-template>
                    </style:style>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:坐标轴类型">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:param name="axis-type"/>
        <style:chart-properties>
            <xsl:choose>
                <xsl:when test="@表:主刻度类型='cross'">
                    <xsl:attribute name="chart:tick-marks-major-inner">true</xsl:attribute>
                    <xsl:attribute name="chart:tick-marks-major-outer">true</xsl:attribute>
                </xsl:when>
                <xsl:when test="@表:主刻度类型='inside'">
                    <xsl:attribute name="chart:tick-marks-major-inner">true</xsl:attribute>
                    <xsl:attribute name="chart:tick-marks-major-outer">false</xsl:attribute>
                </xsl:when>
                <xsl:when test="@表:主刻度类型='outside'">
                    <xsl:attribute name="chart:tick-marks-major-inner">false</xsl:attribute>
                    <xsl:attribute name="chart:tick-marks-major-outer">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="@表:次刻度类型='cross'">
                    <xsl:attribute name="chart:tick-marks-minor-inner">true</xsl:attribute>
                    <xsl:attribute name="chart:tick-marks-minor-outer">true</xsl:attribute>
                </xsl:when>
                <xsl:when test="@表:次刻度类型='inside'">
                    <xsl:attribute name="chart:tick-marks-minor-inner">true</xsl:attribute>
                    <xsl:attribute name="chart:tick-marks-minor-outer">false</xsl:attribute>
                </xsl:when>
                <xsl:when test="@表:次刻度类型='outside'">
                    <xsl:attribute name="chart:tick-marks-minor-inner">false</xsl:attribute>
                    <xsl:attribute name="chart:tick-marks-minor-outer">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:if test="@表:刻度线标志='next to axis'">
                <xsl:attribute name="chart:display-label">true</xsl:attribute>
            </xsl:if>
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="name(.)='表:线型'">
                        <xsl:call-template name="uof:线型"/>
                    </xsl:when>
                    <xsl:when test="name(.)='表:数值'">
                        <xsl:attribute name="chart:link-data-style-to-source"><xsl:value-of select="@表:链接到源"/></xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name(.)='表:刻度'">
                        <xsl:call-template name="表:刻度类型"/>
                    </xsl:when>
                    <xsl:when test="name(.)='表:对齐'">
                        <xsl:if test="表:文字方向">
                            <xsl:attribute name="fo:direction"><xsl:value-of select="表:文字方向"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="表:旋转角度">
                            <xsl:attribute name="text:rotation-angle"><xsl:value-of select="表:旋转角度"/></xsl:attribute>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </style:chart-properties>
        <xsl:if test="表:字体">
            <xsl:for-each select="表:字体">
                <xsl:element name="style:text-properties">
                    <xsl:call-template name="字:句属性类型"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="表:数据点类型">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:param name="recall-type"/>
        <xsl:if test="name(.)='表:数据点'">
            <style:chart-properties>
                <xsl:if test="$table-type='pie' and $table-subtype='pie_offset1' and @表:点='1'">
                    <xsl:attribute name="chart:pie-offset">10</xsl:attribute>
                </xsl:if>
                <xsl:if test="$table-type='pie' and $table-subtype='pie_offset2'">
                    <xsl:attribute name="chart:pie-offset">10</xsl:attribute>
                </xsl:if>
            </style:chart-properties>
        </xsl:if>
        <xsl:for-each select="node()">
            <xsl:choose>
                <xsl:when test="name(.)='表:边框'">
                    <style:graphic-properties>
                        <xsl:call-template name="uof:边框"/>
                    </style:graphic-properties>
                </xsl:when>
                <xsl:when test="name(.)='表:填充'">
                    <style:graphic-properties>
                        <xsl:call-template name="图:填充类型"/>
                    </style:graphic-properties>
                </xsl:when>
                <xsl:when test="name(.)='表:字体'">
                    <style:text-properties>
                        <xsl:call-template name="字:句属性类型"/>
                    </style:text-properties>
                </xsl:when>
                <xsl:when test="name(.)='表:显示标志'">
                    <style:chart-properties>
                        <xsl:if test="@表:类别名">
                            <xsl:attribute name="chart:data-label-text"><xsl:value-of select="@表:类别名"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@表:数值">
                            <xsl:attribute name="chart:data-label-number">value</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@表:百分数">
                            <xsl:attribute name="chart:data-label-number">percentage</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@表:图例标志">
                            <xsl:attribute name="chart:data-label-symbol"><xsl:value-of select="@表:图例标志"/></xsl:attribute>
                        </xsl:if>
                    </style:chart-properties>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="表:标题类型">
        <xsl:param name="table-name"/>
        <xsl:param name="table-type"/>
        <xsl:param name="table-subtype"/>
        <xsl:param name="series-value-start"/>
        <xsl:param name="series-value-end"/>
        <xsl:param name="series-generate-type"/>
        <xsl:for-each select="node()">
            <xsl:choose>
                <xsl:when test="name(.)='表:边框'">
                    <style:graphic-properties>
                        <xsl:call-template name="uof:边框"/>
                    </style:graphic-properties>
                </xsl:when>
                <xsl:when test="name(.)='表:填充'">
                    <style:graphic-properties>
                        <xsl:call-template name="图:填充类型"/>
                    </style:graphic-properties>
                </xsl:when>
                <xsl:when test="name(.)='表:对齐'">
                    <style:chart-properties>
                        <xsl:call-template name="表:对齐格式类型"/>
                    </style:chart-properties>
                </xsl:when>
                <xsl:when test="name(.)='表:字体'">
                    <style:text-properties>
                        <xsl:call-template name="字:句属性类型"/>
                    </style:text-properties>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="uof:边框">
        <xsl:if test="@uof:类型">
            <xsl:variable name="type" select="@uof:类型"/>
            <xsl:attribute name="draw:stroke"><xsl:choose><xsl:when test="@uof:类型='single'">solid</xsl:when><xsl:when test="@uof:类型='none'">none</xsl:when><xsl:otherwise>dash</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="draw:stroke-dash"><xsl:choose><xsl:when test="$type='dash'">Ultrafine_20_Dashed</xsl:when><xsl:when test="$type='dot-dash'">Ultrafine_20_2_20_Dots_20_3_20_Dashes</xsl:when><xsl:when test="$type='dashed-heavy'">Fine_20_Dashed</xsl:when><xsl:when test="$type='dotted' ">Fine_20_Dotted</xsl:when><xsl:when test="$type='dash-long-heavy'">Line_20_with_20_Fine_20_Dots</xsl:when><xsl:when test="$type='dash-long'">Fine_20_Dashed_20__28_var_29_</xsl:when><xsl:when test="$type='dash-dot-dot'">_33__20_Dashes_20_3_20_Dots_20__28_var_29_</xsl:when><xsl:when test="$type='dotted-heavy'">Ultrafine_20_Dotted_20__28_var_29_</xsl:when><xsl:when test="$type='thick'">Line_20_Style_20_9</xsl:when><xsl:when test="$type='dot-dot-dash'">_32__20_Dots_20_1_20_Dash</xsl:when><xsl:when test="$type='dash-dot-dot-heavy'">Dashed_20__28_var_29_</xsl:when><xsl:when test="$type='dash-dot-heavy'">Dash_20_10</xsl:when></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="@uof:宽度">
            <xsl:attribute name="svg:stroke-width"><xsl:value-of select="concat(@uof:宽度,$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@uof:颜色">
            <xsl:attribute name="svg:stroke-color"><xsl:value-of select="@uof:颜色"/></xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template name="图:填充类型">
        <xsl:if test="图:颜色">
            <xsl:attribute name="draw:fill">solid</xsl:attribute>
            <xsl:attribute name="draw:fill-color"><xsl:value-of select="图:颜色"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="图:图片">
            <xsl:attribute name="draw:fill">bitmap</xsl:attribute>
            <xsl:attribute name="draw:fill-image-name"><xsl:value-of select="图:图片/@图:名称"/></xsl:attribute>
            <xsl:if test="not(图:图片/@图:位置='tile')">
                <xsl:attribute name="style:repeat"><xsl:choose><xsl:when test="图:图片/@图:位置='center'">no-repeat</xsl:when><xsl:when test="图:图片/@图:位置='stretch'">stretch</xsl:when></xsl:choose></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="图:图案">
            <xsl:attribute name="draw:fill">bitmap</xsl:attribute>
            <xsl:attribute name="draw:fill-hatch-name"><xsl:value-of select="图:图案/@图:图形引用"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="图:渐变">
            <xsl:attribute name="draw:fill">gradient</xsl:attribute>
            <xsl:attribute name="draw:fill-gradient-name"><xsl:value-of select="图:渐变/@图:图形引用"/></xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template name="uof:线型">
        <xsl:call-template name="uof:边框"/>
    </xsl:template>
    <xsl:template name="字:句属性类型">
        <xsl:apply-templates select="./*"/>
    </xsl:template>
    <xsl:template name="表:刻度类型">
        <xsl:if test="表:最小值">
            <xsl:attribute name="chart:minimum"><xsl:value-of select="表:最小值"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="表:最大值">
            <xsl:attribute name="chart:maximum"><xsl:value-of select="表:最大值"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="表:主单位">
            <xsl:attribute name="chart:interval-major"><xsl:value-of select="表:主单位"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="表:次单位">
            <xsl:attribute name="chart:interval-minor"><xsl:value-of select="表:次单位"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="表:分类交叉点">
            <xsl:attribute name="chart:origin"><xsl:value-of select="表:分类交叉点"/></xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template name="表:对齐格式类型">
        <xsl:if test="表:文字方向">
            <xsl:attribute name="style:direction"><xsl:value-of select="表:文字方向"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="表:文字旋转角度">
            <xsl:attribute name="style:rotation-angle"><xsl:value-of select="表:文字旋转角度"/></xsl:attribute>
        </xsl:if>
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
            <xsl:attribute name="style:font-family-asian"><xsl:value-of select="@字:中文字体引用"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@字:西文字体引用">
            <xsl:attribute name="fo:font-family"><xsl:value-of select="@字:西文字体引用"/></xsl:attribute>
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
            <xsl:attribute name="style:font-weight-asian">bold</xsl:attribute>
            <xsl:attribute name="style:font-weight-complex">bold</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="字:下划线">
        <xsl:choose>
            <xsl:when test="@字:类型 = 'single'">
                <xsl:attribute name="style:text-underline-style">solid</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">auto</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'double'">
                <xsl:attribute name="style:text-underline-style">solid</xsl:attribute>
                <xsl:attribute name="style:text-underline-type">double</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">auto</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'thick'">
                <xsl:attribute name="style:text-underline-style">solid</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dotted'">
                <xsl:attribute name="style:text-underline-style">dotted</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">auto</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dotted-heavy'">
                <xsl:attribute name="style:text-underline-style">dotted</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dash'">
                <xsl:attribute name="style:text-underline-style">dash</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">auto</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dashed-heavy'">
                <xsl:attribute name="style:text-underline-style">dash</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dash-long'">
                <xsl:attribute name="style:text-underline-style">long-dash</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">auto</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dash-long-heavy'">
                <xsl:attribute name="style:text-underline-style">long-dash</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dot-dash'">
                <xsl:attribute name="style:text-underline-style">dot-dash</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">auto</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dash-dot-heavy'">
                <xsl:attribute name="style:text-underline-style">dot-dash</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dot-dot-dash'">
                <xsl:attribute name="style:text-underline-style">dot-dot-dash</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">auto</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'dash-dot-dot-heavy'">
                <xsl:attribute name="style:text-underline-style">dot-dot-dash</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'wave'">
                <xsl:attribute name="style:text-underline-style">wave</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">auto</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'wavy-heavy'">
                <xsl:attribute name="style:text-underline-style">wave</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'wavy-double'">
                <xsl:attribute name="style:text-underline-style">wave</xsl:attribute>
                <xsl:attribute name="style:text-underline-type">double</xsl:attribute>
                <xsl:attribute name="style:text-underline-width">auto</xsl:attribute>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="@字:颜色">
                <xsl:attribute name="style:text-underline-color"><xsl:choose><xsl:when test="@字:颜色='auto'">font-color</xsl:when><xsl:otherwise><xsl:value-of select="@字:颜色"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="style:text-underline-color">font-color</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:着重号">
        <xsl:if test="not(@字:类型='none')">
            <xsl:choose>
                <xsl:when test="@字:类型='accent above' ">
                    <xsl:attribute name="style:text-emphasize">accent above</xsl:attribute>
                </xsl:when>
                <xsl:when test="@字:类型='dot above' ">
                    <xsl:attribute name="style:text-emphasize">dot above</xsl:attribute>
                </xsl:when>
                <xsl:when test="@字:类型='disc above' ">
                    <xsl:attribute name="style:text-emphasize">disc above</xsl:attribute>
                </xsl:when>
                <xsl:when test="@字:类型='circle above' ">
                    <xsl:attribute name="style:text-emphasize">circle above</xsl:attribute>
                </xsl:when>
                <xsl:when test="@字:类型='accent below' ">
                    <xsl:attribute name="style:text-emphasize">accent below</xsl:attribute>
                </xsl:when>
                <xsl:when test="@字:类型='dot below' ">
                    <xsl:attribute name="style:text-emphasize">dot below</xsl:attribute>
                </xsl:when>
                <xsl:when test="@字:类型='disc below' ">
                    <xsl:attribute name="style:text-emphasize">disc below</xsl:attribute>
                </xsl:when>
                <xsl:when test="@字:类型='circle below' ">
                    <xsl:attribute name="style:text-emphasize">circle below</xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="字:颜色">
            <xsl:attribute name="fo:color"><xsl:value-of select="@字:颜色"/></xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="字:隐藏文字">
        <xsl:attribute name="text:display"><xsl:value-of select="@字:值"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:空心">
        <xsl:attribute name="style:text-outline"><xsl:value-of select="@字:值"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:阴影">
        <xsl:if test="not(@字:值='false')">
            <xsl:attribute name="fo:text-shadow">1pt 1pt</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="字:删除线">
        <xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
        <xsl:choose>
            <xsl:when test="@字:类型='double'">
                <xsl:attribute name="style:text-line-through-type">double</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型='single'">
                <xsl:attribute name="style:text-underline-mode">continuous</xsl:attribute>
                <xsl:attribute name="style:text-line-through-mode">continuous</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型='bold'">
                <xsl:attribute name="style:text-line-through-width">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型='带/'">
                <xsl:attribute name="style:text-line-through-text">/</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型='带X'">
                <xsl:attribute name="style:text-line-through-text">X</xsl:attribute>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@字:颜色[not(.='auto')]">
        <xsl:attribute name="fo:color">#<xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:浮雕">
        <xsl:attribute name="style:font-relief"><xsl:choose><xsl:when test="@字:类型='engrave'">engraved</xsl:when><xsl:when test="@字:类型='emboss'">embossed</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:醒目字体">
        <xsl:choose>
            <xsl:when test="@字:类型='small-caps'">
                <xsl:attribute name="fo:font-variant">small-caps</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型='none'">
                <xsl:attribute name="fo:font-variant">normal</xsl:attribute>
                <xsl:attribute name="fo:text-transform">none</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="fo:text-transform"><xsl:choose><xsl:when test="@字:类型='uppercase'">uppercase</xsl:when><xsl:when test="@字:类型='lowercase'">lowercase</xsl:when><xsl:when test="@字:类型='capital'">capitalize</xsl:when></xsl:choose></xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:位置">
        <xsl:attribute name="style:text-position"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:缩放">
        <xsl:attribute name="style:text-scale"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:字符间距">
        <xsl:attribute name="fo:letter-spacing"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:调整字间距">
        <xsl:attribute name="style:letter-kerning"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:外框">
        <xsl:attribute name="style:text-outline">true</xsl:attribute>
    </xsl:template>
    <xsl:template match="字:缩放">
        <xsl:attribute name="style:text-scale"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:字符间距[parent::字:句属性]">
        <xsl:attribute name="fo:letter-spacing"><xsl:value-of select="concat( number(.)* $other-to-cm-conversion-factor, $uofUnit)"/></xsl:attribute>
    </xsl:template>
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
            <xsl:when test="$input-char='G' or $input-char='g' or $input-char='7' or $input-char='７' or $input-char='Roman_VII' or $input-char='Roman_vii' or $input-char='七' or $input-char='柒' or $input-char='庚' or $input-char='午'">
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
    <!-- 以下模板的作用是将网格线颜色由16进制转换为十进制 -->
    <xsl:template name="transform-hex-to-decimal">
        <xsl:param name="number"/>
        <xsl:variable name="R-color-number">
            <xsl:call-template name="color-hex-to-decimal">
                <xsl:with-param name="chars" select="substring($number,2,2)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="G-color-number">
            <xsl:call-template name="color-hex-to-decimal">
                <xsl:with-param name="chars" select="substring($number,4,2)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="B-color-number">
            <xsl:call-template name="color-hex-to-decimal">
                <xsl:with-param name="chars" select="substring($number,6,2)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$R-color-number * 65536 + $G-color-number * 256 + $B-color-number"/>
    </xsl:template>
    <!-- 以下模板的作用是为R或G或B颜色转换为十进制形式-->
    <xsl:template name="color-hex-to-decimal">
        <xsl:param name="chars"/>
        <xsl:variable name="first-num">
            <xsl:call-template name="hex-to-decimal">
                <xsl:with-param name="char" select="substring($chars,1,1)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="second-num">
            <xsl:call-template name="hex-to-decimal">
                <xsl:with-param name="char" select="substring($chars,2,1)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$first-num *16 + $second-num"/>
    </xsl:template>
    <xsl:template name="hex-to-decimal">
        <xsl:param name="char"/>
        <xsl:choose>
            <xsl:when test="$char='0'">0</xsl:when>
            <xsl:when test="$char='1'">1</xsl:when>
            <xsl:when test="$char='2'">2</xsl:when>
            <xsl:when test="$char='3'">3</xsl:when>
            <xsl:when test="$char='4'">4</xsl:when>
            <xsl:when test="$char='5'">5</xsl:when>
            <xsl:when test="$char='6'">6</xsl:when>
            <xsl:when test="$char='7'">7</xsl:when>
            <xsl:when test="$char='8'">8</xsl:when>
            <xsl:when test="$char='9'">9</xsl:when>
            <xsl:when test="$char='a'">10</xsl:when>
            <xsl:when test="$char='b'">11</xsl:when>
            <xsl:when test="$char='c'">12</xsl:when>
            <xsl:when test="$char='d'">13</xsl:when>
            <xsl:when test="$char='e'">14</xsl:when>
            <xsl:when test="$char='f'">15</xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- end -->
    <!--ro000179 chenjh-->
    <xsl:template name="search-left-top-in-tables">
        <xsl:param name="cellstylename"/>
        <xsl:param name="tableslist"/>
        <xsl:param name="return"/>
        <xsl:choose>
            <xsl:when test="$tableslist and $return=''">
                <xsl:variable name="firsttablerows" select="$tableslist[1]//表:行"/>
                <xsl:variable name="first-left-top">
                    <xsl:call-template name="search-left-top-inatable">
                        <xsl:with-param name="row-num" select="'1'"/>
                        <xsl:with-param name="firsttablerows" select="$firsttablerows"/>
                        <xsl:with-param name="cellstylename" select="$cellstylename"/>
                        <xsl:with-param name="return" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="rest-left-top">
                    <xsl:call-template name="search-left-top-in-tables">
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
    <!-- 以下模板的作用为在一个table中寻找左上角-->
    <xsl:template name="search-left-top-inatable">
        <xsl:param name="row-num"/>
        <xsl:param name="firsttablerows"/>
        <xsl:param name="cellstylename"/>
        <xsl:param name="return"/>
        <xsl:choose>
            <xsl:when test="$firsttablerows and $return=''">
                <xsl:variable name="firstcells" select="$firsttablerows[1]/表:单元格"/>
                <xsl:variable name="first-left-top">
                    <xsl:call-template name="search-left-top-inarow">
                        <xsl:with-param name="row-num" select="$row-num"/>
                        <xsl:with-param name="firstcells" select="$firstcells"/>
                        <xsl:with-param name="cellstylename" select="$cellstylename"/>
                        <xsl:with-param name="return" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="row-num-p">
                    <xsl:choose>
                        <xsl:when test="$firsttablerows[1]/@表:跨度">
                            <xsl:value-of select="$row-num+ $firsttablerows[1]/@表:跨度"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$row-num+1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rest-left-top">
                    <xsl:call-template name="search-left-top-inatable">
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
    <!-- 以下模板的作用为在某一行中寻找左上角-->
    <xsl:template name="search-left-top-inarow">
        <xsl:param name="row-num"/>
        <xsl:param name="firstcells"/>
        <xsl:param name="cellstylename"/>
        <xsl:param name="return"/>
        <xsl:choose>
            <xsl:when test="$firstcells and $return=''">
                <xsl:variable name="firstcell" select="$firstcells[1]"/>
                <xsl:variable name="first-left-top">
                    <xsl:call-template name="search-left-top-inacell">
                        <xsl:with-param name="row-num" select="$row-num"/>
                        <xsl:with-param name="cell" select="$firstcell"/>
                        <xsl:with-param name="cellstylename" select="$cellstylename"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="rest-left-top">
                    <xsl:call-template name="search-left-top-inarow">
                        <xsl:with-param name="row-num" select="$row-num"/>
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
    <!-- 以下的模板的作用为判断某个cell是否为左上角 -->
    <xsl:template name="search-left-top-inacell">
        <xsl:param name="row-num"/>
        <xsl:param name="cell"/>
        <xsl:param name="cellstylename"/>
        <xsl:choose>
            <xsl:when test="$cell/@表:式样引用=$cellstylename">
                <xsl:value-of select="concat($cell/ancestor::表:工作表/@表:名称,'.',$cell/@表:列号,' ',$row-num)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
                <!-- <xsl:variable name="style-is-default">
                    <xsl:call-template name="is-default-or-not-condition-format">
                        <xsl:with-param name="column-num" select="$cell/@表:列号"/>
                        <xsl:with-param name="cell" select="$cell"/>
                        <xsl:with-param name="preceding-cellstylename" select="''"/>
                        <xsl:with-param name="temp-num" select="'0'"/>
                        <xsl:with-param name="cellstylename" select="$cellstylename"/>
                        <xsl:with-param name="table-columns" select="$cell/ancestor::表:工作表内容//表:列"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$style-is-default='yes' ">
                        <xsl:value-of select="concat($cell/ancestor::表:工作表/@表:名称,'.',$cell/@表:列号,' ',$row-num)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose> -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="translate-left-top">
        <xsl:param name="left-top"/>
        <xsl:if test="$left-top!=''">
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
        </xsl:if>
    </xsl:template>
    <xsl:template name="create-the-condition-format-map">
        <xsl:param name="condition-format-set"/>
        <xsl:param name="current-left-top"/>
        <xsl:if test="$condition-format-set">
            <xsl:choose>
                <xsl:when test="contains($condition-format-set[1]/表:区域/text(),$current-left-top)">
                    <xsl:for-each select="$condition-format-set[1]/表:条件">
                        <xsl:variable name="condition-text">
                            <xsl:choose>
                                <xsl:when test="@表:类型='cell value'">
                                    <xsl:choose>
                                        <xsl:when test="表:操作码/text()='between' ">
                                            <xsl:value-of select="concat('cell-content-is-between','(',表:第一操作数/text(),',',表:第二操作数/text(),')')"/>
                                        </xsl:when>
                                        <xsl:when test=" 表:操作码/text()='not between'">
                                            <xsl:value-of select="concat('cell-content-is-not-between','(',表:第一操作数/text(),',',表:第二操作数/text(),')')"/>
                                        </xsl:when>
                                        <xsl:when test="表:操作码/text()='equal to'">
                                            <xsl:value-of select="concat('cell-content()=',表:第一操作数/text())"/>
                                        </xsl:when>
                                        <xsl:when test="表:操作码/text()='not equal to'">
                                            <xsl:value-of select="concat('cell-content()!=',表:第一操作数/text())"/>
                                        </xsl:when>
                                        <xsl:when test="表:操作码/text()='greater than'">
                                            <xsl:value-of select="concat('cell-content()&gt;',表:第一操作数/text())"/>
                                        </xsl:when>
                                        <xsl:when test="表:操作码/text()='less than'">
                                            <xsl:value-of select="concat('cell-content()&lt;',表:第一操作数/text())"/>
                                        </xsl:when>
                                        <xsl:when test="表:操作码/text()='greater than or equal to'">
                                            <xsl:value-of select="concat('cell-content()&gt;=',表:第一操作数/text())"/>
                                        </xsl:when>
                                        <xsl:when test="表:操作码/text()='less than or equal to'">
                                            <xsl:value-of select="concat('cell-content()&lt;=',表:第一操作数/text())"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="@表:类型='formula'">
                                    <xsl:value-of select="concat('is-true-formula','(',表:第一操作数/text(),')')"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:element name="style:map">
                            <xsl:attribute name="style:condition"><xsl:value-of select="$condition-text"/></xsl:attribute>
                            <xsl:attribute name="style:apply-style-name"><xsl:value-of select="//uof:单元格式样[@表:标识符=current()/表:格式/@表:式样引用]/@表:名称"/></xsl:attribute>
                            <xsl:attribute name="style:base-cell-address"><xsl:value-of select="substring-after($condition-format-set[1]/表:区域/text(),':')"/></xsl:attribute>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="create-the-condition-format-map">
                        <xsl:with-param name="condition-format-set" select="$condition-format-set[position()!=1]"/>
                        <xsl:with-param name="current-left-top" select="$current-left-top"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!--ro000179 end-->
</xsl:stylesheet>
