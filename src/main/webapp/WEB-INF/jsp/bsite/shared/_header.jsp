<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="aBtn" uri="/WEB-INF/authBtn.tld" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<%@include file="_navi.jsp"%>

<script type="text/javascript">
	$(function(){
		
	});
</script>


	<nav class="main-header navbar navbar-expand navbar-navy navbar-light">
		<!-- 상단 죄측 펼침메뉴 버튼 / 검색 -->
		<ul class="navbar-nav">
			<li class="nav-item">
				<a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
			</li>
		</ul>
		<!-- // 상단 죄측 펼침메뉴 버튼 / 검색 -->

		<!-- 상단 우측 마이페이지 로그아웃-->
		<ul class="navbar-nav ml-auto my-info-btn mr-3">
			
			<c:if test="${loginVO.authCode eq '99'}">
				<li class="nav-item mr-2">
					<a class="nav-link" href="${path }/account/login.do">
						<i class="fa fa-user bt" aria-hidden="true"></i><span class="sm_hidden">login</span>
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="${path }/account/join.do" alt="회원가입">
						<i class="fa fa-sign-out-alt" aria-hidden="true"></i><span class="sm_hidden">join</span>
					</a>
				</li>
			</c:if>
		
			<c:if test="${loginVO.authCode ne '99'}">
				<li class="nav-item mr-2">
					<a class="nav-link" href="${path }/myPage/info/read.do">
						<i class="fa fa-user bt" aria-hidden="true"></i><span class="sm_hidden">mypage</span>
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="${path }/account/logout.do" alt="로그아웃">
						<i class="fa fa-sign-out-alt" aria-hidden="true"></i><span class="sm_hidden">logout</span>
					</a>
				</li>
			</c:if>
		</ul>
		<!-- // 상단 우측 마이페이지 로그아웃-->
	</nav>
