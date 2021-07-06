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
import traceback
from com.sun.star.lang import Locale

class NumberFormatter(object):

    def __init__(self, _xNumberFormatsSupplier, _aLocale, _xMSF=None):
        self.iDateFormatKey = -1
        self.iDateTimeFormatKey = -1
        self.iNumberFormatKey = -1
        self.iTextFormatKey = -1
        self.iTimeFormatKey = -1
        self.iLogicalFormatKey = -1
        self.bNullDateCorrectionIsDefined = False
        self.aLocale = _aLocale
        if _xMSF is not None:
            self.xNumberFormatter = _xMSF.createInstance(
                "com.sun.star.util.NumberFormatter")
        self.xNumberFormats = _xNumberFormatsSupplier.NumberFormats
        self.xNumberFormatSettings = \
            _xNumberFormatsSupplier.NumberFormatSettings
        self.xNumberFormatter.attachNumberFormatsSupplier(
            _xNumberFormatsSupplier)

    '''
    @param _xMSF
    @param _xNumberFormatsSupplier
    @return
    @throws Exception
    @deprecated
    '''

    @classmethod
    def createNumberFormatter(self, _xMSF, _xNumberFormatsSupplier):
        oNumberFormatter = _xMSF.createInstance(
            "com.sun.star.util.NumberFormatter")
        oNumberFormatter.attachNumberFormatsSupplier(_xNumberFormatsSupplier)
        return oNumberFormatter

    '''
    gives a key to pass to a NumberFormat object. <br/>
    example: <br/>
    <pre>
    XNumberFormatsSupplier nsf =
        (XNumberFormatsSupplier)UnoRuntime.queryInterface(...,document)
    int key = Desktop.getNumberFormatterKey(
        nsf, ...star.i18n.NumberFormatIndex.DATE...)
    XNumberFormatter nf = Desktop.createNumberFormatter(xmsf, nsf);
    nf.convertNumberToString( key, 1972 );
    </pre>
    @param numberFormatsSupplier
    @param type - a constant out of i18n.NumberFormatIndex enumeration.
    @return a key to use with a util.NumberFormat instance.
    '''

    @classmethod
    def getNumberFormatterKey(self, numberFormatsSupplier, Type):
        return numberFormatsSupplier.NumberFormats.getFormatIndex(
            Type, Locale())

    def convertNumberToString(self, _nkey, _dblValue, _xNumberFormatter=None):
        if _xNumberFormatter is None:
            return self.xNumberFormatter.convertNumberToString(
                _nkey, _dblValue)
        else:
            return _xNumberFormatter.convertNumberToString(_nkey, _dblValue)

    def convertStringToNumber(self, _nkey, _sString):
        return self.xNumberFormatter.convertStringToNumber(_nkey, _sString)

