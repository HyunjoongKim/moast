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
	
	//============= return option parameter ================
	var isPopup ="${searchVO.isPopup}";
	var res_idx_id ="${searchVO.res_idx_id}";
	var res_title_id ="${searchVO.res_title_id}";
	//============= return option parameter ================
	
	$(function(){
		alertResMsg(gTxt("${resMap.msg}"));
		
		
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
	/* 
	function selectItem(me_id,me_name,me_name_ori, me_enname){	
		alert(res_title_id);
		$("#"+res_idx_id, opener.document).val(me_id);
		$("#"+res_title_id, opener.document).val(me_name); 
		window.close();
		return false; 
	} */
	
	function selectItem(me_id,me_name,me_name_ori, me_enname){	
		var trIdx = "${searchVO.trIdx}";
		if(res_idx_id == "" && res_title_id == ""){
			window.opener.setMember(trIdx, me_name_ori, me_enname, me_id);
		}else{
			if(trIdx==""){
				$("#"+res_idx_id, opener.document).val(me_id);
				$("#"+res_title_id, opener.document).val(me_name);
			}else{
				$(opener.document).find("tr:eq("+trIdx+")").find("input[name='"+res_idx_id+"']").val(me_id);
			}
		}
		
		
		window.close();
		return false; 
	}
	 
</script> 

<form:form commandName="searchVO" method="get" name="listForm" id="listForm" action="${path}/cmm/member/memberManage/list.do" class="form-inline">
<input type="hidden" id="isPopup" name="isPopup" value="${searchVO.isPopup}"  />
<input type="hidden" id="res_idx_id" name="res_idx_id" value="${searchVO.res_idx_id}"  />
<input type="hidden" id="res_title_id" name="res_title_id" value="${searchVO.res_title_id}"  />
<input type="hidden" id="trIdx" name="trIdx" value="${searchVO.trIdx}"  />
<div class="panel">
	<div class="panel-body">
		<div class="form-inline">
			<div class="form-group"> 
				<label class="sr-only" for="searchMeId"><spring:message code="mb.id" text="아이디" /></label> 
				<input type="text" id="searchMeId" name="searchMeId" value="${searchVO.searchMeId }" placeholder="<spring:message code="mb.id" text="아이디" />" class="form-control"/>
			</div>
			
			<div class="form-group m-l-10"> 
				<label class="sr-only" for="searchMeName"><spring:message code="mb.name" text="이름" /></label> 
				<input type="text" id="searchMeName" name="searchMeName" value="${searchVO.searchMeName }" placeholder="<spring:message code="mb.name" text="이름" />"  class="form-control"/>
			</div>
			
			<div class="form-group m-l-10"> 
				<label class="sr-only" for="searchAuthCode"><spring:message code="mb.auth" text="권한" /><spring:message code="btn.select" text="선택" /></label> 
				<select name="searchAuthCode" id="searchAuthCode" class="form-control">
					<option value=""><spring:message code="mb.auth" text="권한" /><spring:message code="btn.select" text="선택" /></option>
					<c:forEach var="result" items="${authList}" varStatus="status">
			       		<option value="${result.auth_code }" ${result.auth_code eq searchVO.searchAuthCode ? 'selected' : ''}>${result.auth_title }</option>
					</c:forEach>
				</select>
			</div>
			<div class="form-group">
				<label class="control-label" for=""><spring:message code="mb.type" text="회원유형" /></label>
				<select name="searchMeType" id="searchMeType"  class="form-control" />
					<option value=""><spring:message code="mb.type" text="회원유형" /></option>
					<c:forEach var="result" items="${memTypeList}" varStatus="status">
			       		<option value="${result.main_code }" ${result.main_code eq searchVO.searchMeType ? 'selected' : ''}>${result.code_name }</option>
					</c:forEach>
				</select>
				
			</div>
			
			<div class="form-group m-l-10"> 
				<a href="#" onclick="fn_search();" class="btn btn-dark" style="height:38px"><spring:message code="btn.search" text="검색" /></a>
			</div>
		</div>
	</div>
</div>
<form:hidden path="pageIndex" />
</form:form>
<table id="datatable-scroller" class="table table-striped table-bordered text-center" width="100%" cellspacing="0">
<caption>LIST</caption>
	<colgroup>
		<col>
		<col>
		<col>
		<col>	
		<col>
		<col>
		<col>
	</colgroup>
<thead>
	<tr>
		<th><spring:message code="mb.no" text="No" /></th>
		<th><spring:message code="mb.id" text="아이디" /></th>
		<th><spring:message code="mb.name" text="이름" /></th>
		<th><spring:message code="mb.auth" text="권한" /></th>
		<th><spring:message code="mb.type" text="회원유형" /></th>
		<th><spring:message code="mb.tel" text="연락처" /></th>			
		<th><spring:message code="btn.select" text="선택" /></th>
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
			<td>
				<a href="javascript:void(0);" onclick="return selectItem('${result.me_id}','${result.auth_name} (${result.me_name})','${result.me_name}','${result.me_enname}'); return false;" class="btn btn-success btn-sm"><spring:message code="btn.select" text="선택" /></a>
			</td>
		</tr>
	<c:set var="ii" value="${ii - 1}" />
	</c:forEach>
	
	<c:if test="${fn:length(resultList) == 0}">
		<tr>
			<td colspan="7"><spring:message code="list.noResult" text="No search results found." /></td>
		</tr>
	</c:if>
	</tbody>
</table>

<div class="pull-left mt10">
	<span class="f11"><spring:message code="list.totalCnt" text="총 게시물  " />  <fmt:formatNumber value="${resultCnt}" type="number" /> / <spring:message code="list.page" text="페이지 " />(<c:out value="${searchVO.pageIndex}"/>/<c:out value="${totalPageCnt}"/>)</span>
</div>
<div class="pull-right">
	
	<ol class="pagination" id="pagination">
		<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_go_page" />
	</ol>
</div>
<div class="clearfix"></div>

