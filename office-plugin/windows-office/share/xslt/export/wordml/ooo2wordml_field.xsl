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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" exclude-result-prefixes="office table style text draw svg   dc config xlink meta oooc dom ooo chart math dr3d form script ooow draw">
    <!-- the following are common used  fields -->
    <xsl:template match="text:page-number | text:page-count | text:subject | text:initial-creator |  text:title  | text:date
     | text:time | text:page-variable-get | text:author-name | text:author-initials | text:file-name  | text:sender-company
     | text:sender-initials | text:sender-phone-work | text:word-count  | text:paragraph-count | text:character-count
     | text:description | text:creation-time | text:creation-date | text:editing-cycles | text:editing-duration
     | text:keywords | text:print-time | text:print-date | text:creator | text:modification-time | text:modification-date
     | text:user-defined  | text:variable-get | text:user-field-get | text:sequence | text:database-name ">
        <w:fldSimple>
            <xsl:variable name="attribute_value1">
                <xsl:choose>
                    <xsl:when test="name() = 'text:page-number' or name() = 'text:page-variable-get' ">
                        <xsl:text> PAGE  </xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:page-count' ">
                        <xsl:text> NUMPAGES </xsl:text>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:subject' ">
                        <xsl:text> SUBJECT  </xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:initial-creator' ">
                        <xsl:text> AUTHOR  </xsl:text>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:title' ">
                        <xsl:text> TITLE    </xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:date' ">
                        <xsl:text> DATE   </xsl:text>
                        <!-- ATM, this template just return null date format, it might be  developed in the future -->
                        <xsl:call-template name="field_get_date_format">
                            <xsl:with-param name="field_date_stylename" select="@style:data-style-name"/>
                            <xsl:with-param name="field_date_value" select="@text:date-value"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:time' ">
                        <xsl:text> TIME   </xsl:text>
                        <!-- ATM, this template just return null time format, it might be  developed in the future -->
                        <xsl:call-template name="field_get_time_format">
                            <xsl:with-param name="field_time_stylename" select="@style:data-style-name"/>
                            <xsl:with-param name="field_time_value" select="@text:time-value"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'text:author-name' ">
                        <xsl:text> AUTHOR   </xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:author-initials' ">
                        <xsl:text> USERINITIALS </xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:file-name' ">
                        <xsl:choose>
                            <xsl:when test="@text:display='name-and-extension' or  @text:display='name' ">
                                <xsl:text> FILENAME   </xsl:text>
                            </xsl:when>
                            <xsl:when test=" @text:display='full' or @text:display='path' ">
                                <xsl:text>FILENAME    \p </xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:sender-company' ">
                        <xsl:text> DOCPROPERTY  Company  </xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:sender-initials' ">
                        <xsl:text> USERINITIALS  </xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:sender-phone-work' ">
                        <xsl:text> DOCPROPERTY  &quot;Telephone number&quot; </xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:word-count' ">
                        <xsl:text> DOCPROPERTY  Words </xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:paragraph-count'  ">
                        <xsl:text> DOCPROPERTY  Paragraphs </xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:character-count' ">
                        <xsl:text> DOCPROPERTY  CharactersWithSpaces </xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:description' ">
                        <xsl:text> COMMENTS  </xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:creation-time' ">
                        <xsl:text> DOCPROPERTY  CreateTime </xsl:text>
                        <!-- ATM, this template just return null time format, it might be  developed in the future -->
                        <xsl:call-template name="field_get_time_format">
                            <xsl:with-param name="field_time_stylename" select="@style:data-style-name"/>
                            <xsl:with-param name="field_time_value" select="@text:time-value"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test=" name()= 'text:creation-date' ">
                        <xsl:text> CREATEDATE </xsl:text>
                        <!-- ATM, this template just return null date format, it might be  developed in the future -->
                        <xsl:call-template name="field_get_date_format">
                            <xsl:with-param name="field_date_stylename" select="@style:data-style-name"/>
                            <xsl:with-param name="field_date_value" select="@text:date-value"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:editing-cycles' ">
                        <xsl:text> REVNUM \* Arabic </xsl:text>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:editing-duration' ">
                        <xsl:text> EDITTIME </xsl:text>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:keywords' ">
                        <xsl:text> KEYWORDS </xsl:text>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:print-time' ">
                        <xsl:text>DOCPROPERTY  LastPrinted  </xsl:text>
                        <!-- ATM, this template just return null time format, it might be  developed in the future -->
                        <xsl:call-template name="field_get_time_format">
                            <xsl:with-param name="field_time_stylename" select="@style:data-style-name"/>
                            <xsl:with-param name="field_time_value" select="@text:time-value"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:print-date' ">
                        <xsl:text>DOCPROPERTY  LastPrinted </xsl:text>
                        <!-- ATM, this template just return null date format, it might be  developed in the future -->
                        <xsl:call-template name="field_get_date_format">
                            <xsl:with-param name="field_date_stylename" select="@style:data-style-name"/>
                            <xsl:with-param name="field_date_value" select="@text:date-value"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:creator' ">
                        <xsl:text> LASTSAVEDBY  </xsl:text>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:modification-time' ">
                        <xsl:text> DOCPROPERTY  LastSavedTime </xsl:text>
                        <!-- ATM, this template just return null time format, it might be  developed in the future -->
                        <xsl:call-template name="field_get_time_format">
                            <xsl:with-param name="field_time_stylename" select="@style:data-style-name"/>
                            <xsl:with-param name="field_time_value" select="@text:time-value"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:modification-date' ">
                        <xsl:text> SAVEDATE  </xsl:text>
                        <!-- ATM, this template just return null date format, it might be  developed in the future -->
                        <xsl:call-template name="field_get_date_format">
                            <xsl:with-param name="field_date_stylename" select="@style:data-style-name"/>
                            <xsl:with-param name="field_date_value" select="@text:date-value"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:user-defined' ">
                        <xsl:text>  DOCPROPERTY </xsl:text>
                        <xsl:text>&quot;</xsl:text>
                        <xsl:value-of select="translate(string(@text:name), ' ', '')"/>
                        <xsl:text>&quot;</xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'text:variable-get' or name() = 'text:user-field-get' ">
                        <xsl:value-of select="concat ('DOCVARIABLE ', @text:name)"/>
                    </xsl:when>
                    <xsl:when test=" name() = 'text:sequence' ">
                        <xsl:value-of select="concat(' SEQ  &quot;',@text:name, '&quot;') "/>
                    </xsl:when>
                    <xsl:when test="name() = 'text:database-name' ">
                        <xsl:value-of select="concat (' DATABASE ', @text:database-name, '.' , @text:table-name)"/>
                    </xsl:when>
                </xsl:choose>
                <!-- Get number style format for number fields -->
                <xsl:if test="@style:num-format">
                    <xsl:call-template name="field_get_number_format">
                        <xsl:with-param name="field_number_format_style" select="@style:num-format"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:text>  \* MERGEFORMAT </xsl:text>
            </xsl:variable>
            <xsl:attribute name="w:instr">
                <xsl:value-of select="$attribute_value1"/>
            </xsl:attribute>
            <w:r>
                <w:rPr>
                    <xsl:choose>
                        <xsl:when test="@style:num-format = '가, 나, 다, ...' or @style:num-format ='일, 이, 삼, ...' or @style:num-format ='ㄱ, ㄴ, ㄷ, ...' ">
                            <w:rFonts w:fareast="Batang" w:hint="fareast"/>
                            <!--wx:font wx:val="Batang"/ -->
                            <w:lang w:fareast="KO"/>
                        </xsl:when>
                        <xsl:when test="@style:num-format = 'ア, イ, ウ, ...' or @style:num-format = 'ｱ, ｲ, ｳ, ...' or @style:num-format = 'イ, ロ, ハ, ...' or @style:num-format = 'ｲ, ﾛ, ﾊ, ...' or @style:num-format ='壱, 弐, 参, ...' ">
                            <w:rFonts w:fareast="MS Mincho" w:hint="fareast"/>
                            <!--wx:font wx:val="MS Mincho"/ -->
                            <w:lang w:fareast="JA"/>
                        </xsl:when>
                        <xsl:when test=" @style:num-format  ='壹, 貳, 參, ...' or @style:num-format  ='壹, 貳, 參, ...' or @style:num-format  ='壹, 贰, 叁, ...'or  @style:num-format  = '一, 二, 三, ...' ">
                            <w:rFonts w:hint="fareast"/>
                            <!--wx:font wx:val="宋体"/ -->
                        </xsl:when>
                    </xsl:choose>
                    <w:noProof/>
                </w:rPr>
                <w:t>
                    <xsl:value-of select="."/>
                </w:t>
            </w:r>
        </w:fldSimple>
    </xsl:template>
    <xsl:template name="field_get_number_format">
        <!-- this template get the various of number formats for number type field-->
        <xsl:param name="field_number_format_style"/>
        <xsl:choose>
            <xsl:when test=" $field_number_format_style = '１, ２, ３, ...' or $field_number_format_style = '1'      ">
                <xsl:text>  \* Arabic </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = '①, ②, ③, ...' ">
                <xsl:text> \* CircleNum </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = 'i' ">
                <xsl:text>  \* roman  </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = 'I' ">
                <xsl:text>  \* ROMAN </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = '一, 二, 三, ...'">
                <xsl:text>  \* CHINESENUM3  </xsl:text>
            </xsl:when>
            <xsl:when test="  $field_number_format_style ='壹, 貳, 參, ...' or $field_number_format_style ='壹, 貳, 參, ...' or $field_number_format_style ='壹, 贰, 叁, ...' ">
                <xsl:text>  \* CHINESENUM2  </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = '壱, 弐, 参, ...' ">
                <xsl:text>  \* DBNUM3  </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = '子, 丑, 寅, ...' ">
                <xsl:text>  \* ZODIAC2 </xsl:text>
            </xsl:when>
            <xsl:when test=" $field_number_format_style ='甲, 乙, 丙, ...' ">
                <xsl:text>  \* ZODIAC1 </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = 'イ, ロ, ハ, ...' or $field_number_format_style = 'ｲ, ﾛ, ﾊ, ...' ">
                <xsl:text> \* Iroha </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style ='ｱ, ｲ, ｳ, ...' or $field_number_format_style ='ア, イ, ウ, ...' ">
                <xsl:text> \* Aiueo </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = '일, 이, 삼, ...' ">
                <xsl:text> \* DBNUM1 </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style ='ㄱ, ㄴ, ㄷ, ...' or $field_number_format_style = '㉠, ㉡, ㉢, ...' ">
                <xsl:text> \* Chosung  </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = '가, 나, 다, ...' or $field_number_format_style = '㉮, ㉯, ㉰, ...' ">
                <xsl:text>  \* Ganada </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = 'ア, イ, ウ, ...' or $field_number_format_style = 'ｱ, ｲ, ｳ, ...' ">
                <xsl:text>  \* Aiueo </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style ='a' ">
                <xsl:text>  \* alphabetic </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style ='A' ">
                <xsl:text>  \* ALPHABETIC </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = 'א, י, ק, ...' ">
                <xsl:text>  \* hebrew1  </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = 'א, ב, ג, ...' ">
                <xsl:text>  \* hebrew2  </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = 'أ, ب, ت, ...' ">
                <xsl:text>  \* ArabicAlpha </xsl:text>
            </xsl:when>
            <xsl:when test="$field_number_format_style = 'ก, ข, ฃ, ...' ">
                <xsl:text>  \* ThaiLetter </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="field_get_date_format">
        <xsl:param name="field_date_stylename"/>
        <xsl:param name="field_date_value"/>
        <!-- this template return null date format ATM-->
        <xsl:text/>
    </xsl:template>
    <xsl:template name="field_get_time_format">
        <xsl:param name="field_time_stylename"/>
        <xsl:param name="field_time_value"/>
        <!-- this template return null date format ATM-->
        <xsl:text/>
    </xsl:template>
    <xsl:template match="text:template-name">
        <xsl:choose>
            <xsl:when test="@text:display='title' or @text:display= 'area' ">
                <!-- directly export the content -->
                <w:r>
                    <w:rPr>
                        <w:noProof/>
                    </w:rPr>
                    <w:t>
                        <xsl:value-of select="."/>
                    </w:t>
                </w:r>
            </xsl:when>
            <xsl:otherwise>
                <w:fldSimple>
                    <xsl:variable name="template_attribute_value">
                        <xsl:choose>
                            <xsl:when test="@text:display='name-and-extension' or          @text:display= 'name' ">
                                <xsl:text> TEMPLATE </xsl:text>
                            </xsl:when>
                            <xsl:when test=" @text:display='full' or @text:display='path' ">
                                <xsl:text>TEMPLATE  \p </xsl:text>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:text>\* MERGEFORMAT </xsl:text>
                    </xsl:variable>
                    <xsl:attribute name="w:instr">
                        <xsl:value-of select="$template_attribute_value"/>
                    </xsl:attribute>
                    <w:r>
                        <w:rPr>
                            <w:noProof/>
                        </w:rPr>
                        <w:t>
                            <xsl:value-of select="."/>
                        </w:t>
                    </w:r>
                </w:fldSimple>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text:text-input | text:variable-input | text:user-field-input">
        <w:fldSimple>
            <xsl:variable name="text-input-attribute">
                <xsl:text>FILLIN  </xsl:text>
                <xsl:if test="@text:description">
                    <xsl:value-of select="@text:description"/>
                </xsl:if>
                <xsl:text> \* MERGEFORMAT</xsl:text>
            </xsl:variable>
            <xsl:attribute name="w:instr">
                <xsl:value-of select="$text-input-attribute"/>
            </xsl:attribute>
            <w:r>
                <w:rPr>
                    <w:noProof/>
                </w:rPr>
                <xsl:call-template name="field_convert_linebreak">
                    <xsl:with-param name="field_input_text" select="text()"/>
                </xsl:call-template>
            </w:r>
        </w:fldSimple>
    </xsl:template>
    <xsl:template name="field_convert_linebreak">
        <!-- this template convert the linebreak (&#x0A; and &#x0D;) in continuous text to Ms word element<w:br/> -->
        <xsl:param name="field_input_text"/>
        <xsl:if test="not (contains($field_input_text,'&#x0A;'))">
            <w:t>
                <xsl:value-of select="$field_input_text"/>
            </w:t>
        </xsl:if>
        <xsl:if test="contains($field_input_text,'&#x0A;')">
            <w:t>
                <xsl:value-of select="translate(substring-before($field_input_text,'&#x0A;'),'&#x0D;','')"/>
            </w:t>
            <w:br/>
            <xsl:call-template name="field_convert_linebreak">
                <xsl:with-param name="field_input_text" select="substring-after($field_input_text,'&#x0A;')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="field_declare">
        <!-- this template export the field declaration to w:docpr -->
        <xsl:param name="simple_field_variable_declares"/>
        <xsl:param name="user_field_variable_declares"/>
        <xsl:param name="field_sequence_declares"/>
        <w:docVars>
            <xsl:if test="$simple_field_variable_declares/text:variable-decl">
                <xsl:for-each select="$simple_field_variable_declares/text:variable-decl">
                    <w:docVar w:name="{@text:name}" w:val="default value"/>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$user_field_variable_declares/text:user-field-decl">
                <xsl:for-each select="$user_field_variable_declares/text:user-field-decl">
                    <w:docVar w:name="{@text:name}" w:val="{@text:string-value}"/>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$field_sequence_declares/text:sequence-decl">
                <!-- do nothing for sequence declares when exporting to MS word-->
            </xsl:if>
        </w:docVars>
    </xsl:template>
    <xsl:template match="text:reference-ref | text:bookmark-ref | text:footnote-ref
                                | text:endnote-ref ">
        <!-- this template is for reference fields -->
        <w:r>
            <w:fldChar w:fldCharType="begin"/>
        </w:r>
        <xsl:variable name="complicate_field_instruction">
            <xsl:choose>
                <xsl:when test=" name() = 'text:reference-ref'  ">
                    <xsl:choose>
                        <xsl:when test=" string(@text:reference-format) = 'page' ">
                            <xsl:value-of select="concat(' PAGEREF ', @text:ref-name, '\h') "/>
                        </xsl:when>
                        <xsl:when test="string(@text:reference-format) = 'chapter' ">
                            <xsl:value-of select="concat(' REF ',  @text:ref-name, '\n \h') "/>
                        </xsl:when>
                        <xsl:when test="string(@text:reference-format) = 'text' ">
                            <xsl:value-of select="concat ( ' REF ' , @text:ref-name, ' \h') "/>
                        </xsl:when>
                        <xsl:when test="string(@text:reference-format) = 'direction' ">
                            <xsl:value-of select="concat(' REF ', @text:ref-name, ' \p \h' ) "/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat ( ' PAGEREF ', @text:ref-name, '\h')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="name() = 'text:footnote-ref' or name() = 'text:endnote-ref' ">
                    <xsl:choose>
                        <xsl:when test=" string(@text:reference-format) = 'page' ">
                            <xsl:value-of select="concat(' PAGEREF ', @text:ref-name, '\h') "/>
                        </xsl:when>
                        <xsl:when test="string(@text:reference-format) = 'chapter' ">
                            <xsl:value-of select="concat(' REF ',  @text:ref-name, '\n  \h') "/>
                        </xsl:when>
                        <xsl:when test="string(@text:reference-format) = 'text' ">
                            <xsl:value-of select="concat ( ' NOTEREF ' , @text:ref-name, ' \h') "/>
                        </xsl:when>
                        <xsl:when test="string(@text:reference-format) = 'direction' ">
                            <xsl:value-of select="concat(' PAGEREF ', @text:ref-name, ' \p \h' ) "/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat ( ' PAGEREF ', @text:ref-name, '\h')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="name() = 'text:bookmark-ref' ">
                    <xsl:choose>
                        <xsl:when test=" string(@text:reference-format) = 'page' ">
                            <xsl:value-of select="concat(' PAGEREF ', @text:ref-name, '\h') "/>
                        </xsl:when>
                        <xsl:when test="string(@text:reference-format) = 'chapter' ">
                            <xsl:value-of select="concat(' PAGEREF ',  @text:ref-name, '  \h') "/>
                        </xsl:when>
                        <xsl:when test="string(@text:reference-format) = 'text' ">
                            <xsl:value-of select="concat ( ' REF ' , @text:ref-name, ' \h') "/>
                        </xsl:when>
                        <xsl:when test="string(@text:reference-format) = 'direction' ">
                            <xsl:value-of select="concat(' REF ', @text:ref-name, ' \p \h' ) "/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat ( ' PAGEREF ', @text:ref-name, '\h')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!--start to combine the complicate field instruction -->
        <w:r>
            <w:instrText>
                <xsl:value-of select="$complicate_field_instruction"/>
            </w:instrText>
        </w:r>
        <w:r>
            <w:fldChar w:fldCharType="separate"/>
        </w:r>
        <w:r>
            <w:rPr>
                <w:noProof/>
            </w:rPr>
            <w:t>
                <xsl:value-of select="."/>
            </w:t>
        </w:r>
        <w:r>
            <w:fldChar w:fldCharType="end"/>
        </w:r>
    </xsl:template>
    <xsl:template match="text:chapter | text:sender-firstname | text:sender-lastname
                                    | text:sender-street | text:sender-country | text:sender-postal-code
                                    | text:sender-city | text:sender-title | text:sender-position
                                    | text:sender-phone-private | text:sender-email | text:sender-fax
                                    | text:sender-state-or-province | text:table-count | text:image-count
                                    | text:object-count | text:printed-by | text:hidden-paragraph
                                    | text:placeholder | text:drop-down | text:conditional-text
                                    | text:variable-set | text:table-formula | text:database-display
                                    | text:database-next | text:database-select | text:database-row-number
                                    | text:sequence-ref | text:expression | text:sheet-name | text:dde-connection">
        <!-- this template just export content of staroffice fields that do not have the corresponding fields in MS word  ATM -->
        <w:r>
            <w:rPr>
                <w:noProof/>
            </w:rPr>
            <w:t>
                <xsl:value-of select="."/>
            </w:t>
        </w:r>
    </xsl:template>
    <xsl:template match="text:execute-macro | text:variable-decls | text:variable-decl | text:user-field-decls | text:variable-decl | text:sequence-decls | text:sequence-decl | text:page-variable-set |  text:bibliography-mark | text:script | text:page-continuation ">
        <!-- this template is to ignore matched elements when exporting writer to word -->
    </xsl:template>
    <xsl:template match="text:a ">
        <xsl:call-template name="export_hyoerlink"/>
    </xsl:template>
    <xsl:template name="export_hyoerlink">
        <!-- all params are used by draw -->
        <xsl:param name="TargetMeasure"/>
        <xsl:param name="x-adjust"/>
        <xsl:param name="y-adjust"/>
        <xsl:param name="force-draw"/>
        <!-- this template processes the hyperlink in writer -->
        <xsl:variable name="hyperlink_filename">
            <xsl:choose>
                <xsl:when test="contains(@xlink:href, '#')">
                    <xsl:value-of select="substring-before(@xlink:href, '#')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@xlink:href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="hyperlink_bookmark">
            <xsl:if test="contains(@xlink:href, '#')">
                <xsl:choose>
                    <xsl:when test="contains(@xlink:href, '%7C')">
                        <xsl:call-template name="translate_string">
                            <xsl:with-param name="t_input_string" select="substring-before( substring-after(@xlink:href, '#'), '%7C')"/>
                            <xsl:with-param name="t_pattern_string" select=" '%20' "/>
                            <xsl:with-param name="t_substitute_string" select=" ' ' "/>
                            <xsl:with-param name="t_output_string" select=" '' "/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="translate_string">
                            <xsl:with-param name="t_input_string" select="substring-after(@xlink:href, '#')"/>
                            <xsl:with-param name="t_pattern_string" select=" '%20' "/>
                            <xsl:with-param name="t_substitute_string" select=" ' ' "/>
                            <xsl:with-param name="t_output_string" select=" '' "/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:variable>
        <w:hlink>
            <xsl:if test="@xlink:href">
                <xsl:attribute name="w:dest">
                    <xsl:value-of select="$hyperlink_filename"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="contains(@xlink:href, '#')">
                <xsl:attribute name="w:bookmark">
                    <xsl:value-of select="$hyperlink_bookmark"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@office:target-frame-name">
                <xsl:attribute name="w:target">
                    <xsl:value-of select="@office:target-frame-name"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@office:name">
                <xsl:attribute name="w:screenTip">
                    <xsl:value-of select="@office:name"/>
                </xsl:attribute>
            </xsl:if>
            <w:r>
                <w:rPr>
                    <w:rStyle w:val="Hyperlink"/>
                </w:rPr>
                <!--apply inline-text-elements, many many many ...  -->
                <xsl:apply-templates select="text:a | text:span | text() | text:hidden-text
            | text:line-break | text:tab-stop | text:s | text:page-number | text:page-count | text:subject
            | text:initial-creator | text:title | text:date | text:time | text:author-name
            | text:author-initials | text:chapter | text:file-name | text:sender-company
            | text:sender-firstname | text:sender-lastname | text:sender-initials | text:sender-street
            | text:sender-country | text:sender-postal-code | text:sender-city | text:sender-title
            | text:sender-position | text:sender-phone-private | text:sender-phone-work
            | text:sender-email | text:sender-fax | text:sender-state-or-province | text:word-count
            | text:paragraph-count | text:character-count | text:table-count | text:image-count
            | text:object-count | text:template-name | text:description | text:creation-time
            | text:creation-date | text:editing-cycles | text:editing-duration | text:keywords
            | text:print-time | text:print-date | text:creator | text:modification-time
            | text:modification-date | text:user-defined | text:printed-by | text:hidden-paragraph
            | text:placeholder | text:drop-down | text:conditional-text  | text:text-input
            | text:execute-macro | text:variable-set | text:variable-input
            | text:user-field-input | text:variable-get | text:user-field-get | text:sequence
            | text:page-variable-set | text:page-variable-get | text:table-formula
            | text:database-display | text:database-next| text:database-select
            | text:database-row-number | text:database-name | text:reference-ref
            | text:bookmark-ref | text:footnote-ref  | text:endnote-ref | text:sequence-ref
            | text:expression | text:measure | text:dde-connection | text:sheet-name
            | text:bibliography-mark | text:script | text:page-continuation | office:annotation
            | draw:*">
                    <xsl:with-param name="TargetMeasure" select="$TargetMeasure"/>
                    <xsl:with-param name="x-adjust" select="$x-adjust"/>
                    <xsl:with-param name="y-adjust" select="$y-adjust"/>
                    <xsl:with-param name="force-draw" select="$force-draw"/>
                </xsl:apply-templates>
            </w:r>
        </w:hlink>
    </xsl:template>
    <xsl:template name="translate_string">
        <!-- this template is to replace  the substring  matched t_pattern_string  in t_t_input_string with t_substitute_string  G.Y.-->
        <xsl:param name="t_input_string"/>
        <xsl:param name="t_pattern_string"/>
        <xsl:param name="t_substitute_string"/>
        <xsl:param name="t_output_string"/>
        <xsl:variable name="t_temp_output_string">
            <xsl:if test="contains($t_input_string, $t_pattern_string) ">
                <xsl:value-of select="concat($t_output_string, substring-before($t_input_string,$t_pattern_string), $t_substitute_string) "/>
            </xsl:if>
            <xsl:if test="not (contains($t_input_string, $t_pattern_string)) ">
                <xsl:value-of select="$t_output_string"/>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="contains($t_input_string, $t_pattern_string) ">
            <xsl:call-template name="translate_string">
                <xsl:with-param name="t_input_string" select="substring-after($t_input_string,$t_pattern_string)"/>
                <xsl:with-param name="t_pattern_string" select="$t_pattern_string"/>
                <xsl:with-param name="t_substitute_string" select="$t_substitute_string"/>
                <xsl:with-param name="t_output_string" select="$t_temp_output_string"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="not (contains($t_input_string, $t_pattern_string))">
            <xsl:value-of select="concat($t_temp_output_string, $t_input_string)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template name="add_hyperlink_style">
        <!--this template is to add the hyperlink related style -->
        <w:style w:type="character" w:styleId="Hyperlink">
            <w:name w:val="Hyperlink"/>
            <w:rsid w:val="006A55B0"/>
            <w:rPr>
                <w:color w:val="000080"/>
                <w:u w:val="single"/>
            </w:rPr>
        </w:style>
        <w:style w:type="character" w:styleId="FollowedHyperlink">
            <w:name w:val="FollowedHyperlink"/>
            <w:rsid w:val="006A55B0"/>
            <w:rPr>
                <w:color w:val="800000"/>
                <w:u w:val="single"/>
            </w:rPr>
        </w:style>
    </xsl:template>
    <xsl:template match="office:annotation">
        <!-- this template export writer note to word comments -->
        <xsl:variable name="comments_aml_id">
            <xsl:call-template name="unique_amlid_generator"/>
        </xsl:variable>
        <aml:annotation w:type="Word.Comment.Start">
            <xsl:attribute name="aml:id">
                <xsl:value-of select="$comments_aml_id"/>
            </xsl:attribute>
        </aml:annotation>
        <aml:annotation w:type="Word.Comment.End">
            <xsl:attribute name="aml:id">
                <xsl:value-of select="$comments_aml_id"/>
            </xsl:attribute>
        </aml:annotation>
        <!-- export aml:annotation content-->
        <w:r>
            <w:rPr>
                <w:rStyle w:val="CommentReference"/>
            </w:rPr>
            <aml:annotation aml:author="{@office:author}" aml:createdate="{@office:create-date}" w:type="Word.Comment" w:initials="{@office:author}">
                <xsl:attribute name="aml:id">
                    <xsl:value-of select="$comments_aml_id"/>
                </xsl:attribute>
                <aml:content>
                    <xsl:apply-templates select="text:p"/>
                </aml:content>
            </aml:annotation>
        </w:r>
        <!-- end of  export aml:annotation content-->
    </xsl:template>
    <xsl:template name="unique_amlid_generator">
        <!-- this template generate unique id for aml:id, ATM it only counts the office:annotation, some other elements might be added later -->
        <xsl:number count="office:annotation" from="/office:document/office:body" level="any" format="1"/>
    </xsl:template>
    <xsl:template name="add_comments_style">
        <w:style w:type="character" w:styleId="CommentReference">
            <w:name w:val="annotation reference"/>
            <w:basedOn w:val="DefaultParagraphFont"/>
            <w:semiHidden/>
            <w:rsid w:val="007770B7"/>
            <w:rPr>
                <w:sz w:val="16"/>
                <w:sz-cs w:val="16"/>
            </w:rPr>
        </w:style>
        <w:style w:type="paragraph" w:styleId="CommentText">
            <w:name w:val="annotation text"/>
            <w:basedOn w:val="Normal"/>
            <w:semiHidden/>
            <w:rsid w:val="007770B7"/>
            <w:pPr>
                <w:pStyle w:val="CommentText"/>
            </w:pPr>
            <w:rPr>
                <w:sz w:val="20"/>
                <w:sz-cs w:val="20"/>
            </w:rPr>
        </w:style>
        <w:style w:type="paragraph" w:styleId="CommentSubject">
            <w:name w:val="annotation subject"/>
            <w:basedOn w:val="CommentText"/>
            <w:next w:val="CommentText"/>
            <w:semiHidden/>
            <w:rsid w:val="007770B7"/>
            <w:pPr>
                <w:pStyle w:val="CommentSubject"/>
            </w:pPr>
            <w:rPr>
                <w:b/>
                <w:b-cs/>
            </w:rPr>
        </w:style>
    </xsl:template>
</xsl:stylesheet>
