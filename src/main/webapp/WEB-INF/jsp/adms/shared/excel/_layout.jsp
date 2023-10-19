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
	<title>test excel</title>

</head>
<body>

<%
 String rFileName = request.getAttribute("filename").toString();

 response.setHeader("Content-Disposition", "attachment; filename="+rFileName+".xls");
 response.setHeader("Content-Description", "JSP Generated Data");
 response.setContentType("application/vnd.ms-excel");
 

%>
	
		<tiles:insertAttribute name="content"/>
	
	
	
</body>
</html>

