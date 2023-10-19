//메뉴 현재위치 자동 설정
function SetMenuAutoPosition(strPosiCssName) {
	$("li.smenunav").each(function(idx) {
		var objTempMenu = $(this);
		var objTempMenuParent = $(this).parent();
		
		$(objTempMenu).find("span").removeClass("on");
		//console.log(objTempMenu.find("a").attr("href"));
		
		if ($(objTempMenu).hasClass(strPosiCssName)) {
		//if (objTempMenu.find("a").attr("href")==strPosiCssName){
			$(objTempMenu).find("span").addClass("on");
			 
			//하위 2차메뉴 모두 닫기
			if ($(objTempMenuParent).hasClass("sub")) {
				$(objTempMenuParent).find("li.has-sub-sub>a>span.arrow").removeClass("open");
				$(objTempMenuParent).find("li.has-sub-sub>ul.sub-sub").hide();
			} else {
				$(objTempMenuParent).parent().parent().find("li.has-sub-sub>a>span.arrow").removeClass("open");
				$(objTempMenuParent).parent().parent().find("li.has-sub-sub>ul.sub-sub").hide();
			}
			
			//해당 메뉴 표시
			if ($(objTempMenuParent).hasClass("sub")) {
				$(objTempMenu).parent().parent().addClass("active");
			} else {
				$(objTempMenu).parent().parent().addClass("current");
				$(objTempMenu).parent().parent().parent().parent().addClass("active");
				
				$(objTempMenu).parent().parent().find("a>span.arrow").addClass("open");
				$(objTempMenu).parent().parent().find("ul.sub-sub").show();
			}
		}
	});
}

//컨텐츠 영역 높이 자동 설정
function SetContainerAutoHeight() {
	var intHtmlHeight = $("html").outerHeight();
	var intHeaderHeight = $("#header").outerHeight();
	var intFooterHeight = $("#footer").outerHeight();
	var intWinsCntHeight = intHtmlHeight - intHeaderHeight - intFooterHeight;
	var intRealCntHeight = $("#content").outerHeight();
	
	if (intRealCntHeight > intWinsCntHeight) {
		$("#main-content div.container").height(intRealCntHeight);
	} else {
		$("#main-content div.container").height(intWinsCntHeight);
	}
}