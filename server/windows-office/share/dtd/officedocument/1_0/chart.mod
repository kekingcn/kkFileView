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

<!ENTITY % chart-class "(line|area|circle|ring|scatter|radar|bar|stock|add-in)">
<!ENTITY % chart-solid-type "(cuboid|cylinder|cone|pyramid)">

<!-- Chart element -->
<!ELEMENT chart:chart ( chart:title?, chart:subtitle?, chart:legend?,
					    chart:plot-area,
						table:table? )>
<!ATTLIST chart:chart
		  chart:class %chart-class; #REQUIRED
		  chart:add-in-name %string; #IMPLIED
		  chart:table-number-list %string; #IMPLIED
		  draw:name %string; #IMPLIED
		  %draw-position;
		  %draw-size;
		  %draw-style-name;
		  chart:column-mapping %string; #IMPLIED
		  chart:row-mapping %string; #IMPLIED
		  chart:style-name %styleName; #IMPLIED>

<!ATTLIST chart:chart %presentation-class; >
<!ATTLIST chart:chart %zindex;>
<!ATTLIST chart:chart %draw-end-position; >
<!ATTLIST chart:chart draw:id %draw-shape-id; >
<!ATTLIST chart:chart draw:layer %layerName; #IMPLIED>

<!ATTLIST style:properties
		  chart:scale-text %boolean; "true"
		  chart:stock-updown-bars %boolean; "false"
		  chart:stock-with-volume %boolean; "false"
		  chart:three-dimensional %boolean; "false"
		  chart:deep %boolean; "false"
		  chart:lines %boolean; "false"
		  chart:percentage %boolean; "false"
		  chart:solid-type %chart-solid-type; "cuboid"
		  chart:splines %nonNegativeInteger; "0"
		  chart:stacked %boolean; "false"
		  chart:symbol %integer; "-1"
		  chart:vertical %boolean; "false"
		  chart:lines-used %nonNegativeInteger; "0"
		  chart:connect-bars %boolean; "false"
		  chart:spline-order %nonNegativeInteger; "2"
		  chart:spline-resolution %nonNegativeInteger; "20"
          chart:pie-offset %nonNegativeInteger; "0">

<!-- Main/Sub Title -->
<!-- the cell-address attribute is currently not supported for titles -->
<!ELEMENT chart:title (text:p)?>
<!ATTLIST chart:title
		  table:cell-range %cell-address; #IMPLIED
		  svg:x %coordinate; #IMPLIED
		  svg:y %coordinate; #IMPLIED
		  chart:style-name %styleName; #IMPLIED >

<!ELEMENT chart:subtitle (text:p)?>
<!ATTLIST chart:subtitle
		  table:cell-range %cell-address; #IMPLIED
		  svg:x %coordinate; #IMPLIED
		  svg:y %coordinate; #IMPLIED
		  chart:style-name %styleName; #IMPLIED >

<!-- you must specify either a legend-position or both, x and y coordinates -->
<!ELEMENT chart:legend EMPTY>
<!ATTLIST chart:legend
		  chart:legend-position (top|left|bottom|right) "right"
		  svg:x %coordinate; #IMPLIED
		  svg:y %coordinate; #IMPLIED
		  chart:style-name %styleName; #IMPLIED >

<!-- Plot-Area specification -->

<!ELEMENT chart:plot-area (dr3d:light*,
						   chart:axis*,
						   chart:categories?,
						   chart:series*,
						   chart:stock-gain-marker?,
						   chart:stock-loss-marker?,
						   chart:stock-range-line?,
						   chart:wall?,
						   chart:floor?) >

<!ATTLIST chart:plot-area
		  svg:x %coordinate; #IMPLIED
		  svg:y %coordinate; #IMPLIED
		  svg:width %length; #IMPLIED
		  svg:height %length; #IMPLIED
		  chart:style-name %styleName; #IMPLIED
		  table:cell-range-address %cell-range-address; #IMPLIED
		  chart:table-number-list %string; #IMPLIED
		  chart:data-source-has-labels (none|row|column|both) "none" >

<!-- 3d scene attributes on plot-area -->
<!ATTLIST chart:plot-area
		  dr3d:vrp %vector3D; #IMPLIED
		  dr3d:vpn %vector3D; #IMPLIED
		  dr3d:vup %vector3D; #IMPLIED
		  dr3d:projection (parallel|perspective) #IMPLIED
		  dr3d:transform CDATA #IMPLIED
		  dr3d:distance %length; #IMPLIED
		  dr3d:focal-length %length; #IMPLIED
		  dr3d:shadow-slant %nonNegativeInteger; #IMPLIED
		  dr3d:shade-mode (flat|phong|gouraud|draft) #IMPLIED
		  dr3d:ambient-color %color; #IMPLIED
		  dr3d:lighting-mode %boolean; #IMPLIED >

<!ATTLIST style:properties
		  chart:series-source (columns|rows) "columns" >

<!ELEMENT chart:wall EMPTY>
<!ATTLIST chart:wall
		  svg:width %length; #IMPLIED
		  chart:style-name %styleName; #IMPLIED >

<!ELEMENT chart:floor EMPTY>
<!ATTLIST chart:floor
		  svg:width %length; #IMPLIED
		  chart:style-name %styleName; #IMPLIED >

<!-- Stock chart elements -->

<!ELEMENT chart:stock-gain-marker EMPTY>
<!ATTLIST chart:stock-gain-marker
		  chart:style-name %styleName; #IMPLIED >

<!ELEMENT chart:stock-loss-marker EMPTY>
<!ATTLIST chart:stock-loss-marker
		  chart:style-name %styleName; #IMPLIED >

<!ELEMENT chart:stock-range-line EMPTY>
<!ATTLIST chart:stock-range-line
		  chart:style-name %styleName; #IMPLIED >

<!-- Axis -->

<!ELEMENT chart:axis (chart:title?, chart:grid*)>
<!ATTLIST chart:axis
		  chart:class (category|value|series|domain) #REQUIRED
		  chart:name %string; #IMPLIED
		  chart:style-name %styleName; #IMPLIED >

<!ATTLIST style:properties
		  chart:tick-marks-major-inner %boolean; "false"
		  chart:tick-marks-major-outer %boolean; "true"
		  chart:tick-marks-minor-inner %boolean; "false"
		  chart:tick-marks-minor-outer %boolean; "false"
		  chart:logarithmic %boolean; "false"
		  chart:maximum %float; #IMPLIED
		  chart:minimum %float; #IMPLIED
		  chart:origin %float; #IMPLIED
		  chart:interval-major %float; #IMPLIED
		  chart:interval-minor %float; #IMPLIED
		  chart:gap-width %integer; #IMPLIED
		  chart:overlap %integer; #IMPLIED
		  text:line-break %boolean; "true"
		  chart:display-label %boolean; "true"
		  chart:label-arrangement (side-by-side|stagger-even|stagger-odd) "side-by-side"
		  chart:text-overlap %boolean; "false"
		  chart:visible %boolean; "true" 
		  chart:link-data-style-to-source %boolean; "true" >

<!ELEMENT chart:grid EMPTY>
<!ATTLIST chart:grid
		  chart:class (major|minor) "major"
		  chart:style-name %styleName; #IMPLIED >


<!ELEMENT chart:categories EMPTY>
<!ATTLIST chart:categories
		  table:cell-range-address %cell-range-address; #IMPLIED >

<!--
	each series element must have a cell-range-address element that points
	to the underlying table data.
	Impl. Note: Internally all href elements are merged to one table range
	that represents the data for the whole chart
-->
<!ELEMENT chart:series ( chart:domain*,
                         chart:mean-value?,
						 chart:regression-curve?,
						 chart:error-indicator?,
						 chart:data-point* )>
<!ATTLIST chart:series
		  chart:values-cell-range-address %cell-range-address; #IMPLIED
		  chart:label-cell-address %cell-address; #IMPLIED
		  chart:class %chart-class; #IMPLIED
		  chart:attached-axis %string; #IMPLIED
		  chart:style-name %styleName; #IMPLIED >

<!ELEMENT chart:domain EMPTY>
<!ATTLIST chart:domain
		  table:cell-range-address %cell-range-address; #IMPLIED >

<!ELEMENT chart:data-point EMPTY>
<!ATTLIST chart:data-point
		  chart:repeated %nonNegativeInteger; #IMPLIED
		  chart:style-name %styleName; #IMPLIED >

<!-- statistical properties -->

<!ELEMENT chart:mean-value EMPTY>
<!ELEMENT chart:regression-curve EMPTY >
<!ELEMENT chart:error-indicator EMPTY >
<!ATTLIST chart:mean-value chart:style-name %styleName; #IMPLIED >
<!ATTLIST chart:regression-curve chart:style-name %styleName; #IMPLIED >
<!ATTLIST chart:error-indicator chart:style-name %styleName; #IMPLIED >

<!ATTLIST style:properties
		  chart:mean-value %boolean; #IMPLIED
		  chart:error-category (none|variance|standard-deviation|percentage|error-margin|constant) "none"
		  chart:error-percentage %float; #IMPLIED
		  chart:error-margin %float; #IMPLIED
		  chart:error-lower-limit %float; #IMPLIED
		  chart:error-upper-limit %float; #IMPLIED
		  chart:error-upper-indicator %boolean; #IMPLIED
		  chart:error-lower-indicator %boolean; #IMPLIED
		  chart:regression-type (none|linear|logarithmic|exponential|power) "none" >

<!-- data label properties -->

<!ATTLIST style:properties
		  chart:data-label-number (none|value|percentage) "none"
		  chart:data-label-text %boolean; "false"
		  chart:data-label-symbol %boolean; "false" >

<!-- general text properties -->

<!ATTLIST style:properties 
		  text:rotation-angle %integer; "0" >

<!-- symbol properties -->

<!ATTLIST style:properties
		  chart:symbol-width %nonNegativeLength; #IMPLIED
		  chart:symbol-height %nonNegativeLength; #IMPLIED
		  chart:symbol-image-name %string; #IMPLIED >
