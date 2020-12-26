<!--***********************************************************
 * 
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 * 
 ***********************************************************-->



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
