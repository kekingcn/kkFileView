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
<xsl:stylesheet version="1.0" encoding="UTF-8"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:office="http://openoffice.org/2000/office"
    xmlns:style="http://openoffice.org/2000/style"
    xmlns:table="http://openoffice.org/2000/table"
    xmlns:draw="http://openoffice.org/2000/drawing"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:meta="http://openoffice.org/2000/meta"
    xmlns:number="http://openoffice.org/2000/datastyle"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:chart="http://openoffice.org/2000/chart"
    xmlns:help="http://openoffice.org/2000/help"
    xmlns:index="http://sun.com/2000/XMLSearch"
    xmlns:text="http://openoffice.org/2000/text">

<xsl:param name="Language" select="'en-US'"/>
<xsl:output method="text" encoding="UTF-8"/>

<xsl:template match="/">
    <xsl:apply-templates select="//title" mode="include"/>
    <xsl:apply-templates select="//paragraph[@role='heading']" mode="include"/>
</xsl:template>

<xsl:template match="*" mode="include">
    <xsl:value-of select="."/>
    <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="*"/>

</xsl:stylesheet>

