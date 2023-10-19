//Left MenuTree Script
var MenuTreeApp = function() {
	var e = "",
		t = !1,
		a = !1,
		i = !1,
		o = !1,
		n = []
		s = function() {
			var e = window,
				t = "inner";
			return "innerWidth" in window || (t = "client", e = document.documentElement || document.body), {
				width: e[t + "Width"],
				height: e[t + "Height"]
			}
		}
		c = function() {
			var e, t = $("#content"),
				a = $("#sidebar"),
				i = $("body");
			e = i.hasClass("sidebar-fixed") ? $(window).height() - $("#header").height() + 1 : a.height() + 20, e >= t.height() && t.attr("style", "min-height:" + e + "px !important")
		},
		d = function() {
			jQuery(".sidebar-menu .has-sub > a").click(function() {
				var e = jQuery(".has-sub.open", $(".sidebar-menu"));
				e.removeClass("open"), jQuery(".arrow", e).removeClass("open"), jQuery(".sub", e).slideUp(200);
				var t = $(this),
					o = jQuery(this).next();
				o.is(":visible") ? (jQuery(".arrow", jQuery(this)).removeClass("open"), jQuery(this).parent().removeClass("open"), o.slideUp(i, function() {
					0 == $("#sidebar").hasClass("sidebar-fixed"), c()
				})) : (jQuery(".arrow", jQuery(this)).addClass("open"), jQuery(this).parent().addClass("open"), o.slideDown(i, function() {
					0 == $("#sidebar").hasClass("sidebar-fixed"), c()
				}))
			}), jQuery(".sidebar-menu .has-sub .sub .has-sub-sub > a").click(function() {
				var e = jQuery(".has-sub-sub.open", $(".sidebar-menu"));
				e.removeClass("open"), jQuery(".arrow", e).removeClass("open"), jQuery(".sub", e).slideUp(200);
				var t = jQuery(this).next();
				t.is(":visible") ? (jQuery(".arrow", jQuery(this)).removeClass("open"), jQuery(this).parent().removeClass("open"), t.slideUp(200)) : (jQuery(".arrow", jQuery(this)).addClass("open"), jQuery(this).parent().addClass("open"), t.slideDown(200))
			})
		},
		m = function() {
			//var e = document.getElementById("sidebar-collapse").querySelector('[class*="fa-"]'),
			//var e = jQuery("#sidebar-collapse").find('[class*="fa-"]:eq(0)').eq(0).get(0),
			var e = jQuery("#sidebar-collapse > i.fa:eq(0)").get(0),
				a = e.getAttribute("data-icon1"),
				i = e.getAttribute("data-icon2");
			jQuery(".navbar-brand").addClass("mini-menu"), jQuery("#sidebar").addClass("mini-menu"), jQuery("#main-content").addClass("margin-left-50"), jQuery(".sidebar-collapse i").removeClass(a), jQuery(".sidebar-collapse i").addClass(i), jQuery(".search").attr("placeholder", ""), t = !0, $.cookie("mini_sidebar", "1")
		},        
		h = function() {
			s();
			"1" === $.cookie("mini_sidebar") && (jQuery(".navbar-brand").addClass("mini-menu"), jQuery("#sidebar").addClass("mini-menu"), jQuery("#main-content").addClass("margin-left-50"), t = !0), jQuery(".sidebar-collapse").click(function() {
				if (a && !i) t ? (jQuery("body").removeClass("slidebar"), jQuery(".sidebar").removeClass("sidebar-fixed"), o && (jQuery("#header").addClass("navbar-fixed-top"), jQuery("#main-content").addClass("margin-top-100")), t = !1, $.cookie("mini_sidebar", "0")) : (jQuery("body").addClass("slidebar"), jQuery(".sidebar").addClass("sidebar-fixed"), o && (jQuery("#header").removeClass("navbar-fixed-top"), jQuery("#main-content").removeClass("margin-top-100")), t = !0, $.cookie("mini_sidebar", "1"), p());
				else {
					//var e = document.getElementById("sidebar-collapse").querySelector('[class*="fa-"]'),
					//var e = jQuery("#sidebar-collapse").find('[class*="fa-"]:eq(0)').get(0),
					var e = jQuery("#sidebar-collapse > i.fa:eq(0)").get(0),
						n = e.getAttribute("data-icon1"),
						r = e.getAttribute("data-icon2");
					t ? (jQuery(".navbar-brand").removeClass("mini-menu"), jQuery("#sidebar").removeClass("mini-menu"), jQuery("#main-content").removeClass("margin-left-50"), jQuery(".sidebar-collapse i").removeClass(r), jQuery(".sidebar-collapse i").addClass(n), jQuery(".search").attr("placeholder", "Search"), t = !1, $.cookie("mini_sidebar", "0", {path:"/"})) : (jQuery(".navbar-brand").addClass("mini-menu"), jQuery("#sidebar").addClass("mini-menu"), jQuery("#main-content").addClass("margin-left-50"), jQuery(".sidebar-collapse i").removeClass(n), jQuery(".sidebar-collapse i").addClass(r), jQuery(".search").attr("placeholder", ""), t = !0, $.cookie("mini_sidebar", "1", {path:"/"})), $("#main-content").on("resize", function(e) {
						e.stopPropagation()
					})
				}
			})
		},
		p = function() {
			var e = $(".sidebar");
			1 === e.parent(".slimScrollDiv").size() && (e.slimScroll({
				destroy: !0
			}), e.removeAttr("style"), $("#sidebar").removeAttr("style")), e.slimScroll({
				size: "7px",
				color: "#a1b2bd",
				opacity: .3,
				height: "100%",
				allowPageScroll: !1,
				disableFadeOut: !1
			})
		};
	return {
		init: function() {
			//MenuTreeApp.isPage("mini_sidebar") && m(), d(), h()
			d(), h()
		},
		setPage: function(t) {
			e = t
		},
		isPage: function(t) {
			return e == t ? !0 : !1
		},
		addResponsiveFunction: function(e) {
			n.push(e)
		},
		scrollTo: function(e, t) {
			pos = e && e.size() > 0 ? e.offset().top : 0, jQuery("html,body").animate({
				scrollTop: pos + (t ? t : 0)
			}, "slow")
		},
		scrollTop: function() {
			MenuTreeApp.scrollTo()
		},
		initUniform: function(e) {
			e ? jQuery(e).each(function() {
				0 == $(this).parents(".checker").size() && ($(this).show(), $(this).uniform())
			}) : J()
		}
	}
}();