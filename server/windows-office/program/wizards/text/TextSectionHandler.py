#
# This file is part of the LibreOffice project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This file incorporates work covered by the following license notice:
#
#   Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements. See the NOTICE file distributed
#   with this work for additional information regarding copyright
#   ownership. The ASF licenses this file to you under the Apache
#   License, Version 2.0 (the "License"); you may not use this file
#   except in compliance with the License. You may obtain a copy of
#   the License at http://www.apache.org/licenses/LICENSE-2.0 .
#
import uno
import traceback

class TextSectionHandler(object):
    '''Creates a new instance of TextSectionHandler'''
    def __init__(self, xMSF, xTextDocument):
        self.xMSFDoc = xMSF
        self.xTextDocument = xTextDocument
        self.xText = xTextDocument.Text

    def removeTextSectionbyName(self, SectionName):
        try:
            xAllTextSections = self.xTextDocument.TextSections
            if xAllTextSections.hasByName(SectionName):
                oTextSection = self.xTextDocument.TextSections.getByName(
                    SectionName)
                self.removeTextSection(oTextSection)


        except Exception:
            traceback.print_exc()

    def hasTextSectionByName(self, SectionName):
        xAllTextSections = self.xTextDocument.TextSections
        return xAllTextSections.hasByName(SectionName)

    def removeTextSection(self, _oTextSection):
        try:
            self.xText.removeTextContent(_oTextSection)
        except Exception:
            traceback.print_exc()

    def removeAllTextSections(self):
        try:
            TextSectionCount = self.xTextDocument.TextSections.Count
            xAllTextSections = self.xTextDocument.TextSections
            for i in range(TextSectionCount - 1, -1, -1):
                xTextContentTextSection = xAllTextSections.getByIndex(i)
                self.xText.removeTextContent(xTextContentTextSection)
        except Exception:
            traceback.print_exc()

    def breakLinkOfTextSection(self, oTextSection):
        try:
            oSectionLink = \
                uno.createUnoStruct('com.sun.star.text.SectionFileLink')
            oSectionLink.FileURL = ""
            uno.invoke(oTextSection, "setPropertyValues",
                (("FileLink", "LinkRegion"), (oSectionLink, "")))
        except Exception:
            traceback.print_exc()

    def linkSectiontoTemplate(
            self, TemplateName, SectionName, oTextSection=None):
        try:
            if not oTextSection:
                oTextSection = self.xTextDocument.TextSections.getByName(
                    SectionName)
            oSectionLink = \
                uno.createUnoStruct('com.sun.star.text.SectionFileLink')
            oSectionLink.FileURL = TemplateName
            uno.invoke(oTextSection, "setPropertyValues",
                (("FileLink", "LinkRegion"), (oSectionLink, SectionName)))

            NewSectionName = oTextSection.Name
            if NewSectionName is not SectionName:
                oTextSection.Name = SectionName
        except Exception:
            traceback.print_exc()

    def insertTextSection(self, GroupName, TemplateName, _bAddParagraph):
        try:
            if _bAddParagraph:
                xTextCursor = self.xText.createTextCursor()
                self.xText.insertControlCharacter(
                    xTextCursor, ControlCharacter.PARAGRAPH_BREAK, False)
                xTextCursor.collapseToEnd()

            xSecondTextCursor = self.xText.createTextCursor()
            xSecondTextCursor.gotoEnd(False)
            insertTextSection(GroupName, TemplateName, xSecondTextCursor)
        except Exception:
            traceback.print_exc()

    def insertTextSection(self, sectionName, templateName, position):
        try:
            if self.xTextDocument.TextSections.hasByName(sectionName):
                xTextSection = \
                    self.xTextDocument.TextSections.getByName(sectionName)
            else:
                xTextSection = self.xMSFDoc.createInstance(
                    "com.sun.star.text.TextSection")
                position.getText().insertTextContent(
                    position, xTextSection, False)

            linkSectiontoTemplate(xTextSection, templateName, sectionName)
        except Exception:
            traceback.print_exc()

