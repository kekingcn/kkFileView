# -*- encoding: UTF-8 -*-
import uno, re, sys, os, traceback
from com.sun.star.text.TextMarkupType import PROOFREADING
from com.sun.star.beans import PropertyValue

pkg = "ru_RU"
lang = "ru_RU"
locales = {'ru-RU': ['ru', 'RU', '']}
version = "0.3.4"
author = "Yakov Reztsov <yr at myooo dot ru>"
name = "Lightproof grammar checker (Russian)"

import lightproof_handler_ru_RU

# loaded rules (check for Update mechanism of the editor)
try:
    langrule
except NameError:
    langrule = {}

# ignored rules
ignore = {}

# cache for morphogical analyses
analyses = {}
stems = {}
suggestions = {}

# assign Calc functions
calcfunc = None

# check settings
def option(lang, opt):
    return lightproof_handler_ru_RU.get_option(lang.Language + "_" + lang.Country, opt)

# filtering affix fields (ds, is, ts etc.)
def onlymorph(st):
    if st != None:
        st = re.sub(r"^.*(st:|po:)", r"\\1", st) # keep last word part
        st = re.sub(r"\\b(?=[dit][sp]:)","@", st) # and its affixes
        st = re.sub(r"(?<!@)\\b\w\w:\w+","", st).replace('@','').strip()
    return st

# if the pattern matches all analyses of the input word, 
# return the last matched substring
def _morph(rLoc, word, pattern, all, onlyaffix):
    global analyses
    if not word:
        return None
    if word not in analyses:
        x = spellchecker.spell(u"<?xml?><query type='analyze'><word>" + word + "</word></query>", rLoc, ())
        if not x:
            return None
        t = x.getAlternatives()
        if not t:
            if not analyses: # fix synchronization problem (missing alternatives with unloaded dictionary)
                return None
            t = [""]
        analyses[word] = t[0].split("</a>")[:-1]
    a = analyses[word]
    result = None
    p = re.compile(pattern)
    for i in a:
        if onlyaffix:
            i = onlymorph(i)
        result = p.search(i)
        if result:
            result = result.group(0)
            if not all:
                return result
        elif all:
            return None
    return result

def morph(rLoc, word, pattern, all=True):
    return _morph(rLoc, word, pattern, all, False)

def affix(rLoc, word, pattern, all=True):
    return _morph(rLoc, word, pattern, all, True)

def spell(rLoc, word):
    if not word:
        return None
    return spellchecker.isValid(word, rLoc, ())

# get the tuple of the stem of the word or an empty array
def stem(rLoc, word):
    global stems
    if not word:
        return []
    if not word in stems:
        x = spellchecker.spell(u"<?xml?><query type='stem'><word>" + word + "</word></query>", rLoc, ())
        if not x:
            return []
        t = x.getAlternatives()
        if not t:
            t = []
        stems[word] = list(t)
    return stems[word]

# get the tuple of the morphological generation of a word or an empty array
def generate(rLoc, word, example):
    if not word:
        return []
    x = spellchecker.spell(u"<?xml?><query type='generate'><word>" + word + "</word><word>" + example + "</word></query>", rLoc, ())
    if not x:
        return []
    t = x.getAlternatives()
    if not t:
        t = []
    return list(t)

# get suggestions
def suggest(rLoc, word):
    global suggestions
    if not word:
        return word
    if word not in suggestions:
        x = spellchecker.spell("_" + word, rLoc, ())
        if not x:
            return word
        t = x.getAlternatives()
        suggestions[word] = "|".join(t)
    return suggestions[word]

# get the nth word of the input string or None
def word(s, n):
    a = re.match("(?u)( [-.\\w%%]+){" + str(n-1) + "}( [-.\\w%%]+)", s)
    if not a:
        return ''
    return a.group(2)[1:]

# get the (-)nth word of the input string or None
def wordmin(s, n):
    a = re.search("(?u)([-.\\w%%]+ )([-.\\w%%]+ ){" + str(n-1) + "}$", s)
    if not a:
        return ''
    return a.group(1)[:-1]

def calc(funcname, par):
    global calcfunc
    global SMGR
    if calcfunc == None:
        calcfunc = SMGR.createInstance( "com.sun.star.sheet.FunctionAccess")
        if calcfunc == None:
                return None
    return calcfunc.callFunction(funcname, par)

def proofread( nDocId, TEXT, LOCALE, nStartOfSentencePos, nSuggestedSentenceEndPos, rProperties ):
    global ignore
    aErrs = []
    s = TEXT[nStartOfSentencePos:nSuggestedSentenceEndPos]
    for i in get_rule(LOCALE).dic:
        # 0: regex,  1: replacement,  2: message,  3: condition,  4: ngroup,  (5: oldline),  6: case sensitive ?
        if i[0] and not str(i[0]) in ignore:
            for m in i[0].finditer(s):
                try:
                    if not i[3] or eval(i[3]):
                        aErr = uno.createUnoStruct( "com.sun.star.linguistic2.SingleProofreadingError" )
                        aErr.nErrorStart        = nStartOfSentencePos + m.start(i[4]) # nStartOfSentencePos
                        aErr.nErrorLength       = m.end(i[4]) - m.start(i[4])
                        aErr.nErrorType         = PROOFREADING
                        aErr.aRuleIdentifier    = str(i[0])
                        iscap = (i[-1] and m.group(i[4])[0:1].isupper())
                        if i[1][0:1] == "=":
                            aErr.aSuggestions = tuple(cap(eval(i[1][1:]).replace('|', "\n").split("\n"), iscap, LOCALE))
                        elif i[1] == "_":
                            aErr.aSuggestions = ()
                        else:
                            aErr.aSuggestions = tuple(cap(m.expand(i[1]).replace('|', "\n").split("\n"), iscap, LOCALE))
                        comment = i[2]
                        if comment[0:1] == "=":
                            comment = eval(comment[1:])
                        else:
                            comment = m.expand(comment)
                        aErr.aShortComment      = comment.replace('|', '\n').replace('\\n', '\n').split("\n")[0].strip()
                        aErr.aFullComment       = comment.replace('|', '\n').replace('\\n', '\n').split("\n")[-1].strip()
                        if "://" in aErr.aFullComment:
                            p = PropertyValue()
                            p.Name = "FullCommentURL"
                            p.Value = aErr.aFullComment
                            aErr.aFullComment = aErr.aShortComment
                            aErr.aProperties        = (p,)
                        else:
                            aErr.aProperties        = ()
                        aErrs = aErrs + [aErr]
                except Exception as e:
                    if len(i) == 7:
                        raise Exception(str(e), i[5])
                    raise

    return tuple(aErrs)

def cap(a, iscap, rLoc):
    if iscap:
        for i in range(0, len(a)):
            if a[i][0:1] == "i":
                if rLoc.Language == "tr" or rLoc.Language == "az":
                    a[i] = u"\u0130" + a[i][1:]
                elif a[i][1:2] == "j" and rLoc.Language == "nl":
                    a[i] = "IJ" + a[i][2:]
                else:
                    a[i] = "I" + a[i][1:]
            else:
                a[i] = a[i].capitalize()
    return a

def compile_rules(dic):
    # compile regular expressions
    for i in dic:
        try:
            if re.compile("[(][?]iu[)]").match(i[0]):
                i += [True]
                i[0] = re.sub("[(][?]iu[)]", "(?u)", i[0])
            else:
                i += [False]
            i[0] = re.compile(i[0])
        except:
            if 'PYUNO_LOGLEVEL' in os.environ:
                print("Lightproof: bad regular expression: " + str(traceback.format_exc()))
            i[0] = None

def get_rule(loc):
    try:
        return langrule[pkg]
    except:
        langrule[pkg] = __import__("lightproof_" + pkg)
        compile_rules(langrule[pkg].dic)
    return langrule[pkg]

def get_path():
    return os.path.join(os.path.dirname(sys.modules[__name__].__file__), __name__ + ".py")

# [code]


