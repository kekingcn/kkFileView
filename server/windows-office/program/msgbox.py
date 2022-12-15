# -*- tab-width: 4; indent-tabs-mode: nil; py-indent-offset: 4 -*-
#
# This file is part of the LibreOffice project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# prepare Python environment - Add the path of this class
from os import path
from sys import modules
from sys import path as syspath

# pyUNO program itself
import uno, unohelper

# UNO GUI toolkit
from com.sun.star.awt.WindowClass import TOP, SIMPLE
from com.sun.star.awt.PushButtonType import STANDARD as standard
from com.sun.star.awt.PushButtonType import OK as ok
from com.sun.star.awt.PushButtonType import CANCEL as cancel
from com.sun.star.awt.PushButtonType import HELP as help
from com.sun.star.awt.TextAlign import CENTER as center
from com.sun.star.awt.TextAlign import LEFT as left
from com.sun.star.awt.TextAlign import RIGHT as right

# used UNO listeners
from com.sun.star.awt import XActionListener

class MsgBox(unohelper.Base):
    """Inspect UNO object, link to sdk and recursive calls"""

    def __init__(self, aContext):
        """acontext : a Valid UNO context
        """

        self.VERSION = '0.1'
        self.ctx = aContext
        self.smgr = aContext.ServiceManager
        # UI Dialog object
        self.dialog=None
        # List of opened Listeners
        self.lst_listeners={}
        #UI parameters
        self.ButtonSize = 50
        self.boxSize = 200
        self.lineHeight = 10
        self.fromBroxSize = False
        self.numberOfLines = -1

        self.Buttons = []
        self.Response = ''

        return

    #####################################################
    #                 GUI definition                    #
    #####################################################
    def _createBox(self):
        """Create the Box"""

        # computes parameters of the message dialog
        if self.numberOfLines == -1:
            #calculate
            numberOfLines = len(self.message.split(chr(10)))
        else:
            numberOfLines = self.numberOfLines

        numberOfButtons = len(self.Buttons)
        self.ButtonSpace = self.ButtonSize/2
        if self.fromBroxSize:
            # button size is calculated from boxsize
            size = (2 * self.boxSize) / (3 * numberOfButtons + 1)
            self.ButtonSize = size
            self.ButtonSpace = self.ButtonSize/2
        else:
            # boxsize is calculated from buttonsize
            self.boxSize = numberOfButtons * (self.ButtonSize +
                                            self.ButtonSpace) + self.ButtonSpace

        # create the dialog model and set the properties
        dialog_model = self.smgr.createInstanceWithContext(
                                    'com.sun.star.awt.UnoControlDialogModel',
                                    self.ctx)
        dialog_model.PositionX = 50
        dialog_model.Step = 1
        dialog_model.TabIndex = 7
        dialog_model.Width = self.boxSize#numberOfButtons * (self.ButtonSize +
                             #               self.ButtonSpace) + 25
        dialog_model.Height = 10 + self.lineHeight * numberOfLines + 10 + 12  + 10
        dialog_model.PositionY = 63
        dialog_model.Sizeable = True
        dialog_model.Closeable = False

        dialog = self.smgr.createInstanceWithContext(
                'com.sun.star.awt.UnoControlDialog', self.ctx)

        # label Label0
        label = dialog_model.createInstance(
                'com.sun.star.awt.UnoControlFixedTextModel')
        label.PositionX =  10
        label.TabIndex = 9
        label.Width = dialog_model.Width - label.PositionX
        label.Height = self.lineHeight* numberOfLines
        label.PositionY = 10
        label.Align = left
        label.MultiLine = True
        label.Label = self.message
        dialog_model.insertByName('Label0', label)

        nb = 0
        for buttonName in self.Buttons:
            nb +=1
            button = dialog_model.createInstance(
                                    'com.sun.star.awt.UnoControlButtonModel')
            button.PositionX = nb * self.ButtonSpace + (nb-1)* self.ButtonSize
            button.TabIndex = 8
            button.Height = 12
            button.Width = self.ButtonSize
            button.PositionY = 10 + label.Height + 10
            button.PushButtonType = standard
            if nb == 1:
                button.DefaultButton = True
            else:
                button.DefaultButton = False
            button.Label = buttonName
            dialog_model.insertByName('Btn' + str(nb), button )

        if not dialog.getModel():
            dialog.setModel(dialog_model)

        # UNO toolkit definition
        toolkit = self.smgr.createInstanceWithContext('com.sun.star.awt.Toolkit', self.ctx)
        a_rect = uno.createUnoStruct( 'com.sun.star.awt.Rectangle' )
        a_rect.X = 50
        dialog.setTitle ( self.title )
        a_rect.Width = 270
        a_rect.Height = 261
        a_rect.Y = 63
        win_descriptor = uno.createUnoStruct('com.sun.star.awt.WindowDescriptor')
        win_descriptor.Type = TOP
        win_descriptor.ParentIndex = -1
        win_descriptor.Bounds = a_rect
        peer = toolkit.createWindow( win_descriptor )
        dialog.createPeer( toolkit, peer )

        return dialog

    def _addListeners(self):
        """Add listeners to dialog"""
        nb = 0
        for buttonName in self.Buttons:
            nb +=1
            a_control = self.dialog.getControl('Btn'+str(nb))
            the_listener = ButtonListener(self)
            a_control.addActionListener(the_listener)
            self.lst_listeners['Btn'+str(nb)] = the_listener
        return

    def _removeListeners(self):
        """ remove listeners on exiting"""
        nb = 0
        for buttonName in self.Buttons:
            nb +=1
            a_control = self.dialog.getControl('Btn'+str(nb))
            a_control.removeActionListener(self.lst_listeners['Btn'+str(nb)])
        return

    def show(self, message, decoration, title):
        self.message = message
        self.decoration = decoration
        self.title = title
        # Create GUI
        self.dialog = self._createBox()
        self._addListeners()
        #execute the dialog --> blocking call
        self.dialog.execute()
        #end --> release listeners and dispose dialog
        self._removeListeners()
        self.dialog.dispose()
        return self.Response

    def addButton(self, caption):
        self.Buttons.append(caption)
        return

    def renderFromBoxSize(self, size = 150):
        self.boxSize = size
        self.fromBroxSize = True
        return

    def renderFromButtonSize(self, size = 50):
        self.ButtonSize = size
        self.fromBroxSize = False
        return

class ButtonListener(unohelper.Base, XActionListener):
    """Stops the MessageBox, sets the button label as returned value"""
    def __init__(self, caller):
        self.caller = caller

    def disposing(self, eventObject):
        pass

    def actionPerformed(self, actionEvent):
        button = actionEvent.Source
        self.caller.Response = button.Model.Label
        self.caller.dialog.endExecute()
        return

### TEST
if __name__ == '__main__':
    # get the uno component context from the PyUNO runtime
    localContext = uno.getComponentContext()

    # create the UnoUrlResolver
    resolver = localContext.ServiceManager.createInstanceWithContext(
                    "com.sun.star.bridge.UnoUrlResolver", localContext )

    # connect to the running office
    # LibO has to be launched in listen mode as
    # ./soffice "--accept=socket,host=localhost,port=2002;urp;"
    ctx = resolver.resolve( "uno:socket,host=localhost,port=2002;urp;StarOffice.ComponentContext" )
    myBox = MsgBox(ctx)
    myBox.addButton("Yes")
    myBox.addButton("No")
    myBox.addButton("May be")
    myBox.renderFromBoxSize(150)
    myBox.numberOflines = 2

    print(myBox.show("A very long message A very long message A very long message A very long message A very long message A very long message A very long message A very long message A very long message A very long message " + chr(10)+chr(10)+"Do you agree ?",0,"Dialog title"))

    myBox = MsgBox(ctx)
    myBox.addButton("oK")
    myBox.renderFromButtonSize()
    myBox.numberOflines = 2

    print(myBox.show("A small message",0,"Dialog title"))

# vim: set shiftwidth=4 softtabstop=4 expandtab:
