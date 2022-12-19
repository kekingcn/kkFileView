#
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
from .PeerConfig import PeerConfig
from .UIConsts import UIConsts
from ..common.PropertyNames import PropertyNames

from com.sun.star.awt import Rectangle
from com.sun.star.awt.PosSize import POS

class UnoDialog(object):

    createDict = False
    dictProperties = None
    BisHighContrastModeActivated = None
    xVclWindowPeer = None

    def __init__(self, xMSF, PropertyNames, PropertyValues):
        try:
            self.xMSF = xMSF
            self.ControlList = {}
            self.xDialogModel = xMSF.createInstance(
                "com.sun.star.awt.UnoControlDialogModel")
            self.xUnoDialog = xMSF.createInstance(
                "com.sun.star.awt.UnoControlDialog")
            self.xUnoDialog.setModel(self.xDialogModel)
            self.m_oPeerConfig = None
            self.xWindowPeer = None
        except Exception:
            traceback.print_exc()

    # repaints the currentDialogStep
    def repaintDialogStep(self):
        try:
            ncurstep = int(self.xDialogModel.Step)
            self.xDialogModel.Step = 99
            self.xDialogModel.Step = ncurstep
        except Exception:
            traceback.print_exc()

    def insertControlModel(self, serviceName, componentName, sPropNames, oPropValues):
        try:
            xControlModel = self.xDialogModel.createInstance(serviceName)
            uno.invoke(xControlModel, "setPropertyValues",
                    (sPropNames, oPropValues))
            self.xDialogModel.insertByName(componentName, xControlModel)
            xControlModel.Name = componentName
        except Exception:
            traceback.print_exc()

        aObj = self.xUnoDialog.getControl(componentName)
        return aObj

    def setFocus(self, ControlName):
        oFocusControl = self.xUnoDialog.getControl(ControlName)
        oFocusControl.setFocus()

    def calculateDialogPosition(self, FramePosSize):
        # Todo:check if it would be useful or possible to create a dialog peer
        # that can be used for the messageboxes to
        # maintain modality when they pop up.
        CurPosSize = self.xUnoDialog.getPosSize()
        WindowHeight = FramePosSize.Height
        WindowWidth = FramePosSize.Width
        DialogWidth = CurPosSize.Width
        DialogHeight = CurPosSize.Height
        iXPos = ((WindowWidth / 2) - (DialogWidth / 2))
        iYPos = ((WindowHeight / 2) - (DialogHeight / 2))
        self.xUnoDialog.setPosSize(
            iXPos, iYPos, DialogWidth, DialogHeight, POS)

    '''
     @param FramePosSize
    @return 0 for cancel, 1 for ok
    @throws com.sun.star.uno.Exception
    '''

    def executeDialog(self, FramePosSize):
        if self.xUnoDialog.getPeer() is None:
            raise AttributeError(
                "Please create a peer, using your own frame")

        self.calculateDialogPosition(FramePosSize)

        if self.xWindowPeer is None:
            self.createWindowPeer()

        self.xVclWindowPeer = self.xWindowPeer
        self.BisHighContrastModeActivated = self.isHighContrastModeActivated()
        return self.xUnoDialog.execute()

    def setVisible(self, parent):
        self.calculateDialogPosition(parent.xUnoDialog.getPosSize())
        if self.xWindowPeer == None:
            self.createWindowPeer()

        self.xUnoDialog.setVisible(True)

    '''
    @param XComponent
    @return 0 for cancel, 1 for ok
    @throws com.sun.star.uno.Exception
    '''

    def executeDialogFromComponent(self, xComponent):
        if xComponent is not None:
            w = xComponent.ComponentWindow
            if w is not None:
                return self.executeDialog(w.PosSize)

        return self.executeDialog( Rectangle (0, 0, 640, 400))

    '''
    create a peer for this
    dialog, using the given
    peer as a parent.
    @param parentPeer
    @return
    @throws java.lang.Exception
    '''

    def createWindowPeer(self, parentPeer=None):
        self.xUnoDialog.setVisible(False)
        xToolkit = self.xMSF.createInstance("com.sun.star.awt.Toolkit")
        if parentPeer is None:
            parentPeer = xToolkit.getDesktopWindow()

        self.xUnoDialog.createPeer(xToolkit, parentPeer)
        self.xWindowPeer = self.xUnoDialog.getPeer()
        return self.xUnoDialog.getPeer()

    @classmethod
    def setEnabled(self, control, enabled):
        control.Model.Enabled = enabled

    @classmethod
    def getModel(self, control):
        return control.getModel()

    @classmethod
    def getDisplayProperty(self, xServiceInfo):
        if xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlFixedTextModel"):
            return PropertyNames.PROPERTY_LABEL
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlButtonModel"):
            return PropertyNames.PROPERTY_LABEL
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlCurrencyFieldModel"):
            return "Value"
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlDateFieldModel"):
            return "Date"
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlFixedLineModel"):
            return PropertyNames.PROPERTY_LABEL
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlFormattedFieldModel"):
            return "EffectiveValue"
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlNumericFieldModel"):
            return "Value"
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlPatternFieldModel"):
            return "Text"
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlProgressBarModel"):
            return "ProgressValue"
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlTimeFieldModel"):
            return "Time"
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlImageControlModel"):
            return PropertyNames.PROPERTY_IMAGEURL
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlRadioButtonModel"):
            return PropertyNames.PROPERTY_STATE
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlCheckBoxModel"):
            return PropertyNames.PROPERTY_STATE
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlEditModel"):
            return "Text"
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlComboBoxModel"):
            return "Text"
        elif xServiceInfo.supportsService(
                "com.sun.star.awt.UnoControlListBoxModel"):
            return "SelectedItems"
        else:
            return ""

    def isHighContrastModeActivated(self):
        if (self.xVclWindowPeer is not None):
            if (self.BisHighContrastModeActivated is None):
                nUIColor = 0
                try:
                    nUIColor = self.xVclWindowPeer.getProperty("DisplayBackgroundColor")
                except Exception:
                    traceback.print_exc()
                    return False

                # TODO: The following methods could be wrapped in an own class implementation
                nRed = self.getRedColorShare(nUIColor)
                nGreen = self.getGreenColorShare(nUIColor)
                nBlue = self.getBlueColorShare(nUIColor)
                nLuminance = ((nBlue * 28 + nGreen * 151 + nRed * 77) / 256)
                bisactivated = (nLuminance <= 25)
                self.BisHighContrastModeActivated = bool(bisactivated)
                return bisactivated;
            else:
                return self.BisHighContrastModeActivated
        else:
            return False


    def getRedColorShare(self, _nColor):
        nRed = _nColor / 65536
        nRedModulo = _nColor % 65536
        nGreen = nRedModulo / 256
        nGreenModulo = (nRedModulo % 256)
        nBlue = nGreenModulo
        return nRed

    def getGreenColorShare(self, _nColor):
        nRed = _nColor / 65536
        nRedModulo = _nColor % 65536
        nGreen = nRedModulo / 256
        return nGreen

    def getBlueColorShare(self, _nColor):
        nRed = _nColor / 65536
        nRedModulo = _nColor % 65536
        nGreen = nRedModulo / 256
        nGreenModulo = (nRedModulo % 256)
        nBlue = nGreenModulo
        return nBlue
