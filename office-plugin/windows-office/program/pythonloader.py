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
import uno
import unohelper
import sys
import types
import os
from com.sun.star.uno import Exception,RuntimeException
from com.sun.star.loader import XImplementationLoader
from com.sun.star.lang import XServiceInfo

MODULE_PROTOCOL = "vnd.openoffice.pymodule:"
DEBUG = 0

g_supportedServices  = "com.sun.star.loader.Python",      # referenced by the native C++ loader !
g_implementationName = "org.openoffice.comp.pyuno.Loader" # referenced by the native C++ loader !

def splitUrl( url ):
    nColon = url.find( ":" )
    if -1 == nColon:
        raise RuntimeException( "PythonLoader: No protocol in url " + url, None )
    return url[0:nColon], url[nColon+1:len(url)]

g_loadedComponents = {}
def checkForPythonPathBesideComponent( url ):
    path = unohelper.fileUrlToSystemPath( url+"/pythonpath.zip" );
    if DEBUG == 1:
        print(b"checking for existence of " + encfile( path ))
    if 1 == os.access( encfile( path ), os.F_OK) and not path in sys.path:
        if DEBUG == 1:
            print(b"adding " + encfile( path ) + b" to sys.path")
        sys.path.append( path )

    path = unohelper.fileUrlToSystemPath( url+"/pythonpath" );
    if 1 == os.access( encfile( path ), os.F_OK) and not path in sys.path:
        if DEBUG == 1:
            print(b"adding " + encfile( path ) + b" to sys.path")
        sys.path.append( path )

def encfile(uni):
    return uni.encode( sys.getfilesystemencoding())

class Loader( XImplementationLoader, XServiceInfo, unohelper.Base ):
    def __init__(self, ctx ):
        if DEBUG:
            print("pythonloader.Loader ctor")
        self.ctx = ctx

    def getModuleFromUrl( self, url ):
        if DEBUG:
            print("pythonloader: interpreting url " + url)
        protocol, dependent = splitUrl( url )
        if "vnd.sun.star.expand" == protocol:
            exp = self.ctx.getValueByName( "/singletons/com.sun.star.util.theMacroExpander" )
            url = exp.expandMacros(dependent)
            protocol,dependent = splitUrl( url )

        if DEBUG:
            print("pythonloader: after expansion " + protocol + ":" + dependent)

        try:
            if "file" == protocol:
                # remove \..\ sequence, which may be useful e.g. in the build env
                url = unohelper.absolutize( url, url )

                # did we load the module already ?
                mod = g_loadedComponents.get( url )
                if not mod:
                    mod = types.ModuleType("uno_component")

                    # check for pythonpath.zip beside .py files
                    checkForPythonPathBesideComponent( url[0:url.rfind('/')] )

                    # read the file
                    filename = unohelper.fileUrlToSystemPath( url )

                    fileHandle = open( filename, encoding='utf_8' )
                    src = fileHandle.read().replace("\r","")
                    if not src.endswith( "\n" ):
                        src = src + "\n"

                    # compile and execute the module
                    codeobject = compile( src, encfile(filename), "exec" )
                    mod.__file__ = filename
                    exec(codeobject, mod.__dict__)
                    g_loadedComponents[url] = mod
                return mod
            elif "vnd.openoffice.pymodule" == protocol:
                nSlash = dependent.rfind('/')
                if -1 != nSlash:
                    path = unohelper.fileUrlToSystemPath( dependent[0:nSlash] )
                    dependent = dependent[nSlash+1:len(dependent)]
                    if not path in sys.path:
                        sys.path.append( path )
                mod =  __import__( dependent )
                path_component, dot, rest = dependent.partition('.')
                while dot == '.':
                    path_component, dot, rest = rest.partition('.')
                    mod = getattr(mod, path_component)
                return mod
            else:
                if DEBUG:
                    print("Unknown protocol '" + protocol + "'");
                raise RuntimeException( "PythonLoader: Unknown protocol " +
                                         protocol + " in url " +url, self )
        except Exception as e:
            if DEBUG:
                print ("Python import exception " + str(type(e)) +
                       " message " + str(e) + " args " + str(e.args));
            raise RuntimeException( "Couldn't load " + url + " for reason " + str(e), None )
        return None

    def activate( self, implementationName, dummy, locationUrl, regKey ):
        if DEBUG:
            print("pythonloader.Loader.activate")

        mod = self.getModuleFromUrl( locationUrl )
        implHelper = mod.__dict__.get( "g_ImplementationHelper" , None )
        if DEBUG:
            print ("Fetched ImplHelper as " + str(implHelper))
        if implHelper is None:
            return mod.getComponentFactory( implementationName, self.ctx.ServiceManager, regKey )
        else:
            return implHelper.getComponentFactory( implementationName,regKey,self.ctx.ServiceManager)

    def writeRegistryInfo( self, regKey, dummy, locationUrl ):
        if DEBUG:
            print( "pythonloader.Loader.writeRegistryInfo" )

        mod = self.getModuleFromUrl( locationUrl )
        implHelper = mod.__dict__.get( "g_ImplementationHelper" , None )
        if implHelper is None:
            return mod.writeRegistryInfo( self.ctx.ServiceManager, regKey )
        else:
            return implHelper.writeRegistryInfo( regKey, self.ctx.ServiceManager )

    def getImplementationName( self ):
        return g_implementationName

    def supportsService( self, ServiceName ):
        return ServiceName in self.getSupportedServiceNames()

    def getSupportedServiceNames( self ):
        return g_supportedServices

# vim: set shiftwidth=4 softtabstop=4 expandtab:
