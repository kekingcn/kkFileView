# -*- tab-width: 4; indent-tabs-mode: nil; py-indent-offset: 4 -*-
#
# This file is part of the LibreOffice project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
import sys, os, uno, unohelper
import re, random, traceback, itertools
import threading, time as __time__

__lng__ = {}

def __trace__():
    if 'PYUNO_LOGLEVEL' in os.environ:
        print(traceback.format_exc())

# get localized commands and messages
def __l12n__(lng):
    global __lng_fallback__
    try:
        return __lng__[lng]
    except:
        try:
            # load resource file
            __lng__[lng] = dict([[i.decode("unicode-escape").split("=")[0].strip(), i.decode("unicode-escape").split("=")[1].strip().strip("|")] for i in open(__lngpath__ + "LibreLogo_" + lng + ".properties", 'rb').readlines() if b"=" in i])
            return __lng__[lng]
        except:
            try:
                # or use embedded fallback resource dictionary
                __lng__[lng] = {}
                for i in __lng_fallback__:
                    try:
                        __lng__[lng][i] = __lng_fallback__[i][lng]
                    except:
                        try:
                            __lng__[lng][i] = __lng_fallback__[i][lng.split('_')[0]]
                        except:
                            __lng__[lng][i] = __lng_fallback__[i]["en_US"]
                return __lng__[lng]
            except Exception:
                __trace__()
                return None

try:
    urebootstrap = os.environ["URE_BOOTSTRAP"]
except:
    # starting in command line updates embedded fallback language dictionary
    print("Update fallback language resource using property file arguments")
    for i in sys.argv[1:]:
        r = re.match("^(.*)LibreLogo_(.*)[.]properties$", i)
        __lngpath__= r.group(1)
        __l12n__(r.group(2))
    fallback = {}

    # fallback of fallback is en_US
    for i in __lng__["en_US"]:
        fallback[i] = { "en_US": __lng__["en_US"][i] }

    # create fallback dictionary
    for i in __lng__:
        dif = 0
        for j in __lng__[i]:
            if __lng__[i][j] != __lng__["en_US"][j]:
                fallback[j][i] = __lng__[i][j]
                dif = dif + 1
        print(i, dif)

    # update fallback resource data in this program file
    import fileinput

    for line in fileinput.input(sys.argv[0], inplace=True):
        if re.match("^__lng_fallback__", line):
            print("__lng_fallback__ = {")
            # break it (CPython has problem with very long Unicode line)
            for i in fallback:
                print("'%s':%s," % (i, str(fallback[i])))
            print("}")
            sys.exit(1)
        else:
            print(line.rstrip("\n")),

if "vnd.sun.star.pathname" in urebootstrap:
    __lngpath__ = re.sub(r"^vnd.sun.star.pathname:(.*)program(/|\\)fundamental([.]ini|rc)$", "\\1", urebootstrap)
else:
    # A way to know if we use MacOs
    if "Resources" in urebootstrap:
        __lngpath__ = unohelper.fileUrlToSystemPath(re.sub("fundamentalrc$", "", urebootstrap))
    else:
        __lngpath__ = unohelper.fileUrlToSystemPath(re.sub("program/(fundamental.ini|fundamentalrc)$", "share", urebootstrap))
__lngpath__ = __lngpath__ + "/Scripts/python/LibreLogo/".replace("/", os.sep)
__translang__ = "am|ca|cs|de|dk|el|en|eo|es|et|fr|hu|it|ja|nl|no|pl|pt|ru|se|sl" # FIXME supported languages for language guessing, expand this list, according to the localizations
__docs__ = {}
__prevcode__ = None
__prevlang__ = None
__prevcompiledcode__ = None
__thread__ = None
__lock__ = threading.Lock()
__halt__ = False
__compiled__ = ""
__group__ = 0
__groupstack__ = []
__grouplefthang__ = 0
__comp__ = {}
__strings__ = []
__colors__ = {}
__COLORS__ = ['BLACK', 0x000000], ['SILVER', 0xc0c0c0], ['GRAY', 0x808080], \
    ['WHITE', 0xffffff], ['MAROON', 0x800000], ['RED', 0xff0000], \
    ['PURPLE', 0x800080], ['FUCHSIA', 0xff00ff], ['GREEN', 0x008000], \
    ['LIME', 0x00ff00], ['OLIVE', 0x808000], ['YELLOW', 0xffff00], \
    ['NAVY', 0x000080], ['BLUE', 0x0000ff], ['TEAL', 0x008080], \
    ['AQUA', 0x00ffff], ['PINK', 0xffc0cb], ['TOMATO', 0xff6347], \
    ['ORANGE', 0xffa500], ['GOLD', 0xffd700], ['VIOLET', 0x9400d3], \
    ['SKYBLUE', 0x87ceeb], ['CHOCOLATE', 0xd2691e], ['BROWN', 0xa52a2a], \
    ['INVISIBLE', 0xffffffff]
__NORMCOLORS__ = [[[255, 255, 0], 0, -11, 1, -11],
    [[255, 128, 0], 1, 116, 1, -33], [[255, 0, 0], 1, 95, 2, 42],
    [[255, 0, 255], 2, -213, 0, -106], [[0, 0, 255], 0, 148, 1, 127],
    [[0, 255, 255], 1, -128, 2, -63], [[0, 255, 0], 2, 192, 0, 244]]
__STRCONST__ = [i[0] for i in __COLORS__] + ['NONE', 'BEVEL', 'MITER', 'ROUNDED', 'SOLID', 'DASH', 'DOTTED', 'BOLD', 'ITALIC', 'UPRIGHT', 'NORMAL', "HOUR", "PT", "INCH", "MM", "CM"]
__SLEEP_SLICE_IN_MILLISECONDS__ = 500
__PT_TO_TWIP__ = 20
__MM_TO_PT__ = 1/(25.4/72)
__MM10_TO_TWIP__ = 1/(2540.0/72/20) # 0.01 mm to twentieth point
__FILLCOLOR__ = 0x8000cc00
__LINEWIDTH__ = 0.5 * __PT_TO_TWIP__
__ENCODED_STRING__ = "_s_%s___"
__ENCODED_COMMENT__ = "_c_%s___"
__DECODE_STRING_REGEX__ = "_s_([0-9]+)___"
__DECODE_COMMENT_REGEX__ = "_c_([0-9]+)___"
__LINEBREAK__ = "#_@L_i_N_e@_#"
__TURTLE__ = "turtle"
__ACTUAL__ = "actual"
__BASEFONTFAMILY__ = "Linux Biolinum G"
__LineStyle_DOTTED__ = 2
# LABEL supports font features with the simplified syntax <FEATURE>text</FEATURE>, e.g.
#   LABEL "Small caps: <smcp>text</smcp>"
# prints "Small caps: TEXT", where TEXT is small capital, if that feature is supported by the font
# See https://en.wikipedia.org/wiki/List_of_typographic_features
__match_fontfeatures__ = re.compile( r"(</?)("
 # OpenType
 "abvf|abvm|abvs|blwf|blwm|blws|pref|pres|psts|pstf|dist|akhn|haln|half|nukt|rkrf|rphf|vatu|cjct|cfar|"
 "smpl|trad|tnam|expt|hojo|nlck|jp78|jp83|jp90|jp04|hngl|ljmo|tjmo|vjmo|fwid|hwid|halt|twid|qwid|pwid|palt|pkna|ruby|hkna|vkna|cpct|"
 "curs|jalt|mset|rclt|rlig|isol|init|medi|med2|fina|fin2|fin3|falt|stch|"
 "lnum|onum|pnum|tnum|frac|afrc|dnom|numr|sinf|zero|mgrk|flac|dtls|ssty|"
 "smcp|c2sc|pcap|c2pc|unic|cpsp|case|ital|ordn|"
 "valt|vhal|vpal|vert|vrt2|vrtr|vkrn|ltra|ltrm|rtla|rtlm"
 "aalt|swsh|cswh|calt|hist|locl|rand|nalt|cv[0-9][0-9]|salt|ss[01][0-9]|ss20|subs|sups|titl|rvrn|clig|dlig|hlig|liga"
 "ccmp|kern|mark|mkmk|opbd|lfbd|rtbd|"
 # Linux Libertine G
 "size|ornm|ingl|algn|arti|caps|circ|dash|dbls|foot|frsp|grkn|hang|itlc|ligc|minu|nfsp|para|quot|texm|thou|vari)((=.*)?>)", re.IGNORECASE )
# LABEL localized color tags, e.g. <red>text in red</red>
__match_localized_colors__ = {}
# LABEL not localized tags (localized translated to these):
__match_tags__ = [re.compile(i, re.IGNORECASE) for i in [r'<(b|strong)>', r'</(b|strong)>', r'<(i|em)>', r'</(i|em)>', '<u>', '</u>', r'<(s|del)>', r'</(s|del)>', '<sup>', '</sup>', '<sub>', '</sub>', r'<(fontcolor) ([^<>]*)>', r'</(fontcolor)>', r'<(fillcolor) ([^<>]*)>', r'</(fillcolor)>', r'<(fontfamily) ([^<>]*)>', r'</(fontfamily)>', r'<(fontfeature) ([^<>]*)>', r'</(fontfeature) ?([^<>]*)>', r'<(fontheight) ([^<>]*)>', r'</(fontheight)>']]

class __Doc__:
    def __init__(self, doc):
        self.doc = doc
        self.secure = False
        try:
            self.drawpage = doc.DrawPage # Writer
        except:
            self.drawpage = doc.DrawPages.getByIndex(0) # Draw, Impress
        self.shapecache = {}
        self.shapecount = itertools.count()
        self.time = 0
        self.zoomvalue = 0
        self.lockturtle = False
        self.fixSVG = False
        self.initialize()

    def initialize(self):
        self.pen = 1
        self.pencolor = 0
        self.pensize = __LINEWIDTH__
        self.linestyle = __LineStyle_SOLID__
        self.linejoint = __ROUNDED__
        self.linecap = __Cap_NONE__
        self.oldlc = 0
        self.oldlw = 0
        self.oldls = __LineStyle_SOLID__
        self.oldlj = __ROUNDED__
        self.oldlcap = __Cap_NONE__
        self.continuous = True
        self.areacolor = __FILLCOLOR__
        self.t10y = int((__FILLCOLOR__ >> 24) / (255.0/100))
        self.hatch = None
        self.textcolor = 0
        self.fontfamily = __BASEFONTFAMILY__
        self.fontheight = 12
        self.fontweight = 100
        self.fontstyle = 0
        self.points = []

from math import pi, sin, cos, asin, sqrt, log10

from com.sun.star.awt import Point as __Point__
from com.sun.star.awt import Gradient as __Gradient__
from com.sun.star.awt.GradientStyle import LINEAR as __GradientStyle_LINEAR__
from com.sun.star.drawing import LineDash as __LineDash__
from com.sun.star.drawing import Hatch as __Hatch__
from com.sun.star.drawing import PolyPolygonBezierCoords as __Bezier__
from com.sun.star.text.TextContentAnchorType import AT_PAGE as __AT_PAGE__
from com.sun.star.text.WrapTextMode import THROUGH as __THROUGH__
from com.sun.star.drawing.LineCap import BUTT as __Cap_NONE__
from com.sun.star.drawing.LineCap import ROUND as __Cap_ROUND__
from com.sun.star.drawing.LineCap import SQUARE as __Cap_SQUARE__
from com.sun.star.drawing.LineJoint import NONE as __Joint_NONE__
from com.sun.star.drawing.LineJoint import BEVEL as __BEVEL__
from com.sun.star.drawing.LineJoint import MITER as __MITER__
from com.sun.star.drawing.LineJoint import ROUND as __ROUNDED__
from com.sun.star.drawing.FillStyle import NONE as __FillStyle_NONE__
from com.sun.star.drawing.FillStyle import GRADIENT as __FillStyle_GRADIENT__
from com.sun.star.drawing.LineStyle import NONE as __LineStyle_NONE__
from com.sun.star.drawing.LineStyle import SOLID as __LineStyle_SOLID__
from com.sun.star.drawing.LineStyle import DASH as __LineStyle_DASHED__
from com.sun.star.drawing.DashStyle import RECT as __DashStyle_RECT__
from com.sun.star.drawing.DashStyle import ROUND as __DashStyle_ROUND__
from com.sun.star.drawing.DashStyle import ROUNDRELATIVE as __DashStyle_ROUNDRELATIVE__
from com.sun.star.drawing.CircleKind import FULL as __FULL__
from com.sun.star.drawing.CircleKind import SECTION as __SECTION__
from com.sun.star.drawing.CircleKind import CUT as __CUT__
from com.sun.star.drawing.CircleKind import ARC as __ARC__
from com.sun.star.awt.FontSlant import NONE as __Slant_NONE__
from com.sun.star.awt.FontSlant import ITALIC as __Slant_ITALIC__
from com.sun.star.awt.FontUnderline import SINGLE as __Underline_SINGLE__
from com.sun.star.awt.FontStrikeout import SINGLE as __Strikeout_SINGLE__
from com.sun.star.awt import Size as __Size__
from com.sun.star.awt import WindowDescriptor as __WinDesc__
from com.sun.star.awt.WindowClass import MODALTOP as __MODALTOP__
from com.sun.star.awt.VclWindowPeerAttribute import OK as __OK__ 
from com.sun.star.awt.VclWindowPeerAttribute import OK_CANCEL as __OK_CANCEL__ 
from com.sun.star.awt.VclWindowPeerAttribute import YES_NO_CANCEL as __YES_NO_CANCEL__ # OK_CANCEL, YES_NO, RETRY_CANCEL, DEF_OK, DEF_CANCEL, DEF_RETRY, DEF_YES, DEF_NO
from com.sun.star.awt.PushButtonType import OK as __Button_OK__
from com.sun.star.awt.PushButtonType import CANCEL as __Button_CANCEL__
from com.sun.star.util.MeasureUnit import APPFONT as __APPFONT__
from com.sun.star.beans import PropertyValue as __property__
from com.sun.star.lang import Locale

def __getprop__(name, value):
    p, p.Name, p.Value = __property__(), name, value
    return p

__uilocale__ = uno.getComponentContext().getValueByName("/singletons/com.sun.star.configuration.theDefaultProvider").\
    createInstanceWithArguments("com.sun.star.configuration.ConfigurationAccess",\
    (__getprop__("nodepath", "/org.openoffice.Setup/L10N"),)).getByName("ooLocale") + '-' # handle missing Country of locale 'eo'

# dot for dotted line (implemented as an array of dot-headed arrows, because PostScript dot isn't supported by Writer)
def __gendots__(n):
    return [__Point__(round(sin(360.0/n * i * pi/180.0) * 600), round(cos(360.0/n * i * pi/180) * 600)) for i in range(n)]
__bezierdot__ = __Bezier__()
__bezierdot__.Coordinates = (tuple(__gendots__(32)),)
__bezierdot__.Flags = ((0,) * 32,)

# turtle shape
__TURTLESHAPE__ = [tuple([(__Point__(-120, 130), __Point__(-245, 347), __Point__(-291, 176), ), (__Point__(0, -500), __Point__(126, -375), __Point__(0, -250), __Point__(-124, -375), ), (__Point__(295, 170), __Point__(124, 124), __Point__(250, 340), ), (__Point__(466, -204), __Point__(224, -269), __Point__(71, -180), __Point__(313, -116), ), (__Point__(-75, -175), __Point__(-292, -300), __Point__(-417, -83), ), (__Point__(250, 0), __Point__(0, -250), __Point__(-250, 0), __Point__(0, 250), )] + 
            [(i,) for i in __gendots__(32)] + # single points for wider selection
            [(__Point__(0, 0),)]), # last point for position handling
            ((__Point__(0, 0),),)] # hidden turtle (single point to draw at the left border of the page area)

def __getdocument__():
    global __docs__, _
    doc = XSCRIPTCONTEXT.getDocument()
    try:
        _ = __docs__[doc.RuntimeUID]
    except:
        _ = __Doc__(doc)
        __docs__[doc.RuntimeUID] = _

# input function, result: input string or 0
def Input(s):
    global __halt__
    try:
        ctx = uno.getComponentContext()
        smgr = ctx.ServiceManager
        text = ""

        # dialog
        d = smgr.createInstanceWithContext("com.sun.star.awt.UnoControlDialogModel", ctx)
        ps = _.doc.CurrentController.Frame.ContainerWindow.getPosSize()
        lo = _.doc.CurrentController.Frame.ContainerWindow.convertSizeToLogic(__Size__(ps.Width, ps.Height), __APPFONT__)
        d.PositionX, d.PositionY, d.Width, d.Height = lo.Width/2 - 75, lo.Height/2 - 25, 150, 50

        # label
        l = d.createInstance("com.sun.star.awt.UnoControlFixedTextModel" )

        if type(s) == list:
            text = s[1]
            s = s[0]
        l.PositionX, l.PositionY, l.Width, l.Height, l.Name, l.TabIndex, l.Label = 5, 4, 140, 14, "l1", 2, s

        # textbox or combobox
        e = d.createInstance("com.sun.star.awt.UnoControlEditModel")
        e.PositionX, e.PositionY, e.Width, e.Height, e.Name, e.TabIndex = 5, 14, 140, 12, "e1", 0

        # buttons
        b = d.createInstance( "com.sun.star.awt.UnoControlButtonModel" )
        b.PositionX, b.PositionY, b.Width, b.Height, b.Name, b.TabIndex, b.PushButtonType, b.DefaultButton =  55, 32, 45, 14, "b1", 1, __Button_OK__, True
        b2 = d.createInstance( "com.sun.star.awt.UnoControlButtonModel" )
        b2.PositionX, b2.PositionY, b2.Width, b2.Height, b2.Name, b2.TabIndex, b2.PushButtonType = 100, 32, 45, 14, "b2", 1, __Button_CANCEL__

        # insert the control models into the dialog model 
        d.insertByName( "l1", l)
        d.insertByName( "b1", b)
        d.insertByName( "b2", b2) 
        d.insertByName( "e1", e) 

        # create the dialog control and set the model 
        controlContainer = smgr.createInstanceWithContext("com.sun.star.awt.UnoControlDialog", ctx)
        controlContainer.setModel(d)

        # create a peer 
        toolkit = smgr.createInstanceWithContext("com.sun.star.awt.ExtToolkit", ctx)
        controlContainer.setVisible(False)
        controlContainer.createPeer(toolkit, None)

        # execute it
        inputtext = controlContainer.execute()
        if inputtext:
            inputtext = e.Text
        else:
            # Cancel button
            __halt__ = True

        # dispose the dialog
        controlContainer.dispose()
        # stop program at pressing Cancel
        __checkhalt__()
        return inputtext
    except Exception:
        __trace__()

def __string__(s, decimal = None): # convert decimal sign, localized BOOL and SET
    if not decimal:
        decimal = _.decimal
    if decimal == ',' and type(s) == float:
        return str(s).replace(".", ",")
    if type(s) in [list, tuple, dict, set]:
        __strings__ = []
        s = re.sub("(?u)(['\"])(([^'\"]|\\['\"])*)(?<!\\\\)\\1", __encodestring__, str(s)) # XXX fix double '\'\"'
        if decimal == ',':
            s = s.replace(".", ",")
        return re.sub(__DECODE_STRING_REGEX__, __decodestring__, \
            s.replace('set', __locname__('SET')).replace('True', __locname__('TRUE')).replace('False', __locname__('FALSE')))
    if type(s) in [str]:
        return s
    elif type(s) == bool:
        return __locname__(str(s).upper())
    return str(s)

def Print(s):
    global __halt__
    s = __string__(s, _.decimal)
    if not MessageBox(_.doc.CurrentController.Frame.ContainerWindow, s[:500] + s[500:5000].replace('\n', ' '), "", "messbox", __OK_CANCEL__):
        # stop program at pressing Cancel
        __halt__ = True
        __checkhalt__()

def MessageBox(parent, message, title, msgtype = "messbox", buttons = __OK__):
    msgtypes = ("messbox", "infobox", "errorbox", "warningbox", "querybox")
    if not (msgtype in msgtypes):
        msgtype = "messbox"
    d = __WinDesc__()
    d.Type = __MODALTOP__
    d.WindowServiceName = msgtype
    d.ParentIndex = -1
    d.Parent = parent
    d.WindowAttributes = buttons
    tk = parent.getToolkit()
    msgbox = tk.createWindow(d)
    msgbox.MessageText = message
    if title:
        msgbox.CaptionText = title
    return msgbox.execute()

def Random(r):
    try:
        return r * random.random()
    except:
        return list(r)[int(random.random() * len(r))]

def to_ascii(s):
    return s.encode("unicode-escape").decode("utf-8").replace("\\u", "__u__").replace(r"\x", "__x__")

def to_unicode(s):
    return bytes(s.replace("__x__", r"\x").replace("__u__", "\\u"), "ascii").decode("unicode-escape")

def __locname__(name, l = -1):
    if l == -1:
        l = _.lng
    for i in __l12n__(l):
        if i == name.upper():
            return __l12n__(l)[i].split("|")[0] # return with the first localized name
    return to_unicode(name)

def __getcursor__(fulltext):
    realselection = False
    try:
        text = _.doc.getCurrentController().getViewCursor().getText().createTextCursor() # copy selection (also in frames)
        text.gotoRange(_.doc.getCurrentController().getViewCursor(), False)
        if fulltext:
            1/len(text.getString()) # exception, if zero length
        realselection = True
    except:
        text = _.doc.getText().createTextCursorByRange(_.doc.getText().getStart())
        text.gotoEnd(True)
    return text, realselection

def __translate__(arg = None):
    global _
    __getdocument__()
    selection = __getcursor__(True)[0]
    __initialize__()
    __setlang__()
    # detect language
    text = selection.getString()
    # remove comments and strings
    text = re.sub(r"[ ]*;[^\n]*", "", re.sub(r"['„“‘«»「][^\n'”“‘’«»」]*['”“‘’«»」]", "", re.sub(r"^[ \t]*[;#][^\n]*", "", text)))
    text = " ".join(set(re.findall(r"(?u)\w+", text)) - set(re.findall(r"(?u)\w*\d+\w*", text))).lower()  # only words
    ctx = uno.getComponentContext()
    guess = ctx.ServiceManager.createInstanceWithContext("com.sun.star.linguistic2.LanguageGuessing", ctx)
    guess.disableLanguages(guess.getEnabledLanguages())
    guess.enableLanguages(tuple([Locale(i, "", "") for i in __translang__.split("|")]))
    guess = guess.guessPrimaryLanguage(text, 0, len(text))
    try:
        l = {'cs': 'cs_CZ', 'el': 'el_GR', 'en': 'en_US', 'pt': 'pt_BR'}[guess.Language]
    except:
        l = guess.Language + '_' + guess.Language.upper()
    lang = __l12n__(l)
    if not lang:
        lang = __l12n__(guess.Language)
        if not lang:
            lang = __l12n__(_.lng)
            if not lang:
                lang = __l12n__("en_US")
    lq = '\'' + lang['LEFTSTRING'].replace("|", "")
    rq = '\'' + lang['RIGHTSTRING'].replace("|", "")
    __strings__ = []

    text = re.sub(r"^(([ \t]*[;#][^\n]*))", __encodecomment__, text)
    text = re.sub("(?u)([%s])((?:[^\n%s]|\\\\[%s])*)(?<!\\\\)[%s]" % (lq, rq, rq, rq), __encodestring__, selection.getString())
    text = re.sub(r'(?u)(?<![0-9])(")(~?\w*)', __encodestring__, text)
    text = re.sub(r";(([^\n]*))", __encodecomment__, text)

    # translate the program to the language of the document FIXME space/tab
    exception = ['DECIMAL']
    in1 = lang['IN'].upper()
    in2 = __l12n__(_.lng)['IN'].split("|")[0].upper()
    if in1[0] == '-' and in2[0] != '-': # "for x y-in" -> "for x in y"
        exception += ['IN']
        text = re.sub(r"(?ui)\b((?:%s) +:?\w+) +([^\n]+)(?:%s) +(?=[\[] |[\[]\n)" % (lang['FOR'], in1), "\\1 %s \\2 " % in2, text)
        text = re.sub(r"(?ui)(:?\b\w+|[\[][^[\n]*])\b(?:%s)\b" % in1, "%s \\1" % in2, text)
    elif in1[0] != '-' and in2[0] == '-': # "for x in y" -> "for x y-in"
        exception += ['IN']
        text = re.sub(r"(?ui)(?<=\n)((?:%s)\b +:?\w+) +(?:%s) +([^\n]+?) +(?=[\[] |[\[]\n)" % (lang['FOR'], in1), "\\1 \\2%s " % in2, text)
        text = re.sub(r"(?ui)(?<!:)\b(?:%s) +(:?\b\w+|[\[][^[\n]*])\b" % in1, "\\1%s" % in2, text)
    for i in set(lang) - set(exception):
        text = re.sub(r'(?ui)(?<!:)\b(%s)\b' % lang[i], __l12n__(_.lng)[i].split("|")[0].upper(), text)
    text = re.sub(r"(?<=\d)[%s](?=\d)" % lang['DECIMAL'], __l12n__(_.lng)['DECIMAL'], text)

    # decode strings and comments
    quoted = u"(?ui)(?<=%s)(%%s)(?=%s)" % (__l12n__(_.lng)['LEFTSTRING'][0], __l12n__(_.lng)['RIGHTSTRING'][0])
    text = re.sub(__DECODE_STRING_REGEX__, __decodestring2__, text)
    for i in __STRCONST__:
        text = re.sub(quoted % lang[i], __l12n__(_.lng)[i].split("|")[0].upper(), text)
    text = re.sub(__DECODE_COMMENT_REGEX__, __decodecomment__, text)
    if _.doc.getText().compareRegionStarts(selection.getStart(), _.doc.getText().getStart()) == 0:
        pagebreak = True
        selection.setString("\n" + text.lstrip("\n"))
    else:
        pagebreak = False
        selection.setString(text)
    # convert to paragraphs
    __dispatcher__(".uno:ExecuteSearch", (__getprop__("SearchItem.SearchString", r"\n"), __getprop__("SearchItem.ReplaceString", r"\n"), \
        __getprop__("Quiet", True), __getprop__("SearchItem.Command", 3), __getprop__("SearchItem.StyleFamily", 2), \
        __getprop__("SearchItem.AlgorithmType", 1), __getprop__("SearchItem.AlgorithmType2", 2), __getprop__("SearchItem.SearchFlags", 0)))
    # set 2-page layout
    if pagebreak:
        selection.getStart().BreakType = 4
    __dispatcher__(".uno:ZoomPage")

def __get_time__():
    return __time__.process_time() - _.start_time

class LogoProgram(threading.Thread):
    def __init__(self, code):
        self.code = code
        threading.Thread.__init__(self)

    def secure(self):
        # 0 = secure
        if _.secure:
            return 0

        # 1 = forms, fields or embedded objects are forbidden
        if _.doc.DrawPage.Forms.getCount() > 0 or _.doc.getTextFields().createEnumeration().hasMoreElements() or _.doc.getEmbeddedObjects().getCount() > 0:
            return 1

        # 2 = hyperlinks with script events
        nodes = _.doc.Text.createEnumeration()
        while nodes.hasMoreElements():
            node = nodes.nextElement()
            if node.supportsService("com.sun.star.text.Paragraph"):
                portions = node.createEnumeration()
                while portions.hasMoreElements():
                    portion = portions.nextElement()
                    if portion.PropertySetInfo.hasPropertyByName("HyperLinkEvents"):
                        events = portion.getPropertyValue("HyperLinkEvents")
                        for event in events.getElementNames():
                            attributes = events.getByName(event)
                            for attribute in attributes:
                                if attribute.Name == "EventType" and attribute.Value == "Script":
                                    return 2

        # 2 = images with script events
        images = _.doc.DrawPage.createEnumeration()
        while images.hasMoreElements():
            image = images.nextElement()
            try:
                events = image.Events
                for event in events.getElementNames():
                    attributes = events.getByName(event)
                    for attribute in attributes:
                        if attribute.Name == "EventType" and attribute.Value == "Script":
                            return 2
            except:
                pass

        _.secure = True
        return 0

    def run(self):
        global __thread__
        try:
            # check document security
            secid = self.secure()
            if secid > 0:
                parent = _.doc.CurrentController.Frame.ContainerWindow
                MessageBox(parent, "Document objects with%s script events" % [" possible", ""][secid-1], "LibreLogo program can't start", "errorbox")
            else:
                _.fixSVG = False
                _.start_time = __time__.process_time()
                exec(self.code)
                __unlock__(all_levels = True)
            if _.origcursor[0] and _.origcursor[1]:
                __dispatcher__(".uno:Escape")
                try:
                    _.doc.CurrentController.getViewCursor().gotoRange(_.origcursor[0], False)
                except:
                    _.doc.CurrentController.getViewCursor().gotoRange(_.origcursor[0].getStart(), False)
        except Exception as e:
            try:
              __unlock__(all_levels = True)
              TRACEPATTERN = '"<string>", line '
              message = traceback.format_exc()
              l = re.findall(TRACEPATTERN + '[0-9]+', message)
              if len(l) > 0 and not "SystemExit" in message:
                line = len(re.findall(__LINEBREAK__, ''.join(self.code.split("\n")[:int(l[-1][len(TRACEPATTERN):])]))) + 1
                caption = __l12n__(_.lng)['LIBRELOGO']
                if __prevcode__ and "\n" in __prevcode__:
                    __gotoline__(line)
                    caption = __l12n__(_.lng)['ERROR'] % line
                parent = _.doc.CurrentController.Frame.ContainerWindow
                if "maximum recursion" in message:
                    MessageBox(parent, __l12n__(_.lng)['ERR_STOP'] + " " + __l12n__(_.lng)['ERR_MAXRECURSION'] % sys.getrecursionlimit(), __l12n__(_.lng)['LIBRELOGO'])
                elif "cannot initialize memory" in message or "Couldn't instantiate" in message:
                    MessageBox(parent, __l12n__(_.lng)['ERR_STOP'] + " " + __l12n__(_.lng)['ERR_MEMORY'], __l12n__(_.lng)['LIBRELOGO'])
                elif "ZeroDivisionError" in message:
                    MessageBox(parent, __l12n__(_.lng)['ERR_ZERODIVISION'], caption, "errorbox")
                elif "IndexError" in message:
                    MessageBox(parent, __l12n__(_.lng)['ERR_INDEX'], caption, "errorbox")
                elif "KeyError" in message:
                    MessageBox(parent, __l12n__(_.lng)['ERR_KEY'] % eval(re.search("KeyError: ([^\n]*)", message).group(1)), caption, "errorbox")
                elif "NameError" in message:
                    if "__repeat__" in message:
                        MessageBox(parent, __l12n__(_.lng)['ERR_ARGUMENTS'] % (__locname__('REPEAT'), 1, 0), caption, "errorbox")
                    else:
                        MessageBox(parent, __l12n__(_.lng)['ERR_NAME'] % \
                            to_unicode(re.search(r"(?<=name ')[\w_]*(?=')", message).group(0)), caption, "errorbox")
                elif "TypeError" in message and "argument" in message and "given" in message:
                    r = re.search(r"([\w_]*)[(][)][^\n]* (\w+) arguments? [(](\d+)", message) # XXX later: handle 'no arguments' + plural
                    MessageBox(parent, __l12n__(_.lng)['ERR_ARGUMENTS'] % (__locname__(r.group(1)), r.group(2), r.group(3)), caption, "errorbox")
                else:
                    origline = __compiled__.split("\n")[line-1]
                    if not "com.sun.star" in message and not "__repeat__" in message and not "*)" in message and ("[" in origline or "]" in origline):
                        MessageBox(parent, __l12n__(_.lng)['ERR_BLOCK'], caption, "errorbox")
                    else:
                        MessageBox(parent, __l12n__(_.lng)['ERROR'] %line, __l12n__(_.lng)['LIBRELOGO'], "errorbox")
              __trace__()
            except:
              pass
        with __lock__:
            __thread__ = None

# to check LibreLogo program termination (in that case, return value is False)
def __is_alive__():
    return __thread__ != None

def __encodestring__(m):
    __strings__.append(re.sub("(\\[^\\]|\\\\(?=[‘’“”»」』]))", "", m.group(2)))
    # replace the string with the numbered identifier _s_0___, _s_1___, ...
    return __ENCODED_STRING__ % (len(__strings__) - 1)

def __encodecomment__(m):
    __strings__.append(re.sub("\\[^\\]", "", m.group(2)))
    return __ENCODED_COMMENT__ % (len(__strings__) - 1)

def __decodestring__(m):
    return "u'%s'" % __strings__[int(m.group(1))]

def __decodestring2__(m):
    return __l12n__(_.lng)['LEFTSTRING'][0] + __strings__[int(m.group(1))] + __l12n__(_.lng)['RIGHTSTRING'][0]

def __decodecomment__(m):
    return ";" + __strings__[int(m.group(1))]

def __initialize__():
    global __halt__, __thread__
    __getdocument__()
    _.zoomvalue = _.doc.CurrentController.getViewSettings().ZoomValue
    shape = __getshape__(__TURTLE__)
    if not shape:
        shape = _.doc.createInstance( "com.sun.star.drawing.PolyPolygonShape" )
        shape.AnchorType = __AT_PAGE__
        shape.TextWrap = __THROUGH__
        shape.Opaque = True
        _.drawpage.add(shape) 
        shape.PolyPolygon = __TURTLESHAPE__[0]
        _.shapecache[__TURTLE__] = shape
        shape.Name = __TURTLE__
        _.initialize()
        turtlehome()
        _.doc.CurrentController.select(shape)
        shape.FillColor, transparence = __splitcolor__(_.areacolor, shape)
        shape.LineColor, shape.LineTransparence = __splitcolor__(_.pencolor)
    elif shape.Visible:
        if shape.FillStyle == __FillStyle_NONE__:
            _.areacolor = 0xffffffff
        else:
            _.areacolor = shape.FillColor + (int(255.0 * shape.FillTransparence/100) << 24)
        if shape.LineWidth != round((1 + _.pen * 2) * __PT_TO_TWIP__ / __MM10_TO_TWIP__) and shape.LineWidth != round(__LINEWIDTH__ / __MM10_TO_TWIP__):
            _.pensize = shape.LineWidth * __MM10_TO_TWIP__
        if shape.LineStyle == __LineStyle_NONE__: # - none -
            __pen__(0)
        else:
            if shape.LineStyle == __LineStyle_SOLID__:
                __pen__(1)
            _.pencolor = shape.LineColor + (int(255.0 * shape.LineTransparence/100) << 24)
    shape.LineJoint = __ROUNDED__
    shape.Shadow = True
    shape.FillColor, transparence = __splitcolor__(_.areacolor, shape)
    shape.FillTransparence = min(95, transparence)
    shape.ShadowColor, shape.ShadowTransparence, shape.ShadowXDistance, shape.ShadowYDistance = (0, 20, 0, 0)
    shape.LineWidth = min(_.pensize, (1 + _.pen * 2) * __PT_TO_TWIP__) / __MM10_TO_TWIP__
    shape.SizeProtect = True

def pagesize(n = -1):
    if n == -1:
        ps = _.doc.CurrentController.getViewCursor().PageStyleName
        page = _.doc.StyleFamilies.getByName("PageStyles").getByName(ps)
        return [page.Width * __MM10_TO_TWIP__ / __PT_TO_TWIP__, page.Height * __MM10_TO_TWIP__ / __PT_TO_TWIP__]
    return None

def turtlehome():
    turtle = __getshape__(__TURTLE__)
    if turtle:
        ps = _.doc.CurrentController.getViewCursor().PageStyleName
        page = _.doc.StyleFamilies.getByName("PageStyles").getByName(ps)
        turtle.setPosition(__Point__((page.Width - turtle.BoundRect.Width)/2, (page.Height - turtle.BoundRect.Height)/2))
        turtle.LineStyle = __LineStyle_SOLID__
        turtle.LineJoint = __MITER__
        turtle.LineWidth = min(_.pensize, (1 + _.pen * 2) * __PT_TO_TWIP__) / __MM10_TO_TWIP__
        turtle.LineColor, none = __splitcolor__(_.pencolor)
        turtle.LineTransparence = 25
        turtle.RotateAngle = 0
        turtle.ZOrder = 1000

def __pen__(n):
    _.pen = n
    turtle = __getshape__(__TURTLE__)
    if turtle:
        if n:
            turtle.LineStyle = __LineStyle_SOLID__
            turtle.LineWidth = min(_.pensize, 3 * __PT_TO_TWIP__) / __MM10_TO_TWIP__
        else:
            turtle.LineStyle = __LineStyle_DASHED__
            turtle.LineDash = __LineDash__(__DashStyle_RECT__, 0, 0, 1, __PT_TO_TWIP__, __PT_TO_TWIP__)
            turtle.LineWidth = min(_.pensize, __PT_TO_TWIP__) / __MM10_TO_TWIP__


def __visible__(shape, visible = -1): # for OOo 3.2 compatibility
    try:
        if visible == -1:
            return shape.Visible
        shape.Visible = visible
    except:
        return True

def hideturtle():
    turtle = __getshape__(__TURTLE__)
    if turtle and turtle.Visible:
        z = turtle.getPosition()
        z = __Point__(z.X + turtle.BoundRect.Width / 2.0, z.Y + turtle.BoundRect.Height / 2.0)
        turtle.PolyPolygon = __TURTLESHAPE__[1]
        __visible__(turtle, False)
        turtle.LineTransparence, turtle.FillTransparence = 100, 100 # for saved files
        turtle.setPosition(z)
    else:
        # HIDETURTLE during locking, no need SHOWTURTLE at the end of locking
        _.lockturtle = False
    __dispatcher__(".uno:Escape")

def showturtle():
    turtle = __getshape__(__TURTLE__)
    if turtle and not turtle.Visible:
        if not turtle.Parent:
            _.drawpage.add(turtle)
        z = turtle.getPosition()
        r, turtle.RotateAngle = turtle.RotateAngle, 0
        turtle.PolyPolygon, turtle.RotateAngle = __TURTLESHAPE__[0], r
        z = __Point__(z.X - turtle.BoundRect.Width / 2.0, z.Y - turtle.BoundRect.Height / 2.0) 
        turtle.setPosition(z)
        __visible__(turtle, True)
        pencolor(_.pencolor)
        fillcolor(_.areacolor)
        pensize(_.pensize/__PT_TO_TWIP__)
        _.doc.CurrentController.select(__getshape__(__TURTLE__))
    elif not turtle:
        __initialize__()

def left(arg=None):
    if __thread__:
        return None
    __initialize__()
    turtle = uno.getComponentContext().ServiceManager.createInstance('com.sun.star.drawing.ShapeCollection')
    turtle.add(__getshape__(__TURTLE__))
    _.doc.CurrentController.select(turtle)
    rotate(__TURTLE__, 1500)
    return None

def right(arg=None):
    if __thread__:
        return None
    __initialize__()
    turtle = uno.getComponentContext().ServiceManager.createInstance('com.sun.star.drawing.ShapeCollection')
    turtle.add(__getshape__(__TURTLE__))
    _.doc.CurrentController.select(turtle)
    rotate(__TURTLE__, -1500)
    return None

def goforward(arg=None):
    if __thread__:
        return None
    __initialize__()
    turtle = uno.getComponentContext().ServiceManager.createInstance('com.sun.star.drawing.ShapeCollection')
    turtle.add(__getshape__(__TURTLE__))
    _.doc.CurrentController.select(turtle)
    forward(10)
    return None

def gobackward(arg=None):
    if __thread__:
        return None
    __initialize__()
    turtle = uno.getComponentContext().ServiceManager.createInstance('com.sun.star.drawing.ShapeCollection')
    turtle.add(__getshape__(__TURTLE__))
    _.doc.CurrentController.select(turtle)
    backward(10)
    return None

def commandline(arg=None, arg2=None):
    run(arg, arg2)

def __setlang__():
        global _
        c = _.doc.CurrentController.getViewCursor()
        locs = [i for i in [c.CharLocale, c.CharLocaleAsian, c.CharLocaleComplex] if i.Language != 'zxx'] # not None language
		# FIXME-BCP47: this needs adaptation to language tags, a simple split on
		# '-' and assuming second field would be country would already fail if
		# a script tag was present.
        loc = Locale(__uilocale__.split('-')[0], __uilocale__.split('-')[1], '')
        if locs and loc not in locs:
            loc = locs[0]
        _.lng = loc.Language + '_' + loc.Country
        if not __l12n__(_.lng):
            _.lng = loc.Language
            if not __l12n__(_.lng):
                _.lng = "en_US"

def run(arg=None, arg2 = -1):
    global _, __thread__, __halt__, _, __prevcode__, __prevlang__, __prevcompiledcode__
    if __thread__:
        return None
    with __lock__:
        __thread__ = 1
    try:
        __getdocument__()
        _.origcursor = [None, None]
        if arg2 == -1:
            _.origcursor, _.cursor = __getcursor__(False), __getcursor__(True)[0]
            __dispatcher__(".uno:Escape")
            c = _.doc.Text.createTextCursor() # go to the first page
            c.gotoStart(False)
            _.doc.CurrentController.getViewCursor().gotoRange(c, False)
            __initialize__()
            __setlang__()
            arg2 = _.cursor.getString()
            if len(arg2) > 20000:
                if MessageBox(_.doc.CurrentController.Frame.ContainerWindow, __l12n__(_.lng)['ERR_NOTAPROGRAM'], __l12n__(_.lng)['LIBRELOGO'], "querybox", __YES_NO_CANCEL__) != 2:
                    with __lock__:
                        __thread__ = None
                    return None
            elif len(arg2) == 0 and _.origcursor[1]:
                _.origcursor[0].setString("fontcolor 'green'\nlabel 'LIBRE'\npu\nback 30\npic [\n\tfc any\n\tcircle 40\n\tfontcolor 'black'\n\tlabel 'LOGO'\n\tleft 180\n\tfd 20\n\tpd\n\tpc any\n\tps 1\n\tfd 40\n\trepeat 20 [\n\t\tfd repcount*2\n\t\trt 90\n\t]\n]\npu pos any pd")
                __translate__()
                _.origcursor, _.cursor = __getcursor__(False), __getcursor__(True)[0]
                arg2 = _.cursor.getString()
        else:
            __initialize__()
            __setlang__()
        if __prevcode__ and __prevcode__ == arg2 and __prevlang__ == _.lng:
            __thread__ = LogoProgram(__prevcompiledcode__)
        else:
            __prevcode__ = arg2
            __prevlang__ = _.lng
            __prevcompiledcode__ = __compil__(arg2)
            __thread__ = LogoProgram(__prevcompiledcode__)
        __halt__ = False
        turtle = uno.getComponentContext().ServiceManager.createInstance('com.sun.star.drawing.ShapeCollection')
        turtle.add(__getshape__(__TURTLE__))
        _.doc.CurrentController.select(turtle)
        # set working directory for file operations
        if _.doc.hasLocation():
          name = os.chdir(unohelper.fileUrlToSystemPath(re.sub("[^/]*$", "", _.doc.getURL())))
        else:
          name = os.chdir(os.path.expanduser('~'))
        __thread__.start()
    except Exception as e:
        __thread__ = None
        __trace__()
    return None

def __unlock__(all_levels):
    while _.doc.hasControllersLocked():
        # show turtle which was hidden by locking
        if _.lockturtle:
            showturtle()
        _.doc.unlockControllers()
        if not all_levels:
            break
    if not _.doc.hasControllersLocked() and _.lockturtle:
        _.lockturtle = False
    elif _.doc.hasControllersLocked() and _.lockturtle:
        hideturtle()

def stop(arg=None):
    global __halt__
    with __lock__:
        __halt__ = True
    __unlock__(all_levels = True)
    return None

def home(arg=None):
    if __thread__:
        return None
    __getdocument__()
    turtle = __getshape__(__TURTLE__)
    if turtle:
        __removeshape__(__TURTLE__)
        _.drawpage.remove(turtle)
    __initialize__()
    __dispatcher__(".uno:Escape")
    if not __halt__:
        return None
    _.pencolor = 0
    _.pensize = __LINEWIDTH__
    _.areacolor = __FILLCOLOR__
    pen = 1
    __removeshape__(__ACTUAL__)

def clearscreen(arg=None):
    if __thread__:
        return None
    __getdocument__()
    turtle = __getshape__(__TURTLE__)
    if not turtle:
        __initialize__()
        if not __halt__:
            # avoid unintentional image deletion in large documents
            if len(__getcursor__(True)[0].getString()) < 5000:
                __cs__(False)
            return
    __cs__(False)
    __dispatcher__(".uno:Escape")

def __checkhalt__():
    global __thread__, __halt__
    if __halt__:
        with __lock__:
            __thread__ = None
        sys.exit()

def __cs__(select = True):
    turtle = __getshape__(__TURTLE__)
    visible = False
    if turtle and turtle.Visible:
        __visible__(turtle, False)
        visible = True
    if _.doc.CurrentController.select(_.drawpage) and \
        _.doc.CurrentController.getSelection().ImplementationName == "com.sun.star.drawing.SvxShapeCollection":
            __dispatcher__(".uno:Delete")
    if turtle and visible:
        __visible__(turtle, True)
        if select:
            _.doc.CurrentController.select(_.drawpage)

def __dispatcher__(s, properties = (), doc = 0):
    ctx = XSCRIPTCONTEXT.getComponentContext()
    d = ctx.ServiceManager.createInstanceWithContext("com.sun.star.frame.DispatchHelper", ctx)
    if doc != 0:
      d.executeDispatch(doc.CurrentController.Frame, s, "", 0, properties)
    else:
      d.executeDispatch(_.doc.CurrentController.Frame, s, "", 0, properties)

def __getshape__(shapename):
    try:
        if _.shapecache[shapename].Parent:
            return _.shapecache[shapename]
        _.shapecache.pop(shapename)
    except:
        pass
    return None

def __angle__(deg):
    if deg == u'any':
        return random.random() * 36000
    return deg * 100

def turnleft(deg):
    rotate(__TURTLE__, __angle__(deg))

def turnright(deg):
    rotate(__TURTLE__, -__angle__(deg))

def heading(deg = -1, go = False):
    turtle = __getshape__(__TURTLE__)
    if deg == -1:
        return -turtle.RotateAngle / 100 + 360
    else:
        if deg == u'any':
            turtle.RotateAngle = random.random() * 36000
        elif type(deg) == list:
            pos = turtle.getPosition()
            px, py = pos.X + turtle.BoundRect.Width / 2.0, pos.Y + turtle.BoundRect.Height / 2.0
            dx = px * __MM10_TO_TWIP__ - deg[0] * __PT_TO_TWIP__
            dy = deg[1] * __PT_TO_TWIP__ - py * __MM10_TO_TWIP__
            n = sqrt(dx**2 + dy**2)
            if dy > 0 and n > 0:
                turtle.RotateAngle = a = -(180 + asin(dx / n) / (pi/180)) * 100 + 72000 # +720 for max(angle, preciseAngle) of __go__()
            elif n > 0:
                turtle.RotateAngle = a = asin(dx / n) / (pi/180) * 100 + 72000
            if go and n > 0:
                __go__(__TURTLE__, -n, False, a)
        else:
            turtle.RotateAngle = -deg * 100

def rotate(shapename, deg):
    shape = __getshape__(shapename)
    if shape:
        shape.RotateAngle = shape.RotateAngle + deg

def forward(n):
    if type(n) == list:
        pos = position()
        angle = heading()
        dx = n[1] * sin((pi/180) * angle) + n[0] * sin((pi/180)*(angle + 90))
        dy = n[1] * cos((pi/180) * angle) + n[0] * cos((pi/180)*(angle + 90))
        position([pos[0] + dx, pos[1] - dy])
    elif type(n) == str:
        siz = label([1, 1, n])
        shape = __getshape__(__ACTUAL__)
        pos = position()
        angle = heading()
        w, h = siz.Width / (__PT_TO_TWIP__ / __MM10_TO_TWIP__), siz.Height / (__PT_TO_TWIP__ / __MM10_TO_TWIP__)
        dx = 0 * sin((pi/180) * (angle)) + w * sin((pi/180)*(angle + 90))
        dy = 0 * cos((pi/180) * (angle)) + w * cos((pi/180)*(angle + 90))
        position([pos[0] + dx, pos[1] - dy])
        heading(angle)
    else:
        __go__(__TURTLE__, -n * __PT_TO_TWIP__)

def backward(n):
    if type(n) == list:
        forward([-n[0], -n[1]])
        turnright(180)
    else:
        __go__(__TURTLE__, n * __PT_TO_TWIP__)

def __dots__(n, pos, dx, dy, r = -1, q = 0): # dots for dotted polyline or circle
    f = [1, 4, 4, 4, 4][q]
    k = abs(int(1.0 * n / max(20, _.pensize) / 2.0 / f))
    dots = []
    px, py = pos.X, pos.Y
    for i in range(k + 1):
        if k > 0:
            if r != -1:
                px, py = pos.X + sin(((f-1)*(q-1)*30 + 360.0/f/k * i) * pi/180.0) * r[0], pos.Y + cos(((f-1)*(q-1)*30 + 360.0/f/k * i) * pi/180) * r[1]
            else:
                px, py = pos.X + round(i * dx/k), pos.Y + round(i * dy/k)
        dots += [(__Point__(px, py), __Point__(px + 7, py + 7))]
    return dots

def __draw__(d, count = True):
    shape = _.doc.createInstance( "com.sun.star.drawing." + d)
    shape.AnchorType = __AT_PAGE__
    shape.TextWrap = __THROUGH__
    __visible__(shape, False)
    while __zoom__(): # temporary fix program halt with continuous zoom
        while __zoom__():
            __time__.sleep(0.2)
        __time__.sleep(0.2)
    _.drawpage.add(shape)
    if __group__ != 0:
        __group__.add(shape)
        if count:
            _.shapecache[next(_.shapecount)] = str(_.time)
    return shape

def __zoom__():
    z = _.doc.CurrentController.getViewSettings().ZoomValue
    if z != _.zoomvalue:
        _.zoomvalue = z
        return True
    return False

def __lefthang__(shape):
    global __grouplefthang__
    if __group__ != 0:
        p = shape.getPosition()
        if p.X < __grouplefthang__:
            __grouplefthang__ = p.X

def __go__(shapename, n, dot = False, preciseAngle = -1):
    turtle = __getshape__(shapename)
    turtlepos = None
    if shapename == __TURTLE__:
        try:
            turtlepos = turtle.PolyPolygon[-1][-1]
        except:
            pass
    pos = turtle.getPosition()
    dx = n * sin((pi/180)*(max(turtle.RotateAngle, preciseAngle)/100))
    dy = n * cos((pi/180)*(max(turtle.RotateAngle, preciseAngle)/100))
    turtle.setPosition(__Point__(pos.X + dx / __MM10_TO_TWIP__, pos.Y + dy / __MM10_TO_TWIP__))
    if (_.pencolor != _.oldlc or _.pensize != _.oldlw or _.linestyle != _.oldls or _.linejoint != _.oldlj or _.linecap != _.oldlcap):
        __removeshape__(__ACTUAL__)
        shape = None
    else:
        shape = __getshape__(__ACTUAL__)
    _.oldlw = _.pensize
    _.oldlc = _.pencolor
    _.oldls = _.linestyle
    _.oldlj = _.linejoint
    _.oldlcap = _.linecap
    if shape and not _.pen and not dot:
        _.continuous = False
        return
    c, c2 = __Point__(pos.X + turtle.BoundRect.Width / 2.0, pos.Y + turtle.BoundRect.Height / 2.0), __Point__(round(dx / __MM10_TO_TWIP__), round(dy / __MM10_TO_TWIP__))
    if shape and "LineShape" in shape.ShapeType:
            if _.continuous or dot:
                last = shape.PolyPolygon[-1][-1]
                if not (turtlepos and (abs(last.X - turtlepos.X) > 100 or abs(last.Y - turtlepos.Y) > 100) and 
                  (__group__ == 0 or (shape.getPosition().X > 0 and turtle.getPosition().X > 0))): # picture [ ] keeps hanging shapes
                    if dot or _.linestyle == __LineStyle_DOTTED__:
                         shape.PolyPolygon = tuple( list(shape.PolyPolygon) + __dots__(n, turtlepos, dx, dy))
                    else:
                        last.X = last.X + c2.X
                        last.Y = last.Y + c2.Y
                        shape.PolyPolygon = tuple( list(shape.PolyPolygon[:-1]) + [tuple( list(shape.PolyPolygon[-1]) + [last])])
                    __lefthang__(shape)
                    return
            elif turtlepos:
                shape.PolyPolygon = tuple( list(shape.PolyPolygon) + [(turtlepos, __Point__(turtlepos.X + c2.X, turtlepos.Y + c2.Y))])
                _.continuous = True
                __lefthang__(shape)
                return
    if not _.pen and not dot:
        return
    if _.pen and not dot:
        _.points = [] # new line drawing: forget the points
    shape = __draw__("PolyLineShape")
    shape.RotateAngle = 0
    shape.PolyPolygon = tuple([tuple([__Point__(0, 0)])])
    shape.setPosition(c)
    last = shape.PolyPolygon[-1][-1]
    last2 = __Point__(last.X + c2.X, last.Y + c2.Y)
    shape.LineStyle, shape.LineDash = __linestyle__(_.linestyle)
    shape.LineJoint = _.linejoint
    shape.LineCap = _.linecap
    if dot or _.linestyle == __LineStyle_DOTTED__:
        shape.PolyPolygon = tuple( list(shape.PolyPolygon) + __dots__(n, last, c2.X, c2.Y))
        shape.LineStart = __bezierdot__
        shape.LineStartCenter = True
        shape.LineStartWidth = max(20, _.pensize) / __MM10_TO_TWIP__
        shape.LineWidth = 0
    else:
        shape.PolyPolygon = tuple([tuple( list(shape.PolyPolygon[-1]) + [last2])])
        shape.LineWidth = _.pensize / __MM10_TO_TWIP__
    shape.LineColor, shape.LineTransparence = __splitcolor__(_.pencolor)
    if shape.LineTransparence == 100:
        shape.LineStyle = 0
    __visible__(shape, True)
    shape.Name = __ACTUAL__
    _.shapecache[__ACTUAL__] = shape
    _.oldlw = _.pensize
    _.oldlc = _.pencolor
    _.oldls = _.linestyle
    _.oldlj = _.linejoint
    _.oldlcap = _.linecap
    _.continuous = True
    __lefthang__(shape)

def __fillit__(filled = True):
    oldshape = __getshape__(__ACTUAL__)
    if (oldshape and oldshape.LineStartCenter) or _.points:
        if oldshape:
            __removeshape__(__ACTUAL__)  # FIXME close dotted polyline
        if _.points:
            p = position()
            h = heading()
            for i in _.points:
                position(i)
                __pen__(1)
                __checkhalt__()
            _.points = []
            __fillit__(filled)
            __pen__(0)
            position(p)
            heading(h)
        return
    if oldshape and "LineShape" in oldshape.ShapeType:
        shape = __draw__("PolyPolygonShape", False)
        shape.PolyPolygon = oldshape.PolyPolygon
        shape.setPosition(oldshape.getPosition())
        shape.LineStyle, shape.LineDash = __linestyle__(_.linestyle)
        shape.LineJoint = _.linejoint
        shape.LineCap = _.linecap
        shape.LineWidth = _.pensize / __MM10_TO_TWIP__
        shape.LineColor, shape.LineTransparence = __splitcolor__(_.pencolor)
        shape.FillColor, shape.FillTransparence = __splitcolor__(_.areacolor, shape)
        if _.hatch:
            shape.FillBackground = True if shape.FillTransparence != 100 else False
            shape.FillHatch = _.hatch
            shape.FillStyle = 3
        elif type(_.areacolor) != tuple:
            shape.FillStyle = int(filled)
        if shape.LineTransparence == 100:
            shape.LineStyle = 0
        if shape.FillTransparence == 100:
            shape.FillTransparence = 0 # for hatching and better modifications on UI 
            if not _.hatch:
                shape.FillStyle = 0
        shape.setString(oldshape.getString())
        oldshape.Name = ""
        shape.Name = __ACTUAL__
        _.shapecache[__ACTUAL__] = shape
        if __group__ != 0:
            __group__.remove(oldshape)
        __visible__(shape, True)
        _.drawpage.remove(oldshape)
    elif oldshape and "PolyPolygon" in oldshape.ShapeType:
        oldshape.LineStyle = int(_.pen)
        oldshape.LineJoint = _.linejoint
        oldshape.LineCap = _.linecap
        if _.hatch:
            oldshape.FillBackground = True
            oldshape.FillHatch = _.hatch
            oldshape.FillStyle = 3
        else:
            oldshape.FillStyle = int(filled)
        oldshape.LineWidth = _.pensize / __MM10_TO_TWIP__
        oldshape.LineColor, oldshape.LineTransparence = __splitcolor__(_.pencolor)
        oldshape.FillColor, oldshape.FillTransparence = __splitcolor__(_.areacolor, oldshape)

def point():
    oldpen, _.pen = _.pen, 1
    oldstyle, _.linestyle = _.linestyle, __LineStyle_DOTTED__
    __go__(__TURTLE__, 0, True)
    _.pen, _.linestyle = oldpen, oldstyle
    _.points.append(position())

def __boxshape__(shapetype, l):
    turtle = __getshape__(__TURTLE__)
    shape = __draw__(shapetype + "Shape")
    pos = turtle.getPosition()
    pos.X = pos.X - (l[0] * __PT_TO_TWIP__ / __MM10_TO_TWIP__ / 2) + turtle.BoundRect.Width / 2.0
    pos.Y = pos.Y - (l[1] * __PT_TO_TWIP__ / __MM10_TO_TWIP__ / 2) + turtle.BoundRect.Height / 2.0
    shape.setPosition(pos)
    shape.setSize(__Size__(l[0] * __PT_TO_TWIP__ / __MM10_TO_TWIP__, l[1] * __PT_TO_TWIP__ / __MM10_TO_TWIP__))
    shape.LineStyle, shape.LineDash = __linestyle__(_.linestyle)
    shape.LineWidth = _.pensize / __MM10_TO_TWIP__
    shape.LineJoint = _.linejoint
    shape.LineCap = _.linecap
    shape.LineColor, shape.LineTransparence = __splitcolor__(_.pencolor)
    shape.FillColor, shape.FillTransparence = __splitcolor__(_.areacolor, shape, turtle.RotateAngle)
    if _.hatch:
        shape.FillBackground = True if shape.FillTransparence != 100 else False
        shape.FillHatch = _.hatch
        shape.FillStyle = 3
    elif type(_.areacolor) != tuple:
        shape.FillStyle = 1
    if shape.LineTransparence == 100:
        shape.LineStyle = 0
    if shape.FillTransparence == 100:
        shape.FillTransparence = 0 # for hatching and better modifications on UI 
        if not _.hatch:
            shape.FillStyle = 0
    shape.RotateAngle = turtle.RotateAngle
    if shapetype == "Rectangle" and len(l) > 2:
        shape.CornerRadius = (l[2] * __PT_TO_TWIP__) / __MM10_TO_TWIP__
    elif shapetype == "Ellipse" and len(l) > 2:
        oldBoundRect = shape.BoundRect
        try:
            shape.CircleKind = __SECTION__
            shape.CircleStartAngle = (-l[3] - 270) * 100
            shape.CircleEndAngle = (-l[2] - 270) * 100
            shape.CircleKind = [__FULL__, __SECTION__, __CUT__, __ARC__][l[4]]
        except:
            pass
        pos.X = pos.X + shape.BoundRect.X - oldBoundRect.X
        pos.Y = pos.Y + shape.BoundRect.Y - oldBoundRect.Y
        shape.setPosition(pos)
    __visible__(shape, True)
    __removeshape__(__ACTUAL__)
    _.shapecache[__ACTUAL__] = shape
    __lefthang__(shape)

def ellipse(l):
    if type(l) != type([]): # default for circle and square
        l = [l, l]
    if _.linestyle == __LineStyle_DOTTED__:
        __groupstart__()
        _.linestyle = __LineStyle_SOLID__
        pc, _.pencolor = _.pencolor, 0xff000000
        ellipse(l)
        _.pencolor, _.linestyle = pc, __LineStyle_DOTTED__
        point()
        shape = __getshape__(__ACTUAL__)
        shape.PolyPolygon = tuple(__dots__(max(l[0], l[1]) * pi * __PT_TO_TWIP__, shape.PolyPolygon[0][0], 0, 0, [i/2.0 * __PT_TO_TWIP__ for i in l]))
        turtle = __getshape__(__TURTLE__)
        shape.RotateAngle = turtle.RotateAngle
        __groupend__()
    else:
        __boxshape__("Ellipse", l)

def rectangle(l):
    if type(l) != type([]): # default for circle and square
        l = [l, l]
    if _.linestyle == __LineStyle_DOTTED__:
        __groupstart__()
        _.linestyle = __LineStyle_SOLID__
        pc, _.pencolor = _.pencolor, 0xff000000
        rectangle(l)
        _.pencolor, _.linestyle = pc, __LineStyle_DOTTED__
        point()
        shape = __getshape__(__ACTUAL__)
        if type(l) != type([]):
            l = [l, l]
        if len(l) == 2:
            l = l + [0]
        l = [i * __PT_TO_TWIP__ for i in l]
        c = shape.PolyPolygon[0][0]
        k = [min(l[0] / 2.0, l[2]), min(l[1] / 2.0, l[2])]
        p = __dots__(l[0] - 2 * k[0], __Point__(c.X - l[0]/2 + k[0], c.Y - l[1]/2), l[0] - 2 * k[0], 0)
        p = p[:-1] + __dots__(l[1] - 2 * k[1], __Point__(c.X + l[0]/2, c.Y - l[1]/2 + k[1]), 0, l[1] - 2 * k[1]) 
        p = p[:-1] + __dots__(l[0] - 2 * k[0], __Point__(c.X + l[0]/2 - k[0], c.Y + l[1]/2), -l[0] + 2 * k[0], 0) 
        p = p[:-1] + __dots__(l[1] - 2 * k[1], __Point__(c.X - l[0]/2, c.Y + l[1]/2 - k[1]), 0, -l[1] + 2 * k[1]) 
        if l[2] > 0:
               p = p + __dots__(max(k) * 2 * pi, __Point__(c.X - l[0]/2 + k[0], c.Y - l[1]/2 + k[1]), 0, 0, k, 3)[1:]
               p = p + __dots__(max(k) * 2 * pi, __Point__(c.X + l[0]/2 - k[0], c.Y - l[1]/2 + k[1]), 0, 0, k, 2)[1:]
               p = p + __dots__(max(k) * 2 * pi, __Point__(c.X + l[0]/2 - k[0], c.Y + l[1]/2 - k[1]), 0, 0, k, 1)[1:]
               p = p + __dots__(max(k) * 2 * pi, __Point__(c.X - l[0]/2 + k[0], c.Y + l[1]/2 - k[1]), 0, 0, k, 4)[1:]
        shape.PolyPolygon = tuple(p)
        turtle = __getshape__(__TURTLE__)
        shape.RotateAngle = turtle.RotateAngle
        __groupend__()
    else:
        __boxshape__("Rectangle", l)

def label(st):
    if type(st) != type([]):
        st = [0, 0, st]
    # get text size 
    shape = _.doc.createInstance( "com.sun.star.drawing.TextShape")
    shape.TextAutoGrowWidth = True
    shape.Visible = False
    actual = __getshape__(__ACTUAL__)
    _.drawpage.add(shape)
    text(shape, st[2])
    z = shape.getSize()
    # show text using RectangleShape (for correct SVG export)
    ac, pc =  _.areacolor, _.pencolor
    _.areacolor, _.pencolor = 0xff000000, 0xff000000 # invisible
    rectangle([z.Width / (__PT_TO_TWIP__ / __MM10_TO_TWIP__), z.Height / (__PT_TO_TWIP__ / __MM10_TO_TWIP__)])
    _.drawpage.remove(shape)
    _.pencolor, _.areacolor = pc, ac
    lab = __getshape__(__ACTUAL__) 
    text(lab, st[2])
    if st[0] != 0 or st[1] != 0:
        pos = position()
        angle = heading()
        n = [st[0] * z.Width/2, st[1] * z.Height/2]
        dx = n[1] * sin((pi/180) * angle) + n[0] * sin((pi/180)*(angle + 90))
        dy = n[1] * cos((pi/180) * angle) + n[0] * cos((pi/180)*(angle + 90)) 
        lab.setPosition(__Point__(round(pos[0] * __PT_TO_TWIP__ / __MM10_TO_TWIP__ + dx - lab.BoundRect.Width/2), round(pos[1] * __PT_TO_TWIP__ / __MM10_TO_TWIP__ - dy - lab.BoundRect.Height/2)))
    _.shapecache[__ACTUAL__] = actual
    return z

def __get_HTML_format__(orig_st):
  "Process HTML-like tags, and return with text and formatting vector"
  st = orig_st.replace('&lt;', '\uE000')
  if not ('<' in st and '>' in st):
      return st.replace('\uE000', '<'), None, None

  # convert localized bold, and italic values to <B> and <I> tags
  for i in ('BOLD', 'ITALIC'):
      st = re.sub(r'(</?)(' + __l12n__(_.lng)[i] + r')>', r'\1%s>' % i[0], st, flags=re.I)

  for i in ('FONTCOLOR', 'FILLCOLOR', 'FONTFAMILY', 'FONTHEIGHT'):
      st = re.sub(r'<(' + __l12n__(_.lng)[i] + r')(  *[^<> ][^<>]*)>', r'<%s\2>' % i.lower(), st, flags=re.I)
      st = re.sub(r'</(' + __l12n__(_.lng)[i] + r')>', r'</%s>' % i.lower(), st, flags=re.I)

  # expand localized color names
  if _.lng not in __match_localized_colors__:
      __match_localized_colors__[_.lng] = re.compile(r'<(/?)(' + '|'.join(__colors__[_.lng].keys()) + ')>', re.IGNORECASE)
  # replacement lambda function: if it's an opening tag, return with the argument, too
  get_fontcolor_tag = lambda m: "<fontcolor %s>" % m.group(2) if len(m.group(1)) == 0 else "</fontcolor>"
  st = re.sub(__match_localized_colors__[_.lng], get_fontcolor_tag, st)

  # expand abbreviated forms of font features
  # <smcp>small caps</smcp> -> <fontfeature smcp>small caps</fontfeature smcp>
  st = re.sub(__match_fontfeatures__, r'\1fontfeature \2\3', st)

  tex = "" # characters without HTML tags
  pat = [] # bit vectors of the previous characters
  extra_pat = [] # extra data of the previous characters
  # 0th bit: bold
  # 1st bit: italic
  # 2nd bit: underline
  # 3rd bit: strikethrough
  # 4th bit: superscript
  # 5th bit: subscript
  # 6th bit: color
  # 7th bit: background color
  # 8th bit: font family
  # 9th bit: font feature (Graphite or OpenType)
  # 10th bit: font size
  f = 0
  # store embedding level of the same element to disable it
  # only at the most outer closing tag, e.g. <i>a <i>double</i> italic here, too</i>
  # bit_level = {0: 0, ...,  10: 0}
  bit_level = { i: 0 for i in range(11) }

  extra_data = {}
  i = 0
  while i < len(st):
      is_tag = False

      if st[i] == '<':
        for j in range(len(__match_tags__)):
          m = __match_tags__[j].match(st[i:])
          if m:
              tag = ""
              bit = j // 2
              if bit > 5:
                  tag = m.group(1).lower()
              # opening tag
              if j % 2 == 0:
                  f |= (1 << bit)
                  bit_level[bit] += 1
                  # extra data (color bit and over)
                  if bit > 5:
                      if tag in extra_data:
                          extra_data[tag] = extra_data[tag] + [m.group(2)]
                      else:
                          extra_data[tag] = [m.group(2)]
              else:
                  if bit_level[bit] > 0:
                      bit_level[bit] -= 1
                  if bit_level[bit] == 0:
                      f &= ~(1 << bit)
                  # extra data for font feature
                  # fontfeature has a special closing tag, remove that from the extra_data
                  # (allowing to use overlapping elements)
                  if bit > 5 and (tag in extra_data):
                      if bit == 9 and len(m.group(2)) > 0:
                          # create a new list to keep the extra data of the previous characters,
                          # and remove the last occurance of the feature
                          z = list(extra_data[tag])
                          for j in reversed(range(len(z))):
                              if z[j].startswith(m.group(2)):
                                  z.pop(j)
                                  extra_data[tag] = z
                                  break
                      # extra data
                      else:
                          extra_data[tag] = extra_data[tag][:-1]

              i += len(m.group(0)) - 1
              is_tag = True
              break

      if not is_tag:
          tex = tex + st[i]
          pat.append(f)
          extra_pat.append(dict(extra_data))
      i += 1

  # no tags
  if len(st) == len(tex):
      pat = None
      extra_pat = None

  return tex.replace('\uE000', '<'), pat, extra_pat

def text(shape, orig_st):
    if shape:
        _.doc.lockControllers()
        # analyse HTML
        st, formatting, extra_data = __get_HTML_format__(orig_st)
        shape.setString(__string__(st, _.decimal))
        c = shape.createTextCursor()
        c.gotoStart(False)
        c.gotoEnd(True)
        c.CharColor, c.CharTransparence = __splitcolor__(_.textcolor)
        c.CharHeight = _.fontheight
        c.CharWeight = __fontweight__(_.fontweight)
        c.CharPosture = __fontstyle__(_.fontstyle)
        c.CharFontName = _.fontfamily

        # has HTML-like formatting
        if formatting != None:
            _.fixSVG = True
            prev_format = 0
            prev_extra_data = extra_data[0]
            c.collapseToStart()
            n = 0 # length of the previous text span
            formatting.append(0) # add terminating 0 to process last span
            for i in formatting:
                if i != prev_format or (len(extra_data) > 0 and extra_data[0] != prev_extra_data):
                    do_formatting = prev_format != 0
                    c.goRight(n, do_formatting) # move cursor with optional selection
                    if do_formatting:
                        if prev_format & (1 << 0):
                            c.CharWeight = 150
                        if prev_format & (1 << 1):
                            c.CharPosture = __Slant_ITALIC__
                        if prev_format & (1 << 2):
                            c.CharUnderline = __Underline_SINGLE__
                        if prev_format & (1 << 3):
                            c.CharStrikeout = __Strikeout_SINGLE__
                        if prev_format & (1 << 4):
                            c.CharEscapement = 14000 # magic number for default superscript, see DFLT_ESC_AUTO_SUPER
                            c.CharEscapementHeight = 58
                        if prev_format & (1 << 5):
                            c.CharEscapement = -14000 # magic number for default subscript, see DFLT_ESC_AUTO_SUB
                            c.CharEscapementHeight = 58
                        if prev_format & (1 << 6):
                            c.CharColor, c.CharTransparence = __splitcolor__(__color__(prev_extra_data['fontcolor'][-1]))
                        if prev_format & (1 << 7):
                            c.CharBackColor = __color__(prev_extra_data['fillcolor'][-1])
                        if prev_format & (1 << 8):
                            c.CharFontName = prev_extra_data['fontfamily'][-1]
                        if prev_format & (1 << 9):
                            # font features uses the following syntax: font_name:feat1&feat2&feat3=value&etc.
                            if ":" in c.CharFontName:
                                c.CharFontName = c.CharFontName + "&" + "&".join(prev_extra_data['fontfeature'])
                            else:
                                c.CharFontName = c.CharFontName + ":" + "&".join(prev_extra_data['fontfeature'])
                        if prev_format & (1 << 10):
                            c.CharHeight = prev_extra_data['fontheight'][-1]

                    c.collapseToEnd()
                    n = 0
                n += 1
                prev_format = i
                if len(extra_data) > 0:
                    prev_extra_data = extra_data.pop(0)
        _.doc.unlockControllers()

def sleep(t):
    # lock shape repaint, if SLEEP argument is negative
    if t < 0:
        _.doc.lockControllers()
        # hide turtle during locking
        turtle = __getshape__(__TURTLE__)
        if turtle and turtle.Visible:
            hideturtle()
            _.lockturtle = True
        return
    else:
        # otherwise unlock one level
        __unlock__(all_levels = False)
    _.time = _.time + t
    __removeshape__(__ACTUAL__)
    for i in range(int(t/__SLEEP_SLICE_IN_MILLISECONDS__)):
        __checkhalt__()
        __time__.sleep(0.5)
    __checkhalt__()
    __time__.sleep(t%__SLEEP_SLICE_IN_MILLISECONDS__/1000.0)

def __removeshape__(shapename):
    try:
        _.shapecache.pop(shapename).Name = ""
    except:
        pass

def __fontweight__(w):
    if type(w) == int:
        return w
    elif re.match(__l12n__(_.lng)['BOLD'], w, flags = re.I):
        return 150
    elif re.match(__l12n__(_.lng)['NORMAL'], w, flags = re.I):
        return 100
    return 100

def __fontstyle__(w):
    if type(w) == int:
        return w
    elif re.match(__l12n__(_.lng)['ITALIC'], w, flags = re.I):
        return __Slant_ITALIC__
    elif re.match(__l12n__(_.lng)['UPRIGHT'], w, flags = re.I):
        return __Slant_NONE__
    return __Slant_NONE__

def __color__(c):
    if type(c) in [int, float]:
        return c
    if type(c) == str:
        if c == u'any':
            rc, rv, rgray = __NORMCOLORS__[int(random.random()*7)], random.random(), random.random() ** 0.5
            ratio = 1.0*abs(rc[2])/(abs(rc[2]) + abs(rc[4]))
            newcol = list(rc[0])
            if rv < ratio:
                newcol[rc[1]] += rc[2] * rv/ratio
            else:
                newcol[rc[3]] += rc[4] * (rv - ratio)/(1 - ratio)
            # random grayness
            rdark = 1 - 2**4 * (random.random()-0.5)**4
            for i in range(0, 3):
                newcol[i] = 255 * (rgray + (newcol[i]/255.0 - rgray) * rdark)
            return __color__(newcol)
        elif c[0:1] == '~':
            c = __componentcolor__(__colors__[_.lng][c[1:].lower()])
            for i in range(3):
                c[i] = max(min(c[i] + int(random.random() * 64) - 32, 255), 0)
            return __color__(c)
        elif c[0].isdigit():
            return int(c, 0) # recognize hex and decimal numbers as strings
        return __colors__[_.lng][c.lower()]
    if type(c) == list:
        if len(c) == 1: # color index
            return __COLORS__[int(c[0])][1]
        elif len(c) == 3: # RGB
            return (int(c[0])%256 << 16) + (int(c[1])%256 << 8) + int(c[2])%256
        elif len(c) == 2 or len(c) > 4: # gradient
           return (__color__(c[0]), __color__(c[1])) + tuple(c[2:])
    return (int(c[3])%256 << 24) + (int(c[0])%256 << 16) + (int(c[1])%256 << 8) + int(c[2])%256 # RGB + alpha

def __linestyle__(s):
    if _.pen == 0:
        return 0, __LineDash__()
    if _.linestyle == __LineStyle_DASHED__:
        return _.linestyle, __LineDash__(__DashStyle_RECT__, 0, 0, 1, 100, 100)
    elif _.linestyle == __LineStyle_DOTTED__:
        return __LineStyle_DASHED__, __LineDash__(__DashStyle_RECT__, 1, 1, 0, 0, 100000)
    elif type(s) == list:
        return __LineStyle_DASHED__, __LineDash__((s[5:6] or [0])[0], s[0], s[1] * __PT_TO_TWIP__, s[2], s[3] * __PT_TO_TWIP__, s[4] * __PT_TO_TWIP__)
    return s, __LineDash__()

def fillstyle(s):
    if type(s) == list:
        color, null = __splitcolor__(__color__(s[1]))
        _.hatch = __Hatch__(s[0] - 1, color, s[2] * __PT_TO_TWIP__, s[3] * 10)
    elif s == 0:
        _.hatch = None
    elif s <= 10: # using hatching styles of Writer
        fillstyle([[1, 0, 5, 0], [1, 0, 5, 45], [1, 0, 5, -45], [1, 0, 5, 90], [2, [127, 0, 0], 5, 45], [2, [127, 0, 0], 5, 0], [2, [0, 0, 127], 5, 45], [2, [0, 0, 127], 5, 0], [3, [0, 0, 127], 5, 0], [1, 0, 25, 45]][s-1])

def __splitcolor__(c, shape = None, angle = None):
    if shape and (type(c) == tuple or type(_.t10y) == list):
        angle = heading() if angle == None else -angle / 100 + 360
        if type(c) == tuple:
            shape.FillStyle = __FillStyle_GRADIENT__
            # gradient color: [color1, color2, style, angle(must be positive for I/O), border, x_percent, y_percent, color1_intensity_percent, color2_intensity_percent]
            d, d[0:len(c)], c = [0, 0, __GradientStyle_LINEAR__, 0, 0, 0, 0, 100, 100], c, c[0]
            shape.FillGradient = __Gradient__(d[2], d[0], d[1], (-angle + d[3]) * 10 % 3600, d[4], d[5], d[6], d[7], d[8], 0)
        if type(_.t10y) == list: # transparency gradient: [begin_percent, end_percent, style, angle, border, x_percent, y_percent]
            table = _.doc.createInstance("com.sun.star.drawing.TransparencyGradientTable")
            if not table.hasByName(str(_.t10y) + str(angle)):
                t, t[0:len(_.t10y)] = [100, __GradientStyle_LINEAR__, 0, 0, 0, 0, 0], _.t10y
                table.insertByName(str(_.t10y) + str(angle), __Gradient__(t[2], t[0] * 0xffffff / 100.0, t[1] * 0xffffff / 100.0, (-angle + t[3]) * 10 % 3600, t[4], t[5], t[6], 100, 100, 0))
            shape.FillTransparenceGradientName = str(_.t10y) + str(angle)
            c = 0 if type(c) == tuple else c & 0xffffff
        else:
            shape.FillStyle = __FillStyle_GRADIENT__
            c = int(_.t10y * 255.0/100) << 24
    """Split color constants to RGB (3-byte) + transparency (%)"""
    return int(c) & 0xffffff, (int(c) >> 24) / (255.0/100)

def __componentcolor__(c):
    a = [ (c & 0xff0000) >> 16, (c & 0xff00) >> 8, c & 0xff ]
    if c > 2**24:
        a.append((c & 0xff000000) >> 24)
    return a

def pencolor(n = -1):
    if n != -1:
        _.pencolor = __color__(n)
        turtle = __getshape__(__TURTLE__)
        if turtle and __visible__(turtle):
            turtle.LineColor, turtle.LineTransparence = __splitcolor__(_.pencolor)
    else:
        return __componentcolor__(_.pencolor)

def pensize(n = -1):
    if n != -1:
        if n == 'any':
            _.pensize = random.random() * 10 * __PT_TO_TWIP__
        else:
            _.pensize = n * __PT_TO_TWIP__
        turtle = __getshape__(__TURTLE__)
        if turtle and __visible__(turtle):
            turtle.LineWidth = min(_.pensize, (1 + _.pen * 2) * __PT_TO_TWIP__) / __MM10_TO_TWIP__
    return _.pensize / __PT_TO_TWIP__

def penstyle(n = -1):
    if n == -1:
        try:
            return __locname__(_.linestyle.value)
        except:
            return __locname__('DOTTED')
    if type(n) == list and len(n) >= 5:
        _.linestyle = n
    elif re.match(__l12n__(_.lng)['SOLID'], n, flags = re.I):
        _.linestyle = __LineStyle_SOLID__
    elif re.match(__l12n__(_.lng)['DASH'], n, flags = re.I):
        _.linestyle = __LineStyle_DASHED__
    elif re.match(__l12n__(_.lng)['DOTTED'], n, flags = re.I):
        _.linestyle = __LineStyle_DOTTED__

def penjoint(n = -1):
    if n == -1:
        return __locname__(_.linejoint.value)
    if re.match(__l12n__(_.lng)['NONE'], n, flags = re.I):
        _.linejoint = __Joint_NONE__
    elif re.match(__l12n__(_.lng)['BEVEL'], n, flags = re.I):
        _.linejoint = __BEVEL__
    elif re.match(__l12n__(_.lng)['MITER'], n, flags = re.I):
        _.linejoint = __MITER__
    elif re.match(__l12n__(_.lng)['ROUNDED'], n, flags = re.I):
        _.linejoint = __ROUNDED__

def pencap(n = -1):
    if n == -1:
        return __locname__(_.linecap.value.replace('BUTT', 'NONE'))
    if re.match(__l12n__(_.lng)['NONE'], n, flags = re.I):
        _.linecap = __Cap_NONE__
    elif re.match(__l12n__(_.lng)['ROUNDED'], n, flags = re.I):
        _.linecap = __Cap_ROUND__
    elif re.match(__l12n__(_.lng)['SQUARE'], n, flags = re.I):
        _.linecap = __Cap_SQUARE__

def fillcolor(n = -1):
    if n != -1:
        _.areacolor = __color__(n)
        if type(_.areacolor) != tuple:
            _.t10y = (int(_.areacolor) >> 24) / (255.0/100)
        else:
            _.t10y = 0
        turtle = __getshape__(__TURTLE__)
        if turtle and __visible__(turtle):
            turtle.FillColor, transparence = __splitcolor__(_.areacolor, turtle)
            turtle.FillTransparence = min(95, transparence)
    else:
        return __componentcolor__(_.areacolor)

def filltransparency(n = -1):
    if n != -1:
        if n == u'any':
            n = 100 * random.random()
        if type(n) != list:
            if type(_.areacolor) != tuple:
                fillcolor((_.areacolor & 0xffffff) + (int(n * (255.0/100)) << 24))
            else:
                _.t10y = n
        else:
            _.t10y = n
    else:
        return _.t10y

def pentransparency(n = -1):
    if n != -1:
        if n == u'any':
            n = 100 * random.random()
        pencolor((_.pencolor & 0xffffff) + (int(n * (255.0/100)) << 24))
    else:
        return _.pencolor >> 24

def fontcolor(n = -1):
    if n != -1:
        _.textcolor = __color__(n)
    else:
        return __componentcolor__(_.textcolor)

def fonttransparency(n = -1):
    if n != -1:
        if n == u'any':
            n = 100 * random.random()
        fontcolor((_.textcolor & 0xffffff) + (int(n * (255.0/100)) << 24))
    else:
        return _.textcolor >> 24

def position(n = -1):
    turtle = __getshape__(__TURTLE__)
    if turtle:
        if n != -1:
            if n == 'any':
                ps = pagesize()
                heading([random.random() * ps[0], random.random() * ps[1]], True)
            else:
                heading(n, True)
        else:
            pos = turtle.getPosition()
            pos.X, pos.Y = pos.X + turtle.BoundRect.Width / 2.0, pos.Y + turtle.BoundRect.Height / 2.0
            return [ pos.X * __MM10_TO_TWIP__ / __PT_TO_TWIP__, pos.Y * __MM10_TO_TWIP__ / __PT_TO_TWIP__ ]

def __groupstart__(name = ""):
    global __group__, __grouplefthang__, __groupstack__
    __removeshape__(__ACTUAL__)
    __groupstack__.append(__group__)
    if name != "": # store pic name (for correct repcount)
      __groupstack__.append(name)
      if ".SVG" == name[-4:].upper():
          _.time = 0
          _.shapecount = itertools.count()
    __groupstack__.append(__grouplefthang__)
    __group__ = uno.getComponentContext().ServiceManager.createInstance('com.sun.star.drawing.ShapeCollection')
    __grouplefthang__ = 0

def create_svg_animation(m):
    global _
    id = int(m.group(1))
    if id - 3 in _.shapecache:
        t = _.shapecache[id-3]
        opacity = "100" if t == "0" else "0"
        name = "" if id != 3 else "id=\"first\""
        start = "%sms;last.end+%sms" % (t, t) if id == 3 else "first.end+%dms" % (int(t) - int(_.shapecache[0]))
        return '<g id="id%s" opacity="0"><animate %s attributeName="opacity" from="100" to="100" begin="%s" dur="1ms" fill="freeze"/><animate attributeName="opacity" from="100" to="%s" begin="last.end" dur="1ms" fill="freeze"/>' % (m.group(1), name, start, opacity)
    return m.group()

def create_valid_svg_file(filename):
    with open(filename, "r") as f:
        s = f.read()
    s = re.sub(r'(?s)(<g\sid="[^"]*)\(([^"]*)\)', '\\1\\2', s) # bad "(", ")" in xml:id
    s = re.sub('(?s)<g\\sooo:[^>]*>', '', s) # remove non standard attributes
    s = re.sub('(?s)<defs class="EmbeddedBulletChars">.*(?=<defs class="TextEmbeddedBitmaps")', '', s) # remove unused parts
    s = re.sub('(?s)(<path stroke-width="[^"]*"[^<]*)stroke-width="[^"]*"', '\\1', s) # double stroke-width
    s = re.sub('(?s)<svg\\s+version="1.2"', '<svg version="1.1"', s) # for W3C Validator
    if _.time > 0:
        s = re.sub('<g id="id([0-9]+)">', create_svg_animation, s)
        m = re.match('(?s)(.*<animate[^>]*first[.]end.([0-9]+)[^>]* dur=")1ms"', s)
        lasttime = _.time - int(m.group(2)) - int(_.shapecache[0]) + 1
        if lasttime > 1:
            s = re.sub('(?s)(.*<animate[^>]*first[.]end.([0-9]+)[^>]* dur=")1ms"', m.group(1) + str(lasttime) + 'ms" id="last"',  s)
    with open(filename, 'w') as f:
        f.write(s)

def __groupend__(name = ""):
    global __group__, __grouplefthang__, __groupstack__, __halt__
    g = 0
    if __group__.getCount() > 1:
        if __grouplefthang__ < 0:
            for i in range(__group__.Count):
                s = __group__.getByIndex(i)
                p = s.getPosition()
                p.X = p.X + -__grouplefthang__
                s.setPosition(p)
            g = _.drawpage.group(__group__)
            p = g.getPosition()
            p.X = p.X + __grouplefthang__
            g.setPosition(p)
        else:
            g = _.drawpage.group(__group__)
        g.TextWrap = __THROUGH__
    elif __group__.getCount() == 1:
        g = __group__.getByIndex(0)
    __grouplefthang__ = min(__groupstack__.pop(), __grouplefthang__)
    if name != "":
      name = __groupstack__.pop()
    if name and ".SVG" == name[-4:].upper() and g != 0:
      _.doc.CurrentController.select(g)
      __dispatcher__(".uno:Copy")
      ctx = XSCRIPTCONTEXT.getComponentContext()
      d = ctx.ServiceManager.createInstanceWithContext("com.sun.star.frame.Desktop", ctx)
      draw = d.loadComponentFromURL("private:factory/sdraw", "_blank", 0, ())
      drawpage = draw.getDrawPages().getByIndex(0)
      while XSCRIPTCONTEXT.getDocument() != draw:
        if XSCRIPTCONTEXT.getDocument() not in [draw, _.doc, None]:
          __halt__ = True
          return
        __time__.sleep(0.1)
      __dispatcher__(".uno:Paste", (), draw)
      __dispatcher__(".uno:FormatGroup", (), draw)
      # fix bad or non-portable SVG export by converting text to curve
      if _.fixSVG:
          __dispatcher__(".uno:ChangeBezier", (), draw)
      pic = drawpage.getByIndex(0)
      pic.setPosition(__Point__((g.BoundRect.Width - g.Size.Width)//2, (g.BoundRect.Height - g.Size.Height)//2))
      drawpage.Height, drawpage.Width = g.BoundRect.Height, g.BoundRect.Width
      if not os.path.isabs(name):
        name = os.getcwd() + os.path.sep + name
      __dispatcher__(".uno:ExportTo", (__getprop__("URL", unohelper.systemPathToFileUrl(name)), __getprop__("FilterName", "draw_svg_Export")), draw)
      draw.close(True)
      while XSCRIPTCONTEXT.getDocument() != _.doc:
        if XSCRIPTCONTEXT.getDocument() not in [draw, _.doc, None]:
          __halt__ = True
          return
        __time__.sleep(0.1)
      create_valid_svg_file(name)
    __group__ = __groupstack__.pop()
    if __group__ != 0 and g != 0:
        __group__.add(g)
    __removeshape__(__ACTUAL__)

def __int__(x): # handle eg. int("10cm")
    if type(x) == str:
        x = __float__(x)
    return int(x)

def __float__(x): # handle eg. float("10,5cm")
    if type(x) == str:
        for i in __comp__[_.lng]:
            x = re.sub(u"(?iu)" + i[0], i[1], x)
        x = eval(x)
    return float(x)

def fontheight(n = -1):
    if n != -1:
        _.fontheight = n
    else:
        return _.fontheight

def fontweight(n = -1):
    if n != -1:
        _.fontweight = n
    else:
        return _.fontweight

def fontfamily(s = -1):
    if s != -1:
        _.fontfamily = s
        if ':' in s:
            _.fixSVG = True
    else:
        return _.fontfamily

def fontstyle(n = -1):
    if n != -1:
        _.fontstyle = n
    else:
        return _.fontstyle

def __loadlang__(lang, a):
    global comp, __colors__
    __colors__[lang] = {}
    for i in __COLORS__:
        for j in a[i[0]].split("|"):
            __colors__[lang][j.lower()] = i[1]
    for i in a:
        if not i[0:3] in ["LIB", "ERR", "PT", "INC", "MM", "CM", "HOU", "DEG"] and not i in __STRCONST__: # uppercase native commands
            a[i] = a[i].upper()
    repcount = a['REPCOUNT'].split('|')[0]
    loopi = itertools.count()
    loop = lambda r: "%(i)s = 1\n%(orig)s%(j)s = %(i)s\n%(i)s += 1\n" % \
        { "i": repcount + str(next(loopi)), "j": repcount, "orig": re.sub( r"(?ui)(?<!:)\b%s\b" % repcount, repcount + str(next(loopi)-1), r.group(0)) }
    __comp__[lang] = [
    [r"(?i)(?<!:)(\b|(?=[-:]))(?:%s)\b" % "|".join([a[i].lower() for i in a if not "_" in i and i != "DECIMAL"]), lambda s: s.group().upper()], # uppercase all native commands in the source code
    [r"(?<!:)\b(?:%s) \[(?= |\n)" % a['GROUP'], "\n__groupstart__()\nfor __groupindex__ in range(2):\n[\nif __groupindex__ == 1:\n[\n__groupend__()\nbreak\n]\n"],
    [r"(?<!:)\b(?:%s) (%s[^[]*)\[(?= |\n)" % (a['GROUP'], __DECODE_STRING_REGEX__), "\n__groupstart__(\\1)\nfor __groupindex__ in range(2):\n[\nif __groupindex__ == 1:\n[\n__groupend__(\\1)\nbreak\n]\n"],
    [r"(?<!:)\b(?:%s)\b" % a['GROUP'], "\n__removeshape__(__ACTUAL__)\n"],
    [r"(\n| )][ \n]*\[(\n| )", "\n]\nelse:\n[\n"], # if/else block
    [r"(?<!\n)\[(?= |\n)", ":\n[\n"], # start block
    [r"( ]|\n]$)", "\n]\n"], # finish block
    [r"(?<!:)\b(?:%s)\b" % a['FOR'], "\nfor"],
    [r"(?<!:)\b(?:%s)\b" % a['REPEAT'], "\n__repeat__"],
    [r"(?<!:)\b(?:%s)\b" % a['BREAK'], "\nbreak"],
    [r"(?<!:)\b(?:%s)\b" % a['CONTINUE'], "\ncontinue"],
    [r"(?<!:)\b(?:%s)\b" % a['REPCOUNT'], repcount],
    [r"(?<!:)\b(?:%s)\b" % a['IF'], "\nif"],
    [r"(?<!:)\b(?:%s)\b" % a['WHILE'], "\nwhile"],
    [r"(?<!:)\b(?:%s)\b" % a['OUTPUT'], "\nreturn"],
    [r"\n(if|while|return) [^\n]*", lambda r: re.sub("(?<![=!<>])=(?!=)", "==", r.group(0))], # = -> ==, XXX x = y = 1?
    [r"(?<=\n)(for\b :?\w+) ([^\n]+)(?<=\w|]|}|\))(?=-|:)(?:%s)\b" % a['IN'], "\\1 in \\2"], # "for x y-in" -> "for x in y"
    [r"(:?\b\w+|[\[][^[\n]*])\b(?:%s)\b" % a['IN'], "in \\1"], # "x y-in" -> "x in y"
    [r"(?<!:)\b(?:%s)\b" % a['IN'], "in"],
    [r"(?<!:)\b(?:%s)\b[ \t]+(:?\w+)\b(?! in\b)" % a['FOR'], "\nfor \\1 in"],
    [r"(?<=\n)__repeat__ :\n", "while True:\n"], # infinite loop
    [r"(?<=\n)(for|while) (?!__groupindex__)[^\n]*:\n\[\n", loop], # loop variables for repcount (not groupindex loop)
    [r"(?<=\n)__repeat__([^\n]*\w[^\n]*):(?=\n)", "for %s in range(1, 1+int(\\1)):" % repcount], # repeat block
    [r"(?<=\d)[%s](?=\d)" % a['DECIMAL'], "."], # decimal sign
    [r"(?<!/)/(?!/)", "*1.0/"], # fix division: /1 -> /1.0, but not with //
    [r"\b([0-9]+([,.][0-9]+)?)(%s)\b" % a['HOUR'], lambda r: str(float(r.group(1).replace(",", "."))*30)], # 12h = 12*30°
    [r"(?<=\d)(%s)" % a['DEG'], ""], # 1° -> 1
    [r"(?<!:)\b(?:__def__)[ \t]+(\w+)\b[ \t]*([:]?\w[^\n]*)", "\ndef \\1(\\2):\n["],
    [r"(?<!:)\b(?:__def__)\s+(\w+)", "\ndef \\1():\n["],
    [r"(?<!:)\b(?:%s)\b" % a['END'], "\n]"],
    [r"(?<!:)\b(?:%s)\b" % a['GLOBAL'], "global"],
    [r"(?<!:)\b(?:%s)\b" % a['TRUE'], "True"],
    [r"(?<!:)\b(?:%s)\b" % a['FALSE'], "False"],
    [r"(?<!:)\b(?:%s)\b" % a['NOT'], "not"],
    [r"(?<!:)\b(?:%s)\b" % a['AND'], "and"],
    [r"(?<!:)\b(?:%s)\b" % a['OR'], "or"],
    [r"(?<!:)\b(?:%s)\b" % a['INT'], "__int__"],
    [r"(?<!:)\b(?:%s)\b" % a['FLOAT'], "__float__"],
    [r"(?<!:)\b(?:%s)\b" % a['STR'], "__string__"],
    [r"(?<!:)\b(?:%s)\b" % a['COUNT'], "len"],
    [r"(?<!:)\b(?:%s)\b" % a['ROUND'], "round"],
    [r"(?<!:)\b(?:%s)\b" % a['ABS'], "abs"],
    [r"(?<!:)\b(?:%s)\b" % a['SIN'], "sin"],
    [r"(?<!:)\b(?:%s)\b" % a['COS'], "cos"],
    [r"(?<!:)\b(?:%s)\b" % a['PI'], "pi"],
    [r"(?<!:)\b(?:%s)\b" % a['SQRT'], "sqrt"],
    [r"(?<!:)\b(?:%s)\b" % a['LOG10'], "log10"],
    [r"(?<!:)\b(?:%s)\b" % a['MIN'], "min"],
    [r"(?<!:)\b(?:%s)\b" % a['MAX'], "max"],
    [r"(?<!:)\b(?:%s)\b" % a['STOP'], "\nreturn None"],
    [r"(?<!:)\b(?:%s)\b" % a['CLEARSCREEN'], "\n__cs__()"],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['PENCOLOR'], "\n)pencolor("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['PENSTYLE'], "\n)penstyle("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['PENJOINT'], "\n)penjoint("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['PENCAP'], "\n)pencap("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['FILLCOLOR'], "\n)fillcolor("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['FILLTRANSPARENCY'], "\n)filltransparency("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['PENTRANSPARENCY'], "\n)pentransparency("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['FILLSTYLE'], "\n)fillstyle("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['FONTCOLOR'], "\n)fontcolor("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['FONTTRANSPARENCY'], "\n)fonttransparency("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['FONTFAMILY'], "\n)fontfamily("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['FONTHEIGHT'], "\n)fontheight("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['FONTWEIGHT'], "\n)fontweight("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['FONTSTYLE'], "\n)fontstyle("],
    [r"(?<!:)\b(?:%s)(\s+|$)" % a['PENWIDTH'], "\n)pensize("],
    [r"(?<!:)\b(?:%s)\b" % a['PENDOWN'], "\n__pen__(1)"],
    [r"(?<!:)\b(?:%s)\b" % a['PENUP'], "\n__pen__(0)"],
    [r"(?<!:)\b(?:%s)\b" % a['HIDETURTLE'], "\nhideturtle()"],
    [r"(?<!:)\b(?:%s)\b" % a['SHOWTURTLE'], "\nshowturtle()"],
    [r"(?<!:)\b(?:%s)\b\[" % a['POSITION'], "position()["],
    [r"(?<!:)\b(?:%s)\b(?!\()" % a['POSITION'], "\n)position("],
    [r"(?<!:)\b(?:%s)\b" % a['HEADING'], "\n)heading("],
    [r"(?<!:)\b(?:%s)\b" % a['PAGESIZE'], "pagesize()"],
    [r"(?<!:)\b(?:%s)\b" % a['POINT'], "\npoint()"],
    [r"(?<!:)\b(?:%s)\b" % (a['ELLIPSE'] + "|" + a['CIRCLE']), "\n)ellipse("],
    [r"(?<!:)\b(?:%s)\b" % (a['RECTANGLE'] + "|" + a['SQUARE']), "\n)rectangle("],
    [r"(?<!:)\b(?:%s)\b" % a['CLOSE'], "\n__fillit__(False)"],
    [r"(?<!:)\b(?:%s)\b" % a['FILL'], "\n__fillit__()"],
    [r"(?<!:)\b(?:%s)\b" % a['LABEL'], "\n)label("],
    [r"(?<!:)\b(?:%s)\b" % a['TEXT'], "\n)text(__getshape__(__ACTUAL__),"],
    [r"(text\([ \t]*\"[^\"\n\)]*)", "\\1\"\n"],
    [r"(?<!:)\b(?:%s)\b" % a['HOME'], "\nturtlehome()"],
    [r"(?<!:)\b(?:%s)\b" % a['SLEEP'], "\n)sleep("],
    [r"(?<!:)\b(?:%s)\b" % a['FORWARD'], "\n)forward("],
    [r"(?<!:)\b(?:%s)\b" % a['BACKWARD'], "\n)backward("],
    [r"(?<!:)\b(?:%s)\b" % a['TURNRIGHT'], "\n)turnright("],
    [r"(?<!:)\b(?:%s)\b" % a['RANDOM'], "Random"],
    [r"(?<!:)\b(?:%s)\b" % a['SET'], "set"],
    [r"(?<!:)\b(?:%s)\b" % a['RANGE'], "range"],
    [r"(?<!:)\b(?:%s)\b" % a['LIST'], "list"],
    [r"(?<!:)\b(?:%s)\b" % a['TUPLE'], "tuple"],
    [r"(?<!:)\b(?:%s)\b" % a['SORTED'], "sorted"],
    [r"(?<!:)\b(?:%s)\b ?\(" % a['RESEARCH'], "re.search('(?u)'+"],
    [r"(?<!:)\b(?:%s)\b ?\(" % a['RESUB'], "re.sub('(?u)'+"],
    [r"(?<!:)\b(?:%s)\b ?\(" % a['REFINDALL'], "re.findall('(?u)'+"],
    [r"(?<!:)\b(?:%s)\b" % a['ANY'], "u'any'"],
    [r"(?<!:)\b(?:%s) (\w+|[\[][^\]]*])\b" % a['INPUT'], " Input(\\1)"],
    [r"(?<!:)\b(?:%s)\b" % a['PRINT'], "\nPrint"],
    [r"(?<!:)\b(?:%s)\b" % a['TURNLEFT'], "\n)turnleft("],
    [r"\b([0-9]+([,.][0-9]+)?)(%s)\b" % a['PT'], "\\1"],
    [r"\b([0-9]+([,.][0-9]+)?)(%s)(?!\w)" % a['INCH'], lambda r: str(float(r.group(1).replace(",", "."))*72)],
    [r"\b([0-9]+([,.][0-9]+)?)(%s)\b" % a['MM'], lambda r: str(float(r.group(1).replace(",", "."))*__MM_TO_PT__)],
    [r"\b([0-9]+([,.][0-9]+)?)(%s)\b" % a['CM'], lambda r: str(float(r.group(1).replace(",", "."))*__MM_TO_PT__*10)],
    [r"(?<=[-*/=+,]) ?\n\)(\w+)\(", "\\1()"], # read attributes, eg. x = fillcolor
    [r"(?<=return) ?\n\)(\w+)\(", "\\1()"], # return + user function
    ]

def __concatenation__(r): # keep line positions with extra line breaks
    s = re.subn("~[ \t]*\n", " ", r.group(0))
    return s[0] + "\n" * s[1]

# convert Logo expressions to Python ones by adding
# missing parentheses to procedure and function calls
# f x y z -> f(x, y, z)
# a = [sin len f [cos 45, 6] [1, 2, 3] sin 90] ->
# a = [sin(len(f([cos(45),6],[1, 2, 3], sin(90))]
# NOTE: "f(45)" and "f (45)" are not the same:
# sin(45) + cos 45 -> sin(45) + cos(45)
# sin (45) + cos 45 -> sin(45 + cos(45))
def __l2p__(i, par, insub, inarray):
    first = True
    while par["pos"] < len(i):
        pos = par["pos"]
        ch = i[pos]
        ignored = False
        # starting parenthesis
        if ch in "([":
            if insub and not inarray and not first and par["out"][-1:] != "]":
                return
            par["out"] += ch
            par["pos"] += 1
            __l2p__(i, par, insub, True)
        # ending parenthesis
        elif ch in ")]":
            if insub and not inarray:
                return
            # put character before terminating spaces
            par["out"] = re.sub("( *)$", ch + "\\1", par["out"])
            par["pos"] += 1
            return
        # starting a subroutine
        elif pos in par["sub"]:
            if insub and not inarray and not first:
                return
            first = False
            subname = i[pos:par["sub"][pos]]
            par["pos"] += len(subname)
            par["out"] += subname
            # Logo syntax: add parentheses
            # for example: foo x y z -> foo(x, y, z)
            par["out"] += "("
            for j in range(par["names"][subname]):
                # add commas, except if already added, eg. with special RANGE
                # (variable argument counts: RANGE 1 or RANGE 1 100 or RANGE 1 100 10)
                if j > 0 and par["out"].rstrip()[-1] != ",":
                    par["out"] = re.sub("( +),$",",\\1", par["out"] + ",")
                __l2p__(i, par, True, False)
            par["out"] = re.sub("( +)\\)$", ")\\1", par["out"] + ")")
        # operators
        elif pos in par["op"]:
            op = i[pos:par["op"][pos]]
            par["out"] += op
            par["pos"] += len(op)
            __l2p__(i, par, insub, False)
        # other atoms
        elif pos in par["atom"]:
            if insub and not inarray and not first:
                return
            first = False
            atom = i[pos:par["atom"][pos]]
            par["out"] += atom
            par["pos"] += len(atom)
            # handle subroutines with explicit parentheses
            # and array indices
            if i[par["pos"]:par["pos"]+1] in "([":
                first = True
                continue
        # optional negative or positive sign
        elif ch in "-+":
            if insub and not inarray and not first:
                return
            par["out"] += ch
            par["pos"] += 1
            ignored = first
        elif ch == " ":
            par["out"] += ch
            par["pos"] += 1
            ignored = first
        elif insub and ((ch == ","  and not inarray) or (ch != ",")):
            return
        else:
            par["out"] += ch
            par["pos"] += 1
        # end of first subexpression, except in the case of ignored characters
        if not ignored:
            first = False

def __compil__(s):
    global _, comp, __strings__, __compiled__
    try:
        c = _.doc.CurrentController.getViewCursor()
        locs = [i for i in [c.CharLocale, c.CharLocaleAsian, c.CharLocaleComplex] if i.Language != 'zxx'] # not None language
        loc = Locale(__uilocale__.split('-')[0], __uilocale__.split('-')[1], '')
        if locs and loc not in locs:
            loc = locs[0]
        try:
            _.lng = loc.Language + '_' + loc.Country
            __loadlang__(_.lng, __l12n__(_.lng))
        except:
            __trace__()
            _.lng = loc.Language 
            __loadlang__(_.lng, __l12n__(_.lng))
    except:
        __trace__()
        # for testing compiling, we create a not document based namespace
        if "_" not in locals():
            _ = lambda: None
        _.lng = 'en_US'
        if not _.lng in __comp__:
            __loadlang__(_.lng, __l12n__(_.lng)) 

    _.decimal = __l12n__(_.lng)['DECIMAL']

    rmsp = re.compile(r"[ ]*([=+*/]|==|<=|>=|<>|!=|-[ ]+)[ ]*")
    chsp = re.compile(r"[ \t]+")
    chch = re.compile(r"(?u)(?<!\w):(?=\w)")

    # remove CR characters and split lines
    s = re.sub(r'[ \t\r]*(?=\n)', '', s)

    # remove full line comments
    s = re.sub(r"^[ \t]*[;#][^\n]*", "", s)
    s = re.sub(r"(?<=\n)[ \t]*[;#][^\n]*", "", s)

    # concatenate lines
    __compiled__ = re.sub(r'([^\n]*~[ \t]*\n)+[^\n]*', __concatenation__, s)

    # sign original line breaks
    s = re.sub("(?<=\n)", __LINEBREAK__ + "\n", __compiled__)

    # encode strings
    lq = '\'' + __l12n__(_.lng)['LEFTSTRING'].replace("|", "")
    rq = '\'' + __l12n__(_.lng)['RIGHTSTRING'].replace("|", "")
    __strings__ = []
    s = re.sub("(?u)([%s])((?:[^\n%s]|\\\\[%s])*)(?<!\\\\)[%s]" % (lq, rq, rq, rq), __encodestring__, s)
    s = re.sub(r'(?u)(?<![0-9])(")(~?\w*)', __encodestring__, s)

    # remove extra spaces
    s = chsp.sub(" ", s)

    # remove inline comments
    s = re.sub(r"[ ]*;[^\n]*", "", s)

    # n-dash and m-dash as minus signs
    s = re.sub(r"(?u)[–—]", "-", s)

    # replace procedure names
    s = re.sub(r"(?i)^[ ]*(%s)[ ]+" % __l12n__(_.lng)['TO'], "__def__ ", s)
    s = re.sub(r"(?i)\n[ ]*(%s)[ ]+" % __l12n__(_.lng)['TO'], "\n__def__ ", s)
    subnames = re.findall(r"(?iu)(?<=__def__ )\w+", s)
    globs = ""
    functions = ["range", "__int__", "__float__", "Random", "Input", "__string__", "len", "round", "abs", "sin", "cos", "sqrt", "log10", "set", "list", "tuple", "re.sub", "re.search", "re.findall", "sorted", "min", "max"]
    defaultfunc = ["Print"] # TODO handle all default procedures

    if len(subnames) > 0:
        globs = "global %s" % ", ".join(subnames)
        # search user functions (function calls with two or more arguments need explicit Python parentheses)
        ends = __l12n__(_.lng)["END"] # support multiple names of "END"
        firstend = ends.split("|")[0]
        s = re.sub(r"(?<!:)\b(?:%s)\b" % ends, firstend, s)
        __l12n__(_.lng)["END"] = firstend
        functions += [ re.findall(r"(?u)\w+",i[0])[0]  for i in re.findall(r"""(?iu)(?<=__def__ )([^\n]*)\n # beginning of a procedure
            (?:[^\n]*(?<!\b(%(END)s))\n)* # 0 or more lines (not END)
            [^\n]*\b(?:%(OUTPUT)s)\b[^\n]*\n # line with OUTPUT (functions = procedures with OUTPUT)
            (?:[^\n]*(?<!\b(?:%(END)s))\n)* # 0 or more lines (not END)
            [ \t]*\b(?:%(END)s)\b""" % __l12n__(_.lng), s, re.X) ]
        __l12n__(_.lng)["END"] = ends
        # add line breaks before procedure calls
        procedures = set(subnames) - set(functions)
        if len(procedures) > 0:
            s = re.sub(r"(?<!__def__)(?<![-+=*/])(?<!%s)(?:^|[ \t]+)(" % ")(?<!".join(functions) + "|".join(procedures) + r")(?!\w)", r"\n\1", s)

    # substitute LibreLogo functions and specifiers with their Python equivalents
    for i in __comp__[_.lng]:
        s = re.sub(u"(?u)" + i[0], i[1], s)

    indent = 0 # Python indentation level
    result = ""
    func = re.compile(r"(?iu)(def (\w+))(\(.*\):)")

    # compile to Python
    subroutines = re.compile(r"(?iu)(?<!def )(?<![_\w])\b(%s)\b(?![\w(])" % "|".join(subnames + functions + defaultfunc))
    operators = re.compile(r"(?iu)(%s)" % "(?:[ ]*([+*/<>]|//|==|<=|>=|<>|!=)[ ]*|[ ]*-[ ]+|(?<! )-[ ]*|[ ]*[*][*][ ]*)") # operators, eg. " - ", "-", "- "
    atoms = re.compile(r"(?iu)(%s)" % r"[0-9]+([.,][0-9]+)?|:?\w+([.]\w)?")

    # store argument numbers of all subroutines in dictionary "names"
    names = {key: 1 for key in functions + defaultfunc}
    names["range"] = names["re.sub"] = 3
    names["re.search"] = names["re.findall"] = 2

    # match a function header
    search_funcdef = re.compile(r"(^|\n) *(def (\w+))(\([^\n]*\):) *(?=\n)")

    # "multiline" lambda function to process function headers: add commas to argument list and
    # add {"subroutine_name": argument_count} into names using a temporary array
    # (instead of using global variable "names" and a new global function to process the matching patterns)
    # for example: "def f(x y z):" -> "def f(x,y,z):" and names = {"f": 3}
    process_funcdef = lambda r: r.group(1) + r.group(2) + \
        [chsp.sub(", ", r.group(4)), names.update({r.group(3): len(re.findall(r"\w+", r.group(4)))})][0]
    # process all function headers calling process_funcdef for every matching
    # (before parsing Logo expressions line by line, we need to know about all functions,
    # because functions can be defined in any order, ie. their calls can be before
    # their definitions)
    s = search_funcdef.sub(process_funcdef, s)

    # process line by line
    for i in s.split("\n"):
        i = i.strip()

        # convert Logo expressions to Python ones using regex based tokenization
        # tokens: {startpos: endpos} dictionaries for subroutine names, operators and other tokens

        # sub: subroutine tokens = positions of Logo subroutine names
        # (without explicit parentheses, for example: "f x" or "f (x*2)", but not "f(x)")
        sub = {key: value for (key, value) in [j.span() for j in list(subroutines.finditer(i))]}
        if sub != {}:
            # op: operator tokens
            op = {key: value for (key, value) in [j.span() for j in list(operators.finditer(i))]}
            # atom: other tokens (variable names, numbers and function names)
            atom = {key: value for (key, value) in [j.span() for j in list(atoms.finditer(i))]}
            par = {"pos": 0, "out": "", "sub": sub, "op": op, "atom": atom, "names": names}
            if i.startswith(')') and '(' in i:
                # replace ")forward(" etc. with spaces temporarily
                len_name = i.index('(') + 1
                __l2p__(' ' * len_name + i[len_name:], par, False, False)
                i = i[:len_name] + par["out"].lstrip()
            else:
                __l2p__(i, par, False, False)
                i = par["out"]
        # starting program block
        if i[0:1] == '[':
            i = i[1:]
            indent += 1
            # check program stop, for example, in every execution of a loop
            result = result + "\n" + " " * indent + "__checkhalt__()\n"
        # fix position of ending parenthesis
        if i[0:1] == ')':
            i = i[1:] + ')'
        result = result + "\n" + " " * indent + i
        # ending program block
        if i[0:1] == ']':
            result = result[:-1]
            indent -= 1

    # colon_to_underline in Logo variables
    result = chch.sub("_", result)

    # character encoding
    result = to_ascii(result).replace(r"\n", "\n")

    # decode strings
    result = re.sub(__DECODE_STRING_REGEX__, __decodestring__, result)
    return to_ascii(globs) + "\n" + result

def __gotoline__(n):
    _.cursor.collapseToStart()
    for i in range(1, n):
        _.cursor.gotoNextParagraph(False)
    try:
        _.doc.CurrentController.getViewCursor().gotoRange(_.cursor, False)
    except:
        __dispatcher__(".uno:Escape")
        _.doc.CurrentController.getViewCursor().gotoRange(_.cursor.getStart(), False)

g_exportedScripts = left, right, goforward, gobackward, run, stop, home, clearscreen, commandline, __translate__

# vim: set shiftwidth=4 softtabstop=4 expandtab:

__lng_fallback__ = {
'FORWARD':{'en_US': 'forward|fd', 'af': 'voorwaarts|vw', 'am': 'ወደ ፊት|ወደ ፊት', 'ar': 'للأمام|أم', 'ast': 'avanzar|av', 'be': 'наперад|нп', 'br': 'war-raok|fd', 'bs': 'naprijed|fd', 'ca': 'avança|endavant|davant|av', 'ca_valencia': 'avança|avant|davant|av', 'cy': 'ymlaen|fd', 'cs': 'dopředu|do', 'de': 'vor|vr', 'dsb': 'doprědka|dp', 'el': 'μπροστά|μπ|forward|fd', 'eo': 'antaŭen|a', 'es': 'avanza|adelante|av|ad', 'et': 'edasi|e', 'eu': 'aurrera|aur', 'fi': 'eteen|et', 'fr': 'avance|av', 'fy': 'foarút|fu', 'gl': 'reenviada|fd', 'gug': 'tenondépe|td', 'he': 'קדימה|קד', 'hr': 'naprijed|np', 'hsb': 'doprědka|dp', 'hu': 'előre|e', 'is': 'áfram|fr', 'ja': 'すすむ|forward|fd', 'kab': 'zdat|zd', 'kk': 'алға|ал', 'km': 'បញ្ជូន\u200bបន្ត|fd', 'kn': 'ಮುಂದಕ್ಕೆ|fd', 'ko': '앞으로|fd', 'lo': 'ໄປຂ້າງຫນ້າ|fd', 'lt': 'priekin|pr', 'lv': 'uz_priekšu|pr', 'mn': 'урагш|fd', 'mr': 'पुढे|fd', 'nb': 'forover|fd', 'nl': 'vooruit|vu', 'nn': 'fram|framover|forover|fr|forward', 'oc': 'avança|av', 'or': 'ଆଗକୁ|fd', 'pt_BR': 'paraFrente|pf', 'ro': 'forward|fd|înainte', 'ru': 'вперёд|в', 'sid': 'albira|ar', 'sk': 'dopredu|do', 'sl': 'naprej|np', 'sq': 'përpara|fd', 'th': 'เดินหน้า|fd', 'tr': 'ileri|il', 'uk': 'вперед|вп', 'uz': 'oldinga|ol', 'zh_CN': '前进|进|forward|fd', 'zh_TW': '前進|進|forward|fd'},
'BACKWARD':{'en_US': 'back|bk', 'af': 'terug|tg', 'am': 'ወደ ኋላ|ወደ ኋላ', 'ar': 'للخلف|خف', 'ast': 'atrás|pt', 'be': 'назад|нз', 'br': 'war-gil|bk', 'bs': 'nazad|bk', 'ca': 'retrocedeix|recula|enrere|re', 'ca_valencia': 'retrocedeix|recula|arrere|re', 'cs': 'vzad|vz', 'de': 'zurück|zk', 'dsb': 'slědk|sk', 'el': 'πίσω|πι|back|bk', 'eo': 'retro|r', 'es': 'retrocede|atras|re|at', 'et': 'tagasi|t', 'eu': 'atzera|atz', 'fi': 'taakse|tk', 'fr': 'recule|re', 'fy': 'tebek|tb', 'gl': 'atrás|bk', 'gug': 'tapykuépe|jere', 'he': 'אחורה|אח', 'hr': 'nazad|nz', 'hsb': 'wróćo|wr', 'hu': 'hátra|h', 'is': 'bakka|bk', 'ja': 'もどる|back|bk', 'kab': 'ɣer deffir', 'kk': 'артқа|ар', 'km': 'ថយក្រោយ|bk', 'kn': 'ಹಿಂದಕ್ಕೆ|bk', 'ko': '뒤로|bk', 'lo': 'ກັບຫຼັງ|bk', 'lt': 'atgal|at', 'lv': 'atpakaļ|at', 'mn': 'буцах|bk', 'mr': 'मागे|bk', 'nb': 'tilbake|bakover|tb', 'nl': 'terug|tg', 'nn': 'tilbake|bakover|tb|back', 'oc': 'recuola|re', 'or': 'ପଛକୁ|bk', 'pt_BR': 'paraTrás|pt', 'ro': 'back|bk|înapoi', 'ru': 'назад|н', 'sid': 'badhera|br', 'sk': 'vzad|vz', 'sl': 'nazaj|nz', 'sq': 'prapa|bk', 'th': 'กลับหลัง|bk', 'tr': 'geri|ge', 'uk': 'назад|нд', 'uz': 'orqaga|or', 'zh_CN': '后退|退|back|bk', 'zh_TW': '後退|退|back|bk'},
'TURNLEFT':{'en_US': 'left|turnleft|lt', 'af': 'links|linksaf|li', 'am': 'ግራ|ወደ ግራ ማዟሪያ|ወደ ግራ', 'ar': 'لليسار', 'ast': 'izquierda|xiraizquierda|xi', 'be': 'улева|паварот_улева|лв', 'bs': 'lijevo|skrenilijevo|lt', 'ca': 'esquerra|giraesquerra|gira.esquerra|ge', 'ca_valencia': 'esquerra|giraesquerra|gira.esquerra|ge', 'cs': 'vlevo|vl', 'de': 'links|li', 'dsb': 'nalěwo|nl', 'el': 'αριστερά|στροφήαριστερά|αρ|left|turnleft|lt', 'eo': 'maldekstren|turnu_liven|lt', 'es': 'izquierda|giraizquierda|iz|gi', 'et': 'vasakule|vasakpööre|v', 'eu': 'ezkerra|ezkerrera|ezk', 'fi': 'vasemmalle|vas', 'fr': 'gauche|tournegauche|ga', 'fy': 'links|linksôf|lf', 'gl': 'esquerda|voltaesquerda|lt', 'gug': 'asúpe|jereasúpe|as', 'he': 'שמאלה|לפנותשמאלה|פנייהשמאלה|שמ', 'hr': 'lijevo|okreni lijevo|li', 'hsb': 'nalěwo|nl', 'hu': 'balra|b', 'is': 'vinstri|snúavinstri|vi', 'ja': '左|左に曲がる|left|turnleft|lt', 'kab': 'ayeffus', 'kk': 'солға|солға_бұрылу|с', 'km': 'ឆ្វេង|turnleft|lt', 'kn': 'ಎಡ|ಎಡಕ್ಕೆ ತಿರುಗಿಸು|lt', 'ko': '왼쪽|왼쪽으로회전|lt', 'lo': 'ຊ້າຍ|ລ້ຽວຊ້າຍ|lt', 'lt': 'kairėn|kr', 'lv': 'pa_kreisi|kreisi|gk', 'mn': 'зүүн|зүүнэргэх|lt', 'mr': 'डावे|डावीकडे वळा|lt', 'nb': 'venstre|snu venstre|ve', 'nl': 'links|linksaf|ls', 'nn': 'venstre|snu venstre|ve|left', 'oc': 'esquerra|viraesquerra|es', 'or': 'ବାମକୁ|ବାମକୁ ଯାଆନ୍ତୁ|lt', 'pt_BR': 'paraEsquerda|pe|girarEsquerda|giraEsquerda', 'ro': 'left|turnleft|lt|stânga', 'ru': 'влево|поворот_налево|л', 'sid': 'gura|guraraqole|gr', 'sk': 'vľavo|vl', 'sl': 'levo|obrnilevo|lv', 'sq': 'majtaj|kthehumajtas|lt', 'th': 'ซ้าย|เลี้ยวซ้าย|lt', 'tr': 'sol|soladön|sl', 'uk': 'ліворуч|поворот_ліворуч|лв', 'uz': 'chap|chapga_burilish|chp', 'zh_CN': '左|左转|left|turnleft|lt', 'zh_TW': '左|左轉|left|turnleft|lt'},
'TURNRIGHT':{'en_US': 'right|turnright|rt', 'af': 'regs|regsaf|re', 'am': 'ቀኝ|ወደ ቀኝ ማዟሪያ|ወደ ቀኝ', 'ar': 'لليمين', 'ast': 'drecha|xiradrecha|xd', 'be': 'управа|паварот_управа|пр', 'br': 'dehou|trotudehou|de', 'bs': 'desno|skrenidesno|rt', 'ca': 'dreta|giradreta|gira.dreta|gd', 'ca_valencia': 'dreta|giradreta|gira.dreta|gd', 'cs': 'vpravo|vp', 'de': 'rechts|re', 'dsb': 'napšawo|np', 'el': 'δεξιά|στροφήδεξιά|δξ|right|turnright|rt', 'eo': 'dekstren|turnu_dekstren|dt', 'es': 'derecha|giraderecha|de|gd', 'et': 'paremale|parempööre|p', 'eu': 'eskuina|eskuinera|esk', 'fi': 'oikealle|oik', 'fr': 'droite|tournedroite|dr', 'fy': 'rjochts|rjochtsôf|rs', 'gl': 'dereita|voltadereita|rt', 'gug': 'akatúa|jereakatúa|ak', 'he': 'ימינה|לפנותימינה|פנייהימינה|ימ', 'hr': 'desno|okreni desno|de', 'hsb': 'naprawo|np', 'hu': 'jobbra|j', 'is': 'hægri|snúahægri|hæ', 'ja': '右|右に曲がる|right|turnright|rt', 'kab': 'azelmaḍ', 'kk': 'оңға|оңға_бұрылу|о', 'km': 'ស្ដាំ|turnright|rt', 'kn': 'ಬಲ|ಬಲಕ್ಕೆ ತಿರುಗಿಸು|rt', 'ko': '오른쪽|오른쪽으로회전|rt', 'lo': 'ຂວາ|ລ້ຽວຂວາ|rt', 'lt': 'dešinėn|dš', 'lv': 'pa_labi|labi|gl', 'mn': 'баруун|баруунэргэлт|rt', 'mr': 'उजवी|उजवीकडे वळा|rt', 'nb': 'høyre|snu høyre|hg', 'nl': 'rechts|rechtsaf|rs', 'nn': 'høgre|snu høgre|hg|right', 'oc': 'dreita|virardreita|de', 'or': 'ଡ଼ାହାଣ|ଡ଼ାହାଣକୁ ଯାଆନ୍ତୁ|rt', 'pt_BR': 'paraDireita|pd|girarDireita|giraDireita', 'ro': 'right|turnright|rt|dreapta', 'ru': 'вправо|поворот_направо|п', 'sid': 'qiniite|qiniitiraqoli|qt', 'sk': 'vpravo|vp', 'sl': 'desno|obrnidesno|ds', 'sq': 'djathtas|kthehudjathtas|rt', 'th': 'ขวา|เลี้ยวขวา|rt', 'tr': 'sağ|sağadön|sğ', 'uk': 'праворуч|поворот_праворуч|пр', 'uz': 'o‘ng|o‘ngga_burilish|o‘n', 'zh_CN': '右|右转|right|turnright|rt', 'zh_TW': '右|右轉|right|turnright|rt'},
'PENUP':{'en_US': 'penup|pu', 'af': 'penop|po', 'am': 'ብዕር ወደ ላይ |pu', 'ar': 'ارفع_القلم|ارفع', 'ast': 'llapizxubir|lx', 'bs': 'pengore|pu', 'ca': 'aixeca.llapis|al', 'ca_valencia': 'alça.llapis|al', 'cs': 'peronahoru|pn', 'de': 'fliegen', 'dsb': 'pisakgórjej|pg', 'el': 'γραφίδαπάνω|γπ|penup|pu', 'eo': 'plumofor|pf', 'es': 'sinpluma|subirlapiz|sp|sl', 'et': 'pliiats_üles|pü', 'eu': 'lumagora|lg', 'fi': 'kynäylös|ky', 'fr': 'levecrayon|lc', 'fy': 'penomheech|po', 'gl': 'senestilo|se', 'gug': "bolígrafo'ỹre|bỹ", 'he': 'להריםעט|עטלמעלה|הרםעט|לע', 'hr': 'olovka gore|og', 'hsb': 'pisakhorje|ph', 'hu': 'tollatfel|tf', 'is': 'penniupp|pu', 'ja': 'ペンをあげる|penup|pu', 'kab': 'saliakeryun|ak', 'kk': 'қаламды_көтеру|қк', 'kn': 'ಲೇಖನಿಎತ್ತು|pu', 'ko': '펜을위로|pu', 'lo': 'ປາກກາຂື້ນ|pu', 'lt': 'eisim|es|pakelk.pieštuką|pakelk.trintuką', 'lv': 'pacelt_spalvu|ps', 'mn': 'үзэгөргөх|pu', 'mr': 'पेनअप|pu', 'nb': 'penn opp|po|penup', 'nl': 'penomhoog|po', 'nn': 'penn opp|po|penup', 'oc': 'levagredon|lg', 'or': 'ପେନଉପରକୁ|pu', 'pt_BR': 'usarNada|un|useNada', 'ro': 'penup|pu|stilousus', 'ru': 'поднять_перо|пп', 'sid': 'biireworora|bw', 'sk': 'perohore|ph', 'sl': 'perogor|pg', 'sq': 'lapsilart|pu', 'th': 'ปากกาขึ้น|pu', 'tr': 'kalemyukarı|ky', 'uk': 'підніми_перо|пп', 'uz': 'ruchkani_ko‘tarish|rk', 'zh_CN': '提笔|抬笔|penup|pu', 'zh_TW': '提筆|penup|pu'},
'PENDOWN':{'en_US': 'pendown|pd', 'af': 'penaf|pa', 'am': 'ብዕር ወደ ታች |pd', 'ar': 'أنزل_القلم|أنزل', 'ast': 'llapizbaxar|lb', 'bs': 'pendole|pd', 'ca': 'baixa.llapis|bl', 'ca_valencia': 'baixa.llapis|bl', 'cs': 'perodolů|pd', 'de': 'laufen', 'dsb': 'pisakdołoj|pd', 'el': 'γραφίδακάτω|γκ|pendown|pd', 'eo': 'plumoek|pe', 'es': 'conpluma|bajarlapiz|cp|bl', 'et': 'pliiats_alla|pa', 'eu': 'lumabehera|lb', 'fi': 'kynäalas|ka', 'fr': 'baissecrayon|bc', 'fy': 'penomleech|po', 'gl': 'conestilo|ce', 'gug': 'bolígrafo|bo', 'he': 'להורידעט|עטלמטה|הורדעט|הע', 'hr': 'olovka dolje|od', 'hsb': 'pisakdele|pd', 'hu': 'tollatle|tl', 'is': 'penniniður|pn', 'ja': 'ペンをおろす|pendown|pd', 'kab': 'siderakeryun|ik', 'kk': 'қаламды_түсіру|қт', 'km': 'pendown', 'kn': 'ಲೇಖನಿಇಳಿಸು|pd', 'ko': '펜아래로|pd', 'lo': 'ປາກກາລົງ|pd', 'lt': 'piešim|pš|nuleisk.pieštuką', 'lv': 'nolikt_spalvu|ns', 'mn': 'үзэгбуулгах|pd', 'mr': 'पेनडाउन|pd', 'nb': 'penn ned|pn|pendown', 'nl': 'penneer|pn', 'nn': 'penn ned|pn|pendown', 'oc': 'abaissagredon|bg', 'or': 'ପେନତଳକୁ|pd', 'pt_BR': 'usarLápis|ul|useLápis', 'ro': 'pendown|pd|stiloujos', 'ru': 'опустить_перо|оп', 'sid': 'biireworora|bw', 'sk': 'perodolu|pd', 'sl': 'perodol|pd', 'sq': 'lapsiposhtë|pd', 'th': 'ปากกาลง|pd', 'tr': 'kalemaşağı|ka', 'uk': 'опусти_перо|оп', 'vec': 'penabasa|pd', 'zh_CN': '下笔|落笔|pendown|pd', 'zh_TW': '下筆|pendown|pd'},
'HOME':{'en_US': 'home', 'af': 'tuis', 'am': 'ቤት', 'ar': 'المنزل', 'as': 'ঘৰ', 'ast': 'aniciu', 'be': 'пачатак', 'bn_IN': 'Home', 'br': 'Degemer', 'bs': 'kući', 'ca': 'inici|centre', 'ca_valencia': 'inici|centre', 'ckb': 'ماڵەوە', 'cy': 'cartref', 'cs': 'domů', 'de': 'anfang', 'dgo': 'घर', 'dsb': 'zachopjeńk', 'el': 'αρχή|home', 'eo': 'hejmen', 'es': 'inicio|casa|centro', 'et': 'koju', 'eu': 'hasiera', 'fi': 'kotiin', 'fr': 'origine', 'fy': 'thús', 'gd': 'dhachaigh', 'gl': 'inicio', 'gug': 'óga', 'gu': 'ઘર', 'he': 'בית', 'hi': 'घर', 'hr': 'polazno', 'hsb': 'spočatk', 'hu': 'haza', 'id': 'beranda', 'is': 'heim', 'ja': 'もとの場所へ|home', 'kab': 'axxam', 'kk': 'басы', 'km': 'ដើម', 'kn': 'ನೆಲೆ', 'kok': 'घरGhor', 'ko': '처음', 'lo': 'ໜ້າທຳອິດ', 'lt': 'namo', 'lv': 'sākums', 'ml': 'ആസ്ഥാനം', 'mn': 'нүүр хуудас', 'mr': 'होम', 'my': 'အချို့', 'nb': 'hjem', 'nl': 'thuis', 'nn': 'heim|home', 'oc': 'acuèlh', 'or': 'ମୂଳ ସ୍ଥାନ', 'pa_IN': 'ਘਰ', 'pt_BR': 'paraCentro|centro|pc', 'ro': 'home|acasă', 'ru': 'начало', 'sat': 'ओड़ाक्', 'sd': 'گهر', 'sid': 'Mine', 'si': 'සමහර', 'sk': 'domov', 'sl': 'začetek', 'sq': 'shtëpia', 'te': 'నివాసం', 'th': 'บ้าน', 'tr': 'başlangıç', 'uk': 'центр', 'vi': 'Home', 'zh_CN': '归位|回归|回家|家|home', 'zh_TW': '回家|家|home'},
'POINT':{'en_US': 'point', 'af': 'punt', 'am': 'ነጥቦች', 'ar': 'نقطة', 'as': 'বিন্দু', 'ast': 'puntu', 'be': 'пункт', 'bn_IN': 'পয়েন্ট', 'br': 'poent', 'bs': 'tačka', 'ca': 'punt', 'ca_valencia': 'punt', 'ckb': 'خاڵ', 'cy': 'pwynt', 'cs': 'bod|puntík', 'de': 'punkt', 'dsb': 'dypk', 'el': 'σημείο|point', 'eo': 'punkto', 'es': 'punto', 'et': 'punkt', 'eu': 'puntua', 'fi': 'piste', 'fy': 'punt', 'gd': 'puing', 'gl': 'punto', 'gug': 'kyta', 'gu': 'બિંદુ', 'he': 'נקודה', 'hi': 'बिंदु', 'hr': 'točka', 'hsb': 'dypk', 'hu': 'pont', 'id': 'poin', 'is': 'punktur', 'ja': '点|point', 'kab': 'agaz', 'ka': 'წერტილი', 'kk': 'нүкте', 'km': 'ចំណុច', 'kn': 'ಬಿಂದುಗಳು', 'ko': '점', 'lo': 'ຈຸດ', 'lt': 'skritulys', 'lv': 'punkts', 'ml': 'പോയിന്റ്', 'mn': 'цэг', 'mr': 'बिंदू', 'my': 'အမှတ်', 'nb': 'punkt', 'ne': 'प्वाइन्ट', 'nl': 'punt', 'nn': 'punkt|point', 'oc': 'punt', 'or': 'ବିନ୍ଦୁ', 'pa_IN': 'ਬਿੰਦੂ', 'pt_BR': 'ponto', 'ro': 'point|punct', 'ru': 'точка', 'sid': 'bixxille', 'si': 'ලක්ෂ්\u200dය', 'sk': 'bod', 'sl': 'točka', 'sq': 'pikë', 'ta': 'புள்ளி', 'te': 'బిందువు', 'th': 'จุด', 'tr': 'nokta', 'ug': 'نۇقتا', 'uk': 'точка', 'vi': 'điểm', 'zh_CN': '点|point', 'zh_TW': '點|point'},
'CIRCLE':{'en_US': 'circle', 'af': 'sirkel', 'am': 'ክብ', 'ar': 'دائرة', 'as': 'বৃত্ত', 'ast': 'círculu', 'be': 'акружына', 'bn_IN': 'বৃত্ত', 'br': "kelc'h", 'bs': 'krug', 'ca': 'cercle', 'ca_valencia': 'cercle', 'ckb': 'بازنە', 'cy': 'cylch', 'cs': 'kruh', 'de': 'kreis', 'dsb': 'krejz', 'el': 'κύκλος|circle', 'eo': 'cirklo', 'es': 'circulo|círculo', 'et': 'ring', 'eu': 'zirkulua', 'fi': 'ympyrä', 'fr': 'cercle', 'fy': 'sirkel', 'gd': 'cearcall', 'gl': 'círculo', 'gug': 'círculo', 'gu': 'વતૃળ', 'he': 'עיגול', 'hi': 'वृत्त', 'hr': 'krug', 'hsb': 'kruh', 'hu': 'kör', 'id': 'lingkaran', 'is': 'hringur', 'ja': '円|circle', 'kab': 'taẓayert', 'ka': 'წრე', 'kk': 'шеңбер', 'km': 'រង្វង់', 'kn': 'ವೃತ್ತ', 'ko': '원', 'lo': 'ວົງມົນ', 'lt': 'apskritimas', 'lv': 'riņķis', 'ml': 'വൃത്തം', 'mn': 'тойрог', 'mr': 'वर्तुळ', 'my': 'စက်ဝိုင်းပုံစံ', 'nb': 'sirkel', 'ne': 'वृत्त', 'nl': 'cirkel', 'nn': 'sirkel|circle', 'oc': 'cercle', 'or': 'ବୃତ୍ତ', 'pa_IN': 'ਚੱਕਰ', 'pt_BR': 'círculo|circunferência', 'ro': 'circle|cerc', 'ru': 'круг', 'sid': 'doyicho', 'si': 'කවය', 'sk': 'kruh', 'sl': 'krog', 'sq': 'rreth', 'ta': 'வட்டம்', 'te': 'వృత్తము', 'th': 'วงกลม', 'tr': 'daire', 'ug': 'چەمبەر', 'uk': 'коло', 'vec': 'sercio', 'vi': 'Tròn', 'zh_CN': '圆|circle', 'zh_TW': '圓|circle'},
'ELLIPSE':{'en_US': 'ellipse', 'af': 'ellips', 'am': 'ኤሊፕስ', 'ar': 'بيضاوي', 'as': 'উপবৃত্ত', 'ast': 'elipse', 'be': 'эліпс', 'bn_IN': 'উপবৃত্ত', 'br': 'elipsenn', 'bs': 'elipsa', 'ca': 'el·lipse', 'ca_valencia': 'el·lipse', 'ckb': 'هێلکەیی', 'cy': 'elips', 'cs': 'elipsa', 'dsb': 'elipsa', 'el': 'έλλειψη|ellipse', 'eo': 'elipso', 'es': 'elipse', 'et': 'ellips', 'eu': 'elipsea', 'fi': 'ellipsi', 'fy': 'elips', 'gd': 'eileaps', 'gl': 'elipse', 'gug': 'elipse', 'gu': 'ઉપવલય', 'he': 'אליפסה', 'hi': 'दीर्घवृत्त', 'hr': 'elipsa', 'hsb': 'elipsa', 'hu': 'ellipszis', 'id': 'elips', 'is': 'sporbaugur', 'ja': '楕円|ellipse', 'kab': 'taglayt', 'ka': 'ელიფსი', 'kk': 'эллипс', 'km': 'ពង\u200bក្រពើ', 'kn': 'ದೀರ್ಘವೃತ್ತ', 'ko': '타원', 'lo': 'ຮູບວົງລີ', 'lt': 'elipsė', 'lv': 'elipse', 'ml': 'അണ്ഡവൃത്തം', 'mn': 'эллипс', 'mr': 'दीर्घवृत्त', 'my': 'ဘဲဥပုံ', 'ne': 'दीर्घवृत्त', 'nl': 'ellips', 'oc': 'ellipsa', 'or': 'ଅଣ୍ଡାକୃତ', 'pa_IN': 'ਅੰਡਾਕਾਰ', 'pt_BR': 'elipse', 'ro': 'ellipse|elipsă', 'ru': 'эллипс', 'sid': 'suduudaamo', 'si': 'ඉලිප්සය', 'sk': 'elipsa', 'sl': 'elipsa', 'sq': 'elips', 'ta': 'நீள்வட்டம்', 'te': 'దీర్ఘవృత్తం', 'th': 'วงรี', 'tr': 'elips', 'ug': 'ئېللىپىس', 'uk': 'еліпс', 'vec': 'ełise', 'vi': 'Bầu dục', 'zh_CN': '椭圆|ellipse', 'zh_TW': '橢圓|ellipse'},
'SQUARE':{'en_US': 'square', 'af': 'vierkant', 'am': 'ስኴር', 'ar': 'مربع', 'as': 'বৰ্গ', 'ast': 'cuadráu', 'be': 'квадрат', 'bn_IN': 'বর্গক্ষেত্র', 'br': 'karrez', 'bs': 'kvadrat', 'ca': 'quadrat', 'ca_valencia': 'quadrat', 'ckb': 'چوارگۆشە', 'cy': 'sgwâr', 'cs': 'čtverec', 'de': 'quadrat', 'dsb': 'kwadrat', 'el': 'τετράγωνο|square', 'eo': 'kvadrato', 'es': 'cuadrado', 'et': 'ruut', 'eu': 'karratu', 'fi': 'neliö', 'fr': 'carré', 'fy': 'fjouwerkant', 'gd': 'ceàrnag', 'gl': 'cadrado', 'gug': 'cuadrado', 'gu': 'ચોરસ', 'he': 'ריבוע', 'hi': 'वर्ग', 'hr': 'kvadrat', 'hsb': 'kwadrat', 'hu': 'négyzet', 'id': 'kotak', 'is': 'ferningur', 'ja': '正方形|square', 'kab': 'amkuẓ', 'ka': 'კვადრატი', 'kk': 'шаршы', 'km': 'ការេ', 'kn': 'ಚೌಕ', 'ko': '정사각형', 'lo': 'ສີ່ຫລ່ຽມຈັດຕຸລັດ', 'lt': 'kvadratas', 'lv': 'kvadrāts', 'ml': 'സമചതുരം', 'mn': 'квадрат', 'mr': 'चौरस', 'my': 'စတုရန်း', 'nb': 'kvadrat', 'ne': 'वर्ग', 'nl': 'vierkant', 'nn': 'kvadrat|square', 'oc': 'carrat', 'or': 'ବର୍ଗାକାର', 'pa_IN': 'ਵਰਗ', 'pt_BR': 'quadrado', 'ro': 'square|pătrat', 'ru': 'квадрат', 'sid': 'isikuwere', 'si': 'සමචතුරශ්\u200dරය', 'sk': 'štvorec', 'sl': 'kvadrat', 'sq': 'katror', 'ta': 'சதுரம்', 'te': 'చతురస్రము', 'th': 'สี่เหลี่ยมจัตุรัส', 'tr': 'kare', 'ug': 'كۋادرات', 'uk': 'квадрат', 'vec': 'cuadrà', 'vi': 'Vuông', 'zh_CN': '正方形|方|square', 'zh_TW': '正方形|方|square'},
'RECTANGLE':{'en_US': 'rectangle', 'af': 'reghoek', 'am': 'አራት ማእዘን', 'ar': 'مستطيل', 'as': 'আয়ত', 'ast': 'rectángulu', 'be': 'прамавугольнік', 'bn_IN': 'আয়তক্ষেত্র', 'br': 'reizhkorneg', 'bs': 'pravougao', 'ckb': 'لاکێشە', 'cy': 'petryal', 'cs': 'obdélník', 'de': 'rechteck', 'dsb': 'pšawokut', 'el': 'ορθογώνιο|rectangle', 'eo': 'ortangulo', 'es': 'rectángulo', 'et': 'ristkülik', 'eu': 'laukizuzena', 'fi': 'suorakulmio', 'fy': 'rjochthoek', 'gd': 'ceart-cheàrnach', 'gl': 'rectángulo', 'gug': 'rectángulo', 'gu': 'લંબચોરસ', 'he': 'מלבן', 'hi': 'आयत', 'hr': 'pravokutnik', 'hsb': 'praworóžk', 'hu': 'téglalap', 'id': 'persegi', 'is': 'rétthyrningur', 'ja': '長方形|rectangle', 'kab': 'asrem', 'ka': 'მართკუთხედი', 'kk': 'тіктөртбұрыш', 'km': 'ចតុកោណកែង', 'kn': 'ಆಯತ', 'ko': '직사각형', 'lo': 'ສີຫລ່ຽມສາກ', 'lt': 'stačiakampis', 'lv': 'taisnstūris', 'ml': 'ചതുര്ഭുജം', 'mn': 'тэгш өнцөгт', 'mr': 'आयत', 'my': 'ထောင့်မှန်စတုဂံ', 'nb': 'rektangel', 'ne': 'आयात', 'nl': 'rechthoek', 'nn': 'rektangel|rectangle', 'or': 'ଆୟତକ୍ଷେତ୍ର', 'pa_IN': 'ਚਤੁਰਭੁਜ', 'pt_BR': 'retângulo', 'ro': 'rectangle|dreptunghi', 'ru': 'прямоугольник', 'sid': 'rekitaangile', 'si': 'ත්\u200dරිකෝණය', 'sk': 'obdĺžnik', 'sl': 'pravokotnik', 'sq': 'drejtkëndësh', 'ta': 'செவ்வகம்', 'te': 'దీర్ఘ చతురస్రము', 'th': 'สี่เหลี่ยมผืนผ้า', 'tr': 'dikdörtgen', 'ug': 'تىك تۆت بۇلۇڭ', 'uk': 'прямокутник', 'vec': 'retàngoło', 'vi': 'Hình chữ nhật', 'zh_CN': '矩形|矩|长方形|rectangle', 'zh_TW': '長方形|矩|rectangle'},
'LABEL':{'en_US': 'label', 'af': 'byskrif', 'am': 'ምልክት', 'ar': 'اللصيقة', 'as': 'লেবেল', 'ast': 'etiqueta', 'be': 'метка', 'bn_IN': 'লেবেল', 'br': 'tikedenn', 'bs': 'naljepnica', 'ca': 'etiqueta', 'ca_valencia': 'etiqueta', 'ckb': 'پێناسکراو', 'cs': 'text', 'de': 'schreibe', 'dgo': 'लेबल', 'dsb': 'pomjenjenje', 'el': 'ετικέτα|label', 'eo': 'etikedo', 'es': 'etiqueta', 'et': 'silt', 'eu': 'etiketa', 'fi': 'selite', 'fr': 'étiquette', 'fy': 'lebel', 'gd': 'leubail', 'gl': 'etiqueta', 'gug': 'etiqueta', 'gu': 'લેબલ', 'he': 'תווית', 'hi': 'लेबल', 'hr': 'oznaka', 'hsb': 'popis', 'hu': 'címke', 'is': 'skýring', 'ja': 'ラベル|label', 'kab': 'tabzimt', 'kk': 'белгі', 'km': 'ស្លាក', 'kn': 'ಲೇಬಲ್', 'ko': '레이블', 'lo': 'ປ້າຍ', 'lt': 'piešk.tekstą|pštk', 'lv': 'etiķete', 'ml': 'ലേബല്\u200d', 'mn': 'пайз', 'mr': 'लेबल', 'nb': 'etikett', 'nl': 'bijschrift', 'nn': 'etikett|label', 'oc': 'etiqueta', 'or': 'ନାମପଟି', 'pa_IN': 'ਲੇਬਲ', 'pt_BR': 'rotular|rotule', 'ro': 'label|etichetă', 'ru': 'надпись', 'sa_IN': 'अंकितकम्', 'sat': 'चिखना़', 'sd': 'ليبلُ', 'sid': 'somaasincho', 'si': 'ලේබලය', 'sk': 'popis', 'sl': 'oznaka', 'sq': 'etiketë', 'ta': 'லேபிள்', 'te': 'లేబుల్', 'th': 'ป้ายกำกับ', 'tr': 'etiket', 'ug': 'ئەن', 'uk': 'напис', 'vi': 'Nhãn', 'zh_CN': '标签|label', 'zh_TW': '標籤|label'},
'PENCOLOR':{'en_US': 'pencolor|pencolour|linecolor|pc', 'af': 'penkleur|lynkleur|pk', 'am': 'የ ብዕር ቀለም|የ ብዕር ቀለም|የ መስመር ቀለም|ብ/ቀ', 'ar': 'لون_القلم', 'ast': 'llapizcolor|lliniacolor|lc', 'bs': 'bojaolovke|bojaolovke|bojalinije|pc', 'ca': 'color.llapis|color.línia|cl', 'ca_valencia': 'color.llapis|color.línia|cl', 'ckb': '\u202bpencolor|pencolour|linecolor|pc', 'cs': 'barvapera|barvačáry|bp', 'de': 'stiftfarbe|linienfarbe|sf|lf', 'dsb': 'barwapisaka|barwalinije|bp|bl', 'el': 'χρώμαγραφίδας|χρώμαγραμμής|χγ|pencolor|pencolour|linecolor|pc', 'eo': 'plumkoloro|linikoloro|pk', 'es': 'color.lápiz|color.línea|cl', 'et': 'pliiatsi_värv|joonevärv|pv|jv', 'eu': 'lumakolorea|marrakolorea|lk', 'fi': 'kynänväri|kv', 'fr': 'couleurcrayon|ccrayon|couleurligne|cc', 'fy': 'penkleur|linekleur|pk', 'gl': 'estilocor|estilodacor|liñadecor|ec', 'gug': "sa'y.lápiz|sa'y.línea|cl", 'he': 'צבעעט|צבעט|צבעקו|צק', 'hr': 'boja olovke|boja olovke|boja linije|bo', 'hsb': 'barbapisaka|barbalinije|bp|bl', 'hu': 'tollszín|tollszín!|tsz!?|vonalszín', 'is': 'pennalitur|línulitur|pl', 'ja': 'ペンの色|線の色|pencolor|pc', 'kab': 'iniakeryun|inakeryun|inizirg|nk', 'kk': 'қалам_түсі|сызық_түсі|т', 'km': 'ពណ៌\u200bប៉ិក|pencolour|linecolor|pc', 'kn': 'ಲೇಖನಿಬಣ್ಣ|ಲೇಖನಿಯಬಣ್ಣ|ರೇಖೆಬಣ್ಣ|pc', 'ko': '펜색상|펜색상|선색상|pc', 'lo': 'pencolor|ສີປາກກາ|ສີເສັ້ນ|pc', 'lt': 'pieštuko.spalva|linijos.spalva|psp', 'lv': 'spalvas_krāsa|linijas_krāsa|sk', 'mn': 'үзэгний өнгө|шугамын өнгө|үөн|шөн', 'mr': 'पेनकलर|पेनकलर|लाइनकलर|pc', 'nb': 'pennfarge|pencolour|pf|linjefarge|pc', 'nl': 'penkleur|lijnkleur|pk', 'nn': 'pennfarge|linjefarge|pf|pencolor', 'oc': 'colorgredon|cgredon|colorlinha|cc', 'or': 'ପେନରଙ୍ଗ|ପେନରଙ୍ଗ|ଧାଡ଼ିରଙ୍ଗ|pc', 'pt_BR': 'mudarCorDoLápis|mCorLa|mudeCorDoLápis|mudecl', 'ro': 'pencolor|pencolour|linecolor|pc|culoarestilou', 'ru': 'цвет_пера|цвет_линии|ц', 'sid': 'biiretekuula|biiretekuula|xuruurukuula|bk', 'sk': 'farbapera|farbačiary|fp|fč', 'sl': 'barvaperesa|barvačrte|bp', 'sq': 'ngjyraestilolapsit|ngjyraestilolapsit|ngjyraevijës|pc', 'th': 'pencolor|สีปากกา|สีเส้น|pc', 'tr': 'kalemrengi|kalemrengi|satırrengi|kr', 'uk': 'колір_пера|колір_лінії|кп', 'vec': 'cołorpena|cołorpena|cołorłinea|pc', 'zh_CN': '笔颜色|笔色|线颜色|线色|pencolor|pencolour|linecolor|pc', 'zh_TW': '筆顏色|筆色|線顏色|線色|筆色彩|線色彩|pencolor|pencolour|linecolor|pc'},
'ANY':{'en_US': 'any', 'af': 'elke', 'am': 'ማንኛውም', 'ar': 'أي', 'as': 'যিকোনো', 'ast': 'cualquier', 'bn_IN': 'যেকোনো', 'bs': 'bilo koji', 'ca': 'qualsevol', 'ca_valencia': 'qualsevol', 'ckb': 'هەریەکێک', 'cy': 'unrhyw un', 'cs': 'libovolně|lib', 'de': 'beliebig|bel', 'dgo': 'कोई बी', 'dsb': 'někaki|nk', 'el': 'όλα|any', 'eo': 'ajna', 'es': 'cualquiera', 'et': 'mistahes', 'eu': 'edozein', 'fi': 'jokin', 'fr': 'tout', 'fy': 'elke', 'gd': 'gin', 'gl': 'calquera', 'gug': 'mavave', 'gu': 'કોઇપણ', 'he': 'כלשהו', 'hi': 'कोई भी', 'hr': 'bilo koja', 'hsb': 'někajki', 'hu': 'tetszőleges|tetsz', 'is': 'hvað sem er', 'ja': 'なんでも|どこでも|乱数|any', 'kab': 'a win yellan', 'kk': 'кез-келген', 'km': 'ណាមួយ', 'kn': 'ಯಾವುದಾದರೂ', 'kok': 'कोणूयKoncheim', 'ko': '모두', 'lo': 'ໃດໆ', 'lt': 'bet.kas', 'lv': 'jebkurš', 'ml': 'ഏതെങ്കിലും', 'mn': 'хамаагүй|хам', 'mr': 'कोणतेहि', 'nb': 'alle', 'nl': 'elke', 'nn': 'alle|any', 'oc': 'tot', 'or': 'ଯେକୌଣସି', 'pa_IN': 'ਕੋਈ ਵੀ', 'pt_BR': 'qualquer', 'ro': 'any|oricare', 'ru': 'любой', 'sa_IN': 'कांह तॊ', 'sat': 'जाहां गे', 'sd': 'ڪابە', 'sid': 'ayee', 'sk': 'ľubovoľný', 'sl': 'poljubno', 'sq': 'çdo', 'te': 'ఏదైనా', 'th': 'ใดๆ', 'tr': 'herhangi', 'uk': 'довільний', 'vec': 'tuto', 'zh_CN': '任意|any', 'zh_TW': '任一|any'},
'PENWIDTH':{'en_US': 'pensize|penwidth|linewidth|ps', 'af': 'pengrootte|pendikte|penbreedte|pg', 'am': 'የ ብዕር መጠን |የ ብዕር ስፋት |የ መስመር ስፋት |ps', 'ar': 'حجم_القلم|عرض_القلم', 'ast': 'llapiztamañu|llapizanchor|lliniaanchor|lt', 'bs': 'veličinaolovke|širinaolovke|širinalinije|ps', 'ca': 'mida.llapis|mida.línia|ml', 'ca_valencia': 'mida.llapis|mida.línia|ml', 'ckb': '\u202bpensize|penwidth|linewidth|ps', 'cs': 'tloušťkapera|tloušťkačáry|tp', 'de': 'stiftbreite|linienbreite|sb|lb', 'dsb': 'wjelikosćpisaka|šyrokosćpisaka|šyrokosćlinije|wp|šl', 'el': 'μέγεθοςγραφίδας|πλάτοςγραφίδας|πλάτοςγραμμής|μγ|pensize|penwidth|linewidth|ps', 'eo': 'plumlarĝo|plumgrando|pg', 'es': 'tamaño.lápiz|tl', 'et': 'pliiatsi_paksus|pliiatsi_jämedus|joonepaksus|joonelaius|jl', 'eu': 'lumatamaina|lumazabalera|marrazabalera|lz', 'fi': 'kynänleveys|kl', 'fr': 'tailleplume|taillecrayon|largeurligne|ta', 'fy': 'pengrutte|pentsjokte|penbreedte|pg', 'gl': 'estilotamaño|estilolargura|larguraliña|et', 'gug': 'tamaño.bolígrafo|tb', 'he': 'גודלעט|עוביעט|רוחבעט|גע', 'hr': 'veličina olovke|širina olovke|širina linije|vo', 'hsb': 'wulkosćpisaka|šěrokosćpisaka|šěrokosćlinije|wp|wl', 'hu': 'tollvastagság|tollvastagság!|tv!?|vonalvastagság', 'is': 'pennastærð|pennabreidd|línubreidd|ps', 'ja': 'ペンの太さ|線の太さ|penwidth|ps', 'kab': 'teɣziastillu|teɣziakeryun|tehrizirg|ts', 'kk': 'қалам_өлшемі|қалам_жуандығы|сызық_жуандығы|сж', 'km': 'ទំហំ\u200bប៉ិក|penwidth|linewidth|ps', 'kn': 'ಲೇಖನಿಗಾತ್ರ|ಲೇಖನಅಗಲ|ರೇಖೆಅಗಲ|ps', 'ko': '펜크기|펜너비|선너비|ps', 'lo': 'ຂະໜາດປາກກາ|ຄວາມກ້ວາງປາກກາ|ຄວາມກ້ວາງຂອງເສັ້ນ|ps', 'lt': 'pieštuko.storis|linijos.storis|ps', 'lv': 'spalvas_izmērs|spalvas_platums|līnijas_platums|sp', 'mn': 'үзэгний өргөн|шугамын өргөн|үөр|шөр', 'mr': 'पेनआकार|पेनरूंदी|रेघरूंदी|ps', 'nb': 'pennstørrelse|pennbredde|linjebredde|ps', 'nl': 'pengrootte|pendikte|penbreedte|pg', 'nn': 'pennstorleik|pennbreidd|linjebreidd|ps|pensize', 'or': 'ପେନଆକାର|ପେନଓସାର|ଧାଡ଼ିଓସାର|ps', 'pt_BR': 'mudarEspessuraDoLápis|mEspLa', 'ro': 'pensize|penwidth|linewidth|ps|mărimestilou', 'ru': 'размер_пера|толщина_пера|толщина_линии|тл', 'sid': 'biiretebikka|biiretebaqo|xuruurubaqo|bb', 'sk': 'hrúbkapera|hrúbkačiary|hp|hč', 'sl': 'velikostperesa|širinaperesa|širinačrte|vp', 'sq': 'madhësiaestilolapsit|gjerësiaestilolapsit|gjerësiaevijës|ps', 'tr': 'kalemboyutu|kalemgenişliği|satırgenişliği|kb', 'uk': 'розмір_пера|ширина_пера|ширина_лінії|рп', 'vec': 'grandesapena|łarghesapena|łarghesałinea|ps', 'zh_CN': '笔大小|笔粗|线粗|pensize|penwidth|linewidth|ps', 'zh_TW': '筆大小|筆粗|線粗|pensize|penwidth|linewidth|ps'},
'PENSTYLE':{'en_US': 'penstyle|linestyle', 'af': 'penstyl|lynstyl', 'am': 'የብዕር ዘዴ |የ መስመር ዘዴ', 'ar': 'نمط_القلم', 'ast': 'llapizestilu|lliniaestilu|le', 'be': 'стыль_пяра|стыль_лініі', 'bs': 'stilolovke|stillinije', 'ca': 'estil.llapis|estil.línia|el', 'ca_valencia': 'estil.llapis|estil.línia|el', 'cs': 'druhpera|druhčáry', 'de': 'stiftstil|linienstil|ss|ls', 'dsb': 'stilpisaka|linijowystil|sp|ls', 'el': 'μορφήγραφίδας|μορφήγραμμής|penstyle|linestyle', 'eo': 'plumstilo|linistilo', 'es': 'estilopluma|estilolínea', 'et': 'pliiatsi_stiil|joonestiil', 'eu': 'lumaestiloa|marraestiloa', 'fi': 'kynäntyyli', 'fr': 'stylecrayon|styleligne', 'fy': 'penstyl|linestyl|linestyl', 'gl': 'estiloestilo|estiloliña', 'gug': 'tipobolígrafo|estilolínea', 'he': 'סגנוןעט|סגנוןקו', 'hr': 'stil olovke|stil linije', 'hsb': 'stilpisaka|linijowystil|sp|ls', 'hu': 'tollstílus|vonalstílus', 'is': 'pennastíll|línustíll', 'ja': 'ペンの種類|線の種類|penstyle', 'kab': 'aɣanibakeryun|aɣanibizirig', 'kk': 'қалам_стилі|сызық_стилі', 'km': 'រចនាប័ទ្ម\u200bប៉ិក|linestyle', 'kn': 'ಲೇಖನಿಶೈಲಿ|ಗೆರೆಶೈಲಿ', 'ko': '펜스타일|선스타일', 'lo': 'ແບບປາກກາ|ແບບເສັ້ນ', 'lt': 'pieštuko.stilius|linijos.stilius', 'lv': 'spalvas_stils|līnijas_stils', 'mn': 'үзэгний загвар|шугамын загвар|үз|шз', 'mr': 'पेनशैली|रेघशैली', 'nb': 'pennstil|linjestil', 'nl': 'penstijl|lijnstijl|lijnopmaak', 'nn': 'pennstil|linjestil|penstyle', 'or': 'ପେନଶୈଳୀ|linestyle', 'pa_IN': 'ਪੈੱਨ ਸਟਾਈਲ|ਲਾਈਨ ਸਟਾਈਲ', 'pt_BR': 'mudarEstiloDoLápis|mEstLa', 'ro': 'penstyle|linestyle|stilstilou', 'ru': 'стиль_пера|стиль_линии', 'sid': 'biireteakata|xuruuruakata', 'sk': 'štýlpera|štýlčiary|šp|šč', 'sl': 'slogperesa|slogčrte', 'sq': 'stiliistilolapsit|stiliivijës', 'th': 'กระบวนแบบปากกา|กระบวนแบบเส้น', 'tr': 'kalembiçemi|satırbiçemi', 'uk': 'стиль_пера|стиль_лінії', 'vec': 'stiłepena|stiłełinea', 'zh_CN': '笔型|线型|笔样式|线样式|penstyle|linestyle', 'zh_TW': '筆樣式|線樣式|penstyle|linestyle'},
'PENJOINT':{'en_US': 'penjoint|linejoint', 'af': 'pen-oorgang|lyn-oorgang', 'am': 'የብዕር መገናኛ |የመስመር መገናኛ', 'ast': 'llapizxunir|lliniaxunir|lx', 'bs': 'vezaolovke|vezalinije', 'ca': 'unió.llapis|unió.línia|ul', 'ca_valencia': 'unió.llapis|unió.línia|ul', 'cs': 'napojenípera|napojeníčáry', 'de': 'stiftübergang|linienübergang|sü|lü', 'dsb': 'pśechadpisaka|pśechadlinije|pp|pl', 'el': 'ένωσηγραφίδας|ένωσηγραμμής|penjoint|linejoint', 'eo': 'liniartiko|plumligo', 'es': 'conjuntopluma|conjuntolínea', 'et': 'pliiatsiühendus|jooneühendus', 'eu': 'lumajuntura|marrajuntura', 'fi': 'kynänmuoto', 'fr': 'jointurestylo|jointureligne', 'fy': 'penferbining|lineferbining', 'gl': 'estilounión|uniónliña', 'gug': 'atybolígrafo|atylínea', 'he': 'מצרףעט|מצרףקו', 'hr': 'spoj olovke|spoj linije', 'hsb': 'přechadpisaka|přechdlinije|pp|pl', 'hu': 'tollsarok|vonalsarok', 'is': 'pennaskeyting|línuskeyting', 'ja': 'ペンのつなぎ方|角のつなぎ方|penjoint', 'kab': 'asemlilastillu|asemlilizirig', 'kk': 'қаламды_біріктіру|сызықтарды_біріктіру', 'kn': 'ಲೇಖನಿಜೋಡಣೆ|ರೇಖೆಜೋಡಣೆ', 'ko': '펜조인트|선조인트', 'lo': 'ປາກກາຕໍ່ກັນ|ເສັ້ນຕໍ່ກັນ', 'lt': 'pieštuko.sujungimas|linijos.sujungimas|psj', 'lv': 'spalvas_salaidums|līnijas_salaidums', 'mn': 'үзэг шилжилт|мөр шилжилт', 'mr': 'पेनजॉइंट|लाइनजॉइंट', 'nb': 'linjekobling|penjoint', 'nl': 'penverbinding|lijnverbinding', 'nn': 'linjekopling|penjoint', 'or': 'ପେନସନ୍ଧି|linejoint', 'pa_IN': 'ਪੈੱਨ ਜੁਆਇੰਟIਲਾਈਨ ਜੁਆਇੰਟ', 'pt_BR': 'mudarCantoDaLinha|mCanLi', 'ro': 'penjoint|linejoint|colțstilou', 'ru': 'соединить_перо|соединить_линии', 'sid': 'biiretexaado|xuruuruxaado', 'sk': 'napojeniepera|napojeniečiary|np|nč', 'sl': 'stikperesa|stikčrt', 'sq': 'bashkimiistilolapsit|bashkimiivijës', 'tr': 'kalembirleşimi|satırbirleşimi', 'uk': 'сполучити_перо|сполучити_лінії', 'vec': 'zontapena|zontałinea', 'zh_CN': '笔接点|线接点|线接|penjoint|linejoint', 'zh_TW': '筆接點|線接點|線接|penjoint|linejoint'},
'PENCAP':{'en_US': 'pencap|linecap', 'af': 'pen-einde|lyn-einde', 'am': 'የብዕር መገናኛ |የመስመር መገናኛ', 'ast': 'finllapiz|finllinia', 'br': 'pennkreion|pennlinenn', 'ca': 'tap.llapis|final.línia|extrem.línia', 'ca_valencia': 'tap.llapis|final.línia|extrem.línia', 'cs': 'zakončenípera|zakončeníčáry', 'de': 'stiftende|linienende|se|le', 'dsb': 'kóńcpisaka|kóńclinije|kp|kl', 'el': 'άκρογραφίδας|άκρογραμμής|pencap|linecap', 'eo': 'plumĉapo|liniĉapo', 'es': 'fin.línea|punta.línea|fl', 'et': 'jooneots', 'eu': 'lumaestalkia|marraestalkia', 'fi': 'viivanpää', 'fr': 'coiffecrayon|coiffeligne', 'fy': 'penein|lineein', 'gl': 'rematelápis|remateliña', 'gug': 'tapabolígrafo|kyta.línea', 'he': 'סיומתעט|סיומתקו', 'hr': 'vrh olovke|vrh linije', 'hsb': 'kónčkpisaka|kónčklinije|kp|kl', 'hu': 'tollhegy|vonalvég', 'is': 'pennaendi|línuendi', 'ja': 'ペンのはじ|線のはじ|linecap', 'kab': 'tacacitastillu|tacacitizirig', 'kk': 'сызық_басы|сызық_аяғы', 'kn': 'ಲೇಖನಿಕ್ಯಾಪ್|ಸಾಲಿನಕ್ಯಾಪ್', 'ko': '펜끝|선끝', 'lt': 'pieštuko.pabaiga|linijos.pabaiga|pp', 'lv': 'spalvas_gals|līnijas_gals', 'mn': 'үзэгний төгсгөл|шугамын төгсгөл', 'nb': 'linjeende|pencap|linecap', 'nl': 'peneinde|lijneinde', 'nn': 'linjeende|pencap|linecap', 'oc': 'coifagredon|coifalinha', 'pa_IN': 'ਪੈੱਨ ਕੈਪIਲਾਈਨ ਕੈਪ', 'pt_BR': 'mudarPontaDoLápis|mPonLa|mPonLi', 'ro': 'pencap|linecap|capătstilou', 'ru': 'угол_пера|угол_линии', 'sk': 'zakončeniepera|zakončeniečiary|zp|zč', 'sl': 'konicaperesa|konicačrte', 'tr': 'kalemyazısı|satıryazısı', 'ug': 'قەلەم ئىزى|سىزىق ئىزى|pencap|linecap', 'uk': 'шапка пера|шапка лінії', 'vec': 'pontapena|pontałinea', 'zh_CN': '笔帽|线帽|笔端帽|线端帽|pencap|linecap', 'zh_TW': '筆端帽|線端帽|線端|pencap|linecap'},
'NONE':{'en_US': 'none', 'af': 'geen', 'am': 'ምንም', 'ar': 'بلا', 'as': 'কোনো নহয়', 'ast': 'dengún', 'be': 'няма', 'bn_IN': 'কোনটি না', 'bn': 'কোনটি না', 'bo': 'མེད་པ།', 'br': 'tra ebet', 'brx': 'रावबो नङा', 'bs': 'ništa', 'ca': 'cap', 'ca_valencia': 'cap', 'ckb': 'هیچ', 'cy': 'dim', 'cs': 'žádné', 'de': 'kein', 'dgo': 'कोई नेईं', 'dsb': 'žeden', 'dz': 'ཅི་མེད།', 'el': 'κανένα', 'eo': 'neniu', 'es': 'ninguno', 'et': 'puudub', 'eu': 'bat ere ez', 'fa': 'هیچ\u200cکدام', 'fi': 'eimitään', 'fr': 'aucun(e)', 'fy': 'gjint', 'gd': 'chan eil gin', 'gl': 'ningún', 'gug': 'mavave', 'gu': 'કંઇ નહિં', 'he': 'ללא', 'hi': 'कोई नहीं', 'hr': 'ništa', 'hsb': 'žadyn', 'hu': 'nincs', 'id': 'tak ada', 'is': 'ekkert', 'ja': 'つながない|none', 'kab': 'ula yiwen', 'ka': 'ცარიელი', 'kk': 'жоқ', 'km': 'គ្មាន', 'kmr_Latn': 'ne yek jî', 'kn': 'ಏನೂ ಇಲ್ಲ', 'kok': 'कोण ना', 'ko': '없음', 'ks': 'كہین نئ', 'lb': 'keen', 'lo': 'ບໍ່ມີ', 'lt': 'nieko', 'lv': 'nav', 'mai': 'किछु नहि', 'mk': 'Нема', 'ml': 'ഒന്നുമില്ല', 'mni': 'অমত্তা নত্তবা', 'mn': 'байхгүй', 'mr': 'काहीही नाही', 'my': 'မရှိပါ', 'nb': 'ingen', 'ne': 'कुनै पनि होइन', 'nl': 'geen', 'nn': 'ingen|none', 'nso': 'ga go na selo', 'oc': 'pas cap', 'om': 'homaa', 'or': 'କିଛି ନାହିଁ', 'pa_IN': 'ਕੋਈ ਨਹੀਂ', 'pt_BR': 'nenhum', 'ro': 'none|nimic', 'ru': 'нет', 'rw': 'ntacyo', 'sa_IN': 'न कोऽपि', 'sat': 'ओका हों बाङजाहानाक् बाङ', 'sd': 'ڪجهہ بہ نہ', 'sid': 'dino', 'si': 'කිසිවක් නැත', 'sk': 'žiadne', 'sl': 'brez', 'sq': 'asnjë', 'st': 'ha di teng', 'sw_TZ': 'bila', 'ta': 'ஏதுமில்லை', 'te': 'ఏదీ కాదు', 'tg': 'ягон', 'th': 'ไม่มี', 'tn': 'sepe', 'tr': 'hiçbiri', 'ts': 'ku hava', 'ug': 'يوق', 'uk': 'немає', 'uz': 'yoʻq', 've': 'a huna', 'vi': 'không có', 'xh': 'akukho', 'zh_CN': '无|none', 'zh_TW': '無|none', 'zu': 'lutho'},
'BEVEL':{'en_US': 'bevel', 'af': 'afskuinsing', 'am': 'ስላሽ', 'ar': 'مشطوف', 'ast': 'moldura', 'be': 'скос', 'bn_IN': 'স্তর', 'br': 'beskell', 'bs': 'kosina', 'ca': 'bisell', 'ca_valencia': 'bisell', 'cy': 'befel', 'cs': 'šikmé', 'de': 'schräg', 'dsb': 'nakósny', 'el': 'λοξό|bevel', 'eo': 'bivela', 'es': 'bisel', 'et': 'faasitud', 'eu': 'alakatua', 'fi': 'viisto', 'fr': 'biseau', 'fy': 'skean dwaan', 'gd': 'beibheal', 'gl': 'bisel', 'gug': 'bisel', 'gu': 'સ્તર', 'he': 'קטום', 'hi': 'स्तर', 'hr': 'stožac', 'hsb': 'nakósny', 'hu': 'tompa', 'is': 'flái', 'ja': '角を落とす|bevel', 'ka': 'დონე', 'kk': 'көлбеу', 'km': 'ជ្រុង\u200bទេរ', 'kn': 'ಸ್ತರ', 'ko': '수준', 'lo': 'ອ່ຽງ', 'lt': 'nuožulnus', 'lv': 'nošķelts', 'ml': 'തലം', 'mn': 'налуу', 'mr': 'बेवेल', 'my': 'အဆင့်', 'nb': 'skråkant', 'ne': 'स्तर', 'nl': 'afschuinen', 'nn': 'skråkant|bevel', 'oc': 'bisèl', 'or': 'ସ୍ତର', 'pa_IN': 'ਲੈਵਲ', 'pt_BR': 'cortado', 'ro': 'bevel|teșit', 'ru': 'скос', 'sid': 'beevele', 'si': 'මට්ටම', 'sk': 'šikmé', 'sl': 'vbočeno', 'sq': 'nivel', 'ta': 'பெவல்', 'te': 'స్థాయి', 'tr': 'eğim', 'ug': 'يانتۇ يۈز', 'uk': 'скіс', 'vec': 'scanton', 'vi': 'Cấp', 'zh_CN': '平角|bevel', 'zh_TW': '平角|bevel'},
'MITER':{'en_US': 'miter', 'af': 'hoeksny', 'am': 'መጋጠሚያ', 'ar': 'قلنسوة', 'ast': 'inglete', 'br': 'garan', 'bs': 'kosispoj', 'ca': 'esbiaixa|biaix', 'ca_valencia': 'esbiaixa|biaix', 'cy': 'meitr', 'cs': 'ostré', 'de': 'gehrung', 'dsb': 'prěcnyrěz', 'el': 'μύτη|miter', 'eo': 'oblikva', 'es': 'mitra|inglete|bies', 'et': 'terav', 'eu': 'ebakia', 'fi': 'jiiri', 'fr': 'mitre', 'fy': 'snijend', 'gd': 'bairrin', 'gl': 'bispel', 'gug': 'mitra|inglete|bies', 'gu': 'મિટર', 'he': 'משלים', 'hi': 'माइटर', 'hr': 'koljeno', 'hsb': 'nakosa', 'hu': 'hegyes', 'id': 'siku', 'is': 'hornskeyting', 'ja': '角をとがらせる|miter', 'kab': 'tacacit n upapas', 'kk': 'көлбеу45', 'km': 'ផ្គុំ', 'kn': 'ಮಿಟರ್', 'ko': '미터', 'lt': 'kampinis', 'lv': 'spics', 'mn': 'татуурга', 'mr': 'मीटर', 'nb': 'skarp', 'nl': 'snijdend', 'nn': 'skarp|miter', 'oc': 'mitra', 'or': 'ମିଟର', 'pa_IN': 'ਕਣ', 'pt_BR': 'pontudo', 'ro': 'miter|ascuțit', 'ru': 'скос45', 'sid': 'metire', 'sk': 'ostré', 'sl': 'izbočeno', 'ta': 'மைட்டர்', 'tr': 'köşe', 'ug': 'چېتىق', 'uk': 'скіс45', 'vec': 'zontacantoni', 'zh_CN': '尖角|miter', 'zh_TW': '尖角|miter'},
'ROUNDED':{'en_US': 'round', 'af': 'ronding', 'am': 'ክብ', 'ar': 'دائري', 'as': 'গোলাকাৰ', 'ast': 'redondu', 'be': 'круглы', 'bn_IN': 'রাউন্ড', 'br': 'ront', 'bs': 'okruglo', 'ca': 'arrodoneix|arrod', 'ca_valencia': 'arredoneix|arred', 'ckb': 'خولاوە', 'cy': 'crwn', 'cs': 'oblé', 'de': 'rund', 'dsb': 'kulowaty', 'el': 'στρογγυλό|round', 'eo': 'ronda', 'es': 'redondear', 'et': 'ümar', 'eu': 'biribildua', 'fi': 'pyöreä', 'fr': 'arrondi', 'fy': 'rûn', 'gd': 'cruinn', 'gl': 'arredondar', 'gug': "emoapu'a", 'gu': 'રાઉન્ડ', 'he': 'עגול', 'hi': 'गोल', 'hr': 'okruglo', 'hsb': 'kulojty', 'hu': 'kerek', 'id': 'bulatan ujung', 'is': 'rúnnað', 'ja': '角を丸くする|round', 'kab': 'yattwaẓ', 'ka': 'მრგვალი', 'kk': 'домалақтау', 'km': 'មូល', 'kn': 'ದುಂಡಾದ', 'ko': '반올림', 'lo': 'ຮອບ', 'lt': 'apvalus', 'lv': 'apaļš', 'ml': 'ഉരുണ്ട', 'mn': 'дугуй', 'mr': 'गोलाकार', 'my': 'ပတ်လည်', 'nb': 'avrunde', 'ne': 'गोलाकार', 'nl': 'rondaf', 'nn': 'avrunda|round', 'oc': 'arredondit', 'or': 'ଗୋଲାକାର', 'pa_IN': 'ਗੋਲ', 'pt_BR': 'arredondado', 'ro': 'round|rotund', 'ru': 'скруглить', 'sid': 'doyssi', 'si': 'වටකුරු', 'sk': 'zaoblené', 'sl': 'zaobljeno', 'sq': 'rrumbullak', 'ta': 'வட்டம்', 'te': 'రౌండ్', 'tr': 'yuvarla', 'ug': 'يۇمۇلاق', 'uk': 'закруглити', 'vec': 'stondà', 'vi': 'Làm tròn', 'zh_CN': '圆角|rounded|round', 'zh_TW': '圓角|round'},
'SOLID':{'en_US': 'solid', 'af': 'solied', 'am': 'ሙሉ', 'ar': 'صلب', 'as': 'কঠিন', 'ast': 'sólidu', 'be': 'суцэльны', 'bn_IN': 'নিরেট', 'br': 'unvan', 'bs': 'čvrsto', 'ca': 'sòlid', 'ca_valencia': 'sòlid', 'ckb': 'ڕەق', 'cy': 'solet', 'cs': 'plná', 'de': 'voll', 'dsb': 'połny', 'el': 'συμπαγές|solid', 'eo': 'solida', 'es': 'sólido', 'et': 'pidev', 'eu': 'solidoa', 'fi': 'yhtenäinen', 'fr': 'plein', 'fy': 'fol', 'gd': 'soladach', 'gl': 'sólido', 'gug': 'hatã', 'gu': 'ઘટ્ટ', 'he': 'אחיד', 'hi': 'ठोस', 'hr': 'puno', 'hsb': 'połny', 'hu': 'folyamatos', 'id': 'padat', 'is': 'einlitt', 'ja': '実線|ふつうの線|solid', 'kab': 'aččuran', 'ka': 'მყარი', 'kk': 'бүтін', 'km': 'តាន់', 'kn': 'ಘನ', 'ko': '단색', 'lo': 'ແນ່ນ', 'lt': 'vientisas', 'lv': 'vienlaidu', 'mn': 'дүүрэн', 'mr': 'गडद', 'nb': 'ensfarget', 'ne': 'ठोस', 'nl': 'vol', 'nn': 'einsfarga|solid', 'oc': 'plen', 'or': 'କଠିନ', 'pa_IN': 'ਗੂੜ੍ਹਾ', 'pt_BR': 'sólido', 'ro': 'solid|continuu', 'ru': 'сплошная', 'sa_IN': 'ठोस', 'sat': 'जिनिस', 'sd': 'ٺوس', 'sid': 'kaajjado', 'sk': 'vyplnené', 'sl': 'polno', 'sq': 'e ngurtë', 'ta': 'திடம்', 'te': 'గట్టి', 'th': 'ทึบ', 'tr': 'düz', 'ug': 'ئۇيۇل', 'uk': 'суцільна', 'vec': 'sòłido', 'vi': 'Đặc', 'zh_CN': '实线|solid', 'zh_TW': '實線|solid'},
'DASH':{'en_US': 'dashed', 'af': 'gestreep', 'am': 'ዳሽ', 'ar': 'متقطع', 'as': 'ডেশ্বযুক্ত', 'ast': 'discontinuu', 'be': 'рыскі', 'bn_IN': 'ড্যাশযুক্ত', 'br': 'gourzhelloù', 'bs': 'isprekidano', 'ca': 'traçat', 'ca_valencia': 'traçat', 'ckb': 'هێڵی پچڕ پچر', 'cy': 'dashedig', 'cs': 'čárkovaná', 'de': 'gestrichelt', 'dsb': 'smužkowany', 'el': 'με παύλες|dashed', 'eo': 'streketa', 'es': 'discontinua', 'et': 'kriipsudega', 'eu': 'marratua', 'fi': 'katkonainen', 'fr': 'tiret', 'fy': 'strepe', 'gd': 'strìochagach', 'gl': 'raiado', 'gug': 'discontinua', 'gu': 'તૂટક', 'he': 'מיקוף', 'hi': 'डैश किया हुआ', 'hr': 'iscrtkano', 'hsb': 'smužkowany', 'hu': 'szaggatott', 'id': 'garis putus', 'is': 'strikað', 'ja': '破線|dashed', 'kab': 'tizdit', 'ka': 'წყვეტილი', 'kk': 'штрихті', 'km': '\u200bដាច់ៗ', 'kn': 'ಅಡ್ಡಗೆರೆಗಳುಳ್ಳ', 'ko': '파선', 'lo': 'ເຄື່ອງໝາຍເສັ້ນເປັນວັກ', 'lt': 'brūkšneliai', 'lv': 'svītrots', 'ml': 'ഡാഷ്ഡ്', 'mn': 'зураасласан', 'mr': 'डॅश्ड', 'my': 'မျဉ်းရှည်', 'nb': 'stiplet', 'ne': 'ड्यासभएको', 'nl': 'gestreept', 'nn': 'stipla|streka|dashed', 'oc': 'jonhent', 'or': 'ଡାସ', 'pa_IN': 'ਧਾਰੀਦਾਰ', 'pt_BR': 'tracejado', 'ro': 'dashed|culiniuțe', 'ru': 'штриховая', 'sid': 'daashshaamo', 'si': 'ඉරි යෙදූ', 'sk': 'Čiarky', 'sl': 'črtkano', 'sq': 'e ndërprerë', 'ta': 'டேஷ்', 'te': 'గీతగీయబడెను', 'th': 'เส้นประ', 'tr': 'kesik çizgi', 'ug': 'سىزىقچە', 'uk': 'штрихова', 'vec': 'tratejà', 'vi': 'Gạch gạch', 'zh_CN': '虚线|dashed', 'zh_TW': '虛線|dashed'},
'DOTTED':{'en_US': 'dotted', 'af': 'gestippel', 'am': 'ነጠብጣብ', 'ar': 'منقط', 'as': 'ডটেড', 'ast': 'puntiáu', 'be': 'пункцір', 'bn_IN': 'ডটেড', 'br': 'pikennaoueg', 'bs': 'tačkasto', 'ca': 'puntejat', 'ca_valencia': 'puntejat', 'ckb': 'خاڵکراو', 'cy': 'dotiog', 'cs': 'tečkovaná', 'de': 'gepunktet', 'dgo': 'बिंदीदार', 'dsb': 'dypkaty', 'el': 'διάστικτο|dotted', 'eo': 'punkta', 'es': 'punteado', 'et': 'punktiir', 'eu': 'puntukatua', 'fi': 'pisteistä', 'fr': 'pointillé', 'fy': 'stippele', 'gd': 'dotagach', 'gl': 'punteado', 'gug': "kyta'i kuéra", 'gu': 'ટપકાંવાળુ', 'he': 'ניקוד', 'hi': 'बिंदुयुक्त', 'hr': 'istočkano', 'hsb': 'dypkowany', 'hu': 'pontozott', 'id': 'garis noktah', 'is': 'punktalína', 'ja': '点線|dotted', 'kab': 's tneqqiḍin', 'ka': 'წერტილოვანი', 'kk': 'пунктирлі', 'km': 'ចុចៗ', 'kn': 'ಚುಕ್ಕಿಯುಕ್ತ', 'kok': "डॉटडTiboyil'lem", 'ko': '점선', 'lo': 'ເສັ້ນຈຸດເປັນວັກ', 'lt': 'taškeliai', 'lv': 'punktēts', 'ml': 'ഡോട്ടുള്ള', 'mn': 'цэгтэй', 'mr': 'डॉटेड', 'my': 'အစက်', 'nb': 'prikket', 'nl': 'gestippeld', 'nn': 'prikka|dotted', 'oc': 'puntejat', 'or': 'ବିନ୍ଦୁମୟ', 'pa_IN': 'ਬਿੰਦੂ', 'pt_BR': 'pontilhado', 'ro': 'dotted|punctat', 'ru': 'пунктирная', 'sa_IN': 'डाटिड', 'sat': 'टुडा़क् आकान', 'sd': 'نقطن وارو', 'sid': 'bixxillisama', 'si': 'තිත් වැටුනු', 'sk': 'Bodkované', 'sl': 'pikasto', 'sq': 'me pika', 'ta': 'புள்ளியிட்ட', 'te': 'చుక్కలు', 'th': 'จุดประ', 'tr': 'noktalı', 'ug': 'چېكىت سىزىق', 'uk': 'пунктирна', 'vec': 'pontinà', 'vi': 'Chấm chấm', 'zh_CN': '点线|dotted', 'zh_TW': '點線|dotted'},
'CLOSE':{'en_US': 'close', 'af': 'sluit', 'am': 'መዝጊያ', 'ar': 'أغلق', 'as': 'বন্ধ কৰক', 'ast': 'zarrar', 'be': 'закрыць', 'bn_IN': 'বন্ধ', 'br': 'serriñ', 'bs': 'blizu', 'ca': 'tanca', 'ca_valencia': 'tanca', 'ckb': 'داخستن', 'cy': 'cau', 'cs': 'uzavři', 'de': 'schliessen|schließen', 'dsb': 'zacyniś', 'el': 'κλείσιμο|close', 'eo': 'fermu', 'es': 'cerrar', 'et': 'sulge', 'eu': 'itxi', 'fi': 'sulje', 'fr': 'fermer', 'fy': 'slute', 'gl': 'pechar', 'gug': 'mboty', 'gu': 'બંધ કરો', 'he': 'סגירה', 'hi': 'बन्द करें', 'hr': 'zatvori', 'hsb': 'začinić', 'hu': 'zár', 'id': 'tutup', 'is': 'loka', 'ja': '折れ線を閉じる|close', 'kab': 'mdel', 'ka': 'დახურვა', 'kk': 'жабу', 'km': 'បិទ', 'kn': 'ಮುಚ್ಚು', 'ko': '닫기', 'lo': 'ປິດ', 'lt': 'sujunk', 'lv': 'aizvērt', 'ml': 'അടയ്ക്കുക', 'mn': 'хаах', 'mr': 'बंद करा', 'my': 'ပိတ်ပါ', 'nb': 'lukk', 'ne': 'बन्द गर्नुहोस्', 'nl': 'sluiten', 'nn': 'lukk|close', 'oc': 'tampar', 'or': 'ବନ୍ଦ କରନ୍ତୁ', 'pa_IN': 'ਬੰਦ ਕਰੋ', 'pt_BR': 'fechar|feche', 'ro': 'close|închide', 'ru': 'закрыть', 'sid': 'cufi', 'si': 'වසන්න', 'sk': 'Zatvoriť', 'sl': 'zaključi', 'sq': 'mbylle', 'ta': 'மூடு', 'te': 'మూయు', 'th': 'ปิด', 'tr': 'kapat', 'ug': 'ياپ', 'uk': 'закрити', 'vec': 'sarà', 'vi': 'Đóng', 'zh_CN': '关闭|close', 'zh_TW': '關閉|close'},
'FILL':{'en_US': 'fill', 'af': 'vul in', 'am': 'መሙያ', 'ar': 'املأ', 'as': 'পূৰ্ণ কৰক', 'ast': 'rellenar', 'be': 'запаўненне', 'bn_IN': 'পূরণ করুন', 'br': 'leuniañ', 'bs': 'popuni', 'ca': 'omple|emplena', 'ca_valencia': 'omple|ompli', 'ckb': 'پڕی', 'cy': 'llanw', 'cs': 'vyplň', 'de': 'füllen', 'dgo': 'भराई', 'dsb': 'połniś', 'el': 'γέμισμα|fill', 'eo': 'plenigu', 'es': 'relleno|rellenar', 'et': 'täida', 'eu': 'bete', 'fi': 'täytä', 'fr': 'remplir', 'fy': 'folje', 'gl': 'encher', 'gug': 'myenyhẽ', 'gu': 'ભરો', 'he': 'מילוי', 'hi': 'भरें', 'hr': 'ispuni', 'hsb': 'pjelnić', 'hu': 'tölt', 'id': 'isian', 'is': 'fylling', 'ja': '塗りつぶし|fill', 'kab': 'ččar', 'ka': 'შევსება', 'kk': 'толтыру', 'km': 'បំពេញ', 'kn': 'ತುಂಬಿಸು', 'ko': '채우기', 'lo': 'ຕື່ມໃສ່', 'lt': 'spalvink', 'lv': 'aizpildīt', 'ml': 'നിറയ്ക്കുക', 'mn': 'дүүргэх', 'mr': 'भरा', 'my': 'ဖြည့်ပါ', 'nb': 'fyll', 'ne': 'भर्नुहोस्', 'nl': 'vullen', 'nn': 'fyll|fill', 'oc': 'emplenar', 'or': 'ପୁରଣ କରନ୍ତୁ', 'pa_IN': 'ਭਰੋ', 'pt_BR': 'pintar|pinte|preencher', 'ro': 'fill|umplere', 'ru': 'заливка', 'sid': 'wonshi', 'sk': 'výplň', 'sl': 'zapolni', 'sq': 'mbush', 'ta': 'நிரப்பு', 'te': 'నింపు', 'th': 'เติม', 'tr': 'doldur', 'ug': 'تولدۇر', 'uk': 'заповнення', 'vec': 'pien', 'zh_CN': '填充|fill', 'zh_TW': '填入|fill'},
'FILLCOLOR':{'en_US': 'fillcolor|fillcolour|fc', 'af': 'vulkleur|vk', 'am': 'ቀለም መሙያ|ቀለም መሙያ|ቀ.መ', 'ar': 'ملأ_لون', 'ast': 'colorrellenu|cr', 'bs': 'popuniboju|popuniboju|fc', 'ca': 'color.emplenament|ce', 'ca_valencia': 'color.emplenament|ce', 'cs': 'barvavýplně|bv', 'de': 'füllfarbe|ff', 'dsb': 'połnjecabarwa|pb', 'el': 'χρώμαγεμίσματος|χε|fillcolor|fillcolour|fc', 'eo': 'pleniga_koloro|plenkoloro|plk', 'es': 'color.relleno|relleno.color|cr|fc', 'et': 'täitevärv|tv', 'eu': 'betetzekolorea|bk', 'fi': 'täyttöväri|tv', 'fr': 'couleurremplissage|cremplissage|cr', 'fy': 'opfolkleur|ok', 'gl': 'cambiarcor|cambiodecor|cc', 'gug': "sa'y.henyhe|ch", 'he': 'צבעמילוי|צמ', 'hr': 'boja punjenja|boja punjenja|bp', 'hsb': 'pjelnjacabarba|pb', 'hu': 'töltőszín|töltőszín!|tlsz!?', 'is': 'fyllilitur|fl', 'ja': '塗りつぶしの色|fillcolor|fc', 'kab': 'initaččart|ččarini|či', 'kk': 'толтыру_түсі|тт', 'km': 'ពណ៌\u200bបំពេញ|fillcolour|fc', 'kn': 'ಬಣ್ಣತುಂಬಿಸು|ಬಣ್ಣತುಂಬಿಸು|fc', 'ko': '색상채우기|색상채우기|fc', 'lo': 'fillcolor|ຕື່ມສີ|fc', 'lt': 'spalvinimo.spalva|ssp', 'lv': 'pildījuma_krāsa|pk', 'mn': 'өнгөдүүргэх|өнгөдүүргэх|fc', 'mr': 'फिलकलर|फिलकलर|fc', 'nb': 'fyllfarge|ff', 'nl': 'opvulkleur|ok', 'nn': 'fyllfarge|ff|fillcolor', 'oc': 'coloremplenatge|coloremplenatge|cr', 'or': 'ରଙ୍ଗପୁରଣ|ରଙ୍ଗପୁରଣ|fc', 'pt_BR': 'mudarCorDaPintura|mCorPi|mudecp', 'ro': 'fillcolor|fillcolour|fc|culoareumplere', 'ru': 'цвет_заливки|цз', 'sid': 'kuulawonshi|kuulawonshi|kw', 'sk': 'farbavýplne|fv', 'sl': 'barvapolnila|polnilnabarva|bp', 'sq': 'ngjyraeplotësimit|ngjyraeplotësimit|fc', 'tr': 'renkdoldur|renkdoldur|rd', 'uk': 'колір_заповнення|кз', 'vec': 'cołorpien|cołorpien|fc', 'zh_CN': '填充颜色|填充色|填色|fillcolor|fillcolour|fc', 'zh_TW': '填入顏色|填入色彩|填色|fillcolor|fillcolour|fc'},
'FILLTRANSPARENCY':{'en_US': 'filltransparency', 'af': 'vuldeursigtigheid', 'am': 'ግልጽነት መሙያ', 'ar': 'ملأ_شفافية', 'ast': 'tresparencia.rellenu', 'br': 'boullderleuniañ', 'ca': 'transparència.emplenament', 'ca_valencia': 'transparència.emplenament', 'cs': 'průhlednostvýplně|průhlvýplně', 'de': 'fülltransparenz|ft', 'dsb': 'połnjecatransparenca', 'el': 'διαφάνειαγεμίσματος', 'eo': 'plenigtravideblo', 'es': 'relleno.transparencia|transparencia.relleno', 'et': 'täite_läbipaistvus|tlp', 'eu': 'betetzegardentasuna', 'fi': 'täyttöläpinäkyvyys', 'fr': 'transparenceremplir', 'fy': 'follingtrochsichtigens', 'gl': 'transparenciarecheo', 'gug': 'myenyhẽ.tesakã', 'he': 'שקיפות_המילוי', 'hr': 'prozirnostispune', 'hsb': 'pjelnjacatransparenca', 'hu': 'töltőátlátszóság', 'is': 'fylligegnsæi', 'ja': '塗りつぶしの透明度|filltransparency', 'kab': 'tafrawantččar', 'kk': 'толтыру_мөлдірлілігі', 'km': 'បំពេញ\u200bភាព\u200bថ្លា', 'kn': 'ಪಾರದರ್ಶಕತೆಭರ್ತಿಮಾಡು', 'ko': '투명채우기', 'lo': 'ຕື່ມຂໍ້ມູນໃສ່ຄວາມໂປ່ງໃສ', 'lt': 'spalvinimo.skaidrumas|ssk', 'lv': 'pildījuma_caurspīdīgums', 'mn': 'өнгөгүйдүүргэлт', 'nb': 'fyllgjennomsiktighet', 'nl': 'vullingstransparantie', 'nn': 'fyllgjennomsikt', 'oc': 'transparénciaemplenar', 'or': 'ପୂରଣସ୍ୱଚ୍ଛତା', 'pa_IN': 'ਪਾਰਦਰਸ਼ਤਾ ਭਰੋ', 'pt_BR': 'mudarTransparênciaDaPintura|mTraPi', 'ru': 'прозр_заливки|пз', 'sk': 'priehľadnosťvýplne|pv', 'sl': 'prosojnostpolnila', 'sq': 'transparencaembushjes', 'tr': 'şeffaflıkladoldur', 'ug': 'تولدۇرۇش سۈزۈكلۈكى', 'uk': 'прозорість_заповнення', 'vec': 'trasparensapien', 'zh_CN': '填充透明|填透明|filltransparency', 'zh_TW': '填入透明|填透明|filltransparency'},
'PENTRANSPARENCY':{'en_US': 'pentransparency|linetransparency', 'af': 'pen-deursigtigheid|lyn-deursigtigheid', 'ar': 'شفافية_القلم', 'ast': 'tresparenciallápiz|tresparenciallinia', 'br': 'boullderkreion|boullderlinenn', 'ca': 'llapis.transparència|línia.transparència', 'ca_valencia': 'llapis.transparència|línia.transparència', 'cs': 'průhlednostpera|průhlednostčáry|průhlpera|průhlčáry', 'de': 'stifttransparenz|linientransparenz|st|lt', 'dsb': 'transparencapisaka|transparencalinije|tp|tl', 'el': 'διαφάνειαγραφίδας|διαφάνειαγραμμής', 'eo': 'plumtravideblo|linitravideblo', 'es': 'pluma.transparencia|línea.transparencia|transparencia.pluma|transparencia.línea', 'et': 'pliiatsi_läbipaistvus|joone_läbipaistvus', 'eu': 'lumagardentasuna|marragardentasuna', 'fi': 'kynänläpinäkyvyys', 'fr': 'transparencecrayon|tranparenceligne', 'fy': 'pentrochsichtigens|linetrochsichtigens', 'gl': 'transparencialapis|transparencialiña', 'gug': 'bolígrafo.hesakã|línea.hesakã', 'he': 'שקיפות_עט|שקיפות_קו', 'hr': 'prozirnostolovke|prozirnostlinije', 'hsb': 'transparencapisaka|transparencalinije|tp|tl', 'hu': 'tollátlátszóság', 'is': 'pennagegnsæi|línugegnsæi', 'ja': 'ペンの透明度|pentransparency|linetransparency', 'kab': 'tafrawantakeryun|tafrawantizirig', 'kk': 'қалам_мөлдірлілігі|сызық_мөлдірлілігі', 'km': 'ភាព\u200bថ្លា|ភាពថ្លាបន្ទាត់', 'kn': 'ಲೇಖನಿಪಾರದರ್ಶಕತೆ|ಸಾಲಿನಪಾರದರ್ಶಕತೆ', 'ko': '투명펜', 'lo': 'ຄວາມໂປ່ງໃສຂອງປາກກາ|ຄວາມປອດໃສຂອງເສັ້ນ', 'lt': 'pieštuko.skaidrumas|linijos.skaidrumas|psk', 'lv': 'spalvas_caurspīdīgums|līnijas_caurspīdīgums', 'mn': 'өнгөгүйүзэг|өнгөгүйшугам', 'nb': 'penngjennomsiktighet|linjegjennomsiktighet', 'nl': 'pentranparantie|lijntransparantie', 'nn': 'penngjennomsikt|linjegjennomsikt', 'oc': 'transparénciagredon|tranparéncialinha', 'or': 'କଲମସ୍ୱଚ୍ଛତା|ଧାଡ଼ିସ୍ୱଚ୍ଛତା', 'pt_BR': 'mudarTransparênciaDoLápis|mTraLa|mTraLi', 'ru': 'прозр_пера|прозр_линии|пп', 'sk': 'priehľadnosťpera|priehľadnosťčiary|pp|pč', 'sl': 'prosojnostperesa|prosojnostčrte', 'sq': 'transparencaestilolapsit|transparencaevijës', 'tr': 'kalemşeffaflığı|çizgişeffaflığı', 'ug': 'قەلەم سۈزۈك|سىزىق سۈزۈك|pentransparency|linetransparency', 'uk': 'прозорість_пера|прозорість_лінії', 'vec': 'trasparensapena|trasparensałinea', 'zh_CN': '笔透明|线透明|pentransparency|linetransparency', 'zh_TW': '筆透明|線透明|pentransparency|linetransparency'},
'FILLSTYLE':{'en_US': 'fillstyle', 'af': 'vulstyl', 'am': 'መሙያ ዘዴ', 'ar': 'نمط_الملأ', 'ast': 'estiluderrellenu', 'be': 'стыль_заліўкі', 'bn_IN': 'ভরাট শৈলী', 'br': 'stil leuniañ', 'bs': 'stil popunjavanja', 'ca': 'estil.emplenament|ee', 'ca_valencia': 'estil.emplenament|ee', 'cs': 'druhvýplně', 'de': 'füllstil|fs', 'dsb': 'połnjeńskistil', 'el': 'μορφήγεμίσματος|fillstyle', 'eo': 'pleniga_stilo', 'es': 'estilorelleno', 'et': 'täitestiil', 'eu': 'betetzeestiloa', 'fi': 'täyttötyyli', 'fr': 'styleremplissage', 'fy': 'folling', 'gd': 'stoidhle an lìonaidh', 'gl': 'estilo de recheo', 'gug': 'estilohenyhe', 'gu': 'ભરવાની શૈલી', 'he': 'סגנון מילוי', 'hi': 'भरने की शैली', 'hr': 'stil ispune', 'hsb': 'pjelnjenskistil|ps', 'hu': 'töltőstílus', 'id': 'fontcolor|textcolor|textcolour', 'is': 'stíll fyllingar', 'ja': '塗りつぶしの模様|fillstyle', 'kab': 'aɣanibtaččart', 'ka': 'ჩასხმის სტილი', 'kk': 'толтыру_түрі', 'km': 'រចនាប័ទ្ម\u200b\u200bបំពេញ', 'kn': 'ತುಂಬಿಸುವ ಶೈಲಿ', 'ko': '채우기 스타일', 'lo': 'ແບບການຕື່ມສີ', 'lt': 'spalvinimo.stilius|sst', 'lv': 'pildījuma_stils', 'ml': 'നിറയ്ക്കുന്ന ശൈലി', 'mn': 'дүүргэх төрөл', 'mr': 'भरण्याची शैली', 'my': 'စတိုင်လ် ဖြည့်ပါ', 'nb': 'fyllstil', 'ne': 'शैली भर्नुहोस्', 'nl': 'vulling', 'nn': 'fyllstil|fillstyle', 'oc': "Estil d'emplenament", 'or': 'ଶୌଳୀ ପୁରଣ କର', 'pa_IN': 'ਭਰਨ ਸਟਾਈਲ', 'pt_BR': 'mudarEstiloDaPintura|mEstPi', 'ro': 'fillstyle|stilumplere', 'ru': 'стиль_заливки', 'sid': 'akatawonshi', 'si': 'පිරවුම් රටාව', 'sk': 'Výplň', 'sl': 'slogpolnila', 'sq': 'stiliimbushjes', 'te': 'నింపు శైలి', 'th': 'กระบวนแบบการเติมสี', 'tr': 'dolgu biçemi', 'ug': 'تولدۇرۇش ئۇسلۇبى', 'uk': 'стиль_заповнення', 'vec': 'stiłepien', 'vi': 'Kiểu tô đầy', 'zh_CN': '填充样式|填样式|填式|fillstyle', 'zh_TW': '填入樣式|填樣式|fillstyle'},
'FONTCOLOR':{'en_US': 'fontcolor|textcolor|textcolour', 'af': 'fontkleur|tekskleur', 'am': 'የ ፊደል ቀለም|የ ጽሁፍ ቀለም|የ ጽሁፍ ቀለም', 'ar': 'لون_الخط', 'ast': 'colorlletra|colortestu', 'bs': 'bojafonta|bojateksta|bojateksta', 'ca': 'color.lletra|color.text', 'ca_valencia': 'color.lletra|color.text', 'cs': 'barvapísma|barvatextu', 'de': 'schriftfarbe|textfarbe|schf|tf', 'dsb': 'pismowabarwa|tekstowabarwaa|pb|tb', 'el': 'χρώμαγραμματοσειράς|χρώμακειμένου|fontcolor|textcolor|textcolour', 'eo': 'tiparkoloro|tekstokoloro|tk', 'es': 'color.texto|color.letra', 'et': 'fondi_värv|teksti_värv', 'eu': 'letrakolorea|testukolorea', 'fi': 'fontinväri', 'fr': 'couleurpolice|couleurtexte|ctexte', 'fy': 'letterkleur|tekstkleur', 'gl': 'cordeletra|cordetexto|cordetexto', 'gug': "sa'y.moñe'ẽrã|sa'y.letra", 'he': 'צבעגופן|צבעפונט|צבעטקסט', 'hr': 'boja fonta|boja teksta|boja teksta', 'hsb': 'pismowabarba|tekstowabarba|pb|tb', 'hu': 'betűszín', 'is': 'leturlitur|textalitur|stafalitur', 'ja': '文字の色|fontcolor', 'kab': 'initasefsit|iniaḍris|inaḍris', 'kk': 'қаріп_түсі|мәтін_түсі', 'km': 'ពណ៌\u200bពុម្ពអក្សរ|textcolor|textcolour', 'kn': 'ಅಕ್ಷರಶೈಲಿಬಣ್ಣ|ಪಠ್ಯಬಣ್ಣ|ಪಠ್ಯಬಣ್ಣ', 'ko': '글꼴색상|글자색상|글자색상', 'lo': 'ສີຕົວອັກສອນ|ສີຂໍ້ຄວາມ|textcolour', 'lt': 'šrifto.spalva|teksto.spalva', 'lv': 'fonta_krāsa|teksta_krāsa', 'mn': 'үсгийнөнгө|текстийнөнгө|textcolour', 'mr': 'फाँटरंग|मजकूररंग|मजकूररंग', 'nb': 'tekstfarge', 'nl': 'letterkleur|tekstkleur', 'nn': 'tekstfarge|textcolor', 'or': 'ଅକ୍ଷରରୂପରଙ୍ଗ|ପାଠ୍ୟରଙ୍ଗ|textcolour', 'pt_BR': 'mudarCorDaLetra|mCorLe', 'ro': 'fontcolor|textcolor|textcolour|culoarefont', 'ru': 'цвет_шрифта|цвет_текста', 'sid': 'borangichukuula|borrotekuula|borrotekuulamme', 'sk': 'farbapísma|farbatextu|fp|ft', 'sl': 'barvapisave|barvačrk|barvabesedila', 'sq': 'ngjyraefontit|ngjyraetekstit|ngjyraetekstit', 'tr': 'yazıtipirengi|metinrengi|metinrengi', 'uk': 'колір_символів|колір_тексту', 'vec': 'cołorfont|cołortesto|cołortesto', 'zh_CN': '文字颜色|字体颜色|字颜色|字色|fontcolor|textcolor|textcolour', 'zh_TW': '字型顏色|文字顏色|字型色彩|文字色彩|字色|fontcolor|textcolor|textcolour'},
'FONTTRANSPARENCY':{'en_US': 'fonttransparency|texttransparency', 'af': 'fontdeursigtigheid|teksdeursigtigheid', 'am': 'የ ፊደል|ጽሁፍ ግልጽነት:', 'ca': 'transparència.lletra|transparència.text', 'ca_valencia': 'transparència.lletra|transparència.text', 'cs': 'průhlednostpísma|průhlpísma|průhlednosttextu|průhltextu', 'da': 'skrifttransparens|teksttransparens', 'de': 'schrifttransparenz|texttransparenz', 'dsb': 'transparencapisma|transparencateksta', 'el': 'διαφάνειαγραμματοσειράς|διαφάνειακειμένου', 'eo': 'tiparvideblo|tekstvideblo', 'es': 'transparenciafuente|transparenciatexto', 'et': 'fondi_läbipaistvus|teksti_läbipaistvus', 'eu': 'letragardentasuna|testugardentasuna', 'fr': 'transparencepolice|transparencetexte', 'fy': 'lettertypetrochsichtens|teksttrochsichtens', 'gl': 'transparenciatipoletra|transparenciatexto', 'he': 'שקיפות_גופן|שקיפות_טקסט', 'hr': 'prozirnostfonta|prozirnostteksta', 'hsb': 'transparencapisma|transparencateksta', 'hu': 'betűátlátszóság|szövegátlátszóság', 'is': 'leturgegnsæi|textagegnsæi', 'ja': 'フォントの透明度|texttransparency', 'kk': 'қаріп_мөлдірлігі|мәтін_мөлдірлігі', 'lv': 'fonta_caurspīdīgums|teksta_caurspīdīgums', 'mn': 'үзэгний тунгалаг байдал|текстийн тунгалаг байдал', 'nb': 'font transparens | tekst transparens', 'nl': 'lettertypetransparantie|teksttransparantie', 'oc': 'transparénciapolissa|transparénciatexte', 'pt_BR': 'transparẽnciafonte|transparênciatexto', 'ru': 'прозр_шрифта|прозр_текста', 'sk': 'priehľadnosťpísma|priehľadnosťtextu|pp|pt', 'sl': 'prosojnostpisave|prosojnostbesedila', 'tr': 'yazıtipişeffaflığı|metinşeffaflığı', 'uk': 'прозор_шрифта|прозор_тексту', 'vec': 'trasparensafont|trasparensatesto', 'zh_CN': '字体透明|文字透明|字透明|fonttransparency|texttransparency', 'zh_TW': '字型透明|文字透明|fonttransparency|texttransparency'},
'FONTHEIGHT':{'en_US': 'fontsize|textsize|textheight', 'af': 'fontgrootte|teksgrootte', 'am': 'የ ፊደል መጠን|የ ጽሁፍ መጠን|የ ጽሁፍ እርዝመት', 'ar': 'حجم_الخط', 'ast': 'tamañulletra|tamañutestu|altortestu', 'bs': 'veličinafonta|veličinateksta|visinateksta', 'ca': 'mida.lletra|mida.text', 'ca_valencia': 'mida.lletra|mida.text', 'cs': 'velikostpísma|velikosttextu', 'de': 'schriftgrösse|schriftgröße|textgrösse|textgröße|schgr|tgr', 'dsb': 'wjelikosćpisma|wjelikosćteksta|wusokosćteksta|wp|wt', 'el': 'μέγεθοςγραμματοσειράς|μέγεθοςκειμένου|ύψοςκειμένου|fontsize|textsize|textheight', 'eo': 'tiparogrando|tekstoalto|tekstogrando', 'es': 'tamaño.texto|tamaño.letra', 'et': 'fondi_suurus|teksti_suurus|teksti_kõrgus', 'eu': 'letratamaina|testutamaina|testualtuera', 'fi': 'fonttikoko', 'fr': 'taillepolice|tailletexte|largeurtexte', 'fy': 'lettergrutte|tekstgrutte|teksthichte', 'gl': 'tamañodeletra|tamañodetexto|alturadetexto', 'he': 'גודלגופן|גודלטקסט|גובהטקסט', 'hr': 'veličina fonta|veličina teksta|visina teksta', 'hsb': 'wulkosćpisma|wulkosćteksta|wysokosćteksta|wp|wt', 'hu': 'betűméret', 'is': 'leturstærð|textastærð|textahæð', 'ja': '文字の大きさ|フォントの大きさ|fontsize|fontheight', 'kab': 'teɣzitasefsit|teɣziaḍris|tehriaḍris', 'kk': 'қаріп_өлшемі|мәтін_өлшемі|мәтін_биіктігі', 'km': 'ទំហំ\u200bពុម្ពអក្សរ|textsize|textheight', 'kn': 'ಅಕ್ಷರಶೈಲಿಗಾತ್ರ|ಪಠ್ಯಗಾತ್ರ|ಪಠ್ಯಎತ್ತರ', 'ko': '글꼴크기|글자크기|글자높이', 'lo': 'fontsize|ຂະໜາດຕົວອັກສອນ|ຄວາມສູງຂອງຂໍ້ຄວາມ', 'lt': 'šrifto.dydis|teksto.dydis', 'lv': 'fonta_izmērs|teksta_izmērs|teksta_augstums', 'mn': 'фонтхэмжээ|текстхэмжээ|текстөндөр', 'mr': 'फाँटआकार|मजकूरआकार|मजकूरऊंची', 'nb': 'tekststørrelse|teksthøyde', 'nl': 'tekengrootte|tekstgrootte|teksthoogte', 'nn': 'tekststorleik|teksthøgd|textsize', 'or': 'ଅକ୍ଷରରୂପ ଆକାର|ପାଠ୍ୟଆକାର|textheight', 'pt_BR': 'mudarTamanhoDaLetra|mTamLe', 'ro': 'fontsize|textsize|textheight|mărimefont', 'ru': 'кегль|размер_текста|высота_текста', 'sid': 'borangichu bikka|borrotebikka|borrotehojja', 'sk': 'veľkosťpísma|veľkosťtextu|vp|vt', 'sl': 'velikostpisave|velikostčrk|velikostbesedila', 'sq': 'madhësiaefontit|madhësiaetekstit|lartësiaetekstit', 'tr': 'yazıtipiboyutu|metinboyutu|metinyüksekliği', 'uk': 'кегль|розмір_символів|висота_символів', 'vec': 'grandesafont|grandesatesto|altesatesto', 'zh_CN': '文字大小|字体大小|字大小|字高|fontsize|textsize|textheight', 'zh_TW': '字型大小|文字大小|字大小|字高|字級|fontsize|textsize|textheight'},
'FONTWEIGHT':{'en_US': 'fontweight', 'af': 'fontdikte', 'am': 'የ ፊደል ክብደት', 'ar': 'وزن_الخط', 'ast': 'pesudefonte', 'bn_IN': 'ফন্টের পুরুত্ব', 'br': 'lard', 'bs': 'težinafonta', 'ca': 'pes.lletra|pl', 'ca_valencia': 'pes.lletra|pl', 'ckb': 'پانی جۆرەپیت', 'cy': 'pwysau ffont', 'cs': 'tloušťkapísma', 'de': 'schriftgewicht|schgw', 'dsb': 'pismowawaga|pw', 'el': 'πάχοςγραμματοσειράς|fontweight', 'eo': 'tiparopezo', 'es': 'peso.letra|pl', 'et': 'fondi_paksus', 'eu': 'letralodiera', 'fi': 'fontinpaksuus', 'fr': 'graisse', 'fy': 'letter tsjokte', 'gl': 'grosor do tipo de letra', 'gu': 'ફોન્ટનો ભાર', 'he': 'משקלגופן', 'hi': 'फ़ॉन्ट भार', 'hr': 'debljina fonta', 'hsb': 'pismowawaha|pw', 'hu': 'betűvastagság', 'is': 'leturbreidd', 'ja': '文字の太さ|フォントの太さ|fontweight', 'kab': 'tuzert', 'ka': 'შრიფტის სიგანე', 'kk': 'қаріп_жуандығы', 'km': 'កម្រាស់\u200bពុម្ពអក្សរ', 'kn': 'ಅಕ್ಷರಶೈಲಿ ತೂಕ', 'ko': '글꼴 굵기', 'lo': 'ຄວາມໃຫ່ຍຂອງຕົວອັກສອນ', 'lt': 'šrifto.storis|teksto.storis', 'lv': 'fonta_treknums', 'ml': 'ഫോണ്ഡിന്റെ തൂക്കം', 'mn': 'үсгийнжин', 'mr': 'फाँटचे वजन', 'my': 'စာလုံး အလေးချိန်', 'nb': 'skrifttykkelse|fontweight', 'ne': 'फन्ट वजन', 'nl': 'letterdikte|tekstdikte', 'nn': 'skrifttjukkleik|fontweight', 'oc': 'Graissa', 'or': 'ଅକ୍ଷରରୂପ ଉଚ୍ଚତା', 'pa_IN': 'ਫੋਂਟ ਗੂੜਾਪਨ', 'pt_BR': 'mudarEspessuraDaLetra|mEspLe', 'ro': 'fontweight|grosimefont', 'ru': 'толщина_шрифта', 'sid': 'brrangichu ayirreenya', 'si': 'අකුරු බර', 'sk': 'Váha písma', 'sl': 'debelinapisave', 'sq': 'peshaefontit', 'ta': 'எழுத்துரு தடிமன்', 'te': 'అక్షరశైలి భారం', 'tr': 'yazı tipi genişliği', 'ug': 'خەت نۇسخا ئىنچىكە توملۇقى', 'uk': 'товщина_символів', 'vec': 'pezofont', 'vi': 'Độ đậm chữ', 'zh_CN': '字体粗细|字粗细|字粗|fontweight', 'zh_TW': '字型重量|字重|字粗細|字粗|fontweight'},
'FONTSTYLE':{'en_US': 'fontstyle', 'af': 'fontstyl', 'am': 'የ ፊደል ዘዴ', 'ar': 'طراز_الخط', 'ast': 'estiludefonte', 'be': 'стыль_шрыфту', 'bn_IN': 'হরফ-শৈলী', 'br': 'stil an nodrezh', 'bs': 'stilfonta', 'ca': 'estil.lletra|el', 'ca_valencia': 'estil.lletra|el', 'ckb': 'شێوازی جۆرەپیت', 'cs': 'stylpísma', 'de': 'schriftstil|schs', 'dsb': 'stilpisma|sp', 'el': 'μορφήγραμματοσειράς|fontstyle', 'eo': 'tiparostilo', 'es': 'estilo.letra|estilo.fuente', 'et': 'fondi_stiil', 'eu': 'letraestiloa', 'fi': 'fonttityyli', 'fr': 'stylepolice', 'fy': 'tekststyl|letterstyl', 'gl': 'estilo do tipo de letra', 'gu': 'ફોન્ટ શૈલી', 'he': 'סגנוןגופן', 'hr': 'stil fonta', 'hsb': 'stilpisma|sp', 'hu': 'betűstílus', 'is': 'leturstíll', 'ja': '文字の書き方|文字のスタイル|フォントのスタイル|fontstyle', 'kab': 'aɣanib n tsefsit', 'kk': 'қаріп_стилі', 'km': 'រចនាប័ទ្ម\u200bពុម្ពអក្សរ', 'kn': 'ಅಕ್ಷರಶೈಲಿ', 'ko': '글꼴스타일', 'lo': 'ຮູບແບບຕົວອັກສອນ', 'lt': 'šrifto.stilius|teksto.stilius', 'lv': 'fonta_stils', 'mn': 'үсгийнхэвмаяг', 'mr': 'फाँटची शैली', 'nb': 'fontstil', 'nl': 'tekststijl|letterstijl', 'nn': 'skriftstil|fontstyle', 'or': 'ଅକ୍ଷରରୂପ ଶୈଳୀ', 'pt_BR': 'mudarEstiloDaLetra|mEstLe', 'ro': 'fontstyle|stilfont', 'ru': 'стиль_шрифта', 'sid': 'borangichuakat', 'sk': 'štýlpísma|šp', 'sl': 'slogpisave', 'sq': 'stiliifontit', 'ta': 'எழுத்துரு பாணி', 'te': 'ఫాంటుశైలి', 'th': 'รูปแบบอักขระ', 'tr': 'yazı tipi biçemi', 'ug': 'خەت نۇسخا ئۇسلۇبى', 'uk': 'стиль_символів', 'vec': 'stiłefont', 'zh_CN': '字体样式|字样式|字样|fontstyle', 'zh_TW': '字型樣式|字樣式|fontstyle'},
'BOLD':{'en_US': 'bold', 'af': 'vetdruk', 'am': 'ማድመቂያ', 'ar': 'ثخين', 'as': 'ডাঠ', 'ast': 'gruesu', 'be': 'цёмны', 'bn_IN': 'গাঢ়', 'bn': 'গাঢ়', 'br': 'Tev', 'bs': 'masno', 'ca': 'negreta', 'ca_valencia': 'negreta', 'ckb': 'قەڵەو', 'cy': 'trwm', 'cs': 'tučné', 'de': 'fett', 'dsb': 'tucny', 'el': 'έντονα|bold', 'eo': 'grasa', 'es': 'negrita|grueso', 'et': 'paks|rasvane', 'eu': 'lodia', 'fa': 'ضخیم', 'fi': 'lihavointi', 'fr': 'gras', 'fy': 'fet', 'gd': 'trom', 'gl': 'grosa', 'gug': "hũ'i", 'gu': 'ઘટ્ટ', 'he': 'מודגש', 'hi': 'मोटा', 'hr': 'podebljano', 'hsb': 'tučny', 'hu': 'félkövér|kövér|vastag', 'id': 'tebal', 'is': 'feitletrað', 'ja': '太く|太字|bold', 'kab': 'azuran', 'ka': 'შეკვრა', 'kk': 'жуан', 'km': 'ដិត\u200b', 'kmr_Latn': 'qalind', 'kn': 'ಬೋಲ್ಡ್\u200d', 'ko': '굵은', 'lb': 'fett', 'lo': 'ຕົວໜາ', 'lt': 'pusjuodis', 'lv': 'trekns', 'ml': 'ബോള്\u200dഡ്', 'mn': 'бүдүүн', 'mr': 'ठळक', 'my': 'မဲ', 'nb': 'fet', 'ne': 'बाक्लो', 'nl': 'vet', 'nn': 'feit|bold', 'nr': 'darhileko', 'nso': 'mokoto', 'oc': 'gras', 'or': 'ଗାଢ଼', 'pa_IN': 'ਗੂੜ੍ਹੇ', 'pt_BR': 'negrito', 'ro': 'bold|îngroșat', 'ru': 'жирный', 'sid': "kee'misi", 'si': 'තදකුරු', 'sk': 'tučné', 'sl': 'krepko', 'sq': 'të trasha', 'ss': 'licinsi', 'st': 'botenya', 'ta': 'தடிமன்', 'te': 'మందం', 'th': 'ตัวหนา', 'tn': 'tiisa', 'tr': 'kalın', 'ts': 'dzwihala', 'tt': 'калын', 'ug': 'توم', 'uk': 'жирний', 'vec': 'groseto', 've': 'ndenya', 'vi': 'đậm', 'xh': 'ngqindilili', 'zh_CN': '粗体|粗|bold', 'zh_TW': '粗體|粗|bold', 'zu': 'okugqamile'},
'ITALIC':{'en_US': 'italic', 'af': 'skuinsdruk', 'am': 'ማዝመሚያ', 'ar': 'مائل', 'as': 'ইতালিক', 'ast': 'cursiva', 'be': 'курсіў', 'bn_IN': 'তির্যক', 'br': 'stouet', 'bs': 'koso', 'ca': 'cursiva|itàlica', 'ca_valencia': 'cursiva|itàlica', 'ckb': 'لار', 'cy': 'italig', 'cs': 'kurzíva', 'de': 'kursiv', 'dgo': 'इटैलिक', 'dsb': 'kursiwny', 'el': 'πλάγια|italic', 'eo': 'kursiva', 'es': 'cursiva|itálica|bastardilla', 'et': 'kaldkiri|kursiiv', 'eu': 'etzana', 'fi': 'kursivointi', 'fr': 'italique', 'fy': 'skeanprinte', 'gd': 'eadailteach', 'gl': 'cursiva', 'gug': 'cursiva', 'gu': 'ઇટાલિક', 'he': 'נטוי', 'hi': 'तिरछा', 'hr': 'kurziv', 'hsb': 'kursiwny', 'hu': 'kurzív|dőlt', 'is': 'skáletrað', 'ja': '斜め|斜体|italic', 'kab': 'uknan', 'ka': 'კურსივი', 'kk': 'курсив', 'km': 'ទ្រេត', 'kn': 'ಇಟಾಲಿಕ್', 'ko': '이탤릭체', 'lo': 'ຕົວງ່ຽງ', 'lt': 'kursyvas', 'lv': 'kursīvs', 'ml': 'ചരിഞ്ഞ', 'mn': 'налуу', 'mr': 'तिरके', 'my': 'စာလုံးစောင်း', 'nb': 'kursiv', 'ne': 'छड्के', 'nl': 'cursief', 'nn': 'kursiv|italic', 'oc': 'italica', 'or': 'ତେର୍ଚ୍ଛା', 'pa_IN': 'ਤਿਰਛੇ', 'pt_BR': 'itálico', 'ro': 'italic|cursiv', 'ru': 'курсив', 'sa_IN': 'इटेलिक', 'sat': 'कोचे ओलाक्', 'sd': 'اِٽيلڪ', 'sid': 'hawiitto-borro', 'si': 'ඇල අකුරු', 'sk': 'Kurzíva', 'sl': 'ležeče', 'sq': 'me të pjerrëta', 'szl': 'kursywa', 'ta': 'சாய்வு', 'te': 'వాలు', 'tr': 'italik', 'ug': 'يانتۇ', 'uk': 'курсив', 'vec': 'zbiego', 'vi': 'Nghiêng', 'zh_CN': '斜体|斜|italic', 'zh_TW': '義式斜體|斜體|斜|italic'},
'UPRIGHT':{'en_US': 'upright|normal', 'af': 'regop|normaal', 'am': 'ቀጥተኛ|መደበኛ', 'ar': 'معتدل|عادي', 'ast': 'normal', 'br': 'a-serzh|normal', 'bs': 'goredesno|normalno', 'ca': 'vertical|normal', 'ca_valencia': 'vertical|normal', 'cs': 'normální', 'de': 'normal', 'dsb': 'normalny', 'el': 'όρθιο|κανονικό|upright|normal', 'eo': 'rekta|vertikala|normala', 'es': 'normal', 'et': 'püstine|tavaline', 'eu': 'tente|normala', 'fi': 'pysty', 'fr': 'hautdroit|normal', 'fy': 'rjochtop|normaal', 'gl': 'vertical|normal', 'gug': 'normal', 'he': 'רגיל|עומד', 'hr': 'uspravan|normalan', 'hsb': 'normalny', 'hu': 'álló|normál', 'is': 'upprétt|venjulegt', 'ja': 'ふつう|標準|upright', 'kab': 'asawenayeffus|amagnu', 'kk': 'тура|қалыпты', 'km': 'ស្ដាំ|ធម្មតា', 'kn': 'ನೆಟ್ಟಗೆ|ಸಾಮಾನ್ಯ', 'ko': '우상단|일반', 'lo': 'ຊື່ກົງ|ປົກກະຕິ', 'lt': 'įprastinis', 'lv': 'taisns|normāls', 'mn': 'босоо|хэвийн', 'mr': 'उभे|सामान्य', 'nb': 'stående|normal', 'nl': 'rechtop|normaal', 'nn': 'normal|upright', 'or': 'ଡ଼ାହାଣପାଖ ଉପର|normal', 'pt_BR': 'vertical', 'ro': 'upright|normal|înpicioare', 'ru': 'прямой|обычный', 'sid': 'aliqiniitira|rosaminoha', 'sk': 'normálne|no', 'sl': 'pokonci|navadno', 'sq': 'lart|normal', 'tr': 'üstsağ|normal', 'uk': 'прямий|звичайний', 'vec': 'vertegałe|normałe', 'zh_CN': '正体|正|一般|upright|normal', 'zh_TW': '正體|正|一般|upright|normal'},
'NORMAL':{'en_US': 'normal', 'af': 'normaal', 'am': 'መደበኛ', 'ar': 'عادي', 'as': 'সাধাৰন', 'be': 'звычайны', 'bn_IN': 'সাধারণ', 'bn': 'সাধারণ', 'br': 'Reizh', 'bs': 'obicno', 'ckb': 'ئاسایی', 'cs': 'normální', 'dgo': 'आम', 'dsb': 'normalny', 'el': 'κανονικό|normal', 'eo': 'normala', 'et': 'keskmine', 'eu': 'normala', 'fa': 'معمولی', 'fi': 'tavallinen', 'fy': 'normaal', 'gd': 'àbhaisteach', 'gu': 'સામાન્ય', 'he': 'רגיל', 'hi': 'सामान्य', 'hr': 'obično', 'hsb': 'normalny', 'hu': 'normál', 'is': 'venjulegt', 'ja': 'ふつう|標準|normal', 'kab': 'amagnu', 'ka': 'ჩვეულებრივი', 'kk': 'қалыпты', 'km': 'ធម្មតា\u200b', 'kmr_Latn': 'asayî', 'kn': 'ಸಾಮಾನ್ಯ', 'ko': '보통', 'lo': 'ປົກກະຕິ', 'lt': 'įprastinis', 'lv': 'normāls', 'ml': 'സാധാരണ', 'mni': 'নোর্মেল', 'mn': 'энгийн', 'mr': 'सामान्य', 'my': 'ပုံမှန်', 'ne': 'सामान्य', 'nl': 'normaal', 'nr': 'jayelekileko', 'nso': 'tlwaelegilego', 'or': 'ସାଧାରଣ', 'pa_IN': 'ਸਧਾਰਨ', 'ru': 'обычный', 'sa_IN': 'आम', 'sid': 'rosaminoha', 'si': 'සාමාන්\u200dය', 'sk': 'normálne', 'sl': 'navadno', 'sq': 'normale', 'ss': 'vamile', 'st': 'tlwaelehileng', 'ta': 'சாதாரண', 'te': 'సాధారణ', 'th': 'ปกติ', 'tn': 'tlwaelo', 'ts': 'tolovelekeeke', 'tt': 'гадәти', 'ug': 'نورمال', 'uk': 'звичайний', 'vec': 'normałe', 've': 'ḓoweleaho', 'vi': 'thông thường', 'xh': 'ngokuqhelekileyo', 'zh_CN': '一般|常规|normal', 'zh_TW': '一般|normal', 'zu': 'okwejwayelekile'},
'FONTFAMILY':{'en_US': 'fontfamily', 'af': 'font familie', 'am': 'የ ፊደል ቤተሰብ', 'ar': 'عائلة_الخط', 'ast': 'familiafonte', 'be': 'гарнітура', 'br': 'spletad nodrezhoù', 'bs': 'fontfamilija', 'ca': 'família.lletra|fl', 'ca_valencia': 'família.lletra|fl', 'ckb': 'خێزانی جۆرەپیت', 'cs': 'druhpísma', 'de': 'schriftart|scha', 'dsb': 'družynapisma|dp', 'el': 'οικογένειαγραμματοσειράς|fontfamily', 'eo': 'tiparofamilio', 'es': 'tipo.letra|letra|fuente', 'et': 'font|kirjatüüp|fondi_perekond', 'eu': 'letrafamilia', 'fi': 'fonttiperhe', 'fr': 'famillepolice', 'fy': 'tekstfamylje', 'gd': "teaghlach a' chruth-chlò", 'gl': 'familia do tipo de letra', 'gu': 'ફોન્ટકુટુંબ', 'he': 'משפחתגופנים', 'hr': 'skupina fontova', 'hsb': 'družinapisma|dp', 'hu': 'betűcsalád', 'is': 'leturtegund', 'ja': '文字の種類|フォントファミリー|fontfamily', 'kab': 'tawaculttasefsit', 'kk': 'қаріптер_отбасы', 'km': 'ក្រុម\u200bពុម្ពអក្សរ', 'kn': 'ಅಕ್ಷರಶೈಲಿಸಮೂಹ', 'ko': '글꼴 모음', 'lo': 'ຮູບແບບຫຼັກຂອງຕົວອັກສອນ', 'lt': 'garnitūras|šriftų.šeima|šš', 'lv': 'fontu_saime', 'mn': 'үсгийн_анги', 'mr': 'फाँटफॅमिलि', 'nb': 'fontfamilie', 'nl': 'tekstfamilie', 'nn': 'skriftfamilie|fontfamily', 'or': 'ଅକ୍ଷରରୂପ ପରିବାର', 'pt_BR': 'mudarTipoDaLetra|mTipLe', 'ro': 'fontfamily|familiefont', 'ru': 'семейство_шрифтов', 'sid': 'borangichumine', 'sk': 'druhpísma|dp', 'sl': 'vrstapisave', 'sq': 'familjaefontit', 'ta': 'எழுத்துரு குடும்பம்', 'te': 'ఫాంట్\u200cఫ్యామిలీ', 'tr': 'yazıtipi ailesi', 'uk': 'гарнітура', 'vec': 'famejafont', 'zh_CN': '字体|字体家族|字型|fontfamily', 'zh_TW': '字型家族|字族|fontfamily'},
'CLEARSCREEN':{'en_US': 'clearscreen|cs', 'af': 'skerm uitveë', 'am': 'መመልከቻ ማጽጃ|መ.ማ', 'ar': 'محو_الشاشة|محو', 'ast': 'llimpiapantalla|lp', 'br': 'skarzhañskramm|cs', 'bs': 'očistiekran|cs', 'ca': 'neteja.dibuix|inicia.dibuix|net|id', 'ca_valencia': 'neteja.dibuix|inicia.dibuix|net|id', 'cs': 'smažobrazovku|so', 'de': 'säubern', 'dsb': 'cysćwobrazowku|cw', 'el': 'καθαρισμόςοθόνης|κο|clearscreen|cs', 'eo': 'vakigi_ekranon|ek', 'es': 'limpiar.pantalla|lp|cs', 'et': 'puhasta_ekraan|pe', 'eu': 'garbitupantaila|gp', 'fi': 'tyhjennänäyttö|tn', 'fr': 'effaceécran|ee', 'fy': 'skermleechmakker|skjin|sl', 'gl': 'limparpantalla|lp', 'gug': 'monandipantalla|mp', 'he': 'לנקותמסך|ניקוימסך|נקהמסך|נמ', 'hr': 'očistizaslon|oz', 'hsb': 'čisćwobrazowku|čw', 'hu': 'törölképernyő|törölkép|törölrajzlap|tr', 'is': 'hreinsaskjá|hs', 'ja': '画面を消す|clearscreen|cs', 'kab': 'sfeḍagdil|sa', 'kk': 'экранды_тазарту|эт', 'km': 'សម្អាត\u200bអេក្រង់|cs', 'kn': 'ತೆರೆಅಳಿಸು|cs', 'ko': '화면지우기|cs', 'lo': 'ລ້າງໜ້າຈໍ|cs', 'lt': 'valyk.vėžliuko.lauką|vvl', 'lv': 'attīrīt_ekrānu|ae', 'mn': 'дэлгэц_цэвэрлэ|cs', 'mr': 'क्लिअरस्क्रिन|cs', 'nb': 'tømskjermen|ts', 'nl': 'schermleegmaken|schoon|sl', 'nn': 'tømskjermen|ts|clearscreen', 'or': 'ପରଦା ପରିଷ୍କାର|cs', 'pt_BR': 'tartaruga|tat', 'ro': 'clearscreen|cs|ștergeecran', 'ru': 'очистить_экран|оэ', 'sid': 'coichaleelshalba|cl', 'sk': 'zmažobrazovku|zo', 'sl': 'počistizaslon|pz', 'sq': 'pastroekranin|cs', 'tr': 'ekranıtemizle|cs', 'uk': 'очистити_екран|ое', 'vec': 'netaschermo|cs', 'zh_CN': '清屏|清除|clearscreen|cs', 'zh_TW': '清除畫面|清畫面|清除|clearscreen|cs'},
'TEXT':{'en_US': 'text', 'af': 'teks', 'am': 'ጽሁፍ', 'ar': 'نص', 'as': 'লিখনী', 'ast': 'testu', 'be': 'тэкст', 'bn_IN': 'পাঠ্য', 'bn': 'পাঠ্য', 'br': 'testenn', 'brx': 'फराय बिजाब', 'bs': 'tekst', 'ckb': 'دەق', 'cy': 'testun', 'cs': 'popisek', 'dgo': 'इबारत', 'dsb': 'tekst', 'dz': 'ཚིག་ཡིག', 'el': 'κείμενο|text', 'eo': 'teksto', 'es': 'texto', 'et': 'tekst', 'eu': 'testua', 'fa': 'متن', 'fi': 'teksti', 'fr': 'texte', 'fy': 'tekst', 'gd': 'teacsa', 'gl': 'texto', 'gug': "moñe'ẽrã", 'gu': 'લખાણ', 'he': 'טקסט', 'hi': 'पाठ', 'hr': 'tekst', 'hsb': 'tekst', 'hu': 'szöveg', 'is': 'texti', 'ja': '文字|テキスト|text', 'kab': 'aḍris', 'ka': 'ტექსტი', 'kk': 'мәтін', 'km': 'អត្ថបទ', 'kmr_Latn': 'Nivîs', 'kn': 'ಪಠ್ಯ', 'kok': 'मजकूर', 'ko': '텍스트', 'ks': 'مواد', 'lo': 'ຂໍ້ຄວາມ', 'lt': 'tekstas', 'lv': 'teksts', 'mai': 'पाठ', 'mk': 'Текст', 'ml': 'വാചകം', 'mni': 'তেক্স', 'mn': 'бичвэр', 'mr': 'मजकूर', 'my': 'စာသား', 'nb': 'tekst', 'ne': 'पाठ', 'nl': 'tekst', 'nn': 'tekst|text', 'oc': 'tèxte', 'om': 'barruu', 'or': 'ପାଠ୍ୟ', 'pa_IN': 'ਟੈਕਸਟ', 'pt_BR': 'texto', 'ru': 'текст', 'rw': 'umwandiko', 'sa_IN': 'पाठ्यम्', 'sat': 'ओनोलओनोल.', 'sid': 'borro', 'si': 'පෙළ', 'sl': 'besedilo', 'sq': 'tekst', 'sw_TZ': 'matini', 'ta': 'உரை', 'te': 'పాఠ్యము', 'tg': 'матн', 'th': 'ข้อความ', 'tr': 'metin', 'tt': 'Текст', 'ug': 'تېكست', 'uk': 'текст', 'uz': 'matn', 'vi': 'văn bản', 'zh_CN': '文字|文本|text', 'zh_TW': '文字|text'},
'HIDETURTLE':{'en_US': 'hideturtle|ht|hideme', 'af': 'verberg', 'am': 'ኤሊ መደበቂያ|ht|ይደብቁኝ', 'ar': 'أخف_السلحفاة|أخف', 'ast': 'anubretortuga|anubrime|at', 'br': 'kuzhatbaot|ht|hideme', 'bs': 'sakrijkornjaču|ht|sakrijmene', 'ca': 'amaga.tortuga|oculta.tortuga|at|ot', 'ca_valencia': 'amaga.tortuga|oculta.tortuga|at|ot', 'cs': 'skryjželvu|skryj|sž', 'de': 'verbergen', 'dsb': 'schowajnopawu|sn', 'el': 'απόκρυψηχελώνας|αχ|κρύψεμε|hideturtle|ht|hideme', 'eo': 'kaŝu_testudon|kt', 'es': 'ocultartortuga|ot|ocultarme', 'et': 'peida|peida_kilpkonn|pk', 'eu': 'ezkutatudortoka|ed|ezkutatuni', 'fi': 'piilotakonna|pk', 'fr': 'cachetortue|ct|cachemoi', 'fy': 'ferbergje|fb', 'gl': 'agochartartaruga|at|agocharme', 'gug': 'mokañykarumbe|ñk|añeñomi', 'he': 'הסתרצב|להסתירצב|הסתרתהצב|להסתיראותי|הס', 'hr': 'sakrikursor|sk|sakrijme', 'hsb': 'schowajnopawu|sn', 'hu': 'elrejt|láthatatlan|elrejtteknőc|rejttek', 'is': 'feladýr|fd|felamig', 'ja': 'タートルを隠す|hideturtle|ht', 'kk': 'тасбақаны_жасыру|тж|мені_жасыру', 'kn': 'ಆಮೆಅಡಗಿಸು|ht|ನನ್ನನ್ನುಅಡಗಿಸು', 'ko': '거북이숨기기|ht|숨기기', 'lo': 'hideturtle|ht|ເຊື່ອງຂ້ອຍ', 'lt': 'slėpk.vėžliuką|slėpkis|sl', 'lv': 'slēpt_rupuci|sr|slēpt_mani', 'mn': 'яст_мэлхийг_нуу|ht|намайг_нуу', 'mr': 'हाइडटर्टल|ht|हाइडमि', 'nb': 'skjulmeg|sm|hideturtle', 'nl': 'verberg|vb', 'nn': 'gøymmeg|gm|hideturtle', 'oc': 'amagartortuga|mt|amagar', 'or': 'କଇଁଛଲୁଚାଇବା|ht|hideme', 'pt_BR': 'desaparecerTat|dt|desapareçaTat|ocultarTat|escondeTat', 'ro': 'hideturtle|ht|hideme|invizibil', 'ru': 'скрыть_черепаху|сч|скрыть_меня', 'sid': 'bukukaamamaaxi|bukukaamamaaxi|bm|anemaaxi', 'sk': 'skrykorytnačku|skry|sk', 'sl': 'skrijželvo|sž|skrijme', 'sq': 'fshihebreshkën|ht|mëfshihmua', 'tr': 'kaplumbağagizle|kg|gizlebeni', 'uk': 'сховай_черепашку|сч', 'vec': 'scondibisascueła|ht|scóndame', 'zh_CN': '隐藏海龟|隐龟|隐藏龟|hideturtle|ht|hideme', 'zh_TW': '隱藏海龜|隱藏|hideturtle|ht|hideme'},
'SHOWTURTLE':{'en_US': 'showturtle|st|showme', 'af': 'vertoon', 'am': 'ኤሊ ማሳያ|st|ያሳዩኝ', 'ar': 'أظهر_السلحفاة|أظهر', 'ast': 'amuesatortuga|veme|vt', 'br': 'diskouezbaot|st|showme', 'bs': 'prikažikornjaču|st|prikažimene', 'ca': 'mostra.tortuga|mt', 'ca_valencia': 'mostra.tortuga|mt', 'cs': 'ukažželvu|ukaž|už', 'de': 'zeigen', 'dsb': 'pokažnopawu|pn', 'el': 'εμφάνισηχελώνας|εμφάνισεμε|εε|showturtle|st|showme', 'eo': 'vidigu_testudon|vt', 'es': 'mostrartortuga|mt|mostrarme', 'et': 'näita|näita_kilpkonna|nk', 'eu': 'erakutsidortoka|rd|erakutsini', 'fi': 'näytäkonna|nk', 'fr': 'montretortue|mt|montremoi', 'fy': 'sjenlitte|sl', 'gl': 'amosartartaruga|mt|amosarme', 'gug': 'hechaukakarumbe|hk|ajehecha', 'he': 'הצגצב|להציבצב|הצגתהצב|להציגאותי|הצ', 'hr': 'pokažikursor|st|pokažime', 'hsb': 'pokazajnopawu|pn', 'hu': 'látható', 'is': 'sýnadýr|sd|sýnamig', 'ja': 'タートルを出す|showturtle|st', 'kk': 'тасбақаны_көрсету|тк|мені_көрсету', 'kn': 'ಆಮೆತೋರಿಸು|st|ನನ್ನನ್ನುತೋರಿಸು', 'ko': '거북이표시|st|표시', 'lo': 'showturtle|st|ສະ\u200bແດງ\u200bໃຫ້\u200bຂ້ອຍ\u200bເຫັນ', 'lt': 'rodyk.vėžliuką|rodykis|rd', 'lv': 'rādīt_rupuci|rr|rādīt_mani', 'mn': 'яст_мэлхийг_харуул|ст|намайг_харуул', 'mr': 'शोटर्टल|st|शोमि', 'nb': 'vismeg|vm|showturtle', 'nl': 'toon|tn', 'nn': 'vismeg|vm|showturtle', 'oc': 'afichartortuga|at|afichar', 'or': 'କଇଁଛଦର୍ଶାଇବା|st|showme', 'pt_BR': 'mostrarTat|mostreTat|at|apareçaTat|aparecerTat', 'ro': 'showturtle|st|showme|vizibil', 'ru': 'показать_черепаху|пч|показать_меня', 'sid': 'bukukaleelshi|bukukaleelshi|bl|aneleelshi', 'sk': 'ukážkorytnačku|ukáž|uk', 'sl': 'pokažiželvo|pž|pokažime', 'sq': 'shfaqebreshkën|st|mëshfaqmua', 'tr': 'kaplumbağagöster|kg|benigöster', 'uk': 'покажи_черепашку|пч', 'vec': 'mostrabisascueła|st|móstrame', 'zh_CN': '显示海龟|显示龟|显龟|showturtle|st|showme', 'zh_TW': '顯示海龜|顯示龜|顯示|showturtle|st|showme'},
'POSITION':{'en_US': 'position|pos|setpos', 'af': 'posisie|pos', 'am': 'ቦታ|ቦታ|ቦታ ማሰናጃ', 'ar': 'موقع|عين_موقع', 'ast': 'posición|pos|dirposición', 'br': "lec'hiadur|pos|setpos", 'bs': 'pozicija|pos|postavipos', 'ca': 'posició|pos|estableix.posició', 'ca_valencia': 'posició|pos|estableix.posició', 'cs': 'pozice|poz|nastavpoz', 'de': 'position|pos', 'dsb': 'pozicija|poz', 'el': 'θέση|θσ|ορισμόςθέσης|βάλε|position|pos|setpos', 'eo': 'pozicio|poz', 'es': 'posición|pos|fijar.posición', 'et': 'asukoht|koht|määra_koht', 'eu': 'kokagunea|pos|ezarrikokagunea', 'fi': 'paikka', 'fr': 'position|pos|fixepos', 'fy': 'posysje|pos|setpos', 'gl': 'posición|pos|estabelecerposición', 'he': 'מיקום|מקום|הגדרמקום|הגדרתמקום|מקו', 'hr': 'pozicija|poz|postavipoz', 'hsb': 'pozicija|poz', 'hu': 'hely|hely!|pozíció|xy!', 'is': 'staðsetning|stað|setjastað', 'ja': '位置|場所|position', 'kk': 'орны|орн|орнын_көрсету', 'kn': 'ಸ್ಥಾನ|pos|ಸ್ಥಾನಹೊಂದಿಸು', 'ko': '위치|pos|위치설정', 'lo': 'ຕໍາແໜ່ງ|pos|setpos', 'lt': 'eik.į', 'lv': 'pozīcija|poz|iest_poz', 'mn': 'байрлал|pos|байрлал_сонго', 'mr': 'स्थान|पॉस|सेटपॉस', 'nb': 'plassering|plasser|position', 'nl': 'positie|pos|setpos', 'nn': 'plassering|plasser|pos|position', 'oc': 'posicion|pos|definirpos', 'or': 'ସ୍ଥାନ|pos|setpos', 'pt_BR': 'posicionar|pos', 'ro': 'position|pos|setpos|poziție', 'ru': 'позиция|поз|установить_позицию', 'sid': 'ofolla|ofo|ofoqineessi', 'sk': 'pozícia|poz|nastavpoz|np', 'sl': 'položaj|pol|določipoložaj', 'sq': 'pozicioni|pos|vendospozicionin', 'tr': 'konum|knm|knmayarla', 'uk': 'позиція|поз|встановити_позицію', 'vec': 'pozision|pos|inpostapozision', 'zh_CN': '位置|定位|position|pos|setpos', 'zh_TW': '位置|定位|position|pos|setpos'},
'HEADING':{'en_US': 'heading|setheading|seth', 'af': 'rigting', 'am': 'ራስጌ|ራስጌ ማሰናጃ|ራ.ማ', 'ar': 'خط\u200cعنوان|عيّن\u200cخط\u200cعنوان', 'ast': 'direición|pondireición|dir', 'br': 'talbenn|setheading|seth', 'bs': 'zaglavlje|postavizaglavlje|seth', 'ca': 'canvia.sentit|sentit|heading|setheading|seth', 'ca_valencia': 'canvia.sentit|sentit', 'cs': 'směr|nastavsměr', 'de': 'richtung|ri', 'dsb': 'směr|sm', 'el': 'επικεφαλίδα|ορισμόςεπικεφαλίδας|ορε|heading|setheading|seth', 'eo': 'direkto|dir', 'es': 'sentido|dirección|dir', 'et': 'pealkiri|määra_pealkiri', 'eu': 'izenburua|ezarriizenburua|ezarrii', 'fi': 'suunta', 'fr': 'cap|fixecap|fc', 'fy': 'rjochting', 'gl': 'cabeceira|estabelecercabeceira|ec', 'he': 'כותרת|הגדרתכותרת|הגכ', 'hr': 'naslov|postavinaslov|postavin', 'hsb': 'směr|sm', 'hu': 'irány|irány!', 'is': 'fyrirsögn|setjafyrirsögn|setf', 'ja': '進む向き|向き|heading', 'kk': 'атауы|атауын_орнату|ата', 'kn': 'ಶೀರ್ಷಿಕೆ|ಶೀರ್ಷಿಕೆಹೊಂದಿಸು|seth', 'ko': '제목|제목설정|seth', 'lo': 'ຫົວເລື່ອງ|ຕັ້ງຄ່າຫົວເລື່ອງ|seth', 'lt': 'žvelk', 'lv': 'azimuts|iestatīt_azimutu|iest_az', 'mn': 'гарчиг|гарчиг_өг|seth', 'mr': 'हेडिंग|सेटहेडिंग|सेटएच', 'nb': 'retning|settretning|heading', 'nl': 'richting', 'oc': 'títol|definirtítol|deft', 'or': 'ଶୀର୍ଷକ|ଶୀର୍ଷକ ବିନ୍ୟାସ|seth', 'pt_BR': 'mudarDireção|mDir|direção', 'ro': 'heading|setheading|seth|direcție', 'ru': 'заголовок|установить_заголовок|заг', 'sid': 'umallo|umalloqineessi|uqineessi', 'sk': 'smer|nastavsmer|ns', 'sl': 'smer|določismer|dols', 'sq': 'koka|vendoskokën|venk', 'tr': 'başlık|başlığıayarla|baş.ayarla', 'uk': 'заголовок|задати_заголовок|заг', 'vec': 'tìtoło|inpostatìtoło|diresion', 'zh_CN': '朝向|定向|heading|setheading|seth', 'zh_TW': '朝向|定向|heading|setheading|seth'},
'PAGESIZE':{'en_US': 'pagesize', 'af': 'bladsygrootte', 'am': 'የ ገጽ መጠን', 'ar': 'حجم_الصفحة', 'ast': 'tamañupaxina', 'be': 'памеры_старонкі', 'bn_IN': 'কাগজের মাপ', 'br': 'ment ar bajenn', 'bs': 'veličinastranice', 'ca': 'mida.pàgina|mp', 'ca_valencia': 'mida.pàgina|mp', 'ckb': 'قەبارەی پەڕە', 'cs': 'velikoststránky', 'de': 'seite', 'dsb': 'wjelikosćboka|wb', 'el': 'μέγεθοςσελίδας|pagesize', 'eo': 'paĝogrando', 'es': 'tamañopágina', 'et': 'lehe_suurus', 'eu': 'orritamaina', 'fi': 'sivukoko', 'fr': 'taillepage', 'fy': 'sidegrutte', 'gl': 'tamaño da páxina', 'gug': 'tamañorogue', 'gu': 'પાનાંમાપ', 'he': 'גודלעמוד', 'hr': 'veličinastranice', 'hsb': 'wulkosćstrony|ws', 'hu': 'oldalméret', 'is': 'síðustærð', 'ja': 'ページサイズ|pagesize', 'kab': 'teɣziasebter', 'kk': 'бет_өлшемі', 'km': 'ទំហំ\u200bទំព័រ', 'kn': 'ಪುಟದಗಾತ್ರ', 'ko': '페이지크기', 'lo': 'ຂະຫນາດຂອງຫນ້າ', 'lt': 'lapo.kampas', 'lv': 'lappuses_izmērs', 'ml': 'താള്\u200dവ്യാപ്തി', 'mn': 'хуудасны_хэмжээ', 'mr': 'पेजसाइज', 'nb': 'sidestørrelse|pagesize', 'nl': 'paginagrootte', 'nn': 'sidestorleik|pagesize', 'oc': 'talhapagina', 'or': 'ପୃଷ୍ଠା ଆକାର', 'pt_BR': 'tamanhoDaPágina|tamPág', 'ro': 'pagesize|mărimepagină', 'ru': 'размер_страницы', 'sid': 'qoolubikka', 'sk': 'veľkosťstránky|vs', 'sl': 'velikoststrani', 'sq': 'madhësiaefaqes', 'te': 'పేజీపరిమాణం', 'tr': 'sayfa boyutu', 'uk': 'розмір_сторінки', 'vec': 'grandesapàjina', 'zh_CN': '页面大小|纸张大小|纸大小|页大小|pagesize', 'zh_TW': '頁面大小|紙張大小|頁大小|紙大小|pagesize'},
'GROUP':{'en_US': 'picture|pic', 'af': 'afbeelding', 'am': 'ስእል|ስእል', 'ar': 'رسم|صور', 'ast': 'figura|fig', 'bs': 'slika|pic', 'ca': 'figura|fig', 'ca_valencia': 'figura|fig', 'cs': 'obrázek|obr', 'de': 'bild', 'dsb': 'wobraz|wob', 'el': 'εικόνα|εικ|picture|pic', 'eo': 'bildo|b', 'es': 'imagen|img', 'et': 'pilt', 'eu': 'irudia|irud', 'fi': 'kuva', 'fr': 'image|ima', 'fy': 'ôfbylding|ôfb', 'gl': 'imaxe|imx', 'gug': "ta'anga|img", 'he': 'תמונה|תמ', 'hr': 'slika|slika', 'hsb': 'wobraz|wob', 'hu': 'kép', 'is': 'mynd|mnd', 'ja': '図|図のグループ|picture|pic', 'kab': 'tugna|tug', 'kk': 'сурет|сур', 'km': 'រូបភាព|pic', 'kn': 'ಚಿತ್ರ|pic', 'ko': '사진|pic', 'lo': 'ຮູບພາບ|pic', 'lt': 'piešinys', 'lv': 'attēls|att', 'mn': 'зураг', 'mr': 'चित्र|पिक', 'nb': 'bilde|fig|picture', 'nl': 'afbeelding|afb', 'nn': 'bilete|fig|picture', 'oc': 'imatge|img', 'or': 'ଛବି|pic', 'pt_BR': 'agrupar|grupo|grp|figura', 'ro': 'picture|pic|imagine', 'ru': 'изображение|изо', 'sid': 'misile|mis', 'sk': 'obrázok|obr', 'sl': 'slika|sli', 'sq': 'fotografi|fot', 'tr': 'resim|res', 'uk': 'зображення|зобр', 'vec': 'imàjene|fegura', 'zh_CN': '图片|图|图组|组|picture|pic|group', 'zh_TW': '圖片|圖|圖組|picture|pic'},
'TO':{'en_US': 'to', 'af': 'na', 'am': 'ለ', 'ar': 'إلى', 'as': 'লৈ', 'ast': 'a', 'bn_IN': 'প্রতি', 'br': 'e', 'bs': 'do', 'ca': 'fins.a', 'ca_valencia': 'fins.a', 'ckb': '\u202bto', 'cs': 'příkaz', 'de': 'zu|als', 'dsb': 'k', 'el': 'σε|to', 'eo': 'al', 'es': 'a', 'et': 'funktsioon|f', 'eu': 'nora', 'fi': 'tee', 'fr': 'à', 'fy': 'nei', 'gd': 'gu', 'gl': 'para', 'gug': 'a', 'gu': 'પ્રતિ', 'he': 'עד', 'hi': 'प्रति', 'hr': 'za', 'hsb': 'k', 'hu': 'ez|eljárás|elj|tanuld', 'is': 'til', 'ja': '動きを作る|to', 'kab': 'ɣer', 'kk': 'қайда', 'km': 'ដល់', 'kn': 'ಗೆ', 'lt': 'tai', 'lv': 'līdz', 'ml': 'ഏങ്ങോട്ട്', 'mn': 'руу', 'mr': 'टु', 'nb': 'til|to', 'nl': 'naar', 'nn': 'til|to', 'oc': 'a', 'or': 'କୁ', 'pt_BR': 'aprender|aprenda', 'ro': 'to|la', 'ru': 'к', 'sid': 'ra', 'sk': 'k', 'sl': 'pri', 'sq': 'tek', 'ta': 'இதற்கு', 'te': 'కు', 'tr': 'buraya', 'uk': 'до', 'zh_CN': '定义|定义起始|起始|to', 'zh_TW': '定義|起|to'},
'END':{'en_US': 'end', 'af': 'einde', 'am': 'መጨረሻ', 'ar': 'النهاية', 'as': 'অন্ত', 'ast': 'final', 'bn_IN': 'শেষ', 'bn': 'শেষ', 'bo': 'end_period', 'br': 'Marevezh echuiñ', 'brx': 'जोबनाय', 'bs': 'kraj', 'ca': 'final|fi', 'ca_valencia': 'final|fi', 'ckb': '\u202bend', 'cy': 'diwedd', 'cs': 'konec', 'de': 'ende', 'dgo': 'अंत', 'dsb': 'kóńc', 'dz': 'མཇུག', 'el': 'τέλος|end', 'eo': 'fino', 'es': 'fin', 'et': 'lõpp', 'eu': 'amaiera', 'fi': 'loppu', 'fr': 'fin', 'fy': 'ein', 'gd': 'deireadh', 'gug': 'opa', 'gu': 'અંત', 'he': 'סוף', 'hi': 'अंत', 'hr': 'kraj', 'hsb': 'kónc', 'hu': 'vége', 'is': 'endar', 'ja': 'おわり|end', 'kab': 'tagara', 'kk': 'соңы', 'km': 'ពេលបញ្ចប់', 'kmr_Latn': 'dawî', 'kn': 'ಕೊನೆ', 'kok': 'अंत', 'ko': '최종 기간', 'ks': 'اند', 'lo': 'ຈົບ', 'lt': 'taškas', 'lv': 'beigas', 'mai': 'अंत', 'mk': 'Крај', 'ml': 'അന്ത്യം', 'mni': 'অরোয়বা', 'mn': 'төгсгөл', 'mr': 'एंड', 'my': 'အဆုံးသတ်', 'nb': 'slutt|end', 'ne': 'अन्त्य', 'nl': 'einde', 'nn': 'slutt|end', 'nr': 'phela', 'nso': 'mafelelo', 'oc': 'fin', 'om': 'dhuma', 'or': 'ଶେଷ', 'pa_IN': 'ਅੰਤ', 'pt_BR': 'fim', 'ro': 'end|sfârșit', 'ru': 'конец', 'rw': 'impera', 'sa_IN': 'समाप्तः', 'sat': 'मुचात् मुचा़त्', 'sd': 'آخر', 'sid': 'gofimarcho', 'si': 'අවසානය', 'sk': 'koniec', 'sl': 'konec', 'sq': 'fund', 'ss': 'kugcina', 'st': 'qetello', 'sw_TZ': 'mwisho', 'ta': 'முடிவு', 'te': 'ముగింపు', 'tg': 'Давраи охир', 'th': 'สิ้นสุด', 'tn': 'bofelo', 'tr': 'son', 'ts': 'makumu', 'uk': 'Кін_період', 've': 'magumo', 'vi': 'kết thúc', 'xh': 'ekugqibeleni', 'zh_CN': '定义终|终|结束|end', 'zh_TW': '結束|迄|end', 'zu': 'isiphetho'},
'STOP':{'en_US': 'stop', 'am': 'ማስቆሚያ', 'ar': 'أوقف', 'as': 'বন্ধ কৰক', 'ast': 'parar', 'bn_IN': 'থামান', 'br': 'arsaviñ', 'bs': 'zaustavi', 'ca': 'atura|para', 'ca_valencia': 'para', 'ckb': '\u202bstop', 'cy': 'atal', 'cs': 'zastav', 'de': 'stopp', 'dgo': 'रोको', 'el': 'τερματισμός|stop', 'eo': 'haltu', 'es': 'detener', 'et': 'peata', 'eu': 'gelditu', 'fi': 'pysäytä', 'fy': 'ophâlde', 'gd': 'sguir', 'gl': 'parar', 'gug': 'pyta', 'gu': 'અટકાવો', 'he': 'עצור|עצירה|לעצור', 'hi': 'रोकें', 'hr': 'zaustavi', 'hsb': 'stój', 'hu': 'stop|visszatér', 'is': 'stöðva', 'ja': '動きから出る|stop', 'kab': 'seḥbes', 'kk': 'тоқтату', 'km': 'បញ្ឈប់', 'kn': 'ನಿಲ್ಲಿಸು', 'ko': '중지', 'lo': 'ຢຸດ', 'lt': 'baik', 'lv': 'apturēt', 'ml': 'നിര്\u200dത്തുക', 'mn': 'зогс', 'mr': 'स्टॉप', 'my': 'ရပ်ပါ', 'nb': 'stopp|stop', 'nn': 'stopp|stop', 'oc': 'arrestar', 'or': 'ବନ୍ଦ କର', 'pa_IN': 'ਰੋਕੋ', 'pt_BR': 'parar|pare', 'ru': 'стоп', 'sa_IN': 'ठॆहर', 'sd': 'رُڪو', 'sid': 'uurri', 'sk': 'zastav', 'sl': 'ustavi', 'sq': 'ndalo', 'ta': 'நிறுத்து', 'te': 'ఆపుము', 'tr': 'dur', 'uk': 'зупини', 'zh_CN': '停止|中止|stop', 'zh_TW': '中止|止|stop'},
'REPEAT':{'en_US': 'repeat|forever', 'af': 'herhaal', 'am': 'መድገሚያ|ለዘለአለም', 'ar': 'كرر|للأبد', 'ast': 'repetir|pasiempres', 'be': 'паўтараць|бясконца', 'br': 'arren|forever', 'bs': 'ponavljaj|zauvijek', 'ca': 'repeteix|rep', 'ca_valencia': 'repeteix|rep', 'ckb': '\u202brepeat|forever', 'cs': 'opakuj|pořád', 'de': 'wiederhole|wdh', 'dsb': 'wóspjetuj|wsp', 'el': 'επανάληψη|repeat|forever', 'eo': 'ripetu|ĉiame|ĉiam', 'es': 'repetir|rep|siempre', 'et': 'korda|igavesti|lõpmatuseni', 'eu': 'errepikatu|betiko', 'fi': 'toista', 'fr': 'répète|toujours', 'fy': 'werhelje|foaraltyd', 'gl': 'repetir|sempre', 'gug': "ha'ejevy|tapia", 'he': 'חזרה|לעד|לנצח|לתמיד', 'hr': 'ponavljaj|zauvijek', 'hsb': 'wospjetuj|wsp', 'hu': 'ismét|ism|ismétlés|végtelenszer|vszer', 'is': 'endurtaka|endalaust', 'ja': 'くりかえす|repeat', 'kab': 'ales|yal ass', 'kk': 'қайталау|шексіз', 'km': 'ធ្វើ\u200bឡើង\u200bវិញ|រហូត', 'kn': 'ಪುನರಾವರ್ತಿಸು|ಯಾವಾಗಲೂ', 'ko': '반복|계속', 'lo': 'ເຮັດຊ້ຳ|ຕະຫຼອດໄປ', 'lt': 'kartok|amžinai', 'lv': 'atkārtot|mūžīgi', 'mn': 'давтах|үүрд', 'mr': 'रिपिट|फॉरएव्हेर', 'nb': 'gjenta|for alltid|repeat', 'nl': 'herhaal|vooraltijd', 'nn': 'gjenta|for alltid|repeat', 'or': 'ପୁନରାବୃତ୍ତି|forever', 'pt_BR': 'repetir|repita', 'ro': 'repeat|forever|repetă', 'ru': 'повторять|бесконечно', 'sid': 'wirroqoli|hegerera', 'sk': 'opakovať|stále', 'sl': 'ponovi|neskončno', 'sq': 'përsërit|përgjithmonë', 'tr': 'tekrarla|sürekli', 'uk': 'завжди', 'vec': 'repeti|senpre', 'zh_CN': '重复|repeat|forever', 'zh_TW': '重複|重復|永遠|repeat|forever'},
'REPCOUNT':{'en_US': 'repcount', 'af': 'herhaal teller', 'ar': 'عداد_التكرار', 'ast': 'repetirvegaes', 'br': 'arren ar gont', 'bs': 'repbroji', 'ca': 'repeteix.vegades|repv', 'ca_valencia': 'repeteix.vegades|repv', 'ckb': '\u202bbreak', 'cs': 'počítadlo|poč', 'de': 'zähler', 'dsb': 'licak', 'el': 'αριθμόςεπαναλήψεων|repcount', 'eo': 'ripetonombro', 'es': 'conteo.veces', 'et': 'korduse_number', 'eu': 'errepzenbak', 'fi': 'toistokerrat', 'fr': 'nombrerep', 'fy': 'kearwerhelje', 'gl': 'contarep', 'gug': "ha'ejevy.papa", 'he': 'ספירתחזרה', 'hr': 'br. ponavljanja', 'hsb': 'ličak', 'hu': 'hányadik', 'is': 'endurtekningafjöldi', 'ja': 'くりかえした数|repcount', 'kk': 'қайталау', 'lt': 'kartojimai', 'lv': 'atkārt_skaits', 'mn': 'тоологч', 'mr': 'रिपकाउंट', 'nb': 'teller|repcount', 'nl': 'keerherhaal', 'nn': 'teljar|repcount', 'or': 'ପୁନରାବୃତ୍ତି ସଂଖ୍ୟା', 'pt_BR': 'contVezes|conteVezes', 'ro': 'repcount|câtelea', 'ru': 'повторить', 'sid': 'wirrotekiiro', 'sk': 'počítadlo|poč', 'sl': 'števecpon', 'sq': 'numërimirep', 'te': 'రెప్\u200cకౌంట్', 'tr': 'tekrarsayısı', 'uk': 'повтори', 'vec': 'contavolte', 'zh_CN': '重复数|repcount', 'zh_TW': '重複數|重復數|repcount'},
'BREAK':{'en_US': 'break', 'af': 'breuk', 'am': 'መጨረሻ', 'ar': 'اكسر', 'ast': 'saltu', 'bn_IN': 'বিরতি', 'br': 'rannadur', 'bs': 'iskoči', 'ca': 'salta|trenca', 'ca_valencia': 'salta|trenca', 'ckb': '\u202bbreak', 'cy': 'toriad', 'cs': 'ukonči', 'de': 'abbruch', 'dsb': 'pśetergnuś', 'el': 'διακοπή|break', 'eo': 'saltu', 'es': 'saltar|interrumpir', 'et': 'katkesta', 'eu': 'jauzia', 'fi': 'keskeytä', 'fr': 'saut', 'fy': 'ôfbrekke', 'gl': 'quebrar', 'gug': 'kytĩ', 'gu': 'વિભાજક', 'he': 'שבירה|לשבור', 'hi': 'खण्डन', 'hr': 'prijelom', 'hsb': 'přetorhnyć', 'hu': 'kilép', 'id': 'pemisah', 'is': 'rofstaður', 'ja': 'くりかえしから出る|break', 'kab': 'yerrez', 'ka': 'შეწყვეტა', 'kk': 'үзу', 'km': 'បំបែក', 'kn': 'ತಡೆ', 'ko': '분할', 'lo': 'ແຕກ', 'lt': 'nutrauk', 'lv': 'pārtraukt', 'ml': 'വിഭജിക്കുക', 'mn': 'цуцлах', 'mr': 'ब्रेक', 'my': 'ကြားဖြတ်ပါ', 'nb': 'avbryt|break', 'ne': 'विच्छेद', 'nl': 'afbreken', 'nn': 'avbryt|break', 'oc': 'fraccionar', 'or': 'ଭାଙ୍ଗ', 'pa_IN': 'ਬਰੇਕ', 'pt_BR': 'interromper|interrompa', 'ro': 'break|întrerupere', 'ru': 'прервать', 'sid': 'tayisi', 'si': 'බිදුම', 'sk': 'Zalomenie', 'sl': 'prekini', 'sq': 'braktis', 'ta': 'முறி', 'te': 'విరుపు', 'tr': 'sonlandır', 'uk': 'перерви', 'vec': 'spaca', 'vi': 'Ngắt', 'zh_CN': '中断|break', 'zh_TW': '中斷|斷|break'},
'CONTINUE':{'en_US': 'continue', 'af': 'gaan voort', 'am': 'ይቀጥሉ', 'ar': 'تابع', 'as': 'অব্যাহত ৰাখক', 'ast': 'siguir', 'be': 'працягваць', 'bn_IN': 'পরবর্তী (~C)', 'br': "kenderc'hel", 'bs': 'nastavak', 'ca': 'continua', 'ca_valencia': 'continua', 'ckb': '\u202bcontinue', 'cy': 'parhau', 'cs': 'pokračuj', 'de': 'weiter', 'dsb': 'dalej', 'el': 'συνέχεια|continue', 'eo': 'daŭrigu', 'es': 'continuar', 'et': 'jätka', 'eu': 'jarraitu', 'fi': 'jatka', 'fr': 'continuer', 'fy': 'trochgean', 'gl': 'continuar', 'gug': 'segui', 'gu': 'ચાલુ રાખો', 'he': 'המשך|להמשיך', 'hi': 'जारी रखें', 'hr': 'nastavi', 'hsb': 'dale', 'hu': 'újra', 'is': 'áfram', 'ja': 'はじめにもどる|continue', 'kab': 'kemmel', 'ka': 'გაგრძელება', 'kk': 'жалғастыру', 'km': 'បន្ត', 'kn': 'ಮುಂದುವರಿಸು', 'ko': '계속', 'lo': 'ສຶບຕໍ່', 'lt': 'tęsk', 'lv': 'turpināt', 'ml': 'തുടരുക', 'mn': 'үргэлжлүүл', 'mr': 'कंटिन्यु', 'my': 'ဆက်လုပ်ပါ', 'nb': 'fortsett|continue', 'ne': 'जारी राख्नुहोस्', 'nl': 'doorgaan|verdergaan', 'nn': 'hald fram|continue', 'oc': 'contunhar', 'or': 'ଚାଲୁରଖ', 'pa_IN': 'ਜਾਰੀ ਰੱਖੋ', 'pt_BR': 'continuar|continue', 'ro': 'continue|continuă', 'ru': 'продолжить', 'sid': 'albisufi', 'si': 'දිගටම කරගෙන යන්න (~C)', 'sk': 'Pokračovať', 'sl': 'nadaljuj', 'sq': 'vazhdo', 'ta': 'தொடர்', 'te': 'కొనసాగించు', 'tr': 'devam', 'uk': 'продовжити', 'vec': 'continua', 'vi': 'Tiếp tục', 'zh_CN': '继续|continue', 'zh_TW': '繼續|續|continue'},
'WHILE':{'en_US': 'while', 'af': 'terwyl', 'am': 'ትንሽ', 'ar': 'طالما', 'ast': 'mentanto', 'be': 'пакуль', 'bn_IN': 'যেখানে', 'br': 'e pad ma', 'bs': 'dok', 'ca': 'mentre', 'ca_valencia': 'mentre', 'ckb': '\u202bwhile', 'cs': 'dokud', 'de': 'solange', 'dsb': 'mjaztymaž', 'el': 'όσο|while', 'eo': 'dum', 'es': 'mientras', 'et': 'kuniks', 'eu': 'bitartean', 'fi': 'kunhan', 'fr': 'pendant', 'fy': 'salang', 'gl': 'mentres', 'gug': 'jave', 'gu': 'સફેદ', 'he': 'כלעוד', 'hi': 'के दौरान', 'hr': 'bijela', 'hsb': 'doniž', 'hu': 'amíg', 'is': 'meðan', 'ja': 'くりかえすのは次の間|while', 'kab': 'ticki', 'ka': 'თეთრი', 'kk': 'дейін', 'kn': 'ಬಿಳಿ', 'ko': '흰색', 'lo': 'ໃນຂະນະທີ່', 'lt': 'kol', 'lv': 'kamēr', 'mn': 'байхад', 'mr': 'व्हाइल', 'nb': 'mens|while', 'ne': 'सेतो', 'nl': 'zolang', 'nn': 'medan|while', 'oc': 'mentre', 'or': 'ଯେତେବେଳେ', 'pa_IN': 'ਚਿੱਟਾ', 'pt_BR': 'enquanto', 'ro': 'while|până', 'ru': 'пока', 'sid': 'waajjo', 'si': 'සුදු', 'sk': 'pokiaľ', 'sl': 'dokler', 'sq': 'ndërsa', 'te': 'జరుగుతున్నప్పుడు', 'tr': 'beyaz', 'uk': 'поки', 'vec': 'intanto', 'zh_CN': '当|while', 'zh_TW': '當|while'},
'FOR':{'en_US': 'for', 'af': 'vir', 'am': 'ለ', 'ar': 'لـ', 'as': 'কাৰণে', 'ast': 'pa', 'be': 'для', 'bn_IN': 'জন্য', 'bn': 'জন্য', 'bo': 'ལ་སྤྱོད།', 'br': 'evit', 'brx': 'थाखाय', 'bs': 'za', 'ca': 'per.a', 'ca_valencia': 'per.a', 'ckb': '\u202bfor', 'cy': 'ar gyfer', 'cs': 'pro', 'de': 'für', 'dgo': 'लेई', 'dsb': 'za', 'dz': 'དོན་ལུ།', 'el': 'γιαόσο|for', 'eo': 'por', 'es': 'para', 'et': 'igale_elemendile', 'eu': 'honentzat', 'fa': 'برای', 'fi': 'jokaiselle', 'fr': 'pour', 'fy': 'foar', 'gd': 'airson', 'gl': 'Para', 'gug': 'haguã', 'gu': 'માટે', 'he': 'עבור', 'hi': 'के लिए', 'hr': 'za', 'hsb': 'za', 'hu': 'fut', 'is': 'fyrir', 'ja': 'ひとつずつ|for', 'kab': 'i', 'ka': '-', 'kk': 'үшін', 'km': 'សម្រាប់', 'kmr_Latn': 'ji bo', 'kn': 'ಗಾಗಿ', 'kok': 'खातीर', 'ko': '유형', 'ks': 'کےلئے', 'lo': 'ສຳລັບ', 'lt': 'ciklas.intervale|nuo.iki', 'lv': 'katram', 'mai': "क'लेल", 'mk': 'за', 'ml': 'വേണ്ടി', 'mni': '-গীদমক', 'mn': 'хувьд', 'mr': 'फॉर', 'my': 'အတွက်', 'ne': 'लागि', 'nl': 'voor', 'nr': 'kwe', 'nso': 'bakeng sa', 'oc': 'per', 'om': 'kanaaf', 'or': 'ପାଇଁ', 'pa_IN': 'ਲਈ', 'pt_BR': 'para', 'ro': 'for|pentru', 'ru': 'для', 'rw': 'Cya', 'sa_IN': 'कृते', 'sat': 'ला़गितला़गित्', 'sd': 'لاءِ', 'sid': 'ra', 'si': 'සඳහා', 'sk': 'pre', 'sl': 'za', 'sq': 'për', 'ss': 'ye', 'st': 'bakeng sa', 'sw_TZ': 'kwa', 'te': 'కొరకు', 'tg': 'барои', 'th': 'สำหรับ', 'tn': 'ya', 'tr': 'için', 'ts': 'eka', 'ug': 'ئۈچۈن', 'uk': 'для', 'uz': 'uchun', 've': 'u itela', 'vi': 'cho', 'xh': 'ukwenzela', 'zh_CN': '取|for', 'zh_TW': '取|for', 'zu': 'kwe'},
'IN':{'en_US': 'in', 'af': 'dm', 'am': 'ኢንች', 'ar': 'في', 'as': 'ইন', 'ast': 'en', 'be': 'у', 'bn_IN': 'ইঞ্চি', 'bn': 'ইঞ্চি', 'bo': 'དབྱིན་ཚུན།', 'br': 'e', 'bs': 'u', 'ca': 'a|en', 'ca_valencia': 'a|en', 'ckb': '\u202bin', 'cy': 'mod', 'cs': 'z', 'dgo': 'इं', 'dsb': 'w', 'dz': 'ཨའི་ཨེན།', 'el': 'στο', 'eo': 'en', 'es': 'en', 'et': 'hulgas', 'eu': 'hemen', 'fa': 'اینچ', 'fi': ':ssa|:ssä', 'fr': 'dans', 'fy': 'yn', 'gd': 'òirleach', 'gl': 'pol', 'gug': 'en', 'he': 'בתוך', 'hi': 'इंच', 'hr': 'dolazno', 'hsb': 'w', 'hu': '-ban|-ben', 'is': 'í', 'ja': 'を次から取り出して|in', 'kab': 'di', 'ka': 'დი', 'kk': 'ішінде', 'km': 'គិត\u200bជា', 'kmr_Latn': 'înç', 'kok': 'इंच', 'ks': 'میں', 'lo': 'ໃນ', 'lt': 'kur', 'lv': 'iekš', 'mai': 'इँच', 'mk': 'инчи', 'mni': 'ইন', 'mn': 'дотор', 'mr': 'इन', 'my': 'လက်မ', 'nb': 'tommer|in', 'nn': 'i|in', 'nso': 'go', 'oc': 'dins', 'or': 'ରେ', 'pt_BR': 'em', 'ro': 'in|în', 'ru': 'в', 'sd': '۾', 'sid': 'giddo', 'sl': 'v', 'sq': 'në', 'sw_TZ': 'katika', 'ta': 'அங்.', 'te': 'లోపల', 'tg': 'ин', 'th': 'น.', 'tn': 'gare', 'ts': 'endzeni', 'ug': 'ديۇيم', 'uk': 'дюйм', 'uz': 'dyuym', 'xh': 'ngaphakathi', 'zh_CN': '自|in', 'zh_TW': '自|in', 'zu': 'phakathi'},
'IF':{'en_US': 'if', 'af': 'as', 'am': 'ከ', 'ar': 'إن', 'ast': 'si', 'be': 'калі', 'bn_IN': 'যদি', 'br': 'mar', 'bs': 'ako', 'ca': 'si', 'ca_valencia': 'si', 'ckb': '\u202bif', 'cs': 'když', 'de': 'wenn', 'dgo': 'IF', 'dsb': 'jolic', 'el': 'αν|if', 'eo': 'se', 'es': 'si', 'et': 'kui', 'eu': 'bada', 'fi': 'jos', 'fr': 'si', 'fy': 'as', 'gl': 'se', 'gug': 'si', 'gu': 'જો', 'he': 'אם', 'hi': 'यदि', 'hr': 'ako', 'hsb': 'jeli', 'hu': 'ha', 'is': 'ef', 'ja': 'もし|if', 'kab': 'ma', 'kk': 'егер', 'kn': 'ಇದು ಆದಲ್ಲಿ', 'kok': 'IF', 'lo': 'ຖ້າວ່າ', 'lt': 'jeigu.tiesa', 'lv': 'ja', 'ml': 'എങ്കില്\u200d', 'mn': 'хэрэв', 'mr': 'इफ', 'nb': 'dersom|hvis|if', 'nl': 'als', 'nn': 'dersom|viss|if', 'oc': 'se', 'or': 'ଯଦି', 'pt_BR': 'se', 'ro': 'if|dacă', 'ru': 'если', 'sa_IN': 'IF', 'sat': 'IF', 'sid': 'ikkiro', 'sk': 'ak', 'sl': 'če', 'sq': 'nëse', 'te': 'ఒకవేళ', 'tr': 'eğer', 'uk': 'якщо', 'zh_CN': '如果|若|if', 'zh_TW': '若|if'},
'OUTPUT':{'en_US': 'output', 'af': 'uitvoer', 'am': 'ውጤት', 'ar': 'أخرِج', 'as': 'আউটপুট', 'ast': 'salida', 'be': 'вывад', 'bn_IN': 'আউটপুট', 'br': "ec'hankad", 'bs': 'izlaz', 'ca': 'sortida', 'ca_valencia': 'eixida', 'ckb': 'دەرخستە', 'cy': 'allbwn', 'cs': 'výsledek', 'de': 'rückgabe', 'dsb': 'wudaśe', 'el': 'έξοδος|output', 'eo': 'eligaĵo', 'es': 'salida', 'et': 'väljund', 'eu': 'Irteera', 'fi': 'kirjoita', 'fr': 'sortie', 'fy': 'útfier', 'gl': 'saída', 'gug': 'ñeseha', 'gu': 'આઉટપુટ', 'he': 'פלט', 'hi': 'आउटपुट', 'hr': 'rezultat', 'hsb': 'wudaće', 'hu': 'eredmény', 'is': 'frálag', 'ja': '値を返す|output', 'kab': 'tuffɣa', 'ka': 'გამონატანი', 'kk': 'шығыс', 'km': 'លទ្ធផល', 'kn': 'ಔಟ್\u200cಪುಟ್', 'ko': '출력', 'lo': 'ຜົນອອກ', 'lt': 'grąžink|išvesk', 'lv': 'izvade', 'ml': 'ഔട്ട്പുട്ട്', 'mn': 'хариу', 'mr': 'आउटपुट', 'my': 'အထုတ်', 'nb': 'utdata|output', 'ne': 'निर्गत', 'nl': 'output|uitvoer', 'nn': 'utdata|output', 'oc': 'sortida', 'or': 'ଫଳାଫଳ', 'pa_IN': 'ਆਉਟਪੁੱਟ', 'pt_BR': 'retornar|retorne|devolver|devolva|envie', 'ro': 'output|ieșire', 'ru': 'вывод', 'sid': 'guma', 'si': 'ප්\u200dරතිදානය', 'sk': 'Výstup', 'sl': 'izhod', 'sq': 'rezultati', 'ta': 'வெளியீடு', 'te': 'అవుట్పుట్', 'tr': 'çıktı', 'uk': 'вивести', 'vi': 'Đầu ra', 'zh_CN': '输出|output', 'zh_TW': '輸出|output'},
'LEFTSTRING':{'en_US': '“|‘', 'ast': '“|‘|«', 'ca': '“|‘|«', 'cs': '„|"', 'de': '„|‚|"|\'', 'dsb': '„|‚|"|\'', 'el': '“|‘|"|\'', 'es': '“|‘|«', 'et': '„', 'fi': '"|\'|”', 'hsb': '„|‚|"|\'', 'hu': '„', 'lt': '„|“|‘', 'nn': '“|‘|«', 'sk': '„|"', 'zh_CN': '「|『|“|‘', 'zh_TW': '「|『|“|‘'},
'RIGHTSTRING':{'en_US': '”|’', 'ast': '”|’|»', 'ca': '”|’|»', 'cs': '“|"', 'de': '“|‘|"|\'', 'dsb': '“|‘|"|\'', 'el': '”|’|"|\'', 'es': '”|’|»', 'et': '”|“', 'fi': '"|\'|”', 'hsb': '“|‘|"|\'', 'hu': '”', 'lt': '“|”|’', 'nn': '”|’|»', 'sk': '“|"', 'zh_CN': '」|』|”|’', 'zh_TW': '」|』|”|’'},
'TRUE':{'en_US': 'true', 'af': 'waar', 'am': 'እውነት', 'ar': 'صحيح', 'as': 'সঁচা', 'ast': 'braero', 'be': 'сапраўдна', 'bn_IN': 'সত্য', 'bn': 'সত্য', 'br': 'gwir', 'ca': 'cert|veritat', 'ca_valencia': 'cert|veritat', 'ckb': '\u202btrue', 'cy': 'gwir', 'cs': 'pravda', 'de': 'wahr', 'dsb': 'wěrno', 'el': 'αληθής|true', 'eo': 'vera', 'es': 'verdadero', 'et': 'tõene', 'eu': 'egiazkoa', 'fi': 'tosi', 'fr': 'vrai', 'fy': 'wier', 'gl': 'verdadeiro', 'gug': 'ete', 'gu': 'સાચુ', 'he': 'אמת', 'hi': 'सही', 'hr': 'točno', 'hsb': 'wěrno', 'hu': 'igaz', 'is': 'satt', 'ja': '真|なりたつ|true', 'kab': 'uzɣan', 'ka': 'ჭეშმარიტი', 'kk': 'ақиқат', 'km': 'ពិត', 'kmr_Latn': 'rast e', 'kn': 'ಸತ್ಯ', 'ko': '참', 'lo': 'ຖືກ', 'lt': 'tiesa', 'lv': 'patiess', 'mn': 'үнэн', 'mr': 'ट्रु', 'my': 'အမှန်', 'nb': 'sann|true', 'ne': 'सत्य', 'nl': 'waar', 'nn': 'sann/true', 'oc': 'verai', 'om': 'dhugaa', 'pa_IN': 'ਸਹੀਂ', 'pt_BR': 'verdadeiro|verd', 'ro': 'true|adevărat', 'ru': 'истина', 'sid': 'halaale', 'si': 'සත්\u200dය', 'sk': 'pravda', 'sl': 'jeresnično', 'sq': 'e vërtetë', 'ta': 'உண்மை', 'te': 'సత్యము', 'tg': 'саҳеҳ', 'th': 'จริง', 'tr': 'doğru', 'ug': 'راست', 'uk': 'істина', 'vi': 'đúng', 'zh_CN': '真|true', 'zh_TW': '真|true'},
'FALSE':{'en_US': 'false', 'af': 'onwaar', 'am': 'ሀሰት', 'ar': 'خطأ', 'as': 'মিছা', 'ast': 'falso', 'be': 'несапраўдна', 'bn_IN': 'মিথ্যা', 'bn': 'মিথ্যা', 'br': 'diwir', 'ca': 'fals', 'ca_valencia': 'fals', 'ckb': '\u202bfalse', 'cy': 'ffug', 'cs': 'nepravda', 'de': 'falsch', 'dsb': 'wopak', 'el': 'ψευδής|false', 'eo': 'falsa', 'es': 'falso', 'et': 'väär', 'eu': 'faltsua', 'fi': 'epätosi', 'fr': 'faux', 'fy': 'ûnwier', 'gl': 'falso', 'gug': 'japu', 'gu': 'ખોટુ', 'he': 'שקר', 'hi': 'गलत', 'hr': 'netočno', 'hsb': 'wopak', 'hu': 'hamis', 'is': 'ósatt', 'ja': '偽|なりたたない|false', 'kab': 'aruzɣan', 'ka': 'მცდარი', 'kk': 'жалған', 'km': 'មិន\u200bពិត', 'kmr_Latn': 'şaşî ye', 'kn': 'ಅಸತ್ಯ', 'ko': '거짓', 'lo': 'ຜິດ', 'lt': 'melas', 'lv': 'aplams', 'mn': 'худал', 'mr': 'फॉल्स', 'my': 'အမှား', 'nb': 'usann|false', 'ne': 'झूटो', 'nl': 'onwaar', 'nn': 'usann|false', 'oc': 'fals', 'om': 'soba', 'pa_IN': 'ਗਲਤ', 'pt_BR': 'falso', 'ro': 'false|fals', 'ru': 'ложь', 'sid': 'xara', 'si': 'අසත්\u200dය', 'sk': 'nepravda', 'sl': 'niresnično', 'sq': 'e pasaktë', 'ta': 'தவறு', 'te': 'అసత్యము', 'tg': 'дурӯғ', 'th': 'เท็จ', 'tr': 'yanlış', 'ug': 'يالغان', 'uk': 'хиба', 'vi': 'sai', 'zh_CN': '假|false', 'zh_TW': '假|false'},
'NOT':{'en_US': 'not', 'af': 'nie', 'am': 'አይደለም', 'ar': 'ليس', 'ast': 'non', 'be': 'не', 'bn_IN': 'নয়', 'br': 'ket', 'bs': 'ne', 'ca': 'no', 'ca_valencia': 'no', 'ckb': '\u202bnot', 'cs': 'není', 'de': 'nicht', 'dgo': 'NOT', 'dsb': 'nic', 'el': 'όχι|not', 'eo': 'ne', 'es': 'no', 'et': 'pole|mitte|ei', 'eu': 'ez', 'fi': 'ei', 'fr': 'non', 'fy': 'net', 'gd': 'chan e', 'gl': 'non', 'gug': 'no', 'gu': 'નથી', 'he': 'לא', 'hi': 'नहीं', 'hr': 'nije', 'hsb': 'nic', 'hu': 'nem', 'is': 'ekki', 'ja': '正しくない|否|not', 'kab': 'mačči', 'kk': 'емес', 'kn': 'ಇಲ್ಲ', 'kok': 'NOT', 'ko': '없음', 'lo': 'ບໍ່', 'lt': 'priešingai', 'lv': 'nav', 'mn': 'үгүй', 'mr': 'नॉट', 'nb': 'ikke|not', 'nl': 'niet', 'nn': 'ikkje|not', 'oc': 'non', 'or': 'ନୁହଁ', 'pa_IN': 'ਨਹੀਂ', 'pt_BR': 'não', 'ro': 'not|nu', 'ru': 'не', 'sa_IN': 'NOT', 'sat': 'NOT', 'sd': 'NOT', 'sid': "dee'ni", 'sk': 'nieje', 'sl': 'ni', 'sq': 'jo', 'te': 'కాదు', 'tr': 'değil', 'uk': 'не', 'zh_CN': '非|not', 'zh_TW': '非|not'},
'AND':{'en_US': 'and', 'af': 'en', 'am': 'እና', 'ar': 'و', 'ast': 'y', 'be': 'і', 'bn_IN': 'এবং', 'bn': 'এবং', 'br': 'ha', 'brx': 'आरो', 'bs': 'i', 'ca': 'i', 'ca_valencia': 'i', 'ckb': '\u202band', 'cy': 'a', 'cs': 'azároveň|az', 'de': 'und', 'dsb': 'a', 'dz': 'དང་།', 'el': 'και|and', 'eo': 'kaj', 'es': 'y', 'et': 'ja', 'eu': 'eta', 'fa': 'و', 'fi': 'ja', 'fr': 'et', 'fy': 'en', 'gd': 'agus', 'gl': 'e', 'gug': 'ha', 'gu': 'અને', 'he': 'וגם', 'hi': 'और', 'hr': 'i', 'hsb': 'a', 'hu': 'és', 'is': 'og', 'ja': 'と|かつ|and', 'kab': 'akked', 'ka': 'და', 'kk': 'және', 'km': 'និង', 'kmr_Latn': 'û', 'kn': 'ಮತ್ತು', 'kok': 'आनिक', 'ko': '및', 'ks': 'بےیئ', 'lb': 'an', 'lo': 'ແລະ', 'lt': 'kiekvienas', 'lv': 'un', 'mai': 'आओर', 'mn': 'ба', 'mr': 'अँड', 'my': 'နှင့်', 'nb': 'og|and', 'nl': 'en', 'nn': 'og|and', 'nso': 'le', 'oc': 'e', 'om': 'fi', 'or': 'ଏବଂ', 'pa_IN': 'ਅਤੇ', 'pt_BR': 'e', 'ro': 'and|și', 'ru': 'и', 'rw': 'na', 'sa_IN': 'च', 'sat': 'आर आर', 'sd': '۽', 'sid': 'nna', 'si': 'සහ', 'sk': 'a', 'sl': 'in', 'sq': 'dhe', 'ss': 'ne', 'st': 'le', 'sw_TZ': 'na', 'te': 'మరియు', 'tg': 'ва', 'th': 'และ', 'tn': 'le', 'tr': 've', 'tt': 'һәм', 'ug': 'ۋە', 'uk': 'та', 'uz': 'va', 'vec': 'e', 've': 'na', 'vi': 'và', 'xh': 'kunye', 'zh_CN': '且|与|and', 'zh_TW': '且|and', 'zu': 'kanye'},
'OR':{'en_US': 'or', 'af': 'of', 'am': 'ወይም', 'ar': 'أو', 'ast': 'o', 'be': 'або', 'bn_IN': 'অথবা', 'bn': 'অথবা', 'bo': 'ཡང་ན།', 'br': 'pe', 'brx': 'एबा', 'bs': 'ili', 'ca': 'o', 'ca_valencia': 'o', 'ckb': '\u202bor', 'cy': 'neu', 'cs': 'nebo', 'de': 'oder', 'dgo': 'जां', 'dsb': 'abo', 'dz': 'ཡང་ན།', 'el': 'ή|or', 'eo': 'aŭ', 'es': 'o', 'et': 'või', 'eu': 'edo', 'fa': 'یا', 'fi': 'tai', 'fr': 'ou', 'fy': 'of', 'gd': 'no', 'gl': 'ou', 'gug': 'o', 'gu': 'અથવા', 'he': 'או', 'hi': 'या', 'hr': 'ili', 'hsb': 'abo', 'hu': 'vagy', 'is': 'eða', 'ja': 'または|or', 'kab': 'neɣ', 'ka': 'ან', 'kk': 'немесе', 'kmr_Latn': 'an jî', 'kn': 'ಅಥವ', 'kok': 'वा', 'ko': '또는', 'ks': 'یا', 'lb': 'oder', 'lo': 'ຫຼື', 'lt': 'nors.vienas|arba|or', 'lv': 'vai', 'mai': 'अथवा', 'mni': 'নত্রগা', 'mn': 'буюу', 'mr': 'ऑर', 'my': 'သို့မဟုတ်', 'nb': 'eller|or', 'ne': 'वा', 'nl': 'of', 'nn': 'eller|or', 'nr': 'namkha', 'nso': 'goba', 'oc': 'o', 'om': 'ykn', 'or': 'କିମ୍ବା', 'pa_IN': 'ਜਾਂ', 'pt_BR': 'ou', 'ro': 'or|sau', 'ru': 'или', 'rw': 'cyangwa', 'sa_IN': 'वा', 'sat': 'आर', 'sd': 'يا', 'sid': 'woy', 'si': 'හෝ', 'sk': 'alebo', 'sl': 'ali', 'sq': 'ose', 'ss': 'nome', 'st': 'kapa', 'sw_TZ': 'au', 'te': 'లేదా', 'tg': 'ё', 'th': 'หรือ', 'tn': 'kgotsa', 'tr': 'veya', 'ts': 'kumbe', 'tt': 'яки', 'ug': 'ياكى', 'uk': 'або', 'uz': 'yoki', 've': 'kana', 'vi': 'hoặc', 'xh': 'okanye', 'zh_CN': '或|or', 'zh_TW': '或|or', 'zu': 'noma'},
'INPUT':{'en_US': 'input', 'af': 'invoer', 'am': 'ማስገቢያ', 'ar': 'أدخِل', 'ast': 'entrada', 'be': 'увод', 'bn_IN': 'ইনপুট', 'br': 'enankañ', 'bs': 'ulaz', 'ca': 'entrada', 'ca_valencia': 'entrada', 'ckb': 'تێخستە', 'cy': 'mewnbwn', 'cs': 'vstup', 'de': 'eingabe', 'dgo': 'इनपुट', 'dsb': 'zapódaśe', 'el': 'είσοδος|input', 'eo': 'enigu', 'es': 'entrada', 'et': 'sisend', 'eu': 'sarrera', 'fi': 'syötä', 'fr': 'saisie', 'fy': 'ynfier', 'gl': 'entrada', 'gug': 'jeikeha', 'gu': 'ઈનપુટ', 'he': 'קלט', 'hi': 'इनपुट', 'hr': 'unos', 'hsb': 'zapodaće', 'hu': 'be', 'is': 'inntak', 'ja': '値を聞く|input', 'kab': 'asekcem', 'ka': 'შეტანა', 'kk': 'кіріс', 'km': '\u200bបញ្ចូល', 'kn': 'ಇನ್\u200cಪುಟ್\u200c', 'ko': '입력', 'lo': 'ປ້ອນເຂົ້າ', 'lt': 'įvesk', 'lv': 'ievade', 'ml': 'ഇന്\u200dപുട്ട്', 'mn': 'оролт', 'mr': 'इंपुट', 'nb': 'inndata|input', 'ne': 'आगत', 'nl': 'invoer', 'nn': 'inndata|input', 'oc': 'picada', 'or': 'ନିବେଶ', 'pa_IN': 'ਇੰਪੁੱਟ', 'pt_BR': 'ler|leia', 'ro': 'input|intrare', 'ru': 'ввод', 'sat': 'आदेर', 'sd': 'اِن پُٽ', 'sid': 'eo', 'si': 'ආදානය', 'sk': 'Vstup', 'sl': 'vnos', 'sq': 'hyrje', 'ta': 'உள்ளீடு', 'te': 'ఇన్పుట్', 'tr': 'girdi', 'uk': 'ввести', 'vi': 'Nhập', 'zh_CN': '输入|input', 'zh_TW': '輸入|input'},
'PRINT':{'en_US': 'print', 'af': 'uitdruk', 'am': 'ማተሚያ', 'ar': 'اطبع', 'ast': 'imprentar', 'be': 'друк', 'bn_IN': 'মুদ্রণ', 'br': 'moullañ', 'bs': 'štampaj', 'ca': 'imprimeix', 'ca_valencia': 'imprimeix', 'ckb': 'چاپکردن', 'cy': 'argraffu', 'cs': 'piš', 'de': 'ausgabe', 'dsb': 'piš', 'el': 'τύπωσε|print', 'eo': 'presu|p', 'es': 'imprimir|escribir', 'et': 'kirjuta|prindi', 'eu': 'inprimatu', 'fi': 'tulosta', 'fr': 'écris', 'fy': 'printsje', 'gd': 'clò-bhuail', 'gl': 'imprimir', 'gug': 'imprimir', 'gu': 'છાપો', 'he': 'הדפסה', 'hi': 'छापें', 'hr': 'ispis', 'hsb': 'pisaj', 'hu': 'ki|kiír', 'is': 'prenta', 'ja': '表示|print', 'kab': 'aru', 'ka': 'ბეჭდვა', 'kk': 'баспа', 'km': 'បោះ\u200b\u200bពុម្ព\u200b', 'kn': 'ಮುದ್ರಿಸು', 'ko': '인쇄', 'lo': 'ພີມ', 'lt': 'spausdink|spd|rašyk', 'lv': 'drukāt', 'ml': 'പ്രിന്റ് ചെയ്യുക', 'mn': 'хэвлэх', 'mr': 'प्रिंट', 'my': 'ပရင့်ထုတ်ပါ', 'nb': 'skriv ut|skriv|print', 'ne': 'मुद्रण गर्नुहोस्', 'nl': 'afdrukken', 'nn': 'skriv ut|skriv|print', 'oc': 'imprimir', 'or': 'ମୁଦ୍ରଣ', 'pa_IN': 'ਛਾਪੋ', 'pt_BR': 'escrever|esc|escreva', 'ro': 'print|afișează', 'ru': 'печать', 'sid': 'attami', 'si': 'මුද්\u200dරණය කරන්න', 'sk': 'Tlač', 'sl': 'izpiši', 'sq': 'printo', 'ta': 'அச்சிடு', 'te': 'ముద్రణ', 'tr': 'yazdır', 'uk': 'друк', 'vec': 'stanpa', 'vi': 'In', 'zh_CN': '打印|印出|print', 'zh_TW': '印出|print'},
'SLEEP':{'en_US': 'sleep', 'af': 'wag', 'am': 'ማስተኛ', 'ar': 'نَم', 'as': 'নিদ্ৰা', 'ast': 'dormir', 'be': 'чакаць', 'br': 'kousket', 'bs': 'spavanje', 'ca': 'dorm|espera', 'ca_valencia': 'dorm|espera', 'ckb': 'خەوتن', 'cy': 'cysgu', 'cs': 'čekej', 'de': 'warte', 'dsb': 'cakaj', 'el': 'αναμονή|sleep', 'eo': 'dormu', 'es': 'dormir|espera', 'et': 'oota', 'eu': 'loegin', 'fi': 'nuku', 'fr': 'suspendre', 'fy': 'sliepe', 'gl': 'durmir', 'gug': 'ke', 'gu': 'નિદ્રા', 'he': 'לישון', 'hi': 'सुप्त', 'hr': 'spavaj', 'hsb': 'čakaj', 'hu': 'vár|várj', 'is': 'svæfa', 'ja': '待つ|sleep', 'kab': 'seṛǧu', 'kk': 'күту', 'km': 'ដេក', 'kn': 'ಜಡ', 'ko': '대기 모드', 'lo': 'ນອນ', 'lt': 'lauk', 'lv': 'gulēt', 'mn': 'хүлээх', 'mr': 'स्लीप', 'nb': 'sov|pause|sleep', 'nl': 'slaap', 'nn': 'sov|pause|sleep', 'oc': 'arrestar', 'or': 'ସୁପ୍ତ', 'pt_BR': 'esperar|espere', 'ro': 'sleep|adormire', 'ru': 'ждать', 'sid': 'goxi', 'sk': 'čakaj', 'sl': 'miruj', 'sq': 'gjumë', 'te': 'స్లీమ్', 'tr': 'askıya al', 'uk': 'чекай', 'vec': 'sospension', 'zh_CN': '休息|睡眠|sleep', 'zh_TW': '睡眠|休息|sleep'},
'GLOBAL':{'en_US': 'global', 'af': 'globaal', 'am': 'አለም አቀፍ', 'ar': 'عمومي', 'as': 'বিশ্বব্যাপী', 'be': 'агульны', 'bn_IN': 'গ্লোবাল', 'br': 'hollek', 'bs': 'opšte', 'ckb': 'جیهانیی', 'cy': 'byd eang', 'cs': 'globální', 'dsb': 'globalny', 'el': 'καθολικό|global', 'eo': 'ĉie', 'et': 'üldine', 'eu': 'globala', 'fi': 'yhteinen', 'fy': 'globaal', 'gu': 'વૈશ્વિક', 'he': 'כללי', 'hi': 'वैश्विक', 'hr': 'opći', 'hsb': 'globalny', 'hu': 'globális|globálisváltozó|globvál', 'is': 'víðvært', 'ja': 'どこからでも見える|グローバル|global', 'kab': 'amatu', 'kk': 'жалпы', 'km': 'សកល\u200b', 'kn': 'ಜಾಗತಿಕ', 'ko': '전역', 'lo': 'ທົ່ວໂລກ', 'lt': 'išorinis', 'lv': 'globāls', 'mn': 'ерөнхий', 'mr': 'ग्लोबल', 'nl': 'globaal', 'or': 'ଜାଗତିକ', 'ru': 'общее', 'sid': 'kalqe', 'sk': 'globálne', 'sl': 'globalno', 'sq': 'globale', 'te': 'గ్లోబల్', 'tr': 'küresel', 'uk': 'загальне', 'zh_CN': '全局|共用|global', 'zh_TW': '全域|共用|global'},
'RANDOM':{'en_US': 'random', 'af': 'willekeurig', 'am': 'በነሲብ', 'ar': 'عشوائي', 'as': 'যাদৃচ্ছিক', 'ast': 'aleatoriu', 'be': 'выпадкова', 'bn_IN': 'এলোমেলো', 'br': 'dargouezhek', 'bs': 'slučajno', 'ca': 'aleatori', 'ca_valencia': 'aleatori', 'ckb': 'هەڕەمەکی', 'cy': 'ar hap', 'cs': 'náhodné', 'de': 'zufällig', 'dsb': 'pśipadny', 'el': 'τυχαίο|random', 'eo': 'harzarda', 'es': 'aleatorio', 'et': 'juhuslik', 'eu': 'ausazkoa', 'fi': 'satunnainen', 'fr': 'hasard', 'fy': 'willekeurich', 'gl': 'aleatorio', 'gug': "Po'a Oimeraẽa (azar)", 'gu': 'અવ્યવસ્થિત', 'he': 'אקראי', 'hi': 'बेतरतीब', 'hr': 'nasumično', 'hsb': 'připadny', 'hu': 'véletlen|véletlenszám|vszám|kiválaszt', 'is': 'slembið', 'ja': 'でたらめな数|乱数|ランダム|random', 'kab': 'agacuṛan', 'kk': 'кездейсоқ', 'km': 'ចៃដន្យ', 'kn': 'ಯಾವುದಾದರು', 'ko': '임의', 'lo': 'ສຸ່ມ', 'lt': 'bet.koks', 'lv': 'nejaušs', 'mn': 'санамсаргүй', 'mr': 'रँडम', 'nb': 'tilfeldig|random', 'nl': 'random|willekeurig', 'nn': 'tilfeldig|random', 'oc': 'aleatòri', 'or': 'ଅନିୟମିତ', 'pt_BR': 'aleatório|sorteieNúmero|sortNum', 'ro': 'random|aleator', 'ru': 'случайно', 'sid': 'hedeweelcho', 'sk': 'náhodné', 'sl': 'naključno', 'sq': 'rastësore', 'te': 'యాదృశ్చిక', 'tr': 'rastgele', 'uk': 'випадкове', 'vec': 'cazuałe', 'zh_CN': '随机|random', 'zh_TW': '隨機|random'},
'INT':{'en_US': 'int', 'af': 'heel', 'ar': 'عدد_صحيح', 'be': 'цэлае', 'br': 'kevan', 'bs': 'cijeli broj', 'cs': 'celé', 'de': 'ganz', 'dgo': 'INT', 'dsb': 'ceły', 'el': 'ακέραιο|int', 'eo': 'entjero|ent', 'et': 'täisarv', 'eu': 'osoa', 'fi': 'kokonaisl', 'fr': 'ent', 'fy': 'ynt', 'he': 'שלם', 'hsb': 'cyły', 'hu': 'egészszám|egész', 'is': 'heilt', 'ja': '切り捨て|整数|整数に|int', 'kab': 'ilaw', 'kk': 'бүтін', 'kok': 'INT', 'ko': '정수', 'lt': 'sveikoji.dalis|svdl', 'lv': 'vesels', 'mn': 'бүтэн', 'mr': 'इंट', 'nb': 'heltall|int', 'nn': 'heiltal', 'or': 'ଗଣନ ସଂଖ୍ୟା', 'ru': 'целое', 'sa_IN': 'INT', 'sat': 'INT', 'sid': 'di"ikkanno', 'sk': 'celé', 'sl': 'celo', 'tr': 'tamsayı', 'uk': 'ціле', 'zh_CN': '整数|int', 'zh_TW': '整數|int'},
'FLOAT':{'en_US': 'float', 'af': 'komma', 'am': 'ማንሳፈፊያ', 'ar': 'عدد عشري', 'ast': 'flotante', 'be': 'дробавае', 'bn_IN': 'ভাসমান', 'br': 'tonnañ', 'bs': 'realni', 'cy': 'arnofio', 'cs': 'desetinné', 'de': 'dezimal', 'dsb': 'decimalny', 'el': 'κινητήυποδιαστολή|float', 'eo': 'reelo', 'et': 'ujukomaarv|ujukoma', 'eu': 'dezimala', 'fi': 'desimaalil', 'fr': 'virgule', 'fy': 'driuwe', 'gl': 'flotante', 'gug': 'vevúi', 'gu': 'અપૂર્ણાંક', 'he': 'שבר', 'hi': 'प्लावित करें', 'hr': 'pomični', 'hsb': 'decimalny', 'hu': 'törtszám|tört', 'is': 'fleyti', 'ja': '小数|小数に|float', 'kab': 'ilaw', 'ka': 'მოლივლივე', 'kk': 'бөлшек', 'km': 'អណ្ដែត', 'kn': 'ತೇಲು', 'ko': '둥둥 뜨기', 'lt': 'trupmeninis.skaičius|trsk', 'lv': 'reāls', 'ml': 'ഫ്\u200dളോട്ട്', 'mn': 'аравтын', 'mr': 'फ्लोट', 'my': 'ပေါလောပေါ်သည်', 'nb': 'flyttall|float', 'ne': 'फ्लोट', 'nl': 'komma', 'nn': 'flyttal|desimaltal|float', 'oc': 'virgula', 'or': 'ଚଳମାନ', 'pa_IN': 'ਤੈਰਦਾ', 'pt_BR': 'real', 'ru': 'дробное', 'sat': 'चापे.', 'sid': 'womi', 'si': 'පාවීම', 'sk': 'Plávať', 'sl': 'plavajoče', 'sq': 'presje e lëvizshme', 'te': 'ఫ్లోట్', 'tr': 'kayan', 'uk': 'дробове', 'vec': 'mobiłidà', 'vi': 'Nổi', 'zh_CN': '浮点|小数|float', 'zh_TW': '浮點|float'},
'STR':{'en_US': 'str', 'ar': 'سلسلة', 'be': 'радок', 'br': 'hedad', 'ckb': '\u202bstr', 'cs': 'řetězec', 'de': 'zeichen', 'dsb': 'znamuška', 'el': 'συμβολοσειρά|str', 'eo': 'ĉeno', 'et': 'sõne|string', 'fi': 'mjono', 'fr': 'car', 'he': 'מחרוזת', 'hr': 'niz', 'hsb': 'znarjećazk', 'hu': 'karakterlánc|lánc', 'ja': '文字列|文字列に|str', 'kab': 'asekkil', 'kk': 'жол', 'lt': 'teksto.eilutė|te', 'lv': 'virkne', 'mn': 'тэмдэгт', 'mr': 'स्ट्रिंग', 'nl': 'teken', 'oc': 'car', 'ru': 'строка', 'sk': 'reťazec', 'sl': 'niz', 'tr': 'dizi', 'uk': 'рядок', 'vec': 'stringa', 'zh_CN': '字串|字符串|str', 'zh_TW': '字串|str'},
'SQRT':{'en_US': 'sqrt', 'af': 'vierkantswortel', 'am': 'ስኴር ሩት', 'ar': 'جذر تربيعي', 'ast': 'raiz', 'be': 'корань', 'br': 'daouvonad', 'bs': 'korijen', 'ca': 'arrel', 'ca_valencia': 'arrel', 'ckb': 'ڕەگ', 'cs': 'odmocnina', 'de': 'wurzel', 'dgo': 'SQRT', 'dsb': 'kórjeń', 'el': 'τετραγωνικήρίζα|sqrt', 'eo': 'kvrad', 'es': 'raiz.cuadrada|raiz|sqrt', 'et': 'ruutjuur|rtjr|√', 'fi': 'neliöjuuri', 'fr': 'racine', 'fy': 'sqrt|fjouwerkantswoartel|fw', 'gl': 'raizc', 'gug': 'raiz.cuadrada|raiz|sqrt', 'he': 'שורש', 'hr': 'korijen', 'hsb': 'korjeń', 'hu': 'gyök', 'is': 'kvaðratr', 'ja': '平方根|sqrt', 'kab': 'aẓar', 'kok': 'SQRT', 'lt': 'šaknis|sqrt', 'lv': 'kvadrātsakne', 'mn': 'язгуур', 'mr': 'स्केअररूट', 'nb': 'kvrot|sqrt', 'nl': 'sqrt|vierkantswortel|vw', 'nn': 'kvrot|rot|sqrt', 'pt_BR': 'raiz|raizQ', 'sa_IN': 'SQRT', 'sat': 'SQRT', 'sk': 'odmocnina', 'sl': 'koren', 'sq': 'rrënja katrore', 'tr': 'karekök', 'uk': 'корінь', 'vec': 'raizacuadrada', 'zh_CN': '平方根|方根|开方|sqrt', 'zh_TW': '開根|方根|sqrt'},
'LOG10':{'en_US': 'log10', 'am': 'ሎግ10', 'ar': 'لوغاريثم عشري', 'ckb': '\u202blog10', 'he': 'לוגריתם_10', 'kab': 'alug10', 'ug': 'لوگارىفما|log10', 'zh_CN': '对数|log10', 'zh_TW': '對數|log10'},
'SIN':{'en_US': 'sin', 'am': 'ሳይን', 'ar': 'جا', 'ast': 'sen', 'ckb': 'ساین', 'dgo': 'SIN', 'el': 'ημίτονο|sin', 'es': 'sen', 'fi': 'sini', 'gl': 'sen', 'gug': 'sen', 'he': 'סינוס', 'is': 'sín', 'kab': 'asin', 'kok': 'SIN', 'mr': 'साइन', 'pt_BR': 'sen', 'sa_IN': 'SIN', 'sat': 'SIN', 'sid': 'sayine', 'vec': 'seno', 'zh_CN': '正弦|sin', 'zh_TW': '正弦|sin'},
'COS':{'en_US': 'cos', 'am': 'ኮስ', 'ar': 'جتا', 'br': 'kos', 'ckb': 'کۆس', 'dgo': 'COS', 'el': 'συνημίτονο|cos', 'eo': 'kos', 'fi': 'kosini', 'he': 'קוסינוס', 'is': 'kós', 'kab': 'akus', 'kok': 'COS', 'mr': 'कॉस', 'sa_IN': 'COS', 'sat': 'COS', 'sid': 'koose', 'tr': 'kos', 'vec': 'cozeno', 'zh_CN': '余弦|cos', 'zh_TW': '餘弦|cos'},
'ROUND':{'en_US': 'round', 'af': 'rondaf', 'am': 'ክብ', 'ar': 'دائري', 'as': 'গোলাকাৰ', 'ast': 'redondu', 'be': 'круглы', 'bn_IN': 'রাউন্ড', 'br': 'ront', 'bs': 'okruglo', 'ca': 'arrodoneix|arrod', 'ca_valencia': 'arredoneix|arred', 'ckb': 'خولاوە', 'cy': 'crwn', 'cs': 'oblé', 'de': 'runde', 'dsb': 'narownaj', 'el': 'στρογγυλοποίηση|round', 'eo': 'ronda', 'es': 'redondear', 'et': 'ümar', 'eu': 'biribildua', 'fi': 'pyöreä', 'fr': 'arrondi', 'fy': 'ôfrûne', 'gd': 'cruinn', 'gl': 'arredondar', 'gug': "emoapu'a", 'gu': 'રાઉન્ડ', 'he': 'עגול', 'hi': 'गोल', 'hr': 'zaokruži', 'hsb': 'nakruž', 'hu': 'kerek', 'is': 'rúnnað', 'ja': '四捨五入|round', 'kab': 'yattwaẓ', 'ka': 'მრგვალი', 'kk': 'домалақтау', 'km': 'មូល', 'kn': 'ದುಂಡಾದ', 'ko': '반올림', 'lo': 'ຮອບ', 'lt': 'apvalink', 'lv': 'apaļš', 'ml': 'ഉരുണ്ട', 'mn': 'бүхэл', 'mr': 'गोलाकार', 'my': 'ပတ်လည်', 'nb': 'avrund|round', 'ne': 'गोलाकार', 'nl': 'rondaf', 'nn': 'avrund|round', 'oc': 'arredondit', 'or': 'ଗୋଲାକାର', 'pa_IN': 'ਗੋਲ', 'pt_BR': 'arred|arredonde', 'ro': 'round|rotund', 'ru': 'скруглить', 'sid': 'doyiissi', 'si': 'වටකුරු', 'sk': 'zaoblené', 'sl': 'zaokroži', 'sq': 'rrumbullak', 'ta': 'வட்டம்', 'te': 'రౌండ్', 'tr': 'yuvarla', 'ug': 'يۇمۇلاق', 'uk': 'закруглити', 'vec': 'stonda', 'vi': 'Làm tròn', 'zh_CN': '四舍五入|舍入|round', 'zh_TW': '四捨五入|round'},
'ABS':{'en_US': 'abs', 'am': 'ፍጹም', 'ar': 'مطلق', 'bn_IN': 'ট্যাব', 'br': 'dizave', 'ckb': '\u202babs', 'cs': 'absolutní', 'de': 'betrag', 'dsb': 'absolutny|abs', 'el': 'απόλυτο', 'et': 'absoluutväärtus|abs', 'fi': 'itseisarvo', 'he': 'ערך מוחלט', 'hi': 'टैब्स', 'hr': 'aps', 'hsb': 'absolutny|abs', 'hu': 'abszolútérték|absz?', 'is': 'algilt', 'ja': '絶対値|abs', 'kab': 'amagdez', 'ka': 'ტაბულაციები', 'kn': 'ಟ್ಯಾಬ್\u200cಗಳು', 'ko': '탭', 'lt': 'ilgis|abs|modulis', 'lv': 'modulis', 'mr': 'ॲब्स', 'my': 'အကွက်ခုန်များ', 'ne': 'ट्याबहरू', 'pa_IN': 'ਟੈਬ', 'sid': 'abse', 'si': 'පටිති', 'te': 'టాబ్ లు', 'tr': 'mutlak', 'vi': 'Tab', 'zh_CN': '绝对值|abs', 'zh_TW': '絕對值|abs'},
'COUNT':{'en_US': 'count', 'af': 'telling', 'am': 'መቁጠሪያ', 'ar': 'عُدّ', 'as': 'গণনা', 'ast': 'contéu', 'br': 'Niver', 'brx': 'साननाय', 'bs': 'mjesta', 'ca': 'compte', 'ca_valencia': 'compte', 'ckb': 'ژماردن', 'cy': 'cyfrif', 'cs': 'počet', 'de': 'zähle', 'dgo': 'गिनतरी', 'dsb': 'licyś', 'dz': 'གྱངས་ཁ་རྐྱབས།', 'el': 'πλήθος|count', 'eo': 'nombru', 'es': 'conteo', 'et': 'loenda', 'eu': 'zenbaketa', 'fi': 'lukumäärä', 'fr': 'compte', 'fy': 'tal', 'gd': 'cunntas', 'gl': 'decimais', 'gug': 'econta', 'gu': 'ગણતરી', 'he': 'ספירה', 'hi': 'गिनती', 'hr': 'brojanje', 'hsb': 'ličić', 'hu': 'darab|db|elemszám', 'is': 'fjöldi', 'ja': '文字数|持っている数|count', 'kab': 'Amḍan', 'ka': 'თვლა', 'kk': 'саны', 'km': 'ចំនួន', 'kmr_Latn': 'Bihijmêre', 'kn': 'ಎಣಿಕೆ', 'kok': 'गणन', 'ko': '수', 'ks': 'شمار', 'lo': 'ນັບ', 'lt': 'kiek', 'lv': 'skaits', 'mai': 'गिनती', 'mk': 'Број', 'ml': 'എണ്ണം', 'mni': 'মশিং থীয়ু', 'mn': 'тоо хэмжээ', 'mr': 'काउंट', 'my': 'ရေတွက်ပါ', 'nb': 'tell|count', 'ne': 'गणना', 'nl': 'aantal', 'nn': 'tel|plassar|count', 'oc': 'nb_decimalas', 'om': "baay'ina", 'or': 'ଗଣନା', 'pa_IN': 'ਗਿਣਤੀ', 'pt_BR': 'contagem', 'ro': 'count|contor', 'ru': 'количество', 'rw': 'kubara', 'sa_IN': 'गणना', 'sat': 'लेखाक्', 'sid': 'kiiri', 'si': 'ගණන් කරන්න', 'sk': 'počet', 'sl': 'preštej', 'sq': 'numëro', 'sw_TZ': 'hesabu', 'ta': 'எண்ணிக்கை', 'te': 'లెక్క', 'tg': 'Шумора', 'th': 'นับ', 'tr': 'sayım', 'uk': 'кількість', 'uz': 'Miqdor', 'vec': 'contejo', 'vi': 'đếm', 'zh_CN': '计数|count', 'zh_TW': '計數|count'},
'SET':{'en_US': 'set', 'af': 'versameling', 'am': 'ማሰናጃ', 'ar': 'مجموعة', 'ast': 'establecer', 'bn_IN': 'সেট', 'br': 'arventenn', 'bs': 'postavi', 'ca': 'conjunt', 'ca_valencia': 'conjunt', 'ckb': 'سێت', 'cs': 'množina', 'de': 'menge', 'dgo': 'सैट्ट करो', 'dsb': 'młogosć', 'el': 'σύνολο|set', 'eo': 'aro', 'es': 'conjunto', 'et': 'hulk', 'eu': 'ezarri', 'fi': 'joukko', 'fr': 'fixe', 'fy': 'set|ynstelle', 'gl': 'estabelecer', 'gug': 'aty', 'gu': 'સુયોજન', 'he': 'קבוצה', 'hr': 'skup', 'hsb': 'mnohosć', 'hu': 'halmaz', 'is': 'setja', 'ja': '同じ値を一つに|集合に|集合|set', 'kab': 'usbiḍ', 'kk': 'орнату', 'km': 'កំណត់', 'kok': 'संचSonch', 'ko': '설정', 'lo': 'ຕັ້ງຄ່າ', 'lt': 'parink', 'lv': 'iestatīt', 'mn': 'олонлиг', 'mr': 'सेट', 'nb': 'sett|set', 'nl': 'set|instellen', 'or': 'ସେଟ', 'pt_BR': 'conjunto', 'ru': 'установить', 'sa_IN': 'सॆट', 'sat': 'साजाव', 'sd': 'سيٽ', 'sid': 'qineessi', 'sk': 'množina', 'sl': 'množica', 'sq': 'vendos', 'tr': 'ayarla', 'uk': 'встановити', 'zh_CN': '集合|set', 'zh_TW': '集合|set'},
'RANGE':{'en_US': 'range', 'af': 'omvang', 'am': 'መጠን', 'ar': 'النطاق', 'as': 'বিস্তাৰ', 'ast': 'estaya', 'bn_IN': 'পরিসর', 'bn': 'পরিসর', 'br': 'lijorenn', 'brx': 'सारि', 'bs': 'opseg', 'ca': 'interval', 'ca_valencia': 'interval', 'ckb': 'بوار', 'cy': 'ystod', 'cs': 'rozsah', 'de': 'folge', 'dgo': 'फलाऽ', 'dsb': 'slěd', 'dz': 'ཁྱབ་ཚད།', 'el': 'περιοχή|range', 'eo': 'amplekso', 'es': 'intervalo', 'et': 'vahemik', 'eu': 'barrutia', 'fa': 'محدوده', 'fi': 'alue', 'fr': 'plage', 'fy': 'berik', 'gd': 'rainse', 'gl': 'intervalo', 'gug': 'intervalo', 'gu': 'વિસ્તાર', 'he': 'טווח', 'hi': 'दायरा', 'hr': 'raspon', 'hsb': 'slěd', 'hu': 'sor', 'is': 'svið', 'ja': '範囲|range', 'kab': 'azilal', 'ka': 'ფორთოხლისფერი', 'kk': 'ауқым', 'km': 'ជួរ', 'kmr_Latn': 'Navber', 'kn': 'ವ್ಯಾಪ್ತಿ', 'kok': 'व्याप्ती', 'ko': '범위', 'ks': 'حد', 'lo': 'ຂອບເຂດ', 'lt': 'sritis', 'lv': 'diapazons', 'mai': 'परिसर', 'mk': 'Опсег', 'ml': 'പരന്പര', 'mni': 'রেন্জ', 'mn': 'муж', 'mr': 'रेंज', 'my': 'ကန့်သတ်နယ်ပယ်', 'nb': 'område|range', 'ne': 'दायरा', 'nl': 'bereik', 'nn': 'område|range', 'oc': 'plaja', 'om': 'hangii', 'or': 'ପରିସର', 'pa_IN': 'ਰੇਜ਼', 'pt_BR': 'intervalo', 'ro': 'range|interval', 'ru': 'диапазон', 'rw': 'igice', 'sa_IN': 'प्रसरः', 'sat': 'पासनाव', 'sid': 'hakkigeeshsha', 'si': 'පරාසය', 'sk': 'oblasť', 'sl': 'obseg', 'sq': 'interval', 'sw_TZ': 'masafa', 'ta': 'வரம்பு', 'te': 'విస్తృతి', 'tg': 'Қитъа', 'th': 'ช่วง', 'tr': 'aralık', 'tt': 'колач', 'uk': 'діапазон', 'uz': 'oraliq', 'vec': 'travało', 'vi': 'phạm vi', 'zh_CN': '范围|range', 'zh_TW': '範圍|range'},
'LIST':{'en_US': 'list', 'af': 'lys', 'am': 'ዝርዝር', 'ar': 'قائمة', 'ast': 'llista', 'be': 'спіс', 'bn_IN': 'তালিকা', 'br': 'roll', 'bs': 'lista', 'ca': 'llista', 'ca_valencia': 'llista', 'ckb': 'لیستە', 'cy': 'rhestr', 'cs': 'seznam', 'de': 'liste', 'dgo': 'सूची', 'dsb': 'lisćina', 'el': 'κατάλογος|list', 'eo': 'listo', 'es': 'lista', 'et': 'loend', 'eu': 'zerrenda', 'fi': 'lista', 'fr': 'liste', 'gl': 'lista', 'gug': 'lista', 'gu': 'યાદી', 'he': 'רשימה', 'hi': 'सूची', 'hr': 'popis', 'hsb': 'lisćina', 'hu': 'lista', 'is': 'listi', 'ja': 'リスト|list', 'kab': 'tabdart', 'ka': 'სია', 'kk': 'тізім', 'km': 'បញ្ជី', 'kn': 'ಪಟ್ಟಿ', 'ko': '목록', 'lo': 'ລາຍການ', 'lt': 'gauk.sąrašą|sąrašas|gksr', 'lv': 'saraksts', 'mn': 'жагсаалт', 'mr': 'लिस्ट', 'my': 'စာရင်း', 'nb': 'liste|list', 'ne': 'सूची', 'nl': 'lijst', 'nn': 'liste|list', 'oc': 'lista', 'or': 'ତାଲିକା', 'pt_BR': 'lista', 'ro': 'list|listă', 'ru': 'список', 'sat': 'लिसटी', 'sid': 'dirto', 'si': 'ලැයිස්තුව', 'sk': 'Zoznam', 'sl': 'izpišiseznam', 'sq': 'lista', 'ta': 'பட்டியல்', 'te': 'జాబిత', 'tr': 'liste', 'uk': 'список', 'zh_CN': '列表|list', 'zh_TW': '清單|列表|list'},
'TUPLE':{'en_US': 'tuple', 'af': 'tupel', 'am': 'ቱፕል', 'ast': 'tupla', 'be': 'картэж', 'br': 'kemalenn', 'bs': 'pobrojane', 'ca': 'tupla', 'ca_valencia': 'tupla', 'cs': 'ntice', 'de': 'tupel', 'dsb': 'tupel', 'el': 'πλειάδα|tuple', 'eo': 'opo', 'es': 'tupla', 'et': 'ennik|korteež', 'eu': 'tuploa', 'fi': 'pari', 'gl': 'tupla', 'gug': 'tupla', 'gu': 'ટપલ', 'he': 'סדרהסדורה', 'hr': 'torka', 'hsb': 'tupel', 'hu': 'fix', 'is': 'tuple-röð', 'ja': '変更できないリスト|タプル|tuple', 'kk': 'кортеж', 'kn': 'ಟಪಲ್', 'ko': '튜플', 'lt': 'kortežas', 'lv': 'kortežs', 'mr': 'टपल', 'nb': 'tuppel', 'nl': 'tuple|tupel', 'or': 'ଟ୍ୟୁପଲ', 'pt_BR': 'tupla', 'ro': 'tuple|fix', 'ru': 'кортеж', 'sid': 'tupile', 'sk': 'ntica', 'sl': 'par', 'tr': 'tüp', 'uk': 'кортеж', 'vec': 'tupla', 'zh_CN': '元组|tuple', 'zh_TW': '元組|tuple'},
'SORTED':{'en_US': 'sorted', 'af': 'gesorteer', 'am': 'ተለይቷል', 'ar': 'مُفرَز', 'as': 'বৰ্গীকৰণ কৰি থোৱা', 'ast': 'ordenao', 'bn_IN': 'বিন্যস্ত', 'bn': 'বিন্যস্ত', 'bo': 'range_lookup', 'br': 'rummet', 'brx': 'थाखो खालाखानाय', 'bs': 'sortirano', 'ca': 'ordenat', 'ca_valencia': 'ordenat', 'ckb': 'رێکخراو', 'cy': 'trefnwyd', 'cs': 'seřazeno', 'de': 'sortiert', 'dgo': 'छांटेआ', 'dsb': 'sortěrowany', 'dz': 'དབྱེ་སེལ་འབད་ཡོདཔ།', 'el': 'ταξινομημένα|sorted', 'eo': 'ordigita', 'es': 'ordenado', 'et': 'sorditud', 'eu': 'ordenatua', 'fa': 'مرتب\u200cشده', 'fi': 'lajiteltu', 'fr': 'trié', 'fy': 'sortearre', 'gd': 'air a sheòrsachadh', 'gl': 'ordenado', 'gug': "ojemohenda va'ekue", 'gu': 'ગોઠવાયેલ', 'he': 'עםמיון', 'hi': 'छांटा हुआ', 'hr': 'razvrstano', 'hsb': 'sortěrowany', 'hu': 'rendez', 'is': 'raðað', 'ja': '並び替える|ソート|sorted', 'kab': 'trié', 'kk': 'сұрыпталған', 'km': 'បាន\u200bតម្រៀប', 'kmr_Latn': 'Rêzkirî', 'kn': 'ವಿಂಗಡಿಸಲಾದ', 'kok': 'वर्गीकृत', 'ko': '정렬', 'ks': 'ساٹ كرمُت', 'lo': 'ຈັດລຽງ', 'lt': 'rikiuok', 'lv': 'sakārtots', 'mai': 'सोर्ट कएल गेल', 'mk': 'Подредување', 'ml': 'വകതിരിച്ച', 'mni': 'মথং-মনাও শেম্লবা', 'mn': 'эрэмбэлэгдсэн', 'mr': 'सॉर्टेड', 'my': 'စနစ်တကျစီထားသည်', 'nb': 'sortert|sorted', 'ne': 'क्रमबद्व गरिएको', 'nl': 'gesorteerd', 'nn': 'sortert|sorted', 'nr': 'hleliwe', 'nso': 'arogantšwe', 'oc': 'triat', 'om': "foo'amaa", 'or': 'ସଜାହୋଇଥିବା', 'pa_IN': 'ਲੜੀਬੱਧ', 'pt_BR': 'ordenado', 'ro': 'sorted|sortat', 'ru': 'отсортировано', 'rw': 'bishunguwe', 'sa_IN': 'क्रमितम्', 'sat': 'साला आकान', 'sd': 'वर्गीकृत केलेले', 'sid': 'diramino', 'si': 'සුබෙදන ලදි', 'sk': 'zoradené', 'sl': 'razvrščeno', 'sq': 'klasifikuar', 'ss': 'kuhlelekile', 'st': 'hlophilwe', 'sw_TZ': 'i-liyopangwa', 'ta': 'அடுக்கப்பட்டது', 'te': 'క్రమబద్దీకరించబడినది', 'tg': 'низомнокшуда', 'th': 'เรียง', 'tn': 'bakantswe', 'tr': 'sıralanmış', 'ts': 'xaxametiwile', 'uk': 'сортований', 'uz': 'saralangan', 'vec': 'ordenà', 've': 'yo dzudzanywa', 'vi': 'đã sắp xếp', 'xh': 'hlela-hlela', 'zh_CN': '排序|sorted', 'zh_TW': '排序|sorted', 'zu': 'ihleliwe'},
'RESUB':{'en_US': 'sub', 'af': 'voetskrif', 'am': 'ንዑስ', 'ar': 'استبدل', 'br': 'is', 'cs': 'nahraď', 'de': 'ersetzt', 'dsb': 'wuměń', 'el': 'αντικατάσταση', 'eo': 'anstataŭu|anst', 'et': 'asenda', 'eu': 'azpi', 'fi': 'korvaa', 'fy': 'ûnderline', 'gu': 'ઉપ', 'he': 'שגרה', 'hr': 'zamjena', 'hsb': 'wuměń', 'hu': 'cserél', 'is': 'skipta|útskipta', 'ja': '文字のおきかえ|置換|sub', 'kab': 'anaddaw', 'kn': 'ಉಪ', 'lo': 'ຍ່ອຍ', 'lt': 'keisk', 'lv': 'aizvietot', 'mr': 'सब', 'nb': 'bytt|bytt ut|sub', 'nl': 'onderlijn', 'nn': 'byt|byt ut|sub', 'or': 'ଉପ', 'pt_BR': 'subst', 'sid': 'cinaancho', 'sk': 'nahraď', 'sl': 'zam', 'sq': 'nën', 'tr': 'alt', 'uk': 'зам', 'zh_CN': '替换|sub', 'zh_TW': '替換|sub'},
'RESEARCH':{'en_US': 'search', 'af': 'soek', 'am': 'መፈለጊያ', 'ar': 'ابحث', 'as': 'সন্ধান কৰক', 'ast': 'guetar', 'be': 'знайсці', 'bn_IN': 'অনুসন্ধান', 'br': 'klask', 'bs': 'traži', 'ca': 'cerca', 'ca_valencia': 'busca', 'ckb': 'گەڕان', 'cy': 'chwilio', 'cs': 'hledej', 'de': 'suche', 'dsb': 'pytaj', 'el': 'αναζήτηση|search', 'eo': 'serĉu', 'es': 'buscar', 'et': 'otsi', 'eu': 'bilatu', 'fi': 'etsi', 'fr': 'recherche', 'fy': 'sykje', 'gl': 'buscar', 'gug': 'heka', 'gu': 'શોધો', 'he': 'חיפוש', 'hi': 'खोजें', 'hr': 'pretraživanje', 'hsb': 'pytaj', 'hu': 'keres', 'is': 'leita', 'ja': '探す|みつける|検索|search', 'kab': 'nadi', 'kk': 'іздеу', 'km': 'ស្វែងរក\u200b', 'kn': 'ಹುಡುಕು', 'ko': '검색', 'lo': 'ຄົ້ນຫາ', 'lt': 'ieškok', 'lv': 'meklēt', 'ml': 'തെരയുക', 'mn': 'хайх', 'mr': 'शोधा', 'my': 'ရှာဖွေပါ', 'nb': 'søk|finn|search', 'ne': 'खोज गर्नुहोस्', 'nl': 'zoeken', 'nn': 'søk|finn|search', 'oc': 'recercar', 'or': 'ଖୋଜନ୍ତୁ', 'pa_IN': 'ਲੱਭੋ', 'pt_BR': 'pesquisa', 'ro': 'search|caută', 'ru': 'найти', 'sid': 'hasi', 'sk': 'Hľadať', 'sl': 'išči', 'sq': 'kërko', 'ta': 'தேடு', 'te': 'వెతుకు', 'tr': 'ara', 'uk': 'знайти', 'vec': 'reserca', 'vi': 'Tìm', 'zh_CN': '查找|搜索|search', 'zh_TW': '搜尋|search'},
'REFINDALL':{'en_US': 'findall', 'af': 'vind alles', 'am': 'ሁሉንም መፈለጊያ', 'ar': 'اعثر_على_كل', 'ast': 'alcontrartoo', 'br': 'kavout an holl', 'bs': 'nadjisve', 'ca': 'cerca.tot|troba.tot', 'ca_valencia': 'busca.tot|troba.tot', 'cs': 'najdivše', 'de': 'findealle', 'dsb': 'namakajwše', 'el': 'εύρεσηόλων|findall', 'eo': 'serĉu_ĉion|ĉionserĉu', 'es': 'buscar.todo|encontrar.todo|bt', 'et': 'leia_kõik', 'eu': 'bilatudenak', 'fi': 'etsikaikki', 'fr': 'touttrouver', 'fy': 'sykjealles', 'gl': 'atopartodo', 'gug': 'hekaopavave', 'gu': 'બધુ શોધો', 'he': 'חיפושהכול', 'hr': 'pronađi sve', 'hsb': 'namakajwšě', 'hu': 'talál', 'is': 'finnaallt', 'ja': '見つかったものを全部ならべる|findall', 'kab': 'afakk', 'kk': 'барлығын_табу', 'kn': 'ಎಲ್ಲಾಹುಡುಕು', 'ko': '모두 찾기', 'lo': 'ຄົ້ນຫາທັງໝົດ', 'lt': 'rask.viską', 'lv': 'atrast_visu', 'mn': 'бүгдийг_ол', 'mr': 'सर्व शोधा', 'nb': 'finnalle|findall', 'nl': 'vindalles', 'nn': 'finnalle|findall', 'oc': 'trobartot', 'or': 'ସମସ୍ତଙ୍କୁ ଖୋଜନ୍ତୁ', 'pt_BR': 'localizaTudo', 'ro': 'findall|cautătoate', 'ru': 'найти_всё', 'sid': 'baalahasi', 'sk': 'nájsťvšetko|nv', 'sl': 'najdivse', 'sq': 'gjejitëgjitha', 'tr': 'hepsinibul', 'uk': 'знайти_все', 'vec': 'catatuto', 'zh_CN': '查找全部|全部查找|findall', 'zh_TW': '找全部|全找|findall'},
'MIN':{'en_US': 'min', 'am': 'አነስተኛ', 'ar': 'الأدنى', 'be': 'мін', 'bn_IN': 'সর্বনিম্ন', 'br': 'izek', 'ca': 'mín|min', 'ca_valencia': 'mín|min', 'ckb': 'نزمترین', 'cy': 'mun', 'dgo': 'घट्टोघट्ट', 'el': 'ελάχιστο|min', 'fi': 'pienin', 'gd': 'as lugha', 'gu': 'ન્યૂનત્તમ', 'he': 'מזערי', 'is': 'lágm', 'ja': 'いちばん小さな数|最小値|最小|min', 'kab': 'adday', 'kk': 'мин', 'km': 'នាទី', 'kn': 'ಕನಿಷ್ಟ', 'kok': 'किमान (~c)Konixtt (~c)', 'lo': 'ຕ່ຳສຸດ', 'lt': 'min.|minimumas', 'mr': 'मिन', 'or': 'ସର୍ବନିମ୍ନ', 'pt_BR': 'mínimo|mín', 'ru': 'мин', 'sa_IN': 'कम ख्तॆ कम', 'sat': 'कोम उता़र, (~c)', 'sd': 'گهٽِ ۾ گهٽ', 'sid': 'shiima', 'sl': 'najmanj', 'te': 'కనిష్ట', 'uk': 'мін', 'zh_CN': '最小值|最小|min', 'zh_TW': '最小值|最小|min'},
'MAX':{'en_US': 'max', 'af': 'maks', 'am': 'ከፍተኛ', 'ar': 'الأقصى', 'be': 'макс', 'bn_IN': 'সর্বোচ্চ', 'br': "uc'hek", 'ca': 'màx|max', 'ca_valencia': 'màx|max', 'ckb': 'بەرزترین', 'cy': 'uchaf', 'dgo': 'बद्धोबद्ध', 'dsb': 'maks', 'el': 'μέγιστο|max', 'eo': 'maks', 'et': 'max|maks', 'fi': 'suurin', 'fy': 'maks', 'gd': 'as motha', 'gl': 'máx', 'gu': 'મહત્તમ', 'he': 'מרבי', 'hr': 'maks', 'hsb': 'maks', 'is': 'hám', 'ja': 'いちばん大きな数|最大値|最大|max', 'kab': 'afellay', 'kk': 'макс', 'km': 'អតិបរមា', 'kn': 'ಗರಿಷ್ಟ', 'kok': 'कमालGarixtt', 'ko': '최대값', 'lo': 'ສູງສຸດ', 'lt': 'maks.|maksimumas', 'lv': 'maks', 'mr': 'मॅक्स', 'nb': 'maks|max', 'nn': 'maks|max', 'or': 'ସର୍ବାଧିକ', 'pt_BR': 'máximo|máx', 'ru': 'макс', 'sa_IN': 'ज़यादॆ खूते ज़यादॆ', 'sat': 'ढेर उता़र,', 'sd': 'وڌِ ۾ وَڌِ', 'sid': 'jawa', 'sl': 'največ', 'sq': 'maks', 'te': 'గరిష్ట', 'tr': 'en çok', 'uk': 'макс', 'zh_CN': '最大值|max', 'zh_TW': '最大值|最大|max'},
'PI':{'en_US': 'pi|π', 'am': 'ፓይ|π', 'ar': 'ط|باي|π', 'ckb': '\u202bpi|π', 'el': 'πι|pi|π', 'et': 'pii|π', 'fi': 'pii|π', 'gl': 'pi|n', 'he': 'פאי|פיי', 'ja': '円周率|pi|π', 'kk': 'pi|пи|π', 'ko': '파이|π', 'mn': 'pi|пи|π', 'mr': 'पाय|π', 'ru': 'pi|пи|π', 'sid': 'payi|π', 'uk': 'pi|пі|π', 'zh_CN': '圆周率|pi|π', 'zh_TW': 'pi|π|拍'},
'DECIMAL':{'en_US': '.', 'af': ',', 'ast': ',', 'ca': ',', 'ca_valencia': ',', 'cs': ',', 'de': ',', 'dsb': ',', 'eo': ',', 'et': ',', 'fi': ',', 'hsb': ',', 'hu': ',', 'lt': ',', 'mn': ',', 'nb': ',', 'nn': ',', 'sl': ','},
'DEG':{'en_US': '°', 'zh_CN': '°|度', 'zh_TW': '°|度'},
'HOUR':{'en_US': 'h', 'ar': 'س', 'br': 'e', 'ckb': 'ک', 'et': 't', 'he': 'שע', 'hu': 'ó|h', 'is': 'klst', 'ja': '時間|h', 'kab': 'asrag', 'kk': 'с', 'lt': 'val', 'nb': 't', 'nn': 't|h', 'sl': 'u', 'tr': 'sa.', 'zh_CN': 'h|小时', 'zh_TW': 'h|小時'},
'MM':{'en_US': 'mm', 'am': 'ሚ/ሚ', 'ar': 'مم', 'as': 'মি.মি.', 'be': 'мм', 'bn_IN': 'মিমি', 'bn': 'মিমি', 'bo': 'ཧའི་སྨི།', 'ckb': 'ملم', 'dgo': 'मी.मी.', 'dz': 'ཨེམ་ཨེམ་', 'el': 'χιλιοστά|mm', 'fa': 'م.م.', 'he': 'מ"מ|מ״מ', 'hi': 'मिमी', 'ja': 'ミリメートル|mm', 'kab': 'mmitr', 'ka': 'მმ', 'kk': 'мм', 'km': 'ម.ម.', 'kn': 'ಮಿ.ಮಿ', 'kok': 'मिमि', 'ks': 'ملی میٹر', 'mai': 'मिमी', 'mk': 'мм', 'ml': 'മിമി', 'mni': 'মি.মি.', 'mn': 'мм', 'my': 'မီလီမီတာ', 'ne': 'मिलिमिटर', 'nr': 'i-mm', 'or': 'ମିଲିମିଟର', 'ru': 'мм', 'sq': '0 mm', 'ta': 'மி.மீ', 'tg': 'мм', 'th': 'มม.', 'tt': 'мм', 'ug': 'مىللىمېتىر', 'uk': 'мм', 'zh_CN': '毫米|mm', 'zh_TW': '公釐|mm'},
'CM':{'en_US': 'cm', 'am': 'ሴ/ሚ', 'ar': 'سم', 'as': 'ছে.মি.', 'be': 'см', 'bn_IN': 'সেমি', 'bn': 'সেমি', 'bo': 'ལིའི་སྨི།', 'ckb': 'سم', 'dgo': 'सैं.मी.', 'dz': 'སི་ཨེམ', 'el': 'εκατοστά|cm', 'fa': 'س.م.', 'fy': 'sm', 'he': 'ס"מ|ס״מ', 'hi': 'सेमी', 'is': 'sm', 'ja': 'センチ|センチメートル|cm', 'ka': 'სმ', 'kk': 'см', 'km': 'ស.ម.', 'kn': 'ಸೆಂ.ಮಿ', 'kok': 'सेंमी', 'ks': 'سینٹی میٹر', 'mai': 'सेमी', 'mk': 'см', 'ml': 'സിമി', 'mni': 'সে.মি.', 'mn': 'см', 'my': 'စင်တီမီတာ', 'ne': 'सेन्टिमिटर', 'nr': 'i-cm', 'om': 'sm', 'or': 'ସେଣ୍ଟିମିଟର', 'ru': 'см', 'st': 'sm', 'sw_TZ': 'sm', 'ta': 'செ.மீ', 'tg': 'см', 'th': 'ซม.', 'tt': 'см', 'ug': 'سانتىمېتىر', 'uk': 'см', 'uz': 'sm', 'zh_CN': '厘米|cm', 'zh_TW': '公分|cm'},
'PT':{'en_US': 'pt', 'am': 'ነጥብ', 'ar': 'نقطة', 'be': 'пт', 'bn_IN': 'পয়েন্ট', 'bn': 'পয়েন্ট', 'dz': 'པི་ཊི།', 'el': 'στιγμή|pt', 'fa': 'نقطه', 'he': 'נק|נקודה', 'hi': 'पॉइंट', 'hr': 'tč', 'ja': 'ポイント|pt', 'kab': 'taneqqiṭ', 'ka': 'პტ', 'kk': 'пт', 'kok': 'पॉ', 'ks': 'پی ٹی', 'lt': 'tšk', 'mk': 'точки', 'mn': 'цэг', 'my': 'ပွိုင့်', 'nr': 'i-pt', 'or': 'ପିଟି', 'ru': 'пт', 'sl': 'tč', 'tg': 'пт', 'th': 'พอยต์', 'tr': 'nk', 'tt': 'пт', 'zh_CN': '点|磅|pt', 'zh_TW': '點|pt'},
'INCH':{'en_US': 'in|"', 'af': 'dm|"', 'am': 'ኢንች|"', 'ar': 'في|"', 'be': 'цаль|"', 'br': 'meutad|"', 'el': 'ίντσα|in|"', 'eo': 'colo|"', 'es': 'in|pulg|"', 'et': 'tolli|"|″', 'fi': 'tuuma', 'fy': 'tomme|"', 'gd': 'òirlich|"', 'gl': 'pol|"', 'gug': 'in|pulg|"', 'he': "אינץ׳|אינץ'|אינטש", 'hr': 'in|″', 'ja': 'インチ|in|"', 'kab': 'di|"', 'kk': 'дюйм|"', 'lt': 'col|"', 'lv': 'colla|"', 'mn': 'дотор|"', 'nb': 'tommer|"', 'nn': 'tomme|in|"', 'or': 'ଇଞ୍ଚ|"', 'pt_BR': 'pol|"', 'ru': 'дюйм|"', 'sl': 'pal|"', 'sq': 'në|"', 'tr': 'inç|"', 'uk': 'дюйм|"', 'zh_CN': '英寸|in', 'zh_TW': '英吋|in'},
'INVISIBLE':{'en_US': 'invisible', 'af': 'onsigbaar', 'am': 'የማይታይ', 'ar': 'مخفي', 'as': 'অদৃশ্য', 'be': 'нябачны', 'bn_IN': 'অদৃশ্য', 'br': 'diwelus', 'bs': 'nevidljivo', 'ckb': 'نەبینراو', 'cy': 'anweledig', 'cs': 'neviditelná', 'de': 'ohne', 'dsb': 'njewidobny', 'el': 'αόρατο|invisible', 'eo': 'nevidebla', 'et': 'nähtamatu', 'eu': 'Ikusezina', 'fi': 'näkymätön', 'fy': 'ûnsichtber', 'gd': 'do-fhaicsinneach', 'gl': 'invisíbel', 'gug': 'nojekuaái', 'gu': 'અદ્ધશ્ય', 'he': 'בלתי נראה', 'hi': 'अदृश्य', 'hr': 'nevidljiv', 'hsb': 'njewidźomny', 'hu': 'láthatatlan', 'is': 'ósýnilegt', 'ja': '見えない|不可視|invisible', 'kab': 'uffir', 'ka': 'უხილავი', 'kk': 'жасырын', 'km': 'មើល\u200bមិន\u200bឃើញ', 'kn': 'ಅದೃಶ್ಯ', 'ko': '숨김', 'lo': 'ບໍ່ເຫັນ', 'lt': 'nematoma', 'lv': 'neredzams', 'ml': 'അദൃശ്യമായ', 'mn': 'гүйгээр', 'mr': 'अदृश्य', 'my': 'မမြင်နိုင်သော', 'nb': 'usynlig|invisible', 'ne': 'अदृश्य', 'nl': 'onzichtbaar', 'nn': 'usynleg|invisible', 'or': 'ଅଦୃଶ୍ଯ', 'pa_IN': 'ਅਦਿੱਖ', 'pt_BR': 'invisível', 'ro': 'invisible|invizibil', 'ru': 'невидимый', 'sid': 'leellannokkiha', 'si': 'අදිසි', 'sk': 'Neviditeľná', 'sl': 'nevidno', 'sq': 'i padukshëm', 'ta': 'தென்படாத', 'te': 'అగోచరమైన', 'tr': 'görünmez', 'uk': 'невидимий', 'vec': 'invizìbiłe', 'vi': 'Vô hình', 'zh_CN': '看不见|不可见|invisible', 'zh_TW': '看不見|隱形|invisible'},
'BLACK':{'en_US': 'black', 'af': 'swart', 'am': 'ጥቁር', 'ar': 'أسود', 'as': 'কলা', 'ast': 'prietu', 'be': 'чорны', 'bn_IN': 'কালো', 'bn': 'কালো', 'br': 'Du', 'bs': 'crna', 'ca': 'negre', 'ca_valencia': 'negre', 'ckb': 'ڕەش', 'cy': 'du', 'cs': 'černé', 'de': 'schwarz', 'dsb': 'carny', 'el': 'μαύρο|black', 'eo': 'nigra', 'es': 'negro', 'et': 'must', 'eu': 'beltza', 'fa': 'سیاه', 'fi': 'musta', 'fr': 'noir', 'fy': 'swart', 'gd': 'dubh', 'gl': 'negro', 'gug': 'hũ', 'gu': 'કાળો', 'he': 'שחור', 'hi': 'काला', 'hr': 'crna', 'hsb': 'čorny', 'hu': 'fekete', 'is': 'svart', 'ja': '黒|black', 'kab': 'amerkan', 'ka': 'შავი', 'kk': 'қара', 'km': 'ខ្មៅ\u200b', 'kmr_Latn': 'reş', 'kn': 'ಕಪ್ಪು', 'ko': '검정', 'lb': 'schwaarz', 'lo': 'ສີດຳ', 'lt': 'juoda', 'lv': 'melns', 'ml': 'കറുത്ത', 'mni': 'অমুবা', 'mn': 'хар', 'mr': 'काळा', 'my': 'အနက်', 'nb': 'svart|black', 'ne': 'कालो', 'nl': 'zwart', 'nn': 'svart|black', 'nr': 'nzima', 'nso': 'ntsho', 'oc': 'negre', 'or': 'କଳା', 'pa_IN': 'ਕਾਲਾ', 'pt_BR': 'preto', 'ro': 'black|negru', 'ru': 'чёрный', 'sa_IN': 'करूहुन', 'sat': 'हेंदे', 'sd': 'ڪارو', 'sid': 'kolishsho', 'si': 'කළු', 'sk': 'čierna', 'sl': 'črna', 'sq': 'e zezë', 'sr_Latn': 'crna', 'sr': 'црна', 'ss': 'mnyama', 'st': 'botsho', 'ta': 'கருப்பு', 'te': 'నలుపు', 'tn': 'bontsho', 'tr': 'siyah', 'ts': 'ntima', 'tt': 'кара', 'ug': 'قارا', 'uk': 'чорний', 've': 'ntswu', 'vi': 'đen', 'xh': 'mnyama', 'zh_CN': '黑|黑色|black', 'zh_TW': '黑|black', 'zu': 'okumnyama'},
'SILVER':{'en_US': 'silver', 'af': 'silwer', 'am': 'ብር', 'ar': 'فضي', 'as': 'ৰূপ', 'ast': 'plata', 'be': 'срэбны', 'bn_IN': 'রূপালী', 'br': 'argant', 'bs': 'srebrena', 'ca': 'plata|argent', 'ca_valencia': 'plata|argent', 'ckb': 'زیوی', 'cy': 'arian', 'cs': 'stříbrná', 'de': 'silber', 'dsb': 'slobro', 'el': 'ασημί|silver', 'eo': 'arĝenta', 'es': 'plata|plateado', 'et': 'hõbedane', 'eu': 'zilarra', 'fi': 'hopea', 'fr': 'argent', 'gd': 'airgid', 'gl': 'prata', 'gug': 'plata', 'gu': 'ચાંદી', 'he': 'כסף', 'hr': 'srebrno', 'hsb': 'slěbro', 'hu': 'világosszürke|ezüst', 'is': 'silfur', 'ja': '銀|silver', 'kab': 'aẓref', 'kk': 'күміс', 'km': 'ប្រាក់', 'kn': 'ಬೆಳ್ಳಿ', 'ko': '은색', 'lo': 'ສີນ້ຳເງິນ', 'lt': 'sidabrinė', 'lv': 'sudraba', 'mn': 'мөнгөлөг', 'mr': 'चंदेरी', 'nb': 'sølv|silver', 'nl': 'zilver', 'nn': 'sølv|silver', 'or': 'ସିଲଭର', 'pt_BR': 'prata', 'ro': 'silver|argintiu', 'ru': 'серебряный', 'sid': 'siwiila', 'sk': 'strieborná', 'sl': 'srebrna', 'sq': 'e argjendtë', 'sr_Latn': 'srebrna', 'sr': 'сребрна', 'ta': 'சில்வர்', 'te': 'సిల్వర్', 'tr': 'gümüş', 'uk': 'срібний', 'zh_CN': '银|银色|silver', 'zh_TW': '銀灰|銀|silver'},
'GRAY':{'en_US': 'gray|grey', 'af': 'grys', 'am': 'ግራጫ|ግራጫ', 'ar': 'رمادي|رصاصي', 'ast': 'buxu', 'be': 'шэры', 'br': 'loued|grey', 'bs': 'siva|siva', 'ca': 'gris', 'ca_valencia': 'gris', 'ckb': 'خۆڵەمێشی', 'cs': 'šedá', 'de': 'grau', 'dsb': 'šery', 'el': 'γκρίζο|gray|grey', 'eo': 'griza', 'es': 'gris', 'et': 'hall', 'eu': 'grisa', 'fi': 'harmaa', 'fr': 'gris|gris', 'fy': 'griis', 'gl': 'gris', 'gug': 'hũndy', 'he': 'אפור', 'hr': 'sivo|sivo', 'hsb': 'šěry', 'hu': 'szürke', 'is': 'grátt', 'ja': '灰色|gray', 'kab': 'amliɣdi|amliɣdi', 'kk': 'сұр', 'km': 'ប្រផះ|grey', 'kn': 'ಬೂದು|ಬೂದು', 'ko': '회색|회색', 'lo': 'gray|ສີເທົາ', 'lt': 'pilka', 'lv': 'pelēks', 'mn': 'саарал', 'mr': 'ग्रे|ग्रे', 'nb': 'grå|gray', 'nl': 'grijs', 'nn': 'grå|gray', 'oc': 'gris|gris', 'or': 'ଧୂସର|grey', 'pt_BR': 'cinza', 'ro': 'gray|grey|gri', 'ru': 'серый', 'sid': 'boora|bulla', 'sk': 'sivá', 'sl': 'siva', 'sq': 'gri|gri', 'sr_Latn': 'siva', 'sr': 'сива', 'tr': 'gri|gri', 'uk': 'сірий', 'vec': 'grizo|grijo', 'zh_CN': '灰|灰色|gray|grey', 'zh_TW': '灰|gray|grey'},
'WHITE':{'en_US': 'white', 'af': 'wit', 'am': 'ነጭ', 'ar': 'أبيض', 'as': 'বগা', 'ast': 'blancu', 'be': 'белы', 'bn_IN': 'সাদা', 'br': 'gwenn', 'bs': 'bijela', 'ca': 'blanc', 'ca_valencia': 'blanc', 'ckb': 'سپی', 'cy': 'gwyn', 'cs': 'bílá', 'de': 'weiß', 'dsb': 'běły', 'el': 'λευκό|white', 'eo': 'blanka', 'es': 'blanco', 'et': 'valge', 'eu': 'zuria', 'fi': 'valkoinen', 'fr': 'blanc', 'fy': 'wyt', 'gd': 'geal', 'gl': 'branco', 'gug': 'morotĩ', 'gu': 'સફેદ', 'he': 'לבן', 'hi': 'सफ़ेद', 'hr': 'bijela', 'hsb': 'běły', 'hu': 'fehér', 'is': 'hvítt', 'ja': '白|white', 'kab': 'amellal', 'ka': 'თეთრი', 'kk': 'ақ', 'km': 'ស', 'kn': 'ಬಿಳಿ', 'ko': '흰색', 'lo': 'ສີຂາວ', 'lt': 'balta', 'lv': 'balts', 'ml': 'വെള്ള', 'mn': 'цагаан', 'mr': 'पांढरा', 'nb': 'hvit|white', 'ne': 'सेतो', 'nl': 'wit', 'nn': 'kvit|white', 'oc': 'blanc', 'or': 'ଧଳା', 'pa_IN': 'ਚਿੱਟਾ', 'pt_BR': 'branco', 'ro': 'white|alb', 'ru': 'белый', 'sa_IN': 'सफ़ीद', 'sid': 'waajjo', 'si': 'සුදු', 'sk': 'Biela', 'sl': 'bela', 'sq': 'e bardhë', 'sr_Latn': 'bela', 'sr': 'бела', 'ta': 'வெள்ளை', 'te': 'తెలుపు', 'tr': 'beyaz', 'uk': 'білий', 'zh_CN': '白|白色|white', 'zh_TW': '白|white'},
'MAROON':{'en_US': 'maroon', 'am': 'የሸክላ ቀለም', 'ar': 'كستنائي', 'as': 'কৃষ্ণৰক্তবৰ্ণ', 'ast': 'marrón', 'be': 'бардовы', 'bn_IN': 'মেরুন', 'br': 'gell', 'bs': 'kestenjasta', 'ca': 'granat|grana', 'ca_valencia': 'granat|grana', 'ckb': 'مارۆنیی', 'cy': 'marŵn', 'cs': 'kaštanová', 'de': 'rotbraun', 'dsb': 'cerwjenobruny', 'el': 'καστανέρυθρο|maroon', 'eo': 'karmezina', 'es': 'guinda|granate', 'et': 'kastanpruun', 'eu': 'granatea', 'fi': 'punaruskea', 'fr': 'marron', 'fy': 'kastanjebrûn', 'gd': 'ciar-dhonn', 'gl': 'granate', 'gug': 'marrón', 'gu': 'મરૂન', 'he': 'חוםכהה', 'hi': 'मरून', 'hr': 'kestenjasta', 'hsb': 'čerwjenobruny', 'hu': 'sötétbarna', 'is': 'ljósbrúnt', 'ja': 'くり色|マルーン|maroon', 'kab': 'aqahwi', 'kk': 'қызыл-қоңыр', 'km': 'ត្នោត\u200bចាស់', 'kn': 'ಕಂದುಗೆಂಪು', 'ko': '적갈색', 'lo': 'ສີນ້ຳຕານແດງ', 'lt': 'kaštoninė', 'lv': 'tumšsarkans', 'ml': 'മറൂണ്\u200d', 'mn': 'улаанбор', 'mr': 'मरून', 'nb': 'rødbrun|maroon', 'nl': 'kastanjebruin', 'nn': 'raudbrun|maroon', 'or': 'ଖଇରିଆ', 'pt_BR': 'castanho', 'ro': 'maroon|maro', 'ru': 'бордовый', 'sid': 'maarone', 'sk': 'gaštanová', 'sl': 'kostanjeva', 'sq': 'gështenjë', 'sr_Latn': 'kestenasta', 'sr': 'кестенаста', 'ta': 'மரூன்', 'te': 'మెరూన్', 'tr': 'bordo', 'uk': 'каштановий', 'zh_CN': '咖啡|黑褐|红棕|栗色|maroon', 'zh_TW': '咖啡|黑褐|紅棕|maroon'},
'RED':{'en_US': 'red', 'af': 'rooi', 'am': 'ቀይ', 'ar': 'أحمر', 'as': 'ৰঙা', 'ast': 'bermeyu', 'be': 'чырвоны', 'bn_IN': 'লাল', 'br': 'ruz', 'bs': 'crvena', 'ca': 'vermell|roig', 'ca_valencia': 'roig', 'ckb': 'سور', 'cy': 'coch', 'cs': 'červená', 'de': 'rot', 'dgo': 'सूहा', 'dsb': 'cerwjeny', 'el': 'κόκκινο|red', 'eo': 'ruĝa', 'es': 'rojo', 'et': 'punane', 'eu': 'gorria', 'fi': 'punainen', 'fr': 'rouge', 'fy': 'read', 'gd': 'dearg', 'gl': 'vermello', 'gug': 'pytã', 'gu': 'લાલ', 'he': 'אדום', 'hi': 'लाल', 'hr': 'crvena', 'hsb': 'čerwjeny', 'hu': 'piros|vörös', 'is': 'rautt', 'ja': '赤|red', 'kab': 'azeggaɣ', 'kk': 'қызыл', 'km': 'ក្រហម', 'kn': 'ಕೆಂಪು', 'kok': 'तांबडोTambddo', 'ko': '빨간색', 'lo': 'ສີແດງ', 'lt': 'raudona', 'lv': 'sarkans', 'ml': 'ചുവപ്പ്', 'mni': 'অঙাংবা', 'mn': 'улаан', 'mr': 'लाल', 'nb': 'rød|red', 'nl': 'rood', 'nn': 'raud|red', 'oc': 'roge', 'or': 'ଲାଲି', 'pt_BR': 'vermelho', 'ro': 'red|roșu', 'ru': 'красный', 'sa_IN': 'वुज़ुल', 'sat': 'आराक्', 'sd': 'ڳاڙهو', 'sid': 'duumo', 'sk': 'červená', 'sl': 'rdeča', 'sq': 'e kuqe', 'sr_Latn': 'crvena', 'sr': 'црвена', 'ta': 'சிவப்பு', 'te': 'ఎరుపు', 'th': 'แดง', 'tr': 'kırmızı', 'uk': 'червоний', 'zh_CN': '红|红色|red', 'zh_TW': '紅|red'},
'PURPLE':{'en_US': 'purple', 'af': 'pers', 'am': 'ወይን ጠጅ', 'ar': 'بنفسجي', 'as': 'জামুকলীয়া', 'ast': 'púrpura', 'be': 'пурпурны', 'bn_IN': 'গোলাপী', 'br': 'limestra', 'bs': 'ljubičasta', 'ca': 'porpra|púrpura', 'ca_valencia': 'porpra|púrpura', 'ckb': 'مۆر', 'cy': 'porffor', 'cs': 'purpurová', 'de': 'lila', 'dgo': 'जामुनी', 'dsb': 'lylowy', 'el': 'πορφυρό|purple', 'eo': 'purpura', 'es': 'púrpura|morado', 'et': 'lilla', 'eu': 'morea', 'fi': 'purppura', 'fr': 'pourpre', 'fy': 'pears', 'gd': 'purpaidh', 'gl': 'púrpura', 'gug': 'lila', 'gu': 'જાંબુડિયો', 'he': 'סגול', 'hi': 'बैंगनी', 'hr': 'ljubičasta', 'hsb': 'purpurny', 'hu': 'lila', 'is': 'purpurablátt', 'ja': '紫|purple', 'kab': 'agadaw', 'kk': 'күлгін', 'km': 'ស្វាយ', 'kn': 'ನೇರಳೆ', 'kok': 'जांबळोZamblli', 'ko': '자주색', 'lo': 'ສີມ່ວງ', 'lt': 'violetinė', 'lv': 'purpura', 'ml': 'പര്\u200dപ്പിള്\u200d', 'mn': 'нил ягаан', 'mr': 'जांभळा', 'nb': 'lilla|purple', 'nl': 'lila', 'nn': 'lilla|purple', 'oc': 'porpra', 'or': 'ବାଇଗଣୀ', 'pa_IN': 'ਵੈਂਗਣੀ', 'pt_BR': 'roxo', 'ro': 'purple|violet', 'ru': 'фиолетовый', 'sa_IN': 'परपोल', 'sat': 'कुरसे बाहा रोङ गाड़माक्', 'sd': 'واڱڻائي', 'sid': 'Hamara', 'sk': 'Purpurová', 'sl': 'škrlatna', 'sq': 'vjollcë', 'sr_Latn': 'ljubičasta', 'sr': 'љубичаста', 'ta': 'ஊதா', 'te': 'వంకాయరంగు', 'tr': 'mor', 'uk': 'фіолетовий', 'vec': 'vioła', 'vi': 'Tía', 'zh_CN': '紫|紫色|purple', 'zh_TW': '紫|purple'},
'FUCHSIA':{'en_US': 'fuchsia|magenta', 'af': 'fuchsia', 'ar': 'فوشيا|أرجواني', 'ast': 'fucsia|maxenta', 'be': 'фуксія|пурпурны', 'br': 'fuchia|magenta', 'ca': 'fúcsia|magenta', 'ca_valencia': 'fúcsia|magenta', 'ckb': 'سوری ئەرخەوانی', 'cs': 'magenta', 'de': 'magenta', 'dsb': 'magenta', 'el': 'φούξια|ματζέντα|fuchsia|magenta', 'eo': 'fuksina', 'es': 'fucsia|magenta', 'et': 'magenta|fuksiapunane', 'eu': 'magenta', 'fi': 'fuksia', 'gl': 'fucsia|maxenta', 'gug': 'fucsia|magenta', 'he': "פוקסיה|מג׳נטה|מג'נטה", 'hr': 'fuksija|magneta', 'hsb': 'magenta', 'hu': 'bíbor|ciklámen', 'is': 'blárauður', 'ja': '明るい紫|フクシア|マゼンタ|fuchsia', 'kk': 'қарақошқыл', 'km': 'ស្វាយ\u200bខ្ចី|ស្វាយខ្ចី', 'kn': 'ನೇರಳೆಗೆಂಪು|ಕಡುಗೆಂಪು', 'ko': 'fuchsia|마젠타', 'lo': 'fuchsia|ສີແດງມ່ວງ', 'lt': 'purpurinė', 'lv': 'fuksiju|koši_rozā', 'mn': 'фухсиа|магента', 'mr': 'फुशिआ|मजेंटा', 'nb': 'fuksia|magentarød|magenta', 'nn': 'fuksia|magentaraud|magenta', 'oc': 'fúcsia|magenta', 'pt_BR': 'magenta', 'ru': 'пурпурный', 'sid': 'daama|addama', 'sk': 'purpurová', 'sl': 'fuksija|magentna', 'sq': 'e purpurtë|e purpurtë', 'sr_Latn': 'purpurna', 'sr': 'пурпурна', 'tr': 'eflatun|mor', 'uk': 'пурпуровий', 'vec': 'fucsia|magenta', 'zh_CN': '紫红|紫红色|洋红|洋红色|fuchsia|magenta', 'zh_TW': '洋紅|紅紫|fuchsia|magenta'},
'GREEN':{'en_US': 'green', 'af': 'groen', 'am': 'አረንጓዴ', 'ar': 'أخضر', 'as': 'সেউজীয়া', 'ast': 'verde', 'be': 'зялёны', 'bn_IN': 'সবুজ', 'br': 'gwer', 'bs': 'zelena', 'ca': 'verd', 'ca_valencia': 'verd', 'ckb': 'سەوز', 'cs': 'zelená', 'de': 'grün', 'dsb': 'zeleny', 'el': 'πράσινο|green', 'eo': 'verda', 'es': 'verde', 'et': 'roheline', 'eu': 'berdea', 'fi': 'vihreä', 'fr': 'vert', 'fy': 'grien', 'gd': 'uaine', 'gl': 'verde', 'gug': 'aky', 'gu': 'લીલો', 'he': 'ירוק', 'hi': 'हरा', 'hr': 'zelena', 'hsb': 'zeleny', 'hu': 'zöld', 'is': 'grænt', 'ja': '緑|green', 'kab': 'azegzaw', 'ka': 'მწვანე', 'kk': 'жасыл', 'km': 'បៃតង', 'kn': 'ಹಸಿರು', 'ko': '녹색', 'lo': 'ສີຂຽວ', 'lt': 'žalia', 'lv': 'zaļš', 'ml': 'പച്ച', 'mni': 'অশংবা', 'mn': 'ногоон', 'mr': 'हिरवा', 'my': 'အစိမ်းရောင်', 'nb': 'grønn|green', 'ne': 'हरियो', 'nl': 'groen', 'nn': 'grøn|green', 'oc': 'verd', 'or': 'ସବୁଜ', 'pa_IN': 'ਹਰਾ', 'pt_BR': 'verde', 'ro': 'green|verde', 'ru': 'зелёный', 'sd': 'سائو', 'sid': 'haanja', 'si': 'කොළ', 'sk': 'zelená', 'sl': 'zelena', 'sq': 'jeshile', 'sr_Latn': 'zelena', 'sr': 'зелена', 'ta': 'பச்சை', 'te': 'ఆకుపచ్చ', 'th': 'เขียว', 'tr': 'yeşil', 'ug': 'يېشىل', 'uk': 'зелений', 'vi': 'Lục', 'zh_CN': '绿|绿色|green', 'zh_TW': '綠|green'},
'LIME':{'en_US': 'lime', 'af': 'lemmetjie', 'am': 'ሎሚ', 'ar': 'ليموني', 'as': 'নেমু', 'ast': 'llima', 'be': 'ярка-зялёны', 'bn_IN': 'সময়', 'br': 'sitroñs', 'ca': 'llima|verd.llima', 'ca_valencia': 'llima|verd.llima', 'cy': 'leim', 'cs': 'žlutozelená', 'de': 'hellgrün', 'dsb': 'swětłozeleny', 'el': 'ανοιχτοπράσινο|lime', 'eo': 'limeta', 'es': 'lima', 'et': 'laimiroheline|laimikarva', 'eu': 'lima', 'fi': 'limetti', 'fr': 'citron', 'fy': 'limoen', 'gd': 'dath na liomaideig', 'gl': 'lima', 'gug': 'lima', 'gu': 'લીંબુ', 'he': 'ליים', 'hi': 'समय', 'hr': 'limun-žuta', 'hsb': 'swětłozeleny', 'hu': 'világoszöld', 'is': 'límónugrænt', 'ja': '明るい緑|ライム色|lime', 'kab': 'aqares', 'ka': 'დრო', 'kk': 'ашық жасыл', 'km': 'បៃតង', 'kn': 'ಸಮಯ', 'ko': '라임', 'lo': 'ສີເຫຼືອງປົນຂຽວ', 'lt': 'citrininė', 'lv': 'laima', 'ml': 'നാരങ്ങ', 'mn': 'цайвар ногоон', 'mr': 'वेळ', 'my': 'အချိန်', 'nb': 'grasgrønn|lime', 'ne': 'समय', 'nl': 'limoen', 'nn': 'grasgrøn|lime', 'oc': 'limon', 'or': 'ଲେମ୍ବୁ ରଙ୍ଗ', 'pa_IN': 'ਸਮਾਂ', 'pt_BR': 'lima', 'ru': 'лимонный', 'sid': 'boloticho', 'si': 'වෙලාව', 'sk': 'limetka', 'sl': 'limetna', 'sq': 'limon', 'sr_Latn': 'svetlo zelena', 'sr': 'светло зелена', 'ta': 'எலுமிச்சை', 'te': 'నిమ్మరంగు', 'tr': 'sarımsı yeşil', 'uk': 'лайм', 'vi': 'Giờ', 'zh_CN': '酸橙色|lime', 'zh_TW': '萊姆綠|亮綠|lime'},
'OLIVE':{'en_US': 'olive', 'af': 'olyfgroen', 'am': 'ወይራ', 'ar': 'زيتوني', 'as': 'জলফাই', 'ast': 'oliva', 'be': 'аліўкавы', 'bn_IN': 'জলপাই রং', 'br': 'olivez', 'bs': 'maslinasta', 'ca': 'oliva|verd.oliva', 'ca_valencia': 'oliva|verd.oliva', 'ckb': 'زەیتوونی', 'cy': 'olewydden', 'cs': 'olivová', 'de': 'dunkelgrün', 'dsb': 'oliwnozeleny', 'el': 'λαδί|olive', 'eo': 'oliva', 'es': 'oliva', 'et': 'kollakasroheline|oliivroheline|oliivikarva', 'eu': 'oliba', 'fi': 'oliivi', 'fy': 'oliifgrien', 'gd': 'donn-uaine', 'gl': 'oliva', 'gug': 'oliva', 'gu': 'ઓલિવ', 'he': 'ירוקזית', 'hi': 'जैतून', 'hr': 'maslinasta', 'hsb': 'oliwozeleny', 'hu': 'olajzöld', 'is': 'ólífugrænt', 'ja': '柿色|オリーブ色|olive', 'kab': 'azemmur', 'kk': 'зәйтүн', 'km': 'អូលីវ', 'kn': 'ಆಲಿವ್', 'ko': '올리브', 'lo': 'ສີຂຽວເຂັ້ມປົນສີເຫຼືອງ', 'lt': 'alyvuogių', 'lv': 'olīvu', 'ml': 'ഒലീവ്', 'mn': 'хар ногоон', 'mr': 'ऑलिव्ह', 'nb': 'olivengrønn|olive', 'nl': 'olijfgroen', 'nn': 'olivengrøn|olive', 'oc': 'oliva', 'or': 'ଓଲିଭ', 'pt_BR': 'oliva', 'ru': 'оливковый', 'sid': 'ejersa', 'sk': 'olivová', 'sl': 'olivnozelena', 'sq': 'ulli', 'sr_Latn': 'maslinasta', 'sr': 'маслинаста', 'ta': 'ஆலிவ்', 'te': 'ఆలివ్', 'tr': 'zeytin yeşili', 'uk': 'оливковий', 'vec': 'ołiva', 'zh_CN': '橄榄绿|黄绿|olive', 'zh_TW': '橄欖綠|黃綠|olive'},
'YELLOW':{'en_US': 'yellow', 'af': 'geel', 'am': 'ቢጫ', 'ar': 'أصفر', 'as': 'হালধীয়া', 'ast': 'mariellu', 'be': 'жоўты', 'bn_IN': 'হলুদ', 'br': 'melen', 'bs': 'žuta', 'ca': 'groc', 'ca_valencia': 'groc', 'ckb': 'زەرد', 'cy': 'melyn', 'cs': 'žlutá', 'de': 'gelb', 'dsb': 'žołty', 'el': 'κίτρινο|yellow', 'eo': 'flava', 'es': 'amarillo', 'et': 'kollane', 'eu': 'horia', 'fi': 'keltainen', 'fr': 'jaune', 'fy': 'giel', 'gd': 'buidhe', 'gl': 'amarelo', 'gug': "sa'yju", 'gu': 'પીળો', 'he': 'צהוב', 'hi': 'पीला', 'hr': 'žuta', 'hsb': 'žołty', 'hu': 'sárga', 'is': 'gult', 'ja': '黄|yellow', 'kab': 'awraɣ', 'ka': 'ყვითელი', 'kk': 'сары', 'km': 'លឿង', 'kn': 'ಹಳದಿ', 'ko': '노랑', 'lo': 'ສີເຫຼືອງ', 'lt': 'geltona', 'lv': 'dzeltens', 'ml': 'മഞ്ഞ', 'mn': 'шар', 'mr': 'पिवळा', 'my': 'အဝါ', 'nb': 'gul|yellow', 'ne': 'पहेलो', 'nl': 'geel', 'nn': 'gul|yellow', 'oc': 'jaune', 'or': 'ହଳଦିଆ', 'pa_IN': 'ਪੀਲਾ', 'pt_BR': 'amarelo', 'ro': 'yellow|galben', 'ru': 'жёлтый', 'sd': 'پيلو', 'sid': 'baqqala', 'si': 'කහ', 'sk': 'žltá', 'sl': 'rumena', 'sq': 'e verdhë', 'sr_Latn': 'žuta', 'sr': 'жута', 'ta': 'மஞ்சள்', 'te': 'పసుపు', 'th': 'เหลือง', 'tr': 'sarı', 'ug': 'سېرىق', 'uk': 'жовтий', 'vec': 'zało', 'vi': 'Vàng', 'zh_CN': '黄|黄色|yellow', 'zh_TW': '黃|yellow'},
'NAVY':{'en_US': 'navy', 'af': 'vlootblou', 'am': 'የባህር ኃይል', 'ar': 'أزرق_بحري', 'as': 'ইষৎনীলা', 'ast': 'azulmarín|marín', 'be': 'цёмна-сіні', 'bn_IN': 'অাকাশি', 'br': 'glaz mor', 'bs': 'mornarska', 'ca': 'blau.marí|marí', 'ca_valencia': 'blau.marí|marí', 'cy': 'glas y llynges', 'cs': 'tmavomodrá', 'de': 'dunkelblau', 'dsb': 'śamnomódry', 'el': 'θαλασσί|navy', 'eo': 'malhelblua', 'es': 'azul.marino|marino', 'et': 'meresinine', 'eu': 'itsasurdina', 'fi': 'laivasto', 'fr': 'marine', 'fy': 'navyblau', 'gd': "gorm a' chabhlaich", 'gl': 'mariño', 'gug': 'hovy.marino|marino', 'gu': 'નેવી', 'he': 'כחולכהה', 'hi': 'नेवी', 'hr': 'tamnoplava', 'hsb': 'ćmowomódry', 'hu': 'sötétkék', 'is': 'flotablátt', 'ja': '濃い青|ネイビー|navy', 'kk': 'қою_көк', 'km': 'ខៀវ\u200bចាស់', 'kn': 'ಗಾಢಬೂದು ನೀಲಿ', 'ko': '군청색', 'lo': 'ສີຟ້າເຂັ້ມ', 'lt': 'jūros', 'lv': 'tumšzils', 'ml': 'നേവി', 'mn': 'хар хөх', 'mr': 'नेव्हि', 'nb': 'marineblå|navy', 'nl': 'marineblauw', 'nn': 'marineblå|navy', 'oc': 'blaumarina', 'or': 'ଗାଢ଼ ନୀଳ', 'pt_BR': 'marinho', 'ru': 'тёмно-синий', 'sid': 'baaruwolqa', 'sk': 'tmavomodrá', 'sl': 'mornarskomodra', 'sq': 'ngjyrë kaltër e errët', 'sr_Latn': 'mornarsko plava', 'sr': 'морнарско плава', 'ta': 'நேவி', 'te': 'నావి', 'tr': 'lacivert', 'uk': 'темно-синій', 'vec': 'marina', 'zh_CN': '海蓝|深蓝|navy', 'zh_TW': '海藍|靛|深藍|navy'},
'BLUE':{'en_US': 'blue', 'af': 'blou', 'am': 'ሰማያዊ', 'ar': 'أزرق', 'as': 'নীলা', 'ast': 'azul', 'be': 'сіні', 'bn_IN': 'নীল', 'br': 'glas', 'bs': 'plava', 'ca': 'blau', 'ca_valencia': 'blau', 'ckb': 'شین', 'cy': 'glas', 'cs': 'modrá', 'de': 'blau', 'dsb': 'módry', 'el': 'γαλάζιο|blue', 'eo': 'blua', 'es': 'azul', 'et': 'sinine', 'eu': 'urdina', 'fi': 'sininen', 'fr': 'bleu', 'fy': 'blau', 'gd': 'gorm', 'gl': 'azul', 'gug': 'hovy', 'gu': 'વાદળી', 'he': 'כחול', 'hi': 'नीला', 'hr': 'plava', 'hsb': 'módry', 'hu': 'kék', 'is': 'blátt', 'ja': '青|blue', 'kab': 'amidadi', 'ka': 'ლურჯი', 'kk': 'көк', 'km': 'ខៀវ', 'kn': 'ನೀಲಿ', 'ko': '청색', 'lo': 'ສີຟ້າ', 'lt': 'mėlyna', 'lv': 'zils', 'ml': 'നീല', 'mni': 'হীগোক', 'mn': 'хөх', 'mr': 'निळा', 'my': 'အပြာရောင်', 'nb': 'blå|blue', 'ne': 'नीलो', 'nl': 'blauw', 'nn': 'blå|blue', 'oc': 'blau', 'or': 'ନୀଳ', 'pa_IN': 'ਨੀਲਾ', 'pt_BR': 'azul', 'ro': 'blue|albastru', 'ru': 'синий', 'sd': 'نيرو', 'sid': 'gordaamo', 'si': 'නිල්', 'sk': 'modrá', 'sl': 'modra', 'sq': 'blu', 'sr_Latn': 'plava', 'sr': 'плава', 'ta': 'நீலம்', 'te': 'నీలం', 'th': 'น้ำเงิน', 'tr': 'mavi', 'ug': 'كۆك', 'uk': 'синій', 'vec': 'blè', 'vi': 'Xanh', 'zh_CN': '蓝|蓝色|blue', 'zh_TW': '藍|blue'},
'TEAL':{'en_US': 'teal', 'af': 'blougroen', 'am': 'አረንጓዴ ሰማያዊ', 'ar': 'أزرق_مخضر', 'as': 'টিল', 'ast': 'xade', 'be': 'бірузовы', 'bn_IN': 'টিল', 'br': 'houad', 'bs': 'grogotovac', 'ca': 'jade', 'ca_valencia': 'jade', 'cs': 'zelenomodrá', 'de': 'blaugrün', 'dsb': 'zelenomódry', 'el': 'γαλαζοπράσινο|teal', 'eo': 'bluverda', 'es': 'cerceta|verde.azulado', 'et': 'sinakasroheline', 'eu': 'urdin berdexka', 'fi': 'sinivihreä', 'fr': 'bleuclair', 'fy': 'grienblau', 'gd': 'dath na crann-lach', 'gl': 'verde azulado', 'gug': 'aky-hovyha', 'gu': 'બતક', 'he': 'צהבהב', 'hi': 'हरा-नीला', 'hr': 'tirkizna', 'hsb': 'módrozeleny', 'hu': 'kékeszöld', 'is': 'djúp-blágrænt', 'ja': 'マガモ色|くすんで暗い青|ティール|teal', 'kab': 'anili afaw', 'kk': 'жасыл_көк', 'km': 'ខៀវ\u200bបៃតង\u200bក្រមៅ', 'kn': 'ಗಾಢನೀಲಿಹಸಿರು', 'lo': 'ສີນ້ຳເງິນປົນຂຽວ', 'lt': 'tamsiai.žydra', 'lv': 'zilganzaļš', 'mn': 'хөх ногоон', 'mr': 'टिअल', 'nb': 'mørk grønnblå|teal', 'nl': 'Turquoise', 'nn': 'mørk grønblå|teal', 'oc': 'baluclar', 'or': 'କଳହଂସ', 'pt_BR': 'turquesa', 'ru': 'сине-зелёный', 'sid': 'shiima dakiyye', 'sk': 'tyrkysová', 'sl': 'modrozelena', 'sq': 'blu e lehtë', 'sr_Latn': 'til', 'sr': 'тил', 'ta': 'டீல்', 'te': 'టీల్', 'tr': 'deniz mavisi', 'uk': 'синьо-зелений', 'vec': 'verde mar', 'zh_CN': '蓝绿色|蓝绿|teal', 'zh_TW': '藍綠|teal'},
'AQUA':{'en_US': 'aqua|cyan', 'af': 'siaan', 'am': 'ዉሀ|አረንጓዴ', 'ar': 'سماوي|سيان', 'ast': 'agua|cian', 'be': 'блакітны', 'br': 'dour|cyan', 'bs': 'vodena|cyan', 'ca': 'cian', 'ca_valencia': 'cian', 'cs': 'azurová', 'de': 'türkis|cyan', 'dsb': 'akwamarin|cyan', 'el': 'ανοιχτόγαλάζιο|aqua|cyan', 'eo': 'cejanblua', 'es': 'agua|cian', 'et': 'rohekassinine|tsüaan', 'eu': 'ura|cyana', 'fi': 'syaani', 'fr': 'turquoise|cyan', 'fy': 'wetter|cyaan', 'gd': 'aqcua|saidhean', 'gl': 'auga|ciano', 'gug': 'y|cian', 'he': 'ים|ציאן|מים', 'hr': 'vodena|cijan', 'hsb': 'akwamarinowy|cyanowy', 'hu': 'ciánkék|cián', 'is': 'blágrænt', 'ja': 'アクア|シアン|aqua', 'kk': 'көгілдір', 'kn': 'ನೀಲಿಹಸಿರು|ಹಸಿರುನೀಲಿ', 'ko': '아쿠아|시안', 'lo': 'ສີນ້ຳທະເລ|ສີຟ້າປົນຂຽວ (Cyan)', 'lt': 'žydra', 'lv': 'gaišzils', 'mn': 'оюу|cyan', 'mr': 'ॲक्वा|सिअन', 'nb': 'cyanblå|cyan', 'nl': 'water|cyaan', 'nn': 'cyanblå|cyan', 'oc': 'aqua|cian', 'or': 'ପାଣି|cyan', 'pt_BR': 'ciano', 'ru': 'голубой', 'sid': 'aqua|cyaan', 'sk': 'azúrová', 'sl': 'vodenomodra|cijanska', 'sq': 'ujë|blu', 'sr_Latn': 'vodeno plava|cijan', 'sr': 'водено плава|цијан', 'th': 'สีน้ำทะเล|สีฟ้าอมเขียว (Cyan)', 'tr': 'gök mavisi', 'uk': 'блакитний', 'vec': 'acua|cyan', 'zh_CN': '青|青色|aqua|cyan', 'zh_TW': '青藍|青|水藍|aqua|cyan'},
'PINK':{'en_US': 'pink', 'af': 'roos', 'am': 'ሮዝ', 'ar': 'وردي', 'as': 'গোলাপী', 'ast': 'rosa', 'be': 'ружовы', 'bn_IN': 'লিংক', 'br': 'roz', 'bs': 'roza', 'ca': 'rosa', 'ca_valencia': 'rosa', 'ckb': 'پەمەیی', 'cy': 'pinc', 'cs': 'růžová', 'de': 'rosa', 'dsb': 'rožowy', 'el': 'ροζ|pink', 'eo': 'rozkolora', 'es': 'rosa', 'et': 'roosa', 'eu': 'arrosa', 'fi': 'pinkki', 'fr': 'rose', 'fy': 'rôs', 'gd': 'pinc', 'gl': 'rosa', 'gug': 'pytãngy', 'gu': 'ગુલાબી', 'he': 'ורוד', 'hi': 'कड़ी', 'hr': 'ružićasta', 'hsb': 'róžowy', 'hu': 'rózsaszín', 'is': 'bleikt', 'ja': 'ピンク|pink', 'kab': 'axuxi', 'ka': 'ბმული', 'kk': 'қызғылт', 'km': 'ផ្កាឈូក', 'kn': 'ಸಂಪರ್ಕಕೊಂಡಿ', 'ko': '분홍', 'lo': 'ສີບົວ', 'lt': 'rausva', 'lv': 'rozā', 'ml': 'പിങ്ക്', 'mn': 'ягаан', 'mr': 'पिंक', 'my': 'ကွင်းဆက်', 'nb': 'rosa|pink', 'ne': 'लिङ्क', 'nl': 'roze', 'nn': 'rosa|pink', 'oc': 'ròse', 'or': 'ଗୋଲାପି', 'pa_IN': 'ਲਿੰਕ', 'pt_BR': 'rosa', 'ro': 'pink|roz', 'ru': 'розовый', 'sid': 'dumamo', 'si': 'සබඳින්න', 'sk': 'ružový', 'sl': 'roza', 'sq': 'rozë', 'sr_Latn': 'roze', 'sr': 'розе', 'ta': 'இளஞ்சிவப்பு', 'te': 'పింక్', 'th': 'ชมพู', 'tr': 'pembe', 'uk': 'рожевий', 'vec': 'roza', 'vi': 'Liên kết', 'zh_CN': '粉色|粉|pink', 'zh_TW': '粉紅|pink'},
'TOMATO':{'en_US': 'tomato', 'af': 'tamatie', 'am': 'ቲማቲም', 'ar': 'طماطمي', 'as': 'টমেটো', 'ast': 'tomate', 'be': 'тамат', 'bn_IN': 'টোমাটো', 'br': 'tomatez', 'bs': 'paradajz', 'ca': 'tomàquet|tomata', 'ca_valencia': 'tomata|tomaca', 'ckb': 'تەماتەیی', 'cs': 'cihlová', 'de': 'dunkelrot', 'dsb': 'śamnocerwjeny', 'el': 'τοματί|tomato', 'eo': 'tomata', 'es': 'tomate|jitomate', 'et': 'tomatipunane|tomatikarva', 'eu': 'tomatea', 'fi': 'tomaatti', 'fr': 'tomate', 'fy': 'tomaat', 'gd': 'tomàto', 'gl': 'tomate', 'gug': 'tomate', 'gu': 'ટોમેટો', 'he': 'עגבניה', 'hi': 'टमाटर', 'hr': 'rajčica', 'hsb': 'ćmowočerwjeny', 'hu': 'világospiros', 'is': 'tómatur', 'ja': 'トマト|トマト色|tomate', 'kab': 'ṭumaṭic', 'kk': 'күңгірт_қызыл', 'km': 'ប៉េងប៉ោះ', 'kn': 'ಟೊಮ್ಯಾಟೊ', 'ko': '토마토', 'lo': 'ສີໝາກເຫຼັ່ນ', 'lt': 'pomidorų', 'lv': 'tomātu', 'ml': 'തക്കാളി', 'mn': 'гүн улаан', 'mr': 'टोमॅटो', 'nb': 'tomatrød|tomato', 'nl': 'tomaat', 'nn': 'tomatraud|tomato', 'or': 'ଟୋମାଟୋ', 'pt_BR': 'tomate', 'ru': 'тёмно-красный', 'sid': 'timaatime', 'sk': 'paradajková', 'sl': 'paradižnikova', 'sq': 'domate', 'sr_Latn': 'paradajz crvena', 'sr': 'парадајз црвена', 'ta': 'தக்காளி', 'te': 'టొమాటో', 'tr': 'koyu kırmızı', 'uk': 'томатний', 'vec': 'pomodoro', 'zh_CN': '番茄红|tomato', 'zh_TW': '蕃茄紅|茄紅|tomato'},
'ORANGE':{'en_US': 'orange', 'af': 'oranje', 'am': 'ብርቱካን', 'ar': 'برتقالي', 'as': 'সুমথীৰা', 'ast': 'naranxa', 'be': 'аранжавы', 'bn_IN': 'পরিসর', 'br': 'orañjez', 'bs': 'narandžasta', 'ca': 'taronja', 'ca_valencia': 'taronja', 'ckb': 'پرتەقاڵی', 'cy': 'oren', 'cs': 'oranžová', 'dsb': 'oranžowy', 'el': 'πορτοκαλί|orange', 'eo': 'oranĝa', 'es': 'naranja', 'et': 'oranž|apelsinikarva', 'eu': 'laranja', 'fi': 'oranssi', 'fy': 'oranje', 'gd': 'orains', 'gl': 'laranxa', 'gug': 'narã', 'gu': 'નારંગી', 'he': 'כתום', 'hi': 'दायरा', 'hr': 'narančasta', 'hsb': 'oranžowy', 'hu': 'narancssárga|narancs', 'is': 'appelsínugult', 'ja': 'オレンジ|オレンジ色|orange', 'kab': 'ačinawi', 'ka': 'ფორთოხლისფერი', 'kk': 'қызғылт-сары', 'km': '\u200bទឹក\u200bក្រូច', 'kn': 'ವ್ಯಾಪ್ತಿ', 'ko': '오렌지', 'lo': 'ສີສົ້ມ', 'lt': 'oranžinė', 'lv': 'oranžs', 'ml': 'ഓറഞ്ച്', 'mn': 'улбар шар', 'mr': 'नारंगी', 'my': 'ကန့်သတ်နယ်ပယ်', 'nb': 'oransje|orange', 'ne': 'दायरा', 'nl': 'oranje', 'nn': 'oransje|orange', 'oc': 'irange', 'or': 'କମଳା', 'pa_IN': 'ਰੇਜ਼', 'pt_BR': 'laranja', 'ro': 'orange|portocaliu', 'ru': 'оранжевый', 'sid': 'burtukaane', 'si': 'පරාසය', 'sk': 'oranžová', 'sl': 'oranžna', 'sq': 'portokalli', 'sr_Latn': 'narandžasta', 'sr': 'наранџаста', 'ta': 'ஆரஞ்சு', 'te': 'ఆరెంజ్', 'tr': 'turuncu', 'uk': 'оранжевий', 'vi': 'phạm vi', 'zh_CN': '橙色|橙|orange', 'zh_TW': '橘黃|橙黃|橙|橘|orange'},
'GOLD':{'en_US': 'gold', 'af': 'goud', 'am': 'ወርቅማ', 'ar': 'ذهبي', 'as': 'সোন', 'ast': 'doráu', 'be': 'залаты', 'bn_IN': 'গাঢ়', 'br': 'aour', 'bs': 'zlatna', 'ca': 'or|daurat', 'ca_valencia': 'or|daurat', 'ckb': 'ئاڵتوونی', 'cy': 'aur', 'cs': 'zlatá', 'dsb': 'złośany', 'el': 'χρυσαφί|gold', 'eo': 'ora', 'es': 'oro', 'et': 'kuldne', 'eu': 'urrea', 'fi': 'kulta', 'fr': 'or', 'fy': 'goud', 'gd': 'òir', 'gl': 'ouro', 'gug': 'oro', 'gu': 'સોનુ', 'he': 'זהב', 'hi': 'मोटा', 'hr': 'zlatna', 'hsb': 'złoty', 'hu': 'aranysárga|arany', 'is': 'gull', 'ja': '金|金色|gold', 'kab': 'ureɣ', 'ka': 'შეკვრა', 'kk': 'алтын', 'km': 'មាស', 'kn': 'ಬೋಲ್ಡ್\u200d', 'ko': '금색', 'lo': 'ສີທອງຄຳ', 'lt': 'auksinė', 'lv': 'zelta', 'ml': 'സ്വര്\u200dണ്ണം', 'mn': 'алтан', 'mr': 'सोनेरी', 'my': 'စာလုံးမဲ', 'nb': 'gull|gold', 'ne': 'बाक्लो', 'nl': 'goud', 'nn': 'gull|gold', 'oc': 'aur', 'or': 'ସ୍ୱର୍ଣ୍ଣ', 'pa_IN': 'ਗੂੜ੍ਹੇ', 'pt_BR': 'ouro', 'ro': 'gold|auriu', 'ru': 'золотой', 'sid': 'clka', 'si': 'තදකුරු', 'sk': 'zlatý', 'sl': 'zlata', 'sq': 'ngjyrë ari', 'sr_Latn': 'zlatna', 'sr': 'златна', 'ta': 'தங்கம்', 'te': 'బంగారం', 'th': 'ทอง', 'tr': 'altın rengi', 'uk': 'золотий', 'vi': 'Đậm', 'zh_CN': '金色|金|gold', 'zh_TW': '金黃|金|gold'},
'VIOLET':{'en_US': 'violet', 'am': 'ወይን ጠጅ', 'ar': 'بنفسجي', 'as': 'বেঙুনীয়া', 'ast': 'violeta', 'be': 'бэзавы', 'bn_IN': 'বেগুনী', 'br': 'mouk', 'bs': 'ljubičasta', 'ca': 'violat|violeta', 'ca_valencia': 'violat|violeta', 'ckb': 'وەنەوشەیی', 'cy': 'fioled', 'cs': 'fialová', 'de': 'violett', 'dsb': 'wioletny', 'el': 'βιολετί|violet', 'eo': 'viola', 'es': 'violeta', 'et': 'violetne', 'eu': 'bioleta', 'fi': 'violetti', 'fy': 'fiolet', 'gd': 'dath na fail-chuaiche', 'gl': 'violeta', 'gug': 'violeta', 'gu': 'જાંબલી', 'he': 'סגולעדין', 'hi': 'बैंगनी', 'hr': 'ljubičasta', 'hsb': 'fijałkojty', 'hu': 'ibolyakék|ibolya|viola', 'is': 'fjólublátt', 'ja': 'すみれ色|バイオレット|ヴァイオレット|violet', 'kab': 'amidadi', 'ka': 'იისფერი', 'kk': 'күлгін', 'km': 'ស្វាយ', 'kn': 'ನೇರಳೆ', 'ko': '보라색', 'lo': 'ສີມ່ວງ', 'lt': 'alyvų', 'lv': 'violets', 'ml': 'വയലറ്റ്', 'mn': 'ягаан', 'mr': 'गडद जांभळा', 'my': 'ခရမ်းရောင်', 'nb': 'fiolett|violet', 'ne': 'बैजनी', 'nn': 'fiolett|violet', 'or': 'ବାଇଗଣି', 'pa_IN': 'ਵੈਂਗਣੀ', 'pt_BR': 'violeta', 'ru': 'фиолетовый', 'sid': 'hamara', 'si': 'ජම්බුල වර්ණය', 'sk': 'Fialová', 'sl': 'vijolična', 'sr_Latn': 'ljubičasta', 'sr': 'љубичаста', 'ta': 'ஊதா', 'te': 'వంకాయరంగు', 'tr': 'menekşe', 'ug': 'بىنەپشە', 'uk': 'фіалковий', 'vec': 'łiła', 'vi': 'Tím xanh', 'zh_CN': '紫罗兰|蓝紫|violet', 'zh_TW': '紫蘿蘭|藍紫|violet'},
'SKYBLUE':{'en_US': 'skyblue', 'af': 'hemelblou', 'am': 'ሰማያዊ', 'ar': 'سماوي', 'as': 'আকাশনীলা', 'ast': 'celeste', 'be': 'нябесна-блакітны', 'bn_IN': 'অাকাশি নীল', 'br': 'glaz oabl', 'bs': 'nebeskoplava', 'ca': 'blau.cel|cel', 'ca_valencia': 'blau.cel|cel', 'ckb': 'شینی ئاسمانی', 'cs': 'bleděmodrá', 'de': 'hellblau', 'dsb': 'njebjomódry', 'el': 'ουρανί|skyblue', 'eo': 'ĉielblua', 'es': 'azul.cielo|celeste', 'et': 'taevasinine', 'eu': 'zeruurdina', 'fi': 'taivaansininen', 'fr': 'bleuciel', 'fy': 'himelsblau', 'gd': 'speur-ghorm', 'gl': 'celeste', 'gug': 'hovyyvága|celeste', 'gu': 'આકાશીવાદળી', 'he': 'כחולשמיים|כחולשמים|שמיים|שמים', 'hi': 'आसमानी', 'hr': 'nebeskoplava', 'hsb': 'njebjomódry', 'hu': 'égszínkék|világoskék', 'is': 'himinblátt', 'it': 'celeste', 'ja': '空色|スカイブルー|skyblue', 'kab': 'anili igni', 'kk': 'ашық_көк', 'km': 'ផ្ទៃមេឃ', 'kn': 'ಆಕಾಶನೀಲಿ', 'ko': '하늘색', 'lo': 'ສີທ້ອງຟ້າ', 'lt': 'dangaus', 'lv': 'debeszils', 'ml': 'സ്കൈബ്ലൂ', 'mn': 'хөх тэнгэр', 'mr': 'स्कायब्ल्यु', 'nb': 'himmelblå|skyblue', 'nl': 'hemelsblauw', 'nn': 'himmelblå|skyblue', 'or': 'ଆକାଶୀ ନୀଳ', 'pt_BR': 'celeste', 'ru': 'небесно-голубой', 'sid': 'gordukuula', 'sk': 'bledomodrá', 'sl': 'nebesnomodra', 'sq': 'blueqielli', 'sr_Latn': 'nebesko plava', 'sr': 'небеско плава', 'ta': 'வான்நீலம்', 'te': 'నింగినీలం', 'tr': 'gök mavisi', 'uk': 'небесно-синій', 'vec': 'sełeste', 'zh_CN': '天蓝|天蓝色|skyblue', 'zh_TW': '天藍|skyblue'},
'CHOCOLATE':{'en_US': 'chocolate', 'af': 'sjokolade', 'am': 'ጥቁር ቡናማ', 'ar': 'شوكولاتي', 'as': 'চকোলেট', 'be': 'шакаладны', 'bn_IN': 'চকোলেট', 'br': 'chokolad', 'bs': 'čokolada', 'ca': 'xocolata|xocolate', 'ca_valencia': 'xocolata|xocolate', 'ckb': 'چوکلێتی', 'cy': 'siocled', 'cs': 'čokoládová', 'de': 'dunkelbraun', 'dsb': 'śamnobruny', 'el': 'σοκολατί|chocolate', 'eo': 'ĉokolada', 'et': 'šokolaadipruun|šokolaadikarva', 'eu': 'txokolatea', 'fi': 'suklaa', 'fr': 'chocolat', 'fy': 'sûkelade', 'gd': 'dath na seòclaid', 'gu': 'ચોકલેટ', 'he': 'שוקולד', 'hi': 'चॉकलेट', 'hr': 'čokoladna', 'hsb': 'ćmowobruny', 'hu': 'világosbarna', 'is': 'súkkulaði', 'ja': '薄い茶色|チョコレート|チョコレート色|chocolate', 'kab': 'cakula', 'kk': 'шоколад_түсті', 'km': 'សូកូឡា', 'kn': 'ಚಾಕೋಲೇಟ್', 'ko': '초콜릿색', 'lo': 'ສີຊັອກໂກແລດ', 'lt': 'šokolado', 'lv': 'gaišbrūns', 'ml': 'ചോക്കോളേറ്റ്', 'mn': 'шоколад|хар хүрэн', 'mr': 'चॉकोलेट', 'nb': 'sjokoladebrun|chocolate', 'nl': 'chocolade', 'nn': 'sjokoladebrun|chocolate', 'oc': 'chocolat', 'or': 'ଚକୋଲେଟ', 'ro': 'chocolate|ciocolatiu', 'ru': 'шоколадный', 'sid': 'chokolete', 'sk': 'čokoládová', 'sl': 'čokoladna', 'sq': 'çokollatë', 'sr_Latn': 'čokolada', 'sr': 'чоколада', 'ta': 'சாக்லேட்', 'te': 'చాకోలేట్', 'tr': 'çikolata', 'uk': 'шоколадний', 'vec': 'ciocołata', 'zh_CN': '巧克力|褐色|chocolate', 'zh_TW': '巧克力|褐|chocolate'},
'BROWN':{'en_US': 'brown', 'af': 'bruin', 'am': 'ቡናማ', 'ar': 'بني', 'as': 'মূগা', 'ast': 'marrón', 'be': 'карычневы', 'bn_IN': 'বাদামি', 'br': 'liv kistin', 'bs': 'smeđa', 'ca': 'marró', 'ca_valencia': 'marró', 'ckb': 'قاوەیی', 'cs': 'hnědá', 'da': 'bbrown', 'de': 'braun', 'dsb': 'bruny', 'el': 'καφέ|brown', 'eo': 'bruna', 'es': 'marrón|café', 'et': 'pruun', 'eu': 'marroia', 'fi': 'ruskea', 'fr': 'marronclair', 'fy': 'brún', 'gd': 'donn', 'gl': 'marrón', 'gug': 'marrón', 'gu': 'તપખીરિયા રંગનું', 'he': 'חום', 'hi': 'भूरा', 'hr': 'smeđa', 'hsb': 'bruny', 'hu': 'barna', 'is': 'brúnt', 'ja': '茶色|ブラウン|brown', 'kab': 'aqehwi', 'ka': 'ყავისფერი', 'kk': 'қоңыр', 'km': 'ត្នោត', 'kn': 'ಕಂದು', 'ko': '갈색', 'lo': 'ສີນ້ຳຕານ', 'lt': 'ruda', 'lv': 'brūns', 'ml': 'ബ്രൌണ്\u200d', 'mn': 'хүрэн', 'mr': 'ब्राउन', 'my': 'အညို', 'nb': 'brun|brown', 'ne': 'कैलो', 'nl': 'bruin', 'nn': 'brun|brown', 'oc': 'marron', 'or': 'ବାଦାମୀ', 'pa_IN': 'ਭੂਰਾ', 'pt_BR': 'marrom', 'ro': 'brown|maro', 'ru': 'коричневый', 'sid': 'daama', 'si': 'දුඹුරු', 'sk': 'Hnedá', 'sl': 'rjava', 'sq': 'kafe', 'sr_Latn': 'braon', 'sr': 'браон', 'ta': 'பழுப்பு', 'te': 'గోధుమరంగు', 'th': 'น้ำตาล', 'tr': 'kahverengi', 'uk': 'коричневий', 'vec': 'maron', 'vi': 'Nâu', 'zh_CN': '棕色|棕|brown', 'zh_TW': '棕|brown'},
'LIBRELOGO':{'en_US': 'LibreLogo', 'am': 'የሊብሬ ምልክት', 'ar': 'ليبر\u200cلوغو', 'ckb': '\u202bLibreLogo', 'hi': 'लिब्रेलोगो', 'ko': '리브레로고', 'ml': 'ലിബര്\u200dലോഗോ', 'mn': 'LibreЛого', 'mr': 'लाइबरलोगो', 'or': 'Libre ପ୍ରତୀକ', 'sq': 'LogoeLibre', 'sr_Latn': 'Librelogo', 'sr': 'Либрелого', 'te': 'లిబ్రేలోగో'},
'ERROR':{'en_US': 'Error (in line %s)', 'af': 'Fout (in reël %s)', 'am': 'ስህተት (በ መስመር %s) ላይ', 'ar': 'خطأ (في السطر %s)', 'as': 'ত্ৰুটি (শাৰী %s ত)', 'ast': 'Fallu (na ringlera %s)', 'be': 'Памылка (у радку %s)', 'bg': 'Грешка (в ред %s)', 'bn_IN': 'ত্রুটি (ইন লাইন %s)', 'br': 'Fazi (gant linenn %s)', 'bs': 'Greška (u liniji %s)', 'ca': "S'ha produït un error (a la línia %s)", 'ca_valencia': "S'ha produït un error (a la línia %s)", 'cy': 'Gwall (yn llinell: %s)', 'cs': 'Chyba (na řádku %s)', 'da': 'Fejl (i linje %s)', 'de': 'Fehler (in Zeile %s)', 'dsb': 'Zmólka (w smužce %s)', 'el': 'Σφάλμα (στη γραμμή %s)', 'eo': 'Eraro (en linio %s)', 'es': 'Error (en el renglón %s)', 'et': 'Viga (real %s)', 'eu': 'Errorea (%s lerroan)', 'fi': 'Virhe (rivillä %s)', 'fr': 'Erreur (à la ligne %s)', 'fy': 'Flater (op rigel %s)', 'ga': 'Earráid (ar líne %s)', 'gd': 'Mearachd (ann an loidhne %s)', 'gl': 'Erro (na liña %s)', 'gug': 'Jejavy (líneape %s)', 'gu': 'ભૂલ (વાક્ય %s માં)', 'he': 'שגיאה (בשורה %s)', 'hi': 'त्रुटि (%s पंक्ति में)', 'hr': 'Greška (u retku %s)', 'hsb': 'Zmylk (w lince %s)', 'hu': 'Hiba (%s. sor)', 'id': 'Galat (dalam baris %s)', 'is': 'Villa (á línu %s)', 'it': 'Errore (nella riga %s)', 'ja': '(%s 行目で)エラー', 'kab': 'Tuccḍa(deg uzirig %s)', 'kk': 'Қате (%s жолында)', 'km': 'កំហុស (ក្នុង\u200bតួ %s)', 'kn': 'ದೋಷ (%s ಸಾಲಿನಲ್ಲಿ)', 'ko': '오류 (%s 번째 줄)', 'lo': 'ເກີດຂໍ້ຜິດພາດ (ໃນແຖວ %s)', 'lt': 'Klaida (%s eilutėje)', 'lv': 'Kļūda (rindā %s)', 'ml': 'പിശക് (%s വരിയില്\u200d)', 'mn': 'Алдаа (%s мөрөнд)', 'mr': 'त्रुटी (ओळ %s वरील)', 'nb': 'Feil (i linje %s)', 'nl': 'Error (op regel %s)', 'nn': 'Feil (i linje %s)', 'oc': 'Error (a la linha %s)', 'or': 'ତ୍ରୁଟି (ଧାଡ଼ି %s ରେ)', 'pl': 'Błąd (w wierszu %s)', 'pt_BR': 'Erro (na linha %s)', 'pt': 'Erro (na linha %s)', 'ro': 'Eroare (la linia %s)', 'ru': 'Ошибка (в строке %s)', 'sid': 'Soro (%s xuruuri giddo)', 'sk': 'Chyba (na riadku %s)', 'sl': 'Napaka (v vrstici %s)', 'sq': 'Gabim (në rreshtin %s)', 'sr_Latn': 'Greška (red %s)', 'sr': 'Грешка (ред %s)', 'sv': 'Fel (på rad %s)', 'szl': 'Błōnd (we liniji %s)', 'ta': 'பிழை (வரி %s இல்)', 'te': 'దోషం (వరుస %s నందు)', 'tr': 'Hata (%s satırında)', 'ug': 'خاتالىق(%s قۇردا)', 'uk': 'Помилка (в рядку %s)', 'vec': 'Eror (inte ła riga %s)', 'zh_CN': '错误 (在第 %s 行)', 'zh_TW': '錯誤 (第 %s 列)'},
'ERR_ZERODIVISION':{'en_US': 'Division by zero.', 'af': 'Deling deur nul.', 'am': 'በዜሮ ማካፈል', 'ar': 'القسمة على صفر.', 'as': 'শুণ্যৰে হৰণ কৰা ।', 'ast': 'División por cero.', 'be': 'Дзяленне на нуль.', 'bg': 'Деление на нула.', 'bn_IN': 'শূন্য দিয়ে বিভাজন।', 'bn': 'শূন্য দিয়ে বিভাজন।', 'bo': 'ཀླད་ཀོར་ཕུད།', 'br': 'Rannadur dre vann.', 'brx': 'लाथिखजों राननाय.', 'bs': 'Dijeljenje sa nulom.', 'ca': 'Divisió per zero.', 'ca_valencia': 'Divisió per zero.', 'ckb': 'دابەشکردن بەسەر سفردا.', 'cy': 'Rhannu gyda sero.', 'cs': 'Dělení nulou.', 'da': 'Division med nul.', 'de': 'Division durch Null.', 'dgo': 'सिफर कन्नै तक्सीम', 'dsb': 'Diwizija pśez nulu.', 'dz': 'ཀླད་ཀོར་གིས་བགོ་རྩིས།', 'el': 'Διαίρεση με το μηδέν.', 'eo': 'Divido per nul.', 'es': 'División por cero.', 'et': 'Nulliga jagamine.', 'eu': 'Zatitzailea zero.', 'fa': 'تقسیم بر صفر', 'fi': 'Jako nollalla.', 'fr': 'Division par zéro.', 'fy': 'Dieling troch nul.', 'ga': 'Roinnt le nialas.', 'gd': 'Roinneadh le neoini.', 'gl': 'División por cero.', 'gug': 'División por cero.', 'gu': 'શૂન્ય દ્વારા વિભાજન.', 'he': 'חלוקה באפס.', 'hi': 'शून्य से विभाजन.', 'hr': 'Dijeljenje s nulom.', 'hsb': 'Diwizija přez nulu.', 'hu': 'Osztás nullával.', 'id': 'Pembagian oleh nol.', 'is': 'Deiling með núlli.', 'it': 'Divisione per zero.', 'ja': 'ゼロで割り算した。', 'kab': 'Tabeṭṭayt ɣef ilem.', 'ka': 'ნულზე გაყოფა.', 'kk': 'Нөлге бөлу.', 'km': 'ចែក\u200bនឹង\u200bសូន្យ\xa0។', 'kmr_Latn': 'Li sifirê parva kirin.', 'kn': 'ಶೂನ್ಯದಿಂದ ಭಾಗಾಕಾರ.', 'kok': 'शून्यान भाग', 'ko': '영(0)으로 나눔', 'ks': 'صفرسئتھ تقسیم كرُن', 'lo': 'ຫານດ້ວຍສູນ.', 'lt': 'Dalyba iš nulio.', 'lv': 'Dalīšana ar nulli.', 'mai': 'सुन्नासँ भाग', 'mk': 'Делење со нула.', 'ml': 'പൂജ്യം കൊണ്ടു് ഹരിക്കുക.', 'mni': 'শূন্যনা য়েন্নবা.', 'mn': 'Тэгд хуваагдаж байна.', 'mr': 'डिविजन बाय झिरो.', 'my': 'သုံညဖြင့်စားခြင်း။', 'nb': 'Deling med null.', 'ne': 'शून्यद्वारा विभाजन ।', 'nl': 'Deling door nul.', 'nn': 'Deling med null.', 'oc': 'Division per zèro.', 'om': 'Qooddii zeeroodhaanii.', 'or': 'ଶୂନ୍ୟ ଦ୍ୱାରା ବିଭାଜିତ।', 'pa_IN': 'ਜ਼ੀਰੋ ਨਾਲ ਭਾਗ', 'pl': 'Dzielenie przez zero.', 'pt_BR': 'Divisão por zero.', 'pt': 'Divisão por zero', 'ro': 'Împărțire la zero.', 'ru': 'Деление на ноль.', 'rw': 'Kugabanya na zeru.', 'sa_IN': 'शून्यतः विभाजनम् ।', 'sat': 'सुन दाराय ते हा़टिञ', 'sd': 'ٻڙيءَ سان ونڊيو', 'sid': 'Zeerotenni beeha.', 'si': 'ශුන්\u200dයයෙන් බෙදීම.', 'sk': 'Delenie nulou.', 'sl': 'Deljenje z nič.', 'sq': 'Pjesëtim me zero.', 'sr_Latn': 'Deljenje nulom.', 'sr': 'Дељење нулом.', 'sv': 'Division med noll.', 'sw_TZ': 'Gawanyika kwa sifuri', 'szl': 'Dzielynie bez zero.', 'ta': 'சுழியால் வகுத்தல்.', 'te': 'సున్నాతో భాగహారము.', 'tg': 'Тақсим бар сифр.', 'th': 'หารด้วยศูนย์', 'tr': 'Sıfıra bölme.', 'tt': 'Нульгә бүлү.', 'ug': 'نۆلگە بۆلۈنگەن.', 'uk': 'Ділення на нуль.', 'uz': 'Nolga boʻlish', 'vec': 'Divizion par zero.', 'vi': 'Chia cho không.', 'zh_CN': '被零除。', 'zh_TW': '除以零。'},
'ERR_NAME':{'en_US': 'Unknown name: “%s”.', 'af': 'Onbekende naam: "%s".', 'am': 'ያልታወቀ ስም: “%s”.', 'ar': 'الاسم مجهول: ”%s“.', 'ast': "Desconozse'l nome: «%s».", 'be': 'Невядомая назва: “%s”.', 'bg': 'Непознато име: „%s“.', 'bn_IN': 'অজানা নাম: “%s”.', 'ca': 'Nom desconegut: «%s».', 'ca_valencia': 'Nom desconegut: «%s».', 'ckb': 'ناوی نەناسراو:  %s', 'cy': 'Enw anhysbys: “%s”.', 'cs': 'Neznámý název: „%s“.', 'da': 'Ukendt navn: “%s”.', 'de': 'Unbekannter Name: „%s“.', 'dsb': 'Njeznate mě: “%s”.', 'el': 'Άγνωστο όνομα: “%s”.', 'eo': 'Nekonata nomo: „%s”.', 'es': 'Nombre desconocido: «%s».', 'et': 'Tundmatu nimi: „%s”.', 'eu': 'Izen ezezaguna: “%s”.', 'fi': 'Tuntematon nimi: ”%s”.', 'fr': 'Nom inconnu : “%s”.', 'fy': 'Unbekende namme: “%s”.', 'ga': 'Ainm anaithnid: “%s”.', 'gd': 'Ainm neo-aithnichte: “%s”.', 'gl': 'Nome descoñecido: «%s».', 'gug': "Téra ojekuaa'ỹva: «%s»", 'he': 'שם לא ידוע: „%s“.', 'hr': 'Nepoznato ime: “%s”.', 'hsb': 'Njeznate mjeno: “%s”.', 'hu': 'Ismeretlen név: „%s”.', 'id': 'Nama tak dikenal: “%s”.', 'is': 'Óþekkt heiti: “%s”.', 'it': 'Nome sconosciuto: “%s”.', 'ja': '不明な名前: “%s”。', 'kab': 'Isem arussin: “%s”.', 'kk': 'Аты белгісіз: "%s".', 'ko': '알 수 없는 이름: “%s”', 'lo': 'ບໍ່ຮູ້ຈັກຊື່: “%s”.', 'lt': 'Nežinoma komanda: „%s“.', 'lv': 'Nezināms nosaukums: “%s”.', 'mn': 'Тодорхойгүй нэр: "%s".', 'nb': 'Ukjent navn: «%s».', 'nl': 'Onbekende naam: "%s”.', 'nn': 'Ukjend namn: «%s».', 'oc': 'Nom desconegut : «%s».', 'pl': 'Nierozpoznana nazwa: „%s”.', 'pt_BR': 'Nome desconhecido: “%s”', 'pt': 'Nome desconhecido: “%s”', 'ro': 'Nume necunoscut: „%s”.', 'ru': 'Неизвестное имя: «%s».', 'sk': 'Neznámy názov: „%s“.', 'sl': 'Neznano ime: “%s”.', 'sq': 'Emër i panjohur: "%s".', 'sv': 'Okänt namn: "%s”.', 'szl': 'Niyznōme miano: “%s”.', 'tr': 'Bilinmeyen ad: “%s”.', 'ug': 'يوچۇن ئات: ‘%s”.', 'uk': 'Невідома назва: “%s”.', 'vec': 'Nome mìa conosùo: “%s”.', 'zh_CN': '未知名称:「%s」。', 'zh_TW': '未知名稱：「%s」。'},
'ERR_ARGUMENTS':{'en_US': '%s takes %s arguments (%s given).', 'af': '%s het %s argumente nodig (%s gegee).', 'am': '%s የሚወስደው %s ክርክር (%s የተሰጠው)', 'ar': '%s يأخذ %s من المعاملات (%s أُعطيت).', 'as': '%s এ %s তৰ্কসমূহ গ্ৰহণ কৰে (%s দিয়া হৈছে)।', 'ast': '%s lleva %s argumentos (%s daos).', 'be': '%s прымае %s аргументаў (пададзена %s).', 'bg': '%s приема %s аргумента (подадени са %s).', 'br': '%s a geler %s arguzenn (%s roet).', 'bs': '%s uzima %s argumenata (%s dato).', 'ca': '%s pren %s arguments (%s donats).', 'ca_valencia': '%s pren %s arguments (%s donats).', 'cy': 'Mae %s yn cymryd %s ymresymiad (Derbyn %s ).', 'cs': '%s vyžaduje %s argumentů (předáno %s).', 'da': '%s tager %s argumenter (%s givet).', 'de': '%s benötigt %s Argumente (%s angegeben).', 'dsb': '%s trjeba toś tu licbu argumentow: %s (%s pódane).', 'el': 'το %s παίρνει τα ορίσματα %s (%s δεδομένα).', 'eo': '%s prenas %s argumentojn (%s donitaj).', 'es': '%s toma %s argumentos (se proporcionaron %s).', 'et': '%s võtab %s argumenti (aga anti %s).', 'eu': '%s(e)k %s argumentu hartu ditu (%s emanda).', 'fi': '%s tarvitsee %s argumenttia (%s annettu).', 'fr': '%s prend les arguments %s (%s donné).', 'fy': '%s hat %s arguminten nedich (%s jûn).', 'ga': 'Glacann %s le %s argóint (bhí %s argóint ann).', 'gd': 'Gabhaidh %s %s argamaidean (thug thu seachad %s).', 'gl': '%s toma %s argumentos (%s dados).', 'gug': '%s toma %s argumentos (se proporcionaron %s).', 'gu': '%s એ %s દલીલો લે છે (%s આપેલ છે).', 'he': '%s מקבלת %s ארגומנטים (%s סופקו).', 'hi': '%s लेता %s वितर्क (%s दिया हुआ).', 'hr': '%s ima %s argumente (%s dano).', 'hsb': '%s trjeba tutu ličbu argumentow: %s (%s podate).', 'hu': '%s: %s adatot vár, de %s lett megadva.', 'id': '%s perlu %s argumen (diberikan %s).', 'is': '%s tekur %s viðföng (%s gefið).', 'it': '%s prende %s argomenti (%s dati).', 'ja': '%s は %s 個の引数をとります(%s 個与えられました)。', 'kab': '%s yettawi %s n tiɣira (%s ttunefken-d).', 'kk': '%s үшін %s аргумент керек (%s берілді).', 'km': '%s ចាប់\u200bយក\u200bអាគុយម៉ង់ %s (បាន\u200bផ្ដល់ឲ្យ %s )។', 'kn': '%s ಎನ್ನುವುದು %s ಆರ್ಗ್ಯುಮೆಂಟ್\u200cಗಳನ್ನು ತೆಗೆದುಕೊಳ್ಳುತ್ತದೆ (%s ಒದಗಿಸಲಾದ).', 'ko': '%s은(는) %s 개의 파라미터를 갖습니다.(%s 제공됨).', 'lo': '%s ໃຊ້ເວລາ %s ການຂັດແຍ້ງ (%s ໄດ້ຮັບ).', 'lt': 'Komandai „%s“ reikia %s argumentų (nurodyta %s).', 'lv': '%s pieņem %s parametrus (nevis %s).', 'ml': '%s, %s ആര്\u200dഗ്രുമെന്റുകള്\u200d സ്വീകരിയ്ക്കുന്നു (%s നല്\u200dകിയിരിയ്ക്കുന്നു).', 'mn': '%s нь %s аргументыг авна (%s өгсөн).', 'mr': '%s %s आर्ग्युमेंट्स (%s दिलेले) प्राप्त करते.', 'nb': '%s tar %s argumenter (%s er angitt).', 'nl': '%s heeft %s argumenten nodig (%s gegeven).', 'nn': '%s tar %s argument (%s er gjevne).', 'oc': '%s pren los arguments %s (%s donat).', 'or': '%s ଟି %s ପ୍ରାଚଳ ନେଇଥାଏ (%s ପ୍ରଦତ୍ତ)।', 'pl': '%s pobiera %s argumenty (%s podane).', 'pt_BR': '%s usa %s argumentos (%s definidos).', 'pt': '%s recebe %s argumentos (indicou %s)', 'ro': '%s dă %s argumente (%s date).', 'ru': '%s принимает %s аргументов (передано %s).', 'sid': '%s tidho %s adhanno (%s uyinoonniha).', 'sk': '%s vyžaduje %s argumentov ( zadaných bolo %s).', 'sl': '%s potrebuje %s argumentov (%s jih je podanih).', 'sq': '%s merr %s argumente (%s të dhëna).', 'sr_Latn': '%s uzima %s argumenata (navedeno %s).', 'sr': '%s узима %s аргумената (наведено %s).', 'sv': '%s tar %s argument (%s givna).', 'szl': '%s pobiyro %s argumynta (%s podane).', 'ta': '%s ஆனது %s மதிப்புருக்களை எடுத்துக்கொள்ளும் (%s கொடுக்கப்பட்டது).', 'te': '%s అనునది %s ఆర్గుమెంట్లు తీసుకొనును (%s యీయబడెను).', 'tr': '%s, %s bağımsız değişken alır (%s verilen).', 'ug': '%s غا %s ئۆزگەرگۈچى زۆرۈر (%s بېرىلگەن).', 'uk': '%s отримує %s аргументів (передано %s).', 'vec': '%s el ciapa %s argomenti (%s dati).', 'zh_CN': '%s 需要 %s 个参数 (已给出 %s 个)。', 'zh_TW': '%s 取用 %s 個引數 (已給 %s 個)。'},
'ERR_BLOCK':{'en_US': 'Error (extra or missing spaces at brackets?)', 'af': 'Fout (ekstra of ontbrekende spasies by haakies?)', 'am': 'ስህተት (ተጨማሪ ወይንም በቅንፉ ውስጥ ባዶ ቦታ የለም?)', 'ar': 'خطأ (مسافات إضافية أو مفقودة في الأقواس؟)', 'as': 'ত্ৰুটি (ব্ৰেকেটসমূহত অতিৰিক্ত অথবা সন্ধানহিন স্পেইচ?)', 'ast': 'Error (¿sobren o falten espacios nos paréntesis?)', 'be': 'Памылка (лішнія ці недастатковыя прабелы ў дужках?)', 'bg': 'Грешка (излишни или липсващи интервали при скоби?)', 'bn_IN': 'ত্রুটি (ব্র্যাকেটে অতিরিক্ত বা অনুপস্থিত স্পেস?)', 'br': "Fazi (esaouioù a vank pe a zo re etre ar c'hrommelloù ?)", 'bs': 'Greška (viška ili fali razmaka u ragradama?)', 'ca': "S'ha produït un error (espais extra o omesos als parèntesis?)", 'ca_valencia': "S'ha produït un error (espais extra o omesos als parèntesis?)", 'cy': 'Gwall (bylchau ychwanegol neu goll wrth y cromfachau?)', 'cs': 'Chyba (přebývající nebo chybějící mezery u závorek?)', 'da': 'Fejl (ekstra eller manglende mellemrum ved kantede parenteser?)', 'de': 'Fehler (zusätzliche oder fehlende Leerstelle bei Klammern?)', 'dsb': 'Zmólka (pśidatne abo felujuce prozne znamjenja pla spinkow?)', 'el': 'Σφάλμα (πρόσθετα ή ελλείποντα κενά στις παρενθέσεις;)', 'eo': 'Eraro (ekstra aŭ mankanta spaceto ĉe krampoj?)', 'es': 'Error (¿faltan o sobran espacios en los corchetes?)', 'et': 'Viga (liiga palju või vähe tühikuid sulgude juures?)', 'eu': 'Errorea (zuriuneak soberan edo faltan parentesietan?)', 'fi': 'Virhe (liikaa tai liian vähän välejä sulkumerkkien vieressä?)', 'fr': 'Erreur (espaces supplémentaires ou manquants entre les parenthèses ?)', 'fy': 'Flater (ekstra of ûntbrekkende spaasjes by heakjes?)', 'ga': 'Earráid (spásanna breise nó ar iarraidh in aice leis na lúibíní?)', 'gd': 'Mearachd (cus àitichean no feadhainn a dhìth aig na bracaidean?)', 'gl': 'Erro (espazos extra ou que faltan nas parénteses?)', 'gu': 'ભૂલ (વધારાની અથવા ગેરહાજર જગ્યાઓ કૌંસમાં છે?)', 'he': 'שגיאה (יכול להיות שיש יותר מדי או שאין רווחים עם הסוגריים?)', 'hi': 'त्रुटि (ब्रैकेट में अतिरिक्त या अनुपस्थित स्थान?)', 'hr': 'Greška (ima previše ili nedostaje razmaka u zagradama?)', 'hsb': 'Zmylk (přidatne abo falowace mjezoty pola spinkow?)', 'hu': 'Hiba (hiányzó vagy felesleges szóköz a kapcsos zárójelnél?)', 'id': 'Galat (spasi ekstra atau kurang pada kurung?)', 'is': 'Villa (vantar eða er ofaukið bilum við sviga?)', 'it': 'Errore (spazi aggiuntivi o mancanti alle parentesi?)', 'ja': 'エラー(括弧の辺りにスペースが重複または不足しているかもしれません)', 'kab': 'Tuccḍa (tallunt gar tacciwin tzadneɣ txuṣ?)', 'kk': 'Қате (жақша ішіндегі бос аралықтар артық немесе жетіспейді?)', 'km': 'កំហុស (បាត់\u200b ឬ\u200bមាន\u200bចន្លោះ\u200bបន្ថែម\u200bនៅ\u200bវង់\u200bក្រចក?)', 'kn': 'ದೋಷ (ಆವರಣಗಳಲ್ಲಿ ಹೆಚ್ಚುವರಿ ಅಂತರಗಳು ಇವೆಯೆ ಅಥವ ಕಾಣಿಸುತ್ತಿಲ್ಲವೆ?)', 'ko': '오류 (괄호안에 불필요하게 추가되었거나 누락된 빈칸)', 'lo': 'ເກີດຂໍ້ຜິດພາດ (ຊ່ອງວ່າງທີ່ພິເສດ ຫຼື ຂາດຫາຍໄປຢູ່ໃນວົງເລັບ?)', 'lt': 'Klaida (per daug arba per mažai tarpų skliausteliuose?)', 'lv': 'Kļūda (liekas vai trūkstošas atstarpes pie iekavām?)', 'ml': 'പിശക്', 'mn': 'Алдаа (хаалтанд дутуу эсвэл илүү хоосон зай байна уу?)', 'mr': 'त्रुटी (ब्रॅकेट्सकडील अगाउ किंवा न आढळलेली मोकळी जागा?)', 'nb': 'Feil (ekstra eller manglende mellomrom ved parenteser?)', 'nl': 'Error (extra of ontbrekende spaties bij haakjes?)', 'nn': 'Feil (Kan vera feil bruk av mellomrom ved parentesar)', 'oc': 'Error (espacis suplementaris o mancants entre las parentèsis ?)', 'or': 'ତ୍ରୁଟି (ବନ୍ଧନିଗୁଡ଼ିକରେ ଅତିରିକ୍ତ କିମ୍ବା ଅନୁପସ୍ଥିତ ଖାଲିସ୍ଥାନ ଅଛି?)', 'pl': 'Błąd (nadmiarowe lub brakujące spacje w nawiasach?)', 'pt_BR': 'Erro (há espaços faltando ou a mais nos colchetes?)', 'pt': 'Erro (espaços em falta ou a mais nos parênteses?)', 'ro': 'Eroare (spații sau paranteze în plus sau lipsă?)', 'ru': 'Ошибка (лишние или недостающие пробелы в скобках?)', 'sid': 'Soro (qoqqowubbate aana ledote woy hawamme fooquwa?)', 'sk': 'Chyba (nadbytočné alebo chýbajúce medzery pri zátvorkách?)', 'sl': 'Napaka (odvečni ali manjkajoči presledki pri oklepajih?)', 'sq': 'Gabim (hapësirë që mungon ose ekstra tek kllapat?)', 'sr_Latn': 'Greška (mogući višak ili manjak razmaka uz zagrade?)', 'sr': 'Грешка (могући вишак или мањак размака уз заграде?)', 'sv': 'Fel (för många eller saknade blanksteg vid parenteser?)', 'szl': 'Błōnd (nadmiarowe abo brakujōnce spacyje w nowiasach?)', 'ta': 'பிழை (பிறையடைப்புகளில் இடைவெளிகள் கூடுதலாக அல்லது விடுபட்டுள்ளதா?)', 'te': 'దోషం (బ్రాకెట్ల వద్ద అదనపు లేదా లేని ఖాళీలు వున్నాయా?)', 'tr': 'Hata (köşeli ayraçlarda fazladan veya eksik boşluk?)', 'ug': 'خاتالىق (تىرناقتا بوشلۇق ئاز ياكى كۆپ؟)', 'uk': 'Помилка (надлишок або нестача пробілів у дужках?)', 'vec': 'Eror (spasi in pì o in manco so łe parènteze?)', 'zh_CN': '错误 (括号处多用或少用了空格?)', 'zh_TW': '錯誤 (括弧中有額外空格或遺漏空格？)'},
'ERR_KEY':{'en_US': 'Unknown element: %s', 'af': 'Onbekende element: %s', 'am': 'ያልታወቀ አካል: %s', 'ar': 'عنصر مجهول: %s', 'as': 'অজ্ঞাত উপাদান: %s', 'ast': "Desconozse l'elementu: %s", 'be': 'Невядомы элемент: %s', 'bg': 'Непознат елемент: %s', 'bn_IN': 'অজানা স্বত্বা %s', 'br': 'Elfenn dianav : %s', 'bs': 'Nepoznat element: %s', 'ca': "L'element «%s» no és conegut.", 'ca_valencia': "L'element «%s» no és conegut.", 'ckb': 'توخمی نەناسراو:  %s', 'cy': 'Elfen anhysbys: %s', 'cs': 'Neznámý prvek: %s', 'da': 'Ukendt element: %s', 'de': 'Unbekanntes Element: %s', 'dsb': 'Njeznaty element: %s', 'el': 'Άγνωστο στοιχείο: %s', 'eo': 'Nekonata elemento: %s', 'es': 'Elemento desconocido: %s', 'et': 'Tundmatu element: %s', 'eu': 'Elementu ezezaguna: %s', 'fi': 'Tuntematon elementti: %s', 'fr': 'Élément inconnu : %s', 'fy': 'Unbekend elemint %s', 'ga': 'Eilimint anaithnid: %s', 'gd': 'Eileamaid neo-aithnichte: %s', 'gl': 'Elemento descoñecido: %s', 'gug': "Elemento ojekuaa'ỹva: %s", 'gu': 'અજ્ઞાત ઘટક: %s', 'he': 'רכיב לא ידוע: %s', 'hi': 'अज्ञात तत्व: %s', 'hr': 'Nepoznati element: %s', 'hsb': 'Njeznaty element: %s', 'hu': 'Ismeretlen elem: %s', 'id': 'Elemen tak diketahui: %s', 'is': 'Óþekkt stak: %s', 'it': 'Elemento sconosciuto: %s', 'ja': '不明な要素: %s', 'kab': 'Aferdis arussin: %s', 'kk': 'Белгісіз элемент: %s', 'km': 'មិន\u200bស្គាល់\u200bធាតុ៖ %s', 'kn': 'ಗೊತ್ತಿರದ ಘಟಕ: %s', 'ko': '알 수 없는 요소: %s', 'lo': 'ອົງປະກອບທີ່ບໍ່ຮູ້ຈັກ: %s', 'lt': 'Nežinomas elementas: %s', 'lv': 'Nezināms elements — %s', 'ml': 'അപരിചിതമായ എലമെന്റ്: %s', 'mn': 'Үл мэдэгдэх элемент: %s', 'mr': 'अपरिचीत एलिमेंट: %s', 'nb': 'Ukjent element: %s', 'nl': 'Onbekend element %s', 'nn': 'Ukjent element: %s', 'oc': 'Element desconegut : %s', 'or': 'ଅଜଣା ଉପାଦାନ: %s', 'pl': 'Nieznany element: %s', 'pt_BR': 'Elemento desconhecido: %s', 'pt': 'Elemento desconhecido: %s', 'ro': 'Element necunoscut: %s', 'ru': 'Неизвестный элемент: %s', 'sid': 'Afaminokki miila: %s', 'sk': 'Neznámy prvok: %s', 'sl': 'Neznan element: %s', 'sq': 'Elementi i panjohur: %s', 'sr_Latn': 'Nepoznati element: %s', 'sr': 'Непознати елемент: %s', 'sv': 'Okänt element: %s', 'szl': 'Niyznōmy elymynt: %s', 'ta': 'தெரியாத கூறு: %s', 'te': 'తెలియని మూలకం: %s', 'tr': 'Bilinmeyen öge: %s', 'ug': 'يوچۇن ئېلېمېنت: %s', 'uk': 'Невідомий елемент: %s', 'vec': 'Ełemento mìa conosùo: %s', 'zh_CN': '未知元素: %s', 'zh_TW': '未知元素：%s'},
'ERR_INDEX':{'en_US': 'Index out of range.', 'af': 'Indeks oorskry bereik.', 'am': 'ማውጫው ከተወሰነው ውጪ ነው', 'ar': 'الفهرس خارج المجال.', 'as': 'সূচী বিস্তাৰৰ বাহিৰ।', 'ast': 'Índiz fuera de rangu.', 'be': 'Індэкс па-за абсягам.', 'bg': 'Индекс извън обхвата.', 'bn_IN': 'সূচি মান সীমাবহির্ভূত।', 'br': 'Ibil er maez eus al lijorenn.', 'bs': 'Indeks van opsega.', 'ca': "L'índex és fora de l'interval.", 'ca_valencia': "L'índex és fora de l'interval.", 'ckb': 'پێڕست لە دەرەوەی بوارەکەیە.', 'cy': "Mynegai tu allan o'r ystod.", 'cs': 'Index mimo rozsah.', 'da': 'Indeks uden for tilladt område.', 'de': 'Index außerhalb des Bereichs.', 'dsb': 'Indeks zwenka wobceŕka.', 'el': 'Δείκτης εκτός περιοχής.', 'eo': 'Indekso ekster amplekso.', 'es': 'Índice fuera del intervalo.', 'et': 'Indeks vahemikust väljas.', 'eu': 'Indizea barrutitik kanpo.', 'fi': 'Indeksimuuttuja arvoalueen ulkopuolella.', 'fr': 'Index en dehors de la plage.', 'fy': 'Yndeks bûten berik.', 'ga': 'Innéacs as raon.', 'gd': 'Tha an clàr-amais taobh a-muigh na rainse.', 'gl': 'Índice fóra de intervalo.', 'gu': 'અનુક્રમણિકા વ્યાખ્યાયિત મર્યાદાની બહાર છે.', 'he': 'האינדקס מחוץ לטווח.', 'hi': 'अनुक्रमणिका दायरे से बाहर है.', 'hr': 'Indeks je izvan raspona.', 'hsb': 'Indeks zwonka wobłuka.', 'hu': 'Nem létező elemre hivatkozás.', 'id': 'Indeks di luar rentang.', 'is': 'Vísir er ekki innan skilgreinds sviðs.', 'it': "Indice fuori dall'area.", 'ja': 'インデックスが範囲外です。', 'kab': 'Amatar berra n tegrumma.', 'kk': 'Индекс ауқымнан тыс.', 'km': 'លិបិក្រម\u200bក្រៅ\u200bជួរ។', 'kn': 'ಸೂಚಿಯು ವ್ಯಾಪ್ತಿಯ ಹೊರಗಿದೆ.', 'ko': '범위 외의 인덱스', 'lo': 'ດັດຊະນີອອກຈາກຊ່ວງທີ່ກໍານົດໄວ້.', 'lt': 'Rodyklė už ribų', 'lv': 'Indekss ir ārpus diapazona.', 'ml': 'സൂചിക പരിധിയ്ക്കു് പുറത്തു്', 'mn': 'Индекс хязгаараас хэтэрсэн байна.', 'mr': 'इंडेक्स आउट ऑफ रेंज.', 'nb': 'Indeksen er utenfor området.', 'nl': 'Index buiten gedefinieerd bereik.', 'nn': 'Indeksen er utanfor området.', 'oc': 'Indèx en defòra de la plaja.', 'or': 'ଅନୁକ୍ରମଣିକା ପରିସର ବାହାରେ ଅଛି।', 'pl': 'Indeks poza zakresem.', 'pt_BR': 'Índice fora do intervalo.', 'pt': 'Índice fora do intervalo', 'ro': 'Index în afara intervalului.', 'ru': 'Индекс вне диапазона.', 'sid': 'Hakkageeshshu gobayiidi mashalaqisaancho.', 'sk': 'Index je mimo rozsahu.', 'sl': 'Kazalo je izven območja.', 'sq': 'Vlerë jashtë rrezes.', 'sr_Latn': 'indeksiranje van opsega.', 'sr': 'индексирање ван опсега.', 'sv': 'Indexet ligger utanför intervallet.', 'szl': 'Indeks poza zakresym.', 'ta': 'குறியீடு வரம்பைத் தாண்டியுள்ளது.', 'te': 'విషయసూచిక విస్తృతి బయటవుంది.', 'tr': 'Dizin aralık dışında.', 'ug': 'ئىندېكىس دائىرىدىن ھالقىدى.', 'uk': 'Індекс поза діапазоном.', 'vec': "Ìndeze fora de l'area.", 'zh_CN': '索引越界。', 'zh_TW': '索引超出範圍。'},
'ERR_STOP':{'en_US': 'Program terminated:', 'af': 'Program be-eindig:', 'am': 'መተግበሪያው ተቋርጧል :', 'ar': 'توقف البرنامج:', 'as': 'প্ৰগ্ৰাম অন্ত কৰা হল:', 'ast': 'Programa fináu:', 'be': 'Праграма спынена:', 'bg': 'Програмата е прекратена:', 'bn_IN': 'প্রোগ্রাম সাময়িক ভাবে বন্ধ করা হয়েছে:', 'br': 'Goulev arsavet :', 'bs': 'Program okončan:', 'ca': 'El programa ha acabat:', 'ca_valencia': 'El programa ha acabat:', 'ckb': 'بەرنامە داخرا:', 'cy': 'Rhaglen wedi dod i ben:', 'cs': 'Program ukončen:', 'da': 'Programmet afbrudt:', 'de': 'Programm beendet:', 'dsb': 'Program skóńcony:', 'el': 'Το πρόγραμμα τερματίστηκε:', 'eo': 'Programo haltita:', 'es': 'Programa finalizado:', 'et': 'Programm lõpetatud:', 'eu': 'Programa eten da:', 'fi': 'Ohjelma on lopetettu:', 'fr': 'Programme arrêté :', 'fy': 'Programma ôfbrútsen:', 'ga': 'Stopadh an ríomhchlár:', 'gd': "Chaidh crìoch a chur air a' phrògram:", 'gl': 'Programa pechado:', 'gu': 'કાર્યક્રમનો અંત આવ્યો:', 'he': 'התכנית חוסלה:', 'hi': 'प्रोग्राम बाहर हुआ:', 'hr': 'Program je završen:', 'hsb': 'Program skónčeny:', 'hu': 'A futás leállítva:', 'id': 'Program diakhiri:', 'is': 'Forritið hætti:', 'it': 'Programma terminato:', 'ja': 'プログラムが終了しました:', 'kab': 'Ahil ibedd:', 'kk': 'Бағдарлама үзілді:', 'km': 'បាន\u200bបញ្ចប់\u200bកម្មវិធី៖', 'kn': 'ಪ್ರೋಗ್ರಾಂ ಅಂತ್ಯಗೊಂಡಿದೆ:', 'ko': '프로그램이 종료됨:', 'lo': 'ໂປຣແກຣມຖືກຍົກເລີກ:', 'lt': 'Programos darbas nutrauktas:', 'lv': 'Programma pārtraukta:', 'ml': 'പ്രോഗ്രാം നിര്\u200dത്തിയിരിയ്ക്കുന്നു:', 'mn': 'Програм зогссон:', 'mr': 'प्रोग्राम बंद केले:', 'nb': 'Programmet ble avsluttet:', 'nl': 'Programma afgebroken:', 'nn': 'Programmet vart avslutta fordi', 'oc': 'Programa arrestat :', 'or': 'ପ୍ରଗ୍ରାମ ସମାପ୍ତ ହୋଇଛି:', 'pl': 'Program zakończony:', 'pt_BR': 'Programa encerrado:', 'pt': 'Programa terminado:', 'ro': 'Programul s-a terminat:', 'ru': 'Программа остановлена:', 'sid': 'Pirogirame gooffino:', 'sk': 'Program ukončený:', 'sl': 'Program se je zaključil:', 'sq': 'Programi përfundoi:', 'sr_Latn': 'Program prekinut:', 'sr': 'Програм прекинут:', 'sv': 'Program avslutades:', 'szl': 'Program zakōńczōny:', 'ta': 'நிரல் முடிக்கப்பட்டது:', 'te': 'ప్రోగ్రామ్ అంతమైను:', 'tr': 'Program sonlandırıldı:', 'ug': 'پىروگرامما توختىدى:', 'uk': 'Програму зупинено:', 'vec': 'Programa terminà:', 'zh_CN': '程序已中断:', 'zh_TW': '程式已中止：'},
'ERR_MAXRECURSION':{'en_US': 'maximum recursion depth (%d) exceeded.', 'af': 'maksimum rekursie diepte (%d) oorskry.', 'am': 'ከፍተኛውን መደጋገሚያ መጠን (%d) አልፏል', 'ar': 'تجاوزتُ الحد الأقصى للعمق التكراري (%d)', 'as': 'সৰ্বাধিক ৰিকাৰ্চন গভিৰতা (%d) অতিক্ৰম হৈছে।', 'ast': 'fondura máxima recursiva (%d) perpasada.', 'be': 'перавышана максімальная глыбіня рэкурсіі (%d).', 'bg': 'надхвърлена е максималната дълбочина на рекурсия (%d).', 'bn_IN': 'সর্বাধিক রিকারসিয়ন ডেপথ (%d) ছাড়িয়ে গেছে।', 'br': "aet eo dreist an donder (%d) askizañ uc'hek .", 'bs': 'maksimalna dubina rekurzija (%d) premašena.', 'ca': "s'ha superat la profunditat màxima de recursivitat (%d).", 'ca_valencia': "s'ha superat la profunditat màxima de recursivitat (%d).", 'cy': "tu hwnt i'r uchafswm dychweliad dyfnder (%d).", 'cs': 'překročena maximální hloubka rekurze (%d).', 'da': 'maksimale gennemløb (%d) blev overskredet.', 'de': 'Maximale Rekursionstiefe (%d) erreicht.', 'dsb': 'Maksimalna rekursijowa dłymokosć (%d) pśekšocona.', 'el': 'το μέγιστο βάθος αναδρομής (%d) ξεπεράστηκε.', 'eo': 'superis la maksimuman rekuran profundon (%d).', 'es': 'se ha superado la profundidad máxima de recursividad (%d).', 'et': 'ületati suurim rekursioonisügavus (%d).', 'eu': 'gehieneko errekurtsio-sakonera (%d) gainditu da.', 'fi': 'suurin sallittu rekursion syvyys (%d) on saavutettu.', 'fr': 'profondeur (%d) de récursion maximum dépassée.', 'fy': 'maksimum fan rekursiedjipte (%d) oer gien.', 'ga': 'sáraíodh an uasdoimhneacht athchúrsála (%d).', 'gd': 'barrachd ath-chùrsaidh na tha ceadaichte (%d).', 'gl': 'máxima profundidade recursiva (%d) sobrepasada.', 'gu': 'મહત્તમ રિકર્ઝન ઊંડાઈ (%d) ઓળંગાઈ.', 'he': 'הגעת לעומק הנסיגה/רקורסיה (%d) המרבי.', 'hi': 'अधिकतम रिकर्सन गहराई (%d) बढ़ गया.', 'hr': 'premašena je maksimalna dubina rekurzije (%d).', 'hsb': 'Maksimalna rekursijna hłubokosć (%d) překročena.', 'hu': 'Elérve az újrahívási korlát (%d).', 'id': 'kedalaman rekursi maksimum (%d) terlampaui.', 'is': 'hámarki endurkvæmrar dýptar (%d) náð.', 'it': 'profondità ricorsiva massima (%d) superata.', 'ja': '再帰の深さが最大値(%d)を越えました。', 'kab': 'telqey (%d) n usniles tafellayt tɛedda.', 'kk': 'рекурсияның максималды тереңдігінен (%d) асып кеттік.', 'km': 'ជម្រៅ\u200bកើត\u200bឡើង\u200b\u200bដដែល\u200bអតិបរមា (%d) បាន\u200bលើស។', 'kn': 'ಗರಿಷ್ಟ ಪುನರಾವರ್ತನಾ ಆಳವು (%d) ಮೀರಿದೆ.', 'ko': '최대 재귀 수준(%d)을 초과하였습니다.', 'lo': 'ຄວາມເລີກສູງສຸດຂອງການທັບຊ້ອນ (%d) ເກີນ.', 'lt': 'viršytas didžiausias rekursijos lygis (%d).', 'lv': 'pārsniegts maksimālais rekursijas dziļums (%d).', 'ml': 'ഏറ്റവും കൂടിയ റിക്കര്\u200dഷന്\u200d വ്യാപ്തി (%d) വര്\u200dദ്ധിച്ചിരിയ്ക്കുന്നു.', 'mn': 'давталтын дээд хэмжээ (%d) хэтэрсэн байна.', 'mr': 'मॅक्सिमम रिकर्शन डेप्थ (%d) वाढले.', 'nb': 'maksimum rekursjonsdypde (%d) overskredet.', 'nl': 'maximum van recursiediepte (%d) overschreden.', 'nn': 'maksimum rekursjonsdjupn (%d) er overskride.', 'oc': 'prigondor (%d) de recursion maximum despassat.', 'or': 'ସର୍ବାଧିକ ପୁନଃପୌନିକ ଘଭୀରତା (%d) ଅତିକ୍ରମ କରିଛି।', 'pl': 'przekroczono maksymalną głębokość (%d) rekursji.', 'pt_BR': 'profundidade máxima de recursão (%d) excedida.', 'pt': 'profundidade máxima (%d) excedida', 'ro': 'Numărul maxim de recursii (%d) depășit.', 'ru': 'превышена максимальная глубина рекурсии (%d).', 'sid': 'jawiidi wirro higate linxe (%d) roortino.', 'sk': 'bola prekročená maximálna hĺbka rekurzie (%d).', 'sl': 'največja globina rekurzije (%d) presežena.', 'sq': 'thellësia maksimale e rekursionit (%d) u tejkalua.', 'sr_Latn': 'Prekoračena je maksimalna dubina rekurzije(%d).', 'sr': 'Прекорачена је максимална дубина рекурзије(%d).', 'sv': 'maximalt rekursionsdjup (%d) har överskridits.', 'szl': 'Maksymalny głymbokość (%d) rekursyje była przekroczōno.', 'ta': 'அதிகபட்ச மீள் நிகழ்வு அளவு (%d) மீறப்பட்டது.', 'te': 'గరిష్ట రికర్షన్ డెప్త్ (%d) మించెను.', 'tr': 'en çok yineleme derinliği (%d) aşıldı.', 'ug': 'ئەڭ يۇقىرى قايتىلاش چوڭقۇرلۇقى (%d) دىن ئېشىپ كەتتى.', 'uk': 'перевищено найбільшу глибину рекурсії (%d).', 'vec': 'suparà ła profondità recorsiva màsima (%d).', 'zh_CN': '已超出最大递归深度 (%d)。', 'zh_TW': '已超出最大遞迴深度 (%d)。'},
'ERR_MEMORY':{'en_US': 'not enough memory.', 'af': 'Onvoldoende geheue.', 'am': 'በቂ memory የለም', 'ar': 'لا ذاكرة كافية.', 'as': 'পৰ্যাপ্ত মেমৰি নাই।', 'ast': 'nun hai memoria bastante.', 'be': 'недастаткова памяці.', 'bg': 'недостатъчна памет.', 'bn_IN': 'অপ্রতুল মেমরি।', 'br': 'memor re skort.', 'bs': 'nema dovoljnomemorije.', 'ca': 'no hi ha prou memòria.', 'ca_valencia': 'no hi ha prou memòria.', 'ckb': 'بیرگەی پێویست نیە.', 'cy': 'dim digon o gof.', 'cs': 'nedostatek paměti.', 'da': 'ikke nok hukommelse', 'de': 'Nicht genügend Arbeitsspeicher.', 'dsb': 'nic dosć składowaka.', 'el': 'ανεπαρκής μνήμη.', 'eo': 'nesufiĉa memoro.', 'es': 'no hay memoria suficiente.', 'et': 'pole piisavalt mälu.', 'eu': 'nahiko memoriarik ez.', 'fi': 'muisti ei riitä.', 'fr': 'mémoire insuffisante.', 'fy': 'net genôch ûnthâld.', 'ga': 'cuimhne ídithe.', 'gd': 'chan eil cuimhne gu leòr ann.', 'gl': 'non hai memoria suficiente.', 'gu': 'પૂરતી મેમરી નથી.', 'he': 'אין די זכרון.', 'hi': 'स्मृति प्रर्याप्त नहीं.', 'hr': 'nema dovoljno memorije.', 'hsb': 'njeje dosć składa.', 'hu': 'Nincs elég memória.', 'id': 'Apakah Anda ingin menjalankan dokumen teks ini?', 'is': 'ekki nægt minni.', 'it': 'memoria insufficiente.', 'ja': 'メモリーが足りません。', 'kab': 'Txuṣ tkatut.', 'ka': 'არ არის საკმარისი მეხსიერება.', 'kk': 'жады жеткіліксіз.', 'km': 'អង្គ\u200bចងចាំ\u200bមិន\u200bគ្រប់គ្រាន់\xa0។', 'kn': 'ಸಾಕಷ್ಟು ಸ್ಮೃತಿ ಇಲ್ಲ.', 'ko': '메모리가 부족합니다.', 'lo': 'ໜວ່ຍຄວາມຈຳບໍ່ພຽງພໍ.', 'lt': 'nepakanka atminties.', 'lv': 'nepietiek atmiņas.', 'ml': 'ആവശ്യമായ മെമ്മറി ലഭ്യമല്ല.', 'mn': 'санах ой хүрэлцэхгүй байна.', 'mr': 'पुरेशी मेमरि नाही.', 'my': 'မှတ်ဉာဏ်မလုံလောက်ပါ။', 'nb': 'ikke nok minne.', 'ne': 'पर्याप्त स्मृति छैन ।', 'nl': 'onvoldoende geheugen.', 'nn': 'det ikkje er nok minne.', 'oc': 'memòria insufisenta.', 'or': 'ଯଥେଷ୍ଟ ସ୍ମୃତି ସ୍ଥାନ ନାହିଁ।', 'pa_IN': 'ਲੋੜੀਂਦੀ ਮੈਮੋਰੀ ਨਹੀਂ ਹੈ', 'pl': 'za mało pamięci.', 'pt_BR': 'memória insuficiente.', 'pt': 'memória insuficiente', 'ro': 'Memorie insuficientă.', 'ru': 'недостаточно памяти.', 'sid': 'kkitinnokki qaaggo.', 'si': 'මතකය ප්\u200dරමාණවත් නැත.', 'sk': 'nedostatok pamäte.', 'sl': 'Ni dovolj pomnilnika.', 'sq': 'memorie të pamjaftueshme.', 'sr_Latn': 'Nema dovoljno memorije.', 'sr': 'Нема довољно меморије.', 'sv': 'otillräckligt minne.', 'szl': 'za mało pamiyńci.', 'ta': 'நினைவகம் போதவில்லை.', 'te': 'సరిపోవునంత మెమొరీ లేదు.', 'tr': 'yeterli bellek yok.', 'ug': 'يېتەرلىك ئەسلەك يوق.', 'uk': "недостатньо пам'яті.", 'vec': 'Ła memoria no ła basta mìa.', 'vi': 'Không đủ bộ nhớ.', 'zh_CN': '内存不足。', 'zh_TW': '記憶體不足。'},
'ERR_NOTAPROGRAM':{'en_US': 'Do you want to run this text document?', 'af': 'Wil u die teksdokument uitvoer?', 'am': 'ይህን የጽሁፍ ሰነድ ማስኬድ ይፈልጋሉ?', 'ar': 'أتريد تشغيل هذا المستند النصّيّ؟', 'as': 'আপুনি এই লিখনী দস্তাবেজ চলাব বিচাৰে নে?', 'ast': '¿Quier executar esti documentu de testu?', 'be': 'Выканаць гэты тэкставы дакумент?', 'bg': 'Желаете ли да се изпълни този текстов документ?', 'bn_IN': 'অাপনি কি এই পাঠ্য নথি চালাতে চান?', 'br': "Ha fellout a ra deoc'h erounit an teul mod testenn-mañ ?", 'bs': 'Da li želite pokrenuti ovaj tekstualni dokument?', 'ca': 'Voleu executar aquest document de text?', 'ca_valencia': 'Voleu executar aquest document de text?', 'ckb': 'دەتەوێت دەقەکانی ناو ئەم بەڵگەنامەیە کارپێبکەیت؟', 'cy': 'Hoffech chi redeg y ddogfen testun hon?', 'cs': 'Přejete si spustit tento textový dokument?', 'da': 'Ønsker du at køre dette tekstdokument?', 'de': 'Möchten Sie dieses Textdokument ausführen?', 'dsb': 'Cośo toś ten tekstowy dokument wuwjasć?', 'el': 'Θέλετε να τρέξετε αυτό το έγγραφο κειμένου;', 'eo': 'Ĉu vi volas ruli ĉi tiun dokumenton?', 'es': '¿Quiere ejecutar este documento de texto?', 'et': 'Kas soovid seda tekstidokumenti käivitada?', 'eu': 'Testu-dokumentu hau exekutatu nahi duzu?', 'fi': 'Haluatko suorittaa tämän tekstiasiakirjan?', 'fr': 'Souhaitez-vous exécuter ce document texte ?', 'fy': 'Wolle jo it tekstdokumint útfiere?', 'ga': 'An bhfuil fonn ort an cháipéis téacs a chur ar siúl?', 'gd': 'A bheil thu airson an sgrìobhainn teacsa seo a ruith?', 'gl': 'Quere executar este documento de texto?', 'gug': "¿Remomba'apo sépa ko documento moñe'ẽrãgui?", 'gu': 'શું તમે આ લખાણ દસ્તાવેજને ચલાવવા માંગો છો?', 'he': 'האם ברצונך להריץ מסמך טקסט זה?', 'hi': 'क्या आप इस पाठ दस्तावेज़ को चलाना चाहते हैं?', 'hr': 'Želite li pokrenuti ovaj tekstualni dokument?', 'hsb': 'Chceće tutón tekstowy dokument wuwjesć?', 'hu': 'Szeretné futtatni ezt a szöveges dokumentumot?', 'id': 'Apakah Anda ingin menjalankan dokumen teks ini?', 'is': 'Viltu keyra þetta textaskjal?', 'it': 'Vuoi eseguire questo documento di testo?', 'ja': 'この文書ドキュメントをプログラムとして実行しますか？', 'kab': 'Tebɣiḍ ad tselkemeḍ isemli-agi aḍris?', 'kk': 'Бұл мәтіндік құжатты орындау керек пе?', 'km': 'តើ\u200bអ្នក\u200bចង់\u200bដំណើរការ\u200bឯកសារ\u200bនេះ?', 'kn': 'ನೀವು ಈ ಪಠ್ಯ ದಸ್ತಾವೇಜನ್ನು ಚಲಾಯಿಸಲು ಬಯಸುವಿರಾ?', 'ko': '이 텍스트 문서에서 실행하시겠습니까?', 'lo': 'ທ່ານຕ້ອງການດໍາເນີນການເອີ້ນໃຊ້ເອກະສານຂໍ້ຄວາມນີ້ ຫຼື ບໍ່?', 'lt': 'Ar norite vykdyti šį teksto dokumentą?', 'lv': 'Vai vēlaties izpildīt šo teksta dokumentu?', 'ml': 'നിങ്ങള്\u200dക്കു് ഈ രേഖ നടപ്പിലാക്കണമോ?', 'mn': 'Та энэ текст документийг ажиллуулахыг хүсч байна уу?', 'mr': 'तुम्हाला हे मजकूर दस्तऐवज चालवायचे?', 'nb': 'Vil du kjøre dette tekstdokumentet?', 'nl': 'Wilt u dit tekstdocument uitvoeren?', 'nn': 'Vil du køyra dette tekstdokumentet?', 'oc': 'Volètz executar aqueste document tèxte ?', 'or': 'ଆପଣ ଏହି ପାଠ୍ଯ ଦଲିଲ ଚଲାଇବାକୁ ଚାହୁଁଛନ୍ତି କି?', 'pl': 'Czy na pewno chcesz uruchomić ten dokument tekstowy?', 'pt_BR': 'Deseja executar este documento de texto?', 'pt': 'Deseja executar este documento de texto?', 'ro': 'Doriți să rulați acest document text?', 'ru': 'Выполнить этот текстовый документ?', 'sid': 'Tenne borrote bortaje harisa hasiratto?', 'sk': 'Spustiť tento textový dokument?', 'sl': 'Ali želite zagnati ta besedilni dokument?', 'sq': 'A doni ta ekzekutoni këtë dokument tekst?', 'sr_Latn': 'Želite li da izvršite naredbe iz dokumenta?', 'sr': 'Желите ли да извршите наредбе из документа?', 'sv': 'Vill du köra detta textdokument?', 'szl': 'Na isto chcesz ôtworzić tyn dokumynt tekstowy?', 'ta': 'இந்த உரை ஆவணத்தை இயக்க வேண்டுமா?', 'te': 'మీరు యీ పాఠం పత్రమును నడుపాలి అనుకొనుచున్నారా?', 'tr': 'Bu metin belgesini çalıştırmak istiyor musunuz?', 'ug': 'بۇ تېكىست پۈتۈكنى ئىجرا قىلامسىز؟', 'uk': 'Виконати цей текстовий документ?', 'vec': "Vuto far partir 'sto documento de testo?", 'zh_CN': '是否希望运行该文本文档?', 'zh_TW': '您是否要執行這份文字文件？'},
}
