/**
 * Paginathing
 * Paginate Everything
 *
 * Original author Alfred Crosby <https://github.com/alfredcrosby>
 * Inspired from http://esimakin.github.io/twbs-pagination/
 * Modified to pure JavaScript and specialised to LibreOffice Help by
 * Ilmari Lauhakangas
 *
 * MIT License (Expat)
 *
 * Copyright (c) 2018 Alfred Crosby
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

var options = {
    perPage: 20,
    limitPagination: 6,
    prevNext: true,
    firstLast: true,
    prevText: '←',
    nextText: '→',
    firstText: '⇤',
    lastText: '⇥',
    containerClass: 'pagination-container',
    ulClass: 'pagination',
    liClass: 'page',
    activeClass: 'active',
    disabledClass: 'disabled'
};

var Paginator = function(element) {
    var el = element;
    var startPage = 1;
    var currentPage = 1;
    var pageDivision = 0;
    var totalItems = el.children.length;
    var limitPagination = options.limitPagination;
    pageDivision = Math.ceil(totalItems / options.perPage);
    // let's not display pagination leading nowhere
    function pagLimit() {
        if (options.limitPagination >= pageDivision) {
            limitPagination = pageDivision;
        } else {
            limitPagination = options.limitPagination;
        }
        return limitPagination;
    }
    var totalPages = Math.max(pageDivision, pagLimit());
    var existingContainer = document.getElementsByClassName('pagination-container')[0];
    if (existingContainer) {
        parent = existingContainer.parentNode;
        parent.removeChild(existingContainer);
    }
    var container = document.createElement('nav');
    container.setAttribute('class', options.containerClass);
    var ul = document.createElement('ul');
    ul.setAttribute('class', options.ulClass);

    function paginationFunc(type, page) {
        var li = document.createElement('li');
        var a = document.createElement('a');
        a.setAttribute('href', '#');
        var cssClass = type === 'number' ? options.liClass : type;
        var text = document.createTextNode(type === 'number' ? page : paginationText(type));

        li.classList.add(cssClass);
        li.setAttribute('data-pagination-type', type);
        li.setAttribute('data-page', page);
        a.appendChild(text);
        li.appendChild(a);

        return li;
    }

    function paginationText(type) {
        return options[type + 'Text'];
    }

    function buildPagination() {
        var pagination = [];
        var prev = currentPage - 1 < startPage ? startPage : currentPage - 1;
        var next = currentPage + 1 > totalPages ? totalPages : currentPage + 1;

        var start = 0;
        var end = 0;
        var limit = limitPagination;

        if (limit) {
            if (currentPage <= Math.ceil(limit / 2) + 1) {
                start = 1;
                end = limit;
            } else if (currentPage + Math.floor(limit / 2) >= totalPages) {
                start = totalPages + 1 - limit;
                end = totalPages;
            } else {
                start = currentPage - Math.ceil(limit / 2);
                end = currentPage + Math.floor(limit / 2);
            }
        } else {
            start = startPage;
            end = totalPages;
        }


        // "First" button
        if (options.firstLast) {
            pagination.push(paginationFunc('first', startPage));
        }

        // "Prev" button
        if (options.prevNext) {
            pagination.push(paginationFunc('prev', prev));
        }

        // Pagination
        for (var i = start; i <= end; i++) {
            pagination.push(paginationFunc('number', i));
        }

        // "Next" button
        if (options.prevNext) {
            pagination.push(paginationFunc('next', next));
        }

        // "Last" button
        if (options.firstLast) {
            pagination.push(paginationFunc('last', totalPages));
        }
        return pagination;
    }

    function render(page) {
        // Remove children before re-render (prevent duplicate)
        while (ul.hasChildNodes()) {
            ul.removeChild(ul.lastChild);
        }

        var paginationBuild = buildPagination();

        paginationBuild.forEach(function(item) {
            ul.appendChild(item);
        });

        // Manage active DOM
        var startAt = page === 1 ? 0 : (page - 1) * options.perPage;
        var endAt = page * options.perPage;

        var domLi = el.children;

        for (var i = 0, len = domLi.length; i < len; i++) {
            var item = domLi[i];

            if (i >= startAt && i <= endAt) {
                item.classList.remove('hidden');
            } else {
                item.classList.add('hidden');
            }
        }

        // Manage active state
        var ulKids = ul.getElementsByTagName("li");

        for (var i = 0, len = ulKids.length; i < len; i++) {
            var _li = ulKids[i];
            var type = _li.getAttribute('data-pagination-type');

            switch (type) {
                case 'number':
                    if (parseInt(_li.getAttribute('data-page'), 10) === page) {
                        _li.classList.add(options.activeClass);
                    }
                    break;
                case 'first':
                    page === startPage && _li.classList.toggle(options.disabledClass);
                    break;
                case 'last':
                    page === totalPages && _li.classList.toggle(options.disabledClass);
                    break;
                case 'prev':
                    (page - 1) < startPage && _li.classList.toggle(options.disabledClass);
                    break;
                case 'next':
                    (page + 1) > totalPages && _li.classList.toggle(options.disabledClass);
                    break;
                default:
                    break;
            }
        }

        el.before(container);
        container.appendChild(ul);
    }

    function handle() {
        var pagLi = container.childNodes[0].childNodes;

        for (var i = 0, len = pagLi.length; i < len; i++) {
            (function() {
                var item = pagLi[i];

                item.addEventListener('click', function(e) {
                    e.preventDefault();
                    var page = parseInt(item.getAttribute('data-page'), 10);
                    currentPage = page;
                    // let's prevent the pagination from flowing to two rows
                    if (currentPage >= 98) {
                        limitPagination = 4;
                    } else {
                        limitPagination = pagLimit();
                    }
                    show(page);
                });
            }());
        }
    }

    function show(page) {
        render(page);
        handle();
    }

    show(startPage);

    return;
};
