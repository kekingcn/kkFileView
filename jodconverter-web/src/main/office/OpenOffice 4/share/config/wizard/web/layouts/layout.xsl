<?xml version="1.0" encoding="UTF-8"?>
<!--***********************************************************
 * 
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 * 
 ***********************************************************-->


<!-- =================================================

This template is a skeleton for single level TOC pages 
Do not overwrite this ! copy it and complete the missing
code.

I use the @ character whereever there is a missing code, so 
you can use a simple find to navigate and find the
places...

====================================================== -->

<xsl:stylesheet version="1.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	
	<xsl:output method               = "html"
                media-type           = "text/html"
                indent               = "yes"
                doctype-public       = "-//W3C//DTD HTML 4.0 Transitional//EN"
                omit-xml-declaration = "yes"
                standalone           = "yes" /> 
  
	 <!-- =============================
	               ROOT
	 ================================== -->


    <xsl:template  match="/">
      	<html>
				   <xsl:call-template name="head"/>
			      <xsl:call-template name="body"/>
		   </html>
	 </xsl:template>
	 
	 
	 <!-- =============================
	         Document properties
	         
	 This section contains templates which
	 give the document properties...
	               
	 ================================== -->
	 
	 <!-- this tempaltes gives the
	 relative href of the document. To use
	 with the <a href="..."> attribute-->
	
	
	 <xsl:template match="document" mode="href">
	   <xsl:value-of select="concat(../@directory,'/')"/>
	   <xsl:if test="@dir">
	     <xsl:value-of select="concat(@dir,'/')"/>
	   </xsl:if>
	   <xsl:value-of select="@fn"/>
	 </xsl:template>
	 
	 
	<xsl:template match="document/@title">
	 	<xsl:param name="target" select="''"/>
		
	 	<span class="doctitle">
	 		<a>
	 		<xsl:attribute name="href"> 
				<xsl:apply-templates select=".." mode="href"/>
			</xsl:attribute>
			
			<xsl:if test=" $target != ''">
				<xsl:attribute name="target">
					<xsl:value-of select="$target"/>
				</xsl:attribute>
			</xsl:if>
			
			<xsl:value-of select="."/>
			</a>
	 	</span>
	 	<br/>
	 </xsl:template>
	

	 <xsl:template match="document/@description">
	 	<span class="docdescription">
	 		<xsl:value-of select="."/>
	 	</span>
	 	<br/>
	 </xsl:template>
	 

	 <xsl:template match="document/@author">
	 	<span class="docauthor">
	 		<xsl:value-of select="."/>
	 	</span>
	 	<br/>
	 </xsl:template>
	 

	 <xsl:template match="document/@create-date">
	 	<span class="doccreationdate">
	 		<xsl:value-of select="."/>
	 	</span>
	 	<br/>
	 </xsl:template>
	 

	 <xsl:template match="document/@update-date">
	 	<span class="doclastchangeddate">
	 		<xsl:value-of select="."/>
	 	</span>
	 	<br/>
	 </xsl:template>
	 

	 <xsl:template match="document/@filename">
	 	<span class="docfilename">
	 		<xsl:value-of select="."/>
	 	</span>
	 	<br/>
	 </xsl:template>


	 <xsl:template match="document/@format">
	 	<span class="docfileformatinfo">
	 		<xsl:value-of select="."/>
	 	</span>
	 	<br/>
	 </xsl:template>


	 <xsl:template match="document/@pages">
	 	<span class="docnumberofpages">
	 		<xsl:value-of select="."/>
	 	</span>
	 	<br/>
	 </xsl:template>
	 

	 <xsl:template match="document/@size">
	 	<span class="docsizeinkb">
	 		<xsl:value-of select="."/>
	 	</span>
	 	<br/>
	 </xsl:template>
	 
	 <xsl:template match="document/@icon">
	   <img src="images/{.}"/>
	 	<br/>
	 </xsl:template>
	

	 <!-- =============================
	               HTML HEAD
	               
    this section should not be changed
	 ================================== -->
	 
	 <xsl:template name="head">
	 	<head>
				<title>
				 	<xsl:value-of select="/session/general-info/@title"/>
				</title>
				<!-- <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> -->
				<meta HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=UTF-8"/>
				<meta name="description" content="{/session/general-info/@description}"/>
				<meta name="keywords" content="{/session/general-info/@keywords}"/>
				<meta name="author" content="{/session/general-info/@author}"/>
				<meta name="email" content="{/session/general-info/@email}"/>
				<meta name="copyright" content="{/session/general-info/@copyright}"/>
				<!-- create date?
				     update date?
				     fav icon?
				     -->
		     <link href="style.css" rel="stylesheet" type="text/css"/>

		</head>
	 </xsl:template>
	     
</xsl:stylesheet>
