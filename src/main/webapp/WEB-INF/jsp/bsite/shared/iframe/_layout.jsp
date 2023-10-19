<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title><tiles:insertAttribute name="title"/></title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/bsite/common.css" /> 

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.10.4/css/jquery-ui.min.css">  
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.cookie.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/script.menutree.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/script.common.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/script.ready.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>

<!-- EASY UI  -->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/icon.css">  
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/custom.css"> 
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/plugins/jquery.numberbox.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/validation.js"></script>
<!-- EASY UI  -->

<style>
	.errorCenter{margin-left:150px;}
	.errorCenter p{text-align:center; margin-top:50px;border:3px solid #5d83df;padding-top:10px;padding-bottom:10px;width:70%;font-size:18px;font-weight:bold;}
	
	 

/***** 게시판 임시 사용 *****/
	 /*Table_list */
    .tbl_List {width:100%;min-width:1080px !important;border-top:1px solid #ccc;border-left:1px solid #ccc; background:#fff;}
	.tbl_List th{border-bottom:1px solid #ccc; border-right:1px solid #ccc; padding:5px 3px; line-height:18px;text-align:center;background:#eee;font-weight:700;letter-spacing:0em;text-overflow:ellipsis;white-space:nowrap;}
	.tbl_List td {border-bottom:1px solid #ccc;border-right:1px solid #ccc; padding:3px; overflow:hidden; line-height:18px;text-overflow:ellipsis;white-space:nowrap;}
	.tbl_List.tc {text-align:center;}
	.tbl_List.tc td{text-align:center; padding:3px;} 
/***** 게시판 임시 사용 *****/	
</style>





</head>

<body>
		<tiles:insertAttribute name="content"/>			
</body>
</html>

