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
	      		alert(gTxt(resMap.msg));
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
	<div class="panel">
		<div class="panel-body">
			<div class="form-inline" >
				<div class="form-group">
					<label class="control-label" for=""><spring:message code="mb.auth" text="권한" /></label>
					<select name="searchAuthCode" id="searchAuthCode" class="form-control" >
						<option value=""><spring:message code="mb.auth" text="권한" /></option>
						<c:forEach var="result" items="${authList}" varStatus="status">
				       		<option value="${result.auth_code }" ${result.auth_code eq searchVO.searchAuthCode ? 'selected' : ''}>${result.auth_title }</option>
						</c:forEach>
					</select>
				</div>
				<div class="form-group m-l-10">
					<label class="control-label" for=""><spring:message code="mb.id" text="아이디" /></label>
					<input type="text" id="searchMeId" name="searchMeId" value="${searchVO.searchMeId }" placeholder="<spring:message code="mb.id" text="아이디" />" style="width:300px" class="form-control"  />
				</div>
				<div class="form-group m-l-10">
					<label class="control-label" for=""><spring:message code="mb.name" text="이름" /></label>
					<input type="text" id="searchMeName" name="searchMeName" value="${searchVO.searchMeName }" placeholder="<spring:message code="mb.name" text="이름" />" style="width:300px" class="form-control"  />
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
					<a href="#" onclick="fn_search();" class="btn btn-dark" style="height:36px;"><spring:message code="btn.search" text="검색" /></a>
				</div>
			</div>
		</div>
	</div>

	<div class="panel">
		<div class="panel-body">
			<h4 class="mt0"><i class="fa fa-cube" aria-hidden="true"></i> <spring:message code="sysmenu.member.manage" text="회원관리" /></h4>
			<div class="table-responsive">
				<table id="datatable-scroller" class="table table-striped table-bordered text-center">
					<caption>LIST</caption>
					<colgroup>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col width="15%">
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
								<a href="${path}/adms/member/memberManage/update.do?meIdx=${result.me_idx}&${qustr}" class="btn btn-success btn-sm"><spring:message code="btn.modify" text="수정" /></a>
								<a href="javascript:void(0);" onclick="fn_delete('${result.me_idx}');return false;" class="btn btn-danger btn-sm"><spring:message code="btn.delete" text="삭제" /></a>
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
			</div>
				
			<div class="pull-left mt10">
				<span><spring:message code="list.totalCnt" text="총 게시물  " />  <fmt:formatNumber value="${resultCnt}" type="number" /> / <spring:message code="list.page" text="페이지 " />(<c:out value="${searchVO.pageIndex}"/>/<c:out value="${totalPageCnt}"/>)</span>
			</div>
			<div class="pull-right">
				<form:hidden path="pageIndex" />
				<ol class="pagination" id="pagination">
					<ui:pagination paginationInfo="${paginationInfo}" type="image" jsFunction="fn_go_page" />
				</ol>
			</div>
			<div class="clearfix"></div>
		</div>
	</div><!--  end panel -->
		
	<div class="pull-right">
		<div class="btn-group dropup">
			<a href="${path}/adms/member/memberManage/create.do" class="btn btn btn-primary btn-lg"><spring:message code="btn.create" text="등록" /></a>
		</div>
	</div>
	<div class="clearfix"></div>
</form:form>