!function(e, t) {
    "object" == typeof exports && "object" == typeof module ? module.exports = t() : "function" == typeof define && define.amd ? define([], t) : "object" == typeof exports ? exports.XMindEmbedViewer = t() : e.XMindEmbedViewer = t()
}(self, (function() {
    return (()=>{
        "use strict";
        var e = {
            61: function(e, t) {
                var n = this && this.__awaiter || function(e, t, n, r) {
                    return new (n || (n = Promise))((function(o, i) {
                        function a(e) {
                            try {
                                l(r.next(e))
                            } catch (e) {
                                i(e)
                            }
                        }
                        function s(e) {
                            try {
                                l(r.throw(e))
                            } catch (e) {
                                i(e)
                            }
                        }
                        function l(e) {
                            var t;
                            e.done ? o(e.value) : (t = e.value,
                            t instanceof n ? t : new n((function(e) {
                                e(t)
                            }
                            ))).then(a, s)
                        }
                        l((r = r.apply(e, t || [])).next())
                    }
                    ))
                }
                  , r = this && this.__generator || function(e, t) {
                    var n, r, o, i, a = {
                        label: 0,
                        sent: function() {
                            if (1 & o[0])
                                throw o[1];
                            return o[1]
                        },
                        trys: [],
                        ops: []
                    };
                    return i = {
                        next: s(0),
                        throw: s(1),
                        return: s(2)
                    },
                    "function" == typeof Symbol && (i[Symbol.iterator] = function() {
                        return this
                    }
                    ),
                    i;
                    function s(i) {
                        return function(s) {
                            return function(i) {
                                if (n)
                                    throw new TypeError("Generator is already executing.");
                                for (; a; )
                                    try {
                                        if (n = 1,
                                        r && (o = 2 & i[0] ? r.return : i[0] ? r.throw || ((o = r.return) && o.call(r),
                                        0) : r.next) && !(o = o.call(r, i[1])).done)
                                            return o;
                                        switch (r = 0,
                                        o && (i = [2 & i[0], o.value]),
                                        i[0]) {
                                        case 0:
                                        case 1:
                                            o = i;
                                            break;
                                        case 4:
                                            return a.label++,
                                            {
                                                value: i[1],
                                                done: !1
                                            };
                                        case 5:
                                            a.label++,
                                            r = i[1],
                                            i = [0];
                                            continue;
                                        case 7:
                                            i = a.ops.pop(),
                                            a.trys.pop();
                                            continue;
                                        default:
                                            if (!((o = (o = a.trys).length > 0 && o[o.length - 1]) || 6 !== i[0] && 2 !== i[0])) {
                                                a = 0;
                                                continue
                                            }
                                            if (3 === i[0] && (!o || i[1] > o[0] && i[1] < o[3])) {
                                                a.label = i[1];
                                                break
                                            }
                                            if (6 === i[0] && a.label < o[1]) {
                                                a.label = o[1],
                                                o = i;
                                                break
                                            }
                                            if (o && a.label < o[2]) {
                                                a.label = o[2],
                                                a.ops.push(i);
                                                break
                                            }
                                            o[2] && a.ops.pop(),
                                            a.trys.pop();
                                            continue
                                        }
                                        i = t.call(e, a)
                                    } catch (e) {
                                        i = [6, e],
                                        r = 0
                                    } finally {
                                        n = o = 0
                                    }
                                if (5 & i[0])
                                    throw i[1];
                                return {
                                    value: i[0] ? i[1] : void 0,
                                    done: !0
                                }
                            }([i, s])
                        }
                    }
                }
                ;
                Object.defineProperty(t, "__esModule", {
                    value: !0
                }),
                t.IframeEventChannelController = void 0;
                var o = function() {
                    function e(e, t) {
                        void 0 === t && (t = "*"),
                        this.channel = new MessageChannel,
                        this.eventIndex = 0,
                        this.handlers = {};
                        var o = e.getIframe();
                        if (o.hasAttribute("data-event-channel-setup"))
                            throw new Error("An embed viewer instance already initialized on the iframe!");
                        o.setAttribute("data-event-channel-setup", "true"),
                        this.channelSetupPromise = n(this, void 0, void 0, (function() {
                            var e = this;
                            return r(this, (function(n) {
                                switch (n.label) {
                                case 0:
                                    return [4, new Promise((function(n) {
                                        o.addEventListener("load", (function() {
                                            var r;
                                            e.channel.port1.start();
                                            var i = function(t) {
                                                "channel-ready" === t.data[0] && (t.preventDefault(),
                                                e.channel.port1.removeEventListener("message", i),
                                                e.channel.port1.addEventListener("message", e.eventDispatcher.bind(e)),
                                                n(void 0))
                                            };
                                            e.channel.port1.addEventListener("message", i),
                                            null === (r = o.contentWindow) || void 0 === r || r.postMessage(["setup-channel", {
                                                port: e.channel.port2
                                            }], t || "*", [e.channel.port2])
                                        }
                                        ))
                                    }
                                    ))];
                                case 1:
                                    return n.sent(),
                                    [2]
                                }
                            }
                            ))
                        }
                        ))
                    }
                    return e.prototype.eventDispatcher = function(e) {
                        var t = e.data || []
                          , n = t[0]
                          , r = t[1]
                          , o = t[2];
                        "event" === n && r && this.handlers[r] && this.handlers[r].forEach((function(e) {
                            return e(o)
                        }
                        ))
                    }
                    ,
                    e.prototype.addEventListener = function(e, t) {
                        this.handlers[e] = this.handlers[e] || [],
                        this.handlers[e].includes(t) || this.handlers[e].push(t)
                    }
                    ,
                    e.prototype.removeEventListener = function(e, t) {
                        if (this.handlers[e]) {
                            var n = this.handlers[e].findIndex((function(e) {
                                return e === t
                            }
                            ));
                            this.handlers[e].splice(n, 1)
                        }
                    }
                    ,
                    e.prototype.emit = function(e, t) {
                        return n(this, void 0, void 0, (function() {
                            var n, o = this;
                            return r(this, (function(r) {
                                switch (r.label) {
                                case 0:
                                    return [4, this.channelSetupPromise];
                                case 1:
                                    return r.sent(),
                                    n = "xmind-embed-viewer#" + this.eventIndex++,
                                    [4, new Promise((function(r) {
                                        var i = function(e) {
                                            var t = e.data
                                              , a = t[0]
                                              , s = t[1];
                                            a === n && (o.channel.port1.removeEventListener("message", i),
                                            r(s))
                                        };
                                        o.channel.port1.addEventListener("message", i),
                                        o.channel.port1.postMessage([e, t, n])
                                    }
                                    ))];
                                case 2:
                                    return r.sent(),
                                    [2]
                                }
                            }
                            ))
                        }
                        ))
                    }
                    ,
                    e
                }();
                t.IframeEventChannelController = o
            },
            860: (e,t)=>{
                Object.defineProperty(t, "__esModule", {
                    value: !0
                }),
                t.IframeController = void 0;
                var n = function() {
                    function e(e, t) {
                        var n, r = "string" == typeof e ? document.querySelector(e) : e;
                        if (null === r)
                            throw new Error("IFrame or mount element not found by selector " + e);
                        r instanceof HTMLIFrameElement ? n = r : (n = document.createElement("iframe"),
                        r.appendChild(n)),
                        n.setAttribute("frameborder", "0"),
                        n.setAttribute("scrolling", "no"),
                        n.setAttribute("allowfullscreen", "true"),
                        n.setAttribute("allow", "allowfullscreen"),
                        n.setAttribute("crossorigin", "anonymous"),
                        n.setAttribute("src", t),
                        this.iframe = n
                    }
                    return e.prototype.getIframe = function() {
                        return this.iframe
                    }
                    ,
                    e.prototype.setStyles = function(e) {
                        for (var t = this.getIframe(), n = 0, r = Object.entries(e); n < r.length; n++) {
                            var o = r[n]
                              , i = o[0]
                              , a = o[1];
                            t.style[i] = a
                        }
                    }
                    ,
                    e
                }();
                t.IframeController = n
            }
            ,
            341: (e,t,n)=>{
                t.XMindEmbedViewer = void 0;
                var r = n(61)
                  , o = n(860)
                  , i = function() {
                    function e(e) {
                        var t = this;
                        this.internalState = {
                            sheets: [],
                            zoomScale: 100,
                            currentSheetId: ""
                        };
          var windowWidth = document.documentElement.clientWidth || document.body.clientWidth;
          var windowHeight = document.documentElement.clientHeight || document.body.clientHeight;
		      windowWidth = windowWidth-30;
              windowHeight = windowHeight-30;
	      windowWidth =windowWidth+"px";
	      windowHeight =windowHeight+"px";
                        var n = e.file
                          , i = e.el
                          , a = e.styles
                          , s = void 0 === a ? {
                            height: windowWidth,
                            width: windowHeight
                        } : a
                          , l = new o.IframeController(i,"xmind/index.html")
                          , u = new r.IframeEventChannelController(l,"");
                        this.iframeController = l,
                        this.iframeEventChannelController = u,
                        u.addEventListener("sheet-switch", (function(e) {
                            return t.internalState.currentSheetId = e
                        }
                        )),
                        u.addEventListener("zoom-change", (function(e) {
                            return t.internalState.zoomScale = e
                        }
                        )),
                        u.addEventListener("sheets-load", (function(e) {
                            return t.internalState.sheets = e
                        }
                        )),
                        this.iframeController.setStyles(s),
                        n && this.load(n)
                    }
                    return e.prototype.addEventListener = function(e, t) {
                        this.iframeEventChannelController.addEventListener(e, t)
                    }
                    ,
                    e.prototype.removeEventListener = function(e, t) {
                        this.iframeEventChannelController.removeEventListener(e, t)
                    }
                    ,
                    e.prototype.setStyles = function(e) {
                        this.iframeController.setStyles(e)
                    }
                    ,
                    e.prototype.load = function(e) {
                        this.iframeEventChannelController.emit("open-file", e)
                    }
                    ,
                    e.prototype.setZoomScale = function(e) {
                        this.iframeEventChannelController.emit("zoom", e)
                    }
                    ,
                    e.prototype.setFitMap = function() {
                        this.iframeEventChannelController.emit("fit-map")
                    }
                    ,
                    e.prototype.switchSheet = function(e) {
                        this.iframeEventChannelController.emit("switch-sheet", e)
                    }
                    ,
                    Object.defineProperty(e.prototype, "zoom", {
                        get: function() {
                            return this.internalState.zoomScale
                        },
                        enumerable: !1,
                        configurable: !0
                    }),
                    Object.defineProperty(e.prototype, "sheets", {
                        get: function() {
                            return JSON.parse(JSON.stringify(this.internalState.sheets))
                        },
                        enumerable: !1,
                        configurable: !0
                    }),
                    Object.defineProperty(e.prototype, "currentSheetId", {
                        get: function() {
                            return this.internalState.currentSheetId
                        },
                        enumerable: !1,
                        configurable: !0
                    }),
                    e
                }();
                t.XMindEmbedViewer = i
            }
        }
          , t = {};
        return function n(r) {
            if (t[r])
                return t[r].exports;
            var o = t[r] = {
                exports: {}
            };
            return e[r].call(o.exports, o, o.exports, n),
            o.exports
        }(341)
    }
    )().XMindEmbedViewer
}
));
