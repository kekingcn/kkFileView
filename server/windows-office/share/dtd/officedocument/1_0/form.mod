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

<!ENTITY % controls	"form:text|form:textarea|form:fixed-text|form:file|
					 form:password|form:formatted-text|form:button|form:image|
					 form:checkbox|form:radio|form:listbox|form:combobox|form:frame|
					 form:hidden|form:image-frame|form:grid|form:value-range|form:generic-control">

<!ENTITY % name "form:name CDATA #IMPLIED">
<!ENTITY % service-name "form:service-name CDATA #IMPLIED">

<!ENTITY % navigation "(none|current|parent)">
<!ENTITY % cycles "(records|current|page)">
<!ENTITY % url "CDATA">


<!ENTITY % types "(submit|reset|push|url)">
<!ENTITY % button-type "form:button-type %types; 'push'">
<!ENTITY % current-selected "form:current-selected %boolean; 'false'">
<!ENTITY % current-value "form:current-value CDATA #IMPLIED">
<!ENTITY % value "form:value CDATA #IMPLIED">
<!ENTITY % disabled "form:disabled %boolean; 'false'">
<!ENTITY % dropdown "form:dropdown %boolean; 'false'">
<!ENTITY % for "form:for CDATA #IMPLIED">
<!ENTITY % image-data "form:image-data %url; #IMPLIED">
<!ENTITY % label "form:label CDATA #IMPLIED">
<!ENTITY % max-length "form:max-length CDATA #IMPLIED">
<!ENTITY % printable "form:printable %boolean; 'true'">
<!ENTITY % readonly "form:readonly %boolean; 'false'">
<!ENTITY % size "form:size CDATA #IMPLIED">
<!ENTITY % selected "form:selected %boolean; 'false'">
<!ENTITY % size "form:size CDATA #IMPLIED">
<!ENTITY % tab-index "form:tab-index CDATA #IMPLIED">
<!ENTITY % target-frame "office:target-frame CDATA '_blank'">
<!ENTITY % target-location "xlink:href %url; #IMPLIED">
<!ENTITY % tab-stop "form:tab-stop %boolean; 'true'">
<!ENTITY % title "form:title CDATA #IMPLIED">
<!ENTITY % default-value "form:default-value CDATA #IMPLIED">
<!ENTITY % bound-column "form:bound-column CDATA #IMPLIED">
<!ENTITY % convert-empty "form:convert-empty-to-null  %boolean; 'false'">
<!ENTITY % data-field "form:data-field CDATA #IMPLIED">
<!ENTITY % linked-cell "form:linked-cell CDATA #IMPLIED">
<!ENTITY % visual-effect "form:visual-effect (flat|3d) #IMPLIED">
<!ENTITY % image-position "form:image-position (start|end|top|bottom|center) 'center'">
<!ENTITY % image-align "form:image-align (start|center|end) 'center'">
<!ENTITY % list-linkage-type "form:list-linkage-type (selection|selection-indexes) #IMPLIED">
<!ENTITY % source-cell-range "form:source-cell-range CDATA #IMPLIED">
<!ENTITY % list-source "form:list-source CDATA #IMPLIED">
<!ENTITY % list-source-types "(table|query|sql|sql-pass-through|value-list|table-fields)">
<!ENTITY % list-source-type "form:list-source-type %list-source-types; #IMPLIED">
<!ENTITY % column-style-name "form:column-style-name %styleName; #IMPLIED">
<!ENTITY % min-value "form:min-value %float; #IMPLIED">
<!ENTITY % max-value "form:max-value %float; #IMPLIED">
<!ENTITY % step-size "form:step-size %positiveInteger; '1'">
<!ENTITY % page-step-size "form:page-step-size %positiveInteger; #IMPLIED">
<!ENTITY % delay-for-repeat "form:delay-for-repeat %positiveInteger; #IMPLIED">
<!ENTITY % orientation "form:orientation (horizontal|vertical) #IMPLIED">




<!ELEMENT form:control (%controls;)+>
<!ATTLIST form:control %name;
                       %service-name;
                       %control-id;>

<!ELEMENT form:form (form:properties?, office:events?, (form:control|form:form)*)>
<!ATTLIST form:form %name; %service-name;>
<!ATTLIST form:form xlink:href %url; #IMPLIED>
<!ATTLIST form:form form:enctype CDATA "application/x-www-form-urlencoded">
<!ATTLIST form:form form:method CDATA "get">
<!ATTLIST form:form office:target-frame CDATA "_blank">
<!ATTLIST form:form form:allow-deletes %boolean; "true">
<!ATTLIST form:form form:allow-inserts %boolean; "true">
<!ATTLIST form:form form:allow-updates %boolean; "true">
<!ATTLIST form:form form:apply-filter %boolean; "false">
<!ATTLIST form:form form:command CDATA #IMPLIED>
<!ATTLIST form:form form:command-type (table|query|command) "command">
<!ATTLIST form:form form:datasource CDATA #IMPLIED>
<!ATTLIST form:form form:detail-fields CDATA #IMPLIED>
<!ATTLIST form:form form:escape-processing %boolean; "true">
<!ATTLIST form:form form:filter CDATA #IMPLIED>
<!ATTLIST form:form form:ignore-result %boolean; "false">
<!ATTLIST form:form form:master-fields CDATA #IMPLIED>
<!ATTLIST form:form form:navigation-mode %navigation; #IMPLIED>
<!ATTLIST form:form form:order CDATA #IMPLIED>
<!ATTLIST form:form form:tab-cycle %cycles; #IMPLIED>

<!ELEMENT office:forms (form:form*)>
<!ATTLIST office:forms form:automatic-focus %boolean; "false">
<!ATTLIST office:forms form:apply-design-mode %boolean; "true">

<!ELEMENT form:text (form:properties?, office:events?)>
<!ATTLIST form:text %current-value;
                    %disabled;
                    %max-length;
                    %printable;
                    %readonly;
                    %tab-index;
                    %tab-stop;
                    %title;
                    %value;
                    %convert-empty;
                    %data-field;
                    %linked-cell;>

<!ELEMENT form:textarea (form:properties?, office:events?, text:p*)>
<!ATTLIST form:textarea %current-value;
                        %disabled;
                        %max-length;
                        %printable;
                        %readonly;
                        %tab-index;
                        %tab-stop;
                        %title;
                        %value;
                        %convert-empty;
                        %data-field;
                        %linked-cell;>

<!ELEMENT form:password (form:properties?, office:events?)>
<!ATTLIST form:password %disabled;
                        %max-length;
                        %printable;
                        %tab-index;
                        %tab-stop;
                        %title;
                        %value;
						%convert-empty;
                        %linked-cell;>

<!ATTLIST form:password form:echo-char CDATA "*">

<!ELEMENT form:file (form:properties?, office:events?)>
<!ATTLIST form:file %current-value;
                    %disabled;
                    %max-length;
                    %printable;
                    %readonly;
                    %tab-index;
                    %tab-stop;
                    %title;
                    %value;>

<!ELEMENT form:formatted-text (form:properties?, office:events?)>
<!ATTLIST form:formatted-text %current-value;
                              %disabled;
                              %max-length;
                              %printable;
                              %readonly;
                              %tab-index;
                              %tab-stop;
                              %title;
                              %min-value;
                              %max-value;
                              %value;
                              %convert-empty;
                              %data-field;
                              %linked-cell;>
<!ATTLIST form:formatted-text form:validation %boolean; "false">

<!ELEMENT form:fixed-text (form:properties?, office:events?)>
<!ATTLIST form:fixed-text %for;
                          %disabled;
                          %label;
                          %printable;
                          %title;>
<!ATTLIST form:fixed-text form:multi-line %boolean; "false">

<!ELEMENT form:combobox (form:properties?, office:events?, form:item*)>
<!ATTLIST form:combobox %current-value;
                        %disabled;
                        %dropdown;
                        %max-length;
                        %printable;
                        %readonly;
                        %size;
                        %tab-index;
                        %tab-stop;
                        %title;
                        %value;
                        %convert-empty;
                        %data-field;
                        %list-source;
                        %list-source-type;
                        %linked-cell;
                        %source-cell-range;>

<!ATTLIST form:combobox form:auto-complete %boolean; #IMPLIED>

<!ELEMENT form:item (#PCDATA)>
<!ATTLIST form:item %label;>

<!ELEMENT form:listbox (form:properties?, office:events?, form:option*)>
<!ATTLIST form:listbox %disabled;
                       %dropdown;
                       %printable;
                       %size;
                       %tab-index;
                       %tab-stop;
                       %title;
                       %bound-column;
                       %data-field;
                       %list-source;
                       %list-source-type;
                       %linked-cell;
                       %list-linkage-type;
                       %source-cell-range;>

<!ATTLIST form:listbox form:multiple %boolean; "false">

<!ELEMENT form:option (#PCDATA)>
<!ATTLIST form:option %current-selected;
                      %selected;
                      %label;
                      %value;>

<!ELEMENT form:button (form:properties?, office:events?)>
<!ATTLIST form:button %button-type;
                      %disabled;
                      %label;
                      %image-data;
                      %printable;
                      %tab-index;
                      %tab-stop;
                      %target-frame;
                      %target-location;
                      %title;
                      %value;
                      %image-position;
                      %image-align;>

<!ATTLIST form:button form:default-button %boolean; "false"
                      form:toggle %boolean; "false"
                      form:focus-on-click %boolean; "true">

<!ELEMENT form:image (form:properties?, office:events?)>
<!ATTLIST form:image %button-type;
                     %disabled;
                     %image-data;
                     %printable;
                     %tab-index;
                     %tab-stop;
                     %target-frame;
                     %target-location;
                     %title;
                     %value;>

<!ELEMENT form:checkbox (form:properties?, office:events?)>
<!ATTLIST form:checkbox %disabled;
                        %label;
                        %printable;
                        %tab-index;
                        %tab-stop;
                        %title;
                        %value;
                        %data-field;
                        %linked-cell;
                        %visual-effect;
                        %image-position;
                        %image-align;>

<!ENTITY % states "(unchecked|checked|unknown)">
<!ATTLIST form:checkbox form:current-state %states; #IMPLIED>
<!ATTLIST form:checkbox form:is-tristate %boolean; "false">
<!ATTLIST form:checkbox form:state %states; "unchecked">

<!ELEMENT form:radio (form:properties?, office:events?)>
<!ATTLIST form:radio %current-selected;
                     %disabled;
                     %label;
                     %printable;
                     %selected;
                     %tab-index;
                     %tab-stop;
                     %title;
                     %value;
                     %data-field;
                     %linked-cell;
                     %visual-effect;
                     %image-position;
                     %image-align;>

<!ELEMENT form:frame (form:properties?, office:events?)>
<!ATTLIST form:frame %disabled;
                     %for;
                     %label;
                     %printable;
                     %title;>

<!ELEMENT form:image-frame (form:properties?, office:events?)>
<!ATTLIST form:image-frame %disabled;
                           %image-data;
                           %printable;
                           %readonly;
                           %title;
                           %data-field;>

<!ELEMENT form:hidden (form:properties?, office:events?)>
<!ATTLIST form:hidden %name;
                      %service-name;
                      %value;>

<!ELEMENT form:grid (form:properties?, office:events?, form:column*)>
<!ATTLIST form:grid %disabled;
                    %printable;
                    %tab-index;
                    %tab-stop;
                    %title;>

<!ENTITY % column-type "form:text| form:textarea| form:formatted-text|form:checkbox| form:listbox| form:combobox">
<!ELEMENT form:column (%column-type;)+>
<!ATTLIST form:column %name;
                      %service-name;
                      %label;
					  %column-style-name;>

<!ELEMENT form:generic-control (form:properties?, office:events?)>

<!ELEMENT form:value-range (form:properties?, office:events?)>
<!ATTLIST form:value-range %disabled;
                           %printable;
                           %tab-index;
                           %tab-stop;
                           %title;
                           %min-value;
                           %max-value;
                           %current-value;
                           %value;
                           %linked-cell;
                           %step-size;
                           %page-step-size;
                           %delay-for-repeat;
                           %orientation;>

<!ELEMENT form:properties (form:property+)>
<!ELEMENT form:property (form:property-value*)>
<!ATTLIST form:property form:property-is-list %boolean; #IMPLIED>
<!ATTLIST form:property form:property-name CDATA #REQUIRED>
<!ATTLIST form:property form:property-type (boolean|short|int|long|double|string)  #REQUIRED>
<!ELEMENT form:property-value (#PCDATA)>
<!ATTLIST form:property-value form:property-is-void %boolean; #IMPLIED>
