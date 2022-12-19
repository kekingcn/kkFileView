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
from .UnoDialog import UnoDialog, UIConsts
from ..common.Desktop import Desktop
from ..common.PropertyNames import PropertyNames
from ..common.SystemDialog import SystemDialog
from .event.CommonListener import ItemListenerProcAdapter, \
    ActionListenerProcAdapter, TextListenerProcAdapter, \
    AdjustmentListenerProcAdapter

'''
This class contains convenience methods for inserting components to a dialog.
It was created for use with the automatic conversion of Basic XML Dialog
description files to a Java class which builds
the same dialog through the UNO API.<br/>
It uses an Event-Listener method, which calls a method through reflection
when an event on a component is triggered.
see the classes CommonListener for details
'''

class UnoDialog2(UnoDialog):

    '''
    Override this method to return another listener.
    @return
    '''

    def __init__(self, xmsf):
        super(UnoDialog2,self).__init__(xmsf,(), ())
        ControlList = {}

    def insertButton(
        self, sName, actionPerformed, sPropNames, oPropValues, listener):
        xButton = self.insertControlModel(
            "com.sun.star.awt.UnoControlButtonModel",
            sName, sPropNames, oPropValues)
        if actionPerformed is not None:
            actionPerformed = getattr(listener, actionPerformed)
            xButton.addActionListener(
                ActionListenerProcAdapter(actionPerformed))

        return xButton

    def insertCheckBox(
        self, sName, itemChanged, sPropNames, oPropValues, listener):
        xCheckBox = self.insertControlModel(
            "com.sun.star.awt.UnoControlCheckBoxModel",
            sName, sPropNames, oPropValues)
        if itemChanged is not None:
            itemChanged = getattr(listener, itemChanged)
            xCheckBox.addItemListener(ItemListenerProcAdapter(itemChanged))

        return xCheckBox

    def insertComboBox(
        self, sName, actionPerformed, itemChanged,
        textChanged, sPropNames, oPropValues, listener):
        xComboBox = self.insertControlModel(
        "com.sun.star.awt.UnoControlComboBoxModel",
        sName, sPropNames, oPropValues)
        if actionPerformed is not None:
            actionPerformed = getattr(listener, actionPerformed)
            xComboBox.addActionListener(
                ActionListenerProcAdapter(actionPerformed))

        if itemChanged is not None:
            itemChanged = getattr(listener, itemChanged)
            xComboBox.addItemListener(ItemListenerProcAdapter(itemChanged))

        if textChanged is not None:
            textChanged = getattr(listener, textChanged)
            xComboBox.addTextListener(TextListenerProcAdapter(textChanged))

        return xComboBox

    def insertListBox(
        self, sName, actionPerformed, itemChanged,
        sPropNames, oPropValues, listener):
        xListBox = self.insertControlModel(
            "com.sun.star.awt.UnoControlListBoxModel",
            sName, sPropNames, oPropValues)

        if itemChanged is not None:
            itemChanged = getattr(listener, itemChanged)
            xListBox.addItemListener(ItemListenerProcAdapter(itemChanged))

        return xListBox

    def insertRadioButton(
        self, sName, itemChanged, sPropNames, oPropValues, listener):
        xRadioButton = self.insertControlModel(
            "com.sun.star.awt.UnoControlRadioButtonModel",
            sName, sPropNames, oPropValues)
        if itemChanged is not None:
            itemChanged = getattr(listener, itemChanged)
            xRadioButton.addItemListener(
                ItemListenerProcAdapter(itemChanged))

        return xRadioButton

    def insertTextField(
        self, sName, sTextChanged, sPropNames, oPropValues, listener):
        return self.insertEditField(
            sName, sTextChanged, "com.sun.star.awt.UnoControlEditModel",
            sPropNames, oPropValues, listener)

    def insertImage(self, sName, sPropNames, oPropValues):
        return self.insertControlModel(
            "com.sun.star.awt.UnoControlImageControlModel",
            sName, sPropNames, oPropValues)

    def insertInfoImage(self, _posx, _posy, _iStep):
        xImgControl = self.insertImage(
            Desktop.getUniqueName(self.xDialogModel, "imgHint"),
            ("Border",
                PropertyNames.PROPERTY_HEIGHT,
                PropertyNames.PROPERTY_IMAGEURL,
                PropertyNames.PROPERTY_POSITION_X,
                PropertyNames.PROPERTY_POSITION_Y, "ScaleImage",
                PropertyNames.PROPERTY_STEP,
                PropertyNames.PROPERTY_WIDTH),
            (0, 10, UIConsts.INFOIMAGEURL, _posx, _posy, False, _iStep, 10))
        return xImgControl

    '''
    This method is used for creating Edit, Currency, Date, Formatted,
    Pattern, File and Time edit components.
    '''

    def insertEditField(
        self, sName, sTextChanged, sModelClass,
        sPropNames, oPropValues, listener):
        xField = self.insertControlModel(sModelClass,
            sName, sPropNames, oPropValues)
        if sTextChanged is not None:
            sTextChanged = getattr(listener, sTextChanged)
            xField.addTextListener(TextListenerProcAdapter(sTextChanged))
        return xField

    def insertDateField(
        self, sName, sTextChanged, sPropNames, oPropValues, listener):
        return self.insertEditField(
            sName, sTextChanged,
            "com.sun.star.awt.UnoControlDateFieldModel",
            sPropNames, oPropValues, listener)

    def insertNumericField(
        self, sName, sTextChanged, sPropNames, oPropValues, listener):
        return self.insertEditField(
            sName, sTextChanged,
            "com.sun.star.awt.UnoControlNumericFieldModel",
            sPropNames, oPropValues, listener)

    def insertTimeField(
        self, sName, sTextChanged, sPropNames, oPropValues, listener):
        return self.insertEditField(
            sName, sTextChanged,
            "com.sun.star.awt.UnoControlTimeFieldModel",
            sPropNames, oPropValues, listener)

    def insertFixedLine(self, sName, sPropNames, oPropValues):
        oLine = self.insertControlModel(
            "com.sun.star.awt.UnoControlFixedLineModel",
            sName, sPropNames, oPropValues)
        return oLine

    def insertLabel(self, sName, sPropNames, oPropValues):
        oFixedText = self.insertControlModel(
            "com.sun.star.awt.UnoControlFixedTextModel",
            sName, sPropNames, oPropValues)
        return oFixedText

    def insertScrollBar(self, sName, sPropNames, oPropValues,
            iControlKey, listener):
        oScrollBar = self.insertControlModel(
            "com.sun.star.awt.UnoControlScrollBarModel",
            sName, sPropNames, oPropValues)
        if listener is not None:
            method = getattr(listener, "scrollControls")
            oScrollBar.addAdjustmentListener(
                AdjustmentListenerProcAdapter(method))
        if self.ControlList is not None:
            self.ControlList[sName] = iControlKey
        return oScrollBar

    def showMessageBox(self, windowServiceName, windowAttribute, MessageText):
        return SystemDialog.showMessageBox(
            super().xMSF, self.xControl.Peer,
            windowServiceName, windowAttribute, MessageText)
