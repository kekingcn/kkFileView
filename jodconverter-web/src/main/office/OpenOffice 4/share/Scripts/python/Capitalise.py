# *************************************************************
#  
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#  
#    http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing,
#  software distributed under the License is distributed on an
#  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#  KIND, either express or implied.  See the License for the
#  specific language governing permissions and limitations
#  under the License.
#  
# *************************************************************


# helper function
def getNewString( theString ) :
    if( not theString or len(theString) ==0) :
        return ""
    # should we tokenize on "."?
    if theString[0].isupper() and len(theString)>=2 and theString[1].isupper() :
        # first two chars are UC => first UC, rest LC
        newString=theString[0:1].upper() + theString[1:].lower();
    elif theString[0].isupper():
        # first char UC => all to LC
        newString=theString.lower()
    else: # all to UC.
        newString=theString.upper()
    return newString;

def capitalisePython( ):
    """Change the case of a selection, or current word from upper case, to first char upper case, to all lower case to upper case..."""
    import string

    # The context variable is of type XScriptContext and is available to
    # all BeanShell scripts executed by the Script Framework
    xModel = XSCRIPTCONTEXT.getDocument()

    #the writer controller impl supports the css.view.XSelectionSupplier interface
    xSelectionSupplier = xModel.getCurrentController()

    #see section 7.5.1 of developers' guide
    xIndexAccess = xSelectionSupplier.getSelection()
    count = xIndexAccess.getCount();
    if(count>=1):  #ie we have a selection
        i=0
        while i < count :
            xTextRange = xIndexAccess.getByIndex(i);
            #print "string: " + xTextRange.getString();
            theString = xTextRange.getString();
            if len(theString)==0 :
                # sadly we can have a selection where nothing is selected
                # in this case we get the XWordCursor and make a selection!
                xText = xTextRange.getText();
                xWordCursor = xText.createTextCursorByRange(xTextRange);
                if not xWordCursor.isStartOfWord():
                    xWordCursor.gotoStartOfWord(False);
                xWordCursor.gotoNextWord(True);
                theString = xWordCursor.getString();
                newString = getNewString(theString);
                if newString :
                    xWordCursor.setString(newString);
                    xSelectionSupplier.select(xWordCursor);
            else :

                newString = getNewString( theString );
                if newString:
                    xTextRange.setString(newString);
                    xSelectionSupplier.select(xTextRange);
            i+= 1


# lists the scripts, that shall be visible inside OOo. Can be omited, if
# all functions shall be visible, however here getNewString shall be surpressed
g_exportedScripts = capitalisePython,
