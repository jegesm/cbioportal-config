webpackJsonp([13], {
    1683: function(e, t) {},
    763: function(e, t, r) {
        "use strict";

        function n(e, t) {
            if (!(e instanceof t)) throw new TypeError("Cannot call a class as a function")
        }

        function o(e, t) {
            if (!e) throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
            return !t || "object" !== (void 0 === t ? "undefined" : a(t)) && "function" != typeof t ? e : t
        }

        function l(e, t) {
            if ("function" != typeof t && null !== t) throw new TypeError("Super expression must either be null or a function, not " + (void 0 === t ? "undefined" : a(t)));
            e.prototype = Object.create(t && t.prototype, {
                constructor: {
                    value: e,
                    enumerable: !1,
                    writable: !0,
                    configurable: !0
                }
            }), t && (Object.setPrototypeOf ? Object.setPrototypeOf(e, t) : e.__proto__ = t)
        }
        var a = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function(e) {
            return typeof e
        } : function(e) {
            return e && "function" == typeof Symbol && e.constructor === Symbol && e !== Symbol.prototype ? "symbol" : typeof e
        };
        Object.defineProperty(t, "__esModule", {
            value: !0
        });
        var i = function() {
                function e(e, t) {
                    for (var r = 0; r < t.length; r++) {
                        var n = t[r];
                        n.enumerable = n.enumerable || !1, n.configurable = !0, "value" in n && (n.writable = !0), Object.defineProperty(e, n.key, n)
                    }
                }
                return function(t, r, n) {
                    return r && e(t.prototype, r), n && e(t, n), t
                }
            }(),
            c = "function" == typeof Symbol && "symbol" === a(Symbol.iterator) ? function(e) {
                return void 0 === e ? "undefined" : a(e)
            } : function(e) {
                return e && "function" == typeof Symbol && e.constructor === Symbol && e !== Symbol.prototype ? "symbol" : void 0 === e ? "undefined" : a(e)
            },
            u = r(1),
            f = function(e) {
                if (e && e.__esModule) return e;
                var t = {};
                if (null != e)
                    for (var r in e) Object.prototype.hasOwnProperty.call(e, r) && (t[r] = e[r]);
                return t.default = e, t
            }(u),
            s = r(25),
            m = r(260);
        r(1683);
        var p = r(263),
            d = function(e) {
                return e && e.__esModule ? e : {
                    default: e
                }
            }(p),
            y = function(e, t, r, n) {
                var o, l = arguments.length,
                    a = l < 3 ? t : null === n ? n = Object.getOwnPropertyDescriptor(t, r) : n;
                if ("object" === ("undefined" == typeof Reflect ? "undefined" : c(Reflect)) && "function" == typeof Reflect.decorate) a = Reflect.decorate(e, t, r, n);
                else
                    for (var i = e.length - 1; i >= 0; i--)(o = e[i]) && (a = (l < 3 ? o(a) : l > 3 ? o(t, r, a) : o(t, r)) || a);
                return l > 3 && a && Object.defineProperty(t, r, a), a
            },
            b = function(e) {
                function t() {
                    return n(this, t), o(this, (t.__proto__ || Object.getPrototypeOf(t)).apply(this, arguments))
                }
                return l(t, e), i(t, [{
                    key: "render",
                    value: function() {
                        return f.createElement(m.PageLayout, {
                                className: "whiteBackground staticPage"
                            }, f.createElement(d.default, null, f.createElement("title", null, "cBioPortal for Cancer Genomics::Tutorials")), f.createElement("h1", null, "Tutorials"),
							f.createElement("h2", null, "Bemutató videó 1"),	
							f.createElement("video", {
								width: "720",
								controls: "controls"
							},f.createElement("source",{
								type: "video/mp4",
								src: "http://kooplex-temp.elte.hu/cbioportal/content/video1.mp4"
							})),
							f.createElement("h2", null, "Bemutató videó 2"),	
							f.createElement("video", {
								width: "720",
								controls: "controls"
							},f.createElement("source",{
								type: "video/mp4",
								src: "http://kooplex-temp.elte.hu/cbioportal/content/video2.mp4"
							})),
							f.createElement("h2", null, "Bemutató videó 3"),	
							f.createElement("video", {
								width: "720",
								controls: "controls"
							},f.createElement("source",{
								type: "video/mp4",
								src: "http://kooplex-temp.elte.hu/cbioportal/content/video3.mp4"
							})),
                            f.createElement("h2", null, "Step-by-step Guide to cBioPortal: a Protocol Paper"), f.createElement("p", null, "Gao, Aksoy, Dogrusoz, Dresdner, Gross, Sumer, Sun, Jacobsen, Sinha, Larsson, Cerami, Sander, Schultz. ", f.createElement("br", null), f.createElement("b", null, "Integrative analysis of complex cancer genomics and clinical profiles using the cBioPortal."), " ", f.createElement("br", null), f.createElement("i", null, "Sci. Signal."), " 6, pl1 (2013). [", f.createElement("a", {
                                href: "http://www.ncbi.nlm.nih.gov/pubmed/23550210"
                            }, "Reprint"), "]."), f.createElement("hr", null), f.createElement("h2", null, "Tutorial #1: Single Study Exploration"), f.createElement("iframe", {
                                src: "https://docs.google.com/presentation/d/1_OGK69lO4Z62WaxHHkNYmWvY0LQN2v0slfaLyY1_IQ0/embed?start=false&loop=false&delayms=60000",
                                frameBorder: "0",
                                width: "720",
                                height: "434",
                                allowFullScreen: !0
                            }), f.createElement("hr", null), f.createElement("h2", null, "Tutorial #2: Single Study Query"), f.createElement("iframe", {
                                src: "https://docs.google.com/presentation/d/1y9UTIr5vHmsNVWqtGTVGgiuYX9wkK_a_RPNYiR8kYD8/embed?start=false&loop=false&delayms=60000",
                                frameBorder: "0",
                                width: "720",
                                height: "434",
                                allowFullScreen: !0
                            }), f.createElement("hr", null), f.createElement("h2", null, "Tutorial #3: Patient View"), f.createElement("iframe", {
                                src: "https://docs.google.com/presentation/d/1Jr_2yEfgjKBn4DBiXRk4kmhIbtsRp6gd0iD3k1fIUUk/embed?start=false&loop=false&delayms=60000",
                                frameBorder: "0",
                                width: "720",
                                height: "434",
                                allowFullScreen: !0
                            }), f.createElement("hr", null), f.createElement("h2", null, "Tutorial #4: Virtual Studies"), f.createElement("iframe", {
                                src: "https://docs.google.com/presentation/d/1rQE5rbFNdmup-rAtySHFxlLp3i4qa8SBA7MiQpMdn1I/embed?start=false&loop=false&delayms=60000",
                                frameBorder: "0",
                                width: "720",
                                height: "434",
                                allowFullScreen: !0
                            }))
                    }
                }]), t
            }(f.Component);
        b = y([s.observer], b), t.default = b
    }
});


//# sourceMappingURL=13.3b60d87a0513ff978405.chunk.js.map