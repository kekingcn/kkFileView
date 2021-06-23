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
from ..text.TextDocument import TextDocument, traceback, \
    TextFieldHandler, Configuration
from ..text.TextSectionHandler import TextSectionHandler

from com.sun.star.table import BorderLine
from com.sun.star.text.ControlCharacter import PARAGRAPH_BREAK
from com.sun.star.style.ParagraphAdjust import CENTER
from com.sun.star.text.PageNumberType import CURRENT
from com.sun.star.style.NumberingType import ARABIC
from com.sun.star.text.HoriOrientation import NONE as NONEHORI
from com.sun.star.text.VertOrientation import NONE as NONEVERT
from com.sun.star.text.RelOrientation import PAGE_FRAME
from com.sun.star.text.TextContentAnchorType import AT_PAGE
from com.sun.star.text.SizeType import FIX
from com.sun.star.text.WrapTextMode import THROUGH
from com.sun.star.awt.FontWeight import BOLD
from com.sun.star.beans import UnknownPropertyException

class LetterDocument(TextDocument):

    def __init__(self, xMSF, listener):
        super(LetterDocument,self).__init__(xMSF, listener, None,
            "WIZARD_LIVE_PREVIEW")
        self.keepLogoFrame = True
        self.keepBendMarksFrame = True
        self.keepLetterSignsFrame = True
        self.keepSenderAddressRepeatedFrame = True
        self.keepAddressFrame = True

    def switchElement(self, sElement, bState):
        try:
            mySectionHandler = TextSectionHandler(
                self.xMSF, self.xTextDocument)
            oSection = \
                mySectionHandler.xTextDocument.TextSections.getByName(sElement)
            oSection.IsVisible = bState
        except Exception:
            traceback.print_exc()

    def updateDateFields(self):
        FH = TextFieldHandler(
            self.xTextDocument, self.xTextDocument)
        FH.updateDateFields()

    def switchFooter(self, sPageStyle, bState, bPageNumber, sText):
        if self.xTextDocument is not None:
            try:
                self.xTextDocument.lockControllers()
                xNameAccess = self.xTextDocument.StyleFamilies
                xPageStyleCollection = xNameAccess.getByName("PageStyles")
                xPageStyle = xPageStyleCollection.getByName(sPageStyle)
                if bState:
                    xPageStyle.FooterIsOn = True
                    xFooterText = xPageStyle.FooterText
                    xFooterText.String = sText
                    if bPageNumber:
                        #Adding the Page Number
                        myCursor = xFooterText.Text.createTextCursor()
                        myCursor.gotoEnd(False)
                        xFooterText.insertControlCharacter(myCursor,
                            PARAGRAPH_BREAK, False)
                        myCursor.setPropertyValue("ParaAdjust", CENTER )

                        xPageNumberField = \
                            self.xTextDocument.createInstance(
                                "com.sun.star.text.TextField.PageNumber")
                        xPageNumberField.setPropertyValue("SubType", CURRENT)
                        xPageNumberField.NumberingType = ARABIC
                        xFooterText.insertTextContent(xFooterText.End,
                            xPageNumberField, False)

                else:
                    xPageStyle.FooterIsOn = False

                self.xTextDocument.unlockControllers()
            except Exception:
                traceback.print_exc()

    def hasElement(self, sElement):
        if self.xTextDocument is not None:
            SH = TextSectionHandler(self.xMSF, self.xTextDocument)
            return SH.hasTextSectionByName(sElement)
        else:
            return False

    def switchUserField(self, sFieldName, sNewContent, bState):
        myFieldHandler = TextFieldHandler(
            self.xMSF, self.xTextDocument)
        if bState:
            myFieldHandler.changeUserFieldContent(sFieldName, sNewContent)
        else:
            myFieldHandler.changeUserFieldContent(sFieldName, "")

    def fillSenderWithUserData(self):
        try:
            myFieldHandler = TextFieldHandler(
                self.xTextDocument, self.xTextDocument)
            oUserDataAccess = Configuration.getConfigurationRoot(
                self.xMSF, "org.openoffice.UserProfile/Data", False)
            myFieldHandler.changeUserFieldContent(
                "Company", oUserDataAccess.getByName("o"))
            myFieldHandler.changeUserFieldContent(
                "Street", oUserDataAccess.getByName("street"))
            myFieldHandler.changeUserFieldContent(
                "PostCode", oUserDataAccess.getByName("postalcode"))
            myFieldHandler.changeUserFieldContent(
                "City", oUserDataAccess.getByName("l"))
            myFieldHandler.changeUserFieldContent(
                "State", oUserDataAccess.getByName("st"))
        except Exception:
            traceback.print_exc()

    def killEmptyUserFields(self):
        myFieldHandler = TextFieldHandler(
            self.xMSF, self.xTextDocument)
        myFieldHandler.removeUserFieldByContent()

    def killEmptyFrames(self):
        try:
            if not self.keepLogoFrame:
                xTF = self.getFrameByName(
                    "Company Logo", self.xTextDocument)
                if xTF is not None:
                    xTF.dispose()

            if not self.keepBendMarksFrame:
                xTF = self.getFrameByName(
                    "Bend Marks", self.xTextDocument)
                if xTF is not None:
                    xTF.dispose()

            if not self.keepLetterSignsFrame:
                xTF = self.getFrameByName(
                    "Letter Signs", self.xTextDocument)
                if xTF is not None:
                    xTF.dispose()

            if not self.keepSenderAddressRepeatedFrame:
                xTF = self.getFrameByName(
                    "Sender Address Repeated", self.xTextDocument)
                if xTF is not None:
                    xTF.dispose()

            if not self.keepAddressFrame:
                xTF = self.getFrameByName(
                    "Sender Address", self.xTextDocument)
                if xTF is not None:
                    xTF.dispose()

        except Exception:
            traceback.print_exc()

class BusinessPaperObject(object):

    def __init__(self, xTextDocument, FrameText, Width, Height, XPos, YPos):
        self.xTextDocument = xTextDocument
        self.iWidth = Width
        self.iHeight = Height
        self.iXPos = XPos
        self.iYPos = YPos
        self.xFrame = None
        try:
            self.xFrame = \
                self.xTextDocument.createInstance(
                    "com.sun.star.text.TextFrame")
            self.setFramePosition()
            self.xFrame.AnchorType = AT_PAGE
            self.xFrame.SizeType = FIX

            self.xFrame.TextWrap = THROUGH
            self.xFrame.Opaque = True
            self.xFrame.BackColor = 15790320

            myBorder = BorderLine()
            myBorder.OuterLineWidth = 0
            self.xFrame.LeftBorder = myBorder
            self.xFrame.RightBorder = myBorder
            self.xFrame.TopBorder = myBorder
            self.xFrame.BottomBorder = myBorder
            self.xFrame.Print = False
            xTextCursor = \
                self.xTextDocument.Text.createTextCursor()
            xTextCursor.gotoEnd(True)
            xText = self.xTextDocument.Text
            xText.insertTextContent(
                xTextCursor, self.xFrame,
                False)

            xFrameText = self.xFrame.Text
            xFrameCursor = xFrameText.createTextCursor()
            xFrameCursor.setPropertyValue("CharWeight", BOLD)
            xFrameCursor.setPropertyValue("CharColor", 16777215)
            xFrameCursor.setPropertyValue("CharFontName", "Albany")
            xFrameCursor.setPropertyValue("CharHeight", 18)

            xFrameText.insertString(xFrameCursor, FrameText, False)
        except Exception:
            traceback.print_exc()

    def setFramePosition(self):
        try:
            self.xFrame.HoriOrient = NONEHORI
            self.xFrame.VertOrient = NONEVERT
            self.xFrame.Height = self.iHeight
            self.xFrame.Width = self.iWidth
            self.xFrame.HoriOrientPosition = self.iXPos
            self.xFrame.VertOrientPosition = self.iYPos
            self.xFrame.HoriOrientRelation = PAGE_FRAME
            self.xFrame.VertOrientRelation = PAGE_FRAME
        except Exception:
            traceback.print_exc()

    def removeFrame(self):
        if self.xFrame is not None:
            try:
                self.xTextDocument.Text.removeTextContent(
                    self.xFrame)
            except UnknownPropertyException:
                pass
            except Exception:
                traceback.print_exc()
