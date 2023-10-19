<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="_navi.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!doctype html>
<html lang="ko">
<head>

<%@ include file="/WEB-INF/jsp/bsite/shared/_includeHeader.jsp" %>

</head>

<body class="hold-transition sidebar-mini layout-fixed">

<div class="wrapper">

	<!-- Navbar: 상단 메뉴 -->
	<tiles:insertAttribute name="header"/>
	<!-- // Navbar : 상단 메뉴 -->
	
	<!-- Main Sidebar Container : 좌측 메뉴 바 -->
	<tiles:insertAttribute name="left"/>
	<!-- // Main Sidebar Container : 좌측 메뉴 바 -->


	<!-- Content Wrapper. Contains page content -->
	<div class="content-wrapper">

		<!-- Main content -->
		<section class="content pt-4 pb-4 pl-3 pr-3">
			<div class="container-fluid">

				<%-- <tiles:insertAttribute name="subVisual"/> --%>
			
				<tiles:insertAttribute name="content"/>			
	
			</div><!-- /.container-fluid -->
		</section><!-- /.content -->
	</div>
	<!-- /.content-wrapper -->
	
	<!-- footer part -->
	<tiles:insertAttribute name="footer"/>

</div>
<!-- //wrapper -->


	
</body>
</html>

