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
from ..ui.ControlScroller import ControlScroller, PropertyNames, traceback, \
    HelpIds
from .AgendaWizardDialogConst import HID
from ..common.Properties import Properties
from ..ui.event.CommonListener import FocusListenerProcAdapter, \
    KeyListenerProcAdapter

from com.sun.star.awt.Key import DOWN, UP, TAB
from com.sun.star.awt.KeyModifier import SHIFT, MOD1

'''
This class implements the UI functionality of the topics scroller control.
<br/>
During development, there has been a few changes which were not *fully* done
mainly in converting the topics and time boxes
from combobox and time box to normal textboxes,
so in the code they might be referenced as combobox or timebox. This should be
rather understood as topicstextbox and timetextbox.<br/><br/>
Important behaviour of this control is that there is always a
blank row at the end, in which the user can enter data.<br/>
Once the row is not blank (thus, the user entered data...),
a new blank row is added.<br/>
Once the user removes the last *unempty* row, binsertRowy deleting its data, it becomes
the *last empty row* and the one after is being automatically removed.<br/><br/>
The control shows 5 rows at a time.<br/>
If, for example, only 2 rows exist (from which the 2ed one is empty...)
then the other three rows, which do not exist in the data model, are disabled.
<br/>
The following other functionality is implemented:
<br/>
0. synchronizing data between controls, data model and live preview.
1. Tab scrolling.<br/>
2. Keyboard scrolling.<br/>
3. Removing rows and adding new rows.<br/>
4. Moving rows up and down. <br/>
<br/>
This control relays on the ControlScroller control which uses the following
Data model:<br/>
1. It uses a vector, whose members are arrays of PropertyValue.<br/>
2. Each array represents a row.<br/>
(Note: the Name and Value members of the PropertyValue object are being used)
3. Each property Value represents a value
for a single control with the following rules:<br/>
3. a. the Value of the property is used for as value
of the controls (usually text).<br/>
3. b. the Name of the property is used to map values
to UI controls in the following manner:<br/>
3. b. 1. only the Name of the first X Rows is regarded,
where X is the number of visible rows (in the ainsertRowgenda wizard this would be 5,
since 5 topic rows are visible on the dialog).<br/>
3. b. 2. The Names of the first X (or 5...) rows are the names
of the UI Controls to hold values. When the control scroller scrolls,
it looks at the first 5 rows and uses the names specified there to map the
current values to the specified controls. <br/>
This data model makes the following limitations on the implementation:
When moving rows, only the values should be moved. The Rows objects,
which contain also the Names of the controls should not be switched. <br/>
also when deleting or inserting rows, attention should be paid that no rows
should be removed or inserted. Instead, only the Values should rotate. <br/><br/>
To save the topics in the registry a ConfigSet of objects of type CGTopic is
being used.
This one is not synchronized "live", since it is unnecessary... instead, it is
synchronized on call, before the settings should be saved.
'''

class TopicsControl(ControlScroller):

    LABEL = "lblTopicCnt_"
    TOPIC = "txtTopicTopic_"
    RESP = "cbTopicResp_"
    TIME = "txtTopicTime_"
    LABEL_PROPS = (PropertyNames.PROPERTY_HEIGHT, PropertyNames.PROPERTY_LABEL,
        PropertyNames.PROPERTY_POSITION_X, PropertyNames.PROPERTY_POSITION_Y,
        PropertyNames.PROPERTY_STEP, PropertyNames.PROPERTY_TABINDEX,
        PropertyNames.PROPERTY_WIDTH)
    TEXT_PROPS = (PropertyNames.PROPERTY_HEIGHT, PropertyNames.PROPERTY_HELPURL,
        PropertyNames.PROPERTY_POSITION_X, PropertyNames.PROPERTY_POSITION_Y,
        PropertyNames.PROPERTY_STEP, PropertyNames.PROPERTY_TABINDEX,
        PropertyNames.PROPERTY_WIDTH)

    def __init__(self, dialog, xmsf, agenda):
        try:
            super(TopicsControl, self).__init__(
                dialog, xmsf, 5, 92, 38, 212, 5, 18, HID + 32)
            self.dialog = dialog
            #fill preview's table
            self.initializeScrollFields(agenda)
            #fill gui's table
            self.fillupControls(True)
            self.nscrollvalue = 0
            self.lastFocusRow = 0
            self.lastFocusControl = None
            # set some focus listeners for TAB scroll down and up...
            # prepare scroll down on tab press...
            self.lastTime = \
                self.ControlGroupVector[self.nblockincrement - 1].timebox

            self.lastTime.addKeyListener(KeyListenerProcAdapter(
                self.lastControlKeyPressed))
            #prepare scroll up on tab press...
            self.firstTopic = self.ControlGroupVector[0].textbox
            self.firstTopic.addKeyListener(KeyListenerProcAdapter(
                self.firstControlKeyPressed))
            self.enableButtons()
        except Exception:
            traceback.print_exc()

    '''
    initializes the data of the control.
    '''

    def initializeScrollFields(self, agenda):
        # create a row for each topic with the given values...
        for index,item  in enumerate(agenda.cp_Topics.childrenList):
            row = self.newRow(index)
            item.setDataToRow(row)
            # a parent class method
            self.registerControlGroup(row, index)
            self.updateDocumentRow(index)
        # inserts a blank row at the end...
        self.insertRowAtEnd()

    '''
    Insert a blank (empty) row
    as last row of the control.
    The control has always a blank row at the
    end, which enables the user to enter data...
    '''

    def insertRowAtEnd(self):
        l = len(self.scrollfields)
        self.registerControlGroup(self.newRow(l), l)
        self.setTotalFieldCount(l + 1)
        # if the new row is visible, it must have been disabled
        # so it should be now enabled...
        if l - self.nscrollvalue < self.nblockincrement:
            self.ControlGroupVector[l - self.nscrollvalue].\
                setEnabled(True)

    def saveTopics(self, agenda):
        # last row is always empty
        agenda.cp_Topics.childrenList = self.scrollfields[:-1]

    '''
    remove the last row
    '''

    def removeLastRow(self):
        l = len(self.scrollfields)
        # if we should scroll up...
        if (l - self.nscrollvalue) >= 1 \
                and (l - self.nscrollvalue) <= self.nblockincrement \
                and self.nscrollvalue > 0:
            while (l - self.nscrollvalue >= 1) \
                    and l - self.nscrollvalue <= self.nblockincrement \
                    and self.nscrollvalue > 0:
                self.setScrollValue(self.nscrollvalue - 1)
        # if we should disable a row...
        elif self.nscrollvalue == 0 and l - 1 < self.nblockincrement:
            self.ControlGroupVector[l - 1].setEnabled(False)

        self.unregisterControlGroup(l - 1)
        self.setTotalFieldCount(l - 1)

    '''
    in order to use the "move up", "down" "insert" and "remove" buttons,
    we track the last control the gained focus, in order to know which
    row should be handled.
    @param fe
    '''

    def focusGained(self, fe):
        xc = fe.Source
        self.focusGained2(xc)

    '''
    Sometimes I set the focus programmatically to a control
    (for example when moving a row up or down, the focus should move
    with it).
    In such cases, no VCL event is being triggered so it must
    be called programmatically.
    This is done by this method.
    @param control
    '''

    def focusGained2(self, control):
        try:
            #calculate in which row we are...
            name = control.Model.Name
            num = name[name.index("_") + 1:]
            self.lastFocusRow = int(num) + self.nscrollvalue
            self.lastFocusControl = control
            # enable/disable the buttons...
            self.enableButtons()
        except Exception:
            traceback.print_exc()

    '''
    enable or disable the buttons according to the
    current row we are in.
    '''

    def enableButtons(self):
        self.CurUnoDialog.btnInsert.Model.Enabled = \
            self.lastFocusRow < len(self.scrollfields)
        self.CurUnoDialog.btnRemove.Model.Enabled = \
            self.lastFocusRow < len(self.scrollfields) - 1
        if self.lastFocusControl is not None:
            self.CurUnoDialog.btnUp.Model.Enabled = self.lastFocusRow > 0
            self.CurUnoDialog.btnDown.Model.Enabled = \
                self.lastFocusRow < len(self.scrollfields) - 1
        else:
            self.CurUnoDialog.btnUp.Model.Enabled = False
            self.CurUnoDialog.btnDown.Model.Enabled =  False

    '''
    Removes the current row.
    See general class documentation explanation about the
    data model used and the limitations which explain the implementation here.
    '''

    def removeRow(self):
        try:
            for i in range(self.lastFocusRow,
                    len(self.scrollfields) - 1):
                pv1 = self.scrollfields[i]
                pv2 = self.scrollfields[i + 1]
                pv1[1].Value = pv2[1].Value
                pv1[2].Value = pv2[2].Value
                pv1[3].Value = pv2[3].Value
                self.updateDocumentRow(i)
                if i - self.nscrollvalue < self.nblockincrement:
                    self.fillupControl(i - self.nscrollvalue)

            self.removeLastRow()
            # update the live preview background document
            self.reduceDocumentToTopics()
            self.enableButtons()
            if self.lastFocusControl is not None:
                # the focus should return to the edit control
                self.focus(self.lastFocusControl)
        except Exception:
            traceback.print_exc()

    '''
    Inserts a row before the current row.
    See general class documentation explanation about the
    data model used and the limitations which explain the implementation here.
    '''

    def insertRow(self):
        try:
            self.insertRowAtEnd()
            for i in range(len(self.scrollfields) - 2,
                    self.lastFocusRow, -1):
                pv1 = self.scrollfields[i]
                pv2 = self.scrollfields[i - 1]
                pv1[1].Value = pv2[1].Value
                pv1[2].Value = pv2[2].Value
                pv1[3].Value = pv2[3].Value
                self.updateDocumentRow(i)
                if i - self.nscrollvalue < self.nblockincrement:
                    self.fillupControl(i - self.nscrollvalue)

            # after rotating all the properties from this row on,
            # we clear the row, so it is practically a new one...
            pv1 = self.scrollfields[self.lastFocusRow]
            pv1[1].Value = ""
            pv1[2].Value = ""
            pv1[3].Value = ""
            # update the preview document.
            self.updateDocumentRow(self.lastFocusRow)
            self.fillupControl(
                self.lastFocusRow - self.nscrollvalue)
            self.enableButtons()

            if self.lastFocusControl is not None:
                self.focus(self.lastFocusControl)
        except Exception:
            traceback.print_exc()

    '''
    create a new row with the given index.
    The index is important because it is used in the
    Name member of the PropertyValue objects.
    To know why see general class documentation above (data model explanation)
    @param i the index of the new row
    @return
    '''

    def newRow(self, i):
        pv = list(range(4))
        pv[0] = Properties.createProperty(
            TopicsControl.LABEL + str(i), "" + str(i + 1) + ".")
        pv[1] = Properties.createProperty(TopicsControl.TOPIC + str(i), "")
        pv[2] = Properties.createProperty(TopicsControl.RESP + str(i), "")
        pv[3] = Properties.createProperty(TopicsControl.TIME + str(i), "")
        return pv

    '''
    Implementation of ControlScroller
    This is a UI method which inserts a new row to the control.
    It uses the child-class ControlRow. (see below).
    '''

    def insertControlGroup(self, _index, npos):
        oControlRow = ControlRow(
            self.CurUnoDialog, self.iCompPosX, npos, _index,
            ControlRow.tabIndex, self)
        self.ControlGroupVector.append(oControlRow)
        ControlRow.tabIndex += 4

    '''
    Checks if a row is empty.
    This is used when the last row is changed.
    If it is empty, the next row (which is always blank) is removed.
    If it is not empty, a next row must exist.
    @param row the index number of the row to check.
    @return true if empty. false if not.
    '''

    def isRowEmpty(self, row):
        data = self.getTopicData(row)
        # now - is this row empty?
        return not data[1].Value and not data[2].Value and not data[3].Value

    '''
    update the preview document and
    remove/insert rows if needed.
    @param guiRow
    @param column
    '''

    def fieldChanged(self, guiRow, column):
        try:
            # First, I update the document
            data = self.getTopicData(guiRow + self.nscrollvalue)
            if data is None:
                return
            self.updateDocumentCell(
                guiRow + self.nscrollvalue, column, data)
            if self.isRowEmpty(guiRow + self.nscrollvalue):
                '''
                if this is the row before the last one
                (the last row is always empty)
                delete the last row...
                '''
                if (guiRow + self.nscrollvalue) \
                        == len(self.scrollfields) - 2:
                    self.removeLastRow()
                    '''now consequently check the last two rows,
                    and remove the last one if they are both empty.
                    (actually I check always the "before last" row,
                    because the last one is always empty...
                    '''
                    while len(self.scrollfields) > 1 \
                            and self.isRowEmpty(
                                len(self.scrollfields) - 2):
                        self.removeLastRow()
                    cr = self.ControlGroupVector[
                        len(self.scrollfields) - \
                            self.nscrollvalue - 1]
                    # if a remove was performed, set focus
                    #to the last row with some data in it...
                    self.focus(self.getControlByIndex(cr, column))
                    # update the preview document.
                    self.reduceDocumentToTopics()
            else:
                # row contains data
                # is this the last row?
                if (guiRow + self.nscrollvalue + 1) \
                        == len(self.scrollfields):
                    self.insertRowAtEnd()

        except Exception:
            traceback.print_exc()

    '''
    return the corresponding row data for the given index.
    @param topic index of the topic to get.
    @return a PropertyValue array with the data for the given topic.
    '''

    def getTopicData(self, topic):
        if topic < len(self.scrollfields):
            return self.scrollfields[topic]
        else:
            return None

    '''
    If the user presses tab on the last control, and
    there *are* more rows in the model, scroll down.
    @param event
    '''

    def lastControlKeyPressed(self, event):
        # if tab without shift was pressed...
        try:
            if event.KeyCode == TAB and event.Modifiers == 0:
                # if there is another row...
                if (self.nblockincrement + self.nscrollvalue) \
                        < len(self.scrollfields):
                    self.setScrollValue(self.nscrollvalue + 1)
                    self.focus(self.getControlByIndex(self.ControlGroupVector[4], 1))
        except Exception:
            traceback.print_exc()

    '''
    If the user presses shift-tab on the first control, and
    there *are* more rows in the model, scroll up.
    @param event
    '''

    def firstControlKeyPressed(self, event):
        # if tab with shift was pressed...
        if (event.KeyCode == TAB) and \
                (event.Modifiers == SHIFT):
            if self.nscrollvalue > 0:
                self.setScrollValue(self.nscrollvalue - 1)
                self.focus(self.lastTime)

    '''
    sets focus to the given control.
    @param textControl
    '''
    
    def focus(self, textControl):
        textControl.setFocus()
        text = textControl.Text
        textControl.Selection = uno.createUnoStruct( \
                    'com.sun.star.awt.Selection', 0, len(text))
        self.focusGained2(textControl)

    '''
    moves the given row one row down.
    @param guiRow the gui index of the row to move.
    @param control the control to gain focus after moving.
    '''

    def rowDown(self, guiRow=None, control=None):
        try:
            if guiRow is None:
                guiRow = self.lastFocusRow - self.nscrollvalue
            if control is None:
                control = self.lastFocusControl
            # only perform if this is not the last row.
            actuallRow = guiRow + self.nscrollvalue
            if actuallRow + 1 < len(self.scrollfields):
                # get the current selection
                selection = control.Selection
                # the last row should scroll...
                scroll = (guiRow == self.nblockincrement - 1)
                if scroll:
                    self.setScrollValue(self.nscrollvalue + 1)

                scroll1 = self.nscrollvalue
                if scroll:
                    aux = -1
                else:
                    aux = 1
                self.switchRows(guiRow, guiRow + aux)
                if self.nscrollvalue != scroll1:
                    guiRow += (self.nscrollvalue - scroll1)

                self.setSelection(guiRow + (not scroll), control, selection)
        except Exception:
            traceback.print_exc()

    '''
    move the current row up
    '''

    def rowUp(self, guiRow=None, control=None):
        try:
            if guiRow is None:
                guiRow = self.lastFocusRow - self.nscrollvalue
            if control is None:
                control = self.lastFocusControl
            # only perform if this is not the first row
            actuallRow = guiRow + self.nscrollvalue
            if actuallRow > 0:
                # get the current selection
                selection = control.Selection
                # the last row should scroll...
                scroll = (guiRow == 0)
                if scroll:
                    self.setScrollValue(self.nscrollvalue - 1)
                if scroll:
                    aux = 1
                else:
                    aux = -1
                self.switchRows(guiRow, guiRow + aux)
                self.setSelection(guiRow - (not scroll), control, selection)
        except Exception:
            traceback.print_exc()

    '''
    moves the cursor up.
    @param guiRow
    @param control
    '''

    def cursorUp(self, guiRow, control):
        # is this the last full row ?
        actuallRow = guiRow + self.nscrollvalue
        #if this is the first row
        if actuallRow == 0:
            return
            # the first row should scroll...

        scroll = (guiRow == 0)
        if scroll:
            self.setScrollValue(self.nscrollvalue - 1)
            upperRow = self.ControlGroupVector[guiRow]
        else:
            upperRow = self.ControlGroupVector[guiRow - 1]

        self.focus(self.getControl(upperRow, control))

    '''
    moves the cursor down
    @param guiRow
    @param control
    '''

    def cursorDown(self, guiRow, control):
        # is this the last full row ?
        actuallRow = guiRow + self.nscrollvalue
        #if this is the last row, exit
        if actuallRow == len(self.scrollfields) - 1:
            return
            # the first row should scroll...

        scroll = (guiRow == self.nblockincrement - 1)
        if scroll:
            self.setScrollValue(self.nscrollvalue + 1)
            lowerRow = self.ControlGroupVector[guiRow]
        else:
            # if we scrolled we are done...
            #otherwise...
            lowerRow = self.ControlGroupVector[guiRow + 1]

        self.focus(self.getControl(lowerRow, control))

    '''
    changes the values of the given rows with each other
    @param row1 one can figure out what this parameter is...
    @param row2 one can figure out what this parameter is...
    '''

    def switchRows(self, row1, row2):
        o1 = self.scrollfields[row1 + self.nscrollvalue]
        o2 = self.scrollfields[row2 + self.nscrollvalue]
        temp = None
        for i in range(1, len(o1)):
            temp = o1[i].Value
            o1[i].Value = o2[i].Value
            o2[i].Value = temp
        self.fillupControl(row1)
        self.fillupControl(row2)
        self.updateDocumentRow(row1 + self.nscrollvalue, o1)
        self.updateDocumentRow(row2 + self.nscrollvalue, o2)

        '''
        if we changed the last row, add another one...
        '''
        if (row1 + self.nscrollvalue + 1 == \
                    len(self.scrollfields)) \
            or (row2 + self.nscrollvalue + 1 == \
                    len(self.scrollfields)):

            self.insertRowAtEnd()
            '''
            if we did not change the last row but
            we did change the one before - check if we
            have two empty rows at the end.
            If so, delete the last one...
            '''
        elif (row1 + self.nscrollvalue) + \
                (row2 + self.nscrollvalue) \
                == (len(self.scrollfields) * 2 - 5):
            if self.isRowEmpty(len(self.scrollfields) - 2) \
                    and self.isRowEmpty(
                        len(self.scrollfields) - 1):
                self.removeLastRow()
                self.reduceDocumentToTopics()

    '''
    sets a text selection to a given control.
    This is used when one moves a row up or down.
    After moving row X to X+/-1, the selection (or cursor position) of the
    last focused control should be restored.
    The control's row is the given guiRow.
    The control's column is detected according to the given event.
    This method is called as subsequent to different events,
    thus it is comfortable to use the event here to detect the column,
    rather than in the different event methods.
    @param guiRow the row of the control to set the selection to.
    @param eventSource helps to detect
    the control's column to set the selection to.
    @param s the selection object to set.
    '''

    def setSelection(self, guiRow, eventSource, s):
        cr = self.ControlGroupVector[guiRow]
        control = self.getControl(cr, eventSource)
        control.setFocus()
        control.setSelection(s)

    '''
    returns a control out of the given row, according to a column number.
    @param cr control row object.
    @param column the column number.
    @return the control...
    '''

    def getControlByIndex(self, cr, column):
        tmp_switch_var1 = column
        if tmp_switch_var1 == 0:
            return cr.label
        elif tmp_switch_var1 == 1:
            return cr.textbox
        elif tmp_switch_var1 == 2:
            return cr.combobox
        elif tmp_switch_var1 == 3:
            return cr.timebox
        else:
            raise Exception("No such column");

    '''getControl
    returns a control out of the given row, which is
    in the same column as the given control.
    @param cr control row object
    @param control a control indicating a column.
    @return
    '''

    def getControl(self, cr, control):
        column = self.getColumn(control)
        return self.getControlByIndex(cr, column)

    '''
    returns the column number of the given control.
    @param control
    @return
    '''

    def getColumn(self, control):
        name = control.Model.Name
        if name.startswith(TopicsControl.TOPIC):
            return 1
        if name.startswith(TopicsControl.RESP):
            return 2
        if name.startswith(TopicsControl.TIME):
            return 3
        if name.startswith(TopicsControl.LABEL):
            return 0
        return -1

    '''
    update the given row in the preview document with the given data.
    @param row
    @param data
    '''

    def updateDocumentRow(self, row, data=None):
        if data is None:
            data = self.scrollfields[row]
        try:
            for i in range(len(data)):
                self.CurUnoDialog.myAgendaDoc.topics.writeCell(
                    row, i, data)
        except Exception:
            traceback.print_exc()

    '''
    updates a single cell in the preview document.
    Is called when a single value is changed, since we really
    don't have to update the whole row for one small change...
    @param row the data row to update (topic number).
    @param column the column to update (a gui column, not a document column).
    @param data the data of the entire row.
    '''

    def updateDocumentCell(self, row, column, data):
        try:
            self.CurUnoDialog.myAgendaDoc.topics.writeCell(
                row, column, data)
        except Exception:
            traceback.print_exc()

    '''
    when removing rows, this method updates
    the preview document to show the number of rows
    according to the data model.
    '''

    def reduceDocumentToTopics(self):
        try:
            self.CurUnoDialog.myAgendaDoc.topics.reduceDocumentTo(
                len(self.scrollfields) - 1)
        except Exception:
            traceback.print_exc()

'''
A class represting a single GUI row.
Note that the instance methods of this class
are being called and handle controls of
a single row.
'''

class ControlRow(object):

    tabIndex = 520
    '''
    constructor. Create the row in the given dialog given coordinates,
    with the given offset (row number) and tabindex.
    Note that since I use this specifically for the agenda wizard,
    the step and all control coordinates inside the
    row are constant (5).
    '''

    def __init__(self, dialog, x, y, i, tabindex, topicsControl):
        self.offset = i
        self.dialog = dialog
        self.topicsControl = topicsControl
        self.label = self.dialog.insertLabel(
            self.topicsControl.LABEL + str(i),
            self.topicsControl.LABEL_PROPS,
            (8, "" + str(i + 1) + ".",
            x + 4, y + 2, self.topicsControl.iStep, tabindex, 10))
        self.textbox = self.dialog.insertTextField(
            self.topicsControl.TOPIC + str(i), "topicTextChanged",
            self.topicsControl.TEXT_PROPS,
            (12, HelpIds.getHelpIdString(self.topicsControl.curHelpIndex + i * 3 + 1),
            x + 15, y, self.topicsControl.iStep, tabindex + 1, 84), self)
        self.combobox = self.dialog.insertTextField(
            self.topicsControl.RESP + str(i), "responsibleTextChanged",
            self.topicsControl.TEXT_PROPS,
            (12, HelpIds.getHelpIdString(self.topicsControl.curHelpIndex + i * 3 + 2),
            x + 103, y, self.topicsControl.iStep, tabindex + 2, 68), self)
        self.timebox = self.dialog.insertTextField(
            self.topicsControl.TIME + str(i), "timeTextChanged",
            self.topicsControl.TEXT_PROPS,
            (12, HelpIds.getHelpIdString(self.topicsControl.curHelpIndex + i * 3 + 3),
            x + 175, y, self.topicsControl.iStep, tabindex + 3, 20), self)
        self.setEnabled(False)
        self.textbox.addKeyListener(KeyListenerProcAdapter(self.keyPressed))
        self.combobox.addKeyListener(KeyListenerProcAdapter(self.keyPressed))
        self.timebox.addKeyListener(KeyListenerProcAdapter(self.keyPressed))
        self.textbox.addFocusListener(FocusListenerProcAdapter(
            self.topicsControl.focusGained))
        self.combobox.addFocusListener(FocusListenerProcAdapter(
            self.topicsControl.focusGained))
        self.timebox.addFocusListener(FocusListenerProcAdapter(
            self.topicsControl.focusGained))

    def topicTextChanged(self):
        try:
            # update the data model
            self.topicsControl.fieldInfo(self.offset, 1)
            # update the preview document
            self.topicsControl.fieldChanged(self.offset, 1)
        except Exception:
            traceback.print_exc()

    '''
    called through an event listener when the
    responsible text is changed by the user.
    updates the data model and the preview document.
    '''

    def responsibleTextChanged(self):
        try:
            # update the data model
            self.topicsControl.fieldInfo(self.offset, 2)
            # update the preview document
            self.topicsControl.fieldChanged(self.offset, 2)
        except Exception:
            traceback.print_exc()

    '''
    called through an event listener when the
    time text is changed by the user.
    updates the data model and the preview document.
    '''

    def timeTextChanged(self):
        try:
            # update the data model
            self.topicsControl.fieldInfo(self.offset, 3)
            # update the preview document
            self.topicsControl.fieldChanged(self.offset, 3)
        except Exception:
            traceback.print_exc()

    '''
    enables/disables the row.
    @param enabled true for enable, false for disable.
    '''

    def setEnabled(self, enabled):
        self.label.Model.Enabled = enabled
        self.textbox.Model.Enabled = enabled
        self.combobox.Model.Enabled = enabled
        self.timebox.Model.Enabled = enabled

    '''
    Implementation of XKeyListener.
    Optionally performs the one of the following:
    cursor up, or down, row up or down
    '''

    def keyPressed(self, event):
        try:
            if self.isMoveDown(event):
                self.topicsControl.rowDown(self.offset, event.Source)
            elif self.isMoveUp(event):
                self.topicsControl.rowUp(self.offset, event.Source)
            elif self.isDown(event):
                self.topicsControl.cursorDown(self.offset, event.Source)
            elif self.isUp(event):
                self.topicsControl.cursorUp(self.offset, event.Source)

            self.topicsControl.enableButtons()
        except Exception:
            traceback.print_exc()

    def isMoveDown(self, e):
        return (e.KeyCode == DOWN) and (e.Modifiers == MOD1)

    def isMoveUp(self, e):
        return (e.KeyCode == UP) and (e.Modifiers == MOD1)

    def isDown(self, e):
        return (e.KeyCode == DOWN) and (e.Modifiers == 0)

    def isUp(self, e):
        return (e.KeyCode == UP) and (e.Modifiers == 0)
