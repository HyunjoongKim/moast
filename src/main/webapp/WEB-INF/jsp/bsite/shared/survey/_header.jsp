<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head> 
<meta http-equiv='content-type' content='text/html; charset=UTF-8' >
<meta http-equiv='pragma' content="IE=edge,chrome=1" >
<title>설문시스템</title> 
<!-- 공통 CSS -->
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script> 
<script src="${pageContext.request.contextPath}/js/common.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/highChart/highcharts.js"></script>
<script src="${pageContext.request.contextPath}/js/highChart/modules/exporting.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/bsite/survey/sv_common.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/bsite/survey/sv_layout.css">