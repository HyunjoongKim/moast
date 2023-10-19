var _thisLayout_style = {};var _orgLayout_style = {};
function checkPageStyle(){
	_orgLayout_style =  $.extend({},_thisLayout_style);  _thisLayout_style = getPageStyle();
}
function getPageStyle(){
	var pg_type = {};
	var chkW = $("#header").width();
	if(_isLowBr_ && chkW >999) chkW = wsize.win.w;
	return pg_type;
}
/////////////////////////////////////////////////////////////////////////////
function _setLayoutFooter(){
	
}
function _resetFooterHeight(){
	if($("#fsitemap").hasClass("is-open")){
		var toH = $("#fsitemap .fsitemenu").outerHeight();
		$("#fsitemap").css({"height":toH + 40});

	}
}
function _getLayoutHeaderHeight(){
return	$("#header-wrap").outerHeight();
}

//-------------------------------------------------------------------------------
function resetTabSize(){
	var tabLimit = 6;
	try{
		if(_thisPage_cfg.tab_line_limit!=undefined && _thisPage_cfg.tab_line_limit) tabLimit = _thisPage_cfg.tab_line_limit;
	}catch(e){}
	setContTabmenu();
}
function setContTabmenu(){	
	$(".c-tab01").rspnsvTab_fauto({height:50,line_limit:6,wsize_data:[{"wsize":740,"list_mod":4},{"wsize":600,"list_mod":3},{"wsize":480,"list_mod":2},{"wsize":360,"list_mod":1}]});
	$(".c-tab02").not(".noAutoTab").rspnsvTab_auto({height:40,showCtrlBtns:true,ctrlBtnWidth:40,line_limit: 5});
}

function setContAutoWidth(){
	if($(".is-wauto-box").length>0 ) {
		if( typeof(setMinWidthAutoScrollBox) !="function" )  $.getScript("/_Js/jquery/jquery.cs_wauto.js",function(){ setMinWidthAutoScrollBox(); });
		else{ setMinWidthAutoScrollBox(); }	
	}
}

//-------------------------------------------------



/******************/
function resetImgZoom(){
	var zwObj =  $('.img-zoom');
	zwObj.each(function(){
		var this_s = $(this);
		var zwObjImg = this_s.children("img");
		var zwObjUrl = zwObjImg.attr("src");
		var win_w = $(window).innerWidth();

		if(win_w<=768){
			this_s.append("<a href='" + zwObjUrl + "' class='btn-zoom' target='_blank' title='새창열림'><span class='blind'>이미지 확대보기</span></a>");
			zwObjImg.addClass("zoom");
		} else {
			$(".btn-zoom, .btn-down", $(this).parent()).remove();
			zwObjImg.removeClass("zoom");
		}
	});

}



$(function(){
	/* top 버튼 */
    // Fakes the loading setting a timeout
    setTimeout(function () {
        $('body').addClass('loaded');
    }, 400);
	
    $(window).scroll(function () {
        if ($(this).scrollTop() > $(window).height() * 0.2) {
            $('.topBt').addClass('over');
        } else {
            $('.topBt').removeClass('over');
        }
    });

    //Click event to scroll to top
    $('.topBt').click(function () {
        $('html, body').animate({ scrollTop: 0 }, 300);
        return false;
    });
    
    /* 중앙 메뉴이동 */
    var mntxt = $('#svisual-wrap #visImgWrap .vis-tit').text();
    var firstxt = $('#mainNavi .mn_li1:first-child').find('.mn_a1').text();
    var lastxt = $('#mainNavi .mn_li1:last-child').find('.mn_a1').text();
    var pretxt = $('#mainNavi .mn_a1.over').parents('.mn_li1').prev('.mn_li1').find('.mn_a1').text();
    var nxtxt = $('#mainNavi .mn_a1.over').parents('.mn_li1').next('.mn_li1').find('.mn_a1').text();
    
    var prelnk = $('#mainNavi .mn_a1.over').parents('.mn_li1').prev('.mn_li1').find('.mn_a1').attr("href");
    var nxtlnk = $('#mainNavi .mn_a1.over').parents('.mn_li1').next('.mn_li1').find('.mn_a1').attr("href");
    var firstlnk = $('#mainNavi .mn_li1:first-child').find('.mn_a1').attr("href");
    var lastlnk = $('#mainNavi .mn_li1:last-child').find('.mn_a1').attr("href");
    
    var firstover = $('#mainNavi .mn_li1:first-child .mn_a1').hasClass( "over" );
    var lastover = $('#mainNavi .mn_li1:last-child .mn_a1').hasClass( "over" );
    
    $('.prev-lnk').attr("href",prelnk);
    $('.next-lnk').attr("href",nxtlnk);
    
    $('.prev-lnk').hover(
		function() {
			if (pretxt.length > 1){
				$('.tit-name').text( pretxt );
			} else if ( firstover = true) {
				$('.tit-name').text( lastxt );
				$('.prev-lnk').attr("href",lastlnk);
			} else {
				$('.tit-name').text( firstxt );
				$('.prev-lnk').attr("href",firstlnk);
			}
		}, function() {
			$('.tit-name').text( mntxt );
		}
    );
    $('.next-lnk').hover(
		function() {
			if (nxtxt.length > 1){
				$('.tit-name').text( nxtxt );
			} else if ( lastover = true) {
				$('.tit-name').text( firstxt );
				$('.prev-lnk').attr("href",firstlnk);
			} else {
				$('.tit-name').text( lastxt );
				$('.next-lnk').attr("href",lastlnk);
			}
		}, function() {
			$('.tit-name').text( mntxt );
		}
    );

});

/* cnavi 높이 조절 */
function naviHeight() {
    var cnavi_height = $('#cont-navi-wrap #cont-navi .navi-menu .mn_l1 ul').height();
	var cnavi_body = $('#doc-wrap').width();
    
    if (cnavi_body > 680){
	    if (cnavi_height > 1){
	    	$('#contents .cont-top').css("padding-top",110);
	    } else if (cnavi_height > 65){
	    	$('#contents .cont-top').css("padding-top",160);
	    }
    }
}

/* 상담 검색 */
function toggleSearch(){
	toggleBtn = $("#menu-wrap .srch-btn");
	searchWrap = $(".mntop-srch");
	if(toggleBtn.hasClass("is-open")){
		closeSearch();
	} else {
		openSearch();
	}
	function openSearch(){
		searchWrap.stop().slideDown(200).attr("tabindex",0).focus();
		toggleBtn.addClass("is-open");
		$(".btn-close",searchWrap).click(function(){
			closeSearch();
		});
	}
	function closeSearch(){
		searchWrap.stop().slideUp(200).attr("");
		toggleBtn.focus().removeClass("is-open");
	}
}