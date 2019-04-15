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
	
	<xsl:include href="../layout.xsl"/>
	 
	 
	 <!-- =============================
	               HTML BODY
	 ================================== -->
	 
	 <xsl:template name="body">
	 	
	 	<body>
	 	
			<!--
		     @ pre code here
			-->
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tcolor">
  	 	
		 		<xsl:call-template name="title"/>
	
				<!--
			     @ inter code here
				-->

		 		<xsl:call-template name="toc"/>
	 		
				<!--
			     @ post code here
				-->
			
			</table>

	 	</body>
	 	
	 </xsl:template>
	 
	 
	 
	 
	 <xsl:template name="title">
	    <!--
	      @ Pre title html code here
	    -->
		 <tr> 
    			<td height="200%" colspan="9" class="toctitle">
    		
			    	<xsl:value-of select="/session/general-info/@title"/>
	    
	    <!--
	      @ Post title html code here
	    -->
	    
 				</td>
	  	</tr>

	 </xsl:template>
	 
	 
 	 <xsl:template name="toc">

		<!-- @ pre toc html here -->

		<!-- - - -->
		
		<!-- use this to group documents, it
		is for example usefull when generating tables -->
		
		
		
		<xsl:call-template name="toc-with-group">
			<xsl:with-param name="group" select="3"/>
		</xsl:call-template>
		
		
		<!-- use this alternative if you do not need to use groups 
		(uncomment to use - and do not forget to comment the group 
		option above...)-->

		<!-- <xsl:apply-templates select="/session/content/document"/> -->
		
		<!-- @ post toc html here	-->
		
		<!-- - - -->

	 </xsl:template>

	 
	 <xsl:template name="toc-with-group">
	 	<xsl:param name="group"/>

	 	<xsl:for-each select="/session/content/document[ ( ( position() - 1 ) mod $group ) = 0 ]">
				
				<xsl:call-template name="document-group">
			  		<xsl:with-param name="group" select="$group"/>
				</xsl:call-template>  
			
		</xsl:for-each>

	 </xsl:template>
	 
	 <xsl:template name="document-group">
	 	<xsl:param name="group"/>
	 	
	 	<!-- @ pre group code here -->
	 	
	 	<tr> 
	   	<td width="30" height="200" class="ccolor"></td>
 	
	 	<!-- - - -->

		 	<xsl:variable name="count" select="(position() - 1) * $group + 1"/>
		 	
		 	<xsl:for-each select="/session/content/document[$count &lt;= position() and position() &lt; ($count + $group)]">
		 	
					<xsl:apply-templates select="."/>
					
					<xsl:choose>
						<xsl:when test="last()=1 and position()=last()">
						  <xsl:call-template name="empty-doc"/>
						  <xsl:call-template name="empty-doc"/>
						</xsl:when>
						<xsl:when test="last()=2 and position()=last()">
						  <xsl:call-template name="empty-doc"/>
						</xsl:when>
					</xsl:choose> 
			 	  
		 	</xsl:for-each>
	 	
	 	<!-- @ post group code here -->
   	
   		<td colspan="2" class="ccolor"></td>
	   </tr>
	 	
	 	<!-- - - -->
	 	
	 </xsl:template>

	<xsl:template name="empty-doc">
		<td width="50"> <p>	</p></td>
		<td width="200"> <p>	</p></td>
	</xsl:template>
	
	
	<!-- also when using groups, in the end it comes 
	to this template, which is called for each document -->
	
	<xsl:template match="document">
		<!-- file format icon -->
		
		<td width="50"> <p>
				<xsl:apply-templates select="@icon"/>
		</p></td>
		
		<td width="200"> <p> 
			
			<xsl:apply-templates select="@title"/>
			<xsl:apply-templates select="@description"/>
			<xsl:apply-templates select="@author"/>
			<xsl:apply-templates select="@create-date"/>
			<xsl:apply-templates select="@update-date"/>
			<xsl:apply-templates select="@filename"/>
			<xsl:apply-templates select="@format"/>
			<xsl:apply-templates select="@pages"/>
			<xsl:apply-templates select="@size"/>
			
		</p> </td>
			
	</xsl:template>

</xsl:stylesheet>
