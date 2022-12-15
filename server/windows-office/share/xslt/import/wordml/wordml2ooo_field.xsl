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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" exclude-result-prefixes="w wx aml o dt fo v">
    <!--Generally, The MS fields can be represented in two forms, simple field w:fldsimple or complicated field
 w:fldChar, so when importing we have to take care of two possible forms of  the same type field -->
    <xsl:template match="w:instrText">
        <!-- ===this template is to process the w:fldChar fields ======  -->
        <xsl:choose>
            <xsl:when test="substring(normalize-space(.),1,7) = 'PAGEREF' ">
                <xsl:variable name="bookmarkname">
                    <xsl:value-of select="normalize-space(substring-before (substring-after( . , 'PAGEREF' ), '\*')) "/>
                </xsl:variable>
                <text:bookmark-ref text:reference-format="page" text:ref-name="{$bookmarkname}">
                    <xsl:call-template name="get-fldchar-content">
                        <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                        <xsl:with-param name="sibling_number" select=" 1"/>
                    </xsl:call-template>
                </text:bookmark-ref>
            </xsl:when>
            <xsl:when test="substring( normalize-space(.),1,9) = 'HYPERLINK' ">
                <xsl:variable name="hyper-str" select="normalize-space(.)"/>
                <xsl:variable name="hyper-dest" select="substring-before( substring($hyper-str, 12), '&quot;')"/>
                <xsl:variable name="hyper-bookmark">
                    <xsl:if test="contains( $hyper-str, ' \l ')">
                        <xsl:value-of select="concat( '#', substring-before( substring-after( substring-after( $hyper-str, ' \l '), '&quot;'), '&quot;') )"/>
                    </xsl:if>
                </xsl:variable>
                <text:a xlink:type="simple" xlink:href="{concat( $hyper-dest, $hyper-bookmark)}">
                    <xsl:call-template name="get-fldchar-content">
                        <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                        <xsl:with-param name="sibling_number" select=" 1"/>
                    </xsl:call-template>
                </text:a>
            </xsl:when>
            <xsl:when test="substring( normalize-space(.),1,3) = 'REF' ">
                <text:bookmark-ref text:reference-format="text" text:ref-name="{normalize-space( substring-before (substring-after(text(), 'REF') , '\') )}">

            </text:bookmark-ref>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,4) = 'DATE'  or substring(normalize-space(.),1,4) = 'TIME' ">
                <text:date>
                    <xsl:choose>
                        <xsl:when test="contains(text(), '\@')">
                            <xsl:attribute name="style:data-style-name">ND<xsl:number count="w:instrText | w:fldSimple" from="/w:wordDocument/w:body" level="any" format="1"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:data-style-name"><xsl:value-of select=" 'NDF1' "/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </text:date>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,9) = 'PRINTDATE' ">
                <text:print-date>
                    <xsl:choose>
                        <xsl:when test="contains(text(), '\@')">
                            <xsl:attribute name="style:data-style-name">ND<xsl:number count="w:instrText | w:fldSimple" from="/w:wordDocument/w:body" level="any" format="1"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:data-style-name"><xsl:value-of select=" 'NDF1' "/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </text:print-date>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,10) = 'CREATEDATE' ">
                <text:creation-date>
                    <xsl:choose>
                        <xsl:when test="contains(text(), '\@')">
                            <xsl:attribute name="style:data-style-name">ND<xsl:number count="w:instrText | w:fldSimple" from="/w:wordDocument/w:body" level="any" format="1"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:data-style-name"><xsl:value-of select=" 'NDF1' "/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </text:creation-date>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,8) = 'SAVEDATE' ">
                <text:modification-date>
                    <xsl:choose>
                        <xsl:when test="contains(text(), '\@')">
                            <xsl:attribute name="style:data-style-name">ND<xsl:number count="w:instrText | w:fldSimple" from="/w:wordDocument/w:body" level="any" format="1"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="style:data-style-name"><xsl:value-of select=" 'NDF1' "/></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </text:modification-date>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,4) = 'PAGE' ">
                <text:page-number text:select-page="current">
                    <xsl:variable name="num-format">
                        <xsl:call-template name="get_field_num_format">
                            <xsl:with-param name="input_MS_num_format" select="normalize-space(substring-after(text(), '\*' ))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="style:num-format"><xsl:value-of select="$num-format"/></xsl:attribute>
                </text:page-number>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,8) = 'NUMPAGES' ">
                <text:page-count>
                    <xsl:variable name="num-format">
                        <xsl:call-template name="get_field_num_format">
                            <xsl:with-param name="input_MS_num_format" select="normalize-space(substring-after(text(), '\*' ))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="style:num-format"><xsl:value-of select="$num-format"/></xsl:attribute>
                </text:page-count>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,8) = 'NUMWORDS' ">
                <text:word-count>
                    <xsl:variable name="num-format">
                        <xsl:call-template name="get_field_num_format">
                            <xsl:with-param name="input_MS_num_format" select="normalize-space(substring-after(text(), '\*' ))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="style:num-format"><xsl:value-of select="$num-format"/></xsl:attribute>
                </text:word-count>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,8) = 'NUMCHARS' ">
                <text:character-count>
                    <xsl:variable name="num-format">
                        <xsl:call-template name="get_field_num_format">
                            <xsl:with-param name="input_MS_num_format" select="normalize-space(substring-after(text(), '\*' ))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="style:num-format"><xsl:value-of select="$num-format"/></xsl:attribute>
                </text:character-count>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,6) = 'REVNUM' ">
                <text:editing-cycles>
                    <xsl:value-of select="w:r"/>
                </text:editing-cycles>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,7) = 'AUTONUM'  or  substring(normalize-space(.),1,10) = 'AUTONUMLGL' or substring(normalize-space(.),1,10) = 'AUTONUMOUT' ">
                <text:sequence>
                    <xsl:attribute name="text:ref-name">RefAutoNum<xsl:number count="w:instrText[contains(text(), 'AUTONUM') or contains(text(), 'AUTONUMLGL') or contains( text(), 'AUTONUMOUT') ] | w:fldSimple[contains(@w:instr,'AUTONUM') or contains(@w:instr, 'AUTONUMLGL') or contains(@w:instr, 'AUTONUMOUT') ] " from="/w:wordDocument/w:body" level="any" format="1"/></xsl:attribute>
                    <xsl:attribute name="text:name"><xsl:value-of select=" 'AutoNr' "/></xsl:attribute>
                    <xsl:attribute name="text:formula"><xsl:value-of select=" 'ooow:AutoNr + 1' "/></xsl:attribute>
                    <xsl:variable name="num-format">
                        <xsl:call-template name="get_field_num_format">
                            <xsl:with-param name="input_MS_num_format" select="normalize-space(substring-after(text(), '\*' ))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="style:num-format"><xsl:value-of select="$num-format"/></xsl:attribute>
                </text:sequence>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,3) = 'SEQ' ">
                <text:sequence>
                    <xsl:attribute name="text:ref-name">Ref<xsl:number count="w:instrText[contains(text(), 'SEQ') ] | w:fldSimple[contains(@w:instr,'SEQ') ] " from="/w:wordDocument/w:body" level="any" format="1"/></xsl:attribute>
                    <xsl:variable name="seq_text_name">
                        <xsl:call-template name="get_seq_name">
                            <xsl:with-param name="input_seq_string" select="normalize-space(substring-after(text(), 'SEQ'))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="text:name"><xsl:value-of select="$seq_text_name"/></xsl:attribute>
                    <xsl:attribute name="text:formula"><xsl:value-of select="concat (concat('ooow:',$seq_text_name), ' + 1' )"/></xsl:attribute>
                    <xsl:variable name="num-format">
                        <xsl:call-template name="get_field_num_format">
                            <xsl:with-param name="input_MS_num_format" select="normalize-space(substring-after(text(), '\*' ))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="style:num-format"><xsl:value-of select="$num-format"/></xsl:attribute>
                </text:sequence>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,6) = 'AUTHOR' ">
                <text:initial-creator>
                    <xsl:call-template name="get-fldchar-content">
                        <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                        <xsl:with-param name="sibling_number" select=" 1"/>
                    </xsl:call-template>
                </text:initial-creator>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,5) = 'TITLE' ">
                <text:title>
                    <xsl:call-template name="get-fldchar-content">
                        <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                        <xsl:with-param name="sibling_number" select=" 1"/>
                    </xsl:call-template>
                </text:title>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,7) = 'SUBJECT' ">
                <text:subject>
                    <xsl:call-template name="get-fldchar-content">
                        <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                        <xsl:with-param name="sibling_number" select=" 1"/>
                    </xsl:call-template>
                </text:subject>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,8) = 'KEYWORDS' ">
                <text:keywords>
                    <xsl:call-template name="get-fldchar-content">
                        <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                        <xsl:with-param name="sibling_number" select=" 1"/>
                    </xsl:call-template>
                </text:keywords>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,6) = 'FILLIN' ">
                <text:text-input>
                    <xsl:attribute name="text:description"><xsl:value-of select="substring-before(substring-after(text(), 'FILLIN'), '\*')"/></xsl:attribute>
                    <xsl:call-template name="get-fldchar-content">
                        <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                        <xsl:with-param name="sibling_number" select=" 1"/>
                    </xsl:call-template>
                </text:text-input>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,11) = 'DOCPROPERTY' ">
                <xsl:variable name="instr_command">
                    <xsl:value-of select="normalize-space (substring-after(text(), 'DOCPROPERTY' ))"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains($instr_command, 'Author' ) ">
                        <text:user-field-get text:name="Author">
                         </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Bytes' ) ">
                        <text:user-field-get text:name="Bytes">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'CharactersWithSpaces' ) ">
                        <text:user-field-get text:name="CharactersWithSpaces">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Category' ) ">
                        <text:user-field-get text:name="Category">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Characters' ) ">
                        <text:user-field-get text:name="Characters">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Comments' ) ">
                        <text:user-field-get text:name="Comments">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Company' ) ">
                        <text:user-field-get text:name="Company">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'CreateTime' ) ">
                        <text:user-field-get text:name="CreateTime">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'HyperlinkBase' ) ">
                        <text:user-field-get text:name="HyperlinkBase">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Keywords' ) ">
                        <text:user-field-get text:name="Keywords">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'LastPrinted' ) ">
                        <text:user-field-get text:name="LastPrinted">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'LastSavedBy' ) ">
                        <text:user-field-get text:name="LastSavedBy">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'LastSavedTime' ) ">
                        <text:user-field-get text:name="LastSavedTime">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Lines' ) ">
                        <text:user-field-get text:name="Lines">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Manager' ) ">
                        <text:user-field-get text:name="Manager">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'NameofApplication' ) ">
                        <text:user-field-get text:name="NameofApplication">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'ODMADocId' ) ">
                        <text:user-field-get text:name="ODMADocId">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Pages' ) ">
                        <text:user-field-get text:name="Pages">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Paragraphs' ) ">
                        <text:user-field-get text:name="Paragraphs">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'RevisionNumber' ) ">
                        <text:user-field-get text:name="RevisionNumber">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Security' ) ">
                        <text:user-field-get text:name="Security">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Subject' ) ">
                        <text:user-field-get text:name="Subject">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Template' ) ">
                        <text:user-field-get text:name="Template">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Title' ) ">
                        <text:user-field-get text:name="Title">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'TotalEditingTime' ) ">
                        <text:user-field-get text:name="TotalEditingTime">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Words' ) ">
                        <text:user-field-get text:name="Words">
                        </text:user-field-get>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,10) = 'MERGEFIELD' ">
                <text:database-display text:database-name="" text:table-name="" text:table-type="table">
                    <xsl:attribute name="text:column-name"><xsl:value-of select="substring-before(substring-after(normalize-space(.), 'MERGEFIELD' ), ' ' ) "/></xsl:attribute>
                    <xsl:call-template name="get-fldchar-content">
                        <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                        <xsl:with-param name="sibling_number" select=" 1"/>
                    </xsl:call-template>
                </text:database-display>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,8) = 'MERGEREC' ">
                <text:database-row-number text:database-name="" text:table-name="" text:table-type="table" style:num-format="A" text:value="0">
                    <xsl:call-template name="get-fldchar-content">
                        <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                        <xsl:with-param name="sibling_number" select=" 1"/>
                    </xsl:call-template>
                </text:database-row-number>
            </xsl:when>
            <xsl:when test="substring(normalize-space(.),1,4) = 'NEXT' ">
                <text:database-next text:database-name="" text:table-name="" text:table-type="table" text:condition="">
                </text:database-next>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="w:fldChar">
        <!-- for complicated field w:fldChar, we only process the w:instrText, please see the template processing w:instrText  -->
    </xsl:template>
    <xsl:template name="get-fldchar-content">
        <!-- this template is to get the content of fldchar in-between w:instrText and w:fldChar/@w:fldCharType ='end'  -->
        <xsl:param name="next_node"/>
        <xsl:param name="sibling_number"/>
        <xsl:if test="not ($next_node/w:fldChar/@w:fldCharType ='end' ) and $next_node ">
            <xsl:if test="$next_node/w:br">
                <xsl:text>&#x0A;</xsl:text>
            </xsl:if>
            <xsl:value-of select="$next_node//w:t"/>
            <xsl:call-template name="get-fldchar-content">
                <xsl:with-param name="next_node" select="../following-sibling::w:r[$sibling_number + 1]"/>
                <xsl:with-param name="sibling_number" select="$sibling_number + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- ====== this  template is to process the w:fldsimple fields ======= -->
    <xsl:template match="w:fldSimple">
        <xsl:choose>
            <xsl:when test="substring(normalize-space(@w:instr),1,7) = 'PAGEREF' ">
                <xsl:variable name="bookmarkname">
                    <xsl:value-of select="normalize-space(substring-before (substring-after( @w:instr , 'PAGEREF' ), '\*')) "/>
                </xsl:variable>
                <text:bookmark-ref text:reference-format="page" text:ref-name="{$bookmarkname}">
                    <xsl:value-of select=" .//w:t"/>
                </text:bookmark-ref>
            </xsl:when>
            <xsl:when test="substring( normalize-space(@w:instr),1,9) = 'HYPERLINK' ">
                <xsl:variable name="hyper-str" select="normalize-space(@w:instr)"/>
                <xsl:variable name="hyper-dest" select="substring-before( substring($hyper-str, 12), '&quot;')"/>
                <xsl:variable name="hyper-bookmark">
                    <xsl:if test="contains( $hyper-str, ' \l ')">
                        <xsl:value-of select="concat( '#', substring-before( substring-after( substring-after( $hyper-str, ' \l '), '&quot;'), '&quot;') )"/>
                    </xsl:if>
                </xsl:variable>
                <text:a xlink:type="simple" xlink:href="{concat( $hyper-dest, $hyper-bookmark)}">
                    <xsl:value-of select=" .//w:t"/>
                </text:a>
            </xsl:when>
            <xsl:when test="substring( normalize-space(@w:instr),1,3) = 'REF' ">
                <text:bookmark-ref text:reference-format="text" text:ref-name="{normalize-space( substring-before (substring-after(@w:instr, 'REF') , '\') )}">

            </text:bookmark-ref>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,4) = 'DATE'  or substring(normalize-space(@w:instr),1,4) = 'TIME'  ">
                <text:date>
                    <xsl:attribute name="style:data-style-name"><xsl:value-of select=" 'NDF1' "/></xsl:attribute>
                    <xsl:value-of select=".//w:t"/>
                </text:date>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,9) = 'PRINTDATE' ">
                <text:print-date>
                    <xsl:attribute name="style:data-style-name"><xsl:value-of select=" 'NDF1' "/></xsl:attribute>
                    <xsl:value-of select=".//w:t"/>
                </text:print-date>
            </xsl:when>
            <xsl:when test=" substring(normalize-space(@w:instr),1,10) = 'CREATEDATE' ">
                <text:creation-date>
                    <xsl:attribute name="style:data-style-name"><xsl:value-of select=" 'NDF1' "/></xsl:attribute>
                    <xsl:value-of select=".//w:t"/>
                </text:creation-date>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,8) = 'SAVEDATE' ">
                <text:modification-date>
                    <xsl:attribute name="style:data-style-name"><xsl:value-of select=" 'NDF1' "/></xsl:attribute>
                    <xsl:value-of select=".//w:t"/>
                </text:modification-date>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,4) = 'PAGE' ">
                <text:page-number text:select-page="current">
                    <xsl:variable name="num-format">
                        <xsl:call-template name="get_field_num_format">
                            <xsl:with-param name="input_MS_num_format" select="normalize-space(substring-after(@w:instr, '\*' ))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="style:num-format"><xsl:value-of select="$num-format"/></xsl:attribute>
                </text:page-number>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,8) = 'NUMPAGES' ">
                <text:page-count>
                    <xsl:variable name="num-format">
                        <xsl:call-template name="get_field_num_format">
                            <xsl:with-param name="input_MS_num_format" select="normalize-space(substring-after(@w:instr, '\*' ))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="style:num-format"><xsl:value-of select="$num-format"/></xsl:attribute>
                </text:page-count>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,8) = 'NUMWORDS' ">
                <text:word-count>
                    <xsl:variable name="num-format">
                        <xsl:call-template name="get_field_num_format">
                            <xsl:with-param name="input_MS_num_format" select="normalize-space(substring-after(@w:instr, '\*' ))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="style:num-format"><xsl:value-of select="$num-format"/></xsl:attribute>
                </text:word-count>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,8) = 'NUMCHARS' ">
                <text:character-count>
                    <xsl:variable name="num-format">
                        <xsl:call-template name="get_field_num_format">
                            <xsl:with-param name="input_MS_num_format" select="normalize-space(substring-after(@w:instr, '\*' ))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="style:num-format"><xsl:value-of select="$num-format"/></xsl:attribute>
                </text:character-count>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,6) = 'REVNUM' ">
                <text:editing-cycles>
                    <xsl:value-of select="w:r"/>
                </text:editing-cycles>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,7) = 'AUTONUM'  or  substring(normalize-space(@w:instr),1,10) = 'AUTONUMLGL' or substring(normalize-space(@w:instr),1,10) = 'AUTONUMOUT' ">
                <text:sequence>
                    <xsl:attribute name="text:ref-name">RefAutoNum<xsl:number count="w:instrText[contains(text(), 'AUTONUM') or contains(text(), 'AUTONUMLGL') or contains( text(), 'AUTONUMOUT') ] | w:fldSimple[contains(@w:instr,'AUTONUM') or contains(@w:instr, 'AUTONUMLGL') or contains(@w:instr, 'AUTONUMOUT') ] " from="/w:wordDocument/w:body" level="any" format="1"/></xsl:attribute>
                    <xsl:attribute name="text:name"><xsl:value-of select=" 'AutoNr' "/></xsl:attribute>
                    <xsl:attribute name="text:formula"><xsl:value-of select=" 'ooow:AutoNr + 1' "/></xsl:attribute>
                    <xsl:variable name="num-format">
                        <xsl:call-template name="get_field_num_format">
                            <xsl:with-param name="input_MS_num_format" select="normalize-space(substring-after(@w:instr, '\*' ))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="style:num-format"><xsl:value-of select="$num-format"/></xsl:attribute>
                </text:sequence>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,3) = 'SEQ' ">
                <text:sequence>
                    <xsl:attribute name="text:ref-name">Ref<xsl:number count="w:instrText[contains(text(), 'SEQ') ] | w:fldSimple[contains(@w:instr,'SEQ') ] " from="/w:wordDocument/w:body" level="any" format="1"/></xsl:attribute>
                    <xsl:variable name="seq_text_name">
                        <xsl:call-template name="get_seq_name">
                            <xsl:with-param name="input_seq_string" select="normalize-space(substring-after(@w:instr, 'SEQ'))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="text:name"><xsl:value-of select="$seq_text_name "/></xsl:attribute>
                    <xsl:attribute name="text:formula"><xsl:value-of select="concat (concat('ooow:',$seq_text_name), ' + 1' )"/></xsl:attribute>
                    <xsl:variable name="num-format">
                        <xsl:call-template name="get_field_num_format">
                            <xsl:with-param name="input_MS_num_format" select="normalize-space(substring-after(@w:instr, '\*' ))"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="style:num-format"><xsl:value-of select="$num-format"/></xsl:attribute>
                </text:sequence>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,6) = 'AUTHOR' ">
                <text:initial-creator>
                    <xsl:value-of select=" .//w:t"/>
                </text:initial-creator>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,5) = 'TITLE' ">
                <text:title>
                    <xsl:value-of select=" .//w:t"/>
                </text:title>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,7) = 'SUBJECT' ">
                <text:subject>
                    <xsl:value-of select=" .//w:t"/>
                </text:subject>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,8) = 'KEYWORDS' ">
                <text:keywords>
                    <xsl:value-of select=" .//w:t"/>
                </text:keywords>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,6) = 'FILLIN' ">
                <text:text-input>
                    <xsl:attribute name="text:description"><xsl:value-of select="substring-before(substring-after(@w:instr, '&quot;'), '&quot;')"/></xsl:attribute>
                    <xsl:value-of select=" .//w:t"/>
                </text:text-input>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,11) = 'DOCPROPERTY' ">
                <xsl:variable name="instr_command">
                    <xsl:value-of select="normalize-space (substring-after(@w:instr, 'DOCPROPERTY' ))"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains($instr_command, 'Author' ) ">
                        <text:user-field-get text:name="Author">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Bytes' ) ">
                        <text:user-field-get text:name="Bytes">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Category' ) ">
                        <text:user-field-get text:name="Category">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'CharactersWithSpaces' ) ">
                        <text:user-field-get text:name="CharactersWithSpaces">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Characters' ) ">
                        <text:user-field-get text:name="Characters">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Comments' ) ">
                        <text:user-field-get text:name="Comments">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Company' ) ">
                        <text:user-field-get text:name="Company">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'CreateTime' ) ">
                        <text:user-field-get text:name="CreateTime">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'HyperlinkBase' ) ">
                        <text:user-field-get text:name="HyperlinkBase">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Keywords' ) ">
                        <text:user-field-get text:name="Keywords">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'LastPrinted' ) ">
                        <text:user-field-get text:name="LastPrinted">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'LastSavedBy' ) ">
                        <text:user-field-get text:name="LastSavedBy">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'LastSavedTime' ) ">
                        <text:user-field-get text:name="LastSavedTime">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Lines' ) ">
                        <text:user-field-get text:name="Lines">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Manager' ) ">
                        <text:user-field-get text:name="Manager">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'NameofApplication' ) ">
                        <text:user-field-get text:name="NameofApplication">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'ODMADocId' ) ">
                        <text:user-field-get text:name="ODMADocId">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Pages' ) ">
                        <text:user-field-get text:name="Pages">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Paragraphs' ) ">
                        <text:user-field-get text:name="Paragraphs">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'RevisionNumber' ) ">
                        <text:user-field-get text:name="RevisionNumber">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Security' ) ">
                        <text:user-field-get text:name="Security">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Subject' ) ">
                        <text:user-field-get text:name="Subject">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Template' ) ">
                        <text:user-field-get text:name="Template">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Title' ) ">
                        <text:user-field-get text:name="Title">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'TotalEditingTime' ) ">
                        <text:user-field-get text:name="TotalEditingTime">
                        </text:user-field-get>
                    </xsl:when>
                    <xsl:when test="contains($instr_command, 'Words' ) ">
                        <text:user-field-get text:name="Words">
                        </text:user-field-get>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,10) = 'MERGEFIELD' ">
                <text:database-display text:database-name="" text:table-name="" text:table-type="table">
                    <xsl:attribute name="text:column-name"><xsl:value-of select="substring-before(substring-after(normalize-space(.), 'MERGEFIELD' ), ' ' ) "/></xsl:attribute>
                    <xsl:value-of select=" .//w:t"/>
                </text:database-display>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,8) = 'MERGEREC' ">
                <text:database-row-number text:database-name="" text:table-name="" text:table-type="table" style:num-format="A" text:value="0">
                    <xsl:value-of select=" .//w:t"/>
                </text:database-row-number>
            </xsl:when>
            <xsl:when test="substring(normalize-space(@w:instr),1,4) = 'NEXT' ">
                <text:database-next text:database-name="" text:table-name="" text:table-type="table" text:condition="">
                    <xsl:value-of select=" .//w:t"/>
                </text:database-next>
            </xsl:when>
            <xsl:otherwise>
                <!--  for  MS simple fields that can not map to  OOo writer fields, we just import the content of these fields -->
                <xsl:value-of select="w:r"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get_seq_name">
        <!-- this template is to get the identifier from the input MS seq string -->
        <xsl:param name="input_seq_string"/>
        <xsl:choose>
            <xsl:when test="contains( $input_seq_string, ' ' )">
                <xsl:value-of select="substring-before($input_seq_string, ' ' )"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$input_seq_string"/>
            </xsl:otherwise>
        </xsl:choose>
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
    <xsl:template match="w:instrText | w:fldSimple" mode="sequence_declare">
        <text:sequence-decl text:display-outline-level="0">
            <xsl:variable name="seq_variable_name">
                <xsl:choose>
                    <xsl:when test=" name() = 'w:instrText' ">
                        <xsl:if test="substring(normalize-space(text()),1,3) = 'SEQ' ">
                            <xsl:call-template name="get_seq_name">
                                <xsl:with-param name="input_seq_string" select="normalize-space( substring-after(text(), 'SEQ' ))"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test=" name() = 'w:fldSimple' ">
                        <xsl:if test="substring(normalize-space(@w:instr),1,3) = 'SEQ' ">
                            <xsl:call-template name="get_seq_name">
                                <xsl:with-param name="input_seq_string" select="normalize-space( substring-after(@w:instr, 'SEQ' ))"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="text:name"><xsl:value-of select="$seq_variable_name"/></xsl:attribute>
        </text:sequence-decl>
    </xsl:template>
    <!-- ===== the following templates are to generate the user fields declarations for MS word DocProperty field importing == -->
    <xsl:template name="user_fields_declare_docproperty">
        <xsl:variable name="document-field-root" select="/w:wordDocument/w:body//w:instrText[substring(normalize-space(text()),1,11) = 'DOCPROPERTY' ]  | /w:wordDocument/w:body//w:fldSimple[substring(normalize-space(@w:instr),1,11) = 'DOCPROPERTY' ] "/>
        <xsl:variable name="field_Author_nodeset" select="$document-field-root[contains(text(), 'Author')] | $document-field-root[contains(@w:instr, 'Author')]"/>
        <xsl:variable name="field_Bytes_nodeset" select="$document-field-root[contains(text(), 'Bytes')] | $document-field-root[contains(@w:instr, 'Bytes')]"/>
        <xsl:variable name="field_Category_nodeset" select="$document-field-root[contains(text(), 'Category')] | $document-field-root[contains(@w:instr, 'Category')]"/>
        <xsl:variable name="field_Characters_nodeset" select="$document-field-root[contains(text(), 'Characters')] | $document-field-root[contains(@w:instr, 'Characters')]"/>
        <xsl:variable name="field_CharactersWithSpaces_nodeset" select="$document-field-root[contains(text(), 'CharactersWithSpaces')] | $document-field-root[contains(@w:instr, 'CharactersWithSpaces')]"/>
        <xsl:variable name="field_Comments_nodeset" select="$document-field-root[contains(text(), 'Comments')] | $document-field-root[contains(@w:instr, 'Comments')]"/>
        <xsl:variable name="field_Company_nodeset" select="$document-field-root[contains(text(), 'Company')] | $document-field-root[contains(@w:instr, 'Company')]"/>
        <xsl:variable name="field_CreateTime_nodeset" select="$document-field-root[contains(text(), 'CreateTime')] | $document-field-root[contains(@w:instr, 'CreateTime')]"/>
        <xsl:variable name="field_HyperlinkBase_nodeset" select="$document-field-root[contains(text(), 'HyperlinkBase')] | $document-field-root[contains(@w:instr, 'HyperlinkBase')]"/>
        <xsl:variable name="field_Keywords_nodeset" select="$document-field-root[contains(text(), 'Keywords')] | $document-field-root[contains(@w:instr, 'Keywords')]"/>
        <xsl:variable name="field_LastPrinted_nodeset" select="$document-field-root[contains(text(), 'LastPrinted')] | $document-field-root[contains(@w:instr, 'LastPrinted')]"/>
        <xsl:variable name="field_LastSavedBy_nodeset" select="$document-field-root[contains(text(), 'LastSavedBy')] | $document-field-root[contains(@w:instr, 'LastSavedBy')]"/>
        <xsl:variable name="field_LastSavedTime_nodeset" select="$document-field-root[contains(text(), 'LastSavedTime')] | $document-field-root[contains(@w:instr, 'LastSavedTime')]"/>
        <xsl:variable name="field_Lines_nodeset" select="$document-field-root[contains(text(), 'Lines')] | $document-field-root[contains(@w:instr, 'Lines')]"/>
        <xsl:variable name="field_Manager_nodeset" select="$document-field-root[contains(text(), 'Manager')] | $document-field-root[contains(@w:instr, 'Manager')]"/>
        <xsl:variable name="field_NameofApplication_nodeset" select="$document-field-root[contains(text(), 'NameofApplication')] | $document-field-root[contains(@w:instr, 'NameofApplication')]"/>
        <xsl:variable name="field_ODMADocId_nodeset" select="$document-field-root[contains(text(), 'ODMADocId')] | $document-field-root[contains(@w:instr, 'ODMADocId')]"/>
        <xsl:variable name="field_Pages_nodeset" select="$document-field-root[contains(text(), 'Pages')] | $document-field-root[contains(@w:instr, 'Pages')]"/>
        <xsl:variable name="field_Paragraphs_nodeset" select="$document-field-root[contains(text(), 'Paragraphs')] | $document-field-root[contains(@w:instr, 'Paragraphs')]"/>
        <xsl:variable name="field_RevisionNumber_nodeset" select="$document-field-root[contains(text(), 'RevisionNumber')] | $document-field-root[contains(@w:instr, 'RevisionNumber')]"/>
        <xsl:variable name="field_Security_nodeset" select="$document-field-root[contains(text(), 'Security')] | $document-field-root[contains(@w:instr, 'Security')]"/>
        <xsl:variable name="field_Subject_nodeset" select="$document-field-root[contains(text(), 'Subject')] | $document-field-root[contains(@w:instr, 'Subject')]"/>
        <xsl:variable name="field_Template_nodeset" select="$document-field-root[contains(text(), 'Template')] | $document-field-root[contains(@w:instr, 'Template')]"/>
        <xsl:variable name="field_Title_nodeset" select="$document-field-root[contains(text(), 'Title')] | $document-field-root[contains(@w:instr, 'Title')]"/>
        <xsl:variable name="field_TotalEditingTime_nodeset" select="$document-field-root[contains(text(), 'TotalEditingTime')] | $document-field-root[contains(@w:instr, 'TotalEditingTime')]"/>
        <xsl:variable name="field_Words_nodeset" select="$document-field-root[contains(text(), 'Words')] | $document-field-root[contains(@w:instr, 'Words')]"/>
        <xsl:apply-templates select="$field_Author_nodeset[1]" mode="user_field_Author_declare"/>
        <xsl:apply-templates select="$field_Bytes_nodeset[1]" mode="user_field_Bytes_declare"/>
        <xsl:apply-templates select="$field_Category_nodeset[1]" mode="user_field_Category_declare"/>
        <xsl:apply-templates select="$field_Characters_nodeset[1]" mode="user_field_Characters_declare"/>
        <xsl:apply-templates select="$field_CharactersWithSpaces_nodeset[1]" mode="user_field_CharactersWithSpaces_declare"/>
        <xsl:apply-templates select="$field_Comments_nodeset[1]" mode="user_field_Comments_declare"/>
        <xsl:apply-templates select="$field_Company_nodeset[1]" mode="user_field_Company_declare"/>
        <xsl:apply-templates select="$field_CreateTime_nodeset[1]" mode="user_field_CreateTime_declare"/>
        <xsl:apply-templates select="$field_HyperlinkBase_nodeset[1]" mode="user_field_HyperlinkBase_declare"/>
        <xsl:apply-templates select="$field_Keywords_nodeset[1]" mode="user_field_Keywords_declare"/>
        <xsl:apply-templates select="$field_LastPrinted_nodeset[1]" mode="user_field_LastPrinted_declare"/>
        <xsl:apply-templates select="$field_LastSavedBy_nodeset[1]" mode="user_field_LastSavedBy_declare"/>
        <xsl:apply-templates select="$field_LastSavedTime_nodeset[1]" mode="user_field_LastSavedTime_declare"/>
        <xsl:apply-templates select="$field_Lines_nodeset[1]" mode="user_field_Lines_declare"/>
        <xsl:apply-templates select="$field_Manager_nodeset[1]" mode="user_field_Manager_declare"/>
        <xsl:apply-templates select="$field_NameofApplication_nodeset[1]" mode="user_field_NameofApplication_declare"/>
        <xsl:apply-templates select="$field_ODMADocId_nodeset[1]" mode="user_field_ODMADocId_declare"/>
        <xsl:apply-templates select="$field_Pages_nodeset[1]" mode="user_field_Pages_declare"/>
        <xsl:apply-templates select="$field_Paragraphs_nodeset[1]" mode="user_field_Paragraphs_declare"/>
        <xsl:apply-templates select="$field_RevisionNumber_nodeset[1]" mode="user_field_RevisionNumber_declare"/>
        <xsl:apply-templates select="$field_Security_nodeset[1]" mode="user_field_Security_declare"/>
        <xsl:apply-templates select="$field_Subject_nodeset[1]" mode="user_field_Subject_declare"/>
        <xsl:apply-templates select="$field_Template_nodeset[1]" mode="user_field_Template_declare"/>
        <xsl:apply-templates select="$field_Title_nodeset[1]" mode="user_field_Title_declare"/>
        <xsl:apply-templates select="$field_TotalEditingTime_nodeset[1]" mode="user_field_TotalEditingTime_declare"/>
        <xsl:apply-templates select="$field_Words_nodeset[1]" mode="user_field_Words_declare"/>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Author_declare">
        <text:user-field-decl office:value-type="string" text:name="Author">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Bytes_declare">
        <text:user-field-decl office:value-type="string" text:name="Bytes">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Category_declare">
        <text:user-field-decl office:value-type="string" text:name="Category">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Characters_declare">
        <text:user-field-decl office:value-type="string" text:name="Characters">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_CharactersWithSpaces_declare">
        <text:user-field-decl office:value-type="string" text:name="CharactersWithSpaces">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Comments_declare">
        <text:user-field-decl office:value-type="string" text:name="Comments">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Company_declare">
        <text:user-field-decl office:value-type="string" text:name="Company">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_CreateTime_declare">
        <text:user-field-decl office:value-type="string" text:name="CreateTime">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_HyperlinkBase_declare">
        <text:user-field-decl office:value-type="string" text:name="HyperlinkBase">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Keywords_declare">
        <text:user-field-decl office:value-type="string" text:name="Keywords">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_LastPrinted_declare">
        <text:user-field-decl office:value-type="string" text:name="LastPrinted">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_LastSavedBy_declare">
        <text:user-field-decl office:value-type="string" text:name="LastSavedBy">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_LastSavedTime_declare">
        <text:user-field-decl office:value-type="string" text:name="LastSavedTime">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Lines_declare">
        <text:user-field-decl office:value-type="string" text:name="Lines">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Manager_declare">
        <text:user-field-decl office:value-type="string" text:name="Manager">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_NameofApplication_declare">
        <text:user-field-decl office:value-type="string" text:name="NameofApplication">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_ODMADocId_declare">
        <text:user-field-decl office:value-type="string" text:name="ODMADocId">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Pages_declare">
        <text:user-field-decl office:value-type="string" text:name="Pages">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Paragraphs_declare">
        <text:user-field-decl office:value-type="string" text:name="Paragraphs">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_RevisionNumber_declare">
        <text:user-field-decl office:value-type="string" text:name="RevisionNumber">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Security_declare">
        <text:user-field-decl office:value-type="string" text:name="Security">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Subject_declare">
        <text:user-field-decl office:value-type="string" text:name="Subject">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Template_declare">
        <text:user-field-decl office:value-type="string" text:name="Template">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Title_declare">
        <text:user-field-decl office:value-type="string" text:name="Title">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_TotalEditingTime_declare">
        <text:user-field-decl office:value-type="string" text:name="TotalEditingTime">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="user_field_Words_declare">
        <text:user-field-decl office:value-type="string" text:name="Words">
            <xsl:variable name="field_content">
                <xsl:choose>
                    <xsl:when test="name() = 'w:instrText' ">
                        <xsl:call-template name="get-fldchar-content">
                            <xsl:with-param name="next_node" select="../following-sibling::w:r[1]"/>
                            <xsl:with-param name="sibling_number" select=" 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="name() = 'w:fldSimple' ">
                        <xsl:value-of select=".//w:t"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="office:string-value"><xsl:value-of select="$field_content"/></xsl:attribute>
        </text:user-field-decl>
    </xsl:template>
    <!-- =========this following template to convert the ms number format to OOo writer format === -->
    <xsl:template name="get_field_num_format">
        <xsl:param name="input_MS_num_format"/>
        <xsl:choose>
            <xsl:when test="contains($input_MS_num_format, 'Arabic' ) ">
                <xsl:text>1</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'roman' ) ">
                <xsl:text>i</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'ROMAN' ) ">
                <xsl:text>I</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'alphabetic' ) ">
                <xsl:text>a</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'ALPHABETIC' ) ">
                <xsl:text>A</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>1</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--xsl:template name="get_field_num_format">
        <xsl:param name="input_MS_num_format"/>
        <xsl:choose>
            <xsl:when test="contains($input_MS_num_format, 'Arabic' ) ">
                <xsl:text>1</xsl:text>
            </xsl:when>
            <xsl:when test="contains ($input_MS_num_format, 'CircleNum' )">
                <xsl:text>①, ②, ③, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'roman' ) ">
                <xsl:text>i</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'ROMAN' ) ">
                <xsl:text>I</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'CHINESENUM3' )">
                <xsl:text>一, 二, 三, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'CHINESENUM2' )">
                <xsl:text>壹,  貳, 參, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'DBNUM3' ) ">
                <xsl:text>壱, 弐, 参, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format,  'ZODIAC2' ) ">
                <xsl:text>子, 丑, 寅, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'ZODIAC1' )  ">
                <xsl:text>甲, 乙, 丙, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'Iroha'  ) ">
                <xsl:text>イ, ロ, ハ, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'Aiueo' ) ">
                <xsl:text>ｱ, ｲ, ｳ, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'alphabetic' ) ">
                <xsl:text>a</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'ALPHABETIC' ) ">
                <xsl:text>A</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'hebrew1' ) ">
                <xsl:text>א, י, ק, ...</xsl:text>
            </xsl:when>
        <xsl:when test="contains($input_MS_num_format, 'hebrew2' ) ">
                <xsl:text>א, ב, ג, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format,  'ArabicAlpha' ) ">
                <xsl:text>أ, ب, ت, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'ThaiLetter' ) ">
                <xsl:text>ก, ข, ฃ, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'Chosung' ) ">
                <xsl:text>ㄱ, ㄴ, ㄷ, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'Ganada' ) ">
                <xsl:text>가, 나, 다, ...</xsl:text>
            </xsl:when>
            <xsl:when test="contains($input_MS_num_format, 'Aiueo' ) ">
                <xsl:text>ア, イ, ウ, ...</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>1</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template -->
    <!-- ========= the following code is to generate the date styles for date/time fields ============ -->
    <!--the default date style content -->
    <xsl:template name="default_date_style_content">
        <number:year number:style="long">
        </number:year>
        <number:text>/</number:text>
        <number:month>
        </number:month>
        <number:text>/</number:text>
        <number:day>
        </number:day>
        <number:text>  </number:text>
        <number:hours>
        </number:hours>
        <number:text>:</number:text>
        <number:minutes number:style="long">
            </number:minutes>
        <number:text>:</number:text>
        <number:seconds number:style="long">
            </number:seconds>
        <number:am-pm>
            </number:am-pm>
    </xsl:template>
    <!--the default date style -->
    <xsl:template name="default_date_style">
        <number:date-style style:name="NDF1">
            <xsl:call-template name="default_date_style_content"/>
        </number:date-style>
    </xsl:template>
    <xsl:template match="w:instrText | w:fldSimple" mode="style">
        <!-- this template is to generate the date, time styles according to the content of DateFormatString ( the string after \@ ) in w:instrText | w:fldSimple/@w:instr -->
        <xsl:choose>
            <xsl:when test=" name() = 'w:instrText' ">
                <xsl:if test="substring(normalize-space(.),1,4) = 'DATE'  or substring(normalize-space(.),1,4) = 'TIME'  or  substring(normalize-space(.),1,9) = 'PRINTDATE'  or substring(normalize-space(.),1,10) =              'CREATEDATE'  or substring(normalize-space(.),1,8) = 'SAVEDATE' ">
                    <number:date-style>
                        <xsl:attribute name="style:name">ND<xsl:number count="w:instrText | w:fldSimple" from="/w:wordDocument/w:body" level="any" format="1"/></xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="contains(text(), '\@' )">
                                <!-- if has the date format string then call the template  parse_field_date_format to produce the style-->
                                <xsl:variable name="MS_date_format">
                                    <xsl:value-of select="normalize-space(substring-before(substring-after(normalize-space(substring-after(text(), '\@')), '&#x22;'), '&#x22;'))"/>
                                </xsl:variable>
                                <xsl:if test="string-length($MS_date_format) &gt;=1">
                                    <xsl:call-template name="parse_field_date_format">
                                        <xsl:with-param name="input_MS_date_format" select="$MS_date_format"/>
                                    </xsl:call-template>
                                </xsl:if>
                                <xsl:if test="string-length($MS_date_format) &lt;1">
                                    <xsl:call-template name="default_date_style_content"/>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- if doesn't have date format string so we use the following default format -->
                                <xsl:call-template name="default_date_style_content"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </number:date-style>
                </xsl:if>
            </xsl:when>
            <xsl:when test="name() = 'w:fldSimple' ">
                <xsl:if test="substring(normalize-space(@w:instr),1,4) = 'DATE'  or substring(normalize-space(@w:instr),1,4) = 'TIME'  or  substring(normalize-space(@w:instr),1,9) = 'PRINTDATE'  or substring(normalize-space(@w:instr),1,10) = 'CREATEDATE'  or substring(normalize-space(@w:instr),1,8) = 'SAVEDATE' ">
                    <!-- we use the default date/time style for w:fldsimple -->
                    <number:date-style>
                        <xsl:attribute name="style:name">NDF1</xsl:attribute>
                        <xsl:call-template name="default_date_style_content"/>
                    </number:date-style>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="parse_field_date_format">
        <!--this template is to parse and generate the content of the date-time style base on the content of input_MS_date_format -->
        <xsl:param name="input_MS_date_format"/>
        <xsl:if test="string-length($input_MS_date_format) &gt;= 1">
            <xsl:variable name="date_token_start_position">
                <!-- to find the start position of the token ' d, M, yy, YY,m etc. -->
                <xsl:call-template name="find_token_startposition">
                    <xsl:with-param name="input_string" select="$input_MS_date_format"/>
                    <xsl:with-param name="token_start_position" select="1"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="date_token">
                <!-- get the matched the token such as MM, YYYY, yy,MMMM etc. -->
                <xsl:call-template name="get_date_token">
                    <xsl:with-param name="input_string2" select="substring($input_MS_date_format,$date_token_start_position)"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:if test="number($date_token_start_position) &gt; 1">
                <!-- print the text between the tokens -->
                <number:text>
                    <xsl:value-of select="substring($input_MS_date_format,1, number($date_token_start_position - 1) )"/>
                </number:text>
            </xsl:if>
            <xsl:call-template name="map_date_format_pattern">
                <xsl:with-param name="input_date_format_pattern" select="$date_token"/>
            </xsl:call-template>
            <xsl:variable name="unparsed_string">
                <xsl:value-of select="substring($input_MS_date_format,$date_token_start_position + string-length($date_token))"/>
            </xsl:variable>
            <xsl:call-template name="parse_field_date_format">
                <xsl:with-param name="input_MS_date_format" select="$unparsed_string"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="find_token_startposition">
        <xsl:param name="input_string"/>
        <xsl:param name="token_start_position"/>
        <xsl:choose>
            <xsl:when test="starts-with( $input_string,'yy') or starts-with($input_string,'YY') or starts-with($input_string,'HH') or starts-with($input_string,'hh') or starts-with($input_string,'ss') or starts-with($input_string,'SS')">
                <xsl:value-of select="$token_start_position"/>
            </xsl:when>
            <xsl:when test="starts-with($input_string, 'M')  or starts-with($input_string,'d') or starts-with($input_string, 'm')  or starts-with($input_string,'D') or starts-with($input_string,'h') or starts-with($input_string,'H') or starts-with($input_string,'s') or starts-with($input_string,'S')">
                <xsl:value-of select="$token_start_position"/>
            </xsl:when>
            <xsl:when test="starts-with($input_string, 'am/pm') or starts-with($input_string, 'AM/PM') ">
                <xsl:value-of select="$token_start_position"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="new_string">
                    <xsl:value-of select="substring($input_string, 2)"/>
                </xsl:variable>
                <xsl:call-template name="find_token_startposition">
                    <xsl:with-param name="input_string" select="$new_string"/>
                    <xsl:with-param name="token_start_position" select="$token_start_position +1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="get_date_token">
        <xsl:param name="input_string2"/>
        <xsl:choose>
            <xsl:when test="starts-with($input_string2, 'am/pm') or starts-with($input_string2, 'AM/PM') ">
                <xsl:value-of select=" 'am/pm' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'yyyy') or starts-with($input_string2, 'YYYY')">
                <xsl:value-of select=" 'yyyy' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'yy') or starts-with($input_string2, 'YY')">
                <xsl:value-of select=" 'yy' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'MMMM') ">
                <xsl:value-of select=" 'MMMM' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'MMM')">
                <xsl:value-of select=" 'MMM' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'MM')">
                <xsl:value-of select=" 'MM' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'M') ">
                <xsl:value-of select=" 'M' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'dddd') or starts-with($input_string2, 'DDDD')">
                <xsl:value-of select=" 'dddd' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'ddd') or starts-with($input_string2, 'DDD')">
                <xsl:value-of select=" 'ddd' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'dd') or starts-with($input_string2, 'dd')">
                <xsl:value-of select=" 'dd' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'd') or starts-with($input_string2, 'D')">
                <xsl:value-of select=" 'd' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'mm')">
                <xsl:value-of select=" 'mm' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'm')">
                <xsl:value-of select=" 'm' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'hh') or starts-with($input_string2, 'HH')">
                <xsl:value-of select=" 'hh' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'h') or starts-with($input_string2, 'H')">
                <xsl:value-of select=" 'h' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 'ss') or starts-with($input_string2, 'SS')">
                <xsl:value-of select=" 'ss' "/>
            </xsl:when>
            <xsl:when test="starts-with($input_string2, 's') or starts-with($input_string2, 'S')">
                <xsl:value-of select=" 's' "/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="map_date_format_pattern">
        <!-- this template map the MS date time format to OOo date time format -->
        <xsl:param name="input_date_format_pattern"/>
        <xsl:choose>
            <xsl:when test="$input_date_format_pattern = 'am/pm' ">
                <number:am-pm>
            </number:am-pm>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'yyyy' ">
                <number:year number:style="long">
            </number:year>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'yy' ">
                <number:year>
            </number:year>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'MMMM' ">
                <number:month number:style="long" number:textual="true">
            </number:month>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'MMM'  ">
                <number:month number:textual="true">
            </number:month>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'MM' ">
                <number:month number:style="long">
            </number:month>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'M' ">
                <number:month>
            </number:month>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'dddd' ">
                <number:day-of-week number:style="long">
            </number:day-of-week>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'ddd' ">
                <number:day-of-week>
            </number:day-of-week>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'dd' ">
                <number:day number:style="long">
            </number:day>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'd' ">
                <number:day>
            </number:day>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'mm' ">
                <number:minutes number:style="long">
            </number:minutes>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'm' ">
                <number:minutes>
            </number:minutes>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'hh' ">
                <number:hours number:style="long">
        </number:hours>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'h' ">
                <number:hours>
            </number:hours>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 'ss' ">
                <number:seconds number:style="long">
        </number:seconds>
            </xsl:when>
            <xsl:when test="$input_date_format_pattern = 's' ">
                <number:seconds>
        </number:seconds>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
