# -*- encoding: UTF-8 -*-
# Lightproof grammar checker for LibreOffice and OpenOffice.org
# 2009-2012 (c) Laszlo Nemeth (nemeth at numbertext org), license: MPL 1.1 / GPLv3+ / LGPLv3+

import uno, unohelper, os, sys, traceback
locales = {'pt-BR': ['pt', 'BR', '']}
pkg = "pt_BR"
import lightproof_handler_pt_BR

from com.sun.star.linguistic2 import XProofreader, XSupportedLocales
from com.sun.star.linguistic2 import ProofreadingResult, SingleProofreadingError
from com.sun.star.lang import XServiceInfo, XServiceName, XServiceDisplayName
from com.sun.star.lang import Locale
# reload in obj.reload in Python 3
try:
    from obj import reload
except:
    pass

class Lightproof( unohelper.Base, XProofreader, XServiceInfo, XServiceName, XServiceDisplayName, XSupportedLocales):

    def __init__( self, ctx, *args ):
        self.ctx = ctx
        self.ServiceName = "com.sun.star.linguistic2.Proofreader"
        self.ImplementationName = "org.libreoffice.comp.pyuno.Lightproof." + pkg
        self.SupportedServiceNames = (self.ServiceName, )
        self.locales = []
        for i in locales:
            l = locales[i]
            self.locales += [Locale(l[0], l[1], l[2])]
        self.locales = tuple(self.locales)

    # XServiceName method implementations
    def getServiceName(self):
        return self.ImplementationName

    # XServiceInfo method implementations
    def getImplementationName (self):
        return self.ImplementationName

    def supportsService(self, ServiceName):
        return (ServiceName in self.SupportedServiceNames)

    def getSupportedServiceNames (self):
        return self.SupportedServiceNames

    # XSupportedLocales
    def hasLocale(self, aLocale):
        if aLocale in self.locales:
            return True
        for i in self.locales:
            if (i.Country == aLocale.Country or i.Country == "") and aLocale.Language == i.Language:
                return True
        return False

    def getLocales(self):
        return self.locales

    # XProofreader
    def isSpellChecker(self):
        return False

    def doProofreading(self, nDocId, rText, rLocale, nStartOfSentencePos, \
        nSuggestedSentenceEndPos, rProperties):
        import lightproof_impl_pt_BR
        currentContext = uno.getComponentContext()
        if lightproof_impl_pt_BR.SMGR == None:
            lightproof_impl_pt_BR.SMGR = currentContext.ServiceManager
            lightproof_impl_pt_BR.spellchecker = \
                lightproof_impl_pt_BR.SMGR.createInstanceWithContext("com.sun.star.linguistic2.SpellChecker", currentContext)
        lightproof_handler_pt_BR.load(currentContext)
        aRes = uno.createUnoStruct( "com.sun.star.linguistic2.ProofreadingResult" )
        aRes.aDocumentIdentifier = nDocId
        aRes.aText = rText
        aRes.aLocale = rLocale
        aRes.nStartOfSentencePosition = nStartOfSentencePos
        aRes.nStartOfNextSentencePosition = nSuggestedSentenceEndPos
        aRes.aProperties = ()
        aRes.xProofreader = self
        aRes.aErrors = ()
        # PATCH FOR LO 4
        # Fix for http://nabble.documentfoundation.org/Grammar-checker-Undocumented-change-in-the-API-for-LO-4-td4030639.html
        if nStartOfSentencePos != 0:
            return aRes
        aRes.nStartOfNextSentencePosition = len(rText)
        # END OF PATCH
        if len(rProperties) > 0 and rProperties[0].Name == "Update":
            try:
                import lightproof_compile_pt_BR
                try:
                    code = lightproof_compile_pt_BR.c(rProperties[0].Value, rLocale.Language, True)
                except Exception as e:
                    aRes.aText, aRes.nStartOfSentencePosition = e
                    return aRes
                path = lightproof_impl_pt_BR.get_path()
                f = open(path.replace("_impl", ""), "w")
                f.write("dic = %s" % code["rules"])
                f.close()
                if pkg in lightproof_impl_pt_BR.langrule:
                    mo = lightproof_impl_pt_BR.langrule[pkg]
                    reload(mo)
                    lightproof_impl_pt_BR.compile_rules(mo.dic)
                    lightproof_impl_pt_BR.langrule[pkg] = mo
                if "code" in code:
                    f = open(path, "r")
                    ft = f.read()
                    f.close()
                    f = open(path, "w")
                    f.write(ft[:ft.find("# [code]") + 8] + "\n" + code["code"])
                    f.close()
                    try:
                        reload(lightproof_impl_pt_BR)
                    except Exception as e:
                        aRes.aText = e.args[0]
                        if e.args[1][3] == "": # "expected an indented block" (end of file)
                            aRes.nStartOfSentencePosition = len(rText.split("\n"))
                        else:
                            aRes.nStartOfSentencePosition = rText.split("\n").index(e.args[1][3][:-1]) + 1
                        return aRes
                aRes.aText = ""
                return aRes
            except:
                if 'PYUNO_LOGLEVEL' in os.environ:
                    print(traceback.format_exc())

        l = rText[aRes.nStartOfNextSentencePosition:aRes.nStartOfNextSentencePosition+1]
        while l == " ":
            aRes.nStartOfNextSentencePosition = aRes.nStartOfNextSentencePosition + 1
            l = rText[aRes.nStartOfNextSentencePosition:aRes.nStartOfNextSentencePosition+1]
        if aRes.nStartOfNextSentencePosition == nSuggestedSentenceEndPos and l!="":
            aRes.nStartOfNextSentencePosition = nSuggestedSentenceEndPos + 1
        aRes.nBehindEndOfSentencePosition = aRes.nStartOfNextSentencePosition

        try:
            aRes.aErrors = lightproof_impl_pt_BR.proofread( nDocId, rText, rLocale, \
                nStartOfSentencePos, aRes.nBehindEndOfSentencePosition, rProperties)
        except Exception as e:
            if len(rProperties) > 0 and rProperties[0].Name == "Debug" and len(e.args) == 2:
                aRes.aText, aRes.nStartOfSentencePosition = e
            else:
                if 'PYUNO_LOGLEVEL' in os.environ:
                    print(traceback.format_exc())
        return aRes

    def ignoreRule(self, rid, aLocale):
        import lightproof_impl_pt_BR
        lightproof_impl_pt_BR.ignore[rid] = 1

    def resetIgnoreRules(self):
        import lightproof_impl_pt_BR
        lightproof_impl_pt_BR.ignore = {}

    # XServiceDisplayName
    def getServiceDisplayName(self, aLocale):
        import lightproof_impl_pt_BR
        return lightproof_impl_pt_BR.name

g_ImplementationHelper = unohelper.ImplementationHelper()
g_ImplementationHelper.addImplementation( Lightproof, \
    "org.libreoffice.comp.pyuno.Lightproof." + pkg,
    ("com.sun.star.linguistic2.Proofreader",),)

g_ImplementationHelper.addImplementation( lightproof_handler_pt_BR.LightproofOptionsEventHandler, \
    "org.libreoffice.comp.pyuno.LightproofOptionsEventHandler." + pkg,
    ("com.sun.star.awt.XContainerWindowEventHandler",),)
