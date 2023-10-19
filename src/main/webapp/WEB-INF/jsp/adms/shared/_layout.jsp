<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="_navi.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>연세대학교 Multiomics</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.cookie.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.i18n.properties.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ui.datepicker-ko.js" ></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/script.menutree.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/script.common.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/script.ready.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>

<!--[if gt IE 8]><!-->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.i18n.properties.js"></script>
<!--<![endif]-->
<!-- Style -->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/bsite/board.css" /> 
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/bootstrap-dist/css/bootstrap.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/bootstrap-dist/css/bootstrap-select.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/bootstrap-dist/css/bootstrap-datepicker.min.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/bootstrap-dist/css/style_201707.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/bootstrap-dist/css/icons.css"/>

<script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/bootstrap.min.js"></script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.10.4/css/jquery-ui.min.css">  
<script src="https://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>

<!-- 설문조사 달력 추가 (s) [2020-08-08] -->
<script src="${pageContext.request.contextPath}/bootstrap-dist/datepicker/daterangepicker-master/moment.min.js"></script>
<script src="${pageContext.request.contextPath}/bootstrap-dist/datepicker/datetimepicker/js/bootstrap-datetimepicker.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/bootstrap-dist/datepicker/datetimepicker/css/bootstrap-datetimepicker.css"/>
<script src="${pageContext.request.contextPath}/bootstrap-dist/datepicker/daterangepicker-master/daterangepicker.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/bootstrap-dist/datepicker/daterangepicker-master/daterangepicker.css" />
<!-- 설문조사 달력 추가 (e) [2020-08-08] -->
 
<script type="text/javascript">
//<![CDATA[
	$(document).ready(function() { 
		//메뉴 셀렉트
		//SetMenuAutoPosition("${pageContext.request.contextPath}${requestScope['javax.servlet.forward.servlet_path']}");
		try{
			SetMenuAutoPosition("${LEFT_MENU_GROUP}");
		}catch(e){console.log("LEFT 메뉴그룹 선택 안됨");}
		
		try{
			var vHost = location.protocol+"//"+location.host; 
			var vUrl = vHost+"${pageContext.request.contextPath}";
			var locale = "${pageContext.response.locale}"; 
			if("ko_KR"==locale){
				locale="ko";
			}
			jQuery.i18n.properties({
			    name:'messages', 
			    path:vUrl+'/i18n/',
			    mode:'both',
			    language:locale, 
			    callback: function() {
			    	   
			    }
			});
		}catch(e){console.log("다국어 조회 안됨"+e);}
		
		//설문조사 달력 추가 (s) [2020-08-08]
		dataRangeOption_ko = {
				"showDropdowns": true, 
				"autoApply": false, 
				"locale": { 
					"format": "YYYY-MM-DD", 
					"separator": " - ", 
					"applyLabel": "확인", 
					"cancelLabel": "취소", 
					"fromLabel": "From", 
					"toLabel": "To", 
					"customRangeLabel": "Custom", 
					"weekLabel": "W", 
					"daysOfWeek": ["일","월","화","수","목","금","토"], 
					"monthNames": ["1","2","3","4","5","6","7","8","9","10","11","12"] 
				}, 
				"linkedCalendars": false, 
				"alwaysShowCalendars": true, 
				"opens": "center", 
				"startDate":setDate("startDate"), 
				"endDate":setDate("endDate"),
				 autoUpdateInput : false
		}
		
		dataRangeOption_en = {
			"showDropdowns": true, 
			"autoApply": false, 
			"locale": { 
				"format": "YYYY-MM-DD", 
				"separator": " - ",  
				"fromLabel": "From", 
				"toLabel": "To", 
				"customRangeLabel": "Custom", 
				"weekLabel": "W", 
				"monthNames": ["1","2","3","4","5","6","7","8","9","10","11","12"] 
			}, 
			"linkedCalendars": false, 
			"alwaysShowCalendars": true, 
			"opens": "center", 
			"startDate":setDate("startDate"), 
			"endDate":setDate("endDate"),
			 autoUpdateInput : false
		}
		
		dataRangeOptionTime_ko = {
				"showDropdowns": true, 
				"autoApply": false, 
				"locale": { 
					"format": "YYYY-MM-DD H:mm", 
					"separator": " - ", 
					"applyLabel": "확인", 
					"cancelLabel": "취소", 
					"fromLabel": "From", 
					"toLabel": "To", 
					"customRangeLabel": "Custom", 
					"weekLabel": "W", 
					"daysOfWeek": ["일","월","화","수","목","금","토"], 
					"monthNames": ["1","2","3","4","5","6","7","8","9","10","11","12"] 
				}, 
				"linkedCalendars": false, 
				timePicker: true,
				timePicker24Hour:true,
				timePickerIncrement : 30,
				"alwaysShowCalendars": true, 
				"opens": "center", 
				"startDate":setDate("startDate"), 
				"endDate":setDate("endDate"),
				 autoUpdateInput : false
		}		
		
		dataRangeOptionTime_en = {
				"showDropdowns": true, 
				"autoApply": false, 
				"locale": { 
					"format": "YYYY-MM-DD H:mm", 
					"separator": " - ",  
					"fromLabel": "From", 
					"toLabel": "To", 
					"customRangeLabel": "Custom", 
					"weekLabel": "W",  
					"monthNames": ["1","2","3","4","5","6","7","8","9","10","11","12"] 
				}, 
				"linkedCalendars": false, 
				timePicker: true,
				timePicker24Hour:true,
				timePickerIncrement : 30,
				"alwaysShowCalendars": true, 
				"opens": "center", 
				"startDate":setDate("startDate"), 
				"endDate":setDate("endDate"),
				 autoUpdateInput : false
		}		
		
		dataRangeOptionTime5m_ko = {
				"showDropdowns": true, 
				"autoApply": false, 
				"locale": { 
					"format": "YYYY-MM-DD H:mm", 
					"separator": " - ", 
					"applyLabel": "확인", 
					"cancelLabel": "취소", 
					"fromLabel": "From", 
					"toLabel": "To", 
					"customRangeLabel": "Custom", 
					"weekLabel": "W", 
					"daysOfWeek": ["일","월","화","수","목","금","토"], 
					"monthNames": ["1","2","3","4","5","6","7","8","9","10","11","12"] 
				}, 
				"linkedCalendars": false, 
				timePicker: true,
				timePicker24Hour:true,
				timePickerIncrement : 5,
				"alwaysShowCalendars": true, 
				"opens": "center", 
				"startDate":setDate("startDate"), 
				"endDate":setDate("endDate"),
				 autoUpdateInput : false
		}		
		
		dataRangeOptionTime5m_en = {
				"showDropdowns": true, 
				"autoApply": false, 
				"locale": { 
					"format": "YYYY-MM-DD H:mm", 
					"separator": " - ",  
					"fromLabel": "From", 
					"toLabel": "To", 
					"customRangeLabel": "Custom", 
					"weekLabel": "W",  
					"monthNames": ["1","2","3","4","5","6","7","8","9","10","11","12"] 
				}, 
				"linkedCalendars": false, 
				timePicker: true,
				timePicker24Hour:true,
				timePickerIncrement : 5,
				"alwaysShowCalendars": true, 
				"opens": "center", 
				"startDate":setDate("startDate"), 
				"endDate":setDate("endDate"),
				 autoUpdateInput : false
		}
		//설문조사 달력 추가 (e) [2020-08-08]
		
		mthoptions = {
			    pattern: 'yyyy-mm', 
			    monthNames: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12']
			};
	});
	
	function accCalc(){
		calcTime(accTime,'accTime');
		accTime--;
		if(accTime<=-1){
			location.href="${pageContext.request.contextPath}/account/logout.do";
			clearInterval(itvAcc);
		}
	}
	function refTime(){
		accTime = 3600;
	}
	
	function setDate(date){ 
		var dateVal = $("#"+date).val(); 

 		if(!moment(dateVal,"YYYY-MM-DD").isValid()){
			if(date=="startDate"){
				dateVal = moment().format('YYYY-01-01') 
			}else if(date=="endDate"){
				dateVal = moment().format('YYYY-12-31')
			}
			
			$("#"+date).val(dateVal); 
		}  

		return dateVal 
	}
	
	
//]]>
</script>
</head>
<body class="fixed-left">
	<div id="wrapper">
		<%-- <div >
			<c:import url="/topLogin.do"></c:import>
		</div>
		 --%>
		
		<!-- <div id="header"></div> -->
		<tiles:insertAttribute name="header"/><!-- end header  -->
		
		<div id="page">
			<tiles:insertAttribute name="left"/>
			
			<div class="content-page">
				<div class="content">				
					<div class="page-header-title type2">
						<ul class="navi ftcfff">
							<li><span></span>${menu1 }</li><li class='on'><span>></span>${menu2 }</li>
						</ul>
					</div><!-- endcontent_head -->								
					<div class="page-content-wrapper" style="margin-top:0;">
						<div class="container">
						<tiles:insertAttribute name="content"/>		
						</div>
					</div>	
				</div><!-- end content -->
			</div><!-- end content-page -->
		</div><!-- end page -->
		<!-- Container End -->
		
		 <tiles:insertAttribute name="footer"/> 
	</div>
	
	<!-- JS -->

	
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/bootstrapValidator.min.js"></script> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/modernizr.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/detect.js"></script>
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/jquery.slimscroll.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/jquery.blockUI.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/waves.js"></script>
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/jquery.nicescroll.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/jquery.scrollTo.min.js"></script>	
	<script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/bootstrap-select.min.js"></script>	
	<script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/wow.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/fastclick.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/app.js"></script>
	
	
    
    
    
    <!-- 
	<script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/plugin/morris.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/plugin/raphael-min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/bootstrap-dist/js/plugin/dashborad.js"></script>
    -->

	<!-- Plugin -->
    <script src="${pageContext.request.contextPath}/bootstrap-dist/js/plugin/bootstrap-timepicker.js"></script>
    <script src="${pageContext.request.contextPath}/bootstrap-dist/js/plugin/bootstrap-colorpicker.min.js"></script>
    <script src="${pageContext.request.contextPath}/bootstrap-dist/js/plugin/bootstrap-datepicker.min.js"></script>
    <!-- 
    <script src="${pageContext.request.contextPath}/bootstrap-dist/js/plugin/form-advanced.js"></script>
    -->

	<!-- Simple File Input -->
    <script src="${pageContext.request.contextPath}/bootstrap-dist/js/plugin/fileinput.min.js"></script>
 
</body>
</html>


