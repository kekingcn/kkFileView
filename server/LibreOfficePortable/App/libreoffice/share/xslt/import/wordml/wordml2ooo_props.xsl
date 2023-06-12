<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" exclude-result-prefixes="w wx aml o dt  v" xmlns:an="urn:flr:annotate">

<an:page-layout-properties
     context-node-input="w:sectPr"
     context-node-output="style:page-layout-properties">
<an:so-supported select="w:pgMar/@w:gutter"/>
<an:so-supported select="w:pgSz/@w:code"/>
</an:page-layout-properties>

<xsl:template name="page-layout-properties">

<!-- NOTE: "div 567.0" converts from twips to cm -->
<xsl:attribute name="fo:margin-top">
  <xsl:variable name="header-margin">
      <xsl:choose>
          <xsl:when test="w:pgMar/@w:header">
              <xsl:value-of select="w:pgMar/@w:header"/>
          </xsl:when>
          <xsl:otherwise>720</xsl:otherwise>
      </xsl:choose>
  </xsl:variable>
  <xsl:variable name="margin-top">
      <xsl:choose>
          <xsl:when test="w:hdr">
              <xsl:choose>
                 <xsl:when test="w:pgMar/@w:top &gt;= $header-margin">
                     <xsl:value-of select="$header-margin"/>
                 </xsl:when>
                 <xsl:otherwise>
                     <xsl:value-of select="w:pgMar/@w:top"/>
                 </xsl:otherwise>
              </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
              <xsl:value-of select="w:pgMar/@w:top"/>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="concat($margin-top div 567.0, 'cm')"/>
</xsl:attribute>
<xsl:attribute name="fo:margin-bottom">
  <xsl:variable name="footer-margin">
      <xsl:choose>
          <xsl:when test="w:pgMar/@w:footer">
              <xsl:value-of select="w:pgMar/@w:footer"/>
          </xsl:when>
          <xsl:otherwise>720</xsl:otherwise>
      </xsl:choose>
  </xsl:variable>
  <xsl:variable name="margin-bottom">
      <xsl:choose>
          <xsl:when test="w:ftr">
              <xsl:value-of select="$footer-margin"/>
          </xsl:when>
          <xsl:otherwise>
              <xsl:value-of select="w:pgMar/@w:bottom"/>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="concat($margin-bottom div 567.0, 'cm')"/>
</xsl:attribute>
<xsl:attribute name="fo:margin-left">
  <xsl:value-of select="concat(w:pgMar/@w:left div 567.0, 'cm')"/>
</xsl:attribute>
<xsl:attribute name="fo:margin-right">
  <xsl:value-of select="concat(w:pgMar/@w:right div 567.0, 'cm')"/>
</xsl:attribute>

<xsl:attribute name="fo:page-width">
  <xsl:value-of select="concat(w:pgSz/@w:w div 567.0, 'cm')"/>
</xsl:attribute>
<xsl:attribute name="fo:page-height">
  <xsl:value-of select="concat(w:pgSz/@w:h div 567.0, 'cm')"/>
</xsl:attribute>
<xsl:attribute name="style:footnote-max-height">
  <xsl:value-of select="'0cm'"/>
</xsl:attribute>
<xsl:attribute name="style:print-orientation">
  <xsl:choose>
      <xsl:when test="w:pgSz/@w:orient">
          <xsl:value-of select="w:pgSz/@w:orient"/>
      </xsl:when>
      <xsl:otherwise>portrait</xsl:otherwise>
  </xsl:choose>
</xsl:attribute>
<xsl:apply-templates select="//w:bgPict"/>
<xsl:call-template name="column-properties"/>
</xsl:template>


<an:column-properties
     context-node-input="w:sectPr"
     context-node-output="style:page-layout-properties">
<an:so-supported select="w:cols/@w:sep"/>
</an:column-properties>
<xsl:template name="column-properties">
<style:columns>
<xsl:attribute name="fo:column-count">
  <xsl:choose>
      <xsl:when test="w:cols/@w:num">
          <xsl:value-of select="w:cols/@w:num"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:attribute>

<xsl:if test="not(w:cols/w:col)">
<!-- bug in the OASIS spec resp. bug in xmloff  -->
<xsl:attribute name="fo:column-gap">
  <xsl:value-of select="concat(w:cols/@w:space div 567.0, 'cm')"/>
</xsl:attribute>
</xsl:if>

<xsl:for-each select="w:cols/w:col">
  <style:column>
     <xsl:attribute name="style:rel-width">
       <xsl:value-of select="concat(@w:w, '*')"/>
     </xsl:attribute>
     <xsl:attribute name="fo:start-indent">
       <xsl:value-of select="'0cm'"/>
     </xsl:attribute>
     <xsl:attribute name="fo:end-indent">
       <xsl:choose>
          <xsl:when test="@w:space">
              <xsl:value-of select="concat(@w:space div 567.0, 'cm')"/>
          </xsl:when>
          <xsl:otherwise>0cm</xsl:otherwise>
       </xsl:choose>
     </xsl:attribute>
  </style:column>
</xsl:for-each>
</style:columns>
</xsl:template>

<an:text-properties
     context-node-input="w:rPr"
     context-node-output="style:text-properties">
</an:text-properties >
<xsl:template name="text-properties">
<xsl:variable name="b-value">
  <xsl:choose>
      <xsl:when test="w:b/@val">
          <xsl:value-of select="w:b/@val"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="local-name(w:b)"/>
      </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<!-- could be simplified: is "b" actually a valid value of w:b/@val ? -->
<xsl:variable name="font-weight">
  <xsl:choose>
      <xsl:when test="$b-value = 'on'">bold</xsl:when>
      <xsl:when test="$b-value = 'off'">normal</xsl:when>
      <xsl:when test="$b-value = 'b'">bold</xsl:when>
      <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<xsl:attribute name="fo:font-weight">
  <xsl:value-of select="$font-weight"/>
</xsl:attribute>
<xsl:attribute name="style:font-weight-asian">
  <xsl:value-of select="$font-weight"/>
</xsl:attribute>
<xsl:attribute name="style:font-weight-complex">
  <xsl:variable name="b-cs-value">
    <xsl:choose>
      <xsl:when test="w:b-cs/@val">
          <xsl:value-of select="w:b-cs/@val"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="local-name(w:b-cs)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- could be simplified: is "b-cs" actually a valid value of w:b-cs/@val -->
  <xsl:choose>
      <xsl:when test="$b-cs-value = 'on'">bold</xsl:when>
      <xsl:when test="$b-cs-value = 'off'">normal</xsl:when>
      <xsl:when test="$b-cs-value = 'b-cs'">bold</xsl:when>
      <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:attribute>
<xsl:variable name="i-value">
  <xsl:choose>
      <xsl:when test="w:i/@val">
          <xsl:value-of select="w:i/@val"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="local-name(w:i)"/>
      </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<!-- could be simplified: is "i" actually a valid value of w:i/@val ? -->
<xsl:variable name="font-style">
  <xsl:choose>
      <xsl:when test="$i-value = 'on'">italic</xsl:when>
      <xsl:when test="$i-value = 'off'">normal</xsl:when>
      <xsl:when test="$i-value = 'i'">italic</xsl:when>
      <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<xsl:attribute name="fo:font-style">
  <xsl:value-of select="$font-style"/>
</xsl:attribute>
<xsl:attribute name="style:font-style-asian">
  <xsl:value-of select="$font-style"/>
</xsl:attribute>
<xsl:attribute name="style:font-style-complex">
  <xsl:variable name="i-cs-value">
      <xsl:choose>
          <xsl:when test="w:i-cs/@val">
              <xsl:value-of select="w:i-cs/@val"/>
          </xsl:when>
          <xsl:otherwise>
              <xsl:value-of select="local-name(w:i-cs)"/>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:variable>
  <!-- could be simplified: is "i-cs" actually a valid value of w:i-cs/@val -->
  <xsl:choose>
      <xsl:when test="$i-cs-value = 'on'">italic</xsl:when>
      <xsl:when test="$i-cs-value = 'off'">normal</xsl:when>
      <xsl:when test="$i-cs-value = 'i-cs'">italic</xsl:when>
      <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:attribute>
<xsl:attribute name="fo:text-transform">
  <xsl:variable name="caps-value">
      <xsl:choose>
          <xsl:when test="w:caps/@val">
              <xsl:value-of select="w:caps/@val"/>
          </xsl:when>
          <xsl:otherwise>
              <xsl:value-of select="local-name(w:caps)"/>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:variable>
  <!-- could be simplified: is "caps" actually a valid value of w:caps/@val -->
  <xsl:choose>
      <xsl:when test="$caps-value = 'on'">uppercase</xsl:when>
      <xsl:when test="$caps-value = 'off'">normal</xsl:when>
      <xsl:when test="$caps-value = 'caps'">uppercase</xsl:when>
      <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:attribute>
<xsl:attribute name="fo:font-variant">
  <xsl:variable name="small-caps-value">
      <xsl:choose>
          <xsl:when test="w:smallCaps/@val">
              <xsl:value-of select="w:smallCaps/@val"/>
          </xsl:when>
          <xsl:otherwise>
              <xsl:value-of select="local-name(w:smallCaps)"/>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:variable>
  <!-- could be simplified: is "smallCaps" actually a valid value of w:smallCaps/@val -->
  <xsl:choose>
      <xsl:when test="$small-caps-value = 'on'">small-caps</xsl:when>
      <xsl:when test="$small-caps-value = 'off'">normal</xsl:when>
      <xsl:when test="$small-caps-value = 'smallCaps'">small-caps</xsl:when>
      <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:attribute>
</xsl:template>

</xsl:stylesheet>
