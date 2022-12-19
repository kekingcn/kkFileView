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
    <xsl:template match="uof:UOF">
        <office:document xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0" xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0" office:version="1.0">
            <xsl:apply-templates select="uof:元数据"/>
            <xsl:apply-templates select="uof:文字处理/字:公用处理规则/字:文档设置"/>
            <xsl:apply-templates select="uof:字体集"/>
            <xsl:apply-templates select="uof:式样集"/>
            <xsl:apply-templates select="uof:文字处理"/>
        </office:document>
    </xsl:template>
    <xsl:template match="uof:元数据">
        <xsl:element name="office:meta">
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
                <xsl:value-of select="uof:创建者"/>
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
            <meta:document-statistic>
               <xsl:attribute name="meta:page-count">
                    <xsl:choose>
                        <xsl:when test="child::*[@uof:locID='u0020']"><xsl:value-of select="uof:页数"/></xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体/字:段落/字:域开始[@字:类型='numpages']">
                                <xsl:variable name="date0" select="substring-after(../字:域代码/字:段落/字:句/字:文本串,' \* ')"/>
                                <xsl:variable name="fmt">
                                        <xsl:value-of select="substring-before($date0,' \*')"/>
                                </xsl:variable>
                                <xsl:if test="$fmt='Arabic'"><xsl:value-of select="following-sibling::字:句/字:文本串"/></xsl:if>
                                <xsl:if test="not($fmt='Arabic')">
                                    <xsl:variable name="content">
                                        <xsl:value-of select="following-sibling::字:句/字:文本串"/>
                                    </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when test="$content='I' or $content='i' or $content='A' or $content='a'">1</xsl:when>
                                        <xsl:when test="$content='II' or $content='ii' or $content='B' or $content='b'">2</xsl:when>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="meta:paragraph-count"><xsl:if test="child::*[@uof:locID='u0025']"><xsl:value-of select="uof:段落数"/></xsl:if></xsl:attribute>
               <xsl:attribute name="meta:word-count"><xsl:if test="child::*[@uof:locID='u0023']"><xsl:value-of select="uof:中文字符数"/></xsl:if></xsl:attribute>
               <xsl:attribute name="meta:object-count"><xsl:if test="child::*[@uof:locID='u0026']"><xsl:value-of select="uof:对象数"/></xsl:if></xsl:attribute>
               <xsl:attribute name="meta:character-count">
                    <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体/字:段落/字:域开始[@字:类型='numchars']">
                        <xsl:value-of select="following-sibling::字:句/字:文本串"/>
                    </xsl:for-each>
                    <xsl:if test="child::*[@uof:locID='u0021']"><xsl:value-of select="uof:字数"/></xsl:if>
               </xsl:attribute>
            </meta:document-statistic>
            <meta:document-statistic/>
        </xsl:element>
    </xsl:template>
    <xsl:variable name="uofUnit">
        <xsl:variable name="uu">
            <xsl:value-of select="/uof:UOF/uof:文字处理/字:公用处理规则/字:文档设置/字:度量单位"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$uu='cm'">cm</xsl:when>
            <xsl:when test="$uu='mm'">mm</xsl:when>
            <xsl:when test="$uu='pt'">pt</xsl:when>
            <xsl:when test="$uu='inch'">in</xsl:when>
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
    <xsl:template match="uof:式样集">
        <xsl:apply-templates select="uof:字体集"/>
        <xsl:variable name="default_paragraph_style" select="uof:段落式样"/>
        <xsl:variable name="default_character_style" select="uof:句式样"/>
        <xsl:variable name="default_table_style" select="uof:文字表式样"/>
        <office:styles>
            <xsl:if test="uof:段落式样[@字:类型 = 'default']">
                <style:default-style style:family="paragraph">
                    <xsl:element name="style:paragraph-properties">
                        <xsl:attribute name="style:tab-stop-distance"><xsl:value-of select="concat( number(/uof:UOF/uof:文字处理/字:公用处理规则/字:文档设置/字:默认制表位位置),$uofUnit)"/></xsl:attribute>
                    </xsl:element>
                    <xsl:element name="style:text-properties">
                        <xsl:choose>
                            <xsl:when test="/uof:UOF/uof:式样集/uof:字体集/uof:默认字体">
                                <xsl:attribute name="style:font-name"><xsl:value-of select="/uof:UOF//uof:字体集/uof:默认字体/@uof:ascii"/></xsl:attribute>
                                <xsl:attribute name="style:font-name-asian"><xsl:value-of select="/uof:UOF//uof:字体集/uof:默认字体/@uof:fareast"/></xsl:attribute>
                                <xsl:attribute name="style:font-name-complex"><xsl:value-of select="/uof:UOF//uof:字体集/uof:默认字体/@uof:cs"/></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:font-name">Times New Roman</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates select="uof:UOF/uof:式样集/uof:句式样/字:字体"/>
                        <xsl:if test="not(uof:UOF/uof:式样集/uof:句式样/字:字体/@字:字号 or uof:UOF/uof:式样集/uof:句属性/字:字体/@字:字号)">
                            <xsl:attribute name="fo:font-size">10pt</xsl:attribute>
                            <xsl:attribute name="fo:font-size-asian">10pt</xsl:attribute>
                            <xsl:attribute name="fo:font-size-complex">10pt</xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </style:default-style>
            </xsl:if>
            <xsl:for-each select="uof:段落式样[@字:类型='auto']">
                <xsl:element name="style:style">
                    <xsl:attribute name="style:family">paragraph</xsl:attribute>
                    <xsl:attribute name="style:name"><xsl:value-of select="@字:标识符"/></xsl:attribute>
                    <xsl:if test="@字:基式样引用">
                        <xsl:attribute name="style:parent-style-name"><xsl:value-of select="@字:基式样引用"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@字:别名">
                        <xsl:attribute name="style:display-name"><xsl:value-of select="@字:别名"/></xsl:attribute>
                    </xsl:if>
                    <xsl:element name="style:paragraph-properties">
                        <xsl:call-template name="XDParagraphAttr"/>
                        <xsl:apply-templates select="*[not(name()='字:大纲级别')]"/>
                        <xsl:if test="字:制表位设置">
                            <xsl:call-template name="ootab"/>
                        </xsl:if>
                    </xsl:element>
                    <xsl:element name="style:text-properties">
                        <xsl:apply-templates select="字:句属性/*"/>
                    </xsl:element>
                    <xsl:variable name="biaoshi" select="@字:标识符"/>
                    <xsl:for-each select="../uof:句式样">
                        <xsl:if test="@字:标识符=$biaoshi">
                            <xsl:element name="style:text-properties">
                                <xsl:apply-templates select="*"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="uof:句式样[@字:类型='auto']">
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name"><xsl:value-of select="@字:标识符"/></xsl:attribute>
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
            </xsl:for-each>
            <style:style style:name="ColumnBreakPara" style:family="paragraph">
                <style:text-properties fo:break-after="column"/>
            </style:style>
            <xsl:if test="uof:句式样">
                <style:default-style style:family="text"/>
            </xsl:if>
            <style:style style:name="Numbering Symbols" style:family="text"/>
            <style:style style:name="Bullet Symbols" style:family="text">
                <style:text-properties style:font-name="StarSymbol" fo:font-size="9pt" style:font-name-asian="StarSymbol" style:font-size-asian="9pt" style:font-name-complex="StarSymbol" style:font-size-complex="9pt"/>
            </style:style>
            <xsl:apply-templates select="uof:文字表式样" mode="table"/>
            <xsl:apply-templates select="uof:式样"/>
            <xsl:call-template name="脚注设置"/>
            <xsl:call-template name="尾注设置"/>
            <xsl:call-template name="行编号"/>
        </office:styles>
        <xsl:element name="office:automatic-styles">
            <style:style style:name="PageBreak" style:family="paragraph">
                <style:text-properties fo:break-before="page"/>
            </style:style>
            <xsl:apply-templates select="/uof:UOF/uof:文字处理/字:主体/字:段落/字:句/字:句属性" mode="style"/>
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体//字:句">
                <xsl:variable name="stylename1" select="字:句属性/@字:式样引用"/>
                <xsl:element name="style:style">
                    <xsl:variable name="stylenum">
                        <xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:句" format="1"/>
                    </xsl:variable>
                    <xsl:attribute name="style:name"><xsl:value-of select="concat('T',$stylenum)"/></xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="ancestor::字:段落式样">
                            <xsl:attribute name="style:family">paragraph</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:family">text</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:for-each select="/uof:UOF/uof:式样集/uof:句式样">
                        <xsl:if test="$stylename1=@字:标识符">
                            <xsl:choose>
                                <xsl:when test="@字:标识符=/uof:UOF/uof:文字处理/字:主体/字:段落/字:句/字:句属性/字:格式修订/@字:修订信息引用">
                                    <xsl:attribute name="style:parent-style-name"><xsl:value-of select="@字:标识符"/></xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="style:parent-style-name"><xsl:value-of select="@字:基式样引用"/></xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:element name="style:text-properties">
                        <xsl:for-each select="/uof:UOF/uof:式样集/uof:句式样">
                            <xsl:if test="$stylename1=@字:标识符">
                                <xsl:apply-templates select="./字:位置" mode="oo"/>
                                <xsl:apply-templates select="*[not(name()='字:位置')]"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体//字:域开始[@字:类型 = 'date']">
                <xsl:element name="number:date-style">
                    <xsl:attribute name="style:name">Date<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'date']"/></xsl:attribute>
                    <xsl:call-template name="日期域"/>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体//字:域开始[@字:类型 = 'createdate']">
                <xsl:element name="number:date-style">
                    <xsl:attribute name="style:name">CreateDate<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'createdate']"/></xsl:attribute>
                    <xsl:call-template name="日期域"/>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体//字:域开始[@字:类型 = 'savedate']">
                <xsl:element name="number:date-style">
                    <xsl:attribute name="style:name">SaveDate<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'savedate']"/></xsl:attribute>
                    <xsl:call-template name="日期域"/>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体//字:域开始[@字:类型 = 'time']">
                <xsl:element name="number:date-style">
                    <xsl:attribute name="style:name">Time<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'time']"/></xsl:attribute>
                    <xsl:call-template name="时间域"/>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体//字:域开始[@字:类型 = 'edittime']">
                <xsl:element name="number:time-style">
                    <xsl:attribute name="style:name">EditTime<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'edittime']"/></xsl:attribute>
                    <xsl:call-template name="编辑时间"/>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体//字:域开始[@字:类型 = 'createtime']">
                <xsl:element name="number:time-style">
                    <xsl:attribute name="style:name">CREATETIME<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'createtime']"/></xsl:attribute>
                    <xsl:call-template name="创建时间"/>
                </xsl:element>
            </xsl:for-each>
            <xsl:apply-templates select="/uof:UOF/uof:文字处理/字:主体//字:文字表[not(@字:类型='sub-table')]" mode="style"/>
            <xsl:apply-templates select="/uof:UOF/uof:文字处理/字:主体//字:单元格" mode="style"/>
            <xsl:apply-templates select="/uof:UOF/uof:文字处理/字:主体//字:行[not(../../@字:类型='sub-table')]" mode="style"/>
            <xsl:apply-templates select="/uof:UOF/uof:文字处理/字:主体//字:列宽集[not(../../@字:类型='sub-table')]" mode="style"/>
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体//字:自动编号信息">
                <xsl:variable name="currlistid" select="@字:编号引用"/>
                <xsl:variable name="currlist" select="."/>
                <xsl:variable name="rootlist" select="/uof:UOF/uof:式样集/uof:自动编号集/字:自动编号[@字:标识符 =$currlistid]"/>
                <xsl:if test="not(ancestor::字:段落/preceding-sibling::字:段落[1]/字:段落属性/字:自动编号信息/@字:编号引用= $currlistid)">
                    <xsl:element name="text:list-style">
                        <xsl:attribute name="style:name">List<xsl:value-of select="count(preceding::字:自动编号信息)"/></xsl:attribute>
                        <xsl:for-each select="$rootlist">
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
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体//字:节属性">
                <xsl:element name="style:page-layout">
                    <xsl:attribute name="style:name">pm<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any"/></xsl:attribute>
                    <xsl:if test="字:对称页边距/@字:值='true'">
                        <xsl:attribute name="style:page-usage">mirrored</xsl:attribute>
                    </xsl:if>
                    <xsl:element name="style:page-layout-properties">
                        <xsl:if test="字:纸张方向">
                            <xsl:attribute name="style:print-orientation"><xsl:choose><xsl:when test="字:纸张方向='portrait'">portrait</xsl:when><xsl:when test="字:纸张方向='landscape'">landscape</xsl:when></xsl:choose></xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="fo:page-width"><xsl:value-of select="concat(字:纸张/@uof:宽度,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="fo:page-height"><xsl:value-of select="concat(字:纸张/@uof:高度,$uofUnit)"/></xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="字:页边距">
                                <xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(字:页边距/@uof:上 ,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(字:页边距/@uof:左,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(字:页边距/@uof:右,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(字:页边距/@uof:下,$uofUnit)"/></xsl:attribute>
                            </xsl:when>
                            <xsl:when test="字:装订线/@字:位置='top'">
                                <xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(字:页边距/@uof:上 ,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(字:页边距/@uof:左,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(字:页边距/@uof:右,$uofUnit)"/></xsl:attribute>
                            </xsl:when>
                            <xsl:when test="字:装订线/@字:位置='left' ">
                                <xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(字:页边距/@uof:上,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat((字:页边距/@uof:左+ 字:装订线/@字:距边界),$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(字:页边距/@uof:右,$uofUnit)"/></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(字:页边距/@uof:上,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(字:页边距/@uof:左,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(字:页边距/@uof:右,$uofUnit)"/></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(字:页边距/@uof:下,$uofUnit)"/></xsl:attribute>
                        <xsl:if test="字:拼页/@字:值='1' or 字:拼页/@字:值='true'">
                            <xsl:attribute name="style:page-usage">mirrored</xsl:attribute>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="string(字:文字排列方向)='vert-r2l'">
                                <xsl:attribute name="style:writing-mode">tb-rl</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="string(字:文字排列方向)='vert-l2r'">
                                <xsl:attribute name="style:writing-mode">tb-rl</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="string(字:文字排列方向)='hori-l2r'">
                                <xsl:attribute name="style:writing-mode">lr-tb</xsl:attribute>
                            </xsl:when>
                            <xsl:when test="string(字:文字排列方向)='hori-r2l'">
                                <xsl:attribute name="style:writing-mode">lr-tb</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:writing-mode">page</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="字:网格设置/@字:网格类型">
                            <xsl:attribute name="style:layout-grid-mode"><xsl:choose><xsl:when test="字:网格设置/@字:网格类型='line-char'">both-nosnap</xsl:when><xsl:when test="字:网格设置/@字:网格类型='char'">both</xsl:when><xsl:when test="字:网格设置/@字:网格类型='line'">line</xsl:when><xsl:when test="字:网格设置/@字:网格类型='none'">none</xsl:when></xsl:choose></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:网格设置/@字:宽度">
                            <xsl:attribute name="style:layout-grid-base-width"><xsl:value-of select="concat(字:网格设置/@字:宽度,$uofUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:网格设置/@字:高度">
                            <xsl:attribute name="style:layout-grid-base-height"><xsl:value-of select="concat(字:网格设置/@字:高度,$uofUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:网格设置/@字:显示网格">
                            <xsl:attribute name="style:layout-grid-display"><xsl:value-of select="字:网格设置/@字:显示网格"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:网格设置/@字:打印网格">
                            <xsl:attribute name="style:layout-grid-print"><xsl:value-of select="字:网格设置/@字:打印网格"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:稿纸设置/@字:类型">
                            <xsl:attribute name="style:layout-grid-mode"><xsl:choose><xsl:when test="字:稿纸设置/@字:类型='draft-paper' ">both</xsl:when><xsl:when test="字:稿纸设置/@字:类型='letter-paper' ">line</xsl:when><xsl:otherwise>both</xsl:otherwise></xsl:choose></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:稿纸设置/@字:格式">
                            <xsl:choose>
                                <xsl:when test="字:稿纸设置/@字:格式='fourth-gear'">
                                    <xsl:attribute name="style:layout-grid-base-width">0.728cm</xsl:attribute>
                                    <xsl:attribute name="style:layout-grid-base-height">0.728cm</xsl:attribute>
                                    <xsl:attribute name="style:layout-grid-ruby-height">0.496cm</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="字:稿纸设置/@字:格式='third-gear'">
                                    <xsl:attribute name="style:layout-grid-base-width">0.584cm</xsl:attribute>
                                    <xsl:attribute name="style:layout-grid-base-height">0.584cm</xsl:attribute>
                                    <xsl:attribute name="style:layout-grid-ruby-height">0.64cm</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="字:稿纸设置/@字:格式='second-gear'">
                                    <xsl:attribute name="style:layout-grid-base-width">0.728cm</xsl:attribute>
                                    <xsl:attribute name="style:layout-grid-base-height">0.728cm</xsl:attribute>
                                    <xsl:attribute name="style:layout-grid-ruby-height">0.905cm</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="字:稿纸设置/@字:格式='first-gear'">
                                    <xsl:attribute name="style:layout-grid-base-width">0.728cm</xsl:attribute>
                                    <xsl:attribute name="style:layout-grid-base-height">0.728cm</xsl:attribute>
                                    <xsl:attribute name="style:layout-grid-ruby-height">1.633cm</xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:attribute name="style:layout-grid-display">true</xsl:attribute>
                            <xsl:attribute name="style:layout-grid-print">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:稿纸设置/@字:颜色">
                            <xsl:attribute name="style:layout-grid-color"><xsl:value-of select="字:稿纸设置/@字:颜色"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:边框">
                            <xsl:for-each select="字:边框">
                                <xsl:call-template name="uof:边框"/>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="字:填充">
                            <xsl:for-each select="字:填充">
                                <xsl:call-template name="uof:填充"/>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:apply-templates select="字:填充"/>
                        <xsl:attribute name="style:num-format"><xsl:variable name="format"><xsl:value-of select="字:页码设置/@字:格式"/></xsl:variable><xsl:call-template name="oo数字格式"><xsl:with-param name="oo_format" select="$format"/></xsl:call-template></xsl:attribute>
                        <xsl:if test="字:纸张来源/@字:其他页">
                            <xsl:attribute name="style:paper-tray-name"><xsl:value-of select="字:纸张来源/@字:其他页"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:分栏/@字:栏数">
                            <xsl:apply-templates select="字:分栏"/>
                        </xsl:if>
                    </xsl:element>
                    <xsl:if test="字:页眉位置">
                        <style:header-style>
                            <xsl:element name="style:header-footer-properties">
                                <xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(字:页眉位置/@字:距边界,$uofUnit)"/></xsl:attribute>
                                <xsl:variable name="long1" select="字:页眉位置/@字:距边界"/>
                                <xsl:variable name="long2" select="字:页眉位置/@字:距版芯"/>
                                <xsl:variable name="long" select="$long1 + $long2"/>
                                <xsl:attribute name="svg:height"><xsl:value-of select="concat($long,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="style:dynamic-spacing">false</xsl:attribute>
                            </xsl:element>
                        </style:header-style>
                    </xsl:if>
                    <xsl:if test="字:页脚位置">
                        <style:footer-style>
                            <xsl:element name="style:header-footer-properties">
                                <xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(字:页脚位置/@字:距边界,$uofUnit)"/></xsl:attribute>
                                <xsl:variable name="long1" select="字:页脚位置/@字:距边界"/>
                                <xsl:variable name="long2" select="字:页脚位置/@字:距版芯"/>
                                <xsl:variable name="long" select="$long1 + $long2"/>
                                <xsl:attribute name="svg:height"><xsl:value-of select="concat($long,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="style:dynamic-spacing">false</xsl:attribute>
                            </xsl:element>
                        </style:footer-style>
                    </xsl:if>
                </xsl:element>
                <xsl:if test="字:分栏/@字:栏数">
                    <xsl:element name="style:style">
                        <xsl:attribute name="style:name">sect<xsl:value-of select="count(preceding::字:节属性[字:分栏/@字:栏数])"/></xsl:attribute>
                        <xsl:attribute name="style:family">section</xsl:attribute>
                        <xsl:element name="style:page-layout-properties">
                            <xsl:element name="style:columns">
                                <xsl:attribute name="fo:column-count"><xsl:value-of select="number(字:分栏/@字:栏数)"/></xsl:attribute>
                                <xsl:attribute name="fo:column-gap"><xsl:value-of select="concat(number(字:分栏/@字:分割线宽度),$uofUnit)"/></xsl:attribute>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象/@uof:公有类型='png' or /uof:UOF/uof:对象集/uof:其他对象/@uof:公有类型='jpg' or /uof:UOF/uof:对象集/uof:其他对象/@uof:公有类型='bmp' or /uof:UOF/uof:对象集/uof:其他对象/@uof:公有类型='gif' or /uof:UOF/uof:对象集/uof:其他对象/@uof:私有类型='图片'">
                <style:style style:name="Graphics" style:family="graphic">
                    <style:graphic-properties text:anchor-type="paragraph" svg:x="0cm" svg:y="0cm" style:wrap="none" style:vertical-pos="top" style:vertical-rel="paragraph" style:horizontal-pos="center" style:horizontal-rel="paragraph"/>
                </style:style>
            </xsl:if>
            <xsl:apply-templates select="/uof:UOF/uof:对象集/图:图形"/>
            <xsl:apply-templates select="/uof:UOF/uof:对象集/图:图形/图:文本内容/字:段落/字:句/字:句属性" mode="style"/>
            <xsl:call-template name="duanluoshuxing"/>
        </xsl:element>
        <office:master-styles>
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体//字:节属性">
                <xsl:element name="style:master-page">
                    <xsl:variable name="master-page-name">
                        <xsl:number count="字:节属性" from="/uof:UOF/uof:文字处理/字:主体" level="any"/>
                    </xsl:variable>
                    <xsl:attribute name="style:name"><xsl:choose>
                        <xsl:when test="../@字:名称"><xsl:value-of select="../@字:名称"/></xsl:when>
                        <xsl:otherwise>Standard</xsl:otherwise>
                    </xsl:choose></xsl:attribute>
                    <xsl:attribute name="style:page-layout-name"><xsl:value-of select="concat('pm', $master-page-name)"/></xsl:attribute>
                    <xsl:if test="following::字:节属性">
                        <xsl:attribute name="style:next-style-name">Standard<xsl:value-of select="$master-page-name +1"/></xsl:attribute>
                    </xsl:if>
                    <xsl:for-each select="字:页眉">
                        <xsl:if test="字:首页页眉 or 字:奇数页页眉">
                            <xsl:element name="style:header">
                                <xsl:apply-templates select="字:奇数页页眉/字:段落 | 字:首页页眉/字:段落 | 字:奇数页页眉/字:文字表 | 字:首页页眉/字:文字表"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="字:偶数页页眉">
                            <xsl:element name="style:header-left">
                                <xsl:apply-templates select="字:偶数页页眉/字:段落 | 字:偶数页页眉/字:文字表"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="字:页脚">
                        <xsl:if test="字:奇数页页脚 or 字:首页页脚">
                            <xsl:element name="style:footer">
                                <xsl:apply-templates select="字:奇数页页脚/字:段落 | 字:首页页脚/字:段落 | 字:奇数页页脚/字:文字表 | 字:首页页脚/字:文字表"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="字:偶数页页脚">
                            <xsl:element name="style:footer-left">
                                <xsl:apply-templates select="字:偶数页页脚/字:段落 | 字:偶数页页脚/字:文字表"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="字:奇偶页页眉页脚不同">
                        <xsl:element name="style:header-left">
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:for-each>
        </office:master-styles>
    </xsl:template>
    <xsl:template match="字:填充">
        <xsl:choose>
            <xsl:when test="图:颜色">
                <xsl:attribute name="fo:background-color"><xsl:value-of select="图:颜色"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="图:图案/@图:背景色">
                <xsl:attribute name="style:text-background-color"><xsl:choose><xsl:when test="contains(图:图案/@图:背景色,'#')"><xsl:value-of select="图:图案/@图:背景色"/></xsl:when><xsl:otherwise>auto</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:when>
            <xsl:when test="图:图案/@图:前景色">
                <xsl:attribute name="fo:text-background-color"><xsl:choose><xsl:when test="contains(图:图案/@图:前景色,'#')"><xsl:value-of select="图:图案/@图:前景色"/></xsl:when><xsl:otherwise>auto</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:分栏">
        <xsl:element name="style:columns">
            <xsl:attribute name="fo:column-count"><xsl:value-of select="//字:分栏/@字:栏数"/></xsl:attribute>
            <xsl:variable name="aa">
                <xsl:value-of select="//字:分栏/字:栏[position()=1]/@字:间距"/>
            </xsl:variable>
            <xsl:if test="//字:分栏/@字:等宽='true' ">
                <xsl:attribute name="fo:column-gap"><xsl:value-of select="concat($aa * 2,$uofUnit)"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="//字:分栏/@字:分隔线宽度">
                <xsl:element name="style:column-sep">
                    <xsl:attribute name="style:width"><xsl:value-of select="concat(@字:分隔线宽度,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="style:color"><xsl:value-of select="@字:分隔线颜色"/></xsl:attribute>
                    <xsl:attribute name="style:height">100%</xsl:attribute>
                    <xsl:attribute name="style:vertical-align">top</xsl:attribute>
                </xsl:element>
            </xsl:if>
            <xsl:for-each select="//字:分栏/字:栏">
                <xsl:element name="style:column">
                    <xsl:attribute name="style:rel-width"><xsl:value-of select="@字:宽度"/>*</xsl:attribute>
                    <xsl:if test="parent::字:分栏/@字:宽度='true'">
                        <xsl:choose>
                            <xsl:when test="self::node()[not(preceding-sibling::字:栏)]">
                                <xsl:attribute name="fo:start-indent">0cm</xsl:attribute>
                                <xsl:attribute name="fo:end-indent"><xsl:value-of select="concat(@字:间距,$uofUnit)"/></xsl:attribute>
                            </xsl:when>
                            <xsl:when test="self::node()[not(following-sibling::字:栏)]">
                                <xsl:attribute name="fo:start-indent"><xsl:value-of select="concat(@字:间距,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:end-indent">0cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="fo:start-indent"><xsl:value-of select="concat(@字:间距,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:end-indent"><xsl:value-of select="concat(@字:间距,$uofUnit)"/></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="parent::字:分栏/@字:等宽='false'">
                        <xsl:variable name="last" select="preceding-sibling::字:栏[1]/@字:间距"/>
                        <xsl:choose>
                            <xsl:when test="self::node()[not(preceding-sibling::字:栏)]">
                                <xsl:attribute name="fo:start-indent">0cm</xsl:attribute>
                                <xsl:attribute name="fo:end-indent"><xsl:value-of select="concat(@字:间距,$uofUnit)"/></xsl:attribute>
                            </xsl:when>
                            <xsl:when test="self::node()[not(following-sibling::字:栏)]">
                                <xsl:attribute name="fo:start-indent"><xsl:value-of select="concat($last,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:end-indent">0cm</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="fo:start-indent"><xsl:value-of select="concat($last,$uofUnit)"/></xsl:attribute>
                                <xsl:attribute name="fo:end-indent"><xsl:value-of select="concat(@字:间距,$uofUnit)"/></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match="uof:文字表式样" mode="table">
        <style:style style:family="table">
            <xsl:attribute name="style:name"><xsl:value-of select="@字:标识符"/></xsl:attribute>
            <xsl:if test="@字:基式样引用">
                <xsl:attribute name="style:parent-style-name"><xsl:value-of select="@字:基式样引用"/></xsl:attribute>
            </xsl:if>
            <style:table-properties>
                <xsl:choose>
                    <xsl:when test="字:对齐">
                        <xsl:attribute name="table:align"><xsl:value-of select="字:对齐"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="table:align">margins</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="字:宽度/@字:相对宽度">
                        <xsl:variable name="reltblw">
                            <xsl:value-of select="concat(number(字:宽度/@字:相对宽度),'%')"/>
                        </xsl:variable>
                        <xsl:variable name="pagew">
                            <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:纸张/@uof:宽度"/>
                        </xsl:variable>
                        <xsl:variable name="leftm">
                            <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:页边距/@uof:左"/>
                        </xsl:variable>
                        <xsl:variable name="rightm">
                            <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:页边距/@uof:右"/>
                        </xsl:variable>
                        <xsl:attribute name="style:rel-width"><xsl:value-of select="concat(number(字:宽度/@字:相对宽度) * 100,'%')"/></xsl:attribute>
                        <xsl:attribute name="style:width"><xsl:value-of select="concat((number($pagew)-number($leftm)-number($rightm)) * number($reltblw),$uofUnit)"/></xsl:attribute>
                    </xsl:when>
                    <xsl:when test="字:宽度/@字:绝对宽度">
                        <xsl:attribute name="style:width"><xsl:value-of select="concat(number(字:宽度/@字:绝对宽度),$uofUnit)"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </style:table-properties>
        </style:style>
    </xsl:template>
    <xsl:template match="字:文字表" mode="style">
        <xsl:element name="style:style">
            <xsl:attribute name="style:name">Table<xsl:number count="字:文字表[not (@字:类型='sub-table')]" from="/uof:UOF/uof:文字处理/字:主体" level="any" format="1"/></xsl:attribute>
            <xsl:attribute name="style:family">table</xsl:attribute>
            <xsl:if test="@字:式样引用">
                <xsl:attribute name="style:parent-style-name"><xsl:value-of select="@字:式样引用"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="name(preceding-sibling::*[1])='字:分节'">
                <xsl:attribute name="style:master-page-name"><xsl:value-of select="preceding-sibling::*[1]/@字:名称"/></xsl:attribute>
            </xsl:if>
            <xsl:element name="style:table-properties">
                <xsl:for-each select="字:文字表属性">
                    <xsl:variable name="biaoshi" select="@字:式样引用"/>
                    <xsl:choose>
                        <xsl:when test="字:对齐 = 'left' or 字:对齐 = 'center' or 字:对齐 = 'right'">
                            <xsl:attribute name="table:align"><xsl:value-of select="字:对齐"/></xsl:attribute>
                        </xsl:when>
                        <xsl:when test="/uof:UOF/uof:式样集/uof:文字表式样[@字:标识符=$biaoshi]/字:对齐">
                            <xsl:attribute name="table:align"><xsl:value-of select="/uof:UOF/uof:式样集/uof:文字表式样[@字:标识符=$biaoshi]/字:对齐"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="table:align">margins</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="字:左缩进">
                        <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(number(字:左缩进),$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="字:绕排/@字:值='around'">
                        <xsl:if test="字:绕排边距/@字:上">
                            <xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(字:绕排边距/@字:上,$uofUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:绕排边距/@字:左">
                            <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(字:绕排边距/@字:左,$uofUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:绕排边距/@字:右">
                            <xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(字:绕排边距/@字:右,$uofUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:绕排边距/@字:下">
                            <xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(字:绕排边距/@字:下,$uofUnit)"/></xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="@字:式样引用">
                        <xsl:variable name="rootStyle" select="@字:式样引用"/>
                        <xsl:variable name="rootStyleNode" select="/uof:UOF/uof:式样集/字:文字表式样[@字:基式样引用 = $rootStyle]"/>
                        <xsl:variable name="paddingleft">
                            <xsl:value-of select="$rootStyleNode/字:文字表属性/字:边距/@uof:左"/>
                        </xsl:variable>
                        <xsl:variable name="paddingright">
                            <xsl:value-of select="$rootStyleNode/字:文字表属性/字:边距/@uof:右"/>
                        </xsl:variable>
                        <xsl:variable name="paddingtop">
                            <xsl:value-of select="$rootStyleNode/字:文字表属性/字:边距/@uof:上"/>
                        </xsl:variable>
                        <xsl:variable name="paddingbottom">
                            <xsl:value-of select="$rootStyleNode/字:文字表属性/字:边距/@uof:下"/>
                        </xsl:variable>
                        <xsl:if test="$rootStyleNode/字:文字表属性/字:边距/@uof:左">
                            <xsl:attribute name="fo:margin-left">-<xsl:value-of select="(number($paddingleft))* $other-to-cm-conversion-factor"/>cm</xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="字:宽度/@字:相对宽度">
                            <xsl:variable name="reltblw">
                                <xsl:value-of select="字:宽度/@字:相对宽度"/>
                            </xsl:variable>
                            <xsl:variable name="pagew">
                                <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:纸张/@uof:宽度"/>
                            </xsl:variable>
                            <xsl:variable name="leftm">
                                <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:页边距/@uof:左"/>
                            </xsl:variable>
                            <xsl:variable name="rightm">
                                <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:页边距/@uof:右"/>
                            </xsl:variable>
                            <xsl:attribute name="style:rel-width"><xsl:value-of select="concat(number(字:宽度/@字:相对宽度) * 100,'%')"/></xsl:attribute>
                            <xsl:attribute name="style:width"><xsl:value-of select="concat((number($pagew)-number($leftm)-number($rightm)) * number($reltblw),$uofUnit)"/></xsl:attribute>
                        </xsl:when>
                        <xsl:when test="字:宽度/@字:绝对宽度">
                            <xsl:attribute name="style:width"><xsl:value-of select="concat(number(字:宽度/@字:绝对宽度),$uofUnit)"/></xsl:attribute>
                        </xsl:when>
                        <xsl:when test="/uof:UOF/uof:式样集/uof:文字表式样[@字:标识符=$biaoshi]/字:宽度/@字:相对宽度 or /uof:UOF/uof:式样集/uof:文字表式样[@字:标识符=$biaoshi]/字:宽度/@字:绝对宽度">
                            <xsl:attribute name="style:rel-width"><xsl:value-of select="concat(/uof:UOF/uof:式样集/uof:文字表式样[@字:标识符=$biaoshi]/字:宽度/@字:相对宽度 * 100,'%')"/></xsl:attribute>
                            <xsl:attribute name="style:width"><xsl:value-of select="/uof:UOF/uof:式样集/uof:文字表式样[@字:标识符=$biaoshi]/字:宽度/@字:绝对宽度"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="pagew">
                                <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:纸张/@uof:宽度"/>
                            </xsl:variable>
                            <xsl:variable name="leftm">
                                <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:页边距/@uof:左"/>
                            </xsl:variable>
                            <xsl:variable name="rightm">
                                <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:页边距/@uof:右"/>
                            </xsl:variable>
                            <xsl:attribute name="style:width"><xsl:value-of select="concat((number($pagew)-number($leftm)-number($rightm)),$uofUnit)"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:variable name="tblsize" select="sum(字:列宽集/字:列宽)"/>
                    <xsl:if test="(not($tblsize='0')) and not(字:宽度) ">
                        <xsl:choose>
                            <xsl:when test="字:左缩进">
                                <xsl:attribute name="style:width"><xsl:value-of select="concat( number($tblsize -  字:左缩进), $uofUnit)"/></xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style:width"><xsl:value-of select="concat( number(sum(字:列宽集/字:列宽) ), $uofUnit)"/></xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="字:边框">
                        <xsl:for-each select="字:边框">
                            <xsl:call-template name="uof:边框"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:for-each select="字:填充">
                        <xsl:call-template name="uof:填充"/>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="字:列宽集" mode="style">
        <xsl:choose>
            <xsl:when test="not(./字:列宽)">
                <xsl:for-each select="../..">
                    <xsl:for-each select="字:行[1]/字:单元格">
                        <xsl:element name="style:style">
                            <xsl:attribute name="style:family">table-column</xsl:attribute>
                            <xsl:attribute name="style:name">Table<xsl:number count="字:文字表" from="/uof:UOF/uof:文字处理/字:主体" level="any" format="1"/>.C<xsl:number value="count(preceding::字:单元格)+1"/></xsl:attribute>
                            <xsl:element name="style:table-column-properties">
                                <xsl:choose>
                                    <xsl:when test="字:单元格属性/字:宽度/@字:相对值">
                                        <xsl:variable name="tblw1">
                                            <xsl:choose>
                                                <xsl:when test="../../字:文字表属性/字:宽度/@字:绝对宽度">
                                                    <xsl:value-of select="../../字:文字表属性/字:宽度/@字:绝对宽度"/>
                                                </xsl:when>
                                                <xsl:when test="../../字:文字表属性/字:宽度/@字:相对宽度">
                                                    <xsl:variable name="pagew">
                                                        <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:纸张/@uof:宽度"/>
                                                    </xsl:variable>
                                                    <xsl:variable name="leftm">
                                                        <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:页边距/@uof:左"/>
                                                    </xsl:variable>
                                                    <xsl:variable name="rightm">
                                                        <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:页边距/@uof:右"/>
                                                    </xsl:variable>
                                                    <xsl:variable name="relw">
                                                        <xsl:value-of select="../../字:文字表属性/字:宽度/@字:相对宽度"/>
                                                    </xsl:variable>
                                                    <xsl:value-of select=" ( number($pagew)-number($leftm)-number($rightm))* number($relw) div 100"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:variable name="pagew">
                                                        <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:纸张/@uof:宽度"/>
                                                    </xsl:variable>
                                                    <xsl:variable name="leftm">
                                                        <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:页边距/@uof:左"/>
                                                    </xsl:variable>
                                                    <xsl:variable name="rightm">
                                                        <xsl:value-of select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:页边距/@uof:右"/>
                                                    </xsl:variable>
                                                    <xsl:value-of select="(number($pagew)-number($leftm)-number($rightm))"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:attribute name="style:column-width"><xsl:value-of select="concat(number(number($tblw1)*number(字:单元格属性/字:宽度/@字:相对值) div 100),$uofUnit)"/></xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="字:单元格属性/字:宽度/@字:绝对值">
                                        <xsl:attribute name="style:column-width"><xsl:value-of select="concat(number(字:单元格属性/字:宽度/@字:绝对值),$uofUnit)"/></xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="style:column-width"><xsl:value-of select="'1cm'"/></xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="字:列宽">
                    <xsl:element name="style:style">
                        <xsl:attribute name="style:family">table-column</xsl:attribute>
                        <xsl:attribute name="style:name">Table<xsl:number count="字:文字表[not (@字:类型='sub-table')]" from="/uof:UOF/uof:文字处理/字:主体" level="any" format="1"/>.C<xsl:number count="字:列宽" from="/uof:UOF/uof:文字处理/字:主体" level="single" format="1"/></xsl:attribute>
                        <xsl:variable name="tableRoot" select="ancestor::字:文字表"/>
                        <xsl:element name="style:table-column-properties">
                            <xsl:choose>
                                <xsl:when test="string(.)">
                                    <xsl:attribute name="style:column-width"><xsl:value-of select="concat(.,$uofUnit)"/></xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="style:column-width"><xsl:value-of select="'1cm'"/></xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:行" mode="style">
        <xsl:element name="style:style">
            <xsl:attribute name="style:family">table-row</xsl:attribute>
            <xsl:attribute name="style:name">Table<xsl:number count="字:文字表[not (@字:类型='sub-table')]" from="/uof:UOF/uof:文字处理/字:主体" level="any" format="1"/>.R<xsl:number count="字:行" from="/uof:UOF/uof:文字处理/字:主体/字:文字表[not (@字:类型='sub-table')]" level="any" format="1"/></xsl:attribute>
            <xsl:element name="style:table-row-properties">
                <xsl:for-each select="字:表行属性">
                    <xsl:choose>
                        <xsl:when test="字:高度/@字:固定值">
                            <xsl:attribute name="style:row-height"><xsl:value-of select="concat(number(字:高度/@字:固定值),$uofUnit)"/></xsl:attribute>
                        </xsl:when>
                        <xsl:when test="字:高度/@字:最小值">
                            <xsl:attribute name="style:min-row-height"><xsl:value-of select="concat(number(字:高度/@字:最小值), $uofUnit )"/></xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:attribute name="fo:keep-together"><xsl:value-of select="字:跨页/@字:值"/></xsl:attribute>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="字:单元格" mode="style">
        <style:style>
            <xsl:attribute name="style:name">Table<xsl:number count="字:文字表[not (@字:类型='sub-table')]" from="/uof:UOF/uof:文字处理/字:主体" level="any" format="1"/>.R<xsl:number count="字:行" from="/uof:UOF/uof:文字处理/字:主体/字:文字表[not (@字:类型='sub-table')]" level="any" format="1"/>C<xsl:number count="字:单元格" from="/uof:UOF/uof:文字处理/字:主体/字:文字表[not (@字:类型='sub-table')]/字:行" level="any" format="1"/></xsl:attribute>
            <xsl:attribute name="style:family">table-cell</xsl:attribute>
            <xsl:element name="style:table-cell-properties">
                <xsl:for-each select="字:单元格属性">
                    <xsl:choose>
                        <xsl:when test="字:单元格边距/@字:左">
                            <xsl:attribute name="fo:padding-left"><xsl:value-of select="concat(number(字:单元格边距/@字:左),$uofUnit)"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="fo:padding-left"><xsl:value-of select="../../../../字:文字表属性/字:默认单元格边距/@字:左"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="字:单元格边距/@字:右">
                            <xsl:attribute name="fo:padding-right"><xsl:value-of select="concat(number(字:单元格边距/@字:右),$uofUnit)"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="fo:padding-right"><xsl:value-of select="../../../../字:文字表属性/字:默认单元格边距/@字:右"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="字:单元格边距/@字:上">
                            <xsl:attribute name="fo:padding-top"><xsl:value-of select="concat(number(字:单元格边距/@字:上),$uofUnit)"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="fo:padding-top"><xsl:value-of select="../../../../字:文字表属性/字:默认单元格边距/@字:上"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="字:单元格边距/@字:下">
                            <xsl:attribute name="fo:padding-bottom"><xsl:value-of select="concat(number(字:单元格边距/@字:下),$uofUnit)"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="fo:padding-bottom"><xsl:value-of select="../../../../字:文字表属性/字:默认单元格边距/@字:下"/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:variable name="cellbefore">
                        <xsl:value-of select="count(ancestor::字:单元格/preceding-sibling::字:单元格)"/>
                    </xsl:variable>
                    <xsl:variable name="cellafter">
                        <xsl:value-of select="count(ancestor::字:单元格/following-sibling::字:单元格)"/>
                    </xsl:variable>
                    <xsl:variable name="rowbefore">
                        <xsl:value-of select="count(ancestor::字:行/preceding-sibling::字:行)"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="字:边框">
                            <xsl:for-each select="字:边框">
                                <xsl:call-template name="uof:边框"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="number($cellafter) &gt; 0">
                                    <xsl:attribute name="fo:border-right">none</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="fo:border-right">0.002cm solid #000000</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:attribute name="fo:border-left">0.002cm solid #000000</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="number($rowbefore) &gt; 0">
                                    <xsl:attribute name="fo:border-top">none</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="fo:border-top">0.002cm solid #000000</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:attribute name="fo:border-bottom">0.002cm solid #000000</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="style:vertical-align"><xsl:choose><xsl:when test="字:垂直对齐方式='center' ">middle</xsl:when><xsl:when test="字:垂直对齐方式='bottom' ">bottom</xsl:when><xsl:otherwise>top</xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:for-each select="字:填充">
                        <xsl:call-template name="uof:填充"/>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
        </style:style>
    </xsl:template>
    <xsl:template match="uof:字体集">
        <xsl:element name="office:font-face-decls">
            <style:font-face style:name="Arial" svg:font-family="Arial" style:font-family-generic="roman" style:font-pitch="variable"/>
            <style:font-face style:name="Times New Roman" svg:font-family="'Times New Roman'" style:font-family-generic="roman" style:font-pitch="variable"/>
            <style:font-face style:name="Symbol" svg:font-family="Symbol" style:font-family-generic="roman" style:font-pitch="variable" style:font-charset="x-symbol"/>
            <style:font-face style:name="Courier New" svg:font-family="'Courier New'" style:font-family-generic="modern" style:font-pitch="fixed"/>
            <xsl:if test="not(uof:字体声明[@uof:名称='StarSymbol'])">
                <style:font-face style:name="StarSymbol" svg:font-family="StarSymbol" style:font-charset="x-symbol"/>
            </xsl:if>
            <xsl:for-each select="uof:字体声明">
                <xsl:element name="style:font-face">
                    <xsl:attribute name="style:name"><xsl:value-of select="@uof:标识符"/></xsl:attribute>
                    <xsl:attribute name="svg:font-family"><xsl:value-of select="@uof:名称"/></xsl:attribute>
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
        </xsl:element>
    </xsl:template>
    <xsl:template match="uof:式样">
        <xsl:element name="style:text-properties">
            <xsl:apply-templates select="uof:句式样/*"/>
            <xsl:apply-templates select="uof:段落式样/*"/>
            <xsl:call-template name="paragraph-properties"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="uof:段落式样"/>
    <xsl:template match="uof:句式样"/>
    <xsl:template match="字:公用处理规则">
        <xsl:apply-templates select="uof:文字处理/字:公用处理规则/字:文档设置"/>
    </xsl:template>
    <xsl:template match="uof:文字处理/字:公用处理规则/字:文档设置">
        <office:settings>
            <config:config-item-set config:name="ooo:view-settings">
                <config:config-item config:name="InBrowseMode" config:type="boolean">
                    <xsl:choose>
                        <xsl:when test="字:当前视图='web'">true</xsl:when>
                        <xsl:otherwise>false</xsl:otherwise>
                    </xsl:choose>
                </config:config-item>
                <config:config-item-map-indexed config:name="Views">
                    <config:config-item-map-entry>
                        <xsl:if test="字:缩放">
                            <config:config-item config:name="VisibleRight" config:type="int">1</config:config-item>
                            <config:config-item config:name="VisibleBottom" config:type="int">1</config:config-item>
                            <xsl:choose>
                                <xsl:when test="字:缩放 = 'best-fit'">
                                    <config:config-item config:name="ZoomType" config:type="short">3</config:config-item>
                                </xsl:when>
                                <xsl:when test="字:缩放 = 'full-page'">
                                    <config:config-item config:name="ZoomType" config:type="short">2</config:config-item>
                                </xsl:when>
                                <xsl:when test="字:缩放 = 'text-fit'">
                                    <config:config-item config:name="ZoomType" config:type="short">1</config:config-item>
                                </xsl:when>
                                <xsl:otherwise>
                                    <config:config-item config:name="ZoomType" config:type="short">0</config:config-item>
                                </xsl:otherwise>
                            </xsl:choose>
                            <config:config-item config:name="ZoomFactor" config:type="short">
                                <xsl:value-of select="字:缩放"/>
                            </config:config-item>
                        </xsl:if>
                    </config:config-item-map-entry>
                </config:config-item-map-indexed>
            </config:config-item-set>
            <config:config-item-set config:name="configuration-settings">
                <config:config-item-map-indexed config:name="ForbiddenCharacters">
                    <config:config-item-map-entry>
                        <config:config-item config:name="Language" config:type="string">zh</config:config-item>
                        <config:config-item config:name="Country" config:type="string">CN</config:config-item>
                        <config:config-item config:name="Variant" config:type="string"/>
                        <config:config-item config:name="BeginLine" config:type="string">
                            <xsl:choose>
                                <xsl:when test="字:标点禁则/字:行首字符 or *[@uof:locID='t0007']/*[@uof:locID='t0008']">
                                    <xsl:value-of select="*[@uof:locID='t0007']/*[@uof:locID='t0008']"/>
                                </xsl:when>
                                <xsl:otherwise>:!),.:;?]}_'"、。〉》」』】〕〗〞︰︱︳﹐_﹒﹔﹕﹖﹗﹚﹜﹞！），．：；？｜｝︴︶︸︺︼︾﹀﹂﹄﹏_～￠々‖_·ˇˉ―--′</xsl:otherwise>
                            </xsl:choose>
                        </config:config-item>
                        <config:config-item config:name="EndLine" config:type="string">
                            <xsl:choose>
                                <xsl:when test="字:标点禁则/字:行尾字符 or  *[@uof:locID='t0007']/*[@uof:locID='t0009']">
                                    <xsl:value-of select="*[@uof:locID='t0007']/*[@uof:locID='t0009']"/>
                                </xsl:when>
                                <xsl:otherwise>([{__'"‵〈《「『【〔〖（［｛￡￥〝︵︷︹︻︽︿﹁﹃﹙﹛﹝（｛</xsl:otherwise>
                            </xsl:choose>
                        </config:config-item>
                    </config:config-item-map-entry>
                </config:config-item-map-indexed>
            </config:config-item-set>
        </office:settings>
    </xsl:template>
    <xsl:template match="uof:文字处理">
        <xsl:element name="office:body">
            <xsl:element name="office:text">
                <xsl:call-template name="GenerateTrackChanges"/>
                <text:sequence-decls>
                    <xsl:call-template name="default_sequence_declaration"/>
                </text:sequence-decls>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="default_sequence_declaration">
        <text:sequence-decl text:display-outline-level="0" text:name="Illustration">
            </text:sequence-decl>
        <text:sequence-decl text:display-outline-level="0" text:name="Table">
            </text:sequence-decl>
        <text:sequence-decl text:display-outline-level="0" text:name="Text">
            </text:sequence-decl>
        <text:sequence-decl text:display-outline-level="0" text:name="Drawing">
            </text:sequence-decl>
        <text:sequence-decl text:display-outline-level="0" text:name="AutoNr">
            </text:sequence-decl>
    </xsl:template>
    <xsl:template name="段落" match="字:段落[not((preceding-sibling::字:段落/字:域开始) and (not(preceding-sibling::字:段落/字:域结束)))][not(字:段落属性[字:自动编号信息])]">
        <xsl:if test="字:域开始/@字:类型='caption'">
            <xsl:apply-templates select="字:域代码"/>
        </xsl:if>
        <xsl:if test="字:域开始/@字:类型='REF'">
            <xsl:call-template name="目录域"/>
        </xsl:if>
        <xsl:if test="字:域开始/@字:类型='INDEX'">
            <xsl:call-template name="索引域"/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="string(parent::node()/@uof:locID)='t0107'">
                <xsl:apply-templates select="字:脚注"/>
            </xsl:when>
            <xsl:when test="string(parent::node()/@uof:locID)='t0108'">
                <xsl:apply-templates select="字:尾注"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="commonParagraph"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:脚注">
        <xsl:element name="text:note">
            <xsl:attribute name="text:note-class">footnote</xsl:attribute>
            <xsl:element name="text:note-citation">
                <xsl:attribute name="text:label"><xsl:value-of select="@字:引文体"/></xsl:attribute>
                <xsl:value-of select="@字:引文体"/>
            </xsl:element>
            <xsl:element name="text:note-body">
                <xsl:for-each select="字:段落">
                    <xsl:call-template name="commonParagraph"/>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="字:尾注">
        <xsl:element name="text:note">
            <xsl:attribute name="text:note-class">endnote</xsl:attribute>
            <xsl:element name="text:note-citation">
                <xsl:attribute name="text:label"><xsl:value-of select="@字:引文体"/></xsl:attribute>
                <xsl:value-of select="@字:引文体"/>
            </xsl:element>
            <xsl:element name="text:note-body">
                <xsl:for-each select="字:段落">
                    <xsl:call-template name="commonParagraph"/>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="字:锚点">
        <xsl:call-template name="图形解析"/>
    </xsl:template>
    <xsl:key match="/uof:UOF/uof:文字处理/字:主体/字:段落/字:句/字:锚点 | /uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:页眉//字:锚点 | /uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:页脚//字:锚点" name="rel_graphic_name" use="字:图形/@字:图形引用"/>
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
            <xsl:when test="图:预定义图形/图:属性/图:填充/图:渐变 | 图:预定义图形/图:属性/图:填充/图:颜色 | 图:预定义图形/图:属性/图:填充/图:图片 | 图:预定义图形/图:属性/图:填充/图:位图">
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
                    <xsl:attribute name="style:family">graphic</xsl:attribute>
                    <xsl:if test="图:文本内容/@图:自动换行='true' or 图:文本内容/@图:自动换行='1'">
                        <xsl:attribute name="draw:fit-to-contour">true</xsl:attribute>
                    </xsl:if>
                    <xsl:element name="style:graphic-properties">
                        <xsl:call-template name="process-graphics">
                            <xsl:with-param name="draw-name" select="$draw-name"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:if test="图:文本内容/@图:文字排列方向">
                        <xsl:choose>
                            <xsl:when test="图:文本内容/@图:文字排列方向='vert-l2r'">
                                <style:paragraph-properties style:writing-mode="tb-rl"/>
                            </xsl:when>
                            <xsl:when test="图:文本内容/@图:文字排列方向='vert-r2l'">
                                <style:paragraph-properties style:writing-mode="tb-rl"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="style:style">
                    <xsl:attribute name="style:name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
                    <xsl:attribute name="style:family">graphic</xsl:attribute>
                    <xsl:element name="style:graphic-properties">
                        <xsl:if test="@图:其他对象 or key('rel_graphic_name',@图:标识符)/字:锚点属性/字:锚点属性/字:位置/字:垂直/字:相对/@字:相对于">
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
                    <xsl:if test="图:文本内容/@图:文字排列方向">
                        <xsl:choose>
                            <xsl:when test="图:文本内容/@图:文字排列方向='vert-l2r'">
                                <style:paragraph-properties style:writing-mode="tb-rl"/>
                            </xsl:when>
                            <xsl:when test="图:文本内容/@图:文字排列方向='vert-r2l'">
                                <style:paragraph-properties style:writing-mode="tb-rl"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
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
                <xsl:attribute name="draw:name"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:填充/图:图案/@图:图形引用"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图案/@图:类型"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:图形引用"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:名称"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图片/@图:名称"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:图形引用"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图片/@图:图形引用"/></xsl:when></xsl:choose></xsl:when></xsl:choose></xsl:attribute>
                <xsl:call-template name="bina_graphic">
                    <xsl:with-param name="refGraphic">
                        <xsl:choose>
                            <xsl:when test="图:预定义图形/图:属性/图:填充/图:图案/@图:图形引用">
                                <xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图案/@图:图形引用"/>
                            </xsl:when>
                            <xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:名称">
                                <xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图片/@图:名称"/>
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
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">1</xsl:attribute>
                        <xsl:attribute name="draw:dots1-length">0.508cm</xsl:attribute>
                        <xsl:attribute name="draw:dots2">1</xsl:attribute>
                        <xsl:attribute name="draw:dots2-length">0.508cm</xsl:attribute>
                        <xsl:attribute name="draw:distance">0.508cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='dot-dot-dash' or $line='dash-dot-dot-heavy'">
                        <xsl:attribute name="draw:name">2 Dots 1 Dash</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">2</xsl:attribute>
                        <xsl:attribute name="draw:dots2">1</xsl:attribute>
                        <xsl:attribute name="draw:dots2-length">0.203cm</xsl:attribute>
                        <xsl:attribute name="draw:distance">0.203cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='dash' or $line='dashed-heavy'">
                        <xsl:attribute name="draw:name">Ultrafine Dashed</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">1</xsl:attribute>
                        <xsl:attribute name="draw:dots1-length">0.051cm</xsl:attribute>
                        <xsl:attribute name="draw:dots2">1</xsl:attribute>
                        <xsl:attribute name="draw:dots2-length">0.051cm</xsl:attribute>
                        <xsl:attribute name="draw:distance">0.051cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='dotted' or $line='dotted-heavy'">
                        <xsl:attribute name="draw:name">Ultrafine Dotted (var)</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">1</xsl:attribute>
                        <xsl:attribute name="draw:distance">50%</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='wave' or $line='wavy-heavy'">
                        <xsl:attribute name="draw:name">Ultrafine 2 Dots 3 Dashes</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">2</xsl:attribute>
                        <xsl:attribute name="draw:dots1-length">0.051cm</xsl:attribute>
                        <xsl:attribute name="draw:dots2">3</xsl:attribute>
                        <xsl:attribute name="draw:dots2-length">0.254cm</xsl:attribute>
                        <xsl:attribute name="draw:distance">0.127cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='dot-dash' or $line='dash-dot-heavy'">
                        <xsl:attribute name="draw:name">3 Dashes 3 Dots (var)</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">3</xsl:attribute>
                        <xsl:attribute name="draw:dots1-length">197%</xsl:attribute>
                        <xsl:attribute name="draw:dots2">3</xsl:attribute>
                        <xsl:attribute name="draw:distance">100%</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='double'">
                        <xsl:attribute name="draw:name">Line with Fine Dots</xsl:attribute>
                        <xsl:attribute name="draw:style">rect</xsl:attribute>
                        <xsl:attribute name="draw:dots1">1</xsl:attribute>
                        <xsl:attribute name="draw:dots1-length">2.007cm</xsl:attribute>
                        <xsl:attribute name="draw:dots2">10</xsl:attribute>
                        <xsl:attribute name="draw:distance">0.152cm</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$line='wavy-double'">
                        <xsl:attribute name="draw:name">Fine Dashed (var)</xsl:attribute>
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
    <xsl:template name="process-graphics">
        <xsl:param name="draw-name"/>
        <xsl:if test="图:预定义图形/图:类别">
        </xsl:if>
        <xsl:for-each select="key('rel_graphic_name',@图:标识符)/字:锚点属性/字:位置/字:垂直">
            <xsl:attribute name="style:vertical-pos"><xsl:choose><xsl:when test="字:绝对">from-top</xsl:when><xsl:when test="字:相对/@字:值='bottom'">bottom</xsl:when><xsl:when test="字:相对/@字:值='center'">middle</xsl:when><xsl:when test="字:相对/@字:值='inside'">below</xsl:when><xsl:otherwise>top</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="style:vertical-rel"><xsl:choose><xsl:when test="@字:相对于='margin'">paragraph-content</xsl:when><xsl:otherwise><xsl:value-of select="@字:相对于"/></xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:for-each>
        <xsl:for-each select="key('rel_graphic_name',@图:标识符)/字:锚点属性/字:位置/字:水平">
            <xsl:attribute name="style:horizontal-pos"><xsl:choose><xsl:when test="字:绝对">from-left</xsl:when><xsl:otherwise><xsl:value-of select="字:相对/@字:值"/></xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="style:horizontal-rel"><xsl:choose><xsl:when test="@字:相对于='margin'">paragraph</xsl:when><xsl:when test="@字:相对于='page'">page</xsl:when><xsl:when test="@字:相对于='column'">paragraph</xsl:when><xsl:when test="@字:相对于='char'">char</xsl:when></xsl:choose></xsl:attribute>
        </xsl:for-each>
        <xsl:variable name="wrap_type">
            <xsl:value-of select="key('rel_graphic_name',@图:标识符)/字:锚点属性/字:绕排/@字:绕排方式"/>
        </xsl:variable>
        <xsl:variable name="aa">
            <xsl:value-of select="key('rel_graphic_name',@图:标识符)/字:锚点属性/字:绕排/@字:绕排顶点"/>
        </xsl:variable>
        <xsl:for-each select="key('rel_graphic_name',@图:标识符)/字:锚点属性/字:绕排/@字:绕排方式">
            <xsl:attribute name="style:wrap"><xsl:choose><xsl:when test="$wrap_type = 'through'">run-through</xsl:when><xsl:when test="$wrap_type = 'tight'">right</xsl:when><xsl:when test="$wrap_type = 'square'">parallel</xsl:when><xsl:when test="$wrap_type = 'top-bottom'">dynamic</xsl:when><xsl:when test="$wrap_type = 'infrontoftext'">run-through</xsl:when><xsl:when test="$wrap_type = 'behindtext'">run-through</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:attribute name="style:run-through"><xsl:choose><xsl:when test="$wrap_type = 'behindtext'">background</xsl:when><xsl:otherwise>foreground</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:for-each>
        <xsl:if test="key('rel_graphic_name',@图:标识符)/字:锚点属性/字:边距">
            <xsl:for-each select="key('rel_graphic_name',@图:标识符)/字:锚点属性/字:边距">
                <xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(@字:上,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(@字:下,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(@字:右,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(@字:左,$uofUnit)"/></xsl:attribute>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="key('rel_graphic_name',@图:标识符)/字:锚点属性/字:保护/@字:值='true'">
            <xsl:choose>
                <xsl:when test="图:预定义图形/图:名称">
                    <xsl:attribute name="style:protect">position size</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="style:protect">content size position</xsl:attribute>
                    <xsl:attribute name="draw:size-protect">true</xsl:attribute>
                    <xsl:attribute name="draw:move-protect">true</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="图:预定义图形/图:名称">
            <xsl:choose>
                <xsl:when test="图:预定义图形/图:名称='椭圆'">
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="not(图:预定义图形/图:属性/图:填充)">
                <xsl:attribute name="draw:fill">none</xsl:attribute>
            </xsl:when>
            <xsl:when test="图:预定义图形/图:属性/图:填充/图:图片">
                <xsl:choose>
                    <xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:名称='background-image'">
                        <xsl:element name="style:background-image">
                            <xsl:element name="office:binary-data">
                                <xsl:variable name="biaoshi">
                                    <xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图片/@图:图形引用"/>
                                </xsl:variable>
                                <xsl:value-of select="ancestor::uof:对象集/uof:其他对象[@uof:标识符=$biaoshi]/uof:数据"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="draw:fill">bitmap</xsl:attribute>
                        <xsl:attribute name="draw:fill-image-name"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:名称"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图片/@图:名称"/></xsl:when><xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:图形引用"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图片/@图:图形引用"/></xsl:when></xsl:choose></xsl:attribute>
                        <xsl:if test="not(图:预定义图形/图:属性/图:填充/图:图片/@图:位置='tile')">
                            <xsl:attribute name="style:repeat"><xsl:choose><xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:位置='center'">no-repeat</xsl:when><xsl:when test="图:预定义图形/图:属性/图:填充/图:图片/@图:位置='stretch'">stretch</xsl:when></xsl:choose></xsl:attribute>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="图:预定义图形/图:属性/图:填充/图:图案">
                <xsl:attribute name="draw:fill">bitmap</xsl:attribute>
                <xsl:attribute name="draw:fill-color"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:图案/@图:前景色"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="图:预定义图形/图:属性/图:填充/图:颜色">
                <xsl:attribute name="draw:fill">solid</xsl:attribute>
                <xsl:attribute name="draw:fill-color"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:颜色"/></xsl:attribute>
                <xsl:attribute name="fo:background-color"><xsl:value-of select="图:预定义图形/图:属性/图:填充/图:颜色"/></xsl:attribute>
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
            <xsl:if test="$linetype='none'">
                <xsl:attribute name="fo:border">none</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="draw:stroke-dash"><xsl:choose><xsl:when test="$linetype='dot-dot-dash' or $linetype='dash-dot-dot-heavy'">2 Dots 1 Dash</xsl:when><xsl:when test="$linetype='dash' or $linetype='dashed-heavy'">Ultrafine_20_Dashed</xsl:when><xsl:when test="$linetype='dotted' or $linetype='dotted-heavy'">Ultrafine Dotted (var)</xsl:when><xsl:when test="$linetype='double'">Line with Fine Dots</xsl:when><xsl:when test="$linetype='dot-dash' or $linetype='dash-dot-heavy'">3 Dashes 3 Dots (var)</xsl:when><xsl:when test="$linetype='wave' or $linetype='wavy-heavy'">Ultrafine 2 Dots 3 Dashes</xsl:when><xsl:when test="$linetype='wavy-double'">Fine Dashed (var)</xsl:when><xsl:otherwise>Fine Dashed</xsl:otherwise></xsl:choose></xsl:attribute>
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
        <xsl:if test="图:预定义图形/图:属性/图:宽度">
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:高度">
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:旋转角度">
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:锁定纵横比">
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:打印对象">
        </xsl:if>
        <xsl:if test="图:预定义图形/图:属性/图:透明度">
            <xsl:attribute name="draw:opacity"><xsl:value-of select="concat((100 - 图:预定义图形/图:属性/图:透明度),'%')"/></xsl:attribute>
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
                        <xsl:attribute name="style:writing-mode">tb-rl</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="图:文本内容/@图:文字排列方向='vert-r2l'">
                        <xsl:attribute name="style:writing-mode">tb-rl</xsl:attribute>
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
                <xsl:attribute name="fo:wrap-option"><xsl:choose><xsl:when test="图:文本内容/@图:自动换行='1' or 图:文本内容/@图:自动换行='true'">wrap</xsl:when><xsl:otherwise>no-wrap</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="图:文本内容/@图:大小适应文字='true'">
                    <xsl:attribute name="draw:auto-grow-width">true</xsl:attribute>
                    <xsl:attribute name="draw:auto-grow-height">true</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="draw:auto-grow-width">false</xsl:attribute>
                    <xsl:attribute name="draw:auto-grow-height">false</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="图:控制点">
    </xsl:if>
    </xsl:template>
    <xsl:template name="图形解析">
        <xsl:variable name="tuxing1" select="字:图形/@字:图形引用"/>
        <xsl:variable name="paiban">
            <xsl:value-of select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]/图:预定义图形/图:名称"/>
        </xsl:variable>
        <xsl:variable name="otherobject">
            <xsl:value-of select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]/@图:其他对象"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]">
                <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:公共类型='png' or /uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:公共类型='jpg' or /uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:公共类型='bmp' or /uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:公共类型='gif' or /uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/@uof:私有类型='图片'">
                    <xsl:element name="draw:frame">
                        <xsl:attribute name="draw:name"><xsl:variable name="pos"><xsl:value-of select="count(preceding::字:锚点)"/></xsl:variable><xsl:value-of select="concat('图形',$pos)"/></xsl:attribute>
                        <xsl:if test="字:锚点属性/字:位置/字:水平/字:绝对">
                            <xsl:attribute name="svg:x"><xsl:value-of select="concat(字:锚点属性/字:位置/字:水平/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:锚点属性/字:位置/字:垂直/字:绝对">
                            <xsl:attribute name="svg:y"><xsl:value-of select="concat(字:锚点属性/字:位置/字:垂直/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="svg:width"><xsl:value-of select="concat(字:锚点属性/字:宽度,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="svg:height"><xsl:value-of select="concat(字:锚点属性/字:高度,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="text:anchor-type"><xsl:choose><xsl:when test="@字:类型='inline'">as-char</xsl:when><xsl:otherwise>paragraph</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]">
                            <xsl:attribute name="draw:style-name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
                            <xsl:attribute name="draw:z-index"><xsl:value-of select="@图:层次"/></xsl:attribute>
                            <xsl:if test="图:预定义图形/图:属性/图:旋转角度 and not(图:预定义图形/图:属性/图:旋转角度='0.0')">
                                <xsl:variable name="jiaodu">
                                    <xsl:value-of select="图:预定义图形/图:属性/图:旋转角度"/>
                                </xsl:variable>
                                <xsl:variable name="shibie">
                                    <xsl:value-of select="图:预定义图形/图:生成软件"/>
                                </xsl:variable>
                                <xsl:variable name="rotate-angle">
                                    <xsl:choose>
                                        <xsl:when test="图:预定义图形/图:生成软件 and not($shibie='PNG')">
                                            <xsl:value-of select="((360 - $jiaodu)  *  2 * 3.14159265 ) div 360"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="(图:预定义图形/图:属性/图:旋转角度 *  2 * 3.14159265 ) div 360"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:attribute name="draw:transform"><xsl:value-of select="concat('rotate (',$rotate-angle,') translate (-0.0194027777777778cm 3.317875cm)')"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="图:文本内容">
                                <xsl:apply-templates select="图:文本内容/字:段落"/>
                                <xsl:apply-templates select="图:文本内容/字:文字表"/>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:数据">
                            <draw:image>
                                <office:binary-data>
                                    <xsl:value-of select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:数据"/>
                                </office:binary-data>
                            </draw:image>
                        </xsl:if>
                        <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:路径">
                            <xsl:attribute name="xlink:href"><xsl:value-of select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:路径"/></xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:when test="/uof:UOF/uof:对象集/图:图形[@图:标识符=$tuxing1]/@图:其他对象 and /uof:UOF/uof:对象集/uof:其他对象/@uof:公共类型='jpg'">
                <xsl:variable name="bshi">
                    <xsl:value-of select="/uof:UOF/uof:对象集/图:图形/@图:其他对象"/>
                </xsl:variable>
                <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$bshi]/@uof:公共类型='jpg'">
                    <xsl:element name="draw:frame">
                        <xsl:attribute name="draw:name"><xsl:variable name="pos"><xsl:value-of select="count(preceding::字:锚点)"/></xsl:variable><xsl:value-of select="concat('图形',$pos)"/></xsl:attribute>
                        <xsl:if test="字:锚点属性/字:位置/字:水平/字:绝对">
                            <xsl:attribute name="svg:x"><xsl:value-of select="concat(字:锚点属性/字:位置/字:水平/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="字:锚点属性/字:位置/字:垂直/字:绝对">
                            <xsl:attribute name="svg:y"><xsl:value-of select="concat(字:锚点属性/字:位置/字:垂直/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="svg:width"><xsl:value-of select="concat(字:锚点属性/字:宽度,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="svg:height"><xsl:value-of select="concat(字:锚点属性/字:高度,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="text:anchor-type"><xsl:choose><xsl:when test="@字:类型='inline'">as-char</xsl:when><xsl:otherwise>paragraph</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]">
                            <xsl:attribute name="draw:style-name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
                            <xsl:attribute name="draw:z-index"><xsl:value-of select="@图:层次"/></xsl:attribute>
                            <xsl:if test="图:预定义图形/图:属性/图:旋转角度 and not(图:预定义图形/图:属性/图:旋转角度='0.0')">
                                <xsl:variable name="jiaodu">
                                    <xsl:value-of select="图:预定义图形/图:属性/图:旋转角度"/>
                                </xsl:variable>
                                <xsl:variable name="shibie">
                                    <xsl:value-of select="图:预定义图形/图:生成软件"/>
                                </xsl:variable>
                                <xsl:variable name="rotate-angle">
                                    <xsl:choose>
                                        <xsl:when test="图:预定义图形/图:生成软件 and not($shibie='PNG')">
                                            <xsl:value-of select="((360 - $jiaodu)  *  2 * 3.14159265 ) div 360"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="(图:预定义图形/图:属性/图:旋转角度 *  2 * 3.14159265 ) div 360"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:attribute name="draw:transform"><xsl:value-of select="concat('rotate (',$rotate-angle,') translate (-0.0194027777777778cm 3.317875cm)')"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="图:文本内容">
                                <xsl:apply-templates select="图:文本内容/字:段落"/>
                                <xsl:apply-templates select="图:文本内容/字:文字表"/>
                            </xsl:if>
                            <xsl:variable name="qita">
                                <xsl:value-of select="self::node()/@图:其他对象"/>
                            </xsl:variable>
                            <xsl:for-each select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$qita]/uof:数据">
                                <draw:image>
                                <office:binary-data>
                                    <xsl:value-of select="."/>
                                </office:binary-data>
                                </draw:image>
                            </xsl:for-each>
                        </xsl:for-each>
                        <xsl:if test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:路径">
                            <xsl:attribute name="xlink:href"><xsl:value-of select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$tuxing1]/uof:路径"/></xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:when test="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]/图:文本内容[@图:文本框='true'] and not($paiban='排版框')">
                <draw:frame text:anchor-type="paragraph">
                    <xsl:attribute name="draw:style-name"><xsl:value-of select="$tuxing1"/></xsl:attribute>
                    <xsl:attribute name="svg:width"><xsl:value-of select="concat(字:锚点属性/字:宽度,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="svg:height"><xsl:value-of select="concat(字:锚点属性/字:高度,$uofUnit)"/></xsl:attribute>
                    <xsl:if test="字:锚点属性/字:位置/字:水平/字:绝对">
                        <xsl:attribute name="svg:x"><xsl:value-of select="concat(字:锚点属性/字:位置/字:水平/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="字:锚点属性/字:位置/字:垂直/字:绝对">
                        <xsl:attribute name="svg:y"><xsl:value-of select="concat(字:锚点属性/字:位置/字:垂直/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="draw:z-index">
                        <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]"><xsl:value-of select="@图:层次"/></xsl:for-each>
                    </xsl:attribute>
                    <draw:text-box>
                        <xsl:apply-templates select="/uof:UOF/uof:对象集/图:图形[@图:标识符=$tuxing1]/图:文本内容/字:段落"/>
                        <xsl:apply-templates select="/uof:UOF/uof:对象集/图:图形[@图:标识符=$tuxing1]/图:文本内容/字:文字表"/>
                    </draw:text-box>
                </draw:frame>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="leibie">
                    <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符=$tuxing1]">
                        <xsl:value-of select="图:预定义图形/图:类别"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="leibie2">
                    <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符=$tuxing1]">
                        <xsl:value-of select="图:预定义图形/图:名称"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$leibie='22'">
                        <xsl:call-template name="排版框">
                            <xsl:with-param name="biaoshi" select="$tuxing1"/>
                            <xsl:with-param name="name" select="$leibie2"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$leibie='23'">
                        <xsl:call-template name="文本框">
                            <xsl:with-param name="biaoshi" select="$tuxing1"/>
                            <xsl:with-param name="name" select="$leibie2"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$leibie='11'">
                        <xsl:call-template name="Rectangle"/>
                    </xsl:when>
                    <xsl:when test="$leibie='19'">
                        <xsl:call-template name="Oval"/>
                    </xsl:when>
                    <xsl:when test="$leibie='61'">
                        <xsl:call-template name="Line"/>
                    </xsl:when>
                    <xsl:when test="$leibie='62'">
                        <xsl:call-template name="Line"/>
                    </xsl:when>
                    <xsl:when test="$leibie='63'">
                        <xsl:call-template name="Line"/>
                    </xsl:when>
                    <xsl:when test="$leibie='64'">
                        <xsl:call-template name="Curve"/>
                    </xsl:when>
                    <xsl:when test="$leibie='65'">
                        <xsl:call-template name="Freeform"/>
                    </xsl:when>
                    <xsl:when test="$leibie='66'">
                        <xsl:call-template name="Scribble"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="文本框">
        <xsl:param name="biaoshi"/>
        <xsl:param name="name"/>
        <draw:frame text:anchor-type="paragraph">
            <xsl:attribute name="draw:style-name"><xsl:value-of select="$biaoshi"/></xsl:attribute>
            <xsl:attribute name="draw:name"><xsl:value-of select="$name"/></xsl:attribute>
            <xsl:attribute name="svg:width"><xsl:value-of select="concat(字:锚点属性/字:宽度,$uofUnit)"/></xsl:attribute>
            <xsl:if test="字:锚点属性/字:位置/字:水平/字:绝对">
                <xsl:attribute name="svg:x"><xsl:value-of select="concat(字:锚点属性/字:位置/字:水平/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="字:锚点属性/字:位置/字:垂直/字:绝对">
                <xsl:attribute name="svg:y"><xsl:value-of select="concat(字:锚点属性/字:位置/字:垂直/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:if>
            <xsl:attribute name="draw:z-index">
                <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $biaoshi]">
                    <xsl:value-of select="@图:层次"/>
                </xsl:for-each>
            </xsl:attribute>
            <draw:text-box>
                <xsl:apply-templates select="/uof:UOF/uof:对象集/图:图形[@图:标识符=$biaoshi]/图:文本内容/字:段落"/>
                <xsl:apply-templates select="/uof:UOF/uof:对象集/图:图形[@图:标识符=$biaoshi]/图:文本内容/字:文字表"/>
            </draw:text-box>
        </draw:frame>
    </xsl:template>
    <xsl:template name="Curve">
        <xsl:element name="draw:path">
            <xsl:variable name="tuxing1" select="字:图形/@字:图形引用"/>
            <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符=$tuxing1]">
                <xsl:variable name="width" select="number(图:预定义图形/图:属性/图:宽度)*1000"/>
                <xsl:variable name="height" select="number(图:预定义图形/图:属性/图:高度)*1000"/>
                <xsl:attribute name="svg:viewBox"><xsl:value-of select="concat('0 0 ',$width, ' ',$height)"/></xsl:attribute>
                <xsl:attribute name="svg:d"><xsl:value-of select="图:预定义图形/图:关键点坐标/@图:路径"/></xsl:attribute>
            </xsl:for-each>
            <xsl:call-template name="common"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="common">
        <xsl:if test="字:锚点属性/字:位置/字:水平/字:绝对">
            <xsl:attribute name="svg:x"><xsl:value-of select="concat(字:锚点属性/字:位置/字:水平/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:锚点属性/字:位置/字:垂直/字:绝对">
            <xsl:attribute name="svg:y"><xsl:value-of select="concat(字:锚点属性/字:位置/字:垂直/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:variable name="tuxing1" select="字:图形/@字:图形引用"/>
        <xsl:attribute name="svg:width"><xsl:value-of select="concat(字:锚点属性/字:宽度,$uofUnit)"/></xsl:attribute>
        <xsl:attribute name="svg:height"><xsl:value-of select="concat(字:锚点属性/字:高度,$uofUnit)"/></xsl:attribute>
        <xsl:attribute name="text:anchor-type"><xsl:choose><xsl:when test="@字:类型='inline'">as-char</xsl:when><xsl:otherwise>paragraph</xsl:otherwise></xsl:choose></xsl:attribute>
        <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]">
            <xsl:attribute name="draw:style-name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
            <xsl:attribute name="draw:z-index"><xsl:value-of select="@图:层次"/></xsl:attribute>
            <xsl:if test="图:预定义图形/图:属性/图:旋转角度 and not(图:预定义图形/图:属性/图:旋转角度='0.0')">
                <xsl:variable name="jiaodu">
                    <xsl:value-of select="图:预定义图形/图:属性/图:旋转角度"/>
                </xsl:variable>
                <xsl:variable name="shibie">
                    <xsl:value-of select="图:预定义图形/图:生成软件"/>
                </xsl:variable>
                <xsl:variable name="rotate-angle">
                    <xsl:choose>
                        <xsl:when test="图:预定义图形/图:生成软件 and not($shibie='PNG')">
                            <xsl:value-of select="((360 - $jiaodu)  *  2 * 3.14159265 ) div 360"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="(图:预定义图形/图:属性/图:旋转角度 *  2 * 3.14159265 ) div 360"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="draw:transform"><xsl:value-of select="concat('rotate (',$rotate-angle,') translate (-0.0194027777777778cm 3.317875cm)')"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="图:文本内容">
                <xsl:apply-templates select="图:文本内容/字:段落"/>
                <xsl:apply-templates select="图:文本内容/字:文字表"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="common1">
        <xsl:if test="字:锚点属性/字:位置/字:水平/字:绝对">
            <xsl:attribute name="svg:x"><xsl:value-of select="concat(字:锚点属性/字:位置/字:水平/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:锚点属性/字:位置/字:垂直/字:绝对">
            <xsl:attribute name="svg:y"><xsl:value-of select="concat(字:锚点属性/字:位置/字:垂直/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:variable name="tuxing1" select="字:图形/@字:图形引用"/>
        <xsl:attribute name="svg:width"><xsl:value-of select="concat(/uof:UOF/uof:对象集/图:图形[@图:标识符=$tuxing1]/图:预定义图形/图:属性/图:宽度,$uofUnit)"/></xsl:attribute>
        <xsl:attribute name="svg:height"><xsl:value-of select="concat(/uof:UOF/uof:对象集/图:图形[@图:标识符=$tuxing1]/图:预定义图形/图:属性/图:高度,$uofUnit)"/></xsl:attribute>
        <xsl:attribute name="text:anchor-type"><xsl:choose><xsl:when test="@字:类型='inline'">as-char</xsl:when><xsl:otherwise>paragraph</xsl:otherwise></xsl:choose></xsl:attribute>
        <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]">
            <xsl:attribute name="draw:style-name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
            <xsl:attribute name="draw:z-index"><xsl:value-of select="@图:层次"/></xsl:attribute>
            <xsl:if test="图:预定义图形/图:属性/图:旋转角度 and not(图:预定义图形/图:属性/图:旋转角度='0.0')">
                <xsl:variable name="jiaodu">
                    <xsl:value-of select="图:预定义图形/图:属性/图:旋转角度"/>
                </xsl:variable>
                <xsl:variable name="shibie">
                    <xsl:value-of select="图:预定义图形/图:生成软件"/>
                </xsl:variable>
                <xsl:variable name="rotate-angle">
                    <xsl:choose>
                        <xsl:when test="图:预定义图形/图:生成软件 and not($shibie='PNG')">
                            <xsl:value-of select="((360 - $jiaodu)  *  2 * 3.14159265 ) div 360"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="(图:预定义图形/图:属性/图:旋转角度 *  2 * 3.14159265 ) div 360"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="draw:transform"><xsl:value-of select="concat('rotate (',$rotate-angle,') translate (-0.0194027777777778cm 3.317875cm)')"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="图:文本内容">
                <xsl:apply-templates select="图:文本内容/字:段落"/>
                <xsl:apply-templates select="图:文本内容/字:文字表"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="Freeform">
        <xsl:element name="draw:polygon">
            <xsl:variable name="tuxing1" select="字:图形/@字:图形引用"/>
            <xsl:variable name="width" select="number(/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]/图:预定义图形/图:属性/图:宽度)*1000"/>
            <xsl:variable name="height" select="number(/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]/图:预定义图形/图:属性/图:高度)*1000"/>
            <xsl:attribute name="svg:viewBox"><xsl:value-of select="concat('0 0 ',$width, ' ',$height)"/></xsl:attribute>
            <xsl:attribute name="draw:points"><xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]/图:预定义图形/图:关键点坐标"><xsl:call-template name="drawpoints"><xsl:with-param name="points" select="concat(number(图:坐标[1]/@x坐标)*1000,',',number(图:坐标[1]/@y坐标)*1000)"/><xsl:with-param name="point-pos" select="2"/></xsl:call-template></xsl:for-each></xsl:attribute>
            <xsl:call-template name="common"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="drawpoints">
        <xsl:param name="points"/>
        <xsl:param name="point-pos"/>
        <xsl:choose>
            <xsl:when test="图:坐标[$point-pos]">
                <xsl:variable name="points1" select="concat($points,' ',number(图:坐标[$point-pos]/@x坐标)*1000,',',number(图:坐标[$point-pos]/@y坐标)*1000)"/>
                <xsl:call-template name="drawpoints">
                    <xsl:with-param name="points" select="$points1"/>
                    <xsl:with-param name="point-pos" select="$point-pos+1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$points"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Scribble">
        <xsl:element name="draw:polyline">
            <xsl:variable name="tuxing1" select="字:图形/@字:图形引用"/>
            <xsl:variable name="width" select="number(/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]/图:预定义图形/图:属性/图:宽度)*1000"/>
            <xsl:variable name="height" select="number(/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]/图:预定义图形/图:属性/图:高度)*1000"/>
            <xsl:attribute name="svg:viewBox"><xsl:value-of select="concat('0 0 ',$width, ' ',$height)"/></xsl:attribute>
            <xsl:attribute name="draw:points"><xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]/图:预定义图形/图:关键点坐标"><xsl:call-template name="drawpoints"><xsl:with-param name="points" select="concat(number(图:坐标[1]/@x坐标)*1000,',',number(图:坐标[1]/@y坐标)*1000)"/><xsl:with-param name="point-pos" select="2"/></xsl:call-template></xsl:for-each></xsl:attribute>
            <xsl:call-template name="common"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="Oval">
        <xsl:element name="draw:ellipse">
            <xsl:call-template name="common1"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="排版框">
        <xsl:param name="biaoshi"/>
        <xsl:param name="name"/>
        <draw:frame text:anchor-type="paragraph">
            <xsl:attribute name="draw:style-name"><xsl:value-of select="$biaoshi"/></xsl:attribute>
            <xsl:attribute name="draw:name"><xsl:value-of select="$name"/></xsl:attribute>
            <xsl:attribute name="svg:width"><xsl:value-of select="concat(字:锚点属性/字:宽度,$uofUnit)"/></xsl:attribute>
            <xsl:if test="字:锚点属性/字:位置/字:水平/字:绝对">
                <xsl:attribute name="svg:x"><xsl:value-of select="concat(字:锚点属性/字:位置/字:水平/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="字:锚点属性/字:位置/字:垂直/字:绝对">
                <xsl:attribute name="svg:y"><xsl:value-of select="concat(字:锚点属性/字:位置/字:垂直/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:if>
            <xsl:attribute name="draw:z-index">
                <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $biaoshi]">
                    <xsl:value-of select="@图:层次"/>
                </xsl:for-each>
            </xsl:attribute>
            <draw:text-box>
                <xsl:attribute name="fo:min-height"><xsl:value-of select="concat(字:锚点属性/字:高度,$uofUnit)"/></xsl:attribute>
                <xsl:apply-templates select="/uof:UOF/uof:对象集/图:图形[@图:标识符=$biaoshi]/图:文本内容/字:段落"/>
                <xsl:apply-templates select="/uof:UOF/uof:对象集/图:图形[@图:标识符=$biaoshi]/图:文本内容/字:文字表"/>
            </draw:text-box>
        </draw:frame>
    </xsl:template>
    <xsl:template name="Rectangle">
        <xsl:element name="draw:rect">
            <xsl:call-template name="common1"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="Line">
        <xsl:element name="draw:line">
            <xsl:variable name="tuxing1" select="字:图形/@字:图形引用"/>
            <xsl:attribute name="svg:x1"><xsl:value-of select="concat(字:锚点属性/字:位置/字:水平/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:y1"><xsl:value-of select="concat(字:锚点属性/字:位置/字:垂直/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:x2"><xsl:value-of select="concat((字:锚点属性/字:位置/字:水平/字:绝对/@字:值 + 字:锚点属性/字:宽度),$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="svg:y2"><xsl:value-of select="concat((字:锚点属性/字:位置/字:垂直/字:绝对/@字:值 + 字:锚点属性/字:高度),$uofUnit)"/></xsl:attribute>
            <xsl:for-each select="/uof:UOF/uof:对象集/图:图形[@图:标识符 = $tuxing1]">
                <xsl:attribute name="text:anchor-type">paragraph</xsl:attribute>
                <xsl:attribute name="draw:style-name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
                <xsl:attribute name="draw:z-index"><xsl:value-of select="@图:层次"/></xsl:attribute>
                <xsl:if test="图:预定义图形/图:属性/图:旋转角度 and not(图:预定义图形/图:属性/图:旋转角度='0.0')">
                    <xsl:variable name="jiaodu">
                        <xsl:value-of select="图:预定义图形/图:属性/图:旋转角度"/>
                    </xsl:variable>
                    <xsl:variable name="shibie">
                        <xsl:value-of select="图:预定义图形/图:生成软件"/>
                    </xsl:variable>
                    <xsl:variable name="rotate-angle">
                        <xsl:choose>
                            <xsl:when test="图:预定义图形/图:生成软件 and not($shibie='PNG')">
                                <xsl:value-of select="((360 - $jiaodu)  *  2 * 3.14159265 ) div 360"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="(图:预定义图形/图:属性/图:旋转角度 *  2 * 3.14159265 ) div 360"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="draw:transform"><xsl:value-of select="concat('rotate (',$rotate-angle,') translate (-0.0194027777777778cm 3.317875cm)')"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="图:文本内容">
                    <xsl:apply-templates select="图:文本内容/字:段落"/>
                    <xsl:apply-templates select="图:文本内容/字:文字表"/>
                </xsl:if>
            </xsl:for-each>
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
                                <xsl:attribute name="text:style-name">P<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落属性"/></xsl:attribute>
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
    <xsl:template match="字:句/字:区域开始[@字:类型='bookmark']">
        <xsl:variable name="biaoshi">
            <xsl:value-of select="@字:标识符"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not(@字:名称)">
                <text:bookmark-start text:name="{/uof:UOF/uof:书签集/uof:书签[uof:文本位置/@字:区域引用=$biaoshi]/@uof:名称}"/>
            </xsl:when>
            <xsl:otherwise>
                <text:bookmark-start text:name="{@字:名称}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:句/字:区域结束[preceding::字:区域开始[1]/@字:类型='bookmark']">
        <xsl:variable name="biaoshi">
            <xsl:value-of select="@字:标识符引用"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not(@字:名称)">
                <text:bookmark-end text:name="{/uof:UOF/uof:书签集/uof:书签[uof:文本位置/@字:区域引用=$biaoshi]/@uof:名称}"/>
            </xsl:when>
            <xsl:otherwise>
                <text:bookmark-end text:name="{@字:名称}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:区域开始[@字:类型='annotation']">
        <text:bookmark-start text:name="{@字:标识符}"/>
    </xsl:template>
    <xsl:template match="字:区域结束[preceding::字:区域开始[1]/@字:类型='annotation']">
        <text:bookmark-end text:name="{@字:标识符引用}"/>
    </xsl:template>
    <xsl:template match="字:区域开始[@字:类型='user-data']">
        <text:alphabetical-index-mark-start text:id="{@字:标识符}" text:string-value-phonetic="{@字:名称}"/>
    </xsl:template>
    <xsl:template match="字:区域结束[preceding::字:区域开始[1]/@字:类型='user-data']">
        <text:alphabetical-index-mark-end text:id="{@字:标识符引用}"/>
    </xsl:template>
    <xsl:template match="字:段落/字:域开始">
        <xsl:choose>
            <xsl:when test="@字:类型='createdate'">
                <xsl:variable name="datestr" select="../字:句[preceding-sibling::字:域代码]/字:文本串"/>
                <xsl:element name="text:creation-date">
                    <xsl:attribute name="style:data-style-name">CreateDate<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'createdate']"/></xsl:attribute>
                    <xsl:attribute name="text:date-value"><xsl:value-of select="$datestr"/></xsl:attribute>
                    <xsl:value-of select="$datestr"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@字:类型='savedate'">
                <xsl:variable name="datestr" select="../字:句[preceding-sibling::字:域代码]/字:文本串"/>
                <xsl:element name="text:date">
                    <xsl:attribute name="style:data-style-name">SaveDate<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'savedate']"/></xsl:attribute>
                    <xsl:attribute name="text:date-value"><xsl:value-of select="$datestr"/></xsl:attribute>
                    <xsl:attribute name="text:fixed">true</xsl:attribute>
                    <xsl:value-of select="$datestr"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@字:类型='date'">
                <xsl:variable name="datestr" select="../字:句[preceding-sibling::字:域代码]/字:文本串"/>
                <xsl:element name="text:date">
                    <xsl:attribute name="style:data-style-name">Date<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'date']"/></xsl:attribute>
                    <xsl:attribute name="text:date-value"><xsl:value-of select="$datestr"/></xsl:attribute>
                    <xsl:value-of select="$datestr"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@字:类型='time'">
                <xsl:variable name="datestr" select="../字:句[preceding-sibling::字:域代码]/字:文本串"/>
                <xsl:element name="text:time">
                    <xsl:attribute name="style:data-style-name">Time<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'time']"/></xsl:attribute>
                    <xsl:attribute name="text:time-value"><xsl:value-of select="$datestr"/></xsl:attribute>
                    <xsl:value-of select="$datestr"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@字:类型='edittime'">
                <xsl:variable name="datestr" select="../字:句[preceding-sibling::字:域代码]/字:文本串"/>
                <xsl:element name="text:editing-duration">
                    <xsl:attribute name="style:data-style-name">EditTime<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'edittime']"/></xsl:attribute>
                    <xsl:value-of select="$datestr"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@字:类型='createtime'">
                <xsl:variable name="datestr" select="../字:句[preceding-sibling::字:域代码]/字:文本串"/>
                <xsl:element name="text:creation-time">
                    <xsl:attribute name="style:data-style-name">CREATETIME<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落/字:域开始[@字:类型 = 'createtime']"/></xsl:attribute>
                    <xsl:value-of select="$datestr"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@字:类型='page'">
                <xsl:call-template name="页码域"/>
            </xsl:when>
            <xsl:when test="@字:类型='numpages'">
                <xsl:call-template name="页数域"/>
            </xsl:when>
            <xsl:when test="@字:类型='author'">
                <xsl:call-template name="作者域"/>
            </xsl:when>
            <xsl:when test="@字:类型='username'">
                <xsl:call-template name="用户域"/>
            </xsl:when>
            <xsl:when test="@字:类型='userinitials'">
                <xsl:call-template name="缩写域"/>
            </xsl:when>
            <xsl:when test="@字:类型='title'">
                <xsl:call-template name="标题域"/>
            </xsl:when>
            <xsl:when test="@字:类型='subject'">
                <xsl:call-template name="主题域"/>
            </xsl:when>
            <xsl:when test="@字:类型='numchars'">
                <xsl:call-template name="字符数"/>
            </xsl:when>
            <xsl:when test="@字:类型='filename'">
                <xsl:call-template name="文件名"/>
            </xsl:when>
            <xsl:when test="@字:类型='edittime'">
                <xsl:call-template name="编辑时间"/>
            </xsl:when>
            <xsl:when test="@字:类型='creation-time'">
                <xsl:call-template name="创建时间"/>
            </xsl:when>
            <xsl:when test="@字:类型='seq'">
                <xsl:call-template name="题注"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="commonParagraph">
        <xsl:choose>
            <xsl:when test="字:段落属性/字:大纲级别">
                <xsl:element name="text:h">
                    <xsl:call-template name="commonParagraphAttributes"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="not (字:域开始/@字:类型='ref') and not(字:域开始/@字:类型='index')">
                <xsl:element name="text:p">
                    <xsl:call-template name="commonParagraphAttributes"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="commonParagraphAttributes">
        <xsl:choose>
            <xsl:when test="字:段落属性">
                <xsl:variable name="pp">
                    <xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落[字:段落属性]"/>
                </xsl:variable>
                <xsl:variable name="aa">
                    <xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落[字:域结束]"/>
                </xsl:variable>
                <xsl:variable name="stylename" select="字:段落属性/@字:式样引用"/>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::字:段落/字:域结束">
                        <xsl:attribute name="text:style-name"><xsl:value-of select="concat('P',$pp+$aa)"/></xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains($stylename,'Heading')">
                        <xsl:attribute name="text:style-name"><xsl:value-of select="$stylename"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="text:style-name"><xsl:value-of select="concat('P',$pp)"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="字:段落属性/字:大纲级别">
                    <xsl:attribute name="text:outline-level"><xsl:value-of select="字:段落属性/字:大纲级别"/></xsl:attribute>
                </xsl:if>
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
    <xsl:template match="字:空格符[parent::字:句]">
        <xsl:element name="text:s">
            <xsl:attribute name="text:c"><xsl:value-of select="@字:个数"/></xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="字:制表符[parent::字:句]">
        <xsl:element name="text:tab"/>
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
                        <xsl:attribute name="xlink:href"><xsl:for-each select="/uof:UOF/uof:链接集/uof:超级链接"><xsl:if test="@uof:链源=$hyperDest"><xsl:if test="@uof:提示"><xsl:attribute name="office:name"><xsl:value-of select="@uof:提示"/></xsl:attribute></xsl:if><xsl:if test="@uof:目标"><xsl:variable name="bsh" select="@uof:目标"/><xsl:choose><xsl:when test="contains($bsh,'\')"><xsl:value-of select="concat('/',translate($bsh,'\','/'))"/></xsl:when><xsl:otherwise><xsl:value-of select="$bsh"/></xsl:otherwise></xsl:choose></xsl:if><xsl:if test="@uof:书签"><xsl:variable name="bookmarkDest" select="@uof:书签"/><xsl:choose><xsl:when test="/uof:UOF/uof:书签集/uof:书签"><xsl:for-each select="/uof:UOF/uof:书签集/uof:书签"><xsl:if test="@uof:名称=$bookmarkDest"><xsl:value-of select="concat('#',@uof:名称)"/></xsl:if></xsl:for-each></xsl:when><xsl:otherwise><xsl:value-of select="concat('#',$bookmarkDest)"/></xsl:otherwise></xsl:choose></xsl:if></xsl:if></xsl:for-each></xsl:attribute>
                        <xsl:for-each select="/uof:UOF/uof:链接集/uof:超级链接">
                            <xsl:if test="@uof:链源=$hyperDest">
                                <xsl:if test="@uof:提示">
                                    <xsl:attribute name="office:name"><xsl:value-of select="@uof:提示"/></xsl:attribute>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:choose>
                            <xsl:when test="./字:文本串">
                                <xsl:apply-templates select="字:文本串"/>
                            </xsl:when>
                            <xsl:when test="following-sibling::字:句/字:文本串">
                                <xsl:value-of select="following-sibling::字:句/字:文本串"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="字:区域结束 and preceding::字:区域开始[1]/@字:类型='bookmark' and not(self::node()/字:区域开始)">
                    <xsl:variable name="aa">
                        <xsl:value-of select="字:区域结束/@字:标识符引用"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="preceding::字:区域开始[1]/@字:类型='bookmark' and not(preceding::字:区域开始[1]/@字:名称)">
                            <text:bookmark-end text:name="{/uof:UOF/uof:书签集/uof:书签[uof:文本位置/@字:区域引用=$aa]/@uof:名称}"/>
                        </xsl:when>
                        <xsl:when test="preceding::字:区域开始[1]/@字:类型='bookmark'">
                            <text:bookmark-end text:name="{preceding::字:区域开始[1]/@字:名称}"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="preceding-sibling::字:句[position()=1]/字:区域开始[@字:类型='hyperlink'] and  not(preceding-sibling::字:句[position()=1]/字:区域结束)"/>
                <xsl:when test="(preceding-sibling::字:句)  or (字:句属性)or(字:区域开始)">
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
                                <xsl:attribute name="text:style-name"><xsl:value-of select="concat('T',$stylenum)"/></xsl:attribute>
                                <xsl:apply-templates select="*[not(name()='字:引文符号')]"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="字:文本串|字:锚点|字:空格符|字:换行符|字:制表符|字:区域开始|字:区域结束|字:脚注|字:尾注"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="node()[name() =  '字:位置']">
        <xsl:attribute name="style:text-position"><xsl:variable name="val"><xsl:value-of select="."/></xsl:variable><xsl:choose><xsl:when test="$val='sub' or $val='super'"><xsl:value-of select="concat($val,' 58%')"/></xsl:when><xsl:when test="contains($val,'sub ') or contains($val,'super ')"><xsl:value-of select="concat($val,'%')"/></xsl:when><xsl:when test="not(contains($val,' '))"><xsl:value-of select="concat($val,'% 100%')"/></xsl:when><xsl:otherwise><xsl:value-of select="concat(substring-before($val,' '),'% ',substring-after($val,' '),'%' )"/></xsl:otherwise></xsl:choose></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:批注">
        <office:annotation office:display="true">
            <xsl:variable name="name" select="@字:作者"/>
            <dc:creator>
                <xsl:value-of select="/uof:UOF/uof:文字处理/字:公用处理规则/字:用户集/字:用户[@字:标识符=$name]/@字:姓名"/>
            </dc:creator>
            <dc:date>
                <xsl:value-of select="@字:日期"/>
            </dc:date>
            <xsl:apply-templates select="字:段落"/>
        </office:annotation>
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
            <xsl:attribute name="fo:color"><xsl:value-of select="@字:颜色"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@字:中文字体引用">
            <xsl:attribute name="style:font-name-asian"><xsl:value-of select="@字:中文字体引用"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@字:西文字体引用">
            <xsl:variable name="xiwen" select="@字:西文字体引用"/>
            <xsl:attribute name="style:font-name"><xsl:value-of select="translate($xiwen,'_',' ')"/></xsl:attribute>
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
        <xsl:if test="@字:值='true'or @字:值='1'">
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
                <xsl:when test="@字:类型='dot'">
                    <xsl:attribute name="style:text-emphasize">dot below</xsl:attribute>
                </xsl:when>
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
                <xsl:otherwise>none</xsl:otherwise>
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
    <xsl:template match="字:闪动的">
        <xsl:attribute name="style:text-blinking"><xsl:value-of select="@字:闪动的"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:删除线">
        <xsl:choose>
            <xsl:when test="@字:类型 = 'single' ">
                <xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'double' ">
                <xsl:attribute name="style:text-line-through-type">double</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'bold' ">
                <xsl:attribute name="style:text-line-through-width">bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = 'xl' ">
                <xsl:attribute name="style:text-line-through-text">X</xsl:attribute>
            </xsl:when>
            <xsl:when test="@字:类型 = '/l' ">
                <xsl:attribute name="style:text-line-through-text">/</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="style:text-crossing-out">none</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:突出显示">
        <xsl:attribute name="fo:background-color">
            <xsl:choose>
                <xsl:when test="@字:颜色='auto'">transparent</xsl:when>
                <xsl:otherwise><xsl:value-of select="@字:颜色"/></xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
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
    <xsl:template match="字:位置" mode="oo">
        <xsl:attribute name="style:text-position"><xsl:variable name="val"><xsl:value-of select="."/></xsl:variable><xsl:choose><xsl:when test="$val='sub' or $val='super'"><xsl:value-of select="concat($val,' 58%')"/></xsl:when><xsl:when test="contains($val,'sub ') or contains($val,'super ')"><xsl:value-of select="concat($val,'%')"/></xsl:when><xsl:when test="not(contains($val,' '))"><xsl:value-of select="concat($val,'% 100%')"/></xsl:when><xsl:otherwise><xsl:value-of select="concat(substring-before($val,' '),'% ',substring-after($val,' '),'%' )"/></xsl:otherwise></xsl:choose></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:缩放">
        <xsl:attribute name="style:text-scale"><xsl:value-of select="."/>%</xsl:attribute>
    </xsl:template>
    <xsl:template match="字:字符间距">
        <xsl:attribute name="fo:letter-spacing"><xsl:value-of select="."/>cm</xsl:attribute>
    </xsl:template>
    <xsl:template match="字:调整字间距">
        <xsl:variable name="tt" select="字:调整字间距"/>
        <xsl:attribute name="style:letter-kerning"><xsl:choose><xsl:when test="$tt='1'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:外框">
        <xsl:attribute name="style:text-outline">true</xsl:attribute>
    </xsl:template>
    <xsl:template match="字:字符间距[parent::字:句属性]">
        <xsl:variable name="aa">
            <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:attribute name="fo:letter-spacing"><xsl:value-of select="concat( $aa, $uofUnit)"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="字:分节">
        <xsl:if test="字:节属性/字:脚注设置">
            <xsl:call-template name="脚注设置"/>
        </xsl:if>
        <xsl:if test="字:节属性/字:尾注设置">
            <xsl:call-template name="尾注设置"/>
        </xsl:if>
        <xsl:if test="字:节属性/字:行号设置">
            <xsl:call-template name="行编号"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="行编号">
        <xsl:element name="text:linenumbering-configuration">
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:行号设置">
                <xsl:choose>
                    <xsl:when test="@字:使用行号='false'">
                        <xsl:attribute name="text:number-lines">false</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="text:style-name">Line numbering</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="@字:编号方式">
                    <xsl:choose>
                        <xsl:when test="@字:编号方式='section'">
                            <xsl:attribute name="text:count-in-floating-frames">true</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@字:编号方式='page'">
                            <xsl:attribute name="text:restart-on-page">true</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="字:编号方式='continuous'">
                            <xsl:attribute name="text:count-empty-lines">true</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@字:起始编号">
                    <xsl:attribute name="style:num-format"><xsl:value-of select="@字:起始编号"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="@字:距边界">
                    <xsl:attribute name="text:offset"><xsl:value-of select="concat(@字:距边界,$uofUnit)"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="@字:行号间隔">
                    <xsl:attribute name="text:increment"><xsl:value-of select="@字:行号间隔"/></xsl:attribute>
                </xsl:if>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template name="脚注设置">
        <xsl:element name="text:notes-configuration">
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:脚注设置">
                <xsl:attribute name="text:note-class">footnote</xsl:attribute>
                <xsl:attribute name="text:master-page-name">Footnote</xsl:attribute>
                <xsl:attribute name="text:footnotes-position"><xsl:choose><xsl:when test="@字:位置='page-bottom'">page</xsl:when><xsl:when test="@字:位置='below-text'">document</xsl:when></xsl:choose></xsl:attribute>
                <xsl:attribute name="text:start-numbering-at"><xsl:choose><xsl:when test="@字:编号方式='continuous'">document</xsl:when><xsl:when test="@字:编号方式='section'">chapter</xsl:when><xsl:when test="@字:编号方式='page'">page</xsl:when></xsl:choose></xsl:attribute>
                <xsl:attribute name="text:start-value"><xsl:value-of select="@字:起始编号 - 1"/></xsl:attribute>
                <xsl:attribute name="style:num-format"><xsl:call-template name="oo数字格式"><xsl:with-param name="oo_format" select="@字:格式"/></xsl:call-template></xsl:attribute>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template name="尾注设置">
        <xsl:element name="text:notes-configuration">
            <xsl:for-each select="/uof:UOF/uof:文字处理/字:主体/字:分节/字:节属性/字:尾注设置">
                <xsl:attribute name="text:note-class">endnote</xsl:attribute>
                <xsl:attribute name="text:master-page-name">Endnote</xsl:attribute>
                <xsl:attribute name="style:num-format"><xsl:call-template name="oo数字格式"><xsl:with-param name="oo_format" select="@字:格式"/></xsl:call-template></xsl:attribute>
                <xsl:attribute name="text:start-value"><xsl:value-of select="@字:起始编号 - 1"/></xsl:attribute>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template name="paragraph-properties">
        <xsl:choose>
            <xsl:when test="descendant::字:页边距[@uof:左]">
                <xsl:attribute name="fo:margin-left"><xsl:value-of select="number((descendant::字:页边距/@uof:左)) * $other-to-cm-conversion-factor"/>cm</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="fo:margin-left">0cm</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="descendant::字:页边距[@uof:右]">
                <xsl:attribute name="fo:margin-right"><xsl:value-of select="number((descendant::字:页边距/@uof:右)) * $other-to-cm-conversion-factor"/>cm</xsl:attribute>
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
    <xsl:template match="字:文字表">
        <xsl:choose>
            <xsl:when test="@字:类型 = 'sub-table'">
                <xsl:element name="table:table">
                    <xsl:attribute name="table:is-sub-table">true</xsl:attribute>
                    <xsl:apply-templates select="字:文字表属性">
                        <xsl:with-param name="sub-table" select="@字:类型"/>
                    </xsl:apply-templates>
                    <xsl:if test="字:行[position()=1]/字:表行属性/字:表头行/@字:值='true'">
                        <xsl:element name="table:table-header-rows">
                            <xsl:for-each select="字:行">
                                <xsl:if test="字:表行属性/字:表头行/@字:值='true'">
                                    <xsl:apply-templates select="."/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>
                    <xsl:for-each select="字:行[not(字:表行属性/字:表头行) or (字:表行属性/字:表头行/@字:值='false')]">
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="table:table">
                    <xsl:if test="字:文字表属性">
                        <xsl:attribute name="table:style-name">Table<xsl:number count="字:文字表[not (@字:类型='sub-table')]" from="/uof:UOF/uof:文字处理/字:主体" level="any" format="1"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="not(字:文字表属性/字:列宽集/字:列宽)">
                        <xsl:for-each select="字:行[1]/字:单元格">
                            <xsl:element name="table:table-column">
                                <xsl:attribute name="table:style-name">Table<xsl:number count="字:文字表" from="/uof:UOF/uof:文字处理/字:主体" level="any" format="1"/>.C<xsl:number value="count(preceding::字:单元格)+1"/></xsl:attribute>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:apply-templates select="字:文字表属性"/>
                    <xsl:if test="字:行[position()=1]/字:表行属性/字:表头行/@字:值='true'">
                        <xsl:element name="table:table-header-rows">
                            <xsl:for-each select="字:行">
                                <xsl:if test="字:表行属性/字:表头行/@字:值='true'">
                                    <xsl:apply-templates select="."/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>
                    <xsl:for-each select="字:行[not(字:表行属性/字:表头行) or (字:表行属性/字:表头行/@字:值='false')]">
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:文字表属性">
        <xsl:param name="sub-table"/>
        <xsl:apply-templates select="字:列宽集">
            <xsl:with-param name="sub-table" select="$sub-table"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="字:列宽集">
        <xsl:param name="sub-table"/>
        <xsl:apply-templates select="字:列宽">
            <xsl:with-param name="sub-table" select="$sub-table"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="字:列宽">
        <xsl:param name="sub-table"/>
        <xsl:element name="table:table-column">
            <xsl:choose>
                <xsl:when test="$sub-table='sub-table'">
                    <xsl:variable name="subtable-leikuan" select="."/>
                    <xsl:variable name="weizi">
                        <xsl:for-each select="ancestor::*[name()='字:文字表' and not(@字:类型='sub-table')]/字:文字表属性/字:列宽集/字:列宽">
                            <xsl:variable name="yyyyy" select="."/>
                            <xsl:if test="substring(string($yyyyy),1,string-length(string($yyyyy))-1)=substring(string($subtable-leikuan),1,string-length(string($subtable-leikuan))-1)">
                                <xsl:value-of select="concat(position(),';')"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="xxxxx">
                        <xsl:number count="字:文字表[not (@字:类型='sub-table')]" from="/uof:UOF/uof:文字处理/字:主体" level="any" format="1"/>
                    </xsl:variable>
                    <xsl:attribute name="table:style-name"><xsl:value-of select="concat('Table',$xxxxx,'.C',substring-before($weizi,';'))"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="table:style-name">Table<xsl:number count="字:文字表[not (@字:类型='sub-table')]" from="/uof:UOF/uof:文字处理/字:主体" level="any" format="1"/>.C<xsl:number count="字:列宽" from="/uof:UOF/uof:文字处理/字:主体" level="single" format="1"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="字:行">
        <xsl:element name="table:table-row">
            <xsl:attribute name="table:style-name">Table<xsl:number count="字:文字表[not (@字:类型='sub-table')]" from="/uof:UOF/uof:文字处理/字:主体" level="any" format="1"/>.R<xsl:number count="字:行" from="/uof:UOF/uof:文字处理/字:主体/字:文字表[not (@字:类型='sub-table')]" level="any" format="1"/></xsl:attribute>
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="name()='字:单元格'">
                        <xsl:call-template name="字:单元格"/>
                    </xsl:when>
                    <xsl:when test="name()='字:单元格覆盖'">

                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template name="字:单元格">
        <xsl:element name="table:table-cell">
            <xsl:attribute name="table:style-name">Table<xsl:number count="字:文字表[not (@字:类型='sub-table')]" from="/uof:UOF/uof:文字处理/字:主体" level="any" format="1"/>.R<xsl:number count="字:行" from="/uof:UOF/uof:文字处理/字:主体/字:文字表[not (@字:类型='sub-table')]" level="any" format="1"/>C<xsl:number count="字:单元格" from="/uof:UOF/uof:文字处理/字:主体/字:文字表[not (@字:类型='sub-table')]/字:行" level="any" format="1"/></xsl:attribute>
            <xsl:if test="字:单元格属性">
                <xsl:apply-templates select="字:单元格属性"/>
            </xsl:if>
            <xsl:for-each select="node( )">
                <xsl:choose>
                    <xsl:when test="name( )='字:段落'">
                        <xsl:apply-templates select="."/>
                    </xsl:when>
                    <xsl:when test="name( )='字:文字表'">
                        <xsl:apply-templates select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match="字:单元格属性/字:边框">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="字:对齐[parent::字:文字表属性]">

    </xsl:template>
    <xsl:template match="uof:上">
        <xsl:choose>
            <xsl:when test="@uof:宽度='nil' ">
                <xsl:attribute name="fo:border-top">none</xsl:attribute>
            </xsl:when>
            <xsl:when test="@uof:宽度 and @uof:颜色">
                <xsl:attribute name="fo:border-top"><xsl:value-of select="concat(number(@uof:宽度),$uofUnit)"/><xsl:text> </xsl:text><xsl:choose><xsl:when test="@uof:颜色 ='auto'"><xsl:text>solid #000000</xsl:text></xsl:when><xsl:otherwise><xsl:text>solid </xsl:text><xsl:value-of select="@uof:颜色"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:when>
            <xsl:when test="@uof:宽度">
                <xsl:attribute name="fo:border-top"><xsl:value-of select="concat(number(@uof:宽度),$uofUnit)"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="uof:下">
        <xsl:choose>
            <xsl:when test="@uof:宽度='nil' ">
                <xsl:attribute name="fo:border-bottom">none</xsl:attribute>
            </xsl:when>
            <xsl:when test="@uof:宽度 and @uof:颜色">
                <xsl:attribute name="fo:border-bottom"><xsl:value-of select="concat(number(@uof:宽度),$uofUnit)"/><xsl:text> </xsl:text><xsl:choose><xsl:when test="@uof:颜色 ='auto'"><xsl:text>solid #000000</xsl:text></xsl:when><xsl:otherwise><xsl:text>solid </xsl:text><xsl:value-of select="@uof:颜色"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:when>
            <xsl:when test="@uof:宽度">
                <xsl:attribute name="fo:border-bottom"><xsl:value-of select="concat(number(@uof:宽度),$uofUnit)"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="uof:左">
        <xsl:choose>
            <xsl:when test="@uof:宽度='nil'">
                <xsl:attribute name="fo:border-left">none</xsl:attribute>
            </xsl:when>
            <xsl:when test="@uof:宽度 and @uof:颜色">
                <xsl:attribute name="fo:border-left"><xsl:value-of select="concat(number(@uof:宽度),$uofUnit)"/><xsl:text> </xsl:text><xsl:choose><xsl:when test="@uof:颜色 ='auto'"><xsl:text>solid #000000</xsl:text></xsl:when><xsl:otherwise><xsl:text>solid </xsl:text><xsl:value-of select="@uof:颜色"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:when>
            <xsl:when test="@uof:宽度">
                <xsl:attribute name="fo:border-left"><xsl:value-of select="concat(number(@uof:宽度),$uofUnit)"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="uof:右">
        <xsl:choose>
            <xsl:when test="@uof:宽度='nil' ">
                <xsl:attribute name="fo:border-right">none</xsl:attribute>
            </xsl:when>
            <xsl:when test="@uof:宽度 and @uof:颜色">
                <xsl:attribute name="fo:border-right"><xsl:value-of select="concat(number(@uof:宽度),$uofUnit)"/><xsl:text> </xsl:text><xsl:choose><xsl:when test="@uof:颜色 ='auto'"><xsl:text>solid #000000</xsl:text></xsl:when><xsl:otherwise><xsl:text>solid </xsl:text><xsl:value-of select="@uof:颜色"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:when>
            <xsl:when test="@uof:宽度">
                <xsl:attribute name="fo:border-right"><xsl:value-of select="concat(number(@uof:宽度),$uofUnit)"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:文字表属性/字:边框">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="字:单元格属性/字:边框">
        <xsl:call-template name="uof:边框"/>
    </xsl:template>
    <xsl:template match="字:左缩进">
    </xsl:template>
    <xsl:template match="字:单元格属性">
        <xsl:if test="字:跨列/@字:值">
            <xsl:attribute name="table:number-columns-spanned"><xsl:value-of select="字:跨列/@字:值"/></xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template name="编号风格">
        <xsl:for-each select="/uof:UOF/uof:式样集/uof:自动编号集/字:自动编号">
            <xsl:element name="style:style">
                <xsl:attribute name="style:name"><xsl:value-of select="concat('P',@字:标识符)"/></xsl:attribute>
                <xsl:attribute name="style:family">paragraph</xsl:attribute>
                <xsl:attribute name="style:parent-style-name">Standard</xsl:attribute>
                <xsl:attribute name="style:list-style-name"><xsl:value-of select="@字:标识符"/></xsl:attribute>
                <xsl:element name="style:text-properties">
                    <xsl:attribute name="fo:margin-left">0cm</xsl:attribute>
                    <xsl:attribute name="fo:margin-right">0cm</xsl:attribute>
                    <xsl:attribute name="fo:color"><xsl:value-of select="字:级别/字:符号字体/字:字体/字:颜色"/></xsl:attribute>
                    <xsl:attribute name="fo:text-indent"/>
                    <xsl:attribute name="style:auto-text-indent">false</xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="编号格式">
        <xsl:attribute name="style:num-format"><xsl:choose><xsl:when test="string(字:编号格式)='lower-letter'">a</xsl:when><xsl:when test="string(字:编号格式)='upper-letter'">A</xsl:when><xsl:when test="string(字:编号格式)='lower-roman'">i</xsl:when><xsl:when test="string(字:编号格式)='upper-roman'">I</xsl:when><xsl:when test="string(字:编号格式)='decimal-enclosed-circle'">①, ②, ③, ...</xsl:when><xsl:when test="string(字:编号格式)='ideograph-traditional'">甲, 乙, 丙, ...</xsl:when><xsl:when test="string(字:编号格式)='ideograph-zodiac'">子, 丑, 寅, ...</xsl:when><xsl:when test="string(字:编号格式)='chinese-counting'">一, 二, 三, ...</xsl:when><xsl:when test="string(字:编号格式)='chinese-legal-simplified'">壹, 贰, 叁, ...</xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute>
    </xsl:template>
    <xsl:template name="图形style">
        <xsl:for-each select="/uof:UOF/uof:对象集/图:图形">
            <xsl:element name="style:style">
                <xsl:attribute name="style:name"><xsl:value-of select="@图:标识符"/></xsl:attribute>
                <xsl:attribute name="style:family">graphic</xsl:attribute>
                <xsl:attribute name="style:parent-style-name">Graphics</xsl:attribute>
                <xsl:element name="style:text-properties">
                    <xsl:attribute name="svg:stroke-width"><xsl:value-of select="图:预定义图形/图:属性/图:线粗细"/></xsl:attribute>
                    <xsl:attribute name="svg:stroke-color"><xsl:value-of select="图:预定义图形/图:属性/图:线颜色"/></xsl:attribute>
                    <xsl:attribute name="draw:stroke-dash"><xsl:value-of select="图:预定义图形/图:属性/图:线型"/></xsl:attribute>
                    <xsl:attribute name="draw:marker-start"><xsl:value-of select="图:预定义图形/图:属性/图:前端箭头/图:式样"/></xsl:attribute>
                    <xsl:attribute name="draw:marker-end"><xsl:value-of select="图:预定义图形/图:属性/图:后端箭头/图:式样"/></xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="duanluoshuxing">
        <xsl:for-each select="/uof:UOF/uof:文字处理//字:段落">
            <xsl:choose>
                <xsl:when test="count(字:句)&lt;=1">
                    <xsl:call-template name="单个或者没有句"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="多个句"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="单个或者没有句">
        <xsl:variable name="stylename" select="字:段落属性/@字:式样引用"/>
        <xsl:element name="style:style">
            <xsl:attribute name="style:name">P<xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落"/></xsl:attribute>
            <xsl:attribute name="style:family">paragraph</xsl:attribute>
            <xsl:if test="name(preceding-sibling::*[1])='字:分节'">
                <xsl:attribute name="style:master-page-name"><xsl:value-of select="preceding-sibling::字:分节[1]/@字:名称"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="字:段落属性/@字:式样引用">
                <xsl:variable name="duanluoyinyong">
                    <xsl:value-of select="字:段落属性/@字:式样引用"/>
                </xsl:variable>
                <xsl:for-each select="/uof:UOF//uof:段落式样">
                    <xsl:if test="$duanluoyinyong=@字:标识符">
                        <xsl:if test="@字:基式样引用">
                            <xsl:choose>
                                <xsl:when test="@字:标识符=/uof:UOF/uof:文字处理/字:主体/字:段落/字:段落属性/字:格式修订/@字:修订信息引用">
                                    <xsl:attribute name="style:parent-style-name"><xsl:value-of select="@字:标识符"/></xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="style:parent-style-name"><xsl:value-of select="@字:基式样引用"/></xsl:attribute>
                                    <xsl:variable name="aa">
                                        <xsl:value-of select="@字:基式样引用"/>
                                    </xsl:variable>
                                    <xsl:for-each select="/uof:UOF//uof:段落式样">
                                        <xsl:if test="$aa=@字:标识符">
                                            <xsl:attribute name="style:display-name"><xsl:choose><xsl:when test="@字:别名"><xsl:value-of select="@字:别名"/></xsl:when><xsl:otherwise><xsl:value-of select="@字:名称"/></xsl:otherwise></xsl:choose></xsl:attribute>
                                            <xsl:element name="style:paragraph-properties">
                                                <xsl:if test="字:对齐">
                                                    <xsl:if test="字:对齐/@字:文字对齐">
                                                        <xsl:attribute name="style:vertical-align"><xsl:choose><xsl:when test="字:对齐/@字:文字对齐='base'">baseline</xsl:when><xsl:when test="字:对齐/@字:文字对齐='center'">middle</xsl:when><xsl:otherwise><xsl:value-of select="字:对齐/@字:文字对齐"/></xsl:otherwise></xsl:choose></xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:if test="字:对齐/@字:水平对齐">
                                                        <xsl:attribute name="fo:text-align"><xsl:choose><xsl:when test="字:对齐/@字:水平对齐='left'">start</xsl:when><xsl:when test="字:对齐/@字:水平对齐='right'">end</xsl:when><xsl:when test="字:对齐/@字:水平对齐='center'">center</xsl:when><xsl:otherwise>justify</xsl:otherwise></xsl:choose></xsl:attribute>
                                                        <xsl:if test="字:对齐/@字:水平对齐='distributed'">
                                                            <xsl:attribute name="fo:text-align-last">justify</xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:attribute name="style:justify-single-word">false</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:if>
                                                <xsl:call-template name="ParagraphAttr"/>
                                                <xsl:if test="字:段落属性/字:制表位设置">
                                                    <xsl:call-template name="ootab"/>
                                                </xsl:if>
                                            </xsl:element>
                                            <xsl:if test="字:句属性">
                                                <xsl:variable name="bsh">
                                                    <xsl:value-of select="字:句属性/@字:式样引用"/>
                                                </xsl:variable>
                                                <xsl:element name="style:text-properties">
                                                    <xsl:for-each select="/uof:UOF//uof:句式样">
                                                        <xsl:if test="$bsh=@字:标识符">
                                                            <xsl:apply-templates select="./*"/>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="字:边框">
                            <xsl:call-template name="uof:边框"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            <xsl:element name="style:text-properties">
                <xsl:if test="字:句/字:句属性/字:字体">
                    <xsl:variable name="ziti">
                        <xsl:value-of select="字:句/字:句属性/字:字体/@字:中文字体引用"/>
                    </xsl:variable>
                    <xsl:for-each select="/uof:UOF/uof:式样集/uof:字体集/uof:字体声明">
                        <xsl:if test="@uof:标识符=$ziti">
                            <xsl:attribute name="style:font-name"><xsl:value-of select="@uof:名称"/></xsl:attribute>
                            <xsl:attribute name="style:font-name-asian"><xsl:value-of select="@uof:名称"/></xsl:attribute>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="字:句/字:句属性/字:字体/@字:字号">
                        <xsl:attribute name="fo:font-size"><xsl:value-of select="字:句/字:句属性/字:字体/@字:字号"/></xsl:attribute>
                        <xsl:attribute name="style:font-size-asian"><xsl:value-of select="字:句/字:句属性/字:字体/@字:字号"/></xsl:attribute>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="字:段落属性/字:句属性">
                    <xsl:for-each select="字:段落属性/字:句属性">
                        <xsl:apply-templates select="./*"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:apply-templates select="字:句/字:句属性/字:浮雕 | 字:句/字:句属性/字:边框 | 字:句/字:句属性/字:缩放 | 字:句/字:句属性/字:阴影 | 字:句/字:句属性/字:删除线 | 字:句/字:句属性/字:下划线 |  字:句/字:填充"/>
                <xsl:call-template name="ParagraphAttr"/>
                <xsl:if test="字:段落属性/字:制表位设置">
                    <xsl:call-template name="ootab"/>
                </xsl:if>
                <xsl:for-each select="/uof:UOF/uof:式样集/uof:句式样[@字:标识符=$stylename]">
                    <xsl:apply-templates select="./*"/>
                </xsl:for-each>
            </xsl:element>
            <style:paragraph-properties>
                <xsl:if test="字:句/字:分栏符">
                    <xsl:attribute name="fo:break-before">column</xsl:attribute>
                </xsl:if>
                <xsl:if test="字:句/字:分页符">
                    <xsl:attribute name="fo:break-before">page</xsl:attribute>
                </xsl:if>
                <xsl:call-template name="ParagraphAttr"/>
                <xsl:if test="字:段落属性/字:制表位设置">
                    <xsl:call-template name="ootab"/>
                </xsl:if>
            </style:paragraph-properties>
        </xsl:element>
    </xsl:template>
    <xsl:template name="ParagraphAttr">
        <xsl:apply-templates select="字:段落属性/字:填充"/>
        <xsl:if test="字:段落属性/字:对齐">
            <xsl:if test="字:段落属性/字:对齐/@字:文字对齐">
                <xsl:attribute name="style:vertical-align"><xsl:choose><xsl:when test="字:段落属性/字:对齐/@字:文字对齐='base'">baseline</xsl:when><xsl:when test="字:段落属性/字:对齐/@字:文字对齐='center'">middle</xsl:when><xsl:otherwise><xsl:value-of select="字:段落属性/字:对齐/@字:文字对齐"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:if>
            <xsl:if test="字:段落属性/字:对齐/@字:水平对齐">
                <xsl:attribute name="fo:text-align"><xsl:choose><xsl:when test="字:段落属性/字:对齐/@字:水平对齐='left'">start</xsl:when><xsl:when test="字:段落属性/字:对齐/@字:水平对齐='right'">end</xsl:when><xsl:when test="字:段落属性/字:对齐/@字:水平对齐='center'">center</xsl:when><xsl:otherwise>justify</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:if test="字:段落属性/字:对齐/@字:水平对齐='distributed'">
                    <xsl:attribute name="fo:text-align-last">justify</xsl:attribute>
                </xsl:if>
                <xsl:attribute name="style:justify-single-word">false</xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="字:段落属性/字:缩进">
                <xsl:variable name="a1">
                    <xsl:value-of select="字:段落属性/字:缩进/字:左/字:相对/@字:值"/>
                </xsl:variable>
                <xsl:variable name="a2">
                    <xsl:value-of select="字:段落属性/字:缩进/字:右/字:相对/@字:值"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="字:段落属性/字:缩进/字:左/字:相对 or 字:段落属性/字:缩进/字:右/字:相对">
                        <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat($a1 * 0.37,'cm')"/></xsl:attribute>
                        <xsl:attribute name="fo:margin-right"><xsl:value-of select="concat($a2 * 0.37,'cm')"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(字:段落属性/字:缩进/字:左/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
                        <xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(字:段落属性/字:缩进/字:右/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:attribute name="fo:text-indent"><xsl:value-of select="concat(字:段落属性/字:缩进/字:首行/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="ancestor::uof:UOF/uof:式样集/uof:自动编号集/字:自动编号/字:级别[following-sibling::字:级别[position()=1]/@字:级别值='1']/字:缩进">
                <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(ancestor::uof:UOF/uof:式样集/uof:自动编号集/字:自动编号/字:级别[following-sibling::字:级别[position()=1]/@字:级别值='1']/字:缩进/字:左/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(ancestor::uof:UOF/uof:式样集/uof:自动编号集/字:自动编号/字:级别[following-sibling::字:级别[position()=1]/@字:级别值='1']/字:缩进/字:右/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
                <xsl:attribute name="fo:text-indent"><xsl:value-of select="concat(ancestor::uof:UOF/uof:式样集/uof:自动编号集/字:自动编号/字:级别[following-sibling::字:级别[position()=1]/@字:级别值='1']/字:缩进/字:首行/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="字:段落属性/字:行距">
            <xsl:variable name="type">
                <xsl:value-of select="字:段落属性/字:行距/@字:类型"/>
            </xsl:variable>
            <xsl:variable name="val">
                <xsl:value-of select="字:段落属性/字:行距/@字:值"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$type='fixed'">
                    <xsl:attribute name="fo:line-height"><xsl:value-of select="concat($val,$uofUnit)"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="$type='multi-lines'">
                    <xsl:attribute name="fo:line-height"><xsl:value-of select="concat($val * 100,'%')"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="$type='at-least'">
                    <xsl:attribute name="style:line-height-at-least"><xsl:value-of select="concat($val,$uofUnit)"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="$type='line-space'">
                    <xsl:attribute name="style:line-spacing"><xsl:value-of select="concat($val,$uofUnit)"/></xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="字:段落属性/字:段间距">
            <xsl:if test="字:段落属性/字:段间距/字:段前距/字:绝对值/@字:值">
                <xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(字:段落属性/字:段间距/字:段前距/字:绝对值/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="字:段落属性/字:段间距/字:段后距/字:绝对值/@字:值">
                <xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(字:段落属性/字:段间距/字:段后距/字:绝对值/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:if>
            <xsl:variable name="aa">
                <xsl:value-of select="字:段落属性/字:段间距/字:段前距/字:相对值/@字:值"/>
            </xsl:variable>
            <xsl:variable name="bb">
                <xsl:value-of select="字:段落属性/字:段间距/字:段后距/字:相对值/@字:值"/>
            </xsl:variable>
            <xsl:if test="字:段落属性/字:段间距/字:段前距/字:相对值/@字:值">
                <xsl:attribute name="fo:margin-top"><xsl:value-of select="concat($aa * 15.6,$uofUnit)"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="字:段落属性/字:段间距/字:段后距/字:相对值/@字:值">
                <xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat($bb * 15.6,$uofUnit)"/></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="字:段落属性/字:孤行控制">
            <xsl:attribute name="fo:widows"><xsl:value-of select="字:段落属性/字:孤行控制"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:段落属性/字:寡行控制">
            <xsl:attribute name="fo:orphans"><xsl:value-of select="字:段落属性/字:寡行控制"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:段落属性/字:段中不分页">
            <xsl:attribute name="fo:keep-together"><xsl:choose><xsl:when test="字:段落属性/字:段中不分页/@字:值='1' or 字:段落属性/字:段中不分页/@字:值='true'">always</xsl:when><xsl:otherwise>auto</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:段落属性/字:与下段同页">
            <xsl:attribute name="fo:keep-with-next"><xsl:choose><xsl:when test="字:段落属性/字:与下段同页/@字:值='1' or 字:段落属性/字:与下段同页/@字:值='true'">always</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:for-each select="字:段落属性/字:边框">
            <xsl:call-template name="uof:边框"/>
        </xsl:for-each>
        <xsl:for-each select="字:段落属性/字:填充">
            <xsl:call-template name="uof:填充"/>
        </xsl:for-each>
        <xsl:if test="字:段落属性/字:对齐网格">
            <xsl:attribute name="style:snap-to-layout-grid"><xsl:choose><xsl:when test="字:段落属性/字:对齐网格/@字:值='1' or 字:段落属性/字:对齐网格/@字:值='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:段落属性/字:取消断字">
            <xsl:attribute name="fo:hyphenation-ladder-count">no-limit</xsl:attribute>
            <xsl:attribute name="fo:hyphenation-remain-char-count">2</xsl:attribute>
            <xsl:attribute name="fo:hyphenation-push-char-count">2</xsl:attribute>
            <xsl:attribute name="fo:hyphenate"><xsl:choose><xsl:when test="字:段落属性/字:取消断字/@字:值='1' or 字:段落属性/字:取消断字/@字:值='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:段落属性/字:取消行号">
            <xsl:attribute name="text:number-lines"><xsl:choose><xsl:when test="字:段落属性/字:取消行号/@字:值='1' or 字:段落属性/字:取消行号/@字:值='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:段落属性/字:行首尾标点控制">
            <xsl:attribute name="style:punctuation-wrap"><xsl:choose><xsl:when test="字:段落属性/字:行首尾标点控制/@字:值='1' or 字:段落属性/字:行首尾标点控制/@字:值='true'">hanging</xsl:when><xsl:otherwise>simple</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:段落属性/字:是否行首标点压缩/@字:值='true'">
            <xsl:attribute name="style:punctuation-compress">false</xsl:attribute>
        </xsl:if>
        <xsl:if test="字:段落属性/字:中文习惯首尾字符">
            <xsl:attribute name="style:line-break"><xsl:choose><xsl:when test="字:段落属性/字:中文习惯首尾字符/@字:值='1' or 字:段落属性/字:中文习惯首尾字符/@字:值='true'">strict</xsl:when><xsl:otherwise>normal</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:段落属性/字:自动调整中英文字符间距 or 字:段落属性/字:自动调整中文与数字间距">
            <xsl:attribute name="style:text-autospace"><xsl:choose><xsl:when test="字:段落属性/字:自动调整中英文字符间距/@字:值='1' or 字:段落属性/字:自动调整中文与数字间距/@字:值='1'or 字:段落属性/字:自动调整中英文字符间距/@字:值='true' or 字:段落属性/字:自动调整中文与数字间距/@字:值='true'">ideograph-alpha</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:段落属性/字:首字下沉">
            <xsl:element name="style:drop-cap">
                <xsl:if test="字:段落属性/字:首字下沉/@字:行数">
                    <xsl:attribute name="style:lines"><xsl:value-of select="字:段落属性/字:首字下沉/@字:行数"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="字:段落属性/字:首字下沉/@字:间距">
                    <xsl:attribute name="style:distance"><xsl:value-of select="concat(字:段落属性/字:首字下沉/@字:间距,$uofUnit)"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="字:段落属性/字:首字下沉/@字:字体引用">
                    <xsl:attribute name="style:style-name"><xsl:value-of select="translate(字:段落属性/字:首字下沉/@字:字体引用,'_',' ')"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="字:段落属性/字:首字下沉/@字:字符数">
                    <xsl:attribute name="style:length"><xsl:choose><xsl:when test="字:段落属性/字:首字下沉/@字:字符数='1'">word</xsl:when><xsl:otherwise><xsl:value-of select="字:段落属性/字:首字下沉/@字:字符数"/></xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="XDParagraphAttr">
        <xsl:apply-templates select="字:填充"/>
        <xsl:if test="字:对齐">
            <xsl:if test="字:对齐/@字:文字对齐">
                <xsl:attribute name="style:vertical-align"><xsl:choose><xsl:when test="字:对齐/@字:文字对齐='base'">baseline</xsl:when><xsl:when test="字:对齐/@字:文字对齐='center'">middle</xsl:when><xsl:otherwise><xsl:value-of select="字:对齐/@字:文字对齐"/></xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:if>
            <xsl:if test="字:对齐/@字:水平对齐">
                <xsl:attribute name="fo:text-align"><xsl:choose><xsl:when test="字:对齐/@字:水平对齐='left'">start</xsl:when><xsl:when test="字:对齐/@字:水平对齐='right'">end</xsl:when><xsl:when test="字:对齐/@字:水平对齐='center'">center</xsl:when><xsl:otherwise>justify</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:if test="字:对齐/@字:水平对齐='distributed'">
                    <xsl:attribute name="fo:text-align-last">justify</xsl:attribute>
                </xsl:if>
                <xsl:attribute name="style:justify-single-word">false</xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="字:缩进">
            <xsl:if test="字:缩进/字:左/字:绝对/@字:值">
                <xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(字:缩进/字:左/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="字:缩进/字:右/字:绝对/@字:值">
                <xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(字:缩进/字:右/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="字:缩进/字:首行/字:绝对/@字:值">
                <xsl:attribute name="fo:text-indent"><xsl:value-of select="concat(字:缩进/字:首行/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="字:行距">
            <xsl:variable name="type">
                <xsl:value-of select="字:行距/@字:类型"/>
            </xsl:variable>
            <xsl:variable name="val">
                <xsl:value-of select="字:行距/@字:值"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$type='fixed'">
                    <xsl:attribute name="fo:line-height"><xsl:value-of select="concat($val,$uofUnit)"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="$type='multi-lines'">
                    <xsl:attribute name="fo:line-height"><xsl:value-of select="concat($val * 100,'%')"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="$type='at-least'">
                    <xsl:attribute name="style:line-height-at-least"><xsl:value-of select="concat($val,$uofUnit)"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="$type='line-space'">
                    <xsl:attribute name="style:line-spacing"><xsl:value-of select="concat($val,$uofUnit)"/></xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="字:段间距">
            <xsl:if test="字:段间距/字:段前距/字:绝对值/@字:值">
                <xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(字:段间距/字:段前距/字:绝对值/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="字:段间距/字:段后距/字:绝对值/@字:值">
                <xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(字:段间距/字:段后距/字:绝对值/@字:值,$uofUnit)"/></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="字:孤行控制">
            <xsl:attribute name="fo:orphans"><xsl:value-of select="字:孤行控制"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:寡行控制">
            <xsl:attribute name="fo:widows"><xsl:value-of select="字:寡行控制"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:段中不分页">
            <xsl:attribute name="fo:keep-together"><xsl:choose><xsl:when test="字:段中不分页/@字:值='1' or 字:段中不分页/@字:值='true'">always</xsl:when><xsl:otherwise>auto</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:与下段同页">
            <xsl:attribute name="fo:keep-with-next"><xsl:choose><xsl:when test="字:与下段同页/@字:值='1' or 字:与下段同页/@字:值='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:for-each select="字:边框">
            <xsl:call-template name="uof:边框"/>
        </xsl:for-each>
        <xsl:for-each select="字:填充">
            <xsl:call-template name="uof:填充"/>
        </xsl:for-each>
        <xsl:if test="字:对齐网格">
            <xsl:attribute name="style:snap-to-layout-grid"><xsl:choose><xsl:when test="字:对齐网格/@字:值='1' or 字:对齐网格/@字:值='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:取消断字">
            <xsl:attribute name="fo:hyphenation-ladder-count">no-limit</xsl:attribute>
            <xsl:attribute name="fo:hyphenation-remain-char-count">2</xsl:attribute>
            <xsl:attribute name="fo:hyphenation-push-char-count">2</xsl:attribute>
            <xsl:attribute name="fo:hyphenate"><xsl:choose><xsl:when test="字:取消断字/@字:值='1' or 字:取消断字/@字:值='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:取消行号">
            <xsl:attribute name="text:number-lines"><xsl:choose><xsl:when test="字:取消行号/@字:值='1' or 字:取消行号/@字:值='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:行首尾标点控制">
            <xsl:attribute name="style:punctuation-wrap"><xsl:choose><xsl:when test="字:行首尾标点控制/@字:值='1' or 字:行首尾标点控制/@字:值='true'">hanging</xsl:when><xsl:otherwise>simple</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:是否行首标点压缩/@字:值='true'">
            <xsl:attribute name="style:punctuation-compress">false</xsl:attribute>
        </xsl:if>
        <xsl:if test="字:中文习惯首尾字符">
            <xsl:attribute name="style:line-break"><xsl:choose><xsl:when test="字:中文习惯首尾字符/@字:值='1' or 字:中文习惯首尾字符/@字:值='true'">strict</xsl:when><xsl:otherwise>normal</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:自动调整中英文字符间距 or 字:自动调整中文与数字间距">
            <xsl:attribute name="style:text-autospace"><xsl:choose><xsl:when test="字:自动调整中英文字符间距/@字:值='1' or 字:自动调整中文与数字间距/@字:值='1'or 字:自动调整中英文字符间距/@字:值='true' or 字:自动调整中文与数字间距/@字:值='true'">ideograph-alpha</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
        </xsl:if>
        <xsl:if test="字:首字下沉">
            <xsl:element name="style:drop-cap">
                <xsl:if test="字:首字下沉/@字:行数">
                    <xsl:attribute name="style:lines"><xsl:value-of select="字:首字下沉/@字:行数"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="字:首字下沉/@字:间距">
                    <xsl:attribute name="style:distance"><xsl:value-of select="concat(字:首字下沉/@字:间距,$uofUnit)"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="字:首字下沉/@字:字体引用">
                    <xsl:attribute name="style:style-name"><xsl:value-of select="字:首字下沉/@字:字体引用"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="字:首字下沉/@字:字符数">
                    <xsl:attribute name="style:length"><xsl:choose><xsl:when test="字:首字下沉/@字:字符数='1'">word</xsl:when><xsl:otherwise><xsl:value-of select="字:首字下沉/@字:字符数"/></xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="多个句">
        <xsl:call-template name="单个或者没有句"/>
    </xsl:template>
    <xsl:template name="jibianhao">
        <xsl:param name="biaoshifu"/>
        <xsl:element name="text:list-level-style-number">
            <xsl:variable name="currlevel" select="number(@字:级别值) + 1"/>
            <xsl:attribute name="text:level"><xsl:value-of select="$currlevel"/></xsl:attribute>
            <xsl:attribute name="text:style-name">Numbering Symbols</xsl:attribute>
            <xsl:if test="@字:尾随字符">
                <xsl:attribute name="style:num-suffix"><xsl:choose><xsl:when test="@字:尾随字符='space'"><xsl:value-of select="' ' "/></xsl:when><xsl:when test="@字:尾随字符='tab'"><xsl:value-of select="'  '"/></xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:if>
            <xsl:if test="字:符号字体">
                <xsl:variable name="Font-ID">
                    <xsl:value-of select="字:符号字体/@字:式样引用"/>
                </xsl:variable>
                <xsl:attribute name="text:style-name"><xsl:value-of select="$Font-ID"/></xsl:attribute>
            </xsl:if>
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
                <xsl:variable name="last" select="substring-after(字:编号格式表示,concat('%',$currlevel))"/>
                <xsl:variable name="first">
                    <xsl:variable name="aa" select="substring-before(字:编号格式表示,concat('%',$currlevel))"/>
                    <xsl:choose>
                        <xsl:when test="not(substring-after($aa,'%'))">
                            <xsl:value-of select="$aa"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="$first!=''">
                    <xsl:attribute name="style:num-prefix"><xsl:value-of select="$first"/></xsl:attribute>
                </xsl:if>
                <xsl:if test="$last!=''">
                    <xsl:attribute name="style:num-suffix"><xsl:value-of select="$last"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="bianhaogeshi">
                    <xsl:with-param name="biaoshi">
                        <xsl:value-of select="字:编号格式表示"/>
                    </xsl:with-param>
                    <xsl:with-param name="jibie">
                        <xsl:value-of select="1"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <xsl:element name="style:text-properties">
                <xsl:call-template name="suojinleixing"/>
                <xsl:if test="@字:编号对齐方式">
                    <xsl:attribute name="fo:text-align"><xsl:variable name="aa"><xsl:value-of select="@字:编号对齐方式"/></xsl:variable><xsl:choose><xsl:when test="$aa='center' ">center</xsl:when><xsl:when test="$aa='right' ">end</xsl:when><xsl:otherwise>left</xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
                <xsl:if test="字:符号字体">
                    <xsl:if test="字:符号字体/@字:式样引用">
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
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="bianhaogeshi">
        <xsl:param name="biaoshi"/>
        <xsl:param name="jibie"/>
        <xsl:variable name="bb">
            <xsl:value-of select="substring-after($biaoshi,'%')"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="substring-after($bb,'%')">
                <xsl:call-template name="bianhaogeshi">
                    <xsl:with-param name="biaoshi" select="$bb"/>
                    <xsl:with-param name="jibie" select="$jibie +1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="not($jibie=1)">
                    <xsl:attribute name="text:display-levels"><xsl:value-of select="$jibie"/></xsl:attribute>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="xiangmufuhao">
        <xsl:param name="biaoshifu"/>
        <xsl:variable name="currlevel" select="number(@字:级别值) + 1"/>
        <xsl:element name="text:list-level-style-bullet">
            <xsl:attribute name="text:level"><xsl:value-of select="$currlevel"/></xsl:attribute>
            <xsl:attribute name="text:style-name"><xsl:value-of select="../@字:名称"/></xsl:attribute>
            <xsl:attribute name="style:num-suffix"><xsl:value-of select="substring-after(字:编号格式表示,'%1')"/></xsl:attribute>
            <xsl:attribute name="text:bullet-char"><xsl:value-of select="字:项目符号"/></xsl:attribute>
            <xsl:element name="style:text-properties">
                <xsl:if test="字:符号字体">
                    <xsl:variable name="Font-ID">
                        <xsl:value-of select="字:符号字体/@字:式样引用"/>
                    </xsl:variable>
                    <xsl:for-each select="/uof:UOF/uof:式样集/uof:句式样">
                        <xsl:if test="@字:标识符=$Font-ID">
                            <xsl:if test="字:字体/@字:中文字体引用">
                                <xsl:attribute name="svg:font-family"><xsl:value-of select="字:字体/@字:中文字体引用"/></xsl:attribute>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="字:项目符号">
                    <xsl:attribute name="fo:font-family"><xsl:value-of select="'WingDings'"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="suojinleixing"/>
                <xsl:if test="@字:编号对齐方式">
                    <xsl:attribute name="fo:text-align"><xsl:variable name="aa"><xsl:value-of select="@字:编号对齐方式"/></xsl:variable><xsl:choose><xsl:when test="$aa='center' ">center</xsl:when><xsl:when test="$aa='right' ">end</xsl:when><xsl:otherwise>left</xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="imagefuhao">
        <xsl:param name="biaoshifu"/>
        <xsl:variable name="currlevel" select="number(@字:级别值) + 1"/>
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
                                <xsl:attribute name="svg:font-family"><xsl:value-of select="字:字体/@字:中文字体引用"/></xsl:attribute>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                <xsl:call-template name="suojinleixing"/>
                <xsl:if test="@字:编号对齐方式">
                    <xsl:attribute name="fo:text-align"><xsl:variable name="aa"><xsl:value-of select="@字:编号对齐方式"/></xsl:variable><xsl:choose><xsl:when test="$aa='center' ">center</xsl:when><xsl:when test="$aa='right' ">end</xsl:when><xsl:otherwise>left</xsl:otherwise></xsl:choose></xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="ootab">
        <xsl:element name="style:tab-stops">
            <xsl:for-each select="字:段落属性/字:制表位设置/字:制表位 | 字:制表位设置/字:制表位">
                <xsl:element name="style:tab-stop">
                    <xsl:attribute name="style:position"><xsl:value-of select="concat(@字:位置,$uofUnit)"/></xsl:attribute>
                    <xsl:attribute name="style:type"><xsl:choose><xsl:when test="@字:类型='decimal'">char</xsl:when><xsl:when test="@字:类型='left' or @字:类型='right' or @字:类型='center'"><xsl:value-of select="@字:类型"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:attribute>
                    <xsl:if test="@字:制表位字符">
                        <xsl:attribute name="style:leader-text"><xsl:value-of select="@字:制表位字符"/></xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="style:leader-style"><xsl:value-of select="@字:前导符"/></xsl:attribute>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match="字:段落[字:段落属性[字:自动编号信息]]">
        <xsl:call-template name="编号解析">
        </xsl:call-template>
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
        <xsl:variable name="currlistlvl" select="字:段落属性/字:自动编号信息/@字:编号级别 + 1"/>
        <xsl:variable name="firstoccur" select="/descendant::字:段落属性[字:自动编号信息/@字:编号引用 = $currlistid][1]"/>
        <xsl:element name="text:list">
            <xsl:attribute name="text:style-name">List<xsl:value-of select="count($firstoccur/preceding::字:自动编号信息)"/></xsl:attribute>
            <xsl:attribute name="text:continue-numbering"><xsl:choose><xsl:when test="字:段落属性/字:自动编号信息/@字:重新编号='false'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
            <xsl:if test="字:段落属性/字:自动编号信息/@字:重新编号">
                <xsl:attribute name="text:continue-numbering"><xsl:choose><xsl:when test="字:段落属性/字:自动编号信息/@字:重新编号='1'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:if>
            <xsl:element name="text:list-item">
                <xsl:call-template name="ordered-levels">
                    <xsl:with-param name="level" select="$currlistlvl - 1"/>
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
                            <xsl:with-param name="level" select="$level - 1"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="无序">
        <xsl:variable name="currlistid" select="字:段落属性/字:自动编号信息/@字:编号引用"/>
        <xsl:variable name="currlistlvl" select="字:段落属性/字:自动编号信息/@字:编号级别 + 1"/>
        <xsl:variable name="firstoccur" select="/descendant::字:段落属性[字:自动编号信息/@字:编号引用 = $currlistid][1]"/>
        <xsl:element name="text:list">
            <xsl:attribute name="text:style-name">List<xsl:value-of select="count($firstoccur/preceding::字:自动编号信息)"/></xsl:attribute>
            <xsl:element name="text:list-item">
                <xsl:call-template name="unordered-levels">
                    <xsl:with-param name="level" select="$currlistlvl - 1"/>
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
                            <xsl:with-param name="level" select="$level - 1"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
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
    <xsl:template name="convert2cm">
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
    </xsl:template>
    <xsl:template name="uof:通用边框">
        <xsl:param name="lineType"/>
        <xsl:param name="width"/>
        <xsl:param name="color"/>
        <xsl:choose>
            <xsl:when test="$lineType='none'">none</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$width"/>
                <xsl:choose>
                    <xsl:when test="$lineType='single'">solid </xsl:when>
                    <xsl:when test="$lineType='double'">double </xsl:when>
                    <xsl:otherwise>solid </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="$color='auto' or $color='none' or $color=''">#808080</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$color"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="uof:边框">
        <xsl:if test="uof:上">
            <xsl:variable name="type" select="uof:上/@uof:类型"/>
            <xsl:variable name="size" select="concat(uof:上/@uof:宽度,$uofUnit,' ')"/>
            <xsl:variable name="clr" select="uof:上/@uof:颜色"/>
            <xsl:attribute name="fo:border-top"><xsl:call-template name="uof:通用边框"><xsl:with-param name="lineType" select="$type"/><xsl:with-param name="width" select="$size"/><xsl:with-param name="color" select="$clr"/></xsl:call-template></xsl:attribute>
            <xsl:if test="uof:上/@uof:线宽度">
                <xsl:attribute name="style:border-line-width-top"><xsl:value-of select="uof:上/@uof:线宽度"/></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="uof:下">
            <xsl:variable name="type" select="uof:下/@uof:类型"/>
            <xsl:variable name="size" select="concat(uof:下/@uof:宽度,$uofUnit,' ')"/>
            <xsl:variable name="clr" select="uof:下/@uof:颜色"/>
            <xsl:attribute name="fo:border-bottom"><xsl:call-template name="uof:通用边框"><xsl:with-param name="lineType" select="$type"/><xsl:with-param name="width" select="$size"/><xsl:with-param name="color" select="$clr"/></xsl:call-template></xsl:attribute>
            <xsl:if test="uof:下/@uof:线宽度">
                <xsl:attribute name="style:border-line-width-bottom"><xsl:value-of select="uof:下/@uof:线宽度"/></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="uof:左">
            <xsl:variable name="type" select="uof:左/@uof:类型"/>
            <xsl:variable name="size" select="concat(uof:左/@uof:宽度,$uofUnit,' ')"/>
            <xsl:variable name="clr" select="uof:左/@uof:颜色"/>
            <xsl:attribute name="fo:border-left"><xsl:call-template name="uof:通用边框"><xsl:with-param name="lineType" select="$type"/><xsl:with-param name="width" select="$size"/><xsl:with-param name="color" select="$clr"/></xsl:call-template></xsl:attribute>
            <xsl:if test="uof:左/@uof:线宽度">
                <xsl:attribute name="style:border-line-width-left"><xsl:value-of select="uof:左/@uof:线宽度"/></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="uof:右">
            <xsl:variable name="type" select="uof:右/@uof:类型"/>
            <xsl:variable name="size" select="concat(uof:右/@uof:宽度,$uofUnit,' ')"/>
            <xsl:variable name="clr" select="uof:右/@uof:颜色"/>
            <xsl:attribute name="fo:border-right"><xsl:call-template name="uof:通用边框"><xsl:with-param name="lineType" select="$type"/><xsl:with-param name="width" select="$size"/><xsl:with-param name="color" select="$clr"/></xsl:call-template></xsl:attribute>
            <xsl:if test="uof:右/@uof:线宽度">
                <xsl:attribute name="style:border-line-width-right"><xsl:value-of select="uof:右/@uof:线宽度"/></xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="uof:上/@uof:阴影='true'or uof:上/@uof:阴影='1'">
            <xsl:if test="uof:左/@uof:阴影='true'or uof:左/@uof:阴影='1'">
                <xsl:attribute name="style:shadow">#808080 -0.18cm -0.18cm</xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="uof:上/@uof:阴影='true'or uof:上/@uof:阴影='1'">
            <xsl:if test="uof:右/@uof:阴影='true'or uof:右/@uof:阴影='1'">
                <xsl:attribute name="style:shadow">#808080 0.18cm -0.18cm</xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="uof:下/@uof:阴影='true'or uof:下/@uof:阴影='1'">
            <xsl:if test="uof:左/@uof:阴影='true'or uof:左/@uof:阴影='1'">
                <xsl:attribute name="style:shadow">#808080 -0.18cm 0.18cm</xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="uof:下/@uof:阴影='true'or uof:下/@uof:阴影='1'">
            <xsl:if test="uof:右/@uof:阴影='true'or uof:右/@uof:阴影='1'">
                <xsl:attribute name="style:shadow">#808080 0.18cm 0.18cm</xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="uof:上/@uof:边距">
            <xsl:attribute name="fo:padding-top"><xsl:value-of select="concat(uof:上/@uof:边距,$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="uof:下/@uof:边距">
            <xsl:attribute name="fo:padding-bottom"><xsl:value-of select="concat(uof:下/@uof:边距,$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="uof:左/@uof:边距">
            <xsl:attribute name="fo:padding-left"><xsl:value-of select="concat(uof:左/@uof:边距,$uofUnit)"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="uof:右/@uof:边距">
            <xsl:attribute name="fo:padding-right"><xsl:value-of select="concat(uof:右/@uof:边距,$uofUnit)"/></xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template name="uof:填充">
        <xsl:choose>
            <xsl:when test="图:颜色">
                <xsl:attribute name="fo:background-color"><xsl:choose><xsl:when test="图:颜色"><xsl:value-of select="图:颜色"/></xsl:when><xsl:otherwise>transparent</xsl:otherwise></xsl:choose></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(图:图案/@图:前景色,'#')">
                <xsl:attribute name="fo:text-background-color"><xsl:value-of select="图:图案/@图:前景色"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="图:图案/@图:背景色">
                <xsl:attribute name="fo:background-color"><xsl:value-of select="图:图案/@图:背景色"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <xsl:if test="图:图片">
            <xsl:element name="style:background-image">
                <xsl:variable name="gid">
                    <xsl:value-of select="图:图片/@图:图形引用"/>
                </xsl:variable>
                <xsl:if test="图:图片/@图:位置 and not(图:图片/@图:位置='tile')">
                    <xsl:attribute name="style:repeat"><xsl:choose><xsl:when test="图:图片/@图:位置='stretch'">stretch</xsl:when><xsl:when test="图:图片/@图:位置='center'">no-repeat</xsl:when></xsl:choose></xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$gid]/uof:数据">
                        <xsl:element name="office:binary-data">
                            <xsl:value-of select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$gid]/uof:数据"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="xlink:href"><xsl:value-of select="/uof:UOF/uof:对象集/uof:其他对象[@uof:标识符=$gid]/uof:路径"/></xsl:attribute>
                        <xsl:attribute name="xlink:type">simple</xsl:attribute>
                        <xsl:attribute name="xlink:actuate">onLoad</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="日期域">
        <xsl:if test="following-sibling::字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(following-sibling::字:域代码/字:段落/字:句/字:文本串,'\@ ')"/>
            <xsl:variable name="datestr">
                <xsl:choose>
                    <xsl:when test="contains($date0,'\*')">
                        <xsl:value-of select="string(substring-before($date0,'\*'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$date0"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="zydate">
                <xsl:with-param name="str1" select="substring($datestr,2,string-length($datestr)-2)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="zydate">
        <xsl:param name="str1"/>
        <xsl:choose>
            <xsl:when test="substring($str1,1,5)='am/pm'">
                <xsl:variable name="str1-before" select="substring($str1,1,5)"/>
                <xsl:variable name="str1-after" select="substring($str1,6)"/>
                <number:am-pm/>
                <xsl:if test="not($str1-after)=''">
                    <number:text>
                        <xsl:value-of select="substring($str1-after,1,1)"/>
                    </number:text>
                </xsl:if>
                <xsl:if test="string-length($str1-after)&gt;1">
                    <xsl:call-template name="zytime">
                        <xsl:with-param name="str1" select="substring($str1-after,2)"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>

        <xsl:choose>
            <xsl:when test="substring($str1,1,4)='yyyy'">
                <xsl:variable name="str1-before" select="substring($str1,1,4)"/>
                <xsl:variable name="str1-after" select="substring($str1,5)"/>
                <number:year number:style="long"/>
                <number:text>
                    <xsl:value-of select="substring($str1-after,1,1)"/>
                </number:text>
                <xsl:if test="string-length($str1-after)&gt;1">
                    <xsl:call-template name="zydate">
                        <xsl:with-param name="str1" select="substring($str1-after,2)"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="substring($str1,1,1)=substring($str1,2,1) and substring($str1,2,1) !=substring($str1,3,1) ">
                        <xsl:variable name="str1-before" select="substring($str1,1,2)"/>
                        <xsl:variable name="str1-after" select="substring($str1,3)"/>
                        <xsl:if test="substring($str1,1,1)='y'">
                            <number:year/>
                        </xsl:if>
                        <xsl:if test="substring($str1,1,1)='M'">
                            <number:month number:style="long"/>
                        </xsl:if>
                        <xsl:if test="substring($str1,1,1)='d'">
                            <number:day number:style="long"/>
                        </xsl:if>
                        <xsl:if test="substring($str1,1,1)='h'">
                            <number:hours number:style="long"/>
                        </xsl:if>
                        <xsl:if test="substring($str1,1,1)='m'">
                            <number:minutes number:style="long"/>
                        </xsl:if>
                        <xsl:if test="substring($str1,1,1)='s'">
                            <number:seconds number:style="long"/>
                        </xsl:if>
                        <xsl:if test="substring($str1,1,1)='W'">
                            <number:week-of-year number:style="long"/>
                        </xsl:if>
                        <number:text>
                            <xsl:value-of select="substring($str1-after,1,1)"/>
                        </number:text>
                        <xsl:if test="string-length($str1-after)&gt;1">
                            <xsl:call-template name="zydate">
                                <xsl:with-param name="str1" select="substring($str1-after,2)"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="substring($str1,1,1)='M'or substring($str1,1,1)='d'or substring($str1,1,1)='h'or substring($str1,1,1)='m'or substring($str1,1,1)='s'">
                            <xsl:variable name="str1-after" select="substring($str1,2)"/>
                            <xsl:variable name="str1-before" select="substring($str1,1,1)"/>
                            <xsl:if test="substring($str1,1,1)='M'">
                                <number:month/>
                                <number:text>
                                    <xsl:value-of select="substring($str1-after,1,1)"/>
                                </number:text>
                            </xsl:if>
                            <xsl:if test="substring($str1,1,1)='d'">
                                <number:day/>
                                <number:text>
                                    <xsl:value-of select="substring($str1-after,1,1)"/>
                                </number:text>
                            </xsl:if>
                            <xsl:if test="substring($str1,1,1)='h'">
                                <number:hours/>
                                <number:text>
                                    <xsl:value-of select="substring($str1-after,1,1)"/>
                                </number:text>
                            </xsl:if>
                            <xsl:if test="substring($str1,1,1)='m'">
                                <number:minutes/>
                                <number:text>
                                    <xsl:value-of select="substring($str1-after,1,1)"/>
                                </number:text>
                            </xsl:if>
                            <xsl:if test="substring($str1,1,1)='s'">
                                <number:seconds/>
                                <number:text>
                                    <xsl:value-of select="substring($str1-after,1,1)"/>
                                </number:text>
                            </xsl:if>
                            <xsl:if test="string-length($str1-after)&gt;1">
                                <xsl:call-template name="zydate">
                                    <xsl:with-param name="str1" select="substring($str1-after,2)"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="contains(substring($str1,1,3),'Q' )">
                            <xsl:choose>
                                <xsl:when test="substring($str1,1,1)='Q'">
                                    <xsl:variable name="str1-before" select="substring($str1,1,2)"/>
                                    <xsl:variable name="str1-after" select="substring($str1,3)"/>
                                    <number:quarter/>
                                    <number:text>
                                        <xsl:value-of select="substring($str1-after,1,1)"/>
                                    </number:text>
                                    <xsl:if test="string-length($str1-after)&gt;1">
                                        <xsl:call-template name="zydate">
                                            <xsl:with-param name="str1" select="substring($str1-after,2)"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="str1-before" select="substring($str1,1,5)"/>
                                    <xsl:variable name="str1-after" select="substring($str1,6)"/>
                                    <number:quarter number:style="long"/>
                                    <number:text>
                                        <xsl:value-of select="substring($str1-after,1,1)"/>
                                    </number:text>
                                    <xsl:if test="string-length($str1-after)&gt;1">
                                        <xsl:call-template name="zydate">
                                            <xsl:with-param name="str1" select="substring($str1-after,2)"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="contains(substring(normalize-space($str1),1,3),'W' )">
                            <xsl:variable name="str1-before" select="substring(normalize-space($str1),1,3)"/>
                            <xsl:variable name="str1-after" select="substring(normalize-space($str1),4)"/>
                            <number:day-of-week number:style="long"/>
                            <number:text>
                                <xsl:value-of select="substring($str1-after,1,1)"/>
                            </number:text>
                            <xsl:if test="string-length($str1-after)&gt;1">
                                <xsl:call-template name="zydate">
                                    <xsl:with-param name="str1" select="substring($str1-after,2)"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="contains(substring($str1,1,3),'NN' ) and substring($str1,1,1)!='NN' ">
                            <xsl:variable name="str1-before" select="substring($str1,1,3)"/>
                            <xsl:variable name="str1-after" select="substring($str1,4)"/>
                            <number:text>第</number:text>
                            <number:week-of-year/>
                            <number:text>周</number:text>
                            <xsl:if test="string-length($str1-after)&gt;1">
                                <xsl:call-template name="zydate">
                                    <xsl:with-param name="str1" select="substring($str1-after,2)"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="时间域">
        <xsl:if test="following-sibling::字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(following-sibling::字:域代码/字:段落/字:句/字:文本串,'\@ ')"/>
            <xsl:variable name="datestr" select="$date0"/>
            <xsl:call-template name="zytime">
                <xsl:with-param name="str1" select="substring($datestr,2,string-length($datestr)-2)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="zytime">
        <xsl:param name="str1"/>
        <xsl:choose>
            <xsl:when test="substring($str1,1,5)='am/pm'">
                <xsl:variable name="str1-before" select="substring($str1,1,5)"/>
                <xsl:variable name="str1-after" select="substring($str1,6)"/>
                <number:am-pm/>
                <xsl:if test="not($str1-after)=''">
                    <number:text>
                        <xsl:value-of select="substring($str1-after,1,1)"/>
                    </number:text>
                </xsl:if>
                <xsl:if test="string-length($str1-after)&gt;1">
                    <xsl:call-template name="zytime">
                        <xsl:with-param name="str1" select="substring($str1-after,2)"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="substring($str1,1,1)=substring($str1,2,1) and substring($str1,2,1) !=substring($str1,3,1) ">
                        <xsl:variable name="str1-before" select="substring($str1,1,2)"/>
                        <xsl:variable name="str1-after" select="substring($str1,3)"/>
                        <xsl:if test="substring($str1,1,1)='H' or substring($str1,1,1)='h'">
                            <number:hours number:style="long"/>
                        </xsl:if>
                        <xsl:if test="substring($str1,1,1)='M' or substring($str1,1,1)='m'">
                            <number:minutes number:style="long"/>
                        </xsl:if>
                        <xsl:if test="substring($str1,1,1)='S' or substring($str1,1,1)='s'">
                            <number:seconds number:style="long"/>
                        </xsl:if>
                        <number:text>
                            <xsl:value-of select="substring($str1-after,1,1)"/>
                        </number:text>
                        <xsl:if test="string-length($str1-after)&gt;1">
                            <xsl:call-template name="zytime">
                                <xsl:with-param name="str1" select="substring($str1-after,2)"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="substring($str1,1,1)='H'or substring($str1,1,1)='M'or substring($str1,1,1)='S'or substring($str1,1,1)='h' or substring($str1,1,1)='m' or  substring($str1,1,1)='s'">
                            <xsl:variable name="str1-after" select="substring($str1,2)"/>
                            <xsl:variable name="str1-before" select="substring($str1,1,1)"/>
                            <xsl:if test="substring($str1,1,1)='H' or substring($str1,1,1)='h'">
                                <number:hours/>
                                <number:text>
                                    <xsl:value-of select="substring($str1-after,1,1)"/>
                                </number:text>
                            </xsl:if>
                            <xsl:if test="substring($str1,1,1)='M' or substring($str1,1,1)='m'">
                                <number:minutes/>
                                <number:text>
                                    <xsl:value-of select="substring($str1-after,1,1)"/>
                                </number:text>
                            </xsl:if>
                            <xsl:if test="substring($str1,1,1)='S' or substring($str1,1,1)='s'">
                                <number:seconds/>
                                <number:text>
                                    <xsl:value-of select="substring($str1-after,1,1)"/>
                                </number:text>
                            </xsl:if>
                            <xsl:if test="string-length($str1-after)&gt;1">
                                <xsl:call-template name="zytime">
                                    <xsl:with-param name="str1" select="substring($str1-after,2)"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="oo数字格式域开关">
        <xsl:param name="oo_format"/>
        <xsl:choose>
            <xsl:when test="$oo_format='Arabic'">1</xsl:when>
            <xsl:when test="$oo_format='ROMAN'">I</xsl:when>
            <xsl:when test="$oo_format='roman'">i</xsl:when>
            <xsl:when test="$oo_format='ALPHABETIC'">A</xsl:when>
            <xsl:when test="$oo_format='alphabetic'">a</xsl:when>
            <xsl:when test="$oo_format='GB1'">１, ２, ３, ...</xsl:when>
            <xsl:when test="$oo_format='GB3'">①, ②, ③, ...</xsl:when>
            <xsl:when test="$oo_format='CHINESENUM3'">一, 二, 三, ...</xsl:when>
            <xsl:when test="$oo_format='CHINESENUM2'">壹, 贰, 叁, ...</xsl:when>
            <xsl:when test="$oo_format='ZODIAC1'">甲, 乙, 丙, ...</xsl:when>
            <xsl:when test="$oo_format='ZODIAC2'">子, 丑, 寅, ...</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="题注">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串 or 字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="aa" select="substring-after(../字:域代码/字:段落/字:句/字:文本串,'\f ')"/>
            <xsl:variable name="ooow" select="substring-after($aa,'ooow:') "/>
            <xsl:variable name="as" select="substring-before(../字:域代码/字:段落/字:句/字:文本串,' \* ')"/>
            <xsl:variable name="ad">
                <xsl:value-of select="substring-after($as,'SEQ ') "/>
            </xsl:variable>
            <xsl:variable name="num">
                <xsl:value-of select="substring-after(substring-before(../字:域代码/字:段落/字:句/字:文本串,' \f'),'\* ')"/>
            </xsl:variable>
            <xsl:variable name="fmt">
                <xsl:call-template name="oo数字格式域开关">
                    <xsl:with-param name="oo_format" select="$num"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:element name="text:sequence">
                <xsl:attribute name="text:name"><xsl:choose><xsl:when test="$ad='表格'">Table</xsl:when><xsl:when test="$ad='图表'">Drawing</xsl:when><xsl:otherwise><xsl:value-of select="$ad"/></xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="text:formula"><xsl:choose><xsl:when test="contains($aa,'ooow:')"><xsl:value-of select="$ooow"/></xsl:when><xsl:when test="contains($as,'表格')"><xsl:value-of select="concat('Table','+',$fmt)"/></xsl:when><xsl:when test="contains($as,'图表')"><xsl:value-of select="concat('Drawing','+',$fmt)"/></xsl:when><xsl:otherwise><xsl:value-of select="$aa"/></xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:attribute name="style:num-format"><xsl:value-of select="$fmt"/></xsl:attribute>
                <xsl:value-of select="following-sibling::字:句/字:文本串"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="页码域">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串 or 字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(../字:域代码/字:段落/字:句/字:文本串,' \* ')"/>
            <xsl:variable name="datestr" select="substring-before(../字:域代码/字:段落/字:句/字:文本串,'\* ')"/>
            <xsl:variable name="fmt">
                <xsl:call-template name="oo数字格式域开关">
                    <xsl:with-param name="oo_format" select="$date0"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:element name="text:page-number">
                <xsl:attribute name="style:num-format"><xsl:value-of select="$fmt"/></xsl:attribute>
                <xsl:attribute name="text:select-page">current</xsl:attribute>
                <xsl:value-of select="following-sibling::字:句/字:文本串"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="页数域">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(../字:域代码/字:段落/字:句/字:文本串,' \* ')"/>
            <xsl:variable name="datestr" select="substring-before(../字:域代码/字:段落/字:句/字:文本串,'\* ')"/>
            <xsl:variable name="fmt">
                <xsl:call-template name="oo数字格式域开关">
                    <xsl:with-param name="oo_format" select="substring-before($date0,' \*')"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:element name="text:page-count">
                <xsl:attribute name="style:num-format"><xsl:value-of select="$fmt"/></xsl:attribute>
                <xsl:value-of select="following-sibling::字:句/字:文本串"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="作者域">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(../字:域代码/字:段落/字:句/字:文本串,' \* ')"/>
            <xsl:variable name="datestr" select="substring-before(../字:域代码/字:段落/字:句/字:文本串,'\* ')"/>
            <xsl:element name="text:initial-creator">
                <xsl:value-of select="following-sibling::字:句/字:文本串"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="用户域">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(../字:域代码/字:段落/字:句/字:文本串,' \* ')"/>
            <xsl:variable name="datestr" select="substring-before(../字:域代码/字:段落/字:句/字:文本串,'\* ')"/>
            <xsl:element name="text:author-name">
                <xsl:value-of select="following-sibling::字:句/字:文本串"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="缩写域">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(../字:域代码/字:段落/字:句/字:文本串,' \* ')"/>
            <xsl:variable name="datestr" select="substring-before(../字:域代码/字:段落/字:句/字:文本串,'\* ')"/>
            <xsl:element name="text:author-initials">
                <xsl:value-of select="following-sibling::字:句/字:文本串"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="标题域">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(../字:域代码/字:段落/字:句/字:文本串,' \* ')"/>
            <xsl:variable name="datestr" select="substring-before(../字:域代码/字:段落/字:句/字:文本串,'\* ')"/>
            <xsl:element name="text:title">
                <xsl:value-of select="following-sibling::字:句/字:文本串"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="主题域">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(../字:域代码/字:段落/字:句/字:文本串,' \* ')"/>
            <xsl:variable name="datestr" select="substring-before(../字:域代码/字:段落/字:句/字:文本串,'\* ')"/>
            <xsl:element name="text:subject">
                <xsl:value-of select="following-sibling::字:句/字:文本串"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="文件名">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串">
            <xsl:element name="text:file-name">
                <xsl:variable name="string">
                    <xsl:value-of select="../字:域代码/字:段落/字:句/字:文本串"/>
                </xsl:variable>
                <xsl:attribute name="text:display"><xsl:choose><xsl:when test="contains($string,' \p')">full</xsl:when><xsl:otherwise>name-and-extension</xsl:otherwise></xsl:choose></xsl:attribute>
                <xsl:value-of select="following-sibling::字:句/字:文本串"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="编辑时间">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(following-sibling::字:域代码/字:段落/字:句/字:文本串,'\@ ')"/>
            <xsl:variable name="datestr" select="$date0"/>
            <xsl:call-template name="zytime">
                <xsl:with-param name="str1" select="substring($datestr,2,string-length($datestr)-2)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="创建时间">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(following-sibling::字:域代码/字:段落/字:句/字:文本串,'\@ ')"/>
            <xsl:variable name="datestr" select="$date0"/>
            <xsl:call-template name="zytime">
                <xsl:with-param name="str1" select="substring($datestr,2,string-length($datestr)-2)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="字符数">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(../字:域代码/字:段落/字:句/字:文本串,' \* ')"/>
            <xsl:variable name="datestr" select="substring-before(../字:域代码/字:段落/字:句/字:文本串,'\* ')"/>
            <xsl:variable name="fmt">
                <xsl:call-template name="oo数字格式域开关">
                    <xsl:with-param name="oo_format" select="substring-before($date0,' \#')"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:element name="text:character-count">
                <xsl:attribute name="style:num-format"><xsl:value-of select="$fmt"/></xsl:attribute>
                <xsl:value-of select="following-sibling::字:句/字:文本串"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:key name="mulu" match="/uof:UOF/uof:式样集/uof:段落式样" use="@字:标识符"/>
    <xsl:template name="索引域">
        <xsl:element name="text:alphabetical-index">
            <xsl:variable name="stylenum">
                <xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:句" format="1"/>
            </xsl:variable>
            <xsl:attribute name="text:style-name"><xsl:value-of select="concat('Sect',$stylenum)"/></xsl:attribute>
            <xsl:variable name="aanum">
                <xsl:number value="0" format="1"/>
            </xsl:variable>
            <xsl:attribute name="text:name"><xsl:value-of select="concat('索引目录',$aanum + 1)"/></xsl:attribute>
            <text:alphabetical-index-source text:main-entry-style-name="Main_index_entry" text:sort-algorithm="pinyin" fo:language="zh" fo:country="CN">
                <text:index-title-template text:style-name="Index_20_Heading">索引目录</text:index-title-template>
                <text:alphabetical-index-entry-template text:outline-level="separator" text:style-name="Index_Separator">
                    <text:index-entry-text/>
                </text:alphabetical-index-entry-template>
                <text:alphabetical-index-entry-template text:outline-level="1" text:style-name="Index_20_1">
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                </text:alphabetical-index-entry-template>
                <text:alphabetical-index-entry-template text:outline-level="2" text:style-name="Index_20_2">
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                </text:alphabetical-index-entry-template>
                <text:alphabetical-index-entry-template text:outline-level="3" text:style-name="Index_20_3">
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                </text:alphabetical-index-entry-template>
            </text:alphabetical-index-source>
            <text:index-body>
                <text:index-title>
                    <xsl:attribute name="text:style-name"><xsl:value-of select="concat('Sect',$stylenum)"/></xsl:attribute>
                    <xsl:attribute name="text:name"><xsl:value-of select="concat('索引目录',$aanum + 1,'_Head')"/></xsl:attribute>
                    <xsl:for-each select="字:域代码/字:段落[position()=2]">
                        <text:p text:style-name="Index_20_Heading">
                            <xsl:apply-templates select=".//字:文本串"/>
                        </text:p>
                    </xsl:for-each>
                </text:index-title>
                <xsl:if test="字:域开始/@字:类型='INDEX'">
                    <xsl:for-each select="字:域代码/字:段落[position()>2]">
                        <xsl:element name="text:p">
                            <xsl:variable name="aa">
                                <xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落[字:段落属性]"/>
                            </xsl:variable>
                            <xsl:attribute name="text:style-name"><xsl:value-of select="concat('P',$aa + 1)"/></xsl:attribute>
                            <xsl:for-each select="字:句">
                                <xsl:apply-templates select="self::node()/*"/>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:if>
            </text:index-body>
        </xsl:element>
    </xsl:template>
    <xsl:template name="目录域">
        <xsl:element name="text:table-of-content">
            <xsl:variable name="stylenum">
                <xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:句" format="1"/>
            </xsl:variable>
            <xsl:attribute name="text:style-name"><xsl:value-of select="concat('Sect',$stylenum)"/></xsl:attribute>
            <xsl:variable name="aanum">
                <xsl:number value="0" format="1"/>
            </xsl:variable>
            <xsl:attribute name="text:name"><xsl:value-of select="concat('内容目录',$aanum + 1)"/></xsl:attribute>
            <text:table-of-content-source text:outline-level="10">
                <text:index-title-template text:style-name="Contents_20_Heading">内容目录</text:index-title-template>
                <text:table-of-content-entry-template text:outline-level="1" text:style-name="Contents 1">
                    <text:index-entry-link-start text:style-name="Index_20_Link"/>
                    <text:index-entry-chapter/>
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                    <text:index-entry-link-end/>
                </text:table-of-content-entry-template>
                <text:table-of-content-entry-template text:outline-level="2" text:style-name="Contents 2">
                    <text:index-entry-link-start text:style-name="Index_20_Link"/>
                    <text:index-entry-chapter/>
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                    <text:index-entry-link-end/>
                </text:table-of-content-entry-template>
                <text:table-of-content-entry-template text:outline-level="3" text:style-name="Contents 3">
                    <text:index-entry-link-start text:style-name="Index_20_Link"/>
                    <text:index-entry-chapter/>
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                    <text:index-entry-link-end/>
                </text:table-of-content-entry-template>
                <text:table-of-content-entry-template text:outline-level="4" text:style-name="Contents 4">
                    <text:index-entry-link-start text:style-name="Index_20_Link"/>
                    <text:index-entry-chapter/>
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                    <text:index-entry-link-end/>
                </text:table-of-content-entry-template>
                <text:table-of-content-entry-template text:outline-level="5" text:style-name="Contents 5">
                    <text:index-entry-link-start text:style-name="Index_20_Link"/>
                    <text:index-entry-chapter/>
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                    <text:index-entry-link-end/>
                </text:table-of-content-entry-template>
                <text:table-of-content-entry-template text:outline-level="6" text:style-name="Contents 6">
                    <text:index-entry-link-start text:style-name="Index_20_Link"/>
                    <text:index-entry-chapter/>
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                    <text:index-entry-link-end/>
                </text:table-of-content-entry-template>
                <text:table-of-content-entry-template text:outline-level="7" text:style-name="Contents 7">
                    <text:index-entry-link-start text:style-name="Index_20_Link"/>
                    <text:index-entry-chapter/>
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                    <text:index-entry-link-end/>
                </text:table-of-content-entry-template>
                <text:table-of-content-entry-template text:outline-level="8" text:style-name="Contents 8">
                    <text:index-entry-link-start text:style-name="Index_20_Link"/>
                    <text:index-entry-chapter/>
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                    <text:index-entry-link-end/>
                </text:table-of-content-entry-template>
                <text:table-of-content-entry-template text:outline-level="9" text:style-name="Contents 9">
                    <text:index-entry-link-start text:style-name="Index_20_Link"/>
                    <text:index-entry-chapter/>
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                    <text:index-entry-link-end/>
                </text:table-of-content-entry-template>
                <text:table-of-content-entry-template text:outline-level="10" text:style-name="Contents 10">
                    <text:index-entry-link-start text:style-name="Index_20_Link"/>
                    <text:index-entry-chapter/>
                    <text:index-entry-text/>
                    <text:index-entry-tab-stop style:type="right" style:leader-char="."/>
                    <text:index-entry-page-number/>
                    <text:index-entry-link-end/>
                </text:table-of-content-entry-template>
            </text:table-of-content-source>
            <text:index-body>
                <text:index-title>
                    <xsl:attribute name="text:style-name"><xsl:value-of select="concat('Sect',$stylenum)"/></xsl:attribute>
                    <xsl:attribute name="text:name"><xsl:value-of select="concat('内容目录',$aanum + 1,'_Head')"/></xsl:attribute>
                    <xsl:for-each select="字:域代码/字:段落[position()=2]">
                        <text:p text:style-name="Contents_20_Heading">
                            <xsl:apply-templates select=".//字:文本串"/>
                        </text:p>
                    </xsl:for-each>
                </text:index-title>
                <xsl:if test="字:域开始/@字:类型='REF'">
                    <xsl:for-each select="字:域代码/字:段落[position()>2]">
                        <xsl:element name="text:p">
                            <xsl:variable name="aa">
                                <xsl:number from="/uof:UOF/uof:文字处理/字:主体" level="any" count="字:段落[字:段落属性]"/>
                            </xsl:variable>
                            <xsl:attribute name="text:style-name"><xsl:value-of select="concat('P',$aa + 1)"/></xsl:attribute>
                            <xsl:element name="text:a">
                                <xsl:attribute name="xlink:type">simple</xsl:attribute>
                                <xsl:attribute name="text:style-name">Index Link</xsl:attribute>
                                <xsl:attribute name="text:visited-style-name">Index Link</xsl:attribute>
                                <xsl:variable name="hyperDest" select="./字:句/字:区域开始/@字:标识符"/>
                                <xsl:attribute name="xlink:href"><xsl:for-each select="/uof:UOF/uof:链接集/uof:超级链接"><xsl:if test="@uof:链源=$hyperDest"><xsl:value-of select="concat('#',@uof:书签)"/></xsl:if></xsl:for-each></xsl:attribute>
                                <xsl:apply-templates select="字:句/*"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:if>
            </text:index-body>
        </xsl:element>
    </xsl:template>
    <xsl:template name="suojinleixing">
        <xsl:if test="字:缩进/字:首行/字:绝对/@字:值 and 字:缩进/字:左/字:绝对/@字:值">
            <xsl:attribute name="text:min-label-width"><xsl:value-of select="concat(0 - 字:缩进/字:首行/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
            <xsl:attribute name="text:space-before"><xsl:value-of select="concat(字:缩进/字:左/字:绝对/@字:值 + 字:缩进/字:首行/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="字:修订开始[@字:类型='insert']">
        <xsl:choose>
            <xsl:when test="./@字:标识符">
                <text:change-start text:change-id="{@字:标识符}"/>
            </xsl:when>
            <xsl:otherwise>
                <text:change-start text:change-id="{@字:修订信息引用}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:修订结束[preceding::字:修订开始[1]/@字:类型='insert']">
        <text:change-end>
            <xsl:attribute name="text:change-id"><xsl:value-of select="@字:开始标识引用"/></xsl:attribute>
        </text:change-end>
    </xsl:template>
    <xsl:template match="字:修订开始[@字:类型='delete']">
        <xsl:choose>
            <xsl:when test="./@字:标识符">
                <text:change-start text:change-id="{@字:标识符}"/>
            </xsl:when>
            <xsl:otherwise>
                <text:change-start text:change-id="{@字:修订信息引用}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:修订结束[preceding::字:修订开始[1]/@字:类型='delete']">
        <text:change-end>
            <xsl:attribute name="text:change-id"><xsl:value-of select="@字:开始标识引用"/></xsl:attribute>
        </text:change-end>
    </xsl:template>
    <xsl:template match="字:修订开始[@字:类型='format']">
        <xsl:choose>
            <xsl:when test="./@字:标识符">
                <text:change-start text:change-id="{@字:标识符}"/>
            </xsl:when>
            <xsl:otherwise>
                <text:change-start text:change-id="{@字:修订信息引用}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="字:修订结束[preceding::字:修订开始[1]/@字:类型='format']">
        <text:change-end>
            <xsl:attribute name="text:change-id"><xsl:value-of select="@字:开始标识引用"/></xsl:attribute>
        </text:change-end>
    </xsl:template>
    <xsl:template name="GenerateTrackChanges">
        <text:tracked-changes>
            <xsl:if test="/uof:UOF/uof:文字处理/字:公用处理规则/字:文档设置/字:修订">
                <xsl:attribute name="text:track-changes"><xsl:value-of select="/uof:UOF/uof:文字处理/字:公用处理规则/字:文档设置/字:修订/@字:值"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="//字:段落/字:修订开始[@字:类型='insert']">
                <xsl:for-each select="//字:段落/字:修订开始[@字:类型='insert']">
                    <xsl:variable name="id" select="@字:标识符"/>
                    <xsl:variable name="aid" select="/uof:UOF/uof:文字处理/字:公用处理规则/字:修订信息集/字:修订信息[@字:标识符=$id]/@字:作者"/>
                    <xsl:variable name="sid" select="/uof:UOF/uof:文字处理/字:公用处理规则/字:用户集/字:用户[@字:标识符=$aid]/@字:姓名"/>
                    <xsl:variable name="bid" select="/uof:UOF/uof:文字处理/字:公用处理规则/字:修订信息集/字:修订信息[@字:标识符=$id]/@字:日期"/>
                    <text:changed-region text:id="{$id}">
                        <xsl:choose>
                            <xsl:when test="name()='字:修订开始'">
                                <xsl:choose>
                                    <xsl:when test="not(name(following-sibling::node()[1])='字:修订结束')">
                                        <text:insertion>
                                            <office:change-info>
                                                <dc:creator>
                                                    <xsl:value-of select="$sid"/>
                                                </dc:creator>
                                                <dc:date>
                                                    <xsl:value-of select="$bid"/>
                                                </dc:date>
                                            </office:change-info>
                                        </text:insertion>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <text:format-change>
                                            <office:change-info>
                                                <dc:creator>
                                                    <xsl:value-of select="$sid"/>
                                                </dc:creator>
                                                <dc:date>
                                                    <xsl:value-of select="$bid"/>
                                                </dc:date>
                                            </office:change-info>
                                        </text:format-change>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                        </xsl:choose>
                    </text:changed-region>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="//字:段落/字:修订开始[@字:类型='insert']">
                <xsl:for-each select="//字:段落/字:修订开始[@字:类型='delete']">
                    <xsl:variable name="id" select="@字:标识符"/>
                    <xsl:variable name="aid" select="/uof:UOF/uof:文字处理/字:公用处理规则/字:修订信息集/字:修订信息[@字:标识符=$id]/@字:作者"/>
                    <xsl:variable name="sid" select="/uof:UOF/uof:文字处理/字:公用处理规则/字:用户集/字:用户[@字:标识符=$aid]/@字:姓名"/>
                    <xsl:variable name="bid" select="/uof:UOF/uof:文字处理/字:公用处理规则/字:修订信息集/字:修订信息[@字:标识符=$id]/@字:日期"/>
                    <text:changed-region text:id="{$id}">
                        <xsl:choose>
                            <xsl:when test="name()='字:修订开始'">
                                <xsl:choose>
                                    <xsl:when test="not(name(following-sibling::node()[1])='字:修订结束')">
                                        <text:deletion>
                                            <office:change-info>
                                                <dc:creator>
                                                    <xsl:value-of select="$sid"/>
                                                </dc:creator>
                                                <dc:date>
                                                    <xsl:value-of select="$bid"/>
                                                </dc:date>
                                            </office:change-info>
                                        </text:deletion>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <text:format-change>
                                            <office:change-info>
                                                <dc:creator>
                                                    <xsl:value-of select="$sid"/>
                                                </dc:creator>
                                                <dc:date>
                                                    <xsl:value-of select="$bid"/>
                                                </dc:date>
                                            </office:change-info>
                                        </text:format-change>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                        </xsl:choose>
                    </text:changed-region>
                </xsl:for-each>
                </xsl:if>
                <xsl:if test="//字:段落/字:修订开始[@字:类型='format']">
                <xsl:for-each select="//字:段落/字:修订开始[@字:类型='format']">
                    <xsl:variable name="id" select="@字:标识符"/>
                    <xsl:variable name="aid" select="/uof:UOF/uof:文字处理/字:公用处理规则/字:修订信息集/字:修订信息[@字:标识符=$id]/@字:作者"/>
                    <xsl:variable name="sid" select="/uof:UOF/uof:文字处理/字:公用处理规则/字:用户集/字:用户[@字:标识符=$aid]/@字:姓名"/>
                    <xsl:variable name="bid" select="/uof:UOF/uof:文字处理/字:公用处理规则/字:修订信息集/字:修订信息[@字:标识符=$id]/@字:日期"/>
                    <text:changed-region text:id="{$id}">
                        <xsl:choose>
                            <xsl:when test="name()='字:修订开始'">
                                <xsl:choose>
                                    <xsl:when test="not(name(following-sibling::node()[1])='字:修订结束')">
                                        <text:format-change>
                                            <office:change-info>
                                                <dc:creator>
                                                    <xsl:value-of select="$sid"/>
                                                </dc:creator>
                                                <dc:date>
                                                    <xsl:value-of select="$bid"/>
                                                </dc:date>
                                            </office:change-info>
                                        </text:format-change>
                                    </xsl:when>
                                    <xsl:otherwise>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                        </xsl:choose>
                    </text:changed-region>
                </xsl:for-each>
                </xsl:if>

            </text:tracked-changes>

    </xsl:template>
    <xsl:template name="oo数字格式">
        <xsl:param name="oo_format"/>
        <xsl:choose>
            <xsl:when test="$oo_format='decimal'">1</xsl:when>
            <xsl:when test="$oo_format='upper-roman'">I</xsl:when>
            <xsl:when test="$oo_format='lower-roman'">i</xsl:when>
            <xsl:when test="$oo_format='upper-letter'">A</xsl:when>
            <xsl:when test="$oo_format='lower-letter'">a</xsl:when>
            <xsl:when test="$oo_format='decimal-full-width'">１, ２, ３, ...</xsl:when>
            <xsl:when test="$oo_format='decimal-enclosed-circle'">①, ②, ③, ...</xsl:when>
            <xsl:when test="$oo_format='chinese-counting'">一, 二, 三, ...</xsl:when>
            <xsl:when test="$oo_format='chinese-legal-simplified'">壹, 贰, 叁, ...</xsl:when>
            <xsl:when test="$oo_format='ideograph-traditional'">甲, 乙, 丙, ...</xsl:when>
            <xsl:when test="$oo_format='ideograph-zodiac'">子, 丑, 寅, ...</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="章节域">
        <xsl:if test="../字:域代码/字:段落/字:句/字:文本串">
            <xsl:variable name="date0" select="substring-after(../字:域代码/字:段落/字:句/字:文本串,' \* ')"/>
            <xsl:variable name="datestr" select="substring-before(../字:域代码/字:段落/字:句/字:文本串,'\* ')"/>
            <xsl:variable name="fmt">
                <xsl:choose>
                    <xsl:when test="substring-before($date0,' \*')='Arabic'">
                        <xsl:call-template name="oo数字格式域开关">
                            <xsl:with-param name="oo_format" select="substring-before($date0,' \*')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:element name="text:chapter">
                <xsl:attribute name="text:display">name</xsl:attribute>
                <xsl:attribute name="text:outline-level"><xsl:value-of select="$fmt"/></xsl:attribute>
                <xsl:value-of select="following-sibling::字:句/字:文本串"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
