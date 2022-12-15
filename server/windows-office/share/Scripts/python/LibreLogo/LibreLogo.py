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
                            __lng__[lng][i] = __lng_fallback__[i][lng[:2]]
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
                exec(self.code)
            if _.origcursor[0] and _.origcursor[1]:
                __dispatcher__(".uno:Escape")
                try:
                    _.doc.CurrentController.getViewCursor().gotoRange(_.origcursor[0], False)
                except:
                    _.doc.CurrentController.getViewCursor().gotoRange(_.origcursor[0].getStart(), False)
        except Exception as e:
            try:
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

def stop(arg=None):
    global __halt__
    with __lock__:
        __halt__ = True
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

def text(shape, st):
    if shape:
        shape.setString(__string__(st, _.decimal))
        c = shape.createTextCursor()
        c.gotoStart(False)
        c.gotoEnd(True)
        c.CharColor, c.CharTransparence = __splitcolor__(_.textcolor)
        c.CharHeight = _.fontheight
        c.CharWeight = __fontweight__(_.fontweight)
        c.CharPosture = __fontstyle__(_.fontstyle)
        c.CharFontName = _.fontfamily

def sleep(t):
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
        if c[0:1] == '~':
            c = __componentcolor__(__colors__[_.lng][c[1:].lower()])
            for i in range(3):
                c[i] = max(min(c[i] + int(random.random() * 64) - 32, 255), 0)
            return __color__(c)
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
'ORANGE':{'lt': 'oranžinė', 'sid': 'burtukaane', 'fi': 'oranssi', 'ro': 'orange|portocaliu', 'lv': 'oranžs', 'kn': 'ವ್ಯಾಪ್ತಿ', 'nn': 'oransje|orange', 'tr': 'turuncu', 'es': 'naranja', 'el': 'πορτοκαλί|orange', 'hr': 'narančasta', 'cs': 'oranžová', 'sr_Latn': 'narandžasta', 'he': 'כתום', 'nl': 'oranje', 'hu': 'narancssárga|narancs', 'hi': 'दायरा', 'ml': 'ഓറഞ്ച്', 'gu': 'નારંગી', 'ko': '오렌지', 'zh_TW': '橘黃|橙黃|橙|橘|orange', 'mr': 'नारंगी', 'ru': 'оранжевый', 'sl': 'oranžna', 'bn_IN': 'পরিসর', 'am': 'ብርቱካን', 'et': 'oranž|apelsinikarva', 'uk': 'оранжевий', 'pt_BR': 'laranja', 'kk': 'қызғылт-сары', 'te': 'ఆరెంజ్', 'br': 'orañjez', 'is': 'appelsínugult', 'km': '\u200bទឹក\u200bក្រូច', 'bs': 'narandžasta', 'eu': 'laranja', 'cy': 'oren', 'pa_IN': 'ਰੇਜ਼', 'ast': 'naranxa', 'gug': 'narã', 'vi': 'phạm vi', 'as': 'সুমথীৰা', 'gd': 'orains', 'or': 'କମଳା', 'ja': 'オレンジ|オレンジ色|orange', 'hsb': 'oranžowy', 'nb': 'oransje|orange', 'be': 'аранжавы', 'oc': 'irange', 'gl': 'laranxa', 'ar': 'برتقالي', 'en_US': 'orange', 'sk': 'oblasť', 'sr': 'наранџаста', 'zh_CN': '橙色|橙|orange', 'eo': 'oranĝa', 'ta': 'ஆரஞ்சு', 'ca_valencia': 'taronja', 'ne': 'दायरा', 'ca': 'taronja', 'si': 'පරාසය', 'my': 'ကန့်သတ်နယ်ပယ်', 'ka': 'ფორთოხლისფერი'},
'POINT':{'lt': 'skritulys', 'th': 'จุด', 'sid': 'bixxille', 'fi': 'piste', 'ro': 'point|punct', 'lv': 'punkts', 'kn': 'ಬಿಂದುಗಳು', 'hsb': 'dypk', 'tr': 'nokta', 'es': 'punto', 'el': 'σημείο|point', 'hr': 'točka', 'cs': 'bod|puntík', 'de': 'punkt', 'mn': 'цэг', 'he': 'נקודה', 'nl': 'punt', 'hu': 'pont', 'hi': 'बिंदु', 'ml': 'പോയിന്റ്', 'gu': 'બિંદુ', 'my': 'အမှတ်', 'ko': '점', 'zh_TW': '點|point', 'mr': 'बिंदू', 'ru': 'точка', 'sl': 'točka', 'bn_IN': 'পয়েন্ট', 'am': 'ነጥቦች', 'et': 'punkt', 'uk': 'точка', 'pt_BR': 'ponto', 'kk': 'нүкте', 'te': 'బిందువు', 'br': 'poent', 'is': 'punktur', 'km': 'ចំណុច', 'bs': 'tačka', 'eu': 'puntua', 'cy': 'pwynt', 'pa_IN': 'ਬਿੰਦੂ', 'ast': 'puntu', 'gug': 'kyta', 'vi': 'điểm', 'as': 'বিন্দু', 'gd': 'puing', 'or': 'ବିନ୍ଦୁ', 'ja': '点|point', 'nn': 'punkt|point', 'nb': 'punkt|point', 'be': 'пункт', 'sq': 'pikë', 'oc': 'punt', 'gl': 'punto', 'ar': 'نقطة', 'en_US': 'point', 'sk': 'bod', 'zh_CN': '点|point', 'eo': 'punkto', 'ta': 'புள்ளி', 'ca_valencia': 'punt', 'ne': 'प्वाइन्ट', 'ca': 'punt', 'si': 'ලක්ෂ්\u200dය', 'ug': 'نۇقتا', 'ka': 'წერტილი'},
'LEFTSTRING':{'lt': '„|“|‘', 'hsb': '„|‚|"|\'', 'hu': '„', 'fi': '"|\'|”', 'en_US': '“|‘', 'sk': '„|"', 'nn': '“|‘|«', 'es': '“|‘|«', 'el': '“|‘|"|\'', 'et': '„', 'zh_TW': '「|『|“|‘', 'cs': '„|"', 'de': '„|‚|"|\'', 'zh_CN': '「|『|“|‘'},
'ABS':{'lt': 'ilgis|abs|modulis', 'sid': 'abse', 'ka': 'ტაბულაციები', 'fi': 'itseisarvo', 'br': 'dizave', 'pa_IN': 'ਟੈਬ', 'kn': 'ಟ್ಯಾಬ್\u200cಗಳು', 'hsb': 'absolutny', 'bn_IN': 'ট্যাব', 'el': 'απόλυτο', 'lv': 'modulis', 'tr': 'Sekmeler', 'vi': 'Tab', 'cs': 'absolutní', 'de': 'betrag', 'he': 'ערך מוחלט', 'hu': 'abszolútérték|absz?', 'hi': 'टैब्स', 'ar': 'مطلق', 'en_US': 'abs', 'te': 'టాబ్ లు', 'ko': '탭', 'ne': 'ट्याबहरू', 'zh_TW': '絕對值|abs', 'mr': 'ॲब्स', 'si': 'පටිති', 'zh_CN': '绝对值|abs', 'ja': '絶対値|abs', 'my': 'အကွက်ခုန်များ', 'am': 'ፍጹም', 'et': 'absoluutväärtus|abs'},
'RESUB':{'lt': 'keisk', 'sid': 'cinaancho', 'pt_BR': 'subst', 'fi': 'korvaa', 'br': 'is', 'uk': 'зам', 'lv': 'aizvietot', 'kn': 'ಉಪ', 'nn': 'byt|byt ut|sub', 'ja': '文字のおきかえ|置換|sub', 'el': 'αντικατάσταση', 'cs': 'nahraď', 'de': 'ersetzt', 'nl': 'onderlijn', 'or': 'ଉପ', 'sl': 'zam', 'hsb': 'naruna', 'eu': 'azpi', 'nb': 'bytt|bytt ut|sub', 'hu': 'cserél', 'ar': 'استبدل', 'gu': 'ઉપ', 'en_US': 'sub', 'sk': 'nahraď', 'eo': 'anstataŭu|anst', 'zh_TW': '替換|sub', 'mr': 'सब', 'he': 'שגרה', 'zh_CN': '替换|sub', 'am': 'ንዑስ', 'et': 'asenda'},
'FILLCOLOR':{'lt': 'spalvinimo.spalva|ssp', 'sid': 'kuulawonshi|kuulawonshi|kw', 'fi': 'täyttöväri|tv', 'ro': 'fillcolor|fillcolour|fc|culoareumplere', 'lv': 'pildījuma_krāsa|pk', 'kn': 'ಬಣ್ಣತುಂಬಿಸು|ಬಣ್ಣತುಂಬಿಸು|fc', 'hsb': 'pjelnjacabarba|pb', 'tr': 'renkdoldur|renkdoldur|rd', 'es': 'color.relleno|cr|fc', 'el': 'χρώμαγεμίσματος|χε|fillcolor|fillcolour|fc', 'hr': 'boja punjenja|boja punjenja|bp', 'cs': 'barvavýplně|bv', 'de': 'füllfarbe|ff', 'he': 'צבעמילוי|צמ', 'nl': 'opvulkleur|ok', 'hu': 'töltőszín|töltőszín!|tlsz!?', 'ko': '색상채우기|색상채우기|fc', 'zh_TW': '填入顏色|填入色彩|填色|fillcolor|fillcolour|fc', 'mr': 'फिलकलर|फिलकलर|fc', 'ru': 'цвет_заливки|цз', 'sl': 'barvapolnila|polnilnabarva|bp', 'am': 'ቀለም መሙያ|ቀለም መሙያ|ቀ.መ', 'et': 'täitevärv|tv', 'uk': 'колір_заповнення|кз', 'pt_BR': 'mudarCorDaPintura|mCorPi|mudecp', 'kk': 'толтыру_түсі|тт', 'km': 'ពណ៌\u200bបំពេញ|fillcolour|fc', 'nb': 'fyllfarge|ff|fillcolor', 'bs': 'popuniboju|popuniboju|fc', 'eu': 'betetzekolorea|bk', 'ast': 'colorrellenu|cr', 'gug': "sa'y.henyhe|ch", 'oc': 'coloremplenatge|coloremplenatge|cr', 'or': 'ରଙ୍ଗପୁରଣ|ରଙ୍ଗପୁରଣ|fc', 'ja': '塗りつぶしの色|fillcolor|fc', 'nn': 'fyllfarge|ff|fillcolor', 'fr': 'couleurremplissage|cremplissage|cr', 'gl': 'cambiarcor|cambiodecor|cc', 'ar': 'ملأ_لون', 'en_US': 'fillcolor|fillcolour|fc', 'sk': 'farbavýplne|fv', 'eo': 'pleniga_koloro|plenkoloro|plk', 'ca_valencia': 'color.emplenament|ce', 'ca': 'color.emplenament|ce', 'zh_CN': '填充颜色|填充色|填色|fillcolor|fillcolour|fc'},
'SIN':{'sid': 'sayine', 'pt_BR': 'sen', 'gl': 'sen', 'fi': 'sini', 'ar': 'جا', 'en_US': 'sin', 'sat': 'SIN', 'is': 'sín', 'kok': 'SIN', 'sa_IN': 'SIN', 'es': 'sen', 'el': 'ημίτονο|sin', 'mr': 'साइन', 'ast': 'sen', 'dgo': 'SIN', 'gug': 'sen', 'zh_TW': '正弦|sin', 'zh_CN': '正弦|sin', 'am': 'ሳይን', 'he': 'סינוס'},
'BEVEL':{'lt': 'nuožulnus', 'sid': 'beevele', 'fi': 'viisto', 'ro': 'bevel|teșit', 'lv': 'nošķelts', 'kn': 'ಸ್ತರ', 'hsb': 'nakósny', 'tr': 'eğim', 'es': 'bisel', 'el': 'λοξό|bevel', 'hr': 'nagib', 'cs': 'šikmé', 'de': 'schräg', 'he': 'קטום', 'nl': 'afschuinen', 'hu': 'tompa', 'hi': 'स्तर', 'ml': 'തലം', 'gu': 'સ્તર', 'my': 'အဆင့်', 'ko': '수준', 'zh_TW': '平角|bevel', 'mr': 'बेवेल', 'ru': 'скос', 'sl': 'vbočeno', 'bn_IN': 'স্তর', 'am': 'ስላሽ', 'et': 'faasitud', 'uk': 'скіс', 'pt_BR': 'cortado', 'kk': 'көлбеу', 'te': 'స్థాయి', 'br': 'beskell', 'is': 'flái', 'km': 'ជ្រុង\u200bទេរ', 'nb': 'skråkant|bevel', 'bs': 'kosina', 'eu': 'alakatua', 'cy': 'befel', 'pa_IN': 'ਲੈਵਲ', 'ast': 'moldura', 'gug': 'bisel', 'vi': 'Cấp', 'or': 'ସ୍ତର', 'gd': 'beibheal', 'ja': '角を落とす|bevel', 'nn': 'skråkant|bevel', 'fr': 'biseau', 'be': 'скос', 'oc': 'bisèl', 'gl': 'bisel', 'ar': 'مشطوف', 'ug': 'يانتۇ يۈز', 'sk': 'šikmé', 'zh_CN': '平角|bevel', 'eo': 'bivela', 'ta': 'பெவல்', 'ca_valencia': 'bisell', 'ne': 'स्तर', 'ca': 'bisell', 'si': 'මට්ටම', 'en_US': 'bevel', 'ka': 'დონე'},
'OUTPUT':{'lt': 'grąžink|išvesk', 'sid': 'guma', 'fi': 'kirjoita', 'ro': 'output|ieșire', 'lv': 'izvade', 'kn': 'ಔಟ್\u200cಪುಟ್', 'hsb': 'wudaće', 'tr': 'çıktı', 'es': 'salida', 'el': 'έξοδος|output', 'hr': 'rezultat', 'cs': 'výsledek', 'de': 'rückgabe', 'he': 'פלט', 'nl': 'output|uitvoer', 'hu': 'eredmény', 'hi': 'आउटपुट', 'ml': 'ഔട്ട്പുട്ട്', 'gu': 'આઉટપુટ', 'ko': '출력', 'zh_TW': '輸出|output', 'mr': 'आउटपुट', 'ru': 'вывод', 'sl': 'izhod', 'bn_IN': 'আউটপুট', 'am': 'ውጤት', 'et': 'väljund', 'uk': 'вивести', 'pt_BR': 'retornar|retorne|devolver|devolva|envie', 'kk': 'шығыс', 'te': 'అవుట్పుట్', 'br': "ec'hankad", 'is': 'frálag', 'km': 'លទ្ធផល', 'nb': 'utdata|output', 'bs': 'izlaz', 'eu': 'Irteera', 'cy': 'allbwn', 'pa_IN': 'ਆਉਟਪੁੱਟ', 'ast': 'salida', 'gug': 'ñeseha', 'vi': 'Đầu ra', 'as': 'আউটপুট', 'or': 'ଫଳାଫଳ', 'ja': '値を返す|output', 'nn': 'utdata|output', 'fr': 'sortie', 'oc': 'sortida', 'gl': 'saída', 'ar': 'أخرِج', 'en_US': 'output', 'sk': 'Výstup', 'zh_CN': '输出|output', 'eo': 'eligaĵo', 'ta': 'வெளியீடு', 'ca_valencia': 'eixida', 'ne': 'निर्गत', 'ca': 'sortida', 'si': 'ප්\u200dරතිදානය', 'my': 'အထုတ်', 'ka': 'გამონატანი'},
'TUPLE':{'sid': 'tupile', 'ja': '変更できないリスト|タプル|tuple', 'pt_BR': 'tupla', 'kk': 'кортеж', 'fi': 'pari', 'br': 'kemalenn', 'eo': 'opo', 'ro': 'tuple|fix', 'uk': 'кортеж', 'lv': 'kortežs', 'kn': 'ಟಪಲ್', 'hsb': 'tupl', 'tr': 'tüp', 'es': 'tupla', 'be': 'картэж', 'el': 'πλειάδα|tuple', 'ast': 'tupla', 'gug': 'tupla', 'cs': 'ntice', 'de': 'tupel', 'nl': 'tuple|tupel', 'bs': 'pobrojane', 'he': 'סדרהסדורה', 'eu': 'tuploa', 'hu': 'fix', 'gl': 'tupla', 'ca': 'tupla', 'gu': 'ટપલ', 'en_US': 'tuple', 'sk': 'ntica', 'ko': '튜플', 'or': 'ଟ୍ୟୁପଲ', 'ca_valencia': 'tupla', 'zh_TW': '元組|tuple', 'et': 'ennik|korteež', 'ru': 'кортеж', 'sl': 'par', 'zh_CN': '元组|tuple', 'am': 'ቱፕል', 'mr': 'टपल'},
'ANY':{'lt': 'bet.kas', 'th': 'ใดๆ', 'sid': 'ayee', 'fi': 'jokin', 'ro': 'any|oricare', 'lv': 'jebkurš', 'kn': 'ಯಾವುದಾದರೂ', 'hsb': 'někajki', 'tr': 'herhangi', 'es': 'cualquiera', 'vec': 'calsiasi', 'el': 'όλα|any', 'hr': 'bilo koja', 'cs': 'libovolně|lib', 'de': 'beliebig|bel', 'mn': 'хамаагүй|хам', 'he': 'כלשהו', 'nl': 'elke', 'hu': 'tetszőleges|tetsz', 'hi': 'कोई भी', 'ml': 'ഏതെങ്കിലും', 'gu': 'કોઇપણ', 'ko': '모두', 'sd': 'ڪابە', 'zh_TW': '任一|any', 'mr': 'कोणतेहि', 'sat': 'जाहां गे', 'ru': 'любой', 'sl': 'poljubno', 'sa_IN': 'कांह तॊ', 'bn_IN': 'যেকোনো', 'am': 'ማንኛውም', 'et': 'mistahes', 'uk': 'довільний', 'pt_BR': 'qualquer', 'kk': 'кез-келген', 'te': 'ఏదైనా', 'km': 'ណាមួយ', 'nb': 'alle|any', 'kok': 'कोणूयKoncheim', 'bs': 'bilo koji', 'eu': 'edozein', 'cy': 'unrhyw un', 'pa_IN': 'ਕੋਈ ਵੀ', 'ast': 'cualquier', 'gug': 'mavave', 'as': 'যিকোনো', 'gd': 'gin', 'or': 'ଯେକୌଣସି', 'ja': 'なんでも|どこでも|乱数|any', 'nn': 'alle|any', 'fr': 'tout', 'gl': 'calquera', 'ar': 'أي', 'en_US': 'any', 'sk': 'ľubovoľný|?', 'eo': 'ajna', 'ca_valencia': 'qualsevol', 'ca': 'qualsevol', 'dgo': 'कोई बी', 'zh_CN': '任意|any'},
'GOLD':{'lt': 'auksinė', 'th': 'ทอง', 'sid': 'clka', 'fi': 'kulta', 'ro': 'gold|auriu', 'lv': 'zelta', 'kn': 'ಬೋಲ್ಡ್\u200d', 'nn': 'gull|gold', 'tr': 'altın rengi', 'es': 'oro', 'el': 'χρυσαφί|gold', 'hr': 'zlatna', 'cs': 'zlatá', 'sr_Latn': 'zlatna', 'he': 'זהב', 'nl': 'goud', 'hu': 'aranysárga|arany', 'hi': 'मोटा', 'ml': 'സ്വര്\u200dണ്ണം', 'gu': 'સોનુ', 'ko': '금색', 'zh_TW': '金黃|金|gold', 'mr': 'सोनेरी', 'ru': 'золотой', 'sl': 'zlata', 'bn_IN': 'গাঢ়', 'am': 'ወርቅማ', 'et': 'kuldne', 'uk': 'золотий', 'pt_BR': 'ouro', 'kk': 'алтын', 'te': 'బంగారం', 'br': 'aour', 'is': 'gull', 'km': 'មាស', 'nb': 'gull|gold', 'bs': 'zlatna', 'eu': 'urrea', 'cy': 'aur', 'pa_IN': 'ਗੂੜ੍ਹੇ', 'ast': 'doráu', 'gug': 'oro', 'vi': 'Đậm', 'as': 'সোন', 'gd': 'òir', 'or': 'ସ୍ୱର୍ଣ୍ଣ', 'ja': '金|金色|gold', 'hsb': 'złoty', 'fr': 'or', 'be': 'залаты', 'oc': 'aur', 'gl': 'ouro', 'ar': 'ذهبي', 'en_US': 'gold', 'sk': 'Tučné', 'sr': 'златна', 'zh_CN': '金色|金|gold', 'eo': 'ora', 'ta': 'தங்கம்', 'ca_valencia': 'or|daurat', 'ne': 'बाक्लो', 'ca': 'or|daurat', 'si': 'තදකුරු', 'my': 'စာလုံးမဲ', 'ka': 'შეკვრა'},
'NOT':{'lt': 'priešingai', 'sid': "dee'ni", 'fi': 'ei', 'ro': 'not|nu', 'lv': 'nav', 'kn': 'ಇಲ್ಲ', 'hsb': 'nic', 'tr': 'değil', 'es': 'no', 'el': 'όχι|not', 'hr': 'nije', 'cs': 'není', 'de': 'nicht', 'he': 'לא', 'nl': 'niet', 'hu': 'nem', 'hi': 'नहीं', 'gu': 'નથી', 'ko': '없음', 'sd': 'NOT', 'zh_TW': '非|not', 'mr': 'नॉट', 'sat': 'NOT', 'ru': 'не', 'sl': 'ni', 'sa_IN': 'NOT', 'bn_IN': 'নয়', 'am': 'አይደለም', 'et': 'pole|mitte', 'uk': 'не', 'pt_BR': 'não', 'kk': 'емес', 'te': 'కాదు', 'br': 'ket', 'is': 'ekki', 'nb': 'ikke|not', 'kok': 'NOT', 'bs': 'ne', 'eu': 'ez', 'ast': 'non', 'gug': 'no', 'or': 'ନୁହଁ', 'gd': 'chan e', 'ja': '正しくない|否|not', 'nn': 'ikkje|not', 'fr': 'non', 'gl': 'non', 'ar': 'ليس', 'en_US': 'not', 'sk': 'nieje', 'zh_CN': '非|not', 'eo': 'ne', 'ca_valencia': 'no', 'ca': 'no', 'dgo': 'NOT', 'oc': 'non'},
'PENUP':{'lt': 'eisim|es|pakelk.pieštuką|pakelk.trintuką', 'th': 'ปากกาขึ้น|pu', 'sid': 'biireworora|bw', 'fi': 'kynäylös|ky', 'ro': 'penup|pu|stilousus', 'lv': 'pacelt_spalvu|ps', 'kn': 'ಲೇಖನಿಎತ್ತು|pu', 'hsb': 'lećeć|le', 'tr': 'kalemyukarı|ky', 'es': 'sinpluma|subirlapiz|sp|sl', 'el': 'γραφίδαπάνω|γπ|penup|pu', 'hr': 'olovka gore|og', 'cs': 'peronahoru|pn', 'de': 'fliegen', 'he': 'להריםעט|עטלמעלה|הרםעט|לע', 'nl': 'penomhoog|po', 'hu': 'tollatfel|tf', 'ko': '펜을위로|pu', 'zh_TW': '提筆|penup|pu', 'mr': 'पेनअप|pu', 'ru': 'поднять_перо|пп', 'sl': 'perogor|pg', 'am': 'ብዕር ወደ ላይ |pu', 'et': 'pliiats_üles|pü', 'uk': 'підніми_перо|пп', 'pt_BR': 'usarNada|un|useNada', 'kk': 'қаламды_көтеру|қк', 'nb': 'penn opp|po|penup', 'bs': 'pengore|pu', 'eu': 'lumagora|lg', 'ast': 'llapizxubir|lx', 'gug': "bolígrafo'ỹre|bỹ", 'or': 'ପେନଉପରକୁ|pu', 'ja': 'ペンをあげる|penup|pu', 'nn': 'penn opp|po|penup', 'fr': 'levecrayon|lc', 'gl': 'senestilo|se', 'ar': 'ارفع_القلم|ارفع', 'en_US': 'penup|pu', 'sk': 'perohore|ph', 'eo': 'plumofor|pf', 'ca_valencia': 'aixeca.llapis|al', 'ca': 'aixeca.llapis|al', 'zh_CN': '提笔|抬笔|penup|pu'},
'FONTFAMILY':{'lt': 'garnitūras|šriftų.šeima|šš', 'sid': 'borangichumine', 'fi': 'fonttiperhe', 'ro': 'fontfamily|familiefont', 'lv': 'fontu_saime', 'kn': 'ಅಕ್ಷರಶೈಲಿಸಮೂಹ', 'hsb': 'družinapisma|dp', 'es': 'tipo.letra|letra|fuente', 'el': 'οικογένειαγραμματοσειράς|fontfamily', 'hr': 'skupina fontova', 'cs': 'druhpísma', 'de': 'schriftart|scha', 'he': 'משפחתגופנים', 'nl': 'tekstfamilie', 'hu': 'betűcsalád', 'gu': 'ફોન્ટકુટુંબ', 'ko': '글꼴 모음', 'zh_TW': '字型家族|字族|fontfamily', 'mr': 'फाँटफॅमिलि', 'ru': 'семейство_шрифтов', 'sl': 'vrstapisave', 'am': 'የፊደል ቤተሰብ', 'et': 'fondi_perekond', 'uk': 'гарнітура', 'pt_BR': 'mudarTipoDaLetra|mTipLe', 'kk': 'қаріптер_отбасы', 'te': 'ఫాంట్\u200cఫ్యామిలీ', 'br': 'spletad nodrezhoù', 'is': 'leturtegund', 'km': 'ក្រុម\u200bពុម្ពអក្សរ', 'nb': 'skriftfamilie|fontfamily', 'bs': 'fontfamilija', 'eu': 'letrafamilia', 'ast': 'familiafonte', 'tr': 'yazıtipi ailesi', 'or': 'ଅକ୍ଷରରୂପ ପରିବାର', 'gd': "teaghlach a' chruth-chlò", 'ja': '文字の種類|フォントファミリー|fontfamily', 'nn': 'skriftfamilie|fontfamily', 'fr': 'famillepolice', 'be': 'гарнітура', 'gl': 'familia de tipo de letra', 'ar': 'عائلة_خط', 'en_US': 'fontfamily', 'sk': 'druhpísma|dp', 'eo': 'tiparofamilio', 'ta': 'எழுத்துரு குடும்பம்', 'ca_valencia': 'família.lletra|fl', 'ca': 'família.lletra|fl', 'zh_CN': '字体|字体家族|字型|fontfamily'},
'PENJOINT':{'lt': 'pieštuko.sujungimas|linijos.sujungimas|psj', 'sid': 'biiretexaado|xuruuruxaado', 'ja': 'ペンのつなぎ方|角のつなぎ方|penjoint', 'pt_BR': 'mudarCantoDaLinha|mCanLi', 'kk': 'қаламды_біріктіру|сызықтарды_біріктіру', 'fi': 'kynänmuoto', 'eo': 'liniartiko|plumligo', 'ro': 'penjoint|linejoint|colțstilou', 'fr': 'jointurestylo|jointureligne', 'lv': 'spalvas_salaidums|līnijas_salaidums', 'kn': 'ಲೇಖನಿಜೋಡಣೆ|ರೇಖೆಜೋಡಣೆ', 'eu': 'lumajuntura|marrajuntura', 'hr': 'spoj olovke|spoj linije', 'es': 'conjuntopluma|conjuntolínea', 'ca': 'unió.llapis|unió.línia|ul', 'el': 'ένωσηγραφίδας|ένωσηγραμμής|penjoint|linejoint', 'pa_IN': 'ਪੈੱਨ ਜੁਆਇੰਟIਲਾਈਨ ਜੁਆਇੰਟ', 'uk': 'сполучити_перо|сполучити_лінії', 'gug': 'atybolígrafo|atylínea', 'cs': 'napojenípera|napojeníčáry', 'de': 'stiftübergang|linienübergang|sü|lü', 'tr': 'kalembirleşimi|satırbirleşimi', 'nl': 'penverbinding|lijnverbinding', 'bs': 'vezaolovke|vezalinije', 'he': 'מצרףעט|מצרףקו', 'hsb': 'přechodpisaka|přechodlinije|pp|pl', 'nn': 'linjekopling|penjoint', 'nb': 'linjekobling|penjoint', 'hu': 'tollsarok|vonalsarok', 'gl': 'estilounión|uniónliña', 'en_US': 'penjoint|linejoint', 'sk': 'napojeniepera|napojeniečiary|np|nč', 'ko': '펜조인트|선조인트', 'or': 'ପେନସନ୍ଧି|linejoint', 'ca_valencia': 'unió.llapis|unió.línia|ul', 'zh_TW': '筆接點|線接點|線接|penjoint|linejoint', 'mr': 'पेनजॉइंट|लाइनजॉइंट', 'ast': 'llapizxunir|lliniaxunir|lx', 'ru': 'соединить_перо|соединить_линии', 'sl': 'stikperesa|stikčrt', 'zh_CN': '笔接点|线接点|线接|penjoint|linejoint', 'am': 'የብዕር መገናኛ |የመስመር መገናኛ', 'et': 'pliiatsiühendus|jooneühendus'},
'PI':{'sid': 'payi|π', 'be': 'pi|пі|π', 'kk': 'pi|пи|π', 'gl': 'pi|n', 'fi': 'pii|π', 'ar': 'ط|باي|π', 'en_US': 'pi|π', 'uk': 'pi|пі|π', 'ko': '파이|π', 'el': 'πι|pi|π', 'et': 'pii|π', 'zh_TW': 'pi|π|拍', 'ru': 'pi|пи|π', 'ja': '円周率|pi|π', 'mr': 'पाय|π', 'zh_CN': '圆周率|pi|π', 'am': 'ፓይ|π', 'he': 'פאי|פיי'},
'NONE':{'fi': 'eimitään', 'kn': 'ಏನೂ ಇಲ್ಲ', 'xh': 'akukho', 'hr': 'ništa', 'de': 'kein', 'he': 'ללא', 'nl': 'geen', 'hu': 'nincs', 'ml': 'ഒന്നുമില്ല', 'st': 'ha di teng', 'ko': '없음', 'mr': 'काहीही नाही', 'mai': 'किछु नहि', 'am': 'ምንም', 'et': 'puudub', 'kk': 'жоқ', 'te': 'ఏదీ కాదు', 'af': 'geen', 'tg': 'ягон', 'km': 'គ្មាន', 'fr': 'aucun(e)', 'kok': 'कोण ना', 'eu': 'bat ere ez', 'pa_IN': 'ਕੋਈ ਨਹੀਂ', 'gug': 'mavave', 'vi': 'không có', 'lo': 'ບໍ່ມີ', 'gd': 'chan eil gin', 'rw': 'ntacyo', 'hsb': 'žadyn', 'nb': 'ingen|none', 'be': 'няма', 'sq': 'asnjë', 'om': 'homaa', 'ug': 'يوق', 'sk': 'žiadne', 'br': 'tra ebet', 'ta': 'ஏதுமில்லை', 'dgo': 'कोई नेईं', 'en_US': 'none', 'lt': 'nieko', 'th': 'ไม่มี', 'sid': 'dino', 'zu': 'lutho', 'mk': 'Нема', 'ro': 'none|nimic', 'lv': 'nav', 'as': 'কোনো নহয়', 'nn': 'ingen|none', 'es': 'ninguno', 'vec': 'njanca uno', 'el': 'κανένα', 'dz': 'ཅི་མེད།', 'tn': 'sepe', 'cs': 'žádné', 'sl': 'brez', 'hi': 'कोई नहीं', 'gu': 'કંઇ નહિં', 've': 'a huna', 'or': 'କିଛି ନାହିଁ', 'sd': 'ڪجهہ بہ نہ', 'zh_TW': '無|none', 'sat': 'ओका हों बाङजाहानाक् बाङ', 'bo': 'མེད་པ།', 'ru': 'нет', 'nso': 'ga go na selo', 'bn_IN': 'কোনটি না', 'uk': 'немає', 'kmr_Latn': 'ne yek jî', 'pt_BR': 'nenhum', 'bn': 'কোনটি না', 'is': 'ekkert', 'bs': 'ništa', 'sa_IN': 'न कोऽपि', 'sw_TZ': 'bila', 'ks': 'كہین نئ', 'my': 'မရှိပါ', 'ast': 'dengún', 'tr': 'hiçbiri', 'brx': 'रावबो नङा', 'mn': 'байхгүй', 'lb': 'keen', 'ja': 'つながない|none', 'cy': 'dim', 'fa': 'هیچ\u200cکدام', 'gl': 'ningún', 'ar': 'بلا', 'oc': 'pas cap', 'zh_CN': '无|none', 'eo': 'neniu', 'ca_valencia': 'cap', 'ne': 'कुनै पनि होइन', 'ca': 'cap', 'si': 'කිසිවක් නැත', 'ts': 'ku hava', 'uz': 'yoʻq', 'mni': 'অমত্তা নত্তবা', 'ka': 'ცარიელი'},
'FILLSTYLE':{'lt': 'spalvinimo.stilius|sst', 'th': 'กระบวนแบบการเติมสี', 'sid': 'akatawonshi', 'fi': 'täyttötyyli', 'ro': 'fillstyle|stilumplere', 'lv': 'pildījuma_stils', 'kn': 'ತುಂಬಿಸುವ ಶೈಲಿ', 'hsb': 'pjelnjenskistil|ps', 'tr': 'dolgu biçemi', 'es': 'estilorelleno', 'el': 'μορφήγεμίσματος|fillstyle', 'hr': 'stil ispune', 'cs': 'druhvýplně', 'de': 'füllstil|fs', 'he': 'סגנון מילוי', 'nl': 'vulling', 'hu': 'töltőstílus', 'hi': 'भरने की शैली', 'ml': 'നിറയ്ക്കുന്ന ശൈലി', 'id': 'fontcolor|textcolor|textcolour', 'gu': 'ભરવાની શૈલી', 'my': 'စတိုင်လ် ဖြည့်ပါ', 'ko': '채우기 스타일', 'zh_TW': '填入樣式|填樣式|fillstyle', 'mr': 'भरण्याची शैली', 'ru': 'стиль_заливки', 'sl': 'slogpolnila', 'bn_IN': 'ভরাট শৈলী', 'am': 'መሙያ ዘዴ', 'et': 'täitestiil', 'uk': 'стиль_заповнення', 'pt_BR': 'mudarEstiloDaPintura|mEstPi', 'kk': 'толтыру_түрі', 'te': 'నింపు శైలి', 'br': 'stil leuniañ', 'is': 'stíll fyllingar', 'km': 'រចនាប័ទ្ម\u200b\u200bបំពេញ', 'nb': 'fyllstil|fillstyle', 'bs': 'stil popunjavanja', 'eu': 'betetzeestiloa', 'pa_IN': 'ਭਰਨ ਸਟਾਈਲ', 'ast': 'estiluderrellenu', 'gug': 'estilohenyhe', 'vi': 'Kiểu tô đầy', 'or': 'ଶୌଳୀ ପୁରଣ କର', 'gd': 'stoidhle an lìonaidh', 'ja': '塗りつぶしの模様|fillstyle', 'nn': 'fyllstil|fillstyle', 'fr': 'styleremplissage', 'oc': "Estil d'emplenament", 'gl': 'estilo de recheo', 'ar': 'نمط_الملأ', 'ug': 'تولدۇرۇش ئۇسلۇبى', 'sk': 'Výplň', 'zh_CN': '填充样式|填样式|填式|fillstyle', 'eo': 'pleniga_stilo', 'ca_valencia': 'estil.emplenament|ee', 'ne': 'शैली भर्नुहोस्', 'ca': 'estil.emplenament|ee', 'si': 'පිරවුම් රටාව', 'en_US': 'fillstyle', 'ka': 'ჩასხმის სტილი'},
'FONTWEIGHT':{'lt': 'šrifto.storis|teksto.storis', 'sid': 'brrangichu ayirreenya', 'fi': 'fontinpaksuus', 'ro': 'fontweight|grosimefont', 'lv': 'fonta_treknums', 'kn': 'ಅಕ್ಷರಶೈಲಿ ತೂಕ', 'hsb': 'pismowawaha|pw', 'es': 'peso.letra|pl', 'el': 'πάχοςγραμματοσειράς|fontweight', 'hr': 'debljina slova', 'cs': 'tloušťkapísma', 'de': 'schriftgewicht|schgw', 'he': 'משקלגופן', 'nl': 'letterdikte|tekstdikte', 'hu': 'betűvastagság', 'hi': 'फ़ॉन्ट भार', 'ml': 'ഫോണ്ഡിന്റെ തൂക്കം', 'gu': 'ફોન્ટનો ભાર', 'my': 'စာလုံး အလေးချိန်', 'ko': '글꼴 굵기', 'zh_TW': '字型重量|字重|字粗細|字粗|fontweight', 'mr': 'फाँटचे वजन', 'ru': 'толщина_шрифта', 'sl': 'debelinapisave', 'bn_IN': 'ফন্টের পুরুত্ব', 'am': 'የፊደል ክብደት', 'et': 'fondi_paksus', 'uk': 'товщина_символів', 'pt_BR': 'mudarEspessuraDaLetra|mEspLe', 'kk': 'қаріп_жуандығы', 'te': 'అక్షరశైలి భారం', 'br': 'lard', 'is': 'leturbreidd', 'km': 'កម្រាស់\u200bពុម្ពអក្សរ', 'nb': 'skrifttykkelse|fontweight', 'bs': 'težinafonta', 'eu': 'letralodiera', 'cy': 'pwysau ffont', 'pa_IN': 'ਫੋਂਟ ਗੂੜਾਪਨ', 'ast': 'pesudefonte', 'tr': 'yazı tipi genişliği', 'vi': 'Độ đậm chữ', 'or': 'ଅକ୍ଷରରୂପ ଉଚ୍ଚତା', 'ja': '文字の太さ|フォントの太さ|fontweight', 'nn': 'skrifttjukkleik|fontweight', 'fr': 'graisse', 'oc': 'Graissa', 'gl': 'grosura de tipo de letra', 'ar': 'عرض_الخط', 'ug': 'خەت نۇسخا ئىنچىكە توملۇقى', 'sk': 'Váha písma', 'zh_CN': '字体粗细|字粗细|字粗|fontweight', 'eo': 'tiparopezo', 'ta': 'எழுத்துரு தடிமன்', 'ca_valencia': 'pes.lletra|pl', 'ne': 'फन्ट वजन', 'ca': 'pes.lletra|pl', 'si': 'අකුරු බර', 'en_US': 'fontweight', 'ka': 'შრიფტის სიგანე'},
'POSITION':{'lt': 'eik.į', 'sid': 'ofolla|ofo|ofoqineessi', 'fi': 'paikka', 'ro': 'position|pos|setpos|poziție', 'lv': 'pozīcija|poz|iest_poz', 'kn': 'ಸ್ಥಾನ|pos|ಸ್ಥಾನಹೊಂದಿಸು', 'hsb': 'pozicija|poz', 'es': 'posición|pos|fijar.posición', 'el': 'θέση|θσ|ορισμόςθέσης|βάλε|position|pos|setpos', 'hr': 'pozicija|poz|postavipoz', 'cs': 'pozice|poz|nastavpoz', 'de': 'position|pos', 'he': 'מיקום|מקום|הגדרמקום|הגדרתמקום|מקו', 'nl': 'positie|pos|setpos', 'hu': 'hely|hely!|pozíció|xy!', 'ko': '위치|pos|위치설정', 'zh_TW': '位置|定位|position|pos|setpos', 'mr': 'स्थान|पॉस|सेटपॉस', 'ru': 'позиция|поз|установить_позицию', 'sl': 'položaj|pol|določipoložaj', 'am': 'ቦታ|ቦታ|ቦታ ማሰናጃ', 'et': 'asukoht|koht|määra_koht', 'uk': 'позиція|поз|встановити_позицію', 'pt_BR': 'posicionar|pos', 'kk': 'орны|орн|орнын_көрсету', 'br': "lec'hiadur|pos|setpos", 'nb': 'plassering|plasser|position', 'bs': 'pozicija|pos|postavipos', 'eu': 'posizioa|pos|ezarriposizioa', 'ast': 'posición|pos|dirposición', 'tr': 'konum|knm|knmayarla', 'oc': 'posicion|pos|definirpos', 'or': 'ସ୍ଥାନ|pos|setpos', 'ja': '位置|場所|position', 'nn': 'plassering|plasser|pos|position', 'fr': 'position|pos|fixepos', 'gl': 'posición|pos|estabelecerposición', 'ar': 'موقع|عين_موقع', 'en_US': 'position|pos|setpos', 'sk': 'pozícia|poz|nastavpoz|np', 'eo': 'pozicio|poz', 'ca_valencia': 'posició|pos|estableix.posició', 'ca': 'posició|pos|estableix.posició', 'zh_CN': '位置|定位|position|pos|setpos'},
'STOP':{'lt': 'baik', 'sid': 'uurri', 'fi': 'pysäytä', 'lv': 'apturēt', 'kn': 'ನಿಲ್ಲಿಸು', 'hsb': 'stój', 'tr': 'dur', 'es': 'detener', 'el': 'τερματισμός|stop', 'hr': 'zaustavi', 'cs': 'zastav', 'de': 'stopp', 'he': 'עצור|עצירה|לעצור', 'hu': 'stop|visszatér', 'hi': 'रोकें', 'ml': 'നിര്\u200dത്തുക', 'gu': 'અટકાવો', 'ko': '중지', 'sd': 'رُڪو', 'zh_TW': '中止|止|stop', 'mr': 'स्टॉप', 'ru': 'стоп', 'sl': 'ustavi', 'sa_IN': 'ठॆहर', 'bn_IN': 'থামান', 'am': 'ማስቆሚያ', 'et': 'peata', 'uk': 'зупини', 'pt_BR': 'parar|pare', 'kk': 'тоқтату', 'te': 'ఆపుము', 'br': 'arsaviñ', 'is': 'stöðva', 'km': 'បញ្ឈប់', 'bs': 'zaustavi', 'eu': 'gelditu', 'cy': 'atal', 'pa_IN': 'ਰੋਕੋ', 'ast': 'parar', 'gug': 'pyta', 'oc': 'arrestar', 'as': 'বন্ধ কৰক', 'gd': 'sguir', 'or': 'ବନ୍ଦ କର', 'ja': '動きから出る|stop', 'nn': 'stopp|stop', 'nb': 'stopp|stop', 'gl': 'parar', 'ar': 'أوقف', 'en_US': 'stop', 'sk': 'zastav', 'zh_CN': '停止|中止|stop', 'eo': 'haltu', 'ta': 'நிறுத்து', 'ca_valencia': 'atura|para', 'ca': 'atura|para', 'dgo': 'रोको', 'my': 'ရပ်ပါ'},
'DASH':{'lt': 'brūkšneliai', 'th': 'เส้นประ', 'sid': 'daashshaamo', 'fi': 'katkonainen', 'ro': 'dashed|culiniuțe', 'lv': 'svītrots', 'kn': 'ಅಡ್ಡಗೆರೆಗಳುಳ್ಳ', 'hsb': 'smužkowany', 'tr': 'kesik çizgi', 'es': 'discontinua', 'el': 'με παύλες|dashed', 'hr': 'iscrtkano', 'cs': 'čárkovaná', 'de': 'gestrichelt', 'he': 'מיקוף', 'nl': 'gestreept', 'hu': 'szaggatott', 'hi': 'डैश किया हुआ', 'ml': 'ഡാഷ്ഡ്', 'gu': 'તૂટક', 'my': 'မျဉ်းရှည်', 'ko': '파선', 'zh_TW': '虛線|dashed', 'mr': 'डॅश्ड', 'ru': 'штриховая', 'sl': 'črtkano', 'bn_IN': 'ড্যাশযুক্ত', 'am': 'ዳሽ', 'et': 'kriipsudega', 'uk': 'штрихова', 'pt_BR': 'tracejado', 'kk': 'штрихті', 'te': 'గీతగీయబడెను', 'br': 'gourzhelloù', 'is': 'strikað', 'km': '\u200bដាច់ៗ', 'nb': 'stiplet|dashed', 'bs': 'isprekidano', 'eu': 'marratua', 'cy': 'toredig', 'pa_IN': 'ਧਾਰੀਦਾਰ', 'ast': 'discontinuu', 'gug': 'discontinua', 'vi': 'Gạch gạch', 'as': 'ডেশ্বযুক্ত', 'gd': 'strìochagach', 'or': 'ଡାସ', 'ja': '破線|dashed', 'nn': 'stipla|streka|dashed', 'fr': 'tiret', 'be': 'рыскі', 'oc': 'jonhent', 'gl': 'raiado', 'ar': 'متقطع', 'en_US': 'dashed', 'sk': 'Čiarky', 'zh_CN': '虚线|dashed', 'eo': 'streketa', 'ta': 'டேஷ்', 'ca_valencia': 'traçat', 'ne': 'ड्यासभएको', 'ca': 'traçat', 'si': 'ඉරි යෙදූ', 'ug': 'سىزىقچە', 'ka': 'წყვეტილი'},
'TEAL':{'lt': 'tamsiai.žydra', 'sid': 'shiima dakiyye', 'fi': 'sinivihreä', 'lv': 'zilzaļš', 'kn': 'ಗಾಢನೀಲಿಹಸಿರು', 'nn': 'mørk grønblå|teal', 'tr': 'deniz mavisi', 'es': 'jade', 'vec': 'grizo-verde', 'el': 'γαλαζοπράσινο|teal', 'hr': 'tirkizna', 'cs': 'zelenomodrá', 'sr_Latn': 'til', 'he': 'צהבהב', 'nl': 'groenblauw|blauwgroen', 'de': 'blaugrün', 'hi': 'हरा-नीला', 'gu': 'બતક', 'zh_TW': '藍綠|teal', 'mr': 'टिअल', 'ru': 'сине-зелёный', 'sl': 'modrozelena', 'bn_IN': 'টিল', 'am': 'ቲል', 'et': 'sinakasroheline', 'uk': 'синьо-зелений', 'pt_BR': 'turquesa', 'kk': 'жасыл_көк', 'te': 'టీల్', 'br': 'houad', 'is': 'djúp-blágrænt', 'km': 'ខៀវ\u200bបៃតង\u200bក្រមៅ', 'nb': 'mørk grønnblå|teal', 'bs': 'grogotovac', 'eu': 'anila', 'hu': 'kékeszöld', 'ast': 'xade', 'gug': 'aky-hovyha', 'as': 'টিল', 'gd': 'dath na crann-lach', 'or': 'କଳହଂସ', 'ja': 'マガモ色|くすんで暗い青|ティール|teal', 'hsb': 'módrozeleny', 'fr': 'bleuclair', 'be': 'бірузовы', 'gl': 'turquesa', 'ar': 'أزرق_مخضر', 'en_US': 'teal', 'sk': 'tyrkysová', 'sr': 'тил', 'zh_CN': '蓝绿色|蓝绿|teal', 'eo': 'bluverda', 'ta': 'டீல்', 'ca_valencia': 'jade', 'ca': 'jade', 'oc': 'baluclar'},
'FILLTRANSPARENCY':{'lt': 'spalvinimo.skaidrumas|ssk', 'uk': 'прозорість_заповнення', 'ja': '塗りつぶしの透明度|filltransparency', 'pt_BR': 'mudarTransparênciaDaPintura|mTraPi', 'kk': 'толтыру_мөлдірлілігі', 'fi': 'täyttöläpinäkyvyys', 'br': 'boullderleuniañ', 'km': 'បំពេញ\u200bភាព\u200bថ្លា', 'fr': 'transparenceremplir', 'pa_IN': 'ਪਾਰਦਰਸ਼ਤਾ ਭਰੋ', 'kn': 'ಪಾರದರ್ಶಕತೆಭರ್ತಿಮಾಡು', 'eu': 'betetzegardentasuna', 'hr': 'prozirnostispune', 'es': 'relleno.transparencia', 'el': 'διαφάνειαγεμίσματος', 'lv': 'pildījuma_caurspīdīgums', 'gug': 'myenyhẽ.tesakã', 'oc': 'transparénciaemplenar', 'cs': 'průhlednostvýplně|průhlvýplně', 'de': 'fülltransparenz|ft', 'tr': 'şeffaflıkladoldur', 'nl': 'vullingstransparantie', 'or': 'ପୂରଣସ୍ୱଚ୍ଛତା', 'he': 'שקיפות_המילוי', 'hsb': 'pjelnjacatransparenca', 'nn': 'fyllgjennomsikt', 'nb': 'fyllgjennomsiktighet', 'hu': 'töltőátlátszóság', 'gl': 'transparenciarecheo', 'ar': 'ملأ_شفافية', 'en_US': 'filltransparency', 'sk': 'priehľadnosťvýplne|pv', 'ko': '투명채우기', 'eo': 'plenigtravideblo', 'ca_valencia': 'transparència.emplenament', 'zh_TW': '填入透明|填透明|filltransparency', 'et': 'täite_läbipaistvus|tlp', 'zh_CN': '填充透明|填透明|filltransparency', 'ru': 'прозр_заливки|пз', 'sl': 'prosojnostpolnila', 'ug': 'تولدۇرۇش سۈزۈكلۈكى', 'am': 'ግልጽነት መሙያ', 'ca': 'transparència.emplenament'},
'BACKWARD':{'lt': 'atgal|at', 'th': 'กลับหลัง|bk', 'sid': 'badhera|br', 'fi': 'taakse|tk', 'ro': 'back|bk|înapoi', 'lv': 'atpakaļ|at', 'kn': 'ಹಿಂದಕ್ಕೆ|bk', 'hsb': 'wróćo|wr', 'tr': 'geri|ge', 'es': 'retrocede|atras|re|at', 'el': 'πίσω|πι|back|bk', 'hr': 'nazad|nz', 'cs': 'vzad|vz', 'de': 'zurück|zk', 'he': 'אחורה|אח', 'nl': 'terug|tg', 'hu': 'hátra|h', 'ko': '뒤로|bk', 'zh_TW': '後退|退|back|bk', 'mr': 'मागे|bk', 'ru': 'назад|н', 'sl': 'nazaj|nz', 'am': 'ወደ ኋላ|ወደ ኋላ', 'et': 'tagasi|t', 'uk': 'назад|нд', 'pt_BR': 'paraTrás|pt', 'kk': 'артқа|ар', 'br': 'war-gil|bk', 'km': 'ថយក្រោយ|bk', 'nb': 'tilbake|bakover|tb', 'bs': 'nazad|bk', 'eu': 'atzera|atz', 'ast': 'atrás|pt', 'gug': 'tapykuépe|jere', 'or': 'ପଛକୁ|bk', 'ja': 'もどる|back|bk', 'nn': 'tilbake|bakover|tb|back', 'fr': 'recule|re', 'be': 'назад|нз', 'sq': 'prapa|bk', 'gl': 'atrás|bk', 'ar': 'للخلف|خف', 'en_US': 'back|bk', 'sk': 'vzad|vz', 'eo': 'retro|r', 'ca_valencia': 'retrocedeix|recula|arrere|re', 'ca': 'retrocedeix|recula|enrere|re', 'zh_CN': '后退|退|back|bk'},
'BLUE':{'lt': 'mėlyna', 'th': 'น้ำเงิน', 'sid': 'gordaamo', 'fi': 'sininen', 'ro': 'blue|albastru', 'lv': 'zils', 'kn': 'ನೀಲಿ', 'hsb': 'módry', 'tr': 'mavi', 'es': 'azul', 'vec': 'blè', 'el': 'γαλάζιο|blue', 'hr': 'plava', 'cs': 'modrá', 'sr_Latn': 'plava', 'he': 'כחול', 'nl': 'blauw', 'de': 'blau', 'hi': 'नीला', 'ml': 'നീല', 'gu': 'વાદળી', 'my': 'အပြာရောင်', 'ko': '청색', 'zh_TW': '藍|blue', 'mr': 'निळा', 'ru': 'синий', 'sl': 'modra', 'bn_IN': 'নীল', 'am': 'ሰማያዊ', 'et': 'sinine', 'uk': 'синій', 'pt_BR': 'azul', 'kk': 'көк', 'te': 'నీలం', 'br': 'glas', 'is': 'blátt', 'km': 'ខៀវ', 'nb': 'blå|blue', 'bs': 'plava', 'eu': 'urdina', 'hu': 'kék', 'cy': 'glas', 'pa_IN': 'ਨੀਲਾ', 'ast': 'azul', 'gug': 'hovy', 'vi': 'Xanh', 'as': 'নীলা', 'gd': 'gorm', 'or': 'ନୀଳ', 'ja': '青|blue', 'nn': 'blå|blue', 'fr': 'bleu', 'be': 'сіні', 'oc': 'blau', 'gl': 'azul', 'ar': 'أزرق', 'en_US': 'blue', 'sk': 'modrá', 'sr': 'плава', 'zh_CN': '蓝|蓝色|blue', 'eo': 'blua', 'ta': 'நீலம்', 'ca_valencia': 'blau', 'ne': 'नीलो', 'ca': 'blau', 'si': 'නිල්', 'ug': 'كۆك', 'ka': 'ლურჯი'},
'GRAY':{'lt': 'pilka', 'sid': 'boora|bulla', 'fi': 'harmaa', 'ro': 'gray|grey|gri', 'lv': 'pelēks', 'kn': 'ಬೂದು|ಬೂದು', 'hsb': 'šěry', 'tr': 'gri|gri', 'es': 'gris', 'el': 'γκρίζο|gray|grey', 'hr': 'sivo|sivo', 'cs': 'šedá', 'sr_Latn': 'siva', 'he': 'אפור', 'nl': 'grijs', 'de': 'grau', 'ko': '회색|회색', 'zh_TW': '灰|gray|grey', 'mr': 'ग्रे|ग्रे', 'ru': 'серый', 'sl': 'siva', 'am': 'ግራጫ|ግራጫ', 'et': 'hall', 'uk': 'сірий', 'pt_BR': 'cinza', 'kk': 'сұр', 'br': 'loued|grey', 'is': 'grátt', 'km': 'ប្រផះ|grey', 'nb': 'grå|gray', 'bs': 'siva|siva', 'eu': 'grisa', 'hu': 'szürke', 'ast': 'buxu', 'gug': 'hũndy', 'or': 'ଧୂସର|grey', 'ja': '灰色|gray', 'nn': 'grå|gray', 'fr': 'gris|gris', 'be': 'шэры', 'gl': 'gris', 'ar': 'رمادي|رصاصي', 'en_US': 'gray|grey', 'sk': 'sivá', 'sr': 'сива', 'zh_CN': '灰|灰色|gray|grey', 'eo': 'griza', 'ca_valencia': 'gris', 'ca': 'gris', 'oc': 'gris|gris'},
'SQRT':{'lt': 'šaknis|sqrt', 'uk': 'корінь', 'ja': '平方根|sqrt', 'pt_BR': 'raiz|raizQ', 'fi': 'neliöjuuri', 'br': 'daouvonad', 'sat': 'SQRT', 'is': 'kvaðratr', 'fr': 'racine', 'kok': 'SQRT', 'bs': 'korijen', 'hsb': 'korjeń', 'tr': 'karekök', 'es': 'raiz.cuadrada|raiz|sqrt', 'ca': 'arrel', 'el': 'τετραγωνικήρίζα|sqrt', 'lv': 'kvadrātsakne', 'ast': 'raiz', 'gug': 'raiz.cuadrada|raiz|sqrt', 'cs': 'odmocnina', 'de': 'wurzel', 'nl': 'sqrt|vierkantswortel|vw', 'he': 'שורש', 'nn': 'kvrot|rot|sqrt', 'nb': 'kvrot|sqrt', 'hu': 'gyök', 'gl': 'raizc', 'ar': 'الجذر_التربيعي', 'en_US': 'sqrt', 'sk': 'odmocnina', 'eo': 'kvrad', 'ca_valencia': 'arrel', 'zh_TW': '開根|方根|sqrt', 'et': 'ruutjuur|rtjr|√', 'dgo': 'SQRT', 'sl': 'koren', 'sa_IN': 'SQRT', 'zh_CN': '平方根|方根|开方|sqrt', 'am': 'ስኴር ሩት', 'mr': 'स्केअररूट'},
'FONTHEIGHT':{'lt': 'šrifto.dydis|teksto.dydis', 'sid': 'borangichu bikka|borrotebikka|borrotehojja', 'ja': '文字の大きさ|フォントの大きさ|fontsize|fontheight', 'pt_BR': 'mudarTamanhoDaLetra|mTamLe', 'kk': 'қаріп_өлшемі|мәтін_өлшемі|мәтін_биіктігі', 'fi': 'fonttikoko', 'ro': 'fontsize|textsize|textheight|mărimefont', 'km': 'ទំហំ\u200bពុម្ពអក្សរ|textsize|textheight', 'fr': 'taillepolice|tailletexte|largeurtexte', 'lv': 'fonta_izmērs|teksta_izmērs|teksta_augstums', 'kn': 'ಅಕ್ಷರಶೈಲಿಗಾತ್ರ|ಪಠ್ಯಗಾತ್ರ|ಪಠ್ಯಎತ್ತರ', 'eu': 'letratamaina|testutamaina|testualtuera', 'tr': 'yazıtipiboyutu|metinboyutu|metinyüksekliği', 'es': 'tamaño.texto|tamaño.letra', 'ca': 'mida.lletra|mida.text', 'el': 'μέγεθοςγραμματοσειράς|μέγεθοςκειμένου|ύψοςκειμένου|fontsize|textsize|textheight', 'uk': 'кегль|розмір_символів|висота_символів', 'hr': 'veličina fonta|veličina teksta|visina teksta', 'cs': 'velikostpísma|velikosttextu', 'de': 'schriftgrösse|textgrösse|schgr|tgr', 'nl': 'lettergrootte|tekstgrootte|teksthoogte', 'bs': 'veličinafonta|veličinateksta|visinateksta', 'he': 'גודלגופן|גודלטקסט|גובהטקסט', 'hsb': 'wulkosćpisma|wulkosćteksta|wysokosćteksta|wp|wt', 'nn': 'tekststorleik|teksthøgd|textsize', 'nb': 'tekststørrelse|teksthøyde|textsize', 'hu': 'betűméret', 'gl': 'tamañodeletra|tamañodetexto|alturadetexto', 'ar': 'حجم_الخط', 'en_US': 'fontsize|textsize|textheight', 'sk': 'veľkosťpísma|veľkosťtextu|vp|vt', 'ko': '글꼴크기|글자크기|글자높이', 'or': 'ଅକ୍ଷରରୂପ ଆକାର|ପାଠ୍ୟଆକାର|textheight', 'eo': 'tiparogrando|tekstoalto|tekstogrando', 'ca_valencia': 'mida.lletra|mida.text', 'zh_TW': '字型大小|文字大小|字大小|字高|字級|fontsize|textsize|textheight', 'mr': 'फाँटआकार|मजकूरआकार|मजकूरऊंची', 'ast': 'tamañulletra|tamañutestu|altortestu', 'ru': 'кегль|размер_текста|высота_текста', 'sl': 'velikostpisave|velikostčrk|velikostbesedila', 'zh_CN': '文字大小|字体大小|字大小|字高|fontsize|textsize|textheight', 'am': 'የፊደል መጠን|የጽሁፍ መጠን|የጽሁፍ እርዝመት', 'et': 'fondi_suurus|teksti_suurus|teksti_kõrgus'},
'BLACK':{'lt': 'juoda', 'sid': 'kolishsho', 'zu': 'okumnyama', 'fi': 'musta', 'ss': 'mnyama', 'nr': 'nzima', 'ro': 'black|negru', 'lv': 'melns', 'kn': 'ಕಪ್ಪು', 'hsb': 'čorny', 'tr': 'siyah', 'xh': 'mnyama', 'el': 'μαύρο|black', 'hr': 'crna', 'tn': 'bontsho', 'cs': 'černé', 'sr_Latn': 'crna', 'he': 'שחור', 'nl': 'zwart', 'de': 'schwarz', 'hi': 'काला', 'ml': 'കറുത്ത', 'nso': 'ntsho', 'gu': 'કાળો', 've': 'ntswu', 'my': 'အနက်', 'ko': '검정', 'st': 'botsho', 'tt': 'кара', 'zh_TW': '黑|black', 'mr': 'काळा', 'sat': 'हेंदे', 'oc': 'negre', 'ru': 'чёрный', 'sl': 'črna', 'sa_IN': 'करूहुन', 'bn_IN': 'কালো', 'am': 'ጥቁር', 'et': 'must', 'lb': 'schwaarz', 'uk': 'чорний', 'kmr_Latn': 'reş', 'pt_BR': 'preto', 'kk': 'қара', 'te': 'నలుపు', 'af': 'swart', 'is': 'svart', 'km': 'ខ្មៅ\u200b', 'nb': 'svart|black', 'bs': 'crna', 'eu': 'beltza', 'hu': 'fekete', 'cy': 'du', 'pa_IN': 'ਕਾਲਾ', 'ast': 'prietu', 'gug': 'hũ', 'vi': 'đen', 'as': 'কলা', 'gd': 'dubh', 'eo': 'nigra', 'or': 'କଳା', 'ja': '黒|black', 'nn': 'svart|black', 'fr': 'noir', 'be': 'чорны', 'br': 'Du', 'fa': 'سیاه', 'gl': 'negro', 'ar': 'أسود', 'en_US': 'black', 'sk': 'čierna', 'es': 'negro', 'sr': 'црна', 'zh_CN': '黑|黑色|black', 'bn': 'কালো', 'ta': 'கருப்பு', 'ca_valencia': 'negre', 'ne': 'कालो', 'ca': 'negre', 'si': 'කළු', 'ts': 'ntima', 'ug': 'قارا', 'ka': 'შავი'},
'HOME':{'lt': 'namo', 'th': 'บ้าน', 'sid': 'Mine', 'fi': 'kotiin', 'ro': 'home|acasă', 'lv': 'mājas', 'kn': 'ನೆಲೆ', 'hsb': 'spočatk', 'tr': 'başlangıç', 'es': 'inicio|casa|centro', 'el': 'αρχή|home', 'hr': 'polazno', 'cs': 'domů', 'de': 'anfang', 'mn': 'эхлэл хуудас', 'he': 'בית', 'nl': 'thuis', 'hu': 'haza', 'hi': 'घर', 'ml': 'ആസ്ഥാനം', 'gu': 'ઘર', 'ko': '처음', 'sd': 'گهر', 'zh_TW': '回家|家|home', 'mr': 'होम', 'sat': 'ओड़ाक्', 'ru': 'начало', 'sl': 'začetek', 'bn_IN': 'Home', 'am': 'ቤት', 'et': 'koju', 'uk': 'центр', 'pt_BR': 'paraCentro|centro|pc', 'kk': 'басы', 'te': 'నివాసం', 'br': 'Degemer', 'is': 'heim', 'km': 'ដើម', 'nb': 'hjem|home', 'kok': 'घरGhor', 'bs': 'kući', 'eu': 'hasiera', 'cy': 'cartref', 'pa_IN': 'ਘਰ', 'ast': 'aniciu', 'gug': 'óga', 'vi': 'Home', 'as': 'ঘৰ', 'gd': 'dhachaigh', 'or': 'ମୂଳ ସ୍ଥାନ', 'ja': 'もとの場所へ|home', 'nn': 'heim|home', 'fr': 'origine', 'sq': 'shtëpia', 'oc': 'acuèlh', 'gl': 'inicio', 'ar': 'المنزل', 'en_US': 'home', 'sk': 'domov', 'zh_CN': '归位|回归|回家|家|home', 'eo': 'hejmen', 'ca_valencia': 'inici|centre', 'ca': 'inici|centre', 'si': 'සමහර', 'dgo': 'घर', 'my': 'အချို့'},
'ROUND':{'lt': 'apvalink', 'sid': 'doyiissi', 'fi': 'pyöreä', 'ro': 'round|rotund', 'lv': 'apaļš', 'kn': 'ದುಂಡಾದ', 'hsb': 'kulojty', 'tr': 'yuvarla', 'es': 'redondear', 'el': 'στρογγυλοποίηση|round', 'hr': 'okruglo', 'cs': 'oblé', 'de': 'runde', 'he': 'עגול', 'nl': 'rondaf', 'hu': 'kerek', 'hi': 'गोल', 'ml': 'ഉരുണ്ട', 'gu': 'રાઉન્ડ', 'my': 'ပတ်လည်', 'ko': '반올림', 'zh_TW': '四捨五入|round', 'mr': 'गोलाकार', 'ru': 'скруглить', 'sl': 'zaokroži', 'bn_IN': 'রাউন্ড', 'am': 'ክብ', 'et': 'ümar', 'uk': 'закруглити', 'pt_BR': 'arred|arredonde', 'kk': 'домалақтау', 'te': 'రౌండ్', 'br': 'ront', 'is': 'rúnnað', 'km': 'មូល', 'nb': 'avrund|round', 'bs': 'okruglo', 'eu': 'biribildua', 'cy': 'crwn', 'pa_IN': 'ਗੋਲ', 'ast': 'redondu', 'gug': "emoapu'a", 'vi': 'Làm tròn', 'as': 'গোলাকাৰ', 'gd': 'cruinn', 'or': 'ଗୋଲାକାର', 'ja': '四捨五入|round', 'nn': 'avrund|round', 'fr': 'arrondi', 'sq': 'rrumbullak', 'oc': 'arredondit', 'gl': 'arredondar', 'ar': 'دائري', 'en_US': 'round', 'sk': 'Zaokrúhlenie', 'zh_CN': '四舍五入|舍入|round', 'eo': 'ronda', 'ta': 'வட்டம்', 'ca_valencia': 'arrodoneix|arrod', 'ne': 'गोलाकार', 'ca': 'arrodoneix|arrod', 'si': 'වටකුරු', 'ug': 'يۇمۇلاق', 'ka': 'მრგვალი'},
'BREAK':{'lt': 'nutrauk', 'sid': 'tayisi', 'fi': 'keskeytä', 'ro': 'break|întrerupere', 'lv': 'pārtraukt', 'kn': 'ತಡೆ', 'hsb': 'přetorhnjenje', 'tr': 'sonlandır', 'es': 'saltar|interrumpir', 'el': 'διακοπή|break', 'hr': 'prijelom', 'cs': 'ukonči', 'de': 'abbruch', 'he': 'שבירה|לשבור', 'nl': 'afbreken', 'hu': 'kilép', 'hi': 'खण्डन', 'ml': 'വിഭജിക്കുക', 'gu': 'વિભાજક', 'ko': '분할', 'zh_TW': '中斷|斷|break', 'mr': 'ब्रेक', 'ru': 'прервать', 'sl': 'prekini', 'bn_IN': 'বিরতি', 'am': 'መጨረሻ', 'et': 'katkesta', 'uk': 'перерви', 'pt_BR': 'interromper|interrompa', 'kk': 'үзу', 'te': 'విరుపు', 'br': 'rannadur', 'is': 'rofstaður', 'km': 'បំបែក', 'nb': 'avbryt|break', 'bs': 'iskoči', 'eu': 'jauzia', 'cy': 'toriad', 'pa_IN': 'ਬਰੇਕ', 'ast': 'saltu', 'gug': 'kytĩ', 'vi': 'Ngắt', 'or': 'ଭାଙ୍ଗ', 'ja': 'くりかえしから出る|break', 'nn': 'avbryt|break', 'fr': 'saut', 'oc': 'fraccionar', 'gl': 'quebrar', 'ar': 'اكسر', 'en_US': 'break', 'sk': 'Zalomenie', 'zh_CN': '中断|break', 'eo': 'saltu', 'ta': 'முறி', 'ca_valencia': 'salta|trenca', 'ne': 'विच्छेद', 'ca': 'salta|trenca', 'si': 'බිදුම', 'my': 'ကြားဖြတ်ပါ', 'ka': 'შეწყვეტა'},
'PURPLE':{'lt': 'violetinė', 'sid': 'Hamara', 'fi': 'purppura', 'ro': 'purple|violet', 'lv': 'purpura', 'kn': 'ನೇರಳೆ', 'hsb': 'purpurny', 'tr': 'mor', 'es': 'púrpura|morado', 'vec': 'vioła', 'el': 'πορφυρό|purple', 'hr': 'ljubičasta', 'cs': 'tmavě purpurová', 'sr_Latn': 'ljubičasta', 'he': 'סגול', 'nl': 'lila', 'de': 'lila', 'hi': 'बैंगनी', 'ml': 'പര്\u200dപ്പിള്\u200d', 'gu': 'જાંબુડિયો', 'ko': '자주색', 'sd': 'واڱڻائي', 'zh_TW': '紫|purple', 'mr': 'जांभळा', 'sat': 'कुरसे बाहा रोङ गाड़माक्', 'ru': 'фиолетовый', 'sl': 'škrlatna', 'sa_IN': 'परपोल', 'bn_IN': 'গোলাপী', 'am': 'ወይን ጠጅ', 'et': 'lilla', 'uk': 'фіолетовий', 'pt_BR': 'roxo', 'kk': 'күлгін', 'te': 'వంకాయరంగు', 'br': 'limestra', 'is': 'purpurablátt', 'km': 'ស្វាយ', 'nb': 'lilla|purple', 'kok': 'जांबळोZamblli', 'bs': 'ljubičasta', 'eu': 'morea', 'hu': 'lila', 'cy': 'porffor', 'pa_IN': 'ਵੈਂਗਣੀ', 'ast': 'púrpura', 'gug': 'lila', 'vi': 'Tía', 'as': 'জামুকলীয়া', 'gd': 'purpaidh', 'or': 'ବାଇଗଣୀ', 'ja': '紫|purple', 'nn': 'lilla|purple', 'fr': 'pourpre', 'be': 'пурпурны', 'gl': 'púrpura', 'ar': 'بنفسجي', 'en_US': 'purple', 'sk': 'Purpurová', 'sr': 'љубичаста', 'zh_CN': '紫|紫色|purple', 'eo': 'purpura', 'ta': 'ஊதா', 'ca_valencia': 'porpra|púrpura', 'ca': 'porpra|púrpura', 'dgo': 'जामुनी', 'oc': 'porpra'},
'BROWN':{'lt': 'ruda', 'th': 'น้ำตาล', 'sid': 'daama', 'fi': 'ruskea', 'ro': 'brown|maro', 'lv': 'brūns', 'kn': 'ಕಂದು', 'hsb': 'bruny', 'tr': 'kahverengi', 'es': 'marrón|café', 'el': 'καφέ|brown', 'hr': 'smeđa', 'cs': 'hnědá', 'sr_Latn': 'braon', 'he': 'חום', 'nl': 'bruin', 'de': 'braun', 'hi': 'भूरा', 'ml': 'ബ്രൌണ്\u200d', 'gu': 'તપખીરિયા રંગનું', 'ko': '갈색', 'zh_TW': '棕|brown', 'mr': 'ब्राउन', 'ru': 'коричневый', 'sl': 'rjava', 'bn_IN': 'বাদামি', 'am': 'ቡናማ', 'et': 'pruun', 'uk': 'коричневий', 'pt_BR': 'marrom', 'kk': 'қоңыр', 'te': 'గోధుమరంగు', 'br': 'liv kistin', 'is': 'brúnt', 'km': 'ត្នោត', 'nb': 'brun|brown', 'bs': 'smeđa', 'eu': 'marroia', 'hu': 'barna', 'pa_IN': 'ਭੂਰਾ', 'ast': 'marrón', 'gug': 'marrón', 'vi': 'Nâu', 'as': 'মূগা', 'gd': 'donn', 'or': 'ବାଦାମୀ', 'ja': '茶色|ブラウン|brown', 'nn': 'brun|brown', 'fr': 'marronclair', 'be': 'карычневы', 'oc': 'marron', 'gl': 'marrón', 'ar': 'بني', 'en_US': 'brown', 'sk': 'Hnedá', 'sr': 'браон', 'zh_CN': '棕色|棕|brown', 'eo': 'bruna', 'ta': 'பழுப்பு', 'ca_valencia': 'marró', 'ne': 'कैलो', 'ca': 'marró', 'si': 'දුඹුරු', 'my': 'အညို', 'ka': 'ყავისფერი'},
'FALSE':{'lt': 'melas', 'th': 'เท็จ', 'sid': 'xara', 'fi': 'epätosi', 'ro': 'false|fals', 'lv': 'aplams', 'kn': 'ಅಸತ್ಯ', 'hsb': 'wopačny', 'tr': 'yanlış', 'es': 'falso', 'el': 'ψευδής|false', 'hr': 'netočno', 'cs': 'nepravda', 'de': 'falsch', 'he': 'שקר', 'nl': 'onwaar', 'hu': 'hamis', 'hi': 'गलत', 'gu': 'ખોટુ', 'my': 'အမှား', 'ko': '거짓', 'br': 'diwir', 'zh_TW': '假|false', 'mr': 'फॉल्स', 'ru': 'ложь', 'sl': 'niresnično', 'bn_IN': 'মিথ্যা', 'am': 'ሀሰት', 'et': 'väär', 'uk': 'хиба', 'kmr_Latn': 'şaşî ye', 'pt_BR': 'falso', 'kk': 'жалған', 'te': 'అసత్యము', 'af': 'onwaar', 'is': 'ósatt', 'tg': 'дурӯғ', 'km': 'មិន\u200bពិត', 'nb': 'usann|false', 'eu': 'faltsua', 'cy': 'ffug', 'pa_IN': 'ਗਲਤ', 'ast': 'falso', 'gug': 'japu', 'vi': 'sai', 'as': 'মিছা', 'ja': '偽|なりたたない|false', 'nn': 'usann|false', 'fr': 'faux', 'bn': 'মিথ্যা', 'oc': 'fals', 'gl': 'falso', 'ar': 'خطأ', 'om': 'soba', 'ug': 'يالغان', 'sk': 'nepravda', 'zh_CN': '假|false', 'eo': 'falsa', 'ta': 'தவறு', 'ca_valencia': 'fals', 'ne': 'झूटो', 'ca': 'fals', 'si': 'අසත්\u200dය', 'en_US': 'false', 'ka': 'მცდარი'},
'MM':{'th': 'มม.', 'uk': 'мм', 'mk': 'мм', 'kk': 'мм', 'bn': 'মিমি', 'tg': 'мм', 'km': 'ម.ម.', 'zh_CN': '毫米|mm', 'kok': 'मिमि', 'kn': 'ಮಿ.ಮಿ', 'ks': 'ملی میٹر', 'nr': 'i-mm', 'el': 'χιλιοστά|mm', 'dz': 'ཨེམ་ཨེམ་', 'as': 'মি.মি.', 'mn': 'мм', 'ru': 'мм', 'or': 'ମିଲିମିଟର', 'he': 'מ"מ|מ״מ', 'be': 'мм', 'sq': '0 mm', 'hi': 'मिमी', 'ml': 'മിമി', 'ar': 'مم', 'en_US': 'mm', 'my': 'မီလီမီတာ', 'bn_IN': 'মিমি', 'ta': 'மி.மீ', 'tt': 'мм', 'ne': 'मिलिमिटर', 'zh_TW': '公釐|mm', 'dgo': 'मी.मी.', 'bo': 'ཧའི་སྨི།', 'mai': 'मिमी', 'ja': 'ミリメートル|mm', 'mni': 'মি.মি.', 'ug': 'مىللىمېتىر', 'am': 'ሚ/ሚ', 'ka': 'მმ'},
'END':{'fi': 'loppu', 'kn': 'ಕೊನೆ', 'xh': 'ekugqibeleni', 'hr': 'kraj', 'de': 'ende', 'he': 'סוף', 'nl': 'E', 'hu': 'vége', 'ml': 'അന്ത്യം', 'st': 'qetello', 'ko': '최종 기간', 'mr': 'एंड', 'mai': 'अंत', 'am': 'መጨረሻ', 'et': 'lõpp', 'kk': 'соңы', 'te': 'ముగింపు', 'af': 'einde', 'tg': 'Давраи охир', 'km': 'ពេលបញ្ចប់', 'fr': 'fin', 'kok': 'अंत', 'eu': 'amaiera', 'pa_IN': 'ਅੰਤ', 'gug': 'opa', 'vi': 'kết thúc', 'lo': 'ຈົບ', 'gd': 'deireadh', 'rw': 'impera', 'hsb': 'kónc', 'nb': 'slutt|end', 'sq': 'fund', 'om': 'dhuma', 'en_US': 'end', 'sk': 'koniec', 'ta': 'முடிவு', 'dgo': 'अंत', 'zh_CN': '定义终|终|结束|end', 'lt': 'taškas', 'th': 'สิ้นสุด', 'sid': 'gofimarcho', 'zu': 'isiphetho', 'ss': 'kugcina', 'mk': 'Крај', 'ro': 'end|sfârșit', 'lv': 'beigas', 'as': 'অন্ত', 'nn': 'slutt|end', 'es': 'fin', 'el': 'τέλος|end', 'dz': 'མཇུག', 'tn': 'bofelo', 'cs': 'konec', 'sl': 'konec', 'hi': 'अंत', 'gu': 'અંત', 've': 'magumo', 'sd': 'آخر', 'zh_TW': '結束|迄|end', 'sat': 'मुचात् मुचा़त्', 'bo': 'end_period', 'ru': 'конец', 'nso': 'mafelelo', 'bn_IN': 'শেষ', 'uk': 'Кін_період', 'kmr_Latn': 'dawî', 'pt_BR': 'fim', 'bn': 'শেষ', 'is': 'endar', 'bs': 'kraj', 'sa_IN': 'समाप्तः', 'sw_TZ': 'mwisho', 'ks': 'اند', 'my': 'အဆုံးသတ်', 'ast': 'final', 'tr': 'son', 'brx': 'जोबनाय', 'mn': 'төгсгөл', 'or': 'ଶେଷ', 'ja': 'おわり|end', 'cy': 'diwedd', 'nr': 'phela', 'br': 'Marevezh echuiñ', 'ar': 'النهاية', 'oc': 'fin', 'eo': 'fino', 'ca_valencia': 'final|fi', 'ne': 'अन्त्य', 'ca': 'final|fi', 'si': 'අවසානය', 'ts': 'makumu', 'mni': 'অরোয়বা'},
'SLEEP':{'lt': 'lauk', 'sid': 'goxi', 'fi': 'nuku', 'ro': 'sleep|adormire', 'lv': 'gulēt', 'kn': 'ಜಡ', 'hsb': 'čakać', 'tr': 'askıya al', 'es': 'dormir|espera', 'el': 'αναμονή|sleep', 'hr': 'spavaj', 'cs': 'čekej', 'de': 'warte', 'he': 'לישון', 'nl': 'slaap', 'hu': 'vár|várj', 'hi': 'सुप्त', 'gu': 'નિદ્રા', 'ko': '대기 모드', 'zh_TW': '睡眠|休息|sleep', 'mr': 'स्लीप', 'ru': 'ждать', 'sl': 'miruj', 'am': 'ማስተኛ', 'et': 'oota', 'uk': 'чекай', 'pt_BR': 'esperar|espere', 'kk': 'күту', 'te': 'స్లీమ్', 'br': 'kousket', 'is': 'svæfa', 'km': 'ដេក', 'nb': 'sov|pause|sleep', 'bs': 'spavanje', 'eu': 'loegin', 'cy': 'cysgu', 'ast': 'dormir', 'gug': 'ke', 'as': 'নিদ্ৰা', 'or': 'ସୁପ୍ତ', 'ja': '待つ|sleep', 'nn': 'sov|pause|sleep', 'fr': 'suspendre', 'gl': 'durmir', 'ar': 'نَم', 'en_US': 'sleep', 'sk': 'čakaj', 'zh_CN': '休息|睡眠|sleep', 'eo': 'dormu', 'ca_valencia': 'dorm|espera', 'ca': 'dorm|espera', 'oc': 'arrestar'},
'BOLD':{'lt': 'pusjuodis', 'th': 'ตัวหนา', 'sid': "kee'misi", 'zu': 'okugqamile', 'fi': 'lihavointi', 'ss': 'licinsi', 'ml': 'ബോള്\u200dഡ്', 'ro': 'bold|îngroșat', 'lv': 'trekns', 'kn': 'ಬೋಲ್ಡ್\u200d', 'hsb': 'tučny', 'tr': 'kalın', 'xh': 'ngqindilili', 'vec': 'groseto', 'el': 'έντονα|bold', 'hr': 'podebljano', 'tn': 'tiisa', 'cs': 'tučné', 'de': 'fett', 'he': 'מודגש', 'nl': 'vet', 'hu': 'félkövér|kövér|vastag', 'hi': 'मोटा', 'bn': 'গাঢ়', 'nso': 'mokoto', 'gu': 'ઘટ્ટ', 've': 'ndenya', 'my': 'မဲ', 'ko': '굵은', 'st': 'botenya', 'tt': 'калын', 'zh_TW': '粗體|粗|bold', 'mr': 'ठळक', 'oc': 'gras', 'ru': 'жирный', 'sl': 'krepko', 'bn_IN': 'গাঢ়', 'am': 'ማድመቂያ', 'et': 'paks|rasvane', 'lb': 'fett', 'uk': 'жирний', 'kmr_Latn': 'qalind', 'pt_BR': 'negrito', 'kk': 'жуан', 'te': 'మందం', 'af': 'vetdruk', 'is': 'feitletrað', 'km': 'ដិត\u200b', 'nb': 'fet|bold', 'bs': 'masno', 'eu': 'lodia', 'nr': 'darhileko', 'cy': 'trwm', 'pa_IN': 'ਗੂੜ੍ਹੇ', 'ast': 'gruesu', 'gug': "hũ'i", 'vi': 'đậm', 'as': 'ডাঠ', 'gd': 'trom', 'eo': 'grasa', 'or': 'ଗାଢ଼', 'ja': '太く|太字|bold', 'nn': 'feit|bold', 'fr': 'gras', 'be': 'цёмны', 'sq': 'të trasha', 'fa': 'ضخیم', 'gl': 'grosa', 'ar': 'عريض', 'en_US': 'bold', 'sk': 'tučné', 'es': 'grueso', 'zh_CN': '粗体|粗|bold', 'br': 'Tev', 'ta': 'தடிமன்', 'ca_valencia': 'negreta', 'ne': 'बाक्लो', 'ca': 'negreta', 'si': 'තදකුරු', 'ts': 'dzwihala', 'ug': 'توم', 'ka': 'შეკვრა'},
'ELLIPSE':{'lt': 'elipsė', 'th': 'วงรี', 'sid': 'suduudaamo', 'fi': 'ellipsi', 'ro': 'ellipse|elipsă', 'lv': 'elipse', 'kn': 'ದೀರ್ಘವೃತ್ತ', 'hsb': 'elipsa', 'tr': 'elips', 'es': 'elipse', 'vec': 'ełise', 'el': 'έλλειψη|ellipse', 'hr': 'elipsa', 'cs': 'elipsa', 'mn': 'эллипс', 'he': 'אליפסה', 'nl': 'Ellips', 'hu': 'ellipszis', 'hi': 'दीर्घवृत्त', 'ml': 'അണ്ഡവൃത്തം', 'gu': 'ઉપવલય', 'my': 'ဘဲဥပုံ', 'ko': '타원', 'zh_TW': '橢圓|ellipse', 'mr': 'दीर्घवृत्त', 'ru': 'эллипс', 'sl': 'elipsa', 'bn_IN': 'উপবৃত্ত', 'am': 'ኤሊፕስ', 'et': 'ellips', 'uk': 'еліпс', 'pt_BR': 'elipse', 'kk': 'эллипс', 'te': 'దీర్ఘవృత్తం', 'br': 'elipsenn', 'is': 'sporbaugur', 'km': 'ពង\u200bក្រពើ', 'bs': 'elipsa', 'eu': 'elipsea', 'pa_IN': 'ਅੰਡਾਕਾਰ', 'ast': 'elipse', 'gug': 'elipse', 'vi': 'Bầu dục', 'as': 'উপবৃত্ত', 'gd': 'eileaps', 'or': 'ଅଣ୍ଡାକୃତ', 'ja': '楕円|ellipse', 'cy': 'elips', 'be': 'эліпс', 'sq': 'elips', 'oc': 'ellipsa', 'gl': 'elipse', 'ar': 'بيضاوي', 'ug': 'ئېللىپىس', 'sk': 'elipsa', 'zh_CN': '椭圆|ellipse', 'eo': 'elipso', 'ta': 'நீள்வட்டம்', 'ca_valencia': 'el·lipse', 'ne': 'दीर्घवृत्त', 'ca': 'el·lipse', 'si': 'ඉලිප්සය', 'en_US': 'ellipse', 'ka': 'ელიფსი'},
'SHOWTURTLE':{'lt': 'rodyk.vėžliuką|rodykis|rd', 'sid': 'bukukaleelshi|bukukaleelshi|bl|aneleelshi', 'fi': 'näytäkonna|nk', 'ro': 'showturtle|st|showme|vizibil', 'lv': 'rādīt_rupuci|rr|rādīt_mani', 'kn': 'ಆಮೆತೋರಿಸು|st|ನನ್ನನ್ನುತೋರಿಸು', 'hsb': 'pokazać', 'tr': 'kaplumbağagöster|kg|benigöster', 'es': 'mostrartortuga|mt|mostrarme', 'el': 'εμφάνισηχελώνας|εμφάνισεμε|εε|showturtle|st|showme', 'hr': 'pokažikursor|st|pokažime', 'cs': 'ukažželvu|ukaž|už', 'de': 'zeigen', 'he': 'הצגצב|להציבצב|הצגתהצב|להציגאותי|הצ', 'nl': 'toon|tn', 'hu': 'látható', 'ko': '거북이표시|st|표시', 'zh_TW': '顯示海龜|顯示龜|顯示|showturtle|st|showme', 'mr': 'शोटर्टल|st|शोमि', 'ru': 'показать_черепаху|пч|показать_меня', 'sl': 'pokažiželvo|pž|pokažime', 'am': 'ኤሊ ማሳያ|st|ያሳዩኝ', 'et': 'näita|näita_kilpkonna|nk', 'uk': 'покажи_черепашку|пч', 'pt_BR': 'mostrarTat|mostreTat|at|apareçaTat|aparecerTat', 'kk': 'тасбақаны_көрсету|тк|мені_көрсету', 'br': 'diskouezbaot|st|showme', 'nb': 'vismeg|vm|showturtle', 'bs': 'prikažikornjaču|st|prikažimene', 'eu': 'erakutsidortoka|rd|erakutsini', 'ast': 'amuesatortuga|veme|vt', 'gug': 'hechaukakarumbe|hk|ajehecha', 'oc': 'afichartortuga|at|afichar', 'or': 'କଇଁଛଦର୍ଶାଇବା|st|showme', 'ja': 'タートルを出す|showturtle|st', 'nn': 'vismeg|vm|showturtle', 'fr': 'montretortue|mt|montremoi', 'gl': 'amosartartaruga|mt|amosarme', 'ar': 'أظهر_السلحفاة|أظهر', 'en_US': 'showturtle|st|showme', 'sk': 'ukážkorytnačku|ukáž|uk', 'eo': 'vidigu_testudon|vt', 'ca_valencia': 'mostra.tortuga|mt', 'ca': 'mostra.tortuga|mt', 'zh_CN': '显示海龟|显示龟|显龟|showturtle|st|showme'},
'SQUARE':{'lt': 'kvadratas', 'th': 'สี่เหลี่ยมจัตุรัส', 'sid': 'isikuwere', 'fi': 'neliö', 'ro': 'square|pătrat', 'lv': 'kvadrāts', 'kn': 'ಚೌಕ', 'hsb': 'kwadrat', 'tr': 'kare', 'es': 'cuadrado', 'vec': 'cuadrato', 'el': 'τετράγωνο|square', 'hr': 'kvadrat', 'cs': 'čtverec', 'de': 'quadrat', 'mn': 'квадрат', 'he': 'ריבוע', 'nl': 'vierkant', 'hu': 'négyzet', 'hi': 'वर्ग', 'ml': 'സമചതുരം', 'gu': 'ચોરસ', 'my': 'စတုရန်း', 'ko': '정사각형', 'zh_TW': '正方形|方|square', 'mr': 'चौरस', 'ru': 'квадрат', 'sl': 'kvadrat', 'bn_IN': 'বর্গক্ষেত্র', 'am': 'ስኴር', 'et': 'ruut', 'uk': 'квадрат', 'pt_BR': 'quadrado', 'kk': 'шаршы', 'te': 'చతురస్రము', 'br': 'karrez', 'is': 'ferningur', 'km': 'ការេ', 'nb': 'kvadrat|square', 'bs': 'kvadrat', 'eu': 'koadroa', 'cy': 'sgwâr', 'pa_IN': 'ਵਰਗ', 'ast': 'cuadráu', 'gug': 'cuadrado', 'vi': 'Vuông', 'as': 'বৰ্গ', 'gd': 'ceàrnag', 'or': 'ବର୍ଗାକାର', 'ja': '正方形|square', 'nn': 'kvadrat|square', 'fr': 'carré', 'be': 'квадрат', 'sq': 'katror', 'oc': 'carrat', 'gl': 'cadrado', 'ar': 'مربع', 'en_US': 'square', 'sk': 'štvorec', 'zh_CN': '正方形|方|square', 'eo': 'kvadrato', 'ta': 'சதுரம்', 'ca_valencia': 'quadrat', 'ne': 'वर्ग', 'ca': 'quadrat', 'si': 'සමචතුරශ්\u200dරය', 'ug': 'كۋادرات', 'ka': 'კვადრატი'},
'LOG10':{'zh_TW': '對數|log10', 'zh_CN': '对数|log10', 'ar': 'لوغاريثم_عشري', 'en_US': 'log10', 'ug': 'لوگارىفما|log10', 'am': 'ሎግ10', 'he': 'לוגריתם_10'},
'FILL':{'lt': 'spalvink', 'th': 'เติม', 'sid': 'wonshi', 'fi': 'täytä', 'ro': 'fill|umplere', 'lv': 'aizpildīt', 'kn': 'ತುಂಬಿಸು', 'hsb': 'pjelnić', 'tr': 'doldur', 'es': 'relleno|rellenar', 'vec': 'Inpienasion', 'el': 'γέμισμα|fill', 'hr': 'ispuni', 'cs': 'vyplň', 'de': 'füllen', 'he': 'מילוי', 'nl': 'vullen', 'hu': 'tölt', 'hi': 'भरें', 'ml': 'നിറയ്ക്കുക', 'gu': 'ભરો', 'my': 'ဖြည့်ပါ', 'ko': '채우기', 'zh_TW': '填入|fill', 'mr': 'भरा', 'ru': 'заливка', 'sl': 'zapolni', 'bn_IN': 'পূরণ করুন', 'am': 'መሙያ', 'et': 'täida', 'uk': 'заповнення', 'pt_BR': 'pintar|pinte|preencher', 'kk': 'толтыру', 'te': 'నింపు', 'br': 'leuniañ', 'is': 'fylling', 'km': 'បំពេញ', 'nb': 'fyll|fill', 'bs': 'popuni', 'eu': 'bete', 'cy': 'llanw', 'pa_IN': 'ਭਰੋ', 'ast': 'rellenar', 'gug': 'myenyhẽ', 'oc': 'emplenar', 'as': 'পূৰ্ণ কৰক', 'or': 'ପୁରଣ କରନ୍ତୁ', 'ja': '塗りつぶし|fill', 'nn': 'fyll|fill', 'fr': 'remplir', 'be': 'запаўненне', 'sq': 'mbush', 'gl': 'encher', 'ar': 'املأ', 'ug': 'تولدۇر', 'sk': 'výplň', 'zh_CN': '填充|fill', 'eo': 'plenigu', 'ta': 'நிரப்பு', 'ca_valencia': 'omple|emplena', 'ne': 'भर्नुहोस्', 'ca': 'omple|emplena', 'dgo': 'भराई', 'en_US': 'fill', 'ka': 'შევსება'},
'SILVER':{'lt': 'sidabrinė', 'sid': 'siwiila', 'fi': 'hopea', 'ro': 'silver|argintiu', 'lv': 'sudraba', 'kn': 'ಬೆಳ್ಳಿ', 'hsb': 'slěbro', 'tr': 'gümüş', 'es': 'plata', 'vec': 'arzento', 'el': 'ασημί|silver', 'hr': 'srebrno', 'cs': 'stříbrná', 'sr_Latn': 'srebrna', 'he': 'כסף', 'nl': 'zilver', 'de': 'silber', 'gu': 'ચાંદી', 'ko': '은색', 'zh_TW': '銀灰|銀|silver', 'mr': 'चंदेरी', 'ru': 'серебряный', 'sl': 'srebrna', 'bn_IN': 'রূপালী', 'am': 'ብር', 'et': 'hõbedane', 'uk': 'срібний', 'pt_BR': 'prata', 'kk': 'күміс', 'te': 'సిల్వర్', 'br': 'argant', 'is': 'silfur', 'km': 'ប្រាក់', 'nb': 'sølv|silver', 'bs': 'srebrena', 'eu': 'zilarra', 'hu': 'világosszürke|ezüst', 'cy': 'arian', 'ast': 'plata', 'gug': 'plata', 'as': 'ৰূপ', 'gd': 'airgid', 'or': 'ସିଲଭର', 'ja': '銀|silver', 'nn': 'sølv|silver', 'fr': 'argent', 'be': 'срэбны', 'gl': 'prata', 'ar': 'فضي', 'en_US': 'silver', 'sk': 'strieborná', 'sr': 'сребрна', 'eo': 'arĝenta', 'ta': 'சில்வர்', 'ca_valencia': 'plata|argent', 'ca': 'plata|argent', 'zh_CN': '银|银色|silver'},
'VIOLET':{'lt': 'alyvų', 'sid': 'hamara', 'fi': 'violetti', 'lv': 'violets', 'kn': 'ನೇರಳೆ', 'hsb': 'fijałkojty', 'tr': 'menekşe', 'es': 'violeta', 'el': 'βιολετί|violet', 'hr': 'ljubičasta', 'cs': 'fialová', 'sr_Latn': 'ljubičasta', 'he': 'סגולעדין', 'de': 'violett', 'hi': 'बैंगनी', 'ml': 'വയലറ്റ്', 'gu': 'જાંબલી', 'my': 'ခရမ်းရောင်', 'ko': '보라색', 'zh_TW': '紫蘿蘭|藍紫|violet', 'mr': 'गडद जांभळा', 'ru': 'лиловый', 'sl': 'vijolična', 'bn_IN': 'বেগুনী', 'am': 'ወይን ጠጅ', 'et': 'violetne', 'uk': 'фіалковий', 'pt_BR': 'violeta', 'kk': 'күлгін', 'te': 'వంకాయరంగు', 'br': 'mouk', 'is': 'fjólublátt', 'km': 'ស្វាយ', 'bs': 'ljubičasta', 'eu': 'bioleta', 'hu': 'ibolyakék|ibolya|viola', 'cy': 'fioled', 'pa_IN': 'ਵੈਂਗਣੀ', 'ast': 'violeta', 'gug': 'violeta', 'vi': 'Tím xanh', 'as': 'বেঙুনীয়া', 'gd': 'purpaidh', 'or': 'ବାଇଗଣି', 'ja': 'すみれ色|バイオレット|ヴァイオレット|violet', 'nn': 'fiolett|violet', 'nb': 'fiolett|violet', 'be': 'бэзавы', 'gl': 'violeta', 'ar': 'بنفسجي', 'en_US': 'violet', 'sk': 'Fialová', 'sr': 'љубичаста', 'zh_CN': '紫罗兰|蓝紫|violet', 'eo': 'viola', 'ta': 'ஊதா', 'ca_valencia': 'violat|violeta', 'ne': 'बैजनी', 'ca': 'violat|violeta', 'si': 'ජම්බුල වර්ණය', 'ug': 'بىنەپشە', 'ka': 'იისფერი'},
'ERR_BLOCK':{'lt': 'Klaida (per daug arba per mažai tarpų skliausteliuose?)', 'sid': 'Soro (qoqqowubbate aana ledote woy hawamme fooquwa?)', 'fi': 'Virhe (liikaa tai liian vähän välejä sulkumerkkien vieressä?)', 'ro': 'Eroare (spații sau paranteze în plus sau lipsă?)', 'lv': 'Kļūda (liekas vai trūkstošas atstarpes pie iekavām?)', 'kn': 'ದೋಷ (ಆವರಣಗಳಲ್ಲಿ ಹೆಚ್ಚುವರಿ ಅಂತರಗಳು ಇವೆಯೆ ಅಥವ ಕಾಣಿಸುತ್ತಿಲ್ಲವೆ?)', 'hsb': 'Zmylk (přidatne abo falowace mjezoty pola spinkow?)', 'es': 'Error (¿faltan o sobran espacios en los corchetes?)', 'vec': 'Eror (spasi in pì o in manco so łe parèntezi?)', 'el': 'Σφάλμα (πρόσθετα ή ελλείποντα κενά στις παρενθέσεις;)', 'sv': 'Fel (för många eller saknade blanksteg vid parenteser?)', 'hr': 'Greška (ima previše ili nedostaje razmaka u zagradama?)', 'cs': 'Chyba (přebývající nebo chybějící mezery u závorek?)', 'sr_Latn': 'Greška (mogući višak ili manjak razmaka uz zagrade?)', 'pl': 'Błąd (nadmiarowe lub brakujące spacje w nawiasach?)', 'he': 'שגיאה (יכול להיות שיש יותר מדי או שאין רווחים עם הסוגריים?)', 'nl': 'Error (extra of ontbrekende spaties bij haakjes?)', 'de': 'Fehler (zusätzliche oder fehlende Leerstelle bei Klammern?)', 'hi': 'त्रुटि (ब्रैकेट में अतिरिक्त या अनुपस्थित स्थान?)', 'ml': 'പിശക്', 'id': 'Galat (spasi ekstra atau kurang pada kurung?)', 'gu': 'ભૂલ (વધારાની અથવા ગેરહાજર જગ્યાઓ કૌંસમાં છે?)', 'ko': '오류 (괄호안에 불필요하게 추가되었거나 누락된 빈칸)', 'zh_TW': '錯誤 (括弧中有額外空格或遺漏空格？)', 'et': 'Viga (liiga palju või vähe tühikuid sulgude juures?)', 'ru': 'Ошибка (лишние или недостающие пробелы в скобках?)', 'sl': 'Napaka (odvečni ali manjkajoči presledki pri oklepajih?)', 'bn_IN': 'ত্রুটি (ব্র্যাকেটে অতিরিক্ত বা অনুপস্থিত স্পেস?)', 'am': 'ስህተት (ተጨማሪ ወይንም በቅንፉ ውስጥ ባዶ ቦታ የለም?)', 'mr': 'त्रुटी (ब्रॅकेट्सकडील अगाउ किंवा न आढळलेली मोकळी जागा?)', 'uk': 'Помилка (надлишок або нестача пробілів у дужках?)', 'pt_BR': 'Erro (há espaços faltando ou a mais nos colchetes?)', 'kk': 'Қате (жақша ішіндегі бос аралықтар артық немесе жетіспейді?)', 'te': 'దోషం (బ్రాకెట్ల వద్ద అదనపు లేదా లేని ఖాళీలు వున్నాయా?)', 'br': "Fazi (esaouioù a vank pe a zo re etre ar c'hrommelloù ?)", 'is': 'Villa (vantar eða er ofaukið bilum við sviga?)', 'km': 'កំហុស (បាត់\u200b ឬ\u200bមាន\u200bចន្លោះ\u200bបន្ថែម\u200bនៅ\u200bវង់\u200bក្រចក?)', 'nb': 'Feil (ekstra eller manglende mellomrom ved parenteser?)', 'bg': 'Грешка (излишни или липсващи интервали при скоби?)', 'bs': 'Greška (viška ili fali razmaka u ragradama?)', 'eu': 'Errorea (zuriuneak soberan edo faltan parentesietan?)', 'hu': 'Hiba (hiányzó vagy felesleges szóköz a kapcsos zárójelnél?)', 'cy': 'Gwall (bylchau ychwanegol neu goll wrth y cromfachau?)', 'ast': 'Error (¿sobren o falten espacios nos paréntesis?)', 'it': 'Errore (spazi aggiuntivi o mancanti alle parentesi?)', 'tr': 'Hata (köşeli ayraçlarda fazladan veya eksik boşluk?)', 'oc': 'Error (espacis suplementaris o mancants entre las parentèsis ?)', 'da': 'Fejl (ekstra eller manglende mellemrum ved kantede parenteser?)', 'as': 'ত্ৰুটি (ব্ৰেকেটসমূহত অতিৰিক্ত অথবা সন্ধানহিন স্পেইচ?)', 'gd': 'Mearachd (cus àitichean no feadhainn a dhìth aig na bracaidean?)', 'or': 'ତ୍ରୁଟି (ବନ୍ଧନିଗୁଡ଼ିକରେ ଅତିରିକ୍ତ କିମ୍ବା ଅନୁପସ୍ଥିତ ଖାଲିସ୍ଥାନ ଅଛି?)', 'ja': 'エラー(括弧の辺りにスペースが重複または不足しているかもしれません)', 'nn': 'Feil (Kan vera feil bruk av mellomrom ved parentesar)', 'fr': 'Erreur (espaces supplémentaires ou manquants entre les parenthèses ?)', 'pt': 'Erro (espaços em falta ou a mais nos parênteses?)', 'gl': 'Erro (espazos extra ou que faltan nas parénteses?)', 'ar': 'خطأ (مسافات إضافية أو مفقودة في الأقواس؟)', 'en_US': 'Error (extra or missing spaces at brackets?)', 'sk': 'Chyba (nadbytočné nebo chýbajúce medzery pri zátvorkách?)', 'sr': 'Грешка (могући вишак или мањак размака уз заграде?)', 'zh_CN': '错误 (括号处多用或少用了空格?)', 'eo': 'Eraro (ekstra aŭ mankanta spaceto ĉe krampoj?)', 'ta': 'பிழை (பிறையடைப்புகளில் இடைவெளிகள் கூடுதலாக அல்லது விடுபட்டுள்ளதா?)', 'ca_valencia': "S'ha produït un error (espais extra o omesos als parèntesis?)", 'ga': 'Earráid (spásanna breise nó ar iarraidh in aice leis na lúibíní?)', 'ca': "S'ha produït un error (espais extra o omesos als parèntesis?)", 'be': 'Памылка (лішнія ці недастатковыя прабелы ў дужках?)', 'ug': 'خاتالىق (تىرناقتا بوشلۇق ئاز ياكى كۆپ؟)'},
'TURNLEFT':{'lt': 'kairėn|kr', 'th': 'ซ้าย|เลี้ยวซ้าย|lt', 'sid': 'gura|guraraqole|gr', 'fi': 'vasemmalle|vas', 'ro': 'left|turnleft|lt|stânga', 'lv': 'pa_kreisi|kreisi|gk', 'kn': 'ಎಡ|ಎಡಕ್ಕೆ ತಿರುಗಿಸು|lt', 'hsb': 'nalěwo|nl', 'tr': 'sol|soladön|sl', 'es': 'izquierda|giraizquierda|iz|gi', 'el': 'αριστερά|στροφήαριστερά|αρ|left|turnleft|lt', 'hr': 'lijevo|okreni lijevo|li', 'cs': 'vlevo|vl', 'de': 'links|li', 'he': 'שמאלה|לפנותשמאלה|פנייהשמאלה|שמ', 'nl': 'links|linksaf|ls', 'hu': 'balra|b', 'ko': '왼쪽|왼쪽으로회전|lt', 'zh_TW': '左|左轉|left|turnleft|lt', 'mr': 'डावे|डावीकडे वळा|lt', 'ru': 'влево|поворот_налево|л', 'sl': 'levo|obrnilevo|lv', 'am': 'ግራ|ወደ ግራ ማዟሪያ|ወደ ግራ', 'et': 'vasakule|vasakpööre|v', 'uk': 'ліворуч|поворот_ліворуч|лв', 'pt_BR': 'paraEsquerda|pe|girarEsquerda|giraEsquerda', 'kk': 'солға|солға_бұрылу|с', 'km': 'ឆ្វេង|turnleft|lt', 'nb': 'venstre|snu venstre|ve', 'bs': 'lijevo|skrenilijevo|lt', 'eu': 'ezkerra|ezkerrera|ezk', 'ast': 'izquierda|xiraizquierda|xi', 'gug': 'asúpe|jereasúpe|as', 'or': 'ବାମକୁ|ବାମକୁ ଯାଆନ୍ତୁ|lt', 'ja': '左|左に曲がる|left|turnleft|lt', 'nn': 'venstre|snu venstre|ve|left', 'fr': 'gauche|tournegauche|ga', 'be': 'улева|паварот_улева|лв', 'sq': 'majtaj|kthehumajtas|lt', 'gl': 'esquerda|voltaesquerda|lt', 'ar': 'لليسار', 'en_US': 'left|turnleft|lt', 'sk': 'vľavo|vl', 'eo': 'maldekstren|turnu_liven|lt', 'ca_valencia': 'esquerra|giraesquerra|gira.esquerra|ge', 'ca': 'esquerra|giraesquerra|gira.esquerra|ge', 'zh_CN': '左|左转|left|turnleft|lt'},
'NAVY':{'lt': 'jūros', 'sid': 'baaruwolqa', 'fi': 'laivasto', 'lv': 'tumšzils', 'kn': 'ಗಾಢಬೂದು ನೀಲಿ', 'hsb': 'ćmowomódry', 'tr': 'lacivert', 'es': 'azul.marino|marino', 'vec': 'blè marina', 'el': 'θαλασσί|navy', 'hr': 'tamnoplava', 'cs': 'tmavomodrá', 'sr_Latn': 'mornarsko plava', 'he': 'כחולכהה', 'nl': 'navyblauw', 'de': 'dunkelblau', 'hi': 'नेवी', 'ml': 'നേവി', 'gu': 'નેવી', 'ko': '군청색', 'zh_TW': '海藍|靛|深藍|navy', 'mr': 'नेव्हि', 'ru': 'тёмно-синий', 'sl': 'mornarskomodra', 'bn_IN': 'অাকাশি', 'am': 'የባህር ኃይል', 'et': 'meresinine', 'uk': 'темно-синій', 'pt_BR': 'marinho', 'kk': 'қою_көк', 'te': 'నావి', 'br': 'glaz mor', 'is': 'flotablátt', 'km': 'ខៀវ\u200bចាស់', 'bs': 'mornarska', 'eu': 'itsasurdina', 'hu': 'sötétkék', 'cy': 'glas y llynges', 'ast': 'azulmarín|marín', 'gug': 'hovy.marino|marino', 'as': 'ইষৎনীলা', 'gd': "gorm a' chabhlaich", 'or': 'ଗାଢ଼ ନୀଳ', 'ja': '濃い青|ネイビー|navy', 'nn': 'marineblå|navy', 'nb': 'marineblå|navy', 'be': 'цёмна-сіні', 'gl': 'mariño', 'ar': 'أزرق_بحري', 'en_US': 'navy', 'sk': 'tmavomodrá', 'sr': 'морнарско плава', 'zh_CN': '海蓝|深蓝|navy', 'eo': 'malhelblua', 'ta': 'நேவி', 'ca_valencia': 'blau.marí|marí', 'ca': 'blau.marí|marí', 'oc': 'blaumarina'},
'PENCAP':{'lt': 'pieštuko.pabaiga|linijos.pabaiga|pp', 'uk': 'шапка пера|шапка лінії', 'ja': 'ペンのはじ|線のはじ|linecap', 'pt_BR': 'mudarPontaDoLápis|mPonLa|mPonLi', 'kk': 'сызық_басы|сызық_аяғы', 'fi': 'viivanpää', 'br': 'pennkreion|pennlinenn', 'ro': 'pencap|linecap|capătstilou', 'fr': 'coiffecrayon|coiffeligne', 'pa_IN': 'ਪੈੱਨ ਕੈਪIਲਾਈਨ ਕੈਪ', 'kn': 'ಲೇಖನಿಕ್ಯಾಪ್|ಸಾಲಿನಕ್ಯಾಪ್', 'eu': 'lumaestalkia|marraestalkia', 'hr': 'vrh olovke|vrh linije', 'es': 'fin.línea|punta.línea|fl', 'el': 'άκρογραφίδας|άκρογραμμής|pencap|linecap', 'lv': 'spalvas_gals|līnijas_gals', 'ast': 'finllapiz|finllinia', 'gug': 'tapabolígrafo|kyta.línea', 'oc': 'coifagredon|coifalinha', 'cs': 'zakončenípera|zakončeníčáry', 'de': 'stiftende|linienende|se|le', 'tr': 'kalemyazısı|satıryazısı', 'nl': 'peneinde|lijneinde', 'he': 'סיומתעט|סיומתקו', 'hsb': 'kónčkpisaka|linijowykónčk|kp|lk', 'nn': 'linjeende|pencap|linecap', 'nb': 'linjeende|pencap|linecap', 'hu': 'tollhegy|vonalvég', 'gl': 'rematelápis|remateliña', 'en_US': 'pencap|linecap', 'sk': 'zakončeniepera|zakončeniečiary|zp|zč', 'ko': '펜끝|선끝', 'eo': 'plumĉapo/liniĉapo', 'ca_valencia': 'tap.llapis|final.línia|extrem.línia', 'zh_TW': '筆端帽|線端帽|線端|pencap|linecap', 'et': 'jooneots', 'zh_CN': '笔帽|线帽|笔端帽|线端帽|pencap|linecap', 'ru': 'угол_пера|угол_линии', 'sl': 'konicaperesa|konicačrte', 'ug': 'قەلەم ئىزى|سىزىق ئىزى|pencap|linecap', 'am': 'የብዕር መገናኛ |የመስመር መገናኛ', 'ca': 'tap.llapis|final.línia|extrem.línia'},
'GLOBAL':{'lt': 'išorinis', 'sid': 'kalqe', 'sk': 'globálne', 'kk': 'жалпы', 'fi': 'yhteinen', 'br': 'hollek', 'is': 'víðvært', 'km': 'សកល\u200b', 'uk': 'загальне', 'lv': 'globāls', 'kn': 'ಜಾಗತಿಕ', 'hsb': 'globalny', 'tr': 'küresel', 'ja': 'どこからでも見える|グローバル|global', 'el': 'καθολικό|global', 'hr': 'opći', 'cs': 'globální', 'as': 'বিশ্বব্যাপী', 'nl': 'globaal', 'bs': 'opšte', 'he': 'כללי', 'eu': 'globala', 'hu': 'globális|globálisváltozó|globvál', 'hi': 'वैश्विक', 'cy': 'byd eang', 'gu': 'વૈશ્વિક', 'en_US': 'global', 'te': 'గ్లోబల్', 'ko': '전역', 'or': 'ଜାଗତିକ', 'ar': 'عمومي', 'zh_TW': '全域|共用|global', 'mr': 'ग्लोबल', 'eo': 'ĉie', 'zh_CN': '全局|共用|global', 'ru': 'общее', 'sl': 'globalno', 'bn_IN': 'গ্লোবাল', 'am': 'አለም አቀፍ', 'et': 'üldine'},
'ERR_INDEX':{'lt': 'Rodyklė už ribų', 'sid': 'Hakkageeshshu gobayiidi mashalaqisaancho.', 'fi': 'Indeksimuuttuja arvoalueen ulkopuolella.', 'ro': 'Index în afara intervalului.', 'lv': 'Indekss ir ārpus diapazona.', 'kn': 'ಸೂಚಿಯು ವ್ಯಾಪ್ತಿಯ ಹೊರಗಿದೆ.', 'hsb': 'Indeks zwonka wobłuka.', 'es': 'Índice fuera del intervalo.', 'vec': "Ìndeze fora de l'area.", 'el': 'Δείκτης εκτός περιοχής.', 'sv': 'Indexet ligger utanför intervallet.', 'hr': 'Indeks je izvan raspona.', 'cs': 'Index mimo rozsah.', 'sr_Latn': 'indeksiranje van opsega.', 'pl': 'Indeks poza zakresem.', 'he': 'האינדקס מחוץ לטווח.', 'nl': 'Index buiten gedefinieerd bereik.', 'de': 'Index außerhalb des Bereichs.', 'hi': 'अनुक्रमणिका दायरे से बाहर है.', 'ml': 'സൂചിക പരിധിയ്ക്കു് പുറത്തു്', 'id': 'Indeks di luar jangkauan.', 'gu': 'અનુક્રમણિકા વ્યાખ્યાયિત મર્યાદાની બહાર છે.', 'ko': '범위 외의 인덱스', 'zh_TW': '索引超出範圍。', 'et': 'Indeks vahemikust väljas.', 'ru': 'Индекс вне диапазона.', 'sl': 'Kazalo je izven območja.', 'bn_IN': 'সূচি মান সীমাবহির্ভূত।', 'am': 'ማውጫው ከተወሰነው ውጪ ነው', 'mr': 'इंडेक्स आउट ऑफ रेंज.', 'uk': 'Індекс поза діапазоном.', 'pt_BR': 'Índice fora do intervalo.', 'kk': 'Индекс ауқымнан тыс.', 'te': 'విషయసూచిక విస్తృతి బయటవుంది.', 'br': 'Ibil er maez eus al lijorenn.', 'is': 'Vísir er ekki innan skilgreinds sviðs.', 'km': 'លិបិក្រម\u200bក្រៅ\u200bជួរ។', 'nb': 'Indeksen er utenfor området.', 'bg': 'Индекс извън обхвата.', 'bs': 'Indeks van opsega.', 'eu': 'Indizea barrutitik kanpo.', 'hu': 'Nem létező elemre hivatkozás.', 'cy': "Mynegai tu allan o'r ystod.", 'ast': 'Índiz fuera de rangu.', 'it': "Indice fuori dall'area.", 'tr': 'Dizin aralık dışında.', 'oc': 'Indèx en defòra de la plaja.', 'da': 'Indeks uden for tilladt område.', 'as': 'সূচী বিস্তাৰৰ বাহিৰ।', 'gd': 'Tha an clàr-amais taobh a-muigh na rainse.', 'or': 'ଅନୁକ୍ରମଣିକା ପରିସର ବାହାରେ ଅଛି।', 'ja': 'インデックスが範囲外です。', 'nn': 'Indeksen er utanfor området.', 'fr': 'Index en dehors de la plage.', 'pt': 'Índice fora do intervalo', 'gl': 'Índice fóra de intervalo.', 'ar': 'الفهرس خارج المجال.', 'en_US': 'Index out of range.', 'sk': 'Index je mimo rozsahu.', 'sr': 'индексирање ван опсега.', 'zh_CN': '索引越界。', 'eo': 'Indekso ekster amplekso.', 'ta': 'குறியீடு வரம்பைத் தாண்டியுள்ளது.', 'ca_valencia': "L'índex és fora de l'interval.", 'ga': 'Innéacs as raon.', 'ca': "L'índex és fora de l'interval.", 'be': 'Індэкс па-за абсягам.', 'ug': 'ئىندېكىس دائىرىدىن ھالقىدى.'},
'IN':{'lt': 'kur', 'th': 'น.', 'sid': 'giddo', 'zu': 'phakathi', 'fi': ':ssa|:ssä', 'mk': 'инчи', 'ro': 'in|în', 'lv': 'iekš', 'as': 'ইন', 'hsb': 'w', 'xh': 'ngaphakathi', 'el': 'στο', 'dz': 'ཨའི་ཨེན།', 'hr': 'dolazno', 'tn': 'gare', 'cs': 'z', 'he': 'בתוך', 'eo': 'en', 'hu': '-ban|-ben', 'hi': 'इंच', 'nso': 'go', 'mn': 'дотор', 'ts': 'endzeni', 'sd': '۾', 'zh_TW': '自|in', 'mr': 'इन', 'bo': 'དབྱིན་ཚུན།', 'mai': 'इँच', 'sl': 'v', 'bn_IN': 'ইঞ্চি', 'am': 'ኢንች', 'et': 'hulgas', 'uk': 'дюйм', 'kmr_Latn': 'înç', 'pt_BR': 'em', 'kk': 'ішінде', 'te': 'లోపల', 'af': 'dm', 'is': 'í', 'tg': 'ин', 'km': 'គិត\u200bជា', 'nb': 'tommer|in', 'kok': 'इंच', 'bs': 'u', 'eu': 'hemen', 'sw_TZ': 'katika', 'ks': 'میں', 'cy': 'mod', 'my': 'လက်မ', 'ast': 'en', 'gug': 'en', 'fa': 'اینچ', 'lo': 'ໃນ', 'or': 'ରେ', 'gd': 'òirleach', 'ru': 'в', 'ja': 'を次から取り出して|in', 'nn': 'i|in', 'fr': 'dans', 'br': 'e', 'oc': 'dins', 'gl': 'pol', 'ar': 'في', 'ug': 'ديۇيم', 'es': 'en', 'zh_CN': '自|in', 'bn': 'ইঞ্চি', 'ta': 'அங்.', 'ca_valencia': 'a|en', 'ca': 'a|en', 'dgo': 'इं', 'uz': 'dyuym', 'mni': 'ইন', 'en_US': 'in', 'ka': 'დი'},
'DECIMAL':{'lt': ',', 'hsb': ',', 'nb': ',', 'hu': ',', 'fi': ',', 'en_US': '.', 'nn': ',', 'ca_valencia': ',', 'ca': ',', 'et': ',', 'ast': ',', 'cs': ',', 'de': ',', 'eo': ',', 'sl': ','},
'CONTINUE':{'lt': 'tęsk', 'sid': 'albisufi', 'fi': 'jatka', 'ro': 'continue|continuă', 'lv': 'turpināt', 'kn': 'ಮುಂದುವರಿಸು', 'hsb': 'dale', 'tr': 'devam', 'es': 'continuar', 'el': 'συνέχεια|continue', 'hr': 'nastavi', 'cs': 'pokračuj', 'de': 'weiter', 'he': 'המשך|להמשיך', 'nl': 'doorgaan|verdergaan', 'hu': 'újra', 'hi': 'जारी रखें', 'ml': 'തുടരുക', 'gu': 'ચાલુ રાખો', 'ko': '계속', 'zh_TW': '繼續|續|continue', 'mr': 'कंटिन्यु', 'ru': 'продолжить', 'sl': 'nadaljuj', 'bn_IN': 'পরবর্তী (~C)', 'am': 'ይቀጥሉ', 'et': 'jätka', 'uk': 'продовжити', 'pt_BR': 'continuar|continue', 'kk': 'жалғастыру', 'te': 'కొనసాగించు', 'br': "kenderc'hel", 'is': 'áfram', 'km': 'បន្ត', 'bs': 'nastavak', 'eu': 'jarraitu', 'cy': 'parhau', 'pa_IN': 'ਜਾਰੀ ਰੱਖੋ', 'ast': 'siguir', 'gug': 'segui', 'vi': 'Tiếp tục', 'as': 'অব্যাহত ৰাখক', 'or': 'ଚାଲୁରଖ', 'ja': 'はじめにもどる|continue', 'nn': 'hald fram|continue', 'nb': 'fortsett|continue', 'sq': 'vazhdo', 'oc': 'contunhar', 'gl': 'continuar', 'ar': 'تابع', 'en_US': 'continue', 'sk': 'Pokračovať', 'zh_CN': '继续|continue', 'eo': 'daŭrigu', 'ta': 'தொடர்', 'ca_valencia': 'continua', 'ne': 'जारी राख्नुहोस्', 'ca': 'continua', 'si': 'දිගටම කරගෙන යන්න (~C)', 'my': 'ဆက်လုပ်ပါ', 'ka': 'გაგრძელება'},
'YELLOW':{'lt': 'geltona', 'th': 'เหลือง', 'sid': 'baqqala', 'fi': 'keltainen', 'ro': 'yellow|galben', 'lv': 'dzeltens', 'kn': 'ಹಳದಿ', 'hsb': 'žołty', 'tr': 'sarı', 'es': 'amarillo', 'vec': 'zało', 'el': 'κίτρινο|yellow', 'hr': 'žuta', 'cs': 'žlutá', 'sr_Latn': 'žuta', 'he': 'צהוב', 'nl': 'geel', 'de': 'gelb', 'hi': 'पीला', 'ml': 'മഞ്ഞ', 'gu': 'પીળો', 'my': 'အဝါ', 'ko': '노랑', 'zh_TW': '黃|yellow', 'mr': 'पिवळा', 'ru': 'жёлтый', 'sl': 'rumena', 'bn_IN': 'হলুদ', 'am': 'ቢጫ', 'et': 'kollane', 'uk': 'жовтий', 'pt_BR': 'amarelo', 'kk': 'сары', 'te': 'పసుపు', 'br': 'melen', 'is': 'gult', 'km': 'លឿង', 'nb': 'gul|yellow', 'bs': 'žuta', 'eu': 'horia', 'hu': 'sárga', 'cy': 'melyn', 'pa_IN': 'ਪੀਲਾ', 'ast': 'mariellu', 'gug': "sa'yju", 'vi': 'Vàng', 'as': 'হালধীয়া', 'gd': 'buidhe', 'or': 'ହଳଦିଆ', 'ja': '黄|yellow', 'nn': 'gul|yellow', 'fr': 'jaune', 'be': 'жоўты', 'sq': 'e verdhë', 'oc': 'jaune', 'gl': 'amarelo', 'ar': 'أصفر', 'en_US': 'yellow', 'sk': 'žltá', 'sr': 'жута', 'zh_CN': '黄|黄色|yellow', 'eo': 'flava', 'ta': 'மஞ்சள்', 'ca_valencia': 'groc', 'ne': 'पहेलो', 'ca': 'groc', 'si': 'කහ', 'ug': 'سېرىق', 'ka': 'ყვითელი'},
'SORTED':{'fi': 'lajiteltu', 'kn': 'ವಿಂಗಡಿಸಲಾದ', 'xh': 'hlela-hlela', 'hr': 'razvrstano', 'de': 'sortiert', 'he': 'עםמיון', 'nl': 'gesorteerd', 'hu': 'rendez', 'ml': 'വകതിരിച്ച', 'st': 'hlophilwe', 'ko': '정렬', 'mr': 'सॉर्टेड', 'mai': 'सोर्ट कएल गेल', 'am': 'ተለይቷል', 'et': 'sorditud', 'kk': 'сұрыпталған', 'te': 'క్రమబద్దీకరించబడినది', 'af': 'gesorteer', 'tg': 'низомнокшуда', 'km': 'បាន\u200bតម្រៀប', 'fr': 'trié', 'kok': 'वर्गीकृत', 'eu': 'ordenatua', 'pa_IN': 'ਲੜੀਬੱਧ', 'vi': 'đã sắp xếp', 'lo': 'ຈັດລຽງ', 'gd': 'air a sheòrsachadh', 'rw': 'bishunguwe', 'hsb': 'sortěrowany', 'nb': 'sortert|sorted', 'sq': 'klasifikuar', 'om': "foo'amaa", 'en_US': 'sorted', 'sk': 'zoradené', 'br': 'rummet', 'ta': 'அடுக்கப்பட்டது', 'dgo': 'छांटेआ', 'my': 'စနစ်တကျစီထားသည်', 'lt': 'rikiuok', 'th': 'เรียง', 'sid': 'diramino', 'zu': 'ihleliwe', 'ss': 'kuhlelekile', 'mk': 'Подредување', 'ro': 'sorted|sortat', 'lv': 'sakārtots', 'as': 'বৰ্গীকৰণ কৰি থোৱা', 'nn': 'sortert|sorted', 'es': 'ordenado', 'el': 'ταξινομημένα|sorted', 'dz': 'དབྱེ་སེལ་འབད་ཡོདཔ།', 'tn': 'bakantswe', 'cs': 'seřazeno', 'sl': 'razvrščeno', 'hi': 'छांटा हुआ', 'gu': 'ગોઠવાયેલ', 've': 'yo dzudzanywa', 'sd': 'वर्गीकृत केलेले', 'zh_TW': '排序|sorted', 'sat': 'साला आकान', 'bo': 'range_lookup', 'ru': 'отсортировано', 'nso': 'arogantšwe', 'bn_IN': 'বিন্যস্ত', 'uk': 'сортований', 'kmr_Latn': 'Rêzkirî', 'pt_BR': 'ordenado', 'bn': 'বিন্যস্ত', 'is': 'raðað', 'bs': 'sortirano', 'sa_IN': 'क्रमितम्', 'sw_TZ': 'i-liyopangwa', 'ks': 'ساٹ كرمُت', 'ast': 'ordenao', 'tr': 'sıralanmış', 'brx': 'थाखो खालाखानाय', 'mn': 'эрэмбэлэгдсэн', 'or': 'ସଜାହୋଇଥିବା', 'ja': '並び替える|ソート|sorted', 'cy': 'trefnwyd', 'nr': 'hleliwe', 'fa': 'مرتب\u200cشده', 'gl': 'ordenado', 'ar': 'افرز', 'oc': 'triat', 'zh_CN': '排序|sorted', 'eo': 'ordigita', 'ca_valencia': 'ordenat', 'ne': 'क्रमबद्व गरिएको', 'ca': 'ordenat', 'si': 'සුබෙදන ලදි', 'ts': 'xaxametiwile', 'uz': 'saralangan', 'mni': 'মথং-মনাও শেম্লবা'},
'GROUP':{'lt': 'piešinys', 'sid': 'misile|mis', 'fi': 'kuva', 'ro': 'picture|pic|imagine', 'lv': 'attēls|att', 'kn': 'ಚಿತ್ರ|pic', 'hsb': 'wobraz|wb', 'tr': 'resim|res', 'es': 'imagen|img', 'el': 'εικόνα|εικ|picture|pic', 'hr': 'slika|slika', 'cs': 'obrázek|obr', 'de': 'bild', 'he': 'תמונה|תמ', 'nl': 'afbeelding|afb', 'hu': 'kép', 'ko': '사진|pic', 'zh_TW': '圖片|圖|圖組|picture|pic', 'mr': 'चित्र|पिक', 'ru': 'изображение|изо', 'sl': 'slika|sli', 'am': 'ስእል|ስእል', 'et': 'pilt', 'uk': 'зображення|зобр', 'pt_BR': 'agrupar|grupo|grp|figura', 'kk': 'сурет|сур', 'km': 'រូបភាព|pic', 'nb': 'bilde|fig|picture', 'bs': 'slika|pic', 'eu': 'irudia|irud', 'ast': 'figura|fig', 'gug': "ta'anga|img", 'oc': 'imatge|img', 'or': 'ଛବି|pic', 'ja': '図|図のグループ|picture|pic', 'nn': 'bilete|fig|picture', 'fr': 'image|ima', 'gl': 'imaxe|imx', 'ar': 'رسم|صور', 'en_US': 'picture|pic', 'sk': 'obrázok|obr', 'eo': 'bildo|b', 'ca_valencia': 'figura|fig', 'ca': 'figura|fig', 'zh_CN': '图片|图|图组|组|picture|pic|group'},
'HIDETURTLE':{'lt': 'slėpk.vėžliuką|slėpkis|sl', 'sid': 'bukukaamamaaxi|bukukaamamaaxi|bm|anemaaxi', 'fi': 'piilotakonna|pk', 'ro': 'hideturtle|ht|hideme|invizibil', 'lv': 'slēpt_rupuci|sr|slēpt_mani', 'kn': 'ಆಮೆಅಡಗಿಸು|ht|ನನ್ನನ್ನುಅಡಗಿಸು', 'hsb': 'schować', 'tr': 'kaplumbağagizle|kg|gizlebeni', 'es': 'ocultartortuga|ot|ocultarme', 'el': 'απόκρυψηχελώνας|αχ|κρύψεμε|hideturtle|ht|hideme', 'hr': 'sakrikursor|sk|sakrijme', 'cs': 'skryjželvu|skryj|sž', 'de': 'verbergen', 'he': 'הסתרצב|להסתירצב|הסתרתהצב|להסתיראותי|הס', 'nl': 'verberg|vb', 'hu': 'elrejt|láthatatlan|elrejtteknőc|rejttek', 'ko': '거북이숨기기|ht|숨기기', 'zh_TW': '隱藏海龜|隱藏|hideturtle|ht|hideme', 'mr': 'हाइडटर्टल|ht|हाइडमि', 'ru': 'скрыть_черепаху|сч|скрыть_меня', 'sl': 'skrijželvo|sž|skrijme', 'am': 'ኤሊ መደበቂያ|ht|ይደብቁኝ', 'et': 'peida|peida_kilpkonn|pk', 'uk': 'сховай_черепашку|сч', 'pt_BR': 'desaparecerTat|dt|desapareçaTat|ocultarTat|escondeTat', 'kk': 'тасбақаны_жасыру|тж|мені_жасыру', 'br': 'kuzhatbaot|ht|hideme', 'nb': 'skjulmeg|sm|hideturtle', 'bs': 'sakrijkornjaču|ht|sakrijmene', 'eu': 'ezkutatudortoka|ed|ezkutatuni', 'ast': 'anubretortuga|anubrime|at', 'gug': 'mokañykarumbe|ñk|añeñomi', 'oc': 'amagartortuga|mt|amagar', 'or': 'କଇଁଛଲୁଚାଇବା|ht|hideme', 'ja': 'タートルを隠す|hideturtle|ht', 'nn': 'gøymmeg|gm|hideturtle', 'fr': 'cachetortue|ct|cachemoi', 'gl': 'agochartartaruga|at|agocharme', 'ar': 'أخف_السلحفاة|أخف', 'en_US': 'hideturtle|ht|hideme', 'sk': 'skrykorytnačku|skry|sk', 'eo': 'kaŝu_testudon|kt', 'ca_valencia': 'amaga.tortuga|oculta.tortuga|at|ot', 'ca': 'amaga.tortuga|oculta.tortuga|at|ot', 'zh_CN': '隐藏海龟|隐龟|隐藏龟|hideturtle|ht|hideme'},
'PENWIDTH':{'lt': 'pieštuko.storis|linijos.storis|ps', 'sid': 'biiretebikka|biiretebaqo|xuruurubaqo|bb', 'fi': 'kynänleveys|kl', 'ro': 'pensize|penwidth|linewidth|ps|mărimestilou', 'lv': 'spalvas_izmērs|spalvas_platums|līnijas_platums|sp', 'kn': 'ಲೇಖನಿಗಾತ್ರ|ಲೇಖನಅಗಲ|ರೇಖೆಅಗಲ|ps', 'hsb': 'wulkosćpisaka|šěrokosćpisaka|šěrokosćlinije|wp|wl', 'tr': 'kalemboyutu|kalemgenişliği|satırgenişliği|kb', 'es': 'tamaño.lápiz|tl', 'el': 'μέγεθοςγραφίδας|πλάτοςγραφίδας|πλάτοςγραμμής|μγ|pensize|penwidth|linewidth|ps', 'hr': 'veličina olovke|širina olovke|širina linije|vo', 'cs': 'tloušťkapera|tloušťkačáry|tp', 'de': 'stiftbreite|linienbreite|sb|lb', 'he': 'גודלעט|עוביעט|רוחבעט|גע', 'nl': 'pengrootte|pendikte|penbreedte|pg', 'hu': 'tollvastagság|tollvastagság!|tv!?|vonalvastagság', 'ko': '펜크기|펜너비|선너비|ps', 'zh_TW': '筆大小|筆粗|線粗|pensize|penwidth|linewidth|ps', 'mr': 'पेनआकार|पेनरूंदी|रेघरूंदी|ps', 'ru': 'размер_пера|толщина_пера|толщина_линии|тл', 'sl': 'velikostperesa|širinaperesa|širinačrte|vp', 'am': 'የ ብዕር መጠን |የ ብዕር ስፋት |የ መስመር ስፋት |ps', 'et': 'pliiatsi_paksus|pliiatsi_jämedus|joonepaksus|joonelaius|jl', 'uk': 'розмір_пера|ширина_пера|ширина_лінії|рп', 'pt_BR': 'mudarEspessuraDoLápis|mEspLa', 'kk': 'қалам_өлшемі|қалам_жуандығы|сызық_жуандығы|сж', 'km': 'ទំហំ\u200bប៉ិក|penwidth|linewidth|ps', 'nb': 'pennstørrelse|pennbredde|linjebredde|ps', 'bs': 'veličinaolovke|širinaolovke|širinalinije|ps', 'eu': 'lumatamaina|lumazabalera|marrazabalera|lz', 'ast': 'llapiztamañu|llapizanchor|lliniaanchor|lt', 'gug': 'tamaño.bolígrafo|tb', 'or': 'ପେନଆକାର|ପେନଓସାର|ଧାଡ଼ିଓସାର|ps', 'mn': 'үзэгний өргөн|шугамын өргөн|үөр|шөр', 'ja': 'ペンの太さ|線の太さ|penwidth|ps', 'nn': 'pennstorleik|pennbreidd|linjebreidd|ps|pensize', 'fr': 'tailleplume|taillecrayon|largeurligne|ta', 'gl': 'estilotamaño|estilolargura|larguraliña|et', 'ar': 'حجم_القلم|عرض_القلم', 'en_US': 'pensize|penwidth|linewidth|ps', 'sk': 'hrúbkapera|hrúbkačiary|hp|hč', 'eo': 'plumlarĝo|plumgrando|pg', 'ca_valencia': 'mida.llapis|mida.línia|ml', 'ca': 'mida.llapis|mida.línia|ml', 'zh_CN': '笔大小|笔粗|线粗|pensize|penwidth|linewidth|ps'},
'CLEARSCREEN':{'lt': 'valyk.vėžliuko.lauką|vvl', 'sid': 'coichaleelshalba|cl', 'fi': 'tyhjennänäyttö|tn', 'ro': 'clearscreen|cs|ștergeecran', 'lv': 'attīrīt_ekrānu|ae', 'kn': 'ತೆರೆಅಳಿಸು|cs', 'hsb': 'čisćić', 'tr': 'ekranıtemizle|cs', 'es': 'limpiar.pantalla|lp|cs', 'el': 'καθαρισμόςοθόνης|κο|clearscreen|cs', 'hr': 'očistizaslon|oz', 'cs': 'smažobrazovku|so', 'de': 'säubern', 'he': 'לנקותמסך|ניקוימסך|נקהמסך|נמ', 'nl': 'schermleegmaken|schoon|sl', 'hu': 'törölképernyő|törölkép|törölrajzlap|tr', 'ko': '화면지우기|cs', 'zh_TW': '清除畫面|清畫面|清除|clearscreen|cs', 'mr': 'क्लिअरस्क्रिन|cs', 'ru': 'очистить_экран|оэ', 'sl': 'počistizaslon|pz', 'am': 'መመልከቻ ማጽጃ|መ.ማ', 'et': 'puhasta_ekraan|pe', 'uk': 'очистити_екран|ое', 'pt_BR': 'tartaruga|tat', 'kk': 'экранды_тазарту|эт', 'br': 'skarzhañskramm|cs', 'is': 'hreinsaskjá|hs', 'km': 'សម្អាត\u200bអេក្រង់|cs', 'nb': 'tømskjermen|ts|clearscreen', 'bs': 'očistiekran|cs', 'eu': 'garbitupantaila|gp', 'ast': 'llimpiapantalla|lp', 'gug': 'monandipantalla|mp', 'or': 'ପରଦା ପରିଷ୍କାର|cs', 'ja': '画面を消す|clearscreen|cs', 'nn': 'tømskjermen|ts|clearscreen', 'fr': 'effaceécran|ee', 'gl': 'limparpantalla|lp', 'ar': 'محو_الشاشة|محو', 'en_US': 'clearscreen|cs', 'sk': 'zmažobrazovku|zo', 'eo': 'vakigi_ekranon|ek', 'ca_valencia': 'neteja.dibuix|inicia.dibuix|net|id', 'ca': 'neteja.dibuix|inicia.dibuix|net|id', 'zh_CN': '清屏|清除|clearscreen|cs'},
'WHILE':{'lt': 'kol', 'sid': 'waajjo', 'fi': 'kunhan', 'ro': 'while|până', 'lv': 'kamēr', 'kn': 'ಬಿಳಿ', 'hsb': 'doniž', 'tr': 'beyaz', 'es': 'mientras', 'el': 'όσο|while', 'hr': 'bijela', 'cs': 'dokud', 'de': 'solange', 'he': 'כלעוד', 'nl': 'zolang', 'hu': 'amíg', 'hi': 'के दौरान', 'gu': 'સફેદ', 'ko': '흰색', 'zh_TW': '當|while', 'mr': 'व्हाइल', 'ru': 'пока', 'sl': 'dokler', 'bn_IN': 'যেখানে', 'am': 'ትንሽ', 'et': 'kuniks', 'uk': 'поки', 'pt_BR': 'enquanto', 'kk': 'дейін', 'te': 'జరుగుతున్నప్పుడు', 'br': 'e pad ma', 'is': 'meðan', 'nb': 'mens|while', 'bs': 'dok', 'eu': 'bitartean', 'pa_IN': 'ਚਿੱਟਾ', 'ast': 'mentanto', 'gug': 'jave', 'or': 'ଯେତେବେଳେ', 'ja': 'くりかえすのは次の間|while', 'nn': 'medan|while', 'fr': 'pendant', 'sq': 'ndërsa', 'gl': 'mentres', 'ar': 'طالما', 'en_US': 'while', 'sk': 'Biela', 'zh_CN': '当|while', 'eo': 'dum', 'ca_valencia': 'mentre', 'ne': 'सेतो', 'ca': 'mentre', 'si': 'සුදු', 'oc': 'mentre', 'ka': 'თეთრი'},
'AQUA':{'lt': 'žydra', 'th': 'สีน้ำทะเล|สีฟ้าอมเขียว (Cyan)', 'sid': 'aqua|cyaan', 'fi': 'syaani', 'lv': 'gaišzils', 'kn': 'ನೀಲಿಹಸಿರು|ಹಸಿರುನೀಲಿ', 'hsb': 'akwamarinwoy|cyanowy', 'tr': 'gök mavisi', 'es': 'agua|cian', 'el': 'ανοιχτόγαλάζιο|aqua|cyan', 'hr': 'vodena|cijan', 'cs': 'azurová', 'sr_Latn': 'vodeno plava|cijan', 'he': 'ים|ציאן|מים', 'nl': 'water|cyaan', 'de': 'türkis|cyan', 'ko': '아쿠아|시안', 'zh_TW': '青藍|青|水藍|aqua|cyan', 'mr': 'ॲक्वा|सिअन', 'ru': 'голубой', 'sl': 'vodenomodra|cijanska', 'am': 'ዉሀ|አረንጓዴ', 'et': 'rohekassinine|tsüaan', 'uk': 'блакитний', 'pt_BR': 'ciano', 'kk': 'көгілдір', 'br': 'dour|cyan', 'is': 'blágrænt', 'bs': 'vodena|cyan', 'eu': 'ura|cyana', 'hu': 'ciánkék|cián', 'ast': 'agua|cian', 'gug': 'y|cian', 'or': 'ପାଣି|cyan', 'gd': 'aqcua|saidhean', 'ja': 'アクア|シアン|aqua', 'nn': 'cyanblå|cyan', 'nb': 'cyanblå|cyan', 'be': 'блакітны', 'gl': 'auga|ciano', 'ar': 'سماوي|سيان', 'en_US': 'aqua|cyan', 'sk': 'azúrová', 'sr': 'водено плава|цијан', 'zh_CN': '青|青色|aqua|cyan', 'eo': 'cejanblua', 'ca_valencia': 'cian', 'ca': 'cian', 'oc': 'aqua|cian'},
'SOLID':{'lt': 'vientisas', 'th': 'ทึบ', 'sid': 'kaajjado', 'fi': 'yhtenäinen', 'ro': 'solid|continuu', 'lv': 'vienlaidu', 'kn': 'ಘನ', 'hsb': 'połny', 'tr': 'düz', 'es': 'sólido', 'el': 'συμπαγές|solid', 'hr': 'puno', 'cs': 'plná', 'de': 'voll', 'he': 'אחיד', 'nl': 'vol', 'hu': 'folyamatos', 'hi': 'ठोस', 'gu': 'ઘટ્ટ', 'ko': '단색', 'sd': 'ٺوس', 'zh_TW': '實線|solid', 'mr': 'गडद', 'sat': 'जिनिस', 'ru': 'сплошная', 'sl': 'polno', 'sa_IN': 'ठोस', 'bn_IN': 'নিরেট', 'am': 'ሙሉ', 'et': 'pidev', 'uk': 'суцільна', 'pt_BR': 'sólido', 'kk': 'бүтін', 'te': 'గట్టి', 'br': 'unvan', 'is': 'einlitt', 'km': 'តាន់', 'nb': 'ensfarget|solid', 'bs': 'čvrsto', 'eu': 'solidoa', 'cy': 'solet', 'pa_IN': 'ਗੂੜ੍ਹਾ', 'ast': 'sólidu', 'gug': 'hatã', 'vi': 'Đặc', 'as': 'কঠিন', 'gd': 'soladach', 'or': 'କଠିନ', 'ja': '実線|ふつうの線|solid', 'nn': 'einsfarga|solid', 'fr': 'plein', 'be': 'суцэльны', 'oc': 'plen', 'gl': 'sólido', 'ar': 'صلب', 'en_US': 'solid', 'sk': 'vyplnené', 'zh_CN': '实线|solid', 'eo': 'solida', 'ta': 'திடம்', 'ca_valencia': 'sòlid', 'ne': 'ठोस', 'ca': 'sòlid', 'ug': 'ئۇيۇل', 'ka': 'მყარი'},
'ERR_NAME':{'lt': 'Nežinoma komanda: „%s“.', 'uk': 'Невідома назва: “%s”.', 'ja': '不明な名前: “%s”。', 'sr_Latn': 'Nepoznato ime: „%s“.', 'kk': 'Аты белгісіз: "%s".', 'fi': 'Tuntematon nimi: ”%s”.', 'ro': 'Nume necunoscut: „%s”.', 'fr': 'Nom inconnu : “%s”.', 'lv': 'Nezināms nosaukums: “%s”.', 'nn': 'Ukjend namn: «%s».', 'tr': 'Bilinmeyen ad: “%s”.', 'es': 'Nombre desconocido: «%s».', 'pt': 'Nome desconhecido: “%s”', 'el': 'Άγνωστο όνομα: “%s”.', 'bg': 'Непознато име: „%s“.', 'it': 'Nome sconosciuto: “%s”.', 'hr': 'Nepoznato ime: “%s”.', 'pt_BR': 'Nome desconhecido: “%s”', 'da': 'Ukendt navn: “%s”.', 'de': 'Unbekannter Name: „%s“.', 'gd': 'Ainm neo-aithnichte: “%s”.', 'cs': 'Neznámý název: „%s“.', 'sl': 'Neznano ime: “%s”.', 'hsb': 'Njeznate mjeno: “%s”.', 'eu': 'Izen ezezaguna: ‘%s”.', 'nb': 'Ukjent navn: «%s».', 'hu': 'Ismeretlen név: „%s”.', 'gl': 'Nome descoñecido: «%s».', 'id': 'Nama tak dikenal: "%s".', 'cy': 'Enw anhysbys: “%s”.', 'en_US': 'Unknown name: “%s”.', 'sk': 'Neznámy názov: „%s“.', 'sr': 'Непознато име: „%s“.', 'eo': 'Nekonata nomo: ‘%s”.', 'ca': 'Nom desconegut: «%s».', 'vec': 'Nome mìa conosesto: “%s”.', 'et': 'Tundmatu nimi: „%s”.', 'ru': 'Неизвестное имя: «%s».', 'be': 'Невядомая назва: “%s”.', 'zh_CN': '未知名称：“%s”。', 'am': 'ያልታወቀ ስም: “%s”.', 'nl': 'Onbekende naam: ‘%s”.'},
'FONTCOLOR':{'lt': 'šrifto.spalva|teksto.spalva', 'sid': 'borangichukuula|borrotekuula|borrotekuulamme', 'fi': 'fontinväri', 'ro': 'fontcolor|textcolor|textcolour|culoarefont', 'lv': 'fonta_krāsa|teksta_krāsa', 'kn': 'ಅಕ್ಷರಶೈಲಿಬಣ್ಣ|ಪಠ್ಯಬಣ್ಣ|ಪಠ್ಯಬಣ್ಣ', 'hsb': 'pismowabarba|tekstowabarba|pb|tb', 'tr': 'yazıtipirengi|metinrengi|metinrengi', 'es': 'color.texto|color.letra', 'el': 'χρώμαγραμματοσειράς|χρώμακειμένου|fontcolor|textcolor|textcolour', 'hr': 'boja fonta|boja teksta|boja teksta', 'cs': 'barvapísma|barvatextu', 'de': 'schriftfarbe|textfarbe|schf|tf', 'he': 'צבעגופן|צבעפונט|צבעטקסט', 'nl': 'letterkleur|tekstkleur', 'hu': 'betűszín', 'ko': '글꼴색상|글자색상|글자색상', 'zh_TW': '字型顏色|文字顏色|字型色彩|文字色彩|字色|fontcolor|textcolor|textcolour', 'mr': 'फाँटरंग|मजकूररंग|मजकूररंग', 'ru': 'цвет_шрифта|цвет_текста', 'sl': 'barvapisave|barvačrk|barvabesedila', 'am': 'የ ፊደል ቀለም|የ ጽሁፍ ቀለም|የ ጽሁፍ ቀለም', 'et': 'fondi_värv|teksti_värv', 'uk': 'колір_символів|колір_тексту', 'pt_BR': 'mudarCorDaLetra|mCorLe', 'kk': 'қаріп_түсі|мәтін_түсі', 'km': 'ពណ៌\u200bពុម្ពអក្សរ|textcolor|textcolour', 'nb': 'tekstfarge|textcolor', 'bs': 'bojafonta|bojateksta|bojateksta', 'eu': 'letrakolorea|testukolorea', 'ast': 'colorlletra|colortestu', 'gug': "sa'y.moñe'ẽrã|sa'y.letra", 'or': 'ଅକ୍ଷରରୂପରଙ୍ଗ|ପାଠ୍ୟରଙ୍ଗ|textcolour', 'ja': '文字の色|fontcolor', 'nn': 'tekstfarge|textcolor', 'fr': 'couleurpolice|couleurtexte|ctexte', 'gl': 'cordeletra|cordetexto|cordetexto', 'ar': 'لون_الخط', 'en_US': 'fontcolor|textcolor|textcolour', 'sk': 'farbapísma|farbatextu|fp|ft', 'eo': 'tiparkoloro|tekstokoloro|tk', 'ca_valencia': 'color.lletra|color.text', 'ca': 'color.lletra|color.text', 'zh_CN': '文字颜色|字体颜色|字颜色|字色|fontcolor|textcolor|textcolour'},
'FONTTRANSPARENCY':{'en_US': 'fonttransparency|texttransparency'},
'ERR_KEY':{'lt': 'Nežinomas elementas: %s', 'sid': 'Afaminokki miila: %s', 'fi': 'Tuntematon elementti: %s', 'ro': 'Element necunoscut: %s', 'lv': 'Nezināms elements — %s', 'kn': 'ಗೊತ್ತಿರದ ಘಟಕ: %s', 'hsb': 'Njeznaty element: %s', 'tr': 'Bilinmeyen öge: %s', 'es': 'Elemento desconocido: %s', 'vec': 'Ełemento mìa conosesto: %s', 'el': 'Άγνωστο στοιχείο: %s', 'sv': 'Okänt element: %s', 'hr': 'Nepoznati element: %s', 'cs': 'Neznámý prvek: %s', 'sr_Latn': 'Nepoznati element: %s', 'pl': 'Nieznany element: %s', 'he': 'רכיב לא ידוע: %s', 'nl': 'Onbekend element %s', 'de': 'Unbekanntes Element: %s', 'hi': 'अज्ञात तत्व: %s', 'ml': 'അപരിചിതമായ എലമെന്റ്: %s', 'id': 'Elemen tak diketahui: %s', 'gu': 'અજ્ઞાત ઘટક: %s', 'ko': '알수 없는 요소: %s', 'zh_TW': '未知元素：%s', 'et': 'Tundmatu element: %s', 'ru': 'Неизвестный элемент: %s', 'sl': 'Neznan element: %s', 'bn_IN': 'অজানা স্বত্বা %s', 'am': 'ያልታወቀ አካል: %s', 'mr': 'अपरिचीत एलिमेंट: %s', 'uk': 'Невідомий елемент: %s', 'pt_BR': 'Elemento desconhecido: %s', 'kk': 'Белгісіз элемент: %s', 'te': 'తెలియని మూలకం: %s', 'br': 'Elfenn dianav : %s', 'is': 'Óþekkt stak: %s', 'km': 'មិន\u200bស្គាល់\u200bធាតុ៖ %s', 'nb': 'Ukjent element: %s', 'bg': 'Непознат елемент: %s', 'bs': 'Nepoznat element: %s', 'eu': 'Elementu ezezaguna: %s', 'hu': 'Ismeretlen elem: %s', 'cy': 'Elfen anhysbys: %s', 'ast': 'Elementu desconocíu: %s', 'it': 'Elemento sconosciuto: %s', 'gug': "Elemento ojekuaa'ỹva: %s", 'oc': 'Element desconegut : %s', 'da': 'Ukendt element: %s', 'as': 'অজ্ঞাত উপাদান: %s', 'gd': 'Eileamaid neo-aithnichte: %s', 'or': 'ଅଜଣା ଉପାଦାନ: %s', 'ja': '不明な要素: %s', 'nn': 'Ukjent element: %s', 'fr': 'Élément inconnu : %s', 'pt': 'Elemento desconhecido: %s', 'gl': 'Elemento descoñecido: %s', 'ar': 'عنصر مجهول: %s', 'en_US': 'Unknown element: %s', 'sk': 'Neznámy prvok: %s', 'sr': 'Непознати елемент: %s', 'zh_CN': '未知元素: %s', 'eo': 'Nekonata elemento: %s', 'ta': 'தெரியாத கூறு: %s', 'ca_valencia': "L'element «%s» no és conegut.", 'ga': 'Eilimint anaithnid: %s', 'ca': "L'element «%s» no és conegut.", 'be': 'Невядомы элемент: %s', 'ug': 'يوچۇن ئېلېمېنت: %s'},
'INPUT':{'lt': 'įvesk', 'sid': 'eo', 'fi': 'syötä', 'ro': 'input|intrare', 'lv': 'ievade', 'kn': 'ಇನ್\u200cಪುಟ್\u200c', 'hsb': 'zapodaće', 'tr': 'girdi', 'es': 'entrada', 'el': 'είσοδος|input', 'hr': 'unos', 'cs': 'vstup', 'de': 'eingabe', 'he': 'קלט', 'nl': 'invoer', 'hu': 'be', 'hi': 'इनपुट', 'ml': 'ഇന്\u200dപുട്ട്', 'gu': 'ઈનપુટ', 'ko': '입력', 'sd': 'اِن پُٽ', 'zh_TW': '輸入|input', 'mr': 'इंपुट', 'sat': 'आदेर', 'ru': 'ввод', 'sl': 'vnos', 'bn_IN': 'ইনপুট', 'am': 'ማስገቢያ', 'et': 'sisend', 'uk': 'ввести', 'pt_BR': 'ler|leia', 'kk': 'кіріс', 'te': 'ఇన్పుట్', 'br': 'enankañ', 'is': 'inntak', 'km': '\u200bបញ្ចូល', 'nb': 'inndata|input', 'bs': 'ulaz', 'eu': 'sarrera', 'cy': 'mewnbwn', 'pa_IN': 'ਇੰਪੁੱਟ', 'ast': 'entrada', 'gug': 'jeikeha', 'vi': 'Nhập', 'or': 'ନିବେଶ', 'ja': '値を聞く|input', 'nn': 'inndata|input', 'fr': 'saisie', 'be': 'увод', 'gl': 'entrada', 'ar': 'أدخِل', 'en_US': 'input', 'sk': 'Vstup', 'zh_CN': '输入|input', 'eo': 'enigu', 'ta': 'உள்ளீடு', 'ca_valencia': 'entrada', 'ne': 'आगत', 'ca': 'entrada', 'si': 'ආදානය', 'dgo': 'इनपुट', 'oc': 'picada', 'ka': 'შეტანა'},
'ITALIC':{'lt': 'kursyvas', 'sid': 'hawiitto-borro', 'fi': 'kursivointi', 'ro': 'italic|cursiv', 'lv': 'kursīvs', 'kn': 'ಇಟಾಲಿಕ್', 'hsb': 'kursiwny', 'tr': 'italik', 'es': 'cursiva', 'vec': 'corsivo', 'el': 'πλάγια|italic', 'hr': 'kurziv', 'cs': 'kurzíva', 'de': 'kursiv', 'pl': 'kursywa', 'he': 'נטוי', 'nl': 'cursief', 'hu': 'kurzív|dőlt', 'hi': 'तिरछा', 'ml': 'ചരിഞ്ഞ', 'gu': 'ઇટાલિક', 'my': 'စာလုံးစောင်း', 'ko': '이탤릭체', 'sd': 'اِٽيلڪ', 'zh_TW': '斜體|斜|italic', 'mr': 'तिरके', 'sat': 'कोचे ओलाक्', 'ru': 'курсив', 'sl': 'ležeče', 'sa_IN': 'इटेलिक', 'bn_IN': 'তির্যক', 'am': 'ማዝመሚያ', 'et': 'kaldkiri|kursiiv', 'uk': 'курсив', 'pt_BR': 'itálico', 'kk': 'курсив', 'te': 'వాలు', 'br': 'stouet', 'is': 'skáletrað', 'km': 'ទ្រេត', 'nb': 'kursiv|italic', 'bs': 'koso', 'eu': 'etzana', 'cy': 'italig', 'pa_IN': 'ਤਿਰਛੇ', 'ast': 'cursiva', 'gug': 'cursiva', 'vi': 'Nghiêng', 'as': 'ইতালিক', 'gd': 'eadailteach', 'or': 'ତେର୍ଚ୍ଛା', 'ja': '斜め|斜体|italic', 'nn': 'kursiv|italic', 'fr': 'italique', 'be': 'курсіў', 'oc': 'italica', 'gl': 'cursiva', 'ar': 'مائل', 'en_US': 'italic', 'sk': 'Kurzíva', 'zh_CN': '斜体|斜|italic', 'eo': 'kursiva', 'ta': 'சாய்வு', 'ca_valencia': 'cursiva|itàlica', 'ne': 'छड्के', 'ca': 'cursiva|itàlica', 'si': 'ඇල අකුරු', 'dgo': 'इटैलिक', 'ug': 'يانتۇ', 'ka': 'კურსივი'},
'INVISIBLE':{'lt': 'nematoma', 'sid': 'leellannokkiha', 'fi': 'näkymätön', 'ro': 'invisible|invizibil', 'lv': 'neredzams', 'kn': 'ಅದೃಶ್ಯ', 'hsb': 'njewidźomny', 'tr': 'görünmez', 'el': 'αόρατο|invisible', 'hr': 'nevidljiv', 'cs': 'neviditelná', 'de': 'ohne', 'he': 'בלתי נראה', 'nl': 'onzichtbaar', 'hu': 'láthatatlan', 'hi': 'अदृश्य', 'ml': 'അദൃശ്യമായ', 'gu': 'અદ્ધશ્ય', 'ko': '숨김', 'zh_TW': '看不見|隱形|invisible', 'mr': 'अदृश्य', 'ru': 'невидимый', 'sl': 'nevidno', 'bn_IN': 'অদৃশ্য', 'am': 'የማይታይ', 'et': 'nähtamatu', 'uk': 'невидимий', 'pt_BR': 'invisível', 'kk': 'жасырын', 'te': 'అగోచరమైన', 'br': 'diwelus', 'is': 'ósýnilegt', 'km': 'មើល\u200bមិន\u200bឃើញ', 'bs': 'nevidljivo', 'eu': 'Ikusezina', 'cy': 'anweledig', 'pa_IN': 'ਅਦਿੱਖ', 'gug': 'nojekuaái', 'vi': 'Vô hình', 'as': 'অদৃশ্য', 'gd': 'do-fhaicsinneach', 'or': 'ଅଦୃଶ୍ଯ', 'ja': '見えない|不可視|invisible', 'nn': 'usynleg|invisible', 'nb': 'usynlig|invisible', 'be': 'нябачны', 'sq': 'i padukshëm', 'gl': 'invisíbel', 'ar': 'مخفي', 'en_US': 'invisible', 'sk': 'Neviditeľná', 'zh_CN': '看不见|不可见|invisible', 'eo': 'nevidebla', 'ta': 'தென்படாத', 'ne': 'अदृश्य', 'si': 'අදිසි', 'my': 'မမြင်နိုင်သော', 'ka': 'უხილავი'},
'PAGESIZE':{'lt': 'lapo.kampas', 'sid': 'qoolubikka', 'fi': 'sivukoko', 'ro': 'pagesize|mărimepagină', 'lv': 'lappuses_izmērs', 'kn': 'ಪುಟದಗಾತ್ರ', 'hsb': 'wulkosćstrony|ws', 'tr': 'sayfa boyutu', 'es': 'tamañopágina', 'el': 'μέγεθοςσελίδας|pagesize', 'hr': 'veličinastranice', 'cs': 'velikoststránky', 'de': 'seite', 'he': 'גודלעמוד', 'nl': 'paginagrootte', 'hu': 'oldalméret', 'ml': 'താള്\u200dവ്യാപ്തി', 'gu': 'પાનાંમાપ', 'ko': '페이지크기', 'zh_TW': '頁面大小|紙張大小|頁大小|紙大小|pagesize', 'mr': 'पेजसाइज', 'ru': 'размер_страницы', 'sl': 'velikoststrani', 'bn_IN': 'কাগজের মাপ', 'am': 'የ ገጽ መጠን', 'et': 'lehe_suurus', 'uk': 'розмір_сторінки', 'pt_BR': 'tamanhoDaPágina|tamPág', 'kk': 'бет_өлшемі', 'te': 'పేజీపరిమాణం', 'br': 'ment ar bajenn', 'km': 'ទំហំ\u200bទំព័រ', 'nb': 'sidestørrelse|pagesize', 'bs': 'veličinastranice', 'eu': 'orritamaina', 'ast': 'tamañupaxina', 'gug': 'tamañorogue', 'or': 'ପୃଷ୍ଠା ଆକାର', 'ja': 'ページサイズ|pagesize', 'nn': 'sidestorleik|pagesize', 'fr': 'taillepage', 'be': 'памеры_старонкі', 'gl': 'tamaño da páxina', 'ar': 'حجم_الصفحة', 'en_US': 'pagesize', 'sk': 'veľkosťstránky|vs', 'zh_CN': '页面大小|纸张大小|纸大小|页大小|pagesize', 'eo': 'paĝogrando', 'ca_valencia': 'mida.pàgina|mp', 'ca': 'mida.pàgina|mp', 'oc': 'talhapagina'},
'SET':{'lt': 'parink', 'sid': 'qineessi', 'fi': 'joukko', 'lv': 'iestatīt', 'hsb': 'mnohosć', 'tr': 'ayarla', 'es': 'conjunto', 'el': 'σύνολο|set', 'hr': 'skup', 'cs': 'množina', 'de': 'menge', 'he': 'קבוצה', 'nl': 'set|instellen', 'hu': 'halmaz', 'gu': 'સુયોજન', 'ko': '설정', 'sd': 'سيٽ', 'zh_TW': '集合|set', 'mr': 'सेट', 'sat': 'साजाव', 'ru': 'установить', 'sl': 'množica', 'bn_IN': 'সেট', 'am': 'ማሰናጃ', 'et': 'hulk', 'uk': 'встановити', 'pt_BR': 'conjunto', 'kk': 'орнату', 'br': 'arventenn', 'km': 'កំណត់', 'is': 'setja', 'nb': 'sett|set', 'kok': 'संचSonch', 'bs': 'postavi', 'eu': 'ezarri', 'ast': 'establecer', 'gug': 'aty', 'or': 'ସେଟ', 'ja': '同じ値を一つに|集合に|集合|set', 'sa_IN': 'सॆट', 'fr': 'fixe', 'gl': 'estabelecer', 'ar': 'مصفوفة', 'en_US': 'set', 'sk': 'množina', 'eo': 'aro', 'ca_valencia': 'conjunt', 'ca': 'conjunt', 'dgo': 'सैट्ट करो', 'zh_CN': '集合|set'},
'CM':{'th': 'ซม.', 'uk': 'см', 'mk': 'см', 'kk': 'см', 'bn': 'সেমি', 'is': 'sm', 'tg': 'см', 'km': 'ស.ម.', 'kok': 'सेंमी', 'kn': 'ಸೆಂ.ಮಿ', 'sw_TZ': 'sm', 'ks': 'سینٹی میٹر', 'nr': 'i-cm', 'el': 'εκατοστά|cm', 'dz': 'སི་ཨེམ', 'as': 'ছে.মি.', 'mn': 'см', 'ru': 'см', 'or': 'ସେଣ୍ଟିମିଟର', 'he': 'ס"מ|ס״מ', 'be': 'см', 'zh_CN': '厘米|cm', 'hi': 'सेमी', 'ml': 'സിമി', 'st': 'sm', 'ar': 'سم', 'om': 'sm', 'en_US': 'cm', 'my': 'စင်တီမီတာ', 'bn_IN': 'সেমি', 'ta': 'செ.மீ', 'tt': 'см', 'ne': 'सेन्टिमिटर', 'zh_TW': '公分|cm', 'dgo': 'सैं.मी.', 'uz': 'sm', 'bo': 'ལིའི་སྨི།', 'mai': 'सेमी', 'ja': 'センチ|センチメートル|cm', 'mni': 'সে.মি.', 'ug': 'سانتىمېتىر', 'am': 'ሴ/ሚ', 'ka': 'სმ'},
'TURNRIGHT':{'lt': 'dešinėn|dš', 'th': 'ขวา|เลี้ยวขวา|rt', 'sid': 'qiniite|qiniitiraqoli|qt', 'fi': 'oikealle|oik', 'ro': 'right|turnright|rt|dreapta', 'lv': 'pa_labi|labi|gl', 'kn': 'ಬಲ|ಬಲಕ್ಕೆ ತಿರುಗಿಸು|rt', 'hsb': 'naprawo|np', 'tr': 'sağ|sağadön|sğ', 'es': 'derecha|giraderecha|de|gd', 'el': 'δεξιά|στροφήδεξιά|δξ|right|turnright|rt', 'hr': 'desno|okreni desno|de', 'cs': 'vpravo|vp', 'de': 'rechts|re', 'he': 'ימינה|לפנותימינה|פנייהימינה|ימ', 'nl': 'rechts|rechtsaf|rs', 'hu': 'jobbra|j', 'ko': '오른쪽|오른쪽으로회전|rt', 'zh_TW': '右|右轉|right|turnright|rt', 'mr': 'उजवी|उजवीकडे वळा|rt', 'ru': 'вправо|поворот_направо|п', 'sl': 'desno|obrnidesno|ds', 'am': 'ቀኝ|ወደ ቀኝ ማዟሪያ|ወደ ቀኝ', 'et': 'paremale|parempööre|p', 'uk': 'праворуч|поворот_праворуч|пр', 'pt_BR': 'paraDireita|pd|girarDireita|giraDireita', 'kk': 'оңға|оңға_бұрылу|о', 'br': 'dehou|trotudehou|de', 'km': 'ស្ដាំ|turnright|rt', 'nb': 'høyre|snu høyre|hg', 'bs': 'desno|skrenidesno|rt', 'eu': 'eskuina|eskuinera|esk', 'ast': 'drecha|xiradrecha|xd', 'gug': 'akatúa|jereakatúa|ak', 'or': 'ଡ଼ାହାଣ|ଡ଼ାହାଣକୁ ଯାଆନ୍ତୁ|rt', 'ja': '右|右に曲がる|right|turnright|rt', 'nn': 'høgre|snu høgre|hg|right', 'fr': 'droite|tournedroite|dr', 'be': 'управа|паварот_управа|пр', 'sq': 'djathtas|kthehudjathtas|rt', 'gl': 'dereita|voltadereita|rt', 'ar': 'لليمين', 'en_US': 'right|turnright|rt', 'sk': 'vpravo|vp', 'zh_CN': '右|右转|right|turnright|rt', 'eo': 'dekstren|turnu_dekstren|dt', 'ca_valencia': 'dreta|giradreta|gira.dreta|gd', 'ca': 'dreta|giradreta|gira.dreta|gd', 'oc': 'dreita|virardreita|de'},
'IF':{'lt': 'jeigu.tiesa', 'sid': 'ikkiro', 'fi': 'jos', 'ro': 'if|dacă', 'lv': 'ja', 'kn': 'ಇದು ಆದಲ್ಲಿ', 'nn': 'dersom|viss|if', 'tr': 'eğer', 'es': 'si', 'el': 'αν|if', 'hr': 'ako', 'cs': 'když', 'de': 'wenn', 'he': 'אם', 'nl': 'als', 'hu': 'ha', 'hi': 'यदि', 'ml': 'എങ്കില്\u200d', 'gu': 'જો', 'zh_TW': '若|if', 'mr': 'इफ', 'sat': 'IF', 'ru': 'если', 'sl': 'če', 'sa_IN': 'IF', 'bn_IN': 'যদি', 'am': 'ከ', 'et': 'kui', 'uk': 'якщо', 'pt_BR': 'se', 'kk': 'егер', 'te': 'ఒకవేళ', 'br': 'mar', 'is': 'ef', 'nb': 'dersom|hvis|if', 'kok': 'IF', 'bs': 'ako', 'eu': 'bada', 'ast': 'si', 'gug': 'si', 'or': 'ଯଦି', 'ja': 'もし|if', 'hsb': 'jeli', 'fr': 'si', 'gl': 'se', 'ar': 'إن', 'en_US': 'if', 'sk': 'ak', 'zh_CN': '如果|若|if', 'eo': 'se', 'ca_valencia': 'si', 'ca': 'si', 'dgo': 'IF', 'oc': 'se'},
'RIGHTSTRING':{'lt': '“|”|’', 'hsb': '“|‘|"|\'', 'hu': '”', 'fi': '"|\'|”', 'en_US': '”|’', 'sk': '“|"', 'nn': '”|’|»', 'es': '”|’|»', 'el': '”|’|"|\'', 'et': '”|“', 'zh_TW': '」|』|”|’', 'cs': '“|"', 'de': '“|‘|"|\'', 'zh_CN': '」|』|”|’'},
'STR':{'lt': 'teksto.eilutė|te', 'uk': 'рядок', 'kk': 'жол', 'fi': 'mjono', 'br': 'hedad', 'lv': 'virkne', 'hsb': 'znamješka', 'be': 'радок', 'el': 'συμβολοσειρά|str', 'tr': 'dizi', 'cs': 'řetězec', 'de': 'zeichen', 'he': 'מחרוזת', 'fr': 'car', 'hu': 'karakterlánc|lánc', 'ar': 'سلسلة', 'en_US': 'str', 'sk': 'reťazec', 'eo': 'ĉeno', 'zh_TW': '字串|str', 'et': 'sõne|string', 'ru': 'строка', 'sl': 'niz', 'zh_CN': '字串|字符串|str', 'ja': '文字列|文字列に|str', 'mr': 'स्ट्रिंग'},
'COUNT':{'lt': 'kiek', 'th': 'นับ', 'sid': 'kiiri', 'fi': 'lukumäärä', 'mk': 'Број', 'ro': 'count|contor', 'pa_IN': 'ਗਿਣਤੀ', 'kn': 'ಎಣಿಕೆ', 'hsb': 'ličić', 'tr': 'sayım', 'es': 'conteo', 'el': 'πλήθος|count', 'dz': 'གྱངས་ཁ་རྐྱབས།', 'hr': 'brojanje', 'cs': 'počet', 'de': 'zähle', 'mn': 'тоо хэмжээ', 'he': 'ספירה', 'nl': 'Aantal', 'hu': 'darab|db|elemszám', 'hi': 'गिनती', 'brx': 'साननाय', 'gu': 'ગણતરી', 'sl': 'preštej', 'ko': '수', 'br': 'Niver', 'zh_TW': '計數|count', 'mr': 'काउंट', 'sat': 'लेखाक्', 'mai': 'गिनती', 'rw': 'kubara', 'sa_IN': 'गणना', 'oc': 'nb_decimalas', 'am': 'መቁጠሪያ', 'et': 'loenda', 'uk': 'кількість', 'kmr_Latn': 'Bihijmêre', 'pt_BR': 'contagem', 'kk': 'саны', 'te': 'లెక్క', 'af': 'telling', 'is': 'fjöldi', 'tg': 'Шумора', 'km': 'ចំនួន', 'nb': 'tell|count', 'kok': 'गणन', 'bs': 'mjesta', 'eu': 'zenbaketa', 'sw_TZ': 'hesabu', 'ks': 'شمار', 'cy': 'cyfrif', 'lv': 'skaits', 'ast': 'contéu', 'gug': 'econta', 'vi': 'đếm', 'lo': 'ນັບ', 'as': 'গণনা', 'gd': 'cunntas', 'ru': 'количество', 'or': 'ଗଣନା', 'ja': '文字数|持っている数|count', 'nn': 'tel|plassar|count', 'fr': 'compte', 'sq': 'numëro', 'ml': 'എണ്ണം', 'gl': 'decimais', 'ar': 'عُدّ', 'om': "baay'ina", 'en_US': 'count', 'sk': 'počet', 'zh_CN': '计数|count', 'eo': 'nombru', 'ta': 'எண்ணிக்கை', 'ca_valencia': 'compte', 'ne': 'गणना', 'ca': 'compte', 'si': 'ගණන් කරන්න', 'dgo': 'गिनतरी', 'uz': 'Miqdor', 'mni': 'মশিং থীয়ু', 'my': 'ရေတွက်ပါ', 'ka': 'თვლა'},
'UPRIGHT':{'lt': 'įprastinis', 'sid': 'aliqiniitira|rosaminoha', 'fi': 'pysty', 'ro': 'upright|normal|înpicioare', 'lv': 'taisns|normāls', 'kn': 'ನೆಟ್ಟಗೆ|ಸಾಮಾನ್ಯ', 'hsb': 'normalny', 'tr': 'üstsağ|normal', 'es': 'normal', 'el': 'όρθιο|κανονικό|upright|normal', 'hr': 'uspravan|normalan', 'cs': 'normální', 'de': 'normal', 'he': 'רגיל|עומד', 'nl': 'rechtop|normaal', 'hu': 'álló|normál', 'ko': '우상단|일반', 'zh_TW': '正體|正|一般|upright|normal', 'mr': 'उभे|सामान्य', 'ru': 'прямой|обычный', 'sl': 'pokonci|navadno', 'am': 'ቀጥተኛ|መደበኛ', 'et': 'püstine|tavaline', 'uk': 'прямий|звичайний', 'pt_BR': 'vertical', 'kk': 'тура|қалыпты', 'br': 'a-serzh|normal', 'is': 'upprétt|venjulegt', 'km': 'ស្ដាំ|ធម្មតា', 'nb': 'stående|normal', 'bs': 'goredesno|normalno', 'eu': 'tente|normala', 'ast': 'normal', 'gug': 'normal', 'or': 'ଡ଼ାହାଣପାଖ ଉପର|normal', 'ja': 'ふつう|標準|upright', 'nn': 'normal|upright', 'fr': 'hautdroit|normal', 'gl': 'vertical|normal', 'ar': 'معتدل|عادي', 'en_US': 'upright|normal', 'sk': 'normálne|no', 'eo': 'rekta|vertikala|normala', 'ca_valencia': 'vertical|normal', 'ca': 'vertical|normal', 'zh_CN': '正体|正|一般|upright|normal'},
'PRINT':{'lt': 'spausdink|spd|rašyk', 'sid': 'attami', 'fi': 'tulosta', 'ro': 'print|afișează', 'lv': 'drukāt', 'kn': 'ಮುದ್ರಿಸು', 'hsb': 'ćišćeć', 'tr': 'yazdır', 'es': 'imprimir|escribir', 'el': 'τύπωσε|print', 'hr': 'ispis', 'cs': 'piš', 'de': 'ausgabe', 'he': 'הדפסה', 'nl': 'afdrukken', 'hu': 'ki|kiír', 'hi': 'छापें', 'ml': 'പ്രിന്റ് ചെയ്യുക', 'gu': 'છાપો', 'ko': '인쇄', 'zh_TW': '印出|print', 'mr': 'प्रिंट', 'ru': 'печать', 'sl': 'izpiši', 'bn_IN': 'মুদ্রণ', 'am': 'ማተሚያ', 'et': 'kirjuta|prindi', 'uk': 'друк', 'pt_BR': 'escrever|esc|escreva', 'kk': 'баспа', 'te': 'ముద్రణ', 'br': 'moullañ', 'is': 'prenta', 'km': 'បោះ\u200b\u200bពុម្ព\u200b', 'nb': 'skriv ut|skriv|print', 'bs': 'štampaj', 'eu': 'inprimatu', 'cy': 'argraffu', 'pa_IN': 'ਛਾਪੋ', 'ast': 'imprentar', 'gug': 'imprimir', 'vi': 'In', 'or': 'ମୁଦ୍ରଣ', 'gd': 'clò-bhuail', 'ja': '表示|print', 'nn': 'skriv ut|skriv|print', 'fr': 'écris', 'be': 'друк', 'oc': 'imprimir', 'gl': 'imprimir', 'ar': 'اطبع', 'en_US': 'print', 'sk': 'Tlač', 'zh_CN': '打印|印出|print', 'eo': 'presu|p', 'ta': 'அச்சிடு', 'ca_valencia': 'imprimeix', 'ne': 'मुद्रण गर्नुहोस्', 'ca': 'imprimeix', 'si': 'මුද්\u200dරණය කරන්න', 'my': 'ပရင့်ထုတ်ပါ', 'ka': 'ბეჭდვა'},
'RESEARCH':{'lt': 'ieškok', 'sid': 'hasi', 'fi': 'etsi', 'ro': 'search|caută', 'lv': 'meklēt', 'kn': 'ಹುಡುಕು', 'hsb': 'pytać', 'tr': 'ara', 'es': 'buscar', 'el': 'αναζήτηση|search', 'hr': 'pretraživanje', 'cs': 'hledej', 'de': 'suche', 'he': 'חיפוש', 'nl': 'zoeken', 'hu': 'keres', 'hi': 'खोजें', 'ml': 'തെരയുക', 'gu': 'શોધો', 'ko': '검색', 'zh_TW': '搜尋|search', 'mr': 'शोधा', 'ru': 'найти', 'sl': 'išči', 'bn_IN': 'অনুসন্ধান', 'am': 'መፈለጊያ', 'et': 'otsi', 'uk': 'знайти', 'pt_BR': 'pesquisa', 'kk': 'іздеу', 'te': 'వెతుకు', 'br': 'klask', 'is': 'leita', 'km': 'ស្វែងរក\u200b', 'nb': 'søk|finn|search', 'bs': 'traži', 'eu': 'bilatu', 'cy': 'chwilio', 'pa_IN': 'ਲੱਭੋ', 'ast': 'guetar', 'gug': 'heka', 'vi': 'Tìm', 'as': 'সন্ধান কৰক', 'or': 'ଖୋଜନ୍ତୁ', 'ja': '探す|みつける|検索|search', 'nn': 'søk|finn|search', 'fr': 'recherche', 'be': 'знайсці', 'sq': 'kërko', 'oc': 'recercar', 'gl': 'buscar', 'ar': 'ابحث', 'en_US': 'search', 'sk': 'Hľadať', 'zh_CN': '查找|搜索|search', 'eo': 'serĉu', 'ta': 'தேடு', 'ca_valencia': 'cerca', 'ne': 'खोज गर्नुहोस्', 'ca': 'cerca', 'my': 'ရှာဖွေပါ'},
'OLIVE':{'lt': 'alyvuogių', 'sid': 'ejersa', 'fi': 'oliivi', 'lv': 'olīvu', 'kn': 'ಆಲಿವ್', 'hsb': 'oliwozeleny', 'tr': 'zeytin yeşili', 'es': 'oliva', 'vec': 'ołiva', 'el': 'λαδί|olive', 'hr': 'maslinasta', 'cs': 'olivová', 'sr_Latn': 'maslinasta', 'he': 'ירוקזית', 'nl': 'olijfgroen', 'de': 'dunkelgrün', 'hi': 'जैतून', 'ml': 'ഒലീവ്', 'gu': 'ઓલિવ', 'ko': '올리브', 'zh_TW': '橄欖綠|黃綠|olive', 'mr': 'ऑलिव्ह', 'ru': 'оливковый', 'sl': 'olivnozelena', 'bn_IN': 'জলপাই রং', 'am': 'ወይራ', 'et': 'kollakasroheline|oliivroheline|oliivikarva', 'uk': 'оливковий', 'pt_BR': 'oliva', 'kk': 'зәйтүн', 'te': 'ఆలివ్', 'br': 'olivez', 'is': 'ólífugrænt', 'km': 'អូលីវ', 'bs': 'maslinasta', 'eu': 'oliba', 'hu': 'olajzöld', 'cy': 'olewydden', 'ast': 'oliva', 'gug': 'oliva', 'as': 'জলফাই', 'gd': 'donn-uaine', 'or': 'ଓଲିଭ', 'ja': '柿色|オリーブ色|olive', 'nn': 'olivengrøn|olive', 'nb': 'olivengrønn|olive', 'be': 'аліўкавы', 'gl': 'oliva', 'ar': 'زيتوني', 'en_US': 'olive', 'sk': 'olivová', 'sr': 'маслинаста', 'zh_CN': '橄榄绿|黄绿|olive', 'eo': 'oliva', 'ta': 'ஆலிவ்', 'ca_valencia': 'oliva|verd.oliva', 'ca': 'oliva|verd.oliva', 'oc': 'oliva'},
'MIN':{'lt': 'min.|minimumas', 'sid': 'shiima', 'pt_BR': 'mínimo|mín', 'kk': 'мин', 'te': 'కనిష్ట', 'br': 'izek', 'is': 'lágm', 'sat': 'कोम उता़र, (~c)', 'km': 'នាទី', 'uk': 'мін', 'kok': 'किमान (~c)Konixtt (~c)', 'kn': 'ಕನಿಷ್ಟ', 'sa_IN': 'कम ख्तॆ कम', 'ja': 'いちばん小さな数|最小値|最小|min', 'el': 'ελάχιστο|min', 'or': 'ସର୍ବନିମ୍ନ', 'gd': 'as lugha', 'sl': 'najmanj', 'cy': 'mun', 'be': 'мін', 'ar': 'الأدنى', 'gu': 'ન્યૂનત્તમ', 'en_US': 'min', 'fi': 'pienin', 'zh_CN': '最小值|最小|min', 'sd': 'گهٽِ ۾ گهٽ', 'ca_valencia': 'mín|min', 'zh_TW': '最小值|最小|min', 'mr': 'मिन', 'dgo': 'घट्टोघट्ट', 'ru': 'мин', 'he': 'מזערי', 'bn_IN': 'সর্বনিম্ন', 'am': 'አነስተኛ', 'ca': 'mín|min'},
'TRUE':{'lt': 'tiesa', 'th': 'จริง', 'sid': 'halaale', 'fi': 'tosi', 'ro': 'true|adevărat', 'lv': 'patiess', 'kn': 'ಸತ್ಯ', 'hsb': 'wěrny', 'tr': 'doğru', 'es': 'verdadero', 'el': 'αληθής|true', 'hr': 'točno', 'cs': 'pravda', 'de': 'wahr', 'he': 'אמת', 'nl': 'waar', 'hu': 'igaz', 'hi': 'सही', 'gu': 'સાચુ', 'my': 'အမှန်', 'ko': '참', 'br': 'gwir', 'zh_TW': '真|true', 'mr': 'ट्रु', 'ru': 'истина', 'sl': 'jeresnično', 'bn_IN': 'সত্য', 'am': 'እውነት', 'et': 'tõene', 'uk': 'істина', 'kmr_Latn': 'rast e', 'pt_BR': 'verdadeiro|verd', 'kk': 'ақиқат', 'te': 'సత్యము', 'af': 'waar', 'is': 'satt', 'tg': 'саҳеҳ', 'km': 'ពិត', 'nb': 'sann|true', 'eu': 'egiazkoa', 'cy': 'gwir', 'pa_IN': 'ਸਹੀਂ', 'ast': 'braero', 'gug': 'ete', 'vi': 'đúng', 'as': 'সঁচা', 'ja': '真|なりたつ|true', 'nn': 'sann|true', 'fr': 'vrai', 'bn': 'সত্য', 'oc': 'verai', 'gl': 'verdadeiro', 'ar': 'صحيح', 'om': 'dhugaa', 'ug': 'راست', 'sk': 'pravda', 'zh_CN': '真|true', 'eo': 'vera', 'ta': 'உண்மை', 'ca_valencia': 'cert|veritat', 'ne': 'सत्य', 'ca': 'cert|veritat', 'si': 'සත්\u200dය', 'en_US': 'true', 'ka': 'ჭეშმარიტი'},
'AND':{'fi': 'ja', 'kn': 'ಮತ್ತು', 'xh': 'kunye', 'hr': 'i', 'de': 'und', 'he': 'וגם', 'nl': 'en', 'hu': 'és', 'st': 'le', 'ko': '및', 'mr': 'अँड', 'mai': 'आओर', 'am': 'እና', 'et': 'ja', 'kk': 'және', 'te': 'మరియు', 'af': 'en', 'tg': 'ва', 'km': 'និង', 'fr': 'et', 'kok': 'आनिक', 'eu': 'eta', 'lv': 'un', 'gug': 'ha', 'vi': 'và', 'gd': 'agus', 'rw': 'na', 'nn': 'og|and', 'nb': 'og|and', 'sq': 'dhe', 'om': 'fi', 'ug': 'ۋە', 'sk': 'a', 'br': 'ha', 'en_US': 'and', 'lt': 'kiekvienas', 'th': 'และ', 'sid': 'nna', 'zu': 'kanye', 'ss': 'ne', 'ro': 'and|și', 'pa_IN': 'ਅਤੇ', 'hsb': 'a', 'es': 'y', 'el': 'και|and', 'dz': 'དང་།', 'tn': 'le', 'cs': 'azároveň|az', 'sl': 'in', 'hi': 'और', 'gu': 'અને', 've': 'na', 'or': 'ଏବଂ', 'sd': '۽', 'zh_TW': '且|and', 'sat': 'आर आर', 'ru': 'и', 'nso': 'le', 'bn_IN': 'এবং', 'uk': 'та', 'kmr_Latn': 'û', 'pt_BR': 'e', 'tt': 'һәм', 'bn': 'এবং', 'is': 'og', 'bs': 'i', 'sa_IN': 'च', 'sw_TZ': 'na', 'ks': 'بےیئ', 'my': 'နှင့်', 'ast': 'y', 'tr': 've', 'brx': 'आरो', 'mn': 'ба', 'lb': 'an', 'ja': 'と|かつ|and', 'cy': 'a', 'fa': 'و', 'gl': 'e', 'ar': 'و', 'oc': 'e', 'zh_CN': '且|与|and', 'eo': 'kaj', 'ca_valencia': 'i', 'ne': 'र', 'ca': 'i', 'si': 'සහ', 'uz': 'va', 'ka': 'და'},
'PENSTYLE':{'lt': 'pieštuko.stilius|linijos.stilius', 'th': 'กระบวนแบบปากกา|กระบวนแบบเส้น', 'sid': 'biireteakata|xuruuruakata', 'fi': 'kynäntyyli', 'ro': 'penstyle|linestyle|stilstilou', 'lv': 'spalvas_stils|līnijas_stils', 'kn': 'ಲೇಖನಿಶೈಲಿ|ಗೆರೆಶೈಲಿ', 'hsb': 'stilpisaka|linijowystil|sp|ls', 'tr': 'kalembiçemi|satırbiçemi', 'es': 'estilopluma|estilolínea', 'el': 'μορφήγραφίδας|μορφήγραμμής|penstyle|linestyle', 'hr': 'stil olovke|stil linije', 'cs': 'druhpera|druhčáry', 'de': 'stiftstil|linienstil|ss|ls', 'he': 'סגנוןעט|סגנוןקו', 'nl': 'penstijl|lijnstijl|lijnopmaak', 'hu': 'tollstílus|vonalstílus', 'ko': '펜스타일|선스타일', 'zh_TW': '筆樣式|線樣式|penstyle|linestyle', 'mr': 'पेनशैली|रेघशैली', 'ru': 'стиль_пера|стиль_линии', 'sl': 'slogperesa|slogčrte', 'am': 'የብዕር ዘዴ |የ መስመር ዘዴ', 'et': 'pliiatsi_stiil|joonestiil', 'uk': 'стиль_пера|стиль_лінії', 'pt_BR': 'mudarEstiloDoLápis|mEstLa', 'kk': 'қалам_стилі|сызық_стилі', 'km': 'រចនាប័ទ្ម\u200bប៉ិក|linestyle', 'nb': 'pennstil|linjestil', 'bs': 'stilolovke|stillinije', 'eu': 'lumaestiloa|marraestiloa', 'pa_IN': 'ਪੈੱਨ ਸਟਾਈਲ|ਲਾਈਨ ਸਟਾਈਲ', 'ast': 'llapizestilu|lliniaestilu|le', 'gug': 'tipobolígrafo|estilolínea', 'or': 'ପେନଶୈଳୀ|linestyle', 'mn': 'үзэгний загвар|шугамын загвар|үз|шз', 'ja': 'ペンの種類|線の種類|penstyle', 'nn': 'pennstil|linjestil|penstyle', 'fr': 'stylecrayon|styleligne', 'gl': 'estiloestilo|estiloliña', 'ar': 'نمط_القلم', 'en_US': 'penstyle|linestyle', 'sk': 'štýlpera|štýlčiary|šp|šč', 'eo': 'plumstilo|linistilo', 'ca_valencia': 'estil.llapis|estil.línia|el', 'ca': 'estil.llapis|estil.línia|el', 'zh_CN': '笔型|线型|笔样式|线样式|penstyle|linestyle'},
'LIME':{'lt': 'citrininė', 'sid': 'boloticho', 'fi': 'limetti', 'lv': 'neonzaļš', 'kn': 'ಸಮಯ', 'hsb': 'swětłozeleny', 'tr': 'sarımsı yeşil', 'es': 'lima', 'el': 'ανοιχτοπράσινο|lime', 'hr': 'limun-žuta', 'cs': 'žlutozelená', 'sr_Latn': 'svetlo zelena', 'he': 'ליים', 'nl': 'limoen', 'de': 'hellgrün', 'hi': 'समय', 'ml': 'നാരങ്ങ', 'gu': 'લીંબુ', 'ko': '라임', 'zh_TW': '萊姆綠|亮綠|lime', 'mr': 'वेळ', 'ru': 'лимонный', 'sl': 'limetna', 'bn_IN': 'সময়', 'am': 'ሎሚ', 'et': 'laimiroheline|laimikarva', 'uk': 'лайм', 'pt_BR': 'lima', 'kk': 'ашық жасыл', 'te': 'నిమ్మరంగు', 'br': 'sitroñs', 'is': 'límónugrænt', 'km': 'បៃតង', 'nb': 'grasgrønn|lime', 'eu': 'lima', 'hu': 'világoszöld', 'cy': 'leim', 'pa_IN': 'ਸਮਾਂ', 'ast': 'llima', 'gug': 'lima', 'vi': 'Giờ', 'as': 'নেমু', 'gd': 'dath na liomaideig', 'or': 'ଲେମ୍ବୁ ରଙ୍ଗ', 'ja': '明るい緑|ライム色|lime', 'nn': 'grasgrøn|lime', 'fr': 'citron', 'be': 'ярка-зялёны', 'oc': 'limon', 'gl': 'lima', 'ar': 'ليموني', 'en_US': 'lime', 'sk': 'Čas', 'sr': 'светло зелена', 'zh_CN': '酸橙色|lime', 'eo': 'limeta', 'ta': 'எலுமிச்சை', 'ca_valencia': 'llima|verd.llima', 'ne': 'समय', 'ca': 'llima|verd.llima', 'si': 'වෙලාව', 'my': 'အချိန်', 'ka': 'დრო'},
'INCH':{'lt': 'col|"', 'uk': 'дюйм|"', 'pt_BR': 'pol|"', 'kk': 'дюйм|"', 'fi': 'tuuma', 'br': 'meutad|"', 'lv': 'colla|"', 'nn': 'tomme|in|"', 'gug': 'in|pulg|"', 'es': 'in|pulg|"', 'el': 'ίντσα|in|"', 'tr': 'inç|"', 'or': 'ଇଞ୍ଚ|"', 'gd': 'òirlich|"', 'sl': 'pal|"', 'nb': 'tommer|"', 'be': 'цаль|"', 'gl': 'pol|"', 'ar': 'في|"', 'en_US': 'in|"', 'eo': 'colo|"', 'zh_TW': '英吋|in', 'et': 'tolli|"|″', 'ru': 'дюйм|"', 'he': "אינץ׳|אינץ'|אינטש", 'zh_CN': '英寸|in', 'ja': 'インチ|in|"'},
'ERR_MEMORY':{'lt': 'nepakanka atminties.', 'sid': 'kkitinnokki qaaggo.', 'fi': 'muisti ei riitä.', 'ro': 'Memorie insuficientă.', 'lv': 'nepietiek atmiņas.', 'kn': 'ಸಾಕಷ್ಟು ಸ್ಮೃತಿ ಇಲ್ಲ.', 'hsb': 'Njeje dosć składa.', 'es': 'no hay memoria suficiente.', 'vec': 'Ła memoria no ła basta mìa.', 'el': 'ανεπαρκής μνήμη.', 'sv': 'otillräckligt minne.', 'hr': 'nema dovoljno memorije.', 'cs': 'nedostatek paměti.', 'sr_Latn': 'Nema dovoljno memorije.', 'pl': 'za mało pamięci.', 'he': 'אין די זכרון.', 'nl': 'onvoldoende geheugen.', 'de': 'Nicht genügend Arbeitsspeicher.', 'hi': 'स्मृति प्रर्याप्त नहीं.', 'ml': 'ആവശ്യമായ മെമ്മറി ലഭ്യമല്ല.', 'id': 'Apakah Anda ingin menjalankan dokumen teks ini?', 'gu': 'પૂરતી મેમરી નથી.', 'my': 'မှတ်ဉာဏ်မလုံလောက်ပါ။', 'ko': '메모리가 부족합니다.', 'ne': 'पर्याप्त स्मृति छैन ।', 'zh_TW': '記憶體不足。', 'et': 'pole piisavalt mälu.', 'ru': 'недостаточно памяти.', 'sl': 'Ni dovolj pomnilnika.', 'bn_IN': 'অপ্রতুল মেমরি।', 'am': 'በቂ memory የለም', 'mr': 'पुरेशी मेमरि नाही.', 'uk': "недостатньо пам'яті.", 'pt_BR': 'memória insuficiente.', 'kk': 'жады жеткіліксіз.', 'te': 'సరిపోవునంత మెమొరీ లేదు.', 'br': 'memor re skort.', 'is': 'ekki nægt minni.', 'km': 'អង្គ\u200bចងចាំ\u200bមិន\u200bគ្រប់គ្រាន់\xa0។', 'nb': 'ikke nok minne.', 'bg': 'недостатъчна памет.', 'bs': 'nema dovoljnomemorije.', 'eu': 'nahiko memoriarik ez.', 'hu': 'Nincs elég memória.', 'cy': 'dim digon o gof.', 'pa_IN': 'ਲੋੜੀਂਦੀ ਮੈਮੋਰੀ ਨਹੀਂ ਹੈ', 'ast': 'nun hai memoria bastante.', 'it': 'memoria insufficiente.', 'tr': 'yeterli bellek yok.', 'vi': 'Không đủ bộ nhớ.', 'da': 'ikke nok hukommelse', 'as': 'পৰ্যাপ্ত মেমৰি নাই।', 'gd': 'chan eil cuimhne gu leòr ann.', 'or': 'ଯଥେଷ୍ଟ ସ୍ମୃତି ସ୍ଥାନ ନାହିଁ।', 'ja': 'メモリーが足りません。', 'nn': 'det ikkje er nok minne.', 'fr': 'mémoire insuffisante.', 'pt': 'memória insuficiente', 'sq': 'memorie të pamjaftueshme.', 'oc': 'memòria insufisenta.', 'gl': 'non hai memoria suficiente.', 'ar': 'لا ذاكرة كافية.', 'en_US': 'not enough memory.', 'sk': 'nedostatok pamäte.', 'sr': 'Нема довољно меморије.', 'zh_CN': '内存不足。', 'eo': 'nesufiĉa memoro.', 'ta': 'நினைவகம் போதவில்லை.', 'ca_valencia': 'no hi ha prou memòria.', 'ga': 'cuimhne ídithe.', 'ca': 'no hi ha prou memòria.', 'si': 'මතකය ප්\u200dරමාණවත් නැත.', 'be': 'недастаткова памяці.', 'ug': 'يېتەرلىك ئەسلەك يوق.', 'ka': 'არ არის საკმარისი მეხსიერება.'},
'TO':{'lt': 'tai', 'sid': 'ra', 'fi': 'tee', 'ro': 'to|la', 'lv': 'līdz', 'kn': 'ಗೆ', 'nn': 'til|to', 'tr': 'buraya', 'es': 'a', 'el': 'σε|to', 'hr': 'za', 'cs': 'příkaz', 'de': 'zu|als', 'he': 'עד', 'nl': 'naar', 'hu': 'ez|eljárás|elj|tanuld', 'hi': 'प्रति', 'ml': 'ഏങ്ങോട്ട്', 'gu': 'પ્રતિ', 'zh_TW': '定義|起|to', 'mr': 'टु', 'ru': 'к', 'sl': 'pri', 'bn_IN': 'প্রতি', 'am': 'ለ', 'et': 'funktsioon|f', 'uk': 'до', 'pt_BR': 'aprender|aprenda', 'kk': 'қайда', 'te': 'కు', 'br': 'e', 'is': 'til', 'km': 'ដល់', 'nb': 'til|to', 'bs': 'do', 'eu': 'nora', 'ast': 'a', 'gug': 'a', 'as': 'লৈ', 'gd': 'gu', 'or': 'କୁ', 'ja': '動きを作る|to', 'hsb': 'přikaz', 'fr': 'à', 'gl': 'para', 'ar': 'إلى', 'en_US': 'to', 'sk': 'k', 'zh_CN': '定义|定义起始|起始|to', 'eo': 'al', 'ta': 'இதற்கு', 'ca_valencia': 'fins.a', 'ca': 'fins.a', 'oc': 'a'},
'GREEN':{'lt': 'žalia', 'th': 'เขียว', 'sid': 'haanja', 'fi': 'vihreä', 'ro': 'green|verde', 'lv': 'zaļš', 'kn': 'ಹಸಿರು', 'hsb': 'zeleny', 'tr': 'yeşil', 'es': 'verde', 'vec': 'verde', 'el': 'πράσινο|green', 'hr': 'zelena', 'cs': 'zelená', 'sr_Latn': 'zelena', 'he': 'ירוק', 'nl': 'groen', 'de': 'grün', 'hi': 'हरा', 'ml': 'പച്ച', 'gu': 'લીલો', 'my': 'အစိမ်းရောင်', 'ko': '녹색', 'zh_TW': '綠|green', 'mr': 'हिरवा', 'ru': 'зелёный', 'sl': 'zelena', 'bn_IN': 'সবুজ', 'am': 'አረንጓዴ', 'et': 'roheline', 'uk': 'зелений', 'pt_BR': 'verde', 'kk': 'жасыл', 'te': 'ఆకుపచ్చ', 'br': 'gwer', 'is': 'grænt', 'km': 'បៃតង', 'nb': 'grønn|green', 'bs': 'zelena', 'eu': 'berdea', 'hu': 'zöld', 'pa_IN': 'ਹਰਾ', 'ast': 'verde', 'gug': 'aky', 'vi': 'Lục', 'as': 'সেউজীয়া', 'gd': 'uaine', 'or': 'ସବୁଜ', 'ja': '緑|green', 'nn': 'grøn|green', 'fr': 'vert', 'be': 'зялёны', 'oc': 'verd', 'gl': 'verde', 'ar': 'أخضر', 'en_US': 'green', 'sk': 'zelená', 'sr': 'зелена', 'zh_CN': '绿|绿色|green', 'eo': 'verda', 'ta': 'பச்சை', 'ca_valencia': 'verd', 'ne': 'हरियो', 'ca': 'verd', 'si': 'කොළ', 'ug': 'يېشىل', 'ka': 'მწვანე'},
'NORMAL':{'lt': 'įprastinis', 'th': 'ปกติ', 'sid': 'rosaminoha', 'zu': 'okwejwayelekile', 'fi': 'tavallinen', 'ss': 'vamile', 'ml': 'സാധാരണ', 'lv': 'normāls', 'kn': 'ಸಾಮಾನ್ಯ', 'hsb': 'normalny', 'xh': 'ngokuqhelekileyo', 'el': 'κανονικό|normal', 'hr': 'obično', 'tn': 'tlwaelo', 'cs': 'normální', 'he': 'רגיל', 'nl': 'normaal', 'hu': 'normál', 'hi': 'सामान्य', 'bn': 'সাধারণ', 'nso': 'tlwaelegilego', 'gu': 'સામાન્ય', 've': 'ḓoweleaho', 'my': 'ပုံမှန်', 'ko': '보통', 'st': 'tlwaelehileng', 'tt': 'гадәти', 'zh_TW': '一般|normal', 'mr': 'सामान्य', 'ru': 'обычный', 'sl': 'navadno', 'bn_IN': 'সাধারণ', 'am': 'መደበኛ', 'et': 'keskmine', 'uk': 'звичайний', 'kmr_Latn': 'asayî', 'kk': 'қалыпты', 'te': 'సాధారణ', 'af': 'normaal', 'is': 'venjulegt', 'ts': 'tolovelekeeke', 'km': 'ធម្មតា\u200b', 'bs': 'obicno', 'eu': 'normala', 'nr': 'jayelekileko', 'pa_IN': 'ਸਧਾਰਨ', 'vi': 'thông thường', 'as': 'সাধাৰন', 'gd': 'àbhaisteach', 'eo': 'normala', 'or': 'ସାଧାରଣ', 'ja': 'ふつう|標準|normal', 'sa_IN': 'आम', 'be': 'звычайны', 'sq': 'normale', 'fa': 'معمولی', 'ar': 'عادي', 'ug': 'نورمال', 'sk': 'normálne', 'zh_CN': '一般|常规|normal', 'br': 'Reizh', 'ta': 'சாதாரண', 'ne': 'सामान्य', 'si': 'සාමාන්\u200dය', 'dgo': 'आम', 'en_US': 'normal', 'ka': 'ჩვეულებრივი'},
'PINK':{'lt': 'rausva', 'th': 'ชมพู', 'sid': 'dumamo', 'fi': 'pinkki', 'ro': 'pink|roz', 'lv': 'rozā', 'kn': 'ಸಂಪರ್ಕಕೊಂಡಿ', 'hsb': 'róžowy', 'tr': 'pembe', 'es': 'rosa', 'el': 'ροζ|pink', 'hr': 'ružićasta', 'cs': 'růžová', 'sr_Latn': 'roze', 'he': 'ורוד', 'nl': 'roze', 'de': 'rosa', 'hi': 'कड़ी', 'ml': 'പിങ്ക്', 'gu': 'ગુલાબી', 'ko': '분홍', 'zh_TW': '粉紅|pink', 'mr': 'पिंक', 'ru': 'розовый', 'sl': 'roza', 'bn_IN': 'লিংক', 'am': 'ሮዝ', 'et': 'roosa', 'uk': 'рожевий', 'pt_BR': 'rosa', 'kk': 'қызғылт', 'te': 'పింక్', 'br': 'roz', 'is': 'bleikt', 'km': 'ផ្កាឈូក', 'nb': 'rosa|pink', 'bs': 'roza', 'eu': 'arrosa', 'hu': 'rózsaszín', 'cy': 'pinc', 'pa_IN': 'ਲਿੰਕ', 'ast': 'rosa', 'gug': 'pytãngy', 'vi': 'Liên kết', 'as': 'গোলাপী', 'gd': 'pinc', 'or': 'ଗୋଲାପି', 'ja': 'ピンク|pink', 'nn': 'rosa|pink', 'fr': 'rose', 'be': 'ружовы', 'sq': 'rozë', 'oc': 'ròse', 'gl': 'rosa', 'ar': 'وردي', 'en_US': 'pink', 'sk': 'Odkaz', 'sr': 'розе', 'zh_CN': '粉色|粉|pink', 'eo': 'rozkolora', 'ta': 'இளஞ்சிவப்பு', 'ca_valencia': 'rosa', 'ne': 'लिङ्क', 'ca': 'rosa', 'si': 'සබඳින්න', 'my': 'ကွင်းဆက်', 'ka': 'ბმული'},
'PENTRANSPARENCY':{'lt': 'pieštuko.skaidrumas|linijos.skaidrumas|psk', 'uk': 'прозорість_пера|прозорість_лінії', 'pt_BR': 'mudarTransparênciaDoLápis|mTraLa|mTraLi', 'kk': 'қалам_мөлдірлілігі|сызық_мөлдірлілігі', 'fi': 'kynänläpinäkyvyys', 'br': 'boullderkreion|boullderlinenn', 'km': 'ភាព\u200bថ្លា|ភាពថ្លាបន្ទាត់', 'fr': 'transparencecrayon|tranparenceligne', 'lv': 'spalvas_caurspīdīgums|līnijas_caurspīdīgums', 'kn': 'ಲೇಖನಿಪಾರದರ್ಶಕತೆ|ಸಾಲಿನಪಾರದರ್ಶಕತೆ', 'eu': 'lumagardentasuna|marragardentasuna', 'hr': 'prozirnostolovke|prozirnostlinije', 'es': 'pluma.transparencia|línea.transparencia', 'nn': 'penngjennomsikt|linjegjennomsikt', 'gug': 'bolígrafo.hesakã|línea.hesakã', 'oc': 'transparénciagredon|tranparéncialinha', 'cs': 'průhlednostpera|průhlednostčáry|průhlpera|průhlčáry', 'de': 'stifttransparenz|linientransparenz|st|lt', 'tr': 'kalemşeffaflığı|çizgişeffaflığı', 'nl': 'pentranparantie|lijntransparantie', 'or': 'କଲମସ୍ୱଚ୍ଛତା|ଧାଡ଼ିସ୍ୱଚ୍ଛତା', 'he': 'שקיפות_עט|שקיפות_קו', 'hsb': 'transparencapisaka|transparencalinije|tp|tl', 'nb': 'penngjennomsiktighet|linjegjennomsiktighet', 'hu': 'tollátlátszóság', 'gl': 'transparencialapis|transparencialiña', 'ar': 'شفافية_القلم', 'en_US': 'pentransparency|linetransparency', 'sk': 'priehľadnosťpera|priehľadnosťčiary|pp|pč', 'ko': '투명펜', 'eo': 'plumtravideblo|linitravideblo', 'ca_valencia': 'llapis.transparència|línia.transparència', 'zh_TW': '筆透明|線透明|pentransparency|linetransparency', 'et': 'pliiatsi_läbipaistvus|joone_läbipaistvus', 'zh_CN': '笔透明|线透明|pentransparency|linetransparency', 'el': 'διαφάνειαγραφίδας|διαφάνειαγραμμής', 'ru': 'прозр_пера|прозр_линии|пп', 'sl': 'prosojnostperesa|prosojnostčrte', 'ug': 'قەلەم سۈزۈك|سىزىق سۈزۈك|pentransparency|linetransparency', 'ja': 'ペンの透明度|pentransparency|linetransparency', 'ca': 'llapis.transparència|línia.transparència'},
'PENCOLOR':{'lt': 'pieštuko.spalva|linijos.spalva|psp', 'th': 'pencolor|สีปากกา|สีเส้น|pc', 'sid': 'biiretekuula|biiretekuula|xuruurukuula|bk', 'fi': 'kynänväri|kv', 'ro': 'pencolor|pencolour|linecolor|pc|culoarestilou', 'lv': 'spalvas_krāsa|linijas_krāsa|sk', 'kn': 'ಲೇಖನಿಬಣ್ಣ|ಲೇಖನಿಯಬಣ್ಣ|ರೇಖೆಬಣ್ಣ|pc', 'hsb': 'barbapisaka|barbalinije|bp|bl', 'tr': 'kalemrengi|kalemrengi|satırrengi|kr', 'es': 'color.lápiz|color.línea|cl', 'el': 'χρώμαγραφίδας|χρώμαγραμμής|χγ|pencolor|pencolour|linecolor|pc', 'hr': 'boja olovke|boja olovke|boja linije|bo', 'cs': 'barvapera|barvačáry|bp', 'de': 'stiftfarbe|linienfarbe|sf|lf', 'he': 'צבעעט|צבעט|צבעקו|צק', 'nl': 'penkleur|lijnkleur|pk', 'hu': 'tollszín|tollszín!|tsz!?|vonalszín', 'ko': '펜색상|펜색상|선색상|pc', 'zh_TW': '筆顏色|筆色|線顏色|線色|筆色彩|線色彩|pencolor|pencolour|linecolor|pc', 'mr': 'पेनकलर|पेनकलर|लाइनकलर|pc', 'ru': 'цвет_пера|цвет_линии|ц', 'sl': 'barvaperesa|barvačrte|bp', 'am': 'የ ብዕር ቀለም|የ ብዕር ቀለም|የ መስመር ቀለም|ብ/ቀ', 'et': 'pliiatsi_värv|joonevärv|pv|jv', 'uk': 'колір_пера|колір_лінії|кп', 'pt_BR': 'mudarCorDoLápis|mCorLa|mudeCorDoLápis|mudecl', 'kk': 'қалам_түсі|сызық_түсі|т', 'km': 'ពណ៌\u200bប៉ិក|pencolour|linecolor|pc', 'nb': 'pennfarge|pencolour|pf|linjefarge|pc', 'bs': 'bojaolovke|bojaolovke|bojalinije|pc', 'eu': 'lumakolorea|marrakolorea|lk', 'ast': 'llapizcolor|lliniacolor|lc', 'gug': "sa'y.lápiz|sa'y.línea|cl", 'or': 'ପେନରଙ୍ଗ|ପେନରଙ୍ଗ|ଧାଡ଼ିରଙ୍ଗ|pc', 'mn': 'үзэгний өнгө|шугамын өнгө|үөн|шөн', 'ja': 'ペンの色|線の色|pencolor|pc', 'nn': 'pennfarge|linjefarge|pf|pencolor', 'fr': 'couleurcrayon|ccrayon|couleurligne|cc', 'gl': 'estilocor|estilodacor|liñadecor|ec', 'ar': 'لون_القلم', 'en_US': 'pencolor|pencolour|linecolor|pc', 'sk': 'farbapera|farbačiary|fp|fč', 'eo': 'plumkoloro|linikoloro|pk', 'ca_valencia': 'color.llapis|color.línia|cl', 'ca': 'color.llapis|color.línia|cl', 'zh_CN': '笔颜色|笔色|线颜色|线色|pencolor|pencolour|linecolor|pc'},
'HEADING':{'lt': 'žvelk', 'sid': 'umallo|umalloqineessi|uqineessi', 'ja': '進む向き|向き|heading', 'pt_BR': 'mudarDireção|mDir|direção', 'kk': 'атауы|атауын_орнату|ата', 'fi': 'suunta', 'br': 'talbenn|setheading|seth', 'eo': 'direkto|dir', 'ro': 'heading|setheading|seth|direcție', 'fr': 'cap|fixecap|fc', 'lv': 'azimuts|iestatīt_azimutu|iest_az', 'kn': 'ಶೀರ್ಷಿಕೆ|ಶೀರ್ಷಿಕೆಹೊಂದಿಸು|seth', 'eu': 'izenburua|ezarriizenburua|ezarrig', 'tr': 'başlık|başlığıayarla|baş.ayarla', 'es': 'sentido|dirección|dir', 'ca': 'canvia.sentit|sentit|heading|setheading|seth', 'el': 'επικεφαλίδα|ορισμόςεπικεφαλίδας|ορε|heading|setheading|seth', 'uk': 'заголовок|задати_заголовок|заг', 'hr': 'naslov|postavinaslov|postavin', 'cs': 'směr|nastavsměr', 'de': 'richtung|ri', 'nl': 'richting', 'bs': 'zaglavlje|postavizaglavlje|seth', 'he': 'כותרת|הגדרתכותרת|הגכ', 'hsb': 'směr', 'nb': 'retning|settretning|heading', 'hu': 'irány|irány!', 'gl': 'cabeceira|estabelecercabeceira|ec', 'ar': 'ترويسة|عين_ترويسة', 'en_US': 'heading|setheading|seth', 'sk': 'smer|nastavsmer|ns', 'ko': '제목|제목설정|seth', 'or': 'ଶୀର୍ଷକ|ଶୀର୍ଷକ ବିନ୍ୟାସ|seth', 'ca_valencia': 'canvia.sentit|sentit|heading|setheading|seth', 'zh_TW': '朝向|定向|heading|setheading|seth', 'mr': 'हेडिंग|सेटहेडिंग|सेटएच', 'zh_CN': '朝向|定向|heading|setheading|seth', 'ast': 'direición|pondireición|dir', 'ru': 'заголовок|установить_заголовок|заг', 'sl': 'smer|določismer|dols', 'oc': 'títol|definirtítol|deft', 'am': 'ራስጌ|ራስጌ ማሰናጃ|ራ.ማ', 'et': 'pealkiri|määra_pealkiri'},
'MITER':{'lt': 'kampinis', 'sid': 'metire', 'fi': 'jiiri', 'ro': 'miter|ascuțit', 'lv': 'spics', 'kn': 'ಮಿಟರ್', 'hsb': 'nakosa', 'tr': 'köşe', 'es': 'mitra|inglete|bies', 'el': 'μύτη|miter', 'hr': 'koljeno', 'cs': 'ostré', 'de': 'gehrung', 'he': 'משלים', 'nl': 'snijdend', 'hu': 'hegyes', 'hi': 'माइटर', 'gu': 'મિટર', 'ko': '미터', 'zh_TW': '尖角|miter', 'mr': 'मीटर', 'ru': 'скос45', 'sl': 'izbočeno', 'am': 'መጋጠሚያ', 'et': 'terav', 'uk': 'скіс45', 'pt_BR': 'pontudo', 'kk': 'көлбеу45', 'br': 'garan', 'is': 'hornskeyting', 'km': 'ផ្គុំ', 'nb': 'skarp|miter', 'bs': 'kosispoj', 'eu': 'ebakia', 'cy': 'meitr', 'pa_IN': 'ਕਣ', 'ast': 'inglete', 'gug': 'mitra|inglete|bies', 'oc': 'mitra', 'or': 'ମିଟର', 'gd': 'bairrin', 'ja': '角をとがらせる|miter', 'nn': 'skarp|miter', 'fr': 'mitre', 'gl': 'bispel', 'ar': 'قلنسوة', 'en_US': 'miter', 'sk': 'ostré', 'zh_CN': '尖角|miter', 'eo': 'oblikva', 'ta': 'மைட்டர்', 'ca_valencia': 'esbiaixa|biaix', 'ca': 'esbiaixa|biaix', 'ug': 'چېتىق'},
'SKYBLUE':{'lt': 'dangaus', 'sid': 'gordukuula', 'fi': 'taivaansininen', 'lv': 'debeszils', 'kn': 'ಆಕಾಶನೀಲಿ', 'hsb': 'njebjomódry', 'tr': 'gök mavisi', 'es': 'azulcielo|celeste', 'el': 'ουρανί|skyblue', 'hr': 'nebeskoplava', 'cs': 'bleděmodrá', 'sr_Latn': 'nebesko plava', 'he': 'כחולשמיים|כחולשמים|שמיים|שמים', 'nl': 'hemelsblauw', 'de': 'hellblau', 'hi': 'आसमानी', 'ml': 'സ്കൈബ്ലൂ', 'gu': 'આકાશીવાદળી', 'ko': '하늘색', 'zh_TW': '天藍|skyblue', 'mr': 'स्कायब्ल्यु', 'ru': 'небесно-голубой', 'sl': 'nebesnomodra', 'bn_IN': 'অাকাশি নীল', 'am': 'ሰማያዊ', 'et': 'taevasinine', 'uk': 'небесно-синій', 'pt_BR': 'celeste', 'kk': 'ашық_көк', 'te': 'నింగినీలం', 'br': 'glaz oabl', 'is': 'himinblátt', 'km': 'ផ្ទៃមេឃ', 'nb': 'himmelblå|skyblue', 'bs': 'nebeskoplava', 'eu': 'zeruurdina', 'hu': 'égszínkék|világoskék', 'ast': 'celeste', 'it': 'celeste', 'gug': 'hovyyvága|celeste', 'as': 'আকাশনীলা', 'gd': 'speur-ghorm', 'or': 'ଆକାଶୀ ନୀଳ', 'ja': '空色|スカイブルー|skyblue', 'nn': 'himmelblå|skyblue', 'fr': 'bleuciel', 'be': 'нябесна-блакітны', 'gl': 'celeste', 'ar': 'سماوي', 'en_US': 'skyblue', 'sk': 'bledomodrá', 'sr': 'небеско плава', 'eo': 'ĉielblua', 'ta': 'வான்நீலம்', 'ca_valencia': 'blau.cel|cel', 'ca': 'blau.cel|cel', 'zh_CN': '天蓝|天蓝色|skyblue'},
'FONTSTYLE':{'lt': 'šrifto.stilius|teksto.stilius', 'th': 'รูปแบบอักขระ', 'sid': 'borangichuakat', 'fi': 'fonttityyli', 'ro': 'fontstyle|stilfont', 'lv': 'fonta_stils', 'kn': 'ಅಕ್ಷರಶೈಲಿ', 'hsb': 'stilpisma|sp', 'es': 'estilo.letra|estilo.fuente', 'el': 'μορφήγραμματοσειράς|fontstyle', 'hr': 'stil fonta', 'cs': 'stylpísma', 'de': 'schriftstil|schs', 'he': 'סגנוןגופן', 'nl': 'tekststijl|letterstijl', 'hu': 'betűstílus', 'gu': 'ફોન્ટ શૈલી', 'ko': '글꼴스타일', 'zh_TW': '字型樣式|字樣式|fontstyle', 'mr': 'फाँटची शैली', 'ru': 'стиль_шрифта', 'sl': 'slogpisave', 'bn_IN': 'হরফ-শৈলী', 'am': 'የፊደል ዘዴ', 'et': 'fondi_stiil', 'uk': 'стиль_символів', 'pt_BR': 'mudarEstiloDaLetra|mEstLe', 'kk': 'қаріп_стилі', 'te': 'ఫాంటుశైలి', 'br': 'stil an nodrezh', 'is': 'leturstíll', 'km': 'រចនាប័ទ្ម\u200bពុម្ពអក្សរ', 'nb': 'skriftstil|fontstyle', 'bs': 'stilfonta', 'eu': 'letraestiloa', 'ast': 'estiludefonte', 'tr': 'yazı tipi biçemi', 'or': 'ଅକ୍ଷରରୂପ ଶୈଳୀ', 'ja': '文字の書き方|文字のスタイル|フォントのスタイル|fontstyle', 'nn': 'skriftstil|fontstyle', 'fr': 'stylepolice', 'gl': 'estilo de tipo de letra', 'ar': 'نمط_الخط', 'en_US': 'fontstyle', 'sk': 'štýlpísma|šp', 'zh_CN': '字体样式|字样式|字样|fontstyle', 'eo': 'tiparostilo', 'ta': 'எழுத்துரு பாணி', 'ca_valencia': 'estil.lletra|el', 'ca': 'estil.lletra|el', 'ug': 'خەت نۇسخا ئۇسلۇبى'},
'LIST':{'lt': 'gauk.sąrašą|sąrašas|gksr', 'sid': 'dirto', 'fi': 'lista', 'ro': 'list|listă', 'lv': 'saraksts', 'kn': 'ಪಟ್ಟಿ', 'hsb': 'lisćina', 'tr': 'liste', 'es': 'lista', 'el': 'κατάλογος|list', 'hr': 'popis', 'cs': 'seznam', 'de': 'liste', 'he': 'רשימה', 'nl': 'Lijst', 'hu': 'lista', 'hi': 'सूची', 'gu': 'યાદી', 'ko': '목록', 'zh_TW': '清單|列表|list', 'mr': 'लिस्ट', 'sat': 'लिसटी', 'ru': 'список', 'sl': 'izpišiseznam', 'bn_IN': 'তালিকা', 'am': 'ዝርዝር', 'et': 'loend', 'uk': 'список', 'pt_BR': 'lista', 'kk': 'тізім', 'te': 'జాబిత', 'br': 'roll', 'is': 'listi', 'km': 'បញ្ជី', 'nb': 'liste|list', 'bs': 'lista', 'eu': 'zerrenda', 'cy': 'rhestr', 'ka': 'სია', 'ast': 'llista', 'gug': 'lista', 'oc': 'lista', 'or': 'ତାଲିକା', 'ja': 'リスト|list', 'nn': 'liste|list', 'fr': 'liste', 'be': 'спіс', 'sq': 'lista', 'gl': 'lista', 'ar': 'قائمة', 'en_US': 'list', 'sk': 'Zoznam', 'zh_CN': '列表|list', 'eo': 'listo', 'ta': 'பட்டியல்', 'ca_valencia': 'llista', 'ne': 'सूची', 'ca': 'llista', 'si': 'ලැයිස්තුව', 'dgo': 'सूची', 'my': 'စာရင်း'},
'ERR_ZERODIVISION':{'fi': 'Jako nollalla.', 'kn': 'ಶೂನ್ಯದಿಂದ ಭಾಗಾಕಾರ.', 'sv': 'Division med noll.', 'hr': 'Dijeljenje s nulom.', 'de': 'Division durch Null.', 'he': 'חלוקה באפס.', 'nl': 'Deling door nul.', 'hu': 'Osztás nullával.', 'brx': 'लाथिखजों राननाय.', 'ko': '영(0)으로 나눔', 'et': 'Nulliga jagamine.', 'mai': 'सुन्नासँ भाग', 'am': 'በዜሮ ማካፈል', 'mr': 'डिविजन बाय झिरो.', 'kk': 'Нөлге бөлу.', 'te': 'సున్నాతో భాగహారము.', 'af': 'Deling deur nul.', 'tg': 'Тақсим бар сифр.', 'km': 'ចែក\u200bនឹង\u200bសូន្យ\xa0។', 'fr': 'Division par zéro.', 'kok': 'शून्यान भाग', 'eu': 'Zatitzailea zero.', 'pt': 'Divisão por zero', 'pa_IN': 'ਜ਼ੀਰੋ ਨਾਲ ਭਾਗ', 'it': 'Divisione per zero.', 'gug': 'División por cero.', 'vi': 'Chia cho không.', 'da': 'Division med nul.', 'gd': 'Roinneadh le neoini.', 'hsb': 'Diwizija přez nulu.', 'nb': 'Deling med null.', 'be': 'Дзяленне на нуль.', 'sq': 'Pjesëtim me zero.', 'om': 'Qooddii zeeroodhaanii.', 'ug': 'نۆلگە بۆلۈنگەن.', 'sk': 'Delenie nulou.', 'ta': 'சுழியால் வகுத்தல்.', 'dgo': 'सिफर कन्नै तक्सीम', 'en_US': 'Division by zero.', 'lt': 'Dalyba iš nulio.', 'th': 'หารด้วยศูนย์', 'sid': 'Zeerotenni beeha.', 'ml': 'പൂജ്യം കൊണ്ടു് ഹരിക്കുക.', 'mk': 'Делење со нула.', 'ro': 'Împărțire la zero.', 'lv': 'Dalīšana ar nulli.', 'as': 'শুণ্যৰে হৰণ কৰা ।', 'nn': 'Deling med null.', 'es': 'División por cero.', 'vec': 'Divizion par zero.', 'el': 'Διαίρεση με το μηδέν.', 'dz': 'ཀླད་ཀོར་གིས་བགོ་རྩིས།', 'cs': 'Dělení nulou.', 'sr_Latn': 'Deljenje nulom.', 'sl': 'Deljenje z nič.', 'hi': 'शून्य से विभाजन.', 'id': 'Pembagian oleh nol.', 'gu': 'શૂન્ય દ્વારા વિભાજન.', 'my': 'သုံညဖြင့်စားခြင်း။', 'sd': 'ٻڙيءَ سان ونڊيو', 'zh_TW': '除以零。', 'sat': 'सुन दाराय ते हा़टिञ', 'bo': 'ཀླད་ཀོར་ཕུད།', 'ru': 'Деление на ноль.', 'rw': 'Kugabanya na zeru.', 'bn_IN': 'শূন্য দিয়ে বিভাজন।', 'uk': 'Ділення на нуль.', 'kmr_Latn': 'Li sifirê parva kirin.', 'pt_BR': 'Divisão por zero.', 'tt': 'Нульгә бүлү.', 'bn': 'শূন্য দিয়ে বিভাজন।', 'is': 'Deiling með núlli.', 'pl': 'Dzielenie przez zero.', 'sa_IN': 'शून्यतः विभाजनम् ।', 'sw_TZ': 'Gawanyika kwa sifuri', 'ks': 'صفرسئتھ تقسیم كرُن', 'ga': 'Roinnt le nialas.', 'bg': 'Деление на нула.', 'ast': 'División por cero.', 'tr': 'Sıfıra bölme.', 'bs': 'Dijeljenje sa nulom.', 'mn': 'Тэгд хуваагдаж байна.', 'or': 'ଶୂନ୍ୟ ଦ୍ୱାରା ବିଭାଜିତ।', 'ja': 'ゼロで割り算した。', 'cy': 'Rhannu gyda sero.', 'br': 'Rannadur dre vann.', 'fa': 'تقسیم بر صفر', 'gl': 'División por cero.', 'ar': 'القسمة على صفر.', 'oc': 'Division per zèro.', 'sr': 'Дељење нулом.', 'zh_CN': '被零除。', 'eo': 'Divido per nul.', 'ca_valencia': 'Divisió per zero.', 'ne': 'शून्यद्वारा विभाजन ।', 'ca': 'Divisió per zero.', 'si': 'ශුන්\u200dයයෙන් බෙදීම.', 'uz': 'Nolga boʻlish', 'mni': 'শূন্যনা য়েন্নবা.', 'ka': 'ნულზე გაყოფა.'},
'ERR_ARGUMENTS':{'lt': 'Komandai „%s“ reikia %s argumentų (nurodyta %s).', 'sid': '%s tidho %s adhanno (%s uyinoonniha).', 'fi': '%s tarvitsee %s argumenttia (%s annettu).', 'ro': '%s dă %s argumente (%s date).', 'lv': '%s pieņem %s parametrus (nevis %s).', 'kn': '%s ಎನ್ನುವುದು %s ಆರ್ಗ್ಯುಮೆಂಟ್\u200cಗಳನ್ನು ತೆಗೆದುಕೊಳ್ಳುತ್ತದೆ (%s ಒದಗಿಸಲಾದ).', 'hsb': '%s trjeba %s argumentow (%s podate).', 'tr': '%s, %s bağımsız değişken alır (%s verilen).', 'es': '%s toma %s argumentos (se proporcionaron %s).', 'vec': '%s el ciapa %s argomenti (%s dati).', 'el': 'το %s παίρνει τα ορίσματα %s (%s δεδομένα).', 'sv': '%s tar %s argument (%s givna).', 'hr': '%s ima %s argumente (%s dano).', 'cs': '%s vyžaduje %s argumentů (předáno %s).', 'sr_Latn': '%s uzima %s argumenata (navedeno %s).', 'pl': '%s pobiera %s argumenty (%s podane).', 'he': '%s מקבלת %s ארגומנטים (%s סופקו).', 'nl': '%s heeft %s argumenten nodig (%s gegeven).', 'de': '%s benötigt %s Argumente (%s angegeben).', 'hi': '%s लेता %s वितर्क (%s दिया हुआ).', 'ml': '%s, %s ആര്\u200dഗ്രുമെന്റുകള്\u200d സ്വീകരിയ്ക്കുന്നു (%s നല്\u200dകിയിരിയ്ക്കുന്നു).', 'id': '%s perlu %s argumen (diberikan %s).', 'gu': '%s એ %s દલીલો લે છે (%s આપેલ છે).', 'ko': '%s 은(는) %s 개의 파라미터를 갖습니다.(%s 제공됨).', 'zh_TW': '%s 取用 %s 個引數 (已給 %s 個)。', 'et': '%s võtab %s argumenti (aga anti %s).', 'ru': '%s принимает %s аргументов (передано %s).', 'sl': '%s potrebuje %s argumentov (%s jih je podanih).', 'am': '%s የሚወስደው %s ክርክር (%s የተሰጠው)', 'mr': '%s %s आर्ग्युमेंट्स (%s दिलेले) प्राप्त करते.', 'uk': '%s отримує %s аргументів (передано %s).', 'pt_BR': '%s usa %s argumentos (%s definidos).', 'kk': '%s үшін %s аргумент керек (%s берілді).', 'te': '%s అనునది %s ఆర్గుమెంట్లు తీసుకొనును (%s యీయబడెను).', 'br': '%s a geler %s arguzenn (%s roet).', 'is': '%s tekur %s viðföng (%s gefið).', 'km': '%s ចាប់\u200bយក\u200bអាគុយម៉ង់ %s (បាន\u200bផ្ដល់ឲ្យ %s )។', 'nb': '%s tar %s argumenter (%s er angitt).', 'bg': '%s приема %s аргумента (подадени са %s).', 'bs': '%s uzima %s argumenata (%s dato).', 'eu': '%s(e)k %s argumentu hartu ditu (%s emanda).', 'hu': '%s: %s adatot vár, de %s lett megadva.', 'cy': 'Mae %s yn cymryd %s ymresymiad (Derbyn %s ).', 'ast': '%s lleva %s argumentos (%s daos).', 'it': '%s prende %s argomenti (%s dati).', 'gug': '%s toma %s argumentos (se proporcionaron %s).', 'oc': '%s pren los arguments %s (%s donat).', 'da': '%s tager %s argumenter (%s givet).', 'as': '%s এ %s তৰ্কসমূহ গ্ৰহণ কৰে (%s দিয়া হৈছে)।', 'gd': 'Gabhaidh %s %s argamaidean (thug thu seachad %s).', 'or': '%s ଟି %s ପ୍ରାଚଳ ନେଇଥାଏ (%s ପ୍ରଦତ୍ତ)।', 'ja': '%s は %s 個の引数をとります(%s 個与えられました)。', 'nn': '%s tar %s argument (%s er gjevne).', 'fr': '%s prend les arguments %s (%s donné).', 'pt': '%s recebe %s argumentos (indicou %s)', 'gl': '%s toma %s argumentos (%s dados).', 'ar': '%s يأخذ %s من المعاملات (%s أُعطيت).', 'en_US': '%s takes %s arguments (%s given).', 'sk': '%s vyžaduje %s argumentov ( zadaných bolo %s).', 'sr': '%s узима %s аргумената (наведено %s).', 'zh_CN': '%s 需要 %s 个参数 (已给出 %s 个)。', 'eo': '%s prenas %s argumentojn (%s donitaj).', 'ta': '%s ஆனது %s மதிப்புருக்களை எடுத்துக்கொள்ளும் (%s கொடுக்கப்பட்டது).', 'ca_valencia': '%s pren %s arguments (%s donats).', 'ga': 'Glacann %s le %s argóint (bhí %s argóint ann).', 'ca': '%s pren %s arguments (%s donats).', 'be': '%s прымае %s аргументаў (пададзена %s).', 'ug': '%s غا %s ئۆزگەرگۈچى زۆرۈر (%s بېرىلگەن).'},
'REPCOUNT':{'lt': 'kartojimai', 'sid': 'wirrotekiiro', 'sk': 'počítadlo|poč', 'pt_BR': 'contVezes|conteVezes', 'kk': 'қайталау', 'te': 'రెప్\u200cకౌంట్', 'br': 'arren ar gont', 'ro': 'repcount|câtelea', 'fr': 'nombrerep', 'lv': 'atkārt_skaits', 'bs': 'repbroji', 'nn': 'teljar|repcount', 'hr': 'br. ponavljanja', 'es': 'conteo.veces', 'ca': 'repeteix.vegades|repv', 'el': 'αριθμόςεπαναλήψεων|repcount', 'uk': 'повтори', 'gug': "ha'ejevy.papa", 'cs': 'počítadlo|poč', 'de': 'zähler', 'tr': 'tekrarsayısı', 'nl': 'keerherhaal', 'or': 'ପୁନରାବୃତ୍ତି ସଂଖ୍ୟା', 'he': 'ספירתחזרה', 'hsb': 'ličak', 'eu': 'errepzenbak', 'nb': 'teller|repcount', 'hu': 'hányadik', 'gl': 'contarep', 'ar': 'عداد_التكرار', 'en_US': 'repcount', 'fi': 'toistokerrat', 'eo': 'ripetonombro', 'ca_valencia': 'repeteix.vegades|repv', 'zh_TW': '重複數|重復數|repcount', 'et': 'korduse_number', 'ast': 'repetirvegaes', 'ru': 'повторить', 'sl': 'števecpon', 'zh_CN': '重复数|repcount', 'ja': 'くりかえした数|repcount', 'mr': 'रिपकाउंट'},
'ERR_STOP':{'lt': 'Programos darbas nutrauktas:', 'sid': 'Pirogirame gooffino:', 'fi': 'Ohjelma on lopetettu:', 'ro': 'Programul s-a terminat:', 'lv': 'Programma pārtraukta:', 'kn': 'ಪ್ರೋಗ್ರಾಂ ಅಂತ್ಯಗೊಂಡಿದೆ:', 'hsb': 'Program skónčeny:', 'es': 'Programa finalizado:', 'vec': 'Programa terminà:', 'el': 'Το πρόγραμμα τερματίστηκε:', 'sv': 'Program avslutades:', 'hr': 'Program je završen:', 'cs': 'Program ukončen:', 'sr_Latn': 'Program prekinut:', 'pl': 'Program zakończony:', 'he': 'התכנית חוסלה:', 'nl': 'Programma afgebroken:', 'de': 'Programm beendet:', 'hi': 'प्रोग्राम बाहर हुआ:', 'ml': 'പ്രോഗ്രാം നിര്\u200dത്തിയിരിയ്ക്കുന്നു:', 'id': 'Program diakhiri:', 'gu': 'કાર્યક્રમનો અંત આવ્યો:', 'ko': '프로그램이 종료됨:', 'zh_TW': '程式已中止：', 'et': 'Programm lõpetatud:', 'ru': 'Программа остановлена:', 'sl': 'Program se je zaključil:', 'bn_IN': 'প্রোগ্রাম সাময়িক ভাবে বন্ধ করা হয়েছে:', 'am': 'መተግበሪያው ተቋርጧል :', 'mr': 'प्रोग्राम बंद केले:', 'uk': 'Програму зупинено:', 'pt_BR': 'Programa encerrado:', 'kk': 'Бағдарлама үзілді:', 'te': 'ప్రోగ్రామ్ అంతమైను:', 'br': 'Goulev arsavet :', 'is': 'Forritið hætti:', 'km': 'បាន\u200bបញ្ចប់\u200bកម្មវិធី៖', 'nb': 'Programmet ble avsluttet:', 'bg': 'Програмата е прекратена:', 'bs': 'Program okončan:', 'eu': 'Programa eten da:', 'hu': 'A futás leállítva:', 'cy': 'Rhaglen wedi dod i ben:', 'ast': 'Programa fináu:', 'it': 'Programma terminato:', 'tr': 'Program sonlandırıldı:', 'oc': 'Programa arrestat :', 'da': 'Programmet afbrudt:', 'as': 'প্ৰগ্ৰাম অন্ত কৰা হল:', 'gd': "Chaidh crìoch a chur air a' phrògram:", 'or': 'ପ୍ରଗ୍ରାମ ସମାପ୍ତ ହୋଇଛି:', 'ja': 'プログラムが終了しました:', 'nn': 'Programmet vart avslutta fordi', 'fr': 'Programme arrêté :', 'pt': 'Programa terminado:', 'gl': 'Programa pechado:', 'ar': 'توقف البرنامج:', 'en_US': 'Program terminated:', 'sk': 'Program ukončený:', 'sr': 'Програм прекинут:', 'zh_CN': '程序已中断:', 'eo': 'Programo haltita:', 'ta': 'நிரல் முடிக்கப்பட்டது:', 'ca_valencia': 'El programa ha acabat:', 'ga': 'Stopadh an ríomhchlár:', 'ca': 'El programa ha acabat:', 'be': 'Праграма спынена:', 'ug': 'پىروگرامما توختىدى:'},
'PENDOWN':{'lt': 'piešim|pš|nuleisk.pieštuką', 'th': 'ปากกาลง|pd', 'sid': 'biireworora|bw', 'fi': 'kynäalas|ka', 'ro': 'pendown|pd|stiloujos', 'lv': 'nolikt_spalvu|ns', 'kn': 'ಲೇಖನಿಇಳಿಸು|pd', 'hsb': 'běžeć|bž', 'tr': 'kalemaşağı|ka', 'es': 'conpluma|bajarlapiz|cp|bl', 'el': 'γραφίδακάτω|γκ|pendown|pd', 'hr': 'olovka dolje|od', 'cs': 'perodolů|pd', 'de': 'laufen', 'he': 'להורידעט|עטלמטה|הורדעט|הע', 'nl': 'penneer|pn', 'hu': 'tollatle|tl', 'ko': '펜아래로|pd', 'zh_TW': '下筆|pendown|pd', 'mr': 'पेनडाउन|pd', 'ru': 'опустить_перо|оп', 'sl': 'perodol|pd', 'am': 'ብዕር ወደ ታች |pd', 'et': 'pliiats_alla|pa', 'uk': 'опусти_перо|оп', 'pt_BR': 'usarLápis|ul|useLápis', 'kk': 'қаламды_түсіру|қт', 'km': 'pendown', 'nb': 'penn ned|pn|pendown', 'bs': 'pendole|pd', 'eu': 'lumabehera|lb', 'ast': 'llapizbaxar|lb', 'gug': 'bolígrafo|bo', 'or': 'ପେନତଳକୁ|pd', 'ja': 'ペンをおろす|pendown|pd', 'nn': 'penn ned|pn|pendown', 'fr': 'baissecrayon|bc', 'gl': 'conestilo|ce', 'ar': 'أنزل_القلم|أنزل', 'en_US': 'pendown|pd', 'sk': 'perodolu|pd', 'eo': 'plumoek|pe', 'ca_valencia': 'baixa.llapis|bl', 'ca': 'baixa.llapis|bl', 'zh_CN': '下笔|落笔|pendown|pd'},
'LABEL':{'lt': 'piešk.tekstą|pštk', 'th': 'ป้ายกำกับ', 'sid': 'somaasincho', 'fi': 'selite', 'ro': 'label|etichetă', 'lv': 'etiķete', 'kn': 'ಲೇಬಲ್', 'hsb': 'pomjenowanje', 'tr': 'etiket', 'es': 'etiqueta', 'vec': 'marca', 'el': 'ετικέτα|label', 'hr': 'oznaka', 'cs': 'text', 'de': 'schreibe', 'mn': 'пайз', 'he': 'תווית', 'nl': 'bijschrift', 'hu': 'címke', 'hi': 'लेबल', 'ml': 'ലേബല്\u200d', 'gu': 'લેબલ', 'ko': '레이블', 'sd': 'ليبلُ', 'zh_TW': '標籤|label', 'mr': 'लेबल', 'sat': 'चिखना़', 'ru': 'надпись', 'sl': 'oznaka', 'sa_IN': 'अंकितकम्', 'bn_IN': 'লেবেল', 'am': 'ምልክት', 'et': 'silt', 'uk': 'напис', 'pt_BR': 'rotular|rotule', 'kk': 'белгі', 'te': 'లేబుల్', 'br': 'tikedenn', 'is': 'skýring', 'km': 'ស្លាក', 'nb': 'etikett|label', 'bs': 'naljepnica', 'eu': 'etiketa', 'pa_IN': 'ਲੇਬਲ', 'ast': 'etiqueta', 'gug': 'etiqueta', 'vi': 'Nhãn', 'as': 'লেবেল', 'gd': 'leubail', 'or': 'ନାମପଟି', 'ja': 'ラベル|label', 'nn': 'etikett|label', 'fr': 'étiquette', 'be': 'метка', 'sq': 'etiketë', 'oc': 'etiqueta', 'gl': 'etiqueta', 'ar': 'تسمية', 'en_US': 'label', 'sk': 'popis', 'zh_CN': '标签|label', 'eo': 'etikedo', 'ta': 'லேபிள்', 'ca_valencia': 'etiqueta', 'ca': 'etiqueta', 'si': 'ලේබලය', 'dgo': 'लेबल', 'ug': 'ئەن'},
'HOUR':{'lt': 'val', 'nb': 't', 'hu': 'ó|h', 'kk': 'с', 'br': 'e', 'en_US': 'h', 'is': 'klst', 'nn': 't|h', 'ar': 'س', 'zh_TW': 'h|小時', 'et': 't', 'he': 'שע', 'zh_CN': 'h|小时', 'ja': '時間|h', 'sl': 'u'},
'ERROR':{'lt': 'Klaida (%s eilutėje)', 'sid': 'Soro (%s xuruuri giddo)', 'fi': 'Virhe (rivillä %s)', 'ro': 'Eroare (la linia %s)', 'lv': 'Kļūda (rindā %s)', 'kn': 'ದೋಷ (%s ಸಾಲಿನಲ್ಲಿ)', 'hsb': 'Zmylk (w lince %s)', 'tr': 'Hata (%s satırında)', 'es': 'Error (en el renglón %s)', 'vec': 'Eror (inte ła riga %s)', 'el': 'Σφάλμα (στη γραμμή %s)', 'sv': 'Fel (på rad %s)', 'hr': 'Greška (u retku %s)', 'cs': 'Chyba (na řádku %s)', 'sr_Latn': 'Greška (red %s)', 'pl': 'Błąd (w linii %s)', 'he': 'שגיאה (בשורה %s)', 'nl': 'Error (op regel %s)', 'de': 'Fehler (in Zeile %s)', 'hi': 'त्रुटि (%s पंक्ति में)', 'ml': 'പിശക് (%s വരിയില്\u200d)', 'id': 'Galat (dalam baris %s)', 'gu': 'ભૂલ (વાક્ય %s માં)', 'ko': '오류 (%s 번째 줄)', 'zh_TW': '錯誤 (第 %s 列)', 'et': 'Viga (real %s)', 'ru': 'Ошибка (в строке %s)', 'sl': 'Napaka (v vrstici %s)', 'bn_IN': 'ত্রুটি (ইন লাইন %s)', 'am': 'ስህተት (በ መስመር %s) ላይ', 'mr': 'त्रुटी (ओळ %s वरील)', 'uk': 'Помилка (в рядку %s)', 'pt_BR': 'Erro (na linha %s)', 'kk': 'Қате (%s жолында)', 'te': 'దోషం (వరుస %s నందు)', 'br': 'Fazi (gant linenn %s)', 'is': 'Villa (á línu %s)', 'km': 'កំហុស (ក្នុង\u200bតួ %s)', 'nb': 'Feil (i linje %s)', 'bg': 'Грешка (в ред %s)', 'bs': 'Greška (u liniji %s)', 'eu': 'Errorea (%s lerroan)', 'hu': 'Hiba (%s. sor)', 'cy': 'Gwall (yn llinell: %s)', 'ast': 'Fallu (na llinia %s)', 'it': 'Errore (nella riga %s)', 'gug': 'Jejavy (líneape %s)', 'oc': 'Error (a la linha %s)', 'da': 'Fejl (i linje %s)', 'as': 'ত্ৰুটি (শাৰী %s ত)', 'gd': 'Mearachd (ann an loidhne %s)', 'or': 'ତ୍ରୁଟି (ଧାଡ଼ି %s ରେ)', 'ja': '(%s 行目で)エラー', 'nn': 'Feil (i linje %s)', 'fr': 'Erreur (à la ligne %s)', 'pt': 'Erro (na linha %s)', 'gl': 'Erro (na liña %s)', 'ar': 'خطأ (في السطر %s)', 'en_US': 'Error (in line %s)', 'sk': 'Chyba (na riadku %s)', 'sr': 'Грешка (ред %s)', 'zh_CN': '错误 (在第 %s 行)', 'eo': 'Eraro (en linio %s)', 'ta': 'பிழை (வரி %s இல்)', 'ca_valencia': "S'ha produït un error (a la línia %s)", 'ga': 'Earráid (ar líne %s)', 'ca': "S'ha produït un error (a la línia %s)", 'be': 'Памылка (у радку %s)', 'ug': 'خاتالىق(%s قۇردا)'},
'REFINDALL':{'lt': 'rask.viską', 'sid': 'baalahasi', 'fi': 'etsikaikki', 'ro': 'findall|cautătoate', 'lv': 'atrast_visu', 'kn': 'ಎಲ್ಲಾಹುಡುಕು', 'hsb': 'pytajwšě', 'tr': 'hepsinibul', 'es': 'buscar.todo|encontrar.todo|bt', 'el': 'εύρεσηόλων|findall', 'hr': 'pronađi sve', 'cs': 'najdivše', 'de': 'findealle', 'he': 'חיפושהכול', 'nl': 'vindalles', 'hu': 'talál', 'gu': 'બધુ શોધો', 'ko': '모두 찾기', 'zh_TW': '找全部|全找|findall', 'mr': 'सर्व शोधा', 'ru': 'найти_всё', 'sl': 'najdivse', 'am': 'ሁሉንም መፈለጊያ', 'et': 'leia_kõik', 'uk': 'знайти_все', 'pt_BR': 'localizaTudo', 'kk': 'барлығын_табу', 'br': 'kavout an holl', 'is': 'finnaallt', 'nb': 'finnalle|findall', 'bs': 'nadjisve', 'eu': 'bilatudenak', 'ast': 'alcontrartoo', 'gug': 'hekaopavave', 'or': 'ସମସ୍ତଙ୍କୁ ଖୋଜନ୍ତୁ', 'ja': '見つかったものを全部ならべる|findall', 'nn': 'finnalle|findall', 'fr': 'touttrouver', 'gl': 'atopartodo', 'ar': 'اعثر_على_كل', 'en_US': 'findall', 'sk': 'nájsťvšetko|nv', 'zh_CN': '查找全部|全部查找|findall', 'eo': 'serĉu_ĉion|ĉionserĉu', 'ca_valencia': 'cerca.tot|troba.tot', 'ca': 'cerca.tot|troba.tot', 'oc': 'trobartot'},
'TEXT':{'lt': 'tekstas', 'th': 'ข้อความ', 'sid': 'borro', 'fi': 'teksti', 'mk': 'Текст', 'sl': 'besedilo', 'lv': 'teksts', 'kn': 'ಪಠ್ಯ', 'hsb': 'tekst', 'tr': 'metin', 'es': 'texto', 'el': 'κείμενο|text', 'dz': 'ཚིག་ཡིག', 'hr': 'tekst', 'cs': 'popisek', 'as': 'লিখনী', 'ug': 'تېكست', 'he': 'טקסט', 'nl': 'Tekst', 'hu': 'szöveg', 'hi': 'पाठ', 'ml': 'വാചകം', 'gu': 'લખાણ', 'ko': '텍스트', 'br': 'testenn', 'zh_TW': '文字|text', 'mr': 'मजकूर', 'sat': 'ओनोलओनोल.', 'oc': 'tèxte', 'mai': 'पाठ', 'rw': 'umwandiko', 'sa_IN': 'पाठ्यम्', 'bn_IN': 'পাঠ্য', 'am': 'ጽሁፍ', 'et': 'tekst', 'uk': 'текст', 'kmr_Latn': 'Nivîs', 'pt_BR': 'texto', 'kk': 'мәтін', 'te': 'పాఠ్యము', 'af': 'teks', 'is': 'texti', 'tg': 'матн', 'km': 'អត្ថបទ', 'nb': 'tekst|text', 'kok': 'मजकूर', 'bs': 'tekst', 'eu': 'testua', 'sw_TZ': 'matini', 'ks': 'مواد', 'cy': 'testun', 'pa_IN': 'ਟੈਕਸਟ', 'ast': 'testu', 'gug': "moñe'ẽrã", 'vi': 'văn bản', 'lo': 'ຂໍ້ຄວາມ', 'brx': 'फराय बिजाब', 'gd': 'teacsa', 'ru': 'текст', 'or': 'ପାଠ୍ୟ', 'ja': '文字|テキスト|text', 'nn': 'tekst|text', 'fr': 'texte', 'be': 'тэкст', 'sq': 'tekst', 'fa': 'متن', 'gl': 'texto', 'ar': 'نص', 'om': 'barruu', 'en_US': 'text', 'si': 'පෙළ', 'zh_CN': '文字|文本|text', 'bn': 'পাঠ্য', 'ta': 'உரை', 'ne': 'पाठ', 'eo': 'teksto', 'dgo': 'इबारत', 'uz': 'matn', 'mn': 'бичвэр', 'mni': 'তেক্স', 'my': 'စာသား', 'ka': 'ტექსტი'},
'ROUNDED':{'lt': 'apvalus', 'sid': 'doyssi', 'fi': 'pyöreä', 'ro': 'round|rotund', 'lv': 'apaļš', 'kn': 'ದುಂಡಾದ', 'hsb': 'kulojty', 'tr': 'yuvarla', 'es': 'redondear', 'el': 'στρογγυλό|round', 'hr': 'okruglo', 'cs': 'oblé', 'de': 'rund', 'he': 'עגול', 'nl': 'rondaf', 'hu': 'kerek', 'hi': 'गोल', 'ml': 'ഉരുണ്ട', 'gu': 'રાઉન્ડ', 'my': 'ပတ်လည်', 'ko': '반올림', 'zh_TW': '圓角|round', 'mr': 'गोलाकार', 'ru': 'скруглить', 'sl': 'zaobljeno', 'bn_IN': 'রাউন্ড', 'am': 'ክብ', 'et': 'ümar', 'uk': 'закруглити', 'pt_BR': 'arredondado', 'kk': 'домалақтау', 'te': 'రౌండ్', 'br': 'ront', 'is': 'rúnnað', 'km': 'មូល', 'nb': 'avrundet|round', 'bs': 'okruglo', 'eu': 'biribildua', 'cy': 'crwn', 'pa_IN': 'ਗੋਲ', 'ast': 'redondu', 'gug': "emoapu'a", 'vi': 'Làm tròn', 'as': 'গোলাকাৰ', 'gd': 'cruinn', 'or': 'ଗୋଲାକାର', 'ja': '角を丸くする|round', 'nn': 'avrunda|round', 'fr': 'arrondi', 'be': 'круглы', 'sq': 'rrumbullak', 'oc': 'arredondit', 'gl': 'arredondar', 'ar': 'دائري', 'en_US': 'round', 'sk': 'zaokrúhlené', 'zh_CN': '圆角|rounded|round', 'eo': 'ronda', 'ta': 'வட்டம்', 'ca_valencia': 'arrodoneix|arrod', 'ne': 'गोलाकार', 'ca': 'arrodoneix|arrod', 'si': 'වටකුරු', 'ug': 'يۇمۇلاق', 'ka': 'მრგვალი'},
'RANGE':{'fi': 'alue', 'kn': 'ವ್ಯಾಪ್ತಿ', 'hr': 'raspon', 'de': 'folge', 'he': 'טווח', 'nl': 'Bereik', 'hu': 'sor', 'ml': 'പരന്പര', 'ko': '범위', 'mr': 'रेंज', 'mai': 'परिसर', 'am': 'መጠን', 'et': 'vahemik', 'kk': 'ауқым', 'te': 'విస్తృతి', 'af': 'omvang', 'tg': 'Қитъа', 'km': 'ជួរ', 'fr': 'plage', 'kok': 'व्याप्ती', 'eu': 'barrutia', 'lv': 'diapazons', 'gug': 'intervalo', 'vi': 'phạm vi', 'lo': 'ຂອບເຂດ', 'gd': 'rainse', 'hsb': 'slěd', 'nb': 'område|range', 'be': 'дыяпазон', 'sq': 'interval', 'om': 'hangii', 'en_US': 'range', 'sk': 'oblasť', 'ta': 'வரம்பு', 'dgo': 'फलाऽ', 'zh_CN': '范围|range', 'lt': 'sritis', 'th': 'ช่วง', 'sid': 'hakkigeeshsha', 'mk': 'Опсег', 'ro': 'range|interval', 'pa_IN': 'ਰੇਜ਼', 'as': 'বিস্তাৰ', 'nn': 'område|range', 'es': 'intervalo', 'el': 'περιοχή|range', 'dz': 'ཁྱབ་ཚད།', 'cs': 'rozsah', 'sl': 'obseg', 'hi': 'दायरा', 'gu': 'વિસ્તાર', 'bn': 'পরিসর', 'zh_TW': '範圍|range', 'sat': 'पासनाव', 'ru': 'диапазон', 'rw': 'igice', 'bn_IN': 'পরিসর', 'uk': 'діапазон', 'kmr_Latn': 'Navber', 'pt_BR': 'intervalo', 'br': 'lijorenn', 'is': 'svið', 'bs': 'opseg', 'sa_IN': 'प्रसरः', 'sw_TZ': 'masafa', 'ks': 'حد', 'my': 'ကန့်သတ်နယ်ပယ်', 'ast': 'rangu', 'tr': 'aralık', 'brx': 'सारि', 'mn': 'муж', 'or': 'ପରିସର', 'ja': '範囲|range', 'cy': 'ystod', 'fa': 'محدوده', 'gl': 'intervalo', 'ar': 'النطاق', 'oc': 'plaja', 'eo': 'amplekso', 'ca_valencia': 'interval', 'ne': 'दायरा', 'ca': 'interval', 'si': 'පරාසය', 'uz': 'oraliq', 'mni': 'রেন্জ', 'ka': 'ფორთოხლისფერი'},
'CIRCLE':{'lt': 'apskritimas', 'th': 'วงกลม', 'sid': 'doyicho', 'fi': 'ympyrä', 'ro': 'circle|cerc', 'lv': 'aplis', 'kn': 'ವೃತ್ತ', 'hsb': 'kruh', 'tr': 'daire', 'es': 'circulo|círculo', 'el': 'κύκλος|circle', 'hr': 'krug', 'cs': 'kruh', 'de': 'kreis', 'mn': 'тойрог', 'he': 'עיגול', 'nl': 'Cirkel', 'hu': 'kör', 'hi': 'वृत्त', 'ml': 'വൃത്തം', 'gu': 'વતૃળ', 'my': 'စက်ဝိုင်းပုံစံ', 'ko': '원', 'zh_TW': '圓|circle', 'mr': 'वर्तुळ', 'ru': 'круг', 'sl': 'krog', 'bn_IN': 'বৃত্ত', 'am': 'ክብ', 'et': 'ring', 'uk': 'коло', 'pt_BR': 'círculo|circunferência', 'kk': 'шеңбер', 'te': 'వృత్తము', 'br': "kelc'h", 'is': 'hringur', 'km': 'រង្វង់', 'nb': 'sirkel|circle', 'bs': 'krug', 'eu': 'zirkulua', 'cy': 'cylch', 'pa_IN': 'ਚੱਕਰ', 'ast': 'círculu', 'gug': 'círculo', 'vi': 'Tròn', 'as': 'বৃত্ত', 'gd': 'cearcall', 'or': 'ବୃତ୍ତ', 'ja': '円|circle', 'nn': 'sirkel|circle', 'fr': 'cercle', 'be': 'акружына', 'sq': 'rreth', 'oc': 'cercle', 'gl': 'círculo', 'ar': 'دائرة', 'en_US': 'circle', 'sk': 'obryskruhu', 'zh_CN': '圆|circle', 'eo': 'cirklo', 'ta': 'வட்டம்', 'ca_valencia': 'cercle', 'ne': 'वृत्त', 'ca': 'cercle', 'si': 'කවය', 'ug': 'چەمبەر', 'ka': 'წრე'},
'RANDOM':{'lt': 'bet.koks', 'sid': 'hedeweelcho', 'fi': 'satunnainen', 'ro': 'random|aleator', 'lv': 'nejaušs', 'kn': 'ಯಾವುದಾದರು', 'hsb': 'připadny', 'tr': 'rastgele', 'es': 'aleatorio', 'el': 'τυχαίο|random', 'hr': 'nasumično', 'cs': 'náhodné', 'de': 'zufällig', 'he': 'אקראי', 'nl': 'random|willekeurig', 'hu': 'véletlen|véletlenszám|vszám|kiválaszt', 'hi': 'बेतरतीब', 'gu': 'અવ્યવસ્થિત', 'ko': '임의', 'zh_TW': '隨機|random', 'mr': 'रँडम', 'ru': 'случайно', 'sl': 'naključno', 'bn_IN': 'এলোমেলো', 'am': 'በነሲብ', 'et': 'juhuslik', 'uk': 'випадкове', 'pt_BR': 'aleatório|sorteieNúmero|sortNum', 'kk': 'кездейсоқ', 'te': 'యాదృశ్చిక', 'br': 'dargouezhek', 'is': 'slembið', 'km': 'ចៃដន្យ', 'nb': 'tilfeldig|random', 'bs': 'slučajno', 'eu': 'ausazkoa', 'cy': 'ar hap', 'ast': 'aleatoriu', 'gug': "Po'a Oimeraẽa (azar)", 'as': 'যাদৃচ্ছিক', 'or': 'ଅନିୟମିତ', 'ja': 'でたらめな数|乱数|ランダム|random', 'nn': 'tilfeldig|random', 'fr': 'hasard', 'gl': 'aleatorio', 'ar': 'عشوائي', 'en_US': 'random', 'sk': 'náhodné', 'zh_CN': '随机|random', 'eo': 'harzarda', 'ca_valencia': 'aleatori', 'ca': 'aleatori', 'oc': 'aleatòri'},
'CLOSE':{'lt': 'sujunk', 'th': 'ปิด', 'sid': 'cufi', 'fi': 'sulje', 'ro': 'close|închide', 'lv': 'aizvērt', 'kn': 'ಮುಚ್ಚು', 'hsb': 'začinić', 'tr': 'kapat', 'es': 'cerrar', 'el': 'κλείσιμο|close', 'hr': 'zatvori', 'cs': 'uzavři', 'de': 'schliessen|schließen', 'he': 'סגירה', 'nl': 'sluiten', 'hu': 'zár', 'hi': 'बन्द करें', 'ml': 'അടയ്ക്കുക', 'gu': 'બંધ કરો', 'my': 'ပိတ်ပါ', 'ko': '닫기', 'zh_TW': '關閉|close', 'mr': 'बंद करा', 'ru': 'закрыть', 'sl': 'zaključi', 'bn_IN': 'বন্ধ', 'am': 'መዝጊያ', 'et': 'sulge', 'uk': 'закрити', 'pt_BR': 'fechar|feche', 'kk': 'жабу', 'te': 'మూయు', 'br': 'serriñ', 'is': 'loka', 'km': 'បិទ', 'nb': 'lukk|close', 'bs': 'blizu', 'eu': 'itxi', 'cy': 'cau', 'pa_IN': 'ਬੰਦ ਕਰੋ', 'ast': 'zarrar', 'gug': 'mboty', 'vi': 'Đóng', 'as': 'বন্ধ কৰক', 'or': 'ବନ୍ଦ କରନ୍ତୁ', 'ja': '折れ線を閉じる|close', 'nn': 'lukk|close', 'fr': 'fermer', 'be': 'закрыць', 'sq': 'mbylle', 'oc': 'tampar', 'gl': 'pechar', 'ar': 'أغلق', 'ug': 'ياپ', 'sk': 'Zatvoriť', 'zh_CN': '关闭|close', 'eo': 'fermu', 'ta': 'மூடு', 'ca_valencia': 'tanca', 'ne': 'बन्द गर्नुहोस्', 'ca': 'tanca', 'si': 'වසන්න', 'en_US': 'close', 'ka': 'დახურვა'},
'INT':{'lt': 'sveikoji.dalis|svdl', 'sid': 'di"ikkanno', 'kk': 'бүтін', 'fi': 'kokonaisl', 'br': 'kevan', 'sat': 'INT', 'is': 'heilt', 'fr': 'ent', 'kok': 'INT', 'bs': 'cijeli broj', 'nn': 'heiltal', 'tr': 'Tamsayı', 'el': 'ακέραιο|int', 'lv': 'vesels', 'uk': 'ціле', 'cs': 'celé', 'de': 'ganz', 'or': 'ଗଣନ ସଂଖ୍ୟା', 'he': 'שלם', 'hsb': 'cyły', 'eu': 'osoa', 'nb': 'heltall|int', 'hu': 'egészszám|egész', 'ar': 'عدد_صحيح', 'en_US': 'int', 'sk': 'celé', 'ko': '정수', 'eo': 'entjero|ent', 'zh_TW': '整數|int', 'et': 'täisarv', 'dgo': 'INT', 'ru': 'целое', 'sl': 'celo', 'sa_IN': 'INT', 'zh_CN': '整数|int', 'ja': '切り捨て|整数|整数に|int', 'mr': 'इंट'},
'FLOAT':{'lt': 'trupmeninis.skaičius|trsk', 'sid': 'womi', 'fi': 'desimaalil', 'lv': 'reāls', 'kn': 'ತೇಲು', 'hsb': 'decimalny', 'tr': 'kayan', 'el': 'κινητήυποδιαστολή|float', 'hr': 'plutajući', 'cs': 'desetinné', 'de': 'dezimal', 'he': 'שבר', 'hu': 'törtszám|tört', 'hi': 'प्लावित करें', 'ml': 'ഫ്\u200dളോട്ട്', 'gu': 'અપૂર્ણાંક', 'ko': '둥둥 뜨기', 'zh_TW': '浮點|float', 'mr': 'फ्लोट', 'sat': 'चापे.', 'ru': 'дробное', 'sl': 'plavajoče', 'bn_IN': 'ভাসমান', 'am': 'ማንሳፈፊያ', 'et': 'ujukoma', 'uk': 'дробове', 'pt_BR': 'real', 'kk': 'бөлшек', 'te': 'ఫ్లోట్', 'br': 'tonnañ', 'is': 'fleyti', 'km': 'អណ្ដែត', 'nb': 'flyttall|float', 'bs': 'realni', 'eu': 'dezimala', 'cy': 'arnofio', 'pa_IN': 'ਤੈਰਦਾ', 'ast': 'flotante', 'gug': 'vevúi', 'vi': 'Nổi', 'or': 'ଚଳମାନ', 'ja': '小数|小数に|float', 'nn': 'flyttal|desimaltal|float', 'fr': 'virgule', 'be': 'дробавае', 'oc': 'virgula', 'gl': 'flotante', 'ar': 'عدد_عشري', 'en_US': 'float', 'sk': 'Plávať', 'zh_CN': '浮点|小数|float', 'eo': 'reelo', 'ne': 'फ्लोट', 'si': 'පාවීම', 'my': 'ပေါလောပေါ်သည်', 'ka': 'მოლივლივე'},
'LIBRELOGO':{'hi': 'लिब्रेलोगो', 'or': 'Libre ପ୍ରତୀକ', 'mr': 'लाइबरलोगो', 'ml': 'ലിബര്\u200dലോഗോ', 'te': 'లిబ్రేలోగో', 'ar': 'ليبر\u200cلوغو', 'sr': 'Либрелого', 'en_US': 'LibreLogo', 'sr_Latn': 'Librelogo', 'am': 'የሊብሬ ምልክት', 'ko': '리브레로고'},
'FORWARD':{'lt': 'priekin|pr', 'th': 'เดินหน้า|fd', 'sid': 'albira|ar', 'fi': 'eteen|et', 'ro': 'forward|fd|înainte', 'lv': 'uz_priekšu|pr', 'kn': 'ಮುಂದಕ್ಕೆ|fd', 'hsb': 'doprědka|dp', 'tr': 'ileri|il', 'es': 'avanza|adelante|av|ad', 'el': 'μπροστά|μπ|forward|fd', 'hr': 'naprijed|np', 'cs': 'dopředu|do', 'de': 'vor|vr', 'he': 'קדימה|קד', 'nl': 'vooruit|vu', 'hu': 'előre|e', 'ko': '앞으로|fd', 'zh_TW': '前進|進|forward|fd', 'mr': 'पुढे|fd', 'ru': 'вперёд|в', 'sl': 'naprej|np', 'am': 'ወደ ፊት|ወደ ፊት', 'et': 'edasi|e', 'uk': 'вперед|вп', 'pt_BR': 'paraFrente|pf', 'kk': 'алға|ал', 'br': 'war-raok|fd', 'km': 'បញ្ជូន\u200bបន្ត|fd', 'nb': 'forover|fram|fd', 'bs': 'naprijed|fd', 'eu': 'aurrera|aur', 'cy': 'ymlaen|fd', 'ast': 'avanzar|av', 'gug': 'tenondépe|td', 'or': 'ଆଗକୁ|fd', 'ja': 'すすむ|forward|fd', 'nn': 'fram|framover|forover|fr|forward', 'fr': 'avance|av', 'be': 'наперад|нп', 'sq': 'përpara|fd', 'gl': 'reenviada|fd', 'ar': 'للأمام|أم', 'en_US': 'forward|fd', 'sk': 'dopredu|do', 'eo': 'antaŭen|a', 'ca_valencia': 'avança|avant|davant|av', 'ca': 'avança|endavant|davant|av', 'zh_CN': '前进|进|forward|fd'},
'REPEAT':{'lt': 'kartok|amžinai', 'sid': 'wirroqoli|hegerera', 'fi': 'toista', 'ro': 'repeat|forever|repetă', 'lv': 'atkārtot|mūžīgi', 'kn': 'ಪುನರಾವರ್ತಿಸು|ಯಾವಾಗಲೂ', 'hsb': 'wospjetować|wsp', 'tr': 'tekrarla|sürekli', 'es': 'repetir|rep|siempre', 'el': 'επανάληψη|repeat|forever', 'hr': 'ponavljaj|zauvijek', 'cs': 'opakuj|pořád', 'de': 'wiederhole|wdh', 'he': 'חזרה|לעד|לנצח|לתמיד', 'nl': 'herhaal|vooraltijd', 'hu': 'ismét|ism|ismétlés|végtelenszer|vszer', 'ko': '반복|계속', 'zh_TW': '重複|重復|永遠|repeat|forever', 'mr': 'रिपिट|फॉरएव्हेर', 'ru': 'повторять|бесконечно', 'sl': 'ponovi|neskončno', 'am': 'መድገሚያ|ለዘለአለም', 'et': 'korda|igavesti|lõpmatuseni', 'uk': 'завжди', 'pt_BR': 'repetir|repita', 'kk': 'қайталау|шексіз', 'br': 'arren|forever', 'km': 'ធ្វើ\u200bឡើង\u200bវិញ|រហូត', 'nb': 'gjenta|for alltid|repeat', 'bs': 'ponavljaj|zauvijek', 'eu': 'errepikatu|betiko', 'ast': 'repetir|pasiempres', 'gug': "ha'ejevy|tapia", 'or': 'ପୁନରାବୃତ୍ତି|forever', 'ja': 'くりかえす|repeat', 'nn': 'gjenta|for alltid|repeat', 'fr': 'répète|toujours', 'be': 'паўтараць|бясконца', 'gl': 'repetir|sempre', 'ar': 'كرر|للأبد', 'en_US': 'repeat|forever', 'sk': 'opakovať|stále', 'eo': 'ripetu|ĉiame|ĉiam', 'ca_valencia': 'repeteix|rep', 'ca': 'repeteix|rep', 'zh_CN': '重复|repeat|forever'},
'ERR_MAXRECURSION':{'lt': 'viršytas didžiausias rekursijos lygis (%d).', 'sid': 'jawiidi wirro higate linxe (%d) roortino.', 'fi': 'suurin sallittu rekursion syvyys (%d) on saavutettu.', 'ro': 'Numărul maxim de recursii (%d) depășit.', 'lv': 'pārsniegts maksimālais rekursijas dziļums (%d).', 'kn': 'ಗರಿಷ್ಟ ಪುನರಾವರ್ತನಾ ಆಳವು (%d) ಮೀರಿದೆ.', 'hsb': 'Maksimalna rekursijna hłubokosć (%d) překročena.', 'es': 'se ha superado la profundidad máxima de recursividad (%d).', 'vec': 'suparà ła profondità recorsiva màsima (%d).', 'el': 'το μέγιστο βάθος αναδρομής (%d) ξεπεράστηκε.', 'sv': 'maximalt rekursionsdjup (%d) har överskridits.', 'hr': 'premašena je maksimalna dubina rekurzije (%d).', 'cs': 'překročena maximální hloubka rekurze (%d).', 'sr_Latn': 'Prekoračena je maksimalna dubina rekurzije(%d).', 'pl': 'przekroczono maksymalną głębokość (%d) rekursji.', 'he': 'הגעת לעומק הנסיגה/רקורסיה (%d) המרבי.', 'nl': 'maximum van recursiediepte (%d) overschreden.', 'de': 'Maximale Rekursionstiefe (%d) erreicht.', 'hi': 'अधिकतम रिकर्सन गहराई (%d) बढ़ गया.', 'ml': 'ഏറ്റവും കൂടിയ റിക്കര്\u200dഷന്\u200d വ്യാപ്തി (%d) വര്\u200dദ്ധിച്ചിരിയ്ക്കുന്നു.', 'id': 'kedalaman rekursi maksimum (%d) terlampaui.', 'gu': 'મહત્તમ રિકર્ઝન ઊંડાઈ (%d) ઓળંગાઈ.', 'ko': '최대 재귀 수준(%d)을 초과하였습니다.', 'zh_TW': '已超出最大遞迴深度 (%d)。', 'et': 'ületati suurim rekursioonisügavus (%d).', 'ru': 'превышена максимальная глубина рекурсии (%d).', 'sl': 'največja globina rekurzije (%d) presežena.', 'bn_IN': 'সর্বাধিক রিকারসিয়ন ডেপথ (%d) ছাড়িয়ে গেছে।', 'am': 'ከፍተኛውን መደጋገሚያ መጠን (%d) አልፏል', 'mr': 'मॅक्सिमम रिकर्शन डेप्थ (%d) वाढले.', 'uk': 'перевищено найбільшу глибину рекурсії (%d).', 'pt_BR': 'profundidade máxima de recursão (%d) excedida.', 'kk': 'рекурсияның максималды тереңдігінен (%d) асып кеттік.', 'te': 'గరిష్ట రికర్షన్ డెప్త్ (%d) మించెను.', 'br': "aet eo dreist an donder (%d) askizañ uc'hek .", 'is': 'hámarki endurkvæmrar dýptar (%d) náð.', 'km': 'ជម្រៅ\u200bកើត\u200bឡើង\u200b\u200bដដែល\u200bអតិបរមា (%d) បាន\u200bលើស។', 'nb': 'maksimum rekursjonsdypde (%d) overskredet.', 'bg': 'надхвърлена е максималната дълбочина на рекурсия (%d).', 'bs': 'maksimalna dubina rekurzija (%d) premašena.', 'eu': 'gehieneko errekurtsio-sakonera (%d) gainditu da.', 'hu': 'Elérve az újrahívási korlát (%d).', 'cy': "tu hwnt i'r uchafswm dychweliad dyfnder (%d).", 'ast': 'fondura máxima recursiva (%d) perpasada.', 'it': 'profondità ricorsiva massima (%d) superata.', 'tr': 'en çok yineleme derinliği (%d) aşıldı.', 'oc': 'prigondor (%d) de recursion maximum depassat.', 'da': 'maksimale gennemløb (%d) blev overskredet.', 'as': 'সৰ্বাধিক ৰিকাৰ্চন গভিৰতা (%d) অতিক্ৰম হৈছে।', 'gd': 'barrachd ath-chùrsaidh na tha ceadaichte (%d).', 'or': 'ସର୍ବାଧିକ ପୁନଃପୌନିକ ଘଭୀରତା (%d) ଅତିକ୍ରମ କରିଛି।', 'ja': '再帰の深さが最大値(%d)を越えました。', 'nn': 'maksimum rekursjonsdjupn (%d) er overskride.', 'fr': 'profondeur (%d) de récursion maximum dépassée.', 'pt': 'profundidade máxima (%d) excedida', 'gl': 'máxima profundidade recursiva (%d) sobrepasada.', 'en_US': 'maximum recursion depth (%d) exceeded.', 'sk': 'bola prekročená maximálna hĺbka rekurzie (%d).', 'sr': 'Прекорачена је максимална дубина рекурзије(%d).', 'zh_CN': '已超出最大递归深度 (%d)。', 'eo': 'superis la maksimuman rekuran profundon (%d).', 'ta': 'அதிகபட்ச மீள் நிகழ்வு அளவு (%d) மீறப்பட்டது.', 'ca_valencia': "s'ha superat la profunditat màxima de recursivitat (%d).", 'ga': 'sáraíodh an uasdoimhneacht athchúrsála (%d).', 'ca': "s'ha superat la profunditat màxima de recursivitat (%d).", 'be': 'перавышана максімальная глыбіня рэкурсіі (%d).', 'ug': 'ئەڭ يۇقىرى قايتىلاش چوڭقۇرلۇقى (%d) دىن ئېشىپ كەتتى.'},
'TOMATO':{'lt': 'pomidorų', 'sid': 'timaatime', 'fi': 'tomaatti', 'lv': 'tomātu', 'kn': 'ಟೊಮ್ಯಾಟೊ', 'hsb': 'ćmowočerwjeny', 'tr': 'koyu kırmızı', 'es': 'tomate|jitomate', 'el': 'τοματί|tomato', 'hr': 'rajčica', 'cs': 'cihlová', 'sr_Latn': 'paradajz crvena', 'he': 'עגבניה', 'nl': 'tomaat', 'de': 'dunkelrot', 'hi': 'टमाटर', 'ml': 'തക്കാളി', 'gu': 'ટોમેટો', 'ko': '토마토', 'zh_TW': '蕃茄紅|茄紅|tomato', 'mr': 'टोमॅटो', 'ru': 'тёмно-красный', 'sl': 'paradižnikova', 'bn_IN': 'টোমাটো', 'am': 'ቲማቲም', 'et': 'tomatipunane|tomatikarva', 'uk': 'томатний', 'pt_BR': 'tomate', 'kk': 'күңгірт_қызыл', 'te': 'టొమాటో', 'br': 'tomatez', 'is': 'tómatur', 'km': 'ប៉េងប៉ោះ', 'nb': 'tomatrød|tomato', 'bs': 'paradajz', 'eu': 'tomatea', 'hu': 'világospiros', 'ast': 'tomate', 'gug': 'tomate', 'as': 'টমেটো', 'gd': 'tomàto', 'or': 'ଟୋମାଟୋ', 'ja': 'トマト|トマト色|tomate', 'nn': 'tomatraud|tomato', 'fr': 'tomate', 'be': 'тамат', 'gl': 'tomate', 'ar': 'طماطمي', 'en_US': 'tomato', 'sk': 'paradajková', 'sr': 'парадајз црвена', 'eo': 'tomata', 'ta': 'தக்காளி', 'ca_valencia': 'tomàquet|tomata', 'ca': 'tomàquet|tomata', 'zh_CN': '番茄红|tomato'},
'RED':{'lt': 'raudona', 'th': 'แดง', 'sid': 'duumo', 'fi': 'punainen', 'ro': 'red|roșu', 'lv': 'sarkans', 'kn': 'ಕೆಂಪು', 'hsb': 'čerwjeny', 'tr': 'kırmızı', 'es': 'rojo', 'el': 'κόκκινο|red', 'hr': 'crvena', 'cs': 'červená', 'sr_Latn': 'crvena', 'he': 'אדום', 'nl': 'rood', 'de': 'rot', 'hi': 'लाल', 'ml': 'ചുവപ്പ്', 'gu': 'લાલ', 'ko': '빨간색', 'sd': 'ڳاڙهو', 'zh_TW': '紅|red', 'mr': 'लाल', 'sat': 'आराक्', 'ru': 'красный', 'sl': 'rdeča', 'sa_IN': 'वुज़ुल', 'bn_IN': 'লাল', 'am': 'ቀይ', 'et': 'punane', 'uk': 'червоний', 'pt_BR': 'vermelho', 'kk': 'қызыл', 'te': 'ఎరుపు', 'br': 'ruz', 'is': 'rautt', 'km': 'ក្រហម', 'nb': 'rød|red', 'kok': 'तांबडोTambddo', 'bs': 'crvena', 'eu': 'gorria', 'hu': 'piros|vörös', 'cy': 'coch', 'ast': 'bermeyu', 'gug': 'pytã', 'as': 'ৰঙা', 'gd': 'dearg', 'or': 'ଲାଲି', 'ja': '赤|red', 'nn': 'raud|red', 'fr': 'rouge', 'be': 'чырвоны', 'gl': 'vermello', 'ar': 'أحمر', 'en_US': 'red', 'sk': 'červená', 'sr': 'црвена', 'zh_CN': '红|红色|red', 'eo': 'ruĝa', 'ta': 'சிவப்பு', 'ca_valencia': 'roig|roig', 'ca': 'vermell|roig', 'dgo': 'सूहा', 'oc': 'roge'},
'RECTANGLE':{'lt': 'stačiakampis', 'th': 'สี่เหลี่ยมผืนผ้า', 'sid': 'rekitaangile', 'fi': 'suorakulmio', 'ro': 'rectangle|dreptunghi', 'lv': 'taisnstūris', 'kn': 'ಆಯತ', 'hsb': 'praworóžk', 'tr': 'dikdörtgen', 'es': 'rectangulo|rectángulo', 'el': 'ορθογώνιο|rectangle', 'hr': 'pravokutnik', 'cs': 'obdélník', 'de': 'rechteck', 'mn': 'тэгш өнцөгт', 'he': 'מלבן', 'nl': 'rechthoek', 'hu': 'téglalap', 'hi': 'आयत', 'ml': 'ചതുര്ഭുജം', 'gu': 'લંબચોરસ', 'my': 'ထောင့်မှန်စတုဂံ', 'ko': '직사각형', 'zh_TW': '長方形|矩|rectangle', 'mr': 'आयत', 'ru': 'прямоугольник', 'sl': 'pravokotnik', 'bn_IN': 'আয়তক্ষেত্র', 'am': 'አራት ማእዘን', 'et': 'ristkülik', 'uk': 'прямокутник', 'pt_BR': 'retângulo', 'kk': 'тіктөртбұрыш', 'te': 'దీర్ఘ చతురస్రము', 'br': 'reizhkorneg', 'is': 'rétthyrningur', 'km': 'ចតុកោណកែង', 'bs': 'pravougao', 'eu': 'laukizuzena', 'cy': 'petryal', 'pa_IN': 'ਚਤੁਰਭੁਜ', 'ast': 'rectángulu', 'gug': 'rectángulo', 'vi': 'Hình chữ nhật', 'as': 'আয়ত', 'gd': 'ceart-cheàrnach', 'or': 'ଆୟତକ୍ଷେତ୍ର', 'ja': '長方形|rectangle', 'nn': 'rektangel|rectangle', 'nb': 'rektangel|rectangle', 'be': 'прамавугольнік', 'sq': 'drejtkëndësh', 'gl': 'rectángulo', 'ar': 'مستطيل', 'en_US': 'rectangle', 'sk': 'obdĺžnik', 'zh_CN': '矩形|矩|长方形|rectangle', 'eo': 'ortangulo', 'ta': 'செவ்வகம்', 'ne': 'आयात', 'si': 'ත්\u200dරිකෝණය', 'ug': 'تىك تۆت بۇلۇڭ', 'ka': 'მართკუთხედი'},
'DEG':{'en_US': '°', 'zh_TW': '°|度', 'zh_CN': '°|度'},
'FUCHSIA':{'lt': 'purpurinė', 'sid': 'daama|addama', 'fi': 'fuksia', 'lv': 'fuksiju|koši_rozā', 'kn': 'ನೇರಳೆಗೆಂಪು|ಕಡುಗೆಂಪು', 'hsb': 'magenta', 'tr': 'eflatun|mor', 'es': 'fucsia|magenta', 'el': 'φούξια|ματζέντα|fuchsia|magenta', 'hr': 'fuksija|magneta', 'cs': 'purpurová', 'sr_Latn': 'purpurna', 'he': "פוקסיה|מג׳נטה|מג'נטה", 'nl': 'fuchsia|foksia|magenta', 'de': 'magenta', 'ko': 'fuchsia|마젠타', 'zh_TW': '洋紅|紅紫|fuchsia|magenta', 'mr': 'फुशिआ|मजेंटा', 'ru': 'пурпурный', 'sl': 'fuksija|magentna', 'et': 'magenta|fuksiapunane', 'uk': 'пурпуровий', 'pt_BR': 'magenta', 'kk': 'қарақошқыл', 'br': 'fuchia|magenta', 'km': 'ស្វាយ\u200bខ្ចី|ស្វាយខ្ចី', 'is': 'blárauður', 'eu': 'magenta', 'hu': 'bíbor|ciklámen', 'ast': 'fucsia|maxenta', 'gug': 'fucsia|magenta', 'oc': 'fúcsia|magenta', 'ja': '明るい紫|フクシア|マゼンタ|fuchsia', 'nn': 'fuksia|magentaraud|magenta', 'nb': 'fuksia|magentarød|magenta', 'be': 'фуксія|пурпурны', 'gl': 'fucsia|maxenta', 'ar': 'فوشيا|أرجواني', 'en_US': 'fuchsia|magenta', 'sk': 'purpurová', 'sr': 'пурпурна', 'eo': 'fuksina', 'ca_valencia': 'fúcsia|magenta', 'ca': 'fúcsia|magenta', 'zh_CN': '紫红|紫红色|洋红|洋红色|fuchsia|magenta'},
'FOR':{'fi': 'jokaiselle', 'kn': 'ಗಾಗಿ', 'xh': 'ukwenzela', 'hr': 'za', 'de': 'für', 'he': 'עבור', 'nl': 'voor', 'hu': 'fut', 'ml': 'വേണ്ടി', 'st': 'bakeng sa', 'ko': '유형', 'mr': 'फॉर', 'mai': "क'लेल", 'am': 'ለ', 'et': 'igale_elemendile', 'kk': 'үшін', 'te': 'కొరకు', 'af': 'vir', 'tg': 'барои', 'km': 'សម្រាប់', 'kok': 'खातीर', 'eu': 'honentzat', 'lv': 'katram', 'gug': 'haguã', 'vi': 'cho', 'lo': 'ສຳລັບ', 'gd': 'airson', 'rw': 'Cya', 'fr': 'pour', 'sq': 'për', 'om': 'kanaaf', 'ug': 'ئۈچۈن', 'sk': 'pre', 'br': 'evit', 'dgo': 'लेई', 'en_US': 'for', 'lt': 'ciklas.intervale|nuo.iki', 'th': 'สำหรับ', 'sid': 'ra', 'zu': 'kwe', 'ss': 'ye', 'mk': 'за', 'ro': 'for|pentru', 'pa_IN': 'ਲਈ', 'as': 'কাৰণে', 'hsb': 'za', 'es': 'para', 'el': 'γιαόσο|for', 'dz': 'དོན་ལུ།', 'tn': 'ya', 'cs': 'pro', 'sl': 'za', 'hi': 'के लिए', 'gu': 'માટે', 've': 'u itela', 'sd': 'لاءِ', 'zh_TW': '取|for', 'sat': 'ला़गितला़गित्', 'bo': 'ལ་སྤྱོད།', 'ru': 'для', 'nso': 'bakeng sa', 'bn_IN': 'জন্য', 'uk': 'для', 'kmr_Latn': 'ji bo', 'pt_BR': 'para', 'bn': 'জন্য', 'is': 'fyrir', 'bs': 'za', 'cy': 'ar gyfer', 'sw_TZ': 'kwa', 'ks': 'کےلئے', 'my': 'အတွက်', 'ast': 'pa', 'tr': 'için', 'brx': 'थाखाय', 'mn': 'хувьд', 'or': 'ପାଇଁ', 'ja': 'ひとつずつ|for', 'sa_IN': 'कृते', 'nr': 'kwe', 'fa': 'برای', 'gl': 'Para', 'ar': 'لـ', 'oc': 'per', 'zh_CN': '取|for', 'eo': 'por', 'ca_valencia': 'per.a', 'ne': 'लागि', 'ca': 'per.a', 'si': 'සඳහා', 'ts': 'eka', 'uz': 'uchun', 'mni': '-গীদমক', 'ka': '-'},
'COS':{'eo': 'kos', 'sid': 'koose', 'fi': 'kosini', 'br': 'kos', 'en_US': 'cos', 'sat': 'COS', 'is': 'kós', 'kok': 'COS', 'sa_IN': 'COS', 'ar': 'جتا', 'el': 'συνημίτονο|cos', 'mr': 'कॉस', 'dgo': 'COS', 'tr': 'kos', 'zh_TW': '餘弦|cos', 'zh_CN': '余弦|cos', 'am': 'ኮስ', 'he': 'קוסינוס'},
'MAX':{'lt': 'maks.|maksimumas', 'sid': 'jawa', 'fi': 'suurin', 'lv': 'maks', 'kn': 'ಗರಿಷ್ಟ', 'nn': 'maks|max', 'el': 'μέγιστο|max', 'hr': 'maks', 'he': 'מרבי', 'gu': 'મહત્તમ', 'ko': '최대값', 'sd': 'وڌِ ۾ وَڌِ', 'zh_TW': '最大值|最大|max', 'mr': 'मॅक्स', 'sat': 'ढेर उता़र,', 'ru': 'макс', 'sl': 'največ', 'sa_IN': 'ज़यादॆ खूते ज़यादॆ', 'bn_IN': 'সর্বোচ্চ', 'am': 'ከፍተኛ', 'et': 'max|maks', 'uk': 'макс', 'pt_BR': 'máximo|máx', 'kk': 'макс', 'te': 'గరిష్ట', 'br': "uc'hek", 'km': 'អតិបរមា', 'is': 'hám', 'kok': 'कमालGarixtt', 'cy': 'uchaf', 'tr': 'en çok', 'or': 'ସର୍ବାଧିକ', 'gd': 'as motha', 'ja': 'いちばん大きな数|最大値|最大|max', 'hsb': 'maks', 'nb': 'maks|max', 'be': 'макс', 'gl': 'máx', 'ar': 'الأقصى', 'en_US': 'max', 'eo': 'maks', 'ca_valencia': 'màx|max', 'ca': 'màx|max', 'dgo': 'बद्धोबद्ध', 'zh_CN': '最大值|max'},
'DOTTED':{'lt': 'taškeliai', 'th': 'จุดประ', 'sid': 'bixxillisama', 'fi': 'pisteistä', 'ro': 'dotted|punctat', 'lv': 'punktēts', 'kn': 'ಚುಕ್ಕಿಯುಕ್ತ', 'hsb': 'dypkowany', 'tr': 'noktalı', 'es': 'punteado', 'vec': 'pontinà', 'el': 'διάστικτο|dotted', 'hr': 'istočkano', 'cs': 'tečkovaná', 'de': 'gepunktet', 'he': 'ניקוד', 'nl': 'gestippeld', 'hu': 'pontozott', 'hi': 'बिंदुयुक्त', 'ml': 'ഡോട്ടുള്ള', 'gu': 'ટપકાંવાળુ', 'my': 'အစက်', 'ko': '점선', 'sd': 'نقطن وارو', 'zh_TW': '點線|dotted', 'mr': 'डॉटेड', 'sat': 'टुडा़क् आकान', 'ru': 'пунктирная', 'sl': 'pikasto', 'sa_IN': 'डाटिड', 'bn_IN': 'ডটেড', 'am': 'ነጠብጣብ', 'et': 'punktiir', 'uk': 'пунктирна', 'pt_BR': 'pontilhado', 'kk': 'пунктирлі', 'te': 'చుక్కలు', 'br': 'pikennaoueg', 'is': 'punktalína', 'km': 'ចុចៗ', 'nb': 'prikket|dotted', 'kok': "डॉटडTiboyil'lem", 'bs': 'tačkasto', 'eu': 'puntukatua', 'cy': 'dotiog', 'pa_IN': 'ਬਿੰਦੂ', 'ast': 'puntiáu', 'gug': "kyta'i kuéra", 'vi': 'Chấm chấm', 'as': 'ডটেড', 'gd': 'dotagach', 'or': 'ବିନ୍ଦୁମୟ', 'ja': '点線|dotted', 'nn': 'prikka|dotted', 'fr': 'pointillé', 'be': 'пункцір', 'oc': 'puntejat', 'gl': 'punteado', 'ar': 'منقط', 'en_US': 'dotted', 'sk': 'Bodkované', 'zh_CN': '点线|dotted', 'eo': 'punkta', 'ta': 'புள்ளியிட்ட', 'ca_valencia': 'puntejat', 'ca': 'puntejat', 'si': 'තිත් වැටුනු', 'dgo': 'बिंदीदार', 'ug': 'چېكىت سىزىق', 'ka': 'წერტილოვანი'},
'PT':{'lt': 'tšk', 'th': 'พอยต์', 'mk': 'точки', 'kk': 'пт', 'bn': 'পয়েন্ট', 'tg': 'пт', 'kok': 'पॉ', 'tr': 'nk', 'ks': 'پی ٹی', 'nr': 'i-pt', 'el': 'στιγμή|pt', 'dz': 'པི་ཊི།', 'hr': 'tč', 'or': 'ପିଟି', 'mn': 'цэг', 'tt': 'пт', 'be': 'пт', 'fa': 'نقطه', 'hi': 'पॉइंट', 'he': 'נק|נקודה', 'ar': 'نقطة', 'en_US': 'pt', 'ja': 'ポイント|pt', 'my': 'ပွိုင့်', 'zh_CN': '磅|pt', 'zh_TW': '點|pt', 'ru': 'пт', 'sl': 'tč', 'bn_IN': 'পয়েন্ট', 'am': 'ነጥብ', 'ka': 'პტ'},
'OR':{'fi': 'tai', 'kn': 'ಅಥವ', 'xh': 'okanye', 'hr': 'ili', 'de': 'oder', 'he': 'או', 'nl': 'of', 'hu': 'vagy', 'st': 'kapa', 'ko': '또는', 'mr': 'ऑर', 'mai': 'अथवा', 'am': 'ወይም', 'et': 'või', 'kk': 'немесе', 'te': 'లేదా', 'af': 'of', 'tg': 'ё', 'fr': 'ou', 'kok': 'वा', 'eu': 'edo', 'lv': 'vai', 'gug': 'o', 'vi': 'hoặc', 'gd': 'no', 'rw': 'cyangwa', 'nn': 'eller|or', 'nb': 'eller|or', 'sq': 'ose', 'om': 'ykn', 'ug': 'ياكى', 'sk': 'alebo', 'br': 'pe', 'dgo': 'जां', 'en_US': 'or', 'lt': 'nors.vienas|arba|or', 'th': 'หรือ', 'sid': 'woy', 'zu': 'noma', 'ss': 'nome', 'ro': 'or|sau', 'pa_IN': 'ਜਾਂ', 'hsb': 'abo', 'es': 'o', 'el': 'ή|or', 'dz': 'ཡང་ན།', 'tn': 'kgotsa', 'cs': 'nebo', 'sl': 'ali', 'hi': 'या', 'gu': 'અથવા', 've': 'kana', 'or': 'କିମ୍ବା', 'sd': 'يا', 'zh_TW': '或|or', 'sat': 'आर', 'bo': 'ཡང་ན།', 'ru': 'или', 'nso': 'goba', 'bn_IN': 'অথবা', 'uk': 'або', 'pt_BR': 'ou', 'tt': 'яки', 'bn': 'অথবা', 'is': 'eða', 'bs': 'ili', 'sa_IN': 'वा', 'sw_TZ': 'au', 'ks': 'یا', 'my': 'သို့မဟုတ်', 'ast': 'o', 'tr': 'veya', 'brx': 'एबा', 'mn': 'буюу', 'lb': 'oder', 'ja': 'または|or', 'cy': 'neu', 'nr': 'namkha', 'fa': 'یا', 'gl': 'ou', 'ar': 'أو', 'oc': 'o', 'zh_CN': '或|or', 'eo': 'aŭ', 'ca_valencia': 'o', 'ne': 'वा', 'ca': 'o', 'si': 'හෝ', 'ts': 'kumbe', 'uz': 'yoki', 'mni': 'নত্রগা', 'ka': 'ან'},
'ERR_NOTAPROGRAM':{'lt': 'Ar norite vykdyti šį teksto dokumentą?', 'sid': 'Tenne borrote bortaje harisa hasiratto?', 'fi': 'Haluatko suorittaa tämän tekstiasiakirjan?', 'ro': 'Doriți să rulați acest document text?', 'lv': 'Vai vēlaties izpildīt šo teksta dokumentu?', 'kn': 'ನೀವು ಈ ಪಠ್ಯ ದಸ್ತಾವೇಜನ್ನು ಚಲಾಯಿಸಲು ಬಯಸುವಿರಾ?', 'hsb': 'Chceće tutón tekstowy dokument wuwjesć?', 'tr': 'Bu metin belgesini çalıştırmak istiyor musunuz?', 'es': '¿Quiere ejecutar este documento de texto?', 'vec': "Vuto far partir 'sto documento de testo?", 'el': 'Θέλετε να τρέξετε αυτό το έγγραφο κειμένου;', 'sv': 'Vill du köra detta textdokument?', 'hr': 'Želite li pokrenuti ovaj tekstni dokument?', 'cs': 'Přejete si spustit tento textový dokument?', 'sr_Latn': 'Želite li da izvršite naredbe iz dokumenta?', 'pl': 'Czy na pewno chcesz uruchomić ten dokument tekstowy?', 'he': 'האם ברצונך להריץ מסמך טקסט זה?', 'nl': 'Wilt u dit tekstdocument uitvoeren?', 'de': 'Möchten Sie dieses Textdokument ausführen?', 'hi': 'क्या आप इस पाठ दस्तावेज़ को चलाना चाहते हैं?', 'ml': 'നിങ്ങള്\u200dക്കു് ഈ രേഖ നടപ്പിലാക്കണമോ?', 'id': 'Apakah Anda ingin menjalankan dokumen teks ini?', 'gu': 'શું તમે આ લખાણ દસ્તાવેજને ચલાવવા માંગો છો?', 'ko': '이 텍스트 문서에서 실행하시겠습니까?', 'zh_TW': '您是否要執行這份文字文件？', 'et': 'Kas soovid seda tekstidokumenti käivitada?', 'ru': 'Выполнить этот текстовый документ?', 'sl': 'Želite zagnati ta besedilni dokument?', 'bn_IN': 'অাপনি কি এই পাঠ্য নথি চালাতে চান?', 'am': 'ይህን የጽሁፍ ሰነድ ማስኬድ ይፈልጋሉ?', 'mr': 'तुम्हाला हे मजकूर दस्तऐवज चालवायचे?', 'uk': 'Виконати цей текстовий документ?', 'pt_BR': 'Deseja executar este documento de texto?', 'kk': 'Бұл мәтіндік құжатты орындау керек пе?', 'te': 'మీరు యీ పాఠం పత్రమును నడుపాలి అనుకొనుచున్నారా?', 'br': "Ha fellout a ra deoc'h erounit an teul mod testenn-mañ ?", 'is': 'Viltu keyra þetta textaskjal?', 'km': 'តើ\u200bអ្នក\u200bចង់\u200bដំណើរការ\u200bឯកសារ\u200bនេះ?', 'nb': 'Vil du kjøre dette tekstdokumentet?', 'bg': 'Желаете ли да се изпълни този текстов документ?', 'bs': 'Da li želite pokrenuti ovaj tekstualni dokument?', 'eu': 'Testu-dokumentu hau exekutatu nahi duzu?', 'hu': 'Szeretné futtatni ezt a szöveges dokumentumot?', 'cy': 'Hoffech chi redeg y ddogfen testun hon?', 'ast': '¿Quier executar esti documentu de testu?', 'it': 'Vuoi eseguire questo documento di testo?', 'gug': "¿Remomba'apo sépa ko documento moñe'ẽrãgui?", 'oc': 'Volètz executar aqueste document tèxte ?', 'da': 'Ønsker du at køre dette tekstdokument?', 'as': 'আপুনি এই লিখনী দস্তাবেজ চলাব বিচাৰে নে?', 'gd': 'A bheil thu airson an sgrìobhainn teacsa seo a ruith?', 'or': 'ଆପଣ ଏହି ପାଠ୍ଯ ଦଲିଲ ଚଲାଇବାକୁ ଚାହୁଁଛନ୍ତି କି?', 'ja': 'このテキスト文書をプログラムとして実行しますか？', 'nn': 'Vil du køyra dette tekstdokumentet?', 'fr': 'Souhaitez-vous exécuter ce document texte ?', 'pt': 'Deseja executar este documento de texto?', 'gl': 'Quere executar este documento de texto?', 'ar': 'أتريد تشغيل هذا المستند النصّيّ؟', 'en_US': 'Do you want to run this text document?', 'sk': 'Spustiť tento textový dokument?', 'sr': 'Желите ли да извршите наредбе из документа?', 'zh_CN': '是否希望运行该文本文档?', 'eo': 'Ĉu vi volas ruli ĉi tiun dokumenton?', 'ta': 'இந்த உரை ஆவணத்தை இயக்க வேண்டுமா?', 'ca_valencia': 'Voleu executar este document de text?', 'ga': 'An bhfuil fonn ort an cháipéis téacs a chur ar siúl?', 'ca': 'Voleu executar aquest document de text?', 'be': 'Выканаць гэты тэкставы дакумент?', 'ug': 'بۇ تېكىست پۈتۈكنى ئىجرا قىلامسىز؟'},
'MAROON':{'lt': 'kaštoninė', 'sid': 'maarone', 'fi': 'punaruskea', 'ro': 'maroon|maro', 'lv': 'tumšsarkans', 'kn': 'ಕಂದುಗೆಂಪು', 'hsb': 'čerwjenobruny', 'tr': 'bordo', 'es': 'guinda|granate', 'vec': 'granada', 'el': 'καστανέρυθρο|maroon', 'hr': 'kestenjasta', 'cs': 'kaštanová', 'sr_Latn': 'kestenasta', 'he': 'חוםכהה', 'nl': 'kastanjebruin', 'de': 'rotbraun', 'hi': 'मरून', 'ml': 'മറൂണ്\u200d', 'gu': 'મરૂન', 'ko': '적갈색', 'zh_TW': '咖啡|黑褐|紅棕|maroon', 'mr': 'मरून', 'ru': 'бордовый', 'sl': 'kostanjeva', 'bn_IN': 'মেরুন', 'am': 'የሸክላ ቀለም', 'et': 'kastanpruun', 'uk': 'каштановий', 'pt_BR': 'castanho', 'kk': 'қызыл-қоңыр', 'te': 'మెరూన్', 'br': 'gell', 'is': 'ljósbrúnt', 'km': 'ត្នោត\u200bចាស់', 'nb': 'rødbrun|maroon', 'bs': 'kestenjasta', 'eu': 'granatea', 'hu': 'sötétbarna', 'cy': 'marŵn', 'ast': 'marrón', 'gug': 'marrón', 'as': 'কৃষ্ণৰক্তবৰ্ণ', 'gd': 'ciar-dhonn', 'or': 'ଖଇରିଆ', 'ja': 'くり色|マルーン|maroon', 'nn': 'raudbrun|maroon', 'fr': 'marron', 'be': 'бардовы', 'gl': 'granate', 'ar': 'كستنائي', 'en_US': 'maroon', 'sk': 'gaštanová', 'sr': 'кестенаста', 'eo': 'karmezina', 'ta': 'மரூன்', 'ca_valencia': 'granat|grana', 'ca': 'granat|grana', 'zh_CN': '咖啡|黑褐|红棕|栗色|maroon'},
'CHOCOLATE':{'lt': 'šokolado', 'sid': 'chokolete', 'fi': 'suklaa', 'ro': 'chocolate|ciocolatiu', 'lv': 'gaišbrūns', 'kn': 'ಚಾಕೋಲೇಟ್', 'hsb': 'ćmowobruny', 'el': 'σοκολατί|chocolate', 'hr': 'čokoladna', 'cs': 'čokoládová', 'sr_Latn': 'čokolada', 'he': 'שוקולד', 'nl': 'chocolade', 'de': 'dunkelbraun', 'hi': 'चॉकलेट', 'ml': 'ചോക്കോളേറ്റ്', 'gu': 'ચોકલેટ', 'ko': '초콜릿색', 'zh_TW': '巧克力|褐|chocolate', 'mr': 'चॉकोलेट', 'ru': 'шоколадный', 'sl': 'čokoladna', 'bn_IN': 'চকোলেট', 'am': 'ጥቁር ቡናማ', 'et': 'šokolaadipruun|šokolaadikarva', 'uk': 'шоколадний', 'kk': 'шоколад_түсті', 'te': 'చాకోలేట్', 'br': 'chokolad', 'is': 'súkkulaði', 'km': 'សូកូឡា', 'nb': 'sjokoladebrun|chocolate', 'bs': 'čokolada', 'eu': 'txokolatea', 'hu': 'világosbarna', 'cy': 'siocled', 'tr': 'çikolata', 'as': 'চকোলেট', 'gd': 'dath na seòclaid', 'or': 'ଚକୋଲେଟ', 'ja': '薄い茶色|チョコレート|チョコレート色|chocolate', 'nn': 'sjokoladebrun|chocolate', 'fr': 'chocolat', 'be': 'шакаладны', 'ar': 'شوكولاتي', 'en_US': 'chocolate', 'sk': 'čokoládová', 'sr': 'чоколада', 'eo': 'ĉokolada', 'ta': 'சாக்லேட்', 'ca_valencia': 'xocolata|xocolate', 'ca': 'xocolata|xocolate', 'zh_CN': '巧克力|褐色|chocolate'},
'WHITE':{'lt': 'balta', 'sid': 'waajjo', 'fi': 'valkoinen', 'ro': 'white|alb', 'lv': 'balts', 'kn': 'ಬಿಳಿ', 'hsb': 'běły', 'tr': 'beyaz', 'es': 'blanco', 'el': 'λευκό|white', 'hr': 'bijela', 'cs': 'bílá', 'sr_Latn': 'bela', 'he': 'לבן', 'nl': 'wit', 'de': 'weiß', 'hi': 'सफ़ेद', 'ml': 'വെള്ള', 'gu': 'સફેદ', 'ko': '흰색', 'zh_TW': '白|white', 'mr': 'पांढरा', 'ru': 'белый', 'sl': 'bela', 'sa_IN': 'सफ़ीद', 'bn_IN': 'সাদা', 'am': 'ነጭ', 'et': 'valge', 'uk': 'білий', 'pt_BR': 'branco', 'kk': 'ақ', 'te': 'తెలుపు', 'br': 'gwenn', 'is': 'hvítt', 'km': 'ស', 'nb': 'hvit|white', 'bs': 'bijela', 'eu': 'zuria', 'hu': 'fehér', 'cy': 'gwyn', 'pa_IN': 'ਚਿੱਟਾ', 'ast': 'blancu', 'gug': 'morotĩ', 'as': 'বগা', 'gd': 'geal', 'or': 'ଧଳା', 'ja': '白|white', 'nn': 'kvit|white', 'fr': 'blanc', 'be': 'белы', 'gl': 'branco', 'ar': 'أبيض', 'en_US': 'white', 'sk': 'Biela', 'sr': 'бела', 'zh_CN': '白|白色|white', 'eo': 'blanka', 'ta': 'வெள்ளை', 'ca_valencia': 'blanc', 'ne': 'सेतो', 'ca': 'blanc', 'si': 'සුදු', 'oc': 'blanc', 'ka': 'თეთრი'},
}
