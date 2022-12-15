<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:s="uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882"
                              xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
                              xmlns:rs="urn:schemas-microsoft-com:rowset"
                              xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
                              xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
                              xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
                              xmlns:calcext="urn:org:documentfoundation:names:experimental:calc:xmlns:calcext:1.0"
                              xmlns:z="#RowsetSchema">
  <xsl:output indent="no" version="1.0" encoding="UTF-8" method="xml"/>
  <xsl:template match="/">
    <office:document office:mimetype="application/vnd.oasis.opendocument.spreadsheet" office:version="1.0">
      <xsl:element name="office:body">
        <xsl:element name="office:spreadsheet">
          <!-- Just a single table (sheet) with default name -->
          <xsl:element name="table:table">
            <!-- declare columns -->
            <xsl:for-each select="./xml/s:Schema/s:ElementType[@name='row']/s:AttributeType">
              <xsl:element name="table:table-column"/>
            </xsl:for-each>
            <!-- header row from Schema -->
            <xsl:element name="table:table-row">
              <xsl:for-each select="./xml/s:Schema/s:ElementType[@name='row']/s:AttributeType">
                <xsl:element name="table:table-cell">
                  <xsl:attribute name="office:value-type">string</xsl:attribute>
                  <xsl:attribute name="calcext:value-type">string</xsl:attribute>
                  <xsl:element name="text:p">
                    <!-- User-readable field name may be defined in optional @rs:name -->
                    <xsl:choose>
                      <xsl:when test="./@rs:name">
                        <xsl:value-of select="./@rs:name"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="./@name"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
            <!-- Now add data itself -->
            <xsl:apply-templates select="./xml/rs:data"/>
          </xsl:element>
          <!-- Add autofilter to the whole range -->
          <xsl:element name="table:database-ranges">
            <xsl:element name="table:database-range">
              <xsl:attribute name="table:target-range-address">
                <xsl:call-template name="RangeName">
                  <xsl:with-param name="rowStartNum" select="1"/>
                  <xsl:with-param name="colStartNum" select="1"/>
                  <xsl:with-param name="rowEndNum" select="count(/xml/rs:data/row)+1"/>
                  <xsl:with-param name="colEndNum" select="count(/xml/s:Schema/s:ElementType[@name='row']/s:AttributeType)"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="table:display-filter-buttons">true</xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </office:document>
  </xsl:template>
  <xsl:template match="rs:data">
    <xsl:apply-templates select="./row"/>
    <xsl:apply-templates select="./z:row"/>
  </xsl:template>
  <xsl:template match="row|z:row">
    <xsl:element name="table:table-row">
      <!-- Store current row in a variable -->
      <xsl:variable name="thisRow" select="."/>
      <!-- Get column order from Schema -->
      <xsl:for-each select="/xml/s:Schema/s:ElementType[@name='row']/s:AttributeType">
        <xsl:element name="table:table-cell">
          <xsl:variable name="thisColName" select="./@name"/>
          <xsl:variable name="thisCellValue">
            <xsl:value-of select="$thisRow/@*[local-name()=$thisColName]"/>
          </xsl:variable>
          <xsl:if test="string-length($thisCellValue) &gt; 0">
            <xsl:variable name="thisColType">
              <xsl:call-template name="ValTypeFromAttributeType">
                <xsl:with-param name="AttributeTypeNode" select="."/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="office:value-type"><xsl:value-of select="$thisColType"/></xsl:attribute>
            <xsl:attribute name="calcext:value-type"><xsl:value-of select="$thisColType"/></xsl:attribute>
            <xsl:choose>
              <xsl:when test="$thisColType='float'">
                <xsl:attribute name="office:value"><xsl:value-of select="$thisCellValue"/></xsl:attribute>
              </xsl:when>
              <xsl:when test="$thisColType='date'">
                <!-- We need to convert '2017-04-06 00:40:40' to '2017-04-06T00:40:40', so replace space with 'T' -->
                <xsl:attribute name="office:date-value"><xsl:value-of select="translate($thisCellValue,' ','T')"/></xsl:attribute>
              </xsl:when>
              <xsl:when test="$thisColType='time'">
                <xsl:attribute name="office:time-value"><xsl:value-of select="$thisCellValue"/></xsl:attribute>
              </xsl:when>
              <xsl:when test="$thisColType='boolean'">
                <xsl:attribute name="office:boolean-value">
                  <xsl:choose>
                    <xsl:when test="$thisCellValue=0">false</xsl:when>
                    <xsl:otherwise>true</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </xsl:when>
            </xsl:choose>
            <xsl:element name="text:p">
              <xsl:value-of select="$thisCellValue"/>
            </xsl:element>
          </xsl:if>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  <!-- https://msdn.microsoft.com/en-us/library/ms675943 -->
  <xsl:template name="ValTypeFromAttributeType">
    <xsl:param name="AttributeTypeNode"/>
    <xsl:variable name="thisDataType">
      <xsl:choose>
        <xsl:when test="$AttributeTypeNode/@dt:type"><xsl:value-of select="$AttributeTypeNode/@dt:type"/></xsl:when>
        <xsl:when test="$AttributeTypeNode/s:datatype"><xsl:value-of select="$AttributeTypeNode/s:datatype/@dt:type"/></xsl:when>
        <xsl:otherwise>string</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="XMLDataType2ValType">
      <xsl:with-param name="XMLDataType" select="$thisDataType"/>
    </xsl:call-template>
  </xsl:template>
  <!-- https://www.w3.org/TR/1998/NOTE-XML-data-0105/#API -->
  <xsl:template name="XMLDataType2ValType">
    <xsl:param name="XMLDataType"/>
    <xsl:choose>
      <xsl:when test="$XMLDataType='number'">float</xsl:when>
      <xsl:when test="$XMLDataType='int'">float</xsl:when>
      <xsl:when test="starts-with($XMLDataType, 'float')">float</xsl:when>
      <xsl:when test="starts-with($XMLDataType, 'fixed')">float</xsl:when>
      <xsl:when test="$XMLDataType='i1'">float</xsl:when>
      <xsl:when test="$XMLDataType='i2'">float</xsl:when>
      <xsl:when test="$XMLDataType='i4'">float</xsl:when>
      <xsl:when test="$XMLDataType='i8'">float</xsl:when>
      <xsl:when test="$XMLDataType='ui1'">float</xsl:when>
      <xsl:when test="$XMLDataType='ui2'">float</xsl:when>
      <xsl:when test="$XMLDataType='ui4'">float</xsl:when>
      <xsl:when test="$XMLDataType='ui8'">float</xsl:when>
      <xsl:when test="$XMLDataType='r4'">float</xsl:when>
      <xsl:when test="$XMLDataType='r8'">float</xsl:when>
      <xsl:when test="$XMLDataType='datetime'">date</xsl:when>
      <xsl:when test="starts-with($XMLDataType, 'dateTime')">date</xsl:when>
      <xsl:when test="starts-with($XMLDataType, 'date')">date</xsl:when>
      <xsl:when test="starts-with($XMLDataType, 'time')">time</xsl:when>
      <xsl:when test="$XMLDataType='boolean'">boolean</xsl:when>
      <xsl:otherwise>string</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- A utility to convert a column number (e.g. 27; 1-based) to column name (like AA) -->
  <xsl:template name="ColNum2Name">
    <xsl:param name="num"/>
    <xsl:if test="$num > 0">
      <xsl:call-template name="ColNum2Name">
        <xsl:with-param name="num" select="floor($num div 26)"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="$num mod 26 = 1">A</xsl:when>
        <xsl:when test="$num mod 26 = 2">B</xsl:when>
        <xsl:when test="$num mod 26 = 3">C</xsl:when>
        <xsl:when test="$num mod 26 = 4">D</xsl:when>
        <xsl:when test="$num mod 26 = 5">E</xsl:when>
        <xsl:when test="$num mod 26 = 6">F</xsl:when>
        <xsl:when test="$num mod 26 = 7">G</xsl:when>
        <xsl:when test="$num mod 26 = 8">H</xsl:when>
        <xsl:when test="$num mod 26 = 9">I</xsl:when>
        <xsl:when test="$num mod 26 = 10">J</xsl:when>
        <xsl:when test="$num mod 26 = 11">K</xsl:when>
        <xsl:when test="$num mod 26 = 12">L</xsl:when>
        <xsl:when test="$num mod 26 = 13">M</xsl:when>
        <xsl:when test="$num mod 26 = 14">N</xsl:when>
        <xsl:when test="$num mod 26 = 15">O</xsl:when>
        <xsl:when test="$num mod 26 = 16">P</xsl:when>
        <xsl:when test="$num mod 26 = 17">Q</xsl:when>
        <xsl:when test="$num mod 26 = 18">R</xsl:when>
        <xsl:when test="$num mod 26 = 19">S</xsl:when>
        <xsl:when test="$num mod 26 = 20">T</xsl:when>
        <xsl:when test="$num mod 26 = 21">U</xsl:when>
        <xsl:when test="$num mod 26 = 22">V</xsl:when>
        <xsl:when test="$num mod 26 = 23">W</xsl:when>
        <xsl:when test="$num mod 26 = 24">X</xsl:when>
        <xsl:when test="$num mod 26 = 25">Y</xsl:when>
        <xsl:otherwise>Z</xsl:otherwise><!-- 0 -->
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <!-- A utility to convert a cell address (e.g. row 2, column 27) to cell name (like AA2) -->
  <xsl:template name="CellName">
    <xsl:param name="rowNum"/>
    <xsl:param name="colNum"/>
    <xsl:call-template name="ColNum2Name">
      <xsl:with-param name="num" select="$colNum"/>
    </xsl:call-template>
    <xsl:value-of select="$rowNum"/>
  </xsl:template>
  <!-- A utility to convert a range given in terms of numbers (e.g. row 1, column 1 to row 2, column 27) to range name (like A1:AA2) -->
  <xsl:template name="RangeName">
    <xsl:param name="rowStartNum"/>
    <xsl:param name="colStartNum"/>
    <xsl:param name="rowEndNum"/>
    <xsl:param name="colEndNum"/>
    <xsl:call-template name="CellName">
      <xsl:with-param name="rowNum" select="$rowStartNum"/>
      <xsl:with-param name="colNum" select="$colStartNum"/>
    </xsl:call-template>
    <xsl:text>:</xsl:text>
    <xsl:call-template name="CellName">
      <xsl:with-param name="rowNum" select="$rowEndNum"/>
      <xsl:with-param name="colNum" select="$colEndNum"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
