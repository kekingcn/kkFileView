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

<!ENTITY % fields "text:date |
				   text:time |
				   text:page-number |
				   text:page-continuation |
				   text:sender-firstname |
				   text:sender-lastname |
				   text:sender-initials |
				   text:sender-title |
				   text:sender-position |
				   text:sender-email | 
				   text:sender-phone-private |
				   text:sender-fax | 
				   text:sender-company |
				   text:sender-phone-work |
				   text:sender-street |
				   text:sender-city |
				   text:sender-postal-code |
				   text:sender-country |
				   text:sender-state-or-province |
				   text:author-name |
				   text:author-initials |
				   text:placeholder |
				   text:variable-set | 
				   text:variable-get | 
				   text:variable-input | 
				   text:user-field-get | 
				   text:user-field-input | 
				   text:sequence | 
				   text:expression | 
				   text:text-input |
				   text:database-display |
				   text:database-next |
				   text:database-select |
				   text:database-row-number |
				   text:database-name |
				   text:initial-creator |
				   text:creation-date |
				   text:creation-time |
				   text:description |
				   text:user-defined |
				   text:print-time |
				   text:print-date |
				   text:printed-by |
				   text:title |
				   text:subject |
				   text:keywords |
				   text:editing-cycles |
				   text:editing-duration |
				   text:modification-time |
				   text:modification-date |
				   text:creator |
				   text:conditional-text |
				   text:hidden-text |
				   text:hidden-paragraph |
				   text:chapter |
				   text:file-name |
				   text:template-name |
				   text:page-variable-set |
				   text:page-variable-get |
				   text:execute-macro |
				   text:dde-connection |
				   text:reference-ref |
				   text:sequence-ref |
				   text:bookmark-ref |
				   text:footnote-ref |
				   text:endnote-ref |
				   text:sheet-name |
				   text:bibliography-mark |
				   text:page-count |
				   text:paragraph-count |
				   text:word-count |
				   text:character-count |
				   text:table-count |
				   text:image-count |
				   text:object-count |
				   office:annotation |
				   text:script |
				   text:measure" >

<!ENTITY % inline-text-elements "
				 text:span|text:tab-stop|text:s|text:line-break|
				 text:footnote|text:endnote|text:a|
				 text:bookmark|text:bookmark-start|text:bookmark-end|
				 text:reference-mark|text:reference-mark-start|
				 text:reference-mark-end|%fields;|%shape;|
				 text:toc-mark-start | text:toc-mark-end | 
				 text:toc-mark | text:user-index-mark-start |
				 text:user-index-mark-end | text:user-index-mark |
				 text:alphabetical-index-mark-start |
				 text:alphabetical-index-mark-end |
				 text:alphabetical-index-mark |
				 %change-marks; | draw:a | text:ruby">

<!ENTITY % inline-text "( #PCDATA | %inline-text-elements; )*">

<!ELEMENT text:p %inline-text;>
<!ELEMENT text:h %inline-text;>

<!ATTLIST text:p text:style-name %styleName; #IMPLIED>
<!ATTLIST text:p text:cond-style-name %styleName; #IMPLIED>

<!ATTLIST text:h text:style-name %styleName; #IMPLIED>
<!ATTLIST text:h text:cond-style-name %styleName; #IMPLIED>
<!ATTLIST text:h text:level %positiveInteger; "1">

<!ELEMENT text:span %inline-text;>
<!ATTLIST text:span text:style-name %styleName; #REQUIRED>

<!ELEMENT text:a (#PCDATA | office:events | %inline-text-elements;)*>
<!ATTLIST text:a xlink:href %uriReference; #REQUIRED>
<!ATTLIST text:a xlink:type (simple) #FIXED "simple">
<!ATTLIST text:a xlink:actuate (onRequest) "onRequest">
<!ATTLIST text:a xlink:show (new|replace) "replace">
<!ATTLIST text:a office:name %string; #IMPLIED>
<!ATTLIST text:a office:target-frame-name %string; #IMPLIED>
<!ATTLIST text:a text:style-name %styleName; #IMPLIED>
<!ATTLIST text:a text:visited-style-name %styleName; #IMPLIED>


<!ELEMENT text:s EMPTY>
<!ATTLIST text:s text:c %positiveInteger; "1">

<!ELEMENT text:tab-stop EMPTY>

<!ELEMENT text:line-break EMPTY>


<!ENTITY % list-items "((text:list-header,text:list-item*)|text:list-item+)">
<!ELEMENT text:ordered-list %list-items;>
<!ELEMENT text:unordered-list %list-items;>


<!ATTLIST text:ordered-list text:style-name %styleName; #IMPLIED>
<!ATTLIST text:unordered-list text:style-name %styleName; #IMPLIED>

<!ATTLIST text:ordered-list text:continue-numbering %boolean; "false">

<!ELEMENT text:list-header (text:p|text:h)+>
<!ELEMENT text:list-item (text:p|text:h|text:ordered-list|text:unordered-list)+>

<!ATTLIST text:list-item text:restart-numbering %boolean; "false">
<!ATTLIST text:list-item text:start-value %positiveInteger; #IMPLIED>

<!ELEMENT text:list-style (text:list-level-style-number|
     					   text:list-level-style-bullet|
     					   text:list-level-style-image)+>

<!ATTLIST text:list-style style:name %styleName; #IMPLIED>

<!ATTLIST text:list-style text:consecutive-numbering %boolean; "false">


<!ELEMENT text:list-level-style-number (style:properties?)>

<!ATTLIST text:list-level-style-number text:level %positiveInteger;
									     		 #REQUIRED>
<!ATTLIST text:list-level-style-number text:style-name %styleName; #IMPLIED>

<!ATTLIST text:list-level-style-number style:num-format %string; #REQUIRED>
<!ATTLIST text:list-level-style-number style:num-prefix %string; #IMPLIED>
<!ATTLIST text:list-level-style-number style:num-suffix %string; #IMPLIED>
<!ATTLIST text:list-level-style-number style:num-letter-sync %boolean;
									     					"false">
<!ATTLIST text:list-level-style-number text:display-levels %positiveInteger;
									     				  "1">
<!ATTLIST text:list-level-style-number text:start-value %positiveInteger;
														   "1">
<!ELEMENT text:list-level-style-bullet (style:properties?)>

<!ATTLIST text:list-level-style-bullet text:level %positiveInteger; #REQUIRED>
<!ATTLIST text:list-level-style-bullet text:style-name %styleName; #IMPLIED>
<!ATTLIST text:list-level-style-bullet text:bullet-char %character; #REQUIRED>
<!ATTLIST text:list-level-style-bullet style:num-prefix %string; #IMPLIED>
<!ATTLIST text:list-level-style-bullet style:num-suffix %string; #IMPLIED>

<!ELEMENT text:list-level-style-image (style:properties?,office:binary-data?)>

<!ATTLIST text:list-level-style-image text:level %positiveInteger; #REQUIRED>
<!ATTLIST text:list-level-style-image xlink:type (simple) #IMPLIED>
<!ATTLIST text:list-level-style-image xlink:href %uriReference; #IMPLIED>
<!ATTLIST text:list-level-style-image xlink:actuate (onLoad) #IMPLIED>
<!ATTLIST text:list-level-style-image xlink:show (embed) #IMPLIED>


<!-- list properties -->
<!ATTLIST style:properties text:space-before %nonNegativeLength; #IMPLIED>
<!ATTLIST style:properties text:min-label-width %nonNegativeLength; #IMPLIED>
<!ATTLIST style:properties text:min-label-distance %nonNegativeLength; #IMPLIED>
<!ATTLIST style:properties text:enable-numbering %boolean; #IMPLIED>
<!ATTLIST style:properties style:list-style-name %styleName; #IMPLIED>

<!ELEMENT text:outline-style (text:outline-level-style)+>

<!ELEMENT text:outline-level-style (style:properties?)>

<!ATTLIST text:outline-level-style text:level %positiveInteger;
													 #REQUIRED>
<!ATTLIST text:outline-level-style text:style-name %styleName; #IMPLIED>

<!ATTLIST text:outline-level-style style:num-format %string; #REQUIRED>
<!ATTLIST text:outline-level-style style:num-prefix %string; #IMPLIED>
<!ATTLIST text:outline-level-style style:num-suffix %string; #IMPLIED>
<!ATTLIST text:outline-level-style style:num-letter-sync %boolean;
																"false">
<!ATTLIST text:outline-level-style text:display-levels %positiveInteger;
															  "1">
<!ATTLIST text:outline-level-style text:start-value %positiveInteger;
														   "1">

<!ENTITY % field-declarations "text:variable-decls?, 
							   text:user-field-decls?, 
							   text:sequence-decls?">

<!ENTITY % variableName "CDATA">

<!ENTITY % formula "CDATA">

<!ENTITY % valueAttr "text:value-type %valueType; #IMPLIED
							 text:currency CDATA #IMPLIED" >

<!ENTITY % valueAndTypeAttr "%valueAttr;
		 					 text:value %float; #IMPLIED
							 text:date-value %date; #IMPLIED
							 text:time-value %timeInstance; #IMPLIED
							 text:boolean-value %boolean; #IMPLIED
							 text:string-value %string; #IMPLIED" >

<!ENTITY % numFormat 'style:num-format CDATA #IMPLIED 
					   style:num-letter-sync %boolean; "false"'>


<!ELEMENT text:date (#PCDATA)>
<!ATTLIST text:date text:date-value %timeInstance; #IMPLIED>
<!ATTLIST text:date text:date-adjust %dateDuration; #IMPLIED>
<!ATTLIST text:date text:fixed %boolean; "false">
<!ATTLIST text:date style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:time (#PCDATA)>
<!ATTLIST text:time text:time-value %timeInstance; #IMPLIED>
<!ATTLIST text:time text:time-adjust %timeDuration; #IMPLIED>
<!ATTLIST text:time text:fixed %boolean; "false">
<!ATTLIST text:time style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:page-number (#PCDATA)>
<!ATTLIST text:page-number text:page-adjust %positiveInteger; #IMPLIED>
<!ATTLIST text:page-number text:select-page (previous|current|next) "current">
<!ATTLIST text:page-number %numFormat;>

<!ELEMENT text:page-continuation (#PCDATA)>
<!ATTLIST text:page-continuation text:select-page (previous|next) #REQUIRED>
<!ATTLIST text:page-continuation text:string-value %string; #IMPLIED>

<!ELEMENT text:sender-firstname (#PCDATA)>
<!ATTLIST text:sender-firstname text:fixed %boolean; "true">

<!ELEMENT text:sender-lastname (#PCDATA)>
<!ATTLIST text:sender-lastname text:fixed %boolean; "true">

<!ELEMENT text:sender-initials (#PCDATA)>
<!ATTLIST text:sender-initials text:fixed %boolean; "true">

<!ELEMENT text:sender-title (#PCDATA)>
<!ATTLIST text:sender-title text:fixed %boolean; "true">

<!ELEMENT text:sender-position (#PCDATA)>
<!ATTLIST text:sender-position text:fixed %boolean; "true">

<!ELEMENT text:sender-email (#PCDATA)>
<!ATTLIST text:sender-email text:fixed %boolean; "true">

<!ELEMENT text:sender-phone-private (#PCDATA)>
<!ATTLIST text:sender-phone-private text:fixed %boolean; "true">

<!ELEMENT text:sender-fax (#PCDATA)>
<!ATTLIST text:sender-fax text:fixed %boolean; "true">

<!ELEMENT text:sender-company (#PCDATA)>
<!ATTLIST text:sender-company text:fixed %boolean; "true">

<!ELEMENT text:sender-phone-work (#PCDATA)>
<!ATTLIST text:sender-phone-work text:fixed %boolean; "true">

<!ELEMENT text:sender-street (#PCDATA)>
<!ATTLIST text:sender-street text:fixed %boolean; "true">

<!ELEMENT text:sender-city (#PCDATA)>
<!ATTLIST text:sender-city text:fixed %boolean; "true">

<!ELEMENT text:sender-postal-code (#PCDATA)>
<!ATTLIST text:sender-postal-code text:fixed %boolean; "true">

<!ELEMENT text:sender-country (#PCDATA)>
<!ATTLIST text:sender-country text:fixed %boolean; "true">

<!ELEMENT text:sender-state-or-province (#PCDATA)>
<!ATTLIST text:sender-state-or-province text:fixed %boolean; "true">

<!ELEMENT text:author-name (#PCDATA)>
<!ATTLIST text:author-name text:fixed %boolean; "true">

<!ELEMENT text:author-initials (#PCDATA)>
<!ATTLIST text:author-initials text:fixed %boolean; "true">

<!ELEMENT text:placeholder (#PCDATA)>
<!ATTLIST text:placeholder text:placeholder-type (text|table|text-box|image|object) #REQUIRED>
<!ATTLIST text:placeholder text:description %string; #IMPLIED>

<!ELEMENT text:variable-decls (text:variable-decl)*>

<!ELEMENT text:variable-decl EMPTY>
<!ATTLIST text:variable-decl text:name %variableName; #REQUIRED>
<!ATTLIST text:variable-decl %valueAndTypeAttr;>

<!ELEMENT text:variable-set (#PCDATA)>
<!ATTLIST text:variable-set text:name %variableName; #REQUIRED>
<!ATTLIST text:variable-set text:formula %formula; #IMPLIED>
<!ATTLIST text:variable-set %valueAndTypeAttr;>
<!ATTLIST text:variable-set text:display (value|none) "value">
<!ATTLIST text:variable-set style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:variable-get (#PCDATA)>
<!ATTLIST text:variable-get text:name %variableName; #REQUIRED>
<!ATTLIST text:variable-get text:display (value|formula) "value">
<!ATTLIST text:variable-get style:data-style-name %styleName; #IMPLIED>
<!ATTLIST text:variable-get %valueAttr;>

<!ELEMENT text:variable-input (#PCDATA)>
<!ATTLIST text:variable-input text:name %variableName; #REQUIRED>
<!ATTLIST text:variable-input text:description %string; #IMPLIED>
<!ATTLIST text:variable-input %valueAndTypeAttr;>
<!ATTLIST text:variable-input text:display (value|none) "value">
<!ATTLIST text:variable-input style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:user-field-decls (text:user-field-decl)*>

<!ELEMENT text:user-field-decl EMPTY>
<!ATTLIST text:user-field-decl text:name %variableName; #REQUIRED>
<!ATTLIST text:user-field-decl text:formula %formula; #IMPLIED>
<!ATTLIST text:user-field-decl %valueAndTypeAttr;>

<!ELEMENT text:user-field-get (#PCDATA)>
<!ATTLIST text:user-field-get text:name %variableName; #REQUIRED>
<!ATTLIST text:user-field-get text:display (value|formula|none) "value">
<!ATTLIST text:user-field-get style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:user-field-input (#PCDATA)>
<!ATTLIST text:user-field-input text:name %variableName; #REQUIRED>
<!ATTLIST text:user-field-input text:description %string; #IMPLIED>
<!ATTLIST text:user-field-input style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:sequence-decls (text:sequence-decl)*>

<!ELEMENT text:sequence-decl EMPTY>
<!ATTLIST text:sequence-decl text:name %variableName; #REQUIRED>
<!ATTLIST text:sequence-decl text:display-outline-level %positiveInteger; "0">
<!ATTLIST text:sequence-decl text:separation-character %character; ".">

<!ELEMENT text:sequence (#PCDATA)>
<!ATTLIST text:sequence text:name %variableName; #REQUIRED>
<!ATTLIST text:sequence text:formula %formula; #IMPLIED>
<!ATTLIST text:sequence %numFormat;>
<!ATTLIST text:sequence text:ref-name ID #IMPLIED>

<!ELEMENT text:expression (#PCDATA)>
<!ATTLIST text:expression text:formula %formula; #IMPLIED>
<!ATTLIST text:expression text:display (value|formula ) "value">
<!ATTLIST text:expression %valueAndTypeAttr;>
<!ATTLIST text:expression style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:text-input (#PCDATA)>
<!ATTLIST text:text-input text:description %string; #IMPLIED>

<!ENTITY % database-table "text:database-name CDATA #REQUIRED 
						   text:table-name CDATA #REQUIRED
						   text:table-type (table|query|command) #IMPLIED">

<!ELEMENT text:database-display (#PCDATA)>
<!ATTLIST text:database-display %database-table;>
<!ATTLIST text:database-display text:column-name %string; #REQUIRED>
<!ATTLIST text:database-display style:data-style-name %styleName; #IMPLIED>
<!ATTLIST text:database-display text:display (none|value) #IMPLIED>

<!ELEMENT text:database-next (#PCDATA)>
<!ATTLIST text:database-next %database-table;>
<!ATTLIST text:database-next text:condition %formula; #IMPLIED>

<!ELEMENT text:database-select (#PCDATA)>
<!ATTLIST text:database-select %database-table;>
<!ATTLIST text:database-select text:condition %formula; #IMPLIED>
<!ATTLIST text:database-select text:row-number %integer; #REQUIRED>

<!ELEMENT text:database-row-number (#PCDATA)>
<!ATTLIST text:database-row-number %database-table;>
<!ATTLIST text:database-row-number %numFormat;>
<!ATTLIST text:database-row-number text:value %integer; #IMPLIED>
<!ATTLIST text:database-row-number text:display (none|value) #IMPLIED>

<!ELEMENT text:database-name (#PCDATA)>
<!ATTLIST text:database-name %database-table;>
<!ATTLIST text:database-name text:display (none|value) #IMPLIED>

<!ELEMENT text:initial-creator (#PCDATA)>
<!ATTLIST text:initial-creator text:fixed %boolean; "false">

<!ELEMENT text:creation-date (#PCDATA)>
<!ATTLIST text:creation-date text:fixed %boolean; "false">
<!ATTLIST text:creation-date text:date-value %date; #IMPLIED>
<!ATTLIST text:creation-date style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:creation-time (#PCDATA)>
<!ATTLIST text:creation-time text:fixed %boolean; "false">
<!ATTLIST text:creation-time text:time-value %timeInstance; #IMPLIED>
<!ATTLIST text:creation-time style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:description (#PCDATA)>
<!ATTLIST text:description text:fixed %boolean; "false">

<!ELEMENT text:user-defined (#PCDATA)>
<!ATTLIST text:user-defined text:fixed %boolean; "false">
<!ATTLIST text:user-defined text:name %string; #REQUIRED>

<!ELEMENT text:print-time (#PCDATA)>
<!ATTLIST text:print-time text:fixed %boolean; "false">
<!ATTLIST text:print-time text:time-value %timeInstance; #IMPLIED>
<!ATTLIST text:print-time style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:print-date (#PCDATA)>
<!ATTLIST text:print-date text:fixed %boolean; "false">
<!ATTLIST text:print-date text:date-value %date; #IMPLIED>
<!ATTLIST text:print-date style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:printed-by (#PCDATA)>
<!ATTLIST text:printed-by text:fixed %boolean; "false">

<!ELEMENT text:title (#PCDATA)>
<!ATTLIST text:title text:fixed %boolean; "false">

<!ELEMENT text:subject (#PCDATA)>
<!ATTLIST text:subject text:fixed %boolean; "false">

<!ELEMENT text:keywords (#PCDATA)>
<!ATTLIST text:keywords text:fixed %boolean; "false">

<!ELEMENT text:editing-cycles (#PCDATA)>
<!ATTLIST text:editing-cycles text:fixed %boolean; "false">

<!ELEMENT text:editing-duration (#PCDATA)>
<!ATTLIST text:editing-duration text:fixed %boolean; "false">
<!ATTLIST text:editing-duration text:duration %timeDuration; #IMPLIED>
<!ATTLIST text:editing-duration style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:modification-time (#PCDATA)>
<!ATTLIST text:modification-time text:fixed %boolean; "false">
<!ATTLIST text:modification-time text:time-value %timeInstance; #IMPLIED>
<!ATTLIST text:modification-time style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:modification-date (#PCDATA)>
<!ATTLIST text:modification-date text:fixed %boolean; "false">
<!ATTLIST text:modification-date text:date-value %date; #IMPLIED>
<!ATTLIST text:modification-date style:data-style-name %styleName; #IMPLIED>

<!ELEMENT text:creator (#PCDATA)>
<!ATTLIST text:creator text:fixed %boolean; "false">

<!ELEMENT text:conditional-text (#PCDATA)>
<!ATTLIST text:conditional-text text:condition %formula; #REQUIRED>
<!ATTLIST text:conditional-text text:string-value-if-false %string; #REQUIRED>
<!ATTLIST text:conditional-text text:string-value-if-true %string; #REQUIRED>
<!ATTLIST text:conditional-text text:current-value %boolean; "false">

<!ELEMENT text:hidden-text (#PCDATA)>
<!ATTLIST text:hidden-text text:condition %formula; #REQUIRED>
<!ATTLIST text:hidden-text text:string-value %string; #REQUIRED>
<!ATTLIST text:hidden-text text:is-hidden %boolean; "false">

<!ELEMENT text:hidden-paragraph EMPTY>
<!ATTLIST text:hidden-paragraph text:condition %formula; #REQUIRED>
<!ATTLIST text:hidden-paragraph text:is-hidden %boolean; "false">

<!ELEMENT text:chapter (#PCDATA)>
<!ATTLIST text:chapter text:display (name|number|number-and-name|
									 plain-number-and-name|plain-number) 
									 "number-and-name">
<!ATTLIST text:chapter text:outline-level %integer; "1">

<!ELEMENT text:file-name (#PCDATA)>
<!ATTLIST text:file-name text:display (full|path|name|name-and-extension) 	
									  "full">
<!ATTLIST text:file-name text:fixed %boolean; "false">

<!ELEMENT text:template-name (#PCDATA)>
<!ATTLIST text:template-name text:display (full|path|name|name-and-extension|
										  area|title) "full">

<!ELEMENT text:page-variable-set EMPTY>
<!ATTLIST text:page-variable-set text:active %boolean; "true">
<!ATTLIST text:page-variable-set text:page-adjust %integer; "0">

<!ELEMENT text:page-variable-get (#PCDATA)>
<!ATTLIST text:page-variable-get %numFormat;>

<!ELEMENT text:execute-macro (#PCDATA|office:events)* >
<!ATTLIST text:execute-macro text:description %string; #IMPLIED>


<!ELEMENT text:dde-connection-decls (text:dde-connection-decl)*>

<!ELEMENT text:dde-connection-decl EMPTY>
<!ATTLIST text:dde-connection-decl text:name %string; #REQUIRED>
<!ATTLIST text:dde-connection-decl office:dde-application %string; #REQUIRED>
<!ATTLIST text:dde-connection-decl office:dde-topic %string; #REQUIRED>
<!ATTLIST text:dde-connection-decl office:dde-item %string; #REQUIRED>
<!ATTLIST text:dde-connection-decl office:automatic-update %boolean; "false">

<!ELEMENT text:dde-connection (#PCDATA)>
<!ATTLIST text:dde-connection text:connection-name %string; #REQUIRED>

<!ELEMENT text:reference-ref (#PCDATA)>
<!ATTLIST text:reference-ref text:ref-name %string; #REQUIRED>
<!ATTLIST text:reference-ref text:reference-format (page|chapter|text|direction) #IMPLIED>

<!ELEMENT text:sequence-ref (#PCDATA)>
<!ATTLIST text:sequence-ref text:ref-name %string; #REQUIRED>
<!ATTLIST text:sequence-ref text:reference-format (page|chapter|text|direction|category-and-value|caption|value) #IMPLIED>

<!ELEMENT text:bookmark-ref (#PCDATA)>
<!ATTLIST text:bookmark-ref text:ref-name %string; #REQUIRED>
<!ATTLIST text:bookmark-ref text:reference-format (page|chapter|text|direction) #IMPLIED>

<!ELEMENT text:footnote-ref (#PCDATA)>
<!ATTLIST text:footnote-ref text:ref-name %string; #REQUIRED>
<!ATTLIST text:footnote-ref text:reference-format (page|chapter|text|direction) #IMPLIED>

<!ELEMENT text:endnote-ref (#PCDATA)>
<!ATTLIST text:endnote-ref text:ref-name %string; #REQUIRED>
<!ATTLIST text:endnote-ref text:reference-format (page|chapter|text|direction) #IMPLIED>

<!ELEMENT text:sheet-name (#PCDATA)>

<!ELEMENT text:page-count (#PCDATA)>
<!ATTLIST text:page-count style:num-format %string; #IMPLIED>
<!ATTLIST text:page-count style:num-letter-sync %boolean; "false">

<!ELEMENT text:paragraph-count (#PCDATA)>
<!ATTLIST text:paragraph-count style:num-format %string; #IMPLIED>
<!ATTLIST text:paragraph-count style:num-letter-sync %boolean; "false">

<!ELEMENT text:word-count (#PCDATA)>
<!ATTLIST text:word-count style:num-format %string; #IMPLIED>
<!ATTLIST text:word-count style:num-letter-sync %boolean; "false">

<!ELEMENT text:character-count (#PCDATA)>
<!ATTLIST text:character-count style:num-format %string; #IMPLIED>
<!ATTLIST text:character-count style:num-letter-sync %boolean; "false">

<!ELEMENT text:table-count (#PCDATA)>
<!ATTLIST text:table-count style:num-format %string; #IMPLIED>
<!ATTLIST text:table-count style:num-letter-sync %boolean; "false">

<!ELEMENT text:image-count (#PCDATA)>
<!ATTLIST text:image-count style:num-format %string; #IMPLIED>
<!ATTLIST text:image-count style:num-letter-sync %boolean; "false">

<!ELEMENT text:object-count (#PCDATA)>
<!ATTLIST text:object-count style:num-format %string; #IMPLIED>
<!ATTLIST text:object-count style:num-letter-sync %boolean; "false">

<!ELEMENT text:bibliography-mark (#PCDATA)>
<!ATTLIST text:bibliography-mark text:bibliography-type 
	( article | book | booklet | conference | custom1 | custom2 | custom3 | 
	  custom4 | custom5 | email | inbook | incollection | inproceedings | 
	  journal | manual | mastersthesis | misc | phdthesis | proceedings | 
	  techreport | unpublished | www ) #REQUIRED >
<!ATTLIST text:bibliography-mark text:identifier CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:address CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:annote CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:author CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:booktitle CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:chapter CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:edition CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:editor CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:howpublished CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:institution CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:journal CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:month CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:note CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:number CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:organizations CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:pages CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:publisher CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:school CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:series CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:title CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:report-type CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:volume CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:year CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:url CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:custom1 CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:custom2 CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:custom3 CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:custom4 CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:custom5 CDATA #IMPLIED>
<!ATTLIST text:bibliography-mark text:isbn CDATA #IMPLIED>


<!ELEMENT text:bookmark EMPTY>
<!ATTLIST text:bookmark text:name CDATA #REQUIRED>

<!ELEMENT text:bookmark-start EMPTY>
<!ATTLIST text:bookmark-start text:name CDATA #REQUIRED>

<!ELEMENT text:bookmark-end EMPTY>
<!ATTLIST text:bookmark-end text:name CDATA #REQUIRED>

<!ELEMENT text:reference-mark EMPTY>
<!ATTLIST text:reference-mark text:name CDATA #REQUIRED>

<!ELEMENT text:reference-mark-start EMPTY>
<!ATTLIST text:reference-mark-start text:name CDATA #REQUIRED>

<!ELEMENT text:reference-mark-end EMPTY>
<!ATTLIST text:reference-mark-end text:name CDATA #REQUIRED>

<!ELEMENT text:footnotes-configuration (text:footnote-continuation-notice-forward?,text:footnote-continuation-notice-backward?)>
<!ATTLIST text:footnotes-configuration style:num-prefix %string; #IMPLIED>
<!ATTLIST text:footnotes-configuration style:num-suffix %string; #IMPLIED>
<!ATTLIST text:footnotes-configuration style:num-format %string; #IMPLIED>
<!ATTLIST text:footnotes-configuration style:num-letter-sync %string; #IMPLIED>
<!ATTLIST text:footnotes-configuration text:citation-body-style-name %styleName; #IMPLIED>
<!ATTLIST text:footnotes-configuration text:citation-style-name %styleName; #IMPLIED>
<!ATTLIST text:footnotes-configuration text:default-style-name  %styleName; #IMPLIED>
<!ATTLIST text:footnotes-configuration text:master-page-name %styleName; #IMPLIED>
<!ATTLIST text:footnotes-configuration text:start-value %integer; #IMPLIED>
<!ATTLIST text:footnotes-configuration text:footnotes-position (document|page) "page">
<!ATTLIST text:footnotes-configuration text:start-numbering-at (document|chapter|page) "document">

<!ELEMENT text:footnote-continuation-notice-forward (#PCDATA)> 
<!ELEMENT text:footnote-continuation-notice-backward (#PCDATA)>

<!ELEMENT text:endnotes-configuration EMPTY>
<!ATTLIST text:endnotes-configuration style:num-prefix %string; #IMPLIED>
<!ATTLIST text:endnotes-configuration style:num-suffix %string; #IMPLIED>
<!ATTLIST text:endnotes-configuration style:num-format %string; #IMPLIED>
<!ATTLIST text:endnotes-configuration style:num-letter-sync %string; #IMPLIED>
<!ATTLIST text:endnotes-configuration text:start-value %integer; #IMPLIED>
<!ATTLIST text:endnotes-configuration text:citation-style-name %styleName; #IMPLIED>
<!ATTLIST text:endnotes-configuration text:citation-body-style-name %styleName; #IMPLIED>
<!ATTLIST text:endnotes-configuration text:default-style-name %styleName; #IMPLIED>
<!ATTLIST text:endnotes-configuration text:master-page-name %styleName; #IMPLIED>

<!-- Validity constraint: text:footnote and text:endnote elements may not 
	contain other text:footnote or text:endnote elements, even though the DTD
	allows this (via the %text; in the foot-/endnote-body).
	Unfortunately, this constraint cannot be easily specified in the DTD.
-->
<!ELEMENT text:footnote (text:footnote-citation, text:footnote-body)>
<!ATTLIST text:footnote text:id ID #IMPLIED>

<!ELEMENT text:footnote-citation (#PCDATA)>
<!ATTLIST text:footnote-citation text:label %string; #IMPLIED>

<!ELEMENT text:footnote-body (text:h|text:p|
							  text:ordered-list|text:unordered-list)*>

<!ELEMENT text:endnote (text:endnote-citation, text:endnote-body)>
<!ATTLIST text:endnote text:id ID #IMPLIED>

<!ELEMENT text:endnote-citation (#PCDATA)>
<!ATTLIST text:endnote-citation text:label %string; #IMPLIED>

<!ELEMENT text:endnote-body (text:h|text:p|
							 text:ordered-list|text:unordered-list)*>

<!ENTITY % sectionAttr "text:name CDATA #REQUIRED
                        text:style-name %styleName; #IMPLIED
                        text:protected %boolean; 'false' ">


<!ELEMENT text:section ((text:section-source|office:dde-source)?,
						%sectionText;) >

<!ATTLIST text:section %sectionAttr;>
<!ATTLIST text:section text:display (true|none|condition) "true">
<!ATTLIST text:section text:condition %formula; #IMPLIED>
<!ATTLIST text:section text:protection-key CDATA #IMPLIED>
<!ATTLIST text:section text:is-hidden %boolean; #IMPLIED>

<!ELEMENT text:section-source EMPTY>
<!ATTLIST text:section-source xlink:href %string; #IMPLIED>
<!ATTLIST text:section-source xlink:type (simple) #FIXED "simple">
<!ATTLIST text:section-source xlink:show (embed) #FIXED "embed">
<!ATTLIST text:section-source text:section-name %string; #IMPLIED>
<!ATTLIST text:section-source text:filter-name %string; #IMPLIED>

<!ELEMENT text:table-of-content (text:table-of-content-source, 
								 text:index-body)   >
<!ATTLIST text:table-of-content %sectionAttr;>

<!ELEMENT text:table-of-content-source (text:index-title-template? , 
										text:table-of-content-entry-template*,
										text:index-source-styles* ) >
<!ATTLIST text:table-of-content-source text:outline-level %integer; #IMPLIED>
<!ATTLIST text:table-of-content-source text:use-outline-level %boolean; "true">
<!ATTLIST text:table-of-content-source text:use-index-marks %boolean; "true">
<!ATTLIST text:table-of-content-source text:use-index-source-styles 
															%boolean; "false">
<!ATTLIST text:table-of-content-source text:index-scope (document|chapter) 
														"document">
<!ATTLIST text:table-of-content-source text:relative-tab-stop-position 
															%boolean; "true">
<!ATTLIST text:table-of-content-source fo:language %string; #IMPLIED>
<!ATTLIST text:table-of-content-source fo:country %string; #IMPLIED>
<!ATTLIST text:table-of-content-source text:sort-algorithm %string; #IMPLIED>

<!ELEMENT text:table-of-content-entry-template (text:index-entry-chapter-number |
												text:index-entry-page-number |
												text:index-entry-text |
												text:index-entry-span |
												text:index-entry-tab-stop |
												text:index-entry-link-start |
												text:index-entry-link-end)* >
<!ATTLIST text:table-of-content-entry-template text:outline-level 
						%integer; #REQUIRED>
<!ATTLIST text:table-of-content-entry-template text:style-name 
						%styleName; #REQUIRED>

<!ELEMENT text:illustration-index 
			(text:illustration-index-source, text:index-body)>
<!ATTLIST text:illustration-index %sectionAttr;>

<!ELEMENT text:illustration-index-source (text:index-title-template?,
									text:illustration-index-entry-template?) >
<!ATTLIST text:illustration-index-source text:index-scope 
									(document|chapter) "document">
<!ATTLIST text:illustration-index-source text:relative-tab-stop-position 
									%boolean; "true">
<!ATTLIST text:illustration-index-source text:use-caption %boolean; "true">
<!ATTLIST text:illustration-index-source text:caption-sequence-name 
									%string; #IMPLIED>
<!ATTLIST text:illustration-index-source text:caption-sequence-format 
									(text|category-and-value|caption) "text">
<!ATTLIST text:illustration-index-source fo:language %string; #IMPLIED>
<!ATTLIST text:illustration-index-source fo:country %string; #IMPLIED>
<!ATTLIST text:illustration-index-source text:sort-algorithm %string; #IMPLIED>

<!ELEMENT text:illustration-index-entry-template 
								( text:index-entry-page-number |
								  text:index-entry-text |
								  text:index-entry-span |
								  text:index-entry-tab-stop )* >
<!ATTLIST text:illustration-index-entry-template text:style-name 
									%styleName; #REQUIRED>

<!ELEMENT text:table-index (text:table-index-source, text:index-body)>
<!ATTLIST text:table-index %sectionAttr;>

<!ELEMENT text:table-index-source (text:index-title-template?, 
									text:table-index-entry-template?) >
<!ATTLIST text:table-index-source text:index-scope 
									(document|chapter) "document">
<!ATTLIST text:table-index-source text:relative-tab-stop-position 
									%boolean; "true">
<!ATTLIST text:table-index-source text:use-caption %boolean; "true">
<!ATTLIST text:table-index-source text:caption-sequence-name 
									%string; #IMPLIED>
<!ATTLIST text:table-index-source text:caption-sequence-format 
									(text|category-and-value|caption) "text">
<!ATTLIST text:table-index-source fo:language %string; #IMPLIED>
<!ATTLIST text:table-index-source fo:country %string; #IMPLIED>
<!ATTLIST text:table-index-source text:sort-algorithm %string; #IMPLIED>

<!ELEMENT text:table-index-entry-template ( text:index-entry-page-number |
											text:index-entry-text |
											text:index-entry-span |
											text:index-entry-tab-stop )* >
<!ATTLIST text:table-index-entry-template text:style-name 
											%styleName; #REQUIRED>

<!ELEMENT text:object-index ( text:object-index-source, text:index-body ) >
<!ATTLIST text:object-index %sectionAttr;>

<!ELEMENT text:object-index-source ( text:index-title-template?,
									 text:object-index-entry-template? ) >
<!ATTLIST text:object-index-source text:index-scope 
									(document|chapter) "document">
<!ATTLIST text:object-index-source text:relative-tab-stop-position 
									%boolean; "true">
<!ATTLIST text:object-index-source text:use-spreadsheet-objects 
									%boolean; "false">
<!ATTLIST text:object-index-source text:use-draw-objects %boolean; "false">
<!ATTLIST text:object-index-source text:use-chart-objects %boolean; "false">
<!ATTLIST text:object-index-source text:use-other-objects %boolean; "false">
<!ATTLIST text:object-index-source text:use-math-objects %boolean; "false">
<!ATTLIST text:object-index-source fo:language %string; #IMPLIED>
<!ATTLIST text:object-index-source fo:country %string; #IMPLIED>
<!ATTLIST text:object-index-source text:sort-algorithm %string; #IMPLIED>

<!ELEMENT text:object-index-entry-template ( text:index-entry-page-number |
											 text:index-entry-text |
											 text:index-entry-span |
											 text:index-entry-tab-stop )* >
<!ATTLIST text:object-index-entry-template text:style-name 
											%styleName; #REQUIRED >

<!ELEMENT text:user-index (text:user-index-source, text:index-body) >
<!ATTLIST text:user-index %sectionAttr;>

<!ELEMENT text:user-index-source ( text:index-title-template?,
								   text:user-index-entry-template*,
								   text:index-source-styles* ) >
<!ATTLIST text:user-index-source text:index-scope 
									(document|chapter) "document">
<!ATTLIST text:user-index-source text:relative-tab-stop-position
									%boolean; "true">
<!ATTLIST text:user-index-source text:use-index-marks %boolean; "false">
<!ATTLIST text:user-index-source text:use-graphics %boolean; "false">
<!ATTLIST text:user-index-source text:use-tables %boolean; "false">
<!ATTLIST text:user-index-source text:use-floating-frames %boolean; "false">
<!ATTLIST text:user-index-source text:use-objects %boolean; "false">
<!ATTLIST text:user-index-source text:use-index-source-styles 
													%boolean; "false">
<!ATTLIST text:user-index-source text:copy-outline-levels %boolean; "false">
<!ATTLIST text:user-index-source fo:language %string; #IMPLIED>
<!ATTLIST text:user-index-source fo:country %string; #IMPLIED>
<!ATTLIST text:user-index-source text:sort-algorithm %string; #IMPLIED>
<!ATTLIST text:user-index-source text:index-name %string; #IMPLIED>

<!ELEMENT text:user-index-entry-template ( text:index-entry-chapter |
										   text:index-entry-page-number |
										   text:index-entry-text |
										   text:index-entry-span |
										   text:index-entry-tab-stop )* >
<!ATTLIST text:user-index-entry-template text:outline-level %integer; #REQUIRED>
<!ATTLIST text:user-index-entry-template text:style-name %styleName; #REQUIRED>

<!ELEMENT text:alphabetical-index (text:alphabetical-index-source, 
									text:index-body)>
<!ATTLIST text:alphabetical-index %sectionAttr;>

<!ELEMENT text:alphabetical-index-source ( text:index-title-template?, 
							text:alphabetical-index-entry-template* ) >
<!ATTLIST text:alphabetical-index-source text:index-scope 
												(document|chapter) "document">
<!ATTLIST text:alphabetical-index-source text:relative-tab-stop-position
												%boolean; "true">
<!ATTLIST text:alphabetical-index-source text:ignore-case %boolean; "false">
<!ATTLIST text:alphabetical-index-source text:main-entry-style-name 
												%styleName; #IMPLIED>
<!ATTLIST text:alphabetical-index-source text:alphabetical-separators 
												%boolean; "false">
<!ATTLIST text:alphabetical-index-source text:combine-entries
												%boolean; "true">
<!ATTLIST text:alphabetical-index-source text:combine-entries-with-dash
												%boolean; "false">
<!ATTLIST text:alphabetical-index-source text:combine-entries-with-pp
												%boolean; "true">
<!ATTLIST text:alphabetical-index-source text:use-keys-as-entries 
												%boolean; "false">
<!ATTLIST text:alphabetical-index-source text:capitalize-entries
												%boolean; "false">
<!ATTLIST text:alphabetical-index-source text:comma-separated
												%boolean; "false">
<!ATTLIST text:alphabetical-index-source fo:language %string; #IMPLIED>
<!ATTLIST text:alphabetical-index-source fo:country %string; #IMPLIED>
<!ATTLIST text:alphabetical-index-source text:sort-algorithm %string; #IMPLIED>

<!ELEMENT text:alphabetical-index-entry-template ( text:index-entry-chapter |
												text:index-entry-page-number |
												text:index-entry-text |
												text:index-entry-span |
												text:index-entry-tab-stop )* >
<!ATTLIST text:alphabetical-index-entry-template text:outline-level 
												(1|2|3|separator) #REQUIRED>
<!ATTLIST text:alphabetical-index-entry-template text:style-name 
												%styleName; #REQUIRED>

<!ELEMENT text:alphabetical-index-auto-mark-file EMPTY>
<!ATTLIST text:alphabetical-index-auto-mark-file xlink:href CDATA #IMPLIED>
<!ATTLIST text:alphabetical-index-auto-mark-file xlink:type (simple) #FIXED "simple">

<!ELEMENT text:bibliography (text:bibliography-source, text:index-body) >
<!ATTLIST text:bibliography %sectionAttr;>

<!ELEMENT text:bibliography-source ( text:index-title-template?,
									 text:bibliography-entry-template* ) >

<!ELEMENT text:bibliography-entry-template ( text:index-entry-span |
											 text:index-entry-tab-stop |
											 text:index-entry-bibliography )* >
<!ATTLIST text:bibliography-entry-template text:bibliography-type 
				( article | book | booklet | conference | custom1 | custom2 | 
				  custom3 | custom4 | custom5 | email | inbook | incollection |
				  inproceedings | journal | manual | mastersthesis | misc | 
				  phdthesis | proceedings | techreport | unpublished | www ) 
				#REQUIRED >
<!ATTLIST text:bibliography-entry-template text:style-name 
													%styleName; #REQUIRED>

<!ELEMENT text:index-body %sectionText; >

<!-- 
Validity constraint: text:index-title elements may appear only in
indices, and there may be only one text:index-title element.  
-->
<!ELEMENT text:index-title %sectionText; >
<!ATTLIST text:index-title text:style-name %styleName; #IMPLIED>
<!ATTLIST text:index-title text:name %string; #IMPLIED>

<!ELEMENT text:index-title-template (#PCDATA)>
<!ATTLIST text:index-title-template text:style-name %styleName; #IMPLIED>

<!ELEMENT text:index-entry-chapter-number EMPTY>
<!ATTLIST text:index-entry-chapter-number text:style-name %styleName; #IMPLIED>

<!ELEMENT text:index-entry-chapter EMPTY>
<!ATTLIST text:index-entry-chapter text:style-name %styleName; #IMPLIED>
<!ATTLIST text:index-entry-chapter text:display (name|number|number-and-name) 
															"number-and-name" >

<!ELEMENT text:index-entry-text EMPTY>
<!ATTLIST text:index-entry-text text:style-name %styleName; #IMPLIED>

<!ELEMENT text:index-entry-page-number EMPTY>
<!ATTLIST text:index-entry-page-number text:style-name %styleName; #IMPLIED>

<!ELEMENT text:index-entry-span (#PCDATA)>
<!ATTLIST text:index-entry-span text:style-name %styleName; #IMPLIED>

<!ELEMENT text:index-entry-bibliography EMPTY>
<!ATTLIST text:index-entry-bibliography text:style-name %styleName; #IMPLIED>
<!ATTLIST text:index-entry-bibliography text:bibliography-data-field
							( address | annote | author | bibliography-type |
							  booktitle | chapter | custom1 | custom2 | 
							  custom3 | custom4 | custom5 | edition | editor |
							  howpublished | identifier | institution | isbn |
							  journal | month | note | number | organizations |
							  pages | publisher | report-type | school | 
							  series | title | url | volume | year ) #REQUIRED>


<!ELEMENT text:index-entry-tab-stop EMPTY>
<!ATTLIST text:index-entry-tab-stop text:style-name %styleName; #IMPLIED>
<!ATTLIST text:index-entry-tab-stop style:leader-char %character; " ">
<!ATTLIST text:index-entry-tab-stop style:type (left|right) "left">
<!ATTLIST text:index-entry-tab-stop style:position %length; #IMPLIED>
<!ATTLIST text:index-entry-tab-stop style:with-tab %boolean; "true">

<!ELEMENT text:index-entry-link-start EMPTY>
<!ATTLIST text:index-entry-link-start text:style-name %styleName; #IMPLIED>

<!ELEMENT text:index-entry-link-end EMPTY>
<!ATTLIST text:index-entry-link-end text:style-name %styleName; #IMPLIED>

<!ELEMENT text:index-source-styles (text:index-source-style)*>
<!ATTLIST text:index-source-styles text:outline-level %integer; #REQUIRED>

<!ELEMENT text:index-source-style EMPTY>
<!ATTLIST text:index-source-style text:style-name %styleName; #REQUIRED>

<!ELEMENT text:toc-mark-start EMPTY>
<!ATTLIST text:toc-mark-start text:id %string; #REQUIRED>
<!ATTLIST text:toc-mark-start text:outline-level %integer; #IMPLIED>

<!ELEMENT text:toc-mark-end EMPTY>
<!ATTLIST text:toc-mark-end text:id %string; #REQUIRED>

<!ELEMENT text:toc-mark EMPTY>
<!ATTLIST text:toc-mark text:string-value %string; #REQUIRED>
<!ATTLIST text:toc-mark text:outline-level %integer; #IMPLIED>

<!ELEMENT text:user-index-mark-start EMPTY>
<!ATTLIST text:user-index-mark-start text:id %string; #REQUIRED>
<!ATTLIST text:user-index-mark-start text:outline-level %integer; #IMPLIED>
<!ATTLIST text:user-index-mark-start text:index-name %string; #IMPLIED>

<!ELEMENT text:user-index-mark-end EMPTY>
<!ATTLIST text:user-index-mark-end text:id %string; #REQUIRED>

<!ELEMENT text:user-index-mark EMPTY>
<!ATTLIST text:user-index-mark text:string-value %string; #REQUIRED>
<!ATTLIST text:user-index-mark text:outline-level %integer; #IMPLIED>
<!ATTLIST text:user-index-mark text:index-name %string; #IMPLIED>

<!ELEMENT text:alphabetical-index-mark-start EMPTY>
<!ATTLIST text:alphabetical-index-mark-start text:id %string; #REQUIRED>
<!ATTLIST text:alphabetical-index-mark-start text:key1 %string; #IMPLIED>
<!ATTLIST text:alphabetical-index-mark-start text:key2 %string; #IMPLIED>
<!ATTLIST text:alphabetical-index-mark-start text:main-etry %boolean; "false">

<!ELEMENT text:alphabetical-index-mark-end EMPTY>
<!ATTLIST text:alphabetical-index-mark-end text:id %string; #REQUIRED>

<!ELEMENT text:alphabetical-index-mark EMPTY>
<!ATTLIST text:alphabetical-index-mark text:string-value %string; #REQUIRED>
<!ATTLIST text:alphabetical-index-mark text:key1 %string; #IMPLIED>
<!ATTLIST text:alphabetical-index-mark text:key2 %string; #IMPLIED>
<!ATTLIST text:alphabetical-index-mark text:main-etry %boolean; "false">

<!ELEMENT text:bibliography-configuration (text:sort-key)*>
<!ATTLIST text:bibliography-configuration text:prefix %string; #IMPLIED>
<!ATTLIST text:bibliography-configuration text:suffix %string; #IMPLIED>
<!ATTLIST text:bibliography-configuration text:sort-by-position %boolean; "true">
<!ATTLIST text:bibliography-configuration text:numbered-entries %boolean; "false">
<!ATTLIST text:bibliography-configuration fo:language %string; #IMPLIED>
<!ATTLIST text:bibliography-configuration fo:country %string; #IMPLIED>
<!ATTLIST text:bibliography-configuration text:sort-algorithm %string; #IMPLIED>

<!ELEMENT text:sort-key EMPTY>
<!ATTLIST text:sort-key text:key ( address | annote | author | 
	bibliography-type | booktitle | chapter | custom1 | custom2 | 
	custom3 | custom4 | custom5 | edition | editor | howpublished | 
	identifier | institution | isbn | journal | month | note | number | 
	organizations | pages | publisher | report-type | school | series | 
	title | url | volume | year ) #REQUIRED>
<!ATTLIST text:sort-key text:sort-ascending %boolean; "true">

<!ELEMENT text:linenumbering-configuration (text:linenumbering-separator?)>
<!ATTLIST text:linenumbering-configuration text:style-name %styleName; #IMPLIED>
<!ATTLIST text:linenumbering-configuration text:number-lines %boolean; "true">
<!ATTLIST text:linenumbering-configuration text:count-empty-lines %boolean; "true">
<!ATTLIST text:linenumbering-configuration text:count-in-floating-frames %boolean; "false">
<!ATTLIST text:linenumbering-configuration text:restart-numbering %boolean; "false">
<!ATTLIST text:linenumbering-configuration text:offset %nonNegativeLength; #IMPLIED>
<!ATTLIST text:linenumbering-configuration style:num-format (1|a|A|i|I) "1">
<!ATTLIST text:linenumbering-configuration style:num-letter-sync %boolean; "false">
<!ATTLIST text:linenumbering-configuration text:number-position (left|right|inner|outer) "left">
<!ATTLIST text:linenumbering-configuration text:increment %nonNegativeInteger; #IMPLIED>

<!ELEMENT text:linenumbering-separator (#PCDATA)>
<!ATTLIST text:linenumbering-separator text:increment %nonNegativeInteger; #IMPLIED>

<!ELEMENT text:script (#PCDATA)>
<!ATTLIST text:script script:language CDATA #REQUIRED>
<!ATTLIST text:script xlink:href CDATA #IMPLIED>
<!ATTLIST text:script xlink:type (simple) #FIXED "simple">

<!ELEMENT text:measure (#PCDATA)>
<!ATTLIST text:measure text:kind (value|unit|gap) #REQUIRED>

<!ELEMENT text:ruby (text:ruby-base, text:ruby-text)>
<!ATTLIST text:ruby text:style-name %styleName; #IMPLIED>

<!ELEMENT text:ruby-base %inline-text;>

<!ELEMENT text:ruby-text (#PCDATA)>
<!ATTLIST text:ruby-text text:style-name %styleName; #IMPLIED>

<!-- elements for change tracking -->

<!ELEMENT text:change EMPTY>
<!ATTLIST text:change text:change-id CDATA #REQUIRED>

<!ELEMENT text:change-start EMPTY>
<!ATTLIST text:change-start text:change-id CDATA #REQUIRED>

<!ELEMENT text:change-end EMPTY>
<!ATTLIST text:change-end text:change-id CDATA #REQUIRED>

<!ELEMENT text:tracked-changes (text:changed-region)*>
<!ATTLIST text:tracked-changes text:track-changes %boolean; "true">
<!ATTLIST text:tracked-changes text:protection-key CDATA #IMPLIED>

<!ELEMENT text:changed-region (text:insertion | 
							   (text:deletion, text:insertion?) | 
                               text:format-change) >
<!ATTLIST text:changed-region text:id ID #REQUIRED>
<!ATTLIST text:changed-region text:merge-last-paragraph %boolean; "true">

<!ELEMENT text:insertion (office:change-info, %sectionText;)>
<!ELEMENT text:deletion (office:change-info, %sectionText;)>
<!ELEMENT text:format-change (office:change-info)>

