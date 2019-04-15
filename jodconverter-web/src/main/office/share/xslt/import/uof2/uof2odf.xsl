<?xml version="1.0" encoding="UTF-8"?>
<!--/************************************************************** *  
* Licensed to the Apache Software Foundation (ASF) under one 
* or more contributor license agreements.  See the NOTICE file 
* distributed with this work for additional information 
* regarding copyright ownership.  The ASF licenses this file 
* to you under the Apache License, Version 2.0 (the 
* "License"); you may not use this file except in compliance 
* with the License.  You may obtain a copy of the License at 
*  
*   http://www.apache.org/licenses/LICENSE-2.0 
*  
* Unless required by applicable law or agreed to in writing, 
* software distributed under the License is distributed on an 
* "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY 
* KIND, either express or implied.  See the License for the 
* specific language governing permissions and limitations 
* under the License. *  
*************************************************************/-->
 <!--MARKER(update_precomp.py): autogen include statement, do not remove-->
 <!--//This file is about the conversion of the UOF v2.0 and ODF document format-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:nsof="http://neoshineoffice.com" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" xmlns:pzip="urn:cleverage:xmlns:post-processings:zip" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:uof="http://schemas.uof.org/cn/2009/uof" xmlns:书签="http://schemas.uof.org/cn/2009/bookmarks" xmlns:元="http://schemas.uof.org/cn/2009/metadata" xmlns:公式="http://schemas.uof.org/cn/2009/equations" xmlns:图="http://schemas.uof.org/cn/2009/graph" xmlns:图形="http://schemas.uof.org/cn/2009/graphics" xmlns:图表="http://schemas.uof.org/cn/2009/chart" xmlns:字="http://schemas.uof.org/cn/2009/wordproc" xmlns:对象="http://schemas.uof.org/cn/2009/objects" xmlns:式样="http://schemas.uof.org/cn/2009/styles" xmlns:扩展="http://schemas.uof.org/cn/2009/extend" xmlns:数="http://www.w3.org/1998/Math/MathML" xmlns:数据="http://schemas.uof.org/cn/2009/usd" xmlns:演="http://schemas.uof.org/cn/2009/presentation" xmlns:表="http://schemas.uof.org/cn/2009/spreadsheet" xmlns:规则="http://schemas.uof.org/cn/2009/rules" xmlns:超链="http://schemas.uof.org/cn/2009/hyperlinks" exclude-result-prefixes="uof 表 演 字 图 数 pzip 元 超链 图形 对象 公式 书签 数据 扩展 规则 式样">
	<xsl:output omit-xml-declaration="no" encoding="utf-8" version="1.0" method="xml" standalone="yes" indent="no"/>
	<xsl:strip-space elements="*"/>
	<xsl:variable name="document_type">
		<xsl:choose>
			<xsl:when test="/uof:UOF_0000/演:演示文稿文档_6C10">presentation</xsl:when>
			<xsl:when test="/uof:UOF_0000/字:文字处理文档_4225">text</xsl:when>
			<xsl:when test="/uof:UOF_0000/表:电子表格文档_E826">spreadsheet</xsl:when>
			<xsl:when test="/uof:UOF_0000/@mimetype_0001='vnd.uof.text'">text</xsl:when>
			<xsl:when test="/uof:UOF_0000/@mimetype_0001='vnd.uof.presentation'">presentation</xsl:when>
			<xsl:when test="/uof:UOF_0000/@mimetype_0001='vnd.uof.spreadsheet'">spreadsheet</xsl:when>
			<xsl:otherwise>text</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="uofUnit">
		<xsl:variable name="uu" select="/uof:UOF_0000/规则:公用处理规则_B665/规则:长度单位_B666"/>
		<xsl:choose>
			<xsl:when test="$uu='cm'">cm</xsl:when>
			<xsl:when test="$uu='mm'">mm</xsl:when>
			<xsl:when test="$uu='pt'">pt</xsl:when>
			<xsl:when test="contains($uu,'in')">in</xsl:when>
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
			<xsl:otherwise>0.03527</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="isRCCellAddress">
		<xsl:choose>
			<xsl:when test="($document_type='spreadsheet') and (/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:是否RC引用_B634 = 'true')">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="gvar_ChartsIndexes">
		<xsl:for-each select="//图表:图表_E837">
			<xsl:element name="ChartIndex">
				<xsl:attribute name="GenerateID" select="generate-id()"/>
				<xsl:attribute name="Index" select="position()"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:variable>
	<xsl:key name="CellStyle" match="/uof:UOF_0000/式样:式样集_990B/式样:单元格式样集_9915/式样:单元格式样_9916" use="@标识符_E7AC"/>
	<xsl:key name="MasterTextStyle" match="/uof:UOF_0000/式样:式样集_990B/式样:文本式样集_9913/式样:文本式样_9914" use="@标识符_9909"/>
	<xsl:key name="uof-paragraph-styles" match="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912 | /uof:UOF_0000/式样:式样集_990B/式样:文本式样集_9913/式样:文本式样_9914/式样:段落式样_9912" use="@标识符_4100"/>
	<xsl:key name="uof-text-styles" match="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910" use="@标识符_4100"/>
	<xsl:key name="uof-table-styles" match="/uof:UOF_0000/式样:式样集_990B/式样:文字表式样集_9917/式样:文字表式样_9918" use="@标识符_4100"/>
	<xsl:key name="hyperlink" match="/uof:UOF_0000/超链:链接集_AA0B/超链:超级链接_AA0C" use="超链:链源_AA00"/>
	<xsl:key name="hyperlinkID" match="/uof:UOF_0000/超链:链接集_AA0B/超链:超级链接_AA0C" use="@标识符_AA0A"/>
	<xsl:key name="bookmark" match="/uof:UOF_0000/书签:书签集_9104/书签:书签_9105" use="@名称_9103"/>
	<xsl:key name="uof-number-styles" match="/uof:UOF_0000/式样:段落式样集_9911/式样:自动编号集_990E/字:自动编号_4124/字:级别_4112" use="字:链接式样引用_4118"/>
	<xsl:key name="AutoNumber" match="/uof:UOF_0000/式样:段落式样集_9911/式样:自动编号集_990E/字:自动编号_4124" use="@标识符_4100"/>
	<xsl:key name="rel_graphic_name" match="/uof:UOF_0000/演:演示文稿文档_6C10//uof:锚点_C644 | /uof:UOF_0000/字:文字处理文档_4225//uof:锚点_C644 | /uof:UOF_0000/表:电子表格文档_E826//uof:锚点_C644 | /uof:UOF_0000/图形:图形集_7C00/图:图形_8062/图:文本_803C/图:内容_8043/字:段落_416B//uof:锚点_C644" use="@图形引用_C62E"/>
	<xsl:key name="graph-styles" match="/uof:UOF_0000/图形:图形集_7C00/图:图形_8062" use="@标识符_804B"/>
	<xsl:key name="graph4chart" match="/uof:UOF_0000/图形:图形集_7C00/图:图形_8062" use="图:图表数据引用_8065"/>
	<xsl:key name="math-styles" match="/uof:UOF_0000/公式:公式集_C200" use="@标识符_C202"/>
	<xsl:key name="other-styles" match="/uof:UOF_0000/对象:对象数据集_D700/对象:对象数据_D701" use="@标识符_D704"/>
	<xsl:key name="HeaderFooterP" match="/uof:UOF_0000/规则:公用处理规则_B665/规则:演示文稿_B66D/规则:页眉页脚集_B640/*" use="name()"/>
	<xsl:key name="Slide" match="/uof:UOF_0000/演:演示文稿文档_6C10/演:幻灯片集_6C0E/演:幻灯片_6C0F" use="@母版引用_6B26"/>
	<xsl:key name="SlideMaster" match="/uof:UOF_0000/演:演示文稿文档_6C10/演:母版集_6C0C/演:母版_6C0D" use="@标识符_6BE8"/>
	<xsl:key name="graphicsextension" match="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201" use="扩展:扩展内容_B204/扩展:路径_B205"/>
	<xsl:key name="textTable" match="/uof:UOF_0000/uof:文字处理文档_4225/字:文字表_416C" use="字:文字表属性_41CC/@式样引用_419C"/>
	<xsl:template match="uof:UOF_0000">
		<office:document>
			<xsl:variable name="mimetype">
				<xsl:choose>
					<xsl:when test="$document_type = 'text'">application/vnd.oasis.opendocument.text</xsl:when>
					<xsl:when test="$document_type = 'presentation'">application/vnd.oasis.opendocument.presentation</xsl:when>
					<xsl:when test="$document_type = 'spreadsheet'">application/vnd.oasis.opendocument.spreadsheet</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="office:mimetype" select="$mimetype"/>
			<xsl:attribute name="office:version" select="1.2"/>
			<xsl:apply-templates select="/uof:UOF_0000/元:元数据_5200"/>
			<office:settings>
				<xsl:choose>
					<xsl:when test="$document_type = 'text'">
						<xsl:call-template name="OfficeSettingsText"/>
					</xsl:when>
					<xsl:when test="$document_type = 'presentation'">
						<xsl:call-template name="OfficeSettingsPresentation"/>
					</xsl:when>
					<xsl:when test="$document_type = 'spreadsheet'">
						<xsl:call-template name="OfficeSettingsSpreadsheet"/>
					</xsl:when>
				</xsl:choose>
			</office:settings>
			<!--<xsl:call-template name="SetMetricUnit"/>-->
			<xsl:if test="$document_type != 'presentation'">
				<office:font-face-decls>
					<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C">
						<xsl:call-template name="UOFFonts"/>
					</xsl:for-each>
				</office:font-face-decls>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$document_type = 'text'">
					<xsl:apply-templates select="/uof:UOF_0000/字:文字处理文档_4225"/>
				</xsl:when>
				<xsl:when test="$document_type = 'presentation'">
					<xsl:apply-templates select="/uof:UOF_0000/演:演示文稿文档_6C10"/>
				</xsl:when>
				<xsl:when test="$document_type = 'spreadsheet'">
					<xsl:apply-templates select="/uof:UOF_0000/表:电子表格文档_E826"/>
				</xsl:when>
			</xsl:choose>
			<office:automatic-styles>
				<!-- number:time-style and number:date-style -->
				<xsl:if test="//字:域开始_419E[@类型_416E='createdate'] | //字:域开始_419E[@类型_416E='time'] | //字:域开始_419E[@类型_416E='savedate'] | //字:域开始_419E[@类型_416E='date']">
					<xsl:call-template name="TimeDateNumberStyle"/>
				</xsl:if>
				<xsl:apply-templates select="演:演示文稿文档_6C10/演:幻灯片集_6C0E/演:幻灯片_6C0F" mode="AutoStyle"/>
				<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@类型_4102='auto']">
					<xsl:apply-templates select=".">
						<xsl:with-param name="Type" select="string('auto')"/>
					</xsl:apply-templates>
				</xsl:for-each>
				<!--xsl:call-template name="BodyTextProperties"/-->
				<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912[@类型_4102='auto']">
					<xsl:apply-templates select=".">
						<xsl:with-param name="Type" select="string('auto')"/>
					</xsl:apply-templates>
				</xsl:for-each>
				<!-- 母版用到的段落式样写在style.xml下，其他段落式样写在content.xml下 -->
				<xsl:choose>
					<xsl:when test="not($document_type = 'presentation')">
						<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:批注集_B669/规则:批注_B66A//字:段落_416B | /uof:UOF_0000/字:文字处理文档_4225//字:段落_416B | /uof:UOF_0000/图形:图形集_7C00/图:图形_8062/图:文本_803C/图:内容_8043//字:段落_416B | /uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825//字:段落_416B">
							<xsl:call-template name="BodyParagraphProperties"/>
							<xsl:for-each select="字:句_419D/字:句属性_4158">
								<xsl:call-template name="BodyTextProperties"/>
							</xsl:for-each>
						</xsl:for-each>
						<xsl:for-each select="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825/表:工作表内容_E80E/表:行_E7F1/表:单元格_E7F2/表:数据_E7B3/字:句_419D/字:句属性_4158">
							<xsl:call-template name="BodyTextProperties"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:批注集_B669/规则:批注_B66A//字:段落_416B | /uof:UOF_0000/图形:图形集_7C00/图:图形_8062/图:文本_803C/图:内容_8043//字:段落_416B">
							<xsl:if test="name(key('rel_graphic_name',ancestor::图:图形_8062/@标识符_804B)[1]/..)!='演:母版_6C0D'">
								<xsl:call-template name="BodyParagraphProperties"/>
								<xsl:for-each select="字:句_419D/字:句属性_4158">
									<xsl:call-template name="BodyTextProperties"/>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$document_type = 'spreadsheet'">
						<xsl:call-template name="BodyTableStyle"/>
						<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:单元格式样集_9915/式样:单元格式样_9916[@类型_E7AE='auto']">
							<xsl:apply-templates select=".">
								<xsl:with-param name="Type" select="string('auto')"/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:文字表式样集_9917/式样:文字表式样_9918[@类型_4102='auto']">
							<xsl:apply-templates select=".">
								<xsl:with-param name="Type" select="string('auto')"/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<!-- 相对于_C647 -->
				<xsl:if test="/uof:UOF_0000/字:文字处理文档_4225/字:文字表_416C/字:文字表属性_41CC/字:位置_41C7/uof:垂直_410D[@相对于_C647 = 'margin']/uof:相对_4109[@参考点_410B = 'bottom']">
					<xsl:apply-templates select="/uof:UOF_0000/字:文字处理文档_4225/字:文字表_416C/字:文字表属性_41CC" mode="embeded_into_frame"/>
				</xsl:if>
				<xsl:apply-templates select="/uof:UOF_0000/式样:式样集_990B/式样:自动编号集_990E/字:自动编号_4124" mode="liststyle"/>
				<xsl:call-template name="BodyTextTableStyle"/>
				<xsl:call-template name="GraphicStyle"/>
			</office:automatic-styles>
			<!--xsl:if test="$document_type != 'presentation'"-->
			<office:font-face-decls>
				<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C">
					<xsl:call-template name="UOFFonts"/>
				</xsl:for-each>
			</office:font-face-decls>
			<!--/xsl:if-->
			<office:automatic-styles>
				<xsl:choose>
					<xsl:when test="$document_type = 'text'">
						<xsl:call-template name="PageLayoutStyle"/>
						<!-- 页码式样 starting -->
						<xsl:for-each select="/uof:UOF_0000/字:文字处理文档_4225/字:分节_416A/字:节属性_421B/字:页脚_41F7//字:段落_416B">
							<xsl:call-template name="BodyParagraphProperties"/>
							<xsl:for-each select="字:句_419D/字:句属性_4158">
								<xsl:call-template name="BodyTextProperties"/>
							</xsl:for-each>
						</xsl:for-each>
						<!-- 页码式样 ending. -->
					</xsl:when>
					<xsl:when test="$document_type = 'spreadsheet'">
						<xsl:call-template name="ScPageLayoutStyle"/>
					</xsl:when>
					<xsl:when test="$document_type = 'presentation'">
						<!-- 母版用到的段落式样写在style.xml下，其他段落式样写在content.xml下 -->
						<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:批注集_B669/规则:批注_B66A//字:段落_416B | /uof:UOF_0000/图形:图形集_7C00/图:图形_8062/图:文本_803C/图:内容_8043//字:段落_416B">
							<xsl:if test="name(key('rel_graphic_name',ancestor::图:图形_8062/@标识符_804B)[1]/..)='演:母版_6C0D'">
								<xsl:call-template name="BodyParagraphProperties"/>
								<xsl:if test="(./字:段落属性_419B/字:自动编号信息_4186) or (count(./字:段落属性_419B/child::*) = 0)">
									<xsl:for-each select="key('uof-paragraph-styles',字:段落属性_419B/@式样引用_419C)[name(..)='式样:段落式样集_9911']">
										<xsl:apply-templates select=".">
											<xsl:with-param name="Type" select="string('auto')"/>
										</xsl:apply-templates>
									</xsl:for-each>
								</xsl:if>
								<xsl:for-each select="字:句_419D/字:句属性_4158">
									<xsl:call-template name="BodyTextProperties"/>
									<xsl:if test="count(*)=0">
										<xsl:for-each select="key('uof-text-styles',@式样引用_417B)">
											<xsl:apply-templates select=".">
												<xsl:with-param name="Type" select="string('auto')"/>
											</xsl:apply-templates>
										</xsl:for-each>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
						<xsl:call-template name="AutoStylePresentation"/>
						<xsl:call-template name="SpecialHolderTextStyle"/>
						<xsl:call-template name="MasterGraphicStyle"/>
					</xsl:when>
				</xsl:choose>
			</office:automatic-styles>
			<office:master-styles>
				<xsl:choose>
					<xsl:when test="$document_type = 'text'">
						<xsl:call-template name="MasterStyleText"/>
					</xsl:when>
					<xsl:when test="$document_type = 'spreadsheet'">
						<xsl:call-template name="MasterStyleSpreadsheet"/>
					</xsl:when>
					<xsl:when test="$document_type = 'presentation'">
						<xsl:call-template name="MasterStylePresentation"/>
					</xsl:when>
				</xsl:choose>
			</office:master-styles>
			<office:styles>
				<xsl:for-each select="//图:渐变_800D/..">
					<xsl:call-template name="GradientStyle"/>
				</xsl:for-each>
				<xsl:call-template name="HatchSetStyle"/>
				<xsl:if test="$document_type = 'text'">
					<xsl:call-template name="CallExpandHatch"/>
					<!--xsl:call-template name="CallExpandMarker"/-->
					<xsl:call-template name="CallExpandStroke"/>
				</xsl:if>
				<xsl:call-template name="GraphicSetStyle"/>
				<xsl:call-template name="GraphicDefinition"/>
				<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@类型_4102='default'][1]">
					<xsl:apply-templates select=".">
						<xsl:with-param name="Type" select="string('default')"/>
					</xsl:apply-templates>
				</xsl:for-each>
				<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912[@类型_4102='default'][1]">
					<xsl:apply-templates select=".">
						<xsl:with-param name="Type" select="string('default')"/>
					</xsl:apply-templates>
				</xsl:for-each>
				<xsl:if test="$document_type = 'presentation'">
					<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912[@类型_4102='default'][1]">
						<xsl:apply-templates select="." mode="presentation-default"/>
					</xsl:for-each>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$document_type = 'spreadsheet'">
						<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:单元格式样集_9915/式样:单元格式样_9916[@类型_E7AE='default'][1]">
							<xsl:apply-templates select=".">
								<xsl:with-param name="Type" select="string('default')"/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:文字表式样集_9917/式样:文字表式样_9918[@类型_4102='default'][1]">
							<xsl:apply-templates select=".">
								<xsl:with-param name="Type" select="string('default')"/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@类型_4102='custom']">
					<xsl:apply-templates select=".">
						<xsl:with-param name="Type" select="string('custom')"/>
					</xsl:apply-templates>
				</xsl:for-each>
				<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912[@类型_4102='custom']">
					<xsl:apply-templates select=".">
						<xsl:with-param name="Type" select="string('custom')"/>
					</xsl:apply-templates>
				</xsl:for-each>
				<xsl:choose>
					<xsl:when test="$document_type = 'spreadsheet'">
						<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:单元格式样集_9915/式样:单元格式样_9916[@类型_E7AE='custom']">
							<xsl:apply-templates select=".">
								<xsl:with-param name="Type" select="string('custom')"/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:文字表式样集_9917/式样:文字表式样_9918[@类型_4102='custom']">
							<xsl:apply-templates select=".">
								<xsl:with-param name="Type" select="string('custom')"/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<!--xsl:call-template name="BodyTextProperties">
					<xsl:with-param name="Type" select="'symbol'"/>
				</xsl:call-template-->
				<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:自动编号集_990E//字:符号字体_4116">
					<xsl:if test="count(./child::*)!=0">
						<xsl:call-template name="BodyTextProperties"/>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="$document_type = 'text'">
					<xsl:call-template name="FootnoteSetting"/>
					<xsl:call-template name="EndnoteSetting"/>
					<xsl:call-template name="LineNumbering"/>
					<style:default-page-layout>
						<style:page-layout-properties style:layout-grid-standard-mode="true"/>
					</style:default-page-layout>
				</xsl:if>
				<xsl:if test="$document_type = 'presentation'">
					<xsl:call-template name="OfficeStylePresentation"/>
				</xsl:if>
			</office:styles>
			<xsl:for-each select="//图表:图表_E837">
				<xsl:apply-templates select="." />
			</xsl:for-each>
		</office:document>
	</xsl:template>
	<xsl:template match="图表:图表_E837">
				<!--<office:meta>
					<meta:generator>NeoShineOffice/6.0$Win32 OpenOffice.org_project/300M39$Build-9402</meta:generator>
				</office:meta>-->
				<xsl:call-template name="图表:固定式样式样集"/>
				<xsl:call-template name="OfficeAutomaticStyles4chart"/>
				<xsl:call-template name="OfficeBody4chart"/>
	</xsl:template>
	<xsl:template name="GetODFMetric">
		<xsl:choose>
			<xsl:when test="$uofUnit = 'mm'">[1]</xsl:when>
			<xsl:when test="$uofUnit = 'cm'">[2]</xsl:when>
			<xsl:when test="$uofUnit = 'pt'">[6]</xsl:when>
			<xsl:when test="$uofUnit = 'in'">[8]</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--<xsl:template name="SetMetricUnit">
		<xsl:choose>
			<xsl:when test="$document_type = 'presentation'">
				<office:scripts/>
			</xsl:when>
			<xsl:otherwise>
				<office:scripts>
					<office:script script:language="ooo:Basic">
						<ooo:libraries>
							<ooo:library-embedded ooo:name="Standard"/>
						</ooo:libraries>
					</office:script>
					<office:event-listeners>
						<script:event-listener script:language="ooo:script" script:event-name="dom:load" xlink:href="vnd.sun.star.script:Tools.Misc.NeoShineOfficeSetMetricUnit?language=Basic&amp;location=application"/>
					</office:event-listeners>
				</office:scripts>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->
	<xsl:template match="元:元数据_5200">
		<office:meta>
			<xsl:if test="元:标题_5201">
				<dc:title>
					<xsl:value-of select="元:标题_5201"/>
				</dc:title>
			</xsl:if>
			<xsl:if test="元:主题_5202">
				<dc:subject>
					<xsl:value-of select="元:主题_5202"/>
				</dc:subject>
			</xsl:if>
			<xsl:if test="元:创建者_5203">
				<meta:initial-creator>
					<xsl:value-of select="元:创建者_5203"/>
				</meta:initial-creator>
			</xsl:if>
			<!--xsl:if test="元:作者">
					</xsl:if-->
			<xsl:if test="元:最后作者_5205 or 元:作者_5204">
				<dc:creator>
					<xsl:value-of select="元:最后作者_5205"/>
					<xsl:value-of select="元:作者_5204"/>
				</dc:creator>
			</xsl:if>
			<dc:date>
				<xsl:value-of select="current-dateTime()"/>
			</dc:date>
			<!--背景音乐信息存放在第二个dc:description元素中-->
			<xsl:if test="元:摘要_5206">
				<dc:description>
					<xsl:value-of select="元:摘要_5206"/>
				</dc:description>
				<xsl:if test="/uof:UOF_0000/uof:演示文稿/演:公用处理规则/演:放映设置/演:声音">
					<dc:description>backgroudvoice</dc:description>
				</xsl:if>
			</xsl:if>
			<xsl:if test="not(元:摘要_5206) and /uof:UOF_0000/uof:演示文稿/演:公用处理规则/演:放映设置/演:声音">
				<dc:description/>
				<dc:description>backgroudvoice</dc:description>
			</xsl:if>
			<xsl:if test="元:创建日期_5207">
				<meta:creation-date>
					<xsl:value-of select="元:创建日期_5207"/>
				</meta:creation-date>
			</xsl:if>
			<xsl:if test="元:编辑次数_5208">
				<meta:editing-cycles>
					<xsl:value-of select="元:编辑次数_5208"/>
				</meta:editing-cycles>
			</xsl:if>
			<dc:date>
				<xsl:value-of select="current-date()"/>
			</dc:date>
			<xsl:if test="元:编辑时间_5209">
				<meta:editing-duration>
					<xsl:choose>
						<xsl:when test="contains(元:编辑时间_5209,'P0Y0')">
							<xsl:variable name="hour" select="substring-after(substring-before(元:编辑时间_5209,'H'),'T')"/>
							<xsl:variable name="minute" select="substring-before(substring-after(元:编辑时间_5209,'H'),'M')"/>
							<xsl:variable name="second" select="substring-after(substring-after(substring-before(元:编辑时间_5209,'S'),'H'),'M')"/>
							<xsl:value-of select="concat('PT',$hour,'H',$minute,'M',$second,'S')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="元:编辑时间_5209"/>
						</xsl:otherwise>
					</xsl:choose>
				</meta:editing-duration>
			</xsl:if>
			<xsl:variable name="ODFMetricUnit">
				<xsl:call-template name="GetODFMetric"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="元:创建应用程序_520A">
					<meta:generator>
						<xsl:value-of select="concat(元:创建应用程序_520A, $ODFMetricUnit)"/>
					</meta:generator>
				</xsl:when>
				<xsl:otherwise>
					<meta:generator>
						<xsl:value-of select="concat('NeoShineOffice-Build', $ODFMetricUnit)"/>
					</meta:generator>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="元:文档模板_520C">
				<meta:template xlink:type="simple" xlink:actuate="onRequest">
					<xsl:attribute name="xlink:title"><xsl:value-of select="元:文档模板_520C"/></xsl:attribute>
				</meta:template>
			</xsl:if>
			<xsl:if test="元:关键字集_520D">
				<xsl:for-each select="元:关键字集_520D/元:关键字_520E">
					<meta:keyword>
						<xsl:value-of select="."/>
					</meta:keyword>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="元:分类_520B">
				<dc:category>
					<xsl:value-of select="元:分类_520B"/>
				</dc:category>
			</xsl:if>
			<xsl:if test="元:公司名称_5213">
				<dc:company>
					<xsl:value-of select="元:公司名称_5213"/>
				</dc:company>
			</xsl:if>
			<xsl:if test="元:经理名称_5214">
				<dc:manager>
					<xsl:value-of select="元:经理名称_5214"/>
				</dc:manager>
			</xsl:if>
			<meta:document-statistic>
				<xsl:if test="元:页数_5215">
					<xsl:attribute name="meta:page-count"><xsl:value-of select="元:页数_5215"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="元:段落数_521A">
					<xsl:attribute name="meta:paragraph-count"><xsl:value-of select="元:段落数_521A"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="元:字数_5216">
					<xsl:attribute name="meta:word-count"><xsl:value-of select="元:字数_5216"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="元:对象数_521B">
					<xsl:attribute name="meta:object-count"><xsl:value-of select="元:对象数_521B"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="元:行数_5219">
					<xsl:attribute name="meta:row-count"><xsl:value-of select="元:行数_5219"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="元:英文字符数_5217 | 元:中文字符数_5218">
					<xsl:attribute name="meta:character-count"><xsl:value-of select="元:英文字符数_5217 + 元:中文字符数_5218"/></xsl:attribute>
				</xsl:if>
			</meta:document-statistic>
			<xsl:if test="元:用户自定义元数据集_520F">
				<xsl:for-each select="元:用户自定义元数据集_520F/元:用户自定义元数据_5210">
					<meta:user-defined meta:name="{@名称_5211}">
						<xsl:if test="@类型_5212">
							<xsl:attribute name="meta:type"><xsl:value-of select="@类型_5212"/></xsl:attribute>
						</xsl:if>
						<xsl:value-of select="."/>
					</meta:user-defined>
				</xsl:for-each>
				<xsl:if test="元:作者_5204">
					<meta:user-defined meta:name="作者">
						<xsl:if test="@类型_5212">
							<xsl:attribute name="meta:type"><xsl:value-of select="元:作者_5204"/></xsl:attribute>
						</xsl:if>
						<xsl:value-of select="元:作者_5204"/>
					</meta:user-defined>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$isRCCellAddress = 'true'">
				<meta:user-defined meta:name="isRCCellAddress">true</meta:user-defined>
			</xsl:if>
		</office:meta>
	</xsl:template>
	<xsl:template name="UOFFonts">
		<xsl:variable name="ss">&apos;</xsl:variable>
		<xsl:for-each select="式样:字体声明_990D">
			<xsl:element name="style:font-face">
				<xsl:for-each select="@*">
					<xsl:choose>
						<xsl:when test="name(.)='标识符_9902'">
							<xsl:attribute name="style:name"><xsl:value-of select="."/></xsl:attribute>
						</xsl:when>
						<xsl:when test="name(.)='名称_9903'">
							<xsl:attribute name="svg:font-family"><xsl:choose><xsl:when test="contains(.,' ')"><xsl:value-of select="concat($ss,.,$ss)"/></xsl:when><xsl:otherwise><xsl:value-of select="."/></xsl:otherwise></xsl:choose></xsl:attribute>
						</xsl:when>
						<xsl:when test="name(.)='式样:字体族_9900'">
							<xsl:choose>
								<xsl:when test="string(.) = 'swiss'">
									<xsl:attribute name="style:font-family-generic">swiss</xsl:attribute>
								</xsl:when>
								<xsl:when test="string(.) = 'modern'">
									<xsl:attribute name="style:font-family-generic">modern</xsl:attribute>
								</xsl:when>
								<xsl:when test="string(.) = 'roman'">
									<xsl:attribute name="style:font-family-generic">roman</xsl:attribute>
								</xsl:when>
								<xsl:when test="string(.) = 'script'">
									<xsl:attribute name="style:font-family-generic">script</xsl:attribute>
								</xsl:when>
								<xsl:when test="string(.) = 'decorative'">
									<xsl:attribute name="style:font-family-generic">decorative</xsl:attribute>
								</xsl:when>
								<xsl:when test="string(.) = 'auto'">
									<xsl:attribute name="style:font-family-generic">system</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="style:font-family-generic">system</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--xsl:when test="name(.)='替换字体_9904'">
						</xsl:when-->
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="convertOthers2cm">
		<xsl:param name="value"/>
		<xsl:param name="rounding-factor" select="10000"/>
		<xsl:param name="dpi" select="111"/>
		<xsl:param name="centimeter-in-mm" select="10"/>
		<xsl:param name="inch-in-mm" select="25.4"/>
		<xsl:param name="didot-point-in-mm" select="0.376065"/>
		<xsl:param name="pica-in-mm" select="4.2333333"/>
		<xsl:param name="point-in-mm" select="0.3527778"/>
		<xsl:param name="twip-in-mm" select="0.017636684"/>
		<xsl:param name="pixel-in-mm" select="$inch-in-mm div $dpi"/>
		<xsl:choose>
			<xsl:when test="contains($value, 'mm')">
				<xsl:value-of select="round(number($rounding-factor) * number(substring-before($value, 'mm') div number($centimeter-in-mm))) div number($rounding-factor)"/>
			</xsl:when>
			<xsl:when test="contains($value, 'in')">
				<xsl:value-of select="round($rounding-factor * number(substring-before($value, 'in') div $centimeter-in-mm * $inch-in-mm)) div $rounding-factor"/>
			</xsl:when>
			<xsl:when test="contains($value, 'pt')">
				<xsl:value-of select="round(number($rounding-factor) * number(substring-before($value, 'pt')) div number($centimeter-in-mm) * number($point-in-mm)) div number($rounding-factor)"/>
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
				<xsl:value-of select="substring-before($value, 'cm')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="convert2cm">
		<xsl:param name="value"/>
		<xsl:param name="rounding-factor" select="10000"/>
		<xsl:param name="dpi" select="111"/>
		<xsl:param name="centimeter-in-mm" select="10"/>
		<xsl:param name="inch-in-mm" select="25.4"/>
		<xsl:param name="didot-point-in-mm" select="0.376065"/>
		<xsl:param name="pica-in-mm" select="4.2333333"/>
		<xsl:param name="point-in-mm" select="0.3527778"/>
		<xsl:param name="twip-in-mm" select="0.017636684"/>
		<xsl:param name="pixel-in-mm" select="$inch-in-mm div $dpi"/>
		<xsl:choose>
			<xsl:when test="contains($value, 'mm')">
				<xsl:value-of select="round(number($rounding-factor) * number(substring-before($value, 'mm') div number($centimeter-in-mm))) div number($rounding-factor)"/>
			</xsl:when>
			<xsl:when test="contains($value, $uofUnit)">
				<xsl:value-of select="substring-before($value, $uofUnit)"/>
			</xsl:when>
			<xsl:when test="contains($value, 'in')">
				<xsl:value-of select="round($rounding-factor * number(substring-before($value, 'in') div $centimeter-in-mm * $inch-in-mm)) div $rounding-factor"/>
			</xsl:when>
			<xsl:when test="contains($value, 'pt')">
				<xsl:value-of select="round(number($rounding-factor) * number(substring-before($value, 'pt')) div number($centimeter-in-mm) * number($point-in-mm)) div number($rounding-factor)"/>
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
	<xsl:template name="UOFCommBorder">
		<xsl:param name="lineType"/>
		<xsl:param name="width"/>
		<xsl:param name="color"/>
		<xsl:choose>
			<xsl:when test="$lineType='none' or $lineType = ' '">none</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="substring-before($width,$uofUnit) != ''">
						<xsl:value-of select="$width"/>
					</xsl:when>
					<xsl:otherwise>0.5pt </xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$lineType='double' or $lineType='thin-thick' or $lineType='thick-thin' or $lineType='thick-between-thin'">double </xsl:when>
					<xsl:otherwise>solid </xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$color='auto' or $color='none' or $color=''">#808080</xsl:when>
					<xsl:when test="$color!=''">
						<xsl:value-of select="$color"/>
					</xsl:when>
					<xsl:otherwise>#000000</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="BorderLineWidth">
		<xsl:param name="aType"/>
		<xsl:param name="aSize"/>
		<xsl:choose>
			<!-- alert starting 
			<xsl:when test="$aType = 'double' or $aType = 'thick-between-thin'">
                <xsl:variable name="widths" select="number($aSize) div 3"/>
				<xsl:value-of select="concat(format-number($widths, '#.000'), $uofUnit, ' ', format-number($widths, '#.000'), $uofUnit, ' ', format-number($widths, '#.000'),  $uofUnit)"/>
			</xsl:when>-->
			<xsl:when test="$aType = 'double'">
				<xsl:value-of select="concat(format-number(number($aSize) * 0.01, '#.000'), $uofUnit, ' ', format-number(number($aSize) * 0.75, '#.000'), $uofUnit, ' ', format-number(number($aSize) * 0.24, '#.000'), $uofUnit)"/>
			</xsl:when>
			<xsl:when test="$aType = 'thick-between-thin'">
				<xsl:variable name="widths" select="number($aSize) div 3"/>
				<xsl:value-of select="concat(format-number($widths, '#.000'), $uofUnit, ' ', format-number($widths, '#.000'), $uofUnit, ' ', format-number($widths, '#.000'),  $uofUnit)"/>
			</xsl:when>
			<!-- alert ending. -->
			<xsl:when test="$aType = 'thick-thin'">
				<xsl:value-of select="concat(format-number(number($aSize) * 0.5, '#.000'), $uofUnit, ' ', format-number(number($aSize) * 0.4, '#.000'), $uofUnit, ' ', format-number(number($aSize) * 0.1, '#.000'), $uofUnit)"/>
			</xsl:when>
			<xsl:when test="$aType = 'thin-thick'">
				<xsl:value-of select="concat(format-number(number($aSize) * 0.1, '#.000'), $uofUnit, ' ', format-number(number($aSize) * 0.4, '#.000'), $uofUnit, ' ', format-number(number($aSize) * 0.5, '#.000'), $uofUnit)"/>
			</xsl:when>
			<!--<xsl:when test="$aType = 'thick-between-thin'">
				<xsl:value-of select="concat(format-number(number($aSize) * 0.44, '#.000'), $uofUnit, ' ', format-number(number($aSize) * 0.28, '#.000'), $uofUnit, ' ', format-number(number($aSize) * 0.28, '#.000'), $uofUnit)"/>
			</xsl:when>-->
		</xsl:choose>
	</xsl:template>
	<xsl:template name="CommonBorder">
		<xsl:param name="pUp"/>
		<xsl:param name="pDown"/>
		<xsl:param name="pLeft"/>
		<xsl:param name="pRight"/>
		<xsl:param name="pDiagon1"/>
		<xsl:param name="pDiagon2"/>
		<xsl:if test="$pUp">
			<!-- 
			<xsl:variable name="type" select="$pUp/@uof:线型"/>-->
			<xsl:variable name="type">
				<xsl:choose>
					<xsl:when test="$pUp/@线型_C60D">
						<xsl:value-of select="$pUp/@线型_C60D"/>
					</xsl:when>
					<!--xsl:when test="$pUp/@uof:类型">
						<xsl:value-of select="$pUp/@uof:类型"/>
					</xsl:when-->
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="size" select="concat($pUp/@宽度_C60F,$uofUnit,' ')"/>
			<xsl:variable name="clr" select="$pUp/@颜色_C611"/>
			<!-- alert staring 
			<xsl:attribute name="fo:padding-top"><xsl:value-of select="concat(string($pUp/@边距_C610),$uofUnit)"/></xsl:attribute>-->
			<xsl:if test="$pUp/@边距_C610">
				<xsl:attribute name="fo:padding-top"><xsl:value-of select="concat(string($pUp/@边距_C610),$uofUnit)"/></xsl:attribute>
			</xsl:if>
			<!-- alert ending. -->
			<xsl:attribute name="fo:border-top"><xsl:call-template name="UOFCommBorder"><xsl:with-param name="lineType" select="$type"/><xsl:with-param name="width" select="$size"/><xsl:with-param name="color" select="$clr"/></xsl:call-template></xsl:attribute>
			<xsl:if test="$type != 'none' and $type != 'single'">
				<xsl:attribute name="style:border-line-width-top"><xsl:call-template name="BorderLineWidth"><xsl:with-param name="aType" select="$type"/><xsl:with-param name="aSize" select="$pUp/@宽度_C60F"/></xsl:call-template></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$pDown">
			<xsl:variable name="type">
				<xsl:choose>
					<xsl:when test="$pDown/@线型_C60D">
						<xsl:value-of select="$pDown/@线型_C60D"/>
					</xsl:when>
					<!--xsl:when test="$pDown/@uof:类型">
						<xsl:value-of select="$pDown/@uof:类型"/>
					</xsl:when-->
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="size" select="concat(normalize-space(string($pDown/@宽度_C60F)),$uofUnit,' ')"/>
			<xsl:variable name="clr" select="$pDown/@颜色_C611"/>
			<xsl:attribute name="fo:padding-bottom"><xsl:value-of select="concat(string($pDown/@边距_C610),$uofUnit)"/></xsl:attribute>
			<xsl:attribute name="fo:border-bottom"><xsl:call-template name="UOFCommBorder"><xsl:with-param name="lineType" select="$type"/><xsl:with-param name="width" select="$size"/><xsl:with-param name="color" select="$clr"/></xsl:call-template></xsl:attribute>
			<xsl:if test="$type != 'none' and $type != 'single'">
				<xsl:attribute name="style:border-line-width-bottom"><xsl:call-template name="BorderLineWidth"><xsl:with-param name="aType" select="$type"/><xsl:with-param name="aSize" select="$pDown/@宽度_C60F"/></xsl:call-template></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$pLeft">
			<xsl:variable name="type">
				<xsl:choose>
					<xsl:when test="$pLeft/@线型_C60D">
						<xsl:value-of select="$pLeft/@线型_C60D"/>
					</xsl:when>
					<!--xsl:when test="$pLeft/@uof:类型">
						<xsl:value-of select="$pLeft/@uof:类型"/>
					</xsl:when-->
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="size" select="concat($pLeft/@宽度_C60F,$uofUnit,' ')"/>
			<xsl:variable name="clr" select="$pLeft/@颜色_C611"/>
			<xsl:attribute name="fo:padding-left"><xsl:value-of select="concat(string($pLeft/@边距_C610),$uofUnit)"/></xsl:attribute>
			<xsl:attribute name="fo:border-left"><xsl:call-template name="UOFCommBorder"><xsl:with-param name="lineType" select="$type"/><xsl:with-param name="width" select="$size"/><xsl:with-param name="color" select="$clr"/></xsl:call-template></xsl:attribute>
			<xsl:if test="$type != 'none' and $type != 'single'">
				<xsl:attribute name="style:border-line-width-left"><xsl:call-template name="BorderLineWidth"><xsl:with-param name="aType" select="$type"/><xsl:with-param name="aSize" select="$pLeft/@宽度_C60F"/></xsl:call-template></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$pRight">
			<xsl:variable name="type">
				<xsl:choose>
					<xsl:when test="$pRight/@线型_C60D">
						<xsl:value-of select="$pRight/@线型_C60D"/>
					</xsl:when>
					<!--xsl:when test="$pRight/@uof:类型">
						<xsl:value-of select="$pRight/@uof:类型"/>
					</xsl:when-->
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="size" select="concat($pRight/@宽度_C60F,$uofUnit,' ')"/>
			<xsl:variable name="clr" select="$pRight/@颜色_C611"/>
			<xsl:attribute name="fo:padding-right"><xsl:value-of select="concat(string($pRight/@边距_C610),$uofUnit)"/></xsl:attribute>
			<xsl:attribute name="fo:border-right"><xsl:call-template name="UOFCommBorder"><xsl:with-param name="lineType" select="$type"/><xsl:with-param name="width" select="$size"/><xsl:with-param name="color" select="$clr"/></xsl:call-template></xsl:attribute>
			<xsl:if test="$type != 'none' and $type != 'single'">
				<xsl:attribute name="style:border-line-width-right"><xsl:call-template name="BorderLineWidth"><xsl:with-param name="aType" select="$type"/><xsl:with-param name="aSize" select="$pRight/@宽度_C60F"/></xsl:call-template></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$pDiagon1">
			<xsl:variable name="type">
				<xsl:choose>
					<xsl:when test="$pDiagon1/@线型_C60D">
						<xsl:value-of select="$pDiagon1/@线型_C60D"/>
					</xsl:when>
					<!--xsl:when test="$pDiagon1/@uof:类型">
						<xsl:value-of select="$pDiagon1/@uof:类型"/>
					</xsl:when-->
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="size" select="concat($pDiagon1/@宽度_C60F,$uofUnit,' ')"/>
			<xsl:variable name="clr" select="$pDiagon1/@颜色_C611"/>
			<xsl:attribute name="style:diagonal-tl-br"><xsl:call-template name="UOFCommBorder"><xsl:with-param name="lineType" select="$type"/><xsl:with-param name="width" select="$size"/><xsl:with-param name="color" select="$clr"/></xsl:call-template></xsl:attribute>
			<xsl:if test="$type != 'none' and $type != 'single'">
				<xsl:attribute name="style:diagonal-tl-br-width"><xsl:call-template name="BorderLineWidth"><xsl:with-param name="aType" select="$type"/><xsl:with-param name="aSize" select="$pDiagon1/@宽度_C60F"/></xsl:call-template></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$pDiagon2">
			<xsl:variable name="type">
				<xsl:choose>
					<xsl:when test="$pDiagon2/@线型_C60D">
						<xsl:value-of select="$pDiagon2/@线型_C60D"/>
					</xsl:when>
					<!--xsl:when test="$pDiagon2/@uof:类型">
						<xsl:value-of select="$pDiagon2/@uof:类型"/>
					</xsl:when-->
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="size" select="concat($pDiagon2/@宽度_C60F,$uofUnit,' ')"/>
			<xsl:variable name="clr" select="$pDiagon2/@颜色_C611"/>
			<xsl:attribute name="style:diagonal-bl-tr"><xsl:call-template name="UOFCommBorder"><xsl:with-param name="lineType" select="$type"/><xsl:with-param name="width" select="$size"/><xsl:with-param name="color" select="$clr"/></xsl:call-template></xsl:attribute>
			<xsl:if test="$type != 'none' and $type != 'single'">
				<xsl:attribute name="style:diagonal-bl-tr-width"><xsl:call-template name="BorderLineWidth"><xsl:with-param name="aType" select="$type"/><xsl:with-param name="aSize" select="$pDiagon2/@宽度_C60F"/></xsl:call-template></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<!--兼容错误案例，案例将字符串'true'写为'ture'-->
		<xsl:if test="$pUp/@是否加阴影_C612='true'or $pUp/@是否加阴影_C612='1'">
			<xsl:if test="$pLeft/@是否加阴影_C612='true'or $pLeft/@是否加阴影_C612='1' or $pLeft/@是否加阴影_C612='ture'">
				<xsl:attribute name="style:shadow">#808080 -0.18cm -0.18cm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$pUp/@是否加阴影_C612='true'or $pUp/@是否加阴影_C612='1' or $pUp/@是否加阴影_C612='ture'">
			<xsl:if test="$pRight/@是否加阴影_C612='true'or $pRight/@是否加阴影_C612='1' or $pRight/@是否加阴影_C612='ture'">
				<xsl:attribute name="style:shadow">#808080 0.18cm -0.18cm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$pDown/@是否加阴影_C612='true'or $pDown/@是否加阴影_C612='1' or $pDown/@是否加阴影_C612='ture'">
			<xsl:if test="$pLeft/@是否加阴影_C612='true'or $pLeft/@是否加阴影_C612='1' or $pLeft/@是否加阴影_C612='ture'">
				<xsl:attribute name="style:shadow">#808080 -0.18cm 0.18cm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$pDown/@是否加阴影_C612='true'or $pDown/@是否加阴影_C612='1' or $pDown/@是否加阴影_C612='ture'">
			<xsl:if test="$pRight/@是否加阴影_C612='true'or $pRight/@是否加阴影_C612='1' or $pRight/@是否加阴影_C612='ture'">
				<xsl:attribute name="style:shadow">#808080 0.18cm 0.18cm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="CommonFillAttr">
		<xsl:choose>
			<xsl:when test="图:颜色_8004">
				<xsl:attribute name="fo:background-color"><xsl:value-of select="string(图:颜色_8004)"/></xsl:attribute>
			</xsl:when>
			<xsl:when test="图:图片_8005">
				<xsl:attribute name="fo:background-color"><xsl:value-of select="string('transprent')"/></xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="CommonFillElement">
		<xsl:choose>
			<xsl:when test="图:图案_800A">
				<style:background-image>
					<xsl:for-each select="图:图案_800A">
						<xsl:call-template name="BinaryData"/>
					</xsl:for-each>
				</style:background-image>
			</xsl:when>
			<xsl:when test="图:渐变_800D">
				<xsl:element name="style:background-gradient">
					<xsl:attribute name="draw:name">Background-Gradient</xsl:attribute>
					<xsl:attribute name="draw:style"><xsl:choose><xsl:when test="图:渐变_800D/@种子类型_8010='linear'"><xsl:value-of select="'linear'"/></xsl:when><xsl:when test="图:渐变_800D/@种子类型_8010='radar'"><xsl:value-of select="'radial'"/></xsl:when><xsl:when test="图:渐变_800D/@种子类型_8010='oval'"><xsl:value-of select="'ellipsoid'"/></xsl:when><xsl:when test="图:渐变_800D/@种子类型_8010='square'"><xsl:value-of select="'square'"/></xsl:when><xsl:when test="图:渐变_800D/@种子类型_8010='rectangle'"><xsl:value-of select="'rectangular'"/></xsl:when></xsl:choose></xsl:attribute>
					<xsl:attribute name="draw:start-color"><xsl:value-of select="图:渐变_800D/@起始色_800E"/></xsl:attribute>
					<xsl:attribute name="draw:end-color"><xsl:value-of select="图:渐变_800D/@终止色_800F"/></xsl:attribute>
					<xsl:attribute name="draw:start-intensity"><xsl:value-of select="concat(图:渐变_800D/@起始浓度_8011,'%')"/></xsl:attribute>
					<xsl:attribute name="draw:end-intensity"><xsl:value-of select="concat(图:渐变_800D/@终止浓度_8012,'%')"/></xsl:attribute>
					<xsl:attribute name="draw:angle"><xsl:value-of select="number(图:渐变_800D/@渐变方向_8013) * 10"/></xsl:attribute>
					<xsl:attribute name="draw:border"><xsl:value-of select="concat(图:渐变_800D/@边界_8014,'%')"/></xsl:attribute>
					<xsl:if test="图:渐变_800D/@种子X位置_8015">
						<xsl:attribute name="draw:cx"><xsl:value-of select="concat(图:渐变_800D/@种子X位置_8015,'%')"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="图:渐变_800D/@种子Y位置_8016">
						<xsl:attribute name="draw:cy"><xsl:value-of select="concat(图:渐变_800D/@种子Y位置_8016,'%')"/></xsl:attribute>
					</xsl:if>
				</xsl:element>
			</xsl:when>
			<xsl:when test="图:图片_8005">
				<xsl:element name="style:background-image">
					<xsl:variable name="gid">
						<xsl:value-of select="图:图片_8005/@图形引用_8007"/>
					</xsl:variable>
					<xsl:if test="图:图片_8005/@位置_8006 and not(图:图片_8005/@位置_8006='tile')">
						<xsl:if test="图:图片_8005/@位置_8006='stretch'">
							<xsl:attribute name="style:repeat">stretch</xsl:attribute>
						</xsl:if>
						<xsl:if test="图:图片_8005/@位置_8006='center'">
							<xsl:attribute name="style:position"><xsl:value-of select="'center'"/></xsl:attribute>
							<xsl:attribute name="style:repeat">no-repeat</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<!--<xsl:choose>
						<xsl:when test="/uof:UOF_0000/对象:对象数据集_D700/对象:对象数据集_D701[@uof:标识符=$gid]/对象:数据_D702">
							<xsl:element name="office:binary-data">
								<xsl:value-of select="/uof:UOF_0000/对象:对象数据集_D700/对象:对象数据集_D701[@uof:标识符=$gid]/对象:数据_D702"/>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="xlink:href"><xsl:value-of select="/uof:UOF_0000/对象:对象数据集_D700/对象:对象数据集_D701[@uof:标识符=$gid]/对象:路径_D703"/></xsl:attribute>
							<xsl:attribute name="xlink:type">simple</xsl:attribute>
							<xsl:attribute name="xlink:actuate">onLoad</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>-->
					<xsl:if test="图:图片_8005/@图形引用_8007">
						<xsl:choose>
							<xsl:when test="key('other-styles',图:图片_8005/@图形引用_8007)/对象:路径_D703">
								<xsl:attribute name="xlink:href"><xsl:value-of select="concat('Pictures/',substring-after(key('other-styles',图:图片_8005/@图形引用_8007)/对象:路径_D703,'/'))"/></xsl:attribute>
							</xsl:when>
							<xsl:when test="key('other-styles',图:图片_8005/@图形引用_8007)/对象:数据_D702">
								<xsl:element name="office:binary-data">
									<xsl:value-of select="key('other-styles',图:图片_8005/@图形引用_8007)/对象:数据_D702"/>
								</xsl:element>
								<!--<xsl:call-template name="BinaryGraphic">
									<xsl:with-param name="refGraphic" select="图:图片_8005/@图形引用_8007"/>
								</xsl:call-template>-->
							</xsl:when>
						</xsl:choose>
					</xsl:if>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="CommonFill">
		<xsl:call-template name="CommonFillAttr"/>
		<xsl:call-template name="CommonFillElement"/>
	</xsl:template>
	<!--<xsl:template name="FindMasterColorSetName">
		<xsl:for-each select="..">
			<xsl:choose>
				<xsl:when test="name(.) = '演:幻灯片'">
					<xsl:variable name="mastername" select="@演:母版引用"/>
					<xsl:value-of select="key('SlideMaster',$mastername)/@演:配色方案引用"/>
				</xsl:when>
				<xsl:when test="name(.) = '演:母版'">
					<xsl:value-of select="@演:配色方案引用"/>
				</xsl:when>
				<xsl:when test="name(.) = '演:主体'">
					<xsl:value-of select="'none'"/>
				</xsl:when>
				<xsl:when test="name(.) = 'uof:UOF_0000'">
					<xsl:value-of select="'none'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="FindMasterColorSetName"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>-->
	<xsl:template name="PresentationColorSet">
		<xsl:if test="$document_type = 'presentation'">
			<xsl:variable name="colorsetname">
				<xsl:for-each select="key('rel_graphic_name',../../../@标识符_804B)">
					<xsl:choose>
						<xsl:when test="ancestor::演:幻灯片_6C0F">
							<xsl:variable name="mastername" select="ancestor::演:幻灯片_6C0F/@母版引用_6B26"/>
							<xsl:value-of select="key('SlideMaster',$mastername)/@配色方案引用_6C12"/>
						</xsl:when>
						<xsl:when test="ancestor::演:母版_6C0D">
							<xsl:value-of select="ancestor::演:母版_6C0D/@配色方案引用_6C12"/>
						</xsl:when>
						<xsl:otherwise>none</xsl:otherwise>
					</xsl:choose>
					<!--<xsl:call-template name="FindMasterColorSetName"/>-->
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="colorset" select="/uof:UOF_0000/演:演示文稿文档_6C10/演:母版集_6C0C/演:母版_6C0D/演:配色方案集/演:配色方案[@演:标识符 = $colorsetname]"/>
			<xsl:if test="$colorset != ''">
				<xsl:choose>
					<xsl:when test="name(.) = '图:填充'">
						<xsl:attribute name="draw:fill">solid</xsl:attribute>
						<xsl:attribute name="draw:fill-color"><xsl:value-of select="$colorset/演:填充"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="name(.) = '演:背景'">
						<xsl:attribute name="draw:fill">solid</xsl:attribute>
						<xsl:attribute name="draw:fill-color"><xsl:value-of select="$colorset/演:背景色"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="name(.) = '表:填充'">
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="FillGraph">
		<xsl:param name="par_DefaultColor" select="''"/>
		<xsl:choose>
			<xsl:when test="图:颜色_8004">
				<xsl:if test="图:颜色_8004 = 'auto'">
					<xsl:choose>
						<xsl:when test="$document_type = 'presentation'">
							<xsl:call-template name="PresentationColorSet"/>
						</xsl:when>
						<xsl:when test="$document_type = 'spreadsheet'">
							<xsl:if test="string($par_DefaultColor) != ''">
								<xsl:attribute name="draw:fill">solid</xsl:attribute>
								<xsl:attribute name="draw:fill-color" select="$par_DefaultColor"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="draw:fill">solid</xsl:attribute>
							<!--xsl:attribute name="draw:fill-color">#005998</xsl:attribute-->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="图:颜色_8004 != 'auto'">
					<xsl:attribute name="draw:fill">solid</xsl:attribute>
					<xsl:attribute name="draw:fill-color"><xsl:value-of select="图:颜色_8004"/></xsl:attribute>
					<xsl:attribute name="fo:background-color"><xsl:value-of select="图:颜色_8004"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:when test="图:图案_800A">
				<xsl:variable name="isprename">
					<xsl:variable name="prefix" select="substring(图:图案_800A/@类型_8008,1,4)"/>
					<xsl:choose>
						<xsl:when test="$prefix= 'ptn0'">true</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="false"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$isprename='true'">
						<xsl:variable name="hatchname">
							<xsl:choose>
								<xsl:when test="图:图案_800A/@类型_8008 = 'ptn001' and 图:图案_800A/@前景色_800B = '#ff78bd'">ptn001_5f_ff78db</xsl:when>
								<xsl:when test="图:图案_800A/@类型_8008 = 'ptn001' and 图:图案_800A/@前景色_800B = '#0000ff'">Bitmape_20_2</xsl:when>
								<xsl:when test="图:图案_800A/@类型_8008 = 'ptn043' and 图:图案_800A/@前景色_800B = '#ffffff' and 图:图案_800A/@背景色_800C = '#ff0000'">ptn043_red</xsl:when>
								<xsl:when test="图:图案_800A/@类型_8008 = 'ptn044' and 图:图案_800A/@前景色_800B = '#ffffff' and 图:图案_800A/@背景色_800C = '#ff0000'">ptn044_red</xsl:when>
								<xsl:when test="substring('图:图案_800A/@类型_8008',1,4) = 'ptn0'">图:图案_800A/@类型_8008</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="图:图案_800A/@类型_8008"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:attribute name="draw:fill-image-name"><xsl:value-of select="$hatchname"/></xsl:attribute>
						<xsl:attribute name="draw:fill">bitmap</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<!--<xsl:attribute name="draw:fill-hatch-name"><xsl:value-of select="图:图案_800A/@类型_8008"/></xsl:attribute>
						<xsl:attribute name="draw:fill">hatch</xsl:attribute>
						<xsl:attribute name="draw:fill-color"><xsl:value-of select="图:图案_800A/@背景色_800C"/></xsl:attribute>
						<xsl:attribute name="draw:fill-hatch-solid"><xsl:choose><xsl:when test="图:图案_800A/@背景色_800C">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>-->
						<xsl:attribute name="draw:fill-image-name"><xsl:value-of select="'ptnwrong'"/></xsl:attribute>
						<xsl:attribute name="draw:fill">bitmap</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="图:渐变_800D">
				<xsl:attribute name="draw:fill">gradient</xsl:attribute>
				<xsl:attribute name="draw:fill-color"><xsl:value-of select="图:渐变_800D/@起始色_800E"/></xsl:attribute>
				<!--
				<xsl:choose>
					<xsl:when test="图:渐变_800D/@类型_8008">
						<xsl:attribute name="draw:fill-gradient-name"><xsl:value-of select="图:渐变_800D/@类型_8008"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="draw:fill-gradient-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				-->
				<xsl:attribute name="draw:fill-gradient-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
			</xsl:when>
			<xsl:when test="图:图片_8005">
				<xsl:attribute name="draw:fill">bitmap</xsl:attribute>
				<xsl:attribute name="draw:fill-image-name"><xsl:value-of select="图:图片_8005/@图形引用_8007"/></xsl:attribute>
				<xsl:if test="图:图片_8005/@位置_8006">
					<xsl:attribute name="style:repeat"><xsl:choose><xsl:when test="图:图片_8005/@位置_8006='center'">no-repeat</xsl:when><xsl:when test="图:图片_8005/@位置_8006='stretch'">stretch</xsl:when><xsl:otherwise>repeat</xsl:otherwise></xsl:choose></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="draw:fill">none</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--xsl:template name="IsPrecedeType">
		<xsl:param name="nodename"/>
		<xsl:param name="pos"/>
		<xsl:for-each select="preceding-sibling::node()[1]">
			<xsl:choose>
				<xsl:when test="self::node()[name(.) = $nodename] and 字:节属性/字:节类型 != 'continuous'">
					<xsl:value-of select="$pos+1"/>
				</xsl:when>
				<xsl:when test="self::*[name(.)='']">
					<xsl:call-template name="IsPrecedeType">
						<xsl:with-param name="nodename" select="$nodename"/>
						<xsl:with-param name="pos" select="$pos+1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number('0')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template-->
	<xsl:template name="NumberFormat">
		<xsl:param name="oo_format"/>
		<xsl:choose>
			<xsl:when test="$oo_format='upper-roman'">I</xsl:when>
			<xsl:when test="$oo_format='lower-roman'">i</xsl:when>
			<xsl:when test="$oo_format='upper-letter'">A</xsl:when>
			<xsl:when test="$oo_format='lower-letter'">a</xsl:when>
			<xsl:when test="$oo_format='decimal-full-width' or $oo_format='decimal-enclosed-fullstop'">１, ２, ３, ...</xsl:when>
			<xsl:when test="$oo_format='decimal-enclosed-circle'">①, ②, ③, ...</xsl:when>
			<xsl:when test="$oo_format='chinese-counting'">一, 二, 三, ...</xsl:when>
			<xsl:when test="$oo_format='chinese-legal-simplified'">壹, 贰, 叁, ...</xsl:when>
			<xsl:when test="$oo_format='ideograph-traditional'">甲, 乙, 丙, ...</xsl:when>
			<xsl:when test="$oo_format='ideograph-zodiac'">子, 丑, 寅, ...</xsl:when>
			<xsl:when test="$oo_format='ordinal'">1st</xsl:when>
			<xsl:when test="$oo_format='cardinal-text'">one</xsl:when>
			<xsl:when test="$oo_format='ordinal-text'">first</xsl:when>
			<xsl:when test="$oo_format='decimal-enclosed-circle-chinese'">①, ②, ③, ...</xsl:when>
			<xsl:when test="$oo_format='ideograph-enclosed-circle'">㈠, ㈡, ㈢, ...</xsl:when>
			<!--otherwise中包含decimal，decimal-enclosed-paren-->
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="NumStyleElementAttribute">
		<xsl:param name="number-format-code"/>
		<xsl:if test="contains($number-format-code,'[hh]')">
			<xsl:attribute name="number:truncate-on-overflow">false</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with($number-format-code,'[natnum1]')">
			<xsl:attribute name="number:transliteration-format">一</xsl:attribute>
			<xsl:attribute name="number:transliteration-style">short</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with($number-format-code,'[natnum2]')">
			<xsl:attribute name="number:transliteration-format">壹</xsl:attribute>
			<xsl:attribute name="number:transliteration-style">short</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with($number-format-code,'[natnum3]')">
			<xsl:attribute name="number:transliteration-format">１</xsl:attribute>
			<xsl:attribute name="number:transliteration-style">short</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with($number-format-code,'[natnum4]')">
			<xsl:attribute name="number:transliteration-format">一</xsl:attribute>
			<xsl:attribute name="number:transliteration-style">long</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with($number-format-code,'[natnum5]')">
			<xsl:attribute name="number:transliteration-format">壹</xsl:attribute>
			<xsl:attribute name="number:transliteration-style">long</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with($number-format-code,'[natnum6]')">
			<xsl:attribute name="number:transliteration-format">１</xsl:attribute>
			<xsl:attribute name="number:transliteration-style">long</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with($number-format-code,'[natnum7]')">
			<xsl:attribute name="number:transliteration-format">一</xsl:attribute>
			<xsl:attribute name="number:transliteration-style">medium</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with($number-format-code,'[natnum8]')">
			<xsl:attribute name="number:transliteration-format">壹</xsl:attribute>
			<xsl:attribute name="number:transliteration-style">medium</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with($number-format-code,'[natnum0]')">
			<xsl:attribute name="number:transliteration-format">1</xsl:attribute>
			<xsl:attribute name="number:transliteration-style">short</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with($number-format-code,'[dbnum1]')">
			<xsl:attribute name="number:transliteration-format">一</xsl:attribute>
			<xsl:attribute name="number:transliteration-style">long</xsl:attribute>
			<xsl:attribute name="number:transliteration-language">zh</xsl:attribute>
			<xsl:attribute name="number:transliteration-country">CN</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with($number-format-code,'[dbnum2]')">
			<xsl:attribute name="number:transliteration-format">壹</xsl:attribute>
			<xsl:attribute name="number:transliteration-style">long</xsl:attribute>
			<xsl:attribute name="number:transliteration-language">zh</xsl:attribute>
			<xsl:attribute name="number:transliteration-country">CN</xsl:attribute>
		</xsl:if>
		<xsl:if test="contains($number-format-code,'[$-804]')">
			<xsl:attribute name="number:transliteration-language">zh</xsl:attribute>
			<xsl:attribute name="number:transliteration-country">CN</xsl:attribute>
		</xsl:if>
		<xsl:if test="contains($number-format-code,'上午/下午')">
			<xsl:attribute name="number:language">zh</xsl:attribute>
			<xsl:attribute name="number:country">CN</xsl:attribute>
		</xsl:if>
		<xsl:if test="contains($number-format-code,'am/pm')">
			<xsl:attribute name="number:language">en</xsl:attribute>
			<xsl:attribute name="number:country">US</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="StyleMap">
		<xsl:param name="number-format-name"/>
		<xsl:param name="number-format-code"/>
		<xsl:param name="style-id"/>
		<xsl:param name="total-unit"/>
		<xsl:param name="current-unit"/>
		<xsl:if test="$current-unit &lt; ($total-unit -1)">
			<xsl:variable name="stylecondition">
				<xsl:choose>
					<xsl:when test="$total-unit &gt;= 3">
						<xsl:if test="$current-unit = 0">
							<xsl:value-of select="'value()&gt;0'"/>
						</xsl:if>
						<xsl:if test="$current-unit = 1">
							<xsl:value-of select="'value()&lt;0'"/>
						</xsl:if>
						<xsl:if test="$current-unit = 2">
							<xsl:value-of select="'value()=0'"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$total-unit = 2">
						<xsl:value-of select="'value()&gt;=0'"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<style:map style:condition="{$stylecondition}" style:apply-style-name="{concat( $style-id, 'P',$current-unit)}"/>
			<xsl:call-template name="StyleMap">
				<xsl:with-param name="number-format-name" select="$number-format-name"/>
				<xsl:with-param name="number-format-code" select="substring-after($number-format-code,';')"/>
				<xsl:with-param name="style-id" select="$style-id"/>
				<xsl:with-param name="total-unit" select="$total-unit"/>
				<xsl:with-param name="current-unit" select="$current-unit +1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="DecimalIntExponentFraction">
		<xsl:param name="digits-part"/>
		<xsl:variable name="decimal-digits">
			<xsl:choose>
				<xsl:when test="contains($digits-part,'.')">
					<xsl:choose>
						<xsl:when test="contains($digits-part,' ') and not(contains($digits-part,'_'))">
							<xsl:value-of select="string-length(substring-before(substring-after($digits-part,'.'),' '))"/>
						</xsl:when>
						<xsl:when test="contains(substring-after($digits-part,'.'),',')">
							<xsl:value-of select="string-length(substring-before(substring-after($digits-part,'.'),','))"/>
						</xsl:when>
						<xsl:when test="contains($digits-part,'e')">
							<xsl:value-of select="string-length(substring-before(substring-after($digits-part,'.'),'e'))"/>
						</xsl:when>
						<xsl:when test="contains(substring-after($digits-part,'.'),'_')">
							<xsl:value-of select="string-length(substring-before(substring-after($digits-part,'.'),'_'))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="contains($digits-part,'%')">
									<xsl:value-of select="string-length(substring-after($digits-part,'.')) - 1"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="string-length(substring-after($digits-part,'.'))"/>
								</xsl:otherwise>
							</xsl:choose>
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
			<xsl:call-template name="DisplayFactorDigits">
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
	<xsl:template name="DisplayFactorDigits">
		<xsl:param name="digits-part"/>
		<xsl:param name="count"/>
		<xsl:choose>
			<xsl:when test="not(substring($digits-part,string-length($digits-part),1) =',')">
				<xsl:value-of select="$count"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="DisplayFactorDigits">
					<xsl:with-param name="digits-part" select="substring($digits-part,1,string-length($digits-part) -1)"/>
					<xsl:with-param name="count" select="$count + 1"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GeneralNumberStyle">
		<xsl:param name="number-format-code"/>
		<xsl:param name="month-minute"/>
		<!--xsl:choose-->
		<xsl:if test="string-length($number-format-code) != 0">
			<xsl:choose>
				<xsl:when test="starts-with($number-format-code,'[')">
					<xsl:call-template name="ProcessSquareBracket">
						<xsl:with-param name="number-format-code" select="substring($number-format-code,2)"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'g/通用格式') or starts-with($number-format-code,'general')">
					<number:number number:min-integer-digits="1" number:decimal-places="6" number:decimal-replacement=""/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'&quot;')">
					<number:text>
						<xsl:value-of select="substring-before(substring-after($number-format-code,'&quot;'),'&quot;')"/>
					</number:text>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'@')">
					<number:text-content/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'yyyy')">
					<number:year number:style="long"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'yy')">
					<number:year number:style="short"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'kkkkro')">
					<number:year number:style="rolong"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'mmmm')">
					<number:month number:style="long" number:textual="true"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'mmm')">
					<number:month number:style="rolong" number:textual="true"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'mro')">
					<number:month number:style="rolong" number:textual="true"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'mm')">
					<xsl:choose>
						<xsl:when test="contains($number-format-code,'s') or starts-with($month-minute,'min')">
							<number:minutes number:style="long"/>
						</xsl:when>
						<xsl:otherwise>
							<number:month number:style="long"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'m')">
					<xsl:choose>
						<xsl:when test="contains($number-format-code,'s') or starts-with($month-minute,'min')">
							<number:minutes number:style="short"/>
						</xsl:when>
						<xsl:otherwise>
							<number:month number:style="short"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'dro')">
					<number:day number:style="rolong"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'dd')">
					<number:day number:style="long"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'d')">
					<number:day number:style="short"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'hh')">
					<number:hours number:style="long"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'h')">
					<number:hours/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'ss.00')">
					<number:seconds number:style="long" number:decimal-places="2"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'ss')">
					<number:seconds number:style="long"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'s')">
					<number:seconds/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'am/pm') or starts-with($number-format-code,'上午/下午')">
					<number:am-pm/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'nnnn')">
					<number:day-of-week number:style="long"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'nnn')">
					<number:day-of-week/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'qq')">
					<number:quarter number:style="long"/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'q')">
					<number:quarter/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'ww')">
					<number:week-of-year/>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'cny')">
					<number:currency-symbol>CNY</number:currency-symbol>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'ccc')">
					<number:currency-symbol>CCC</number:currency-symbol>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'#') or starts-with($number-format-code,'0') or starts-with($number-format-code,'?')">
					<xsl:variable name="digits-part">
						<xsl:choose>
							<xsl:when test="contains($number-format-code,'&quot;')">
								<xsl:value-of select="substring-before($number-format-code,'&quot;')"/>
							</xsl:when>
							<xsl:when test="contains($number-format-code,')')">
								<xsl:value-of select="substring-before($number-format-code,')')"/>
							</xsl:when>
							<xsl:when test="contains($number-format-code,'_') and substring(substring-after($number-format-code,'_'),2,1) != 'e'">
								<xsl:value-of select="substring-before($number-format-code,'_')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$number-format-code"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:call-template name="DecimalIntExponentFraction">
						<xsl:with-param name="digits-part" select="$digits-part"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="starts-with($number-format-code,'_')">
					<xsl:if test="substring($number-format-code,2,1) != '￥'">
						<number:text>
							<xsl:value-of select="' '"/>
						</number:text>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(starts-with($number-format-code,'_')) and not(starts-with($number-format-code,'*'))">
						<number:text>
							<xsl:value-of select="substring($number-format-code,1,1)"/>
						</number:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:variable name="unit-length">
				<xsl:choose>
					<xsl:when test="starts-with($number-format-code,'[')">
						<xsl:value-of select="string-length(substring-before($number-format-code,']')) + 2"/>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'g/通用格式')">
						<xsl:value-of select="7"/>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'&quot;')">
						<xsl:value-of select="string-length(substring-before(substring-after($number-format-code,'&quot;'),'&quot;')) +3"/>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'yyyy')">5</xsl:when>
					<xsl:when test="starts-with($number-format-code,'yy')">3</xsl:when>
					<xsl:when test="starts-with($number-format-code,'kkkkro')">7</xsl:when>
					<xsl:when test="starts-with($number-format-code,'mmmm')">5</xsl:when>
					<xsl:when test="starts-with($number-format-code,'mmm')">4</xsl:when>
					<xsl:when test="starts-with($number-format-code,'mm')">3</xsl:when>
					<xsl:when test="starts-with($number-format-code,'mro')">4</xsl:when>
					<xsl:when test="starts-with($number-format-code,'dd')">3</xsl:when>
					<xsl:when test="starts-with($number-format-code,'dro')">4</xsl:when>
					<xsl:when test="starts-with($number-format-code,'hh')">3</xsl:when>
					<xsl:when test="starts-with($number-format-code,'ss.00')">6</xsl:when>
					<xsl:when test="starts-with($number-format-code,'ss')">3</xsl:when>
					<xsl:when test="starts-with($number-format-code,'am/pm')">6</xsl:when>
					<xsl:when test="starts-with($number-format-code,'上午/下午')">6</xsl:when>
					<xsl:when test="starts-with($number-format-code,'nnnn')">5</xsl:when>
					<xsl:when test="starts-with($number-format-code,'nnn')">4</xsl:when>
					<xsl:when test="starts-with($number-format-code,'qqro')">5</xsl:when>
					<xsl:when test="starts-with($number-format-code,'qq')">3</xsl:when>
					<xsl:when test="starts-with($number-format-code,'ww')">3</xsl:when>
					<xsl:when test="starts-with($number-format-code,'cny')">4</xsl:when>
					<xsl:when test="starts-with($number-format-code,'ccc')">4</xsl:when>
					<xsl:when test="starts-with($number-format-code,'#') or starts-with($number-format-code,'0') or starts-with($number-format-code,'?')">
						<xsl:choose>
							<xsl:when test="contains($number-format-code,'&quot;')">
								<xsl:value-of select="string-length(substring-before($number-format-code,'&quot;')) + 1"/>
							</xsl:when>
							<xsl:when test="contains($number-format-code,'_') and substring(substring-after($number-format-code,'_'),2,1) != 'e'">
								<xsl:value-of select="string-length(substring-before($number-format-code,'_')) + 1"/>
							</xsl:when>
							<xsl:when test="contains($number-format-code,')')">
								<xsl:value-of select="string-length(substring-before($number-format-code,')')) + 1"/>
							</xsl:when>
							<xsl:when test="contains($number-format-code,'%')">
								<xsl:value-of select="string-length(substring-before($number-format-code,'%')) + 1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="string-length($number-format-code) + 1"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'_')">
						<xsl:if test="substring($number-format-code,2,1) != '￥'">
							<xsl:value-of select="3"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$number-format-code= 'general'">1</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="monthORminute">
				<xsl:choose>
					<xsl:when test="starts-with($number-format-code,'h') or starts-with($number-format-code,'[h') or $month-minute = 'minute'">
						<xsl:value-of select="'minute'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'month'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$unit-length &gt; 1">
				<xsl:call-template name="GeneralNumberStyle">
					<xsl:with-param name="number-format-code" select="substring($number-format-code,$unit-length)"/>
					<xsl:with-param name="month-minute" select="string($monthORminute)"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!--xsl:otherwise>
				<number:number number:min-integer-digits="1" number:decimal-places="6" number:decimal-replacement=""/>
			</xsl:otherwise>
		</xsl:choose-->
	</xsl:template>
	<xsl:template name="ProcessSquareBracket">
		<xsl:param name="number-format-code"/>
		<xsl:choose>
			<xsl:when test="starts-with($number-format-code,'$')">
				<xsl:choose>
					<xsl:when test="starts-with($number-format-code,'$￥-804')">
						<number:currency-symbol number:language="zh" number:country="CN">￥</number:currency-symbol>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'$us$-804')">
						<number:currency-symbol number:language="zh" number:country="CN">US$</number:currency-symbol>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'$$-409')">
						<number:currency-symbol number:language="en" number:country="US">$</number:currency-symbol>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'$$-2c0a')">
						<number:currency-symbol number:language="es" number:country="AR">$</number:currency-symbol>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'$$-c0c')">
						<number:currency-symbol number:language="fr" number:country="CA">$</number:currency-symbol>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'$cny')">
						<number:currency-symbol>CNY</number:currency-symbol>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'$afa')">
						<number:currency-symbol>AFA</number:currency-symbol>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="starts-with($number-format-code,'black') or starts-with($number-format-code,'黑色')">
						<style:text-properties fo:color="#000000"/>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'blue') or starts-with($number-format-code,'蓝色')">
						<style:text-properties fo:color="#0000ff"/>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'cyan') or starts-with($number-format-code,'蓝绿色')">
						<style:text-properties fo:color="#00ffff"/>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'green') or starts-with($number-format-code,'绿色')">
						<style:text-properties fo:color="#00ff00"/>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'magenta') or starts-with($number-format-code,'洋红色')">
						<style:text-properties fo:color="#ff00ff"/>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'red') or starts-with($number-format-code,'红色')">
						<style:text-properties fo:color="#ff0000"/>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'white') or starts-with($number-format-code,'白色')">
						<style:text-properties fo:color="#ffffff"/>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'yellow') or starts-with($number-format-code,'黄色')">
						<style:text-properties fo:color="#ffff00"/>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'hh')">
						<number:hours number:style="long"/>
					</xsl:when>
					<xsl:when test="starts-with($number-format-code,'h')">
						<number:hours/>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ProcessNumberStyle">
		<xsl:param name="number-format-name"/>
		<xsl:param name="number-format-code"/>
		<xsl:param name="style-id"/>
		<xsl:param name="total-unit"/>
		<xsl:param name="current-unit"/>
		<xsl:choose>
			<xsl:when test="$current-unit &lt; ($total-unit -1)">
				<xsl:element name="{concat('number:',$number-format-name,'-style')}">
					<xsl:attribute name="style:name"><xsl:value-of select="concat( $style-id, 'P',$current-unit)"/></xsl:attribute>
					<xsl:attribute name="style:volatile">true</xsl:attribute>
					<xsl:call-template name="GeneralNumberStyle">
						<xsl:with-param name="number-format-code" select="substring-before($number-format-code,';')"/>
					</xsl:call-template>
				</xsl:element>
				<xsl:call-template name="ProcessNumberStyle">
					<xsl:with-param name="number-format-name" select="$number-format-name"/>
					<xsl:with-param name="number-format-code" select="substring-after($number-format-code,';')"/>
					<xsl:with-param name="style-id" select="$style-id"/>
					<xsl:with-param name="total-unit" select="$total-unit"/>
					<xsl:with-param name="current-unit" select="$current-unit + 1"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{concat('number:',$number-format-name,'-style')}">
					<xsl:attribute name="style:name"><xsl:value-of select="$style-id"/></xsl:attribute>
					<xsl:call-template name="NumStyleElementAttribute">
						<xsl:with-param name="number-format-code" select="string($number-format-code)"/>
					</xsl:call-template>
					<xsl:call-template name="GeneralNumberStyle">
						<xsl:with-param name="number-format-code" select="string($number-format-code)"/>
					</xsl:call-template>
					<xsl:call-template name="StyleMap">
						<xsl:with-param name="number-format-name" select="@分类名称_E740"/>
						<xsl:with-param name="number-format-code" select="@格式码_E73F"/>
						<xsl:with-param name="style-id" select="$style-id"/>
						<xsl:with-param name="total-unit" select="$total-unit"/>
						<xsl:with-param name="current-unit" select="0"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="NumberStyle">
		<xsl:param name="style-id"/>
		<xsl:variable name="unit-count" select="string-length(@格式码_E73F) - string-length(translate(@格式码_E73F,';','')) + 1"/>
		<xsl:variable name="number-format-name">
			<xsl:choose>
				<xsl:when test="@分类名称_E740='number'">number</xsl:when>
				<xsl:when test="@分类名称_E740='currency' or @分类名称_E740='accounting'">currency</xsl:when>
				<xsl:when test="@分类名称_E740='date'">date</xsl:when>
				<xsl:when test="@分类名称_E740='time'">time</xsl:when>
				<xsl:when test="@分类名称_E740='percentage'">percentage</xsl:when>
				<xsl:when test="@分类名称_E740='text'">text</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'number'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="ProcessNumberStyle">
			<xsl:with-param name="number-format-name" select="$number-format-name"/>
			<xsl:with-param name="number-format-code" select="fn:lower-case(@格式码_E73F)"/>
			<xsl:with-param name="style-id" select="concat($style-id,'F')"/>
			<xsl:with-param name="total-unit" select="$unit-count"/>
			<xsl:with-param name="current-unit" select="0"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="character-to-number">
		<xsl:param name="character"/>
		<xsl:choose>
			<xsl:when test="$character = 'A'">1</xsl:when>
			<xsl:when test="$character = 'B'">2</xsl:when>
			<xsl:when test="$character = 'C'">3</xsl:when>
			<xsl:when test="$character = 'D'">4</xsl:when>
			<xsl:when test="$character = 'E'">5</xsl:when>
			<xsl:when test="$character = 'F'">6</xsl:when>
			<xsl:when test="$character = 'G'">7</xsl:when>
			<xsl:when test="$character = 'H'">8</xsl:when>
			<xsl:when test="$character = 'I'">9</xsl:when>
			<xsl:when test="$character = 'J'">10</xsl:when>
			<xsl:when test="$character = 'K'">11</xsl:when>
			<xsl:when test="$character = 'L'">12</xsl:when>
			<xsl:when test="$character = 'M'">13</xsl:when>
			<xsl:when test="$character = 'N'">14</xsl:when>
			<xsl:when test="$character = 'O'">15</xsl:when>
			<xsl:when test="$character = 'P'">16</xsl:when>
			<xsl:when test="$character = 'Q'">17</xsl:when>
			<xsl:when test="$character = 'R'">18</xsl:when>
			<xsl:when test="$character = 'S'">19</xsl:when>
			<xsl:when test="$character = 'T'">20</xsl:when>
			<xsl:when test="$character = 'U'">21</xsl:when>
			<xsl:when test="$character = 'V'">22</xsl:when>
			<xsl:when test="$character = 'W'">23</xsl:when>
			<xsl:when test="$character = 'X'">24</xsl:when>
			<xsl:when test="$character = 'Y'">25</xsl:when>
			<xsl:when test="$character = 'Z'">26</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="number-to-character">
		<xsl:param name="number"/>
		<xsl:choose>
			<xsl:when test="$number = 0"/>
			<xsl:when test="$number = 1">A</xsl:when>
			<xsl:when test="$number = 2">B</xsl:when>
			<xsl:when test="$number = 3">C</xsl:when>
			<xsl:when test="$number = 4">D</xsl:when>
			<xsl:when test="$number = 5">E</xsl:when>
			<xsl:when test="$number = 6">F</xsl:when>
			<xsl:when test="$number = 7">G</xsl:when>
			<xsl:when test="$number = 8">H</xsl:when>
			<xsl:when test="$number = 9">I</xsl:when>
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
	<xsl:template match="字:字体_4128" mode="sentence">
		<xsl:if test="@西文字体引用_4129">
			<xsl:variable name="westfontref" select="@西文字体引用_4129"/>
			<xsl:variable name="sdwestfontref">
				<xsl:choose>
					<xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $westfontref]">
						<xsl:value-of select="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $westfontref]/@名称_9903"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$westfontref"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="westFamilyref">
				<xsl:choose>
					<xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $westfontref]">
						<xsl:value-of select="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $westfontref]/式样:字体族_9900"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$westfontref"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$document_type = 'presentation' or ancestor::图表:图表_E837">
					<xsl:attribute name="style:font-name" select="$sdwestfontref"/>
					<!--演 中用字体名称；字、表用字体ID，此时不用再指定font-family-->
					<xsl:attribute name="fo:font-family" select="$sdwestfontref"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="style:font-name" select="$westfontref"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="@中文字体引用_412A">
			<xsl:variable name="cjkfontref" select="@中文字体引用_412A"/>
			<xsl:variable name="sdcjkfontref">
				<xsl:choose>
					<xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $cjkfontref]">
						<xsl:value-of select="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $cjkfontref]/@名称_9903"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$cjkfontref"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="cjkFamilyref">
				<xsl:choose>
					<xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $cjkfontref]">
						<xsl:value-of select="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $cjkfontref]/式样:字体族_9900"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$cjkfontref"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$document_type = 'presentation' or ancestor::图表:图表_E837">
					<xsl:attribute name="style:font-name-asian" select="$sdcjkfontref"/>
					<xsl:attribute name="style:font-family-asian" select="$sdcjkfontref"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="style:font-name-asian" select="$cjkfontref"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="not(@西文字体引用_4129) and not(@中文字体引用_412A) and (@特殊字体引用_412B)">
			<xsl:variable name="fontref" select="@特殊字体引用_412B"/>
			<xsl:variable name="sdfontref">
				<xsl:choose>
					<xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $fontref]">
						<xsl:value-of select="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $fontref]/@名称_9903"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$fontref"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="Familyref">
				<xsl:choose>
					<xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $fontref]">
						<xsl:value-of select="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $fontref]/式样:字体族_9900"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$fontref"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$document_type = 'presentation'">
					<xsl:attribute name="style:font-name" select="$sdfontref"/>
					<xsl:attribute name="style:font-name-asian" select="$sdfontref"/>
					<xsl:attribute name="fo:font-family" select="$sdfontref"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="style:font-name" select="$fontref"/>
					<xsl:attribute name="style:font-name-asian" select="$fontref"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="@字号_412D">
				<xsl:attribute name="fo:font-size"><xsl:value-of select="concat(@字号_412D,'pt')"/></xsl:attribute>
				<xsl:attribute name="style:font-size-asian"><xsl:value-of select="concat(@字号_412D,'pt')"/></xsl:attribute>
				<xsl:attribute name="style:font-size-complex"><xsl:value-of select="concat(@字号_412D,'pt')"/></xsl:attribute>
			</xsl:when>
			<xsl:when test="@相对字号_412E">
				<xsl:attribute name="fo:font-size"><xsl:value-of select="concat(@相对字号_412E,'%')"/></xsl:attribute>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="@颜色_412F">
			<xsl:attribute name="fo:color"><xsl:value-of select="@颜色_412F"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@是否西文绘制_412C">
			<xsl:attribute name="style:western-content"><xsl:value-of select="@是否西文绘制_412C"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:是否粗体_4130" mode="sentence">
		<xsl:if test="string(.)='true' or string(.)='1'">
			<xsl:attribute name="fo:font-weight">bold</xsl:attribute>
			<xsl:attribute name="style:font-weight-asian">bold</xsl:attribute>
			<xsl:attribute name="style:font-weight-complex">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="string(.)='false'or string(.)='0'">
			<xsl:attribute name="fo:font-weight">normal</xsl:attribute>
			<xsl:attribute name="style:font-weight-asian">normal</xsl:attribute>
			<xsl:attribute name="style:font-weight-complex">normal</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:是否斜体_4131" mode="sentence">
		<xsl:if test="string(.)='true' or string(.)='1'">
			<xsl:attribute name="fo:font-style">italic</xsl:attribute>
			<xsl:attribute name="fo:font-style-asian">italic</xsl:attribute>
			<xsl:attribute name="style:font-style-asian">italic</xsl:attribute>
			<xsl:attribute name="style:font-style-complex">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="string(.)='false' or string(.)='0'">
			<xsl:attribute name="fo:font-style">normal</xsl:attribute>
			<xsl:attribute name="fo:font-style-asian">normal</xsl:attribute>
			<xsl:attribute name="style:font-style-asian">normal</xsl:attribute>
			<xsl:attribute name="style:font-style-complex">normal</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:突出显示颜色_4132" mode="sentence">
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="string(.)='auto'">transparent</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="fo:background-color"><xsl:value-of select="$color"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:边框_4133" mode="sentence">
	</xsl:template>
	<xsl:template match="字:填充_4134" mode="sentence">
		<xsl:call-template name="CommonFillAttr"/>
	</xsl:template>
	<xsl:template match="字:删除线_4135" mode="sentence">
		<xsl:choose>
			<xsl:when test="string(.) = 'single' ">
				<xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
			</xsl:when>
			<xsl:when test="string(.) = 'double' ">
				<xsl:attribute name="style:text-line-through-style">solid</xsl:attribute>
				<xsl:attribute name="style:text-line-through-type">double</xsl:attribute>
			</xsl:when>
			<xsl:when test="string(.) = 'bold' ">
				<xsl:attribute name="style:text-line-through-width">bold</xsl:attribute>
			</xsl:when>
			<xsl:when test="string(.) = 'xl' ">
				<xsl:attribute name="style:text-line-through-text">X</xsl:attribute>
			</xsl:when>
			<xsl:when test="string(.) = '/l' ">
				<xsl:attribute name="style:text-line-through-text">/</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="style:text-crossing-out">none</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:下划线_4136" mode="sentence">
		<xsl:choose>
			<xsl:when test=" @线型_4137 and @线型_4137 != 'none'">
				<xsl:attribute name="style:text-underline-type"><xsl:choose><xsl:when test="@线型_4137 = 'single'">single</xsl:when><xsl:when test="@线型_4137 = 'double'">double</xsl:when><xsl:otherwise>single</xsl:otherwise><!--other types of 线型 like thick-thin，thin-thick and thick-between-thin--></xsl:choose></xsl:attribute>
			</xsl:when>
			<!--xsl:when test=" @线型_4137 and @线型_4137 != 'none'">
				<xsl:attribute name="style:text-underline-type">
					<xsl:choose>
						<xsl:when test="@线型_4137 = 'single'">single</xsl:when>
						<xsl:when test="@线型_4137 = 'double'">double</xsl:when>
						<xsl:otherwise>solid</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:when-->
		</xsl:choose>
		<xsl:if test="@虚实_4138 and @线型_4137 != 'none'">
			<xsl:attribute name="style:text-underline-style"><xsl:choose><xsl:when test="@虚实_4138 = 'solid'">solid</xsl:when><xsl:when test="@虚实_4138 = 'dash'">dash</xsl:when><xsl:when test="@虚实_4138 = 'dash-dot'">dot-dash</xsl:when><xsl:when test="@虚实_4138 = 'long-dash'">long-dash</xsl:when><xsl:when test="@虚实_4138 = 'dash-dot-dot'">dot-dot-dash</xsl:when><xsl:when test="@虚实_4138 = 'round-dot'">dotted</xsl:when><xsl:when test="@虚实_4138 = 'square-dot'">dotted</xsl:when><xsl:when test="@虚实_4138 = 'long-dash-dot'">dot-dash</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
		</xsl:if>
		<xsl:if test="@线型_4137 != 'none' and @线型_4137">
			<xsl:attribute name="style:text-underline-width">auto</xsl:attribute>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="@颜色_412F">
				<xsl:variable name="color">
					<xsl:choose>
						<xsl:when test="@颜色_412F='auto'">font-color</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@颜色_412F"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="style:text-underline-color"><xsl:value-of select="$color"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="style:text-underline-color">font-color</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string(@是否字下划线_4139) = 'true'">
				<xsl:attribute name="style:text-line-through-mode">skip-white-space</xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:着重号_413A" mode="sentence">
		<xsl:choose>
			<xsl:when test="@类型_413B='none'">
				<xsl:attribute name="style:text-emphasize">none</xsl:attribute>
			</xsl:when>
			<xsl:when test="@类型_413B='dot'">
				<xsl:choose>
					<xsl:when test="@是否字着重号_413C='true'">
						<xsl:attribute name="style:text-emphasize">dot below spaceex</xsl:attribute>
					</xsl:when>
					<xsl:when test="@是否字着重号_413C='false'">
						<xsl:attribute name="style:text-emphasize">dot below spacein</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="style:text-emphasize">dot below</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:是否隐藏文字_413D" mode="sentence">
		<xsl:if test="string(.) = 'true'">
			<xsl:attribute name="text:display">none</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:是否空心_413E" mode="sentence">
		<xsl:attribute name="style:text-outline"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:浮雕_413F" mode="sentence">
		<xsl:attribute name="style:font-relief"><xsl:choose><xsl:when test="string(.)='engrave'">engraved</xsl:when><xsl:when test="string(.)='emboss'">embossed</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:是否阴影_4140" mode="sentence">
		<xsl:if test="string(.)!='false'">
			<xsl:attribute name="fo:text-shadow">1pt 1pt</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:醒目字体类型_4141" mode="sentence">
		<xsl:choose>
			<xsl:when test="string(.)='small-caps'">
				<xsl:attribute name="fo:font-variant">small-caps</xsl:attribute>
			</xsl:when>
			<xsl:when test="string(.)='none'">
				<xsl:attribute name="fo:font-variant">normal</xsl:attribute>
				<xsl:attribute name="fo:text-transform">none</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="fo:text-transform"><xsl:choose><xsl:when test="string(.)='uppercase'">uppercase</xsl:when><xsl:when test="string(.)='lowercase'">lowercase</xsl:when><xsl:when test="string(.)='capital'">capitalize</xsl:when></xsl:choose></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="UOFGetCharSize">
		<xsl:choose>
			<xsl:when test="字:字体_4128/@字号_412D">
				<xsl:value-of select="字:字体_4128/@字号_412D"/>
			</xsl:when>
			<xsl:when test="@式样引用_419C!=''">
				<xsl:for-each select="key('uof-text-styles',@式样引用_419C)">
					<xsl:call-template name="UOFGetCharSize"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="@基式样引用_4104!=''">
				<xsl:for-each select="key('uof-text-styles',@基式样引用_4104)">
					<xsl:call-template name="UOFGetCharSize"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>10.5</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:位置_4142" mode="sentence">
		<xsl:variable name="size">
			<xsl:for-each select="..">
				<xsl:call-template name="UOFGetCharSize"/>
			</xsl:for-each>
		</xsl:variable>
		<!--xsl:variable name="position" select="."/-->
		<xsl:variable name="pre" select="字:偏移量_4126[1]"/>
		<xsl:variable name="suf" select="字:缩放量_4127[1]"/>
		<xsl:for-each select="../..">
			<xsl:if test="not(starts-with(string($pre),'-'))">
				<xsl:choose>
					<xsl:when test="number($pre) &lt; number($size)">
						<xsl:variable name="tmp">
							<xsl:choose>
								<xsl:when test="$size!=''">
									<xsl:value-of select="number($pre) div number($size) * 100"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="number($pre) div 10.5 * 100"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:attribute name="style:text-position"><xsl:value-of select="concat(concat($tmp,'%'),' ',concat($suf,'%'))"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="style:text-position"><xsl:value-of select="concat('100%',' ',concat($suf,'%'))"/></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="starts-with(string($pre),'-')">
				<xsl:choose>
					<xsl:when test="number(substring-after(string($pre),'-')) &lt; number($size)">
						<xsl:variable name="tmp">
							<xsl:choose>
								<xsl:when test="$size!=''">
									<xsl:value-of select="number(substring-after(string($pre),'-')) div number($size) * 100"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="number(substring-after(string($pre),'-')) div 10.5 * 100"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:attribute name="style:text-position"><xsl:value-of select="concat('-',concat(string($tmp),'%'),' ',concat($suf,'%'))"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="style:text-position"><xsl:value-of select="concat('-100%',' ',concat($suf,'%'))"/></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="字:上下标类型_4143" mode="sentence">
		<xsl:variable name="positon">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:attribute name="style:text-position"><xsl:choose><xsl:when test="contains($positon,'sup')">super 58%</xsl:when><xsl:when test="contains($positon,'sub')">sub 58%</xsl:when></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:缩放_4144" mode="sentence">
		<xsl:attribute name="style:text-scale"><xsl:value-of select="."/>%</xsl:attribute>
	</xsl:template>
	<xsl:template match="字:字符间距_4145" mode="sentence">
		<xsl:attribute name="fo:letter-spacing"><xsl:value-of select="concat(.,$uofUnit)"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:调整字间距_4146" mode="sentence">
		<xsl:variable name="tt">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:attribute name="style:letter-kerning"><xsl:choose><xsl:when test="$tt !='0'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
		<xsl:attribute name="fo:letter-spacing"><xsl:value-of select="concat($tt,$uofUnit)"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:是否字符对齐网格_4147" mode="sentence">
	</xsl:template>
	<xsl:template match="字:双行合一_4148" mode="sentence">
		<xsl:attribute name="style:text-combine">lines</xsl:attribute>
		<xsl:if test="@前置字符_414A">
			<xsl:attribute name="style:text-combine-start-char"><xsl:value-of select="@前置字符_414A"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@后置字符_414B">
			<xsl:attribute name="style:text-combine-end-char"><xsl:value-of select="@后置字符_414B"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TextProperties">
		<xsl:if test="./*">
			<xsl:for-each select="*">
				<xsl:apply-templates select="." mode="sentence"/>
				<!--
				<xsl:choose>
					<xsl:when test="self::node()[name(.)='字:字体_4128']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:粗体']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:斜体']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:突出显示']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:边框_4133']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:填充']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:删除线_4135']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:下划线']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:着重号']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:隐藏文字']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:空心']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:浮雕']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:阴影']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:醒目字体']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:位置']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:上下标']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:缩放']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:字符间距']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:调整字间距']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:字符对齐网格']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:双行合一']">
						<xsl:apply-templates select="." mode="sentence"/>
					</xsl:when>
				</xsl:choose>
				-->
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="OneTextStyle">
		<xsl:attribute name="style:family">text</xsl:attribute>
		<xsl:attribute name="style:name"><xsl:value-of select="@标识符_4100"/></xsl:attribute>
		<xsl:choose>
			<xsl:when test="@别名_4103">
				<xsl:attribute name="style:display-name"><xsl:value-of select="@别名_4103"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="style:display-name"><xsl:value-of select="@标识符_4100"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="@基式样引用_4104">
			<xsl:attribute name="style:parent-style-name"><xsl:value-of select="@基式样引用_4104"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@后继式样引用_4105">
			<xsl:attribute name="style:next-style-name"><xsl:value-of select="@后继式样引用_4105"/></xsl:attribute>
		</xsl:if>
		<xsl:element name="style:text-properties">
			<xsl:call-template name="TextProperties"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="式样:句式样_9910">
		<xsl:param name="Type"/>
		<xsl:if test="@类型_4102=$Type">
			<xsl:choose>
				<xsl:when test="$Type='default'">
					<xsl:element name="style:default-style">
						<xsl:attribute name="style:family">text</xsl:attribute>
						<xsl:element name="style:text-properties">
							<xsl:call-template name="TextProperties"/>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$Type='custom'">
					<xsl:element name="style:style">
						<xsl:call-template name="OneTextStyle"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$Type='auto'">
					<xsl:element name="style:style">
						<xsl:call-template name="OneTextStyle"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TextParentProperties">
		<xsl:param name="Stylename"/>
		<xsl:for-each select="key('uof-text-styles',$Stylename)|key('uof-paragraph-styles',$Stylename)/字:句属性_4158">
			<xsl:variable name="styleref">
				<xsl:choose>
					<xsl:when test="@基式样引用_4104">
						<xsl:value-of select="@基式样引用_4104"/>
					</xsl:when>
					<xsl:when test="@式样引用_419C">
						<xsl:value-of select="@式样引用_417B"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$styleref">
				<xsl:call-template name="TextParentProperties">
					<xsl:with-param name="Stylename" select="$styleref"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:for-each select=".">
				<xsl:call-template name="TextProperties"/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="BodyTextProperties">
		<!--xsl:param name="Type"/>
		<xsl:choose>
			<xsl:when test="$Type='symbol'">
				<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:自动编号集_990E//字:符号字体_4116">
					<xsl:if test="count(./child::*)!=0">
						<xsl:element name="style:style">
							<xsl:attribute name="style:family">text</xsl:attribute>
							<xsl:attribute name="style:name">
								<xsl:value-of select="generate-id(.)"/>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="@式样引用_4117">
									<xsl:attribute name="style:parent-style-name">
										<xsl:value-of select="@式样引用_4117"/>
									</xsl:attribute>
									<xsl:element name="style:text-properties">
										<xsl:call-template name="TextParentProperties">
											<xsl:with-param name="Stylename" select="@式样引用_4117"/>
										</xsl:call-template>
										<xsl:call-template name="TextProperties"/>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="style:text-properties">
										<xsl:call-template name="TextProperties"/>
									</xsl:element>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:批注集_B669/规则:批注_B66A//字:句_419D/字:句属性_4158 | /uof:UOF_0000/字:文字处理文档_4225//字:句_419D/字:句属性_4158 | /uof:UOF_0000/图形:图形集_7C00/图:图形_8062/图:文本_803C/图:内容_8043//字:句_419D/字:句属性_4158 | /uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825//字:句_419D/字:句属性_4158"-->
		<xsl:variable name="textstyleref" select="@式样引用_419C"/>
		<xsl:variable name="textstylerefabsence">
			<xsl:if test="$textstyleref!='' and count(/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@标识符_4100=$textstyleref])=0">1</xsl:if>
		</xsl:variable>
		<xsl:variable name="pageNumberColor" select="../preceding-sibling::字:域开始_419E/@类型_416E"/>
		<xsl:variable name="beforeNumberColor" select="../字:文本串[1]"/>
		<xsl:choose>
			<xsl:when test="$textstylerefabsence='1'">
				<xsl:if test="count(key('uof-paragraph-styles',$textstyleref))!=0">
					<xsl:element name="style:style">
						<xsl:attribute name="style:family">text</xsl:attribute>
						<xsl:attribute name="style:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
						<xsl:element name="style:text-properties">
							<xsl:for-each select="key('uof-paragraph-styles',$textstyleref)/字:句属性_4158">
								<xsl:if test="@式样引用_419C">
									<xsl:call-template name="TextParentProperties">
										<xsl:with-param name="Stylename" select="@式样引用_419C"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:for-each select=".">
									<xsl:call-template name="TextProperties"/>
								</xsl:for-each>
								<!-- 为页码的字符部分做一个灰色背景式样 -->
								<xsl:if test="$document_type = 'text' and (string($pageNumberColor[1]) = 'page' or $beforeNumberColor[1] = '-')">
									<xsl:attribute name="fo:background-color">#d2d2d2</xsl:attribute>
								</xsl:if>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:when>
			<xsl:when test="count(*)!=0">
				<xsl:element name="style:style">
					<xsl:attribute name="style:family">text</xsl:attribute>
					<xsl:attribute name="style:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
					<xsl:choose>
						<xsl:when test="@式样引用_419C">
							<xsl:attribute name="style:parent-style-name"><xsl:value-of select="@式样引用_419C"/></xsl:attribute>
							<xsl:element name="style:text-properties">
								<xsl:call-template name="TextParentProperties">
									<xsl:with-param name="Stylename" select="@式样引用_419C"/>
								</xsl:call-template>
								<xsl:call-template name="TextProperties"/>
								<!-- 为页码的字符部分做一个灰色背景式样 -->
								<xsl:if test="$document_type = 'text' and (string($pageNumberColor[1]) = 'page' or $beforeNumberColor[1] = '-')">
									<xsl:attribute name="fo:background-color">#d2d2d2</xsl:attribute>
								</xsl:if>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="style:text-properties">
								<xsl:call-template name="TextProperties"/>
								<!-- 为页码的字符部分做一个灰色背景式样 -->
								<xsl:if test="$document_type = 'text' and (string($pageNumberColor[1]) = 'page' or $beforeNumberColor[1] = '-')">
									<xsl:attribute name="fo:background-color">#d2d2d2</xsl:attribute>
								</xsl:if>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
		<!--/xsl:for-each>
			</xsl:otherwise>
		</xsl:choose-->
	</xsl:template>
	<xsl:template name="ParaCharSize">
		<xsl:variable name="charSize">
			<xsl:choose>
				<xsl:when test="字:句属性_4158/字:字体_4128/@字号_412D">
					<xsl:value-of select="字:句属性_4158/字:字体_4128/@字号_412D"/>
				</xsl:when>
				<xsl:when test="字:句属性_4158/@式样引用_419C!=''">
					<xsl:for-each select="key('uof-text-styles',字:句属性_4158/@式样引用_419C)">
						<xsl:call-template name="UOFGetCharSize"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="@式样引用_419C!=''">
					<xsl:for-each select="key('uof-paragraph-styles',@式样引用_419C)">
						<xsl:call-template name="ParaCharSize"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="@基式样引用_4104!=''">
					<xsl:for-each select="key('uof-paragraph-styles',@基式样引用_4104)">
						<xsl:call-template name="ParaCharSize"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912[@类型_4102 = 'default']/字:句属性_4158/字:字体_4128/@字号_412D">
					<xsl:value-of select="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912[@类型_4102 = 'default']/字:句属性_4158/字:字体_4128/@字号_412D"/>
				</xsl:when>
				<xsl:otherwise>10.5</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--<xsl:variable name="defaultCharSize">
			<xsl:value-of select="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912[@类型_4102='default']/字:句属性_4158/字:字体_4128/@字号_412D"/>
		</xsl:variable>-->
		<xsl:choose>
			<xsl:when test="$charSize!=''">
				<xsl:value-of select="$charSize"/>
			</xsl:when>
			<!--<xsl:when test="$defaultCharSize!=''">
				<xsl:value-of select="$defaultCharSize"/>
			</xsl:when>-->
			<xsl:otherwise>10.5</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:边框_4133" mode="paragraph">
		<xsl:if test="@阴影类型_C645 and @阴影类型_C645 !='' and @阴影类型_C645 !='none'">
			<xsl:choose>
				<xsl:when test="@阴影类型_C645 = 'right-bottom'">
					<xsl:attribute name="style:shadow">#808080 5pt 5pt</xsl:attribute>
				</xsl:when>
				<xsl:when test="@阴影类型_C645 = 'right-top'">
					<xsl:attribute name="style:shadow">#808080 5pt -5pt</xsl:attribute>
				</xsl:when>
				<xsl:when test="@阴影类型_C645 = 'left-bottom'">
					<xsl:attribute name="style:shadow">#808080 -5pt 5pt</xsl:attribute>
				</xsl:when>
				<xsl:when test="@阴影类型_C645 = 'left-top'">
					<xsl:attribute name="style:shadow">#808080 -5pt -5pt</xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:call-template name="CommonBorder">
			<xsl:with-param name="pUp" select="uof:上_C614"/>
			<xsl:with-param name="pDown" select="uof:下_C616"/>
			<xsl:with-param name="pLeft" select="uof:左_C613"/>
			<xsl:with-param name="pRight" select="uof:右_C615"/>
			<xsl:with-param name="pDiagon1" select="uof:对角线1_C617"/>
			<xsl:with-param name="pDiagon2" select="uof:对角线2_C618"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="字:填充_4134" mode="paragraphAttr">
		<xsl:call-template name="CommonFillAttr"/>
	</xsl:template>
	<xsl:template match="字:填充_4134" mode="paragraphElement">
		<xsl:call-template name="CommonFillElement"/>
	</xsl:template>
	<xsl:template match="字:大纲级别_417C" mode="paragraph">
		<xsl:attribute name="text:outline-level"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:对齐_417D" mode="paragraph">
		<xsl:if test="@文字对齐_421E">
			<xsl:attribute name="style:vertical-align"><xsl:choose><xsl:when test="@文字对齐_421E='base'">baseline</xsl:when><xsl:when test="@文字对齐_421E='center'">middle</xsl:when><xsl:otherwise><xsl:value-of select="@文字对齐_421E"/></xsl:otherwise></xsl:choose></xsl:attribute>
		</xsl:if>
		<xsl:if test="@水平对齐_421D">
			<xsl:attribute name="fo:text-align"><xsl:choose><xsl:when test="@水平对齐_421D='left'">start</xsl:when><xsl:when test="@水平对齐_421D='right'">end</xsl:when><xsl:when test="@水平对齐_421D='center'">center</xsl:when><xsl:otherwise>justify</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:if test="@水平对齐_421D='distributed'">
				<xsl:attribute name="fo:text-align-last">justify</xsl:attribute>
				<xsl:attribute name="style:justify-single-word">true</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:缩进_411D" mode="paragraph">
		<xsl:variable name="fontcharsize">
			<xsl:for-each select="..">
				<xsl:call-template name="ParaCharSize"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="字:左_410E">
			<xsl:choose>
				<xsl:when test="字:左_410E/字:相对_4109">
					<xsl:variable name="a1" select="字:左_410E/字:相对_4109/@值_4108"/>
					<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat($a1 * number(10.5), 'pt')"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="字:左_410E/字:绝对_4107">
					<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(字:左_410E/字:绝对_4107/@值_410F,$uofUnit)"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="字:右_4110">
			<xsl:choose>
				<xsl:when test="字:右_4110/字:相对_4109">
					<xsl:variable name="a2" select="字:右_4110/字:相对_4109/@值_4108"/>
					<xsl:attribute name="fo:margin-right"><xsl:value-of select="concat($a2 * number(10.5), 'pt')"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="字:右_4110/字:绝对_4107">
					<xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(字:右_4110/字:绝对_4107/@值_410F,$uofUnit)"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="字:首行_4111">
			<xsl:choose>
				<xsl:when test="字:首行_4111/字:绝对_4107">
					<xsl:attribute name="fo:text-indent"><xsl:value-of select="concat(字:首行_4111/字:绝对_4107/@值_410F,$uofUnit)"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="字:首行_4111/字:相对_4109">
					<xsl:variable name="a3" select="字:首行_4111/字:相对_4109/@值_4108"/>
					<xsl:attribute name="fo:text-indent"><xsl:value-of select="concat($a3 * $fontcharsize, 'pt')"/></xsl:attribute>
					<!--xsl:attribute name="fo:text-indent"><xsl:value-of select="concat($a3 * number(10.5), 'pt')"/></xsl:attribute-->
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:行距_417E" mode="paragraph">
		<xsl:variable name="type" select="@类型_417F"/>
		<xsl:variable name="val" select="@值_4108"/>
		<xsl:choose>
			<xsl:when test="$document_type = 'presentation' and $type='fixed'">
				<xsl:attribute name="style:line-spacing"><xsl:value-of select="concat($val,$uofUnit)"/></xsl:attribute>
			</xsl:when>
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
	</xsl:template>
	<xsl:template match="字:段间距_4180" mode="paragraph">
		<xsl:variable name="lineheight">
			<xsl:choose>
				<xsl:when test="字:段前距_4181/字:相对值_4148 | 字:段后距_4185/字:相对值_4148">
					<xsl:choose>
						<xsl:when test="../..[name()='字:段落_416B']">
							<xsl:choose>
								<xsl:when test="preceding::字:分节_416A[1]">
									<xsl:for-each select="preceding::字:分节_416A[1]">
										<xsl:choose>
											<xsl:when test="(字:节属性_421B/字:网格设置_420E/@网格类型_420F = 'none') or 字:节属性_421B/字:网格设置_420E/@行跨度_4243">
												<xsl:for-each select="字:节属性_421B">
													<xsl:variable name="margintop">
														<xsl:choose>
															<xsl:when test="字:页边距_41EB/@上_C608">
																<xsl:value-of select="字:页边距_41EB/@上_C608"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="number(0)"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:variable>
													<xsl:variable name="marginbottom">
														<xsl:choose>
															<xsl:when test="字:页边距_41EB/@下_C60B">
																<xsl:value-of select="字:页边距_41EB/@下_C60B"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="number(0)"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:variable>
													<xsl:variable name="pageheight">
														<xsl:call-template name="GetPageHeight"/>
													</xsl:variable>
													<xsl:variable name="bodyheight" select="$pageheight - $margintop - $marginbottom"/>
													<xsl:variable name="modnum" select="number(1.0015)"/>
													<xsl:variable name="gridheight">
														<xsl:value-of select="$bodyheight div ceiling(字:网格设置_420E/@行数_4210) div $modnum"/>
													</xsl:variable>
													<xsl:value-of select="$gridheight"/>
												</xsl:for-each>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="12"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="12"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="12"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="12"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="字:段前距_4181/字:绝对值_4183">
				<xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(字:段前距_4181/字:绝对值_4183,$uofUnit)"/></xsl:attribute>
			</xsl:when>
			<xsl:when test="字:段前距_4181/字:相对值_4184">
				<xsl:variable name="aa" select="字:段前距_4181/字:相对值_4184"/>
				<xsl:attribute name="fo:margin-taop"><xsl:value-of select="$lineheight"/></xsl:attribute>
				<xsl:attribute name="fo:margin-top"><xsl:value-of select="concat($aa * number($lineheight),$uofUnit)"/></xsl:attribute>
			</xsl:when>
			<xsl:when test="字:段前距_4181/字:自动_4182">
				<xsl:attribute name="fo:margin-top"><xsl:choose><xsl:when test="../字:行距_417E"><xsl:value-of select="concat(字:行距_417E/@值_4108,$uofUnit)"/></xsl:when><xsl:otherwise>0.549cm</xsl:otherwise></xsl:choose></xsl:attribute>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="字:段后距_4185/字:绝对值_4183">
				<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(字:段后距_4185/字:绝对值_4183,$uofUnit)"/></xsl:attribute>
			</xsl:when>
			<xsl:when test="字:段后距_4185/字:相对值_4184">
				<xsl:variable name="bb">
					<xsl:value-of select="字:段后距_4185/字:相对值_4184"/>
				</xsl:variable>
				<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat($bb * number($lineheight),$uofUnit)"/></xsl:attribute>
			</xsl:when>
			<xsl:when test="字:段后距_4185/字:自动_4182">
				<xsl:attribute name="fo:margin-bottom"><xsl:choose><xsl:when test="../字:行距_417E"><xsl:value-of select="concat(字:行距_417E/@值_4108,@uofUnit)"/></xsl:when><xsl:otherwise>0.549cm</xsl:otherwise></xsl:choose></xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--xsl:template match="字:自动编号信息" mode="paragraph">
	</xsl:template-->
	<xsl:template match="字:孤行控制_418A" mode="paragraph">
		<xsl:attribute name="fo:orphans"><xsl:value-of select="string(.)"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:寡行控制_418B" mode="paragraph">
		<xsl:attribute name="fo:widows"><xsl:value-of select="string(.)"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:是否段中不分页_418C" mode="paragraph">
		<xsl:attribute name="fo:keep-together"><xsl:choose><xsl:when test="string(.) = 'true'">always</xsl:when><xsl:otherwise>auto</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:是否与下段同页_418D" mode="paragraph">
		<xsl:attribute name="fo:keep-with-next"><xsl:choose><xsl:when test="string(.)='1' or string(.)='true'">always</xsl:when><xsl:otherwise>auto</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:是否段前分页_418E" mode="paragraph">
		<xsl:if test="string(.)='true' or string(.)='1'">
			<xsl:attribute name="fo:break-before">page-paragraph</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="OOoTabstop">
		<xsl:for-each select="字:制表位_4171">
			<xsl:element name="style:tab-stop">
				<xsl:attribute name="style:position"><xsl:value-of select="concat(@位置_4172,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="style:type"><xsl:choose><xsl:when test="@类型_4173='decimal'">char</xsl:when><xsl:when test="@类型_4173='left' or @类型_4173='right' or @类型_4173='center'"><xsl:value-of select="@类型_4173"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:attribute>
				<xsl:if test="@类型_4173='decimal'">
					<xsl:attribute name="style:char" select="'.'"/>
				</xsl:if>
				<xsl:variable name="prechar" select="@前导符_4174"/>
				<xsl:choose>
					<xsl:when test="@制表位字符_4175">
						<xsl:attribute name="style:leader-style"><xsl:value-of select="@制表位字符_4175"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="$prechar='-' or $prechar='_'">
						<xsl:attribute name="style:leader-style">solid</xsl:attribute>
					</xsl:when>
					<xsl:when test="$prechar='.' or $prechar='·'">
						<xsl:attribute name="style:leader-style">dotted</xsl:attribute>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
				<xsl:if test="@前导符_4174">
					<xsl:attribute name="style:leader-text"><xsl:value-of select="@前导符_4174"/></xsl:attribute>
				</xsl:if>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="字:制表位设置_418F" mode="paragraph">
		<xsl:call-template name="OOoTabstop"/>
	</xsl:template>
	<xsl:template match="字:是否对齐网格_4190" mode="paragraph">
		<xsl:attribute name="style:snap-to-layout-grid"><xsl:choose><xsl:when test="string(.)='1' or string(.)='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:首字下沉_4191" mode="paragraph">
		<xsl:element name="style:drop-cap">
			<xsl:if test="@类型_413B">
				<xsl:attribute name="style:drop-type"><xsl:value-of select="@类型_413B"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@行数_4178">
				<xsl:attribute name="style:lines"><xsl:value-of select="@行数_4178"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@间距_4179">
				<xsl:attribute name="style:distance"><xsl:value-of select="concat(@间距_4179,$uofUnit)"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@字体引用_4176">
				<xsl:attribute name="style:style-name"><xsl:value-of select="@字体引用_4176"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@字符数_4177">
				<xsl:attribute name="style:length"><xsl:value-of select="@字符数_4177"/></xsl:attribute>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template match="字:是否取消断字_4192" mode="paragraph">
		<!-- alert staring 
		<xsl:attribute name="fo:hyphenation-ladder-count">no-limit</xsl:attribute>
		<xsl:attribute name="fo:hyphenation-remain-char-count">2</xsl:attribute>
		<xsl:attribute name="fo:hyphenation-push-char-count">2</xsl:attribute>
		<xsl:attribute name="fo:hyphenate">
			<xsl:choose>
				<xsl:when test="string(.)='1' or string(.)='true'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>-->
		<xsl:if test="string(.) ='0' or string(.) ='false'">
			<xsl:attribute name="fo:hyphenate">true</xsl:attribute>
			<xsl:attribute name="fo:hyphenation-ladder-count">no-limit</xsl:attribute>
			<xsl:attribute name="fo:hyphenation-remain-char-count">2</xsl:attribute>
			<xsl:attribute name="fo:hyphenation-push-char-count">2</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:是否取消行号_4193" mode="paragraph">
		<xsl:attribute name="text:number-lines"><xsl:choose><xsl:when test="string(.)='1' or string(.)='true'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:是否允许单词断字_4194" mode="paragraph">
		<!-- alert staring 
		<xsl:attribute name="style:word-wrap">
			<xsl:choose>
				<xsl:when test="string(.) = 'true'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>-->
		<xsl:if test="string(.) ='1' or string(.) ='true'">
			<xsl:attribute name="fo:hyphenation-ladder-count"><xsl:value-of select="2"/></xsl:attribute>
		</xsl:if>
		<!-- alert ending. -->
	</xsl:template>
	<!-- alert starting -->
	<xsl:template match="字:是否允许单词断字_4194" mode="text">
		<xsl:if test="string(.) ='1' or string(.) ='true'">
			<xsl:attribute name="fo:hyphenate">true</xsl:attribute>
			<xsl:attribute name="fo:hyphenation-ladder-count">no-limit</xsl:attribute>
			<xsl:attribute name="fo:hyphenation-remain-char-count">2</xsl:attribute>
			<xsl:attribute name="fo:hyphenation-push-char-count">2</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<!-- alert ending. -->
	<xsl:template match="字:是否行首尾标点控制_4195" mode="paragraph">
		<xsl:attribute name="style:punctuation-wrap"><xsl:choose><xsl:when test="string(.)='1' or string(.)='true'">hanging</xsl:when><xsl:otherwise>simple</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:是否行首标点压缩_4196" mode="paragraph">
		<xsl:attribute name="style:punctuation-compress"><xsl:choose><xsl:when test=". = 'true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:是否采用中文习惯首尾字符_4197" mode="paragraph">
		<xsl:attribute name="style:line-break"><xsl:choose><xsl:when test="string(.)='1' or string(.)='true'">strict</xsl:when><xsl:otherwise>normal</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:是否自动调整中英文字符间距_4198" mode="paragraph">
		<xsl:attribute name="style:text-autospace"><xsl:choose><xsl:when test="string(.)='1' or string(.)='true'">ideograph-alpha</xsl:when><xsl:when test="string(../字:是否自动调整中文与数字间距_4199) = '1' or string(../字:是否自动调整中文与数字间距_4199) = 'true'">ideograph-alpha</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:是否自动调整中文与数字间距_4199" mode="paragraph">
		<xsl:attribute name="style:text-autospace"><xsl:choose><xsl:when test="string(.)='1' or string(.)='true'">ideograph-alpha</xsl:when><xsl:when test="string(../字:是否自动调整中英文字符间距_4198) = '1' or string(../字:是否自动调整中英文字符间距_4198) = 'true'">ideograph-alpha</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:是否有网格自动调整右缩进_419A" mode="paragraph">
	</xsl:template>
	<xsl:template name="defaultParaProAttr">
		<xsl:attribute name="style:text-autospace" select="'ideograph-alpha'"/>
		<!--段落文字垂直对齐方式 UOF 默认值为base 与ODF（auto）不一致-->
		<xsl:attribute name="style:vertical-align" select="'baseline'"/>
		<xsl:attribute name="fo:text-align" select="'justify'"/>
	</xsl:template>
	<xsl:template name="ParaPropertiesAttr">
		<xsl:param name="tabstop"/>
		<xsl:param name="Stylename"/>
		<xsl:if test="$tabstop = 'default'">
			<xsl:if test="/uof:UOF_0000/规则:公用处理规则_B665/规则:文字处理_B66B/规则:文档设置_B600/规则:默认制表位位置_B604">
				<xsl:variable name="defaultab">
					<xsl:value-of select="/uof:UOF_0000/规则:公用处理规则_B665/规则:文字处理_B66B/规则:文档设置_B600/规则:默认制表位位置_B604"/>
				</xsl:variable>
				<xsl:if test="number($defaultab) != 0">
					<xsl:attribute name="style:tab-stop-distance"><xsl:value-of select="concat(number($defaultab),$uofUnit)"/></xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$Stylename = '' and not(/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912[@类型_4102 = 'default'])">
			<xsl:call-template name="defaultParaProAttr"/>
		</xsl:if>
		<xsl:if test="$Stylename!=''">
			<xsl:for-each select="key('uof-paragraph-styles',$Stylename)">
				<xsl:call-template name="ParaPropertiesAttr">
					<xsl:with-param name="tabstop" select="$tabstop"/>
					<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name(.)='字:大纲级别_417C'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:对齐_417D'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:缩进_411D'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:行距_417E'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:段间距_4180'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<!--<xsl:when test="name(.)='字:自动编号信息'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
			-->
				<xsl:when test="name(.)='字:孤行控制_418A'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:寡行控制_418B'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:是否段中不分页_418C'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:是否与下段同页_418D'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:是否段前分页_418E'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:边框_4133'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:填充_4134'">
					<xsl:apply-templates select="." mode="paragraphAttr"/>
				</xsl:when>
				<xsl:when test="name(.)='字:是否对齐网格_4190'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<!-- remove
				<xsl:when test="name(.)='字:是否取消断字_4192'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				 -->
				<xsl:when test="name(.)='字:是否取消行号_4193'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:是否允许单词断字_4194'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:是否行首尾标点控制_4195'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:是否行首标点压缩_4196'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:是否采用中文习惯首尾字符_4197'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:是否自动调整中英文字符间距_4198'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
				<xsl:when test="name(.)='字:是否自动调整中文与数字间距_4199'">
					<xsl:apply-templates select="." mode="paragraph"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		<!--<xsl:if test="/uof:UOF_0000/图形:图形集_7C00/图:图形_8062/图:文本_803C/图:文字排列方向_8042 = 't2b-r2l-0e-0w'">
			<xsl:attribute name="style:writing-mode"><xsl:value-of select="'rl-tb'"/></xsl:attribute>
			<xsl:attribute name="fo:text-align"><xsl:value-of select="'end'"/></xsl:attribute>
		</xsl:if>-->
	</xsl:template>
	<xsl:template name="字:制表位设置">
		<xsl:param name="Stylename"/>
		<!--制表位各级叠加-->
		<xsl:for-each select="key('uof-paragraph-styles',$Stylename)">
			<xsl:if test="@基式样引用_4104">
				<xsl:call-template name="字:制表位设置">
					<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:apply-templates select="字:制表位设置_418F" mode="paragraph"/>
		</xsl:for-each>
		<xsl:apply-templates select="字:制表位设置_418F" mode="paragraph"/>
	</xsl:template>
	<xsl:template name="字:首字下沉">
		<xsl:param name="Stylename"/>
		<xsl:choose>
			<xsl:when test="字:首字下沉_4191">
				<xsl:apply-templates select="字:首字下沉_4191" mode="paragraph"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="key('uof-paragraph-styles',$Stylename)">
					<xsl:call-template name="字:首字下沉">
						<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="字:填充">
		<xsl:param name="Stylename"/>
		<xsl:choose>
			<xsl:when test="name(字:填充_4134/*)!='' and name(字:填充_4134/*)!='图:颜色_8004'">
				<xsl:apply-templates select="字:填充_4134" mode="paragraphElement"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="key('uof-paragraph-styles',$Stylename)">
					<xsl:call-template name="字:填充">
						<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ParaPropertiesElement">
		<xsl:param name="Stylename"/>
		<!--here will create new element-->
		<style:tab-stops>
			<xsl:call-template name="字:制表位设置">
				<xsl:with-param name="Stylename" select="$Stylename"/>
			</xsl:call-template>
		</style:tab-stops>
		<xsl:call-template name="字:首字下沉">
			<xsl:with-param name="Stylename" select="$Stylename"/>
		</xsl:call-template>
		<xsl:call-template name="字:填充">
			<xsl:with-param name="Stylename" select="$Stylename"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="ParaPropertiesAll">
		<xsl:param name="tabstop"/>
		<xsl:param name="Stylename"/>
		<xsl:call-template name="ParaPropertiesAttr">
			<xsl:with-param name="tabstop" select="$tabstop"/>
			<xsl:with-param name="Stylename" select="$Stylename"/>
		</xsl:call-template>
		<xsl:call-template name="ParaPropertiesElement">
			<xsl:with-param name="Stylename" select="$Stylename"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="FindParentStyleName">
		<xsl:param name="parentStyleName"/>
		<xsl:choose>
			<xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:段落式样_9917[@标识符_4100 = $parentStyleName]/@类型_4102 = 'custom'">
				<xsl:attribute name="style:parent-style-name"><xsl:value-of select="$parentStyleName"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="/uof:UOF_0000/式样:式样集_990B/式样:段落式样_9917[@标识符_4100 = $parentStyleName]/@基式样引用_4104">
					<xsl:call-template name="FindParentStyleName">
						<xsl:with-param name="parentStyleName" select="/uof:UOF_0000/式样:式样集_990B/式样:段落式样_9917[@标识符_4100 = $parentStyleName]/@基式样引用_4104"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="OneParagraphStyle">
		<xsl:attribute name="style:family">paragraph</xsl:attribute>
		<xsl:attribute name="style:name"><xsl:value-of select="@标识符_4100"/></xsl:attribute>
		<xsl:choose>
			<xsl:when test="@别名_4103 and not(@类型_4102='default')">
				<xsl:attribute name="style:display-name"><xsl:choose><xsl:when test="@别名_4103='正文'">Text body</xsl:when><xsl:when test="@别名_4103='页脚'">footer</xsl:when><xsl:otherwise><xsl:value-of select="@别名_4103"/></xsl:otherwise></xsl:choose></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="style:display-name"><xsl:value-of select="@标识符_4100"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="@基式样引用_4104">
			<xsl:call-template name="FindParentStyleName">
				<xsl:with-param name="parentStyleName" select="@基式样引用_4104"/>
			</xsl:call-template>
			<!--<xsl:attribute name="style:parent-style-name"><xsl:value-of select="@基式样引用_4104"/></xsl:attribute>-->
		</xsl:if>
		<xsl:if test="@后继式样引用_4105">
			<xsl:attribute name="style:next-style-name"><xsl:value-of select="@后继式样引用_4105"/></xsl:attribute>
		</xsl:if>
		<xsl:element name="style:paragraph-properties">
			<!--演示文稿中存在占位符的文字的默认式样，uof文件中定义了默认式样-->
			<xsl:if test="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912[@类型_4102 = 'default']">
				<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912[@类型_4102 = 'default']">
					<xsl:call-template name="defaultParaProAttr"/>
					<xsl:call-template name="ParaPropertiesAttr">
						<!--xsl:with-param name="Stylename" select="@基式样引用_4104"/-->
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
			<xsl:call-template name="ParaPropertiesAll">
				<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="style:text-properties">
			<!--演示文稿中存在占位符的文字的默认式样，uof文件中定义了默认式样-->
			<xsl:if test="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912[@字:类型 = 'default']/字:句属性_4158">
				<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样_9912[@字:类型 = 'default']">
					<xsl:call-template name="TextPropertiesAll">
						<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
			<xsl:for-each select="字:句属性_4158">
				<xsl:call-template name="TextProperties"/>
			</xsl:for-each>
			<xsl:choose>
				<xsl:when test="字:是否允许单词断字_4194 and (string(字:是否允许单词断字_4194)='1' or string(字:是否允许单词断字_4194)='true')">
					<xsl:for-each select="字:是否允许单词断字_4194">
						<xsl:apply-templates select="." mode="text"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="字:是否取消断字_4192">
					<xsl:for-each select="字:是否取消断字_4192">
						<xsl:apply-templates select="." mode="paragraph"/>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
			<xsl:call-template name="HyphenateTextProperties">
				<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template name="HyphenateTextProperties">
		<xsl:param name="Stylename"/>
		<xsl:if test="$Stylename!=''">
			<xsl:for-each select="key('uof-paragraph-styles',$Stylename)">
				<xsl:call-template name="HyphenateTextProperties">
					<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:choose>
				<xsl:when test="字:是否允许单词断字_4194 and (string(字:是否允许单词断字_4194)='1' or string(字:是否允许单词断字_4194)='true')">
					<xsl:for-each select="字:是否允许单词断字_4194">
						<xsl:apply-templates select="." mode="text"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="字:是否取消断字_4192">
					<xsl:for-each select="字:是否取消断字_4192">
						<xsl:apply-templates select="." mode="paragraph"/>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TextPropertiesAll">
		<xsl:param name="Stylename"/>
		<xsl:if test="$Stylename!=''">
			<xsl:for-each select="key('uof-paragraph-styles',$Stylename)">
				<xsl:call-template name="TextPropertiesAll">
					<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each select="字:句属性_4158">
			<xsl:call-template name="TextProperties"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="UOFParagraphStyle">
		<xsl:param name="Type"/>
		<xsl:if test="@类型_4102=$Type">
			<xsl:choose>
				<xsl:when test="$Type='default'">
					<xsl:element name="style:default-style">
						<xsl:attribute name="style:family">paragraph</xsl:attribute>
						<xsl:element name="style:paragraph-properties">
							<xsl:call-template name="ParaPropertiesAll">
								<xsl:with-param name="tabstop" select="string('default')"/>
							</xsl:call-template>
						</xsl:element>
						<xsl:element name="style:text-properties">
							<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@类型_4102='default'][1]">
								<xsl:call-template name="TextProperties"/>
							</xsl:for-each>
							<xsl:for-each select="字:句属性_4158">
								<xsl:call-template name="TextProperties"/>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$Type='custom'">
					<xsl:element name="style:style">
						<xsl:call-template name="OneParagraphStyle"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$Type='auto'">
					<xsl:element name="style:style">
						<xsl:call-template name="OneParagraphStyle"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="式样:段落式样_9912">
		<xsl:param name="Type"/>
		<xsl:call-template name="UOFParagraphStyle">
			<xsl:with-param name="Type" select="$Type"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="ParaParentProperties">
		<xsl:param name="Stylename"/>
		<xsl:for-each select="key('uof-paragraph-styles',$Stylename)">
			<xsl:if test="@基式样引用_4104">
				<xsl:call-template name="ParaParentProperties">
					<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:call-template name="ParaPropertiesAttr"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ParaParentPropertiesElement">
		<xsl:param name="Stylename"/>
		<xsl:for-each select="key('uof-paragraph-styles',$Stylename)">
			<xsl:if test="@基式样引用_4104">
				<xsl:call-template name="ParaParentProperties">
					<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:call-template name="ParaPropertiesAll">
				<xsl:with-param name="Stylename" select="$Stylename"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="TextParaParentProperties">
		<xsl:param name="Stylename"/>
		<xsl:for-each select="key('uof-paragraph-styles',$Stylename)">
			<xsl:if test="@基式样引用_4104">
				<xsl:call-template name="TextParaParentProperties">
					<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:for-each select="字:句属性_4158">
				<xsl:call-template name="TextProperties"/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="PageBreakStyle">
		<xsl:element name="style:style">
			<xsl:attribute name="style:family">paragraph</xsl:attribute>
			<xsl:attribute name="style:name"><xsl:value-of select="concat('breakpage',generate-id(.))"/></xsl:attribute>
			<xsl:variable name="Stylename">
				<xsl:value-of select="./字:段落属性_419B/@式样引用_419C"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$Stylename != ''">
					<xsl:call-template name="FindParentStyleName">
						<xsl:with-param name="parentStyleName" select="$Stylename"/>
					</xsl:call-template>
					<!---<xsl:attribute name="style:parent-style-name"><xsl:value-of select="$Stylename"/></xsl:attribute>-->
					<xsl:element name="style:paragraph-properties">
						<xsl:attribute name="fo:break-before">page</xsl:attribute>
						<xsl:call-template name="ParaParentProperties">
							<xsl:with-param name="Stylename" select="$Stylename"/>
						</xsl:call-template>
						<xsl:for-each select="字:段落属性_419B">
							<xsl:call-template name="ParaPropertiesAll">
								<xsl:with-param name="Stylename" select="$Stylename"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="style:text-properties">
						<xsl:call-template name="TextParaParentProperties">
							<xsl:with-param name="Stylename" select="$Stylename"/>
						</xsl:call-template>
						<xsl:for-each select="字:段落属性_419B/字:句属性_4158">
							<xsl:call-template name="TextProperties"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="style:paragraph-properties">
						<xsl:for-each select="字:段落属性_419B">
							<xsl:call-template name="ParaPropertiesAll">
								<xsl:with-param name="Stylename" select="$Stylename"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="style:text-properties">
						<xsl:for-each select="字:段落属性_419B/字:句属性_4158">
							<xsl:call-template name="TextProperties"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="PageColumnStyle">
		<xsl:element name="style:style">
			<xsl:attribute name="style:family">paragraph</xsl:attribute>
			<xsl:attribute name="style:name"><xsl:value-of select="concat('breakcolumn',generate-id(.))"/></xsl:attribute>
			<xsl:variable name="Stylename">
				<xsl:value-of select="./字:段落属性_419B/@式样引用_419C"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$Stylename != ''">
					<xsl:call-template name="FindParentStyleName">
						<xsl:with-param name="parentStyleName" select="$Stylename"/>
					</xsl:call-template>
					<!---<xsl:attribute name="style:parent-style-name"><xsl:value-of select="$Stylename"/></xsl:attribute>-->
					<xsl:element name="style:paragraph-properties">
						<xsl:attribute name="fo:break-before">column</xsl:attribute>
						<xsl:call-template name="ParaParentProperties">
							<xsl:with-param name="Stylename" select="$Stylename"/>
						</xsl:call-template>
						<xsl:for-each select="字:段落属性_419B">
							<xsl:call-template name="ParaPropertiesAll">
								<xsl:with-param name="Stylename" select="$Stylename"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="style:text-properties">
						<xsl:call-template name="TextParaParentProperties">
							<xsl:with-param name="Stylename" select="$Stylename"/>
						</xsl:call-template>
						<xsl:for-each select="字:段落属性_419B/字:句属性_4158">
							<xsl:call-template name="TextProperties"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="style:paragraph-properties">
						<xsl:for-each select="字:段落属性_419B">
							<xsl:call-template name="ParaPropertiesAll">
								<xsl:with-param name="Stylename" select="$Stylename"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="style:text-properties">
						<xsl:for-each select="字:段落属性_419B/字:句属性_4158">
							<xsl:call-template name="TextProperties"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="BodyParagraphProperties">
		<xsl:variable name="SpecialSection">
			<xsl:choose>
				<xsl:when test="($document_type='text') and (name(..) = '字:文字处理文档_4225')">
					<xsl:variable name="SectPos">
						<xsl:choose>
							<xsl:when test="preceding-sibling::*[1][name(.) = '字:分节_416A'] and preceding-sibling::*[1]/字:节属性_421B/字:节类型_41EA != 'continuous'">
								<!--xsl:call-template name="IsPrecedeType">
						<xsl:with-param name="nodename" select="'字:分节'"/>
						<xsl:with-param name="pos" select="0"/>
					</xsl:call-template-->
								<xsl:value-of select="1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="0"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="number($SectPos) &gt; 0">
							<xsl:for-each select="preceding-sibling::*[position() = $SectPos]">
								<xsl:choose>
									<xsl:when test="字:节属性_421B/字:是否首页页眉页脚不同_41EE='true'">
										<xsl:value-of select="nsof:NeoShineOfficeID(字:节属性_421B/字:是否首页页眉页脚不同_41EE)"/>
									</xsl:when>
									<xsl:when test="字:节属性_421B/字:页码设置_4205/@字:首页显示 = 'false'">
										<xsl:value-of select="nsof:NeoShineOfficeID(字:节属性_421B/字:页码设置_4205)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="@名称_4166='RoStandard'">
												<xsl:value-of select="string('none')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="nsof:NeoShineOfficeID(.)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('none')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string('none')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="PageNumberStart">
			<xsl:if test="($document_type='text') and (name(..) = '字:文字处理文档_4225')">
				<xsl:variable name="SectPos">
					<xsl:choose>
						<xsl:when test="preceding-sibling::*[1][name(.) = '字:分节_416A'] and preceding-sibling::*[1]/字:节属性_421B/字:节类型_41EA != 'continuous'">
							<!--xsl:call-template name="IsPrecedeType">
						<xsl:with-param name="nodename" select="'字:分节'"/>
						<xsl:with-param name="pos" select="0"/>
					</xsl:call-template-->
							<xsl:value-of select="1"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="0"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="number($SectPos) &gt; 0">
					<xsl:for-each select="preceding-sibling::*[position() = $SectPos]">
						<xsl:if test="字:节属性_421B/字:页码设置_4205/@起始编号_4152">
							<xsl:value-of select="字:节属性_421B/字:页码设置_4205/@起始编号_4152"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="((count(./字:段落属性_419B/child::*) = 1) and not(./字:段落属性_419B/字:自动编号信息_4186)) or (count(./字:段落属性_419B/child::*) &gt; 1)">
				<xsl:element name="style:style">
					<xsl:attribute name="style:family">paragraph</xsl:attribute>
					<xsl:attribute name="style:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
					<xsl:if test="$SpecialSection != 'none'">
						<xsl:attribute name="style:master-page-name"><xsl:value-of select="$SpecialSection"/></xsl:attribute>
					</xsl:if>
					<xsl:variable name="Stylename">
						<xsl:value-of select="./字:段落属性_419B/@式样引用_419C"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$Stylename != ''">
							<xsl:call-template name="FindParentStyleName">
								<xsl:with-param name="parentStyleName" select="$Stylename"/>
							</xsl:call-template>
							<!---<xsl:attribute name="style:parent-style-name"><xsl:value-of select="$Stylename"/></xsl:attribute>-->
							<xsl:element name="style:paragraph-properties">
								<!--xsl:call-template name="ParaParentProperties">
									<xsl:with-param name="Stylename" select="$Stylename"/>
								</xsl:call-template-->
								<xsl:for-each select="字:段落属性_419B">
									<xsl:call-template name="ParaPropertiesAll">
										<xsl:with-param name="Stylename" select="$Stylename"/>
									</xsl:call-template>
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="style:text-properties">
								<xsl:call-template name="TextParaParentProperties">
									<xsl:with-param name="Stylename" select="$Stylename"/>
								</xsl:call-template>
								<xsl:for-each select="字:段落属性_419B/字:句属性_4158">
									<xsl:call-template name="TextProperties"/>
								</xsl:for-each>
								<xsl:choose>
									<xsl:when test="字:段落属性_419B/字:是否允许单词断字_4194 and (string(字:段落属性_419B/字:是否允许单词断字_4194)='1' or string(字:段落属性_419B/字:是否允许单词断字_4194)='true')">
										<xsl:for-each select="字:段落属性_419B/字:是否允许单词断字_4194">
											<xsl:apply-templates select="." mode="text"/>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="字:段落属性_419B/字:是否取消断字_4192">
										<xsl:for-each select="字:段落属性_419B/字:是否取消断字_4192">
											<xsl:apply-templates select="." mode="paragraph"/>
										</xsl:for-each>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="style:paragraph-properties">
								<xsl:for-each select="字:段落属性_419B">
									<xsl:call-template name="ParaPropertiesAll">
										<xsl:with-param name="Stylename" select="$Stylename"/>
									</xsl:call-template>
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="style:text-properties">
								<xsl:for-each select="字:段落属性_419B/字:句属性_4158">
									<xsl:call-template name="TextProperties"/>
								</xsl:for-each>
								<xsl:choose>
									<xsl:when test="字:段落属性_419B/字:是否允许单词断字_4194 and (string(字:段落属性_419B/字:是否允许单词断字_4194)='1' or string(字:段落属性_419B/字:是否允许单词断字_4194)='true')">
										<xsl:for-each select="字:段落属性_419B/字:是否允许单词断字_4194">
											<xsl:apply-templates select="." mode="text"/>
										</xsl:for-each>
									</xsl:when>
									<xsl:when test="字:段落属性_419B/字:是否取消断字_4192">
										<xsl:for-each select="字:段落属性_419B/字:是否取消断字_4192">
											<xsl:apply-templates select="." mode="paragraph"/>
										</xsl:for-each>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="($SpecialSection !='none')">
					<xsl:variable name="Stylename">
						<xsl:value-of select="./字:段落属性_419B/@式样引用_419C"/>
					</xsl:variable>
					<xsl:if test="$Stylename">
						<xsl:element name="style:style">
							<xsl:attribute name="style:family">paragraph</xsl:attribute>
							<xsl:attribute name="style:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
							<xsl:if test="$SpecialSection != 'none'">
								<xsl:attribute name="style:master-page-name"><xsl:value-of select="$SpecialSection"/></xsl:attribute>
							</xsl:if>
							<xsl:element name="style:paragraph-properties">
								<xsl:if test="$PageNumberStart != ''">
									<xsl:attribute name="style:page-number"><xsl:value-of select="$PageNumberStart"/></xsl:attribute>
								</xsl:if>
								<xsl:call-template name="ParaParentProperties">
									<xsl:with-param name="Stylename" select="$Stylename"/>
								</xsl:call-template>
								<xsl:call-template name="ParaParentPropertiesElement">
									<xsl:with-param name="Stylename" select="$Stylename"/>
								</xsl:call-template>
							</xsl:element>
							<xsl:element name="style:text-properties">
								<xsl:call-template name="TextParaParentProperties">
									<xsl:with-param name="Stylename" select="$Stylename"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="($document_type='text') and preceding-sibling::*[1]//字:分页符_4163">
			<xsl:call-template name="PageBreakStyle"/>
		</xsl:if>
		<xsl:if test="($document_type='text') and .//字:分页符_4163">
			<xsl:call-template name="PageBreakStyle"/>
		</xsl:if>
		<xsl:if test="($document_type='text') and preceding-sibling::*[1]//字:分栏符_4160">
			<xsl:call-template name="PageColumnStyle"/>
		</xsl:if>
		<xsl:if test="($document_type='text') and .//字:分栏符_4160">
			<xsl:call-template name="PageColumnStyle"/>
		</xsl:if>
		<!--图形文字的文字排列方向，水平从右至左，需要生成新的式样-->
		<xsl:if test="ancestor::*[name() = '图:文本_803C']/图:文字排列方向_8042='r2l-t2b-90e-90w' or ancestor::*[name() = '图:文本_803C']/图:文字排列方向_8042='t2b-r2l-0e-0w' or ancestor::*[name() = '图:文本_803C']/图:文字排列方向_8042='r2l-t2b-0e-90w'">
			<xsl:element name="style:style">
				<xsl:attribute name="style:family">paragraph</xsl:attribute>
				<xsl:attribute name="style:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
				<xsl:variable name="Stylename" select="./字:段落属性_419B/@式样引用_419C"/>
				<xsl:choose>
					<xsl:when test="$Stylename != ''">
						<!--<xsl:attribute name="style:parent-style-name"><xsl:value-of select="$Stylename"/></xsl:attribute>-->
						<xsl:call-template name="FindParentStyleName">
							<xsl:with-param name="parentStyleName" select="$Stylename"/>
						</xsl:call-template>
						<style:paragraph-properties style:writing-mode="rl-tb" fo:text-align="end">
							<xsl:call-template name="ParaParentProperties">
								<xsl:with-param name="Stylename" select="$Stylename"/>
							</xsl:call-template>
							<xsl:for-each select="字:段落属性_419B">
								<xsl:call-template name="ParaPropertiesAll">
									<xsl:with-param name="Stylename" select="$Stylename"/>
								</xsl:call-template>
							</xsl:for-each>
						</style:paragraph-properties>
						<xsl:element name="style:text-properties">
							<xsl:call-template name="TextParaParentProperties">
								<xsl:with-param name="Stylename" select="$Stylename"/>
							</xsl:call-template>
							<xsl:for-each select="字:段落属性_419B/字:句属性_4158">
								<xsl:call-template name="TextProperties"/>
							</xsl:for-each>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<style:paragraph-properties style:writing-mode="rl-tb" fo:text-align="end">
							<xsl:for-each select="字:段落属性_419B">
								<xsl:call-template name="ParaPropertiesAll">
									<xsl:with-param name="Stylename" select="$Stylename"/>
								</xsl:call-template>
							</xsl:for-each>
						</style:paragraph-properties>
						<xsl:element name="style:text-properties">
							<xsl:for-each select="字:段落属性_419B/字:句属性_4158">
								<xsl:call-template name="TextProperties"/>
							</xsl:for-each>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="字:缩进_411D" mode="liststyle">
		<xsl:if test="字:左">
			<xsl:choose>
				<xsl:when test="字:左/字:绝对">
					<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(字:左/字:绝对/@字:值,$uofUnit)"/></xsl:attribute>
				</xsl:when>			
				<xsl:when test="字:左/字:相对">
					<xsl:variable name="a1">
						<xsl:value-of select="字:左/字:相对/@字:值"/>
					</xsl:variable>
					<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat($a1 * 10.5, 'pt')"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="字:首行">
			<xsl:variable name="a3">
				<xsl:value-of select="字:首行/字:相对/@字:值"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="字:首行/字:绝对">
					<xsl:variable name="indent">
						<xsl:value-of select="number(字:首行/字:绝对/@字:值) - number(字:左/字:绝对/@字:值)"/>
					</xsl:variable>
					<xsl:attribute name="fo:text-indent"><xsl:value-of select="concat($indent, $uofUnit)"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="字:首行/字:相对">
					<xsl:variable name="a3">
						<xsl:value-of select="字:首行/字:相对/@字:值"/>
					</xsl:variable>
					<xsl:variable name="a1">
						<xsl:choose>
							<xsl:when test="字:左/字:相对"><xsl:value-of select="字:左/字:相对/@字:值"/></xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="fo:text-indent"><xsl:value-of select="concat(($a3 - $a1) * 10.5, 'pt')"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>-->
	<xsl:template match="字:缩进_411D" mode="liststyle">
		<xsl:variable name="fontcharsize">
			<xsl:for-each select="..">
				<xsl:call-template name="ParaCharSize"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="字:首行_4111">
			<xsl:choose>
				<xsl:when test="字:首行_4111/字:绝对_4107">
					<xsl:attribute name="fo:text-indent"><xsl:value-of select="concat(字:首行_4111/字:绝对_4107/@值_410F, $uofUnit)"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="字:首行_4111/字:相对_4109">
					<xsl:variable name="a3" select="字:首行_4111/字:相对_4109/@值_4108"/>
					<xsl:attribute name="fo:text-indent"><xsl:value-of select="concat($a3 * $fontcharsize, 'pt')"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="字:左_410E">
			<xsl:choose>
				<xsl:when test="字:左_410E/字:绝对_4107">
					<xsl:variable name="textIndent">
						<xsl:choose>
							<xsl:when test="字:首行_4111/字:绝对_4107/@值_410F">
								<xsl:value-of select="字:首行_4111/字:绝对_4107/@值_410F"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="marginleft">
						<xsl:choose>
							<xsl:when test="number($textIndent &lt; 0)">
								<xsl:value-of select="number(字:左_410E/字:绝对_4107/@值_410F) - number($textIndent)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number(字:左_410E/字:绝对_4107/@值_410F)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat($marginleft, $uofUnit)"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="字:左_410E/字:相对_4109">
					<xsl:variable name="a3">
						<xsl:choose>
							<xsl:when test="字:首行_4111/字:相对_4109">
								<xsl:value-of select="字:首行_4111/字:相对_4109/@值_4108"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="a1" select="字:左_410E/字:相对_4109/@值_4108"/>
					<!--<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(($a1 - $a3) * 10.5, 'pt')"/></xsl:attribute>-->
					<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(($a1 - $a3) * $fontcharsize, 'pt')"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TextDisplayLevels">
		<xsl:param name="NumberFormatDisplay"/>
		<xsl:param name="Level"/>
		<xsl:variable name="NumberFormatDisplayAfter">
			<xsl:value-of select="substring-after($NumberFormatDisplay,'%')"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="substring-after($NumberFormatDisplayAfter,'%')">
				<xsl:call-template name="TextDisplayLevels">
					<xsl:with-param name="NumberFormatDisplay" select="$NumberFormatDisplayAfter"/>
					<xsl:with-param name="Level" select="number($Level)+1"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not(number($Level)=1)">
					<xsl:attribute name="text:display-levels"><xsl:value-of select="$Level"/></xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ListLevelProperties">
		<xsl:param name="type"/>
		<xsl:element name="style:list-level-properties">
			<xsl:if test="字:编号对齐方式_4113">
				<xsl:variable name="alignformat">
					<xsl:choose>
						<xsl:when test="字:编号对齐方式_4113='center' ">center</xsl:when>
						<xsl:when test="字:编号对齐方式_4113='right' ">end</xsl:when>
						<xsl:otherwise>left</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="fo:text-align"><xsl:value-of select="$alignformat"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$type = 'image'">
				<xsl:attribute name="style:vertical-pos">middle</xsl:attribute>
				<xsl:attribute name="style:vertical-rel">line</xsl:attribute>
				<xsl:variable name="imagewidth">
					<xsl:choose>
						<xsl:when test="字:图片符号_411B/@宽_C605">
							<xsl:value-of select="字:图片符号_411B/@宽_C605"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="number(0.27 div $other-to-cm-conversion-factor)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="imageheight">
					<xsl:choose>
						<xsl:when test="字:图片符号_411B/@长_C604">
							<xsl:value-of select="字:图片符号_411B/@长_C604"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="number(0.27 div $other-to-cm-conversion-factor)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="fo:width"><xsl:value-of select="concat($imagewidth,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="fo:height"><xsl:value-of select="concat($imageheight,$uofUnit)"/></xsl:attribute>
			</xsl:if>
			<!--演中编号的对齐-->
			<xsl:choose>
				<xsl:when test="$document_type='presentation'">
					<xsl:if test="字:缩进_411D/字:左_410E/字:绝对_4107">
						<xsl:attribute name="text:space-before"><xsl:value-of select="concat(字:缩进_411D/字:左_410E/字:绝对_4107/@值_410F,$uofUnit)"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="字:缩进_411D/字:首行_4111/字:绝对_4107">
						<xsl:attribute name="text:min-label-width"><xsl:value-of select="concat(字:缩进_411D/字:首行_4111/字:绝对_4107/@值_410F,$uofUnit)"/></xsl:attribute>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="text:list-level-position-and-space-mode">label-alignment</xsl:attribute>
					<xsl:element name="style:list-level-label-alignment">
						<xsl:if test="字:尾随字符_4114">
							<xsl:variable name="follow">
								<xsl:choose>
									<xsl:when test="字:尾随字符_4114 = 'space'">space</xsl:when>
									<xsl:when test="字:尾随字符_4114 = 'tab'">listtab</xsl:when>
									<xsl:otherwise>nothing</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:attribute name="text:label-followed-by"><xsl:value-of select="$follow"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="字:制表符位置_411E">
							<xsl:attribute name="text:list-tab-stop-position"><xsl:value-of select="concat(字:制表符位置_411E,$uofUnit)"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="字:缩进_411D">
							<xsl:apply-templates select="字:缩进_411D" mode="liststyle"/>
						</xsl:if>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:for-each select="字:符号字体_4116">
			<xsl:element name="style:text-properties">
				<xsl:call-template name="TextProperties"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="BulletList">
		<xsl:element name="text:list-level-style-bullet">
			<xsl:attribute name="text:level"><xsl:value-of select="number(@级别值_4121)"/></xsl:attribute>
			<xsl:attribute name="text:bullet-char"><xsl:value-of select="字:项目符号_4115"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="count(字:符号字体_4116/child::*)=0 and 字:符号字体_4116/@式样引用_4247">
					<xsl:attribute name="text:style-name"><xsl:value-of select="字:符号字体_4116/@式样引用_4247"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="text:style-name"><xsl:value-of select="generate-id(字:符号字体_4116)"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="ListLevelProperties"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="ImageList">
		<xsl:element name="text:list-level-style-image">
			<xsl:attribute name="text:level"><xsl:value-of select="number(@级别值_4121)"/></xsl:attribute>
			<xsl:if test="字:图片符号_411B">
				<xsl:variable name="gid">
					<xsl:value-of select="字:图片符号_411B/@引用_411C"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="key('other-styles',$gid)/对象:路径_D703">
						<xsl:attribute name="xlink:href"><xsl:value-of select="replace(key('other-styles',$gid)/对象:路径_D703,'/data','Pictures')"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="key('other-styles',$gid)/对象:数据_D702">
						<xsl:call-template name="BinaryGraphic">
							<xsl:with-param name="refGraphic" select="$gid"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
			<xsl:call-template name="ListLevelProperties">
				<xsl:with-param name="type" select="'image'"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template name="NumberList">
		<xsl:element name="text:list-level-style-number">
			<xsl:attribute name="text:level"><xsl:value-of select="number(@级别值_4121)"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="count(字:符号字体_4116/child::*)=0 and 字:符号字体_4116/@式样引用_4247">
					<xsl:attribute name="text:style-name"><xsl:value-of select="字:符号字体_4116/@式样引用_4247"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="text:style-name"><xsl:value-of select="generate-id(字:符号字体_4116)"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="字:起始编号_411F">
				<xsl:attribute name="text:start-value"><xsl:value-of select="字:起始编号_411F"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="字:是否使用正规格式_4120">
				<xsl:variable name="regular">
					<xsl:choose>
						<xsl:when test="字:是否使用正规格式_4120='true' or 字:是否使用正规格式_4120='1'">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="text:num-regular-exp"><xsl:value-of select="$regular"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="字:编号格式_4119">
				<xsl:variable name="format">
					<xsl:call-template name="NumberFormat">
						<xsl:with-param name="oo_format" select="字:编号格式_4119"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:attribute name="style:num-format"><xsl:value-of select="$format"/></xsl:attribute>
				<xsl:variable name="NumSuffix">
					<xsl:variable name="suffix">
						<xsl:choose>
							<xsl:when test="字:编号格式_4119='decimal-enclosed-fullstop'">
								<xsl:value-of select="'.'"/>
							</xsl:when>
							<xsl:when test="字:编号格式_4119='decimal-enclosed-paren'">
								<xsl:value-of select="')'"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:value-of select="concat($suffix,substring-after(字:编号格式表示_411A,concat('%',@级别值_4121)))"/>
				</xsl:variable>
				<xsl:if test="$NumSuffix !=''">
					<xsl:attribute name="style:num-suffix"><xsl:value-of select="$NumSuffix"/></xsl:attribute>
				</xsl:if>
				<xsl:variable name="NumPrefix">
					<xsl:variable name="prefix">
						<xsl:if test="字:编号格式_4119='decimal-enclosed-paren'">
							<xsl:value-of select="'('"/>
						</xsl:if>
					</xsl:variable>
					<xsl:value-of select="concat(substring-before(字:编号格式表示_411A,'%'),$prefix)"/>
				</xsl:variable>
				<xsl:if test="$NumPrefix !=''">
					<xsl:attribute name="style:num-prefix"><xsl:value-of select="$NumPrefix"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="字:编号格式表示_411A">
					<xsl:call-template name="TextDisplayLevels">
						<xsl:with-param name="NumberFormatDisplay">
							<xsl:value-of select="字:编号格式表示_411A"/>
						</xsl:with-param>
						<xsl:with-param name="Level">
							<xsl:value-of select="1"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
			<xsl:call-template name="ListLevelProperties"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="字:自动编号_4124" mode="liststyle">
		<xsl:element name="text:list-style">
			<xsl:attribute name="style:name"><xsl:value-of select="@标识符_4100"/></xsl:attribute>
			<xsl:attribute name="style:display-name"><xsl:value-of select="@名称_4122"/></xsl:attribute>
			<xsl:for-each select="字:级别_4112">
				<xsl:choose>
					<xsl:when test="字:项目符号_4115">
						<xsl:call-template name="BulletList"/>
					</xsl:when>
					<xsl:when test="字:图片符号_411B">
						<xsl:call-template name="ImageList"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="NumberList"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="字:宽度_41A1" mode="texttable">
		<xsl:param name="tableAlign"/>
		<xsl:choose>
			<xsl:when test="@相对宽度_41C0">
				<xsl:variable name="reltblw">
					<xsl:value-of select="@相对宽度_41C0"/>
				</xsl:variable>
				<!-- alert staring 
				<xsl:variable name="pagew">
					<xsl:for-each select="key('textTable',../@标识符_4100)">
						<xsl:value-of select="preceding::字:分节_416A[1]/字:节属性_421B/字:纸张_41EC/@宽_C605"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="leftm">
					<xsl:for-each select="key('textTable',../@标识符_4100)">
						<xsl:value-of select="preceding::字:分节_416A[1]/字:节属性_421B/字:页边距_41EB/@左_C608"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="rightm">
					<xsl:for-each select="key('textTable',../@标识符_4100)">
						<xsl:value-of select="preceding::字:分节_416A[1]/字:节属性_421B/字:页边距_41EB/@右_C60A"/>
					</xsl:for-each>
				</xsl:variable>-->
				<xsl:variable name="textTableAttrUse">
					<xsl:value-of select="../@标识符_4100"/>
				</xsl:variable>
				<xsl:variable name="page">
					<xsl:choose>
						<xsl:when test="$textTableAttrUse">
							<xsl:for-each select="key('textTable',../@标识符_4100)">
								<xsl:value-of select="preceding::字:分节_416A[1]"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../../preceding::字:分节_416A[1]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="pagew">
					<xsl:choose>
						<xsl:when test="$page/字:节属性_421B/字:纸张_41EC/@宽_C605">
							<xsl:value-of select="$page/字:节属性_421B/字:纸张_41EC/@宽_C605"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="21"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="leftm">
					<xsl:choose>
						<xsl:when test="$page/字:节属性_421B/字:节属性_421B/字:页边距_41EB/@左_C608">
							<xsl:value-of select="$page/字:节属性_421B/字:页边距_41EB/@左_C608"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="3.175"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="rightm">
					<xsl:choose>
						<xsl:when test="$page/字:节属性_421B/字:节属性_421B/字:页边距_41EB/@右_C60A8">
							<xsl:value-of select="$page/字:节属性_421B/字:页边距_41EB/@右_C60A"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="3.175"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- alert ending. -->
				<xsl:attribute name="style:rel-width"><xsl:value-of select="concat(number(@相对宽度_41C0),'%')"/></xsl:attribute>
				<xsl:attribute name="style:width"><xsl:value-of select="concat((number($pagew)-number($leftm)-number($rightm)) * number($reltblw) div 100,$uofUnit)"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="$tableAlign='left'">
						<xsl:attribute name="fo:margin-right"><xsl:value-of select="concat((number($pagew)-number($leftm)-number($rightm)) *(1- number($reltblw) div 100),$uofUnit)"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="$tableAlign='right'">
						<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat((number($pagew)-number($leftm)-number($rightm)) *(1- number($reltblw) div 100),$uofUnit)"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="fo:margin-right"><xsl:value-of select="concat((number($pagew)-number($leftm)-number($rightm)) *(1- number($reltblw) div 100),$uofUnit)"/></xsl:attribute>
						<!--<xsl:attribute name="table:align">margins</xsl:attribute>-->
						<xsl:attribute name="table:align">left</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="./@绝对宽度_41BF">
				<xsl:attribute name="style:width"><xsl:value-of select="concat(number(@绝对宽度_41BF),$uofUnit)"/></xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:对齐_41C3" mode="texttable">
		<xsl:attribute name="table:align"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:左缩进_41C4" mode="texttable">
		<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(number(.),$uofUnit)"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:绕排_41C5" mode="texttable">
	</xsl:template>
	<xsl:template match="字:绕排边距_41C6" mode="texttable">
		<xsl:if test="@左_C608">
			<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(@左_C608, $uofUnit)"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@右_C60A">
			<xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(@右_C60A, $uofUnit)"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@上_C609">
			<xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(@上_C609,$uofUnit)"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@下_C60B">
			<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(@下_C60B,$uofUnit)"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:位置_41C7" mode="texttable">
		<xsl:variable name="verticalRel">
			<xsl:choose>
				<xsl:when test="uof:垂直_410D/@相对于_4103='page'">page</xsl:when>
				<xsl:when test="uof:垂直_410D/@相对于_4103='paragraph'">paragraph</xsl:when>
				<xsl:when test="uof:垂直_410D/@相对于_4103='margin'">page-content</xsl:when>
				<xsl:when test="uof:垂直_410D/@相对于_4103='line'">line</xsl:when>
				<xsl:when test="uof:垂直_410D/@相对于_410C='page'">page</xsl:when>
				<xsl:when test="uof:垂直_410D/@相对于_410C='paragraph'">paragraph</xsl:when>
				<xsl:when test="uof:垂直_410D/@相对于_410C='margin'">page-content</xsl:when>
				<xsl:when test="uof:垂直_410D/@相对于_410C='line'">line</xsl:when>
				<xsl:otherwise>paragraph</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="horizontalRel">
			<xsl:choose>
				<xsl:when test="uof:水平_4106/@相对于_4103='margin'">page-content</xsl:when>
				<xsl:when test="uof:水平_4106/@相对于_4103='page'">page</xsl:when>
				<xsl:when test="uof:水平_4106/@相对于_4103='char'">char</xsl:when>
				<xsl:when test="uof:水平_4106/@相对于_4103='column'">paragraph</xsl:when>
				<xsl:when test="uof:水平_4106/@相对于_410C='margin'">page-content</xsl:when>
				<xsl:when test="uof:水平_4106/@相对于_410C='page'">page</xsl:when>
				<xsl:when test="uof:水平_4106/@相对于_410C='char'">char</xsl:when>
				<xsl:when test="uof:水平_4106/@相对于_410C='column'">paragraph</xsl:when>
				<xsl:otherwise>paragraph</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="style:vertical-rel"><xsl:value-of select="$verticalRel"/></xsl:attribute>
		<xsl:attribute name="style:horizontal-rel"><xsl:value-of select="$horizontalRel"/></xsl:attribute>
		<xsl:variable name="verticalPos">
			<xsl:choose>
				<xsl:when test="string(uof:垂直_410D/uof:相对_4109/@值_410B) != '0'">from-top</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="uof:垂直_410D/uof:相对_4109/@参考点_410A"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="horizontalPos">
			<xsl:choose>
				<xsl:when test="string(uof:水平_4106/uof:相对_4109/@值_410B) != '0'">left</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="uof:水平_4106/uof:相对_4109/@参考点_410A"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="style:vertical-pos"><xsl:value-of select="$verticalPos"/></xsl:attribute>
		<xsl:attribute name="style:horizontal-pos"><xsl:value-of select="$horizontalPos"/></xsl:attribute>
		<xsl:if test="uof:垂直_410D/uof:相对_4109/@值_410B">
			<xsl:attribute name="svg:y"><xsl:value-of select="concat(uof:垂直_410D/uof:相对_4109/@值_410B,$uofUnit)"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="uof:水平_4106/uof:相对_4109/@值_410B">
			<xsl:attribute name="svg:x"><xsl:value-of select="concat(uof:水平_4106/uof:相对_4109/@值_410B,$uofUnit)"/></xsl:attribute>
		</xsl:if>
		<!-- fo:margin-left -->
		<xsl:attribute name="fo:margin-left"><xsl:if test="uof:水平_4106/uof:绝对_4107/@值_4108"><xsl:value-of select="concat( uof:水平_4106/uof:绝对_4107/@值_4108, $uofUnit)"/></xsl:if></xsl:attribute>
	</xsl:template>
	<xsl:template name="TableBorderToCell">
		<xsl:param name="pTableBorder"/>
		<xsl:param name="IsFirstRow"/>
		<xsl:param name="IsLastRow"/>
		<xsl:param name="IsFirstCell"/>
		<xsl:param name="IsLastCell"/>
		<xsl:choose>
			<xsl:when test="$IsFirstRow='true' and $IsLastRow='true'">
				<xsl:choose>
					<xsl:when test="$IsFirstCell='true' and $IsLastCell='true'">
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:上_C614"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:下_C616"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:左_C613"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:右_C615"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$IsFirstCell='true'">
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:上_C614"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:下_C616"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:左_C613"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:内部竖线_C61A"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$IsLastCell='true'">
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:上_C614"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:下_C616"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:内部竖线_C61A"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:右_C615"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:上_C614"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:下_C616"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:内部竖线_C61A"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:内部竖线_C61A"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$IsFirstRow='true'">
				<xsl:choose>
					<xsl:when test="$IsFirstCell='true' and $IsLastCell='true'">
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:上_C614"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:左_C613"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:右_C615"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$IsFirstCell='true'">
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:上_C614"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:左_C613"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:内部竖线_C61A"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$IsLastCell='true'">
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:上_C614"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:内部竖线_C61A"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:右_C615"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:上_C614"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:内部竖线_C61A"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:内部竖线_C61A"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$IsLastRow='true'">
				<xsl:choose>
					<xsl:when test="$IsFirstCell='true' and $IsLastCell='true'">
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:下_C616"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:左_C613"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:右_C615"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$IsFirstCell='true'">
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:下_C616"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:左_C613"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:内部竖线_C61A"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$IsLastCell='true'">
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:下_C616"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:内部竖线_C61A"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:右_C615"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:下_C616"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:内部竖线_C61A"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:内部竖线_C61A"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$IsFirstCell='true' and $IsLastCell='true'">
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:左_C613"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:右_C615"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$IsFirstCell='true'">
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:左_C613"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:内部竖线_C61A"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$IsLastCell='true'">
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:内部竖线_C61A"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:右_C615"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="CommonBorder">
							<xsl:with-param name="pUp" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pDown" select="$pTableBorder/uof:内部横线_C619"/>
							<xsl:with-param name="pLeft" select="$pTableBorder/uof:内部竖线_C61A"/>
							<xsl:with-param name="pRight" select="$pTableBorder/uof:内部竖线_C61A"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:边框_4133" mode="texttable">
		<!-- it should be calculated in texttablecell element
		<xsl:call-template name="CommonBorder"/>
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
		<xsl:if test="uof:下_C616/@uof:阴影='true'or uof:下_C616/@uof:阴影='1'">
			<xsl:if test="uof:左/@uof:阴影='true'or uof:左/@uof:阴影='1'">
				<xsl:attribute name="style:shadow">#808080 -0.18cm 0.18cm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="uof:下_C616/@uof:阴影='true'or uof:下_C616/@uof:阴影='1'">
			<xsl:if test="uof:右/@uof:阴影='true'or uof:右/@uof:阴影='1'">
				<xsl:attribute name="style:shadow">#808080 0.18cm 0.18cm</xsl:attribute>
			</xsl:if>
		</xsl:if>-->
	</xsl:template>
	<xsl:template match="字:填充_4134" mode="texttableAttr">
		<xsl:call-template name="CommonFillAttr"/>
	</xsl:template>
	<xsl:template match="字:填充_4134" mode="texttableElement">
		<xsl:call-template name="CommonFillElement"/>
	</xsl:template>
	<xsl:template match="字:是否自动调整大小_41C8" mode="texttable">
	</xsl:template>
	<xsl:template match="字:默认默认单元格边距_41CA" mode="texttable">
	</xsl:template>
	<xsl:template match="字:默认单元格间距_41CB" mode="texttable">
		<xsl:if test=".!=''">
			<xsl:attribute name="style:table-cell-spacing"><xsl:value-of select="concat(number(.),$uofUnit)"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TablePropertiesAttr">
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name(.)='字:宽度_41A1'">
					<!-- alert staring 
				   <xsl:apply-templates select="." mode="texttable"/>-->
					<xsl:apply-templates select="." mode="texttable">
						<xsl:with-param name="tableAlign" select="../字:对齐_41C3"/>
					</xsl:apply-templates>
					<!-- alert ending. -->
				</xsl:when>
				<xsl:when test="name(.)='字:列宽集_41C1'">
					<!-- don't process this node here, it contains a element-->
				</xsl:when>
				<xsl:when test="name(.)='字:对齐_41C3'">
					<xsl:apply-templates select="." mode="texttable"/>
				</xsl:when>
				<xsl:when test="name(.)='字:左缩进_41C4'">
					<xsl:apply-templates select="." mode="texttable"/>
				</xsl:when>
				<xsl:when test="name(.)='字:绕排_41C5'">
					<xsl:apply-templates select="." mode="texttable"/>
				</xsl:when>
				<xsl:when test="name(.)='字:绕排边距_41C6'">
					<xsl:apply-templates select="." mode="texttable"/>
				</xsl:when>
				<xsl:when test="name(.)='字:位置_41C7'">
					<xsl:apply-templates select="." mode="texttable"/>
				</xsl:when>
				<xsl:when test="name(.)='字:边框_4133'">
					<xsl:apply-templates select="." mode="texttable"/>
				</xsl:when>
				<xsl:when test="name(.)='字:填充_4134'">
					<xsl:apply-templates select="." mode="texttableAttr"/>
				</xsl:when>
				<xsl:when test="name(.)='字:是否自动调整大小_41C8'">
					<xsl:apply-templates select="." mode="texttable"/>
				</xsl:when>
				<xsl:when test="name(.)='字:默认默认单元格边距_41CA'">
					<xsl:apply-templates select="." mode="texttable"/>
				</xsl:when>
				<xsl:when test="name(.)='字:默认单元格间距_41CB'">
					<xsl:apply-templates select="." mode="texttable"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		<xsl:if test="not(字:宽度_41A1) and 字:列宽集_41C1">
			<xsl:variable name="tblsize" select="sum(字:列宽集_41C1/字:列宽_41C2)"/>
			<xsl:attribute name="style:width"><xsl:value-of select="concat($tblsize,$uofUnit)"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TablePropertiesElement">
		<xsl:if test="字:填充_4134">
			<xsl:apply-templates select="字:填充_4134" mode="texttableElement"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TablePropertiesAll">
		<xsl:call-template name="TablePropertiesAttr"/>
		<xsl:call-template name="TablePropertiesElement"/>
	</xsl:template>
	<xsl:template name="OneTextTableStyle">
		<xsl:attribute name="style:family">table</xsl:attribute>
		<xsl:attribute name="style:name"><xsl:value-of select="@标识符_4100"/></xsl:attribute>
		<xsl:choose>
			<xsl:when test="@别名_4103">
				<xsl:attribute name="style:display-name"><xsl:value-of select="@别名_4103"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="style:display-name"><xsl:value-of select="@标识符_4100"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="@基式样引用_4104">
			<xsl:attribute name="style:parent-style-name"><xsl:value-of select="@基式样引用_4104"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@后继式样引用_4105">
			<xsl:attribute name="style:next-style-name"><xsl:value-of select="@后继式样引用_4105"/></xsl:attribute>
		</xsl:if>
		<xsl:element name="style:table-properties">
			<xsl:attribute name="table:border-model">collapsing</xsl:attribute>
			<xsl:call-template name="TablePropertiesAll"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="式样:文字表式样_9918">
		<xsl:param name="Type"/>
		<xsl:if test="@类型_4102=$Type">
			<xsl:choose>
				<xsl:when test="$Type='default'">
					<xsl:element name="style:default-style">
						<xsl:attribute name="style:family">table</xsl:attribute>
						<xsl:element name="style:table-properties">
							<xsl:attribute name="table:border-model">collapsing</xsl:attribute>
							<xsl:call-template name="TablePropertiesAll"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="style:style">
						<xsl:call-template name="OneTextTableStyle"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$Type='custom'">
					<xsl:element name="style:style">
						<xsl:call-template name="OneTextTableStyle"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$Type='auto'">
					<xsl:element name="style:style">
						<xsl:call-template name="OneTextTableStyle"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:填充_4134" mode="texttablecell">
		<xsl:call-template name="CommonFill"/>
	</xsl:template>
	<xsl:template match="字:边框_4133" mode="texttablecell">
		<!--<xsl:call-template name="CommonBorder"/>-->
	</xsl:template>
	<xsl:template name="ParentTextTableBorder">
		<xsl:param name="IsFirstRow"/>
		<xsl:param name="IsLastRow"/>
		<xsl:param name="IsFirstCell"/>
		<xsl:param name="IsLastCell"/>
		<xsl:param name="Stylename"/>
		<xsl:for-each select="key('uof-table-styles',$Stylename)">
			<xsl:choose>
				<xsl:when test="@基式样引用_4104">
					<xsl:call-template name="ParentTextTableBorder">
						<xsl:with-param name="IsFirstRow" select="$IsFirstRow"/>
						<xsl:with-param name="IsLastRow" select="$IsLastRow"/>
						<xsl:with-param name="IsFirstCell" select="$IsFirstCell"/>
						<xsl:with-param name="IsLastCell" select="$IsLastCell"/>
						<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:文字表式样集_9917/式样:文字表式样_9918[@字:类型='default'][1]">
						<xsl:call-template name="TableBorderToCell">
							<xsl:with-param name="pTableBorder" select="字:文字表边框_4227"/>
							<xsl:with-param name="IsFirstRow" select="$IsFirstRow"/>
							<xsl:with-param name="IsLastRow" select="$IsLastRow"/>
							<xsl:with-param name="IsFirstCell" select="$IsFirstCell"/>
							<xsl:with-param name="IsLastCell" select="$IsLastCell"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="TableBorderToCell">
				<xsl:with-param name="pTableBorder" select="字:文字表边框_4227"/>
				<xsl:with-param name="IsFirstRow" select="$IsFirstRow"/>
				<xsl:with-param name="IsLastRow" select="$IsLastRow"/>
				<xsl:with-param name="IsFirstCell" select="$IsFirstCell"/>
				<xsl:with-param name="IsLastCell" select="$IsLastCell"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="TextTableBorder">
		<xsl:param name="pCell"/>
		<xsl:param name="pTable"/>
		<xsl:param name="pTableStyle"/>
		<xsl:param name="IsFirstRow"/>
		<xsl:param name="IsLastRow"/>
		<xsl:param name="IsFirstCell"/>
		<xsl:param name="IsLastCell"/>
		<xsl:if test="$pTableStyle">
			<xsl:call-template name="ParentTextTableBorder">
				<xsl:with-param name="IsFirstRow" select="$IsFirstRow"/>
				<xsl:with-param name="IsLastRow" select="$IsLastRow"/>
				<xsl:with-param name="IsFirstCell" select="$IsFirstCell"/>
				<xsl:with-param name="IsLastCell" select="$IsLastCell"/>
				<xsl:with-param name="Stylename" select="$pTableStyle/@基式样引用_4104"/>
			</xsl:call-template>
			<xsl:call-template name="TableBorderToCell">
				<xsl:with-param name="pTableBorder" select="$pTableStyle/字:文字表边框_4227"/>
				<xsl:with-param name="IsFirstRow" select="$IsFirstRow"/>
				<xsl:with-param name="IsLastRow" select="$IsLastRow"/>
				<xsl:with-param name="IsFirstCell" select="$IsFirstCell"/>
				<xsl:with-param name="IsLastCell" select="$IsLastCell"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$pTable">
			<xsl:call-template name="TableBorderToCell">
				<xsl:with-param name="pTableBorder" select="$pTable/字:文字表属性_41CC/字:文字表边框_4227"/>
				<xsl:with-param name="IsFirstRow" select="$IsFirstRow"/>
				<xsl:with-param name="IsLastRow" select="$IsLastRow"/>
				<xsl:with-param name="IsFirstCell" select="$IsFirstCell"/>
				<xsl:with-param name="IsLastCell" select="$IsLastCell"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$pCell">
			<xsl:call-template name="CommonBorder">
				<xsl:with-param name="pUp" select="$pCell/字:单元格属性_41B7/字:边框_4133/uof:上_C614"/>
				<xsl:with-param name="pDown" select="$pCell/字:单元格属性_41B7/字:边框_4133/uof:下_C616"/>
				<xsl:with-param name="pLeft" select="$pCell/字:单元格属性_41B7/字:边框_4133/uof:左_C613"/>
				<xsl:with-param name="pRight" select="$pCell/字:单元格属性_41B7/字:边框_4133/uof:右_C615"/>
				<xsl:with-param name="pDiagon1" select="$pCell/字:单元格属性_41B7/字:边框_4133/uof:对角线1"/>
				<xsl:with-param name="pDiagon2" select="$pCell/字:单元格属性_41B7/字:边框_4133/uof:对角线2"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TextTableCellPadding">
		<xsl:param name="Style"/>
		<xsl:choose>
			<xsl:when test="$Style[1]/@左_C608">
				<xsl:attribute name="fo:padding-left"><xsl:value-of select="concat(number($Style[1]/@左_C608),$uofUnit)"/></xsl:attribute>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$Style[1]/@右_C60A">
				<xsl:attribute name="fo:padding-right"><xsl:value-of select="concat(number($Style[1]/@右_C60A),$uofUnit)"/></xsl:attribute>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$Style[1]/@上_C609">
				<xsl:attribute name="fo:padding-top"><xsl:value-of select="concat(number($Style[1]/@上_C609),$uofUnit)"/></xsl:attribute>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$Style[1]/@下_C60B">
				<xsl:attribute name="fo:padding-bottom"><xsl:value-of select="concat(number($Style[1]/@下_C60B),$uofUnit)"/></xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="UOFTextCellPadding">
		<xsl:param name="pCellPad"/>
		<xsl:param name="pTablePad"/>
		<xsl:param name="pTableStylePad"/>
		<xsl:if test="$pTableStylePad">
			<xsl:call-template name="TextTableCellPadding">
				<xsl:with-param name="Style" select="$pTableStylePad"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$pTablePad">
			<xsl:call-template name="TextTableCellPadding">
				<xsl:with-param name="Style" select="$pTablePad"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$pCellPad">
			<xsl:call-template name="TextTableCellPadding">
				<xsl:with-param name="Style" select="$pCellPad"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:表行属性_41BD" mode="texttable">
		<xsl:if test="count(./child::*)">
			<xsl:element name="style:style">
				<xsl:attribute name="style:family">table-row</xsl:attribute>
				<xsl:attribute name="style:name"><xsl:value-of select="generate-id(..)"/></xsl:attribute>
				<xsl:element name="style:table-row-properties">
					<xsl:for-each select="*">
						<xsl:choose>
							<xsl:when test="name(.)='字:高度_41B8'">
								<xsl:if test="@固定值_41B9">
									<xsl:attribute name="style:row-height"><xsl:value-of select="concat(number(@固定值_41B9),$uofUnit)"/></xsl:attribute>
								</xsl:if>
								<xsl:if test="@最小值_41BA">
									<xsl:attribute name="style:min-row-height"><xsl:value-of select="concat(number(@最小值_41BA), $uofUnit )"/></xsl:attribute>
								</xsl:if>
							</xsl:when>
							<xsl:when test="name(.)='字:是否跨页_41BB'">
								<xsl:attribute name="style:keep-together"><xsl:choose><xsl:when test="string(.) != ''"><xsl:value-of select="."/></xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
								<xsl:attribute name="fo:keep-together"><xsl:choose><xsl:when test="string(.) = 'true'">auto</xsl:when><xsl:otherwise>always</xsl:otherwise></xsl:choose></xsl:attribute>
							</xsl:when>
							<xsl:when test="name(.)='字:是否表头行_41BC行'">
								<!-- process these element in content file-->
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:列宽集_41C1" mode="texttable">
		<xsl:for-each select="字:列宽_41C2">
			<xsl:element name="style:style">
				<xsl:attribute name="style:family">table-column</xsl:attribute>
				<xsl:attribute name="style:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
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
	</xsl:template>
	<xsl:template name="TableParentProperties">
		<xsl:param name="Stylename"/>
		<xsl:for-each select="key('uof-table-styles',$Stylename)">
			<xsl:if test="@基式样引用_4104">
				<xsl:call-template name="TableParentProperties">
					<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:call-template name="TablePropertiesAttr"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="字:文字表属性_41CC" mode="embeded_into_frame">
		<xsl:if test="字:位置_41C7/uof:垂直_410D[@相对于_C647 = 'margin']/uof:相对_4109[@参考点_410B = 'bottom']">">
			<xsl:element name="style:style">
				<xsl:attribute name="style:name">Embeded_fr<xsl:number count="字:文字表_416C[not(@类型_4102='sub-table')]" from="/uof:UOF_0000/字:文字处理文档_4225" level="any" format="1"/></xsl:attribute>
				<xsl:attribute name="style:family"><xsl:value-of select="'graphic'"/></xsl:attribute>
				<xsl:attribute name="style:parent-style-name"><xsl:value-of select="'Frame'"/></xsl:attribute>
				<xsl:element name="style:graphic-properties">
					<xsl:if test="字:绕排边距_41C6/@左_C608">
						<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(字:绕排边距_41C6/@左_C608, $uofUnit)"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="字:绕排边距_41C6/@右_C60A">
						<xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(字:绕排边距_41C6/@右_C60A, $uofUnit)"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="字:位置_41C7/uof:垂直_410D/uof:相对_4109/@值_410B">
						<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(字:位置_41C7/uof:垂直_410D/uof:相对_4109/@值_410B, $uofUnit)"/></xsl:attribute>
					</xsl:if>
					<xsl:attribute name="style:wrap"><xsl:value-of select="'dynamic'"/></xsl:attribute>
					<xsl:attribute name="style:number-wrapped-paragraphs"><xsl:value-of select="'no-limit'"/></xsl:attribute>
					<xsl:attribute name="style:vertical-pos"><xsl:value-of select="'bottom'"/></xsl:attribute>
					<xsl:attribute name="fo:background-color"><xsl:value-of select="'#ffffff'"/></xsl:attribute>
					<xsl:attribute name="style:background-transparency"><xsl:value-of select="'100%'"/></xsl:attribute>
					<xsl:attribute name="style:writing-mode"><xsl:value-of select="'lr-tb'"/></xsl:attribute>
					<xsl:attribute name="style:vertical-rel"><xsl:value-of select="'page-content'"/></xsl:attribute>
					<xsl:attribute name="style:horizontal-pos"><xsl:value-of select="字:位置_41C7/uof:水平_4106/uof:相对_4109/@参考点_410A"/></xsl:attribute>
					<xsl:attribute name="style:horizontal-rel"><xsl:value-of select="'paragraph-content'"/></xsl:attribute>
					<xsl:attribute name="draw:wrap-influence-on-position"><xsl:value-of select="'once-successive'"/></xsl:attribute>
					<xsl:attribute name="fo:border"><xsl:value-of select="'none'"/></xsl:attribute>
					<style:background-image/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:文字表属性_41CC" mode="texttable">
		<xsl:variable name="newstyle">
			<xsl:variable name="nChildCount" select="count(./*)"/>
			<xsl:choose>
				<xsl:when test="$nChildCount = 0">
					<xsl:value-of select="0"/>
				</xsl:when>
				<!--
				<xsl:when test="$nChildCount = 1">
					<xsl:choose>
						<xsl:when test="node()[1][name(.)='字:列宽集_41C1']">
							<xsl:value-of select="0"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>-->
				<xsl:otherwise>
					<xsl:value-of select="1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="SpecialSection">
			<xsl:for-each select="..">
				<xsl:choose>
					<xsl:when test="($document_type='text') and (name(..) = '字:文字处理文档_4225')">
						<xsl:variable name="SectPos">
							<xsl:choose>
								<xsl:when test="preceding-sibling::*[1][name(.) = '字:分节_416A'] and preceding-sibling::*[1]/字:节属性_421B/字:节类型_41EA != 'continuous'">
									<!--xsl:call-template name="IsPrecedeType">
										<xsl:with-param name="nodename" select="'字:分节_416A'"/>
										<xsl:with-param name="pos" select="0"/>
									</xsl:call-template-->
									<xsl:value-of select="1"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="0"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="number($SectPos) &gt; 0">
								<xsl:for-each select="preceding-sibling::*[position() = $SectPos]">
									<xsl:choose>
										<xsl:when test="字:节属性_421B/字:是否首页页眉页脚不同_41EE = 'true'">
											<xsl:value-of select="generate-id(字:节属性_421B/字:是否首页页眉页脚不同_41EE)"/>
										</xsl:when>
										<!--xsl:when test="字:节属性_421B/字:页码设置_4205/@字:首页显示 = 'false'">
											<xsl:value-of select="generate-id(字:节属性_421B/字:页码设置)"/>
										</xsl:when-->
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="@名称_4166='RoStandard'">
													<xsl:value-of select="string('none')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="nsof:NeoShineOfficeID(.)"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="string('none')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="string('none')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="($newstyle = 1) or ($SpecialSection !='none')">
			<xsl:element name="style:style">
				<xsl:variable name="styleName" select="@式样引用_419C"/>
				<xsl:attribute name="style:family">table</xsl:attribute>
				<xsl:attribute name="style:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
				<xsl:if test="$SpecialSection != 'none'">
					<xsl:attribute name="style:master-page-name"><xsl:value-of select="$SpecialSection"/></xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="@式样引用_419C">
						<xsl:attribute name="style:parent-style-name"><xsl:value-of select="@式样引用_419C"/></xsl:attribute>
						<xsl:element name="style:table-properties">
							<xsl:attribute name="table:border-model">collapsing</xsl:attribute>
							<xsl:call-template name="TableParentProperties">
								<xsl:with-param name="Stylename" select="@式样引用_419C"/>
							</xsl:call-template>
							<xsl:call-template name="TableParentProperties">
								<xsl:with-param name="Stylename" select="@式样引用_419C"/>
							</xsl:call-template>
							<xsl:call-template name="TablePropertiesAttr"/>
							<xsl:choose>
								<xsl:when test="字:填充_4134">
									<xsl:call-template name="TablePropertiesElement"/>
								</xsl:when>
								<xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:文字表式样集_9917/式样:文字表式样_9918[@标识符_4100 = $styleName]/字:填充_4134">
									<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:文字表式样集_9917/式样:文字表式样_9918[@标识符_4100 = $styleName]">
										<xsl:call-template name="TablePropertiesElement"/>
									</xsl:for-each>
								</xsl:when>
							</xsl:choose>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="style:table-properties">
							<xsl:attribute name="table:border-model">collapsing</xsl:attribute>
							<xsl:call-template name="TablePropertiesAll"/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
		<xsl:if test="字:列宽集_41C1">
			<xsl:apply-templates select="字:列宽集_41C1" mode="texttable"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="BodyTextTableStyle">
		<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:批注集_B669/规则:批注_B66A//字:文字表_416C | /uof:UOF_0000/字:文字处理文档_4225//字:文字表_416C | /uof:UOF_0000/图形:图形集_7C00/图:图形_8062/图:文本_803C/图:内容_8043//字:文字表_416C | /uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825/表:工作表属性_E80D/表:页面设置_E7C1//字:文字表_416C">
			<xsl:apply-templates select="字:文字表属性_41CC" mode="texttable"/>
			<xsl:variable name="CreateColumn">
				<xsl:choose>
					<xsl:when test="not(字:文字表属性_41CC/字:列宽集_41C1)">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="pTable" select="."/>
			<xsl:for-each select="字:行_41CD">
				<xsl:apply-templates select="字:表行属性_41BD" mode="texttable"/>
				<xsl:variable name="IsFirstRow">
					<xsl:choose>
						<xsl:when test="position() = 1">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="IsLastRow">
					<xsl:choose>
						<xsl:when test="position() = last()">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="($CreateColumn = 'true') and (position()= 1)">
					<xsl:variable name="bodywidth">
						<xsl:variable name="pagew">
							<xsl:value-of select="preceding::字:分节_416A[1]/字:节属性_421B/字:纸张_41EC/@宽_C605"/>
						</xsl:variable>
						<xsl:variable name="leftm">
							<xsl:value-of select="preceding::字:分节_416A[1]/字:节属性_421B/字:页边距_41EB/@左_C608"/>
						</xsl:variable>
						<xsl:variable name="rightm">
							<xsl:value-of select="preceding::字:分节_416A[1]/字:节属性_421B/字:页边距_41EB/@右_C60A"/>
						</xsl:variable>
						<xsl:value-of select="number($pagew) - number($leftm) - number($rightm)"/>
					</xsl:variable>
					<xsl:for-each select="字:单元格_41BE">
						<xsl:if test="字:单元格属性_41B7/字:宽度_41A1">
							<xsl:element name="style:style">
								<xsl:attribute name="style:family">table-column</xsl:attribute>
								<xsl:attribute name="style:name"><xsl:value-of select="generate-id(字:单元格属性_41B7/字:宽度_41A1)"/></xsl:attribute>
								<xsl:element name="style:table-column-properties">
									<xsl:choose>
										<xsl:when test="字:单元格属性_41B7/字:宽度_41A1/@相对值_41A3">
											<xsl:attribute name="style:column-width"><xsl:value-of select="concat($bodywidth * 字:单元格属性_41B7/字:宽度_41A1/@相对值_41A3 div 100, $uofUnit)"/></xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="style:column-width"><xsl:value-of select="concat(字:单元格属性_41B7/字:宽度_41A1/@绝对值_41A2, $uofUnit)"/></xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				<xsl:for-each select="字:单元格_41BE">
					<xsl:variable name="pCell" select="."/>
					<xsl:variable name="IsFirstCell">
						<xsl:choose>
							<xsl:when test="position() = 1">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="IsLastCell">
						<xsl:choose>
							<xsl:when test="position() = last()">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="字:单元格属性_41B7/child::*">
						<style:style>
							<xsl:attribute name="style:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
							<xsl:attribute name="style:family">table-cell</xsl:attribute>
							<xsl:element name="style:table-cell-properties">
								<!--
								<xsl:for-each select="字:单元格属性_41B7/node()">
									<xsl:choose>
										<xsl:when test="self::node()[name(.)='字:宽度_41A1']">

										</xsl:when>
										<xsl:when test="self::node()[name(.)='字:单元格边距']">
											
										</xsl:when>
										<xsl:when test="self::node()[name(.)='字:边框']">
											
										</xsl:when>
										<xsl:when test="self::node()[name(.)='字:填充']">
											
										</xsl:when>
										<xsl:when test="self::node()[name(.)='字:垂直对齐方式']">
											<xsl:attribute name="style:vertical-align"><xsl:choose><xsl:when test="self::node()='center' ">middle</xsl:when><xsl:when test="self::node()='bottom' ">bottom</xsl:when><xsl:otherwise>top</xsl:otherwise></xsl:choose></xsl:attribute>
										</xsl:when>
										<xsl:when test="self::node()[name(.)='字:跨行']">
											
										</xsl:when>
										<xsl:when test="self::node()[name(.)='字:跨列']">

										</xsl:when>
										<xsl:when test="self::node()[name(.)='字:自动换行']">
											<xsl:apply-templates select="."/>
										</xsl:when>
										<xsl:when test="self::node()[name(.)='字:适应文字']">
											
										</xsl:when>
										<xsl:when test="self::node()[name(.)='字:斜线表头']">

										</xsl:when>
									</xsl:choose>
								</xsl:for-each>-->
								<xsl:if test="字:单元格属性_41B7/字:垂直对齐方式_41A5">
									<xsl:attribute name="style:vertical-align"><xsl:choose><xsl:when test="字:单元格属性_41B7/字:垂直对齐方式_41A5='center' ">middle</xsl:when><xsl:when test="字:单元格属性_41B7/字:垂直对齐方式_41A5='bottom' ">bottom</xsl:when><xsl:otherwise>top</xsl:otherwise></xsl:choose></xsl:attribute>
								</xsl:if>
								<xsl:variable name="pTableStyle" select="key('uof-table-styles',$pTable/字:文字表属性_41CC/@式样引用_419C)"/>
								<xsl:call-template name="TextTableBorder">
									<xsl:with-param name="pCell" select="$pCell"/>
									<xsl:with-param name="pTable" select="$pTable"/>
									<xsl:with-param name="pTableStyle" select="$pTableStyle"/>
									<xsl:with-param name="IsFirstRow" select="$IsFirstRow"/>
									<xsl:with-param name="IsLastRow" select="$IsLastRow"/>
									<xsl:with-param name="IsFirstCell" select="$IsFirstCell"/>
									<xsl:with-param name="IsLastCell" select="$IsLastCell"/>
								</xsl:call-template>
								<xsl:call-template name="UOFTextCellPadding">
									<xsl:with-param name="pCellPad" select="字:单元格属性_41B7/字:单元格边距_41A4"/>
									<xsl:with-param name="pTablePad" select="$pTable/字:文字表属性_41CC/字:默认单元格边距_41CA"/>
									<xsl:with-param name="pTableStylePad" select="$pTableStyle/字:默认默认单元格边距_41CA"/>
								</xsl:call-template>
								<xsl:if test="字:单元格属性_41B7/字:填充_4134">
									<xsl:apply-templates select="字:单元格属性_41B7/字:填充_4134" mode="texttablecell"/>
								</xsl:if>
							</xsl:element>
						</style:style>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="GradientStyle">
		<xsl:element name="draw:gradient">
			<!--
			<xsl:choose>
				<xsl:when test="图:渐变/@图:类型">
					<xsl:attribute name="draw:name"><xsl:value-of select="图:渐变/@图:类型"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="draw:name"><xsl:value-of select="generate-id()"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		-->
			<xsl:attribute name="draw:name"><xsl:value-of select="generate-id()"/></xsl:attribute>
			<xsl:attribute name="draw:style"><xsl:choose><xsl:when test="图:渐变_800D/@种子类型_8010='linear'"><xsl:value-of select="'linear'"/></xsl:when><xsl:when test="图:渐变_800D/@种子类型_8010='radar'"><xsl:value-of select="'radial'"/></xsl:when><xsl:when test="图:渐变_800D/@种子类型_8010='oval'"><xsl:value-of select="'ellipsoid'"/></xsl:when><xsl:when test="图:渐变_800D/@种子类型_8010='square'"><xsl:value-of select="'square'"/></xsl:when><xsl:when test="图:渐变_800D/@种子类型_8010='rectangle'"><xsl:value-of select="'rectangular'"/></xsl:when></xsl:choose></xsl:attribute>
			<xsl:attribute name="draw:start-color"><xsl:value-of select="图:渐变_800D/@起始色_800E"/></xsl:attribute>
			<xsl:attribute name="draw:end-color"><xsl:value-of select="图:渐变_800D/@终止色_800F"/></xsl:attribute>
			<xsl:attribute name="draw:start-intensity"><xsl:value-of select="concat(图:渐变_800D/@起始浓度_8011,'%')"/></xsl:attribute>
			<xsl:attribute name="draw:end-intensity"><xsl:value-of select="concat(图:渐变_800D/@终止浓度_8012,'%')"/></xsl:attribute>
			<xsl:attribute name="draw:angle"><xsl:value-of select="number(图:渐变_800D/@渐变方向_8013) * 10"/></xsl:attribute>
			<xsl:attribute name="draw:border"><xsl:value-of select="concat(图:渐变_800D/@边界_8014,'%')"/></xsl:attribute>
			<xsl:if test="图:渐变_800D/@种子X位置_8015">
				<xsl:attribute name="draw:cx"><xsl:value-of select="concat(图:渐变_800D/@种子X位置_8015,'%')"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="图:渐变_800D/@种子Y位置_8016">
				<xsl:attribute name="draw:cy"><xsl:value-of select="concat(图:渐变_800D/@种子Y位置_8016,'%')"/></xsl:attribute>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template name="HatchSetStyle">
		<xsl:variable name="fillImage">
			<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B//图:图案_800A | /uof:UOF_0000/图形:图形集_7C00//图:图案_800A | /uof:UOF_0000/字:文字处理文档_4225/字:段落_416B//图:图案_800A | /uof:UOF_0000/字:文字处理文档_4225/字:文字表_416C//图:图案_800A | /uof:UOF_0000/演:演示文稿文档_6C10//图:图案_800A | /uof:UOF_0000/表:电子表格文档_E826//图:图案_800A|/uof:UOF_0000/图表:图表集_E836/图表:图表_E837//图:图案_800A">
				<draw:fill-image>
					<xsl:variable name="ptnType">
						<xsl:choose>
							<xsl:when test="@类型_8008='ptn043' and @前景色_800B='#ffffff' and @图:背景色='#ff0000'">ptn043_red</xsl:when>
							<xsl:when test="@类型_8008='ptn044' and @前景色_800B='#ffffff' and @背景色_800C='#ff0000'">ptn044_red</xsl:when>
							<xsl:when test="@类型_8008">
								<xsl:value-of select="@类型_8008"/>
							</xsl:when>
							<xsl:otherwise>ptnwrong</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="draw:name"><xsl:value-of select="$ptnType"/></xsl:attribute>
					<xsl:attribute name="draw:display-name"><xsl:value-of select="substring-after($ptnType,'ptn')"/></xsl:attribute>
					<xsl:call-template name="BinaryData"/>
				</draw:fill-image>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="FillImage">
			<xsl:with-param name="fillImage" select="$fillImage"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="GraphicSetStyle">
		<xsl:variable name="fillImage">
			<xsl:for-each select="//图:填充_804C/图:图片_8005 | //字:填充_4134/图:图片_8005 | //演:背景_6B2C/图:图片_8005 | //表:背景填充_E830/图:图片_8005 | //表:填充_E746/图:图片_8005 | //图表:填充_E746/图:图片_8005">
				<!-- 图表的填充为后加的，解决图表无背景图片问题 -->
				<draw:fill-image xlink:actuate="onLoad" xlink:show="embed" xlink:type="simple">
					<xsl:attribute name="draw:name"><xsl:value-of select="@图形引用_8007"/></xsl:attribute>
					<xsl:choose>
						<xsl:when test="key('other-styles',@图形引用_8007)/对象:路径_D703">
							<xsl:attribute name="xlink:href"><xsl:value-of select="concat('Pictures/',substring-after(key('other-styles',@图形引用_8007)[1]/对象:路径_D703,'/data/'))"/></xsl:attribute>
						</xsl:when>
						<xsl:when test="key('other-styles',@图形引用_8007)/对象:数据_D702">
							<xsl:call-template name="BinaryGraphic">
								<xsl:with-param name="refGraphic" select="@图形引用_8007"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</draw:fill-image>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="FillImage">
			<xsl:with-param name="fillImage" select="$fillImage"/>
		</xsl:call-template>
	</xsl:template>
	<!--过滤重复式样-->
	<xsl:template name="FillImage">
		<xsl:param name="fillImage"/>
		<xsl:for-each-group select="$fillImage/*" group-by="@draw:name">
			<xsl:copy-of select="."/>
		</xsl:for-each-group>
	</xsl:template>
	<xsl:template match="对象:对象数据_D701">
		<xsl:for-each select="key('rel_graphic_name',@标识符_D704)">
			<xsl:element name="style:style">
				<xsl:attribute name="style:name"><xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:attribute name="style:family">graphic</xsl:attribute>
				<xsl:element name="style:graphic-properties">
					<xsl:choose>
						<xsl:when test="uof:保护_C62A/@是否保护大小='true'">
							<xsl:attribute name="style:protect">size</xsl:attribute>
						</xsl:when>
						<xsl:when test="uof:保护_C62A/@是否保护位置='true'">
							<xsl:attribute name="style:protect">position</xsl:attribute>
						</xsl:when>
						<xsl:when test="uof:保护_C62A/@是否保护位置='true'and uof:保护_C62A/@是否保护大小='true'">
							<xsl:attribute name="style:protect">position size</xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<xsl:attribute name="fo:border">none</xsl:attribute>
					<!-- a special case,there is a @类型,but no uof:垂直 starting -->
					<xsl:if test="uof:位置_C620/@类型_C646 = 'as-char'">
						<xsl:attribute name="style:vertical-pos"><xsl:value-of select="'from-top'"/></xsl:attribute>
					</xsl:if>
					<!-- a special case,there is a @类型,but no uof:垂直 , ending. -->
					<xsl:apply-templates select="uof:位置_C620/uof:垂直_410D"/>
					<xsl:apply-templates select="uof:位置_C620/uof:水平_4106"/>
					<xsl:apply-templates select="uof:绕排_C622"/>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="BinaryData">
		<office:binary-data>
			<xsl:choose>
				<xsl:when test="@类型_8008='ptn001' and @前景色_800B='#00ff00'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJElEQVR4nGNh+M/wn5EBE7BgFQVJYBcmVoIRyT4UCWT7SLcDAC48BiC0r93dAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn001' and @前景色_800B='#ff78bd'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAI0lEQVR4nGP5//8/AzbAglUUvwQjAwM2w1iwipJpBzJAsg8AQFcGHZrs6e8AAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn001' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJElEQVR4nGNhYPjP8J+RAQOwYBUFS+AAREowIuxDlUCyj3Q7ACg9BiAi8rOrAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn002' and @前景色_800B='#ff0000'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJklEQVR4nGP5z8DA8B9EoAEWrKJgCWTAyAhXhyqBpJsFWRWN7AAAOSsRFt141QcAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn003' and @前景色_800B='#ff0000'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKklEQVR4nGP5z8DACMRg8J8RwWaBsxiQVIAkMNVC2CyYaiFsFky1VLcDAOahGCD63ouBAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn004' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAI0lEQVR4nGNhYPj//z8DBDAyMsDZLBAWRAiZzYIpBGEPqA4A/1o9AqgXatAAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn005' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKUlEQVR4nGNhYPj//z8DIyMDGskCZzEwMCCzWTDVInSgqYWw8eqgkh0A7ZVBDhySK7QAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn006' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKUlEQVR4nGNhYPj//z8DIyMDGsmCVRRIsmAVxaKDgYFUHcTZATcXmQQA8ftBGoRo5DEAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn007' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAHklEQVR4nGNhYPj//z8DIyMDGsmCVRRIsmAVHWgdAPL9QR46gf26AAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn008' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKklEQVR4nGNhYPjPAAb//zMwMjLA2SwQPibJAmcBATIbrw40tRA2Fe0AAP6iMSo4Vov8AAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn009' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAI0lEQVR4nGP5//8/IyMDBPz/zwBns0BYECFkNgumEIQ9oDoAnUwhPDtydwUAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn010' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAK0lEQVR4nGP5//8/IyMDBPz/zwBns8BZQIDMZsFUC2GzYKqFsFkw1VLdDgAA8xEwmsNKVwAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn010' and @前景色_800B='#ffffff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAALElEQVR4nGP5//+/icksBjA4cyYNzmaBs4AAmc2CqRbCZsFUC2GzYKqluh0ANq4hMPEukbMAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn011' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKklEQVR4nGNhYPjPAAb//zMwMjLAAQuchSyKIoEMgLqxSwB1syCropEdADipCSSSiwzsAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn012' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJElEQVR4nGNhYPjPgA2wYBUlWuL/fwZGRmwScFHy7EA2FxkAAOHDBSIH/WEvAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn013' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAALUlEQVR4nGNhYPj//z8DBDAyMsDZLEAWnI/MZkHjw9ksEI2YcixYzQHpoJ4dAOY1OQZM1tGbAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn014' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKElEQVR4nGP5//8/AxgwMjLAmCA2C1ZRIJsFqygQsGAVBUlgFaWuHQBj1iEg8vXVKAAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn015' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAMUlEQVR4nGNhYPjPAMQggoGRkQHOZgFSQD4QARnIbBaIEkw5Fky1EDYLxGhMOSraAQCLbjkg7ZCwuwAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn016' and @前景色_800B='#0000ff' and @背景色_800C='#ff0000'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJ0lEQVR4nGNhYPjPAMKMQJIRic2CVRTIZsEqCtWBKQpks2AVpa4dAI7FICCCNCzYAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn016' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKUlEQVR4nGNhYPjPAMQggoGRkQHOZsEqCmSzYBWF6sAUBbJZsIpS1w4AYkkhHuKbNUYAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn017' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAN0lEQVR4nGXOAQoAQARE0VH//lfenU2hpUheBOnI+UpHhKhumnucnm4jfRu1+xnz7rSGz9j/pF2YoB0gtk9UpQAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn018' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAMUlEQVR4nGNhYPj//z8DMmBkBJEsWEVBElhFgapZsIoidKCJQiUwRUESWEURRmG6DQAbfBEgGcS1uwAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn019' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAHElEQVR4nGNhYPj//z8DBDAyMsDZLAw4wOCUAADHvwUeDEtdDgAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn020' and @前景色_800B='#ffff00'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAGklEQVR4nGP5/58BK2BhZMQhgV0YnwQd7AAAYJIEISB3Q/YAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn020' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAIElEQVR4nGNhYPjPgA2w/McuzsCCXRifBCMjDgnq2QEAwAgFHjYAUNQAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn021' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAGklEQVR4nGNhYPj//z8DIyMDGsnCgAMMTgkApfgJHqRbf9cAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn022' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAHElEQVR4nGNhYPjPgA2w/McuzsDCyIhDYiB1AADmewkeUS/FOwAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn022' and @前景色_800B='#00ff00' and @背景色_800C='#00ffff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAGElEQVR4nGNh+P+fARtgYWBgxCUxCHUAALvMBSC5rp57AAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn022' and @前景色_800B='#00ff00'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAF0lEQVR4nGNh+M+AFbAw4JABSjAOPh0AV88FH0+MxjkAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn023' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAHElEQVR4nGNhYPjPAMQggoGRkQHOZmHAAQanBAC7ywUeNxfiogAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn024' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAIElEQVR4nGNhYPjPgA2wYBUFSfzHrgGPDkZGUnWQbAcAXGwFHqNw3RkAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn025' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAMklEQVR4nGP5//8/AzbAglUUJMHIyADXg8xmAbLgfGQ2CxofzobagSmHsBzZdQgdmAAAyBUhEFI1qLsAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn026' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAMElEQVR4nGP5//8/AzbAglUURYKRkQGuGchmwSoKZLNgFQUZhVUUJIHsKGQ2TlcBACh9FRy4as61AAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn027' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJUlEQVR4nGNhYPjPAAP/EUwGFmQOMmDBLkysBCMjDgkUy0m2AwAbsQccw3M/SgAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn028' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAIElEQVR4nGNhYPj//z8DJmDBIkauBLIFjIwMcC4V7QAAw/oHHGDxXvUAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn029' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAANUlEQVR4nGWNQQoAMAjDKuT/X+4OgpPqQUgNFsm27rDTKg2yeUsEj8f90/sfooxb2xKhj/EAW+UdErFnPgwAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn030' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAOUlEQVR4nGWO0QoAMAgCDfz/X3aOhoy6J08qIiAJVcBNaKyM/LhkUuhtDs8EhydzeOC+/jYs+zGXB++ZGRj0GfymAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn031' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAANElEQVR4nGNhYPj//z8DGmBkZGABigIpZDkIl4UBpAUhB2ewQFRB5CAMCGCBK0EzjYp2AABEjCcUaUAW6gAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn032' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAALElEQVR4nGP5//8/AzbAAmcxMoJIuDIWuChECMIAkixoCiEMIMmCwwpq2gEARxkdGBfi2AgAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn033' and @前景色_800B='#ff0000'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAANklEQVR4nGNhYPjPgAH+MzCyYBVlZPiPLgERBTJYsIqiSABFkRWxoKlFMQrZBCADajmyKLIcAMprFiBoxxp5AAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn033' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAANElEQVR4nGP5//8/AwZgZGRgwSoKVIwuAREFAhasoigSQFFkwIKmFsUoZBOADKjlyKLIcgBi7Bcg5WuxKQAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn034' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJklEQVR4nGNhYPjPgA2wAPF/bFIsWJUTkmBkxCaBbAFQBZxLuh0ALx0HHo+Ka1MAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn035' and @前景色_800B='#0000ff' and @背景色_800C='#ff00ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAANUlEQVR4nGNhYPj/nwEKGIEcGJvlP4yPTIIkGFD5cDYLmglwfSyYohB9LJhqEXYw4LcDTQ4AMPkZGo5IQCMAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn035' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAN0lEQVR4nGVNQQ4AIAjCjf9/2WpsVOjBgYAQ6G5oqmDMjcTffQTg48aMD85xXpXj9N6O8GZHaAt21jEU9i1BlQAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn035' and @前景色_800B='#0000ff' and @背景色_800C='#ff00ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAANUlEQVR4nGNhYPj/nwEKGIEcGJvlP4yPTIIkGFD5cDYLmglwfSyYohB9LJhqEXYw4LcDTQ4AMPkZGo5IQCMAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn036' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAALElEQVR4nGNhYPj//z8DIyMDGsmCVRRIsmAVJaQDCCAkA8hCKMnCgAOQLgEA5O4lHgp+1OoAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn037' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAALUlEQVR4nGP5//8/AzbAAmcxMjIgq0FIAEWR5YjTgWIHmkKEBFZRoGrsOoAiAHAjFRgrzI7EAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn038' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJUlEQVR4nGNhYPj//z8DIyMDGskCxAwgSXSSBSKPCViwitJJBwC5tB0QWDyhJgAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn039' and @前景色_800B='#ffffff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAMElEQVR4nGMxNp7JgA2wAPGZM2kmJrMgfDgbJAEXRWazwIWQ9aFIIItSaAcyAOoDADXzFyjANSY3AAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn039' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAMElEQVR4nGNhYPj//z8DJmDBKgqSgFCMjAxwFRA2VAJZH4TNgqwdWR+KBLI+0u0AAFpvGRLKSkf3AAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn040' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAOUlEQVR4nG2NCwoAMAhCF3j/KzuHIAYTyuL1AcmzNfMyZI3SQpamh6AwcxHBlo3U6Ld9cIFgsQ+wLoWFGxgcGtpJAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn041' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAALElEQVR4nGNhYPjPgA2w/P/PwMgIYv0HK4CzWSAsuBCczYKpFiGBppbqdgAALSkVLK4WE5kAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn042' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAN0lEQVR4nHWNSQoAQAjDKvT/X+4UBBcYc4oHU0qKQCKhnDbfSbmF2PQHDji7/w3L3OPsrtS18QDeoxEoMtsKvAAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn043' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJUlEQVR4nGNhYPjPgA2wAPF/mBQjI4LNglU5IQmgCXAAZ1PRDgBm3wkgDXDgQQAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn043' and @前景色_800B='#ffffff' and @背景色_800C='#ff0000'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKklEQVR4nGN5YqosferOUzMVBjCAs1kYcADcEkC9EBPgQhA2C9BEWtsBAJwCGSIIxPtQAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn044' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAGklEQVR4nGNhYPjPgA2wAPF/bFIsWJUPtAQAJtwDHhoe2JQAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn044' and @前景色_800B='#ffffff' and @背景色_800C='#ff0000'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJklEQVR4nGN5YqosferOUzMVBlTAwoAD0EUC6CQgBSFRJDAdCgEAA0IJHu/iI/cAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn045' and @前景色_800B='#ff0000' and @背景色_800C='#ffff00'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKElEQVR4nGP5/5+BgZEBBP6DSRibBcRCFYKwWRhwABYGnEbh1EE1OwBLFQ4fojv/LgAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn045' and @前景色_800B='#ff0000'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKUlEQVR4nGP5z8DAAMIMDIxgEsZmAbFQhSBsFgYcgAWkBLtROHVQzQ4A9OwNIMy7yHkAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn045' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKklEQVR4nGNhYPj//z8DEDAygkg4mwXIQhOCsFkYcAAWoBLsRuHUQT07AB7YGSAdbcZUAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn046' and @前景色_800B='#0000ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAH0lEQVR4nGNhYPjPAAP/EUwGFgYcgAwJZHMZGWliBwALswUeEhCN8AAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn005' and @背景色_800C='#333399'">
iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKElEQVR4nGNRZrhz57+yCuNdBjCAs1kgLEySBSIP58PZeHWgqaW6HQDkpk8sQd5vKgAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn010'and @背景色_800C='#333399'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAALElEQVR4nGP5//8/AxioqNy9c0cZzmZhgAG4KITNgqkWwmbBVAthIIyinR0Az50mQDmqEnoAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="substring(@类型_8008,5,2)='13'and string(@背景色_800C)='#ff3333'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAK0lEQVR4nGP5b2zMAAaMZ88is1ngfCCJzGZB48PZLJhqIWwWiKGYclS0AwACfUJCQU/IJQAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn022' and @背景色_800C='#00ffff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAG0lEQVR4nGNh+P+fARtgUWZQwS5xl+HO4NMBAP+nCGbuOY6AAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn035' and @背景色_800C='#ff00ff'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAPUlEQVR4nGP5z/BfheEuAxjcYVAGsiEkC5wFlEBmsyCrgouCJDDVQsxkQTYH2SYWTLVQO5DNQXEVRCGm2wCx4C4nyqBe2QAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn039' and @背景色_800C='#333399'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAMklEQVR4nGNRZrjDgA2wQKg7/5VVGO9ikUATBUkgq0VmsyCrRWazYFoL0YdFAqIPpx0A44IXKNx/AToAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn045' and @背景色_800C='#ffff00'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJUlEQVR4nGP5/58BCO6qgEjlOwg2CwMOwIKpFsLGrQNTLdXtAAD9VxEgnseUWAAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn001'">				iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAIUlEQVR4nGP5//8/AzbAglUUrwQjIyNW01ioaAcyB9k+AAO9DBstSVK1AAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn002'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKUlEQVR4nGOZqeHDAANphVKz+p9B2CwMSAAuCpJAVoUMWLCKohtFIzsAN2YVaquFlH0AAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn003'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAALElEQVR4nGNRVr7DgA2w3BEIV/mwEsJBZrPAWUCAzGbBVAths2CqhbCpaAcAxPUjsSXviH8AAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn004'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAI0lEQVR4nGOR7OpK/1bGAAYzuRBsFggLIoTMZsEUgrAHVAcAq3dJq0qbe9YAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn005'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJElEQVR4nGNpaGAAQhABBnA2C4SFiVgg8nA+nI1XB5paqtsBAN6ENyG+vb1pAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn006'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKklEQVR4nGOR7Op6Xlom2Y1OsqDxGRgYIGwWTLXYdcBJvDrg5hKtA6scAIQYXcTwY7BfAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn007'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAHklEQVR4nGNh+M/A4O3FsHUbGsmCVRRIsmAVHWgdAJ1uP7UktXJ2AAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn008'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAMElEQVR4nGP5/z+NYRYDFKQxwNksIBaEj0qygGRnIamFsVkQJqDrwFALYVPNDgYGAHpeHCHJYPuMAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn009'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJklEQVR4nGOR7Op6xn9H6qMKAxjA2SxADGFBhOBsFkwhCHtAdQAAcSg9JIa+mA8AAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn010'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKklEQVR4nGNZd54BAtr7GSoLEWwWBhiAi0LYLJhqIWwWTLUQgDCKdnYAAK3RFxro9SLpAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn011'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJ0lEQVR4nGNpaGhgwAZYMIUkJX2eP9+CRQIoitABUYXFKDRR6toBAJq6FSc596YjAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn012'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAK0lEQVR4nGOR7OpiwAZY4KxnpaVS3d1YJJBFUSRwGkWUBNA+7BJA+3AaBQAC0Ah+yZWsQwAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn013'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAALUlEQVR4nGP5//8/AxgwMjLAmCA2C5wPJJHZLGh8OJsFUy2EzQIxFFOOinYAADx8OwaQ1VWOAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn014'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKUlEQVR4nGNhuPOfAQJUGBjuMMDZLFhFgWwWrKJAwIJVFCyBTZS6dgAAE3wRIDlgYu4AAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn015'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAMklEQVR4nGOZmXbm+awtDAwMkmk+QBLOZoFQQD4QARlwNgsaH85mgWjHlGPBag517QAAiLdV7DSstF0AAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn016'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAK0lEQVR4nGNZd54BCC5tlASSev7P4WwWrKJANgtWUagOTFEgmwWrKHXtAADkozA6i+VXKgAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn017'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAO0lEQVR4nGNhYPjPcOYsAzIwMQYSLFAWshyQbWLMglCFKscCkceUY4HrRZNjgetFk2OB60WTQ5JAlQMAcWQdIItfX/MAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn018'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAOUlEQVR4nGOZ4j6FgYHhkjwrAxjoPfwNYbBgFQVJYBWF6sAUBapmwSoK0oFVFGEUmihQNQtWUSAJAItIGZCmAj/UAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn019'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAHElEQVR4nGNh+M/A0NjAUN/AAAEwNgsDDjA4JQDARQUg8kU9AQAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn020'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAH0lEQVR4nGNhuPOfARtgwSoKllDBJXEHlwROo6hmBwAWYQP8EvqLCwAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn021'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAF0lEQVR4nGP5//8/IyMjJsnCgAMMTgkA6ywMIQCWenYAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn022'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAGElEQVR4nGNhwAFY/v//j12CkZFx8OkAAKXuDB5FnY15AAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn023'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAHklEQVR4nGP5//8/IyMjAwMDkAEk4WwWBhxgcEoAAKkECR7id7rEAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn024'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAHElEQVR4nGP5//8/AzbAglUUJMHIyEiiDjrYAQCF2QYhE3pd/wAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn025'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAL0lEQVR4nGP5//8/AxgwMjIis1kYYAAuCmEjJNAAGRJodsLZLEAWnI/MZkHjw9kAFogqDyFktcgAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn026'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKUlEQVR4nGP5//8/AzbAglWUQglGRka4fUA2C1ZRIJsFqyjIKKyiQAAA6fcYIfk0nh8AAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn027'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKElEQVR4nGP5//8/AzbAgsxhZGTELoGsG0UCp1EoEsjmohhFlKuQAQA9sAwbpfdUbgAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn028'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAIElEQVR4nGP5//8/AwwwMjLCuSwMOAAZEsjmIttHRTsAofAMG54pChoAAAAASUVORK5CYII=
			</xsl:when>
				<xsl:when test="@类型_8008='ptn029'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAANUlEQVR4nGWMQQoAQAgCDfz/l92Di0F2qnGSACShhofOjAnPHe8H/ccusbdBqA0eNwbb9f4AKKYqDJtlg60AAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn030'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAOUlEQVR4nG1NOQ4AMAjShP9/mZIwSGsZDHIoSFZVd2uaG5CUuyERZruHHbeHTF0/8m56n1NOTONJHNjRJBKMzS6qAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn031'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAL0lEQVR4nGP5//8/IyMjkGRgYIAzgIAFmYOsiAUuiiwHkoDwIRyIIqgOZKNpZAcAogk5DLqwhAsAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn032'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAMUlEQVR4nGNhYGD4//8/IyMjkASy4QwWCAWRgzAYwICFAQbgQugScADRygIxlKZ2AAD5kSoS/A+e7AAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn033'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAOElEQVR4nG2MQQoAQAgCE/r/l1ujkFjsEDqKWVURAYB/9FxKXboB6x/twNIOLGU7LTVTsj0lc0sPILchG3Z9PUUAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn034'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAKklEQVR4nGNhwAFY/v//D2ExMjLC2SAJnDpwSgBNgHOQ2SzI5hJnFC4JANNjCSHwZ+dOAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn035'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAPElEQVR4nGWOWwoAQAgCDbz/ld2HS7jUR0gNKgFIwp2q2tqbrUy0ZlJ9PY/J2pPpk0mc7MtIn6+VwdltAaKwTglQF5YxAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn036'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAALklEQVR4nGP5//8/IyMjJsmCVRRIsgAxAwMDhA9kQEggYGHAAciTgNgGt4mAqwCl+DMhMZsO5QAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn037'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAALklEQVR4nGP5//8/AwMDIyMjhAEHLFhFoRJAUew6IHJYdCADuFZ0CbixpOiAMADmpyEShMaewQAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn038'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAK0lEQVR4nGP5//8/AwMDIyMjhAEHLBAKTRQkAVGLSbJA1GKSUKNIsYNkHQC3qC0JDQzH4AAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn039'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAMElEQVR4nGP5//8/AzbAAqEYGRnRVEAlMPWxIKtFZrMgq0Vms2BaC9GHRQKiD6cdAA9EIRKBWkN+AAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn040'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAOElEQVR4nGWOUQoAMAhCF7z7X7nGBJHmR6mhRHefh6q60xK7skxIoYQk6eYNrWwXx9aKshr2Vz8GDzgwD2pvz7kAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn041'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAK0lEQVR4nGNhYGD4//8/kGRkZERms8CFIADOZgEqQVMLYbPAlaDpY6GDHQDLBh45l0dhygAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn042'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAOUlEQVR4nHWNQQoAMAzCWvD/X3aC1DHoPJQcbERNSBq6Wxf1CVJ3MQwbRAHzVeXjUS0bLu4b8cYpPr24ISf5W9S/AAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn043'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJklEQVR4nGP5//8/IyMjkGQAAzibhQEHwC0B1AsxAS4EYbPQwQ4A6J0SLfF/06kAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn044'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJElEQVR4nGP5//8/IyMjkGRABSwMOAALUDmQgpAoEqQbRT0JAHD2DCHlOvIhAAAAAElFTkSuQmCC</xsl:when>
				<xsl:when test="@类型_8008='ptn045'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJUlEQVR4nGNhAIP///8DSUZGRjibhQEHYMFUC2Hj1oGplup2AAC9HBgeRnkBAgAAAABJRU5ErkJggg==</xsl:when>
				<xsl:when test="@类型_8008='ptn046'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJklEQVR4nGP5//8/IyMjAwwAuRAGCwMOQIYE0AK4uUAAt4+KdgAAofcJIdNbiq8AAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn047'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAOElEQVR4nG2NQQoAMAjDFPr/L3eDjmzIbo1RK9tV1d0JZAV2CrNxxOuCV/wvYJxGM05jitPo5PMCryM5EtSyCSkAAAAASUVORK5CYII=</xsl:when>
				<xsl:when test="@类型_8008='ptn048'">iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAANklEQVR4nG2N0QoAMAgCFfz/X3aBEG2rxzs12QZAEuMK6qchit8bj8u4Zqpc6CU6u4i9kR/tDmj1IRsmDqtoAAAAAElFTkSuQmCC</xsl:when>
				<xsl:otherwise>iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAJElEQVR4nGNhYPjP8J+RAQOwYBUFS+AAREowIuxDlUCyj3Q7ACg9BiAi8rOrAAAAAElFTkSuQmCC</xsl:otherwise>
			</xsl:choose>
		</office:binary-data>
	</xsl:template>
	<xsl:template name="BinaryGraphic">
		<xsl:param name="refGraphic"/>
		<xsl:element name="office:binary-data">
			<xsl:value-of select="/uof:UOF_0000/对象:对象数据集_D700/对象:对象数据_D701[@标识符_D704 = $refGraphic]/对象:数据_D702"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="图:填充_804C" mode="Graph">
		<xsl:call-template name="FillGraph"/>
	</xsl:template>
	<xsl:template match="图:属性_801D" mode="Graph">
		<xsl:param name="textanchor"/>
		<xsl:variable name="drawName" select="../../@标识符_804B"/>
		<xsl:choose>
			<xsl:when test="图:填充_804C">
				<xsl:apply-templates select="图:填充_804C" mode="Graph"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- special for presentation. there are some bugs, if (draw:fill != 'none), it will be filled in default color for presentation graphic object. -->
				<xsl:for-each select="/uof:UOF_0000/图形:图形集_7C00/图:图形_8062/图:预定义图形_8018/图:属性_801D">
					<xsl:if test="not(图:填充_804C)">
						<xsl:attribute name="draw:fill">none</xsl:attribute>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="$document_type = 'presentation' and $textanchor">
					<xsl:attribute name="draw:fill">none</xsl:attribute>
					<!--
					<xsl:choose>
						<xsl:when test="(name($textanchor/..) = '演:母版') and ($textanchor/@uof:占位符 = 'text')">
							<xsl:choose>
								<xsl:when test="$textanchor/../演:背景">
									<xsl:for-each select="$textanchor/../演:背景">
										<xsl:call-template name="FillGraph"/>
									</xsl:for-each>

									<xsl:if test="$textanchor/../演:背景/图:颜色">
										<xsl:attribute name="draw:fill">solid</xsl:attribute>
										<xsl:attribute name="draw:fill-color"><xsl:value-of select="$textanchor/../演:背景/图:颜色"/></xsl:attribute>								
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="draw:fill">none</xsl:attribute>						
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="draw:fill">none</xsl:attribute>			
						</xsl:otherwise>
					</xsl:choose>-->
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="图:线_8057/图:线颜色_8058">
			<xsl:attribute name="svg:stroke-color"><xsl:value-of select="图:线_8057/图:线颜色_8058"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="图:线_8057/图:线类型_8059">
			<!--<xsl:variable name="xmlid">
				<xsl:choose>
					<xsl:when test="图:线类型/@xml:id">
						<xsl:value-of select="图:线类型/@xml:id"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="图:线类型/@图:虚实"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>-->
			<xsl:variable name="type" select="图:线_8057/图:线类型_8059/@线型_805A"/>
			<xsl:variable name="dash" select="图:线_8057/图:线类型_8059/@虚实_805B"/>
			<xsl:if test="$type='none'">
				<xsl:attribute name="fo:border">none</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$type!=''">
					<xsl:attribute name="draw:stroke"><xsl:choose><xsl:when test="$type='none'">none</xsl:when><xsl:when test="$dash='round-dot' or $dash='square-dot' or $dash='dash' or $dash='dash-dot' or $dash='long-dash' or $dash='long-dash-dot' or $dash='dash-dot-dot'">dash</xsl:when><xsl:otherwise>solid</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="draw:stroke-dash"><xsl:choose><xsl:when test="$dash='round-dot'">round-dot</xsl:when><xsl:when test="$dash='square-dot'">square-dot</xsl:when><xsl:when test="$dash='dash'">dash</xsl:when><xsl:when test="$dash='dash-dot'">dash-dot</xsl:when><xsl:when test="$dash='long-dash'">long-dash</xsl:when><xsl:when test="$dash='long-dash-dot'">long-dash-dot</xsl:when><xsl:when test="$dash='dash-dot-dot'">dash-dot-dot</xsl:when><xsl:otherwise>Fine Dashed</xsl:otherwise></xsl:choose></xsl:attribute>
				</xsl:when>
				<xsl:when test="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204[扩展:路径_B205 = $drawName]/扩展:内容_B206[@名称 = 'draw:stroke-dash']">
					<xsl:attribute name="draw:stroke">dash</xsl:attribute>
					<xsl:attribute name="draw:stroke-dash"><xsl:value-of select="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204[扩展:路径_B205 = $drawName]/扩展:内容_B206[@名称 = 'draw:stroke-dash']/扩展:线型数据/@draw:name"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="图:线_8057/图:线粗细_805C">
			<xsl:attribute name="svg:stroke-width"><xsl:value-of select="concat(图:线_8057/图:线粗细_805C,$uofUnit)"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="图:箭头_805D/图:前端箭头_805E">
			<xsl:for-each select="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204[扩展:路径_B205 = $drawName]/扩展:内容_B206[@名称 = 'draw:marker']/扩展:前端箭头">
				<xsl:attribute name="draw:marker-start" select="@draw:name"/>
				<xsl:attribute name="draw:marker-start-width" select="@draw:marker-start-width"/>
			</xsl:for-each>
			<xsl:if test="图:箭头_805D/图:前端箭头_805E/图:端点结合方式_8003">
				<xsl:attribute name="draw:stroke-linejoin"><xsl:value-of select="图:箭头_805D/图:前端箭头_805E/图:端点结合方式_8003"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="图:箭头_805D/图:前端箭头_805E/图:式样_8000">
				<xsl:call-template name="callArrow">
					<xsl:with-param name="ArrowElement1" select="图:箭头_805D/图:前端箭头_805E/图:式样_8000"/>
					<xsl:with-param name="ArrowElement2" select="图:箭头_805D/图:前端箭头_805E/图:大小_8001"/>
					<xsl:with-param name="isBegin" select="'true'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<xsl:if test="图:箭头_805D/图:后端箭头_805F">
			<xsl:for-each select="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204[扩展:路径_B205 = $drawName]/扩展:内容_B206[@名称 = 'draw:marker']/扩展:后端箭头">
				<xsl:attribute name="draw:marker-end" select="@draw:name"/>
				<xsl:attribute name="draw:marker-end-width" select="@draw:marker-end-width"/>
			</xsl:for-each>
			<xsl:if test="图:箭头_805D/图:后端箭头_805F/图:端点结合方式_8003">
				<xsl:attribute name="draw:stroke-linejoin"><xsl:value-of select="图:箭头_805D/图:后端箭头_805F/图:端点结合方式_8003"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="图:箭头_805D/图:后端箭头_805F/图:式样_8000">
				<xsl:call-template name="callArrow">
					<xsl:with-param name="ArrowElement1" select="图:箭头_805D/图:后端箭头_805F/图:式样_8000"/>
					<xsl:with-param name="ArrowElement2" select="图:箭头_805D/图:后端箭头_805F/图:大小_8001"/>
					<xsl:with-param name="isBegin" select="'false'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<xsl:if test="图:是否打印对象_804E">
			<xsl:choose>
				<xsl:when test="string(图:是否打印对象_804E) = 'true'">
					<xsl:attribute name="draw:printprev-hide">false</xsl:attribute>
				</xsl:when>
				<xsl:when test="string(图:是否打印对象_804E) = 'false'">
					<xsl:attribute name="draw:printprev-hide">true</xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="图:透明度_8050">
			<xsl:choose>
				<xsl:when test="../图:名称_801A='Line'">
					<xsl:attribute name="svg:stroke-opacity"><xsl:value-of select="concat(图:透明度_8050,'%')"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="draw:opacity"><xsl:value-of select="concat(100 - 图:透明度_8050,'%')"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<!--UOF template Wrong-->
		<xsl:if test="图:阴影_8051">
			<xsl:if test="图:阴影_8051/图:是否显示阴影_C61C='true'">
				<xsl:attribute name="draw:shadow"><xsl:value-of select="string('visible')"/></xsl:attribute>
				<xsl:if test="图:阴影_8051/uof:偏移量_C61B/@x_C606 and not(图:阴影_8051/uof:偏移量_C61B/@x_C606=0)">
					<xsl:attribute name="draw:shadow-offset-x"><xsl:value-of select="concat(图:阴影_8051/uof:偏移量_C61B/@x_C606,$uofUnit)"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="图:阴影_8051/uof:偏移量_C61B/@y_C607 and not(图:阴影_8051/uof:偏移量_C61B/@y_C607=0)">
					<xsl:attribute name="draw:shadow-offset-y"><xsl:value-of select="concat(图:阴影_8051/uof:偏移量_C61B/@y_C607,$uofUnit)"/></xsl:attribute>
				</xsl:if>
				<xsl:attribute name="draw:shadow-color"><xsl:value-of select="图:阴影_8051/@颜色_C61E"/></xsl:attribute>
				<xsl:attribute name="draw:shadow-opacity"><xsl:value-of select="concat(100 - 图:阴影_8051/透明度_C61F, '%')"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="图:阴影_8051">
			<xsl:if test="图:阴影_8051/@是否显示阴影_C61C='true'">
				<xsl:attribute name="draw:shadow"><xsl:value-of select="string('visible')"/></xsl:attribute>
				<xsl:if test="图:阴影_8051/uof:偏移量_C61B/@x_C606 and not(图:阴影_8051/uof:偏移量_C61B/@x_C606=0)">
					<xsl:attribute name="draw:shadow-offset-x"><xsl:value-of select="concat(图:阴影_8051/uof:偏移量_C61B/@x_C606,$uofUnit)"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="图:阴影_8051/uof:偏移量_C61B/@y_C607 and not(图:阴影_8051/uof:偏移量_C61B/@y_C607=0)">
					<xsl:attribute name="draw:shadow-offset-y"><xsl:value-of select="concat(图:阴影_8051/uof:偏移量_C61B/@y_C607,$uofUnit)"/></xsl:attribute>
				</xsl:if>
				<xsl:attribute name="draw:shadow-color"><xsl:value-of select="图:阴影_8051/@颜色_C61E"/></xsl:attribute>
				<xsl:attribute name="draw:shadow-opacity"><xsl:value-of select="concat(100 - 图:阴影_8051/@透明度_C61F, '%')"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="图:图片属性_801E">
			<xsl:apply-templates select="图:图片属性_801E" mode="Graph"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="callArrow">
		<xsl:param name="ArrowElement1"/>
		<xsl:param name="ArrowElement2"/>
		<xsl:param name="isBegin"/>
		<xsl:variable name="sizeArrow">
			<xsl:value-of select="$ArrowElement2"/>
		</xsl:variable>
		<xsl:if test="$ArrowElement1">
			<xsl:variable name="typeName">
				<xsl:value-of select="$ArrowElement1"/>
			</xsl:variable>
			<xsl:variable name="arrowType">
				<xsl:choose>
					<xsl:when test="$typeName = 'diamond'">
						<xsl:value-of select="concat('msArrowDiamondEnd_20_',$sizeArrow)"/>
					</xsl:when>
					<xsl:when test="$typeName = 'normal'">
						<xsl:value-of select="concat('msArrowEnd_20_',$sizeArrow)"/>
					</xsl:when>
					<xsl:when test="$typeName = 'open'">
						<xsl:value-of select="concat('msArrowOpenEnd_20_',$sizeArrow)"/>
					</xsl:when>
					<xsl:when test="$typeName = 'stealth'">
						<xsl:value-of select="concat('msArrowStealthEnd_20_',$sizeArrow)"/>
					</xsl:when>
					<xsl:when test="$typeName = 'oval'">
						<xsl:value-of select="concat('msArrowOvalEnd_20_',$sizeArrow)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="arrow"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$isBegin = 'true'">
					<xsl:attribute name="draw:marker-start"><xsl:value-of select="$arrowType"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="draw:marker-end"><xsl:value-of select="$arrowType"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$ArrowElement2">
			<xsl:variable name="arrowSize">
				<xsl:choose>
					<xsl:when test="$sizeArrow = '1' or $sizeArrow = '2' or $sizeArrow = '3'">0.247cm</xsl:when>
					<xsl:when test="$sizeArrow = '4' or $sizeArrow = '5' or $sizeArrow = '6'">0.437cm</xsl:when>
					<xsl:when test="$sizeArrow = '7' or $sizeArrow = '8' or $sizeArrow = '9'">0.617cm</xsl:when>
					<xsl:otherwise>0.247cm</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$isBegin = 'true'">
					<xsl:attribute name="draw:marker-start-width"><xsl:value-of select="$arrowSize"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="draw:marker-end-width"><xsl:value-of select="$arrowSize"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="uof:垂直_410D">
		<xsl:variable name="vertpos">
			<xsl:choose>
				<xsl:when test="../@类型_C646 = 'as-char'">from-top</xsl:when>
				<xsl:when test="uof:绝对_4107">from-top</xsl:when>
				<xsl:when test="uof:相对_4109/@参考点_410A='bottom'">bottom</xsl:when>
				<xsl:when test="uof:相对_4109/@参考点_410A='center'">middle</xsl:when>
				<xsl:when test="uof:相对_4109/@参考点_410A='inside'">below</xsl:when>
				<xsl:otherwise>top</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="vertrel">
			<xsl:choose>
				<xsl:when test="@相对于_410C='margin'">page-content</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@相对于_410C"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="style:vertical-pos"><xsl:value-of select="$vertpos"/></xsl:attribute>
		<xsl:attribute name="style:vertical-rel"><xsl:value-of select="$vertrel"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="uof:水平_4106">
		<xsl:variable name="horipos">
			<xsl:choose>
				<xsl:when test="uof:绝对_4107">from-left</xsl:when>
				<xsl:when test="uof:相对_4109/@参考点_410A='left'">left</xsl:when>
				<xsl:when test="uof:相对_4109/@参考点_410A='center'">center</xsl:when>
				<xsl:when test="uof:相对_4109/@参考点_410A='right'">right</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="horirel">
			<xsl:choose>
				<xsl:when test="@相对于_410C='margin'">page-content</xsl:when>
				<!--xsl:when test="@相对于_410C='margin'">paragraph</xsl:when-->
				<xsl:when test="@相对于_410C='page'">page</xsl:when>
				<xsl:when test="@相对于_410C='column'">paragraph</xsl:when>
				<xsl:when test="@相对于_410C='char'">char</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="style:horizontal-pos"><xsl:value-of select="$horipos"/></xsl:attribute>
		<xsl:attribute name="style:horizontal-rel"><xsl:value-of select="$horirel"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="uof:绕排_C622">
		<xsl:variable name="wrap_type">
			<xsl:value-of select="@绕排方式_C623"/>
		</xsl:variable>
		<xsl:variable name="wrap_place">
			<xsl:value-of select="@环绕文字_C624"/>
		</xsl:variable>
		<xsl:for-each select="@绕排方式_C623">
			<xsl:variable name="wrap">
				<xsl:choose>
					<xsl:when test="$wrap_place = 'left'">left</xsl:when>
					<xsl:when test="$wrap_place = 'both'">parallel</xsl:when>
					<xsl:when test="$wrap_place = 'right'">right</xsl:when>
					<xsl:when test="$wrap_place = 'largest'">dynamic</xsl:when>
					<xsl:when test="$wrap_type = 'infront-of-text' or $wrap_type = 'behind-text'">run-through</xsl:when>
					<xsl:when test="$wrap_type = 'top-bottom'">none</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="wrapcontour">
				<xsl:choose>
					<xsl:when test="$wrap_type = 'tight' or $wrap_type = 'through'">true</xsl:when>
					<xsl:when test="$wrap_type = 'square'">false</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="wrapcontourmode">
				<xsl:choose>
					<xsl:when test="$wrap_type = 'tight'">outside</xsl:when>
					<xsl:when test="$wrap_type = 'through'">full</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="run-through">
				<xsl:choose>
					<xsl:when test="$wrap_type = 'behind-text'">background</xsl:when>
					<xsl:otherwise>foreground</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="style:wrap"><xsl:value-of select="$wrap"/></xsl:attribute>
			<xsl:attribute name="style:wrap-contour"><xsl:value-of select="$wrapcontour"/></xsl:attribute>
			<xsl:attribute name="style:wrap-contour-mode"><xsl:value-of select="$wrapcontourmode"/></xsl:attribute>
			<xsl:attribute name="style:run-through"><xsl:value-of select="$run-through"/></xsl:attribute>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="图:图片属性_801E" mode="Graph">
		<xsl:if test="图:颜色模式_801F">
			<xsl:attribute name="draw:color-mode"><xsl:choose><xsl:when test="图:颜色模式_801F = 'auto'">standard</xsl:when><xsl:when test="图:颜色模式_801F = 'monochrome'">mono</xsl:when><xsl:when test="图:颜色模式_801F = 'erosion'">watermark</xsl:when><xsl:otherwise><xsl:value-of select="图:颜色模式_801F"/></xsl:otherwise></xsl:choose></xsl:attribute>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="图:亮度_8020">
				<xsl:attribute name="draw:luminance"><xsl:value-of select="concat(图:亮度_8020,'%')"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="draw:luminance">0%</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="图:对比度_8021">
				<xsl:attribute name="draw:contrast"><xsl:value-of select="concat(图:对比度_8021,'%')"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="draw:contrast">0%</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="图:图片裁剪_8022">
			<xsl:variable name="clipup">
				<xsl:value-of select="concat(图:图片裁剪_8022/图:上_8023,$uofUnit)"/>
			</xsl:variable>
			<xsl:variable name="clipdown">
				<xsl:value-of select="concat(图:图片裁剪_8022/图:下_8024,$uofUnit)"/>
			</xsl:variable>
			<xsl:variable name="clipleft">
				<xsl:value-of select="concat(图:图片裁剪_8022/图:左_8025,$uofUnit)"/>
			</xsl:variable>
			<xsl:variable name="clipright">
				<xsl:value-of select="concat(图:图片裁剪_8022/图:右_8026,$uofUnit)"/>
			</xsl:variable>
			<xsl:attribute name="fo:clip"><xsl:value-of select="concat('rect(',$clipup,',',$clipright,',',$clipdown,',',$clipleft,')')"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="图:预定义图形_8018" mode="Graph">
		<xsl:param name="textanchor"/>
		<!--
		<xsl:for-each select="node()">
			<xsl:choose>
				<xsl:when test="self::node()[name(.)='图:类别']">
				</xsl:when>
				<xsl:when test="self::node()[name(.)='图:名称']">
				</xsl:when>
				<xsl:when test="self::node()[name(.)='图:生成软件']">
				</xsl:when>
				<xsl:when test="self::node()[name(.)='图:关键点坐标']">
				</xsl:when>
				<xsl:when test="self::node()[name(.)='图:属性']">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="self::node()[name(.)='图:图片属性']">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="self::node()[name(.)='图:连接线规则']">
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>-->
		<xsl:if test="图:属性_801D">
			<xsl:apply-templates select="图:属性_801D" mode="Graph">
				<xsl:with-param name="textanchor" select="$textanchor"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template match="图:文本_803C" mode="Graph">
		<xsl:param name="textanchor"/>
		<xsl:if test="图:边距_803D/@上_C609 != ''">
			<xsl:attribute name="fo:padding-top"><xsl:value-of select="concat(图:边距_803D/@上_C609,$uofUnit)"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="图:边距_803D/@下_C60B != ''">
			<xsl:attribute name="fo:padding-bottom"><xsl:value-of select="concat(图:边距_803D/@下_C60B,$uofUnit)"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="图:边距_803D/@左_C608 != ''">
			<xsl:attribute name="fo:padding-left"><xsl:value-of select="concat(图:边距_803D/@左_C608,$uofUnit)"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="图:边距_803D/@右_C60A != ''">
			<xsl:attribute name="fo:padding-right"><xsl:value-of select="concat(图:边距_803D/@右_C60A,$uofUnit)"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="图:对齐_803E/@水平对齐_421D">
			<xsl:if test="not($textanchor and $textanchor/uof:占位符_C626/@类型_C627)">
				<xsl:variable name="horizotalType">
					<xsl:choose>
						<xsl:when test="图:对齐_803E/@水平对齐_421D = 'left'">left</xsl:when>
						<xsl:when test="图:对齐_803E/@水平对齐_421D = 'center'">center</xsl:when>
						<xsl:when test="图:对齐_803E/@水平对齐_421D = 'right'">right</xsl:when>
						<xsl:when test="图:对齐_803E/@水平对齐_421D = 'justified'">justify</xsl:when>
						<xsl:otherwise>left</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="draw:textarea-horizontal-align"><xsl:value-of select="$horizotalType"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="图:对齐_803E/@文字对齐_421E">
			<xsl:variable name="verticalType">
				<xsl:choose>
					<xsl:when test="图:对齐_803E/@文字对齐_421E = 'top'">top</xsl:when>
					<xsl:when test="图:对齐_803E/@文字对齐_421E = 'center'">middle</xsl:when>
					<xsl:when test="图:对齐_803E/@文字对齐_421E = 'bottom'">bottom</xsl:when>
					<xsl:when test="图:对齐_803E/@文字对齐_421E = 'base'">justify</xsl:when>
					<xsl:otherwise>top</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="draw:textarea-vertical-align"><xsl:value-of select="$verticalType"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@是否自动换行_8047 = 'false'">
			<xsl:attribute name="fo:wrap-option">no-wrap</xsl:attribute>
		</xsl:if>
		<!--xsl:choose>
			<xsl:when test="$textanchor and $textanchor/uof:占位符_C626">
				<xsl:attribute name="draw:auto-grow-height">true</xsl:attribute>
			</xsl:when>
			<xsl:otherwise-->
		<xsl:attribute name="draw:auto-grow-height"><xsl:choose><xsl:when test="string(@是否大小适应文字_8048) = 'true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
		<!--软件默认值为true，导致图形变形-->
		<xsl:attribute name="draw:auto-grow-width"><xsl:choose><xsl:when test="string(@是否大小适应文字_8048) = 'true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="uof:边距_C628" mode="anchor">
		<xsl:if test="@上_C609">
			<xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(@上_C609,$uofUnit)"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@下_C60B">
			<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(@下_C60B,$uofUnit)"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@右_C60A">
			<xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(@右_C60A,$uofUnit)"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@左_C608">
			<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(@左_C608,$uofUnit)"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="图:图形_8062" mode="Graph">
		<xsl:param name="textanchor"/>
		<xsl:element name="style:style">
			<xsl:choose>
				<xsl:when test="$textanchor/uof:占位符_C626">
					<!--是演中的占位符，则重写family-->
					<xsl:attribute name="style:family">presentation</xsl:attribute>
					<xsl:attribute name="style:name"><xsl:value-of select="@标识符_804B"/></xsl:attribute>
					<xsl:attribute name="style:display-name"><xsl:value-of select="@标识符_804B"/></xsl:attribute>
					<xsl:variable name="placeholder" select="$textanchor/uof:占位符_C626"/>
					<xsl:variable name="masterid">
						<xsl:choose>
							<xsl:when test="name($textanchor/..)='演:母版_6C0D'">
								<xsl:value-of select="$textanchor/../@标识符_6BE8"/>
							</xsl:when>
							<xsl:when test="name($textanchor/..)='演:幻灯片_6C0F'">
								<xsl:value-of select="$textanchor/../@母版引用_6B26"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<!--重写部分style:parent-style-name-->
					<xsl:choose>
						<xsl:when test="$placeholder='title'">
							<xsl:attribute name="style:parent-style-name"><xsl:value-of select="concat($masterid,'-title')"/></xsl:attribute>
						</xsl:when>
						<xsl:when test="$placeholder='subtitle' or $placeholder='vertical_subtitle'">
							<xsl:attribute name="style:parent-style-name"><xsl:value-of select="concat($masterid,'-subtitle')"/></xsl:attribute>
						</xsl:when>
						<xsl:when test="$placeholder='text' or $placeholder='vertical_text' or $placeholder='outline'">
							<xsl:attribute name="style:parent-style-name"><xsl:value-of select="concat($masterid,'-outline1')"/></xsl:attribute>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!-- alert starting 
                    <xsl:attribute name="style:family">graphic</xsl:attribute>
                     alert ending. -->
					<!--<xsl:for-each select="$textanchor">-->
					<xsl:choose>
						<!--xsl:when test="parent::node() = '演:母版_6C0D'"-->
						<xsl:when test="$textanchor">
							<xsl:for-each select="$textanchor">
								<xsl:choose>
									<xsl:when test="parent::node() = '演:母版_6C0D'">
										<xsl:attribute name="style:family">presentation</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="style:family">graphic</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="style:family">graphic</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="style:name"><xsl:value-of select="@标识符_804B"/></xsl:attribute>
					<xsl:attribute name="style:display-name"><xsl:value-of select="@标识符_804B"/></xsl:attribute>
					<!-- convert frame or customshape -->
					<xsl:variable name="id" select="@标识符_804B"/>
					<xsl:variable name="IsFrame">
						<xsl:choose>
							<xsl:when test="/uof:UOF_0000/图形:图形集_7C00/图:图形_8062/图:文本_803C/图:前后链接_803F/@前一链接_8040 = $id or /uof:UOF_0000/图形:图形集_7C00/图:图形_8062/图:文本_803C/图:前后链接_803F/@后一链接_8041 = $id">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="图:文本_803C/图:内容_8043//字:域开始_419E or 图:文本_803C/图:内容_8043/图:文字表_416C or 图:文本_803C/图:前后链接_803F/@前一链接_8040 or 图:文本_803C/图:前后链接_803F/@后一链接_8041 or $IsFrame = 'true' or (图:其他对象引用_8038 != '') or 图:文本_803C/图:内容_8043//uof:锚点_C644">
							<xsl:attribute name="style:parent-style-name"><xsl:value-of select="'Frame'"/></xsl:attribute>
						</xsl:when>
						<xsl:when test="图:文本_803C/图:内容_8043[string(@是否为文本框_8046) = 'true'] or 图:文本_803C/图:内容_8043[string(@是否为文本框_8046) = '1']"/>
						<!-- style:parent-style-name for xlink:href -->
						<xsl:when test="图:图片数据引用_8037">
							<!--用'图:预定义图形_8018/图:属性_801D/图:图片属性_801E'这个属性判断也行-->
							<xsl:attribute name="style:parent-style-name">Frame</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="style:parent-style-name">Default</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<style:graphic-properties draw:auto-grow-height="false" style:wrap="run-through" style:run-through="foreground" fo:padding-left="0pt" fo:padding-right="0pt" fo:padding-top="0pt" fo:padding-bottom="0pt">
				<!--<xsl:if test="name($textanchor)='字:锚点'">
					<xsl:attribute name="style:wrap">run-through</xsl:attribute>
					<xsl:attribute name="style:run-through">foreground</xsl:attribute>
				</xsl:if>-->
				<!--增加演示文稿文本框中min-height属性-->
				<xsl:if test="$textanchor/uof:占位符_C626/@类型_C627">
					<xsl:attribute name="fo:min-height"><xsl:value-of select="concat($textanchor/uof:大小_C621/@长_C604,$uofUnit)"/></xsl:attribute>
				</xsl:if>
				<xsl:for-each select="*">
					<xsl:choose>
						<xsl:when test="name(.)='图:svg图形对象_8017'">
						</xsl:when>
						<xsl:when test="name(.)='图:预定义图形_8018'">
							<xsl:apply-templates select="." mode="Graph">
								<xsl:with-param name="textanchor" select="$textanchor"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="name(.)='图:文本_803C'">
							<xsl:apply-templates select="." mode="Graph">
								<xsl:with-param name="textanchor" select="$textanchor"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="name(.)='图:控制点_8039'">
						</xsl:when>
						<xsl:when test="name(.)='图:翻转_803A'">
						</xsl:when>
						<xsl:when test="name(.)='图:组合位置_803B'">
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<xsl:if test="$textanchor">
					<!-- a special case,there is a @类型,but no uof:垂直 , starting -->
					<xsl:if test="$textanchor/uof:位置_C620/@类型_C646 = 'as-char'">
						<xsl:attribute name="style:vertical-pos"><xsl:value-of select="'from-top'"/></xsl:attribute>
					</xsl:if>
					<!-- a special case,there is a @类型,but no uof:垂直 ,ending -->
					<xsl:apply-templates select="$textanchor/uof:位置_C620/uof:垂直_410D"/>
					<xsl:apply-templates select="$textanchor/uof:位置_C620/uof:水平_4106"/>
					<xsl:apply-templates select="$textanchor/uof:绕排_C622"/>
					<xsl:if test="$textanchor/uof:边距_C628">
						<xsl:apply-templates select="$textanchor/uof:边距_C628" mode="anchor"/>
					</xsl:if>
					<xsl:if test="$textanchor/uof:保护_C62A/@大小_C643='true'">
						<xsl:choose>
							<xsl:when test="图:预定义图形_8018/图:名称_801A">
								<xsl:attribute name="style:protect">position size</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="style:protect">content size position</xsl:attribute>
								<xsl:attribute name="draw:size-protect">true</xsl:attribute>
								<xsl:attribute name="draw:move-protect">true</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$textanchor/uof:是否允许重叠_C62B">
					<xsl:attribute name="style:allowoverlap"><xsl:value-of select="$textanchor/uof:是否允许重叠_C62B"/></xsl:attribute>
				</xsl:if>
				<!--<xsl:if test="name($textanchor)='uof:锚点_C644'">
					<xsl:choose>
						<xsl:when test="$textanchor/@随动方式_C62F='move'">
							<xsl:attribute name="style:protect">size</xsl:attribute>
						</xsl:when>
						<xsl:when test="$textanchor/@随动方式_C62F='movesize'">
							<xsl:attribute name="style:protect">position</xsl:attribute>
						</xsl:when>
						<xsl:when test="$textanchor/@随动方式_C62F='none'">
							<xsl:attribute name="style:protect">position size</xsl:attribute>
						</xsl:when>
					</xsl:choose>
				</xsl:if>-->
			</style:graphic-properties>
			<xsl:for-each select="图:文本_803C/图:文字排列方向_8042">
				<xsl:variable name="writing-mode">
					<xsl:choose>
						<xsl:when test=".='r2l-t2b-90e-90w' or .='r2l-t2b-0e-90w' or .='l2r-b2t-270e-270w' or .='l2r-t2b-0e-90w' or .='vert-l2r'">tb-rl</xsl:when>
						<xsl:when test=".='l2r-b2t-270e-270w' or .='vert-l2r'">tb-rl</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$writing-mode != ''">
					<xsl:element name="style:paragraph-properties">
						<xsl:attribute name="style:font-independent-line-spacing" select="'true'"/>
						<xsl:attribute name="style:writing-mode"><xsl:value-of select="$writing-mode"/></xsl:attribute>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="GraphicStyle">
		<xsl:for-each select="/uof:UOF_0000/图形:图形集_7C00/图:图形_8062">
			<xsl:variable name="textanchor" select="key('rel_graphic_name',@标识符_804B)[1]"/>
			<!--排除母版中的titile、outline或text占位符引用的图形对应的式样（这些式样在officestyle中）-->
			<!--修改兼容案例 -->
			<!--xsl:if test="not(name($textanchor/..)='演:母版_6C0D' and $textanchor/../@类型_6BEA='slide' and ($textanchor/占位符_C626='title' or $textanchor/占位符_C626='text' or $textanchor/占位符_C626='outline')) and not($textanchor/@是否显示缩略图_C630='true' and $textanchor/占位符_C626!='clipart' and $textanchor/占位符_C626!='graphics')">
					<xsl:apply-templates select="." mode="Graph">
						<xsl:with-param name="textanchor" select="$textanchor"/>
					</xsl:apply-templates>
				</xsl:if-->
			<!--母版中的图形式样存储在styles.xml中-->
			<xsl:if test="not(name($textanchor/..)='演:母版_6C0D')">
				<xsl:apply-templates select="." mode="Graph">
					<xsl:with-param name="textanchor" select="$textanchor"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="/uof:UOF_0000/对象:对象数据集_D700/对象:对象数据_D701">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="MasterGraphicStyle">
		<xsl:for-each select="/uof:UOF_0000/图形:图形集_7C00">
			<xsl:for-each select="图:图形_8062">
				<xsl:variable name="textanchor" select="key('rel_graphic_name',@标识符_804B)[1]"/>
				<xsl:if test="name($textanchor/..)='演:母版_6C0D'">
					<xsl:apply-templates select="." mode="Graph">
						<xsl:with-param name="textanchor" select="$textanchor"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ArrowDefinition">
		<xsl:if test="图:预定义图形_8018/图:属性_801D/图:箭头_805D/图:前端箭头_805E">
			<xsl:element name="draw:marker">
				<xsl:variable name="tusy3" select="图:预定义图形_8018/图:属性_801D/图:箭头_805D/图:前端箭头_805E/图:式样_8000"/>
				<xsl:variable name="tudx3" select="图:预定义图形_8018/图:属性_801D/图:箭头_805D/图:前端箭头_805E/图:大小_8001"/>
				<xsl:variable name="drawname">
					<xsl:choose>
						<xsl:when test="$tusy3='normal'">
							<xsl:value-of select="concat('msArrowEnd_20_',$tudx3)"/>
						</xsl:when>
						<xsl:when test="$tusy3='diamond'">
							<xsl:value-of select="concat('msArrowDiamondEnd_20_',$tudx3)"/>
						</xsl:when>
						<xsl:when test="$tusy3='open'">
							<xsl:value-of select="concat('msArrowOpenEnd_20_',$tudx3)"/>
						</xsl:when>
						<xsl:when test="$tusy3='stealth'">
							<xsl:value-of select="concat('msArrowStealthEnd_20_',$tudx3)"/>
						</xsl:when>
						<xsl:when test="$tusy3='oval'">
							<xsl:value-of select="concat('msArrowOvalEnd_20_',$tudx3)"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="draw:name"><xsl:value-of select="$drawname"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="$tusy3='normal' and $tudx3='1'">
						<xsl:attribute name="svg:viewBox">0 0 140 140</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 140h-140z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='normal' and $tudx3='2'">
						<xsl:attribute name="svg:viewBox">0 0 140 310</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 210h-140z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='normal' and $tudx3='3'">
						<xsl:attribute name="svg:viewBox">0 0 140 350</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 350h-140z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='normal' and $tudx3='4'">
						<xsl:attribute name="svg:viewBox">0 0 210 140</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 140h-210z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='normal' and $tudx3='5'">
						<xsl:attribute name="svg:viewBox">0 0 210 210</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 210h-210z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='normal' and $tudx3='6'">
						<xsl:attribute name="svg:viewBox">0 0 210 350</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 350h-210z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='normal' and $tudx3='7'">
						<xsl:attribute name="svg:viewBox">0 0 350 140</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 140h-350z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='normal' and $tudx3='8'">
						<xsl:attribute name="svg:viewBox">0 0 350 210</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 210h-350z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='normal' and $tudx3='9'">
						<xsl:attribute name="svg:viewBox">0 0 350 350</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 350h-350z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='diamond' and $tudx3='1'">
						<xsl:attribute name="svg:viewBox">0 0 140 140</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 70-70 70-70-70z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='diamond' and $tudx3='2'">
						<xsl:attribute name="svg:viewBox">0 0 140 310</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 105-70 105-70-105z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='diamond' and $tudx3='3'">
						<xsl:attribute name="svg:viewBox">0 0 140 350</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 175-70 175-70-175z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='diamond' and $tudx3='4'">
						<xsl:attribute name="svg:viewBox">0 0 210 140</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 70-105 70-105-70z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='diamond' and $tudx3='5'">
						<xsl:attribute name="svg:viewBox">0 0 210 210</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 105-105 105-105-105z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='diamond' and $tudx3='6'">
						<xsl:attribute name="svg:viewBox">0 0 210 350</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 175-105 175-105-175z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='diamond' and $tudx3='7'">
						<xsl:attribute name="svg:viewBox">0 0 350 140</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 70-175 70-175-70z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='diamond' and $tudx3='8'">
						<xsl:attribute name="svg:viewBox">0 0 350 210</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 105-175 105-175-105z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='diamond' and $tudx3='9'">
						<xsl:attribute name="svg:viewBox">0 0 350 350</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 175-175 175-175-175z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='open' and $tudx3='1'">
						<xsl:attribute name="svg:viewBox">0 0 140 140</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 128-20 12-50-90-48 90-22-12z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='open' and $tudx3='2'">
						<xsl:attribute name="svg:viewBox">0 0 140 310</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 292-20 18-50-134-48 134-22-18z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='open' and $tudx3='3'">
						<xsl:attribute name="svg:viewBox">0 0 140 350</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 318-20 32-50-224-48 224-22-32z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='open' and $tudx3='4'">
						<xsl:attribute name="svg:viewBox">0 0 210 140</xsl:attribute>
						<xsl:attribute name="svg:d">m106 0 104 128-32 12-72-90-74 90-32-12z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='open' and $tudx3='5'">
						<xsl:attribute name="svg:viewBox">0 0 210 210</xsl:attribute>
						<xsl:attribute name="svg:d">m106 0 104 192-32 18-72-134-74 134-32-18z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='open' and $tudx3='6'">
						<xsl:attribute name="svg:viewBox">0 0 210 350</xsl:attribute>
						<xsl:attribute name="svg:d">m106 0 104 318-32 32-72-224-74 224-32-32z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='open' and $tudx3='7'">
						<xsl:attribute name="svg:viewBox">0 0 350 140</xsl:attribute>
						<xsl:attribute name="svg:d">m176 0 174 128-52 12-122-90-124 90-52-12z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='open' and $tudx3='8'">
						<xsl:attribute name="svg:viewBox">0 0 350 210</xsl:attribute>
						<xsl:attribute name="svg:d">m176 0 174 192-52 18-122-134-124 134-52-18z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='open' and $tudx3='9'">
						<xsl:attribute name="svg:viewBox">0 0 350 350</xsl:attribute>
						<xsl:attribute name="svg:d">m176 0 174 318-52 32-122-224-124 224-52-32z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='stealth' and $tudx3='1'">
						<xsl:attribute name="svg:viewBox">0 0 140 140</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 140-70-56-70 56z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='stealth' and $tudx3='2'">
						<xsl:attribute name="svg:viewBox">0 0 140 310</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 210-70-84-70 84z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='stealth' and $tudx3='3'">
						<xsl:attribute name="svg:viewBox">0 0 140 350</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 350-70-140-70 140z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='stealth' and $tudx3='4'">
						<xsl:attribute name="svg:viewBox">0 0 210 140</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 140-105-56-105 56z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='stealth' and $tudx3='5'">
						<xsl:attribute name="svg:viewBox">0 0 210 210</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 210-105-84-105 84z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='stealth' and $tudx3='6'">
						<xsl:attribute name="svg:viewBox">0 0 210 350</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 350-105-140-105 140z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='stealth' and $tudx3='7'">
						<xsl:attribute name="svg:viewBox">0 0 350 140</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 140-175-56-175 56z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='stealth' and $tudx3='8'">
						<xsl:attribute name="svg:viewBox">0 0 350 210</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 210-175-84-175 84z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='stealth' and $tudx3='9'">
						<xsl:attribute name="svg:viewBox">0 0 350 350</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 350-175-140-175 140z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='oval' and $tudx3='1'">
						<xsl:attribute name="svg:viewBox">0 0 140 140</xsl:attribute>
						<xsl:attribute name="svg:d">m140 0c0-38-32-70-70-70s-70 32-70 70 32 70 70 70 70-32 70-70z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='oval' and $tudx3='2'">
						<xsl:attribute name="svg:viewBox">0 0 140 310</xsl:attribute>
						<xsl:attribute name="svg:d">m140 0c0-57-32-105-70-105s-70 48-70 105 32 105 70 105 70-48 70-105z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='oval' and $tudx3='3'">
						<xsl:attribute name="svg:viewBox">0 0 140 350</xsl:attribute>
						<xsl:attribute name="svg:d">m140 0c0-96-32-175-70-175s-70 79-70 175 32 175 70 175 70-79 70-175z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='oval' and $tudx3='4'">
						<xsl:attribute name="svg:viewBox">0 0 210 140</xsl:attribute>
						<xsl:attribute name="svg:d">m210 0c0-38-48-70-105-70s-105 32-105 70 48 70 105 70 105-32 105-70z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='oval' and $tudx3='5'">
						<xsl:attribute name="svg:viewBox">0 0 210 210</xsl:attribute>
						<xsl:attribute name="svg:d">m210 0c0-57-48-105-105-105s-105 48-105 105 48 105 105 105 105-48 105-105z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='oval' and $tudx3='6'">
						<xsl:attribute name="svg:viewBox">0 0 210 350</xsl:attribute>
						<xsl:attribute name="svg:d">m210 0c0-96-48-175-105-175s-105 79-105 175 48 175 105 175 105-79 105-175z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='oval' and $tudx3='7'">
						<xsl:attribute name="svg:viewBox">0 0 350 140</xsl:attribute>
						<xsl:attribute name="svg:d">m350 0c0-38-79-70-175-70s-175 32-175 70 79 70 175 70 175-32 175-70z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='oval' and $tudx3='8'">
						<xsl:attribute name="svg:viewBox">0 0 350 210</xsl:attribute>
						<xsl:attribute name="svg:d">m350 0c0-57-79-105-175-105s-175 48-175 105 79 105 175 105 175-48 175-105z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy3='oval' and $tudx3='9'">
						<xsl:attribute name="svg:viewBox">0 0 350 350</xsl:attribute>
						<xsl:attribute name="svg:d">m350 0c0-96-79-175-175-175s-175 79-175 175 79 175 175 175 175-79 175-175z</xsl:attribute>
					</xsl:when>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
		<xsl:if test="图:预定义图形_8018/图:属性_801D/图:箭头_805D/图:后端箭头_805F">
			<xsl:element name="draw:marker">
				<xsl:variable name="tusy4" select="图:预定义图形_8018/图:属性_801D/图:箭头_805D/图:后端箭头_805F/图:式样_8000"/>
				<xsl:variable name="tudx4" select="图:预定义图形_8018/图:属性_801D/图:箭头_805D/图:后端箭头_805F/图:大小_8001"/>
				<xsl:variable name="drawname">
					<xsl:choose>
						<xsl:when test="$tusy4='normal'">
							<xsl:value-of select="concat('msArrowEnd_20_',$tudx4)"/>
						</xsl:when>
						<xsl:when test="$tusy4='diamond'">
							<xsl:value-of select="concat('msArrowDiamondEnd_20_',$tudx4)"/>
						</xsl:when>
						<xsl:when test="$tusy4='open'">
							<xsl:value-of select="concat('msArrowOpenEnd_20_',$tudx4)"/>
						</xsl:when>
						<xsl:when test="$tusy4='stealth'">
							<xsl:value-of select="concat('msArrowStealthEnd_20_',$tudx4)"/>
						</xsl:when>
						<xsl:when test="$tusy4='oval'">
							<xsl:value-of select="concat('msArrowOvalEnd_20_',$tudx4)"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="draw:name"><xsl:value-of select="$drawname"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="$tusy4='normal' and $tudx4='1'">
						<xsl:attribute name="svg:viewBox">0 0 140 140</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 140h-140z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='normal' and $tudx4='2'">
						<xsl:attribute name="svg:viewBox">0 0 140 310</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 210h-140z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='normal' and $tudx4='3'">
						<xsl:attribute name="svg:viewBox">0 0 140 350</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 350h-140z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='normal' and $tudx4='4'">
						<xsl:attribute name="svg:viewBox">0 0 210 140</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 140h-210z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='normal' and $tudx4='5'">
						<xsl:attribute name="svg:viewBox">0 0 210 210</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 210h-210z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='normal' and $tudx4='6'">
						<xsl:attribute name="svg:viewBox">0 0 210 350</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 350h-210z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='normal' and $tudx4='7'">
						<xsl:attribute name="svg:viewBox">0 0 350 140</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 140h-350z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='normal' and $tudx4='8'">
						<xsl:attribute name="svg:viewBox">0 0 350 210</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 210h-350z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='normal' and $tudx4='9'">
						<xsl:attribute name="svg:viewBox">0 0 350 350</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 350h-350z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='diamond' and $tudx4='1'">
						<xsl:attribute name="svg:viewBox">0 0 140 140</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 70-70 70-70-70z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='diamond' and $tudx4='2'">
						<xsl:attribute name="svg:viewBox">0 0 140 310</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 105-70 105-70-105z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='diamond' and $tudx4='3'">
						<xsl:attribute name="svg:viewBox">0 0 140 350</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 175-70 175-70-175z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='diamond' and $tudx4='4'">
						<xsl:attribute name="svg:viewBox">0 0 210 140</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 70-105 70-105-70z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='diamond' and $tudx4='5'">
						<xsl:attribute name="svg:viewBox">0 0 210 210</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 105-105 105-105-105z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='diamond' and $tudx4='6'">
						<xsl:attribute name="svg:viewBox">0 0 210 350</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 175-105 175-105-175z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='diamond' and $tudx4='7'">
						<xsl:attribute name="svg:viewBox">0 0 350 140</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 70-175 70-175-70z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='diamond' and $tudx4='8'">
						<xsl:attribute name="svg:viewBox">0 0 350 210</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 105-175 105-175-105z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='diamond' and $tudx4='9'">
						<xsl:attribute name="svg:viewBox">0 0 350 350</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 175-175 175-175-175z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='open' and $tudx4='1'">
						<xsl:attribute name="svg:viewBox">0 0 140 140</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 128-20 12-50-90-48 90-22-12z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='open' and $tudx4='2'">
						<xsl:attribute name="svg:viewBox">0 0 140 310</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 292-20 18-50-134-48 134-22-18z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='open' and $tudx4='3'">
						<xsl:attribute name="svg:viewBox">0 0 140 350</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 318-20 32-50-224-48 224-22-32z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='open' and $tudx4='4'">
						<xsl:attribute name="svg:viewBox">0 0 210 140</xsl:attribute>
						<xsl:attribute name="svg:d">m106 0 104 128-32 12-72-90-74 90-32-12z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='open' and $tudx4='5'">
						<xsl:attribute name="svg:viewBox">0 0 210 210</xsl:attribute>
						<xsl:attribute name="svg:d">m106 0 104 192-32 18-72-134-74 134-32-18z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='open' and $tudx4='6'">
						<xsl:attribute name="svg:viewBox">0 0 210 350</xsl:attribute>
						<xsl:attribute name="svg:d">m106 0 104 318-32 32-72-224-74 224-32-32z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='open' and $tudx4='7'">
						<xsl:attribute name="svg:viewBox">0 0 350 140</xsl:attribute>
						<xsl:attribute name="svg:d">m176 0 174 128-52 12-122-90-124 90-52-12z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='open' and $tudx4='8'">
						<xsl:attribute name="svg:viewBox">0 0 350 210</xsl:attribute>
						<xsl:attribute name="svg:d">m176 0 174 192-52 18-122-134-124 134-52-18z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='open' and $tudx4='9'">
						<xsl:attribute name="svg:viewBox">0 0 350 350</xsl:attribute>
						<xsl:attribute name="svg:d">m176 0 174 318-52 32-122-224-124 224-52-32z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='stealth' and $tudx4='1'">
						<xsl:attribute name="svg:viewBox">0 0 140 140</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 140-70-56-70 56z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='stealth' and $tudx4='2'">
						<xsl:attribute name="svg:viewBox">0 0 140 310</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 210-70-84-70 84z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='stealth' and $tudx4='3'">
						<xsl:attribute name="svg:viewBox">0 0 140 350</xsl:attribute>
						<xsl:attribute name="svg:d">m70 0 70 350-70-140-70 140z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='stealth' and $tudx4='4'">
						<xsl:attribute name="svg:viewBox">0 0 210 140</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 140-105-56-105 56z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='stealth' and $tudx4='5'">
						<xsl:attribute name="svg:viewBox">0 0 210 210</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 210-105-84-105 84z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='stealth' and $tudx4='6'">
						<xsl:attribute name="svg:viewBox">0 0 210 350</xsl:attribute>
						<xsl:attribute name="svg:d">m105 0 105 350-105-140-105 140z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='stealth' and $tudx4='7'">
						<xsl:attribute name="svg:viewBox">0 0 350 140</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 140-175-56-175 56z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='stealth' and $tudx4='8'">
						<xsl:attribute name="svg:viewBox">0 0 350 210</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 210-175-84-175 84z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='stealth' and $tudx4='9'">
						<xsl:attribute name="svg:viewBox">0 0 350 350</xsl:attribute>
						<xsl:attribute name="svg:d">m175 0 175 350-175-140-175 140z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='oval' and $tudx4='1'">
						<xsl:attribute name="svg:viewBox">0 0 140 140</xsl:attribute>
						<xsl:attribute name="svg:d">m140 0c0-38-32-70-70-70s-70 32-70 70 32 70 70 70 70-32 70-70z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='oval' and $tudx4='2'">
						<xsl:attribute name="svg:viewBox">0 0 140 310</xsl:attribute>
						<xsl:attribute name="svg:d">m140 0c0-57-32-105-70-105s-70 48-70 105 32 105 70 105 70-48 70-105z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='oval' and $tudx4='3'">
						<xsl:attribute name="svg:viewBox">0 0 140 350</xsl:attribute>
						<xsl:attribute name="svg:d">m140 0c0-96-32-175-70-175s-70 79-70 175 32 175 70 175 70-79 70-175z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='oval' and $tudx4='4'">
						<xsl:attribute name="svg:viewBox">0 0 210 140</xsl:attribute>
						<xsl:attribute name="svg:d">m210 0c0-38-48-70-105-70s-105 32-105 70 48 70 105 70 105-32 105-70z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='oval' and $tudx4='5'">
						<xsl:attribute name="svg:viewBox">0 0 210 210</xsl:attribute>
						<xsl:attribute name="svg:d">m210 0c0-57-48-105-105-105s-105 48-105 105 48 105 105 105 105-48 105-105z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='oval' and $tudx4='6'">
						<xsl:attribute name="svg:viewBox">0 0 210 350</xsl:attribute>
						<xsl:attribute name="svg:d">m210 0c0-96-48-175-105-175s-105 79-105 175 48 175 105 175 105-79 105-175z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='oval' and $tudx4='7'">
						<xsl:attribute name="svg:viewBox">0 0 350 140</xsl:attribute>
						<xsl:attribute name="svg:d">m350 0c0-38-79-70-175-70s-175 32-175 70 79 70 175 70 175-32 175-70z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='oval' and $tudx4='8'">
						<xsl:attribute name="svg:viewBox">0 0 350 210</xsl:attribute>
						<xsl:attribute name="svg:d">m350 0c0-57-79-105-175-105s-175 48-175 105 79 105 175 105 175-48 175-105z</xsl:attribute>
					</xsl:when>
					<xsl:when test="$tusy4='oval' and $tudx4='9'">
						<xsl:attribute name="svg:viewBox">0 0 350 350</xsl:attribute>
						<xsl:attribute name="svg:d">m350 0c0-96-79-175-175-175s-175 79-175 175 79 175 175 175 175-79 175-175z</xsl:attribute>
					</xsl:when>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
		<xsl:if test="name() = '扩展:前端箭头'">
			<xsl:element name="draw:marker">
				<xsl:copy-of select="@*"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="name() = '扩展:后端箭头'">
			<xsl:element name="draw:marker">
				<xsl:copy-of select="@*"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="LinearDefinition">
		<xsl:param name="dash"/>
		<xsl:choose>
			<xsl:when test="$dash = 'round-dot'">
				<draw:stroke-dash draw:name="round-dot" draw:display-name="round-dot" draw:style="round" draw:dots1="1" draw:dots1-length="0.025cm" draw:distance="0.025cm"/>
			</xsl:when>
			<xsl:when test="$dash = 'square-dot'">
				<draw:stroke-dash draw:name="square-dot" draw:display-name="square-dot" draw:style="rect" draw:dots1="1" draw:dots1-length="0.026cm" draw:distance="0.026cm"/>
			</xsl:when>
			<xsl:when test="$dash = 'dash'">
				<draw:stroke-dash draw:name="dash" draw:display-name="dash" draw:style="rect" draw:dots2="1" draw:dots2-length="0.105cm" draw:distance="0.079cm"/>
			</xsl:when>
			<xsl:when test="$dash = 'dash-dot'">
				<draw:stroke-dash draw:name="dash-dot" draw:display-name="dash-dot" draw:style="rect" draw:dots1="1" draw:dots1-length="0.026cm" draw:dots2="1" draw:dots2-length="0.105cm" draw:distance="0.079cm"/>
			</xsl:when>
			<xsl:when test="$dash = 'long-dash'">
				<draw:stroke-dash draw:name="long-dash" draw:display-name="long-dash" draw:style="rect" draw:dots2="1" draw:dots2-length="0.211cm" draw:distance="0.079cm"/>
			</xsl:when>
			<xsl:when test="$dash = 'long-dash-dot'">
				<draw:stroke-dash draw:name="long-dash-dot" draw:display-name="long-dash-dot" draw:style="rect" draw:dots1="1" draw:dots1-length="0.026cm" draw:dots2="1" draw:dots2-length="0.211cm" draw:distance="0.079cm"/>
			</xsl:when>
			<xsl:when test="$dash = 'dash-dot-dot'">
				<draw:stroke-dash draw:name="dash-dot-dot" draw:display-name="dash-dot-dot" draw:style="rect" draw:dots1="2" draw:dots1-length="0.026cm" draw:dots2="1" draw:dots2-length="0.211cm" draw:distance="0.079cm"/>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/扩展:内容_B206/@名称 = 'draw:stroke-dash'">
			<xsl:for-each select="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/扩展:内容_B206[@名称 = 'draw:stroke-dash']/扩展:线型数据">
				<draw:stroke-dash>
					<xsl:copy-of select="@*"/>
				</draw:stroke-dash>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="GraphicDefinition">
		<xsl:for-each select="/uof:UOF_0000/图形:图形集_7C00/图:图形_8062[图:预定义图形_8018/图:属性_801D/图:箭头_805D/图:前端箭头_805E] | /uof:UOF_0000/图形:图形集_7C00/图:图形_8062[图:预定义图形_8018/图:属性_801D/图:箭头_805D/图:后端箭头_805F] | /uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/扩展:内容_B206/扩展:前端箭头 | /uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/扩展:内容_B206/扩展:后端箭头">
			<xsl:call-template name="ArrowDefinition"/>
		</xsl:for-each>
		<xsl:for-each select="/uof:UOF_0000/图形:图形集_7C00/图:图形_8062[图:预定义图形_8018/图:属性_801D/图:线_8057/图:线类型_8059]">
			<xsl:call-template name="LinearDefinition">
				<xsl:with-param name="dash" select="图:预定义图形_8018/图:属性_801D/图:线_8057/图:线类型_8059/@虚实_805B"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="字:脚注_4159">
		<xsl:element name="text:note">
			<xsl:attribute name="text:note-class">footnote</xsl:attribute>
			<xsl:element name="text:note-citation">
				<xsl:value-of select="@引文体_4157"/>
			</xsl:element>
			<xsl:element name="text:note-body">
				<xsl:for-each select="*">
					<xsl:choose>
						<xsl:when test="name(.)='字:段落_416B'">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="name(.)='字:文字表_416C'">
							<xsl:apply-templates select="."/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="字:尾注_415A">
		<xsl:element name="text:note">
			<xsl:attribute name="text:note-class">endnote</xsl:attribute>
			<xsl:element name="text:note-citation">
				<xsl:value-of select="@引文体_4157"/>
			</xsl:element>
			<xsl:element name="text:note-body">
				<xsl:for-each select="*">
					<xsl:choose>
						<xsl:when test="name(.)='字:段落_416B'">
							<xsl:apply-templates select="."/>
						</xsl:when>
						<xsl:when test="name(.)='字:文字表_416C'">
							<xsl:apply-templates select="."/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:preserve-space elements="字:文本串_415B"/>
	<xsl:template match="字:文本串_415B">
		<xsl:choose>
			<xsl:when test="$document_type = 'presentation'">
				<xsl:variable name="graphid" select="ancestor::图:图形_8062/@标识符_804B"/>
				<xsl:variable name="sd-placeholder" select="key('rel_graphic_name',$graphid)/uof:占位符_C626/@类型_C627"/>
				<xsl:choose>
					<!-- alert staring 
					<xsl:when test="$sd-placeholder = 'date' and contains(.,'&lt;日期/时间&gt;')">
                        <xsl:value-of select="replace(.,'&lt;日期/时间&gt;','')" disable-output-escaping="yes"/>
					</xsl:when>
					<xsl:when test="$sd-placeholder = 'header' and contains(.,'&lt;页眉&gt;')">
						<xsl:value-of select="replace(.,'&lt;页眉&gt;','')" disable-output-escaping="yes"/>
					</xsl:when>
					<xsl:when test="$sd-placeholder = 'footer' and contains(.,'&lt;页脚&gt;')">
                        <xsl:value-of select="replace(.,'&lt;页脚&gt;','')" disable-output-escaping="yes"/>
					</xsl:when>
					<xsl:when test="$sd-placeholder = 'number' and contains(.,'&lt;#&gt;')">
						<xsl:value-of select="substring-before(.,'&lt;#&gt;')"/>
						<xsl:value-of select="substring-after(.,'&lt;#&gt;')"/>
					</xsl:when>-->
					<xsl:when test="$sd-placeholder = 'date'">
						<presentation:date-time/>
						<xsl:if test=".!= '&lt;日期/时间&gt;'">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$sd-placeholder = 'header'">
						<presentation:header/>
						<xsl:if test=".!= '&lt;页眉&gt;'">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$sd-placeholder = 'footer'">
						<presentation:footer/>
						<xsl:if test=".!= '&lt;页脚&gt;'">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$sd-placeholder = 'number'">
						<text:page-number>&lt;编号&gt;</text:page-number>
						<xsl:if test=".!= '&lt;编号&gt;' and .!= '&lt;#&gt;'">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="字:文本串_415B">
		<xsl:value-of select="."/>
	</xsl:template>-->
	<xsl:template match="uof:锚点_C644">
		<xsl:call-template name="ObjectContent"/>
	</xsl:template>
	<xsl:template match="字:制表符_415E">
		<xsl:element name="text:tab"/>
	</xsl:template>
	<xsl:template match="字:换行符_415F">
		<xsl:element name="text:line-break"/>
	</xsl:template>
	<xsl:template name="BreakPageOrColumn">
		<xsl:param name="styleName"/>
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="./字:段落属性_419B/字:自动编号信息_4186/@编号级别_4188">
					<xsl:value-of select="./字:段落属性_419B/字:自动编号信息_4186/@编号级别_4188"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="numberlevel">
						<xsl:for-each select="key('uof-number-styles',字:段落属性_419B/@式样引用_419C)">
							<xsl:value-of select="@级别值_4121"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="($numberlevel != '') and number($numberlevel) &gt; 0">
							<xsl:value-of select="$numberlevel"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="0"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="textName">
			<xsl:choose>
				<xsl:when test="number($level) &gt; 0">text:h</xsl:when>
				<xsl:when test="../../字:段落属性_419B/字:大纲级别_417C and ../../字:段落属性_419B/字:大纲级别_417C != '0'">text:h</xsl:when>
				<xsl:otherwise>text:p</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="name(preceding-sibling::*[1]) = '字:句属性_4158' and (preceding-sibling::*[1]/@式样引用_419C or count(preceding-sibling::*[1]/child::*))">
				<xsl:text disable-output-escaping="yes">&lt;/text:span&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
				<xsl:value-of select="$textName"/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				<xsl:value-of select="$textName"/>
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:value-of select="$styleName"/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;text:span&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
				<xsl:value-of select="$textName"/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				<xsl:value-of select="$textName"/>
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:value-of select="$styleName"/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:分栏符_4160">
		<xsl:variable name="styleName" select="concat('text:style-name=&quot;',concat('breakcolumn',generate-id(../..)),'&quot;')"/>
		<xsl:call-template name="BreakPageOrColumn">
			<xsl:with-param name="styleName" select="$styleName"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="字:空格符_4161">
		<xsl:element name="text:s">
			<xsl:attribute name="text:c"><xsl:value-of select="@个数_4162"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template match="字:分页符_4163">
		<xsl:variable name="styleName" select="concat('text:style-name=&quot;',concat('breakpage',generate-id(../..)),'&quot;')"/>
		<xsl:variable name="whetherCreateLastNode">
			<xsl:if test="not(following-sibling::*) and not(../following-sibling::*)">
				<xsl:if test="name(../../following-sibling::*[1]) = '字:段落_416B' or name(../../following-sibling::*[1]) = '字:文字表_416C'">
					<xsl:if test="(name(../../following-sibling::字:句_419D[1]/*[1]) != '字:分页符_4163' and not(../../following-sibling::字:句_419D[1]/字:句属性_4158)) or (../../following-sibling::字:句_419D[1]/字:句属性_4158 and name(../../following-sibling::字:句_419D[1]/*[2]) != '字:分页符_4163')">false</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="whetherCreateFirstNode">
			<xsl:if test="not(preceding-sibling::*) or (count(preceding-sibling::*) = 1 and name(preceding-sibling::*[1]) = '字:句属性_4158')">
				<xsl:if test="not(../preceding-sibling::*) or (count(../preceding-sibling::*) = 1 and name(../preceding-sibling::*[1]) = '字:段落属性_419B')">
					<xsl:if test="name(../../preceding-sibling::*[1]) = '字:段落_416B' or name(../../preceding-sibling::*[1]) = '字:文字表_416C'">false</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$whetherCreateFirstNode = 'false'"/>
			<xsl:when test="$whetherCreateLastNode = 'false'"/>
			<xsl:otherwise>
				<xsl:call-template name="BreakPageOrColumn">
					<xsl:with-param name="styleName" select="$styleName"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:引文符号_4164">
		
	</xsl:template>
	<xsl:template name="TextHyperlinkStart">
		<xsl:variable name="textastart">
			<xsl:value-of select="'&lt;text:a'"/>
		</xsl:variable>
		<xsl:variable name="linkout">
			<xsl:value-of select="'xlink:type=&quot;simple&quot;'"/>
		</xsl:variable>
		<xsl:variable name="hyperDest" select="@标识符_4100"/>
		<xsl:variable name="href1">
			<xsl:variable name="bsh" select="key('hyperlink', $hyperDest)/超链:目标_AA01"/>
			<xsl:if test="$bsh != ''">
				<xsl:analyze-string select="$bsh" regex="=?'?(.*?)'?!\$?([A-Z,a-z]{{1,2}})\$?(\d+)">
					<xsl:matching-substring>
						<xsl:variable name="apos">&apos;</xsl:variable>
						<xsl:value-of select="concat('#', '$', regex-group(1), '.', '$', regex-group(2), '$', regex-group(3))"/>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<xsl:choose>
							<xsl:when test="contains($bsh,'\')">
								<xsl:value-of select="concat('/',translate($bsh,'\','/'))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$bsh"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="href2" select="concat('#', key('hyperlink', $hyperDest)/超链:书签_AA0D)"/>
		<xsl:variable name="href">
			<xsl:choose>
				<xsl:when test="not($href2='#')">
					<xsl:value-of select="$href2"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$href1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="hrefout">
			<xsl:value-of select="concat('xlink:href=&quot;', $href, '&quot;')"/>
		</xsl:variable>
		<xsl:variable name="visited">
			<xsl:value-of select="key('hyperlink', $hyperDest)/超链:式样_AA02/@已访问式样引用_AA04"/>
		</xsl:variable>
		<xsl:variable name="stylename">
			<xsl:value-of select="key('hyperlink', $hyperDest)/超链:式样_AA02/@未访问式样引用_AA03"/>
		</xsl:variable>
		<xsl:variable name="visitedout">
			<xsl:value-of select="concat('text:style-name=&quot;', $stylename, '&quot;')"/>
		</xsl:variable>
		<xsl:variable name="stylenameout">
			<xsl:value-of select="concat('text:visited-style-name=&quot;', $visited, '&quot;')"/>
		</xsl:variable>
		<xsl:value-of disable-output-escaping="yes" select="concat($textastart, ' ', $linkout, ' ', $hrefout, ' ', $stylenameout, ' ', $visitedout, '&gt;')"/>
	</xsl:template>
	<xsl:template match="字:区域开始_4165">
		<xsl:choose>
			<xsl:when test="@类型_413B='hyperlink'">
				<xsl:variable name="biaoshi">
					<xsl:value-of select="@标识符_4100"/>
				</xsl:variable>
				<xsl:if test="following::*[name(.)='字:区域结束_4167'][@标识符引用_4168=$biaoshi]">
					<xsl:call-template name="TextHyperlinkStart"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@类型_413B='bookmark'">
				<xsl:variable name="biaoshi">
					<xsl:value-of select="@标识符_4100"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following-sibling::*[1][name(.)='字:区域结束_4167'][@标识符引用_4168=$biaoshi]">
						<xsl:element name="text:bookmark">
							<xsl:choose>
								<xsl:when test="not(@名称_4166)">
									<xsl:attribute name="text:name"><xsl:value-of select="/uof:UOF_0000/书签:书签集_9104/书签:书签_9105[书签:区域_9100/@区域引用_41CE=$biaoshi]/@名称_9103"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="text:name"><xsl:value-of select="@名称_4166"/></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="text:bookmark-start">
							<xsl:choose>
								<xsl:when test="not(@名称_4166)">
									<xsl:attribute name="text:name"><xsl:value-of select="/uof:UOF_0000/书签:书签集_9104/书签:书签_9105[书签:区域_9100/@区域引用_41CE=$biaoshi]/@名称_9103"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="text:name"><xsl:value-of select="@名称_4166"/></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@类型_413B='annotation'">
				<xsl:element name="office:annotation">
					<xsl:variable name="AnnoDest" select="@标识符_4100"/>
					<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:批注集_B669/规则:批注_B66A[@区域引用_41CE=$AnnoDest]">
						<xsl:variable name="name" select="@作者_41DD"/>
						<dc:creator>
							<xsl:choose>
								<xsl:when test="/uof:UOF_0000/规则:公用处理规则_B665/规则:用户集_B667">
									<xsl:value-of select="/uof:UOF_0000/规则:公用处理规则_B665/规则:用户集_B667/规则:用户_B668[@标识符_4100=$name]/@姓名_41DC"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$name"/>
								</xsl:otherwise>
							</xsl:choose>
						</dc:creator>
						<xsl:if test="@作者缩写_41DF">
							<xsl:element name="dc:creator-initials">
								<xsl:value-of select="@作者缩写_41DF"/>
							</xsl:element>
						</xsl:if>
						<dc:date>
							<xsl:value-of select="@日期_41DE"/>
						</dc:date>
						<xsl:for-each select="*">
							<xsl:apply-templates select="."/>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@类型_413B='user-data'">
				<xsl:variable name="fileName" select="/uof:UOF_0000/数据:用户数据集_6300/数据:用户数据_6301/数据:关系_6302[uof:UOF_0000/@uof:用户数据引用 = current()/@标识符_4100]/@名称_630D"/>
				<xsl:element name="office:annotation">
					<xsl:element name="dc:creator">__@*Start@#100001#1#0#0#0#0#0#0#16776960#</xsl:element>
					<xsl:element name="text:p">
						<xsl:value-of select="$fileName"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:区域结束_4167">
		<xsl:variable name="startmark" select="@标识符引用_4168"/>
		<xsl:for-each select="preceding::*[name(.)='字:区域开始_4165'][@标识符_4100=$startmark]">
			<xsl:choose>
				<xsl:when test="@类型_413B='hyperlink'">
					<xsl:text disable-output-escaping="yes">&lt;/text:a&gt;</xsl:text>
				</xsl:when>
				<xsl:when test="@类型_413B='bookmark'">
					<xsl:choose>
						<xsl:when test="following-sibling::*[1][name(.)='字:区域结束_4167'][@标识符引用_4168=$startmark]">
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="text:bookmark-end">
								<xsl:attribute name="text:name"><xsl:value-of select="/uof:UOF_0000/书签:书签集_9104/书签:书签_9105[书签:区域_9100/@区域引用_41CE=$startmark]/@名称_9103"/></xsl:attribute>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@类型_413B='annotation'">
					<xsl:choose>
						<xsl:when test="@标识符_4100=$startmark">
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="office:annotation_end">
								<xsl:attribute name="office:name"><xsl:value-of select="$startmark"/></xsl:attribute>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@类型_413B='user-data'">
					<xsl:variable name="fileName" select="/uof:UOF_0000/数据:用户数据集_6300/数据:用户数据_6301/数据:关系_6302[uof:UOF_0000/@uof:用户数据引用 = current()/@标识符引用_4168]/@名称_630D"/>
					<xsl:element name="office:annotation">
						<xsl:element name="dc:creator">__@*End@#100002#0#0#0#0#0#0#0#16776960#</xsl:element>
						<xsl:element name="text:p">
							<xsl:value-of select="$fileName"/>
						</xsl:element>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="字:修订开始_421F">
		<xsl:choose>
			<xsl:when test="@标识符_4220">
				<text:change-start text:change-id="{@标识符_4220}"/>
			</xsl:when>
			<xsl:otherwise>
				<text:change-start text:change-id="{@修订信息引用_4222}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:修订结束_4223">
		<text:change-end>
			<xsl:attribute name="text:change-id"><xsl:value-of select="@开始标识引用_4224"/></xsl:attribute>
		</text:change-end>
	</xsl:template>
	<xsl:template name="SentenceContent">
		<xsl:variable name="nCount">
			<xsl:value-of select="count(./字:区域开始_4165[@类型_413B='hyperlink'])"/>
		</xsl:variable>
		<xsl:variable name="HyperStart">
			<xsl:value-of select="./字:区域开始_4165[@类型_413B='hyperlink']"/>
		</xsl:variable>
		<xsl:variable name="HyperEnd">
			<xsl:value-of select="./字:区域结束_4167[@类型_413B='hyperlink']"/>
		</xsl:variable>
		<xsl:variable name="startmark" select="@标识符引用_4168"/>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name(.)='字:脚注_4159'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:尾注_415A'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:文本串_415B'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='uof:锚点_C644'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:制表符_415E'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:换行符_415F'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:分栏符_4160'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:空格符_4161'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:分页符_4163'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:引文符号'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:区域开始_4165'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:区域结束_4167'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:修订开始_421F'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:修订结束_4223'">
					<xsl:apply-templates select="."/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="字:句_419D">
		<xsl:choose>
			<xsl:when test="字:句属性_4158 and (字:句属性_4158/@式样引用_417B or count(./字:句属性_4158/child::*))">
				<xsl:element name="text:span">
					<xsl:choose>
						<xsl:when test="count(./字:句属性_4158/child::*)">
							<xsl:attribute name="text:style-name"><xsl:value-of select="generate-id(字:句属性_4158)"/></xsl:attribute>
						</xsl:when>
						<xsl:when test="字:句属性_4158/@式样引用_417B!=''">
							<xsl:variable name="textstylename">
								<xsl:variable name="textstyleref" select="字:句属性_4158/@式样引用_417B"/>
								<xsl:choose>
									<xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@标识符_4100=$textstyleref]">
										<xsl:value-of select="$textstyleref"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="generate-id(字:句属性_4158)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:attribute name="text:style-name"><xsl:value-of select="$textstylename"/></xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<xsl:call-template name="SentenceContent"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="SentenceContent"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ParaContent">
		<xsl:variable name="SpecialSection">
			<xsl:variable name="SectPos">
				<xsl:choose>
					<xsl:when test="preceding-sibling::*[1][name(.) = '字:分节_416A'] and preceding-sibling::*[1]/字:节属性_421B/字:节类型_41EA != 'continuous'">
						<!--xsl:call-template name="IsPrecedeType">
							<xsl:with-param name="nodename" select="'字:分节'"/>
							<xsl:with-param name="pos" select="0"/>
						</xsl:call-template-->
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="0"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="number($SectPos) &gt; 0">
					<!--<xsl:when test="preceding-sibling::node()[1][name()='字:分节']">-->
					<xsl:for-each select="preceding-sibling::*[position()=$SectPos]">
						<xsl:choose>
							<xsl:when test="字:节属性_421B/字:是否首页页眉页脚不同_41EE='true'">
								<xsl:value-of select="generate-id(字:节属性_421B/字:是否首页页眉页脚不同_41EE)"/>
							</xsl:when>
							<xsl:when test="字:节属性_421B/@字:首页显示 = 'false'">
								<xsl:value-of select="generate-id(字:节属性_421B/字:页码设置_4205)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="@名称_4166='RoStandard'">
										<xsl:value-of select="string('none')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="generate-id(.)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string('none')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="stylename">
			<xsl:variable name="breakPageForLastNode">
				<xsl:if test="name(preceding-sibling::*[1]/字:句_419D[last()]/*[last()]) = '字:分页符_4163'">
					<xsl:if test="not(name(./字:句_419D[1]/*[1]) = '字:句属性_4158' and name(./字:句_419D[1]/*[2]) = '字:分页符_4163' and name(./字:句_419D[1]/*[last()]) = '字:分页符_4163') and name(./字:句_419D[1]/*[1]) != '字:分页符_4163'">page</xsl:if>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="breakPageForFirstNode">
				<xsl:if test="(name(./字:句_419D[1]/*[1]) = '字:句属性_4158' and name(./字:句_419D[1]/*[2]) = '字:分页符_4163') or name(./字:句_419D[1]/*[1]) = '字:分页符_4163'">
					<xsl:if test=" (name(./字:句_419D[1]/*[last()]) = '字:分页符_4163' and count(./字:句_419D) &gt; 1) or name(./字:句_419D[1]/*[last()]) != '字:分页符_4163'">
						<xsl:if test="name(preceding-sibling::*[1]) = '字:段落_416B' or name(preceding-sibling::*[1]) = '字:文字表_416C'">page</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$breakPageForFirstNode = 'page' or $breakPageForLastNode = 'page'">
					<xsl:value-of select="concat('breakpage',generate-id(.))"/>
				</xsl:when>
				<xsl:when test="($SpecialSection != 'none')">
					<xsl:value-of select="generate-id(.)"/>
				</xsl:when>
				<xsl:when test="(count(./字:段落属性_419B/child::*) = 1) and not(./字:段落属性_419B/字:自动编号信息_4186)">
					<xsl:value-of select="generate-id(.)"/>
				</xsl:when>
				<xsl:when test="count(./字:段落属性_419B/child::*) &gt; 1">
					<xsl:value-of select="generate-id(.)"/>
				</xsl:when>
				<xsl:when test="ancestor::*[name() = '图:文本_803C']/图:文字排列方向_8042='r2l-t2b-90e-90w' or ancestor::*[name() = '图:文本_803C']/图:文字排列方向_8042='t2b-r2l-0e-0w' or ancestor::*[name() = '图:文本_803C']/图:文字排列方向_8042='r2l-t2b-0e-90w'">
					<xsl:value-of select="generate-id(.)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="./字:段落属性_419B/@式样引用_419C">
							<xsl:value-of select="./字:段落属性_419B/@式样引用_419C"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="none"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$stylename != 'none'">
			<xsl:attribute name="text:style-name"><xsl:value-of select="$stylename"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="字:段落属性_419B/字:大纲级别_417C and 字:段落属性_419B/字:大纲级别_417C != '0'">
			<xsl:attribute name="text:outline-level"><xsl:value-of select="字:段落属性_419B/字:大纲级别_417C"/></xsl:attribute>
		</xsl:if>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name(.)='字:句_419D'">
					<!-- uot目录域 -->
					<xsl:if test="not(preceding-sibling::*[1][name(.)='字:域代码_419F'] and not(preceding-sibling::*[2][@类型_416E='toc']))">
						<xsl:apply-templates select="."/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="name(.)='字:域开始_419E'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<!--
					<xsl:when test="self::node()[name(.)='字:域代码']">
						<xsl:apply-templates select="."/>
					</xsl:when>
					<xsl:when test="self::node()[name(.)='字:域结束_419F']">
						<xsl:apply-templates select="."/>
					</xsl:when>-->
				<xsl:when test="name(.)='字:修订开始_421F'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:修订结束_4223'">
					<xsl:apply-templates select="."/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="字:句_419D" mode="IsEmpty">
		<xsl:variable name="IsCurEmpty">
			<xsl:variable name="nCountChild" select="count(*)"/>
			<xsl:choose>
				<xsl:when test="$nCountChild = 0">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:when test="($nCountChild = 1) and (字:句属性_4158 != '')">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'false'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$IsCurEmpty = 'true'">
			<xsl:choose>
				<xsl:when test="following-sibling::字:句_419D">
					<xsl:apply-templates select="following-sibling::字:句_419D[1]" mode="IsEmpty"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'true'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="ParaElement">
		<xsl:param name="textName"/>
		<xsl:variable name="IsEmpty">
			<xsl:if test="$document_type='presentation'">
				<xsl:variable name="nCount1" select="count(字:域开始_419E)"/>
				<xsl:variable name="nCount2" select="count(域代码_419F)"/>
				<xsl:variable name="nCount3" select="count(字:域结束_419F)"/>
				<xsl:variable name="nCount4" select="count(字:修订开始_421F)"/>
				<xsl:variable name="nCount5" select="count(字:修订结束_4223)"/>
				<xsl:if test="($nCount1 = 0) and ($nCount2 = 0) and ($nCount3 = 0) and ($nCount4 = 0) and ($nCount5 = 0)">
					<xsl:choose>
						<xsl:when test="count(字:句_419D) = 0">
							<xsl:value-of select="'true'"/>
						</xsl:when>
						<!-- alert staring 
                        <xsl:otherwise>
							<xsl:apply-templates select="字:句_419D[1]" mode="IsEmpty"/>
						</xsl:otherwise>
                         -->
						<xsl:otherwise>
							<xsl:value-of select="'false'"/>
						</xsl:otherwise>
						<!-- alert ending. -->
					</xsl:choose>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		<xsl:if test="$IsEmpty != 'true'">
			<xsl:choose>
				<xsl:when test="字:域开始_419E[@类型_416E='REF'] or 字:域开始_419E[@类型_416E='section'] or 字:域开始_419E[@类型_416E='INDEX'] or 字:域开始_419E[@类型_416E='pageinsection']">
					<xsl:apply-templates select="字:域开始_419E"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="{$textName}">
						<xsl:if test="@标识符_4220">
							<xsl:attribute name="text:id"><xsl:value-of select="@标识符_4220"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="@标识符_4169">
							<xsl:attribute name="text:id"><xsl:value-of select="@标识符_4169"/></xsl:attribute>
						</xsl:if>
						<xsl:call-template name="ParaContent"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="ListContent">
		<xsl:param name="level"/>
		<xsl:param name="stylename"/>
		<xsl:param name="parastyle"/>
		<xsl:param name="continue-numbering"/>
		<xsl:element name="text:list">
			<xsl:if test="$stylename != ''">
				<xsl:attribute name="text:style-name"><xsl:value-of select="$stylename"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$continue-numbering != ''">
				<xsl:attribute name="text:continue-numbering"><xsl:value-of select="$continue-numbering"/></xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="number($level) = 0">
					<xsl:element name="text:list-header">
						<xsl:call-template name="ParaElement">
							<xsl:with-param name="textName" select="'text:p'"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>
				<xsl:when test="number($level) = 1">
					<xsl:element name="text:list-item">
						<xsl:call-template name="ParaElement">
							<xsl:with-param name="textName" select="'text:p'"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="text:list-item">
						<xsl:call-template name="ListContent">
							<xsl:with-param name="level" select="$level - 1"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="LevelInNumber">
		<xsl:param name="parastyle"/>
		<xsl:choose>
			<xsl:when test="./字:段落属性_419B/字:自动编号信息_4186/@编号级别_4188">
				<xsl:value-of select="./字:段落属性_419B/字:自动编号信息_4186/@编号级别_4188"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="numberlevel">
					<xsl:for-each select="key('uof-number-styles',字:段落属性_419B/@式样引用_419C)">
						<xsl:value-of select="@级别值_4121"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:choose>
					<!--<xsl:when test="not($numberlevel) and $numberlevel &gt; 0">-->
					<xsl:when test="($numberlevel != '') and number($numberlevel) &gt; 0">
						<xsl:value-of select="$numberlevel"/>
					</xsl:when>
					<xsl:when test="$parastyle/字:自动编号信息_4186/@编号级别_4188">
						<xsl:value-of select="$parastyle/字:自动编号信息_4186/@编号级别_4188"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="0"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="LevelInOutline">
		<xsl:param name="parastyle"/>
		<xsl:choose>
			<xsl:when test="$parastyle">
				<xsl:choose>
					<xsl:when test="$parastyle/字:大纲级别_417C">
						<xsl:value-of select="$parastyle/字:大纲级别_417C"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="parentparastyle" select="key('uof-paragraph-styles',$parastyle/@基式样引用_4104)"/>
						<xsl:call-template name="LevelInOutline">
							<xsl:with-param name="parastyle" select="$parentparastyle"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!--各级段落式样中均未存大纲级别-->
			<xsl:otherwise>'F'</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:段落_416B">
		<xsl:variable name="keyStyleName" select="字:段落属性_419B/@式样引用_419C"/>
		<xsl:variable name="parastyle" select="key('uof-paragraph-styles',$keyStyleName)"/>
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="$document_type = 'presentation'">
					<xsl:variable name="graphid" select="ancestor::图:图形_8062/@标识符_804B"/>
					<xsl:choose>
						<xsl:when test="key('rel_graphic_name',$graphid)/uof:占位符_C626/@类型_C627='outline'">
							<xsl:variable name="outlinelevel">
								<xsl:choose>
									<xsl:when test="./字:段落属性_419B/字:大纲级别_417C">
										<xsl:value-of select="./字:段落属性_419B/字:大纲级别_417C"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="LevelInOutline">
											<xsl:with-param name="parastyle" select="$parastyle"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$outlinelevel='F'">
									<xsl:call-template name="LevelInNumber">
										<xsl:with-param name="parastyle" select="$parastyle"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$outlinelevel"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="LevelInNumber">
								<xsl:with-param name="parastyle" select="$parastyle"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="LevelInNumber">
						<xsl:with-param name="parastyle" select="$parastyle"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="stylename">
			<xsl:choose>
				<xsl:when test="number($level) &gt; 0">
					<xsl:choose>
						<xsl:when test="./字:段落属性_419B/字:自动编号信息_4186/@编号引用_4187">
							<xsl:value-of select="字:段落属性_419B/字:自动编号信息_4186/@编号引用_4187"/>
						</xsl:when>
						<xsl:when test="$parastyle/字:自动编号信息_4186/@编号引用_4187">
							<xsl:value-of select="$parastyle/字:自动编号信息_4186/@编号引用_4187"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="key('uof-number-styles',字:段落属性_419B/@式样引用_419C)">
								<xsl:value-of select="../@标识符_4100"/>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="continue-numbering">
			<xsl:choose>
				<xsl:when test="字:段落属性_419B/字:自动编号信息_4186/@是否重新编号_4189='true'">false</xsl:when>
				<xsl:when test="$parastyle/字:自动编号信息_4186/@是否重新编号_4189='true'">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="number($level) &gt; 0 and not(./字:段落属性_419B/字:自动编号信息_4186/@编号引用_4187='HeadOutline')">
				<xsl:call-template name="ListContent">
					<xsl:with-param name="level" select="$level"/>
					<xsl:with-param name="stylename" select="$stylename"/>
					<xsl:with-param name="continue-numbering" select="$continue-numbering"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="textName">
					<xsl:choose>
						<!-- 图形中的段落对应到odf中均为text:p -->
						<xsl:when test="name(../..)='图:文本_803C'">text:p</xsl:when>
						<xsl:when test="number($level) &gt; 0">text:h</xsl:when>
						<xsl:when test="字:段落属性_419B/字:大纲级别_417C and 字:段落属性_419B/字:大纲级别_417C != '0'">text:h</xsl:when>
						<xsl:otherwise>text:p</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:call-template name="ParaElement">
					<xsl:with-param name="textName" select="$textName"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:单元格属性_41B7">
		<xsl:if test="字:跨列_41A7">
			<xsl:attribute name="table:number-columns-spanned"><xsl:value-of select="字:跨列_41A7"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="字:跨行_41A6">
			<xsl:attribute name="table:number-rows-spanned"><xsl:value-of select="字:跨行_41A6"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:单元格_41BE">
		<xsl:element name="table:table-cell">
			<xsl:attribute name="table:style-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="name( )='字:单元格属性_41B7'">
						<xsl:apply-templates select="."/>
					</xsl:when>
					<xsl:when test="name( )='字:段落_416B'">
						<xsl:apply-templates select="."/>
					</xsl:when>
					<xsl:when test="name( )='字:文字表_416C'">
						<xsl:apply-templates select="."/>
					</xsl:when>
					<xsl:otherwise>
					
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="字:文字表属性_41CC">
		<xsl:variable name="newstyle">
			<xsl:variable name="nChildCount" select="count(./child::*)"/>
			<xsl:choose>
				<xsl:when test="$nChildCount = 0">
					<xsl:value-of select="0"/>
				</xsl:when>
				<!--
				<xsl:when test="$nChildCount = 1">
					<xsl:choose>
						<xsl:when test="node()[1][name(.)='字:列宽集']">
							<xsl:value-of select="0"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>-->
				<xsl:otherwise>
					<xsl:value-of select="1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="($newstyle = 1)">
				<xsl:attribute name="table:style-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="table:style-name"><xsl:value-of select="@式样引用_419C"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<!--
		<xsl:for-each select="字:列宽集/字:列宽">
			<xsl:element name="table:table-column">
				<xsl:attribute name="table:style-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
			</xsl:element>
		</xsl:for-each>	-->
		<xsl:variable name="curStyle">
			<xsl:if test="@式样引用_419C">
				<xsl:value-of select="key('uof-table-styles',@式样引用_419C)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="字:列宽集_41C1/字:列宽_41C2">
				<xsl:for-each select="字:列宽集_41C1/字:列宽_41C2">
					<xsl:element name="table:table-column">
						<xsl:attribute name="table:style-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
					</xsl:element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$curStyle/字:列宽集_41C1/字:列宽_41C2">
						<xsl:for-each select="$curStyle/字:列宽集_41C1/字:列宽_41C2">
							<xsl:element name="table:table-column">
								<xsl:attribute name="table:style-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
							</xsl:element>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="../字:行_41CD[1]/字:单元格_41BE">
							<xsl:element name="table:table-column">
								<xsl:attribute name="table:style-name"><xsl:value-of select="generate-id(字:单元格属性_41B7/字:宽度_41A1)"/></xsl:attribute>
							</xsl:element>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:行_41CD">
		<xsl:choose>
			<xsl:when test="字:表行属性_41BD/字:是否表头行_41BC='true' or 字:表行属性_41BD/字:是否表头行_41BC='1'">
				<xsl:text disable-output-escaping="yes">&lt;table:table-header-rows&gt;</xsl:text>
				<xsl:element name="table:table-row">
					<xsl:attribute name="table:style-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
					<xsl:for-each select="*">
						<xsl:choose>
							<xsl:when test="name()='字:单元格_41BE'">
								<xsl:apply-templates select="."/>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
				<xsl:text disable-output-escaping="yes">&lt;/table:table-header-rows&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="table:table-row">
					<xsl:attribute name="table:style-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
					<xsl:for-each select="*">
						<xsl:choose>
							<xsl:when test="name()='字:单元格_41BE'">
								<xsl:apply-templates select="."/>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="字:文字表_416C">
		<xsl:choose>
			<xsl:when test="字:文字表属性_41CC/字:位置_41C7/uof:垂直_410D[@相对于_C647 = 'margin']/uof:相对_4109[@参考点_410B = 'bottom']">
				<xsl:element name="text:p">
					<xsl:if test="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/uof:公文框绑定内容/@uof:公文框绑定内容式样">
						<xsl:attribute name="text:style-name"><xsl:value-of select="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/uof:公文框绑定内容/@uof:公文框绑定内容式样"/></xsl:attribute>
					</xsl:if>
					<xsl:element name="draw:frame">
						<xsl:if test="字:文字表属性_41CC">
							<xsl:attribute name="draw:style-name">Embeded_fr<xsl:number count="字:文字表_416C[not(@字:类型='sub-table')]" from="/uof:UOF_0000/字:文字处理文档_4225" level="any" format="1"/></xsl:attribute>
						</xsl:if>
						<xsl:attribute name="draw:name">Embeded_frame<xsl:number count="字:文字表_416C[not(@字:类型='sub-table')]" from="/uof:UOF_0000/字:文字处理文档_4225" level="any" format="1"/></xsl:attribute>
						<xsl:attribute name="text:anchor-type"><xsl:value-of select="'paragraph'"/></xsl:attribute>
						<xsl:if test="字:文字表属性_41CC">
							<xsl:variable name="to_spand_frame_constant">
								<xsl:value-of select="0.44 div $other-to-cm-conversion-factor"/>
							</xsl:variable>
							<xsl:attribute name="svg:width"><xsl:value-of select="concat(sum(字:文字表属性_41CC/字:列宽集_41C1/字:列宽_41C2), $uofUnit)"/></xsl:attribute>
						</xsl:if>
						<xsl:attribute name="draw:z-index"><xsl:value-of select="'0'"/></xsl:attribute>
						<xsl:element name="draw:text-box">
							<xsl:element name="table:table">
								<xsl:for-each select="*">
									<xsl:choose>
										<xsl:when test="name(.)='字:文字表属性_41CC'">
											<xsl:apply-templates select="."/>
										</xsl:when>
										<xsl:when test="name(.)='字:行_41CD'">
											<xsl:apply-templates select="."/>
										</xsl:when>
										<xsl:when test="name(.)='字:修订开始_421F'">
											<xsl:apply-templates select="."/>
										</xsl:when>
										<xsl:when test="name(.)='字:修订结束_4223'">
											<xsl:apply-templates select="."/>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:if test="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/uof:公文框绑定内容">
						<xsl:variable name="pos" select="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/uof:公文框绑定内容/@uof:公文框绑定内容位置"/>
						<xsl:for-each select="/uof:UOF_0000/字:文字处理文档_4225/字:段落_416B[position()=$pos]">
							<xsl:apply-templates/>
						</xsl:for-each>
					</xsl:if>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="table:table">
					<xsl:variable name="isWrap">
						<xsl:choose>
							<xsl:when test="字:文字表属性_41CC/字:绕排_41C5 = 'around'">true</xsl:when>
							<xsl:when test="字:文字表属性_41CC/@式样引用_419C != '' and key('uof-table-styles',字:文字表属性_41CC/@式样引用_419C)/字:绕排_41C5 = 'around'">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$isWrap = 'true'">
						<xsl:attribute name="style:wrap">parallel</xsl:attribute>
					</xsl:if>
					<xsl:for-each select="*">
						<xsl:choose>
							<xsl:when test="name(.)='字:文字表属性_41CC'">
								<xsl:apply-templates select="."/>
							</xsl:when>
							<xsl:when test="name(.)='字:行_41CD'">
								<xsl:apply-templates select="."/>
							</xsl:when>
							<xsl:when test="name(.)='字:修订开始_421F'">
								<xsl:apply-templates select="."/>
							</xsl:when>
							<xsl:when test="name(.)='字:修订结束_4223'">
								<xsl:apply-templates select="."/>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="TextContent">
		<xsl:param name="content"/>
		<xsl:for-each select="$content/*">
			<xsl:choose>
				<xsl:when test="name(.)='字:分节_416A'">
					<!-- don't process this node here-->
				</xsl:when>
				<xsl:when test="name(.)='字:逻辑章节_421C'">
					
				</xsl:when>
				<xsl:when test="name(.)='字:段落_416B'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:文字表_416C'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:修订开始_421F'">
					<xsl:apply-templates select="."/>
				</xsl:when>
				<xsl:when test="name(.)='字:修订结束_4223'">
					<xsl:apply-templates select="."/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="TimeDateNumberStyle">
		<xsl:for-each select="//字:域开始_419E[@类型_416E='createdate'] | //字:域开始_419E[@类型_416E='time'] | //字:域开始_419E[@类型_416E='savedate'] | //字:域开始_419E[@类型_416E='date']">
			<xsl:variable name="styleName">
				<xsl:choose>
					<xsl:when test="contains(substring-after(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D[2]/字:文本串_415B[1],'\@ '),'d') or contains(substring-after(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D[2]/字:文本串_415B[1],'\@ '),'M') or contains(substring-after(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D[2]/字:文本串_415B[1],'\@ '),'y')">number:date-style</xsl:when>
					<xsl:otherwise>number:time-style</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:element name="{$styleName}">
				<xsl:attribute name="style:name"><xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:variable name="datestr" select="substring-after(following-sibling::字:域代码_419F/字:段落_416B/字:句_419D[2]/字:文本串_415B[1],'\@ ')"/>
				<xsl:call-template name="TimeTransform">
					<xsl:with-param name="str1" select="substring($datestr,2,string-length($datestr)-2)"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="TableOfContentsField">
		<xsl:element name="text:table-of-content">
			<xsl:variable name="stylenum">
				<xsl:number from="/uof:UOF_0000/字:文字处理文档_4225" level="any" count="字:句_419D" format="1"/>
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
					<xsl:apply-templates select="following-sibling::字:域代码_419F/字:段落_416B[position()=2]"/>
				</text:index-title>
				<xsl:for-each select="following-sibling::字:域代码_419F/child::*[position()>2]">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
			</text:index-body>
		</xsl:element>
	</xsl:template>
	<xsl:template name="AlphabeticalIndexField">
		<xsl:element name="text:alphabetical-index">
			<xsl:variable name="stylenum">
				<xsl:number from="/uof:UOF_0000/字:文字处理文档_4225" level="any" count="字:句_419D" format="1"/>
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
					<xsl:for-each select="字:域代码_419F/字:段落_416B[position()=2]">
						<text:p text:style-name="Index_20_Heading">
							<xsl:apply-templates select=".//字:文本串_415B"/>
						</text:p>
					</xsl:for-each>
				</text:index-title>
				<xsl:if test="字:域开始_419E/@类型_416E='INDEX'">
					<xsl:for-each select="字:域代码_419F/字:段落_416B[position()>2]">
						<xsl:element name="text:p">
							<xsl:attribute name="text:style-name"><xsl:value-of select="./字:段落属性_419B/@式样引用_419C"/></xsl:attribute>
							<xsl:for-each select="字:句_419D">
								<xsl:apply-templates select="self::node()/*"/>
							</xsl:for-each>
						</xsl:element>
					</xsl:for-each>
				</xsl:if>
			</text:index-body>
		</xsl:element>
	</xsl:template>
	<xsl:template name="TimeTransform">
		<xsl:param name="str1"/>
		<xsl:choose>
			<xsl:when test="contains($str1,'[DBNum1]')">
				<xsl:analyze-string select="substring-after($str1,'[DBNum1]')" regex="(am/pm)|(AM/PM)|[a-zA-Z]+">
					<xsl:matching-substring>
						<xsl:variable name="string" select="."/>
						<xsl:choose>
							<xsl:when test="$string='yyyy'">
								<number:year number:style="rolong"/>
							</xsl:when>
							<xsl:when test="$string='M'">
								<number:month number:style="rolong" number:textual="true"/>
							</xsl:when>
							<xsl:when test="$string='d'">
								<number:day number:style="rolong"/>
							</xsl:when>
							<xsl:when test="$string='AM/PM'">
								<number:am-pm/>
							</xsl:when>
							<xsl:when test="$string='h'">
								<number:hours number:style="long"/>
							</xsl:when>
							<xsl:when test="$string='mm'">
								<number:minutes number:style="long"/>
							</xsl:when>
							<xsl:when test="$string='ss'">
								<number:seconds number:style="long"/>
							</xsl:when>
						</xsl:choose>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<number:text>
							<xsl:value-of select="."/>
						</number:text>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</xsl:when>
			<xsl:otherwise>
				<xsl:analyze-string select="$str1" regex="(am/pm)|(AM/PM)|[a-zA-Z]+">
					<xsl:matching-substring>
						<xsl:variable name="string" select="."/>
						<xsl:choose>
							<xsl:when test="$string='am/pm' or $string='AM/PM'">
								<number:am-pm/>
							</xsl:when>
							<xsl:when test="$string='yyyy'">
								<number:year number:style="long"/>
							</xsl:when>
							<xsl:when test="$string='yy'">
								<number:year/>
							</xsl:when>
							<xsl:when test="$string='dddd'">
								<number:day-of-week number:style="long"/>
							</xsl:when>
							<xsl:when test="$string='dd'">
								<number:day number:style="long"/>
							</xsl:when>
							<xsl:when test="$string='d'">
								<number:day/>
							</xsl:when>
							<xsl:when test="$string='MMMM'">
								<number:month number:style="long" number:textual="true"/>
							</xsl:when>
							<xsl:when test="$string='MMM' or $string='MM'">
								<number:month number:style="long"/>
							</xsl:when>
							<xsl:when test="$string='M'">
								<number:month/>
							</xsl:when>
							<xsl:when test="$string='HH' or $string='hh'">
								<number:hours number:style="long"/>
							</xsl:when>
							<xsl:when test="$string='h' or $string='H'">
								<number:hours/>
							</xsl:when>
							<xsl:when test="$string='mm'">
								<number:minutes number:style="long"/>
							</xsl:when>
							<xsl:when test="$string='m'">
								<number:minutes/>
							</xsl:when>
							<xsl:when test="$string='SS' or $string='ss'">
								<number:seconds number:style="long"/>
							</xsl:when>
							<xsl:when test="$string='s'">
								<number:seconds/>
							</xsl:when>
							<xsl:when test="$string='WW'">
								<number:week-of-year number:style="long"/>
							</xsl:when>
							<xsl:when test="$string='W'">
								<number:day-of-week number:style="long"/>
							</xsl:when>
							<xsl:when test="$string='Q季'">
								<number:quarter/>
							</xsl:when>
							<xsl:when test="$string='第QQ季度'">
								<number:quarter number:style="long"/>
							</xsl:when>
							<xsl:when test="$string='NN'">
								<number:text>第</number:text>
								<number:week-of-year/>
								<number:text>周</number:text>
							</xsl:when>
						</xsl:choose>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<number:text>
							<xsl:value-of select="."/>
						</number:text>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--<xsl:template name="TimeTransform">
		<xsl:param name="str1"/>
		<xsl:choose>
			
			<xsl:when test="substring($str1,1,5)='am/pm'">
				<xsl:variable name="str1-before" select="substring($str1,1,5)"/>
				<xsl:variable name="str1-after" select="substring($str1,6)"/>
				<number:am-pm/>
				<xsl:if test="$str1-after != ' '">
					<number:text>
						<xsl:value-of select="substring($str1-after,1,1)"/>
					</number:text>
				</xsl:if>
				<xsl:if test="string-length($str1-after)&gt;1">
					<xsl:call-template name="TimeTransform">
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
							<xsl:call-template name="TimeTransform">
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
								<xsl:call-template name="TimeTransform">
									<xsl:with-param name="str1" select="substring($str1-after,2)"/>
								</xsl:call-template>
							</xsl:if>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="DateTimeTransform">
		<xsl:param name="str1"/>
		<xsl:choose>
			
			<xsl:when test="substring($str1,1,5)='am/pm'">
				<xsl:variable name="str1-before" select="substring($str1,1,5)"/>
				<xsl:variable name="str1-after" select="substring($str1,6)"/>
				<number:am-pm/>
				<xsl:if test="$str1-after != ' '">
					<number:text>
						<xsl:value-of select="substring($str1-after,1,1)"/>
					</number:text>
				</xsl:if>
				<xsl:if test="string-length($str1-after)&gt;1">
					<xsl:call-template name="TimeTransform">
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
							<xsl:call-template name="DateTimeTransform">
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
								<xsl:if test="substring($str1,1,1)='H' or substring($str1,1,1)='h'">
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
									<xsl:call-template name="DateTimeTransform">
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
										<xsl:call-template name="DateTimeTransform">
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
												<xsl:call-template name="DateTimeTransform">
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
												<xsl:call-template name="DateTimeTransform">
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
										<xsl:call-template name="DateTimeTransform">
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
										<xsl:call-template name="DateTimeTransform">
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
	</xsl:template>-->
	<xsl:template name="DateField">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<!--<xsl:variable name="date0" select="substring-after(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,'\@ ')"/>
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
			<xsl:call-template name="DateTimeTransform">
				<xsl:with-param name="str1" select="substring($datestr,2,string-length($datestr)-2)"/>
			</xsl:call-template>-->
			<xsl:variable name="datestr" select="following-sibling::字:句_419D[1]/字:文本串_415B"/>
			<xsl:attribute name="style:data-style-name"><xsl:value-of select="generate-id()"/></xsl:attribute>
			<xsl:attribute name="text:date-value"><xsl:value-of select="$datestr"/></xsl:attribute>
			<xsl:if test="@是否锁定_416F='true'">
				<xsl:attribute name="text:fixed">true</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$datestr"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TimeField">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<!--<xsl:variable name="date0" select="substring-after(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,'\@ ')"/>
			<xsl:variable name="datestr" select="$date0"/>
			<xsl:call-template name="TimeTransform">
				<xsl:with-param name="str1" select="substring($datestr,2,string-length($datestr)-2)"/>
			</xsl:call-template>-->
			<xsl:variable name="datestr" select="following-sibling::字:句_419D[1]/字:文本串_415B"/>
			<xsl:attribute name="style:data-style-name"><xsl:value-of select="generate-id()"/></xsl:attribute>
			<xsl:if test="$datestr != ''">
				<xsl:attribute name="text:time-value"><xsl:value-of select="$datestr"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@是否锁定_416F='true'">
				<xsl:attribute name="text:fixed">true</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$datestr"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="OutputDateField">
		<xsl:variable name="datestr" select="following-sibling::字:句_419D[1]/字:文本串_415B"/>
		<xsl:element name="text:date">
			<xsl:attribute name="style:data-style-name"><xsl:value-of select="generate-id()"/></xsl:attribute>
			<xsl:attribute name="text:date-value"><xsl:value-of select="$datestr"/></xsl:attribute>
			<xsl:if test="@是否锁定_416F='true'">
				<xsl:attribute name="text:fixed">true</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$datestr"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="EditingDurationField">
		<xsl:variable name="datestr" select="following-sibling::字:句_419D[1]/字:文本串_415B"/>
		<xsl:element name="text:editing-duration">
			<xsl:attribute name="style:data-style-name"><xsl:value-of select="generate-id()"/></xsl:attribute>
			<xsl:if test="@是否锁定_416F='true'">
				<xsl:attribute name="text:fixed">true</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$datestr"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="PageNumberField">
		<xsl:element name="text:page-number">
			<xsl:for-each select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
				<xsl:variable name="format">
					<xsl:value-of select="substring-after(.,' \* ')"/>
				</xsl:variable>
				<xsl:variable name="fmt">
					<xsl:call-template name="NumFormat">
						<xsl:with-param name="oo_format" select="$format"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:attribute name="style:num-format"><xsl:value-of select="$fmt"/></xsl:attribute>
				<xsl:attribute name="text:select-page"><xsl:choose><xsl:when test="../../../字:页码设置_4205/@字:首页显示 = 'false'">current</xsl:when><xsl:otherwise>current</xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:if test="following-sibling::node() = 'PAGE \* Arabic'">
					<xsl:attribute name="text:page-adjust"><xsl:value-of select="number(following-sibling::node()) - 1"/></xsl:attribute>
				</xsl:if>
				<xsl:value-of select="following-sibling::node()"/>
				<xsl:value-of select="../../../following-sibling::node()"/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="PageCountField">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<!--
			<xsl:variable name="date0" select="substring-after(following-sibling::字:域代码_419F[1][@类型_416E = 'numpages']/字:段落_416B/字:句_419D/字:文本串_415B,' \* ')"/>
			<xsl:variable name="datestr" select="substring-before(following-sibling::字:域代码_419F[1][@类型_416E = 'numpages']/字:段落_416B/字:句_419D/字:文本串_415B,'\* ')"/>
			
			<xsl:variable name="fmt">
				<xsl:call-template name="NumFormat">
					<xsl:with-param name="oo_format" select="substring-before($date0,' \*')"/>
				</xsl:call-template>
			</xsl:variable>-->
			<xsl:variable name="fmt">
				<xsl:call-template name="NumFormat">
					<xsl:with-param name="oo_format" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:element name="text:page-count">
				<xsl:attribute name="style:num-format"><xsl:value-of select="$fmt"/></xsl:attribute>
				<xsl:value-of select="following-sibling::字:句_419D/字:文本串_415B"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="AuthorField">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<xsl:variable name="datestr">
				<xsl:choose>
					<xsl:when test="contains(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,'\*')">
						<xsl:value-of select="substring-before(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,' \* ')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$datestr='AUTHOR'">
					<xsl:element name="text:author-name">
						<xsl:value-of select="following-sibling::字:句_419D/字:文本串_415B"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$datestr='AUTHORINITIALS'">
					<xsl:element name="text:author-initials">
						<xsl:value-of select="following-sibling::字:句_419D/字:文本串_415B"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$datestr='MODIFICATIONAUTHOR'">
					<xsl:element name="text:creator">
						<xsl:value-of select="following-sibling::字:句_419D/字:文本串_415B"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$document_type != 'presentation'">
					<xsl:element name="text:initial-creator">
						<xsl:value-of select="following-sibling::字:句_419D/字:文本串_415B"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TitleField">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<xsl:variable name="date0" select="substring-after(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,' \* ')"/>
			<xsl:variable name="datestr" select="substring-before(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,'\* ')"/>
			<xsl:element name="text:title">
				<xsl:value-of select="following-sibling::字:句_419D/字:文本串_415B"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="SubjectField">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<xsl:variable name="date0" select="substring-after(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,' \* ')"/>
			<xsl:variable name="datestr" select="substring-before(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,'\* ')"/>
			<xsl:element name="text:subject">
				<xsl:value-of select="following-sibling::字:句_419D/字:文本串_415B"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="KeywordsField">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<xsl:element name="text:keywords">
				<xsl:if test="@是否锁定_416F='true'">
					<xsl:attribute name="text:fixed">true</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="following-sibling::字:句_419D/字:文本串_415B"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="CommentsField">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<xsl:element name="text:description">
				<xsl:if test="@是否锁定_416F='true'">
					<xsl:attribute name="text:fixed">true</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="following-sibling::字:句_419D/字:文本串_415B"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="RevnumField">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<xsl:element name="text:editing-cycles">
				<xsl:if test="@是否锁定_416F='true'">
					<xsl:attribute name="text:fixed">true</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="following-sibling::字:句_419D/字:文本串_415B"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="FilenameField">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<xsl:element name="text:file-name">
				<xsl:variable name="string">
					<xsl:value-of select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B"/>
				</xsl:variable>
				<xsl:attribute name="text:display"><xsl:choose><xsl:when test="contains($string,' \p')">full</xsl:when><xsl:otherwise>name-and-extension</xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:if test="@是否锁定_416F='true'">
					<xsl:attribute name="text:fixed">true</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="following-sibling::字:句_419D/字:文本串_415B"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="EditTime">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<!--<xsl:variable name="date0" select="substring-after(following-sibling::字:域代码_419F/字:段落_416B/字:句_419D/字:文本串_415B,'\@ ')"/>
			<xsl:variable name="datestr" select="$date0"/>
			<xsl:call-template name="TimeTransform">
				<xsl:with-param name="str1" select="substring($datestr,2,string-length($datestr)-2)"/>
			</xsl:call-template>-->
			<xsl:variable name="datestr" select="following-sibling::字:句_419D[1]/字:文本串_415B"/>
			<xsl:attribute name="style:data-style-name"><xsl:value-of select="generate-id()"/></xsl:attribute>
			<xsl:if test="$datestr != ''">
				<xsl:attribute name="text:time-value"><xsl:value-of select="$datestr"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@是否锁定_416F='true'">
				<xsl:attribute name="text:fixed">true</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$datestr"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="CreationTime">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<!--<xsl:variable name="date0" select="substring-after(following-sibling::字:域代码_419F/字:段落_416B/字:句_419D/字:文本串_415B,'\@ ')"/>
			<xsl:variable name="datestr" select="$date0"/>
			<xsl:call-template name="TimeTransform">
				<xsl:with-param name="str1" select="substring($datestr,2,string-length($datestr)-2)"/>
			</xsl:call-template>-->
			<xsl:variable name="datestr" select="following-sibling::字:句_419D[1]/字:文本串_415B"/>
			<xsl:attribute name="style:data-style-name"><xsl:value-of select="generate-id()"/></xsl:attribute>
			<xsl:if test="$datestr != ''">
				<xsl:attribute name="text:time-value"><xsl:value-of select="$datestr"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@是否锁定_416F='true'">
				<xsl:attribute name="text:fixed">true</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$datestr"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="CharCount">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<!--<xsl:variable name="date0" select="substring-after(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,' \* ')"/>
			<xsl:variable name="datestr" select="substring-before(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,'\* ')"/>
			<xsl:variable name="fmt">
				<xsl:call-template name="NumFormat">
					<xsl:with-param name="oo_format" select="substring-before($date0,' \#')"/>
				</xsl:call-template>
			</xsl:variable>-->
			<xsl:variable name="fmt">
				<xsl:call-template name="NumFormat">
					<xsl:with-param name="oo_format" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:element name="text:character-count">
				<xsl:attribute name="style:num-format"><xsl:value-of select="$fmt"/></xsl:attribute>
				<xsl:value-of select="following-sibling::字:句_419D/字:文本串_415B"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="CaptionField">
		<xsl:if test="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B or 字:域代码_419F/字:段落_416B/字:句_419D/字:文本串_415B">
			<xsl:variable name="aa" select="substring-after(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,'\f ')"/>
			<xsl:variable name="ooow" select="substring-after($aa,'ooow:') "/>
			<xsl:variable name="as" select="substring-before(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,' \* ')"/>
			<xsl:variable name="ad">
				<xsl:value-of select="substring-after($as,'SEQ ') "/>
			</xsl:variable>
			<xsl:variable name="num">
				<xsl:value-of select="substring-after(substring-before(following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:文本串_415B,' \f'),'\* ')"/>
			</xsl:variable>
			<xsl:variable name="fmt">
				<xsl:call-template name="NumFormat">
					<xsl:with-param name="oo_format" select="$num"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:element name="text:sequence">
				<xsl:attribute name="text:name"><xsl:choose><xsl:when test="$ad='表格'">Table</xsl:when><xsl:when test="$ad='图表'">Drawing</xsl:when><xsl:otherwise><xsl:value-of select="$ad"/></xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:attribute name="text:formula"><xsl:choose><xsl:when test="contains($aa,'ooow:')"><xsl:value-of select="$ooow"/></xsl:when><xsl:when test="contains($as,'表格')"><xsl:value-of select="concat('Table','+',$fmt)"/></xsl:when><xsl:when test="contains($as,'图表')"><xsl:value-of select="concat('Drawing','+',$fmt)"/></xsl:when><xsl:otherwise><xsl:value-of select="$aa"/></xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:attribute name="style:num-format"><xsl:value-of select="$fmt"/></xsl:attribute>
				<xsl:value-of select="following-sibling::字:句_419D[1]/字:文本串_415B"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="PlaceholderField">
		<xsl:element name="text:placeholder">
			<xsl:attribute name="text:placeholder-type"><xsl:value-of select="substring-before(@类型_416E,'placeholder')"/></xsl:attribute>
			<xsl:attribute name="text:description"><xsl:value-of select="following-sibling::字:域代码_419F/字:段落_416B/字:句_419D/字:文本串_415B"/></xsl:attribute>
			<xsl:value-of select="following-sibling::字:句_419D[1]/字:文本串_415B"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="PageinSection">
		<text:section>
			<xsl:attribute name="text:name">sect<xsl:number from="/uof:UOF_0000/字:文字处理文档_4225" level="any" count="字:域开始_419E[@类型_416E='pageinsection']"/></xsl:attribute>
			<xsl:if test="字:域开始_419E/@是否锁定_416F='true'">
				<xsl:attribute name="text:protected">true</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="following-sibling::字:域代码_419F/child::node()">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</text:section>
	</xsl:template>
	<xsl:template name="SectionField">
		<text:section>
			<xsl:attribute name="text:name">sect<xsl:number from="/uof:UOF_0000/字:文字处理文档_4225" level="any" count="字:域开始_419E[@类型_416E='section']"/></xsl:attribute>
			<xsl:if test="字:域开始_419E/@是否锁定_416F='true'">
				<xsl:attribute name="text:protected">true</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="following-sibling::字:域代码_419F/child::node()">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</text:section>
	</xsl:template>
	<xsl:template name="NumFormat">
		<xsl:param name="oo_format"/>
		<xsl:choose>
			<xsl:when test="contains($oo_format,'Arabic')">1</xsl:when>
			<xsl:when test="contains($oo_format,'ALPHABETIC')">A</xsl:when>
			<xsl:when test="contains($oo_format,'alphabetic')">a</xsl:when>
			<xsl:when test="contains($oo_format,'ROMAN')">I</xsl:when>
			<xsl:when test="contains($oo_format,'roman')">i</xsl:when>
			<xsl:when test="contains($oo_format,'CHINESENUM3')">一, 二, 三, ...</xsl:when>
			<xsl:when test="contains($oo_format,'CHINESENUM2')">壹, 贰, 叁, ...</xsl:when>
			<xsl:when test="contains($oo_format,'ZODIAC1')">甲, 乙, 丙, ...</xsl:when>
			<xsl:when test="contains($oo_format,'ZODIAC2')">子, 丑, 寅, ...</xsl:when>
			<xsl:when test="contains($oo_format,'GB1')">１, ２, ３, ...</xsl:when>
			<xsl:when test="contains($oo_format,'GB3')">①, ②, ③, ...</xsl:when>
			<xsl:when test="contains($oo_format,'GB4')">㈠, ㈡, ㈢, ...</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="AdjustNumber">
		<xsl:param name="format"/>
		<xsl:param name="adjustnode"/>
		<xsl:choose>
			<xsl:when test="$format='Arabic'">
				<xsl:value-of select="number($adjustnode) - 1"/>
			</xsl:when>
			<xsl:when test="$format='ALPHABETIC'">
				<xsl:value-of select="string-to-codepoints($adjustnode) - string-to-codepoints('A')"/>
			</xsl:when>
			<xsl:when test="$format='alphabetic'">
				<xsl:value-of select="string-to-codepoints($adjustnode) - string-to-codepoints('a')"/>
			</xsl:when>
			<xsl:when test="$format='ROMAN'">
				<xsl:value-of select="string-to-codepoints($adjustnode) - string-to-codepoints('I')"/>
			</xsl:when>
			<xsl:when test="$format='roman'">
				<xsl:value-of select="string-to-codepoints($adjustnode) - string-to-codepoints('i')"/>
			</xsl:when>
			<xsl:when test="$format='CHINESENUM3'">
				<xsl:value-of select="string-to-codepoints($adjustnode) - string-to-codepoints('一')"/>
			</xsl:when>
			<xsl:when test="$format='CHINESENUM2'">
				<xsl:value-of select="string-to-codepoints($adjustnode) - string-to-codepoints('壹')"/>
			</xsl:when>
			<xsl:when test="$format='ZODIAC1'">
				<xsl:value-of select="string-to-codepoints($adjustnode) - string-to-codepoints('甲')"/>
			</xsl:when>
			<xsl:when test="$format='ZODIAC2'">
				<xsl:value-of select="string-to-codepoints($adjustnode) - string-to-codepoints('子')"/>
			</xsl:when>
			<xsl:when test="$format='GB3'">
				<xsl:value-of select="string-to-codepoints($adjustnode) - string-to-codepoints('①')"/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="OutputPageNumber">
		<xsl:for-each select="./following-sibling::字:域代码_419F[position() = 1]/字:段落_416B/字:句_419D/字:文本串_415B">
			<xsl:variable name="format" select="substring-after(.,' \* ')"/>
			<xsl:variable name="fmt">
				<xsl:call-template name="NumFormat">
					<xsl:with-param name="oo_format" select="$format"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:attribute name="style:num-format"><xsl:value-of select="$fmt"/></xsl:attribute>
			<xsl:attribute name="text:select-page">current</xsl:attribute>
			<!--在style:page-number的基础上累加产生新的首页页码-->
			<xsl:variable name="adjustnode">
				<xsl:value-of select="../../../following-sibling::node()[1][name() = '字:句_419D']/字:文本串_415B"/>
			</xsl:variable>
			<xsl:variable name="adjust">
				<xsl:call-template name="AdjustNumber">
					<xsl:with-param name="format" select="$format"/>
					<xsl:with-param name="adjustnode" select="$adjustnode"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:attribute name="text:page-adjust"><xsl:value-of select="number($adjust)"/></xsl:attribute>
		</xsl:for-each>
	</xsl:template>
	<!--xsl:template name="InMasterPage">
		<xsl:for-each select="..">
			<xsl:choose>
				<xsl:when test="name(.) = '演:母版'">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:when test="name(.) = '演:幻灯片'">
					<xsl:value-of select="'false'"/>
				</xsl:when>
				<xsl:when test="name(.) = '演:主体'">
					<xsl:value-of select="'false'"/>
				</xsl:when>
				<xsl:when test="name(.) = 'uof:UOF_0000'">
					<xsl:value-of select="'false'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="InMasterPage"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template-->
	<xsl:template match="字:域开始_419E">
		<xsl:choose>
			<xsl:when test="@类型_416E='date'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:element name="text:date">
						<xsl:call-template name="DateField"/>
					</xsl:element>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='createdate'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:element name="text:creation-date">
						<xsl:call-template name="DateField"/>
					</xsl:element>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='modificationdate'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:element name="text:modification-date">
						<xsl:call-template name="DateField"/>
					</xsl:element>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='time'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:element name="text:time">
						<xsl:call-template name="TimeField"/>
					</xsl:element>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='createtime'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:element name="text:creation-time">
						<xsl:call-template name="TimeField"/>
					</xsl:element>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='modificationtime'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:element name="text:modification-time">
						<xsl:call-template name="TimeField"/>
					</xsl:element>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='savedate'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="OutputDateField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='edittime'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="EditTime"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='page'">
				<xsl:variable name="IsInMasterPage">
					<xsl:choose>
						<xsl:when test="$document_type = 'presentation'">
							<xsl:choose>
								<xsl:when test="ancestor::图:图形_8062">
									<xsl:variable name="graphid" select="ancestor::图:图形_8062/@标识符_804B"/>
									<xsl:for-each select="key('rel_graphic_name',$graphid)[1]">
										<xsl:choose>
											<xsl:when test="uof:占位符_C626/@类型_C627 = 'number' and ancestor::演:母版_6C0D">
												<!--xsl:call-template name="InMasterPage"/-->
												<xsl:value-of select="'true'"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'false'"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'false'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'false'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$IsInMasterPage != 'true'">
					<text:span>
						<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
						<!--兼容页码功能缺失案例-->
						<xsl:element name="text:span">
							<xsl:if test="following-sibling::字:域代码_419F[1]/following-sibling::字:句_419D/字:句属性_4158/@式样引用_4117 or following-sibling::字:域代码_419F[1]/following-sibling::字:句_419D/字:句属性_4158/*">
								<xsl:for-each select="following-sibling::字:域代码_419F[1]/following-sibling::字:句_419D[1]">
									<xsl:if test="字:句属性_4158 and (字:句属性_4158/@式样引用_4117 or count(字:句属性_4158/child::*))">
										<xsl:variable name="textstylename">
											<xsl:variable name="textstyleref" select="字:句属性_4158/@式样引用_4117"/>
											<xsl:choose>
												<xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@标识符_4100=$textstyleref]">
													<xsl:value-of select="$textstyleref"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="generate-id(字:句属性_4158)"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:attribute name="text:style-name"><xsl:value-of select="$textstylename"/></xsl:attribute>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
							<xsl:variable name="SpecialString">
								<xsl:value-of select="following-sibling::字:域代码_419F[1]/following-sibling::字:句_419D/字:文本串_415B"/>
							</xsl:variable>
							<xsl:call-template name="SpecialStringBefore">
								<xsl:with-param name="SpecialString" select="$SpecialString"/>
							</xsl:call-template>
							<xsl:element name="text:page-number">
								<xsl:call-template name="OutputPageNumber"/>
							</xsl:element>
							<xsl:call-template name="SpecialStringAfter">
								<xsl:with-param name="SpecialString" select="$SpecialString"/>
							</xsl:call-template>
						</xsl:element>
					</text:span>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@类型_416E='numpages'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="PageCountField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='author'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="AuthorField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='username'">		
			</xsl:when>
			<xsl:when test="@类型_416E='userinitials'">		
			</xsl:when>
			<xsl:when test="@类型_416E='title'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="TitleField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='subject'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="SubjectField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='keywords'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="KeywordsField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='comments'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="CommentsField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='revnum'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="RevnumField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='filename'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="FilenameField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='SEQ'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="CaptionField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="contains(@类型_416E,'placeholder')">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="PlaceholderField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='dropdown'">		
			</xsl:when>
			<xsl:when test="@类型_416E='REF'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="TableOfContentsField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='INDEX'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="AlphabeticalIndexField"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='creation-time'">
				<text:span>
					<xsl:attribute name="text:style-name" select="following-sibling::字:域代码_419F[1]/字:段落_416B/字:句_419D/字:句属性_4158/@式样引用_4117"/>
					<xsl:call-template name="CreationTime"/>
				</text:span>
			</xsl:when>
			<xsl:when test="@类型_416E='numchars'">
				<xsl:call-template name="CharCount"/>
			</xsl:when>
			<xsl:when test="@类型_416E='pageinsection'">
				<xsl:call-template name="PageinSection"/>
			</xsl:when>
			<xsl:when test="@类型_416E='section'">
				<xsl:call-template name="SectionField"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="字:域代码_419F">
	</xsl:template>
	<xsl:template match="字:域结束">
	</xsl:template>-->
	<xsl:template name="SpecialStringBefore">
		<xsl:param name="SpecialString"/>
		<xsl:choose>
			<xsl:when test="contains($SpecialString,'I。')">I。</xsl:when>
			<xsl:when test="contains($SpecialString,'A—')">A—</xsl:when>
			<xsl:when test="contains($SpecialString,'1-')">1-</xsl:when>
			<xsl:when test="contains($SpecialString,'1：')">1：</xsl:when>
			<xsl:when test="contains($SpecialString,'一-')">一-</xsl:when>
			<xsl:when test="contains($SpecialString,'(1)')">(</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="SpecialStringAfter">
		<xsl:param name="SpecialString"/>
		<xsl:choose>
			<xsl:when test="contains($SpecialString,'1.')">.</xsl:when>
			<xsl:when test="contains($SpecialString,'(1)')">)</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="TextParaToTextProperties">
		<xsl:param name="Stylename"/>
		<xsl:for-each select="key('uof-paragraph-styles',$Stylename)">
			<xsl:if test="@基式样引用_4104">
				<xsl:call-template name="TextParaToTextProperties">
					<xsl:with-param name="Stylename" select="@基式样引用_4104"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:for-each select="./字:句属性_4158">
				<xsl:call-template name="TextProperties"/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="SpecialHolderTextStyleContent">
		<xsl:for-each select="../..">
			<xsl:if test="name(.) = '字:段落_416B'">
				<xsl:variable name="stylename">
					<xsl:choose>
						<xsl:when test="(count(./字:段落属性_419B/child::*) = 1) and not(./字:段落属性_419B/字:自动编号信息_4186)">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:when>
						<xsl:when test="count(./字:段落属性_419B/child::*) &gt; 1">
							<xsl:value-of select="generate-id(.)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="./字:段落属性_419B/@式样引用_419C">
									<xsl:value-of select="./字:段落属性_419B/@式样引用_419C"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="none"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$stylename != 'none'">
					<xsl:attribute name="style:parent-style-name"><xsl:value-of select="$stylename"/></xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="..">
			<xsl:if test="name(.) = '字:句_419D'">
				<xsl:element name="style:text-properties">
					<xsl:if test="../字:段落属性_419B/@式样引用_419C">
						<xsl:call-template name="TextParaToTextProperties">
							<xsl:with-param name="Stylename" select="../字:段落属性_419B/@式样引用_419C"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="../字:段落属性_419B/字:句属性_4158">
						<xsl:call-template name="TextProperties"/>
					</xsl:if>
					<xsl:if test="字:句属性_4158/@式样引用_417B">
						<xsl:call-template name="TextParentProperties">
							<xsl:with-param name="Stylename" select="字:句属性_4158/@式样引用_417B"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:for-each select="字:句属性_4158">
						<xsl:call-template name="TextProperties"/>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="SearchSpecialHolder">
		<xsl:param name="anchorname"/>
		<xsl:choose>
			<xsl:when test="$anchorname = 'date' and contains(.,'&lt;日期/时间&gt;')">
				<xsl:call-template name="SpecialHolderTextStyleContent"/>
			</xsl:when>
			<xsl:when test="$anchorname = 'header' and contains(.,'&lt;页眉&gt;')">
				<xsl:call-template name="SpecialHolderTextStyleContent"/>
			</xsl:when>
			<xsl:when test="$anchorname = 'footer' and contains(.,'&lt;页脚&gt;')">
				<xsl:call-template name="SpecialHolderTextStyleContent"/>
			</xsl:when>
			<xsl:when test="$anchorname = 'number' and contains(.,'&lt;#&gt;')">
				<xsl:call-template name="SpecialHolderTextStyleContent"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="following-sibling::*[name(.) = '字:文本串_415B'][1]">
						<xsl:for-each select="following-sibling::*[name(.) = '字:文本串_415B'][1]">
							<xsl:call-template name="SearchSpecialHolder">
								<xsl:with-param name="anchorname" select="$anchorname"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="..">
							<xsl:choose>
								<xsl:when test="following-sibling::*[name(.) = '字:句_419D'][1]/字:文本串_415B[1]">
									<xsl:for-each select="following-sibling::*[name(.) = '字:句_419D'][1]/字:文本串_415B[1]">
										<xsl:call-template name="SearchSpecialHolder">
											<xsl:with-param name="anchorname" select="$anchorname"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="SpecialHolderTextStyleContent"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="SpecialHolderTextStyle">
		<xsl:for-each select="/uof:UOF_0000/演:演示文稿文档_C610/演:母版集_C60C/演:母版_6C0D/uof:锚点_C644[uof:占位符_C626/@类型_C627='date' or uof:占位符_C626/@类型_C627='footer' or  uof:占位符_C626/@类型_C627='header' or uof:占位符_C626/@类型_C627='number']">
			<xsl:variable name="anchorname" select="uof:占位符_C626/@类型_C627"/>
			<xsl:element name="style:style">
				<xsl:attribute name="style:family">paragraph</xsl:attribute>
				<xsl:attribute name="style:name"><xsl:value-of select="concat(generate-id(), '-special')"/></xsl:attribute>
				<xsl:variable name="picname">
					<xsl:value-of select="@图形引用_C62E"/>
				</xsl:variable>
				<xsl:for-each select="key('graph-styles', $picname)">
					<xsl:for-each select="图:文本_803C/图:内容_8043/字:段落_416B/字:句_419D[1]/字:文本串_415B[1]">
						<xsl:call-template name="SearchSpecialHolder">
							<xsl:with-param name="anchorname" select="$anchorname"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="DrawTransform">
		<xsl:param name="angle"/>
		<xsl:variable name="GraphicID">
			<xsl:value-of select="@图形引用_C62E"/>
		</xsl:variable>
		<xsl:variable name="x_without_rotate">
			<xsl:choose>
				<xsl:when test="uof:位置_C620/@类型_C646 = 'as-char'">
					<xsl:value-of select="number(0)"/>
				</xsl:when>
				<xsl:when test="uof:位置_C620/uof:水平_4106/uof:绝对_4107">
					<xsl:value-of select="uof:位置_C620/uof:水平_4106/uof:绝对_4107/@值_4108"/>
				</xsl:when>
				<xsl:when test="uof:位置_C620/uof:水平_4106/uof:相对_4109/@值_410B">
					<xsl:value-of select="uof:位置_C620/uof:水平_4106/uof:相对_4109/@值_410B"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="y_without_rotate">
			<xsl:choose>
				<xsl:when test="uof:位置_C620/@类型_C646 = 'as-char'">
					<xsl:value-of select="number(0)"/>
				</xsl:when>
				<!--xsl:when test="uof:位置_C620/uof:垂直_410D/@相对于_410C = 'line'">
					<xsl:value-of select="0 - number(uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108)"/>
				</xsl:when-->
				<xsl:when test="uof:位置_C620/uof:垂直_410D/uof:绝对_4107">
					<xsl:value-of select="uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108"/>
				</xsl:when>
				<xsl:when test="uof:位置_C620/uof:垂直_410D/uof:相对_4109/@值_410B">
					<xsl:value-of select="uof:位置_C620/uof:垂直_410D/uof:相对_4109/@值_410B"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="x0">
			<xsl:variable name="box_width">
				<xsl:value-of select="uof:大小_C621/@宽_C605"/>
			</xsl:variable>
			<xsl:value-of select="number($x_without_rotate) + number(number($box_width) div 2)"/>
		</xsl:variable>
		<xsl:variable name="y0">
			<xsl:variable name="box_high">
				<xsl:value-of select="uof:大小_C621/@长_C604"/>
			</xsl:variable>
			<xsl:value-of select="number($y_without_rotate) + (number($box_high) div 2)"/>
		</xsl:variable>
		<xsl:variable name="arc">
			<xsl:value-of select="$angle * 0.0174532925"/>
		</xsl:variable>
		<xsl:variable name="sin_x">
			<xsl:call-template name="sin">
				<xsl:with-param name="arc">
					<!--xsl:value-of select="0 - $arc"/-->
					<xsl:value-of select="$arc"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="cos_x">
			<xsl:call-template name="cos">
				<xsl:with-param name="arc">
					<xsl:value-of select="$arc"/>
					<!--xsl:value-of select="0 - $arc"/-->
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="x">
			<xsl:value-of select="($x_without_rotate - $x0) * $cos_x - ($y0 - $y_without_rotate) * $sin_x + $x0"/>
		</xsl:variable>
		<xsl:variable name="y">
			<xsl:value-of select="$y0 - ($y0 - $y_without_rotate) * $cos_x - ($x_without_rotate - $x0) * $sin_x"/>
		</xsl:variable>
		<xsl:attribute name="draw:transform"><xsl:value-of select="concat('rotate (',$arc,') translate (', $x, $uofUnit, ' ', $y, $uofUnit, ')')"/></xsl:attribute>
		<!--xsl:attribute name="draw:transform"><xsl:value-of select="concat('rotate (',0 - $arc,') translate (', $x, $uofUnit, ' ', $y, $uofUnit, ')')"/></xsl:attribute-->
	</xsl:template>
	<xsl:template name="DrawCommAttr">
		<xsl:param name="picstyle"/>
		<xsl:variable name="angle">
			<xsl:choose>
				<xsl:when test="$picstyle/图:预定义图形_8018/图:属性_801D/图:旋转角度_804D and not($picstyle/图:预定义图形_8018/图:属性_801D/图:旋转角度_804D='0.0')">
					<xsl:value-of select="$picstyle/图:预定义图形_8018/图:属性_801D/图:旋转角度_804D"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="0"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$picstyle/@层次_8063">
			<xsl:attribute name="draw:z-index"><xsl:value-of select="$picstyle[1]/@层次_8063"/></xsl:attribute>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="not($picstyle/图:组合位置_803B)">
				<xsl:if test="$angle=0">
					<xsl:variable name="posx">
						<xsl:choose>
							<xsl:when test="uof:位置_C620/@类型_C646 = 'as-char'">
								<xsl:value-of select="number(0)"/>
							</xsl:when>
							<xsl:when test="uof:位置_C620/uof:水平_4106/uof:绝对_4107/@值_4108">
								<xsl:value-of select="number(uof:位置_C620/uof:水平_4106/uof:绝对_4107/@值_4108)"/>
							</xsl:when>
							<xsl:when test="uof:位置_C620/uof:水平_4106/uof:相对_4109/@值_410B">
								<xsl:value-of select="number(uof:位置_C620/uof:水平_4106/uof:相对_4109/@值_410B)"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="posy">
						<xsl:choose>
							<xsl:when test="uof:位置_C620/@类型_C646 = 'as-char'">
								<xsl:value-of select="number(0)"/>
							</xsl:when>
							<!--xsl:when test="uof:位置_C620/uof:垂直_410D/@相对于_410C = 'line'">
								<xsl:value-of select="0 - number(uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108)"/>
							</xsl:when-->
							<xsl:when test="uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108">
								<xsl:value-of select="number(uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108)"/>
							</xsl:when>
							<xsl:when test="uof:位置_C620/uof:垂直_410D/uof:相对_4109/@值_410B">
								<xsl:value-of select="number(uof:位置_C620/uof:垂直_410D/uof:相对_4109/@值_410B)"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="svg:x"><xsl:value-of select="concat($posx,$uofUnit)"/></xsl:attribute>
					<xsl:attribute name="svg:y"><xsl:value-of select="concat($posy,$uofUnit)"/></xsl:attribute>
				</xsl:if>
				<xsl:variable name="width">
					<xsl:value-of select="number(uof:大小_C621/@宽_C605)"/>
				</xsl:variable>
				<xsl:variable name="height">
					<xsl:value-of select="number(uof:大小_C621/@长_C604)"/>
				</xsl:variable>
				<xsl:attribute name="svg:width"><xsl:value-of select="concat($width,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:height"><xsl:value-of select="concat($height,$uofUnit)"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="zuheweizhi-x">
					<xsl:value-of select="$picstyle/图:组合位置_803B/@x_C606"/>
				</xsl:variable>
				<xsl:variable name="zuheweizhi-y">
					<xsl:value-of select="$picstyle/图:组合位置_803B/@y_C607"/>
				</xsl:variable>
				<xsl:variable name="hex">
					<xsl:value-of select="concat(0+number($zuheweizhi-x),$uofUnit)"/>
				</xsl:variable>
				<xsl:variable name="hey">
					<xsl:value-of select="concat(0+number($zuheweizhi-y),$uofUnit)"/>
				</xsl:variable>
				<xsl:variable name="width">
					<xsl:value-of select="number($picstyle/图:预定义图形_8018/图:属性_801D/图:大小_8060/@宽_C605)"/>
				</xsl:variable>
				<xsl:variable name="height">
					<xsl:value-of select="number($picstyle/图:预定义图形_8018/图:属性_801D/图:大小_8060/@长_C604)"/>
				</xsl:variable>
				<xsl:attribute name="svg:x"><xsl:value-of select="$hex"/></xsl:attribute>
				<xsl:attribute name="svg:y"><xsl:value-of select="$hey"/></xsl:attribute>
				<xsl:attribute name="svg:width"><xsl:value-of select="concat($width,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:height"><xsl:value-of select="concat($height,$uofUnit)"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$document_type = 'text'">
			<xsl:attribute name="text:anchor-type"><xsl:choose><xsl:when test="uof:位置_C620/@类型_C646='page'">page</xsl:when><xsl:when test="uof:位置_C620/@类型_C646='paragraph'">paragraph</xsl:when><xsl:when test="uof:位置_C620/@类型_C646='char'">char</xsl:when><xsl:when test="uof:位置_C620/@类型_C646='as-char'">as-char</xsl:when><xsl:when test="uof:位置_C620/@类型_C646='frame'">frame</xsl:when><xsl:otherwise>char</xsl:otherwise></xsl:choose></xsl:attribute>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="uof:占位符_C626/@类型_C627 != ''">
				<xsl:attribute name="presentation:style-name"><xsl:choose><xsl:when test="name(..)='演:母版_6C0D' and uof:占位符_C626/@类型_C627 = 'title'"><xsl:value-of select="concat(string(../@标识符_6BE8),'-title')"/></xsl:when><xsl:when test="name(..)='演:母版_6C0D' and (uof:占位符_C626/@类型_C627 = 'outline' or uof:占位符_C626/@类型_C627 = 'text')"><xsl:value-of select="concat(string(../@标识符_6BE8),'-outline1')"/></xsl:when><xsl:otherwise><xsl:value-of select="$picstyle[1]/@标识符_804B"/></xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:variable name="placeChar">
					<xsl:choose>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'clipart'">graphic</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'media_clip'">graphic</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'graphics'">graphic</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'number'">page-number</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'centertitle'">title</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'date'">date-time</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'vertical_text'">outline</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'vertical_title'">title</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'vertical_subtitle'">subtitle</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'title'">
							<xsl:choose>
								<xsl:when test="../uof:锚点_C644[uof:占位符_C626/@类型_C627='centertitle']">subtitle</xsl:when>
								<xsl:otherwise>title</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'text'">
							<xsl:choose>
								<xsl:when test="parent::演:幻灯片_6C0F or parent::演:母版_6C0D">outline</xsl:when>
								<xsl:otherwise>subtitle</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="uof:占位符_C626/@类型_C627"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="presentation:class"><xsl:value-of select="$placeChar"/></xsl:attribute>
				<xsl:if test="(name(..) = '演:母版_6C0D') and (($placeChar = 'header') or ($placeChar = 'footer') or ($placeChar = 'date-time') or ($placeChar = 'page-number'))">
					<xsl:attribute name="draw:text-style-name" select="concat(generate-id(), '-special')"/>
				</xsl:if>
				<!--
				<xsl:if test="not((name(..) = '演:母版') and (uof:占位符_C626 = 'title'))">
					<xsl:attribute name="presentation:user-transformed" select="'true'"/>
				</xsl:if>
				-->
				<xsl:choose>
					<xsl:when test="not((name(..) = '演:母版_6C0D') and (uof:占位符_C626/@类型_C627 = 'title'))">
						<xsl:attribute name="presentation:user-transformed" select="'false'"/>
					</xsl:when>
					<xsl:when test="(name(..) = '演:母版_6C0D') and (uof:占位符_C626/@类型_C627 = 'title')">
						<!--xsl:if test="following-sibling::node()[@uof:占位符 = 'text']">
							<xsl:variable name="IsEmptyText">
								<xsl:for-each select="following-sibling::node()[(uof:占位符_C626 = 'text')]">
									<xsl:variable name="picname">
										<xsl:value-of select="@uof:图形引用"/>
									</xsl:variable>
									<xsl:variable name="picstyle" select="key('graph-styles', $picname)"/>
									<xsl:for-each select="$picstyle/图:文本内容/字:段落_416B[1]">
										<xsl:variable name="nCount1" select="count(字:域开始)"/>
										<xsl:variable name="nCount2" select="count(字:域代码)"/>
										<xsl:variable name="nCount3" select="count(字:域结束)"/>
										<xsl:variable name="nCount4" select="count(字:修订开始)"/>
										<xsl:variable name="nCount5" select="count(字:修订结束)"/>
										<xsl:if test="($nCount1 = 0) and ($nCount2 = 0) and ($nCount3 = 0) and ($nCount4 = 0) and ($nCount5 = 0)">
											<xsl:choose>
												<xsl:when test="count(字:句_419D) = 0">
													<xsl:value-of select="'true'"/>
												</xsl:when>
												<xsl:otherwise>
													<!-hsr ??在变量定义中应用模板是无效的吧??->
													<xsl:apply-templates select="字:句_419D[1]" mode="IsEmpty"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</xsl:for-each>
								</xsl:for-each>
							</xsl:variable>
							<xsl:if test="$IsEmptyText != 'true'">
								<xsl:attribute name="presentation:user-transformed" select="'true'"/>
							</xsl:if>
						</xsl:if>
						<xsl:if test="following-sibling::node()[uof:占位符_C626 = 'outline']">
							<xsl:variable name="IsEmptyOutline">
								<xsl:for-each select="following-sibling::node()[(uof:占位符_C626 = 'outline')]">
									<xsl:variable name="picname">
										<xsl:value-of select="@uof:图形引用"/>
									</xsl:variable>
									<xsl:variable name="picstyle" select="key('graph-styles', $picname)"/>
									<xsl:for-each select="$picstyle/图:文本内容">
										<xsl:variable name="nCount1" select="count(字:段落_416B[1]/字:域开始)"/>
										<xsl:variable name="nCount2" select="count(字:段落_416B[1]/字:域代码)"/>
										<xsl:variable name="nCount3" select="count(字:段落_416B[1]/字:域结束)"/>
										<xsl:variable name="nCount4" select="count(字:段落_416B[1]/字:修订开始)"/>
										<xsl:variable name="nCount5" select="count(字:段落_416B[1]/字:修订结束)"/>
										<xsl:choose>
											<xsl:when test="($nCount1 = 0) and ($nCount2 = 0) and ($nCount3 = 0) and ($nCount4 = 0) and ($nCount5 = 0) and count(字:段落_416B/字:句_419D) = 0">
												<xsl:value-of select="'true'"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates select="字:段落/字:句[1]" mode="IsEmpty"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</xsl:for-each>
							</xsl:variable>
							<xsl:if test="$IsEmptyOutline != 'true'">
								<xsl:attribute name="presentation:user-transformed" select="'true'"/>
							</xsl:if>
						</xsl:if-->
						<xsl:for-each select="following-sibling::*">
							<xsl:if test="uof:占位符_C626/@类型_C627 = 'text' or uof:占位符_C626/@类型_C627 = 'outline'">
								<xsl:variable name="picname">
									<xsl:value-of select="@图形引用_C62E"/>
								</xsl:variable>
								<xsl:variable name="picstyle" select="key('graph-styles', $picname)"/>
								<xsl:for-each select="$picstyle/图:文本_803C/图:内容_8043">
									<xsl:variable name="nCount1" select="count(字:段落_416B[1]/字:域开始_419E)"/>
									<xsl:variable name="nCount2" select="count(字:段落_416B[1]/字:域代码_419F)"/>
									<xsl:variable name="nCount3" select="count(字:段落_416B[1]/字:域结束_41A0)"/>
									<xsl:variable name="nCount4" select="count(字:段落_416B[1]/字:修订开始_421F)"/>
									<xsl:variable name="nCount5" select="count(字:段落_416B[1]/字:修订结束_4223)"/>
									<xsl:if test="not(($nCount1 = 0) and ($nCount2 = 0) and ($nCount3 = 0) and ($nCount4 = 0) and ($nCount5 = 0) and count(字:段落_416B/字:句_419D) = 0)">
										<xsl:attribute name="presentation:user-transformed" select="'false'"/>
										<xsl:apply-templates select="字:段落_416B/字:句_419D[1]" mode="IsEmpty"/>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="name(..) = '演:幻灯片_6C0F'and not(uof:占位符_C626/@类型_C627 = 'chart' or uof:占位符_C626/@类型_C627 = 'clipart' or uof:占位符_C626/@类型_C627 = 'media_clip' or uof:占位符_C626/@类型_C627= 'graphics') ">
					<xsl:attribute name="presentation:placeholder" select="'true'"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$picstyle/@标识符_804B">
						<xsl:attribute name="draw:style-name"><xsl:value-of select="$picstyle[1]/@标识符_804B"/></xsl:attribute>
						<xsl:attribute name="draw:id"><xsl:value-of select="$picstyle[1]/@标识符_804B"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="$picstyle/@标识符_804B">
						<xsl:attribute name="draw:style-name"><xsl:value-of select="$picstyle[1]/@标识符_804B"/></xsl:attribute>
						<xsl:attribute name="draw:id"><xsl:value-of select="$picstyle[1]/@标识符_804B"/></xsl:attribute>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="not($angle=0)">
			<xsl:call-template name="DrawTransform">
				<xsl:with-param name="angle" select="$picstyle/图:预定义图形_8018/图:属性_801D/图:旋转角度_804D"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:variable name="tuxing">
			<xsl:value-of select="@图形引用_C62E"/>
		</xsl:variable>
		<xsl:if test="../演:动画_6B1A/演:序列_6B1B[@对象引用_6C28 = $tuxing]">
			
			<xsl:attribute name="draw:id"><xsl:value-of select="$tuxing"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="DrawCommElementWeb">
		<xsl:param name="picstyle"/>
		<xsl:if test="$picstyle/图:预定义图形_8018/图:属性_801D/图:Web文字_804F">
			<xsl:element name="svg:title">
				<xsl:value-of select="$picstyle/图:预定义图形_8018/图:属性_801D/图:Web文字_804F"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="DrawCommElementText">
		<xsl:param name="picstyle"/>
		<xsl:if test="$picstyle/图:文本_803C/图:内容_8043">
			<!-- whether empty title of marster -->
			<xsl:variable name="IsEmptyTitle">
				<xsl:if test="(name(..) = '演:母版_6C0D') and (uof:占位符_C626/@类型_C627 = 'title')">
					<xsl:for-each select="$picstyle/图:文本_803C/图:内容_8043">
						<xsl:variable name="nCount1" select="count(字:段落_416B[1]/字:域开始_419E)"/>
						<xsl:variable name="nCount2" select="count(字:段落_416B[1]/字:域代码_419F)"/>
						<xsl:variable name="nCount3" select="count(字:段落_416B[1]/字:域结束_41A0)"/>
						<xsl:variable name="nCount4" select="count(字:段落_416B[1]/字:修订开始_421F)"/>
						<xsl:variable name="nCount5" select="count(字:段落_416B[1]/字:修订结束_4223)"/>
						<!--xsl:choose>
							<xsl:when test="count(字:段落[1]/字:句)!=0 and ($nCount1 = 0) and ($nCount2 = 0) and ($nCount3 = 0) and ($nCount4 = 0) and ($nCount5 = 0)">
								<xsl:apply-templates select="字:段落[1]/字:句[1]" mode="IsEmpty"/>
							</xsl:when>
							<xsl:otherwise>true</xsl:otherwise>
						</xsl:choose-->
						<xsl:if test="not(count(字:段落_416B[1]/字:句_419D)!=0 and ($nCount1 = 0) and ($nCount2 = 0) and ($nCount3 = 0) and ($nCount4 = 0) and ($nCount5 = 0))">true</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:variable>
			<xsl:choose>
				<!-- give a prompt message for marster's empty title -->
				<xsl:when test="$IsEmptyTitle = 'true'">
					<text:p>单击鼠标编辑标题文的格式</text:p>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$picstyle/图:文本_803C/图:内容_8043/*">
						<xsl:choose>
							<xsl:when test="name(.)='字:段落_416B'">
								<xsl:apply-templates select="."/>
							</xsl:when>
							<xsl:when test="name(.)='字:文字表_416C'">
								<xsl:apply-templates select="."/>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="DrawCommElement">
		<xsl:param name="picstyle"/>
		<xsl:call-template name="DrawCommElementWeb">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
		<xsl:call-template name="DrawCommElementText">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="DrawCommContent">
		<xsl:param name="picstyle"/>
		<xsl:call-template name="DrawCommAttr">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
		<xsl:call-template name="DrawCommElement">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="DrawPoints">
		<xsl:param name="points"/>
		<xsl:param name="value"/>
		<xsl:if test="$points">
			<xsl:variable name="frist-piont">
				<xsl:value-of select="substring-before($points,'lineto')"/>
			</xsl:variable>
			<xsl:variable name="other-points">
				<xsl:value-of select="substring-after($points,'lineto')"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="contains($other-points,'lineto')">
					<xsl:variable name="x-coor">
						<xsl:value-of select="number(substring-before($frist-piont,' ')) * 1000"/>
					</xsl:variable>
					<xsl:variable name="y-coor">
						<xsl:value-of select="number(substring-after($frist-piont,' ')) * 1000"/>
					</xsl:variable>
					<xsl:call-template name="DrawPoints">
						<xsl:with-param name="points" select="$other-points"/>
						<xsl:with-param name="value" select="concat($value,$x-coor,',',$y-coor,' ')"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="q-x-coor">
						<xsl:value-of select="number(substring-before($frist-piont,' ')) * 1000"/>
					</xsl:variable>
					<xsl:variable name="q-y-coor">
						<xsl:value-of select="number(substring-after($frist-piont,' ')) * 1000"/>
					</xsl:variable>
					<xsl:variable name="e-x-coor">
						<xsl:value-of select="number(substring-before($other-points,' ')) * 1000"/>
					</xsl:variable>
					<xsl:variable name="e-y-coor">
						<xsl:value-of select="number(substring-after($other-points,' ')) * 1000"/>
					</xsl:variable>
					<xsl:value-of select="concat($value,$q-x-coor,',',$q-y-coor,' ',$e-x-coor,',',$e-y-coor)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="DrawPathContent">
		<xsl:param name="picstyle"/>
		<xsl:call-template name="DrawCommAttr">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
		<xsl:variable name="width" select="number($picstyle/图:预定义图形_8018/图:属性_801D/图:大小_8060/@宽_C605)*1000"/>
		<xsl:variable name="height" select="number($picstyle/图:预定义图形_8018/图:属性_801D/图:大小_8060/@长_C604)*1000"/>
		<xsl:attribute name="svg:viewBox"><xsl:value-of select="concat('0 0 ',$width, ' ',$height)"/></xsl:attribute>
		<xsl:attribute name="draw:points"><xsl:call-template name="DrawPoints"><xsl:with-param name="points" select="$picstyle/图:预定义图形_8018/图:路径_801C"/><xsl:with-param name="value"/></xsl:call-template></xsl:attribute>
		<xsl:call-template name="DrawCommElement">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="DrawSpecialGeometry">
		<xsl:param name="GraphicID"/>
		<xsl:choose>
			<xsl:when test="$GraphicID='122'">
				<xsl:attribute name="svg:viewBox">0 0 640 861</xsl:attribute>
				<xsl:attribute name="draw:text-areas">257 295 414 566</xsl:attribute>
				<xsl:attribute name="draw:type">non-primitive</xsl:attribute>
				<xsl:attribute name="draw:enhanced-path">M 640 233 L 221 293 506 12 367 0 29 406 431 347 145 645 99 520 0 861 326 765 209 711 640 233 640 233 Z N</xsl:attribute>
			</xsl:when>
			<xsl:when test="$GraphicID='217'">
				<xsl:attribute name="draw:text-areas">4000 ?f1 ?f5 ?f2</xsl:attribute>
				<xsl:attribute name="draw:glue-points">0 10800 21600 10800 ?f0 0 ?f0 21600</xsl:attribute>
				<xsl:attribute name="draw:type">mso-spt100</xsl:attribute>
				<xsl:attribute name="draw:modifiers">13200 6400 0</xsl:attribute>
				<xsl:attribute name="draw:enhanced-path">M ?f0 0 L 21600 10800 ?f0 21800 ?f0 ?f2 4000 ?f2 4000 ?f1 ?f0 ?f1 ?f0 0 M 0 ?f1 L 0 ?f2 1000 ?f2 1000 ?f1 0 ?f1 M 2000 ?f1 L 2000 ?f2 3000 ?f2 3000 ?f1 2000 ?f1 Z N</xsl:attribute>
				<draw:equation draw:name="f0" draw:formula="$0 "/>
				<draw:equation draw:name="f1" draw:formula="$1 "/>
				<draw:equation draw:name="f2" draw:formula="bottom-$1 "/>
				<draw:equation draw:name="f3" draw:formula="right-$0 "/>
				<draw:equation draw:name="f4" draw:formula="?f3 *$1 /10800"/>
				<draw:equation draw:name="f5" draw:formula="$0 +?f4 "/>
				<draw:handle draw:handle-position="$0 $1" draw:handle-range-x-minimum="4000" draw:handle-range-x-maximum="21600" draw:handle-range-y-minimum="0" draw:handle-range-y-maximum="10800"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="DrawCustomContent">
		<xsl:param name="picstyle"/>
		<xsl:param name="graphtype"/>
		<xsl:variable name="customtype">
			<xsl:call-template name="CustomShapeType">
				<xsl:with-param name="GraphicID" select="$graphtype[1]"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="graphicreferences">
			<xsl:value-of select="@图形引用_C62E"/>
		</xsl:variable>
		<xsl:call-template name="DrawCommAttr">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
		<draw:enhanced-geometry>
			<xsl:choose>
				<xsl:when test="$picstyle/图:翻转_803A = 'y'">
					<xsl:attribute name="draw:mirror-vertical">true</xsl:attribute>
				</xsl:when>
				<xsl:when test="$picstyle/图:翻转_803A = 'x'">
					<xsl:attribute name="draw:mirror-horizontal">true</xsl:attribute>
				</xsl:when>
				<xsl:when test="$picstyle/图:翻转_803A = 'xy'">
					<xsl:attribute name="draw:mirror-horizontal">true</xsl:attribute>
					<xsl:attribute name="draw:mirror-vertical">true</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="$picstyle/图:控制点_8039/@x_C606 != ' ' or $picstyle/图:控制点_8039/@y_C607 != ' '">
				<xsl:variable name="modifiers-x">
					<xsl:value-of select="$picstyle/图:控制点_8039/@x_C606"/>
				</xsl:variable>
				<xsl:variable name="modifiers-y">
					<xsl:value-of select="$picstyle/图:控制点_8039/@y_C607"/>
				</xsl:variable>
				<xsl:attribute name="draw:modifiers"><xsl:value-of select="concat($modifiers-x,' ',$modifiers-y)"/></xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$customtype!=''">
					<xsl:attribute name="draw:type"><xsl:value-of select="$customtype"/></xsl:attribute>
					<xsl:call-template name="DrawSpecialGeometry">
						<xsl:with-param name="GraphicID" select="$graphtype"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="key('graphicsextension',$graphicreferences)">
					<xsl:for-each select="key('graphicsextension',$graphicreferences)/扩展:扩展内容_B204/扩展:内容_B206/扩展:预定义图形数据">
						<xsl:copy-of select="@*|node()"/>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</draw:enhanced-geometry>
		<xsl:call-template name="DrawCommElement">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="DrawLineAttr">
		<xsl:param name="picstyle"/>
		<xsl:param name="isconnector"/>
		<xsl:variable name="angle">
			<xsl:choose>
				<xsl:when test="$picstyle/图:预定义图形_8018/图:属性_801D/图:旋转角度_804D and not($picstyle/图:预定义图形_8018/图:属性_801D/图:旋转角度_804D='0.0')">
					<xsl:value-of select="$picstyle/图:预定义图形_8018/图:属性_801D/图:旋转角度_804D"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="0"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="not($picstyle/图:组合位置_803B)">
				<xsl:variable name="posx">
					<xsl:choose>
						<xsl:when test="uof:位置_C620/@类型_C646 = 'as-char'">
							<xsl:value-of select="number(0)"/>
						</xsl:when>
						<xsl:when test="uof:位置_C620/uof:水平_4106/uof:绝对_4107/@值_4108">
							<xsl:value-of select="number(uof:位置_C620/uof:水平_4106/uof:绝对_4107/@值_4108)"/>
						</xsl:when>
						<xsl:when test="uof:位置_C620/uof:水平_4106/uof:相对_4109">
							<xsl:value-of select="number(uof:位置_C620/uof:水平_4106/uof:相对_4109/@值_410B)"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="posy">
					<xsl:choose>
						<xsl:when test="uof:位置_C620/@类型_C646 = 'as-char'">
							<xsl:value-of select="number(0)"/>
						</xsl:when>
						<xsl:when test="uof:位置_C620/uof:垂直_410D/@相对于_410C = 'line'">
							<xsl:value-of select="0 - number(uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108)"/>
						</xsl:when>
						<xsl:when test="uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108">
							<xsl:value-of select="number(uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108)"/>
						</xsl:when>
						<xsl:when test="uof:位置_C620/uof:垂直_410D/uof:相对_4109">
							<xsl:value-of select="number(字:位置_C620/uof:垂直_410D/uof:相对_4109/@值_410B)"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="width" select="number(uof:大小_C621/@宽_C605)"/>
				<xsl:variable name="height" select="number(uof:大小_C621/@长_C604)"/>
				<xsl:choose>
					<xsl:when test="$picstyle/图:翻转_803A = 'x'">
						<xsl:variable name="x1" select="number($posx) + number($width)"/>
						<xsl:variable name="y1" select="number($posy)"/>
						<xsl:variable name="x2" select="$posx"/>
						<xsl:variable name="y2" select="number($posy) + number($height)"/>
						<xsl:attribute name="svg:x1"><xsl:value-of select="concat($x1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y1"><xsl:value-of select="concat($y1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:x2"><xsl:value-of select="concat($x2,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y2"><xsl:value-of select="concat($y2,$uofUnit)"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="$picstyle/图:翻转_803A = 'y'">
						<xsl:variable name="x1" select="number($posx)"/>
						<xsl:variable name="y1" select="number($posy) + number($height)"/>
						<xsl:variable name="x2" select="number($posx) + number($width)"/>
						<xsl:variable name="y2" select="$posy"/>
						<xsl:attribute name="svg:x1"><xsl:value-of select="concat(string($x1),$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y1"><xsl:value-of select="concat(string($y1),$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:x2"><xsl:value-of select="concat(string($x2),$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y2"><xsl:value-of select="concat(string($y2),$uofUnit)"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="$picstyle/图:翻转_803A = 'xy'">
						<xsl:variable name="x1" select="$posx + $width"/>
						<xsl:variable name="y1" select="$posy + $height"/>
						<xsl:variable name="x2" select="$posx"/>
						<xsl:variable name="y2" select="$posy"/>
						<xsl:attribute name="svg:x1"><xsl:value-of select="concat($x1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y1"><xsl:value-of select="concat($y1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:x2"><xsl:value-of select="concat($x2,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y2"><xsl:value-of select="concat($y2,$uofUnit)"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="x1" select="$posx"/>
						<xsl:variable name="y1" select="$posy"/>
						<xsl:variable name="x2" select="number($posx) + number($width)"/>
						<xsl:variable name="y2" select="number($posy) + number($height)"/>
						<xsl:attribute name="svg:x1"><xsl:value-of select="concat($x1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y1"><xsl:value-of select="concat($y1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:x2"><xsl:value-of select="concat($x2,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y2"><xsl:value-of select="concat($y2,$uofUnit)"/></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="posx" select="number($picstyle/图:组合位置_803B/@x_C606)"/>
				<xsl:variable name="posy" select="number($picstyle/图:组合位置_803B/@y_C607)"/>
				<xsl:variable name="width" select="number($picstyle/图:预定义图形_8018/图:属性_801D/图:大小_8060/@宽_C605)"/>
				<xsl:variable name="height" select="number($picstyle/图:预定义图形_8018/图:属性_801D/图:大小_8060/@长_C604)"/>
				<xsl:choose>
					<xsl:when test="$picstyle/图:翻转_803A = 'x'">
						<xsl:variable name="x1" select="$posx + $width"/>
						<xsl:variable name="y1" select="$posy"/>
						<xsl:variable name="x2" select="$posx"/>
						<xsl:variable name="y2" select="$posy + $height"/>
						<xsl:attribute name="svg:x1"><xsl:value-of select="concat($x1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y1"><xsl:value-of select="concat($y1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:x2"><xsl:value-of select="concat($x2,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y2"><xsl:value-of select="concat($y2,$uofUnit)"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="$picstyle/图:翻转_803A = 'y'">
						<xsl:variable name="x1" select="$posx"/>
						<xsl:variable name="y1" select="$posy + $height"/>
						<xsl:variable name="x2" select="$posx + $width"/>
						<xsl:variable name="y2" select="$posy"/>
						<xsl:attribute name="svg:x1"><xsl:value-of select="concat($x1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y1"><xsl:value-of select="concat($y1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:x2"><xsl:value-of select="concat($x2,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y2"><xsl:value-of select="concat($y2,$uofUnit)"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="$picstyle/图:翻转_803A = 'xy'">
						<xsl:variable name="x1" select="$posx + $width"/>
						<xsl:variable name="y1" select="$posy + $height"/>
						<xsl:variable name="x2" select="$posx"/>
						<xsl:variable name="y2" select="$posy"/>
						<xsl:attribute name="svg:x1"><xsl:value-of select="concat($x1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y1"><xsl:value-of select="concat($y1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:x2"><xsl:value-of select="concat($x2,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y2"><xsl:value-of select="concat($y2,$uofUnit)"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="x1" select="$posx"/>
						<xsl:variable name="y1" select="$posy"/>
						<xsl:variable name="x2" select="$posx + $width"/>
						<xsl:variable name="y2" select="$posy + $height"/>
						<xsl:attribute name="svg:x1"><xsl:value-of select="concat($x1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y1"><xsl:value-of select="concat($y1,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:x2"><xsl:value-of select="concat($x2,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="svg:y2"><xsl:value-of select="concat($y2,$uofUnit)"/></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<!--<xsl:variable name="zuheweizhi-x">
					<xsl:value-of select="$picstyle/图:组合位置/@图:x坐标"/>
				</xsl:variable>
				<xsl:variable name="zuheweizhi-y">
					<xsl:value-of select="$picstyle/图:组合位置/@图:y坐标"/>
				</xsl:variable>
				<xsl:variable name="hex">
					<xsl:value-of select="concat(0+number($zuheweizhi-x),$uofUnit)"/>
				</xsl:variable>
				<xsl:variable name="hey">
					<xsl:value-of select="concat(0+number($zuheweizhi-y),$uofUnit)"/>
				</xsl:variable>
				<xsl:attribute name="svg:x1"><xsl:value-of select="$hex"/></xsl:attribute>
				<xsl:attribute name="svg:y1"><xsl:value-of select="$hey"/></xsl:attribute>
				<xsl:attribute name="svg:x2"><xsl:value-of select="concat((number($zuheweizhi-x) + number($picstyle/图:预定义图形/图:属性/图:宽度)),$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:y2"><xsl:value-of select="concat((number($zuheweizhi-y) + number($picstyle/图:预定义图形/图:属性/图:高度)),$uofUnit)"/></xsl:attribute>-->
			</xsl:otherwise>
		</xsl:choose>
		<xsl:attribute name="text:anchor-type"><xsl:choose><xsl:when test="uof:位置_C620/@类型_C646='page'">page</xsl:when><xsl:when test="uof:位置_C620/@类型_C646='paragraph'">paragraph</xsl:when><xsl:when test="uof:位置_C620/@类型_C646='char'">char</xsl:when><xsl:when test="uof:位置_C620/@类型_C646='as-char'">as-char</xsl:when><xsl:when test="uof:位置_C620/@类型_C646='frame'">frame</xsl:when><xsl:otherwise>char</xsl:otherwise></xsl:choose></xsl:attribute>
		<xsl:attribute name="draw:style-name"><xsl:value-of select="$picstyle[1]/@标识符_804B"/></xsl:attribute>
		<xsl:attribute name="draw:id"><xsl:value-of select="$picstyle[1]/@标识符_804B"/></xsl:attribute>
		<xsl:if test="$picstyle/@层次_8063">
			<xsl:attribute name="draw:z-index"><xsl:value-of select="$picstyle[1]/@层次_8063"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="not($angle=0)">
			<xsl:call-template name="DrawTransform">
				<xsl:with-param name="angle" select="$picstyle/图:预定义图形_8018/图:属性_801D/图:旋转角度_804D"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$isconnector='true'">
			<xsl:attribute name="draw:start-shape"><xsl:value-of select="$picstyle//图:预定义图形_8018/图:连接线规则_8027/@始端对象引用_8029"/></xsl:attribute>
			<xsl:attribute name="draw:end-shape"><xsl:value-of select="$picstyle//图:预定义图形_8018/图:连接线规则_8027/@终端对象引用_802A"/></xsl:attribute>
			<xsl:attribute name="draw:start-glue-point"><xsl:value-of select="$picstyle//图:预定义图形_8018/图:连接线规则_8027/@始端对象连接点索引_802B"/></xsl:attribute>
			<xsl:attribute name="draw:end-glue-point"><xsl:value-of select="$picstyle//图:预定义图形_8018/图:连接线规则_8027/@终端对象连接点索引_802C"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<!--xsl:template name="DrawRect">
		<xsl:param name="picstyle"/>
		<xsl:element name="draw:rect">
			<xsl:call-template name="DrawCommContent">
				<xsl:with-param name="picstyle" select="$picstyle"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template-->
	<xsl:template name="DrawCaption">
		<xsl:param name="picstyle"/>
		<xsl:element name="draw:caption">
			<xsl:call-template name="DrawCommContent">
				<xsl:with-param name="picstyle" select="$picstyle"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template name="DrawLine">
		<xsl:param name="picstyle"/>
		<xsl:element name="draw:line">
			<xsl:call-template name="DrawLineAttr">
				<xsl:with-param name="picstyle" select="$picstyle"/>
			</xsl:call-template>
			<xsl:call-template name="DrawCommElement">
				<xsl:with-param name="picstyle" select="$picstyle"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template name="DrawConnector">
		<xsl:param name="picstyle"/>
		<xsl:variable name="isconnector" select="string('true')"/>
		<xsl:variable name="graphtype">
			<xsl:value-of select="$picstyle/图:预定义图形_8018/图:类别_8019"/>
		</xsl:variable>
		<xsl:element name="draw:connector">
			<xsl:call-template name="DrawLineAttr">
				<xsl:with-param name="picstyle" select="$picstyle"/>
				<xsl:with-param name="isconnector" select="$isconnector"/>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="$graphtype='71' or $graphtype='72' or $graphtype='73'">
					<xsl:attribute name="draw:type">line</xsl:attribute>
				</xsl:when>
				<xsl:when test="$graphtype='77' or $graphtype='78' or $graphtype='79'">
					<xsl:attribute name="draw:type">curve</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="$picstyle/图:预定义图形_8018/图:路径_801C/图:路径值_8069">
				<xsl:variable name="width" select="number($picstyle/图:预定义图形_8018/图:属性_801D/图:大小_8060/@宽_C605)"/>
				<xsl:variable name="height" select="number($picstyle/图:预定义图形_8018/图:属性_801D/图:大小_8060/@长_C604)"/>
				<xsl:attribute name="svg:viewBox"><xsl:value-of select="concat('0 0 ',$width, ' ',$height)"/></xsl:attribute>
				<xsl:attribute name="draw:points"><xsl:value-of select="$picstyle/图:预定义图形_8018/图:路径_801C/图:路径值_8069"/></xsl:attribute>
			</xsl:if>
			<xsl:call-template name="DrawCommElement">
				<xsl:with-param name="picstyle" select="$picstyle"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template name="DrawPolyline">
		<xsl:param name="picstyle"/>
		<xsl:element name="draw:polyline">
			<xsl:call-template name="DrawPathContent">
				<xsl:with-param name="picstyle" select="$picstyle"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template name="DrawPolygon">
		<xsl:param name="picstyle"/>
		<xsl:element name="draw:polygon">
			<xsl:call-template name="DrawPathContent">
				<xsl:with-param name="picstyle" select="$picstyle"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<!--xsl:template name="DrawEllipse">
		<xsl:param name="picstyle"/>
		<xsl:element name="draw:ellipse">
			<xsl:call-template name="DrawCommContent">
				<xsl:with-param name="picstyle" select="$picstyle"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template-->
	<xsl:template name="CustomShapeType">
		<xsl:param name="GraphicID"/>
		<xsl:choose>
			<xsl:when test="$GraphicID='11'">rectangle</xsl:when>
			<xsl:when test="$GraphicID='12'">parallelogram</xsl:when>
			<xsl:when test="$GraphicID='13'">trapezoid</xsl:when>
			<xsl:when test="$GraphicID='14'">diamond</xsl:when>
			<xsl:when test="$GraphicID='15'">round-rectangle</xsl:when>
			<xsl:when test="$GraphicID='16'">octagon</xsl:when>
			<xsl:when test="$GraphicID='17'">isosceles-triangle</xsl:when>
			<xsl:when test="$GraphicID='18'">right-triangle</xsl:when>
			<xsl:when test="$GraphicID='19'">ellipse</xsl:when>
			<xsl:when test="$GraphicID='21'">right-arrow</xsl:when>
			<xsl:when test="$GraphicID='22'">left-arrow</xsl:when>
			<xsl:when test="$GraphicID='23'">up-arrow</xsl:when>
			<xsl:when test="$GraphicID='24'">down-arrow</xsl:when>
			<xsl:when test="$GraphicID='25'">left-right-arrow</xsl:when>
			<xsl:when test="$GraphicID='26'">up-down-arrow</xsl:when>
			<xsl:when test="$GraphicID='27'">quad-arrow</xsl:when>
			<xsl:when test="$GraphicID='28'">mso-spt182</xsl:when>
			<xsl:when test="$GraphicID='31'">flowchart-process</xsl:when>
			<xsl:when test="$GraphicID='33'">flowchart-decision</xsl:when>
			<xsl:when test="$GraphicID='34'">flowchart-data</xsl:when>
			<xsl:when test="$GraphicID='35'">flowchart-predefined-process</xsl:when>
			<xsl:when test="$GraphicID='36'">flowchart-internal-storage</xsl:when>
			<xsl:when test="$GraphicID='37'">flowchart-document</xsl:when>
			<xsl:when test="$GraphicID='38'">flowchart-multidocument</xsl:when>
			<xsl:when test="$GraphicID='39'">flowchart-terminator</xsl:when>
			<xsl:when test="$GraphicID='41'">mso-spt71</xsl:when>
			<xsl:when test="$GraphicID='42'">bang</xsl:when>
			<xsl:when test="$GraphicID='43'">star4</xsl:when>
			<xsl:when test="$GraphicID='44'">star5</xsl:when>
			<xsl:when test="$GraphicID='45'">star8</xsl:when>
			<xsl:when test="$GraphicID='46'">mso-spt59</xsl:when>
			<xsl:when test="$GraphicID='47'">star24</xsl:when>
			<xsl:when test="$GraphicID='48'">mso-spt60</xsl:when>
			<xsl:when test="$GraphicID='49'">mso-spt54</xsl:when>
			<xsl:when test="$GraphicID='51'">rectangular-callout</xsl:when>
			<xsl:when test="$GraphicID='52'">round-rectangular-callout</xsl:when>
			<xsl:when test="$GraphicID='53'">round-callout</xsl:when>
			<xsl:when test="$GraphicID='54'">cloud-callout</xsl:when>
			<xsl:when test="$GraphicID='55'">line-callout-1</xsl:when>
			<xsl:when test="$GraphicID='56'">line-callout-2</xsl:when>
			<xsl:when test="$GraphicID='57'">line-callout-3</xsl:when>
			<xsl:when test="$GraphicID='110'">hexagon</xsl:when>
			<xsl:when test="$GraphicID='111'">cross</xsl:when>
			<xsl:when test="$GraphicID='112'">pentagon</xsl:when>
			<xsl:when test="$GraphicID='113'">can</xsl:when>
			<xsl:when test="$GraphicID='114'">cube</xsl:when>
			<xsl:when test="$GraphicID='115'">quad-bevel</xsl:when>
			<xsl:when test="$GraphicID='116'">paper</xsl:when>
			<xsl:when test="$GraphicID='117'">smiley</xsl:when>
			<xsl:when test="$GraphicID='118'">ring</xsl:when>
			<xsl:when test="$GraphicID='119'">forbidden</xsl:when>
			<xsl:when test="$GraphicID='120'">block-arc</xsl:when>
			<xsl:when test="$GraphicID='121'">heart</xsl:when>
			<xsl:when test="$GraphicID='122'">non-primitive</xsl:when>
			<xsl:when test="$GraphicID='123'">sun</xsl:when>
			<xsl:when test="$GraphicID='124'">moon</xsl:when>
			<xsl:when test="$GraphicID='126'">bracket-pair</xsl:when>
			<xsl:when test="$GraphicID='127'">brace-pair</xsl:when>
			<xsl:when test="$GraphicID='128'">mso-spt21</xsl:when>
			<xsl:when test="$GraphicID='129'">left-bracket</xsl:when>
			<xsl:when test="$GraphicID='130'">right-bracket</xsl:when>
			<xsl:when test="$GraphicID='131'">left-brace</xsl:when>
			<xsl:when test="$GraphicID='132'">right-brace</xsl:when>
			<xsl:when test="$GraphicID='211'">mso-spt89</xsl:when>
			<xsl:when test="$GraphicID='212'">non-primitive</xsl:when>
			<xsl:when test="$GraphicID='214'">circular-arrow</xsl:when>
			<xsl:when test="$GraphicID='216'">circular-arrow</xsl:when>
			<xsl:when test="$GraphicID='217'">mso-spt100</xsl:when>
			<xsl:when test="$GraphicID='218'">notched-right-arrow</xsl:when>
			<xsl:when test="$GraphicID='219'">pentagon-right</xsl:when>
			<xsl:when test="$GraphicID='220'">chevron</xsl:when>
			<xsl:when test="$GraphicID='221'">right-arrow-callout</xsl:when>
			<xsl:when test="$GraphicID='222'">left-arrow-callout</xsl:when>
			<xsl:when test="$GraphicID='223'">up-arrow-callout</xsl:when>
			<xsl:when test="$GraphicID='224'">down-arrow-callout</xsl:when>
			<xsl:when test="$GraphicID='225'">left-right-arrow-callout</xsl:when>
			<xsl:when test="$GraphicID='226'">up-down-arrow-callout</xsl:when>
			<xsl:when test="$GraphicID='227'">quad-arrow-callout</xsl:when>
			<xsl:when test="$GraphicID='228'">circular-arrow</xsl:when>
			<xsl:when test="$GraphicID='310'">flowchart-preparation</xsl:when>
			<xsl:when test="$GraphicID='311'">flowchart-manual-input</xsl:when>
			<xsl:when test="$GraphicID='312'">flowchart-manual-operation</xsl:when>
			<xsl:when test="$GraphicID='313'">flowchart-connector</xsl:when>
			<xsl:when test="$GraphicID='314'">flowchart-off-page-connector</xsl:when>
			<xsl:when test="$GraphicID='315'">flowchart-card</xsl:when>
			<xsl:when test="$GraphicID='316'">flowchart-punched-tape</xsl:when>
			<xsl:when test="$GraphicID='317'">flowchart-summing-junction</xsl:when>
			<xsl:when test="$GraphicID='318'">flowchart-or</xsl:when>
			<xsl:when test="$GraphicID='319'">flowchart-collate</xsl:when>
			<xsl:when test="$GraphicID='320'">flowchart-sort</xsl:when>
			<xsl:when test="$GraphicID='321'">flowchart-extract</xsl:when>
			<xsl:when test="$GraphicID='322'">flowchart-merge</xsl:when>
			<xsl:when test="$GraphicID='323'">flowchart-stored-data</xsl:when>
			<xsl:when test="$GraphicID='324'">flowchart-delay</xsl:when>
			<xsl:when test="$GraphicID='325'">flowchart-sequential-access</xsl:when>
			<xsl:when test="$GraphicID='326'">flowchart-magnetic-disk</xsl:when>
			<xsl:when test="$GraphicID='327'">flowchart-direct-access-storage</xsl:when>
			<xsl:when test="$GraphicID='328'">flowchart-display</xsl:when>
			<xsl:when test="$GraphicID='413'">vertical-scroll</xsl:when>
			<xsl:when test="$GraphicID='414'">horizontal-scroll</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="DrawCustomshape">
		<xsl:param name="picstyle"/>
		<xsl:param name="graphtype"/>
		<xsl:element name="draw:custom-shape">
			<xsl:call-template name="DrawCustomContent">
				<xsl:with-param name="picstyle" select="$picstyle"/>
				<xsl:with-param name="graphtype" select="$graphtype"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template name="FrmContent">
		<xsl:param name="refobject"/>
		<xsl:variable name="frmobject">
			<xsl:choose>
				<xsl:when test="$refobject/@公共类型_D706">
					<xsl:choose>
						<xsl:when test="$refobject/@公共类型_D706= 'png'">image</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'jpg'">image</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'gif'">image</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'bmp'">image</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'pbm'">image</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'wav'">plugin</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'mid'">plugin</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'ra'">plugin</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'au'">plugin</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'mp3'">plugin</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'avi'">plugin</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'mpeg'">plugin</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'qt'">plugin</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'rm'">plugin</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'asf'">plugin</xsl:when>
						<xsl:when test="$refobject/@公共类型_D706= 'svg'">plugin</xsl:when>
						<xsl:otherwise>none</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$refobject/@私有类型_D707">
					<xsl:choose>
						<xsl:when test="$refobject/@私有类型_D707= '图片'">image</xsl:when>
						<xsl:when test="$refobject/@私有类型_D707= 'emf'">image</xsl:when>
						<xsl:when test="$refobject/@私有类型_D707= 'old对象'">objectole</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$refobject/@私有类型_D707"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>none</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="not($frmobject='none')">
			<xsl:choose>
				<xsl:when test="$frmobject='image'">
					<draw:image xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad">
						<xsl:if test="$refobject/对象:路径_D703">
							<!-- maybe xlink is a outside picture -->
							<xsl:call-template name="AddXLink">
								<xsl:with-param name="refobject" select="$refobject"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="$refobject/对象:数据_D702">
							<xsl:element name="office:binary-data">
								<xsl:value-of select="$refobject/对象:数据_D702"/>
							</xsl:element>
						</xsl:if>
					</draw:image>
				</xsl:when>
				<xsl:when test="$frmobject='objectole'">
					<xsl:element name="draw:object-ole">
						<xsl:if test="$refobject/对象:路径_D703">
							<!-- extensions of outside picture -->
							<xsl:call-template name="AddXLink">
								<xsl:with-param name="refobject" select="$refobject"/>
							</xsl:call-template>
							<!-- object data -->
						</xsl:if>
						<xsl:if test="$refobject/对象:数据_D702">
							<xsl:element name="office:binary-data">
								<xsl:value-of select="$refobject/对象:数据_D702"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!-- process pictues including outside pictures -->
	<xsl:template name="AddXLink">
		<xsl:param name="refobject"/>
		<xsl:attribute name="xlink:href"><xsl:variable name="path"><xsl:value-of select="$refobject/对象:路径_D703"/></xsl:variable><xsl:choose><xsl:when test="starts-with( $path,'/data')"><xsl:value-of select="replace($refobject/对象:路径_D703,'/data','Pictures')"/></xsl:when><xsl:otherwise><xsl:choose><!--'/' is for maybe absolute path--><xsl:when test="starts-with($path,'.') or starts-with($path,'/')"><xsl:value-of select="$path"/></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="substring($path,2,1)=':'"><xsl:value-of select="concat( '/',$path)"/></xsl:when><xsl:otherwise><xsl:value-of select="$path"/></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	
	<xsl:template name="DrawFrame">
		<xsl:param name="picstyle"/>
		<xsl:element name="draw:frame">
			<xsl:attribute name="draw:name"><xsl:value-of select="@图形引用_C62E"/></xsl:attribute>
			<xsl:call-template name="DrawCommAttr">
				<xsl:with-param name="picstyle" select="$picstyle"/>
			</xsl:call-template>
			<xsl:if test="$picstyle/图:其他对象引用_8038">
				<xsl:variable name="cs">
					<xsl:value-of select="$picstyle/图:其他对象引用_8038"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="/uof:UOF_0000/公式:公式集_C200/公式:数学公式_C201[@标识符_C202=$cs]">
						<xsl:variable name="refobject" select="/uof:UOF_0000/公式:公式集_C200/公式:数学公式_C201[@标识符_C202=$cs]"/>
						<xsl:element name="draw:object">
							<xsl:element name="math:math">
								<xsl:copy-of select="$refobject/公式:math_C203/*"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="refobject" select="/uof:UOF_0000/对象:对象数据集_D700/对象:对象数据_D701[@标识符_D704=$cs]"/>
						<xsl:call-template name="FrmContent">
							<xsl:with-param name="refobject" select="$refobject"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<!-- about Draw::Frame match subElement , starting… -->
			<xsl:if test="$picstyle/图:图片数据引用_8037">
				<xsl:variable name="titleMap">
					<xsl:value-of select="$picstyle/图:图片数据引用_8037"/>
				</xsl:variable>
				<xsl:variable name="pathMap">
					<xsl:for-each select="/uof:UOF_0000/对象:对象数据集_D700/对象:对象数据_D701[@标识符_D704 = $titleMap]">
						<xsl:if test="@标识符_D704 = $titleMap">
							<xsl:if test="current()/对象:路径_D703 and @是否内嵌_D705 = 'true'">
								<!-- Maybe there need to judge if it is an embedded URL path. Outside URL path doesn't allow to be replaced. -->
								<!-- Maybe need to judge if gonggongleixing_D706 attribute is existing. -->
								<xsl:value-of select="replace(current()/对象:路径_D703,'/data','Pictures')"/>
							</xsl:if>
							<xsl:if test="current()/对象:路径_D703 and @是否内嵌_D705 = 'false'">
								<!-- Maybe there need to judge if it is an embedded URL path. Outside URL path doesn't allow to be replaced. -->
								<!-- Maybe need to judge if gonggongleixing_D706 attribute is existing. -->
								<xsl:value-of select="current()/对象:路径_D703"/>
							</xsl:if>
							<xsl:if test="current()/对象:数据_D702">
								<xsl:value-of select="''"/>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="embed">
					<!-- embedded attribute, correspond with xlink:show in odf -->
					<xsl:for-each select="/uof:UOF_0000/对象:对象数据集_D700/对象:对象数据_D701[@标识符_D704 = $titleMap]">
						<xsl:if test="@标识符_D704 = $titleMap">
							<!-- If judge ShiFouNeiQian_D705 attribute is existing? -->
							<xsl:choose>
								<xsl:when test="@是否内嵌_D705 = 'true'">embed<!--xsl:value-of select="'embed'"/-->
								</xsl:when>
								<xsl:otherwise>new<!--replace-->
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:element name="draw:image">
					<xsl:choose>
						<xsl:when test="$pathMap = ''">
							<xsl:for-each select="/uof:UOF_0000/对象:对象数据集_D700/对象:对象数据_D701[@标识符_D704 = $titleMap]">
								<xsl:if test="@标识符_D704 = $titleMap">
									<xsl:if test="current()/对象:数据_D702">
										<xsl:element name="office:binary-data">
											<xsl:value-of select="current()/对象:数据_D702"/>
										</xsl:element>
									</xsl:if>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="xlink:href">
								<xsl:value-of select="$pathMap"/>
							</xsl:attribute>
							<xsl:attribute name="xlink:show">
								<xsl:value-of select="$embed"/>
							</xsl:attribute>
						</xsl:otherwise>				
					</xsl:choose>
				</xsl:element>		
			</xsl:if>
			<xsl:if test="($document_type = 'presentation') and (name() = 'uof:锚点_C644')">
				<xsl:if test="not($picstyle/图:其他对象引用_8038)">
					<xsl:choose>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'graphics'">
							<draw:image xlink:href=""/>
						</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'chart'">
							<draw:object/>
							<draw:image/>
						</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'clipart'">
							<draw:image xlink:href=""/>
						</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'object'">
							<draw:object xlink:href="" xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad"/>
						</xsl:when>
						<xsl:when test="uof:占位符_C626/@类型_C627 = 'table'">
							<draw:object/>
							<draw:image/>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="name() = 'uof:锚点_C644'">
					<xsl:call-template name="DrawCommElementWeb">
						<xsl:with-param name="picstyle" select="$picstyle"/>
					</xsl:call-template>
					<xsl:element name="draw:text-box">
						<xsl:variable name="minheight" select="uof:大小_C621/@长_C604"/>
						<xsl:if test="@图形引用_C62E">
							<xsl:variable name="tempName" select="@图形引用_C62E"/>
							<xsl:for-each select="$picstyle/图:文本_803C/图:前后链接_803F[@后一链接_8041]">
								<xsl:attribute name="draw:chain-next-name"><xsl:value-of select="@后一链接_8041"/></xsl:attribute>
								<!--xsl:variable name="secondName" select="@后一链接_8041"/>
								<xsl:attribute name="draw:chain-next-name"><xsl:value-of select="/uof:UOF_0000/字:文字处理文档_4225/字:段落_416B//uof:锚点_C644[@图形引用_C62E = $secondName]/@标识符"/></xsl:attribute-->
							</xsl:for-each>
						</xsl:if>
						<xsl:attribute name="fo:min-height" select="concat($minheight, $uofUnit)"/>
						<xsl:call-template name="DrawCommElementText">
							<xsl:with-param name="picstyle" select="$picstyle"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>
				<!--<xsl:when test="name() = 'uof:锚点_C644'">
					<xsl:call-template name="DrawCommElementWeb">
						<xsl:with-param name="picstyle" select="$picstyle"/>
					</xsl:call-template>
					<xsl:element name="draw:text-box">
						<xsl:call-template name="DrawCommElementText">
							<xsl:with-param name="picstyle" select="$picstyle"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>-->
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="GroupContent">
		<xsl:param name="zuhe_list"/>
		<xsl:variable name="first">
			<xsl:value-of select="substring-before($zuhe_list,' ')"/>
		</xsl:variable>
		<xsl:variable name="picname">
			<xsl:choose>
				<xsl:when test="not($first='')">
					<xsl:value-of select="$first"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$zuhe_list"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="picstyle" select="key('graph-styles', $picname)"/>
		<xsl:call-template name="DrawContent">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
		<xsl:variable name="other">
			<xsl:value-of select="substring-after($zuhe_list,' ')"/>
		</xsl:variable>
		<xsl:if test="not($other='')">
			<xsl:call-template name="GroupContent">
				<xsl:with-param name="zuhe_list" select="$other"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="DrawSvgContent">
		<xsl:param name="picstyle"/>
		<xsl:call-template name="DrawCommAttr">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
		<xsl:variable name="width" select="number($picstyle/图:svg图形对象_8017/@width)*1000"/>
		<xsl:variable name="height" select="number($picstyle/图:svg图形对象_8017/@height)*1000"/>
		<xsl:attribute name="svg:viewBox"><xsl:value-of select="concat('0 0 ',$width, ' ',$height)"/></xsl:attribute>
		<xsl:attribute name="svg:d"><xsl:value-of select="$picstyle/图:svg图形对象_8017/svg:path/@d"/></xsl:attribute>
		<xsl:call-template name="DrawCommElement">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="SvgGraph">
		<xsl:param name="picstyle"/>
		<xsl:element name="draw:path">
			<xsl:call-template name="DrawSvgContent">
				<xsl:with-param name="picstyle" select="$picstyle"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template name="ChartGraph">
		<xsl:param name="picstyle"/>
		<draw:frame>
			<xsl:attribute name="draw:z-index"><xsl:value-of select="'0'"/></xsl:attribute>
			<xsl:attribute name="svg:width"><xsl:value-of select="concat(uof:大小_C621/@宽_C605,$uofUnit)"/></xsl:attribute>
			<xsl:attribute name="svg:height"><xsl:value-of select="concat(uof:大小_C621/@长_C604,$uofUnit)"/></xsl:attribute>
			<xsl:for-each select="uof:位置_C620">
				<xsl:attribute name="svg:x"><xsl:value-of select="concat(uof:水平_4106/uof:绝对_4107/@值_4108,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:y"><xsl:value-of select="concat(uof:垂直_410D/uof:绝对_4107/@值_4108,$uofUnit)"/></xsl:attribute>
			</xsl:for-each>
			<xsl:for-each select="/uof:UOF_0000/图表:图表集_E836/图表:图表_E837[@标识符_E828=$picstyle/图:图表数据引用_8065]">
				<xsl:element name="draw:object">
					<xsl:variable name="var_ObjectName">
						<xsl:variable name="var_GenerateID" select="generate-id()"/>
						<xsl:value-of select="concat('./Object ',$gvar_ChartsIndexes/ChartIndex[@GenerateID = $var_GenerateID]/@Index)"/>
					</xsl:variable>
					<xsl:attribute name="draw:notify-on-update-of-ranges"><xsl:choose><xsl:when test="图表:绘图区_E747/图表:数据区域_E74B"><xsl:value-of select="图表:绘图区_E747/图表:数据区域_E74B"/></xsl:when><xsl:otherwise><xsl:for-each select="图表:绘图区_E747/图表:图表类型组集_E74C/图表:组_E74D[1]/图表:数据系列集_E74E"><xsl:for-each select="图表:数据系列_E74F[1]"><xsl:if test="@值_E775"><xsl:analyze-string select="@值_E775" regex="='(.*?)'!([A-Z,a-z]{{1,2}}\d+):?([A-Z,a-z]{{1,2}}\d+)?"><xsl:matching-substring><xsl:choose><xsl:when test="regex-group(3) = ''"><xsl:value-of select="concat(regex-group(1), '.', regex-group(2))"/></xsl:when><xsl:otherwise><xsl:value-of select="concat(regex-group(1), '.', regex-group(2), ':', regex-group(1), '.', regex-group(3))"/></xsl:otherwise></xsl:choose><xsl:value-of select="' '"/></xsl:matching-substring></xsl:analyze-string></xsl:if></xsl:for-each><xsl:for-each-group select="图表:数据系列_E74F" group-by="@分类名_E776"><xsl:analyze-string select="current-grouping-key()" regex="='(.*?)'!([A-Z,a-z]{{1,2}}\d+):?([A-Z,a-z]{{1,2}}\d+)?"><xsl:matching-substring><xsl:choose><xsl:when test="regex-group(3) = ''"><xsl:value-of select="concat(regex-group(1), '.', regex-group(2), ':', regex-group(1), '.', regex-group(2))"/></xsl:when><xsl:otherwise><xsl:value-of select="concat(regex-group(1), '.', regex-group(2), ':', regex-group(1), '.', regex-group(3))"/></xsl:otherwise></xsl:choose><xsl:value-of select="' '"/></xsl:matching-substring></xsl:analyze-string></xsl:for-each-group><xsl:for-each-group select="图表:数据系列_E74F" group-by="@名称_E774"><xsl:analyze-string select="current-grouping-key()" regex="='(.*?)'!([A-Z,a-z]{{1,2}}\d+):?([A-Z,a-z]{{1,2}}\d+)?"><xsl:matching-substring><xsl:choose><xsl:when test="regex-group(3) = ''"><xsl:value-of select="concat(regex-group(1), '.', regex-group(2), ':', regex-group(1), '.', regex-group(2))"/></xsl:when><xsl:otherwise><xsl:value-of select="concat(regex-group(1), '.', regex-group(2), ':', regex-group(1), '.', regex-group(3))"/></xsl:otherwise></xsl:choose><xsl:value-of select="' '"/></xsl:matching-substring></xsl:analyze-string></xsl:for-each-group></xsl:for-each></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="xlink:href"><xsl:value-of select="$var_ObjectName"/></xsl:attribute>
					<xsl:attribute name="xlink:type">simple</xsl:attribute>
					<xsl:attribute name="xlink:show">embed</xsl:attribute>
					<xsl:attribute name="xlink:actuate">onLoad</xsl:attribute>
				</xsl:element>
			</xsl:for-each>
		</draw:frame>
	</xsl:template>
	<xsl:template name="LinePathContent">
		<xsl:param name="picstyle"/>
		<xsl:call-template name="DrawCommAttr">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
		<xsl:variable name="pointx">
			<xsl:value-of select="$picstyle/图:预定义图形_8018/图:路径_801C/图:视窗_806A/图:左上角_806B/@x_C606"/>
		</xsl:variable>
		<xsl:variable name="pointy">
			<xsl:value-of select="$picstyle/图:预定义图形_8018/图:路径_801C/图:视窗_806A/图:左上角_806B/@y_C607"/>
		</xsl:variable>
		<xsl:variable name="height">
			<xsl:value-of select="$picstyle/图:预定义图形_8018/图:路径_801C/图:视窗_806A/图:大小_806C/@长_C604"/>
		</xsl:variable>
		<xsl:variable name="width">
			<xsl:value-of select="$picstyle/图:预定义图形_8018/图:路径_801C/图:视窗_806A/图:大小_806C/@宽_C605"/>
		</xsl:variable>
		<xsl:attribute name="svg:viewBox"><xsl:value-of select="concat($pointx,' ',$pointy,' ',$width, ' ',$height)"/></xsl:attribute>
		<xsl:attribute name="svg:d"><xsl:value-of select="$picstyle/图:预定义图形_8018/图:路径_801C/图:路径值_8069"/></xsl:attribute>
		<xsl:call-template name="DrawCommElement">
			<xsl:with-param name="picstyle" select="$picstyle"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="LinePath">
		<xsl:param name="picstyle"/>
		<xsl:element name="draw:path">
			<xsl:call-template name="LinePathContent">
				<xsl:with-param name="picstyle" select="$picstyle"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template name="DrawPageThumbnail">
		<xsl:param name="picstyle"/>
		<draw:page-thumbnail>
			<xsl:attribute name="draw:layer">layout</xsl:attribute>
			<xsl:attribute name="draw:page-number"><xsl:value-of select="count(../../preceding-sibling::*) + 1"/></xsl:attribute>
			<xsl:call-template name="DrawCommAttr">
				<xsl:with-param name="picstyle" select="$picstyle"/>
			</xsl:call-template>
			<xsl:attribute name="presentation:class">page</xsl:attribute>
		</draw:page-thumbnail>
	</xsl:template>
	<xsl:template name="DrawContent">
		<xsl:param name="picstyle"/>
		<xsl:variable name="id" select="@图形引用_C62E"/>
		<xsl:variable name="Isframe">
			<xsl:variable name="IsChaining">
				<xsl:choose>
					<xsl:when test="/uof:UOF_0000/图形:图形集_7C00/图:图形_8062/图:文本_803C/图:前后链接_803F/@前一链接_8040 = $id or /uof:UOF_0000/图形:图形集_7C00/图:图形_8062/图:文本_803C/图:前后链接_803F/@后一链接_8041 = $id">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="uof:占位符_C626">true</xsl:when>
				<xsl:when test="$picstyle/图:文本_803C/图:内容_8043/字:文字表_416C or $picstyle/图:文本_803C//uof:锚点_C644 or $picstyle/图:文本_803C/图:前后链接_803F/@前一链接_8040 or $picstyle/图:文本_803C/图:前后链接_803F/@后一链接_8041 or ($picstyle/图:文本_803C/图:文字排列方向_8042 != '' and $picstyle/图:文本_803C/图:文字排列方向_8042 != 't2b-l2r-0e-0w') or $IsChaining = 'true' or $picstyle/图:其他对象引用_8038 or $picstyle/图:文本_803C//字:域开始_419E">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$picstyle/@组合列表_8064">
				<xsl:variable name="zuhe_list" select="$picstyle/@组合列表_8064"/>
				<xsl:element name="draw:g">
					<xsl:call-template name="DrawCommContent">
						<xsl:with-param name="picstyle" select="$picstyle"/>
					</xsl:call-template>
					<xsl:call-template name="GroupContent">
						<xsl:with-param name="zuhe_list" select="$zuhe_list"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:when>
			<!--xsl:when test="$picstyle/图:其他对象引用_8038 !=''">
				<xsl:element name="draw:frame">
					<xsl:call-template name="DrawOtherAttr"/>
					<xsl:for-each select="key('other-styles',$picstyle/图:其他对象引用_8038)">
						<draw:image xlink:actuate="onLoad" xlink:show="embed" xlink:type="simple">
							<xsl:attribute name="xlink:href"><xsl:value-of select="对象:路径_D703"/></xsl:attribute>
						</draw:image>
					</xsl:for-each>
				</xsl:element>
			</xsl:when-->
			<!--integrated Conversion the customshape or frame -->
			<!-- change this type to draw:frame -->
			<xsl:when test="$picstyle/图:图片数据引用_8037">
				<!--用‘图:预定义图形_8018/图:属性_801D/图:图片属性_801E’判断也可以-->
				<xsl:call-template name="DrawFrame">
					<xsl:with-param name="picstyle" select="$picstyle"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$picstyle/图:预定义图形_8018/图:类别_8019 = '11' and $Isframe = 'true'">
				<xsl:call-template name="DrawFrame">
					<xsl:with-param name="picstyle" select="$picstyle"/>
				</xsl:call-template>
			</xsl:when>
			<!--<xsl:when test="$picstyle/图:预定义图形/图:类别 = '11' and uof:占位符_C626 !='' ">-->
			<xsl:when test="uof:占位符_C626 !='' ">
				<xsl:call-template name="DrawFrame">
					<xsl:with-param name="picstyle" select="$picstyle"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$picstyle/图:svg图形对象_8017">
				<xsl:call-template name="SvgGraph">
					<xsl:with-param name="picstyle" select="$picstyle"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$picstyle/图:图表数据引用_8065">
				<xsl:call-template name="ChartGraph">
					<xsl:with-param name="picstyle" select="$picstyle"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$picstyle/图:预定义图形_8018/图:路径_801C">
				<xsl:call-template name="LinePath">
					<xsl:with-param name="picstyle" select="$picstyle"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="graphtype">
					<xsl:value-of select="$picstyle[1]/图:预定义图形_8018/图:类别_8019"/>
				</xsl:variable>
				<xsl:choose>
					<!--xsl:when test="$graphtype='11'">
						<xsl:call-template name="DrawRect">
							<xsl:with-param name="picstyle" select="$picstyle"/>
						</xsl:call-template>
					</xsl:when-->
					<xsl:when test="$graphtype='61'">
						<xsl:call-template name="DrawLine">
							<xsl:with-param name="picstyle" select="$picstyle"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$graphtype='66'">
						<xsl:call-template name="DrawPolyline">
							<xsl:with-param name="picstyle" select="$picstyle"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$graphtype='65'">
						<xsl:call-template name="DrawPolygon">
							<xsl:with-param name="picstyle" select="$picstyle"/>
						</xsl:call-template>
					</xsl:when>
					<!--xsl:when test="$graphtype='19'">
						<xsl:call-template name="DrawEllipse">
							<xsl:with-param name="picstyle" select="$picstyle"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$graphtype='51'">
						<xsl:call-template name="DrawCaption">
							<xsl:with-param name="picstyle" select="$picstyle"/>
						</xsl:call-template>
					</xsl:when-->
					<xsl:when test="$graphtype='71' or $graphtype='72' or $graphtype='73' or $graphtype='74' or $graphtype='75' or $graphtype='76' or $graphtype='77' or $graphtype='78' or $graphtype='79'">
						<xsl:call-template name="DrawConnector">
							<xsl:with-param name="picstyle" select="$picstyle"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="DrawCustomshape">
							<xsl:with-param name="picstyle" select="$picstyle"/>
							<xsl:with-param name="graphtype" select="$graphtype"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="DrawOtherAttr">
		<xsl:variable name="posx">
			<xsl:choose>
				<xsl:when test="uof:位置_C620/@类型_C646 = 'as-char'">
					<xsl:value-of select="number(0)"/>
				</xsl:when>
				<xsl:when test="uof:位置_C620/uof:水平_4106/uof:绝对_4107/@值_4108">
					<xsl:value-of select="number(uof:位置_C620/uof:水平_4106/uof:绝对_4107/@值_4108)"/>
				</xsl:when>
				<xsl:when test="uof:位置_C620/uof:水平_4106/uof:相对_4109">
					<xsl:value-of select="number(uof:位置_C620/uof:水平_4106/uof:相对_4109/@值_410B)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="posy">
			<xsl:choose>
				<xsl:when test="uof:位置_C620/@类型_C646 = 'as-char'">
					<xsl:value-of select="number(0)"/>
				</xsl:when>
				<xsl:when test="uof:位置_C620/uof:垂直_410D/@相对于_410C = 'line'">
					<xsl:value-of select="0 - number(uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108)"/>
				</xsl:when>
				<xsl:when test="uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108">
					<xsl:value-of select="number(uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108)"/>
				</xsl:when>
				<xsl:when test="uof:位置_C620/uof:垂直_410D/uof:相对_4109">
					<xsl:value-of select="number(uof:位置_C620/uof:垂直_410D/uof:相对_4109/@值_410B)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="svg:x"><xsl:value-of select="concat($posx,$uofUnit)"/></xsl:attribute>
		<xsl:attribute name="svg:y"><xsl:value-of select="concat($posy,$uofUnit)"/></xsl:attribute>
		<xsl:variable name="width">
			<xsl:value-of select="number(uof:大小_C621/@宽_C605)"/>
		</xsl:variable>
		<xsl:variable name="height">
			<xsl:value-of select="number(uof:大小_C621/@长_C604)"/>
		</xsl:variable>
		<xsl:attribute name="svg:width"><xsl:value-of select="concat($width,$uofUnit)"/></xsl:attribute>
		<xsl:attribute name="svg:height"><xsl:value-of select="concat($height,$uofUnit)"/></xsl:attribute>
		<xsl:attribute name="text:anchor-type"><xsl:choose><xsl:when test="uof:位置_C620/@类型_C646='page'">page</xsl:when><xsl:when test="uof:位置_C620/@类型_C646='paragraph'">paragraph</xsl:when><xsl:when test="uof:位置_C620/@类型_C646='char'">char</xsl:when><xsl:when test="uof:位置_C620/@类型_C646='as-char'">as-char</xsl:when><xsl:when test="uof:位置_C620/@类型_C646='frame'">frame</xsl:when><xsl:otherwise>char</xsl:otherwise></xsl:choose></xsl:attribute>
		<xsl:attribute name="draw:style-name"><xsl:value-of select="generate-id()"/></xsl:attribute>
	</xsl:template>
	<xsl:template name="ObjectContent">
		<xsl:variable name="picname" select="@图形引用_C62E"/>
		<xsl:variable name="picstyle" select="key('graph-styles', $picname)[1]"/>
		<xsl:choose>
			<xsl:when test="@是否显示缩略图_C630='true' or @是否显示缩略图_C630='1'">
				<xsl:call-template name="DrawPageThumbnail">
					<xsl:with-param name="picstyle" select="$picstyle"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="name($picstyle[1]) != ''">
				<xsl:call-template name="DrawContent">
					<xsl:with-param name="picstyle" select="$picstyle"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="objstyle" select="key('other-styles', $picname)"/>
				<xsl:choose>
					<xsl:when test="$objstyle != ''">
						<xsl:element name="draw:frame">
							<xsl:call-template name="DrawOtherAttr"/>
							<xsl:call-template name="FrmContent">
								<xsl:with-param name="refobject" select="$objstyle"/>
							</xsl:call-template>
						</xsl:element>
						<!--<xsl:call-template name="DrawFrame">
							<xsl:with-param name="picstyle" select="$objstyle"/>
						</xsl:call-template>-->
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="mathstyle" select="key('math-styles', $picname)"/>
						<xsl:if test="$mathstyle != ''">
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- if x value is too big, it will overflow. -->
	<!-- template sin(x) : sin(x) = x - x^3 / 3! + x^5 / 5! - ... +(-1)^(n-1) * x^(2 * n - 1) / (2 * n - 1) + ...-->
	<xsl:template name="sin">
		<xsl:param name="arc"/>
		<xsl:param name="n">
			<xsl:value-of select="'1'"/>
		</xsl:param>
		<xsl:param name="result"/>
		<xsl:choose>
			<xsl:when test="$n = '1'">
				<xsl:call-template name="sin">
					<xsl:with-param name="arc">
						<xsl:value-of select="$arc"/>
					</xsl:with-param>
					<xsl:with-param name="n">
						<xsl:value-of select="$n + 1"/>
					</xsl:with-param>
					<xsl:with-param name="result">
						<xsl:value-of select="$arc"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($n mod 2) = 0">
				<xsl:variable name="NPowerOfArc">
					<xsl:call-template name="power">
						<xsl:with-param name="x">
							<xsl:value-of select="$arc"/>
						</xsl:with-param>
						<xsl:with-param name="n">
							<xsl:value-of select="2 * $n - 1"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="NFactorial">
					<xsl:call-template name="factorial">
						<xsl:with-param name="n">
							<xsl:value-of select="2 * $n - 1"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="factor">
					<xsl:value-of select="$NPowerOfArc div $NFactorial"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$factor &gt; -0.0000001 and $factor &lt; 0.0000001">
						<xsl:value-of select="$result - $factor"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="sin">
							<xsl:with-param name="arc">
								<xsl:value-of select="$arc"/>
							</xsl:with-param>
							<xsl:with-param name="n">
								<xsl:value-of select="$n + 1"/>
							</xsl:with-param>
							<xsl:with-param name="result">
								<xsl:value-of select="$result - $factor"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="($n mod 2) = 1">
				<xsl:variable name="NPowerOfArc">
					<xsl:call-template name="power">
						<xsl:with-param name="x">
							<xsl:value-of select="$arc"/>
						</xsl:with-param>
						<xsl:with-param name="n">
							<xsl:value-of select="2 * $n - 1"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="NFactorial">
					<xsl:call-template name="factorial">
						<xsl:with-param name="n">
							<xsl:value-of select="2 * $n - 1"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="factor">
					<xsl:value-of select="$NPowerOfArc div $NFactorial"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$factor &gt; -0.0000001 and $factor &lt; 0.0000001">
						<xsl:value-of select="$result + $factor"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="sin">
							<xsl:with-param name="arc">
								<xsl:value-of select="$arc"/>
							</xsl:with-param>
							<xsl:with-param name="n">
								<xsl:value-of select="$n + 1"/>
							</xsl:with-param>
							<xsl:with-param name="result">
								<xsl:value-of select="$result + $factor"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- if x value is too big, it will overflow. -->
	<!-- template cos(x) : cos(x) = 1 - x^2 / 2! + x^4 / 4! - ... + (-1)^n * x^(2 * n) / (2 * n)! + ...-->
	<xsl:template name="cos">
		<xsl:param name="arc"/>
		<xsl:param name="n">
			<xsl:value-of select="'0'"/>
		</xsl:param>
		<xsl:param name="result"/>
		<xsl:choose>
			<xsl:when test="$n = '0'">
				<xsl:call-template name="cos">
					<xsl:with-param name="arc">
						<xsl:value-of select="$arc"/>
					</xsl:with-param>
					<xsl:with-param name="n">
						<xsl:value-of select="$n + 1"/>
					</xsl:with-param>
					<xsl:with-param name="result">
						<xsl:value-of select="1"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($n mod 2) = 0">
				<xsl:variable name="NPowerOfArc">
					<xsl:call-template name="power">
						<xsl:with-param name="x">
							<xsl:value-of select="$arc"/>
						</xsl:with-param>
						<xsl:with-param name="n">
							<xsl:value-of select="2 * $n"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="NFactorial">
					<xsl:call-template name="factorial">
						<xsl:with-param name="n">
							<xsl:value-of select="2 * $n"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="factor">
					<xsl:value-of select="$NPowerOfArc div $NFactorial"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$factor &gt; -0.0000001 and $factor &lt; 0.0000001">
						<xsl:value-of select="$result + $factor"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="cos">
							<xsl:with-param name="arc">
								<xsl:value-of select="$arc"/>
							</xsl:with-param>
							<xsl:with-param name="n">
								<xsl:value-of select="$n + 1"/>
							</xsl:with-param>
							<xsl:with-param name="result">
								<xsl:value-of select="$result + $factor"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="($n mod 2) = 1">
				<xsl:variable name="NPowerOfArc">
					<xsl:call-template name="power">
						<xsl:with-param name="x">
							<xsl:value-of select="$arc"/>
						</xsl:with-param>
						<xsl:with-param name="n">
							<xsl:value-of select="2 * $n"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="NFactorial">
					<xsl:call-template name="factorial">
						<xsl:with-param name="n">
							<xsl:value-of select="2 * $n"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="factor">
					<xsl:value-of select="$NPowerOfArc div $NFactorial"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$factor &gt; -0.0000001 and $factor &lt; 0.0000001 ">
						<xsl:value-of select="$result - $factor"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="cos">
							<xsl:with-param name="arc">
								<xsl:value-of select="$arc"/>
							</xsl:with-param>
							<xsl:with-param name="n">
								<xsl:value-of select="$n + 1"/>
							</xsl:with-param>
							<xsl:with-param name="result">
								<xsl:value-of select="$result - $factor"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- template : n power of x -->
	<xsl:template name="power">
		<xsl:param name="x"/>
		<xsl:param name="n"/>
		<xsl:param name="i">
			<xsl:value-of select="1"/>
		</xsl:param>
		<xsl:param name="result">
			<xsl:value-of select="1"/>
		</xsl:param>
		<xsl:choose>
			<xsl:when test="$n = 0">
				<xsl:value-of select="1"/>
			</xsl:when>
			<xsl:when test="$i = 1">
				<xsl:choose>
					<xsl:when test="$n = 1">
						<xsl:value-of select="$x"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="power">
							<xsl:with-param name="x">
								<xsl:value-of select="$x"/>
							</xsl:with-param>
							<xsl:with-param name="n">
								<xsl:value-of select="$n"/>
							</xsl:with-param>
							<xsl:with-param name="i">
								<xsl:value-of select="$i + 1"/>
							</xsl:with-param>
							<xsl:with-param name="result">
								<xsl:value-of select="$x"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$i = $n">
				<xsl:value-of select="$result * $x"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="power">
					<xsl:with-param name="x">
						<xsl:value-of select="$x"/>
					</xsl:with-param>
					<xsl:with-param name="n">
						<xsl:value-of select="$n"/>
					</xsl:with-param>
					<xsl:with-param name="i">
						<xsl:value-of select="$i + 1"/>
					</xsl:with-param>
					<xsl:with-param name="result">
						<xsl:value-of select="$result * $x"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- template : N! -->
	<xsl:template name="factorial">
		<xsl:param name="n"/>
		<xsl:param name="i">
			<xsl:value-of select="1"/>
		</xsl:param>
		<xsl:param name="result">
			<xsl:value-of select="1"/>
		</xsl:param>
		<xsl:choose>
			<xsl:when test="$n = 0">
				<xsl:value-of select="1"/>
			</xsl:when>
			<xsl:when test="$i = 1">
				<xsl:choose>
					<xsl:when test="$n = 1">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="factorial">
							<xsl:with-param name="n">
								<xsl:value-of select="$n"/>
							</xsl:with-param>
							<xsl:with-param name="i">
								<xsl:value-of select="$i + 1"/>
							</xsl:with-param>
							<xsl:with-param name="result">
								<xsl:value-of select="1"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$i = $n">
				<xsl:value-of select="$result * $i"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="factorial">
					<xsl:with-param name="n">
						<xsl:value-of select="$n"/>
					</xsl:with-param>
					<xsl:with-param name="i">
						<xsl:value-of select="$i + 1"/>
					</xsl:with-param>
					<xsl:with-param name="result">
						<xsl:value-of select="$result * $i"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="OfficeSettingsText">
		<!-- 关于SW中公共处理规则的相关子元素的处理 -->
		<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:文字处理_B66B/规则:文档设置_B600">
			<config:config-item-set config:name="ooo:view-settings">
				<config:config-item config:name="InBrowseMode" config:type="boolean">
					<xsl:choose>
						<xsl:when test="规则:当前视图_B601='web'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</config:config-item>
				<config:config-item config:name="ShowRedlineChanges" config:type="boolean">
					<!-- absent function xsl:choose>
						<xsl:when test="规则:是否修订_B605 = 'true'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose-->
					<xsl:value-of select="'true'"/>
				</config:config-item>
				<config:config-item-map-indexed config:name="Views">
					<config:config-item-map-entry>
						<xsl:if test="规则:缩放_B603">
							<config:config-item config:name="VisibleRight" config:type="int">1</config:config-item>
							<config:config-item config:name="VisibleBottom" config:type="int">1</config:config-item>
							<xsl:choose>
								<xsl:when test="string(规则:缩放_B603) = 'best-fit'">
									<config:config-item config:name="ZoomType" config:type="short">3</config:config-item>
								</xsl:when>
								<xsl:when test="string(规则:缩放_B603) = 'full-page'">
									<config:config-item config:name="ZoomType" config:type="short">2</config:config-item>
								</xsl:when>
								<xsl:when test="string(规则:缩放_B603) = 'text-fit'">
									<config:config-item config:name="ZoomType" config:type="short">1</config:config-item>
								</xsl:when>
								<xsl:otherwise>
									<config:config-item config:name="ZoomType" config:type="short">0</config:config-item>
								</xsl:otherwise>
							</xsl:choose>
							<config:config-item config:name="ZoomFactor" config:type="short">
								<xsl:value-of select="规则:缩放_B603"/>
							</config:config-item>
						</xsl:if>
					</config:config-item-map-entry>
				</config:config-item-map-indexed>
			</config:config-item-set>
			<config:config-item-set config:name="ooo:configuration-settings">
				<config:config-item-map-indexed config:name="ForbiddenCharacters">
					<config:config-item-map-entry>
						<config:config-item config:name="Language" config:type="string">zh</config:config-item>
						<config:config-item config:name="Country" config:type="string">CN</config:config-item>
						<config:config-item config:name="Variant" config:type="string"/>
						<config:config-item config:name="BeginLine" config:type="string">
							<xsl:choose>
								<xsl:when test="规则:标点禁则_B608/规则:行首字符_B609">
									<xsl:value-of select="规则:标点禁则_B608/规则:行首字符_B609"/>
								</xsl:when>
								<xsl:otherwise>:!),.:;?]}_'"、。〉》」』】〕〗〞︰︱︳﹐_﹒﹔﹕﹖﹗﹚﹜﹞！），．：；？｜｝︴︶︸︺︼︾﹀﹂﹄﹏_～￠々‖_·ˇˉ―--′</xsl:otherwise>
							</xsl:choose>
						</config:config-item>
						<config:config-item config:name="EndLine" config:type="string">
							<xsl:choose>
								<xsl:when test="规则:标点禁则_B608/规则:行尾字符_B60A">
									<xsl:value-of select="规则:标点禁则_B608/规则:行尾字符_B60A"/>
								</xsl:when>
								<xsl:otherwise>([{__'"‵〈《「『【〔〖（［｛￡￥〝︵︷︹︻︽︿﹁﹃﹙﹛﹝（｛</xsl:otherwise>
							</xsl:choose>
						</config:config-item>
					</config:config-item-map-entry>
				</config:config-item-map-indexed>
				<config:config-item config:name="AddExternalLeading" config:type="boolean">false</config:config-item>
				<!--<config:config-item config:name="AddParaTableSpacingAtStart" config:type="boolean">false</config:config-item>-->
				<config:config-item config:name="CharacterCompressionType" config:type="short">
					<xsl:choose>
						<!--<xsl:when test="string(规则:标点压缩_B60B/@是否采用_B60C) = 'true'">1</xsl:when>-->
						<xsl:when test="string(规则:字距调整是否用于西文和标点符号_B60B) = 'true'">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</config:config-item>
				<config:config-item config:name="CurrentDatabaseDataSource" config:type="string">
					<xsl:variable name="alignway">
						<xsl:value-of select="concat('!',../../字:分节_416A_416A[1]/字:节属性_421B/字:垂直对齐方式_4213,'#')"/>
					</xsl:variable>
					<xsl:variable name="view">
						<xsl:value-of select="concat(规则:当前视图_B601,'@')"/>
					</xsl:variable>
					<xsl:variable name="anthor">
						<xsl:value-of select="concat(../规则:批注集_B669/规则:批注_B66A[1]/@作者缩写_41DF,'%')"/>
					</xsl:variable>
					<xsl:variable name="pagesep">
						<xsl:value-of select="concat(../../字:分节_416A[1]/字:节属性_421B/字:页码设置_4205/@分隔符_4209,'*')"/>
					</xsl:variable>
					<xsl:variable name="pagetype">
						<xsl:value-of select="concat(../../字:分节_416A[1]/字:节属性_421B/字:节类型_41EA,'/')"/>
					</xsl:variable>
					<xsl:variable name="pinye">
						<xsl:value-of select="concat(../../字:分节_416A[1]/字:节属性_421B/字:是否拼页_41FE,'(')"/>
					</xsl:variable>
					<xsl:value-of select="concat($alignway,$view,$anthor,$pagesep,$pagetype,$pinye)"/>
				</config:config-item>
				<config:config-item config:name="IsKernAsianPunctuation" config:type="boolean">
					<xsl:choose>
						<xsl:when test="规则:字距调整_B606 = 'none'">false</xsl:when>
						<xsl:otherwise>true</xsl:otherwise>
					</xsl:choose>
				</config:config-item>
				<xsl:if test="../../字:文字处理文档_4225/字:分节_416A/字:节属性_421B/字:装订线_41FB">
					<xsl:variable name="pos">
						<xsl:value-of select="../../字:分节_416A/字:节属性_421B/字:装订线_41FB/@位置_4150"/>
					</xsl:variable>
					<xsl:variable name="val">
						<xsl:value-of select="../../字:分节_416A/字:节属性_421B/字:装订线_41FB/@距边界_41FC"/>
					</xsl:variable>
					<xsl:variable name="danwei">
						<xsl:value-of select="../../规则:公用处理规则_B665/规则:长度单位_B666"/>
					</xsl:variable>
					<xsl:variable name="mer">
						<xsl:value-of select="concat($val,$danwei)"/>
					</xsl:variable>
					<xsl:variable name="val0">
						<xsl:call-template name="convert2cm">
							<xsl:with-param name="value" select="$mer"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="name">
						<xsl:value-of select="concat($pos,'-',$val0)"/>
					</xsl:variable>
					<config:config-item config:name="PrintFaxName" config:type="string">
						<xsl:value-of select="$name"/>
					</config:config-item>
				</xsl:if>
			</config:config-item-set>
		</xsl:for-each>
		<!-- 关于SW中公共处理规则的相关子元素的处理 -->
	</xsl:template>
	<xsl:template name="default_seqence_declaration">
		<text:sequence-decls>
			<text:sequence-decl text:display-outline-level="0" text:name="Illustration"/>
			<text:sequence-decl text:display-outline-level="0" text:name="Table"/>
			<text:sequence-decl text:display-outline-level="0" text:name="Text"/>
			<text:sequence-decl text:display-outline-level="0" text:name="Drawing"/>
		</text:sequence-decls>
	</xsl:template>
	<xsl:template name="OneTrackChanges">
		<xsl:param name="type"/>
		<xsl:variable name="id" select="@标识符_4220"/>
		<xsl:variable name="ref" select="@修订信息引用_4222"/>
		<xsl:variable name="aid" select="/uof:UOF_0000/规则:公用处理规则_B665/规则:文字处理_B66B/规则:修订信息集_B60E/规则:修订信息_B60F[@标识符_B610=$ref]/@作者_B611"/>
		<xsl:variable name="sid" select="/uof:UOF_0000/规则:公用处理规则_B665/规则:用户集_B667/规则:用户_B668[@标识符_4100=$aid]/@姓名_41DC"/>
		<xsl:variable name="bid" select="/uof:UOF_0000/规则:公用处理规则_B665/规则:文字处理_B66B/规则:修订信息集_B60E/规则:修订信息_B60F[@标识符_B610=$ref]/@日期_B612"/>
		<text:changed-region text:id="{$id}">
			<xsl:choose>
				<xsl:when test="not(name(following-sibling::*[1])='字:修订结束_4223')">
					<xsl:choose>
						<xsl:when test="$type='insert'">
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
						<xsl:when test="$type='delete'">
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
						<xsl:when test="$type='format'">
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
					</xsl:choose>
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
		</text:changed-region>
	</xsl:template>
	<xsl:template name="GenerateTrackChanges">
		<xsl:if test="/uof:UOF_0000/规则:公用处理规则_B665/规则:文字处理_B66B/规则:文档设置_B600/规则:是否修订_B605 or //字:修订开始_421F">
			<text:tracked-changes>
				<xsl:if test="/uof:UOF_0000/规则:公用处理规则_B665/规则:文字处理_B66B/规则:文档设置_B600/规则:是否修订_B605">
					<xsl:attribute name="text:track-changes"><xsl:value-of select="/uof:UOF_0000/规则:公用处理规则_B665/规则:文字处理_B66B/规则:文档设置_B600/规则:是否修订_B605"/></xsl:attribute>
				</xsl:if>
				<xsl:for-each select="//字:段落_416B/字:修订开始_421F[@类型_4221='insert'] | //字:文字处理文档_4225/字:修订开始_421F[@类型_4221='insert']">
					<xsl:call-template name="OneTrackChanges">
						<xsl:with-param name="type" select="string('insert')"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="//字:段落_416B/字:修订开始_421F[@类型_4221='delete'] | //字:文字处理文档_4225/字:修订开始_421F[@类型_4221='delete']">
					<xsl:call-template name="OneTrackChanges">
						<xsl:with-param name="type" select="string('delete')"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="//字:段落_416B/字:修订开始_421F[@类型_4221='format'] | //字:文字处理文档_4225/字:修订开始_421F[@类型_4221='format']">
					<xsl:call-template name="OneTrackChanges">
						<xsl:with-param name="type" select="string('format')"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="//字:段落_416B/字:句_419D/字:修订开始_421F[@类型_4221='format']">
					<xsl:call-template name="OneTrackChanges">
						<xsl:with-param name="type" select="string('format')"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="//字:段落_416B/字:句_419D/字:修订开始_421F[@类型_4221='insert'] ">
					<xsl:call-template name="OneTrackChanges">
						<xsl:with-param name="type" select="string('insert')"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="//字:段落_416B/字:句_419D/字:修订开始_421F[@类型_4221='delete']">
					<xsl:call-template name="OneTrackChanges">
						<xsl:with-param name="type" select="string('delete')"/>
					</xsl:call-template>
				</xsl:for-each>
			</text:tracked-changes>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:文字处理文档_4225">
		<xsl:element name="office:body">
			<xsl:element name="office:text">
				<xsl:call-template name="default_seqence_declaration"/>
				<xsl:call-template name="GenerateTrackChanges"/>
				<!--xsl:for-each select="字:文字处理文档_4225"-->
				<xsl:call-template name="TextContent">
					<xsl:with-param name="content" select="."/>
				</xsl:call-template>
				<!--/xsl:for-each-->
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template name="CallExpandHatch">
		<xsl:if test="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/扩展:内容_B206[@名称='draw:hatch']">
			<xsl:for-each select="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/扩展:内容_B206[@名称='draw:hatch']/扩展:图案数据">
				<draw:hatch>
					<xsl:attribute name="draw:name"><xsl:value-of select="@uof:name"/></xsl:attribute>
					<xsl:attribute name="draw:display-name"><xsl:value-of select="@uof:display-name"/></xsl:attribute>
					<xsl:attribute name="draw:style"><xsl:value-of select="@uof:style"/></xsl:attribute>
					<xsl:attribute name="draw:color"><xsl:value-of select="@uof:color"/></xsl:attribute>
					<xsl:attribute name="draw:distance"><xsl:value-of select="@uof:distance"/></xsl:attribute>
					<xsl:attribute name="draw:rotation"><xsl:value-of select="@uof:rotation"/></xsl:attribute>
				</draw:hatch>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<!--xsl:template name="CallExpandMarker">
		<xsl:if test="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/扩展:内容_B206[@名称='draw:marker']">
			<xsl:for-each select="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/扩展:内容_B206[@名称='draw:marker']/*">
				<draw:marker>
					<xsl:attribute name="draw:name"><xsl:value-of select="@uof:name"/></xsl:attribute>
					<xsl:attribute name="draw:display-name"><xsl:value-of select="@uof:display-name"/></xsl:attribute>
					<xsl:attribute name="svg:viewBox"><xsl:value-of select="@svg:viewBox"/></xsl:attribute>
					<xsl:attribute name="svg:d"><xsl:value-of select="@svg:d"/></xsl:attribute>
				</draw:marker>
			</xsl:for-each>
		</xsl:if>
	</xsl:template-->
	<xsl:template name="CallExpandStroke">
		<xsl:if test="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/扩展:内容_B206[@名称='draw:stroke-dash']">
			<xsl:for-each select="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204/扩展:内容_B206[@名称='draw:stroke-dash']/扩展:线型数据">
				<draw:stroke-dash>
					<xsl:attribute name="draw:name"><xsl:value-of select="@uof:name"/></xsl:attribute>
					<xsl:attribute name="draw:display-name"><xsl:value-of select="@uof:display-name"/></xsl:attribute>
					<xsl:attribute name="draw:dots1"><xsl:value-of select="@uof:dots1"/></xsl:attribute>
					<xsl:attribute name="draw:dots2"><xsl:value-of select="@uof:dots1"/></xsl:attribute>
					<xsl:attribute name="draw:dots1-length"><xsl:value-of select="@uof:dots1-length"/></xsl:attribute>
					<xsl:attribute name="draw:dots2-length"><xsl:value-of select="@uof:dots2-length"/></xsl:attribute>
					<xsl:attribute name="draw:distance"><xsl:value-of select="@uof:distance"/></xsl:attribute>
				</draw:stroke-dash>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="FootnoteSetting">
		<xsl:element name="text:notes-configuration">
			<xsl:attribute name="text:note-class"><xsl:value-of select="'footnote'"/></xsl:attribute>
			<xsl:attribute name="text:master-page-name">Footnote</xsl:attribute>
			<xsl:for-each select="/uof:UOF_0000/字:文字处理文档_4225/字:分节_416A[1]/字:节属性_421B/字:脚注设置_4203">
				<xsl:attribute name="text:footnotes-position"><xsl:choose><xsl:when test="@位置_4150='page-bottom' or @位置_4150='below-text'">page</xsl:when><!--<xsl:otherwise>document</xsl:otherwise>--><xsl:otherwise>page</xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:attribute name="text:start-numbering-at"><xsl:choose><xsl:when test="@编号方式_4153='continuous'">document</xsl:when><xsl:when test="@编号方式_4153='section'">chapter</xsl:when><xsl:when test="@编号方式_4153='page'">page</xsl:when></xsl:choose></xsl:attribute>
				<xsl:attribute name="text:start-value"><xsl:value-of select="number(@起始编号_4152) - number(1)"/></xsl:attribute>
				<xsl:attribute name="style:num-format"><xsl:call-template name="NumberFormat"><xsl:with-param name="oo_format" select="@格式_4151"/></xsl:call-template></xsl:attribute>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="EndnoteSetting">
		<xsl:element name="text:notes-configuration">
			<xsl:attribute name="text:note-class">endnote</xsl:attribute>
			<xsl:attribute name="text:master-page-name">Endnote</xsl:attribute>
			<xsl:for-each select="/uof:UOF_0000/字:文字处理文档_4225/字:分节_416A[1]/字:节属性_421B/字:尾注设置_4204">
				<xsl:attribute name="style:num-format"><xsl:call-template name="NumberFormat"><xsl:with-param name="oo_format" select="@格式_4151"/></xsl:call-template></xsl:attribute>
				<xsl:attribute name="text:start-value"><xsl:value-of select="number(@起始编号_4152) - 1"/></xsl:attribute>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="LineNumbering">
		<xsl:for-each select="/uof:UOF_0000/字:文字处理文档_4225/字:分节_416A[1]/字:节属性_421B/字:行号设置_420A">
			<xsl:if test="@是否使用行号_420B='true'">
				<xsl:element name="text:linenumbering-configuration">
					<xsl:choose>
						<xsl:when test="@是否使用行号_420B='true'">
							<xsl:attribute name="text:number-lines">true</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="text:style-name">Line numbering</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@编号方式_4153">
						<xsl:choose>
							<xsl:when test="@编号方式_4153='section'">
								<xsl:attribute name="text:count-in-floating-frames">true</xsl:attribute>
							</xsl:when>
							<xsl:when test="@编号方式_4153='page'">
								<xsl:attribute name="text:restart-on-page">true</xsl:attribute>
							</xsl:when>
							<xsl:when test="编号方式_4153='continuous'">
								<xsl:attribute name="text:count-empty-lines">true</xsl:attribute>
							</xsl:when>
						</xsl:choose>
					</xsl:if>
					<!--
					<xsl:if test="@字:起始编号">
						<xsl:attribute name="style:num-format"><xsl:value-of select="@字:起始编号"/></xsl:attribute>
					</xsl:if>-->
					<!-- 行编号兼容eio 当永中设置距离文本为'自动'时,其默认距离为0.65cm-->
					<xsl:if test="@距边界_41F0">
						<xsl:attribute name="text:offset"><xsl:choose><xsl:when test="@距边界_41F0='0.0'">0.65cm</xsl:when><xsl:otherwise><xsl:value-of select="concat(@距边界_41F0,$uofUnit)"/></xsl:otherwise></xsl:choose></xsl:attribute>
					</xsl:if>
					<xsl:if test="@行号间隔_420D">
						<xsl:attribute name="text:increment"><xsl:value-of select="@行号间隔_420D"/></xsl:attribute>
					</xsl:if>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:function name="nsof:NeoShineOfficeID">
		<xsl:param name="CurNode"/>
		<xsl:for-each select="$CurNode">
			<xsl:variable name="curName" select="substring-after(name(),':')"/>
			<xsl:choose>
				<xsl:when test="$curName != '分节_416A'">
					<xsl:value-of select="concat($curName,'-',string(count(../../preceding-sibling::*[name() = '字:分节_416A']) + 1))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($curName,'-',string(count(preceding-sibling::*[name() = '字:分节_416A']) + 1))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:function>
	<xsl:template name="MasterStyleText">
		<xsl:for-each select="/uof:UOF_0000/字:文字处理文档_4225/字:分节_416A/字:节属性_421B">
			<xsl:variable name="sectname">
				<xsl:value-of select="nsof:NeoShineOfficeID(..)"/>
			</xsl:variable>
			<xsl:if test="字:是否首页页眉页脚不同_41EE='true' or 字:页码设置_4205/@字:首页显示 = 'false'">
				<style:master-page>
					<xsl:variable name="mname">
						<xsl:choose>
							<xsl:when test="字:是否首页页眉页脚不同_41EE='true'">
								<xsl:value-of select="nsof:NeoShineOfficeID(字:是否首页页眉页脚不同_41EE)"/>
							</xsl:when>
							<xsl:when test="字:页码设置_4205/@字:首页显示 = 'false'">
								<xsl:value-of select="nsof:NeoShineOfficeID(字:页码设置_4205)"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="style:name"><xsl:value-of select="$mname"/></xsl:attribute>
					<xsl:attribute name="style:page-layout-name"><xsl:value-of select="concat('layout-', $sectname)"/></xsl:attribute>
					<xsl:attribute name="style:display-name"><xsl:value-of select="$mname"/></xsl:attribute>
					<xsl:attribute name="style:next-style-name"><xsl:value-of select="$sectname"/></xsl:attribute>
					<xsl:if test="字:页眉_41F3/字:首页页眉_41F6 or 字:页脚_41F7/字:首页页脚_41FA">
						<xsl:choose>
							<xsl:when test="字:页眉_41F3/字:首页页眉_41F6">
								<style:header>
									<xsl:call-template name="TextContent">
										<xsl:with-param name="content" select="字:页眉_41F3/字:首页页眉_41F6"/>
									</xsl:call-template>
								</style:header>
							</xsl:when>
							<xsl:otherwise>
								<style:header>
									<xsl:variable name="parastyle" select="key('uof-paragraph-styles',字:段落属性_419B/@式样引用_419C)"/>
									<xsl:variable name="level">
										<xsl:choose>
											<xsl:when test="$document_type = 'presentation'">
												<xsl:variable name="graphid" select="ancestor::图形:图形集_7C00/图:图形_8062/@标识符_804B"/>
												<xsl:choose>
													<xsl:when test="key('rel_graphic_name',$graphid)/uof:占位符_C626/@类型_C627='outline'">
														<xsl:variable name="outlinelevel">
															<xsl:choose>
																<xsl:when test="./字:段落属性_419B/字:大纲级别_417C">
																	<xsl:value-of select="./字:段落属性_419B/字:大纲级别_417C"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:call-template name="LevelInOutline">
																		<xsl:with-param name="parastyle" select="$parastyle"/>
																	</xsl:call-template>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:variable>
														<xsl:choose>
															<xsl:when test="$outlinelevel='F'">
																<xsl:call-template name="LevelInNumber">
																	<xsl:with-param name="parastyle" select="$parastyle"/>
																</xsl:call-template>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$outlinelevel"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<xsl:call-template name="LevelInNumber">
															<xsl:with-param name="parastyle" select="$parastyle"/>
														</xsl:call-template>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="LevelInNumber">
													<xsl:with-param name="parastyle" select="$parastyle"/>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="stylename">
										<xsl:choose>
											<xsl:when test="number($level) &gt; 0">
												<xsl:choose>
													<xsl:when test="./字:段落属性_419B/字:自动编号信息_4186/@编号引用_4187">
														<xsl:value-of select="字:段落属性_419B/字:自动编号信息_4186/@编号引用_4187"/>
													</xsl:when>
													<xsl:when test="$parastyle/字:自动编号信息_4186/@编号引用_4187">
														<xsl:value-of select="$parastyle/字:自动编号信息_4186/@编号引用_4187"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:for-each select="key('uof-number-styles',字:段落属性_419B/@式样引用_419C)">
															<xsl:value-of select="../@标识符_4169"/>
														</xsl:for-each>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
										</xsl:choose>
									</xsl:variable>
									<text:p text:style-name="{$stylename}"/>
								</style:header>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="字:页脚_41F7/字:首页页脚_41FA">
								<style:footer>
									<xsl:call-template name="TextContent">
										<xsl:with-param name="content" select="字:页脚_41F7/字:首页页脚_41FA"/>
									</xsl:call-template>
								</style:footer>
							</xsl:when>
							<xsl:otherwise>
								<style:footer>
									<text:p text:style-name="Standard"/>
								</style:footer>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</style:master-page>
			</xsl:if>
			<xsl:element name="style:master-page">
				<xsl:attribute name="style:name"><xsl:value-of select="$sectname"/></xsl:attribute>
				<xsl:attribute name="style:page-layout-name"><xsl:value-of select="concat('layout-', $sectname)"/></xsl:attribute>
				<xsl:attribute name="style:display-name"><xsl:value-of select="$sectname"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="字:是否奇偶页页眉页脚不同_41ED='true'">
						<xsl:if test="字:页眉_41F3/字:奇数页页眉_41F4 or 字:页眉_41F3/字:偶数页页眉_41F5">
							<xsl:choose>
								<xsl:when test="字:页眉_41F3/字:奇数页页眉_41F4">
									<style:header>
										<xsl:call-template name="TextContent">
											<xsl:with-param name="content" select="字:页眉_41F3/字:奇数页页眉_41F4"/>
										</xsl:call-template>
									</style:header>
								</xsl:when>
								<xsl:otherwise>
									<style:header>
										<text:p text:style-name="Standard"/>
									</style:header>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="字:页眉_41F3/字:偶数页页眉_41F5">
									<style:header-left>
										<xsl:call-template name="TextContent">
											<xsl:with-param name="content" select="字:页眉_41F3/字:偶数页页眉_41F5"/>
										</xsl:call-template>
									</style:header-left>
								</xsl:when>
								<xsl:otherwise>
									<style:header-left>
										<text:p text:style-name="Standard"/>
									</style:header-left>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="字:页脚_41F7/字:奇数页页脚_41F8 or 字:页脚_41F7/字:偶数页页脚_41F9">
							<xsl:choose>
								<xsl:when test="字:页脚_41F7/字:奇数页页脚_41F8">
									<style:footer>
										<xsl:call-template name="TextContent">
											<xsl:with-param name="content" select="字:页脚_41F7/字:奇数页页脚_41F8"/>
										</xsl:call-template>
									</style:footer>
								</xsl:when>
								<xsl:otherwise>
									<style:footer>
										<text:p text:style-name="Standard"/>
									</style:footer>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="字:页脚_41F7/字:偶数页页脚_41F9">
									<style:footer-left>
										<xsl:call-template name="TextContent">
											<xsl:with-param name="content" select="字:页脚_41F7/字:偶数页页脚_41F9"/>
										</xsl:call-template>
									</style:footer-left>
								</xsl:when>
								<xsl:otherwise>
									<style:footer-left>
										<text:p text:style-name="Standard"/>
									</style:footer-left>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="字:页眉_41F3/字:奇数页页眉_41F4">
							<style:header>
								<xsl:call-template name="TextContent">
									<xsl:with-param name="content" select="字:页眉_41F3/字:奇数页页眉_41F4"/>
								</xsl:call-template>
							</style:header>
						</xsl:if>
						<xsl:if test="字:页脚_41F7/字:奇数页页脚_41F8">
							<style:footer>
								<xsl:call-template name="TextContent">
									<xsl:with-param name="content" select="字:页脚_41F7/字:奇数页页脚_41F8"/>
								</xsl:call-template>
							</style:footer>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="OneColumn">
		<xsl:param name="onewidth"/>
		<xsl:param name="gap"/>
		<xsl:param name="count"/>
		<xsl:param name="pos"/>
		<xsl:if test="not($pos &gt; $count)">
			<xsl:element name="style:column">
				<xsl:attribute name="style:rel-width"><xsl:value-of select="concat($onewidth, '*')"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="$pos = 1">
						<xsl:attribute name="fo:start-indent">0cm</xsl:attribute>
						<xsl:attribute name="fo:end-indent"><xsl:value-of select="concat(number($gap) * 0.5,$uofUnit)"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="$pos = $count">
						<xsl:attribute name="fo:start-indent"><xsl:value-of select="concat(number($gap) * 0.5,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="fo:end-indent">0cm</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="fo:start-indent"><xsl:value-of select="concat(number($gap) * 0.5,$uofUnit)"/></xsl:attribute>
						<xsl:attribute name="fo:end-indent"><xsl:value-of select="concat(number($gap) * 0.5,$uofUnit)"/></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:call-template name="OneColumn">
				<xsl:with-param name="onewidth" select="$onewidth"/>
				<xsl:with-param name="gap" select="$gap"/>
				<xsl:with-param name="count" select="$count"/>
				<xsl:with-param name="pos" select="$pos+1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:分栏_4215">
		<xsl:param name="bodywidth"/>
		<xsl:element name="style:columns">
			<xsl:attribute name="fo:column-count"><xsl:value-of select="字:栏数_41E8"/></xsl:attribute>
			<xsl:variable name="aa" select="字:栏_41E0[position()=1]/@间距_41E2"/>
			<xsl:if test="字:是否等宽_41E9='true' ">
				<xsl:attribute name="fo:column-gap"><xsl:value-of select="concat($aa,$uofUnit)"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="字:分隔线_41E3/@分隔线线型_41E4 != '' and 字:分隔线_41E3/@分隔线线型_41E4 != 'none'">
				<xsl:element name="style:column-sep">
					<xsl:choose>
						<xsl:when test="字:分隔线_41E3/@分隔线宽度_41E6 != ''">
							<xsl:attribute name="style:width"><xsl:value-of select="concat(字:分隔线_41E3/@分隔线宽度_41E6,$uofUnit)"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="style:color"><xsl:value-of select="'#000000'"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="字:分隔线_41E3/@分隔线颜色_41E7 != ''">
							<xsl:attribute name="style:color"><xsl:value-of select="字:分隔线_41E3/@分隔线颜色_41E7"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="style:color"><xsl:value-of select="'0.002cm'"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<!-- 以下属性uof没有,其中style:vertical-align是require的 -->
					<xsl:attribute name="style:height">100%</xsl:attribute>
					<xsl:attribute name="style:vertical-align">top</xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:variable name="bodywidthtwips" select="number(($bodywidth * $other-to-cm-conversion-factor * 1440) div 2.54)"/>
			<xsl:variable name="count" select="字:栏数_41E8"/>
			<xsl:choose>
				<xsl:when test="字:是否等宽_41E9 and (字:是否等宽_41E9='true')">
					<xsl:variable name="onewidth" select="number($bodywidthtwips div $count)"/>
					<xsl:variable name="gap">
						<xsl:choose>
							<xsl:when test="字:栏_41E0[1]/@间距_41E2">
								<xsl:value-of select="number(字:栏_41E0[1]/@间距_41E2)"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:call-template name="OneColumn">
						<xsl:with-param name="onewidth" select="round($onewidth)"/>
						<xsl:with-param name="gap" select="$gap"/>
						<xsl:with-param name="count" select="$count"/>
						<xsl:with-param name="pos" select="1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="字:栏_41E0">
						<xsl:element name="style:column">
							<xsl:variable name="width" select="number(@宽度_41E1)"/>
							<xsl:variable name="gap1">
								<xsl:choose>
									<xsl:when test="position() = 1">0</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="number(preceding-sibling::字:栏_41E0[1]/@间距_41E2) div 2"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="gap2">
								<xsl:choose>
									<xsl:when test="position() = last()">0</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="number(@间距_41E2) div 2"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="onewidth" select="round(($width + $gap1 + $gap2) div $bodywidth * $bodywidthtwips)"/>
							<xsl:attribute name="style:rel-width"><xsl:value-of select="concat($onewidth, '*')"/></xsl:attribute>
							<xsl:attribute name="fo:start-indent"><xsl:value-of select="concat($gap1,$uofUnit)"/></xsl:attribute>
							<xsl:attribute name="fo:end-indent"><xsl:value-of select="concat($gap2,$uofUnit)"/></xsl:attribute>
						</xsl:element>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template match="字:填充_4134" mode="textpage">
		<xsl:call-template name="CommonFill"/>
	</xsl:template>
	<xsl:template match="字:边框_4133" mode="textpage">
		<xsl:if test="@阴影类型_C645 and @阴影类型_C645 !='' and @阴影类型_C645 !='none'">
			<xsl:choose>
				<xsl:when test="@阴影类型_C645 = 'right-bottom'">
					<xsl:attribute name="style:shadow">#808080 5pt 5pt</xsl:attribute>
				</xsl:when>
				<xsl:when test="@阴影类型_C645 = 'right-top'">
					<xsl:attribute name="style:shadow">#808080 5pt -5pt</xsl:attribute>
				</xsl:when>
				<xsl:when test="@阴影类型_C645 = 'left-bottom'">
					<xsl:attribute name="style:shadow">#808080 -5pt 5pt</xsl:attribute>
				</xsl:when>
				<xsl:when test="@阴影类型_C645 = 'left-top'">
					<xsl:attribute name="style:shadow">#808080 -5pt -5pt</xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:call-template name="CommonBorder">
			<xsl:with-param name="pUp" select="uof:上_C614"/>
			<xsl:with-param name="pDown" select="uof:下_C616"/>
			<xsl:with-param name="pLeft" select="uof:左_C613"/>
			<xsl:with-param name="pRight" select="uof:右_C615"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="字:页码设置_4205">
		<xsl:variable name="format">
			<xsl:call-template name="NumberFormat">
				<xsl:with-param name="oo_format" select="@格式_4151"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:attribute name="style:num-format"><xsl:value-of select="$format"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="字:网格设置_420E">
		<xsl:param name="bodywidth"/>
		<xsl:param name="bodyheight"/>
		<xsl:if test="@网格类型_420F">
			<xsl:attribute name="style:layout-grid-mode"><xsl:choose><xsl:when test="@网格类型_420F='line-char'">both</xsl:when><xsl:when test="@网格类型_420F='char'">both</xsl:when><xsl:when test="@网格类型_420F='line'">line</xsl:when><xsl:when test="@网格类型_420F='none'">none</xsl:when></xsl:choose></xsl:attribute>
		</xsl:if>
		<xsl:if test="@网格类型_420F = 'char'">
			<xsl:attribute name="style:layout-grid-snap-to-characters">true</xsl:attribute>
		</xsl:if>
		<xsl:if test="@网格类型_420F = 'line-char'">
			<xsl:attribute name="style:layout-grid-snap-to-characters">false</xsl:attribute>
		</xsl:if>
		<xsl:variable name="IsType">
			<xsl:choose>
				<xsl:when test="@字符数_4228 &lt; 1 or @行数_4210 &lt; 1">
					<xsl:value-of select="'WrongUOFType'"/>
				</xsl:when>
				<!--xsl:when test="@字:宽度 = '10.50' or @字:高度 = '15.60'">
					<xsl:value-of select="'WrongUOFType'"/>
				</xsl:when>
				<xsl:when test="@字:宽度 = '10.5' or @字:高度 = '15.6'">
					<xsl:value-of select="'WrongUOFType'"/>
				</xsl:when>
				<xsl:when test="@字:宽度 = '10.50' or @字:高度 = '15.06'">
					<xsl:value-of select="'WrongUOFType'"/>
				</xsl:when-->
				<xsl:otherwise>
					<xsl:value-of select="'UOFType'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- SPECIAL -->
		<xsl:choose>
			<xsl:when test="$IsType = 'WrongUOFType'">
				<xsl:attribute name="style:layout-grid-base-width"><xsl:value-of select="concat(number(@字符数_4228),$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="style:layout-grid-lines"><xsl:value-of select="floor(($bodyheight) div number(@行数_4210))"/></xsl:attribute>
				<xsl:attribute name="style:layout-grid-base-height"><xsl:value-of select="concat(number(@行数_4210),$uofUnit)"/></xsl:attribute>
			</xsl:when>
			<xsl:when test="$IsType = 'UOFType'">
				<xsl:variable name="modnum" select="number(1.0015)"/>
				<xsl:variable name="gridwidth" select="$bodywidth div ceiling(@字符数_4228) div $modnum"/>
				<xsl:variable name="gridheight" select="$bodyheight div ceiling(@行数_4210) div $modnum"/>
				<xsl:variable name="gridline" select=" ceiling(@行数_4210)"/>
				<xsl:if test="@字符数_4228 and @网格类型_420F != 'none' and @网格类型_420F != 'line'">
					<xsl:attribute name="style:layout-grid-base-width"><xsl:value-of select="concat($gridwidth,$uofUnit)"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="@行数_4210 and @网格类型_420F != 'none'">
					<xsl:attribute name="style:layout-grid-lines"><xsl:value-of select="floor($gridline)"/></xsl:attribute>
					<xsl:attribute name="style:layout-grid-base-height"><xsl:value-of select="concat($gridheight,$uofUnit)"/></xsl:attribute>
					<!--xsl:attribute name="style:layout-grid-base-height"><xsl:value-of select="concat($gridheight * $other-to-cm-conversion-factor, 'cm')"/></xsl:attribute-->
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<xsl:attribute name="style:layout-grid-ruby-height"><xsl:value-of select="concat(0,$uofUnit)"/></xsl:attribute>
		<xsl:if test="@是否显示网格_4211 = 'false'">
			<xsl:attribute name="style:layout-grid-display">false</xsl:attribute>
		</xsl:if>
		<xsl:if test="@是否打印网格_4212 = 'false' or not(@是否打印网格_4212)">
			<xsl:attribute name="style:layout-grid-print">false</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="字:稿纸设置_4216">
		<xsl:param name="bodywidth"/>
		<xsl:param name="bodyheight"/>
		<xsl:if test="@格式_4217">
			<xsl:choose>
				<xsl:when test="@类型_4173='draft-paper'">
					<xsl:variable name="row">
						<xsl:choose>
							<xsl:when test="@格式_4217 = 'first-gear'">10.2</xsl:when>
							<xsl:when test="@格式_4217 = 'second-gear'">15.008</xsl:when>
							<xsl:when test="@格式_4217 = 'third-gear'">20</xsl:when>
							<xsl:when test="@格式_4217 = 'fourth-gear'">20.2</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="layout-grid-lines">
						<xsl:choose>
							<xsl:when test="@格式_4217 = 'first-gear'">10</xsl:when>
							<xsl:when test="@格式_4217 = 'second-gear'">15</xsl:when>
							<xsl:when test="@格式_4217 = 'third-gear'">20</xsl:when>
							<xsl:when test="@格式_4217 = 'fourth-gear'">20</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="column">
						<xsl:choose>
							<xsl:when test="@格式_4217 = 'first-gear'">20.05</xsl:when>
							<xsl:when test="@格式_4217 = 'second-gear'">20.05</xsl:when>
							<xsl:when test="@格式_4217 = 'third-gear'">20.05</xsl:when>
							<xsl:when test="@格式_4217 = 'fourth-gear'">25.02</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="basewidth">
						<xsl:value-of select="number($bodywidth) div number($column)"/>
					</xsl:variable>
					<xsl:variable name="allheight">
						<xsl:variable name="allheight1">
							<xsl:value-of select="number($bodyheight) div (number($layout-grid-lines) + 1)"/>
						</xsl:variable>
						<xsl:variable name="allheight2">
							<xsl:value-of select="number($bodyheight) div number($layout-grid-lines)"/>
						</xsl:variable>
						<xsl:value-of select="($allheight1 + $allheight2) * 0.5"/>
					</xsl:variable>
					<xsl:variable name="rubyheight">
						<xsl:value-of select="number($allheight) - number($basewidth)"/>
					</xsl:variable>
					<xsl:attribute name="style:layout-grid-base-width"><xsl:value-of select="concat($basewidth,$uofUnit)"/></xsl:attribute>
					<xsl:attribute name="style:layout-grid-base-height"><xsl:value-of select="concat($basewidth,$uofUnit)"/></xsl:attribute>
					<xsl:attribute name="style:layout-grid-ruby-height"><xsl:value-of select="concat($rubyheight,$uofUnit)"/></xsl:attribute>
					<xsl:attribute name="style:layout-grid-lines" select="$layout-grid-lines"/>
					<xsl:attribute name="style:layout-grid-mode">both</xsl:attribute>
					<xsl:attribute name="style:layout-grid-display">true</xsl:attribute>
					<xsl:attribute name="style:layout-grid-print">true</xsl:attribute>
				</xsl:when>
				<xsl:when test="@类型_4173='letter-paper'">
					<xsl:variable name="RubyHeight">
						<xsl:choose>
							<xsl:when test="@线型_4218='single-line'">0</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number(0.1 div $other-to-cm-conversion-factor)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="layout-grid-lines">
						<xsl:choose>
							<xsl:when test="@格式_4217 = 'first-gear'">10</xsl:when>
							<xsl:when test="@格式_4217 = 'second-gear'">15</xsl:when>
							<xsl:when test="@格式_4217 = 'third-gear'">20</xsl:when>
							<xsl:when test="@格式_4217 = 'fourth-gear'">24</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="row">
						<xsl:choose>
							<xsl:when test="@格式_4217 = 'first-gear'">10.004</xsl:when>
							<xsl:when test="@格式_4217 = 'second-gear'">15.008</xsl:when>
							<xsl:when test="@格式_4217 = 'third-gear'">20.03</xsl:when>
							<xsl:when test="@格式_4217 = 'fourth-gear'">24.01</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="layout-grid-base-height" select="($bodyheight div number($row)) - number($RubyHeight)"/>
					<xsl:attribute name="style:layout-grid-base-height"><xsl:value-of select="concat($layout-grid-base-height,$uofUnit)"/></xsl:attribute>
					<xsl:attribute name="style:layout-grid-ruby-height"><xsl:value-of select="concat($RubyHeight,$uofUnit)"/></xsl:attribute>
					<xsl:attribute name="style:layout-grid-lines"><xsl:value-of select="$layout-grid-lines"/></xsl:attribute>
					<xsl:attribute name="style:layout-grid-mode">line</xsl:attribute>
					<xsl:attribute name="style:layout-grid-display">true</xsl:attribute>
					<xsl:attribute name="style:layout-grid-print">true</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="@颜色_4219">
				<xsl:attribute name="style:layout-grid-color"><xsl:value-of select="@颜色_4219"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@方向_421A">
				<xsl:variable name="direction">
					<xsl:choose>
						<xsl:when test="string(@方向_421A)='hori-l2r'">lr-tb</xsl:when>
						<xsl:when test="string(@方向_421A)='hori-r2l'">tb-lr</xsl:when>
						<xsl:when test="string(@方向_421A)='vert-l2r'">tb-lr</xsl:when>
						<xsl:when test="string(@方向_421A)='vert-r2l'">tb-rl</xsl:when>
						<xsl:otherwise>page</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="style:writing-mode"><xsl:value-of select="$direction"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="GetPageWidth">
		<xsl:choose>
			<xsl:when test="字:纸张_41EC/@宽_C605">
				<xsl:value-of select="字:纸张_41EC/@宽_C605"/>
			</xsl:when>
			<xsl:when test="字:纸张方向_41FF = 'portrait'">
				<xsl:variable name="widthcm">
					<xsl:choose>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'A3'">29.7</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'A4'">21.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'A5'">14.8</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'B4'">25.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'B5'">17.6</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'letter-small'">21.59</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'letter'">21.59</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'PRC-16K'">18.4</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'PRC-32K'">13.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'PRC-32K(Big)'">14.0</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="number($widthcm) div $other-to-cm-conversion-factor"/>
			</xsl:when>
			<xsl:when test="字:纸张方向_41FF = 'landscape'">
				<xsl:variable name="widthcm">
					<xsl:choose>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'A3'">42.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'A4'">29.7</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'A5'">21.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'B4'">35.3</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'B5'">25.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'letter-small'">35.57</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'letter'">27.94</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'PRC-16K'">26.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'PRC-32K'">18.4</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'PRC-32K(Big)'">20.3</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="number($widthcm) div $other-to-cm-conversion-factor"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetPageHeight">
		<xsl:choose>
			<xsl:when test="字:纸张_41EC/@长_C604">
				<xsl:value-of select="字:纸张_41EC/@长_C604"/>
			</xsl:when>
			<xsl:when test="字:纸张方向_41FF = 'portrait'">
				<xsl:variable name="heightcm">
					<xsl:choose>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'A3'">42.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'A4'">29.7</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'A5'">21.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'B4'">35.3</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'B5'">25.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'letter-small'">35.57</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'letter'">27.94</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'PRC-16K'">26.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'PRC-32K'">18.4</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'PRC-32K(Big)'">20.3</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="number($heightcm) div $other-to-cm-conversion-factor"/>
			</xsl:when>
			<xsl:when test="字:纸张方向_41FF = 'landscape'">
				<xsl:variable name="heightcm">
					<xsl:choose>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'A3'">29.7</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'A4'">21.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'A5'">14.8</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'B4'">25.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'B5'">17.6</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'letter-small'">21.59</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'letter'">21.59</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'PRC-16K'">18.4</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'PRC-32K'">13.0</xsl:when>
						<xsl:when test="字:纸张_41EC/@纸型_C60C = 'PRC-32K(Big)'">14.0</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="number($heightcm) div $other-to-cm-conversion-factor"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="PageLayoutStyle">
		<xsl:for-each select="/uof:UOF_0000/字:文字处理文档_4225/字:分节_416A/字:节属性_421B">
			<!--
			<xsl:variable name="sectname">
				<xsl:choose>
					<xsl:when test="../@字:名称">
						<xsl:value-of select="../@字:名称"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="generate-id(..)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>-->
			<xsl:variable name="sectname">
				<xsl:value-of select="nsof:NeoShineOfficeID(..)"/>
			</xsl:variable>
			<xsl:if test="(position()&gt;1) or ((position() = 1) and ($sectname != 'RoStandard'))">
				<xsl:element name="style:page-layout">
					<xsl:variable name="margintop">
						<xsl:choose>
							<xsl:when test="字:页边距_41EB/@上_C609">
								<xsl:value-of select="字:页边距_41EB/@上_C609"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="convert2cm">
									<xsl:with-param name="value" select="'72pt'"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="marginbottom">
						<xsl:choose>
							<xsl:when test="字:页边距_41EB/@下_C60B">
								<xsl:value-of select="字:页边距_41EB/@下_C60B"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="convert2cm">
									<xsl:with-param name="value" select="'72pt'"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="marginleft">
						<xsl:choose>
							<xsl:when test="字:页边距_41EB/@左_C608">
								<xsl:value-of select="字:页边距_41EB/@左_C608"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="convert2cm">
									<xsl:with-param name="value" select="'90pt'"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="marginright">
						<xsl:choose>
							<xsl:when test="字:页边距_41EB/@右_C60A">
								<xsl:value-of select="字:页边距_41EB/@右_C60A"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="convert2cm">
									<xsl:with-param name="value" select="'90pt'"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="padtop">
						<xsl:choose>
							<xsl:when test="字:边框_4133/uof:上_C614/@边距_C610">
								<xsl:value-of select="字:边框_4133/uof:上_C614/@边距_C610"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number(0)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="padbottom">
						<xsl:choose>
							<xsl:when test="字:边框_4133/uof:下_C616/@边距_C610">
								<xsl:value-of select="字:边框_4133/uof:下_C616/@边距_C610"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number(0)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="padleft">
						<xsl:choose>
							<xsl:when test="字:边框_4133/uof:左_C613/@边距_C610">
								<xsl:value-of select="字:边框_4133/uof:左_C613/@边距_C610"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number(0)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="padright">
						<xsl:choose>
							<xsl:when test="字:边框_4133/uof:右_C615/@边距_C610">
								<xsl:value-of select="字:边框_4133/uof:右_C615/@边距_C610"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number(0)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="headerpos">
						<xsl:choose>
							<xsl:when test="字:页眉位置_41EF/@距边界_41F0">
								<xsl:value-of select="字:页眉位置_41EF/@距边界_41F0"/>
							</xsl:when>
							<xsl:when test="字:页眉位置_41EF/@距版芯_41F1">
								<xsl:value-of select="number($margintop)-number(字:页眉位置_41EF/@距版芯_41F1)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number(0)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="footerpos">
						<xsl:choose>
							<xsl:when test="字:页脚位置_41F2/@距边界_41F0">
								<xsl:value-of select="字:页脚位置_41F2/@距边界_41F0"/>
							</xsl:when>
							<xsl:when test="字:页脚位置_41F2/@距版芯_41F1">
								<xsl:value-of select="number($marginbottom)-number(字:页脚位置_41F2/@距版芯_41F1)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number(0)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="style:name"><xsl:value-of select="concat('layout-', $sectname)"/></xsl:attribute>
					<xsl:if test="字:是否对称页边距_41FD='true' or 字:是否对称页边距_41FD='1'">
						<xsl:attribute name="style:page-usage">mirrored</xsl:attribute>
					</xsl:if>
					<xsl:element name="style:page-layout-properties">
						<xsl:if test="字:纸张方向_41FF">
							<xsl:attribute name="style:print-orientation"><xsl:value-of select="字:纸张方向_41FF"/></xsl:attribute>
						</xsl:if>
						<xsl:variable name="direction">
							<xsl:choose>
								<xsl:when test="string(字:文字排列方向_4214)='t2b-l2r-0e-0w'">lr-tb</xsl:when>
								<xsl:when test="string(字:文字排列方向_4214)='t2b-r2l-0e-0w'">rl-tb</xsl:when>
								<xsl:when test="string(字:文字排列方向_4214)='t2b-r2l-0e-90w'">rl-tb</xsl:when>
								<xsl:when test="string(字:文字排列方向_4214)='r2l-t2b-90e-90w'">tb-rl</xsl:when>
								<xsl:when test="string(字:文字排列方向_4214)='r2l-t2b-0e-90w'">tb-rl</xsl:when>
								<xsl:when test="string(字:文字排列方向_4214)='l2r-b2t-270e-270w'">tb-lr</xsl:when>
								<xsl:otherwise>page</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:attribute name="style:writing-mode"><xsl:value-of select="$direction"/></xsl:attribute>
						<xsl:variable name="pagewidth">
							<xsl:call-template name="GetPageWidth"/>
						</xsl:variable>
						<xsl:variable name="pageheight">
							<xsl:call-template name="GetPageHeight"/>
						</xsl:variable>
						<xsl:attribute name="fo:page-width"><xsl:value-of select="concat(number($pagewidth), $uofUnit)"/></xsl:attribute>
						<xsl:attribute name="fo:page-height"><xsl:value-of select="concat(number($pageheight), $uofUnit)"/></xsl:attribute>
						<xsl:choose>
							<xsl:when test="$headerpos=0 and $padtop=0">
								<xsl:attribute name="fo:margin-top"><xsl:value-of select="concat($margintop,$uofUnit)"/></xsl:attribute>
							</xsl:when>
							<xsl:when test="$padtop=0">
								<xsl:attribute name="fo:margin-top"><xsl:value-of select="concat($headerpos,$uofUnit)"/></xsl:attribute>
							</xsl:when>
							<xsl:when test="$headerpos=0">
								<xsl:attribute name="fo:margin-top"><xsl:value-of select="concat($margintop - $padtop,$uofUnit)"/></xsl:attribute>
								<xsl:attribute name="fo:padding-top"><xsl:value-of select="concat($margintop - $padtop,$uofUnit)"/></xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$headerpos &lt; $padtop">
										<xsl:attribute name="fo:margin-top"><xsl:value-of select="concat($headerpos,$uofUnit)"/></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="fo:margin-top"><xsl:value-of select="concat($headerpos - $padtop,$uofUnit)"/></xsl:attribute>
										<xsl:attribute name="fo:padding-top"><xsl:value-of select="concat($headerpos - $padtop,$uofUnit)"/></xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="$footerpos=0 and $padbottom=0">
								<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat($marginbottom,$uofUnit)"/></xsl:attribute>
							</xsl:when>
							<xsl:when test="$padtop=0">
								<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat($footerpos,$uofUnit)"/></xsl:attribute>
							</xsl:when>
							<xsl:when test="$footerpos=0">
								<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat($marginbottom - $padbottom,$uofUnit)"/></xsl:attribute>
								<xsl:attribute name="fo:padding-bottom"><xsl:value-of select="concat($marginbottom - $padbottom,$uofUnit)"/></xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$footerpos &lt; $padbottom">
										<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat($footerpos,$uofUnit)"/></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat($footerpos - $padbottom,$uofUnit)"/></xsl:attribute>
										<xsl:attribute name="fo:padding-bottom"><xsl:value-of select="concat($footerpos - $padbottom,$uofUnit)"/></xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="$padleft=0">
								<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat($marginleft,$uofUnit)"/></xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat($marginleft - $padleft,$uofUnit)"/></xsl:attribute>
								<xsl:attribute name="fo:padding-left"><xsl:value-of select="concat($marginleft - $padleft,$uofUnit)"/></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="$padright=0">
								<xsl:attribute name="fo:margin-right"><xsl:value-of select="concat($marginright,$uofUnit)"/></xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="fo:margin-right"><xsl:value-of select="concat($marginright - $padright,$uofUnit)"/></xsl:attribute>
								<xsl:attribute name="fo:padding-right"><xsl:value-of select="concat($marginright - $padright,$uofUnit)"/></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="字:装订线_41FB/@位置_4150">
							<xsl:attribute name="style:gutter-location"><xsl:value-of select="字:装订线_41FB/@位置_4150"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="字:装订线_41FB/@距边界_41FC">
							<xsl:attribute name="style:gutter-margin"><xsl:value-of select="concat(字:装订线_41FB/@距边界_41FC,$uofUnit)"/></xsl:attribute>
						</xsl:if>
						<xsl:variable name="bodywidth">
							<xsl:value-of select="number($pagewidth) - number($marginleft) - number($marginright)"/>
						</xsl:variable>
						<xsl:variable name="bodyheight">
							<xsl:value-of select="number($pageheight) - number($margintop) - number($marginbottom)"/>
						</xsl:variable>
						<xsl:if test="字:边框_4133">
							<xsl:apply-templates select="字:边框_4133" mode="textpage">
								<xsl:with-param name="bodywidth" select="$bodywidth"/>
							</xsl:apply-templates>
						</xsl:if>
						<xsl:if test="字:纸张来源_4200/@其他页_4202">
							<xsl:attribute name="style:paper-tray-name"><xsl:value-of select="字:纸张来源_4200/@其他页_4202"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="字:网格设置_420E">
							<xsl:apply-templates select="字:网格设置_420E">
								<xsl:with-param name="bodywidth" select="$bodywidth"/>
								<xsl:with-param name="bodyheight" select="$bodyheight"/>
							</xsl:apply-templates>
						</xsl:if>
						<xsl:if test="字:垂直对齐方式_4213">
							<xsl:attribute name="style:vertical-align"><xsl:value-of select="字:垂直对齐方式_4213"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="字:稿纸设置_4216">
							<xsl:apply-templates select="字:稿纸设置_4216">
								<xsl:with-param name="bodywidth">
									<xsl:choose>
										<xsl:when test="字:稿纸设置_4216/@方向_421A = 'hori-l2r'">
											<xsl:value-of select="$bodywidth"/>
										</xsl:when>
										<xsl:when test="字:稿纸设置_4216/@方向_421A = 'hori-r2l'">
											<xsl:value-of select="$bodyheight"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$bodywidth"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="bodyheight">
									<xsl:choose>
										<xsl:when test="字:稿纸设置_4216/@方向_421A = 'hori-l2r'">
											<xsl:value-of select="$bodyheight"/>
										</xsl:when>
										<xsl:when test="字:稿纸设置_4216/@方向_421A = 'hori-r2l'">
											<xsl:value-of select="$bodywidth"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$bodyheight"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:apply-templates>
						</xsl:if>
						<xsl:if test="字:分栏_4215/字:栏数_41E8">
							<xsl:apply-templates select="字:分栏_4215">
								<xsl:with-param name="bodywidth" select="number($bodywidth)"/>
							</xsl:apply-templates>
						</xsl:if>
						<xsl:if test="字:填充_4134">
							<xsl:apply-templates select="字:填充_4134" mode="textpage"/>
						</xsl:if>
					</xsl:element>
					<xsl:if test="字:页眉位置_41EF">
						<style:header-style>
							<xsl:element name="style:header-footer-properties">
								<xsl:variable name="min_height">
									<xsl:value-of select="$margintop - $headerpos"/>
								</xsl:variable>
								<xsl:attribute name="fo:min-height"><xsl:value-of select="concat($min_height, $uofUnit)"/></xsl:attribute>
								<xsl:if test="字:页眉位置_41EF/@距版芯_41F1">
									<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(字:页眉位置_41EF/@距版芯_41F1,$uofUnit)"/></xsl:attribute>
								</xsl:if>
								<xsl:attribute name="style:dynamic-spacing">true</xsl:attribute>
							</xsl:element>
						</style:header-style>
					</xsl:if>
					<xsl:if test="字:页脚位置_41F2">
						<style:footer-style>
							<xsl:element name="style:header-footer-properties">
								<xsl:variable name="min_height">
									<xsl:value-of select="$marginbottom - $footerpos"/>
								</xsl:variable>
								<xsl:attribute name="fo:min-height"><xsl:value-of select="concat($min_height,$uofUnit)"/></xsl:attribute>
								<xsl:if test="字:页脚位置_41F2/@距版芯_41F1">
									<xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(字:页脚位置_41F2/@距版芯_41F1,$uofUnit)"/></xsl:attribute>
								</xsl:if>
								<xsl:attribute name="style:dynamic-spacing">true</xsl:attribute>
							</xsl:element>
						</style:footer-style>
					</xsl:if>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="transform-hex-to-decimal">
		<xsl:param name="number"/>
		<xsl:variable name="R-color-number">
			<xsl:call-template name="color-hex-to-decimal">
				<xsl:with-param name="chars" select="substring($number[1],2,2)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="G-color-number">
			<xsl:call-template name="color-hex-to-decimal">
				<xsl:with-param name="chars" select="substring($number[1],4,2)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="B-color-number">
			<xsl:call-template name="color-hex-to-decimal">
				<xsl:with-param name="chars" select="substring($number[1],6,2)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="format-number($R-color-number * 65536 + $G-color-number * 256 + $B-color-number,'#')"/>
	</xsl:template>
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
		<xsl:value-of select="number($first-num) *16 + number($second-num)"/>
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
	<xsl:template name="OfficeSettingsSpreadsheet">
		<xsl:variable name="sheetprop" select="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825"/>
		<config:config-item-set config:name="ooo:view-settings">
			<xsl:variable name="ratio" select="15"/>
			<xsl:if test="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825/表:工作表内容_E80E/表:行_E7F1/表:单元格_E7F2/表:数据_E7B3/字:句_419D/字:修订开始_421F">
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
						<xsl:element name="config:config-item-map-entry">
							<xsl:attribute name="config:name"><xsl:value-of select="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825/@名称_E822"/></xsl:attribute>
							<xsl:if test="not(/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825/表:工作表属性_E80D/表:视图_E7D5/表:缩放_E7C4)">
								<config:config-item config:name="ZoomValue" config:type="int">100</config:config-item>
							</xsl:if>
							<xsl:for-each select="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825/表:工作表属性_E80D">
								<xsl:for-each select="表:视图_E7D5">
									<xsl:if test="./表:选中区域_E7E2">
										<xsl:variable name="WorkingTableName" select="../../@名称_E822"/>
										<xsl:variable name="position" select="./表:选中区域_E7E2"/>
										<xsl:variable name="currentX">
											<xsl:variable name="CursorX" select="substring-before(substring-after($position,'$'),'$')"/>
											<xsl:call-template name="character-to-number">
												<xsl:with-param name="character" select="$CursorX"/>
											</xsl:call-template>
										</xsl:variable>
										<config:config-item config:name="CursorPositionX" config:type="int">
											<xsl:value-of select="number($currentX) - 1"/>
										</config:config-item>
										<xsl:variable name="CursorY" select="substring-after(substring-after($position,'$'),'$')"/>
										<config:config-item config:name="CursorPositionY" config:type="int">
											<xsl:value-of select="number($CursorY) - 1"/>
										</config:config-item>
									</xsl:if>
									<xsl:element name="config:config-item">
										<xsl:attribute name="config:name">HorizontalSplitMode</xsl:attribute>
										<xsl:attribute name="config:type">short</xsl:attribute>
										<xsl:choose>
											<xsl:when test="表:冻结_E7D8 and 表:冻结_E7D8/@列号_E7DA!=0">2</xsl:when>
											<xsl:when test="表:冻结_E7D8 and 表:冻结_E7D8/@列号_E7DA=0">0</xsl:when>
											<xsl:when test="表:拆分_E7D7 and 表:拆分_E7D7/@宽_C605!=0">1</xsl:when>
											<xsl:when test="表:拆分_E7D7 and 表:拆分_E7D7/@宽_C605=0">0</xsl:when>
										</xsl:choose>
									</xsl:element>
									<xsl:element name="config:config-item">
										<xsl:attribute name="config:name">VerticalSplitMode</xsl:attribute>
										<xsl:attribute name="config:type">short</xsl:attribute>
										<xsl:choose>
											<xsl:when test="表:冻结_E7D8 and 表:冻结_E7D8/@行号_E7D9!=0">2</xsl:when>
											<xsl:when test="表:冻结_E7D8 and 表:冻结_E7D8/@行号_E7D9=0">0</xsl:when>
											<xsl:when test="表:拆分_E7D7 and 表:拆分_E7D7/@长_C604!=0">1</xsl:when>
											<xsl:when test="表:拆分_E7D7 and 表:拆分_E7D7/@长_C604=0">0</xsl:when>
										</xsl:choose>
									</xsl:element>
									<xsl:element name="config:config-item">
										<xsl:attribute name="config:name">HorizontalSplitPosition</xsl:attribute>
										<xsl:attribute name="config:type">int</xsl:attribute>
										<xsl:choose>
											<xsl:when test="表:冻结_E7D8 and 表:冻结_E7D8/@列号_E7DA=0">0</xsl:when>
											<xsl:when test="表:冻结_E7D8 and 表:冻结_E7D8/@列号_E7DA!=0">
												<xsl:value-of select="表:冻结_E7D8/@列号_E7DA"/>
											</xsl:when>
											<xsl:when test="表:拆分_E7D7 and 表:拆分_E7D7/@宽_C605=0">0</xsl:when>
											<xsl:when test="表:拆分_E7D7 and 表:拆分_E7D7/@宽_C605!=0">
												<xsl:value-of select="表:拆分_E7D7/@宽_C605"/>
											</xsl:when>
										</xsl:choose>
									</xsl:element>
									<xsl:element name="config:config-item">
										<xsl:attribute name="config:name">VerticalSplitPosition</xsl:attribute>
										<xsl:attribute name="config:type">int</xsl:attribute>
										<xsl:choose>
											<xsl:when test="表:冻结_E7D8 and 表:冻结_E7D8/@行号_E7D9=0">0</xsl:when>
											<xsl:when test="表:冻结_E7D8 and 表:冻结_E7D8/@行号_E7D9!=0">
												<xsl:value-of select="表:冻结_E7D8/@行号_E7D9"/>
											</xsl:when>
											<xsl:when test="表:拆分_E7D7 and 表:拆分_E7D7/@长_C604=0">0</xsl:when>
											<xsl:when test="表:拆分_E7D7 and 表:拆分_E7D7/@长_C604!=0">
												<xsl:value-of select="表:拆分_E7D7/@长_C604"/>
											</xsl:when>
										</xsl:choose>
									</xsl:element>
									<xsl:variable name="position-top">
										<xsl:choose>
											<xsl:when test="表:最上行_E7DB">
												<xsl:value-of select="number(表:最上行_E7DB) -1"/>
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="position-left">
										<xsl:choose>
											<xsl:when test="表:最左列_E7DC">
												<xsl:value-of select="表:最左列_E7DC - 1"/>
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<config:config-item config:name="PositionLeft" config:type="int">
										<xsl:value-of select="$position-left"/>
									</config:config-item>
									<config:config-item config:name="PositionBottom" config:type="int">
										<xsl:value-of select="$position-top"/>
									</config:config-item>
									<!--xsl:if test="表:当前视图">
										<xsl:element name="config:config-item">
											<xsl:attribute name="config:name">ShowPageBreakPreview</xsl:attribute>
											<xsl:attribute name="config:type">boolean</xsl:attribute>
											<xsl:choose>
												<xsl:when test="表:当前视图/@表:类型='normal'">false</xsl:when>
												
												<xsl:when test="表:当前视图/@表:类型='page'">true</xsl:when>
												
												<xsl:otherwise>true</xsl:otherwise>
											</xsl:choose>
										</xsl:element>
									</xsl:if-->
									<xsl:if test="表:是否选中_E7D6">
										<xsl:element name="config:config-item">
											<xsl:attribute name="config:name">ActiveTable</xsl:attribute>
											<xsl:attribute name="config:type">string</xsl:attribute>
											<xsl:value-of select="$sheetprop/表:工作表属性_E80D/表:视图_E7D5[表:是否选中_E7D6]/ancestor::表:工作表_E825/@名称_E822"/>
										</xsl:element>
									</xsl:if>
									<xsl:if test="表:缩放_E7C4">
										<config:config-item config:name="ZoomValue" config:type="int">
											<xsl:value-of select="表:缩放_E7C4"/>
										</config:config-item>
									</xsl:if>
									<xsl:if test="表:分页缩放_E7E1 or 表:缩放_E7C4">
										<config:config-item config:name="PageViewZoomValue" config:type="int">
											<xsl:choose>
												<xsl:when test="表:分页缩放_E7E1">
													<xsl:value-of select="表:分页缩放_E7E1"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="表:缩放_E7C4"/>
												</xsl:otherwise>
											</xsl:choose>
										</config:config-item>
									</xsl:if>
									<config:config-item config:name="HasColumnRowHeaders" config:type="boolean">
										<xsl:choose>
											<xsl:when test="表:是否显示行号列标_E7E3='true'">true</xsl:when>
											<xsl:otherwise>false</xsl:otherwise>
										</xsl:choose>
									</config:config-item>
								</xsl:for-each>
								<xsl:if test="表:标签背景色_E7C0">
									<config:config-item config:name="sctabcolor" config:type="long">
										<xsl:value-of select="substring-after(表:标签背景色_E7C0,'#')"/>
									</config:config-item>
								</xsl:if>
							</xsl:for-each>
						</xsl:element>
					</config:config-item-map-named>
					<xsl:for-each select="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825/表:工作表属性_E80D/表:视图_E7D5">
						<xsl:if test="表:当前视图类型_E7DD">
							<xsl:element name="config:config-item">
								<xsl:attribute name="config:name">ShowPageBreakPreview</xsl:attribute>
								<xsl:attribute name="config:type">boolean</xsl:attribute>
								<xsl:choose>
									<xsl:when test="表:当前视图类型_E7DD='normal'">false</xsl:when>
									<xsl:when test="表:当前视图类型_E7DD='page'">true</xsl:when>
									<xsl:otherwise>true</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:if>
						<xsl:if test="表:是否显示网格_E7DF">
							<xsl:element name="config:config-item">
								<xsl:attribute name="config:name">ShowGrid</xsl:attribute>
								<xsl:attribute name="config:type">boolean</xsl:attribute>
								<xsl:choose>
									<xsl:when test="string(表:是否显示网格_E7DF)='1' or string(表:是否显示网格_E7DF)='true'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:if>
						<xsl:if test="表:网格颜色_E7E0 and 表:网格颜色_E7E0 != ''">
							<xsl:element name="config:config-item">
								<xsl:attribute name="config:name">GridColor</xsl:attribute>
								<xsl:attribute name="config:type">long</xsl:attribute>
								<xsl:call-template name="transform-hex-to-decimal">
									<xsl:with-param name="number" select="表:网格颜色_E7E0/text()"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825[string(表:工作表属性_E80D/表:视图_E7D5/表:是否选中_E7D6) = 'true' or string(表:工作表属性_E80D/表:视图_E7D5/表:是否选中_E7D6) = '1']">
						<config:config-item config:name="ActiveTable" config:type="string">
							<xsl:value-of select="@名称_E822"/>
						</config:config-item>
					</xsl:for-each>
					<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:是否显示工作表标签_B635">
						<xsl:choose>
							<xsl:when test=".='false'">
								<config:config-item config:name="HasSheetTabs" config:type="boolean">false</config:config-item>
							</xsl:when>
							<xsl:otherwise>
								<config:config-item config:name="HasSheetTabs" config:type="boolean">true</config:config-item>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</config:config-item-map-entry>
			</config:config-item-map-indexed>
		</config:config-item-set>
		<config:config-item-set config:name="ooo:configuration-settings">
			<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:是否自动重算_B638">
				<xsl:choose>
					<xsl:when test="false">
						<config:config-item config:name="AutoCalculate" config:type="boolean">false</config:config-item>
					</xsl:when>
					<xsl:otherwise>
						<config:config-item config:name="AutoCalculate" config:type="boolean">true</config:config-item>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:是否显示工作表标签_B635">
				<xsl:choose>
					<xsl:when test=".='false'">
						<config:config-item config:name="HasSheetTabs" config:type="boolean">false</config:config-item>
					</xsl:when>
					<xsl:otherwise>
						<config:config-item config:name="HasSheetTabs" config:type="boolean">true</config:config-item>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</config:config-item-set>
	</xsl:template>
	<xsl:template name="print_fun">
		<xsl:param name="saGrid"/>
		<xsl:param name="saHeaders"/>
		<xsl:param name="saAnnotations"/>
		<xsl:if test="$saGrid != ''">
			<xsl:value-of select="'grid '"/>
		</xsl:if>
		<xsl:if test="$saHeaders != ''">
			<xsl:value-of select="'headers '"/>
		</xsl:if>
		<xsl:if test="$saAnnotations != ''">
			<xsl:value-of select="'annotations '"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="ScPageLayoutStyle">
		<xsl:for-each select="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825/表:工作表属性_E80D">
			<xsl:if test="表:页面设置_E7C1">
				<xsl:element name="style:page-layout">
					<xsl:attribute name="style:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
					<xsl:element name="style:page-layout-properties">
						<xsl:variable name="marginTop">
							<xsl:choose>
								<xsl:when test="$uofUnit = 'pt' and 表:页面设置_E7C1/表:页眉页脚_E7C6">
									<xsl:value-of select="number(表:页面设置_E7C1/表:页边距_E7C5/@上_C609) - 21.29"/>
								</xsl:when>
								<xsl:when test="$uofUnit = 'cm' and 表:页面设置_E7C1/表:页眉页脚_E7C6">
									<xsl:value-of select="number(表:页面设置_E7C1/表:页边距_E7C5/@上_C609) - 0.751"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="表:页面设置_E7C1/表:页边距_E7C5/@上_C609"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="marginBottom">
							<xsl:choose>
								<xsl:when test="$uofUnit = 'pt' and 表:页面设置_E7C1/表:页眉页脚_E7C6">
									<xsl:value-of select="number(表:页面设置_E7C1/表:页边距_E7C5/@下_C60B) - 21.29"/>
								</xsl:when>
								<xsl:when test="$uofUnit = 'cm' and 表:页面设置_E7C1/表:页眉页脚_E7C6">
									<xsl:value-of select="number(表:页面设置_E7C1/表:页边距_E7C5/@下_C60B) - 0.751"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="表:页面设置_E7C1/表:页边距_E7C5/@下_C60B"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="表:页面设置_E7C1/表:页边距_E7C5/@左_C608">
							<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(表:页面设置_E7C1/表:页边距_E7C5/@左_C608,$uofUnit)"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="表:页面设置_E7C1/表:页边距_E7C5/@右_C60A">
							<xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(表:页面设置_E7C1/表:页边距_E7C5/@右_C60A,$uofUnit)"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="表:页面设置_E7C1/表:页边距_E7C5/@上_C609">
							<xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(string($marginTop),$uofUnit)"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="表:页面设置_E7C1/表:页边距_E7C5/@下_C60B">
							<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(string($marginBottom),$uofUnit)"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="表:页面设置_E7C1/表:缩放_E7C4">
							<xsl:attribute name="style:scale-to"><xsl:value-of select="concat(表:页面设置_E7C1/表:缩放_E7C4,'%')"/></xsl:attribute>
						</xsl:if>
						<xsl:variable name="pagewidth">
							<xsl:choose>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'A3'">29.7</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'A4'">21.0</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'A5'">14.8</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'B4'">25.0</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'B5'">17.6</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'letter-small'">9.2</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'letter'">21.59</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'PRC-16K'">18.4</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'PRC-32K'">13.0</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'PRC-32K(Big)'">14.0</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="pageheight">
							<xsl:choose>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'A3'">42.0</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'A4'">29.7</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'A5'">21.0</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'B4'">35.3</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'B5'">25.0</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'letter-small'">16.5</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'letter'">27.94</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'PRC-16K'">26.0</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'PRC-32K'">18.4</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C = 'PRC-32K(Big)'">20.3</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="page-width">
							<xsl:choose>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C and 表:页面设置_E7C1/表:纸张方向_E7C3 = 'portrait'">
									<xsl:value-of select="$pagewidth"/>
								</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C and 表:页面设置_E7C1/表:纸张方向_E7C3 = 'landscape'">
									<xsl:value-of select="$pageheight"/>
								</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@宽_C605">
									<!--xsl:value-of select="convertOthers2cm(表:页面设置_E7C1/表:纸张_E7C2/@宽_C605,$uofUnit)"/-->
									<xsl:call-template name="convertOthers2cm">
										<xsl:with-param name="value" select="concat(表:页面设置_E7C1/表:纸张_E7C2/@宽_C605,$uofUnit)"/>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="page-height">
							<xsl:choose>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C and 表:页面设置_E7C1/表:纸张方向_E7C3 = 'portrait'">
									<xsl:value-of select="$pageheight"/>
								</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@纸型_C60C and 表:页面设置_E7C1/表:纸张方向_E7C3 = 'landscape'">
									<xsl:value-of select="$pagewidth"/>
								</xsl:when>
								<xsl:when test="表:页面设置_E7C1/表:纸张_E7C2/@长_C604">
									<!--xsl:value-of select="convertOthers2cm(表:页面设置_E7C1/表:纸张_E7C2/@长_C604,$uofUnit)"/-->
									<xsl:call-template name="convertOthers2cm">
										<xsl:with-param name="value" select="concat(表:页面设置_E7C1/表:纸张_E7C2/@长_C604,$uofUnit)"/>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="wPage">
							<xsl:if test="$page-width != ''">
								<xsl:choose>
									<xsl:when test="number($page-width) &lt; 21.69 and number($page-width) &gt; 21.49 and number($page-height) &lt; 28.04 and number($page-height) &gt; 27.84">
										<xsl:value-of select="'21.59'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 9.31 and number($page-width) &gt; 9.11 and number($page-height) &lt; 16.61 and number($page-height) &gt; 16.41">
										<xsl:value-of select="'9.21'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 16.61 and number($page-width) &gt; 16.41 and number($page-height) &lt; 9.31 and number($page-height) &gt; 9.11">
										<xsl:value-of select="'16.51'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 29.8 and number($page-width) &gt; 29.6 and number($page-height) &lt; 42.1 and number($page-height) &gt; 41.9">
										<xsl:value-of select="'29.7'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 21.1 and number($page-width) &gt; 20.9 and number($page-height) &lt; 29.6 and number($page-height) &gt; 29.8">
										<xsl:value-of select="'21.0'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 14.9 and number($page-width) &gt; 14.7 and number($page-height) &lt; 21.1 and number($page-height) &gt; 20.9">
										<xsl:value-of select="'14.8'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 25.8 and number($page-width) &gt; 25.6 and number($page-height) &lt; 36.5 and number($page-height) &gt; 36.3">
										<xsl:value-of select="'25.7'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 18.3 and number($page-width) &gt; 18.1 and number($page-height) &lt; 25.8 and number($page-height) &gt; 25.6">
										<xsl:value-of select="'18.2'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 18.5 and number($page-width) &gt; 18.3 and number($page-height) &lt; 26.1 and number($page-height) &gt; 25.9">
										<xsl:value-of select="'18.4'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 13.1 and number($page-width) &gt; 12.9 and number($page-height) &lt; 18.5 and number($page-height) &gt; 18.3">
										<xsl:value-of select="'13.0'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 14.1 and number($page-width) &gt; 13.9 and number($page-height) &lt; 20.4 and number($page-height) &gt; 20.2">
										<xsl:value-of select="'14.0'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$page-width"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:variable>
						<xsl:attribute name="fo:page-width"><xsl:choose><xsl:when test="$wPage!=''"><xsl:value-of select="concat($wPage,'cm')"/></xsl:when><xsl:otherwise><xsl:value-of select="'21.0cm'"/></xsl:otherwise></xsl:choose></xsl:attribute>
						<xsl:variable name="hPage">
							<xsl:if test="$page-height != ''">
								<xsl:choose>
									<xsl:when test="number($page-width) &lt; 21.69 and number($page-width) &gt; 21.49 and number($page-height) &lt; 28.04 and number($page-height) &gt; 27.84">
										<xsl:value-of select="'27.94'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 9.31 and number($page-width) &gt; 9.11 and number($page-height) &lt; 16.61 and number($page-height) &gt; 16.41">
										<xsl:value-of select="'16.51'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 16.61 and number($page-width) &gt; 16.41 and number($page-height) &lt; 9.31 and number($page-height) &gt; 9.11">
										<xsl:value-of select="'9.21'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 29.8 and number($page-width) &gt; 29.6 and number($page-height) &lt; 42.1 and number($page-height) &gt; 41.9">
										<xsl:value-of select="'42.0'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 21.1 and number($page-width) &gt; 20.9 and number($page-height) &lt; 29.6 and number($page-height) &gt; 29.8">
										<xsl:value-of select="'29.7'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 14.9 and number($page-width) &gt; 14.7 and number($page-height) &lt; 21.1 and number($page-height) &gt; 20.9">
										<xsl:value-of select="'21.0'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 25.8 and number($page-width) &gt; 25.6 and number($page-height) &lt; 36.5 and number($page-height) &gt; 36.3">
										<xsl:value-of select="'36.4'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 18.3 and number($page-width) &gt; 18.1 and number($page-height) &lt; 25.8 and number($page-height) &gt; 25.6">
										<xsl:value-of select="'25.7'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 18.5 and number($page-width) &gt; 18.3 and number($page-height) &lt; 26.1 and number($page-height) &gt; 25.9">
										<xsl:value-of select="'26.0'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 13.1 and number($page-width) &gt; 12.9 and number($page-height) &lt; 18.5 and number($page-height) &gt; 18.3">
										<xsl:value-of select="'18.4'"/>
									</xsl:when>
									<xsl:when test="number($page-width) &lt; 14.1 and number($page-width) &gt; 13.9 and number($page-height) &lt; 20.4 and number($page-height) &gt; 20.2">
										<xsl:value-of select="'20.3'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$page-height"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:variable>
						<xsl:attribute name="fo:page-height"><xsl:choose><xsl:when test="$hPage!=''"><xsl:value-of select="concat($hPage,'cm')"/></xsl:when><xsl:otherwise><xsl:value-of select="'29.7cm'"/></xsl:otherwise></xsl:choose></xsl:attribute>
						<xsl:if test="表:页面设置_E7C1/表:纸张方向_E7C3">
							<xsl:attribute name="style:print-orientation"><xsl:value-of select="表:页面设置_E7C1/表:纸张方向_E7C3"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="string(表:页面设置_E7C1/表:打印_E7CA/@是否先列后行_E7CE) = '0' or string(表:页面设置_E7C1/表:打印_E7CA/@是否先列后行_E7CE) = 'false'">
							<xsl:attribute name="style:print-page-order">ltr</xsl:attribute>
						</xsl:if>
						<xsl:if test="string(表:页面设置_E7C1/表:垂直对齐方式_E701) = 'center' and string(表:页面设置_E7C1/表:水平对齐方式_E700) = 'center'">
							<xsl:attribute name="style:table-centering">both</xsl:attribute>
						</xsl:if>
						<xsl:if test="string(表:页面设置_E7C1/表:水平对齐方式_E700) = 'left' and  string(表:页面设置_E7C1/表:垂直对齐方式_E701) = 'center'">
							<xsl:attribute name="style:table-centering">vertical</xsl:attribute>
						</xsl:if>
						<xsl:if test="string(表:页面设置_E7C1/表:水平对齐方式_E700) = 'center' and  string(表:页面设置_E7C1/表:垂直对齐方式_E701) = 'top'">
							<xsl:attribute name="style:table-centering">horizontal</xsl:attribute>
						</xsl:if>
						<xsl:if test="表:页面设置_E7C1/表:调整_E7D1/@页高倍数_E7D2">
							<xsl:attribute name="style:scale-to-X"><xsl:value-of select="表:页面设置_E7C1/表:调整_E7D1/@页高倍数_E7D2"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="表:页面设置_E7C1/表:调整_E7D1/@页宽倍数_E7D3">
							<xsl:attribute name="style:scale-to-Y"><xsl:value-of select="表:页面设置_E7C1/表:调整_E7D1/@页宽倍数_E7D3"/></xsl:attribute>
						</xsl:if>
						<xsl:variable name="saGrid">
							<xsl:choose>
								<xsl:when test="表:页面设置_E7C1/表:打印_E7CA/@是否带网格线_E7CB = 'true' or number(表:页面设置_E7C1/表:打印_E7CA/@是否带网格线_E7CB) = 1">grid</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="saHeaders">
							<xsl:choose>
								<xsl:when test="表:页面设置_E7C1/表:打印_E7CA/@是否带行号列标_E7CC = 'true' or number(表:页面设置_E7C1/表:打印_E7CA/@是否带行号列标_E7CC) = 1">headers</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="saAnnotations">
							<xsl:choose>
								<xsl:when test="表:页面设置_E7C1/表:批注打印方式_E7CF = 'sheet-end'">annotations</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="default_print">
							<xsl:value-of select="'charts drawings objects zero-values'"/>
						</xsl:variable>
						<xsl:variable name="Sc_Print_Result">
							<xsl:call-template name="print_fun">
								<xsl:with-param name="saGrid" select="$saGrid"/>
								<xsl:with-param name="saHeaders" select="$saHeaders"/>
								<xsl:with-param name="saAnnotations" select="$saAnnotations"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$Sc_Print_Result != ''">
							<xsl:attribute name="style:print"><xsl:value-of select="concat($Sc_Print_Result,$default_print)"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="表:页面设置_E7C1/表:打印_E7CA/@是否按按草稿方式_E7CD">
							<xsl:attribute name="style:draft-print"><xsl:value-of select="表:页面设置_E7C1/表:打印_E7CA/@是否按按草稿方式_E7CD"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="表:页面设置_E7C1/表:错误单元格打印方式_E7D0">
							<xsl:attribute name="style:print-errors-as"><xsl:value-of select="表:页面设置_E7C1/表:错误单元格打印方式_E7D0"/></xsl:attribute>
						</xsl:if>
					</xsl:element>
					<xsl:if test="表:页面设置_E7C1/表:页眉页脚_E7C6">
						<xsl:element name="style:header-style">
							<style:header-footer-properties fo:min-height="0.751cm" fo:margin-left="0cm" fo:margin-right="0cm" fo:margin-bottom="0.25cm"/>
						</xsl:element>
						<xsl:element name="style:footer-style">
							<style:header-footer-properties fo:min-height="0.751cm" fo:margin-left="0cm" fo:margin-right="0cm" fo:margin-bottom="0.25cm"/>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:if>
			<xsl:if test="表:背景填充_E830/图:颜色_8004">
				<xsl:element name="style:style">
					<xsl:attribute name="style:family">table</xsl:attribute>
					<xsl:attribute name="style:name"><xsl:value-of select="generate-id(..)"/></xsl:attribute>
					<xsl:element name="style:table-properties">
						<xsl:attribute name="fo:background-color"><xsl:value-of select="表:背景填充_E830/图:颜色_8004"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="MasterStyleSpreadsheet">
		<xsl:for-each select="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825/表:工作表属性_E80D">
			<xsl:element name="style:master-page">
				<xsl:choose>
					<xsl:when test="表:页面设置_E7C1/@名称_E7D4 = '工作表1的页面设置' or 表:页面设置_E7C1/@名称_E7D4 = '工作表2的页面设置'">
						<xsl:attribute name="style:name"><xsl:value-of select="表:页面设置_E7C1/@名称_E7D4"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="表:页面设置_E7C1">
						<xsl:attribute name="style:name"><xsl:value-of select="generate-id(表:页面设置_E7C1)"/></xsl:attribute>
					</xsl:when>
				</xsl:choose>
				<!--<xsl:attribute name="style:name"><xsl:value-of select="../@表:名称"/></xsl:attribute>-->
				<!--xsl:attribute name="style:name"><xsl:value-of select="generate-id(表:页面设置_E7C1)"/></xsl:attribute-->
				<xsl:attribute name="style:page-layout-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
				<xsl:for-each select="表:页面设置_E7C1/表:页眉页脚_E7C6[contains(@位置_E7C9,'head')]">
					<xsl:element name="style:header">
						<xsl:choose>
							<xsl:when test="@位置_E7C9='header-right'">
								<!--style:region-center>
									<text:p>
										<text:sheet-name>???</text:sheet-name>
									</text:p>
								</style:region-center-->
								<xsl:element name="style:region-right">
									<!--<xsl:element name="text:p">
										<xsl:value-of select="字:段落_416B/字:句_419D/字:文本串_415B"/>
									</xsl:element>-->
									<xsl:apply-templates select="./字:段落_416B"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@位置_E7C9='header-left'">
								<xsl:element name="style:region-left">
									<!--<xsl:element name="text:p">
										<xsl:value-of select="字:段落_416B/字:句_419D/字:文本串_415B"/>
									</xsl:element>-->
									<xsl:apply-templates select="./字:段落_416B"/>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="style:region-center">
									<!--<xsl:element name="text:p">
										<xsl:value-of select="字:段落_416B/字:句_419D/字:文本串_415B"/>
									</xsl:element>-->
									<xsl:apply-templates select="./字:段落_416B"/>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<style:header-left style:display="false"/>
				</xsl:for-each>
				<xsl:for-each select="表:页面设置_E7C1/表:页眉页脚_E7C6[contains(@位置_E7C9,'foot')]">
					<xsl:element name="style:footer">
						<xsl:choose>
							<xsl:when test="@位置_E7C9='footer-right'">
								<!--style:region-center>
									<text:p>
										<text:sheet-name>???</text:sheet-name>
									</text:p>
								</style:region-center-->
								<xsl:element name="style:region-right">
									<!--<xsl:element name="text:p">
										<xsl:value-of select="字:段落_416B/字:句_419D/字:文本串_415B"/>
										
									</xsl:element>-->
									<xsl:apply-templates select="./字:段落_416B"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@位置_E7C9='footer-left'">
								<xsl:element name="style:region-left">
									<!--<xsl:element name="text:p">
										<xsl:value-of select="字:段落_416B/字:句_419D/字:文本串_415B"/>
										
									</xsl:element>-->
									<xsl:apply-templates select="./字:段落_416B"/>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="style:region-center">
									<!--<xsl:element name="text:p">
										<xsl:value-of select="字:段落_416B/字:句_419D/字:文本串_415B"/>
									</xsl:element>-->
									<xsl:apply-templates select="./字:段落_416B"/>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:for-each>
				<!--<style:footer>
					<text:p>第<text:page-number>1</text:page-number>页</text:p>
				</style:footer>-->
				<style:footer-left style:display="false"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="listValidation">
		<xsl:param name="inputString"/>
		<xsl:param name="tempString"/>
		<xsl:param name="resultString"/>
		<xsl:variable name="itemString">
			<xsl:choose>
				<xsl:when test="contains($inputString,',')">
					<xsl:value-of select="concat('&#34;',substring-before($inputString,','),'&#34;')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('&#34;',$inputString,'&#34;')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($inputString,',')">
				<xsl:call-template name="listValidation">
					<xsl:with-param name="inputString" select="$tempString"/>
					<xsl:with-param name="tempString" select="substring-after($tempString,',')"/>
					<xsl:with-param name="resultString" select="concat($resultString,$itemString,';')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($resultString,$itemString)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="one-content-validation">
		<xsl:variable name="condition-text">
			<xsl:choose>
				<xsl:when test="规则:校验类型_B61C/text()='cell-range'">
					<xsl:value-of select="concat('oooc:cell-content-is-in-list',规则:第一操作数_B61E/text())"/>
				</xsl:when>
				<xsl:when test="规则:校验类型_B61C/text()='list'">
					<xsl:variable name="temp">
						<xsl:call-template name="listValidation">
							<xsl:with-param name="inputString" select="规则:第一操作数_B61E/text()"/>
							<xsl:with-param name="tempString" select="substring-after(规则:第一操作数_B61E/text(),',')"/>
							<xsl:with-param name="resultString" select="''"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="concat('of:cell-content-is-in-list(',$temp,')')"/>
				</xsl:when>
				<xsl:when test="规则:校验类型_B61C/text()='text-length'">
					<xsl:choose>
						<xsl:when test="规则:操作码_B61D/text()='between' ">
							<xsl:value-of select="concat('oooc:cell-content-text-length-is-between','(',规则:第一操作数_B61E/text(),',',规则:第二操作数_B61F/text(),')')"/>
						</xsl:when>
						<xsl:when test="规则:操作码_B61D/text()='not-between'">
							<xsl:value-of select="concat('oooc:cell-content-text-length-is-not-between','(',规则:第一操作数_B61E/text(),',',规则:第二操作数_B61F/text(),')')"/>
						</xsl:when>
						<xsl:when test="规则:操作码_B61D/text()='equal-to'">
							<xsl:value-of select="concat('oooc:cell-content-text-length()=',规则:第一操作数_B61E/text())"/>
						</xsl:when>
						<xsl:when test="规则:操作码_B61D/text()='not-equal-to'">
							<xsl:value-of select="concat('oooc:cell-content-text-length()!=',规则:第一操作数_B61E/text())"/>
						</xsl:when>
						<xsl:when test="规则:操作码_B61D/text()='greater-than'">
							<xsl:value-of select="concat('oooc:cell-content-text-length()&gt;',规则:第一操作数_B61E/text())"/>
						</xsl:when>
						<xsl:when test="规则:操作码_B61D/text()='less-than'">
							<xsl:value-of select="concat('oooc:cell-content-text-length()&lt;',规则:第一操作数_B61E/text())"/>
						</xsl:when>
						<xsl:when test="规则:操作码_B61D/text()='greater-than-or-equal-to'">
							<xsl:value-of select="concat('oooc:cell-content-text-length()&gt;=',规则:第一操作数_B61E/text())"/>
						</xsl:when>
						<xsl:when test="规则:操作码_B61D/text()='less-than-or-equal-to'">
							<xsl:value-of select="concat('oooc:cell-content-text-length()&lt;=',规则:第一操作数_B61E/text())"/>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="condition-item">
						<xsl:choose>
							<xsl:when test="规则:操作码_B61D/text()='between' ">
								<xsl:value-of select="concat(' and cell-content-is-between','(',规则:第一操作数_B61E/text(),',',规则:第二操作数_B61F/text(),')')"/>
							</xsl:when>
							<xsl:when test="规则:操作码_B61D/text()='not-between'">
								<xsl:value-of select="concat(' and cell-content-is-not-between','(',规则:第一操作数_B61E/text(),',',规则:第二操作数_B61F/text(),')')"/>
							</xsl:when>
							<xsl:when test="规则:操作码_B61D/text()='equal-to'">
								<xsl:value-of select="concat(' and cell-content()=',规则:第一操作数_B61E/text())"/>
							</xsl:when>
							<xsl:when test="规则:操作码_B61D/text()='not-equal-to'">
								<xsl:value-of select="concat(' and cell-content()!=',规则:第一操作数_B61E/text())"/>
							</xsl:when>
							<xsl:when test="规则:操作码_B61D/text()='greater-than'">
								<xsl:value-of select="concat(' and cell-content()&gt;',规则:第一操作数_B61E/text())"/>
							</xsl:when>
							<xsl:when test="规则:操作码_B61D/text()='less-than'">
								<xsl:value-of select="concat(' and cell-content()&lt;',规则:第一操作数_B61E/text())"/>
							</xsl:when>
							<xsl:when test="规则:操作码_B61D/text()='greater-than-or-equal-to'">
								<xsl:value-of select="concat(' and cell-content()&gt;=',规则:第一操作数_B61E/text())"/>
							</xsl:when>
							<xsl:when test="规则:操作码_B61D/text()='less-than-or-equal-to'">
								<xsl:value-of select="concat(' and cell-content()&lt;=',规则:第一操作数_B61E/text())"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="validation-type">
						<xsl:choose>
							<xsl:when test="规则:校验类型_B61C/text()='whole-number'">
								<xsl:value-of select="'oooc:cell-content-is-whole-number()'"/>
							</xsl:when>
							<xsl:when test="规则:校验类型_B61C/text()='decimal'">
								<xsl:value-of select="'oooc:cell-content-is-decimal-number()'"/>
							</xsl:when>
							<xsl:when test="规则:校验类型_B61C/text()='date'">
								<xsl:value-of select="'oooc:cell-content-is-date()'"/>
							</xsl:when>
							<xsl:when test="规则:校验类型_B61C/text()='time'">
								<xsl:value-of select="'oooc:cell-content-is-time()'"/>
							</xsl:when>
							<xsl:when test="$condition-item!=''">
								<xsl:value-of select="'oooc:cell-content-is-whole-number()'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:value-of select="concat($validation-type,$condition-item)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="table:content-validation">
			<xsl:attribute name="table:name"><xsl:value-of select="@表:name"/></xsl:attribute>
			<xsl:if test="not($condition-text='')">
				<xsl:attribute name="table:condition"><xsl:value-of select="$condition-text"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="规则:是否忽略空格_B620">
				<xsl:attribute name="table:allow-empty-cell"><xsl:value-of select="规则:是否忽略空格_B620"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="规则:是否显示下拉箭头_B621">
				<xsl:variable name="listshow">
					<xsl:choose>
						<xsl:when test="string(规则:是否显示下拉箭头_B621)='false'">
							<xsl:value-of select="'no'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'unsorted'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="table:display-list"><xsl:value-of select="$listshow"/></xsl:attribute>
			</xsl:if>
			<xsl:variable name="danyinhao">&apos;</xsl:variable>
			<xsl:variable name="base_cell_address">
				<xsl:choose>
					<xsl:when test="contains(规则:区域集_B61A/规则:区域_B62A[1]/text(),':')">
						<xsl:value-of select="translate(substring-after(规则:区域集_B61A/规则:区域_B62A[1]/text(),':'),'$','')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="translate(translate(translate(规则:区域集_B61A/规则:区域_B62A[1]/text(),'$',''),$danyinhao,''),'!','.')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="table:base-cell-address"><xsl:value-of select="$base_cell_address"/></xsl:attribute>
			<xsl:if test="规则:输入提示_B622">
				<xsl:element name="table:help-message">
					<xsl:if test="规则:输入提示_B622/@标题_B624">
						<xsl:attribute name="table:title"><xsl:value-of select="规则:输入提示_B622/@标题_B624"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="规则:输入提示_B622/@是否显示_B623">
						<xsl:attribute name="table:display"><xsl:value-of select="规则:输入提示_B622/@是否显示_B623"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="规则:输入提示_B622/@内容_B625">
						<xsl:element name="text:p">
							<xsl:value-of select="规则:输入提示_B622/@内容_B625"/>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:if>
			<xsl:if test="规则:错误提示_B626">
				<xsl:element name="table:error-message">
					<xsl:if test="规则:错误提示_B626/@标题_B624">
						<xsl:attribute name="table:title"><xsl:value-of select="规则:错误提示_B626/@标题_B624"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="规则:错误提示_B626/@是否显示_B623">
						<xsl:attribute name="table:display"><xsl:value-of select="规则:错误提示_B626/@是否显示_B623"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="规则:错误提示_B626/@类型_B627">
						<xsl:attribute name="table:message-type"><xsl:value-of select="规则:错误提示_B626/@类型_B627"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="规则:错误提示_B626/@内容_B625">
						<xsl:element name="text:p">
							<xsl:value-of select="规则:错误提示_B626/@内容_B625"/>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template name="content-validations">
		<xsl:if test="/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:数据有效性集_B618">
			<xsl:element name="table:content-validations">
				<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:数据有效性集_B618/*">
					<xsl:call-template name="one-content-validation"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="calculation-settings">
		<xsl:element name="table:calculation-settings">
			<xsl:attribute name="table:precision-as-shown"><xsl:choose><xsl:when test="string(/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:精确度是否以显示值为准_B613) = 'true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:choose>
				<xsl:when test="string(/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:日期系统_B614)='1904'">
					<table:null-date table:date-value="1904-01-01"/>
				</xsl:when>
				<xsl:when test="string(/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:日期系统_B614)='1899'"/>
				<xsl:when test="string(/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:日期系统_B614)='iso8601'">
					<table:null-date table:date-value="1900-01-01"/>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:计算设置_B615">
				<xsl:element name="table:iteration">
					<xsl:attribute name="table:status">enable</xsl:attribute>
					<xsl:attribute name="table:steps"><xsl:choose><xsl:when test="/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:计算设置_B615/@迭代次数_B616"><xsl:value-of select="/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:计算设置_B615/@迭代次数_B616"/></xsl:when><xsl:otherwise>100</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="table:maximum-difference"><xsl:choose><xsl:when test="/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:计算设置_B615/@偏差值_B617"><xsl:value-of select="/uof:UOF_0000/规则:公用处理规则_B665/规则:电子表格_B66C/规则:计算设置_B615/@偏差值_B617"/></xsl:when><xsl:otherwise>0.001</xsl:otherwise></xsl:choose></xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template name="tracked-changes">
		<xsl:for-each select="表:工作表_E825/表:工作表内容_E80E//字:修订开始_421F">
			<xsl:variable name="num">
				<xsl:number level="any" from="表:工作表_E825/表:工作表内容_E80E//*" count="字:修订开始_421F"/>
			</xsl:variable>
			<table:tracked-changes>
				<table:cell-content-change>
					<xsl:attribute name="table:id"><xsl:value-of select="concat('ct',$num)"/></xsl:attribute>
					<table:cell-address>
						<xsl:attribute name="table:column"><xsl:value-of select="substring-after(@标识符_4220,'-')"/></xsl:attribute>
						<xsl:attribute name="table:row"><xsl:value-of select="substring-before(@标识符_4220,'-')"/></xsl:attribute>
						<xsl:attribute name="table:table">0</xsl:attribute>
					</table:cell-address>
					<office:change-info>
						<dc:creator>
							<xsl:choose>
								<xsl:when test="starts-with(@修订信息引用_4222,'+')"/>
								<xsl:otherwise>
									<xsl:value-of select="substring-before(@修订信息引用_4222,'+')"/>
								</xsl:otherwise>
							</xsl:choose>
						</dc:creator>
						<dc:date>
							<xsl:value-of select="substring-before(substring-after(@修订信息引用_4222,'+'),'%')"/>
						</dc:date>
					</office:change-info>
					<table:previous>
						<table:change-track-table-cell>
							<text:p>
								<xsl:value-of select="substring-after(@修订信息引用_4222,'%')"/>
							</text:p>
						</table:change-track-table-cell>
					</table:previous>
				</table:cell-content-change>
			</table:tracked-changes>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="表:电子表格文档_E826">
		<office:body>
			<office:spreadsheet>
				<xsl:call-template name="tracked-changes"/>
				<xsl:call-template name="calculation-settings"/>
				<xsl:call-template name="content-validations"/>
				<xsl:for-each select="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825">
					<xsl:call-template name="TableSheet"/>
				</xsl:for-each>
				<!--<xsl:for-each select="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825/表:筛选集_E83A/表:筛选_E80F">
					<xsl:apply-templates select="."/>
				</xsl:for-each>-->
				<xsl:apply-templates select="/uof:UOF_0000/书签:书签集_9104" mode="table"/>
				<xsl:element name="table:database-ranges">
					<xsl:for-each select="表:工作表_E825/表:筛选集_E83A/表:筛选_E80F">
						<!--<xsl:element name="table:database-range">
							<xsl:if test="@类型_E83B = 'auto'">
								<xsl:attribute name="table:display-filter-buttons">true</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="table:target-range-address">
								<xsl:call-template name="getDataRange"/>
							</xsl:attribute>
							<xsl:if test="表:条件_E811">
								<table:filter>
									<xsl:choose>
										<xsl:when test="表:条件_E811/表:普通_E812">
											<xsl:element name="table:filter-condition">
												<xsl:variable name="opea" select="表:条件_E811/表:普通_E812/@类型_E7B6"/>
												<xsl:variable name="conditionArea">
													<xsl:call-template name="character-to-number">
														<xsl:with-param name="character" select="substring-before(substring-after(表:范围_E810,'$'),'$')"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:attribute name="table:field-number">
													<xsl:value-of select="number(表:条件_E811/@列号_E819) - number($conditionArea)"/>
												</xsl:attribute>
												<xsl:attribute name="table:value" select="表:条件_E811/表:普通_E812/@值_E813"/>
												<xsl:attribute name="table:operator">
													<xsl:choose>
														<xsl:when test="$opea = 'bottomitem'">bottom values</xsl:when>
														<xsl:when test="$opea = 'bottompercent'">bottom percent</xsl:when>
														<xsl:when test="$opea = 'topitem'">top values</xsl:when>
														<xsl:when test="$opea = 'toppercent'">top percent</xsl:when>
														<xsl:when test="$opea = 'value'">=</xsl:when>
														<xsl:otherwise/>
													</xsl:choose>
												</xsl:attribute>
											</xsl:element>
										</xsl:when>
										<xsl:when test="表:条件_E811/表:自定义_E814/@类型_E75D = 'or'">
											<xsl:element name="table:filter-or">
												<xsl:for-each select="表:条件_E811/表:自定义_E814/表:操作条件_815">
													<xsl:call-template name="表:操作条件_815"/>
												</xsl:for-each>
											</xsl:element>
										</xsl:when>
										<xsl:when test="表:条件_E811/表:自定义_E814/@类型_E75D = 'and'">
											<xsl:element name="table:filter-and">
												<xsl:for-each select="表:条件_E811/表:自定义_E814/表:操作条件_815">
													<xsl:call-template name="表:操作条件_815"/>
												</xsl:for-each>
											</xsl:element>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="表:条件_E811/表:自定义_E814/表:操作条件_815">
												<xsl:call-template name="表:操作条件_815"/>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</table:filter>
							</xsl:if>
						</xsl:element>-->
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</xsl:element>
			</office:spreadsheet>
		</office:body>
	</xsl:template>
	<xsl:template name="表:操作条件_815">
		<xsl:element name="table:filter-condition">
			<xsl:variable name="ope" select="规则:操作码_B61D"/>
			<xsl:variable name="conditionArea">
				<xsl:call-template name="character-to-number">
					<xsl:with-param name="character" select="substring-before(substring-after(../../../表:范围_E810,'$'),'$')"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:attribute name="table:field-number"><xsl:value-of select="number(../../@列号_E819) - number($conditionArea)"/></xsl:attribute>
			<xsl:attribute name="table:value"><xsl:value-of select="@值_E817"/></xsl:attribute>
			<xsl:attribute name="table:operator"><xsl:choose><xsl:when test="$ope = 'equal to'">=</xsl:when><xsl:when test="$ope = 'not equal to'">!=</xsl:when><xsl:when test="$ope = 'greater than'">&gt;</xsl:when><xsl:when test="$ope = 'greater than or equal to'">&gt;=</xsl:when><xsl:when test="$ope = 'less than'">&lt;</xsl:when><xsl:when test="$ope = 'less than or equal to'">&lt;=</xsl:when><xsl:when test="$ope = 'start with'">begins-with</xsl:when><xsl:when test="$ope = 'not start with'">does-not-begin-with</xsl:when><xsl:when test="$ope = 'end with'">ends-with</xsl:when><xsl:when test="$ope = 'not end with'">does-not-end-with</xsl:when><xsl:when test="$ope = 'contain' or $ope = 'between'">contains</xsl:when><xsl:when test="$ope = 'not contain' or $ope = 'between'">does-not-contain</xsl:when><xsl:otherwise/></xsl:choose></xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template name="OneTableStyle">
		<xsl:element name="style:style">
			<xsl:attribute name="style:family">table</xsl:attribute>
			<xsl:attribute name="style:name"><xsl:value-of select="concat('ta', generate-id(.))"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="表:工作表属性_E80D/表:页面设置_E7C1/@名称_E7D4 = '工作表1的页面设置' or 表:工作表属性_E80D/表:页面设置_E7C1/@名称_E7D4 = '工作表1的页面设置'">
					<xsl:attribute name="style:master-page-name"><xsl:value-of select="表:工作表属性_E80D/表:页面设置_E7C1/@名称_E7D4"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="表:工作表属性_E80D/表:页面设置_E7C1/@名称_E7D4 = '工作表2的页面设置' or 表:工作表属性_E80D/表:页面设置_E7C1/@名称_E7D4 = '工作表2的页面设置'">
					<xsl:attribute name="style:master-page-name"><xsl:value-of select="表:工作表属性_E80D/表:页面设置_E7C1/@名称_E7D4"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="表:工作表属性_E80D/表:页面设置_E7C1">
					<xsl:attribute name="style:master-page-name"><xsl:value-of select="generate-id(表:工作表属性_E80D/表:页面设置_E7C1)"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<!--xsl:attribute name="style:master-page-name">
				<xsl:value-of select="generate-id(表:工作表属性_E80D/表:页面设置_E7C1)"/>
			</xsl:attribute-->
			<xsl:element name="style:table-properties">
				<xsl:choose>
					<xsl:when test="string(@是否隐藏_E73C) = '1' or string(@是否隐藏_E73C) ='true'">
						<xsl:attribute name="table:display">false</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="table:display">true</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:for-each select="key('CellStyle', @式样引用_E824)">
					<xsl:choose>
						<xsl:when test="./表:对齐格式_E7A8/表:水平对齐方式_E700='right'">
							<xsl:attribute name="style:writing-mode">rl-tb</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="style:writing-mode">lr-tb</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:if test="表:背景_E823">
					<xsl:attribute name="fo:background-color"><xsl:value-of select="表:背景_E823"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="表:工作表属性_E80D/表:标签背景色_E7C0">
					<xsl:attribute name="table:tab-color"><xsl:value-of select="表:工作表属性_E80D/表:标签背景色_E7C0"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="表:工作表属性_E80D/表:标签前景色_E7BF">
					<xsl:attribute name="table:tab-font-color"><xsl:value-of select="表:工作表属性_E80D/表:标签前景色_E7BF"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="表:工作表属性_E80D/表:背景填充_E830">
					<xsl:for-each select="表:工作表属性_E80D/表:背景填充_E830">
						<xsl:call-template name="CommonFillAttr"/>
						<xsl:call-template name="CommonFillElement"/>
					</xsl:for-each>
				</xsl:if>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!--从<表:工作表内容>中提取默认的行的式样和列的式样信息。两个模版的结构时类似的，仅在元素命名和属性方面有所不同-->
	<xsl:template name="DefaultColumnStyles">
		<!--根据'表:工作表'节点generate-id()设定该工作表默认列的式样名称，两个，一个是带PageBreak的，一个是不带PageBreak的-->
		<style:style>
			<xsl:attribute name="style:name"><xsl:value-of select="concat('co-default',@名称_E822)"/></xsl:attribute>
			<xsl:attribute name="style:family">table-column</xsl:attribute>
			<style:table-column-properties>
				<xsl:attribute name="fo:break-before">auto</xsl:attribute>
				<xsl:attribute name="style:column-width"><xsl:choose><xsl:when test="表:工作表内容_E80E[@缺省列宽_E7EB]"><xsl:value-of select="concat(表:工作表内容_E80E/@缺省列宽_E7EB, $uofUnit)"/></xsl:when><xsl:otherwise><xsl:value-of select="string('2.267cm')"/></xsl:otherwise></xsl:choose></xsl:attribute>
			</style:table-column-properties>
		</style:style>
		<style:style>
			<xsl:attribute name="style:name"><xsl:value-of select="concat('co-default-page',@名称_E822)"/></xsl:attribute>
			<xsl:attribute name="style:family">table-column</xsl:attribute>
			<style:table-column-properties>
				<xsl:attribute name="fo:break-before">page</xsl:attribute>
				<xsl:attribute name="style:column-width"><xsl:choose><xsl:when test="表:工作表内容_E80E[@缺省列宽_E7EB]"><xsl:value-of select="concat(表:工作表内容_E80E/@缺省列宽_E7EB, $uofUnit)"/></xsl:when><xsl:otherwise><xsl:value-of select="string('2.267cm')"/></xsl:otherwise></xsl:choose></xsl:attribute>
			</style:table-column-properties>
		</style:style>
	</xsl:template>
	<xsl:template name="DefaultRowStyles">
		<!--根据'表:工作表'节点generate-id()设定该工作表默认行的式样名称，两个，一个是带PageBreak的，一个是不带PageBreak的-->
		<style:style>
			<xsl:attribute name="style:name"><xsl:value-of select="concat('ro-default', @名称_E822)"/></xsl:attribute>
			<xsl:attribute name="style:family">table-row</xsl:attribute>
			<style:table-row-properties>
				<xsl:attribute name="fo:break-before">auto</xsl:attribute>
				<xsl:attribute name="style:row-height"><xsl:choose><xsl:when test="表:工作表内容_E80E[@缺省行高列宽_E7E9]"><xsl:value-of select="concat(表:工作表内容_E80E/@缺省行高列宽_E7E9, $uofUnit)"/></xsl:when><xsl:otherwise><xsl:value-of select="string('0.513cm')"/></xsl:otherwise></xsl:choose></xsl:attribute>
			</style:table-row-properties>
		</style:style>
		<style:style>
			<xsl:attribute name="style:name"><xsl:value-of select="concat('ro-default-page', @名称_E822)"/></xsl:attribute>
			<xsl:attribute name="style:family">table-row</xsl:attribute>
			<style:table-row-properties>
				<xsl:attribute name="fo:break-before">page</xsl:attribute>
				<xsl:attribute name="style:row-height"><xsl:choose><xsl:when test="表:工作表内容_E80E[@缺省行高列宽_E7E9]"><xsl:value-of select="concat(表:工作表内容_E80E/@缺省行高列宽_E7E9, $uofUnit)"/></xsl:when><xsl:otherwise><xsl:value-of select="string('0.513cm')"/></xsl:otherwise></xsl:choose></xsl:attribute>
			</style:table-row-properties>
		</style:style>
	</xsl:template>
	<xsl:template match="表:列_E7EC" mode="TableColumStyle">
		<xsl:param name="BeginColum" select="number('1')"/>
		<!--得到当前列的列号-->
		<xsl:variable name="ColumNumber">
			<xsl:choose>
				<xsl:when test="@列号_E7DA">
					<xsl:value-of select="@列号_E7DA"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$BeginColum"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--为当前列生成列式样,先不考虑当前列有分页符的情况,固定生成一个不含分页信息的列式样-->
		<style:style>
			<xsl:attribute name="style:name"><xsl:value-of select="concat('co', generate-id())"/></xsl:attribute>
			<xsl:attribute name="style:family">table-column</xsl:attribute>
			<style:table-column-properties>
				<xsl:attribute name="fo:break-before">auto</xsl:attribute>
				<xsl:if test="@列宽_E7EE">
					<xsl:attribute name="style:column-width"><xsl:value-of select="concat(@列宽_E7EE, $uofUnit)"/></xsl:attribute>
				</xsl:if>
			</style:table-column-properties>
		</style:style>
		<!--处理当前列及其跨度列中有分页符的情况-->
		<xsl:variable name="repeatColumBeginNum" select="$ColumNumber"/>
		<xsl:variable name="repeatColumEndNum">
			<xsl:choose>
				<xsl:when test="@跨度_E7EF">
					<xsl:value-of select="number($ColumNumber) + number(@跨度_E7EF)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$ColumNumber"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="../../表:分页符集_E81E/表:分页符_E81F[number(@列号_E821) + 1 ge number($repeatColumBeginNum) and number(@列号_E7DA) + 1 le number($repeatColumEndNum)]">
			<style:style>
				<xsl:attribute name="style:name"><xsl:value-of select="concat('co-page', generate-id())"/></xsl:attribute>
				<xsl:attribute name="style:family">table-column</xsl:attribute>
				<style:table-column-properties>
					<xsl:attribute name="fo:break-before">page</xsl:attribute>
					<xsl:choose>
						<xsl:when test="@列宽_E7EE">
							<xsl:attribute name="style:column-width"><xsl:value-of select="concat(@列宽_E7EE, $uofUnit)"/></xsl:attribute>
						</xsl:when>
						<xsl:when test="../@缺省列宽_E7EB">
							<xsl:attribute name="style:column-width"><xsl:value-of select="concat(../@缺省列宽_E7EB, $uofUnit)"/></xsl:attribute>
						</xsl:when>
					</xsl:choose>
				</style:table-column-properties>
			</style:style>
		</xsl:if>
		<!--递归处理下一个'表:列'定义，传入参数为当前列（包含跨度）的下一个列的列号-->
		<xsl:if test="following-sibling::表:列_E7EC">
			<xsl:apply-templates select="following-sibling::表:列_E7EC[1]" mode="TableColumStyle">
				<xsl:with-param name="BeginColum" select="number($ColumNumber) + number(@跨度_E7EF) + 1"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template match="表:行_E7F1" mode="TableRowStyle">
		<xsl:param name="BeginRow" select="number('1')"/>
		<!--得到当前列的行号-->
		<xsl:variable name="RowNumber">
			<xsl:choose>
				<xsl:when test="@行号_E7F3">
					<xsl:value-of select="@行号_E7F3"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$BeginRow"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--为当前行生成行式样,先不考虑当前列有分页符的情况,固定生成一个不含分页信息的行式样-->
		<style:style>
			<xsl:attribute name="style:name"><xsl:value-of select="concat('ro', generate-id())"/></xsl:attribute>
			<xsl:attribute name="style:family">table-row</xsl:attribute>
			<style:table-row-properties>
				<xsl:attribute name="fo:break-before">auto</xsl:attribute>
				<xsl:choose>
					<xsl:when test="@行高_E7F4">
						<xsl:attribute name="style:row-height"><xsl:value-of select="concat(@行高_E7F4, $uofUnit)"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="../表:缺省行高列宽_E7E9/@缺省行高_E7EA">
						<xsl:attribute name="style:row-height"><xsl:value-of select="concat(../表:缺省行高列宽_E7E9/@缺省行高_E7EA, $uofUnit)"/></xsl:attribute>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="@是否自适应行高_E7F5">
					<xsl:attribute name="style:use-optimal-row-height"><xsl:value-of select="@是否自适应行高_E7F5"/></xsl:attribute>
				</xsl:if>
			</style:table-row-properties>
		</style:style>
		<!--处理当前行及其跨度中有分页符的情况-->
		<xsl:variable name="repeatRowBeginNum">
			<xsl:value-of select="$RowNumber"/>
		</xsl:variable>
		<xsl:variable name="repeatRowEndNum">
			<xsl:choose>
				<xsl:when test="@跨度_E7EF">
					<xsl:value-of select="number($RowNumber) + number(@跨度_E7EF)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$RowNumber"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="../../表:分页符集_E81E/表:分页符_E81F[(number(@行号_E7F3) + 1) &gt;= number($repeatRowBeginNum) and (number(@行号_E7F3) + 1) &lt;= number($repeatRowEndNum)]">
			<style:style>
				<xsl:attribute name="style:name"><xsl:value-of select="concat('ro-page', generate-id())"/></xsl:attribute>
				<xsl:attribute name="style:family">table-row</xsl:attribute>
				<style:table-row-properties>
					<xsl:attribute name="fo:break-before">page</xsl:attribute>
					<xsl:if test="../表:缺省行高列宽_E7E9/@缺省行高_E7EA">
						<xsl:attribute name="style:row-height"><xsl:value-of select="concat(../表:缺省行高列宽_E7E9/@缺省行高_E7EA, $uofUnit)"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="@行高_E7F4">
						<xsl:attribute name="style:row-width"><xsl:value-of select="concat(@行高_E7F4, $uofUnit)"/></xsl:attribute>
					</xsl:if>
				</style:table-row-properties>
			</style:style>
		</xsl:if>
		<!--递归处理下一个'表:行_E7F1'定义，传入参数为当前行（包含跨度）的下一个行的行号-->
		<xsl:if test="following-sibling::表:行_E7F1">
			<xsl:apply-templates select="following-sibling::表:行_E7F1[1]" mode="TableRowStyle">
				<xsl:with-param name="BeginRow" select="number($RowNumber) + number(@跨度_E7EF) + 1"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template name="BodyTableStyle">
		<xsl:for-each select="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825">
			<xsl:call-template name="OneTableStyle"/>
			<xsl:call-template name="DefaultColumnStyles"/>
			<xsl:choose>
				<xsl:when test="表:工作表内容_E80E/表:列_E7EC">
					<xsl:apply-templates select="表:工作表内容_E80E/表:列_E7EC[1]" mode="TableColumStyle"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="表:分页符集_E81E/表:分页符_E81F[@列号_E821]">
						<style:style>
							<xsl:attribute name="style:name"><xsl:value-of select="concat('co', generate-id())"/></xsl:attribute>
							<xsl:attribute name="style:family">table-column</xsl:attribute>
							<style:table-column-properties>
								<xsl:attribute name="fo:break-before"><xsl:value-of select="string('page')"/></xsl:attribute>
							</style:table-column-properties>
						</style:style>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="DefaultRowStyles"/>
			<xsl:choose>
				<xsl:when test="表:工作表内容_E80E/表:行_E7F1">
					<xsl:apply-templates select="表:工作表内容_E80E/表:行_E7F1[1]" mode="TableRowStyle"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="表:分页符集_E81E/表:分页符_E81F[@行号_E820]">
						<style:style>
							<xsl:attribute name="style:name"><xsl:value-of select="concat('ro', generate-id())"/></xsl:attribute>
							<xsl:attribute name="style:family">table-row</xsl:attribute>
							<style:table-row-properties>
								<xsl:attribute name="fo:break-before"><xsl:value-of select="string('page')"/></xsl:attribute>
								<xsl:choose>
									<xsl:when test="@行高_E7F4">
										<xsl:attribute name="style:row-height"><xsl:value-of select="concat(@行高_E7F4, $uofUnit)"/></xsl:attribute>
									</xsl:when>
									<xsl:when test="../表:缺省行高列宽_E7E9/@缺省行高_E7EA">
										<xsl:attribute name="style:row-height"><xsl:value-of select="concat(../表:缺省行高列宽_E7E9/@缺省行高_E7EA, $uofUnit)"/></xsl:attribute>
									</xsl:when>
								</xsl:choose>
							</style:table-row-properties>
						</style:style>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="TableCellProperties">
		<xsl:if test="表:对齐格式_E7A8">
			<xsl:if test="表:对齐格式_E7A8/表:垂直对齐方式_E701">
				<xsl:variable name="vertical-align">
					<xsl:choose>
						<xsl:when test="表:对齐格式_E7A8/表:垂直对齐方式_E701 = 'top'">top</xsl:when>
						<xsl:when test="表:对齐格式_E7A8/表:垂直对齐方式_E701 = 'center'">middle</xsl:when>
						<xsl:when test="表:对齐格式_E7A8/表:垂直对齐方式_E701 = 'bottom'">bottom</xsl:when>
						<xsl:otherwise>auto</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="style:vertical-align"><xsl:value-of select="$vertical-align"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="表:对齐格式_E7A8/表:文字排列方向_E703 = 'r2l-t2b-0e-90w'">
				<xsl:if test="表:对齐格式_E7A8/表:水平对齐方式_E700 ='general'">
					<xsl:attribute name="style:glyph-orientation-vertical">auto</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="style:direction">ttb</xsl:attribute>
				<xsl:if test="not(表:对齐格式_E7A8/字:水平对齐方式_E700)">
					<xsl:attribute name="style:text-align-source">fix</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="表:对齐格式_E7A8/表:文字旋转角度_E704">
				<xsl:attribute name="style:rotation-angle"><xsl:choose><xsl:when test="表:对齐格式_E7A8/表:文字旋转角度_E704 &lt; 0"><xsl:value-of select="360 + 表:对齐格式_E7A8/表:文字旋转角度_E704"/></xsl:when><xsl:otherwise><xsl:value-of select="表:对齐格式_E7A8/表:文字旋转角度_E704"/></xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:attribute name="style:rotation-align">none</xsl:attribute>
			</xsl:if>
			<xsl:if test="表:对齐格式_E7A8/表:是否自动换行_E705 = 'true'">
				<xsl:attribute name="fo:wrap-option">wrap</xsl:attribute>
			</xsl:if>
			<xsl:if test="表:对齐格式_E7A8/表:是否缩小字体填充_E706 = 'true'">
				<xsl:attribute name="style:shrink-to-fit">true</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="表:边框_4133">
			<xsl:for-each select="表:边框_4133">
				<xsl:if test="@阴影类型_C645 and @阴影类型_C645 !='' and @阴影类型_C645 !='none'">
					<xsl:choose>
						<xsl:when test="@阴影类型_C645 = 'right-bottom'">
							<xsl:attribute name="style:shadow">#808080 5pt 5pt</xsl:attribute>
						</xsl:when>
						<xsl:when test="@阴影类型_C645 = 'right-top'">
							<xsl:attribute name="style:shadow">#808080 5pt -5pt</xsl:attribute>
						</xsl:when>
						<xsl:when test="@阴影类型_C645 = 'left-bottom'">
							<xsl:attribute name="style:shadow">#808080 -5pt 5pt</xsl:attribute>
						</xsl:when>
						<xsl:when test="@阴影类型_C645 = 'left-top'">
							<xsl:attribute name="style:shadow">#808080 -5pt -5pt</xsl:attribute>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<xsl:call-template name="CommonBorder">
					<xsl:with-param name="pUp" select="uof:上_C614"/>
					<xsl:with-param name="pDown" select="uof:下_C616"/>
					<xsl:with-param name="pLeft" select="uof:左_C613"/>
					<xsl:with-param name="pRight" select="uof:右_C615"/>
					<xsl:with-param name="pDiagon1" select="uof:对角线1_C617"/>
					<xsl:with-param name="pDiagon2" select="uof:对角线2_C618"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="表:填充_E7A3">
			<xsl:for-each select="表:填充_E7A3">
				<xsl:call-template name="CommonFill"/>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="表:字体格式_E7A7/字:是否隐藏文字_413D">
			<xsl:choose>
				<xsl:when test="string(表:字体格式_E7A7/字:是否隐藏文字_413D) = 'true'">
					<xsl:attribute name="style:cell-protect">protected formula-hidden</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="style:cell-protect">none</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="表:对齐格式_E7A8/表:水平对齐方式_E700 = 'fill'">
			<xsl:attribute name="style:repeat-content">true</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TableParaProperties">
		<xsl:element name="style:paragraph-properties">
			<xsl:if test="表:对齐格式_E7A8/表:水平对齐方式_E700">
				<xsl:variable name="text-align">
					<xsl:choose>
						<xsl:when test="表:对齐格式_E7A8/表:水平对齐方式_E700 = 'left'">start</xsl:when>
						<xsl:when test="表:对齐格式_E7A8/表:水平对齐方式_E700 = 'center'">center</xsl:when>
						<xsl:when test="表:对齐格式_E7A8/表:水平对齐方式_E700 = 'right'">end</xsl:when>
						<xsl:when test="表:对齐格式_E7A8/表:水平对齐方式_E700 = 'justify'">justify</xsl:when>
						<xsl:when test="表:对齐格式_E7A8/表:水平对齐方式_E700 = 'fill'">start</xsl:when>
						<xsl:otherwise>auto</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="fo:text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="表:对齐格式_E7A8/表:缩进_E702">
				<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(表:对齐格式_E7A8/表:缩进_E702,$uofUnit)"/></xsl:attribute>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template name="OneTableCellStyle">
		<xsl:attribute name="style:family">table-cell</xsl:attribute>
		<xsl:attribute name="style:name"><xsl:value-of select="@标识符_E7AC"/></xsl:attribute>
		<xsl:attribute name="style:display-name"><xsl:value-of select="@标识符_E7AC"/></xsl:attribute>
		<xsl:attribute name="style:parent-style-name">Default</xsl:attribute>
		<xsl:if test="表:数字格式_E7A9">
			<xsl:attribute name="style:data-style-name"><xsl:value-of select="concat( @标识符_E7AC, 'F')"/></xsl:attribute>
		</xsl:if>
		<xsl:element name="style:table-cell-properties">
			<xsl:call-template name="TableCellProperties"/>
		</xsl:element>
		<xsl:if test="表:对齐格式_E7A8">
			<xsl:call-template name="TableParaProperties"/>
		</xsl:if>
		<xsl:if test="表:字体格式_E7A7">
			<xsl:element name="style:text-properties">
				<xsl:for-each select="表:字体格式_E7A7">
					<xsl:call-template name="TextProperties"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
		<xsl:apply-templates select="规则:条件格式化_B629"/>
	</xsl:template>
	<xsl:template match="式样:单元格式样_9916">
		<xsl:param name="Type"/>
		<xsl:if test="@类型_E7AE=$Type">
			<xsl:choose>
				<xsl:when test="$Type='default'">
					<xsl:element name="style:default-style">
						<xsl:attribute name="style:family">table-cell</xsl:attribute>
						<xsl:element name="style:table-cell-properties">
							<xsl:call-template name="TableCellProperties"/>
						</xsl:element>
						<xsl:if test="表:对齐格式_E7A8">
							<xsl:call-template name="TableParaProperties"/>
						</xsl:if>
						<xsl:if test="表:字体格式_E7A7">
							<xsl:element name="style:text-properties">
								<xsl:for-each select="表:字体格式_E7A7">
									<xsl:call-template name="TextProperties"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<xsl:apply-templates select="规则:条件格式化_B629"/>
					</xsl:element>
					<xsl:element name="style:style">
						<xsl:attribute name="style:family">table-cell</xsl:attribute>
						<xsl:attribute name="style:name">Default</xsl:attribute>
						<xsl:attribute name="style:display-name">Default</xsl:attribute>
						<xsl:if test="表:数字格式_E7A9">
							<xsl:attribute name="style:data-style-name">DefaultF</xsl:attribute>
						</xsl:if>
						<xsl:element name="style:table-cell-properties">
							<xsl:call-template name="TableCellProperties"/>
						</xsl:element>
						<xsl:if test="表:对齐格式_E7A8">
							<xsl:call-template name="TableParaProperties"/>
						</xsl:if>
						<xsl:if test="表:字体格式_E7A7">
							<xsl:element name="style:text-properties">
								<xsl:for-each select="表:字体格式_E7A7">
									<xsl:call-template name="TextProperties"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
					</xsl:element>
					<xsl:if test="表:数字格式_E7A9[@分类名称_E740 and @分类名称_E740 != 'general']">
						<xsl:for-each select="表:数字格式_E7A9">
							<xsl:call-template name="NumberStyle">
								<xsl:with-param name="style-id" select="'Default'"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:if>
					<xsl:apply-templates select="规则:条件格式化_B629"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="style:style">
						<xsl:call-template name="OneTableCellStyle"/>
					</xsl:element>
					<xsl:variable name="style-id" select="@标识符_E7AC"/>
					<xsl:for-each select="表:数字格式_E7A9[@格式码_E73F]">
						<xsl:call-template name="NumberStyle">
							<xsl:with-param name="style-id" select="$style-id"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--xsl:key name="condtionalcells" match="/uof:UOF_0000/表:电子表格文档_E826/表:工作表_E825/表:工作表内容_E80E/表:行_E7F1/表:单元格_E7F2" use="@表:条件格式化"/>
	<xsl:key name="cellstyles" match="/uof:UOF_0000/式样:式样集_990B/式样:单元格式样集_9915/式样:单元格式样_9916" use="@标识符_E7AC"/-->
	<xsl:template match="规则:条件格式化_B629">
		<xsl:for-each select="规则:条件_B62B">
			<xsl:element name="style:map">
				<xsl:variable name="condition-text">
					<xsl:choose>
						<xsl:when test="@类型_B673='cell-value'">
							<xsl:choose>
								<xsl:when test="规则:操作码_B62C/text()='between' ">
									<xsl:value-of select="concat('cell-content-is-between','(',规则:第一操作数_B61E/text(),',',规则:第二操作数_B61F/text(),')')"/>
								</xsl:when>
								<xsl:when test=" 规则:操作码_B62C/text()='not-between'">
									<xsl:value-of select="concat('cell-content-is-not-between','(',规则:第一操作数_B61E/text(),',',规则:第二操作数_B61F/text(),')')"/>
								</xsl:when>
								<xsl:when test=" 规则:操作码_B62C/text()='equal-to'">
									<xsl:value-of select="concat('cell-content()=',规则:第一操作数_B61E/text())"/>
								</xsl:when>
								<xsl:when test=" 规则:操作码_B62C/text()='not-equal-to'">
									<xsl:value-of select="concat('cell-content()!=',规则:第一操作数_B61E/text())"/>
								</xsl:when>
								<xsl:when test=" 规则:操作码_B62C/text()='greater-than'">
									<xsl:value-of select="concat('cell-content()&gt;',规则:第一操作数_B61E/text())"/>
								</xsl:when>
								<xsl:when test=" 规则:操作码_B62C/text()='less-than'">
									<xsl:value-of select="concat('cell-content()&lt;',规则:第一操作数_B61E/text())"/>
								</xsl:when>
								<xsl:when test=" 规则:操作码_B62C/text()='greater-than-or-equal-to'">
									<xsl:value-of select="concat('cell-content()&gt;=',规则:第一操作数_B61E/text())"/>
								</xsl:when>
								<xsl:when test=" 规则:操作码_B62C/text()='less-than-or-equal-to'">
									<xsl:value-of select="concat('cell-content()&lt;=',规则:第一操作数_B61E/text())"/>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="@类型_B673='formula'">
							<xsl:value-of select="concat('is-true-formula','(',规则:第一操作数_B61E/text(),')')"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="address">
					<xsl:value-of select="../规则:区域集_B61A/规则:区域_B62A[1]"/>
				</xsl:variable>
				<xsl:variable name="apos">&apos;</xsl:variable>
				<xsl:attribute name="style:condition"><xsl:value-of select="$condition-text"/></xsl:attribute>
				<xsl:attribute name="style:apply-style-name"><xsl:value-of select="规则:格式_B62D/@式样引用_B62E"/></xsl:attribute>
				<xsl:attribute name="style:base-cell-address"><xsl:value-of select="concat(substring-before(substring-after($address,$apos),$apos),'.',substring-before(substring-after(substring-after($address,':'),'$'),'$'),substring-after(substring-after(substring-after($address,':'),'$'),'$'))"/></xsl:attribute>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="BorderLineAttr">
		<xsl:variable name="type" select="@线型_C60D"/>
		<xsl:variable name="dash" select="@虚实_C60E"/>
		<!-- LineStyle -->
		<xsl:variable name="draw-stroke">
			<xsl:choose>
				<xsl:when test="$type='none'">none</xsl:when>
				<xsl:when test="string($type)=''">none</xsl:when>
				<xsl:when test="$dash='round-dot' or $dash='square-dot' or $dash='dash' or $dash='dash-dot' or $dash='long-dash' or $dash='long-dash-dot' or $dash='dash-dot-dot'">dash</xsl:when>
				<xsl:otherwise>solid</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="draw:stroke"><xsl:value-of select="$draw-stroke"/></xsl:attribute>
		<xsl:if test="$type='none'">
			<xsl:attribute name="fo:border">none</xsl:attribute>
		</xsl:if>
		<xsl:variable name="stroke-dash">
			<xsl:choose>
				<xsl:when test="$dash='round-dot'">round-dot</xsl:when>
				<xsl:when test="$dash='square-dot'">square-dot</xsl:when>
				<xsl:when test="$dash='dash'">dash</xsl:when>
				<xsl:when test="$dash='dash-dot'">dash-dot</xsl:when>
				<xsl:when test="$dash='long-dash'">long-dash</xsl:when>
				<xsl:when test="$dash='long-dash-dot'">long-dash-dot</xsl:when>
				<xsl:when test="$dash='dash-dot-dot'">dash-dot-dot</xsl:when>
				<xsl:otherwise>Fine Dashed</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$draw-stroke != 'none'">
			<xsl:attribute name="draw:stroke-dash"><xsl:value-of select="$stroke-dash"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@颜色_C611">
			<xsl:attribute name="svg:stroke-color"><xsl:value-of select="@颜色_C611"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@宽度_C60F">
			<xsl:attribute name="svg:stroke-width"><xsl:value-of select="concat(@宽度_C60F, $uofUnit)"/></xsl:attribute>
		</xsl:if>
		<!-- Waiting, ShadowLine -->
	</xsl:template>
	<xsl:template match="图表:边框线_4226" mode="chartstyle">
		<!-- Waiting, FrameType, including Top, Bottom, Left, Right, On The Cross -->
	</xsl:template>
	<xsl:template name="GraphicEleAndTextPropEle">
		<xsl:param name="par_DefaultColor"/>
		<xsl:element name="style:graphic-properties">
			<xsl:for-each select="图表:对齐_E726/图表:是否自动换行_E705">
				<xsl:variable name="w-o">
					<xsl:choose>
						<xsl:when test="'true'">wrap</xsl:when>
						<xsl:otherwise>no-wrap</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="fo:wrap-option" select="$w-o"/>
			</xsl:for-each>
			<xsl:for-each select="图表:边框线_4226">
				<xsl:call-template name="BorderLineAttr"/>
			</xsl:for-each>
			<xsl:choose>
				<xsl:when test="图表:填充_E746">
					<xsl:for-each select="图表:填充_E746">
						<xsl:call-template name="FillGraph">
							<xsl:with-param name="par_DefaultColor" select="$par_DefaultColor"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
			<xsl:attribute name="draw:opacity">100%</xsl:attribute>
			<!-- no Foreward Color data in ODF -->
			<xsl:if test="图表:数据标记_E70E/@背景色E711">
				<xsl:attribute name="draw:stroke" select="'solid'"/>
				<xsl:attribute name="svg:stroke-color" select="图表:数据标记_E70E/@背景色E711"/>
			</xsl:if>
		</xsl:element>
		<xsl:element name="style:text-properties">
			<!-- absent fucntions -->
			<xsl:for-each select="图表:图例项_E765[1]/图表:字体_E70B">
				<xsl:call-template name="TextProperties"/>
			</xsl:for-each>
			<xsl:for-each select="图表:字体_E70B">
				<xsl:call-template name="TextProperties"/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="AlignAttr">
		<xsl:if test="图表:水平对齐方式_E700">
			<xsl:variable name="t-h-a">
				<xsl:choose>
					<!-- no supported functions in ODF -->
					<xsl:when test="图表:水平对齐方式_E700 = 'center'">center</xsl:when>
					<xsl:when test="图表:水平对齐方式_E700 = 'left'">left</xsl:when>
					<xsl:when test="图表:水平对齐方式_E700 = 'right'">right</xsl:when>
					<xsl:when test="图表:水平对齐方式_E700 = 'fill'">justify</xsl:when>
					<xsl:when test="图表:水平对齐方式_E700 = 'center across selection'">center</xsl:when>
					<xsl:when test="图表:水平对齐方式_E700 = 'distributed'">justify</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="draw:textarea-horizontal-align" select="$t-h-a"/>
		</xsl:if>
		<xsl:if test="图表:垂直对齐方式_E701">
			<xsl:variable name="t-v-a">
				<xsl:choose>
					<!-- no supported functions in ODF -->
					<xsl:when test="图表:垂直对齐方式_E701 = 'top'">top</xsl:when>
					<xsl:when test="图表:垂直对齐方式_E701 = 'center'">middle</xsl:when>
					<xsl:when test="图表:垂直对齐方式_E701 = 'bottom'">bottom</xsl:when>
					<xsl:when test="图表:垂直对齐方式_E701 = 'justify'">justify</xsl:when>
					<xsl:when test="图表:垂直对齐方式_E701 = 'distributed'">justify</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="draw:textarea-vertical-align" select="$t-v-a"/>
		</xsl:if>
		<!-- Waiting, see graphic-properties -->
		<xsl:if test="图表:文字排列方向_E703">
			<xsl:variable name="d">
				<xsl:choose>
					<xsl:when test="图表:文字排列方向_E703='r2l-t2b-90e-90w'">ttb</xsl:when>
					<xsl:when test="图表:文字排列方向_E703='r2l-t2b-0e-90w'">ttb</xsl:when>
					<xsl:when test="图表:文字排列方向_E703='t2b-l2r-0e-0w'">ltr</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="style:direction" select="$d"/>
		</xsl:if>
		<!--xsl:variable name="r-a">
			<xsl:choose>
				<xsl:when test="图表:文字旋转角度_E704">
					<xsl:value-of select="图表:文字旋转角度_E704"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable-->
		<xsl:if test="图表:文字旋转角度_E704">
			<xsl:attribute name="style:rotation-angle" select="图表:文字旋转角度_E704"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="图表:图表区_E743" mode="chartstyle">
		<style:style style:name="chart-area" style:family="chart">
			<xsl:call-template name="GraphicEleAndTextPropEle"/>
		</style:style>
	</xsl:template>
	<xsl:template match="图表:数据标签_E752" mode="chartstyle">
		<xsl:attribute name="chart:data-label-text"><xsl:value-of select="@是否显示系列名_E715"/></xsl:attribute>
		<xsl:attribute name="chart:data-label-text"><xsl:value-of select="@是否显示类别名_E716"/></xsl:attribute>
		<xsl:choose>
			<xsl:when test="@是否显示数值_E717='true' and @是否百分数图表_E718='true'">
				<!--xsl:attribute name="chart:data-label-number">group-bars-per-axis</xsl:attribute-->
				<xsl:attribute name="chart:data-label-number">value-and-percentage</xsl:attribute>
			</xsl:when>
			<xsl:when test="@是否显示数值_E717='true'">
				<xsl:attribute name="chart:data-label-number">value</xsl:attribute>
			</xsl:when>
			<xsl:when test="@是否百分数图表_E718='true'">
				<xsl:attribute name="chart:data-label-number">percentage</xsl:attribute>
			</xsl:when>
			<xsl:when test="@是否显示数值_E717='false'">
				<xsl:attribute name="chart:data-label-number">none</xsl:attribute>
			</xsl:when>
		</xsl:choose>
		<xsl:attribute name="chart:data-label-symbol"><xsl:value-of select="@是否显示图例标志_E719"/></xsl:attribute>
		<xsl:if test="@分隔符_E71A">
			<xsl:element name="chart:label-separator">
				<xsl:element name="text:p">
					<xsl:choose>
						<xsl:when test="@分隔符_E71A='1'">, </xsl:when>
						<xsl:when test="@分隔符_E71A='2'">; </xsl:when>
						<xsl:when test="@分隔符_E71A='3'">
							<text:line-break/>
						</xsl:when>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<!-- no supported functions in ODF -->
	</xsl:template>
	<xsl:template match="图表:数据标记_E70E" mode="chartstyle">
		<xsl:choose>
			<xsl:when test="@类型_E70F='none' or not(@类型_E70F)">
				<xsl:attribute name="chart:symbol-type" select="'none'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="chart:symbol-type" select="'named-symbol'"/>
				<xsl:variable name="symbol-name">
					<xsl:choose>
						<xsl:when test="@类型_E70F='triangle'">arrow-up</xsl:when>
						<xsl:when test="@类型_E70F='square-cross'">x</xsl:when>
						<xsl:when test="@类型_E70F='square-star'">asterisk</xsl:when>
						<xsl:when test="@类型_E70F='half-line' or @类型_E70F='line'">horizontal-bar</xsl:when>
						<xsl:when test="@类型_E70F='square-plus'">plus</xsl:when>
						<xsl:otherwise>
							<!-- include square, diamond, circle -->
							<xsl:value-of select="@类型_E70F"/>
						</xsl:otherwise>
						<!-- surplus types in ODF: star, vertical-bar, arrow-down, arrow-right, arrow-left, bow-tie, hourglass -->
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="chart:symbol-name"><xsl:value-of select="$symbol-name"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="@大小_E712='7'">
				<xsl:attribute name="chart:symbol-width">0.25cm</xsl:attribute>
				<xsl:attribute name="chart:symbol-height">0.25cm</xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="图表:数据点集_E755" mode="chartstyle">
		<xsl:for-each select="图表:数据点_E756">
			<style:style style:family="chart">
				<xsl:attribute name="style:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
				<style:chart-properties>
					<xsl:apply-templates select="图表:数据标签_E752" mode="chartstyle"/>
					<xsl:apply-templates select="图表:数据标记_E70E" mode="chartstyle"/>
				</style:chart-properties>
				<xsl:call-template name="GraphicEleAndTextPropEle"/>
			</style:style>
			<!-- no supported functions in ODF -->
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="图表:误差线_E75A" mode="error-attr">
		<!-- no supported functions in ODF, no X error bars -->
		<xsl:if test="@方向_E75F='Y'">
			<!-- no supported functions in ODF -->
			<!-- <xsl:if test="@是否显示误差标记_E75B"></xsl:if> -->
			<xsl:if test="@显示方式_E75C">
				<xsl:choose>
					<xsl:when test="@显示方式_E75C='positive'">
						<xsl:attribute name="chart:error-upper-indicator" select="'true'"/>
					</xsl:when>
					<xsl:when test="@显示方式_E75C='negtive'">
						<xsl:attribute name="chart:error-lower-indicator" select="'true'"/>
					</xsl:when>
					<xsl:when test="@显示方式_E75C='both'">
						<xsl:attribute name="chart:error-upper-indicator" select="'true'"/>
						<xsl:attribute name="chart:error-lower-indicator" select="'true'"/>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="@类型_E75D">
				<xsl:choose>
					<xsl:when test="@类型_E75D='custom'">
						<xsl:attribute name="chart:error-category" select="'constant'"/>
						<xsl:attribute name="chart:error-upper-limit"><!--xsl:value-of select="@加_E760"/--><xsl:value-of select="@值_E75E"/></xsl:attribute>
						<xsl:attribute name="chart:error-lower-limit"><!--xsl:value-of select="@减_E760"/--><xsl:value-of select="@值_E75E"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="@类型_E75D='fixed-value'">
						<xsl:attribute name="chart:error-category" select="'constant'"/>
						<xsl:attribute name="chart:error-upper-limit"><xsl:value-of select="@值_E75E"/></xsl:attribute>
						<xsl:attribute name="chart:error-lower-limit"><xsl:value-of select="@值_E75E"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="@类型_E75D='percentage'">
						<xsl:attribute name="chart:error-category" select="'percentage'"/>
						<xsl:attribute name="chart:error-percentage" select="@值_E75E"/>
					</xsl:when>
					<xsl:when test="@类型_E75D='std-dev'">
						<xsl:attribute name="chart:error-category" select="'standard-deviation'"/>
					</xsl:when>
					<!-- 100520版UOF2.0错误 'srd-err' 应为 'std-err' -->
					<xsl:when test="@类型_E75D='std-err'">
						<!-- this enumeration has not in ODF -->
						<xsl:attribute name="chart:error-category" select="'standard-error'"/>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="图表:误差线集_E759" mode="chartstyle">
		<xsl:for-each select="图表:误差线_E75A">
			<style:style>
				<xsl:attribute name="style:name" select="generate-id(.)"/>
				<xsl:attribute name="style:family" select="'chart'"/>
				<style:chart-properties>
					<xsl:variable name="error-category">
						<xsl:choose>
							<xsl:when test="@类型_E75D='custom'">constant</xsl:when>
							<xsl:when test="@类型_E75D='fixed-value'">constant</xsl:when>
							<xsl:when test="@类型_E75D='percentage'">percentage</xsl:when>
							<xsl:when test="@类型_E75D='std-dev'">standard-deviation</xsl:when>
							<xsl:when test="@类型_E75D='srd-err'">standard-error</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="chart:error-category" select="$error-category"/>
				</style:chart-properties>
				<style:graphic-properties>
					<xsl:for-each select="图表:边框线_4226">
						<xsl:call-template name="BorderLineAttr"/>
					</xsl:for-each>
				</style:graphic-properties>
			</style:style>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="图表:趋势线集_E762" mode="chartstyle">
		<xsl:for-each select="图表:趋势线_E763[1]">
			<style:style>
				<xsl:attribute name="style:name" select="generate-id(.)"/>
				<xsl:attribute name="style:family" select="'chart'"/>
				<style:graphic-properties>
					<xsl:for-each select="图表:边框线_4226">
						<xsl:call-template name="BorderLineAttr"/>
					</xsl:for-each>
				</style:graphic-properties>
				<!-- TuLiXiang was not supported in ODF -->
			</style:style>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="图表:数据系列集_E74E" mode="chartstyle">
		<xsl:for-each select="图表:数据系列_E74F">
			<style:style>
				<xsl:attribute name="style:family">chart</xsl:attribute>
				<xsl:variable name="var_Pos">
					<!--xsl:choose>
						<xsl:when test="@名称_E774">
							<xsl:value-of select="@名称_E774"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="position()"/>
						</xsl:otherwise>
					</xsl:choose-->
					<xsl:value-of select="position()"/>
				</xsl:variable>
				<!-- Waiting, @FeiLeiMing, Zhi, HuiZhiZhou -->
				<xsl:attribute name="style:name"><xsl:value-of select="concat('DataSerial',string($var_Pos))"/></xsl:attribute>
				<style:chart-properties>
					<xsl:apply-templates select="图表:数据标记_E70E" mode="chartstyle"/>
					<xsl:apply-templates select="图表:数据标签_E752" mode="chartstyle"/>
					<!--xsl:choose>
						< these code is no necessary now >
						<xsl:when test="string($par_类型) = 'line'">
							<xsl:choose>
								<xsl:when test="string($par_子类型) = 'clustered-marker'">
									<xsl:attribute name="chart:symbol-type" select="string('named-symbol')"/>
									<xsl:attribute name="chart:symbol-name">
										<xsl:call-template name="getChartLineSymbol">
											<xsl:with-param name="par_Index" select="$par_序号"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						>
					</xsl:choose-->
					<xsl:if test="contains(@子类型_E777,'stacked')">
						<xsl:attribute name="chart:stacked" select="'true'"/>
					</xsl:if>
					<xsl:if test="contains(@子类型_E777,'percent')">
						<xsl:attribute name="chart:percentage" select="'true'"/>
					</xsl:if>
					<xsl:if test="@类型_E75D = 'pie' and contains(@子类型_E777,'exploded')">
						<xsl:attribute name="chart:pie-offset">20</xsl:attribute>
					</xsl:if>
					<!-- Waiting, too much subtypes -->
					<xsl:apply-templates select="图表:误差线集_E759/图表:误差线_E75A[1]" mode="error-attr"/>
					<xsl:for-each select="图表:趋势线集_E762/图表:趋势线_E763[1]">
						<xsl:variable name="regression-type">
							<xsl:choose>
								<!--xsl:when test="@类型_E76C='exponential'">exponential</xsl:when>
								<xsl:when test="@类型_E76C='linear'">linear</xsl:when>
								<xsl:when test="@类型_E76C='logarithmic'">logarithmic</xsl:when>
								<xsl:when test="@类型_E76C='power'">power</xsl:when-->
								<!-- Waiting , temporary value is none -->
								<xsl:when test="@类型_E76C='moving-average' or @类型_E76C='polynomial'">none</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@类型_E76C"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:attribute name="chart:regression-type" select="$regression-type"/>
					</xsl:for-each>
				</style:chart-properties>
				<style:graphic-properties>
					<!--xsl:choose>
						<xsl:when test="表:边框_4133">
							<xsl:apply-templates select="表:边框_4133" mode="chartstyle"/>
						</xsl:when>
						<-边框的颜色会自动设置
						<xsl:otherwise>
							<xsl:attribute name="svg:stroke-color">
								<xsl:call-template name="getDefaultColor">
									<xsl:with-param name="par_Index" select="$var_Pos"/>
								</xsl:call-template>
							</xsl:attribute>
						</xsl:otherwise>
						->
					</xsl:choose-->
					<xsl:for-each select="图表:边框线_4226">
						<xsl:call-template name="BorderLineAttr"/>
					</xsl:for-each>
					<xsl:choose>
						<xsl:when test="图表:填充_E746">
							<xsl:for-each select="图表:填充_E746">
								<xsl:call-template name="FillGraph">
									<xsl:with-param name="par_DefaultColor">
										<xsl:call-template name="getDefaultColor">
											<xsl:with-param name="par_Index" select="$var_Pos"/>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="draw:fill-color"><xsl:call-template name="getDefaultColor"><xsl:with-param name="par_Index" select="$var_Pos"/></xsl:call-template></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</style:graphic-properties>
			</style:style>
			<xsl:apply-templates select="图表:数据点集_E755" mode="chartstyle"/>
			<!-- Waiting, New Funciton : xsl:apply-templates select="图表:引导线_E758" mode="chartstyle" -->
			<xsl:apply-templates select="图表:误差线集_E759" mode="chartstyle"/>
			<xsl:apply-templates select="图表:趋势线集_E762" mode="chartstyle"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="StockMarkerStyle">
		<!-- DieZhuXian, ZhangZhuXian -->
		<style:style style:family="chart" style:name="GnMk">
			<xsl:attribute name="style:name" select="generate-id()"/>
			<style:graphic-properties>
				<xsl:for-each select="图表:边框线_4226">
					<xsl:call-template name="BorderLineAttr"/>
				</xsl:for-each>
				<xsl:for-each select="图表:填充_E746">
					<xsl:call-template name="FillGraph">
						<!--xsl:with-param name="par_DefaultColor" select="$par_DefaultColor"/-->
					</xsl:call-template>
				</xsl:for-each>
			</style:graphic-properties>
		</style:style>
	</xsl:template>
	<xsl:template match="图表:刻度_E71D" mode="chartstyle">
		<xsl:if test="图表:最小值_E71E!=''">
			<xsl:attribute name="chart:minimum"><xsl:value-of select="图表:最小值_E71E"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="图表:最大值_E720!=''">
			<xsl:attribute name="chart:maximum"><xsl:value-of select="图表:最大值_E720"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="图表:主单位_E721!=''">
			<xsl:attribute name="chart:interval-major"><xsl:value-of select="图表:主单位_E721"/></xsl:attribute>
			<xsl:if test="图表:次单位_E722!='' and not(图表:次单位_E722='0')">
				<xsl:attribute name="chart:interval-minor-divisor"><xsl:value-of select="number(图表:主单位_E721) div number(图表:次单位_E722)"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="图表:是否显示为对数刻度_E729='true' or 图表:是否显示为对数刻度_E729='1'">
			<xsl:attribute name="chart:logarithmic">true</xsl:attribute>
		</xsl:if>
		<xsl:if test="图表:是否次序反转_E72B">
			<xsl:choose>
				<xsl:when test="图表:是否次序反转_E72B = 'false'">
					<xsl:attribute name="chart:reverse-direction">false</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="chart:reverse-direction">true</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="../@子类型_E793 = 'value'">
				<xsl:if test="图表:数值次序反转">
					<xsl:choose>
						<xsl:when test="图表:数值次序反转 = 'false'">
							<xsl:attribute name="chart:reverse-direction">false</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="chart:reverse-direction">true</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="图表:交叉点_E723 != ''">
					<xsl:attribute name="chart:axis-position"><xsl:value-of select="图表:交叉点_E723"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="../../图表:坐标轴_E791[@子类型_E793 = 'category']/图表:刻度_E71D/图表:交叉点_E723 !=''">
					<xsl:attribute name="chart:origin"><xsl:value-of select="../../图表:坐标轴_E791[@子类型_E793 = 'category']/图表:刻度_E71D/图表:交叉点_E723"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:when test="../@子类型_E793 = 'category'">
				<xsl:if test="图表:分类次序反转">
					<xsl:choose>
						<xsl:when test="图表:分类次序反转 = 'false'">
							<xsl:attribute name="chart:reverse-direction">false</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="chart:reverse-direction">true</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="图表:交叉点_E723 != ''">
					<xsl:attribute name="chart:axis-position"><xsl:value-of select="图表:交叉点_E723 != ''"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!--xsl:choose>
			<xsl:when test="../@主类型_E792='primary'">
				<xsl:for-each select="../../表:坐标轴_E791[@主类型_E792='secondary']/表:刻度_E71D">
					<xsl:for-each select="表:交叉点_E723">
						<xsl:attribute name="chart:axis-position"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="表:分类刻度数_E72D">
					<Waiting>
					<xsl:attribute name="chart:interval-major"><xsl:value-of select="."/></xsl:attribute>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="../@主类型_E792='secondary'">
				<xsl:for-each select="../../表:坐标轴_E791[@主类型_E792='primary']/表:刻度_E71D">
					<xsl:for-each select="表:交叉点_E723">
						<xsl:attribute name="chart:axis-position"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<xsl:for-each select="表:分类标签数_E72C">
						<xsl:attribute name="chart:interval-major"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose-->
		<!-- xsl::choose>
			<xsl:when test="../../表:坐标轴_E791[@主类型_E792=current()/../@主类型_E792 and @子类型_E793!=(current()/../@子类型_E793)]/表:刻度_E71D">
				<xsl:for-each select="../../表:坐标轴_E791[@主类型_E792=current()/../@主类型_E792 and @子类型_E793!=(current()/../@子类型_E793)]/表:刻度_E71D">
					<xsl:if test="表:交叉点_E723 !=''">
						<xsl:attribute name="chart:axis-position" select="表:交叉点_E723"/>
					</xsl:if>
					<xsl:if test="表:分类标签数_E72C != ''">
						<xsl:attribute name="chart:interval-major" select="表:分类标签数_E72C"/>
					</xsl:if>
					<Absent Function: xsl:for-each select="表:分类刻度数_E72D">
					</xsl:for-each->
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="../../表:坐标轴_E791[@子类型_E793!=(current()/../@子类型_E793)]/表:刻度_E71D">					
					<xsl:if test="表:交叉点_E723 !=''">
						<xsl:attribute name="chart:axis-position" select="表:交叉点_E723"/>
					</xsl:if>
					<xsl:if test="表:分类标签数_E72C != ''">
						<xsl:attribute name="chart:interval-major" select="表:分类标签数_E72C"/>
					</xsl:if>
					<!-xsl:for-each select="表:分类刻度数_E72D">
					</xsl:for-each->
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose-->
		<xsl:if test="图表:交叉点_E723 !=''">
			<xsl:attribute name="chart:axis-position" select="图表:交叉点_E723"/>
		</xsl:if>
		<!-- Waiting, 显示单位、 是否交叉于最大值、 数值轴是否至于分类轴之间-->
	</xsl:template>
	<xsl:template match="图表:网格线集_E733" mode="chartstyle">
		<xsl:for-each select="图表:网格线_E734">
			<style:style style:family="chart">
				<xsl:attribute name="style:name" select="generate-id(.)"/>
				<style:graphic-properties>
					<xsl:call-template name="BorderLineAttr"/>
				</style:graphic-properties>
			</style:style>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="图表:标题_E736" mode="chartstyle">
		<style:style style:family="chart">
			<xsl:attribute name="style:name" select="generate-id(.)"/>
			<style:chart-properties>
				<xsl:for-each select="图表:对齐_E726">
					<xsl:call-template name="AlignAttr"/>
					<!-- Waiting, see graphic-properties -->
				</xsl:for-each>
			</style:chart-properties>
			<xsl:call-template name="GraphicEleAndTextPropEle"/>
		</style:style>
		<!--@名称 位置 在 chartbody-->
	</xsl:template>
	<xsl:template match="图表:坐标轴_E791" mode="chartstyle">
		<style:style style:family="chart">
			<xsl:attribute name="style:name" select="generate-id(.)"/>
			<xsl:for-each select="图表:数值_E70D[@分类名称_E740]">
				<xsl:attribute name="style:data-style-name"><xsl:value-of select="concat(generate-id(.),'F')"/></xsl:attribute>
			</xsl:for-each>
			<style:chart-properties>
				<xsl:choose>
					<!-- @主刻度类型_E737 缺省取"inside"  by yao.wang@cs2c.com.cn, starting -->
					<xsl:when test="@主刻度类型_E737='none'">
						<xsl:attribute name="chart:tick-marks-major-inner">false</xsl:attribute>
						<xsl:attribute name="chart:tick-marks-major-outer">false</xsl:attribute>
					</xsl:when>
					<xsl:when test="@主刻度类型_E737='cross'">
						<xsl:attribute name="chart:tick-marks-major-inner">true</xsl:attribute>
						<xsl:attribute name="chart:tick-marks-major-outer">true</xsl:attribute>
					</xsl:when>
					<xsl:when test="@主刻度类型_E737='outside'">
						<xsl:attribute name="chart:tick-marks-major-inner">false</xsl:attribute>
						<xsl:attribute name="chart:tick-marks-major-outer">true</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="chart:tick-marks-major-inner">true</xsl:attribute>
						<xsl:attribute name="chart:tick-marks-major-outer">false</xsl:attribute>
					</xsl:otherwise>
					<!-- Ending. -->
				</xsl:choose>
				<xsl:choose>
					<!-- @次刻度类型_E738 缺省取"none" starting -->
					<xsl:when test="@次刻度类型_E738='cross'">
						<xsl:attribute name="chart:tick-marks-minor-inner">true</xsl:attribute>
						<xsl:attribute name="chart:tick-marks-minor-outer">true</xsl:attribute>
					</xsl:when>
					<xsl:when test="@次刻度类型_E738='inside'">
						<xsl:attribute name="chart:tick-marks-minor-inner">true</xsl:attribute>
						<xsl:attribute name="chart:tick-marks-minor-outer">false</xsl:attribute>
					</xsl:when>
					<xsl:when test="@次刻度类型_E738='outside'">
						<xsl:attribute name="chart:tick-marks-minor-inner">false</xsl:attribute>
						<xsl:attribute name="chart:tick-marks-minor-outer">true</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="chart:tick-marks-minor-inner">false</xsl:attribute>
						<xsl:attribute name="chart:tick-marks-minor-outer">false</xsl:attribute>
					</xsl:otherwise>
					<!-- Ending. -->
				</xsl:choose>
				<!-- @刻度线标志_E739 缺省取 'next-to-axis' starting -->
				<xsl:attribute name="chart:display-label">true</xsl:attribute>
				<xsl:choose>
					<xsl:when test="@刻度线标志_E739='inside'">
						<xsl:attribute name="chart:axis-label-position">outside-maximum</xsl:attribute>
						<xsl:attribute name="chart:tick-mark-position">at-labels</xsl:attribute>
						<xsl:attribute name="chart:axis-position" select="0"/>
					</xsl:when>
					<xsl:when test="@刻度线标志_E739='outside'">
						<xsl:attribute name="chart:axis-label-position">outside-minimum</xsl:attribute>
						<xsl:attribute name="chart:tick-mark-position">at-labels</xsl:attribute>
					</xsl:when>
					<xsl:when test="@刻度线标志_E739='none'">
						<xsl:attribute name="chart:axis-label-position">outside-minimum</xsl:attribute>
						<xsl:attribute name="chart:tick-mark-position">at-labels</xsl:attribute>
						<xsl:attribute name="chart:display-label">false</xsl:attribute>
					</xsl:when>
					<xsl:when test="@刻度线标志_E739='next-axis'">
						<xsl:attribute name="chart:axis-position">0</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="chart:axis-label-position">next-axis</xsl:attribute>
						<xsl:attribute name="chart:tick-mark-position">at-labels</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<!-- Waiting, @ 主类型 次类型 可能在坐标轴内容 而非式样中 -->
				<xsl:for-each select="*">
					<xsl:choose>
						<xsl:when test="name(.)='表:数值_E70D'">
							<xsl:choose>
								<xsl:when test="@是否链接到源_E73E">
									<xsl:attribute name="chart:link-data-style-to-source" select="@是否链接到源_E73E"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="chart:link-data-style-to-source" select="false"/>
								</xsl:otherwise>
							</xsl:choose>
							<!-- Waiting, @格式码 -->
						</xsl:when>
						<xsl:when test="name(.)='图表:刻度_E71D'">
							<xsl:apply-templates select="." mode="chartstyle"/>
						</xsl:when>
						<xsl:when test="name(.)='图表:对齐_E730'">
							<!--xsl:if test="表:文字排列方向 = 'r2l-t2b-90e-90w'"-->
							<xsl:if test="图表:文字排列方向_E703 = 'r2l-t2b-90e-90w' or 图表:文字排列方向_E703 = 'r2l-t2b-0e-90w'">
								<!-- Waiting, some enumerations are not supported. -->
								<xsl:attribute name="style:direction">ttb</xsl:attribute>
							</xsl:if>
							<xsl:if test="图表:文字旋转角度_E704">
								<xsl:attribute name="style:rotation-angle"><xsl:value-of select="图表:文字旋转角度_E704"/></xsl:attribute>
							</xsl:if>
							<!-- Waiting, Offset -->
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</style:chart-properties>
			<xsl:call-template name="GraphicEleAndTextPropEle"/>
		</style:style>
		<xsl:apply-templates select="图表:网格线集_E733" mode="chartstyle"/>
		<!-- Waiting ,UOF2.0图表下也有标题 与此处编号不一致，暂以此为准 -->
		<xsl:apply-templates select="图表:标题_E736" mode="chartstyle"/>
	</xsl:template>
	<xsl:template match="图表:绘图区_E747" mode="chartstyle">
		<style:style style:name="chart-wall" style:family="chart">
			<xsl:call-template name="GraphicEleAndTextPropEle"/>
		</style:style>
		<style:style style:name="plot-area" style:family="chart">
			<style:chart-properties>
				<xsl:for-each select="图表:图表类型组集_E74C/图表:组_E74D[1]/图表:数据系列集_E74E/图表:数据系列_E74F[1]">
					<xsl:variable name="table-type" select="@类型_E75D"/>
					<xsl:variable name="table-subtype" select="@子类型_E777"/>
					<xsl:choose>
						<xsl:when test="$table-subtype='stacked'">
							<xsl:attribute name="chart:stacked">true</xsl:attribute>
						</xsl:when>
						<xsl:when test="$table-subtype='percent-stacked'">
							<xsl:attribute name="chart:percentage">true</xsl:attribute>
						</xsl:when>
						<!--UOF2.0 101215版本无此枚举值，暂用stacked-marker代替
						<xsl:when test="($table-subtype='clustered' and $table-type != 'line') or $table-subtype='clustered-marker'"-->
						<xsl:when test="($table-subtype='clustered' and $table-type != 'line') or $table-subtype='stacked-marker'">
							<xsl:attribute name="chart:symbol-type">automatic</xsl:attribute>
						</xsl:when>
						<xsl:when test="contains($table-subtype[position() =1],'3d')">
							<xsl:attribute name="chart:three-dimensional">true</xsl:attribute>
							<xsl:attribute name="chart:soft-page-break">true</xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<xsl:attribute name="chart:vertical"><xsl:choose><xsl:when test="$table-type='bar'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:variable name="series-value-start">
						<xsl:value-of select="@值_E775"/>
					</xsl:variable>
					<xsl:variable name="series-value-end">
						<xsl:value-of select="../图表:数据系列_E74F[last()]/@值_E775"/>
					</xsl:variable>
					<!-- Waiting, 按行按列 即 表:数据源/@表:系列产生 -->
					<!--
					<xsl:variable name="series-generate-type">
						<xsl:choose>
							<xsl:when test="../表:数据源/@表:系列产生">
								<xsl:value-of select="表:数据源/@表:系列产生"/>
							</xsl:when>
							<xsl:when test="substring(substring-after($series-value-start,'!'),2,1)=substring(substring-after($series-value-start,':'),2,1)">row</xsl:when>
							<xsl:otherwise>col</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					-->
					<!--
					<xsl:attribute name="chart:series-source">
						<xsl:choose>
							<xsl:when test="$series-generate-type='row'">rows</xsl:when>
							<xsl:otherwise>columns</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					-->
					<xsl:for-each select="图表:数据标签_E752">
						<xsl:if test="@是否显示类别名_E716">
							<xsl:attribute name="chart:data-label-text" select="@是否显示类别名_E716"/>
						</xsl:if>
						<xsl:attribute name="chart:data-label-number"><xsl:choose><xsl:when test="@是否显示数值_E717='true'">value</xsl:when><xsl:when test="@是否百分数图表_E718='true'">percentage</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
						<xsl:if test="@是否显示图例标志_E719">
							<xsl:attribute name="chart:data-label-symbol"><xsl:value-of select="@是否显示图例标志_E719"/></xsl:attribute>
							<!--分隔符缺省值设为 0-->
							<xsl:if test="string(@分隔符_E71A)">
								<chart:label-separator>
									<xsl:choose>
										<xsl:when test="string(@分隔符_E71A) = '4'">
											<text:line-break/>
										</xsl:when>
										<xsl:otherwise>
											<text:p>
												<xsl:choose>
													<xsl:when test="string(@分隔符_E71A) = '1'">, </xsl:when>
													<xsl:when test="string(@分隔符_E71A) = '2'">; </xsl:when>
													<!-- Absent Function , '3' correnspond with '0' space>
													<xsl:when test="string(@分隔符_E71A) = '3'">. </xsl:when-->
												</xsl:choose>
											</text:p>
										</xsl:otherwise>
									</xsl:choose>
								</chart:label-separator>
							</xsl:if>
							<!-- Waiting, QiPaoChiCun_E71B -->
							<!-- Waiting, some new functions for uof2.0 -->
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</style:chart-properties>
		</style:style>
		<xsl:for-each select="图表:图表类型组集_E74C/图表:组_E74D[1]">
			<xsl:apply-templates select="图表:数据系列集_E74E" mode="chartstyle"/>
			<xsl:for-each select="图表:跌柱线_E77E|图表:涨柱线_E780">
				<xsl:call-template name="StockMarkerStyle"/>
			</xsl:for-each>
			<!-- Waiting, some new subelements for uof2.0 -->
		</xsl:for-each>
		<xsl:for-each select="图表:坐标轴集_E790">
			<xsl:apply-templates select="图表:坐标轴_E791" mode="chartstyle"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="图表:图例_E794" mode="chartstyle">
		<style:style style:name="legend" style:family="chart">
			<xsl:call-template name="GraphicEleAndTextPropEle"/>
		</style:style>
		<!-- Waiting, Size, TuLiXiang -->
	</xsl:template>
	<xsl:template match="图表:数据表_E79B" mode="chartstyle">
		<style:style style:name="data-table" style:family="chart">
			<!--边框 编号及标签名 均不一致-->
			<xsl:call-template name="GraphicEleAndTextPropEle"/>
		</style:style>
		<!-- Waiting, Attributes -->
	</xsl:template>
	<xsl:template match="图表:背景墙_E7A1" mode="chartstyle">
		<style:style style:name="chart-wall" style:family="chart">
			<xsl:call-template name="GraphicEleAndTextPropEle"/>
		</style:style>
	</xsl:template>
	<xsl:template match="图表:基底_E7A4" mode="chartstyle">
		<style:style style:name="chart-floor" style:family="chart">
			<xsl:call-template name="GraphicEleAndTextPropEle"/>
		</style:style>
	</xsl:template>
	<xsl:template name="getChartLineSymbol">
		<xsl:param name="par_Index"/>
		<xsl:variable name="var_SymbolArray">
			<symbolName>square</symbolName>
			<symbolName>diamond</symbolName>
			<symbolName>arrow-down</symbolName>
			<symbolName>arrow-up</symbolName>
			<symbolName>arrow-right</symbolName>
			<symbolName>arrow-left</symbolName>
			<symbolName>bow-tie</symbolName>
			<symbolName>hourglass</symbolName>
		</xsl:variable>
		<xsl:variable name="varIndex">
			<xsl:choose>
				<xsl:when test="$par_Index mod 8 = 0">
					<xsl:value-of select="number('8')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$par_Index mod 8"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$var_SymbolArray/symbolName[position() = number($varIndex)]"/>
	</xsl:template>
	<xsl:template name="getDefaultColor">
		<xsl:param name="par_Index"/>
		<xsl:variable name="var_ColorArray">
			<color>#004586</color>
			<color>#ff420e</color>
			<color>#ffd320</color>
			<color>#579d1c</color>
			<color>#7e0021</color>
			<color>#83caff</color>
			<color>#314004</color>
			<color>#aecf00</color>
			<color>#4b1f6f</color>
			<color>#ff950e</color>
			<color>#c5000b</color>
			<color>#0084d1</color>
		</xsl:variable>
		<xsl:variable name="varIndex">
			<xsl:choose>
				<xsl:when test="$par_Index mod 12 = 0">
					<xsl:value-of select="number('12')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$par_Index mod 12"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$var_ColorArray/color[position() = number($varIndex)]"/>
	</xsl:template>
	<xsl:template name="图表:固定式样式样集">
		<office:styles>
			<draw:stroke-dash draw:name="Ultrafine_20_Dashed" draw:display-name="Ultrafine Dashed" draw:style="rect" draw:dots1="1" draw:dots1-length="0.051cm" draw:dots2="1" draw:dots2-length="0.051cm" draw:distance="0.051cm"/>
			<draw:stroke-dash draw:name="dash" draw:style="rect" draw:dots1="1" draw:dots1-length="0.2cm" draw:dots2="1" draw:dots2-length="0.2cm" draw:distance="0.15cm"/>
			<draw:stroke-dash draw:name="dash-dot" draw:style="rect" draw:dots1="1" draw:dots1-length="0.2cm" draw:dots2="1" draw:distance="0.1cm"/>
			<draw:stroke-dash draw:name="dot-dash" draw:style="rect" draw:dots1="1" draw:dots1-length="0.21cm" draw:dots2="1" draw:distance="0.1cm"/>
			<draw:stroke-dash draw:name="dash-dot-dot" draw:style="rect" draw:dots1="1" draw:dots1-length="0.15cm" draw:dots2="2" draw:distance="0.07cm"/>
			<draw:stroke-dash draw:name="dot-dot-dash" draw:style="rect" draw:dots1="1" draw:dots1-length="0.16cm" draw:dots2="2" draw:distance="0.07cm"/>
			<draw:stroke-dash draw:name="dash-long" draw:style="rect" draw:dots1="1" draw:dots1-length="0.4cm" draw:dots2="1" draw:dots2-length="0.4cm" draw:distance="0.25cm"/>
			<draw:stroke-dash draw:name="round-dot" draw:display-name="round-dot" draw:style="round" draw:dots1="1" draw:dots1-length="0.025cm" draw:distance="0.025cm"/>
			<draw:stroke-dash draw:name="square-dot" draw:display-name="square-dot" draw:style="rect" draw:dots1="1" draw:dots1-length="0.026cm" draw:distance="0.026cm"/>
			<draw:stroke-dash draw:name="long-dash-dot" draw:display-name="long-dash-dot" draw:style="rect" draw:dots1="1" draw:dots1-length="0.026cm" draw:dots2="1" draw:dots2-length="0.211cm" draw:distance="0.079cm"/>
			<draw:stroke-dash draw:name="long-dash" draw:display-name="long-dash" draw:style="rect" draw:dots2="1" draw:dots2-length="0.211cm" draw:distance="0.079cm"/>
			<xsl:call-template name="GraphicSetStyle"/>
			<xsl:call-template name="HatchSetStyle"/>
			<xsl:for-each select=".//图:渐变_800D/..">
				<xsl:call-template name="GradientStyle"/>
			</xsl:for-each>
		</office:styles>
	</xsl:template>
	<xsl:template name="OfficeAutomaticStyles4chart">
		<office:automatic-styles>
			<!--number:number-style-->
			<!-- no sure, these digit format is necessary. -->
			<xsl:if test="图表:数值轴/图表:数值/@图表:分类名称='text'">
				<number:text-style style:name="axisYstyle" number:language="zh" number:country="CN">
					<number:text-content/>
				</number:text-style>
			</xsl:if>
			<xsl:if test="图表:数值轴/图表:数值/@图表:分类名称='general'">
				<number:number-style style:name="axisYstyle">
					<number:number number:min-integer-digits="1"/>
				</number:number-style>
			</xsl:if>
			<xsl:for-each select="图表:数值轴/图表:数值[@图表:分类名称]">
				<xsl:call-template name="NumberStyle">
					<xsl:with-param name="style-id" select="generate-id(.)"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="*">
				<xsl:apply-templates select="." mode="chartstyle"/>
				<!--表:图表区_E743|表:绘图区_E747|表:图例_E794|表:数据表_E79B|表:标题_E70A|表:背景墙_E7A1|表:基底_E7A4  
待转 空白单元格绘制方式 是否显示隐藏单元格-->
			</xsl:for-each>
		</office:automatic-styles>
	</xsl:template>
	<xsl:template name="transform-data-area">
		<xsl:param name="data-area"/>
		<xsl:variable name="apos">&apos;</xsl:variable>
		<!--xsl:variable name="MidData1" select="translate($data-area, ',', ' ')"/>
		<xsl:variable name="MidData2" select="translate($MidData1, '!', '.')"/>
		<xsl:variable name="MidData3" select="translate($MidData2, $apos, '')"/>
		<xsl:variable name="MidData4" select="translate($MidData3, '=', '')"/>
		<xsl:variable name="TableName" select="substring-before($MidData4,'.')"/>
		<xsl:variable name="MidData5" select="concat(substring-before($MidData4,':'), ':', $TableName, '.', substring-after($MidData4,':'))"/>
		<xsl:value-of select="$MidData5"/-->
		<xsl:analyze-string select="substring-after($data-area,'=')" regex="{','}">
			<xsl:non-matching-substring>
				<xsl:variable name="tablename" select="substring-before(substring-after(.,$apos),$apos)"/>
				<xsl:analyze-string select="." regex="{':'}">
					<xsl:non-matching-substring>
						<xsl:choose>
							<xsl:when test="contains(.,$tablename)">
								<xsl:value-of select="translate(translate(.,$apos,''),'!','.')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($tablename,'.',.)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:non-matching-substring>
					<xsl:matching-substring>
						<xsl:value-of select="."/>
					</xsl:matching-substring>
				</xsl:analyze-string>
			</xsl:non-matching-substring>
			<xsl:matching-substring>
				<xsl:value-of select="' '"/>
			</xsl:matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	<xsl:template name="CalCellRange">
		<xsl:for-each select="图表:图表类型组集_E74C/图表:组_E74D/图表:数据系列集_E74E">
			<xsl:for-each select="图表:数据系列_E74F">
				<xsl:variable name="odf-area">
					<xsl:call-template name="transform-data-area">
						<xsl:with-param name="data-area" select="@值_E775"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$odf-area"/>
				<xsl:value-of select="' '"/>
				<xsl:if test="@名称_E774 and contains(@名称_E774, '!') and contains(@名称_E774, ':')">
					<xsl:variable name="odf-legend">
						<xsl:call-template name="transform-data-area">
							<xsl:with-param name="data-area" select="@名称_E774"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$odf-legend"/>
					<xsl:value-of select="' '"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="contains(图表:数据系列_E74F[1]/@分类名_E776, '!') and contains(图表:数据系列_E74F[1]/@分类名_E776, ':')">
				<xsl:variable name="odf-cata">
					<xsl:call-template name="transform-data-area">
						<xsl:with-param name="data-area" select="图表:数据系列_E74F[1]/@分类名_E776"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$odf-cata"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="图表:标题_E736" mode="chartbody">
		<xsl:param name="ChartSize"/>
		<xsl:variable name="plotAreaX">
			<xsl:for-each select="../..">
				<xsl:call-template name="PlotAreaSize">
					<xsl:with-param name="param" select="'x'"/>
					<xsl:with-param name="ChartSize" select="$ChartSize"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="plotAreaWidth">
			<xsl:for-each select="../..">
				<xsl:call-template name="PlotAreaSize">
					<xsl:with-param name="param" select="'width'"/>
					<xsl:with-param name="ChartSize" select="$ChartSize"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="plotAreaY">
			<xsl:for-each select="../..">
				<xsl:call-template name="PlotAreaSize">
					<xsl:with-param name="param" select="'y'"/>
					<xsl:with-param name="ChartSize" select="$ChartSize"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="plotAreaHeight">
			<xsl:for-each select="../..">
				<xsl:call-template name="PlotAreaSize">
					<xsl:with-param name="param" select="'height'"/>
					<xsl:with-param name="ChartSize" select="$ChartSize"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<chart:title>
			<xsl:attribute name="chart:style-name" select="generate-id(.)"/>
			<xsl:for-each select="图表:位置_E70A">
				<xsl:variable name="svgX">
					<xsl:choose>
						<xsl:when test="@x_C606">
							<xsl:value-of select="concat(@x_C606,$uofUnit)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(number($plotAreaX) + number($plotAreaWidth) div 2.3,$uofUnit)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="svgY">
					<xsl:choose>
						<xsl:when test="@y_C607">
							<xsl:value-of select="concat(@y_C607,$uofUnit)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(number($ChartSize/@长_C604) * 0.02,$uofUnit)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="svg:x"><xsl:value-of select="$svgX"/></xsl:attribute>
				<xsl:attribute name="svg:y"><xsl:value-of select="$svgY"/></xsl:attribute>
			</xsl:for-each>
			<text:p>
				<xsl:value-of select="@名称_E742"/>
			</text:p>
		</chart:title>
	</xsl:template>
	<xsl:template match="图表:图例_E794" mode="chartbody">
		<xsl:param name="ChartSize"/>
		<xsl:variable name="plotAreaX">
			<xsl:call-template name="PlotAreaSize">
				<xsl:with-param name="param" select="'x'"/>
				<xsl:with-param name="ChartSize" select="$ChartSize"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="plotAreaWidth">
			<xsl:call-template name="PlotAreaSize">
				<xsl:with-param name="param" select="'width'"/>
				<xsl:with-param name="ChartSize" select="$ChartSize"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="plotAreaY">
			<xsl:call-template name="PlotAreaSize">
				<xsl:with-param name="param" select="'y'"/>
				<xsl:with-param name="ChartSize" select="$ChartSize"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="plotAreaHeight">
			<xsl:call-template name="PlotAreaSize">
				<xsl:with-param name="param" select="'height'"/>
				<xsl:with-param name="ChartSize" select="$ChartSize"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="paddingX" select="number($ChartSize/@宽_C605) * 0.16"/>
		<xsl:variable name="paddingY" select="number($ChartSize/@长_C604) * 0.16"/>
		<chart:legend chart:style-name="legend">
			<xsl:variable name="legend-position">
				<xsl:choose>
					<xsl:when test="图表:图例位置_E795='right'">end</xsl:when>
					<xsl:when test="图表:图例位置_E795='bottom'">bottom</xsl:when>
					<xsl:when test="图表:图例位置_E795='top'">top</xsl:when>
					<xsl:when test="图表:图例位置_E795='left'">start</xsl:when>
					<xsl:when test="图表:图例位置_E795='corner'">top-end</xsl:when>
					<xsl:otherwise>end</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="chart:legend-position"><xsl:value-of select="$legend-position"/></xsl:attribute>
			<xsl:variable name="xPos">
				<xsl:choose>
					<xsl:when test="图表:位置_E70A/@x_C606">
						<xsl:value-of select="图表:位置_E70A/@x_C606"/>
					</xsl:when>
					<xsl:otherwise>
						<!--xsl:if test="../@表:宽度"-->
						<xsl:if test="$ChartSize/@宽_C605">
							<xsl:choose>
								<xsl:when test="contains($legend-position, 'end')">
									<xsl:value-of select="number($plotAreaX) + number($plotAreaWidth) + number($paddingX)"/>
								</xsl:when>
								<xsl:when test="$legend-position = 'start'">
									<xsl:value-of select="number($ChartSize/@宽_C605) * 0.0199"/>
								</xsl:when>
								<xsl:when test="$legend-position = 'top'">
									<xsl:value-of select="number($plotAreaX) + number($plotAreaWidth) div 2.3"/>
								</xsl:when>
								<xsl:when test="$legend-position = 'bottom'">
									<xsl:value-of select="number($plotAreaX) + number($plotAreaWidth) div 2.3"/>
								</xsl:when>
								<xsl:when test="$legend-position = 'corner'">
									<xsl:value-of select="number($plotAreaX) + number($plotAreaWidth) + number($paddingX)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="这是一个不应出现的值"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="yPos">
				<xsl:choose>
					<xsl:when test="图表:位置_E70A/@y_C607">
						<xsl:value-of select="图表:位置_E70A/@y_C607"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- Waiting. -->
						<xsl:choose>
							<xsl:when test="$legend-position = 'end'">
								<xsl:value-of select="number($ChartSize/@长_C604) * 0.364"/>
							</xsl:when>
							<xsl:when test="$legend-position = 'start'">
								<xsl:value-of select="number($ChartSize/@长_C604) * 0.364"/>
							</xsl:when>
							<xsl:when test="contains($legend-position, 'top')">
								<xsl:value-of select="number($plotAreaY) - number($plotAreaHeight) * 0.2"/>
							</xsl:when>
							<xsl:when test="$legend-position = 'bottom'">
								<xsl:value-of select="number($plotAreaY) + number($plotAreaHeight) + number($paddingY)"/>
							</xsl:when>
							<xsl:when test="$legend-position = 'corner'">
								<xsl:value-of select="number($ChartSize/@长_C604) * 0.25"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="这是一个不应该出现的值"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="string($xPos) != '' and string($xPos) != 'NaN'">
				<xsl:attribute name="svg:x"><xsl:value-of select="concat($xPos, $uofUnit)"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="string($yPos) != '' and string($xPos) != 'NaN'">
				<xsl:attribute name="svg:y"><xsl:value-of select="concat($yPos, $uofUnit)"/></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="chart:style-name">legend</xsl:attribute>
		</chart:legend>
	</xsl:template>
	<xsl:template match="图表:坐标轴_E791" mode="chartbody">
		<chart:axis>
			<xsl:attribute name="chart:style-name" select="generate-id(.)"/>
			<xsl:attribute name="chart:name" select="concat(generate-id(.),'-a')"/>
			<xsl:choose>
				<xsl:when test="@子类型_E793='date' or @子类型_E793='category'">
					<xsl:attribute name="chart:dimension" select="'x'"/>
					<xsl:for-each select="../../图表:图表类型组集_E74C/图表:组_E74D/图表:数据系列集_E74E/图表:数据系列_E74F[1]">
						<xsl:variable name="categories_value" select="string(@分类名_E776)"/>
						<xsl:variable name="cellrangeTem">
							<xsl:choose>
								<xsl:when test="contains($categories_value, ':')">
									<xsl:call-template name="transform-data-area">
										<xsl:with-param name="data-area" select="$categories_value"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$categories_value"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="cellrange">
							<xsl:choose>
								<xsl:when test="ends-with($cellrangeTem,' ')">
									<xsl:value-of select="substring($cellrangeTem,1,string-length($cellrangeTem)-1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$cellrangeTem"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="$cellrange!=''">
							<chart:categories>
								<xsl:attribute name="table:cell-range-address"><xsl:value-of select="$cellrange"/></xsl:attribute>
							</chart:categories>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="@子类型_E793='value' or @主类型_E792 = 'secondary'">
					<xsl:attribute name="chart:dimension" select="'y'"/>
				</xsl:when>
				<xsl:when test="@子类型_E793='series'">
					<xsl:attribute name="chart:dimension" select="'z'"/>
				</xsl:when>
			</xsl:choose>
			<xsl:for-each select="图表:网格线集_E733/图表:网格线_E734">
				<chart:grid>
					<xsl:attribute name="chart:class" select="@位置_E735"/>
					<xsl:attribute name="chart:style-name" select="generate-id(.)"/>
				</chart:grid>
			</xsl:for-each>
			<xsl:variable name="ChartName" select="../../../@标识符_E828"/>
			<!--anchor for chart-->
			<xsl:variable name="AnchorChart" select="key('rel_graphic_name',key('graph4chart',$ChartName)/@标识符_804B)"/>
			<xsl:apply-templates mode="chartbody" select="图表:标题_E736">
				<xsl:with-param name="ChartSize" select="$AnchorChart/uof:大小_C621"/>
			</xsl:apply-templates>
		</chart:axis>
	</xsl:template>
	<xsl:template match="图表:数据系列集_E74E" mode="chartbody">
		<xsl:for-each select="图表:数据系列_E74F">
			<chart:series>
				<xsl:attribute name="chart:style-name"><xsl:value-of select="concat('DataSerial',position())"/></xsl:attribute>
				<xsl:variable name="attached-axis">
					<xsl:choose>
						<xsl:when test="@系列坐标系_E779">
							<xsl:value-of select="generate-id(ancestor::图表:绘图区_E747/图表:坐标轴集_E790/图表:坐标轴_E791[@子类型_E793='value' and @主类型_E792=current()/@系列坐标系_E779])"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="generate-id(ancestor::图表:绘图区_E747/图表:坐标轴集_E790/图表:坐标轴_E791[@子类型_E793='value' and @主类型_E792='primary'])"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="chart:attached-axis" select="concat($attached-axis,'-a')"/>
				<xsl:variable name="value_address">
					<xsl:call-template name="transform-data-area">
						<xsl:with-param name="data-area" select="@值_E775"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:attribute name="chart:values-cell-range-address"><xsl:value-of select="$value_address"/></xsl:attribute>
				<xsl:if test="@名称_E774 and contains(@名称_E774, ':')">
					<xsl:variable name="label_address">
						<xsl:call-template name="transform-data-area">
							<xsl:with-param name="data-area" select="@名称_E774"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:attribute name="chart:label-cell-address"><xsl:value-of select="$label_address"/></xsl:attribute>
				</xsl:if>
				<xsl:variable name="series-class">
					<xsl:choose>
						<xsl:when test="@类型_E75D = 'bar'">chart:bar</xsl:when>
						<xsl:when test="@类型_E75D = 'column'">chart:bar</xsl:when>
						<xsl:when test="@类型_E75D = 'line'">chart:line</xsl:when>
						<xsl:when test="@类型_E75D = 'pie'">chart:circle</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="chart:class"><xsl:value-of select="$series-class"/></xsl:attribute>
				<xsl:for-each select="图表:数据点集_E755/图表:数据点_E756">
					<xsl:variable name="precedingPoint">
						<xsl:choose>
							<xsl:when test="position() = 1">0</xsl:when>
							<xsl:when test="preceding-sibling::*[1]">
								<xsl:value-of select="preceding-sibling::*[1]/@点_E757"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="currentPoint" select="@点_E757"/>
					<xsl:element name="chart:data-point">
						<xsl:attribute name="chart:style-name"><xsl:value-of select="generate-id()"/></xsl:attribute>
						<xsl:if test="number($currentPoint) != number($precedingPoint) + 1">
							<xsl:attribute name="chart:repeated"><xsl:value-of select="number($currentPoint) - number($precedingPoint)"/></xsl:attribute>
						</xsl:if>
					</xsl:element>
					<!-- no supported function in ODF : YinDaoXian -->
				</xsl:for-each>
				<!-- no supported function in ODF : one series with only one error bars -->
				<xsl:for-each select="图表:误差线集_E759/图表:误差线_E75A">
					<chart:error-indicator>
						<xsl:attribute name="chart:style-name" select="generate-id(.)"/>
					</chart:error-indicator>
				</xsl:for-each>
				<!-- no supported function in ODF : one series with only one trendline -->
				<xsl:for-each select="图表:趋势线集_E762/图表:趋势线_E763[1]">
					<chart:regression-curve>
						<xsl:attribute name="chart:style-name" select="generate-id(.)"/>
						<chart:equation>
							<xsl:if test="@是否显示R平方值_E771='false' or @是否显示R平方值_E771='0'">
								<xsl:attribute name="chart:display-r-square" select="'false'"/>
							</xsl:if>
							<xsl:if test="@是否显示公式_E770='false' or @是否显示公式_E770='0'">
								<xsl:attribute name="chart:display-equation" select="'false'"/>
							</xsl:if>
						</chart:equation>
					</chart:regression-curve>
					<!-- no supported function in ODF : @ 值 名称 截距 前推预测周期 倒退预测周期；图例项 -->
				</xsl:for-each>
			</chart:series>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="PlotArea4chart">
		<xsl:param name="ChartSize"/>
		<chart:plot-area chart:style-name="plot-area">
			<xsl:for-each select="图表:绘图区_E747">
				<xsl:variable name="cellrangeTem">
					<xsl:choose>
						<xsl:when test="图表:数据区域_E74B">
							<xsl:call-template name="transform-data-area">
								<xsl:with-param name="data-area" select="图表:数据区域_E74B"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="CalCellRange"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="cellrange">
					<xsl:choose>
						<xsl:when test="ends-with($cellrangeTem,' ')">
							<xsl:value-of select="substring($cellrangeTem,1,string-length($cellrangeTem)-1)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$cellrangeTem"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="table:cell-range-address"><xsl:value-of select="$cellrange"/></xsl:attribute>
				<!--<xsl:variable name="svgWidth">
					<xsl:choose>
						<xsl:when test="表:大小_E748/@宽_C605">
							<xsl:value-of select="concat(表:大小_E748/@宽_C605,$uofUnit)"/>
						</xsl:when>
						<xsl:when test="../../表:图例_E794/表:大小_E748/@宽_C605 and (number($ChartSize/@长_C604) *0.8 &gt; number(../../表:图例_E794/表:位置_E70A/@x_C606))">
							<xsl:value-of select="concat((number($ChartSize/@长_C604) - number(../../表:图例_E794/表:大小_E748/@宽_C605)) * 0.8,$uofUnit)"/>
						</xsl:when>
						<xsl:otherwise>
							
							<xsl:value-of select="concat(number($ChartSize/@长_C604)*0.8,$uofUnit)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="svgHeight">
					<xsl:choose>
						<xsl:when test="表:大小_E748/@长_C604">
							<xsl:value-of select="concat(表:大小_E748/@长_C604,$uofUnit)"/>
						</xsl:when>
						<xsl:otherwise>
							
							<xsl:value-of select="concat(number($ChartSize/@宽_C605)*0.7,$uofUnit)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="svgX">
					<xsl:choose>
						<xsl:when test="表:位置_E70A/@x_C606">
							<xsl:value-of select="concat(表:位置_E70A/@x_C606,$uofUnit)"/>
						</xsl:when>
						<xsl:when test="../表:图例_E794/表:图例位置_E795 = 'left'">2.067cm</xsl:when>
						<xsl:when test="表:坐标轴集_E790/表:坐标轴_E791[@主类型_E792 = 'secondary']/表:标题_E736">
							<xsl:value-of select="concat(number(表:大小_E748/@长_C604)*0.1,$uofUnit)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(number(表:大小_E748/@长_C604)*0.06,$uofUnit)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="svgY">
					<xsl:choose>
						<xsl:when test="表:位置_E70A/@y_C607">
							<xsl:value-of select="concat(表:位置_E70A/@y_C607,$uofUnit)"/>
						</xsl:when>
						<xsl:when test="../表:图例_E794/表:图例位置_E795 = 'bottom'">0.1cm</xsl:when>
						<xsl:when test="表:坐标轴集_E790/表:坐标轴_E791/表:标题_E736">
							<xsl:value-of select="concat(number(表:大小_E748/@宽_C605)*0.1,$uofUnit)"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>-->
				<xsl:variable name="svgWidth">
					<xsl:call-template name="PlotAreaSize">
						<xsl:with-param name="param" select="'width'"/>
						<xsl:with-param name="ChartSize" select="$ChartSize"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="svgHeight">
					<xsl:call-template name="PlotAreaSize">
						<xsl:with-param name="param" select="'height'"/>
						<xsl:with-param name="ChartSize" select="$ChartSize"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="svgX">
					<xsl:call-template name="PlotAreaSize">
						<xsl:with-param name="param" select="'x'"/>
						<xsl:with-param name="ChartSize" select="$ChartSize"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="svgY">
					<xsl:call-template name="PlotAreaSize">
						<xsl:with-param name="param" select="'y'"/>
						<xsl:with-param name="ChartSize" select="$ChartSize"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:attribute name="svg:width"><xsl:value-of select="concat($svgWidth,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:height"><xsl:value-of select="concat($svgHeight,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:x"><xsl:value-of select="concat($svgX,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:y"><xsl:value-of select="concat($svgY,$uofUnit)"/></xsl:attribute>
				<xsl:for-each select="图表:坐标轴集_E790">
					<!-- 按轴定义的先后次序判断主次 -->
					<xsl:apply-templates select="图表:坐标轴_E791[@主类型_E792='primary']" mode="chartbody"/>
					<xsl:apply-templates select="图表:坐标轴_E791[not(@主类型_E792='primary')]" mode="chartbody"/>
				</xsl:for-each>
				<xsl:for-each select="图表:图表类型组集_E74C/图表:组_E74D">
					<xsl:apply-templates select="图表:数据系列集_E74E" mode="chartbody"/>
					<xsl:for-each select="图表:跌柱线_E77E">
						<chart:stock-loss-marker>
							<xsl:attribute name="chart:style-name" select="generate-id(.)"/>
						</chart:stock-loss-marker>
					</xsl:for-each>
					<xsl:for-each select="图表:涨柱线_E780">
						<chart:stock-gain-marker>
							<xsl:attribute name="chart:style-name" select="generate-id(.)"/>
						</chart:stock-gain-marker>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>
			<chart:wall>
				<xsl:attribute name="chart:style-name">chart-wall</xsl:attribute>
			</chart:wall>
			<chart:floor>
				<xsl:attribute name="chart:style-name">chart-floor</xsl:attribute>
			</chart:floor>
		</chart:plot-area>
	</xsl:template>
	<xsl:template name="PlotAreaSize">
		<xsl:param name="param"/>
		<xsl:param name="ChartSize"/>
		<xsl:variable name="PaddingX" select="number($ChartSize/@宽_C605) * number(0.04)"/>
		<xsl:variable name="PaddingY" select="number($ChartSize/@长_C604) * number(0.019)"/>
		<xsl:for-each select="..">
			<xsl:variable name="legendPosX">
				<xsl:choose>
					<xsl:when test="图表:图例_E794/图表:位置_E70A/@x_C606">
						<xsl:choose>
							<xsl:when test="number(图表:图例_E794/图表:位置_E70A/@x_C606) &lt; number($ChartSize/@宽_C605) div 3">
								<xsl:choose>
									<xsl:when test="图表:图例_E794/图表:大小_E748/@宽_C605">
										<xsl:value-of select="number(图表:图例_E794/图表:位置_E70A/@x_C606) + number(图表:图例_E794/图表:大小_E748/@宽_C605) + $PaddingX"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="number(图表:图例_E794/图表:位置_E70A/@x_C606) + number($ChartSize/@宽_C605) * 0.12 + $PaddingX"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="图表:图例_E794/图表:图例位置_E795 = 'left'">
						<xsl:choose>
							<xsl:when test="图表:图例_E794/图表:大小_E748/@宽_C605">
								<xsl:value-of select="$PaddingX + number(图表:图例_E794/图表:大小_E748/@宽_C605) + number($ChartSize/@宽_C605) * 0.02"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$PaddingX + number($ChartSize/@宽_C605) * 0.12 + number($ChartSize/@宽_C605) * 0.02"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="legendPosY">
				<xsl:choose>
					<xsl:when test="图表:图例_E794/图表:位置_E70A/@y_C607">
						<xsl:choose>
							<xsl:when test="number(图表:图例_E794/图表:位置_E70A/@y_C607) &lt; number($ChartSize/@长_C604) div 3">
								<xsl:choose>
									<xsl:when test="图表:图例_E794/图表:大小_E748/@长_C604">
										<xsl:value-of select="number(图表:图例_E794/图表:位置_E70A/@y_C607) + number(图表:图例_E794/图表:大小_E748/@长_C604) + $PaddingY"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="number(图表:图例_E794/图表:位置_E70A/@y_C607) + number($ChartSize/@长_C604) div 3 + $PaddingY"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="图表:图例_E794/图表:图例位置_E795 = 'top'">
						<xsl:choose>
							<xsl:when test="图表:图例_E794/图表:大小_E748/@长_C604">
								<xsl:value-of select="$PaddingY + number(图表:图例_E794/图表:大小_E748/@长_C604) + number($ChartSize/@长_C604) * 0.02"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$PaddingY + number($ChartSize/@长_C604) * 0.12 + number($ChartSize/@长_C604) * 0.02"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="legendWidth">
				<xsl:choose>
					<xsl:when test="图表:图例_E794/图表:位置_E70A/@x_C606">
						<xsl:choose>
							<xsl:when test="(number(图表:图例_E794/图表:位置_E70A/@x_C606) &lt; number($ChartSize/@宽_C605) div 3) or (number(图表:图例_E794/图表:位置_E70A/@x_C606) &gt; number($ChartSize/@宽_C605) *2 div 3)">
								<xsl:choose>
									<xsl:when test="图表:图例_E794/图表:大小_E748/@宽_C605">
										<xsl:value-of select="number(图表:图例_E794/图表:大小_E748/@宽_C605)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="number($ChartSize/@宽_C605) * 0.12"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="图表:图例_E794/图表:图例位置_E795 = 'left' or 图表:图例_E794/图表:图例位置_E795 = 'right'">
						<xsl:choose>
							<xsl:when test="图表:图例_E794/图表:大小_E748/@宽_C605">
								<xsl:value-of select="number(图表:图例_E794/图表:大小_E748/@宽_C605)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number($ChartSize/@宽_C605) * 0.12"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="legendHeight">
				<xsl:choose>
					<xsl:when test="图表:图例_E794/图表:位置_E70A/@y_C607">
						<xsl:choose>
							<xsl:when test="(number(图表:图例_E794/图表:位置_E70A/@y_C607) &lt; number($ChartSize/@长_C604) div 3) or (number(图表:图例_E794/图表:位置_E70A/@y_C607) &gt; number($ChartSize/@长_C604) *2 div 3)">
								<xsl:choose>
									<xsl:when test="图表:图例_E794/图表:大小_E748/@长_C604">
										<xsl:value-of select="number(图表:图例_E794/图表:大小_E748/@长_C604)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="number($ChartSize/@长_C604) div 3"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="图表:图例_E794/图表:图例位置_E795 = 'top' or 图表:图例_E794/图表:图例位置_E795 = 'bottom'">
						<xsl:choose>
							<xsl:when test="图表:图例_E794/图表:大小_E748/@长_C604">
								<xsl:value-of select="number(图表:图例_E794/图表:大小_E748/@长_C604)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number($ChartSize/@长_C604) div 3"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="titlePosX">
				<xsl:choose>
					<xsl:when test="图表:绘图区_E747/图表:坐标轴集_E790/图表:坐标轴_E791[@子类型_E793 = 'value']/图表:标题_E736/图表:位置_E70A">
						<xsl:choose>
							<xsl:when test="图表:绘图区_E747/图表:坐标轴集_E790/图表:坐标轴_E791[@子类型_E793 = 'value']/图表:标题_E736/图表:位置_E70A/@x_C606">
								<xsl:value-of select="图表:绘图区_E747/图表:坐标轴集_E790/图表:坐标轴_E791[@子类型_E793 = 'value']/图表:标题_E736/图表:位置_E70A/@x_C606"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number($ChartSize/@宽_C605)*0.07 + number($ChartSize/@宽_C605) * 0.02 + number($ChartSize/@宽_C605) * 0.02"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="titlePosY">
				<xsl:choose>
					<xsl:when test="图表:标题_E736/图表:位置_E70A">
						<xsl:choose>
							<xsl:when test="图表:标题_E736/图表:位置_E70A/@y_C607">
								<xsl:value-of select="图表:标题_E736/图表:位置_E70A/@y_C607"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number($ChartSize/@长_C604) * 0.07 + number($ChartSize/@长_C604) * 0.02 + number($ChartSize/@长_C604) * 0.02"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="titleWidth">
				<xsl:choose>
					<xsl:when test="图表:绘图区_E747/图表:坐标轴集_E790/图表:坐标轴_E791[@子类型_E793 = 'category']/图表:标题_E736/图表:位置_E70A/@x_C606">
						<xsl:value-of select="number($ChartSize/@长_C604) * 0.0689"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="categoryTitleHeight">
				<xsl:choose>
					<xsl:when test="图表:绘图区_E747/图表:坐标轴集_E790/图表:坐标轴_E791[@子类型_E793 = 'category']/图表:标题_E736/图表:位置_E70A/@y_C607">
						<xsl:value-of select="number($ChartSize/@长_C604) * 0.0689"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="titleHeight">
				<xsl:choose>
					<xsl:when test="图表:标题_E736/图表:位置_E70A/@y_C607">
						<xsl:value-of select="number($ChartSize/@长_C604) *0.0689"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$param = 'width'">
					<xsl:choose>
						<xsl:when test="图表:绘图区_E747/图表:大小_E748/@宽_C605">
							<xsl:value-of select="图表:绘图区_E747/图表:大小_E748/@宽_C605"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="(($ChartSize/@宽_C605) - number($legendWidth) - number($titleWidth)) *0.9"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$param = 'height'">
					<xsl:choose>
						<xsl:when test="图表:绘图区_E747/图表:大小_E748/@长_C604">
							<xsl:value-of select="图表:绘图区_E747/图表:大小_E748/@长_C604"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="(number($ChartSize/@长_C604) - number($legendHeight) - number($titleHeight) - number($titleHeight)) *0.9"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$param = 'x'">
					<xsl:choose>
						<xsl:when test="图表:绘图区_E747/图表:位置_E70A/@x_C606">
							<xsl:value-of select="图表:绘图区_E747/图表:位置_E70A/@x_C606"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="number($legendPosX) + number($titlePosX) + ($ChartSize/@宽_C605) * 0.05"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$param = 'y'">
					<xsl:choose>
						<xsl:when test="图表:绘图区_E747/图表:位置_E70A/@y_C607">
							<xsl:value-of select="图表:绘图区_E747/图表:位置_E70A/@y_C607"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="number($legendPosY) + number($titlePosY) + ($ChartSize/@长_C604) * 0.1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="CreateTmpLocTable">
		<table:table-header-rows>
			<table:table-row>
				<xsl:if test="图表:绘图区_E747/图表:图表类型组集_E74C/图表:组_E74D/图表:数据系列集_E74E/图表:数据系列_E74F[@分类名_E776][1]/图表:数据标签_E752/@是否显示分类名_E716 = 'true'">
					<xsl:for-each select="图表:绘图区_E747/图表:图表类型组集_E74C/图表:组_E74D/图表:数据系列集_E74E/图表:数据系列_E74F[@分类名_E776][1]">
						<xsl:variable name="IsRightCatalog">
							<xsl:choose>
								<xsl:when test="@分类名_E776 and contains(@分类名_E776, '!') and contains(@分类名_E776, '=')">
									<xsl:value-of select="'true'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'false'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="CatalogValue">
							<xsl:choose>
								<xsl:when test="$IsRightCatalog = 'true'">
									<xsl:call-template name="All-Header-Cell">
										<xsl:with-param name="HeaderAddress" select="@分类名_E776"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@分类名_E776"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:call-template name="Set-Catalog-Cell">
							<xsl:with-param name="SeriesPos" select="position()"/>
							<xsl:with-param name="CatalogValue" select="$CatalogValue"/>
							<xsl:with-param name="IsRightCatalog" select="$IsRightCatalog"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
			</table:table-row>
		</table:table-header-rows>
		<table:table-rows>
			<xsl:for-each select="图表:绘图区_E747/图表:图表类型组集_E74C/图表:组_E74D/图表:数据系列集_E74E/图表:数据系列_E74F">
				<xsl:variable name="data-area" select="@值_E775"/>
				<xsl:variable name="sAddress">
					<xsl:choose>
						<xsl:when test="contains($data-area, ':')">
							<xsl:value-of select="substring-after(substring-before($data-area, ':'), '!')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-after($data-area, '!')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="eAddress">
					<xsl:choose>
						<xsl:when test="contains($data-area, ':')">
							<xsl:value-of select="substring-after($data-area, ':')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-after($data-area, '!')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="sDivPos">
					<xsl:call-template name="DivCellPos">
						<xsl:with-param name="CellAddress" select="$sAddress"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="eDivPos">
					<xsl:call-template name="DivCellPos">
						<xsl:with-param name="CellAddress" select="$eAddress"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="nStartCol">
					<xsl:call-template name="CellColNum">
						<xsl:with-param name="CellAddress" select="$sAddress"/>
						<xsl:with-param name="DivPos" select="$sDivPos"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="nEndCol">
					<xsl:call-template name="CellColNum">
						<xsl:with-param name="CellAddress" select="$eAddress"/>
						<xsl:with-param name="DivPos" select="$eDivPos"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="nStartRow">
					<xsl:value-of select="number(substring($sAddress, $sDivPos+1))"/>
				</xsl:variable>
				<xsl:variable name="nEndRow">
					<xsl:value-of select="number(substring($eAddress, $eDivPos+1))"/>
				</xsl:variable>
				<xsl:variable name="TableName">
					<xsl:variable name="Tmp1" select="substring-before($data-area, '!')"/>
					<xsl:value-of select="substring($data-area, 3, (string-length($Tmp1) - 3))"/>
				</xsl:variable>
				<xsl:variable name="IsRightSeriesName">
					<xsl:choose>
						<xsl:when test="@名称_E774 and contains(@名称_E774, '!') and contains(@名称_E774, '=')">
							<xsl:value-of select="'true'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'false'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="SeriesNameValue">
					<xsl:choose>
						<xsl:when test="$IsRightSeriesName = 'true'">
							<xsl:call-template name="All-Header-Cell">
								<xsl:with-param name="HeaderAddress" select="@名称_E774"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="@名称_E774">
									<xsl:value-of select="@名称_E774"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('系列', position())"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="SeriesPos" select="position()"/>
				<table:table-row>
					<xsl:call-template name="Set-Series-Cell">
						<xsl:with-param name="SeriesPos" select="position()"/>
						<xsl:with-param name="SeriesNameValue" select="$SeriesNameValue"/>
						<xsl:with-param name="IsRightSeriesName" select="$IsRightSeriesName"/>
					</xsl:call-template>
					<xsl:for-each select="/uof:UOF_0000/uof:电子表格/表:主体/表:工作表[string(@表:名称) = string($TableName)]">
						<xsl:variable name="var_TextID" select="concat(string($TableName),'.',string($sAddress),':',string($TableName),'.',string($eAddress))"/>
						<xsl:for-each select="表:工作表内容/表:行[number(@表:行号) &gt; (number($nStartRow) - 1)][number(@表:行号) &lt; (number($nEndRow) + 1)]">
							<xsl:for-each select="表:单元格[number(@表:列号) &gt; (number($nStartCol) - 1) and number(@表:列号) &lt; (number($nEndCol) + 1)]">
								<xsl:apply-templates select="." mode="chart">
									<xsl:with-param name="par_TextID" select="$var_TextID"/>
								</xsl:apply-templates>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:for-each>
				</table:table-row>
			</xsl:for-each>
		</table:table-rows>
	</xsl:template>
	<xsl:template match="表:单元格" mode="chart">
		<xsl:param name="par_TextID" select="''"/>
		<table:table-cell>
			<xsl:variable name="cellContent">
				<xsl:for-each select="表:数据/字:句">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="表:数据/@表:数据类型 = 'text'">
					<xsl:attribute name="office:value-type" select="'string'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="office:value-type" select="'float'"/>
					<xsl:attribute name="office:value" select="string($cellContent)"/>
				</xsl:otherwise>
			</xsl:choose>
			<text:p>
				<xsl:if test="$par_TextID != ''">
					<xsl:attribute name="text:id" select="$par_TextID"/>
				</xsl:if>
				<xsl:value-of select="$cellContent"/>
			</text:p>
		</table:table-cell>
	</xsl:template>
	<xsl:template name="DivCellPos">
		<xsl:param name="CellAddress"/>
		<xsl:variable name="x2" select="substring($CellAddress, 2, 1)"/>
		<xsl:variable name="x3" select="substring($CellAddress, 3, 1)"/>
		<xsl:choose>
			<xsl:when test="not($x3 &lt; 'A') and not($x3 &gt; 'Z')">
				<xsl:value-of select="3"/>
			</xsl:when>
			<xsl:when test="not($x2 &lt; 'A') and not($x2 &gt; 'Z')">
				<xsl:value-of select="2"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="1"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="CellColNum">
		<xsl:param name="CellAddress"/>
		<xsl:param name="DivPos"/>
		<xsl:variable name="StartCol">
			<xsl:value-of select="substring($CellAddress, 1, $DivPos)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$DivPos = 1">
				<xsl:value-of select="string-to-codepoints(substring($CellAddress, 1, 1)) - string-to-codepoints('A') + 1"/>
			</xsl:when>
			<xsl:when test="$DivPos = 2">
				<xsl:variable name="high" select="string-to-codepoints(substring($CellAddress, 2, 1)) - string-to-codepoints('A') + 1"/>
				<xsl:variable name="low" select="string-to-codepoints(substring($CellAddress, 1, 1)) - string-to-codepoints('A') + 1"/>
				<xsl:value-of select="$high * 26 + $low"/>
			</xsl:when>
			<xsl:when test="$DivPos = 3">
				<xsl:variable name="high" select="string-to-codepoints(substring($CellAddress, 3, 1)) - string-to-codepoints('A') + 1"/>
				<xsl:variable name="mid" select="string-to-codepoints(substring($CellAddress, 2, 1)) - string-to-codepoints('A') + 1"/>
				<xsl:variable name="low" select="string-to-codepoints(substring($CellAddress, 1, 1)) - string-to-codepoints('A') + 1"/>
				<xsl:value-of select="$high * 26 * 26 + $mid * 26 + $low"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="All-Header-Cell">
		<xsl:param name="HeaderAddress"/>
		<xsl:variable name="sAddress">
			<xsl:choose>
				<xsl:when test="contains($HeaderAddress, ':')">
					<xsl:value-of select="substring-after(substring-before($HeaderAddress, ':'), '!')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-after($HeaderAddress, '!')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="sDivPos">
			<xsl:call-template name="DivCellPos">
				<xsl:with-param name="CellAddress" select="$sAddress"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="nStartCol">
			<xsl:call-template name="CellColNum">
				<xsl:with-param name="CellAddress" select="$sAddress"/>
				<xsl:with-param name="DivPos" select="$sDivPos"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="nStartRow">
			<xsl:value-of select="number(substring($sAddress, $sDivPos+1))"/>
		</xsl:variable>
		<xsl:variable name="eAddress">
			<xsl:choose>
				<xsl:when test="contains($HeaderAddress, ':')">
					<xsl:value-of select="substring-after($HeaderAddress, ':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-after($HeaderAddress, '!')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="eDivPos">
			<xsl:choose>
				<xsl:when test="$eAddress = ''">
					<xsl:value-of select="0"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="DivCellPos">
						<xsl:with-param name="CellAddress" select="$eAddress"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="nEndCol">
			<xsl:choose>
				<xsl:when test="$eAddress = ''">
					<xsl:value-of select="$nStartCol"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="CellColNum">
						<xsl:with-param name="CellAddress" select="$eAddress"/>
						<xsl:with-param name="DivPos" select="$eDivPos"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="nEndRow">
			<xsl:choose>
				<xsl:when test="$eAddress = ''">
					<xsl:value-of select="$nStartRow"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number(substring($eAddress, $eDivPos+1))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="TableName">
			<xsl:variable name="Tmp1" select="substring-before($HeaderAddress, '!')"/>
			<xsl:value-of select="substring($HeaderAddress, 3, (string-length($Tmp1) - 3))"/>
		</xsl:variable>
		<xsl:variable name="var_TextID">
			<xsl:value-of select="concat( $TableName, '.' , $sAddress, ':', $TableName, '.' , $eAddress)"/>
		</xsl:variable>
		<xsl:for-each select="/uof:UOF_0000/uof:电子表格/表:主体/表:工作表[@表:名称 = $TableName]">
			<xsl:for-each select="表:工作表内容/表:行[@表:行号 &gt; ($nStartRow - 1) and @表:行号 &lt; ($nEndRow + 1)]">
				<xsl:for-each select="表:单元格[@表:列号 &gt; ($nStartCol - 1) and @表:列号 &lt; ($nEndCol + 1)]">
					<xsl:apply-templates select="." mode="chart">
						<xsl:with-param name="par_TextID" select="$var_TextID"/>
					</xsl:apply-templates>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="Parse-Catelog-Cell">
		<xsl:param name="par_CatelogArray"/>
		<xsl:choose>
			<xsl:when test="contains($par_CatelogArray, ',')">
				<table:table-cell office:value-type="string">
					<text:p>
						<xsl:value-of select="substring-before($par_CatelogArray, ',')"/>
					</text:p>
				</table:table-cell>
				<xsl:call-template name="Parse-Catelog-Cell">
					<xsl:with-param name="par_CatelogArray" select="substring-after($par_CatelogArray, ',')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<table:table-cell office:value-type="string">
					<text:p>
						<xsl:value-of select="$par_CatelogArray"/>
					</text:p>
				</table:table-cell>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Set-Catalog-Cell">
		<xsl:param name="SeriesPos"/>
		<xsl:param name="CatalogValue"/>
		<xsl:param name="IsRightCatalog"/>
		<xsl:choose>
			<xsl:when test="$IsRightCatalog = 'true'">
				<xsl:copy-of select="$CatalogValue"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="quot">&quot;</xsl:variable>
				<xsl:choose>
					<xsl:when test="contains(string($CatalogValue), '{') and contains(string($CatalogValue), '}')">
						<xsl:call-template name="Parse-Catelog-Cell">
							<xsl:with-param name="par_CatelogArray" select="replace(substring-before(substring-after($CatalogValue, '{'), '}'), $quot, '')"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<table:table-cell office:value-type="string">
							<text:p>
								<xsl:value-of select="$CatalogValue"/>
							</text:p>
						</table:table-cell>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Set-Series-Cell">
		<xsl:param name="SeriesPos"/>
		<xsl:param name="SeriesNameValue"/>
		<xsl:param name="IsRightSeriesName"/>
		<xsl:choose>
			<xsl:when test="$IsRightSeriesName = 'true'">
				<xsl:for-each select="$SeriesNameValue/table:table-cell[1]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<table:table-cell office:value-type="string">
					<text:p>
						<xsl:value-of select="$SeriesNameValue"/>
					</text:p>
				</table:table-cell>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="MaxColumninLocal-Table">
		<xsl:param name="CurMaxCol"/>
		<xsl:choose>
			<xsl:when test="following-sibling::table:table-row">
				<xsl:for-each select="following-sibling::table:table-row[1]">
					<xsl:variable name="NewMaxCol">
						<xsl:variable name="nColCount" select="count(table:table-cell)"/>
						<xsl:choose>
							<xsl:when test="CurMaxCol &gt; nColCount">
								<xsl:value-of select="$CurMaxCol"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$nColCount"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:call-template name="MaxColumninLocal-Table">
						<xsl:with-param name="CurMaxCol" select="$NewMaxCol"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$CurMaxCol"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="CreateEmptyTableCell">
		<xsl:param name="par_Num" select="number('0')"/>
		<xsl:if test="number($par_Num) gt 0">
			<table:table-cell>
				<text:p/>
			</table:table-cell>
			<xsl:call-template name="CreateEmptyTableCell">
				<xsl:with-param name="par_Num" select="number($par_Num) - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="CreateDefaultCatelogs">
		<xsl:param name="par_Num" select="number('0')"/>
		<xsl:if test="number($par_Num) gt 0">
			<xsl:call-template name="CreateDefaultCatelogs">
				<xsl:with-param name="par_Num" select="number($par_Num) - 1"/>
			</xsl:call-template>
			<table:table-cell office:value-type="string">
				<text:p>
					<xsl:value-of select="$par_Num"/>
				</text:p>
			</table:table-cell>
		</xsl:if>
	</xsl:template>
	<xsl:template name="TableTable4chart">
		<table:table table:name="local-table">
			<xsl:variable name="reverse-row">
				<xsl:call-template name="CreateTmpLocTable"/>
			</xsl:variable>
			<!--test><xsl:copy-of select="$reverse-row"/></test-->
			<xsl:variable name="ColCount">
				<xsl:for-each select="$reverse-row/table:table-rows/table:table-row[1]">
					<xsl:variable name="CurMaxCol" select="count(table:table-cell)"/>
					<xsl:call-template name="MaxColumninLocal-Table">
						<xsl:with-param name="CurMaxCol" select="$CurMaxCol"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:variable>
			<table:table-header-columns>
				<table:table-column/>
			</table:table-header-columns>
			<table:table-columns>
				<table:table-column>
					<xsl:attribute name="table:number-columns-repeated" select="number($ColCount)-1"/>
				</table:table-column>
			</table:table-columns>
			<!--table:table-header-rows-->
			<table:table-header-rows>
				<table:table-row>
					<table:table-cell>
						<text:p/>
					</table:table-cell>
					<xsl:for-each select="$reverse-row/table:table-header-rows/table:table-row">
						<xsl:choose>
							<xsl:when test="count(table:table-cell) = 0">
								<xsl:call-template name="CreateDefaultCatelogs">
									<xsl:with-param name="par_Num" select="number($ColCount) - 1"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="count(table:table-cell) ge number($ColCount) - 1 ">
								<xsl:copy-of select="table:table-cell[position() lt number($ColCount)]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="table:table-cell"/>
								<xsl:call-template name="CreateEmptyTableCell">
									<xsl:with-param name="par_Num" select="number($ColCount) - count(table:table-cell) - 1"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</table:table-row>
			</table:table-header-rows>
			<!--table:table-rows-->
			<xsl:copy-of select="$reverse-row/table:table-rows"/>
		</table:table>
	</xsl:template>
	<xsl:template name="LocalTableForChart">
		<xsl:param name="chartName"/>
		<xsl:for-each select="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201/扩展:扩展内容_B204[扩展:路径_B205 = $chartName]/扩展:内容_B206/扩展:local-table">
			<table:table table:name="local-table">
				<xsl:copy-of select="@*|node()"/>
			</table:table>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="OfficeBody4chart">
		<office:body>
			<office:chart>
				<chart:chart>
					<!--@xlink:href 用于读取local-table中的数据-->
					<xsl:if test="$document_type != 'spreadsheet'">
						<xsl:attribute name="xlink:href" select="'.'"/>
					</xsl:if>
					<xsl:variable name="ChartName" select="@标识符_E828"/>
					<!--anchor for chart-->
					<xsl:variable name="AnchorChart" select="key('rel_graphic_name',key('graph4chart',$ChartName)/@标识符_804B)"/>
					<xsl:for-each select="$AnchorChart">
						<xsl:for-each select="uof:位置_C620">
							<xsl:for-each select="uof:水平_4106/uof:绝对_4107">
								<xsl:if test="@值_4108">
									<xsl:attribute name="svg:x" select="concat(@值_4108,$uofUnit)"/>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select="uof:垂直_410D/uof:绝对_4107">
								<xsl:if test="@值_4108">
									<xsl:attribute name="svg:y" select="concat(@值_4108,$uofUnit)"/>
								</xsl:if>
							</xsl:for-each>
						</xsl:for-each>
						<xsl:for-each select="uof:大小_C621">
							<xsl:if test="@宽_C605">
								<xsl:attribute name="svg:width" select="concat(@宽_C605,$uofUnit)"/>
							</xsl:if>
							<xsl:if test="@长_C604">
								<xsl:attribute name="svg:height" select="concat(@长_C604,$uofUnit)"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each>
					<xsl:for-each select="图表:绘图区_E747/图表:图表类型组集_E74C/图表:组_E74D[1]/图表:数据系列集_E74E/图表:数据系列_E74F[1]">
						<xsl:variable name="table-type" select="@类型_E75D"/>
						<xsl:variable name="table-subtype" select="@子类型_E777"/>
						<xsl:variable name="odfclass">
							<xsl:choose>
								<!--xsl:when test="$table-type='bar'">chart:bar</xsl:when>
						<xsl:when test="$table-type='line'">chart:line</xsl:when>
						<xsl:when test="$table-type='pie'">
							<xsl:choose>
								<xsl:when test="$table-subtype='pie_ring'">chart:ring</xsl:when>
								<xsl:otherwise>chart:circle</xsl:otherwise>
							</xsl:choose>
						</xsl:when-->
								<xsl:when test="$table-type='pie'">
									<xsl:value-of select="'chart:circle'"/>
								</xsl:when>
								<xsl:when test="$table-type='doughnut'">
									<xsl:value-of select="'chart:ring'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('chart:',$table-type)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:attribute name="chart:class" select="$odfclass"/>
					</xsl:for-each>
					<xsl:attribute name="chart:style-name">chart-area</xsl:attribute>
					<!--UOF2.0的标题定义存在问题：坐标轴、图表下标题编号E736,E7A0不一致-->
					<xsl:apply-templates select="图表:标题_E736" mode="chartbody">
						<xsl:with-param name="ChartSize" select="$AnchorChart/uof:大小_C621"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="图表:图例_E794" mode="chartbody">
						<xsl:with-param name="ChartSize" select="$AnchorChart/uof:大小_C621"/>
					</xsl:apply-templates>
					<xsl:call-template name="PlotArea4chart">
						<xsl:with-param name="ChartSize" select="$AnchorChart/uof:大小_C621"/>
					</xsl:call-template>
					<xsl:choose>
						<xsl:when test="$document_type != 'spreadsheet'">
							<!--处理文字处理和演示文稿模块的图表功能-->
							<xsl:call-template name="LocalTableForChart">
								<xsl:with-param name="chartName" select="$ChartName"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="TableTable4chart"/>
						</xsl:otherwise>
					</xsl:choose>
				</chart:chart>
			</office:chart>
		</office:body>
	</xsl:template>
	<xsl:template match="图表:图表_E837">
		<xsl:variable name="var_ObjectName">
			<xsl:variable name="var_GenerateID" select="generate-id(.)"/>
			<xsl:value-of select="concat('./Object ',$var_GenerateID)"/>
		</xsl:variable>
		<xsl:element name="draw:frame">
			<!-- Waiting, 目前对图表的定位仍存在问题 xsl:attribute name="draw:z-index"><xsl:value-of select="'0'"/></xsl:attribute>
			<xsl:attribute name="svg:width"><xsl:value-of select="concat(@表:宽度,$uofUnit)"/></xsl:attribute>
			<xsl:attribute name="svg:height"><xsl:value-of select="concat(@表:高度,$uofUnit)"/></xsl:attribute>
			<xsl:attribute name="svg:x"><xsl:value-of select="concat(@表:x坐标,$uofUnit)"/></xsl:attribute>
			<xsl:attribute name="svg:y"><xsl:value-of select="concat(@表:y坐标,$uofUnit)"/></xsl:attribute-->
			<xsl:element name="draw:object">
				<!-- no sure, these attributes's relation , xsl:attribute name="draw:notify-on-update-of-ranges"><xsl:choose><xsl:when test="表:数据源/@表:数据区域"><xsl:value-of select="表:数据源/@表:数据区域"/></xsl:when><xsl:otherwise><xsl:for-each select="表:数据源/表:系列"><xsl:if test="@表:系列值"><xsl:analyze-string select="@表:系列值" regex="='(.*?)'!([A-Z,a-z]{{1,2}}\d+):?([A-Z,a-z]{{1,2}}\d+)?"><xsl:matching-substring><xsl:choose><xsl:when test="regex-group(3) = ''"><xsl:value-of select="concat(regex-group(1), '.', regex-group(2))"/></xsl:when><xsl:otherwise><xsl:value-of select="concat(regex-group(1), '.', regex-group(2), ':', regex-group(1), '.', regex-group(3))"/></xsl:otherwise></xsl:choose><xsl:value-of select="' '"/></xsl:matching-substring></xsl:analyze-string></xsl:if></xsl:for-each><xsl:for-each-group select="表:数据源/表:系列" group-by="@表:分类名"><xsl:analyze-string select="current-grouping-key()" regex="='(.*?)'!([A-Z,a-z]{{1,2}}\d+):?([A-Z,a-z]{{1,2}}\d+)?"><xsl:matching-substring><xsl:choose><xsl:when test="regex-group(3) = ''"><xsl:value-of select="concat(regex-group(1), '.', regex-group(2), ':', regex-group(1), '.', regex-group(2))"/></xsl:when><xsl:otherwise><xsl:value-of select="concat(regex-group(1), '.', regex-group(2), ':', regex-group(1), '.', regex-group(3))"/></xsl:otherwise></xsl:choose><xsl:value-of select="' '"/></xsl:matching-substring></xsl:analyze-string></xsl:for-each-group><xsl:for-each-group select="表:数据源/表:系列" group-by="@表:系列名"><xsl:analyze-string select="current-grouping-key()" regex="='(.*?)'!([A-Z,a-z]{{1,2}}\d+):?([A-Z,a-z]{{1,2}}\d+)?"><xsl:matching-substring><xsl:choose><xsl:when test="regex-group(3) = ''"><xsl:value-of select="concat(regex-group(1), '.', regex-group(2), ':', regex-group(1), '.', regex-group(2))"/></xsl:when><xsl:otherwise><xsl:value-of select="concat(regex-group(1), '.', regex-group(2), ':', regex-group(1), '.', regex-group(3))"/></xsl:otherwise></xsl:choose><xsl:value-of select="' '"/></xsl:matching-substring></xsl:analyze-string></xsl:for-each-group></xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:attribute name="xlink:href"><xsl:value-of select="$var_ObjectName"/></xsl:attribute-->
				<xsl:attribute name="xlink:type">simple</xsl:attribute>
				<xsl:attribute name="xlink:show">embed</xsl:attribute>
				<xsl:attribute name="xlink:actuate">onLoad</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:variable name="ooMaxColumnNum" select="1024"/>
	<xsl:variable name="ooMaxRowNum" select="65536"/>
	<!--xsl:template match="uof:锚点_C644|演:锚点_E7BA|uof:锚点_E7BA" mode="table"-->
	<xsl:template match="uof:锚点_C644" mode="table">
		<xsl:call-template name="ObjectContent"/>
	</xsl:template>
	<!-- OASIS OpenDocument Format change:
		Excel   "=RC4*6"
		OOoXML "=$D22*6"
	 OASIS XML "of:=[.$D22]*6" -->
	<xsl:template name="translate-expression">
		<!--  return position or range for formula or other -->
		<xsl:param name="cell-row-pos"/>
		<!-- the position in row (vertical) of cell -->
		<xsl:param name="cell-column-pos"/>
		<!-- the position in column (horizontal of cell -->
		<xsl:param name="expression"/>
		<!-- as mode changes a '[.' resp. ']' is written out  -->
		<xsl:param name="return-value"/>
		<!-- expression of table:cell-range-address is different than formula (e.g. no prefix)  -->
		<xsl:param name="isRangeAddress"/>
		<!-- determines if RC translate -->
		<xsl:param name="isRCtrans"/>
		<!-- recomposed expression containing cell positions after every conversion -->
		<xsl:param name="is-range-mode" select="'false'"/>
		<!-- value to be given out later -->
		<!-- to judge whether this input expression contains any cell position to convert -->
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
		<!-- if $range-type = 1, then range is representing a sheet, function's name or separated symbol, but not cell position,
			 or if $range-type = 2, range should be handled because it contains certain cell position.
			 The first character marks the type of that expression. -->
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
		<!-- remove that added range type token -->
		<xsl:variable name="current-range">
			<xsl:value-of select="substring($temp-range, 2)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$range-type = 1">
				<!-- Nothing to convert, so just join the front and behind strings. -->
				<xsl:call-template name="translate-expression">
					<xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
					<xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
					<xsl:with-param name="expression">
						<!-- get current converting position from $temp-token or $current-range, then join the expression. -->
						<xsl:choose>
							<xsl:when test="contains($current-range, &quot;&apos;!&quot;)">
								<xsl:value-of select="substring-after($expression, '!')"/>
							</xsl:when>
							<xsl:when test="contains($current-range, '#$')">
								<!-- because of recomposing of string, the $current-range may not be the pit
							of $expression, so the char #$ should not be used for nominal -->
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
						<!-- react on range mode change (when to insert closing ']' or in case of '!' change the mode to RANGE and create open '[' -->
						<xsl:choose>
							<xsl:when test="$current-range = '=' and $return-value = '' and not($isRangeAddress)">
								<xsl:text>of:=</xsl:text>
							</xsl:when>
							<xsl:when test="contains($current-range, '!') and not($isRangeAddress)">
								<xsl:choose>
									<xsl:when test="$isRCtrans = 'true'">
										<xsl:value-of select="concat($return-value, '[', $current-range)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($return-value, $current-range)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$is-range-mode = 'true' and $current-range != ':' and not($isRangeAddress)">
										<xsl:value-of select="concat($return-value, ']', substring-before($expression, $current-range), $current-range)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($return-value, substring-before($expression, $current-range), $current-range)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="is-range-mode">
						<xsl:choose>
							<!-- ! is the separator of worksheet and range
								 : is the separator for a cell range -->
							<xsl:when test="contains($current-range, '!') or $current-range = ':'">
								<xsl:value-of select="'true'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'false'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
					<xsl:with-param name="isRCtrans" select="$isRCtrans"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- types of range to handle in $current-range, i.e. the cell position expression to convert
					1: special cell including row and column; e.g. R4C5
					2: whole row; e.g. R3
					3: whole column; e.g. C5
					4: other name not for cell or row/column; e.g. RANDOM() or something unknown
				-->
				<xsl:variable name="handle-type">
					<xsl:choose>
						<xsl:when test="$isRCtrans = 'false'">
							<xsl:value-of select="0"/>
						</xsl:when>
						<xsl:when test="starts-with($current-range, 'R')">
							<!-- It's type 1 or type 2 or 4/unknown cell position. -->
							<xsl:choose>
								<xsl:when test="contains($current-range, 'C')">
									<!-- It's type 1, specifying the cell position or 4/unknown -->
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
									<!-- It's type 2 specifying the cell position, or 4/unknown. -->
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
							<!-- It's type 3 of cell position, or 4/unknown -->
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
							<!-- It's type 4, not cell position -->
							<xsl:value-of select="4"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- Start to convert that cell position expression, that cell position unit -->
				<xsl:choose>
					<xsl:when test="$handle-type = 1">
						<!-- It's type 1, e.g. R1C2 -->
						<!-- process the row part -->
						<xsl:variable name="after-R">
							<xsl:value-of select="substring(substring-after($current-range,'R'),1,1)"/>
						</xsl:variable>
						<xsl:choose>
							<!-- found one cell unit -->
							<xsl:when test="$after-R='C' or $after-R='[' or $after-R='0' or $after-R='1' or $after-R='2' or $after-R='3' or $after-R='4' or $after-R='5' or $after-R='6' or $after-R='7' or $after-R='8' or $after-R='9'">
								<xsl:variable name="row-pos">
									<xsl:choose>
										<xsl:when test="$after-R='['">
											<xsl:value-of select="$cell-row-pos + number(substring-before( substring-after($current-range,'R['),']'))"/>
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
								<!-- process the column part -->
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
											<xsl:value-of select="$cell-column-pos + number(substring-before(substring-after(substring-after($current-range,'R'),'C['),']'))"/>
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
									<xsl:with-param name="return-value">
										<xsl:choose>
											<xsl:when test="$is-range-mode = 'true'">
												<xsl:value-of select="concat($return-value, '.', $name-unit)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat($return-value, '[.', $name-unit)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="is-range-mode" select="'true'"/>
									<xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
									<xsl:with-param name="isRCtrans" select="$isRCtrans"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), translate( substring-before(substring-after($expression, '('),'R'),',!', ';.'))"/>
								<xsl:call-template name="translate-expression">
									<xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
									<xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
									<xsl:with-param name="expression" select="substring-after($current-range,'R')"/>
									<xsl:with-param name="return-value">
										<xsl:choose>
											<xsl:when test="$is-range-mode = 'true'">
												<xsl:value-of select="concat($return-value, $name-unit)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat($return-value, '[.', $name-unit)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="is-range-mode" select="'true'"/>
									<xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
									<xsl:with-param name="isRCtrans" select="$isRCtrans"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$handle-type = 2">
						<!-- It's type 2, e.g. R3 -->
						<!-- process the range only including a whole row -->
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
								<xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), $trans-unit1, ':.', $trans-unit2)"/>
								<xsl:call-template name="translate-expression">
									<xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
									<xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
									<xsl:with-param name="expression" select="substring-after($expression, $current-range)"/>
									<xsl:with-param name="return-value">
										<xsl:choose>
											<xsl:when test="$is-range-mode = 'true'">
												<xsl:value-of select="concat($return-value, '.', $name-unit)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat($return-value, '[.', $name-unit)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="is-range-mode" select="'true'"/>
									<xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
									<xsl:with-param name="isRCtrans" select="$isRCtrans"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), translate( substring-before($current-range,'R'),',!', ';.'),'R')"/>
								<xsl:call-template name="translate-expression">
									<xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
									<xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
									<xsl:with-param name="expression" select="substring-after($current-range,'R')"/>
									<xsl:with-param name="return-value">
										<xsl:choose>
											<xsl:when test="$is-range-mode = 'true'">
												<xsl:value-of select="concat($return-value, '.', $name-unit)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat($return-value, '[.', $name-unit)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="is-range-mode" select="'true'"/>
									<xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
									<xsl:with-param name="isRCtrans" select="$isRCtrans"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$handle-type = 3">
						<!-- It's type 3, e.g. C4 -->
						<!-- process the range only including a whole column -->
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
										<xsl:with-param name="row-number" select="65565"/>
										<xsl:with-param name="column-pos-style" select="'relative'"/>
										<xsl:with-param name="row-pos-style" select="'relative'"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), $trans-unit1, ':.', $trans-unit2)"/>
								<xsl:call-template name="translate-expression">
									<xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
									<xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
									<xsl:with-param name="expression" select="substring-after($expression, $current-range)"/>
									<xsl:with-param name="return-value">
										<xsl:choose>
											<xsl:when test="$is-range-mode = 'true'">
												<xsl:value-of select="concat($return-value, '.', $name-unit)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat($return-value, '[.', $name-unit)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="is-range-mode" select="'true'"/>
									<xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
									<xsl:with-param name="isRCtrans" select="$isRCtrans"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="name-unit" select="concat(substring-before($expression, $current-range), translate( substring-before($current-range,'C'),',!', ';.'),'C')"/>
								<xsl:call-template name="translate-expression">
									<xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
									<xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
									<xsl:with-param name="expression" select="substring-after($current-range,'C')"/>
									<xsl:with-param name="return-value">
										<xsl:choose>
											<xsl:when test="$is-range-mode = 'true'">
												<xsl:value-of select="concat($return-value, '.', $name-unit)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat($return-value, '[.', $name-unit)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="is-range-mode" select="'true'"/>
									<xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
									<xsl:with-param name="isRCtrans" select="$isRCtrans"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<!-- It's unknown, so just jump over it -->
						<xsl:variable name="next-pit" select="substring-after($expression, $current-range)"/>
						<xsl:choose>
							<xsl:when test="contains($next-pit, '+') or contains($next-pit, '-') or contains($next-pit, '*') or contains($next-pit, '/') or contains($next-pit, ')') or contains($next-pit, '^') or contains($next-pit, ':') or contains($next-pit, '&quot;') or contains($next-pit, ';') or contains($next-pit, ',') or contains($next-pit, '[')">
								<xsl:call-template name="translate-expression">
									<xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
									<xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
									<xsl:with-param name="expression" select="substring-after($expression, $current-range)"/>
									<xsl:with-param name="return-value" select="concat($return-value, substring-before($expression, $current-range), $current-range)"/>
									<xsl:with-param name="is-range-mode" select="'false'"/>
									<xsl:with-param name="isRangeAddress" select="$isRangeAddress"/>
									<xsl:with-param name="isRCtrans" select="$isRCtrans"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<!-- return the final range or formula -->
								<xsl:choose>
									<!-- in case the closing bracket of the range wasn't set, do it now  -->
									<xsl:when test="$is-range-mode = 'true' and $current-range = ''">
										<xsl:choose>
											<xsl:when test="$isRCtrans = 'false'">
												<xsl:value-of select="translate( concat($return-value, ']'),',!', ';.')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="translate( concat($return-value, ']'),',!', ';')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="$isRCtrans = 'false'">
												<xsl:value-of select="translate( concat($return-value, substring-before($expression, $current-range), $current-range),',!', ';.')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="translate( concat($return-value, substring-before($expression, $current-range), $current-range),',!', ';')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="parse-range-name">
		<!-- return the string or name for next handle. the type 1 is names of function, sheet, special separated symbol, not to parse as range; type 2 is the range including R/C to be parsed -->
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
						<xsl:variable name="str-out">
							<xsl:value-of select="concat(&quot;&apos;&quot;, substring-before(substring-after($expression, '['), ']'), &quot;&apos;&quot;, '#$', substring-before(substring-after($expression, ']'), '!'))"/>
						</xsl:variable>
						<xsl:call-template name="parse-range-name">
							<xsl:with-param name="expression" select="concat('!', substring-after($expression, '!'))"/>
							<xsl:with-param name="return-value" select="concat($return-value, $str-out)"/>
						</xsl:call-template>
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
				<!-- here the string &quot;&apos;&quot; represents a char &apos;  -->
				<xsl:variable name="str-in" select="substring-before(substring-after($expression, &quot;&apos;&quot;), &quot;&apos;&quot;)"/>
				<xsl:choose>
					<xsl:when test="substring(substring-after(substring($expression, 2), &quot;&apos;&quot;), 1, 1) = '!'">
						<xsl:variable name="str-out">
							<xsl:choose>
								<xsl:when test="contains($str-in, '[') and contains($str-in, ']')">
									<xsl:variable name="first-pos" select="substring-before($str-in, '[')"/>
									<xsl:variable name="second-pos" select="substring-before(substring-after($str-in, '['), ']')"/>
									<xsl:variable name="third-pos" select="substring-after($str-in, ']')"/>
									<xsl:value-of select="concat(&quot;&apos;&quot;, $first-pos, $second-pos, &quot;&apos;&quot;, '#$', &quot;&apos;&quot;, $third-pos, &quot;&apos;&quot;)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat(&quot;&apos;&quot;, $str-in, &quot;&apos;&quot;)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:call-template name="parse-range-name">
							<xsl:with-param name="expression" select="substring($expression, string-length($str-in)+3)"/>
							<xsl:with-param name="return-value" select="concat($return-value, $str-out)"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<!-- for file path transformation -->
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
		<!-- to handle the part between R and C, or after C in range string in translate-expression. return type: 1: number or cell range; 2: other, not for next step -->
		<xsl:param name="t-part"/>
		<xsl:choose>
			<xsl:when test="starts-with($t-part, '[')">
				<xsl:variable name="tt-str" select="substring-before( substring-after( $t-part, '['), ']')"/>
				<xsl:choose>
					<xsl:when test="(number($tt-str) &lt; 0) or (number($tt-str) &gt; 0) or (number($tt-str) = 0)">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="2"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="(number($t-part) &lt; 0) or (number($t-part) &gt; 0) or (number($t-part) = 0)">
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
		<!-- convert cell position expression unit, R1C1, R3, C4 -->
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
		<!-- position styles are 'absolute' or 'relative', -->
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
	<xsl:template name="get-digit-length">
		<xsl:param name="complexive-string"/>
		<xsl:variable name="first-char">
			<xsl:value-of select="substring( $complexive-string, 1, 1)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$first-char = '1' or $first-char = '2' or $first-char = '3' or $first-char = '4' or $first-char = '5' or $first-char = '6' or $first-char = '7' or $first-char = '8' or $first-char = '9' or $first-char = '0' ">
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
	<xsl:template match="表:数据_E7B3" mode="table">
		<xsl:param name="hyperDest"/>
		<xsl:choose>
			<xsl:when test="not($hyperDest) or $hyperDest = ''">
				<xsl:element name="text:p">
					<xsl:for-each select="字:句_419D">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="text:p">
					<xsl:element name="text:a">
						<xsl:attribute name="xlink:type" select="'simple'"/>
						<xsl:for-each select="key('hyperlinkID', $hyperDest)">
							<xsl:variable name="var_Target">
								<xsl:value-of select="超链:目标_AA01"/>
							</xsl:variable>
							<xsl:variable name="href">
								<xsl:choose>
									<xsl:when test="@书签_AA0D and key('bookmark', @书签_AA0D)/uof:命名表达式/@区域引用_41CE">
										<xsl:value-of select="concat('#',@书签_AA0D)"/>
									</xsl:when>
									<!-- case Bookmark: outside or inside -->
									<xsl:when test="key('bookmark',超链:目标_AA01)">
										<xsl:value-of select="concat('#',$var_Target)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:analyze-string select="$var_Target" regex="=?'?(.*?)'?!\$?([A-Z,a-z]{{1,2}})\$?(\d+)">
											<xsl:matching-substring>
												<xsl:value-of select="concat('#', '$', regex-group(1), '.', '$', regex-group(2), '$', regex-group(3))"/>
											</xsl:matching-substring>
											<xsl:non-matching-substring>
												<xsl:choose>
													<xsl:when test="contains($var_Target,'\')">
														<xsl:value-of select="concat('/',translate($var_Target,'\','/'))"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$var_Target"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:non-matching-substring>
										</xsl:analyze-string>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:attribute name="xlink:href" select="$href"/>
							<xsl:variable name="visited">
								<xsl:value-of select="超链:式样_AA02/@已访问式样引用_AA04"/>
							</xsl:variable>
							<xsl:variable name="stylename">
								<xsl:value-of select="超链:式样_AA02/@未访问式样引用_AA03"/>
							</xsl:variable>
							<xsl:attribute name="text:style-name" select="$stylename"/>
							<xsl:attribute name="text:visited-style-name" select="$visited"/>
						</xsl:for-each>
						<xsl:for-each select="字:句_419D">
							<xsl:apply-templates select="."/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--uof2.0 has deleted the below elements-->
	<xsl:template match="表:批注_E7B7" mode="table">
		<xsl:element name="office:annotation">
			<xsl:if test="string(@是否显示_E7B9) = 'true'">
				<xsl:attribute name="office:display">true</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="draw:style-name"><xsl:value-of select="uof:锚点_C644/@图形引用_C62E"/></xsl:attribute>
			<xsl:attribute name="svg:height"><xsl:value-of select="concat(uof:锚点_C644/uof:大小_C621/@长_C604,$uofUnit)"/></xsl:attribute>
			<xsl:attribute name="svg:width"><xsl:value-of select="concat(uof:锚点_C644/uof:大小_C621/@宽_C605,$uofUnit)"/></xsl:attribute>
			<xsl:attribute name="svg:x"><xsl:value-of select="concat(uof:锚点_C644/uof:位置_C620/uof:水平_4106/uof:绝对_4107/@值_4108,$uofUnit)"/></xsl:attribute>
			<xsl:attribute name="svg:y"><xsl:value-of select="concat(uof:锚点_C644/uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108,$uofUnit)"/></xsl:attribute>
			<xsl:variable name="graph-name">
				<xsl:value-of select="./uof:锚点_C644/@图形引用_C62E"/>
			</xsl:variable>
			<xsl:for-each select="key('graph-styles',$graph-name)/图:文本_803C/图:内容_8043/*">
				<xsl:choose>
					<xsl:when test="name(.)='字:段落_416B'">
						<xsl:apply-templates select="."/>
					</xsl:when>
					<xsl:when test="name(.)='字:文字表_416C'">
						<xsl:apply-templates select="."/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
			<!--xsl:apply-templates select="uof:锚点_C644" mode="table"/-->
		</xsl:element>
	</xsl:template>
	<xsl:template name="CreateRowCells">
		<xsl:param name="par_curCellColumnNum" select="1"/>
		<xsl:variable name="var_curCellColumnNum">
			<xsl:choose>
				<xsl:when test="@列号_E7ED">
					<xsl:value-of select="@列号_E7ED"/>
				</xsl:when>
				<!-- 列中的列号和单元格中的列号编号不同 -->
				<xsl:when test="@列号_E7BC">
					<xsl:value-of select="@列号_E7BC"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$par_curCellColumnNum"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="var_curCellSpanAfter">
			<xsl:choose>
				<xsl:when test="表:合并_E7AF/@列数_E7B0">
					<xsl:value-of select="number(表:合并_E7AF/@列数_E7B0) + 1"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="var_curCellRepeatAfter">
			<xsl:choose>
				<xsl:when test="@跨度_E7EF">
					<xsl:value-of select="@跨度_E7EF"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tabelCellName">
			<xsl:choose>
				<xsl:when test="name(.) = '表:单元格_E7F2'">table:table-cell</xsl:when>
				<xsl:otherwise>table:covered-table-cell</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- no sure : 跨度已在预处理中换算 -->
		<xsl:if test="number($var_curCellColumnNum) &gt; number($par_curCellColumnNum)">
			<xsl:element name="table:table-cell">
				<xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="$var_curCellColumnNum - $par_curCellColumnNum"/></xsl:attribute>
			</xsl:element>
		</xsl:if>
		<xsl:element name="{$tabelCellName}">
			<!--xsl:choose>
				<xsl:when test="@表:条件格式化 and @式样引用_E7BD">
					<xsl:attribute name="table:style-name"><xsl:value-of select="concat(@表:条件格式化, @式样引用_E7BD)"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="@表:条件格式化">
					<xsl:attribute name="table:style-name"><xsl:value-of select="@表:条件格式化"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="@式样引用_E7BD">
					<xsl:attribute name="table:style-name"><xsl:value-of select="@式样引用_E7BD"/></xsl:attribute>
				</xsl:when>
			</xsl:choose-->
			<xsl:if test="@式样引用_E7BD">
				<xsl:attribute name="table:style-name"><xsl:value-of select="@式样引用_E7BD"/></xsl:attribute>
			</xsl:if>
			<xsl:for-each select="表:合并_E7AF">
				<xsl:if test="@列数_E7B0">
					<!--xsl:attribute name="table:number-columns-spanned"><xsl:value-of select="表:合并_E7AF/@列数_E7B0 + 1"/></xsl:attribute-->
					<xsl:attribute name="table:number-columns-spanned" select="number(@列数_E7B0) + 1"/>
				</xsl:if>
				<xsl:if test="@行数_E7B1">
					<!--xsl:attribute name="table:number-rows-spanned"><xsl:value-of select="表:合并_E7AF/@行数_E7B1 + 1"/></xsl:attribute-->
					<xsl:attribute name="table:number-rows-spanned" select="number(@行数_E7B1) + 1"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="@跨度_E7EF">
				<xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="@跨度_E7EF + 1"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@表:content-validation-name">
				<xsl:attribute name="table:content-validation-name" select="@表:content-validation-name"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="表:数据_E7B3/@类型_E7B6 = 'number'">
					<xsl:variable name="table-stylename" select="@式样引用_E7BD"/>
					<xsl:variable name="data-format">
						<xsl:for-each select="key('CellStyle', $table-stylename)">
							<xsl:value-of select="表:数字格式_E7A9/@分类名称_E740"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="data-formatcode">
						<xsl:for-each select="key('CellStyle', $table-stylename)">
							<xsl:value-of select="表:数字格式_E7A9/@格式码_E73F"/>
						</xsl:for-each>
					</xsl:variable>
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
					<xsl:variable name="value">
						<xsl:choose>
							<xsl:when test="$data-format = 'percentage' or contains( $data-formatcode, '%')">
								<xsl:value-of select="表:数据_E7B3/字:句_419D/字:文本串_415B"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="表:数据_E7B3/字:句_419D/字:文本串_415B"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="office:value"><xsl:value-of select="$value"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="表:数据_E7B3/@类型_E7B6 = 'date'">
					<xsl:attribute name="office:value-type">date</xsl:attribute>
					<xsl:attribute name="office:date-value"><xsl:value-of select="表:数据_E7B3/字:句_419D/字:文本串_415B"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="表:数据_E7B3/@类型_E7B6 = 'time' or 表:数据_E7B3/@类型_E7B6 = 'error'">
					<xsl:attribute name="office:value-type">time</xsl:attribute>
					<xsl:attribute name="office:time-value"><xsl:value-of select="表:数据_E7B3/字:句_419D/字:文本串_415B"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="表:数据_E7B3/@类型_E7B6 = 'boolean'">
					<xsl:attribute name="office:value-type">boolean</xsl:attribute>
					<xsl:variable name="BooleanValue">
						<xsl:choose>
							<xsl:when test="表:数据_E7B3/字:句_419D/字:文本串_415B = 'true'">true</xsl:when>
							<xsl:when test="表:数据_E7B3/字:句_419D/字:文本串_415B = '1'">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="office:boolean-value"><xsl:value-of select="$BooleanValue"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="表:数据_E7B3/@类型_E7B6 = 'text'">
					<xsl:attribute name="office:value-type">string</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="表:数据_E7B3/表:公式_E7B5">
				<xsl:variable name="sCellFormula">
					<xsl:choose>
						<xsl:when test="contains(表:数据_E7B3/表:公式_E7B5,'=TABLE')">
							<xsl:variable name="firstTemp">
								<xsl:value-of select="substring-after(表:数据_E7B3/表:公式_E7B5,'=TABLE')"/>
							</xsl:variable>
							<xsl:value-of select="concat('=MULTIPLE.OPERATIONS',$firstTemp)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="表:数据_E7B3/表:公式_E7B5"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="calc-formula">
					<xsl:choose>
						<xsl:when test="$isRCCellAddress = 'true'">
							<xsl:variable name="cell-row-pos">
								<xsl:choose>
									<xsl:when test="../@行号_E7F3 != ''">
										<xsl:value-of select="../@行号_E7F3"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="9"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="cell-column-pos">
								<xsl:choose>
									<xsl:when test="@列号_E7ED != ''">
										<xsl:value-of select="@列号_E7ED"/>
									</xsl:when>
									<!--列中的列号和单元格中的列号编号不同-->
									<xsl:when test="@列号_E7BC != ''">
										<xsl:value-of select="@列号_E7BC"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="9"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:call-template name="translate-expression">
								<xsl:with-param name="cell-row-pos" select="$cell-row-pos"/>
								<xsl:with-param name="cell-column-pos" select="$cell-column-pos"/>
								<xsl:with-param name="expression" select="$sCellFormula"/>
								<xsl:with-param name="return-value" select="''"/>
								<xsl:with-param name="isRCtrans" select="'true'"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="translate-expression">
								<xsl:with-param name="cell-row-pos" select="0"/>
								<xsl:with-param name="cell-column-pos" select="0"/>
								<xsl:with-param name="expression" select="$sCellFormula"/>
								<xsl:with-param name="return-value" select="''"/>
								<xsl:with-param name="isRCtrans" select="'false'"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="table:formula" select="$calc-formula"/>
			</xsl:if>
			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="name(.) = '表:数据_E7B3'">
						<xsl:apply-templates select="." mode="table">
							<xsl:with-param name="hyperDest" select="../@超链接引用_E7BE"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="table"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
		<xsl:choose>
			<xsl:when test="following-sibling::*[name() = '表:单元格_E7F2' or name() = '表:covered-table-cell']">
				<xsl:for-each select="following-sibling::*[1]">
					<xsl:call-template name="CreateRowCells">
						<xsl:with-param name="par_curCellColumnNum">
							<xsl:value-of select="$var_curCellColumnNum + $var_curCellSpanAfter + $var_curCellRepeatAfter + 1"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="columnLeft">
					<xsl:value-of select="$ooMaxColumnNum - $var_curCellColumnNum - $var_curCellSpanAfter - $var_curCellRepeatAfter"/>
				</xsl:variable>
				<xsl:if test="$columnLeft &gt; 0">
					<xsl:element name="table:table-cell">
						<xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="$columnLeft"/></xsl:attribute>
					</xsl:element>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="OneTableRow">
		<xsl:param name="IsVirtual"/>
		<xsl:param name="nRepeatInclude"/>
		<xsl:param name="PageBreak"/>
		<xsl:param name="IsCollapse"/>
		<xsl:variable name="var_TableName">
			<xsl:choose>
				<xsl:when test="name(.)='表:工作表_E825'">
					<xsl:value-of select="@名称_E822"/>
				</xsl:when>
				<xsl:when test="name(.)='表:行_E7F1'">
					<xsl:value-of select="../../@名称_E822"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$IsVirtual = 'true'">
				<xsl:element name="table:table-row">
					<xsl:choose>
						<xsl:when test="$PageBreak != 'true'">
							<xsl:attribute name="table:style-name"><xsl:value-of select="concat('ro-default', $var_TableName)"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="table:style-name"><xsl:value-of select="concat('ro-default-page', $var_TableName)"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$nRepeatInclude &gt; 1">
						<xsl:attribute name="table:number-rows-repeated"><xsl:value-of select="$nRepeatInclude"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$IsCollapse = 'true'">
						<xsl:attribute name="table:visibility" select="'collapse'"/>
					</xsl:if>
					<xsl:element name="table:table-cell">
						<xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="$ooMaxColumnNum"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="table:table-row">
					<xsl:choose>
						<xsl:when test="$PageBreak != 'true'">
							<xsl:attribute name="table:style-name"><xsl:value-of select="concat('ro', generate-id())"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="table:style-name"><xsl:value-of select="concat('ro-page', generate-id())"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="@式样引用_E7BD">
							<xsl:attribute name="table:default-cell-style-name"><xsl:value-of select="@式样引用_E7BD"/></xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="$nRepeatInclude &gt; 1">
						<xsl:attribute name="table:number-rows-repeated"><xsl:value-of select="$nRepeatInclude"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$IsCollapse = 'true' or @是否隐藏_E73C = 'true'">
						<xsl:attribute name="table:visibility" select="'collapse'"/>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="*[name()='表:单元格_E7F2' or name() = '表:covered-table-cell']">
							<xsl:for-each select="*[1]">
								<xsl:call-template name="CreateRowCells"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="table:table-cell">
								<xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="$ooMaxColumnNum"/></xsl:attribute>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="表:行_E7F1" mode="table">
		<xsl:param name="curPos"/>
		<xsl:param name="lastPos"/>
		<xsl:param name="SpecialSet"/>
		<xsl:variable name="RowStart" select="@行号_E7F3"/>
		<xsl:variable name="RowEnd">
			<xsl:choose>
				<xsl:when test="@跨度_E7EF">
					<xsl:value-of select="number($RowStart) + number(@跨度_E7EF)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$RowStart"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="DisplayMode">
			<xsl:if test="@是否隐藏_E73C = 'true'">
				<xsl:value-of select="concat(' @table:display=', 'false')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$curPos = 1">
				<xsl:if test="$RowStart &gt; 1">
					<xsl:call-template name="GroupSet">
						<xsl:with-param name="IsVirtual" select="'true'"/>
						<xsl:with-param name="GroupType" select="'row'"/>
						<xsl:with-param name="SpecialSet" select="$SpecialSet"/>
						<xsl:with-param name="nStart" select="number('1')"/>
						<xsl:with-param name="nEnd" select="number($RowStart - 1)"/>
						<xsl:with-param name="DisplayMode" select="$DisplayMode"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="PrevRowStart" select="preceding-sibling::*[1]/@行号_E7F3"/>
				<xsl:variable name="PrevRowEnd">
					<xsl:choose>
						<xsl:when test="preceding-sibling::*[1]/@跨度_E7EF">
							<xsl:value-of select="number($PrevRowStart + preceding-sibling::*[1]/@跨度_E7EF)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$PrevRowStart"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="(number($PrevRowEnd) + 1) &lt; $RowStart">
					<xsl:call-template name="GroupSet">
						<xsl:with-param name="IsVirtual" select="'true'"/>
						<xsl:with-param name="GroupType" select="'row'"/>
						<xsl:with-param name="SpecialSet" select="$SpecialSet"/>
						<xsl:with-param name="nStart" select="number($PrevRowEnd + 1)"/>
						<xsl:with-param name="nEnd" select="number($RowStart - 1)"/>
						<xsl:with-param name="DisplayMode" select="$DisplayMode"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="GroupSet">
			<xsl:with-param name="IsVirtual" select="'false'"/>
			<xsl:with-param name="GroupType" select="'row'"/>
			<xsl:with-param name="SpecialSet" select="$SpecialSet"/>
			<xsl:with-param name="nStart" select="$RowStart"/>
			<xsl:with-param name="nEnd" select="$RowEnd"/>
			<xsl:with-param name="DisplayMode" select="$DisplayMode"/>
		</xsl:call-template>
		<xsl:if test="$curPos = $lastPos">
			<xsl:if test="$ooMaxRowNum &gt; $RowEnd">
				<xsl:call-template name="GroupSet">
					<xsl:with-param name="IsVirtual" select="'true'"/>
					<xsl:with-param name="GroupType" select="'row'"/>
					<xsl:with-param name="SpecialSet" select="$SpecialSet"/>
					<xsl:with-param name="nStart" select="$RowEnd + 1"/>
					<xsl:with-param name="nEnd" select="$ooMaxRowNum"/>
					<xsl:with-param name="DisplayMode" select="$DisplayMode"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="OneTableColumn">
		<xsl:param name="IsVirtual"/>
		<xsl:param name="nRepeatInclude"/>
		<xsl:param name="PageBreak"/>
		<xsl:param name="IsCollapse"/>
		<xsl:choose>
			<xsl:when test="$IsVirtual = 'true'">
				<xsl:variable name="var_TableName">
					<xsl:choose>
						<xsl:when test="name(.)='表:工作表_E825'">
							<xsl:value-of select="@名称_E822"/>
						</xsl:when>
						<xsl:when test="name(.)='表:列_E7EC'">
							<xsl:value-of select="../../@名称_E822"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="var_DefaultCellStyle">
					<xsl:choose>
						<xsl:when test="name(.)='表:工作表_E825'">
							<xsl:value-of select="@式样引用_E824"/>
						</xsl:when>
						<xsl:when test="name(.)='表:列_E7EC'">
							<xsl:value-of select="../../@式样引用_E824"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:element name="table:table-column">
					<xsl:choose>
						<xsl:when test="$PageBreak != 'true'">
							<xsl:attribute name="table:style-name"><xsl:value-of select="concat('co-default', $var_TableName)"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="table:style-name"><xsl:value-of select="concat('co-default-page',$var_TableName)"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="not($var_DefaultCellStyle = '')">
						<xsl:attribute name="table:default-cell-style-name"><xsl:value-of select="$var_DefaultCellStyle"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$IsCollapse = 'true'">
						<xsl:attribute name="table:visibility" select="'collapse'"/>
					</xsl:if>
					<xsl:if test="number($nRepeatInclude) &gt; 1">
						<xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="$nRepeatInclude"/></xsl:attribute>
					</xsl:if>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="table:table-column">
					<xsl:choose>
						<xsl:when test="$PageBreak != 'true'">
							<xsl:attribute name="table:style-name"><xsl:value-of select="concat('co', generate-id())"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="table:style-name"><xsl:value-of select="concat('co-page', generate-id())"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="@式样引用_E7BD">
							<xsl:attribute name="table:default-cell-style-name"><xsl:value-of select="@式样引用_E7BD"/></xsl:attribute>
						</xsl:when>
						<xsl:when test="../../@式样引用_E824">
							<xsl:attribute name="table:default-cell-style-name"><xsl:value-of select="../../@式样引用_E824"/></xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="number($nRepeatInclude) &gt; 1">
						<xsl:attribute name="table:number-columns-repeated"><xsl:value-of select="$nRepeatInclude"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$IsCollapse = 'true' or @是否隐藏_E73C = 'true'">
						<xsl:attribute name="table:visibility" select="'collapse'"/>
					</xsl:if>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="OneCreateElement">
		<xsl:param name="IsVirtual"/>
		<xsl:param name="GroupType"/>
		<xsl:param name="nRepeatAfter"/>
		<xsl:param name="PageBreak"/>
		<xsl:param name="IsCollapse"/>
		<xsl:choose>
			<xsl:when test="$GroupType = 'col'">
				<xsl:call-template name="OneTableColumn">
					<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
					<xsl:with-param name="nRepeatInclude" select="$nRepeatAfter+1"/>
					<xsl:with-param name="PageBreak" select="$PageBreak"/>
					<xsl:with-param name="IsCollapse" select="$IsCollapse"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$GroupType = 'row'">
				<xsl:call-template name="OneTableRow">
					<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
					<xsl:with-param name="nRepeatInclude" select="$nRepeatAfter+1"/>
					<xsl:with-param name="PageBreak" select="$PageBreak"/>
					<xsl:with-param name="IsCollapse" select="$IsCollapse"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GroupHalf">
		<xsl:param name="GroupType"/>
		<xsl:param name="GroupPos"/>
		<xsl:param name="DisplayMode"/>
		<xsl:choose>
			<xsl:when test="$GroupType = 'col'">
				<xsl:choose>
					<xsl:when test="$GroupPos = 'start'">
						<xsl:text disable-output-escaping="yes">&lt;table:table-column-group</xsl:text>
						<xsl:if test="$DisplayMode != ''">
							<xsl:text disable-output-escaping="yes"> table:display = </xsl:text>
							<xsl:text disable-output-escaping="yes">"</xsl:text>
							<xsl:value-of select="$DisplayMode"/>
							<xsl:text disable-output-escaping="yes">"</xsl:text>
						</xsl:if>
						<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
					</xsl:when>
					<xsl:when test="$GroupPos = 'end'">
						<xsl:text disable-output-escaping="yes">&lt;/table:table-column-group&gt;</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$GroupType = 'row'">
				<xsl:choose>
					<xsl:when test="$GroupPos = 'start'">
						<xsl:text disable-output-escaping="yes">&lt;table:table-row-group</xsl:text>
						<xsl:if test="$DisplayMode != ''">
							<xsl:text disable-output-escaping="yes"> table:display = </xsl:text>
							<xsl:text disable-output-escaping="yes">"</xsl:text>
							<xsl:value-of select="$DisplayMode"/>
							<xsl:text disable-output-escaping="yes">"</xsl:text>
						</xsl:if>
						<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
					</xsl:when>
					<xsl:when test="$GroupPos = 'end'">
						<xsl:text disable-output-escaping="yes">&lt;/table:table-row-group&gt;</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GroupSet">
		<xsl:param name="IsVirtual"/>
		<xsl:param name="GroupType"/>
		<xsl:param name="SpecialSet"/>
		<xsl:param name="nStart"/>
		<xsl:param name="nEnd"/>
		<xsl:param name="DisplayMode"/>
		<xsl:choose>
			<xsl:when test="count($SpecialSet/sGroup[not(number(nNumber) &lt; $nStart) and not($nEnd &lt; number(nNumber))]) &gt; 0">
				<xsl:variable name="CurNode" select="."/>
				<xsl:for-each select="$SpecialSet/sGroup[not(number(nNumber) &lt; $nStart) and not($nEnd &lt; number(nNumber))]">
					<xsl:variable name="var_PreIsCollapse">
						<xsl:if test="preceding-sibling::node()[1]/text() = 'iscollapse'">true</xsl:if>
					</xsl:variable>
					<xsl:variable name="var_NextIsCollapse">
						<xsl:if test="following-sibling::node()[1]/text() = 'iscollapse'">true</xsl:if>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="sType = 'pagebreak'">
							<xsl:choose>
								<!--首先考虑给定的区间只有一个行或列的情况-->
								<xsl:when test="$nStart = $nEnd">
									<!--如果给定区间内只有一个sGroup元素，也就是没有组起始截止符的情况-->
									<xsl:if test="position() = last()">
										<xsl:for-each select="$CurNode">
											<xsl:choose>
												<xsl:when test="$SpecialSet/sGroup/nNumber = @列号_E7ED or $SpecialSet/sGroup/nNumber = @行号_E7F3">
													<xsl:call-template name="OneCreateElement">
														<xsl:with-param name="IsVirtual" select="'true'"/>
														<xsl:with-param name="GroupType" select="$GroupType"/>
														<xsl:with-param name="nRepeatAfter" select="0"/>
														<xsl:with-param name="PageBreak" select="'true'"/>
														<xsl:with-param name="IsCollapse" select="$var_PreIsCollapse"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="OneCreateElement">
														<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
														<xsl:with-param name="GroupType" select="$GroupType"/>
														<xsl:with-param name="nRepeatAfter" select="0"/>
														<xsl:with-param name="PageBreak" select="'true'"/>
														<xsl:with-param name="IsCollapse" select="$var_PreIsCollapse"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
											<!--xsl:call-template name="OneCreateElement">
												<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
												<xsl:with-param name="GroupType" select="$GroupType"/>
												<xsl:with-param name="nRepeatAfter" select="0"/>
												<xsl:with-param name="PageBreak" select="'true'"/>
												<xsl:with-param name="IsCollapse" select="$var_PreIsCollapse"/>
											</xsl:call-template-->
										</xsl:for-each>
									</xsl:if>
									<!--给定区间只有一个行或列，但区间内内有多个元素的情况会在后面一起处理-->
								</xsl:when>
								<xsl:otherwise>
									<!--当前的pagebreak元素是给定区间内的第一个sGroup元素-->
									<!--这里好像逻辑上有些漏洞，因为可能出现在同一个行或列上既有pagebreak信息，又有分组信息的情况，这时候是否能保证分组信息一定排在pagebreak前面？这依赖于xslt内部的实现逻辑-->
									<xsl:if test="position() = 1">
										<!--这里处理了pagebreak元素之前的行或列-->
										<xsl:if test="not(nNumber &lt; $nStart)">
											<xsl:variable name="nRepeatAfter">
												<xsl:value-of select="nNumber - $nStart - 1"/>
											</xsl:variable>
											<xsl:for-each select="$CurNode">
												<xsl:if test="number($nRepeatAfter) ge 1">
													<xsl:call-template name="OneCreateElement">
														<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
														<xsl:with-param name="GroupType" select="$GroupType"/>
														<xsl:with-param name="nRepeatAfter" select="$nRepeatAfter"/>
														<xsl:with-param name="IsCollapse" select="$var_PreIsCollapse"/>
													</xsl:call-template>
												</xsl:if>
												<xsl:call-template name="OneCreateElement">
													<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
													<xsl:with-param name="GroupType" select="$GroupType"/>
													<xsl:with-param name="nRepeatAfter" select="0"/>
													<xsl:with-param name="PageBreak" select="'true'"/>
													<xsl:with-param name="IsCollapse" select="$var_PreIsCollapse"/>
												</xsl:call-template>
											</xsl:for-each>
										</xsl:if>
									</xsl:if>
									<!--在给定的区间里，当前pagebreak元素之前还有分组信息或pagebreak元素-->
									<xsl:if test="position() != 1">
										<!--当前pagebreak元素不在给定区间的起始位置，并且当前pagebreak元素的上一个元素与当前元素不在同一个行或列-->
										<xsl:if test="(nNumber &gt; $nStart) and (preceding-sibling::*[1]/nNumber != nNumber)">
											<xsl:variable name="nRepeatAfter">
												<xsl:choose>
													<!--这句话的逻辑好像是错的，因为跟前面的 <xsl:if test="position() != 1">冲突-->
													<xsl:when test="not(preceding-sibling::*[1])">
														<xsl:value-of select="nNumber - $nStart - 1"/>
													</xsl:when>
													<!--当前pagebreak元素的上一个元素不在给定的区间内-->
													<xsl:when test="preceding-sibling::*[1] &lt; $nStart">
														<xsl:value-of select="nNumber - $nStart - 1"/>
													</xsl:when>
													<!--在给定的区间里，当前pagebreak元素之前还有分组信息或pagebreak元素，且这些元素与当前元素不在同一个行或列-->
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="preceding-sibling::*[1]/sType = 'end'">
																<xsl:value-of select="nNumber - preceding-sibling::sGroup[1]/nNumber - 1 - 1"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="nNumber - preceding-sibling::sGroup[1]/nNumber - 1"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:for-each select="$CurNode">
												<xsl:call-template name="OneCreateElement">
													<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
													<xsl:with-param name="GroupType" select="$GroupType"/>
													<xsl:with-param name="nRepeatAfter" select="0"/>
													<xsl:with-param name="PageBreak" select="'true'"/>
													<xsl:with-param name="IsCollapse" select="$var_NextIsCollapse"/>
												</xsl:call-template>
												<xsl:if test="number($nRepeatAfter) ge 1">
													<xsl:call-template name="OneCreateElement">
														<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
														<xsl:with-param name="GroupType" select="$GroupType"/>
														<xsl:with-param name="nRepeatAfter" select="$nRepeatAfter"/>
														<xsl:with-param name="IsCollapse" select="$var_NextIsCollapse"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
									</xsl:if>
									<!--给定区间内只有当前pagebreak元素这一个sGroup元素,这个条件与前面的<xsl:if test="position() = 1">条件是共同起作用的-->
									<xsl:if test="position() = last()">
										<xsl:variable name="nRepeatAfter">
											<xsl:value-of select="$nEnd - ( number($nStart) + 1)"/>
										</xsl:variable>
										<xsl:for-each select="$CurNode">
											<xsl:call-template name="OneCreateElement">
												<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
												<xsl:with-param name="GroupType" select="$GroupType"/>
												<xsl:with-param name="nRepeatAfter" select="$nRepeatAfter"/>
												<xsl:with-param name="IsCollapse" select="$var_NextIsCollapse"/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<!--首先考虑给定的区间只有一个行或列的情况-->
								<xsl:when test="$nStart = $nEnd">
									<xsl:choose>
										<xsl:when test="sType = 'start'">
											<xsl:call-template name="GroupHalf">
												<xsl:with-param name="GroupType" select="$GroupType"/>
												<xsl:with-param name="GroupPos" select="sType"/>
												<xsl:with-param name="DisplayMode" select="sDisplay"/>
											</xsl:call-template>
											<xsl:if test="position() = last()">
												<xsl:for-each select="$CurNode">
													<xsl:call-template name="OneCreateElement">
														<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
														<xsl:with-param name="GroupType" select="$GroupType"/>
														<xsl:with-param name="nRepeatAfter" select="0"/>
														<xsl:with-param name="IsCollapse" select="$var_NextIsCollapse"/>
													</xsl:call-template>
												</xsl:for-each>
											</xsl:if>
										</xsl:when>
										<xsl:when test="sType = 'end'">
											<xsl:if test="position() = 1">
												<xsl:for-each select="$CurNode">
													<xsl:call-template name="OneCreateElement">
														<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
														<xsl:with-param name="GroupType" select="$GroupType"/>
														<xsl:with-param name="nRepeatAfter" select="0"/>
														<xsl:with-param name="IsCollapse" select="$var_PreIsCollapse"/>
													</xsl:call-template>
												</xsl:for-each>
											</xsl:if>
											<xsl:call-template name="GroupHalf">
												<xsl:with-param name="GroupType" select="$GroupType"/>
												<xsl:with-param name="GroupPos" select="sType"/>
												<xsl:with-param name="DisplayMode" select="sDisplay"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								<!--其次考虑区间有多个行列的情况-->
								<xsl:otherwise>
									<xsl:if test="position() = 1">
										<xsl:if test="nNumber &gt; $nStart">
											<xsl:variable name="curPos">
												<xsl:choose>
													<xsl:when test="sType = 'start'">
														<xsl:value-of select="nNumber"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="nNumber + 1"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="nRepeatAfter">
												<xsl:value-of select="$curPos -1 - $nStart"/>
											</xsl:variable>
											<xsl:for-each select="$CurNode">
												<xsl:call-template name="OneCreateElement">
													<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
													<xsl:with-param name="GroupType" select="$GroupType"/>
													<xsl:with-param name="nRepeatAfter" select="$nRepeatAfter"/>
													<xsl:with-param name="IsCollapse" select="$var_PreIsCollapse"/>
												</xsl:call-template>
											</xsl:for-each>
										</xsl:if>
									</xsl:if>
									<xsl:if test="position() != 1">
										<xsl:if test="(nNumber &gt; $nStart) and (preceding-sibling::sGroup[1]/nNumber != nNumber)">
											<xsl:variable name="curPos">
												<xsl:choose>
													<xsl:when test="sType = 'start'">
														<xsl:value-of select="nNumber"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="nNumber + 1"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="nRepeatAfter">
												<xsl:choose>
													<xsl:when test="not(preceding-sibling::*[1])">
														<xsl:value-of select="$curPos -1 - $nStart"/>
													</xsl:when>
													<xsl:when test="preceding-sibling::*[1]/nNumber &lt; $nStart">
														<xsl:value-of select="$curPos -1 - $nStart"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="preceding-sibling::*[1]/sType = 'end'">
																<xsl:value-of select="$curPos -1 - preceding-sibling::sGroup[1]/nNumber - 1"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$curPos -1 - preceding-sibling::sGroup[1]/nNumber"/>
															</xsl:otherwise>
														</xsl:choose>
														<!--<xsl:value-of select="$curPos - preceding-sibling::node()[1]/nNumber"/>-->
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:for-each select="$CurNode">
												<xsl:call-template name="OneCreateElement">
													<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
													<xsl:with-param name="GroupType" select="$GroupType"/>
													<xsl:with-param name="nRepeatAfter" select="$nRepeatAfter"/>
													<xsl:with-param name="IsCollapse" select="$var_PreIsCollapse"/>
												</xsl:call-template>
											</xsl:for-each>
										</xsl:if>
									</xsl:if>
									<xsl:call-template name="GroupHalf">
										<xsl:with-param name="GroupType" select="$GroupType"/>
										<xsl:with-param name="GroupPos" select="sType"/>
										<xsl:with-param name="DisplayMode" select="sDisplay"/>
									</xsl:call-template>
									<xsl:if test="position() = last()">
										<xsl:choose>
											<xsl:when test="nNumber = $nEnd">
												<xsl:if test="sType = 'start'">
													<xsl:for-each select="$CurNode">
														<xsl:call-template name="OneCreateElement">
															<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
															<xsl:with-param name="GroupType" select="$GroupType"/>
															<xsl:with-param name="nRepeatAfter" select="0"/>
															<xsl:with-param name="IsCollapse" select="$var_NextIsCollapse"/>
														</xsl:call-template>
													</xsl:for-each>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:variable name="curPos">
													<xsl:choose>
														<xsl:when test="sType = 'start'">
															<xsl:value-of select="nNumber"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="nNumber + 1"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<xsl:variable name="nRepeatAfter">
													<xsl:value-of select="$nEnd - $curPos"/>
												</xsl:variable>
												<xsl:for-each select="$CurNode">
													<xsl:call-template name="OneCreateElement">
														<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
														<xsl:with-param name="GroupType" select="$GroupType"/>
														<xsl:with-param name="nRepeatAfter" select="$nRepeatAfter"/>
														<xsl:with-param name="IsCollapse" select="$var_NextIsCollapse"/>
													</xsl:call-template>
												</xsl:for-each>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="var_IsCollapse">
					<xsl:if test="$SpecialSet/sGroup[number(nNumber) gt number($nEnd)] and $SpecialSet/sGroup[number(nNumber) lt number($nStart)]">
						<xsl:for-each select="$SpecialSet/sGroup[number(nNumber) gt number($nEnd)][1]">
							<xsl:if test="preceding-sibling::node()[1]/text() ='iscollapse'">
								<xsl:value-of select="'true'"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="nRepeatAfter">
					<xsl:value-of select="number($nEnd - $nStart)"/>
				</xsl:variable>
				<xsl:call-template name="OneCreateElement">
					<xsl:with-param name="IsVirtual" select="$IsVirtual"/>
					<xsl:with-param name="GroupType" select="$GroupType"/>
					<xsl:with-param name="nRepeatAfter" select="$nRepeatAfter"/>
					<xsl:with-param name="IsCollapse" select="$var_IsCollapse"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="表:列_E7EC" mode="table">
		<xsl:param name="curPos"/>
		<xsl:param name="lastPos"/>
		<xsl:param name="SpecialSet"/>
		<xsl:variable name="ColStart" select="number(@列号_E7ED)"/>
		<xsl:variable name="ColEnd">
			<xsl:choose>
				<xsl:when test="@跨度_E7EF">
					<xsl:value-of select="number($ColStart + @跨度_E7EF)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number($ColStart)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="DisplayMode">
			<xsl:if test="@是否隐藏_E73C = 'true'">
				<xsl:value-of select="concat(' @table:display=', 'false')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$curPos = 1">
				<xsl:if test="$ColStart &gt; 1">
					<xsl:call-template name="GroupSet">
						<xsl:with-param name="IsVirtual" select="'true'"/>
						<xsl:with-param name="GroupType" select="'col'"/>
						<xsl:with-param name="SpecialSet" select="$SpecialSet"/>
						<xsl:with-param name="nStart" select="number('1')"/>
						<xsl:with-param name="nEnd" select="number($ColStart - 1)"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="PrevColStart" select="preceding-sibling::*[1]/@列号_E7ED"/>
				<xsl:variable name="PrevColEnd">
					<xsl:choose>
						<xsl:when test="preceding-sibling::*[1]/@跨度_E7EF">
							<xsl:value-of select="number($PrevColStart + preceding-sibling::*[1]/@跨度_E7EF)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$PrevColStart"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="number($PrevColEnd + 1) &lt; $ColStart">
					<xsl:call-template name="GroupSet">
						<xsl:with-param name="IsVirtual" select="'true'"/>
						<xsl:with-param name="GroupType" select="'col'"/>
						<xsl:with-param name="SpecialSet" select="$SpecialSet"/>
						<xsl:with-param name="nStart" select="number($PrevColEnd + 1)"/>
						<xsl:with-param name="nEnd" select="number($ColStart - 1)"/>
						<xsl:with-param name="DisplayMode" select="$DisplayMode"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="GroupSet">
			<xsl:with-param name="IsVirtual" select="'false'"/>
			<xsl:with-param name="GroupType" select="'col'"/>
			<xsl:with-param name="SpecialSet" select="$SpecialSet"/>
			<xsl:with-param name="nStart" select="$ColStart"/>
			<xsl:with-param name="nEnd" select="$ColEnd"/>
			<xsl:with-param name="DisplayMode" select="$DisplayMode"/>
		</xsl:call-template>
		<xsl:if test="$curPos = $lastPos">
			<xsl:if test="$ooMaxColumnNum &gt; $ColEnd">
				<xsl:call-template name="GroupSet">
					<xsl:with-param name="IsVirtual" select="'true'"/>
					<xsl:with-param name="GroupType" select="'col'"/>
					<xsl:with-param name="SpecialSet" select="$SpecialSet"/>
					<xsl:with-param name="nStart" select="$ColEnd + 1"/>
					<xsl:with-param name="nEnd" select="$ooMaxColumnNum"/>
					<xsl:with-param name="DisplayMode" select="$DisplayMode"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="NoColumnProcess">
		<xsl:param name="SpecialSet"/>
		<xsl:variable name="ColStart" select="1"/>
		<xsl:call-template name="GroupSet">
			<xsl:with-param name="IsVirtual" select="'true'"/>
			<xsl:with-param name="GroupType" select="'col'"/>
			<xsl:with-param name="SpecialSet" select="$SpecialSet"/>
			<xsl:with-param name="nStart" select="$ColStart"/>
			<xsl:with-param name="nEnd" select="$ooMaxColumnNum"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="NoRowProcess">
		<xsl:param name="SpecialSet"/>
		<xsl:variable name="RowStart" select="1"/>
		<xsl:call-template name="GroupSet">
			<xsl:with-param name="IsVirtual" select="'true'"/>
			<xsl:with-param name="GroupType" select="'row'"/>
			<xsl:with-param name="SpecialSet" select="$SpecialSet"/>
			<xsl:with-param name="nStart" select="$RowStart"/>
			<xsl:with-param name="nEnd" select="$ooMaxRowNum"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="TableSheet">
		<xsl:element name="table:table">
			<xsl:attribute name="table:name"><xsl:value-of select="@名称_E822"/></xsl:attribute>
			<xsl:attribute name="table:style-name"><xsl:value-of select="concat('ta', generate-id(.))"/></xsl:attribute>
			<!--xsl:if test="表:工作表内容_E80E/uof:锚点_C644 or 表:工作表内容_E80E/表:行_E7F1/表:单元格_E7F2/uof:锚点_C644"-->
			<xsl:if test="表:工作表内容_E80E/uof:锚点_C644">
				<table:shapes>
					<xsl:for-each select="表:工作表内容_E80E/uof:锚点_C644">
						<xsl:apply-templates select="." mode="table"/>
					</xsl:for-each>
				</table:shapes>
			</xsl:if>
			<xsl:if test="表:工作表内容_E80E">
				<xsl:variable name="SpecialColumnSet">
					<xsl:variable name="tmp">
						<xsl:for-each select="表:工作表内容_E80E/表:分组集_E7F6/表:列_E841">
							<sGroup>
								<sType>start</sType>
								<sDisplay>
									<xsl:choose>
										<xsl:when test="@是否隐藏_E73C = 'true'">false</xsl:when>
										<xsl:when test="@是否隐藏_E73C = 'false'">true</xsl:when>
									</xsl:choose>
								</sDisplay>
								<nNumber>
									<xsl:value-of select="@起始_E73A"/>
								</nNumber>
							</sGroup>
							<sGroup>
								<sType>end</sType>
								<nNumber>
									<xsl:value-of select="@终止_E73B"/>
								</nNumber>
							</sGroup>
						</xsl:for-each>
						<xsl:for-each select="表:分页符集_E81E/表:分页符_E81F[@列号_E821]">
							<sGroup>
								<sType>pagebreak</sType>
								<nNumber>
									<xsl:value-of select="@列号_E821 + 1"/>
								</nNumber>
							</sGroup>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="collapseArea">
						<xsl:for-each select="表:工作表内容_E80E/表:分组集_E7F6/表:列_E841">
							<xsl:if test="@是否隐藏_E73C = 'true'">
								<xsl:copy-of select="."/>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:for-each select="$tmp/sGroup">
						<xsl:sort select="nNumber" data-type="number"/>
						<xsl:copy-of select="."/>
						<xsl:variable name="var_number" select="number(nNumber/text())"/>
						<xsl:choose>
							<xsl:when test="sType = 'start' or sType = 'pagebreak'">
								<xsl:if test="$collapseArea/表:列_E7EC[@是否隐藏_E73C = 'true'][number(@起始_E73A) le $var_number and number(@终止_E73B) ge $var_number]">
									<sElement>iscollapse</sElement>
								</xsl:if>
							</xsl:when>
							<xsl:when test="sType = 'end'">
								<xsl:if test="$collapseArea/表:列_E7EC[@是否隐藏_E73C = 'true'][number(@起始_E73A) le $var_number and number(@终止_E73B) gt $var_number]">
									<sElement>iscollapse</sElement>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="SpecialRowSet">
					<xsl:variable name="tmp">
						<xsl:for-each select="表:工作表内容_E80E/表:分组集_E7F6/表:行_E842">
							<sGroup>
								<sType>start</sType>
								<sDisplay>
									<xsl:choose>
										<xsl:when test="@是否隐藏_E73C = 'true'">false</xsl:when>
										<xsl:when test="@是否隐藏_E73C = 'false'">true</xsl:when>
									</xsl:choose>
								</sDisplay>
								<nNumber>
									<xsl:value-of select="@起始_E73A"/>
								</nNumber>
							</sGroup>
							<sGroup>
								<sType>end</sType>
								<nNumber>
									<xsl:value-of select="@终止_E73B"/>
								</nNumber>
							</sGroup>
						</xsl:for-each>
						<xsl:for-each select="表:分页符集_E81E/表:分页符_E81F[@行号_E820]">
							<sGroup>
								<sType>pagebreak</sType>
								<nNumber>
									<xsl:value-of select="@行号_E820 + 1"/>
								</nNumber>
							</sGroup>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="collapseArea">
						<xsl:for-each select="表:工作表内容_E80E/表:分组集_E7F6/表:行_E842">
							<xsl:if test="@是否隐藏_E73C = 'true'">
								<xsl:copy-of select="."/>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:for-each select="$tmp/sGroup">
						<xsl:sort select="nNumber" data-type="number"/>
						<xsl:copy-of select="."/>
						<xsl:variable name="var_number" select="number(nNumber/text())"/>
						<xsl:choose>
							<xsl:when test="sType = 'start' or sType = 'pagebreak'">
								<xsl:if test="$collapseArea/表:行_E7F1[@是否隐藏_E73C = 'true'][number(@起始_E73A) le $var_number and number(@终止_E73B) ge $var_number]">
									<sElement>iscollapse</sElement>
								</xsl:if>
							</xsl:when>
							<xsl:when test="sType = 'end'">
								<xsl:if test="$collapseArea/表:行_E7F1[@是否隐藏_E73C = 'true'][number(@起始_E73A) le $var_number and number(@终止_E73B) gt $var_number]">
									<sElement>iscollapse</sElement>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="表:工作表内容_E80E/表:列_E7EC">
						<xsl:for-each select="表:工作表内容_E80E/表:列_E7EC">
							<xsl:apply-templates select="." mode="table">
								<xsl:with-param name="curPos" select="position()"/>
								<xsl:with-param name="lastPos" select="last()"/>
								<xsl:with-param name="SpecialSet" select="$SpecialColumnSet"/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="NoColumnProcess">
							<xsl:with-param name="SpecialSet" select="$SpecialColumnSet"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="表:工作表内容_E80E/表:行_E7F1">
						<xsl:for-each select="表:工作表内容_E80E/表:行_E7F1">
							<xsl:sort data-type="number" select="@行号_E7F3"/>
							<xsl:apply-templates select="." mode="table">
								<xsl:with-param name="curPos" select="position()"/>
								<xsl:with-param name="lastPos" select="last()"/>
								<xsl:with-param name="SpecialSet" select="$SpecialRowSet"/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="NoRowProcess">
							<xsl:with-param name="SpecialSet" select="$SpecialRowSet"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template match="表:操作条件_E815">
		<xsl:element name="table:filter-condition">
			<xsl:variable name="ope" select="表:操作码_E816"/>
			<xsl:variable name="conditionArea">
				<xsl:call-template name="character-to-number">
					<xsl:with-param name="character" select="substring-before(substring-after(../../../表:范围_E810,'$'),'$')"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:attribute name="table:field-number"><xsl:value-of select="number(../../@列号_E819) - 1"/></xsl:attribute>
			<xsl:attribute name="table:value"><xsl:value-of select="表:值_E817"/></xsl:attribute>
			<xsl:attribute name="table:operator"><xsl:choose><xsl:when test="$ope = 'equal to'">=</xsl:when><xsl:when test="$ope = 'not equal to'">!=</xsl:when><xsl:when test="$ope = 'greater than'">&gt;</xsl:when><xsl:when test="$ope = 'greater than or equal to'">&gt;=</xsl:when><xsl:when test="$ope = 'less than'">&lt;</xsl:when><xsl:when test="$ope = 'less than or equal to'">&lt;=</xsl:when><xsl:when test="$ope = 'start with'">begins-with</xsl:when><xsl:when test="$ope = 'not start with'">does-not-begin-with</xsl:when><xsl:when test="$ope = 'end with'">ends-with</xsl:when><xsl:when test="$ope = 'not end with'">does-not-end-with</xsl:when><xsl:when test="$ope = 'contain' or $ope = 'between'">contains</xsl:when><xsl:when test="$ope = 'not contain' or $ope = 'between'">does-not-contain</xsl:when><xsl:otherwise/></xsl:choose></xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template name="getDataRange">
		<xsl:variable name="first">
			<xsl:value-of select="表:范围_E810"/>
		</xsl:variable>
		<xsl:variable name="quote">'</xsl:variable>
		<xsl:variable name="tempTableName">
			<xsl:value-of select="substring-after(substring-before($first,'!'), $quote)"/>
		</xsl:variable>
		<xsl:variable name="tableName">
			<xsl:value-of select="substring-before($tempTableName, $quote)"/>
		</xsl:variable>
		<xsl:variable name="firstTempAddress">
			<xsl:value-of select="substring-after(substring-before($first,':'),'!')"/>
		</xsl:variable>
		<xsl:variable name="firstHorizonAddress">
			<xsl:value-of select="substring-before(substring-after($firstTempAddress,'$'),'$')"/>
		</xsl:variable>
		<xsl:variable name="firstVerticalAddress">
			<xsl:value-of select="substring-after(substring-after($firstTempAddress,'$'),'$')"/>
		</xsl:variable>
		<xsl:variable name="secondTempAddress">
			<xsl:value-of select="substring-after($first,':')"/>
		</xsl:variable>
		<xsl:variable name="secondHorizonAddress">
			<xsl:value-of select="substring-before(substring-after($secondTempAddress,'$'),'$')"/>
		</xsl:variable>
		<xsl:variable name="secondVerticalAddress">
			<xsl:value-of select="substring-after(substring-after($secondTempAddress,'$'),'$')"/>
		</xsl:variable>
		<xsl:value-of select="concat($tableName,'.',$firstHorizonAddress,$firstVerticalAddress,':',$tableName,'.',$secondHorizonAddress,$secondVerticalAddress)"/>
	</xsl:template>
	<xsl:template match="表:筛选_E80F">
		<xsl:element name="table:database-range">
			<xsl:if test="@类型_E83B = 'auto'">
				<xsl:attribute name="table:display-filter-buttons">true</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="table:target-range-address"><xsl:call-template name="getDataRange"/></xsl:attribute>
			<xsl:if test="表:条件_E811">
				<table:filter>
					<xsl:if test="表:条件区域_E81A">
						<xsl:attribute name="table:condition-source-range-address"><xsl:value-of select="表:条件区域_E81A"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="表:结果区域_E81B">
						<xsl:attribute name="table:display-duplicates"><xsl:value-of select="表:结果区域_E81B"/></xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="表:条件_E811/表:普通_E812">
							<xsl:element name="table:filter-condition">
								<xsl:variable name="opea" select="表:条件_E811/表:普通_E812/@类型_E7B6"/>
								<xsl:attribute name="table:field-number" select="number(表:条件_E811/@列号_E819) - 1"/>
								<xsl:attribute name="table:value" select="表:条件_E811/表:普通_E812/@值_E813"/>
								<xsl:attribute name="table:operator"><xsl:choose><xsl:when test="$opea = 'bottomitem'">bottom values</xsl:when><xsl:when test="$opea = 'bottompercent'">bottom percent</xsl:when><xsl:when test="$opea = 'topitem'">top values</xsl:when><xsl:when test="$opea = 'toppercent'">top percent</xsl:when><xsl:when test="$opea = 'value'">=</xsl:when><xsl:otherwise/></xsl:choose></xsl:attribute>
							</xsl:element>
						</xsl:when>
						<xsl:when test="表:条件_E811/表:自定义_E814/@类型_E7B6 = 'or'">
							<xsl:element name="table:filter-or">
								<xsl:for-each select="表:条件_E811/表:自定义_E814/表:操作条件_E815">
									<xsl:apply-templates select="."/>
								</xsl:for-each>
							</xsl:element>
						</xsl:when>
						<xsl:when test="表:条件_E811/表:自定义_E814/@类型_E7B6 = 'and'">
							<xsl:element name="table:filter-and">
								<xsl:for-each select="表:条件_E811/表:自定义_E814/表:操作条件_E815">
									<xsl:apply-templates select="."/>
								</xsl:for-each>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="表:条件_E811/表:自定义_E814/表:操作条件_E815">
								<xsl:apply-templates select="."/>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</table:filter>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="uof:链接集" mode="table">
		<table:named-expressions>
			<xsl:for-each select="uof:超级链接">
				<xsl:if test="@uof:目标 and @uof:书签">
					<xsl:variable name="var_TagetUrl">
						<xsl:choose>
							<xsl:when test="@uof:目标 = @uof:书签">
								<xsl:if test="key('bookmark', @uof:书签)/uof:命名表达式/@uof:区域引用">
									<xsl:value-of select="key('bookmark', @uof:书签)/uof:命名表达式/@uof:区域引用"/>											
								</xsl:if>								
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@uof:目标"/>								
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="var_Name">
						<xsl:value-of select="@uof:书签"/>
					</xsl:variable>
					<xsl:analyze-string select="$var_TagetUrl" regex="=?'?(.*?)'?!\$?([A-Z,a-z]{{1,2}})\$?(\d+)">
						<xsl:matching-substring>
							<xsl:variable name="apos">&apos;</xsl:variable>
							<table:named-range>
								<xsl:attribute name ='table:name'>
									<xsl:value-of select="$var_Name"/>
								</xsl:attribute>
								<xsl:attribute name="table:base-cell-address">
									<xsl:value-of select="concat( '$', regex-group(1), '.', '$', regex-group(2), '$', regex-group(3)) "/>
								</xsl:attribute>
								<xsl:attribute name="table:cell-range-address">
									<xsl:value-of select="concat( '$', regex-group(1), '.', '$', regex-group(2), '$', regex-group(3)) "/>
								</xsl:attribute>
							</table:named-range>
						</xsl:matching-substring>
					</xsl:analyze-string>
				</xsl:if>
			</xsl:for-each>	
		</table:named-expressions>	
	</xsl:template>
	-->
	<xsl:template match="书签:书签集_9104" mode="table">
		<table:named-expressions>
			<xsl:for-each select="书签:书签_9105">
				<xsl:variable name="var_BookmarkName" select="@名称_9103"/>
				<xsl:if test="书签:区域_9100/@区域引用_41CE">
					<xsl:analyze-string select="书签:区域_9100/@区域引用_41CE" regex="=?'?(.*?)'?!\$?([A-Z,a-z]{{0,3}})\$?(\d*)(:?)\$?([A-Z,a-z]{{0,3}})\$?(\d*)">
						<xsl:matching-substring>
							<table:named-range>
								<xsl:attribute name="table:name" select="$var_BookmarkName"/>
								<xsl:variable name="tablename" select="regex-group(1)"/>
								<xsl:variable name="UOFbeginColum" select="regex-group(2)"/>
								<xsl:variable name="UOFbeginRow" select="regex-group(3)"/>
								<xsl:variable name="breakChar" select="regex-group(4)"/>
								<xsl:variable name="UOFendColum" select="regex-group(5)"/>
								<xsl:variable name="UOFendRow" select="regex-group(6)"/>
								<xsl:variable name="ODFbeginColum">
									<xsl:choose>
										<xsl:when test="$UOFbeginColum = ''">A</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$UOFbeginColum"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="ODFbeginRow">
									<xsl:choose>
										<xsl:when test="$UOFbeginRow = ''">1</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$UOFbeginRow"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="ODFendColum">
									<xsl:choose>
										<xsl:when test="$UOFendColum = ''">AMJ</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$UOFendColum"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="ODFendRow">
									<xsl:choose>
										<xsl:when test="$UOFendRow = ''">65536</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$UOFendRow"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$breakChar = ''">
										<xsl:attribute name="table:base-cell-address" select="concat($tablename, '.', '$', $ODFbeginColum, '$', $ODFbeginRow)"/>
										<xsl:attribute name="table:cell-range-address" select="concat($tablename, '.', '$', $ODFbeginColum, '$', $ODFbeginRow)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="table:base-cell-address" select="concat($tablename, '.', '$', $ODFbeginColum, '$', $ODFbeginRow)"/>
										<xsl:attribute name="table:cell-range-address" select="concat($tablename, '.', '$', $ODFbeginColum, '$', $ODFbeginRow, ':.', '$', $ODFendColum, '$', $ODFendRow)"/>
									</xsl:otherwise>
								</xsl:choose>
							</table:named-range>
						</xsl:matching-substring>
					</xsl:analyze-string>
				</xsl:if>
			</xsl:for-each>
		</table:named-expressions>
	</xsl:template>
	<xsl:template name="OfficeSettingsPresentation">
		<config:config-item-set config:name="ooo:view-settings">
			<config:config-item config:name="VisibleAreaTop" config:type="int">0</config:config-item>
			<config:config-item config:name="VisibleAreaLeft" config:type="int">0</config:config-item>
			<config:config-item config:name="VisibleAreaWidth" config:type="int">14098</config:config-item>
			<config:config-item config:name="VisibleAreaHeight" config:type="int">9998</config:config-item>
			<config:config-item-map-indexed config:name="Views">
				<config:config-item-map-entry>
					<config:config-item config:name="IsSnapToSnapLines" config:type="boolean">true</config:config-item>
					<xsl:for-each select="规则:公用处理规则_B665/规则:演示文稿_B66D/规则:最后视图_B639">
						<xsl:variable name="PageKind">
							<xsl:value-of select="规则:类型_B63A"/>
						</xsl:variable>
						<config:config-item config:name="PageKind" config:type="short">
							<xsl:choose>
								<xsl:when test="$PageKind='normal' or $PageKind='sort'">0</xsl:when>
								<xsl:when test="$PageKind='note-page'">1</xsl:when>
								<xsl:when test="$PageKind='note-master'">1</xsl:when>
								<xsl:when test="$PageKind='handout-master'">2</xsl:when>
							</xsl:choose>
						</config:config-item>
						<config:config-item config:name="EditModeStandard" config:type="int">
							<xsl:choose>
								<xsl:when test="$PageKind='slide-master'">1</xsl:when>
								<xsl:when test="$PageKind='note-master'">0</xsl:when>
								<xsl:when test="$PageKind='normal'">0</xsl:when>
							</xsl:choose>
						</config:config-item>
						<config:config-item config:name="EditModeNotes" config:type="int">
							<xsl:choose>
								<xsl:when test="$PageKind='note-page'">0</xsl:when>
								<xsl:when test="$PageKind='note-master'">1</xsl:when>
							</xsl:choose>
						</config:config-item>
						<config:config-item config:name="ViewId" config:type="string">
							<xsl:choose>
								<xsl:when test="$PageKind='normal' or $PageKind='handout-master' or $PageKind='note-page'">view1</xsl:when>
								<xsl:when test="$PageKind='sort'">view2</xsl:when>
							</xsl:choose>
						</config:config-item>
					</xsl:for-each>
					<xsl:apply-templates select="/uof:UOF_0000/扩展:扩展区_B200/扩展:扩展_B201[扩展:软件名称_B202= 'NeoShineOffice']/扩展:扩展内容_B204[扩展:路径 = '/office:document/office:settings']/uof:内容/配置/分类配置项集[@类属 = '视图配置']/配置项索引表[@名称 = '视图']/配置列表条目" mode="Views"/>
				</config:config-item-map-entry>
			</config:config-item-map-indexed>
		</config:config-item-set>
		<config:config-item-set config:name="ooo:configuration-settings">
			<config:config-item config:name="PageNumberFormat" config:type="int">
				<xsl:choose>
					<xsl:when test="规则:公用处理规则_B665/规则:演示文稿_B66D/规则:页面设置集_B670/规则:页面设置_B638/演:页码格式_6BDF[1]">
						<xsl:variable name="pageNumberFormat" select="规则:公用处理规则_B665/规则:演示文稿_B66D/规则:页面设置集_B670/规则:页面设置_B638/演:页码格式_6BDF[1]"/>
						<xsl:choose>
							<xsl:when test="$pageNumberFormat='upper-letter'">0</xsl:when>
							<xsl:when test="$pageNumberFormat='lower-letter'">1</xsl:when>
							<xsl:when test="$pageNumberFormat='upper-roman'">2</xsl:when>
							<xsl:when test="$pageNumberFormat='lower-roman'">3</xsl:when>
							<xsl:when test="$pageNumberFormat='decimal'">4</xsl:when>
							<xsl:otherwise>5</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>5</xsl:otherwise>
				</xsl:choose>
			</config:config-item>
		</config:config-item-set>
	</xsl:template>
	<xsl:template match="式样:段落式样_9912" mode="presentation-default">
		<xsl:element name="style:default-style">
			<xsl:attribute name="style:family">graphic</xsl:attribute>
			<xsl:element name="style:paragraph-properties">
				<xsl:call-template name="ParaPropertiesAll">
					<xsl:with-param name="tabstop" select="string('default')"/>
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="style:text-properties">
				<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@类型_4102='default'][1]">
					<xsl:call-template name="TextProperties"/>
				</xsl:for-each>
				<xsl:for-each select="字:句属性_4158">
					<xsl:call-template name="TextProperties"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template name="OfficeStylePresentation">
		<!--xsl:for-each select="uof:演示文稿">
			<xsl:for-each select="演:公用处理规则">
				<xsl:for-each select="演:页面版式集">
					<xsl:apply-templates select="演:页面版式"/>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="演:主体/演:母版集/演:母版">
				<xsl:if test="@演:类型='slide'">
					<xsl:apply-templates select="." mode="OfficeStyle"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each-->
		<xsl:apply-templates select="规则:公用处理规则_B665/规则:演示文稿_B66D/规则:页面版式集_B651/规则:页面版式_B652"/>
		<xsl:for-each select="演:演示文稿文档_6C10/演:母版集_6C0C/演:母版_6C0D">
			<xsl:if test="@类型_6BEA='slide'">
				<xsl:apply-templates select="." mode="OfficeStyle"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="演:母版_6C0D" mode="OfficeStyle">
		<xsl:variable name="TextStyle" select="key('MasterTextStyle',@文本式样引用_6BED)"/>
		<xsl:variable name="MasterName" select="@标识符_6BE8"/>
		<xsl:for-each select="uof:锚点_C644">
			<xsl:choose>
				<xsl:when test="uof:占位符_C626/@类型_C627='title'">
					<style:style style:family="presentation">
						<xsl:attribute name="style:name"><xsl:value-of select="concat($MasterName,'-title')"/></xsl:attribute>
						<xsl:call-template name="OfficeStyleGraphProp">
							<xsl:with-param name="NumberID" select="$TextStyle/式样:段落式样_9912[字:大纲级别_417C='0'][1]/字:自动编号信息_4186/@编号引用_4187"/>
						</xsl:call-template>
						<xsl:for-each select="$TextStyle/式样:段落式样_9912[字:大纲级别_417C='0'][1]">
							<xsl:apply-templates select="." mode="OfficeStyle">
								<xsl:with-param name="TextStyle" select="$TextStyle"/>
								<xsl:with-param name="SetDefaultTitle" select="'true'"/>
							</xsl:apply-templates>
						</xsl:for-each>
						<xsl:if test="count($TextStyle/式样:段落式样_9912[字:大纲级别_417C='0'])=0">
							<style:paragraph-properties fo:text-align="center" style:text-autospace="ideograph-alpha" style:punctuation-wrap="simple" style:line-break="strict"/>
							<style:text-properties style:text-outline="false" fo:font-family="'Times New Roman'" fo:font-size="44pt" fo:letter-spacing="normal" fo:font-style="normal" fo:text-shadow="none" style:text-underline-style="none" style:letter-kerning="true" style:font-family-asian="宋体" style:font-size-asian="44pt" style:font-style-asian="normal" style:font-size-complex="44pt" style:font-style-complex="normal" style:text-emphasize="none" style:text-scale="100%" style:font-relief="none"/>
						</xsl:if>
					</style:style>
				</xsl:when>
				<xsl:when test="uof:占位符_C626/@类型_C627='text' or uof:占位符_C626/@类型_C627='outline'">
					<xsl:variable name="GraphName" select="@图形引用_C62E"/>
					<style:style style:family="presentation">
						<xsl:attribute name="style:name"><xsl:value-of select="concat($MasterName,'-outline1')"/></xsl:attribute>
						<xsl:call-template name="OfficeStyleGraphProp">
							<xsl:with-param name="NumberID" select="$TextStyle/式样:段落式样_9912[字:大纲级别_417C='1'][1]/字:自动编号信息_4186/@编号引用_4187"/>
						</xsl:call-template>
						<xsl:for-each select="$TextStyle/式样:段落式样_9912[字:大纲级别_417C='1'][1]">
							<xsl:apply-templates select="." mode="OfficeStyle">
								<xsl:with-param name="TextStyle" select="$TextStyle"/>
							</xsl:apply-templates>
						</xsl:for-each>
					</style:style>
					<!-- 若存在相同大纲级别的多个段落式样，取第一个 -->
					<xsl:for-each-group select="$TextStyle/式样:段落式样_9912" group-by="字:大纲级别_417C">
						<xsl:if test="not(字:大纲级别_417C='0' or 字:大纲级别_417C='1')">
							<style:style style:family="presentation">
								<xsl:attribute name="style:name"><xsl:value-of select="concat($MasterName,'-outline',string(字:大纲级别_417C))"/></xsl:attribute>
								<xsl:variable name="SetDefaultOutLine">
									<xsl:variable name="OutlineNumber" select="number(字:大纲级别_417C)"/>
									<xsl:variable name="Parent" select="@基式样引用_4104"/>
									<xsl:variable name="ParentPart" select="concat('-outline',string($OutlineNumber - 1))"/>
									<xsl:choose>
										<xsl:when test="contains($Parent, $ParentPart)">
											<xsl:value-of select="'false'"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="'true'"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:apply-templates select="." mode="OfficeStyle">
									<xsl:with-param name="TextStyle" select="$TextStyle"/>
									<xsl:with-param name="SetDefaultOutLine" select="$SetDefaultOutLine"/>
								</xsl:apply-templates>
							</style:style>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<!--<xsl:template name="DefaultMasterFooterOrHeaderOrDatetimeSize">
		<xsl:param name="textAreaHeight"/>
		<xsl:param name="textAreaWidth"/>
		<xsl:variable name="dateX" select="0.05 * number($textAreaWidth)"/>
		<xsl:variable name="footerX" select="0.342 * number($textAreaWidth)"/>
		<xsl:variable name="numberX" select="0.717 * number($textAreaWidth)"/>
		<xsl:variable name="dateOrNumberWidth">
			<xsl:value-of select="number(0.2329643) * number($textAreaWidth)"/>
		</xsl:variable>
		<xsl:variable name="footerWidth" select="0.31696 * number($textAreaWidth)"/>
		<xsl:variable name="Y" select="0.911 * $textAreaHeight"/>
		<xsl:variable name="Height" select="0.0689524 * $textAreaHeight"/>
		<xsl:if test="not(uof:锚点_C644/uof:占位符_C626[@类型_C627 = 'date'])">
			<draw:frame presentation:style-name="Mpr1" draw:text-style-name="MP1" draw:layer="backgroundobjects" svg:width="6.523cm" svg:height="1.448cm" svg:x="1.4cm" svg:y="19.131cm" presentation:class="date-time">
				<xsl:attribute name="svg:width"><xsl:value-of select="concat($dateOrNumberWidth,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:height"><xsl:value-of select="concat($Height,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:x"><xsl:value-of select="concat($dateX,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:y"><xsl:value-of select="concat($Y,$uofUnit)"/></xsl:attribute>
				<draw:text-box>
					<text:p text:style-name="MP1">
						<presentation:date-time/>
					</text:p>
				</draw:text-box>
			</draw:frame>
		</xsl:if>
		<xsl:if test="not(uof:锚点_C644/uof:占位符_C626[@类型_C627 = 'footer'])">
			<draw:frame presentation:style-name="Mpr1" draw:text-style-name="MP3" draw:layer="backgroundobjects" svg:width="8.875cm" svg:height="1.448cm" svg:x="9.576cm" svg:y="19.131cm" presentation:class="footer">
				<xsl:attribute name="svg:width"><xsl:value-of select="concat($footerWidth,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:height"><xsl:value-of select="concat($Height,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:x"><xsl:value-of select="concat($footerX,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:y"><xsl:value-of select="concat($Y,$uofUnit)"/></xsl:attribute>
				<draw:text-box>
					<text:p text:style-name="MP3">
						<presentation:footer/>
					</text:p>
				</draw:text-box>
			</draw:frame>
		</xsl:if>
		<xsl:if test="not(uof:锚点_C644/uof:占位符_C626[@类型_C627 = 'number'])">
			<draw:frame presentation:style-name="Mpr1" draw:text-style-name="MP2" draw:layer="backgroundobjects" svg:width="6.523cm" svg:height="1.448cm" svg:x="20.076cm" svg:y="19.131cm" presentation:class="page-number">
				<xsl:attribute name="svg:width"><xsl:value-of select="concat($dateOrNumberWidth,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:height"><xsl:value-of select="concat($Height,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:x"><xsl:value-of select="concat($numberX,$uofUnit)"/></xsl:attribute>
				<xsl:attribute name="svg:y"><xsl:value-of select="concat($Y,$uofUnit)"/></xsl:attribute>
				<draw:text-box>
					<text:p text:style-name="MP2">
						<text:page-number>&lt;编号&gt;</text:page-number>
					</text:p>
				</draw:text-box>
			</draw:frame>
		</xsl:if>
	</xsl:template>-->
	<xsl:template name="OfficeStyleGraphProp">
		<xsl:param name="NumberID"/>
		<xsl:variable name="GraphName" select="@图形引用_C62E"/>
		<xsl:variable name="textanchor" select="."/>
		<style:graphic-properties draw:stroke="none">
			<!--增加演示文稿文本框中min-height属性-->
			<xsl:if test="uof:占位符_C626/@类型_C627">
				<xsl:attribute name="fo:min-height"><xsl:value-of select="concat(uof:大小_C621/@长_C604,$uofUnit)"/></xsl:attribute>
			</xsl:if>
			<xsl:for-each select="key('graph-styles',$GraphName)">
				<xsl:apply-templates select="图:预定义图形_8018" mode="Graph">
					<xsl:with-param name="textanchor" select="$textanchor"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="图:文本_803C" mode="Graph">
					<xsl:with-param name="textanchor" select="$textanchor"/>
				</xsl:apply-templates>
			</xsl:for-each>
			<xsl:if test="$NumberID != ''">
				<xsl:for-each select="key('AutoNumber',$NumberID)">
					<xsl:apply-templates select="." mode="liststyle"/>
				</xsl:for-each>
			</xsl:if>
		</style:graphic-properties>
	</xsl:template>
	<xsl:template name="DefaultParaTitle">
		<xsl:attribute name="fo:text-align" select="'center'"/>
	</xsl:template>
	<xsl:template name="DefaultParaOutLine">
		<xsl:attribute name="fo:margin-left" select="'0cm'"/>
		<xsl:attribute name="fo:margin-right" select="'0cm'"/>
		<xsl:attribute name="fo:margin-top" select="'0cm'"/>
		<xsl:attribute name="fo:margin-bottom" select="'0cm'"/>
		<xsl:attribute name="fo:line-height" select="'100%'"/>
		<xsl:attribute name="fo:text-indent" select="'0cm'"/>
	</xsl:template>
	<xsl:template name="DefaultTextTitle">
		<xsl:attribute name="fo:font-size" select="'44pt'"/>
		<xsl:attribute name="style:font-size-asian" select="'44pt'"/>
		<xsl:attribute name="style:font-size-complex" select="'44pt'"/>
	</xsl:template>
	<xsl:template name="DefaultTextOutLine">
		<xsl:attribute name="style:use-window-font-color" select="'true'"/>
		<xsl:attribute name="style:text-outline" select="'false'"/>
		<xsl:attribute name="style:text-line-through-style" select="'none'"/>
		<!--<xsl:attribute name="fo:font-family" select="'&apos;Times New Roman&apos;'"/>-->
		<xsl:attribute name="style:font-family-generic" select="'roman'"/>
		<xsl:attribute name="style:font-pitch" select="'variable'"/>
		<xsl:attribute name="fo:font-size" select="'18pt'"/>
		<xsl:attribute name="fo:font-style" select="'normal'"/>
		<xsl:attribute name="fo:text-shadow" select="'none'"/>
		<xsl:attribute name="style:text-underline-style" select="'none'"/>
		<xsl:attribute name="fo:font-weight" select="'normal'"/>
		<xsl:attribute name="style:letter-kerning" select="'true'"/>
		<xsl:attribute name="style:font-family-asian" select="'宋体'"/>
		<xsl:attribute name="style:font-family-generic-asian" select="'system'"/>
		<xsl:attribute name="style:font-pitch-asian" select="'variable'"/>
		<xsl:attribute name="style:font-size-asian" select="'18pt'"/>
		<xsl:attribute name="style:font-style-asian" select="'normal'"/>
		<xsl:attribute name="style:font-weight-asian" select="'normal'"/>
		<xsl:attribute name="style:font-family-complex" select="'Tahoma'"/>
		<xsl:attribute name="style:font-family-generic-complex" select="'system'"/>
		<xsl:attribute name="style:font-pitch-complex" select="'variable'"/>
		<xsl:attribute name="style:font-size-complex" select="'18pt'"/>
		<xsl:attribute name="style:font-style-complex" select="'normal'"/>
		<xsl:attribute name="style:font-weight-complex" select="'normal'"/>
		<xsl:attribute name="style:text-emphasize" select="'none'"/>
		<xsl:attribute name="style:font-relief" select="'none'"/>
		<xsl:attribute name="style:text-overline-style" select="'none'"/>
		<xsl:attribute name="style:text-overline-color" select="'font-color'"/>
	</xsl:template>
	<xsl:template match="式样:段落式样_9912" mode="OfficeStyle">
		<xsl:param name="TextStyle"/>
		<xsl:param name="SetDefaultTitle"/>
		<xsl:param name="SetDefaultOutLine"/>
		<xsl:variable name="parentName" select="@基式样引用_4104"/>
		<xsl:element name="style:paragraph-properties">
			<xsl:if test="$SetDefaultTitle = 'true'">
				<xsl:call-template name="DefaultParaTitle"/>
			</xsl:if>
			<xsl:if test="$SetDefaultOutLine = 'true'">
				<xsl:call-template name="DefaultParaOutLine"/>
			</xsl:if>
			<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样[@类型_4102 = 'default'][1]">
				<xsl:call-template name="ParaPropertiesAttr"/>
			</xsl:for-each>
			<!-- xsl:call-template name="ParaParentProperties">
				<xsl:with-param name="Stylename" select="$parentName"/>
			</xsl:call-template>
			<xsl:call-template name="ParaPropertiesAttr"/-->
			<xsl:call-template name="ParaPropertiesAll">
				<xsl:with-param name="Stylename" select="$parentName"/>
			</xsl:call-template>
		</xsl:element>
		<xsl:element name="style:text-properties">
			<xsl:if test="$SetDefaultTitle = 'true'">
				<xsl:call-template name="DefaultTextTitle"/>
			</xsl:if>
			<xsl:if test="$SetDefaultOutLine = 'true'">
				<xsl:call-template name="DefaultTextOutLine"/>
			</xsl:if>
			<xsl:attribute name="fo:text-shadow">none</xsl:attribute>
			<xsl:attribute name="style:text-scale">100%</xsl:attribute>
			<xsl:attribute name="fo:letter-spacing">normal</xsl:attribute>
			<xsl:for-each select="/uof:UOF_0000/式样:式样集_990B/式样:段落式样集_9911/式样:段落式样[@类型_4102 = 'default'][1]/字:句属性_4158">
				<xsl:call-template name="TextProperties"/>
			</xsl:for-each>
			<xsl:call-template name="TextParaParentProperties">
				<xsl:with-param name="Stylename" select="$parentName"/>
			</xsl:call-template>
			<xsl:for-each select="字:句属性_4158">
				<xsl:call-template name="TextProperties"/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="规则:页面版式_B652">
		<xsl:element name="style:presentation-page-layout">
			<xsl:attribute name="style:name"><xsl:value-of select="@标识符_6B0D"/></xsl:attribute>
			<xsl:for-each select="uof:锚点_C644">
				<presentation:placeholder>
					<xsl:variable name="placeChar">
						<xsl:choose>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'clipart'">graphic</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'media_clip'">graphic</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'graphics'">graphic</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'number'">page-number</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'centertitle'">title</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'date'">date-time</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'chart'">chart</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'title'">
								<xsl:choose>
									<xsl:when test="../uof:锚点_6B19/uof:占位符_C626[@类型_C627='centertitle']">subtitle</xsl:when>
									<xsl:otherwise>title</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'subtitle'">subtitle</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'text'">outline</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'object'">object</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'header'">header</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'footer'">footer</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'table'">table</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'outline'">outline</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'handout'">handout</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'notes'">notes</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'vertical_text'">outline</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'vertical_title'">title</xsl:when>
							<xsl:when test="uof:占位符_C626/@类型_C627 = 'vertical_subtitle'">subtitle</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="presentation:object"><xsl:value-of select="$placeChar"/></xsl:attribute>
					<xsl:attribute name="svg:x"><xsl:value-of select="concat(uof:位置_C620/uof:水平_4106/uof:绝对_4107/@值_4108,$uofUnit)"/></xsl:attribute>
					<xsl:attribute name="svg:y"><xsl:value-of select="concat(uof:位置_C620/uof:垂直_410D/uof:绝对_4107/@值_4108,$uofUnit)"/></xsl:attribute>
					<xsl:attribute name="svg:width"><xsl:value-of select="concat(uof:大小_C621/@宽_C605,$uofUnit)"/></xsl:attribute>
					<xsl:attribute name="svg:height"><xsl:value-of select="concat(uof:大小_C621/@长_C604,$uofUnit)"/></xsl:attribute>
				</presentation:placeholder>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="AutoStylePresentation">
		<!--xsl:for-each select="uof:演示文稿">
			<xsl:for-each select="演:公用处理规则">
				<xsl:for-each select="演:页面设置集">
					<xsl:apply-templates select="演:页面设置"/>
				</xsl:for-each>
				<xsl:for-each select="演:文本式样集">
					<xsl:apply-templates select="演:文本式样/演:段落式样" mode="AutoStyle"/>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="演:主体">
				<xsl:apply-templates select="演:母版集/演:母版" mode="AutoStyle"/>
				<xsl:apply-templates select="演:幻灯片集/演:幻灯片" mode="AutoStyle"/>
			</xsl:for-each>
		</xsl:for-each-->
		<!--设置母板页眉页脚的默认式样-->
		<xsl:if test="not(演:演示文稿文档_6C10/演:母版集_6C0C/演:母版_6C0D/uof:锚点_C644/uof:占位符_C626[@类型_C627 = 'header']) or not(演:演示文稿文档_6C10/演:母版集_6C0C/演:母版_6C0D/uof:锚点_C644/uof:占位符_C626[@类型_C627 = 'date']) or not(演:演示文稿文档_6C10/演:母版集_6C0C/演:母版_6C0D/uof:锚点_C644/uof:占位符_C626[@类型_C627 = 'number'])">
			<style:style style:name="Mpr1" style:family="presentation">
				<style:graphic-properties draw:stroke="none" draw:fill="none" draw:fill-color="#ffffff" draw:auto-grow-height="false"/>
			</style:style>
			<style:style style:name="MP1" style:family="paragraph">
				<style:text-properties fo:font-size="14pt" style:font-size-asian="14pt" style:font-size-complex="14pt"/>
			</style:style>
			<style:style style:name="MP2" style:family="paragraph">
				<style:paragraph-properties fo:text-align="end"/>
				<style:text-properties fo:font-size="14pt" style:font-size-asian="14pt" style:font-size-complex="14pt"/>
			</style:style>
			<style:style style:name="MP3" style:family="paragraph">
				<style:paragraph-properties fo:text-align="center"/>
				<style:text-properties fo:font-size="14pt" style:font-size-asian="14pt" style:font-size-complex="14pt"/>
			</style:style>
		</xsl:if>
		<xsl:apply-templates select="规则:公用处理规则_B665/规则:演示文稿_B66D/规则:页面设置集_B670/规则:页面设置_B638"/>
		<xsl:apply-templates select="演:演示文稿文档_6C10/演:母版集_6C0C/演:母版_6C0D" mode="AutoStyle"/>
		<!--xsl:apply-templates select="演:演示文稿文档_6C10/演:幻灯片集_6C0E/演:幻灯片_6C0F" mode="AutoStyle"/-->
	</xsl:template>
	<xsl:template match="规则:页面设置_B638">
		<xsl:element name="style:page-layout">
			<xsl:attribute name="style:name"><xsl:value-of select="@标识符_B671"/></xsl:attribute>
			<xsl:element name="style:page-layout-properties">
				<xsl:variable name="page-width">
					<xsl:choose>
						<xsl:when test="演:纸张_6BDD/@宽_C605">
							<xsl:value-of select="concat(演:纸张_6BDD/@宽_C605,$uofUnit)"/>
						</xsl:when>
						<xsl:when test="演:纸张方向_6BE1 = 'portrait'">
							<xsl:choose>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'A3'">297mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'A4'">210mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'A5'">148mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'B4'">250mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'B5'">176mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'letter-small'">215.9mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'letter'">215.9mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'PRC-16K'">184mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'PRC-32K'">130mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'PRC-32K(Big)'">140mm</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="演:纸张方向_6BE1 = 'landscape'">
							<xsl:choose>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'A3'">420mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'A4'">297mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'A5'">210mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'B4'">353mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'B5'">250mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'letter-small'">355.7mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'letter'">279.4mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'PRC-16K'">260mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'PRC-32K'">184mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'PRC-32K(Big)'">203mm</xsl:when>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="page-height">
					<xsl:choose>
						<xsl:when test="演:纸张_6BDD/@长_C604">
							<xsl:value-of select="concat(演:纸张_6BDD/@长_C604,$uofUnit)"/>
						</xsl:when>
						<xsl:when test="演:纸张方向_6BE1 = 'portrait'">
							<xsl:choose>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'A3'">420mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'A4'">297mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'A5'">210mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'B4'">353mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'B5'">250mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'letter-small'">355.7mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'letter'">279.4mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'PRC-16K'">260mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'PRC-32K'">184mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'PRC-32K(Big)'">203mm</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="演:纸张方向_6BE1 = 'landscape'">
							<xsl:choose>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'A3'">297mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'A4'">210mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'A5'">148mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'B4'">250mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'B5'">176mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@u纸型_C60C = 'letter-small'">215.9mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'letter'">215.9mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'PRC-16K'">184mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'PRC-32K'">130mm</xsl:when>
								<xsl:when test="演:纸张_6BDD/@纸型_C60C = 'PRC-32K(Big)'">140mm</xsl:when>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="fo:page-width"><xsl:value-of select="$page-width"/></xsl:attribute>
				<xsl:attribute name="fo:page-height"><xsl:value-of select="$page-height"/></xsl:attribute>
				<xsl:for-each select="演:页边距_6BDE">
					<xsl:attribute name="fo:margin-top"><xsl:value-of select="concat(@上_C609,$uofUnit)"/></xsl:attribute>
					<xsl:attribute name="fo:margin-bottom"><xsl:value-of select="concat(@下_C60B,$uofUnit)"/></xsl:attribute>
					<xsl:attribute name="fo:margin-left"><xsl:value-of select="concat(@左_C608,$uofUnit)"/></xsl:attribute>
					<xsl:attribute name="fo:margin-right"><xsl:value-of select="concat(@右_C60A,$uofUnit)"/></xsl:attribute>
				</xsl:for-each>
				<xsl:choose>
					<xsl:when test="演:纸张方向_6BE1 = 'landscape'">
						<xsl:attribute name="style:print-orientation">landscape</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="style:print-orientation">portrait</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="式样:段落式样_9912" mode="AutoStyle">
		<!--部分案例不规范 式样类型写成default  造成丢失 故稍作修改
		<xsl:call-template name="UOFParagraphStyle">
			<xsl:with-param name="Type" select="string('auto')"/>
		</xsl:call-template-->
		<xsl:element name="style:style">
			<xsl:call-template name="OneParagraphStyle"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="showSettings">
		<xsl:variable name="displayorderref" select="规则:放映顺序_B658"/>
		<xsl:element name="presentation:settings">
			<xsl:attribute name="presentation:mouse-visible">false</xsl:attribute>
			<xsl:if test="string(规则:是否循环放映_B65A)='true'">
				<xsl:attribute name="presentation:endless">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="规则:幻灯片序列_B654[@标识符_B655=$displayorderref]/@是否自定义_B657='true'">
				<xsl:attribute name="presentation:show"><xsl:value-of select="$displayorderref"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="string(规则:是否全屏放映_B659)='false'">
				<xsl:attribute name="presentation:full-screen">false</xsl:attribute>
			</xsl:if>
			<xsl:if test="string(规则:是否手动方式_B65C)='true'">
				<xsl:attribute name="presentation:force-manual">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="string(规则:是否使用导航帮助_B65D)='true'">
				<xsl:attribute name="presentation:start-with-navigator">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="string(规则:是否放映动画_B65E)='false'">
				<xsl:attribute name="presentation:animations">disabled</xsl:attribute>
			</xsl:if>
			<xsl:if test="string(规则:是否前端显示_B65F)='true'">
				<xsl:attribute name="presentation:stay-on-top">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="规则:放映间隔_B65B">
				<xsl:variable name="displayinterval" select="规则:放映间隔_B65B"/>
				<xsl:attribute name="presentation:pause"><xsl:if test="contains($displayinterval,'P0Y0M0DT')"><xsl:variable name="OOtime"><xsl:value-of select="substring-after(规则:放映间隔_B65B,'P0Y0M0DT')"/></xsl:variable><xsl:value-of select="concat('PT',$OOtime)"/></xsl:if><xsl:if test="contains($displayinterval,'PT')"><xsl:value-of select="$displayinterval"/></xsl:if></xsl:attribute>
			</xsl:if>
			<xsl:for-each select="规则:幻灯片序列_B654">
				<xsl:choose>
					<xsl:when test="@标识符_B655=$displayorderref">
						<xsl:variable name="space" select="."/>
						<xsl:choose>
							<xsl:when test="@是否自定义_B657='false'">
								<xsl:variable name="start">
									<xsl:choose>
										<xsl:when test="contains($space,' ')">
											<xsl:value-of select="substring-before($space,' ')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$space"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="end">
									<xsl:choose>
										<xsl:when test="contains($space,' ')">
											<xsl:value-of select="substring-after($space,' ')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$space"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:if test="not($start='')">
									<xsl:attribute name="presentation:start-page"><xsl:value-of select="$start"/></xsl:attribute>
								</xsl:if>
								<xsl:if test="not($end='')">
									<xsl:attribute name="presentation:end-page"><xsl:value-of select="$end"/></xsl:attribute>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="presentation:show"><xsl:value-of select="$displayorderref"/></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
			<xsl:for-each select="规则:幻灯片序列_B654">
				<xsl:element name="presentation:show">
					<xsl:attribute name="presentation:name" select="@标识符_B655"/>
					<xsl:attribute name="presentation:pages" select="replace(.,' ',',')"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="演:母版_6C0D" mode="AutoStyle">
		<xsl:variable name="MasterName" select="@标识符_6BE8"/>
		<xsl:element name="style:style">
			<xsl:attribute name="style:name" select="concat($MasterName,'_draw')"/>
			<xsl:attribute name="style:family">drawing-page</xsl:attribute>
			<xsl:element name="style:drawing-page-properties">
				<xsl:for-each select="演:背景_6B2C">
					<xsl:call-template name="FillGraph"/>
				</xsl:for-each>
				<!--母版页面式样设置页眉页脚是否显示不起作用，故不应用PlaceholderDisplay模板-->
			</xsl:element>
		</xsl:element>
		<!--动画在幻灯片页中处理-->
	</xsl:template>
	<xsl:template match="演:幻灯片_6C0F" mode="AutoStyle">
		<xsl:variable name="MasterName" select="@母版引用_6B26"/>
		<xsl:variable name="SlideName" select="@标识符_6B0A"/>
		<xsl:element name="style:style">
			<xsl:attribute name="style:name" select="concat($SlideName,'_draw')"/>
			<xsl:attribute name="style:family">drawing-page</xsl:attribute>
			<xsl:element name="style:drawing-page-properties">
				<xsl:for-each select="演:背景_6B2C">
					<xsl:call-template name="FillGraph"/>
				</xsl:for-each>
				<xsl:attribute name="presentation:visibility"><xsl:choose><xsl:when test="@是否显示_6B28='false' or @是否显示_6B28='0'">hidden</xsl:when><xsl:otherwise>visible</xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:attribute name="presentation:background-visible"><xsl:choose><xsl:when test="@是否显示背景_6B29='false' or @是否显示背景_6B29='0'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:attribute name="presentation:background-objects-visible"><xsl:choose><xsl:when test="@是否显示背景对象_6B2A='false' or @是否显示背景对象_6B2A='0'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:for-each select="演:切换_6B1F">
					<xsl:for-each select="演:方式_6B23">
						<!--切换声音在动画中处理-->
						<xsl:attribute name="presentation:transition-type"><xsl:value-of select="'manual'"/></xsl:attribute>
						<xsl:if test="演:单击鼠标_6B24='false' or 演:单击鼠标_6B24='0'">
							<xsl:attribute name="presentation:transition-type"><xsl:value-of select="'none'"/></xsl:attribute>
							<xsl:if test="演:时间间隔_6B25">
								<xsl:attribute name="presentation:transition-type"><xsl:value-of select="'automatic'"/></xsl:attribute>
							</xsl:if>
						</xsl:if>
						<xsl:if test="演:时间间隔_6B25">
							<xsl:attribute name="presentation:duration"><!--UOF的时间表示如果与ODF不一致需做进一步处理--><xsl:value-of select="演:时间间隔_6B25"/></xsl:attribute>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="演:速度_6B21">
						<xsl:attribute name="presentation:transition-speed"><xsl:value-of select="演:速度_6B21"/></xsl:attribute>
					</xsl:if>
				</xsl:for-each>
				<xsl:variable name="isFirstSld">
					<xsl:choose>
						<xsl:when test="preceding-sibling::演:幻灯片_6C0F">0</xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:for-each select="key('HeaderFooterP','规则:幻灯片_B641')">
					<xsl:choose>
						<xsl:when test="@标题幻灯片中是否显示_B64B='true'and $isFirstSld='1' ">
							<xsl:attribute name="presentation:display-date-time" select="'false'"/>
							<xsl:attribute name="presentation:display-footer" select="'false'"/>
							<xsl:attribute name="presentation:display-page-number" select="'false'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="presentation:display-page-number"><xsl:choose><xsl:when test="@是否显示幻灯片编号_B64A='true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:attribute name="presentation:display-date-time"><xsl:choose><xsl:when test="@是否显示日期和时间_B647='false'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:attribute name="presentation:display-footer"><xsl:choose><xsl:when test="@是否显示页脚_B648='false'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
		<xsl:element name="style:style">
			<xsl:attribute name="style:name" select="concat($SlideName,'_N_draw')"/>
			<xsl:attribute name="style:family">drawing-page</xsl:attribute>
			<xsl:element name="style:drawing-page-properties">
				<xsl:for-each select="演:幻灯片备注_6B1D/演:背景_6B2C">
					<xsl:call-template name="FillGraph"/>
				</xsl:for-each>
				<xsl:for-each select="key('HeaderFooterP','规则:讲义和备注_B64C')">
					<xsl:attribute name="presentation:display-header"><xsl:choose><xsl:when test="@是否显示页眉_B64F='false'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="presentation:display-page-number"><xsl:choose><xsl:when test="@是否显示页码_B650='false'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="presentation:display-date-time"><xsl:choose><xsl:when test="@是否显示日期和时间_B647='false'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="presentation:display-footer"><xsl:choose><xsl:when test="@是否显示页脚_B648='false'">false</xsl:when><xsl:otherwise>true</xsl:otherwise></xsl:choose></xsl:attribute>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
		<!--动画在幻灯片页中处理-->
	</xsl:template>
	<xsl:template name="MasterStylePresentation">
		<draw:layer-set>
			<!-- uof中无对应项 -->
			<draw:layer draw:name="layout"/>
			<draw:layer draw:name="background"/>
			<draw:layer draw:name="backgroundobjects"/>
			<draw:layer draw:name="controls"/>
			<draw:layer draw:name="measurelines"/>
		</draw:layer-set>
		<xsl:apply-templates select="演:演示文稿文档_6C10/演:母版集_6C0C/演:母版_6C0D"/>
	</xsl:template>
	<xsl:template match="演:母版_6C0D">
		<xsl:variable name="pageLayoutStyleName" select="@页面设置引用_6C18"/>
		<xsl:variable name="textAreaHeight">
			<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:演示文稿_B66D/规则:页面设置集_B670/规则:页面设置_B638[@标识符_B671 = $pageLayoutStyleName]">
				<xsl:variable name="top">
					<xsl:choose>
						<xsl:when test="演:页边距_6BDE/@上_C609">
							<xsl:value-of select="演:页边距_6BDE/@上_C609"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="bottom">
					<xsl:choose>
						<xsl:when test="演:页边距_6BDE/@下_C60B">
							<xsl:value-of select="演:页边距_6BDE/@下_C60B"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="number(演:纸张_6BDD/@长_C604) - number($top) - number($bottom)"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="textAreaWidth">
			<xsl:for-each select="/uof:UOF_0000/规则:公用处理规则_B665/规则:演示文稿_B66D/规则:页面设置集_B670/规则:页面设置_B638[@标识符_B671 = $pageLayoutStyleName]">
				<xsl:variable name="left">
					<xsl:choose>
						<xsl:when test="演:页边距_6BDE/@左_C608">
							<xsl:value-of select="演:页边距_6BDE/@左_C608"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="right">
					<xsl:choose>
						<xsl:when test="演:页边距_6BDE/@右_C60A">
							<xsl:value-of select="演:页边距_6BDE/@右_C60A"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="number(演:纸张_6BDD/@宽_C605) - number($left) - number($right)"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@类型_6BEA = 'handout' ">
				<xsl:element name="style:handout-master">
					<xsl:variable name="MasterName" select="@标识符_6BE8"/>
					<xsl:attribute name="style:name"><xsl:value-of select="$MasterName"/></xsl:attribute>
					<xsl:attribute name="style:page-layout-name"><xsl:value-of select="@页面设置引用_6C18"/></xsl:attribute>
					<xsl:attribute name="draw:style-name" select="concat($MasterName,'_draw')"/>
					<xsl:if test="@页面版式引用_6BEC">
						<xsl:attribute name="presentation:presentation-page-layout-name"><xsl:value-of select="@页面版式引用_6BEC"/></xsl:attribute>
					</xsl:if>
					<xsl:for-each select="uof:锚点_C644">
						<xsl:call-template name="ObjectContent"/>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@类型_6BEA = 'slide' or not(@类型_6BEA)">
				<xsl:element name="style:master-page">
					<xsl:variable name="MasterName" select="@标识符_6BE8"/>
					<xsl:attribute name="style:name"><xsl:value-of select="$MasterName"/></xsl:attribute>
					<!-- 只要@style:name和@style:display-name不一致，则幻灯片、母版中的文字默认采用软件预设的段落式样，实际设置的式样信息丢失 -->
					<!--<xsl:attribute name="style:display-name"><xsl:value-of select="@演:名称"/></xsl:attribute>
					-->
					<xsl:attribute name="style:display-name"><xsl:value-of select="$MasterName"/></xsl:attribute>
					<!-- <xsl:attribute name="style:page-layout-name"><xsl:value-of select="'PM1'"/></xsl:attribute>
                     -->
					<xsl:attribute name="style:page-layout-name"><xsl:value-of select="@页面设置引用_6C18"/></xsl:attribute>
					<xsl:attribute name="draw:style-name" select="concat($MasterName,'_draw')"/>
					<xsl:for-each select="uof:锚点_C644">
						<xsl:call-template name="ObjectContent"/>
					</xsl:for-each>
					<!--演示文稿母板中默认页眉页脚
					<xsl:call-template name="DefaultMasterFooterOrHeaderOrDatetimeSize">
						<xsl:with-param name="textAreaHeight" select="$textAreaHeight"/>
						<xsl:with-param name="textAreaWidth" select="$textAreaWidth"/>
					</xsl:call-template>-->
					<!--可能在不同幻灯片中出现不一致slide母版-note母版引用，取第一次出现的note母版放入slide母版下-->
					<xsl:variable name="NoteMasterName" select="key('Slide',$MasterName)[1]/演:幻灯片备注_6B1D/@备注母版引用_6B2D"/>
					<xsl:for-each select="../演:母版_6C0D[@标识符_6BE8=$NoteMasterName]">
						<xsl:if test="@类型_6BEA = 'notes'">
							<xsl:element name="presentation:notes">
								<!-- <xsl:attribute name="style:page-layout-name"><xsl:value-of select="'PM1'"/></xsl:attribute>
								 -->
								<xsl:attribute name="style:page-layout-name"><xsl:value-of select="@页面设置引用_6C18"/></xsl:attribute>
								<xsl:attribute name="draw:style-name"><xsl:value-of select="concat($NoteMasterName,'_draw')"/></xsl:attribute>
								<xsl:for-each select="uof:锚点_C644">
									<xsl:call-template name="ObjectContent"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="演:演示文稿文档_6C10">
		<office:body>
			<office:presentation>
				<xsl:for-each select="../规则:公用处理规则_B665/规则:演示文稿_B66D">
					<xsl:apply-templates select="规则:页眉页脚集_B640"/>
				</xsl:for-each>
				<xsl:for-each select="演:幻灯片集_6C0E/演:幻灯片_6C0F">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
				<xsl:for-each select="../规则:公用处理规则_B665/规则:演示文稿_B66D/规则:放映设置_B653">
					<xsl:call-template name="showSettings"/>
				</xsl:for-each>
			</office:presentation>
		</office:body>
	</xsl:template>
	<xsl:template match="规则:页眉页脚集_B640">
		<xsl:for-each select="规则:幻灯片_B641">
			<xsl:for-each select="规则:页脚_B644">
				<xsl:element name="presentation:footer-decl">
					<xsl:attribute name="presentation:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:for-each>
			<xsl:element name="presentation:date-time-decl">
				<xsl:attribute name="presentation:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="string(@是否自动更新日期和时间_B649)='true'">
						<xsl:attribute name="presentation:source">current-date</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="presentation:source">fixed</xsl:attribute>
						<xsl:value-of select="规则:日期和时间字符串_B643"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
		<xsl:for-each select="规则:讲义和备注_B64C">
			<xsl:for-each select="规则:页脚_B644">
				<xsl:element name="presentation:footer-decl">
					<xsl:attribute name="presentation:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
					<xsl:value-of select="string(.)"/>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="规则:页眉_B64D">
				<xsl:element name="presentation:header-decl">
					<xsl:attribute name="presentation:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
					<xsl:value-of select="string(.)"/>
				</xsl:element>
			</xsl:for-each>
			<xsl:element name="presentation:date-time-decl">
				<xsl:attribute name="presentation:name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="string(@是否自动更新日期和时间_B649)='true'">
						<xsl:attribute name="presentation:source">current-date</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="presentation:source">fixed</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="演:幻灯片_6C0F">
		<xsl:variable name="SlideName" select="@标识符_6B0A"/>
		<xsl:element name="draw:page">
			<xsl:attribute name="draw:name"><xsl:value-of select="$SlideName"/></xsl:attribute>
			<xsl:attribute name="draw:style-name"><xsl:value-of select="concat($SlideName,'_draw')"/></xsl:attribute>
			<xsl:attribute name="draw:display-name"><xsl:value-of select="@名称_6B0B"/></xsl:attribute>
			<xsl:attribute name="draw:master-page-name"><xsl:value-of select="@母版引用_6B26"/></xsl:attribute>
			<xsl:if test="@页面版式引用_6B27">
				<xsl:attribute name="presentation:presentation-page-layout-name"><xsl:value-of select="@页面版式引用_6B27"/></xsl:attribute>
			</xsl:if>
			<xsl:for-each select="key('HeaderFooterP','规则:幻灯片_B641')">
				<xsl:for-each select="规则:页脚_B644">
					<xsl:attribute name="presentation:use-footer-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
				</xsl:for-each>
				<xsl:attribute name="presentation:use-date-time-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
			</xsl:for-each>
			<xsl:if test="(演:切换_6B1F/演:效果_6B20 and 演:切换_6B1F/演:效果_6B20 !='none') or 演:切换_6B1F/演:声音_6B22">
				<xsl:attribute name="draw:id"><xsl:value-of select="generate-id()"/></xsl:attribute>
			</xsl:if>
			<xsl:for-each select="uof:锚点_C644">
				<xsl:if test="not(uof:占位符_C626/@类型_C627='date' or uof:占位符_C626/@类型_C627='footer' or uof:占位符_C626/@类型_C627='number')">
					<xsl:call-template name="ObjectContent"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="演:动画_6B1A or (演:切换_6B1F/演:效果_6B20 and 演:切换_6B1F/演:效果_6B20 !='none') or 演:切换_6B1F/演:声音_6B22 or (/uof:UOF_0000/规则:公用处理规则_B665/规则:演示文稿_B66D/规则:放映设置_B653/规则:声音_B660 and position()= 1)">
				<xsl:element name="anim:par">
					<xsl:attribute name="presentation:node-type">timing-root</xsl:attribute>
					<xsl:if test="(演:切换_6B1F/演:效果_6B20 and 演:切换_6B1F/演:效果_6B20 !='none') or 演:切换_6B1F/演:声音_6B22">
						<xsl:apply-templates select="演:切换_6B1F"/>
					</xsl:if>
					<!--用幻灯片切换声音模拟背景音乐-->
					<xsl:if test="/uof:UOF_0000/规则:公用处理规则_B665/规则:演示文稿_B66D/规则:放映设置_B653/规则:声音_B660">
						<xsl:element name="anim:par">
							<xsl:attribute name="smil:begin"><xsl:value-of select="concat(generate-id(),'.begin')"/></xsl:attribute>
							<xsl:variable name="VoicePath">
								<xsl:call-template name="TranslateVoicePath">
									<xsl:with-param name="voicetype" select="/uof:UOF_0000/规则:公用处理规则_B665/规则:演示文稿_B66D/规则:放映设置_B653/规则:声音_B660/@预定义声音_C631"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:element name="anim:audio">
								<xsl:choose>
									<xsl:when test="/uof:UOF_0000/规则:公用处理规则_B665/规则:演示文稿_B66D/规则:放映设置_B653/规则:声音_B660/@预定义声音_C631 and /uof:UOF_0000/规则:公用处理规则_B665/规则:演示文稿_B66D/规则:放映设置_B653/规则:声音_B660/@预定义声音_C631 != 'none'">
										<xsl:attribute name="xlink:href"><xsl:value-of select="$VoicePath"/></xsl:attribute>
									</xsl:when>
									<xsl:when test="/uof:UOF_0000/规则:公用处理规则_B665/规则:演示文稿_B66D/规则:放映设置_B653/规则:声音_B660/@自定义声音_C632">
										<xsl:attribute name="xlink:href"><xsl:value-of select="/uof:UOF_0000/规则:公用处理规则_B665/规则:演示文稿_B66D/规则:放映设置_B653/规则:声音_B660/@自定义声音_C632"/></xsl:attribute>
									</xsl:when>
								</xsl:choose>
								<xsl:if test="/uof:UOF_0000/规则:公用处理规则_B665/规则:演示文稿_B66D/规则:放映设置_B653/规则:声音_B660/@是否循环播放_C633 = 'true'">
									<xsl:attribute name="smil:repeatCount">indefinite</xsl:attribute>
								</xsl:if>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:apply-templates select="演:动画_6B1A"/>
				</xsl:element>
			</xsl:if>
			<!-- 目前版本默认幻灯片均有notes，故写出。由此可保证页眉页脚的相关设置 -->
			<xsl:element name="presentation:notes">
				<xsl:for-each select="key('HeaderFooterP','规则:讲义和备注_B64C')">
					<xsl:for-each select="演:页脚_B644">
						<xsl:attribute name="presentation:use-footer-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
					</xsl:for-each>
					<xsl:for-each select="演:页眉_B64D">
						<xsl:attribute name="presentation:use-header-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
					</xsl:for-each>
					<xsl:attribute name="presentation:use-date-time-name"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
				</xsl:for-each>
				<xsl:attribute name="draw:style-name"><xsl:value-of select="concat($SlideName,'_N_draw')"/></xsl:attribute>
				<xsl:for-each select="演:幻灯片备注_6B1D/uof:锚点_C644">
					<xsl:if test="not(uof:占位符_C626/@类型_C627='date' or uof:占位符_C626/@类型_C627='footer' or uof:占位符_C626/@类型_C627='number' or uof:占位符_C626/@类型_C627='header')">
						<xsl:call-template name="ObjectContent"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!--预处理了一个uof:RoGalleryPath元素，存放声音文件路径-->
	<xsl:variable name="RoGalleryPath">
		<xsl:value-of select="/uof:UOF_0000/uof:RoGalleryPath"/>
	</xsl:variable>
	<xsl:template name="TranslateVoicePath">
		<xsl:param name="voicetype"/>
		<xsl:choose>
			<xsl:when test="$voicetype = 'applause'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/applause.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'arrow'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/arrow.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'bomb'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/bomb.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'breeze'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/breeze.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'camera'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/camera.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'cash register'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/cashregister.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'chime'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/chime.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'click'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/click.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'coin'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/coin.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'drum roll'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/drumroll.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'explosion'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/explosion.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'hammer'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/hammer.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'laser'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/laser.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'push'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/push.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'suction'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/suction.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'typewriter'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/typewriter.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'voltage'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/voltage.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'whoosh'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/whoosh.wav')"/>
			</xsl:when>
			<xsl:when test="$voicetype = 'wind'">
				<xsl:value-of select="concat('/',$RoGalleryPath,'/wind.wav')"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="SlideSwitchAtrr">
		<xsl:variable name="switchSpeed">
			<xsl:choose>
				<xsl:when test="演:速度_6B21='slow'">3s</xsl:when>
				<xsl:when test="演:速度_6B21='middle'">2s</xsl:when>
				<xsl:when test="演:速度_6B21='fast'">1s</xsl:when>
				<xsl:otherwise>3s</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="smil:dur"><xsl:value-of select="$switchSpeed"/></xsl:attribute>
		<xsl:if test="演:效果_6B20 and 演:效果_6B20 != 'none'">
			<xsl:variable name="effect">
				<xsl:value-of select="演:效果_6B20"/>
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
				<xsl:when test="$effect='fade smoothly'">
					<xsl:attribute name="smil:type">fade</xsl:attribute>
					<xsl:attribute name="smil:subtype">crossfade</xsl:attribute>
					<xsl:attribute name="smil:fadeColor">#000000</xsl:attribute>
				</xsl:when>
				<xsl:when test="$effect='cut through black'">
					<xsl:attribute name="smil:type">fade</xsl:attribute>
					<xsl:attribute name="smil:subtype">fadeOverColor</xsl:attribute>
					<xsl:attribute name="smil:fadeColor">#000000</xsl:attribute>
				</xsl:when>
				<xsl:when test="$effect='cut'">
					<xsl:attribute name="smil:type">fade</xsl:attribute>
					<xsl:attribute name="smil:subtype">crossfade</xsl:attribute>
					<xsl:attribute name="smil:fadeColor">#000000</xsl:attribute>
				</xsl:when>
				<xsl:when test="$effect='newsflash'">
					<xsl:attribute name="smil:type">fanWipe</xsl:attribute>
					<xsl:attribute name="smil:subtype">centerTop</xsl:attribute>
				</xsl:when>
				<xsl:when test="$effect='strips right-down'">
					<xsl:attribute name="smil:type">waterfallWipe</xsl:attribute>
					<xsl:attribute name="smil:subtype">horizontalLeft</xsl:attribute>
				</xsl:when>
				<xsl:when test="$effect='strips right-up'">
					<xsl:attribute name="smil:type">waterfallWipe</xsl:attribute>
					<xsl:attribute name="smil:subtype">horizontalRight</xsl:attribute>
					<xsl:attribute name="smil:direction">reverse</xsl:attribute>
				</xsl:when>
				<xsl:when test="$effect='strips left-down'">
					<xsl:attribute name="smil:type">waterfallWipe</xsl:attribute>
					<xsl:attribute name="smil:subtype">horizontalRight</xsl:attribute>
				</xsl:when>
				<xsl:when test="$effect='strips left-up'">
					<xsl:attribute name="smil:type">waterfallWipe</xsl:attribute>
					<xsl:attribute name="smil:subtype">horizontalLeft</xsl:attribute>
					<xsl:attribute name="smil:direction">reverse</xsl:attribute>
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
	</xsl:template>
	<xsl:template match="演:切换_6B1F">
		<xsl:element name="anim:par">
			<xsl:variable name="animId">id<xsl:number from="/uof:UOF_0000/演:演示文稿文档_6C10/演:幻灯片集_6C0E" level="any" count="演:幻灯片_6C0F" format="1"/>
			</xsl:variable>
			<xsl:attribute name="smil:begin"><xsl:value-of select="concat($animId,'.begin')"/></xsl:attribute>
			<xsl:if test="演:效果_6B20 and 演:效果_6B20 != 'none'">
				<xsl:element name="anim:transitionFilter">
					<xsl:call-template name="SlideSwitchAtrr"/>
				</xsl:element>
			</xsl:if>
			<xsl:variable name="VoicePath">
				<xsl:call-template name="TranslateVoicePath">
					<xsl:with-param name="voicetype" select="演:声音_6B22/@预定义声音_C631"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="演:声音_6B22">
				<xsl:choose>
					<xsl:when test="演:声音_6B22/@预定义声音_C631 = 'stop previous sound'">
						<anim:command anim:command="stop-audio"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="anim:audio">
							<xsl:choose>
								<xsl:when test="演:声音_6B22/@预定义声音_C631">
									<xsl:attribute name="xlink:href"><xsl:value-of select="$VoicePath"/></xsl:attribute>
								</xsl:when>
								<xsl:when test="演:声音_6B22/@自定义声音_C632">
									<xsl:attribute name="xlink:href"><xsl:value-of select="演:声音_6B22/@自定义声音_C632"/></xsl:attribute>
								</xsl:when>
							</xsl:choose>
							<xsl:if test="是否循环播放_C633 = 'true'">
								<xsl:attribute name="smil:repeatCount">indefinite</xsl:attribute>
							</xsl:if>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template match="演:动画_6B1A">
		<!-- need to access data outside animation, temporary tree, which doesn't use trigger on it -->
		<xsl:variable name="isTrigger">
			<xsl:for-each select="演:序列_6B1B">
				<xsl:if test="演:定时_6B2E/@触发对象引用_6B34">
					<xsl:value-of select="1"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="number($isTrigger) &gt; 0">
				<xsl:for-each-group select="演:序列_6B1B" group-by="演:定时_6B2E[@触发对象引用_6B34 = ''] or not(演:定时_6B2E[@触发对象引用_6B34]) ">
					<xsl:choose>
						<xsl:when test="current-grouping-key()">
							<xsl:variable name="noTrigger">
								<noTrigger>
									<xsl:for-each select="current-group()">
										<xsl:copy>
											<xsl:apply-templates select="@*|node()"/>
										</xsl:copy>
									</xsl:for-each>
								</noTrigger>
							</xsl:variable>
							<anim:seq presentation:node-type="main-sequence">
								<xsl:for-each select="$noTrigger/noTrigger/演:序列_6B1B[1]">
									<xsl:variable name="begin1">
										<xsl:choose>
											<xsl:when test="演:定时_6B2E/@事件_6B2F = 'with-previous' or 演:定时_6B2E/@事件_6B2F = 'after-previous'">0s</xsl:when>
											<xsl:otherwise>next</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="begin2" select="'0s'"/>
									<xsl:call-template name="OneSequence">
										<xsl:with-param name="begin1" select="$begin1"/>
										<xsl:with-param name="begin2" select="$begin2"/>
									</xsl:call-template>
								</xsl:for-each>
							</anim:seq>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="current-group()">
								<anim:seq presentation:node-type="interactive-sequence">
									<anim:par>
										<xsl:attribute name="smil:begin"><xsl:value-of select="concat(演:定时_6B2E/@触发对象引用_6B34,'.click')"/></xsl:attribute>
										<anim:par smil:begin="0s">
											<xsl:variable name="animNodeName">
												<xsl:choose>
													<xsl:when test="./演:增强_6B35/演:动画文本_6B3A/@发送_6B3B">anim:iterate</xsl:when>
													<xsl:otherwise>anim:par</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="演:效果_6B40 or 演:定时_6B2E or 演:增强_6B35">
													<xsl:element name="{$animNodeName}">
														<xsl:attribute name="smil:fill"><xsl:choose><xsl:when test="演:定时_6B2E/@是否回卷_6B33='true'">remove</xsl:when><xsl:otherwise>hold</xsl:otherwise></xsl:choose></xsl:attribute>
														<xsl:choose>
															<xsl:when test="./演:增强_6B35/演:动画播放后_6B36/演:是否播放后隐藏_6B38 = 'true'">
																<xsl:attribute name="anim:id">animId<xsl:number from="/uof:UOF_0000/演:演示文稿文档_6C10/演:幻灯片集_6C0E/演:幻灯片_6C0F/演:动画_6B1A" level="any" count="演:序列_6B1B" format="1"/></xsl:attribute>
															</xsl:when>
														</xsl:choose>
														<xsl:attribute name="presentation:node-type">on-click</xsl:attribute>
														<xsl:attribute name="smil:begin"><xsl:choose><xsl:when test="./演:定时_6B2E/@延时_6B30"><xsl:value-of select="concat(substring(演:定时_6B2E/@延时_6B30,3,1),'s')"/></xsl:when><xsl:otherwise>0s</xsl:otherwise></xsl:choose></xsl:attribute>
														<xsl:choose>
															<xsl:when test="演:定时_6B2E/@重复_6B32='until next click' ">
																<xsl:attribute name="smil:repeatCount">indefinite</xsl:attribute>
																<xsl:attribute name="smil:end">next</xsl:attribute>
															</xsl:when>
															<xsl:when test="演:定时_6B2E/@重复_6B32='until end of slide' ">
																<xsl:attribute name="smil:repeatCount">indefinite</xsl:attribute>
															</xsl:when>
															<xsl:when test="演:定时_6B2E/@重复_6B32 !='none'">
																<xsl:attribute name="smil:repeatCount"><xsl:value-of select="演:定时_6B2E/@重复_6B32"/></xsl:attribute>
															</xsl:when>
														</xsl:choose>
														<xsl:if test="演:增强_6B35/演:动画文本_6B3A/@发送_6B3B">
															<xsl:attribute name="anim:sub-item">text</xsl:attribute>
															<xsl:attribute name="anim:iterate-type"><xsl:choose><xsl:when test="演:增强_6B35/演:动画文本_6B3A/@发送_6B3B='by word'">by-word</xsl:when><xsl:when test="演:增强_6B35/演:动画文本_6B3A/@发送_6B3B='by letter'">by-letter</xsl:when><xsl:otherwise>all at once</xsl:otherwise></xsl:choose></xsl:attribute>
															<xsl:attribute name="smil:targetElement"><xsl:value-of select="@对象引用_6C28"/></xsl:attribute>
															<xsl:attribute name="anim:iterate-interval"><xsl:choose><xsl:when test="./演:增强_6B35/演:动画文本_6B3A/@演:间隔"><xsl:value-of select="concat(substring(./演:增强_6B35/演:动画文本_6B3A/@间隔_6B3C,3,1),'s')"/></xsl:when><xsl:otherwise>0.05s</xsl:otherwise></xsl:choose></xsl:attribute>
														</xsl:if>
														<xsl:choose>
															<xsl:when test="演:效果_6B40/演:进入_6B41">
																<xsl:apply-templates select="演:效果_6B40/演:进入_6B41/*/*[1]" mode="entrance"/>
															</xsl:when>
															<xsl:when test="演:效果_6B40/演:退出_6BBE">
																<xsl:apply-templates select="演:效果_6B40/演:退出_6BBE/*/*[1]" mode="exit"/>
															</xsl:when>
															<xsl:when test="演:效果_6B40/演:强调_6B07">
																<xsl:apply-templates select="演:效果_6B40/演:强调_6B07/*/*[1]" mode="emphasis"/>
															</xsl:when>
														</xsl:choose>
														<xsl:if test="演:增强_6B35/演:声音_6B22">
															<xsl:variable name="VoicePath">
																<xsl:call-template name="TranslateVoicePath">
																	<xsl:with-param name="voicetype" select="演:增强_6B35/演:声音_6B22/@预定义声音_C631"/>
																</xsl:call-template>
															</xsl:variable>
															<xsl:choose>
																<xsl:when test="演:增强_6B35/演:声音_6B22/@预定义声音_C631 = 'stop previous sound'">
																	<anim:command anim:command="stop-audio"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:element name="anim:audio">
																		<xsl:choose>
																			<xsl:when test="演:增强_6B35/演:声音_6B22/@预定义声音_C631">
																				<xsl:attribute name="xlink:href"><xsl:value-of select="$VoicePath"/></xsl:attribute>
																			</xsl:when>
																			<xsl:when test="演:增强_6B35/演:声音_6B22/@自定义声音_C632">
																				<xsl:attribute name="xlink:href"><xsl:value-of select="演:增强_6B35/演:声音_6B22/@自定义声音_C632"/></xsl:attribute>
																			</xsl:when>
																		</xsl:choose>
																		<xsl:if test="演:增强_6B35/演:声音_6B22/@是否循环播放_C633 = 'true'">
																			<xsl:attribute name="smil:repeatCount">indefinite</xsl:attribute>
																		</xsl:if>
																	</xsl:element>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
													</xsl:element>
													<xsl:if test="./演:增强_6B35/演:动画播放后_6B36/演:是否播放后隐藏_6B38 = 'true'">
														<anim:set smil:begin="animID" smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
															<xsl:attribute name="smil:begin">animId<xsl:number from="/uof:UOF_0000/演:演示文稿文档_6C10/演:幻灯片集_6C0E/演:幻灯片_6C0F/演:动画_6B1A" level="any" count="演:序列_6B1B" format="1"/>.end</xsl:attribute>
															<xsl:attribute name="smil:targetElement"><xsl:value-of select="@对象引用_6C28"/></xsl:attribute>
														</anim:set>
													</xsl:if>
												</xsl:when>
											</xsl:choose>
										</anim:par>
									</anim:par>
									<xsl:if test="./演:增强_6B35/演:动画播放后_6B36/演:颜色_6B37">
										<anim:par smil:begin="next">
											<anim:par smil:begin="0s">
												<anim:animateColor smil:begin="0s" smil:dur="0.001s" smil:fill="hold" anim:color-interpolation="rgb" anim:color-interpolation-direction="clockwise" smil:attributeName="dim">
													<xsl:attribute name="smil:targetElement"><xsl:value-of select="@对象引用_6C28"/></xsl:attribute>
													<xsl:attribute name="smil:to"><xsl:choose><xsl:when test="演:增强_6B35/演:动画播放后_6B36/演:颜色_6B37"><xsl:value-of select="演:增强_6B35/演:动画播放后_6B36/演:颜色_6B37"/></xsl:when></xsl:choose></xsl:attribute>
												</anim:animateColor>
											</anim:par>
										</anim:par>
									</xsl:if>
									<xsl:if test="./演:增强_6B35/演:动画播放后_6B36/演:是否单击后隐藏_6B39 = 'true'">
										<anim:par smil:begin="next">
											<anim:par smil:begin="0s">
												<anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
													<xsl:attribute name="smil:targetElement"><xsl:value-of select="@对象引用_6C28"/></xsl:attribute>
												</anim:set>
											</anim:par>
										</anim:par>
									</xsl:if>
								</anim:seq>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each-group>
			</xsl:when>
			<xsl:otherwise>
				<anim:seq presentation:node-type="main-sequence">
					<xsl:for-each select="演:序列_6B1B[1]">
						<xsl:variable name="begin1">
							<xsl:choose>
								<xsl:when test="演:定时_6B2E/@事件_6B2F = 'with-previous' or 演:定时_6B2E/@事件_6B2F = 'after-previous'">0s</xsl:when>
								<xsl:otherwise>next</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="begin2" select="'0s'"/>
						<xsl:call-template name="OneSequence">
							<xsl:with-param name="begin1" select="$begin1"/>
							<xsl:with-param name="begin2" select="$begin2"/>
						</xsl:call-template>
					</xsl:for-each>
				</anim:seq>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template name="OneSequence">
		<xsl:param name="begin1"/>
		<xsl:param name="begin2"/>
		<xsl:if test="$begin1 != 'no'">
			<xsl:text disable-output-escaping="yes">&lt;anim:par smil:begin=&quot;</xsl:text>
			<xsl:value-of select="$begin1"/>
			<xsl:text disable-output-escaping="yes">&quot;&gt;</xsl:text>
		</xsl:if>
		<xsl:if test="$begin2 != 'no'">
			<xsl:text disable-output-escaping="yes">&lt;anim:par smil:begin=&quot;</xsl:text>
			<xsl:value-of select="$begin2"/>
			<xsl:text disable-output-escaping="yes">&quot;&gt;</xsl:text>
		</xsl:if>
		<xsl:call-template name="Animation"/>
		<xsl:variable name="NextEvent" select="following-sibling::*[1]/演:定时_6B2E/@事件_6B2F"/>
		<xsl:choose>
			<xsl:when test="$NextEvent = 'with-previous'">
				<xsl:for-each select="following-sibling::*[1]">
					<xsl:call-template name="OneSequence">
						<xsl:with-param name="begin1" select="'no'"/>
						<xsl:with-param name="begin2" select="'no'"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$NextEvent = 'after-previous'">
				<xsl:text disable-output-escaping="yes">&lt;/anim:par&gt;</xsl:text>
				<xsl:for-each select="following-sibling::*[1]">
					<xsl:variable name="aDelay">
						<xsl:value-of select="substring-after(substring-before(preceding-sibling::*[last()]/演:定时_6B2E/@延时_6B30,'S'),'PT')"/>
					</xsl:variable>
					<xsl:variable name="aSpeed">
						<xsl:call-template name="aSpeedTranstration">
							<xsl:with-param name="speed" select="preceding-sibling::*[last()]/演:效果_6B40//速度_6B44"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:call-template name="OneSequence">
						<xsl:with-param name="begin1" select="'no'"/>
						<xsl:with-param name="begin2" select="concat(number($aDelay)+number($aSpeed),'s')"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$NextEvent = 'on-click'">
				<xsl:text disable-output-escaping="yes">&lt;/anim:par&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;/anim:par&gt;</xsl:text>
				<xsl:for-each select="following-sibling::*[1]">
					<xsl:call-template name="OneSequence">
						<xsl:with-param name="begin1" select="'next'"/>
						<xsl:with-param name="begin2" select="'0s'"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="following-sibling::*[1]">
				<xsl:text disable-output-escaping="yes">&lt;/anim:par&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;/anim:par&gt;</xsl:text>
				<xsl:for-each select="following-sibling::*[1]">
					<xsl:call-template name="OneSequence">
						<xsl:with-param name="begin1" select="'next'"/>
						<xsl:with-param name="begin2" select="'0s'"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text disable-output-escaping="yes">&lt;/anim:par&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;/anim:par&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Animation">
		<xsl:variable name="animNodeName">
			<xsl:choose>
				<xsl:when test="演:增强_6B35/演:动画文本_6B3A/@发送_6B3B">anim:iterate</xsl:when>
				<xsl:otherwise>anim:par</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="aEvent">
			<xsl:choose>
				<xsl:when test="演:定时_6B2E/@事件_6B2F='on-click'">on-click</xsl:when>
				<xsl:when test="演:定时_6B2E/@事件_6B2F='after-previous'">after-previous</xsl:when>
				<xsl:when test="演:定时_6B2E/@事件_6B2F='with-previous'">with-previous</xsl:when>
				<xsl:otherwise>on-click</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$animNodeName}">
			<xsl:attribute name="smil:fill"><xsl:choose><xsl:when test="演:定时_6B2E/@是否回卷_6B33='true'">remove</xsl:when><xsl:otherwise>hold</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:choose>
				<xsl:when test="演:增强_6B35">
					<xsl:attribute name="anim:id"><xsl:value-of select="concat('id',generate-id())"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:attribute name="presentation:node-type"><xsl:value-of select="$aEvent"/></xsl:attribute>
			<xsl:attribute name="smil:begin"><xsl:choose><xsl:when test="演:定时_6B2E/@延时_6B30"><xsl:value-of select="concat(substring(演:定时_6B2E/@延时_6B30,3,1),'s')"/></xsl:when><xsl:otherwise>0s</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:choose>
				<xsl:when test="演:定时_6B2E/@重复_6B32='until next click' ">
					<xsl:attribute name="smil:repeatCount">indefinite</xsl:attribute>
					<xsl:attribute name="smil:end">next</xsl:attribute>
				</xsl:when>
				<xsl:when test="演:定时_6B2E/@重复_6B32='until end of slide' ">
					<xsl:attribute name="smil:repeatCount">indefinite</xsl:attribute>
				</xsl:when>
				<xsl:when test="演:定时_6B2E/@重复_6B32 !='none'">
					<xsl:attribute name="smil:repeatCount"><xsl:value-of select="演:定时_6B2E/@重复_6B32"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="演:增强_6B35/演:动画文本_6B3A/@发送_6B3B">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
				<xsl:attribute name="anim:iterate-type"><xsl:choose><xsl:when test="演:增强_6B35/演:动画文本_6B3A/@发送_6B3B='by word'">by-word</xsl:when><xsl:when test="演:增强_6B35/演:动画文本_6B3A/@发送_6B3B='by letter'">by-letter</xsl:when><xsl:otherwise>all at once</xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:attribute name="smil:targetElement"><xsl:value-of select="@对象引用_6C28"/></xsl:attribute>
				<xsl:attribute name="anim:iterate-interval"><xsl:choose><xsl:when test="演:增强_6B35/演:动画文本_6B3A/@间隔_6B3C"><xsl:value-of select="concat(substring(演:增强_6B35/演:动画文本_6B3A/@间隔_6B3C,3,1),'s')"/></xsl:when><xsl:otherwise>0.05s</xsl:otherwise></xsl:choose></xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="演:效果_6B40/演:进入_6B41">
					<xsl:apply-templates select="演:效果_6B40/演:进入_6B41/*/*[1]" mode="entrance"/>
				</xsl:when>
				<xsl:when test="演:效果_6B40/演:退出_6BBE">
					<xsl:apply-templates select="演:效果_6B40/演:退出_6BBE/*/*[1]" mode="exit"/>
				</xsl:when>
				<xsl:when test="演:效果_6B40/演:强调_6B07">
					<xsl:apply-templates select="演:效果_6B40/演:强调_6B07/*/*[1]" mode="emphasis"/>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="演:增强_6B35/演:声音_6B22">
				<xsl:variable name="VoicePath">
					<xsl:call-template name="TranslateVoicePath">
						<xsl:with-param name="voicetype" select="演:增强_6B35/演:声音_6B22/@预定义声音_C631"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="演:增强/演:声音/@预定义声音_C631 = 'stop previous sound'">
						<anim:command anim:command="stop-audio"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="anim:audio">
							<xsl:choose>
								<xsl:when test="演:增强_6B35/演:声音_6B22/@预定义声音_C631">
									<xsl:attribute name="xlink:href"><xsl:value-of select="$VoicePath"/></xsl:attribute>
								</xsl:when>
								<xsl:when test="演:增强_6B35/演:声音_6B22/@自定义声音_C632">
									<xsl:attribute name="xlink:href"><xsl:value-of select="演:增强_6B35/演:声音_6B22/@自定义声音_C632"/></xsl:attribute>
								</xsl:when>
							</xsl:choose>
							<xsl:if test="演:增强_6B35/演:声音_6B22/@是否循环播放_C633 = 'true'">
								<xsl:attribute name="smil:repeatCount">indefinite</xsl:attribute>
							</xsl:if>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:element>
		<xsl:choose>
			<xsl:when test="演:增强_6B35/演:动画播放后_6B36/演:是否播放后隐藏_6B38 = 'true'">
				<xsl:call-template name="Hidden">
					<xsl:with-param name="begin" select="'no'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="演:增强_6B35/演:动画播放后_6B36/演:是否单击后隐藏_6B39 = 'true'">
				<xsl:call-template name="Hidden">
					<xsl:with-param name="begin" select="'next'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="演:增强_6B35/演:动画播放后_6B36/演:颜色_6B37">
				<xsl:call-template name="AnimColor"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Hidden">
		<xsl:param name="begin"/>
		<anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:choose>
				<xsl:when test="$begin = 'no'">
					<xsl:attribute name="smil:begin"><xsl:value-of select="concat('id',generate-id(),'.end')"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="$begin = 'next'">
					<xsl:attribute name="smil:begin">next</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:attribute name="presentation:master-element"><xsl:value-of select="concat('id',generate-id())"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template name="AnimColor">
		<anim:animateColor smil:begin="next" smil:dur="0.001s" smil:fill="hold" anim:color-interpolation="rgb" anim:color-interpolation-direction="clockwise" smil:attributeName="dim">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:to"><xsl:if test="演:增强_6B35/演:动画播放后_6B36/演:颜色_6B37"><xsl:value-of select="演:增强_6B35/演:动画播放后_6B36/演:颜色_6B37"/></xsl:if></xsl:attribute>
			<xsl:attribute name="presentation:master-element"><xsl:value-of select="concat('id',generate-id())"/></xsl:attribute>
		</anim:animateColor>
	</xsl:template>
	<xsl:template name="aSpeedTranstration">
		<xsl:param name="speed"/>
		<xsl:choose>
			<xsl:when test="$speed='very-fast'">0.5</xsl:when>
			<xsl:when test="$speed='fast'">1</xsl:when>
			<xsl:when test="$speed='medium'">2</xsl:when>
			<xsl:when test="$speed='slow'">3</xsl:when>
			<xsl:when test="$speed='very-slow'">5</xsl:when>
			<xsl:otherwise>0.5</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="演:出现_6B46" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-appear</xsl:attribute>
		<anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" anim:sub-item="text" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:盒状_6B47" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-box</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B48"><xsl:value-of select="@方向_6B48"/></xsl:when><xsl:otherwise>in</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:dur="0.004s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<!-- It's not which kinds of types, graphics or text, to be judged. But it doesn't affect the effect. -->
			<!--xsl:if test="ancestor::演:序列/@演:段落引用">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
			</xsl:if-->
		</anim:set>
		<anim:transitionFilter smil:type="irisWipe" smil:subtype="rectangle">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:if test="@方向_6B48 = 'in'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
			<!--xsl:if test="ancestor::演:序列/@演:段落引用">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
			</xsl:if-->
		</anim:transitionFilter>
	</xsl:template>
	<xsl:template match="演:棋盘_6B4E" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-checkerboard</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B50='down'">downward</xsl:when><xsl:when test="@方向_6B50='across'">across</xsl:when><xsl:otherwise>across</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<anim:transitionFilter smil:type="checkerBoardWipe">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@方向_6B50='down'">down</xsl:when><xsl:when test="@方向_6B50='across'">across</xsl:when><xsl:otherwise>across</xsl:otherwise></xsl:choose></xsl:attribute>
		</anim:transitionFilter>
	</xsl:template>
	<xsl:template match="演:圆形扩展_6B56" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-circle</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B48"><xsl:value-of select="@方向_6B48"/></xsl:when><xsl:otherwise>in</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<anim:transitionFilter smil:type="ellipseWipe" smil:subtype="horizontal">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:if test="@方向_6B48='in'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
		</anim:transitionFilter>
	</xsl:template>
	<xsl:template match="演:阶梯状_6B49" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-diagonal-squares</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B4A='left down'">left-to-bottom</xsl:when><xsl:when test="@方向_6B4A='left up'">left-to-top</xsl:when><xsl:when test="@方向_6B4A='right down'">right-to-bottom</xsl:when><xsl:when test="@方向_6B4A='right up'">right-to-top</xsl:when><xsl:otherwise>left-to-bottom</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<anim:transitionFilter smil:type="waterfallWipe">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="@方向_6B4A='left down'">
					<xsl:attribute name="smil:subtype">horizontalRight</xsl:attribute>
				</xsl:when>
				<xsl:when test="@方向_6B4A='left up'">
					<xsl:attribute name="smil:subtype">horizontalLeft</xsl:attribute>
					<xsl:attribute name="smil:direction">reverse</xsl:attribute>
				</xsl:when>
				<xsl:when test="@方向_6B4A='right up'">
					<xsl:attribute name="smil:subtype">horizontalRight</xsl:attribute>
					<xsl:attribute name="smil:direction">reverse</xsl:attribute>
				</xsl:when>
				<xsl:when test="@方向_6B4A='right down'">
					<xsl:attribute name="smil:subtype">horizontalLeft</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="smil:subtype">horizontalRight</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<!--xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@方向='left down'">horizontalLeft</xsl:when><xsl:when test="@方向='left up'">horizontalLeft</xsl:when><xsl:when test="@方向='right down'">horizontalRight</xsl:when><xsl:when test="@方向='right up'">horizontalRight</xsl:when></xsl:choose></xsl:attribute-->
		</anim:transitionFilter>
	</xsl:template>
	<xsl:template match="演:菱形_6B5D" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-diamond</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B48"><xsl:value-of select="@方向_6B48"/></xsl:when><xsl:otherwise>in</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<anim:transitionFilter smil:type="irisWipe" smil:subtype="diamond">
			<xsl:choose>
				<xsl:when test="@方向_6B48">
					<xsl:if test="@方向_6B48 = 'in'">
						<xsl:attribute name="smil:direction">reverse</xsl:attribute>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="smil:direction">reverse</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:transitionFilter>
	</xsl:template>
	<!-- ooo:entrance dissolve-in, uof1, NeiXiangRongJie(p0098) -->
	<xsl:template match="演:向内溶解_6B64" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-dissolve-in</xsl:attribute>
		<anim:set smil:begin="0s" smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<anim:transitionFilter smil:type="dissolve" smil:direction="reverse">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:transitionFilter>
	</xsl:template>
	<!-- ooo:entrance flash-once, uof1, ShanShuoYiCi(p0086) -->
	<xsl:template match="演:闪烁一次_6B51" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-flash-once</xsl:attribute>
		<anim:set smil:begin="0s" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_fast"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<!-- ooo:entrance fly-in, uof1, FeiRu(p0091) -->
	<xsl:template match="演:飞入_6B59" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-fly-in</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B5A= 'from bottom'">from-bottom</xsl:when><xsl:when test="@方向_6B5A = 'from top-right'">from-top-right</xsl:when><xsl:when test="@方向_6B5A = 'from top-left'">from-top-left</xsl:when><xsl:when test="@方向_6B5A = 'from bottom-left'">from-bottom-left</xsl:when><xsl:when test="@方向_6B5A = 'from bottom-right'">from-bottom-right</xsl:when><xsl:when test="@方向_6B5A = 'from right'">from-right</xsl:when><xsl:when test="@方向_6B5A = 'from left'">from-left</xsl:when><xsl:when test="@方向_6B5A = 'from top'">from-top</xsl:when><xsl:otherwise>from-bottom</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<xsl:variable name="smilvalueX">
			<xsl:choose>
				<xsl:when test="contains(@方向_6B5A,'right')">1+width/2;x</xsl:when>
				<xsl:when test="contains(@方向_6B5A,'left')">0-width/2;x</xsl:when>
				<xsl:otherwise>x;x</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="smilvalueY">
			<xsl:choose>
				<xsl:when test="@方向_6B5A">
					<xsl:choose>
						<xsl:when test="contains(@方向_6B5A,'bottom')">1+height/2;y</xsl:when>
						<xsl:when test="contains(@方向_6B5A,'top')">0-height/2;y</xsl:when>
						<xsl:otherwise>y;y</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>1+height/2;y</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<anim:animate smil:fill="hold" smil:attributeName="x" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueX"/></xsl:attribute>
		</anim:animate>
		<anim:animate smil:fill="hold" smil:attributeName="y" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueY"/></xsl:attribute>
		</anim:animate>
	</xsl:template>
	<xsl:template match="演:缓慢进入_6B5B" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-fly-in-slow</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B58= 'from bottom'">from-bottom</xsl:when><xsl:when test="@方向_6B58 = 'from right'">from-right</xsl:when><xsl:when test="@方向_6B58 = 'from left'">from-left</xsl:when><xsl:when test="@方向_6B58 = 'from top'">from-top</xsl:when><xsl:otherwise>from-bottom</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<xsl:variable name="smilvalueX">
			<xsl:choose>
				<xsl:when test="contains(@方向_6B58,'right')">1+width/2;x</xsl:when>
				<xsl:when test="contains(@方向_6B58,'left')">0-width/2;x</xsl:when>
				<xsl:otherwise>x;x</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="smilvalueY">
			<xsl:choose>
				<xsl:when test="@方向_6B58">
					<xsl:choose>
						<xsl:when test="contains(@方向_6B58,'bottom')">1+height/2;y</xsl:when>
						<xsl:when test="contains(@方向_6B58,'top')">0-height/2;y</xsl:when>
						<xsl:otherwise>y;y</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>1+height/2;y</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<anim:animate smil:fill="hold" smil:attributeName="x" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_veryslow"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueX"/></xsl:attribute>
		</anim:animate>
		<anim:animate smil:fill="hold" smil:attributeName="y" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_veryslow"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueY"/></xsl:attribute>
		</anim:animate>
	</xsl:template>
	<!-- ooo:entrance peek-in, uof1, QieRu(p0095) -->
	<xsl:template match="演:切入_6B60" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-peek-in</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B58= 'from bottom'">from-bottom</xsl:when><xsl:when test="@方向_6B58 = 'from right'">from-right</xsl:when><xsl:when test="@方向_6B58 = 'from left'">from-left</xsl:when><xsl:when test="@方向_6B58 = 'from top'">from-top</xsl:when><xsl:otherwise>from bottom</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<!--xsl:if test="ancestor::演:序列/@演:段落引用">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
			</xsl:if-->
		</anim:set>
		<anim:transitionFilter smil:type="slideWipe" smil:direction="reverse">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@方向_6B58= 'from bottom'">fromBottom</xsl:when><xsl:when test="@方向_6B58 = 'from right'">fromRight</xsl:when><xsl:when test="@方向_6B58 = 'from left'">fromLeft</xsl:when><xsl:when test="@方向_6B58 = 'from top'">fromTop</xsl:when></xsl:choose></xsl:attribute>
			<!--xsl:if test="ancestor::演:序列/@演:段落引用">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
			</xsl:if-->
		</anim:transitionFilter>
	</xsl:template>
	<!-- ooo:entrance plus, uof1, ShiZiXingKuoZhan(p0087) -->
	<xsl:template match="演:十字形扩展_6B53" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-plus</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B48"><xsl:value-of select="@方向_6B48"/></xsl:when><xsl:otherwise>in</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<anim:transitionFilter smil:type="fourBoxWipe" smil:subtype="cornersIn">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<!--xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@方向= 'in'">cornersIn</xsl:when><xsl:when test="@方向 = 'out'">cornersOut</xsl:when></xsl:choose></xsl:attribute-->
			<xsl:if test="@方向_6B48= 'out'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
		</anim:transitionFilter>
	</xsl:template>
	<!-- ooo:entrance random bars, uof1, SuiJiXianTiao(p0097) -->
	<xsl:template match="演:随机线条_6B62" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-random-bars</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B45"><xsl:value-of select="@方向_6B45"/></xsl:when><xsl:otherwise>horizontal</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<anim:transitionFilter smil:type="randomBarWipe" smil:direction="reverse">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@方向_6B45= 'horizontal'">vertical</xsl:when><xsl:when test="@方向_6B45 = 'vertical'">horizontal</xsl:when><xsl:otherwise>vertical</xsl:otherwise></xsl:choose></xsl:attribute>
		</anim:transitionFilter>
	</xsl:template>
	<!-- ooo:entrance split , uof1, PiLie(p0094) -->
	<xsl:template match="演:劈裂_6B5E" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-split</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B5F = 'horizontal out'">horizontal-out</xsl:when><xsl:when test="@方向_6B5F= 'horizontal in'">horizontal-in</xsl:when><xsl:when test="@方向_6B5F= 'vertical in'">vertical-in</xsl:when><xsl:when test="@方向_6B5F= 'vertical out'">vertical-out</xsl:when><xsl:otherwise>horizontal-out</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<!--xsl:if test="ancestor::演:序列/@演:段落引用">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
			</xsl:if-->
		</anim:set>
		<anim:transitionFilter smil:type="barnDoorWipe">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@方向_6B5F = 'horizontal out'">horizontal</xsl:when><xsl:when test="@方向_6B5F= 'horizontal in'">horizontal</xsl:when><xsl:when test="@方向_6B5F= 'vertical in'">vertical</xsl:when><xsl:when test="@方向_6B5F= 'vertical out'">vertical</xsl:when></xsl:choose></xsl:attribute>
			<xsl:if test="@方向_6B5F= 'horizontal in' or @方向_6B5F= 'vertical in'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
			<!--xsl:if test="ancestor::演:序列/@演:段落引用">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
			</xsl:if-->
		</anim:transitionFilter>
	</xsl:template>
	<!-- ooo:entrance venetian-blinds, uof1, BaiYeChuang(p0080) -->
	<xsl:template match="演:百叶窗_6B43" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-venetian-blinds</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B45= 'horizontal'">horizontal</xsl:when><xsl:when test="@方向_6B45 = 'vertical'">vertical</xsl:when><xsl:otherwise>vertical</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<anim:transitionFilter smil:type="blindsWipe" smil:direction="reverse">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@方向_6B45= 'horizontal'">vertical</xsl:when><xsl:when test="@方向_6B45 = 'vertical'">horizontal</xsl:when><xsl:otherwise>horizontal</xsl:otherwise></xsl:choose></xsl:attribute>
		</anim:transitionFilter>
	</xsl:template>
	<!-- ooo:entrance wedge, uof1, ShanXingZhanKai(p0096) -->
	<xsl:template match="演:扇形展开_6B61" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-wedge</xsl:attribute>
		<anim:set smil:begin="0s" smil:dur="0.0015s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<anim:transitionFilter smil:type="fanWipe" smil:subtype="centerTop">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
		</anim:transitionFilter>
	</xsl:template>
	<!-- ooo:entrance wheel, uof1, LunZi(p0084) -->
	<xsl:template match="演:轮子_6B4B" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-wheel</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@轮辐_6B4D"><xsl:value-of select="@轮辐_6B4D"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<anim:transitionFilter smil:dur="0.5s" smil:type="pinWheelWipe">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@轮辐_6B4D='1'">oneBlade</xsl:when><xsl:when test="@轮辐_6B4D='2'">twoBladeVertical</xsl:when><xsl:when test="@轮辐_6B4D='3'">threeBlade</xsl:when><xsl:when test="@轮辐_6B4D='4'">fourBlade</xsl:when><xsl:when test="@轮辐_6B4D='8'">eightBlade</xsl:when><xsl:otherwise>oneBlade</xsl:otherwise></xsl:choose></xsl:attribute>
		</anim:transitionFilter>
	</xsl:template>
	<!-- ooo:entrance wipe, uof1, CaChu(p0090) -->
	<xsl:template match="演:擦除_6B57" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-wipe</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B58 = 'from right'">from-right</xsl:when><xsl:when test="@方向_6B58 = 'from left'">from-left</xsl:when><xsl:when test="@方向_6B58 = 'from top'">from-top</xsl:when><xsl:when test="@方向_6B58 = 'from bottom'">from-bottom</xsl:when><xsl:otherwise>from-left</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:set smil:begin="0s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<anim:transitionFilter smil:type="barWipe">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="(@方向_6B58 = 'from right') or (@方向_6B58 = 'from left')">leftToRight</xsl:when><xsl:when test="(@方向_6B58 = 'from top') or (@方向_6B58 = 'from bottom')">topToBottom</xsl:when><xsl:otherwise>leftToRight</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:if test="@方向_6B58='from right'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
			<xsl:if test="@方向_6B58='from bottom'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
		</anim:transitionFilter>
	</xsl:template>
	<!-- ooo:entrance random, uof1, SuiJiXiaoGuo(p0088) -->
	<xsl:template match="演:随机效果_6B55" mode="entrance">
		<xsl:attribute name="presentation:preset-class">entrance</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-entrance-random</xsl:attribute>
		<anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="visible">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
		<anim:animate smil:dur="1s" smil:fill="hold" smil:attributeName="width" smil:values="0;width" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
		</anim:animate>
		<anim:animate smil:fill="hold" smil:attributeName="height" smil:values="0;height" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
		</anim:animate>
		<anim:animate smil:fill="hold" smil:attributeName="rotate" smil:values="90;0" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
		</anim:animate>
		<anim:transitionFilter smil:type="fade" smil:subtype="crossfade">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
		</anim:transitionFilter>
	</xsl:template>
	<!-- emphasis animation types , starting -->
	<!-- Change FillColor , uof1, GengGaiTianChongYanSe(p0124) -->
	<xsl:template match="演:更改填充颜色_6B9F" mode="emphasis">
		<xsl:attribute name="presentation:preset-class">emphasis</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-emphasis-fill-color</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type">2</xsl:attribute>
		<anim:animateColor smil:fill="hold" smil:attributeName="fill-color" presentation:additive="base" anim:color-interpolation="rgb" anim:color-interpolation-direction="clockwise">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:to"><xsl:value-of select="@颜色_6B95"/></xsl:attribute>
		</anim:animateColor>
		<anim:set smil:dur="0.5s" smil:fill="hold" smil:attributeName="fill" smil:to="solid">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<!-- Change FontColor, uof1, GengGaiZiTiYanSe(p0126) -->
	<xsl:template match="演:更改字体颜色_6BA2" mode="emphasis">
		<xsl:attribute name="presentation:preset-class">emphasis</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-emphasis-font-color</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type">2</xsl:attribute>
		<anim:animateColor smil:fill="hold" anim:sub-item="text" smil:attributeName="color" presentation:additive="base" anim:color-interpolation="rgb" anim:color-interpolation-direction="clockwise">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:to"><xsl:value-of select="@颜色_6B95"/></xsl:attribute>
		</anim:animateColor>
	</xsl:template>
	<!-- Change FontSize( Zoom in ), uof1, GengGaiZiHao(p0125)/SuoFang(p0120) -->
	<xsl:template match="演:更改字号_6BA0" mode="emphasis">
		<xsl:attribute name="presentation:preset-class">emphasis</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-emphasis-font-size</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type">2</xsl:attribute>
		<anim:animate smil:fill="hold" smil:attributeName="font-size" presentation:additive="base" anim:sub-item="text">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:to"><xsl:choose><xsl:when test="@预定义尺寸_6B92='tiny' ">0.25pt</xsl:when><xsl:when test="@预定义尺寸_6B92='smaller' ">0.5pt</xsl:when><xsl:when test="@预定义尺寸_6B92='larger' ">1.5pt</xsl:when><xsl:when test="@预定义尺寸_6B92='huge' ">4pt</xsl:when><xsl:when test="@自定义尺寸_6B93"><xsl:value-of select="concat(@自定义尺寸_6B93 div 100,'pt')"/></xsl:when><xsl:otherwise>1pt</xsl:otherwise></xsl:choose></xsl:attribute>
		</anim:animate>
	</xsl:template>
	<!-- here is about styles content, no changed -->
	<xsl:template match="演:更改字形_6B96" mode="emphasis">
		<xsl:attribute name="presentation:preset-class">emphasis</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-emphasis-font-style</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type">1</xsl:attribute>
		<xsl:variable name="FontStyleName">
			<xsl:value-of select="@字形_6B97"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@名称_4101 = $FontStyleName]/字:字体_4128">
				<anim:set anim:sub-item="text" smil:attributeName="font-family">
					<xsl:attribute name="smil:dur"><xsl:choose><xsl:when test="@期间_6B98 = 'until-next-click'">until next click</xsl:when><xsl:when test="@期间_6B98 = 'until-end-of-slide'">indefinite</xsl:when><xsl:otherwise><xsl:value-of select="concat(@期间_6B98,'s')"/></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
					<xsl:variable name="fontname" select="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@名称_4101 = $FontStyleName]/字:字体_4128/@中文字体引用_412A"/>
					<xsl:attribute name="smil:to"><xsl:value-of select="/uof:UOF_0000/式样:式样集_990B/式样:字体集_990C/式样:字体声明_990D[@标识符_9902 = $fontname]/@名称_9903"/></xsl:attribute>
				</anim:set>
			</xsl:when>
			<xsl:otherwise>
				<anim:set anim:sub-item="text" smil:attributeName="font-style">
					<xsl:attribute name="smil:dur"><xsl:choose><xsl:when test="@期间_6B98 = 'until-next-click'">until next click</xsl:when><xsl:when test="@期间_6B98 = 'until-end-of-slide'">indefinite</xsl:when><xsl:otherwise><xsl:value-of select="concat(@期间_6B98,'s')"/></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
					<xsl:attribute name="smil:to"><xsl:choose><xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@名称_4101 = $FontStyleName]/字:是否斜体_4131">italic</xsl:when><xsl:otherwise>normal</xsl:otherwise></xsl:choose></xsl:attribute>
				</anim:set>
				<anim:set anim:sub-item="text" smil:attributeName="font-weight">
					<xsl:attribute name="smil:dur"><xsl:choose><xsl:when test="@期间_6B98 = 'until-next-click'">until next click</xsl:when><xsl:when test="@期间_6B98 = 'until-end-of-slide'">indefinite</xsl:when><xsl:otherwise><xsl:value-of select="concat(@期间_6B98,'s')"/></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
					<xsl:attribute name="smil:to"><xsl:choose><xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@名称_4101 = $FontStyleName]/字:是否粗体_4130">bold</xsl:when><xsl:otherwise>normal</xsl:otherwise></xsl:choose></xsl:attribute>
				</anim:set>
				<anim:set anim:sub-item="text" smil:attributeName="text-underline">
					<xsl:attribute name="smil:dur"><xsl:choose><xsl:when test="@期间_6B98 = 'until-next-click'">until next click</xsl:when><xsl:when test="@期间_6B98 = 'until-end-of-slide'">indefinite</xsl:when><xsl:otherwise><xsl:value-of select="concat(@期间_6B98,'s')"/></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
					<xsl:attribute name="smil:to"><xsl:choose><xsl:when test="/uof:UOF_0000/式样:式样集_990B/式样:句式样集_990F/式样:句式样_9910[@名称_4101 = $FontStyleName]/字:下划线_4136">solid</xsl:when><xsl:otherwise>none</xsl:otherwise></xsl:choose></xsl:attribute>
				</anim:set>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Change LineColor, uof1, GengGaiXianTiaoYanSe(p0121) -->
	<xsl:template match="演:更改线条颜色_6B94" mode="emphasis">
		<xsl:attribute name="presentation:preset-class">emphasis</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-emphasis-line-color</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type">2</xsl:attribute>
		<anim:animateColor smil:fill="hold" smil:attributeName="stroke-color" presentation:additive="base" anim:color-interpolation="rgb" anim:color-interpolation-direction="clockwise">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:to"><xsl:value-of select="@颜色_6B95"/></xsl:attribute>
		</anim:animateColor>
		<anim:set smil:dur="0s" smil:fill="hold" anim:sub-item="text" smil:attributeName="stroke" smil:to="solid">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:陀螺旋_6B9B" mode="emphasis">
		<xsl:attribute name="presentation:preset-class">emphasis</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-emphasis-spin</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type">2</xsl:attribute>
		<anim:animateTransform smil:fill="hold" presentation:additive="base" svg:type="rotate">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:by"><xsl:choose><xsl:when test="@是否顺时针方向_6B9C = 'true'"><xsl:choose><xsl:when test="@预定义角度_6B9D='quarter spin'">90</xsl:when><xsl:when test="@预定义角度_6B9D='half spin'">180</xsl:when><xsl:when test="@预定义角度_6B9D='full spin'">360</xsl:when><xsl:when test="@预定义角度_6B9D='two spins'">720</xsl:when><xsl:when test="@自定义角度_6B9E"><xsl:value-of select="@自定义角度_6B9E"/></xsl:when></xsl:choose></xsl:when><xsl:when test="@是否顺时针方向_6B9C = 'false'"><xsl:choose><xsl:when test="@预定义角度_6B9D='quarter spin'">-90</xsl:when><xsl:when test="@预定义角度_6B9D='half spin'">-180</xsl:when><xsl:when test="@预定义角度_6B9D='full spin'">-360</xsl:when><xsl:when test="@预定义角度_6B9D='two spins'">-720</xsl:when><xsl:when test="@自定义角度_6B9E">-<xsl:value-of select="@自定义角度_6B9E"/></xsl:when></xsl:choose></xsl:when></xsl:choose></xsl:attribute>
		</anim:animateTransform>
	</xsl:template>
	<xsl:template match="演:透明_6BA3" mode="emphasis">
		<xsl:attribute name="presentation:preset-class">emphasis</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-emphasis-transparency</xsl:attribute>
		<anim:set anim:sub-item="text" smil:attributeName="opacity">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:choose><xsl:when test="@期间_6BA6 = 'until next click'">until next click</xsl:when><xsl:when test="@期间_6BA6 = 'until end of slide'">indefinite</xsl:when><xsl:otherwise><xsl:value-of select="concat(@期间_6BA6,'s')"/></xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:attribute name="smil:to"><xsl:choose><xsl:when test="@预定义透明度_6BA4='25' ">0.25</xsl:when><xsl:when test="@预定义透明度_6BA4='50' ">0.5</xsl:when><xsl:when test="@预定义透明度_6BA4='75' ">0.75</xsl:when><xsl:when test="@预定义透明度_6BA4='100' ">1</xsl:when><xsl:when test="@自定义透明度_6BA5"><xsl:value-of select="number(@自定义透明度_6BA5) div 100"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:缩放_6B72" mode="emphasis">
		<xsl:attribute name="presentation:preset-class">emphasis</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-emphasis-grow-and-shrink</xsl:attribute>
		<anim:animateTransform smil:fill="hold" anim:sub-item="text" presentation:additive="base" svg:type="scale">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:to"><xsl:choose><xsl:when test="@预定义尺寸_6B92='tiny'"><xsl:choose><xsl:when test="@方向_6B91 = 'horizontal'">0.25,1</xsl:when><xsl:when test="@方向_6B91 = 'vertical'">1,0.25</xsl:when><xsl:otherwise>0.25,0.25</xsl:otherwise></xsl:choose></xsl:when><xsl:when test="@预定义尺寸_6B92='smaller'"><xsl:choose><xsl:when test="@方向_6B91 = 'horizontal'">0.5,1</xsl:when><xsl:when test="@方向_6B91 = 'vertical'">1,0.5</xsl:when><xsl:otherwise>0.5,0.5</xsl:otherwise></xsl:choose></xsl:when><xsl:when test="@预定义尺寸_6B92='larger'"><xsl:choose><xsl:when test="@方向_6B91 = 'horizontal'">1.5,1</xsl:when><xsl:when test="@方向_6B91 = 'vertical'">1,1.5</xsl:when><xsl:otherwise>1.5,1.5</xsl:otherwise></xsl:choose></xsl:when><xsl:when test="@预定义尺寸_6B92='huge'"><xsl:choose><xsl:when test="@方向_6B91 = 'horizontal'">4,1</xsl:when><xsl:when test="@方向_6B91 = 'vertical'">1,4</xsl:when><xsl:otherwise>4,4</xsl:otherwise></xsl:choose></xsl:when><xsl:when test="@自定义尺寸_6B93"><xsl:choose><xsl:when test="@方向_6B91 = 'horizontal'"><xsl:value-of select="@自定义尺寸_6B93 div 100"/>,1</xsl:when><xsl:when test="@方向 = 'vertical'">1,<xsl:value-of select="@自定义尺寸_6B93 div 100"/></xsl:when><xsl:otherwise><xsl:value-of select="@自定义尺寸_6B93 div 100"/>,<xsl:value-of select="@自定义尺寸_6B93 div 100"/></xsl:otherwise></xsl:choose></xsl:when></xsl:choose></xsl:attribute>
		</anim:animateTransform>
	</xsl:template>
	<!-- emphasis animation types, ending. -->
	<xsl:template match="演:盒状_6B47" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-box</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B48"><xsl:value-of select="@方向_6B48"/></xsl:when><xsl:otherwise>in</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:transitionFilter smil:type="irisWipe" smil:subtype="rectangle" smil:mode="out">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:if test="@方向_6B48 = 'in'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
		</anim:transitionFilter>
		<anim:set smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:棋盘_6B4E" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-checkerboard</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B50='down'">downward</xsl:when><xsl:when test="@方向_6B50='across'">across</xsl:when><xsl:otherwise>across</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:transitionFilter anim:sub-item="text" smil:type="checkerBoardWipe" smil:mode="out">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@方向_6B50='down'">down</xsl:when><xsl:when test="@方向_6B50='across'">across</xsl:when></xsl:choose></xsl:attribute>
		</anim:transitionFilter>
		<anim:set smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:圆形扩展_6B56" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-circle</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B48"><xsl:value-of select="@方向_6B48"/></xsl:when><xsl:otherwise>in</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:transitionFilter smil:type="ellipseWipe" smil:subtype="horizontal" smil:mode="out">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:if test="@方向_6B48 = 'out'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
		</anim:transitionFilter>
		<anim:set smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:阶梯状_6B49" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-diagonal-squares</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B4A='left down'">left-to-bottom</xsl:when><xsl:when test="@方向_6B4A='left up'">left-to-top</xsl:when><xsl:when test="@方向_6B4A='right down'">right-to-bottom</xsl:when><xsl:when test="@方向_6B4A='right up'">right-to-top</xsl:when><xsl:otherwise>left-to-bottom</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:transitionFilter smil:type="waterfallWipe" smil:mode="out">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="@方向_6B4A='left down'">
					<xsl:attribute name="smil:subtype">horizontalRight</xsl:attribute>
				</xsl:when>
				<xsl:when test="@方向_6B4A='left up'">
					<xsl:attribute name="smil:subtype">horizontalLeft</xsl:attribute>
					<xsl:attribute name="smil:direction">reverse</xsl:attribute>
				</xsl:when>
				<xsl:when test="@方向_6B4A='right up'">
					<xsl:attribute name="smil:subtype">horizontalRight</xsl:attribute>
					<xsl:attribute name="smil:direction">reverse</xsl:attribute>
				</xsl:when>
				<xsl:when test="@方向_6B4A='right down'">
					<xsl:attribute name="smil:subtype">horizontalLeft</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="smil:subtype">horizontalRight</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</anim:transitionFilter>
		<anim:set smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:菱形_6B5D" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-diamond</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B48"><xsl:value-of select="@方向_6B48"/></xsl:when><xsl:otherwise>in</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:transitionFilter smil:type="irisWipe" smil:subtype="diamond" smil:mode="out">
			<xsl:if test="@方向_6B48 = 'out'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:transitionFilter>
		<anim:set smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:消失_6BC7" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-disappear</xsl:attribute>
		<anim:set smil:begin="0s" smil:dur="0.001s" smil:fill="hold" anim:sub-item="text" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:向外溶解_6BC5" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-dissolve</xsl:attribute>
		<anim:transitionFilter smil:type="dissolve" smil:direction="reverse" smil:mode="out">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:transitionFilter>
		<anim:set smil:dur="0.0005s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:闪烁一次_6B51" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-flash-once</xsl:attribute>
		<anim:animate smil:attributeName="visibility" smil:values="hidden;visible" smil:keyTimes="0;0.5" smil:calcMode="discrete">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_fast"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:animate>
		<anim:set smil:dur="0s" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度_fast"/></xsl:attribute>
			<xsl:attribute name="smil:fill">hold</xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:飞出_6BBF" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-fly-out</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6BC0= 'to bottom'">from-bottom</xsl:when><xsl:when test="@方向_6BC0 = 'to top-right'">from-top-right</xsl:when><xsl:when test="@方向_6BC0 = 'to top-left'">from-top-left</xsl:when><xsl:when test="@方向_6BC0 = 'to bottom-left'">from-bottom-left</xsl:when><xsl:when test="@方向_6BC0 = 'to bottom-right'">from-bottom-right</xsl:when><xsl:when test="@方向_6BC0 = 'to right'">from-right</xsl:when><xsl:when test="@方向_6BC0 = 'to left'">from-left</xsl:when><xsl:when test="@方向_6BC0 = 'to top'">from-top</xsl:when><xsl:otherwise>from-bottom</xsl:otherwise></xsl:choose></xsl:attribute>
		<xsl:variable name="smilvalueX">
			<xsl:choose>
				<xsl:when test="contains(@方向_6BC0,'right')">x;1+width/2</xsl:when>
				<xsl:when test="contains(@方向_6BC0,'left')">x;0-width/2</xsl:when>
				<xsl:otherwise>x;x</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="smilvalueY">
			<xsl:choose>
				<xsl:when test="@方向_6BC0">
					<xsl:choose>
						<xsl:when test="contains(@方向_6BC0,'bottom')">y;1+height/2</xsl:when>
						<xsl:when test="contains(@方向_6BC0,'top')">y;0-height/2</xsl:when>
						<xsl:otherwise>y;y</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>y;1+height/2</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<anim:animate smil:fill="hold" smil:attributeName="x" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueX"/></xsl:attribute>
		</anim:animate>
		<anim:animate smil:fill="hold" smil:attributeName="y" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueY"/></xsl:attribute>
		</anim:animate>
		<anim:set smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:缓慢移出_6BC1" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-crawl-out</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6BC2= 'to bottom'">from-bottom</xsl:when><xsl:when test="@方向_6BC2 = 'to right'">from-right</xsl:when><xsl:when test="@方向_6BC2 = 'to left'">from-left</xsl:when><xsl:when test="@方向_6BC2 = 'to top'">from-top</xsl:when><xsl:otherwise>from-bottom</xsl:otherwise></xsl:choose></xsl:attribute>
		<xsl:variable name="smilvalueX">
			<xsl:choose>
				<xsl:when test="contains(@方向_6BC2,'right')">x;1+width/2</xsl:when>
				<xsl:when test="contains(@方向_6BC2,'left')">x;0-width/2</xsl:when>
				<xsl:otherwise>x;x</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="smilvalueY">
			<xsl:choose>
				<xsl:when test="@方向_6BC2">
					<xsl:choose>
						<xsl:when test="contains(@方向_6BC2,'bottom')">y;1+height/2</xsl:when>
						<xsl:when test="contains(@方向_6BC2,'top')">y;0-height/2</xsl:when>
						<xsl:otherwise>y;y</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>y;1+height/2</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<anim:animate smil:fill="hold" smil:attributeName="x" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_veryslow"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueX"/></xsl:attribute>
		</anim:animate>
		<anim:animate smil:fill="hold" smil:attributeName="y" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_veryslow"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:values"><xsl:value-of select="$smilvalueY"/></xsl:attribute>
		</anim:animate>
		<anim:set smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:切出_6BC4" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-peek-out</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6BC2 = 'to bottom'">from-bottom</xsl:when><xsl:when test="@方向_6BC2 = 'to right'">from-right</xsl:when><xsl:when test="@方向_6BC2 = 'to left'">from-left</xsl:when><xsl:when test="@方向_6BC2 = 'to top'">from-top</xsl:when><xsl:otherwise>from-bottom</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:transitionFilter smil:type="slideWipe" smil:direction="reverse" smil:mode="out">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@方向= 'to bottom'">fromBottom</xsl:when><xsl:when test="@方向_6BC2= 'to right'">fromRight</xsl:when><xsl:when test="@方向_6BC2 = 'to left'">fromLeft</xsl:when><xsl:when test="@方向_6BC2 = 'to top'">fromTop</xsl:when></xsl:choose></xsl:attribute>
			<!--xsl:if test="ancestor::演:序列/@演:段落引用">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
			</xsl:if-->
		</anim:transitionFilter>
		<anim:set smil:dur="0s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<!--xsl:if test="ancestor::演:序列/@演:段落引用">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
			</xsl:if-->
		</anim:set>
	</xsl:template>
	<xsl:template match="演:十字形扩展_6B53" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-plus</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B48"><xsl:value-of select="@方向_6B48"/></xsl:when><xsl:otherwise>in</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:transitionFilter smil:type="fourBoxWipe" smil:subtype="cornersIn" smil:mode="out">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:if test="@方向_6B48= 'in'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
		</anim:transitionFilter>
		<anim:set smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:随机线条_6B62" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-random-bars</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B45"><xsl:value-of select="@方向_6B45"/></xsl:when><xsl:otherwise>horizontal</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:transitionFilter smil:type="randomBarWipe" smil:direction="reverse" smil:mode="out">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@方向_6B45= 'horizontal'">vertical</xsl:when><xsl:when test="@方向_6B45 = 'vertical'">horizontal</xsl:when><xsl:otherwise>vertical</xsl:otherwise></xsl:choose></xsl:attribute>
		</anim:transitionFilter>
		<anim:set smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:劈裂_6B5E" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-split</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B5F = 'horizontal out'">horizontal-out</xsl:when><xsl:when test="@方向_6B5F= 'horizontal in'">horizontal-in</xsl:when><xsl:when test="@方向_6B5F= 'vertical in'">vertical-in</xsl:when><xsl:when test="@方向_6B5F= 'vertical out'">vertical-out</xsl:when></xsl:choose></xsl:attribute>
		<anim:transitionFilter smil:type="barnDoorWipe" smil:mode="out">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@方向_6B5F = 'horizontal out'">horizontal</xsl:when><xsl:when test="@方向_6B5F= 'horizontal in'">horizontal</xsl:when><xsl:when test="@方向_6B5F= 'vertical in'">vertical</xsl:when><xsl:when test="@方向_6B5F= 'vertical out'">vertical</xsl:when></xsl:choose></xsl:attribute>
			<xsl:if test="@方向_6B5F= 'horizontal in' or @方向_6B5F= 'vertical in'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
			<!--xsl:if test="ancestor::演:序列/@演:段落引用">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
			</xsl:if-->
		</anim:transitionFilter>
		<anim:set smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<!--xsl:if test="ancestor::演:序列/@演:段落引用">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
			</xsl:if-->
		</anim:set>
	</xsl:template>
	<xsl:template match="演:百叶窗_6B43" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-venetian-blinds</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B45= 'horizontal'">horizontal</xsl:when><xsl:when test="@方向_6B45 = 'vertical'">vertical</xsl:when><xsl:otherwise>vertical</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:transitionFilter smil:type="blindsWipe" smil:direction="reverse" smil:mode="out">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@方向_6B45= 'horizontal'">vertical</xsl:when><xsl:when test="@方向_6B45 = 'vertical'">horizontal</xsl:when><xsl:otherwise>horizontal</xsl:otherwise></xsl:choose></xsl:attribute>
		</anim:transitionFilter>
		<anim:set smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:扇形展开_6B61" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-wedge</xsl:attribute>
		<anim:transitionFilter smil:type="fanWipe" smil:subtype="centerTop" smil:mode="out">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
		</anim:transitionFilter>
		<anim:set smil:dur="0.0015s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:轮子_6B4B" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-wheel</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@轮辐_6B4D"><xsl:value-of select="@轮辐_6B4D"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:transitionFilter smil:dur="0.5s" smil:type="pinWheelWipe" smil:mode="out">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="@轮辐_6B4D='1'">oneBlade</xsl:when><xsl:when test="@轮辐_6B4D='2'">twoBladeVertical</xsl:when><xsl:when test="@轮辐_6B4D='3'">threeBlade</xsl:when><xsl:when test="@轮辐_6B4D='4'">fourBlade</xsl:when><xsl:when test="@轮辐_6B4D='8'">eightBlade</xsl:when><xsl:otherwise>oneBlade</xsl:otherwise></xsl:choose></xsl:attribute>
		</anim:transitionFilter>
		<anim:set smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度_medium"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template match="演:擦除_6B57" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-wipe</xsl:attribute>
		<xsl:attribute name="presentation:preset-sub-type"><xsl:choose><xsl:when test="@方向_6B58 = 'from right'">from-right</xsl:when><xsl:when test="@方向_6B58 = 'from left'">from-left</xsl:when><xsl:when test="@方向_6B58 = 'from top'">from-top</xsl:when><xsl:when test="@方向_6B58 = 'from bottom'">from-bottom</xsl:when><xsl:otherwise>from-left</xsl:otherwise></xsl:choose></xsl:attribute>
		<anim:transitionFilter smil:type="barWipe" smil:mode="out">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:subtype"><xsl:choose><xsl:when test="(@方向_6B58 = 'from right') or (@方向_6B58 = 'from left')">leftToRight</xsl:when><xsl:when test="(@方向_6B58 = 'from top') or (@方向_6B58 = 'from bottom')">topToBottom</xsl:when><xsl:otherwise>leftToRight</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:if test="@方向_6B58 = 'from right'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
			<xsl:if test="@方向_6B58 = 'from bottom'">
				<xsl:attribute name="smil:direction">reverse</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::演:序列/@演:段落引用">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
			</xsl:if>
		</anim:transitionFilter>
		<anim:set smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
			<!--xsl:if test="ancestor::演:序列/@演:段落引用">
				<xsl:attribute name="anim:sub-item">text</xsl:attribute>
			</xsl:if-->
		</anim:set>
	</xsl:template>
	<xsl:template match="演:随机效果_6B55" mode="exit">
		<xsl:attribute name="presentation:preset-class">exit</xsl:attribute>
		<xsl:attribute name="presentation:preset-id">ooo-exit-random</xsl:attribute>
		<anim:transitionFilter smil:type="fade" smil:subtype="crossfade" smil:mode="out">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:transitionFilter>
		<anim:animate smil:attributeName="x" smil:values="x;x" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:dur"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:animate>
		<anim:animate smil:dur="0.1s" smil:decelerate="1" smil:attributeName="y" smil:values="y;y-.03" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:animate>
		<anim:animate smil:begin="0.1s" smil:dur="0.9s" smil:accelerate="1" smil:attributeName="y" smil:values="y;y+1" smil:keyTimes="0;1" presentation:additive="base">
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:animate>
		<anim:set smil:dur="0.001s" smil:fill="hold" smil:attributeName="visibility" smil:to="hidden">
			<xsl:attribute name="smil:begin"><xsl:call-template name="演速度"/></xsl:attribute>
			<xsl:attribute name="smil:targetElement"><xsl:value-of select="ancestor::演:序列_6B1B/@对象引用_6C28"/></xsl:attribute>
		</anim:set>
	</xsl:template>
	<xsl:template name="演速度">
		<xsl:choose>
			<xsl:when test="./@速度_6B44='very-fast'">0.5s</xsl:when>
			<xsl:when test="./@速度_6B44='fast'">1s</xsl:when>
			<xsl:when test="./@速度_6B44='medium'">2s</xsl:when>
			<xsl:when test="./@速度_6B44='slow'">3s</xsl:when>
			<xsl:when test="./@速度_6B44='very-slow'">5s</xsl:when>
			<xsl:otherwise>0.5s</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="演速度_medium">
		<xsl:choose>
			<xsl:when test="./@速度_6B44='very-fast'">0.5s</xsl:when>
			<xsl:when test="./@速度_6B44='fast'">1s</xsl:when>
			<xsl:when test="./@速度_6B44='medium'">2s</xsl:when>
			<xsl:when test="./@速度_6B44='slow'">3s</xsl:when>
			<xsl:when test="./@速度_6B44='very-slow'">5s</xsl:when>
			<xsl:otherwise>2s</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="演速度_veryslow">
		<xsl:choose>
			<xsl:when test="./@速度_6B44='very-fast'">0.5s</xsl:when>
			<xsl:when test="./@速度_6B44='fast'">1s</xsl:when>
			<xsl:when test="./@速度_6B44='medium'">2s</xsl:when>
			<xsl:when test="./@速度_6B44='slow'">3s</xsl:when>
			<xsl:when test="./@速度_6B44='very-slow'">5s</xsl:when>
			<xsl:otherwise>5s</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="演速度_fast">
		<xsl:choose>
			<xsl:when test="./@速度_6B44='very-fast'">0.5s</xsl:when>
			<xsl:when test="./@速度_6B44='fast'">1s</xsl:when>
			<xsl:when test="./@速度_6B44='medium'">2s</xsl:when>
			<xsl:when test="./@速度_6B44='slow'">3s</xsl:when>
			<xsl:when test="./@速度_6B44='very-slow'">5s</xsl:when>
			<xsl:otherwise>1s</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
