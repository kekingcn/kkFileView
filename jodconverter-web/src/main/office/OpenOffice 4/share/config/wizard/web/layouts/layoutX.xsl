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



<xsl:stylesheet version="1.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	
	<xsl:output method               = "html"
                media-type           = "text/html"
                indent               = "yes"
                doctype-public       = "-//W3C//DTD HTML 4.0 Transitional//EN"
                omit-xml-declaration = "yes"
                standalone           = "yes" />
	
	<xsl:include href="../layout.xsl"/>
   
 
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
	               HTML BODY
	 ================================== -->
	 
	 <xsl:template name="body">
	 	<body>
		 	<xsl:call-template name="title"/>
		 	<xsl:call-template name="toc"/>
		</body>
	 </xsl:template>
	 
	 
	 <xsl:template name="toc">
		<!--
		     @ pre toc html here
		-->
		
		<!-- use this to group documents, it
		is for example usefull when generating tables -->
		
		<xsl:variable name="group" select="3"/>
		
		<xsl:for-each select="/session/content/document[ ( ( position() - 1 ) mod $group ) = 0 ]">
			
			<!-- 
				@ pre group html here 
			-->
			
			<xsl:call-template name="document-group">
			  <xsl:with-param name="group" select="$group"/>
			</xsl:call-template>  
			
			<!--
				@ post group html here
			-->
			
		</xsl:for-each>


		<!-- use this alternative if you do not need to use groups 
		(uncomment to use - and do not forget to comment the group 
		option above...)-->

		<!-- 
	  <xsl:apply-templates select="/session/content/document"/>
		-->

		<!--
		     @ post toc html here
		-->

	 </xsl:template>
	 
	<!-- also when using groups, in the end it comes 
	to this template, which is called for each document -->
	<xsl:template match="document">
	  <xsl:apply-templates select="@title"/>
	  <xsl:apply-templates select="@description"/>
	  <xsl:apply-templates select="@author"/>
	  <xsl:apply-templates select="@create-date"/>
	  <xsl:apply-templates select="@update-date"/>
	  <xsl:apply-templates select="@filename"/>
	  <xsl:apply-templates select="@format"/>
	  <xsl:apply-templates select="@format-icon"/>
	  <xsl:apply-templates select="@format-icon"/>
	</xsl:template>
		

	 
	 <xsl:template name="document-group">
	 	<xsl:param name="group"/>
	 	
	 	<!-- @ pre group code here -->
	 	
	 	<!-- - - -->

		 	<xsl:variable name="count" select="(position() - 1) * $group + 1"/>
		 	
		 	<xsl:for-each select="/session/content/document[$count &lt;= position() and position() &lt; ($count + $group)]">
		 	
					<xsl:apply-templates select="."/>
			 	  
		 	</xsl:for-each>
	 	
	 	<!-- @ post group code here -->
	 	
	 	<!-- - - -->
	 	
	 </xsl:template>

	 	 
	 <xsl:template name="title">
	    <!--
	      @ Pre title html code here
	    -->
	    
	    <xsl:value-of select="/session/general-info/@title"/>
	    
	    <!--
	      @ Post title html code here
	    -->
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
	 	<span class="doctitle">
	 		<a>
	 		<xsl:attribute name="href"> 
				<xsl:apply-templates select=".." mode="href"/>
			</xsl:attribute> 
			
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
