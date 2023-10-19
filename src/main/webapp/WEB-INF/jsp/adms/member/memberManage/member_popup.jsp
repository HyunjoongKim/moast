<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<c:set var="qustr" value="${searchVO.qustr}" />

<script type="text/javascript">
	var path = "${pageContext.request.contextPath }";
	var qustr = "${searchVO.qustr}";
	
	$(function(){
		alertResMsg("${resMap.msg}");
		
		
	});
	
	function fn_go_page(pageNo) {
		$("#pageIndex").val(pageNo);
		$("#listForm").submit();
		return false;
	}
	
	function fn_search(){
		$("#pageIndex").val("1");
		$("#listForm").submit();
		return false;
	}
	
	function fn_delete(meIdx){
		if(!confirm(gTxt("confirm.delete"))) return false;
		
		var submitObj = new Object();
		submitObj.me_idx= meIdx;
		
		$.ajax({ 
	      	  url: path+"/adms/member/memberManage/delete_action.do", 
	      	  type: "POST", 
	      	  contentType: "application/json;charset=UTF-8",
	      	  data:JSON.stringify(submitObj),
	      	  dataType : "json"
	      	 }) 
	      	 .done(function(resMap) {
	      		alert(resMap.msg);
	      		location.reload();
	      	 }) 
	      	 .fail(function(e) {  
	      		 alert("FAIL - "+e);
	      	 }) 
	      	 .always(function() { 
	      		 pass =  false;
	      	 }); 
		
	}

	
</script>

<form:form commandName="searchVO" method="get" name="listForm" id="listForm" action="${path}/adms/member/memberManage/list.do">

	
	<table class="tbl_Search" cellspacing="0" width="100%">
		<td>
			<input type="text" id="searchMeId" name="searchMeId" value="${searchVO.searchMeId }" placeholder="<spring:message code="mb.id" text="아이디" />" />
			<input type="text" id="searchMeName" name="searchMeName" value="${searchVO.searchMeName }" placeholder="<spring:message code="mb.name" text="이름" />"  />
			
			<select name="searchAuthCode" id="searchAuthCode">
				<c:forEach var="result" items="${authList}" varStatus="status">
		       		<option value="${result.auth_code }" ${result.auth_code eq searchVO.searchAuthCode ? 'selected' : ''}>${result.auth_title }</option>
				</c:forEach>
			</select>
			
		</td>
		<td><a href="#" onclick="fn_search();" class="rbutton navy"><spring:message code="btn.search" text="검색" /></a></td>
	</table>


	<div class="bottom_right" style="margin-bottom:5px">
		<a href="${path}/adms/member/memberManage/create.do" class="rbutton blue"><spring:message code="btn.create" text="등록" /></a>
	</div>

	
	<table class="tbl_List tc" width="100%" cellspacing="0">
	<caption>LIST</caption>
		<colgroup>
			<col>
			
			<col>
			<col>
			<col>
			
			<col>
			<col>

			<col width="10%">
			<col width="10%">
		</colgroup>
	<thead>
		<tr>
			<th><spring:message code="mb.no" text="No" /></th>
			
			<th><spring:message code="mb.id" text="아이디" /></th>
			<th><spring:message code="mb.name" text="이름" /></th>
			<th><spring:message code="mb.auth" text="권한" /></th>
			<th><spring:message code="mb.type" text="회원유형" /></th>
			<th><spring:message code="mb.tel" text="연락처" /></th>
			<th><spring:message code="mb.cdate" text="가입일" /></th>
			
			<th></th>
		</tr>
	</thead>
	<tbody>
		<c:set var="ii" value="${resultCnt - (searchVO.pageIndex -1) * paginationInfo.recordCountPerPage }" />
		<c:forEach var="result" items="${resultList}" varStatus="status">
			<tr>
				<td><c:out value="${ii}"/></td>
				
				<td><c:out value="${result.me_id}"/></td>
				<td><c:out value="${result.me_name}"/></td>
				<td><c:out value="${result.auth_name}"/></td>

				<td><c:out value="${result.me_type_nm}"/></td>
				<td><c:out value="${result.me_tel}"/></td>
				<td><c:out value="${result.cret_date}"/></td>
				
				<td>
					<a href="${path}/adms/member/memberManage/update.do?meIdx=${result.me_idx}&${qustr}" class="rbutton xsmall navy"><spring:message code="btn.modify" text="수정" /></a>
					<a href="javascript:void(0);" onclick="fn_delete('${result.me_idx}');return false;" class="rbutton xsmall navy"><spring:message code="btn.delete" text="삭제" /></a>
				</td>
			</tr>
		<c:set var="ii" value="${ii - 1}" />
		</c:forEach>
		
		<c:if test="${fn:length(resultList) == 0}">
			<tr>
				<td colspan="8"><spring:message code="list.noResult" text="No search results found." /></td>
			</tr>
		</c:if>
		</tbody>
	</table>
	
	<div class="boardBottom">
		<div class="bottom_left">
			<span class="f11"><spring:message code="list.totalCnt" text="총 게시물  " />  <fmt:formatNumber value="${resultCnt}" type="number" /> / <spring:message code="list.page" text="페이지 " />(<c:out value="${searchVO.pageIndex}"/>/<c:out value="${totalPageCnt}"/>)</span>
		</div>
		<div class="bottom_right">
			<form:hidden path="pageIndex" />
			<ol class="pagination" id="pagination">
				<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_go_page" />
			</ol>
		</div>
	</div>

</form:form>