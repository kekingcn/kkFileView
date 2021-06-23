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
<!--
    For further documentation and updates visit http://xml.openoffice.org/odf2xhtml
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- DPI (dots per inch) the standard resolution of given pictures (necessary for the conversion of 'cm' into 'pixel')
         Although many pictures have a 96 dpi resolution, a higher resolution give better results for common browsers -->
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
    <!-- changing measure to twip (cp. section comment) -->
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
    <xsl:template name="ConvertMeasure">
        <xsl:param name="TargetMeasure" select="'cm'"/>
        <xsl:param name="TargetTruncate" select=" 'all' "/>
        <xsl:param name="value"/>
        <!-- When TargetTruncate ='all'  it returns the number whichsoever the return value is negative or positive
            When TargetTruncate ='nonNegative' it only returns nonNegative number, all negative number to be returned as 0
            When TargetTruncate ='positive" it only returns positive number, all nonPositive number to be returned as 1 -->
        <xsl:variable name="return_value">
            <xsl:choose>
                <!-- remove the measure mark, if the value is null, the result should be 0. Must be the first case  -->
                <xsl:when test="string-length(translate(string($value),'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ','')) = 0">0</xsl:when>
                <xsl:when test="string-length(translate(string($value),'- .0123456789','')) = 0">
                    <xsl:value-of select="$value"/>
                </xsl:when>
                <xsl:when test="$TargetMeasure = 'cm'">
                    <xsl:call-template name="convert2cm">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$TargetMeasure = 'pt'">
                    <xsl:call-template name="convert2pt">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$TargetMeasure = 'twip'">
                    <xsl:call-template name="convert2twip">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$TargetMeasure = 'in'">
                    <xsl:call-template name="convert2in">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$TargetTruncate = 'all' ">
                <xsl:choose>
                    <xsl:when test="string(number($TargetMeasure)) = 'NaN' ">
                        <xsl:value-of select=" '0' "/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$return_value"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$TargetTruncate = 'nonNegative' ">
                <xsl:choose>
                    <xsl:when test="string(number($TargetMeasure)) = 'NaN' ">
                        <xsl:value-of select=" '0' "/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test=" $return_value &lt; 0  ">
                                <xsl:value-of select=" '0' "/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$return_value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$TargetTruncate = 'positive' ">
                <xsl:choose>
                    <xsl:when test="string(number($TargetMeasure)) = 'NaN' ">
                        <xsl:value-of select=" '1' "/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test=" $return_value &lt;= 0 ">
                                <xsl:value-of select=" '1' "/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$return_value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Add-With-Measure">
        <xsl:param name="value1"/>
        <xsl:param name="value2"/>
        <xsl:param name="TargetMeasure" select="'in'"/>
        <xsl:variable name="number-value1">
            <xsl:call-template name="ConvertMeasure">
                <xsl:with-param name="value" select="$value1"/>
                <xsl:with-param name="TargetMeasure" select="$TargetMeasure"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="number-value2">
            <xsl:call-template name="ConvertMeasure">
                <xsl:with-param name="value" select="$value2"/>
                <xsl:with-param name="TargetMeasure" select="$TargetMeasure"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$number-value1 + $number-value2"/>
    </xsl:template>
</xsl:stylesheet>
