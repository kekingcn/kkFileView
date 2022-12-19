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
import pyuno
import os
import sys

from com.sun.star.lang import XTypeProvider, XSingleComponentFactory, XServiceInfo
from com.sun.star.uno import RuntimeException, XCurrentContext
from com.sun.star.beans.MethodConcept import ALL as METHOD_CONCEPT_ALL
from com.sun.star.beans.PropertyConcept import ALL as PROPERTY_CONCEPT_ALL

from com.sun.star.reflection.ParamMode import \
     IN as PARAM_MODE_IN, \
     OUT as PARAM_MODE_OUT, \
     INOUT as PARAM_MODE_INOUT

from com.sun.star.beans.PropertyAttribute import \
     MAYBEVOID as PROP_ATTR_MAYBEVOID, \
     BOUND as PROP_ATTR_BOUND, \
     CONSTRAINED as PROP_ATTR_CONSTRAINED, \
     TRANSIENT as PROP_ATTR_TRANSIENT, \
     READONLY as PROP_ATTR_READONLY, \
     MAYBEAMBIGUOUS as PROP_ATTR_MAYBEAMBIGUOUS, \
     MAYBEDEFAULT as PROP_ATTR_MAYBEDEFAULT, \
     REMOVABLE as PROP_ATTR_REMOVABLE

def _mode_to_str( mode ):
    ret = "[]"
    if mode == PARAM_MODE_INOUT:
        ret = "[inout]"
    elif mode == PARAM_MODE_OUT:
        ret = "[out]"
    elif mode == PARAM_MODE_IN:
        ret = "[in]"
    return ret

def _propertymode_to_str( mode ):
    ret = ""
    if PROP_ATTR_REMOVABLE & mode:
        ret = ret + "removable "
    if PROP_ATTR_MAYBEDEFAULT & mode:
        ret = ret + "maybedefault "
    if PROP_ATTR_MAYBEAMBIGUOUS & mode:
        ret = ret + "maybeambiguous "
    if PROP_ATTR_READONLY & mode:
        ret = ret + "readonly "
    if PROP_ATTR_TRANSIENT & mode:
        ret = ret + "transient "
    if PROP_ATTR_CONSTRAINED & mode:
        ret = ret + "constrained "
    if PROP_ATTR_BOUND & mode:
        ret = ret + "bound "
    if PROP_ATTR_MAYBEVOID & mode:
        ret = ret + "maybevoid "
    return ret.rstrip()

def inspect( obj , out ):
    if isinstance( obj, uno.Type ) or \
       isinstance( obj, uno.Char ) or \
       isinstance( obj, uno.Bool ) or \
       isinstance( obj, uno.ByteSequence ) or \
       isinstance( obj, uno.Enum ) or \
       isinstance( obj, uno.Any ):
        out.write( str(obj) + "\n")
        return

    ctx = uno.getComponentContext()
    introspection = \
         ctx.ServiceManager.createInstanceWithContext( "com.sun.star.beans.Introspection", ctx )

    out.write( "Supported services:\n" )
    if hasattr( obj, "getSupportedServiceNames" ):
        names = obj.getSupportedServiceNames()
        for ii in names:
            out.write( "  " + ii + "\n" )
    else:
        out.write( "  unknown\n" )

    out.write( "Interfaces:\n" )
    if hasattr( obj, "getTypes" ):
        interfaces = obj.getTypes()
        for ii in interfaces:
            out.write( "  " + ii.typeName + "\n" )
    else:
        out.write( "  unknown\n" )

    access = introspection.inspect( obj )
    methods = access.getMethods( METHOD_CONCEPT_ALL )
    out.write( "Methods:\n" )
    for ii in methods:
        out.write( "  " + ii.ReturnType.Name + " " + ii.Name )
        args = ii.ParameterTypes
        infos = ii.ParameterInfos
        out.write( "( " )
        for i in range( 0, len( args ) ):
            if i > 0:
                out.write( ", " )
            out.write( _mode_to_str( infos[i].aMode ) + " " + args[i].Name + " " + infos[i].aName )
        out.write( " )\n" )

    props = access.getProperties( PROPERTY_CONCEPT_ALL )
    out.write ("Properties:\n" )
    for ii in props:
        out.write( "  ("+_propertymode_to_str( ii.Attributes ) + ") "+ii.Type.typeName+" "+ii.Name+ "\n" )

def createSingleServiceFactory( clazz, implementationName, serviceNames ):
    return _FactoryHelper_( clazz, implementationName, serviceNames )

class _ImplementationHelperEntry:
    def __init__(self, ctor,serviceNames):
        self.ctor = ctor
        self.serviceNames = serviceNames

class ImplementationHelper:
    def __init__(self):
        self.impls = {}

    def addImplementation( self, ctor, implementationName, serviceNames ):
        self.impls[implementationName] =  _ImplementationHelperEntry(ctor,serviceNames)

    def writeRegistryInfo( self, regKey, smgr ):
        for i in list(self.impls.items()):
            keyName = "/"+ i[0] + "/UNO/SERVICES"
            key = regKey.createKey( keyName )
            for serviceName in i[1].serviceNames:
                key.createKey( serviceName )
        return 1

    def getComponentFactory( self, implementationName , regKey, smgr ):
        entry = self.impls.get( implementationName, None )
        if entry is None:
            raise RuntimeException( implementationName + " is unknown" , None )
        return createSingleServiceFactory( entry.ctor, implementationName, entry.serviceNames )

    def getSupportedServiceNames( self, implementationName ):
        entry = self.impls.get( implementationName, None )
        if entry is None:
            raise RuntimeException( implementationName + " is unknown" , None )
        return entry.serviceNames

    def supportsService( self, implementationName, serviceName ):
        entry = self.impls.get( implementationName,None )
        if entry is None:
            raise RuntimeException( implementationName + " is unknown", None )
        return serviceName in entry.serviceNames


class ImplementationEntry:
    def __init__(self, implName, supportedServices, clazz ):
        self.implName = implName
        self.supportedServices = supportedServices
        self.clazz = clazz

def writeRegistryInfoHelper( smgr, regKey, seqEntries ):
    for entry in seqEntries:
        keyName = "/"+ entry.implName + "/UNO/SERVICES"
        key = regKey.createKey( keyName )
        for serviceName in entry.supportedServices:
            key.createKey( serviceName )

def systemPathToFileUrl( systemPath ):
    "returns a file-url for the given system path"
    return pyuno.systemPathToFileUrl( systemPath )

def fileUrlToSystemPath( url ):
    "returns a system path (determined by the system, the python interpreter is running on)"
    return pyuno.fileUrlToSystemPath( url )

def absolutize( path, relativeUrl ):
    "returns an absolute file url from the given urls"
    return pyuno.absolutize( path, relativeUrl )

def getComponentFactoryHelper( implementationName, smgr, regKey, seqEntries ):
    for x in seqEntries:
        if x.implName == implementationName:
            return createSingleServiceFactory( x.clazz, implementationName, x.supportedServices )

def addComponentsToContext( toBeExtendedContext, contextRuntime, componentUrls, loaderName ):
    smgr = contextRuntime.ServiceManager
    loader = smgr.createInstanceWithContext( loaderName, contextRuntime )
    implReg = smgr.createInstanceWithContext( "com.sun.star.registry.ImplementationRegistration",contextRuntime)

    isWin = os.name == 'nt' or os.name == 'dos'
    isMac = sys.platform == 'darwin'
    #   create a temporary registry
    for componentUrl in componentUrls:
        reg = smgr.createInstanceWithContext( "com.sun.star.registry.SimpleRegistry", contextRuntime )
        reg.open( "", 0, 1 )
        if not isWin and componentUrl.endswith( ".uno" ):  # still allow platform independent naming
            if isMac:
                componentUrl = componentUrl + ".dylib"
            else:
                componentUrl = componentUrl + ".so"

        implReg.registerImplementation( loaderName,componentUrl, reg )
        rootKey = reg.getRootKey()
        implementationKey = rootKey.openKey( "IMPLEMENTATIONS" )
        implNames = implementationKey.getKeyNames()
        extSMGR = toBeExtendedContext.ServiceManager
        for x in implNames:
            fac = loader.activate( max(x.split("/")),"",componentUrl,rootKey)
            extSMGR.insert( fac )
        reg.close()

# never shrinks !
_g_typeTable = {}
def _unohelper_getHandle( self):
    ret = None
    if self.__class__ in _g_typeTable:
        ret = _g_typeTable[self.__class__]
    else:
        names = {}
        traverse = list(self.__class__.__bases__)
        while len( traverse ) > 0:
            item = traverse.pop()
            bases = item.__bases__
            if uno.isInterface( item ):
                names[item.__pyunointerface__] = None
            elif len(bases) > 0:
                # the "else if", because we only need the most derived interface
                traverse = traverse + list(bases)#

        lst = list(names.keys())
        types = []
        for x in lst:
            t = uno.getTypeByName( x )
            types.append( t )

        ret = tuple(types)
        _g_typeTable[self.__class__] = ret
    return ret

class Base(XTypeProvider):
    def getTypes( self ):
        return _unohelper_getHandle( self )
    def getImplementationId(self):
        return ()

class CurrentContext(XCurrentContext, Base ):
    """a current context implementation, which first does a lookup in the given
       hashmap and if the key cannot be found, it delegates to the predecessor
       if available
    """
    def __init__( self, oldContext, hashMap ):
        self.hashMap = hashMap
        self.oldContext = oldContext

    def getValueByName( self, name ):
        if name in self.hashMap:
            return self.hashMap[name]
        elif self.oldContext is not None:
            return self.oldContext.getValueByName( name )
        else:
            return None

# -------------------------------------------------
# implementation details
# -------------------------------------------------
class _FactoryHelper_( XSingleComponentFactory, XServiceInfo, Base ):
    def __init__( self, clazz, implementationName, serviceNames ):
        self.clazz = clazz
        self.implementationName = implementationName
        self.serviceNames = serviceNames

    def getImplementationName( self ):
        return self.implementationName

    def supportsService( self, ServiceName ):
        return ServiceName in self.serviceNames

    def getSupportedServiceNames( self ):
        return self.serviceNames

    def createInstanceWithContext( self, context ):
        return self.clazz( context )

    def createInstanceWithArgumentsAndContext( self, args, context ):
        return self.clazz( context, *args )

# vim: set shiftwidth=4 softtabstop=4 expandtab:
