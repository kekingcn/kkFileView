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

<!ENTITY % points "CDATA" >
<!ENTITY % pathData "CDATA" >
<!ENTITY % gradient-style "(linear|axial|radial|ellipsoid|square|rectangular)" >
<!ENTITY % draw-position "svg:x %coordinate; #IMPLIED svg:y %coordinate; #IMPLIED">
<!ENTITY % draw-end-position "table:end-cell-address %cell-address; #IMPLIED table:end-x %coordinate; #IMPLIED table:end-y %coordinate; #IMPLIED">
<!ENTITY % draw-size "svg:width %coordinate; #IMPLIED svg:height %coordinate; #IMPLIED">
<!ENTITY % draw-transform "draw:transform CDATA #IMPLIED">
<!ENTITY % draw-viewbox "svg:viewBox CDATA #REQUIRED">
<!ENTITY % draw-style-name "draw:style-name %styleName; #IMPLIED presentation:style-name %styleName; #IMPLIED draw:text-style-name %styleName; #IMPLIED">
<!ENTITY % draw-shape-id "CDATA #IMPLIED" >
<!ENTITY % draw-text "(text:p|text:unordered-list|text:ordered-list)*">
<!ENTITY % zindex "draw:z-index %nonNegativeInteger; #IMPLIED">
<!ENTITY % distance "CDATA">
<!ENTITY % rectanglePoint "(top-left|top|top-right|left|center|right|bottom-left|bottom|bottom-right)">
<!ENTITY % vector3D "CDATA">
<!ENTITY % text-anchor "text:anchor-type %anchorType; #IMPLIED text:anchor-page-number %positiveInteger; #IMPLIED">
<!ENTITY % layerName "CDATA">
<!ENTITY % table-background "table:table-background (true | false) #IMPLIED">

<!-- common presentation shape attributes -->
<!ENTITY % presentation-style-name "presentation:style-name %styleName; #IMPLIED">
<!ENTITY % presentation-classes "(title|outline|subtitle|text|graphic|object|chart|table|orgchart|page|notes)" >
<!-- ENTITY % presentation-class "presentation:class %presentation-classes; #IMPLIED" -->
<!ENTITY % presentation-class "presentation:class %presentation-classes; #IMPLIED presentation:placeholder (true|false) #IMPLIED presentation:user-transformed (true|false) #IMPLIED">
<!ENTITY % presentationEffects "(none|fade|move|stripes|open|close|dissolve|wavyline|random|lines|laser|appear|hide|move-short|checkerboard|rotate|stretch)" >
<!ENTITY % presentationEffectDirections "(none|from-left|from-top|from-right|from-bottom|from-center|from-upper-left|from-upper-right|from-lower-left|from-lower-right|to-left|to-top|to-right|to-bottom|to-upper-left|to-upper-right|to-lower-right|to-lower-left|path|spiral-inward-left|spiral-inward-right|spiral-outward-left|spiral-outward-right|vertical|horizontal|to-center|clockwise|counter-clockwise)" >
<!ENTITY % presentationSpeeds "(slow|medium|fast)" >

<!-- Drawing shapes -->
<!ELEMENT draw:rect ( office:events?, %draw-text; )>
<!ATTLIST draw:rect %draw-position; >
<!ATTLIST draw:rect %draw-end-position; >
<!ATTLIST draw:rect %table-background; >
<!ATTLIST draw:rect %draw-size; >
<!ATTLIST draw:rect %draw-style-name; >
<!ATTLIST draw:rect %draw-transform; >
<!ATTLIST draw:rect draw:corner-radius %nonNegativeLength; #IMPLIED>
<!ATTLIST draw:rect %zindex;>
<!ATTLIST draw:rect draw:id %draw-shape-id;>
<!ATTLIST draw:rect %text-anchor;>
<!ATTLIST draw:rect draw:layer %layerName; #IMPLIED>

<!ELEMENT draw:line ( office:events?, %draw-text; )>
<!ATTLIST draw:line svg:x1 %length; #IMPLIED>
<!ATTLIST draw:line svg:y1 %length; #IMPLIED>
<!ATTLIST draw:line svg:x2 %length; #REQUIRED>
<!ATTLIST draw:line svg:y2 %length; #REQUIRED>
<!ATTLIST draw:line svg:y %coordinate; #IMPLIED>
<!ATTLIST draw:line %draw-style-name; >
<!ATTLIST draw:line %draw-transform; >
<!ATTLIST draw:line %zindex;>
<!ATTLIST draw:line %draw-end-position; >
<!ATTLIST draw:line %table-background; >
<!ATTLIST draw:line draw:id %draw-shape-id;>
<!ATTLIST draw:line %text-anchor;>
<!ATTLIST draw:line draw:layer %layerName; #IMPLIED>

<!ELEMENT draw:polyline ( office:events?, %draw-text; )>
<!ATTLIST draw:polyline %draw-position; >
<!ATTLIST draw:polyline %draw-size; >
<!ATTLIST draw:polyline %draw-viewbox; >
<!ATTLIST draw:polyline draw:points %points; #REQUIRED>
<!ATTLIST draw:polyline %draw-style-name; >
<!ATTLIST draw:polyline %draw-transform; >
<!ATTLIST draw:polyline %zindex;>
<!ATTLIST draw:polyline %draw-end-position; >
<!ATTLIST draw:polyline %table-background; >
<!ATTLIST draw:polyline draw:id %draw-shape-id;>
<!ATTLIST draw:polyline %text-anchor;>
<!ATTLIST draw:polyline draw:layer %layerName; #IMPLIED>

<!ELEMENT draw:polygon ( office:events?, %draw-text; )>
<!ATTLIST draw:polygon %draw-position; >
<!ATTLIST draw:polygon %draw-end-position; >
<!ATTLIST draw:polygon %table-background; >
<!ATTLIST draw:polygon %draw-size; >
<!ATTLIST draw:polygon %draw-viewbox; >
<!ATTLIST draw:polygon draw:points %points; #REQUIRED >
<!ATTLIST draw:polygon %draw-style-name; >
<!ATTLIST draw:polygon %draw-transform; >
<!ATTLIST draw:polygon %zindex;>
<!ATTLIST draw:polygon draw:id %draw-shape-id;>
<!ATTLIST draw:polygon %text-anchor;>
<!ATTLIST draw:polygon draw:layer %layerName; #IMPLIED>

<!ELEMENT draw:path ( office:events?, %draw-text; )>
<!ATTLIST draw:path %draw-position;>
<!ATTLIST draw:path %draw-end-position; >
<!ATTLIST draw:path %table-background; >
<!ATTLIST draw:path %draw-size; >
<!ATTLIST draw:path %draw-viewbox; >
<!ATTLIST draw:path svg:d %pathData; #REQUIRED >
<!ATTLIST draw:path %draw-style-name; >
<!ATTLIST draw:path %draw-transform; >
<!ATTLIST draw:path %zindex;>
<!ATTLIST draw:path draw:id %draw-shape-id;>
<!ATTLIST draw:path %text-anchor;>
<!ATTLIST draw:path draw:layer %layerName; #IMPLIED>

<!ELEMENT draw:circle ( office:events?, %draw-text; )>
<!ATTLIST draw:circle %draw-position; >
<!ATTLIST draw:circle %draw-size; >
<!ATTLIST draw:circle %draw-style-name; >
<!ATTLIST draw:circle %draw-transform; >
<!ATTLIST draw:circle %zindex;>
<!ATTLIST draw:circle %draw-end-position; >
<!ATTLIST draw:circle %table-background; >
<!ATTLIST draw:circle draw:id %draw-shape-id;>
<!ATTLIST draw:circle draw:kind (full|section|cut|arc) "full">
<!ATTLIST draw:circle draw:start-angle %nonNegativeInteger; #IMPLIED>
<!ATTLIST draw:circle draw:end-angle %nonNegativeInteger; #IMPLIED>
<!ATTLIST draw:circle %text-anchor;>
<!ATTLIST draw:circle draw:layer %layerName; #IMPLIED>

<!ELEMENT draw:ellipse ( office:events?, %draw-text; )>
<!ATTLIST draw:ellipse %draw-position; >
<!ATTLIST draw:ellipse %draw-size; >
<!ATTLIST draw:ellipse %draw-style-name; >
<!ATTLIST draw:ellipse %draw-transform; >
<!ATTLIST draw:ellipse %zindex;>
<!ATTLIST draw:ellipse %draw-end-position; >
<!ATTLIST draw:ellipse %table-background; >
<!ATTLIST draw:ellipse draw:id %draw-shape-id;>
<!ATTLIST draw:ellipse draw:kind (full|section|cut|arc) "full">
<!ATTLIST draw:ellipse draw:start-angle %nonNegativeInteger; #IMPLIED>
<!ATTLIST draw:ellipse draw:end-angle %nonNegativeInteger; #IMPLIED>
<!ATTLIST draw:ellipse  %text-anchor;>
<!ATTLIST draw:ellipse draw:layer %layerName; #IMPLIED>

<!ELEMENT draw:connector ( office:events?, %draw-text;)>
<!ATTLIST draw:connector draw:type (standard|lines|line|curve) "standard">
<!ATTLIST draw:connector draw:line-skew CDATA #IMPLIED>
<!ATTLIST draw:connector %draw-style-name;>
<!ATTLIST draw:connector svg:x1 %coordinate; #REQUIRED>
<!ATTLIST draw:connector svg:y1 %coordinate; #REQUIRED>
<!ATTLIST draw:connector svg:x2 %coordinate; #REQUIRED>
<!ATTLIST draw:connector svg:y2 %coordinate; #REQUIRED>
<!ATTLIST draw:connector draw:start-shape %draw-shape-id;>
<!ATTLIST draw:connector draw:start-glue-point %integer; #IMPLIED>
<!ATTLIST draw:connector draw:end-shape %draw-shape-id;>
<!ATTLIST draw:connector draw:end-glue-point %integer; #IMPLIED>
<!ATTLIST draw:connector %zindex;>
<!ATTLIST draw:connector %draw-end-position; >
<!ATTLIST draw:connector %table-background; >
<!ATTLIST draw:connector draw:id %draw-shape-id;>
<!ATTLIST draw:connector %text-anchor;>
<!ATTLIST draw:connector draw:layer %layerName; #IMPLIED>

<!ELEMENT draw:control EMPTY>
<!ATTLIST draw:control %draw-style-name;>
<!ATTLIST draw:control %draw-position; >
<!ATTLIST draw:control %draw-size; >
<!ATTLIST draw:control %control-id; >
<!ATTLIST draw:control %zindex;>
<!ATTLIST draw:control %draw-end-position; >
<!ATTLIST draw:control %table-background; >
<!ATTLIST draw:control draw:id %draw-shape-id;>
<!ATTLIST draw:control %text-anchor;>
<!ATTLIST draw:control draw:layer %layerName; #IMPLIED>

<!ELEMENT draw:g ( office:events?, (%shapes;)* ) >
<!ATTLIST draw:g svg:y %coordinate; #IMPLIED>
<!ATTLIST draw:g %draw-transform; >
<!ATTLIST draw:g draw:name %string; #IMPLIED>
<!ATTLIST draw:g %draw-style-name; >
<!ATTLIST draw:g %zindex;>
<!ATTLIST draw:g %draw-end-position; >
<!ATTLIST draw:g %table-background; >
<!ATTLIST draw:g draw:id %draw-shape-id;>
<!ATTLIST draw:g %text-anchor;>
<!ATTLIST draw:g draw:layer %layerName; #IMPLIED>

<!ELEMENT draw:page-thumbnail EMPTY>
<!ATTLIST draw:page-thumbnail draw:page-number %positiveInteger; #IMPLIED>
<!ATTLIST draw:page-thumbnail %draw-position; >
<!ATTLIST draw:page-thumbnail %draw-size; >
<!ATTLIST draw:page-thumbnail %draw-style-name; >
<!ATTLIST draw:page-thumbnail %presentation-class; >
<!ATTLIST draw:page-thumbnail %zindex;>
<!ATTLIST draw:page-thumbnail %draw-end-position; >
<!ATTLIST draw:page-thumbnail %table-background; >
<!ATTLIST draw:page-thumbnail draw:id %draw-shape-id;>
<!ATTLIST draw:page-thumbnail %text-anchor;>
<!ATTLIST draw:page-thumbnail draw:layer %layerName; #IMPLIED>

<!ELEMENT draw:caption ( office:events?, %draw-text;)>
<!ATTLIST draw:caption %draw-position; >
<!ATTLIST draw:caption %draw-end-position; >
<!ATTLIST draw:caption %table-background; >
<!ATTLIST draw:caption %draw-size; >
<!ATTLIST draw:caption %draw-style-name; >
<!ATTLIST draw:caption %draw-transform; >
<!ATTLIST draw:caption draw:caption-point-x %coordinate; #IMPLIED>
<!ATTLIST draw:caption draw:caption-point-y %coordinate; #IMPLIED>
<!ATTLIST draw:caption %zindex;>
<!ATTLIST draw:caption draw:id %draw-shape-id;>
<!ATTLIST draw:caption  %text-anchor;>
<!ATTLIST draw:caption draw:layer %layerName; #IMPLIED>
<!ATTLIST draw:caption draw:corner-radius %nonNegativeLength; #IMPLIED>

<!ELEMENT draw:measure ( office:events?, %draw-text;)>
<!ATTLIST draw:measure svg:x1 %coordinate; #REQUIRED>
<!ATTLIST draw:measure svg:y1 %coordinate; #REQUIRED>
<!ATTLIST draw:measure svg:x2 %coordinate; #REQUIRED>
<!ATTLIST draw:measure svg:y2 %coordinate; #REQUIRED>
<!ATTLIST draw:measure %draw-end-position; >
<!ATTLIST draw:measure %table-background; >
<!ATTLIST draw:measure %draw-style-name; >
<!ATTLIST draw:measure %draw-transform; >
<!ATTLIST draw:measure %zindex;>
<!ATTLIST draw:measure draw:id %draw-shape-id;>
<!ATTLIST draw:measure %text-anchor;>
<!ATTLIST draw:measure draw:layer %layerName; #IMPLIED>

<!-- graphic style elements -->
<!ELEMENT draw:gradient EMPTY >
<!ATTLIST draw:gradient draw:name %styleName; #REQUIRED>
<!ATTLIST draw:gradient draw:style %gradient-style; #REQUIRED>
<!ATTLIST draw:gradient draw:cx %coordinate; #IMPLIED>
<!ATTLIST draw:gradient draw:cy %coordinate; #IMPLIED>
<!ATTLIST draw:gradient draw:start-color %color; #IMPLIED>
<!ATTLIST draw:gradient draw:end-color %color; #IMPLIED>
<!ATTLIST draw:gradient draw:start-intensity %percentage; #IMPLIED>
<!ATTLIST draw:gradient draw:end-intensity %percentage; #IMPLIED>
<!ATTLIST draw:gradient draw:angle %integer; #IMPLIED>
<!ATTLIST draw:gradient draw:border %percentage; #IMPLIED>

<!ELEMENT draw:hatch EMPTY >
<!ATTLIST draw:hatch draw:name %styleName; #REQUIRED>
<!ATTLIST draw:hatch draw:style (single|double|triple) #REQUIRED >
<!ATTLIST draw:hatch draw:color %color; #IMPLIED>
<!ATTLIST draw:hatch draw:distance %length; #IMPLIED>
<!ATTLIST draw:hatch draw:rotation %integer; #IMPLIED>


<!ELEMENT draw:fill-image EMPTY >
<!ATTLIST draw:fill-image draw:name %styleName; #REQUIRED>
<!ATTLIST draw:fill-image xlink:href %uriReference; #REQUIRED>
<!ATTLIST draw:fill-image xlink:type (simple) #IMPLIED>
<!ATTLIST draw:fill-image xlink:show (embed) #IMPLIED>
<!ATTLIST draw:fill-image xlink:actuate (onLoad) #IMPLIED>
<!ATTLIST draw:fill-image svg:width %length; #IMPLIED>
<!ATTLIST draw:fill-image svg:height %length; #IMPLIED>

<!ELEMENT draw:transparency EMPTY>
<!ATTLIST draw:transparency draw:name %styleName; #REQUIRED>
<!ATTLIST draw:transparency draw:style %gradient-style; #REQUIRED>
<!ATTLIST draw:transparency draw:cx %coordinate; #IMPLIED>
<!ATTLIST draw:transparency draw:cy %coordinate; #IMPLIED>
<!ATTLIST draw:transparency draw:start %percentage; #IMPLIED>
<!ATTLIST draw:transparency draw:end %percentage; #IMPLIED>
<!ATTLIST draw:transparency draw:angle %integer; #IMPLIED>
<!ATTLIST draw:transparency draw:border %percentage; #IMPLIED>

<!ELEMENT draw:marker EMPTY>
<!ATTLIST draw:marker draw:name %styleName; #REQUIRED>
<!ATTLIST draw:marker %draw-viewbox; >
<!ATTLIST draw:marker svg:d %pathData; #REQUIRED>

<!ELEMENT draw:stroke-dash EMPTY>
<!ATTLIST draw:stroke-dash draw:name %styleName; #REQUIRED>
<!ATTLIST draw:stroke-dash draw:style (rect|round) #IMPLIED>
<!ATTLIST draw:stroke-dash draw:dots1 %integer; #IMPLIED>
<!ATTLIST draw:stroke-dash draw:dots1-length %length; #IMPLIED>
<!ATTLIST draw:stroke-dash draw:dots2 %integer; #IMPLIED>
<!ATTLIST draw:stroke-dash draw:dots2-length %length; #IMPLIED>
<!ATTLIST draw:stroke-dash draw:distance %length; #IMPLIED>

<!-- stroke attributes -->
<!ATTLIST style:properties draw:stroke (none|dash|solid) #IMPLIED>
<!ATTLIST style:properties draw:stroke-dash CDATA #IMPLIED>
<!ATTLIST style:properties svg:stroke-width %length; #IMPLIED>
<!ATTLIST style:properties svg:stroke-color %color; #IMPLIED>
<!ATTLIST style:properties draw:marker-start %styleName; #IMPLIED>
<!ATTLIST style:properties draw:marker-end %styleName; #IMPLIED>
<!ATTLIST style:properties draw:marker-start-width %length; #IMPLIED>
<!ATTLIST style:properties draw:marker-end-width %length; #IMPLIED>
<!ATTLIST style:properties draw:marker-start-center %boolean; #IMPLIED>
<!ATTLIST style:properties draw:marker-end-center %boolean; #IMPLIED>
<!ATTLIST style:properties svg:stroke-opacity %floatOrPercentage; #IMPLIED>
<!ATTLIST style:properties svg:stroke-linejoin (miter|round|bevel|middle|none|inherit) #IMPLIED>

<!-- text attributes -->
<!ATTLIST style:properties draw:auto-grow-width %boolean; #IMPLIED>
<!ATTLIST style:properties draw:auto-grow-height %boolean; #IMPLIED>
<!ATTLIST style:properties draw:fit-to-size %boolean; #IMPLIED>
<!ATTLIST style:properties draw:fit-to-contour %boolean; #IMPLIED>
<!ATTLIST style:properties draw:textarea-horizontal-align ( left | center | right | justify ) #IMPLIED>
<!ATTLIST style:properties draw:textarea-vertical-align ( top | middle | bottom | justify ) #IMPLIED>
<!ATTLIST style:properties draw:writing-mode (lr-tb|tb-rl) "lr-tb">
<!ATTLIST style:properties style:font-independent-line-spacing %boolean; #IMPLIED>


<!-- fill attributes -->
<!ATTLIST style:properties draw:fill (none|solid|bitmap|gradient|hatch) #IMPLIED>
<!ATTLIST style:properties draw:fill-color %color; #IMPLIED>
<!ATTLIST style:properties draw:fill-gradient-name %styleName; #IMPLIED>
<!ATTLIST style:properties draw:gradient-step-count CDATA #IMPLIED>
<!ATTLIST style:properties draw:fill-hatch-name %styleName; #IMPLIED>
<!ATTLIST style:properties draw:fill-hatch-solid %boolean; #IMPLIED>
<!ATTLIST style:properties draw:fill-image-name %styleName; #IMPLIED>
<!ATTLIST style:properties style:repeat (no-repeat|repeat|stretch) #IMPLIED>
<!ATTLIST style:properties draw:fill-image-width %lengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties draw:fill-image-height %lengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties draw:fill-image-ref-point-x %percentage; #IMPLIED>
<!ATTLIST style:properties draw:fill-image-ref-point-y %percentage; #IMPLIED>
<!ATTLIST style:properties draw:fill-image-ref-point %rectanglePoint; #IMPLIED>
<!ATTLIST style:properties draw:tile-repeat-offset CDATA #IMPLIED>
<!ATTLIST style:properties draw:transparency %percentage; #IMPLIED>
<!ATTLIST style:properties draw:transparency-name %styleName; #IMPLIED>

<!-- graphic attributes -->
<!ATTLIST style:properties draw:color-mode (greyscale|mono|watermark|standard) #IMPLIED>
<!ATTLIST style:properties draw:luminance %percentage; #IMPLIED>
<!ATTLIST style:properties draw:contrast %percentage; #IMPLIED>
<!ATTLIST style:properties draw:gamma %percentage; #IMPLIED>
<!ATTLIST style:properties draw:red %percentage; #IMPLIED>
<!ATTLIST style:properties draw:green %percentage; #IMPLIED>
<!ATTLIST style:properties draw:blue %percentage; #IMPLIED>
<!ATTLIST style:properties draw:color-inversion %boolean; #IMPLIED>
<!ATTLIST style:properties draw:mirror %boolean; #IMPLIED>

<!-- shadow attributes -->
<!ATTLIST style:properties draw:shadow (visible|hidden) #IMPLIED>
<!ATTLIST style:properties draw:shadow-offset-x %length; #IMPLIED>
<!ATTLIST style:properties draw:shadow-offset-y %length; #IMPLIED>
<!ATTLIST style:properties draw:shadow-color %color; #IMPLIED>
<!ATTLIST style:properties draw:shadow-transparency CDATA #IMPLIED>

<!-- connector attributes -->
<!ATTLIST style:properties draw:start-line-spacing-horizontal %distance; #IMPLIED>
<!ATTLIST style:properties draw:start-line-spacing-vertical %distance; #IMPLIED>
<!ATTLIST style:properties draw:end-line-spacing-horizontal %distance; #IMPLIED>
<!ATTLIST style:properties draw:end-line-spacing-vertical %distance; #IMPLIED>

<!-- measure attributes -->
<!ATTLIST style:properties draw:line-distance %distance; #IMPLIED>
<!ATTLIST style:properties draw:guide-overhang %distance; #IMPLIED>
<!ATTLIST style:properties draw:guide-distance %distance; #IMPLIED>
<!ATTLIST style:properties draw:start-guide %distance; #IMPLIED>
<!ATTLIST style:properties draw:end-guide %distance; #IMPLIED>
<!ATTLIST style:properties draw:measure-align (automatic|left-outside|inside|right-outside) #IMPLIED>
<!ATTLIST style:properties draw:measure-vertical-align (automatic|above|below|center) #IMPLIED>
<!ATTLIST style:properties draw:unit (automatic|mm|cm|m|km|pt|pc|inch|ft|mi) #IMPLIED>
<!ATTLIST style:properties draw:show-unit %boolean; #IMPLIED>
<!ATTLIST style:properties draw:placing (below|above) #IMPLIED>
<!ATTLIST style:properties draw:parallel %boolean; #IMPLIED>
<!ATTLIST style:properties draw:decimal-places %nonNegativeLength; #IMPLIED>

<!-- frame attributes -->
<!ATTLIST style:properties draw:frame-display-scrollbar %boolean; #IMPLIED>
<!ATTLIST style:properties draw:frame-display-border %boolean; #IMPLIED>
<!ATTLIST style:properties draw:frame-margin-horizontal %nonNegativePixelLength; #IMPLIED>
<!ATTLIST style:properties draw:frame-margin-vertical %nonNegativePixelLength; #IMPLIED>
<!ATTLIST style:properties draw:size-protect %boolean; #IMPLIED>
<!ATTLIST style:properties draw:move-protect %boolean; #IMPLIED>

<!-- ole object attributes -->
<!ATTLIST style:properties draw:visible-area-left %nonNegativeLength; #IMPLIED>
<!ATTLIST style:properties draw:visible-area-top %nonNegativeLength; #IMPLIED>
<!ATTLIST style:properties draw:visible-area-width %positiveLength; #IMPLIED>
<!ATTLIST style:properties draw:visible-area-height %positiveLength; #IMPLIED>

<!-- fontwork attributes -->
<!ATTLIST style:properties draw:fontwork-style (rotate|upright|slant-x|slant-y|none) #IMPLIED>
<!ATTLIST style:properties draw:fontwork-adjust (left|right|autosize|center) #IMPLIED>
<!ATTLIST style:properties draw:fontwork-distance %distance; #IMPLIED>
<!ATTLIST style:properties draw:fontwork-start %distance; #IMPLIED>
<!ATTLIST style:properties draw:fontwork-mirror %boolean; #IMPLIED>
<!ATTLIST style:properties draw:fontwork-outline %boolean; #IMPLIED>
<!ATTLIST style:properties draw:fontwork-shadow (normal|slant|none) #IMPLIED>
<!ATTLIST style:properties draw:fontwork-shadow-color %color; #IMPLIED>
<!ATTLIST style:properties draw:fontwork-shadow-offset-x %distance; #IMPLIED>
<!ATTLIST style:properties draw:fontwork-shadow-offset-y %distance; #IMPLIED>
<!ATTLIST style:properties draw:fontwork-form (none|top-circle|bottom-circle|left-circle|right-circle|top-arc|bottom-arc|left-arc|right-arc|button1|button2|button3|button4) #IMPLIED>
<!ATTLIST style:properties draw:fontwork-hide-form %boolean; #IMPLIED>
<!ATTLIST style:properties draw:fontwork-shadow-transparence %percentage; #IMPLIED>

<!-- caption attributes -->
<!ATTLIST style:properties draw:caption-type (straight-line|angled-line|angled-connector-line) #IMPLIED>
<!ATTLIST style:properties draw:caption-angle-type (fixed|free) #IMPLIED>
<!ATTLIST style:properties draw:caption-angle %nonNegativeInteger; #IMPLIED>
<!ATTLIST style:properties draw:caption-gap %distance; #IMPLIED>
<!ATTLIST style:properties draw:caption-escape-direction (horizontal|vertical|auto) #IMPLIED>
<!ATTLIST style:properties draw:caption-escape %lengthOrPercentage; #IMPLIED>
<!ATTLIST style:properties draw:caption-line-length %distance; #IMPLIED>
<!ATTLIST style:properties draw:caption-fit-line-length %boolean; #IMPLIED>

<!-- Animations -->
<!ELEMENT presentation:sound EMPTY>
<!ATTLIST presentation:sound xlink:href %uriReference; #REQUIRED>
<!ATTLIST presentation:sound xlink:type (simple) #FIXED "simple">
<!ATTLIST presentation:sound xlink:show (new|replace) #IMPLIED>
<!ATTLIST presentation:sound xlink:actuate (onRequest) "onRequest">
<!ATTLIST presentation:sound presentation:play-full %boolean; #IMPLIED>

<!ELEMENT presentation:show-shape (presentation:sound)?>
<!ATTLIST presentation:show-shape draw:shape-id CDATA #REQUIRED>
<!ATTLIST presentation:show-shape presentation:effect %presentationEffects; "none">
<!ATTLIST presentation:show-shape presentation:direction %presentationEffectDirections; "none">
<!ATTLIST presentation:show-shape presentation:speed %presentationSpeeds; "medium">
<!ATTLIST presentation:show-shape presentation:start-scale %percentage; "100&#37;">
<!ATTLIST presentation:show-shape presentation:path-id CDATA #IMPLIED >

<!ELEMENT presentation:show-text (presentation:sound)?>
<!ATTLIST presentation:show-text draw:shape-id CDATA #REQUIRED>
<!ATTLIST presentation:show-text presentation:effect %presentationEffects; "none">
<!ATTLIST presentation:show-text presentation:direction %presentationEffectDirections; "none">
<!ATTLIST presentation:show-text presentation:speed %presentationSpeeds; "medium">
<!ATTLIST presentation:show-text presentation:start-scale %percentage; "100&#37;">
<!ATTLIST presentation:show-text presentation:path-id CDATA #IMPLIED >

<!ELEMENT presentation:hide-shape (presentation:sound)?>
<!ATTLIST presentation:hide-shape draw:shape-id CDATA #REQUIRED>
<!ATTLIST presentation:hide-shape presentation:effect %presentationEffects; "none">
<!ATTLIST presentation:hide-shape presentation:direction %presentationEffectDirections; "none">
<!ATTLIST presentation:hide-shape presentation:speed %presentationSpeeds; "medium">
<!ATTLIST presentation:hide-shape presentation:start-scale %percentage; "100&#37;">
<!ATTLIST presentation:hide-shape presentation:path-id CDATA #IMPLIED >

<!ELEMENT presentation:hide-text (presentation:sound)?>
<!ATTLIST presentation:hide-text draw:shape-id CDATA #REQUIRED>
<!ATTLIST presentation:hide-text presentation:effect %presentationEffects; "none">
<!ATTLIST presentation:hide-text presentation:direction %presentationEffectDirections; "none">
<!ATTLIST presentation:hide-text presentation:speed %presentationSpeeds; "medium">
<!ATTLIST presentation:hide-text presentation:start-scale %percentage; "100&#37;">
<!ATTLIST presentation:hide-text presentation:path-id CDATA #IMPLIED >

<!ELEMENT presentation:dim (presentation:sound)?>
<!ATTLIST presentation:dim draw:shape-id CDATA #REQUIRED>
<!ATTLIST presentation:dim draw:color %color; #REQUIRED>

<!ELEMENT presentation:play EMPTY>
<!ATTLIST presentation:play draw:shape-id CDATA #REQUIRED>
<!ATTLIST presentation:play presentation:speed %presentationSpeeds; "medium">

<!ELEMENT presentation:animations (presentation:show-shape|presentation:show-text|presentation:hide-shape|presentation:hide-text|presentation:dim|presentation:play)*>

<!ELEMENT presentation:show EMPTY>
<!ATTLIST presentation:show presentation:name %styleName; #REQUIRED>
<!ATTLIST presentation:show presentation:pages CDATA #REQUIRED>

<!ELEMENT presentation:settings (presentation:show)*>
<!ATTLIST presentation:settings presentation:start-page %styleName; #IMPLIED>
<!ATTLIST presentation:settings presentation:show %styleName; #IMPLIED>
<!ATTLIST presentation:settings presentation:full-screen %boolean; "true">
<!ATTLIST presentation:settings presentation:endless %boolean; "false">
<!ATTLIST presentation:settings presentation:pause %timeDuration; #IMPLIED>
<!ATTLIST presentation:settings presentation:show-logo %boolean; "false">
<!ATTLIST presentation:settings presentation:force-manual %boolean; "false">
<!ATTLIST presentation:settings presentation:mouse-visible %boolean; "true">
<!ATTLIST presentation:settings presentation:mouse-as-pen %boolean; "false">
<!ATTLIST presentation:settings presentation:start-with-navigator %boolean; "false">
<!ATTLIST presentation:settings presentation:animations (enabled|disabled) "enabled">
<!ATTLIST presentation:settings presentation:stay-on-top %boolean; "false">
<!ATTLIST presentation:settings presentation:transition-on-click (enabled|disabled) "enabled">

<!-- Drawing page -->
<!ELEMENT draw:page (office:forms?,(%shapes;)*,presentation:animations?,presentation:notes?)>
<!ATTLIST draw:page draw:name %string; #IMPLIED>
<!ATTLIST draw:page draw:style-name %styleName; #IMPLIED>
<!ATTLIST draw:page draw:master-page-name %styleName; #REQUIRED>
<!ATTLIST draw:page presentation:presentation-page-layout-name %styleName; #IMPLIED>
<!ATTLIST draw:page draw:id %nonNegativeInteger; #IMPLIED>
<!ATTLIST draw:page xlink:href %uriReference; #IMPLIED>
<!ATTLIST draw:page xlink:type (simple) #IMPLIED>
<!ATTLIST draw:page xlink:show (replace) #IMPLIED>
<!ATTLIST draw:page xlink:actuate (onRequest) #IMPLIED>

<!-- Presentation notes -->
<!ELEMENT presentation:notes (%shapes;)*>
<!ATTLIST presentation:notes style:page-master-name %styleName; #IMPLIED>
<!ATTLIST presentation:notes draw:style-name %styleName; #IMPLIED>

<!-- presentation page layouts -->
<!ELEMENT style:presentation-page-layout (presentation:placeholder)* >
<!ATTLIST style:presentation-page-layout style:name %styleName; #REQUIRED>
<!ELEMENT presentation:placeholder EMPTY >
<!ATTLIST presentation:placeholder presentation:object (title|outline|subtitle|text|graphic|object|chart|orgchart|page|notes|handout) #REQUIRED>
<!ATTLIST presentation:placeholder svg:x %coordinateOrPercentage; #REQUIRED>
<!ATTLIST presentation:placeholder svg:y %coordinateOrPercentage; #REQUIRED>
<!ATTLIST presentation:placeholder svg:width %lengthOrPercentage; #REQUIRED>
<!ATTLIST presentation:placeholder svg:height %lengthOrPercentage; #REQUIRED>

<!-- presentation page attributes -->
<!ATTLIST style:properties presentation:transition-type (manual|automatic|semi-automatic) #IMPLIED >
<!ATTLIST style:properties presentation:transition-style (none|fade-from-left|fade-from-top|fade-from-right|fade-from-bottom|fade-to-center|fade-from-center|move-from-left|move-from-top|move-from-right|move-from-bottom|roll-from-top|roll-from-left|roll-from-right|roll-from-bottom|vertical-stripes|horizontal-stripes|clockwise|counterclockwise|fade-from-upperleft|fade-from-upperright|fade-from-lowerleft|fade-from-lowerright|close-vertical|close-horizontal|open-vertical|open-horizontal|spiralin-left|spiralin-right|spiralout-left|spiralout-right|dissolve|wavyline-from-left|wavyline-from-top|wavyline-from-right|wavyline-from-bottom|random|stretch-from-left|stretch-from-top|stretch-from-right|stretch-from-bottom|vertical-lines|horizontal-lines) #IMPLIED >
<!ATTLIST style:properties presentation:transition-speed %presentationSpeeds; #IMPLIED >
<!ATTLIST style:properties presentation:duration %timeDuration; #IMPLIED>
<!ATTLIST style:properties presentation:visibility (visible|hidden) #IMPLIED>
<!ATTLIST style:properties draw:background-size (full|border) #IMPLIED>
<!ATTLIST style:properties presentation:background-objects-visible %boolean; #IMPLIED>
<!ATTLIST style:properties presentation:background-visible %boolean; #IMPLIED>


<!-- text boxes -->
<!ELEMENT draw:text-box (office:events?,draw:image-map?,
		%sectionText;)>
<!ATTLIST draw:text-box %draw-style-name;>
<!ATTLIST draw:text-box %draw-transform; >
<!ATTLIST draw:text-box draw:name %string; #IMPLIED>
<!ATTLIST draw:text-box draw:chain-next-name %string; #IMPLIED>

<!ATTLIST draw:text-box %text-anchor;>
<!ATTLIST draw:text-box %draw-position;>
<!ATTLIST draw:text-box %draw-end-position; >
<!ATTLIST draw:text-box %table-background; >
<!ATTLIST draw:text-box svg:width %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:text-box svg:height %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:text-box style:rel-width %percentage; #IMPLIED>
<!ATTLIST draw:text-box style:rel-height %percentage; #IMPLIED>
<!ATTLIST draw:text-box fo:min-height %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:text-box %zindex;>
<!ATTLIST draw:text-box %presentation-class; >
<!ATTLIST draw:text-box draw:id %draw-shape-id;>
<!ATTLIST draw:text-box draw:layer %layerName; #IMPLIED>
<!ATTLIST draw:text-box draw:corner-radius %nonNegativeLength; #IMPLIED>

<!-- image -->
<!ELEMENT draw:image (office:binary-data?,office:events?,draw:image-map?,svg:desc?,(draw:contour-polygon|draw:contour-path)?)>
<!ATTLIST draw:image %draw-transform; >
<!ATTLIST draw:image %draw-style-name;>
<!ATTLIST draw:image draw:name %string; #IMPLIED>
<!ATTLIST draw:image xlink:href %uriReference; #IMPLIED>
<!ATTLIST draw:image xlink:type (simple) #IMPLIED>
<!ATTLIST draw:image xlink:show (embed) #IMPLIED>
<!ATTLIST draw:image xlink:actuate (onLoad) #IMPLIED>
<!ATTLIST draw:image draw:filter-name %string; #IMPLIED>
<!ATTLIST draw:image %text-anchor;>
<!ATTLIST draw:image %draw-position;>
<!ATTLIST draw:image %draw-end-position; >
<!ATTLIST draw:image %table-background; >
<!ATTLIST draw:image svg:width %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:image svg:height %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:image %presentation-class; >
<!ATTLIST draw:image %zindex;>
<!ATTLIST draw:image draw:id %draw-shape-id;>
<!ATTLIST draw:image draw:layer %layerName; #IMPLIED>
<!ATTLIST draw:image style:rel-width %percentage; #IMPLIED>
<!ATTLIST draw:image style:rel-height %percentage; #IMPLIED>

<!-- objects -->
<!ELEMENT draw:thumbnail EMPTY>
<!ATTLIST draw:thumbnail xlink:href %uriReference; #REQUIRED>
<!ATTLIST draw:thumbnail xlink:type (simple) #IMPLIED>
<!ATTLIST draw:thumbnail xlink:show (embed) #IMPLIED>
<!ATTLIST draw:thumbnail xlink:actuate (onLoad) #IMPLIED>

<!ELEMENT math:math ANY> <!-- dummy (we have no MathML DTD currently)-->
<!ELEMENT draw:object (draw:thumbnail?,(office:document|math:math)?,office:events?, draw:image-map?, svg:desc?,(draw:contour-polygon|draw:contour-path)?)>
<!ATTLIST draw:object %draw-style-name;>
<!ATTLIST draw:object draw:name %string; #IMPLIED>
<!ATTLIST draw:object xlink:href %uriReference; #IMPLIED>
<!ATTLIST draw:object xlink:type (simple) #IMPLIED>
<!ATTLIST draw:object xlink:show (embed) #IMPLIED>
<!ATTLIST draw:object xlink:actuate (onLoad) #IMPLIED>
<!ATTLIST draw:object %text-anchor;>
<!ATTLIST draw:object %draw-position;>
<!ATTLIST draw:object %draw-end-position; >
<!ATTLIST draw:object %table-background; >
<!ATTLIST draw:object svg:width %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:object svg:height %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:object %presentation-class; >
<!ATTLIST draw:object %zindex;>
<!ATTLIST draw:object draw:id %draw-shape-id;>
<!ATTLIST draw:object draw:layer %layerName; #IMPLIED>
<!ATTLIST draw:object draw:notify-on-update-of-ranges %string; #IMPLIED>
<!ATTLIST draw:object style:rel-width %percentage; #IMPLIED>
<!ATTLIST draw:object style:rel-height %percentage; #IMPLIED>

<!ELEMENT draw:object-ole (office:binary-data?|office:events?|draw:image-map?|svg:desc?|draw:contour-polygon?|draw:contour-path?|draw:thumbnail?)>
<!ATTLIST draw:object-ole draw:class-id CDATA #IMPLIED>
<!ATTLIST draw:object-ole %draw-style-name;>
<!ATTLIST draw:object-ole draw:name %string; #IMPLIED>
<!ATTLIST draw:object-ole xlink:href %uriReference; #IMPLIED>
<!ATTLIST draw:object-ole xlink:type (simple) #IMPLIED>
<!ATTLIST draw:object-ole xlink:show (embed) #IMPLIED>
<!ATTLIST draw:object-ole xlink:actuate (onLoad) #IMPLIED>
<!ATTLIST draw:object-ole %text-anchor;>
<!ATTLIST draw:object-ole %draw-position;>
<!ATTLIST draw:object-ole %draw-end-position; >
<!ATTLIST draw:object-ole %table-background; >
<!ATTLIST draw:object-ole svg:width %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:object-ole svg:height %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:object-ole %presentation-class; >
<!ATTLIST draw:object-ole %zindex;>
<!ATTLIST draw:object-ole draw:id %draw-shape-id;>
<!ATTLIST draw:object-ole draw:layer %layerName; #IMPLIED>
<!ATTLIST draw:object-ole style:rel-width %percentage; #IMPLIED>
<!ATTLIST draw:object-ole style:rel-height %percentage; #IMPLIED>

<!ELEMENT svg:desc (#PCDATA)>

<!ELEMENT draw:contour-polygon EMPTY>
<!ATTLIST draw:contour-polygon svg:width %coordinate; #REQUIRED>
<!ATTLIST draw:contour-polygon svg:height %coordinate; #REQUIRED>
<!ATTLIST draw:contour-polygon %draw-viewbox;>
<!ATTLIST draw:contour-polygon draw:points %points; #REQUIRED>
<!ATTLIST draw:contour-polygon draw:recreate-on-edit %boolean; #IMPLIED>

<!ELEMENT draw:contour-path EMPTY>
<!ATTLIST draw:contour-path svg:width %coordinate; #REQUIRED>
<!ATTLIST draw:contour-path svg:height %coordinate; #REQUIRED>
<!ATTLIST draw:contour-path %draw-viewbox;>
<!ATTLIST draw:contour-path svg:d %pathData; #REQUIRED>
<!ATTLIST draw:contour-path draw:recreate-on-edit %boolean; #IMPLIED>

<!-- hyperlink -->
<!ELEMENT draw:a (draw:image|draw:text-box)>
<!ATTLIST draw:a xlink:href %uriReference; #REQUIRED>
<!ATTLIST draw:a xlink:type (simple) #FIXED "simple">
<!ATTLIST draw:a xlink:show (new|replace) #IMPLIED>
<!ATTLIST draw:a xlink:actuate (onRequest) "onRequest">
<!ATTLIST draw:a office:name %string; #IMPLIED>
<!ATTLIST draw:a office:target-frame-name %string; #IMPLIED>
<!ATTLIST draw:a office:server-map %boolean; "false">

<!-- 3d properties -->
<!ATTLIST style:properties dr3d:horizontal-segments %nonNegativeInteger; #IMPLIED>
<!ATTLIST style:properties dr3d:vertical-segments %nonNegativeInteger; #IMPLIED>
<!ATTLIST style:properties dr3d:edge-rounding %percentage; #IMPLIED>
<!ATTLIST style:properties dr3d:edge-rounding-mode (correct|attractive) #IMPLIED>
<!ATTLIST style:properties dr3d:back-scale %percentage; #IMPLIED>
<!ATTLIST style:properties dr3d:end-angle %nonNegativeInteger; #IMPLIED>
<!ATTLIST style:properties dr3d:depth %length; #IMPLIED>
<!ATTLIST style:properties dr3d:backface-culling (enabled|disabled) #IMPLIED>
<!ATTLIST style:properties dr3d:lighting-mode (standard|double-sided) #IMPLIED>
<!ATTLIST style:properties dr3d:normals-kind (object|flat|sphere) #IMPLIED>
<!ATTLIST style:properties dr3d:normals-direction (normal|inverse) #IMPLIED>
<!ATTLIST style:properties dr3d:texture-generation-mode-x (object|parallel|sphere) #IMPLIED>
<!ATTLIST style:properties dr3d:texture-generation-mode-y (object|parallel|sphere) #IMPLIED>
<!ATTLIST style:properties dr3d:texture-kind (luminance|intesity|color) #IMPLIED>
<!ATTLIST style:properties dr3d:texture-filter (enabled|disabled) #IMPLIED>
<!ATTLIST style:properties dr3d:texture-mode (replace|modulate|blend) #IMPLIED>
<!ATTLIST style:properties dr3d:ambient-color %color; #IMPLIED>
<!ATTLIST style:properties dr3d:emissive-color %color; #IMPLIED>
<!ATTLIST style:properties dr3d:specular-color %color; #IMPLIED>
<!ATTLIST style:properties dr3d:diffuse-color %color; #IMPLIED>
<!ATTLIST style:properties dr3d:shininess %percentage; #IMPLIED>
<!ATTLIST style:properties dr3d:shadow (visible|hidden) #IMPLIED>
<!ATTLIST style:properties dr3d:close-front %boolean; #IMPLIED>
<!ATTLIST style:properties dr3d:close-back %boolean; #IMPLIED>

<!ELEMENT dr3d:light EMPTY>
<!ATTLIST dr3d:light dr3d:diffuse-color %color; #IMPLIED>
<!ATTLIST dr3d:light dr3d:direction %vector3D; #REQUIRED>
<!ATTLIST dr3d:light dr3d:enabled %boolean; #IMPLIED>
<!ATTLIST dr3d:light dr3d:specular %boolean; #IMPLIED>

<!ENTITY % shapes3d "(dr3d:scene|dr3d:extrude|dr3d:sphere|dr3d:rotate|dr3d:cube)">

<!ELEMENT dr3d:cube EMPTY>
<!ATTLIST dr3d:cube dr3d:transform CDATA #IMPLIED>
<!ATTLIST dr3d:cube dr3d:min-edge %vector3D; #IMPLIED>
<!ATTLIST dr3d:cube dr3d:max-edge %vector3D; #IMPLIED>
<!ATTLIST dr3d:cube %zindex;>
<!ATTLIST dr3d:cube draw:id %draw-shape-id;>
<!ATTLIST dr3d:cube %draw-end-position; >
<!ATTLIST dr3d:cube %table-background; >
<!ATTLIST dr3d:cube %draw-style-name; >
<!ATTLIST dr3d:cube draw:layer %layerName; #IMPLIED>

<!ELEMENT dr3d:sphere EMPTY>
<!ATTLIST dr3d:sphere dr3d:transform CDATA #IMPLIED>
<!ATTLIST dr3d:sphere dr3d:center %vector3D; #IMPLIED>
<!ATTLIST dr3d:sphere dr3d:size %vector3D; #IMPLIED>
<!ATTLIST dr3d:sphere %zindex;>
<!ATTLIST dr3d:sphere draw:id %draw-shape-id;>
<!ATTLIST dr3d:sphere %draw-end-position; >
<!ATTLIST dr3d:sphere %table-background; >
<!ATTLIST dr3d:sphere %draw-style-name; >
<!ATTLIST dr3d:sphere draw:layer %layerName; #IMPLIED>

<!ELEMENT dr3d:extrude EMPTY>
<!ATTLIST dr3d:extrude dr3d:transform CDATA #IMPLIED>
<!ATTLIST dr3d:extrude %draw-viewbox;>
<!ATTLIST dr3d:extrude svg:d %pathData; #REQUIRED >
<!ATTLIST dr3d:extrude %zindex;>
<!ATTLIST dr3d:extrude draw:id %draw-shape-id;>
<!ATTLIST dr3d:extrude %draw-end-position; >
<!ATTLIST dr3d:extrude %table-background; >
<!ATTLIST dr3d:extrude %draw-style-name; >
<!ATTLIST dr3d:extrude draw:layer %layerName; #IMPLIED>

<!ELEMENT dr3d:rotate EMPTY>
<!ATTLIST dr3d:rotate dr3d:transform CDATA #IMPLIED>
<!ATTLIST dr3d:rotate %draw-viewbox;>
<!ATTLIST dr3d:rotate svg:d %pathData; #REQUIRED >
<!ATTLIST dr3d:rotate %zindex;>
<!ATTLIST dr3d:rotate draw:id %draw-shape-id;>
<!ATTLIST dr3d:rotate %draw-end-position; >
<!ATTLIST dr3d:rotate %table-background; >
<!ATTLIST dr3d:rotate %draw-style-name; >
<!ATTLIST dr3d:rotate draw:layer %layerName; #IMPLIED>

<!ELEMENT dr3d:scene (dr3d:light*,(%shapes3d;)*)>
<!ATTLIST dr3d:scene %draw-style-name; >
<!ATTLIST dr3d:scene svg:x %coordinate; #IMPLIED>
<!ATTLIST dr3d:scene svg:y %coordinate; #IMPLIED>
<!ATTLIST dr3d:scene svg:width %length; #IMPLIED>
<!ATTLIST dr3d:scene svg:height %length; #IMPLIED>
<!ATTLIST dr3d:scene dr3d:vrp %vector3D; #IMPLIED>
<!ATTLIST dr3d:scene dr3d:vpn %vector3D; #IMPLIED>
<!ATTLIST dr3d:scene dr3d:vup %vector3D; #IMPLIED>
<!ATTLIST dr3d:scene dr3d:projection (parallel|perspective) #IMPLIED>
<!ATTLIST dr3d:scene dr3d:transform CDATA #IMPLIED>
<!ATTLIST dr3d:scene dr3d:distance %length; #IMPLIED>
<!ATTLIST dr3d:scene dr3d:focal-length %length; #IMPLIED>
<!ATTLIST dr3d:scene dr3d:shadow-slant %nonNegativeInteger; #IMPLIED>
<!ATTLIST dr3d:scene dr3d:shade-mode (flat|phong|gouraud|draft) #IMPLIED>
<!ATTLIST dr3d:scene dr3d:ambient-color %color; #IMPLIED>
<!ATTLIST dr3d:scene dr3d:lighting-mode %boolean; #IMPLIED>
<!ATTLIST dr3d:scene %zindex;>
<!ATTLIST dr3d:scene draw:id %draw-shape-id;>
<!ATTLIST dr3d:scene %draw-end-position; >
<!ATTLIST dr3d:scene %table-background; >

<!-- layer -->

<!ELEMENT draw:layer-set (draw:layer*)>

<!ELEMENT draw:layer EMPTY>
<!ATTLIST draw:layer draw:name %layerName; #REQUIRED>

<!-- events -->
<!ELEMENT presentation:event (presentation:sound)?>
<!ATTLIST presentation:event %event-name;>
<!ATTLIST presentation:event presentation:action (none|previous-page|next-page|first-page|last-page|hide|stop|execute|show|verb|fade-out|sound) #REQUIRED>
<!ATTLIST presentation:event presentation:effect %presentationEffects; "none">
<!ATTLIST presentation:event presentation:direction %presentationEffectDirections; "none">
<!ATTLIST presentation:event presentation:speed %presentationSpeeds; "medium">
<!ATTLIST presentation:event presentation:start-scale %percentage; "100&#37;">
<!ATTLIST presentation:event xlink:href %uriReference; #IMPLIED>
<!ATTLIST presentation:event xlink:type (simple) #IMPLIED>
<!ATTLIST presentation:event xlink:show (embed) #IMPLIED>
<!ATTLIST presentation:event xlink:actuate (onRequest) #IMPLIED>
<!ATTLIST presentation:event presentation:verb %nonNegativeInteger; #IMPLIED>

<!-- applets -->
<!ELEMENT draw:applet (draw:thumbnail?, draw:param*, svg:desc?)>
<!ATTLIST draw:applet xlink:href %uriReference; #IMPLIED>
<!ATTLIST draw:applet xlink:type (simple) #IMPLIED>
<!ATTLIST draw:applet xlink:show (embed) #IMPLIED>
<!ATTLIST draw:applet xlink:actuate (onLoad) #IMPLIED>
<!ATTLIST draw:applet draw:code CDATA #REQUIRED>
<!ATTLIST draw:applet draw:object CDATA #IMPLIED>
<!ATTLIST draw:applet draw:archive CDATA #IMPLIED>
<!ATTLIST draw:applet draw:may-script %boolean; "false">
<!ATTLIST draw:applet draw:name CDATA #IMPLIED>
<!ATTLIST draw:applet %draw-style-name;>
<!ATTLIST draw:applet svg:width %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:applet svg:height %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:applet %zindex;>
<!ATTLIST draw:applet draw:layer %layerName; #IMPLIED>
<!ATTLIST draw:applet %draw-position;>
<!ATTLIST draw:applet %draw-end-position; >

<!-- plugins -->
<!ELEMENT draw:plugin (draw:thumbnail?, draw:param*, svg:desc?)>
<!ATTLIST draw:plugin xlink:href %uriReference; #IMPLIED>
<!ATTLIST draw:plugin xlink:type (simple) #IMPLIED>
<!ATTLIST draw:plugin xlink:show (embed) #IMPLIED>
<!ATTLIST draw:plugin xlink:actuate (onLoad) #IMPLIED>
<!ATTLIST draw:plugin draw:mime-type CDATA #IMPLIED>
<!ATTLIST draw:plugin draw:name CDATA #IMPLIED>
<!ATTLIST draw:plugin %draw-style-name;>
<!ATTLIST draw:plugin svg:width %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:plugin svg:height %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:plugin %zindex;>
<!ATTLIST draw:plugin draw:layer %layerName; #IMPLIED>
<!ATTLIST draw:plugin %draw-position;>
<!ATTLIST draw:plugin %draw-end-position; >

<!-- Parameters -->
<!ELEMENT draw:param EMPTY>
<!ATTLIST draw:param draw:name CDATA #IMPLIED>
<!ATTLIST draw:param draw:value CDATA #IMPLIED>

<!-- Floating Frames -->
<!ELEMENT draw:floating-frame (draw:thumbnail?, svg:desc?)>
<!ATTLIST draw:floating-frame xlink:href %uriReference; #IMPLIED>
<!ATTLIST draw:floating-frame xlink:type (simple) #IMPLIED>
<!ATTLIST draw:floating-frame xlink:show (embed) #IMPLIED>
<!ATTLIST draw:floating-frame xlink:actuate (onLoad) #IMPLIED>
<!ATTLIST draw:floating-frame draw:name CDATA #IMPLIED>
<!ATTLIST draw:floating-frame draw:frame-name CDATA #IMPLIED>
<!ATTLIST draw:floating-frame %draw-style-name;>
<!ATTLIST draw:floating-frame svg:width %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:floating-frame svg:height %lengthOrPercentage; #IMPLIED>
<!ATTLIST draw:floating-frame %zindex;>
<!ATTLIST draw:floating-frame draw:layer %layerName; #IMPLIED>
<!ATTLIST draw:floating-frame %draw-position;>
<!ATTLIST draw:floating-frame %draw-end-position; >

<!-- Image Maps -->
<!ELEMENT draw:image-map
	(draw:area-rectangle|draw:area-circle|draw:area-polygon)*>

<!ELEMENT draw:area-rectangle (svg:desc?,office:events?)>
<!ATTLIST draw:area-rectangle xlink:href %uriReference; #IMPLIED>
<!ATTLIST draw:area-rectangle xlink:type (simple) #IMPLIED>
<!ATTLIST draw:area-rectangle office:target-frame-name CDATA #IMPLIED>
<!ATTLIST draw:area-rectangle xlink:show (new|replace) #IMPLIED>
<!ATTLIST draw:area-rectangle office:name CDATA #IMPLIED>
<!ATTLIST draw:area-rectangle draw:nohref (nohref) #IMPLIED>
<!ATTLIST draw:area-rectangle svg:x %coordinate; #REQUIRED>
<!ATTLIST draw:area-rectangle svg:y %coordinate; #REQUIRED>
<!ATTLIST draw:area-rectangle svg:width %coordinate; #REQUIRED>
<!ATTLIST draw:area-rectangle svg:height %coordinate; #REQUIRED>

<!ELEMENT draw:area-circle (svg:desc?,office:events?)>
<!ATTLIST draw:area-circle xlink:href %uriReference; #IMPLIED>
<!ATTLIST draw:area-circle xlink:type (simple) #IMPLIED>
<!ATTLIST draw:area-circle office:target-frame-name CDATA #IMPLIED>
<!ATTLIST draw:area-circle xlink:show (new|replace) #IMPLIED>
<!ATTLIST draw:area-circle office:name CDATA #IMPLIED>
<!ATTLIST draw:area-circle draw:nohref (nohref) #IMPLIED>
<!ATTLIST draw:area-circle svg:cx %coordinate; #REQUIRED>
<!ATTLIST draw:area-circle svg:cy %coordinate; #REQUIRED>
<!ATTLIST draw:area-circle svg:r %coordinate; #REQUIRED>

<!ELEMENT draw:area-polygon (svg:desc?,office:events?)>
<!ATTLIST draw:area-polygon xlink:href %uriReference; #IMPLIED>
<!ATTLIST draw:area-polygon xlink:type (simple) #IMPLIED>
<!ATTLIST draw:area-polygon office:target-frame-name CDATA #IMPLIED>
<!ATTLIST draw:area-polygon xlink:show (new|replace) #IMPLIED>
<!ATTLIST draw:area-polygon office:name CDATA #IMPLIED>
<!ATTLIST draw:area-polygon draw:nohref (nohref) #IMPLIED>
<!ATTLIST draw:area-polygon svg:x %coordinate; #REQUIRED>
<!ATTLIST draw:area-polygon svg:y %coordinate; #REQUIRED>
<!ATTLIST draw:area-polygon svg:width %coordinate; #REQUIRED>
<!ATTLIST draw:area-polygon svg:height %coordinate; #REQUIRED>
<!ATTLIST draw:area-polygon svg:points %points; #REQUIRED>
<!ATTLIST draw:area-polygon svg:viewBox CDATA #REQUIRED>
