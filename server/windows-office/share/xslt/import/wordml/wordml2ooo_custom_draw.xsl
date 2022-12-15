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
    <xsl:template name="ms_word_draw_map2ooo_custom_draw">
        <xsl:param name="ms_word_draw_type"/>
        <!-- all ooo draw names are get from EnhancedCustomShapeGeometry.idl-->
        <xsl:choose>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t5'  ">
                <xsl:value-of select=" 'isosceles-triangle'"/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type ='#_x0000_t6' ">
                <xsl:value-of select="  'right-triangle' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t8' ">
                <xsl:value-of select=" 'trapezoid' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t4' ">
                <xsl:value-of select=" 'diamond' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t9'  ">
                <xsl:value-of select=" 'hexagon' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =   '#_x0000_t7' ">
                <xsl:value-of select="'parallelogram' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t56' ">
                <xsl:value-of select=" 'pentagon' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t10' ">
                <xsl:value-of select=" 'octagon' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t11' ">
                <xsl:value-of select=" 'cross' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t23' ">
                <xsl:value-of select=" 'ring' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t95' ">
                <xsl:value-of select=" 'block-arc'  "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t22' ">
                <xsl:value-of select=" 'can' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t16' ">
                <xsl:value-of select=" 'cube' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t65' ">
                <xsl:value-of select=" 'paper' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t96' ">
                <xsl:value-of select=" 'smiley' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t183' ">
                <xsl:value-of select=" 'sun' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t184' ">
                <xsl:value-of select=" 'moon' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t74' ">
                <xsl:value-of select=" 'heart' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t57' ">
                <xsl:value-of select=" 'forbidden' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type ='#_x0000_t85' ">
                <xsl:value-of select="  'left-bracket'  "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t86' ">
                <xsl:value-of select=" 'right-bracket' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t87' ">
                <xsl:value-of select=" 'left-brace'  "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t88' ">
                <xsl:value-of select=" 'right-brace' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t185' ">
                <xsl:value-of select=" 'bracket-pair' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t186' ">
                <xsl:value-of select=" 'brace-pair' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t189' ">
                <xsl:value-of select=" 'quad-bevel' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t66' ">
                <xsl:value-of select=" 'left-arrow' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t67' ">
                <xsl:value-of select=" 'down-arrow' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t68' ">
                <xsl:value-of select=" 'up-arrow' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t13' ">
                <xsl:value-of select=" 'right-arrow' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t69' ">
                <xsl:value-of select=" 'left-right-arrow' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t70' ">
                <xsl:value-of select=" 'up-down-arrow' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t89' ">
                <xsl:value-of select=" 'mso-spt89' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t76' ">
                <xsl:value-of select=" 'quad-arrow' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t94' ">
                <xsl:value-of select=" 'notched-right-arrow' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t177' ">
                <xsl:value-of select=" 'pentagon-right' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t55' ">
                <xsl:value-of select=" 'chevron' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t79' ">
                <xsl:value-of select=" 'up-arrow-callout' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t80' ">
                <xsl:value-of select=" 'down-arrow-callout' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t82' ">
                <xsl:value-of select=" 'up-down-arrow-callout' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t103' ">
                <xsl:value-of select=" 'circular-arrow' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t109' ">
                <xsl:value-of select=" 'flowchart-process'  "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t116' ">
                <xsl:value-of select=" 'flowchart-alternate-process' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t110' ">
                <xsl:value-of select=" 'flowchart-decision' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t111' ">
                <xsl:value-of select=" 'flowchart-data' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =   '#_x0000_t112' ">
                <xsl:value-of select=" 'flowchart-predefined-process' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t113' ">
                <xsl:value-of select=" 'flowchart-internal-storage'  "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t114' ">
                <xsl:value-of select=" 'flowchart-document'  "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t115' ">
                <xsl:value-of select=" 'flowchart-multidocument' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t116' ">
                <xsl:value-of select=" 'flowchart-terminator' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t117' ">
                <xsl:value-of select=" 'flowchart-preparation' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t118' ">
                <xsl:value-of select=" 'flowchart-manual-input' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t119' ">
                <xsl:value-of select=" 'flowchart-manual-operation' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t120' ">
                <xsl:value-of select=" 'flowchart-connector' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t177' ">
                <xsl:value-of select=" 'flowchart-off-page-connector' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t121' ">
                <xsl:value-of select=" 'flowchart-card' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t122'  ">
                <xsl:value-of select=" 'flowchart-punched-tape' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t123' ">
                <xsl:value-of select=" 'flowchart-summing-junction'  "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t124' ">
                <xsl:value-of select=" 'flowchart-or'  "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t125'  ">
                <xsl:value-of select=" 'flowchart-collate' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t126' ">
                <xsl:value-of select=" 'flowchart-sort' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t127'  ">
                <xsl:value-of select=" 'flowchart-extract' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t128' ">
                <xsl:value-of select=" 'flowchart-merge' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t130'  ">
                <xsl:value-of select="  'flowchart-stored-data' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t135' ">
                <xsl:value-of select=" 'flowchart-delay'  "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t131'  ">
                <xsl:value-of select=" 'flowchart-sequential-access' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t132' ">
                <xsl:value-of select=" 'flowchart-magnetic-disk' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t133' ">
                <xsl:value-of select=" 'flowchart-direct-access-storage' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t134' ">
                <xsl:value-of select=" 'flowchart-display'  "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t61' ">
                <xsl:value-of select=" 'rectangular-callout' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t62' ">
                <xsl:value-of select=" 'round-rectangular-callout'  "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t63' ">
                <xsl:value-of select=" 'round-callout' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t106' ">
                <xsl:value-of select=" 'cloud-callout' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type =  '#_x0000_t50' ">
                <xsl:value-of select=" 'line-callout-1' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t51' ">
                <xsl:value-of select=" 'line-callout-2' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t47' ">
                <xsl:value-of select=" 'line-callout-3' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t72' ">
                <xsl:value-of select=" 'bang' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t187' ">
                <xsl:value-of select=" 'star4' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t12' ">
                <xsl:value-of select=" 'star5' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t58' ">
                <xsl:value-of select=" 'star8' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t92' ">
                <xsl:value-of select=" 'star24' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t97' ">
                <xsl:value-of select=" 'vertical-scroll' "/>
            </xsl:when>
            <xsl:when test="$ms_word_draw_type = '#_x0000_t98' ">
                <xsl:value-of select=" 'horizontal-scroll' "/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
