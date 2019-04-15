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



<!-- This module should contain entities intended for content definitions
     in several other modules. Putting all of them here should remove
     (some) order dependencies of the other module files
-->


<!-- text marks for tracking changes; usually used inside of paragraphs -->
<!ENTITY % change-marks "text:change | text:change-start | text:change-end">

<!-- (optional) text declarations; used before the first paragraph -->
<!ENTITY % text-decls "text:variable-decls?, text:sequence-decls?,
					   text:user-field-decls?, text:dde-connection-decls?, 
					   text:alphabetical-index-auto-mark-file?" >

<!-- define the types of text which may occur inside of sections -->
<!ENTITY % sectionText "(text:h|text:p|text:ordered-list|
						text:unordered-list|table:table|text:section|
						text:table-of-content|text:illustration-index|
						text:table-index|text:object-index|text:user-index|
						text:alphabetical-index|text:bibliography|
						text:index-title|%change-marks;)*">

<!ENTITY % headerText "(%text-decls;, (text:h|text:p|text:ordered-list|
						text:unordered-list|table:table|text:section|
						text:table-of-content|text:illustration-index|
						text:table-index|text:object-index|text:user-index|
						text:alphabetical-index|text:bibliography|
						text:index-title|%change-marks;)* )">

