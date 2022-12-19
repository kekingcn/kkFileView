hyph_en_GB.dic - British English hyphenation patterns for OpenOffice.org

version 2011-10-07

- remove unnecessary parts for Hyphen 2.8.2

version 2010-03-16

Changes

- forbid hyphenation at 1-character distances from dashes (eg. ad=d-on)
  and at the dashes (fix for OpenOffice.org 3.2)
- UTF-8 encoding and corrected hyphenation for words with Unicode f ligatures
  (conversion scripts: see Hyphen 2.6)

version 2009-01-23

Changes

- add missing \hyphenation list (how-ever, through-out etc.)
- set correct LEFTHYPHENMIN = 2, RIGHTHYPHENMIN = 3
- handle apostrophes (forbid *can='t, *abaser='s, *o'c=lock etc.)
- set COMPOUNDLEFTHYPHENMIN, COMPOUNDRIGHTHYPHENMIN values

License

BSD-style. Unlimited copying, redistribution and modification of this file
is permitted with this copyright and license information.

British English hyphenation patterns, based on "ukhyphen.tex" Version 1.0a
Created by Dominik Wujastyk and Graham Toal using Frank Liang's PATGEN 1.0,
source: http://ctan.org

See original ukhyphen.tex license in this file, too.

Conversion and modifications by László Németh (nemeth at OOo).

Conversion:

./substrings.pl hyph_en_GB.dic.source /tmp/hyph_en_GB.dic.patterns >/dev/null
cat hyph_en_GB.dic.header /tmp/hyph_en_GB.dic.patterns >hyph_en_GB.dic

hyph_en_GB.dic.header:

ISO8859-1
LEFTHYPHENMIN 2
RIGHTHYPHENMIN 3
COMPOUNDLEFTHYPHENMIN 2
COMPOUNDRIGHTHYPHENMIN 3
1'.
1's.
1't.
NEXTLEVEL

OpenOffice.org ukhyphen patch (hyph_en_GB.dic.source):

--- ukhyphen.tex	2008-12-17 15:37:04.000000000 +0100
+++ hyph_en_GB.dic.source	2008-12-18 10:07:02.000000000 +0100
@@ -52,7 +52,6 @@
 %
 % These patterns require a value of about 14000 for TeX's pattern memory size.
 %
-\patterns{ % just type <return> if you're not using INITEX
 .ab4i
 .ab3ol
 .ace4
@@ -8580,13 +8579,64 @@
 z3zie
 zzo3
 z5zot
-}
-\hyphenation{ % Do NOT make any alterations to this list! --- DW
-uni-ver-sity
-uni-ver-sit-ies
-how-ever
-ma-nu-script
-ma-nu-scripts
-re-ci-pro-city
-through-out
-some-thing}
+.uni5ver5sity.
+.uni5ver5sit5ies.
+.how5ever.
+.ma5nu5script.
+.ma5nu5scripts.
+.re5ci5pro5city.
+.through5out.
+.some5thing.
+4'4
+4a'
+4b'
+4c'
+4d'
+4e'
+4f'
+4g'
+4h'
+4i'
+4j'
+4k'
+4l'
+4m'
+4n'
+4o'
+4p'
+4q'
+4r'
+4s'
+4t'
+4u'
+4v'
+4w'
+4x'
+4y'
+4z'
+'a4
+'b4
+'c4
+'d4
+'e4
+'f4
+'g4
+'h4
+'i4
+'j4
+'k4
+'l4
+'m4
+'n4
+'o4
+'p4
+'q4
+'r4
+'s4
+'t4
+'u4
+'v4
+'w4
+'x4
+'y4
+'z4

Original License

% File: ukhyphen.tex
% TeX hyphenation patterns for UK English

% Unlimited copying and redistribution of this file
% is permitted so long as the file is not modified
% in any way.
%
% Modifications may be made for private purposes (though
% this is discouraged, as it could result in documents
% hyphenating differently on different systems) but if
% such modifications are re-distributed, the modified
% file must not be capable of being confused with the
% original.  In particular, this means
%
%(a) the filename (the portion before the extension, if any)
%    must not match any of :
%
%        UKHYPH                  UK-HYPH
%        UKHYPHEN                UK-HYPHEN
%        UKHYPHENS               UK-HYPHENS
%        UKHYPHENATION           UK-HYPHENATION
%        UKHYPHENISATION         UK-HYPHENISATION
%        UKHYPHENIZATION         UK-HYPHENIZATION
%
%   regardless of case, and
%
%(b) the file must contain conditions identical to these,
% except that the modifier/distributor may, if he or she
% wishes, augment the list of proscribed filenames.

%       $Log: ukhyph.tex $
%       Revision 2.0  1996/09/10 15:04:04  ucgadkw
%       o  added list of hyphenation exceptions at the end of this file.
%
%
% Version 1.0a.  Released 18th October 2005/PT.
%
% Created by Dominik Wujastyk and Graham Toal using Frank Liang's PATGEN 1.0.
% Like the US patterns, these UK patterns correctly hyphenate about 90% of
% the words in the input list, and produce no hyphens not in the list
% (see TeXbook pp. 451--2).
%
% These patterns are based on a file of 114925 British-hyphenated words
% generously made available to Dominik Wujastyk by Oxford University Press.
% This list of words is copyright to the OUP and may not be redistributed.
% The hyphenation break points in the words in the abovementioned file is
% also copyright to the OUP.
%
% We are very grateful to Oxford University Press for allowing us to use
% their list of hyphenated words to produce the following TeX hyphenation
% patterns.  This file of hyphenation patterns may be freely distributed.
%
% These patterns require a value of about 14000 for TeX's pattern memory size.
%
