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
import time
from datetime import date as dateTimeObject
from .TextFieldHandler import TextFieldHandler
from ..document.OfficeDocument import OfficeDocument
from ..common.Desktop import Desktop
from ..common.Configuration import Configuration
from ..common.NumberFormatter import NumberFormatter

from com.sun.star.i18n.NumberFormatIndex import DATE_SYS_DDMMYY
from com.sun.star.view.DocumentZoomType import ENTIRE_PAGE
from com.sun.star.beans.PropertyState import DIRECT_VALUE

class TextDocument(object):

    def __init__(self, xMSF,listener=None,bShowStatusIndicator=None,
        FrameName=None,_sPreviewURL=None,_moduleIdentifier=None,
        _textDocument=None, xArgs=None):

        self.xMSF = xMSF
        self.xTextDocument = None

        if listener is not None:
            if FrameName is not None:
                '''creates an instance of TextDocument
                and creates a named frame.
                No document is actually loaded into this frame.'''
                self.xFrame = OfficeDocument.createNewFrame(
                    xMSF, listener, FrameName)
                return

            elif _sPreviewURL is not None:
                '''creates an instance of TextDocument by
                loading a given URL as preview'''
                self.xFrame = OfficeDocument.createNewFrame(xMSF, listener)
                self.xTextDocument = self.loadAsPreview(_sPreviewURL, True)

            elif xArgs is not None:
                '''creates an instance of TextDocument
                and creates a frame and loads a document'''
                self.xDesktop = Desktop.getDesktop(xMSF);
                self.xFrame = OfficeDocument.createNewFrame(xMSF, listener)
                self.xTextDocument = OfficeDocument.load(
                    self.xFrame, URL, "_self", xArgs);
                self.xWindowPeer = self.xFrame.getComponentWindow()
                self.m_xDocProps = self.xTextDocument.DocumentProperties
                CharLocale = self.xTextDocument.CharLocale
                return

            else:
                '''creates an instance of TextDocument from
                the desktop's current frame'''
                self.xDesktop = Desktop.getDesktop(xMSF);
                self.xFrame = self.xDesktop.getActiveFrame()
                self.xTextDocument = self.xFrame.getController().Model

        elif _moduleIdentifier is not None:
            try:
                '''create the empty document, and set its module identifier'''
                self.xTextDocument = xMSF.createInstance(
                    "com.sun.star.text.TextDocument")
                self.xTextDocument.initNew()
                self.xTextDocument.setIdentifier(
                    _moduleIdentifier.Identifier)
                # load the document into a blank frame
                xDesktop = Desktop.getDesktop(xMSF)
                loadArgs = list(range(1))
                loadArgs[0] = "Model"
                loadArgs[0] = -1
                loadArgs[0] = self.xTextDocument
                loadArgs[0] = DIRECT_VALUE
                xDesktop.loadComponentFromURL(
                    "private:object", "_blank", 0, loadArgs)
                # remember some things for later usage
                self.xFrame = self.xTextDocument.CurrentController.Frame
            except Exception:
                traceback.print_exc()

        elif _textDocument is not None:
            '''creates an instance of TextDocument
            from a given XTextDocument'''
            self.xFrame = _textDocument.CurrentController.Frame
            self.xTextDocument = _textDocument
        if bShowStatusIndicator:
            self.showStatusIndicator()
        self.init()

    def init(self):
        self.xWindowPeer = self.xFrame.getComponentWindow()
        self.m_xDocProps = self.xTextDocument.DocumentProperties
        self.CharLocale = self.xTextDocument.CharLocale
        self.xText = self.xTextDocument.Text

    def showStatusIndicator(self):
        self.xProgressBar = self.xFrame.createStatusIndicator()
        self.xProgressBar.start("", 100)
        self.xProgressBar.setValue(5)

    def loadAsPreview(self, sDefaultTemplate, asTemplate):
        loadValues = list(range(3))
        #      open document in the Preview mode
        loadValues[0] = uno.createUnoStruct(
            'com.sun.star.beans.PropertyValue')
        loadValues[0].Name = "ReadOnly"
        loadValues[0].Value = True
        loadValues[1] = uno.createUnoStruct(
            'com.sun.star.beans.PropertyValue')
        loadValues[1].Name = "AsTemplate"
        if asTemplate:
            loadValues[1].Value = True
        else:
            loadValues[1].Value = False

        loadValues[2] = uno.createUnoStruct(
            'com.sun.star.beans.PropertyValue')
        loadValues[2].Name = "Preview"
        loadValues[2].Value = True

        self.xTextDocument = OfficeDocument.load(
            self.xFrame, sDefaultTemplate, "_self", loadValues)

        self.DocSize = self.getPageSize()

        try:
            self.xTextDocument.CurrentController.ViewSettings.ZoomType = ENTIRE_PAGE
        except Exception:
            traceback.print_exc()
        myFieldHandler = TextFieldHandler(self.xMSF, self.xTextDocument)
        myFieldHandler.updateDocInfoFields()
        return self.xTextDocument

    def getPageSize(self):
        try:
            xNameAccess = self.xTextDocument.StyleFamilies
            xPageStyleCollection = xNameAccess.getByName("PageStyles")
            xPageStyle = xPageStyleCollection.getByName("First Page")
            return xPageStyle.Size
        except Exception:
            traceback.print_exc()
            return None

    '''creates an instance of TextDocument and creates a
    frame and loads a document'''

    def createTextCursor(self, oCursorContainer):
        xTextCursor = oCursorContainer.createTextCursor()
        return xTextCursor

    def refresh(self):
        self.xTextDocument.refresh()

    '''
    This method sets the Author of a Wizard-generated template correctly
    and adds an explanatory sentence to the template description.
    @param WizardName The name of the Wizard.
    @param TemplateDescription The old Description which is being
    appended with another sentence.
    @return void.
    '''

    def setWizardTemplateDocInfo(self, WizardName, TemplateDescription):
        try:
            xNA = Configuration.getConfigurationRoot(
                self.xMSF, "/org.openoffice.UserProfile/Data", False)
            gn = xNA.getByName("givenname")
            sn = xNA.getByName("sn")
            fullname = str(gn) + " " + str(sn)
            now = time.localtime(time.time())
            year = time.strftime("%Y", now)
            month = time.strftime("%m", now)
            day = time.strftime("%d", now)

            dateObject = dateTimeObject(int(year), int(month), int(day))
            du = self.DateUtils(self.xMSF, self.xTextDocument)
            ff = du.getFormat(DATE_SYS_DDMMYY)
            myDate = du.format(ff, dateObject)
            xDocProps2 = self.xTextDocument.DocumentProperties
            xDocProps2.Author = fullname
            xDocProps2.ModifiedBy = fullname
            description = xDocProps2.Description
            description = description + " " + TemplateDescription
            description = description.replace("<wizard_name>", WizardName)
            description = description.replace("<current_date>", myDate)
            xDocProps2.Description = description
        except Exception:
            traceback.print_exc()

    @classmethod
    def getFrameByName(self, sFrameName, xTD):
        if xTD.TextFrames.hasByName(sFrameName):
            return xTD.TextFrames.getByName(sFrameName)

        return None

    def searchFillInItems(self, typeSearch):
        sd = self.xTextDocument.createSearchDescriptor()

        if typeSearch == 0:
            sd.setSearchString("<[^>]+>")
        elif typeSearch == 1:
            sd.setSearchString("#[^#]+#")

        sd.setPropertyValue("SearchRegularExpression", True)
        sd.setPropertyValue("SearchWords", True)

        auxList = []
        allItems = self.xTextDocument.findAll(sd)
        for i in list(range(allItems.Count)):
            auxList.append(allItems.getByIndex(i))

        return auxList

    class DateUtils(object):

        def __init__(self, xmsf, document):
            self.formatSupplier = document
            formatSettings = self.formatSupplier.getNumberFormatSettings()
            date = formatSettings.NullDate
            self.calendar = dateTimeObject(date.Year, date.Month, date.Day)
            self.formatter = NumberFormatter.createNumberFormatter(xmsf,
                self.formatSupplier)

        '''
        @param format a constant of the enumeration NumberFormatIndex
        @return
        '''

        def getFormat(self, format):
            return NumberFormatter.getNumberFormatterKey(
                self.formatSupplier, format)

        '''
        @param date a VCL date in form of 20041231
        @return a document relative date
        '''

        def format(self, formatIndex, date):
            difference =  date - self.calendar
            return self.formatter.convertNumberToString(formatIndex,
                difference.days)
