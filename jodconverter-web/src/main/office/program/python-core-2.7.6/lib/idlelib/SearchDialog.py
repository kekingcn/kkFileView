from Tkinter import *

from idlelib import SearchEngine
from idlelib.SearchDialogBase import SearchDialogBase

def _setup(text):
    root = text._root()
    engine = SearchEngine.get(root)
    if not hasattr(engine, "_searchdialog"):
        engine._searchdialog = SearchDialog(root, engine)
    return engine._searchdialog

def find(text):
    pat = text.get("sel.first", "sel.last")
    return _setup(text).open(text,pat)

def find_again(text):
    return _setup(text).find_again(text)

def find_selection(text):
    return _setup(text).find_selection(text)

class SearchDialog(SearchDialogBase):

    def create_widgets(self):
        f = SearchDialogBase.create_widgets(self)
        self.make_button("Find Next", self.default_command, 1)

    def default_command(self, event=None):
        if not self.engine.getprog():
            return
        self.find_again(self.text)

    def find_again(self, text):
        if not self.engine.getpat():
            self.open(text)
            return False
        if not self.engine.getprog():
            return False
        res = self.engine.search_text(text)
        if res:
            line, m = res
            i, j = m.span()
            first = "%d.%d" % (line, i)
            last = "%d.%d" % (line, j)
            try:
                selfirst = text.index("sel.first")
                sellast = text.index("sel.last")
                if selfirst == first and sellast == last:
                    text.bell()
                    return False
            except TclError:
                pass
            text.tag_remove("sel", "1.0", "end")
            text.tag_add("sel", first, last)
            text.mark_set("insert", self.engine.isback() and first or last)
            text.see("insert")
            return True
        else:
            text.bell()
            return False

    def find_selection(self, text):
        pat = text.get("sel.first", "sel.last")
        if pat:
            self.engine.setcookedpat(pat)
        return self.find_again(text)
