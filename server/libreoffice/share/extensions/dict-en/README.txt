OpenOffice.org Hunspell en_US dictionary
2010-03-09 release

--
This dictionary is based on a subset of the original
English wordlist created by Kevin Atkinson for Pspell 
and  Aspell and thus is covered by his original 
LGPL license.  The affix file is a heavily modified
version of the original english.aff file which was
released as part of Geoff Kuenning's Ispell and as 
such is covered by his BSD license.

Thanks to both authors for there wonderful work.

ChangeLog

2010-03-09 (nemeth AT OOo)
  - UTF-8 encoded dictionary:
       - fix em-dash problem of OOo 3.2 by BREAK
       - suggesting words with typographical apostrophes
       - recognizing words with Unicode f ligatures
  - add phonetic suggestion (Copyright (C) 2000 BjÃ¶rn Jacke, see the end of the file)

2007-08-29 nemeth AT OOo

Mozilla 376296 - add "axe" (variant of ax)
Mozilla 386259 - add "JavaScript"
Mozilla 383694 - add "foci" and "octopi" (plurals of focus and octopus)
Issue 73024 - add "gauge"
Issue 75710 - add "foldable"
Issue 75772 - add "GHz"
Mozilla 379527 and Issue 62294 - add "dialogue"
Issue 64246 - add "acknowledgement" as a variant of "acknowledgment"

- TRY extended with apostrophe and dash for
 dont -> don't
 alltime -> all-time suggestions
- new REP suggestions:
- REP alot a_lot (alot ->  a lot)
for suggestion)
- REP nt n't (dont -> don't)
- REP avengence -> a_vengeance (avengence -> a vengeance)
- REP ninties 1990s
- REP tion ssion: readmition -> readmission

- add Mozilla words (blog, cafe, inline, online, eBay, PayPal, etc.)
- add cybercafé
- alias compression (saving 15 kB disk space + 0.8 MB memory)

Mozilla 355178 - add scot-free
Mozilla 374411 - add Scotty
Mozilla 359305 - add archaeology, archeological, archeologist
Mozilla 358754 - add doughnut
Mozilla 254814 - add gauging, canoeing, *canoing, proactively
Issue 71718 - remove *opthalmic, *opthalmology; *opthalmologic -> ophthalmologic
Issue 68550 - *estoppal -> estoppel
Issue 69345 - add tapenade
Issue 67975 - add assistive
Issue 63541 - remove *dessicate
Issue 62599 - add toolbar

2006-02-07 nemeth AT OOo

Issue 48060 - add ordinal numbers with COMPOUNDRULE (1st, 11th, 101st etc.)
Issue 29112, 55498 - add NOSUGGEST flags to taboo words
Issue 56755 - add sequitor (non sequitor)
Issue 50616 - add open source words (GNOME, KDE, OOo, OpenOffice.org)
Issue 56389 - add Mozilla words (Mozilla, Firefox, Thunderbird)
Issue 29110 - add okay
Issue 58468 - add advisors
Issue 58708 - add hiragana & katakana
Issue 60240 - add arginine, histidine, monovalent, polymorphism, pyroelectric, pyroelectricity

2005-11-01 dnaber AT OOo

Issue 25797 - add proven, advisor, etc.
