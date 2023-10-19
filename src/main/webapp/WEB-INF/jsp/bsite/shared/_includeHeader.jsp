<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="_navi.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!-- Title 설정 -->
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>다중오믹스 생물정보플랫폼</title>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="${path }/dist/css/font.css"><!-- font -->
<link rel="stylesheet" href="${path }/dist/css/all.min.css"><!-- icon -->
<link rel="stylesheet" href="${path }/dist/css/ionicons/ionicons.min.css"><!-- icon -->

<link rel="stylesheet" href="${path }/dist/css/style.css">
<link rel="stylesheet" href="${path }/dist/css/adminlte.min.css">

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
<script src="${path }/dist/js/bootstrap.bundle.min.js"></script>
<script src="${path }/dist/js/adminlte.js"></script>
<script src="${path }/js/common.js"></script>

	
<style>
	.initHide {display: none;}
	.initHideT {display: none;}
</style>
 
<script type="text/javascript">
//<![CDATA[
	$(document).ready(function() {
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
		
		
		mthoptions = {
			startYear :  1900,
		    pattern: 'yyyy-mm', 
		    monthNames: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12']
		};
	});
//]]>
</script>

