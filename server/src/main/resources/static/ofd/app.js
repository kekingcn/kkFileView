(function(e) {
    function t(t) {
        for (var s, i, u = t[0], o = t[1], l = t[2], b = 0, d = []; b < u.length; b++) i = u[b],
        Object.prototype.hasOwnProperty.call(a, i) && a[i] && d.push(a[i][0]),
        a[i] = 0;
        for (s in o) Object.prototype.hasOwnProperty.call(o, s) && (e[s] = o[s]);
        c && c(t);
        while (d.length) d.shift()();
        return r.push.apply(r, l || []),
        n()
    }
    function n() {
        for (var e, t = 0; t < r.length; t++) {
            for (var n = r[t], s = !0, u = 1; u < n.length; u++) {
                var o = n[u];
                0 !== a[o] && (s = !1)
            }
            s && (r.splice(t--, 1), e = i(i.s = n[0]))
        }
        return e
    }
    var s = {},
    a = {
        app: 0
    },
    r = [];
    function i(t) {
        if (s[t]) return s[t].exports;
        var n = s[t] = {
            i: t,
            l: !1,
            exports: {}
        };
        return e[t].call(n.exports, n, n.exports, i),
        n.l = !0,
        n.exports
    }
    i.m = e,
    i.c = s,
    i.d = function(e, t, n) {
        i.o(e, t) || Object.defineProperty(e, t, {
            enumerable: !0,
            get: n
        })
    },
    i.r = function(e) {
        "undefined" !== typeof Symbol && Symbol.toStringTag && Object.defineProperty(e, Symbol.toStringTag, {
            value: "Module"
        }),
        Object.defineProperty(e, "__esModule", {
            value: !0
        })
    },
    i.t = function(e, t) {
        if (1 & t && (e = i(e)), 8 & t) return e;
        if (4 & t && "object" === typeof e && e && e.__esModule) return e;
        var n = Object.create(null);
        if (i.r(n), Object.defineProperty(n, "default", {
            enumerable: !0,
            value: e
        }), 2 & t && "string" != typeof e) for (var s in e) i.d(n, s,
        function(t) {
            return e[t]
        }.bind(null, s));
        return n
    },
    i.n = function(e) {
        var t = e && e.__esModule ?
        function() {
            return e["default"]
        }: function() {
            return e
        };
        return i.d(t, "a", t),
        t
    },
    i.o = function(e, t) {
        return Object.prototype.hasOwnProperty.call(e, t)
    },
    i.p = "/ofd/";
    var u = window["webpackJsonp"] = window["webpackJsonp"] || [],
    o = u.push.bind(u);
    u.push = t,
    u = u.slice();
    for (var l = 0; l < u.length; l++) t(u[l]);
    var c = o;
    r.push([0, "chunk-vendors"]),
    n()
})({
    0 : function(e, t, n) {
        e.exports = n("56d7")
    },
    "034f": function(e, t, n) {
        "use strict";
        n("85ec")
    },
    3662 : function(e, t, n) {
        "use strict";
        n.d(t, "a", (function() {
            return r
        }));
        n("96cf");
        var s = n("1da1");
        Array.prototype.pipeline = function() {
            var e = Object(s["a"])(regeneratorRuntime.mark((function e(t) {
                var n, s, a;
                return regeneratorRuntime.wrap((function(e) {
                    while (1) switch (e.prev = e.next) {
                    case 0:
                        if (null !== this && "undefined" !== typeof this) {
                            e.next = 2;
                            break
                        }
                        throw new TypeError("Array.prototype.pipeline called on null or undefined");
                    case 2:
                        if ("function" === typeof t) {
                            e.next = 4;
                            break
                        }
                        throw new TypeError(t + " is not a function");
                    case 4:
                        a = this.length >>> 0,
                        n = 0;
                    case 6:
                        if (! (a > n)) {
                            e.next = 13;
                            break
                        }
                        return e.next = 9,
                        t(s, this[n], n, this);
                    case 9:
                        s = e.sent;
                    case 10:
                        ++n,
                        e.next = 6;
                        break;
                    case 13:
                        return e.abrupt("return", s);
                    case 14:
                    case "end":
                        return e.stop()
                    }
                }), e, this)
            })));
            return function(t) {
                return e.apply(this, arguments)
            }
        } ();
        var a = function() {
            for (var e = this,
            t = arguments.length,
            n = new Array(t), s = 0; s < t; s++) n[s] = arguments[s];
            return n.pipeline((function(t, n) {
                return n.call(e, t)
            }))
        },
        r = a
    },
    "56d7": function(e, t, n) {
        "use strict";
        n.r(t);
        n("e260"),
        n("e6cf"),
        n("cca6"),
        n("a79d");
        var s = n("2b0e"),
        a = function() {
            var e = this,
            t = e.$createElement,
            n = e._self._c || t;
            return n("div", {
                attrs: {
                    id: "app"
                }
            },
            [n("HelloWorld")], 1)
        },
        r = [],
        i = function() {
            var e = this,
            t = e.$createElement,
            n = e._self._c || t;
            return n("el-container", {
                staticStyle: {
                    width: "100vw",
                    height: "100vh"
                }
            },
            [n("el-header", {
                staticStyle: {
                    background: "#F5F5F5",
                    display: "flex",
                    height: "40px",
                    border: "1px solid #e8e8e8",
                    "align-items": "center"
                }
            },
            [n("div", {
                staticClass: "upload-icon",
                on: {
                    click: e.uploadFile
                }
            },
            [n("div", {
                staticClass: "upload-icon"
            },
            [e._v("打开OFD")]), n("font-awesome-icon", {
                attrs: {
                    icon: "cloud-upload-alt"
                }
            }), n("input", {
                ref: "file",
                staticClass: "hidden",
                attrs: {
                    type: "file",
                    accept: ".ofd"
                },
                on: {
                    change: e.fileChanged
                }
            })], 1), n("div", {
                staticClass: "upload-icon",
                style:"display:none",
                on: {
                    click: e.uploadPdfFile
                }
            },
            [n("div", {
                staticClass: "upload-icon",
                style:"display:none"
            },
            [e._v("PDF2OFD")]), n("font-awesome-icon", {
                attrs: {
                    icon: "cloud-upload-alt",
                    style:"display:none"
                }
            }), n("input", {
                ref: "pdfFile",
                staticClass: "hidden",
                attrs: {
                    type: "file",
                    accept: ".pdf"
                },
                on: {
                    change: e.pdfFileChanged
                }
            })], 1), true ? n("div", {
                staticStyle: {
                    display: "flex",
                    "align-items": "center"
                }
            },
            [e.ofdBase64 ? n("div", {
                staticClass: "upload-icon",
                style:"display:none",
                staticStyle: {
                    "margin-left": "10px"
                },
                on: {
                    click: e.downPdf
                }
            },
            [e._v(" 下载PDF "), n("font-awesome-icon", {
                attrs: {
                    icon: "download"
                }
            })], 1) : e._e(), n("div", {
                staticClass: "scale-icon",
                staticStyle: {
                    "margin-left": "10px"
                },
                on: {
                    click: e.plus
                }
            },
            [n("font-awesome-icon", {
                attrs: {
                    icon: "search-plus"
                }
            })], 1), n("div", {
                staticClass: "scale-icon",
                on: {
                    click: e.minus
                }
            },
            [n("font-awesome-icon", {
                attrs: {
                    icon: "search-minus"
                }
            })], 1), n("div", {
                staticClass: "scale-icon"
            },
            [n("font-awesome-icon", {
                attrs: {
                    icon: "step-backward"
                },
                on: {
                    click: e.firstPage
                }
            })], 1), n("div", {
                staticClass: "scale-icon",
                staticStyle: {
                    "font-size": "18px"
                },
                on: {
                    click: e.prePage
                }
            },
            [n("font-awesome-icon", {
                attrs: {
                    icon: "caret-left"
                }
            })], 1), n("div", {
                staticClass: "scale-icon"
            },
            [e._v(" " + e._s(e.pageIndex) + "/" + e._s(e.pageCount) + " ")]), n("div", {
                staticClass: "scale-icon",
                staticStyle: {
                    "font-size": "18px"
                },
                on: {
                    click: e.nextPage
                }
            },
            [n("font-awesome-icon", {
                attrs: {
                    icon: "caret-right"
                }
            })], 1), n("div", {
                staticClass: "scale-icon",
                on: {
                    click: e.lastPage
                }
            },
            [n("font-awesome-icon", {
                attrs: {
                    icon: "step-forward"
                }
            })], 1)]) : e._e()]), n("el-main", {
                directives: [{
                    name: "loading",
                    rawName: "v-loading",
                    value: e.loading,
                    expression: "loading"
                }],
                staticStyle: {
                    height: "auto",
                    background: "#808080",
                    padding: "0"
                }
            },
            [n("div", {
                staticClass: "left-section",
                attrs: {
                    id: "leftMenu",
                    style:"display:none"
                }
            },
            [n("div", {
                staticClass: "text-icon",
                on: {
                    click: function(t) {
                    }
                }
                
            },
            [n("p", [e._v("电子发票")])]), n("div", {
                staticClass: "text-icon",
                on: {
                    click: function(t) {
                    }
                }
            }
            ,
            [n("p", [e._v("电子公文")])]), n("div", {
                staticClass: "text-icon",
                on: {
                    click: function(t) {
                    }
                }
            },
            [n("p", [e._v("骑缝章")])]), n("div", {
                staticClass: "text-icon",
                on: {
                    click: function(t) {
                    }
                }
            },
            [n("p", [e._v("多页文档")])])]), n("div", {
                ref: "contentDiv",
                staticClass: "main-section",
                attrs: {
                    id: "content"
                },
                on: {
                    mousewheel: e.scrool
                }
            })]), n("div", {
                ref: "sealInfoDiv",
                staticClass: "SealContainer",
                attrs: {
                    id: "sealInfoDiv",
                    hidden: "hidden"
                }
            },
            [n("div", {
                staticClass: "SealContainer mask",
                on: {
                    click: e.closeSealInfoDialog
                }
            }), n("div", {
                staticClass: "SealContainer-layout"
            },
            [n("div", {
                staticClass: "SealContainer-content"
            },
            [n("p", {
                staticClass: "content-title"
            },
            [e._v("签章信息")]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("签章人")]), n("span", {
                staticClass: "value",
                attrs: {
                    id: "spSigner"
                }
            },
            [e._v("[无效的签章结构]")])]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("签章提供者")]), n("span", {
                staticClass: "value",
                attrs: {
                    id: "spProvider"
                }
            },
            [e._v("[无效的签章结构]")])]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("原文摘要值")]), n("span", {
                staticClass: "value",
                staticStyle: {
                    cursor: "pointer"
                },
                attrs: {
                    id: "spHashedValue"
                },
                on: {
                    click: function(t) {
                        return e.showMore("原文摘要值", "spHashedValue")
                    }
                }
            },
            [e._v("[无效的签章结构]")])]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("签名值")]), n("span", {
                staticClass: "value",
                staticStyle: {
                    cursor: "pointer"
                },
                attrs: {
                    id: "spSignedValue"
                },
                on: {
                    click: function(t) {
                        return e.showMore("签名值", "spSignedValue")
                    }
                }
            },
            [e._v("[无效的签章结构]")])]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("签名算法")]), n("span", {
                staticClass: "value",
                attrs: {
                    id: "spSignMethod"
                }
            },
            [e._v("[无效的签章结构]")])]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("版本号")]), n("span", {
                staticClass: "value",
                attrs: {
                    id: "spVersion"
                }
            },
            [e._v("[无效的签章结构]")])]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("验签结果")]), n("span", {
                staticClass: "value",
                attrs: {
                    id: "VerifyRet"
                }
            },
            [e._v("[无效的签章结构]")])]), n("p", {
                staticClass: "content-title"
            },
            [e._v("印章信息")]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("印章标识")]), n("span", {
                staticClass: "value",
                attrs: {
                    id: "spSealID"
                }
            },
            [e._v("[无效的签章结构]")])]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("印章名称")]), n("span", {
                staticClass: "value",
                attrs: {
                    id: "spSealName"
                }
            },
            [e._v("[无效的签章结构]")])]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("印章类型")]), n("span", {
                staticClass: "value",
                attrs: {
                    id: "spSealType"
                }
            },
            [e._v("[无效的签章结构]")])]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("有效时间")]), n("span", {
                staticClass: "value",
                attrs: {
                    id: "spSealAuthTime"
                }
            },
            [e._v("[无效的签章结构]")])]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("制章日期")]), n("span", {
                staticClass: "value",
                attrs: {
                    id: "spSealMakeTime"
                }
            },
            [e._v("[无效的签章结构]")])]), n("div", {
                staticClass: "subcontent"
            },
            [n("span", {
                staticClass: "title"
            },
            [e._v("印章版本")]), n("span", {
                staticClass: "value",
                attrs: {
                    id: "spSealVersion"
                }
            },
            [e._v("[无效的签章结构]")])])]), n("input", {
                staticStyle: {
                    position: "absolute",
                    right: "1%",
                    top: "1%"
                },
                attrs: {
                    type: "button",
                    name: "",
                    id: "",
                    value: "X"
                },
                on: {
                    click: function(t) {
                        return e.closeSealInfoDialog()
                    }
                }
            })])]), n("el-dialog", {
                attrs: {
                    title: e.title,
                    visible: e.dialogFormVisible
                },
                on: {
                    "update:visible": function(t) {
                        e.dialogFormVisible = t
                    }
                }
            },
            [n("span", {
                staticStyle: {
                    "text-align": "left"
                }
            },
            [e._v(" " + e._s(e.value) + " ")]), n("div", {
                staticClass: "dialog-footer",
                attrs: {
                    slot: "footer"
                },
                slot: "footer"
            },
            [n("el-button", {
                attrs: {
                    type: "primary"
                },
                on: {
                    click: function(t) {
                        e.dialogFormVisible = !1
                    }
                }
            },
            [e._v("确 定")])], 1)])], 1)
        },
                
        u = [],
        o = n("8374"),
        l = o["a"],
        c = (n("e12b"), n("2877")),
        b = Object(c["a"])(l, i, u, !1, null, "b0082a62", null),
        d = b.exports,
        f = {
            name: "App",
            components: {
                HelloWorld: d
            }
        },
        h = f,
        p = (n("034f"), Object(c["a"])(h, a, r, !1, null, null, null)),
        v = p.exports,
        g = (n("5717"), n("5c96")),
        m = n.n(g),
        y = (n("0fae"), n("ecee")),
        x = n("c074"),
        w = n("ad3d"),
        O = n("bc3a"),
        S = n.n(O);
        s["default"].prototype.$axios = S.a,
        y["c"].add(x["a"]),
        s["default"].config.productionTip = !1,
        s["default"].component("font-awesome-icon", w["a"]),
        s["default"].use(m.a),
        new s["default"]({
            render: function(e) {
                return e(v)
            }
        }).$mount("#app")
    },
    5717 : function(e, t, n) {},
   
    "67d3": function(e, t, n) {
        "use strict"; (function(e) {
            n.d(t, "c", (function() {
                return f
            })),
            n.d(t, "a", (function() {
                return h
            })),
            n.d(t, "b", (function() {
                return p
            }));
            n("99af"),
            n("4160"),
            n("c975"),
            n("baa5"),
            n("4ec9"),
            n("b64b"),
            n("d3b7"),
            n("ac1f"),
            n("25f0"),
            n("3ca3"),
            n("5319"),
            n("1276"),
            n("159b"),
            n("ddb0");
            var s = n("b85c"),
            a = n("3835"),
            r = (n("96cf"), n("1da1")),
            i = n("3662"),
            u = n("c4e3"),
            o = n.n(u),
            l = n("6b33"),
            c = n("73fd"),
            b = n("a9c6"),
            d = n("74db"),
            f = function(e) {
                return new Promise((function(t, n) {
                    o.a.loadAsync(e).then((function(e) {
                        t(e)
                    }), (function(e) {
                        n(e)
                    }))
                }))
            },
            h = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t) {
                    var n, s, a;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            return e.next = 2,
                            T(t, "OFD.xml");
                        case 2:
                            return n = e.sent,
                            s = n["json"]["ofd:OFD"]["ofd:DocBody"],
                            a = [],
                            a = a.concat(s),
                            e.abrupt("return", [t, a]);
                        case 7:
                        case "end":
                            return e.stop()
                        }
                    }), e)
                })));
                return function(t) {
                    return e.apply(this, arguments)
                }
            } (),
            p = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t) {
                    var n, r, i, u, o, l, c, b;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            n = Object(a["a"])(t, 2),
                            r = n[0],
                            i = n[1],
                            u = [],
                            o = Object(s["a"])(i),
                            e.prev = 3,
                            o.s();
                        case 5:
                            if ((l = o.n()).done) {
                                e.next = 29;
                                break
                            }
                            if (c = l.value, !c) {
                                e.next = 27;
                                break
                            }
                            return e.next = 10,
                            v(r, c);
                        case 10:
                            return b = e.sent,
                            e.next = 13,
                            g(b);
                        case 13:
                            return b = e.sent,
                            e.next = 16,
                            y(b);
                        case 16:
                            return b = e.sent,
                            e.next = 19,
                            x(b);
                        case 19:
                            return b = e.sent,
                            e.next = 22,
                            w(b);
                        case 22:
                            return b = e.sent,
                            e.next = 25,
                            O(b);
                        case 25:
                            b = e.sent,
                            u.push(b);
                        case 27:
                            e.next = 5;
                            break;
                        case 29:
                            e.next = 34;
                            break;
                        case 31:
                            e.prev = 31,
                            e.t0 = e["catch"](3),
                            o.e(e.t0);
                        case 34:
                            return e.prev = 34,
                            o.f(),
                            e.finish(34);
                        case 37:
                            return e.abrupt("return", u);
                        case 38:
                        case "end":
                            return e.stop()
                        }
                    }), e, null, [[3, 31, 34, 37]])
                })));
                return function(t) {
                    return e.apply(this, arguments)
                }
            } (),
            v = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t, n) {
                    var a, r, i, u, o, c, b, d, f, h, p, v, g, m, y, x, w, O;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            return a = n["ofd:DocRoot"],
                            a = Object(l["m"])(a),
                            r = a.split("/")[0],
                            i = n["ofd:Signatures"],
                            e.next = 6,
                            C(t, i, r);
                        case 6:
                            u = e.sent,
                            o = {},
                            c = Object(s["a"])(u),
                            e.prev = 9,
                            c.s();
                        case 11:
                            if ((b = c.n()).done) {
                                e.next = 25;
                                break
                            }
                            if (d = b.value, !(d.sealObj && Object.keys(d.sealObj).length > 0)) {
                                e.next = 23;
                                break
                            }
                            if ("ofd" !== d.sealObj.type) {
                                e.next = 22;
                                break
                            }
                            return e.next = 17,
                            D(d);
                        case 17:
                            f = e.sent,
                            h = Object(s["a"])(f);
                            try {
                                for (h.s(); ! (p = h.n()).done;) v = p.value,
                                d.stampAnnot.boundary = Object(l["l"])(d.stampAnnot["@_Boundary"]),
                                d.stampAnnot.pageRef = d.stampAnnot["@_PageRef"],
                                o[d.stampAnnot["@_PageRef"]] || (o[d.stampAnnot["@_PageRef"]] = []),
                                o[d.stampAnnot["@_PageRef"]].push({
                                    type: "ofd",
                                    obj: v,
                                    stamp: d
                                })
                            } catch(S) {
                                h.e(S)
                            } finally {
                                h.f()
                            }
                            e.next = 23;
                            break;
                        case 22:
                            if ("png" === d.sealObj.type) {
                                g = "data:image/png;base64," + btoa(String.fromCharCode.apply(null, d.sealObj.ofdArray)),
                                m = [],
                                m = m.concat(d.stampAnnot),
                                y = Object(s["a"])(m);
                                try {
                                    for (y.s(); ! (x = y.n()).done;) w = x.value,
                                    w && (O = {
                                        img: g,
                                        pageId: w["@_PageRef"],
                                        boundary: Object(l["l"])(w["@_Boundary"]),
                                        clip: Object(l["l"])(w["@_Clip"])
                                    },
                                    o[w["@_PageRef"]] || (o[w["@_PageRef"]] = []), o[w["@_PageRef"]].push({
                                        type: "png",
                                        obj: O,
                                        stamp: d
                                    }))
                                } catch(S) {
                                    y.e(S)
                                } finally {
                                    y.f()
                                }
                            }
                        case 23:
                            e.next = 11;
                            break;
                        case 25:
                            e.next = 30;
                            break;
                        case 27:
                            e.prev = 27,
                            e.t0 = e["catch"](9),
                            c.e(e.t0);
                        case 30:
                            return e.prev = 30,
                            c.f(),
                            e.finish(30);
                        case 33:
                            return e.abrupt("return", [t, r, a, o]);
                        case 34:
                        case "end":
                            return e.stop()
                        }
                    }), e, null, [[9, 27, 30, 33]])
                })));
                return function(t, n) {
                    return e.apply(this, arguments)
                }
            } (),
            g = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t) {
                    var n, s, r, i, u, o, l, c, b, d, f;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            return n = Object(a["a"])(t, 4),
                            s = n[0],
                            r = n[1],
                            i = n[2],
                            u = n[3],
                            e.next = 3,
                            T(s, i);
                        case 3:
                            if (o = e.sent, l = o["json"]["ofd:Document"], c = l["ofd:Annotations"], b = [], !c) {
                                e.next = 15;
                                break
                            }
                            if ( - 1 !== c.indexOf("/") && (d = c.substring(0, c.indexOf("/"))), -1 === c.indexOf(r) && (c = "".concat(r, "/").concat(c)), !s.files[c]) {
                                e.next = 15;
                                break
                            }
                            return e.next = 13,
                            T(s, c);
                        case 13:
                            c = e.sent,
                            b = b.concat(c["json"]["ofd:Annotations"]["ofd:Page"]);
                        case 15:
                            return e.next = 17,
                            m(d, b, r, s);
                        case 17:
                            return f = e.sent,
                            e.abrupt("return", [s, r, l, u, f]);
                        case 19:
                        case "end":
                            return e.stop()
                        }
                    }), e)
                })));
                return function(t) {
                    return e.apply(this, arguments)
                }
            } (),
            m = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t, n, a, r) {
                    var i, u, o, l, c, b, d, f, h, p, v, g, m, y, x;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            i = {},
                            u = Object(s["a"])(n),
                            e.prev = 2,
                            u.s();
                        case 4:
                            if ((o = u.n()).done) {
                                e.next = 43;
                                break
                            }
                            if (l = o.value, l) {
                                e.next = 8;
                                break
                            }
                            return e.abrupt("continue", 41);
                        case 8:
                            if (c = l["@_PageID"], b = l["ofd:FileLoc"], t && -1 === b.indexOf(t) && (b = "".concat(t, "/").concat(b)), -1 === b.indexOf(a) && (b = "".concat(a, "/").concat(b)), !r.files[b]) {
                                e.next = 41;
                                break
                            }
                            return e.next = 15,
                            T(r, b);
                        case 15:
                            d = e.sent,
                            f = [],
                            f = f.concat(d["json"]["ofd:PageAnnot"]["ofd:Annot"]),
                            i[c] || (i[c] = []),
                            h = Object(s["a"])(f),
                            e.prev = 20,
                            h.s();
                        case 22:
                            if ((p = h.n()).done) {
                                e.next = 33;
                                break
                            }
                            if (v = p.value, v) {
                                e.next = 26;
                                break
                            }
                            return e.abrupt("continue", 31);
                        case 26:
                            g = v["@_Type"],
                            m = !v["@_Visible"] || v["@_Visible"],
                            y = v["ofd:Appearance"],
                            x = {
                                type: g,
                                appearance: y,
                                visible: m
                            },
                            i[c].push(x);
                        case 31:
                            e.next = 22;
                            break;
                        case 33:
                            e.next = 38;
                            break;
                        case 35:
                            e.prev = 35,
                            e.t0 = e["catch"](20),
                            h.e(e.t0);
                        case 38:
                            return e.prev = 38,
                            h.f(),
                            e.finish(38);
                        case 41:
                            e.next = 4;
                            break;
                        case 43:
                            e.next = 48;
                            break;
                        case 45:
                            e.prev = 45,
                            e.t1 = e["catch"](2),
                            u.e(e.t1);
                        case 48:
                            return e.prev = 48,
                            u.f(),
                            e.finish(48);
                        case 51:
                            return e.abrupt("return", i);
                        case 52:
                        case "end":
                            return e.stop()
                        }
                    }), e, null, [[2, 45, 48, 51], [20, 35, 38, 41]])
                })));
                return function(t, n, s, a) {
                    return e.apply(this, arguments)
                }
            } (),
            y = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t) {
                    var n, s, r, i, u, o, l, c, b, d, f, h;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            if (n = Object(a["a"])(t, 5), s = n[0], r = n[1], i = n[2], u = n[3], o = n[4], l = i["ofd:CommonData"]["ofd:DocumentRes"], c = {},
                            b = {},
                            d = {},
                            !l) {
                                e.next = 21;
                                break
                            }
                            if ( - 1 == l.indexOf(r) && (l = "".concat(r, "/").concat(l)), !s.files[l]) {
                                e.next = 21;
                                break
                            }
                            return e.next = 10,
                            T(s, l);
                        case 10:
                            return f = e.sent,
                            h = f["json"]["ofd:Res"],
                            e.next = 14,
                            S(h);
                        case 14:
                            return c = e.sent,
                            e.next = 17,
                            k(h);
                        case 17:
                            return b = e.sent,
                            e.next = 20,
                            j(s, h, r);
                        case 20:
                            d = e.sent;
                        case 21:
                            return e.abrupt("return", [s, r, i, u, o, c, b, d]);
                        case 22:
                        case "end":
                            return e.stop()
                        }
                    }), e)
                })));
                return function(t) {
                    return e.apply(this, arguments)
                }
            } (),
            x = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t) {
                    var n, s, r, i, u, o, l, c, b, d, f, h, p, v, g;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            if (n = Object(a["a"])(t, 8), s = n[0], r = n[1], i = n[2], u = n[3], o = n[4], l = n[5], c = n[6], b = n[7], d = i["ofd:CommonData"]["ofd:PublicRes"], !d) {
                                e.next = 21;
                                break
                            }
                            if ( - 1 == d.indexOf(r) && (d = "".concat(r, "/").concat(d)), !s.files[d]) {
                                e.next = 21;
                                break
                            }
                            return e.next = 7,
                            T(s, d);
                        case 7:
                            return f = e.sent,
                            h = f["json"]["ofd:Res"],
                            e.next = 11,
                            S(h);
                        case 11:
                            return p = e.sent,
                            l = Object.assign(l, p),
                            e.next = 15,
                            k(h);
                        case 15:
                            return v = e.sent,
                            c = Object.assign(c, v),
                            e.next = 19,
                            j(s, h, r);
                        case 19:
                            g = e.sent,
                            b = Object.assign(b, g);
                        case 21:
                            return e.abrupt("return", [s, r, i, u, o, l, c, b]);
                        case 22:
                        case "end":
                            return e.stop()
                        }
                    }), e)
                })));
                return function(t) {
                    return e.apply(this, arguments)
                }
            } (),
            w = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t) {
                    var n, r, i, u, o, l, c, b, d, f, h, p, v, g, m, y;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            n = Object(a["a"])(t, 8),
                            r = n[0],
                            i = n[1],
                            u = n[2],
                            o = n[3],
                            l = n[4],
                            c = n[5],
                            b = n[6],
                            d = n[7],
                            f = u["ofd:CommonData"]["ofd:TemplatePage"],
                            h = [],
                            h = h.concat(f),
                            p = {},
                            v = Object(s["a"])(h),
                            e.prev = 6,
                            v.s();
                        case 8:
                            if ((g = v.n()).done) {
                                e.next = 17;
                                break
                            }
                            if (m = g.value, !m) {
                                e.next = 15;
                                break
                            }
                            return e.next = 13,
                            I(r, m, i);
                        case 13:
                            y = e.sent,
                            p[Object.keys(y)[0]] = y[Object.keys(y)[0]];
                        case 15:
                            e.next = 8;
                            break;
                        case 17:
                            e.next = 22;
                            break;
                        case 19:
                            e.prev = 19,
                            e.t0 = e["catch"](6),
                            v.e(e.t0);
                        case 22:
                            return e.prev = 22,
                            v.f(),
                            e.finish(22);
                        case 25:
                            return e.abrupt("return", [r, i, u, o, l, p, c, b, d]);
                        case 26:
                        case "end":
                            return e.stop()
                        }
                    }), e, null, [[6, 19, 22, 25]])
                })));
                return function(t) {
                    return e.apply(this, arguments)
                }
            } (),
            O = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t) {
                    var n, r, i, u, o, l, c, b, d, f, h, p, v, g, m, y, x, w, O, S;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            n = Object(a["a"])(t, 9),
                            r = n[0],
                            i = n[1],
                            u = n[2],
                            o = n[3],
                            l = n[4],
                            c = n[5],
                            b = n[6],
                            d = n[7],
                            f = n[8],
                            h = u["ofd:Pages"]["ofd:Page"],
                            p = [],
                            p = p.concat(h),
                            v = [],
                            g = Object(s["a"])(p),
                            e.prev = 6,
                            g.s();
                        case 8:
                            if ((m = g.n()).done) {
                                e.next = 22;
                                break
                            }
                            if (y = m.value, !y) {
                                e.next = 20;
                                break
                            }
                            return e.next = 13,
                            I(r, y, i);
                        case 13:
                            x = e.sent,
                            w = Object.keys(x)[0],
                            O = o[w],
                            O && (x[w].stamp = O),
                            S = l[w],
                            S && (x[w].annotation = S),
                            v.push(x);
                        case 20:
                            e.next = 8;
                            break;
                        case 22:
                            e.next = 27;
                            break;
                        case 24:
                            e.prev = 24,
                            e.t0 = e["catch"](6),
                            g.e(e.t0);
                        case 27:
                            return e.prev = 27,
                            g.f(),
                            e.finish(27);
                        case 30:
                            return e.abrupt("return", {
                                doc: i,
                                document: u,
                                pages: v,
                                tpls: c,
                                stampAnnot: o,
                                fontResObj: b,
                                drawParamResObj: d,
                                multiMediaResObj: f
                            });
                        case 31:
                        case "end":
                            return e.stop()
                        }
                    }), e, null, [[6, 24, 27, 30]])
                })));
                return function(t) {
                    return e.apply(this, arguments)
                }
            } (),
            S = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t) {
                    var n, a, r, i, u, o;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            if (n = t["ofd:Fonts"], a = {},
                            n) {
                                r = [],
                                r = r.concat(n["ofd:Font"]),
                                i = Object(s["a"])(r);
                                try {
                                    for (i.s(); ! (u = i.n()).done;) o = u.value,
                                    o && (o["@_FamilyName"] ? a[o["@_ID"]] = o["@_FamilyName"] : a[o["@_ID"]] = o["@_FontName"])
                                } catch(l) {
                                    i.e(l)
                                } finally {
                                    i.f()
                                }
                            }
                            return e.abrupt("return", a);
                        case 4:
                        case "end":
                            return e.stop()
                        }
                    }), e)
                })));
                return function(t) {
                    return e.apply(this, arguments)
                }
            } (),
            k = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t) {
                    var n, a, r, i, u, o;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            if (n = t["ofd:DrawParams"], a = {},
                            n) {
                                r = [],
                                r = r.concat(n["ofd:DrawParam"]),
                                i = Object(s["a"])(r);
                                try {
                                    for (i.s(); ! (u = i.n()).done;) o = u.value,
                                    o && (a[o["@_ID"]] = {
                                        LineWidth: o["@_LineWidth"],
                                        FillColor: o["ofd:FillColor"] ? o["ofd:FillColor"]["@_Value"] : "",
                                        StrokeColor: o["ofd:StrokeColor"] ? o["ofd:StrokeColor"]["@_Value"] : "",
                                        relative: o["@_Relative"]
                                    })
                                } catch(l) {
                                    i.e(l)
                                } finally {
                                    i.f()
                                }
                            }
                            return e.abrupt("return", a);
                        case 4:
                        case "end":
                            return e.stop()
                        }
                    }), e)
                })));
                return function(t) {
                    return e.apply(this, arguments)
                }
            } (),
            j = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t, n, a) {
                    var r, i, u, o, c, b, d, f, h, p, v;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            if (r = n["ofd:MultiMedias"], i = {},
                            !r) {
                                e.next = 41;
                                break
                            }
                            u = [],
                            u = u.concat(r["ofd:MultiMedia"]),
                            o = Object(s["a"])(u),
                            e.prev = 6,
                            o.s();
                        case 8:
                            if ((c = o.n()).done) {
                                e.next = 33;
                                break
                            }
                            if (b = c.value, !b) {
                                e.next = 31;
                                break
                            }
                            if (d = b["ofd:MediaFile"], n["@_BaseLoc"] && -1 === d.indexOf(n["@_BaseLoc"]) && (d = "".concat(n["@_BaseLoc"], "/").concat(d)), -1 === d.indexOf(a) && (d = "".concat(a, "/").concat(d)), "image" !== b["@_Type"].toLowerCase()) {
                                e.next = 30;
                                break
                            }
                            if (f = b["@_Format"], h = Object(l["g"])(d), (!f || "gbig2" !== f.toLowerCase() && "jb2" !== f.toLowerCase()) && (!h || "jb2" !== h.toLowerCase() && "gbig2" !== h.toLowerCase())) {
                                e.next = 24;
                                break
                            }
                            return e.next = 20,
                            A(t, d);
                        case 20:
                            p = e.sent,
                            i[b["@_ID"]] = p,
                            e.next = 28;
                            break;
                        case 24:
                            return e.next = 26,
                            R(t, d);
                        case 26:
                            v = e.sent,
                            i[b["@_ID"]] = {
                                img: v,
                                format: "png"
                            };
                        case 28:
                            e.next = 31;
                            break;
                        case 30:
                            i[b["@_ID"]] = d;
                        case 31:
                            e.next = 8;
                            break;
                        case 33:
                            e.next = 38;
                            break;
                        case 35:
                            e.prev = 35,
                            e.t0 = e["catch"](6),
                            o.e(e.t0);
                        case 38:
                            return e.prev = 38,
                            o.f(),
                            e.finish(38);
                        case 41:
                            return e.abrupt("return", i);
                        case 42:
                        case "end":
                            return e.stop()
                        }
                    }), e, null, [[6, 35, 38, 41]])
                })));
                return function(t, n, s) {
                    return e.apply(this, arguments)
                }
            } (),
            I = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t, n, s) {
                    var a, r, i;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            return a = n["@_BaseLoc"],
                            -1 == a.indexOf(s) && (a = "".concat(s, "/").concat(a)),
                            e.next = 4,
                            T(t, a);
                        case 4:
                            return r = e.sent,
                            i = {},
                            i[n["@_ID"]] = {
                                json: r["json"]["ofd:Page"],
                                xml: r["xml"]
                            },
                            e.abrupt("return", i);
                        case 8:
                        case "end":
                            return e.stop()
                        }
                    }), e)
                })));
                return function(t, n, s) {
                    return e.apply(this, arguments)
                }
            } (),
            C = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t, n, a) {
                    var r, i, u, o, c, b, d, f, h;
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            if (r = [], !n) {
                                e.next = 37;
                                break
                            }
                            if (n = Object(l["m"])(n), -1 === n.indexOf(a) && (n = "".concat(a, "/").concat(n)), !t.files[n]) {
                                e.next = 37;
                                break
                            }
                            return e.next = 7,
                            T(t, n);
                        case 7:
                            i = e.sent,
                            u = i["json"]["ofd:Signatures"]["ofd:Signature"],
                            o = [],
                            o = o.concat(u),
                            c = Object(s["a"])(o),
                            e.prev = 12,
                            c.s();
                        case 14:
                            if ((b = c.n()).done) {
                                e.next = 29;
                                break
                            }
                            if (d = b.value, !d) {
                                e.next = 27;
                                break
                            }
                            return f = d["@_BaseLoc"],
                            h = d["@_ID"],
                            f = Object(l["m"])(f),
                            -1 === f.indexOf("Signs") && (f = "Signs/".concat(f)),
                            -1 === f.indexOf(a) && (f = "".concat(a, "/").concat(f)),
                            e.t0 = r,
                            e.next = 25,
                            _(t, f, h);
                        case 25:
                            e.t1 = e.sent,
                            e.t0.push.call(e.t0, e.t1);
                        case 27:
                            e.next = 14;
                            break;
                        case 29:
                            e.next = 34;
                            break;
                        case 31:
                            e.prev = 31,
                            e.t2 = e["catch"](12),
                            c.e(e.t2);
                        case 34:
                            return e.prev = 34,
                            c.f(),
                            e.finish(34);
                        case 37:
                            return e.abrupt("return", r);
                        case 38:
                        case "end":
                            return e.stop()
                        }
                    }), e, null, [[12, 31, 34, 37]])
                })));
                return function(t, n, s) {
                    return e.apply(this, arguments)
                }
            } (),
            B = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t, n) {
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            return e.abrupt("return", t.files[n].async("uint8array"));
                        case 1:
                        case "end":
                            return e.stop()
                        }
                    }), e)
                })));
                return function(t, n) {
                    return e.apply(this, arguments)
                }
            } (),
            _ = function() {
                var t = Object(r["a"])(regeneratorRuntime.mark((function t(n, s, a) {
                    var i, u, o, l, c;
                    return regeneratorRuntime.wrap((function(t) {
                        while (1) switch (t.prev = t.next) {
                        case 0:
                            return t.next = 2,
                            T(n, s);
                        case 2:
                            return i = t.sent,
                            u = i["json"]["ofd:Signature"]["ofd:SignedValue"],
                            u = u.toString().replace("/", ""),
                            n.files[u] || (u = "".concat(s.substring(0, s.lastIndexOf("/")), "/").concat(u)),
                            t.next = 8,
                            Object(b["b"])(n, u);
                        case 8:
                            return o = t.sent,
                            l = i["json"]["ofd:Signature"]["ofd:SignedInfo"]["ofd:References"]["@_CheckMethod"],
                            e.toBeChecked = new Map,
                            c = new Array,
                            i["json"]["ofd:Signature"]["ofd:SignedInfo"]["ofd:References"]["ofd:Reference"].forEach(function() {
                                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t) {
                                    var s, a, r;
                                    return regeneratorRuntime.wrap((function(e) {
                                        while (1) switch (e.prev = e.next) {
                                        case 0:
                                            if (0 != Object.keys(t).length && 0 != Object.keys(t["@_FileRef"]).length) {
                                                e.next = 2;
                                                break
                                            }
                                            return e.abrupt("return", !0);
                                        case 2:
                                            return s = t["ofd:CheckValue"],
                                            a = t["@_FileRef"].replace("/", ""),
                                            e.next = 6,
                                            B(n, a);
                                        case 6:
                                            r = e.sent,
                                            c.push({
                                                fileData: r,
                                                hashed: s,
                                                checkMethod: l
                                            });
                                        case 8:
                                        case "end":
                                            return e.stop()
                                        }
                                    }), e)
                                })));
                                return function(t) {
                                    return e.apply(this, arguments)
                                }
                            } ()),
                            e.toBeChecked.set(a, c),
                            t.abrupt("return", {
                                stampAnnot: i["json"]["ofd:Signature"]["ofd:SignedInfo"]["ofd:StampAnnot"],
                                sealObj: o,
                                signedInfo: {
                                    signatureID: a,
                                    VerifyRet: o.verifyRet,
                                    Provider: i["json"]["ofd:Signature"]["ofd:SignedInfo"]["ofd:Provider"],
                                    SignatureMethod: i["json"]["ofd:Signature"]["ofd:SignedInfo"]["ofd:SignatureMethod"],
                                    SignatureDateTime: i["json"]["ofd:Signature"]["ofd:SignedInfo"]["ofd:SignatureDateTime"]
                                }
                            });
                        case 15:
                        case "end":
                            return t.stop()
                        }
                    }), t)
                })));
                return function(e, n, s) {
                    return t.apply(this, arguments)
                }
            } (),
            D = function(e) {
                var t = this;
                return new Promise((function(n, s) {
                    i["a"].call(t, Object(r["a"])(regeneratorRuntime.mark((function t() {
                        return regeneratorRuntime.wrap((function(t) {
                            while (1) switch (t.prev = t.next) {
                            case 0:
                                return t.next = 2,
                                f(e.sealObj.ofdArray);
                            case 2:
                                return t.abrupt("return", t.sent);
                            case 3:
                            case "end":
                                return t.stop()
                            }
                        }), t)
                    }))), h, p).then((function(e) {
                        n(e)
                    })).
                    catch((function(e) {
                        s(e)
                    }))
                }))
            },
            T = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t, n) {
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            return e.abrupt("return", new Promise((function(e, s) {
                                t.files[n].async("string").then((function(t) {
                                    var n = {
                                        attributeNamePrefix: "@_",
                                        ignoreAttributes: !1,
                                        parseNodeValue: !1,
                                        trimValues: !1
                                    },
                                    s = d.parse(t, n),
                                    a = {
                                        xml: t,
                                        json: s
                                    };
                                    e(a)
                                }), (function(e) {
                                    s(e)
                                }))
                            })));
                        case 1:
                        case "end":
                            return e.stop()
                        }
                    }), e)
                })));
                return function(t, n) {
                    return e.apply(this, arguments)
                }
            } (),
            A = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t, n) {
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            return e.abrupt("return", new Promise((function(e, s) {
                                t.files[n].async("uint8array").then((function(t) {
                                    var n = new c["a"],
                                    s = n.parse(t);
                                    e({
                                        img: s,
                                        width: n.width,
                                        height: n.height,
                                        format: "gbig2"
                                    })
                                }), (function(e) {
                                    s(e)
                                }))
                            })));
                        case 1:
                        case "end":
                            return e.stop()
                        }
                    }), e)
                })));
                return function(t, n) {
                    return e.apply(this, arguments)
                }
            } (),
            R = function() {
                var e = Object(r["a"])(regeneratorRuntime.mark((function e(t, n) {
                    return regeneratorRuntime.wrap((function(e) {
                        while (1) switch (e.prev = e.next) {
                        case 0:
                            return e.abrupt("return", new Promise((function(e, s) {
                                t.files[n].async("base64").then((function(t) {
                                    var n = "data:image/png;base64," + t;
                                    e(n)
                                }), (function(e) {
                                    s(e)
                                }))
                            })));
                        case 1:
                        case "end":
                            return e.stop()
                        }
                    }), e)
                })));
                return function(t, n) {
                    return e.apply(this, arguments)
                }
            } ()
        }).call(this, n("c8ba"))
    },
    "6b33": function(e, t, n) {
        "use strict";
        n.d(t, "d", (function() {
            return a
        })),
        n.d(t, "b", (function() {
            return r
        })),
        n.d(t, "n", (function() {
            return l
        })),
        n.d(t, "o", (function() {
            return c
        })),
        n.d(t, "i", (function() {
            return b
        })),
        n.d(t, "f", (function() {
            return d
        })),
        n.d(t, "c", (function() {
            return h
        })),
        n.d(t, "m", (function() {
            return p
        })),
        n.d(t, "g", (function() {
            return v
        })),
        n.d(t, "h", (function() {
            return w
        })),
        n.d(t, "l", (function() {
            return O
        })),
        n.d(t, "k", (function() {
            return S
        })),
        n.d(t, "j", (function() {
            return k
        })),
        n.d(t, "e", (function() {
            return j
        })),
        n.d(t, "a", (function() {
            return I
        }));
        n("99af"),
        n("c975"),
        n("a15b"),
        n("baa5"),
        n("b64b"),
        n("d3b7"),
        n("ac1f"),
        n("25f0"),
        n("5319"),
        n("1276"),
        n("498a");
        var s = n("b85c"),
        a = function(e) {
            var t = e.split(" "),
            n = [],
            s = 0;
            while (s < t.length) {
                if ("M" === t[s] || "S" === t[s]) {
                    var a = {
                        type: "M",
                        x: parseFloat(t[s + 1]),
                        y: parseFloat(t[s + 2])
                    };
                    s += 3,
                    n.push(a)
                }
                if ("L" === t[s]) {
                    var r = {
                        type: "L",
                        x: parseFloat(t[s + 1]),
                        y: parseFloat(t[s + 2])
                    };
                    s += 3,
                    n.push(r)
                } else if ("C" === t[s]) {
                    var i = {
                        type: "C",
                        x: 0,
                        y: 0
                    };
                    n.push(i),
                    s++
                } else if ("B" === t[s]) {
                    var u = {
                        type: "B",
                        x1: parseFloat(t[s + 1]),
                        y1: parseFloat(t[s + 2]),
                        x2: parseFloat(t[s + 3]),
                        y2: parseFloat(t[s + 4]),
                        x3: parseFloat(t[s + 5]),
                        y3: parseFloat(t[s + 6])
                    };
                    s += 7,
                    n.push(u)
                } else s++
            }
            return n
        },
        r = function(e) {
            for (var t = [], n = 0; n < e.length; n++) {
                var s = e[n];
                if ("M" === s.type || "L" === s.type || "C" === s.type) {
                    var a = 0,
                    r = 0;
                    a = s.x,
                    r = s.y,
                    s.x = d(a),
                    s.y = d(r),
                    t.push(s)
                } else if ("B" === s.type) {
                    var i = s.x1,
                    u = s.y1,
                    o = s.x2,
                    l = s.y2,
                    c = s.x3,
                    b = s.y3,
                    f = {
                        type: "B",
                        x1: d(i),
                        y1: d(u),
                        x2: d(o),
                        y2: d(l),
                        x3: d(c),
                        y3: d(b)
                    };
                    t.push(f)
                }
            }
            return t
        },
        i = function(e, t) {
            return e * t / 25.4
        },
        u = 10,
        o = u,
        l = function(e) {
            u = e > 5 ? 5 : e
        },
        c = function(e) {
            o = e > 1 ? e: 1,
            o = o > u ? u: o
        },
        b = function() {
            return o
        },
        d = function(e) {
            return i(e, 25.4 * o)
        },
        f = function(e) {
            if ( - 1 === e.indexOf("g")) {
                var t, n = [],
                a = Object(s["a"])(e.split(" "));
                try {
                    for (a.s(); ! (t = a.n()).done;) {
                        var r = t.value;
                        n.push(parseFloat(r))
                    }
                } catch(p) {
                    a.e(p)
                } finally {
                    a.f()
                }
                return n
            }
            var i, u = e.split(" "),
            o = !1,
            l = !1,
            c = 0,
            b = [],
            d = Object(s["a"])(u);
            try {
                for (d.s(); ! (i = d.n()).done;) {
                    var f = i.value;
                    if ("g" === f) o = !0;
                    else {
                        if (!f || 0 == f.trim().length) continue;
                        if (o) c = parseInt(f),
                        l = !0,
                        o = !1;
                        else if (l) {
                            for (var h = 0; h < c; h++) b.push(parseFloat(f));
                            l = !1
                        } else b.push(parseFloat(f))
                    }
                }
            } catch(p) {
                d.e(p)
            } finally {
                d.f()
            }
            return b
        },
        h = function(e) {
            var t = 0,
            n = 0,
            a = [];
            if (!e) return a;
            var r, i = Object(s["a"])(e);
            try {
                for (i.s(); ! (r = i.n()).done;) {
                    var u = r.value;
                    if (u) {
                        t = parseFloat(u["@_X"]),
                        n = parseFloat(u["@_Y"]),
                        isNaN(t) && (t = 0),
                        isNaN(n) && (n = 0);
                        var o = [],
                        l = [];
                        u["@_DeltaX"] && u["@_DeltaX"].length > 0 && (o = f(u["@_DeltaX"])),
                        u["@_DeltaY"] && u["@_DeltaY"].length > 0 && (l = f(u["@_DeltaY"]));
                        var c = u["#text"];
                        if (c) {
                            c += "",
                            c = y(c),
                            c = c.replace(/&#x20;/g, " ");
                            for (var b = 0; b < c.length; b++) {
                                b > 0 && o.length > 0 && (t += o[b - 1]),
                                b > 0 && l.length > 0 && (n += l[b - 1]);
                                var h = c.substring(b, b + 1),
                                p = {
                                    x: d(t),
                                    y: d(n),
                                    text: h
                                };
                                a.push(p)
                            }
                        }
                    }
                }
            } catch(v) {
                i.e(v)
            } finally {
                i.f()
            }
            return a
        },
        p = function(e) {
            return e && 0 === e.indexOf("/") && (e = e.replace("/", "")),
            e
        },
        v = function(e) {
            return e || "string" === typeof e ? e.substring(e.lastIndexOf(".") + 1) : ""
        },
        g = /&\w+;|&#(\d+);/g,
        m = {
            "&lt;": "<",
            "&gt;": ">",
            "&amp;": "&",
            "&nbsp;": " ",
            "&quot;": '"',
            "&copy;": "",
            "&apos;": "'"
        },
        y = function(e) {
            return e = void 0 != e ? e: this.toString(),
            "string" != typeof e ? e: e.replace(g, (function(e, t) {
                var n = m[e];
                return void 0 == n && (n = isNaN(t) ? e: String.fromCharCode(160 == t ? 32 : t)),
                n
            }))
        },
        x = {
            "楷体": "楷体, KaiTi, Kai, simkai",
            kaiti: "楷体, KaiTi, Kai, simkai",
            Kai: "楷体, KaiTi, Kai",
            simsun: "SimSun, simsun, Songti SC",
            "宋体": "SimSun, simsun, Songti SC",
            "黑体": "SimHei, STHeiti, simhei",
            "仿宋": "FangSong, STFangsong, simfang",
            "小标宋体": "sSun",
            "方正小标宋_gbk": "sSun",
            "仿宋_gb2312": "FangSong, STFangsong, simfang",
            "楷体_gb2312": "楷体, KaiTi, Kai, simkai",
            couriernew: "Courier New",
            "courier new": "Courier New"
        },
        w = function(e) {
            x[e.toLowerCase()] && (e = x[e.toLowerCase()]);
            for (var t = 0,
            n = Object.keys(x); t < n.length; t++) {
                var s = n[t];
                if ( - 1 != e.toLowerCase().indexOf(s.toLowerCase())) return x[s]
            }
            return e
        },
        O = function(e) {
            if (e) {
                var t = e.split(" ");
                return {
                    x: parseFloat(t[0]),
                    y: parseFloat(t[1]),
                    w: parseFloat(t[2]),
                    h: parseFloat(t[3])
                }
            }
            return null
        },
        S = function(e) {
            var t = e.split(" ");
            return t
        },
        k = function(e) {
            if (e) {
                if ( - 1 !== e.indexOf("#")) return e = e.replace(/#/g, ""),
                e = e.replace(/ /g, ""),
                e = "#" + e.toString(),
                e;
                var t = e.split(" ");
                return "rgb(".concat(t[0], ", ").concat(t[1], ", ").concat(t[2], ")")
            }
            return "rgb(0, 0, 0)"
        },
        j = function(e) {
            return {
                x: d(e.x),
                y: d(e.y),
                w: d(e.w),
                h: d(e.h)
            }
        },
        I = function(e) {
            for (var t = [], n = 0, s = 0; s < 2 * e.length; s += 2) t[s >>> 3] |= parseInt(e[n], 10) << 24 - s % 8 * 4,
            n++;
            for (var a = [], r = 0; r < e.length; r++) {
                var i = t[r >>> 2] >>> 24 - r % 4 * 8 & 255;
                a.push((i >>> 4).toString(16)),
                a.push((15 & i).toString(16))
            }
            return a.join("")
        }
    },
    "73fd": function(e, t, n) {
        "use strict";
        n.d(t, "a", (function() {
            return w
        }));
        n("99af"),
        n("d3b7"),
        n("fd87"),
        n("143c"),
        n("5cc6"),
        n("8a59"),
        n("84c3"),
        n("fb2c"),
        n("9a8c"),
        n("a975"),
        n("735e"),
        n("c1ac"),
        n("d139"),
        n("3a7b"),
        n("d5d6"),
        n("82f8"),
        n("e91f"),
        n("60bd"),
        n("5f96"),
        n("3280"),
        n("3fcc"),
        n("ca91"),
        n("25a1"),
        n("cd26"),
        n("3c5d"),
        n("2954"),
        n("649e"),
        n("219c"),
        n("170b"),
        n("b39a"),
        n("72f7");
        var s = n("d4ec"),
        a = n("262e"),
        r = n("2caf"),
        i = (n("a623"), n("a15b"), n("fb6a"), n("b0c0"), n("a9e3"), n("8ba4"), n("ac1f"), n("25f0"), n("3ca3"), n("4d90"), n("5319"), n("ddb0"), n("2b3d"), n("bee2")),
        u = (n("53ca"), n("7f3b"), {
            ERRORS: 0,
            WARNINGS: 1,
            INFOS: 5
        }),
        o = u.WARNINGS;
        function l(e) {
            o >= u.INFOS && console.log("Info: ".concat(e))
        }
        function c(e) {
            throw new Error(e)
        }
        function b(e, t, n) {
            return Object.defineProperty(e, t, {
                value: n,
                enumerable: !0,
                configurable: !0,
                writable: !1
            }),
            n
        }
        var d = function() {
            function e(t) {
                this.constructor === e && c("Cannot initialize BaseException."),
                this.message = t,
                this.name = this.constructor.name
            }
            return e.prototype = new Error,
            e.constructor = e,
            e
        } (); (function() {
            var e = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
        })(),
        n("90d7");
        function f(e) {
            return e <= 0 ? 0 : Math.ceil(Math.log2(e))
        }
        function h(e, t) {
            return e[t] << 24 >> 24
        }
        function p(e, t) {
            return e[t] << 8 | e[t + 1]
        }
        function v(e, t) {
            return (e[t] << 24 | e[t + 1] << 16 | e[t + 2] << 8 | e[t + 3]) >>> 0
        }
        var g = [{
            qe: 22017,
            nmps: 1,
            nlps: 1,
            switchFlag: 1
        },
        {
            qe: 13313,
            nmps: 2,
            nlps: 6,
            switchFlag: 0
        },
        {
            qe: 6145,
            nmps: 3,
            nlps: 9,
            switchFlag: 0
        },
        {
            qe: 2753,
            nmps: 4,
            nlps: 12,
            switchFlag: 0
        },
        {
            qe: 1313,
            nmps: 5,
            nlps: 29,
            switchFlag: 0
        },
        {
            qe: 545,
            nmps: 38,
            nlps: 33,
            switchFlag: 0
        },
        {
            qe: 22017,
            nmps: 7,
            nlps: 6,
            switchFlag: 1
        },
        {
            qe: 21505,
            nmps: 8,
            nlps: 14,
            switchFlag: 0
        },
        {
            qe: 18433,
            nmps: 9,
            nlps: 14,
            switchFlag: 0
        },
        {
            qe: 14337,
            nmps: 10,
            nlps: 14,
            switchFlag: 0
        },
        {
            qe: 12289,
            nmps: 11,
            nlps: 17,
            switchFlag: 0
        },
        {
            qe: 9217,
            nmps: 12,
            nlps: 18,
            switchFlag: 0
        },
        {
            qe: 7169,
            nmps: 13,
            nlps: 20,
            switchFlag: 0
        },
        {
            qe: 5633,
            nmps: 29,
            nlps: 21,
            switchFlag: 0
        },
        {
            qe: 22017,
            nmps: 15,
            nlps: 14,
            switchFlag: 1
        },
        {
            qe: 21505,
            nmps: 16,
            nlps: 14,
            switchFlag: 0
        },
        {
            qe: 20737,
            nmps: 17,
            nlps: 15,
            switchFlag: 0
        },
        {
            qe: 18433,
            nmps: 18,
            nlps: 16,
            switchFlag: 0
        },
        {
            qe: 14337,
            nmps: 19,
            nlps: 17,
            switchFlag: 0
        },
        {
            qe: 13313,
            nmps: 20,
            nlps: 18,
            switchFlag: 0
        },
        {
            qe: 12289,
            nmps: 21,
            nlps: 19,
            switchFlag: 0
        },
        {
            qe: 10241,
            nmps: 22,
            nlps: 19,
            switchFlag: 0
        },
        {
            qe: 9217,
            nmps: 23,
            nlps: 20,
            switchFlag: 0
        },
        {
            qe: 8705,
            nmps: 24,
            nlps: 21,
            switchFlag: 0
        },
        {
            qe: 7169,
            nmps: 25,
            nlps: 22,
            switchFlag: 0
        },
        {
            qe: 6145,
            nmps: 26,
            nlps: 23,
            switchFlag: 0
        },
        {
            qe: 5633,
            nmps: 27,
            nlps: 24,
            switchFlag: 0
        },
        {
            qe: 5121,
            nmps: 28,
            nlps: 25,
            switchFlag: 0
        },
        {
            qe: 4609,
            nmps: 29,
            nlps: 26,
            switchFlag: 0
        },
        {
            qe: 4353,
            nmps: 30,
            nlps: 27,
            switchFlag: 0
        },
        {
            qe: 2753,
            nmps: 31,
            nlps: 28,
            switchFlag: 0
        },
        {
            qe: 2497,
            nmps: 32,
            nlps: 29,
            switchFlag: 0
        },
        {
            qe: 2209,
            nmps: 33,
            nlps: 30,
            switchFlag: 0
        },
        {
            qe: 1313,
            nmps: 34,
            nlps: 31,
            switchFlag: 0
        },
        {
            qe: 1089,
            nmps: 35,
            nlps: 32,
            switchFlag: 0
        },
        {
            qe: 673,
            nmps: 36,
            nlps: 33,
            switchFlag: 0
        },
        {
            qe: 545,
            nmps: 37,
            nlps: 34,
            switchFlag: 0
        },
        {
            qe: 321,
            nmps: 38,
            nlps: 35,
            switchFlag: 0
        },
        {
            qe: 273,
            nmps: 39,
            nlps: 36,
            switchFlag: 0
        },
        {
            qe: 133,
            nmps: 40,
            nlps: 37,
            switchFlag: 0
        },
        {
            qe: 73,
            nmps: 41,
            nlps: 38,
            switchFlag: 0
        },
        {
            qe: 37,
            nmps: 42,
            nlps: 39,
            switchFlag: 0
        },
        {
            qe: 21,
            nmps: 43,
            nlps: 40,
            switchFlag: 0
        },
        {
            qe: 9,
            nmps: 44,
            nlps: 41,
            switchFlag: 0
        },
        {
            qe: 5,
            nmps: 45,
            nlps: 42,
            switchFlag: 0
        },
        {
            qe: 1,
            nmps: 45,
            nlps: 43,
            switchFlag: 0
        },
        {
            qe: 22017,
            nmps: 46,
            nlps: 46,
            switchFlag: 0
        }],
        m = function() {
            function e(t, n, a) {
                Object(s["a"])(this, e),
                this.data = t,
                this.bp = n,
                this.dataEnd = a,
                this.chigh = t[n],
                this.clow = 0,
                this.byteIn(),
                this.chigh = this.chigh << 7 & 65535 | this.clow >> 9 & 127,
                this.clow = this.clow << 7 & 65535,
                this.ct -= 7,
                this.a = 32768
            }
            return Object(i["a"])(e, [{
                key: "byteIn",
                value: function() {
                    var e = this.data,
                    t = this.bp;
                    255 === e[t] ? e[t + 1] > 143 ? (this.clow += 65280, this.ct = 8) : (t++, this.clow += e[t] << 9, this.ct = 7, this.bp = t) : (t++, this.clow += t < this.dataEnd ? e[t] << 8 : 65280, this.ct = 8, this.bp = t),
                    this.clow > 65535 && (this.chigh += this.clow >> 16, this.clow &= 65535)
                }
            },
            {
                key: "readBit",
                value: function(e, t) {
                    var n, s = e[t] >> 1,
                    a = 1 & e[t],
                    r = g[s],
                    i = r.qe,
                    u = this.a - i;
                    if (this.chigh < i) u < i ? (u = i, n = a, s = r.nmps) : (u = i, n = 1 ^ a, 1 === r.switchFlag && (a = n), s = r.nlps);
                    else {
                        if (this.chigh -= i, 0 !== (32768 & u)) return this.a = u,
                        a;
                        u < i ? (n = 1 ^ a, 1 === r.switchFlag && (a = n), s = r.nlps) : (n = a, s = r.nmps)
                    }
                    do {
                        0 === this.ct && this.byteIn(), u <<= 1, this.chigh = this.chigh << 1 & 65535 | this.clow >> 15 & 1, this.clow = this.clow << 1 & 65535, this.ct--
                    } while ( 0 === ( 32768 & u ));
                    return this.a = u,
                    e[t] = s << 1 | a,
                    n
                }
            }]),
            e
        } (),
        y = function() {
            var e = -2,
            t = -1,
            n = 0,
            s = 1,
            a = 2,
            r = 3,
            i = 4,
            u = 5,
            o = 6,
            c = 7,
            b = 8,
            d = [[ - 1, -1], [ - 1, -1], [7, b], [7, c], [6, o], [6, o], [6, u], [6, u], [4, n], [4, n], [4, n], [4, n], [4, n], [4, n], [4, n], [4, n], [3, s], [3, s], [3, s], [3, s], [3, s], [3, s], [3, s], [3, s], [3, s], [3, s], [3, s], [3, s], [3, s], [3, s], [3, s], [3, s], [3, i], [3, i], [3, i], [3, i], [3, i], [3, i], [3, i], [3, i], [3, i], [3, i], [3, i], [3, i], [3, i], [3, i], [3, i], [3, i], [3, r], [3, r], [3, r], [3, r], [3, r], [3, r], [3, r], [3, r], [3, r], [3, r], [3, r], [3, r], [3, r], [3, r], [3, r], [3, r], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a], [1, a]],
            f = [[ - 1, -1], [12, e], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [11, 1792], [11, 1792], [12, 1984], [12, 2048], [12, 2112], [12, 2176], [12, 2240], [12, 2304], [11, 1856], [11, 1856], [11, 1920], [11, 1920], [12, 2368], [12, 2432], [12, 2496], [12, 2560]],
            h = [[ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [8, 29], [8, 29], [8, 30], [8, 30], [8, 45], [8, 45], [8, 46], [8, 46], [7, 22], [7, 22], [7, 22], [7, 22], [7, 23], [7, 23], [7, 23], [7, 23], [8, 47], [8, 47], [8, 48], [8, 48], [6, 13], [6, 13], [6, 13], [6, 13], [6, 13], [6, 13], [6, 13], [6, 13], [7, 20], [7, 20], [7, 20], [7, 20], [8, 33], [8, 33], [8, 34], [8, 34], [8, 35], [8, 35], [8, 36], [8, 36], [8, 37], [8, 37], [8, 38], [8, 38], [7, 19], [7, 19], [7, 19], [7, 19], [8, 31], [8, 31], [8, 32], [8, 32], [6, 1], [6, 1], [6, 1], [6, 1], [6, 1], [6, 1], [6, 1], [6, 1], [6, 12], [6, 12], [6, 12], [6, 12], [6, 12], [6, 12], [6, 12], [6, 12], [8, 53], [8, 53], [8, 54], [8, 54], [7, 26], [7, 26], [7, 26], [7, 26], [8, 39], [8, 39], [8, 40], [8, 40], [8, 41], [8, 41], [8, 42], [8, 42], [8, 43], [8, 43], [8, 44], [8, 44], [7, 21], [7, 21], [7, 21], [7, 21], [7, 28], [7, 28], [7, 28], [7, 28], [8, 61], [8, 61], [8, 62], [8, 62], [8, 63], [8, 63], [8, 0], [8, 0], [8, 320], [8, 320], [8, 384], [8, 384], [5, 10], [5, 10], [5, 10], [5, 10], [5, 10], [5, 10], [5, 10], [5, 10], [5, 10], [5, 10], [5, 10], [5, 10], [5, 10], [5, 10], [5, 10], [5, 10], [5, 11], [5, 11], [5, 11], [5, 11], [5, 11], [5, 11], [5, 11], [5, 11], [5, 11], [5, 11], [5, 11], [5, 11], [5, 11], [5, 11], [5, 11], [5, 11], [7, 27], [7, 27], [7, 27], [7, 27], [8, 59], [8, 59], [8, 60], [8, 60], [9, 1472], [9, 1536], [9, 1600], [9, 1728], [7, 18], [7, 18], [7, 18], [7, 18], [7, 24], [7, 24], [7, 24], [7, 24], [8, 49], [8, 49], [8, 50], [8, 50], [8, 51], [8, 51], [8, 52], [8, 52], [7, 25], [7, 25], [7, 25], [7, 25], [8, 55], [8, 55], [8, 56], [8, 56], [8, 57], [8, 57], [8, 58], [8, 58], [6, 192], [6, 192], [6, 192], [6, 192], [6, 192], [6, 192], [6, 192], [6, 192], [6, 1664], [6, 1664], [6, 1664], [6, 1664], [6, 1664], [6, 1664], [6, 1664], [6, 1664], [8, 448], [8, 448], [8, 512], [8, 512], [9, 704], [9, 768], [8, 640], [8, 640], [8, 576], [8, 576], [9, 832], [9, 896], [9, 960], [9, 1024], [9, 1088], [9, 1152], [9, 1216], [9, 1280], [9, 1344], [9, 1408], [7, 256], [7, 256], [7, 256], [7, 256], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 2], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [4, 3], [5, 128], [5, 128], [5, 128], [5, 128], [5, 128], [5, 128], [5, 128], [5, 128], [5, 128], [5, 128], [5, 128], [5, 128], [5, 128], [5, 128], [5, 128], [5, 128], [5, 8], [5, 8], [5, 8], [5, 8], [5, 8], [5, 8], [5, 8], [5, 8], [5, 8], [5, 8], [5, 8], [5, 8], [5, 8], [5, 8], [5, 8], [5, 8], [5, 9], [5, 9], [5, 9], [5, 9], [5, 9], [5, 9], [5, 9], [5, 9], [5, 9], [5, 9], [5, 9], [5, 9], [5, 9], [5, 9], [5, 9], [5, 9], [6, 16], [6, 16], [6, 16], [6, 16], [6, 16], [6, 16], [6, 16], [6, 16], [6, 17], [6, 17], [6, 17], [6, 17], [6, 17], [6, 17], [6, 17], [6, 17], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 4], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [6, 14], [6, 14], [6, 14], [6, 14], [6, 14], [6, 14], [6, 14], [6, 14], [6, 15], [6, 15], [6, 15], [6, 15], [6, 15], [6, 15], [6, 15], [6, 15], [5, 64], [5, 64], [5, 64], [5, 64], [5, 64], [5, 64], [5, 64], [5, 64], [5, 64], [5, 64], [5, 64], [5, 64], [5, 64], [5, 64], [5, 64], [5, 64], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 6], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7], [4, 7]],
            p = [[ - 1, -1], [ - 1, -1], [12, e], [12, e], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [11, 1792], [11, 1792], [11, 1792], [11, 1792], [12, 1984], [12, 1984], [12, 2048], [12, 2048], [12, 2112], [12, 2112], [12, 2176], [12, 2176], [12, 2240], [12, 2240], [12, 2304], [12, 2304], [11, 1856], [11, 1856], [11, 1856], [11, 1856], [11, 1920], [11, 1920], [11, 1920], [11, 1920], [12, 2368], [12, 2368], [12, 2432], [12, 2432], [12, 2496], [12, 2496], [12, 2560], [12, 2560], [10, 18], [10, 18], [10, 18], [10, 18], [10, 18], [10, 18], [10, 18], [10, 18], [12, 52], [12, 52], [13, 640], [13, 704], [13, 768], [13, 832], [12, 55], [12, 55], [12, 56], [12, 56], [13, 1280], [13, 1344], [13, 1408], [13, 1472], [12, 59], [12, 59], [12, 60], [12, 60], [13, 1536], [13, 1600], [11, 24], [11, 24], [11, 24], [11, 24], [11, 25], [11, 25], [11, 25], [11, 25], [13, 1664], [13, 1728], [12, 320], [12, 320], [12, 384], [12, 384], [12, 448], [12, 448], [13, 512], [13, 576], [12, 53], [12, 53], [12, 54], [12, 54], [13, 896], [13, 960], [13, 1024], [13, 1088], [13, 1152], [13, 1216], [10, 64], [10, 64], [10, 64], [10, 64], [10, 64], [10, 64], [10, 64], [10, 64]],
            v = [[8, 13], [8, 13], [8, 13], [8, 13], [8, 13], [8, 13], [8, 13], [8, 13], [8, 13], [8, 13], [8, 13], [8, 13], [8, 13], [8, 13], [8, 13], [8, 13], [11, 23], [11, 23], [12, 50], [12, 51], [12, 44], [12, 45], [12, 46], [12, 47], [12, 57], [12, 58], [12, 61], [12, 256], [10, 16], [10, 16], [10, 16], [10, 16], [10, 17], [10, 17], [10, 17], [10, 17], [12, 48], [12, 49], [12, 62], [12, 63], [12, 30], [12, 31], [12, 32], [12, 33], [12, 40], [12, 41], [11, 22], [11, 22], [8, 14], [8, 14], [8, 14], [8, 14], [8, 14], [8, 14], [8, 14], [8, 14], [8, 14], [8, 14], [8, 14], [8, 14], [8, 14], [8, 14], [8, 14], [8, 14], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 10], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [7, 11], [9, 15], [9, 15], [9, 15], [9, 15], [9, 15], [9, 15], [9, 15], [9, 15], [12, 128], [12, 192], [12, 26], [12, 27], [12, 28], [12, 29], [11, 19], [11, 19], [11, 20], [11, 20], [12, 34], [12, 35], [12, 36], [12, 37], [12, 38], [12, 39], [11, 21], [11, 21], [12, 42], [12, 43], [10, 0], [10, 0], [10, 0], [10, 0], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12], [7, 12]],
            g = [[ - 1, -1], [ - 1, -1], [ - 1, -1], [ - 1, -1], [6, 9], [6, 8], [5, 7], [5, 7], [4, 6], [4, 6], [4, 6], [4, 6], [4, 5], [4, 5], [4, 5], [4, 5], [3, 1], [3, 1], [3, 1], [3, 1], [3, 1], [3, 1], [3, 1], [3, 1], [3, 4], [3, 4], [3, 4], [3, 4], [3, 4], [3, 4], [3, 4], [3, 4], [2, 3], [2, 3], [2, 3], [2, 3], [2, 3], [2, 3], [2, 3], [2, 3], [2, 3], [2, 3], [2, 3], [2, 3], [2, 3], [2, 3], [2, 3], [2, 3], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2], [2, 2]];
            function m(e) {
                var t = arguments.length > 1 && void 0 !== arguments[1] ? arguments[1] : {};
                if (!e || "function" !== typeof e.next) throw new Error('CCITTFaxDecoder - invalid "source" parameter.');
                this.source = e,
                this.eof = !1,
                this.encoding = t.K || 0,
                this.eoline = t.EndOfLine || !1,
                this.byteAlign = t.EncodedByteAlign || !1,
                this.columns = t.Columns || 1728,
                this.rows = t.Rows || 0;
                var n, s = t.EndOfBlock;
                null !== s && void 0 !== s || (s = !0),
                this.eoblock = s,
                this.black = t.BlackIs1 || !1,
                this.codingLine = new Uint32Array(this.columns + 1),
                this.refLine = new Uint32Array(this.columns + 2),
                this.codingLine[0] = this.columns,
                this.codingPos = 0,
                this.row = 0,
                this.nextLine2D = this.encoding < 0,
                this.inputBits = 0,
                this.inputBuf = 0,
                this.outputBits = 0,
                this.rowsDone = !1;
                while (0 === (n = this._lookBits(12))) this._eatBits(1);
                1 === n && this._eatBits(12),
                this.encoding > 0 && (this.nextLine2D = !this._lookBits(1), this._eatBits(1))
            }
            return m.prototype = {
                readNextChar: function() {
                    if (this.eof) return - 1;
                    var e, d, f, h, p, v = this.refLine,
                    g = this.codingLine,
                    m = this.columns;
                    if (0 === this.outputBits) {
                        if (this.rowsDone && (this.eof = !0), this.eof) return - 1;
                        var y, x, w;
                        if (this.err = !1, this.nextLine2D) {
                            for (h = 0; g[h] < m; ++h) v[h] = g[h];
                            v[h++] = m,
                            v[h] = m,
                            g[0] = 0,
                            this.codingPos = 0,
                            e = 0,
                            d = 0;
                            while (g[this.codingPos] < m) switch (y = this._getTwoDimCode(), y) {
                            case n:
                                this._addPixels(v[e + 1], d),
                                v[e + 1] < m && (e += 2);
                                break;
                            case s:
                                if (y = x = 0, d) {
                                    do {
                                        y += w = this._getBlackCode()
                                    } while ( w >= 64 );
                                    do {
                                        x += w = this._getWhiteCode()
                                    } while ( w >= 64 )
                                } else {
                                    do {
                                        y += w = this._getWhiteCode()
                                    } while ( w >= 64 );
                                    do {
                                        x += w = this._getBlackCode()
                                    } while ( w >= 64 )
                                }
                                this._addPixels(g[this.codingPos] + y, d),
                                g[this.codingPos] < m && this._addPixels(g[this.codingPos] + x, 1 ^ d);
                                while (v[e] <= g[this.codingPos] && v[e] < m) e += 2;
                                break;
                            case c:
                                if (this._addPixels(v[e] + 3, d), d ^= 1, g[this.codingPos] < m) {++e;
                                    while (v[e] <= g[this.codingPos] && v[e] < m) e += 2
                                }
                                break;
                            case u:
                                if (this._addPixels(v[e] + 2, d), d ^= 1, g[this.codingPos] < m) {++e;
                                    while (v[e] <= g[this.codingPos] && v[e] < m) e += 2
                                }
                                break;
                            case r:
                                if (this._addPixels(v[e] + 1, d), d ^= 1, g[this.codingPos] < m) {++e;
                                    while (v[e] <= g[this.codingPos] && v[e] < m) e += 2
                                }
                                break;
                            case a:
                                if (this._addPixels(v[e], d), d ^= 1, g[this.codingPos] < m) {++e;
                                    while (v[e] <= g[this.codingPos] && v[e] < m) e += 2
                                }
                                break;
                            case b:
                                if (this._addPixelsNeg(v[e] - 3, d), d ^= 1, g[this.codingPos] < m) {
                                    e > 0 ? --e: ++e;
                                    while (v[e] <= g[this.codingPos] && v[e] < m) e += 2
                                }
                                break;
                            case o:
                                if (this._addPixelsNeg(v[e] - 2, d), d ^= 1, g[this.codingPos] < m) {
                                    e > 0 ? --e: ++e;
                                    while (v[e] <= g[this.codingPos] && v[e] < m) e += 2
                                }
                                break;
                            case i:
                                if (this._addPixelsNeg(v[e] - 1, d), d ^= 1, g[this.codingPos] < m) {
                                    e > 0 ? --e: ++e;
                                    while (v[e] <= g[this.codingPos] && v[e] < m) e += 2
                                }
                                break;
                            case t:
                                this._addPixels(m, 0),
                                this.eof = !0;
                                break;
                            default:
                                l("bad 2d code"),
                                this._addPixels(m, 0),
                                this.err = !0
                            }
                        } else {
                            g[0] = 0,
                            this.codingPos = 0,
                            d = 0;
                            while (g[this.codingPos] < m) {
                                if (y = 0, d) do {
                                    y += w = this._getBlackCode()
                                } while ( w >= 64 );
                                else do {
                                    y += w = this._getWhiteCode()
                                } while ( w >= 64 );
                                this._addPixels(g[this.codingPos] + y, d),
                                d ^= 1
                            }
                        }
                        var O = !1;
                        if (this.byteAlign && (this.inputBits &= -8), this.eoblock || this.row !== this.rows - 1) {
                            if (y = this._lookBits(12), this.eoline) while (y !== t && 1 !== y) this._eatBits(1),
                            y = this._lookBits(12);
                            else while (0 === y) this._eatBits(1),
                            y = this._lookBits(12);
                            1 === y ? (this._eatBits(12), O = !0) : y === t && (this.eof = !0)
                        } else this.rowsDone = !0;
                        if (!this.eof && this.encoding > 0 && !this.rowsDone && (this.nextLine2D = !this._lookBits(1), this._eatBits(1)), this.eoblock && O && this.byteAlign) {
                            if (y = this._lookBits(12), 1 === y) {
                                if (this._eatBits(12), this.encoding > 0 && (this._lookBits(1), this._eatBits(1)), this.encoding >= 0) for (h = 0; h < 4; ++h) y = this._lookBits(12),
                                1 !== y && l("bad rtc code: " + y),
                                this._eatBits(12),
                                this.encoding > 0 && (this._lookBits(1), this._eatBits(1));
                                this.eof = !0
                            }
                        } else if (this.err && this.eoline) {
                            while (1) {
                                if (y = this._lookBits(13), y === t) return this.eof = !0,
                                -1;
                                if (y >> 1 === 1) break;
                                this._eatBits(1)
                            }
                            this._eatBits(12),
                            this.encoding > 0 && (this._eatBits(1), this.nextLine2D = !(1 & y))
                        }
                        g[0] > 0 ? this.outputBits = g[this.codingPos = 0] : this.outputBits = g[this.codingPos = 1],
                        this.row++
                    }
                    if (this.outputBits >= 8) p = 1 & this.codingPos ? 0 : 255,
                    this.outputBits -= 8,
                    0 === this.outputBits && g[this.codingPos] < m && (this.codingPos++, this.outputBits = g[this.codingPos] - g[this.codingPos - 1]);
                    else {
                        f = 8,
                        p = 0;
                        do {
                            this.outputBits > f ? (p <<= f, 1 & this.codingPos || (p |= 255 >> 8 - f), this.outputBits -= f, f = 0) : (p <<= this.outputBits, 1 & this.codingPos || (p |= 255 >> 8 - this.outputBits), f -= this.outputBits, this.outputBits = 0, g[this.codingPos] < m ? (this.codingPos++, this.outputBits = g[this.codingPos] - g[this.codingPos - 1]) : f > 0 && (p <<= f, f = 0))
                        } while ( f )
                    }
                    return this.black && (p ^= 255),
                    p
                },
                _addPixels: function(e, t) {
                    var n = this.codingLine,
                    s = this.codingPos;
                    e > n[s] && (e > this.columns && (l("row is wrong length"), this.err = !0, e = this.columns), 1 & s ^ t && ++s, n[s] = e),
                    this.codingPos = s
                },
                _addPixelsNeg: function(e, t) {
                    var n = this.codingLine,
                    s = this.codingPos;
                    if (e > n[s]) e > this.columns && (l("row is wrong length"), this.err = !0, e = this.columns),
                    1 & s ^ t && ++s,
                    n[s] = e;
                    else if (e < n[s]) {
                        e < 0 && (l("invalid code"), this.err = !0, e = 0);
                        while (s > 0 && e < n[s - 1])--s;
                        n[s] = e
                    }
                    this.codingPos = s
                },
                _findTableCode: function(e, n, s, a) {
                    for (var r = a || 0,
                    i = e; i <= n; ++i) {
                        var u = this._lookBits(i);
                        if (u === t) return [!0, 1, !1];
                        if (i < n && (u <<= n - i), !r || u >= r) {
                            var o = s[u - r];
                            if (o[0] === i) return this._eatBits(i),
                            [!0, o[1], !0]
                        }
                    }
                    return [!1, 0, !1]
                },
                _getTwoDimCode: function() {
                    var e, n = 0;
                    if (this.eoblock) {
                        if (n = this._lookBits(7), e = d[n], e && e[0] > 0) return this._eatBits(e[0]),
                        e[1]
                    } else {
                        var s = this._findTableCode(1, 7, d);
                        if (s[0] && s[2]) return s[1]
                    }
                    return l("Bad two dim code"),
                    t
                },
                _getWhiteCode: function() {
                    var e, n = 0;
                    if (this.eoblock) {
                        if (n = this._lookBits(12), n === t) return 1;
                        if (e = n >> 5 === 0 ? f[n] : h[n >> 3], e[0] > 0) return this._eatBits(e[0]),
                        e[1]
                    } else {
                        var s = this._findTableCode(1, 9, h);
                        if (s[0]) return s[1];
                        if (s = this._findTableCode(11, 12, f), s[0]) return s[1]
                    }
                    return l("bad white code"),
                    this._eatBits(1),
                    1
                },
                _getBlackCode: function() {
                    var e, n;
                    if (this.eoblock) {
                        if (e = this._lookBits(13), e === t) return 1;
                        if (n = e >> 7 === 0 ? p[e] : e >> 9 === 0 && e >> 7 !== 0 ? v[(e >> 1) - 64] : g[e >> 7], n[0] > 0) return this._eatBits(n[0]),
                        n[1]
                    } else {
                        var s = this._findTableCode(2, 6, g);
                        if (s[0]) return s[1];
                        if (s = this._findTableCode(7, 12, v, 64), s[0]) return s[1];
                        if (s = this._findTableCode(10, 13, p), s[0]) return s[1]
                    }
                    return l("bad black code"),
                    this._eatBits(1),
                    1
                },
                _lookBits: function(e) {
                    var n;
                    while (this.inputBits < e) {
                        if ( - 1 === (n = this.source.next())) return 0 === this.inputBits ? t: this.inputBuf << e - this.inputBits & 65535 >> 16 - e;
                        this.inputBuf = this.inputBuf << 8 | n,
                        this.inputBits += 8
                    }
                    return this.inputBuf >> this.inputBits - e & 65535 >> 16 - e
                },
                _eatBits: function(e) { (this.inputBits -= e) < 0 && (this.inputBits = 0)
                }
            },
            m
        } (),
        x = function(e) {
            Object(a["a"])(n, e);
            var t = Object(r["a"])(n);
            function n(e) {
                return Object(s["a"])(this, n),
                t.call(this, "JBIG2 error: ".concat(e))
            }
            return n
        } (d),
        w = function() {
            function e() {}
            function t(e, t, n) {
                this.data = e,
                this.start = t,
                this.end = n
            }
            function n(e, t, n) {
                var s = e.getContexts(t),
                a = 1;
                function r(e) {
                    for (var t = 0,
                    r = 0; r < e; r++) {
                        var i = n.readBit(s, a);
                        a = a < 256 ? a << 1 | i: 511 & (a << 1 | i) | 256,
                        t = t << 1 | i
                    }
                    return t >>> 0
                }
                var i = r(1),
                u = r(1) ? r(1) ? r(1) ? r(1) ? r(1) ? r(32) + 4436 : r(12) + 340 : r(8) + 84 : r(6) + 20 : r(4) + 4 : r(2);
                return 0 === i ? u: u > 0 ? -u: null
            }
            function s(e, t, n) {
                for (var s = e.getContexts("IAID"), a = 1, r = 0; r < n; r++) {
                    var i = t.readBit(s, a);
                    a = a << 1 | i
                }
                return n < 31 ? a & (1 << n) - 1 : 2147483647 & a
            }
            e.prototype = {
                getContexts: function(e) {
                    return e in this ? this[e] : this[e] = new Int8Array(65536)
                }
            },
            t.prototype = {
                get decoder() {
                    var e = new m(this.data, this.start, this.end);
                    return b(this, "decoder", e)
                },
                get contextCache() {
                    var t = new e;
                    return b(this, "contextCache", t)
                }
            };
            var a = ["SymbolDictionary", null, null, null, "IntermediateTextRegion", null, "ImmediateTextRegion", "ImmediateLosslessTextRegion", null, null, null, null, null, null, null, null, "PatternDictionary", null, null, null, "IntermediateHalftoneRegion", null, "ImmediateHalftoneRegion", "ImmediateLosslessHalftoneRegion", null, null, null, null, null, null, null, null, null, null, null, null, "IntermediateGenericRegion", null, "ImmediateGenericRegion", "ImmediateLosslessGenericRegion", "IntermediateGenericRefinementRegion", null, "ImmediateGenericRefinementRegion", "ImmediateLosslessGenericRefinementRegion", null, null, null, null, "PageInformation", "EndOfPage", "EndOfStripe", "EndOfFile", "Profiles", "Tables", null, null, null, null, null, null, null, null, "Extension"],
            r = [[{
                x: -1,
                y: -2
            },
            {
                x: 0,
                y: -2
            },
            {
                x: 1,
                y: -2
            },
            {
                x: -2,
                y: -1
            },
            {
                x: -1,
                y: -1
            },
            {
                x: 0,
                y: -1
            },
            {
                x: 1,
                y: -1
            },
            {
                x: 2,
                y: -1
            },
            {
                x: -4,
                y: 0
            },
            {
                x: -3,
                y: 0
            },
            {
                x: -2,
                y: 0
            },
            {
                x: -1,
                y: 0
            }], [{
                x: -1,
                y: -2
            },
            {
                x: 0,
                y: -2
            },
            {
                x: 1,
                y: -2
            },
            {
                x: 2,
                y: -2
            },
            {
                x: -2,
                y: -1
            },
            {
                x: -1,
                y: -1
            },
            {
                x: 0,
                y: -1
            },
            {
                x: 1,
                y: -1
            },
            {
                x: 2,
                y: -1
            },
            {
                x: -3,
                y: 0
            },
            {
                x: -2,
                y: 0
            },
            {
                x: -1,
                y: 0
            }], [{
                x: -1,
                y: -2
            },
            {
                x: 0,
                y: -2
            },
            {
                x: 1,
                y: -2
            },
            {
                x: -2,
                y: -1
            },
            {
                x: -1,
                y: -1
            },
            {
                x: 0,
                y: -1
            },
            {
                x: 1,
                y: -1
            },
            {
                x: -2,
                y: 0
            },
            {
                x: -1,
                y: 0
            }], [{
                x: -3,
                y: -1
            },
            {
                x: -2,
                y: -1
            },
            {
                x: -1,
                y: -1
            },
            {
                x: 0,
                y: -1
            },
            {
                x: 1,
                y: -1
            },
            {
                x: -4,
                y: 0
            },
            {
                x: -3,
                y: 0
            },
            {
                x: -2,
                y: 0
            },
            {
                x: -1,
                y: 0
            }]],
            i = [{
                coding: [{
                    x: 0,
                    y: -1
                },
                {
                    x: 1,
                    y: -1
                },
                {
                    x: -1,
                    y: 0
                }],
                reference: [{
                    x: 0,
                    y: -1
                },
                {
                    x: 1,
                    y: -1
                },
                {
                    x: -1,
                    y: 0
                },
                {
                    x: 0,
                    y: 0
                },
                {
                    x: 1,
                    y: 0
                },
                {
                    x: -1,
                    y: 1
                },
                {
                    x: 0,
                    y: 1
                },
                {
                    x: 1,
                    y: 1
                }]
            },
            {
                coding: [{
                    x: -1,
                    y: -1
                },
                {
                    x: 0,
                    y: -1
                },
                {
                    x: 1,
                    y: -1
                },
                {
                    x: -1,
                    y: 0
                }],
                reference: [{
                    x: 0,
                    y: -1
                },
                {
                    x: -1,
                    y: 0
                },
                {
                    x: 0,
                    y: 0
                },
                {
                    x: 1,
                    y: 0
                },
                {
                    x: 0,
                    y: 1
                },
                {
                    x: 1,
                    y: 1
                }]
            }],
            u = [39717, 1941, 229, 405],
            o = [32, 8];
            function l(e, t, n) {
                var s, a, r, i, u, o, l, c = n.decoder,
                b = n.contextCache.getContexts("GB"),
                d = [],
                f = 31735;
                for (a = 0; a < t; a++) for (u = d[a] = new Uint8Array(e), o = a < 1 ? u: d[a - 1], l = a < 2 ? u: d[a - 2], s = l[0] << 13 | l[1] << 12 | l[2] << 11 | o[0] << 7 | o[1] << 6 | o[2] << 5 | o[3] << 4, r = 0; r < e; r++) u[r] = i = c.readBit(b, s),
                s = (s & f) << 1 | (r + 3 < e ? l[r + 3] << 11 : 0) | (r + 4 < e ? o[r + 4] << 4 : 0) | i;
                return d
            }
            function c(e, t, n, s, a, i, o, c) {
                if (e) {
                    var b = new M(c.data, c.start, c.end);
                    return U(b, t, n, !1)
                }
                if (0 === s && !i && !a && 4 === o.length && 3 === o[0].x && -1 === o[0].y && -3 === o[1].x && -1 === o[1].y && 2 === o[2].x && -2 === o[2].y && -2 === o[3].x && -2 === o[3].y) return l(t, n, c);
                var d = !!i,
                f = r[s].concat(o);
                f.sort((function(e, t) {
                    return e.y - t.y || e.x - t.x
                }));
                var h, p, v = f.length,
                g = new Int8Array(v),
                m = new Int8Array(v),
                y = [],
                x = 0,
                w = 0,
                O = 0,
                S = 0;
                for (p = 0; p < v; p++) g[p] = f[p].x,
                m[p] = f[p].y,
                w = Math.min(w, f[p].x),
                O = Math.max(O, f[p].x),
                S = Math.min(S, f[p].y),
                p < v - 1 && f[p].y === f[p + 1].y && f[p].x === f[p + 1].x - 1 ? x |= 1 << v - 1 - p: y.push(p);
                var k = y.length,
                j = new Int8Array(k),
                I = new Int8Array(k),
                C = new Uint16Array(k);
                for (h = 0; h < k; h++) p = y[h],
                j[h] = f[p].x,
                I[h] = f[p].y,
                C[h] = 1 << v - 1 - p;
                for (var B, _, D, T, A, R = -w,
                F = -S,
                P = t - O,
                E = u[s], L = new Uint8Array(t), N = [], V = c.decoder, H = c.contextCache.getContexts("GB"), q = 0, W = 0, $ = 0; $ < n; $++) {
                    if (a) {
                        var z = V.readBit(H, E);
                        if (q ^= z, q) {
                            N.push(L);
                            continue
                        }
                    }
                    for (L = new Uint8Array(L), N.push(L), B = 0; B < t; B++) if (d && i[$][B]) L[B] = 0;
                    else {
                        if (B >= R && B < P && $ >= F) for (W = W << 1 & x, p = 0; p < k; p++) _ = $ + I[p],
                        D = B + j[p],
                        T = N[_][D],
                        T && (T = C[p], W |= T);
                        else for (W = 0, A = v - 1, p = 0; p < v; p++, A--) D = B + g[p],
                        D >= 0 && D < t && (_ = $ + m[p], _ >= 0 && (T = N[_][D], T && (W |= T << A)));
                        var J = V.readBit(H, W);
                        L[B] = J
                    }
                }
                return N
            }
            function d(e, t, n, s, a, r, u, l, c) {
                var b = i[n].coding;
                0 === n && (b = b.concat([l[0]]));
                var d, f = b.length,
                h = new Int32Array(f),
                p = new Int32Array(f);
                for (d = 0; d < f; d++) h[d] = b[d].x,
                p[d] = b[d].y;
                var v = i[n].reference;
                0 === n && (v = v.concat([l[1]]));
                var g = v.length,
                m = new Int32Array(g),
                y = new Int32Array(g);
                for (d = 0; d < g; d++) m[d] = v[d].x,
                y[d] = v[d].y;
                for (var w = s[0].length, O = s.length, S = o[n], k = [], j = c.decoder, I = c.contextCache.getContexts("GR"), C = 0, B = 0; B < t; B++) {
                    if (u) {
                        var _ = j.readBit(I, S);
                        if (C ^= _, C) throw new x("prediction is not supported")
                    }
                    var D = new Uint8Array(e);
                    k.push(D);
                    for (var T = 0; T < e; T++) {
                        var A, R, F = 0;
                        for (d = 0; d < f; d++) A = B + p[d],
                        R = T + h[d],
                        A < 0 || R < 0 || R >= e ? F <<= 1 : F = F << 1 | k[A][R];
                        for (d = 0; d < g; d++) A = B + y[d] - r,
                        R = T + m[d] - a,
                        A < 0 || A >= O || R < 0 || R >= w ? F <<= 1 : F = F << 1 | s[A][R];
                        var P = j.readBit(I, F);
                        D[T] = P
                    }
                }
                return k
            }
            function g(e, t, a, r, i, u, o, l, b, h, p, v) {
                if (e && t) throw new x("symbol refinement with Huffman is not supported");
                var g, m, y = [],
                O = 0,
                S = f(a.length + r),
                k = p.decoder,
                j = p.contextCache;
                e && (g = N(1), m = [], S = Math.max(S, 1));
                while (y.length < r) {
                    var I = e ? u.tableDeltaHeight.decode(v) : n(j, "IADH", k);
                    O += I;
                    var C = 0,
                    B = 0,
                    _ = e ? m.length: 0;
                    while (1) {
                        var D, T = e ? u.tableDeltaWidth.decode(v) : n(j, "IADW", k);
                        if (null === T) break;
                        if (C += T, B += C, t) {
                            var A = n(j, "IAAI", k);
                            if (A > 1) D = w(e, t, C, O, 0, A, 1, a.concat(y), S, 0, 0, 1, 0, u, b, h, p, 0, v);
                            else {
                                var R = s(j, k, S),
                                F = n(j, "IARDX", k),
                                P = n(j, "IARDY", k),
                                E = R < a.length ? a[R] : y[R - a.length];
                                D = d(C, O, b, E, F, P, !1, h, p)
                            }
                            y.push(D)
                        } else e ? m.push(C) : (D = c(!1, C, O, o, !1, null, l, p), y.push(D))
                    }
                    if (e && !t) {
                        var L = u.tableBitmapSize.decode(v);
                        v.byteAlign();
                        var M = void 0;
                        if (0 === L) M = W(v, B, O);
                        else {
                            var V = v.end,
                            H = v.position + L;
                            v.end = H,
                            M = U(v, B, O, !1),
                            v.end = V,
                            v.position = H
                        }
                        var q = m.length;
                        if (_ === q - 1) y.push(M);
                        else {
                            var $ = void 0,
                            z = void 0,
                            J = 0,
                            G = void 0,
                            K = void 0,
                            X = void 0;
                            for ($ = _; $ < q; $++) {
                                for (K = m[$], G = J + K, X = [], z = 0; z < O; z++) X.push(M[z].subarray(J, G));
                                y.push(X),
                                J = G
                            }
                        }
                    }
                }
                var Y = [],
                Z = [],
                Q = !1,
                ee = a.length + r;
                while (Z.length < ee) {
                    var te = e ? g.decode(v) : n(j, "IAEX", k);
                    while (te--) Z.push(Q);
                    Q = !Q
                }
                for (var ne = 0,
                se = a.length; ne < se; ne++) Z[ne] && Y.push(a[ne]);
                for (var ae = 0; ae < r; ne++, ae++) Z[ne] && Y.push(y[ae]);
                return Y
            }
            function w(e, t, a, r, i, u, o, l, c, b, f, h, p, v, g, m, y, w, O) {
                if (e && t) throw new x("refinement with Huffman is not supported");
                var S, k, j = [];
                for (S = 0; S < r; S++) {
                    if (k = new Uint8Array(a), i) for (var I = 0; I < a; I++) k[I] = i;
                    j.push(k)
                }
                var C = y.decoder,
                B = y.contextCache,
                _ = e ? -v.tableDeltaT.decode(O) : -n(B, "IADT", C),
                D = 0;
                S = 0;
                while (S < u) {
                    var T = e ? v.tableDeltaT.decode(O) : n(B, "IADT", C);
                    _ += T;
                    var A = e ? v.tableFirstS.decode(O) : n(B, "IAFS", C);
                    D += A;
                    var R = D;
                    do {
                        var F = 0;
                        o > 1 && (F = e ? O.readBits(w) : n(B, "IAIT", C));
                        var P = o * _ + F,
                        E = e ? v.symbolIDTable.decode(O) : s(B, C, c), L = t && (e ? O.readBit() : n(B, "IARI", C)), N = l[E], M = N[0].length, V = N.length;
                        if (L) {
                            var H = n(B, "IARDW", C),
                            q = n(B, "IARDH", C),
                            W = n(B, "IARDX", C),
                            U = n(B, "IARDY", C);
                            M += H,
                            V += q,
                            N = d(M, V, g, N, (H >> 1) + W, (q >> 1) + U, !1, m, y)
                        }
                        var $, z, J, G = P - (1 & h ? 0 : V - 1), K = R - (2 & h ? M - 1 : 0);
                        if (b) {
                            for ($ = 0; $ < V; $++) if (k = j[K + $], k) {
                                J = N[$];
                                var X = Math.min(a - G, M);
                                switch (p) {
                                case 0:
                                    for (z = 0; z < X; z++) k[G + z] |= J[z];
                                    break;
                                case 2:
                                    for (z = 0; z < X; z++) k[G + z] ^= J[z];
                                    break;
                                default:
                                    throw new x("operator ".concat(p, " is not supported"))
                                }
                            }
                            R += V - 1
                        } else {
                            for (z = 0; z < V; z++) if (k = j[G + z], k) switch (J = N[z], p) {
                            case 0:
                                for ($ = 0; $ < M; $++) k[K + $] |= J[$];
                                break;
                            case 2:
                                for ($ = 0; $ < M; $++) k[K + $] ^= J[$];
                                break;
                            default:
                                throw new x("operator ".concat(p, " is not supported"))
                            }
                            R += M - 1
                        }
                        S++;
                        var Y = e ? v.tableDeltaS.decode(O) : n(B, "IADS", C);
                        if (null === Y) break;
                        R += Y + f
                    } while ( 1 )
                }
                return j
            }
            function O(e, t, n, s, a, r) {
                var i = [];
                e || (i.push({
                    x: -t,
                    y: 0
                }), 0 === a && (i.push({
                    x: -3,
                    y: -1
                }), i.push({
                    x: 2,
                    y: -2
                }), i.push({
                    x: -2,
                    y: -2
                })));
                for (var u = (s + 1) * t, o = c(e, u, n, a, !1, null, i, r), l = [], b = 0; b <= s; b++) {
                    for (var d = [], f = t * b, h = f + t, p = 0; p < n; p++) d.push(o[p].subarray(f, h));
                    l.push(d)
                }
                return l
            }
            function S(e, t, n, s, a, r, i, u, o, l, b, d, h, p, v) {
                var g = null;
                if (i) throw new x("skip is not supported");
                if (0 !== u) throw new x("operator " + u + " is not supported in halftone region");
                var m, y, w, O = [];
                for (m = 0; m < a; m++) {
                    if (w = new Uint8Array(s), r) for (y = 0; y < s; y++) w[y] = r;
                    O.push(w)
                }
                var S = t.length,
                k = t[0],
                j = k[0].length,
                I = k.length,
                C = f(S),
                B = [];
                e || (B.push({
                    x: n <= 1 ? 3 : 2,
                    y: -1
                }), 0 === n && (B.push({
                    x: -3,
                    y: -1
                }), B.push({
                    x: 2,
                    y: -2
                }), B.push({
                    x: -2,
                    y: -2
                })));
                var _, D, T, A, R, F, P, E, L, N, V, H = [];
                for (e && (_ = new M(v.data, v.start, v.end)), m = C - 1; m >= 0; m--) D = e ? U(_, o, l, !0) : c(!1, o, l, n, !1, g, B, v),
                H[m] = D;
                for (T = 0; T < l; T++) for (A = 0; A < o; A++) {
                    for (R = 0, F = 0, y = C - 1; y >= 0; y--) R = H[y][T][A] ^ R,
                    F |= R << y;
                    if (P = t[F], E = b + T * p + A * h >> 8, L = d + T * h - A * p >> 8, E >= 0 && E + j <= s && L >= 0 && L + I <= a) for (m = 0; m < I; m++) for (V = O[L + m], N = P[m], y = 0; y < j; y++) V[E + y] |= N[y];
                    else {
                        var q = void 0,
                        W = void 0;
                        for (m = 0; m < I; m++) if (W = L + m, !(W < 0 || W >= a)) for (V = O[W], N = P[m], y = 0; y < j; y++) q = E + y,
                        q >= 0 && q < s && (V[q] |= N[y])
                    }
                }
                return O
            }
            function k(e, t) {
                var n = {};
                n.number = v(e, t);
                var s = e[t + 4],
                r = 63 & s;
                if (!a[r]) throw new x("invalid segment type: " + r);
                n.type = r,
                n.typeName = a[r],
                n.deferredNonRetain = !!(128 & s);
                var i = !!(64 & s),
                u = e[t + 5],
                o = u >> 5 & 7,
                l = [31 & u],
                c = t + 6;
                if (7 === u) {
                    o = 536870911 & v(e, c - 1),
                    c += 3;
                    var b = o + 7 >> 3;
                    l[0] = e[c++];
                    while (--b > 0) l.push(e[c++])
                } else if (5 === u || 6 === u) throw new x("invalid referred-to flags");
                n.retainBits = l;
                var d = 4;
                n.number <= 256 ? d = 1 : n.number <= 65536 && (d = 2);
                var f, h, g = [];
                for (f = 0; f < o; f++) {
                    var m = void 0;
                    m = 1 === d ? e[c] : 2 === d ? p(e, c) : v(e, c),
                    g.push(m),
                    c += d
                }
                if (n.referredTo = g, i ? (n.pageAssociation = v(e, c), c += 4) : n.pageAssociation = e[c++], n.length = v(e, c), c += 4, 4294967295 === n.length) {
                    if (38 !== r) throw new x("invalid unknown segment length");
                    var y = I(e, c),
                    w = e[c + C],
                    O = !!(1 & w),
                    S = 6,
                    k = new Uint8Array(S);
                    for (O || (k[0] = 255, k[1] = 172), k[2] = y.height >>> 24 & 255, k[3] = y.height >> 16 & 255, k[4] = y.height >> 8 & 255, k[5] = 255 & y.height, f = c, h = e.length; f < h; f++) {
                        var j = 0;
                        while (j < S && k[j] === e[f + j]) j++;
                        if (j === S) {
                            n.length = f + S;
                            break
                        }
                    }
                    if (4294967295 === n.length) throw new x("segment end was not found")
                }
                return n.headerEnd = c,
                n
            }
            function j(e, t, n, s) {
                var a = [],
                r = n;
                while (r < s) {
                    var i = k(t, r);
                    r = i.headerEnd;
                    var u = {
                        header: i,
                        data: t
                    };
                    if (e.randomAccess || (u.start = r, r += i.length, u.end = r), a.push(u), 51 === i.type) break
                }
                if (e.randomAccess) for (var o = 0,
                l = a.length; o < l; o++) a[o].start = r,
                r += a[o].header.length,
                a[o].end = r;
                return a
            }
            function I(e, t) {
                return {
                    width: v(e, t),
                    height: v(e, t + 4),
                    x: v(e, t + 8),
                    y: v(e, t + 12),
                    combinationOperator: 7 & e[t + 16]
                }
            }
            var C = 17;
            function B(e, t) {
                var n, s, a, r, i = e.header,
                u = e.data,
                o = e.start,
                l = e.end;
                switch (i.type) {
                case 0:
                    var c = {},
                    b = p(u, o);
                    if (c.huffman = !!(1 & b), c.refinement = !!(2 & b), c.huffmanDHSelector = b >> 2 & 3, c.huffmanDWSelector = b >> 4 & 3, c.bitmapSizeSelector = b >> 6 & 1, c.aggregationInstancesSelector = b >> 7 & 1, c.bitmapCodingContextUsed = !!(256 & b), c.bitmapCodingContextRetained = !!(512 & b), c.template = b >> 10 & 3, c.refinementTemplate = b >> 12 & 1, o += 2, !c.huffman) {
                        for (r = 0 === c.template ? 4 : 1, s = [], a = 0; a < r; a++) s.push({
                            x: h(u, o),
                            y: h(u, o + 1)
                        }),
                        o += 2;
                        c.at = s
                    }
                    if (c.refinement && !c.refinementTemplate) {
                        for (s = [], a = 0; a < 2; a++) s.push({
                            x: h(u, o),
                            y: h(u, o + 1)
                        }),
                        o += 2;
                        c.refinementAt = s
                    }
                    c.numberOfExportedSymbols = v(u, o),
                    o += 4,
                    c.numberOfNewSymbols = v(u, o),
                    o += 4,
                    n = [c, i.number, i.referredTo, u, o, l];
                    break;
                case 6:
                case 7:
                    var d = {};
                    d.info = I(u, o),
                    o += C;
                    var f = p(u, o);
                    if (o += 2, d.huffman = !!(1 & f), d.refinement = !!(2 & f), d.logStripSize = f >> 2 & 3, d.stripSize = 1 << d.logStripSize, d.referenceCorner = f >> 4 & 3, d.transposed = !!(64 & f), d.combinationOperator = f >> 7 & 3, d.defaultPixelValue = f >> 9 & 1, d.dsOffset = f << 17 >> 27, d.refinementTemplate = f >> 15 & 1, d.huffman) {
                        var g = p(u, o);
                        o += 2,
                        d.huffmanFS = 3 & g,
                        d.huffmanDS = g >> 2 & 3,
                        d.huffmanDT = g >> 4 & 3,
                        d.huffmanRefinementDW = g >> 6 & 3,
                        d.huffmanRefinementDH = g >> 8 & 3,
                        d.huffmanRefinementDX = g >> 10 & 3,
                        d.huffmanRefinementDY = g >> 12 & 3,
                        d.huffmanRefinementSizeSelector = !!(16384 & g)
                    }
                    if (d.refinement && !d.refinementTemplate) {
                        for (s = [], a = 0; a < 2; a++) s.push({
                            x: h(u, o),
                            y: h(u, o + 1)
                        }),
                        o += 2;
                        d.refinementAt = s
                    }
                    d.numberOfSymbolInstances = v(u, o),
                    o += 4,
                    n = [d, i.referredTo, u, o, l];
                    break;
                case 16:
                    var m = {},
                    y = u[o++];
                    m.mmr = !!(1 & y),
                    m.template = y >> 1 & 3,
                    m.patternWidth = u[o++],
                    m.patternHeight = u[o++],
                    m.maxPatternIndex = v(u, o),
                    o += 4,
                    n = [m, i.number, u, o, l];
                    break;
                case 22:
                case 23:
                    var w = {};
                    w.info = I(u, o),
                    o += C;
                    var O = u[o++];
                    w.mmr = !!(1 & O),
                    w.template = O >> 1 & 3,
                    w.enableSkip = !!(8 & O),
                    w.combinationOperator = O >> 4 & 7,
                    w.defaultPixelValue = O >> 7 & 1,
                    w.gridWidth = v(u, o),
                    o += 4,
                    w.gridHeight = v(u, o),
                    o += 4,
                    w.gridOffsetX = 4294967295 & v(u, o),
                    o += 4,
                    w.gridOffsetY = 4294967295 & v(u, o),
                    o += 4,
                    w.gridVectorX = p(u, o),
                    o += 2,
                    w.gridVectorY = p(u, o),
                    o += 2,
                    n = [w, i.referredTo, u, o, l];
                    break;
                case 38:
                case 39:
                    var S = {};
                    S.info = I(u, o),
                    o += C;
                    var k = u[o++];
                    if (S.mmr = !!(1 & k), S.template = k >> 1 & 3, S.prediction = !!(8 & k), !S.mmr) {
                        for (r = 0 === S.template ? 4 : 1, s = [], a = 0; a < r; a++) s.push({
                            x: h(u, o),
                            y: h(u, o + 1)
                        }),
                        o += 2;
                        S.at = s
                    }
                    n = [S, u, o, l];
                    break;
                case 48:
                    var j = {
                        width: v(u, o),
                        height: v(u, o + 4),
                        resolutionX: v(u, o + 8),
                        resolutionY: v(u, o + 12)
                    };
                    4294967295 === j.height && delete j.height;
                    var B = u[o + 16];
                    p(u, o + 17),
                    j.lossless = !!(1 & B),
                    j.refinement = !!(2 & B),
                    j.defaultPixelValue = B >> 2 & 1,
                    j.combinationOperator = B >> 3 & 3,
                    j.requiresBuffer = !!(32 & B),
                    j.combinationOperatorOverride = !!(64 & B),
                    n = [j];
                    break;
                case 49:
                    break;
                case 50:
                    break;
                case 51:
                    break;
                case 53:
                    n = [i.number, u, o, l];
                    break;
                case 62:
                    break;
                default:
                    throw new x("segment type ".concat(i.typeName, "(").concat(i.type, ")") + " is not implemented")
                }
                var _ = "on" + i.typeName;
                _ in t && t[_].apply(t, n)
            }
            function _(e, t) {
                for (var n = 0,
                s = e.length; n < s; n++) B(e[n], t)
            }
            function D(e) {
                for (var t = new A,
                n = 0,
                s = e.length; n < s; n++) {
                    var a = e[n],
                    r = j({},
                    a.data, a.start, a.end);
                    _(r, t)
                }
                return t.buffer
            }
            function T(e) {
                var t = e.length,
                n = 0;
                if (151 !== e[n] || 74 !== e[n + 1] || 66 !== e[n + 2] || 50 !== e[n + 3] || 13 !== e[n + 4] || 10 !== e[n + 5] || 26 !== e[n + 6] || 10 !== e[n + 7]) throw new x("parseJbig2 - invalid header.");
                var s = Object.create(null);
                n += 8;
                var a = e[n++];
                s.randomAccess = !(1 & a),
                2 & a || (s.numberOfPages = v(e, n), n += 4);
                var r = j(s, e, n, t),
                i = new A;
                _(r, i);
                for (var u = i.currentPageInfo,
                o = u.width,
                l = u.height,
                c = i.buffer,
                b = new Uint8ClampedArray(o * l), d = 0, f = 0, h = 0; h < l; h++) for (var p = 0,
                g = void 0,
                m = 0; m < o; m++) p || (p = 128, g = c[f++]),
                b[d++] = g & p ? 0 : 255,
                p >>= 1;
                return {
                    imgData: b,
                    width: o,
                    height: l
                }
            }
            function A() {}
            function R(e) {
                2 === e.length ? (this.isOOB = !0, this.rangeLow = 0, this.prefixLength = e[0], this.rangeLength = 0, this.prefixCode = e[1], this.isLowerRange = !1) : (this.isOOB = !1, this.rangeLow = e[0], this.prefixLength = e[1], this.rangeLength = e[2], this.prefixCode = e[3], this.isLowerRange = "lower" === e[4])
            }
            function F(e) {
                this.children = [],
                e ? (this.isLeaf = !0, this.rangeLength = e.rangeLength, this.rangeLow = e.rangeLow, this.isLowerRange = e.isLowerRange, this.isOOB = e.isOOB) : this.isLeaf = !1
            }
            function P(e, t) {
                t || this.assignPrefixCodes(e),
                this.rootNode = new F(null);
                for (var n = 0,
                s = e.length; n < s; n++) {
                    var a = e[n];
                    a.prefixLength > 0 && this.rootNode.buildTree(a, a.prefixLength - 1)
                }
            }
            function E(e, t, n) {
                var s, a, r = e[t],
                i = 4294967295 & v(e, t + 1),
                u = 4294967295 & v(e, t + 5),
                o = new M(e, t + 9, n),
                l = 1 + (r >> 1 & 7),
                c = 1 + (r >> 4 & 7),
                b = [],
                d = i;
                do {
                    s = o.readBits(l), a = o.readBits(c), b.push(new R([d, s, a, 0])), d += 1 << a
                } while ( d < u );
                return s = o.readBits(l),
                b.push(new R([i - 1, s, 32, 0, "lower"])),
                s = o.readBits(l),
                b.push(new R([u, s, 32, 0])),
                1 & r && (s = o.readBits(l), b.push(new R([s, 0]))),
                new P(b, !1)
            }
            A.prototype = {
                onPageInformation: function(e) {
                    this.currentPageInfo = e;
                    var t = e.width + 7 >> 3,
                    n = new Uint8ClampedArray(t * e.height);
                    if (e.defaultPixelValue) for (var s = 0,
                    a = n.length; s < a; s++) n[s] = 255;
                    this.buffer = n
                },
                drawBitmap: function(e, t) {
                    var n, s, a, r, i = this.currentPageInfo,
                    u = e.width,
                    o = e.height,
                    l = i.width + 7 >> 3,
                    c = i.combinationOperatorOverride ? e.combinationOperator: i.combinationOperator,
                    b = this.buffer,
                    d = 128 >> (7 & e.x),
                    f = e.y * l + (e.x >> 3);
                    switch (c) {
                    case 0:
                        for (n = 0; n < o; n++) {
                            for (a = d, r = f, s = 0; s < u; s++) t[n][s] && (b[r] |= a),
                            a >>= 1,
                            a || (a = 128, r++);
                            f += l
                        }
                        break;
                    case 2:
                        for (n = 0; n < o; n++) {
                            for (a = d, r = f, s = 0; s < u; s++) t[n][s] && (b[r] ^= a),
                            a >>= 1,
                            a || (a = 128, r++);
                            f += l
                        }
                        break;
                    default:
                        throw new x("operator ".concat(c, " is not supported"))
                    }
                },
                onImmediateGenericRegion: function(e, n, s, a) {
                    var r = e.info,
                    i = new t(n, s, a),
                    u = c(e.mmr, r.width, r.height, e.template, e.prediction, null, e.at, i);
                    this.drawBitmap(r, u)
                },
                onImmediateLosslessGenericRegion: function() {
                    this.onImmediateGenericRegion.apply(this, arguments)
                },
                onSymbolDictionary: function(e, n, s, a, r, i) {
                    var u, o;
                    e.huffman && (u = q(e, s, this.customTables), o = new M(a, r, i));
                    var l = this.symbols;
                    l || (this.symbols = l = {});
                    for (var c = [], b = 0, d = s.length; b < d; b++) {
                        var f = l[s[b]];
                        f && (c = c.concat(f))
                    }
                    var h = new t(a, r, i);
                    l[n] = g(e.huffman, e.refinement, c, e.numberOfNewSymbols, e.numberOfExportedSymbols, u, e.template, e.at, e.refinementTemplate, e.refinementAt, h, o)
                },
                onImmediateTextRegion: function(e, n, s, a, r) {
                    for (var i, u, o = e.info,
                    l = this.symbols,
                    c = [], b = 0, d = n.length; b < d; b++) {
                        var h = l[n[b]];
                        h && (c = c.concat(h))
                    }
                    var p = f(c.length);
                    e.huffman && (u = new M(s, a, r), i = H(e, n, this.customTables, c.length, u));
                    var v = new t(s, a, r),
                    g = w(e.huffman, e.refinement, o.width, o.height, e.defaultPixelValue, e.numberOfSymbolInstances, e.stripSize, c, p, e.transposed, e.dsOffset, e.referenceCorner, e.combinationOperator, i, e.refinementTemplate, e.refinementAt, v, e.logStripSize, u);
                    this.drawBitmap(o, g)
                },
                onImmediateLosslessTextRegion: function() {
                    this.onImmediateTextRegion.apply(this, arguments)
                },
                onPatternDictionary: function(e, n, s, a, r) {
                    var i = this.patterns;
                    i || (this.patterns = i = {});
                    var u = new t(s, a, r);
                    i[n] = O(e.mmr, e.patternWidth, e.patternHeight, e.maxPatternIndex, e.template, u)
                },
                onImmediateHalftoneRegion: function(e, n, s, a, r) {
                    var i = this.patterns[n[0]],
                    u = e.info,
                    o = new t(s, a, r),
                    l = S(e.mmr, i, e.template, u.width, u.height, e.defaultPixelValue, e.enableSkip, e.combinationOperator, e.gridWidth, e.gridHeight, e.gridOffsetX, e.gridOffsetY, e.gridVectorX, e.gridVectorY, o);
                    this.drawBitmap(u, l)
                },
                onImmediateLosslessHalftoneRegion: function() {
                    this.onImmediateHalftoneRegion.apply(this, arguments)
                },
                onTables: function(e, t, n, s) {
                    var a = this.customTables;
                    a || (this.customTables = a = {}),
                    a[e] = E(t, n, s)
                }
            },
            F.prototype = {
                buildTree: function(e, t) {
                    var n = e.prefixCode >> t & 1;
                    if (t <= 0) this.children[n] = new F(e);
                    else {
                        var s = this.children[n];
                        s || (this.children[n] = s = new F(null)),
                        s.buildTree(e, t - 1)
                    }
                },
                decodeNode: function(e) {
                    if (this.isLeaf) {
                        if (this.isOOB) return null;
                        var t = e.readBits(this.rangeLength);
                        return this.rangeLow + (this.isLowerRange ? -t: t)
                    }
                    var n = this.children[e.readBit()];
                    if (!n) throw new x("invalid Huffman data");
                    return n.decodeNode(e)
                }
            },
            P.prototype = {
                decode: function(e) {
                    return this.rootNode.decodeNode(e)
                },
                assignPrefixCodes: function(e) {
                    for (var t = e.length,
                    n = 0,
                    s = 0; s < t; s++) n = Math.max(n, e[s].prefixLength);
                    for (var a = new Uint32Array(n + 1), r = 0; r < t; r++) a[e[r].prefixLength]++;
                    var i, u, o, l = 1,
                    c = 0;
                    a[0] = 0;
                    while (l <= n) {
                        c = c + a[l - 1] << 1,
                        i = c,
                        u = 0;
                        while (u < t) o = e[u],
                        o.prefixLength === l && (o.prefixCode = i, i++),
                        u++;
                        l++
                    }
                }
            };
            var L = {};
            function N(e) {
                var t, n = L[e];
                if (n) return n;
                switch (e) {
                case 1:
                    t = [[0, 1, 4, 0], [16, 2, 8, 2], [272, 3, 16, 6], [65808, 3, 32, 7]];
                    break;
                case 2:
                    t = [[0, 1, 0, 0], [1, 2, 0, 2], [2, 3, 0, 6], [3, 4, 3, 14], [11, 5, 6, 30], [75, 6, 32, 62], [6, 63]];
                    break;
                case 3:
                    t = [[ - 256, 8, 8, 254], [0, 1, 0, 0], [1, 2, 0, 2], [2, 3, 0, 6], [3, 4, 3, 14], [11, 5, 6, 30], [ - 257, 8, 32, 255, "lower"], [75, 7, 32, 126], [6, 62]];
                    break;
                case 4:
                    t = [[1, 1, 0, 0], [2, 2, 0, 2], [3, 3, 0, 6], [4, 4, 3, 14], [12, 5, 6, 30], [76, 5, 32, 31]];
                    break;
                case 5:
                    t = [[ - 255, 7, 8, 126], [1, 1, 0, 0], [2, 2, 0, 2], [3, 3, 0, 6], [4, 4, 3, 14], [12, 5, 6, 30], [ - 256, 7, 32, 127, "lower"], [76, 6, 32, 62]];
                    break;
                case 6:
                    t = [[ - 2048, 5, 10, 28], [ - 1024, 4, 9, 8], [ - 512, 4, 8, 9], [ - 256, 4, 7, 10], [ - 128, 5, 6, 29], [ - 64, 5, 5, 30], [ - 32, 4, 5, 11], [0, 2, 7, 0], [128, 3, 7, 2], [256, 3, 8, 3], [512, 4, 9, 12], [1024, 4, 10, 13], [ - 2049, 6, 32, 62, "lower"], [2048, 6, 32, 63]];
                    break;
                case 7:
                    t = [[ - 1024, 4, 9, 8], [ - 512, 3, 8, 0], [ - 256, 4, 7, 9], [ - 128, 5, 6, 26], [ - 64, 5, 5, 27], [ - 32, 4, 5, 10], [0, 4, 5, 11], [32, 5, 5, 28], [64, 5, 6, 29], [128, 4, 7, 12], [256, 3, 8, 1], [512, 3, 9, 2], [1024, 3, 10, 3], [ - 1025, 5, 32, 30, "lower"], [2048, 5, 32, 31]];
                    break;
                case 8:
                    t = [[ - 15, 8, 3, 252], [ - 7, 9, 1, 508], [ - 5, 8, 1, 253], [ - 3, 9, 0, 509], [ - 2, 7, 0, 124], [ - 1, 4, 0, 10], [0, 2, 1, 0], [2, 5, 0, 26], [3, 6, 0, 58], [4, 3, 4, 4], [20, 6, 1, 59], [22, 4, 4, 11], [38, 4, 5, 12], [70, 5, 6, 27], [134, 5, 7, 28], [262, 6, 7, 60], [390, 7, 8, 125], [646, 6, 10, 61], [ - 16, 9, 32, 510, "lower"], [1670, 9, 32, 511], [2, 1]];
                    break;
                case 9:
                    t = [[ - 31, 8, 4, 252], [ - 15, 9, 2, 508], [ - 11, 8, 2, 253], [ - 7, 9, 1, 509], [ - 5, 7, 1, 124], [ - 3, 4, 1, 10], [ - 1, 3, 1, 2], [1, 3, 1, 3], [3, 5, 1, 26], [5, 6, 1, 58], [7, 3, 5, 4], [39, 6, 2, 59], [43, 4, 5, 11], [75, 4, 6, 12], [139, 5, 7, 27], [267, 5, 8, 28], [523, 6, 8, 60], [779, 7, 9, 125], [1291, 6, 11, 61], [ - 32, 9, 32, 510, "lower"], [3339, 9, 32, 511], [2, 0]];
                    break;
                case 10:
                    t = [[ - 21, 7, 4, 122], [ - 5, 8, 0, 252], [ - 4, 7, 0, 123], [ - 3, 5, 0, 24], [ - 2, 2, 2, 0], [2, 5, 0, 25], [3, 6, 0, 54], [4, 7, 0, 124], [5, 8, 0, 253], [6, 2, 6, 1], [70, 5, 5, 26], [102, 6, 5, 55], [134, 6, 6, 56], [198, 6, 7, 57], [326, 6, 8, 58], [582, 6, 9, 59], [1094, 6, 10, 60], [2118, 7, 11, 125], [ - 22, 8, 32, 254, "lower"], [4166, 8, 32, 255], [2, 2]];
                    break;
                case 11:
                    t = [[1, 1, 0, 0], [2, 2, 1, 2], [4, 4, 0, 12], [5, 4, 1, 13], [7, 5, 1, 28], [9, 5, 2, 29], [13, 6, 2, 60], [17, 7, 2, 122], [21, 7, 3, 123], [29, 7, 4, 124], [45, 7, 5, 125], [77, 7, 6, 126], [141, 7, 32, 127]];
                    break;
                case 12:
                    t = [[1, 1, 0, 0], [2, 2, 0, 2], [3, 3, 1, 6], [5, 5, 0, 28], [6, 5, 1, 29], [8, 6, 1, 60], [10, 7, 0, 122], [11, 7, 1, 123], [13, 7, 2, 124], [17, 7, 3, 125], [25, 7, 4, 126], [41, 8, 5, 254], [73, 8, 32, 255]];
                    break;
                case 13:
                    t = [[1, 1, 0, 0], [2, 3, 0, 4], [3, 4, 0, 12], [4, 5, 0, 28], [5, 4, 1, 13], [7, 3, 3, 5], [15, 6, 1, 58], [17, 6, 2, 59], [21, 6, 3, 60], [29, 6, 4, 61], [45, 6, 5, 62], [77, 7, 6, 126], [141, 7, 32, 127]];
                    break;
                case 14:
                    t = [[ - 2, 3, 0, 4], [ - 1, 3, 0, 5], [0, 1, 0, 0], [1, 3, 0, 6], [2, 3, 0, 7]];
                    break;
                case 15:
                    t = [[ - 24, 7, 4, 124], [ - 8, 6, 2, 60], [ - 4, 5, 1, 28], [ - 2, 4, 0, 12], [ - 1, 3, 0, 4], [0, 1, 0, 0], [1, 3, 0, 5], [2, 4, 0, 13], [3, 5, 1, 29], [5, 6, 2, 61], [9, 7, 4, 125], [ - 25, 7, 32, 126, "lower"], [25, 7, 32, 127]];
                    break;
                default:
                    throw new x("standard table B.".concat(e, " does not exist"))
                }
                for (var s = 0,
                a = t.length; s < a; s++) t[s] = new R(t[s]);
                return n = new P(t, !0),
                L[e] = n,
                n
            }
            function M(e, t, n) {
                this.data = e,
                this.start = t,
                this.end = n,
                this.position = t,
                this.shift = -1,
                this.currentByte = 0
            }
            function V(e, t, n) {
                for (var s = 0,
                a = 0,
                r = t.length; a < r; a++) {
                    var i = n[t[a]];
                    if (i) {
                        if (e === s) return i;
                        s++
                    }
                }
                throw new x("can't find custom Huffman table")
            }
            function H(e, t, n, s, a) {
                for (var r = [], i = 0; i <= 34; i++) {
                    var u = a.readBits(4);
                    r.push(new R([i, u, 0, 0]))
                }
                var o = new P(r, !1);
                r.length = 0;
                for (var l = 0; l < s;) {
                    var c = o.decode(a);
                    if (c >= 32) {
                        var b = void 0,
                        d = void 0,
                        f = void 0;
                        switch (c) {
                        case 32:
                            if (0 === l) throw new x("no previous value in symbol ID table");
                            d = a.readBits(2) + 3,
                            b = r[l - 1].prefixLength;
                            break;
                        case 33:
                            d = a.readBits(3) + 3,
                            b = 0;
                            break;
                        case 34:
                            d = a.readBits(7) + 11,
                            b = 0;
                            break;
                        default:
                            throw new x("invalid code length in symbol ID table")
                        }
                        for (f = 0; f < d; f++) r.push(new R([l, b, 0, 0])),
                        l++
                    } else r.push(new R([l, c, 0, 0])),
                    l++
                }
                a.byteAlign();
                var h, p, v, g = new P(r, !1),
                m = 0;
                switch (e.huffmanFS) {
                case 0:
                case 1:
                    h = N(e.huffmanFS + 6);
                    break;
                case 3:
                    h = V(m, t, n),
                    m++;
                    break;
                default:
                    throw new x("invalid Huffman FS selector")
                }
                switch (e.huffmanDS) {
                case 0:
                case 1:
                case 2:
                    p = N(e.huffmanDS + 8);
                    break;
                case 3:
                    p = V(m, t, n),
                    m++;
                    break;
                default:
                    throw new x("invalid Huffman DS selector")
                }
                switch (e.huffmanDT) {
                case 0:
                case 1:
                case 2:
                    v = N(e.huffmanDT + 11);
                    break;
                case 3:
                    v = V(m, t, n),
                    m++;
                    break;
                default:
                    throw new x("invalid Huffman DT selector")
                }
                if (e.refinement) throw new x("refinement with Huffman is not supported");
                return {
                    symbolIDTable:
                    g,
                    tableFirstS: h,
                    tableDeltaS: p,
                    tableDeltaT: v
                }
            }
            function q(e, t, n) {
                var s, a, r, i, u = 0;
                switch (e.huffmanDHSelector) {
                case 0:
                case 1:
                    s = N(e.huffmanDHSelector + 4);
                    break;
                case 3:
                    s = V(u, t, n),
                    u++;
                    break;
                default:
                    throw new x("invalid Huffman DH selector")
                }
                switch (e.huffmanDWSelector) {
                case 0:
                case 1:
                    a = N(e.huffmanDWSelector + 2);
                    break;
                case 3:
                    a = V(u, t, n),
                    u++;
                    break;
                default:
                    throw new x("invalid Huffman DW selector")
                }
                return e.bitmapSizeSelector ? (r = V(u, t, n), u++) : r = N(1),
                i = e.aggregationInstancesSelector ? V(u, t, n) : N(1),
                {
                    tableDeltaHeight: s,
                    tableDeltaWidth: a,
                    tableBitmapSize: r,
                    tableAggregateInstances: i
                }
            }
            function W(e, t, n) {
                for (var s = [], a = 0; a < n; a++) {
                    var r = new Uint8Array(t);
                    s.push(r);
                    for (var i = 0; i < t; i++) r[i] = e.readBit();
                    e.byteAlign()
                }
                return s
            }
            function U(e, t, n, s) {
                for (var a, r = {
                    K: -1,
                    Columns: t,
                    Rows: n,
                    BlackIs1: !0,
                    EndOfBlock: s
                },
                i = new y(e, r), u = [], o = !1, l = 0; l < n; l++) {
                    var c = new Uint8Array(t);
                    u.push(c);
                    for (var b = -1,
                    d = 0; d < t; d++) b < 0 && (a = i.readNextChar(), -1 === a && (a = 0, o = !0), b = 7),
                    c[d] = a >> b & 1,
                    b--
                }
                if (s && !o) for (var f = 5,
                h = 0; h < f; h++) if ( - 1 === i.readNextChar()) break;
                return u
            }
            function $() {}
            return M.prototype = {
                readBit: function() {
                    if (this.shift < 0) {
                        if (this.position >= this.end) throw new x("end of data while reading bit");
                        this.currentByte = this.data[this.position++],
                        this.shift = 7
                    }
                    var e = this.currentByte >> this.shift & 1;
                    return this.shift--,
                    e
                },
                readBits: function(e) {
                    var t, n = 0;
                    for (t = e - 1; t >= 0; t--) n |= this.readBit() << t;
                    return n
                },
                byteAlign: function() {
                    this.shift = -1
                },
                next: function() {
                    return this.position >= this.end ? -1 : this.data[this.position++]
                }
            },
            $.prototype = {
                parseChunks: function(e) {
                    return D(e)
                },
                parse: function(e) {
                    var t = T(e),
                    n = t.imgData,
                    s = t.width,
                    a = t.height;
                    return this.width = s,
                    this.height = a,
                    n
                }
            },
            $
        } ()
    },
    "7f3b": function(e, t, n) {
        "use strict"; (function(e) {
            n("a4d3"),
            n("e01a"),
            n("a630"),
            n("caad"),
            n("fb6a"),
            n("6c57"),
            n("4ec9"),
            n("90d7"),
            n("a9e3"),
            n("8ba4"),
            n("9129"),
            n("4fad"),
            n("c1f9"),
            n("d3b7"),
            n("07ac"),
            n("25f0"),
            n("6062"),
            n("f5b2"),
            n("8a79"),
            n("f6d6"),
            n("2532"),
            n("3ca3"),
            n("843c"),
            n("4d90"),
            n("2ca0"),
            n("5cc6"),
            n("9a8c"),
            n("a975"),
            n("735e"),
            n("c1ac"),
            n("d139"),
            n("3a7b"),
            n("d5d6"),
            n("82f8"),
            n("e91f"),
            n("60bd"),
            n("5f96"),
            n("3280"),
            n("3fcc"),
            n("ca91"),
            n("25a1"),
            n("cd26"),
            n("3c5d"),
            n("2954"),
            n("649e"),
            n("219c"),
            n("170b"),
            n("b39a"),
            n("72f7"),
            n("10d1"),
            n("1fe2"),
            n("ddb0"),
            n("2b3d");
            var t = n("d00a");
            "undefined" !== typeof PDFJSDev && PDFJSDev.test("SKIP_BABEL") || "undefined" !== typeof globalThis && globalThis._pdfjsCompatibilityChecked || ("undefined" !== typeof globalThis && globalThis.Math === Math || (globalThis = n("eb73")), globalThis._pdfjsCompatibilityChecked = !0,
            function() { ! globalThis.btoa && t["a"] && (globalThis.btoa = function(t) {
                    return e.from(t, "binary").toString("base64")
                })
            } (),
            function() { ! globalThis.atob && t["a"] && (globalThis.atob = function(t) {
                    return e.from(t, "base64").toString("binary")
                })
            } (),
            function() {
                String.prototype.startsWith || n("d2a2")
            } (),
            function() {
                String.prototype.endsWith || n("8f4c")
            } (),
            function() {
                String.prototype.includes || n("4661")
            } (),
            function() {
                Array.prototype.includes || n("bf2c")
            } (),
            function() {
                Array.from || n("6b84")
            } (),
            function() {
                Object.assign || n("2418")
            } (),
            function() {
                Object.fromEntries || n("8ac5")
            } (),
            function() {
                Math.log2 || (Math.log2 = n("dc57"))
            } (),
            function() {
                Number.isNaN || (Number.isNaN = n("9020"))
            } (),
            function() {
                Number.isInteger || (Number.isInteger = n("f2e6"))
            } (),
            function() {
                Uint8Array.prototype.slice || n("8f2a")
            } (),
            function() {
                "undefined" !== typeof PDFJSDev && PDFJSDev.test("IMAGE_DECODERS") || globalThis.Promise.allSettled || (globalThis.Promise = n("3980"))
            } (),
            function() {
                "undefined" !== typeof PDFJSDev && PDFJSDev.test("PRODUCTION") && PDFJSDev.test("GENERIC") && (PDFJSDev.test("IMAGE_DECODERS") || (globalThis.URL = n("14d8")))
            } (),
            function() {
                if ("undefined" === typeof PDFJSDev || !PDFJSDev.test("IMAGE_DECODERS")) {
                    var e = !1;
                    if ("undefined" !== typeof ReadableStream) try {
                        new ReadableStream({
                            start: function(e) {
                                e.close()
                            }
                        }),
                        e = !0
                    } catch(t) {}
                    e || (globalThis.ReadableStream = n("87c2").ReadableStream)
                }
            } (),
            function() {
                globalThis.Map && globalThis.Map.prototype.entries || (globalThis.Map = n("5eff"))
            } (),
            function() {
                globalThis.Set && globalThis.Set.prototype.entries || (globalThis.Set = n("9a35"))
            } (),
            function() {
                globalThis.WeakMap || (globalThis.WeakMap = n("ad63"))
            } (),
            function() {
                globalThis.WeakSet || (globalThis.WeakSet = n("ee42"))
            } (),
            function() {
                String.prototype.codePointAt || n("d627")
            } (),
            function() {
                String.fromCodePoint || (String.fromCodePoint = n("1cd7"))
            } (),
            function() {
                globalThis.Symbol || n("1f4a")
            } (),
            function() {
                String.prototype.padStart || n("1920")
            } (),
            function() {
                String.prototype.padEnd || n("476b")
            } (),
            function() {
                Object.values || (Object.values = n("4e28"))
            } (),
            function() {
                Object.entries || (Object.entries = n("a960"))
            } ())
        }).call(this, n("b639").Buffer)
    },
    "81a2": function(e, t, n) {
        "use strict";
        n.d(t, "c", (function() {
            return w
        })),
        n.d(t, "d", (function() {
            return S
        })),
        n.d(t, "e", (function() {
            return k
        })),
        n.d(t, "a", (function() {
            return j
        })),
        n.d(t, "f", (function() {
            return I
        })),
        n.d(t, "b", (function() {
            return C
        }));
        n("99af"),
        n("c19f"),
        n("b64b"),
        n("d3b7");
        var s = n("b85c"),
        a = (n("96cf"), n("1da1")),
        r = (n("b680"), n("ac1f"), n("5319"), n("1276"), n("8a59"), n("9a8c"), n("a975"), n("735e"), n("c1ac"), n("d139"), n("3a7b"), n("d5d6"), n("82f8"), n("e91f"), n("60bd"), n("5f96"), n("3280"), n("3fcc"), n("ca91"), n("25a1"), n("cd26"), n("3c5d"), n("2954"), n("649e"), n("219c"), n("170b"), n("b39a"), n("72f7"), n("6b33")),
        i = function(e, t, n) {
            var s, a = n[Object.keys(n)[0]]["json"]["ofd:Area"];
            if (a) {
                var i = a["ofd:PhysicalBox"];
                if (i) s = i;
                else {
                    var u = a["ofd:ApplicationBox"];
                    if (u) s = u;
                    else {
                        var o = a["ofd:ContentBox"];
                        o && (s = o)
                    }
                }
            } else {
                var l = t["ofd:CommonData"]["ofd:PageArea"],
                c = l["ofd:PhysicalBox"];
                if (c) s = c;
                else {
                    var b = l["ofd:ApplicationBox"];
                    if (b) s = b;
                    else {
                        var d = l["ofd:ContentBox"];
                        d && (s = d)
                    }
                }
            }
            var f = s.split(" "),
            h = ((e - 10) / parseFloat(f[2])).toFixed(1);
            return Object(r["n"])(h),
            Object(r["o"])(h),
            s = Object(r["l"])(s),
            s = Object(r["e"])(s),
            s
        },
        u = function(e, t) {
            var n, s = t[Object.keys(t)[0]]["json"]["ofd:Area"];
            if (s) {
                var a = s["ofd:PhysicalBox"];
                if (a) n = a;
                else {
                    var i = s["ofd:ApplicationBox"];
                    if (i) n = i;
                    else {
                        var u = s["ofd:ContentBox"];
                        u && (n = u)
                    }
                }
            } else {
                var o = e["ofd:CommonData"]["ofd:PageArea"],
                l = o["ofd:PhysicalBox"];
                if (l) n = l;
                else {
                    var c = o["ofd:ApplicationBox"];
                    if (c) n = c;
                    else {
                        var b = o["ofd:ContentBox"];
                        b && (n = b)
                    }
                }
            }
            return n = Object(r["l"])(n),
            n = Object(r["e"])(n),
            n
        },
        o = function(e, t, n, a, i, u) {
            var o = Object.keys(t)[0],
            d = t[o]["json"]["ofd:Template"];
            if (d) {
                var f = [],
                p = n[d["@_TemplateID"]]["json"]["ofd:Content"]["ofd:Layer"];
                f = f.concat(p);
                var v, g = Object(s["a"])(f);
                try {
                    for (g.s(); ! (v = g.n()).done;) {
                        var m = v.value;
                        m && b(e, a, i, u, m, !1)
                    }
                } catch(R) {
                    g.e(R)
                } finally {
                    g.f()
                }
            }
            var y = t[o]["json"]["ofd:Content"]["ofd:Layer"],
            x = [];
            x = x.concat(y);
            var w, O = Object(s["a"])(x);
            try {
                for (O.s(); ! (w = O.n()).done;) {
                    var S = w.value;
                    S && b(e, a, i, u, S, !1)
                }
            } catch(R) {
                O.e(R)
            } finally {
                O.f()
            }
            if (t[o].stamp) {
                var k, j = Object(s["a"])(t[o].stamp);
                try {
                    for (j.s(); ! (k = j.n()).done;) {
                        var I = k.value;
                        if ("ofd" === I.type) c(e, I.obj.pages, I.obj.tpls, !0, I.stamp.stampAnnot, I.obj.fontResObj, I.obj.drawParamResObj, I.obj.multiMediaResObj, I.stamp.sealObj.SES_Signature, I.stamp.signedInfo);
                        else if ("png" === I.type) {
                            var C = Object(r["e"])(I.obj.boundary),
                            B = Array.isArray(I.stamp.stampAnnot) ? I.stamp.stampAnnot[0]["pfIndex"] : I.stamp.stampAnnot["pfIndex"],
                            _ = h(e.style.width, e.style.height, I.obj.img, C, I.obj.clip, !0, I.stamp.sealObj.SES_Signature, I.stamp.signedInfo, B);
                            e.appendChild(_)
                        }
                    }
                } catch(R) {
                    j.e(R)
                } finally {
                    j.f()
                }
            }
            if (t[o].annotation) {
                var D, T = Object(s["a"])(t[o].annotation);
                try {
                    for (T.s(); ! (D = T.n()).done;) {
                        var A = D.value;
                        l(e, A, a, i, u)
                    }
                } catch(R) {
                    T.e(R)
                } finally {
                    T.f()
                }
            }
        },
        l = function(e, t, n, s, a) {
            var i = document.createElement("div");
            i.setAttribute("style", "position:relative;");
            var u = t["appearance"]["@_Boundary"];
            if (u) {
                var o = Object(r["e"])(Object(r["l"])(u));
                i.setAttribute("style", "z-index:-1;position:absolute; left: ".concat(o.x, "px; top: ").concat(o.y, "px; width: ").concat(o.w, "px; height: ").concat(o.h, "px"))
            }
            var l = t["appearance"];
            b(i, n, s, a, l, !1),
            e.appendChild(i)
        },
        c = function(e, t, n, a, i, u, o, l, c, d) {
            var f, h = Object(s["a"])(t);
            try {
                for (h.s(); ! (f = h.n()).done;) {
                    var p = f.value,
                    v = Object.keys(p)[0],
                    g = {
                        x: 0,
                        y: 0,
                        w: 0,
                        h: 0
                    };
                    a && i && (g = i.boundary);
                    var m = Object(r["e"])(g),
                    y = document.createElement("div");
                    y.setAttribute("name", "seal_img_div"),
                    y.setAttribute("style", "cursor: pointer; position:relative; left: ".concat(m.x, "px; top: ").concat(m.y, "px; width: ").concat(m.w, "px; height: ").concat(m.h, "px")),
                    y.setAttribute("data-ses-signature", "".concat(JSON.stringify(c))),
                    y.setAttribute("data-signed-info", "".concat(JSON.stringify(d)));
                    var x = p[v]["json"]["ofd:Template"];
                    if (x) {
                        var w = n[x["@_TemplateID"]]["json"]["ofd:Content"]["ofd:Layer"],
                        O = [];
                        O = O.concat(w);
                        var S, k = Object(s["a"])(O);
                        try {
                            for (k.s(); ! (S = k.n()).done;) {
                                var j = S.value;
                                j && b(y, u, o, l, j, a)
                            }
                        } catch(T) {
                            k.e(T)
                        } finally {
                            k.f()
                        }
                    }
                    var I = p[v]["json"]["ofd:Content"]["ofd:Layer"],
                    C = [];
                    C = C.concat(I);
                    var B, _ = Object(s["a"])(C);
                    try {
                        for (_.s(); ! (B = _.n()).done;) {
                            var D = B.value;
                            D && b(y, u, o, l, D, a)
                        }
                    } catch(T) {
                        _.e(T)
                    } finally {
                        _.f()
                    }
                    e.appendChild(y)
                }
            } catch(T) {
                h.e(T)
            } finally {
                h.f()
            }
        },
        b = function(e, t, n, a, i, u) {
            var o = null,
            l = null,
            c = Object(r["f"])(.353),
            b = i["@_DrawParam"];
            b && Object.keys(n).length > 0 && n[b] && (n[b]["relative"] && (b = n[b]["relative"], n[b]["FillColor"] && (o = Object(r["j"])(n[b]["FillColor"])), n[b]["StrokeColor"] && (l = Object(r["j"])(n[b]["StrokeColor"])), n[b]["LineWidth"] && (c = Object(r["f"])(n[b]["LineWidth"]))), n[b]["FillColor"] && (o = Object(r["j"])(n[b]["FillColor"])), n[b]["StrokeColor"] && (l = Object(r["j"])(n[b]["StrokeColor"])), n[b]["LineWidth"] && (c = Object(r["f"])(n[b]["LineWidth"])));
            var f = i["ofd:ImageObject"],
            h = [];
            h = h.concat(f);
            var g, m = Object(s["a"])(h);
            try {
                for (m.s(); ! (g = m.n()).done;) {
                    var y = g.value;
                    if (y) {
                        var x = d(e.style.width, e.style.height, a, y);
                        e.appendChild(x)
                    }
                }
            } catch(R) {
                m.e(R)
            } finally {
                m.f()
            }
            var w = i["ofd:PathObject"],
            O = [];
            O = O.concat(w);
            var S, k = Object(s["a"])(O);
            try {
                for (k.s(); ! (S = k.n()).done;) {
                    var j = S.value;
                    if (j) {
                        var I = v(n, j, o, l, c, u);
                        e.appendChild(I)
                    }
                }
            } catch(R) {
                k.e(R)
            } finally {
                k.f()
            }
            var C = i["ofd:TextObject"],
            B = [];
            B = B.concat(C);
            var _, D = Object(s["a"])(B);
            try {
                for (D.s(); ! (_ = D.n()).done;) {
                    var T = _.value;
                    if (T) {
                        var A = p(t, T, o, l);
                        e.appendChild(A)
                    }
                }
            } catch(R) {
                D.e(R)
            } finally {
                D.f()
            }
        },
        d = function(e, t, n, s) {
            var a = Object(r["l"])(s["@_Boundary"]);
            a = Object(r["e"])(a);
            var i = s["@_ResourceID"];
            if ("gbig2" === n[i].format) {
                var u = n[i].img,
                o = n[i].width,
                l = n[i].height;
                return f(u, o, l, a, s["pfIndex"])
            }
            return h(e, t, n[i].img, a, !1, !1, null, null, s["pfIndex"])
        },
        f = function(e, t, n, s, a) {
            for (var r = new Uint8ClampedArray(4 * t * n), i = 0; i < e.length; i++) r[4 * i] = e[i],
            r[4 * i + 1] = e[i],
            r[4 * i + 2] = e[i],
            r[4 * i + 3] = 255;
            var u = new ImageData(r, t, n),
            o = document.createElement("canvas");
            o.width = t,
            o.height = n;
            var l = o.getContext("2d");
            return l.putImageData(u, 0, 0),
            o.setAttribute("style", "left: ".concat(s.x, "px; top: ").concat(s.y, "px; width: ").concat(s.w, "px; height: ").concat(s.h, "px;z-index: ").concat(a)),
            o.style.position = "absolute",
            o
        },
        h = function(e, t, n, s, a, i, u, o, l) {
            var c = document.createElement("div");
            i && (c.setAttribute("name", "seal_img_div"), c.setAttribute("data-ses-signature", "".concat(JSON.stringify(u))), c.setAttribute("data-signed-info", "".concat(JSON.stringify(o))));
            var b = document.createElement("img");
            b.src = n,
            b.setAttribute("width", "100%"),
            b.setAttribute("height", "100%"),
            c.appendChild(b);
            var d = parseFloat(e.replace("px", "")),
            f = parseFloat(t.replace("px", "")),
            h = s.w > d ? d: s.w,
            p = s.h > f ? f: s.h,
            v = "";
            return a && (a = Object(r["e"])(a), v = "clip: rect(".concat(a.y, "px, ").concat(a.w + a.x, "px, ").concat(a.h + a.y, "px, ").concat(a.x, "px)")),
            c.setAttribute("style", "cursor: pointer; overflow: hidden; position: absolute; left: ".concat(v ? s.x: s.x < 0 ? 0 : s.x, "px; top: ").concat(v ? s.y: s.y < 0 ? 0 : s.y, "px; width: ").concat(h, "px; height: ").concat(p, "px; ").concat(v, ";z-index: ").concat(l)),
            c
        },
        p = function(e, t, n, a) {
            var i = 1,
            u = Object(r["l"])(t["@_Boundary"]);
            u = Object(r["e"])(u);
            var o = t["@_CTM"],
            l = t["@_HScale"],
            c = t["@_Font"],
            b = t["@_Weight"],
            d = Object(r["f"])(parseFloat(t["@_Size"])),
            f = [];
            f = f.concat(t["ofd:TextCode"]);
            var h = Object(r["c"])(f),
            p = document.createElementNS("http://www.w3.org/2000/svg", "svg");
            p.setAttribute("version", "1.1");
            var v = t["ofd:FillColor"];
            if (v) {
                n = Object(r["j"])(v["@_Value"]);
                var g = v["@_Alpha"];
                g && (i = g > 1 ? g / 255 : g)
            }
            var m, y = Object(s["a"])(h);
            try {
                for (y.s(); ! (m = y.n()).done;) {
                    var x = m.value;
                    if (x && !isNaN(x.x)) {
                        var w = document.createElementNS("http://www.w3.org/2000/svg", "text");
                        if (w.setAttribute("x", x.x), w.setAttribute("y", x.y), w.innerHTML = x.text, o) {
                            var O = Object(r["k"])(o);
                            w.setAttribute("transform", "matrix(".concat(O[0], " ").concat(O[1], " ").concat(O[2], " ").concat(O[3], " ").concat(Object(r["f"])(O[4]), " ").concat(Object(r["f"])(O[5]), ")"))
                        }
                        l && w.setAttribute("transform", "matrix(".concat(l, ", 0, 0, 1, ").concat((1 - l) * x.x, ", 0)")),
                        w.setAttribute("fill", a),
                        w.setAttribute("fill", n),
                        w.setAttribute("fill-opacity", i),
                        w.setAttribute("style", "font-weight: ".concat(b, ";font-size:").concat(d, "px;font-family: ").concat(Object(r["h"])(e[c]), ";")),
                        p.appendChild(w)
                    }
                }
            } catch(C) {
                y.e(C)
            } finally {
                y.f()
            }
            var S = u.w,
            k = u.h,
            j = u.x,
            I = u.y;
            return p.setAttribute("style", "overflow:visible;position:absolute;width:".concat(S, "px;height:").concat(k, "px;left:").concat(j, "px;top:").concat(I, "px;z-index:").concat(t["pfIndex"])),
            p
        },
        v = function(e, t, n, a, i, u) {
            var o = Object(r["l"])(t["@_Boundary"]);
            o = Object(r["e"])(o);
            var l = t["@_LineWidth"],
            c = t["ofd:AbbreviatedData"],
            b = Object(r["b"])(Object(r["d"])(c)),
            d = t["@_CTM"],
            f = document.createElementNS("http://www.w3.org/2000/svg", "svg");
            f.setAttribute("version", "1.1");
            var h = document.createElementNS("http://www.w3.org/2000/svg", "path");
            l && (i = Object(r["f"])(l));
            var p = t["@_DrawParam"];
            if (p && (l = e[p].LineWidth, l && (i = Object(r["f"])(l))), d) {
                var v = Object(r["k"])(d);
                h.setAttribute("transform", "matrix(".concat(v[0], " ").concat(v[1], " ").concat(v[2], " ").concat(v[3], " ").concat(Object(r["f"])(v[4]), " ").concat(Object(r["f"])(v[5]), ")"))
            }
            var g = "",
            m = t["ofd:StrokeColor"];
            m && (a = Object(r["j"])(m["@_Value"]));
            var y = "fill: none;",
            x = t["ofd:FillColor"];
            x && (n = Object(r["j"])(x["@_Value"])),
            i > 0 && !a && (a = n, a || (a = "rgb(0, 0, 0)")),
            g = "stroke:".concat(a, ";stroke-width:").concat(i, "px;"),
            "false" == t["@_Stroke"] && (g = ""),
            "false" != t["@_Fill"] && (y = "fill:".concat(u ? "none": n || "none", ";")),
            h.setAttribute("style", "".concat(g, ";").concat(y));
            var w, O = "",
            S = Object(s["a"])(b);
            try {
                for (S.s(); ! (w = S.n()).done;) {
                    var k = w.value;
                    "M" === k.type ? O += "M".concat(k.x, " ").concat(k.y, " ") : "L" === k.type ? O += "L".concat(k.x, " ").concat(k.y, " ") : "B" === k.type ? O += "C".concat(k.x1, " ").concat(k.y1, " ").concat(k.x2, " ").concat(k.y2, " ").concat(k.x3, " ").concat(k.y3, " ") : "C" === k.type && (O += "Z")
                }
            } catch(_) {
                S.e(_)
            } finally {
                S.f()
            }
            h.setAttribute("d", O),
            f.appendChild(h);
            var j = u ? o.w: Math.ceil(o.w),
            I = u ? o.h: Math.ceil(o.h),
            C = o.x,
            B = o.y;
            return f.setAttribute("style", "overflow:visible;position:absolute;width:".concat(j, "px;height:").concat(I, "px;left:").concat(C, "px;top:").concat(B, "px;z-index:").concat(t["pfIndex"])),
            f
        },
        g = n("3662"),
        m = n("67d3"),
        y = n("a9c6"),
        x = n("0083"),
        w = function(e) {
            e.ofd instanceof File || e.ofd instanceof ArrayBuffer ? O(e) : x["getBinaryContent"](e.ofd, (function(t, n) {
                t ? e.fail && e.fail(t) : (e.ofd = n, O(e))
            }))
        },
        O = function(e) {
            g["a"].call(this, Object(a["a"])(regeneratorRuntime.mark((function t() {
                return regeneratorRuntime.wrap((function(t) {
                    while (1) switch (t.prev = t.next) {
                    case 0:
                        return t.next = 2,
                        Object(m["c"])(e.ofd);
                    case 2:
                        return t.abrupt("return", t.sent);
                    case 3:
                    case "end":
                        return t.stop()
                    }
                }), t)
            }))), m["a"], m["b"]).then((function(t) {
                e.success && e.success(t)
            })).
            catch((function(t) {
                console.log(t),
                e.fail && e.fail(t)
            }))
        },
        S = function(e, t) {
            var n = [];
            if (!t) return n;
            var a, r = Object(s["a"])(t.pages);
            try {
                for (r.s(); ! (a = r.n()).done;) {
                    var u = a.value,
                    l = i(e, t.document, u),
                    c = Object.keys(u)[0],
                    b = document.createElement("div");
                    b.id = c,
                    b.setAttribute("style", "margin-bottom: 20px;position: relative;width:".concat(l.w, "px;height:").concat(l.h, "px;background: white;")),
                    o(b, u, t.tpls, t.fontResObj, t.drawParamResObj, t.multiMediaResObj),
                    n.push(b)
                }
            } catch(d) {
                r.e(d)
            } finally {
                r.f()
            }
            return n
        },
        k = function(e) {
            var t = [];
            if (!e) return t;
            var n, a = Object(s["a"])(e.pages);
            try {
                for (a.s(); ! (n = a.n()).done;) {
                    var r = n.value,
                    i = u(e.document, r),
                    l = Object.keys(r)[0],
                    c = document.createElement("div");
                    c.id = l,
                    c.setAttribute("style", "margin-bottom: 20px;position: relative;width:".concat(i.w, "px;height:").concat(i.h, "px;background: white;")),
                    o(c, r, e.tpls, e.fontResObj, e.drawParamResObj, e.multiMediaResObj),
                    t.push(c)
                }
            } catch(b) {
                a.e(b)
            } finally {
                a.f()
            }
            return t
        },
        j = function(e) {
            return Object(y["a"])(e)
        },
        I = function(e) {
            Object(r["o"])(e)
        },
        C = function() {
            return Object(r["i"])()
        }
    },
    8374 : function(e, t, n) {
        "use strict"; (function(e) {
            n("c975"),
            n("c19f"),
            n("b0c0"),
            n("b64b"),
            n("d3b7"),
            n("ac1f"),
            n("3ca3"),
            n("5319"),
            n("1276"),
            n("5cc6"),
            n("9a8c"),
            n("a975"),
            n("735e"),
            n("c1ac"),
            n("d139"),
            n("3a7b"),
            n("d5d6"),
            n("82f8"),
            n("e91f"),
            n("60bd"),
            n("5f96"),
            n("3280"),
            n("3fcc"),
            n("ca91"),
            n("25a1"),
            n("cd26"),
            n("3c5d"),
            n("2954"),
            n("649e"),
            n("219c"),
            n("170b"),
            n("b39a"),
            n("72f7"),
            n("ddb0"),
            n("2b3d");
            var s = n("b85c"),
            a = n("81a2"),
            r = n("0083");
            t["a"] = {
                name: "HelloWorld",
                data: function() {
                    return {
                        pdfFile: null,
                        ofdBase64: null,
                        loading: !1,
                        pageIndex: 1,
                        pageCount: 0,
                        scale: 0,
                        title: null,
                        value: null,
                        dialogFormVisible: !1,
                        ofdObj: null,
                        screenWidth: document.body.clientWidth
                    }
                },
                created: function() {
                    this.pdfFile = null,
                    this.file = null
                },
                mounted: function() {
                    this.screenWidth = document.body.clientWidth - document.getElementById("leftMenu").getBoundingClientRect().width;
                    var e = this;
                    this.$refs.contentDiv.addEventListener("scroll", this.scrool),
                    window.onresize = function() {
                        return function() {
                            e.screenWidth = document.body.clientWidth - 88;
                            var t = Object(a["d"])(e.screenWidth, e.ofdObj);
                            e.displayOfdDiv(t)
                        } ()
                    }
                    var file = this.getQueryVariable("file");
                    this.demo(file);
                },
                methods: {
                	getQueryVariable :function (variable){
				       var query = window.location.search.substring(1);
				       var vars = query.split("&");
				       for (var i=0;i<vars.length;i++) {
				               var pair = vars[i].split("=");
				               if(pair[0] == variable){return pair[1];}
				       }
				       return(false);
					},
                    scrool: function() {
                        for (var e, t, n = (null === (e = this.$refs.contentDiv.firstElementChild) || void 0 === e || null === (t = e.getBoundingClientRect()) || void 0 === t ? void 0 : t.top) - 60, s = 0, a = 0, r = 0; r < this.$refs.contentDiv.childElementCount; r++) {
                            var i, u;
                            if (s += Math.abs(null === (i = this.$refs.contentDiv.children.item(r)) || void 0 === i ? void 0 : i.style.height.replace("px", "")) + Math.abs(null === (u = this.$refs.contentDiv.children.item(r)) || void 0 === u ? void 0 : u.style.marginBottom.replace("px", "")), Math.abs(n) < s) {
                                a = r;
                                break
                            }
                        }
                        this.pageIndex = a + 1
                    },
                    closeSealInfoDialog: function() {
                        this.$refs.sealInfoDiv.setAttribute("style", "display: none"),
                        document.getElementById("spSigner").innerText = "[无效的签章结构]",
                        document.getElementById("spProvider").innerText = "[无效的签章结构]",
                        document.getElementById("spHashedValue").innerText = "[无效的签章结构]",
                        document.getElementById("spSignedValue").innerText = "[无效的签章结构]",
                        document.getElementById("spSignMethod").innerText = "[无效的签章结构]",
                        document.getElementById("spSealID").innerText = "[无效的签章结构]",
                        document.getElementById("spSealName").innerText = "[无效的签章结构]",
                        document.getElementById("spSealType").innerText = "[无效的签章结构]",
                        document.getElementById("spSealAuthTime").innerText = "[无效的签章结构]",
                        document.getElementById("spSealMakeTime").innerText = "[无效的签章结构]",
                        document.getElementById("spSealVersion").innerText = "[无效的签章结构]",
                        document.getElementById("spVersion").innerText = "[无效的签章结构]",
                        document.getElementById("VerifyRet").innerText = "[无效的签章结构]"
                    },
                    showMore: function(e, t) {
                        this.dialogFormVisible = !0,
                        this.value = document.getElementById(t).innerText,
                        this.title = e
                    },
                    downOfd: function(e) {
                        var t = this,
                        n = this;
                        this.loading = !0,
                        this.$axios({
                            method: "post",
                            url: "https://51shouzu.xyz/api/ofd/convertOfd",
                            data: {
                                pdfBase64: e
                            }
                        }).then((function(e) {
                            n.loading = !1;
                            for (var t = atob(e.data.data.replace(/\s/g, "")), s = t.length, a = new ArrayBuffer(s), r = new Uint8Array(a), i = 0; i < s; i++) r[i] = t.charCodeAt(i);
                            var u = new Blob([r], null),
                            o = URL.createObjectURL(u),
                            l = document.createElement("a");
                            l.style.display = "none",
                            l.href = o,
                            l.setAttribute("download", "ofd.ofd"),
                            document.body.appendChild(l),
                            l.click()
                        })).
                        catch((function(e) {
                            console.log(e, "error"),
                            n.$alert("PDF打开失败", e, {
                                confirmButtonText: "确定",
                                callback: function(e) {
                                    t.$message({
                                        type: "info",
                                        message: "action: ".concat(e)
                                    })
                                }
                            })
                        }))
                    },
                    downPdf: function() {
                        var e = this,
                        t = this;
                        this.loading = !0,
                        this.$axios({
                            method: "post",
                            url: "https://51shouzu.xyz/api/ofd/convertPdf",
                            data: {
                                ofdBase64: this.ofdBase64
                            }
                        }).then((function(e) {
                            t.loading = !1;
                            for (var n = atob(e.data.data.replace(/\s/g, "")), s = n.length, a = new ArrayBuffer(s), r = new Uint8Array(a), i = 0; i < s; i++) r[i] = n.charCodeAt(i);
                            var u = new Blob([r], {
                                type: "application/pdf"
                            }),
                            o = URL.createObjectURL(u),
                            l = document.createElement("a");
                            l.style.display = "none",
                            l.href = o,
                            l.setAttribute("download", "ofd.pdf"),
                            document.body.appendChild(l),
                            l.click()
                        })).
                        catch((function(n) {
                            console.log(n, "error"),
                            t.$alert("OFD打开失败", n, {
                                confirmButtonText: "确定",
                                callback: function(t) {
                                    e.$message({
                                        type: "info",
                                        message: "action: ".concat(t)
                                    })
                                }
                            })
                        }))
                    },
                    plus: function() {
                        Object(a["f"])(++this.scale);
                        var e = Object(a["e"])(this.ofdObj);
                        this.displayOfdDiv(e)
                    },
                    minus: function() {
                        Object(a["f"])(--this.scale);
                        var e = Object(a["e"])(this.ofdObj);
                        this.displayOfdDiv(e)
                    },
                    prePage: function() {
                        var e = document.getElementById("content"),
                        t = e.children.item(this.pageIndex - 2);
                        null === t || void 0 === t || t.scrollIntoView(!0),
                        t && (this.pageIndex = this.pageIndex - 1)
                    },
                    firstPage: function() {
                        var e = document.getElementById("content"),
                        t = e.firstElementChild;
                        null === t || void 0 === t || t.scrollIntoView(!0),
                        t && (this.pageIndex = 1)
                    },
                    nextPage: function() {
                        var e = document.getElementById("content"),
                        t = e.children.item(this.pageIndex);
                        null === t || void 0 === t || t.scrollIntoView(!0),
                        t && ++this.pageIndex
                    },
                    lastPage: function() {
                        var e = document.getElementById("content"),
                        t = e.lastElementChild;
                        null === t || void 0 === t || t.scrollIntoView(!0),
                        t && (this.pageIndex = e.childElementCount)
                    },
                    demo: function(file) {
                        var t = file;
                        //t = "999.ofd";//可以
						//t = "D:/invoice_files/6044347eaacfadd4d7236fc4214b08da_999.ofd";//可以
                        //t = "http://localhost:9088/6044347eaacfadd4d7236fc4214b08da_999.ofd";//也可以
                        var n = this;
                        r["getBinaryContent"](t, (function(t) {
                            var s = btoa(String.fromCharCode.apply(null, new Uint8Array(t)));
                            n.ofdBase64 = s
                        })),
                        this.getOfdDocumentObj(t, this.screenWidth)
                        
                    },
                    uploadFile: function() {
                        this.file = null,
                        this.$refs.file.click()
                    },
                    fileChanged: function() {
                        var e = this;
                        this.file = this.$refs.file.files[0];
                        var t = this.file.name.replace(/.+\./, "");
                        if ( - 1 !== ["ofd"].indexOf(t)) if (this.file.size > 104857600) this.$alert("error", "文件大小需 < 100M", {
                            confirmButtonText: "确定",
                            callback: function(t) {
                                e.$message({
                                    type: "info",
                                    message: "action: ".concat(t)
                                })
                            }
                        });
                        else {
                            var n = this,
                            s = new FileReader;
                            s.readAsDataURL(this.file),
                            s.onload = function(e) {
                                n.ofdBase64 = e.target.result.split(",")[1]
                            },
                            this.getOfdDocumentObj(this.file, this.screenWidth),
                            this.$refs.file.value = null
                        } else this.$alert("error", "仅支持ofd类型", {
                            confirmButtonText: "确定",
                            callback: function(t) {
                                e.$message({
                                    type: "info",
                                    message: "action: ".concat(t)
                                })
                            }
                        })
                    },
                    uploadPdfFile: function() {
                        this.pdfFile = null,
                        this.$refs.pdfFile.click()
                    },
                    pdfFileChanged: function() {
                        var e = this;
                        this.pdfFile = this.$refs.pdfFile.files[0];
                        var t = this.pdfFile.name.replace(/.+\./, "");
                        if ( - 1 !== ["pdf"].indexOf(t)) if (this.pdfFile.size > 104857600) this.$alert("error", "文件大小需 < 100M", {
                            confirmButtonText: "确定",
                            callback: function(t) {
                                e.$message({
                                    type: "info",
                                    message: "action: ".concat(t)
                                })
                            }
                        });
                        else {
                            var n = this,
                            s = new FileReader;
                            s.readAsDataURL(this.pdfFile),
                            s.onload = function(e) {
                                var t = e.target.result.split(",")[1];
                                n.downOfd(t)
                            },
                            this.$refs.pdfFile.value = null
                        } else this.$alert("error", "仅支持pdf类型", {
                            confirmButtonText: "确定",
                            callback: function(t) {
                                e.$message({
                                    type: "info",
                                    message: "action: ".concat(t)
                                })
                            }
                        })
                    },
                    getOfdDocumentObj: function(e, t) {
                        var n = this,
                        s = (new Date).getTime();
                        this.loading = !0,
                        Object(a["c"])({
                            ofd: e,
                            success: function(e) {
                                console.log(e);
                                var r = (new Date).getTime();
                                console.log("解析ofd", r - s),
                                n.ofdObj = e[0],
                                n.pageCount = e[0].pages.length;
                                var i = Object(a["d"])(t, e[0]),
                                u = (new Date).getTime();
                                console.log("xml转svg", u - r),
                                n.displayOfdDiv(i);
                                var o = (new Date).getTime();
                                console.log("svg渲染到页面", o - u),
                                n.loading = !1
                            },
                            fail: function(e) {
                                var t = this;
                                n.loading = !1,
                                n.$alert("OFD打开失败", e, {
                                    confirmButtonText: "确定",
                                    callback: function(e) {
                                        t.$message({
                                            type: "info",
                                            message: "action: ".concat(e)
                                        })
                                    }
                                })
                            }
                        })
                    },
                    displayOfdDiv: function(e) {
                        this.scale = Object(a["b"])();
                        var t = document.getElementById("content");
                        t.innerHTML = "";
                        var n, r = Object(s["a"])(e);
                        try {
                            for (r.s(); ! (n = r.n()).done;) {
                                var i = n.value;
                                t.appendChild(i)
                            }
                        } catch(c) {
                            r.e(c)
                        } finally {
                            r.f()
                        }
                        var u, o = Object(s["a"])(document.getElementsByName("seal_img_div"));
                        try {
                            for (o.s(); ! (u = o.n()).done;) {
                                var l = u.value;
                                this.addEventOnSealDiv(l, JSON.parse(l.dataset.sesSignature), JSON.parse(l.dataset.signedInfo))
                            }
                        } catch(c) {
                            o.e(c)
                        } finally {
                            o.f()
                        }
                    },
                    addEventOnSealDiv: function(t, n, s) {
                        try {
                            e.HashRet = null,
                            e.VerifyRet = s.VerifyRet,
                            t.addEventListener("click", (function() {
                                document.getElementById("sealInfoDiv").hidden = !1,
                                document.getElementById("sealInfoDiv").setAttribute("style", "display:flex;align-items: center;justify-content: center;"),
                                n.realVersion < 4 ? (document.getElementById("spSigner").innerText = n.toSign.cert["commonName"], document.getElementById("spProvider").innerText = s.Provider["@_ProviderName"], document.getElementById("spHashedValue").innerText = n.toSign.dataHash.replace(/\n/g, ""), document.getElementById("spSignedValue").innerText = n.signature.replace(/\n/g, ""), document.getElementById("spSignMethod").innerText = n.toSign.signatureAlgorithm.replace(/\n/g, ""), document.getElementById("spSealID").innerText = n.toSign.eseal.esealInfo.esID, document.getElementById("spSealName").innerText = n.toSign.eseal.esealInfo.property.name, document.getElementById("spSealType").innerText = n.toSign.eseal.esealInfo.property.type, document.getElementById("spSealAuthTime").innerText = "从 " + n.toSign.eseal.esealInfo.property.validStart + " 到 " + n.toSign.eseal.esealInfo.property.validEnd, document.getElementById("spSealMakeTime").innerText = n.toSign.eseal.esealInfo.property.createDate, document.getElementById("spSealVersion").innerText = n.toSign.eseal.esealInfo.header.version) : (document.getElementById("spSigner").innerText = n.cert["commonName"], document.getElementById("spProvider").innerText = s.Provider["@_ProviderName"], document.getElementById("spHashedValue").innerText = n.toSign.dataHash.replace(/\n/g, ""), document.getElementById("spSignedValue").innerText = n.signature.replace(/\n/g, ""), document.getElementById("spSignMethod").innerText = n.signatureAlgID.replace(/\n/g, ""), document.getElementById("spSealID").innerText = n.toSign.eseal.esealInfo.esID, document.getElementById("spSealName").innerText = n.toSign.eseal.esealInfo.property.name, document.getElementById("spSealType").innerText = n.toSign.eseal.esealInfo.property.type, document.getElementById("spSealAuthTime").innerText = "从 " + n.toSign.eseal.esealInfo.property.validStart + " 到 " + n.toSign.eseal.esealInfo.property.validEnd, document.getElementById("spSealMakeTime").innerText = n.toSign.eseal.esealInfo.property.createDate, document.getElementById("spSealVersion").innerText = n.toSign.eseal.esealInfo.header.version),
                                document.getElementById("spVersion").innerText = n.toSign.version,
                                document.getElementById("VerifyRet").innerText = "文件摘要值后台验证中，请稍等... " + (e.VerifyRet ? "签名值验证成功": "签名值验证失败"),
                                (null == e.HashRet || void 0 == e.HashRet || Object.keys(e.HashRet).length <= 0) && setTimeout((function() {
                                    var t = e.VerifyRet ? "签名值验证成功": "签名值验证失败";
                                    e.HashRet = Object(a["a"])(e.toBeChecked.get(s.signatureID));
                                    var n = e.HashRet ? "文件摘要值验证成功": "文件摘要值验证失败";
                                    document.getElementById("VerifyRet").innerText = n + " " + t
                                }), 1e3)
                            }))
                        } catch(r) {
                            console.log(r)
                        }
                        e.VerifyRet || t.setAttribute("class", "gray")
                    }
                }
            }
        }).call(this, n("c8ba"))
    },
    "85ec": function(e, t, n) {},
    a9c6: function(e, t, n) {
        "use strict";
        n.d(t, "b", (function() {
            return V
        })),
        n.d(t, "a", (function() {
            return H
        }));
        n("4160"),
        n("c975"),
        n("4ec9"),
        n("d3b7"),
        n("ac1f"),
        n("3ca3"),
        n("5319"),
        n("1276"),
        n("4c53"),
        n("159b"),
        n("ddb0");
        var s = n("b85c"),
        a = (n("96cf"), n("1da1")),
        r = n("6f9c"),
        i = n.n(r),
        u = n("64c1"),
        o = n.n(u),
        l = n("a476"),
        c = n.n(l),
        b = n("8060");
        n("99af"),
        n("a15b"),
        n("13d5"),
        n("25f0"),
        n("f5b2");
        function d(e, t) {
            return e.length >= t ? e: new Array(t - e.length + 1).join("0") + e
        }
        function f(e) {
            for (var t = 8,
            n = "",
            s = 0; s < e.length / t; s++) n += d(parseInt(e.substr(s * t, t), 2).toString(16), 2);
            return n
        }
        function h(e) {
            for (var t = 2,
            n = "",
            s = 0; s < e.length / t; s++) n += d(parseInt(e.substr(s * t, t), 16).toString(2), 8);
            return n
        }
        function p(e, t) {
            return e.substring(t % e.length) + e.substr(0, t % e.length)
        }
        function v(e, t, n) {
            for (var s, a = e || "",
            r = t || "",
            i = [], u = a.length - 1; u >= 0; u--) s = n(a[u], r[u], s),
            i[u] = s[0];
            return i.join("")
        }
        function g(e, t) {
            return v(e, t, (function(e, t) {
                return [e === t ? "0": "1"]
            }))
        }
        function m(e, t) {
            return v(e, t, (function(e, t) {
                return ["1" === e && "1" === t ? "1": "0"]
            }))
        }
        function y(e, t) {
            return v(e, t, (function(e, t) {
                return ["1" === e || "1" === t ? "1": "0"]
            }))
        }
        function x(e, t) {
            var n = v(e, t, (function(e, t, n) {
                var s = n ? n[1] : "0";
                return e !== t ? ["0" === s ? "1": "0", s] : [s, e]
            }));
            return n
        }
        function w(e) {
            return v(e, void 0, (function(e) {
                return ["1" === e ? "0": "1"]
            }))
        }
        function O(e) {
            return function() {
                for (var t = arguments.length,
                n = new Array(t), s = 0; s < t; s++) n[s] = arguments[s];
                return n.reduce((function(t, n) {
                    return e(t, n)
                }))
            }
        }
        function S(e) {
            return O(g)(e, p(e, 9), p(e, 17))
        }
        function k(e) {
            return O(g)(e, p(e, 15), p(e, 23))
        }
        function j(e, t, n, s) {
            return s >= 0 && s <= 15 ? O(g)(e, t, n) : O(y)(m(e, t), m(e, n), m(t, n))
        }
        function I(e, t, n, s) {
            return s >= 0 && s <= 15 ? O(g)(e, t, n) : y(m(e, t), m(w(e), n))
        }
        function C(e) {
            return h(e >= 0 && e <= 15 ? "79cc4519": "7a879d8a")
        }
        function B(e, t) {
            for (var n = 32,
            s = [], a = [], r = 0; r < 16; r++) s.push(t.substr(r * n, n));
            for (var i = 16; i < 68; i++) s.push(O(g)(k(O(g)(s[i - 16], s[i - 9], p(s[i - 3], 15))), p(s[i - 13], 7), s[i - 6]));
            for (var u = 0; u < 64; u++) a.push(g(s[u], s[u + 4]));
            for (var o = [], l = 0; l < 8; l++) o.push(e.substr(l * n, n));
            for (var c, b, d, f, h = o[0], v = o[1], m = o[2], y = o[3], w = o[4], B = o[5], _ = o[6], D = o[7], T = 0; T < 64; T++) c = p(O(x)(p(h, 12), w, p(C(T), T)), 7),
            b = g(c, p(h, 12)),
            d = O(x)(j(h, v, m, T), y, b, a[T]),
            f = O(x)(I(w, B, _, T), D, c, s[T]),
            y = m,
            m = p(v, 9),
            v = h,
            h = d,
            D = _,
            _ = p(B, 19),
            B = w,
            w = S(f);
            return g([h, v, m, y, w, B, _, D].join(""), e)
        }
        function _(e) {
            var t = h(e),
            n = t.length,
            s = n % 512;
            s = s >= 448 ? 512 - s % 448 - 1 : 448 - s - 1;
            for (var a = "".concat(t, "1").concat(d("", s)).concat(d(n.toString(2), 64)).toString(), r = (n + s + 65) / 512, i = h("7380166f4914b2b9172442d7da8a0600a96f30bc163138aae38dee4db0fb0e4e"), u = 0; u <= r - 1; u++) {
                var o = a.substr(512 * u, 512);
                i = B(i, o)
            }
            return f(i)
        }
        var D = n("8237"),
        T = n.n(D),
        A = n("6199"),
        R = n.n(A),
        F = n("81fa"),
        P = n.n(F),
        E = n("6b33"),
        L = function(e, t, n) {
            var s = Object(E["a"])(o.a.decode(t));
            return n = n.toLowerCase(),
            n.indexOf("1.2.156.10197.1.401") >= 0 || n.indexOf("sm3") >= 0 ? s == _(Object(E["a"])(e)) : n.indexOf("md5") >= 0 ? s == T()(e) : n.indexOf("sha1") >= 0 ? s == R()(e) : ""
        },
        N = function(e) {
            try {
                var t = e.realVersion < 4 ? e.toSign.signatureAlgorithm: e.signatureAlgID;
                t = t.toLowerCase();
                var n = e.toSignDer;
                if (t.indexOf("1.2.156.10197.1.501") >= 0 || t.indexOf("sm2") >= 0) {
                    var s = e.signature.replace(/ /g, "").replace(/\n/g, "");
                    0 == s.indexOf("00") && (s = s.substr(2, s.length - 2));
                    var a = e.realVersion < 4 ? e.toSign.cert: e.cert,
                    r = a.subjectPublicKeyInfo.subjectPublicKey.replace(/ /g, "").replace(/\n/g, "");
                    return 0 == r.indexOf("00") && (r = r.substr(2, r.length - 2)),
                    b["sm2"].doVerifySignature(n, s, r, {
                        der: !0,
                        hash: !0,
                        userId: "1234567812345678"
                    })
                }
                var i = new P.a.KJUR.crypto.Signature({
                    alg: "SHA1withRSA"
                }),
                u = e.realVersion < 4 ? e.toSign.cert: e.cert,
                o = e.signature.replace(/ /g, "").replace(/\n/g, "");
                return 0 == o.indexOf("00") && (o = o.substr(2, o.length - 2)),
                i.init(u),
                i.updateHex(n),
                i.verify(o)
            } catch(l) {
                return console.log(l),
                !1
            }
        },
        M = /^\s*(?:[0-9A-Fa-f][0-9A-Fa-f]\s*)+$/,
        V = function() {
            var e = Object(a["a"])(regeneratorRuntime.mark((function e(t, n) {
                return regeneratorRuntime.wrap((function(e) {
                    while (1) switch (e.prev = e.next) {
                    case 0:
                        return e.abrupt("return", new Promise((function(e, s) {
                            t.files[n].async("base64").then((function(t) {
                                var n = q(t);
                                e(n)
                            }), (function(e) {
                                s(e)
                            }))
                        })));
                    case 1:
                    case "end":
                        return e.stop()
                    }
                }), e)
            })));
            return function(t, n) {
                return e.apply(this, arguments)
            }
        } (),
        H = function(e) {
            var t, n = !0,
            a = Object(s["a"])(e);
            try {
                for (a.s(); ! (t = a.n()).done;) {
                    var r = t.value,
                    i = L(r.fileData, r.hashed, r.checkMethod);
                    n = n && i
                }
            } catch(u) {
                a.e(u)
            } finally {
                a.f()
            }
            return n
        },
        q = function(e) {
            try {
                var t = M.test(e) ? i.a.decode(e) : o.a.unarmor(e);
                return W(t)
            } catch(n) {
                return console.log(n),
                {}
            }
        },
        W = function(e, t) {
            t = t || 0;
            try {
                var n = $(e, t),
                s = n.toSign.eseal.esealInfo.picture.type,
                a = n.toSign.eseal.esealInfo.picture.data.byte;
                return {
                    ofdArray: a,
                    type: s.toLowerCase(),
                    SES_Signature: n,
                    verifyRet: N(n)
                }
            } catch(r) {
                return console.log(r),
                {}
            }
        },
        U = function(e) {
            e = e.replace("Unrecognized time: ", "");
            e.indexOf("Z");
            return e = e.replace("Z", ""),
            e = e.substr(0, 1) < "5" ? "20" + e: "19" + e,
            e
        },
        $ = function(e, t) {
            t = t || 0;
            var n, s = c.a.decode(e, t);
            try {
                var a, r, i, u, o, l, b, d, f, h, p, v, g, m, y, x, w, O, S, k, j, I, C, B, _, D, T, A, R, F, P, E, L, N, M, V, H, q, W, $, G, K, X, Y, Z, Q, ee, te, ne, se, ae, re, ie, ue, oe, le, ce, be, de, fe, he, pe, ve, ge, me, ye, xe, we, Oe, Se, ke, je, Ie, Ce, Be, _e, De, Te, Ae, Re, Fe, Pe, Ee, Le, Ne, Me, Ve, He, qe, We, Ue, $e, ze, Je, Ge, Ke, Xe, Ye, Ze, Qe, et = U(null === (a = s.sub[0]) || void 0 === a || null === (r = a.sub[1]) || void 0 === r || null === (i = r.sub[0]) || void 0 === i || null === (u = i.sub[2]) || void 0 === u || null === (o = u.sub[3]) || void 0 === o ? void 0 : o.stream.parseTime(s.sub[0].sub[1].sub[0].sub[2].sub[3].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[3].header, s.sub[0].sub[1].sub[0].sub[2].sub[3].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[3].header + s.sub[0].sub[1].sub[0].sub[2].sub[3].length)),
                tt = U(null === (l = s.sub[0]) || void 0 === l || null === (b = l.sub[1]) || void 0 === b || null === (d = b.sub[0]) || void 0 === d || null === (f = d.sub[2]) || void 0 === f || null === (h = f.sub[4]) || void 0 === h ? void 0 : h.stream.parseTime(s.sub[0].sub[1].sub[0].sub[2].sub[4].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[4].header, s.sub[0].sub[1].sub[0].sub[2].sub[4].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[4].header + s.sub[0].sub[1].sub[0].sub[2].sub[4].length)),
                nt = U(null === (p = s.sub[0]) || void 0 === p || null === (v = p.sub[1]) || void 0 === v || null === (g = v.sub[0]) || void 0 === g || null === (m = g.sub[2]) || void 0 === m || null === (y = m.sub[5]) || void 0 === y ? void 0 : y.stream.parseTime(s.sub[0].sub[1].sub[0].sub[2].sub[5].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[5].header, s.sub[0].sub[1].sub[0].sub[2].sub[5].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[5].header + s.sub[0].sub[1].sub[0].sub[2].sub[5].length)),
                st = U(null === (x = s.sub[0]) || void 0 === x || null === (w = x.sub[2]) || void 0 === w ? void 0 : w.stream.parseTime(s.sub[0].sub[2].stream.pos + s.sub[0].sub[2].header, s.sub[0].sub[2].stream.pos + s.sub[0].sub[2].header + s.sub[0].sub[2].length, !1)),
                at = null === (O = s.sub[0]) || void 0 === O || null === (S = O.sub[1]) || void 0 === S || null === (k = S.sub[0]) || void 0 === k || null === (j = k.sub[2]) || void 0 === j ? void 0 : j.sub[2],
                rt = new Array;
                at && at.sub.forEach((function(e) {
                    rt.push(e.stream.parseOctetString(e.stream.pos + e.header, e.stream.pos + e.header + e.length))
                }));
                var it = null === (I = s.sub[0]) || void 0 === I || null === (C = I.sub[1]) || void 0 === C || null === (B = C.sub[0]) || void 0 === B ? void 0 : B.sub[4],
                ut = new Array;
                it && it.sub.forEach((function(e) {
                    var t, n, s;
                    ut.push({
                        extnID: null === (t = e.sub[0]) || void 0 === t ? void 0 : t.stream.parseOID(e.sub[0].stream.pos + e.sub[0].header, e.sub[0].stream.pos + e.sub[0].header + e.sub[0].length),
                        critical: null === (n = e.sub[1]) || void 0 === n ? void 0 : n.stream.parseInteger(e.sub[1].stream.pos + e.sub[1].header, e.sub[1].stream.pos + e.sub[1].header + e.sub[1].length),
                        extnValue: null === (s = e.sub[2]) || void 0 === s ? void 0 : s.stream.parseOctetString(e.sub[2].stream.pos + e.sub[2].header, e.sub[2].stream.pos + e.sub[2].header + e.sub[2].length)
                    })
                })),
                n = {
                    realVersion: 1,
                    toSignDer: null === (_ = s.sub[0]) || void 0 === _ ? void 0 : _.stream.enc.subarray(s.sub[0].stream.pos, s.sub[0].stream.pos + s.sub[0].header + s.sub[0].length),
                    toSign: {
                        version: null === (D = s.sub[0]) || void 0 === D || null === (T = D.sub[0]) || void 0 === T ? void 0 : T.stream.parseInteger(s.sub[0].sub[0].stream.pos + s.sub[0].sub[0].header, s.sub[0].sub[0].stream.pos + s.sub[0].sub[0].header + s.sub[0].sub[0].length),
                        eseal: {
                            esealInfo: {
                                header: {
                                    ID: null === (A = s.sub[0]) || void 0 === A || null === (R = A.sub[1]) || void 0 === R || null === (F = R.sub[0]) || void 0 === F || null === (P = F.sub[0]) || void 0 === P || null === (E = P.sub[0]) || void 0 === E ? void 0 : E.stream.parseStringUTF(s.sub[0].sub[1].sub[0].sub[0].sub[0].stream.pos + s.sub[0].sub[1].sub[0].sub[0].sub[0].header, s.sub[0].sub[1].sub[0].sub[0].sub[0].stream.pos + s.sub[0].sub[1].sub[0].sub[0].sub[0].header + s.sub[0].sub[1].sub[0].sub[0].sub[0].length),
                                    version: null === (L = s.sub[0]) || void 0 === L || null === (N = L.sub[1]) || void 0 === N || null === (M = N.sub[0]) || void 0 === M || null === (V = M.sub[0]) || void 0 === V || null === (H = V.sub[1]) || void 0 === H ? void 0 : H.stream.parseInteger(s.sub[0].sub[1].sub[0].sub[0].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[0].sub[1].header, s.sub[0].sub[1].sub[0].sub[0].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[0].sub[1].header + s.sub[0].sub[1].sub[0].sub[0].sub[1].length),
                                    Vid: null === (q = s.sub[0]) || void 0 === q || null === (W = q.sub[1]) || void 0 === W || null === ($ = W.sub[0]) || void 0 === $ || null === (G = $.sub[0]) || void 0 === G || null === (K = G.sub[2]) || void 0 === K ? void 0 : K.stream.parseStringUTF(s.sub[0].sub[1].sub[0].sub[0].sub[2].stream.pos + s.sub[0].sub[1].sub[0].sub[0].sub[2].header, s.sub[0].sub[1].sub[0].sub[0].sub[2].stream.pos + s.sub[0].sub[1].sub[0].sub[0].sub[2].header + s.sub[0].sub[1].sub[0].sub[0].sub[2].length)
                                },
                                esID: null === (X = s.sub[0]) || void 0 === X || null === (Y = X.sub[1]) || void 0 === Y || null === (Z = Y.sub[0]) || void 0 === Z || null === (Q = Z.sub[1]) || void 0 === Q ? void 0 : Q.stream.parseStringUTF(s.sub[0].sub[1].sub[0].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[1].header, s.sub[0].sub[1].sub[0].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[1].header + s.sub[0].sub[1].sub[0].sub[1].length),
                                property: {
                                    type: null === (ee = s.sub[0]) || void 0 === ee || null === (te = ee.sub[1]) || void 0 === te || null === (ne = te.sub[0]) || void 0 === ne || null === (se = ne.sub[2]) || void 0 === se || null === (ae = se.sub[0]) || void 0 === ae ? void 0 : ae.stream.parseInteger(s.sub[0].sub[1].sub[0].sub[2].sub[0].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[0].header, s.sub[0].sub[1].sub[0].sub[2].sub[0].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[0].header + s.sub[0].sub[1].sub[0].sub[2].sub[0].length),
                                    name: null === (re = s.sub[0]) || void 0 === re || null === (ie = re.sub[1]) || void 0 === ie || null === (ue = ie.sub[0]) || void 0 === ue || null === (oe = ue.sub[2]) || void 0 === oe || null === (le = oe.sub[1]) || void 0 === le ? void 0 : le.stream.parseStringUTF(s.sub[0].sub[1].sub[0].sub[2].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[1].header, s.sub[0].sub[1].sub[0].sub[2].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[1].header + s.sub[0].sub[1].sub[0].sub[2].sub[1].length),
                                    certList: rt,
                                    createDate: et,
                                    validStart: tt,
                                    validEnd: nt
                                },
                                picture: {
                                    type: null === (ce = s.sub[0]) || void 0 === ce || null === (be = ce.sub[1]) || void 0 === be || null === (de = be.sub[0]) || void 0 === de || null === (fe = de.sub[3]) || void 0 === fe || null === (he = fe.sub[0]) || void 0 === he ? void 0 : he.stream.parseStringUTF(s.sub[0].sub[1].sub[0].sub[3].sub[0].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[0].header, s.sub[0].sub[1].sub[0].sub[3].sub[0].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[0].header + s.sub[0].sub[1].sub[0].sub[3].sub[0].length),
                                    data: {
                                        hex: null === (pe = s.sub[0]) || void 0 === pe || null === (ve = pe.sub[1]) || void 0 === ve || null === (ge = ve.sub[0]) || void 0 === ge || null === (me = ge.sub[3]) || void 0 === me || null === (ye = me.sub[1]) || void 0 === ye ? void 0 : ye.stream.parseOctetString(s.sub[0].sub[1].sub[0].sub[3].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[1].header, s.sub[0].sub[1].sub[0].sub[3].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[1].header + s.sub[0].sub[1].sub[0].sub[3].sub[1].length),
                                        byte: null === (xe = s.sub[0]) || void 0 === xe || null === (we = xe.sub[1]) || void 0 === we || null === (Oe = we.sub[0]) || void 0 === Oe || null === (Se = Oe.sub[3]) || void 0 === Se || null === (ke = Se.sub[1]) || void 0 === ke ? void 0 : ke.stream.enc.subarray(s.sub[0].sub[1].sub[0].sub[3].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[1].header, s.sub[0].sub[1].sub[0].sub[3].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[1].header + s.sub[0].sub[1].sub[0].sub[3].sub[1].length)
                                    },
                                    width: null === (je = s.sub[0]) || void 0 === je || null === (Ie = je.sub[1]) || void 0 === Ie || null === (Ce = Ie.sub[0]) || void 0 === Ce || null === (Be = Ce.sub[3]) || void 0 === Be || null === (_e = Be.sub[2]) || void 0 === _e ? void 0 : _e.stream.parseInteger(s.sub[0].sub[1].sub[0].sub[3].sub[2].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[2].header, s.sub[0].sub[1].sub[0].sub[3].sub[2].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[2].header + s.sub[0].sub[1].sub[0].sub[3].sub[2].length),
                                    height: null === (De = s.sub[0]) || void 0 === De || null === (Te = De.sub[1]) || void 0 === Te || null === (Ae = Te.sub[0]) || void 0 === Ae || null === (Re = Ae.sub[3]) || void 0 === Re || null === (Fe = Re.sub[3]) || void 0 === Fe ? void 0 : Fe.stream.parseInteger(s.sub[0].sub[1].sub[0].sub[3].sub[3].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[3].header, s.sub[0].sub[1].sub[0].sub[3].sub[3].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[3].header + s.sub[0].sub[1].sub[0].sub[3].sub[3].length)
                                },
                                extDatas: ut
                            },
                            signInfo: {
                                cert: z(null === (Pe = s.sub[0]) || void 0 === Pe || null === (Ee = Pe.sub[1]) || void 0 === Ee || null === (Le = Ee.sub[1]) || void 0 === Le ? void 0 : Le.sub[0]),
                                signatureAlgorithm: null === (Ne = s.sub[0]) || void 0 === Ne || null === (Me = Ne.sub[1]) || void 0 === Me || null === (Ve = Me.sub[1]) || void 0 === Ve || null === (He = Ve.sub[1]) || void 0 === He ? void 0 : He.stream.parseOID(s.sub[0].sub[1].sub[1].sub[1].stream.pos + s.sub[0].sub[1].sub[1].sub[1].header, s.sub[0].sub[1].sub[1].sub[1].stream.pos + s.sub[0].sub[1].sub[1].sub[1].header + s.sub[0].sub[1].sub[1].sub[1].length),
                                signData: null === (qe = s.sub[0]) || void 0 === qe || null === (We = qe.sub[1]) || void 0 === We || null === (Ue = We.sub[1]) || void 0 === Ue || null === ($e = Ue.sub[2]) || void 0 === $e ? void 0 : $e.stream.hexDump(s.sub[0].sub[1].sub[1].sub[2].stream.pos + s.sub[0].sub[1].sub[1].sub[2].header, s.sub[0].sub[1].sub[1].sub[2].stream.pos + s.sub[0].sub[1].sub[1].sub[2].header + s.sub[0].sub[1].sub[1].sub[2].length, !1)
                            }
                        },
                        timeInfo: st,
                        dataHash: null === (ze = s.sub[0]) || void 0 === ze || null === (Je = ze.sub[3]) || void 0 === Je ? void 0 : Je.stream.hexDump(s.sub[0].sub[3].stream.pos + s.sub[0].sub[3].header, s.sub[0].sub[3].stream.pos + s.sub[0].sub[3].header + s.sub[0].sub[3].length, !1),
                        propertyInfo: null === (Ge = s.sub[0]) || void 0 === Ge || null === (Ke = Ge.sub[4]) || void 0 === Ke ? void 0 : Ke.stream.parseStringUTF(s.sub[0].sub[4].stream.pos + s.sub[0].sub[4].header, s.sub[0].sub[4].stream.pos + s.sub[0].sub[4].header + s.sub[0].sub[4].length),
                        cert: z(null === (Xe = s.sub[0]) || void 0 === Xe ? void 0 : Xe.sub[5]),
                        signatureAlgorithm: null === (Ye = s.sub[0]) || void 0 === Ye || null === (Ze = Ye.sub[6]) || void 0 === Ze ? void 0 : Ze.stream.parseOID(s.sub[0].sub[6].stream.pos + s.sub[0].sub[6].header, s.sub[0].sub[6].stream.pos + s.sub[0].sub[6].header + s.sub[0].sub[6].length)
                    },
                    signature: null === (Qe = s.sub[1]) || void 0 === Qe ? void 0 : Qe.stream.hexDump(s.sub[1].stream.pos + s.sub[1].header, s.sub[1].stream.pos + s.sub[1].header + s.sub[1].length, !1)
                }
            } catch(rs) {
                try {
                    var ot, lt, ct, bt, dt, ft, ht, pt, vt, gt, mt, yt, xt, wt, Ot, St, kt, jt, It, Ct, Bt, _t, Dt, Tt, At, Rt, Ft, Pt, Et, Lt, Nt, Mt, Vt, Ht, qt, Wt, Ut, $t, zt, Jt, Gt, Kt, Xt, Yt, Zt, Qt, en, tn, nn, sn, an, rn, un, on, ln, cn, bn, dn, fn, hn, pn, vn, gn, mn, yn, xn, wn, On, Sn, kn, jn, In, Cn, Bn, _n, Dn, Tn, An, Rn, Fn, Pn, En, Ln, Nn, Mn, Vn, Hn, qn, Wn, Un, $n, zn, Jn, Gn, Kn, Xn, Yn, Zn, Qn, es = null === (ot = s.sub[0]) || void 0 === ot || null === (lt = ot.sub[1]) || void 0 === lt || null === (ct = lt.sub[0]) || void 0 === ct || null === (bt = ct.sub[2]) || void 0 === bt || null === (dt = bt.sub[2]) || void 0 === dt ? void 0 : dt.stream.parseInteger(s.sub[0].sub[1].sub[0].sub[2].sub[2].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[2].header, s.sub[0].sub[1].sub[0].sub[2].sub[2].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[2].header + s.sub[0].sub[1].sub[0].sub[2].sub[2].length),
                    ts = null === (ft = s.sub[0]) || void 0 === ft || null === (ht = ft.sub[1]) || void 0 === ht || null === (pt = ht.sub[0]) || void 0 === pt || null === (vt = pt.sub[2]) || void 0 === vt ? void 0 : vt.sub[3],
                    ns = new Array;
                    ts && ts.sub.forEach((function(e) {
                        ns.push(e.stream.parseOctetString(e.stream.pos + e.header, e.stream.pos + e.header + e.length))
                    }));
                    var ss = null === (gt = s.sub[0]) || void 0 === gt || null === (mt = gt.sub[1]) || void 0 === mt || null === (yt = mt.sub[0]) || void 0 === yt ? void 0 : yt.sub[4],
                    as = new Array;
                    ss && ss.sub.forEach((function(e) {
                        var t, n, s;
                        as.push({
                            extnID: null === (t = e.sub[0]) || void 0 === t ? void 0 : t.stream.parseOID(e.sub[0].stream.pos + e.sub[0].header, e.sub[0].stream.pos + e.sub[0].header + e.sub[0].length),
                            critical: null === (n = e.sub[1]) || void 0 === n ? void 0 : n.stream.parseInteger(e.sub[1].stream.pos + e.sub[1].header, e.sub[1].stream.pos + e.sub[1].header + e.sub[1].length),
                            extnValue: null === (s = e.sub[2]) || void 0 === s ? void 0 : s.stream.parseOctetString(e.sub[2].stream.pos + e.sub[2].header, e.sub[2].stream.pos + e.sub[2].header + e.sub[2].length)
                        })
                    })),
                    n = {
                        realVersion: 4,
                        toSignDer: null === (xt = s.sub[0]) || void 0 === xt ? void 0 : xt.stream.enc.subarray(s.sub[0].stream.pos, s.sub[0].stream.pos + s.sub[0].header + s.sub[0].length),
                        toSign: {
                            version: null === (wt = s.sub[0]) || void 0 === wt || null === (Ot = wt.sub[0]) || void 0 === Ot ? void 0 : Ot.stream.parseInteger(s.sub[0].sub[0].stream.pos + s.sub[0].sub[0].header, s.sub[0].sub[0].stream.pos + s.sub[0].sub[0].header + s.sub[0].sub[0].length),
                            eseal: {
                                esealInfo: {
                                    header: {
                                        ID: null === (St = s.sub[0]) || void 0 === St || null === (kt = St.sub[1]) || void 0 === kt || null === (jt = kt.sub[0]) || void 0 === jt || null === (It = jt.sub[0]) || void 0 === It || null === (Ct = It.sub[0]) || void 0 === Ct ? void 0 : Ct.stream.parseStringUTF(s.sub[0].sub[1].sub[0].sub[0].sub[0].stream.pos + s.sub[0].sub[1].sub[0].sub[0].sub[0].header, s.sub[0].sub[1].sub[0].sub[0].sub[0].stream.pos + s.sub[0].sub[1].sub[0].sub[0].sub[0].header + s.sub[0].sub[1].sub[0].sub[0].sub[0].length),
                                        version: null === (Bt = s.sub[0]) || void 0 === Bt || null === (_t = Bt.sub[1]) || void 0 === _t || null === (Dt = _t.sub[0]) || void 0 === Dt || null === (Tt = Dt.sub[0]) || void 0 === Tt || null === (At = Tt.sub[1]) || void 0 === At ? void 0 : At.stream.parseInteger(s.sub[0].sub[1].sub[0].sub[0].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[0].sub[1].header, s.sub[0].sub[1].sub[0].sub[0].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[0].sub[1].header + s.sub[0].sub[1].sub[0].sub[0].sub[1].length),
                                        Vid: null === (Rt = s.sub[0]) || void 0 === Rt || null === (Ft = Rt.sub[1]) || void 0 === Ft || null === (Pt = Ft.sub[0]) || void 0 === Pt || null === (Et = Pt.sub[0]) || void 0 === Et || null === (Lt = Et.sub[2]) || void 0 === Lt ? void 0 : Lt.stream.parseStringUTF(s.sub[0].sub[1].sub[0].sub[0].sub[2].stream.pos + s.sub[0].sub[1].sub[0].sub[0].sub[2].header, s.sub[0].sub[1].sub[0].sub[0].sub[2].stream.pos + s.sub[0].sub[1].sub[0].sub[0].sub[2].header + s.sub[0].sub[1].sub[0].sub[0].sub[2].length)
                                    },
                                    esID: null === (Nt = s.sub[0]) || void 0 === Nt || null === (Mt = Nt.sub[1]) || void 0 === Mt || null === (Vt = Mt.sub[0]) || void 0 === Vt || null === (Ht = Vt.sub[1]) || void 0 === Ht ? void 0 : Ht.stream.parseStringUTF(s.sub[0].sub[1].sub[0].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[1].header, s.sub[0].sub[1].sub[0].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[1].header + s.sub[0].sub[1].sub[0].sub[1].length),
                                    property: {
                                        type: null === (qt = s.sub[0]) || void 0 === qt || null === (Wt = qt.sub[1]) || void 0 === Wt || null === (Ut = Wt.sub[0]) || void 0 === Ut || null === ($t = Ut.sub[2]) || void 0 === $t || null === (zt = $t.sub[0]) || void 0 === zt ? void 0 : zt.stream.parseInteger(s.sub[0].sub[1].sub[0].sub[2].sub[0].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[0].header, s.sub[0].sub[1].sub[0].sub[2].sub[0].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[0].header + s.sub[0].sub[1].sub[0].sub[2].sub[0].length),
                                        name: null === (Jt = s.sub[0]) || void 0 === Jt || null === (Gt = Jt.sub[1]) || void 0 === Gt || null === (Kt = Gt.sub[0]) || void 0 === Kt || null === (Xt = Kt.sub[2]) || void 0 === Xt || null === (Yt = Xt.sub[1]) || void 0 === Yt ? void 0 : Yt.stream.parseStringUTF(s.sub[0].sub[1].sub[0].sub[2].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[1].header, s.sub[0].sub[1].sub[0].sub[2].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[1].header + s.sub[0].sub[1].sub[0].sub[2].sub[1].length),
                                        certListType: es,
                                        certList: ns,
                                        createDate: null === (Zt = s.sub[0]) || void 0 === Zt || null === (Qt = Zt.sub[1]) || void 0 === Qt || null === (en = Qt.sub[0]) || void 0 === en || null === (tn = en.sub[2]) || void 0 === tn || null === (nn = tn.sub[4]) || void 0 === nn ? void 0 : nn.stream.parseTime(s.sub[0].sub[1].sub[0].sub[2].sub[4].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[4].header, s.sub[0].sub[1].sub[0].sub[2].sub[4].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[4].header + s.sub[0].sub[1].sub[0].sub[2].sub[4].length),
                                        validStart: null === (sn = s.sub[0]) || void 0 === sn || null === (an = sn.sub[1]) || void 0 === an || null === (rn = an.sub[0]) || void 0 === rn || null === (un = rn.sub[2]) || void 0 === un || null === (on = un.sub[5]) || void 0 === on ? void 0 : on.stream.parseTime(s.sub[0].sub[1].sub[0].sub[2].sub[5].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[5].header, s.sub[0].sub[1].sub[0].sub[2].sub[5].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[5].header + s.sub[0].sub[1].sub[0].sub[2].sub[5].length),
                                        validEnd: null === (ln = s.sub[0]) || void 0 === ln || null === (cn = ln.sub[1]) || void 0 === cn || null === (bn = cn.sub[0]) || void 0 === bn || null === (dn = bn.sub[2]) || void 0 === dn || null === (fn = dn.sub[6]) || void 0 === fn ? void 0 : fn.stream.parseTime(s.sub[0].sub[1].sub[0].sub[2].sub[6].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[6].header, s.sub[0].sub[1].sub[0].sub[2].sub[6].stream.pos + s.sub[0].sub[1].sub[0].sub[2].sub[6].header + s.sub[0].sub[1].sub[0].sub[2].sub[6].length)
                                    },
                                    picture: {
                                        type: null === (hn = s.sub[0]) || void 0 === hn || null === (pn = hn.sub[1]) || void 0 === pn || null === (vn = pn.sub[0]) || void 0 === vn || null === (gn = vn.sub[3]) || void 0 === gn || null === (mn = gn.sub[0]) || void 0 === mn ? void 0 : mn.stream.parseStringUTF(s.sub[0].sub[1].sub[0].sub[3].sub[0].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[0].header, s.sub[0].sub[1].sub[0].sub[3].sub[0].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[0].header + s.sub[0].sub[1].sub[0].sub[3].sub[0].length),
                                        data: {
                                            hex: null === (yn = s.sub[0]) || void 0 === yn || null === (xn = yn.sub[1]) || void 0 === xn || null === (wn = xn.sub[0]) || void 0 === wn || null === (On = wn.sub[3]) || void 0 === On || null === (Sn = On.sub[1]) || void 0 === Sn ? void 0 : Sn.stream.parseOctetString(s.sub[0].sub[1].sub[0].sub[3].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[1].header, s.sub[0].sub[1].sub[0].sub[3].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[1].header + s.sub[0].sub[1].sub[0].sub[3].sub[1].length),
                                            byte: null === (kn = s.sub[0]) || void 0 === kn || null === (jn = kn.sub[1]) || void 0 === jn || null === (In = jn.sub[0]) || void 0 === In || null === (Cn = In.sub[3]) || void 0 === Cn || null === (Bn = Cn.sub[1]) || void 0 === Bn ? void 0 : Bn.stream.enc.subarray(s.sub[0].sub[1].sub[0].sub[3].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[1].header, s.sub[0].sub[1].sub[0].sub[3].sub[1].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[1].header + s.sub[0].sub[1].sub[0].sub[3].sub[1].length)
                                        },
                                        width: null === (_n = s.sub[0]) || void 0 === _n || null === (Dn = _n.sub[1]) || void 0 === Dn || null === (Tn = Dn.sub[0]) || void 0 === Tn || null === (An = Tn.sub[3]) || void 0 === An || null === (Rn = An.sub[2]) || void 0 === Rn ? void 0 : Rn.stream.parseInteger(s.sub[0].sub[1].sub[0].sub[3].sub[2].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[2].header, s.sub[0].sub[1].sub[0].sub[3].sub[2].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[2].header + s.sub[0].sub[1].sub[0].sub[3].sub[2].length),
                                        height: null === (Fn = s.sub[0]) || void 0 === Fn || null === (Pn = Fn.sub[1]) || void 0 === Pn || null === (En = Pn.sub[0]) || void 0 === En || null === (Ln = En.sub[3]) || void 0 === Ln || null === (Nn = Ln.sub[3]) || void 0 === Nn ? void 0 : Nn.stream.parseInteger(s.sub[0].sub[1].sub[0].sub[3].sub[3].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[3].header, s.sub[0].sub[1].sub[0].sub[3].sub[3].stream.pos + s.sub[0].sub[1].sub[0].sub[3].sub[3].header + s.sub[0].sub[1].sub[0].sub[3].sub[3].length)
                                    },
                                    extDatas: as
                                },
                                cert: z(null === (Mn = s.sub[0]) || void 0 === Mn || null === (Vn = Mn.sub[1]) || void 0 === Vn ? void 0 : Vn.sub[1]),
                                signAlgID: null === (Hn = s.sub[0]) || void 0 === Hn || null === (qn = Hn.sub[1]) || void 0 === qn || null === (Wn = qn.sub[2]) || void 0 === Wn ? void 0 : Wn.stream.parseOID(s.sub[0].sub[1].sub[2].stream.pos + s.sub[0].sub[1].sub[2].header, s.sub[0].sub[1].sub[2].stream.pos + s.sub[0].sub[1].sub[2].header + s.sub[0].sub[1].sub[2].length),
                                signedValue: null === (Un = s.sub[0]) || void 0 === Un || null === ($n = Un.sub[1]) || void 0 === $n || null === (zn = $n.sub[3]) || void 0 === zn ? void 0 : zn.stream.hexDump(s.sub[0].sub[1].sub[3].stream.pos + s.sub[0].sub[1].sub[3].header, s.sub[0].sub[1].sub[3].stream.pos + s.sub[0].sub[1].sub[3].header + s.sub[0].sub[1].sub[3].length, !1)
                            },
                            timeInfo: null === (Jn = s.sub[0]) || void 0 === Jn || null === (Gn = Jn.sub[2]) || void 0 === Gn ? void 0 : Gn.stream.parseTime(s.sub[0].sub[2].stream.pos + s.sub[0].sub[2].header, s.sub[0].sub[2].stream.pos + s.sub[0].sub[2].header + s.sub[0].sub[2].length, !1),
                            dataHash: null === (Kn = s.sub[0]) || void 0 === Kn || null === (Xn = Kn.sub[3]) || void 0 === Xn ? void 0 : Xn.stream.hexDump(s.sub[0].sub[3].stream.pos + s.sub[0].sub[3].header, s.sub[0].sub[3].stream.pos + s.sub[0].sub[3].header + s.sub[0].sub[3].length, !1),
                            propertyInfo: J(s.sub[0].sub[4])
                        },
                        cert: z(s.sub[1]),
                        signatureAlgID: null === (Yn = s.sub[2]) || void 0 === Yn ? void 0 : Yn.stream.parseOID(s.sub[2].stream.pos + s.sub[2].header, s.sub[2].stream.pos + s.sub[2].header + s.sub[2].length),
                        signature: null === (Zn = s.sub[3]) || void 0 === Zn ? void 0 : Zn.stream.hexDump(s.sub[3].stream.pos + s.sub[3].header, s.sub[3].stream.pos + s.sub[3].header + s.sub[3].length, !1),
                        timpStamp: null === (Qn = s.sub[4]) || void 0 === Qn ? void 0 : Qn.stream.parseTime(s.sub[4].stream.pos + s.sub[4].header, s.sub[4].stream.pos + s.sub[4].header + s.sub[4].length)
                    }
                } catch(rs) {
                    console.log(rs),
                    n = {}
                }
            }
            return n
        },
        z = function(e, t) {
            t = t || 0;
            try {
                var n, s, a = e.sub[0].sub[0].sub[5],
                r = new Map;
                a.sub.forEach((function(e) {
                    var t, n = e.sub[0].sub[0].content().split("\n")[0],
                    s = null === (t = e.sub[0].sub[1]) || void 0 === t ? void 0 : t.stream.parseStringUTF(e.sub[0].sub[1].stream.pos + e.sub[0].sub[1].header, e.sub[0].sub[1].stream.pos + e.sub[0].sub[1].header + e.sub[0].sub[1].length);
                    r.set(n, s)
                }));
                var i = e.sub[0].sub[0].sub[6];
                return {
                    subject: r,
                    commonName: r.get("2.5.4.3"),
                    subjectPublicKeyInfo: {
                        algorithm: null === (n = i.sub[0]) || void 0 === n ? void 0 : n.stream.parseOID(i.sub[0].stream.pos + i.sub[0].header, i.sub[0].stream.pos + i.sub[0].header + i.sub[0].length),
                        subjectPublicKey: null === (s = i.sub[1]) || void 0 === s ? void 0 : s.stream.hexDump(i.sub[1].stream.pos + i.sub[1].header, i.sub[1].stream.pos + i.sub[1].header + i.sub[1].length)
                    }
                }
            } catch(u) {
                return console.log(u),
                {}
            }
        },
        J = function(e) {
            for (var t = "",
            n = 0; n < e.length; n++) t += String.fromCharCode(e[n]);
            return t
        }
    },
    d00a: function(e, t, n) {
        "use strict"; (function(e) {
            n.d(t, "a", (function() {
                return a
            }));
            var s = n("53ca"),
            a = "object" === ("undefined" === typeof e ? "undefined": Object(s["a"])(e)) && e + "" === "[object process]" && !e.versions.nw && !(e.versions.electron && e.type && "browser" !== e.type)
        }).call(this, n("4362"))
    },
    e12b: function(e, t, n) {
        "use strict";
        n("ed1a")
    },
    ed1a: function(e, t, n) {}
});