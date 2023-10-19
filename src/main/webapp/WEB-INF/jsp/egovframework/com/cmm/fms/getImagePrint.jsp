<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%


%>
<!-- link href="<c:url value='/css/egovframework/com/cmm/com.css' />" rel="stylesheet" type="text/css"-->

<script type="text/javascript">

	
</script>


<c:forEach var="fileVO" items="${fileList}" varStatus="status">
	<c:set var="FileExtention" value="${fn:toLowerCase(fileVO.fileExtsn)}" />
	<c:set var="IsImage" value="0"  />
		<c:if test="${FileExtention eq 'jpg' || FileExtention eq 'jpeg' || FileExtention eq 'bmp' || FileExtention eq 'png' || FileExtention eq 'gif'}" >
			<c:set var="IsImage" value="1"  />
		</c:if>
	
	<c:if test="${IsImage eq '1' }">
		<c:set var="rFile" value="${pageContext.request.contextPath}/cmm/fms/getImagePrintFlush.do?param_atchFileId=${fileVO.atchFileId}&fileSn=${fileVO.fileSn}" />
		<img src="${rFile}" alt="게시판 본문의 첨부파일 이미지입니다. : ${fileVO.orignlFileNm}" /> <br/><br/>
	</c:if>
	
</c:forEach>