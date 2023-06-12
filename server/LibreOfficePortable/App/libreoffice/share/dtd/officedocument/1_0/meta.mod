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

<!ELEMENT meta:generator (%cString;)>

<!ELEMENT dc:title (%cString;)>

<!ELEMENT dc:description (%cString;)>

<!ELEMENT dc:subject (%cString;)>

<!ELEMENT meta:keywords (meta:keyword)*>
<!ELEMENT meta:keyword (%cString;)>

<!ELEMENT meta:initial-creator (%cString;)>

<!ELEMENT dc:creator (%cString;)>

<!ELEMENT meta:printed-by (%cString;)>

<!ELEMENT meta:creation-date (%cTimeInstance;)>

<!ELEMENT dc:date (%cTimeInstance;)>

<!ELEMENT meta:print-date (%cTimeInstance;)>

<!ELEMENT meta:template EMPTY>
<!ATTLIST meta:template xlink:type (simple) #FIXED "simple">
<!ATTLIST meta:template xlink:actuate (onRequest) "onRequest">
<!ATTLIST meta:template xlink:href %uriReference; #REQUIRED>
<!ATTLIST meta:template xlink:title %string; #IMPLIED>
<!ATTLIST meta:template meta:date %timeInstance; #IMPLIED>

<!ELEMENT meta:auto-reload EMPTY>
<!ATTLIST meta:auto-reload xlink:type (simple) #IMPLIED>
<!ATTLIST meta:auto-reload xlink:show (replace) #IMPLIED>
<!ATTLIST meta:auto-reload xlink:actuate (onLoad) #IMPLIED>
<!ATTLIST meta:auto-reload xlink:href %uriReference; #IMPLIED>
<!ATTLIST meta:auto-reload meta:delay %timeDuration; "P0S">

<!ELEMENT meta:hyperlink-behaviour EMPTY>
<!ATTLIST meta:hyperlink-behaviour office:target-frame-name %targetFrameName; #IMPLIED>
<!ATTLIST meta:hyperlink-behaviour xlink:show (new|replace) #IMPLIED>

<!ELEMENT dc:language (%cLanguage;)>

<!ELEMENT meta:editing-cycles (%cPositiveInteger;)>

<!ELEMENT meta:editing-duration (%cTimeDuration;)>

<!ELEMENT meta:user-defined (%cString;)>
<!ATTLIST meta:user-defined meta:name %string; #REQUIRED>

<!ELEMENT meta:document-statistic EMPTY>
<!ATTLIST meta:document-statistic meta:page-count %positiveInteger; #IMPLIED
	meta:table-count %nonNegativeInteger; #IMPLIED
	meta:draw-count %nonNegativeInteger; #IMPLIED
	meta:image-count %nonNegativeInteger; #IMPLIED
	meta:ole-object-count %nonNegativeInteger; #IMPLIED
	meta:paragraph-count %nonNegativeInteger; #IMPLIED
	meta:word-count %nonNegativeInteger; #IMPLIED
	meta:character-count %nonNegativeInteger; #IMPLIED
	meta:row-count %nonNegativeInteger; #IMPLIED
	meta:cell-count %nonNegativeInteger; #IMPLIED
	meta:object-count %positiveInteger; #IMPLIED>
