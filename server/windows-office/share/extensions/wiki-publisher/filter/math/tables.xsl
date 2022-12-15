<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:m="http://www.w3.org/1998/Math/MathML"
                version='1.0'>
                
<!-- ====================================================================== -->
<!-- $Id: tables.xsl 2755 2008-03-07 20:35:56Z hauma $
     This file is part of the XSLT MathML Library distribution.
     See ./README or http://xsltml.sf.net for
     copyright and other information                                        -->
<!-- ====================================================================== -->

<xsl:template match="m:mtd[@columnspan]">
	<xsl:text>\multicolumn{</xsl:text>
	<xsl:value-of select="@columnspan"/>
	<xsl:text>}{c}{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
	<xsl:if test="count(following-sibling::*)>0">
		<xsl:text>&amp; </xsl:text>
	</xsl:if>
</xsl:template>


<xsl:template match="m:mtd">
	<xsl:if test="@columnalign='right' or @columnalign='center'">
		<xsl:text>\hfill </xsl:text>
	</xsl:if>
	<xsl:apply-templates/>
	<xsl:if test="@columnalign='left' or @columnalign='center'">
		<xsl:text>\hfill </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="m:mtr">
	<xsl:for-each select="*">
		<xsl:apply-templates select="current()"/>
		<xsl:if test="not(position()=last())">
			<xsl:text>&amp; 	</xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:if test="not(position()=last())">
		<xsl:text>\\ &#13;&#10;</xsl:text>
		<xsl:if test="../@rowlines">
			<xsl:variable name="line">
				<xsl:call-template name="getToken">
					<xsl:with-param name="text" select="../@rowlines"/>
					<xsl:with-param name="position" select="position()"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$line='solid'">
				<xsl:text>\hline </xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="m:mtable">
	<xsl:text>\begin{array}{</xsl:text>
	<xsl:if test="@frame='solid'">
		<xsl:text>|</xsl:text>
	</xsl:if>
	<xsl:variable name="numbercols" select="count(./m:mtr[1]/*[not(@columnspan)])+sum(./m:mtr[1]/m:mtd/@columnspan)"/>
	<xsl:choose>
		<xsl:when test="@columnalign and @columnlines">
			<xsl:call-template name="generateAlignString">
				<xsl:with-param name="columnalignstring" select="@columnalign"/>
				<xsl:with-param name="columnlinestring" select="@columnlines"/>
				<xsl:with-param name="count" select="$numbercols"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="@columnlines">
			<xsl:call-template name="generateAlignString">
				<xsl:with-param name="columnlinestring" select="@columnlines"/>
				<xsl:with-param name="count" select="$numbercols"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="@columnalign">
			<xsl:call-template name="generateAlignString">
				<xsl:with-param name="columnalignstring" select="@columnalign"/>
				<xsl:with-param name="count" select="$numbercols"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="generateAlignString">
				<xsl:with-param name="count" select="$numbercols"/>
				</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="@frame='solid'">
		<xsl:text>|</xsl:text>
	</xsl:if>
	<xsl:text>}</xsl:text>
	<xsl:if test="@frame='solid'">
		<xsl:text>\hline </xsl:text>
	</xsl:if>
	<xsl:apply-templates/>
	<xsl:if test="@frame='solid'">
		<xsl:text>\\ \hline&#13;&#10;</xsl:text>
	</xsl:if>
	<xsl:text>\end{array}</xsl:text>
</xsl:template>

<xsl:template name="colalign">
	<xsl:param name="colalign"/>
	<xsl:choose>
		<xsl:when test="contains($colalign,' ')">
			<xsl:value-of select="substring($colalign,1,1)"/>
			<xsl:call-template name="colalign">
				<xsl:with-param name="colalign" select="substring-after($colalign,' ')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="substring($colalign,1,1)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="generate-string">
<!-- template from XSLT Standard Library v1.1 -->
    <xsl:param name="text"/>
    <xsl:param name="count"/>

    <xsl:choose>
      <xsl:when test="string-length($text) = 0 or $count &lt;= 0"/>

      <xsl:otherwise>
	<xsl:value-of select="$text"/>
	<xsl:call-template name="generate-string">
	  <xsl:with-param name="text" select="$text"/>
	  <xsl:with-param name="count" select="$count - 1"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="generateAlignString">
	<xsl:param name="columnalignstring">center</xsl:param>
	<xsl:param name="columnlinestring"/>
	<xsl:param name="count"/>
	<xsl:choose>
		<xsl:when test="$count &lt;= 0"/>
		<xsl:otherwise>
			<xsl:variable name="columnalign">
				<xsl:call-template name="getToken">
					<xsl:with-param name="text" select="$columnalignstring"/>
					<xsl:with-param name="position" select="1"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="columnline">
				<xsl:call-template name="getToken">
					<xsl:with-param name="text" select="$columnlinestring"/>
					<xsl:with-param name="position" select="1"/>
				</xsl:call-template>
			</xsl:variable>
      	<xsl:value-of select="substring($columnalign,1,1)"/>
      	<xsl:if test="$columnline='solid' and $count>1"><xsl:text>|</xsl:text></xsl:if>
      	<xsl:variable name="leftPartOrLastTokenA">
      		<xsl:choose>
      			<xsl:when test="substring-after($columnalignstring,' ')">
						<xsl:value-of select="substring-after($columnalignstring,' ')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$columnalignstring"/>
					</xsl:otherwise>
				</xsl:choose>
      	</xsl:variable>
      	<xsl:variable name="leftPartOrLastTokenB">
      		<xsl:choose>
      			<xsl:when test="substring-after($columnlinestring,' ')">
						<xsl:value-of select="substring-after($columnlinestring,' ')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$columnlinestring"/>
					</xsl:otherwise>
				</xsl:choose>
      	</xsl:variable>
			<xsl:call-template name="generateAlignString">
	  			<xsl:with-param name="columnalignstring" select="$leftPartOrLastTokenA"/>
	  			<xsl:with-param name="columnlinestring" select="$leftPartOrLastTokenB"/>
	  			<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:template name="getToken">
    <xsl:param name="text"/>
    <xsl:param name="char" select="string(' ')"/>
    <xsl:param name="position"/>
    <xsl:choose>
      <xsl:when test="$position = 1 or not(contains($text ,$char))">
        <xsl:choose>
          <xsl:when test="contains($text ,$char)">
            <xsl:value-of select="substring-before($text,$char)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$text"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="contains($text ,$char) and $position &gt; 1">
        <xsl:variable name="last" select="substring-after($text,$char)"/>
        <xsl:choose>
          <xsl:when test="$position &gt; 1">
            <xsl:call-template name="getToken">
              <xsl:with-param name="text" select="$last"/>
              <xsl:with-param name="char" select="$char"/>
              <xsl:with-param name="position" select="$position - 1"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
