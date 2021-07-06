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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" exclude-result-prefixes="office table style text draw svg   dc config xlink meta oooc dom ooo chart math dr3d form script ooow draw">
    <xsl:template name="ooo_custom_draw2ms_word_draw_map">
        <xsl:param name="ooo_predefined_type"/>
        <!-- all ooo draw names are get from EnhancedCustomShapeGeometry.idl-->
        <xsl:choose>
            <xsl:when test="$ooo_predefined_type = 'isosceles-triangle' ">
                <xsl:value-of select=" '#_x0000_t5' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'right-triangle' ">
                <xsl:value-of select=" '#_x0000_t6' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'trapezoid' ">
                <xsl:value-of select=" '#_x0000_t8' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'diamond' ">
                <xsl:value-of select=" '#_x0000_t4' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'hexagon' ">
                <xsl:value-of select=" '#_x0000_t9' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'parallelogram' ">
                <xsl:value-of select=" '#_x0000_t7' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'pentagon' ">
                <xsl:value-of select=" '#_x0000_t56' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'octagon' ">
                <xsl:value-of select=" '#_x0000_t10' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'cross' ">
                <xsl:value-of select=" '#_x0000_t11' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'ring' ">
                <xsl:value-of select=" '#_x0000_t23' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'block-arc' ">
                <xsl:value-of select=" '#_x0000_t95' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'can' ">
                <xsl:value-of select=" '#_x0000_t22' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'cube' ">
                <xsl:value-of select=" '#_x0000_t16' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'paper' ">
                <xsl:value-of select=" '#_x0000_t65' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'smiley' ">
                <xsl:value-of select=" '#_x0000_t96' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'sun' ">
                <xsl:value-of select=" '#_x0000_t183' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'moon' ">
                <xsl:value-of select=" '#_x0000_t184' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'heart' ">
                <xsl:value-of select=" '#_x0000_t74' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'forbidden' ">
                <xsl:value-of select=" '#_x0000_t57' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'left-bracket' ">
                <xsl:value-of select=" '#_x0000_t85' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'right-bracket' ">
                <xsl:value-of select=" '#_x0000_t86' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'left-brace' ">
                <xsl:value-of select=" '#_x0000_t87' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'right-brace' ">
                <xsl:value-of select=" '#_x0000_t88' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'bracket-pair' ">
                <xsl:value-of select=" '#_x0000_t185' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'brace-pair' ">
                <xsl:value-of select=" '#_x0000_t186' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'quad-bevel' ">
                <xsl:value-of select=" '#_x0000_t189' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'left-arrow' ">
                <xsl:value-of select=" '#_x0000_t66' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'down-arrow' ">
                <xsl:value-of select=" '#_x0000_t67' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'up-arrow' ">
                <xsl:value-of select=" '#_x0000_t68' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'right-arrow' ">
                <xsl:value-of select=" '#_x0000_t13' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'left-right-arrow' ">
                <xsl:value-of select=" '#_x0000_t69' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'up-down-arrow' ">
                <xsl:value-of select=" '#_x0000_t70' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'mso-spt89' ">
                <xsl:value-of select=" '#_x0000_t89' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'quad-arrow' ">
                <xsl:value-of select=" '#_x0000_t76' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'notched-right-arrow' ">
                <xsl:value-of select=" '#_x0000_t94' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'pentagon-right' ">
                <xsl:value-of select=" '#_x0000_t177' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'chevron' ">
                <xsl:value-of select=" '#_x0000_t55' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'up-arrow-callout' ">
                <xsl:value-of select=" '#_x0000_t79' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'down-arrow-callout' ">
                <xsl:value-of select=" '#_x0000_t80' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'up-down-arrow-callout' ">
                <xsl:value-of select=" '#_x0000_t82' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'circular-arrow' ">
                <xsl:value-of select=" '#_x0000_t103' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-process' ">
                <xsl:value-of select=" '#_x0000_t109' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-alternate-process' ">
                <xsl:value-of select=" '#_x0000_t116' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-decision' ">
                <xsl:value-of select=" '#_x0000_t110' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-data' ">
                <xsl:value-of select=" '#_x0000_t111' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-predefined-process' ">
                <xsl:value-of select=" '#_x0000_t112' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-internal-storage' ">
                <xsl:value-of select=" '#_x0000_t113' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-document' ">
                <xsl:value-of select=" '#_x0000_t114' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-multidocument' ">
                <xsl:value-of select=" '#_x0000_t115' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-terminator' ">
                <xsl:value-of select=" '#_x0000_t116' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-preparation' ">
                <xsl:value-of select=" '#_x0000_t117' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-manual-input' ">
                <xsl:value-of select=" '#_x0000_t118' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-manual-operation' ">
                <xsl:value-of select=" '#_x0000_t119' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-connector' ">
                <xsl:value-of select=" '#_x0000_t120' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-off-page-connector' ">
                <xsl:value-of select=" '#_x0000_t177' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-card' ">
                <xsl:value-of select=" '#_x0000_t121' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-punched-tape' ">
                <xsl:value-of select=" '#_x0000_t122' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-summing-junction' ">
                <xsl:value-of select=" '#_x0000_t123' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-or' ">
                <xsl:value-of select=" '#_x0000_t124' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-collate' ">
                <xsl:value-of select=" '#_x0000_t125' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-sort' ">
                <xsl:value-of select=" '#_x0000_t126' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-extract' ">
                <xsl:value-of select=" '#_x0000_t127' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-merge' ">
                <xsl:value-of select=" '#_x0000_t128' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-stored-data' ">
                <xsl:value-of select=" '#_x0000_t130' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-delay' ">
                <xsl:value-of select=" '#_x0000_t135' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-sequential-access' ">
                <xsl:value-of select=" '#_x0000_t131' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-magnetic-disk' ">
                <xsl:value-of select=" '#_x0000_t132' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-direct-access-storage' ">
                <xsl:value-of select=" '#_x0000_t133' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'flowchart-display' ">
                <xsl:value-of select=" '#_x0000_t134' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'rectangular-callout' ">
                <xsl:value-of select=" '#_x0000_t61' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'round-rectangular-callout' ">
                <xsl:value-of select=" '#_x0000_t62' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'round-callout' ">
                <xsl:value-of select=" '#_x0000_t63' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'cloud-callout' ">
                <xsl:value-of select=" '#_x0000_t106' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'line-callout-1' ">
                <xsl:value-of select=" '#_x0000_t50' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'line-callout-2' ">
                <xsl:value-of select=" '#_x0000_t51' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'line-callout-3' ">
                <xsl:value-of select=" '#_x0000_t47' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'bang' ">
                <xsl:value-of select=" '#_x0000_t72' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'star4' ">
                <xsl:value-of select=" '#_x0000_t187' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'star5' ">
                <xsl:value-of select=" '#_x0000_t12' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'star8' ">
                <xsl:value-of select=" '#_x0000_t58' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'star24' ">
                <xsl:value-of select=" '#_x0000_t92' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'vertical-scroll' ">
                <xsl:value-of select=" '#_x0000_t97' "/>
            </xsl:when>
            <xsl:when test="$ooo_predefined_type = 'horizontal-scroll' ">
                <xsl:value-of select=" '#_x0000_t98' "/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
