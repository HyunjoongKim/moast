var _isLowBr_ = false,_isMobile_ = false;
var _thisPage_cfg  = {};

//레이아웃 셋팅(로딩완료된 후에만 1번만 처리)
function initPageLayout(){
	//resetTabSize(); 탭메뉴 사용시 주석제거
	setContAutoWidth();
	_setLayoutFooter();
	//setMinWidthAutoScrollBox();  //주석함

}

//레이아웃 리셋
function resetPageLayout(){
	mainNavi._reset();
	//initSubNavigation();
	//resetTabSize();   탭메뉴 사용시 주석제거
	setMinWidthAutoScrollBox();
	setContAutoWidth();
	_resetFooterHeight();


	//팝업이미지 리사이징에 따른 높이 처리
	if($(".top-wide-popups").attr("isOpen")=="1"){
		resetTopWidePopups();
	}


	//isOverTab();  탭메뉴 사용시 주석제거

	// 서브좌측메뉴 리사이징에 따른 속성처리
	var win_w = $(window).innerWidth();
	if(win_w>700){
		$(".submenu .depth2").attr("style",'display:block');
	} else {
		$(".submenu .depth2").attr("style",'display:none');
	}
}

//레이아웃 높이 리셋
function resizePageLayoutHeight(){
}
////////////////////////////////////////////////////
//윈도우 회전시 실행할 함수
function setWindowRotation(){
	if(typeof(thisPageRotation)=="function" && thisPageRotation!=undefined){  thisPageRotation(); }
	else {
		//기본 회전시 실행할 함수
		//resetPageLayout();
	}
}
//document.addEventListener('DOMContentLoaded', loaded, false);
if('onorientationchange' in window){
	window.addEventListener('onorientationchange', setWindowRotation, false);
}
////////////////////////////////////////////////////
$(document).ready(function(){
	console.log("1.Ready");
	naviHeight();
	//initPageCssFiles();
	//initPageJavascript();
	try{getWindowSize();	}catch(e){}
	try{getPageSize();	}catch(e){}
	if(_isMobile_) $alertLoading("Page Loading...");
	try{setLowBrowser();	}catch(e){	}
	try{setMediaObjectFunc();	}catch(e){	}
	try{ _thisLayout_style = getPageStyle(); }catch(e){}
	try{ resetTabSize(); }catch(e){}
	//initNavigation();  //주석함
	docLoading(function(){
		console.log("3.docLoad");
		initImgSizeInfo();
		initPageLayout();
		resetImgZoom();
	});
});
$(window).load(function(){
	console.log("2.Load");
	//naviHeight();
});
$(window).resize(function(e){
	//var resizeTimeGap = (_isLowBr_)?  250 : 10;
	var resizeTimeGap = 10;
	if(_isLowBr_) resizeTimeGap=100;
	clearTimeout(window.resizeEvt);
	window.resizeEvt = setTimeout(function()
	{
		//console.log("Resize" );
		getWindowSize();getPageSize();
		try{
		if(old_wsize.win== undefined ||  wsize.win.w!=old_wsize.win.w){
			resetPageLayout();
		}else{
			resizePageLayoutHeight();
		}
		}catch(e){
			resetPageLayout();
		}
	}, resizeTimeGap);
});

$(window).scroll(function(){
	clearTimeout(window.scrollEvt);
	window.scrollEvt = setTimeout(function()
	{
		////srolling
	}, 250);

});
try{
$(window).scrollStopped(function(){
	//end sroll
});
}catch(e){}

// 서브 컨텐츠 및 레이아웃에 관한 JS //
$(".quick-top").click(function(event){
    event.preventDefault();
    $('html,body').animate({scrollTop:$(this.hash).offset().top}, 500);
});

// 서브 페이지가이드 fixed 발동/해제 스크립트
function setScrollEndLayout(){
	var scrTop = $(window).scrollTop();
	var chkH = $("#header-wrap").height();
	var cnaviTop = $("#container").offset().top - $("#cont-navi-wrap").outerHeight();
	if ( scrTop>=cnaviTop ) {
		if($("#cont-navi-wrap").parent().hasClass("cnavi-fix")!=true){
			$("#cont-navi-wrap").wrap("<div class='cnavi-fix'/>");
		}
	} else {
		if($("#cont-navi-wrap").parent().hasClass("cnavi-fix")){
			$("#cont-navi-wrap").unwrap("");
		}
	}
	if (_thisPage.scrollAction!=undefined && _thisPage.scrollAction.length>0) {
		$(_thisPage.scrollAction).each(function(i,func){
			try{ func(); }
			catch(e){ alert(e); }
		});
	}
}
$(window).scroll(function(){
	var scrTimeGap = 10;
	if(_isLowBr_) scrTimeGap=200;


	clearTimeout(window.scrollEvt);
	window.scrollEvt = setTimeout(function() {
		try{ setScrollEndLayout();}catch(e){}		////srolling
	}, scrTimeGap);

	clearTimeout(window.scrollAfterEvt);
	window.scrollAfterEvt = setTimeout(function() {
		try{ setScrollAfertLayout();}catch(e){}		////srolling End After
	}, 5000);
});



$(window).resize(function() {

	defaultTabSetting();


	if(this.resizeTO) {
		clearTimeout(this.resizeTO);
	}
	this.resizeTO = setTimeout(function() {
		$(this).trigger('resizeEnd');
	}, 150 );
});
$(window).on('resizeEnd', function() {
	$w_w = $(window).innerWidth();
	resetImgZoom();

});




//풀탭스크립트 jquery.cs_tab.js 필요
$(document).ready(function(){
	try{
		defaultTabSetting();
	}catch(e){}
});

function defaultTabSetting(){
	//$("#multi-tab01").multiTab_fwidth({line_limit:4,height:50});
	$("#board-tab").multiTab_auto({line_limit:6, height:56, showCtrlBtns:true, ctrlBtnWidth:46});
	//$("#multi-tab02").multiTab_auto({line_limit:6, height:56, showCtrlBtns:true, ctrlBtnWidth:46});
}


//페이지 타이틀 좌우 화살표 버튼 셋팅
function subPageMover() {
	$keywd = $(".cont-tit h2.tit").text();
	$stdNode = $(".depth2-wrap li.mn_l2 a.mn_a2 span.txt").filter(":contains('" + $keywd + "')").closest("li.mn_l2");
	$stdNode_idx = $stdNode.index();
	$stdNode_num = $stdNode.parent().children("li").length - 1;	// 개수와 인덱스 수치 동일여부 비교 편의을 위해 -1
	$stdNode_1depIdx = $stdNode.closest(".mn_l1").index();
	$stdNode_1depLen = $stdNode.closest(".topmenu").children(".mn_l1").length - 1;

	if ( $stdNode_idx == 0 ) {	// 2depth 첫번째 메뉴
		$linkPrev = $stdNode.closest("li.mn_l1").prev().find(".depth2-wrap .depth2 > li.mn_l2:last-child a.mn_a2").attr("href");
		$txtPrev = $stdNode.closest("li.mn_l1").prev().find(".depth2-wrap .depth2 > li.mn_l2:last-child a.mn_a2 .txt").text();

		$linkNext = $stdNode.next().children("a").attr("href");
		$txtNext = $stdNode.next().find("a.mn_a2 .txt").text();
	} else if ( $stdNode_idx == $stdNode_num ) {	// 2depth 마지막 메뉴
		$linkPrev = $stdNode.prev().children("a").attr("href");
		$txtPrev = $stdNode.prev().find("a.mn_a2 .txt").text();

		$linkNext = $stdNode.closest("li.mn_l1").next().find(".depth2-wrap .depth2 > li.mn_l2:first-child a.mn_a2").attr("href");
		$txtNext = $stdNode.closest("li.mn_l1").next().find(".depth2-wrap .depth2 > li.mn_l2:first-child a.mn_a2 .txt").text();
	} else {
		$linkPrev = $stdNode.prev().children("a").attr("href");
		$txtPrev = $stdNode.prev().find("a.mn_a2 .txt").text();

		$linkNext = $stdNode.next().children("a").attr("href");
		$txtNext = $stdNode.next().find("a.mn_a2 .txt").text();
	}

	if ( $stdNode_1depIdx == 0 && $stdNode_idx == 0 ) {	// 1depth 첫번재 메뉴의 첫번째 2depth 메뉴
		$(".page-prev").hide();
		$(".page-next").attr({ "href" : $linkNext });
		$(".page-next span").text( $txtNext );
	} else if ( $stdNode_1depIdx == $stdNode_1depLen && $stdNode_idx == $stdNode_num) {	// 1depth 마지막 메뉴의 마지막 2depth 메뉴
		$(".page-prev").attr({ "href" : $linkPrev });
		$(".page-prev span").text( $txtPrev );
		$(".page-next").hide();
	} else {
		$(".page-prev").attr({ "href" : $linkPrev });
		$(".page-prev span").text( $txtPrev );
		$(".page-next").attr({ "href" : $linkNext });
		$(".page-next span").text( $txtNext );
	}
}