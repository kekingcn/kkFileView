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

<!-- datatypes corresponding to XML Schema Part 2 W3C Working draft of	-->
<!-- 07 April 2000														-->

<!-- string -->
<!ENTITY % string				"CDATA">
<!ENTITY % cString				"#PCDATA">

<!-- boolean (values are "true" and "false" -->
<!ENTITY % boolean				"CDATA">

<!-- integer ( ..., -2, -1, 0, 1, 2, ...) -->
<!ENTITY % integer				"CDATA">

<!-- non negative integer ( 0, 1, 2, ...) -->
<!ENTITY % nonNegativeInteger	"CDATA">

<!-- positive integer ( 1, 2, ...) -->
<!ENTITY % positiveInteger		"CDATA">
<!ENTITY % cPositiveInteger		"#PCDATA">

<!ENTITY % positiveNumberOrDefault "CDATA">

<!-- time duration as specified by ISO8601, section 5.5.3.2 -->
<!ENTITY % timeDuration			"CDATA">
<!ENTITY % cTimeDuration		"#PCDATA">

<!-- time instance as specified by ISO8601, section 5.4 -->
<!ENTITY % timeInstance			"CDATA">
<!ENTITY % cTimeInstance		"#PCDATA">

<!-- date instance as specified by ISO8601, section 5.2.1.1, extended format-->
<!ENTITY % date					"CDATA">
<!ENTITY % cDate				"#PCDATA">

<!-- date duration, like timDuration but truncated to full dates -->
<!ENTITY % dateDuration			"CDATA">
<!ENTITY % cDateDuration		"#PCDATA">

<!-- URI reference -->
<!ENTITY % uriReference			"CDATA">

<!-- language code as specified by RFC1766 -->
<!ENTITY % language				"CDATA">
<!ENTITY % cLanguage			"#PCDATA">

<!-- float -->
<!ENTITY % float "CDATA">

<!-- Some other common used data types -->

<!-- a single UNICODE character -->
<!ENTITY % character			"CDATA">

<!-- a style name -->
<!ENTITY % styleName			"CDATA">

<!-- a target frame name -->
<!ENTITY % targetFrameName			"CDATA">

<!-- a language without a country as specified by ISO639 -->
<!ENTITY % languageOnly			"CDATA">

<!-- a country as specified by ISO3166 -->
<!ENTITY % country				"CDATA">

<!-- a color value having the format #rrggbb -->
<!ENTITY % color				"CDATA">
<!-- a color value having the format #rrggbb or "transparent" -->
<!ENTITY % transparentOrColor			"CDATA">

<!-- a percentage -->
<!ENTITY % percentage 			"CDATA">

<!-- a length (i.e. 1cm or .6inch) -->
<!ENTITY % length				"CDATA">
<!ENTITY % positiveLength		"CDATA">
<!ENTITY % nonNegativeLength	"CDATA">
<!ENTITY % lengthOrNoLimit "CDATA">

<!-- a length or a percentage -->
<!ENTITY % lengthOrPercentage	"CDATA">
<!ENTITY % positiveLengthOrPercentage	"CDATA">

<!-- a pixel length (i.e. 2px) -->
<!ENTITY % nonNegativePixelLength	"CDATA">

<!-- a float or a percentage -->
<!ENTITY % floatOrPercentage	"CDATA">

<!-- a text encoding -->
<!ENTITY % textEncoding	"CDATA">

<!-- cell address and cell range address -->
<!ENTITY % cell-address "CDATA">
<!ENTITY % cell-range-address "CDATA">
<!ENTITY % cell-range-address-list "CDATA">

<!-- value types -->
<!ENTITY % valueType "(float|time|date|percentage|currency|boolean|string)">

<!-- an svg coordinate in different distance formats -->
<!ENTITY % coordinate "CDATA">

<!ENTITY % coordinateOrPercentage	"CDATA">

<!ENTITY % shape "draw:rect|draw:line|draw:polyline|draw:polygon|draw:path|
				   draw:circle|draw:ellipse|draw:g|draw:page-thumbnail|
				   draw:text-box|draw:image|draw:object|draw:object-ole|
				   draw:applet|draw:floating-frame|draw:plugin|
				   draw:measure|draw:caption|draw:connector|chart:chart|
				   dr3d:scene|draw:control|draw:custom-shape" >
<!ENTITY % shapes "(%shape;)" >

<!ENTITY % anchorType "(page|frame|paragraph|char|as-char)">

<!ENTITY % control-id "form:id CDATA #REQUIRED">
