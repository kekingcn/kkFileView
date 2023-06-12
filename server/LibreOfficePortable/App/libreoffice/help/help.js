/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

// Pagination and bookmark search
var url = window.location.pathname;
var moduleRegex = new RegExp('text\\/(\\w+)\\/');
var regexArray = moduleRegex.exec(url);
var userModule = currentModule();
var modules = ['CALC', 'WRITER', 'IMPRESS', 'DRAW', 'BASE', 'MATH', 'CHART', 'BASIC', 'SHARED'];
var indexEl = document.getElementsByClassName("index")[0];
var fullLinks = fullLinkify(indexEl, bookmarks, modules, userModule);
var search = document.getElementById('search-bar');
search.addEventListener('keyup', debounce(filter, 100, indexEl));
var flexIndex =  new FlexSearch.Document({ document: {
        // Only the text content gets indexed, the others get stored as-is
        index: [{
            field: 'text',
            tokenize: 'full'
        }],
        store: ['url','app','text']
    }
});
// Populate FlexSearch index
loadSearch();
// Render the unfiltered index list on page load
fillIndex(indexEl, fullLinks, modules);
// Preserve search input value during the session
search.value = sessionStorage.getItem('searchsave');
if (search.value !== undefined) {
    filter(indexEl);
}
window.addEventListener('unload', function(event) {
    sessionStorage.setItem('searchsave', search.value);
});

function getQuery(q) {
   var pattern = new RegExp('[?&]' + q + '=([^&]+)');
   var param = window.location.search.match(pattern);
   if (param) {
       return param[1];
   }
   return null;
}

function currentModule() {
    // We need to know the module that the user is using when they call for help
    let module = getQuery('DbPAR');
    let moduleFromURL = regexArray[1].toUpperCase();
    if (module == null) {
        // first deal with snowflake Base
        if(url.indexOf('/sdatabase/') !== -1) {
            module = 'BASE';
        } else {
            if (null === regexArray || moduleFromURL === 'SHARED') {
                // comes from search or elsewhere, no defined module in URL
                module = 'SHARED'
            } else {
                // drop the 's' from the start
                module = moduleFromURL.substring(1);
            }
        }
    }
    return module;
};
function fullLinkify(indexEl, bookmarks, modules, currentModule) {
    var fullLinkified = '';
    // if user is not on a shared category page, limit the index to the current module + shared
    if(currentModule !== 'SHARED') {
        bookmarks = bookmarks.filter(function(obj) {
            return obj['app'] === currentModule || obj['app'] === 'SHARED';
        });
    }
    bookmarks.forEach(function(obj) {
        fullLinkified += '<a href="' + obj['url'] + '" class="' + obj['app'] + '" dir="auto">' + obj['text'] + '</a>';
    });
    return fullLinkified;
}
function loadSearch() {
    bookmarks.forEach((el, i) => {
        flexIndex.add(i, el);
    });
}
function fillIndex(indexEl, content, modules) {
    indexEl.innerHTML = content;
    var indexKids = indexEl.children;
    for (var i = 0, len = indexKids.length; i < len; i++) {
        indexKids[i].removeAttribute("id");
    }
    modules.forEach(function(module) {
        var moduleHeader = indexEl.getElementsByClassName(module)[0];
        if (typeof moduleHeader !== 'undefined') {
            // let's wrap the header in a span, so the ::before element will not become a link
            moduleHeader.outerHTML = '<span id="' + module + '" class="' + module + '">' + moduleHeader.outerHTML + '</span>';
        }
    });
    Paginator(indexEl);
}
// filter the index list based on search field input
function filter(indexList) {
    let group = [];
    let target = search.value.trim();
    let filtered = '';
    if (target.length < 1) {
        fillIndex(indexEl, fullLinks, modules);
        return;
    }
    // Regex for highlighting the match
    let regex = new RegExp(target.split(/\s+/).filter((i) => i?.length).join("|"), 'gi');
    let results = flexIndex.search(target, { pluck: "text", enrich: true, limit: 1000 });

    // Similarly to fullLinkify(), limit search results to the user's current module + shared
    // unless they're somehow not coming from a module.
    if(userModule !== 'SHARED') {
        resultModules = [userModule, 'SHARED'];
    } else {
        resultModules = modules;
    }

    // tdf#123506 - Group the filtered list into module groups, keeping the ordering
    modules.forEach(function(module) {
        group[module] = '';
    });
    results.forEach(function(result) {
        group[result.doc.app] += '<a href="' + result.doc.url + '" class="' + result.doc.app + '">' + result.doc.text.replace(regex, (match) => `<strong>${match}</strong>`) + '</a>';
    });
    resultModules.forEach(function(module) {
        if (group[module].length > 0) {
            filtered += group[module];
        }
    });

    fillIndex(indexList, filtered, modules);
};
// delay the rendering of the filtered results while user is typing
function debounce(fn, wait, indexList) {
    var timeout;
    return function() {
        clearTimeout(timeout);
        timeout = setTimeout(function() {
            fn.call(this, indexList);
        }, (wait || 150));
    };
}

// copy pycode, sqlcode and bascode to clipboard on mouse click
// Show border when copy is done
divcopyable(document.getElementsByClassName("bascode"));
divcopyable(document.getElementsByClassName("pycode"));
divcopyable(document.getElementsByClassName("sqlcode"));

function divcopyable(itemcopyable){
for (var i = 0, len = itemcopyable.length; i < len; i++) {
    (function() {
        var item = itemcopyable[i];

        function changeBorder(item, color) {
            var saveBorder  = item.style.border;
            item.style.borderColor = color;

            setTimeout(function() {
                item.style.border = saveBorder;
            }, 150);
        }
        item.onclick = function() {
            document.execCommand("copy");
            changeBorder(item, "#18A303");
        };
        item.addEventListener("copy", function(event) {
            event.preventDefault();
            if (event.clipboardData) {
                event.clipboardData.setData("text/plain", item.textContent);
            }
        });
    }());
}
}

// copy useful content to clipboard on mouse click
var copyable = document.getElementsByClassName("input");
for (var i = 0, len = copyable.length; i < len; i++) {
    (function() {
        var item = copyable[i];

        function changeColor(item, color, colorToChangeBackTo) {
            item.style.backgroundColor = color;
            setTimeout(function() {
                item.style.backgroundColor = colorToChangeBackTo;
            }, 150);
        }
        item.onclick = function() {
            document.execCommand("copy");
            changeColor(item, "#18A303", "transparent");
        };
        item.addEventListener("copy", function(event) {
            event.preventDefault();
            if (event.clipboardData) {
                event.clipboardData.setData("text/plain", item.textContent);
            }
        });
    }());
}
// auto-expand contents per subitem
var pathname = window.location.pathname;
var pathRegex = /text\/.*\.html$/;
var linkIndex = 0;
var contentMatch = pathname.match(pathRegex);
function linksMatch(content) {
    var linkMatch = new RegExp(content);
    var links = document.getElementById("Contents").getElementsByTagName("a");
    for (var i = 0, len = links.length; i < len; i++) {
        if (links[i].href.match(linkMatch)) {
            return i;
        }
    }
}
linkIndex = linksMatch(contentMatch);
if (typeof linkIndex !== "undefined") {
    var current = document.getElementById("Contents").getElementsByTagName("a")[linkIndex];
    var cItem = current.parentElement;
    var parents = [];
    while (cItem.parentElement && !cItem.parentElement.matches("#Contents") && parents.indexOf(cItem.parentElement) == -1) {
        parents.push(cItem = cItem.parentElement);
    }
    var liParents = [].filter.call(parents, function(item) {
        return item.matches("li");
    });
    for (var i = 0, len = liParents.length; i < len; i++) {
        var input = liParents[i].querySelectorAll(':scope > input');
        document.getElementById(input[0].id).checked = true;
    }
    current.classList.add('contents-current');
}
// close navigation menus when clicking anywhere on the page
// (ignoring menu button clicks and mobile browsing)
document.addEventListener('click', function(event) {
    let a11yButton = event.target.getAttribute("data-a11y-toggle");
    let vw = Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0);
    if (!a11yButton && vw >= 960) {
        document.querySelectorAll("[data-a11y-toggle] + nav").forEach((el) => {
            el.setAttribute("aria-hidden", true);
        });
    }
});
// YouTube consent click. This only works for a single video.
let youtubePlaceholder = document.querySelector(".youtube_placeholder");
if (youtubePlaceholder) {
    youtubePlaceholder.prepend(...document.querySelectorAll(".youtube_consent"));
}
function youtubeLoader(ytId, width, height) {
    let iframeMarkup = `<iframe width="${width}" height="${height}" src="https://www.youtube-nocookie.com/embed/${ytId}?version=3" allowfullscreen="true" frameborder="0"></iframe>`;
    let placeholder = document.getElementById(ytId);
    placeholder.innerHTML = iframeMarkup;
    placeholder.removeAttribute("style");
}
/* vim:set shiftwidth=4 softtabstop=4 expandtab cinoptions=b1,g0,N-s cinkeys+=0=break: */
