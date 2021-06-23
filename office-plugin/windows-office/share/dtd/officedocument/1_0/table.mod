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

<!ELEMENT table:calculation-settings (table:null-date?, table:iteration?)>
<!ATTLIST table:calculation-settings
	table:case-sensitive %boolean; "true"
	table:precision-as-shown %boolean; "false"
	table:search-criteria-must-apply-to-whole-cell %boolean; "true"
	table:automatic-find-labels %boolean; "true"
	table:use-regular-expressions %boolean; "true"
	table:null-year %positiveInteger; "1930"
>
<!ELEMENT table:null-date EMPTY>
<!ATTLIST table:null-date
	table:value-type %valueType; #FIXED "date"
	table:date-value %date; "1899-12-30"
>
<!ELEMENT table:iteration EMPTY>
<!ATTLIST table:iteration
	table:status (enable | disable) "disable"
	table:steps %positiveInteger; "100"
	table:maximum-difference %float; "0.001"
>

<!ELEMENT table:tracked-changes (table:cell-content-change | table:insertion | table:deletion | table:movement | table:rejection)*>
<!ATTLIST table:tracked-changes table:track-changes %boolean; "true"
				table:protected %boolean; "false"
				table:protection-key CDATA #IMPLIED
>

<!ELEMENT table:dependences (table:dependence)+>
<!ELEMENT table:dependence EMPTY>
<!ATTLIST table:dependence
	table:id CDATA #REQUIRED
>
<!ELEMENT table:deletions (table:cell-content-deletion | table:change-deletion)+>
<!ELEMENT table:cell-content-deletion (table:cell-address?, table:change-track-table-cell?)>
<!ATTLIST table:cell-content-deletion
	table:id CDATA #IMPLIED
>
<!ELEMENT table:change-deletion EMPTY>
<!ATTLIST table:change-deletion
	table:id CDATA #IMPLIED
>
<!ELEMENT table:insertion (office:change-info, table:dependences?, table:deletions?)>
<!ATTLIST table:insertion
	table:id CDATA #REQUIRED
	table:acceptance-state (accepted | rejected | pending) "pending"
	table:rejecting-change-id %positiveInteger; #IMPLIED
	table:type (row | column | table) #REQUIRED
	table:position %integer; #REQUIRED
	table:count %positiveInteger; "1"
	table:table %integer; #IMPLIED
>
<!ELEMENT table:deletion (office:change-info, table:dependences?, table:deletions?, table:cut-offs?)>
<!ATTLIST table:deletion
	table:id CDATA #REQUIRED
	table:acceptance-state (accepted | rejected | pending) "pending"
	table:rejecting-change-id %positiveInteger; #IMPLIED
	table:type (row | column | table) #REQUIRED
	table:position %integer; #REQUIRED
	table:count %positiveInteger; "1"
	table:table %integer; #IMPLIED
	table:multi-deletion-spanned %integer; #IMPLIED
>
<!ELEMENT table:cut-offs (table:movement-cut-off+ | (table:insertion-cut-off, table:movement-cut-off*))>
<!ELEMENT table:insertion-cut-off EMPTY>
<!ATTLIST table:insertion-cut-off
	table:id CDATA #REQUIRED
	table:position %integer; #REQUIRED
>
<!ELEMENT table:movement-cut-off EMPTY>
<!ATTLIST table:movement-cut-off
	table:id CDATA #REQUIRED
	table:start-position %integer; #IMPLIED
	table:end-position %integer; #IMPLIED
	table:position %integer; #IMPLIED
>
<!ELEMENT table:movement (table:source-range-address, table:target-range-address, office:change-info, table:dependences?, table:deletions?)>
<!ATTLIST table:movement
	table:id CDATA #REQUIRED
	table:acceptance-state (accepted | rejected | pending) "pending"
	table:rejecting-change-id %positiveInteger; #IMPLIED
>
<!ELEMENT table:target-range-address EMPTY>
<!ATTLIST table:target-range-address
	table:column %integer; #IMPLIED
	table:row %integer; #IMPLIED
	table:table %integer; #IMPLIED
	table:start-column %integer; #IMPLIED
	table:start-row %integer; #IMPLIED
	table:start-table %integer; #IMPLIED
	table:end-column %integer; #IMPLIED
	table:end-row %integer; #IMPLIED
	table:end-table %integer; #IMPLIED
>
<!ELEMENT table:source-range-address EMPTY>
<!ATTLIST table:source-range-address
	table:column %integer; #IMPLIED
	table:row %integer; #IMPLIED
	table:table %integer; #IMPLIED
	table:start-column %integer; #IMPLIED
	table:start-row %integer; #IMPLIED
	table:start-table %integer; #IMPLIED
	table:end-column %integer; #IMPLIED
	table:end-row %integer; #IMPLIED
	table:end-table %integer; #IMPLIED
>
<!ELEMENT table:change-track-table-cell (text:p*)>
<!ATTLIST table:change-track-table-cell
	table:cell-address %cell-address; #IMPLIED
	table:matrix-covered (true | false) "false"
	table:formula %string; #IMPLIED
	table:number-matrix-rows-spanned %positiveInteger; #IMPLIED
	table:number-matrix-columns-spanned %positiveInteger; #IMPLIED
	table:value-type %valueType; "string"
	table:value %float; #IMPLIED
	table:date-value %date; #IMPLIED
	table:time-value %timeInstance; #IMPLIED
	table:string-value %string; #IMPLIED
>
<!ELEMENT table:cell-content-change (table:cell-address, office:change-info, table:dependences?, table:deletions?, table:previous)>
<!ATTLIST table:cell-content-change
	table:id CDATA #REQUIRED
	table:acceptance-state (accepted | rejected | pending) "pending"
	table:rejecting-change-id %positiveInteger; #IMPLIED
>
<!ELEMENT table:cell-address EMPTY>
<!ATTLIST table:cell-address
	table:column %integer; #IMPLIED
	table:row %integer; #IMPLIED
	table:table %integer; #IMPLIED
>
<!ELEMENT table:previous (table:change-track-table-cell)>
<!ATTLIST table:previous
	table:id CDATA #IMPLIED
>
<!ELEMENT table:rejection (office:change-info, table:dependences?, table:deletions?)>
<!ATTLIST table:rejection
	table:id CDATA #REQUIRED
	table:acceptance-state (accepted | rejected | pending) "pending"
	table:rejecting-change-id %positiveInteger; #IMPLIED
>

<!ENTITY % table-columns "table:table-columns | ( table:table-column | table:table-column-group )+">
<!ENTITY % table-header-columns "table:table-header-columns">
<!ENTITY % table-rows "table:table-rows | ( table:table-row | table:table-row-group )+">
<!ENTITY % table-header-rows "table:table-header-rows">
<!ENTITY % table-column-groups "((%table-columns;),(%table-header-columns;,(%table-columns;)?)?) | (%table-header-columns;,(%table-columns;)?)">
<!ENTITY % table-row-groups "((%table-rows;),(%table-header-rows;,(%table-rows;)?)?) | (%table-header-rows;,(%table-rows;)?)">
<!ELEMENT table:table (table:table-source?, table:scenario?, office:forms?, table:shapes?, (%table-column-groups;), (%table-row-groups;))>
<!ATTLIST table:table
	table:name %string; #IMPLIED
	table:style-name %styleName; #IMPLIED
	table:protected %boolean; "false"
	table:protection-key CDATA #IMPLIED
	table:print-ranges %cell-range-address-list; #IMPLIED
	table:automatic-print-range %boolean; #IMPLIED
>
<!ELEMENT table:table-source EMPTY>
<!ATTLIST table:table-source
	table:mode (copy-all | copy-results-only) "copy-all"
	xlink:type (simple) #FIXED "simple"
	xlink:actuate (onRequest) "onRequest"
	xlink:href %uriReference; #REQUIRED
	table:filter-name CDATA #IMPLIED
	table:table-name CDATA #IMPLIED
	table:filter-options CDATA #IMPLIED
	table:refresh-delay %timeDuration; #IMPLIED
>
<!ELEMENT table:scenario EMPTY>
<!ATTLIST table:scenario
	table:display-border %boolean; "true"
	table:border-color %color; #IMPLIED
	table:copy-back %boolean; "true"
	table:copy-styles %boolean; "true"
	table:copy-formulas %boolean; "true"
	table:is-active %boolean; #REQUIRED
	table:scenario-ranges %cell-range-address-list; #REQUIRED
	table:comment CDATA #IMPLIED
>
<!ELEMENT table:shapes %shapes;>
<!ELEMENT table:table-column-group (table:table-header-columns | table:table-column | table:table-column-group)+>
<!ATTLIST table:table-column-group
	table:display %boolean; "true"
>
<!ELEMENT table:table-header-columns (table:table-column | table:table-column-group)+>
<!ELEMENT table:table-columns (table:table-column | table:table-column-group)+>
<!ELEMENT table:table-column EMPTY>
<!ATTLIST table:table-column
	table:number-columns-repeated %positiveInteger; "1"
	table:style-name %styleName; #IMPLIED
	table:visibility (visible | collapse | filter) "visible"
	table:default-cell-style-name %styleName; #IMPLIED
>
<!ELEMENT table:table-row-group (table:table-header-rows | table:table-row | table:table-row-group)+>
<!ATTLIST table:table-row-group
	table:display %boolean; "true"
>
<!ELEMENT table:table-header-rows (table:table-row | table:table-row-group)+>
<!ELEMENT table:table-rows (table:table-row | table:table-row-group)+>
<!ENTITY % table-cells "(table:table-cell|table:covered-table-cell)+">
<!ELEMENT table:table-row %table-cells;>
<!ATTLIST table:table-row
	table:number-rows-repeated %positiveInteger; "1"
	table:style-name %styleName; #IMPLIED
	table:visibility (visible | collapse | filter) "visible"
	table:default-cell-style-name %styleName; #IMPLIED
>

<!ENTITY % text-wo-table "(text:h|text:p|text:ordered-list|text:unordered-list|%shapes;)*">
<!ENTITY % cell-content "(table:cell-range-source?,office:annotation?,table:detective?,(table:sub-table|%text-wo-table;))">
<!ELEMENT table:table-cell %cell-content;>
<!ELEMENT table:covered-table-cell %cell-content;>
<!ATTLIST table:table-cell
	table:number-columns-repeated %positiveInteger; "1"
	table:number-rows-spanned %positiveInteger; "1"
	table:number-columns-spanned %positiveInteger; "1"
	table:style-name %styleName; #IMPLIED
	table:validation-name CDATA #IMPLIED
	table:formula %string; #IMPLIED
	table:number-matrix-rows-spanned %positiveInteger; #IMPLIED
	table:number-matrix-columns-spanned %positiveInteger; #IMPLIED
	table:value-type %valueType; "string"
	table:value %float; #IMPLIED
	table:date-value %date; #IMPLIED
	table:time-value %timeInstance; #IMPLIED
	table:boolean-value %boolean; #IMPLIED
	table:string-value %string; #IMPLIED
	table:currency %string; #IMPLIED
>
<!ATTLIST table:covered-table-cell
	table:number-columns-repeated %positiveInteger; "1"
	table:style-name %styleName; #IMPLIED
	table:validation-name CDATA #IMPLIED
	table:formula %string; #IMPLIED
	table:number-matrix-rows-spanned %positiveInteger; #IMPLIED
	table:number-matrix-columns-spanned %positiveInteger; #IMPLIED
	table:value-type %valueType; "string"
	table:value %float; #IMPLIED
	table:date-value %date; #IMPLIED
	table:time-value %timeInstance; #IMPLIED
	table:boolean-value %boolean; #IMPLIED
	table:string-value %string; #IMPLIED
	table:currency %string; #IMPLIED
>
<!-- cell protection in writer: cell attribute; calc uses format -->
<!ATTLIST table:table-cell table:protected %boolean; "false">

<!ELEMENT table:cell-range-source EMPTY>
<!ATTLIST table:cell-range-source
	table:name %string; #REQUIRED
	xlink:type (simple) #FIXED "simple"
	xlink:actuate (onRequest) #FIXED "onRequest"
	xlink:href %uriReference; #REQUIRED
	table:filter-name %string; #REQUIRED
	table:filter-options %string; #IMPLIED
	table:last-column-spanned %positiveInteger; #REQUIRED
	table:last-row-spanned %positiveInteger; #REQUIRED
	table:refresh-delay %timeDuration; #IMPLIED
>

<!ELEMENT table:detective (table:highlighted-range*, table:operation*)>
<!ELEMENT table:highlighted-range EMPTY>
<!ATTLIST table:highlighted-range
	table:cell-range-address %cell-range-address; #IMPLIED
	table:direction (from-another-table | to-another-table | from-same-table | to-same-table) #IMPLIED
	table:contains-error %boolean; #IMPLIED
	table:marked-invalid %boolean; #IMPLIED
>
<!ELEMENT table:operation EMPTY>
<!ATTLIST table:operation
	table:name (trace-dependents | remove-dependents | trace-precedents | remove-precedents | trace-errors) #REQUIRED
	table:index %nonNegativeInteger; #REQUIRED
>

<!ELEMENT table:content-validations (table:content-validation)+>
<!ELEMENT table:content-validation (table:help-message?, (table:error-message | (table:error-macro, office:events?))?)>
<!ATTLIST table:content-validation
	table:name CDATA #REQUIRED
	table:condition CDATA #IMPLIED
	table:base-cell-address %cell-address; #IMPLIED
	table:allow-empty-cell %boolean; #IMPLIED
	table:show-list (no | unsorted | sorted-ascending) #IMPLIED
>
<!ELEMENT table:help-message (text:p*)>
<!ATTLIST table:help-message
	table:title CDATA #IMPLIED
	table:display %boolean; #IMPLIED
>
<!ELEMENT table:error-message (text:p*)>
<!ATTLIST table:error-message
	table:title CDATA #IMPLIED
	table:message-type (stop | warning | information) #IMPLIED
	table:display %boolean; #IMPLIED
>
<!ELEMENT table:error-macro EMPTY>
<!ATTLIST table:error-macro
	table:name CDATA #IMPLIED
	table:execute %boolean; #IMPLIED
>

<!ELEMENT table:sub-table ((%table-column-groups;) , (%table-row-groups;))>

<!ELEMENT table:label-ranges (table:label-range)*>
<!ELEMENT table:label-range EMPTY>
<!ATTLIST table:label-range
	table:label-cell-range-address %cell-range-address; #REQUIRED
	table:data-cell-range-address %cell-range-address; #REQUIRED
	table:orientation (column | row) #REQUIRED
>

<!ELEMENT table:named-expressions (table:named-range | table:named-expression)*>
<!ELEMENT table:named-range EMPTY>
<!ATTLIST table:named-range
	table:name CDATA #REQUIRED
	table:cell-range-address %cell-range-address; #REQUIRED
	table:base-cell-address %cell-address; #IMPLIED
	table:range-usable-as CDATA "none"
>
<!ELEMENT table:named-expression EMPTY>
<!ATTLIST table:named-expression
	table:name CDATA #REQUIRED
	table:expression CDATA #REQUIRED
	table:base-cell-address %cell-address; #IMPLIED
>

<!ELEMENT table:filter (table:filter-condition | table:filter-and | table:filter-or)>
<!ATTLIST table:filter
	table:target-range-address %cell-range-address; #IMPLIED
	table:condition-source-range-address %cell-range-address; #IMPLIED
	table:condition-source (self | cell-range) "self"
	table:display-duplicates %boolean; "true"
>
<!ELEMENT table:filter-and (table:filter-or | table:filter-condition)+>
<!ELEMENT table:filter-or (table:filter-and | table:filter-condition)+>
<!ELEMENT table:filter-condition EMPTY>
<!ATTLIST table:filter-condition
	table:field-number %nonNegativeInteger; #REQUIRED
	table:case-sensitive %boolean; "false"
	table:data-type (text | number) "text"
	table:value CDATA #REQUIRED
	table:operator CDATA #REQUIRED
>

<!ELEMENT table:database-ranges (table:database-range)*>
<!ELEMENT table:database-range ((table:database-source-sql | table:database-source-table | table:database-source-query)?, table:filter?, table:sort?, table:subtotal-rules?)>
<!ATTLIST table:database-range
	table:name CDATA #IMPLIED
	table:is-selection %boolean; "false"
	table:on-update-keep-styles %boolean; "false"
	table:on-update-keep-size %boolean; "true"
	table:has-persistent-data %boolean; "true"
	table:orientation (row | column) "row"
	table:contains-header %boolean; "true"
	table:display-filter-buttons %boolean; "false"
	table:target-range-address %cell-range-address; #REQUIRED
	table:refresh-delay %timeDuration; #IMPLIED
>
<!ELEMENT table:database-source-sql EMPTY>
<!ATTLIST table:database-source-sql
	table:database-name CDATA #REQUIRED
	table:sql-statement CDATA #REQUIRED
	table:parse-sql-statements %boolean; "false"
>
<!ELEMENT table:database-source-table EMPTY>
<!ATTLIST table:database-source-table
	table:database-name CDATA #REQUIRED
	table:table-name CDATA #REQUIRED
>
<!ELEMENT table:database-source-query EMPTY>
<!ATTLIST table:database-source-query
	table:database-name CDATA #REQUIRED
	table:query-name CDATA #REQUIRED
>

<!ELEMENT table:sort (table:sort-by)+>
<!ATTLIST table:sort
	table:bind-styles-to-content %boolean; "true"
	table:target-range-address %cell-range-address; #IMPLIED
	table:case-sensitive %boolean; "false"
	table:language CDATA #IMPLIED
	table:country CDATA #IMPLIED
	table:algorithm CDATA #IMPLIED
>
<!ELEMENT table:sort-by EMPTY>
<!ATTLIST table:sort-by
	table:field-number %nonNegativeInteger; #REQUIRED
	table:data-type CDATA "automatic"
	table:order (ascending | descending) "ascending"
>

<!ELEMENT table:subtotal-rules (table:sort-groups? | table:subtotal-rule*)?>
<!ATTLIST table:subtotal-rules
	table:bind-styles-to-content %boolean; "true"
	table:case-sensitive %boolean; "false"
	table:page-breaks-on-group-change %boolean; "false"
>
<!ELEMENT table:sort-groups EMPTY>
<!ATTLIST table:sort-groups
	table:data-type CDATA "automatic"
	table:order (ascending | descending) "ascending"
>
<!ELEMENT table:subtotal-rule (table:subtotal-field)*>
<!ATTLIST table:subtotal-rule
	table:group-by-field-number %nonNegativeInteger; #REQUIRED
>
<!ELEMENT table:subtotal-field EMPTY>
<!ATTLIST table:subtotal-field
	table:field-number %nonNegativeInteger; #REQUIRED
	table:function CDATA #REQUIRED
>

<!ELEMENT table:data-pilot-tables (table:data-pilot-table)*>
<!ELEMENT table:data-pilot-table ((table:database-source-sql | table:database-source-table | table:database-source-query | table:source-service | table:source-cell-range)?, table:data-pilot-field+)>
<!ATTLIST table:data-pilot-table
	table:name CDATA #REQUIRED
	table:application-data CDATA #IMPLIED
	table:grand-total (none | row | column | both) "both"
	table:ignore-empty-rows %boolean; "false"
	table:identify-categories %boolean; "false"
	table:target-range-address %cell-range-address; #REQUIRED
	table:buttons %cell-range-address-list; #REQUIRED
>
<!ELEMENT table:source-service EMPTY>
<!ATTLIST table:source-service
	table:name CDATA #REQUIRED
	table:source-name CDATA #REQUIRED
	table:object-name CDATA #REQUIRED
	table:username CDATA #IMPLIED
	table:password CDATA #IMPLIED
>
<!ELEMENT table:source-cell-range (table:filter)?>
<!ATTLIST table:source-cell-range
	table:cell-range-address %cell-range-address; #REQUIRED
>
<!ELEMENT table:data-pilot-field (table:data-pilot-level)?>
<!ATTLIST table:data-pilot-field
	table:source-field-name CDATA #REQUIRED
	table:is-data-layout-field %boolean; "false"
	table:function CDATA #REQUIRED
	table:orientation (row | column | data | page | hidden) #REQUIRED
	table:used-hierarchy %positiveInteger; "1"
>
<!ELEMENT table:data-pilot-level (table:data-pilot-subtotals?, table:data-pilot-members?)>
<!ATTLIST table:data-pilot-level
	table:display-empty %boolean; #IMPLIED
>
<!ELEMENT table:data-pilot-subtotals (table:data-pilot-subtotal)*>
<!ELEMENT table:data-pilot-subtotal EMPTY>
<!ATTLIST table:data-pilot-subtotal
	table:function CDATA #REQUIRED
>
<!ELEMENT table:data-pilot-members (table:data-pilot-member)*>
<!ELEMENT table:data-pilot-member EMPTY>
<!ATTLIST table:data-pilot-member
	table:name CDATA #REQUIRED
	table:display %boolean; #IMPLIED
	table:display-details %boolean; #IMPLIED
>

<!ELEMENT table:consolidation EMPTY>
<!ATTLIST table:consolidation
	table:function CDATA #REQUIRED
	table:source-cell-range-addresses %cell-range-address-list; #REQUIRED
	table:target-cell-address %cell-address; #REQUIRED
	table:use-label (none | column | row | both) "none"
	table:link-to-source-data %boolean; "false"
>

<!ELEMENT table:dde-links (table:dde-link)+>
<!ELEMENT table:dde-link (office:dde-source, table:table)>
