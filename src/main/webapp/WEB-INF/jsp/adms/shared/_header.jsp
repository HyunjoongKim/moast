<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

			<!-- Top -->
			<div class="topbar">
                <!-- 로고 -->
				<div class="topbar-left">
                    <div class="text-center">
                        <h1>
							<%-- <a href="${path }" class="logo"><img src="${pageContext.request.contextPath}/bootstrap-dist/images/page-logo-sys.png" alt=""></a>
							<a href="${path }" class="logo-sm"><img src="${pageContext.request.contextPath}/bootstrap-dist/images/page-logo-sys-sm.png" alt=""></a> --%>
							<a href="${path }" class="logo"><img src="${pageContext.request.contextPath}/img/common/logo.gif" alt="multiomics" /> </a>
							<a href="${path }" class="logo-sm"><img src="${pageContext.request.contextPath}/img/common/logo2.gif" alt="multiomics" /></a>
						</h1>
                    </div>
                </div>
				<!-- //로고 -->

				<!-- 상단 네비바 -->
                <div class="navbar navbar-default" role="navigation">
                    <div class="container">
                        <div class="">
                            <!-- 햄버거 메뉴 -->
							<div class="pull-left">
                                <button type="button" class="button-menu-mobile open-left waves-effect waves-light">
                                    <i class="glyphicon glyphicon-align-left" style="font-size:20px;top:-1px"></i>
                                </button>
                                <span class="clearfix"></span>
							</div>
							<!-- //햄버거 메뉴 -->
							
							<!-- 검색 폼 -->
							<!-- 
							<form class="navbar-form pull-left" role="search">
								<div class="form-group">
									<input type="text" class="form-control search-bar" placeholder="Search..." style="width:300px">
								</div>
								<button type="submit" class="btn btn-search">
									<i class="glyphicon glyphicon-search"></i>
								</button>
							</form>
							-->
							<!-- //검색 폼 -->
                        </div>
                        
                        <div class="pull-right lang">							
							<c:if test="${locale eq 'ko' || locale eq 'ko_KR'}">
								<a href="${path}/?lang=en"class="button-menu-mobile open-left waves-effect waves-light">
									<i class="icon-eng"></i>
								</a>
							</c:if>
							<c:if test="${locale eq 'en' }">
								<a href="${path}/?lang=ko" class="button-menu-mobile open-left waves-effect waves-light">
									<i class="icon-kor"></i>
								</a>
							</c:if>
						</div>
						
                    </div>
                </div>
				<!-- //상단 네비바 -->
            </div>
            <!-- //Top -->

<!-- 
<div id="topgnb">
	<h1 class="logo"><a href="javascript:void(0);"><img src="${pageContext.request.contextPath}/img/sub_logo.png" alt="" /></a></h1>
	<ul class="topNavi">
		<li class="admin"><a href="javascript:void(0);">${loginVO.name}</a></li>
		<%--<li class="pw"><a href="${pageContext.request.contextPath}/" target="_blank">홈페이지</a></li> --%>
		<c:if test="${loginVO.authCode ne '99'}"> 
		<li class="logout"><a href="${pageContext.request.contextPath}/account/logout.do">로그아웃</a></li>
		</c:if>
	</ul>	
</div>
-->

<!--div id="sidebar-collapse" class="sidebar-collapse btn">
	<i class="fa fa-bars icon-reorder pull-left"></i>
</div-->