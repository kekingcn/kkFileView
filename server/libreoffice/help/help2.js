/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
// Used to set Application in caseinline=APP
function setApplSpan(spanZ) {
    var module = getParameterByName("DbPAR");
    if (module === null) {
        module = "WRITER";
    }
    var y = spanZ.getElementsByTagName("SPAN");
    var n = y.length;
    var foundAppl = false;
    for (i = 0; i < n; i++) {
        if (y[i].getAttribute("id") === null){
            continue;
        }
        else if( y[i].getAttribute("id").startsWith(module)){
            y[i].removeAttribute("hidden");
            foundAppl=true;
        }
    }
    for (i = 0; i < n; i++) {
        if (y[i].getAttribute("id") === null){
            continue;
        }
        else if( y[i].getAttribute("id").startsWith("default")){
            if(!foundAppl){
                y[i].removeAttribute("hidden");
            }
        }
    }
}
// Used to set system in case, caseinline=SYSTEM
function setSystemSpan(spanZ) {
    // if no System in URL, get browser system
    var system = getParameterByName("System");
    if (system === null) {
        system = getSystem();
    }
    var y = spanZ.getElementsByTagName("SPAN");
    var n = y.length;
    var foundSystem = false;
    for (i = 0; i < n; i++) {
        if (y[i].getAttribute("id") === null){
            continue;
        }
        else if( y[i].getAttribute("id").startsWith(system)){
            y[i].removeAttribute("hidden");
            foundSystem=true;
        }
    }
    for (i = 0; i < n; i++) {
        if (y[i].getAttribute("id") === null){
            continue;
        }
        else if( y[i].getAttribute("id").startsWith("default")){
            if(!foundSystem){
                y[i].removeAttribute("hidden");
            }
        }
    }
}

// paint headers and headings with appl color

function moduleColor (module) {
    switch (module){
        case "WRITER" : {color="#0369A3"; break;}
        case "CALC"   : {color="#43C330"; break;}
        case "CHART"  : {color="darkcyan"; break;}
        case "IMPRESS": {color="#A33E03"; break;}
        case "DRAW"   : {color="#C99C00"; break;}
        case "BASE"   : {color="#8E03A3"; break;}
        case "BASIC"  : {color="black"; break;}
        case "MATH"   : {color="darkslategray"; break;}
        case "SHARED" : {color="gray"; break;}
        default : {color="#18A303"; break;}
    }
    document.getElementById("TopLeftHeader").style.background = color;
    document.getElementById("SearchFrame").style.background = color;
    document.getElementById("DonationFrame").style.background = color;
    var cols = document.getElementsByClassName('tableheadcell');
    for(i = 0; i < cols.length; i++) {cols[i].style.backgroundColor = color;};
    for (j of [1,2,3,4,5,6]) {
        var hh = document.getElementsByTagName("H" + j);
        for(i = 0; i < hh.length; i++) {
            hh[i].style.color = color;
            hh[i].style.borderBottomColor = color;
        }
    }
}

// Find spans that need the switch treatment and give it to them
var spans = document.querySelectorAll("[class^=switch]");
var n = spans.length;
for (z = 0; z < n; z++) {
    var id = spans[z].getAttribute("id");
    if (id === null) {
        continue;
    }
    else if (id.startsWith("swlnsys")) {
        setSystemSpan(spans[z]);
    } else {
        setApplSpan(spans[z]);
    }
}
/* add &DbPAR= and &System= to the links in DisplayArea div */
/* skip for object files */
function fixURL(module, system) {
    if ((DisplayArea = document.getElementById("DisplayArea")) === null) return;
    var itemlink = DisplayArea.getElementsByTagName("a");
    var pSystem = (system === null) ? getSystem() : system;
    var pAppl = (module === null) ? "WRITER" : module;
    var n = itemlink.length;
    for (var i = 0; i < n; i++) {
        if (itemlink[i].getAttribute("class") != "objectfiles") {
            setURLParam(itemlink[i], pSystem, pAppl);
        }
    }
}
//Set the params inside URL
function setURLParam(itemlink, pSystem, pAppl) {
    var href = itemlink.getAttribute("href");
    if (href !== null) {
        // skip external links
        if (!href.startsWith("http")) {
            // handle bookmark.
            if (href.lastIndexOf('#') != -1) {
                var postf = href.substring(href.lastIndexOf('#'), href.length);
                var pref = href.substring(0, href.lastIndexOf('#'));
                itemlink.setAttribute("href", pref + "?" + '&DbPAR=' + pAppl + '&System=' + pSystem + postf);
            } else {
                itemlink.setAttribute("href", href + "?" + '&DbPAR=' + pAppl + '&System=' + pSystem);
            }
        }
    }
}

function getSystem() {
    var system = "Unknown OS";
    if (navigator.appVersion.indexOf("Win") != -1) system = "WIN";
    if (navigator.appVersion.indexOf("Mac") != -1) system = "MAC";
    if (navigator.appVersion.indexOf("X11") != -1) system = "UNIX";
    if (navigator.appVersion.indexOf("Linux") != -1) system = "UNIX";
    return system;
}

function getParameterByName(name, url) {
    if (!url) {
        url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");
    var results = regex.exec(url);
    if (!results) {
        return null;
    }
    if (!results[2]) {
        return '';
    }
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function existingLang(lang) {
    if (lang === undefined) {
        return 'en-US';
    }

    if (languagesSet.has(lang)) {
        return lang;
    }

    lang = lang.replace(/[-_].*/, '');
    if (languagesSet.has(lang)) {
        return lang;
    }

    return 'en-US';
}

function setupModules(lang) {
    var modulesNav = document.getElementById('modules-nav');
    if (!modulesNav.classList.contains('loaded')) {
        var html =
            '<a href="' + lang + '/text/swriter/main0000.html?DbPAR=WRITER"><div class="writer-icon"></div>Writer</a>' +
            '<a href="' + lang + '/text/scalc/main0000.html?DbPAR=CALC"><div class="calc-icon"></div>Calc</a>' +
            '<a href="' + lang + '/text/simpress/main0000.html?DbPAR=IMPRESS"><div class="impress-icon"></div>Impress</a>' +
            '<a href="' + lang + '/text/sdraw/main0000.html?DbPAR=DRAW"><div class="draw-icon"></div>Draw</a>' +
            '<a href="' + lang + '/text/sdatabase/main.html?DbPAR=BASE"><div class="base-icon"></div>Base</a>' +
            '<a href="' + lang + '/text/smath/main0000.html?DbPAR=MATH"><div class="math-icon"></div>Math</a>' +
            '<a href="' + lang + '/text/schart/main0000.html?DbPAR=CHART"><div class="chart-icon"></div>Chart</a>' +
            '<a href="' + lang + '/text/sbasic/shared/main0601.html?DbPAR=BASIC"><div class="basic-icon"></div>Basic</a>';
        modulesNav.innerHTML = html;
        modulesNav.classList.add('loaded');
    }
}

function setupLanguages(page) {
    var langNav = document.getElementById('langs-nav');
    if (!langNav.classList.contains('loaded')) {
        var html = '';
        languagesSet.forEach(function(lang) {
            html += '<a href="' + lang + page + '">' + ((lang in languageNames)? languageNames[lang]: lang) + '</a>';
        });
        langNav.innerHTML = html;
        langNav.classList.add('loaded');
    }
}

// Test, if we are online
if (document.body.getElementsByTagName('meta')) {
    var _paq = _paq || [];
    /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
    _paq.push(['disableCookies']);
    _paq.push(['trackPageView']);
    _paq.push(['enableLinkTracking']);
    (function() {
    var u="//piwik.documentfoundation.org/";
    _paq.push(['setTrackerUrl', u+'piwik.php']);
    _paq.push(['setSiteId', '68']);
    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
    g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
    })();
    var system = getParameterByName("System");
} else {
    var system = getSystem();
}

var module = getParameterByName("DbPAR");
fixURL(module,system);
moduleColor(module);
var helpID = getParameterByName("HID");
// only used in xhp pages with <help-id-missing/> tags
var missingElement = document.getElementById("bm_HID2");
if(missingElement != null){missingElement.innerHTML = helpID;}

function debugInfo(dbg) {
    if (dbg == null) return;
    document.getElementById("DEBUG").style.display = "block";
    document.getElementById("bm_module").innerHTML = "Module is: "+module;
    document.getElementById("bm_system").innerHTML = "System is: "+system;
    document.getElementById("bm_HID").innerHTML = "HID is: "+helpID;
}

debugInfo(getParameterByName("Debug"));

// Mobile devices need the modules and langs on page load
if (Math.max(document.documentElement.clientWidth, window.innerWidth || 0) < 960) {
    var e = new Event('click');
    var modulesBtn = document.getElementById('modules');
    var langsBtn = document.getElementById('langs');
    var modules = document.getElementById('modules-nav');
    var langs = document.getElementById('langs-nav');
    modules.setAttribute('data-a11y-toggle-open', '');
    modulesBtn.dispatchEvent(e);
    if (langs) {
        langs.setAttribute('data-a11y-toggle-open', '');
        langsBtn.dispatchEvent(e);
    }
}
/* vim:set shiftwidth=4 softtabstop=4 expandtab cinoptions=b1,g0,N-s cinkeys+=0=break: */
