;Copyright (C) 2004-2017 John T. Haller of PortableApps.com

;Website: http://PortableApps.com/go/LibreOfficePortable

;This software is OSI Certified Open Source Software.
;OSI Certified is a certification mark of the Open Source Initiative.

;This program is free software; you can redistribute it and/or
;modify it under the terms of the GNU General Public License
;as published by the Free Software Foundation; either version 2
;of the License, or (at your option) any later version.

;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with this program; if not, write to the Free Software
;Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

!define NAME "LibreOfficeBasePortable"
!define FRIENDLYNAME "LibreOffice  Base Portable"
!define APP "LibreOfficeBase"
!define VER "2.0.0.0"
!define WEBSITE "PortableApps.com/LibreOfficePortable"
!define EXECTHIS "LibreOfficePortable.exe -base"

;=== Program Details
Name "${FRIENDLYNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${FRIENDLYNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${FRIENDLYNAME}"
VIAddVersionKey Comments "Allows ${APP} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "John T. Haller"
VIAddVersionKey FileDescription "${FRIENDLYNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${FRIENDLYNAME}"
VIAddVersionKey LegalTrademarks "PortableApps.com is a Trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "${NAME}.exe"
;VIAddVersionKey PrivateBuild ""
;VIAddVersionKey SpecialBuild ""


;=== Runtime Switches
CRCCheck On
WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user
Unicode true
ManifestDPIAware true

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
;(Standard NSIS)
!include FileFunc.nsh
!insertmacro GetParameters

;=== Program Icon
Icon "..\..\App\AppInfo\appicon1.ico"

Var EXECSTRING

Section "Main"
	StrCpy $EXECSTRING "${EXECTHIS}"

	;=== Get any passed parameters
	SetOutPath $EXEDIR
	${GetParameters} $0
	StrCmp "'$0'" "''" "" LaunchProgramParameters

	;=== No parameters
	StrCpy $EXECSTRING `${EXECTHIS}`
	Goto LaunchNow

	LaunchProgramParameters:
		StrCpy $EXECSTRING `${EXECTHIS} $0`

	LaunchNow:
		Exec $EXECSTRING
SectionEnd