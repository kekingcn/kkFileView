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

<!ELEMENT style:font-decl EMPTY>
<!ATTLIST style:font-decl style:name %string; #REQUIRED>
<!ATTLIST style:font-decl fo:font-family %string; #REQUIRED>
<!ATTLIST style:font-decl style:font-style-name %string; #IMPLIED>
<!ENTITY % fontFamilyGeneric "(roman|swiss|modern|decorative|script|system)">
<!ATTLIST style:font-decl style:font-family-generic %fontFamilyGeneric;
						   #IMPLIED>
<!ENTITY % fontPitch "(fixed|variable)">
<!ATTLIST style:font-decl style:font-pitch %fontPitch; #IMPLIED>
<!ATTLIST style:font-decl style:font-charset %textEncoding; #IMPLIED>

<!ELEMENT style:style ( style:properties?,office:events?,style:map*)>

<!ATTLIST style:style style:name %styleName; #REQUIRED>

<!ENTITY % styleFamily "(paragraph|text|section|
						 table|table-column|table-row|table-cell|table-page|chart|graphics|default|drawing-page|presentation|control|ruby)">
<!ATTLIST style:style style:family %styleFamily; #REQUIRED>

<!ATTLIST style:style style:parent-style-name %styleName; #IMPLIED>
<!ATTLIST style:style style:master-page-name %styleName; #IMPLIED>
<!ATTLIST style:style style:next-style-name %styleName; #IMPLIED>
<!ATTLIST style:style style:list-style-name %styleName; #IMPLIED>
<!ATTLIST style:style style:data-style-name %styleName; #IMPLIED>

<!ATTLIST style:style style:auto-update %boolean; "false">

<!ATTLIST style:style style:class %string; #IMPLIED>

<!ELEMENT style:default-style (style:properties?)>
<!ATTLIST style:default-style style:family %styleFamily; #REQUIRED>

<!ELEMENT style:map EMPTY>

<!ATTLIST style:map style:condition %string; #REQUIRED>
<!ATTLIST style:map style:apply-style-name %styleName; #REQUIRED>
<!ATTLIST style:map style:base-cell-address %cell-address; #IMPLIED>

<!ELEMENT style:properties ANY>

<!-- number format properties -->
<!ATTLIST style:properties style:num-prefix %string; #IMPLIED>
<!ATTLIST style:properties style:num-suffix %string; #IMPLIED>
<!ATTLIST style:properties style:num-format %string; #IMPLIED>
<!ATTLIST style:properties style:num-letter-sync %boolean; #IMPLIED>

<!-- frame properties -->
<!ATTLIST style:properties fo:width %positiveLength; #IMPLIED>
<!ATTLIST style:properties fo:height %positiveLength; #IMPLIED>
<!ATTLIST style:properties style:vertical-pos (top|middle|bottom|from-top|below) #IMPLIED>
<!ATTLIST style:properties style:vertical-rel (page|page-content|
											   frame|frame-content|
											   paragraph|paragraph-content|char|
											   line|baseline|text) #IMPLIED>
<!ATTLIST style:properties style:horizontal-pos (left|center|right|from-left|inside|outside|from-inside) #IMPLIED>
<!ATTLIST style:properties style:horizontal-rel (page|page-content|
								 page-start-margin|page-end-margin|
								 frame|frame-content|
								 frame-start-margin|frame-end-margin|
								 paragraph|paragraph-content|
								 paragraph-start-margin|paragraph-end-margin|
								 char) #IMPLIED>
<!ATTLIST style:properties svg:width %lengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties svg:height %lengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties fo:min-height %lengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties fo:min-width %lengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties fo:max-height %lengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties fo:max-width %lengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties text:anchor-type %anchorType; #IMPLIED>
<!ATTLIST style:properties text:anchor-page-number %positiveInteger; #IMPLIED>
<!ATTLIST style:properties svg:x %coordinate; #IMPLIED>
<!ATTLIST style:properties svg:y %coordinate; #IMPLIED>
<!ATTLIST style:properties style:print-content %boolean; #IMPLIED>
<!ATTLIST style:properties style:protect %boolean; #IMPLIED>
<!ATTLIST style:properties style:wrap (none|left|right|parallel|dynamic|run-through) #IMPLIED>
<!ENTITY % noLimitOrPositiveInteger "CDATA">
<!ATTLIST style:properties style:number-wrapped-paragraphs %noLimitOrPositiveInteger; #IMPLIED>
<!ATTLIST style:properties style:wrap-contour %boolean; #IMPLIED>
<!ATTLIST style:properties style:wrap-contour-mode (full|outside) #IMPLIED>
<!ATTLIST style:properties style:run-through (foreground|background) #IMPLIED>
<!ATTLIST style:properties style:editable %boolean; #IMPLIED>
<!ATTLIST style:properties style:mirror CDATA #IMPLIED>
<!ATTLIST style:properties fo:clip CDATA #IMPLIED>
<!ATTLIST style:properties text:animation (none|scroll|alternate|slide) #IMPLIED>
<!ATTLIST style:properties text:animation-direction (left|right|up|down) #IMPLIED>
<!ATTLIST style:properties text:animation-start-inside %boolean; #IMPLIED>
<!ATTLIST style:properties text:animation-stop-inside %boolean; #IMPLIED>
<!ATTLIST style:properties text:animation-repeat %integer; #IMPLIED>
<!ATTLIST style:properties text:animation-delay %timeDuration; #IMPLIED>
<!ATTLIST style:properties text:animation-steps %length; #IMPLIED>

<!-- text properties -->
<!ATTLIST style:properties fo:font-variant (normal|small-caps) #IMPLIED>
<!ATTLIST style:properties fo:text-transform (none|lowercase|
											  uppercase|capitalize) #IMPLIED>
<!ATTLIST style:properties fo:color %color; #IMPLIED>
<!ATTLIST style:properties style:use-window-font-color %boolean; #IMPLIED>
<!ATTLIST style:properties style:text-outline %boolean; #IMPLIED>
<!ATTLIST style:properties style:text-crossing-out
						   (none|single-line|double-line|thick-line|slash|X)
						   #IMPLIED>
<!ATTLIST style:properties style:text-position CDATA #IMPLIED>
<!ATTLIST style:properties style:text-align (left|right|start|center|end|justify|justified) #IMPLIED>

<!ATTLIST style:properties style:font-name %string; #IMPLIED>
<!ATTLIST style:properties fo:font-family %string; #IMPLIED>
<!ATTLIST style:properties style:font-family-generic %fontFamilyGeneric;
						   #IMPLIED>
<!ATTLIST style:properties style:font-style-name %string; #IMPLIED>
<!ATTLIST style:properties style:font-pitch %fontPitch; #IMPLIED>
<!ATTLIST style:properties style:font-charset %textEncoding; #IMPLIED>
<!ATTLIST style:properties style:font-name-asian %string; #IMPLIED>
<!ATTLIST style:properties style:font-family-asian %string; #IMPLIED>
<!ATTLIST style:properties style:font-family-generic-asian %fontFamilyGeneric;
						   #IMPLIED>
<!ATTLIST style:properties style:font-style-name-asian %string; #IMPLIED>
<!ATTLIST style:properties style:font-pitch-asian %fontPitch; #IMPLIED>
<!ATTLIST style:properties style:font-charset-asian %textEncoding; #IMPLIED>
<!ATTLIST style:properties style:font-name-complex %string; #IMPLIED>
<!ATTLIST style:properties style:font-family-complex %string; #IMPLIED>
<!ATTLIST style:properties style:font-family-generic-complex %fontFamilyGeneric;
						   #IMPLIED>
<!ATTLIST style:properties style:font-style-name-complex %string; #IMPLIED>
<!ATTLIST style:properties style:font-pitch-complex %fontPitch; #IMPLIED>
<!ATTLIST style:properties style:font-charset-complex %textEncoding; #IMPLIED>

<!ATTLIST style:properties fo:font-size %positiveLengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties style:font-size-rel %length; #IMPLIED>
<!ATTLIST style:properties style:font-size-asian %positiveLengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties style:font-size-rel-asian %length; #IMPLIED>
<!ATTLIST style:properties style:font-size-complex %positiveLengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties style:font-size-rel-complex %length; #IMPLIED>
<!ENTITY % normalOrLength "CDATA">
<!ATTLIST style:properties fo:letter-spacing %normalOrLength; #IMPLIED>
<!ATTLIST style:properties fo:language %languageOnly; #IMPLIED>
<!ATTLIST style:properties style:language-asian %languageOnly; #IMPLIED>
<!ATTLIST style:properties style:language-complex %languageOnly; #IMPLIED>
<!ATTLIST style:properties fo:country %country; #IMPLIED>
<!ATTLIST style:properties style:country-asian %country; #IMPLIED>
<!ATTLIST style:properties style:country-complex %country; #IMPLIED>
<!ENTITY % fontStyle "(normal|italic|oblique)">
<!ATTLIST style:properties fo:font-style %fontStyle; #IMPLIED>
<!ATTLIST style:properties style:font-style-asian %fontStyle; #IMPLIED>
<!ATTLIST style:properties style:font-style-complex %fontStyle; #IMPLIED>
<!ENTITY % fontRelief "(none|embossed|engraved)">
<!ATTLIST style:properties style:font-relief %fontRelief; #IMPLIED>
<!ATTLIST style:properties fo:text-shadow CDATA #IMPLIED>
<!ATTLIST style:properties style:text-underline
						   (none|single|double|dotted|dash|long-dash|dot-dash|
							dot-dot-dash|wave|bold|bold-dotted|bold-dash|
							bold-long-dash|bold-dot-dash|bold-dot-dot-dash|
							bold-wave|double-wave|small-wave) #IMPLIED>
<!ATTLIST style:properties style:text-autospace (none | ideograph-alpha) #IMPLIED>
<!ATTLIST style:properties style:punctuation-wrap (simple | hanging) #IMPLIED>
<!ATTLIST style:properties style:line-break (normal | strict) #IMPLIED>
<!ENTITY % fontColorOrColor "CDATA">
<!ATTLIST style:properties style:text-underline-color %fontColorOrColor;
						   #IMPLIED>
<!ATTLIST style:properties fo:font-weight CDATA #IMPLIED>
<!ATTLIST style:properties style:font-weight-asian CDATA #IMPLIED>
<!ATTLIST style:properties style:font-weight-complex CDATA #IMPLIED>
<!ATTLIST style:properties fo:score-spaces %boolean; #IMPLIED>
<!ATTLIST style:properties style:letter-kerning %boolean; #IMPLIED>
<!ATTLIST style:properties style:text-blinking %boolean; #IMPLIED>
<!ATTLIST style:properties style:text-background-color %transparentOrColor;
						   #IMPLIED>

<!ATTLIST style:properties style:text-combine (none|letters|lines) #IMPLIED>
<!ATTLIST style:properties style:text-combine-start-char %character; #IMPLIED>
<!ATTLIST style:properties style:text-combine-end-char %character; #IMPLIED>
<!ATTLIST style:properties style:text-emphasize CDATA #IMPLIED>
<!ATTLIST style:properties style:text-scale %percentage; #IMPLIED>
<!ATTLIST style:properties style:text-rotation-angle %integer; #IMPLIED>
<!ATTLIST style:properties style:text-rotation-scale (fixed|line-height) #IMPLIED>
<!ATTLIST style:properties text:display (none|true) #IMPLIED>

<!-- paragraph properties -->
<!ENTITY % nonNegativeLengthOrPercentageOrNormal "CDATA">
<!ATTLIST style:properties fo:line-height
						   %nonNegativeLengthOrPercentageOrNormal; #IMPLIED>
<!ATTLIST style:properties style:line-height-at-least %nonNegativeLength;
						   #IMPLIED>
<!ATTLIST style:properties style:line-spacing %length; #IMPLIED>
<!ATTLIST style:properties fo:text-align (start|end|center|justify) #IMPLIED>
<!ATTLIST style:properties fo:text-align-last (start|center|justify) #IMPLIED>
<!ATTLIST style:properties style:text-align-source (fix|value-type) #IMPLIED>
<!ATTLIST style:properties style:justify-single-word %boolean; #IMPLIED>
<!-- fo:keep-together is new in OOo 2.0 -->
<!ATTLIST style:properties fo:keep-together (auto|always) #IMPLIED>
<!ATTLIST style:properties style:break-inside (auto|avoid) #IMPLIED>
<!ATTLIST style:properties fo:widows %nonNegativeInteger; #IMPLIED>
<!ATTLIST style:properties fo:orphans %nonNegativeInteger; #IMPLIED>

<!ATTLIST style:properties fo:hyphenate %boolean; #IMPLIED>
<!ATTLIST style:properties fo:hyphenate-keep (none|page) #IMPLIED>
<!ATTLIST style:properties fo:hyphenation-remain-char-count %positiveInteger;
						   #IMPLIED>
<!ATTLIST style:properties fo:hyphenation-push-char-count %positiveInteger;
						   #IMPLIED>
<!ATTLIST style:properties fo:hyphenation-ladder-count
						   %noLimitOrPositiveInteger;  #IMPLIED>
<!ATTLIST style:properties style:page-number %positiveInteger; #IMPLIED>

<!ELEMENT style:tab-stops (style:tab-stop)*>
<!ELEMENT style:tab-stop EMPTY>
<!ATTLIST style:tab-stop style:position %nonNegativeLength; #REQUIRED>
<!ATTLIST style:tab-stop style:type (left|center|right|char|default) "left">
<!ATTLIST style:tab-stop style:char %character; #IMPLIED>
<!ATTLIST style:tab-stop style:leader-char %character; " ">

<!ELEMENT style:drop-cap EMPTY>
<!ENTITY % wordOrPositiveInteger "CDATA">
<!ATTLIST style:drop-cap style:length %wordOrPositiveInteger; "1">
<!ATTLIST style:drop-cap style:lines %positiveInteger; "1">
<!ATTLIST style:drop-cap style:distance %length; "0cm">
<!ATTLIST style:drop-cap style:style-name %styleName; #IMPLIED>

<!ATTLIST style:properties style:register-true %boolean; #IMPLIED>
<!ATTLIST style:properties style:register-truth-ref-style-name %styleName; #IMPLIED>
<!ATTLIST style:properties fo:margin-left %positiveLengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties fo:margin-right %positiveLengthOrPercentage;
						   #IMPLIED>
<!ATTLIST style:properties fo:text-indent %lengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties style:auto-text-indent %boolean; #IMPLIED>
<!ATTLIST style:properties fo:margin-top %positiveLengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties fo:margin-bottom %positiveLengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties fo:break-before (auto|column|page) #IMPLIED>
<!ATTLIST style:properties fo:break-after (auto|column|page) #IMPLIED>
<!ATTLIST style:properties fo:background-color %transparentOrColor; #IMPLIED>
<!ATTLIST style:properties style:background-transparency %percentage; #IMPLIED>
<!ATTLIST style:properties style:dynamic-spacing %boolean; #IMPLIED>

<!ELEMENT style:background-image (office:binary-data?)>
<!ATTLIST style:background-image xlink:type (simple) #IMPLIED>
<!ATTLIST style:background-image xlink:href %uriReference; #IMPLIED>
<!ATTLIST style:background-image xlink:show (embed) #IMPLIED>
<!ATTLIST style:background-image xlink:actuate (onLoad) #IMPLIED>
<!ATTLIST style:background-image style:repeat (no-repeat|repeat|stretch)
								 "repeat">
<!ATTLIST style:background-image style:position CDATA "center">
<!ATTLIST style:background-image style:filter-name %string; #IMPLIED>
<!ATTLIST style:background-image draw:transparency %percentage; #IMPLIED>

<!ELEMENT style:symbol-image (office:binary-data?)>
<!ATTLIST style:symbol-image xlink:type (simple) #IMPLIED>
<!ATTLIST style:symbol-image xlink:href %uriReference; #IMPLIED>
<!ATTLIST style:symbol-image xlink:show (embed) #IMPLIED>
<!ATTLIST style:symbol-image xlink:actuate (onLoad) #IMPLIED>

<!ATTLIST style:properties fo:border CDATA #IMPLIED>
<!ATTLIST style:properties fo:border-top CDATA #IMPLIED>
<!ATTLIST style:properties fo:border-bottom CDATA #IMPLIED>
<!ATTLIST style:properties fo:border-left CDATA #IMPLIED>
<!ATTLIST style:properties fo:border-right CDATA #IMPLIED>
<!ATTLIST style:properties style:border-line-width CDATA #IMPLIED>
<!ATTLIST style:properties style:border-line-width-top CDATA #IMPLIED>
<!ATTLIST style:properties style:border-line-width-bottom CDATA #IMPLIED>
<!ATTLIST style:properties style:border-line-width-left CDATA #IMPLIED>
<!ATTLIST style:properties style:border-line-width-right CDATA #IMPLIED>
<!ATTLIST style:properties fo:padding %nonNegativeLength; #IMPLIED>
<!ATTLIST style:properties fo:padding-top %nonNegativeLength; #IMPLIED>
<!ATTLIST style:properties fo:padding-bottom %nonNegativeLength; #IMPLIED>
<!ATTLIST style:properties fo:padding-left %nonNegativeLength; #IMPLIED>
<!ATTLIST style:properties fo:padding-right %nonNegativeLength; #IMPLIED>
<!ATTLIST style:properties style:shadow CDATA #IMPLIED>
<!ATTLIST style:properties fo:keep-with-next %boolean; #IMPLIED>
<!ATTLIST style:properties style:join-border %boolean; #IMPLIED>

<!ATTLIST style:properties text:number-lines %boolean; "false">
<!ATTLIST style:properties text:line-number %nonNegativeInteger; #IMPLIED>

<!ATTLIST style:properties style:decimal-places %nonNegativeInteger; #IMPLIED>
<!ATTLIST style:properties style:tab-stop-distance %nonNegativeLength; #IMPLIED>

<!-- section properties -->
<!ATTLIST style:properties text:dont-balance-text-columns %boolean; #IMPLIED>

<!-- ruby properties -->
<!ATTLIST style:properties style:ruby-align (left|center|right|distribute-letter|distribute-space) #IMPLIED>
<!ATTLIST style:properties style:ruby-position (above|below) #IMPLIED>


<!-- table properties -->
<!ATTLIST style:properties style:width %positiveLength; #IMPLIED>
<!ATTLIST style:properties style:rel-width %percentage; #IMPLIED>
<!ATTLIST style:properties style:may-break-between-rows %boolean; #IMPLIED>
<!ATTLIST style:properties table:page-style-name %styleName; #IMPLIED>
<!ATTLIST style:properties table:display %boolean; #IMPLIED>

<!-- table column properties -->
<!ATTLIST style:properties style:column-width %positiveLength; #IMPLIED>
<!ENTITY % relWidth "CDATA">
<!ATTLIST style:properties style:rel-column-width %relWidth; #IMPLIED>
<!ATTLIST style:properties style:use-optimal-column-width %boolean; #IMPLIED>

<!-- table row properties -->
<!ATTLIST style:properties style:row-height %positiveLength; #IMPLIED>
<!ATTLIST style:properties style:min-row-height %nonNegativeLength; #IMPLIED>
<!ATTLIST style:properties style:use-optimal-row-height %boolean; #IMPLIED>

<!-- table cell properties -->
<!ATTLIST style:properties
	table:align (left | center | right | margins) #IMPLIED
	table:border-model (collapsing | separating) #IMPLIED
	fo:vertical-align (top | middle | bottom | automatic) #IMPLIED
	fo:direction (ltr | ttb) #IMPLIED
	style:glyph-orientation-vertical (auto | 0) #IMPLIED
	style:rotation-angle %nonNegativeInteger; #IMPLIED
	style:rotation-align (none | bottom | top | center) #IMPLIED
	style:cell-protect CDATA #IMPLIED
	fo:wrap-option (no-wrap | wrap) #IMPLIED
>
<!ELEMENT style:columns (style:column-sep?,style:column*)>
<!ATTLIST style:columns fo:column-count %nonNegativeInteger; #IMPLIED>
<!ATTLIST style:columns fo:column-gap %positiveLength; #IMPLIED>

<!ELEMENT style:column EMPTY>
<!ATTLIST style:column style:rel-width CDATA #IMPLIED>
<!ATTLIST style:column fo:margin-left %positiveLength; #IMPLIED>
<!ATTLIST style:column fo:margin-right %positiveLength; #IMPLIED>

<!ELEMENT style:column-sep EMPTY>
<!ATTLIST style:column-sep style:style (none|solid|dotted|dashed|dot-dashed)
																	"solid">
<!ATTLIST style:column-sep style:width %length; #REQUIRED>
<!ATTLIST style:column-sep style:height %percentage; "100&#37;">
<!ATTLIST style:column-sep style:vertical-align (top|middle|bottom) "top">
<!ATTLIST style:column-sep style:color %color; "#000000">

<!-- page master properties -->
<!ELEMENT style:page-master (style:properties?, style:header-style?, style:footer-style?)>
<!ATTLIST style:page-master style:name %styleName; #REQUIRED>
<!ATTLIST style:page-master style:page-usage (all|left|right|mirrored) "all">

<!ELEMENT style:header-style (style:properties?)>
<!ELEMENT style:footer-style (style:properties?)>

<!ATTLIST style:properties fo:page-width %length; #IMPLIED>
<!ATTLIST style:properties fo:page-height %length; #IMPLIED>
<!ATTLIST style:properties style:paper-tray-name %string; #IMPLIED>
<!ATTLIST style:properties style:print-orientation (portrait|landscape) #IMPLIED>
<!ATTLIST style:properties style:print CDATA #IMPLIED>
<!ATTLIST style:properties style:print-page-order (ttb|ltr) #IMPLIED>
<!ATTLIST style:properties style:first-page-number %positiveInteger; #IMPLIED>
<!ATTLIST style:properties style:scale-to %percentage; #IMPLIED>
<!ATTLIST style:properties style:scale-to-pages %positiveInteger; #IMPLIED>
<!ATTLIST style:properties style:table-centering (horizontal | vertical | both | none) #IMPLIED>

<!ATTLIST style:properties style:footnote-max-height %lengthOrNoLimit; #IMPLIED>
<!ATTLIST style:properties style:vertical-align (top|bottom|middle|basline|auto) #IMPLIED>
<!ATTLIST style:properties style:writing-mode (lr-tb|rl-tb|tb-rl|tb-lr|lr|rl|tb|page) "lr-tb">
<!ATTLIST style:properties style:layout-grid-mode (none|line|both) #IMPLIED>
<!ATTLIST style:properties style:layout-grid-base-height %length; #IMPLIED>
<!ATTLIST style:properties style:layout-grid-ruby-height %length; #IMPLIED>
<!ATTLIST style:properties style:layout-grid-lines %positiveInteger; #IMPLIED>
<!ATTLIST style:properties style:layout-grid-color %color; #IMPLIED>
<!ATTLIST style:properties style:layout-grid-ruby-below %boolean; #IMPLIED>
<!ATTLIST style:properties style:layout-grid-print %boolean; #IMPLIED>
<!ATTLIST style:properties style:layout-grid-display %boolean; #IMPLIED>
<!ATTLIST style:properties style:snap-to-layout-grid %boolean; #IMPLIED>

<!ELEMENT style:footnote-sep EMPTY>
<!ATTLIST style:footnote-sep style:width %length; #IMPLIED>
<!ATTLIST style:footnote-sep style:rel-width %percentage; #IMPLIED>
<!ATTLIST style:footnote-sep style:color %color; #IMPLIED>
<!ATTLIST style:footnote-sep style:adjustment (left|center|right) "left">
<!ATTLIST style:footnote-sep style:distance-before-sep %length; #IMPLIED>
<!ATTLIST style:footnote-sep style:distance-after-sep %length; #IMPLIED>

<!-- master page -->
<!ELEMENT style:master-page ( (style:header, style:header-left?)?, (style:footer, style:footer-left?)?,
								office:forms?,style:style*, (%shapes;)*, presentation:notes? )>
<!ATTLIST style:master-page style:name %styleName; #REQUIRED>
<!ATTLIST style:master-page style:page-master-name %styleName; #REQUIRED>
<!ATTLIST style:master-page style:next-style-name %styleName; #IMPLIED>
<!ATTLIST style:master-page draw:style-name %styleName; #IMPLIED>

<!-- handout master -->
<!ELEMENT style:handout-master (%shapes;)*>
<!ATTLIST style:handout-master presentation:presentation-page-layout-name %styleName; #IMPLIED>
<!ATTLIST style:handout-master style:page-master-name %styleName; #IMPLIED>
<!ATTLIST style:handout-master draw:style-name %styleName; #IMPLIED>

<!ENTITY % hd-ft-content "( %headerText; | (style:region-left?, style:region-center?, style:region-right?) )">
<!ELEMENT style:header %hd-ft-content;>
<!ATTLIST style:header style:display %boolean; "true">
<!ELEMENT style:footer %hd-ft-content;>
<!ATTLIST style:footer style:display %boolean; "true">
<!ELEMENT style:header-left %hd-ft-content;>
<!ATTLIST style:header-left style:display %boolean; "true">
<!ELEMENT style:footer-left %hd-ft-content;>
<!ATTLIST style:footer-left style:display %boolean; "true">

<!ENTITY % region-content "(text:p*)">
<!ELEMENT style:region-left %region-content;>
<!ELEMENT style:region-center %region-content;>
<!ELEMENT style:region-right %region-content;>

<!-- control shape properties -->
<!ATTLIST style:properties draw:symbol-color %color; #IMPLIED>
