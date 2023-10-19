<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<div id="content-table-inner">  
<h1><font color="orange">Error</font></h1>
 <center class="errorCenter">
       <p>
        <font color="orange">${errorMsg} <br/>
        <!-- <a href="javascript:history.go(-1);">뒤로</a> -->
        <a href="${pageContext.request.contextPath}/"><font color="#F5F6CE"><spring:message code="txt.goHome" text="홈으로 이동" /></font></a> <font color="orange">/</font>
        <a href="${pageContext.request.contextPath}/account/logout.do"><font color="#F2F2F2"><spring:message code="txt.logout" text="로그아웃" /></font></a>
       </p>
  </center> 
</div>  <!--  // content-table-inner -->























