/*
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
 */

<%

public const cnRefreshTime  = 5    ' refresh time in seconds

' filename for file with all pictures and file containing the name of the current picture
public const csFilePicture= "picture.txt"
public const csFileCurrent= "currpic.txt"

' constants for file-access
const ForReading    =  1
const ForWriting    =  2

' new-line delimiter
Dim FILE_LINE_DELIMITER
FILE_LINE_DELIMITER = vbCRLF

'/**
' * Get data from file using a given separator.
' */
function File_getDataVirtual( sFilename, sServerPath, sSeparator )
    call Err.Clear()

    Dim aFSObject, sServerFileName

    Set aFSObject = CreateObject("Scripting.FileSystemObject")
    sServerFileName = aFSObject.BuildPath( Server.MapPath( sServerPath ), sFileName )

    File_getDataVirtual = ""
    if Err.Number = 0 then
        File_getDataVirtual = File_read( sServerFileName )
        If Not IsNull(File_getDataVirtual) Then
            File_getDataVirtual = Replace( File_getDataVirtual, FILE_LINE_DELIMITER, sSeparator)
            File_getDataVirtual = Split( File_getDataVirtual, sSeparator)
        End If
    end if
end function

'/**
' * Get data from a file
' */
function File_read( sFilename )
    call Err.Clear()

    Dim aFSObject, aStream

    Set aFSObject = CreateObject( "Scripting.FileSystemObject" )
    Set aStream = aFSObject.OpenTextFile( sFilename, ForReading )

    while not aStream.AtEndOfStream
        File_read = File_read + aStream.ReadLine + FILE_LINE_DELIMITER
    wend

    aStream.Close
end function

'/**
' * Get data from a file given by filename and virtual pathname
' */
Function File_readVirtual(sFileName, sServerPath)
    call Err.Clear()

    Dim aFSObject, sServerFileName

    Set aFSObject = CreateObject("Scripting.FileSystemObject")
    sServerFileName = aFSObject.BuildPath( Server.MapPath( sServerPath ), sFileName )

    File_readVirtual = ""
    if Err.Number = 0 then
        File_readVirtual = File_read( sServerFileName )
    end if
End Function

'/**
' * Write data to a file
' */
function File_write( sFileName, sText )
    call Err.Clear()

    Dim aFSObject, aFile

    Set aFSObject = CreateObject( "Scripting.FileSystemObject" )
    if Err.Number = 0 then
        Set aFile = aFSObject.CreateTextFile( sFileName, TRUE )
        if Err.Number = 0 then
            aFile.Write( sText )
            aFile.Close
        end if
    end if

    File_write = ( Err.Number = 0 )
end function

'/**
' * Write data to a file given by filename and virtual pathname
' */
function File_writeVirtual( sFileName, sServerPath, sText )
    call Err.Clear()

    Dim aFSObject, aServerFile

    Set aFSObject = CreateObject( "Scripting.FileSystemObject" )
    aServerFile = aFSObject.BuildPath( Server.MapPath( sServerPath ), sFileName )

    If Err.Number = 0 Then
        File_writeVirtual = File_write( aServerFile, sText )
    else
        File_writeVirtual = false
    End If
end function
%>