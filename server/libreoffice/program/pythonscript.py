# -*- tab-width: 4; indent-tabs-mode: nil; py-indent-offset: 4 -*-
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
# XScript implementation for python
import uno
import unohelper
import sys
import os
import types
import time
import ast
import platform
from com.sun.star.uri.RelativeUriExcessParentSegments import RETAIN

class LogLevel:
    NONE = 0   # production level
    ERROR = 1  # for script developers
    DEBUG = 2  # for script framework developers

PYSCRIPT_LOG_ENV = "PYSCRIPT_LOG_LEVEL"
PYSCRIPT_LOG_STDOUT_ENV = "PYSCRIPT_LOG_STDOUT"

# Configuration ----------------------------------------------------
LogLevel.use = LogLevel.NONE
if os.environ.get(PYSCRIPT_LOG_ENV) == "ERROR":
    LogLevel.use = LogLevel.ERROR
elif os.environ.get(PYSCRIPT_LOG_ENV) == "DEBUG":
    LogLevel.use = LogLevel.DEBUG

# True, writes to stdout (difficult on windows)
# False, writes to user/Scripts/python/log.txt
LOG_STDOUT = os.environ.get(PYSCRIPT_LOG_STDOUT_ENV, "1") != "0"

ENABLE_EDIT_DIALOG=False                    # offers a minimal editor for editing.
#-------------------------------------------------------------------

def encfile(uni):
    return uni.encode( sys.getfilesystemencoding())

def lastException2String():
    (excType,excInstance,excTraceback) = sys.exc_info()
    ret = str(excType) + ": "+str(excInstance) + "\n" + \
          uno._uno_extract_printable_stacktrace( excTraceback )
    return ret

def logLevel2String( level ):
    ret = " NONE"
    if level == LogLevel.ERROR:
        ret = "ERROR"
    elif level >= LogLevel.DEBUG:
        ret = "DEBUG"
    return ret

def getLogTarget():
    ret = sys.stdout
    if not LOG_STDOUT:
        try:
            pathSubst = uno.getComponentContext().ServiceManager.createInstance(
                "com.sun.star.util.PathSubstitution" )
            userInstallation =  pathSubst.getSubstituteVariableValue( "user" )
            if len( userInstallation ) > 0:
                systemPath = uno.fileUrlToSystemPath( userInstallation + "/Scripts/python/log.txt" )
                ret = open( systemPath , "a" )
        except:
            print("Exception during creation of pythonscript logfile: "+ lastException2String() + "\n, delegating log to stdout\n")
    return ret

class Logger(LogLevel):
    def __init__(self , target ):
        self.target = target

    def isDebugLevel( self ):
        return self.use >= self.DEBUG

    def debug( self, msg ):
        if self.isDebugLevel():
            self.log( self.DEBUG, msg )

    def isErrorLevel( self ):
        return self.use >= self.ERROR

    def error( self, msg ):
        if self.isErrorLevel():
            self.log( self.ERROR, msg )

    def log( self, level, msg ):
        if self.use >= level:
            try:
                self.target.write(
                    time.asctime() +
                    " [" +
                    logLevel2String( level ) +
                    "] " +
                    msg +
                    "\n" )
                self.target.flush()
            except:
                print("Error during writing to stdout: " +lastException2String() + "\n")

log = Logger( getLogTarget() )

log.debug( "pythonscript loading" )

#from com.sun.star.lang import typeOfXServiceInfo, typeOfXTypeProvider
from com.sun.star.uno import RuntimeException
from com.sun.star.lang import IllegalArgumentException
from com.sun.star.container import NoSuchElementException
from com.sun.star.lang import XServiceInfo
from com.sun.star.io import IOException
from com.sun.star.ucb import CommandAbortedException, XCommandEnvironment, XProgressHandler, Command
from com.sun.star.task import XInteractionHandler
from com.sun.star.beans import XPropertySet, Property
from com.sun.star.container import XNameContainer
from com.sun.star.xml.sax import XDocumentHandler, InputSource
from com.sun.star.uno import Exception as UnoException
from com.sun.star.script import XInvocation
from com.sun.star.awt import XActionListener

from com.sun.star.script.provider import XScriptProvider, XScript, XScriptContext, ScriptFrameworkErrorException
from com.sun.star.script.browse import XBrowseNode
from com.sun.star.script.browse.BrowseNodeTypes import SCRIPT, CONTAINER, ROOT
from com.sun.star.util import XModifyListener

LANGUAGENAME = "Python"
GLOBAL_SCRIPTCONTEXT_NAME = "XSCRIPTCONTEXT"
CALLABLE_CONTAINER_NAME =  "g_exportedScripts"

# pythonloader looks for a static g_ImplementationHelper variable
g_ImplementationHelper = unohelper.ImplementationHelper()
g_implName = "org.libreoffice.pyuno.LanguageScriptProviderFor"+LANGUAGENAME



BLOCK_SIZE = 65536
def readTextFromStream( inputStream ):
    # read the file
    code = uno.ByteSequence( b"" )
    while True:
        read,out = inputStream.readBytes( None , BLOCK_SIZE )
        code = code + out
        if read < BLOCK_SIZE:
           break
    return code.value

def toIniName( str ):
    if platform.system() == "Windows":
        return str + ".ini"
    else:
        return str + "rc"


""" definition: storageURI is the system dependent, absolute file url, where the script is stored on disk
                scriptURI is the system independent uri
"""
class MyUriHelper:

    def __init__( self, ctx, location ):
        self.ctx = ctx
        self.s_UriMap = \
        { "share" : "vnd.sun.star.expand:$BRAND_BASE_DIR/$BRAND_SHARE_SUBDIR/Scripts/python" , \
          "share:uno_packages" : "vnd.sun.star.expand:$UNO_SHARED_PACKAGES_CACHE/uno_packages", \
          "user" : "vnd.sun.star.expand:${$BRAND_INI_DIR/" + toIniName( "bootstrap") + "::UserInstallation}/user/Scripts/python" , \
          "user:uno_packages" : "vnd.sun.star.expand:$UNO_USER_PACKAGES_CACHE/uno_packages" }
        self.m_uriRefFac = ctx.ServiceManager.createInstanceWithContext("com.sun.star.uri.UriReferenceFactory",ctx)
        if location.startswith( "vnd.sun.star.tdoc" ):
            self.m_baseUri = location + "/Scripts/python"
            self.m_scriptUriLocation = "document"
        else:
            self.m_baseUri = expandUri( self.s_UriMap[location] )
            self.m_scriptUriLocation = location
        log.debug( "initialized urihelper with baseUri="+self.m_baseUri + ",m_scriptUriLocation="+self.m_scriptUriLocation )

    def getRootStorageURI( self ):
        return self.m_baseUri

    def getStorageURI( self, scriptURI ):
        return self.scriptURI2StorageUri(scriptURI)

    def getScriptURI( self, storageURI ):
        return self.storageURI2ScriptUri(storageURI)

    def storageURI2ScriptUri( self, storageURI ):
        if not storageURI.startswith( self.m_baseUri ):
            message = "pythonscript: storage uri '" + storageURI + "' not in base uri '" + self.m_baseUri + "'"
            log.debug( message )
            raise RuntimeException( message, self.ctx )

        ret = "vnd.sun.star.script:" + \
              storageURI[len(self.m_baseUri)+1:].replace("/","|") + \
              "?language=" + LANGUAGENAME + "&location=" + self.m_scriptUriLocation
        log.debug( "converting storageURI="+storageURI + " to scriptURI=" + ret )
        return ret

    def scriptURI2StorageUri( self, scriptURI ):
        try:
            # base path to the python script location
            sBaseUri = self.m_baseUri + "/"
            xBaseUri = self.m_uriRefFac.parse(sBaseUri)

            # path to the .py file + "$functionname, arguments, etc
            xStorageUri = self.m_uriRefFac.parse(scriptURI)
            # getName will apply url-decoding to the name, so encode back
            sStorageUri = xStorageUri.getName().replace("%", "%25")
            sStorageUri = sStorageUri.replace( "|", "/" )

            # path to the .py file, relative to the base
            funcNameStart = sStorageUri.find("$")
            if funcNameStart != -1:
                sFileUri = sStorageUri[0:funcNameStart]
                sFuncName = sStorageUri[funcNameStart+1:]
            else:
                sFileUri = sStorageUri

            xFileUri = self.m_uriRefFac.parse(sFileUri)
            if not xFileUri:
                message = "pythonscript: invalid relative uri '" + sFileUri+ "'"
                log.debug( message )
                raise RuntimeException( message, self.ctx )

            if not xFileUri.hasRelativePath():
                message = "pythonscript: an absolute uri is invalid '" + sFileUri+ "'"
                log.debug( message )
                raise RuntimeException( message, self.ctx )

            # absolute path to the .py file
            xAbsScriptUri = self.m_uriRefFac.makeAbsolute(xBaseUri, xFileUri, True, RETAIN)
            sAbsScriptUri = xAbsScriptUri.getUriReference()

            # ensure py file is under the base path
            if not sAbsScriptUri.startswith(sBaseUri):
                message = "pythonscript: storage uri '" + sAbsScriptUri + "' not in base uri '" + self.m_baseUri + "'"
                log.debug( message )
                raise RuntimeException( message, self.ctx )

            ret = sAbsScriptUri
            if funcNameStart != -1:
                ret = ret + "$" + sFuncName
            log.debug( "converting scriptURI="+scriptURI + " to storageURI=" + ret )
            return ret
        except UnoException as e:
            log.error( "error during converting scriptURI="+scriptURI + ": " + e.Message)
            raise RuntimeException( "pythonscript:scriptURI2StorageUri: " + e.Message, self.ctx )
        except Exception as e:
            log.error( "error during converting scriptURI="+scriptURI + ": " + str(e))
            raise RuntimeException( "pythonscript:scriptURI2StorageUri: " + str(e), self.ctx )


class ModuleEntry:
    def __init__( self, lastRead, module ):
        self.lastRead = lastRead
        self.module = module

def hasChanged( oldDate, newDate ):
    return newDate.Year > oldDate.Year or \
           newDate.Month > oldDate.Month or \
           newDate.Day > oldDate.Day or \
           newDate.Hours > oldDate.Hours or \
           newDate.Minutes > oldDate.Minutes or \
           newDate.Seconds > oldDate.Seconds or \
           newDate.NanoSeconds > oldDate.NanoSeconds

def ensureSourceState( code ):
    if code.endswith(b"\n"):
        code = code + b"\n"
    code = code.replace(b"\r", b"")
    return code


def checkForPythonPathBesideScript( url ):
    if url.startswith( "file:" ):
        path = unohelper.fileUrlToSystemPath( url+"/pythonpath.zip" );
        log.log( LogLevel.DEBUG,  "checking for existence of " + path )
        if 1 == os.access( encfile(path), os.F_OK) and not path in sys.path:
            log.log( LogLevel.DEBUG, "adding " + path + " to sys.path" )
            sys.path.append( path )

        path = unohelper.fileUrlToSystemPath( url+"/pythonpath" );
        log.log( LogLevel.DEBUG,  "checking for existence of " + path )
        if 1 == os.access( encfile(path), os.F_OK) and not path in sys.path:
            log.log( LogLevel.DEBUG, "adding " + path + " to sys.path" )
            sys.path.append( path )


class ScriptContext(unohelper.Base):
    def __init__( self, ctx, doc, inv ):
        self.ctx = ctx
        self.doc = doc
        self.inv = inv

   # XScriptContext
    def getDocument(self):
        if self.doc:
            return self.doc
        return self.getDesktop().getCurrentComponent()

    def getDesktop(self):
        return self.ctx.ServiceManager.createInstanceWithContext(
            "com.sun.star.frame.Desktop", self.ctx )

    def getComponentContext(self):
        return self.ctx

    def getInvocationContext(self):
        return self.inv

#----------------------------------
# Global Module Administration
# does not fit together with script
# engine lifetime management
#----------------------------------
#g_scriptContext = ScriptContext( uno.getComponentContext(), None )
#g_modules = {}
#def getModuleByUrl( url, sfa ):
#    entry =  g_modules.get(url)
#    load = True
#    lastRead = sfa.getDateTimeModified( url )
#    if entry:
#        if hasChanged( entry.lastRead, lastRead ):
#            log.debug("file " + url + " has changed, reloading")
#        else:
#            load = False
#
#    if load:
#        log.debug( "opening >" + url + "<" )
#
#        code = readTextFromStream( sfa.openFileRead( url ) )

        # execute the module
#        entry = ModuleEntry( lastRead, types.ModuleType("ooo_script_framework") )
#        entry.module.__dict__[GLOBAL_SCRIPTCONTEXT_NAME] = g_scriptContext
#        entry.module.__file__ = url
#        exec code in entry.module.__dict__
#        g_modules[ url ] = entry
#        log.debug( "mapped " + url + " to " + str( entry.module ) )
#    return entry.module

class ProviderContext:
    def __init__( self, storageType, sfa, uriHelper, scriptContext ):
        self.storageType = storageType
        self.sfa = sfa
        self.uriHelper = uriHelper
        self.scriptContext = scriptContext
        self.modules = {}
        self.rootUrl = None
        self.mapPackageName2Path = None

    def getTransientPartFromUrl( self, url ):
        rest = url.replace( self.rootUrl , "",1 ).replace( "/","",1)
        return rest[0:rest.find("/")]

    def getPackageNameFromUrl( self, url ):
        rest = url.replace( self.rootUrl , "",1 ).replace( "/","",1)
        start = rest.find("/") +1
        return rest[start:rest.find("/",start)]


    def removePackageByUrl( self, url ):
        items = self.mapPackageName2Path.items()
        for i in items:
            if url in i[1].paths:
                self.mapPackageName2Path.pop(i[0])
                break

    def addPackageByUrl( self, url ):
        packageName = self.getPackageNameFromUrl( url )
        transientPart = self.getTransientPartFromUrl( url )
        log.debug( "addPackageByUrl : " + packageName + ", " + transientPart + "("+url+")" + ", rootUrl="+self.rootUrl )
        if packageName in self.mapPackageName2Path:
            package = self.mapPackageName2Path[ packageName ]
            package.paths = package.paths + (url, )
        else:
            package = Package( (url,), transientPart)
            self.mapPackageName2Path[ packageName ] = package

    def isUrlInPackage( self, url ):
        values = self.mapPackageName2Path.values()
        for i in values:
#           print ("checking " + url + " in " + str(i.paths))
            if url in i.paths:
               return True
#        print ("false")
        return False

    def setPackageAttributes( self, mapPackageName2Path, rootUrl ):
        self.mapPackageName2Path = mapPackageName2Path
        self.rootUrl = rootUrl

    def getPersistentUrlFromStorageUrl( self, url ):
        # package name is the second directory
        ret = url
        if self.rootUrl:
            pos = len( self.rootUrl) +1
            ret = url[0:pos]+url[url.find("/",pos)+1:len(url)]
        log.debug( "getPersistentUrlFromStorageUrl " + url +  " -> "+ ret)
        return ret

    def getStorageUrlFromPersistentUrl( self, url):
        ret = url
        if self.rootUrl:
            pos = len(self.rootUrl)+1
            packageName = url[pos:url.find("/",pos+1)]
            package = self.mapPackageName2Path[ packageName ]
            ret = url[0:pos]+ package.transientPathElement + "/" + url[pos:len(url)]
        log.debug( "getStorageUrlFromPersistentUrl " + url + " -> "+ ret)
        return ret

    def getFuncsByUrl( self, url ):
        src = readTextFromStream( self.sfa.openFileRead( url ) )
        checkForPythonPathBesideScript( url[0:url.rfind('/')] )
        src = ensureSourceState( src )

        try:
            code = ast.parse( src )
        except:
            log.isDebugLevel() and log.debug( "pythonscript: getFuncsByUrl: exception while parsing: " + lastException2String())
            raise

        allFuncs = []

        if code is None:
            return allFuncs

        g_exportedScripts = []
        for node in ast.iter_child_nodes(code):
            if isinstance(node, ast.FunctionDef):
                allFuncs.append(node.name)
            elif isinstance(node, ast.Assign):
                for target in node.targets:
                    try:
                        identifier = target.id
                    except AttributeError:
                        identifier = ""
                        pass
                    if identifier == "g_exportedScripts":
                        for value in node.value.elts:
                            g_exportedScripts.append(value.id)
                        return g_exportedScripts

# Python 2 only
#        for node in code.node.nodes:
#            if node.__class__.__name__ == 'Function':
#                allFuncs.append(node.name)
#            elif node.__class__.__name__ == 'Assign':
#                for assignee in node.nodes:
#                    if assignee.name == 'g_exportedScripts':
#                        for item in node.expr.nodes:
#                            if item.__class__.__name__ == 'Name':
#                                g_exportedScripts.append(item.name)
#                        return g_exportedScripts

        return allFuncs

    def getModuleByUrl( self, url ):
        entry =  self.modules.get(url)
        load = True
        lastRead = self.sfa.getDateTimeModified( url )
        if entry:
            if hasChanged( entry.lastRead, lastRead ):
                log.debug( "file " + url + " has changed, reloading" )
            else:
                load = False

        if load:
            log.debug( "opening >" + url + "<" )

            src = readTextFromStream( self.sfa.openFileRead( url ) )
            checkForPythonPathBesideScript( url[0:url.rfind('/')] )
            src = ensureSourceState( src )

            # execute the module
            entry = ModuleEntry( lastRead, types.ModuleType("ooo_script_framework") )
            entry.module.__dict__[GLOBAL_SCRIPTCONTEXT_NAME] = self.scriptContext

            code = None
            if url.startswith( "file:" ):
                code = compile( src, encfile(uno.fileUrlToSystemPath( url ) ), "exec" )
            else:
                code = compile( src, url, "exec" )
            exec(code, entry.module.__dict__)
            entry.module.__file__ = url
            self.modules[ url ] = entry
            log.debug( "mapped " + url + " to " + str( entry.module ) )
        return  entry.module

#--------------------------------------------------
def isScript( candidate ):
    ret = False
    if isinstance( candidate, type(isScript) ):
        ret = True
    return ret

#-------------------------------------------------------
class ScriptBrowseNode( unohelper.Base, XBrowseNode , XPropertySet, XInvocation, XActionListener ):
    def __init__( self, provCtx, uri, fileName, funcName ):
        self.fileName = fileName
        self.funcName = funcName
        self.provCtx = provCtx
        self.uri = uri

    def getName( self ):
        return self.funcName

    def getChildNodes(self):
        return ()

    def hasChildNodes(self):
        return False

    def getType( self):
        return SCRIPT

    def getPropertyValue( self, name ):
        ret = None
        try:
            if name == "URI":
                ret = self.provCtx.uriHelper.getScriptURI(
                    self.provCtx.getPersistentUrlFromStorageUrl( self.uri + "$" + self.funcName ) )
            elif name == "Editable" and ENABLE_EDIT_DIALOG:
                ret = not self.provCtx.sfa.isReadOnly( self.uri )

            log.debug( "ScriptBrowseNode.getPropertyValue called for " + name + ", returning " + str(ret) )
        except:
            log.error( "ScriptBrowseNode.getPropertyValue error " + lastException2String())
            raise

        return ret
    def setPropertyValue( self, name, value ):
        log.debug( "ScriptBrowseNode.setPropertyValue called " + name + "=" +str(value ) )
    def getPropertySetInfo( self ):
        log.debug( "ScriptBrowseNode.getPropertySetInfo called "  )
        return None

    def getIntrospection( self ):
        return None

    def invoke( self, name, params, outparamindex, outparams ):
        if name == "Editable":
            servicename = "com.sun.star.awt.DialogProvider"
            ctx = self.provCtx.scriptContext.getComponentContext()
            dlgprov = ctx.ServiceManager.createInstanceWithContext(
                servicename, ctx )

            self.editor = dlgprov.createDialog(
                "vnd.sun.star.script:" +
                "ScriptBindingLibrary.MacroEditor?location=application")

            code = readTextFromStream(self.provCtx.sfa.openFileRead(self.uri))
            code = ensureSourceState( code )
            self.editor.getControl("EditorTextField").setText(code)

            self.editor.getControl("RunButton").setActionCommand("Run")
            self.editor.getControl("RunButton").addActionListener(self)
            self.editor.getControl("SaveButton").setActionCommand("Save")
            self.editor.getControl("SaveButton").addActionListener(self)

            self.editor.execute()

        return None

    def actionPerformed( self, event ):
        try:
            if event.ActionCommand == "Run":
                code = self.editor.getControl("EditorTextField").getText()
                code = ensureSourceState( code )
                mod = types.ModuleType("ooo_script_framework")
                mod.__dict__[GLOBAL_SCRIPTCONTEXT_NAME] = self.provCtx.scriptContext
                exec(code, mod.__dict__)
                values = mod.__dict__.get( CALLABLE_CONTAINER_NAME , None )
                if not values:
                    values = mod.__dict__.values()

                for i in values:
                    if isScript( i ):
                        i()
                        break

            elif event.ActionCommand == "Save":
                toWrite = uno.ByteSequence(
                    self.editor.getControl("EditorTextField").getText().encode(
                    sys.getdefaultencoding()) )
                copyUrl = self.uri + ".orig"
                self.provCtx.sfa.move( self.uri, copyUrl )
                out = self.provCtx.sfa.openFileWrite( self.uri )
                out.writeBytes( toWrite )
                out.close()
                self.provCtx.sfa.kill( copyUrl )
#                log.debug("Save is not implemented yet")
#                text = self.editor.getControl("EditorTextField").getText()
#                log.debug("Would save: " + text)
        except:
            # TODO: add an error box here!
            log.error( lastException2String() )


    def setValue( self, name, value ):
        return None

    def getValue( self, name ):
        return None

    def hasMethod( self, name ):
        return False

    def hasProperty( self, name ):
        return False


#-------------------------------------------------------
class FileBrowseNode( unohelper.Base, XBrowseNode ):
    def __init__( self, provCtx, uri , name ):
        self.provCtx = provCtx
        self.uri = uri
        self.name = name
        self.funcnames = None

    def getName( self ):
        return self.name

    def getChildNodes(self):
        ret = ()
        try:
            self.funcnames = self.provCtx.getFuncsByUrl( self.uri )

            scriptNodeList = []
            for i in self.funcnames:
                scriptNodeList.append(
                    ScriptBrowseNode(
                    self.provCtx, self.uri, self.name, i ))
            ret = tuple( scriptNodeList )
            log.debug( "returning " +str(len(ret)) + " ScriptChildNodes on " + self.uri )
        except:
            text = lastException2String()
            log.error( "Error while evaluating " + self.uri + ":" + text )
            raise
        return ret

    def hasChildNodes(self):
        try:
            return len(self.getChildNodes()) > 0
        except:
            return False

    def getType( self):
        return CONTAINER



class DirBrowseNode( unohelper.Base, XBrowseNode ):
    def __init__( self, provCtx, name, rootUrl ):
        self.provCtx = provCtx
        self.name = name
        self.rootUrl = rootUrl

    def getName( self ):
        return self.name

    def getChildNodes( self ):
        try:
            log.debug( "DirBrowseNode.getChildNodes called for " + self.rootUrl )
            contents = self.provCtx.sfa.getFolderContents( self.rootUrl, True )
            browseNodeList = []
            for i in contents:
                if i.endswith( ".py" ):
                    log.debug( "adding filenode " + i )
                    browseNodeList.append(
                        FileBrowseNode( self.provCtx, i, i[i.rfind("/")+1:len(i)-3] ) )
                elif self.provCtx.sfa.isFolder( i ) and not i.endswith("/pythonpath"):
                    log.debug( "adding DirBrowseNode " + i )
                    browseNodeList.append( DirBrowseNode( self.provCtx, i[i.rfind("/")+1:len(i)],i))
            return tuple( browseNodeList )
        except Exception as e:
            text = lastException2String()
            log.error( "DirBrowseNode error: " + str(e) + " while evaluating " + self.rootUrl)
            log.error( text)
            return ()

    def hasChildNodes( self ):
        return True

    def getType( self ):
        return CONTAINER

    def getScript( self, uri ):
        log.debug( "DirBrowseNode getScript " + uri + " invoked" )
        raise IllegalArgumentException( "DirBrowseNode couldn't instantiate script " + uri , self , 0 )


class ManifestHandler( XDocumentHandler, unohelper.Base ):
    def __init__( self, rootUrl ):
        self.rootUrl = rootUrl

    def startDocument( self ):
        self.urlList = []

    def endDocument( self ):
        pass

    def startElement( self , name, attlist):
        if name == "manifest:file-entry":
            if attlist.getValueByName( "manifest:media-type" ) == "application/vnd.sun.star.framework-script":
                self.urlList.append(
                    self.rootUrl + "/" + attlist.getValueByName( "manifest:full-path" ) )

    def endElement( self, name ):
        pass

    def characters ( self, chars ):
        pass

    def ignoreableWhitespace( self, chars ):
        pass

    def setDocumentLocator( self, locator ):
        pass

def isPyFileInPath( sfa, path ):
    ret = False
    contents = sfa.getFolderContents( path, True )
    for i in contents:
        if sfa.isFolder(i):
            ret = isPyFileInPath(sfa,i)
        else:
            if i.endswith(".py"):
                ret = True
        if ret:
            break
    return ret

# extracts META-INF directory from
def getPathsFromPackage( rootUrl, sfa ):
    ret = ()
    try:
        fileUrl = rootUrl + "/META-INF/manifest.xml"
        inputStream = sfa.openFileRead( fileUrl )
        parser = uno.getComponentContext().ServiceManager.createInstance( "com.sun.star.xml.sax.Parser" )
        handler = ManifestHandler( rootUrl )
        parser.setDocumentHandler( handler )
        parser.parseStream( InputSource( inputStream , "", fileUrl, fileUrl ) )
        for i in tuple(handler.urlList):
            if not isPyFileInPath( sfa, i ):
                handler.urlList.remove(i)
        ret = tuple( handler.urlList )
    except UnoException:
        text = lastException2String()
        log.debug( "getPathsFromPackage " + fileUrl + " Exception: " +text )
        pass
    return ret


class Package:
    def __init__( self, paths, transientPathElement ):
        self.paths = paths
        self.transientPathElement = transientPathElement

class DummyInteractionHandler( unohelper.Base, XInteractionHandler ):
    def __init__( self ):
        pass
    def handle( self, event):
        log.debug( "pythonscript: DummyInteractionHandler.handle " + str( event ) )

class DummyProgressHandler( unohelper.Base, XProgressHandler ):
    def __init__( self ):
        pass

    def push( self,status ):
        log.debug( "pythonscript: DummyProgressHandler.push " + str( status ) )
    def update( self,status ):
        log.debug( "pythonscript: DummyProgressHandler.update " + str( status ) )
    def pop( self, event ):
        log.debug( "pythonscript: DummyProgressHandler.push " + str( event ) )

class CommandEnvironment(unohelper.Base, XCommandEnvironment):
    def __init__( self ):
        self.progressHandler = DummyProgressHandler()
        self.interactionHandler = DummyInteractionHandler()
    def getInteractionHandler( self ):
        return self.interactionHandler
    def getProgressHandler( self ):
        return self.progressHandler

#maybe useful for debugging purposes
#class ModifyListener( unohelper.Base, XModifyListener ):
#    def __init__( self ):
#        pass
#    def modified( self, event ):
#        log.debug( "pythonscript: ModifyListener.modified " + str( event ) )
#    def disposing( self, event ):
#        log.debug( "pythonscript: ModifyListener.disposing " + str( event ) )

def getModelFromDocUrl(ctx, url):
    """Get document model from document url."""
    doc = None
    args = ("Local", "Office")
    ucb = ctx.getServiceManager().createInstanceWithArgumentsAndContext(
        "com.sun.star.ucb.UniversalContentBroker", args, ctx)
    identifier = ucb.createContentIdentifier(url)
    content = ucb.queryContent(identifier)
    p = Property()
    p.Name = "DocumentModel"
    p.Handle = -1

    c = Command()
    c.Handle = -1
    c.Name = "getPropertyValues"
    c.Argument = uno.Any("[]com.sun.star.beans.Property", (p,))

    env = CommandEnvironment()
    try:
        ret = content.execute(c, 0, env)
        doc = ret.getObject(1, None)
    except Exception as e:
        log.isErrorLevel() and log.error("getModelFromDocUrl: %s" % url)
    return doc

def mapStorageType2PackageContext( storageType ):
    ret = storageType
    if( storageType == "share:uno_packages" ):
        ret = "shared"
    if( storageType == "user:uno_packages" ):
        ret = "user"
    return ret

def getPackageName2PathMap( sfa, storageType ):
    ret = {}
    packageManagerFactory = uno.getComponentContext().getValueByName(
        "/singletons/com.sun.star.deployment.thePackageManagerFactory" )
    packageManager = packageManagerFactory.getPackageManager(
        mapStorageType2PackageContext(storageType))
#    packageManager.addModifyListener( ModifyListener() )
    log.debug( "pythonscript: getPackageName2PathMap start getDeployedPackages" )
    packages = packageManager.getDeployedPackages(
        packageManager.createAbortChannel(), CommandEnvironment( ) )
    log.debug( "pythonscript: getPackageName2PathMap end getDeployedPackages (" + str(len(packages))+")" )

    for i in packages:
        log.debug( "inspecting package " + i.Name + "("+i.Identifier.Value+")" )
        transientPathElement = penultimateElement( i.URL )
        j = expandUri( i.URL )
        paths = getPathsFromPackage( j, sfa )
        if len( paths ) > 0:
            # map package name to url, we need this later
            log.isErrorLevel() and log.error( "adding Package " + transientPathElement + " " + str( paths ) )
            ret[ lastElement( j ) ] = Package( paths, transientPathElement )
    return ret

def penultimateElement( aStr ):
    lastSlash = aStr.rindex("/")
    penultimateSlash = aStr.rindex("/",0,lastSlash-1)
    return  aStr[ penultimateSlash+1:lastSlash ]

def lastElement( aStr):
    return aStr[ aStr.rfind( "/" )+1:len(aStr)]

class PackageBrowseNode( unohelper.Base, XBrowseNode ):
    def __init__( self, provCtx, name, rootUrl ):
        self.provCtx = provCtx
        self.name = name
        self.rootUrl = rootUrl

    def getName( self ):
        return self.name

    def getChildNodes( self ):
        items = self.provCtx.mapPackageName2Path.items()
        browseNodeList = []
        for i in items:
            if len( i[1].paths ) == 1:
                browseNodeList.append(
                    DirBrowseNode( self.provCtx, i[0], i[1].paths[0] ))
            else:
                for j in i[1].paths:
                    browseNodeList.append(
                        DirBrowseNode( self.provCtx, i[0]+"."+lastElement(j), j ) )
        return tuple( browseNodeList )

    def hasChildNodes( self ):
        return len( self.provCtx.mapPackageName2Path ) > 0

    def getType( self ):
        return CONTAINER

    def getScript( self, uri ):
        log.debug( "PackageBrowseNode getScript " + uri + " invoked" )
        raise IllegalArgumentException( "PackageBrowseNode couldn't instantiate script " + uri , self , 0 )




class PythonScript( unohelper.Base, XScript ):
    def __init__( self, func, mod, args ):
        self.func = func
        self.mod = mod
        self.args = args

    def invoke(self, args, out, outindex ):
        log.debug( "PythonScript.invoke " + str( args ) )
        try:
            if (self.args):
                args += self.args
            ret = self.func( *args )
        except UnoException as e:
            # UNO Exception continue to fly ...
            text = lastException2String()
            complete = "Error during invoking function " + \
                str(self.func.__name__) + " in module " + \
                self.mod.__file__ + " (" + text + ")"
            log.debug( complete )
            # some people may beat me up for modifying the exception text,
            # but otherwise office just shows
            # the type name and message text with no more information,
            # this is really bad for most users.
            e.Message = e.Message + " (" + complete + ")"
            raise
        except Exception as e:
            # General python exception are converted to uno RuntimeException
            text = lastException2String()
            complete = "Error during invoking function " + \
                str(self.func.__name__) + " in module " + \
                self.mod.__file__ + " (" + text + ")"
            log.debug( complete )
            raise RuntimeException( complete , self )
        log.debug( "PythonScript.invoke ret = " + str( ret ) )
        return ret, (), ()

def expandUri(  uri ):
    if uri.startswith( "vnd.sun.star.expand:" ):
        uri = uri.replace( "vnd.sun.star.expand:", "",1)
        uri = uno.getComponentContext().getByName(
                    "/singletons/com.sun.star.util.theMacroExpander" ).expandMacros( uri )
    if uri.startswith( "file:" ):
        uri = uno.absolutize("",uri)   # necessary to get rid of .. in uri
    return uri

#--------------------------------------------------------------
class PythonScriptProvider( unohelper.Base, XBrowseNode, XScriptProvider, XNameContainer):
    def __init__( self, ctx, *args ):
        if log.isDebugLevel():
            mystr = ""
            for i in args:
                if len(mystr) > 0:
                    mystr = mystr +","
                mystr = mystr + str(i)
            log.debug( "Entering PythonScriptProvider.ctor" + mystr )

        doc = None
        inv = None
        storageType = ""

        if isinstance(args[0], str):
            storageType = args[0]
            if storageType.startswith( "vnd.sun.star.tdoc" ):
                doc = getModelFromDocUrl(ctx, storageType)
        else:
            inv = args[0]
            try:
                doc = inv.ScriptContainer
                content = ctx.getServiceManager().createInstanceWithContext(
                    "com.sun.star.frame.TransientDocumentsDocumentContentFactory",
                    ctx).createDocumentContent(doc)
                storageType = content.getIdentifier().getContentIdentifier()
            except Exception as e:
                text = lastException2String()
                log.error( text )

        isPackage = storageType.endswith( ":uno_packages" )

        try:
#            urlHelper = ctx.ServiceManager.createInstanceWithArgumentsAndContext(
#                "com.sun.star.script.provider.ScriptURIHelper", (LANGUAGENAME, storageType), ctx)
            urlHelper = MyUriHelper( ctx, storageType )
            log.debug( "got urlHelper " + str( urlHelper ) )

            rootUrl = expandUri( urlHelper.getRootStorageURI() )
            log.debug( storageType + " transformed to " + rootUrl )

            ucbService = "com.sun.star.ucb.SimpleFileAccess"
            sfa = ctx.ServiceManager.createInstanceWithContext( ucbService, ctx )
            if not sfa:
                log.debug("PythonScriptProvider couldn't instantiate " +ucbService)
                raise RuntimeException(
                    "PythonScriptProvider couldn't instantiate " +ucbService, self)
            self.provCtx = ProviderContext(
                storageType, sfa, urlHelper, ScriptContext( uno.getComponentContext(), doc, inv ) )
            if isPackage:
                mapPackageName2Path = getPackageName2PathMap( sfa, storageType )
                self.provCtx.setPackageAttributes( mapPackageName2Path , rootUrl )
                self.dirBrowseNode = PackageBrowseNode( self.provCtx, LANGUAGENAME, rootUrl )
            else:
                self.dirBrowseNode = DirBrowseNode( self.provCtx, LANGUAGENAME, rootUrl )

        except Exception as e:
            text = lastException2String()
            log.debug( "PythonScriptProvider could not be instantiated because of : " + text )
            raise e

    def getName( self ):
        return self.dirBrowseNode.getName()

    def getChildNodes( self ):
        return self.dirBrowseNode.getChildNodes()

    def hasChildNodes( self ):
        return self.dirBrowseNode.hasChildNodes()

    def getType( self ):
        return self.dirBrowseNode.getType()

    # retrieve function args in parenthesis
    def getFunctionArguments(self, func_signature):
        nOpenParenthesis = func_signature.find( "(" )
        if -1 == nOpenParenthesis:
            function_name = func_signature
            arguments = None
        else:
            function_name = func_signature[0:nOpenParenthesis]
            arg_part = func_signature[nOpenParenthesis+1:len(func_signature)]
            nCloseParenthesis = arg_part.find( ")" )
            if -1 == nCloseParenthesis:
                raise IllegalArgumentException( "PythonLoader: mismatch parenthesis " + func_signature, self, 0 )
            arguments = arg_part[0:nCloseParenthesis].strip()
            if arguments == "":
                arguments = None
            else:
                arguments = tuple([x.strip().strip('"') for x in arguments.split(",")])
        return function_name, arguments

    def getScript( self, scriptUri ):
        try:
            log.debug( "getScript " + scriptUri + " invoked")

            storageUri = self.provCtx.getStorageUrlFromPersistentUrl(
                self.provCtx.uriHelper.getStorageURI(scriptUri) );
            log.debug( "getScript: storageUri = " + storageUri)
            fileUri = storageUri[0:storageUri.find( "$" )]
            funcName = storageUri[storageUri.find( "$" )+1:len(storageUri)]

            # retrieve arguments in parenthesis
            funcName, funcArgs = self.getFunctionArguments(funcName)
            log.debug( " getScript : parsed funcname " + str(funcName) )
            log.debug( " getScript : func args " + str(funcArgs) )

            mod = self.provCtx.getModuleByUrl( fileUri )
            log.debug( " got mod " + str(mod) )

            func = mod.__dict__[ funcName ]

            log.debug( "got func " + str( func ) )
            return PythonScript( func, mod, funcArgs )
        except:
            text = lastException2String()
            log.error( text )
            raise ScriptFrameworkErrorException( text, self, scriptUri, LANGUAGENAME, 0 )


    # XServiceInfo
    def getSupportedServices( self ):
        return g_ImplementationHelper.getSupportedServices(g_implName)

    def supportsService( self, ServiceName ):
        return g_ImplementationHelper.supportsService( g_implName, ServiceName )

    def getImplementationName(self):
        return g_implName

    def getByName( self, name ):
        log.debug( "getByName called" + str( name ))
        return None


    def getElementNames( self ):
        log.debug( "getElementNames called")
        return ()

    def hasByName( self, name ):
        try:
            log.debug( "hasByName called " + str( name ))
            uri = expandUri(name)
            ret = self.provCtx.isUrlInPackage( uri )
            log.debug( "hasByName " + uri + " " +str( ret ) )
            return ret
        except:
            text = lastException2String()
            log.debug( "Error in hasByName:" +  text )
            return False

    def removeByName( self, name ):
        log.debug( "removeByName called" + str( name ))
        uri = expandUri( name )
        if self.provCtx.isUrlInPackage( uri ):
            self.provCtx.removePackageByUrl( uri )
        else:
            log.debug( "removeByName unknown uri " + str( name ) + ", ignoring" )
            raise NoSuchElementException( uri + "is not in package" , self )
        log.debug( "removeByName called" + str( uri ) + " successful" )

    def insertByName( self, name, value ):
        log.debug( "insertByName called " + str( name ) + " " + str( value ))
        uri = expandUri( name )
        if isPyFileInPath( self.provCtx.sfa, uri ):
            self.provCtx.addPackageByUrl( uri )
        else:
            # package is no python package ...
            log.debug( "insertByName: no python files in " + str( uri ) + ", ignoring" )
            raise IllegalArgumentException( uri + " does not contain .py files", self, 1 )
        log.debug( "insertByName called " + str( uri ) + " successful" )

    def replaceByName( self, name, value ):
        log.debug( "replaceByName called " + str( name ) + " " + str( value ))
        uri = expandUri( name )
        self.removeByName( name )
        self.insertByName( name, value )
        log.debug( "replaceByName called" + str( uri ) + " successful" )

    def getElementType( self ):
        log.debug( "getElementType called" )
        return uno.getTypeByName( "void" )

    def hasElements( self ):
        log.debug( "hasElements got called")
        return False

g_ImplementationHelper.addImplementation( \
    PythonScriptProvider,g_implName, \
    ("com.sun.star.script.provider.LanguageScriptProvider",
     "com.sun.star.script.provider.ScriptProviderFor"+ LANGUAGENAME,),)


log.debug( "pythonscript finished initializing" )

# vim: set shiftwidth=4 softtabstop=4 expandtab:
