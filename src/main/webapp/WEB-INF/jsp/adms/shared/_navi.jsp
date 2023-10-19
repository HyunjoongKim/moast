<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<c:set var="nowPageUrl" value="${requestScope['javax.servlet.forward.servlet_path']}" />
<c:if test="${fn:contains(nowPageUrl, '/adms/common/site/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.site"  /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.site.manage" /></c:set> 
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/member/authManage/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.site" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.auth.manage" /></c:set> 
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/common/menu/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.site" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.menu.manage" /></c:set> 
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/member/memberManage/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.member.manage" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.member.manage" /></c:set> 
</c:if>

<!--  =================================  자원관설정  ====================================  -->
<c:if test="${fn:contains(nowPageUrl, '/adms/common/department/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.nnibr" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.nnibr.dept" /></c:set> 
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/common/taxon/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.nnibr" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.nnibr.taxon" /></c:set> 
</c:if>

<!--  =================================  자원관 설정  ====================================  -->


<!--  =================================  코드 관리  ====================================  -->
<c:if test="${fn:contains(nowPageUrl, '/adms/common/code/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.code" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.code.common" /></c:set> 
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/common/collection/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.code" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.code.place" /></c:set> 
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/common/resources/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.code" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.code.res" /></c:set>
</c:if>
<!--  =================================  코드 관리  ====================================  -->

<c:if test="${fn:contains(nowPageUrl, '/adms/board/boardManage/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.board.manage" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.board.manage" /></c:set>
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/contents/popup/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.contents" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.contents.popup" /></c:set>
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/contents/banner/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.contents" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.contents.banner" /></c:set>
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/survey/')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.survey.manage" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.survey.manage" /></c:set>
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/zboard/') && param.lmCode eq 'content1'}"> 
	<c:set var="menu1">컨텐츠관리</c:set> 
	<c:set var="menu2">컨텐츠관리</c:set>
</c:if>

<c:if test="${fn:contains(nowPageUrl, '/zcal/act/')}"> 
	<c:set var="menu1">컨텐츠관리 ${param.lmCode}</c:set> 
	<c:set var="menu2">일정관리</c:set>
</c:if>


<!--  =================================  로그 관리  ===============================  -->
<c:if test="${fn:contains(nowPageUrl, '/adms/common/log/list')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.manage" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.manage.dashboard" /></c:set>
</c:if>

<c:if test="${fn:contains(nowPageUrl, '/adms/common/menulog/list')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.log" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.log.menu" /></c:set>
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/common/sitelog/month_list')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.log" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.log.month" /></c:set>
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/common/sitelog/days_list')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.log" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.log.days" /></c:set>
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/common/sitelog/time_list')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.log" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.log.time" /></c:set>
</c:if>
<c:if test="${fn:contains(nowPageUrl, '/adms/common/adminlog/list')}"> 
	<c:set var="menu1"><spring:message code="sysmenu.log" /></c:set> 
	<c:set var="menu2"><spring:message code="sysmenu.log.admin" /></c:set>
</c:if>

<!--  =================================  로그 관리  ===============================  -->












