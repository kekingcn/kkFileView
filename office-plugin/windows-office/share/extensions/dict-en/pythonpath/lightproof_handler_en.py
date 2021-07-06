import uno
import unohelper
import lightproof_opts_en
from lightproof_impl_en import pkg

from com.sun.star.lang import XServiceInfo
from com.sun.star.awt import XContainerWindowEventHandler

# options
options = {}

def load(context):
    try:
        l = LightproofOptionsEventHandler(context)
        for i in lightproof_opts_en.lopts:
            l.load(i)
    except:
        pass

def get_option(page, option):
    try:
        return options[page + "," + option]
    except:
        try:
            return options[page[:2] + "," + option]
        except:
            return 0

def set_option(page, option, value):
    options[page + "," + option] = int(value)

class LightproofOptionsEventHandler( unohelper.Base, XServiceInfo, XContainerWindowEventHandler ):
    def __init__( self, ctx ):
        p = uno.createUnoStruct( "com.sun.star.beans.PropertyValue" )
        p.Name = "nodepath"
        p.Value = "/org.openoffice.Lightproof_%s/Leaves"%pkg
        self.xConfig = ctx.ServiceManager.createInstance( 'com.sun.star.configuration.ConfigurationProvider' )
        self.node = self.xConfig.createInstanceWithArguments( 'com.sun.star.configuration.ConfigurationUpdateAccess', (p, ) )
        self.service = "org.libreoffice.comp.pyuno.LightproofOptionsEventHandler." + pkg
        self.ImplementationName = self.service
        self.services = (self.service, )

    # XContainerWindowEventHandler
    def callHandlerMethod(self, aWindow, aEventObject, sMethod):
        if sMethod == "external_event":
            return self.handleExternalEvent(aWindow, aEventObject)

    def getSupportedMethodNames(self):
        return ("external_event", )

    def handleExternalEvent(self, aWindow, aEventObject):
        sMethod = aEventObject
        if sMethod == "ok":
            self.saveData(aWindow)
        elif sMethod == "back" or sMethod == "initialize":
            self.loadData(aWindow)
        return True

    def load(self, sWindowName):
        child = self.getChild(sWindowName)
        for i in lightproof_opts_en.lopts[sWindowName]:
            sValue = child.getPropertyValue(i)
            if sValue == '':
                if i in lightproof_opts_en.lopts_default[sWindowName]:
                    sValue = 1
                else:
                    sValue = 0
            set_option(sWindowName, i, sValue)

    def loadData(self, aWindow):
        sWindowName = self.getWindowName(aWindow)
        if (sWindowName == None):
            return
        child = self.getChild(sWindowName)
        for i in lightproof_opts_en.lopts[sWindowName]:
            sValue = child.getPropertyValue(i)
            if sValue == '':
                if i in lightproof_opts_en.lopts_default[sWindowName]:
                    sValue = 1
                else:
                    sValue = 0
            xControl = aWindow.getControl(i)
            xControl.State = sValue
            set_option(sWindowName, i, sValue)

    def saveData(self, aWindow):
        sWindowName = self.getWindowName(aWindow)
        if (sWindowName == None):
            return
        child = self.getChild(sWindowName)
        for i in lightproof_opts_en.lopts[sWindowName]:
            xControl = aWindow.getControl(i)
            sValue = xControl.State
            child.setPropertyValue(i, str(sValue))
            set_option(sWindowName, i, sValue)
        self.commitChanges()

    def getWindowName(self, aWindow):
        sName = aWindow.getModel().Name
        if sName in lightproof_opts_en.lopts:
            return sName
        return None

    # XServiceInfo method implementations
    def getImplementationName (self):
        return self.ImplementationName

    def supportsService(self, ServiceName):
        return (ServiceName in self.services)

    def getSupportedServiceNames (self):
        return self.services

    def getChild(self, name):
        return self.node.getByName(name)

    def commitChanges(self):
        self.node.commitChanges()
        return True
