#**************************************************************
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
#**************************************************************

#
# Translated to python from "Bootstrap.java" by Kim Kulak
#

import os
import random
from sys import platform
from time import sleep

import uno
from com.sun.star.connection import NoConnectException
from com.sun.star.uno import Exception as UnoException


class BootstrapException(UnoException):
    pass

def bootstrap():
    """Bootstrap OOo and PyUNO Runtime.
    The soffice process is started opening a named pipe of random name, then the local context is used
        to access the pipe. This function directly returns the remote component context, from whereon you can
        get the ServiceManager by calling getServiceManager() on the returned object.
        """
    try:
        # soffice script used on *ix, Mac; soffice.exe used on Windoof
        if "UNO_PATH" in os.environ:
            sOffice = os.environ["UNO_PATH"]
        else:
            sOffice = "" # lets hope for the best
        sOffice = os.path.join(sOffice, "soffice")
        if platform.startswith("win"):
            sOffice += ".exe"

        # Generate a random pipe name.
        random.seed()
        sPipeName = "uno" + str(random.random())[2:]

        # Start the office proces, don't check for exit status since an exception is caught anyway if the office terminates unexpectedly.
        cmdArray = (sOffice, "-nologo", "-nodefault", "".join(["-accept=pipe,name=", sPipeName, ";urp;"]))
        os.spawnv(os.P_NOWAIT, sOffice, cmdArray)

        # ---------

        xLocalContext = uno.getComponentContext()
        resolver = xLocalContext.ServiceManager.createInstanceWithContext(
                        "com.sun.star.bridge.UnoUrlResolver", xLocalContext)
        sConnect = "".join(["uno:pipe,name=", sPipeName, ";urp;StarOffice.ComponentContext"])

        # Wait until an office is started, but loop only nLoop times (can we do this better???)
        nLoop = 20
        while True:
            try:
                xContext = resolver.resolve(sConnect)
                break
            except NoConnectException:
                nLoop -= 1
                if nLoop <= 0:
                    raise BootstrapException("Cannot connect to soffice server.", None)
                sleep(0.5)  # Sleep 1/2 second.

    except BootstrapException:
        raise
    except Exception as e:  # Any other exception
        raise BootstrapException("Caught exception " + str(e), None)

    return xContext
