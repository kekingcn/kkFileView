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
from unohelper import systemPathToFileUrl, absolutize
from ..common.Desktop import Desktop
from ..common.SystemDialog import SystemDialog

from com.sun.star.awt import WindowDescriptor
from com.sun.star.awt import Rectangle
from com.sun.star.awt.WindowClass import TOP
from com.sun.star.task import ErrorCodeIOException

#Window Constants
com_sun_star_awt_WindowAttribute_BORDER \
    = uno.getConstantByName( "com.sun.star.awt.WindowAttribute.BORDER" )
com_sun_star_awt_WindowAttribute_SIZEABLE \
    = uno.getConstantByName( "com.sun.star.awt.WindowAttribute.SIZEABLE" )
com_sun_star_awt_WindowAttribute_MOVEABLE \
    = uno.getConstantByName( "com.sun.star.awt.WindowAttribute.MOVEABLE" )
com_sun_star_awt_VclWindowPeerAttribute_CLIPCHILDREN \
    = uno.getConstantByName(
        "com.sun.star.awt.VclWindowPeerAttribute.CLIPCHILDREN" )

class OfficeDocument(object):
    '''Creates a new instance of OfficeDocument '''

    def __init__(self, _xMSF):
        self.xMSF = _xMSF

    @classmethod
    def attachEventCall(self, xComponent, EventName, EventType, EventURL):
        try:
            oEventProperties = list(range(2))
            oEventProperties[0] = uno.createUnoStruct(
                'com.sun.star.beans.PropertyValue')
            oEventProperties[0].Name = "EventType"
            oEventProperties[0].Value = EventType
            # "Service", "StarBasic"
            oEventProperties[1] = uno.createUnoStruct(
                'com.sun.star.beans.PropertyValue')
            oEventProperties[1].Name = "Script" #"URL";
            oEventProperties[1].Value = EventURL
            uno.invoke(xComponent.Events, "replaceByName",
                (EventName, uno.Any("[]com.sun.star.beans.PropertyValue",
                    tuple(oEventProperties))))
        except Exception:
            traceback.print_exc()

    def dispose(self, xMSF, xComponent):
        try:
            if xComponent is not None:
                xFrame = xComponent.CurrentController.Frame
                if xComponent.isModified():
                    xComponent.setModified(False)

                Desktop.dispatchURL(xMSF, ".uno:CloseDoc", xFrame)

        except Exception:
            traceback.print_exc()

    @classmethod
    def createNewFrame(self, xMSF, listener, FrameName="_blank"):
        xFrame = None
        if FrameName.lower() == "WIZARD_LIVE_PREVIEW".lower():
            xFrame = self.createNewPreviewFrame(xMSF, listener)
        else:
            xF = Desktop.getDesktop(xMSF)
            xFrame = xF.findFrame(FrameName, 0)
            if listener is not None:
                xFF = xF.getFrames()
                xFF.remove(xFrame)
                xF.addTerminateListener(listener)

        return xFrame

    @classmethod
    def createNewPreviewFrame(self, xMSF, listener):
        xToolkit = None
        try:
            xToolkit = xMSF.createInstance("com.sun.star.awt.Toolkit")
        except Exception:
            # TODO Auto-generated catch block
            traceback.print_exc()

        #describe the window and its properties
        aDescriptor = WindowDescriptor()
        aDescriptor.Type = TOP
        aDescriptor.WindowServiceName = "window"
        aDescriptor.ParentIndex = -1
        aDescriptor.Parent = None
        aDescriptor.Bounds = Rectangle(10, 10, 640, 480)

        #Set Window Attributes
        gnDefaultWindowAttributes = \
            com_sun_star_awt_WindowAttribute_BORDER + \
            com_sun_star_awt_WindowAttribute_MOVEABLE + \
            com_sun_star_awt_WindowAttribute_SIZEABLE + \
            com_sun_star_awt_VclWindowPeerAttribute_CLIPCHILDREN

        aDescriptor.WindowAttributes = gnDefaultWindowAttributes
        #create a new blank container window
        xPeer = None
        try:
            xPeer = xToolkit.createWindow(aDescriptor)
        except Exception:
            traceback.print_exc()

        #define some further properties of the frame window
        #if it's needed .-)
        #xPeer->setBackground(...);
        #create new empty frame and set window on it
        xFrame = None
        try:
            xFrame = xMSF.createInstance("com.sun.star.frame.Frame")
        except Exception:
            traceback.print_exc()

        xFrame.initialize(xPeer)
        #from now this frame is usable ...
        #and not part of the desktop tree.
        #You are alone with him .-)
        if listener is not None:
            Desktop.getDesktop(xMSF).addTerminateListener(listener)

        return xFrame

    @classmethod
    def load(self, xInterface, sURL, sFrame, xValues):
        xComponent = None
        try:
            if not sURL.startswith("file://"):
                sURL = systemPathToFileUrl(sURL)
            xComponent = xInterface.loadComponentFromURL(
                sURL, sFrame, 0, tuple(xValues))
        except Exception:
            traceback.print_exc()

        return xComponent

    @classmethod
    def store(self, xMSF, xComponent, StorePath, FilterName):
        try:
            if len(FilterName):
                oStoreProperties = list(range(2))
                oStoreProperties[0] = uno.createUnoStruct(
                    'com.sun.star.beans.PropertyValue')
                oStoreProperties[0].Name = "FilterName"
                oStoreProperties[0].Value = FilterName
                oStoreProperties[1] = uno.createUnoStruct(
                    'com.sun.star.beans.PropertyValue')
                oStoreProperties[1].Name = "InteractionHandler"
                oStoreProperties[1].Value = xMSF.createInstance(
                    "com.sun.star.comp.uui.UUIInteractionHandler")
            else:
                oStoreProperties = list(range(0))

            StorePath = systemPathToFileUrl(StorePath)
            sPath = StorePath[:(StorePath.rfind("/") + 1)]
            sFile = StorePath[(StorePath.rfind("/") + 1):]
            xComponent.storeToURL(
                absolutize(sPath, sFile), tuple(oStoreProperties))
            return True
        except ErrorCodeIOException:
            #Throw this exception when trying to save a file
            #which is already opened in Libreoffice
            #TODO: handle it properly
            return True
            pass
        except Exception:
            traceback.print_exc()
            return False

    def close(self, xComponent):
        bState = False
        if xComponent is not None:
            try:
                xComponent.close(True)
                bState = True
            except Exception:
                print ("could not close doc")
                bState = False

        else:
            bState = True

        return bState

    def showMessageBox(
        self, xMSF, windowServiceName, windowAttribute, MessageText):

        return SystemDialog.showMessageBox(
            xMSF, windowServiceName, windowAttribute, MessageText)
