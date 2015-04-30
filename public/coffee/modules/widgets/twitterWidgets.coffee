`!function() {
    var t;
    Function && Function.prototype && Function.prototype.bind && (/MSIE [678]/.test(navigator.userAgent) || !function e(t, n, i) {
        function r(o, a) {
            if (!n[o]) {
                if (!t[o]) {
                    var c = "function" == typeof require && require;
                    if (!a && c) return c(o, !0);
                    if (s) return s(o, !0);
                    var u = new Error("Cannot find module '" + o + "'");
                    throw u.code = "MODULE_NOT_FOUND", u
                }
                var d = n[o] = {
                    exports: {}
                };
                t[o][0].call(d.exports, function(e) {
                    var n = t[o][1][e];
                    return r(n ? n : e)
                }, d, d.exports, e, t, n, i)
            }
            return n[o].exports
        }
        for (var s = "function" == typeof require && require, o = 0; o < i.length; o++) {
            r(i[o]);
        }
        return r
    }({
        1: [function(e, n, i) {
                (function() {
                    "use strict";
                    function e(t) {
                        return "function" == typeof t || "object" == typeof t && null !== t
                    }
                    function i(t) {
                        return "function" == typeof t
                    }
                    function r(t) {
                        return "object" == typeof t && null !== t
                    }
                    function s() {
                    }
                    function o() {
                        return function() {
                            process.nextTick(d)
                        }
                    }
                    function a() {
                        var t = 0,
                            e = new j(d),
                            n = document.createTextNode("");return e.observe(n, {
                                characterData: !0
                            }), function() {
                                n.data = t = ++t % 2
                        }
                    }
                    function c() {
                        var t = new MessageChannel;return t.port1.onmessage = d, function() {
                                t.port2.postMessage(0)
                        }
                    }
                    function u() {
                        return function() {
                            setTimeout(d, 1)
                        }
                    }
                    function d() {
                        for (var t = 0; k > t; t += 2) {
                            var e = q[t],
                                n = q[t + 1];e(n), q[t] = void 0, q[t + 1] = void 0
                        }
                        k = 0
                    }
                    function h() {
                    }
                    function l() {
                        return new TypeError("You cannot resolve a promise with itself")
                    }
                    function f() {
                        return new TypeError("A promises callback cannot return that same promise.")
                    }
                    function p(t) {
                        try {
                            return t.then
                        } catch ( e ) {
                            return V.error = e, V
                        }
                    }
                    function m(t, e, n, i) {
                        try {
                            t.call(e, n, i)
                        } catch ( r ) {
                            return r
                        }
                    }
                    function g(t, e, n) {
                        H(function(t) {
                            var i = !1,
                                r = m(n, e, function(n) {
                                    i || (i = !0, e !== n ? w(t, n) : _(t, n))
                                }, function(e) {
                                        i || (i = !0, A(t, e))
                                    }, "Settle: " + (t._label || " unknown promise"));
                            !i && r && (i = !0, A(t, r))
                        }, t)
                    }
                    function v(t, e) {
                        e._state === z ? _(t, e._result) : t._state === B ? A(t, e._result) : E(e, void 0, function(e) {
                            w(t, e)
                        }, function(e) {
                                A(t, e)
                            })
                    }
                    function y(t, e) {
                        if (e.constructor === t.constructor) {
                            v(t, e);
                        } else {
                            var n = p(e);
                            n === V ? A(t, V.error) : void 0 === n ? _(t, e) : i(n) ? g(t, e, n) : _(t, e)
                        }
                    }
                    function w(t, n) {
                        t === n ? A(t, l()) : e(n) ? y(t, n) : _(t, n)
                    }
                    function b(t) {
                        t._onerror && t._onerror(t._result), T(t)
                    }
                    function _(t, e) {
                        t._state === F && (t._result = e, t._state = z, 0 === t._subscribers.length || H(T, t))
                    }
                    function A(t, e) {
                        t._state === F && (t._state = B, t._result = e, H(b, t))
                    }
                    function E(t, e, n, i) {
                        var r = t._subscribers,
                            s = r.length;t._onerror = null, r[s] = e, r[s + z] = n, r[s + B] = i, 0 === s && t._state && H(T, t)
                    }
                    function T(t) {
                        var e = t._subscribers,
                            n = t._state;
                        if (0 !== e.length) {
                            for (var i, r, s = t._result, o = 0; o < e.length; o += 3) {
                                i = e[o], r = e[o + n], i ? D(n, i, r, s) : r(s);
                            }
                            t._subscribers.length = 0
                        }
                    }
                    function x() {
                        this.error = null
                    }
                    function I(t, e) {
                        try {
                            return t(e)
                        } catch ( n ) {
                            return G.error = n, G
                        }
                    }
                    function D(t, e, n, r) {
                        var s, o, a, c,
                            u = i(n);
                        if (u) {
                            if (s = I(n, r), s === G ? (c = !0, o = s.error, s = null) : a = !0, e === s) return void A(e, f())
                        } else {
                            s = r, a = !0;
                        }
                        e._state !== F || (u && a ? w(e, s) : c ? A(e, o) : t === z ? _(e, s) : t === B && A(e, s))
                    }
                    function N(t, e) {
                        try {
                            e(function(e) {
                                w(t, e)
                            }, function(e) {
                                    A(t, e)
                                })
                        } catch ( n ) {
                            A(t, n)
                        }
                    }
                    function S(t, e, n, i) {
                        this._instanceConstructor = t, this.promise = new t(h, i), this._abortOnReject = n, this._validateInput(e) ? (this._input = e, this.length = e.length, this._remaining = e.length, this._init(), 0 === this.length ? _(this.promise, this._result) : (this.length = this.length || 0, this._enumerate(), 0 === this._remaining && _(this.promise, this._result))) : A(this.promise, this._validationError())
                    }
                    function C() {
                        throw new TypeError("You must pass a resolver function as the first argument to the promise constructor")
                    }
                    function R() {
                        throw new TypeError("Failed to construct 'Promise': Please use the 'new' operator, this object constructor cannot be called as a function.")
                    }
                    function P(t) {
                        this._id = X++, this._state = void 0, this._result = void 0, this._subscribers = [], h !== t && (i(t) || C(), this instanceof P || R(), N(this, t))
                    }
                    var L;
                    L = Array.isArray ? Array.isArray : function(t) {
                        return "[object Array]" === Object.prototype.toString.call(t)
                    };
                    var M,
                        O = L,
                        k = (Date.now || function() {
                            return (new Date).getTime()
                        }, Object.create || function(t) {
                            if (arguments.length > 1)
                                throw new Error("Second argument not supported");
                            if ("object" != typeof t)
                                throw new TypeError("Argument must be an object");
                            return s.prototype = t, new s
                        }, 0),
                        H = function(t, e) {
                            q[k] = t, q[k + 1] = e, k += 2, 2 === k && M()
                        },
                        W = "undefined" != typeof window ? window : {},
                        j = W.MutationObserver || W.WebKitMutationObserver,
                        U = "undefined" != typeof Uint8ClampedArray && "undefined" != typeof importScripts && "undefined" != typeof MessageChannel,
                        q = new Array(1e3);
                    M = "undefined" != typeof process && "[object process]" === {}.toString.call(process) ? o() : j ? a() : U ? c() : u();
                    var F = void 0,
                        z = 1,
                        B = 2,
                        V = new x,
                        G = new x;
                    S.prototype._validateInput = function(t) {
                        return O(t)
                    }, S.prototype._validationError = function() {
                        return new Error("Array Methods must be provided an Array")
                    }, S.prototype._init = function() {
                        this._result = new Array(this.length)
                    };
                    var $ = S;
                    S.prototype._enumerate = function() {
                        for (var t = this.length, e = this.promise, n = this._input, i = 0; e._state === F && t > i; i++) {
                            this._eachEntry(n[i], i)
                        }
                    }, S.prototype._eachEntry = function(t, e) {
                        var n = this._instanceConstructor;
                        r(t) ? t.constructor === n && t._state !== F ? (t._onerror = null, this._settledAt(t._state, e, t._result)) : this._willSettleAt(n.resolve(t), e) : (this._remaining--, this._result[e] = this._makeResult(z, e, t))
                    }, S.prototype._settledAt = function(t, e, n) {
                        var i = this.promise;
                        i._state === F && (this._remaining--, this._abortOnReject && t === B ? A(i, n) : this._result[e] = this._makeResult(t, e, n)), 0 === this._remaining && _(i, this._result)
                    }, S.prototype._makeResult = function(t, e, n) {
                        return n
                    }, S.prototype._willSettleAt = function(t, e) {
                        var n = this;
                        E(t, void 0, function(t) {
                            n._settledAt(z, e, t)
                        }, function(t) {
                                n._settledAt(B, e, t)
                            })
                    };
                    var J = function(t, e) {
                            return new $(this, t, !0, e).promise
                        },
                        K = function(t, e) {
                            function n(t) {
                                w(s, t)
                            }
                            function i(t) {
                                A(s, t)
                            }
                            var r = this,
                                s = new r(h, e);
                            if (!O(t)) return A(s, new TypeError("You must pass an array to race.")), s;
                            for (var o = t.length, a = 0; s._state === F && o > a; a++) {
                                E(r.resolve(t[a]), void 0, n, i);
                            }
                            return s
                        },
                        Y = function(t, e) {
                            var n = this;
                            if (t && "object" == typeof t && t.constructor === n) return t;
                            var i = new n(h, e);
                            return w(i, t), i
                        },
                        Q = function(t, e) {
                            var n = this,
                                i = new n(h, e);
                            return A(i, t), i
                        },
                        X = 0,
                        Z = P;
                    P.all = J, P.race = K, P.resolve = Y, P.reject = Q, P.prototype = {
                        constructor: P,
                        then: function(t, e) {
                            var n = this,
                                i = n._state;
                            if (i === z && !t || i === B && !e) return this;
                            var r = new this.constructor(h),
                                s = n._result;
                            if (i) {
                                var o = arguments[i - 1];
                                H(function() {
                                    D(i, r, o, s)
                                })
                            } else {
                                E(n, r, t, e);
                            }
                            return r
                        },
                        "catch": function(t) {
                            return this.then(null, t)
                        }
                    };
                    var tt = function() {
                            var t;
                            t = "undefined" != typeof global ? global : "undefined" != typeof window && window.document ? window : self;
                            var e = "Promise" in t && "resolve" in t.Promise && "reject" in t.Promise && "all" in t.Promise && "race" in t.Promise && function() {
                                    var e;
                                    return new t.Promise(function(t) {
                                            e = t
                                        }), i(e)
                                }();
                            e || (t.Promise = Z)
                        },
                        et = {
                            Promise: Z,
                            polyfill: tt
                        };
                    "function" == typeof t && t.amd ? t(function() {
                        return et
                    }) : "undefined" != typeof n && n.exports ? n.exports = et : "undefined" != typeof this && (this.ES6Promise = et)
                }).call(this)
        }, {}],
        2: [function(t, e, n) {
                function i(t, e) {
                    var n;return e = e || o, (n = e.requestAnimationFrame || e.webkitRequestAnimationFrame || e.mozRequestAnimationFrame || e.msRequestAnimationFrame || e.oRequestAnimationFrame || function() {
                            e.setTimeout(function() {
                                t(+new Date)
                            }, 1e3 / 60)
                        })(t)
                }
                function r(t, e) {
                    return Math.sin(Math.PI / 2 * e) * t
                }
                function s(t, e, n, r, s) {
                    function o() {
                        var c = +new Date,
                            u = c - a,
                            d = Math.min(u / n, 1),
                            h = r ? r(e, d) : e * d,
                            l = 1 == d;t(h, l), l || i(o, s)
                    }
                    var a = +new Date;i(o)
                }
                var o = t(12);
                e.exports = {
                    animate: s,
                    requestAnimationFrame: i,
                    easeOut: r
                }
            }, {
            12: 12
        }],
        3: [function(t, e, n) {
                function i() {
                    return a.builtUrl(u)
                }
                function r(t) {
                    return "dark" === t ? "dark" : "light"
                }
                function s(t, e, n) {
                    var i, s;return n = r(n), i = o.isRtlLang(e) ? "rtl" : "ltr", s = [t, c.css, n, i, "css"].join("."), a.base() + "/css/" + s
                }
                var o = t(19),
                    a = t(37),
                    c = t(77),
                    u = "embed/timeline.css";
                e.exports = {
                    tweet: s.bind(null, "tweet"),
                    timeline: i,
                    video: s.bind(null, "video")
                }
            }, {
            19: 19,
            37: 37,
            77: 77
        }],
        4: [function(t, e, n) {
                function i(t) {
                    return new RegExp("\\b" + t + "\\b", "g")
                }
                function r(t, e) {
                    return t.classList ? void t.classList.add(e) : void (i(e).test(t.className) || (t.className += " " + e))
                }
                function s(t, e) {
                    return t.classList ? void t.classList.remove(e) : void (t.className = t.className.replace(i(e), " "))
                }
                function o(t, e, n) {
                    return void 0 === n && t.classList && t.classList.toggle ? t.classList.toggle(e, n) : (n ? r(t, e) : s(t, e), n)
                }
                function a(t, e, n) {
                    return t.classList && c(t, e) ? (s(t, e), void r(t, n)) : void (t.className = t.className.replace(i(e), n))
                }
                function c(t, e) {
                    return t.classList ? t.classList.contains(e) : i(e).test(t.className)
                }
                e.exports = {
                    add: r,
                    remove: s,
                    replace: a,
                    toggle: o,
                    present: c
                }
        }, {}],
        5: [function(t, e, n) {
                function i(t) {
                    var e = t.getAttribute("data-twitter-event-id");return e ? e : (t.setAttribute("data-twitter-event-id", ++m), m)
                }
                function r(t, e, n) {
                    var i = 0,
                        r = t && t.length || 0;
                    for (i = 0; r > i; i++) {
                        t[i].call(e, n)
                    }
                }
                function s(t, e, n) {
                    for (var i = n || t.target || t.srcElement, o = i.className.split(" "), a = 0, c = o.length; c > a; a++) {
                        r(e["." + o[a]], i, t);
                    }
                    r(e[i.tagName], i, t), t.cease || i !== this && s.call(this, t, e, i.parentElement || i.parentNode)
                }
                function o(t, e, n, i) {
                    function r(i) {
                        s.call(t, i, n[e])
                    }
                    a(t, r, e, i), t.addEventListener(e, r, !1)
                }
                function a(t, e, n, i) {
                    t.id && (g[t.id] = g[t.id] || [], g[t.id].push({
                        el: t,
                        listener: e,
                        type: n,
                        rootId: i
                    }))
                }
                function c(t) {
                    var e = g[t];e && (e.forEach(function(t) {
                        t.el.removeEventListener(t.type, t.listener, !1),
                        delete p[t.rootId]
                    }),
                    delete g[t]
                    )
                }
                function u(t, e, n, r) {
                    var s = i(t);p[s] = p[s] || {}, p[s][e] || (p[s][e] = {}, o(t, e, p[s], s)), p[s][e][n] = p[s][e][n] || [], p[s][e][n].push(r)
                }
                function d(t, e, n) {
                    var r = i(e),
                        o = p[r] && p[r];s.call(e, {
                        target: n
                    }, o[t])
                }
                function h(t) {
                    return f(t), l(t), !1
                }
                function l(t) {
                    t && t.preventDefault ? t.preventDefault() : t.returnValue = !1
                }
                function f(t) {
                    t && (t.cease = !0) && t.stopPropagation ? t.stopPropagation() : t.cancelBubble = !0
                }
                var p = {},
                    m = -1,
                    g = {};
                e.exports = {
                    stop: h,
                    stopPropagation: f,
                    preventDefault: l,
                    delegate: u,
                    simulate: d,
                    removeDelegatesForWidget: c
                }
        }, {}],
        6: [function(t, e, n) {
                function i(t) {
                    var e = t.charAt(0);return "." === e ? function(e) {
                        var n = e.className ? e.className.split(/\s+/) : [];
                        return s.contains(n, t.slice(1))
                    } : "#" === e ? function(e) {
                        return e.id === t.slice(1)
                    } : function(e) {
                        return e.tagName === t.toUpperCase()
                    }
                }
                function r(t, e, n) {
                    var o;
                    if (e) return n = n || e && e.ownerDocument, o = s.isType("function", t) ? t : i(t), e === n ? o(e) ? e : void 0 : o(e) ? e : r(o, e.parentNode, n)
                }
                var s = t(74);
                e.exports = {
                    closest: r
                }
            }, {
            74: 74
        }],
        7: [function(t, e, n) {
                function i(t) {
                    return t = t || r, t.getSelection && t.getSelection().toString()
                }
                var r = t(12);
                e.exports = {
                    getSelection: i
                }
            }, {
            12: 12
        }],
        8: [function(t, e, n) {
                function i(t) {
                    return t && 1 === t.nodeType ? t.offsetWidth || i(t.parentNode) : 0
                }
                e.exports = {
                    effectiveWidth: i
                }
        }, {}],
        9: [function(t, e, n) {
                e.exports = document
        }, {}],
        10: [function(t, e, n) {
                e.exports = location
        }, {}],
        11: [function(t, e, n) {
                e.exports = navigator
        }, {}],
        12: [function(t, e, n) {
                e.exports = window
        }, {}],
        13: [function(t, e, n) {
                function i(t, e, n) {
                    e.ready = t.then.bind(t), n && Array.isArray(e[n]) && (e[n].forEach(t.then.bind(t)),
                    delete e[n]
                    )
                }
                e.exports = {
                    exposeReadyPromise: i
                }
        }, {}],
        14: [function(t, e, n) {
                function i(t) {
                    return a.isType("string", t) ? t.split(".") : a.isType("array", t) ? t : []
                }
                function r(t, e) {
                    var n = i(e),
                        r = n.slice(0, -1);return r.reduce(function(t, e, n) {
                        if (t[e] = t[e] || {}, !a.isObject(t[e]))
                            throw new Error(r.slice(0, n + 1).join(".") + " is already defined with a value.");
                        return t[e]
                    }, t)
                }
                function s(t, e) {
                    e = e || o, e[t] = e[t] || {}, Object.defineProperty(this, "base", {
                        value: e[t]
                    }), Object.defineProperty(this, "name", {
                        value: t
                    })
                }
                var o = t(12),
                    a = t(74);
                a.aug(s.prototype, {
                    get: function(t) {
                        var e = i(t);
                        return e.reduce(function(t, e) {
                            return a.isObject(t) ? t[e] : void 0
                        }, this.base)
                    },
                    set: function(t, e, n) {
                        var s = i(t),
                            o = r(this.base, t),
                            a = s.slice(-1);
                        return n && a in o ? o[a] : o[a] = e
                    },
                    init: function(t, e) {
                        return this.set(t, e, !0)
                    },
                    unset: function(t) {
                        var e = i(t),
                            n = this.get(e.slice(0, -1));
                        n &&
                        delete n[e.slice(-1)]
                    },
                    aug: function(t) {
                        var e = this.get(t),
                            n = a.toRealArray(arguments).slice(1);
                        if (e = "undefined" != typeof e ? e : {}, n.unshift(e), !n.every(a.isObject))
                            throw new Error("Cannot augment non-object.");
                        return this.set(t, a.aug.apply(null, n))
                    },
                    call: function(t) {
                        var e = this.get(t),
                            n = a.toRealArray(arguments).slice(1);
                        if (!a.isType("function", e))
                            throw new Error("Function " + t + "does not exist.");
                        return e.apply(null, n)
                    },
                    fullPath: function(t) {
                        var e = i(t);
                        return e.unshift(this.name), e.join(".")
                    }
                }), e.exports = s
            }, {
            12: 12,
            74: 74
        }],
        15: [function(t, e, n) {
                function i(t) {
                    var e, n, i,
                        r = 0;
                    for (s = {}, t = t || o, e = t.getElementsByTagName("meta"); n = e[r]; r++) {
                        /^twitter:/.test(n.name) && (i = n.name.replace(/^twitter:/, ""), s[i] = n.content)
                    }
                }
                function r(t) {
                    return s[t]
                }
                var s,
                    o = t(9);
                i(), e.exports = {
                    init: i,
                    val: r
                }
            }, {
            9: 9
        }],
        16: [function(t, e, n) {
                var i = t(14);
                e.exports = new i("__twttr")
            }, {
            14: 14
        }],
        17: [function(t, e, n) {
                var i = t(14);
                e.exports = new i("twttr")
            }, {
            14: 14
        }],
        18: [function(t, e, n) {
                e.exports = ["hi", "zh-cn", "fr", "zh-tw", "msa", "fil", "fi", "sv", "pl", "ja", "ko", "de", "it", "pt", "es", "ru", "id", "tr", "da", "no", "nl", "hu", "fa", "ar", "ur", "he", "th", "cs", "uk", "vi", "ro", "bn"]
        }, {}],
        19: [function(t, e, n) {
                function i(t) {
                    return t = String(t).toLowerCase(), r.contains(s, t)
                }
                var r = t(74),
                    s = ["ar", "fa", "he", "ur"];
                e.exports = {
                    isRtlLang: i
                }
            }, {
            74: 74
        }],
        20: [function(t, e, n) {
                function i(t) {
                    var e = ~o.host.indexOf("poptip.com") ? "https://poptip.com" : o.href,
                        n = "original_referer=" + e;return [t, n].join(-1 == t.indexOf("?") ? "?" : "&")
                }
                function r(t) {
                    var e, n;t.altKey || t.metaKey || t.shiftKey || (e = c.closest(function(t) {
                        return "A" === t.tagName || "AREA" === t.tagName
                    }, t.target), e && d.isIntentURL(e.href) && (n = i(e.href), n = n.replace(/^http[:]/, "https:"), n = n.replace(/^\/\//, "https://"), u.open(n, e), a.preventDefault(t)))
                }
                function s(t) {
                    t.addEventListener("click", r, !1)
                }
                var o = t(10),
                    a = t(5),
                    c = t(6),
                    u = t(46),
                    d = t(70);
                e.exports = {
                    attachTo: s
                }
            }, {
            10: 10,
            46: 46,
            5: 5,
            6: 6,
            70: 70
        }],
        21: [function(t, e, n) {
                function i(t) {
                    var e = [];return l.forIn(t, function(t, n) {
                            e.push(t + "=" + n)
                        }), e.join(",")
                }
                function r() {
                    return f + h.generate()
                }
                function s(t, e) {
                    function n(t) {
                        return Math.round(t / 2)
                    }
                    return t > e ? {
                        coordinate: 0,
                        size: e
                    } : {
                        coordinate: n(e) - n(t),
                        size: t
                    }
                }
                function o(t, e, n) {
                    var r, o;e = a.parse(e), n = n || {}, r = s(e.width, n.width || p), e.left = r.coordinate, e.width = r.size, o = s(e.height, n.height || m), e.top = o.coordinate, e.height = o.size, this.win = t, this.features = i(e)
                }
                var a,
                    c = t(12),
                    u = t(63),
                    d = t(70),
                    h = t(72),
                    l = t(74),
                    f = "intent_",
                    p = c.screen.width,
                    m = c.screen.height;
                a = (new u).defaults({
                    width: 550,
                    height: 520,
                    personalbar: "0",
                    toolbar: "0",
                    location: "1",
                    scrollbars: "1",
                    resizable: "1"
                }), o.prototype.open = function(t) {
                    return d.isTwitterURL(t) ? (this.name = r(), this.popup = this.win.open(t, this.name, this.features), this) : void 0
                }, o.open = function(t, e) {
                    var n = new o(c, e);
                    return n.open(t)
                }, e.exports = o
            }, {
            12: 12,
            63: 63,
            70: 70,
            72: 72,
            74: 74
        }],
        22: [function(t, e, n) {
                function i(t) {
                    u[t] = +new Date
                }
                function r(t) {
                    return u[t] ? +new Date - u[t] : null
                }
                function s(t, e, n, i, s) {
                    var a = r(e);a && o(t, n, i, a, s)
                }
                function o(t, e, n, i, r) {
                    var s,
                        o = void 0 === r ? d : r;100 * Math.random() > o || (n = c.aug(n || {}, {
                        duration_ms: i
                    }), s = {
                        page: e,
                        component: "performance",
                        action: t
                    }, a.clientEvent(s, n, !0))
                }
                var a = t(32),
                    c = t(74),
                    u = {},
                    d = 1;
                e.exports = {
                    start: i,
                    end: r,
                    track: o,
                    endAndTrack: s
                }
            }, {
            32: 32,
            74: 74
        }],
        23: [function(t, e, n) {
                function i(t) {
                    if (!t)
                        throw new Error("JsonRpcClient requires a dispatcher");
                    this.idIterator = 0, this.dispatcher = t, this.idPrefix = String(+new Date) + a++
                }
                function r(t) {
                    var e = {
                        jsonrpc: o,
                        method: t
                    };return arguments.length > 1 && (e.params = [].slice.call(arguments, 1)), e
                }
                var s = t(66),
                    o = "2.0",
                    a = 0;
                i.prototype._generateId = function() {
                    return this.idPrefix + this.idIterator++
                }, i.prototype.notify = function() {
                    this.dispatcher.send(r.apply(null, arguments))
                }, i.prototype.request = function() {
                    var t = r.apply(null, arguments);
                    return t.id = this._generateId(), this.dispatcher.send(t).then(function(t) {
                            return "result" in t ? t.result : s.reject(t.error)
                        })
                }, e.exports = i
            }, {
            66: 66
        }],
        24: [function(t, e, n) {
                e.exports = {
                    PARSE_ERROR: {
                        code: -32700,
                        message: "Parse error"
                    },
                    INVALID_REQUEST: {
                        code: -32600,
                        message: "Invalid Request"
                    },
                    INVALID_PARAMS: {
                        code: -32602,
                        message: "Invalid params"
                    },
                    METHOD_NOT_FOUND: {
                        code: -32601,
                        message: "Method not found"
                    },
                    INTERNAL_ERROR: {
                        code: -32603,
                        message: "Internal error"
                    }
                }
        }, {}],
        25: [function(t, e, n) {
                function i(t) {
                    this.registry = t || {}
                }
                function r(t) {
                    return l.isType("string", t) ? JSON.parse(t) : t
                }
                function s(t) {
                    var e, n, i;return l.isObject(t) ? (e = t.jsonrpc === m, n = l.isType("string", t.method), i = !("id" in t) || o(t.id), e && n && i) : !1
                }
                function o(t) {
                    var e, n, i;return e = l.isType("string", t), n = l.isType("number", t), i = null === t, e || n || i
                }
                function a(t) {
                    return l.isObject(t) && !l.isType("function", t)
                }
                function c(t, e) {
                    return {
                        jsonrpc: m,
                        id: t,
                        result: e
                    }
                }
                function u(t, e) {
                    return {
                        jsonrpc: m,
                        id: o(t) ? t : null,
                        error: e
                    }
                }
                function d(t) {
                    return f.all(t).then(function(t) {
                        return t = t.filter(function(t) {
                                return void 0 !== t
                            }), t.length ? t : void 0
                    })
                }
                var h = t(24),
                    l = t(74),
                    f = t(66),
                    p = t(67),
                    m = "2.0";
                i.prototype._invoke = function(t, e) {
                    var n, i, r;
                    n = this.registry[t.method], i = t.params || [], i = l.isType("array", i) ? i : [i];try {
                        r = n.apply(e.source || null, i)
                    } catch ( s ) {
                        r = f.reject(s.message)
                    } return p.isPromise(r) ? r : f.resolve(r)
                }, i.prototype._processRequest = function(t, e) {
                    function n(e) {
                        return c(t.id, e)
                    }
                    function i() {
                        return u(t.id, h.INTERNAL_ERROR)
                    }
                    var r;
                    return s(t) ? (r = "params" in t && !a(t.params) ? f.resolve(u(t.id, h.INVALID_PARAMS)) : this.registry[t.method] ? this._invoke(t, {
                        source: e
                    }).then(n, i) : f.resolve(u(t.id, h.METHOD_NOT_FOUND)), null != t.id ? r : f.resolve()) : f.resolve(u(t.id, h.INVALID_REQUEST))
                }, i.prototype.attachReceiver = function(t) {
                    return t.attachTo(this), this
                }, i.prototype.bind = function(t, e) {
                    return this.registry[t] = e, this
                }, i.prototype.receive = function(t, e) {
                    var n, i, s,
                        o = this;
                    try {
                        t = r(t)
                    } catch ( a ) {
                        return f.resolve(u(null, h.PARSE_ERROR))
                    } return e = e || null, n = l.isType("array", t), i = n ? t : [t], s = i.map(function(t) {
                            return o._processRequest(t, e)
                        }), n ? d(s) : s[0]
                }, e.exports = i
            }, {
            24: 24,
            66: 66,
            67: 67,
            74: 74
        }],
        26: [function(t, e, n) {
                function i(t, e, n) {
                    var i;t && t.postMessage && (m ? i = (n || "") + JSON.stringify(e) : n ? (i = {}, i[n] = e) : i = e, t.postMessage(i, "*"))
                }
                function r(t) {
                    return f.isType("string", t) ? t : "JSONRPC"
                }
                function s(t, e) {
                    return e ? f.isType("string", t) && 0 === t.indexOf(e) ? t.substring(e.length) : t[e] ? t[e] : void 0 : t
                }
                function o(t, e) {
                    var n = t.document;this.filter = r(e), this.server = null, this.isTwitterFrame = p.isTwitterURL(n.location.href), t.addEventListener("message", this._onMessage.bind(this), !1)
                }
                function a(t, e) {
                    this.pending = {}, this.target = t, this.isTwitterHost = p.isTwitterURL(u.href), this.filter = r(e), d.addEventListener("message", this._onMessage.bind(this), !1)
                }
                function c(t) {
                    return arguments.length > 0 && (m = !!t), m
                }
                var u = t(10),
                    d = t(12),
                    h = t(65),
                    l = t(57),
                    f = t(74),
                    p = t(70),
                    m = l.ie9();
                f.aug(o.prototype, {
                    _onMessage: function(t) {
                        var e,
                            n = this;
                        this.server && (!this.isTwitterFrame || p.isTwitterURL(t.origin)) && (e = s(t.data, this.filter), e && this.server.receive(e, t.source).then(function(e) {
                            e && i(t.source, e, n.filter)
                        }))
                    },
                    attachTo: function(t) {
                        this.server = t
                    },
                    detach: function() {
                        this.server = null
                    }
                }), f.aug(a.prototype, {
                    _processResponse: function(t) {
                        var e = this.pending[t.id];
                        e && (e.resolve(t),
                        delete this.pending[t.id]
                        )
                    },
                    _onMessage: function(t) {
                        var e;
                        if ((!this.isTwitterHost || p.isTwitterURL(t.origin)) && (e = s(t.data, this.filter))) {
                            if (f.isType("string", e)) try {
                                    e = JSON.parse(e)
                                } catch ( n ) {
                                    return
                            } e = f.isType("array", e) ? e : [e], e.forEach(this._processResponse.bind(this))
                        }
                    },
                    send: function(t) {
                        var e = new h;
                        return t.id ? this.pending[t.id] = e : e.resolve(), i(this.target, t, this.filter), e.promise
                    }
                }), e.exports = {
                    Receiver: o,
                    Dispatcher: a,
                    _stringifyPayload: c
                }
            }, {
            10: 10,
            12: 12,
            57: 57,
            65: 65,
            70: 70,
            74: 74
        }],
        27: [function(t, e, n) {
                function i(t, e, n, i) {
                    var o,
                        u = this;this.readyDeferred = new s, this.attrs = t || {}, this.styles = e || {}, this.appender = n || function(t) {
                        r.body.appendChild(t)
                    }, this.layout = i || function(t) {
                        return c.resolve(t())
                    }, this.frame = o = a(this.attrs, this.styles), o.onreadystatechange = o.onload = this.getCallback(this.onLoad), this.layout(function() {
                        u.appender(o)
                    })
                }
                var r = t(9),
                    s = t(65),
                    o = t(57),
                    a = t(60),
                    c = t(66),
                    u = t(16),
                    d = 0;
                i.prototype.getCallback = function(t) {
                    var e = this,
                        n = !1;
                    return function() {
                        n || (n = !0, t.call(e))
                    }
                }, i.prototype.registerCallback = function(t) {
                    var e = "cb" + d++;
                    return u.set(["sandbox", e], t), e
                }, i.prototype.onLoad = function() {
                    try {
                        this.document = this.frame.contentWindow.document
                    } catch ( t ) {
                        return void this.setDocDomain()
                    } this.writeStandardsDoc(), this.readyDeferred.resolve(this)
                }, i.prototype.ready = function() {
                    return this.readyDeferred.promise
                }, i.prototype.setDocDomain = function() {
                    var t = this,
                        e = a(this.attrs, this.styles),
                        n = this.registerCallback(this.getCallback(this.onLoad));
                    e.src = ["javascript:", 'document.write("");', "try { window.parent.document; }", "catch (e) {", 'document.domain="' + r.domain + '";', "}", "window.parent." + u.fullPath(["sandbox", n]) + "();"].join(""), this.layout(function() {
                        t.frame.parentNode.removeChild(t.frame), t.frame = null, t.appender ? t.appender(e) : r.body.appendChild(e), t.frame = e
                    })
                }, i.prototype.writeStandardsDoc = function() {
                    if (o.anyIE() && !o.cspEnabled()) {
                        var t = ["<!DOCTYPE html>", "<html>", "<head>", "<scr", "ipt>", "try { window.parent.document; }", 'catch (e) {document.domain="' + r.domain + '";}', "</scr", "ipt>", "</head>", "<body></body>", "</html>"].join("");
                        this.document.write(t), this.document.close()
                    }
                }, e.exports = i
            }, {
            16: 16,
            57: 57,
            60: 60,
            65: 65,
            66: 66,
            9: 9
        }],
        28: [function(t, e, n) {
                function i() {
                    var t, e;y = {}, o || (t = a.body.offsetHeight, e = a.body.offsetWidth, (t != b || e != w) && (v.forEach(function(t) {
                        t.dispatchFrameResize(w, b)
                    }), b = t, w = e))
                }
                function r(t) {
                    var e;return t.id ? t.id : (e = t.getAttribute("data-twttr-id")) ? e : (e = "twttr-sandbox-" + g++, t.setAttribute("data-twttr-id", e), e)
                }
                function s(t, e) {
                    var n = this;d.apply(this, [t, e]), this._resizeHandlers = [], v = v.filter(function(t) {
                        var e = t._frame.parentElement;
                        return e || f.async(function() {
                                p.removeDelegatesForWidget(t._frame.id)
                            }), e
                    }), v.push(this), this._win.addEventListener("resize", function() {
                        n.dispatchFrameResize()
                    }, !1)
                }
                var o,
                    a = t(9),
                    c = t(12),
                    u = t(27),
                    d = t(29),
                    h = t(57),
                    l = t(66),
                    f = t(74),
                    p = t(5),
                    m = t(4),
                    g = 0,
                    v = [],
                    y = {},
                    w = 0,
                    b = 0;
                c.addEventListener("resize", i, !1), s.prototype = new d, f.aug(s.prototype, {
                    dispatchFrameResize: function() {
                        var t = this._frame.parentNode,
                            e = r(t),
                            n = y[e];
                        o = !0, this._resizeHandlers.length && (n || (n = y[e] = {
                            w: this._frame.offsetWidth,
                            h: this._frame.offsetHeight
                        }), (this._frameWidth != n.w || this._frameHeight != n.h) && (this._frameWidth = n.w, this._frameHeight = n.h, this._resizeHandlers.forEach(function(t) {
                            t(n.w, n.h)
                        }), c.setTimeout(function() {
                            y = {}
                        }, 50)))
                    },
                    addClass: function(t) {
                        var e = this._doc.documentElement;
                        return this.layout(function() {
                            m.add(e, t)
                        })
                    },
                    appendStyleSheet: function(t, e) {
                        var n = this,
                            i = this._doc.createElement("link");
                        return i.type = "text/css", i.rel = "stylesheet", i.href = t, e && (i.onload = e), this.layout(function() {
                                return n._head.appendChild(i)
                            })
                    },
                    removeStyleSheet: function(t) {
                        var e,
                            n = this;
                        return e = 'link[rel="stylesheet"][href="' + t + '"]', this.layout(function() {
                                var t = n._doc.querySelector(e);
                                return t && n._head.removeChild(t)
                            })
                    },
                    appendCss: function(t) {
                        var e,
                            n = this;
                        return h.cspEnabled() ? l.reject("CSP enabled; cannot embed inline styles.") : (e = this._doc.createElement("style"), e.type = "text/css", e.styleSheet ? e.styleSheet.cssText = t : e.appendChild(this._doc.createTextNode(t)), this.layout(function() {
                            return n._head.appendChild(e)
                        }))
                    },
                    style: function(t, e) {
                        var n = this;
                        return this.layout(function() {
                            e && (n._frame.style.cssText = ""), f.forIn(t, function(t, e) {
                                n._frame.style[t] = e
                            })
                        })
                    },
                    onresize: function(t) {
                        this._resizeHandlers.push(t)
                    },
                    width: function(t) {
                        return void 0 !== t && (this._frame.style.width = t + "px"), h.ios() ? Math.min(this._frame.parentNode.offsetWidth, this._frame.offsetWidth) : this._frame.offsetWidth
                    },
                    height: function(t) {
                        return void 0 !== t && (this._frame.height = t), this._frame.offsetHeight
                    },
                    contentHeight: function() {
                        return this._doc.body.firstChild.offsetHeight
                    },
                    hasContent: function() {
                        return !!this._doc.body.firstChild
                    },
                    resizeToContent: function() {
                        var t = this;
                        return this.layout(function() {
                            return t.height(t.contentHeight())
                        })
                    }
                }), s.createSandbox = function(t, e, n, i) {
                    var r = new u(t, e, n, i);
                    return r.ready().then(function(t) {
                        return new s(t.frame, t.layout)
                    })
                }, e.exports = s
            }, {
            12: 12,
            27: 27,
            29: 29,
            4: 4,
            5: 5,
            57: 57,
            66: 66,
            74: 74,
            9: 9
        }],
        29: [function(t, e, n) {
                function i(t, e) {
                    t && (this._frame = t, this._win = t.contentWindow, this._doc = this._win.document, this._body = this._doc.body, this._head = this._body.parentNode.children[0], this.layout = e, this.root = this._doc.documentElement, this.root.className = "SandboxRoot")
                }
                var r = t(27),
                    s = t(74);
                s.aug(i.prototype, {
                    createElement: function(t) {
                        return this._doc.createElement(t)
                    },
                    createDocumentFragment: function() {
                        return this._doc.createDocumentFragment()
                    },
                    appendChild: function(t) {
                        var e = this;
                        return this.layout(function() {
                            return e._body.appendChild(t)
                        })
                    },
                    setBaseTarget: function(t) {
                        var e = this,
                            n = this._doc.createElement("base");
                        return n.target = t, this.layout(function() {
                                return e._head.appendChild(n)
                            })
                    },
                    setTitle: function(t) {
                        t && (this._frame.title = t)
                    },
                    element: function() {
                        return this._frame
                    },
                    document: function() {
                        return this._doc
                    }
                }), i.createSandbox = function(t, e, n, s) {
                    var o = new r(t, e, n, s);
                    return o.ready().then(function(t) {
                        return new i(t.frame, t.layout)
                    })
                }, e.exports = i
            }, {
            27: 27,
            74: 74
        }],
        30: [function(t, e, n) {
                function i() {
                    return d.formatGenericEventData("syndicated_impression", {})
                }
                function r() {
                    c("tweet")
                }
                function s() {
                    c("timeline")
                }
                function o() {
                    c("video")
                }
                function a() {
                    c("partnertweet")
                }
                function c(t) {
                    h.isHostPageSensitive() || l[t] || (l[t] = !0, u.scribe(d.formatClientEventNamespace({
                        page: t,
                        action: "impression"
                    }), i(), d.AUDIENCE_ENDPOINT))
                }
                var u = t(32),
                    d = t(33),
                    h = t(69),
                    l = {};
                e.exports = {
                    scribePartnerTweetAudienceImpression: a,
                    scribeTweetAudienceImpression: r,
                    scribeTimelineAudienceImpression: s,
                    scribeVideoAudienceImpression: o
                }
            }, {
            32: 32,
            33: 33,
            69: 69
        }],
        31: [function(t, e, n) {
                function i() {
                    return x ? I.promise : (m.createSandbox({
                        id: "rufous-sandbox"
                    }, {
                            display: "none"
                        }).then(function(t) {
                        l = t, d = c(), h = u(), I.resolve([d, h])
                    }), x = !0, I.promise)
                }
                function r(t, e) {
                    var n, i, r;w.isObject(t) && w.isObject(e) && (r = y.flattenClientEventPayload(t, e), n = d.firstChild, n.value = +(+n.value || r.dnt || 0), i = l.createElement("input"), i.type = "hidden", i.name = "l", i.value = y.stringify(r), d.appendChild(i))
                }
                function s(t, e, n) {
                    var i = !w.isObject(t),
                        s = e ? !w.isObject(e) : !1;i || s || I.promise.then(function() {
                        r(y.formatClientEventNamespace(t), y.formatClientEventData(e, n))
                    })
                }
                function o() {
                    return I.promise.then(function() {
                        if (d.children.length <= 2) return v.reject();
                        var t = v.all([l.appendChild(d), l.appendChild(h)]).then(function(t) {
                            var e = t[0],
                                n = t[1];
                            return n.addEventListener("load", function() {
                                    a(e, n)(), b.get("events").trigger("logFlushed")
                                }), e.submit(), t
                        });
                        return d = c(), h = u(), t
                    })
                }
                function a(t, e) {
                    return function() {
                        var n = t.parentNode;
                        n && (n.removeChild(t), n.removeChild(e))
                    }
                }
                function c() {
                    var t = l.createElement("form"),
                        e = l.createElement("input"),
                        n = l.createElement("input");return T++, t.action = y.CLIENT_EVENT_ENDPOINT, t.method = "POST", t.target = A + T, t.id = E + T, e.type = "hidden", e.name = "dnt", e.value = p.enabled(), n.type = "hidden", n.name = "tfw_redirect", n.value = y.RUFOUS_REDIRECT, t.appendChild(e), t.appendChild(n), t
                }
                function u() {
                    var t = A + T;return f({
                        id: t,
                        name: t,
                        width: 0,
                        height: 0,
                        border: 0
                    }, {
                            display: "none"
                        }, l.document())
                }
                var d, h, l,
                    f = t(60),
                    p = t(56),
                    m = t(29),
                    g = t(65),
                    v = t(66),
                    y = t(33),
                    w = t(74),
                    b = t(17),
                    _ = Math.floor(1e3 * Math.random()) + "_",
                    A = "rufous-frame-" + _ + "-",
                    E = "rufous-form-" + _ + "-",
                    T = 0,
                    x = !1,
                    I = new g;
                e.exports = {
                    clientEvent: s,
                    flush: o,
                    init: i
                }
            }, {
            17: 17,
            29: 29,
            33: 33,
            56: 56,
            60: 60,
            65: 65,
            66: 66,
            74: 74
        }],
        32: [function(t, e, n) {
                function i(t, e, n) {
                    return r(t, e, n, 2)
                }
                function r(t, e, n, i) {
                    var r = !p.isObject(t),
                        s = e ? !p.isObject(e) : !1;r || s || o(f.formatClientEventNamespace(t), f.formatClientEventData(e, n, i), f.CLIENT_EVENT_ENDPOINT)
                }
                function s(t, e, n, i) {
                    var s = f.extractTermsFromDOM(t.target || t.srcElement);s.action = i || "click", r(s, e, n)
                }
                function o(t, e, n) {
                    var i, r;n && p.isObject(t) && p.isObject(e) && (i = f.flattenClientEventPayload(t, e), r = {
                        l: f.stringify(i)
                    }, i.dnt && (r.dnt = 1), d(l.url(n, r)))
                }
                function a(t, e, n, i) {
                    var r,
                        s = !p.isObject(t),
                        o = e ? !p.isObject(e) : !1;
                    if (!s && !o) return r = f.flattenClientEventPayload(f.formatClientEventNamespace(t), f.formatClientEventData(e, n, i)), c(r)
                }
                function c(t) {
                    return g.push(t), g
                }
                function u() {
                    var t, e,
                        n = l.url(f.CLIENT_EVENT_ENDPOINT, {
                            dnt: 0,
                            l: ""
                        }),
                        i = encodeURIComponent(n).length;return g.length > 1 && a({
                            page: "widgets_js",
                            component: "scribe_pixel",
                            action: "batch_log"
                        }, {}), t = g, g = [], e = t.reduce(function(e, n, r) {
                            var s, o,
                                a = e.length,
                                c = a && e[a - 1],
                                u = r + 1 == t.length;
                            return u && n.event_namespace && "batch_log" == n.event_namespace.action && (n.message = ["entries:" + r, "requests:" + a].join("/")), s = f.stringify(n), o = encodeURIComponent(s).length + 3, i + o > m ? e : ((!c || c.urlLength + o > m) && (c = {
                                    urlLength: i,
                                    items: []
                                }, e.push(c)), c.urlLength += o, c.items.push(s), e)
                        }, []), e.map(function(t) {
                            var e = {
                                l: t.items
                            };
                            return h.enabled() && (e.dnt = 1), d(l.url(f.CLIENT_EVENT_ENDPOINT, e))
                        })
                }
                function d(t) {
                    var e = new Image;return e.src = t
                }
                var h = t(56),
                    l = t(68),
                    f = t(33),
                    p = t(74),
                    m = 2083,
                    g = [];
                e.exports = {
                    _enqueueRawObject: c,
                    scribe: o,
                    clientEvent: r,
                    clientEvent2: i,
                    enqueueClientEvent: a,
                    flushClientEvents: u,
                    interaction: s
                }
            }, {
            33: 33,
            56: 56,
            68: 68,
            74: 74
        }],
        33: [function(t, e, n) {
                function i(t, e) {
                    var n;return e = e || {}, t && t.nodeType === Node.ELEMENT_NODE ? ((n = t.getAttribute("data-scribe")) && n.split(" ").forEach(function(t) {
                            var n = t.trim().split(":"),
                                i = n[0],
                                r = n[1];
                            i && r && !e[i] && (e[i] = r)
                        }), i(t.parentNode, e)) : e
                }
                function r(t) {
                    return h.aug({
                        client: "tfw"
                    }, t || {})
                }
                function s(t, e, n) {
                    var i = t && t.widget_origin || u.referrer;return t = o("tfw_client_event", t, i), t.client_version = p, t.format_version = void 0 !== n ? n : 1, e || (t.widget_origin = i), t
                }
                function o(t, e, n) {
                    return e = e || {}, h.aug(e, {
                            _category_: t,
                            triggered_on: e.triggered_on || +new Date,
                            dnt: d.enabled(n)
                        })
                }
                function a(t, e) {
                    return h.aug({}, e, {
                        event_namespace: t
                    })
                }
                function c(t) {
                    var e,
                        n = Array.prototype.toJSON;return delete Array.prototype.toJSON
                        , e = JSON.stringify(t), n && (Array.prototype.toJSON = n), e
                }
                var u = t(9),
                    d = t(56),
                    h = t(74),
                    l = t(76),
                    f = t(16),
                    p = l.version,
                    m = f.get("endpoints.rufous") || "https://syndication.twitter.com/i/jot",
                    g = f.get("endpoints.rufousAudience") || "https://syndication.twitter.com/i/jot/syndication",
                    v = f.get("endpoints.rufousRedirect") || "https://platform.twitter.com/jot.html";
                e.exports = {
                    extractTermsFromDOM: i,
                    flattenClientEventPayload: a,
                    formatGenericEventData: o,
                    formatClientEventData: s,
                    formatClientEventNamespace: r,
                    stringify: c,
                    AUDIENCE_ENDPOINT: g,
                    CLIENT_EVENT_ENDPOINT: m,
                    RUFOUS_REDIRECT: v
                }
            }, {
            16: 16,
            56: 56,
            74: 74,
            76: 76,
            9: 9
        }],
        34: [function(t, e, n) {
                function i(t, e, n, i) {
                    return t = t || [], n = n || {}, function() {
                            var r, s, c, d,
                                h = Array.prototype.slice.apply(arguments, [0, t.length]),
                                l = Array.prototype.slice.apply(arguments, [t.length]);
                            return l.forEach(function(t) {
                                    return t ? 1 === t.nodeType ? void (c = t) : o.isType("function", t) ? void (r = t) : void (o.isType("object", t) && (s = t)) : void 0
                                }), h.length != t.length || 0 === l.length ? (r && o.async(function() {
                                    r(!1)
                                }), a.reject("Not enough parameters")) : c ? (s = o.aug(s || {}, n), s.targetEl = c, t.forEach(function(t) {
                                    s[t] = h.shift()
                                }), d = new e(s), u.doLayout(), d.render(), i && i(), r && d.completed().then(r, function() {
                                    r(!1)
                                }), d.completed()) : (r && o.async(function() {
                                    r(!1)
                                }), a.reject("No target specified"))
                    }
                }
                function r(t) {
                    var e;t.linkColor = t.linkColor || t.previewParams.link_color, t.theme = t.theme || t.previewParams.theme, t.height = t.height || t.previewParams.height, e = new p(t), this.render = e.render.bind(e), this.completed = e.completed.bind(e)
                }
                var s = t(12),
                    o = t(74),
                    a = t(66),
                    c = t(70),
                    u = t(43),
                    d = t(49),
                    h = t(45),
                    l = t(44),
                    f = t(50),
                    p = t(48),
                    m = i(["url"], d, {
                        type: "share"
                    }),
                    g = i(["hashtag"], d, {
                        type: "hashtag"
                    }),
                    v = i(["screenName"], d, {
                        type: "mention"
                    }),
                    y = i(["screenName"], h),
                    w = i(["tweetId"], l, {}, l.fetchAndRender),
                    b = i(["tweetId"], f, {}, f.fetchAndRender),
                    _ = i(["widgetId"], p),
                    A = i(["previewParams"], r),
                    E = {
                        createShareButton: m,
                        createMentionButton: v,
                        createHashtagButton: g,
                        createFollowButton: y,
                        createTweet: w,
                        createVideo: b,
                        createTweetEmbed: w,
                        createTimeline: _
                    };
                c.isTwitterURL(s.location.href) && (E.createTimelinePreview = A), e.exports = E
            }, {
            12: 12,
            43: 43,
            44: 44,
            45: 45,
            48: 48,
            49: 49,
            50: 50,
            66: 66,
            70: 70,
            74: 74
        }],
        35: [function(t, e, n) {
                function i(t, e) {
                    var n = u.connect({
                        src: t,
                        iframe: {
                            name: e,
                            style: "position:absolute;top:-9999em;width:10px;height:10px"
                        }
                    });return d(n).expose({
                            trigger: function(t, e, n) {
                                e = e || {};
                                var i = e.region;
                                delete e.region
                                , f.get("events").trigger(t, {
                                    target: h.find(n),
                                    data: e,
                                    region: i,
                                    type: t
                                })
                            },
                            initXPHub: function() {
                                s(!0)
                            }
                        }), n
                }
                function r(t) {
                    return t ? l.secureHubId : l.contextualHubId
                }
                function s(t) {
                    var e = c.base(t) + "/widgets/hub.f15fe2cd70788a40560e69fa17341d5e.html",
                        n = r(t);
                    if (!a.getElementById(n)) return i(e, n)
                }
                function o(t, e) {
                    var n = u.connect({
                        window: {
                            width: 550,
                            height: 450
                        },
                        src: t
                    });d(n).expose({
                        trigger: function(t, n) {
                            f.get("events").trigger(t, {
                                target: e,
                                region: "intent",
                                type: t,
                                data: n
                            })
                        }
                    })
                }
                var a = t(9),
                    c = t(37),
                    u = t(83),
                    d = t(82),
                    h = t(43),
                    l = t(75),
                    f = t(17);
                e.exports = {
                    init: s,
                    openIntent: o
                }
            }, {
            17: 17,
            37: 37,
            43: 43,
            75: 75,
            82: 82,
            83: 83,
            9: 9
        }],
        36: [function(t, e, n) {
                function i() {
                    return s !== s.top ? r.request(h).then(function(t) {
                        o.rootDocumentLocation(t.url), t.dnt && a.setOn()
                    }) : void 0
                }
                var r,
                    s = t(12),
                    o = t(54),
                    a = t(56),
                    c = t(25),
                    u = t(23),
                    d = t(26),
                    h = "twttr.private.requestArticleUrl",
                    l = "twttr.article";
                s === s.top ? (new c).attachReceiver(new d.Receiver(s, l)).bind(h, function() {
                    return {
                        url: o.rootDocumentLocation(),
                        dnt: a.enabled()
                    }
                }) : r = new u(new d.Dispatcher(s.top, l)), e.exports = {
                    requestArticleUrl: i
                }
            }, {
            12: 12,
            23: 23,
            25: 25,
            26: 26,
            54: 54,
            56: 56
        }],
        37: [function(t, e, n) {
                function i(t, e) {
                    var n,
                        i = u[t];return "embed/timeline.css" === t && c.contains(s.href, "localhost.twitter.com") ? "/node_modules/syndication-templates/lib/css/index.css" : (n = a.retina() ? "2x" : "default",
                    e && (n += ".rtl"), r() + "/" + i[n])
                }
                function r(t) {
                    var e = o.get("host");return d(t) + "://" + e
                }
                var s = t(10),
                    o = t(16),
                    a = t(57),
                    c = t(74),
                    u = {
                        "embed/timeline.css": {
                            "default": "embed/timeline.438399f9c19919ece063ecfc9ead5a7c.default.css",
                            "2x": "embed/timeline.438399f9c19919ece063ecfc9ead5a7c.2x.css",
                            gif: "embed/timeline.438399f9c19919ece063ecfc9ead5a7c.gif.css",
                            "default.rtl": "embed/timeline.438399f9c19919ece063ecfc9ead5a7c.default.rtl.css",
                            "2x.rtl": "embed/timeline.438399f9c19919ece063ecfc9ead5a7c.2x.rtl.css",
                            "gif.rtl": "embed/timeline.438399f9c19919ece063ecfc9ead5a7c.gif.rtl.css"
                        }
                    },
                    d = function() {
                        return /^http\:$/.test(s.protocol) ? function(t) {
                            return t ? "https" : "http"
                        } : function() {
                            return "https"
                        }
                    }();
                e.exports = {
                    builtUrl: i,
                    base: r
                }
            }, {
            10: 10,
            16: 16,
            57: 57,
            74: 74
        }],
        38: [function(t, e, n) {
                function i(t) {
                    return function(e) {
                        e.error ? t.error && t.error(e) : e.headers && 200 != e.headers.status ? (t.error && t.error(e), u.warn(e.headers.message)) : t.success && t.success(e), t.complete && t.complete(e), r(t)
                    }
                }
                function r(t) {
                    var e = t.script;e && (e.onload = e.onreadystatechange = null, e.parentNode && e.parentNode.removeChild(e), t.script = void 0, e = void 0), t.callbackName && c.unset(["callbacks", t.callbackName])
                }
                function s(t) {
                    var e = {};return t.success && d.isType("function", t.success) && (e.success = t.success), t.error && d.isType("function", t.error) && (e.error = t.error), t.complete && d.isType("function", t.complete) && (e.complete = t.complete), e
                }
                var o = t(9),
                    a = t(10),
                    c = t(16),
                    u = t(62),
                    d = t(74),
                    h = t(68),
                    l = "cb",
                    f = 0,
                    p = !1,
                    m = {},
                    g = d.aug({
                        tweets: "https://syndication.twitter.com/tweets.json",
                        timeline: "https://cdn.syndication.twimg.com/widgets/timelines/",
                        timelinePoll: "https://syndication.twitter.com/widgets/timelines/paged/",
                        timelinePreview: "https://syndication.twitter.com/widgets/timelines/preview/",
                        videos: "https://syndication.twitter.com/widgets/video/"
                    }, c.get("endpoints") || {});
                m.jsonp = function(t, e, n) {
                    var r = n || l + f,
                        s = c.fullPath(["callbacks", r]),
                        u = o.createElement("script"),
                        d = {
                            callback: s,
                            suppress_response_codes: !0
                        };
                    c.set(["callbacks", r], i(e)), (p || !/^https?\:$/.test(a.protocol)) && (t = t.replace(/^\/\//, "https://")), u.src = h.url(t, d), u.async = "async", o.body.appendChild(u), e.script = u, e.callbackName = r, n || f++
                }, m.config = function(t) {
                    (t.forceSSL === !0 || t.forceSSL === !1) && (p = t.forceSSL)
                }, m.tweets = function(t) {
                    var e,
                        n = s(t),
                        i = {
                            ids: t.ids.join(","),
                            lang: t.lang,
                            new_html: !0
                        };
                    e = h.url(g.tweets, i), this.jsonp(e, n)
                }, m.videos = function(t) {
                    var e = s(t),
                        n = {
                            ids: t.ids.join(","),
                            lang: t.lang
                        },
                        i = h.url(g.videos, n);
                    this.jsonp(i, e)
                }, m.timeline = function(t) {
                    var e,
                        n = s(t),
                        i = 9e5,
                        r = Math.floor(+new Date / i),
                        o = {
                            lang: t.lang,
                            t: r,
                            domain: a.host,
                            dnt: t.dnt,
                            override_type: t.overrideType,
                            override_id: t.overrideId,
                            override_name: t.overrideName,
                            override_owner_id: t.overrideOwnerId,
                            override_owner_name: t.overrideOwnerName,
                            with_replies: t.withReplies
                        };
                    d.compact(o), e = h.url(g.timeline + t.id, o), this.jsonp(e, n, "tl_" + t.id + "_" + t.instanceId)
                }, m.timelinePoll = function(t) {
                    var e,
                        n = s(t),
                        i = {
                            lang: t.lang,
                            since_id: t.sinceId,
                            max_id: t.maxId,
                            min_position: t.minPosition,
                            max_position: t.maxPosition,
                            domain: a.host,
                            dnt: t.dnt,
                            override_type: t.overrideType,
                            override_id: t.overrideId,
                            override_name: t.overrideName,
                            override_owner_id: t.overrideOwnerId,
                            override_owner_name: t.overrideOwnerName,
                            with_replies: t.withReplies
                        };
                    d.compact(i), e = h.url(g.timelinePoll + t.id, i), this.jsonp(e, n, "tlPoll_" + t.id + "_" + t.instanceId + "_" + (t.sinceId || t.maxId || t.maxPosition || t.minPosition))
                }, m.timelinePreview = function(t) {
                    var e = s(t),
                        n = t.params,
                        i = h.url(g.timelinePreview, n);
                    this.jsonp(i, e)
                }, e.exports = m
            }, {
            10: 10,
            16: 16,
            62: 62,
            68: 68,
            74: 74,
            9: 9
        }],
        39: [function(t, e, n) {
                function i() {
                    var t = 36e5,
                        e = o.combined(s)._;return void 0 !== r ? r : (r = !1, e && /^\d+$/.test(e) && (r = +new Date - parseInt(e) < t), r)
                }
                var r,
                    s = t(10),
                    o = t(64);
                e.exports = {
                    isDynamicWidget: i
                }
            }, {
            10: 10,
            64: 64
        }],
        40: [function(t, e, n) {
                function i(t, e) {
                    return 2 == t || 3 == t && 0 === +e
                }
                function r(t) {
                    var e = t.split(" ");this.url = decodeURIComponent(e[0].trim()), this.width = +e[1].replace(/w$/, "").trim()
                }
                function s(t, e, n) {
                    var i, s, o, a;
                    if (t = f.devicePixelRatio ? t * f.devicePixelRatio : t, s = e.split(",").map(function(t) {
                            return new r(t.trim())
                        }), n)
                        for (a = 0; a < s.length; a++) {
                            s[a].url === n && (i = s[a]);
                    }
                    return o = s.reduce(function(e, n) {
                            return n.width < e.width && n.width >= t ? n : e
                        }, s[0]), i && i.width > o.width ? i : o
                }
                function o(t, e) {
                    var n,
                        i = t.getAttribute("data-srcset"),
                        r = t.src;i && (n = s(e, i, r), t.src = n.url)
                }
                function a(t, e) {
                    e = void 0 !== e ? !!e : m.retina(), p.toRealArray(t.getElementsByTagName("IMG")).forEach(function(t) {
                        var n = t.getAttribute("data-src-1x") || t.getAttribute("src"),
                            i = t.getAttribute("data-src-2x");
                        e && i ? t.src = i : n && (t.src = n)
                    })
                }
                function c(t, e, n, r) {
                    var s = 0,
                        a = t.querySelector(".multi-photo"),
                        c = a && +a.getAttribute("data-photo-count");
                    if (t) return p.toRealArray(t.querySelectorAll(".NaturalImage-image")).forEach(function(t) {
                                r(function() {
                                    o(t, e)
                                })
                            }), p.toRealArray(t.querySelectorAll(".CroppedImage-image")).forEach(function(t) {
                                r(function() {
                                    o(t, e / 2)
                                })
                            }), (m.ios() || m.android()) && p.toRealArray(t.querySelectorAll(".FilledIframe")).forEach(function(t) {
                                r(function() {
                                    d(t, {
                                        width: t.offsetWidth,
                                        height: t.offsetHeight
                                    })
                                })
                            }), p.toRealArray(t.querySelectorAll(".autosized-media")).forEach(function(t) {
                                var i = u(t.getAttribute("data-width"), t.getAttribute("data-height"), e, n);
                                r(function() {
                                    o(t, e), t.width = i.width, t.height = i.height, d(t, i)
                                }), s = i.height > s ? i.height : s
                            }), p.toRealArray(t.querySelectorAll("img.cropped-media")).forEach(function(t) {
                                var a, d, h,
                                    l = e - 12,
                                    f = t.parentNode,
                                    p = t.getAttribute("data-crop-x") || 0,
                                    m = t.getAttribute("data-crop-y") || 0,
                                    g = i(c, t.getAttribute("data-image-index")),
                                    b = Math.floor(l / 2 - v),
                                    _ = Math.floor(b / (g ? y : w));
                                g || (_ -= v / 2), h = u(t.getAttribute("data-width"), t.getAttribute("data-height"), b, n, b, _), a = h.width - b - p, d = h.height - _ - m, 0 > a && Math.max(0, p += a), 0 > d && Math.max(0, m += d), r(function() {
                                    o(t, b), t.width = h.width, t.height = h.height, f.style.width = b - 1 + "px", f.style.height = _ + "px", p && (t.style.marginLeft = "-" + Math.floor(h.width * p / 100) + "px"), m && (t.style.marginTop = "-" + Math.floor(h.height * m / 100) + "px")
                                }), s = h.height * (g ? 2 : 1) > s ? h.height : s
                            }), s
                }
                function u(t, e, n, i, r, s) {
                    return n = n || t, i = i || e, r = r || 0, s = s || 0, t > n && (e *= n / t, t = n), e > i && (t *= i / e, e = i), r > t && (e *= r / t, t = r), s > e && (t *= s / e, e = s), {
                            width: Math.floor(t),
                            height: Math.floor(e)
                    }
                }
                function d(t, e) {
                    function n() {
                        var t = {
                            name: "tfw:resize",
                            dimensions: e
                        };r.postMessage(t, "*")
                    }
                    var i, r, s, o, a;t && (r = t.contentWindow, i = t.ownerDocument && t.ownerDocument.defaultView, s = m.ios() || m.android(), o = g.isTwitterURL(t.src), a = r && m.canPostMessage(r), s && o && a && (n(), i && i.addEventListener("message", function(t) {
                        "tfw:requestsize" === t.data && n()
                    }, !1)))
                }
                function h(t, e, n, i) {
                    p.toRealArray(t.querySelectorAll(e)).forEach(function(t) {
                        var e = t.getAttribute("style") || t.getAttribute("data-style"),
                            r = i.test(e) && RegExp.$1;
                        r && (t.setAttribute("data-csp-fix", !0), t.style[n] = r)
                    })
                }
                function l(t) {
                    m.cspEnabled() && (h(t, ".MediaCard-widthConstraint", "maxWidth", b), h(t, ".MediaCard-mediaContainer", "paddingBottom", x), h(t, ".CroppedImage-image", "marginTop", E), h(t, ".CroppedImage-image", "marginLeft", T), h(t, ".CroppedImage-image", "top", _), h(t, ".CroppedImage-image", "left", A))
                }
                var f = t(12),
                    p = t(74),
                    m = t(57),
                    g = t(70),
                    v = 6,
                    y = 8 / 9,
                    w = 16 / 9,
                    b = /max-width:\s*([\d\.]+px)/,
                    _ = /top:\s*(\-?[\d\.]+%)/,
                    A = /left:\s*(\-?[\d\.]+%)/,
                    E = /margin-top:\s*(\-?[\d\.]+%)/,
                    T = /margin-left:\s*(\-?[\d\.]+%)/,
                    x = /padding-bottom:\s*([\d\.]+%)/;
                e.exports = {
                    scaleDimensions: u,
                    retinize: a,
                    constrainMedia: c,
                    fixMediaCardLayout: l,
                    __setSrcFromSet: o
                }
            }, {
            12: 12,
            57: 57,
            70: 70,
            74: 74
        }],
        41: [function(t, e, n) {
                var i = t(68),
                    r = t(70);
                e.exports = function(t, e) {
                    return function(n) {
                        var s, o,
                            a = "data-tw-params";
                        if (n && r.isTwitterURL(n.href) && !n.getAttribute(a)) {
                            if (n.setAttribute(a, !0), "function" == typeof e) {
                                s = e.call(this, n);
                                for (o in s) s.hasOwnProperty(o) && (t[o] = s[o])
                            }
                            n.href = i.url(n.href, t)
                        }
                    }
                }
            }, {
            68: 68,
            70: 70
        }],
        42: [function(t, e, n) {
                function i() {
                    (new o).attachReceiver(new a.Receiver(r, "twttr.resize")).bind("twttr.private.resizeButton", function(t) {
                        var e = u(this),
                            n = e && e.id,
                            i = n && s.findInstance(n),
                            r = c.asInt(t.width),
                            o = c.asInt(t.height);
                        i && r && o && i.setInitialSize(r, o)
                    })
                }
                var r = t(12),
                    s = t(43),
                    o = t(25),
                    a = t(26),
                    c = t(71),
                    u = t(59);
                e.exports = i
            }, {
            12: 12,
            25: 25,
            26: 26,
            43: 43,
            59: 59,
            71: 71
        }],
        43: [function(t, e, n) {
                function i(t) {
                    var e;t && (t.ownerDocument ? (this.srcEl = t, this.classAttr = t.className.split(" ")) : (this.srcOb = t, this.classAttr = []), e = this.params(), this.id = this.generateId(), this.setLanguage(), this.related = e.related || this.dataAttr("related"), this.partner = e.partner || this.dataAttr("partner") || y.val("partner"), this.styleAttr = [], this.targetEl = t.targetEl, g.asBoolean(e.dnt || this.dataAttr("dnt")) && w.setOn(), x[this.id] = this, this.completeDeferred = new h, this.completed().then(function(t) {
                        t && t != a.body && A.get("events").trigger("rendered", {
                            target: t
                        })
                    }))
                }
                function r() {
                    I.forEach(function(t) {
                        t()
                    }), i.doLayout()
                }
                function s(t) {
                    return t ? t.lang ? t.lang : s(t.parentNode) : void 0
                }
                var o,
                    a = t(9),
                    c = t(12),
                    u = t(37),
                    d = t(22),
                    h = t(65),
                    l = t(60),
                    f = t(61),
                    p = t(66),
                    m = t(68),
                    g = t(71),
                    v = t(74),
                    y = t(15),
                    w = t(56),
                    b = t(62),
                    _ = t(54),
                    A = t(17),
                    E = t(18),
                    T = 0,
                    x = {},
                    I = [],
                    D = new f,
                    N = "data-twttr-rendered";
                v.aug(i.prototype, {
                    setLanguage: function(t) {
                        var e;
                        return t || (t = this.params().lang || this.dataAttr("lang") || s(this.srcEl)), (t = t && t.toLowerCase()) ? v.contains(E, t) ? this.lang = t : (e = t.replace(/[\-_].*/, ""), v.contains(E, t) ? this.lang = e : void (this.lang = "en")) : this.lang = "en"
                    },
                    ringo: function(t, e, n) {
                        return n = n || /\{\{([\w_]+)\}\}/g, t.replace(n, function(t, n) {
                                return void 0 !== e[n] ? e[n] : t
                            })
                    },
                    makeIframeSource: function() {
                        if (this.iframeSource) {
                            var t = m.encode(this.widgetUrlParams());
                            return [u.base(), "/", this.ringo(this.iframeSource, {
                                    lang: this.lang
                            }), "#", t].join("")
                        }
                    },
                    add: function(t) {
                        x[this.id] = t
                    },
                    create: function(t, e) {
                        var n,
                            i = this;
                        return e[N] = !0, n = l(v.aug({
                                id: this.id,
                                src: t,
                                "class": this.classAttr.join(" ")
                            }, e), {
                                    position: "absolute",
                                    visibility: "hidden"
                                }, this.targetEl && this.targetEl.ownerDocument), this.srcEl ? this.layout(function() {
                                return i.srcEl.parentNode.replaceChild(n, i.srcEl), n
                            }) : this.targetEl ? this.layout(function() {
                                return i.targetEl.appendChild(n), n
                            }) : p.reject("Did not append widget")
                    },
                    setInitialSize: function(t, e) {
                        var n = this,
                            i = this.element;
                        return i ? void this.layout(function() {
                            n.width = t, n.height = e, i.style.width = t + "px", i.style.height = e + "px", i.style.position = "static", i.style.visibility = "visible"
                        }).then(function() {
                            n.completeDeferred.resolve(i)
                        }) : !1
                    },
                    params: function() {
                        var t, e;
                        return this.srcOb ? e = this.srcOb : (t = this.srcEl && this.srcEl.href && this.srcEl.href.split("?")[1], e = t ? m.decode(t) : {}), this.params = function() {
                                return e
                            }, e
                    },
                    widgetUrlParams: function() {
                        return {}
                    },
                    dataAttr: function(t) {
                        return this.srcEl && this.srcEl.getAttribute("data-" + t)
                    },
                    attr: function(t) {
                        return this.srcEl && this.srcEl.getAttribute(t)
                    },
                    layout: function(t) {
                        return D.enqueue(t)
                    },
                    generateId: function() {
                        return this.srcEl && this.srcEl.id || "twitter-widget-" + T++
                    },
                    completed: function() {
                        return this.completeDeferred ? this.completeDeferred.promise : void 0
                    }
                }), i.afterLoad = function(t) {
                    I.push(t)
                }, i.doLayout = function() {
                    D.exec()
                }, i.doLayoutAsync = function() {
                    D.delayedExec()
                }, i.init = function(t) {
                    o = t
                }, i.reset = function() {
                    x = {}
                }, i.findInstance = function(t) {
                    return t && x[t] ? x[t] : null
                }, i.find = function(t) {
                    var e = i.findInstance(t);
                    return e && e.element || null
                }, i.embed = function(t) {
                    var e = [],
                        n = [],
                        s = [];
                    g.isArray(t) || (t = [t || a]), b.time("sandboxes"), t.forEach(function(t) {
                        v.forIn(o, function(n, i) {
                            var r = t.querySelectorAll(n);
                            v.toRealArray(r).forEach(function(t) {
                                var n;
                                t.getAttribute(N) || (t.setAttribute(N, "true"), n = new i(t), e.push(n), s.push(n.sandboxCreated))
                            })
                        })
                    }), p.all(s).then(function() {
                        b.timeEnd("sandboxes")
                    }), i.doLayout(), e.forEach(function(t) {
                        n.push(t.completed()), t.render()
                    }), p.all(n).then(function(t) {
                        t = t.filter(function(t) {
                            return t
                        }), t.length && (A.get("events").trigger("loaded", {
                            widgets: t
                        }), b.timeEnd("load"))
                    }).then(i.trackRender), i.doLayoutAsync(), r()
                }, i.trackRender = function() {
                    d.endAndTrack("render", "widgets-js-load", "page", {
                        widget_origin: _.rootDocumentLocation(),
                        widget_frame: _.isFramed() && _.currentDocumentLocation()
                    })
                }, c.setInterval(function() {
                    i.doLayout()
                }, 500), e.exports = i
            }, {
            12: 12,
            15: 15,
            17: 17,
            18: 18,
            22: 22,
            37: 37,
            54: 54,
            56: 56,
            60: 60,
            61: 61,
            62: 62,
            65: 65,
            66: 66,
            68: 68,
            71: 71,
            74: 74,
            9: 9
        }],
        44: [function(t, e, n) {
                function i(t, e) {
                    var n = t.querySelector("blockquote.subject"),
                        i = t.querySelector("blockquote.reply"),
                        r = n && n.getAttribute("data-tweet-id"),
                        s = i && i.getAttribute("data-tweet-id"),
                        o = {},
                        a = {};r && (o[r] = {
                        item_type: 0
                    }, A.clientEvent({
                        page: "tweet",
                        section: "subject",
                        component: "tweet",
                        action: "results"
                    }, y.aug({}, e, {
                            item_ids: [r],
                            item_details: o
                        }), !0), _.scribeTweetAudienceImpression(), s && (a[s] = {
                        item_type: 0
                    }, A.clientEvent({
                        page: "tweet",
                        section: "conversation",
                        component: "tweet",
                        action: "results"
                    }, y.aug({}, e, {
                            item_ids: [s],
                            item_details: a,
                            associations: {
                                4: {
                                    association_id: r,
                                    association_type: 4
                                }
                            }
                        }), !0)))
                }
                function r(t, e) {
                    var n = {};t && (n[t] = {
                        item_type: 0
                    }, A.clientEvent({
                        page: "tweet",
                        section: "subject",
                        component: "rawembedcode",
                        action: "no_results"
                    }, {
                            widget_origin: T.rootDocumentLocation(),
                            widget_frame: T.isFramed() && T.currentDocumentLocation(),
                            message: e,
                            item_ids: [t],
                            item_details: n
                        }, !0), _.scribeTweetAudienceImpression())
                }
                function s(t, e, n, i) {
                    S[t] = S[t] || [], S[t].push({
                        s: n,
                        f: i,
                        lang: e
                    })
                }
                function o(t) {
                    if (t) {
                        var e, n, i;
                        h.apply(this, [t]), e = this.params(), n = this.srcEl && this.srcEl.getElementsByTagName("A"), i = n && n[n.length - 1], this.hideThread = "none" == (e.conversation || this.dataAttr("conversation")) || y.contains(this.classAttr, "tw-hide-thread"), this.hideCard = "hidden" == (e.cards || this.dataAttr("cards")) || y.contains(this.classAttr, "tw-hide-media"), "left" == (e.align || this.attr("align")) || y.contains(this.classAttr, "tw-align-left") ? this.align = "left" : "right" == (e.align || this.attr("align")) || y.contains(this.classAttr, "tw-align-right") ? this.align = "right" : ("center" == (e.align || this.attr("align")) || y.contains(this.classAttr, "tw-align-center")) && (this.align = "center", this.containerWidth > this.dimensions.MIN_WIDTH * (1 / .7) && this.width > .7 * this.containerWidth && (this.width = .7 * this.containerWidth)), this.narrow = e.narrow || this.width <= this.dimensions.NARROW_WIDTH, this.narrow && this.classAttr.push("var-narrow"), this.tweetId = e.tweetId || i && w.status(i.href)
                    }
                }
                var a = t(3),
                    c = t(12),
                    u = t(7),
                    d = t(43),
                    h = t(47),
                    l = t(53),
                    f = t(41),
                    p = t(4),
                    m = t(6),
                    g = t(22),
                    v = t(66),
                    y = t(74),
                    w = t(70),
                    b = t(38),
                    _ = t(30),
                    A = t(31),
                    E = t(40),
                    T = t(54),
                    x = t(17),
                    I = t(5),
                    D = t(32),
                    N = "tweetembed",
                    S = {},
                    C = [];
                o.prototype = new h, y.aug(o.prototype, {
                    renderedClassNames: "twitter-tweet twitter-tweet-rendered",
                    dimensions: {
                        DEFAULT_HEIGHT: "0",
                        DEFAULT_WIDTH: "500",
                        NARROW_WIDTH: "350",
                        maxHeight: "375",
                        FULL_BLEED_PHOTO_MAX_HEIGHT: "600",
                        MIN_WIDTH: "220",
                        MIN_HEIGHT: "0",
                        MARGIN: "10px 0",
                        WIDE_MEDIA_PADDING: 32,
                        NARROW_MEDIA_PADDING: 32,
                        BORDERS: 0
                    },
                    styleSheetUrl: a.tweet,
                    onStyleSheetLoad: function() {
                        var t = this;
                        this.sandbox.hasContent() && (d.doLayoutAsync(), this.sandbox.resizeToContent().then(function(e) {
                            t.height = e
                        }))
                    },
                    loadCardCss: function(t) {
                        var e = this,
                            n = t && t.getAttribute("data-css");
                        n && this.sandbox.appendStyleSheet(n, function() {
                            p.add(t, "is-ready"), d.doLayoutAsync(), e.sandbox.resizeToContent().then(function(t) {
                                e.height = t
                            })
                        })
                    },
                    create: function(t) {
                        var e, n,
                            r = this,
                            s = this.sandbox.createElement("div");
                        return s.innerHTML = t, (e = s.children[0] || !1) ? ("dark" == this.theme && this.classAttr.push("thm-dark"), this.linkColor && this.addSiteStyles(), p.present(e, "media-forward") && (this.fullBleedPhoto = !0, this.dimensions.maxHeight = this.dimensions.FULL_BLEED_PHOTO_MAX_HEIGHT), E.retinize(e), E.fixMediaCardLayout(e), e.id = this.id, e.className += " " + this.classAttr.join(" "), e.lang = this.lang, this.sandbox.setTitle(e.getAttribute("data-iframe-title") || "Tweet"), this.loadCardCss(e.querySelector(".PrerenderedCard")), this.sandbox.appendChild(e).then(function() {
                                r.renderedDeferred.resolve(r.sandbox)
                            }), n = this.layout(function() {
                                r.predefinedWidth = r.width, r.width = r.sandbox.width(r.width), r.collapseRegions()
                            }), n.then(function() {
                                r.constrainMedia(e, r.contentWidth(r.width)), r.setNarrow().then(function() {
                                    r.layout(function() {
                                        r.completeDeferred.resolve(r.sandbox.element())
                                    })
                                })
                            }), i(e, this.baseScribeData(), this.partner), e) : void 0
                    },
                    render: function() {
                        var t = this,
                            e = "",
                            n = this.tweetId;
                        return n ? (this.hideCard && (e += "c"), this.hideThread && (e += "t"), e && (n += "-" + e), this.rendered().then(function(e) {
                            var n = t.srcEl;
                            n && n.parentNode && t.layout(function() {
                                n && n.parentNode && n.parentNode.removeChild(n)
                            }), "center" == t.align ? e.style({
                                margin: "7px auto",
                                cssFloat: "none"
                            }) : t.align && (t.width == t.dimensions.DEFAULT_WIDTH && (t.predefinedWidth = t.width = t.dimensions.NARROW_WIDTH), e.style({
                                cssFloat: t.align
                            })), t.sandbox.resizeToContent().then(function(e) {
                                return t.height = e, d.doLayoutAsync(), t.sandbox.resizeToContent().then(function(e) {
                                        t.height = e
                                    })
                            }).then(function() {
                                e.onresize(t.handleResize.bind(t))
                            }), e.style({
                                position: "static",
                                visibility: "visible"
                            }), d.doLayoutAsync()
                        }), s(n, this.lang, function(e) {
                            t.ready().then(function() {
                                t.element = t.create(e), t.readTimestampTranslations(), t.updateTimeStamps(), t.bindIntentHandlers(), t.bindUIHandlers(), t.bindPermalinkHandler(), d.doLayoutAsync()
                            })
                        }, function() {
                                r(t.tweetId, t.partner), t.completeDeferred.resolve(t.srcEl)
                            }), C.push(this.completed()), this.completed().then(this.scribePerformance.bind(this)), this.completed()) : (this.completeDeferred.resolve(this.srcEl), this.completed())
                    },
                    bindPermalinkHandler: function() {
                        var t = this;
                        I.delegate(this.element, "click", "A", function(t) {
                            I.stopPropagation(t)
                        }), I.delegate(this.element, "click", ".twitter-tweet", function(e) {
                            var n, i;
                            u.getSelection(t.sandbox._win) || (n = t.element.querySelectorAll("blockquote.tweet"), i = n[n.length - 1], t.openPermalink(i), t.scribePermalinkClick(i, e), I.stopPropagation(e))
                        })
                    },
                    scribePermalinkClick: function(t, e) {
                        var n = this.createScribeData(t);
                        D.interaction(e, n, !1)
                    },
                    openPermalink: function(t) {
                        var e = t.cite;
                        w.isStatus(e) && c.open(e)
                    },
                    scribePerformance: function() {
                        g.endAndTrack("render", "widgets-js-load", "tweet", this.baseScribeData())
                    },
                    addUrlParams: function(t) {
                        var e = this,
                            n = {
                                related: this.related,
                                partner: this.partner,
                                original_referer: T.rootDocumentLocation(),
                                tw_p: N
                            };
                        return this.addUrlParams = f(n, function(t) {
                                var n = m.closest(".tweet", t, e.element);
                                return {
                                    tw_i: n.getAttribute("data-tweet-id")
                                }
                            }), this.addUrlParams(t)
                    },
                    baseScribeData: function() {
                        return {
                            widget_origin: T.rootDocumentLocation(),
                            widget_frame: T.isFramed() && T.currentDocumentLocation(),
                            message: this.partner
                        }
                    },
                    handleResize: function(t) {
                        var e = this;
                        t != this.width && (this.width = t, this.setNarrow(), this.constrainMedia(this.element, this.contentWidth(t)), this.collapseRegions(), this.sandbox.resizeToContent().then(function(t) {
                            e.height = t, x.get("events").trigger("resize", {
                                target: e.sandbox.element()
                            })
                        }), d.doLayoutAsync())
                    },
                    readTimestampTranslations: function() {
                        var t = this.element,
                            e = "data-dt-",
                            n = t.getAttribute(e + "months") || "";
                        this.datetime = new l(y.compact({
                            phrases: {
                                AM: t.getAttribute(e + "am"),
                                PM: t.getAttribute(e + "pm")
                            },
                            months: n.split("|"),
                            formats: {
                                full: t.getAttribute(e + "full")
                            }
                        }))
                    },
                    updateTimeStamps: function() {
                        var t = this.element.querySelector(".long-permalink"),
                            e = t.getAttribute("data-datetime"),
                            n = e && this.datetime.localTimeStamp(e),
                            i = t.getElementsByTagName("TIME")[0];
                        n && (this.layout(function() {
                            return i && i.innerHTML ? void (i.innerHTML = n) : void (t.innerHTML = n)
                        }, "Update Timestamp"), d.doLayoutAsync())
                    }
                }), o.fetchAndRender = function() {
                    var t, e,
                        n = S,
                        i = [];
                    if (S = {}, n.keys) {
                        i = n.keys();
                    } else
                        for (t in n) n.hasOwnProperty(t) && i.push(t);
                    i.length && (A.init(), e = n[i[0]][0].lang, b.tweets({
                        ids: i.sort(),
                        lang: e,
                        complete: function(t) {
                            y.forIn(t, function(t, e) {
                                var i = n[t];
                                i.forEach(function(t) {
                                    t.s && t.s.call(this, e)
                                }),
                                delete n[t]
                            }), d.doLayout(), y.forIn(n, function(t, e) {
                                e.forEach(function(e) {
                                    e.f && e.f.call(this, t)
                                })
                            }), d.doLayout()
                        }
                    }), v.all(C).then(function() {
                        A.flush()
                    }), C = [])
                }, d.afterLoad(o.fetchAndRender), e.exports = o
            }, {
            12: 12,
            17: 17,
            22: 22,
            3: 3,
            30: 30,
            31: 31,
            32: 32,
            38: 38,
            4: 4,
            40: 40,
            41: 41,
            43: 43,
            47: 47,
            5: 5,
            53: 53,
            54: 54,
            6: 6,
            66: 66,
            7: 7,
            70: 70,
            74: 74
        }],
        45: [function(t, e, n) {
                function i(t) {
                    if (t) {
                        var e, n, i, r;
                        o.apply(this, [t]), e = this.params(), n = e.size || this.dataAttr("size"), i = e.showScreenName || this.dataAttr("show-screen-name"), r = e.count || this.dataAttr("count"), this.classAttr.push("twitter-follow-button"), this.showScreenName = "false" != i, this.showCount = !(e.showCount === !1 || "false" == this.dataAttr("show-count")), "none" == r && (this.showCount = !1), this.explicitWidth = e.width || this.dataAttr("width") || "", this.screenName = e.screen_name || e.screenName || a.screenName(this.attr("href")), this.preview = e.preview || this.dataAttr("preview") || "", this.align = e.align || this.dataAttr("align") || "", this.size = "large" == n ? "l" : "m"
                    }
                }
                var r = t(56),
                    s = t(74),
                    o = t(43),
                    a = t(70),
                    c = t(66);
                i.prototype = new o, s.aug(i.prototype, {
                    iframeSource: "widgets/follow_button.f399ce91824b7ff2ece442a414e1a813.{{lang}}.html",
                    widgetUrlParams: function() {
                        return s.compact({
                            screen_name: this.screenName,
                            lang: this.lang,
                            show_count: this.showCount,
                            show_screen_name: this.showScreenName,
                            align: this.align,
                            id: this.id,
                            preview: this.preview,
                            size: this.size,
                            partner: this.partner,
                            dnt: r.enabled(),
                            _: +new Date
                        })
                    },
                    render: function() {
                        if (!this.screenName) return c.reject("Missing Screen Name");
                        var t = this,
                            e = this.makeIframeSource(),
                            n = this.create(e, {
                                title: "Twitter Follow Button"
                            }).then(function(e) {
                                return t.element = e
                            });
                        return n
                    }
                }), e.exports = i
            }, {
            43: 43,
            56: 56,
            66: 66,
            70: 70,
            74: 74
        }],
        46: [function(t, e, n) {
                function i(t) {
                    p.open(t)
                }
                function r(e, n) {
                    var i = t(35);i.openIntent(e, n)
                }
                function s(t, e) {
                    if (f.isTwitterURL(t))
                        if (g.get("eventsHub") && e) {
                            var n = new o(c.generateId(), e);
                            c.add(n), r(t, e), m.get("events").trigger("click", {
                                target: e,
                                region: "intent",
                                type: "click",
                                data: {}
                            })
                        } else {
                            i(t)
                    }
                }
                function o(t, e) {
                    this.id = t, this.element = this.srcEl = e
                }
                function a(t) {
                    this.srcEl = [], this.element = t
                }
                var c,
                    u = t(9),
                    d = t(43),
                    h = t(74),
                    l = t(66),
                    f = t(70),
                    p = t(21),
                    m = t(17),
                    g = t(16);
                a.prototype = new d, h.aug(a.prototype, {
                    render: function() {
                        return c = this, l.resolve(u.body)
                    }
                }), a.open = s, e.exports = a
            }, {
            16: 16,
            17: 17,
            21: 21,
            35: 35,
            43: 43,
            66: 66,
            70: 70,
            74: 74,
            9: 9
        }],
        47: [function(t, e, n) {
                function i() {
                    o = r.VALID_COLOR.test(l.val("widgets:link-color")) && RegExp.$1, c = r.VALID_COLOR.test(l.val("widgets:border-color")) && RegExp.$1, a = l.val("widgets:theme")
                }
                function r(t) {
                    if (t) {
                        var e,
                            n = this;
                        this.readyDeferred = new A, this.renderedDeferred = new A, d.apply(this, [t]), e = this.params(), this.targetEl = this.srcEl && this.srcEl.parentNode || e.targetEl || u.body, this.predefinedWidth = r.VALID_UNIT.test(e.width || this.attr("width")) && RegExp.$1, this.layout(function() {
                            return n.containerWidth = w.effectiveWidth(n.targetEl)
                        }).then(function(t) {
                            var i = n.predefinedWidth || t || n.dimensions.DEFAULT_WIDTH;
                            n.height = r.VALID_UNIT.test(e.height || n.attr("height")) && RegExp.$1, n.width = Math.max(n.dimensions.MIN_WIDTH, Math.min(i, n.dimensions.DEFAULT_WIDTH))
                        }), this.linkColor = r.VALID_COLOR.test(e.linkColor || this.dataAttr("link-color")) ? RegExp.$1 : o, this.borderColor = r.VALID_COLOR.test(e.borderColor || this.dataAttr("border-color")) ? RegExp.$1 : c, this.theme = e.theme || this.attr("data-theme") || a, this.theme = /(dark|light)/.test(this.theme) ? this.theme : "", this.classAttr.push(E.touch() ? "is-touch" : "not-touch"), E.ie9() && this.classAttr.push("ie9"), this.sandboxCreated = b.createSandbox({
                            "class": this.renderedClassNames,
                            id: this.id,
                            allowfullscreen: ""
                        }, {
                                position: "absolute",
                                visibility: "hidden"
                            }, function(t) {
                                n.modifyFrame && (t = n.modifyFrame(t)), n.srcEl ? n.targetEl.insertBefore(t, n.srcEl) : n.targetEl.appendChild(t)
                            }, this.layout).then(function(t) {
                            n.setupSandbox(t), new m(t.element().contentWindow)
                        }), this.rendered().then(function(t) {
                            n.applyVisibleSandboxStyles(t)
                        })
                    }
                }
                function s(t, e) {
                    return t + e
                }
                var o, a, c,
                    u = t(9),
                    d = t(43),
                    h = t(46),
                    l = t(15),
                    f = t(40),
                    p = t(32),
                    m = t(78),
                    g = t(4),
                    v = t(6),
                    y = t(5),
                    w = t(8),
                    b = t(28),
                    _ = t(51),
                    A = t(65),
                    E = t(57),
                    T = t(66),
                    x = t(70),
                    I = t(71),
                    D = t(74),
                    N = t(67),
                    S = [".customisable", ".customisable:link", ".customisable:visited"],
                    C = [".customisable:hover", ".customisable:focus", ".customisable:active", ".customisable-highlight:hover", ".customisable-highlight:focus", "a:hover .customisable-highlight", "a:focus .customisable-highlight"],
                    R = ["a:hover .ic-mask", "a:focus .ic-mask"],
                    P = [".customisable-border"],
                    L = [".timeline-header h1.summary", ".timeline-header h1.summary a:link", ".timeline-header h1.summary a:visited"],
                    M = {
                        TWEET: 0,
                        RETWEET: 10
                    };
                r.prototype = new d, D.aug(r.prototype, {
                    dimensions: {},
                    styleSheetUrl: function() {
                        throw new Error("must set styleSheetUrl")
                    },
                    onStyleSheetLoad: function() {},
                    setupSandbox: function(t) {
                        var e, n,
                            i = this;
                        this.sandbox = t, e = this.styleSheetUrl(this.lang, this.theme), n = this.onStyleSheetLoad.bind(this), N.some([i.applyInitialSandboxStyles(t), t.appendCss(".SandboxRoot { display:none }"), t.setBaseTarget("_blank"), t.appendStyleSheet(e, n)]).then(function() {
                            i.readyDeferred.resolve(t)
                        })
                    },
                    ready: function() {
                        return this.readyDeferred.promise
                    },
                    rendered: function() {
                        return this.renderedDeferred.promise
                    },
                    contentWidth: function(t) {
                        var e = this.dimensions,
                            n = this.borderless ? 0 : e.BORDERS,
                            i = this.fullBleedPhoto ? 0 : this.chromeless && this.narrow ? e.NARROW_MEDIA_PADDING_CL : this.chromeless ? e.WIDE_MEDIA_PADDING_CL : this.narrow ? e.NARROW_MEDIA_PADDING : e.WIDE_MEDIA_PADDING;
                        return (t || this.width) - (i + n)
                    },
                    applyInitialSandboxStyles: function(t) {
                        var e = this;
                        return t.style({
                            border: "none",
                            maxWidth: "100%",
                            minWidth: e.dimensions.MIN_WIDTH + "px",
                            margin: e.dimensions.MARGIN,
                            padding: "0",
                            display: "block",
                            position: "absolute",
                            visibility: "hidden"
                        }, !0)
                    },
                    applyVisibleSandboxStyles: function(t) {
                        return t.style({
                            position: "static",
                            visibility: "visible"
                        })
                    },
                    addSiteStyles: function() {
                        function t(t) {
                            return ("dark" == e.theme ? ".thm-dark " : "") + t
                        }
                        var e = this,
                            n = [];
                        return this.headingStyle && n.push(L.map(t).join(",") + "{" + this.headingStyle + "}"), this.linkColor && (n.push(S.map(t).join(",") + "{color:" + this.linkColor + "}"), n.push(R.map(t).join(",") + "{background-color:" + this.linkColor + "}"), n.push(C.map(t).join(",") + "{color:" + _.lighten(this.linkColor, .2) + "}")), this.borderColor && n.push(P.map(t).concat("dark" == this.theme ? [".thm-dark.customisable-border"] : []).join(",") + "{border-color:" + this.borderColor + "}"), n.length ? this.sandbox.appendCss(n.join("")) : void 0
                    },
                    setNarrow: function() {
                        var t = this,
                            e = this.narrow;
                        return this.narrow = this.width < this.dimensions.NARROW_WIDTH, e != this.narrow ? this.layout(function() {
                                g.toggle(t.sandbox.root, "env-narrow", t.narrow), g.toggle(t.element, "var-narrow", t.narrow)
                            }) : T.resolve(this.narrow)
                    },
                    createScribeData: function(t) {
                        var e = D.aug({}, this.baseScribeData(), {
                            item_ids: [],
                            item_details: this.extractTweetScribeDetails(t)
                        });
                        return D.forIn(e.item_details, function(t) {
                                e.item_ids.push(t)
                            }), e
                    },
                    bindUIHandlers: function() {
                        var t = this.element;
                        y.delegate(t, "click", ".MediaCard-dismissNsfw", function() {
                            var e = v.closest(".MediaCard", this, t);
                            g.remove(e, "MediaCard--nsfw")
                        })
                    },
                    bindIntentHandlers: function() {
                        function t(t) {
                            var i = v.closest(".tweet", this, n),
                                r = e.createScribeData(i);p.interaction(t, r, !0)
                        }
                        var e = this,
                            n = this.element;
                        y.delegate(n, "click", "A", t), y.delegate(n, "click", "BUTTON", t), y.delegate(n, "click", ".profile", function() {
                            e.addUrlParams(this)
                        }), y.delegate(n, "click", ".follow-button", function(t) {
                            var n;
                            t.altKey || t.metaKey || t.shiftKey || E.ios() || E.android() || I.asBoolean(this.getAttribute("data-age-gate")) || (n = x.intentForFollowURL(this.href, !0), n && (h.open(n, e.sandbox.element()), y.preventDefault(t)))
                        }), y.delegate(n, "click", ".web-intent", function(t) {
                            e.addUrlParams(this), t.altKey || t.metaKey || t.shiftKey || (h.open(this.href, e.sandbox.element()), y.preventDefault(t))
                        })
                    },
                    baseScribeData: function() {
                        return {}
                    },
                    extractTweetScribeDetails: function(t) {
                        var e, n,
                            i = {};
                        return t ? (e = t.getAttribute("data-tweet-id"), n = t.getAttribute("data-rendered-tweet-id") || e, n == e ? i[n] = {
                            item_type: M.TWEET
                        } : e && (i[n] = {
                            item_type: M.RETWEET,
                            target_type: M.TWEET,
                            target_id: e
                        }), i) : i
                    },
                    constrainMedia: function(t, e) {
                        return f.constrainMedia(t || this.element, e || this.contentWidth(), this.dimensions.maxHeight, this.layout)
                    },
                    collapseRegions: function() {
                        var t = this;
                        D.toRealArray(this.element.querySelectorAll(".collapsible-container")).forEach(function(e) {
                            var n, i,
                                r = D.toRealArray(e.children),
                                o = r.length && e.offsetWidth,
                                a = r.length && r.map(function(t) {
                                    return t.offsetWidth
                                }),
                                c = r.length;
                            if (r.length)
                                for (; c > 0; ) {
                                    if (c--, n = a.reduce(s, 0), !o || !n) return;
                                    if (o > n) return;
                                    i = r[c].getAttribute("data-collapsed-class"), i && (g.add(t.element, i), a[c] = r[c].offsetWidth)
                            }
                        })
                    }
                }), r.VALID_UNIT = /^([0-9]+)( ?px)?$/, r.VALID_COLOR = /^(#(?:[0-9a-f]{3}|[0-9a-f]{6}))$/i, i(), e.exports = r
            }, {
            15: 15,
            28: 28,
            32: 32,
            4: 4,
            40: 40,
            43: 43,
            46: 46,
            5: 5,
            51: 51,
            57: 57,
            6: 6,
            65: 65,
            66: 66,
            67: 67,
            70: 70,
            71: 71,
            74: 74,
            78: 78,
            8: 8,
            9: 9
        }],
        48: [function(t, e, n) {
                function i(t) {
                    if (t) {
                        var e, n, i, r, s, o, c, u;
                        a.apply(this, [t]), e = this.params(), n = (e.chrome || this.dataAttr("chrome") || "").split(" "), this.preview = e.previewParams, this.widgetId = e.widgetId || this.dataAttr("widget-id"), this.instanceId = ++z, this.cursors = {
                            maxPosition: 0,
                            minPosition: 0
                        }, this.override = (r = e.screenName || this.dataAttr("screen-name")) || (s = e.userId || this.dataAttr("user-id")) ? {
                            overrideType: "user",
                            overrideId: s,
                            overrideName: r,
                            withReplies: y.asBoolean(e.showReplies || this.dataAttr("show-replies")) ? "true" : "false"
                        } : (r = e.favoritesScreenName || this.dataAttr("favorites-screen-name")) || (s = e.favoritesUserId || this.dataAttr("favorites-user-id")) ? {
                            overrideType: "favorites",
                            overrideId: s,
                            overrideName: r
                        } : ((r = e.listOwnerScreenName || this.dataAttr("list-owner-screen-name")) || (s = e.listOwnerId || this.dataAttr("list-owner-id"))) && ((o = e.listId || this.dataAttr("list-id")) || (c = e.listSlug || this.dataAttr("list-slug"))) ? {
                            overrideType: "list",
                            overrideOwnerId: s,
                            overrideOwnerName: r,
                            overrideId: o,
                            overrideName: c
                        } : (u = e.customTimelineId || this.dataAttr("custom-timeline-id")) ? {
                            overrideType: "custom",
                            overrideId: u
                        } : {}, this.tweetLimit = y.asInt(e.tweetLimit || this.dataAttr("tweet-limit")), this.staticTimeline = this.tweetLimit > 0, n.length && (i = w.contains(n, "none"), this.chromeless = i || w.contains(n, "transparent"), this.headerless = i || w.contains(n, "noheader"), this.footerless = i || w.contains(n, "nofooter"), this.borderless = i || w.contains(n, "noborders"), this.noscrollbar = w.contains(n, "noscrollbar")), this.headingStyle = g.sanitize(e.headingStyle || this.dataAttr("heading-style"), void 0, !0), this.classAttr.push("twitter-timeline-rendered"), this.ariaPolite = e.ariaPolite || this.dataAttr("aria-polite")
                    }
                }
                var r = t(12),
                    s = t(3),
                    o = t(43),
                    a = t(47),
                    c = t(53),
                    u = t(2),
                    d = t(22),
                    h = t(38),
                    l = t(40),
                    f = t(30),
                    p = t(31),
                    m = t(41),
                    g = t(52),
                    v = t(57),
                    y = t(71),
                    w = t(74),
                    b = t(5),
                    _ = t(4),
                    A = t(6),
                    E = t(56),
                    T = t(54),
                    x = t(17),
                    I = t(16),
                    D = {
                        CLIENT_SIDE_USER: 0,
                        CLIENT_SIDE_APP: 2
                    },
                    N = ".timeline",
                    S = ".new-tweets-bar",
                    C = ".timeline-header",
                    R = ".timeline-footer",
                    P = ".stream",
                    L = ".h-feed",
                    M = ".tweet",
                    O = ".detail-expander",
                    k = ".expand",
                    H = ".permalink",
                    W = ".no-more-pane",
                    j = "expanded",
                    U = "pending-scroll-in",
                    q = "pending-new-tweet-display",
                    F = "pending-new-tweet",
                    z = 0;
                i.prototype = new a, w.aug(i.prototype, {
                    renderedClassNames: "twitter-timeline twitter-timeline-rendered",
                    dimensions: {
                        DEFAULT_HEIGHT: "600",
                        DEFAULT_WIDTH: "520",
                        NARROW_WIDTH: "320",
                        maxHeight: "375",
                        MIN_WIDTH: "180",
                        MIN_HEIGHT: "200",
                        MARGIN: "0",
                        WIDE_MEDIA_PADDING: 81,
                        NARROW_MEDIA_PADDING: 16,
                        WIDE_MEDIA_PADDING_CL: 60,
                        NARROW_MEDIA_PADDING_CL: 12,
                        BORDERS: 2
                    },
                    styleSheetUrl: s.timeline,
                    create: function(t) {
                        var e, n, i, r,
                            s = this,
                            o = this.sandbox.createElement("div"),
                            a = [];
                        return o.innerHTML = t.body, (e = o.children[0] || !1) ? (this.reconfigure(t.config), this.discardStaticOverflow(e), this.sandbox.setTitle(e.getAttribute("data-iframe-title") || "Timeline"), l.retinize(e), this.constrainMedia(e), this.searchQuery = e.getAttribute("data-search-query"), this.profileId = e.getAttribute("data-profile-id"), this.timelineType = e.getAttribute("data-timeline-type"), r = this.getTweetDetails(o.querySelector(L)), w.forIn(r, function(t) {
                                a.push(t)
                            }), i = this.baseScribeData(), i.item_ids = a, i.item_details = r, this.timelineType && p.clientEvent({
                                page: this.timelineType + "_timeline",
                                component: "timeline",
                                element: "initial",
                                action: a.length ? "results" : "no_results"
                            }, i, !0), p.clientEvent({
                                page: "timeline",
                                component: "timeline",
                                element: "initial",
                                action: a.length ? "results" : "no_results"
                            }, i, !0), f.scribeTimelineAudienceImpression(), p.flush(), "assertive" == this.ariaPolite && (n = e.querySelector(S), n.setAttribute("aria-polite", "assertive")), e.id = this.id, e.className += " " + this.classAttr.join(" "), e.lang = this.lang, this.ready().then(function(t) {
                                t.appendChild(e).then(function() {
                                    s.renderedDeferred.resolve(s.sandbox)
                                }), t.style({
                                    display: "inline-block"
                                }), s.layout(function() {
                                    s.srcEl && s.srcEl.parentNode && s.srcEl.parentNode.removeChild(s.srcEl), s.predefinedWidth = s.width, s.predefinedHeight = s.height, s.width = t.width(s.width), s.height = t.height(s.height)
                                }).then(function() {
                                    s.setNarrow(), s.sandbox.onresize(s.handleResize.bind(s)), s.completeDeferred.resolve(s.sandbox.element())
                                })
                            }), e) : void 0
                    },
                    render: function() {
                        var t = this;
                        return this.preview || this.widgetId ? (this.rendered().then(this.staticTimeline ? function(t) {
                            t.resizeToContent(), o.doLayoutAsync()
                        } : function() {
                            t.recalculateStreamHeight(), o.doLayoutAsync()
                        }), this.preview ? this.getPreviewTimeline() : this.getTimeline(), this.completed().then(this.scribePerformance.bind(this)), this.completed()) : (this.completeDeferred.reject(400), this.completed())
                    },
                    scribePerformance: function() {
                        d.endAndTrack("render", "widgets-js-load", "timeline", this.baseScribeData())
                    },
                    getPreviewTimeline: function() {
                        var t = this;
                        h.timelinePreview({
                            success: function(e) {
                                t.ready().then(function() {
                                    t.element = t.create(e), t.readTranslations(), t.bindInteractions(), t.updateCursors(e.headers, {
                                        initial: !0
                                    }), o.doLayoutAsync()
                                })
                            },
                            error: function(e) {
                                return e && e.headers ? void t.completeDeferred.reject(e.headers.status) : void t.completeDeferred.resolve(t.srcEl)
                            },
                            params: this.preview
                        })
                    },
                    getTimeline: function() {
                        var t = this;
                        p.init(), h.timeline(w.aug({
                            id: this.widgetId,
                            instanceId: this.instanceId,
                            dnt: E.enabled(),
                            lang: this.lang,
                            success: function(e) {
                                t.ready().then(function() {
                                    t.element = t.create(e), t.readTranslations(), t.bindInteractions(), t.updateTimeStamps(), t.updateCursors(e.headers, {
                                        initial: !0
                                    }), e.headers.xPolling && /\d/.test(e.headers.xPolling) && (t.pollInterval = 1e3 * e.headers.xPolling), t.staticTimeline || t.schedulePolling(), o.doLayoutAsync()
                                })
                            },
                            error: function(e) {
                                return e && e.headers ? void t.completeDeferred.reject(e.headers.status) : void t.completeDeferred.resolve(t.srcEl)
                            }
                        }, this.override))
                    },
                    reconfigure: function(t) {
                        this.lang = t.lang, this.theme || (this.theme = t.theme), "dark" == this.theme && this.classAttr.push("thm-dark"), this.chromeless && this.classAttr.push("var-chromeless"), this.borderless && this.classAttr.push("var-borderless"), this.headerless && this.classAttr.push("var-headerless"), this.footerless && this.classAttr.push("var-footerless"), this.staticTimeline && this.classAttr.push("var-static"), !this.linkColor && t.linkColor && a.VALID_COLOR.test(t.linkColor) && (this.linkColor = RegExp.$1), !this.height && a.VALID_UNIT.test(t.height) && (this.height = RegExp.$1), this.height = Math.max(this.dimensions.MIN_HEIGHT, this.height ? this.height : this.dimensions.DEFAULT_HEIGHT), this.preview && this.classAttr.push("var-preview"), this.narrow = this.width <= this.dimensions.NARROW_WIDTH, this.narrow && this.classAttr.push("var-narrow"), this.addSiteStyles()
                    },
                    getTweetDetails: function(t) {
                        var e,
                            n = this,
                            i = {};
                        return e = t && t.children || [], w.toRealArray(e).forEach(function(t) {
                                w.aug(i, n.extractTweetScribeDetails(t))
                            }), i
                    },
                    baseScribeData: function() {
                        return {
                            widget_id: this.widgetId,
                            widget_origin: T.rootDocumentLocation(),
                            widget_frame: T.isFramed() && T.currentDocumentLocation(),
                            message: this.partner,
                            query: this.searchQuery,
                            profile_id: this.profileId
                        }
                    },
                    bindInteractions: function() {
                        var t = this,
                            e = this.element,
                            n = !0;
                        this.bindIntentHandlers(), this.bindUIHandlers(), b.delegate(e, "click", ".load-tweets", function(e) {
                            n && (n = !1, t.forceLoad(), b.stop(e))
                        }), b.delegate(e, "click", ".display-sensitive-image", function(n) {
                            t.showNSFW(A.closest(M, this, e)), b.stop(n)
                        }), b.delegate(e, "mouseover", N, function() {
                            t.mouseOver = !0
                        }), b.delegate(e, "mouseout", N, function() {
                            t.mouseOver = !1
                        }), b.delegate(e, "mouseover", S, function() {
                            t.mouseOverNotifier = !0
                        }), b.delegate(e, "mouseout", S, function() {
                            t.mouseOverNotifier = !1, r.setTimeout(function() {
                                t.hideNewTweetNotifier()
                            }, 3e3)
                        }), this.staticTimeline || (b.delegate(e, "click", k, function(n) {
                            n.altKey || n.metaKey || n.shiftKey || (t.toggleExpando(A.closest(M, this, e)), b.stop(n))
                        }), b.delegate(e, "click", "A", function(t) {
                            b.stopPropagation(t)
                        }), b.delegate(e, "click", ".with-expansion", function(e) {
                            t.toggleExpando(this), b.stop(e)
                        }), b.delegate(e, "click", ".load-more", function() {
                            t.loadMore()
                        }), b.delegate(e, "click", S, function() {
                            t.scrollToTop(), t.hideNewTweetNotifier(!0)
                        }))
                    },
                    scrollToTop: function() {
                        var t = this.element.querySelector(P);
                        t.scrollTop = 0, t.focus()
                    },
                    update: function() {
                        var t = this,
                            e = this.element.querySelector(L),
                            n = e && e.children[0],
                            i = n && n.getAttribute("data-tweet-id");
                        this.updateTimeStamps(), this.requestTweets(i, !0, function(e) {
                            e.childNodes.length > 0 && t.insertNewTweets(e)
                        })
                    },
                    loadMore: function() {
                        var t = this,
                            e = w.toRealArray(this.element.querySelectorAll(M)).pop(),
                            n = e && e.getAttribute("data-tweet-id");
                        this.requestTweets(n, !1, function(e) {
                            var i = t.element.querySelector(W),
                                r = e.childNodes[0];
                            return i.style.cssText = "", r && r.getAttribute("data-tweet-id") == n && e.removeChild(r), e.childNodes.length > 0 ? void t.appendTweets(e) : (_.add(t.element, "no-more"), void i.focus())
                        })
                    },
                    forceLoad: function() {
                        var t = this,
                            e = !!this.element.querySelectorAll(L).length;
                        this.requestTweets(1, !0, function(n) {
                            n.childNodes.length && (t[e ? "insertNewTweets" : "appendTweets"](n), _.add(t.element, "has-tweets"))
                        })
                    },
                    schedulePolling: function(t) {
                        var e = this;
                        null !== this.pollInterval && (t = I.get("timeline.pollInterval") || t || this.pollInterval || 1e4, t > -1 && r.setTimeout(function() {
                            e.isUpdating || e.update(), e.schedulePolling()
                        }, t))
                    },
                    updateCursors: function(t, e) {
                        (e || {}).initial ? (this.cursors.maxPosition = t.maxPosition, this.cursors.minPosition = t.minPosition) : (e || {}).newer ? this.cursors.maxPosition = t.maxPosition || this.cursors.maxPosition : this.cursors.minPosition = t.minPosition || this.cursors.minPosition
                    },
                    requestTweets: function(t, e, n) {
                        var i = this,
                            r = {
                                id: this.widgetId,
                                instanceId: this.instanceId,
                                screenName: this.widgetScreenName,
                                userId: this.widgetUserId,
                                withReplies: this.widgetShowReplies,
                                dnt: E.enabled(),
                                lang: this.lang
                            };
                        e && this.cursors.maxPosition ? r.minPosition = this.cursors.maxPosition : !e && this.cursors.minPosition ? r.maxPosition = this.cursors.minPosition : e ? r.sinceId = t : r.maxId = t, r.complete = function() {
                            i.isUpdating = !1
                        }, r.error = function(t) {
                            if (t && t.headers) {
                                if ("404" == t.headers.status) return void (i.pollInterval = null);
                                if ("503" == t.headers.status) return void (i.pollInterval *= 1.5)
                            }
                        }, r.success = function(t) {
                            var r, s,
                                o = i.sandbox.createDocumentFragment(),
                                a = i.sandbox.createElement("ol"),
                                c = [];
                            if (i.updateCursors(t.headers, {
                                    newer: e
                                }), t && t.headers && t.headers.xPolling && /\d+/.test(t.headers.xPolling) && (i.pollInterval = 1e3 * t.headers.xPolling), t && void 0 !== t.body) {
                                if (a.innerHTML = t.body, a.children[0] && "LI" != a.children[0].tagName) return;
                                for (s = i.getTweetDetails(a), w.forIn(s, function(t) {
                                        c.push(t)
                                    }), c.length && (r = i.baseScribeData(), r.item_ids = c, r.item_details = s, r.event_initiator = e ? D.CLIENT_SIDE_APP : D.CLIENT_SIDE_USER, i.timelineType && p.clientEvent({
                                        page: i.timelineType + "_timeline",
                                        component: "timeline",
                                        element: "initial",
                                        action: c.length ? "results" : "no_results"
                                    }, r, !0), p.clientEvent({
                                        page: "timeline",
                                        component: "timeline",
                                        element: e ? "newer" : "older",
                                        action: "results"
                                    }, r, !0), p.flush()), l.retinize(a), i.constrainMedia(a); a.children[0]; ) {
                                    o.appendChild(a.children[0]);
                                }
                                n(o)
                            }
                        }, h.timelinePoll(w.aug(r, this.override))
                    },
                    insertNewTweets: function(t) {
                        var e,
                            n = this,
                            i = this.element.querySelector(P),
                            s = i.querySelector(L),
                            o = s.offsetHeight;
                        return s.insertBefore(t, s.firstChild), e = s.offsetHeight - o, x.get("events").trigger("timelineUpdated", {
                                target: this.sandbox.element(),
                                region: "newer"
                            }), i.scrollTop > 40 || this.mouseIsOver() ? (i.scrollTop = i.scrollTop + e, this.updateTimeStamps(), void this.showNewTweetNotifier()) : (_.remove(this.element, U), s.style.cssText = "margin-top: -" + e + "px", r.setTimeout(function() {
                                i.scrollTop = 0, _.add(n.element, U), v.cssTransitions() ? s.style.cssText = "" : u.animate(function(t) {
                                    s.style.cssText = e > t ? "margin-top: -" + (e - t) + "px" : ""
                                }, e, 500, u.easeOut)
                            }, 500), this.updateTimeStamps(), void ("custom" != this.timelineType && this.gcTweets(50)))
                    },
                    appendTweets: function(t) {
                        var e = this.element.querySelector(L);
                        e.appendChild(t), this.updateTimeStamps(), x.get("events").trigger("timelineUpdated", {
                            target: this.sandbox.element(),
                            region: "older"
                        })
                    },
                    gcTweets: function(t) {
                        var e,
                            n = this.element.querySelector(L),
                            i = n.children.length;
                        for (t = t || 50; i > t && (e = n.children[i - 1]); i--) {
                            n.removeChild(e)
                        }
                    },
                    showNewTweetNotifier: function() {
                        var t = this,
                            e = this.element.querySelector(S),
                            n = e.children[0];
                        e.style.cssText = "", e.removeChild(n), e.appendChild(n), _.add(this.element, q), r.setTimeout(function() {
                            _.add(t.element, F)
                        }, 10), this.newNoticeDisplayTime = +new Date, r.setTimeout(function() {
                            t.hideNewTweetNotifier()
                        }, 5e3)
                    },
                    hideNewTweetNotifier: function(t) {
                        var e = this;
                        (t || !this.mouseOverNotifier) && (_.remove(this.element, F), r.setTimeout(function() {
                            _.remove(e.element, q)
                        }, 500))
                    },
                    discardStaticOverflow: function(t) {
                        var e,
                            n = t.querySelector(L);
                        if (this.staticTimeline)
                            for (this.height = 0; e = n.children[this.tweetLimit]; ) {
                                n.removeChild(e)
                        }
                    },
                    hideStreamScrollBar: function() {
                        var t,
                            e = this.element.querySelector(P),
                            n = this.element.querySelector(L);
                        e.style.width = "", t = this.element.offsetWidth - n.offsetWidth, t > 0 && (e.style.width = this.element.offsetWidth + t + "px")
                    },
                    readTranslations: function() {
                        var t = this.element,
                            e = "data-dt-";
                        this.datetime = new c(w.compact({
                            phrases: {
                                now: t.getAttribute(e + "now"),
                                s: t.getAttribute(e + "s"),
                                m: t.getAttribute(e + "m"),
                                h: t.getAttribute(e + "h"),
                                second: t.getAttribute(e + "second"),
                                seconds: t.getAttribute(e + "seconds"),
                                minute: t.getAttribute(e + "minute"),
                                minutes: t.getAttribute(e + "minutes"),
                                hour: t.getAttribute(e + "hour"),
                                hours: t.getAttribute(e + "hours")
                            },
                            months: t.getAttribute(e + "months").split("|"),
                            formats: {
                                abbr: t.getAttribute(e + "abbr"),
                                shortdate: t.getAttribute(e + "short"),
                                longdate: t.getAttribute(e + "long")
                            }
                        }))
                    },
                    updateTimeStamps: function() {
                        for (var t, e, n, i, r = this.element.querySelectorAll(H), s = 0; t = r[s]; s++) {
                            n = t.getAttribute("data-datetime"), i = n && this.datetime.timeAgo(n, this.i18n), e = t.getElementsByTagName("TIME")[0], i && (e && e.innerHTML ? e.innerHTML = i : t.innerHTML = i)
                        }
                    },
                    mouseIsOver: function() {
                        return this.mouseOver
                    },
                    addUrlParams: function(t) {
                        var e = this,
                            n = {
                                tw_w: this.widgetId,
                                related: this.related,
                                partner: this.partner,
                                query: this.searchQuery,
                                profile_id: this.profileId,
                                original_referer: T.rootDocumentLocation(),
                                tw_p: "embeddedtimeline"
                            };
                        return this.addUrlParams = m(n, function(t) {
                                var n = A.closest(M, t, e.element);
                                return n && {
                                        tw_i: n.getAttribute("data-tweet-id")
                                }
                            }), this.addUrlParams(t)
                    },
                    showNSFW: function(t) {
                        var e, n, i, r, s, o,
                            a = t.querySelector(".nsfw"),
                            c = 0;
                        a && (n = l.scaleDimensions(a.getAttribute("data-width"), a.getAttribute("data-height"), this.contentWidth(), a.getAttribute("data-height")), e = !!(r = a.getAttribute("data-player")), e ? s = this.sandbox.createElement("iframe") : (s = this.sandbox.createElement("img"), r = a.getAttribute(v.retina() ? "data-image-2x" : "data-image"), s.alt = a.getAttribute("data-alt"), o = this.sandbox.createElement("a"), o.href = a.getAttribute("data-href"), o.appendChild(s)), s.title = a.getAttribute("data-title"), s.src = r, s.width = n.width, s.height = n.height, i = A.closest(O, a, t), c = n.height - a.offsetHeight, a.parentNode.replaceChild(e ? s : o, a), i.style.cssText = "height:" + (i.offsetHeight + c) + "px")
                    },
                    toggleExpando: function(t) {
                        var e, n,
                            i = t.querySelector(O),
                            r = i && i.children[0],
                            s = r && r.getAttribute("data-expanded-media"),
                            a = 0,
                            c = t.querySelector(k),
                            u = c && c.getElementsByTagName("B")[0],
                            d = u && (u.innerText || u.textContent);
                        if (u) {
                            if (this.layout(function() {
                                    u.innerHTML = c.getAttribute("data-toggled-text"), c.setAttribute("data-toggled-text", d)
                                }), _.present(t, j)) return this.layout(function() {
                                        _.remove(t, j)
                                    }), i ? (this.layout(function() {
                                        i.style.cssText = "", r.innerHTML = ""
                                    }), void o.doLayout()) : void o.doLayout();
                            s && (e = this.sandbox.createElement("DIV"), e.innerHTML = s, l.retinize(e), a = this.constrainMedia(e), this.layout(function() {
                                r.appendChild(e)
                            })), i && this.layout(function() {
                                n = Math.max(r.offsetHeight, a), i.style.cssText = "height:" + n + "px"
                            }), this.layout(function() {
                                _.add(t, j)
                            }), o.doLayout()
                        }
                    },
                    recalculateStreamHeight: function(t) {
                        var e = this,
                            n = this.element.querySelector(C),
                            i = this.element.querySelector(R),
                            r = this.element.querySelector(P);
                        this.layout(function() {
                            var s = n.offsetHeight + (i ? i.offsetHeight : 0),
                                o = t || e.sandbox.height();
                            r.style.cssText = "height:" + (o - s - 2) + "px", e.noscrollbar && e.hideStreamScrollBar()
                        })
                    },
                    handleResize: function(t, e) {
                        var n = this,
                            i = Math.min(this.dimensions.DEFAULT_WIDTH, Math.max(this.dimensions.MIN_WIDTH, Math.min(this.predefinedWidth || this.dimensions.DEFAULT_WIDTH, t)));
                        (i != this.width || e != this.height) && (this.width = i, this.height = e, this.setNarrow(), this.constrainMedia(this.element, this.contentWidth(i)), this.staticTimeline ? this.layout(function() {
                            n.height = n.element.offsetHeight, n.sandbox.height(n.height), x.get("events").trigger("resize", {
                                target: n.sandbox.element()
                            })
                        }) : (this.recalculateStreamHeight(e), x.get("events").trigger("resize", {
                            target: this.sandbox.element()
                        })), o.doLayoutAsync())
                    }
                }), e.exports = i
            }, {
            12: 12,
            16: 16,
            17: 17,
            2: 2,
            22: 22,
            3: 3,
            30: 30,
            31: 31,
            38: 38,
            4: 4,
            40: 40,
            41: 41,
            43: 43,
            47: 47,
            5: 5,
            52: 52,
            53: 53,
            54: 54,
            56: 56,
            57: 57,
            6: 6,
            71: 71,
            74: 74
        }],
        49: [function(t, e, n) {
                function i(t) {
                    o.apply(this, [t]);var e = this.params(),
                        n = e.count || this.dataAttr("count"),
                        i = e.size || this.dataAttr("size"),
                        r = u.getScreenNameFromPage(),
                        s = "" + (e.shareWithRetweet || this.dataAttr("share-with-retweet") || a.val("share-with-retweet"));this.classAttr.push("twitter-tweet-button"), "hashtag" == e.type || c.contains(this.classAttr, "twitter-hashtag-button") ? (this.type = "hashtag", this.classAttr.push("twitter-hashtag-button")) : "mention" == e.type || c.contains(this.classAttr, "twitter-mention-button") ? (this.type = "mention", this.classAttr.push("twitter-mention-button")) : this.classAttr.push("twitter-share-button"), this.text = e.text || this.dataAttr("text"), this.text && /\+/.test(this.text) && !/ /.test(this.text) && (this.text = this.text.replace(/\+/g, " ")), this.counturl = e.counturl || this.dataAttr("counturl"), this.searchlink = e.searchlink || this.dataAttr("searchlink"), this.button_hashtag = d.hashTag(e.button_hashtag || e.hashtag || this.dataAttr("button-hashtag"), !1), this.size = "large" == i ? "l" : "m", this.align = e.align || this.dataAttr("align") || "", this.via = e.via || this.dataAttr("via"), this.hashtags = e.hashtags || this.dataAttr("hashtags"), this.screen_name = d.screenName(e.screen_name || e.screenName || this.dataAttr("button-screen-name")), this.url = e.url || this.dataAttr("url"), this.type ? (this.count = "none", this.shareWithRetweet = "never", r && (this.related = this.related ? r + "," + this.related : r)) : (this.text = this.text || l, this.url = this.url || u.getCanonicalURL() || f, this.count = c.contains(p, n) ? n : "horizontal", this.via = this.via || r, s && c.contains(m, s) && (this.shareWithRetweet = s.replace("-", "_")))
                }
                var r = t(9),
                    s = t(10),
                    o = t(43),
                    a = t(15),
                    c = t(74),
                    u = t(73),
                    d = t(70),
                    h = t(56),
                    l = r.title,
                    f = s.href,
                    p = ["vertical", "horizontal", "none"],
                    m = ["never", "publisher-first", "publisher-only", "author-first", "author-only"];
                i.prototype = new o, c.aug(i.prototype, {
                    iframeSource: "widgets/tweet_button.341448ccd3e070268cd097e6a7ee603f.{{lang}}.html",
                    widgetUrlParams: function() {
                        return c.compact({
                            text: this.text,
                            url: this.url,
                            via: this.via,
                            related: this.related,
                            count: this.count,
                            lang: this.lang,
                            counturl: this.counturl,
                            searchlink: this.searchlink,
                            placeid: this.placeid,
                            original_referer: s.href,
                            id: this.id,
                            size: this.size,
                            type: this.type,
                            screen_name: this.screen_name,
                            share_with_retweet: this.shareWithRetweet,
                            button_hashtag: this.button_hashtag,
                            hashtags: this.hashtags,
                            align: this.align,
                            partner: this.partner,
                            dnt: h.enabled(),
                            _: +new Date
                        })
                    },
                    render: function() {
                        var t,
                            e = this,
                            n = this.makeIframeSource();
                        return this.count && this.classAttr.push("twitter-count-" + this.count), t = this.create(n, {
                                title: "Twitter Tweet Button"
                            }).then(function(t) {
                                return e.element = t
                            })
                    }
                }), e.exports = i
            }, {
            10: 10,
            15: 15,
            43: 43,
            56: 56,
            70: 70,
            73: 73,
            74: 74,
            9: 9
        }],
        50: [function(t, e, n) {
                function i(t, e, n, i) {
                    w[t] = w[t] || [], w[t].push({
                        s: n,
                        f: i,
                        lang: e
                    })
                }
                function r(t, e) {
                    var n = {};n[t] = {
                        item_type: 0
                    }, g.clientEvent({
                        page: "video",
                        component: "tweet",
                        action: "results"
                    }, l.aug({}, e, {
                            item_ids: [t],
                            item_details: n
                        }), !0), m.scribeVideoAudienceImpression()
                }
                function s(t, e) {
                    var n = {};n[t] = {
                        item_type: 0
                    }, g.clientEvent({
                        page: "video",
                        component: "rawembedcode",
                        action: "no_results"
                    }, {
                            widget_origin: f.rootDocumentLocation(),
                            widget_frame: f.isFramed() && f.currentDocumentLocation(),
                            message: e,
                            item_ids: [t],
                            item_details: n
                        }, !0), m.scribeVideoAudienceImpression()
                }
                function o(t) {
                    if (t) {
                        u.apply(this, [t]);
                        var e = this.srcEl && this.srcEl.getElementsByTagName("A"),
                            n = e && e[e.length - 1],
                            i = this.params();
                        this.hideStatus = "hidden" === (i.status || this.dataAttr("status")), this.tweetId = i.tweetId || n && v.status(n.href)
                    }
                }
                var a = t(3),
                    c = t(43),
                    u = t(47),
                    d = t(53),
                    h = t(66),
                    l = t(74),
                    f = t(54),
                    p = t(38),
                    m = t(30),
                    g = t(31),
                    v = t(70),
                    y = t(9),
                    w = {},
                    b = [];
                o.prototype = new u, l.aug(o.prototype, {
                    renderedClassNames: "twitter-video twitter-video-rendered",
                    videoPlayer: !0,
                    dimensions: {
                        DEFAULT_HEIGHT: "0",
                        DEFAULT_WIDTH: "0",
                        maxHeight: "500",
                        MIN_WIDTH: "320",
                        MIN_HEIGHT: "180",
                        MARGIN: "10px 0",
                        WIDE_MEDIA_PADDING: 0,
                        NARROW_MEDIA_PADDING: 0,
                        BORDERS: 0
                    },
                    styleSheetUrl: a.video,
                    applyVisibleSandboxStyles: function(t) {
                        return t.style({
                            visibility: "visible"
                        })
                    },
                    applyInitialSandboxStyles: function(t) {
                        return t.style({
                            position: "absolute",
                            top: 0,
                            left: 0,
                            width: "100%",
                            height: "100%",
                            visiblity: "hidden"
                        })
                    },
                    modifyFrame: function(t) {
                        return this.constrainingWrapper = y.createElement("div"), this.constrainingWrapper.style.minWidth = this.dimensions.MIN_WIDTH + "px", this.constrainingWrapper.style.margin = this.dimensions.MARGIN, this.wrapper = y.createElement("div"), this.wrapper.style.position = "relative", this.wrapper.style.height = 0, this.constrainingWrapper.appendChild(this.wrapper), this.wrapper.appendChild(t), this.constrainingWrapper
                    },
                    create: function(t) {
                        var e, n,
                            i = this,
                            s = this.sandbox.createElement("div");
                        if (s.innerHTML = t, e = s.children[0]) {
                            n = e.children[0], this.playerConfig = JSON.parse(e.getAttribute("data-player-config")), this.sandbox.setTitle(e.getAttribute("data-iframe-title") || "Video"), this.sandbox.appendChild(e).then(function() {
                                i.renderedDeferred.resolve(i.sandbox), i.completeDeferred.resolve(i.sandbox.element())
                            });
                            var o = n.getAttribute("data-width"),
                                a = n.getAttribute("data-height"),
                                c = o / a,
                                u = 1 / c * 100 + "%";
                            return this.layout(function() {
                                    i.wrapper.style.paddingBottom = u, i.constrainingWrapper.style.maxWidth = parseInt(i.dimensions.maxHeight, 10) * c + "px"
                                }), r(this.tweetId, this.baseScribeData()), e
                        }
                    },
                    render: function() {
                        var t = this;
                        return this.tweetId ? (this.rendered().then(function() {
                            var e = t.srcEl;
                            e && e.parentNode && t.layout(function() {
                                e.parentNode.removeChild(e)
                            })
                        }), i(this.tweetId, this.lang, function(e) {
                            t.ready().then(function() {
                                t.element = t.create(e), t.readTimestampTranslations(), t.writePlayerConfig()
                            })
                        }, function() {
                                s(t.tweetId, t.partner), t.completeDeferred.resolve(t.srcEl)
                            }), b.push(this.completed()), this.completed()) : (this.completeDeferred.resolve(this.srcEl), this.completed())
                    },
                    baseScribeData: function() {
                        return {
                            widget_origin: f.rootDocumentLocation(),
                            widget_frame: f.isFramed() && f.currentDocumentLocation(),
                            message: this.partner
                        }
                    },
                    readTimestampTranslations: function() {
                        var t = this.element,
                            e = "data-dt-",
                            n = t.getAttribute(e + "months") || "";
                        this.datetime = new d(l.compact({
                            phrases: {
                                AM: t.getAttribute(e + "am"),
                                PM: t.getAttribute(e + "pm")
                            },
                            months: n.split("|"),
                            formats: {
                                full: t.getAttribute(e + "full")
                            }
                        }))
                    },
                    getTimestamp: function() {
                        var t = this.element.getAttribute("data-datetime"),
                            e = t && this.datetime.localTimeStamp(t);
                        return {
                            local: e
                        }
                    },
                    writePlayerConfig: function() {
                        this.playerConfig.statusTimestamp = this.getTimestamp(), this.playerConfig.hideStatus = this.hideStatus, this.element.setAttribute("data-player-config", JSON.stringify(this.playerConfig))
                    }
                }), o.fetchAndRender = function() {
                    var t = w,
                        e = [];
                    w = {};
                    for (var n in t) t.hasOwnProperty(n) && e.push(n);
                    e.length && (p.videos({
                        ids: e.sort(),
                        lang: t[e[0]][0].lang,
                        complete: function(e) {
                            l.forIn(e, function(e, n) {
                                var i = t[e];
                                i.forEach(function(t) {
                                    t.s && t.s.call(this, n)
                                }),
                                delete t[e]
                            }), l.forIn(t, function(t, e) {
                                e.forEach(function(e) {
                                    e.f && e.f.call(this, t)
                                })
                            })
                        }
                    }), h.all(b), b = [])
                }, c.afterLoad(o.fetchAndRender), e.exports = o
            }, {
            3: 3,
            30: 30,
            31: 31,
            38: 38,
            43: 43,
            47: 47,
            53: 53,
            54: 54,
            66: 66,
            70: 70,
            74: 74,
            9: 9
        }],
        51: [function(t, e, n) {
                function i(t) {
                    return c.parseInt(t, 16)
                }
                function r(t) {
                    return u.isType("string", t) ? (t = t.replace(d, ""), t += 3 === t.length ? t : "") : null
                }
                function s(t, e) {
                    var n, s, o, a;return t = r(t), e = e || 0, t ? (n = 0 > e ? 0 : 255, e = 0 > e ? -Math.max(e, -1) : Math.min(e, 1), s = i(t.substring(0, 2)), o = i(t.substring(2, 4)), a = i(t.substring(4, 6)), "#" + (16777216 + 65536 * (Math.round((n - s) * e) + s) + 256 * (Math.round((n - o) * e) + o) + (Math.round((n - a) * e) + a)).toString(16).slice(1)) : void 0
                }
                function o(t, e) {
                    return s(t, -e)
                }
                function a(t, e) {
                    return s(t, e)
                }
                var c = t(12),
                    u = t(74),
                    d = /^#/;
                e.exports = {
                    darken: o,
                    lighten: a
                }
            }, {
            12: 12,
            74: 74
        }],
        52: [function(t, e, n) {
                e.exports = {
                    sanitize: function(t, e, n) {
                        var i,
                            r = /^[\w ,%\/"'\-_#]+$/,
                            s = t && t.split(";").map(function(t) {
                                return t.split(":").slice(0, 2).map(function(t) {
                                    return t.trim()
                                })
                            }),
                            o = 0,
                            a = [],
                            c = n ? "!important" : "";
                        for (e = e || /^(font|text\-|letter\-|color|line\-)[\w\-]*$/; s && (i = s[o]); o++) {
                            i[0].match(e) && i[1].match(r) && a.push(i.join(":") + c);
                        }
                        return a.join(";")
                    }
                }
        }, {}],
        53: [function(t, e, n) {
                function i(t) {
                    return 10 > t ? "0" + t : t
                }
                function r(t) {
                    function e(t, e) {
                        return n && n[t] && (t = n[t]), t.replace(/%\{([\w_]+)\}/g, function(t, n) {
                                return void 0 !== e[n] ? e[n] : t
                            })
                    }
                    var n = t && t.phrases,
                        s = t && t.months || c,
                        o = t && t.formats || u;this.timeAgo = function(t) {
                        var n,
                            i = r.parseDate(t),
                            a = +new Date,
                            c = a - i;
                        return i ? isNaN(c) || 2 * d > c ? e("now") : h > c ? (n = Math.floor(c / d), e(o.abbr, {
                            number: n,
                            symbol: e(p, {
                                abbr: e("s"),
                                expanded: e(n > 1 ? "seconds" : "second")
                            })
                        })) : l > c ? (n = Math.floor(c / h), e(o.abbr, {
                            number: n,
                            symbol: e(p, {
                                abbr: e("m"),
                                expanded: e(n > 1 ? "minutes" : "minute")
                            })
                        })) : f > c ? (n = Math.floor(c / l), e(o.abbr, {
                            number: n,
                            symbol: e(p, {
                                abbr: e("h"),
                                expanded: e(n > 1 ? "hours" : "hour")
                            })
                        })) : 365 * f > c ? e(o.shortdate, {
                            day: i.getDate(),
                            month: e(s[i.getMonth()])
                        }) : e(o.longdate, {
                            day: i.getDate(),
                            month: e(s[i.getMonth()]),
                            year: i.getFullYear().toString().slice(2)
                        }) : ""
                    }, this.localTimeStamp = function(t) {
                        var n = r.parseDate(t),
                            a = n && n.getHours();
                        return n ? e(o.full, {
                            day: n.getDate(),
                            month: e(s[n.getMonth()]),
                            year: n.getFullYear(),
                            hours24: i(a),
                            hours12: 13 > a ? a ? a : "12" : a - 12,
                            minutes: i(n.getMinutes()),
                            seconds: i(n.getSeconds()),
                            amPm: e(12 > a ? "AM" : "PM")
                        }) : ""
                    }
                }
                var s = /(\d{4})-?(\d{2})-?(\d{2})T(\d{2}):?(\d{2}):?(\d{2})(Z|[\+\-]\d{2}:?\d{2})/,
                    o = /[a-z]{3,4} ([a-z]{3}) (\d{1,2}) (\d{1,2}):(\d{2}):(\d{2}) ([\+\-]\d{2}:?\d{2}) (\d{4})/i,
                    a = /^\d+$/,
                    c = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                    u = {
                        abbr: "%{number}%{symbol}",
                        shortdate: "%{day} %{month}",
                        longdate: "%{day} %{month} %{year}",
                        full: "%{hours12}:%{minutes} %{amPm} - %{day} %{month} %{year}"
                    },
                    d = 1e3,
                    h = 60 * d,
                    l = 60 * h,
                    f = 24 * l,
                    p = '<abbr title="%{expanded}">%{abbr}</abbr>';
                r.parseDate = function(t) {
                    var e, n,
                        i = t || "",
                        r = i.toString();
                    return (e = function() {
                        var t;
                        return a.test(r) ? parseInt(r, 10) : (t = r.match(o)) ? Date.UTC(t[7], c.indexOf(t[1]), t[2], t[3], t[4], t[5]) : (t = r.match(s)) ? Date.UTC(t[1], t[2] - 1, t[3], t[4], t[5], t[6]) : void 0
                    }()) ? (n = new Date(e), !isNaN(n.getTime()) && n) : !1
                }, e.exports = r
        }, {}],
        54: [function(t, e, n) {
                function i(t) {
                    return t && c.isType("string", t) && (u = t), u
                }
                function r() {
                    return d
                }
                function s() {
                    return u !== d
                }
                var o = t(10),
                    a = t(73),
                    c = t(74),
                    u = a.getCanonicalURL() || o.href,
                    d = u;
                e.exports = {
                    isFramed: s,
                    rootDocumentLocation: i,
                    currentDocumentLocation: r
                }
            }, {
            10: 10,
            73: 73,
            74: 74
        }],
        55: [function(t, e, n) {
                function i() {
                    u = 1;
                    for (var t = 0, e = d.length; e > t; t++) {
                        d[t]()
                    }
                }
                var r, s, o,
                    a = t(9),
                    c = t(12),
                    u = 0,
                    d = [],
                    h = !1,
                    l = a.createElement("a");
                /^loade|c/.test(a.readyState) && (u = 1), a.addEventListener && a.addEventListener("DOMContentLoaded", s = function() {
                    a.removeEventListener("DOMContentLoaded", s, h), i()
                }, h), l.doScroll && a.attachEvent("onreadystatechange", r = function() {
                    /^c/.test(a.readyState) && (a.detachEvent("onreadystatechange", r), i())
                }), o = l.doScroll ? function(t) {
                    c.self != c.top ? u ? t() : d.push(t) : !function() {
                        try {
                            l.doScroll("left")
                        } catch ( e ) {
                            return setTimeout(function() {
                                o(t)
                            }, 50)
                        } t()
                    }()
                } : function(t) {
                    u ? t() : d.push(t)
                }, e.exports = o
            }, {
            12: 12,
            9: 9
        }],
        56: [function(t, e, n) {
                function i() {
                    l = !0
                }
                function r(t, e) {
                    return l ? !0 : d.asBoolean(h.val("dnt")) ? !0 : !a || 1 != a.doNotTrack && 1 != a.msDoNotTrack ? u.isUrlSensitive(e || o.host) ? !0 : c.isFramed() && u.isUrlSensitive(c.rootDocumentLocation()) ? !0 : (t = f.test(t || s.referrer) && RegExp.$1, t && u.isUrlSensitive(t) ? !0 : !1) : !0
                }
                var s = t(9),
                    o = t(10),
                    a = t(11),
                    c = t(54),
                    u = t(69),
                    d = t(71),
                    h = t(15),
                    l = !1,
                    f = /https?:\/\/([^\/]+).*/i;
                e.exports = {
                    setOn: i,
                    enabled: r
                }
            }, {
            10: 10,
            11: 11,
            15: 15,
            54: 54,
            69: 69,
            71: 71,
            9: 9
        }],
        57: [function(t, e, n) {
                function i(t) {
                    return t = t || g, t.devicePixelRatio ? t.devicePixelRatio >= 1.5 : t.matchMedia ? t.matchMedia("only screen and (min-resolution: 144dpi)").matches : !1
                }
                function r(t) {
                    return t = t || E, /(Trident|MSIE \d)/.test(t)
                }
                function s(t) {
                    return t = t || E, /MSIE 9/.test(t)
                }
                function o(t) {
                    return t = t || E, /(iPad|iPhone|iPod)/.test(t)
                }
                function a(t) {
                    return t = t || E, /^Mozilla\/5\.0 \(Linux; (U; )?Android/.test(t)
                }
                function c() {
                    return T
                }
                function u(t, e) {
                    return t = t || g, e = e || E, t.postMessage && !(r(e) && t.opener)
                }
                function d(t) {
                    t = t || m;try {
                        return !!t.plugins["Shockwave Flash"] || !!new ActiveXObject("ShockwaveFlash.ShockwaveFlash")
                    } catch ( e ) {
                        return !1
                    }
                }
                function h(t, e, n) {
                    return t = t || g, e = e || m, n = n || E, "ontouchstart" in t || /Opera Mini/.test(n) || e.msMaxTouchPoints > 0
                }
                function l() {
                    var t = p.body.style;return void 0 !== t.transition || void 0 !== t.webkitTransition || void 0 !== t.mozTransition || void 0 !== t.oTransition || void 0 !== t.msTransition
                }
                function f() {
                    return !!(g.Promise && g.Promise.resolve && g.Promise.reject && g.Promise.all && g.Promise.race && function() {
                            var t;
                            return new g.Promise(function(e) {
                                    t = e
                                }), b.isType("function", t)
                        }())
                }
                var p = t(9),
                    m = t(11),
                    g = t(12),
                    v = t(55),
                    y = t(62),
                    w = t(71),
                    b = t(74),
                    _ = t(15),
                    A = t(16),
                    E = m.userAgent,
                    T = !1,
                    x = !1,
                    I = "twitter-csp-test";
                A.set("verifyCSP", function(t) {
                    var e = p.getElementById(I);
                    x = !0, T = !!t, e && e.parentNode.removeChild(e)
                }), v(function() {
                    var t;
                    return w.asBoolean(_.val("widgets:csp")) ? T = !0 : (t = p.createElement("script"), t.id = I, t.text = A.fullPath("verifyCSP") + "(false);", p.body.appendChild(t), void g.setTimeout(function() {
                        x || (y.warn('TWITTER: Content Security Policy restrictions may be applied to your site. Add <meta name="twitter:widgets:csp" content="on"> to supress this warning.'), y.warn("TWITTER: Please note: Not all embedded timeline and embedded Tweet functionality is supported when CSP is applied."))
                    }, 5e3))
                }), e.exports = {
                    retina: i,
                    anyIE: r,
                    ie9: s,
                    ios: o,
                    android: a,
                    cspEnabled: c,
                    flashEnabled: d,
                    canPostMessage: u,
                    touch: h,
                    cssTransitions: l,
                    hasPromiseSupport: f
                }
            }, {
            11: 11,
            12: 12,
            15: 15,
            16: 16,
            55: 55,
            62: 62,
            71: 71,
            74: 74,
            9: 9
        }],
        58: [function(t, e, n) {
                var i = t(74),
                    r = {
                        bind: function(t, e) {
                            return this._handlers = this._handlers || {}, this._handlers[t] = this._handlers[t] || [], this._handlers[t].push(e)
                        },
                        unbind: function(t, e) {
                            if (this._handlers[t])
                                if (e) {
                                    var n = this._handlers[t].indexOf(e);
                                    n >= 0 && this._handlers[t].splice(n, 1)
                                } else {
                                    this._handlers[t] = []
                            }
                        },
                        trigger: function(t, e) {
                            var n = this._handlers && this._handlers[t];
                            e = e || {}, e.type = t, n && n.forEach(function(t) {
                                i.async(t.bind(this, e))
                            })
                        }
                    };
                e.exports = {
                    Emitter: r
                }
            }, {
            74: 74
        }],
        59: [function(t, e, n) {
                function i(t) {
                    for (var e, n = r.getElementsByTagName("iframe"), i = 0; e = n[i]; i++)
                        if (e.contentWindow === t) return e
                }
                var r = t(9);
                e.exports = i
            }, {
            9: 9
        }],
        60: [function(t, e, n) {
                var i = t(9),
                    r = t(74);
                e.exports = function(t, e, n) {
                    var s;
                    if (n = n || i, t = t || {}, e = e || {}, t.name) {
                        try {
                            s = n.createElement('<iframe name="' + t.name + '"></iframe>')
                        } catch ( o ) {
                            s = n.createElement("iframe"), s.name = t.name
                        }
                        delete t.name
                    } else {
                        s = n.createElement("iframe");
                    }
                    return t.id && (s.id = t.id,
                        delete t.id
                        ), s.allowtransparency = "true", s.scrolling = "no", s.setAttribute("frameBorder", 0), s.setAttribute("allowTransparency", !0), r.forIn(t, function(t, e) {
                            s.setAttribute(t, e)
                        }), r.forIn(e, function(t, e) {
                            s.style[t] = e
                        }), s
                }
            }, {
            74: 74,
            9: 9
        }],
        61: [function(t, e, n) {
                function i() {
                }
                var r,
                    s = t(12),
                    o = t(65),
                    a = [];
                i.prototype.enqueue = function(t, e) {
                    var n = new o;
                    return a.push({
                            action: t,
                            deferred: n,
                            note: e
                        }), n.promise
                }, i.prototype.exec = function() {
                    var t,
                        e = a;
                    if (e.length)
                        for (a = []; e.length; ) {
                            t = e.shift(), t && t.action ? t.deferred.resolve(t.action()) : t.deferred.reject()
                    }
                }, i.prototype.delayedExec = function() {
                    r && s.clearTimeout(r), r = s.setTimeout(this.exec, 100)
                }, e.exports = i
            }, {
            12: 12,
            65: 65
        }],
        62: [function(t, e, n) {
                function i() {
                    u("info", l.toRealArray(arguments))
                }
                function r() {
                    u("warn", l.toRealArray(arguments))
                }
                function s() {
                    u("error", l.toRealArray(arguments))
                }
                function o(t) {
                    m && (p[t] = c())
                }
                function a(t) {
                    var e;m && (p[t] ? (e = c(), i("_twitter", t, e - p[t])) : s("timeEnd() called before time() for id: ", t))
                }
                function c() {
                    return h.performance && +h.performance.now() || +new Date
                }
                function u(t, e) {
                    if (h[f] && h[f][t]) switch (e.length) {
                            case 1:h[f][t](e[0]);break;case 2:h[f][t](e[0], e[1]);break;case 3:h[f][t](e[0], e[1], e[2]);break;case 4:h[f][t](e[0], e[1], e[2], e[3]);break;case 5:h[f][t](e[0], e[1], e[2], e[3], e[4]);break;default:0 !== e.length && h[f].warn && h[f].warn("too many params passed to logger." + t)
                    }
                }
                var d = t(10),
                    h = t(12),
                    l = t(74),
                    f = ["con", "sole"].join(""),
                    p = {},
                    m = l.contains(d.href, "tw_debug=true");
                e.exports = {
                    info: i,
                    warn: r,
                    error: s,
                    time: o,
                    timeEnd: a
                }
            }, {
            10: 10,
            12: 12,
            74: 74
        }],
        63: [function(t, e, n) {
                function i(t) {
                    return function(e) {
                        return s.hasValue(e[t])
                    }
                }
                function r() {
                    this.assertions = [], this._defaults = {}
                }
                var s = t(71),
                    o = t(74);
                r.prototype.assert = function(t, e) {
                    return this.assertions.push({
                            fn: t,
                            msg: e || "assertion failed"
                        }), this
                }, r.prototype.defaults = function(t) {
                    return this._defaults = t || this._defaults, this
                }, r.prototype.require = function(t) {
                    var e = this;
                    return t = Array.isArray(t) ? t : o.toRealArray(arguments), t.forEach(function(t) {
                            e.assert(i(t), "required: " + t)
                        }), this
                }, r.prototype.parse = function(t) {
                    var e, n;
                    if (e = o.aug({}, this._defaults, t || {}), n = this.assertions.reduce(function(t, n) {
                            return n.fn(e) || t.push(n.msg), t
                        }, []), n.length > 0)
                        throw new Error(n.join("\n"));
                    return e
                }, e.exports = r
            }, {
            71: 71,
            74: 74
        }],
        64: [function(t, e, n) {
                var i, r, s,
                    o = t(68);
                i = function(t) {
                    var e = t.search.substr(1);
                    return o.decode(e)
                }, r = function(t) {
                    var e = t.href,
                        n = e.indexOf("#"),
                        i = 0 > n ? "" : e.substring(n + 1);
                    return o.decode(i)
                }, s = function(t) {
                    var e,
                        n = {},
                        s = i(t),
                        o = r(t);
                    for (e in s) s.hasOwnProperty(e) && (n[e] = s[e]);
                    for (e in o) o.hasOwnProperty(e) && (n[e] = o[e]);
                    return n
                }, e.exports = {
                    combined: s,
                    fromQuery: i,
                    fromFragment: r
                }
            }, {
            68: 68
        }],
        65: [function(t, e, n) {
                function i() {
                    var t = this;
                    this.promise = new r(function(e, n) {
                        t.resolve = e, t.reject = n
                    })
                }
                var r = t(66);
                e.exports = i
            }, {
            66: 66
        }],
        66: [function(t, e, n) {
                var i = t(1).Promise,
                    r = t(12),
                    s = t(57);
                e.exports = s.hasPromiseSupport() ? r.Promise : i
            }, {
            1: 1,
            12: 12,
            57: 57
        }],
        67: [function(t, e, n) {
                function i(t) {
                    var e;return t = t || [], e = t.length, t = t.filter(r), e ? e !== t.length ? s.reject("non-Promise passed to .some") : new s(function(e, n) {
                            function i() {
                                r += 1, r === t.length && n()
                            }
                            var r = 0;
                            t.forEach(function(t) {
                                t.then(e, i)
                            })
                        }) : s.reject("no promises passed to .some")
                }
                function r(t) {
                    return t instanceof s
                }
                var s = t(66);
                e.exports = {
                    some: i,
                    isPromise: r
                }
            }, {
            66: 66
        }],
        68: [function(t, e, n) {
                function i(t) {
                    return encodeURIComponent(t).replace(/\+/g, "%2B").replace(/'/g, "%27")
                }
                function r(t) {
                    return decodeURIComponent(t)
                }
                function s(t) {
                    var e = [];return d.forIn(t, function(t, n) {
                            var r = i(t);
                            d.isType("array", n) || (n = [n]), n.forEach(function(t) {
                                u.hasValue(t) && e.push(r + "=" + i(t))
                            })
                        }), e.sort().join("&")
                }
                function o(t) {
                    var e,
                        n = {};return t ? (e = t.split("&"), e.forEach(function(t) {
                        var e = t.split("="),
                            i = r(e[0]),
                            s = r(e[1]);
                        return 2 == e.length ? d.isType("array", n[i]) ? void n[i].push(s) : i in n ? (n[i] = [n[i]], void n[i].push(s)) : void (n[i] = s) : void 0
                    }), n) : {}
                }
                function a(t, e) {
                    var n = s(e);return n.length > 0 ? d.contains(t, "?") ? t + "&" + s(e) : t + "?" + s(e) : t
                }
                function c(t) {
                    var e = t && t.split("?");return 2 == e.length ? o(e[1]) : {}
                }
                var u = t(71),
                    d = t(74);
                e.exports = {
                    url: a,
                    decodeURL: c,
                    decode: o,
                    encode: s,
                    encodePart: i,
                    decodePart: r
                }
            }, {
            71: 71,
            74: 74
        }],
        69: [function(t, e, n) {
                function i(t) {
                    return t in a ? a[t] : a[t] = o.test(t)
                }
                function r() {
                    return i(s.host)
                }
                var s = t(10),
                    o = /^[^#?]*\.(gov|mil)(:\d+)?([#?].*)?$/i,
                    a = {};
                e.exports = {
                    isUrlSensitive: i,
                    isHostPageSensitive: r
                }
            }, {
            10: 10
        }],
        70: [function(t, e, n) {
                function i(t) {
                    return "string" == typeof t && m.test(t) && RegExp.$1.length <= 20
                }
                function r(t) {
                    return i(t) ? RegExp.$1 : void 0
                }
                function s(t, e) {
                    var n = p.decodeURL(t);return e = e || !1, n.screen_name = r(t), n.screen_name ? p.url("https://twitter.com/intent/" + (e ? "follow" : "user"), n) : void 0
                }
                function o(t) {
                    return s(t, !0)
                }
                function a(t) {
                    return "string" == typeof t && w.test(t)
                }
                function c(t, e) {
                    return e = void 0 === e ? !0 : e, a(t) ? (e ? "#" : "") + RegExp.$1 : void 0
                }
                function u(t) {
                    return "string" == typeof t && g.test(t)
                }
                function d(t) {
                    return u(t) && RegExp.$1
                }
                function h(t) {
                    return v.test(t)
                }
                function l(t) {
                    return y.test(t)
                }
                function f(t) {
                    return b.test(t)
                }
                var p = t(68),
                    m = /(?:^|(?:https?\:)?\/\/(?:www\.)?twitter\.com(?:\:\d+)?(?:\/intent\/(?:follow|user)\/?\?screen_name=|(?:\/#!)?\/))@?([\w]+)(?:\?|&|$)/i,
                    g = /(?:^|(?:https?\:)?\/\/(?:www\.)?twitter\.com(?:\:\d+)?\/(?:#!\/)?[\w_]+\/status(?:es)?\/)(\d+)/i,
                    v = /^http(s?):\/\/(\w+\.)*twitter\.com([\:\/]|$)/i,
                    y = /^http(s?):\/\/pbs\.twimg\.com\//,
                    w = /^#?([^.,<>!\s\/#\-\(\)\'\"]+)$/,
                    b = /twitter\.com(\:\d{2,4})?\/intent\/(\w+)/;
                e.exports = {
                    isHashTag: a,
                    hashTag: c,
                    isScreenName: i,
                    screenName: r,
                    isStatus: u,
                    status: d,
                    intentForProfileURL: s,
                    intentForFollowURL: o,
                    isTwitterURL: h,
                    isTwimgURL: l,
                    isIntentURL: f,
                    regexen: {
                        profile: m
                    }
                }
            }, {
            68: 68
        }],
        71: [function(t, e, n) {
                function i(t) {
                    return void 0 !== t && null !== t && "" !== t
                }
                function r(t) {
                    return o(t) && t % 1 === 0
                }
                function s(t) {
                    return o(t) && !r(t)
                }
                function o(t) {
                    return i(t) && !isNaN(t)
                }
                function a(t) {
                    return i(t) && "array" == l.toType(t)
                }
                function c(t) {
                    if (!i(t)) return !1;
                    switch (t) {
                        case "1":case "on":case "ON":case "true":case "TRUE":case "yes":case "YES":return !0;case "0":case "off":case "OFF":case "false":case "FALSE":case "no":case "NO":return !1;default:return !!t
                    }
                }
                function u(t) {
                    return o(t) ? t : void 0
                }
                function d(t) {
                    return s(t) ? t : void 0
                }
                function h(t) {
                    return r(t) ? t : void 0
                }
                var l = t(74);
                e.exports = {
                    hasValue: i,
                    isInt: r,
                    isFloat: s,
                    isNumber: o,
                    isArray: a,
                    asInt: h,
                    asFloat: d,
                    asNumber: u,
                    asBoolean: c
                }
            }, {
            74: 74
        }],
        72: [function(t, e, n) {
                function i() {
                    return String(+new Date) + Math.floor(1e5 * Math.random()) + r++
                }
                var r = 0;
                e.exports = {
                    generate: i
                }
        }, {}],
        73: [function(t, e, n) {
                function i(t, e) {
                    var n, i;return e = e || a, /^https?:\/\//.test(t) ? t : /^\/\//.test(t) ? e.protocol + t : (n = e.host + (e.port.length ? ":" + e.port : ""), 0 !== t.indexOf("/") && (i = e.pathname.split("/"), i.pop(), i.push(t), t = "/" + i.join("/")), [e.protocol, "//", n, t].join(""))
                }
                function r() {
                    for (var t, e = o.getElementsByTagName("link"), n = 0; t = e[n]; n++)
                        if ("canonical" == t.rel) return i(t.href);

                }
                function s() {
                    for (var t, e, n, i = o.getElementsByTagName("a"), r = o.getElementsByTagName("link"), s = [i, r], a = 0, u = 0, d = /\bme\b/; t = s[a]; a++)
                        for (u = 0; e = t[u]; u++)
                            if (d.test(e.rel) && (n = c.screenName(e.href))) return n
                }
                var o = t(9),
                    a = t(10),
                    c = t(70);
                e.exports = {
                    absolutize: i,
                    getCanonicalURL: r,
                    getScreenNameFromPage: s
                }
            }, {
            10: 10,
            70: 70,
            9: 9
        }],
        74: [function(t, e, n) {
                function i(t) {
                    return h(arguments).slice(1).forEach(function(e) {
                            s(e, function(e, n) {
                                t[e] = n
                            })
                        }), t
                }
                function r(t) {
                    return s(t, function(e, n) {
                            c(n) && (r(n), u(n) &&
                            delete t[e]
                            ), (void 0 === n || null === n || "" === n) &&
                            delete t[e]
                        }), t
                }
                function s(t, e) {
                    for (var n in t) (!t.hasOwnProperty || t.hasOwnProperty(n)) && e(n, t[n]);
                    return t
                }
                function o(t) {
                    return {}.toString.call(t).match(/\s([a-zA-Z]+)/)[1].toLowerCase()
                }
                function a(t, e) {
                    return t == o(e)
                }
                function c(t) {
                    return t === Object(t)
                }
                function u(t) {
                    if (!c(t)) return !1;
                    if (Object.keys) return !Object.keys(t).length;
                    for (var e in t)
                        if (t.hasOwnProperty(e)) return !1;
                    return !0
                }
                function d(t, e) {
                    f.setTimeout(function() {
                        t.call(e || null)
                    }, 0)
                }
                function h(t) {
                    return Array.prototype.slice.call(t)
                }
                function l(t, e) {
                    return t && t.indexOf ? t.indexOf(e) > -1 : !1
                }
                var f = t(12);
                e.exports = {
                    aug: i,
                    async: d,
                    compact: r,
                    contains: l,
                    forIn: s,
                    isObject: c,
                    isEmptyObject: u,
                    toType: o,
                    isType: a,
                    toRealArray: h
                }
            }, {
            12: 12
        }],
        75: [function(t, e, n) {
                function i() {
                    if (s) return s;
                    if (u.isDynamicWidget()) {
                        var t,
                            e = 0,
                            n = c.parent.frames.length;
                        try {
                            if (s = c.parent.frames[l]) return s
                        } catch ( i ) {}
                        if (d.anyIE())
                            for (; n > e; e++) try {
                                    if (t = c.parent.frames[e], t && "function" == typeof t.openIntent) return s = t
                                } catch ( i ) {}
                    }
                }
                function r() {
                    var t, e, n, s, a, d,
                        h = {};
                    if ("function" === (typeof arguments[0]).toLowerCase() ? h.success = arguments[0] : h = arguments[0], t = h.success || function() {}, e = h.timeout || function() {}, n = h.nohub || function() {}, s = h.complete || function() {}, a = void 0 !== h.attempt ? h.attempt : m, !u.isDynamicWidget() || o) return n(), s(), !1;
                    d = i(), a--;try {
                        if (d && d.trigger) return t(d), void s()
                    } catch ( l ) {} return 0 >= a ? (o = !0, e(), void s()) : +new Date - f > p * m ? (o = !0, void n()) : void c.setTimeout(function() {
                        r({
                            success: t,
                            timeout: e,
                            nohub: n,
                            attempt: a,
                            complete: s
                        })
                    }, p)
                }
                var s, o,
                    a = t(10),
                    c = t(12),
                    u = t(39),
                    d = t(57),
                    h = "twttrHubFrameSecure",
                    l = "http:" == a.protocol ? "twttrHubFrame" : h,
                    f = +new Date,
                    p = 100,
                    m = 20;
                e.exports = {
                    withHub: r,
                    contextualHubId: l,
                    secureHubId: h
                }
            }, {
            10: 10,
            12: 12,
            39: 39,
            57: 57
        }],
        76: [function(t, e, n) {
                e.exports = {
                    version: "f5045446417440a57140409dd3a851300aa9ddbd:1430170814284"
                }
        }, {}],
        77: [function(t, e, n) {
                e.exports = {
                    css: "1b8dc0da7dca587361635cb7eae65382"
                }
        }, {}],
        78: [function(t, e, n) {
                function i(t, e) {
                    return t && t.getAttribute ? t.getAttribute("data-" + e) : void 0
                }
                function r(t, e) {
                    return {
                        element: t.element || g,
                        action: t.action || v,
                        page: s(e) ? "video" : void 0
                    }
                }
                function s(t) {
                    return d.closest(".embedded-video", t)
                }
                function o(t) {
                    return JSON.parse(i(s(t), "player-config"))
                }
                function a(t, e) {
                    var n, r, o,
                        a = s(e);return a ? n = u.aug({
                            item_type: p,
                            card_type: m,
                            id: i(a, "tweet-id"),
                            card_name: i(a, "card-name"),
                            publisher_id: i(a, "publisher-id"),
                            content_id: i(a, "content-id")
                        }, t.itemData || {}) : (r = d.closest(".cards-multimedia", e), o = d.closest(".tweet", e), n = u.aug({
                            item_type: p,
                            card_type: m,
                            id: i(o, "tweet-id"),
                            card_name: i(r, "card-name"),
                            publisher_id: i(r, "publisher-id"),
                            content_id: i(r, "video-content-id")
                        }, t.itemData || {})), {
                            items: [n]
                    }
                }
                function c(t) {
                    var e = this;this.global = t, this.server = (new h).attachReceiver(new f.Receiver(t, "")).bind("scribe", function(t) {
                        e.scribe(t, this)
                    }).bind("requestPlayerConfig", function() {
                        return e.requestPlayerConfig(this)
                    })
                }
                var u = t(74),
                    d = t(6),
                    h = t(25),
                    l = t(32),
                    f = t(26),
                    p = 0,
                    m = 6,
                    g = "amplify_player",
                    v = "undefined";
                c.prototype.findIframeByWindow = function(t) {
                    for (var e = this.global.document.getElementsByTagName("iframe"), n = e.length, i = 0; n > i; i++)
                        if (e[i].contentWindow == t) return e[i]
                }, c.prototype.requestPlayerConfig = function(t) {
                    var e = this.findIframeByWindow(t);
                    if (e) return o(e)
                }, c.prototype.scribe = function(t, e) {
                    var n, i, s, o;
                    n = t && t.customScribe, i = this.findIframeByWindow(e), n && i && (s = r(n, i), o = a(n, i), l.clientEvent2(s, o, !0))
                }, e.exports = c
            }, {
            25: 25,
            26: 26,
            32: 32,
            6: 6,
            74: 74
        }],
        79: [function(t, e, n) {
                !function() {
                    var e = t(9),
                        n = t(36),
                        i = t(55),
                        r = t(62),
                        s = t(22),
                        o = t(43),
                        a = t(45),
                        c = t(49),
                        u = t(44),
                        d = t(48),
                        h = t(50),
                        l = t(46),
                        f = t(34),
                        p = t(58),
                        m = t(35),
                        g = t(20),
                        v = t(17),
                        y = t(16),
                        w = t(13),
                        b = t(65),
                        _ = t(42);
                    if (y.init("host", "platform.twitter.com"), s.start("widgets-js-load"), n.requestArticleUrl(), _(), y.get("widgets.loaded")) return v.call("widgets.load"), !1;
                    if (y.get("widgets.init")) return !1;
                    y.set("widgets.init", !0), v.set("init", !0);
                    var A = new b;
                    w.exposeReadyPromise(A.promise, v.base, "_e"), v.set("events", {
                        bind: function(t, e) {
                            A.promise.then(function(n) {
                                n.events.bind(t, e)
                            })
                        }
                    }), i(function() {
                        function t() {
                            y.set("eventsHub", m.init()), m.init(!0)
                        }
                        var n,
                            i = {
                                "a.twitter-share-button": c,
                                "a.twitter-mention-button": c,
                                "a.twitter-hashtag-button": c,
                                "a.twitter-follow-button": a,
                                "blockquote.twitter-tweet": u,
                                "a.twitter-timeline": d,
                                "div.twitter-timeline": d,
                                "blockquote.twitter-video": h,
                                body: l
                            },
                            s = y.get("eventsHub") ? v.get("events") : {};
                        v.aug("widgets", f, {
                            load: function(t) {
                                r.time("load"), o.init(i), o.embed(t), y.set("widgets.loaded", !0)
                            }
                        }), v.aug("events", s, p.Emitter), n = v.get("events.bind"), v.set("events.bind", function(e, i) {
                            t(), this.bind = n, this.bind(e, i)
                        }), A.resolve(v.base), g.attachTo(e), v.call("widgets.load")
                    })
                }()
            }, {
            13: 13,
            16: 16,
            17: 17,
            20: 20,
            22: 22,
            34: 34,
            35: 35,
            36: 36,
            42: 42,
            43: 43,
            44: 44,
            45: 45,
            46: 46,
            48: 48,
            49: 49,
            50: 50,
            55: 55,
            58: 58,
            62: 62,
            65: 65,
            9: 9
        }],
        80: [function(t, e, n) {
                function i() {
                }
                var r = t(74),
                    s = t(58);
                r.aug(i.prototype, s.Emitter, {
                    transportMethod: "",
                    init: function() {},
                    send: function(t) {
                        var e;
                        this._ready ? this._performSend(t) : e = this.bind("ready", function() {
                            this.unbind("ready", e), this._performSend(t)
                        })
                    },
                    ready: function() {
                        this.trigger("ready", this), this._ready = !0
                    },
                    isReady: function() {
                        return !!this._ready
                    },
                    receive: function(t) {
                        this.trigger("message", t)
                    }
                }), e.exports = {
                    Connection: i
                }
            }, {
            58: 58,
            74: 74
        }],
        81: [function(t, e, n) {
                function i(t, e) {
                    var n = e || Math.floor(100 * Math.random()),
                        i = ['<object id="xdflashshim' + n + '" name="xdflashshim' + n + '"', 'type="application/x-shockwave-flash" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"', 'width="1" height="1" style="position:absolute;left:-9999px;top:-9999px;">', '<param name="movie" value="' + t + "&debug=" + r.__XDDEBUG__ + '">', '<param name="wmode" value="window">', '<param name="allowscriptaccess" value="always">', "</object>"].join(" ");return i
                }
                var r = t(12);
                e.exports = {
                    object: i
                }
            }, {
            12: 12
        }],
        82: [function(t, e, n) {
                function i(t) {
                    return (JSON.parse || JSON.decode)(t)
                }
                function r(t) {
                    this.con = t
                }
                function s() {
                    this.id = s.id++
                }
                var o = t(74),
                    a = t(58);
                o.aug(r.prototype, {
                    expose: function(t) {
                        this.con.bind("message", this._handleRequest(t))
                    },
                    call: function(t) {
                        var e,
                            n = this;
                        return this._requests || (this._requests = {}, this.con.bind("message", function(t) {
                                var e;
                                try {
                                    t = i(t)
                                } catch ( r ) {
                                    return
                                } t.callback && "number" == typeof t.id && (e = n._requests[t.id]) && (t.error ? e.trigger("error", t) : e.trigger("success", t),
                                delete n._requests[t.id]
                                )
                            })), e = new s, this._requests[e.id] = e, e.send(this.con, t, Array.prototype.slice.call(arguments, 1))
                    },
                    _handleRequest: function(t) {
                        var e = this;
                        return function(n) {
                            var r, s;
                            try {
                                n = i(n)
                            } catch ( o ) {
                                return
                            } n.callback || "number" == typeof n.id && "function" == typeof t[n.method] && (s = e._responseCallbacks(n.id), r = t[n.method].apply(t, n.params.concat(s)), "undefined" != typeof r && s[0](r))
                        }
                    },
                    _responseCallbacks: function(t) {
                        var e = this.con;
                        return [function(n) {
                                e.send(JSON.stringify({
                                    id: t,
                                    result: n,
                                    callback: !0
                                }))
                            }, function n(i) {
                                e.send(JSON.stringify({
                                    id: t,
                                    error: n,
                                    callback: i
                                }))
                        }]
                    }
                }), s.id = 0, o.aug(s.prototype, a.Emitter, {
                    send: function(t, e, n) {
                        return t.send(JSON.stringify({
                                id: this.id,
                                method: e,
                                params: n
                            })), this
                    },
                    success: function(t) {
                        return this.bind("success", t), this
                    },
                    error: function(t) {
                        return this.bind("error", t), this
                    }
                }), e.exports = function(t) {
                    return new r(t)
                }
            }, {
            58: 58,
            74: 74
        }],
        83: [function(t, e, n) {
                function i() {
                }
                function r(t) {
                    this.transportMethod = "PostMessage", this.options = t, this._createChild()
                }
                function s(t) {
                    this.transportMethod = "Flash", this.options = t, this.token = Math.random().toString(16).substring(2), this._setup()
                }
                function o(t) {
                    this.transportMethod = "Fallback", this.options = t, this._createChild()
                }
                var a,
                    c = t(9),
                    u = t(12),
                    d = t(80),
                    h = t(74),
                    l = t(57),
                    f = t(21),
                    p = "__ready__",
                    m = 0;
                i.prototype = new d.Connection, h.aug(i.prototype, {
                    _createChild: function() {
                        this.options.window ? this._createWindow() : this._createIframe()
                    },
                    _createIframe: function() {
                        function t() {
                            s.child = e.contentWindow, s._ready || s.init()
                        }
                        var e, n, i, r,
                            s = this,
                            o = {
                                allowTransparency: !0,
                                frameBorder: "0",
                                scrolling: "no",
                                tabIndex: "0",
                                name: this._name()
                            },
                            d = h.aug(h.aug({}, o), this.options.iframe);
                        u.postMessage ? (a || (a = c.createElement("iframe")), e = a.cloneNode(!1)) : e = c.createElement('<iframe name="' + d.name + '">'), e.id = d.name, h.forIn(d, function(t, n) {
                            "style" != t && e.setAttribute(t, n)
                        }), r = e.getAttribute("style"), r && "undefined" != typeof r.cssText ? r.cssText = d.style : e.style.cssText = d.style, e.addEventListener("load", t, !1), e.src = this._source(), (n = this.options.appendTo) ? n.appendChild(e) : (i = this.options.replace) ? (n = i.parentNode, n && n.replaceChild(e, i)) : c.body.insertBefore(e, c.body.firstChild)
                    },
                    _createWindow: function() {
                        var t = f.open(this._source()).popup;
                        t && t.focus(), this.child = t, this.init()
                    },
                    _source: function() {
                        return this.options.src
                    },
                    _name: function() {
                        var t = "_xd_" + m++;
                        return u.parent && u.parent != u && u.name && (t = u.name + t), t
                    }
                }), r.prototype = new i, h.aug(r.prototype, {
                    init: function() {
                        function t(t) {
                            t.source === e.child && (e._ready || t.data !== p ? e.receive(t.data) : e.ready())
                        }
                        var e = this;
                        u.addEventListener("message", t, !1)
                    },
                    _performSend: function(t) {
                        this.child.postMessage(t, this.options.src)
                    }
                }), s.prototype = new i, h.aug(s.prototype, {
                    _setup: function() {
                        var e = this,
                            n = t(81);
                        u["__xdcb" + e.token] = {
                            receive: function(t) {
                                e._ready || t !== p ? e.receive(t) : e.ready()
                            },
                            loaded: function() {}
                        };
                        var i = c.createElement("div");
                        i.innerHTML = n.object("https://platform.twitter.com/xd/ft.swf?&token=" + e.token + "&parent=true&callback=__xdcb" + e.token + "&xdomain=" + e._host(), e.token), c.body.insertBefore(i, c.body.firstChild), e.proxy = i.firstChild, e._createChild()
                    },
                    init: function() {},
                    _performSend: function(t) {
                        this.proxy.send(t)
                    },
                    _host: function() {
                        return this.options.src.replace(/https?:\/\//, "").split(/(:|\/)/)[0]
                    },
                    _source: function() {
                        return this.options.src + (this.options.src.match(/\?/) ? "&" : "?") + "xd_token=" + u.escape(this.token)
                    }
                }), o.prototype = new i, h.aug(o.prototype, {
                    init: function() {},
                    _performSend: function() {}
                }), e.exports = {
                    connect: function(t) {
                        return !l.canPostMessage() || l.anyIE() && t.window ? l.anyIE() && l.flashEnabled() ? new s(t) : new o(t) : new r(t)
                    }
                }
            }, {
            12: 12,
            21: 21,
            57: 57,
            74: 74,
            80: 80,
            81: 81,
            9: 9
        }]
    }, {}, [79]))
}();`