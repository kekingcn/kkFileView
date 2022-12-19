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

<!-- data styles -->
<!ENTITY % any-number "( number:number | number:scientific-number | number:fraction )">
<!ENTITY % number-style-content "( (number:text,(%any-number;,number:text?)?) | (%any-number;,number:text?) )">
<!ELEMENT number:number-style ( style:properties?, %number-style-content;, style:map* )>
<!ELEMENT number:number ( number:embedded-text* )>
<!ELEMENT number:scientific-number EMPTY>
<!ELEMENT number:fraction EMPTY>

<!ELEMENT number:embedded-text (#PCDATA)>
<!ATTLIST number:embedded-text number:position %integer; #REQUIRED>

<!ENTITY % currency-symbol-and-text "number:currency-symbol,number:text?">
<!ENTITY % number-and-text "number:number,number:text?">
<!ENTITY % currency-symbol-and-number "((%number-and-text;),(%currency-symbol-and-text;)?) | ((%currency-symbol-and-text;),(%number-and-text;)?)">
<!ENTITY % currency-style-content "number:text?, (%currency-symbol-and-number;)?">

<!ELEMENT number:currency-style ( style:properties?, (%currency-style-content;), style:map* )>
<!ELEMENT number:currency-symbol (#PCDATA)>
<!ATTLIST number:currency-symbol number:language CDATA #IMPLIED>
<!ATTLIST number:currency-symbol number:country CDATA #IMPLIED>

<!ENTITY % percentage-style-content "( (number:text,(%number-and-text;)?) | (%number-and-text;) )">
<!ELEMENT number:percentage-style ( style:properties?, %percentage-style-content;, style:map* )>

<!ENTITY % any-date "( number:day | number:month | number:year | number:era | number:day-of-week | number:week-of-year | number:quarter| number:hours | number:am-pm | number:minutes | number:seconds )">
<!ENTITY % date-style-content "( (number:text,(%any-date;,number:text?)+) | (%any-date;,number:text?)+ )">
<!ELEMENT number:date-style ( style:properties?, %date-style-content;, style:map* )>
<!ELEMENT number:day EMPTY>
<!ATTLIST number:day number:style (short|long) "short">
<!ATTLIST number:day number:calendar CDATA #IMPLIED>
<!ELEMENT number:month EMPTY>
<!ATTLIST number:month number:textual %boolean; "false">
<!ATTLIST number:month number:style (short|long) "short">
<!ATTLIST number:month number:calendar CDATA #IMPLIED>
<!ELEMENT number:year EMPTY>
<!ATTLIST number:year number:style (short|long) "short">
<!ATTLIST number:year number:calendar CDATA #IMPLIED>
<!ELEMENT number:era EMPTY>
<!ATTLIST number:era number:style (short|long) "short">
<!ATTLIST number:era number:calendar CDATA #IMPLIED>
<!ELEMENT number:day-of-week EMPTY>
<!ATTLIST number:day-of-week number:style (short|long) "short">
<!ATTLIST number:day-of-week number:calendar CDATA #IMPLIED>
<!ELEMENT number:week-of-year EMPTY>
<!ATTLIST number:week-of-year number:calendar CDATA #IMPLIED>
<!ELEMENT number:quarter EMPTY>
<!ATTLIST number:quarter number:style (short|long) "short">
<!ATTLIST number:quarter number:calendar CDATA #IMPLIED>

<!ENTITY % any-time "( number:hours | number:am-pm | number:minutes | number:seconds )">
<!ENTITY % time-style-content "( (number:text,(%any-time;,number:text?)+) | (%any-time;,number:text?)+)">
<!ELEMENT number:time-style ( style:properties?, %time-style-content;, style:map* )>
<!ELEMENT number:hours EMPTY>
<!ATTLIST number:hours number:style (short|long) "short">
<!ELEMENT number:minutes EMPTY>
<!ATTLIST number:minutes number:style (short|long) "short">
<!ELEMENT number:seconds EMPTY>
<!ATTLIST number:seconds number:style (short|long) "short">
<!ATTLIST number:seconds number:decimal-places %integer; "0">
<!ELEMENT number:am-pm EMPTY>

<!ENTITY % boolean-style-content "( (number:text,(number:boolean,number:text?)?) | (number:boolean,number:text?) )">
<!ELEMENT number:boolean-style ( style:properties?,%boolean-style-content;, style:map* )>
<!ELEMENT number:boolean EMPTY>

<!ENTITY % text-style-content "( (number:text,(number:text-content,number:text?)?) | (number:text-content,number:text?) )">
<!ELEMENT number:text-style ( style:properties?,%text-style-content;, style:map* )>
<!ELEMENT number:text (#PCDATA)>
<!ELEMENT number:text-content EMPTY>

<!ATTLIST number:number-style style:name %styleName; #REQUIRED>
<!ATTLIST number:currency-style style:name %styleName; #REQUIRED>
<!ATTLIST number:percentage-style style:name %styleName; #REQUIRED>
<!ATTLIST number:date-style style:name %styleName; #REQUIRED>
<!ATTLIST number:time-style style:name %styleName; #REQUIRED>
<!ATTLIST number:boolean-style style:name %styleName; #REQUIRED>
<!ATTLIST number:text-style style:name %styleName; #REQUIRED>

<!-- The style:family is redundant and therefore should not exist at all -->
<!-- Since OOo 1.0/1.1 is exporting this attribute it is an #IMPLIED    -->
<!-- one to avoid validation errors.                                    -->
<!ATTLIST number:number-style style:family CDATA #IMPLIED>
<!ATTLIST number:currency-style style:family CDATA #IMPLIED>
<!ATTLIST number:percentage-style style:family CDATA #IMPLIED>
<!ATTLIST number:date-style style:family CDATA #IMPLIED>
<!ATTLIST number:time-style style:family CDATA #IMPLIED>
<!ATTLIST number:boolean-style style:family CDATA #IMPLIED>
<!ATTLIST number:text-style style:family CDATA #IMPLIED>

<!ATTLIST number:number-style number:language CDATA #IMPLIED>
<!ATTLIST number:currency-style number:language CDATA #IMPLIED>
<!ATTLIST number:percentage-style number:language CDATA #IMPLIED>
<!ATTLIST number:date-style number:language CDATA #IMPLIED>
<!ATTLIST number:time-style number:language CDATA #IMPLIED>
<!ATTLIST number:boolean-style number:language CDATA #IMPLIED>
<!ATTLIST number:text-style number:language CDATA #IMPLIED>

<!ATTLIST number:number-style number:country CDATA #IMPLIED>
<!ATTLIST number:currency-style number:country CDATA #IMPLIED>
<!ATTLIST number:percentage-style number:country CDATA #IMPLIED>
<!ATTLIST number:date-style number:country CDATA #IMPLIED>
<!ATTLIST number:time-style number:country CDATA #IMPLIED>
<!ATTLIST number:boolean-style number:country CDATA #IMPLIED>
<!ATTLIST number:text-style number:country CDATA #IMPLIED>

<!ATTLIST number:number-style number:title CDATA #IMPLIED>
<!ATTLIST number:currency-style number:title CDATA #IMPLIED>
<!ATTLIST number:percentage-style number:title CDATA #IMPLIED>
<!ATTLIST number:date-style number:title CDATA #IMPLIED>
<!ATTLIST number:time-style number:title CDATA #IMPLIED>
<!ATTLIST number:boolean-style number:title CDATA #IMPLIED>
<!ATTLIST number:text-style number:title CDATA #IMPLIED>

<!ATTLIST number:number-style style:volatile %boolean; #IMPLIED>
<!ATTLIST number:currency-style style:volatile %boolean; #IMPLIED>
<!ATTLIST number:percentage-style style:volatile %boolean; #IMPLIED>
<!ATTLIST number:date-style style:volatile %boolean; #IMPLIED>
<!ATTLIST number:time-style style:volatile %boolean; #IMPLIED>
<!ATTLIST number:boolean-style style:volatile %boolean; #IMPLIED>
<!ATTLIST number:text-style style:volatile %boolean; #IMPLIED>

<!ATTLIST number:number-style number:transliteration-format CDATA "1">
<!ATTLIST number:currency-style number:transliteration-format CDATA "1">
<!ATTLIST number:percentage-style number:transliteration-format CDATA "1">
<!ATTLIST number:date-style number:transliteration-format CDATA "1">
<!ATTLIST number:time-style number:transliteration-format CDATA "1">
<!ATTLIST number:boolean-style number:transliteration-format CDATA "1">
<!ATTLIST number:text-style number:transliteration-format CDATA "1">

<!ATTLIST number:number-style number:transliteration-language CDATA #IMPLIED>
<!ATTLIST number:currency-style number:transliteration-language CDATA #IMPLIED>
<!ATTLIST number:percentage-style number:transliteration-language CDATA #IMPLIED>
<!ATTLIST number:date-style number:transliteration-language CDATA #IMPLIED>
<!ATTLIST number:time-style number:transliteration-language CDATA #IMPLIED>
<!ATTLIST number:boolean-style number:transliteration-language CDATA #IMPLIED>
<!ATTLIST number:text-style number:transliteration-language CDATA #IMPLIED>

<!ATTLIST number:number-style number:transliteration-country CDATA #IMPLIED>
<!ATTLIST number:currency-style number:transliteration-country CDATA #IMPLIED>
<!ATTLIST number:percentage-style number:transliteration-country CDATA #IMPLIED>
<!ATTLIST number:date-style number:transliteration-country CDATA #IMPLIED>
<!ATTLIST number:time-style number:transliteration-country CDATA #IMPLIED>
<!ATTLIST number:boolean-style number:transliteration-country CDATA #IMPLIED>
<!ATTLIST number:text-style number:transliteration-country CDATA #IMPLIED>

<!ATTLIST number:number-style number:transliteration-style (short|medium|long) "short">
<!ATTLIST number:currency-style number:transliteration-style (short|medium|long) "short">
<!ATTLIST number:percentage-style number:transliteration-style (short|medium|long) "short">
<!ATTLIST number:date-style number:transliteration-style (short|medium|long) "short">
<!ATTLIST number:time-style number:transliteration-style (short|medium|long) "short">
<!ATTLIST number:boolean-style number:transliteration-style (short|medium|long) "short">
<!ATTLIST number:text-style number:transliteration-style (short|medium|long) "short">

<!ATTLIST number:currency-style number:automatic-order %boolean; "false">
<!ATTLIST number:date-style number:automatic-order %boolean; "false">

<!ATTLIST number:date-style number:format-source (fixed|language) "fixed">
<!ATTLIST number:time-style number:format-source (fixed|language) "fixed">

<!ATTLIST number:time-style number:truncate-on-overflow %boolean; "true">

<!ATTLIST number:number number:decimal-places %integer; #IMPLIED>
<!ATTLIST number:scientific-number number:decimal-places %integer; #IMPLIED>

<!ATTLIST number:number number:min-integer-digits %integer; #IMPLIED>
<!ATTLIST number:scientific-number number:min-integer-digits %integer; #IMPLIED>
<!ATTLIST number:fraction number:min-integer-digits %integer; #IMPLIED>

<!ATTLIST number:number number:grouping %boolean; "false">
<!ATTLIST number:scientific-number number:grouping %boolean; "false">
<!ATTLIST number:fraction number:grouping %boolean; "false">

<!ATTLIST number:number number:decimal-replacement CDATA #IMPLIED>

<!ATTLIST number:number number:display-factor %float; "1">

<!ATTLIST number:scientific-number number:min-exponent-digits %integer; #IMPLIED>

<!ATTLIST number:fraction number:min-numerator-digits %integer; #IMPLIED>

<!ATTLIST number:fraction number:min-denominator-digits %integer; #IMPLIED>
