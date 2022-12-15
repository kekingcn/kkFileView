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
from ..text.TextElement import TextElement
from ..text.TextDocument import TextDocument
from ..text.TextSectionHandler import TextSectionHandler
from ..common.FileAccess import FileAccess

from datetime import datetime

from com.sun.star.text.PlaceholderType import TEXT
from com.sun.star.i18n.NumberFormatIndex import TIME_HHMM, DATE_SYSTEM_LONG

'''
The classes here implement the whole document-functionality of the agenda wizard:
the live-preview and the final "creation" of the document,
when the user clicks "finish". <br/>
<br/>
<h2>Some terminology:<h2/>
items are names or headings. we don't make any distinction.

<br/>
The Agenda Template is used as general "controller"
of the whole document, whereas the two child-classes ItemsTable
and TopicsTable control the item tables (note plural!) and the
topics table (note singular).<br/>
<br/>
Other small classes are used to abstract the handling of cells and text and we
try to use them as components.
<br/><br/>
We tried to keep the Agenda Template as flexible as possible, though there
must be many limitations, because it is generated dynamically.<br/><br/>
To keep the template flexible the following decisions were made:<br/>
1. Item tables.<br/>
1.a. there might be arbitrary number of Item tables.<br/>
1.b. Item tables design (bordewr, background) is arbitrary.<br/>
1.c. Items text styles are individual,
and use stylelist styles with predefined names.<br/>
As result the following limitations:<br/>
Pairs of Name->value for each item.<br/>
Tables contain *only* those pairs.<br/>
2. Topics table.<br/>
2.a. arbitrary structure.<br/>
2.b. design is arbitrary.<br/>
As result the following limitations:<br/>
No column merge is allowed.<br/>
One compulsory Heading row.<br/>
<br/><br/>
To let the template be flexible, we use a kind of "detection": we look where
the items are read the design of each table, re-applying it after writing the
table.self.xTextDocument
<br/><br/>
A note about threads:<br/>
Many methods here are synchronized, in order to avoid collision made by
events fired too often.
'''
class AgendaDocument(TextDocument):

    '''
    constructor. The document is *not* loaded here.
    only some formal members are set.
    '''

    def __init__(self,  xmsf, agenda, resources, templateConsts, listener):
        super(AgendaDocument,self).__init__(xmsf,listener, None,
            "WIZARD_LIVE_PREVIEW")
        self.agenda = agenda
        self.templateConsts = templateConsts
        self.resources = resources
        self.itemsMap = {}
        self.allItems = []

    def load(self, templateURL):
        # Each template is duplicated. aw-XXX.ott is the template itself
        # and XXX.ott is a section link.
        self.template = self.calcTemplateName(templateURL)
        self.loadAsPreview(templateURL, False)
        self.xFrame.ComponentWindow.Enable = False
        self.xTextDocument.lockControllers()
        self.initialize()
        self.initializeData()
        self.xTextDocument.unlockControllers()

    '''
    The agenda templates are in format of aw-XXX.ott
    the templates name is then XXX.ott.
    This method calculates it.
    '''

    def calcTemplateName(self, url):
        return FileAccess.connectURLs(
            FileAccess.getParentDir(url), FileAccess.getFilename(url)[3:])

    '''synchronize the document to the model.<br/>
    this method rewrites all titles, item tables , and the topics table-
    thus synchronizing the document to the data model (CGAgenda).
    information (it is only actualized on save) the given list
    supplies this information.
    '''

    def initializeData(self):
        for i in self.itemsTables:
            try:
                i.write()
            except Exception:
                traceback.print_exc()

        self.redrawTitle("txtTitle")
        self.redrawTitle("txtDate")
        self.redrawTitle("txtTime")
        self.redrawTitle("cbLocation")

    '''
    redraws/rewrites the table which contains the given item
    This method is called when the user checks/unchecks an item.
    The table is being found, in which the item is, and redrawn.
    '''

    def redraw(self, itemName):
        self.xTextDocument.lockControllers()
        try:
            # get the table in which the item is...
            itemsTable = self.itemsMap[itemName]
            # rewrite the table.
            itemsTable.write()
        except Exception:
            traceback.print_exc()
        self.xTextDocument.unlockControllers()

    '''
    checks the data model if the
    item corresponding to the given string should be shown
    '''

    def isShowItem(self, itemName):
        if itemName == self.templateConsts.FILLIN_MEETING_TYPE:
            return self.agenda.cp_ShowMeetingType
        elif itemName == self.templateConsts.FILLIN_READ:
            return self.agenda.cp_ShowRead
        elif itemName == self.templateConsts.FILLIN_BRING:
            return self.agenda.cp_ShowBring
        elif itemName == self.templateConsts.FILLIN_NOTES:
            return self.agenda.cp_ShowNotes
        elif itemName == self.templateConsts.FILLIN_FACILITATOR:
            return self.agenda.cp_ShowFacilitator
        elif itemName == self.templateConsts.FILLIN_TIMEKEEPER:
            return self.agenda.cp_ShowTimekeeper
        elif itemName == self.templateConsts.FILLIN_NOTETAKER:
            return self.agenda.cp_ShowNotetaker
        elif itemName == self.templateConsts.FILLIN_PARTICIPANTS:
            return self.agenda.cp_ShowAttendees
        elif itemName == self.templateConsts.FILLIN_CALLED_BY:
            return self.agenda.cp_ShowCalledBy
        elif itemName == self.templateConsts.FILLIN_OBSERVERS:
            return self.agenda.cp_ShowObservers
        elif itemName == self.templateConsts.FILLIN_RESOURCE_PERSONS:
            return self.agenda.cp_ShowResourcePersons
        else:
            raise ValueError("No such item")

    '''itemsCache is a Map containing all agenda item. These are object which
    "write themselves" to the table, given a table cursor.
    A cache is used in order to reuse the objects, instead of recreate them.
    This method fills the cache will all items objects (names and headings).
    '''

    def initItemsCache(self):
        self.itemsCache = {}
        # Headings
        self.itemsCache[
                self.templateConsts.FILLIN_MEETING_TYPE] = \
            AgendaItem(self.templateConsts.FILLIN_MEETING_TYPE,
                self.resources.itemMeetingType,
                PlaceholderElement(
                    self.resources.reschkMeetingTitle_value,
                    self.resources.resPlaceHolderHint, self.xTextDocument))
        self.itemsCache[
                self.templateConsts.FILLIN_BRING] = \
            AgendaItem(self.templateConsts.FILLIN_BRING,
                self.resources.itemBring,
                PlaceholderElement (
                    self.resources.reschkBring_value,
                    self.resources.resPlaceHolderHint, self.xTextDocument))
        self.itemsCache[
                self.templateConsts.FILLIN_READ] = \
            AgendaItem (self.templateConsts.FILLIN_READ,
                self.resources.itemRead,
                PlaceholderElement (
                    self.resources.reschkRead_value,
                    self.resources.resPlaceHolderHint, self.xTextDocument))
        self.itemsCache[
                self.templateConsts.FILLIN_NOTES] = \
            AgendaItem (self.templateConsts.FILLIN_NOTES,
                self.resources.itemNote,
                PlaceholderElement (
                    self.resources.reschkNotes_value,
                    self.resources.resPlaceHolderHint, self.xTextDocument))

        # Names
        self.itemsCache[
                self.templateConsts.FILLIN_CALLED_BY] = \
            AgendaItem(self.templateConsts.FILLIN_CALLED_BY,
                self.resources.itemCalledBy,
                PlaceholderElement (
                    self.resources.reschkConvenedBy_value,
                    self.resources.resPlaceHolderHint, self.xTextDocument))
        self.itemsCache[
                self.templateConsts.FILLIN_FACILITATOR] = \
            AgendaItem(self.templateConsts.FILLIN_FACILITATOR,
                self.resources.itemFacilitator,
                PlaceholderElement (
                    self.resources.reschkPresiding_value,
                    self.resources.resPlaceHolderHint, self.xTextDocument))
        self.itemsCache[
                self.templateConsts.FILLIN_PARTICIPANTS] = \
            AgendaItem(self.templateConsts.FILLIN_PARTICIPANTS,
                self.resources.itemAttendees,
                PlaceholderElement(
                    self.resources.reschkAttendees_value,
                    self.resources.resPlaceHolderHint, self.xTextDocument))
        self.itemsCache[
                self.templateConsts.FILLIN_NOTETAKER] = \
            AgendaItem(self.templateConsts.FILLIN_NOTETAKER,
                self.resources.itemNotetaker,
                PlaceholderElement(
                    self.resources.reschkNoteTaker_value,
                    self.resources.resPlaceHolderHint, self.xTextDocument))
        self.itemsCache[
                self.templateConsts.FILLIN_TIMEKEEPER] = \
            AgendaItem(self.templateConsts.FILLIN_TIMEKEEPER,
                self.resources.itemTimekeeper,
                PlaceholderElement(
                    self.resources.reschkTimekeeper_value,
                    self.resources.resPlaceHolderHint, self.xTextDocument))
        self.itemsCache[
                self.templateConsts.FILLIN_OBSERVERS] = \
            AgendaItem(self.templateConsts.FILLIN_OBSERVERS,
                self.resources.itemObservers,
                PlaceholderElement(
                    self.resources.reschkObservers_value,
                    self.resources.resPlaceHolderHint, self.xTextDocument))
        self.itemsCache[
                self.templateConsts.FILLIN_RESOURCE_PERSONS] = \
            AgendaItem(self.templateConsts.FILLIN_RESOURCE_PERSONS,
                self.resources.itemResource,
                PlaceholderElement(
                    self.resources.reschkResourcePersons_value,
                    self.resources.resPlaceHolderHint, self.xTextDocument))

    '''Initializes a template.<br/>
    This method does the following tasks:<br/>
    get a Time and Date format for the document, and retrieve the null
    date of the document (which is document-specific).<br/>
    Initializes the Items Cache map.
    Analyses the document:<br/>
    -find all "filled-ins" (appear as &gt;xxx&lt; in the document).
    -analyze all items sections (and the tables in them).
    -locate the titles and actualize them
    -analyze the topics table
    '''

    def initialize(self):
        '''
        Get the default locale of the document,
        and create the date and time formatters.
        '''
        self.dateUtils = self.DateUtils(self.xMSF, self.xTextDocument)
        self.formatter = self.dateUtils.formatter
        self.dateFormat = self.dateUtils.getFormat(DATE_SYSTEM_LONG)
        self.timeFormat = self.dateUtils.getFormat(TIME_HHMM)

        self.initItemsCache()
        self.allItems = self.searchFillInItems(0)
        self.initializeTitles()
        self.initializeItemsSections()
        self.textSectionHandler = TextSectionHandler(
            self.xTextDocument, self.xTextDocument)
        self.topics = Topics(self)

    '''
    locates the titles (name, location, date, time)
    and saves a reference to their Text ranges.
    '''

    def initializeTitles(self):
        auxList = []
        for i in self.allItems:
            text = i.String.lstrip().lower()
            if text == self.templateConsts.FILLIN_TITLE:
                self.teTitle = PlaceholderTextElement(
                    i, self.resources.resPlaceHolderTitle,
                    self.resources.resPlaceHolderHint, self.xTextDocument)
                self.trTitle = i
            elif text == self.templateConsts.FILLIN_DATE:
                self.teDate = PlaceholderTextElement(
                    i, self.resources.resPlaceHolderDate,
                    self.resources.resPlaceHolderHint, self.xTextDocument)
                self.trDate = i
            elif text == self.templateConsts.FILLIN_TIME:
                self.teTime = PlaceholderTextElement(
                    i, self.resources.resPlaceHolderTime,
                    self.resources.resPlaceHolderHint, self.xTextDocument)
                self.trTime = i
            elif text == self.templateConsts.FILLIN_LOCATION:
                self.teLocation = PlaceholderTextElement(
                    i, self.resources.resPlaceHolderLocation,
                    self.resources.resPlaceHolderHint, self.xTextDocument)
                self.trLocation = i
            else:
                auxList.append(i)
        self.allItems = auxList

    '''
    analyze the item sections in the template.
    delegates the analyze of each table to the ItemsTable class.
    '''

    def initializeItemsSections(self):
        sections = self.getSections(
        self.xTextDocument, self.templateConsts.SECTION_ITEMS)
        # for each section - there is a table...
        self.itemsTables = []
        for i in sections:
            try:
                self.itemsTables.append(
                    ItemsTable(self.getSection(i), self.getTable(i), self))
            except Exception:
                traceback.print_exc()
                raise AttributeError (
                    "Fatal Error while initializing \
                    Template: items table in section " + i)


    def getSections(self, document, s):
        allSections = document.TextSections.ElementNames
        return self.getNamesWhichStartWith(allSections, s)

    def getSection(self, name):
        return self.xTextDocument.TextSections.getByName(name)

    def getTable(self, name):
        return self.xTextDocument.TextTables.getByName(name)

    def redrawTitle(self, controlName):
        try:
            if controlName == "txtTitle":
                self.teTitle.placeHolderText = self.agenda.cp_Title
                self.teTitle.write(self.trTitle)
            elif controlName == "txtDate":
                self.teDate.placeHolderText = \
                    self.getDateString(self.agenda.cp_Date)
                self.teDate.write(self.trDate)
            elif controlName == "txtTime":
                self.teTime.placeHolderText = self.agenda.cp_Time
                self.teTime.write(self.trTime)
            elif controlName == "cbLocation":
                self.teLocation.placeHolderText = self.agenda.cp_Location
                self.teLocation.write(self.trLocation)
            else:
                raise Exception("No such title control...")
        except Exception:
            traceback.print_exc()

    def getDateString(self, date):
        if not date:
            return ""
        dateObject = datetime.strptime(date, '%d/%m/%y').date()
        return self.dateUtils.format(self.dateFormat, dateObject)

    def finish(self, topics):
        self.createMinutes(topics)
        self.deleteHiddenSections()
        self.textSectionHandler.removeAllTextSections()

    '''
    hidden sections exist when an item's section is hidden because the
    user specified not to display any items which it contains.
    When finishing the wizard removes this sections
    entirely from the document.
    '''

    def deleteHiddenSections(self):
        allSections = self.xTextDocument.TextSections.ElementNames
        try:
            for i in allSections:
                self.section = self.getSection(i)
                visible = bool(self.section.IsVisible)
                if not visible:
                    self.section.Anchor.String = ""

        except Exception:
            traceback.print_exc()

    '''
    create the minutes for the given topics or remove the minutes
    section from the document.
    If no topics are supplied, or the user specified not to create minutes,
    the minutes section will be removed,
    @param topicsData supplies PropertyValue arrays containing
    the values for the topics.
    '''

    def createMinutes(self, topicsData):
        # if the minutes section should be removed (the
        # user did not check "create minutes")
        if not self.agenda.cp_IncludeMinutes \
                or len(topicsData) <= 1:
            try:
                minutesAllSection = self.getSection(
                    self.templateConsts.SECTION_MINUTES_ALL)
                minutesAllSection.Anchor.String = ""
            except Exception:
                traceback.print_exc()

        # the user checked "create minutes"
        else:
            try:
                topicStartTime = int(self.agenda.cp_Time)
                # first I replace the minutes titles...
                self.items = self.searchFillInItems()
                itemIndex = 0
                for item in self.items:
                    itemText = item.String.lstrip().lower()
                    if itemText == \
                            self.templateConsts.FILLIN_MINUTES_TITLE:
                        self.fillMinutesItem(
                            item, self.agenda.cp_Title,
                            self.resources.resPlaceHolderTitle)
                    elif itemText == \
                            self.templateConsts.FILLIN_MINUTES_LOCATION:
                        self.fillMinutesItem(
                            item, self.agenda.cp_Location,
                            self.resources.resPlaceHolderLocation)
                    elif itemText == \
                            self.templateConsts.FILLIN_MINUTES_DATE:
                        self.fillMinutesItem(
                            item, getDateString(self.agenda.cp_Date),
                            self.resources.resPlaceHolderDate)
                    elif itemText == \
                            self.templateConsts.FILLIN_MINUTES_TIME:
                        self.fillMinutesItem( item, self.agenda.cp_Time,
                            self.resources.resPlaceHolderTime)

                self.items.clear()
                '''
                now add minutes for each topic.
                The template contains *one* minutes section, so
                we first use the one available, and then add a one...
                topics data has *always* an empty topic at the end...
                '''

                for i in xrange(len(topicsData) - 1):
                    topic = topicsData[i]
                    items = self.searchFillInItems()
                    itemIndex = 0
                    for item in items:
                        itemText = item.String.lstrip().lower()
                        if itemText == \
                                self.templateConsts.FILLIN_MINUTE_NUM:
                            self.fillMinutesItem(item, topic[0].Value, "")
                        elif itemText == \
                                self.templateConsts.FILLIN_MINUTE_TOPIC:
                            self.fillMinutesItem(item, topic[1].Value, "")
                        elif itemText == \
                                self.templateConsts.FILLIN_MINUTE_RESPONSIBLE:
                            self.fillMinutesItem(item, topic[2].Value, "")
                        elif itemText == \
                                self.templateConsts.FILLIN_MINUTE_TIME:
                            topicTime = 0
                            try:
                                topicTime = topic[3].Value
                            except Exception:
                                pass

                            '''
                            if the topic has no time, we do not
                            display any time here.
                            '''
                            if topicTime == 0 or topicStartTime == 0:
                                time = topic[3].Value
                            else:
                                time = str(topicStartTime) + " - "
                                topicStartTime += topicTime * 1000
                                time += str(topicStartTime)

                            self.fillMinutesItem(item, time, "")

                    self.textSectionHandler.removeTextSectionbyName(
                        self.templateConsts.SECTION_MINUTES)
                    # after the last section we do not insert a one.
                    if i < len(topicsData) - 2:
                        self.textSectionHandler.insertTextSection(
                            self.templateConsts.SECTION_MINUTES,
                            self.template, False)

            except Exception:
                traceback.print_exc()

    '''given a text range and a text, fills the given
    text range with the given text.
    If the given text is empty, uses a placeholder with the given
    placeholder text.
    @param range text range to fill
    @param text the text to fill to the text range object.
    @param placeholder the placeholder text to use, if the
    text argument is empty (null or "")
    '''

    def fillMinutesItem(self, Range, text, placeholder):
        paraStyle = Range.ParaStyleName
        Range.setString(text)
        Range.ParaStyleName = paraStyle
        if text is None or text == "":
            if placeholder is not None and not placeholder == "":
                placeHolder = self.createPlaceHolder(
                    self.xTextDocument, placeholder,
                    self.resources.resPlaceHolderHint)
                try:
                    Range.Start.Text.insertTextContent(
                        Range.Start, placeHolder, True)
                except Exception:
                    traceback.print_exc()

    '''
    creates a placeholder field with the given text and given hint.
    '''

    @classmethod
    def createPlaceHolder(self, xmsf, ph, hint):
        try:
            placeHolder =  xmsf.createInstance(
                "com.sun.star.text.TextField.JumpEdit")
        except Exception:
            traceback.print_exc()
            return None

        placeHolder.PlaceHolder = ph
        placeHolder.Hint = hint
        placeHolder.PlaceHolderType = uno.Any("short",TEXT)
        return placeHolder

    def getNamesWhichStartWith(self, allNames, prefix):
        v = []
        for i in allNames:
            if i.startswith(prefix):
                v.append(i)
        return v

    '''
    Convenience method for inserting some cells into a table.
    '''

    @classmethod
    def insertTableRows(self, table, start, count):
        rows = table.Rows
        rows.insertByIndex(start, count)

    '''
    returns the rows count of this table, assuming
    there is no vertical merged cells.
    '''

    @classmethod
    def getRowCount(self, table):
        cells = table.getCellNames()
        return int(cells[len(cells) - 1][1:])

class ItemsTable(object):
    '''
    the items in the table.
    '''
    items = []
    table = None

    def __init__(self, section, table, agenda):
        self.agenda = agenda
        ItemsTable.table = table
        self.section = section
        self.items = []
        '''
        go through all <*> items in the document
        and each one if it is in this table.
        If they are, register them to belong here, notice their order
        and remove them from the list of all <*> items, so the next
        search will be faster.
        '''
        aux = []
        for item in self.agenda.allItems:
            t = item.TextTable
            if t == ItemsTable.table:
                iText = item.String.lower().lstrip()
                ai = self.agenda.itemsCache[iText]
                if ai is not None:
                    self.items.append(ai)
                    self.agenda.itemsMap[iText] = self
            else:
                aux.append(item)
        self.agenda.allItems = aux

    '''
    link the section to the template. this will restore the original table
    with all the items.<br/>
    then break the link, to make the section editable.<br/>
    then, starting at cell one, write all items that should be visible.
    then clear the rest and remove obsolete rows.
    If no items are visible, hide the section.
    '''

    def write(self):
        name = self.section.Name
        # link and unlink the section to the template.
        self.agenda.textSectionHandler.linkSectiontoTemplate(
            self.agenda.template, name, self.section)
        self.agenda.textSectionHandler.breakLinkOfTextSection(
            self.section)
        # we need to get an instance after linking

        ItemsTable.table = self.agenda.getTable(name)
        self.section = self.agenda.getSection(name)
        cursor = ItemsTable.table.createCursorByCellName("A1")
        # should this section be visible?
        visible = False
        # write items
        cellName = ""
        '''
        now go through all items that belong to this
        table. Check each one against the model. If it should
        be displayed, call its write method.
        All items are of type AgendaItem which means they write
        two cells to the table: a title (text) and a placeholder.
        see AgendaItem class below.
        '''
        for i in self.items:
            if self.agenda.isShowItem(i.name):
                visible = True
                i.table = ItemsTable.table
                i.write(cursor)
                # I store the cell name which was last written...
                cellName = cursor.RangeName
                cursor.goRight(1, False)

        if visible:
            boolean = True
        else:
            boolean = False
        self.section.IsVisible = boolean
        if not visible:
            return
            '''
            if the cell that was last written is the current cell,
            it means this is the end of the table, so we end here.
            (because after getting the cellName above,
            I call the goRight method.
            If it did not go right, it means it's the last cell.
            '''

        if cellName == cursor.RangeName:
            return
            '''
            if not, we continue and clear all cells until
            we are at the end of the row.
            '''

        while not cellName == cursor.RangeName and \
                not cursor.RangeName.startswith("A"):
            cell = ItemsTable.table.getCellByName(cursor.RangeName)
            cell.String = ""
            cellName = cursor.RangeName
            cursor.goRight(1, False)

        '''
        again: if we are at the end of the table, end here.
        '''
        if cellName == cursor.RangeName:
            return

        '''
        now before deleting i move the cursor up so it
        does not disappear, because it will crash office.
        '''
        cursor.gotoStart(False)

'''
This class handles the preview of the topics table.
You can call it the controller of the topics table.
It differs from ItemsTable in that it has no data model -
the update is done programmatically.<br/>
<br/>
The decision to make this class a class by its own
was done out of logic reasons and not design/functionality reasons,
since there is anyway only one instance of this class at runtime
it could have also be implemented in the AgendaDocument class
but for clarity and separation I decided to make a sub class for it.
'''

class Topics(object):
    '''Analyze the structure of the Topics table.
    The structure Must be as follows:<br>
    -One Header Row. <br>
    -arbitrary number of rows per topic <br>
    -arbitrary content in the topics row <br>
    -only soft formatting will be restored. <br>
    -the topic rows must repeat three times. <br>
    -in the topics rows, placeholders for number, topic, responsible,
    and duration must be placed.<br><br>
    A word about table format: to reconstruct the format of the table we hold
    to the following formats: first row (header), topic, and last row.
    We hold the format of the last row, because one might wish to give it
    a special format, other than the one on the bottom of each topic.
    The left and right borders of the whole table are, on the other side,
    part of the topics rows format, and need not be preserved separately.
    '''
    table = None
    lastRowFormat = []
    rowsPerTopic = None

    def __init__(self, agenda):
        self.firstRowFormat = []
        self.agenda = agenda
        self.writtenTopics = -1
        try:
            Topics.table = self.agenda.getTable(
                self.agenda.templateConsts.SECTION_TOPICS)
        except Exception:
            traceback.print_exc()
            raise AttributeError (
                "Fatal error while loading template: table " + \
                self.agenda.templateConsts.SECTION_TOPICS + " could not load.")

        '''
        first I store all <*> ranges
        which are in the topics table.
        I store each <*> range in this - the key
        is the cell it is in. Later when analyzing the topic,
        cell by cell, I check in this map to know
        if a cell contains a <*> or not.
        '''
        try:
            items = {}
            for i in self.agenda.allItems:
                t = i.TextTable
                if t == Topics.table:
                    cell = i.Cell
                    iText = cell.CellName
                    items[iText] = i

            '''
            in the topics table, there are always one
            title row and three topics defined.
            So no mutter how many rows a topic takes - we
            can restore its structure and format.
            '''
            rows = self.agenda.getRowCount(Topics.table)
            Topics.rowsPerTopic = int((rows - 1) / 3)

            firstCell = "A" + str(1 + Topics.rowsPerTopic + 1)
            afterLastCell = "A" + str(1 + (Topics.rowsPerTopic * 2) + 1)
            # go to the first row of the 2. topic

            cursor = Topics.table.createCursorByCellName(firstCell)
            # analyze the structure of the topic rows.
            while not cursor.RangeName == afterLastCell:
                cell = Topics.table.getCellByName(cursor.RangeName)
                # first I store the content and para style of the cell
                ae = TextElement(cell, cell.String)
                ae.write()

                # goto next cell.
                cursor.goRight(1, False)
        except Exception:
            traceback.print_exc()

    '''rewrites a single cell containing.
    This is used in order to refresh the topic/responsible/duration data
    in the preview document, in response to a change in the gui (by the user)
    Since the structure of the topics table is flexible,
    The Topics object, which analyzed the structure of the topics table upon
    initialization, refreshes the appropriate cell.
    '''
    def writeCell(self, row, column, data):
        # if the whole row should be written...
        if self.writtenTopics < row:
            self.writtenTopics += 1
            rows = self.agenda.getRowCount(Topics.table)
            reqRows = 1 + (row + 1) * Topics.rowsPerTopic
            firstRow = reqRows - Topics.rowsPerTopic + 1
            diff = reqRows - rows
            if diff > 0:
                # set the item's text...
                self.agenda.insertTableRows(Topics.table, rows, diff)
            column = 0
            cursor = Topics.table.createCursorByCellName("A" + str(firstRow))
        else:
            # calculate the table row.
            firstRow = 1 + (row * Topics.rowsPerTopic) + 1
            cursor = Topics.table.createCursorByCellName("A" + str(firstRow))

            # move the cursor to the needed cell...
            cursor.goRight(column, False)

        xc = Topics.table.getCellByName(cursor.RangeName)
        # and write it !
        te = TextElement(xc, data[column].Value)
        te.write()

    '''removes obsolete rows, reducing the
    topics table to the given number of topics.
    Note this method does only reducing - if
    the number of topics given is greater than the
    number of actual topics it does *not* add
    rows!
    Note also that the first topic will never be removed.
    If the table contains no topics, the whole section will
    be removed upon finishing.
    The reason for that is a "table-design" one: the first topic is
    maintained in order to be able to add rows with a design of this topic,
    and not of the header row.
    @param topics the number of topics the table should contain.
    @throws Exception
    '''

    def reduceDocumentTo(self, topics):
        # we never remove the first topic...
        if topics <= 0:
            topics = 1

        tableRows = Topics.table.Rows
        targetNumOfRows = topics * Topics.rowsPerTopic + 1
        if tableRows.Count > targetNumOfRows:
            tableRows.removeByIndex(
                targetNumOfRows, tableRows.Count - targetNumOfRows)

'''
A Text element which, if the text to write is empty (null or "")
inserts a placeholder instead.
'''

class PlaceholderTextElement(TextElement):

    def __init__(self, textRange, placeHolderText_, hint_, xmsf_):
        super(PlaceholderTextElement,self).__init__(textRange, "")

        self.text = placeHolderText_
        self.hint = hint_
        self.xmsf = xmsf_
        self.xTextContentList = []

    def write(self, textRange):
        textRange.String = self.placeHolderText
        if self.placeHolderText is None or self.placeHolderText == "":
            try:
                xTextContent = AgendaDocument.createPlaceHolder(
                    self.xmsf, self.text, self.hint)
                self.xTextContentList.append(xTextContent)
                textRange.Text.insertTextContent(
                    textRange.Start, xTextContent, True)
            except Exception:
                traceback.print_exc()
        else:
            if self.xTextContentList:
                for i in self.xTextContentList:
                    textRange.Text.removeTextContent(i)
                self.xTextContentList = []
'''
An Agenda element which writes no text, but inserts a placeholder, and formats
it using a ParaStyleName.
'''

class PlaceholderElement(object):

    def __init__(self, placeHolderText_, hint_,  textDocument):
        self.placeHolderText = placeHolderText_
        self.hint = hint_
        self.textDocument =  textDocument

    def write(self, textRange):
        try:
            xTextContent = AgendaDocument.createPlaceHolder(
                self.textDocument, self.placeHolderText, self.hint)
            textRange.Text.insertTextContent(
                textRange.Start, xTextContent, True)
        except Exception:
            traceback.print_exc()

'''
An implementation of AgendaElement which
gets as a parameter a table cursor, and writes
a text to the cell marked by this table cursor, and
a place holder to the next cell.
'''

class AgendaItem(object):

    def __init__(self, name_, te, f):
        self.name = name_
        self.field = f
        self.textElement = te

    def write(self, tableCursor):
        cellname = tableCursor.RangeName
        cell = ItemsTable.table.getCellByName(cellname)
        cell.String = self.textElement
        tableCursor.goRight(1, False)
        # second field is actually always null...
        # this is a preparation for adding placeholders.
        if self.field is not None:
            self.field.write(ItemsTable.table.getCellByName(
                tableCursor.RangeName))
