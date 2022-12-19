<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:m="http://www.w3.org/1998/Math/MathML"
		xmlns:oomath="http://www.w3.org/1998/Math/MathML"
                version='1.0'>

<!-- ====================================================================== -->
<!-- $Id: glayout.xsl 2755 2008-03-07 20:35:56Z hauma $
     This file is part of the XSLT MathML Library distribution.
     See ./README or http://xsltml.sf.net for
     copyright and other information                                        -->
<!-- ====================================================================== -->

<!-- 3.3.2 mfrac -->
<xsl:template match="m:mfrac">
	<xsl:choose>
		<xsl:when test="@linethickness">
			<xsl:text>\genfrac{}{}{</xsl:text>
			<xsl:choose>
				<xsl:when test="number(@linethickness)">
					<xsl:value-of select="@linethickness div 10"/>
					<xsl:text>ex</xsl:text>
				</xsl:when>
				<xsl:when test="@linethickness='0'">
					<xsl:text>0ex</xsl:text>
				</xsl:when>
				<xsl:when test="@linethickness='thin'">
					<xsl:text>.05ex</xsl:text>
				</xsl:when>
				<xsl:when test="@linethickness='medium'"/>
				<xsl:when test="@linethickness='thick'">
					<xsl:text>.2ex</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@linethickness"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>}{}{</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>\frac{</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="@numalign='right'">
		<xsl:text>\hfill </xsl:text>
	</xsl:if>
	<xsl:apply-templates select="./*[1]"/>
	<xsl:if test="@numalign='left'">
		<xsl:text>\hfill </xsl:text>
	</xsl:if>
	<xsl:text>}{</xsl:text>	
	<xsl:if test="@denomalign='right'">
		<xsl:text>\hfill </xsl:text>
	</xsl:if>
	<xsl:apply-templates select="./*[2]"/>
		<xsl:if test="@denomalign='left'">
		<xsl:text>\hfill </xsl:text>
	</xsl:if>
	<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="m:mfrac[@bevelled='true']">
	<xsl:text>\raisebox{1ex}{$</xsl:text>
	<xsl:apply-templates select="./*[1]"/>
	<xsl:text>$}\!\left/ \!\raisebox{-1ex}{$</xsl:text>
	<xsl:apply-templates select="./*[2]"/>
	<xsl:text>$}\right.</xsl:text>
</xsl:template>


<xsl:template match="m:mroot">
	<xsl:choose>
		<xsl:when test="count(./*)=2">
			<xsl:text>\sqrt[</xsl:text>
			<xsl:apply-templates select="./*[2]"/>
			<xsl:text>]{</xsl:text>	
			<xsl:apply-templates select="./*[1]"/>
			<xsl:text>}</xsl:text>	
		</xsl:when>
		<xsl:otherwise>
		<!-- number of argumnets is not 2 - code 25 -->
			<xsl:message>exception 25:</xsl:message>
			<xsl:text>\text{exception 25:}</xsl:text> 
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="m:msqrt">
	<xsl:text>\sqrt{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="m:mfenced">
	<xsl:choose>
		<xsl:when test="@oomath:open">
			<xsl:if test="translate(@oomath:open,'{}[]()&#xe09e;&#xe09f;|&#x02223;','{{{{{{{{{{')='{'">
				<xsl:text>\left</xsl:text>
			</xsl:if>
			<xsl:if test="translate(@oomath:open,'{}[]()&#xe09e;&#xe09f;|&#x02223;','{{{{{{{{{{')!='{' and (translate(@oomath:close,'{}[]()&#xe09e;&#xe09f;|&#x02223;','{{{{{{{{{{')='{' or not(@oomath:close))">
				<xsl:text>\left.</xsl:text>
			</xsl:if>
			<xsl:call-template name="replaceEntities">
				<xsl:with-param name="content" select="@oomath:open"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise><xsl:text>\left(</xsl:text></xsl:otherwise>
	</xsl:choose>
			<xsl:variable name="sep">
				<xsl:choose>
					<xsl:when test="@separators">
						<xsl:value-of select="translate(@separators,' ','')"/>
					</xsl:when>
					<xsl:otherwise>,</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:for-each select="./*">
				<xsl:apply-templates select="."/>
				<xsl:if test="not(position()=last())">
					<xsl:choose>
						<xsl:when test="position()>string-length($sep)">
							<xsl:value-of select="substring($sep,string-length($sep))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring($sep,position(),1)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
	<xsl:choose>
		<xsl:when test="@oomath:close">
			<xsl:if test="translate(@oomath:close,'{}[]()&#xe09e;&#xe09f;|&#x02223;','{{{{{{{{{{')='{'">
				<xsl:text>\right</xsl:text>
			</xsl:if>
			<xsl:if test="translate(@oomath:close,'{}[]()&#xe09e;&#xe09f;|&#x02223;','{{{{{{{{{{')!='{' and (translate(@oomath:open,'{}[]()&#xe09e;&#xe09f;|&#x02223;','{{{{{{{{{{')='{' or not(@oomath:open))">
				<xsl:text>\right.</xsl:text>
			</xsl:if>
			<xsl:call-template name="replaceEntities">
				<xsl:with-param name="content" select="@oomath:close"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise><xsl:text>\right)</xsl:text></xsl:otherwise>
	</xsl:choose>	
</xsl:template>

<xsl:template match="m:mphantom">
<!-- Not supported by MediaWiki. -->
<!-- 
 	<xsl:text>\phantom{</xsl:text>
 -->
	<xsl:apply-templates/>
<!-- 
	<xsl:text>}</xsl:text>
 -->
</xsl:template>

<xsl:template match="m:menclose">
	<xsl:choose>
		<xsl:when test="@notation = 'actuarial'">
			<xsl:text>\overline{</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>\hspace{.2em}|}</xsl:text>
		</xsl:when>
		<xsl:when test="@notation = 'radical'">
			<xsl:text>\sqrt{</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>}</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>\overline{)</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>}</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="m:mrow">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="m:mstyle">
	<xsl:if test="@displaystyle='true'">
		<xsl:text>{\displaystyle </xsl:text>
	</xsl:if>
	<xsl:if test="@scriptlevel and not(@displaystyle='true')">
		<xsl:text>{</xsl:text>
		<xsl:choose>
			<xsl:when test="@scriptlevel=0"><xsl:text>\textstyle </xsl:text></xsl:when>
			<xsl:when test="@scriptlevel=1"><xsl:text>\scriptstyle </xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>\scriptscriptstyle </xsl:text></xsl:otherwise> 
		</xsl:choose> 
	</xsl:if>	
	<xsl:if test="@background">
		<xsl:text>\colorbox[rgb]{</xsl:text>
		<xsl:call-template name="color">
			<xsl:with-param name="color" select="@background"/>
		</xsl:call-template>
		<xsl:text>}{$</xsl:text>
	</xsl:if>
	<xsl:if test="@color or @mathcolor">
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="@mathcolor"><xsl:value-of select="@mathcolor"/></xsl:when>
				<xsl:when test="@color"><xsl:value-of select="@color"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:text>\textcolor[rgb]{</xsl:text>
		<xsl:call-template name="color">
			<xsl:with-param name="color" select="$color"/>
		</xsl:call-template>
		<xsl:text>}{</xsl:text>
	</xsl:if>
	<xsl:apply-templates/>
	<xsl:if test="@color or @mathcolor">
		<xsl:text>}</xsl:text>
	</xsl:if>
	<xsl:if test="@background">
		<xsl:text>$}</xsl:text>
	</xsl:if>
	<xsl:if test="@scriptlevel and not(@displaystyle='true')">
		<xsl:text>}</xsl:text>
	</xsl:if>	
	<xsl:if test="@displaystyle='true'">
		<xsl:text>}</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="m:merror">
	<xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
