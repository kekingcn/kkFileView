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



<!ELEMENT script:libraries (script:library-embedded | script:library-linked)*>
<!ATTLIST script:libraries xmlns:script CDATA #FIXED "http://openoffice.org/2000/script">
<!ATTLIST script:libraries xmlns:xlink CDATA #FIXED "http://www.w3.org/1999/xlink">

<!ENTITY % boolean "(true|false)">

<!ELEMENT script:library-embedded (script:module*)>
<!ATTLIST script:library-embedded script:name %string; #REQUIRED>
<!ATTLIST script:library-embedded script:readonly %boolean; #IMPLIED>

<!ELEMENT script:library-linked EMPTY>
<!ATTLIST script:library-linked script:name %string; #REQUIRED>
<!ATTLIST script:library-linked xlink:href %string; #REQUIRED>
<!ATTLIST script:library-linked xlink:type (simple) #FIXED "simple">
<!ATTLIST script:library-linked script:readonly %boolean; #IMPLIED>

<!ELEMENT script:module (script:source-code)>
<!ATTLIST script:module script:name %string; #REQUIRED>

<!ELEMENT script:source-code (#PCDATA)>


<!ENTITY % script-language "script:language %string; #REQUIRED">
<!ENTITY % event-name "script:event-name %string; #REQUIRED">
<!ENTITY % location "script:location (document|application) #REQUIRED">
<!ENTITY % macro-name "script:macro-name %string; #REQUIRED">

<!ELEMENT script:event (#PCDATA)>
<!ATTLIST script:event %script-language;
                       %event-name;
                       %location;
					   %macro-name;>
