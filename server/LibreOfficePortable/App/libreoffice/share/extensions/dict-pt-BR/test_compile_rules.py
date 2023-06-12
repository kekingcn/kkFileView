#!/usr/bin/env python3
# -*- tab-width: 4; indent-tabs-mode: nil; py-indent-offset: 4 -*-
#
# This file is part of the LibreOffice project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# usage: run script in pt-BR dict root.
# $python3 test_compile_rules.py
import re
from pythonpath.lightproof_pt_BR import dic as rules


def main():
    for i, rule in enumerate(rules):
        msg = f'Test rule: {i} - {rule[0]}'
        print(msg)
        re.compile(rule[0])
    return


if __name__ == '__main__':
    main()
# vim: set shiftwidth=4 softtabstop=4 expandtab:
