<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<script type="text/javascript">
//<![CDATA[
    var path = "${pageContext.request.contextPath }";    
    var errorMsg = "${errorMsg}";
    var goUrl = "${goUrl}";
    var title = "${title}";
    
    console.log("path : " + path);
    console.log("errorMsg : " + errorMsg);
    console.log("goUrl : " + goUrl);
    console.log("title : " + title);

    alert(errorMsg);
	if(title == "cmmDeleteFile"){
		location.href = goUrl;
	}else{
		location.href = path + goUrl;
	}
	

    /* $(document).ready(function() { 
		alert(errorMsg);
		if(title == "cmmDeleteFile"){
			location.href = goUrl;
		}else{
			location.href = path + goUrl;
		}
		
		return false;
    }); */
           
//]]>
</script>

<noscript>
<table class="tbl_List" summary="">
	<caption>에러메시지</caption>
	<colgroup>
		<col width="20%" />
		<col />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="txt.result.message" text="결과 메시지" /></th>
			<td>
				<spring:message code="${errorMsg}" text="" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="txt.re.page" text="페이지 이동" /></th>
			<td>
				<a href="${goUrl}"  class="rbutton navy large"><spring:message code="txt.re.page" text="페이지 이동" /></a>
			</td>
		</tr>
		
	</tbody>
</table>
</noscript>















