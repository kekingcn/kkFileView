/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
// This file can be removed, when we stop supporting IE11.
// Polyfill for .before()
// from: https://github.com/jserz/js_piece/blob/master/DOM/ChildNode/before()/before().md
// Copyright (c) 2016-present, jszhou
// MIT License
(function (arr) {
  arr.forEach(function (item) {
    if (item.hasOwnProperty('before')) {
      return;
    }
    Object.defineProperty(item, 'before', {
      configurable: true,
      enumerable: true,
      writable: true,
      value: function before() {
        var argArr = Array.prototype.slice.call(arguments),
          docFrag = document.createDocumentFragment();

        argArr.forEach(function (argItem) {
          var isNode = argItem instanceof Node;
          docFrag.appendChild(isNode ? argItem : document.createTextNode(String(argItem)));
        });

        this.parentNode.insertBefore(docFrag, this);
      }
    });
  });
})([Element.prototype, CharacterData.prototype, DocumentType.prototype]);
// Polyfill for .startsWith()
// from: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/startsWith#Polyfill
if (!String.prototype.startsWith) {
    Object.defineProperty(String.prototype, 'startsWith', {
        value: function(search, pos) {
            pos = !pos || pos < 0 ? 0 : +pos;
            return this.substring(pos, pos + search.length) === search;
        }
    });
}
// Polyfill for .matches()
// from: https://developer.mozilla.org/en-US/docs/Web/API/Element/matches#Polyfill
if (!Element.prototype.matches) {
  Element.prototype.matches = Element.prototype.msMatchesSelector ||
                              Element.prototype.webkitMatchesSelector;
}
// Polyfill for iterable Set (IE11)
// from: https://stackoverflow.com/a/45686452/3057764
if (new Set([0]).size === 0) {
    //constructor doesn't take an iterable as an argument - thanks IE
    const BuiltinSet = Set;
    Set = function Set(iterable) {
        const set = new BuiltinSet();
        if (iterable) {
            iterable.forEach(set.add, set);
        }
        return set;
    };
    Set.prototype = BuiltinSet.prototype;
    Set.prototype.constructor = Set;
}
// Polyfill for using :scope in querySelector/querySelectorAll
// from: https://github.com/lazd/scopedQuerySelectorShim
// Copyright (C) 2015 Larry Davis
// This software may be modified and distributed under the terms of the BSD license.
(function() {
    if (!HTMLElement.prototype.querySelectorAll) {
        throw new Error("rootedQuerySelectorAll: This polyfill can only be used with browsers that support querySelectorAll");
    }
    // A temporary element to query against for elements not currently in the DOM
    // We'll also use this element to test for :scope support
    var container = document.createElement("div");
    // Check if the browser supports :scope
    try {
        // Browser supports :scope, do nothing
        container.querySelectorAll(":scope *");
    } catch (e) {
        // Match usage of scope
        var scopeRE = /^\s*:scope/gi;
        // Overrides
        function overrideNodeMethod(prototype, methodName) {
            // Store the old method for use later
            var oldMethod = prototype[methodName];
            // Override the method
            prototype[methodName] = function(query) {
                var nodeList, gaveId = false, gaveContainer = false;
                if (query.match(scopeRE)) {
                    // Remove :scope
                    query = query.replace(scopeRE, "");
                    if (!this.parentNode) {
                        // Add to temporary container
                        container.appendChild(this);
                        gaveContainer = true;
                    }
                    parentNode = this.parentNode;
                    if (!this.id) {
                        // Give temporary ID
                        this.id = "rootedQuerySelector_id_" + new Date().getTime();
                        gaveId = true;
                    }
                    // Find elements against parent node
                    nodeList = oldMethod.call(parentNode, "#" + this.id + " " + query);
                    // Reset the ID
                    if (gaveId) {
                        this.id = "";
                    }
                    // Remove from temporary container
                    if (gaveContainer) {
                        container.removeChild(this);
                    }
                    return nodeList;
                } else {
                    // No immediate child selector used
                    return oldMethod.call(this, query);
                }
            };
        }
        // Browser doesn't support :scope, add polyfill
        overrideNodeMethod(HTMLElement.prototype, "querySelector");
        overrideNodeMethod(HTMLElement.prototype, "querySelectorAll");
    }
})();
/* vim:set shiftwidth=4 softtabstop=4 expandtab cinoptions=b1,g0,N-s cinkeys+=0=break: */
