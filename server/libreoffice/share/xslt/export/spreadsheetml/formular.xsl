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
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
    xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dom="http://www.w3.org/2001/xml-events"
    xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
    xmlns:math="http://www.w3.org/1998/Math/MathML"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:ooo="http://openoffice.org/2004/office"
    xmlns:oooc="http://openoffice.org/2004/calc"
    xmlns:ooow="http://openoffice.org/2004/writer"
    xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xt="http://www.jclark.com/xt"
    xmlns:common="http://exslt.org/common"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:c="urn:schemas-microsoft-com:office:component:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x2="http://schemas.microsoft.com/office/excel/2003/xml" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="chart config dc dom dr3d draw fo form math meta number office ooo oooc ooow script style svg table text xlink xt common xalan">


    <!-- Mapping @table:formula to @ss:Formula translating the expression syntax -->
    <xsl:template match="@table:formula">
        <xsl:param name="calculatedCellPosition" />
        <xsl:param name="calculatedRowPosition" />

        <xsl:attribute name="ss:Formula">
            <xsl:call-template name="translate-formular-expression">
                <xsl:with-param name="rowPos"    select="$calculatedRowPosition" />
                <xsl:with-param name="columnPos" select="$calculatedCellPosition" />
                <xsl:with-param name="expression" select="." />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>


    <!-- Translate OOOC formula expressions of table cells to spreadsheetml expression

        For example:
            "oooc:=ROUNDDOWN(123.321;2)"
                to "=ROUNDDOWN(123.321,2)"
            "oooc:=([.B2]-[.C2])"
                to  "=(RC[-2]-RC[-1])"
            "oooc:=DCOUNTA([.E14:.F21];[.F14];[.H14:.I15])"
                to  "=DCOUNTA(R[-17]C[3]:R[-10]C[4],R[-17]C[4],R[-17]C[6]:R[-16]C[7])"   -->
    <xsl:template name="translate-formular-expression">
        <!--  return position or range for formula or other -->
        <xsl:param name="rowPos" /> <!-- the position in row (vertical) of cell -->
        <xsl:param name="columnPos" /> <!-- the position in column (horizontal of cell) -->
        <xsl:param name="expression" /> <!-- the expression string to be converted  -->

        <xsl:choose>
            <xsl:when test="$expression != ''">
                <xsl:choose>
                    <!-- OASIS Open Document XML formular expressions  -->
                    <xsl:when test="starts-with($expression,'oooc:')">
                        <!-- giving out the '=', which will be removed with 'oooc:=' to enable recursive string parsing  -->
                        <xsl:text>=</xsl:text>
                        <xsl:call-template name="function-parameter-mapping">
                            <xsl:with-param name="rowPos" select="$rowPos" />
                            <xsl:with-param name="columnPos" select="$columnPos" />
                            <!-- 1) remove 'oooc:=' prefix and exchange ';' with ',' -->
                            <xsl:with-param name="expression" select="translate(substring($expression,7),';',',')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$expression" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$expression" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- As the function API of our Office and MS Office show differences in the argumentlists,
            -   sometimes the last parameter have to be neglected
            -   sometimes a default have to be added
        these exchanges have to be done as well -->
    <xsl:template name="function-parameter-mapping">
        <xsl:param name="rowPos" /> <!-- the position in row (vertical of cell) -->
        <xsl:param name="columnPos" /> <!-- the position in column (horizontal of cell) -->
        <xsl:param name="expression" /> <!-- expression to be exchanged -->

        <!-- Choose if the expression contains one of the function, which might need changes -->
        <xsl:choose>
            <!-- if not contain one of the functions, which need parameter mapping -->
            <xsl:when test="not(contains($expression, 'ADDRESS(') or
                                contains($expression, 'CEILING(') or
                                contains($expression, 'FLOOR(') or
                                contains($expression, 'IF(') or
                                contains($expression, 'ROUND('))">
                <!-- simply translate possibly existing column & row references -->
                <xsl:call-template name="translate-oooc-expression">
                    <xsl:with-param name="rowPos" select="$rowPos" />
                    <xsl:with-param name="columnPos" select="$columnPos" />
                    <xsl:with-param name="expression" select="$expression"/>
                </xsl:call-template>
            </xsl:when>
            <!-- functions to be mapped -->
            <xsl:otherwise>
                <xsl:variable name="functionPrefix" select="substring-before($expression, '(')" />
                <xsl:variable name="expressionSuffix" select="substring-after($expression, '(')" />

                <!-- translate in case the expression contains row/cell references aside of the function name -->
                <xsl:call-template name="translate-oooc-expression">
                    <xsl:with-param name="rowPos" select="$rowPos" />
                    <xsl:with-param name="columnPos" select="$columnPos" />
                    <xsl:with-param name="expression" select="$functionPrefix"/>
                </xsl:call-template>
                <!-- Prefix do not include the bracket -->
                <xsl:text>(</xsl:text>
                <xsl:choose>
                    <xsl:when test="not(contains($functionPrefix, 'ADDRESS') or
                                        contains($functionPrefix, 'CEILING') or
                                        contains($functionPrefix, 'FLOOR') or
                                        (contains($functionPrefix, 'IF') and not(
                                            contains($functionPrefix, 'COUNTIF') or
                                            contains($functionPrefix, 'SUMIF'))) or
                                        contains($functionPrefix, 'ROUND'))">
                        <xsl:call-template name="function-parameter-mapping">
                            <xsl:with-param name="rowPos" select="$rowPos" />
                            <xsl:with-param name="columnPos" select="$columnPos" />
                            <xsl:with-param name="expression" select="$expressionSuffix"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($functionPrefix, 'ADDRESS')">
                                <xsl:call-template name="find-parameters">
                                    <xsl:with-param name="rowPos" select="$rowPos" />
                                    <xsl:with-param name="columnPos" select="$columnPos" />
                                    <xsl:with-param name="expressionSuffix" select="$expressionSuffix"/>
                                    <xsl:with-param name="parameterRemoval" select="4" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="contains($functionPrefix, 'CEILING') or
                                            contains($functionPrefix, 'FLOOR')">
                                <xsl:call-template name="find-parameters">
                                    <xsl:with-param name="rowPos" select="$rowPos" />
                                    <xsl:with-param name="columnPos" select="$columnPos" />
                                    <xsl:with-param name="expressionSuffix" select="$expressionSuffix"/>
                                    <xsl:with-param name="parameterRemoval" select="3" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="contains($functionPrefix, 'IF')">
                                <xsl:if test="not(contains($functionPrefix, 'COUNTIF') or
                                                  contains($functionPrefix, 'SUMIF'))">
                                    <xsl:call-template name="find-parameters">
                                        <xsl:with-param name="rowPos" select="$rowPos" />
                                        <xsl:with-param name="columnPos" select="$columnPos" />
                                        <xsl:with-param name="expressionSuffix" select="$expressionSuffix"/>
                                        <xsl:with-param name="parameterAddition" select="'true'" />
                                        <xsl:with-param name="additonAfterLastParameter" select="2" />
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="contains($functionPrefix, 'ROUND')">
                                <xsl:call-template name="find-parameters">
                                    <xsl:with-param name="rowPos" select="$rowPos" />
                                    <xsl:with-param name="columnPos" select="$columnPos" />
                                    <xsl:with-param name="expressionSuffix" select="$expressionSuffix"/>
                                    <xsl:with-param name="parameterAddition" select="'null'" />
                                    <xsl:with-param name="additonAfterLastParameter" select="1" />
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Each parameter of the argumentlist have to be determined.
    Due to the low level string functionality in XSLT it becomes a clumsy task -->
    <xsl:template name="find-parameters">
        <!-- used for mapping of row/column reference  -->
        <xsl:param name="rowPos" /> <!-- the position in row (vertical of cell) -->
        <xsl:param name="columnPos" /> <!-- the position in column (horizontal of cell) -->
        <!-- used for mapping of parameter  -->
        <xsl:param name="parameterRemoval" />
        <xsl:param name="parameterAddition" />
        <xsl:param name="additonAfterLastParameter" />
        <!-- used as helper to find a parameter  -->
        <xsl:param name="expressionSuffix" />
        <xsl:param name="parameterNumber" select="1" />

        <xsl:variable name="parameter">
            <xsl:call-template name="getParameter">
                <xsl:with-param name="expressionSuffix" select="$expressionSuffix"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <!-- if it is not the last parameter -->
            <xsl:when test="starts-with(substring-after($expressionSuffix, $parameter), ',')">
                <!-- searches the argument for functions to be mapped -->
                <xsl:if test="not($parameterRemoval = $parameterNumber)">
                    <xsl:call-template name="function-parameter-mapping">
                        <xsl:with-param name="rowPos" select="$rowPos" />
                        <xsl:with-param name="columnPos" select="$columnPos" />
                        <xsl:with-param name="expression">
                            <xsl:choose>
                                <!-- in case a character will be removed the preceding won't make a comma -->
                                <xsl:when test="$parameterRemoval = ($parameterNumber + 1)">
                                    <xsl:value-of select="$parameter" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat($parameter, ',')" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <!-- searches for the next parameter -->
                <xsl:call-template name="find-parameters">
                    <xsl:with-param name="rowPos" select="$rowPos" />
                    <xsl:with-param name="columnPos" select="$columnPos" />
                    <xsl:with-param name="expressionSuffix" select="substring-after(substring-after($expressionSuffix, $parameter),',')"/>
                    <xsl:with-param name="parameterAddition" select="$parameterAddition" />
                    <xsl:with-param name="parameterRemoval" select="$parameterRemoval" />
                    <xsl:with-param name="additonAfterLastParameter" select="$additonAfterLastParameter" />
                    <xsl:with-param name="parameterNumber" select="$parameterNumber + 1" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- the last parameter -->
                <xsl:choose>
                    <xsl:when test="$parameterRemoval = $parameterNumber">
                        <!-- searches the rest of the expression for functions to be mapped -->
                        <xsl:call-template name="function-parameter-mapping">
                            <xsl:with-param name="rowPos" select="$rowPos" />
                            <xsl:with-param name="columnPos" select="$columnPos" />
                            <xsl:with-param name="expression" select="substring-after($expressionSuffix, $parameter)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$parameterAddition and ($parameterNumber  = $additonAfterLastParameter)">
                        <!-- searches the rest of the expression for functions to be mapped -->
                        <xsl:call-template name="function-parameter-mapping">
                            <xsl:with-param name="rowPos" select="$rowPos" />
                            <xsl:with-param name="columnPos" select="$columnPos" />
                            <xsl:with-param name="expression" select="$parameter" />
                        </xsl:call-template>
                        <!-- searches last parameter and additional parameters for functions to be mapped -->
                        <xsl:call-template name="function-parameter-mapping">
                            <xsl:with-param name="rowPos" select="$rowPos" />
                            <xsl:with-param name="columnPos" select="$columnPos" />
                            <!-- for the final parameter the latter substring is the ')' -->
                            <xsl:with-param name="expression" select="concat(',', $parameterAddition, substring-after($expressionSuffix, $parameter))"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- searches the argument for functions to be mapped -->
                        <xsl:call-template name="function-parameter-mapping">
                            <xsl:with-param name="rowPos" select="$rowPos" />
                            <xsl:with-param name="columnPos" select="$columnPos" />
                            <xsl:with-param name="expression" select="$parameter" />
                        </xsl:call-template>
                        <!-- searches the rest of the expression for functions to be mapped -->
                        <xsl:call-template name="function-parameter-mapping">
                            <xsl:with-param name="rowPos" select="$rowPos" />
                            <xsl:with-param name="columnPos" select="$columnPos" />
                            <xsl:with-param name="expression" select="substring-after($expressionSuffix, $parameter)"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getParameter">
        <xsl:param name="closingBracketCount" select="0" />
        <xsl:param name="openingBracketCount" select="0" />
        <xsl:param name="expressionSuffix" />
        <xsl:param name="parameterCandidate">
            <xsl:choose>
                <!-- if there are multiple parameter -->
                <xsl:when test="contains(substring-before($expressionSuffix, ')'), ',')">
                    <xsl:value-of select="substring-before($expressionSuffix, ',')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before($expressionSuffix, ')')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:param name="earlierCandidate" select="$parameterCandidate" />

        <xsl:choose>
            <xsl:when test="contains($parameterCandidate, '(') or contains($parameterCandidate, ')')">
                <xsl:choose>
                    <!-- contains only closing bracket(s) -->
                    <xsl:when test="contains($parameterCandidate, '(') and not(contains($parameterCandidate, ')'))">
                        <xsl:call-template name="getParameter">
                            <xsl:with-param name="openingBracketCount" select="$openingBracketCount + 1" />
                            <xsl:with-param name="closingBracketCount" select="$closingBracketCount" />
                            <xsl:with-param name="parameterCandidate" select="substring-after($parameterCandidate, '(')" />
                            <xsl:with-param name="earlierCandidate" select="$earlierCandidate" />
                            <xsl:with-param name="expressionSuffix" select="$expressionSuffix"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- contains only opening bracket(s) -->
                    <xsl:when test="not(contains($parameterCandidate, '(')) and contains($parameterCandidate, ')')">
                        <xsl:call-template name="getParameter">
                            <xsl:with-param name="openingBracketCount" select="$openingBracketCount" />
                            <xsl:with-param name="closingBracketCount" select="$closingBracketCount + 1" />
                            <xsl:with-param name="parameterCandidate" select="substring-after($parameterCandidate, ')')" />
                            <xsl:with-param name="earlierCandidate" select="$earlierCandidate" />
                            <xsl:with-param name="expressionSuffix" select="$expressionSuffix"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="string-length(substring-before($parameterCandidate, '(')) &lt;
                                            string-length(substring-before($parameterCandidate, ')'))">
                                <xsl:call-template name="getParameter">
                                    <xsl:with-param name="openingBracketCount" select="$openingBracketCount + 1" />
                                    <xsl:with-param name="closingBracketCount" select="$closingBracketCount" />
                                    <xsl:with-param name="parameterCandidate" select="substring-after($parameterCandidate, '(')" />
                                    <xsl:with-param name="earlierCandidate" select="$earlierCandidate" />
                                    <xsl:with-param name="expressionSuffix" select="$expressionSuffix"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="getParameter">
                                    <xsl:with-param name="openingBracketCount" select="$openingBracketCount" />
                                    <xsl:with-param name="closingBracketCount" select="$closingBracketCount + 1" />
                                    <xsl:with-param name="parameterCandidate" select="substring-after($parameterCandidate, ')')" />
                                    <xsl:with-param name="earlierCandidate" select="$earlierCandidate" />
                                    <xsl:with-param name="expressionSuffix" select="$expressionSuffix"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$openingBracketCount = $closingBracketCount">
                        <xsl:value-of select="$earlierCandidate" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$earlierCandidate" />
                        <xsl:variable name="parameterCandidate2">
                            <xsl:variable name="formularAfterCandidate" select="substring-after($expressionSuffix, $earlierCandidate)" />
                            <xsl:variable name="parameterTillBracket" select="concat(substring-before($formularAfterCandidate,')'),')')" />
                            <xsl:variable name="parameterTillComma" select="substring-before(substring-after($expressionSuffix, $parameterTillBracket),',')" />
                            <xsl:choose>
                                <xsl:when test="string-length($parameterTillComma) &gt; 0 and
                                                not(contains($parameterTillComma, '('))">
                                    <xsl:choose>
                                        <xsl:when test="starts-with($formularAfterCandidate, ',')">
                                            <xsl:value-of select="concat(',',substring-before(substring-after($formularAfterCandidate,','),','))"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-before($formularAfterCandidate,',')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$parameterTillBracket"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:call-template name="getParameter">
                            <xsl:with-param name="closingBracketCount" select="$closingBracketCount" />
                            <xsl:with-param name="openingBracketCount" select="$openingBracketCount" />
                            <xsl:with-param name="parameterCandidate" select="$parameterCandidate2" />
                            <xsl:with-param name="earlierCandidate" select="$parameterCandidate2" />
                            <xsl:with-param name="expressionSuffix" select="$expressionSuffix" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Mapping table-cell definitions by exchangomg all table cell definitions:
        a) a pair of cells e.g. "[.E14:.F21]" to "R[-17]C[3]:R[-10]C[4]"
        b) a single cell e.g. "[.F14]" to "R[-17]"-->
    <xsl:template name="translate-oooc-expression">
        <xsl:param name="rowPos" /> <!-- the position in row (vertical of cell) -->
        <xsl:param name="columnPos" /> <!-- the position in column (horizontal of cell) -->
        <xsl:param name="expression" /> <!-- expression to be exchanged -->

        <xsl:choose>
            <xsl:when test="contains($expression, '[')">

                <!-- Giving out the part before '[.' -->
                <xsl:value-of select="substring-before($expression, '[')" />

                <!-- Mapping cell definitions
                1) a pair of cells e.g. "[.E14:.F21]" to "R[-17]C[3]:R[-10]C[4]"
                2) a single cell e.g. "[.F14]" to "R[-17]"-->
                <xsl:variable name="remainingExpression" select="substring-after($expression, '[')"/>
                <xsl:choose>
                    <xsl:when test="contains(substring-before($remainingExpression, ']'), ':')">
                        <xsl:call-template name="translate-cell-expression">
                            <xsl:with-param name="rowPos" select="$rowPos" />
                            <xsl:with-param name="columnPos" select="$columnPos" />
                            <xsl:with-param name="expression" select="substring-before($remainingExpression, ':')" />
                        </xsl:call-template>
                        <xsl:value-of select="':'" />
                        <xsl:call-template name="translate-cell-expression">
                            <xsl:with-param name="rowPos" select="$rowPos" />
                            <xsl:with-param name="columnPos" select="$columnPos" />
                            <xsl:with-param name="expression" select="substring-after(substring-before($remainingExpression, ']'), ':')" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="translate-cell-expression">
                            <xsl:with-param name="rowPos" select="$rowPos" />
                            <xsl:with-param name="columnPos" select="$columnPos" />
                            <xsl:with-param name="expression" select="substring-before($remainingExpression, ']')" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="translate-oooc-expression">
                    <xsl:with-param name="rowPos" select="$rowPos" />
                    <xsl:with-param name="columnPos" select="$columnPos" />
                    <xsl:with-param name="expression" select="substring-after($remainingExpression,']')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- Giving out the remaining part -->
                <xsl:value-of select="$expression" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- A cell expression has usually starts with a '.' otherwise it references to a sheet  -->
    <xsl:template name="translate-cell-expression">
        <xsl:param name="rowPos" /> <!-- the vertical position of the current cell -->
        <xsl:param name="columnPos" /> <!-- the horizontal position of the current cell -->
        <xsl:param name="targetRowPos" select="0"/> <!-- the vertical position of the target cell -->
        <xsl:param name="targetColumnPos" select="0"/> <!-- the horizontal position of the target cell -->
        <xsl:param name="charPos" select="0"/> <!-- current column position (needed for multiplying) -->
        <xsl:param name="digitPos" select="0"/>  <!-- current row position (needed for multiplying) -->
        <xsl:param name="expression" /> <!-- expression to be parsed by character -->
        <xsl:param name="isRow" select="true()"/> <!-- the string (e.g. $D39 is parsed character per character from the back,
                                                       first the row, later the column is parsed -->

        <xsl:choose>
            <xsl:when test="starts-with($expression, '.')">
                <xsl:variable name="expLength" select="string-length($expression)" />
                <xsl:choose>
                    <!-- parsing from the end, till only the '.' remains -->
                    <xsl:when test="$expLength != 1">
                        <xsl:variable name="token" select="substring($expression, $expLength)" />
                        <xsl:choose>
                            <xsl:when test="$token='0' or $token='1' or $token='2' or $token='3' or $token='4' or $token='5' or $token='6' or $token='7' or $token='8' or $token='9'">
                                <xsl:variable name="multiplier">
                                    <xsl:call-template name="calculate-square-numbers">
                                        <xsl:with-param name="base" select="10" />
                                        <xsl:with-param name="exponent" select="$digitPos"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:call-template name="translate-cell-expression">
                                    <xsl:with-param name="columnPos" select="$columnPos" />
                                    <xsl:with-param name="rowPos" select="$rowPos" />
                                    <xsl:with-param name="targetColumnPos" select="$targetColumnPos" />
                                    <xsl:with-param name="targetRowPos" select="$targetRowPos + $multiplier * $token" />
                                    <xsl:with-param name="digitPos" select="$digitPos + 1" />
                                    <xsl:with-param name="charPos" select="$charPos" />
                                    <!-- removing the last character-->
                                    <xsl:with-param name="expression" select="substring($expression, 1, $expLength - 1)" />
                                    <xsl:with-param name="isRow" select="true()" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$token = '$'">
                                <xsl:choose>
                                    <!-- if this is the first '$' after '.' (column-->
                                    <xsl:when test="$expLength = 2">
                                        <xsl:text>C</xsl:text><xsl:value-of select="$targetColumnPos"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>R</xsl:text><xsl:value-of select="$targetRowPos"/>
                                        <xsl:call-template name="translate-cell-expression">
                                            <xsl:with-param name="columnPos" select="$columnPos" />
                                            <xsl:with-param name="rowPos" select="$rowPos" />
                                            <xsl:with-param name="targetColumnPos" select="$targetColumnPos" />
                                            <xsl:with-param name="targetRowPos" select="$targetRowPos" />
                                            <xsl:with-param name="charPos" select="$charPos" />
                                            <!-- removing the last character-->
                                            <xsl:with-param name="expression" select="substring($expression, 1, $expLength - 1)" />
                                            <xsl:with-param name="isRow" select="false()" />
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <!-- in case of a letter -->
                            <xsl:otherwise>
                                <xsl:if test="$isRow">
                                    <xsl:text>R</xsl:text>
                                    <xsl:if test="$targetRowPos != $rowPos">
                                        <xsl:text>[</xsl:text><xsl:value-of select="$targetRowPos - $rowPos"/><xsl:text>]</xsl:text>
                                    </xsl:if>
                                </xsl:if>
                                <xsl:variable name="multiplier">
                                    <xsl:call-template name="calculate-square-numbers">
                                        <xsl:with-param name="base" select="26" />
                                        <xsl:with-param name="exponent" select="$charPos"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="tokenNumber">
                                    <xsl:call-template name="character-to-number">
                                        <xsl:with-param name="character" select="$token" />
                                    </xsl:call-template>
                                </xsl:variable>

                                <xsl:call-template name="translate-cell-expression">
                                    <xsl:with-param name="columnPos" select="$columnPos" />
                                    <xsl:with-param name="rowPos" select="$rowPos" />
                                    <xsl:with-param name="targetColumnPos" select="$targetColumnPos + $multiplier * $tokenNumber" />
                                    <xsl:with-param name="targetRowPos" select="$targetRowPos" />
                                    <xsl:with-param name="digitPos" select="$digitPos" />
                                    <xsl:with-param name="charPos" select="$charPos + 1" />
                                    <!-- removing the last character-->
                                    <xsl:with-param name="expression" select="substring($expression, 1, $expLength - 1)" />
                                    <xsl:with-param name="isRow" select="false()" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>C</xsl:text>
                        <xsl:if test="$targetColumnPos != $columnPos">
                            <xsl:text>[</xsl:text><xsl:value-of select="$targetColumnPos - $columnPos"/><xsl:text>]</xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="sheetName" select="substring-before($expression, '.')" />
                <xsl:value-of select="$sheetName"/><xsl:text>!</xsl:text>
                <xsl:call-template name="translate-cell-expression">
                    <xsl:with-param name="rowPos" select="$rowPos" />
                    <xsl:with-param name="columnPos" select="$columnPos" />
                    <xsl:with-param name="expression" select="substring-after($expression, $sheetName)" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="calculate-square-numbers">
        <xsl:param name="base" />
        <xsl:param name="exponent" />
        <xsl:param name="return" select="1" />

        <xsl:choose>
            <xsl:when test="$exponent > '1'">
                <xsl:call-template name="calculate-square-numbers">
                    <xsl:with-param name="base" select="$base" />
                    <xsl:with-param name="exponent" select="$exponent - 1"/>
                    <xsl:with-param name="return" select="$return * $base" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$exponent = '1'">
                <xsl:value-of select="$return * $base"/>
            </xsl:when>
            <!-- if exponent is equal '0' -->
            <xsl:otherwise>
                <xsl:value-of select="1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="character-to-number">
        <xsl:param name="character" />
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

</xsl:stylesheet>
