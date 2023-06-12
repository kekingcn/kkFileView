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
import traceback
from .UnoDialog import UnoDialog
from ..common.Desktop import Desktop
from ..common.PropertyNames import PropertyNames
from ..common.HelpIds import HelpIds

from com.sun.star.awt.ScrollBarOrientation import VERTICAL

class ControlScroller(object):

    SORELFIRSTPOSY = 3
    iScrollBarWidth = 10

    # TODO add parameters for tabindices and helpindex
    def __init__(self, _CurUnoDialog, _xMSF, _iStep, _iCompPosX, _iCompPosY,
            _iCompWidth, _nblockincrement, _nlinedistance, _firsthelpindex):
        self.xMSF = _xMSF
        self.scrollfields = []
        self.ControlGroupVector = []
        ControlScroller.nblockincrement = _nblockincrement
        self.CurUnoDialog = _CurUnoDialog
        self.iStep = _iStep
        self.curHelpIndex = _firsthelpindex
        self.curtabindex = self.iStep * 100
        self.linedistance = _nlinedistance
        self.iCompPosX = _iCompPosX
        self.iCompPosY = _iCompPosY
        self.iCompWidth = _iCompWidth
        self.iCompHeight = 2 * ControlScroller.SORELFIRSTPOSY + \
                ControlScroller.nblockincrement * self.linedistance
        self.iStartPosY = self.iCompPosY + ControlScroller.SORELFIRSTPOSY
        ScrollHeight = self.iCompHeight - 2
        self.nlineincrement = 1
        self.sincSuffix = Desktop.getIncrementSuffix(
            self.CurUnoDialog.xDialogModel, "imgBackground")

        self.xScrollBar = self.CurUnoDialog.insertScrollBar(
            "TitleScrollBar" + self.sincSuffix,
            ("Border", PropertyNames.PROPERTY_ENABLED,
                PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_HELPURL, "Orientation",
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y,
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_WIDTH),
            (0, True, ScrollHeight,
                HelpIds.getHelpIdString(self.curHelpIndex),
                VERTICAL, self.iCompPosX + self.iCompWidth - \
                    ControlScroller.iScrollBarWidth - 1,
                self.iCompPosY + 1, self.iStep,
                ControlScroller.iScrollBarWidth), 0, self)
        self.nscrollvalue = 0
        ypos = self.iStartPosY + ControlScroller.SORELFIRSTPOSY
        for i in range(ControlScroller.nblockincrement):
            self.insertControlGroup(i, ypos)
            ypos += self.linedistance

    def fillupControls(self, binitialize):
        for i in range(ControlScroller.nblockincrement):
            if i < self.ncurfieldcount:
                self.fillupControl(i)

        if binitialize:
            self.CurUnoDialog.repaintDialogStep()


    def fillupControl(self, guiRow):
        nameProps = self.scrollfields[guiRow]
        valueProps = self.scrollfields[guiRow + self.nscrollvalue]
        for index, item in enumerate(nameProps):
            if self.CurUnoDialog.xDialogModel.hasByName(item.Name):
                self.setControlData(item.Name, valueProps[index].Value)
            else:
                raise AttributeError("No such control !")
        self.ControlGroupVector[guiRow].setEnabled(True)

    def setScrollValue(self, _nscrollvalue, _ntotfieldcount=None):
        if _ntotfieldcount is not None:
            self.setTotalFieldCount(_ntotfieldcount)
        if _nscrollvalue >= 0:
            self.xScrollBar.Model.ScrollValue = _nscrollvalue
            self.scrollControls()

    def setCurFieldCount(self):
        if self.ntotfieldcount > ControlScroller.nblockincrement:
            self.ncurfieldcount = ControlScroller.nblockincrement
        else:
            self.ncurfieldcount = self.ntotfieldcount

    def setTotalFieldCount(self, _ntotfieldcount):
        self.ntotfieldcount = _ntotfieldcount
        self.setCurFieldCount()
        if self.ntotfieldcount > ControlScroller.nblockincrement:
            self.xScrollBar.Model.Enabled = True
            self.xScrollBar.Model.ScrollValueMax = \
                self.ntotfieldcount - ControlScroller.nblockincrement
        else:
            self.xScrollBar.Model.Enabled = False

    def scrollControls(self):
        try:
            self.nscrollvalue = \
                int(self.xScrollBar.Model.ScrollValue)
            if self.nscrollvalue + ControlScroller.nblockincrement \
                    >= self.ntotfieldcount:
                self.nscrollvalue = \
                    self.ntotfieldcount - ControlScroller.nblockincrement
            self.fillupControls(False)
        except Exception:
            traceback.print_exc()

    '''
    updates the corresponding data to
    the control in guiRow and column
    @param guiRow 0 based row index
    @param column 0 based column index
    @return the propertyValue object corresponding to
    this control.
    '''

    def fieldInfo(self, guiRow, column):
        if guiRow + self.nscrollvalue < len(self.scrollfields):
            valueProp = (self.scrollfields[guiRow + self.nscrollvalue])[column]
            nameProp = (self.scrollfields[guiRow])[column]
            if self.CurUnoDialog.xDialogModel.hasByName(nameProp.Name):
                valueProp.Value = self.getControlData(nameProp.Name)
            else:
                valueProp.Value = nameProp.Value
            return valueProp
        else:
            return None

    def unregisterControlGroup(self, _index):
        del self.scrollfields[_index]

    def registerControlGroup(self, _currowproperties, _i):
        if _i == 0:
            del self.scrollfields[:]

        if _i >= len(self.scrollfields):
            self.scrollfields.append(_currowproperties)
        else:
            self.scrollfields.insert(_currowproperties, _i)

    def setControlData(self, controlname, newvalue):
        oControlModel = self.CurUnoDialog.xUnoDialog.getControl(
            controlname).Model
        propertyname = UnoDialog.getDisplayProperty(oControlModel)
        if propertyname:
            setattr(oControlModel, propertyname, newvalue)

    def getControlData(self, controlname):
        oControlModel = self.CurUnoDialog.xUnoDialog.getControl(
            controlname).Model
        propertyname = UnoDialog.getDisplayProperty(oControlModel)
        if propertyname:
            return getattr(oControlModel, propertyname)
        else:
            return None
