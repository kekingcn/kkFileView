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

<!ELEMENT office:settings (config:config-item-set+)>

<!ENTITY % items	"(config:config-item |
			config:config-item-set |
			config:config-item-map-named |
			config:config-item-map-indexed)+">

<!ELEMENT config:config-item-set %items;>
<!ATTLIST config:config-item-set config:name CDATA #REQUIRED>

<!ELEMENT config:config-item (#PCDATA)>
<!ATTLIST config:config-item config:name CDATA #REQUIRED
			config:type (boolean | short | int | long | double | string | datetime | base64Binary) #REQUIRED>

<!ELEMENT config:config-item-map-named (config:config-item-map-entry)+>
<!ATTLIST config:config-item-map-named config:name CDATA #REQUIRED>

<!ELEMENT config:config-item-map-indexed (config:config-item-map-entry)+>
<!ATTLIST config:config-item-map-indexed config:name CDATA #REQUIRED>

<!ELEMENT config:config-item-map-entry %items;>
<!ATTLIST config:config-item-map-entry config:name CDATA #IMPLIED>
