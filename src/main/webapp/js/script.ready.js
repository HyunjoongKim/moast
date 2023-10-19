$(document).ready(function() {
	//MenuTree Init()
	MenuTreeApp.init();

	//컨텐츠 영역 높이 자동 설정
	SetContainerAutoHeight();
});

$(window).resize(function() {
	//컨텐츠 영역 높이 자동 설정
	SetContainerAutoHeight();
});